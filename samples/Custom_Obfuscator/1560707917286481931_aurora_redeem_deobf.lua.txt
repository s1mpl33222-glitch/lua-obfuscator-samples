-- Deobfuscated by https://discord.gg/fxT24a7ZS
-- Detected obfuscation: Luraph v15
-- Local names are inferred from use (the original names are not in the bytecode)

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime1(...)
	error("Luraph runtime function, not devirtualized")
end

local ... = ...
local v = table.pack(...)

if not ce_like_loadstring_fn then
	if not l_fastload_enabled or not is_from_loader then
		game:GetService("Players").LocalPlayer:Kick("[Luarmor]: Use the loadstring, do not run this directly")
		wait(5)

		while true do
		end
	end
end

local str = "?"
loadstring = ce_like_loadstring_fn or loadstring
local flag = false

pcall(function()
	flag = true
	local UserGameSettings = UserSettings():GetService("UserGameSettings")

	if not UserGameSettings:GetTutorialState("nil  nil  ") then
		str = ""
		local n = ({ wait() })[1] * 1000000

		local function fn(arg)
			local n2 = 1103515245
			local n3 = 12345
			local n4 = 99999999
			local n5 = arg % 2147483648
			local n6 = 1

			return function(arg2, arg3)
				local v2 = n4
				local n7 = n2 * n5 + n3
				local n8 = n7 % v2 + n6
				n6 += 1
				n5 = n8
				n3 = n7 % 4858 * v2 % 5782
				return arg2 + n8 % arg3 - arg2 + 1
			end
		end

		local v2 = fn(n - n % 1)
		UserGameSettings:SetTutorialState("nil  nil  ", true)
		local n2 = 0

		for i = 1, 16 do
			local n3 = 0
			local n4 = 1

			for i2 = 1, 5 do
				local flag2 = v2(10, 20) > 15
				UserGameSettings:SetTutorialState("nil  nil  " .. n2, flag2)
				n3 += (flag2 and 1 or 0) * n4
				n4 *= 2
				n2 += 1
			end

			str ..= ("qwertyuiopasdfghjklzxcvbnm098765"):sub(n3 + 1, n3 + 1)
		end
	else
		str = ""
		local n = 0

		for i = 1, 16 do
			local n2 = 0
			local n3 = 1

			for i2 = 1, 5 do
				n2 += (UserGameSettings:GetTutorialState("nil  nil  " .. n) and 1 or 0) * n3
				n3 *= 2
				n += 1
			end

			str ..= ("qwertyuiopasdfghjklzxcvbnm098765"):sub(n2 + 1, n2 + 1)
		end
	end
end)

while not flag do
end

local now = os.clock()

if devsignature_sig then
	print([[        Luarmor - Lua whitelist service
        This is a signature - If you are seeing this, you know what not to do :3
        Have a good day!
        https://luarmor.net/
    ]])
end

local flag2 = nil
local flag3 = nil
local v2 = ({ table.unpack(v, 1, v.n) })[3]

if v2 and v2[1] then
end

local floor = math.floor
local random = math.random
local remove = table.remove
local char = string.char
local n = 0
local n2 = 2
local tbl = {}
local tbl2 = {}

for i = 1, 256 do
	tbl2[i] = i
end

repeat
	local v3 = random(1, #tbl2)
	local v4 = remove(tbl2, v3)
	tbl[v4] = char(v4 - 1)
until #tbl2 == 0

local tbl3 = {}

local function fn()
	if #tbl3 == 0 then
		n = (n * 149 + 4033097371307) % 35184372088832

		repeat
			n2 = n2 * 37 % 257
		until n2 ~= 1

		local n3 = n2 % 32
		local n4 = floor(n / 2 ^ (13 - (n2 - n3) / 32)) % 4294967296 / 2 ^ n3
		local n5 = floor(n4 % 1 * 4294967296) + floor(n4)
		local n6 = n5 % 65536
		local n7 = (n5 - n6) / 65536
		local n8 = n6 % 256
		local n9 = n7 % 256
		tbl3 = { n8, (n6 - n8) / 256, n9, (n7 - n9) / 256 }
	end

	return table.remove(tbl3)
end

local tbl4 = {}
local v3 = tbl4

local function fn2(arg, arg2)
	local v4 = tbl4

	if not v4[arg2] then
		tbl3 = {}
		local v5 = tbl
		n = arg2 % 35184372088832
		n2 = arg2 % 255 + 2
		v4[arg2] = ""
		local n3 = 77

		for i = 1, #arg do
			n3 = (string.byte(arg, i) + fn() + n3) % 256
			v4[arg2] = v4[arg2] .. v5[n3 + 1]
		end
	end

	return arg2
end

local v4 = LUARMOR_SkipAntidebugDevMode
local v5 = LUARMOR_AllowKeyCheckSkip
local flag4 = ff97f23b97f93792992999 and ff97f23b97f93792992999() == v3[fn2("\172", 31126577901884)] or false
local v6 = v3[fn2("6\143K\188=\r\226\146\248&\176;\3\231Æ\133\143\248\204_\184\222\229\157\254\25", 2340828612740)]
local v7 = USE_NON_SSL_NODE
local v8 = l_fastload_enabled
local n3 = os[v3[fn2("(\204\6\168", 4882453074371)]](os[v3[fn2("UC\178}", 12971197083440)]](v3[fn2("\139L", 33012126087192)])) - os[v3[fn2("vܢ\204", 5436520764359)]](os[v3[fn2("f\150\187#", 4318721413046)]](v3[fn2("\209\6D", 24300592814183)]))
local n4

if n3 < 0 then
	n4 = (86400 + -(-n3 % 86400)) % 86400
else
	n4 = n3 % 86400
end

local n5 = n4 / 3600

if n5 >= 21 or n5 < 5 then
	local tbl5 = {}
	local v9 = v3[fn2("\226XO\140q\210K\180:%\205B\254\182.y\229\163\245\219v$\209Y\171\6f", 3448963992716)]
	local v10 = v3[fn2("N\235X\233G\12\243\241ˣ@s\250\190\137\214\t\2267j\174\247\195\241\237\1\160", 16047561292385)]
	tbl5[1] = v9
	tbl5[2] = v10
	v6 = tbl5[math[v3[fn2("\195K\\\173\155:", 14086848885567)]](1, 2)]
elseif n5 >= 5 and n5 < 15 then
	local tbl5 = {}
	local v9 = v3[fn2("\136M\165r\0017j\254\186\147Ds\224x\241\151\231]k\137\28\184\17f,\138\149", 25839311805952)]
	local v10 = v3[fn2("\211:<?S\222\17[!\164Yl\240F\230\"\193\251\128\220a\29\252\133\u{87}\163", 2297877629020)]
	local v11 = v3[fn2("s\146p: \167\177_\228\255\136kW\246\245\253e\146M\245\19T\169IP\21\187", 2572763924828)]
	local v12 = v3[fn2("'\26L\252\146.\25c\151\208\248ϕ\154\r\229I\243\26\149\181\139k`+\16\2", 19333311546965)]
	local v13 = v3[fn2("$\1C\213\234\205?\169\200\"\188@\0\188\128\27C\244\12\203l\224\3p\245\187\233", 21697763200751)]
	local v14 = v3[fn2("\30\197\216\\\25\163\155i\1304i\2af\14\181\15\174MD\174\131\206\208Zã", 15465575462979)]
	local v15 = v3[fn2("\5ڝ_\154\171yf\184\193\138\26T\188\11\16#K\128\144:\7\197m\210\14\252", 30187025133009)]
	local v16 = v3[fn2("\182\186\142\199\t\163\189V 8\195g\230w\148\228\193v\199\\\186\212\246\174\130H\254", 19714501527480)]
	local v17 = v3[fn2("\248~\133\207\196r\178\244G\251 /\n\30\169\154%m\187W\141{\235\246\179\243\240", 7900833455294)]
	local v18 = v3[fn2("*\211\203v\129\12j\218\209A\222\15\186[S\135\165w\1725[tI\n \212\199", 17090196422188)]
	local v19 = v3[fn2("y\193\242QA\127\235\22\"\3\134\159.\0\5\224\130\236\239\27\254.\224\194ż\188", 25925213773392)]
	tbl5[1] = v9
	tbl5[2] = v10
	tbl5[3] = v11
	tbl5[4] = v12
	tbl5[5] = v13
	tbl5[6] = v14
	tbl5[7] = v15
	tbl5[8] = v16
	tbl5[9] = v17
	tbl5[10] = v18
	tbl5[11] = v19
	v6 = tbl5[math[v3[fn2("xԳ\192\182-", 34852575739594)]](1, 11)]
elseif n5 >= 15 and n5 < 21 then
	local tbl5 = {}
	local v9 = v3[fn2("\240\230R\240>\184pcy\16\164\25JH\231\14\235b\3\8\138b\1\249\194\4\255", 13222460338202)]
	local v10 = v3[fn2("\132\141w\195|l\143>'\247n\175\248+\249\226\144<C!*\177\160\233\21\2I", 27390916092837)]
	local v11 = v3[fn2("\rl\1903\128\248l\136-%\192js\153c\179\238b\157\207\209#\200;\238Nt", 14158791783298)]
	tbl5[1] = v9
	tbl5[2] = v10
	tbl5[3] = v11
	v6 = tbl5[math[v3[fn2("\237\238q\243\0025", 446690230688)]](1, 2)]
else
	game:GetService(v3[fn2("\11\19\5\4\2527\137", 10601376556689)])[v3[fn2("6\164p?\177pjs'\184]", 30941888671888)]]:Kick(v3[fn2("XЀ\129\142\231\6\145\130ښz\231[\253\250\28A\140`;m\\\243C\167d_\8뵟\11\24\4̩\172S\rH\235-E\0079\1519lH\149-C3\130)\225\20\162{1\228ܞ", 31900769383437)])
end

pcall(function()
	if game:GetService(v3[fn2("Y4\161\128j\n\206\18\4\2551z\235۾\220\26C\148", 26759536632153)]):GetCountryRegionForPlayerAsync(game:GetService(v3[fn2("A\209q\131\160\177\219", 8137063865754)])[v3[fn2("\255\189\244ˢ\218K\216I\131\254", 24768758536731)]]) == v3[fn2(";%", 6519959328696)] then
		local tbl5 = {}
		local v9 = v3[fn2("l\205hnf\2268}\206\25\1781{\11\1981/\224\8\179\240\27-\r\205#\151", 30974101909678)]
		local v10 = v3[fn2("\n\230\168\228\154T\28\183\22\226r\177\0\0042f+\129\184ʟ\193ͤ\166\128i", 12874557370070)]
		local v11 = v3[fn2("\31\140C\234\224\0128'uqF\230\160\26)\210ߣ\139\172\132w\172\181\245\250\246", 25825352736243)]
		local v12 = v3[fn2("Q\t\222t?\167\240\222K|Jn\228\232[\172OO\133\25\130Ϋ\203\24\190&", 1597776594384)]
		local v13 = v3[fn2("w׆z\184Rػ\135\17w\149\1628\245<t\183\218\"9\180&\154\173oS", 24407970273483)]
		tbl5[1] = v9
		tbl5[2] = v10
		tbl5[3] = v11
		tbl5[4] = v12
		tbl5[5] = v13
		v6 = tbl5[math[v3[fn2("\182\163/Pv\178", 434878710165)]](1, 5)]
	end
end)

local tbl5 = { [v3[fn2("$GBp\229(\220", 25758778711477)]] = v3[fn2("\233\191\12", 22757578724042)] }
tbl5[v3[fn2("\168)[\4", 30887126167645)]] = flag4 and LT_R_RRT_H or v3[fn2("\145\199\235ښ\255A\27", 5940121048476)] .. v6
tbl5[v3[fn2("-\187\163M\25\167\217@", 4026654723750)]] = "3c623a1403a704a33a5552fbca911b37"
tbl5[v3[fn2("|\153\251\252\129+\213c\238\189\31]\198", 318911054121)]] = "0013"
tbl5[v3[fn2("\255u\7\188", 2453574945005)]] = "Traced Code Redeemer"

if v7 then
	tbl5[v3[fn2("P+\173\t", 11860914154278)]] = v3[fn2("\190\203\210Z\214\212\25ې\173pԼ\146\25\18\18\16\133\139\193獓ݓ\217", 22440815219107)]
	v6 = v3[fn2("_\12\235cw\2309\u{84}\23,d\224NS\22X\5\19p", 20241724852643)]
end

local flag5 = type(({ table.unpack(v, 1, v.n) })[1]) ~= v3[fn2("\242\19\150\29>", 10561646896748)]
local flag6 = false
local fn3 = nil
local n6 = nil
local tbl6 = nil
local tbl7 = nil
local flag7 = nil
local v9 = nil
local tbl8 = nil
local v10 = print
local v11 = next
local v12 = string[v3[fn2("2\2521\5", 29730670930984)]]
local v13 = identifyexecutor
local v14 = game
local v15 = pcall
local v16 = string[v3[fn2("\159\240\254\230\24\28", 19614640490331)]]
local v17 = debug[v3[fn2(";+\25\153&\188\15\128\26", 12781138980479)]]
local v18 = tonumber
local v19 = setmetatable
local v20 = rawget
local v21 = wait
local v22 = debug[v3[fn2("P\221{\181\235n\227", 23381441762575)]]
local v23 = loadstring
local v24 = os[v3[fn2("X\184mZ", 16176414243545)]]
local v25 = string[v3[fn2("U\235\251\154", 32087606162619)]]
local v26 = string[v3[fn2("\175\1522", 25909107154497)]]
local v27 = spawn
local v28 = game:GetService(v3[fn2("`B\166#\255jI\172]^", 4772928065885)])[v3[fn2("\160\129EكZ\5\18\24", 20189109897586)]]
local v29 = os[v3[fn2(">^S\159\159", 3206290934698)]]
local v30 = rconsoleprint
local v31 = math[v3[fn2("\165A7e", 11417445247369)]]
local v32 = tostring
local v33 = pairs
local v34 = string[v3[fn2("\3\155\250\194", 32580468700806)]]
local v35 = getgenv
local flag8 = false

local function fn4(arg, arg2)
	v23(v3[fn2("i\154\24+|X6!\178ڻ\204ηA\11\7\248<\206\28\245\222c\174\5\23\227\240?Iz\250a4S.\240\147t\199\0065\4\145\11\239\203\2.\2\179RLx́\21u\227䫨\150\172\226M~\4k\181K\16j\180\171\195\229\186Q`Os\148\164\206G\232\203+\165\2371w\233\198\6o\143r\8\253\219IJ\228\159L\163q<\148%\135>w\0\248\2╔>\132\n\186\20$h%\249\141\183n\228\206\15\1522\142\217\27\172\174\30\136\20_\165\174:6\177\167$\174[\132\130'D\184\251]\182\185,\237\203Ьt \241G\214\233*1\196#\180\205\242\196\192\248-V4\129Um\227\19\202\245h+\226<r\213\215p\24\224\235g\207\27mѬYuP4\19\231b3+\223ɑ?ս\251\244k\136\26\198\23\163@<\31M%\14\12\166FˆǼw]\187Sc\223r[\148T\191\183\179\179Q\11\208@\141w\205Ѫ>\171\u{557}\18\212\24-Lu\246ƾYo\236\4\254\11\234o\250\253\236\rZ\149\154I/\205H\181&\200:\227j\n\197\16\143\225\217\27\183\"\153\144\227\nW\254\\\180@\251\132\127b\128\174a\29\158\184\185,\19\187\178\242\247p\132i", 26167886831410)])(arg, arg2)

	while v21() do
	end
end

local tbl9 = {}
local flag9 = false
local v36 = string[v3[fn2("\189[J\156\131h", 30415739121318)]]
local v37 = string[v3[fn2("\1510\206", 13348091965583)]]
local v38 = table[v3[fn2("k\188*TG\222", 11500125891030)]]
local v39 = type
local v40 = v33
local v41 = v21
local v42 = coroutine[v3[fn2("\177߽\215", 9666118886186)]]
local v43 = syn and syn[v3[fn2("Z\185\149\247\174\30\161\141\220", 26705847902503)]] and syn[v3[fn2("\137ҫ\217\r2\137v\146", 25551540215028)]][v3[fn2("fӟ\144\186|\152", 30015221198129)]]
local v44

if v43 then
	v44 = v43
else
	v44 = WebSocket and WebSocket[v3[fn2("\202Be\155Q\245>", 758084862658)]]
end

local fn5 = v44 or WebsocketClient and function(arg)
	local v45 = WebsocketClient[v3[fn2("\188m\224", 16394390485924)]](arg)
	v45:Connect()
	return v45
end

local fn6 = nil

fn6 = function(arg)
	local tbl10 = {}

	for k, v45 in v40(arg) do
		local n7 = #tbl10 + 1
		local v46 = v3[fn2("'\200\247\146 \170_\227", 34886936526570)]
		local v47 = v3
		local flag10 = v39(v45) == v47[fn2("\20/x-\133", 7497094208326)] and fn6(v45)
		local str2

		if flag10 then
			str2 = flag10
		else
			local v48 = v3
			str2 = v3[fn2("=", 18649317131224)] .. v45 .. v48[fn2("Z", 173951484066)]
		end

		tbl10[n7] = v36(v46, k, str2)
	end

	return v3[fn2("i", 24314551883892)] .. v37(v38(tbl10), 0, -2) .. v3[fn2("\194", 22373167419748)]
end

local function fn7(arg)
	local function fn8(arg2)
		if arg2 == v3[fn2(",\196P\\", 10051603965073)] then
			if flag8 then
				local v45 = v3
				v30(v3[fn2("\188", 31749367165824)] .. os[v3[fn2("\0302\18I\236", 28036254623230)]]() .. v45[fn2("]F\213\251\200_\178F\20\156:\132P\20@C\245\5rT\147\137\228\134\r\254\141{\211", 1801793767054)])
			end

			arg[v3[fn2(",\186lJ\254\246p\224", 16202184833777)]] = tick()
			return
		end

		local v45 = v3
		local v46 = string[v3[fn2("\159\11\208\29\209", 9071247761664)]](arg2, v45[fn2("\188\201\31<\247\150\244\169-\6\18", 23326679258332)])

		if flag8 then
			local v47 = v3
			v30(v3[fn2("\7", 33022863833122)] .. os[v3[fn2("\127>\184\15\133", 17304951340788)]]() .. v3[fn2("\1651f.\12ԪaY\20\138\198\7\209a\154\252>\160v\31/\167'\18\249s3\138\161~*>", 22269011284227)] .. arg2 .. v47[fn2(" ", 17028991270387)])
		end

		if v46 then
			local v47 = arg[v3[fn2("Ƣn!\210\2\204y", 20264274119096)]][v46 + 0]
			local v48 = v3
			v47:Fire(arg2:gsub(v3[fn2("2\186\6u\237\151?\157\214\218\26", 16177488018138)], v48[fn2("", 19126073050516)]))
			return v47:Destroy()
		end

		return arg[v3[fn2("\222Jͮlw\170\t\1\159\242Xx\250i", 33181782472886)]]:Fire(arg2)
	end

	local fn9 = nil

	fn9 = function()
		if flag8 then
			local v45 = v3
			v30(v3[fn2("\20", 25372219857997)] .. os[v3[fn2("\31\244\136j\213", 5980924483010)]]() .. v45[fn2("\245\140.:\174\129O1!\183\\", 29455784635176)])
		end

		arg[v3[fn2("\154p\255\171h\15\253<\144\234\187\20\22\154\6", 7238314531413)]] = false

		if arg[v3[fn2("\150\184\188@_\170\153\19\224ڥ5", 8969239175329)]] or flag9 then
			if flag8 then
				v30(v3[fn2("\215̡\147q1\177\167\170\11O\146&\250\134\170g|", 12225997515898)])
			end

			return
		end

		local n7 = 0
		local v45

		while true do
			if flag8 then
				local v46 = v3
				v30(v3[fn2("\8", 25877967691300)] .. os[v3[fn2("\242\131\241\176\153", 32213237790000)]]() .. v46[fn2("\158\5\232\183M\152\162w\231Y\191\203\31\168H\18Cu\188<\171s\200\226N\20\133\25n\255\209ȴV\192\30ǁv", 28825478949085)])
			end

			local v46 = v24()
			local flag10 = false
			local v47 = nil
			v45 = nil

			v27(function()
				local v48, v49 = v15(fn5, arg[v3[fn2("\23\20\24", 29848786136214)]])
				v47 = v48
				v45 = v49
				flag10 = true
			end)

			while not flag10 and v24() < v46 + 8 do
				v41()
			end

			if flag8 then
				local v48 = v3
				v30(v3[fn2("\128", 29034864994720)] .. os[v3[fn2("\175\nP\245\156", 12251768106130)]]() .. v3[fn2("z\24ث\148\2523\254\223\1\222Q\227{\241\197\249\\\11_h\181", 34490713701753)] .. v32(flag10) .. v3[fn2("\127\132\31\28g\n", 10375883892159)] .. v32(v47) .. v48[fn2("\12", 27328637166443)])
			end

			if not flag10 then
				flag6 = false
				n7 = 10

				if flag8 then
					warn(v3[fn2("\226\255\210W,\15\226\250ESIn\195\237\222O\184\158,R\173\222\226\25\17\167\176R\229\224\251", 13362051035292)])
				end
			end

			if not v47 then
				n7 += 1

				if n7 > 5 then
					flag6 = false
				end

				v41(n7 < 4 and 10 or 120)
				continue
			end

			break
		end

		if flag8 then
			local v46 = v3
			v30(v3[fn2("\194", 33361102829917)] .. os[v3[fn2("nG\178p\189", 1458185897294)]]() .. v46[fn2("\148\235A|\17\230\0113\2209x\22|\149\178\167\141\242\182\164\19x\130\238", 2558804855119)])
		end

		arg[v3[fn2("\204*c\136֯\156\235c\228#\163\143\18\204", 14980229346943)]] = true
		arg[v3[fn2("\196\28p0\225\186\219]\246", 13544592716102)]] = v45
		flag6 = arg
		local v46 = v3

		v45:Send(fn6({
			[v3[fn2("\144\157\26\202J\143", 30815183269914)]] = v46[fn2("\158\177\19U", 18578448008086)],
			[v3[fn2("\222U\224\t", 256632127727)]] = {},
		}))

		v15(function()
			v45[v3[fn2("k(\166.\2433M", 11661192079980)]]:Connect(fn9)
			v45[v3[fn2("\15\210\249~|\227\202\248q", 12796171824781)]]:Connect(fn8)
		end)

		v15(function()
			v45[v3[fn2(" URU\22\156\133D\244\18\140\156u\238\15*", 31006315147468)]]:Connect(fn9)
			v45[v3[fn2("v\150P\222B\136';\166\162\1439", 3526275763412)]]:Connect(fn8)
		end)
	end

	v15(function()
		local v45 = v3
		arg[v3[fn2("\0Q8\178\17K1\246R", 27593859490914)]][v45[fn2("Q\211s\145*Q?", 8519327620862)]]:Connect(fn9)
		local v46 = v3
		arg[v3[fn2("\197,r \183r\1669N", 8460270018247)]][v46[fn2("Ó@Qd\143\153|\223", 32507452028482)]]:Connect(fn8)
	end)

	v15(function()
		local v45 = v3
		arg[v3[fn2("\29i\"\207\r\254\208\235\162", 33601628338749)]][v45[fn2("\127\0\163\179\239\249y\205g\245RE", 27001135915578)]]:Connect(fn8)
		local v46 = v3
		arg[v3[fn2("Z_\28\178_Aͣ8", 23336343229669)]][v46[fn2("h\177\227\15\189\1384\185\128\r\248H7\209\205\244", 11453953583531)]]:Connect(fn9)
	end)

	arg[v3[fn2("U0\18973y\172\177", 26105607905016)]] = tick()

	while v41(10) do
		if flag8 then
			local v45 = v3
			v30(v3[fn2("\145", 14951237432932)] .. os[v3[fn2("\2286\234N\229", 22975554966421)]]() .. v45[fn2("ח\31]\186]\218A}\226[{\251\17t\146էړg\20\toć:\170", 14658096969043)])
		end

		if arg[v3[fn2("\200tK\173\215\207e8\175\212\11Or\171\158", 15693215676695)]] then
			local v45 = v3

			arg[v3[fn2("t\168\177Eņ\218\30\232", 31886810313728)]]:Send(fn6({
				[v3[fn2("+\30H\139\251Z", 29989450607897)]] = v45[fn2("\234\23\201\8", 21721386241797)],
				[v3[fn2("\227o\137\144", 9220502430091)]] = {},
			}))

			if tick() - arg[v3[fn2("\161\183W҉G\174\t", 26743430013258)]] > 20 then
				if flag8 then
					local v46 = v3
					v30(v3[fn2("=", 25162833812362)] .. os[v3[fn2("\2501\245\132\"", 26944225862149)]]() .. v46[fn2("\240\161\251\171\150\228~\247ֶ\166T\188\2\n\31\4\nlA!\3P\242", 20296487356886)])
					warn(v3[fn2("\222\6\189\254ChVJX'\161Kl\129", 21935067385804)])
				end

				arg[v3[fn2("\156\156&\216d,<\149*", 15423698253852)]]:Close()
			end
		end
	end
end

tbl9.new = function(arg, arg2)
	local tbl10 = {}
	v19(tbl10, arg)
	arg[v3[fn2("\227t\243=\230\148\11", 15742609307973)]] = arg
	local v45 = v24()
	local flag10 = false
	local v46 = nil
	local v47 = nil

	v27(function()
		local v48, v49 = v15(fn5, arg2)
		v46 = v48
		v47 = v49
		flag10 = true
	end)

	while not flag10 and v24() < v45 + 8 do
		v41()
	end

	if not flag10 then
		flag6 = false
		error(v3[fn2("\184y\139\177~s\r\17\174\255$3ٲv\2472N_\151S\1428", 21285433757039)])
	end

	assert(v46, v47)
	arg[v3[fn2("\232\nl\8\221\198\244\158\162", 15444099971119)]] = v47
	arg[v3[fn2("\212\216b", 32886494459811)]] = arg2
	local v48 = v3
	arg[v3[fn2("\154\254+\5n)\173\161d\163\227\187\2262\186", 7107314031067)]] = Instance[v3[fn2("f̜", 13855987348072)]](v48[fn2("\12\2423\140\203\204q\2223\23\184\t\169", 19879862814802)])
	local v49 = v3
	arg[v3[fn2("\246M\198tb߸\2464", 4490525347926)]] = arg[v3[fn2(">RVz5\150\2A\180;\184ķ\181\202", 26856176345523)]][v49[fn2(">4z\139p", 25648179928398)]]
	arg[v3[fn2("sfê\t\245<\19", 6486672316313)]] = {}
	arg[v3[fn2("U\245\146]\170\143@8N@#\176\212\228\178", 12321563454675)]] = true
	v42(fn7)(arg)

	repeat
		v28:Wait()
	until arg[v3[fn2("\174\181j@\3-\232\22", 34774190194305)]]

	return tbl10
end

tbl9.request = function(arg, arg2)
	if flag8 then
		local v45 = v3
		v30(v3[fn2("v", 34172876422225)] .. os[v3[fn2("\1532\200F\140", 32307729954184)]]() .. v3[fn2("O\221\216+\241\133\255\226;\180\16\22\27\253\203\u{58C}\246l\7\148o\130TO\4\nO\140\200\0u?\140u\183\132J\245hS\144\30<\219\3", 4505558192228)] .. v32(arg[v3[fn2("\239調\168\155^Q\134(\151\189m\150\196", 22259347312890)]]) .. v45[fn2("\200", 12545982344612)])
	end

	local n7 = 0

	while not arg[v3[fn2("\214\240x\235\156NC\182\231{\193cx\215d", 1803941316240)]] do
		n7 += 1
		v41(0.1)
		if not (n7 > 40) then
			continue
		end

		if flag8 then
			warn(v3[fn2("\1950\131r\170\212EȪ\218Bil", 4536697655425)])
		end

		flag6 = false
		return v3[fn2("", 22063920336964)]
	end

	if flag8 then
		local v45 = v3
		v30(v3[fn2("Y", 27805393085735)] .. os[v3[fn2("\207\199us@", 9663971337000)]]() .. v45[fn2("bp\228\206D\24\1659\145\143\129bc\145\235\171\\\3\127[\2340x\247[\199GvH\160Q\147?\225̣w\tC", 19677993191318)])
	end

	local v45 = math[v3[fn2("\158\226\202\\\232\159", 458501751211)]](1, 99999999)
	local v46 = v3
	local v47 = Instance[v3[fn2("J\3\167", 23438351816004)]](v46[fn2("\203%q\241\205e\171\179\26\144\200.v", 12404244098336)])

	if flag8 then
		local v48 = v3
		v30(v3[fn2("o", 27769958524166)] .. os[v3[fn2(">\238W\231\186", 6757263513749)]]() .. v48[fn2("\221O\190w\196!\176\224\7\187#ʮgm\217c", 26137821142806)])
	end

	arg[v3[fn2("\227\197\200eba\232\t", 21769706098482)]][v45] = v47
	local v48 = v3

	arg[v3[fn2("\178\18Q\147\250:[\134\176", 17162139319919)]]:Send(fn6({
		[v3[fn2("~\148\234\238Ɗ", 22738250781368)]] = v48[fn2("\142YQϺ\16\149", 21390663667153)],
		[v3[fn2("s\182\11\31", 24974923258587)]] = arg2,
		[v3[fn2("\183\1", 1700858955312)]] = v45,
	}))

	if flag8 then
		local v49 = v3
		v30(v3[fn2("\215", 27636810474634)] .. os[v3[fn2("-O0\128\243", 26764905505118)]]() .. v49[fn2("\229\171\27\129\190\143\178\29\245<<\251}yL", 15506378897513)])
	end

	local flag10 = false

	v27(function()
		v41(30)

		if not flag10 then
			if flag8 then
				local v49 = v3
				v30(v3[fn2("\178", 20659423169320)] .. os[v3[fn2("͗q;\138", 2741346535929)]]() .. v49[fn2("\195wkZ\144wȺ\168\1644\255\201\252U=\131\243\6\174KR!\250\179?ä\203\200\249\131\225<=c\8\216H\2452C\236\245\5\156", 29761810394181)])
			end

			local v49 = arg[v3[fn2("į\140R\1966\251\147", 8061899644244)]][v45]
			v49:Fire(v3[fn2("", 10378031441345)])

			if flag8 then
				local v50 = v3
				v30(v3[fn2("\19", 4223155474269)] .. os[v3[fn2("\138J\234w\251", 2422435481808)]]() .. v50[fn2("\220\225Ȣ\212/\159\152\17\130\1\192\160\175\215+\170\142-\222\01938\151\237#G\250s}\166a\1", 34310319570129)])
			end

			return v49:Destroy()
		end
	end)

	local v49 = v47[v3[fn2("6y\14\152\246", 14892179830317)]]
	flag10 = true
	return (v49:Wait())
end

tbl9.close = function(arg)
	arg[v3[fn2("\241\199\234^{\15\210n\242Θ\147", 28222017627819)]] = true
	arg[v3[fn2("\248Ot\178\26\"\163W\188", 11388453333358)]]:Close()
end

local v45 = script_key or v3[fn2("O8\150\147", 28215574980261)]
local n7 = 0
local flag10 = false

v27(function()
	flag10 = true

	while not flag7 do
		n7 += 1
		v28:Wait()
	end
end)

while not flag10 do
	v28:Wait()
end

local function fn8()
	local v46 = n7

	while n7 == v46 do
		v28:Wait()
	end
end

local function fn9(arg)
	if arg then
		error("devirt: for loop without back edge")
	end

	while v21() do
	end
end

local function fn10(arg)
	for i = 1, 2 do
		local n8 = arg % 9915 + 4
		local n9 = nil
		local n10 = nil

		for i2 = 1, 3 do
			n9 = arg % 4155 + 3

			if i2 % 2 == 1 then
				n9 += 522
			end

			n10 = arg % 9996 + 1

			if n10 % 2 ~= 1 then
				n10 *= 3
			end
		end

		local n11 = arg % 9999995 + 1 + 12874
		local n12 = arg % 1000
		local n13 = fn3((arg - n12) / 1000) % 1000
		local n14 = arg % (n8 * n9 + 9999) + 12874
		arg = (n12 * n13 + n11 + arg % (419824125 - n11 + n12) + (n14 + n12 * n9 + n13) % 999999 * (n11 + n14 % n10)) % 99999999999
	end

	return arg
end

local n8 = 1
local v46 = syn and syn[v3[fn2("D\180\156f\239S\239", 24172813637616)]] or request or http_request

if v13 and ({ v13() })[1] == v3[fn2("\25\247}t\225\1\187", 7949153311979)] then
	n8 = 9
elseif v13 and ({ v13() })[1] == v3[fn2("\144\144T\182[\138\11\21\232z", 2290361206869)] then
	if ({ v13() })[2] == v3[fn2("@I\129", 19850870900791)] then
		n8 = 5
	else
		n8 = 2
	end
elseif FLUXUS_LOADED or EVON_LOADED or WRD_LOADED or COMET_LOADED or OZONE_LOADED or TRIGON_LOADED then
	n8 = 4
elseif KRNL_LOADED then
	n8 = 3
elseif Electron_Loaded then
	n8 = 6
elseif v13 and ({ v13() })[1] == v3[fn2("\171\192\220JXȜ", 12815499767455)] then
	n8 = 7
elseif v13 and ({ v13() })[1] == v3[fn2("\169\192C<\132\166", 18670792623084)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("\229\232Z}%\134\210K`", 16058299038315)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("v\191", 18668645073898)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("\138\203G|", 30760420765671)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("y\142\4\231\253", 9953890477110)] then
	n8 = 11
elseif v13 and ({ v13() })[1] == v3[fn2("h\16\196\"\236", 28973659842919)] then
	n8 = 15
end

if v13() == v3[fn2("\236<\200I", 5129421230761)] then
	n8 = 11
end

local function fn11(arg, arg2)
	tbl7 = {}
	tbl6 = {}

	for i = 0, arg do
		local v47 = v12(i)
		tbl6[i] = v47
		tbl6[v47] = i
	end

	for i = 1, #arg2 do
		local v47 = arg2[i]
		tbl7[i - 1] = v47
		tbl7[v47] = i - 1
	end
end

local tbl10 = {}
local v47 = v3[fn2("?", 4071753256656)]
local v48 = v3[fn2("\170", 20685193759552)]
local v49 = v3[fn2("\235", 33316004297011)]
local v50 = v3[fn2(" ", 9831480173508)]
local v51 = v3[fn2(".", 12166939913283)]
local v52 = v3[fn2("\188", 20310446426595)]
local v53 = v3[fn2("\30", 7856808696981)]
local v54 = v3[fn2("J", 30505936187130)]
local v55 = v3[fn2("\22", 31005241372875)]
local v56 = v3[fn2("y", 15134852888335)]
local v57 = v3[fn2("p", 7987809197327)]
local v58 = v3[fn2("\227", 12325858553047)]
local v59 = v3[fn2("M", 14182414824344)]
local v60 = v3[fn2(")", 20544529287869)]
local v61 = v3[fn2("F", 24744061721092)]
local v62 = v3[fn2("\174", 28931782633792)]
tbl10[1] = v47
tbl10[2] = v48
tbl10[3] = v49
tbl10[4] = v50
tbl10[5] = v51
tbl10[6] = v52
tbl10[7] = v53
tbl10[8] = v54
tbl10[9] = v55
tbl10[10] = v56
tbl10[11] = v57
tbl10[12] = v58
tbl10[13] = v59
tbl10[14] = v60
tbl10[15] = v61
tbl10[16] = v62
fn11(255, tbl10)

fn3 = function(arg)
	return arg - arg % 1
end

local function fn12(arg)
	local n9 = 1103515245
	local n10 = 12345
	local n11 = 99999999
	local n12 = arg % 2147483648
	local n13 = 1

	return function(arg2, arg3)
		local v63 = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v63 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v63 % 5781
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local function fn13(arg)
	for i = 1, 2 do
		local n9 = arg % 9915 + 4
		local n10 = nil
		local n11 = nil

		for i2 = 1, 3 do
			n10 = arg % 4155 + 3

			if i2 % 2 == 1 then
				n10 += 522
			end

			n11 = arg % 9996 + 1

			if n11 % 2 ~= 1 then
				n11 *= 3
			end
		end

		local n12 = arg % 9999995 + 1 + 12874
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 12874
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
	end

	return arg
end

local function fn14()
end

local function fn15(arg)
	local tbl11 = {}
	local tbl12 = {}
	local tbl13 = {}

	for i = 1, 13 do
		local tbl14 = {}
		local tbl15 = {}
		tbl11[tbl14] = tbl15
		tbl12[tbl15] = i
		tbl13[tbl14] = tbl15
	end

	if arg then
		tbl11 = arg[1]
		tbl12 = arg[2]
		tbl13 = arg[3]
	end

	local n9 = 0
	local n10 = 0
	local n11 = 0

	for k, v63 in v11, tbl11, nil do
		local v64 = tbl12[v63]

		if tbl13[k] == v63 then
			n9 += 1
		end

		n10 += 1
		n11 = n10 % 2 == 0 and n11 * v64 or n11 + v64 + n10
	end

	if n9 ~= 13 then
		n6 = -1
	end

	tbl8 = { tbl11, tbl12, tbl13 }
	n6 = n11
	return false
end

local function fn16(arg)
	for i = 1, 2 do
		local n9 = arg % 9915 + 4
		local n10 = nil
		local n11 = nil

		for i2 = 1, 3 do
			n10 = arg % 4155 + 3

			if i2 % 2 == 1 then
				n10 += 522
			end

			n11 = arg % 9996 + 1

			if n11 % 2 ~= 1 then
				n11 *= 3
			end
		end

		local n12 = arg % 9999995 + 1 + 12874
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 12874
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
	end

	return arg
end

local function fn17(arg)
	for i = 1, 2 do
		local n9 = arg % 9915 + 4
		local n10 = nil
		local n11 = nil

		for i2 = 1, 3 do
			n10 = arg % 4155 + 3

			if i2 % 2 == 1 then
				n10 += 522
			end

			n11 = arg % 9996 + 1

			if n11 % 2 ~= 1 then
				n11 *= 3
			end
		end

		local n12 = arg % 9999995 + 1 + 12874
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n9 * n10 + 9999) + 12874
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
	end

	return arg
end

local function fn18(arg)
	local n9 = 1103515245
	local n10 = 12345
	local n11 = 99999999
	local n12 = arg % 2147483648
	local n13 = 1

	return function(arg2, arg3)
		local v63 = n11
		local n14 = n9 * n12 + n10
		local n15 = n14 % v63 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v63 % 5781
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local n9 = 68
fn14(67, v3[fn2("\132", 3840891719161)], v3[fn2("\148\243v\159\160\235\254v\22\198&3\183[\220h\254qŎJ\25\208K\154\157\246]", 12721007603271)])
n6 = -1
fn15()

while n6 == -1 do
end

local v63 = fn18(n7 + n6)

if n8 == 9 or n8 == 15 then
	local n10 = 0

	v15(function()
		local function fn19(arg)
			v32(arg[1])
		end

		fn19(v19({}, { [v3[fn2("\216K\237\155\22XS", 643190981207)]] = function()
			local fn20 = nil

			fn20 = function()
				n10 += 1
				return fn20()
			end

			fn20()
		end }))
	end)

	local n11 = 0

	v15(function()
		v46(v19({}, { [v3[fn2("\192\ra\139\231\195\12", 32549329237609)]] = function()
			local fn19 = nil

			fn19 = function()
				n11 += 1
				return fn19()
			end

			fn19()
		end }))
	end)

	if n11 + n10 < 20000 then
		n9 = 19
	elseif n11 - n10 ~= 0 then
		n9 = 189
	end
end

local function fn19(arg, arg2, arg3)
	local v64 = v3
	local tbl11 = { [v3[fn2("\242~\242\192\31\156", 25253030878174)]] = v64[fn2("rs\254", 30562846240559)] }

	if arg2 then
		tbl11 = v19(tbl11, { [v3[fn2("\216\21m\142\201m\185", 4427172646939)]] = function(arg4, arg5)
			if arg5 == v3[fn2("6c\17", 29393505708782)] then
				local v65 = v3
				local v66 = v16(v17(), v65[fn2("\1639\5\144\26ǈu&/\184", 32746903762721)])
				local v67 = v66()
				local v68 = v66()
				local n10 = 1

				v15(function()
					n10 = v18(v68) - v18(v67)
				end)

				if (n8 == 9 or n8 == 15) and (n10 ~= 0 or v67 ~= v68) then
					n9 = 121

					while arg3 do
					end
				end

				return arg
			end

			return v20(tbl11, arg5)
		end })
	else
		tbl11[v3[fn2("\226\245\174", 16547940252723)]] = arg
	end

	local v65 = v46(tbl11)

	if v65[v3[fn2("\133\\*\136\211ɹ\206\215j", 13445805453546)]] == 0 then
		if flag8 then
			warn(v3[fn2("j-F\128\162\139WIʯ\\хE\181p6\159O\23).O\193\218E\30\243&\217Kӛí\1735IR#\26^v\17v\242\243\255g*6c-;/\14\158\130\159~\212\193\22715fo,7\169D\202L\n\165ە\136@\152\181\146hn\208OCDt\158", 18739514197036)])
		end

		local v66 = v3
		writefile(v3[fn2("\207\249D\240\136>\28\137\129dÐ\214\30\184\231\139\226\150\24\179", 17214754274976)], v66[fn2("\216xc\22ѧ\29\211\253\25&\168\165\162\239_rגm*\250\8\190C\229\197ڊ\1792y\193\3|\21\198)$\183\28\14\127\167}\137 H\206\220J\198tݪ\165/\129\29`$'\176\252{v\185j\163M\160\tCEi\4\196z\255]\n\16zx\167\254\\W\168\181", 24541118323015)])
	end

	return v65[v3[fn2("2\224o\143", 15183172745020)]], v65[v3[fn2("\235\144\243\23326\138", 30737871499218)]]
end

fn8()

local function fn20(arg)
	if v35()[8753563] == 22044 and n8 ~= 11 then
		if flag8 then
			warn(v3[fn2("MI\186Vb\245\221\195>\219۔\228\197\2258:\228<d\249\232\25\157|\139\228q\18寋k\17\11\202\232\154l|\190\2325\144\15\240-\210\234\162\6\158\183\227\237j\165\205W\1\145\189Q\241\233\238&\23\156/\205L꜊\255\134)\132!\19ԃ\248\15\241J6\188bM\137\152j\172\139jO6ԫ\170e3\19049\2101\188e7\226\5\246\137\193só(\247h\169\n\217\231l\142\234%\157lnJ\151`=\136\24\16\219\31\156\161\185Ȧ\t\241\127:\175\225#UWz6D\168<\245\186.ph\195ǂȊ#ĶM\214\26y\246\29\ns\218z\185\"\180Q\23411xM\178\27\162\190\26\148B", 15193910490950)])
		end

		v27(function()
			v21(5)
			v35()[8753563] = nil
		end)

		fn9()
	end

	v35()[8753563] = 22044
	local flag11 = false
	local tbl11 = { v22, v19, v32 }

	tbl11[-1] = n8 == 3 and function()
	end or v46

	local v64 = v26
	local v65 = v25
	local v66 = v24
	local v67 = v23
	local v68 = v15
	tbl11[4] = v12
	tbl11[5] = v64
	tbl11[6] = v65
	tbl11[7] = v66
	tbl11[8] = v67
	tbl11[9] = v68

	local function fn21()
		flag11 = true
		return v3[fn2("9", 805330944750)]:rep(16777215)
	end

	local v69 = v19({}, { [v3[fn2("\2\164\245C\127\213\\\162\31N", 24089059219362)]] = function()
		flag11 = true
		return v3[fn2("\n", 12700605886004)]:rep(16777215)
	end })

	for k, v70 in v11, tbl11, nil do
		if k ~= -1 then
			local flag12 = n8 ~= 11

			if flag12 then
				local v71 = v3
				flag12 = v22(v70)[v71[fn2("\183\167\19\142", 33365397928289)]] == v3[fn2("\11h\3", 1198332445788)]
			end

			if flag12 then
				flag11 = true
			end
		end

		if v70 ~= v10 and v70 ~= v32 then
			local v71 = v10
			local v72 = v32
			local v73 = error
			local env = getfenv()
			env[v3[fn2("*\253\137\5\172\129[\220", 22630873322068)]] = fn21
			env[v3[fn2("d0\166\143,", 17147106475617)]] = fn21
			env[v3[fn2("\194\218Gp<", 22071436759115)]] = fn21

			if k == -1 then
				if n8 ~= 5 then
					v15(v70, v3[fn2("", 22141232107660)])
				end
			else
				v15(v70, v69)
			end

			env[v3[fn2("\236\169g\\\154\181>2", 19030507111739)]] = v72
			env[v3[fn2("OH\r\168\171", 146033344648)]] = v71
			env[v3[fn2("n9\171U\136", 23510294713735)]] = v73
		end
	end

	if flag11 and n8 ~= 11 then
		n9 = 85

		if arg then
			fn9(true)
		end
	end

	v35()[8753563] = nil
end

local v64 = n7
local v65 = nil
local flag11 = nil

while true do
	local v66 = v15(function()
		local v66 = fn19
		local v67 = v3
		v65 = v66(tbl5[v3[fn2("vx\194#", 12421424491824)]] .. v67[fn2("[O\242\0037\14\186", 5635169064064)], n8 == 9 or n8 == 15)
		local data = v14:GetService(v3[fn2("\14\162\t\231\29\182*\207)\183p", 24734397749755)]):JSONDecode(v65)

		if not data[v3[fn2(",b@\180%\197", 21709574721274)]] then
			warn(data[v3[fn2("#\144\1440\177J_", 15555772528791)]])
			fn9()
		end

		if not data[v3[fn2("'G\8\177li2\202", 6353524266781)]][tbl5[v3[fn2("\\\1927b`\19\180", 2717723494883)]]] then
			warn(v3[fn2("\170\225Ӥ\6t=\31\209\\\128W\254\215\219\217\208\249\214K,\170JOUZ\243o\144F\180\1443|\169+E\162\5\197\239\173\243y\2088$\250\24/7\4q)", 10233071871290)])
			fn9()
		end

		tbl5[v3[fn2("M<\173\140", 25338932845614)]] = flag4 and LT_R_RRT_H or v7 and v3[fn2("U՜\142s`Q\20;\18\198p\167-\154\139]\156\225\206\u{F45E}\2072:\0", 13360977260699)] or v3[fn2("\194\219Κ\2251\176\229", 20587480271589)] .. v6
		local v68 = tbl5
		local v69 = v3
		v9 = data[v3[fn2("\147\208\226r\29\14\12\29", 29417128749828)]][v68[v69[fn2("\234]\254\157\27yP", 25466712022181)]]]
	end)

	fn8()

	if not v66 then
		if flag11 then
			break
		end
		fn14(69, v3[fn2("\132", 5187405058783)], v3[fn2("z\144\199zz\217\30\184 .t\4\248Hc\184\169BB\254G\191\5\223\237t\220i", 2506189900062)])
		v6 = v3[fn2("\185\153\142\14\4\0Q\15~a\234\8\243\250\128\"\185\152v\229Y\160\205Mĸ~", 25562277960958)]
		tbl5[v3[fn2("ѝ\175\188", 12563162738100)]] = flag4 and LT_R_RRT_H or v3[fn2("\137q\219σ\146\245\230B)\11%\rè~\188\254\151Q\214En1?\194h\197p\202>\191\128\188\166", 19243114481153)]
		flag11 = true
	end

	if not v66 then
		continue
	end

	local function fn21(arg)
		local n10 = 1103515245
		local n11 = 12345
		local n12 = 99999999
		local n13 = arg % 2147483648
		local n14 = 1

		return function(arg2, arg3)
			local v67 = n12
			local n15 = n10 * n13 + n11
			local n16 = n15 % v67 + n14
			n14 += 1
			n13 = n16
			n11 = n15 % 4859 * v67 % 5781
			return arg2 + n16 % arg3 - arg2 + 1
		end
	end

	local flag12 = false

	v27(function()
		if not v15(function()
			local v67 = tbl9
			local new = v67.new
			local str2 = flag4 and LT_R_RRT_W

			if not str2 then
				str2 = v7

				if v7 then
					local v68 = v6
					local v69 = v3
					str2 = v3[fn2("\183b\225(\6", 22124051714172)] .. v68 .. v69[fn2("0Mz'W!\18\31\179uwA\241", 2211975661580)]
				end
			end

			if not str2 then
				local v68 = v6
				local v69 = v3
				str2 = v3[fn2("\146?\180M\218\\", 11448584710566)] .. v68 .. v69[fn2("S\1344\0225\167y%\153\151\160p\17F", 6916182153513)]
			end

			flag6 = new(v67, str2)
		end) then
			local v67 = v3
			fn14(75, v3[fn2("$", 1674014590487)], v67[fn2("\3ER\150\169\174/D\168\171\182\25\\\129i\223kg\5\21\233\248\2127\249՞\184\27\144\31\179\180xO\159\127݀*\28\194TT\189\145\233z\n", 9788529189788)])
			flag6 = false
		end

		flag12 = true
	end)

	local n10 = n7 % 8585 * v64 % 9910
	fn20()

	if flag5 then
		n9 = 146
	end

	fn14(85, v3[fn2("\164", 31753662264196)], v3[fn2("e\249\24\25\161 \251\8\2081\171\141\127Q:\247V\12\157\2432\28\237a\225", 6450163980151)])
	local v67 = fn21(n10 + v63(2, 4096))
	local v68 = v63(1111, 32768)
	local n11 = 12000 + ((1398563873 * ((1398563873 * (1361 + n10 + n6 % 1000 + n6) % 1610612736 + 22491) % 95716599 + 1) + 22491) % 95716599 + 1) % 120000 - 12000 + 1
	local tbl11 = { n11 + v67(100000, 1000000), v68, n11 + v63(3333, 15625) + n7, (v67(10000, 1000000)) }
	n6 = -1
	fn15()
	local flag13 = false

	if n6 == -1 then
		n6 = 100
		flag13 = true
	end

	local n12 = 0
	local n13 = 0
	local n14 = 0
	local n15 = 1
	local tbl12 = { [0] = 0 }

	local function fn22(arg, arg2, arg3)
		local n16 = arg2 and arg or tbl6[arg]

		if not arg3 then
			n16 = (n16 + 4096 - tbl12[n12]) % 256
			n14 += n16
			n12 = (n12 + 1) % n15
		end

		local n17 = n16 % 16
		return tbl7[(n16 - n17) / 16] .. tbl7[n17]
	end

	local function fn23(arg)
		local n16 = 0

		for i = 1, #arg do
			n16 += v25(arg, i)
		end

		return n16
	end

	local function fn24(arg, arg2)
		local v69 = tbl7
		local n16 = (tbl7[v26(arg, 1, 1)] * 16 + v69[v26(arg, 2, 2)] + tbl12[n13]) % 256
		n13 = (n13 + 1) % n15
		if arg2 then
			return n16
		end
		return tbl6[n16]
	end

	local function fn25(arg)
		local tbl13 = {}
		n13 = 0
		local n16 = 1

		while true do
			local v69 = fn24(v26(arg, n16, n16 + 1), true)
			n16 += 2
			local v70 = v3[fn2("", 13613314290054)]

			for i = 1, v69 do
				v70 ..= fn24(v26(arg, n16, n16 + 1))
				n16 += 2
			end

			tbl13[#tbl13 + 1] = v70
			if not (n16 > #arg) then
				continue
			end
			break
		end

		return tbl13
	end

	local function fn26(arg, arg2)
		local v69 = fn22(#arg, true, arg2)

		for i = 1, #arg do
			v69 ..= fn22(v26(arg, i, i), false, arg2)
		end

		return v69
	end

	local function fn27(arg, arg2, arg3)
		if arg == 1 then
			tbl12 = arg2
			n15 = arg3
		elseif arg == 2 then
			n12 = 0
			n14 = 0
		elseif arg == 3 then
			return n14
		end
	end

	local v69 = fn18(v63(2, 32768 + v24() % 2000) + n6 % 4096)
	local v70 = fn12(v67(1, 32768) + n7 + v24() % 1000)
	local v71 = v69(111111, 999999)
	local tbl13 = {}

	for i = 1, v71 % 30 + 1 do
		local fn28

		if i == 2 then
			fn28 = v32
		elseif i == 8 then
			fn28 = v10
		elseif i == 17 then
			fn28 = v26
		else
			fn28 = function()
			end
		end

		tbl13[i] = fn28
	end

	local n16 = v70(111111, 999999) + 9717
	local n17 = v69(1, 1234) * v70(2, 1235) + n6 % 80000
	local n18 = 10000 + ((1445613873 * ((1445613873 * (n11 + n6) % 1627389952 + 23515) % 94716599 + 1) + 23515) % 94716599 + 1) % 100000 - 10000 + 1
	local tbl14 = { n18 + v69(100000, 1000000), n18 + v70(100000, 1000000), (v69(100000, 1000000)) }

	if v4 or v5 then
		n9 = 218
	end

	if flag13 then
		n9 = 250
	end

	local v72 = tbl14[1]
	local n19 = 12811 + tbl11[4]
	local str2 = (((fn26(v3[fn2("", 26309625077686)] .. n16) .. fn26(v3[fn2("", 16740145904870)] .. fn16(12064 + v71) .. fn13(n9 + n17) .. fn10(n16 - 9717))) .. fn26(n17 .. v3[fn2("", 17472460177296)]) .. fn26(v3[fn2("", 27987934766545)] .. v71)) .. fn26(tbl11[3] + 18822 .. v3[fn2("", 13603650318717)])) .. fn26(v3[fn2("", 32880051812253)] .. v72) .. fn26(v3[fn2("", 16629547121791)] .. n19)
	local n20 = tbl11[2] + 9717
	local str3 = str2 .. fn26(tbl14[3] .. v3[fn2("", 13202058620935)]) .. fn26(v3[fn2("", 15144516859672)] .. n20)
	local n21 = 12064 + tbl11[1]
	local str4 = (str3 .. fn26(tbl14[2] .. v3[fn2("", 18783538955349)]) .. fn26(v3[fn2("", 8523622719234)] .. n21)) .. fn26(str or v3[fn2("\15", 2953953905343)])
	local str5 = fn26(fn17(fn27(3) + 2154) .. v3[fn2("", 3140790684525)], true) .. str4
	local tbl15 = {}
	local v73 = v70(111111, 999999)
	local v74 = n6
	getfenv()[tbl15] = v73
	local v75, v76 = fn19(tbl5[v3[fn2("\209\30p\238", 17011810876899)]] .. v3[fn2("V", 25199342148524)] .. v9 .. v3[fn2("\221\209\n=o\17", 1184373376079)] .. tbl5[v3[fn2("p<\196O\205\0158s", 21268253363551)]] .. v3[fn2("c>\6\3F\162+y", 3976187317879)] .. str5 .. v3[fn2("\167Q\174", 1858703820483)] .. tbl5[v3[fn2("\15s )\130R\2366K\160\146G\162", 33488882006484)]] .. v3[fn2("\142\229\173", 8988567118003)] .. v45, n8 == 9 or n8 == 15)
	n6 = -1
	fn15(tbl8)

	while n6 == -1 do
	end

	while tbl11[2] ~= v68 do
	end

	local n22 = 0

	for k, v77 in v33(tbl13) do
		if k == 2 and v77 ~= v32 then
			n9 = 147
		end

		if k == 8 and v77 ~= v10 then
			n9 = 147
		end

		if k == 17 and v77 ~= v26 then
			n9 = 147
		end

		n22 = k
	end

	if n22 ~= v71 % 30 + 1 then
		n9 = 147
	end

	local flag14 = false

	if n9 == 147 then
		flag14 = true
	end

	if n6 ~= v74 then
		n9 = 100
		flag14 = true
	end

	if v75 == v3[fn2("\196\205X", 28147927180902)] then
		while true do
		end
	else
		local fn28, n23, v77, n24, n25, v78, tbl16, n26, n27, n28

		do
			if v34(v75, v3[fn2("\166\222ʞ\1593\166ye\241v\251\148W\162\200<\128\148(ݯ\180\233/p\147\233F襣\136\185\170\1\172\250\235\173k", 1377652802819)]) then
				if v8 then
					v8(v3[fn2("Ҕ~E\164", 19446057879230)])
					return
				end
			end

			if v26(v75, 1, 1) == v3[fn2("\138", 5914350458244)] then
				local v79 = v3[fn2("l\24\178\25+\175\tY\29B갖X\23", 28383083816769)]
				local v80

				if string[v3[fn2("\220eg'", 2761748253196)]](v75, v3[fn2("\23GB\147\212y\236\24\167&\219\243@y;\217", 9639274521361)]) then
					v79 = v3[fn2("LY\1333\11w\134\174FP\194 \4\177,y7\5y", 15260484515716)]
					v80 = v26(v75, 2, #v75 - 17)
				else
					v80 = v26(v75, 2, #v75)
				end

				fn14(100, v3[fn2("\244\159\237\201L\217X\239\180\245$\181G?", 30952626417818)], v3[fn2("N=1MT {!\211Z\191R\207'\140\200\253|3\169\178\183\150U\25c", 27278169760572)], Color3[v3[fn2("\189o`", 30263263129112)]](1, 0, 0), v3[fn2("4\226\14\232\14", 13170919157738)])
				fn4(v79, v80)
				fn9()
			end

			if v76 then
				if not v76[v3[fn2("\2\209\252\2074\186vTX\135", 27265284465456)]] then
					local v79 = v76[v3[fn2("\212/tO\130\27\16ĩ\177", 17419845222239)]]
				end
			end

			local n29 = tbl11[4] % 256
			local tbl17 = { [0] = tbl11[1] % 256, tbl11[2] % 256, tbl11[3] % 256, n29 }
			fn8()

			fn28 = function(arg)
				local n30 = 1103515245
				local n31 = 12345
				local n32 = 99999999
				local n33 = arg % 2147483648
				local n34 = 1

				return function(arg2, arg3)
					local v79 = n32
					local n35 = n30 * n33 + n31
					local n36 = n35 % v79 + n34
					n34 += 1
					n33 = n36
					n31 = n35 % 4859 * v79 % 5781
					return arg2 + n36 % arg3 - arg2 + 1
				end
			end

			if getfenv()[tbl15] ~= v73 then
				n9 = 100
				flag14 = true
			end

			n23 = 1

			for i = 1, 30 do
				local v79 = v32({})
				local n30

				if v32({}) < v79 then
					n30 = n23 + 1
				else
					n30 = n23 * 2
				end

				n23 = n30 % 10000
			end

			fn27(1, tbl17, 4)
			v77 = fn25(v75)
			n24 = v77[1] - n16
			n25 = v77[4] - v71

			while n29 ~= tbl17[3] do
			end

			fn20()
			v78 = tbl17[3]

			tbl16 = {
				[0] = tbl17[0],
				[2] = tbl17[1],
				[4] = tbl17[2],
				[6] = v78,
				v77[9],
				[3] = v77[7],
				[5] = v77[2],
				[7] = v77[6],
			}

			fn27(1, tbl16, 8)
			n26 = v77[8] - tbl14[1]
			n27 = v77[3] - tbl14[2]
			n28 = v77[5] - tbl14[3]
			local str6 = v3[fn2("", 28654748788798)] .. fn17(tbl14[3] + 2511) .. fn16(tbl14[1] + 31) .. fn13(tbl14[2] + 7037)

			if v77[11] == str6 and ({ [str6] = true })[v77[11]] then
				flag2 = true
			else
				local str7 = v3[fn2("", 6334196324107)] .. fn10(tbl14[3] + 2511) .. fn13(tbl14[1] + 69) .. fn16(tbl14[2] + 7037)

				if v77[11] == str7 and ({ [str7] = true })[v77[11]] then
					flag2 = true
				end
			end
		end

		local n29, v79, str6

		do
			if flag2 then
				local flag15 = v18(v77[14] and v77[14] or v3[fn2("\230v", 11362682743126)]) == -1
				v18(v77[15] and v77[15] or v3[fn2("\8", 1527981245839)])
			end

			n6 = -1
			fn15()

			if n6 == -1 then
				n9 = 250
				n6 = 100
			end

			n29 = n7 + v69(111111, 999999) + v70(1234, 5678) + n6 % 99915 + n23
			tbl14[4] = n7 + n6 % 9951
			v69(100000, 1000000 + n6 % 1000)
			tbl14[5] = n6 % 8005 + n23 + v70(100000, 1000000 + n6 % 5000)
			tbl14[6] = v69(100000, 1000000)
			fn27(2)
			v79 = v77[10]
			local v80 = tbl14[6]
			local str7 = fn26(v3[fn2("", 11551667071494)] .. fn13(v77[13] + 15509) .. fn17(n29 + n9) .. fn16(v77[10] + v71)) .. fn26(tbl14[5] .. v3[fn2("", 33512505047530)]) .. fn26(v3[fn2("", 24280191096916)] .. n29) .. fn26(v3[fn2("", 281328943366)] .. v80) .. fn26(tbl14[4] .. v3[fn2("", 30946183770260)])
			str6 = fn26(fn13(fn27(3) + 2154) .. v3[fn2("", 1284234413228)], true) .. str7
		end

		local v80 = v77[12]
		local response = v14:HttpGet(tbl5[v3[fn2("\204=\165,", 285624041738)]] .. v3[fn2("\215", 34962100748080)] .. v9 .. v3[fn2("\180T}\144E`\233N0\18\159\197", 5342028600175)] .. v80 .. v3[fn2("l4\190", 13551035363660)] .. str6)

		while v78 ~= tbl16[6] do
		end

		if response == v3[fn2("-\n+", 31841711780822)] then
			while true do
			end
		else
			if v26(response, 1, 1) == v3[fn2("\231", 5502021014532)] then
				v14:GetService(v3[fn2("<\165\18]\1795\142", 2067016091525)])[v3[fn2("\135\2218q\250\240\249wOź", 21595754614416)]]:Kick(response)
				fn9()
			end

			do
				local v81 = fn25(response)
				local n30 = 1
				local v82 = fn28(1 + v69(100, 1000 + n23) + v70(500, 5000 + n23) + n7 % 10000)
				local flag15 = false
				local n31 = 0
				local flag16 = false
				local flag17 = false
				local v83 = nil

				for i = 1, 3 do
					local v84 = v81[3]
					local str7 = fn13(tbl14[5] + 9717) .. fn13(tbl14[4] + fn23(flag16 and v3[fn2("\177", 34008588909496)] or v14[v3[fn2("\5fw\137\244", 33146347911317)]])) .. fn13(tbl14[6] + tbl14[2])

					if v84 == str7 and ({ [str7] = true })[v84] then
						do
							flag3 = true

							do
								local v85 = v81[8]
								local flag18

								if v85 then
									flag18 = v81[8] ~= v3[fn2("C", 5343102374768)] and v81[8]
								else
									flag18 = v85
								end

								if not flag18 then
									local v86 = v3[fn2("x\138\221<\173~N", 31676350493500)]
								end
							end
						end

						if not (v81[9] and v81[9]) then
							local v85 = v3[fn2("\190;h\148\252\0\245", 23283728274612)]
						end

						v83 = v81[6]

						do
							local n32 = v81[1] - tbl14[4]
							local n33 = v81[7] - tbl14[5]
							local n34 = v81[5] - tbl14[6]
							local v85 = n26
							local v86 = n27
							local v87 = n28

							n26 = function(arg)
								if not (flag15 or n31 < v29() - 8) then
									n30 = (n30 + arg % 66) % 6644
									return v85 * arg % n32 + arg * 3
								end

								while true do
								end
							end

							n27 = function(arg)
								local v88 = flag15
								local flag18

								if flag15 then
									flag18 = v88
								else
									flag18 = n31 < v29() - 8
								end

								if not flag18 then
									n30 = (n30 + arg % 50) % 5891
									return v86 * arg % 10000 + arg * n33 % 4
								end

								while true do
								end
							end

							n28 = function(arg)
								if not (flag15 or n31 < v29() - 8) then
									n30 = (n30 + arg % 35) % 6711
									return (arg + n34) % 100 * arg % (v87 % 100 + 1)
								end

								while true do
								end
							end
						end

						flag17 = true
						break
					elseif i == 3 then
						flag17 = false
						v83 = nil
					else
						flag16 = true
						flag17 = false
						v83 = nil
					end
				end

				if not flag17 then
					while true do
					end
				elseif flag14 then
					while true do
					end
				else
					do
						while not flag12 do
							v28:Wait()
						end

						flag7 = true

						do
							local flag18 = false
							local flag19 = false
							local n32 = 0
							local n33 = 0
							local n34 = 0
							local flag20 = false
							local n35 = 0
							local n36 = 0
							local v84 = v77[12]

							v27(function()
								flag19 = true

								while not flag9 do
									local n37 = v82(1000, n30 + 10000) + n30
									local n38 = v82(1000, n30 + 10000) + n30
									n35 = n37
									n36 = n38
									fn27(2)
									local v85 = fn26
									local str7 = fn26(n36 .. v3[fn2("", 15363566876644)]) .. v85(fn17(n36 + v79) .. v3[fn2("", 6862493423863)] .. fn16(n35 + n16)) .. fn26(n35 .. v3[fn2("", 13612240515461)])
									local v86 = v3[fn2("", 26792823644536)]
									local v87 = v9
									local v88 = v3
									local str8 = tbl5[v3[fn2("\251k\3\137", 8239072452089)]] .. v3[fn2("\243", 6554320115672)] .. v87 .. v3[fn2("\1716y\6\132\215\1\133#\18\21'\12\146H\155\195\17", 8461343792840)] .. str7 .. v88[fn2("\224\212\238", 27556277380159)] .. v84

									v15(function()
										if flag8 then
											local v89 = v3
											v30(v3[fn2("@", 8025391308082)] .. v29() .. v3[fn2("\198\5\158\149\150H\31\14\31\12\163}g\158\31H\4\5\208[", 21377778372037)] .. v32(flag6) .. v89[fn2("\229\215", 957806936956)])
										end

										if flag6 == false then
											v86 = fn19(str8)
										else
											v86 = flag6:request({ [v3[fn2("E\143\147", 17306025115381)]] = str8 })
										end

										if flag8 then
											local v89 = v3
											v30(v3[fn2("\136", 8205785439706)] .. v29() .. v89[fn2("\20N\188+\204\18\227\131`OM\249P=\163n\206\2432", 6507074033580)])
										end

										if v86 and #v86 > 3 then
											if v86 == v3[fn2(",.[\"@+o>\223", 19626452010854)] then
												flag15 = true
												flag2 = false
												flag3 = false
												n25 = 1
												n24 = 2
												local v89 = v3
												v14:GetService(v3[fn2("K\26\21\0193\18\164", 34803182108316)])[v89[fn2("\210\201\222Q\159{D\181\180\253d", 29684498623485)]]:Kick(v3[fn2("\3\174d\163\173\15\196\248\n\148\211g\189\226M\252,\146?T\145^m\161\29J\31mM\158n\1\176D\232\133\t\2291r*\138W\145\0190\29\152I\176\177\147X^3\153O۴", 33049708197947)])
												fn9()
											end

											if v86 == v3[fn2("Ɖ\162J", 30249304059403)] then
												flag15 = true
												flag2 = false
												flag3 = false
												n25 = 1
												n24 = 2
												local v89 = v3
												writefile(v3[fn2("\231\151|(\168\248]\170\254\215\233V\231k\136M\172\129\168", 14824532030958)], v89[fn2("s25z\154\234a\131\145", 15250820544379)])

												while true do
												end
											else
												v86 = fn25(v86)[1]

												if v86 == fn13(n35 * n36 % 100000 + n29 + 12064) .. v3[fn2("", 28489387501476)] then
													n33 += 1
													flag20 = true
													flag18 = true
												elseif v86 == fn10(n35 * n36 % 100000 + n29 + 12064 + 4919) .. v3[fn2("", 15233640150891)] then
													flag20 = true
													flag18 = true
													flag9 = true

													v15(function()
														flag6:close()
													end)
												else
													flag15 = true
													flag2 = false
													flag3 = false
													n25 = 1
													n24 = 2
													local v89 = v3
													v14:GetService(v3[fn2("\197>x\169\18fL", 29485850323780)])[v89[fn2("\172\15\203V*\147lM\179R\26", 24838553885276)]]:Kick(v3[fn2("\174\191bRRQ*\193ع'\25\154\n\158j\6\129\242\184\187\21\21D\245\225tL\179\160(", 22159486275741)] .. n33)
												end
											end
										end
									end)

									v21(20)
								end
							end)

							while not flag19 do
								v28:Wait()
							end

							flag19 = false

							v27(function()
								flag19 = true
								local n37 = 200

								while true do
									n37 += 1

									if not flag9 and n37 >= 250 then
										if flag20 then
											n32 += 1

											if n32 > 4 then
												n32 = 0

												if n34 < 10 then
													n34 += 1
												end
											end
										else
											n34 -= 1

											if n34 <= 0 then
												flag15 = true
												flag2 = false
												flag3 = false
												n25 = 1
												n24 = 2
												local v85 = n33
												writefile(v3[fn2("\rq\227Ŗ\196C\12d5\169P\130\23\225R%\162/\160\157", 15647043369196)], v3[fn2("\226\254\178K\216\255Z+Z", 8167129554358)] .. v85 .. v3[fn2("\250\193X\28", 24571184011619)] .. v32(flag6))
											end
										end

										flag20 = false
										n37 = 0
									end

									n31 = v29()
									v21(0.18)
									if n31 ~= v29() then
										continue
									end
									flag15 = true
									flag2 = false
									flag3 = false
									n25 = 1
									n24 = 2
									local v85 = n33
									writefile(v3[fn2("\221aK\192\216\12q\174n\167\"\232\6\199\17:\166y\t=)", 26022927261355)], v3[fn2("\206\224\168?\226v\231\19\29", 709765005973)] .. v85 .. v3[fn2("\169d\175m", 10312531191172)] .. v32(flag6))
								end
							end)

							fn14(95, v3[fn2("\132", 22787644412646)], v3[fn2("\"\140\144$Il~ٳz\219Z\206:\t", 447764005281)])

							while not flag19 or not flag18 do
								v21()
							end
						end
					end

					fn14(100, v3[fn2("^\156\160\174\193/5\1494\0U\206\225\165}", 10029054698620)], v3[fn2("[Q7ð=\11x\218~\1302}\200\234/m\228.\159", 31806277219253)] .. v29() - now .. v3[fn2("\252", 21953321553885)], Color3[v3[fn2("wܽ", 20447889574499)]](0, 1, 0), v3[fn2("\211\225ף", 11135042529410)])

					do
						local v84 = nil

						local tbl17 = {
							[9] = 220,
							77,
							[18] = 223,
							[14] = 205,
							[6] = 238,
							[3] = 44,
							[19] = 229,
							[17] = 239,
							[13] = 8,
							[10] = 76,
							[12] = 83,
							[8] = 236,
							[5] = 4,
							192,
							[16] = 85,
							[7] = 44,
							[15] = 155,
							[4] = 134,
							[11] = 84,
						}

						luraph_runtime1(v83, buffer.fromstring("3\150\171\194^\141\127_\152\255\217\12\129\194Y_\190w\242. \154\169\"\22n\231)ĈJ\226\201v\227D\28\169s\231\5\2/\0050\242\254\134K\190\144\158\6lGy\233dG\238\192\251\226Z/L\182\183\252\219\208b\153R^\132\153\162\247ƪ\230\0071a\175\26\215/\214&\186F\241P\227#o\20\02615\151\186{\222\227\227\200\230\203,d\196\5,\136\205Ƒ\143\140\234\131g=\216D\207\245\206\199\253\30\166\154vq\225r\179\228n\28ȞTy\8j\2326\237k\214t\1449J\190\219@^\16\160\"D\15\226>VF\245\200\24\145\223\211\253d\23Z\11\199\17\t\164\\&\215\247_\14t\169*#D\251\211\215\236\207ڰL\141+\129'E\156lT\183\18M\11\189\129O\187\206\194\210\214\12\210\7\249J4cM\165\12 \253\207\219\24̹\140\143\164\11\n\246\189\251Z\134\215o@\t\139,\192\153m\149\1326\154\16K(C\169U7uz\200 \223\4\0172(\11*B\182^\26\241]\206L̑Y\194,\183:\\\253\5\26}\155\240\250\143te\202|\251\24\15\166\26l\1f\178eut\137\154f\229(\2099\160\250\150\167\171\145\216\"\158h\5#\1H@\188\232j\23\155\251?\241D\165\210\205]\164\199\21\192K\244ѝ\20\160\190\11)\174\127^c\191\254\255\180r%\\\245\rD\245\212r\189\225\210a\r\174y\238=9|\25\223P\n\2045\226\207$\149\191\174\28\172\255E\23\247!\30\12\239o\149\173}\149\255\183Ձs\184l;\198?\174ݶ\16\138\25.\237[{\209\209\210\199\222\4\225\137\192\16\166\173\164\165\250\241w\142\171\128\234\23\230\30ҩ^S\162\225k\247\26\30\249s\187\172]I\169\255\8p,\241\170\144\227D\19R\180\205\16\2\157f\224\204G\195\216k\177\203_\175\179\135;O\155\141\238}3\197]b\246&\191\31\147\19\138\179V\162\197\29d\249\233Uw\196\207\2107=\156\205g\230<#C\175T\247 )\167\142\222\241@\147\184\131\244<\253\16A^\180ul+\19\223\216\255\163\164\18\r\165\135(\159\248\211\20>t\255%\233\158\18\183\194\8\255\25\161e\22\5\175g\167\149?i~S\192\229\181]&\239\29*k1\178\140\165D\232dW\6GM\142ּ\228\175q\28V\5\144\7^\196\30R}\180u\181S=+-\250JkF\t\20\250amR\216w\146W\128Y3N\242\16\209$^\16Q\25/\138h\173\12\r\250&\225\249wX\169\176\220,\217\203A\228#\246HeF\164\202=g\187\242'\"^\183I~\201\29\188\158\142\182\248\r4\1908\158c;\12\201\218Y\144>hֳ6-\1511'F\1\7睌\131t\199Y,\188\210\2398\217V,\151\6\31\131Q۠܆\25\132\187\176\235\173\244\232\rQ\2379;9t\209,BN&\148\239j\173O\221C[\15\191\183\1292\4\138\162\26\255\237\127\17y\158\6J\208/\248\173\28\178\242\183gcl~\131a\246\182\163\155PQt\254\204S\27ɑX\174\137ɬ\0312m\247\168\181d\241\200%\174}\238\29r\26m\178\210\204\236\247\233\198\31\221\217\232GO\224z\132˷z\231r\228T\232\197`\168>b+z\197\249i\156 \164\193b\180\\.\201\19|S\197qIG\144\231\15\143\156\157`qW\11\191\17\30$\192\146\128\130m|\16m\21\186\1463A\17\252\196\20%\139\16\232\155\246ƞ茡5\168\127\149\130\159\187\249\207\232\5\217\246\168~\196\30\177\181\160\216G\202\200%\148\1729?m#\254\1570\168V\194L\253#\241\131\236\225\18;\\\220.\n\244\140\173kSd;\5#J\196\228\\\26\232c{\30\147T\130\139,\144\243\18˷\3\228f\2037C\170\203\1M\152]\234\249\139T\236V?\143}j\28\223\194\"\17PۥT'\129\2<\217몪9GU\27]\8\197Ñ\187\30\252`\236\219͐t\127T\24Yїd\147\6sS\174\253c\142x\2356t\246\148?\158p\u{E11C}y\30\17\220\27\141\192w\145&\233(\187+t5\15\228z\152L\27\0179:\180\190\155\251aJ\7*+\180\131\200\195i\197}\4z\137\172P\189\139\163A\253\255\176\6\144\221Q\254p\250&D^Zy\186P\133\8\1892\29k=\28\145\30hrXPJ\199\211+\192\167x\199\229\238K_d\27\245\242)\178\0ɐ\175\242\3\194\239'\r\252\178a]`\2359m\135\2050\127\142\136λ\12\r2 \141\0\210D\185\138D\0175+\235T\219\246\157\204\212ע?\252\237\r6\172\135\215\225\2202}'2p!D\189lg\139\212ե\216\"\190\240\231mʫ\254TԽ=\170\188\168ډ\134\224\222,k\157\131\160p\23\196kȖu\151-\234\254\159\136\1888\221e\217\28\r,0\236\181Ǵ\164\231QEa\231\239\199w\23\251\183\177\20\17\26R\243\234j\28Ù\199e\147w^3\152!\190\208\237LL\235D\139\201\246Pl\214=\8\178g\231\\\231.\140\132'\\\176\131\3\228R\246\2\1b\146\188=?\239M\191\1\223o \3\142\147\5}\162\227\190ub\166K\160ỉq\228\11\211#m\130R\219t\130\156\143\243\165\27Ä\162\160\184\141ÉD瑜s\173'\222\212\2\154\14r\224\t[\31\174_\156\2497\192\r\216ɓ\15}^\206\238an8\205\213yL\6NJC\245\5\243\192I\242*{\197]\5Tk\221\242o\155H\226\218R\131\240t\2131\26x<\151\"g\137\29\148%GŦ\181\251\145\189\239__\1925@\142%\"\136\158B\214Q4\214\2281-\221\202\230CBܝ\132$\175{\\|q\1\155\185\2341\173\2259l8\150+S9\4|\131\170s\183\250zcӍ\156\133\161\231\149\16\nt80\197\230\193}&\240\255\0\166\157e\182\4ĭ\165\199z_\255\179\146K\188:\\\149\194\209ts\165v@\155\26\156\4\30\186\192OK!\223`\229;2*\6\131j\153\215\200\15\181F\01203\140\216\234\189q\26\8\238\232J\195\28s\237\244;\219\"\197/\250e\136ؔ)\24\179@E\228\162.\12\0\182\14\8\2135\r\206̀\228\143\217`sɆ<#\224\rL\233\146\r҃\31GvY\129N\203\209=)߽$@K\156L\150\231\197\22\240\136\22\154n\196P\185\4q%\181I\138_\164\182\254\255O\2300UP\178\246!\238&|\29$\186倣\197fb\6\230\2557αKp\251\137\182\215\30\166\251v]O\30\152/w\r\1559h\148\140\24\150\17+\189\192\127\243\197z\22\203\252\26}t\237\177r\226?|&\21288M\164\205`R\241D\141\167\224\188\r8Tr|JW\182\1+e\164\25580\1In\169\142SH\198\30v\220u\27\154)3\176A\221u4\23ww\219Ӷ>\198\237\nt\24\170\195y\165\128\147\196\193\28\168~\130n\28\254S\150\211\12\242\129<\253@\189\1\247\230H\27\245\189\255N\127<g\31\167\128XďnB/\163\208\222-\193\215Ń*\169\3``\"F\234\172\24\195WJPj\145\2028\187nȋ\17\165\t\135V\228\164u\218\127͊\239:\132\22\12C\156\237\6<pY\229Vײ}\28\129I\206\234\14\177\180\167\248)(\149\139+m\14_\19ȷ\17ʻi\128\23\190\154\171Ё!-I\224\27\136\174\229\248|%KGa\232\2a֕j\157X\150o\12\146r\1\252\0\12q\4\174\145\145\175B$\2069\239\232\176-\248\128\12\29_\28n\\~\217\234\129S\137\220r|)\164\170\165g\254\186}\239F\230 +Uq2}t\0_ᥓ\11\"5į\188\25z\4-\26\31\131\129\1362\255+:0w\229m\236e\177n\231\20\152§o\2384e%\202;\0P>\159\162\255ǐ\158\143\251\201XK\139\14\168\204J_\254d\225]]\160\215\n(\229\136i\253\154\169\0262\220c\12\0\192\222k\t:\20\2\2417vڡ&\2152\137b\24\143FS_8t\188(\155\231\2360I0\255,\221,9/z\179\147ќ\31\187\n\160\157\179\251\240\145D]=\24\234b\177\24\206[\253\169l\252\226ȦC\187\"\167\160\162\222\214)\1873!\227``24\231o\31\127\203ٺ\1531b\0126bS\234\29']0h\139\129ɹ4k\131\145\219\246\239\230\176]\246\157\135\30*\175w\183\162\233\245\217X\187\nH0\186\157g=\173+&7u\151\144f\180X\142 K\172\187.\233W\134;L\20125\158=\236}-\11\219\21844V0\140\227\248D\134\166pR\r'\201e\254\232\187\0189\225.+\193u\7\227\185\195\u{7B5}Ζ\240Ӱ\242C\150\255l\198\22\7\19o\154\225侱5>p\198\255\255\4>\175/)~pd4$\158\217\249n\251\180?\227̠^\194\224\4jy\203CC\170\164\237\\\1\242\155i\0ͯ\234n\162b\164\172\4\199U\19\135\140\31\132\167\231v4\25\t=H\248\220;\248\218\8_\200\200H\205\1993g\24C\138vys9\0S\232\228ܿ3\"7`\254\228\r1\24S\207\212\253\238\243\\\175𧔲\202\217Frڬ\223\194\207&\214ճ\187\195%\19\157\205\226u\169\245\131\199\195^\180}9vQF\137\11\184u2\21\207\29\184\148I!k\228^0+\234߃c\165F\3\130!\208\192\148\\ժ\26\237\165C\136\27\174\22+\249\25\230\18>\134c\161\158\248\26\209/J \250\206\1;\172 \161\6\208\2%\243I4\168\148۰[\136\185\216x-\180IZ\248\179)\240L\248\235\250ny\132+\212N\25\1341\31\204o\127 \170\216\240G)\201\209\tt{Z\142Z\31\2521~\192x\1585z\203\225\"F\163\213\245y\222߉u'\207\223r\150\236\133A\16\219\235\245\30\180h\218\248\220\16d~\247`e\192\185\180vX\242\136\234s\131i\210\"X\203xs#g{\250\176\218\20ȶ\24\140\243\212Co=zܩ\17n^9\231RQ\2148\u{5C9}\137\254XU<\4\255\t\148\174\174\2\202\27\238\235\129\18\175\151\163\169[`\151w[Ph0\130\220q\174k\232s/AΑ~o\220\nUo\141\2\1631\139\227+J\226\196\1\214Ȝ[\218\249\1\254(\227\152?\155\8\153_\143\163\192\1394\176\138\253|f\230x\158\244\212\229\"\214\14Vq\27\166p\205\\\212\30[\1284\169\253Migv\135\26\166\147\223\\\250':joR\179\180\196\232,\0125٩Ot\242\135\147\1L\176O`<\145 \161ʧ\26g\157i\245P\141xO5c]\131\25\11\239iܵ˜\249\254\6\28\6M\164=y:\133,g\138\209\11\174\170\24\5\208\2\211\231\215sTc\184OO=C\169\nx\1720b\222P\4t\n֫\170\198't~\193\r\224\149+\166ʚ\176\18\180P\194\197\194.\131\203&1\214q\210\199/)\190\157Tm\138\193\18Z\139.*Z\204R0\162~'\194(C\172#\15\131\233q\141\231\194G\205Ѻ\251.r\30\176\132~\163\168\185^\179r\134ɰ^a\173\137\131\228\128l\237h\194\210p$\250\247\6\157_?7\168\191\249u\168\251.\0281Χ\199\207\12'\187\158\151J%\31\216r\215\195jy)E\162g\150\167i2\146}E\239\182\12G\1413\184\3\192\161\3\133\2ͫ\252.\12\169\0\143@\233\199l\170\184'b\216\234.O\174\177\250\1(\11\127\183\158\185@;,\234.\179\178\193P`\167}\174\224V\28n\147\151&O\136\180To\137\202l22\224 8H\180\191G\167\1566\232\235\183\242\208syR\192\166\154\222(\3.=\132{\131\1463\250\132\255\254\166a<t$\240\240c\160@\157\22\200y\255\133\206F\2\201\214BI\131\229d\235촉\202hqj\227\247\199\n(\236\169fXN\27\15994\205Y\206\11\1924\27\n@\198!I\251\164q\22213\17\228Ca\253c\1951А)$\136\12702;3\12\215)\188\149\146\31ulj\172\t\237Z\218\247\196\17L\178=\172\232\160\241'\1956\140*y\28:\23>\139\247\248\157\241\156C5)\189e\240\r9\16\238\213\246~4E\245\176\171\2048\192\168\183:\129ɸU\243\248Su\207in\226\r6Ƅ\161\214,\165Z\247Ȟ]\15\n\219\28\186\160b\135\12ө߲\1_\224I\15FӋ\225\188\"\24իv\248C\237\171\170\229\236R\175\128̫r\173\155H$U\242\31U\"ͭ\146g\225φ\255µ\132\164\249\139J{\195=\177lr\151\"\151\26\239D}SJ\200!?F\159\226\155\209\0013\18\21199\194-\189k\244`\156\161h\254\193jH\188*\195\19d\241\162\246\28\139\208\207=\240T\229]\151+\170]ҝ\184\162\29\148\195\206\232G\198\30?\190\199K^\232\1\156\221h\179\194\231\244͞5\184\200\247\202K_)x魡\233\191g\172\31\131\178\210cx\255\0\1]\192 \222<\182\175\160j'\n\19w\29~\186o\224[rw\161x\2\249\255?\132Z\229Yv\170\175\127\206Cp\153S\254]k\231\27蓕\25>\29\29\209,\182k\154#\173\158-\19\25j;\31\226LɌ8\135gm\208\7\18\160kTEr\241\22\160"), tbl17, 521)()

						if n28(v84[187]) >= 778 then
							local v85, v86, localPlayer, v87, net, v88, v89, v90, keyboardEnabled, flag18
							local fn29, v91, tbl18, max, flag19, v92, flag20, autoRedeem, autoType, manual
							local flag21, thread, n32, n33, listenKey, g, str7, tbl19, v93, v94
							local flag22, autoListen, v95, v96, fn30, fn31, fn32, fn33, fn34, fn35
							local fn36, fn37, fn38, fn39, fn40, fn41, tbl20, tbl21, gothamMedium, gothamBold
							local gothamBlack, fn42, fn43, fn44, fn45, fn46, fn47, fn48, fn49, ScreenGui
							local Main, Frame, Rag, v97, v98, n34, v99, fn50, TextBox, v100
							local clear, redeem, fn51, listen, Frame2, Frame3, TextButton, v101, v102, v103
							local v104, v105, v106, start, v107, v108

							do
								local Settings, showKeybinds, visible, fn52, words, Frame4, Frame5

								do
									local tbl22, Frame6

									do
										do
											local v109

											do
												do
													local getupvalues_, getconnections_, setupvalue_

													do
														do
															local writeClipboard

															do
																do
																	local fn53 = cloneref or function(arg)
																		return arg
																	end

																	local v110 = fn53(game:GetService("Players"))
																	v85 = fn53(game:GetService("ReplicatedStorage"))
																	v86 = fn53(game:GetService(v84[86]))
																	v109 = fn53(game:GetService("TweenService"))
																	localPlayer = v110.LocalPlayer
																	v87 = localPlayer:WaitForChild(v84[135])
																	net = v85:WaitForChild("Packages"):WaitForChild("Net")
																	v88 = fn53(game:GetService("RunService"))
																end

																do
																	v89 = localPlayer
																	v90 = v87
																	getupvalues_ = debug and debug.getupvalues or getupvalues

																	do
																		local v110 = getconnections

																		if v110 then
																			getconnections_ = v110
																		else
																			getconnections_ = debug and debug.getconnections
																		end
																	end
																end

																setupvalue_ = debug and debug.setupvalue or setupvalue

																do
																	local v110 = setclipboard or toclipboard

																	if v110 then
																		writeClipboard = v110
																	else
																		writeClipboard = syn and syn.write_clipboard
																	end
																end
															end

															do
																keyboardEnabled = v86.KeyboardEnabled
																flag18 = v86.TouchEnabled and not keyboardEnabled

																fn29 = function()
																	if not flag18 then
																		return v84[110]
																	end
																	local currentCamera = workspace.CurrentCamera
																	currentCamera = currentCamera and currentCamera.ViewportSize.Y or 600
																	local uiSize = _G.__RdmCfgStr and _G.__RdmCfgStr("uiSize", "MEDIUM") or v84[172]
																	local n35 = uiSize == v84[85] and 1.15 or uiSize == "SMALL" and 0.8 or 1
																	return math.clamp(currentCamera * 0.88 / 548, v84[82], 1.3) * n35
																end

																v91 = fn29()

																do
																	local tbl23 = {}

																	if readfile and isfile then
																		local ok, result = pcall(function()
																			if isfile("redeemer_settings.txt") then
																				return readfile("redeemer_settings.txt")
																			end
																		end)

																		if ok and type(result) == "string" then
																			for match in result:gmatch("[^\n]+") do
																				local match2, v110 = match:match("^(%w+)=(.*)$")

																				if match2 then
																					tbl23[match2] = v110
																				end
																			end
																		end
																	end

																	_G.__RdmCfgBool = function(arg, arg2)
																		local v110 = tbl23[arg]
																		if v110 == v84[34] then
																			return true
																		end

																		if v110 == v84[13] then
																			return false
																		end
																		return arg2
																	end

																	_G.__RdmCfgStr = function(arg, arg2)
																		if n26(2807) >= 11555 then
																			local v110 = tbl23[arg]

																			if n25 > 9120 then
																				while v84[132] do
																				end
																			end

																			local v111 = v84[62]
																			return type(v110) == v111 and v110 ~= "" and v110 or arg2
																		end

																		while true do
																		end
																	end

																	_G.__RdmCfgSet = function(arg, arg2)
																		tbl23[arg] = type(arg2) == "boolean" and (arg2 and "1" or "0") or tostring(arg2)
																		if not writefile then
																			return
																		end
																		local tbl24 = {}

																		for k, v110 in pairs(tbl23) do
																			tbl24[#tbl24 + 1] = k .. "=" .. tostring(v110)
																		end

																		table.sort(tbl24)
																		pcall(writefile, "redeemer_settings.txt", table.concat(tbl24, "\n"))
																	end
																end
															end

															do
																tbl18 = {
																	listenKey = Enum.KeyCode.F,
																	maxFeed = v84[176],
																}

																tbl22 = { MAX = 0.15 }
																max = tbl22[_G.__RdmCfgStr("speed", "MAX")] or tbl22.MAX
																flag19 = _G.__RdmCfgBool(v84[59], v84[12])
																v92 = v84[82]
																flag20 = false
																autoRedeem = _G.__RdmCfgBool("autoRedeem", true)
																autoType = _G.__RdmCfgBool("autoType", true)
																manual = _G.__RdmCfgBool("manual", false)
																flag21 = false
																thread = nil
																n32 = 0
																n33 = 1
																listenKey = tbl18.listenKey
																g = Enum.KeyCode.G
																str7 = nil
																tbl19 = {}
																v93 = nil
																v94 = nil
																flag22 = false
																autoListen = _G.__RdmCfgBool("autoListen", v84[132])
																v95 = _G.__RdmCfgBool(v84[107], true)
																showKeybinds = _G.__RdmCfgBool("showKeybinds", keyboardEnabled)
																v96 = _G.__RdmCfgBool(v84[189], true)
																_G.__RdmDuo = _G.__RdmCfgBool("duo", v84[12])

																_G.__SabClassifyDrop = function(arg)
																	local str8 = tostring(arg or "")
																	local str9 = str8:lower()
																	local tbl23 = {}

																	for match in str8:gmatch("[%w']+") do
																		tbl23[#tbl23 + 1] = match
																	end

																	local n35 = #tbl23
																	if n35 == 0 then
																		return nil
																	end
																	local str10 = " " .. str9:gsub("[^%w]", " ") .. " "
																	if str9:find("?", 1, true) then
																		return "riddle"
																	end

																	for _, v110 in ipairs({
																		" what ",
																		v84[191],
																		" which ",
																		v84[81],
																		" when ",
																		" who ",
																		v84[113],
																		" where ",
																		" why ",
																		" guess ",
																		" riddle ",
																		v84[123],
																	}) do
																		if str10:find(v110, 1, v84[132]) then
																			return "riddle"
																		end
																	end

																	if str10:find(" my ", 1, true) then
																		return "riddle"
																	end
																	local flag23 = n35 >= 2
																	local pos

																	if flag23 then
																		pos = str10:find(" plus ", v84[110], true) or str9:find("+", v84[110], true)
																	else
																		pos = flag23
																	end

																	if pos then
																		return "riddle"
																	end

																	if n35 >= v84[153] and str10:find(" and ", 1, v84[132]) then
																		return "riddle"
																	end

																	if str9:find(v84[171], v84[110], true) then
																		return "code"
																	end

																	for _, v110 in ipairs({ " redeem ", " type ", " enter ", " claim " }) do
																		if str10:find(v110, 1, true) then
																			return "code"
																		end
																	end

																	if n35 >= 7 then
																		return "riddle"
																	end

																	if n35 == 1 then
																		if not flag3 then
																			return
																		end
																		return "code"
																	end

																	if n35 <= 3 then
																		local v110 = v84[44]

																		for _, v111 in ipairs(tbl23) do
																			if #v111 >= 3 and (v111 == v111:upper() and v111:match("%a") or v111:match("%d")) then
																				v110 += 1
																			end
																		end

																		if v110 == n35 then
																			return "code"
																		end
																	end

																	return nil
																end

																fn30 = nil
																fn52 = nil
																fn31 = nil
																fn32 = nil

																fn33 = function(arg)
																	if type(arg) ~= "string" then
																		return tostring(arg)
																	end
																	return (arg:gsub("<[^>]->", ""))
																end

																fn34 = function(arg)
																	return (arg or ""):gsub("^%s+", ""):gsub("%s+$", "")
																end

																fn35 = function(arg)
																	if not writeClipboard then
																		return false
																	end
																	return (pcall(writeClipboard, arg))
																end

																fn36 = function(arg)
																	local tbl23 = {}

																	for match in arg:gmatch("[%w_]+") do
																		tbl23[#tbl23 + 1] = match
																	end

																	return tbl23
																end

																fn37 = function(arg)
																	local v110 = nil

																	for match in arg:gmatch("[%w_]+") do
																		if #match >= v84[153] and match:match("%a") and (match:match("%u") or match:match("%d")) then
																			v110 = match
																		end
																	end

																	if v110 then
																		return v110
																	end

																	for match in arg:gmatch("[%w_]+") do
																		if #match >= 4 then
																			return match
																		end
																	end
																end

																do
																	local tbl23 = {
																		leads = {
																			"use",
																			"using",
																			"redeem",
																			"type",
																			"enter",
																			v84[57],
																			v84[53],
																			"grab",
																			v84[165],
																			"here is",
																			v84[93],
																			"here's",
																			"there is",
																			"theres",
																			"there's",
																		},
																		articles = {
																			"",
																			"the%s+",
																			"a%s+",
																			"an%s+",
																			"this%s+",
																			"your%s+",
																			"new%s+",
																		},
																		patterns = {
																			"code%s+is",
																			"codes?%s+are",
																			"code%s+for",
																			"code%s+to%s+use",
																			"code%s*[:%-]",
																			"new%s+code",
																			"free%s+code",
																			"secret%s+code",
																			"working%s+code",
																			"another%s+code",
																		},
																	}

																	for _, lead in ipairs(tbl23.leads) do
																		local str8 = lead:gsub("%s+", "%%s+")

																		for _, article in ipairs(tbl23.articles) do
																			tbl23.patterns[#tbl23.patterns + 1] = str8 .. "%s+" .. article .. "code"
																		end
																	end

																	tbl23.names = { "sammy" }

																	local function fn53(arg)
																		for match, match2 in arg:gmatch("()([%w_]+)") do
																			if #match2 >= 4 and match2:match("%a") and (match2:match("%u") or match2:match("%d")) then
																				return arg:sub(match)
																			end
																		end
																	end

																	fn38 = function(arg)
																		local str8 = arg:lower()
																		local v110 = nil
																		local v111 = nil

																		local function fn54(arg2, arg3, arg4)
																			local n35 = 1

																			while v84[132] do
																				local ok, result, result2 = pcall(string.find, str8, arg2, n35, arg3)

																				if not (not ok or not result) then
																					if not v110 or result2 > v110 then
																						v110 = result2
																						v111 = arg4
																					end

																					n35 = result2 + v84[110]
																					continue
																				end

																				break
																			end
																		end

																		for _, pattern in ipairs(tbl23.patterns) do
																			fn54(pattern, false, v84[12])
																		end

																		if str8:find(v84[171]) then
																			for _, name in ipairs(tbl23.names) do
																				local v112 = v84[132]
																				fn54(name:lower(), v112, true)
																			end
																		end

																		if not v110 then
																			return nil
																		end
																		local str9 = arg:sub(v110 + v84[110])
																		local v112 = fn53(str9)
																		if v111 then
																			return v112
																		end
																		return v112 or ""
																	end
																end
															end
														end

														do
															local function fn53(arg)
																if not getupvalues_ then
																	return {}
																end
																local ok, result = pcall(getupvalues_, arg)
																local tbl23 = {}

																if ok and result then
																	for _, v110 in pairs(result) do
																		if typeof(v110) == "Instance" and (v110:IsA("RemoteEvent") or v110:IsA("RemoteFunction") or v110:IsA(v84[65])) and v110.Parent == net then
																			table.insert(tbl23, v110)
																		end
																	end
																end

																return tbl23
															end

															fn39 = function()
																local ok, result = pcall(function()
																	return require(v85.Controllers:FindFirstChild("NotificationController", true))
																end)

																if ok then
																	local v110 = v84[151]
																	ok = type(result) == v110
																end

																if ok then
																	local v110 = v84[79]
																	ok = type(result.Start) == v110
																end

																if ok then
																	return fn53(result.Start)[v84[110]]
																end
															end
														end
													end

													do
														local fn53, fn54

														do
															fn53 = function()
																local codes = v87:FindFirstChild("Codes")
																if not codes then
																	return nil
																end
																local v110 = (codes:FindFirstChild("Codes") or codes):FindFirstChild(v84[180])
																v110 = v110 and v110:FindFirstChild(v84[159])
																if v110 and v110:IsA(v84[159]) then
																	return v110
																end

																for _, descendant in ipairs(codes:GetDescendants()) do
																	if descendant:IsA("TextBox") then
																		return descendant
																	end
																end
															end

															do
																local function fn55()
																	local codes = v87:FindFirstChild("Codes")
																	if not codes then
																		return nil
																	end
																	local codes2 = codes:FindFirstChild("Codes") or codes
																	local confirm = (codes2:FindFirstChild(v84[180]) or codes2):FindFirstChild("Confirm")

																	if confirm and (confirm:IsA(v84[173]) or confirm:IsA("TextButton")) then
																		local v110 = v84[130]
																		if n28(1416) < v110 then
																			return confirm
																		end

																		while v84[132] do
																		end
																	end

																	local v110 = nil

																	for _, descendant in ipairs(codes:GetDescendants()) do
																		if descendant:IsA(v84[173]) or descendant:IsA("TextButton") then
																			local str8 = descendant.Name:lower()
																			if str8:find("confirm") or str8:find(v84[10]) or str8:find("redeem") or str8:find("enter") then
																				return descendant
																			end
																			v110 = v110 or descendant
																		end
																	end

																	return v110
																end

																local fn56 = nil

																fn56 = function(arg, arg2)
																	if not (arg and setupvalue_ and getupvalues_) then
																		return
																	end
																	arg2 = arg2 or 1
																	local ok, result = pcall(getupvalues_, arg)

																	if ok and type(result) == "table" then
																		for k, v110 in pairs(result) do
																			local v111 = v84[25]

																			if type(v110) == v111 then
																				pcall(setupvalue_, arg, k, false)
																			else
																				local v112 = v84[79]

																				if type(v110) == v112 and arg2 > 0 then
																					fn56(v110, arg2 - 1)
																				end
																			end
																		end
																	end
																end

																local function fn57(arg, ...)
																	if not getconnections_ then
																		return false
																	end
																	local ok, result = pcall(getconnections_, arg)
																	local flag23 = not ok

																	if not flag23 then
																		local v110 = v84[151]
																		flag23 = type(result) ~= v110
																	end

																	if flag23 or #result == 0 then
																		return false
																	end

																	if n24 <= 9284 then
																		while v84[132] do
																		end
																	end

																	local v110 = table.pack(...)
																	local v111, v112, v113 = ipairs(result)
																	local flag24 = false

																	for _, v114 in v111, v112, v113 do
																		if v114.Enabled ~= false then
																			local function_ = nil

																			pcall(function()
																				function_ = v114.Function
																			end)

																			fn56(function_)
																			local ok2

																			if function_ then
																				ok2 = pcall(task.spawn, function_, table.unpack(v110, v84[110], v110.n))
																			else
																				ok2 = pcall(function()
																					v114:Fire(table.unpack(v110, 1, v110.n))
																				end)
																			end

																			flag24 = flag24 or ok2
																		end
																	end

																	return flag24
																end

																fn40 = function(text)
																	if type(text) ~= "string" or text == "" then
																		return
																	end
																	local v110 = fn53()

																	if not v110 then
																		if n26(3459) < 11342 then
																			return
																		end

																		while v84[132] do
																		end
																	end

																	pcall(function()
																		if v110.Text ~= text then
																			v110.Text = text
																		end
																	end)
																end

																fn54 = function(text)
																	if not getconnections_ then
																		return v84[12], "no getconnections"
																	end
																	local v110 = fn53()
																	if not v110 then
																		return false, v84[46]
																	end

																	pcall(function()
																		v110.Text = text
																		v110.Active = v84[132]
																		v110.Selectable = true
																	end)

																	local v111 = fn55()
																	local flag23 = false

																	if v111 then
																		local flag24 = fn57(v111.MouseButton1Click)
																		flag24 = flag24 or false
																		flag23 = fn57(v111.Activated) or flag24
																	end

																	if not flag23 then
																		flag23 = fn57(v110.FocusLost, true) or flag23
																	end

																	return flag23, flag23 and v84[131] or "no submit control"
																end
															end
														end

														do
															local function fn55(text)
																local v110 = fn53()

																if not v110 then
																	if not flag3 then
																		return
																	end
																	return v84[12], v84[46]
																end

																if not pcall(function()
																	v110.Text = text
																	v110:CaptureFocus()
																end) then
																	return false, "focus failed"
																end

																task.wait(0.1)

																local ok = pcall(function()
																	v110:ReleaseFocus(true)
																end)

																return ok, ok and v84[131] or v84[175]
															end

															fn41 = function(arg)
																local v110, v111 = fn54(arg)

																if v110 then
																	if not flag2 then
																		return
																	end
																	return v84[132], v111
																end

																if getconnections_ then
																	return false, v111
																end
																return fn55(arg)
															end
														end
													end
												end

												tbl20 = {
													ready = false,
													why = "EventController unavailable",
													IsBlocked = function()
														return false
													end,
												}

												do
													local function fn53(arg)
														local v110 = v85:FindFirstChild(v84[47])
														v110 = v110 and v110:FindFirstChild(arg, true)
														if not (v110 and v110:IsA("ModuleScript")) then
															return nil
														end
														local ok, result = pcall(require, v110)
														if ok and type(result) == "table" then
															return result
														end
													end

													local EventController = fn53("EventController")
													local EffectController = fn53("EffectController")
													local flag23 = EventController and type(EventController.Events) == "table"

													if flag23 then
														local v110 = v84[79]
														flag23 = type(EventController.Execute) == v110
													end

													if not flag23 then
														tbl20.why = v84[45]
													else
														local brainrotEventTool, v110, fn54, fn55, fn56, fn57, fn58

														do
															do
																brainrotEventTool = _G.__BrainrotEventTool

																if not brainrotEventTool then
																	if n27(v84[116]) <= 13138 then
																		brainrotEventTool = {}
																		_G.__BrainrotEventTool = brainrotEventTool
																	else
																		while v84[132] do
																		end
																	end
																end

																brainrotEventTool.origExecute = brainrotEventTool.origExecute or EventController.Execute
																brainrotEventTool.origGetActive = brainrotEventTool.origGetActive or EventController.GetActiveEvents

																if EffectController then
																	brainrotEventTool.origRun = brainrotEventTool.origRun or EffectController.Run
																end

																brainrotEventTool.fakes = brainrotEventTool.fakes or {}
																brainrotEventTool.capture = brainrotEventTool.capture or {}
																brainrotEventTool.spawned = brainrotEventTool.spawned or {}
																brainrotEventTool.clearedAttrs = brainrotEventTool.clearedAttrs or {}
																brainrotEventTool.stashed = brainrotEventTool.stashed or {}

																if brainrotEventTool.blocked == nil then
																	brainrotEventTool.blocked = false
																end

																tbl20.S = brainrotEventTool

																tbl20.IsBlocked = function()
																	return brainrotEventTool.blocked and true or v84[12]
																end

																v110 = nil

																do
																	local getupvalue_ = debug and debug.getupvalue

																	if getupvalue_ then
																		local ok, result = pcall(getupvalue_, brainrotEventTool.origExecute, 5)

																		if ok and type(result) == "table" then
																			v110 = result
																		end
																	end
																end
															end

															if not brainrotEventTool.shimmed then
																if n28(v84[77]) <= 690 then
																	EventController.GetActiveEvents = function(arg)
																		local v111 = v84[94]

																		if n27(1962) < v111 then
																			local tbl23 = {}

																			if not brainrotEventTool.blocked then
																				local ok, result = pcall(brainrotEventTool.origGetActive, arg)

																				if ok and type(result) == "table" then
																					for _, v112 in pairs(result) do
																						tbl23[#tbl23 + 1] = v112
																					end
																				end
																			end

																			for _, fake in pairs(brainrotEventTool.fakes) do
																				tbl23[#tbl23 + 1] = fake
																			end

																			return tbl23
																		end

																		while true do
																		end
																	end

																	brainrotEventTool.shimmed = true
																else
																	while true do
																	end
																end
															end

															fn54 = function()
																local v111 = fn53(v84[11])

																if v111 and type(v111.Update) == "function" then
																	pcall(function()
																		v111:Update()
																	end)
																end

																local SoundController = fn53("SoundController")
																local flag24

																if SoundController then
																	local v112 = v84[79]
																	flag24 = type(SoundController.UpdateOST) == v112
																else
																	flag24 = SoundController
																end

																if flag24 then
																	pcall(function()
																		if n27(297) < 1516 then
																			SoundController:UpdateOST()
																		else
																			while v84[132] do
																			end
																		end
																	end)
																end

																if not flag2 then
																	return
																end
															end

															fn55 = function(arg)
																return arg:IsA("Sky") or arg:IsA("Atmosphere") or arg:IsA("Clouds") or arg:IsA("PostEffect")
															end

															fn56 = function()
																local flag24 = EffectController

																if EffectController then
																	local v111 = v84[151]
																	flag24 = type(EffectController.ActiveEffects) == v111
																end

																if not flag24 then
																	return 0
																end
																local tbl23 = {}

																for k in pairs(EffectController.ActiveEffects) do
																	tbl23[#tbl23 + 1] = k
																end

																for _, v111 in ipairs(tbl23) do
																	local v112 = v84[151]
																	local flag25 = type(EffectController.Effects) == v112 and EffectController.Effects[v111] or nil
																	EffectController.ActiveEffects[v111] = nil

																	if type(flag25) == "table" then
																		local v113 = v84[79]

																		if type(flag25.OnUpdate) == v113 then
																			pcall(function()
																				flag25:OnUpdate()
																			end)
																		end

																		if type(flag25.OnStop) == "function" then
																			pcall(function()
																				flag25:OnStop()
																			end)
																		end
																	end
																end

																return #tbl23
															end

															do
																local tbl23 = {
																	EventsLoaded = v84[132],
																	NextCrystalEvent = v84[132],
																	CrystalEventLastTime = true,
																	SantaMerchantStockId = true,
																	SantaMerchantNextStockId = true,
																	FuseMachineLuck = true,
																	FuseMachineLuckTimer = true,
																}

																local tbl24 = {
																	"AyMiGatitoEvent",
																	"ChicleteiraBicicleteiraEvent",
																	"EasterEvent",
																	"ExtinctEvent",
																	"IndonesiaEvent",
																	"MeowlEvent",
																	"MexicoEvent",
																	"RipMyGrannyEvent",
																	"SkibidiEvent",
																	"StPatricksEvent",
																	"StrawberryEvent",
																	"TrickOrTreatEvent",
																	v84[106],
																	v84[124],
																	"WitchingHourEvent",
																}

																local tbl25 = {
																	v84[142],
																	"WallRecolor",
																	v84[80],
																}

																fn57 = function()
																	if not (EffectController and type(EffectController.Effects) == "table") then
																		return
																	end

																	for _, v111 in ipairs(tbl25) do
																		local v112 = EffectController.Effects[v111]
																		local flag24

																		if v112 then
																			local v113 = v84[79]
																			flag24 = type(v112.OnUpdate) == v113
																		else
																			flag24 = v112
																		end

																		if flag24 then
																			pcall(function()
																				v112:OnUpdate()
																			end)
																		end
																	end
																end

																fn58 = function()
																	local tbl26 = {}

																	for _, v111 in ipairs(tbl24) do
																		tbl26[v111] = true
																	end

																	local v111 = v84[44]

																	for k, v112 in pairs(v85:GetAttributes()) do
																		local v113 = v84[62]
																		local flag24 = type(k) == v113 and v112 == v84[132] and not tbl23[k]
																		local pos

																		if flag24 then
																			pos = tbl26[k] or k:find("Event") or k:find("Phase") or k:find("Hour")
																		else
																			pos = flag24
																		end

																		if pos then
																			pcall(function()
																				v85:SetAttribute(k, nil)
																			end)

																			brainrotEventTool.clearedAttrs[k] = true
																			v111 += 1
																		end
																	end

																	fn57()
																	return v111
																end
															end
														end

														do
															local function fn59()
																local n35 = 0

																for k in pairs(brainrotEventTool.clearedAttrs) do
																	pcall(function()
																		v85:SetAttribute(k, true)
																	end)

																	n35 += v84[110]
																end

																table.clear(brainrotEventTool.clearedAttrs)
																fn57()
																return n35
															end

															local function fn60()
																local n35 = 0

																for _, descendant in ipairs(workspace:GetDescendants()) do
																	if descendant:IsA("Sound") and descendant.Playing and descendant.Looped then
																		pcall(function()
																			descendant:Stop()
																		end)

																		n35 += 1
																	end
																end

																return n35
															end

															local function fn61()
																local n35 = 0

																for k, v111 in pairs(brainrotEventTool.stashed) do
																	if typeof(k) == "Instance" then
																		pcall(function()
																			k.Parent = v111
																		end)

																		n35 += v84[110]
																	end

																	brainrotEventTool.stashed[k] = nil
																end

																return n35
															end

															local function fn62()
																local effects = _G.Effects
																if type(effects) == "table" and type(effects.Block) == "function" and type(effects.Unblock) == "function" then
																	return effects
																end
															end

															tbl20.Block = function()
																local v111 = fn62()

																if v111 then
																	v111.Block()
																	brainrotEventTool.blocked = true
																	return v84[132], "blocked (effects panel)"
																end

																local n35 = 0

																for k, event in pairs(EventController.Events) do
																	if type(event) == "table" and rawget(event, v84[4]) then
																		if not (type(EventController.Cancel) == "function" and pcall(function()
																			return EventController:Cancel(k)
																		end)) then
																			rawset(event, "Active", false)
																			rawset(event, "__started", false)
																		end

																		n35 += 1
																	end
																end

																local v112 = fn56()

																for k, v113 in pairs(brainrotEventTool.capture) do
																	local flag24 = type(v113) == "table"

																	if flag24 then
																		local v114 = v84[151]
																		flag24 = type(v113.caught) == v114
																	end

																	if flag24 then
																		for k2 in pairs(v113.caught) do
																			local v114 = v84[66]

																			if typeof(k2) == v114 and k2.Parent and not fn55(k2) then
																				pcall(function()
																					k2:Destroy()
																				end)
																			end
																		end
																	end

																	brainrotEventTool.capture[k] = nil
																end

																table.clear(brainrotEventTool.spawned)
																table.clear(brainrotEventTool.fakes)

																if v110 then
																	for k, v113 in pairs(v110) do
																		local v114 = v84[151]

																		if type(v113) == v114 then
																			for _, v115 in ipairs(v113) do
																				if typeof(v115) == "Instance" and not fn55(v115) then
																					pcall(function()
																						v115:Destroy()
																					end)
																				end
																			end
																		end

																		v110[k] = nil
																	end
																end

																EventController.Execute = function()
																	if not (n24 < 9284) then
																		return false
																	end

																	while true do
																	end
																end

																if EffectController then
																	EffectController.Run = function()
																		return false, false
																	end
																end

																brainrotEventTool.blocked = true
																fn54()
																fn58()
																local v113 = fn60()
																return true, ("blocked %d event(s), %d fx, %d sound(s)"):format(n35, v112, v113)
															end

															tbl20.Unblock = function()
																local v111 = fn62()

																if v111 then
																	v111.Unblock()
																	brainrotEventTool.blocked = v84[12]
																	return true, "unblocked (effects panel)"
																end

																EventController.Execute = brainrotEventTool.origExecute

																if EffectController and brainrotEventTool.origRun then
																	EffectController.Run = brainrotEventTool.origRun
																end

																brainrotEventTool.blocked = v84[12]
																local v112 = fn59()
																local v113 = fn61()
																fn54()
																return true, ("unblocked - %d flag(s), %d model(s) restored"):format(v112, v113)
															end
														end

														tbl20.ready = true
														tbl20.why = nil
													end
												end
											end

											local v110

											do
												do
													tbl21 = {
														bg = Color3.fromRGB(v84[184], v84[184], v84[157]),
														panel = Color3.fromRGB(16, 15, 21),
														panel2 = Color3.fromRGB(32, 28, 42),
														line = Color3.fromRGB(42, 35, 52),
														acc = Color3.fromRGB(235, 90, 175),
														acc2 = Color3.fromRGB(160, 50, 110),
														accHi = Color3.fromRGB(255, v84[90], 210),
														txt = Color3.fromRGB(v84[119], 240, 255),
														sub = Color3.fromRGB(v84[161], 175, v84[1]),
														ok = Color3.fromRGB(55, 195, 105),
														err = Color3.fromRGB(205, 50, v84[14]),
														warn = Color3.fromRGB(255, 215, 0),
														input = Color3.fromRGB(11, v84[196], 15),
														dark = Color3.fromRGB(v84[184], 6, 9),
													}

													gothamMedium = Enum.Font.GothamMedium
													gothamBold = Enum.Font.GothamBold
													gothamBlack = Enum.Font.GothamBlack

													fn42 = function(arg, arg2, parent)
														local instance = Instance.new(arg)
														local v111 = pairs
														local tbl23 = arg2 or {}

														for k, v112 in v111(tbl23) do
															instance[k] = v112
														end

														if parent then
															instance.Parent = parent
														end

														return instance
													end

													fn43 = function(arg, arg2)
														fn42("UICorner", { CornerRadius = UDim.new(0, arg2 or v84[23]) }, arg)
													end

													fn44 = function(arg, arg2, arg3, arg4)
														return fn42("UIStroke", { Color = arg2 or tbl21.line, Thickness = arg3 or 1, Transparency = arg4 or 0 }, arg)
													end

													fn45 = function(arg, arg2, arg3, arg4)
														if not flag3 then
															return
														end
														v109:Create(arg, TweenInfo.new(arg2, arg4 or Enum.EasingStyle.Quad), arg3):Play()
													end

													do
														local function fn53(arg, arg2, arg3, arg4)
															return fn42("UIGradient", { Color = ColorSequence.new(arg2, arg3), Rotation = arg4 or 90 }, arg)
														end

														fn46 = function(arg, arg2, arg3, arg4, arg5, arg6)
															return fn42("TextLabel", {
																BackgroundTransparency = 1,
																Text = arg,
																Font = arg4 or gothamMedium,
																TextSize = arg2 or 12,
																TextColor3 = arg3 or tbl21.txt,
																TextXAlignment = arg5 or Enum.TextXAlignment.Left,
															}, arg6)
														end

														local function fn54(arg, arg2)
															local flag23 = nil
															local v111 = nil
															local v112 = nil

															arg.InputBegan:Connect(function(input)
																if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
																	local position = input.Position
																	local position2 = arg2.Position
																	flag23 = true
																	v111 = position
																	v112 = position2

																	input.Changed:Connect(function()
																		if input.UserInputState == Enum.UserInputState.End then
																			flag23 = false
																			if not flag2 then
																				return
																			end
																		end
																	end)
																end
															end)

															v86.InputChanged:Connect(function(input)
																if flag23 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
																	local n35 = input.Position - v111
																	arg2.Position = UDim2.new(v112.X.Scale, v112.X.Offset + n35.X, v112.Y.Scale, v112.Y.Offset + n35.Y)
																end
															end)
														end

														fn47 = function(arg, arg2, arg3, arg4)
															local v111 = fn42(v84[98], {
																Name = arg,
																Size = UDim2.fromOffset(arg2, arg3),
																BackgroundColor3 = tbl21.bg,
																BorderSizePixel = v84[44],
																Active = true,
																ClipsDescendants = true,
															})

															fn43(v111, 14)
															fn53(v111, Color3.fromRGB(v84[40], 15, 21), Color3.fromRGB(6, 6, v84[157]), 90)
															fn44(v111, tbl21.acc, v84[127], 0.45)

															if flag18 then
																fn42("UIScale", { Name = "WinScale", Scale = v91 }, v111)
															end

															local Frame7 = fn42("Frame", { Size = UDim2.new(1, v84[44], 0, 44), BackgroundColor3 = tbl21.panel, BorderSizePixel = 0 }, v111)
															fn43(Frame7, 14)

															fn42("Frame", {
																Size = UDim2.new(v84[110], 0, v84[44], 14),
																Position = UDim2.new(0, v84[44], 1, -14),
																BackgroundColor3 = tbl21.panel,
																BorderSizePixel = v84[44],
															}, Frame7)

															local ImageLabel = fn42("ImageLabel", {
																Size = UDim2.fromOffset(24, 24),
																Position = UDim2.new(v84[44], 12, v84[55], -v84[112]),
																BackgroundColor3 = tbl21.panel2,
																BorderSizePixel = v84[44],
																Image = "rbxthumb://type=Asset&id=124491981850461&w=150&h=150",
															}, Frame7)

															fn43(ImageLabel, 12)
															fn44(ImageLabel, tbl21.acc, 1.5, 0.2)
															local v112 = fn46(arg4, v84[197], tbl21.txt, gothamBlack, Enum.TextXAlignment.Left, Frame7)
															v112.Size = UDim2.new(1, -v84[89], v84[110], 0)
															v112.Position = UDim2.fromOffset(v84[185], v84[44])
															fn54(Frame7, v111)
															return v111, Frame7, ImageLabel, v112
														end

														fn48 = function(arg, arg2)
															local TextButton2 = fn42("TextButton", {
																BackgroundColor3 = tbl21.panel2,
																Text = arg,
																Font = gothamBold,
																TextSize = v84[112],
																TextColor3 = tbl21.txt,
																AutoButtonColor = false,
																BorderSizePixel = v84[44],
															}, arg2)

															fn43(TextButton2, v84[23])
															local v111 = fn44(TextButton2, tbl21.line, 1, 0.2)

															TextButton2.MouseEnter:Connect(function()
																fn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.panel })
																fn45(v111, v84[37], { Color = tbl21.acc, Transparency = 0 })
															end)

															TextButton2.MouseLeave:Connect(function()
																fn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.panel2 })
																fn45(v111, v84[37], { Color = tbl21.line, Transparency = 0.2 })
															end)

															return TextButton2
														end

														fn49 = function(arg, arg2)
															local TextButton2 = fn42("TextButton", {
																BackgroundColor3 = tbl21.acc,
																Text = arg,
																Font = gothamBlack,
																TextSize = 13,
																TextColor3 = Color3.fromRGB(255, 255, 255),
																AutoButtonColor = v84[12],
																BorderSizePixel = v84[44],
															}, arg2)

															fn43(TextButton2, 8)
															fn53(TextButton2, tbl21.acc, tbl21.acc2, 90)

															TextButton2.MouseEnter:Connect(function()
																fn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.accHi })
															end)

															TextButton2.MouseLeave:Connect(function()
																if v84[39] >= n27(v84[76]) then
																	fn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.acc })
																	if not flag2 then
																		return
																	end
																	return
																end

																while true do
																end
															end)

															return TextButton2
														end
													end
												end

												do
													local hui = gethui and gethui() or v87
													local traced = hui:FindFirstChild("Traced")

													if traced then
														traced:Destroy()
													end

													ScreenGui = fn42("ScreenGui", {
														Name = "Traced",
														ResetOnSpawn = false,
														ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
														DisplayOrder = 250,
													}, hui)
												end

												do
													local v111, v112
													Main, v110, v111, v112 = fn47("Main", 316, 548, "TRACED")
													Main.Position = UDim2.new(v84[110], -340, 0.5, -v84[74])

													if flag18 then
														Main.Position = UDim2.new(v84[110], -math.floor(316 * v91) - 8, 0.5, -math.floor(548 * v91 / 2))
													end

													Main.Parent = ScreenGui
													v112.Size = UDim2.new(v84[110], -262, v84[110], 0)
												end
											end

											do
												fn43(fn42(v84[146], {
													Name = "CityBg",
													Size = UDim2.new(v84[110], 0, 1, 0),
													BackgroundTransparency = v84[110],
													BorderSizePixel = 0,
													ZIndex = 0,
													Image = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420",
													ImageTransparency = 0.5,
													ImageColor3 = Color3.fromRGB(200, 160, v84[154]),
													ScaleType = Enum.ScaleType.Crop,
												}, Main), 14)

												do
													local Frame7 = fn42("Frame", {
														Name = "LeavesLayer",
														Size = UDim2.new(1, 0, 1, v84[44]),
														BackgroundTransparency = 1,
														BorderSizePixel = 0,
														ZIndex = 0,
														ClipsDescendants = true,
													}, Main)

													fn43(Frame7, 14)
													local tbl23 = {}
													local color = Color3.fromRGB(v84[137], 205, 225)
													local color2 = Color3.fromRGB(255, 175, v84[1])
													local color3 = Color3.fromRGB(245, 135, 185)
													local color4 = Color3.fromRGB(v84[137], 220, 235)
													local color5 = Color3.fromRGB
													local v111 = v84[168]
													tbl23[1] = color
													tbl23[2] = color2
													tbl23[3] = color3
													tbl23[4] = color4

													do
														local values = table.pack(color5(230, 110, v111))
														table.move(values, 1, values.n, 5, tbl23)
													end

													for i = 1, v84[8] do
														task.spawn(function()
															task.wait(math.random() * 2.5)

															while Frame7.Parent do
																local n35 = math.random(5, 8)
																local n36 = n35 + math.random(2, v84[153])
																local n37 = math.random()
																local v112 = v84[95]

																local Frame8 = fn42("Frame", {
																	Size = UDim2.new(0, n35, v84[44], n36),
																	AnchorPoint = Vector2.new(0.5, v84[55]),
																	Position = UDim2.new(n37, 0, 0, -n36),
																	BackgroundColor3 = tbl23[math.random(#tbl23)],
																	BackgroundTransparency = 0.15 + math.random() * v112,
																	BorderSizePixel = 0,
																	ZIndex = v84[44],
																	Rotation = math.random(0, 359),
																}, Frame7)

																fn42("UICorner", { CornerRadius = UDim.new(1, 0) }, Frame8)
																local new = NumberSequenceKeypoint.new

																fn42("UIGradient", {
																	Rotation = math.random(v84[44], 359),
																	Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), new(1, 0.55) }),
																}, Frame8)

																local n38 = v84[118] + math.random() * 2.6
																local v113 = v84[95]
																local n39 = (math.random() - 0.5) * v113
																local n40 = math.random(180, 540)
																local n41 = math.random() < 0.5 and -v84[110] or 1
																v109:Create(Frame8, TweenInfo.new(n38, Enum.EasingStyle.Linear), { Position = UDim2.new(n37 + n39, v84[44], 1, n36 * 2), Rotation = Frame8.Rotation + n40 * n41 }):Play()
																task.wait(n38)

																if Frame8 and Frame8.Parent then
																	Frame8:Destroy()
																end

																task.wait(math.random() * 0.5)
															end
														end)
													end
												end
											end

											do
												Frame = fn42("Frame", {
													Size = UDim2.fromOffset(v84[23], 8),
													Position = UDim2.new(1, -212, 0.5, -4),
													BackgroundColor3 = tbl21.sub,
													BorderSizePixel = v84[44],
													Visible = false,
												}, v110)

												fn43(Frame, 4)
												Rag = fn48("Rag", v110)
												Rag.Size = UDim2.fromOffset(38, 22)
												Rag.Position = UDim2.new(1, -200, v84[55], -11)
												Rag.TextSize = v84[196]
												v97 = fn48(v84[61], v110)
												v97.Size = UDim2.fromOffset(38, 22)
												v97.Position = UDim2.new(v84[110], -v84[71], 0.5, -11)
												v97.TextSize = 10
												v98 = fn48(v84[193], v110)
												v98.Size = UDim2.fromOffset(38, 22)
												v98.Position = UDim2.new(v84[110], -114, 0.5, -v84[133])
												v98.TextSize = v84[196]
												Settings = fn48("Settings", v110)
												Settings.Size = UDim2.fromOffset(v84[38], 22)
												Settings.Position = UDim2.new(1, -71, 0.5, -11)
												Settings.TextSize = 8

												do
													local v111 = fn48("", v110)
													v111.Size = UDim2.fromOffset(22, 22)
													v111.Position = UDim2.new(1, -28, 0.5, -v84[133])

													fn43(fn42("Frame", {
														Size = UDim2.fromOffset(10, v84[88]),
														Position = UDim2.new(0.5, -5, 0.5, -1),
														BackgroundColor3 = tbl21.txt,
														BorderSizePixel = 0,
													}, v111), 1)

													local v112 = fn42(v84[98], {
														Size = UDim2.fromOffset(2, 10),
														Position = UDim2.new(0.5, -v84[110], 0.5, -5),
														BackgroundColor3 = tbl21.txt,
														BorderSizePixel = 0,
														Visible = false,
													}, v111)

													fn43(v112, 1)
													n34 = 548
													visible = false

													v111.MouseButton1Click:Connect(function()
														visible = not visible
														v112.Visible = visible
														fn45(Main, v84[152], { Size = UDim2.fromOffset(v84[96], visible and 179 or n34) })
													end)
												end
											end
										end

										Frame6 = fn42("Frame", {
											Size = UDim2.new(v84[110], -20, 1, -54),
											Position = UDim2.fromOffset(10, 48),
											BackgroundTransparency = 1,
										}, Main)

										fn42(v84[102], {
											Padding = UDim.new(0, 5),
											SortOrder = Enum.SortOrder.LayoutOrder,
										}, Frame6)

										do
											local Frame7 = fn42("Frame", {
												Size = UDim2.new(1, 0, v84[44], 32),
												BackgroundColor3 = tbl21.panel,
												BorderSizePixel = 0,
												LayoutOrder = 1,
											}, Frame6)

											fn43(Frame7, 9)
											fn44(Frame7, tbl21.line, v84[110], 0.3)

											local Frame8 = fn42("Frame", {
												Size = UDim2.fromOffset(8, 8),
												Position = UDim2.new(0, 12, 0.5, -4),
												BackgroundColor3 = tbl21.sub,
												BorderSizePixel = 0,
											}, Frame7)

											fn43(Frame8, 4)
											v99 = fn46("starting...", 12, tbl21.txt, gothamBold, Enum.TextXAlignment.Left, Frame7)
											v99.Size = UDim2.new(1, -32, 1, 0)
											v99.Position = UDim2.fromOffset(28, 0)
											v99.TextTruncate = Enum.TextTruncate.AtEnd

											fn50 = function(text, arg)
												v99.Text = text
												local ok = arg == v84[140] and tbl21.ok or arg == "err" and tbl21.err or arg == v84[155] and tbl21.acc or arg == "wait" and tbl21.warn or tbl21.txt
												v99.TextColor3 = ok
												Frame8.BackgroundColor3 = ok
											end
										end
									end

									do
										do
											do
												do
													local v109 = fn42(v84[98], {
														Size = UDim2.new(1, 0, v84[44], v84[14]),
														BackgroundColor3 = tbl21.panel,
														BorderSizePixel = 0,
														LayoutOrder = 2,
													}, Frame6)

													fn43(v109, 9)
													fn44(v109, tbl21.line, 1, 0.3)
													local v110 = fn46(v84[48], 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, v109)
													v110.Size = UDim2.new(1, -16, v84[44], v84[133])
													v110.Position = UDim2.fromOffset(11, 5)

													TextBox = fn42("TextBox", {
														Size = UDim2.new(1, -v84[8], 0, v84[7]),
														Position = UDim2.fromOffset(9, 18),
														BackgroundColor3 = tbl21.input,
														Text = "",
														PlaceholderText = "type or snipe a code...",
														PlaceholderColor3 = tbl21.sub,
														Font = gothamBlack,
														TextSize = 14,
														TextColor3 = tbl21.txt,
														ClearTextOnFocus = v84[12],
														BorderSizePixel = 0,
														TextXAlignment = Enum.TextXAlignment.Left,
													}, v109)
												end

												do
													fn43(TextBox, 7)

													do
														local v109 = fn44(TextBox, tbl21.line, 1.2, 0.25)

														fn42(v84[192], {
															PaddingLeft = UDim.new(v84[44], 9),
															PaddingRight = UDim.new(v84[44], 9),
														}, TextBox)

														TextBox.Focused:Connect(function()
															fn45(v109, 0.12, { Color = tbl21.acc, Transparency = 0 })
														end)

														TextBox.FocusLost:Connect(function()
															fn45(v109, v84[37], { Color = tbl21.line, Transparency = 0.25 })

															if v84[64] < n25 then
																while v84[132] do
																end
															end
														end)
													end
												end

												do
													local v109 = fn42(v84[98], {
														Size = UDim2.new(1, 0, 0, 33),
														BackgroundTransparency = v84[110],
														LayoutOrder = 3,
													}, Frame6)

													fn42("UIListLayout", {
														FillDirection = Enum.FillDirection.Horizontal,
														Padding = UDim.new(0, 6),
														SortOrder = Enum.SortOrder.LayoutOrder,
													}, v109)

													v100 = fn48(v84[190], v109)
													v100.Size = UDim2.new(0.33333333333333331, -4, v84[110], 0)
													v100.LayoutOrder = 1
													clear = fn48("CLEAR", v109)
													clear.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
													clear.LayoutOrder = 2
													redeem = fn49("REDEEM", v109)
												end
											end

											do
												local fn53

												do
													redeem.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
													redeem.LayoutOrder = 3
													redeem.TextColor3 = Color3.fromRGB(0, v84[44], v84[44])

													fn51 = function(arg, arg2, arg3, arg4, arg5)
														local Frame7 = fn42("Frame", {
															Size = UDim2.new(1, 0, v84[44], 31),
															BackgroundColor3 = tbl21.panel,
															BorderSizePixel = 0,
															LayoutOrder = arg2,
														}, arg)

														fn43(Frame7, 8)
														fn44(Frame7, tbl21.line, v84[110], 0.3)
														local v109 = fn46(arg3, v84[133], tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
														v109.Size = UDim2.new(v84[110], -56, 1, 0)
														v109.Position = UDim2.fromOffset(12, 0)
														v109.TextTruncate = Enum.TextTruncate.AtEnd

														local Frame8 = fn42("Frame", {
															Size = UDim2.fromOffset(36, 18),
															Position = UDim2.new(1, -v84[162], 0.5, -9),
															BackgroundColor3 = tbl21.line,
															BorderSizePixel = 0,
														}, Frame7)

														fn43(Frame8, 9)

														local Frame9 = fn42("Frame", {
															Size = UDim2.fromOffset(14, v84[150]),
															Position = UDim2.new(0, 2, 0.5, -7),
															BackgroundColor3 = tbl21.txt,
															BorderSizePixel = 0,
														}, Frame8)

														fn43(Frame9, 7)
														local v110 = fn42(v84[72], { Size = UDim2.fromScale(1, v84[110]), BackgroundTransparency = 1, Text = "" }, Frame7)
														local flag23 = arg4

														local function fn54()
															fn45(Frame8, 0.16, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.line })
															fn45(Frame9, 0.16, { Position = UDim2.new(0, flag23 and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
															fn45(v109, v84[21], { TextColor3 = flag23 and tbl21.txt or tbl21.sub })
														end

														fn54()

														v110.MouseButton1Click:Connect(function()
															flag23 = not flag23
															fn54()

															if arg5 then
																arg5(flag23)
															end
														end)

														return Frame7
													end

													fn53 = function(arg, arg2, arg3, arg4)
														return fn51(Frame6, arg, arg2, arg3, arg4)
													end

													do
														local Frame7 = fn42("Frame", {
															Size = UDim2.new(1, 0, 0, 31),
															BackgroundColor3 = tbl21.panel,
															BorderSizePixel = 0,
															LayoutOrder = 4,
														}, Frame6)

														fn43(Frame7, v84[23])
														fn44(Frame7, tbl21.line, 1, 0.3)
														listen = fn46("LISTEN", v84[133], tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
														listen.Size = UDim2.new(1, -v84[158], 1, 0)
														listen.Position = UDim2.fromOffset(v84[112], 0)

														Frame2 = fn42("Frame", {
															Size = UDim2.fromOffset(36, 18),
															Position = UDim2.new(1, -v84[162], v84[55], -9),
															BackgroundColor3 = tbl21.line,
															BorderSizePixel = v84[44],
														}, Frame7)

														fn43(Frame2, 9)

														Frame3 = fn42("Frame", {
															Size = UDim2.fromOffset(14, 14),
															Position = UDim2.new(0, 2, v84[55], -7),
															BackgroundColor3 = tbl21.txt,
															BorderSizePixel = v84[44],
														}, Frame2)

														fn43(Frame3, 7)

														TextButton = fn42("TextButton", {
															Size = UDim2.fromScale(v84[110], 1),
															BackgroundTransparency = 1,
															Text = "",
														}, Frame7)
													end
												end

												do
													Frame4 = fn42("Frame", {
														Size = UDim2.new(1, 0, 0, 31),
														BackgroundColor3 = tbl21.panel,
														BorderSizePixel = 0,
														LayoutOrder = 5,
													}, Frame6)

													fn43(Frame4, 8)
													fn44(Frame4, tbl21.line, 1, 0.3)

													do
														local v109 = fn46(v84[52], 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame4)
														v109.Size = UDim2.new(1, -100, 1, 0)
														v109.Position = UDim2.fromOffset(12, v84[44])
													end
												end

												v101 = fn48(listenKey and listenKey.Name or "-", Frame4)
												v101.Size = UDim2.fromOffset(46, v84[50])
												v101.Position = UDim2.new(1, -84, 0.5, -v84[112])
												v101.TextSize = v84[133]
												v102 = fn48("X", Frame4)
												v102.Size = UDim2.fromOffset(24, 24)
												v102.Position = UDim2.new(1, -32, 0.5, -12)
												v102.TextSize = 12

												Frame5 = fn42("Frame", {
													Size = UDim2.new(1, 0, 0, 31),
													BackgroundColor3 = tbl21.panel,
													BorderSizePixel = 0,
													LayoutOrder = 6,
												}, Frame6)

												fn43(Frame5, 8)
												fn44(Frame5, tbl21.line, v84[110], 0.3)

												do
													local v109 = fn46(v84[58], 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame5)
													v109.Size = UDim2.new(1, -100, 1, v84[44])
													v109.Position = UDim2.fromOffset(v84[112], 0)
												end

												v103 = fn48(g and g.Name or "-", Frame5)
												v103.Size = UDim2.fromOffset(46, 24)
												v103.Position = UDim2.new(1, -84, v84[55], -12)
												v103.TextSize = 11
												v104 = fn48(v84[111], Frame5)
												v104.Size = UDim2.fromOffset(24, 24)
												v104.Position = UDim2.new(1, -v84[73], 0.5, -12)
												v104.TextSize = 12

												fn53(7, "AUTO REDEEM", autoRedeem, function(arg)
													autoRedeem = arg
													_G.__RdmCfgSet(v84[125], arg)
												end)

												fn53(8, "AUTO TYPE", autoType, function(arg)
													autoType = arg
													_G.__RdmCfgSet(v84[163], arg)
												end)

												fn53(9, "MANUAL", manual, function(arg)
													manual = arg
													tbl19 = {}
													fn52()
												end)
											end

											do
												local function fn53(arg, arg2, arg3, arg4, arg5)
													local Frame7 = fn42("Frame", {
														Size = UDim2.new(1, 0, 0, 31),
														BackgroundColor3 = tbl21.panel,
														BorderSizePixel = 0,
														LayoutOrder = arg,
													}, Frame6)

													fn43(Frame7, v84[23])
													fn44(Frame7, tbl21.line, 1, v84[181])
													local v109 = fn46(arg2, 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
													v109.Size = UDim2.fromOffset(56, 31)
													v109.Position = UDim2.fromOffset(v84[133], v84[44])

													local v110 = fn42(v84[98], {
														Size = UDim2.fromOffset(168, 23),
														Position = UDim2.new(1, -177, 0.5, -11.5),
														BackgroundColor3 = tbl21.input,
														BorderSizePixel = 0,
													}, Frame7)

													fn43(v110, 7)
													local tbl23 = {}

													local function fn54(arg6)
														for k, v111 in pairs(tbl23) do
															local flag23 = k == arg6
															fn45(v111, 0.12, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.input })
															v111.TextColor3 = flag23 and Color3.fromRGB(255, 255, v84[137]) or tbl21.sub
														end

														if arg5 then
															arg5(arg6)
														end
													end

													for i, v111 in ipairs(arg3) do
														local flag23 = type(v111) == "table" and v111[1] or v111
														local flag24 = type(v111) == "table" and v111[v84[88]] or v111

														local TextButton2 = fn42("TextButton", {
															Size = UDim2.new(v84[110] / #arg3, -v84[88], 1, -2),
															Position = UDim2.new((i - 1) / #arg3, 1, 0, v84[110]),
															BackgroundColor3 = tbl21.input,
															Text = flag24,
															Font = gothamBold,
															TextSize = flag24:find("\n") and 8 or 10,
															TextColor3 = tbl21.sub,
															AutoButtonColor = v84[12],
															BorderSizePixel = 0,
														}, v110)

														fn43(TextButton2, 6)
														tbl23[flag23] = TextButton2

														TextButton2.MouseButton1Click:Connect(function()
															fn54(flag23)
														end)
													end

													fn54(arg4)
													return Frame7, fn54
												end

												words = fn53(11, "WORDS", { v84[34], v84[28], v84[188], v84[32] }, tostring(n33), function(arg)
													n33 = tonumber(arg) or 1
													tbl19 = {}

													if flag20 and not manual then
														fn50(("listening... 0/%d"):format(n33), "wait")
													end
												end)

												local Frame7 = fn42("Frame", {
													Size = UDim2.new(1, 0, 0, 31),
													BackgroundColor3 = tbl21.panel,
													BorderSizePixel = v84[44],
													LayoutOrder = 12,
												}, Frame6)

												fn43(Frame7, 8)
												v105 = fn44(Frame7, tbl21.line, v84[110], 0.3)
												v106 = fn46(v84[15], 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
												v106.Size = UDim2.new(1, -94, 1, 0)
												v106.Position = UDim2.fromOffset(11, 0)
												start = fn48("START", Frame7)
												start.Size = UDim2.fromOffset(70, 24)
												start.Position = UDim2.new(1, -v84[24], 0.5, -12)
												start.TextSize = v84[133]

												v107 = fn42(v84[98], {
													Size = UDim2.fromOffset(7, 7),
													Position = UDim2.new(0, 9, 0.5, -3.5),
													BackgroundColor3 = tbl21.line,
													BorderSizePixel = 0,
												}, start)

												fn43(v107, 4)

												fn53(13, "SPEED", { "MAX", { "WORD", "EVERY\nWORD" } }, _G.__RdmCfgBool("wordMode", false) and v84[103] or "MAX", function(arg)
													flag19 = arg == v84[103]

													if not flag19 then
														if not flag2 then
															return
														end
														max = tbl22[arg] or tbl22.MAX
													end

													_G.__RdmCfgSet("speed", arg)
													_G.__RdmCfgSet("wordMode", flag19)
												end)
											end
										end

										do
											local Frame7

											do
												do
													do
														local v109 = nil

														for _, descendant in ipairs(Frame6:GetDescendants()) do
															if descendant:IsA("TextButton") and descendant.Text == "EVERY\nWORD" then
																v109 = descendant
																break
															else
																v109 = nil
															end
														end

														if v109 then
															fn42("TextLabel", {
																Size = UDim2.fromOffset(64, 8),
																AnchorPoint = Vector2.new(v84[55], 1),
																Position = UDim2.new(v84[55], v84[44], 0, -1),
																BackgroundTransparency = 1,
																TextColor3 = tbl21.warn,
																TextTransparency = 0.35,
																Font = gothamBlack,
																TextSize = 8,
																Text = v84[199],
																ZIndex = 3,
															}, v109)
														end
													end
												end

												Frame7 = fn42("Frame", {
													Size = UDim2.new(1, 0, 0, v84[115]),
													BackgroundColor3 = tbl21.panel,
													BorderSizePixel = 0,
													LayoutOrder = 14,
												}, Frame6)

												fn43(Frame7, 8)
												fn44(Frame7, tbl21.line, v84[110], 0.3)

												do
													local events = fn46("EVENTS", v84[133], tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
													events.Size = UDim2.new(v84[110], -104, 1, 0)
													events.Position = UDim2.fromOffset(11, 0)
												end
											end

											local blockAll = fn48("BLOCK ALL", Frame7)
											blockAll.Size = UDim2.fromOffset(v84[128], 24)
											blockAll.Position = UDim2.new(1, -97, 0.5, -12)
											blockAll.TextSize = 10
											local flag23 = false
											local v109 = nil
											local str8 = nil
											local str9 = nil
											local n35 = v84[44]

											local function fn53()
												local flag24 = os.clock() < n35
												local str10 = tostring(tbl20.ready) .. tostring(flag24)
												if str10 == v109 then
													return
												end
												v109 = str10
												blockAll.Text = flag24 and "BLOCKED" or "BLOCK ALL"
												blockAll.TextColor3 = not tbl20.ready and tbl21.sub or flag24 and tbl21.ok or tbl21.txt
											end

											blockAll.MouseButton1Click:Connect(function()
												if flag23 then
													return
												end

												if not tbl20.ready then
													local v110 = v84[5]
													fn50("events: " .. tostring(tbl20.why), v110)
													return
												end

												if not flag3 then
													return
												end
												flag23 = true
												fn50(v84[139], v84[155])

												task.spawn(function()
													local ok, result, result2 = pcall(tbl20.Block)

													if ok and result then
														result2 = result2 or "blocked"
														str8 = result2
														str9 = "ok"
													else
														str8 = "events: " .. tostring(result2 or result)
														str9 = "err"
													end

													flag23 = false
												end)
											end)

											task.spawn(function()
												while Frame7.Parent do
													if str8 then
														local v110 = str8
														local v111 = str9
														str8 = nil
														str9 = nil

														if v111 == "ok" then
															n35 = os.clock() + 1
														end

														pcall(fn50, v110, v111)
													end

													pcall(fn53)
													task.wait(0.2)
												end
											end)

											fn53()
										end
									end
								end

								do
									local fn53, Settings2

									do
										do
											do
												local n35 = 548
												local n36 = 36
												local tbl22 = {}
												local tbl23 = {}
												local n37 = 0

												local function fn54(arg, arg2, arg3)
													local flag23 = tbl22[arg]

													if flag23 == nil then
														flag23 = true
													end

													if flag23 == arg2 then
														return
													end
													tbl22[arg] = arg2
													local n38 = (tbl23[arg] or 0) + 1
													tbl23[arg] = n38
													n37 = math.max(0, n37 + (arg2 and -1 or 1))
													n34 = n35 - n37 * n36

													if not visible then
														if arg3 then
															Main.Size = UDim2.fromOffset(v84[96], n34)
														else
															fn45(Main, 0.2, { Size = UDim2.fromOffset(v84[96], n34) }, Enum.EasingStyle.Quart)
														end
													end

													arg.ClipsDescendants = v84[132]

													if arg2 then
														arg.Visible = true

														if arg3 then
															arg.Size = UDim2.new(v84[110], v84[44], v84[44], 31)
															arg.ClipsDescendants = false
															return
														end

														arg.Size = UDim2.new(v84[110], 0, 0, 0)
														fn45(arg, 0.2, { Size = UDim2.new(v84[110], v84[44], 0, 31) }, Enum.EasingStyle.Quart)

														task.delay(v84[43], function()
															if tbl23[arg] == n38 then
																arg.ClipsDescendants = false
															end
														end)
													elseif arg3 then
														if n26(3696) <= 11540 then
															arg.Size = UDim2.new(v84[110], 0, 0, 0)
															arg.Visible = v84[12]
															return
														end

														while true do
														end
													else
														fn45(arg, 0.2, { Size = UDim2.new(1, v84[44], 0, 0) }, Enum.EasingStyle.Quart)

														task.delay(0.22, function()
															if tbl23[arg] == n38 then
																arg.Visible = false
															end
														end)
													end
												end

												fn52 = function(arg)
													fn54(words, not manual, arg)
												end

												fn53 = function(arg)
													fn54(Frame4, showKeybinds, arg)
													fn54(Frame5, showKeybinds, arg)
												end
											end
										end

										do
											local v109
											Settings2, v109 = fn47("Settings", 300, flag18 and 316 or 280, "SETTINGS")
											Settings2.Visible = false
											Settings2.Parent = ScreenGui
											local v110 = fn48("X", v109)
											v110.Size = UDim2.fromOffset(22, v84[97])
											v110.Position = UDim2.new(v84[110], -28, 0.5, -11)
											v110.TextSize = 12

											v110.MouseButton1Click:Connect(function()
												Settings2.Visible = false
											end)
										end
									end

									local Frame6

									do
										Frame6 = fn42("Frame", {
											Size = UDim2.new(v84[110], -v84[84], 1, -v84[104]),
											Position = UDim2.fromOffset(10, 50),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
										}, Settings2)

										fn42("UIListLayout", {
											Padding = UDim.new(0, 5),
											SortOrder = Enum.SortOrder.LayoutOrder,
										}, Frame6)

										fn51(Frame6, 1, "AUTO LISTEN", autoListen, function(arg)
											autoListen = arg
											_G.__RdmCfgSet(v84[92], arg)
										end)

										fn51(Frame6, 2, "SPAM ON LISTEN", v95, function(arg)
											v95 = arg
											_G.__RdmCfgSet(v84[107], arg)
										end)

										fn51(Frame6, 3, "SHOW KEYBINDS", showKeybinds, function(arg)
											showKeybinds = arg
											fn53()
											_G.__RdmCfgSet("showKeybinds", arg)
										end)

										fn51(Frame6, 4, "IGNORE SYSTEM PHRASES", v96, function(arg)
											v96 = arg
											_G.__RdmCfgSet("ignoreSystem", arg)
										end)

										do
											local v109 = fn51(Frame6, 6, "DUO MODE (WITH RIDDLER)", _G.__RdmDuo, function(rdmDuo)
												local v109 = v84[109]

												if n27(437) <= v109 then
													_G.__RdmDuo = rdmDuo
													_G.__RdmCfgSet("duo", rdmDuo)

													if _G.__SabDuoSync then
														_G.__SabDuoSync()
													end

													return
												end

												while true do
												end
											end)

											local v110 = fn46("0/2", 10, tbl21.sub, gothamBold, Enum.TextXAlignment.Right, v109)
											v110.Size = UDim2.fromOffset(v84[170], 31)
											v110.Position = UDim2.new(v84[110], -84, 0, v84[44])

											for _, child in ipairs(v109:GetChildren()) do
												if child:IsA("TextLabel") and child ~= v110 then
													child.Size = UDim2.new(v84[110], -v84[2], v84[110], 0)
												end
											end

											local function redeemer()
												if not flag2 then
													return
												end
												local n35 = (_G.__RiddlerDuo and v84[110] or 0) + (_G.__RdmDuo and 1 or 0)
												v110.Text = n35 .. "/2"
												v110.TextColor3 = n35 == 2 and tbl21.acc or n35 == 1 and (tbl21.warn or tbl21.sub) or tbl21.sub
											end

											redeemer()
											_G.__SabDuoRefresh = _G.__SabDuoRefresh or {}
											_G.__SabDuoRefresh.redeemer = redeemer

											_G.__SabDuoSync = function()
												local v111 = pairs
												local sabDuoRefresh = _G.__SabDuoRefresh or {}

												for _, v112 in v111(sabDuoRefresh) do
													pcall(v112)
												end
											end

											_G.__SabDuoSync()

											task.spawn(function()
												while v109.Parent do
													redeemer()
													task.wait(v84[110])
												end
											end)
										end
									end

									do
										local Frame7

										do
											if flag18 then
												local Frame8

												do
													local Frame9 = fn42("Frame", {
														Size = UDim2.new(1, 0, v84[44], 31),
														BackgroundColor3 = tbl21.panel,
														BorderSizePixel = v84[44],
														LayoutOrder = 5,
													}, Frame6)

													fn43(Frame9, 8)
													fn44(Frame9, tbl21.line, v84[110], 0.3)
													local uiSize = fn46("UI SIZE", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame9)
													uiSize.Size = UDim2.fromOffset(70, 31)
													uiSize.Position = UDim2.fromOffset(11, 0)

													Frame8 = fn42("Frame", {
														Size = UDim2.fromOffset(168, 23),
														Position = UDim2.new(1, -177, 0.5, -11.5),
														BackgroundColor3 = tbl21.input,
														BorderSizePixel = v84[44],
													}, Frame9)
												end

												fn43(Frame8, 7)

												do
													local tbl22 = {}

													local function fn54(arg, arg2)
														for k, v109 in pairs(tbl22) do
															local flag23 = k == arg
															fn45(v109, 0.12, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.input })
															v109.TextColor3 = flag23 and Color3.fromRGB(v84[137], 255, 255) or tbl21.sub
														end

														if arg2 then
															return
														end
														_G.__RdmCfgSet("uiSize", arg)

														if tbl18.refit then
															tbl18.refit()
														end
													end

													local tbl23 = { "BIG", "MEDIUM", "SMALL" }

													for i, v109 in ipairs(tbl23) do
														local TextButton2 = fn42("TextButton", {
															Size = UDim2.new(1 / #tbl23, -2, 1, -2),
															Position = UDim2.new((i - 1) / #tbl23, v84[110], 0, v84[110]),
															BackgroundColor3 = tbl21.input,
															Text = v109,
															Font = gothamBold,
															TextSize = 9,
															TextColor3 = tbl21.sub,
															AutoButtonColor = false,
															BorderSizePixel = v84[44],
														}, Frame8)

														fn43(TextButton2, 6)
														tbl22[v109] = TextButton2

														TextButton2.MouseButton1Click:Connect(function()
															fn54(v109)
														end)
													end

													fn54(_G.__RdmCfgStr(v84[54], "MEDIUM"), true)
												end
											end

											Frame7 = fn42("Frame", {
												Size = UDim2.new(v84[110], v84[44], v84[44], 31),
												BackgroundColor3 = tbl21.panel,
												BorderSizePixel = v84[44],
												LayoutOrder = 6,
											}, Frame6)

											fn43(Frame7, 8)
											fn44(Frame7, tbl21.line, 1, 0.3)

											do
												local autoBuy = fn46("AUTO BUY", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
												autoBuy.Size = UDim2.new(1, -70, v84[110], v84[44])
												autoBuy.Position = UDim2.fromOffset(12, 0)
											end
										end

										local open = fn48("OPEN", Frame7)
										open.Size = UDim2.fromOffset(52, 22)
										open.Position = UDim2.new(v84[110], -60, 0.5, -11)
										open.TextSize = 10

										open.MouseButton1Click:Connect(function()
											Settings2.Visible = false

											if fn31 then
												fn31()
											end
										end)
									end

									do
										local function fn54()
											if flag18 then
												Settings2.Position = UDim2.new(0.5, -math.floor(Settings2.AbsoluteSize.X / 2), 0.5, -math.floor(Settings2.AbsoluteSize.Y / 2))
											else
												local position = Main.Position
												Settings2.Position = UDim2.new(position.X.Scale, position.X.Offset - Settings2.AbsoluteSize.X - v84[196], position.Y.Scale, position.Y.Offset)
											end

											Settings2.Visible = true
										end

										v108 = fn54

										Settings.MouseButton1Click:Connect(function()
											if not Settings2.Visible then
												fn54()
												return
											end

											if not (n24 > 9293) then
												Settings2.Visible = false
												return
											end

											while true do
											end
										end)
									end

									fn53(v84[132])
								end

								fn52(true)
							end

							local Frame4, fn52, fn53, tbl22

							do
								do
									do
										local Feed, v109, v110

										do
											do
												local v111
												Feed, v111 = fn47("Feed", v84[136], 320, "LIVE FEED")
												Feed.Visible = v84[12]
												Feed.Parent = ScreenGui

												Frame4 = fn42("Frame", {
													Size = UDim2.fromOffset(8, 8),
													Position = UDim2.new(1, -v84[60], v84[55], -v84[153]),
													BackgroundColor3 = tbl21.sub,
													BorderSizePixel = v84[44],
												}, v111)

												fn43(Frame4, 4)
												v109 = fn46("0 caught", 10, tbl21.sub, gothamBold, Enum.TextXAlignment.Right, v111)
												v109.Size = UDim2.fromOffset(v84[29], v84[185])
												v109.Position = UDim2.new(1, -166, v84[44], 0)
												v110 = fn48(v84[87], v111)
												v110.Size = UDim2.fromOffset(40, 22)
												v110.Position = UDim2.new(1, -82, 0.5, -11)
												v110.TextSize = v84[196]
												local v112 = fn48(v84[111], v111)
												v112.Size = UDim2.fromOffset(22, 22)
												v112.Position = UDim2.new(1, -32, 0.5, -11)
												v112.TextSize = 12

												v112.MouseButton1Click:Connect(function()
													Feed.Visible = false
												end)
											end
										end

										local ScrollingFrame = fn42("ScrollingFrame", {
											Size = UDim2.new(1, -18, v84[110], -56),
											Position = UDim2.fromOffset(v84[133], 50),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											ScrollBarThickness = v84[177],
											ScrollBarImageColor3 = tbl21.acc,
											ScrollBarImageTransparency = 0.3,
											CanvasSize = UDim2.new(),
											AutomaticCanvasSize = Enum.AutomaticSize.Y,
											ScrollingDirection = Enum.ScrollingDirection.Y,
										}, Feed)

										fn42("UIListLayout", {
											Padding = UDim.new(0, 6),
											SortOrder = Enum.SortOrder.LayoutOrder,
										}, ScrollingFrame)

										local v111 = fn46("waiting for announcements...", 11, tbl21.sub, gothamMedium, Enum.TextXAlignment.Center, ScrollingFrame)
										v111.Size = UDim2.new(1, 0, 0, v84[198])
										v111.LayoutOrder = 999
										local tbl23 = {}
										local n35 = v84[44]
										fn52 = nil

										local function fn54()
											if flag18 then
												Feed.Position = UDim2.new(0.5, -math.floor(Feed.AbsoluteSize.X / 2), 0.5, -math.floor(Feed.AbsoluteSize.Y / 2))
											else
												if n24 > 9303 then
													while v84[132] do
													end
												end

												local position = Main.Position
												Feed.Position = UDim2.new(position.X.Scale, position.X.Offset - Feed.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
											end

											Feed.Visible = true
										end

										fn53 = function(arg, arg2)
											if n28(v84[138]) >= 2417 then
												if v111 then
													v111:Destroy()
													v111 = nil
												end

												n35 += v84[110]
												v109.Text = n35 .. " caught"

												local Frame5 = fn42("Frame", {
													Size = UDim2.new(1, -4, 0, 0),
													AutomaticSize = Enum.AutomaticSize.Y,
													BackgroundColor3 = tbl21.panel,
													BorderSizePixel = 0,
													LayoutOrder = -n35,
												}, ScrollingFrame)

												fn43(Frame5, 9)
												fn44(Frame5, arg2 and tbl21.acc or tbl21.line, 1, arg2 and 0.3 or 0.5)

												fn42(v84[192], {
													PaddingTop = UDim.new(v84[44], 8),
													PaddingBottom = UDim.new(0, 8),
													PaddingLeft = UDim.new(v84[44], v84[196]),
													PaddingRight = UDim.new(v84[44], 10),
												}, Frame5)

												fn42("UIListLayout", { Padding = UDim.new(v84[44], 5), SortOrder = Enum.SortOrder.LayoutOrder }, Frame5)
												local v112 = fn42(v84[98], { Size = UDim2.new(1, v84[44], 0, v84[112]), BackgroundTransparency = 1, LayoutOrder = 1 }, Frame5)

												fn43(fn42("Frame", {
													Size = UDim2.fromOffset(6, v84[184]),
													Position = UDim2.new(v84[44], v84[44], 0.5, -v84[177]),
													BackgroundColor3 = arg2 and tbl21.acc or tbl21.sub,
													BorderSizePixel = 0,
												}, v112), 3)

												fn46("NOTIFY", v84[23], tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, v112).Position = UDim2.fromOffset(v84[112], 0)
												local sub = tbl21.sub
												local right = Enum.TextXAlignment.Right
												local v113 = fn46(os.date("%H:%M:%S"), 8, sub, gothamMedium, right, v112)
												v113.Size = UDim2.new(v84[44], 60, 1, 0)
												v113.Position = UDim2.new(v84[110], -60, v84[44], 0)
												local v114 = fn46(arg, 10, tbl21.txt, gothamMedium, Enum.TextXAlignment.Left, Frame5)
												v114.Size = UDim2.new(v84[110], 0, 0, v84[44])
												v114.AutomaticSize = Enum.AutomaticSize.Y
												v114.TextWrapped = v84[132]
												v114.LayoutOrder = 2

												if arg2 then
													local Frame6 = fn42("Frame", {
														Size = UDim2.new(1, 0, v84[44], v84[50]),
														BackgroundTransparency = v84[110],
														LayoutOrder = v84[177],
													}, Frame5)

													local TextLabel = fn42("TextLabel", {
														Size = UDim2.new(0.5, -3, 1, 0),
														BackgroundColor3 = tbl21.input,
														Text = arg2,
														Font = gothamBlack,
														TextSize = 12,
														TextColor3 = tbl21.acc,
														BorderSizePixel = 0,
													}, Frame6)

													fn43(TextLabel, 6)
													fn44(TextLabel, tbl21.acc, 1, 0.4)
													local copy = fn48("COPY", Frame6)
													copy.Size = UDim2.new(0.22, -3, 1, 0)
													copy.Position = UDim2.new(0.52, 3, v84[44], v84[44])
													copy.TextSize = 9

													copy.MouseButton1Click:Connect(function()
														copy.Text = fn35(arg2) and "OK" or "ERR"

														task.delay(0.7, function()
															if copy.Parent then
																copy.Text = "COPY"
															end
														end)
													end)

													local v115 = fn49(v84[178], Frame6)
													v115.Size = UDim2.new(0.26, -v84[177], v84[110], 0)
													v115.Position = UDim2.new(0.74, 3, 0, v84[44])
													v115.TextSize = v84[157]

													v115.MouseButton1Click:Connect(function()
														v115.Text = "..."
														fn52(arg2)
														v115.Text = v84[178]
													end)

													if n25 < v84[35] then
														while true do
														end
													end
												end

												table.insert(tbl23, Frame5)

												if #tbl23 > tbl18.maxFeed then
													local v115 = table.remove(tbl23, 1)

													if v115 then
														v115:Destroy()
													end
												end

												return
											end

											while true do
											end
										end

										v110.MouseButton1Click:Connect(function()
											for _, v112 in ipairs(tbl23) do
												v112:Destroy()
											end

											tbl23 = {}
											n35 = 0
											v109.Text = "0 caught"

											if not v111 then
												v111 = fn46(v84[91], 11, tbl21.sub, gothamMedium, Enum.TextXAlignment.Center, ScrollingFrame)
												v111.Size = UDim2.new(1, v84[44], v84[44], 34)
												v111.LayoutOrder = 999
											end
										end)

										v98.MouseButton1Click:Connect(function()
											if Feed.Visible then
												Feed.Visible = false
												return
											end
											fn54()
										end)
									end

									do
										local v109, v110, TextBox2

										do
											do
												local v111
												v109, v111 = fn47(v84[61], v84[179], 178, v84[144])
												v109.Visible = false
												v109.Parent = ScreenGui
												local v112 = fn48("X", v111)
												v112.Size = UDim2.fromOffset(22, v84[97])
												v112.Position = UDim2.new(v84[110], -v84[49], 0.5, -11)
												v112.TextSize = 12

												v112.MouseButton1Click:Connect(function()
													v109.Visible = v84[12]
													if not flag3 then
														return
													end
												end)
											end

											do
												v110 = fn42(v84[98], {
													Size = UDim2.new(1, -24, 1, -58),
													Position = UDim2.fromOffset(v84[112], 50),
													BackgroundTransparency = v84[110],
												}, v109)

												fn42("UIListLayout", {
													Padding = UDim.new(v84[44], v84[23]),
													SortOrder = Enum.SortOrder.LayoutOrder,
												}, v110)

												do
													local Frame5 = fn42("Frame", {
														Size = UDim2.new(1, 0, 0, 54),
														BackgroundColor3 = tbl21.panel,
														BorderSizePixel = 0,
														LayoutOrder = 1,
													}, v110)

													fn43(Frame5, 9)
													fn44(Frame5, tbl21.line, 1, 0.3)
													local message = fn46("MESSAGE", 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, Frame5)
													message.Size = UDim2.new(1, -16, 0, 12)
													message.Position = UDim2.fromOffset(11, v84[184])

													TextBox2 = fn42("TextBox", {
														Size = UDim2.new(1, -18, 0, v84[27]),
														Position = UDim2.fromOffset(9, 20),
														BackgroundColor3 = tbl21.input,
														Text = "",
														PlaceholderText = "type a fake announcement...",
														PlaceholderColor3 = tbl21.sub,
														Font = gothamBlack,
														TextSize = v84[30],
														TextColor3 = tbl21.txt,
														ClearTextOnFocus = false,
														BorderSizePixel = 0,
														TextXAlignment = Enum.TextXAlignment.Left,
													}, Frame5)
												end
											end

											fn43(TextBox2, 7)

											do
												local v111 = fn44(TextBox2, tbl21.line, 1.2, 0.25)

												fn42("UIPadding", {
													PaddingLeft = UDim.new(0, 9),
													PaddingRight = UDim.new(0, 9),
												}, TextBox2)

												TextBox2.Focused:Connect(function()
													fn45(v111, 0.12, { Color = tbl21.acc, Transparency = 0 })
												end)

												TextBox2.FocusLost:Connect(function()
													fn45(v111, 0.12, { Color = tbl21.line, Transparency = 0.25 })
												end)
											end
										end

										local testCode, send

										do
											local v111 = fn42(v84[98], {
												Size = UDim2.new(1, 0, v84[44], 34),
												BackgroundTransparency = v84[110],
												LayoutOrder = 2,
											}, v110)

											testCode = fn48("TEST CODE", v111)
											testCode.Size = UDim2.new(0.4, -4, 1, 0)
											send = fn49("SEND", v111)
										end

										send.Size = UDim2.new(0.6, -v84[153], 1, 0)
										send.Position = UDim2.new(0.4, 4, v84[44], 0)

										do
											local v111 = fn46("", 10, tbl21.sub, gothamMedium, Enum.TextXAlignment.Left, v110)
											v111.Size = UDim2.new(1, -4, v84[44], 14)
											v111.LayoutOrder = 3

											local function fn54(arg)
												local localTest = fn34(arg)

												if localTest == "" then
													v111.Text = "nothing to send"
													v111.TextColor3 = tbl21.err
													return
												end

												if not (v94 and not flag22 and typeof(firesignal) == "function") then
													local ok = pcall(fn30, localTest, v84[19], v84[105], "Top", v84[141])
													v111.Text = ok and "local test: " .. localTest or "handler error"
													v111.TextColor3 = ok and tbl21.ok or tbl21.err
													return
												end

												if n28(v84[70]) <= 1508 then
													local ok = pcall(firesignal, v94.OnClientEvent, localTest, v84[19], v84[105], "Top", 2678001507)
													v111.Text = ok and "fired: " .. localTest or "firesignal failed"
													v111.TextColor3 = ok and tbl21.ok or tbl21.err
													return
												end

												while true do
												end
											end

											send.MouseButton1Click:Connect(function()
												fn54(TextBox2.Text)
												TextBox2.Text = ""
												TextBox2:CaptureFocus()
											end)

											TextBox2.FocusLost:Connect(function(enterPressed)
												if enterPressed then
													fn54(TextBox2.Text)
													TextBox2.Text = ""
													TextBox2:CaptureFocus()
												end
											end)

											testCode.MouseButton1Click:Connect(function()
												if 1569 >= n28(v84[3]) then
													fn54("TESTCODE" .. tostring(math.random(1000, 9999)))
													return
												end

												while true do
												end
											end)
										end

										v97.MouseButton1Click:Connect(function()
											if not flag3 then
												return
											end

											if v109.Visible then
												v109.Visible = v84[12]
												return
											end

											if flag18 then
												v109.Position = UDim2.new(0.5, -math.floor(v109.AbsoluteSize.X / 2), 0.5, -math.floor(v109.AbsoluteSize.Y / 2))
											else
												local position = Main.Position
												v109.Position = UDim2.new(position.X.Scale, position.X.Offset - v109.AbsoluteSize.X - v84[196], position.Y.Scale, position.Y.Offset + Main.AbsoluteSize.Y - v109.AbsoluteSize.Y)
											end

											v109.Visible = true
										end)
									end
								end

								do
									local fn54, fn55, fn56, fn57, fn58, fn59, fn60, fn61, fn62, fn63
									local fn64

									do
										do
											if _G.__AntiRagdollToggleCleanup then
												pcall(_G.__AntiRagdollToggleCleanup)
											end

											tbl22 = {
												Enabled = false,
												Connections = {},
												Welds = {},
												LastPosition = nil,
												JumpPauseUntil = 0,
												JumpPauseDuration = 0.6,
												KnockbackThreshold = 35,
												MaxUpwardVelocity = 60,
												MaxHorizontalVelocity = 12,
												MaxFrameDisplacement = 10,
											}

											do
												local tbl23 = {
													v84[9],
													v84[194],
													"launch",
													v84[122],
													"fall",
													"down",
													"flop",
													v84[149],
													"push",
													"shove",
													"blast",
													"force",
												}

												local tbl24 = {
													"BodyVelocity",
													v84[126],
													"BodyGyro",
													"BodyForce",
													"BodyAngularVelocity",
													v84[183],
													v84[69],
													"LinearVelocity",
													"AngularVelocity",
													v84[143],
													"Torque",
												}

												fn54 = function(arg)
													for _, v109 in ipairs(tbl24) do
														if arg:IsA(v109) then
															return true
														end
													end

													return false
												end

												fn55 = function(arg)
													local str8 = arg:lower()

													for _, v109 in ipairs(tbl23) do
														if str8:find(v109) then
															return true
														end
													end

													return false
												end
											end
										end

										fn56 = function()
											local character = v89.Character

											if character then
												local humanoid = character:FindFirstChildOfClass("Humanoid")
												local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
												local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
												if humanoid and humanoidRootPart and animator then
													return character, humanoid, humanoidRootPart, animator
												end
												return
											end

											if not (n24 >= 9310) then
												return
											end

											while true do
											end
										end

										fn57 = function(arg)
											local jumpPauseUntil = tbl22.JumpPauseUntil
											if tick() < jumpPauseUntil then
												return true
											end

											if arg then
												local state = arg:GetState()
												if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
													return true
												end
											end

											return false
										end

										fn58 = function()
											for _, weld in ipairs(tbl22.Welds) do
												pcall(function()
													weld:Destroy()
												end)
											end

											tbl22.Welds = {}
										end

										fn59 = function(arg, part0)
											if v84[167] >= n28(v84[117]) then
												if not arg or not part0 then
													return
												end
												fn58()

												for _, descendant in ipairs(arg:GetDescendants()) do
													if descendant:IsA("BasePart") and descendant ~= part0 then
														local instance = Instance.new(v84[83])
														instance.Name = v84[182]
														instance.Part0 = part0
														instance.Part1 = descendant
														instance.Parent = part0
														table.insert(tbl22.Welds, instance)
													end
												end
											else
												while v84[132] do
												end
											end

											if n25 <= 9105 then
												while v84[132] do
												end
											end
										end

										fn60 = function(arg, arg2)
											pcall(function()
												arg:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, arg2)
												arg:SetStateEnabled(Enum.HumanoidStateType.Physics, arg2)
												arg:SetStateEnabled(Enum.HumanoidStateType.FallingDown, arg2)
												arg:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, arg2)
											end)
										end

										fn61 = function(arg, arg2)
											if not arg then
												return
											end

											for _, descendant in ipairs(arg:GetDescendants()) do
												if descendant:IsA(v84[56]) or descendant:IsA("HingeConstraint") or descendant:IsA("RopeConstraint") or descendant:IsA("RodConstraint") then
													pcall(function()
														descendant:Destroy()
													end)
												elseif fn54(descendant) then
													local parent = descendant.Parent
													local name = parent and parent.Name or ""

													if parent == arg2 or fn55(descendant.Name) or fn55(name) then
														pcall(function()
															descendant:Destroy()
														end)
													end
												end
											end
										end

										fn62 = function(arg)
											if n27(v84[164]) >= 8043 then
												if not arg then
													return
												end

												for _, descendant in ipairs(arg:GetDescendants()) do
													if descendant:IsA("Motor6D") then
														descendant.Enabled = true
													end
												end
											else
												while v84[132] do
												end
											end
										end

										do
											local function fn65(arg, arg2)
												if not arg then
													return
												end

												for _, descendant in ipairs(arg:GetDescendants()) do
													if descendant:IsA("BasePart") then
														if descendant == arg2 then
															descendant.CanCollide = false
															descendant.Massless = false

															pcall(function()
																descendant.CustomPhysicalProperties = PhysicalProperties.new(v84[14], 0.3, 0.5, 100, v84[2])
															end)
														else
															descendant.CanCollide = false
															descendant.Massless = true
														end
													end
												end
											end

											fn63 = function(arg)
												pcall(function()
													if arg:CanSetNetworkOwnership() then
														arg:SetNetworkOwner(v89)
													end
												end)
											end

											fn64 = function(arg, cameraSubject, arg2)
												if not (not arg or not cameraSubject or cameraSubject.Health <= v84[44]) then
													cameraSubject.PlatformStand = false
													cameraSubject.Sit = false
													cameraSubject.AutoRotate = true
													cameraSubject.BreakJointsOnDeath = false
													cameraSubject.RequiresNeck = false

													if cameraSubject.WalkSpeed < 1 then
														cameraSubject.WalkSpeed = 16
													end

													if cameraSubject.JumpPower < 1 and cameraSubject.JumpHeight < v84[110] then
														cameraSubject.JumpPower = 50
													end

													fn62(arg)
													fn65(arg, arg2)
													local currentCamera = workspace.CurrentCamera

													if currentCamera and currentCamera.CameraSubject ~= cameraSubject then
														if v84[20] >= n28(v84[186]) then
															currentCamera.CameraSubject = cameraSubject
														else
															while true do
															end
														end
													end

													return
												end

												if not (n25 <= 9108) then
													return
												end

												while true do
												end
											end
										end
									end

									local fn65, fn66

									do
										do
											local function fn67(arg)
												local currentCamera = workspace.CurrentCamera
												currentCamera = currentCamera and currentCamera.CFrame.LookVector or arg.CFrame.LookVector
												local vector = Vector3.new(currentCamera.X, v84[44], currentCamera.Z)

												if vector.Magnitude < 0.05 then
													if n26(3241) >= 12323 then
														local lookVector = arg.CFrame.LookVector
														vector = Vector3.new(lookVector.X, 0, lookVector.Z)
													else
														while v84[132] do
														end
													end
												end

												if vector.Magnitude < v84[114] then
													return Vector3.new(0, 0, -v84[110])
												end
												return vector.Unit
											end

											fn65 = function(arg)
												local assemblyLinearVelocity = arg.AssemblyLinearVelocity
												arg.AssemblyAngularVelocity = Vector3.zero
												local z = assemblyLinearVelocity.Z
												arg.AssemblyLinearVelocity = Vector3.new(math.clamp(assemblyLinearVelocity.X, -tbl22.MaxHorizontalVelocity, tbl22.MaxHorizontalVelocity), math.clamp(assemblyLinearVelocity.Y, -50, tbl22.MaxUpwardVelocity), math.clamp(z, -tbl22.MaxHorizontalVelocity, tbl22.MaxHorizontalVelocity))
											end

											fn66 = function(arg, arg2, arg3, arg4)
												if not arg or not arg2 or not arg3 or arg2.Health <= v84[44] then
													return
												end
												fn64(arg, arg2, arg3)
												local v109 = fn67(arg3)

												if not fn57(arg2) then
													fn65(arg3)
												end

												arg3.CFrame = arg3.CFrame:Lerp(CFrame.lookAt(arg3.Position, arg3.Position + v109), arg4 and v84[110] or 0.5)
												arg2.PlatformStand = false
												arg2.Sit = v84[12]
												arg2:ChangeState(Enum.HumanoidStateType.GettingUp)

												task.defer(function()
													if arg2.Parent and arg2.Health > 0 then
														arg2:ChangeState(Enum.HumanoidStateType.Running)
													end
												end)
											end
										end
									end

									do
										local function fn67(arg)
											if not arg then
												return
											end

											for _, v109 in ipairs(arg:GetPlayingAnimationTracks()) do
												if fn55(v109.Animation and v109.Animation.Name or "") then
													v109:Stop(0)
												end
											end
										end

										local function fn68(arg, arg2, arg3, arg4)
											if not arg or not arg2 or arg2.Health <= v84[44] then
												return
											end
											fn61(arg, arg3)
											fn64(arg, arg2, arg3)
											fn67(arg4)
											fn63(arg3)

											pcall(function()
												local playerModule = v89.PlayerScripts:FindFirstChild("PlayerModule")

												if playerModule then
													local controls = require(playerModule):GetControls()

													if controls then
														controls:Enable()
													end
												end
											end)
										end

										tbl22.Disable = function(arg)
											arg.Enabled = false
											arg.LastPosition = nil
											arg.JumpPauseUntil = 0

											for _, connection in ipairs(arg.Connections) do
												pcall(function()
													connection:Disconnect()
												end)
											end

											arg.Connections = {}
											fn58()
											local v109
											v109, v109 = fn56()

											if v109 then
												fn60(v109, true)
											end
										end

										tbl22.Enable = function(arg)
											if arg.Enabled then
												return
											end
											arg.Enabled = true
											local v109, v110, v111, v112 = fn56()
											if not v109 then
												arg.Enabled = false
												return
											end
											fn68(v109, v110, v111, v112)
											fn60(v110, false)
											fn66(v109, v110, v111, true)
											fn59(v109, v111)
											arg.LastPosition = v111.Position

											table.insert(arg.Connections, v86.JumpRequest:Connect(function()
												if not arg.Enabled then
													return
												end
												local jumpPauseDuration = arg.JumpPauseDuration
												arg.JumpPauseUntil = tick() + jumpPauseDuration
											end))

											table.insert(arg.Connections, v86.InputBegan:Connect(function(input, gameProcessed)
												if not arg.Enabled or gameProcessed then
													return
												end

												if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
													if n24 > 9305 then
														while v84[132] do
														end
													end

													if n27(563) < 6025 then
														local jumpPauseDuration = arg.JumpPauseDuration
														arg.JumpPauseUntil = tick() + jumpPauseDuration
													else
														while true do
														end
													end
												end
											end))

											table.insert(arg.Connections, v88.Stepped:Connect(function()
												if not arg.Enabled then
													return
												end
												local v113, v114, v115 = fn56()
												if not v113 or v114.Health <= 0 then
													return
												end

												if not fn57(v114) then
													if n25 > 9132 then
														while true do
														end
													else
														fn65(v115)
													end
												end

												fn63(v115)
											end))

											table.insert(arg.Connections, v88.Heartbeat:Connect(function()
												if not arg.Enabled then
													return
												end
												local v113, v114, v115, v116 = fn56()
												if not v113 or v114.Health <= 0 then
													return
												end
												fn60(v114, false)
												fn64(v113, v114, v115)
												fn61(v113, v115)
												local v117 = fn57(v114)
												local state = v114:GetState()
												local flag23 = state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.Seated
												local flag24 = v115.CFrame.UpVector.Y < 0.85

												if flag23 or flag24 then
													fn66(v113, v114, v115, flag24 and v115.CFrame.UpVector.Y < 0.5)
													if not flag3 then
														return
													end
													fn67(v116)
												end

												if v117 then
													arg.LastPosition = v115.Position
													return
												end

												if arg.LastPosition then
													local n35 = v115.Position - arg.LastPosition
													local vector = Vector3.new(n35.X, 0, n35.Z)

													if arg.MaxFrameDisplacement < vector.Magnitude then
														local n36 = arg.LastPosition + vector.Unit * arg.MaxFrameDisplacement
														v115.CFrame = CFrame.new(n36.X, v115.Position.Y, n36.Z) * (v115.CFrame - v115.Position)
														v115.AssemblyLinearVelocity = Vector3.zero
														v115.AssemblyAngularVelocity = Vector3.zero
													end
												end

												arg.LastPosition = v115.Position

												if arg.KnockbackThreshold < v115.AssemblyLinearVelocity.Magnitude then
													v115.AssemblyLinearVelocity = Vector3.zero
													v115.AssemblyAngularVelocity = Vector3.zero
													fn68(v113, v114, v115, v116)
												else
													fn65(v115)
												end
											end))

											table.insert(arg.Connections, v110.StateChanged:Connect(function(old, new)
												if not arg.Enabled then
													return
												end

												if ({
													[Enum.HumanoidStateType.Ragdoll] = true,
													[Enum.HumanoidStateType.Physics] = v84[132],
													[Enum.HumanoidStateType.FallingDown] = v84[132],
													[Enum.HumanoidStateType.PlatformStanding] = true,
												})[new] then
													v110.PlatformStand = false
													v110.Sit = false
													v110:ChangeState(Enum.HumanoidStateType.GettingUp)
													v110:ChangeState(Enum.HumanoidStateType.Running)
													local v113, v114, v115, v116 = fn56()

													if v113 then
														fn68(v113, v114, v115, v116)
														fn66(v113, v114, v115, true)
													end
												end
											end))

											table.insert(arg.Connections, v109.DescendantAdded:Connect(function(descendant)
												if not arg.Enabled then
													return
												end

												if descendant:IsA(v84[68]) then
													descendant.Enabled = true
													return
												end

												if descendant:IsA("BasePart") then
													task.wait()
													local v113, v114, v115 = fn56()

													if v113 and v115 and descendant ~= v115 and descendant.Parent then
														local weldConstraint = Instance.new("WeldConstraint")
														weldConstraint.Name = "AntiRagdollWeld"
														weldConstraint.Part0 = v115
														weldConstraint.Part1 = descendant
														weldConstraint.Parent = v115
														table.insert(tbl22.Welds, weldConstraint)
													end

													return
												end

												if descendant:IsA(v84[56]) or descendant:IsA("HingeConstraint") or descendant:IsA("RopeConstraint") or descendant:IsA(v84[99]) then
													task.wait()

													pcall(function()
														descendant:Destroy()
													end)

													return
												end

												if fn54(descendant) then
													local v113, v114, v115 = fn56()
													local name = descendant.Parent and descendant.Parent.Name or ""
													local flag23 = descendant.Parent == v115
													local v116 = fn55(descendant.Name) or fn55(name)
													if not flag3 then
														return
													end

													if flag23 or v116 then
														task.wait()

														pcall(function()
															descendant:Destroy()
														end)
													end
												end
											end))

											table.insert(arg.Connections, v109.DescendantRemoving:Connect(function(descendant)
												if not arg.Enabled then
													if n27(786) >= 11141 then
														return
													end

													while v84[132] do
													end
												end

												if descendant:IsA(v84[68]) then
													task.defer(function()
														local character = v89.Character

														if character then
															fn62(character)
														end
													end)
												end

												if n24 > 9296 then
													while v84[132] do
													end
												end
											end))

											table.insert(arg.Connections, v89.CharacterAdded:Connect(function()
												task.wait(1)

												if arg.Enabled then
													arg:Disable()
													arg:Enable()
												end
											end))
										end
									end
								end
							end

							local fn54

							do
								do
									local AntiRagdoll

									do
										do
											do
												local function fn55()
													local ragCountdownBillboard = v90:FindFirstChild("RagCountdownBillboard")

													if ragCountdownBillboard then
														ragCountdownBillboard:Destroy()
													end
												end

												fn55()

												tbl22.Disable = function(arg)
													arg.Enabled = false
													arg.ResetCooldown = 0
													fn55()

													if arg.V2Connection then
														arg.V2Connection:Disconnect()
														if not flag2 then
															return
														end
														arg.V2Connection = nil
													end
												end
											end
										end

										tbl22.Enable = function(arg)
											if arg.V2Connection then
												return
											end
											arg.Enabled = v84[132]
											arg.ResetCooldown = v84[44]

											arg.V2Connection = v88.Heartbeat:Connect(function()
												if not arg.Enabled then
													return
												end
												local character = v89.Character
												if not character then
													return
												end
												local humanoid = character:FindFirstChildOfClass("Humanoid")
												local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
												if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
													return
												end
												local state = humanoid:GetState()
												local now2 = tick()

												if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
													if now2 - arg.ResetCooldown > 0.15 then
														arg.ResetCooldown = now2

														pcall(function()
															humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
															humanoidRootPart.Velocity = Vector3.zero
															humanoidRootPart.RotVelocity = Vector3.zero
															humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
															humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

															for _, descendant in ipairs(character:GetDescendants()) do
																if descendant:IsA("Motor6D") then
																	descendant.Enabled = true
																end

																if descendant:IsA(v84[100]) then
																	descendant.Enabled = true
																end
															end

															workspace.CurrentCamera.CameraSubject = humanoid
															local playerModule = v89.PlayerScripts:FindFirstChild("PlayerModule")
															playerModule = playerModule and playerModule:FindFirstChild("ControlModule")

															if playerModule then
																local module = require(playerModule)

																if module and module.Enable then
																	module:Enable()
																end
															end

															humanoid.AutoRotate = true
															humanoid.PlatformStand = false
															humanoid.Sit = false
														end)
													end
												end
											end)
										end

										_G.__AntiRagdollToggleCleanup = function()
											pcall(function()
												tbl22:Disable()
											end)
										end

										do
											local v109
											AntiRagdoll, v109 = fn47("AntiRagdoll", 260, v84[154], "ANTI RAGDOLL")
											AntiRagdoll.Visible = false
											AntiRagdoll.Parent = ScreenGui
											local v110 = fn48("X", v109)
											v110.Size = UDim2.fromOffset(22, 22)
											v110.Position = UDim2.new(1, -28, 0.5, -11)
											v110.TextSize = 12

											v110.MouseButton1Click:Connect(function()
												if not (n24 >= 9290) then
													AntiRagdoll.Visible = false
													return
												end

												while true do
												end
											end)
										end
									end

									local Frame5, Frame6, v109

									do
										Frame5 = fn42("Frame", {
											Size = UDim2.new(1, -24, v84[110], -58),
											Position = UDim2.fromOffset(12, v84[14]),
											BackgroundTransparency = 1,
										}, AntiRagdoll)

										fn42("UIListLayout", {
											Padding = UDim.new(0, 8),
											SortOrder = Enum.SortOrder.LayoutOrder,
										}, Frame5)

										do
											local Frame7 = fn42("Frame", {
												Size = UDim2.new(1, v84[44], v84[44], 38),
												BackgroundColor3 = tbl21.panel,
												BorderSizePixel = 0,
												LayoutOrder = v84[110],
											}, Frame5)

											fn43(Frame7, 9)
											fn44(Frame7, tbl21.line, 1, 0.3)

											Frame6 = fn42("Frame", {
												Size = UDim2.fromOffset(v84[23], 8),
												Position = UDim2.new(0, 12, 0.5, -4),
												BackgroundColor3 = tbl21.err,
												BorderSizePixel = 0,
											}, Frame7)

											fn43(Frame6, v84[153])
											v109 = fn46(v84[75], 12, tbl21.txt, gothamBold, Enum.TextXAlignment.Left, Frame7)
										end
									end

									local enable

									do
										v109.Size = UDim2.new(1, -32, 1, 0)
										v109.Position = UDim2.fromOffset(28, 0)
										enable = fn49("ENABLE", Frame5)
										enable.Size = UDim2.new(1, 0, 0, v84[176])
										enable.LayoutOrder = v84[88]
										enable.TextColor3 = Color3.fromRGB(0, 0, v84[44])

										do
											local v110 = fn46("rigidifies your character and strips ragdoll forces / states", 10, tbl21.sub, gothamMedium, Enum.TextXAlignment.Left, Frame5)
											v110.Size = UDim2.new(1, 0, v84[44], 30)
											v110.LayoutOrder = 3
											v110.TextWrapped = true
										end
									end

									do
										local function fn55()
											local enabled = tbl22.Enabled
											v109.Text = enabled and "enabled - staying upright" or "disabled"
											v109.TextColor3 = enabled and tbl21.ok or tbl21.sub
											Frame6.BackgroundColor3 = enabled and tbl21.ok or tbl21.err
											enable.Text = enabled and "DISABLE" or "ENABLE"
											Rag.TextColor3 = enabled and tbl21.acc or tbl21.txt
										end

										enable.MouseButton1Click:Connect(function()
											if tbl22.Enabled then
												tbl22:Disable()
											else
												tbl22:Enable()
											end

											fn55()
										end)

										Rag.MouseButton1Click:Connect(function()
											if AntiRagdoll.Visible then
												AntiRagdoll.Visible = false
												if not flag2 then
													return
												end
												return
											end

											if flag18 then
												AntiRagdoll.Position = UDim2.new(v84[55], -math.floor(AntiRagdoll.AbsoluteSize.X / 2), 0.5, -math.floor(AntiRagdoll.AbsoluteSize.Y / 2))
											elseif v84[101] < n27(4015) then
												local position = Main.Position
												AntiRagdoll.Position = UDim2.new(position.X.Scale, position.X.Offset - AntiRagdoll.AbsoluteSize.X - v84[196], position.Y.Scale, position.Y.Offset + 96)
											else
												while v84[132] do
												end
											end

											AntiRagdoll.Visible = true
										end)

										v89.CharacterAdded:Connect(function()
											task.wait(1)
											fn55()
										end)

										fn55()
									end
								end

								do
									local function fn55()
										local tbl23 = { Enabled = v84[12] }
										local tbl24 = {}
										local tbl25 = { animals = nil, game = nil, mutations = nil, traits = nil, tried = false }

										local function fn56(arg, arg2)
											local getupvalue_ = debug and debug.getupvalue or getupvalue
											if not (n24 > 9313) then
												local v109, v110 = getupvalue_(arg, arg2)
												return v110 ~= nil and v110 or v109
											end

											while true do
											end
										end

										local function fn57(arg, arg2)
											for _, v109 in pairs(arg) do
												if type(v109) == "table" and tonumber(rawget(v109, arg2)) ~= nil then
													return true
												end
											end

											return v84[12]
										end

										local function fn58()
											if tbl25.tried then
												return
											end
											tbl25.tried = v84[132]
											local ok, result = pcall(require, v85:FindFirstChild(v84[18]) and v85.Shared:FindFirstChild(v84[160]))

											if ok then
												local v109 = v84[151]
												ok = type(result) == v109
											end

											local value = ok and rawget(result, "GetGeneration") or nil
											if type(value) ~= "function" then
												return
											end

											for i = 1, v84[40] do
												local ok2, game_ = pcall(fn56, value, i)

												if ok2 and type(game_) == "table" then
													local value2 = rawget(game_, "Game")

													if not tbl25.game and type(value2) == "table" and tonumber(rawget(value2, "AnimalGanerationModifier")) then
														tbl25.game = game_
													elseif not tbl25.traits and fn57(game_, "MultiplierModifier") then
														tbl25.traits = game_
													elseif not tbl25.mutations and fn57(game_, "Modifier") then
														tbl25.mutations = game_
													elseif not tbl25.animals and (fn57(game_, "Generation") or fn57(game_, "Price")) then
														tbl25.animals = game_
													end
												end
											end
										end

										local function fn59(arg, arg2, arg3)
											local value = tbl25.animals and rawget(tbl25.animals, arg)
											if type(value) ~= "table" then
												return nil, nil
											end
											local num = tonumber(rawget(value, "Generation"))

											if not num then
												if not flag3 then
													return
												end
												local game_ = tbl25.game

												if game_ then
													game_ = tonumber(rawget(rawget(tbl25.game, "Game") or {}, "AnimalGanerationModifier"))
												end

												game_ = game_ or 0
												num = (tonumber(rawget(value, "Price")) or 0) * game_
											end

											local mutations = arg2 and tbl25.mutations
											local n35 = 1

											if mutations then
												local value2 = rawget(tbl25.mutations, arg2)

												if type(value2) == "table" then
													n35 = 1 + (tonumber(rawget(value2, v84[166])) or 0)
												end
											end

											local traits = type(arg3) == "table" and tbl25.traits
											local flag23 = false

											if traits then
												if not flag3 then
													return
												end

												for _, v109 in ipairs(arg3) do
													if v109 == "Sleepy" then
														flag23 = true
													else
														local value2 = rawget(tbl25.traits, v109)

														if type(value2) == "table" then
															n35 += tonumber(rawget(value2, "MultiplierModifier")) or 0
														end
													end
												end
											end

											local n36 = num * n35
											local n37

											if flag23 then
												n37 = n36 * 0.5
											else
												n37 = n36
											end

											return math.round(n37), value
										end

										local tbl26 = {}

										local function fn60(child)
											if not (n25 < 9095) then
												if child:IsA(v84[17]) and child:GetAttribute("Index") ~= nil then
													tbl26[child] = true
												end

												return
											end

											while true do
											end
										end

										local tbl27 = {}
										local fn61 = nil
										local fn62 = nil

										local function fn63()
											for _, v109 in ipairs(tbl27) do
												pcall(function()
													v109:Disconnect()
												end)
											end

											tbl27 = {}
											tbl26 = {}

											if fn62 then
												pcall(fn62)
											end
										end

										local function fn64()
											if #tbl27 > 0 then
												return
											end
											fn58()

											for _, child in ipairs(workspace:GetChildren()) do
												fn60(child)
											end

											tbl27[#tbl27 + v84[110]] = workspace.ChildAdded:Connect(fn60)

											tbl27[#tbl27 + 1] = workspace.ChildRemoved:Connect(function(child)
												tbl26[child] = nil
											end)

											tbl27[#tbl27 + 1] = v88.Heartbeat:Connect(function(deltaTime)
												if fn61 then
													fn61(deltaTime)
												end
											end)

											if n25 < v84[120] then
												while v84[132] do
												end
											end
										end

										local function fn65(arg)
											local primaryPart = arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
											if not primaryPart then
												return nil
											end
											local v109 = primaryPart:FindFirstChildOfClass(v84[51])
											v109 = v109 and v109:FindFirstChildOfClass(v84[174])
											if v109 and v109.Enabled and v109.ActionText == "Purchase" then
												return v109, primaryPart
											end
											return nil
										end

										local function fn66()
											local character = localPlayer.Character
											character = character and character:FindFirstChild(v84[41])
											if not character then
												return nil, nil, math.huge
											end
											local huge = math.huge
											local v109 = nil
											local v110 = nil

											for k in pairs(tbl26) do
												if k.Parent == workspace then
													local v111, v112 = fn65(k)

													if v111 then
														local magnitude = (character.Position - v112.Position).Magnitude

														if magnitude < huge then
															huge = magnitude
															v109 = k
															v110 = v111
														end
													end
												else
													tbl26[k] = nil
												end
											end

											return v109, v110, huge
										end

										local function fn67(arg)
											local num = tonumber(arg)
											if not num then
												return tostring(arg or "---")
											end
											local n35 = math.abs(num)

											for _, v109 in ipairs({ { v84[121], v84[156] }, { v84[26], "B" }, { 1000000, "M" }, { 1000, "K" } }) do
												if v109[1] <= n35 then
													local n36 = num / v109[1]
													return string.format(n36 >= v84[2] and "%.0f%s" or "%.1f%s", n36, v109[2])
												end
											end

											if num % 1 == 0 then
												return tostring(math.floor(num))
											end
											return string.format("%.1f", num)
										end

										local function fn68(arg)
											if not arg or not arg.Parent or not arg.Enabled then
												return v84[12], "prompt gone"
											end
											local v109 = v84[79]
											if type(fireproximityprompt) == v109 then
												local ok = pcall(fireproximityprompt, arg)
												return ok, ok and nil or "fire failed"
											end

											local ok = pcall(function()
												arg:InputHoldBegin()
												local v110 = v84[114]
												task.wait(math.max(arg.HoldDuration, 0.05) + v110)
												arg:InputHoldEnd()
											end)

											return ok, ok and nil or "hold failed"
										end

										local AutoBuy, v109 = fn47("AutoBuy", 300, 306, "AUTO BUY")
										AutoBuy.Visible = false
										AutoBuy.Parent = ScreenGui
										local v110 = fn48("X", v109)
										v110.Size = UDim2.fromOffset(22, 22)
										v110.Position = UDim2.new(1, -28, 0.5, -v84[133])
										v110.TextSize = 12

										v110.MouseButton1Click:Connect(function()
											AutoBuy.Visible = v84[12]

											if not (v84[31] < n25) then
												if v108 then
													v108()
												end

												return
											end

											while true do
											end
										end)

										local Frame5 = fn42("Frame", {
											Size = UDim2.new(1, -24, 1, -58),
											Position = UDim2.fromOffset(12, 50),
											BackgroundTransparency = 1,
										}, AutoBuy)

										fn42(v84[102], { Padding = UDim.new(v84[44], 6), SortOrder = Enum.SortOrder.LayoutOrder }, Frame5)

										local Frame6 = fn42("Frame", {
											Size = UDim2.new(1, v84[44], 0, 32),
											BackgroundColor3 = tbl21.panel,
											BorderSizePixel = v84[44],
											LayoutOrder = 1,
										}, Frame5)

										fn43(Frame6, 9)
										fn44(Frame6, tbl21.line, 1, 0.3)

										local Frame7 = fn42("Frame", {
											Size = UDim2.fromOffset(8, 8),
											Position = UDim2.new(0, 12, v84[55], -4),
											BackgroundColor3 = tbl21.line,
											BorderSizePixel = 0,
										}, Frame6)

										fn43(Frame7, 4)
										local v111 = fn46(v84[134], 12, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame6)
										v111.Size = UDim2.new(v84[110], -32, 1, 0)
										v111.Position = UDim2.fromOffset(28, 0)
										v111.TextTruncate = Enum.TextTruncate.AtEnd

										local function fn69(text, arg)
											v111.Text = text
											local ok = arg == "ok" and tbl21.ok or arg == "err" and tbl21.err or arg == "busy" and tbl21.acc or arg == v84[108] and tbl21.warn or tbl21.sub
											v111.TextColor3 = ok
											Frame7.BackgroundColor3 = ok
										end

										fn51(Frame5, v84[88], v84[200], v84[12], function(enabled)
											tbl23.Enabled = enabled

											if enabled then
												if n27(1115) > 5659 then
													fn64()
												else
													while true do
													end
												end
											else
												fn63()
											end

											if not enabled then
												if n26(1620) > 5938 then
													fn69("idle", nil)
												else
													while v84[132] do
													end
												end
											else
												fn69("armed - looking for a buy...", "wait")
											end
										end)

										local nearestBuyable = fn46("NEAREST BUYABLE", 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, Frame5)
										nearestBuyable.Size = UDim2.new(1, 0, v84[44], 14)
										nearestBuyable.LayoutOrder = 3

										local function fn70(layoutOrder, arg, arg2, arg3)
											local v112 = fn46(arg, 11, arg2 or tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame5)
											v112.Size = UDim2.new(1, 0, 0, arg3 or 16)
											v112.LayoutOrder = layoutOrder
											v112.TextTruncate = Enum.TextTruncate.AtEnd
											return v112
										end

										local v112 = fn70(4, "Name: ---", tbl21.txt)
										local v113 = fn70(v84[22], "Income: --- /sec", tbl21.acc)
										local v114 = fn70(6, "Rarity: ---")
										local v115 = fn70(7, "Mutation: ---")
										local v116 = fn70(8, "Traits: ---", tbl21.sub, 30)
										v116.TextWrapped = true
										v116.TextYAlignment = Enum.TextYAlignment.Top
										local v117 = fn70(9, "Distance: ---", tbl21.sub, 14)
										v117.TextSize = 9

										fn62 = function()
											v112.Text = "Name: ---"
											v113.Text = "Income: --- /sec"
											v114.Text = "Rarity: ---"
											v115.Text = "Mutation: ---"
											v116.Text = "Traits: ---"
											v117.Text = "Distance: ---"
										end

										local function fn71(arg, arg2, arg3)
											if not (arg and arg2) then
												fn62()
												return
											end
											local attribute = arg:GetAttribute(v84[67])
											local attribute2 = arg:GetAttribute(v84[36])
											local attribute3 = arg:GetAttribute(v84[33])
											local v118 = v84[62]
											local tbl28

											if type(attribute3) == v118 and attribute3 ~= "" then
												tbl28 = { attribute3 }
											else
												tbl28 = attribute3
											end

											local v119, v120 = fn59(attribute, attribute2, tbl28)
											local value = v120 and rawget(v120, v84[63])
											v112.Text = "Name: " .. tostring(v120 and rawget(v120, "DisplayName") or attribute or arg2.ObjectText or "---") .. (value and " ($" .. fn67(value) .. ")" or "")
											v113.Text = "Income: " .. fn67(v119) .. " /sec"
											v114.Text = "Rarity: " .. tostring(v120 and rawget(v120, v84[16]) or "---")
											v115.Text = "Mutation: " .. tostring(attribute2 or "---")
											v116.Text = "Traits: " .. (type(tbl28) == "table" and #tbl28 > 0 and table.concat(tbl28, ", ") or "---")
											v117.Text = string.format("Distance: %.1f studs", arg3)
										end

										local v118 = nil
										local v119 = v84[44]
										local v120 = v84[44]
										local flag23 = false

										fn61 = function(arg)
											if not tbl23.Enabled then
												if flag23 then
													fn62()
													flag23 = false
												end

												return
											end

											v120 += arg
											if v120 < 0.2 then
												return
											end
											v120 = v84[44]
											local v121, v122, v123 = fn66()
											fn71(v121, v122, v123)
											flag23 = v122 ~= nil

											if v122 then
												if v123 > (v122.MaxActivationDistance or 10) + 2 then
													fn69("move closer to buy", "wait")
													return
												end

												if v122 ~= v118 or os.clock() - v119 >= 1.2 then
													local now2 = os.clock()
													v118 = v122
													v119 = now2
													fn69("buying...", "busy")

													task.spawn(function()
														local v124, v125 = fn68(v122)

														if v124 then
															fn69(v84[129], v84[140])
														elseif tbl23.Enabled then
															fn69(v125 or "buy failed", "err")
														end
													end)
												end

												return
											end

											local v124 = v84[78]
											if n28(v84[145]) < v124 then
												fn69("no buy prompt in range", "wait")
												return
											end

											while true do
											end
										end

										fn31 = function()
											if flag18 then
												local v121 = v84[55]
												AutoBuy.Position = UDim2.new(0.5, -math.floor(AutoBuy.AbsoluteSize.X / 2), v121, -math.floor(AutoBuy.AbsoluteSize.Y / 2))
											else
												local position = Main.Position
												AutoBuy.Position = UDim2.new(position.X.Scale, position.X.Offset - AutoBuy.AbsoluteSize.X - v84[196], position.Y.Scale, position.Y.Offset)
											end

											AutoBuy.Visible = true
										end

										fn32 = function()
											tbl23.Enabled = v84[12]
											fn63()

											for _, v121 in ipairs(tbl24) do
												pcall(function()
													v121:Disconnect()
												end)
											end

											tbl24 = {}
										end
									end

									fn55()
								end

								do
									local str8, n35

									do
										str8 = ""
										n35 = 0

										do
											local function fn55(descendant)
												task.defer(function()
													if not descendant.Parent then
														return
													end
													local descendants = descendant:IsA("TextLabel") and { descendant } or descendant:GetDescendants()

													for _, descendant2 in ipairs(descendants) do
														if descendant2:IsA(v84[42]) and descendant2.Text ~= "" then
															local str9 = fn33(descendant2.Text):lower()
															local now2 = os.clock()
															str8 = str9
															n35 = now2
															return
														end
													end
												end)
											end

											local function fn56(arg)
												if not arg then
													return
												end
												arg.DescendantAdded:Connect(fn55)

												for _, descendant in ipairs(arg:GetDescendants()) do
													if descendant:IsA(v84[42]) then
														descendant:GetPropertyChangedSignal("Text"):Connect(function()
															if descendant.Text ~= "" then
																local str9 = fn33(descendant.Text):lower()
																local now2 = os.clock()
																str8 = str9
																n35 = now2
															end
														end)
													end
												end
											end

											fn56(v87:FindFirstChild("Notification"))
											fn56(v87:FindFirstChild(v84[195]))
											fn56(v87:FindFirstChild(v84[169]))
										end
									end

									do
										local tbl23 = {
											"base is full",
											"sold out",
											"out of stock",
											"already redeemed",
											"already used",
											"code redeemed",
											"you have already",
										}

										fn54 = function(arg)
											if n35 <= (arg or 0) then
												return nil
											end

											if os.clock() - n35 > 3 then
												return nil
											end

											for _, v109 in ipairs(tbl23) do
												if str8:find(v109, 1, true) then
													return v109
												end
											end
										end
									end
								end
							end

							local fn55, fn56, fn57, fn58, fn59, fn60, fn61, fn62, fn63, fn64

							do
								do
									fn55 = function(arg, arg2)
										local v109 = fn34(arg)
										if v109 == "" then
											fn50(v84[6], "err")
											return false, v84[12]
										end
										arg2 = arg2 and arg2 .. " " or ""
										fn50(("%sredeeming: %s"):format(arg2, v109), "busy")
										local v110, v111 = fn41(v109)
										local flag23 = v110 and type(v111) == "table"

										if flag23 and (v111.success or v111.Success) and v84[132] then
											fn50(("%sredeemed: %s"):format(arg2, v109), "ok")
										elseif flag23 then
											fn50(("%srejected: %s"):format(arg2, v109), "err")
										elseif v110 then
											fn50(("%ssent: %s"):format(arg2, v109), "busy")
										else
											fn50(("%sfailed to send: %s"):format(arg2, v109), "err")
										end

										return v110, flag23
									end

									fn52 = function(text)
										TextBox.Text = text
										fn55(text)
									end

									do
										local fn65 = nil

										local function fn66(arg)
											local v109 = fn34(arg or "")
											if v109 == "" then
												return v84[12]
											end
											n32 += v84[110]
											local v110, v111 = fn55(v109)

											if v110 and v111 then
												local v112 = v84[140]
												fn50(("spam %d - redeemed: %s"):format(n32, v109), v112)
											elseif v110 then
												fn50(("spam %d - sent: %s"):format(n32, v109), "busy")
											else
												fn50(("spam %d - failed: %s"):format(n32, v109), "err")
											end

											return v110
										end

										fn56 = function(arg)
											if flag21 and flag20 and flag19 then
												fn66(arg)
											end
										end

										local function fn67()
											if not (n25 <= 9086) then
												while flag21 and flag20 do
													if flag19 then
														if n32 == 0 then
															fn50("spam - redeem on every word", "wait")
														end

														task.wait(0.1)
													else
														if fn34(TextBox.Text) == "" then
															fn50("spam - waiting for a code...", v84[108])
														else
															fn66(TextBox.Text)
														end

														task.wait(max)
													end
												end

												if flag21 then
													fn65(false)
												end

												return
											end

											while true do
											end
										end

										fn65 = function(arg)
											if arg and not flag20 then
												fn50("turn LISTEN on first", "err")
												return
											end

											if arg == flag21 then
												return
											end
											flag21 = arg
											start.Text = arg and "STOP" or v84[148]
											start.TextColor3 = arg and tbl21.acc or tbl21.txt
											fn45(v107, 0.16, { BackgroundColor3 = arg and tbl21.acc or tbl21.line })
											fn45(v106, 0.16, { TextColor3 = arg and tbl21.txt or tbl21.sub })
											fn45(v105, 0.16, { Color = arg and tbl21.acc or tbl21.line, Transparency = arg and 0.15 or v84[181] })

											if arg then
												n32 = 0
												thread = task.spawn(fn67)
											else
												thread = nil

												if flag20 then
													if n24 >= 9303 then
														while v84[132] do
														end
													end

													fn50("spam stopped", "wait")
												end
											end
										end

										start.MouseButton1Click:Connect(function()
											fn65(not flag21)
										end)

										redeem.MouseButton1Click:Connect(function()
											redeem.Text = v84[147]
											fn55(TextBox.Text)
											redeem.Text = "REDEEM"
										end)

										TextBox.FocusLost:Connect(function(enterPressed)
											if enterPressed then
												fn55(TextBox.Text)
											end
										end)

										v100.MouseButton1Click:Connect(function()
											local copied = fn34(TextBox.Text)
											if copied == "" then
												fn50("nothing to copy", "err")
												return
											end
											local v109 = fn35(copied)
											fn50(v109 and "copied: " .. copied or "copy failed", v109 and "ok" or "err")
										end)

										clear.MouseButton1Click:Connect(function()
											TextBox.Text = ""
											v93 = nil
											tbl19 = {}
											fn50(flag20 and "listening... (cleared)" or "cleared", flag20 and v84[108] or v84[134])
										end)

										fn57 = function(text)
											v93 = text

											if 9097 > n25 then
												while v84[132] do
												end
											end

											TextBox.Text = text
										end

										fn58 = function()
											if not (not keyboardEnabled or not listenKey) then
												return "press " .. listenKey.Name .. " to fire"
											end

											if not (n24 > 9296) then
												return "tap LISTEN to fire"
											end

											while true do
											end
										end

										fn59 = function()
											if not keyboardEnabled then
												return "idle - tap LISTEN to start"
											end
											return listenKey and "idle - press " .. listenKey.Name .. " to listen" or "idle - no listen key bound"
										end

										fn60 = function(arg)
											flag20 = arg

											if not arg and flag21 then
												fn65(false)
											end

											fn45(Frame2, 0.16, { BackgroundColor3 = arg and tbl21.acc or tbl21.line })
											fn45(Frame3, 0.16, { Position = UDim2.new(0, arg and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
											fn45(listen, 0.16, { TextColor3 = arg and tbl21.txt or tbl21.sub })

											if arg then
												tbl19 = {}

												if v95 and not flag21 then
													if v93 and TextBox.Text == v93 then
														fn57("")
													end

													fn65(true)
												end

												if manual then
													fn50("listening... " .. fn58(), "wait")
												else
													local v109 = v84[108]
													fn50(("listening... 0/%d"):format(n33), v109)
												end
											else
												fn50(fn59(), "idle")
											end
										end
									end
								end

								do
									fn61 = function(arg)
										if autoType then
											fn57(arg)
										end

										if autoRedeem then
											fn55(arg, "[FULL]")
										else
											fn50("captured: " .. arg .. " (auto-redeem off)", "ok")
										end
									end

									fn62 = function(arg)
										local v109 = fn34(arg or "")
										if v109 == "" then
											return
										end
										local now2 = os.clock()

										task.spawn(function()
											for i = v84[110], 3 do
												task.wait(v92)
												local v110 = fn54(now2)

												if v110 then
													local v111 = v84[108]
													fn50(("%s - stopped retrying"):format(v110), v111)
													break
												else
													n32 += 1
													local v111, v112 = fn55(v109, "[FULL]")
													fn50(("confirm %d/%d - %s%s"):format(i, 3, v111 and "sent: " or "retry: ", v109), v111 and v84[140] or "busy")
													if not (v111 and v112) then
														continue
													end
												end

												break
											end
										end)
									end

									do
										local function fn65()
											local str8 = table.concat(tbl19)
											local v109 = flag21
											fn60(false)

											if str8 ~= "" then
												fn61(str8)

												if v109 then
													fn62(str8)

													if n24 > 9295 then
														while v84[132] do
														end
													end

													if not flag3 then
														return
													end
												end
											end
										end

										fn63 = function()
											if flag20 then
												if manual then
													fn65()
												else
													fn60(false)
												end
											else
												fn60(true)
											end
										end
									end
								end

								TextButton.MouseButton1Click:Connect(fn63)

								v101.MouseButton1Click:Connect(function()
									str7 = "listen"
									v101.Text = v84[147]
									v101.TextColor3 = tbl21.warn
								end)

								v102.MouseButton1Click:Connect(function()
									listenKey = nil
									str7 = nil
									v101.Text = "-"
									v101.TextColor3 = tbl21.txt

									if not flag20 then
										fn50(fn59(), "idle")
									end
								end)

								v103.MouseButton1Click:Connect(function()
									str7 = "redeem"
									v103.Text = "..."
									v103.TextColor3 = tbl21.warn
								end)

								v104.MouseButton1Click:Connect(function()
									g = nil
									str7 = nil
									v103.Text = "-"
									v103.TextColor3 = tbl21.txt
								end)

								TextBox:GetPropertyChangedSignal("Text"):Connect(function()
									if flag20 and TextBox.Text ~= v93 then
										tbl19 = {}
									end
								end)

								tbl18.positions = {
									Top = true,
									Bottom = true,
									Center = v84[132],
									Middle = v84[132],
									Left = true,
									Right = true,
									TopRight = true,
									TopLeft = true,
									BottomRight = true,
									BottomLeft = true,
								}

								do
									local function fn65(arg)
										return fn33(tostring(arg or "")):lower():gsub("[^%w]", "")
									end

									local tbl23 = {
										phrases = {
											"code is",
											"use code",
											"font color",
											"fontcolour",
											"fontcolor",
											"font colour",
											"sammy has activated bubblegum machine",
											"sammy activated 2x luck",
											"sammy activated 6x luck",
											"sammy activated 8x luck",
											"sammy activated 10x luck",
											"sammy activated 12x luck",
											"sammy activated 15x luck",
											"sammy activated 20x luck",
											"sammy activated 25x luck",
											"sammy activated 30x luck",
											"sammy activated 35x luck",
											"sammy activated",
											"coins shop",
											"brainrot trader",
											"robux shop",
											"robuxshop",
											"spin wheel",
											"spinwheel",
											"trade plaza",
											"tradeplaza",
											"event has started",
											"eventhasstarted",
											"allowfriends",
											"setcreatorid",
											"to buy this",
											"tobuythis",
											"your base is already locked",
											"your base is full",
											"request failed",
											"you locked your base for",
											"you got a free spin",
											"broke into your base",
											"someone is stealing",
											"trade has been completed",
											"tradehasbeencompleted",
											"event has been activated",
											"has been activated",
											"has activated",
											"base is already locked",
											"you locked your base",
											"you have locked your base",
											"locked your base",
											"brainrot express has arrived",
											"brainrot express has arrv",
											"brainrot express leaving in",
										},
										prefixes = { "sammy:", "spydersammy:" },
										compact = {},
									}

									local tbl24 = {}

									for _, phrase in ipairs(tbl23.phrases) do
										local v109 = fn65(phrase)

										if v109 ~= "" and not tbl24[v109] then
											tbl24[v109] = true
											tbl23.compact[#tbl23.compact + 1] = { phrase = phrase, compact = v109 }
										end
									end

									fn64 = function(arg)
										if not v96 or not flag20 then
											return false
										end
										local str8 = fn33(tostring(arg or "")):lower()
										local str9 = str8:gsub("%s+", "")

										for _, prefixe in ipairs(tbl23.prefixes) do
											if str9:find(prefixe, 1, true) then
												return v84[132], prefixe
											end
										end

										local v109 = fn65(str8)

										for _, v110 in ipairs(tbl23.compact) do
											if v109:find(v110.compact, v84[110], true) then
												return true, v110.phrase
											end
										end

										return false
									end
								end
							end

							do
								do
									local function fn65(...)
										local v109 = table.pack(...)
										if v109.n == 0 or typeof(v109[1]) ~= "string" then
											return v84[12]
										end

										if v96 then
											return v109[4] == "Top"
										end

										for i = 2, v109.n do
											local v110 = v109[i]
											if typeof(v110) == "string" and (v110:find("Sounds%.") or v110:find("rbxassetid") or tbl18.positions[v110]) then
												return true
											end
										end

										return v84[12]
									end

									fn30 = function(...)
										local v109 = table.pack(...)

										if not fn65(...) then
											if n24 >= 9302 then
												while v84[132] do
												end
											end

											return
										end

										local v110 = fn33(tostring(v109[1] or ""))

										if v110 ~= "" then
											if fn64(v110) then
												return
											end

											if _G.__RdmDuo and _G.__RiddlerDuo then
												local v111 = _G.__SabClassifyDrop(v110)

												if v111 == "riddle" then
													_G.__SabDropClaim = { text = v110, kind = "riddle", at = os.clock() }
													fn50("riddle - left to the AI riddler", v84[108])
													fn53(v110, nil)
													return
												end

												if v111 == "code" then
													_G.__SabDropClaim = { text = v110, kind = "code", at = os.clock() }
												end
											end

											local v111 = fn37(v110)
											local v112

											if autoListen and not flag20 then
												v112 = fn38(v110)

												if v112 then
													fn60(true)

													if v112 == "" then
														fn50("trigger heard - waiting for the code...", v84[155])
														fn53(v110, v111)
														return
													end
												else
													v112 = v110
												end
											else
												v112 = v110
											end

											if flag20 then
												for _, v113 in ipairs(fn36(v112)) do
													tbl19[#tbl19 + v84[110]] = v113

													if flag19 and flag21 then
														if manual then
															fn56(table.concat(tbl19))
														else
															local tbl23 = {}

															for i = v84[110], math.min(#tbl19, n33) do
																tbl23[i] = tbl19[i]
															end

															fn56(table.concat(tbl23))
														end
													end
												end

												if manual then
													local str8 = table.concat(tbl19)
													fn57(str8)
													fn40(str8)
													local v113 = v84[108]
													fn50(("listening... %d words - %s"):format(#tbl19, fn58()), v113)
												else
													local v113 = n33
													local tbl23 = {}

													for i = 1, math.min(#tbl19, v113) do
														tbl23[i] = tbl19[i]
													end

													local str8 = table.concat(tbl23)
													fn57(str8)
													fn40(str8)

													if v113 <= #tbl19 then
														local v114 = flag21
														tbl19 = {}
														fn60(false)
														fn61(str8)

														if v114 then
															fn62(str8)
															v111 = str8
														else
															v111 = str8
														end
													else
														fn50(("listening... %d/%d"):format(#tbl19, v113), "wait")
													end
												end
											end

											fn53(v110, v111)
											return
										end

										if n28(311) > 1494 then
											return
										end

										while true do
										end
									end
								end
							end

							if getgenv and getgenv().StopTraced then
								pcall(getgenv().StopTraced)
							end

							do
								local tbl23 = {}
								local v109 = nil
								local n35 = 0

								local function fn65(...)
									local v110 = table.pack(...)
									local str8 = tostring(...)
									local now2 = os.clock()
									if str8 == v109 and now2 - n35 < 0.25 then
										return
									end
									v109 = str8
									n35 = now2
									pcall(fn30, table.unpack(v110, 1, v110.n))
								end

								v94 = fn39()

								if v94 then
									Frame.BackgroundColor3 = tbl21.ok
									Frame4.BackgroundColor3 = tbl21.ok
									tbl23[#tbl23 + 1] = v94.OnClientEvent:Connect(fn65)
								else
									do
										local n36 = 0

										for _, child in ipairs(net:GetChildren()) do
											if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
												n36 += 1
												tbl23[#tbl23 + v84[110]] = child.OnClientEvent:Connect(fn65)
												if not (n36 >= 400) then
													continue
												end
											else
												continue
											end

											break
										end

										tbl23[#tbl23 + v84[110]] = net.ChildAdded:Connect(function(child)
											if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
												tbl23[#tbl23 + 1] = child.OnClientEvent:Connect(fn65)
											end
										end)

										flag22 = n36 > v84[44]
									end

									local warn_ = flag22 and tbl21.warn or tbl21.err
									Frame.BackgroundColor3 = warn_
									Frame4.BackgroundColor3 = warn_
								end

								if flag18 then
									local currentCamera = workspace.CurrentCamera

									local function refit()
										v91 = fn29()

										for _, descendant in ipairs(ScreenGui:GetDescendants()) do
											if descendant:IsA("UIScale") and descendant.Name == "WinScale" then
												descendant.Scale = v91
											end
										end

										Main.Position = UDim2.new(v84[110], -math.floor(316 * v91) - 8, 0.5, -math.floor(n34 * v91 / 2))
									end

									if currentCamera then
										currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit)
									end

									tbl18.refit = refit
									refit()
								end

								v86.InputBegan:Connect(function(input, gameProcessed)
									local userInputType = input.UserInputType

									if not (userInputType == Enum.UserInputType.Keyboard or userInputType == Enum.UserInputType.Gamepad1) then
										if str7 and userInputType == Enum.UserInputType.Touch then
											str7 = nil

											if str7 == "listen" then
												v101.Text = listenKey and listenKey.Name or "-"
												v101.TextColor3 = tbl21.txt
											else
												v103.Text = g and g.Name or "-"
												v103.TextColor3 = tbl21.txt
											end
										end

										return
									end

									if str7 == "listen" then
										str7 = nil

										if input.KeyCode ~= Enum.KeyCode.Escape then
											listenKey = input.KeyCode
										end

										v101.Text = listenKey and listenKey.Name or "-"
										v101.TextColor3 = tbl21.txt

										if not flag20 then
											fn50(fn59(), "idle")
										end

										return
									end

									if str7 == "redeem" then
										str7 = nil

										if input.KeyCode ~= Enum.KeyCode.Escape then
											g = input.KeyCode
										end

										v103.Text = g and g.Name or "-"
										v103.TextColor3 = tbl21.txt
										return
									end

									if gameProcessed then
										return
									end

									if listenKey and input.KeyCode == listenKey then
										fn63()
									end

									if g and input.KeyCode == g then
										fn55(TextBox.Text)
									end
								end)

								if getgenv then
									getgenv().TracedAnnounce = function(...)
										fn30(...)
									end

									getgenv().TracedStatus = function()
										return v99.Text
									end

									getgenv().StopTraced = function()
										flag21 = false
										flag20 = false

										pcall(function()
											tbl22:Disable()
										end)

										if fn32 then
											pcall(fn32)
										end

										for _, v110 in ipairs(tbl23) do
											pcall(function()
												v110:Disconnect()
											end)
										end

										tbl23 = {}

										if ScreenGui then
											ScreenGui:Destroy()
										end
									end

									getgenv().TracedUnblockEvents = function()
										if not flag2 then
											return
										end

										if not tbl20.ready then
											return false, tbl20.why
										end
										return tbl20.Unblock()
									end
								end
							end

							fn60(false)

							if v94 or flag22 then
								fn50(keyboardEnabled and (listenKey and "ready - press " .. listenKey.Name .. " to listen" or "ready - no listen key bound") or "ready - tap LISTEN to start", "idle")
							else
								fn50("notify remote not found", v84[5])
							end

							return
						end
					end

					while true do
					end
				end
			end
		end
	end
end

fn14(100, v3[fn2("n\218\192\176\129w\151\190\193\1756", 21845944094585)], v3[fn2("-\209 \r\161\128\30\181)\162\169\194\240\156\19Ȣs\0212\188p\207(\188\240\176\157\230\2\142\167\11\226\159&\233", 10693721171687)] .. v32(v65), Color3[v3[fn2("\211\207k", 18772801209419)]](1, 0, 0), v3[fn2(" `\4\162\157", 18561267614598)])
