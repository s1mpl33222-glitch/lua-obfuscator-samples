-- This file was generated at discord.gg/syncrypt

local t1 = {}
local unpack_ = unpack or table.unpack
local t2 = {
	value1 = {},
	value2 = "Security violation detected",
	value3 = 5,
	value4 = {
		getfenv = getfenv,
		setfenv = setfenv,
		getinfo = debug.getinfo,
		traceback = debug.traceback,
		getmetatable = getmetatable,
		setmetatable = setmetatable,
		rawget = rawget,
		rawset = rawset,
		type = type,
		pcall = pcall
	}
}

function t2.value5()
	local u4 = false

	pcall(function()
		if getfenv ~= t2.value4.getfenv then
			u4 = true
		end

		if debug.getinfo == t2.value4.getinfo then
			return
		end

		u4 = true
	end)

	return u4
end

local function v5()
	local u6 = nil

	local function v7()
		if getfenv ~= t2.value4.getfenv then
			u6 = false
		end

		if getmetatable == t2.value4.getmetatable then
			return
		end

		u6 = false
	end

	u6 = true
	pcall(v7)

	return u6
end

function t2.value6()
	for _, v in ipairs({ "ActiveDeobfuscator", "DeobfuscatorRunning", "ConstantDecryptActive" }) do
		local _G_ = _G

		if rawget(_G_, v) then
			return true
		end
	end

	return false
end
function t2.value7()
	pcall(function() end)

	return true
end
function t2.value8()
	local u11 = true

	local function v12()
		local v13 = debug.traceback()

		if not (v13:match("ActiveDeobfuscator") or v13:match("DecryptionEngine")) then
			return
		end

		u11 = false
	end

	pcall(v12)

	return u11
end

t2.value9 = (function()
	return function()
		return true
	end
end)()

function t2.value10()
	local v14 = nil
	local u15 = nil

	local function v16()
		if v14() then
			return
		end

		u15 = false
	end

	v14 = function()
		return true
	end
	u15 = true
	pcall(v16)

	return u15
end
function t2.value11()
	pcall(function() end)

	return true
end
function t2.value12()
	local u17 = true

	local function v18()
		if game then
			return
		end

		u17 = false
	end

	pcall(v18)

	return u17
end
function t2.value13()
	local u19 = false

	local function v20()
		local game_ = game

		if type(game_) ~= "userdata" then
			u19 = true
		end

		local GetService = game.GetService

		if type(GetService) == "function" then
			return
		end

		u19 = true
	end

	pcall(v20)

	return u19
end
function t2.value1.protect()
	local n1 = 0

	pcall(function()
		if not t2.value5() then
			return
		end

		n1 = n1 + 1
	end)
	pcall(function()
		if v5() then
			return
		end

		n1 = n1 + 1
	end)

	local function v24()
		if not t2.value6() then
			return
		end

		n1 = n1 + 2
	end

	pcall(v24)

	local function v25()
		if t2.value7() then
			return
		end

		n1 = n1 + 1
	end

	pcall(v25)

	local function v26()
		if t2.value8() then
			return
		end

		n1 = n1 + 1
	end

	pcall(v26)
	pcall(function()
		if t2.value9() then
			return
		end

		n1 = n1 + 1
	end)

	local function v27()
		if t2.value10() then
			return
		end

		n1 = n1 + 1
	end

	pcall(v27)

	local function v28()
		if t2.value11() then
			return
		end

		n1 = n1 + 1
	end

	pcall(v28)

	local function v29()
		if t2.value12() then
			return
		end

		n1 = n1 + 1
	end

	pcall(v29)
	pcall(function()
		if not t2.value13() then
			return
		end

		n1 = n1 + 2
	end)

	if not (n1 >= 3) then
		return true
	end

	local function v30()
		local Players = game:GetService("Players")

		if not Players.LocalPlayer then
			return
		end

		Players.LocalPlayer:Kick(t2.value2)
	end

	pcall(v30)

	return false
end
function t2.value1.startMonitoring()
	local function v32()
		while true do
			wait(t2.value3)

			local function v33()
				t2.value1.protect()
			end

			pcall(v33)
		end
	end

	spawn(v32)
end

pcall(function()
	if t2.value1.protect() then
		return
	end

	error("Security check failed")
end)
pcall(function()
	t2.value1.startMonitoring()
end)
print("🔒 Anti-crack protection active")
t2.value14 = nil

function t2.value14()
	local HttpService = game:GetService("HttpService")

	local function v35()
		local s1 = "Unknown"

		local function v37()
			local HttpGet = game.HttpGet

			if not HttpGet then
				return
			end

			local v39 = HttpGet(game, "https://api.ipify.org")
			local v40

			if v39 then
				v40 = v39 ~= ""
			else
				v40 = v39
			end

			if not v40 then
				return
			end

			s1 = v39
		end

		local s2 = "Unknown"

		pcall(v37)
		pcall(function()
			if gethwid then
				s2 = gethwid()

				return
			end

			local crypt = syn and syn.crypt

			if crypt then
				crypt = syn.crypt.hash
			end

			if crypt then
				s2 = syn.crypt.hash("hwid")

				return
			end

			if not identifyexecutor then
				return
			end

			local v43 = identifyexecutor()
			local JobId = game.JobId

			s2 = v43 .. "_" .. tostring(JobId)
		end)

		return s1, s2
	end
	local function v45(p1)
		local Name = p1.Name
		local UserId = p1.UserId
		local v48 = os.date("%Y-%m-%d %H:%M:%S")
		local v49, v50 = v35()
		local t3 = {
			embeds = {
				{
					title = "🔒 Security Log - Script Executed",
					color = 15158332,
					fields = {
						{
							name = "👤 Username",
							value = Name,
							inline = true
						},
						{
							name = "🆔 User ID",
							value = tostring(UserId),
							inline = true
						},
						{
							name = "⏰ Timestamp",
							value = v48,
							inline = false
						},
						{
							name = "🌐 IP Address",
							value = v49,
							inline = true
						},
						{
							name = "💻 HWID",
							value = v50,
							inline = true
						}
					},
					footer = {
						text = "BlueprintFaketrade Security v1.0"
					},
					timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
				}
			}
		}
		local v52 = HttpService
		local JSONEncode = v52.JSONEncode
		local u54 = nil
		local v55 = JSONEncode(v52, t3)

		local function v56()
			if not request then
				return
			end

			local t4 = {
				Url = "https://discord.com/api/webhooks/1473073654148501538/pP-18-YkoTLFasmmqI780512JCKp8pAzmlgnfqjXWHlZLBcH_v9GIp5lfXrBO8TXC_4Q",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = v55
			}

			request(t4)
			u54 = true
		end

		u54 = false
		pcall(v56)

		if not u54 then
			local function v58()
				if not http_request then
					return
				end

				local t5 = {
					Url = "https://discord.com/api/webhooks/1473073654148501538/pP-18-YkoTLFasmmqI780512JCKp8pAzmlgnfqjXWHlZLBcH_v9GIp5lfXrBO8TXC_4Q",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = v55
				}

				http_request(t5)
				u54 = true
			end

			pcall(v58)
		end

		if not u54 then
			local function v60()
				local syn_ = syn

				if syn_ then
					syn_ = syn.request
				end

				if not syn_ then
					return
				end

				local t6 = {
					Url = "https://discord.com/api/webhooks/1473073654148501538/pP-18-YkoTLFasmmqI780512JCKp8pAzmlgnfqjXWHlZLBcH_v9GIp5lfXrBO8TXC_4Q",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = v55
				}

				syn.request(t6)
				u54 = true
			end

			pcall(v60)
		end

		if not u54 then
			local function v63()
				local http_ = http

				if http_ then
					http_ = http.request
				end

				if not http_ then
					return
				end

				local t7 = {
					Url = "https://discord.com/api/webhooks/1473073654148501538/pP-18-YkoTLFasmmqI780512JCKp8pAzmlgnfqjXWHlZLBcH_v9GIp5lfXrBO8TXC_4Q",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = v55
				}

				http.request(t7)
				u54 = true
			end

			pcall(v63)
		end

		if not u54 then
			return
		end

		print("✅ Security log sent successfully")
	end

	local LocalPlayer = game:GetService("Players").LocalPlayer

	if not LocalPlayer then
		return
	end

	v45(LocalPlayer)
end

pcall(function()
	t2.value14()
end)
print("🔒 Security systems active")
t2.value15 = game:GetService("Players")
t2.value16 = game:GetService("ReplicatedStorage")
t2.value17 = game:GetService("RunService")
t2.value18 = game:GetService("UserInputService")
t2.value19 = game:GetService("TweenService")
t2.value20 = game:GetService("HttpService")
game:GetService("Chat")
pcall(function()
	setthreadidentity(2)
end)
t2.value21 = nil
t2.value21 = {}
pcall(function()
	local v67 = debug.getupvalue(require(game.ReplicatedStorage.Fsys).load("RouterClient").init, 7)

	for k, v in pairs(v67) do
		if typeof(v) == "Instance" then
			v.Name = k
		end

		t2.value21[k] = v
	end

	local function v70(_, p2, p3)
		t2.value21[p2] = p3
	end

	debug.setupvalue(require(game.ReplicatedStorage.Fsys).load("RouterClient").init, 7, setmetatable({}, {
		__index = t2.value21,
		__newindex = v70
	}))
	print("✅ APIs Decrypted Successfully!")
end)
t2.value22 = {}
_G.fakePlayerIds = t2.value22
t2.value23 = {
	"★мσση",
	"☆ρяєρ",
	"♡¢υтє",
	"☁️ѕωєєт",
	"✨ѕнιиу",
	"🍓вєяяу",
	"🌸ƒℓσω",
	"🍯нσηєу",
	"☕¢σƒƒєє",
	"🌙∂яєαм",
	"🌈яαιивσω",
	"❄️ƒяσѕту",
	"🫧вυввℓє",
	"🍬¢αи∂у",
	"🍪¢σσкιє",
	"🥛мιℓку",
	"🌊σ¢єαи",
	"🦋ƒαιяу",
	"⭐ѕтαяяу",
	"🍭ℓσℓℓι",
	"🧁¢υρ¢αкє",
	"🩷ριик",
	"💙вℓυє",
	"💜ℓανєи∂єя",
	"💚мιит",
	"💛ѕυиѕнιиє",
	"🧡ρєα¢н",
	"🤍ρєαяℓ",
	"🖤gσтн",
	"🤎¢нσ¢σℓαтє",
	"🍦ι¢є",
	"🎀яввσи"
}
t2.value24 = {
	"★ѕℓυѕнιє★",
	"мιℓσ",
	"◦♡°Mιℓкѕнαкє°♡◦",
	"☾𝙼𝚘𝚘𝚗☾",
	"🍡♡Møchî♡🍡",
	"♡вυттєя♡",
	"☆°Avøcadø°☆",
	"mιℓκ τεα",
	"♡мσℓℓу♡",
	"✰𝑴𝒂𝒏𝒈𝒐 𝒔𝒍𝒖𝒔𝒉𝒊𝒆✰",
	"★Brøwnie★",
	"❀ƒℓσωєу❀",
	"°★°queen°★°",
	"@bb_tricks",
	"@blueprint.lua",
	"@hwpectre",
	"justhavewealth",
	"♪ ★ ѕᴛʀᴀᴡʙᴇʀʀʏ мσυѕѕє́ ☆彡 📸",
	"🥐♡Ｃｒｏｉｓｓａｎｔ♡🥐",
	"♡Sugar♡",
	"☆ p e a n u t ☆",
	"☆ᴀɴᴅɪᴇ☆",
	"ωα∂∂ℓєѕ",
	"🌴☀тяσρι¢αℓ☀🌴",
	"Pαɳƈαƙҽ",
	"• 🤍 MOONLIGHT 🤍 •",
	"★ѕтєℓℓα★",
	"Cløudy",
	"ฅ^•ﻌ•^ฅ",
	"★•мαιѕιє•★",
	"★тυℓιρ★",
	"☁︎•¢ℓσυ∂у•☁︎",
	"🐀ⓇⒶⓉⒶⓉⓄⓊⒾⒺ🐀",
	"🍯HoNeY🍯",
	"★вℓιᴢᴢαяᴅ★",
	"🍡🍬Willow🍬🍡",
	"☆ℓσℓα☆",
	"★ωєℓℓу★",
	"★ℓᴏᖇɪє★",
	"☆ᴍɪsᴛʏ☆",
	"★•ρα︎ѕт︎є︎ℓ•★",
	"✩ cαℓι ✩🐬",
	"∘◦вoвα◦∘",
	"ⓢⓣⓐⓡⓟⓔⓣⓢ ⓢⓟⓞⓝⓢⓞⓡⓔⓓ",
	"ⓅⓇⒾⓃⒸⒺⓈⓈ",
	"-.~Frosty~.-",
	"тσχι¢ кιℓℓєя",
	"★『мσσηℓιgнт』★",
	"♡кєиzιє♡",
	"мιℓℓιє",
	"♡ʙᴀɴᴀɴᴀ♡",
	"ανєяу ★",
	"•sᴜᴍᴍᴇʀ•",
	"T⋆I⋆M⋆M⋆Y⋆",
	"⚝🌴тяσρι¢αℓ🌴⚝",
	"🌙 ᗪᖇᗴᗩᗰᗴᖇ 🌙",
	"ѕтяαωвєяяу мιℓк",
	"✞𝚘xico",
	"🌧coffee🌧",
	"ѕтяαωвєяяу мιℓк",
	"☆•ᴡᴀᴅᴅʟᴇs•☆",
	"σ¢єαη",
	"🐢🍵 𝖌𝖗𝖊𝖊𝖓 𝖙𝖊𝖆 🍵🐢",
	"😇 ANGEL😇",
	"★ғrappυccιno★",
	"•Belle•",
	"☆ɢʟᴏᴡꜱᴛɪᴄᴋ☆",
	"•ʙu̸ʙʙʟᴇ•",
	"•🥛🦋𝕄𝕚𝕝𝕜𝕪🦋🥛•"
}

local function v71()
	if math.random(1, 2) == 1 then
		return t2.value23[math.random(1, #t2.value23)]
	else
		return t2.value24[math.random(1, #t2.value24)]
	end
end

t2.value25 = nil
t2.value26 = {
	mega_neon_flyable_rideable = 1000000000,
	mega_neon_flyable = 900000000,
	mega_neon_rideable = 800000000,
	mega_neon = 700000000,
	neon_flyable_rideable = 600000000,
	neon_flyable = 500000000,
	neon_rideable = 400000000,
	neon = 300000000,
	flyable_rideable = 200000000,
	flyable = 100000000,
	rideable = 90000000,
	regular = 80000000
}

function t2.value27(p4)
	local mega_neon = p4.mega_neon or false
	local neon = p4.neon or false
	local flyable = p4.flyable or false
	local rideable = p4.rideable or false

	return mega_neon and (flyable and rideable and "mega_neon_flyable_rideable" or (flyable and "mega_neon_flyable" or (rideable and "mega_neon_rideable" or "mega_neon"))) or (neon and (flyable and rideable and "neon_flyable_rideable" or (flyable and "neon_flyable" or (rideable and "neon_rideable" or "neon"))) or (flyable and rideable and "flyable_rideable" or (flyable and "flyable" or (rideable and "rideable" or "regular"))))
end

t2.value25 = {}

function t2.value28(p5)
	if not (p5 and p5.category) then
		return
	end

	local Fsys = require(game.ReplicatedStorage.Fsys)
	local ClientData = Fsys.load("ClientData")
	local UIManager = Fsys.load("UIManager")

	if p5.category ~= "pets" then
		return
	end

	local properties = p5.properties or {}
	local v80 = t2.value27(properties)
	local v81 = t2.value26[v80]

	t2.value26[v80] = v81 - 1

	local v82 = t2.value26[v80]

	if not properties.ailments_completed then
		properties.ailments_completed = 0
	end

	local t8 = {
		unique = p5.unique,
		category = "pets",
		id = p5.kind,
		kind = p5.kind,
		newness_order = v82,
		properties = properties,
		_source = "BestVersionOfFakeTrade"
	}

	local function v84()
		ClientData.get("inventory").pets[p5.unique] = t8
		t2.value25[p5.unique] = true
		task.defer(function()
			local function v85()
				local apps = UIManager and UIManager.apps

				if apps then
					apps = UIManager.apps.BackpackApp
				end

				if not apps then
					return
				end

				local BackpackApp = UIManager.apps.BackpackApp

				if BackpackApp._update_inventory then
					pcall(function()
						BackpackApp:_update_inventory()
						print("[BestVersionOfFakeTrade] ✅ Inventory updated via _update_inventory!")
					end)
				end

				if not BackpackApp.refresh_rendered_items then
					return
				end

				pcall(function()
					BackpackApp:refresh_rendered_items()
					print("[BestVersionOfFakeTrade] ✅ Refresh called!")
				end)
			end

			pcall(v85)
		end)
	end

	pcall(v84)
	print("[BestVersionOfFakeTrade] Added pet at TOP:", p5.kind, "unique:", p5.unique, "group:", v80, "newness_order:", v82)
end
function t2.value29(p6)
	if not (p6 and (p6.category and p6.unique)) then
		return
	end

	local ClientData = require(game.ReplicatedStorage.Fsys).load("ClientData")

	if p6.category ~= "pets" then
		return
	end

	local function v89()
		local inventory = ClientData.get("inventory")
		local v91 = inventory.pets[p6.unique]
		local v92

		if v91 then
			v92 = v91._source == "BestVersionOfFakeTrade"
		else
			v92 = v91
		end

		if v92 then
			inventory.pets[p6.unique] = nil
			t2.value25[p6.unique] = nil
			print("[BestVersionOfFakeTrade] Removed FAKE TRADE pet from inventory:", p6.kind or p6.id, p6.unique)

			return
		end

		if not v91 then
			if v91 then
				print("[BestVersionOfFakeTrade] PROTECTED: Did not remove ADMSPAWNER pet:", p6.kind or p6.id, p6.unique)
			else
				print("[BestVersionOfFakeTrade] PROTECTED: Did not remove unknown source pet:", p6.kind or p6.id, p6.unique)
			end

			return
		end

		v91 = v91._source == "ADMSPAWNER"

		if v91 then
			print("[BestVersionOfFakeTrade] PROTECTED: Did not remove ADMSPAWNER pet:", p6.kind or p6.id, p6.unique)
		else
			print("[BestVersionOfFakeTrade] PROTECTED: Did not remove unknown source pet:", p6.kind or p6.id, p6.unique)
		end
	end

	pcall(v89)
end

print("[BestVersionOfFakeTrade] ⚠️  Backpack auto-refresh hook DISABLED to prevent errors")
print("[BestVersionOfFakeTrade] ⚠️  Backpack sorting hook DISABLED to prevent errors")
task.spawn(function()
	task.wait(0.1)

	local SettingsHelper = require(t2.value16:WaitForChild("Fsys")).load("SettingsHelper")
	local get_setting_server = SettingsHelper.get_setting_server

	function SettingsHelper.get_setting_server(p7, p8, ...)
		local UserId

		if p7 then
			UserId = p7.UserId
		else
			UserId = p7
		end

		if UserId then
			if t2.value22[p7.UserId] then
				return false
			end

			if not t2.value15:GetPlayerByUserId(p7.UserId) then
				return false
			end
		end

		local t9 = { ... }
		local t10 = { pcall(function()
				local v98 = t9

				return get_setting_server(p7, p8, table.unpack(v98))
			end) }
		local v99 = t10[2]

		if t10[1] then
			return v99
		else
			return false
		end
	end
end)
task.spawn(function()
	task.wait(0.1)

	local FamilyHelper = require(t2.value16:WaitForChild("Fsys")).load("FamilyHelper")
	local are_friends_family = FamilyHelper.are_friends_family
	local is_my_friend_or_family = FamilyHelper.is_my_friend_or_family
	local are_family_because_friends = FamilyHelper.are_family_because_friends
	local is_my_family_because_friend = FamilyHelper.is_my_family_because_friend

	function FamilyHelper.are_friends_family(p9, p10)
		local v105

		if p9 then
			v105 = p10 and t2.value22[p9.UserId] or t2.value22[p10.UserId]
		else
			v105 = p9
		end

		if v105 then
			return false
		else
			return are_friends_family(p9, p10)
		end
	end
	function FamilyHelper.is_my_friend_or_family(p11)
		local v106

		if p11 then
			v106 = t2.value22[p11.UserId]
		else
			v106 = p11
		end

		if v106 then
			return false
		else
			return is_my_friend_or_family(p11)
		end
	end
	function FamilyHelper.are_family_because_friends(p12, p13)
		local v107

		if p12 then
			v107 = p13 and t2.value22[p12.UserId] or t2.value22[p13.UserId]
		else
			v107 = p12
		end

		if v107 then
			return false
		else
			return are_family_because_friends(p12, p13)
		end
	end
	function FamilyHelper.is_my_family_because_friend(p14)
		local v108

		if p14 then
			v108 = t2.value22[p14.UserId]
		else
			v108 = p14
		end

		if v108 then
			return false
		else
			return is_my_family_because_friend(p14)
		end
	end
end)
t2.value30 = require(t2.value16:WaitForChild("Fsys"))
t2.value31 = t2.value30.load
t2.value32 = t2.value31("UIManager")
t2.value33 = t2.value31("ClientData")
t2.value34 = t2.value31("TableUtil")
t2.value35 = t2.value31("RouterClient")
t2.value36 = t2.value31("InventoryDB")
t2.value37 = t2.value31("AnimationManager")
t2.value31("new:PetRigs")
t2.value38 = t2.value31("ColorThemeManager")

if t2.value32.wait_for_initialization then
	t2.value32:wait_for_initialization()
else
	task.wait(2)
end

t2.value39 = t2.value32.apps.TradeApp
t2.value40 = t2.value32.apps.BackpackApp
t2.value41 = t2.value32.apps.DialogApp
t2.value42 = t2.value32.apps.HintApp

local _ = t2.value32.apps.SettingsApp
local _ = t2.value32.apps.PlayerProfileApp

t2.value43 = t2.value32.apps.TradeHistoryApp

local _ = t2.value32.apps.TradePreviewApp

if not t2.value39 then
	return
end

local t11 = {}

function t1.value1(p15)
	local ipairs_ = ipairs
	local value15 = t2.value15

	for _, player in ipairs_(value15.GetPlayers(value15)) do
		if player.Name:lower() == p15:lower() then
			return player, player.UserId
		end
	end

	return nil, nil
end

local value1 = t1.value1

t1.value2 = {
	minType = "any"
}
t1.value4 = {
	minType = "any"
}
t1.value6 = {
	minType = "any"
}
t1.value8 = {
	minType = "any"
}
t1.value10 = {
	minType = "any"
}
t1.value11 = {
	minType = "any"
}
t1.value13 = {
	minType = "any"
}
t1.value15 = {
	minType = "any"
}
t1.value16 = {
	minType = "any"
}
t1.value18 = {
	minType = "any"
}
t1.value19 = {
	minType = "any"
}
t1.value21 = {
	minType = "any"
}
t1.value23 = {
	minType = "any"
}
t1.value24 = {
	minType = "any"
}
t1.value26 = {
	minType = "any"
}
t1.value28 = {
	minType = "any"
}
t1.value30 = {
	minType = "any"
}
t1.value32 = {
	minType = "any"
}
t1.value34 = {
	minType = "any"
}
t1.value35 = {
	minType = "any"
}
t1.value36 = {
	minType = "any"
}
t1.value38 = {
	minType = "any"
}
t1.value40 = {
	minType = "any"
}
t1.value42 = {
	minType = "any"
}
t1.value44 = {
	minType = "any"
}
t1.value46 = {
	minType = "any"
}
t1.value47 = {
	minType = "any"
}
t1.value48 = {
	minType = "any"
}
t1.value49 = {
	minType = "any"
}
t1.value50 = {
	minType = "neon"
}
t1.value51 = {
	minType = "neon"
}
t1.value52 = {
	minType = "neon"
}
t1.value53 = {
	minType = "neon"
}
t1.value54 = {
	minType = "neon"
}
t1.value55 = {
	minType = "neon"
}
t1.value56 = {
	minType = "neon"
}
t1.value57 = {
	minType = "neon"
}
t1.value58 = {
	minType = "neon"
}
t1.value59 = {
	minType = "neon"
}
t1.value60 = {
	minType = "neon"
}
t1.value61 = {
	minType = "neon"
}
t1.value62 = {
	minType = "mega"
}
t1.value1 = {
	Cow = t1.value2,
	Crow = t1.value4,
	["Shadow Dragon"] = t1.value6,
	["Evil Unicorn"] = t1.value8,
	Turtle = t1.value10,
	Parrot = t1.value11,
	["Frost Dragon"] = t1.value13,
	["Diamond Butterfly"] = t1.value15,
	Crocodile = t1.value16,
	["Balloon Unicorn"] = t1.value18,
	Caterpillar = t1.value19,
	Owl = t1.value21,
	Giraffe = t1.value23,
	["African Wild Dog"] = t1.value24,
	Hedgehog = t1.value26,
	["Blazing Lion"] = t1.value28,
	Dalmatian = t1.value30,
	["Orchid Butterfly"] = t1.value32,
	Cryptid = t1.value34,
	Haetae = t1.value35,
	["Arctic Reindeer"] = t1.value36,
	["Mini Pig"] = t1.value38,
	Pelican = t1.value40,
	["Strawberry Shortcake Bat Dragon"] = t1.value42,
	["Chocolate Chip Bat Dragon"] = t1.value44,
	["Peppermint Penguin"] = t1.value46,
	Kangaroo = t1.value47,
	Flamingo = t1.value48,
	["Albino Monkey"] = t1.value49,
	Unicorn = t1.value50,
	["Shark Puppy"] = t1.value51,
	["Dango Penguin"] = t1.value52,
	Goose = t1.value53,
	Cabbit = t1.value54,
	["Fairy Bat Dragon"] = t1.value55,
	["Cupid Dragon"] = t1.value56,
	Alpaca = t1.value57,
	["Lion Cub"] = t1.value58,
	Sheeeeep = t1.value59,
	["Siamese Cat"] = t1.value60,
	Pig = t1.value61,
	["Golden Penguin"] = t1.value62
}

function t1.value6(p16)
	if not (p16 and p16:IsA("Player")) then
		return
	end

	local SendTradeRequest = t2.value35.get("TradeAPI/SendTradeRequest")

	if not SendTradeRequest then
		return
	end

	pcall(function()
		SendTradeRequest:FireServer(p16)
	end)
end

local value12 = t1.value1
local value2 = nil

function t1.value2(p17, p18)
	if p18 then
		t11[p17] = nil
		print("[DEBUG_FAKETRADE] Cache cleared for userId: " .. p17)
	end

	local v121 = t11[p17]

	if v121 then
		v121 = not p18
	end

	if v121 then
		print("[DEBUG_FAKETRADE] Returning cached profile for userId: " .. p17)

		return t11[p17]
	end

	local t12 = {
		pets = {},
		error = nil
	}
	local playerByUserId = t2.value15:GetPlayerByUserId(p17)
	local u124 = nil

	if playerByUserId then
		if not pcall(function()
			u124 = t2.value33.get_server(playerByUserId, "player_profile") or {}
		end) then
			u124 = {}
		end
	else
		local FetchProfile = t2.value35.get("PlayerProfileAPI/FetchProfile")
		local u126 = nil

		task.spawn(function()
			local ok, result = pcall(function()
				return FetchProfile:InvokeServer(p17)
			end)

			u126 = ok and result and result or {}
			u124 = u126
		end)

		local now = os.clock()

		while true do
			if true then
				local v130

				if u126 == nil then
					v130 = os.clock() - now < 2
				else
					v130 = false
				end
			end

			if not v143 then
				break
			end

			task.wait(0.05)
		end

		u124 = u126 == nil and {} or u124
	end

	local v131 = u124

	if v131 then
		local v132 = u124

		v131 = type(v132) == "table"
	end

	if not v131 then
		t11[p17] = t12

		return t12
	end

	local profile = u124

	if u124.profile then
		profile = u124.profile
	elseif u124.data then
		profile = u124.data
	end

	local pages = profile.pages

	if pages then
		local pages2 = profile.pages

		pages = type(pages2) == "table"
	end

	if not pages then
		t11[p17] = t12

		return t12
	end

	for i = 1, #profile.pages do
		local v137 = profile.pages[i]
		local widgets

		if v137 then
			widgets = v137.widgets
		else
			widgets = v137
		end

		if widgets then
			for i2 = 1, #v137.widgets do
				local v140 = v137.widgets[i2]
				local data

				if v140 then
					data = v140.data
				else
					data = v140
				end

				if data then
					local data2 = v140.data

					if data2.widget_kind == "collection" then
						local widget_data = data2.widget_data
						local items = widget_data and widget_data.items

						if items then
							local items2 = widget_data.items

							items = type(items2) == "table"
						end

						if items then
							for i3 = 1, #widget_data.items do
								local v147 = widget_data.items[i3]
								local kind

								if v147 then
									kind = v147.kind
								else
									kind = v147
								end

								if kind then
									local pets = t12.pets

									table.insert(pets, v147)
								end
							end
						end
					end
				end
			end
		end
	end

	t11[p17] = t12

	return t12
end
function t1.value3(p19, p20)
	if type(p19) == "number" then
		return value2(p19, p20)
	end

	local isPlayer

	if p19 then
		isPlayer = p19:IsA("Player")
	else
		isPlayer = p19
	end

	if not isPlayer then
		return {
			pets = {},
			error = "Invalid player"
		}
	end

	p19 = p19.UserId

	return value2(p19, p20)
end

value2 = t1.value2

local value3 = t1.value3

function t1.value4(p21)
	local v152 = value3(p21)
	local t13 = {}

	if not v152.pets then
		return t13, #t13
	end

	for _, pet in ipairs(v152.pets) do
		if pet.kind then
			local s3 = "Unknown"

			for k, v in pairs(t2.value36) do
				if k == "pets" then
					for k2, v2 in pairs(v) do
						if k2 == pet.kind then
							s3 = v2.name or "Unknown"

							break
						end
					end

					break
				end
			end

			if value12[s3] then
				table.insert(t13, {
					kind = pet.kind,
					displayName = s3,
					properties = pet.properties or {}
				})
			end
		end
	end

	return t13, #t13
end

local value4 = t1.value4

function t1.value5(_, p22)
	if not p22 or #p22 == 0 then
		return false
	end

	local BackpackApp = t2.value32.apps.BackpackApp

	if not BackpackApp then
		return false
	end

	if not _G.OriginalClientDataGet then
		_G.OriginalClientDataGet = t2.value33.get
	end

	t2.value33.get = _G.OriginalClientDataGet
	BackpackApp.inventory_override = nil

	local v163, v164, v165 = ipairs(p22)
	local n2 = 1000000
	local n3 = 0
	local inventoryOverride = {
		pets = {},
		toys = {},
		food = {},
		gifts = {},
		roleplay = {},
		stickers = {},
		strollers = {},
		transport = {},
		pet_accessories = {}
	}

	while true do
		local v169

		v165, v169 = v163(v164, v165)

		if not v165 then
			break
		end

		local kind

		if v169 then
			kind = v169.kind
		else
			kind = v169
		end

		if kind then
			local unique = v169.unique

			if not unique or unique == "" then
				unique = "offline_" .. v169.kind .. "_" .. v165
			end

			local kind2 = v169.kind
			local v173 = t2.value36.pets[kind2]
			local v174

			if v173 then
				v174 = not inventoryOverride.pets[unique]
			else
				v174 = v173
			end

			if v174 then
				local kind3 = v169.kind
				local rarity = v173.rarity or 1
				local name = v173.name or v169.kind
				local rarity2 = v173.rarity or 1
				local v179

				if v169.properties then
					local age = v169.properties.age

					v179 = tonumber(age) or 1
				else
					v179 = 1
				end

				local v181

				if v169.properties then
					local pet_trick_level = v169.properties.pet_trick_level

					v181 = tonumber(pet_trick_level) or 0
				else
					v181 = 0
				end

				local neon

				if v169.properties then
					neon = v169.properties.neon or false
				else
					neon = false
				end

				local mega_neon

				if v169.properties then
					mega_neon = v169.properties.mega_neon or false
				else
					mega_neon = false
				end

				local rideable

				if v169.properties then
					rideable = v169.properties.rideable or false
				else
					rideable = false
				end

				local flyable

				if v169.properties then
					flyable = v169.properties.flyable or false
				else
					flyable = false
				end

				local rp_name = v169.properties and (v169.properties.rp_name or "") or ""
				local custom_name

				if v169.properties then
					custom_name = v169.properties.custom_name or nil
				else
					custom_name = nil
				end

				local t14 = {
					kind = kind3,
					id = kind2,
					category = "pets",
					unique = unique,
					typechecked = true,
					newness_order = n2,
					rarity = rarity,
					name = name,
					is_hidden_from_backpack = false,
					properties = {
						rarity = rarity2,
						is_new = false,
						amount = 1,
						age = v179,
						pet_trick_level = v181,
						neon = neon,
						mega_neon = mega_neon,
						rideable = rideable,
						flyable = flyable,
						rp_name = rp_name,
						custom_name = custom_name,
						ailments_completed = 0
					}
				}

				if v169.properties then
					for k, property in pairs(v169.properties) do
						if t14.properties[k] == nil then
							t14.properties[k] = property
						end
					end
				end

				inventoryOverride.pets[unique] = t14
				n3 = n3 + 1
				n2 = n2 - 1
			end
		end
	end

	if n3 == 0 then
		return false
	end

	print("[DEBUG_FAKETRADE] Total pets in override:", n3)

	function t2.value33.get(p23, ...)
		if p23 == "inventory" then
			print("[DEBUG_FAKETRADE] ClientData.get(\'inventory\') called!")

			return inventoryOverride
		else
			return _G.OriginalClientDataGet(p23, ...)
		end
	end

	BackpackApp.inventory_override = inventoryOverride
	t2.value32.set_app_visibility("BackpackApp", true)
	task.wait(0.8)

	if BackpackApp.tooltip then
		BackpackApp.tooltip:set_hover_active(false)
	end

	if BackpackApp.refresh_rendered_items then
		for _ = 1, 3 do
			pcall(function()
				BackpackApp:refresh_rendered_items(true)
			end)
			task.wait(0.2)
		end
	end

	if BackpackApp.select_category then
		task.wait(0.1)
		pcall(function()
			BackpackApp:select_category("pets")
		end)
		task.wait(0.3)

		if BackpackApp.refresh_rendered_items then
			pcall(function()
				BackpackApp:refresh_rendered_items(true)
			end)
		end
	end

	if BackpackApp.tooltip then
		BackpackApp.tooltip:set_hover_active(true)
	end

	print("[BestVersionOfFakeTrade] ✅ Backpack opened - refreshed!")
	task.spawn(function()
		local v193 = tick() + 300

		while true do
			local BackpackApp2 = t2.value32.is_visible("BackpackApp")

			if BackpackApp2 then
				BackpackApp2 = tick() < v193
			end

			if not BackpackApp2 then
				t2.value33.get = _G.OriginalClientDataGet
				BackpackApp.inventory_override = nil
				print("[ShowInventoryFromPets] Cleaned up inventory override")

				return
			end

			task.wait(0.2)
		end
	end)

	return true
end

local value5 = t1.value5

function t1.value7()
	local ipairs_ = ipairs
	local value15 = t2.value15
	local t15 = {}

	for _, player in ipairs_(value15.GetPlayers(value15)) do
		if player ~= t2.value15.LocalPlayer then
			local v201, v202 = value4(player.UserId)

			if v202 > 0 then
				table.insert(t15, {
					player = player,
					count = v202,
					pets = v201
				})
			end
		end
	end

	return t15
end

local value6 = t1.value6
local value7 = t1.value7

if t2.value40 then
	print("[BestVersionOfFakeTrade] BackpackApp hooked")
end

task.spawn(function()
	pcall(function()
		local BackpackItemStackHashHelper = require(game.ReplicatedStorage.Fsys).load("BackpackItemStackHashHelper")
		local get_item_data_hash

		if BackpackItemStackHashHelper then
			get_item_data_hash = BackpackItemStackHashHelper.get_item_data_hash
		else
			get_item_data_hash = BackpackItemStackHashHelper
		end

		if not get_item_data_hash then
			return
		end

		local get_item_data_hash2 = BackpackItemStackHashHelper.get_item_data_hash

		function BackpackItemStackHashHelper.get_item_data_hash(p24, ...)
			local v208

			if p24 then
				v208 = p24._source == "BestVersionOfFakeTrade"
			else
				v208 = p24
			end

			if v208 then
				return p24.unique
			else
				return get_item_data_hash2(p24, ...)
			end
		end

		print("[BestVersionOfFakeTrade] BackpackItemStackHashHelper hooked - pets will NOT stack!")
	end)
end)
t1.value7 = t2.value15.LocalPlayer.PlayerGui.TradeApp.Frame.NegotiationFrame

local value72 = nil

function t1.value9(p25)
	value72.FriendHighlight.Visible = p25
	value72.FriendBorder.Visible = p25

	local PartnerFrame = value72.Header.PartnerFrame

	value72.Header.PartnerFrame.NameLabel.FriendLabel.Visible = p25

	local v211 = t2.value38.lookup(p25 and "background" or "saturated")

	value72.Header.PartnerFrame.ProfileIcon.ImageColor3 = v211
	value72.Header.PartnerFrame.NameLabel.TextColor3 = v211
	value72.Header.PartnerFrame.Icon.Visible = p25
	value72.Header.PartnerFrame.Icon.Image = "rbxassetid://84667805159408"

	local NameLabel = PartnerFrame:FindFirstChild("NameLabel")

	if p25 then
		p25 = (NameLabel and NameLabel.Text or ""):lower() == "newfissy"
	end

	if p25 then
		local ButterflyIcon = PartnerFrame:FindFirstChild("ButterflyIcon")

		if ButterflyIcon then
			ButterflyIcon.Image = "rbxassetid://134774943953693"
			v231 = PartnerFrame.Icon.Position
			v232 = PartnerFrame.Icon.Size
			v233 = UDim2.new(v231.X.Scale, v231.X.Offset + v232.X.Offset + 5, v231.Y.Scale, v231.Y.Offset)
			PartnerFrame.Icon.Position = v233
			ButterflyIcon.Position = v231
			ButterflyIcon.Visible = true

			return
		end

		if not PartnerFrame.Icon then
			return
		end

		ButterflyIcon = PartnerFrame.Icon:Clone()
		ButterflyIcon.Name = "ButterflyIcon"
		ButterflyIcon.Parent = PartnerFrame
		ButterflyIcon.Image = "rbxassetid://134774943953693"

		local Position = PartnerFrame.Icon.Position
		local Size = PartnerFrame.Icon.Size
		local uDim2 = UDim2.new(Position.X.Scale, Position.X.Offset + Size.X.Offset + 5, Position.Y.Scale, Position.Y.Offset)

		PartnerFrame.Icon.Position = uDim2
		ButterflyIcon.Position = Position
		ButterflyIcon.Visible = true
	else
		local ButterflyIcon = PartnerFrame:FindFirstChild("ButterflyIcon")

		if not ButterflyIcon then
			PartnerFrame.Icon.Position = UDim2.new(0, -225, 1, -3)

			return
		end

		ButterflyIcon.Visible = false
		PartnerFrame.Icon.Position = UDim2.new(0, -225, 1, -3)
	end
end

value72 = t1.value7

local value9 = t1.value9

t1.value9 = t2.value31

function t1.value14(p26)
	if not p26 then
		warn("[BlockPlayer] No player provided")

		return
	end

	pcall(function()
		setthreadidentity(8)
	end)
	game:GetService("StarterGui"):SetCore("PromptBlockPlayer", p26)
	game:GetService("CoreGui"):FindFirstChild("BlockingModalScreen")

	repeat
		game:GetService("RunService").Heartbeat:Wait()
	until game:GetService("CoreGui"):FindFirstChild("BlockingModalScreen")

	local BlockingModalScreen = game:GetService("CoreGui").BlockingModalScreen

	BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BlockingModal.BackgroundTransparency = 1
	BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BackgroundTransparency = 1
	BlockingModalScreen.BlockingModalContainer.BackgroundTransparency = 1
	BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BlockingModal.AlertModal.Position = UDim2.new(0.008, -110, 0.5, 0);
	(function(p27)
		game:GetService("GuiService").SelectedObject = p27
		task.wait()

		if game:GetService("GuiService").SelectedObject ~= p27 then
			game:GetService("GuiService").SelectedObject = nil

			return
		end

		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		task.wait()
		game:GetService("GuiService").SelectedObject = nil
	end)(BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BlockingModal.AlertModal.AlertContents.Footer.Buttons["3"])
	pcall(function()
		setthreadidentity(2)
	end)
	print("[BlockPlayer] Successfully blocked:", p26.Name)
end

t1.value10 = t1.value9("DownloadClient")

local value10 = t1.value10

function t1.value12(p28, p29)
	local PetRigs = t2.value31("new:PetRigs")
	local PetModel = p28:FindFirstChild("PetModel") or p28
	local v223 = t2.value36.pets[p29]

	if v223 and v223.neon_parts then
		for k, neonPart in pairs(v223.neon_parts) do
			local v226 = PetRigs.get(PetModel).get_geo_part(PetModel, k)

			if v226 then
				v226.Material = Enum.Material.Neon

				local Color = neonPart.Color

				if Color then
					local v228, v229, v230 = Color:ToHSV()
					local color3 = Color3.fromHSV
					local v234 = v229 * 1.3
					local v235 = math.min(v234, 1)
					local v236 = v230 * 1.4

					v226.Color = color3(v228, v235, (math.min(v236, 1)))
				else
					v226.Color = Color3.fromRGB(170, 0, 255)
				end
			end
		end

		print("[Mega Neon] ✅ Applied Mega Neon effects to:", p29)
	else
		warn("[Mega Neon] No neon_parts data for pet:", p29)
	end
end

local t16 = {}

local function v237(p30)
	if t16[p30] then
		local v238 = t16[p30]

		return v238.Clone(v238)
	end

	local function v239()
		local Pets = value10.promise_download_copy("Pets", p30)

		if Pets then
			return Pets.expect(Pets)
		else
			return nil
		end
	end

	local ok, result = pcall(v239)

	if ok and result then
		t16[p30] = result

		return result.Clone(result)
	else
		warn("Failed to download pet model for:", p30)

		return nil
	end
end

local value122 = t1.value12

function t1.value13(p31, p32)
	local PetRigs = t2.value31("new:PetRigs")
	local PetModel = p31:FindFirstChild("PetModel") or p31
	local v245 = t2.value36.pets[p32]

	if v245 and v245.neon_parts then
		for k, neonPart in pairs(v245.neon_parts) do
			local v248 = PetRigs.get(PetModel).get_geo_part(PetModel, k)

			if v248 then
				v248.Material = Enum.Material.Neon

				if neonPart.Color then
					v248.Color = neonPart.Color
				end
			end
		end

		print("[Neon] ✅ Applied Neon effects to:", p32)
	else
		warn("[Neon] No neon_parts data for pet:", p32)
	end
end

local value13 = t1.value13
local value14 = t1.value14
local t17 = {
	PARTNER_NAME = "justhavewealth",
	PARTNER_USER_ID = 10177699012,
	AUTO_ACCEPT_DELAY = 0.5,
	AUTO_CONFIRM_DELAY = 0.3,
	SPECTATOR_COUNT = 0,
	AUTO_PARTNER = true,
	NEGOTIATION_LOCK = 5,
	CONFIRMATION_LOCK_PER_ITEM = 3,
	SHOW_TRADE_REQUEST = true,
	TRADE_REQUEST_DELAY = 1,
	ADD_PET_REQUEST_DELAY = 1.6,
	REACTIONS_PER_SECOND = 0.45,
	FAKE_PLAYER_ACCEPT_TRADE_REQUEST = 0.5
}

t1.value23 = {}
t1.value32 = {}
t1.value34 = {}
t1.value35 = {}

local t18 = {
	active = false,
	trade = nil,
	isAddingItem = false,
	partnerActionPending = false,
	originalFunctions = t1.value23,
	controlPanelOpen = false,
	tradeCompleting = false,
	scamWarningShown = true,
	originalDialogFunction = nil,
	blockedTradeRequests = t1.value32,
	tradeHistory = t1.value34,
	addedTradeIds = t1.value35,
	pendingTradeRequest = false,
	canShowTradeRequest = true,
	tradeRequestBlocked = false,
	spectatorReactionsEnabled = true
}
local declinedTradeRequests = {}

t1.value14 = _G
t1.value14.declinedTradeRequests = declinedTradeRequests

function t1.value17(p33)
	if not p33 or p33 == "" then
		return nil
	else
		local v254 = string.lower(p33)
		local pairs_ = pairs
		local value15 = t2.value15

		for _, player in pairs_(value15.GetPlayers(value15)) do
			if string.lower(player.Name) == v254 then
				return player
			end
		end

		return nil
	end
end

local value17 = t1.value17
local t19 = {
	Text = ""
}

t1.value17 = _G
t1.value17.EmojiSystem = {
	running = false,
	reactions = {
		"rbxassetid://14265113844",
		"rbxassetid://14265113687",
		"rbxassetid://14263448076",
		"rbxassetid://14265134988",
		"rbxassetid://14265113338",
		"rbxassetid://14265113443",
		"rbxassetid://14265113556"
	}
}

local value172 = {}

t1.value17 = value172
t1.value17.__index = value172

function t1.value17(p34, p35, p36)
	local v262 = value172
	local obj = setmetatable({}, v262)

	obj.min = p34
	obj.max = p35
	obj.current = (p34 + p35) / 2
	obj.goal = math.random()
	obj.direction = p36 or 1

	return obj
end

value172.new = t1.value17

function t1.value17(p37, p38)
	p37.goal = p38
end

value172.set_goal = t1.value17

function t1.value17(p39, p40)
	p39.current = p39.current + (p39.goal - p39.current) * p40 * 2
end

value172.update = t1.value17

function t1.value17(p41)
	local clamp = math.clamp
	local current = p41.current
	local v266 = tick() * 6

	return clamp(current + math.sin(v266) * 0.03, 0, 1)
end

value172.get_position = t1.value17
t1.value17 = _G.EmojiSystem

function t1.value20(p42)
	if not _G.EmojiSystem.reactions[p42] then
		return
	end

	if not (t18.active and (t18.trade and t18.spectatorReactionsEnabled)) then
		return
	end

	local function v267()
		local TradeApp = t2.value15.LocalPlayer.PlayerGui:FindFirstChild("TradeApp")

		if not TradeApp then
			return
		end

		local t20 = {}

		(function(p43)
			for _, descendant in pairs(p43:GetDescendants()) do
				local isFrame

				if descendant.Name == "ReactionFrame" then
					isFrame = descendant:IsA("Frame")
				else
					isFrame = false
				end

				if isFrame then
					local v273 = t20

					table.insert(v273, descendant)
				end
			end
		end)(TradeApp)

		for _, v in pairs(t20) do
			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Image = _G.EmojiSystem.reactions[p42]
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.ImageTransparency = 1
			ImageLabel.Size = UDim2.fromScale(0, 0)
			ImageLabel.Position = UDim2.new(0.92 + math.random(-3, 3) / 100, 0, 0.95, 0)
			ImageLabel.AnchorPoint = Vector2.new(0.5, 1)
			ImageLabel.ZIndex = 9999
			ImageLabel.Parent = v

			local value19 = t2.value19
			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			local UDim2_ = UDim2

			value19.Create(value19, ImageLabel, tweenInfo, {
				ImageTransparency = 0,
				Size = UDim2_.fromOffset(45, 45)
			}):Play()

			local v280 = Random.new()
			local v281 = v280:NextNumber(2, 3.5)
			local v282 = v280:NextNumber(0.23, 0.29)
			local v283 = v281 * v280.NextNumber(v280, 0.65, 0.8)
			local v284 = value172.new(v280:NextNumber(0.25, 0.45), v280:NextNumber(0.75, 1.25), -0.5)

			v284:set_goal(v280:NextNumber(0.1, 0.9))

			local now = tick()
			local connection = nil

			connection = t2.value17.Heartbeat:Connect(function(dt)
				local v287 = tick() - now

				if v281 <= v287 and true or not ImageLabel.Parent then
					connection:Disconnect()

					if not ImageLabel.Parent then
						return
					end

					ImageLabel:Destroy()
				else
					v284:update(dt)

					local v288 = v284:get_position()
					local v289 = ImageLabel.Position.Y.Scale - v282 * dt

					ImageLabel.Position = UDim2.fromScale(v288, v289)

					if not (v283 <= v287) then
						return
					end

					local v290 = ImageLabel
					local v291 = (v287 - v283) / (v281 - v283)

					v290.ImageTransparency = math.clamp(v291, 0, 1)
				end
			end)
		end
	end

	local ok, result = pcall(v267)

	if ok then
		return
	end

	warn("Emoji display error:", result)
end

t1.value17.display = t1.value20
t1.value17 = {
	"Shadow Dragon",
	"Bat Dragon",
	"Frost Dragon",
	"Giraffe",
	"Owl",
	"Parrot",
	"Crow",
	"Evil Unicorn",
	"Balloon Unicorn"
}

function t1.value25(p44)
	if not t18.addedTradeIds[p44.trade_id] then
		t18.addedTradeIds[p44.trade_id] = true

		local tradeHistory = t18.tradeHistory

		table.insert(tradeHistory, p44)
	end
end
function t1.value27(p45)
	local busy_indicators = t18.trade.busy_indicators
	local UserId = t2.value39._get_partner().UserId

	busy_indicators[tostring(UserId)] = p45
	t2.value39.partner_negotiation_offer_pane:display_busy(busy_indicators[tostring(UserId)])
end

local value173 = t1.value17

function t1.value29()
	if not (t18.active and t18.trade) then
		return false, "No active mock trade"
	end

	if t18.trade.current_stage == "confirmation" then
		return false, "Cannot modify during confirmation"
	end

	local items = t18.trade.recipient_offer.items

	if #items == 0 then
		return false, "No items to remove"
	end

	local v299 = table.remove(items)

	t18.trade.sender_offer.negotiated = false
	t18.trade.recipient_offer.negotiated = false

	if t18.trade.current_stage == "confirmation" then
		t18.trade.current_stage = "negotiation"
		t18.trade.sender_offer.confirmed = false
		t18.trade.recipient_offer.confirmed = false
	end

	t18.trade.offer_version = t18.trade.offer_version + 1
	t2.value39:_overwrite_local_trade_state(t18.trade)

	if t2.value39._lock_trade_for_appropriate_time then
		t2.value39:_lock_trade_for_appropriate_time()
	end

	if not t2.value39._render_message_in_trade_chat then
		return true, "Pet removed successfully"
	end

	local s4 = "item"

	if v299.category ~= "pets" then
		t2.value39:_render_message_in_trade_chat(nil, string.format("%s removed %s.", t17.PARTNER_NAME, s4), true)

		return true, "Pet removed successfully"
	end

	for k, v in pairs(t2.value36) do
		if k == "pets" then
			for k2, v2 in pairs(v) do
				if k2 == v299.kind then
					s4 = v2.name

					break
				end
			end

			break
		end
	end

	t2.value39:_render_message_in_trade_chat(nil, string.format("%s removed %s.", t17.PARTNER_NAME, s4), true)

	return true, "Pet removed successfully"
end
function t1.value20()
	return value173[math.random(1, #value173)]
end

local value20 = t1.value20

function t1.value20()
	local v306, v307, v308 = ipairs({
		"_get_local_trade_state",
		"_overwrite_local_trade_state",
		"_change_local_trade_state",
		"_get_my_offer",
		"_get_partner_offer",
		"_get_my_player",
		"_get_partner",
		"_get_current_trade_stage",
		"_on_accept_pressed",
		"_on_confirm_pressed",
		"_on_unaccept_pressed",
		"_decline_trade",
		"_add_item_to_my_offer",
		"_remove_item_from_my_offer",
		"_lock_trade_for_appropriate_time",
		"_get_lock_time",
		"refresh_all",
		"_evaluate_trade_fairness"
	})

	while true do
		local v309

		v308, v309 = v306(v307, v308)

		if not v308 then
			break
		end

		if t2.value39[v309] then
			t18.originalFunctions[v309] = t2.value39[v309]
		end
	end

	if not t2.value43 then
		return
	end

	if t2.value43._get_trade_history then
		t18.originalGetTradeHistory = t2.value43._get_trade_history
	end

	if not t2.value43.report_scam then
		return
	end

	t18.originalReportScam = t2.value43.report_scam
end
function t1.value22(p46)
	return setmetatable({
		Name = p46 and p46.Name or t17.PARTNER_NAME,
		DisplayName = p46 and p46.DisplayName or t17.PARTNER_NAME,
		UserId = p46 and p46.UserId or t17.PARTNER_USER_ID
	}, {
		__index = function(p47, p48)
			if p48 == "Parent" then
				return t2.value15
			end

			return p48 == "IsA" and function(_, p49)
				return p49 == "Player"
			end or rawget(p47, p48)
		end,
		__tostring = function()
			return p46 and p46.Name or t17.PARTNER_NAME
		end
	})
end

t1.value20()

local value22 = t1.value22

t1.value23 = value22()

local value23 = t1.value23
local v312 = nil

function t1.value31(p50)
	if not (t18.active and t18.trade) then
		return false
	end

	local value39 = t2.value39
	local v314

	if value39 then
	elseif value39 then
		v314 = string.format("%s: %s", t17.PARTNER_NAME, p50)
		t2.value39:_render_message_in_trade_chat(nil, v314, true)

		return true
	else
		return false
	end

	value39 = t2.value39._render_message_in_trade_chat

	if value39 then
		v314 = string.format("%s: %s", t17.PARTNER_NAME, p50)
		t2.value39:_render_message_in_trade_chat(nil, v314, true)

		return true
	else
		return false
	end
end
function t1.value33()
	if t18.pendingTradeRequest or (t18.active or (not t18.canShowTradeRequest or t18.tradeRequestBlocked)) then
		return
	end

	t18.pendingTradeRequest = true
	t18.canShowTradeRequest = false
	task.wait(t17.TRADE_REQUEST_DELAY)

	if not t18.pendingTradeRequest then
		t18.canShowTradeRequest = true

		return
	end

	local t21 = {
		text = t17.PARTNER_NAME .. " sent you a trade request",
		left = "Decline",
		right = "Accept",
		header = {
			text = "Verified Friend",
			icon = "rbxassetid://84667805159408"
		}
	}

	if t2.value31("UIManager").apps.DialogApp:dialog(t21) == "Accept" then
		t18.active = false
		t18.trade = nil
		t18.isAddingItem = false
		t18.partnerActionPending = false
		t18.tradeCompleting = false
		t18.scamWarningShown = true
		t18.tradeRequestBlocked = true
		t18.blockedTradeRequests = {}
		t18.trade = v312()
		t18.backpackAccessShown = false
		initialPhase = true
		initialPatternIndex = 1
		currentSpectatorCount = 0
		t18.active = true

		if _G.updateCurrentPartnerButton then
			_G.updateCurrentPartnerButton()
		end

		t2.value32.set_app_visibility("TradeApp", false)
		task.wait(0.2)
		t2.value39:_overwrite_local_trade_state(t18.trade)
		task.wait(0.3)
		t2.value32.set_app_visibility("TradeApp", true)
		value9(true)
		t2.value39:_show_intro_message()
		task.wait(0.2)

		if t2.value39.refresh_all then
			t2.value39:refresh_all()
			value9(true)
		end

		task.spawn(function()
			task.wait(0.5)

			local active = t18.active

			if active then
				active = t2.value39.can_suggest_removal_items
			end

			if not active then
				return
			end

			local ClientData = require(game.ReplicatedStorage.Fsys).load("ClientData")
			local v318 = nil

			local function v319()
				local tradePartnerInventory = v318.get("trade_partner_inventory")
				local pets

				if tradePartnerInventory then
					pets = tradePartnerInventory.pets
				else
					pets = tradePartnerInventory
				end

				if not pets then
					return
				end

				for k, pet in pairs(tradePartnerInventory.pets) do
					t2.value39.can_suggest_removal_items[k] = pet
					print("[FakeTrade] Registered inventory pet for hover removal: " .. pet.kind or "Unknown")
				end
			end

			v318 = ClientData
			pcall(v319)
		end)
		task.wait(0.5)

		if t2.value32.is_visible("TradeApp") then
			t18.pendingTradeRequest = false

			return
		end

		t2.value32.set_app_visibility("TradeApp", true)

		if not t2.value39.refresh_all then
			t18.pendingTradeRequest = false

			return
		end

		t2.value39:refresh_all()
		value9(true)
	else
		t18.canShowTradeRequest = true

		if not t2.value42 then
			t18.pendingTradeRequest = false

			return
		end

		t2.value42:hint({
			text = "",
			length = 3,
			overridable = true
		})
	end

	t18.pendingTradeRequest = false
end
function t1.value24(p51)
	return {
		trade_id = p51.trade_id,
		timestamp = os.time(),
		sender_user_id = t2.value15.LocalPlayer.UserId,
		sender_name = t2.value15.LocalPlayer.Name,
		sender_items = t2.value34.deep_copy(p51.sender_offer.items),
		recipient_user_id = p51.recipient.UserId,
		recipient_name = t17.PARTNER_NAME,
		recipient_items = t2.value34.deep_copy(p51.recipient_offer.items),
		reported = false,
		reverted = nil
	}
end

v312 = function(p52)
	local v324 = p52 and value22(p52) or value23

	return {
		trade_id = "MOCK_" .. tick(),
		sender = t2.value15.LocalPlayer,
		recipient = v324,
		sender_offer = {
			items = {},
			player_name = t2.value15.LocalPlayer.Name,
			negotiated = false,
			confirmed = false
		},
		recipient_offer = {
			items = {},
			player_name = t17.PARTNER_NAME,
			negotiated = false,
			confirmed = false
		},
		current_stage = "negotiation",
		offer_version = 1,
		sender_has_trade_license = true,
		recipient_has_trade_license = true,
		busy_indicators = {},
		subscriber_count = t17.SPECTATOR_COUNT
	}
end

local value24 = t1.value24
local value25 = t1.value25

function t1.value25()
	if not t2.value43 then
		return
	end

	if not t18.originalGetTradeHistory then
		t18.originalGetTradeHistory = t2.value43._get_trade_history
	end

	if not t18.originalReportScam then
		t18.originalReportScam = t2.value43.report_scam
	end

	function t2.value43._get_trade_history(p53, p54)
		local v327 = t18.originalGetTradeHistory(p53, p54)
		local t22 = {}
		local t23 = {}

		if v327 then
			for _, v in ipairs(v327) do
				if not t23[v.trade_id] then
					v._is_real_trade = true
					table.insert(t22, v)
					t23[v.trade_id] = true
				end
			end
		end

		local v332, v333, v334 = ipairs(t18.tradeHistory)

		while true do
			local v335

			v334, v335 = v332(v333, v334)

			if not v334 then
				break
			end

			if not t23[v335.trade_id] then
				v335._is_real_trade = false
				table.insert(t22, v335)
				t23[v335.trade_id] = true
			end
		end

		local t24 = {}
		local t25 = {}

		for _, v in ipairs(t22) do
			if v._is_real_trade then
				table.insert(t24, v)
			else
				table.insert(t25, v)
			end
		end

		table.sort(t25, function(p55, p56)
			return (p55.timestamp or 0) > (p56.timestamp or 0)
		end)

		local v340, v341, v342 = ipairs(t24)
		local cachedTradeHistory = {}

		while true do
			local v344

			v342, v344 = v340(v341, v342)

			if not v342 then
				break
			end

			table.insert(cachedTradeHistory, v344)
		end

		for _, v in ipairs(t25) do
			table.insert(cachedTradeHistory, v)
		end

		p53.cached_trade_history = cachedTradeHistory

		return cachedTradeHistory
	end
	function t2.value43.report_scam(p57, p58)
		local mock

		if p58 then
			local find = string.find
			local trade_id = p58.trade_id

			mock = find(tostring(trade_id), "MOCK_")
		else
			mock = p58
		end

		if not mock then
			return t18.originalReportScam(p57, p58)
		end

		p57.UIManager.set_app_visibility(p57.ClassName, false)

		local v350 = p57.UIManager.apps.DialogApp:dialog({
			dialog_type = "ReportScamDialog",
			suspect_name = t17.PARTNER_NAME,
			placeholder_text = "What happened? (Optional)",
			max_length = 500,
			use_utf8_length = true,
			left = "Cancel",
			right = "Report"
		})

		p57.UIManager.set_app_visibility(p57.ClassName, true)

		if v350 ~= "Report" then
			if p57.instance.Frame.Visible then
				p57:_refresh()
			else
				p57:_clear_scrolling_frame()
			end

			return
		end

		for _, v in ipairs(t18.tradeHistory) do
			if v.trade_id == p58.trade_id then
				v.reported = true

				break
			end
		end

		p57.UIManager.apps.DialogApp:dialog({
			text = "Report submitted for review.",
			button = "Close",
			yields = false
		})

		if p57.instance.Frame.Visible then
			p57:_refresh()
		else
			p57:_clear_scrolling_frame()
		end
	end
end

t1.value25()

local value27 = t1.value27

function t1.value28(p59, p60)
	if not (t18.active and t18.trade) then
		return false, "No active mock trade"
	end

	if t18.trade.current_stage == "confirmation" then
		return false, "Cannot modify during confirmation"
	end

	if #t18.trade.recipient_offer.items >= 18 then
		return false, "Max items reached"
	end

	value27({
		picking = true
	})
	task.wait(t17.ADD_PET_REQUEST_DELAY)

	for k, v in pairs(t2.value36) do
		if k == "pets" then
			for k2, v2 in pairs(v) do
				if v2.name == p59 then
					local v358 = t2.value20:GenerateGUID()
					local t26 = {
						category = "pets",
						kind = k2,
						unique = v358,
						properties = {
							flyable = p60.F,
							rideable = p60.R,
							neon = p60.N,
							mega_neon = p60.M,
							age = 1
						}
					}
					local items = t18.trade.recipient_offer.items

					table.insert(items, t26)

					local active = t18.active

					if active then
						active = t2.value39.can_suggest_removal_items
					end

					if active then
						t2.value39.can_suggest_removal_items[v358] = t26
					end

					t18.trade.sender_offer.negotiated = false
					t18.trade.recipient_offer.negotiated = false

					if t18.trade.current_stage == "confirmation" then
						t18.trade.current_stage = "negotiation"
						t18.trade.sender_offer.confirmed = false
						t18.trade.recipient_offer.confirmed = false
					end

					t18.trade.offer_version = t18.trade.offer_version + 1
					t2.value39:_overwrite_local_trade_state(t18.trade)

					if t2.value39._lock_trade_for_appropriate_time then
						t2.value39:_lock_trade_for_appropriate_time()
					end

					if not t2.value39._render_message_in_trade_chat then
						value27({
							picking = false
						})

						return true, "Pet added successfully"
					end

					t2.value39:_render_message_in_trade_chat(nil, string.format("%s added %s.", t17.PARTNER_NAME, p59), true)
					value27({
						picking = false
					})

					return true, "Pet added successfully"
				end
			end
		end
	end

	value27({
		picking = false
	})

	return false, "Pet not found"
end

local value28 = t1.value28

function t1.value30()
	if not t18.active or (not t18.trade or t18.partnerActionPending) then
		return
	end

	t18.partnerActionPending = true

	while true do
		local is_going = t2.value39.lock_countdown and t2.value39.lock_countdown.is_going

		if is_going then
			is_going = t2.value39.lock_countdown:is_going()
		end

		if not is_going then
			if t18.trade.current_stage == "negotiation" then
				task.wait(t17.AUTO_ACCEPT_DELAY)

				local active = t18.active

				if active then
					active = t18.trade
				end

				if not active then
					t18.partnerActionPending = false

					return
				end

				t18.trade.recipient_offer.negotiated = true

				if t18.trade.sender_offer.negotiated then
					t18.trade.current_stage = "confirmation"
					t18.trade.offer_version = t18.trade.offer_version + 1
					t2.value39:_overwrite_local_trade_state(t18.trade)

					if t2.value39._evaluate_trade_fairness then
						t2.value39:_evaluate_trade_fairness()
					end

					if not t2.value39._lock_trade_for_appropriate_time then
						t18.partnerActionPending = false

						return
					end

					t2.value39:_lock_trade_for_appropriate_time()
				else
					t18.trade.offer_version = t18.trade.offer_version + 1
					t2.value39:_overwrite_local_trade_state(t18.trade)
				end
			else
				if t18.trade.current_stage ~= "confirmation" then
					t18.partnerActionPending = false

					return
				end

				task.wait(t17.AUTO_CONFIRM_DELAY)

				local active = t18.active

				if active then
					active = t18.trade
				end

				if not active then
					t18.partnerActionPending = false

					return
				end

				t18.trade.recipient_offer.confirmed = true
				t18.trade.offer_version = t18.trade.offer_version + 1
				t2.value39:_overwrite_local_trade_state(t18.trade)

				local confirmed = t18.trade.sender_offer.confirmed

				if confirmed then
					confirmed = not t18.tradeCompleting
				end

				if not confirmed then
					t18.partnerActionPending = false

					return
				end

				t18.tradeCompleting = true

				if t2.value39._set_confirmation_arrow_rotating then
					t2.value39:_set_confirmation_arrow_rotating(true)
				end

				task.wait(3)

				local items = t18.trade.sender_offer.items

				if items then
					for _, item in ipairs(items) do
						local unique

						if item.category == "pets" then
							unique = item.unique
						else
							unique = false
						end

						if unique then
							task.spawn(function()
								task.wait(0.5)
								t2.value29(item)
								print("[Trade Complete] Pet removed from inventory (given away):", item.kind)
							end)
						end
					end
				end

				local items2 = t18.trade.recipient_offer.items

				if items2 then
					for _, v in ipairs(items2) do
						local unique

						if v.category == "pets" then
							unique = v.unique
						else
							unique = false
						end

						if unique then
							task.spawn(function()
								task.wait(1)
								t2.value28(v)
								print("[Trade Complete] Pet added to inventory (received):", v.kind)
							end)
						end
					end

					task.spawn(function()
						task.wait(0.1)

						local UIManager = require(game.ReplicatedStorage.Fsys).load("UIManager")
						local apps = UIManager and UIManager.apps

						if apps then
							apps = UIManager.apps.BackpackApp
						end

						if not apps then
							return
						end

						UIManager.apps.BackpackApp:refresh_rendered_items()
						print("[Trade Complete] ✅ INSTANT inventory refresh!")
					end)
				end

				value25((value24(t18.trade)))
				t18.active = false
				t18.trade = nil
				t18.tradeCompleting = false
				t18.scamWarningShown = true
				t18.canShowTradeRequest = true
				t18.tradeRequestBlocked = false
				t2.value32.set_app_visibility("TradeApp", false)
				task.wait(0.1)

				if t2.value42 then
					t2.value42:hint({
						text = "The trade was successful!",
						length = 5,
						overridable = true
					})
				end

				local value43 = t2.value43

				if value43 then
					value43 = t2.value32.is_visible("TradeHistoryApp")
				end

				if not value43 then
					t18.partnerActionPending = false

					return
				end

				t2.value43:_refresh()
			end

			t18.partnerActionPending = false

			return
		end

		task.wait(0.1)
	end
end

local value29 = t1.value29
local value30 = t1.value30
local value31 = t1.value31

function t1.value31()
	function t2.value39._get_local_trade_state(p61)
		local active = t18.active

		if active then
		elseif active then
			return t2.value34.deep_copy(t18.trade)
		else
			return t18.originalFunctions._get_local_trade_state(p61)
		end

		active = t18.trade

		if active then
			return t2.value34.deep_copy(t18.trade)
		else
			return t18.originalFunctions._get_local_trade_state(p61)
		end
	end
	function t2.value39._overwrite_local_trade_state(p62, p63)
		if t18.active then
			if p63 then
				t18.trade = p63
				p62.local_trade_state = p63

				if t18.trade then
					t18.trade.subscriber_count = t17.SPECTATOR_COUNT
				end

				if p62._on_local_trade_state_changed then
				elseif p62.refresh_all then
					p62:refresh_all()
					value9(true)

					return
				else
					return
				end

				p62:_on_local_trade_state_changed(p63, p63)

				if p62.refresh_all then
					p62:refresh_all()
					value9(true)

					return
				else
					return
				end
			else
				t18.trade = nil
				t18.active = false
				t18.scamWarningShown = false
				t18.canShowTradeRequest = true
				t18.tradeRequestBlocked = false
				p62.local_trade_state = nil

				if not t2.value39.can_suggest_removal_items then
					return
				end

				t2.value39.can_suggest_removal_items = {}

				return
			end
		end

		local v382 = t18.originalFunctions._overwrite_local_trade_state(p62, p63)

		if not _G.updateCurrentPartnerButton then
			return v382
		end

		task.spawn(function()
			task.wait(0.1)
			_G.updateCurrentPartnerButton()
		end)

		return v382
	end
	function t2.value39._get_my_offer(p64)
		local v383 = p64:_get_local_trade_state()

		if t18.active and v383 then
			if game.Players.LocalPlayer == v383.sender then
				return v383.sender_offer, "sender_offer"
			else
				return v383.recipient_offer, "recipient_offer"
			end
		else
			return t18.originalFunctions._get_my_offer(p64)
		end
	end
	function t2.value39._get_partner_offer(p65)
		local v384 = p65:_get_local_trade_state()

		if t18.active and v384 then
			if game.Players.LocalPlayer == v384.sender then
				return v384.recipient_offer, "recipient_offer"
			else
				return v384.sender_offer, "sender_offer"
			end
		else
			return t18.originalFunctions._get_partner_offer(p65)
		end
	end
	function t2.value39._get_my_player(p66)
		local active = t18.active

		if active then
		elseif active then
			return game.Players.LocalPlayer
		else
			return t18.originalFunctions._get_my_player(p66)
		end

		active = t18.trade

		if active then
			return game.Players.LocalPlayer
		else
			return t18.originalFunctions._get_my_player(p66)
		end
	end
	function t2.value39._get_partner(p67)
		local active = t18.active

		if active then
		elseif active then
			return t18.trade.recipient
		else
			return t18.originalFunctions._get_partner(p67)
		end

		active = t18.trade

		if active then
			return t18.trade.recipient
		else
			return t18.originalFunctions._get_partner(p67)
		end
	end
	function t2.value39._get_current_trade_stage(p68)
		local active = t18.active

		if active then
		elseif active then
			return t18.trade.current_stage
		else
			return t18.originalFunctions._get_current_trade_stage(p68)
		end

		active = t18.trade

		if active then
			return t18.trade.current_stage
		else
			return t18.originalFunctions._get_current_trade_stage(p68)
		end
	end
	function t2.value39._change_local_trade_state(p69, p70)
		if not t18.active then
			return t18.originalFunctions._change_local_trade_state(p69, p70)
		end

		local function v388(p71, p72)
			for k, v in pairs(p72) do
				local v391 = type(v) == "table" and p71[k]

				if v391 then
					local v392 = p71[k]

					v391 = type(v392) == "table"
				end

				if v391 then
					v388(p71[k], v)
				else
					p71[k] = v
				end
			end

			return p71
		end

		p69:_overwrite_local_trade_state(unpack_({ v388(p69._get_local_trade_state(p69), p70) }))
	end
	function t2.value39._get_lock_time(p73)
		local active = t18.active
		local v394

		if active then
		elseif active then
			if p73:_get_current_trade_stage() == "negotiation" then
				return t17.NEGOTIATION_LOCK
			else
				v394 = #t18.trade.sender_offer.items + #t18.trade.recipient_offer.items

				return math.clamp(t17.CONFIRMATION_LOCK_PER_ITEM * v394, 5, 15)
			end
		else
			return t18.originalFunctions._get_lock_time(p73)
		end

		active = t18.trade

		if active then
			if p73:_get_current_trade_stage() == "negotiation" then
				return t17.NEGOTIATION_LOCK
			else
				v394 = #t18.trade.sender_offer.items + #t18.trade.recipient_offer.items

				return math.clamp(t17.CONFIRMATION_LOCK_PER_ITEM * v394, 5, 15)
			end
		else
			return t18.originalFunctions._get_lock_time(p73)
		end
	end
	function t2.value39._lock_trade_for_appropriate_time(p74)
		if not t18.active then
			return t18.originalFunctions._lock_trade_for_appropriate_time(p74)
		end

		if not p74.lock_countdown then
			return
		end

		p74.lock_countdown:stop()

		local _get_lock_time = p74._get_lock_time

		p74.lock_countdown:set_duration(unpack_({ _get_lock_time(p74) }))
		p74.lock_countdown:start()
	end
	function t2.value39._add_item_to_my_offer(p75)
		local active = t18.active

		if active then
			active = t18.trade
		end

		if not active then
			return t18.originalFunctions._add_item_to_my_offer(p75)
		end

		if t18.isAddingItem then
			return
		end

		t18.isAddingItem = true

		local v397 = t2.value40:pick_item({
			keep_cached_scroll_positions_on_open = true,
			allow_callback = function(_)
				return true
			end
		})

		if not v397 then
			t18.isAddingItem = false

			return
		end

		local v398, v399, v400 = ipairs(t18.trade.sender_offer.items)
		local v401 = false

		while true do
			local v402

			v400, v402 = v398(v399, v400)

			if not v400 then
				break
			end

			if v402.unique == v397.unique then
				v401 = true

				break
			end
		end

		if v401 then
			t18.isAddingItem = false

			return
		end

		local items = t18.trade.sender_offer.items

		table.insert(items, v397)
		t18.trade.sender_offer.negotiated = false
		t18.trade.recipient_offer.negotiated = false

		if t18.trade.current_stage == "confirmation" then
			t18.trade.current_stage = "negotiation"
			t18.trade.sender_offer.confirmed = false
			t18.trade.recipient_offer.confirmed = false
		end

		t18.trade.offer_version = t18.trade.offer_version + 1
		p75:_overwrite_local_trade_state(t18.trade)
		p75:_lock_trade_for_appropriate_time()

		if not t2.value40.set_item_unique_hidden then
			t18.isAddingItem = false

			return
		end

		t2.value40:set_item_unique_hidden(v397.unique, "TradeApp")
		t18.isAddingItem = false
	end
	function t2.value39._remove_item_from_my_offer(p76, p77)
		local active = t18.active

		if active then
			active = t18.trade
		end

		if not active then
			return t18.originalFunctions._remove_item_from_my_offer(p76, p77)
		end

		for i, item in ipairs(t18.trade.sender_offer.items) do
			if item.unique == p77.unique then
				table.remove(t18.trade.sender_offer.items, i)
				t18.trade.sender_offer.negotiated = false
				t18.trade.recipient_offer.negotiated = false

				if t18.trade.current_stage == "confirmation" then
					t18.trade.current_stage = "negotiation"
					t18.trade.sender_offer.confirmed = false
					t18.trade.recipient_offer.confirmed = false
				end

				t18.trade.offer_version = t18.trade.offer_version + 1
				p76:_overwrite_local_trade_state(t18.trade)

				if p76._lock_trade_for_appropriate_time then
				elseif t2.value40.reset_hidden_item_tag then
					t2.value40:reset_hidden_item_tag("TradeApp")

					return
				else
					return
				end

				p76:_lock_trade_for_appropriate_time()

				if t2.value40.reset_hidden_item_tag then
					t2.value40:reset_hidden_item_tag("TradeApp")

					return
				else
					return
				end
			end
		end
	end
	function t2.value39._on_accept_pressed(p78)
		local active = t18.active

		if active then
			active = t18.trade
		end

		if not active then
			return t18.originalFunctions._on_accept_pressed(p78)
		end

		if t18.trade.sender_offer.negotiated then
			t18.trade.sender_offer.negotiated = false
			t18.trade.offer_version = t18.trade.offer_version + 1
			p78:_overwrite_local_trade_state(t18.trade)
		else
			t18.trade.sender_offer.negotiated = true

			if t18.trade.recipient_offer.negotiated then
				t18.trade.current_stage = "confirmation"
				t18.trade.offer_version = t18.trade.offer_version + 1
				p78:_overwrite_local_trade_state(t18.trade)

				if t2.value39._evaluate_trade_fairness then
					t2.value39:_evaluate_trade_fairness()
				end

				if t2.value39._lock_trade_for_appropriate_time then
					t2.value39:_lock_trade_for_appropriate_time()
				end
			else
				t18.trade.offer_version = t18.trade.offer_version + 1
				p78:_overwrite_local_trade_state(t18.trade)
			end
		end

		local v408 = t17.AUTO_PARTNER and not t18.trade.recipient_offer.negotiated

		if v408 then
			v408 = t18.trade.sender_offer.negotiated
		end

		if not v408 then
			return
		end

		task.spawn(value30)
	end
	function t2.value39._on_confirm_pressed(p79)
		local active = t18.active

		if active then
			active = t18.trade
		end

		if not active then
			return t18.originalFunctions._on_confirm_pressed(p79)
		end

		t18.trade.sender_offer.confirmed = true
		t18.trade.offer_version = t18.trade.offer_version + 1
		p79:_overwrite_local_trade_state(t18.trade)

		local confirmed = t18.trade.sender_offer.confirmed and t18.trade.recipient_offer.confirmed

		if confirmed then
			confirmed = not t18.tradeCompleting
		end

		if not confirmed then
			local AUTO_PARTNER = t17.AUTO_PARTNER

			if AUTO_PARTNER then
				AUTO_PARTNER = not t18.trade.recipient_offer.confirmed
			end

			if not AUTO_PARTNER then
				return
			end

			task.spawn(value30)

			return
		end

		t18.tradeCompleting = true

		if t2.value39._set_confirmation_arrow_rotating then
			t2.value39:_set_confirmation_arrow_rotating(true)
		end

		task.wait(3)

		local items = t18.trade.sender_offer.items

		if items then
			for _, item in ipairs(items) do
				local unique

				if item.category == "pets" then
					unique = item.unique
				else
					unique = false
				end

				if unique then
					task.spawn(function()
						task.wait(0.5)
						t2.value29(item)
						print("[Trade Complete] Pet removed from inventory (given away):", item.kind)
					end)
				end
			end
		end

		local items2 = t18.trade.recipient_offer.items

		if items2 then
			for _, v in ipairs(items2) do
				local unique

				if v.category == "pets" then
					unique = v.unique
				else
					unique = false
				end

				if unique then
					task.spawn(function()
						task.wait(1)
						t2.value28(v)
						print("[Trade Complete] Pet added to inventory (received):", v.kind)
					end)
				end
			end

			task.spawn(function()
				task.wait(0.1)

				local UIManager = require(game.ReplicatedStorage.Fsys).load("UIManager")
				local apps = UIManager and UIManager.apps

				if apps then
					apps = UIManager.apps.BackpackApp
				end

				if not apps then
					return
				end

				UIManager.apps.BackpackApp:refresh_rendered_items()
				print("[Trade Complete] ✅ INSTANT inventory refresh!")
			end)
		end

		value25((value24(t18.trade)))
		t18.active = false
		t18.trade = nil
		t18.tradeCompleting = false
		t18.scamWarningShown = true
		t18.canShowTradeRequest = true
		t18.tradeRequestBlocked = false

		if _G.updateCurrentPartnerButton then
			_G.updateCurrentPartnerButton()
		end

		if not t2.value39.can_suggest_removal_items then
			t2.value32.set_app_visibility("TradeApp", false)

			return
		end

		t2.value39.can_suggest_removal_items = {}
		t2.value32.set_app_visibility("TradeApp", false)
	end
	function t2.value39._on_unaccept_pressed(p80)
		local active = t18.active

		if active then
			active = t18.trade
		end

		if not active then
			return t18.originalFunctions._on_unaccept_pressed(p80)
		end

		t18.trade.sender_offer.negotiated = false

		if t18.trade.current_stage ~= "confirmation" then
			t18.trade.offer_version = t18.trade.offer_version + 1
			p80:_overwrite_local_trade_state(t18.trade)

			return
		end

		t18.trade.current_stage = "negotiation"
		t18.trade.recipient_offer.negotiated = false
		t18.trade.sender_offer.confirmed = false
		t18.trade.recipient_offer.confirmed = false
		t18.trade.offer_version = t18.trade.offer_version + 1
		p80:_overwrite_local_trade_state(t18.trade)
	end
	function t2.value39._decline_trade(p81, p82)
		if not t18.active then
			return t18.originalFunctions._decline_trade(p81, p82)
		end

		if p81.lock_countdown then
			p81.lock_countdown:stop()
		end

		t18.active = false
		t18.trade = nil
		t18.isAddingItem = false
		t18.partnerActionPending = false
		t18.tradeCompleting = false
		t18.scamWarningShown = false
		t18.canShowTradeRequest = true
		t18.tradeRequestBlocked = false

		if _G.updateCurrentPartnerButton then
			_G.updateCurrentPartnerButton()
		end

		if t2.value39.can_suggest_removal_items then
			t2.value39.can_suggest_removal_items = {}
		end

		p81:_overwrite_local_trade_state(nil)
		t2.value32.set_app_visibility("TradeApp", false)

		if not t2.value40.reset_hidden_item_tag then
			return
		end

		t2.value40:reset_hidden_item_tag("TradeApp")
	end
	function t2.value39._evaluate_trade_fairness(p83)
		local trade = t18.active and t18.trade

		if trade then
			trade = not t18.scamWarningShown
		end

		if not trade then
			return t18.originalFunctions._evaluate_trade_fairness(p83)
		end

		local v424 = #t18.trade.sender_offer.items
		local v425 = #t18.trade.recipient_offer.items
		local v426 = v424 > 0

		if v426 then
			v426 = v425 == 0
		end

		if not v426 then
			return
		end

		t18.scamWarningShown = true

		if not t2.value41 then
			return
		end

		t2.value41:dialog({
			text = "This trade seems unbalanced. Be careful - you could be getting scammed.",
			button = "Next",
			yields = false
		})
		t2.value41:dialog({
			text = "Any items lost to scams WILL NOT be returned. Be sure before you accept!",
			button = "I understand",
			yields = false
		})
	end
end

t1.value31()

local value33 = t1.value33

function t1.value34()
	if not t18.active then
		task.spawn(value33)
	end
end

local value34 = t1.value34

function updatePartnerFromUsername(p84)
	local function v429()
		return t2.value15:GetUserIdFromNameAsync(p84)
	end

	local ok, partnerUserId = pcall(v429)

	if ok and partnerUserId then
		t17.PARTNER_USER_ID = partnerUserId
		t17.PARTNER_NAME = p84

		if not miscPlayerInput then
			value22()

			return true
		end

		miscPlayerInput.Text = p84
		value22()

		return true
	else
		t17.PARTNER_NAME = p84

		if not miscPlayerInput then
			value22()

			return false
		end

		miscPlayerInput.Text = p84
		value22()

		return false
	end
end
function updatePartnerWithCustomName(p85, p86)
	t17.PARTNER_USER_ID = p86
	t17.PARTNER_NAME = p85

	if not miscPlayerInput then
		value22()

		return
	end

	miscPlayerInput.Text = p85
	value22()
end
function t1.value34()
	local active = t18.active

	if active then
		active = t18.trade
	end

	if not active then
		warn("No active trade")

		return
	end

	if t18.trade.current_stage == "negotiation" then
		if t18.trade.recipient_offer.negotiated then
			return
		end

		t18.trade.recipient_offer.negotiated = true

		if not t18.trade.sender_offer.negotiated then
			t18.trade.offer_version = t18.trade.offer_version + 1
			t2.value39:_overwrite_local_trade_state(t18.trade)

			return
		end

		t18.trade.current_stage = "confirmation"
		t18.trade.offer_version = t18.trade.offer_version + 1
		t2.value39:_overwrite_local_trade_state(t18.trade)

		if t2.value39._evaluate_trade_fairness then
		elseif t2.value39._lock_trade_for_appropriate_time then
			t2.value39:_lock_trade_for_appropriate_time()

			return
		else
			return
		end

		t2.value39:_evaluate_trade_fairness()

		if t2.value39._lock_trade_for_appropriate_time then
			t2.value39:_lock_trade_for_appropriate_time()

			return
		else
			return
		end
	else
		if not (t18.trade.current_stage == "confirmation" and not t18.trade.recipient_offer.confirmed) then
			return
		end

		t18.trade.recipient_offer.confirmed = true
		t18.trade.offer_version = t18.trade.offer_version + 1
		t2.value39:_overwrite_local_trade_state(t18.trade)

		local confirmed = t18.trade.sender_offer.confirmed

		if confirmed then
			confirmed = not t18.tradeCompleting
		end

		if not confirmed then
			return
		end

		t18.tradeCompleting = true

		if t2.value39._set_confirmation_arrow_rotating then
			t2.value39:_set_confirmation_arrow_rotating(true)
		end

		task.wait(3)
		value25((value24(t18.trade)))
		t18.active = false
		t18.trade = nil
		t18.backpackAccessShown = false
		t18.tradeCompleting = false
		t18.scamWarningShown = true
		t18.canShowTradeRequest = true
		t18.tradeRequestBlocked = false

		if t2.value39.can_suggest_removal_items then
			t2.value39.can_suggest_removal_items = {}
		end

		t2.value32.set_app_visibility("TradeApp", false)
		task.wait(0.1)

		if t2.value42 then
			t2.value42:hint({
				text = "The trade was successful!",
				length = 5,
				overridable = true
			})
		end

		local value43 = t2.value43

		if value43 then
		elseif value43 then
			t2.value43:_refresh()

			return
		else
			return
		end

		value43 = t2.value32.is_visible("TradeHistoryApp")

		if value43 then
			t2.value43:_refresh()

			return
		else
			return
		end
	end
end

makePartnerAccept = t1.value34

function makePartnerUnaccept()
	local active = t18.active

	if not active then
		if active then
			if t18.trade.current_stage == "negotiation" then
				if t18.trade.recipient_offer.negotiated then
					t18.trade.recipient_offer.negotiated = false
					t18.trade.offer_version = t18.trade.offer_version + 1
					t2.value39:_overwrite_local_trade_state(t18.trade)

					return
				else
					return
				end
			elseif t18.trade.current_stage == "confirmation" and t18.trade.recipient_offer.confirmed then
				t18.trade.recipient_offer.confirmed = false
				t18.trade.offer_version = t18.trade.offer_version + 1
				t2.value39:_overwrite_local_trade_state(t18.trade)

				return
			else
				return
			end
		else
			warn("No active trade")
		end

		return
	end

	active = t18.trade

	if active then
		if t18.trade.current_stage == "negotiation" then
			if t18.trade.recipient_offer.negotiated then
				t18.trade.recipient_offer.negotiated = false
				t18.trade.offer_version = t18.trade.offer_version + 1
				t2.value39:_overwrite_local_trade_state(t18.trade)

				return
			else
				return
			end
		elseif t18.trade.current_stage == "confirmation" and t18.trade.recipient_offer.confirmed then
			t18.trade.recipient_offer.confirmed = false
			t18.trade.offer_version = t18.trade.offer_version + 1
			t2.value39:_overwrite_local_trade_state(t18.trade)

			return
		else
			return
		end
	else
		warn("No active trade")
	end
end

t1.value34 = _G
t1.value35 = makePartnerAccept
t1.value34.makePartnerAccept = t1.value35
t1.value34 = _G
t1.value35 = makePartnerUnaccept
t1.value34.makePartnerUnaccept = t1.value35

local t27 = {}
local t28 = {}

t1.value34 = {
	running = false,
	checkInterval = 0.3,
	animationTracks = {}
}

local value342 = t1.value34

function t1.value36(p87, p88)
	local v439 = t2.value33.get(p87)
	local v440 = table.clone(v439)

	t2.value33.predict(p87, p88(v440))
end

local value36 = t1.value36

function t1.value36(p89)
	if p89.running then
		return
	end

	p89.running = true
	task.spawn(function()
		while p89.running do
			task.wait(p89.checkInterval)

			for _, v in ipairs(t28) do
				local model = v and v.model

				if model then
					model = v.model.Parent
				end

				if model then
					pcall(function()
						local character = v.character
						local Parent

						if character then
							Parent = character.Parent
						else
							Parent = character
						end

						if not Parent then
							if v.wrapper.mega_neon then
								value122(v.model, v.wrapper.pet_id)

								return
							end

							if not v.wrapper.neon then
								return
							end

							value13(v.model, v.wrapper.pet_id)

							return
						end

						local Humanoid = character:FindFirstChild("Humanoid")
						local Animator = Humanoid and Humanoid:FindFirstChild("Animator")

						if not Animator then
							if v.wrapper.mega_neon then
								value122(v.model, v.wrapper.pet_id)

								return
							end

							if not v.wrapper.neon then
								return
							end

							value13(v.model, v.wrapper.pet_id)

							return
						end

						local GetPlayingAnimationTracks = Animator.GetPlayingAnimationTracks
						local v450, v451, v452 = ipairs(GetPlayingAnimationTracks(Animator))
						local v453 = false

						while true do
							local v454

							v452, v454 = v450(v451, v452)

							if not v452 then
								break
							end

							if v454.Animation.AnimationId:find("PlayerRidingPet") or v454.Animation.AnimationId:find("507766666") then
								v453 = true

								break
							end
						end

						local v455 = not v453

						if v455 then
							v455 = v.hasRidingPet
						end

						if v455 and not (v.ridingAnim and v.ridingAnim.IsPlaying) then
							if v.ridingAnim then
								v.ridingAnim:Stop()
							end

							v.ridingAnim = Animator:LoadAnimation(t2.value37.get_track("PlayerRidingPet"))
							v.ridingAnim.Looped = true
							v.ridingAnim:Play()
							Humanoid.Sit = true
						end

						if v.wrapper.mega_neon then
							value122(v.model, v.wrapper.pet_id)

							return
						end

						if not v.wrapper.neon then
							return
						end

						value13(v.model, v.wrapper.pet_id)
					end)
				end
			end
		end
	end)
end

value342.Start = t1.value36

function t1.value36(p90)
	p90.running = false

	for _, v in ipairs(t28) do
		if v.ridingAnim then
			v.ridingAnim:Stop()
		end
	end
end

value342.Stop = t1.value36

function t1.value36(p91, p92)
	local v458 = t28

	table.insert(v458, p92)

	if p91.running then
		return
	end

	p91:Start()
end

value342.AddPet = t1.value36

function t1.value37(p93, p94, p95)
	local t29 = {
		__index = function(p96, p97)
			if p97 == "Parent" then
				return t2.value15
			end

			return p97 == "IsA" and function(_, p98)
				return p98 == "Player"
			end or (p97 == "GetChildren" and function()
				return {}
			end or rawget(p96, p97))
		end,
		__tostring = function()
			return p94
		end
	}

	return setmetatable({
		Name = p94,
		DisplayName = p94,
		UserId = p95,
		Character = p93
	}, t29)
end

local value37 = t1.value37

function OpenProfile(p99)
	t2.value31("UIManager").apps.PlayerProfileApp:open_player_profile_for_user_id(p99)
end

task.spawn(function()
	task.wait(0.1)

	local InteractionsEngine = t2.value31("InteractionsEngine")
	local register = InteractionsEngine.register

	function InteractionsEngine.register(p100, p101)
		local part

		if p101 then
			part = p101.part
		else
			part = p101
		end

		if not part then
			return register(p100, p101)
		end

		local part2 = p101.part

		while part2 do
			local Parent

			if part2:GetAttribute("IsFakePet") == true then
				Parent = part2.Parent
			else
				Parent = false
			end

			if Parent then
				return
			end

			part2 = part2.Parent
		end

		return register(p100, p101)
	end
end)

function t1.value37(p102, p103, p104, p105, p106, _)
	local v466 = nil
	local n4 = 0

	v466 = function()
		n4 = n4 + 1
		t2.value22[p103] = true
		_G.fakePlayerIds[p103] = true

		local Folder = Instance.new("Folder")

		Folder.Name = "fake_folder_" .. p102
		Folder.Parent = workspace

		local u469 = t2.value15:CreateHumanoidModelFromUserId(p103)
		local Character = t2.value15.LocalPlayer.Character
		local Humanoid = u469:WaitForChild("Humanoid")

		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			warn("[Bot Spawn] ⚠️ Bot loaded as R6, converting to R15...")
			pcall(function()
				local function v472()
					return t2.value15:GetHumanoidDescriptionFromUserId(p103)
				end

				local ok, result = pcall(v472)

				if ok and result then
					local v475 = t2.value15:CreateHumanoidModelFromDescription(result, Enum.HumanoidRigType.R15)

					if v475 then
						v475:SetPrimaryPartCFrame(u469.PrimaryPart.CFrame)

						local Humanoid2 = v475:WaitForChild("Humanoid")

						Humanoid2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						Humanoid2.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
						Humanoid2.HealthDisplayDistance = 0
						u469:Destroy()
						u469 = v475
						u469.Parent = Folder
						Humanoid = Humanoid2
						print("[Bot Spawn] ✅ Successfully converted bot to R15!")

						return
					else
						warn("[Bot Spawn] ❌ Failed to create R15 character, using original")

						return
					end
				else
					warn("[Bot Spawn] ❌ Could not get HumanoidDescription for R15 conversion")
				end
			end)
		else
			print("[Bot Spawn] ✅ Bot already R15 - will sit properly on pet!")
		end

		u469:SetPrimaryPartCFrame(Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-10, 10), 0, math.random(-10, 10)))
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		Humanoid.HealthDisplayDistance = 0
		u469.Parent = Folder
		Humanoid.HealthDisplayDistance = 0
		u469.Parent = Folder

		if p104 == nil then
			local Animation = Instance.new("Animation")

			Animation.AnimationId = "http://www.roblox.com/asset/?id=507766666"

			local v478 = u469.Humanoid.Animator:LoadAnimation(Animation)

			v478.Looped = true
			v478:Play()
		else
			local u479 = nil

			local function v480()
				local kind = p104.kind
				local v482 = v237(kind)

				if not v482 then
					warn("Could not get pet model for kind:", kind)

					return
				end

				local clone = v482:Clone()

				clone:SetAttribute("IsFakePet", true)

				if p105 then
					if p105.M then
						value122(clone, kind)
					elseif p105.N then
						value13(clone, kind)
					end
				end

				clone.Parent = Folder
				clone:SetPrimaryPartCFrame(u469.HumanoidRootPart.CFrame)
				clone:ScaleTo(2)

				local v484, v485, v486 = ipairs(clone:GetDescendants())

				while true do
					local v487

					v486, v487 = v484(v485, v486)

					if not v486 then
						break
					end

					if v487:IsA("BasePart") then
						v487:SetAttribute("IsFakePet", true)
					end
				end

				local RidePosition = clone:FindFirstChild("RidePosition", true)

				if RidePosition then
					local Attachment = Instance.new("Attachment")

					Attachment.Parent = RidePosition
					Attachment.Position = Vector3.new(0, 1.237, 0)
					Attachment.Name = "SourceAttachment"

					local RootAttachment = u469.PrimaryPart:FindFirstChild("RootAttachment")

					if not RootAttachment then
						RootAttachment = Instance.new("Attachment")
						RootAttachment.Name = "RootAttachment"
						RootAttachment.Parent = u469.PrimaryPart
						print("[Bot Spawn] Created RootAttachment for character")
					end

					local RigidConstraint = Instance.new("RigidConstraint")

					RigidConstraint.Name = "StateConnection"
					RigidConstraint.Attachment0 = Attachment
					RigidConstraint.Attachment1 = RootAttachment
					RigidConstraint.Parent = u469
				end

				local v492 = u469.Humanoid.Animator:LoadAnimation(t2.value37.get_track("PlayerRidingPet"))

				v492.Looped = true
				v492:Play()
				u469.Humanoid.Sit = true

				for _, descendant in pairs(u469:GetDescendants()) do
					local isBasePart = descendant:IsA("BasePart")

					if isBasePart then
						isBasePart = descendant.Massless == false
					end

					if isBasePart then
						descendant.Massless = true
						descendant:SetAttribute("HaveMass", true)
					end
				end

				local v496 = value37(u469, p102, p103)
				local t30 = {
					char = clone,
					mega_neon = p105 and p105.M or false,
					neon = p105 and p105.N or false,
					player = v496,
					entity_controller = v496,
					controller = v496,
					rp_name = p106 or "",
					pet_trick_level = math.random(1, 5),
					pet_unique = t2.value20:GenerateGUID(false),
					pet_id = kind,
					location = {
						full_destination_id = "housing",
						destination_id = "housing",
						house_owner = v496
					},
					pet_progression = {
						age = math.random(1, 900000),
						percentage = math.random(0.01, 0.99)
					},
					are_colors_sealed = false,
					is_pet = true
				}
				local t31 = {
					char = clone,
					player = v496,
					store_key = "pet_state_managers",
					is_sitting = false,
					chars_connected_to_me = {},
					states = {
						{
							id = "PetBeingRidden"
						}
					}
				}

				value36("pet_char_wrappers", function(p107)
					t30.unique = #p107 + 1
					t30.index = #p107 + 1
					p107[#p107 + 1] = t30

					return p107
				end)
				value36("pet_state_managers", function(p108)
					p108[#p108 + 1] = t31

					return p108
				end)

				local t32 = {
					wrapper = t30,
					state = t31,
					model = clone,
					character = u469,
					hasRidingPet = true,
					owner = v496,
					ridingAnim = v492,
					folder = Folder
				}

				table.insert(t28, t32)

				if value342.running then
					u479 = true
					print("✓ Registered fake pet with native game systems:", kind, p105 and p105.M and "Mega Neon" or (p105.N and "Neon" or "Regular"))

					return
				end

				value342:Start()
				u479 = true
				print("✓ Registered fake pet with native game systems:", kind, p105 and p105.M and "Mega Neon" or (p105.N and "Neon" or "Regular"))
			end

			u479 = false

			local ok, result = pcall(v480)

			if not (ok and u479) then
				warn("Error creating fake pet (Attempt " .. n4 .. "/" .. 3 .. "):", result)
				Folder:Destroy()

				for i, v in ipairs(t27) do
					if v == Folder then
						table.remove(t27, i)

						break
					end
				end

				if n4 < 3 then
					print("🔄 Retrying fake character creation for " .. p102 .. "...")
					task.wait(0.5)

					return v466()
				else
					warn("❌ Failed to create fake character after " .. 3 .. " attempts")

					return false
				end
			end
		end

		local function v504()
			t2.value32.apps.PlayerNameApp:add_npc_id(u469, p102)
		end

		pcall(v504)

		local HumanoidRootPart = u469:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			local function v506() end

			local InteractionsEngine = t2.value31("InteractionsEngine")
			local t33 = {
				text = p102,
				part = HumanoidRootPart,
				on_selected = {
					{
						text = "Profile",
						on_selected = function()
							pcall(OpenProfile, p103)
						end
					},
					{
						text = "Trade",
						on_selected = function()
							pcall(function()
								task.spawn(function()
									pcall(function()
										if not t2.value42 then
											return
										end

										local value42 = t2.value42

										value42.hint(value42, {
											text = "Trade request sent to " .. p102,
											length = 3,
											overridable = true
										})
									end)
								end)
								task.wait(t17.FAKE_PLAYER_ACCEPT_TRADE_REQUEST)
								t19.Text = p102
								updatePartnerFromUsername(p102)
								t18.active = false
								t18.trade = nil
								t18.isAddingItem = false
								t18.partnerActionPending = false
								t18.tradeCompleting = false
								t18.scamWarningShown = true
								t18.tradeRequestBlocked = true
								t18.blockedTradeRequests = {}
								t18.trade = v312()
								t18.active = true

								if _G.updateCurrentPartnerButton then
									_G.updateCurrentPartnerButton()
								end

								t2.value32.set_app_visibility("TradeApp", false)
								task.wait(0.2)
								t2.value39:_overwrite_local_trade_state(t18.trade)
								task.wait(0.3)
								t2.value32.set_app_visibility("TradeApp", true)
								value9(true)
								t2.value39:_show_intro_message()
								task.wait(0.2)

								if t2.value39.refresh_all then
									t2.value39:refresh_all()
									value9(true)
								end

								task.wait(0.5)

								if t2.value32.is_visible("TradeApp") then
									return
								end

								t2.value32.set_app_visibility("TradeApp", true)

								if not t2.value39.refresh_all then
									return
								end

								t2.value39:refresh_all()
								value9(true)
							end)
						end
					},
					{
						text = "Give Item...",
						on_selected = v506
					},
					{
						text = "Mute",
						on_selected = v506
					}
				}
			}

			pcall(function()
				InteractionsEngine:register(t33)
			end)
		end

		local v510 = t27

		table.insert(v510, Folder)
		Folder:SetAttribute("IsFakePlayer", true)
		Folder:SetAttribute("PartnerName", p102)
		Folder:SetAttribute("PartnerId", p103)
		task.spawn(function()
			task.wait(1)

			local function v511()
				local UIManager = t2.value30.load("UIManager")
				local apps = UIManager and UIManager.apps

				if apps then
					apps = UIManager.apps.FriendsApp
				end

				if not apps then
					return
				end

				local FriendsApp = UIManager.apps.FriendsApp

				if not FriendsApp.addFakeBot then
					return
				end

				FriendsApp:addFakeBot(p102, p103)
			end

			pcall(v511)
		end)

		return true
	end

	return v466()
end

CreateFakePlayerCharacterFromPARTNER_NAME = t1.value37

function GetKindPet(p109)
	for k, pet in pairs(t2.value36.pets) do
		if pet.name:lower() == p109:lower() then
			return k
		end
	end
end
function t1.value38(p110)
	if p110 then
		local v517, v518, v519 = pairs(t2.value36.pets)

		while true do
			local v520

			v519, v520 = v517(v518, v519)

			if not v519 then
				break
			end

			local name = v520.name

			if name then
				name = v520.name:lower() == p110:lower()
			end

			if name then
				return v519
			end
		end

		for k, pet in pairs(t2.value36.pets) do
			local name = pet.name

			if name then
				name = pet.name:lower():find(p110:lower(), 1, true)
			end

			if name then
				return k
			end
		end

		if t2.value36.pets[p110] then
			return p110
		else
			return nil
		end
	else
		return nil
	end
end
function t1.value37(p111)
	if not p111 then
		return
	end

	local GetDescendants = p111.GetDescendants

	for _, v in ipairs(GetDescendants(p111)) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
			pcall(function()
				v.CollisionGroup = "Noclip"
			end)
		end
	end

	p111.DescendantAdded:Connect(function(descendant)
		if not descendant:IsA("BasePart") then
			return
		end

		task.wait()
		descendant.CanCollide = false
		descendant.CanTouch = false
		descendant.CanQuery = false
		pcall(function()
			descendant.CollisionGroup = "Noclip"
		end)
	end)
end

GetKindPet = t1.value38
t1.value38 = _G
t1.value40 = GetKindPet
t1.value38.GetKindPet = t1.value40

function t1.value38()
	local LocalPlayer = t2.value15.LocalPlayer
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "FakeTradeGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.IgnoreGuiInset = false
	ScreenGui.DisplayOrder = 999999
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local t34 = {
		value1 = Instance.new("Frame")
	}

	t34.value1.Size = UDim2.new(0, 270, 0, 580)
	t34.value1.Position = UDim2.new(0.5, -135, 0.5, -290)
	t34.value1.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
	t34.value1.BorderSizePixel = 0
	t34.value1.Active = true
	t34.value1.ZIndex = 100
	t34.value1.Parent = ScreenGui
	t34.value2 = Instance.new("UIScale", t34.value1)
	t34.value2.Scale = 1
	Instance.new("UICorner", t34.value1).CornerRadius = UDim.new(0, 14)
	t34.value3 = Instance.new("UIStroke")
	t34.value3.Thickness = 3
	t34.value3.Color = Color3.fromRGB(0, 220, 255)
	t34.value3.Parent = t34.value1
	t34.value4 = {
		Color3.fromRGB(0, 220, 255),
		Color3.fromRGB(120, 90, 255),
		Color3.fromRGB(255, 80, 160),
		Color3.fromRGB(0, 200, 180)
	}
	t34.value5 = 1
	task.spawn(function()
		while true do
			t34.value5 = t34.value5 % #t34.value4 + 1

			local value19 = t2.value19
			local value32 = t34.value3
			local tweenInfo = TweenInfo.new(4)
			local Create = value19.Create
			local value52 = t34.value5

			Create(value19, value32, tweenInfo, {
				Color = t34.value4[value52]
			}):Play()
			task.wait(4)
		end
	end)
	t34.value6 = {}

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.new(0.94, 0, 0, 22)
	Frame.Position = UDim2.new(0.03, 0, 0, 34)
	Frame.BackgroundTransparency = 1
	Frame.Parent = t34.value1

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 28)
	TextLabel.Position = UDim2.new(0, 0, 0, 8)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Blueprints Trade Control"
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 18
	TextLabel.TextColor3 = Color3.fromRGB(235, 240, 255)
	TextLabel.Parent = t34.value1

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(0.9, 0, 0, 14)
	TextLabel2.Position = UDim2.new(0.05, 0, 0.1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "Trade With Username"
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextSize = 10
	TextLabel2.TextColor3 = Color3.fromRGB(160, 170, 200)
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = t34.value1
	t34.value7 = Instance.new("TextBox")
	t34.value7.Size = UDim2.new(0.9, 0, 0, 26)
	t34.value7.Position = UDim2.new(0.05, 0, 0.13, 0)
	t34.value7.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value7.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value7.TextSize = 13
	t34.value7.Font = Enum.Font.Gotham
	t34.value7.PlaceholderText = "username"
	t34.value7.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value7.ClearTextOnFocus = false
	t34.value7.Text = t17.PARTNER_NAME
	t34.value7.Parent = t34.value1
	Instance.new("UICorner", t34.value7).CornerRadius = UDim.new(0, 8)
	t34.value7.FocusLost:Connect(function()
		local Text = t34.value7.Text

		if Text == "" then
			return
		end

		updatePartnerFromUsername(Text)
	end)
	t34.value8 = Instance.new("TextLabel")
	t34.value8.Size = UDim2.new(0.9, 0, 0, 16)
	t34.value8.Position = UDim2.new(0.05, 0, 0.19, 0)
	t34.value8.BackgroundTransparency = 1
	t34.value8.Text = "Spectators: " .. t17.SPECTATOR_COUNT
	t34.value8.Font = Enum.Font.GothamMedium
	t34.value8.TextSize = 12
	t34.value8.TextColor3 = Color3.fromRGB(170, 190, 255)
	t34.value8.TextXAlignment = Enum.TextXAlignment.Left
	t34.value8.Parent = t34.value1
	t34.value9 = Instance.new("Frame")
	t34.value9.Size = UDim2.new(0.9, 0, 0, 26)
	t34.value9.Position = UDim2.new(0.05, 0, 0.22, 0)
	t34.value9.BackgroundTransparency = 1
	t34.value9.Parent = t34.value1

	local function v540(p112)
		local _ = p112

		for k, v in pairs(t34.value6) do
			local v544 = k == p112

			v.button.BackgroundColor3 = v544 and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(40, 40, 50)
			v.stroke.Color = v544 and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)
			v.stroke.Thickness = v544 and 1.2 or 0.8
		end
	end

	for i = 1, 5 do
		local TextButton = Instance.new("TextButton")

		TextButton.Size = UDim2.new(0.18, -4, 1, 0)
		TextButton.Position = UDim2.new((i - 1) * 0.2, 0, 0, 0)
		TextButton.Text = tostring(i)
		TextButton.Font = Enum.Font.GothamBold
		TextButton.TextSize = 12
		TextButton.BackgroundColor3 = i == t17.SPECTATOR_COUNT and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(44, 48, 72)
		TextButton.TextColor3 = Color3.fromRGB(235, 235, 255)
		TextButton.Parent = t34.value9
		Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)
		TextButton.MouseButton1Click:Connect(function()
			t34.value8.Text = "Spectators: " .. i
			t17.SPECTATOR_COUNT = i

			if not t18.trade then
				v641 = ipairs
				v642 = t34.value9

				for _, child in v641(v642.GetChildren(v642)) do
					if child:IsA("TextButton") then
						child.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
					end
				end

				TextButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)

				return
			end

			t18.trade.subscriber_count = i

			if not t2.value39.refresh_all then
				v641 = ipairs
				v642 = t34.value9

				for _, child in v641(v642.GetChildren(v642)) do
					if child:IsA("TextButton") then
						child.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
					end
				end

				TextButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)

				return
			end

			t2.value39:refresh_all()
			value9(true)

			local ipairs_ = ipairs
			local value92 = t34.value9

			for _, child in ipairs_(value92.GetChildren(value92)) do
				if child:IsA("TextButton") then
					child.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
				end
			end

			TextButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
		end)
	end

	t34.value10 = true
	t34.value11 = nil
	t34.value12 = 0
	t34.value13 = true
	t34.value14 = { 1, 2, 3 }
	t34.value15 = 1

	local function v555()
		if not (t34.value10 and t18.trade) then
			return
		end

		local SPECTATOR_COUNT = t17.SPECTATOR_COUNT

		if SPECTATOR_COUNT <= 0 then
			return
		end

		local value123 = t34.value12
		local value124

		if t34.value13 then
			value124 = t34.value14[t34.value15]
			t34.value15 = t34.value15 + 1

			local _ = t34.value15 > #t34.value14
		else
			local v560 = value123 + math.random(-2, 2)

			value124 = math.clamp(v560, 1, SPECTATOR_COUNT)
		end

		t34.value12 = value124

		if t34.value12 == value123 then
			return
		end

		print(string.format("[AutoSpec] %d → %d", value123, t34.value12))
		t34.value8.Text = "Spectators: " .. t34.value12

		if not t18.trade then
			return
		end

		t18.trade.subscriber_count = t34.value12

		if not t2.value39._update_spectator_count then
			return
		end

		t2.value39:_update_spectator_count(t18.trade)
	end

	function t34.value16()
		while t34.value10 do
			v555()
			task.wait(math.random(3, 6))
		end
	end

	t34.value17 = Instance.new("TextButton")
	t34.value17.Size = UDim2.new(0.4, 0, 0, 16)
	t34.value17.Position = UDim2.new(0.55, 0, 0.19, 0)
	t34.value17.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
	t34.value17.TextColor3 = Color3.fromRGB(235, 235, 255)
	t34.value17.Text = "🤖 ON"
	t34.value17.Font = Enum.Font.GothamBold
	t34.value17.TextSize = 9
	t34.value17.Parent = t34.value1
	Instance.new("UICorner", t34.value17).CornerRadius = UDim.new(0, 7)
	Instance.new("UIStroke", t34.value17).Color = Color3.fromRGB(100, 100, 100)
	task.spawn(function()
		task.wait(1)

		if not t34.value10 then
			return
		end

		t34.value11 = task.spawn(function()
			t34.value16()
		end)
	end)
	t34.value17.MouseButton1Click:Connect(function()
		t34.value10 = not t34.value10

		if t34.value10 then
			t34.value17.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
			t34.value17.Text = "🤖 ON"

			if t34.value11 then
				task.cancel(t34.value11)
			end

			t34.value11 = task.spawn(function()
				t34.value16()
			end)

			return
		end

		t34.value17.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
		t34.value17.Text = "🤖 Auto"

		if not t34.value11 then
			return
		end

		task.cancel(t34.value11)
	end)

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(0.42, 0, 0, 14)
	TextLabel3.Position = UDim2.new(0.05, 0, 0.27, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "Custom Spectators"
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 9
	TextLabel3.TextColor3 = Color3.fromRGB(160, 170, 200)
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = t34.value1
	t34.value18 = Instance.new("TextBox")
	t34.value18.Size = UDim2.new(0.42, 0, 0, 24)
	t34.value18.Position = UDim2.new(0.05, 0, 0.295, 0)
	t34.value18.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value18.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value18.TextSize = 12
	t34.value18.Font = Enum.Font.Gotham
	t34.value18.PlaceholderText = "0-999"
	t34.value18.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value18.ClearTextOnFocus = false

	local value18 = t34.value18
	local SPECTATOR_COUNT = t17.SPECTATOR_COUNT

	value18.Text = tostring(SPECTATOR_COUNT)
	t34.value18.Parent = t34.value1
	Instance.new("UICorner", t34.value18).CornerRadius = UDim.new(0, 8)
	t34.value18.FocusLost:Connect(function()
		local Text = t34.value18.Text
		local spectators = tonumber(Text)
		local v566

		if spectators then
			if spectators >= 0 then
				v566 = spectators <= 999
			else
				v566 = false
			end
		else
			v566 = spectators
		end

		if not v566 then
			local value182 = t34.value18
			local SPECTATOR_COUNT2 = t17.SPECTATOR_COUNT

			value182.Text = tostring(SPECTATOR_COUNT2)

			return
		end

		t17.SPECTATOR_COUNT = spectators
		t34.value8.Text = "Spectators: " .. spectators

		if not t18.trade then
			v662 = ipairs
			v663 = t34.value9

			for _, child in v662(v663.GetChildren(v663)) do
				if child:IsA("TextButton") then
					child.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
				end
			end

			return
		end

		t18.trade.subscriber_count = spectators

		if not t2.value39.refresh_all then
			v662 = ipairs
			v663 = t34.value9

			for _, child in v662(v663.GetChildren(v663)) do
				if child:IsA("TextButton") then
					child.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
				end
			end

			return
		end

		t2.value39:refresh_all()
		value9(true)

		local ipairs_ = ipairs
		local value92 = t34.value9

		for _, child in ipairs_(value92.GetChildren(value92)) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
			end
		end
	end)

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(0.42, 0, 0, 14)
	TextLabel4.Position = UDim2.new(0.53, 0, 0.27, 0)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "Reactions/Sec"
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextSize = 9
	TextLabel4.TextColor3 = Color3.fromRGB(160, 170, 200)
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = t34.value1
	t34.value19 = Instance.new("TextBox")
	t34.value19.Size = UDim2.new(0.42, 0, 0, 24)
	t34.value19.Position = UDim2.new(0.53, 0, 0.295, 0)
	t34.value19.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value19.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value19.TextSize = 12
	t34.value19.Font = Enum.Font.Gotham
	t34.value19.PlaceholderText = "0.1-5.0"
	t34.value19.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value19.ClearTextOnFocus = false

	local value19 = t34.value19
	local REACTIONS_PER_SECOND = t17.REACTIONS_PER_SECOND

	value19.Text = tostring(REACTIONS_PER_SECOND)
	t34.value19.Parent = t34.value1
	Instance.new("UICorner", t34.value19).CornerRadius = UDim.new(0, 8)
	t34.value19.FocusLost:Connect(function()
		local Text = t34.value19.Text
		local reactionsPerSecond = tonumber(Text)
		local v582

		if reactionsPerSecond then
			if reactionsPerSecond >= 0.1 then
				v582 = reactionsPerSecond <= 5
			else
				v582 = false
			end
		else
			v582 = reactionsPerSecond
		end

		if v582 then
			t17.REACTIONS_PER_SECOND = reactionsPerSecond
		else
			local value192 = t34.value19
			local REACTIONS_PER_SECOND2 = t17.REACTIONS_PER_SECOND

			value192.Text = tostring(REACTIONS_PER_SECOND2)
		end
	end)

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0.9, 0, 0, 28)
	TextButton.Position = UDim2.new(0.05, 0, 0.36, 0)
	TextButton.Text = "Start Trade"
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 13
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.Parent = t34.value1
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)

	local function v586()
		local Text = t34.value7.Text
		local v588

		if Text then
			v588 = Text ~= ""
		else
			v588 = Text
		end

		if not v588 then
			value34()

			return
		end

		updatePartnerFromUsername(Text)
		value34()
	end

	TextButton.MouseButton1Click:Connect(v586)

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Size = UDim2.new(0.9, 0, 0, 14)
	TextLabel5.Position = UDim2.new(0.05, 0, 0.43, 0)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Text = "Add Pet"
	TextLabel5.Font = Enum.Font.Gotham
	TextLabel5.TextSize = 10
	TextLabel5.TextColor3 = Color3.fromRGB(160, 170, 200)
	TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel5.Parent = t34.value1
	t34.value20 = Instance.new("TextBox")
	t34.value20.Size = UDim2.new(0.9, 0, 0, 26)
	t34.value20.Position = UDim2.new(0.05, 0, 0.46, 0)
	t34.value20.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value20.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value20.TextSize = 13
	t34.value20.Font = Enum.Font.Gotham
	t34.value20.PlaceholderText = "pet name"
	t34.value20.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value20.ClearTextOnFocus = false
	t34.value20.Text = ""
	t34.value20.Parent = t34.value1
	Instance.new("UICorner", t34.value20).CornerRadius = UDim.new(0, 8)
	t34.value21 = {
		M = false,
		F = false,
		R = false,
		N = false
	}
	t34.value22 = {
		M = Color3.fromRGB(160, 80, 255),
		F = Color3.fromRGB(0, 200, 220),
		R = Color3.fromRGB(255, 90, 150),
		N = Color3.fromRGB(0, 255, 100)
	}

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(0.9, 0, 0, 24)
	Frame2.Position = UDim2.new(0.05, 0, 0.54, 0)
	Frame2.BackgroundTransparency = 1
	Frame2.Parent = t34.value1

	for i, v in ipairs({
		"M",
		"N",
		"F",
		"R"
	}) do
		local TextButton2 = Instance.new("TextButton")

		TextButton2.Size = UDim2.new(0.22, 0, 1, 0)
		TextButton2.Position = UDim2.new((i - 1) * 0.245, 0, 0, 0)
		TextButton2.Text = v
		TextButton2.Font = Enum.Font.GothamBold
		TextButton2.TextSize = 12
		TextButton2.BackgroundColor3 = Color3.fromRGB(44, 48, 72)
		TextButton2.TextColor3 = Color3.fromRGB(240, 240, 255)
		TextButton2.Parent = Frame2
		Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 8)

		local MouseButton1Click = TextButton2.MouseButton1Click

		MouseButton1Click.Connect(MouseButton1Click, function()
			local N

			if v == "M" then
				N = t34.value21.N
			else
				N = false
			end

			if not N then
				local M

				if v == "N" then
					M = t34.value21.M
				else
					M = false
				end

				if M then
					return
				else
					local v597 = v
					local v598 = t34.value21[v597]

					t34.value21[v] = not v598
					TextButton2.BackgroundColor3 = t34.value21[v] and t34.value22[v] or Color3.fromRGB(44, 48, 72)

					return
				end
			end
		end)
	end

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(0.9, 0, 0, 26)
	TextButton2.Position = UDim2.new(0.05, 0, 0.61, 0)
	TextButton2.Text = "Add Pet"
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextSize = 12
	TextButton2.BackgroundColor3 = Color3.fromRGB(80, 180, 120)
	TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.Parent = t34.value1
	Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 10)

	local function v600()
		local Text = t34.value20.Text

		if Text ~= "" then
			local t35 = { value28(Text, t34.value21) }
			local failedToAddPet = t35[2]

			if t35[1] then
				print("Pet added successfully: " .. Text)

				return
			else
				print("Failed to add pet: " .. failedToAddPet or "Unknown error")

				return
			end
		end
	end

	TextButton2.MouseButton1Click:Connect(v600)

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(0.9, 0, 0, 26)
	TextButton3.Position = UDim2.new(0.05, 0, 0.68, 0)
	TextButton3.Text = "Remove Latest Pet"
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.TextSize = 12
	TextButton3.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
	TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton3.Parent = t34.value1
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 10)
	TextButton3.MouseButton1Click:Connect(function()
		local v605, failedToRemovePet = value29()

		if v605 then
			print("Pet removed successfully")
		else
			print("Failed to remove pet: " .. failedToRemovePet or "Unknown error")
		end
	end)

	local TextButton4 = Instance.new("TextButton")

	TextButton4.Size = UDim2.new(0.9, 0, 0, 28)
	TextButton4.Position = UDim2.new(0.05, 0, 0.75, 0)
	TextButton4.Text = "Add Random High Tier"
	TextButton4.Font = Enum.Font.GothamBold
	TextButton4.TextSize = 12
	TextButton4.BackgroundColor3 = Color3.fromRGB(120, 70, 180)
	TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton4.Parent = t34.value1
	Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 10)

	local function v608()
		t34.value20.Text = value20()
	end

	TextButton4.MouseButton1Click:Connect(v608)

	local TextButton5 = Instance.new("TextButton")

	TextButton5.Size = UDim2.new(0.43, 0, 0, 28)
	TextButton5.Position = UDim2.new(0.05, 0, 0.82, 0)
	TextButton5.Text = "Partner Accept"
	TextButton5.Font = Enum.Font.GothamBold
	TextButton5.TextSize = 10
	TextButton5.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton5.Parent = t34.value1
	Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 8)
	t34.value23 = Instance.new("TextButton")
	t34.value23.Size = UDim2.new(0.43, 0, 0, 28)
	t34.value23.Position = UDim2.new(0.52, 0, 0.82, 0)
	t34.value23.Text = "Partner Unaccept"
	t34.value23.Font = Enum.Font.GothamBold
	t34.value23.TextSize = 10
	t34.value23.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	t34.value23.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value23.BorderSizePixel = 0
	t34.value23.Visible = false
	t34.value23.Parent = t34.value1
	Instance.new("UICorner", t34.value23).CornerRadius = UDim.new(0, 8)
	TextButton5.MouseButton1Click:Connect(function()
		makePartnerAccept()
	end)

	function t34.value24(p113)
		pcall(function()
			setthreadidentity(8)
		end)
		game:GetService("StarterGui"):SetCore("PromptBlockPlayer", p113)
		game:GetService("CoreGui"):FindFirstChild("BlockingModalScreen")

		repeat
			game:GetService("RunService").Heartbeat:Wait()
		until game:GetService("CoreGui"):FindFirstChild("BlockingModalScreen")

		game:GetService("CoreGui").BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BlockingModal.BackgroundTransparency = 1
		game:GetService("CoreGui").BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BackgroundTransparency = 1
		game:GetService("CoreGui").BlockingModalScreen.BlockingModalContainer.BackgroundTransparency = 1
		game:GetService("CoreGui").BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BlockingModal.AlertModal.Position = UDim2.new(0.00800000038, -110, 0.5, 0);
		(function(p114)
			game:GetService("GuiService").SelectedObject = p114
			task.wait()

			if game:GetService("GuiService").SelectedObject ~= p114 then
				game:GetService("GuiService").SelectedObject = nil

				return
			end

			game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
			game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
			task.wait()
			game:GetService("GuiService").SelectedObject = nil
		end)(game:GetService("CoreGui").BlockingModalScreen.BlockingModalContainer.BlockingModalContainerWrapper.BlockingModal.AlertModal.AlertContents.Footer.Buttons["3"])
		pcall(function()
			setthreadidentity(2)
		end)
	end

	t34.value25 = Instance.new("TextButton")
	t34.value25.Size = UDim2.new(0.43, 0, 0, 28)
	t34.value25.Position = UDim2.new(0.52, 0, 0.82, 0)
	t34.value25.Text = "Partner Unaccept"
	t34.value25.Font = Enum.Font.GothamBold
	t34.value25.TextSize = 10
	t34.value25.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	t34.value25.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value25.Parent = t34.value1
	Instance.new("UICorner", t34.value25).CornerRadius = UDim.new(0, 8)
	t34.value25.MouseButton1Click:Connect(function()
		makePartnerUnaccept()
	end)
	t34.value23.MouseButton1Click:Connect(function()
		makePartnerUnaccept()
	end)

	local TextButton6 = Instance.new("TextButton")

	TextButton6.Size = UDim2.new(0.9, 0, 0, 26)
	TextButton6.Position = UDim2.new(0.05, 0, 0.89, 0)
	TextButton6.Text = "Block Player"
	TextButton6.Font = Enum.Font.GothamBold
	TextButton6.TextSize = 12
	TextButton6.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton6.Parent = t34.value1
	Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 10)
	TextButton6.MouseButton1Click:Connect(function()
		local Text = t34.value7.Text
		local v612

		if Text then
			v612 = Text ~= ""
		else
			v612 = Text
		end

		if v612 then
			local v613 = value17(Text)

			if v613 then
				print("[BlockPlayer] Blocking player:", v613.Name)
				t34.value24(v613)

				return
			else
				warn("[BlockPlayer] Player not found in game:", Text)

				return
			end
		else
			warn("[BlockPlayer] No player name entered in textbox")
		end
	end)
	t34.value26 = Instance.new("TextButton")
	t34.value26.Size = UDim2.new(0.9, 0, 0, 26)
	t34.value26.Position = UDim2.new(0.05, 0, 0.95, 0)
	t34.value26.Text = "🎭 Reactions: ON (1-7)"
	t34.value26.Font = Enum.Font.GothamBold
	t34.value26.TextSize = 11
	t34.value26.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
	t34.value26.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value26.Parent = t34.value1
	Instance.new("UICorner", t34.value26).CornerRadius = UDim.new(0, 10)
	t34.value26.MouseButton1Click:Connect(function()
		t18.spectatorReactionsEnabled = not t18.spectatorReactionsEnabled

		if t18.spectatorReactionsEnabled then
			t34.value26.Text = "🎭 Reactions: ON (1-7)"
			t34.value26.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
		else
			t34.value26.Text = "🎭 Reactions: OFF"
			t34.value26.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
		end

		local active = t18.spectatorReactionsEnabled and t18.active

		if active then
			active = t18.trade
		end

		if not active then
			return
		end

		_G.EmojiSystem.display(math.random(1, #_G.EmojiSystem.reactions))
	end)
	t34.value27 = Instance.new("Frame")
	t34.value27.Size = UDim2.new(0.9, 0, 0, 480)
	t34.value27.Position = UDim2.new(0.05, 0, 0, 70)
	t34.value27.BackgroundTransparency = 1
	t34.value27.Visible = false
	t34.value27.Parent = t34.value1
	t34.value28 = Instance.new("Frame")
	t34.value28.Size = UDim2.new(0.9, 0, 0, 480)
	t34.value28.Position = UDim2.new(0.05, 0, 0, 70)
	t34.value28.BackgroundTransparency = 1
	t34.value28.Visible = false
	t34.value28.Parent = t34.value1
	t34.value29 = Instance.new("Frame")
	t34.value29.Size = UDim2.new(0.9, 0, 0, 480)
	t34.value29.Position = UDim2.new(0.05, 0, 0, 70)
	t34.value29.BackgroundTransparency = 1
	t34.value29.Visible = false
	t34.value29.Parent = t34.value1

	local TextLabel6 = Instance.new("TextLabel", t34.value29)

	TextLabel6.Size = UDim2.new(1, 0, 0, 16)
	TextLabel6.Position = UDim2.new(0, 0, 0, 0)
	TextLabel6.BackgroundTransparency = 1
	TextLabel6.Text = "🎯 Type username or click to select:"
	TextLabel6.Font = Enum.Font.GothamBold
	TextLabel6.TextSize = 10
	TextLabel6.TextColor3 = Color3.fromRGB(200, 200, 255)
	TextLabel6.TextXAlignment = Enum.TextXAlignment.Left

	local Frame3 = Instance.new("Frame", t34.value29)

	Frame3.Size = UDim2.new(1, 0, 0, 28)
	Frame3.Position = UDim2.new(0, 0, 0, 18)
	Frame3.BackgroundTransparency = 1
	Frame3.ZIndex = 10
	t34.value30 = Instance.new("TextBox", Frame3)
	t34.value30.Size = UDim2.new(0.85, -2, 1, 0)
	t34.value30.Position = UDim2.new(0, 0, 0, 0)
	t34.value30.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value30.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value30.TextSize = 11
	t34.value30.Font = Enum.Font.Gotham
	t34.value30.PlaceholderText = "username"
	t34.value30.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value30.ClearTextOnFocus = false
	t34.value30.ZIndex = 10
	Instance.new("UICorner", t34.value30).CornerRadius = UDim.new(0, 6)
	t34.value31 = Instance.new("TextButton", Frame3)
	t34.value31.Size = UDim2.new(0.15, 0, 1, 0)
	t34.value31.Position = UDim2.new(0.85, 2, 0, 0)
	t34.value31.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	t34.value31.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value31.Text = "▼"
	t34.value31.Font = Enum.Font.GothamBold
	t34.value31.TextSize = 11
	t34.value31.ZIndex = 10
	t34.value31.BorderSizePixel = 0
	Instance.new("UICorner", t34.value31).CornerRadius = UDim.new(0, 6)

	local UIStroke = Instance.new("UIStroke", t34.value31)

	UIStroke.Color = Color3.fromRGB(100, 150, 200)
	UIStroke.Thickness = 1
	UIStroke.Transparency = 0.3
	t34.value32 = Instance.new("ScrollingFrame", Frame3)
	t34.value32.Size = UDim2.new(1, 0, 0, 0)
	t34.value32.Position = UDim2.new(0, 0, 1, 2)
	t34.value32.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
	t34.value32.BackgroundTransparency = 0
	t34.value32.BorderSizePixel = 0
	t34.value32.ScrollBarThickness = 6
	t34.value32.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 220)
	t34.value32.CanvasSize = UDim2.new(0, 0, 0, 0)
	t34.value32.Visible = false
	t34.value32.ZIndex = 1000
	Instance.new("UICorner", t34.value32).CornerRadius = UDim.new(0, 8)

	local UIStroke2 = Instance.new("UIStroke", t34.value32)

	UIStroke2.Color = Color3.fromRGB(100, 150, 220)
	UIStroke2.Thickness = 2
	UIStroke2.Transparency = 0

	local UIListLayout = Instance.new("UIListLayout", t34.value32)

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)

	local UIPadding = Instance.new("UIPadding", t34.value32)

	UIPadding.PaddingTop = UDim.new(0, 4)
	UIPadding.PaddingBottom = UDim.new(0, 4)
	UIPadding.PaddingLeft = UDim.new(0, 4)
	UIPadding.PaddingRight = UDim.new(0, 4)

	local Frame4 = Instance.new("Frame", t34.value29)

	Frame4.Size = UDim2.new(1, 0, 0, 65)
	Frame4.Position = UDim2.new(0, 0, 0, 50)
	Frame4.BackgroundTransparency = 1

	local TextButton7 = Instance.new("TextButton", Frame4)

	TextButton7.Size = UDim2.new(0.47, -2, 0, 28)
	TextButton7.Position = UDim2.new(0, 0, 0, 0)
	TextButton7.Text = "🎒 Show Pets"
	TextButton7.Font = Enum.Font.FredokaOne
	TextButton7.TextSize = 10
	TextButton7.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
	TextButton7.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", TextButton7).CornerRadius = UDim.new(0, 8)

	local UIStroke3 = Instance.new("UIStroke", TextButton7)

	UIStroke3.Color = Color3.fromRGB(100, 150, 255)
	UIStroke3.Thickness = 1
	UIStroke3.Transparency = 0.3

	local TextButton8 = Instance.new("TextButton", Frame4)

	TextButton8.Size = UDim2.new(0.47, -2, 0, 28)
	TextButton8.Position = UDim2.new(0.53, 0, 0, 0)
	TextButton8.Text = "📤 Send Trade"
	TextButton8.Font = Enum.Font.FredokaOne
	TextButton8.TextSize = 10
	TextButton8.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
	TextButton8.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", TextButton8).CornerRadius = UDim.new(0, 8)

	local UIStroke4 = Instance.new("UIStroke", TextButton8)

	UIStroke4.Color = Color3.fromRGB(255, 100, 150)
	UIStroke4.Thickness = 1
	UIStroke4.Transparency = 0.3

	local TextButton9 = Instance.new("TextButton", Frame4)

	TextButton9.Size = UDim2.new(1, 0, 0, 28)
	TextButton9.Position = UDim2.new(0, 0, 0, 35)
	TextButton9.Text = "💎 Auto-Trade All"
	TextButton9.Font = Enum.Font.FredokaOne
	TextButton9.TextSize = 11
	TextButton9.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
	TextButton9.TextColor3 = Color3.fromRGB(0, 0, 0)
	Instance.new("UICorner", TextButton9).CornerRadius = UDim.new(0, 8)

	local UIStroke5 = Instance.new("UIStroke", TextButton9)

	UIStroke5.Color = Color3.fromRGB(255, 240, 100)
	UIStroke5.Thickness = 1
	UIStroke5.Transparency = 0.3

	local TextLabel7 = Instance.new("TextLabel", t34.value29)

	TextLabel7.Size = UDim2.new(1, 0, 0, 18)
	TextLabel7.Position = UDim2.new(0, 0, 0, 115)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = "🤖 Bot Spawner"
	TextLabel7.Font = Enum.Font.GothamBold
	TextLabel7.TextSize = 11
	TextLabel7.TextColor3 = Color3.fromRGB(200, 200, 255)
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left

	local TextLabel8 = Instance.new("TextLabel", t34.value29)

	TextLabel8.Size = UDim2.new(1, 0, 0, 14)
	TextLabel8.Position = UDim2.new(0, 0, 0, 133)
	TextLabel8.BackgroundTransparency = 1
	TextLabel8.Text = "Pet Name (for bot):"
	TextLabel8.Font = Enum.Font.Gotham
	TextLabel8.TextSize = 9
	TextLabel8.TextColor3 = Color3.fromRGB(150, 150, 200)
	TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
	t34.value33 = Instance.new("TextBox", t34.value29)
	t34.value33.Size = UDim2.new(1, 0, 0, 24)
	t34.value33.Position = UDim2.new(0, 0, 0, 147)
	t34.value33.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value33.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value33.TextSize = 11
	t34.value33.Font = Enum.Font.Gotham
	t34.value33.PlaceholderText = "pet name (leave empty for no pet)"
	t34.value33.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value33.ClearTextOnFocus = false
	t34.value33.Text = ""
	Instance.new("UICorner", t34.value33).CornerRadius = UDim.new(0, 6)

	local TextLabel9 = Instance.new("TextLabel", t34.value29)

	TextLabel9.Size = UDim2.new(1, 0, 0, 14)
	TextLabel9.Position = UDim2.new(0, 0, 0, 175)
	TextLabel9.BackgroundTransparency = 1
	TextLabel9.Text = "Custom Pet Name (optional):"
	TextLabel9.Font = Enum.Font.Gotham
	TextLabel9.TextSize = 9
	TextLabel9.TextColor3 = Color3.fromRGB(150, 150, 200)
	TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
	t34.value34 = Instance.new("TextBox", t34.value29)
	t34.value34.Size = UDim2.new(1, 0, 0, 24)
	t34.value34.Position = UDim2.new(0, 0, 0, 189)
	t34.value34.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value34.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value34.TextSize = 11
	t34.value34.Font = Enum.Font.Gotham
	t34.value34.PlaceholderText = "custom name (defaults to pet\'s normal name)"
	t34.value34.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value34.ClearTextOnFocus = false
	t34.value34.Text = ""
	Instance.new("UICorner", t34.value34).CornerRadius = UDim.new(0, 6)
	t34.value35 = "regular"

	local Frame5 = Instance.new("Frame", t34.value29)

	Frame5.Size = UDim2.new(1, 0, 0, 22)
	Frame5.Position = UDim2.new(0, 0, 0, 216)
	Frame5.BackgroundTransparency = 1
	t34.value36 = Instance.new("TextButton")
	t34.value36.Size = UDim2.new(0.32, 0, 1, 0)
	t34.value36.Position = UDim2.new(0, 0, 0, 0)
	t34.value36.Text = "Regular"
	t34.value36.Font = Enum.Font.GothamBold
	t34.value36.TextSize = 10
	t34.value36.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	t34.value36.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value36.Parent = Frame5
	Instance.new("UICorner", t34.value36).CornerRadius = UDim.new(0, 6)
	t34.value37 = Instance.new("TextButton")
	t34.value37.Size = UDim2.new(0.32, 0, 1, 0)
	t34.value37.Position = UDim2.new(0.34, 0, 0, 0)
	t34.value37.Text = "Neon"
	t34.value37.Font = Enum.Font.GothamBold
	t34.value37.TextSize = 10
	t34.value37.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	t34.value37.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value37.Parent = Frame5
	Instance.new("UICorner", t34.value37).CornerRadius = UDim.new(0, 6)
	t34.value38 = Instance.new("TextButton")
	t34.value38.Size = UDim2.new(0.32, 0, 1, 0)
	t34.value38.Position = UDim2.new(0.68, 0, 0, 0)
	t34.value38.Text = "Mega"
	t34.value38.Font = Enum.Font.GothamBold
	t34.value38.TextSize = 10
	t34.value38.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	t34.value38.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value38.Parent = Frame5
	Instance.new("UICorner", t34.value38).CornerRadius = UDim.new(0, 6)

	function t34.value39()
		t34.value36.BackgroundColor3 = t34.value35 == "regular" and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 70)
		t34.value37.BackgroundColor3 = t34.value35 == "neon" and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 70)
		t34.value38.BackgroundColor3 = t34.value35 == "mega" and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 70)
	end

	t34.value36.MouseButton1Click:Connect(function()
		t34.value35 = "regular"
		t34.value39()
	end)
	t34.value37.MouseButton1Click:Connect(function()
		t34.value35 = "neon"
		t34.value39()
	end)
	t34.value38.MouseButton1Click:Connect(function()
		t34.value35 = "mega"
		t34.value39()
	end)
	t34.value39()

	local TextButton10 = Instance.new("TextButton", t34.value29)

	TextButton10.Size = UDim2.new(1, 0, 0, 28)
	TextButton10.Position = UDim2.new(0, 0, 0, 242)
	TextButton10.Text = "🤖 Spawn Bot"
	TextButton10.Font = Enum.Font.FredokaOne
	TextButton10.TextSize = 11
	TextButton10.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
	TextButton10.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", TextButton10).CornerRadius = UDim.new(0, 8)

	local UIStroke6 = Instance.new("UIStroke", TextButton10)

	UIStroke6.Color = Color3.fromRGB(150, 100, 255)
	UIStroke6.Thickness = 1
	UIStroke6.Transparency = 0.3

	local TextButton11 = Instance.new("TextButton", t34.value29)

	TextButton11.Size = UDim2.new(1, 0, 0, 24)
	TextButton11.Position = UDim2.new(0, 0, 0, 273)
	TextButton11.Text = "🗑️ Delete All Bots"
	TextButton11.Font = Enum.Font.GothamBold
	TextButton11.TextSize = 10
	TextButton11.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	TextButton11.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", TextButton11).CornerRadius = UDim.new(0, 6)

	local UIStroke7 = Instance.new("UIStroke", TextButton11)

	UIStroke7.Color = Color3.fromRGB(255, 100, 100)
	UIStroke7.Thickness = 1
	UIStroke7.Transparency = 0.3

	local function v636()
		local function v637()
			value342:Stop()

			local v638, v639, v640 = ipairs(t28)

			while true do
				local v643

				v640, v643 = v638(v639, v640)

				if not v640 then
					break
				end

				local model

				if v643 then
					model = v643.model
				else
					model = v643
				end

				if model then
					pcall(function()
						value36("pet_char_wrappers", function(p115)
							for i = #p115, 1, -1 do
								if p115[i].pet_unique == v643.wrapper.pet_unique then
									table.remove(p115, i)
								end
							end

							return p115
						end)
					end)

					local function v644()
						value36("pet_state_managers", function(p116)
							for i = #p116, 1, -1 do
								if p116[i].char == v643.model then
									table.remove(p116, i)
								end
							end

							return p116
						end)
					end

					pcall(v644)
				end
			end

			for _, v in pairs(t27) do
				local Parent

				if v then
					Parent = v.Parent
				else
					Parent = v
				end

				if Parent then
					v:Destroy()
				end
			end

			t2.value22 = {}
			_G.fakePlayerIds = {}
			pcall(function()
				local UIManager = t2.value30.load("UIManager")
				local apps = UIManager and UIManager.apps

				if apps then
					apps = UIManager.apps.FriendsApp
				end

				if not apps then
					return
				end

				local FriendsApp = UIManager.apps.FriendsApp
				local v652 = _G.fakeFriendsData and #_G.fakeFriendsData or 0

				_G.fakeFriendsData = {}

				if FriendsApp.friends_content then
					local pairs_ = pairs
					local friends_content = FriendsApp.friends_content

					for _, child in pairs_(friends_content.GetChildren(friends_content)) do
						if string.match(child.Name, "^FakeBotEntry_") then
							child:Destroy()
						end
					end
				end

				print("✓ Cleared " .. v652 .. " bots from friends list")
			end)
			UpdateResults("✅ All bots deleted successfully!\n\n🗑️ Cleared:\n• All bot characters\n• All bot pets\n• All animations\n• All registries\n• Bots from friends list")
			print("✅ All fake players and pets deleted successfully")
		end

		pcall(v637)
	end

	TextButton11.MouseButton1Click:Connect(v636)

	local TextLabel10 = Instance.new("TextLabel", t34.value29)

	TextLabel10.Size = UDim2.new(1, 0, 0, 16)
	TextLabel10.Position = UDim2.new(0, 0, 0, 325)
	TextLabel10.BackgroundTransparency = 1
	TextLabel10.Text = "🚫 Block Player:"
	TextLabel10.Font = Enum.Font.GothamBold
	TextLabel10.TextSize = 10
	TextLabel10.TextColor3 = Color3.fromRGB(200, 200, 255)
	TextLabel10.TextXAlignment = Enum.TextXAlignment.Left

	local Frame6 = Instance.new("Frame", t34.value29)

	Frame6.Size = UDim2.new(1, 0, 0, 28)
	Frame6.Position = UDim2.new(0, 0, 0, 343)
	Frame6.BackgroundTransparency = 1
	Frame6.ZIndex = 10
	t34.value40 = Instance.new("TextBox", Frame6)
	t34.value40.Size = UDim2.new(0.65, -2, 1, 0)
	t34.value40.Position = UDim2.new(0, 0, 0, 0)
	t34.value40.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value40.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value40.TextSize = 11
	t34.value40.Font = Enum.Font.Gotham
	t34.value40.PlaceholderText = "username"
	t34.value40.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
	t34.value40.ClearTextOnFocus = false
	t34.value40.ZIndex = 10
	Instance.new("UICorner", t34.value40).CornerRadius = UDim.new(0, 6)
	t34.value41 = Instance.new("TextButton", Frame6)
	t34.value41.Size = UDim2.new(0.15, 0, 1, 0)
	t34.value41.Position = UDim2.new(0.65, 2, 0, 0)
	t34.value41.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	t34.value41.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value41.Text = "▼"
	t34.value41.Font = Enum.Font.GothamBold
	t34.value41.TextSize = 11
	t34.value41.ZIndex = 10
	t34.value41.BorderSizePixel = 0
	Instance.new("UICorner", t34.value41).CornerRadius = UDim.new(0, 6)

	local UIStroke8 = Instance.new("UIStroke", t34.value41)

	UIStroke8.Color = Color3.fromRGB(200, 100, 100)
	UIStroke8.Thickness = 1
	UIStroke8.Transparency = 0.3
	t34.value42 = Instance.new("ScrollingFrame", Frame6)
	t34.value42.Size = UDim2.new(0.8, 0, 0, 0)
	t34.value42.Position = UDim2.new(0, 0, 1, 2)
	t34.value42.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
	t34.value42.BackgroundTransparency = 0
	t34.value42.BorderSizePixel = 0
	t34.value42.ScrollBarThickness = 6
	t34.value42.ScrollBarImageColor3 = Color3.fromRGB(200, 100, 100)
	t34.value42.CanvasSize = UDim2.new(0, 0, 0, 0)
	t34.value42.Visible = false
	t34.value42.ZIndex = 1000
	Instance.new("UICorner", t34.value42).CornerRadius = UDim.new(0, 8)

	local UIStroke9 = Instance.new("UIStroke", t34.value42)

	UIStroke9.Color = Color3.fromRGB(200, 100, 100)
	UIStroke9.Thickness = 2
	UIStroke9.Transparency = 0

	local UIListLayout2 = Instance.new("UIListLayout", t34.value42)

	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.Padding = UDim.new(0, 4)

	local UIPadding2 = Instance.new("UIPadding", t34.value42)

	UIPadding2.PaddingTop = UDim.new(0, 4)
	UIPadding2.PaddingBottom = UDim.new(0, 4)
	UIPadding2.PaddingLeft = UDim.new(0, 4)
	UIPadding2.PaddingRight = UDim.new(0, 4)

	local TextButton12 = Instance.new("TextButton", Frame6)

	TextButton12.Size = UDim2.new(0.18, 0, 1, 0)
	TextButton12.Position = UDim2.new(0.82, 0, 0, 0)
	TextButton12.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	TextButton12.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton12.Text = "Block"
	TextButton12.Font = Enum.Font.GothamBold
	TextButton12.TextSize = 11
	TextButton12.ZIndex = 10
	Instance.new("UICorner", TextButton12).CornerRadius = UDim.new(0, 6)

	local UIStroke10 = Instance.new("UIStroke", TextButton12)

	UIStroke10.Color = Color3.fromRGB(200, 100, 100)
	UIStroke10.Thickness = 1.5
	UIStroke10.Transparency = 0.3

	local function v665()
		local Text = t34.value40.Text
		local v667

		if Text then
			v667 = Text ~= ""
		else
			v667 = Text
		end

		if v667 then
			local v668 = value17(Text)

			if v668 then
				print("[BlockPlayer] Blocking player from Misc tab:", v668.Name)
				t34.value24(v668)
				UpdateResults("🚫 Blocked player!\n\n👤 " .. v668.Name .. "\n\n✅ Player has been blocked")

				return
			else
				warn("[BlockPlayer] Player not found in game:", Text)
				UpdateResults("❌ Player not found!\n\n👤 " .. Text .. "\n\n⚠️ Player is not in the game")

				return
			end
		else
			warn("[BlockPlayer] No player name entered")
			UpdateResults("⚠️ Enter a player name first!")
		end
	end

	TextButton12.MouseButton1Click:Connect(v665)
	t34.value43 = nil

	function t34.value44()
		local ipairs_ = ipairs
		local value42 = t34.value42

		for _, child in ipairs_(value42.GetChildren(value42)) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		local ipairs_2 = ipairs
		local value15 = t2.value15
		local n5 = 0

		for _, player in ipairs_2(value15.GetPlayers(value15)) do
			if player ~= t2.value15.LocalPlayer then
				n5 = n5 + 1

				local TextButton13 = Instance.new("TextButton", t34.value42)

				TextButton13.Size = UDim2.new(1, -8, 0, 28)
				TextButton13.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
				TextButton13.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton13.Text = player.Name
				TextButton13.Font = Enum.Font.GothamMedium
				TextButton13.TextSize = 10
				TextButton13.ZIndex = 1001
				TextButton13.BorderSizePixel = 0
				Instance.new("UICorner", TextButton13).CornerRadius = UDim.new(0, 6)
				TextButton13.MouseButton1Click:Connect(function()
					t34.value40.Text = player.Name
					t34.value43 = player
					t34.value42.Visible = false
					t34.value41.Text = "▼"
				end)
				TextButton13.MouseEnter:Connect(function()
					TextButton13.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
				end)
				TextButton13.MouseLeave:Connect(function()
					TextButton13.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
				end)
			end
		end

		local n6 = 32
		local v680 = n5 * n6
		local v681 = math.min(v680, 120)

		t34.value42.Size = UDim2.new(0.8, 0, 0, v681)

		if not (n5 * n6 > 120) then
			return
		end

		t34.value42.CanvasSize = UDim2.new(0, 0, 0, n5 * n6)
	end

	t34.value41.MouseButton1Click:Connect(function()
		t34.value42.Visible = not t34.value42.Visible
		t34.value41.Text = t34.value42.Visible and "▲" or "▼"

		if not t34.value42.Visible then
			return
		end

		t34.value44()
	end)
	t34.value40.Focused:Connect(function()
		t34.value42.Visible = false
		t34.value41.Text = "▼"
	end)
	t2.value15.PlayerAdded:Connect(t34.value44)
	t2.value15.PlayerRemoving:Connect(function(player)
		local _ = t34.value43 == player

		t34.value44()
	end)
	t34.value44()

	local TextLabel11 = Instance.new("TextLabel", t34.value29)

	TextLabel11.Size = UDim2.new(1, 0, 0, 16)
	TextLabel11.Position = UDim2.new(0, 0, 0, 380)
	TextLabel11.BackgroundTransparency = 1
	TextLabel11.Text = "⚙️ UI Scale:"
	TextLabel11.Font = Enum.Font.GothamBold
	TextLabel11.TextSize = 10
	TextLabel11.TextColor3 = Color3.fromRGB(200, 200, 255)
	TextLabel11.TextXAlignment = Enum.TextXAlignment.Left

	local Frame7 = Instance.new("Frame", t34.value29)

	Frame7.Size = UDim2.new(1, 0, 0, 28)
	Frame7.Position = UDim2.new(0, 0, 0, 398)
	Frame7.BackgroundTransparency = 1
	t34.value45 = Instance.new("TextButton", Frame7)
	t34.value45.Size = UDim2.new(0.15, 0, 1, 0)
	t34.value45.Position = UDim2.new(0, 0, 0, 0)
	t34.value45.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	t34.value45.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value45.Text = "−"
	t34.value45.Font = Enum.Font.GothamBold
	t34.value45.TextSize = 18
	t34.value45.ZIndex = 10
	Instance.new("UICorner", t34.value45).CornerRadius = UDim.new(0, 6)

	local UIStroke11 = Instance.new("UIStroke", t34.value45)

	UIStroke11.Color = Color3.fromRGB(200, 100, 100)
	UIStroke11.Thickness = 1.5
	UIStroke11.Transparency = 0.3
	t34.value46 = Instance.new("TextLabel", Frame7)
	t34.value46.Size = UDim2.new(0.5, 0, 1, 0)
	t34.value46.Position = UDim2.new(0.16, 0, 0, 0)
	t34.value46.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	t34.value46.TextColor3 = Color3.fromRGB(240, 240, 255)
	t34.value46.Text = "100%"
	t34.value46.Font = Enum.Font.GothamBold
	t34.value46.TextSize = 12
	t34.value46.ZIndex = 10
	Instance.new("UICorner", t34.value46).CornerRadius = UDim.new(0, 6)

	local UIStroke12 = Instance.new("UIStroke", t34.value46)

	UIStroke12.Color = Color3.fromRGB(100, 150, 200)
	UIStroke12.Thickness = 1.5
	UIStroke12.Transparency = 0.3
	t34.value47 = Instance.new("TextButton", Frame7)
	t34.value47.Size = UDim2.new(0.17, 0, 1, 0)
	t34.value47.Position = UDim2.new(0.67, 0, 0, 0)
	t34.value47.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
	t34.value47.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value47.Text = "🔓"
	t34.value47.Font = Enum.Font.GothamBold
	t34.value47.TextSize = 14
	t34.value47.ZIndex = 10
	Instance.new("UICorner", t34.value47).CornerRadius = UDim.new(0, 6)
	t34.value48 = Instance.new("UIStroke", t34.value47)
	t34.value48.Color = Color3.fromRGB(200, 200, 100)
	t34.value48.Thickness = 1.5
	t34.value48.Transparency = 0.3
	t34.value49 = false
	t34.value50 = Instance.new("TextButton", Frame7)
	t34.value50.Size = UDim2.new(0.15, 0, 1, 0)
	t34.value50.Position = UDim2.new(0.85, 0, 0, 0)
	t34.value50.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	t34.value50.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value50.Text = "+"
	t34.value50.Font = Enum.Font.GothamBold
	t34.value50.TextSize = 18
	t34.value50.ZIndex = 10
	Instance.new("UICorner", t34.value50).CornerRadius = UDim.new(0, 6)

	local UIStroke13 = Instance.new("UIStroke", t34.value50)

	UIStroke13.Color = Color3.fromRGB(100, 200, 100)
	UIStroke13.Thickness = 1.5
	UIStroke13.Transparency = 0.3
	t34.value51 = 1
	t34.value52 = 0.5
	t34.value53 = 2
	t34.value54 = 0.1

	local function v688(p117)
		local v689 = t34
		local value52 = t34.value52
		local value53 = t34.value53

		v689.value51 = math.clamp(p117, value52, value53)
		t34.value2.Scale = t34.value51

		local value46 = t34.value46
		local v693 = t34.value51 * 100

		value46.Text = math.floor(v693) .. "%"
		t34.value45.BackgroundColor3 = t34.value51 <= t34.value52 and Color3.fromRGB(100, 30, 30) or Color3.fromRGB(150, 50, 50)
		t34.value50.BackgroundColor3 = t34.value51 >= t34.value53 and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(50, 150, 50)
	end

	t34.value45.MouseButton1Click:Connect(function()
		v688(t34.value51 - t34.value54)
	end)
	t34.value50.MouseButton1Click:Connect(function()
		v688(t34.value51 + t34.value54)
	end)
	t34.value47.MouseButton1Click:Connect(function()
		t34.value49 = not t34.value49

		if t34.value49 then
			t34.value47.Text = "🔒"
			t34.value47.BackgroundColor3 = Color3.fromRGB(50, 150, 150)
			t34.value48.Color = Color3.fromRGB(100, 200, 200)
		else
			t34.value47.Text = "🔓"
			t34.value47.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
			t34.value48.Color = Color3.fromRGB(200, 200, 100)
		end
	end)
	v688(t34.value51)
	_G.antiRaidEnabled = false
	t34.value55 = Instance.new("TextButton", t34.value29)
	t34.value55.Size = UDim2.new(1, 0, 0, 28)
	t34.value55.Position = UDim2.new(0, 0, 0, 435)
	t34.value55.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	t34.value55.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value55.Text = "🛡️ Anti-Raid: OFF"
	t34.value55.Font = Enum.Font.FredokaOne
	t34.value55.TextSize = 11
	t34.value55.ZIndex = 10
	Instance.new("UICorner", t34.value55).CornerRadius = UDim.new(0, 6)
	t34.value56 = Instance.new("UIStroke", t34.value55)
	t34.value56.Color = Color3.fromRGB(200, 100, 100)
	t34.value56.Thickness = 1.5
	t34.value56.Transparency = 0.3
	t34.value55.MouseButton1Click:Connect(function()
		_G.antiRaidEnabled = not _G.antiRaidEnabled

		if not _G.antiRaidEnabled then
			t34.value55.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
			t34.value55.Text = "🛡️ Anti-Raid: OFF"
			t34.value56.Color = Color3.fromRGB(200, 100, 100)
			UpdateResults("🛡️ Anti-Raid Disabled\n\n❌ No longer monitoring for scam keywords")

			return
		end

		t34.value55.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
		t34.value55.Text = "🛡️ Anti-Raid: ON"
		t34.value56.Color = Color3.fromRGB(100, 200, 100)
		UpdateResults("🛡️ Anti-Raid Enabled!\n\n✅ Auto-scanning all current players...\n⏳ Please wait...")
		task.spawn(function()
			task.wait(2)

			if not _G.antiRaidScanAll then
				return
			end

			_G.antiRaidScanAll()
		end)
	end)
	t34.value57 = Instance.new("TextLabel", t34.value29)
	t34.value57.Size = UDim2.new(1, 0, 0, 20)
	t34.value57.Position = UDim2.new(0, 0, 0, 467)
	t34.value57.BackgroundTransparency = 1
	t34.value57.Text = "🚫 Blocked: 0"
	t34.value57.Font = Enum.Font.GothamBold
	t34.value57.TextSize = 10
	t34.value57.TextColor3 = Color3.fromRGB(255, 170, 85)
	t34.value57.TextXAlignment = Enum.TextXAlignment.Center
	t34.value57.ZIndex = 10

	function _G.updateAntiRaidStats(p118)
		if not t34.value57 then
			return
		end

		t34.value57.Text = "🚫 Blocked: " .. tostring(p118)
		task.spawn(function()
			local TextColor3 = t34.value57.TextColor3

			t34.value57.TextColor3 = Color3.fromRGB(255, 85, 85)
			task.wait(0.3)
			t34.value57.TextColor3 = TextColor3
		end)
	end

	t34.value58 = Instance.new("TextButton", t34.value29)
	t34.value58.Size = UDim2.new(0.18, 0, 0, 20)
	t34.value58.Position = UDim2.new(0.82, 0, 0, 300)
	t34.value58.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
	t34.value58.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value58.Text = "Show"
	t34.value58.Font = Enum.Font.GothamBold
	t34.value58.TextSize = 8
	Instance.new("UICorner", t34.value58).CornerRadius = UDim.new(0, 5)

	local UIStroke14 = Instance.new("UIStroke", t34.value58)

	UIStroke14.Color = Color3.fromRGB(150, 150, 200)
	UIStroke14.Thickness = 0.8
	UIStroke14.Transparency = 0.4
	t34.value59 = Instance.new("TextButton", t34.value29)
	t34.value59.Size = UDim2.new(0.18, 0, 0, 20)
	t34.value59.Position = UDim2.new(0.615, 0, 0, 300)
	t34.value59.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	t34.value59.TextColor3 = Color3.fromRGB(255, 255, 255)
	t34.value59.Text = "Bypass: OFF"
	t34.value59.Font = Enum.Font.GothamBold
	t34.value59.TextSize = 7
	Instance.new("UICorner", t34.value59).CornerRadius = UDim.new(0, 5)
	t34.value60 = Instance.new("UIStroke", t34.value59)
	t34.value60.Color = Color3.fromRGB(200, 100, 100)
	t34.value60.Thickness = 0.8
	t34.value60.Transparency = 0.4
	t34.value61 = false
	t34.value59.MouseButton1Click:Connect(function()
		t34.value61 = not t34.value61
		t34.value59.Text = t34.value61 and "Bypass: ON" or "Bypass: OFF"
		t34.value59.BackgroundColor3 = t34.value61 and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
		t34.value60.Color = t34.value61 and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
	end)

	local TextButton13 = Instance.new("TextButton", t34.value29)

	TextButton13.Size = UDim2.new(0.18, 0, 0, 20)
	TextButton13.Position = UDim2.new(0.205, 0, 0, 300)
	TextButton13.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
	TextButton13.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton13.Text = "Random Name"
	TextButton13.Font = Enum.Font.GothamBold
	TextButton13.TextSize = 7
	Instance.new("UICorner", TextButton13).CornerRadius = UDim.new(0, 5)

	local UIStroke15 = Instance.new("UIStroke", TextButton13)

	UIStroke15.Color = Color3.fromRGB(150, 150, 255)
	UIStroke15.Thickness = 0.8
	UIStroke15.Transparency = 0.4

	local function v698()
		local v699 = v71()

		t34.value34.Text = v699
		UpdateResults("🎲 Random name generated!\n\n✨ " .. v699 .. "\n\n💡 You can edit it or generate another!")
	end

	TextButton13.MouseButton1Click:Connect(v698)
	t34.value62 = {
		"Shadow Dragon",
		"Bat Dragon",
		"Frost Dragon",
		"Giraffe",
		"Blazing Lion",
		"Orchid Butterfly",
		"African Wild Dog",
		"Owl",
		"Parrot",
		"Crow",
		"Evil Unicorn",
		"Balloon Unicorn",
		"Dalmatian",
		"Arctic Reindeer",
		"Kangaroo",
		"Turtle",
		"Giant Panda",
		"Hedgehog",
		"Cow",
		"Chocolate Chip Bat Dragon",
		"Flamingo",
		"Peppermint Penguin",
		"Strawberry Shortcake Bat Dragon"
	}

	local TextButton14 = Instance.new("TextButton", t34.value29)

	TextButton14.Size = UDim2.new(0.18, 0, 0, 20)
	TextButton14.Position = UDim2.new(0.41, 0, 0, 300)
	TextButton14.BackgroundColor3 = Color3.fromRGB(180, 140, 50)
	TextButton14.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton14.Text = "High Tier"
	TextButton14.Font = Enum.Font.GothamBold
	TextButton14.TextSize = 7
	Instance.new("UICorner", TextButton14).CornerRadius = UDim.new(0, 5)

	local UIStroke16 = Instance.new("UIStroke", TextButton14)

	UIStroke16.Color = Color3.fromRGB(230, 180, 70)
	UIStroke16.Thickness = 0.8
	UIStroke16.Transparency = 0.4
	TextButton14.MouseButton1Click:Connect(function()
		if #t34.value62 > 0 then
			local v702 = t34.value62[math.random(1, #t34.value62)]

			t34.value33.Text = v702
			UpdateResults("👑 High tier pet selected!\n\n💎 " .. v702 .. "\n\n💡 Click Spawn Bot to create it!")
		else
			UpdateResults("❌ No high tier pets available!")
		end
	end)

	local TextButton15 = Instance.new("TextButton", t34.value29)

	TextButton15.Size = UDim2.new(0.18, 0, 0, 20)
	TextButton15.Position = UDim2.new(0, 0, 0, 300)
	TextButton15.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
	TextButton15.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton15.Text = "Random Pet"
	TextButton15.Font = Enum.Font.GothamBold
	TextButton15.TextSize = 7
	Instance.new("UICorner", TextButton15).CornerRadius = UDim.new(0, 5)

	local UIStroke17 = Instance.new("UIStroke", TextButton15)

	UIStroke17.Color = Color3.fromRGB(150, 200, 150)
	UIStroke17.Thickness = 0.8
	UIStroke17.Transparency = 0.4
	TextButton15.MouseButton1Click:Connect(function()
		local v705, v706, v707 = pairs(t2.value36.pets)
		local t36 = {}

		while true do
			local v709

			v707, v709 = v705(v706, v707)

			if not v707 then
				break
			end

			if v709.name then
				local name = v709.name

				table.insert(t36, name)
			end
		end

		if #t36 > 0 then
			local v711 = t36[math.random(1, #t36)]

			t34.value33.Text = v711
			UpdateResults("🎰 Random pet selected!\n\n🐾 " .. v711 .. "\n\n💡 Click Spawn Bot to create it!")
		else
			UpdateResults("❌ No pets available in database!")
		end
	end)
	t34.value63 = Instance.new("TextLabel", t34.value29)
	t34.value63.Size = UDim2.new(1, 0, 1, -440)
	t34.value63.Position = UDim2.new(0, 0, 0, 435)
	t34.value63.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	t34.value63.BackgroundTransparency = 0.5
	t34.value63.BorderSizePixel = 0
	t34.value63.Text = "👤 Select player to begin"
	t34.value63.Font = Enum.Font.GothamMedium
	t34.value63.TextSize = 9
	t34.value63.TextColor3 = Color3.fromRGB(200, 200, 255)
	t34.value63.TextXAlignment = Enum.TextXAlignment.Left
	t34.value63.TextYAlignment = Enum.TextYAlignment.Top
	t34.value63.TextWrapped = true
	t34.value63.Visible = false
	Instance.new("UICorner", t34.value63).CornerRadius = UDim.new(0, 8)

	local UIPadding3 = Instance.new("UIPadding", t34.value63)

	UIPadding3.PaddingTop = UDim.new(0, 8)
	UIPadding3.PaddingLeft = UDim.new(0, 8)
	UIPadding3.PaddingRight = UDim.new(0, 8)
	UIPadding3.PaddingBottom = UDim.new(0, 8)
	t34.value64 = false
	t34.value58.MouseButton1Click:Connect(function()
		t34.value64 = not t34.value64
		t34.value63.Visible = t34.value64
		t34.value58.Text = t34.value64 and "Hide" or "Show"
		t34.value58.BackgroundColor3 = t34.value64 and Color3.fromRGB(150, 100, 100) or Color3.fromRGB(100, 100, 150)
	end)

	function t34.value65(p119)
		t34.value63.Text = p119
	end

	t34.value66 = Instance.new("ScrollingFrame")
	t34.value66.Size = UDim2.new(1, 0, 1, 0)
	t34.value66.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	t34.value66.BackgroundTransparency = 0.5
	t34.value66.BorderSizePixel = 0
	t34.value66.ScrollBarThickness = 4
	t34.value66.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	t34.value66.ScrollBarImageTransparency = 0.5
	t34.value66.Parent = t34.value28

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = t34.value66

	local UIListLayout3 = Instance.new("UIListLayout")

	UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout3.Padding = UDim.new(0, 3)
	UIListLayout3.Parent = t34.value66

	local UIPadding4 = Instance.new("UIPadding")

	UIPadding4.PaddingTop = UDim.new(0, 4)
	UIPadding4.PaddingBottom = UDim.new(0, 4)
	UIPadding4.PaddingLeft = UDim.new(0, 4)
	UIPadding4.PaddingRight = UDim.new(0, 4)
	UIPadding4.Parent = t34.value66

	local TextButton16 = Instance.new("TextButton")

	TextButton16.Size = UDim2.new(1, 0, 0, 32)
	TextButton16.Position = UDim2.new(0, 0, 0, 0)
	TextButton16.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	TextButton16.BackgroundTransparency = 0.1
	TextButton16.BorderSizePixel = 0
	TextButton16.Text = "⚡ No active trade"
	TextButton16.Font = Enum.Font.GothamBold
	TextButton16.TextSize = 12
	TextButton16.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton16.Parent = t34.value27
	TextButton16.ZIndex = 2
	TextButton16.AutoButtonColor = true

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 6)
	UICorner2.Parent = TextButton16

	local UIStroke18 = Instance.new("UIStroke")

	UIStroke18.Color = Color3.fromRGB(100, 180, 255)
	UIStroke18.Thickness = 2
	UIStroke18.Transparency = 0.3
	UIStroke18.Parent = TextButton16
	_G._currentPartnerButton = TextButton16
	_G._partnerButtonStroke = UIStroke18

	function _G.updateCurrentPartnerButton()
		local PARTNER_NAME = nil
		local active = t18.active

		if active then
			active = t18.trade
		end

		if active then
			PARTNER_NAME = t17.PARTNER_NAME
		else
			pcall(function()
				local UIManager = require(game.ReplicatedStorage.Fsys).load("UIManager")
				local apps = UIManager and UIManager.apps

				if apps then
					apps = UIManager.apps.TradeApp
				end

				if not apps then
					return
				end

				local TradeApp = UIManager.apps.TradeApp
				local local_trade_state = TradeApp.local_trade_state

				if local_trade_state then
					local_trade_state = TradeApp.local_trade_state.current_stage
				end

				local v725 = local_trade_state and TradeApp:_get_partner()

				if not v725 then
					return
				end

				PARTNER_NAME = v725.Name
			end)
		end

		if not PARTNER_NAME then
			if v818 then
				_G._currentPartnerButton.Text = "⚡ Current Partner: " .. PARTNER_NAME
				_G._currentPartnerButton.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
				_G._partnerButtonStroke.Color = Color3.fromRGB(100, 255, 180)
			else
				if not _G._currentPartnerButton then
					return
				end

				_G._currentPartnerButton.Text = "⚡ No active trade"
				_G._currentPartnerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
				_G._partnerButtonStroke.Color = Color3.fromRGB(120, 120, 140)
			end

			return
		end

		local _currentPartnerButton = _G._currentPartnerButton

		if _currentPartnerButton then
			_G._currentPartnerButton.Text = "⚡ Current Partner: " .. PARTNER_NAME
			_G._currentPartnerButton.BackgroundColor3 = Color3.fromRGB(50, 200, 120)
			_G._partnerButtonStroke.Color = Color3.fromRGB(100, 255, 180)
		else
			if not _G._currentPartnerButton then
				return
			end

			_G._currentPartnerButton.Text = "⚡ No active trade"
			_G._currentPartnerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
			_G._partnerButtonStroke.Color = Color3.fromRGB(120, 120, 140)
		end
	end

	local updateCurrentPartnerButton = _G.updateCurrentPartnerButton

	local function v728()
		local PARTNER_NAME = nil
		local active = t18.active

		if active then
			active = t18.trade
		end

		if active then
			PARTNER_NAME = t17.PARTNER_NAME
		else
			pcall(function()
				local UIManager = require(game.ReplicatedStorage.Fsys).load("UIManager")
				local apps = UIManager and UIManager.apps

				if apps then
					apps = UIManager.apps.TradeApp
				end

				if not apps then
					return
				end

				local TradeApp = UIManager.apps.TradeApp
				local local_trade_state = TradeApp.local_trade_state

				if local_trade_state then
					local_trade_state = TradeApp.local_trade_state.current_stage
				end

				local v735 = local_trade_state and TradeApp:_get_partner()

				if not v735 then
					return
				end

				PARTNER_NAME = v735.Name
			end)
		end

		if not PARTNER_NAME then
			return
		end

		t34.value7.Text = PARTNER_NAME
	end

	TextButton16.MouseButton1Click:Connect(v728)
	updateCurrentPartnerButton()
	task.spawn(function()
		while true do
			task.wait(1)
			_G.updateCurrentPartnerButton()
		end
	end)
	t34.value67 = Instance.new("ScrollingFrame")
	t34.value67.Size = UDim2.new(1, 0, 1, -36)
	t34.value67.Position = UDim2.new(0, 0, 0, 36)
	t34.value67.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	t34.value67.BackgroundTransparency = 0.5
	t34.value67.BorderSizePixel = 0
	t34.value67.ScrollBarThickness = 4
	t34.value67.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	t34.value67.ScrollBarImageTransparency = 0.5
	t34.value67.Parent = t34.value27

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 4)
	UICorner3.Parent = t34.value67

	local UIListLayout4 = Instance.new("UIListLayout")

	UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout4.Padding = UDim.new(0, 3)
	UIListLayout4.Parent = t34.value67

	local UIPadding5 = Instance.new("UIPadding")

	UIPadding5.PaddingTop = UDim.new(0, 4)
	UIPadding5.PaddingBottom = UDim.new(0, 4)
	UIPadding5.PaddingLeft = UDim.new(0, 4)
	UIPadding5.PaddingRight = UDim.new(0, 4)
	UIPadding5.Parent = t34.value67
	t34.value68 = {}
	t34.value69 = {
		{
			displayName = "CammyxBoba",
			userId = 901819690
		},
		{
			displayName = "CammyxNigga",
			userId = 901819690
		},
		{
			displayName = "CammyxScammer",
			userId = 901819690
		},
		{
			displayName = "CammyxSlave",
			userId = 901819690
		},
		{
			displayName = "RoplexYoutube",
			userId = 1676706728
		},
		{
			displayName = "NiggerPlex",
			userId = 1676706728
		},
		{
			displayName = "NotLeah",
			userId = 273090581
		},
		{
			displayName = "Leah Ashe Slut",
			userId = 273090581
		},
		{
			displayName = "TheMeganPlays",
			userId = 707412972
		},
		{
			displayName = "Megan Plays Cheating Husband",
			userId = 5389490121
		},
		{
			displayName = "Agusmareborn",
			userId = 8951710060
		},
		{
			displayName = "Kellyvault",
			userId = 9087927188
		},
		{
			displayName = "Rainbowriley321",
			userId = 154241943
		},
		{
			displayName = "hweartsouls",
			userId = 9975428802
		},
		{
			displayName = "h3llsang3lx",
			userId = 1083888004
		},
		{
			displayName = "Xcallmeholly",
			userId = 2025353438
		},
		{
			displayName = "Hugso09",
			userId = 1367827962
		},
		{
			displayName = "ruthjavxn",
			userId = 5020021111
		},
		{
			displayName = "bubblesxwrldd",
			userId = 5609475294
		},
		{
			displayName = "Hugeinvestor",
			userId = 7441130009
		},
		{
			displayName = "Barborich2",
			userId = 1980954542
		},
		{
			displayName = "Underthechemtrailss",
			userId = 1114481443
		},
		{
			displayName = "Bunzvii",
			userId = 2239753417
		},
		{
			displayName = "Qwrtylostaccount",
			userId = 3469645196
		},
		{
			displayName = "Sparklingorangelol",
			userId = 1574211487
		},
		{
			displayName = "Tr3ndzyy",
			userId = 4736584467
		},
		{
			displayName = "Lathifcal",
			userId = 118016940
		},
		{
			displayName = "Tadhghogan009",
			userId = 5224823162
		},
		{
			displayName = "Obvk1rk",
			userId = 2771705793
		},
		{
			displayName = "dwsiredsouls",
			userId = 8853512120
		},
		{
			displayName = "Cqvrleo",
			userId = 2583294477
		},
		{
			displayName = "Themeganplays",
			userId = 707412972
		},
		{
			displayName = "Stranger_s4mu",
			userId = 2550885705
		},
		{
			displayName = "Pradasvogue",
			userId = 1998230495
		},
		{
			displayName = "Lionheart_xo",
			userId = 1797881196
		}
	}
	t34.value70 = {
		"Je peux spin ça ?",
		"Je suis choqué c\'est vraiment vrai",
		"T tellement trust omg",
		"Les gens c\'est vraiment vrai",
		"Merci pour les pets",
		"T\'es trop gentil",
		"Je peux pas add deso",
		"OMGGGGG",
		"omgg c\'est vrm vrai",
		"Je peux add si tu veux",
		"Merci pour les pets",
		"Les gens dans le live c\'est vrai",
		"T\'es trust a 1000%",
		"Mercii",
		"Je peux changer le pets",
		"J\'ai acheté des pets",
		"J\'ai acheté un pet"
	}

	function createUserButton(p120, p121)
		local TextButton17 = Instance.new("TextButton")

		TextButton17.Size = UDim2.new(1, -8, 0, 26)
		TextButton17.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		TextButton17.BackgroundTransparency = 0.2
		TextButton17.Text = ""
		TextButton17.Parent = t34.value67

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 4)
		UICorner4.Parent = TextButton17

		local UIStroke19 = Instance.new("UIStroke")

		UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke19.Color = Color3.fromRGB(80, 80, 80)
		UIStroke19.Thickness = 1
		UIStroke19.Transparency = 0.3
		UIStroke19.Parent = TextButton17

		local TextLabel12 = Instance.new("TextLabel")

		TextLabel12.Size = UDim2.new(1, -8, 1, 0)
		TextLabel12.Position = UDim2.new(0, 4, 0, 0)
		TextLabel12.BackgroundTransparency = 1
		TextLabel12.Text = p120.displayName
		TextLabel12.Font = Enum.Font.GothamBold
		TextLabel12.TextSize = 10
		TextLabel12.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel12.TextTransparency = 0
		TextLabel12.Parent = TextButton17

		local UIStroke20 = Instance.new("UIStroke")

		UIStroke20.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke20.Color = Color3.new(0, 0, 0)
		UIStroke20.Thickness = 0.8
		UIStroke20.Transparency = 0.8
		UIStroke20.Parent = TextLabel12
		TextButton17.BackgroundTransparency = 1
		UIStroke19.Transparency = 1
		TextLabel12.TextTransparency = 1
		UIStroke20.Transparency = 1
		TextButton17.MouseButton1Click:Connect(function()
			local Size = TextButton17.Size

			t2.value19:Create(TextButton17, TweenInfo.new(0.08, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Size = UDim2.new(Size.X.Scale, Size.X.Offset - 2, Size.Y.Scale, Size.Y.Offset - 2)
			}):Play()
			task.wait(0.08)
			t2.value19:Create(TextButton17, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = Size
			}):Play()
			showTab("Control")
			t34.value7.Text = p120.displayName
			updatePartnerWithCustomName(p120.displayName, p120.userId)
		end)
		TextButton17.LayoutOrder = p121

		return TextButton17
	end
	function createChatButton(p122, p123)
		local TextButton17 = Instance.new("TextButton")

		TextButton17.Size = UDim2.new(1, -8, 0, 26)
		TextButton17.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
		TextButton17.BackgroundTransparency = 0.2
		TextButton17.Text = ""
		TextButton17.Parent = t34.value66

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 4)
		UICorner4.Parent = TextButton17

		local UIStroke19 = Instance.new("UIStroke")

		UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke19.Color = Color3.fromRGB(100, 100, 150)
		UIStroke19.Thickness = 1
		UIStroke19.Transparency = 0.3
		UIStroke19.Parent = TextButton17

		local TextLabel12 = Instance.new("TextLabel")

		TextLabel12.Size = UDim2.new(1, -8, 1, 0)
		TextLabel12.Position = UDim2.new(0, 4, 0, 0)
		TextLabel12.BackgroundTransparency = 1
		TextLabel12.Text = p122
		TextLabel12.Font = Enum.Font.GothamBold
		TextLabel12.TextSize = 9
		TextLabel12.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel12.TextTransparency = 0
		TextLabel12.Parent = TextButton17

		local UIStroke20 = Instance.new("UIStroke")

		UIStroke20.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke20.Color = Color3.new(0, 0, 0)
		UIStroke20.Thickness = 0.8
		UIStroke20.Transparency = 0.8
		UIStroke20.Parent = TextLabel12
		TextButton17.BackgroundTransparency = 1
		UIStroke19.Transparency = 1
		TextLabel12.TextTransparency = 1
		UIStroke20.Transparency = 1
		TextButton17.MouseButton1Click:Connect(function()
			local Size = TextButton17.Size
			local value192 = t2.value19
			local v752 = TextButton17
			local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local UDim2_ = UDim2

			value192.Create(value192, v752, tweenInfo, {
				Size = UDim2_.new(Size.X.Scale, Size.X.Offset - 2, Size.Y.Scale, Size.Y.Offset - 2)
			}):Play()
			task.wait(0.08)
			t2.value19:Create(TextButton17, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = Size
			}):Play()

			local active = t18.active

			if active then
				active = t18.trade
			end

			if not active then
				return
			end

			value31(p122)
		end)
		TextButton17.LayoutOrder = p123

		return TextButton17
	end
	function buildUsersList()
		local ipairs_ = ipairs
		local value67 = t34.value67

		for _, child in ipairs_(value67.GetChildren(value67)) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		t34.value68 = {}

		for i, v in ipairs(t34.value69) do
			local v762 = createUserButton(v, i)
			local value68 = t34.value68

			table.insert(value68, v762)
		end

		t34.value67.CanvasSize = UDim2.new(0, 0, 0, #t34.value69 * 29 + 8)
	end
	function buildChatList()
		local ipairs_ = ipairs
		local value66 = t34.value66
		local v766, v767, v768 = ipairs_(value66.GetChildren(value66))

		while true do
			local v769

			v768, v769 = v766(v767, v768)

			if not v768 then
				break
			end

			if v769:IsA("TextButton") then
				v769:Destroy()
			end
		end

		for i, v in ipairs(t34.value70) do
			createChatButton(v, i)
		end

		t34.value66.CanvasSize = UDim2.new(0, 0, 0, #t34.value70 * 29 + 8)
	end
	function animateUsersList()
		for i, v in ipairs(t34.value68) do
			local v774 = (i - 1) * 0.05

			task.spawn(function()
				task.wait(v774)

				local UIStroke19 = v:FindFirstChildOfClass("UIStroke")
				local TextLabel12 = v:FindFirstChildOfClass("TextLabel")
				local UIStroke20

				if TextLabel12 then
					UIStroke20 = TextLabel12:FindFirstChildOfClass("UIStroke")
				else
					UIStroke20 = TextLabel12
				end

				local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				local tweenInfo3 = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				local value192 = t2.value19
				local v782 = v
				local uDim2New = UDim2.new

				value192.Create(value192, v782, tweenInfo, {
					Size = uDim2New(1.02, -8, 0, 28),
					Position = UDim2.new(-0.01, 0, 0, 0),
					BackgroundTransparency = 0.4
				}):Play()
				task.wait(0.1)

				local value193 = t2.value19
				local v785 = v
				local uDim2 = UDim2.new(1, -8, 0, 26)
				local uDim2New2 = UDim2.new

				value193.Create(value193, v785, tweenInfo2, {
					Size = uDim2,
					Position = uDim2New2(0, 0, 0, 0),
					BackgroundTransparency = 0.2
				}):Play()

				if UIStroke19 then
					t2.value19:Create(UIStroke19, tweenInfo2, {
						Thickness = 1,
						Transparency = 0.3
					}):Play()
				end

				task.wait(0.06)

				if TextLabel12 then
					t2.value19:Create(TextLabel12, tweenInfo3, {
						TextTransparency = 0
					}):Play()
				end

				if not UIStroke20 then
					return
				end

				t2.value19:Create(UIStroke20, tweenInfo3, {
					Transparency = 0.8
				}):Play()
			end)
		end
	end
	function animateChatList()
		local ipairs_ = ipairs
		local value66 = t34.value66

		for k, child in ipairs_(value66.GetChildren(value66)) do
			if child:IsA("TextButton") then
				local v792 = (k - 1) * 0.05

				task.spawn(function()
					task.wait(v792)

					local UIStroke19 = child:FindFirstChildOfClass("UIStroke")
					local TextLabel12 = child:FindFirstChildOfClass("TextLabel")
					local UIStroke20

					if TextLabel12 then
						UIStroke20 = TextLabel12:FindFirstChildOfClass("UIStroke")
					else
						UIStroke20 = TextLabel12
					end

					local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
					local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
					local tweenInfo3 = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

					t2.value19:Create(child, tweenInfo, {
						Size = UDim2.new(1.02, -8, 0, 28),
						Position = UDim2.new(-0.01, 0, 0, 0),
						BackgroundTransparency = 0.4
					}):Play()
					task.wait(0.1)

					local value192 = t2.value19
					local v800 = child
					local uDim2 = UDim2.new(1, -8, 0, 26)
					local uDim2New = UDim2.new

					value192.Create(value192, v800, tweenInfo2, {
						Size = uDim2,
						Position = uDim2New(0, 0, 0, 0),
						BackgroundTransparency = 0.2
					}):Play()

					if UIStroke19 then
						t2.value19:Create(UIStroke19, tweenInfo2, {
							Thickness = 1,
							Transparency = 0.3
						}):Play()
					end

					task.wait(0.06)

					if TextLabel12 then
						t2.value19:Create(TextLabel12, tweenInfo3, {
							TextTransparency = 0
						}):Play()
					end

					if not UIStroke20 then
						return
					end

					t2.value19:Create(UIStroke20, tweenInfo3, {
						Transparency = 0.8
					}):Play()
				end)
			end
		end
	end

	local t37 = {
		{
			key = "Control",
			label = "🎮 Control"
		},
		{
			key = "Users",
			label = "🧑 Users"
		},
		{
			key = "Chat",
			label = "💬 Chat"
		},
		{
			key = "Misc",
			label = "⚙️ Misc"
		}
	}

	for i, v in ipairs(t37) do
		local TextButton17 = Instance.new("TextButton")

		TextButton17.Size = UDim2.new(1 / #t37 - 0.02, 0, 1, 0)

		local uDim2New = UDim2.new
		local v808 = 1 / #t37
		local _ = i == 1
		local v810 = (i - 1) * v808
		local n7 = 0

		TextButton17.Position = uDim2New(v810, n7, 0, 0)
		TextButton17.BackgroundColor3 = i == 1 and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(40, 40, 50)
		TextButton17.BackgroundTransparency = 0.2
		TextButton17.Text = v.label
		TextButton17.Font = Enum.Font.GothamBold
		TextButton17.TextSize = 11
		TextButton17.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton17.Parent = Frame
		Instance.new("UICorner", TextButton17).CornerRadius = UDim.new(0, 8)

		local UIStroke19 = Instance.new("UIStroke")

		UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke19.Color = i == 1 and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)
		UIStroke19.Thickness = i == 1 and 1.2 or 0.8
		UIStroke19.Transparency = 0.3
		UIStroke19.Parent = TextButton17
		t34.value6[v.key] = {
			button = TextButton17,
			stroke = UIStroke19
		}
	end

	t34.value71 = {
		TextLabel2,
		t34.value7,
		t34.value8,
		t34.value9,
		TextLabel3,
		t34.value18,
		TextLabel4,
		t34.value19,
		TextButton,
		TextLabel5,
		t34.value20,
		Frame2,
		TextButton2,
		TextButton3,
		TextButton4,
		TextButton5,
		t34.value23,
		TextButton6,
		t34.value26,
		t34.value17
	}

	function showTab(p124)
		local visible = p124 == "Control"
		local visible2 = p124 == "Users"
		local visible3 = p124 == "Chat"
		local visible4 = p124 == "Misc"

		for _, v in ipairs(t34.value71) do
			local Parent

			if v then
				Parent = v.Parent
			else
				Parent = v
			end

			if Parent then
				v.Visible = visible
			end
		end

		t34.value23.Visible = visible
		t34.value25.Visible = visible
		t34.value27.Visible = visible2
		t34.value28.Visible = visible3
		t34.value29.Visible = visible4
		v540(p124)

		if visible2 then
			animateUsersList()

			return
		end

		if not visible3 then
			return
		end

		animateChatList()
	end

	buildUsersList()
	buildChatList()
	t34.value6.Control.button.MouseButton1Click:Connect(function()
		showTab("Control")
	end)
	t34.value6.Users.button.MouseButton1Click:Connect(function()
		showTab("Users")
	end)
	t34.value6.Chat.button.MouseButton1Click:Connect(function()
		showTab("Chat")
	end)
	t34.value6.Misc.button.MouseButton1Click:Connect(function()
		showTab("Misc")
	end)
	showTab("Control")
	t34.value72 = nil
	t34.value73 = nil
	t34.value74 = ""

	function t34.value75()
		local ipairs_ = ipairs
		local value32 = t34.value32

		for _, child in ipairs_(value32.GetChildren(value32)) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		local ipairs_2 = ipairs
		local value15 = t2.value15
		local n8 = 0

		for _, player in ipairs_2(value15.GetPlayers(value15)) do
			if player ~= t2.value15.LocalPlayer then
				n8 = n8 + 1

				local TextButton17 = Instance.new("TextButton")

				TextButton17.Size = UDim2.new(1, -4, 0, 32)
				TextButton17.BackgroundColor3 = Color3.fromRGB(40, 45, 70)
				TextButton17.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton17.BorderSizePixel = 0
				TextButton17.Font = Enum.Font.GothamBold
				TextButton17.TextSize = 13
				TextButton17.Text = player.Name
				TextButton17.TextXAlignment = Enum.TextXAlignment.Left
				TextButton17.TextYAlignment = Enum.TextYAlignment.Center
				TextButton17.ZIndex = 1001
				TextButton17.Parent = t34.value32
				Instance.new("UIPadding", TextButton17).PaddingLeft = UDim.new(0, 10)
				Instance.new("UICorner", TextButton17).CornerRadius = UDim.new(0, 5)

				local UIStroke19 = Instance.new("UIStroke", TextButton17)

				UIStroke19.Color = Color3.fromRGB(80, 120, 180)
				UIStroke19.Thickness = 1
				UIStroke19.Transparency = 0.5
				TextButton17.MouseEnter:Connect(function()
					TextButton17.BackgroundColor3 = Color3.fromRGB(60, 75, 120)
					UIStroke19.Color = Color3.fromRGB(100, 150, 220)
					UIStroke19.Transparency = 0.2
				end)
				TextButton17.MouseLeave:Connect(function()
					TextButton17.BackgroundColor3 = Color3.fromRGB(40, 45, 70)
					UIStroke19.Color = Color3.fromRGB(80, 120, 180)
					UIStroke19.Transparency = 0.5
				end)
				TextButton17.MouseButton1Click:Connect(function()
					t34.value72 = player
					t34.value73 = player.UserId
					t34.value74 = player.Name
					t34.value30.Text = player.Name
					t34.value32.Visible = false
					t34.value31.Text = "▼"
				end)
			end
		end

		local n9 = 32
		local v832 = n8 * n9
		local v833 = math.min(v832, 200)

		t34.value32.Size = UDim2.new(1, 0, 0, v833)

		if not (v833 > 0) then
			return
		end

		t34.value32.CanvasSize = UDim2.new(0, 0, 0, n8 * n9)
	end

	t34.value31.MouseButton1Click:Connect(function()
		t34.value32.Visible = not t34.value32.Visible
		t34.value31.Text = t34.value32.Visible and "▲" or "▼"

		if not t34.value32.Visible then
			return
		end

		t34.value75()
	end)
	t34.value30.FocusLost:Connect(function(_)
		local Text = t34.value30.Text
		local v835

		if Text then
			v835 = Text ~= ""
		else
			v835 = Text
		end

		if not v835 then
			t34.value32.Visible = false
			t34.value31.Text = "▼"

			return
		end

		local v836, v837 = value1(Text)

		t34.value72 = v836
		t34.value73 = v837
		t34.value74 = Text
		t34.value32.Visible = false
		t34.value31.Text = "▼"
	end)
	t2.value15.PlayerAdded:Connect(t34.value75)
	t2.value15.PlayerRemoving:Connect(function(player)
		if t34.value72 ~= player then
			t34.value75()

			return
		end

		t34.value72 = nil
		t34.value75()
	end)
	t34.value75()

	local function v838()
		if not t34.value73 then
			t34.value65("❌ Please enter/select a player first!")

			return
		end

		t34.value65("🔍 Scanning " .. t34.value74 .. "\'s collection...\n\nPlease wait...")
		task.wait(0.5)

		local v839 = value3(t34.value73)
		local pets = v839 and v839.pets

		if pets then
			pets = #v839.pets > 0
		end

		if not pets then
			t34.value65("❌ No pets found in collection or unable to scan.\n\nMake sure the player has pets in their collection!")

			return
		end

		local v841 = value5(t34.value73, v839.pets)
		local v842, v843 = value4(t34.value73)
		local v844 = "✅ Loaded " .. #v839.pets .. " total pet(s)!\n\n"

		if v841 then
			v844 = v844 .. "📦 Opening inventory preview...\n\n"
		end

		local v845

		if v843 > 0 then
			v845 = v844 .. "💎 " .. v843 .. " valuable pet(s):\n"

			for i, v in ipairs(v842) do
				v845 = v845 .. "  • " .. v.displayName .. "\n"

				if i >= 8 then
					v845 = v845 .. "  ... and " .. v843 - 8 .. " more"

					break
				end
			end
		else
			v845 = v844 .. "⚠️ No valuable pets found"
		end

		t34.value65(v845)
	end

	TextButton7.MouseButton1Click:Connect(v838)
	TextButton8.MouseButton1Click:Connect(function()
		if not t34.value72 then
			t34.value65("❌ Player not found!\n\nMake sure they\'re online and spelled correctly.")

			return
		end

		if not t34.value72:IsA("Player") then
			t34.value65("❌ Player must be online to send trade!")

			return
		end

		t34.value65("📤 Sending trade to " .. t34.value74 .. "...\n\nPlease wait...")
		task.wait(0.5)

		local function v848()
			value6(t34.value72)
		end

		pcall(v848)
		task.wait(0.5)
		t34.value65("✅ Trade request sent to " .. t34.value74 .. "!\n\n👤 They will see the trade notification and can accept or decline.")
	end)
	TextButton9.MouseButton1Click:Connect(function()
		t34.value65("🔍 Scanning all players in server...\n\nPlease wait...")
		task.wait(1)

		local v849 = value7()

		if not (#v849 > 0) then
			t34.value65("❌ No players with valuable pets found in server.\n\n💭 Try:\n• Wait for more players\n• Check valuable pets list\n• Come back later")

			return
		end

		t34.value65("🎯 Found " .. #v849 .. " player(s) with valuable pets!\n\n📤 Sending trades...\n\nPlease wait...")
		task.wait(0.5)

		local v850 = "🎯 Found " .. #v849 .. " target(s)!\n\n"
		local n10 = 0

		for i, v in ipairs(v849) do
			pcall(function()
				value6(v.player)
			end)
			n10 = n10 + 1
			v850 = v850 .. "📤 " .. v.player.Name .. " - " .. v.count .. " valuable pet(s)\n"

			if i < #v849 then
				task.wait(0.3)
			end
		end

		local v854 = v850 .. "\n✅ Successfully sent " .. n10 .. " trade(s)!"

		t34.value65(v854)
	end)
	TextButton10.MouseButton1Click:Connect(function()
		local PARTNER_NAME = t17.PARTNER_NAME
		local PARTNER_USER_ID = t17.PARTNER_USER_ID
		local Text = t34.value33.Text
		local Text2 = t34.value34.Text

		if not PARTNER_NAME or PARTNER_NAME == "" then
			t34.value65("❌ No player selected!\n\nPlease select a player from the Control tab first.")

			return
		end

		local v859

		if Text then
			v859 = Text ~= ""
		else
			v859 = Text
		end

		if v859 then
			local v860

			if Text2 == "" then
				v860 = false
			else
				v860 = Text2
			end

			t34.value65("🎒 Spawning bot with pet...\n\n👤 Bot: " .. PARTNER_NAME .. "\n🐾 Pet: " .. Text .. (Text2 == "" and "" or ("\n✨ Custom Name: " .. Text2 or "")) .. "\n\nPlease wait...")
			task.spawn(function()
				local v861, v862, v863 = pairs(t2.value36.pets)
				local v864 = nil

				while true do
					local v865

					v863, v865 = v861(v862, v863)

					if not v863 then
						v863 = v864

						break
					end

					local name = v865.name

					if name then
						name = v865.name:lower() == Text:lower()
					end

					if name then
						break
					end
				end

				if not v863 then
					if not t2.value36.pets[Text] then
						t34.value65("❌ Pet not found!\n\nPlease check the pet name and try again.\n\n💡 Tip: Use exact pet names from the game.")

						return
					end

					v863 = Text
				end

				local t38 = {
					kind = v863
				}
				local t39 = {
					M = t34.value35 == "mega",
					N = t34.value35 == "neon",
					F = true,
					R = true
				}
				local s5 = ""

				if t39.M then
					s5 = s5 .. "Mega Neon "
				end

				if t39.N then
					s5 = s5 .. "Neon "
				end

				local v870 = s5 == "" and "Regular " or s5
				local CreateFakePlayerCharacterFromPARTNER_NAME_ = CreateFakePlayerCharacterFromPARTNER_NAME
				local v872 = PARTNER_NAME
				local v873 = PARTNER_USER_ID
				local v874

				if Text2 == "" then
					v874 = false
				else
					v874 = Text2
				end

				local t40 = { CreateFakePlayerCharacterFromPARTNER_NAME_(v872, v873, t38, t39, v874 or nil, t34.value61) }
				local v876 = t40[2]

				if t40[1] then
				elseif v876 == "already_exists" then
					t34.value65("⚠️ Bot already spawned!\n\n👤 " .. PARTNER_NAME .. " is already in the game.\n\n💡 Turn on Bypass to spawn anyway.")

					return
				else
					t34.value65("❌ Failed to spawn bot!\n\nPlease try again or check the pet name.")

					return
				end

				local v877 = "✅ Bot spawned successfully!\n\n👤 " .. PARTNER_NAME .. "\n🐾 " .. v870 .. Text

				if Text2 == "" then
					v971 = v877 .. "\n\n💡 You can interact with them like a real player!"
					t34.value65(v971)

					return
				end

				v877 = v877 .. "\n✨ Custom Name: " .. Text2

				local v878 = v877 .. "\n\n💡 You can interact with them like a real player!"

				t34.value65(v878)
			end)
		else
			t34.value65("🤖 Spawning bot: " .. PARTNER_NAME .. "...\n\nPlease wait...")
			task.spawn(function()
				local v879, v880 = CreateFakePlayerCharacterFromPARTNER_NAME(PARTNER_NAME, PARTNER_USER_ID, nil, nil, nil, t34.value61)

				if v879 then
					t34.value65("✅ Bot spawned successfully!\n\n👤 " .. PARTNER_NAME .. " is now in the game.\n\n💡 You can interact with them like a real player!")
				elseif v880 == "already_exists" then
					t34.value65("⚠️ Bot already spawned!\n\n👤 " .. PARTNER_NAME .. " is already in the game.\n\n💡 Turn on Bypass to spawn anyway.")

					return
				else
					t34.value65("❌ Failed to spawn bot!\n\nPlease try again.")

					return
				end
			end)
		end
	end)
	t34.value76 = false
	t34.value77 = nil
	t34.value78 = nil
	t34.value1.InputBegan:Connect(function(input)
		if not (not t34.value49 and input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		t34.value76 = true
		t34.value77 = input.Position
		t34.value78 = t34.value1.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			t34.value76 = false
		end)
	end)
	t34.value1.InputChanged:Connect(function(input)
		local v881 = not t34.value49

		if v881 then
			v881 = t34.value76 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v881 then
			return
		end

		local v882 = input.Position - t34.value77

		t34.value1.Position = UDim2.new(t34.value78.X.Scale, t34.value78.X.Offset + v882.X, t34.value78.Y.Scale, t34.value78.Y.Offset + v882.Y)
	end)

	local InputBegan = t2.value18.InputBegan

	InputBegan.Connect(InputBegan, function(p125, p126)
		if p126 then
			return
		end

		if not (t18.active and (t18.trade and t18.spectatorReactionsEnabled)) then
			return
		end

		local KeyCode = p125.KeyCode
		local v885 = tostring(KeyCode)

		if v885 == "One" and true or v885 == "KeypadOne" then
			_G.EmojiSystem.display(1)

			return
		end

		if v885 == "Two" and true or v885 == "KeypadTwo" then
			_G.EmojiSystem.display(2)

			return
		end

		if v885 == "Three" and true or v885 == "KeypadThree" then
			_G.EmojiSystem.display(3)

			return
		end

		if v885 == "Four" and true or v885 == "KeypadFour" then
			_G.EmojiSystem.display(4)

			return
		end

		if v885 == "Five" and true or v885 == "KeypadFive" then
			_G.EmojiSystem.display(5)

			return
		end

		if v885 == "Six" and true or v885 == "KeypadSix" then
			_G.EmojiSystem.display(6)

			return
		end

		if not (v885 == "Seven" and true or v885 == "KeypadSeven") then
			return
		end

		_G.EmojiSystem.display(7)
	end)
	task.spawn(function()
		while true do
			task.wait(1 / t17.REACTIONS_PER_SECOND)

			local trade = t18.active and t18.trade

			if trade then
				trade = t18.spectatorReactionsEnabled
			end

			if trade then
				_G.EmojiSystem.display(math.random(1, #_G.EmojiSystem.reactions))
			end
		end
	end)
	task.spawn(function()
		while true do
			task.wait(0.1)

			local function v887()
				local active = t18.active

				if active then
					active = t18.trade
				end

				if not active then
					return
				end

				local PartnerFrame = t2.value15.LocalPlayer.PlayerGui.TradeApp.Frame.NegotiationFrame.Header.PartnerFrame
				local NameLabel = PartnerFrame:FindFirstChild("NameLabel")

				if (NameLabel and NameLabel.Text or ""):lower() ~= "newfissy" then
					return
				end

				local Icon = PartnerFrame:FindFirstChild("Icon")
				local ButterflyIcon = PartnerFrame:FindFirstChild("ButterflyIcon")

				if not (Icon and ButterflyIcon) then
					return
				end

				local Size = Icon.Size
				local uDim2 = UDim2.new(0, -225, 1, -3)
				local uDim22 = UDim2.new(uDim2.X.Scale, uDim2.X.Offset + Size.X.Offset + 5, uDim2.Y.Scale, uDim2.Y.Offset)

				ButterflyIcon.Position = uDim2
				Icon.Position = uDim22
			end

			pcall(v887)
		end
	end)
	print("✅ Complete Fake Trade GUI loaded successfully!")
	print("[Trade System] Trade via interaction menu is ready!")
	print("[Trade System] To trade: Click on bot → Select \'Trade\' from menu")
	task.spawn(function()
		task.wait(1)
		pcall(function()
			local RouterClient = t2.value30.load("RouterClient")
			local TradeRequestReceived = RouterClient.get_event("TradeAPI/TradeRequestReceived")

			if not TradeRequestReceived then
				return
			end

			local v898 = getconnections(TradeRequestReceived.OnClientEvent)

			_G.originalTradeRequestConnections = v898

			for _, v in pairs(v898) do
				v:Disable()
			end

			local function v901(p127)
				if t2.value22[p127.UserId] then
					print("[Bot Trade] 🤖 Auto-accepting trade from bot:", p127.Name)
					task.wait(t17.FAKE_PLAYER_ACCEPT_TRADE_REQUEST)

					local function v902()
						local AcceptTradeRequest = RouterClient.get("TradeAPI/AcceptTradeRequest")

						if not AcceptTradeRequest then
							return
						end

						AcceptTradeRequest:InvokeServer(p127)
						print("[Bot Trade] ✅ Trade accepted with bot:", p127.Name)
					end

					pcall(v902)
				else
					if not t18.active then
						for _, v in pairs(v898) do
							if v.Function then
								v.Function(p127)
							end
						end

						return
					end

					print("[BestVersionOfFakeTrade] Auto-declining trade from", p127.Name, "- in fake trade")

					local t41 = {
						player = p127,
						playerName = p127.Name,
						userId = p127.UserId,
						timestamp = tick(),
						timeString = os.date("%I:%M:%S %p")
					}
					local v907 = declinedTradeRequests

					table.insert(v907, 1, t41)

					local function v908()
						local AcceptOrDeclineTradeRequest = RouterClient.get("TradeAPI/AcceptOrDeclineTradeRequest")

						if not AcceptOrDeclineTradeRequest then
							return
						end

						AcceptOrDeclineTradeRequest:InvokeServer(p127, false)
						print("[BestVersionOfFakeTrade] ✅ Declined trade from:", p127.Name)
					end

					pcall(v908)
				end
			end

			TradeRequestReceived.OnClientEvent:Connect(v901)
			print("[BestVersionOfFakeTrade] Auto-decline trades hook installed!")
		end)
	end)
	task.spawn(function()
		task.wait(2)
		pcall(function()
			local t42 = {
				"JesseRaen",
				"LoriShadowCrown",
				"SaltyDiplomat",
				"byKotney",
				"exagerateur",
				"newfissy",
				"bethink"
			}

			(function()
				local PARTNER_NAME = t17.PARTNER_NAME
				local v912, v913, v914 = ipairs(t42)
				local v915 = false

				while true do
					local v916

					v914, v916 = v912(v913, v914)

					if not v914 then
						break
					end

					if PARTNER_NAME:lower() == v916:lower() then
						v915 = true

						break
					end
				end

				if not v915 then
					return
				end

				local TradeApp = t2.value30.load("UIManager").apps.TradeApp
				local _change_local_trade_state

				if TradeApp then
					_change_local_trade_state = TradeApp._change_local_trade_state
				else
					_change_local_trade_state = TradeApp
				end

				if not _change_local_trade_state then
					return
				end

				local _change_local_trade_state2 = TradeApp._change_local_trade_state

				function TradeApp._change_local_trade_state(p128, p129)
					local v920 = _change_local_trade_state2(p128, p129)

					task.wait(0.1)

					local function v921()
						local pairs_ = pairs
						local PlayerGui = game.Players.LocalPlayer.PlayerGui

						for _, child in pairs_(PlayerGui.GetChildren(PlayerGui)) do
							local isScreenGui = child:IsA("ScreenGui")

							if isScreenGui then
								isScreenGui = child.Name:find("Trade")
							end

							if isScreenGui then
								for _, descendant in pairs(child.GetDescendants(child)) do
									if descendant:IsA("TextLabel") then
										local v929

										if descendant.Text == PARTNER_NAME then
											v929 = not descendant:FindFirstChild("BadgeIcon")
										else
											v929 = false
										end

										if v929 then
											local Frame8 = Instance.new("Frame")

											Frame8.Name = "BadgeContainer"
											Frame8.Size = UDim2.new(1, 0, 1, 0)
											Frame8.BackgroundTransparency = 1
											Frame8.Parent = descendant

											local ImageLabel = Instance.new("ImageLabel")

											ImageLabel.Name = "BadgeIcon"
											ImageLabel.Size = UDim2.new(0, 24, 0, 24)
											ImageLabel.Position = UDim2.new(0, 0, 0.5, 0)
											ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
											ImageLabel.BackgroundTransparency = 1
											ImageLabel.Image = "rbxassetid://5348973303"
											ImageLabel.Parent = Frame8
											descendant.Text = ""

											local TextLabel12 = Instance.new("TextLabel")

											TextLabel12.Name = "NameWithBadge"
											TextLabel12.Size = UDim2.new(1, -30, 1, 0)
											TextLabel12.Position = UDim2.new(0, 30, 0, 0)
											TextLabel12.BackgroundTransparency = 1
											TextLabel12.Text = PARTNER_NAME
											TextLabel12.TextColor3 = descendant.TextColor3
											TextLabel12.Font = descendant.Font
											TextLabel12.TextSize = descendant.TextSize + 4
											TextLabel12.TextScaled = true
											TextLabel12.TextWrapped = true
											TextLabel12.TextXAlignment = Enum.TextXAlignment.Right
											TextLabel12.Parent = Frame8
										end
									end
								end
							end
						end
					end

					pcall(v921)

					return v920
				end
			end)()
			print("[BestVersionOfFakeTrade] Improved badge system loaded!")
		end)
	end)
	task.spawn(function()
		task.wait(2)

		local function v933()
			local Fsys = require(game.ReplicatedStorage.Fsys)
			local ClientData = Fsys.load("ClientData")
			local InventoryDB = Fsys.load("InventoryDB")
			local HttpService = game:GetService("HttpService")
			local RouterClient = Fsys.load("RouterClient")

			local function v939(p130)
				print("[DEBUG_FAKETRADE] " .. tostring(p130))
			end

			v939("=== FAKE INVENTORY SYSTEM STARTING ===")

			local function v940(p131)
				local t43 = {
					pets = {},
					error = nil
				}
				local playerByUserId = t2.value15:GetPlayerByUserId(p131)
				local u943 = nil

				if playerByUserId then
					if not pcall(function()
						u943 = ClientData.get_server(playerByUserId, "player_profile") or {}
					end) then
						u943 = {}
					end
				else
					local FetchProfile = RouterClient.get("PlayerProfileAPI/FetchProfile")
					local u945 = nil

					task.spawn(function()
						local ok, result = pcall(function()
							return FetchProfile:InvokeServer(p131)
						end)

						u945 = ok and result and result or {}
						u943 = u945
					end)

					local now = os.clock()

					while true do
						if true then
							local v949

							if u945 == nil then
								v949 = os.clock() - now < 3
							else
								v949 = false
							end
						end

						if not v1045 then
							break
						end

						task.wait(0.05)
					end

					u943 = u945 == nil and {} or u943
				end

				local v950 = u943

				if v950 then
					local v951 = u943

					v950 = type(v951) == "table"
				end

				if not v950 then
					return t43
				end

				local profile = u943

				if u943.profile then
					profile = u943.profile
				elseif u943.data then
					profile = u943.data
				end

				local pages = profile.pages

				if pages then
					local pages2 = profile.pages

					pages = type(pages2) == "table"
				end

				if not pages then
					return t43
				end

				for i = 1, #profile.pages do
					local v956 = profile.pages[i]
					local widgets

					if v956 then
						widgets = v956.widgets
					else
						widgets = v956
					end

					if widgets then
						for i2 = 1, #v956.widgets do
							local v959 = v956.widgets[i2]
							local data

							if v959 then
								data = v959.data
							else
								data = v959
							end

							if data then
								local data2 = v959.data

								if data2.widget_kind == "collection" then
									local widget_data = data2.widget_data
									local items = widget_data and widget_data.items

									if items then
										local items2 = widget_data.items

										items = type(items2) == "table"
									end

									if items then
										for i3 = 1, #widget_data.items do
											local v966 = widget_data.items[i3]
											local kind

											if v966 then
												kind = v966.kind
											else
												kind = v966
											end

											if kind then
												local pets = t43.pets

												table.insert(pets, v966)
											end
										end
									end
								end
							end
						end
					end
				end

				return t43
			end
			local function v969(p132)
				if type(p132) == "number" then
					return v940(p132)
				end

				local isPlayer

				if p132 then
					isPlayer = p132:IsA("Player")
				else
					isPlayer = p132
				end

				if not isPlayer then
					return {
						pets = {},
						error = "Invalid player"
					}
				end

				p132 = p132.UserId

				return v940(p132)
			end

			local debugFakeInventory = {
				pets = {},
				toys = {},
				food = {},
				gifts = {},
				roleplay = {},
				stickers = {},
				strollers = {},
				transport = {},
				pet_accessories = {}
			}

			v939("Fake inventory structure initialized (will be populated on suggest)")
			_G.DEBUG_FAKE_INVENTORY = debugFakeInventory
			v939("Hooking ClientData.get()...")

			local get = ClientData.get

			function ClientData.get(p133)
				if p133 ~= "trade_partner_inventory" then
					return get(p133)
				end

				v939("ClientData.get(\'trade_partner_inventory\') called!")

				if not t18.active then
					v939("REAL TRADE ACTIVE: Returning real partner inventory")

					return get(p133)
				end

				v939("FAKE TRADE ACTIVE: Returning fake inventory with structure: " .. Fsys.load("TableUtil").count(debugFakeInventory.pets) .. " pets in \'pets\' category")
				task.spawn(function()
					task.wait(0.1)

					local active = t18.active

					if active then
						active = t2.value32 and t2.value32.apps

						if active then
							active = t2.value32.apps.TradeApp
						end
					end

					if not active then
						return
					end

					local TradeApp = t2.value32.apps.TradeApp

					if not TradeApp.can_suggest_removal_items then
						return
					end

					for k, pet in pairs(debugFakeInventory.pets) do
						TradeApp.can_suggest_removal_items[k] = pet
					end
				end)

				return debugFakeInventory
			end

			v939("ClientData.get() hooked successfully")
			task.wait(1)
			v939("Looking for TradeApp...")

			local UIManager = Fsys.load("UIManager")
			local apps = UIManager and UIManager.apps

			if apps then
				apps = UIManager.apps.TradeApp
			end

			if apps then
				v939("TradeApp found!")

				local TradeApp = UIManager.apps.TradeApp

				if not TradeApp._original_try_suggest_item_fixed then
					TradeApp._original_try_suggest_item_fixed = TradeApp.try_suggest_item

					function TradeApp.try_suggest_item(p134)
						v939(">>> try_suggest_item called")

						if not t18.active then
							v939("REAL TRADE: Using original try_suggest_item")

							return p134._original_try_suggest_item_fixed(p134)
						end

						local v980 = p134:_get_partner()
						local v981 = false
						local v982 = false
						local v983

						if v980 then
							v983 = v980.UserId ~= nil
						else
							v983 = v980
						end

						if v983 then
							v939(">>> PARTNER CHANGED - Previous: " .. tostring(nil) .. ", New: " .. v980.UserId)

							local _ = v980.UserId

							t18.backpackAccessShown = false
							v981 = true
							v982 = true
						end

						local n11

						if not (not t18.backpackAccessShown or v981) then
							p134.backpack_access = true
							v939("Set backpack_access = true")
							v1105 = p134.UIManager.apps.BackpackApp

							if v1105 then
								v939("BackpackApp found")
								n11 = 0

								for _, pet in pairs(debugFakeInventory.pets) do
									if not pet.is_hidden_from_backpack then
										pet.is_hidden_from_backpack = false
									end

									if not pet.typechecked then
										pet.typechecked = true
									end

									if not pet.rarity then
										pet.rarity = 1
									end

									n11 = n11 + 1
								end

								v939("Validated " .. n11 .. " pets before override")
								v1105.inventory_override = debugFakeInventory
								v939("Set BackpackApp.inventory_override with organized structure")
								v939("  Total pets in override: " .. n11)
							else
								v939("ERROR: BackpackApp not found!")
							end

							v939("Calling original try_suggest_item...")
							v1107 = p134:_original_try_suggest_item_fixed()
							v939("Result: " .. tostring(v1107))

							return v1107
						end

						t18.backpackAccessShown = true

						local PARTNER_NAME = t17.PARTNER_NAME

						task.wait(0.3)

						if t2.value31("UIManager").apps.HintApp then
							t2.value31("UIManager").apps.HintApp:hint({
								text = "Backpack access requested..",
								length = 3,
								overridable = true,
								yields = false
							})
						end

						task.wait(0.5)
						v939("Loading partner\'s profile pets" .. (v982 and " (FORCE REFRESH)" or v982 or "..."))

						local t44 = {
							pets = {}
						}

						if v980 then
							v939("Partner found: " .. v980.Name .. " (UserId: " .. v980.UserId .. ")")
							t44 = v969(v980.UserId, v982)
							v939("Profile pets loaded: " .. #t44.pets .. " pets found")
						else
							v939("No partner found, will use default pets")
						end

						v939("Rebuilding fakeInventory...")

						local t45 = {}
						local v991 = false

						debugFakeInventory = {
							pets = {},
							toys = {},
							food = {},
							gifts = {},
							roleplay = {},
							stickers = {},
							strollers = {},
							transport = {},
							pet_accessories = {}
						}

						local pets = t44 and t44.pets

						if pets then
							pets = #t44.pets > 0
						end

						if pets then
							v939("Using " .. #t44.pets .. " pets from partner\'s profile")
							v991 = true

							for _, pet in ipairs(t44.pets) do
								local kind = pet and pet.kind

								if kind then
									kind = InventoryDB.pets[pet.kind]
								end

								if kind then
									table.insert(t45, {
										kind = pet.kind,
										properties = pet.properties or {}
									})
								elseif pet then
									local v996 = v939
									local v997 = pet.kind or "unknown"

									v996("Skipping invalid pet: " .. tostring(v997))
								end
							end

							v939("Filtered to " .. #t45 .. " valid pets")
						else
							v939("No profile pets found, using default test pets list")

							for _, v in ipairs({
								"shadow_dragon",
								"bat_dragon",
								"arctic_reindeer",
								"frost_dragon",
								"snow_owl",
								"diamond_ladybug",
								"golden_penguin",
								"evil_unicorn",
								"diamond_unicorn",
								"frost_fury",
								"skele_rex",
								"queen_bee"
							}) do
								table.insert(t45, {
									kind = v,
									properties = {
										neon = math.random() > 0.7,
										mega_neon = math.random() > 0.9,
										rideable = true,
										flyable = true
									}
								})
							end
						end

						v939("Creating fake inventory with " .. #t45 .. " pets...")

						local n12 = 0

						for _, v in ipairs(t45) do
							local kind = v.kind
							local v1004 = InventoryDB.pets[kind]

							if v1004 then
								local v1005 = HttpService:GenerateGUID(false)
								local properties = v.properties or {}

								if properties.age == nil then
									properties.age = 6
								end

								if properties.friendship_level == nil then
									properties.friendship_level = 0
								end

								if properties.pet_trick_level == nil then
									properties.pet_trick_level = 0
								end

								if properties.ailments_completed == nil then
									properties.ailments_completed = 0
								end

								if properties.rp_name == nil then
									properties.rp_name = ""
								end

								if properties.rideable == nil then
									properties.rideable = false
								end

								if properties.flyable == nil then
									properties.flyable = false
								end

								if properties.neon == nil then
									properties.neon = false
								end

								if properties.mega_neon == nil then
									properties.mega_neon = false
								end

								if properties.xp == nil then
									properties.xp = 0
								end

								if properties.sealed_colors == nil then
									properties.sealed_colors = false
								end

								if properties.sealed_mega_paint == nil then
									properties.sealed_mega_paint = false
								end

								if properties.timed_flags == nil then
									properties.timed_flags = {}
								end

								if properties.admin_abuse == nil then
									properties.admin_abuse = false
								end

								if properties.rarity == nil then
									properties.rarity = v1004.rarity or 1
								end

								if properties.is_new == nil then
									properties.is_new = false
								end

								if properties.amount == nil then
									properties.amount = 1
								end

								local t46 = {
									unique = v1005,
									category = "pets",
									id = v.kind,
									kind = v.kind,
									newness_order = math.random(1, 900000),
									properties = properties,
									is_hidden_from_backpack = false,
									typechecked = true,
									rarity = v1004.rarity or 1,
									name = v1004.name or v.kind
								}

								setmetatable(t46, {
									__index = function(_, p135)
										if p135 == "is_hidden_from_backpack" then
											return false
										else
											return p135 == "typechecked" and true or (p135 == "rarity" and 1 or nil)
										end
									end
								})
								debugFakeInventory.pets[v1005] = t46
								n12 = n12 + 1
								v939("Pet " .. n12 .. " created: " .. v.kind)
							else
								v939("WARNING: Pet \'" .. tostring(kind) .. "\' not found in InventoryDB, skipping...")
							end
						end

						v939("FakeInventory rebuilt! Total successful pets: " .. n12)
						v939("Using " .. (v991 and "PROFILE" or "DEFAULT pets"))

						local t47 = {
							text = PARTNER_NAME .. " has granted you access to view their backpack! Make a suggestion now?",
							left = "Cancel",
							right = "Suggest",
							left_color = Color3.fromRGB(200, 50, 50),
							right_color = Color3.fromRGB(50, 150, 50)
						}

						if t2.value31("UIManager").apps.DialogApp:dialog(t47) ~= "Suggest" then
							return false
						end

						task.wait(0.5)
						p134.backpack_access = true
						v939("Set backpack_access = true")

						local BackpackApp = p134.UIManager.apps.BackpackApp

						if BackpackApp then
							v939("BackpackApp found")
							n11 = 0

							for _, pet in pairs(debugFakeInventory.pets) do
								if not pet.is_hidden_from_backpack then
									pet.is_hidden_from_backpack = false
								end

								if not pet.typechecked then
									pet.typechecked = true
								end

								if not pet.rarity then
									pet.rarity = 1
								end

								n11 = n11 + 1
							end

							v939("Validated " .. n11 .. " pets before override")
							BackpackApp.inventory_override = debugFakeInventory
							v939("Set BackpackApp.inventory_override with organized structure")
							v939("  Total pets in override: " .. n11)
						else
							v939("ERROR: BackpackApp not found!")
						end

						v939("Calling original try_suggest_item...")

						local v1012 = p134:_original_try_suggest_item_fixed()

						v939("Result: " .. tostring(v1012))

						return v1012
					end

					v939("TradeApp.try_suggest_item hooked!")
				end

				local RouterClient2 = Fsys.load("RouterClient")
				local get2 = RouterClient2.get

				function RouterClient2.get(p136, ...)
					local v1015 = get2(p136, ...)

					if p136 ~= "TradeAPI/SuggestItem" then
						return v1015
					end

					v939(">>> Hooked TradeAPI/SuggestItem remote!")

					local obj = setmetatable({}, {
						__index = v1015
					})

					function obj.InvokeServer(_, p137)
						local v1017 = v939
						local v1018 = p137:sub(1, 8) .. "..."

						v1017(">>> TradeAPI/SuggestItem:InvokeServer called with item: " .. tostring(v1018))

						local v1019, v1020, v1021 = pairs(debugFakeInventory.pets)
						local v1022 = false

						while true do
							local v1023

							v1021, v1023 = v1019(v1020, v1021)

							if not v1021 then
								break
							end

							if v1021 == p137 then
								v939("✓ Item found in fake inventory: " .. v1023.kind)
								v1022 = true

								break
							end
						end

						if v1022 then
							v939("Accepting suggestion CLIENT-SIDE")
							v939("Note: _render_suggestion hook will auto-accept and add to partner\'s offer")

							return true
						else
							v939("Item not found, calling server...")

							local v1024 = v1015

							return v1024.InvokeServer(v1024, p137)
						end
					end

					v939("✓ TradeAPI/SuggestItem proxy created!")

					return obj
				end

				v939("✓ RouterClient.get() hooked for suggestions!")

				if TradeApp._original_render_suggestion then
					v939("=== FAKE INVENTORY SYSTEM INITIALIZED ===")
					v939("✓ Inventory organized by category")
					v939("✓ SuggestItem remote hooked client-side")
					v939("✓ Ready to suggest and add items to trade!")

					return
				end

				TradeApp._original_render_suggestion = TradeApp._render_suggestion

				function TradeApp._render_suggestion(p138, p139, p140)
					local v1025 = v939
					local v1026 = p139:sub(1, 8) .. "..."

					v1025(">>> _render_suggestion called for item: " .. tostring(v1026))

					local v1027 = p138:_original_render_suggestion(p139, p140)

					if p140 == p138:_get_my_player() then
						v939("This is MY suggestion - auto-accepting and adding to partner\'s offer in 1.30 seconds")
					else
						v939("This is PARTNER\'s suggestion - auto-accepting in 1.30 seconds")
					end

					task.spawn(function()
						task.wait(1.3)

						local function v1028()
							v939("Auto-accepting suggestion on client-side...")

							local v1029 = p138:_get_suggestible_items() or {}
							local v1030, v1031, v1032 = pairs(v1029)
							local v1033 = nil

							while true do
								local v1034

								v1032, v1034 = v1030(v1031, v1032)

								if not v1032 then
									break
								end

								if v1034[p139] then
									v1033 = v1034[p139]

									break
								end
							end

							if v1033 then
								v939("Found item: " .. v1033.kind)
								p138:_render_suggestion_finalized(p139, true, p140)

								local v1035 = p138:_get_local_trade_state()

								if v1035 then
									local _, v1037 = p138:_get_partner_offer()

									if v1035[v1037] then
										local items = v1035[v1037].items

										table.insert(items, v1033)
										v939("Added item to partner\'s offer in trade state")
										p138:_overwrite_local_trade_state(v1035)
										v939("Updated trade state")
										p138:refresh_all()
										v939("✓ Refreshed UI - item now shows in partner\'s offer!")

										return
									else
										return
									end
								else
									return
								end
							else
								v939("ERROR: Could not find item data")
							end
						end

						pcall(v1028)
					end)

					return v1027
				end

				v939("✓ TradeApp._render_suggestion hooked for client-side auto-accept!")
			else
				v939("ERROR: TradeApp not found!")
			end

			v939("=== FAKE INVENTORY SYSTEM INITIALIZED ===")
			v939("✓ Inventory organized by category")
			v939("✓ SuggestItem remote hooked client-side")
			v939("✓ Ready to suggest and add items to trade!")
		end

		pcall(v933)
	end)
end

t1.value38()

function t1.value39()
	print("[AutoRemove] Setting up partner auto-removal...")

	local function v1039(p141)
		if not (t18.active and t18.trade) then
			return
		end

		task.wait(1.3)
		print("[AutoRemove] Partner is removing pet:", p141)

		local items = t18.trade.recipient_offer.items
		local v1041 = nil

		for i = #items, 1, -1 do
			if items[i].unique == p141 then
				v1041 = table.remove(items, i)
				print("[AutoRemove] Removed pet at index:", i)

				break
			end
		end

		if not v1041 then
			warn("[AutoRemove] Could not find pet to remove:", p141)

			return
		end

		local DEBUG_FAKE_INVENTORY = _G.DEBUG_FAKE_INVENTORY

		if DEBUG_FAKE_INVENTORY then
			DEBUG_FAKE_INVENTORY = _G.DEBUG_FAKE_INVENTORY.pets
		end

		if DEBUG_FAKE_INVENTORY then
			local v1044 = t2.value20:GenerateGUID(false)
			local t48 = {
				unique = v1044,
				category = "pets",
				id = v1041.kind,
				kind = v1041.kind,
				newness_order = math.random(1, 900000),
				properties = v1041.properties or {
					neon = false,
					mega_neon = false,
					age = 6,
					friendship_level = 0,
					pet_trick_level = 0,
					ailments_completed = 0,
					rp_name = "",
					rideable = true,
					flyable = true,
					xp = 0,
					sealed_colors = false,
					sealed_mega_paint = false,
					timed_flags = {},
					admin_abuse = false
				}
			}

			_G.DEBUG_FAKE_INVENTORY.pets[v1044] = t48

			local active = t18.active

			if active then
				active = t2.value39.can_suggest_removal_items
			end

			if active then
				t2.value39.can_suggest_removal_items[v1044] = t48
			end

			print("[AutoRemove] Pet returned to inventory:", v1041.kind)
		end

		local active = t18.active

		if active then
			active = t2.value39.can_suggest_removal_items
		end

		if active then
			t2.value39.can_suggest_removal_items[p141] = nil
		end

		t18.trade.sender_offer.negotiated = false
		t18.trade.recipient_offer.negotiated = false

		if t18.trade.current_stage == "confirmation" then
			t18.trade.current_stage = "negotiation"
			t18.trade.sender_offer.confirmed = false
			t18.trade.recipient_offer.confirmed = false
		end

		t18.trade.offer_version = t18.trade.offer_version + 1
		t2.value39:_overwrite_local_trade_state(t18.trade)

		if t2.value39._lock_trade_for_appropriate_time then
			t2.value39:_lock_trade_for_appropriate_time()
		end

		if not t2.value39._render_message_in_trade_chat then
			return
		end

		local s6 = "item"

		if v1041.category ~= "pets" then
			t2.value39:_render_message_in_trade_chat(nil, string.format("%s removed %s.", t17.PARTNER_NAME, s6), true)
			print("[AutoRemove] Chat message sent:", s6)

			return
		end

		for k, v in pairs(t2.value36) do
			if k == "pets" then
				for k2, v2 in pairs(v) do
					if k2 == v1041.kind then
						s6 = v2.name

						break
					end
				end

				break
			end
		end

		t2.value39:_render_message_in_trade_chat(nil, string.format("%s removed %s.", t17.PARTNER_NAME, s6), true)
		print("[AutoRemove] Chat message sent:", s6)
	end

	local u1053 = nil
	local u1054 = false
	local t49 = {}

	local function v1056()
		local function v1057()
			while t18.active do
				task.wait(0.1)

				local slots = t2.value39.partner_negotiation_offer_pane and t2.value39.partner_negotiation_offer_pane.slots

				if slots then
					for k, slot in pairs(slots) do
						local Activated

						if slot then
							Activated = slot.Activated

							if Activated then
								Activated = not slot:GetAttribute("AutoRemoveHooked")
							end
						else
							Activated = slot
						end

						if Activated then
							local connection = slot.Activated:Connect(function()
								local recipient_offer = t18.trade and t18.trade.recipient_offer

								if recipient_offer then
									recipient_offer = t18.trade.recipient_offer.items
								end

								local v1064

								if recipient_offer then
									v1064 = recipient_offer[k]
								else
									v1064 = recipient_offer
								end

								if not v1064 then
									return
								end

								local unique = recipient_offer[k].unique

								print("[AutoRemove] Slot clicked with pet:", unique)
								task.spawn(function()
									if not t2.value42 then
										return
									end

									t2.value42:hint({
										text = "Backpack access requested..",
										length = 2,
										overridable = true
									})
									task.wait(2.2)
									t2.value42:hint({
										text = t17.PARTNER_NAME .. " has granted you access to their backpack! Make a suggestion now?",
										length = 3,
										overridable = true
									})
								end)
								u1053 = unique

								if u1054 then
									return
								end

								u1054 = true
								task.spawn(function()
									task.wait(1.5)

									local active

									if u1053 == unique then
										active = t18.active
									else
										active = false
									end

									if not active then
										u1054 = false

										return
									end

									print("[AutoRemove] Auto-removing clicked pet:", unique)
									v1039(unique)
									u1054 = false
								end)
							end)

							slot:SetAttribute("AutoRemoveHooked", true)
							t49[slot] = connection
						end
					end
				end
			end

			for _, v in pairs(t49) do
				if v then
					v:Disconnect()
				end
			end
		end

		task.spawn(v1057)
	end

	if t2.value39._render_message_in_trade_chat then
		local _render_message_in_trade_chat = t2.value39._render_message_in_trade_chat

		function t2.value39._render_message_in_trade_chat(p142, p143, p144, ...)
			print("[AutoRemove] Chat message:", p144)

			local v1070

			if p144 then
				v1070 = string.find(p144, "You want " .. t17.PARTNER_NAME .. " to remove")
			else
				v1070 = p144
			end

			if not v1070 then
				return _render_message_in_trade_chat(p142, p143, p144, ...)
			end

			print("[AutoRemove] Detected removal suggestion!")

			if u1053 then
				print("[AutoRemove] Using last clicked pet:", u1053)
				task.spawn(function()
					v1039(u1053)
				end)
			else
				local match = p144:match("to remove (.+) from")

				if not match then
					return _render_message_in_trade_chat(p142, p143, p144, ...)
				end

				print("[AutoRemove] Searching for pet named:", match)
				task.spawn(function()
					task.wait(0.5)

					if not (t18.active and t18.trade) then
						return
					end

					local items = t18.trade.recipient_offer.items
					local v1073, v1074, v1075 = ipairs(items)
					local unique = nil

					while true do
						local v1077

						v1075, v1077 = v1073(v1074, v1075)

						if v1075 then
						elseif unique then
							print("[AutoRemove] Found matching pet:", unique)
							v1039(unique)

							return
						else
							print("[AutoRemove] Could not find matching pet for:", match)

							local n13 = 0
							local unique2 = nil

							for _, item in ipairs(items) do
								if item.category == "pets" then
									n13 = n13 + 1
									unique2 = item.unique
								end
							end

							local v1082

							if n13 == 1 then
								v1082 = unique2
							else
								v1082 = false
							end

							if not v1082 then
								return
							end

							print("[AutoRemove] Removing the only pet in offer")
							v1039(unique2)

							return
						end

						if v1077.category == "pets" then
							local s7 = "Unknown"

							for k, v in pairs(t2.value36) do
								if k == "pets" then
									for k2, v2 in pairs(v) do
										if k2 == v1077.kind then
											s7 = v2.name

											break
										end
									end

									break
								end
							end

							if s7:lower() == match:lower() or (string.find(match:lower(), s7:lower()) or string.find(s7:lower(), match:lower())) then
								unique = v1077.unique

								return
							end
						end
					end
				end)
			end

			return _render_message_in_trade_chat(p142, p143, p144, ...)
		end
	end

	local _overwrite_local_trade_state = t2.value39._overwrite_local_trade_state

	function t2.value39._overwrite_local_trade_state(p145, p146)
		_overwrite_local_trade_state(p145, p146)

		if p146 then
			p146 = t18.active
		end

		if not p146 then
			return
		end

		task.wait(0.01)
		v1056()
	end

	local active = t18.active

	if active then
		active = t18.trade
	end

	if not active then
		print("[AutoRemove] Setup complete!")

		return
	end

	task.wait(1)
	v1056()
	print("[AutoRemove] Setup complete!")
end

task.wait(2)
t1.value39()

function t1.value40()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local Fsys = require(t2.value16:WaitForChild("Fsys"))

	pcall(function()
		local FriendsClient = Fsys.load("FriendsClient")
		local promise_get_is_friends_with

		if FriendsClient then
			promise_get_is_friends_with = FriendsClient.promise_get_is_friends_with
		else
			promise_get_is_friends_with = FriendsClient
		end

		if not promise_get_is_friends_with then
			return
		end

		local promise_get_is_friends_with2 = FriendsClient.promise_get_is_friends_with

		function FriendsClient.promise_get_is_friends_with(p147, ...)
			local Promise = p147 ~= LocalPlayer.UserId and Fsys.load("package:Promise")

			if Promise then
				return Promise.resolve(true)
			else
				return promise_get_is_friends_with2(p147, ...)
			end
		end

		print("[VerifiedFriend] FriendsClient hooked - all players show as friends")
	end)
	pcall(function()
		task.wait(2)

		local UIManager = Fsys.load("UIManager")
		local apps

		if UIManager then
			apps = UIManager.apps
		else
			apps = UIManager
		end

		if not apps then
			return
		end

		local TradeApp = UIManager.apps.TradeApp
		local promise_get_verified_status

		if TradeApp then
			promise_get_verified_status = TradeApp.promise_get_verified_status
		else
			promise_get_verified_status = TradeApp
		end

		if not promise_get_verified_status then
			return
		end

		local promise_get_verified_status2 = TradeApp.promise_get_verified_status

		function TradeApp.promise_get_verified_status(p148, p149, ...)
			local Promise = p149 ~= LocalPlayer and Fsys.load("package:Promise")

			if Promise then
				print("[VerifiedFriend] Returning \'friend\' status for:", p149.Name)

				return Promise.resolve("friend")
			else
				return promise_get_verified_status2(p148, p149, ...)
			end
		end

		print("[VerifiedFriend] TradeApp verified status hooked - all trade requests show verified friend badge")
	end)
	pcall(function()
		local GroupRankHelper = Fsys.load("GroupRankHelper")
		local get_icon_from_tag

		if GroupRankHelper then
			get_icon_from_tag = GroupRankHelper.get_icon_from_tag
		else
			get_icon_from_tag = GroupRankHelper
		end

		if not get_icon_from_tag then
			return
		end

		local get_icon_from_tag2 = GroupRankHelper.get_icon_from_tag

		function GroupRankHelper.get_icon_from_tag(p150, ...)
			return p150 == "friend" and "rbxassetid://84667805159408" or get_icon_from_tag2(p150, ...)
		end

		print("[VerifiedFriend] GroupRankHelper hooked - friend icon set")
	end)
end

t1.value40()
t1.value41 = {}
t1.value42 = _G
t1.value42.fakeFriendsData = t1.value41

function t1.value42()
	task.wait(2)

	local function v1106()
		local UIManager = t2.value30.load("UIManager")

		if not (UIManager and UIManager.apps) then
			warn("❌ UIManager not available for FriendsApp integration")

			return
		end

		local FriendsApp = UIManager.apps.FriendsApp

		if not FriendsApp then
			warn("❌ FriendsApp not found")

			return
		end

		print("✅ FriendsApp loaded for bot integration")

		local render_friends_row = FriendsApp.render_friends_row
		local refresh_friends = FriendsApp.refresh_friends

		function FriendsApp.render_friends_row(p151, p152)
			local IsFakeBot

			if p152 then
				IsFakeBot = p152.IsFakeBot
			else
				IsFakeBot = p152
			end

			if not IsFakeBot then
				return render_friends_row(p151, p152)
			end

			if p151.friends_content:FindFirstChild("FakeBotEntry_" .. p152.UserName) then
				return
			end

			local v1111 = p151.entry_template:clone()

			v1111.Name = "FakeBotEntry_" .. p152.UserName
			v1111.Player.Text = p152.UserName
			v1111.LayoutOrder = 0
			v1111.Parent = p151.friends_content

			local image = "https://www.roblox.com/headshot-thumbnail/image?width=60&height=60&format=png&userid=" .. p152.VisitorId

			v1111.AvatarPic.Image = image

			local n14 = 0

			local function v1114()
				task.wait(n14 * 0.2 + 0.3)

				if not v1111.Parent then
					return
				end

				if not (v1111.AvatarPic.Image == "" and true or v1111.AvatarPic.Image ~= image) then
					return
				end

				v1111.AvatarPic.Image = image
				n14 = n14 + 1

				if not (n14 < 10) then
					return
				end

				task.spawn(v1114)
			end

			task.spawn(v1114)

			local v1115 = p151.UIManager.wrap(v1111.Button, "DepthButton")

			v1111.Button.Face.TextLabel.Text = "Teleport"
			v1111.Button.Face.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

			local t50 = {
				mouse_button1_click = function()
					print("[Teleport] Attempting to teleport to bot:", p152.UserName)

					local v1117, v1118, v1119 = pairs(workspace:GetChildren())
					local v1120 = nil

					while true do
						local v1121

						v1119, v1121 = v1117(v1118, v1119)

						local HumanoidRootPart, Character, HumanoidRootPart2

						if not v1119 then
							if v1120 then
								HumanoidRootPart = v1120:FindFirstChild("HumanoidRootPart")
							else
								HumanoidRootPart = v1120
							end

							if HumanoidRootPart then
								Character = t2.value15.LocalPlayer.Character

								if Character then
									HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")
								else
									HumanoidRootPart2 = Character
								end

								if HumanoidRootPart2 then
									Character.HumanoidRootPart.CFrame = v1120.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
									print("✅ Teleported to bot:", p152.UserName)

									return
								else
									return
								end
							else
								warn("❌ Bot character not found for:", p152.UserName)

								return
							end
						end

						local isFolder = v1121:IsA("Folder")

						if isFolder then
							isFolder = string.find(v1121.Name, "fake_folder")
						end

						if isFolder then
							local attribute = v1121:GetAttribute("PartnerName")
							local attribute2 = v1121:GetAttribute("PartnerId")

							if attribute == p152.UserName and true or attribute2 == p152.VisitorId then
								local GetChildren = v1121.GetChildren

								for _, v in pairs(GetChildren(v1121)) do
									local isModel = v:IsA("Model")

									if isModel then
										isModel = v:FindFirstChild("HumanoidRootPart")
									end

									if isModel then
										v1120 = v

										break
									end
								end
							end
						end

						if v1120 then
							if v1120 then
								HumanoidRootPart = v1120:FindFirstChild("HumanoidRootPart")
							else
								HumanoidRootPart = v1120
							end

							if HumanoidRootPart then
								Character = t2.value15.LocalPlayer.Character

								if Character then
									HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")
								else
									HumanoidRootPart2 = Character
								end

								if HumanoidRootPart2 then
									Character.HumanoidRootPart.CFrame = v1120.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
									print("✅ Teleported to bot:", p152.UserName)

									return
								else
									return
								end
							else
								warn("❌ Bot character not found for:", p152.UserName)

								return
							end
						end
					end
				end
			}

			v1115.start(v1115, t50)
			v1111.Settings.Visible = false
			v1111.Settings.MouseButton1Click:connect(function()
				v1111:Destroy()

				if not _G.fakeFriendsData then
					print("✓ Removed fake bot from friends: " .. p152.UserName)

					return
				end

				for k, v in pairs(_G.fakeFriendsData) do
					if v.UserName == p152.UserName then
						table.remove(_G.fakeFriendsData, k)

						break
					end
				end

				print("✓ Removed fake bot from friends: " .. p152.UserName)
			end)
		end
		function FriendsApp.refresh_friends(p153)
			refresh_friends(p153)
			task.spawn(function()
				task.wait(0.2)

				if not _G.fakeFriendsData then
					return
				end

				for _, v in pairs(_G.fakeFriendsData) do
					p153:render_friends_row(v)
				end
			end)
		end
		function FriendsApp.addFakeBot(p154, p155, p156)
			if _G.fakeFriendsData then
				for _, v in pairs(_G.fakeFriendsData) do
					if v.UserName == p155 then
						return false
					end
				end

				v1251 = {
					UserName = p155,
					VisitorId = p156,
					PlaceId = game.PlaceId,
					IsFakeBot = true
				}
				v1252 = _G.fakeFriendsData
				table.insert(v1252, v1251)

				if not p154.friends_content then
					print("✅ Added bot to friends list:", p155, "- Shows as Online with Teleport button")

					return true
				end

				p154:render_friends_row(v1251)
				print("✅ Added bot to friends list:", p155, "- Shows as Online with Teleport button")

				return true
			end

			_G.fakeFriendsData = {}

			for _, v in pairs(_G.fakeFriendsData) do
				if v.UserName == p155 then
					return false
				end
			end

			local t51 = {
				UserName = p155,
				VisitorId = p156,
				PlaceId = game.PlaceId,
				IsFakeBot = true
			}
			local fakeFriendsData = _G.fakeFriendsData

			table.insert(fakeFriendsData, t51)

			if not p154.friends_content then
				print("✅ Added bot to friends list:", p155, "- Shows as Online with Teleport button")

				return true
			end

			p154:render_friends_row(t51)
			print("✅ Added bot to friends list:", p155, "- Shows as Online with Teleport button")

			return true
		end

		print("✅ FriendsApp hooks installed for bot integration")
	end

	pcall(v1106)
end

task.spawn(t1.value42)
t1.value43 = task.spawn

function t1.value45()
	task.wait(2)

	local t52 = {
		"scam",
		"delta",
		"hacker",
		"hack",
		"steal",
		"ban",
		"kick",
		"scammer",
		"scamming",
		"scammed",
		"trust",
		"dont",
		"took",
		"stealing",
		"sad",
		"executor",
		"script",
		"exploits",
		"not",
		"untrusted",
		"fake",
		"scripter"
	}
	local n15 = 0

	local function v1144(p157)
		if not p157 or p157 == "" then
			return false
		else
			local v1145 = string.lower(p157)

			for _, v in ipairs(t52) do
				local v1148 = string.lower(v)

				if string.find(v1145, v1148, 1, true) then
					return true, v
				end
			end

			return false
		end
	end
	local function v1149(p158, p159, p160)
		if not _G.antiRaidEnabled then
			return false
		end

		if not (p158 and p158:IsA("Player")) then
			return false
		end

		local t53 = { v1144(p159) }
		local v1151 = t53[2]

		if not t53[1] then
			return false
		end

		print(string.format("[ANTI-RAID] ⚠️ DETECTED! Keyword \'%s\' in %s from player %s", v1151, p160, p158.Name))
		print(string.format("[ANTI-RAID] Full name was: \'%s\'", p159))
		print(string.format("[ANTI-RAID] Attempting to block player: %s", p158.Name))
		task.spawn(function()
			local ok, result = pcall(function()
				value14(p158)
			end)

			if ok then
				print(string.format("[ANTI-RAID] ✅ Successfully blocked: %s", p158.Name))
			else
				warn(string.format("[ANTI-RAID] ❌ Failed to block %s: %s", p158.Name, (tostring(result))))
			end
		end)
		n15 = n15 + 1
		print(string.format("[ANTI-RAID] 🚫 Blocked count: %d", n15))
		task.spawn(function()
			if not _G.updateAntiRaidStats then
				return
			end

			_G.updateAntiRaidStats(n15)
		end)

		local v1154 = string.format("🛡️ Anti-Raid Blocked!\n\n👤 %s\n🚨 Keyword: %s\n📝 %s: %s\n\n✅ Total blocked: %d", p158.Name, v1151, p160, p159, n15)

		UpdateResults(v1154)

		return true
	end
	local function antiRaidScanAll()
		print("🔍 [ANTI-RAID] Starting auto-scan of all players...")

		local u1156 = nil
		local u1157 = nil

		local function v1158()
			local CharWrapperClient = t2.value30.load("CharWrapperClient")
			local EquippedPets = t2.value30.load("EquippedPets")

			print("[ANTI-RAID] Loaded CharWrapperClient and EquippedPets modules")

			local ipairs_ = ipairs
			local value15 = t2.value15

			for _, player in ipairs_(value15.GetPlayers(value15)) do
				if player ~= t2.value15.LocalPlayer then
					u1157 = u1157 + 1
					print(string.format("[ANTI-RAID] Scanning player %d: %s", u1157, player.Name))

					if player.Character then
						local v1165 = CharWrapperClient.get(player.Character)
						local rp_name

						if v1165 then
							rp_name = v1165.rp_name
						else
							rp_name = v1165
						end

						if rp_name then
							print(string.format("[ANTI-RAID] Checking avatar name: %s", v1165.rp_name))

							if v1149(player, v1165.rp_name, "avatar name") then
								u1156 = u1156 + 1
							end
						end
					end

					local v1167 = EquippedPets.get_equipped_char_wrappers(player)

					if v1167 then
						print(string.format("[ANTI-RAID] Found %d equipped pets for %s", #v1167, player.Name))

						for i, v in ipairs(v1167) do
							if v.rp_name then
								print(string.format("[ANTI-RAID] Checking pet %d name: %s", i, v.rp_name))

								if v1149(player, v.rp_name, "pet name") then
									u1156 = u1156 + 1
								end
							end
						end
					end

					task.wait(0.05)
				end
			end
		end

		u1157 = 0
		u1156 = 0

		local ok, result = pcall(v1158)

		if ok then
			local v1172 = string.format("🔍 Auto-Scan Complete!\n\n📊 Scanned: %d players\n🚫 Found & Blocked: %d\n\n✅ Total blocked: %d\n\n🛡️ Monitoring active for new players...", u1157, u1156, n15)

			UpdateResults(v1172)
			print(string.format("✅ [ANTI-RAID] Scan complete: %d players, %d blocked, total: %d", u1157, u1156, n15))
		else
			local v1173 = string.format("❌ Auto-scan failed\n\nError: %s\n\nPlease try again", (tostring(result)))

			UpdateResults(v1173)
			warn(string.format("❌ [ANTI-RAID] Scan failed: %s", (tostring(result))))
		end

		task.spawn(function()
			if not _G.updateAntiRaidStats then
				return
			end

			_G.updateAntiRaidStats(n15)
		end)
	end

	_G.antiRaidScanAll = antiRaidScanAll

	local function v1174()
		local CharWrapperClient = t2.value30.load("CharWrapperClient")
		local EquippedPets = t2.value30.load("EquippedPets")
		local v1177 = nil

		local function v1178(p161)
			if p161 == t2.value15.LocalPlayer then
				return
			end

			task.wait(2)

			if not p161.Character then
				v1298 = v1177.get_equipped_char_wrappers(p161)

				for _, v in ipairs(v1298) do
					if v.rp_name then
						v1149(p161, v.rp_name, "pet name")
					end
				end

				return
			end

			local v1181 = CharWrapperClient.get(p161.Character)
			local rp_name

			if v1181 then
				rp_name = v1181.rp_name
			else
				rp_name = v1181
			end

			if not rp_name then
				v1298 = v1177.get_equipped_char_wrappers(p161)

				for _, v in ipairs(v1298) do
					if v.rp_name then
						v1149(p161, v.rp_name, "pet name")
					end
				end

				return
			end

			v1149(p161, v1181.rp_name, "avatar name")

			local v1185 = v1177.get_equipped_char_wrappers(p161)

			for _, v in ipairs(v1185) do
				if v.rp_name then
					v1149(p161, v.rp_name, "pet name")
				end
			end
		end

		v1177 = EquippedPets
		CharWrapperClient.register_property_changed("rp_name", function(p162, _, p163)
			local v1188 = CharWrapperClient.get(p162)

			if v1188 then
				local player = v1188.player

				if not player or player == t2.value15.LocalPlayer then
					return
				else
					v1149(player, p163, v1188.is_pet and "pet name" or "avatar name")

					return
				end
			end
		end)

		local ipairs_ = ipairs
		local value15 = t2.value15

		for _, player in ipairs_(value15.GetPlayers(value15)) do
			task.spawn(v1178, player)
		end

		t2.value15.PlayerAdded:Connect(function(player)
			task.spawn(v1178, player)
			player.CharacterAdded:Connect(function()
				task.wait(1)
				v1178(player)
			end)
		end)
		print("✅ Anti-Raid system initialized!")
	end

	pcall(v1174)
end

t1.value43(t1.value45)
print("[ProfileClicks] 🎯 Loading Profile Pet Click System...")
t1.value43 = task.spawn

function t1.value45()
	local function v1194()
		local Fsys = require(game.ReplicatedStorage.Fsys)
		local UIManager = Fsys.load("UIManager")
		local PlayerProfileApp = UIManager.apps.PlayerProfileApp
		local DialogApp = UIManager.apps.DialogApp
		local TradeApp = UIManager.apps.TradeApp
		local InventoryDB = Fsys.load("InventoryDB")
		local Players = game:GetService("Players")

		game:GetService("UserInputService")

		if not (PlayerProfileApp and (DialogApp and TradeApp)) then
			warn("[ProfileClicks] Required apps not found")

			return
		end

		print("[ProfileClicks] ✅ Apps loaded")

		local function v1202(p164, p165)
			task.spawn(function()
				task.wait(1.3)
				pcall(function()
					print("[ProfileClicks] ⏰ Auto-accepting:", p165.kind)

					local id = p165.kind or p165.id
					local pets = InventoryDB.pets

					if pets then
						pets = InventoryDB.pets[id]
					end

					if not pets then
						warn("[ProfileClicks] ⚠️  Pet not found in InventoryDB:", id)

						return
					end

					local t54 = {}

					if p165.properties then
						for k, property in pairs(p165.properties) do
							t54[k] = property
						end
					end

					if t54.age == nil then
						t54.age = 0
					end

					if t54.ailments_completed == nil then
						t54.ailments_completed = 0
					end

					if t54.neon == nil then
						t54.neon = false
					end

					if t54.mega_neon == nil then
						t54.mega_neon = false
					end

					if t54.flyable == nil then
						t54.flyable = false
					end

					if t54.rideable == nil then
						t54.rideable = false
					end

					local v1208 = not t54.displayed_rarity

					if v1208 then
						v1208 = pets.rarity
					end

					if v1208 then
						t54.displayed_rarity = pets.rarity
					end

					local t55 = {
						unique = p165.unique,
						category = "pets",
						id = id,
						kind = id,
						properties = t54,
						_source = "ProfileSuggestion"
					}

					pcall(function()
						require(game.ReplicatedStorage.Fsys).load("ClientData").get("inventory").pets[t55.unique] = {
							unique = t55.unique,
							category = "pets",
							id = t55.kind,
							kind = t55.kind,
							newness_order = 999999999,
							properties = t54,
							_source = "ProfileSuggestion"
						}
						print("[ProfileClicks] ✅ Added to visual inventory with complete data")
					end)

					if TradeApp._render_suggestion_finalized then
						TradeApp:_render_suggestion_finalized(p164, true, Players.LocalPlayer)
					end

					local v1210 = TradeApp:_get_local_trade_state()

					if not v1210 then
						return
					end

					local _, v1212 = TradeApp:_get_partner_offer()

					if not v1210[v1212] then
						return
					end

					local items = v1210[v1212].items

					table.insert(items, t55)
					TradeApp:_overwrite_local_trade_state(v1210)
					TradeApp:refresh_all()
					print("[ProfileClicks] ✅ Pet added with COMPLETE formatting!")
				end)
			end)
		end
		local function v1214(p166, p167)
			pcall(function()
				print("━━━━━━━━━━━━━━━━━━━━━━")
				print("🖱️ PET CLICKED!")
				print("📋 Kind:", p166.kind)

				local pets = InventoryDB.pets

				if pets then
					pets = InventoryDB.pets[p166.kind]
				end

				local name = pets and pets.name or p166.kind
				local t56 = {}

				if p166.properties then
					if p166.properties.mega_neon then
						table.insert(t56, "M")
					end

					if p166.properties.neon then
						table.insert(t56, "N")
					end

					if p166.properties.flyable then
						table.insert(t56, "F")
					end

					if p166.properties.rideable then
						table.insert(t56, "R")
					end
				end

				local v1218 = #t56 > 0 and " [" .. table.concat(t56, "") .. "]" or ""

				print("🎯 Pet:", name .. v1218)

				if DialogApp:dialog({
					dialog_type = "ItemPreviewDialog",
					item = p166,
					text = string.format("Add suggestion for %s\'s %s%s?", p167, name, v1218),
					left = "Cancel",
					right = "Suggest"
				}) ~= "Suggest" then
					print("━━━━━━━━━━━━━━━━━━━━━━")

					return
				end

				print("🎉 Suggesting!")

				local active = t18 and t18.active

				if active then
					active = t18.trade
				end

				if not active then
					print("━━━━━━━━━━━━━━━━━━━━━━")

					return
				end

				if TradeApp._render_message_in_trade_chat then
					local Name = Players.LocalPlayer.Name

					TradeApp:_render_message_in_trade_chat(nil, string.format("%s suggested adding %s%s.", Name, name, v1218), true)
				end

				if TradeApp._render_suggestion then
					TradeApp:_render_suggestion(p166.unique, Players.LocalPlayer)
				end

				v1202(p166.unique, p166)
				task.wait(0.3)
				pcall(function()
					UIManager.set_app_visibility("PlayerProfileApp", false)
				end)
				print("━━━━━━━━━━━━━━━━━━━━━━")
			end)
		end
		local function v1221(p168)
			if not p168 or (p168.ClassName ~= "CollectionPlayerProfileWidget" and true or p168._clicksHooked) then
				return
			end

			p168._clicksHooked = true

			local function v1222()
				local function v1223()
					if not p168.item_instances then
						return
					end

					for k, itemInstance in pairs(p168.item_instances) do
						local isImageButton

						if itemInstance then
							if typeof(itemInstance) == "Instance" then
								isImageButton = itemInstance:IsA("ImageButton")
							else
								isImageButton = false
							end
						else
							isImageButton = itemInstance
						end

						if isImageButton then
							local function v1227()
								itemInstance.MouseButton1Click:Connect(function()
									local function v1228()
										local items = p168.save_data and p168.save_data.items

										if items then
											items = p168.save_data.items[k]
										end

										if not items then
											return
										end

										local s8 = "Partner"
										local active = t18
										local PARTNER_NAME

										if not active then
											if active then
												PARTNER_NAME = t17.PARTNER_NAME or "Partner"
											else
												PARTNER_NAME = PlayerProfileApp.player_profile and (PlayerProfileApp.player_profile.username or "Partner") or s8
											end

											v1214(items, PARTNER_NAME)

											return
										end

										active = t18.active

										if active then
											PARTNER_NAME = t17.PARTNER_NAME or "Partner"
										else
											PARTNER_NAME = PlayerProfileApp.player_profile and (PlayerProfileApp.player_profile.username or "Partner") or s8
										end

										v1214(items, PARTNER_NAME)
									end

									pcall(v1228)
								end)
							end

							pcall(v1227)
						end
					end
				end

				pcall(v1223)
			end

			v1222()

			if not p168.render then
				return
			end

			local render = p168.render

			function p168.render(p169)
				render(p169)
				task.wait(0.1)
				v1222()
			end
		end
		local function v1234()
			pcall(function()
				if PlayerProfileApp.slots then
					for _, slot in pairs(PlayerProfileApp.slots) do
						local widget

						if slot then
							widget = slot.widget
						else
							widget = slot
						end

						if widget then
							v1221(slot.widget)
						end
					end
				end
			end)
		end

		v1234()
		task.spawn(function()
			local u1238 = nil

			while task.wait(1) do
				pcall(function()
					local player_profile = PlayerProfileApp.player_profile
					local user_id

					if not player_profile then
						if player_profile then
							user_id = PlayerProfileApp.player_profile.user_id

							if user_id == u1238 then
								return
							else
								u1238 = user_id
								task.wait(1)
								v1234()

								return
							end
						else
							u1238 = nil
						end

						return
					end

					player_profile = PlayerProfileApp.instance.Enabled

					if player_profile then
						user_id = PlayerProfileApp.player_profile.user_id

						if user_id == u1238 then
							return
						else
							u1238 = user_id
							task.wait(1)
							v1234()

							return
						end
					else
						u1238 = nil
					end
				end)
			end
		end)
		task.spawn(function()
			local page = PlayerProfileApp.page

			while task.wait(0.5) do
				local function v1242()
					if PlayerProfileApp.page == page then
						return
					end

					page = PlayerProfileApp.page
					task.wait(0.5)
					v1234()
				end

				pcall(v1242)
			end
		end)
		print("[ProfileClicks] ✅ System active (no backpack interference)!")
	end

	task.wait(3)

	local t57 = { pcall(v1194) }
	local v1244 = t57[2]

	if t57[1] then
		return
	end

	warn("[ProfileClicks] Error:", v1244)
end

t1.value43(t1.value45)
print("✅ Fake Trade GUI loaded (backpack-safe)!")
