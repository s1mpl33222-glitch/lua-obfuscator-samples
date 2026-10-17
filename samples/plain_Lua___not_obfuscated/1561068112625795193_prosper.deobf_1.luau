-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime1(...)
	error("Luraph runtime function, not devirtualized")
end

local v = table.pack(...)

if not ce_like_loadstring_fn then
	local flag = not l_fastload_enabled or not is_from_loader

	if flag then
		game:GetService("Players").LocalPlayer:Kick("[Luarmor]: Use the loadstring, do not run this directly")
		wait(5)

		while true do
		end
	end
end

local str = "?"
local v2 = ce_like_loadstring_fn
loadstring = v2 or loadstring
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
				local v3 = n4
				local n7 = n2 * n5 + n3
				local n8 = n7 % v3 + n6
				n6 += 1
				n5 = n8
				n3 = n7 % 4858 * v3 % 5782
				return arg2 + n8 % arg3 - arg2 + 1
			end
		end

		local v3 = fn(n - n % 1)
		UserGameSettings:SetTutorialState("nil  nil  ", true)
		local n2 = 0

		for i = 1, 16 do
			local n3 = 0
			local n4 = 1

			for i2 = 1, 5 do
				local flag2 = v3(10, 20) > 15
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
local v3 = ({ table.unpack(v, 1, v.n) })[3]

if v3 and v3[1] then
end

local floor = math.floor
local random = math.random
local remove = table.remove
local char = string.char
local n2 = 0
local n3 = 2
local tbl = {}
local tbl2 = {}

for i = 1, 256 do
	tbl2[i] = i
end

repeat
	local v4 = random(1, #tbl2)
	local v5 = remove(tbl2, v4)
	tbl[v5] = char(v5 - 1)
until #tbl2 == 0

local tbl3 = {}

local function fn()
	if #tbl3 == 0 then
		n2 = (n2 * 149 + 4033097371307) % 35184372088832

		repeat
			n3 = n3 * 37 % 257
		until n3 ~= 1

		local n = n3 % 32
		local n4 = floor(n2 / 2 ^ (13 - (n3 - n) / 32)) % 4294967296 / 2 ^ n
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
local v4 = tbl4

local function fn2(arg, arg2)
	local v5 = tbl4

	if not v5[arg2] then
		tbl3 = {}
		local v6 = tbl
		n2 = arg2 % 35184372088832
		n3 = arg2 % 255 + 2
		v5[arg2] = ""
		local n = 77

		for i = 1, #arg do
			n = (string.byte(arg, i) + fn() + n) % 256
			v5[arg2] = v5[arg2] .. v6[n + 1]
		end
	end

	return arg2
end

local v5 = LUARMOR_SkipAntidebugDevMode
local v6 = LUARMOR_AllowKeyCheckSkip
local flag4 = ff97f23b97f93792992999 and ff97f23b97f93792992999() == v4[fn2("\172", 31126577901884)] or false
local v7 = v4[fn2("6\143K\188=\r\226\146\248&\176;\3\231Æ\133\143\248\204_\184\222\229\157\254\25", 2340828612740)]
local v8 = USE_NON_SSL_NODE
local v9 = l_fastload_enabled
local n4 = os[v4[fn2("(\204\6\168", 4882453074371)]](os[v4[fn2("UC\178}", 12971197083440)]](v4[fn2("\139L", 33012126087192)])) - os[v4[fn2("vܢ\204", 5436520764359)]](os[v4[fn2("f\150\187#", 4318721413046)]](v4[fn2("\209\6D", 24300592814183)]))
local n5

if n4 < 0 then
	n5 = (86400 + -(-n4 % 86400)) % 86400
else
	n5 = n4 % 86400
end

local n6 = n5 / 3600

if n6 >= 21 or n6 < 5 then
	local tbl5 = {}
	local v10 = v4[fn2("\226XO\140q\210K\180:%\205B\254\182.y\229\163\245\219v$\209Y\171\6f", 3448963992716)]
	local v11 = v4[fn2("N\235X\233G\12\243\241ˣ@s\250\190\137\214\t\2267j\174\247\195\241\237\1\160", 16047561292385)]
	tbl5[1] = v10
	tbl5[2] = v11
	v7 = tbl5[math[v4[fn2("\195K\\\173\155:", 14086848885567)]](1, 2)]
elseif n6 >= 5 and n6 < 15 then
	local tbl5 = {}
	local v10 = v4[fn2("\136M\165r\0017j\254\186\147Ds\224x\241\151\231]k\137\28\184\17f,\138\149", 25839311805952)]
	local v11 = v4[fn2("\211:<?S\222\17[!\164Yl\240F\230\"\193\251\128\220a\29\252\133\u{87}\163", 2297877629020)]
	local v12 = v4[fn2("s\146p: \167\177_\228\255\136kW\246\245\253e\146M\245\19T\169IP\21\187", 2572763924828)]
	local v13 = v4[fn2("'\26L\252\146.\25c\151\208\248ϕ\154\r\229I\243\26\149\181\139k`+\16\2", 19333311546965)]
	local v14 = v4[fn2("$\1C\213\234\205?\169\200\"\188@\0\188\128\27C\244\12\203l\224\3p\245\187\233", 21697763200751)]
	local v15 = v4[fn2("\30\197\216\\\25\163\155i\1304i\2af\14\181\15\174MD\174\131\206\208Zã", 15465575462979)]
	local v16 = v4[fn2("\5ڝ_\154\171yf\184\193\138\26T\188\11\16#K\128\144:\7\197m\210\14\252", 30187025133009)]
	local v17 = v4[fn2("\182\186\142\199\t\163\189V 8\195g\230w\148\228\193v\199\\\186\212\246\174\130H\254", 19714501527480)]
	local v18 = v4[fn2("\248~\133\207\196r\178\244G\251 /\n\30\169\154%m\187W\141{\235\246\179\243\240", 7900833455294)]
	local v19 = v4[fn2("*\211\203v\129\12j\218\209A\222\15\186[S\135\165w\1725[tI\n \212\199", 17090196422188)]
	local v20 = v4[fn2("y\193\242QA\127\235\22\"\3\134\159.\0\5\224\130\236\239\27\254.\224\194ż\188", 25925213773392)]
	tbl5[1] = v10
	tbl5[2] = v11
	tbl5[3] = v12
	tbl5[4] = v13
	tbl5[5] = v14
	tbl5[6] = v15
	tbl5[7] = v16
	tbl5[8] = v17
	tbl5[9] = v18
	tbl5[10] = v19
	tbl5[11] = v20
	v7 = tbl5[math[v4[fn2("xԳ\192\182-", 34852575739594)]](1, 11)]
elseif n6 >= 15 and n6 < 21 then
	local tbl5 = {}
	local v10 = v4[fn2("\240\230R\240>\184pcy\16\164\25JH\231\14\235b\3\8\138b\1\249\194\4\255", 13222460338202)]
	local v11 = v4[fn2("\132\141w\195|l\143>'\247n\175\248+\249\226\144<C!*\177\160\233\21\2I", 27390916092837)]
	local v12 = v4[fn2("\rl\1903\128\248l\136-%\192js\153c\179\238b\157\207\209#\200;\238Nt", 14158791783298)]
	tbl5[1] = v10
	tbl5[2] = v11
	tbl5[3] = v12
	v7 = tbl5[math[v4[fn2("\237\238q\243\0025", 446690230688)]](1, 2)]
else
	game:GetService(v4[fn2("\11\19\5\4\2527\137", 10601376556689)])[v4[fn2("6\164p?\177pjs'\184]", 30941888671888)]]:Kick(v4[fn2("XЀ\129\142\231\6\145\130ښz\231[\253\250\28A\140`;m\\\243C\167d_\8뵟\11\24\4̩\172S\rH\235-E\0079\1519lH\149-C3\130)\225\20\162{1\228ܞ", 31900769383437)])
end

pcall(function()
	if game:GetService(v4[fn2("Y4\161\128j\n\206\18\4\2551z\235۾\220\26C\148", 26759536632153)]):GetCountryRegionForPlayerAsync(game:GetService(v4[fn2("A\209q\131\160\177\219", 8137063865754)])[v4[fn2("\255\189\244ˢ\218K\216I\131\254", 24768758536731)]]) == v4[fn2(";%", 6519959328696)] then
		local tbl5 = {}
		local v10 = v4[fn2("l\205hnf\2268}\206\25\1781{\11\1981/\224\8\179\240\27-\r\205#\151", 30974101909678)]
		local v11 = v4[fn2("\n\230\168\228\154T\28\183\22\226r\177\0\0042f+\129\184ʟ\193ͤ\166\128i", 12874557370070)]
		local v12 = v4[fn2("\31\140C\234\224\0128'uqF\230\160\26)\210ߣ\139\172\132w\172\181\245\250\246", 25825352736243)]
		local v13 = v4[fn2("Q\t\222t?\167\240\222K|Jn\228\232[\172OO\133\25\130Ϋ\203\24\190&", 1597776594384)]
		local v14 = v4[fn2("w׆z\184Rػ\135\17w\149\1628\245<t\183\218\"9\180&\154\173oS", 24407970273483)]
		tbl5[1] = v10
		tbl5[2] = v11
		tbl5[3] = v12
		tbl5[4] = v13
		tbl5[5] = v14
		v7 = tbl5[math[v4[fn2("\182\163/Pv\178", 434878710165)]](1, 5)]
	end
end)

local tbl5 = { [v4[fn2("$GBp\229(\220", 25758778711477)]] = v4[fn2("\233\191\12", 22757578724042)] }
tbl5[v4[fn2("\168)[\4", 30887126167645)]] = flag4 and LT_R_RRT_H or v4[fn2("\145\199\235ښ\255A\27", 5940121048476)] .. v7
tbl5[v4[fn2("-\187\163M\25\167\217@", 4026654723750)]] = "d900e5606391ba0ae0b87d74989527a8"
tbl5[v4[fn2("|\153\251\252\129+\213c\238\189\31]\198", 318911054121)]] = "0169"
tbl5[v4[fn2("\255u\7\188", 2453574945005)]] = "Prosperity"

if v8 then
	tbl5[v4[fn2("P+\173\t", 11860914154278)]] = v4[fn2("\190\203\210Z\214\212\25ې\173pԼ\146\25\18\18\16\133\139\193獓ݓ\217", 22440815219107)]
	v7 = v4[fn2("_\12\235cw\2309\u{84}\23,d\224NS\22X\5\19p", 20241724852643)]
end

local flag5 = type(({ table.unpack(v, 1, v.n) })[1]) ~= v4[fn2("\242\19\150\29>", 10561646896748)]
local flag6 = false
local fn3 = nil
local n7 = nil
local tbl6 = nil
local tbl7 = nil
local flag7 = nil
local v10 = nil
local tbl8 = nil
local v11 = print
local v12 = next
local v13 = string[v4[fn2("2\2521\5", 29730670930984)]]
local v14 = identifyexecutor
local v15 = game
local v16 = pcall
local v17 = string[v4[fn2("\159\240\254\230\24\28", 19614640490331)]]
local v18 = debug[v4[fn2(";+\25\153&\188\15\128\26", 12781138980479)]]
local v19 = tonumber
local v20 = setmetatable
local v21 = rawget
local v22 = wait
local v23 = debug[v4[fn2("P\221{\181\235n\227", 23381441762575)]]
local v24 = loadstring
local v25 = os[v4[fn2("X\184mZ", 16176414243545)]]
local v26 = string[v4[fn2("U\235\251\154", 32087606162619)]]
local v27 = string[v4[fn2("\175\1522", 25909107154497)]]
local v28 = spawn
local v29 = game:GetService(v4[fn2("`B\166#\255jI\172]^", 4772928065885)])[v4[fn2("\160\129EكZ\5\18\24", 20189109897586)]]
local v30 = os[v4[fn2(">^S\159\159", 3206290934698)]]
local v31 = rconsoleprint
local v32 = math[v4[fn2("\165A7e", 11417445247369)]]
local v33 = tostring
local v34 = pairs
local v35 = string[v4[fn2("\3\155\250\194", 32580468700806)]]
local v36 = getgenv
local flag8 = false

local function fn4(arg, arg2)
	v24(v4[fn2("i\154\24+|X6!\178ڻ\204ηA\11\7\248<\206\28\245\222c\174\5\23\227\240?Iz\250a4S.\240\147t\199\0065\4\145\11\239\203\2.\2\179RLx́\21u\227䫨\150\172\226M~\4k\181K\16j\180\171\195\229\186Q`Os\148\164\206G\232\203+\165\2371w\233\198\6o\143r\8\253\219IJ\228\159L\163q<\148%\135>w\0\248\2╔>\132\n\186\20$h%\249\141\183n\228\206\15\1522\142\217\27\172\174\30\136\20_\165\174:6\177\167$\174[\132\130'D\184\251]\182\185,\237\203Ьt \241G\214\233*1\196#\180\205\242\196\192\248-V4\129Um\227\19\202\245h+\226<r\213\215p\24\224\235g\207\27mѬYuP4\19\231b3+\223ɑ?ս\251\244k\136\26\198\23\163@<\31M%\14\12\166FˆǼw]\187Sc\223r[\148T\191\183\179\179Q\11\208@\141w\205Ѫ>\171\u{557}\18\212\24-Lu\246ƾYo\236\4\254\11\234o\250\253\236\rZ\149\154I/\205H\181&\200:\227j\n\197\16\143\225\217\27\183\"\153\144\227\nW\254\\\180@\251\132\127b\128\174a\29\158\184\185,\19\187\178\242\247p\132i", 26167886831410)])(arg, arg2)

	while v22() do
	end
end

local tbl9 = {}
local flag9 = false
local v37 = string[v4[fn2("\189[J\156\131h", 30415739121318)]]
local v38 = string[v4[fn2("\1510\206", 13348091965583)]]
local v39 = table[v4[fn2("k\188*TG\222", 11500125891030)]]
local v40 = type
local v41 = v34
local v42 = v22
local v43 = coroutine[v4[fn2("\177߽\215", 9666118886186)]]

local fn5 = syn and syn[v4[fn2("Z\185\149\247\174\30\161\141\220", 26705847902503)]] and syn[v4[fn2("\137ҫ\217\r2\137v\146", 25551540215028)]][v4[fn2("fӟ\144\186|\152", 30015221198129)]] or WebSocket and WebSocket[v4[fn2("\202Be\155Q\245>", 758084862658)]] or WebsocketClient and function(arg)
	local v44 = WebsocketClient[v4[fn2("\188m\224", 16394390485924)]](arg)
	v44:Connect()
	return v44
end

local fn6 = nil

fn6 = function(arg)
	local tbl10 = {}

	for k, v44 in v41(arg) do
		local n = #tbl10 + 1
		local v45 = v4[fn2("'\200\247\146 \170_\227", 34886936526570)]
		local v46 = v4
		local flag10 = v40(v44) == v46[fn2("\20/x-\133", 7497094208326)] and fn6(v44)
		local str2

		if flag10 then
			str2 = flag10
		else
			local v47 = v4
			str2 = v4[fn2("=", 18649317131224)] .. v44 .. v47[fn2("Z", 173951484066)]
		end

		tbl10[n] = v37(v45, k, str2)
	end

	return v4[fn2("i", 24314551883892)] .. v38(v39(tbl10), 0, -2) .. v4[fn2("\194", 22373167419748)]
end

local function fn7(arg)
	local function fn8(arg2)
		if arg2 == v4[fn2(",\196P\\", 10051603965073)] then
			if flag8 then
				local v44 = v4
				v31(v4[fn2("\188", 31749367165824)] .. os[v4[fn2("\0302\18I\236", 28036254623230)]]() .. v44[fn2("]F\213\251\200_\178F\20\156:\132P\20@C\245\5rT\147\137\228\134\r\254\141{\211", 1801793767054)])
			end

			arg[v4[fn2(",\186lJ\254\246p\224", 16202184833777)]] = tick()
			return
		end

		local v44 = v4
		local v45 = string[v4[fn2("\159\11\208\29\209", 9071247761664)]](arg2, v44[fn2("\188\201\31<\247\150\244\169-\6\18", 23326679258332)])

		if flag8 then
			local v46 = v4
			v31(v4[fn2("\7", 33022863833122)] .. os[v4[fn2("\127>\184\15\133", 17304951340788)]]() .. v4[fn2("\1651f.\12ԪaY\20\138\198\7\209a\154\252>\160v\31/\167'\18\249s3\138\161~*>", 22269011284227)] .. arg2 .. v46[fn2(" ", 17028991270387)])
		end

		if v45 then
			local v46 = arg[v4[fn2("Ƣn!\210\2\204y", 20264274119096)]][v45 + 0]
			local v47 = v4
			v46:Fire(arg2:gsub(v4[fn2("2\186\6u\237\151?\157\214\218\26", 16177488018138)], v47[fn2("", 19126073050516)]))
			return v46:Destroy()
		end

		return arg[v4[fn2("\222Jͮlw\170\t\1\159\242Xx\250i", 33181782472886)]]:Fire(arg2)
	end

	local fn9 = nil

	fn9 = function()
		if flag8 then
			local v44 = v4
			v31(v4[fn2("\20", 25372219857997)] .. os[v4[fn2("\31\244\136j\213", 5980924483010)]]() .. v44[fn2("\245\140.:\174\129O1!\183\\", 29455784635176)])
		end

		arg[v4[fn2("\154p\255\171h\15\253<\144\234\187\20\22\154\6", 7238314531413)]] = false

		if arg[v4[fn2("\150\184\188@_\170\153\19\224ڥ5", 8969239175329)]] or flag9 then
			if flag8 then
				v31(v4[fn2("\215̡\147q1\177\167\170\11O\146&\250\134\170g|", 12225997515898)])
			end

			return
		end

		local n = 0
		local v44

		while true do
			if flag8 then
				local v45 = v4
				v31(v4[fn2("\8", 25877967691300)] .. os[v4[fn2("\242\131\241\176\153", 32213237790000)]]() .. v45[fn2("\158\5\232\183M\152\162w\231Y\191\203\31\168H\18Cu\188<\171s\200\226N\20\133\25n\255\209ȴV\192\30ǁv", 28825478949085)])
			end

			local v45 = v25()
			local flag10 = false
			local v46 = nil
			v44 = nil

			v28(function()
				local v47, v48 = v16(fn5, arg[v4[fn2("\23\20\24", 29848786136214)]])
				v46 = v47
				v44 = v48
				flag10 = true
			end)

			while not flag10 and v25() < v45 + 8 do
				v42()
			end

			if flag8 then
				local v47 = v4
				v31(v4[fn2("\128", 29034864994720)] .. os[v4[fn2("\175\nP\245\156", 12251768106130)]]() .. v4[fn2("z\24ث\148\2523\254\223\1\222Q\227{\241\197\249\\\11_h\181", 34490713701753)] .. v33(flag10) .. v4[fn2("\127\132\31\28g\n", 10375883892159)] .. v33(v46) .. v47[fn2("\12", 27328637166443)])
			end

			if not flag10 then
				flag6 = false
				n = 10

				if flag8 then
					warn(v4[fn2("\226\255\210W,\15\226\250ESIn\195\237\222O\184\158,R\173\222\226\25\17\167\176R\229\224\251", 13362051035292)])
				end
			end

			if not v46 then
				n += 1

				if n > 5 then
					flag6 = false
				end

				v42(n < 4 and 10 or 120)
				continue
			end

			break
		end

		if flag8 then
			local v45 = v4
			v31(v4[fn2("\194", 33361102829917)] .. os[v4[fn2("nG\178p\189", 1458185897294)]]() .. v45[fn2("\148\235A|\17\230\0113\2209x\22|\149\178\167\141\242\182\164\19x\130\238", 2558804855119)])
		end

		arg[v4[fn2("\204*c\136֯\156\235c\228#\163\143\18\204", 14980229346943)]] = true
		arg[v4[fn2("\196\28p0\225\186\219]\246", 13544592716102)]] = v44
		flag6 = arg
		local v45 = v4

		v44:Send(fn6({
			[v4[fn2("\144\157\26\202J\143", 30815183269914)]] = v45[fn2("\158\177\19U", 18578448008086)],
			[v4[fn2("\222U\224\t", 256632127727)]] = {},
		}))

		v16(function()
			v44[v4[fn2("k(\166.\2433M", 11661192079980)]]:Connect(fn9)
			v44[v4[fn2("\15\210\249~|\227\202\248q", 12796171824781)]]:Connect(fn8)
		end)

		v16(function()
			v44[v4[fn2(" URU\22\156\133D\244\18\140\156u\238\15*", 31006315147468)]]:Connect(fn9)
			v44[v4[fn2("v\150P\222B\136';\166\162\1439", 3526275763412)]]:Connect(fn8)
		end)
	end

	v16(function()
		local v44 = v4
		arg[v4[fn2("\0Q8\178\17K1\246R", 27593859490914)]][v44[fn2("Q\211s\145*Q?", 8519327620862)]]:Connect(fn9)
		local v45 = v4
		arg[v4[fn2("\197,r \183r\1669N", 8460270018247)]][v45[fn2("Ó@Qd\143\153|\223", 32507452028482)]]:Connect(fn8)
	end)

	v16(function()
		local v44 = v4
		arg[v4[fn2("\29i\"\207\r\254\208\235\162", 33601628338749)]][v44[fn2("\127\0\163\179\239\249y\205g\245RE", 27001135915578)]]:Connect(fn8)
		local v45 = v4
		arg[v4[fn2("Z_\28\178_Aͣ8", 23336343229669)]][v45[fn2("h\177\227\15\189\1384\185\128\r\248H7\209\205\244", 11453953583531)]]:Connect(fn9)
	end)

	arg[v4[fn2("U0\18973y\172\177", 26105607905016)]] = tick()

	while v42(10) do
		if flag8 then
			local v44 = v4
			v31(v4[fn2("\145", 14951237432932)] .. os[v4[fn2("\2286\234N\229", 22975554966421)]]() .. v44[fn2("ח\31]\186]\218A}\226[{\251\17t\146էړg\20\toć:\170", 14658096969043)])
		end

		if arg[v4[fn2("\200tK\173\215\207e8\175\212\11Or\171\158", 15693215676695)]] then
			local v44 = v4

			arg[v4[fn2("t\168\177Eņ\218\30\232", 31886810313728)]]:Send(fn6({
				[v4[fn2("+\30H\139\251Z", 29989450607897)]] = v44[fn2("\234\23\201\8", 21721386241797)],
				[v4[fn2("\227o\137\144", 9220502430091)]] = {},
			}))

			if tick() - arg[v4[fn2("\161\183W҉G\174\t", 26743430013258)]] > 20 then
				if flag8 then
					local v45 = v4
					v31(v4[fn2("=", 25162833812362)] .. os[v4[fn2("\2501\245\132\"", 26944225862149)]]() .. v45[fn2("\240\161\251\171\150\228~\247ֶ\166T\188\2\n\31\4\nlA!\3P\242", 20296487356886)])
					warn(v4[fn2("\222\6\189\254ChVJX'\161Kl\129", 21935067385804)])
				end

				arg[v4[fn2("\156\156&\216d,<\149*", 15423698253852)]]:Close()
			end
		end
	end
end

tbl9.new = function(arg, arg2)
	local tbl10 = {}
	v20(tbl10, arg)
	arg[v4[fn2("\227t\243=\230\148\11", 15742609307973)]] = arg
	local v44 = v25()
	local flag10 = false
	local v45 = nil
	local v46 = nil

	v28(function()
		local v47, v48 = v16(fn5, arg2)
		v45 = v47
		v46 = v48
		flag10 = true
	end)

	while not flag10 and v25() < v44 + 8 do
		v42()
	end

	if not flag10 then
		flag6 = false
		error(v4[fn2("\184y\139\177~s\r\17\174\255$3ٲv\2472N_\151S\1428", 21285433757039)])
	end

	assert(v45, v46)
	arg[v4[fn2("\232\nl\8\221\198\244\158\162", 15444099971119)]] = v46
	arg[v4[fn2("\212\216b", 32886494459811)]] = arg2
	local v47 = v4
	arg[v4[fn2("\154\254+\5n)\173\161d\163\227\187\2262\186", 7107314031067)]] = Instance[v4[fn2("f̜", 13855987348072)]](v47[fn2("\12\2423\140\203\204q\2223\23\184\t\169", 19879862814802)])
	local v48 = v4
	arg[v4[fn2("\246M\198tb߸\2464", 4490525347926)]] = arg[v4[fn2(">RVz5\150\2A\180;\184ķ\181\202", 26856176345523)]][v48[fn2(">4z\139p", 25648179928398)]]
	arg[v4[fn2("sfê\t\245<\19", 6486672316313)]] = {}
	arg[v4[fn2("U\245\146]\170\143@8N@#\176\212\228\178", 12321563454675)]] = true
	v43(fn7)(arg)

	repeat
		v29:Wait()
	until arg[v4[fn2("\174\181j@\3-\232\22", 34774190194305)]]

	return tbl10
end

tbl9.request = function(arg, arg2)
	if flag8 then
		local v44 = v4
		v31(v4[fn2("v", 34172876422225)] .. os[v4[fn2("\1532\200F\140", 32307729954184)]]() .. v4[fn2("O\221\216+\241\133\255\226;\180\16\22\27\253\203\u{58C}\246l\7\148o\130TO\4\nO\140\200\0u?\140u\183\132J\245hS\144\30<\219\3", 4505558192228)] .. v33(arg[v4[fn2("\239調\168\155^Q\134(\151\189m\150\196", 22259347312890)]]) .. v44[fn2("\200", 12545982344612)])
	end

	local n = 0

	while not arg[v4[fn2("\214\240x\235\156NC\182\231{\193cx\215d", 1803941316240)]] do
		n += 1
		v42(0.1)
		if not (n > 40) then
			continue
		end

		if flag8 then
			warn(v4[fn2("\1950\131r\170\212EȪ\218Bil", 4536697655425)])
		end

		flag6 = false
		return v4[fn2("", 22063920336964)]
	end

	if flag8 then
		local v44 = v4
		v31(v4[fn2("Y", 27805393085735)] .. os[v4[fn2("\207\199us@", 9663971337000)]]() .. v44[fn2("bp\228\206D\24\1659\145\143\129bc\145\235\171\\\3\127[\2340x\247[\199GvH\160Q\147?\225̣w\tC", 19677993191318)])
	end

	local v44 = math[v4[fn2("\158\226\202\\\232\159", 458501751211)]](1, 99999999)
	local v45 = v4
	local v46 = Instance[v4[fn2("J\3\167", 23438351816004)]](v45[fn2("\203%q\241\205e\171\179\26\144\200.v", 12404244098336)])

	if flag8 then
		local v47 = v4
		v31(v4[fn2("o", 27769958524166)] .. os[v4[fn2(">\238W\231\186", 6757263513749)]]() .. v47[fn2("\221O\190w\196!\176\224\7\187#ʮgm\217c", 26137821142806)])
	end

	arg[v4[fn2("\227\197\200eba\232\t", 21769706098482)]][v44] = v46
	local v47 = v4

	arg[v4[fn2("\178\18Q\147\250:[\134\176", 17162139319919)]]:Send(fn6({
		[v4[fn2("~\148\234\238Ɗ", 22738250781368)]] = v47[fn2("\142YQϺ\16\149", 21390663667153)],
		[v4[fn2("s\182\11\31", 24974923258587)]] = arg2,
		[v4[fn2("\183\1", 1700858955312)]] = v44,
	}))

	if flag8 then
		local v48 = v4
		v31(v4[fn2("\215", 27636810474634)] .. os[v4[fn2("-O0\128\243", 26764905505118)]]() .. v48[fn2("\229\171\27\129\190\143\178\29\245<<\251}yL", 15506378897513)])
	end

	local flag10 = false

	v28(function()
		v42(30)

		if not flag10 then
			if flag8 then
				local v48 = v4
				v31(v4[fn2("\178", 20659423169320)] .. os[v4[fn2("͗q;\138", 2741346535929)]]() .. v48[fn2("\195wkZ\144wȺ\168\1644\255\201\252U=\131\243\6\174KR!\250\179?ä\203\200\249\131\225<=c\8\216H\2452C\236\245\5\156", 29761810394181)])
			end

			local v48 = arg[v4[fn2("į\140R\1966\251\147", 8061899644244)]][v44]
			v48:Fire(v4[fn2("", 10378031441345)])

			if flag8 then
				local v49 = v4
				v31(v4[fn2("\19", 4223155474269)] .. os[v4[fn2("\138J\234w\251", 2422435481808)]]() .. v49[fn2("\220\225Ȣ\212/\159\152\17\130\1\192\160\175\215+\170\142-\222\01938\151\237#G\250s}\166a\1", 34310319570129)])
			end

			return v48:Destroy()
		end
	end)

	local v48 = v46[v4[fn2("6y\14\152\246", 14892179830317)]]
	flag10 = true
	return (v48:Wait())
end

tbl9.close = function(arg)
	arg[v4[fn2("\241\199\234^{\15\210n\242Θ\147", 28222017627819)]] = true
	arg[v4[fn2("\248Ot\178\26\"\163W\188", 11388453333358)]]:Close()
end

local v44 = script_key or v4[fn2("O8\150\147", 28215574980261)]
local n8 = 0
local flag10 = false

v28(function()
	flag10 = true

	while not flag7 do
		n8 += 1
		v29:Wait()
	end
end)

while not flag10 do
	v29:Wait()
end

local function fn8()
	local v45 = n8

	while n8 == v45 do
		v29:Wait()
	end
end

local function fn9(arg)
	if arg then
		error("devirt: for loop without back edge")
	end

	while v22() do
	end
end

local function fn10(arg)
	for i = 1, 2 do
		local n = arg % 9915 + 4
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

		local n11 = arg % 9999995 + 1 + 16038
		local n12 = arg % 1000
		local n13 = fn3((arg - n12) / 1000) % 1000
		local n14 = arg % (n * n9 + 9999) + 16038
		arg = (n12 * n13 + n11 + arg % (419824125 - n11 + n12) + (n14 + n12 * n9 + n13) % 999999 * (n11 + n14 % n10)) % 99999999999
	end

	return arg
end

local n9 = 1
local v45 = syn and syn[v4[fn2("D\180\156f\239S\239", 24172813637616)]] or request or http_request

if v14 and ({ v14() })[1] == v4[fn2("\25\247}t\225\1\187", 7949153311979)] then
	n9 = 9
elseif v14 and ({ v14() })[1] == v4[fn2("\144\144T\182[\138\11\21\232z", 2290361206869)] then
	if ({ v14() })[2] == v4[fn2("@I\129", 19850870900791)] then
		n9 = 5
	else
		n9 = 2
	end
elseif FLUXUS_LOADED or EVON_LOADED or WRD_LOADED or COMET_LOADED or OZONE_LOADED or TRIGON_LOADED then
	n9 = 4
elseif KRNL_LOADED then
	n9 = 3
elseif Electron_Loaded then
	n9 = 6
elseif v14 and ({ v14() })[1] == v4[fn2("\171\192\220JXȜ", 12815499767455)] then
	n9 = 7
elseif v14 and ({ v14() })[1] == v4[fn2("\169\192C<\132\166", 18670792623084)] then
	n9 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("\229\232Z}%\134\210K`", 16058299038315)] then
	n9 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("v\191", 18668645073898)] then
	n9 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("\138\203G|", 30760420765671)] then
	n9 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("y\142\4\231\253", 9953890477110)] then
	n9 = 11
elseif v14 and ({ v14() })[1] == v4[fn2("h\16\196\"\236", 28973659842919)] then
	n9 = 15
end

if v14() == v4[fn2("\236<\200I", 5129421230761)] then
	n9 = 11
end

local function fn11(arg, arg2)
	tbl7 = {}
	tbl6 = {}

	for i = 0, arg do
		local v46 = v13(i)
		tbl6[i] = v46
		tbl6[v46] = i
	end

	for i = 1, #arg2 do
		local v46 = arg2[i]
		tbl7[i - 1] = v46
		tbl7[v46] = i - 1
	end
end

local tbl10 = {}
local v46 = v4[fn2("?", 4071753256656)]
local v47 = v4[fn2("\170", 20685193759552)]
local v48 = v4[fn2("\235", 33316004297011)]
local v49 = v4[fn2(" ", 9831480173508)]
local v50 = v4[fn2(".", 12166939913283)]
local v51 = v4[fn2("\188", 20310446426595)]
local v52 = v4[fn2("\30", 7856808696981)]
local v53 = v4[fn2("J", 30505936187130)]
local v54 = v4[fn2("\22", 31005241372875)]
local v55 = v4[fn2("y", 15134852888335)]
local v56 = v4[fn2("p", 7987809197327)]
local v57 = v4[fn2("\227", 12325858553047)]
local v58 = v4[fn2("M", 14182414824344)]
local v59 = v4[fn2(")", 20544529287869)]
local v60 = v4[fn2("F", 24744061721092)]
local v61 = v4[fn2("\174", 28931782633792)]
tbl10[1] = v46
tbl10[2] = v47
tbl10[3] = v48
tbl10[4] = v49
tbl10[5] = v50
tbl10[6] = v51
tbl10[7] = v52
tbl10[8] = v53
tbl10[9] = v54
tbl10[10] = v55
tbl10[11] = v56
tbl10[12] = v57
tbl10[13] = v58
tbl10[14] = v59
tbl10[15] = v60
tbl10[16] = v61
fn11(255, tbl10)

fn3 = function(arg)
	return arg - arg % 1
end

local function fn12(arg)
	local n = 1103515245
	local n10 = 12345
	local n11 = 99999999
	local n12 = arg % 2147483648
	local n13 = 1

	return function(arg2, arg3)
		local v62 = n11
		local n14 = n * n12 + n10
		local n15 = n14 % v62 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v62 % 5781
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local function fn13(arg)
	for i = 1, 2 do
		local n = arg % 9915 + 4
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

		local n12 = arg % 9999995 + 1 + 16038
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n * n10 + 9999) + 16038
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

	local v62 = nil
	local n = 0
	local n10 = 0
	local n11 = 0

	for k, v63 in v12, tbl11, v62 do
		local v64 = tbl12[v63]

		if tbl13[k] == v63 then
			n += 1
		end

		n10 += 1
		n11 = n10 % 2 == 0 and n11 * v64 or n11 + v64 + n10
	end

	if n ~= 13 then
		n7 = -1
	end

	tbl8 = { tbl11, tbl12, tbl13 }
	n7 = n11
	return false
end

local function fn16(arg)
	for i = 1, 2 do
		local n = arg % 9915 + 4
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

		local n12 = arg % 9999995 + 1 + 16038
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n * n10 + 9999) + 16038
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
	end

	return arg
end

local function fn17(arg)
	for i = 1, 2 do
		local n = arg % 9915 + 4
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

		local n12 = arg % 9999995 + 1 + 16038
		local n13 = arg % 1000
		local n14 = fn3((arg - n13) / 1000) % 1000
		local n15 = arg % (n * n10 + 9999) + 16038
		arg = (n13 * n14 + n12 + arg % (419824125 - n12 + n13) + (n15 + n13 * n10 + n14) % 999999 * (n12 + n15 % n11)) % 99999999999
	end

	return arg
end

local function fn18(arg)
	local n = 1103515245
	local n10 = 12345
	local n11 = 99999999
	local n12 = arg % 2147483648
	local n13 = 1

	return function(arg2, arg3)
		local v62 = n11
		local n14 = n * n12 + n10
		local n15 = n14 % v62 + n13
		n13 += 1
		n12 = n15
		n10 = n14 % 4859 * v62 % 5781
		return arg2 + n15 % arg3 - arg2 + 1
	end
end

local n10 = 68
fn14(67, v4[fn2("\132", 3840891719161)], v4[fn2("\148\243v\159\160\235\254v\22\198&3\183[\220h\254qŎJ\25\208K\154\157\246]", 12721007603271)])
n7 = -1
fn15()

while n7 == -1 do
end

local v62 = fn18(n8 + n7)

if n9 == 9 or n9 == 15 then
	local n = 0

	v16(function()
		local function fn19(arg)
			v33(arg[1])
		end

		fn19(v20({}, { [v4[fn2("\216K\237\155\22XS", 643190981207)]] = function()
			local fn20 = nil

			fn20 = function()
				n += 1
				return fn20()
			end

			fn20()
		end }))
	end)

	local n11 = 0

	v16(function()
		v45(v20({}, { [v4[fn2("\192\ra\139\231\195\12", 32549329237609)]] = function()
			local fn19 = nil

			fn19 = function()
				n11 += 1
				return fn19()
			end

			fn19()
		end }))
	end)

	if n11 + n < 20000 then
		n10 = 19
	elseif n11 - n ~= 0 then
		n10 = 189
	end
end

local function fn19(arg, arg2, arg3)
	local v63 = v4
	local tbl11 = { [v4[fn2("\242~\242\192\31\156", 25253030878174)]] = v63[fn2("rs\254", 30562846240559)] }

	if arg2 then
		tbl11 = v20(tbl11, { [v4[fn2("\216\21m\142\201m\185", 4427172646939)]] = function(arg4, arg5)
			if arg5 == v4[fn2("6c\17", 29393505708782)] then
				local v64 = v4
				local v65 = v17(v18(), v64[fn2("\1639\5\144\26ǈu&/\184", 32746903762721)])
				local v66 = v65()
				local v67 = v65()
				local n = 1

				v16(function()
					n = v19(v67) - v19(v66)
				end)

				if (n9 == 9 or n9 == 15) and (n ~= 0 or v66 ~= v67) then
					n10 = 121

					while arg3 do
					end
				end

				return arg
			end

			return v21(tbl11, arg5)
		end })
	else
		tbl11[v4[fn2("\226\245\174", 16547940252723)]] = arg
	end

	local v64 = v45(tbl11)

	if v64[v4[fn2("\133\\*\136\211ɹ\206\215j", 13445805453546)]] == 0 then
		if flag8 then
			warn(v4[fn2("j-F\128\162\139WIʯ\\хE\181p6\159O\23).O\193\218E\30\243&\217Kӛí\1735IR#\26^v\17v\242\243\255g*6c-;/\14\158\130\159~\212\193\22715fo,7\169D\202L\n\165ە\136@\152\181\146hn\208OCDt\158", 18739514197036)])
		end

		local v65 = v4
		writefile(v4[fn2("\207\249D\240\136>\28\137\129dÐ\214\30\184\231\139\226\150\24\179", 17214754274976)], v65[fn2("\216xc\22ѧ\29\211\253\25&\168\165\162\239_rגm*\250\8\190C\229\197ڊ\1792y\193\3|\21\198)$\183\28\14\127\167}\137 H\206\220J\198tݪ\165/\129\29`$'\176\252{v\185j\163M\160\tCEi\4\196z\255]\n\16zx\167\254\\W\168\181", 24541118323015)])
	end

	return v64[v4[fn2("2\224o\143", 15183172745020)]], v64[v4[fn2("\235\144\243\23326\138", 30737871499218)]]
end

fn8()

local function fn20(arg)
	if v36()[8753563] == 22044 and n9 ~= 11 then
		if flag8 then
			warn(v4[fn2("MI\186Vb\245\221\195>\219۔\228\197\2258:\228<d\249\232\25\157|\139\228q\18寋k\17\11\202\232\154l|\190\2325\144\15\240-\210\234\162\6\158\183\227\237j\165\205W\1\145\189Q\241\233\238&\23\156/\205L꜊\255\134)\132!\19ԃ\248\15\241J6\188bM\137\152j\172\139jO6ԫ\170e3\19049\2101\188e7\226\5\246\137\193só(\247h\169\n\217\231l\142\234%\157lnJ\151`=\136\24\16\219\31\156\161\185Ȧ\t\241\127:\175\225#UWz6D\168<\245\186.ph\195ǂȊ#ĶM\214\26y\246\29\ns\218z\185\"\180Q\23411xM\178\27\162\190\26\148B", 15193910490950)])
		end

		v28(function()
			v22(5)
			v36()[8753563] = nil
		end)

		fn9()
	end

	v36()[8753563] = 22044
	local flag11 = false
	local tbl11 = { v23, v20, v33 }

	tbl11[-1] = n9 == 3 and function()
	end or v45

	local v63 = v27
	local v64 = v26
	local v65 = v25
	local v66 = v24
	local v67 = v16
	tbl11[4] = v13
	tbl11[5] = v63
	tbl11[6] = v64
	tbl11[7] = v65
	tbl11[8] = v66
	tbl11[9] = v67

	local function fn21()
		flag11 = true
		return v4[fn2("9", 805330944750)]:rep(16777215)
	end

	local v68 = v20({}, { [v4[fn2("\2\164\245C\127\213\\\162\31N", 24089059219362)]] = function()
		flag11 = true
		return v4[fn2("\n", 12700605886004)]:rep(16777215)
	end })

	for k, v69 in v12, tbl11, nil do
		if k ~= -1 then
			local flag12 = n9 ~= 11

			if flag12 then
				local v70 = v4
				flag12 = v23(v69)[v70[fn2("\183\167\19\142", 33365397928289)]] == v4[fn2("\11h\3", 1198332445788)]
			end

			if flag12 then
				flag11 = true
			end
		end

		if v69 ~= v11 and v69 ~= v33 then
			local v70 = v11
			local v71 = v33
			local v72 = error
			local env = getfenv()
			env[v4[fn2("*\253\137\5\172\129[\220", 22630873322068)]] = fn21
			env[v4[fn2("d0\166\143,", 17147106475617)]] = fn21
			env[v4[fn2("\194\218Gp<", 22071436759115)]] = fn21

			if k == -1 then
				if n9 ~= 5 then
					v16(v69, v4[fn2("", 22141232107660)])
				end
			else
				v16(v69, v68)
			end

			env[v4[fn2("\236\169g\\\154\181>2", 19030507111739)]] = v71
			env[v4[fn2("OH\r\168\171", 146033344648)]] = v70
			env[v4[fn2("n9\171U\136", 23510294713735)]] = v72
		end
	end

	if flag11 and n9 ~= 11 then
		n10 = 85

		if arg then
			fn9(true)
		end
	end

	v36()[8753563] = nil
end

local v63 = n8
local v64 = nil
local flag11 = nil
local v65, tbl11, tbl12, tbl13, tbl14, v66, tbl15, tbl16, tbl17

while true do
	local v67 = v16(function()
		local v67 = fn19
		local v68 = v4
		v64 = v67(tbl5[v4[fn2("vx\194#", 12421424491824)]] .. v68[fn2("[O\242\0037\14\186", 5635169064064)], n9 == 9 or n9 == 15)
		local data = v15:GetService(v4[fn2("\14\162\t\231\29\182*\207)\183p", 24734397749755)]):JSONDecode(v64)

		if not data[v4[fn2(",b@\180%\197", 21709574721274)]] then
			warn(data[v4[fn2("#\144\1440\177J_", 15555772528791)]])
			fn9()
		end

		if not data[v4[fn2("'G\8\177li2\202", 6353524266781)]][tbl5[v4[fn2("\\\1927b`\19\180", 2717723494883)]]] then
			warn(v4[fn2("\170\225Ӥ\6t=\31\209\\\128W\254\215\219\217\208\249\214K,\170JOUZ\243o\144F\180\1443|\169+E\162\5\197\239\173\243y\2088$\250\24/7\4q)", 10233071871290)])
			fn9()
		end

		local v69 = tbl5
		local v70 = v4[fn2("M<\173\140", 25338932845614)]
		local v71 = flag4 and LT_R_RRT_H
		local v72

		if v71 then
			v72 = v71
		else
			local v73 = v8

			if v8 then
				v72 = v4[fn2("U՜\142s`Q\20;\18\198p\167-\154\139]\156\225\206\u{F45E}\2072:\0", 13360977260699)]
			else
				v72 = v73
			end
		end

		v69[v70] = v72 or v4[fn2("\194\219Κ\2251\176\229", 20587480271589)] .. v7
		local v73 = tbl5
		local v74 = v4
		v10 = data[v4[fn2("\147\208\226r\29\14\12\29", 29417128749828)]][v73[v74[fn2("\234]\254\157\27yP", 25466712022181)]]]
	end)

	fn8()

	if not v67 then
		if flag11 then
			break
		end
		fn14(69, v4[fn2("\132", 5187405058783)], v4[fn2("z\144\199zz\217\30\184 .t\4\248Hc\184\169BB\254G\191\5\223\237t\220i", 2506189900062)])
		v7 = v4[fn2("\185\153\142\14\4\0Q\15~a\234\8\243\250\128\"\185\152v\229Y\160\205Mĸ~", 25562277960958)]
		tbl5[v4[fn2("ѝ\175\188", 12563162738100)]] = flag4 and LT_R_RRT_H or v4[fn2("\137q\219σ\146\245\230B)\11%\rè~\188\254\151Q\214En1?\194h\197p\202>\191\128\188\166", 19243114481153)]
		flag11 = true
	end

	if not v67 then
		continue
	end

	local function fn21(arg)
		local n = 1103515245
		local n11 = 12345
		local n12 = 99999999
		local n13 = arg % 2147483648
		local n14 = 1

		return function(arg2, arg3)
			local v68 = n12
			local n15 = n * n13 + n11
			local n16 = n15 % v68 + n14
			n14 += 1
			n13 = n16
			n11 = n15 % 4859 * v68 % 5781
			return arg2 + n16 % arg3 - arg2 + 1
		end
	end

	local flag12 = false

	v28(function()
		if not v16(function()
			local v68 = tbl9
			local new = v68.new
			local v69 = flag4 and LT_R_RRT_W
			local str2

			if v69 then
				str2 = v69
			else
				str2 = v8

				if v8 then
					local v70 = v7
					local v71 = v4
					str2 = v4[fn2("\183b\225(\6", 22124051714172)] .. v70 .. v71[fn2("0Mz'W!\18\31\179uwA\241", 2211975661580)]
				end
			end

			if not str2 then
				local v70 = v7
				local v71 = v4
				str2 = v4[fn2("\146?\180M\218\\", 11448584710566)] .. v70 .. v71[fn2("S\1344\0225\167y%\153\151\160p\17F", 6916182153513)]
			end

			flag6 = new(v68, str2)
		end) then
			local v68 = v4
			fn14(75, v4[fn2("$", 1674014590487)], v68[fn2("\3ER\150\169\174/D\168\171\182\25\\\129i\223kg\5\21\233\248\2127\249՞\184\27\144\31\179\180xO\159\127݀*\28\194TT\189\145\233z\n", 9788529189788)])
			flag6 = false
		end

		flag12 = true
	end)

	local n11 = n8 % 8585 * v63 % 9910
	fn20()

	if flag5 then
		n10 = 146
	end

	fn14(85, v4[fn2("\164", 31753662264196)], v4[fn2("e\249\24\25\161 \251\8\2081\171\141\127Q:\247V\12\157\2432\28\237a\225", 6450163980151)])
	local v68 = fn21(n11 + v62(2, 4096))
	local v69 = v62(1111, 32768)
	local n12 = 12000 + ((1398563873 * ((1398563873 * (1361 + n11 + n7 % 1000 + n7) % 1610612736 + 22491) % 95716599 + 1) + 22491) % 95716599 + 1) % 120000 - 12000 + 1
	local tbl18 = { n12 + v68(100000, 1000000), v69, n12 + v62(3333, 15625) + n8, (v68(10000, 1000000)) }
	n7 = -1
	fn15()
	local flag13 = false

	if n7 == -1 then
		n7 = 100
		flag13 = true
	end

	local n13 = 0
	local n14 = 0
	local n15 = 0
	local n16 = 1
	local tbl19 = { [0] = 0 }

	local function fn22(arg, arg2, arg3)
		arg2 = arg2 and arg or tbl6[arg]

		if not arg3 then
			arg2 = (arg2 + 4096 - tbl19[n13]) % 256
			n15 += arg2
			n13 = (n13 + 1) % n16
		end

		local n = arg2 % 16
		return tbl7[(arg2 - n) / 16] .. tbl7[n]
	end

	local function fn23(arg)
		local n = 0

		for i = 1, #arg do
			n += v26(arg, i)
		end

		return n
	end

	local function fn24(arg, arg2)
		local v70 = tbl7
		local n = (tbl7[v27(arg, 1, 1)] * 16 + v70[v27(arg, 2, 2)] + tbl19[n14]) % 256
		n14 = (n14 + 1) % n16
		if arg2 then
			return n
		end
		return tbl6[n]
	end

	local function fn25(arg)
		local tbl20 = {}
		n14 = 0
		local n = 1

		while true do
			local v70 = fn24(v27(arg, n, n + 1), true)
			n += 2
			local v71 = v4[fn2("", 13613314290054)]

			for i = 1, v70 do
				v71 ..= fn24(v27(arg, n, n + 1))
				n += 2
			end

			tbl20[#tbl20 + 1] = v71
			if not (n > #arg) then
				continue
			end
			break
		end

		return tbl20
	end

	local function fn26(arg, arg2)
		local v70 = fn22(#arg, true, arg2)

		for i = 1, #arg do
			v70 ..= fn22(v27(arg, i, i), false, arg2)
		end

		return v70
	end

	local function fn27(arg, arg2, arg3)
		if arg == 1 then
			tbl19 = arg2
			n16 = arg3
		elseif arg == 2 then
			n13 = 0
			n15 = 0
		elseif arg == 3 then
			return n15
		end
	end

	local v70 = fn18(v62(2, 32768 + v25() % 2000) + n7 % 4096)
	local v71 = fn12(v68(1, 32768) + n8 + v25() % 1000)
	local v72 = v70(111111, 999999)
	local tbl20 = {}

	for i = 1, v72 % 30 + 1 do
		local fn28

		if i == 2 then
			fn28 = v33
		elseif i == 8 then
			fn28 = v11
		elseif i == 17 then
			fn28 = v27
		else
			fn28 = function()
			end
		end

		tbl20[i] = fn28
	end

	local n17 = v71(111111, 999999) + 14915
	local n18 = v70(1, 1234) * v71(2, 1235) + n7 % 80000
	local n19 = 10000 + ((1445613873 * ((1445613873 * (n12 + n7) % 1627389952 + 23515) % 94716599 + 1) + 23515) % 94716599 + 1) % 100000 - 10000 + 1
	local tbl21 = { n19 + v70(100000, 1000000), n19 + v71(100000, 1000000), (v70(100000, 1000000)) }
	v6 = v5 or v6

	if v6 then
		n10 = 218
	end

	if flag13 then
		n10 = 250
	end

	local v73 = tbl21[1]
	local n20 = 14629 + tbl18[4]
	local n21 = tbl18[2] + 14915
	local n22 = 2492 + tbl18[1]
	local str2 = ((((((fn26(v4[fn2("", 26309625077686)] .. n17) .. fn26(v4[fn2("", 16740145904870)] .. fn16(2492 + v72) .. fn13(n10 + n18) .. fn10(n17 - 14915))) .. fn26(n18 .. v4[fn2("", 17472460177296)]) .. fn26(v4[fn2("", 27987934766545)] .. v72)) .. fn26(tbl18[3] + 6293 .. v4[fn2("", 13603650318717)])) .. fn26(v4[fn2("", 32880051812253)] .. v73) .. fn26(v4[fn2("", 16629547121791)] .. n20)) .. fn26(tbl21[3] .. v4[fn2("", 13202058620935)]) .. fn26(v4[fn2("", 15144516859672)] .. n21)) .. fn26(tbl21[2] .. v4[fn2("", 18783538955349)]) .. fn26(v4[fn2("", 8523622719234)] .. n22)) .. fn26(str or v4[fn2("\15", 2953953905343)])
	local str3 = fn26(fn17(fn27(3) + 2579) .. v4[fn2("", 3140790684525)], true) .. str2
	local tbl22 = {}
	local v74 = v71(111111, 999999)
	local v75 = n7
	getfenv()[tbl22] = v74
	local v76, v77 = fn19(tbl5[v4[fn2("\209\30p\238", 17011810876899)]] .. v4[fn2("V", 25199342148524)] .. v10 .. v4[fn2("\221\209\n=o\17", 1184373376079)] .. tbl5[v4[fn2("p<\196O\205\0158s", 21268253363551)]] .. v4[fn2("c>\6\3F\162+y", 3976187317879)] .. str3 .. v4[fn2("\167Q\174", 1858703820483)] .. tbl5[v4[fn2("\15s )\130R\2366K\160\146G\162", 33488882006484)]] .. v4[fn2("\142\229\173", 8988567118003)] .. v44, n9 == 9 or n9 == 15)
	n7 = -1
	fn15(tbl8)

	while n7 == -1 do
	end

	while tbl18[2] ~= v69 do
	end

	local n23 = 0

	for k, v78 in v34(tbl20) do
		if k == 2 and v78 ~= v33 then
			n10 = 147
		end

		if k == 8 and v78 ~= v11 then
			n10 = 147
		end

		if k == 17 and v78 ~= v27 then
			n10 = 147
		end

		n23 = k
	end

	if n23 ~= v72 % 30 + 1 then
		n10 = 147
	end

	local flag14 = false

	if n10 == 147 then
		flag14 = true
	end

	if n7 ~= v75 then
		n10 = 100
		flag14 = true
	end

	if v76 == v4[fn2("\196\205X", 28147927180902)] then
		while true do
		end
	else
		local fn28, n24, v78, n25, n26, v79, tbl23, n27, n28, n29

		do
			do
				if v35(v76, v4[fn2("\166\222ʞ\1593\166ye\241v\251\148W\162\200<\128\148(ݯ\180\233/p\147\233F襣\136\185\170\1\172\250\235\173k", 1377652802819)]) then
					if v9 then
						v9(v4[fn2("Ҕ~E\164", 19446057879230)])
						return
					end
				end

				if v27(v76, 1, 1) == v4[fn2("\138", 5914350458244)] then
					do
						local v80 = v4[fn2("l\24\178\25+\175\tY\29B갖X\23", 28383083816769)]
						local v81

						if string[v4[fn2("\220eg'", 2761748253196)]](v76, v4[fn2("\23GB\147\212y\236\24\167&\219\243@y;\217", 9639274521361)]) then
							v80 = v4[fn2("LY\1333\11w\134\174FP\194 \4\177,y7\5y", 15260484515716)]
							v81 = v27(v76, 2, #v76 - 17)
						else
							v81 = v27(v76, 2, #v76)
						end

						fn14(100, v4[fn2("\244\159\237\201L\217X\239\180\245$\181G?", 30952626417818)], v4[fn2("N=1MT {!\211Z\191R\207'\140\200\253|3\169\178\183\150U\25c", 27278169760572)], Color3[v4[fn2("\189o`", 30263263129112)]](1, 0, 0), v4[fn2("4\226\14\232\14", 13170919157738)])
						fn4(v80, v81)
					end

					fn9()
				end

				if v77 then
					if not v77[v4[fn2("\2\209\252\2074\186vTX\135", 27265284465456)]] then
						local v80 = v77[v4[fn2("\212/tO\130\27\16ĩ\177", 17419845222239)]]
					end
				end

				do
					local n = tbl18[4] % 256
					local tbl24 = { [0] = tbl18[1] % 256, tbl18[2] % 256, tbl18[3] % 256, n }
					fn8()

					fn28 = function(arg)
						local n30 = 1103515245
						local n31 = 12345
						local n32 = 99999999
						local n33 = arg % 2147483648
						local n34 = 1

						return function(arg2, arg3)
							local v80 = n32
							local n35 = n30 * n33 + n31
							local n36 = n35 % v80 + n34
							n34 += 1
							n33 = n36
							n31 = n35 % 4859 * v80 % 5781
							return arg2 + n36 % arg3 - arg2 + 1
						end
					end

					if getfenv()[tbl22] ~= v74 then
						n10 = 100
						flag14 = true
					end

					n24 = 1

					for i = 1, 30 do
						local v80 = v33({})
						local n30

						if v33({}) < v80 then
							n30 = n24 + 1
						else
							n30 = n24 * 2
						end

						n24 = n30 % 10000
					end

					fn27(1, tbl24, 4)
					v78 = fn25(v76)
					n25 = v78[1] - n17
					n26 = v78[4] - v72

					while n ~= tbl24[3] do
					end

					fn20()
					v79 = tbl24[3]

					tbl23 = {
						[0] = tbl24[0],
						[2] = tbl24[1],
						[4] = tbl24[2],
						[6] = v79,
						v78[9],
						[3] = v78[7],
						[5] = v78[2],
						[7] = v78[6],
					}
				end
			end

			fn27(1, tbl23, 8)
			n27 = v78[8] - tbl21[1]
			n28 = v78[3] - tbl21[2]
			n29 = v78[5] - tbl21[3]

			do
				local str4 = v4[fn2("", 28654748788798)] .. fn17(tbl21[3] + 16704) .. fn16(tbl21[1] + 31) .. fn13(tbl21[2] + 10976)

				if v78[11] == str4 and ({ [str4] = true })[v78[11]] then
					flag2 = true
				else
					local str5 = v4[fn2("", 6334196324107)] .. fn10(tbl21[3] + 16704) .. fn13(tbl21[1] + 69) .. fn16(tbl21[2] + 10976)

					if v78[11] == str5 and ({ [str5] = true })[v78[11]] then
						flag2 = true
					end
				end
			end
		end

		local n30, v80, str4

		do
			if flag2 then
				local flag15 = v19(v78[14] and v78[14] or v4[fn2("\230v", 11362682743126)]) == -1
				v19(v78[15] and v78[15] or v4[fn2("\8", 1527981245839)])
			end

			n7 = -1
			fn15()

			if n7 == -1 then
				n10 = 250
				n7 = 100
			end

			n30 = n8 + v70(111111, 999999) + v71(1234, 5678) + n7 % 99915 + n24
			tbl21[4] = n8 + n7 % 9951
			v70(100000, 1000000 + n7 % 1000)
			tbl21[5] = n7 % 8005 + n24 + v71(100000, 1000000 + n7 % 5000)
			tbl21[6] = v70(100000, 1000000)
			fn27(2)
			v80 = v78[10]

			do
				local v81 = tbl21[6]
				local v82 = tbl21[4]
				str4 = fn26(v4[fn2("", 11551667071494)] .. fn13(v78[13] + 11958) .. fn17(n30 + n10) .. fn16(v78[10] + v72)) .. fn26(tbl21[5] .. v4[fn2("", 33512505047530)]) .. fn26(v4[fn2("", 24280191096916)] .. n30) .. fn26(v4[fn2("", 281328943366)] .. v81) .. fn26(v82 .. v4[fn2("", 30946183770260)])
			end
		end

		local str5 = fn26(fn13(fn27(3) + 2579) .. v4[fn2("", 1284234413228)], true) .. str4
		local v81 = v78[12]
		local response = v15:HttpGet(tbl5[v4[fn2("\204=\165,", 285624041738)]] .. v4[fn2("\215", 34962100748080)] .. v10 .. v4[fn2("\180T}\144E`\233N0\18\159\197", 5342028600175)] .. v81 .. v4[fn2("l4\190", 13551035363660)] .. str5)

		while v79 ~= tbl23[6] do
		end

		if response == v4[fn2("-\n+", 31841711780822)] then
			while true do
			end
		else
			if v27(response, 1, 1) == v4[fn2("\231", 5502021014532)] then
				v15:GetService(v4[fn2("<\165\18]\1795\142", 2067016091525)])[v4[fn2("\135\2218q\250\240\249wOź", 21595754614416)]]:Kick(response)
				fn9()
			end

			do
				local v82 = fn25(response)
				local n31 = 1
				local v83 = fn28(1 + v70(100, 1000 + n24) + v71(500, 5000 + n24) + n8 % 10000)
				local flag15 = false
				local n32 = 0
				local flag16 = false
				local flag17 = false
				local v84 = nil

				for i = 1, 3 do
					local v85 = v82[3]
					local str6 = fn13(tbl21[5] + 14915) .. fn13(tbl21[4] + fn23(flag16 and v4[fn2("\177", 34008588909496)] or v15[v4[fn2("\5fw\137\244", 33146347911317)]])) .. fn13(tbl21[6] + tbl21[2])

					if v85 == str6 and ({ [str6] = true })[v85] then
						flag3 = true

						if not (v82[8] and v82[8] ~= v4[fn2("C", 5343102374768)] and v82[8]) then
							local v86 = v4[fn2("x\138\221<\173~N", 31676350493500)]
						end

						if not (v82[9] and v82[9]) then
							local v86 = v4[fn2("\190;h\148\252\0\245", 23283728274612)]
						end

						v84 = v82[6]

						do
							local n = v82[1] - tbl21[4]
							local n33 = v82[7] - tbl21[5]
							local n34 = v82[5] - tbl21[6]
							local v86 = n27
							local v87 = n28
							local v88 = n29

							n27 = function(arg)
								if not (flag15 or n32 < v30() - 8) then
									n31 = (n31 + arg % 66) % 6644
									return v86 * arg % n + arg * 3
								end

								while true do
								end
							end

							n28 = function(arg)
								local v89 = flag15
								local flag18

								if flag15 then
									flag18 = v89
								else
									flag18 = n32 < v30() - 8
								end

								if not flag18 then
									n31 = (n31 + arg % 50) % 5891
									return v87 * arg % 10000 + arg * n33 % 4
								end

								while true do
								end
							end

							n29 = function(arg)
								if not (flag15 or n32 < v30() - 8) then
									n31 = (n31 + arg % 35) % 6711
									return (arg + n34) % 100 * arg % (v88 % 100 + 1)
								end

								while true do
								end
							end
						end

						flag17 = true
						break
					elseif i == 3 then
						v84 = nil
					else
						flag16 = true
						v84 = nil
					end
				end

				if not flag17 then
					while true do
					end
				else
					if not flag14 then
						local v85, prosper, Players, service, service2, ReplicatedStorage, HttpService, Workspace, Debris, service3
						local StarterGui, localPlayer, atan2, new, vector, huge, random2, cframe, cframe2, insert
						local sort, remove2, v86, v87, numberSequence, exclude, include, fileMesh, vector2, vector3
						local vector4, vector5, cframe3, floor2, min, max, clamp, sqrt, abs, originalSizes
						local insert2, find, spawn_, defer, delay, wait_, clock, v88, fn29, v89
						local new2, raycastParams, tbl24, variables, tbl25, tbl26, fn30, fn31, tbl27, getMuzzlePos

						do
							local v90

							do
								local str6

								do
									do
										do
											while not flag12 do
												v29:Wait()
											end

											flag7 = true

											do
												local flag18 = false
												local flag19 = false
												local n = 0
												local n33 = 0
												local n34 = 0
												local flag20 = false
												local n35 = 0
												local n36 = 0
												local v91 = v78[12]

												v28(function()
													flag19 = true

													while not flag9 do
														local n37 = v83(1000, n31 + 10000) + n31
														local n38 = v83(1000, n31 + 10000) + n31
														n35 = n37
														n36 = n38
														fn27(2)
														local v92 = fn26
														local str7 = fn26(n36 .. v4[fn2("", 15363566876644)]) .. v92(fn17(n36 + v80) .. v4[fn2("", 6862493423863)] .. fn16(n35 + n17)) .. fn26(n35 .. v4[fn2("", 13612240515461)])
														local v93 = v4[fn2("", 26792823644536)]
														local v94 = v10
														local v95 = v4
														local str8 = tbl5[v4[fn2("\251k\3\137", 8239072452089)]] .. v4[fn2("\243", 6554320115672)] .. v94 .. v4[fn2("\1716y\6\132\215\1\133#\18\21'\12\146H\155\195\17", 8461343792840)] .. str7 .. v95[fn2("\224\212\238", 27556277380159)] .. v91

														v16(function()
															if flag8 then
																local v96 = v4
																v31(v4[fn2("@", 8025391308082)] .. v30() .. v4[fn2("\198\5\158\149\150H\31\14\31\12\163}g\158\31H\4\5\208[", 21377778372037)] .. v33(flag6) .. v96[fn2("\229\215", 957806936956)])
															end

															if flag6 == false then
																v93 = fn19(str8)
															else
																v93 = flag6:request({ [v4[fn2("E\143\147", 17306025115381)]] = str8 })
															end

															if flag8 then
																local v96 = v4
																v31(v4[fn2("\136", 8205785439706)] .. v30() .. v96[fn2("\20N\188+\204\18\227\131`OM\249P=\163n\206\2432", 6507074033580)])
															end

															if v93 and #v93 > 3 then
																if v93 == v4[fn2(",.[\"@+o>\223", 19626452010854)] then
																	flag15 = true
																	flag2 = false
																	flag3 = false
																	n26 = 1
																	n25 = 2
																	local v96 = v4
																	v15:GetService(v4[fn2("K\26\21\0193\18\164", 34803182108316)])[v96[fn2("\210\201\222Q\159{D\181\180\253d", 29684498623485)]]:Kick(v4[fn2("\3\174d\163\173\15\196\248\n\148\211g\189\226M\252,\146?T\145^m\161\29J\31mM\158n\1\176D\232\133\t\2291r*\138W\145\0190\29\152I\176\177\147X^3\153O۴", 33049708197947)])
																	fn9()
																end

																if v93 == v4[fn2("Ɖ\162J", 30249304059403)] then
																	flag15 = true
																	flag2 = false
																	flag3 = false
																	n26 = 1
																	n25 = 2
																	local v96 = v4
																	writefile(v4[fn2("\231\151|(\168\248]\170\254\215\233V\231k\136M\172\129\168", 14824532030958)], v96[fn2("s25z\154\234a\131\145", 15250820544379)])

																	while true do
																	end
																else
																	v93 = fn25(v93)[1]

																	if v93 == fn13(n35 * n36 % 100000 + n30 + 2492) .. v4[fn2("", 28489387501476)] then
																		n33 += 1
																		flag20 = true
																		flag18 = true
																	elseif v93 == fn10(n35 * n36 % 100000 + n30 + 2492 + 4919) .. v4[fn2("", 15233640150891)] then
																		flag20 = true
																		flag18 = true
																		flag9 = true

																		v16(function()
																			flag6:close()
																		end)
																	else
																		flag15 = true
																		flag2 = false
																		flag3 = false
																		n26 = 1
																		n25 = 2
																		local v96 = v4
																		v15:GetService(v4[fn2("\197>x\169\18fL", 29485850323780)])[v96[fn2("\172\15\203V*\147lM\179R\26", 24838553885276)]]:Kick(v4[fn2("\174\191bRRQ*\193ع'\25\154\n\158j\6\129\242\184\187\21\21D\245\225tL\179\160(", 22159486275741)] .. n33)
																	end
																end
															end
														end)

														v22(20)
													end
												end)

												while not flag19 do
													v29:Wait()
												end

												flag19 = false

												v28(function()
													flag19 = true
													local n37 = 200

													while true do
														n37 += 1

														if not flag9 and n37 >= 250 then
															if flag20 then
																n += 1

																if n > 4 then
																	n = 0

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
																	n26 = 1
																	n25 = 2
																	local v92 = n33
																	writefile(v4[fn2("\rq\227Ŗ\196C\12d5\169P\130\23\225R%\162/\160\157", 15647043369196)], v4[fn2("\226\254\178K\216\255Z+Z", 8167129554358)] .. v92 .. v4[fn2("\250\193X\28", 24571184011619)] .. v33(flag6))
																end
															end

															flag20 = false
															n37 = 0
														end

														n32 = v30()
														v22(0.18)
														if n32 ~= v30() then
															continue
														end
														flag15 = true
														flag2 = false
														flag3 = false
														n26 = 1
														n25 = 2
														local v92 = n33
														writefile(v4[fn2("\221aK\192\216\12q\174n\167\"\232\6\199\17:\166y\t=)", 26022927261355)], v4[fn2("\206\224\168?\226v\231\19\29", 709765005973)] .. v92 .. v4[fn2("\169d\175m", 10312531191172)] .. v33(flag6))
													end
												end)

												fn14(95, v4[fn2("\132", 22787644412646)], v4[fn2("\"\140\144$Il~ٳz\219Z\206:\t", 447764005281)])

												while not flag19 or not flag18 do
													v22()
												end
											end
										end

										fn14(100, v4[fn2("^\156\160\174\193/5\1494\0U\206\225\165}", 10029054698620)], v4[fn2("[Q7ð=\11x\218~\1302}\200\234/m\228.\159", 31806277219253)] .. v30() - now .. v4[fn2("\252", 21953321553885)], Color3[v4[fn2("wܽ", 20447889574499)]](0, 1, 0), v4[fn2("\211\225ף", 11135042529410)])
										v85 = nil

										do
											local tbl28 = {
												[23] = 145,
												[14] = 188,
												[21] = 154,
												[11] = 242,
												[24] = 30,
												[16] = 178,
												[6] = 44,
												[5] = 5,
												[13] = 8,
												[18] = 105,
												[12] = 81,
												[8] = 184,
												[4] = 195,
												[7] = 78,
												[20] = 97,
												[9] = 238,
												[3] = 96,
												[15] = 186,
												[22] = 71,
												[10] = 159,
												223,
												162,
												[19] = 244,
												[17] = 130,
											}

											luraph_runtime1(v84, buffer.fromstring("\180\240\228\222\234'h\148Z\133\139\4\29\155\28\17<\11\181V\1889'\140\153\136-N\210\0\188\r_\15\r^T\14?4W\"rp\188\160|\132\142\127$\184&\206&\149Y\192\232\188SGa\172\192\132\226\11\1330\186\21܂;\237\221[Ev+=!\tg*\148\207FχIx\136O\183\138\252\3\204\7J`\208\213L\211c\1523[\134v\7\u{E21F}\199N\24\137\129\1846\188\196մ\185\255\199ͬp\"\165\166\248\138\187-p4h)G\193\180\160\233'{\195\29s\160C\144\200a|\157N\132\160Ѹ\232g\136(\3\138|.\20!\27A\230\233\193\249\25\28\203\197\23\23&\222]A\1634\31\247zA\0\24bL\220XK\127\208\196s\29T\162g\193\2177\129\173\162\172\147\18O(\11\218)\219$\234\131\242b\16s\187\194\24\192A\154j\219\24\134\194ba\175_\182\190k\131\154x\23\183\253c(\2285\0042\183\171\143f\16\140b\130w\223w\199i~\151\162,r\134>\27\166\145\161\25\183\184K\12M\26\5w\163\161\224\185UbG\23\6\247\198\0070ߋ1\20X\18!秦\19\224\n\166\128\23\210\4\2251\17\222oJ\230Xww\174\29\tNV\242\5\158֚v\148\159\204%'?_\238\173(\2\151\186][\\B\19Q\235?\11\148\171<z\249\213N\224L\133V\216\26\253\8\245\242\127\2282\254\182\236r\240\188\233Ѽ\196\17\12\140n\1691bp\226\15P\178\215D\28V\170l\222ls\130\251\132\185\2074VW\149q2*\141\166\228*B\159\254,q\143-\212KoB\168\24\230\248u\182Vo\220\4\1326}\7\131pi\254h\16\147\11y\152\5{~\220h\219\0005J\193{\155\204L?3P\15m\2031gM\23\245:\176\17\0\133S\184\181\223DMS\159\213$^\196\240g<0|\131\21p\237\239.\154\160R\130\5\148\7U/\199\22\162m\223iV\180\2421\4A\145\254勐;\2403M\240\255\189\27\29\242`\240\249\183\t\138ƆqY\177\131\209TJ\235\3)\229\237\30zegv\207@\184Q\1279\164\195/\26M\198\240ߦ\4Pb\163Q\183\26O\240\200_\197[{\127\219h\139\t\252FST.'y\248\25q]z%K\27\149\136n\175\150\132ɫ\189+\255\179\2427\166\188\"\169v\238\169\29\0290̸b\251\26O\202\250\245\242+K\1Ğ\14\180~\192a\253L\230\231p\215'\189\196#\141\24r\163ŗ2\177ҝ6^d\171O\217mv\1\140\148\138U9\209.n1\149\28\30Z\18\20=]r\190\165\212S5'!\220)\185]Ǫ\192f\155\253\198[Ԋհ\189\239%\186\242\3\188\31\128n\137q\8\1624\180\241\143\154r\2\12\168\132b\227#\18.\190Bu\243\152\142t\29X\157\141\198A\219\224_숞\146v\169Б\158\12X\216\195\248\196HK\148\15X\179eS\240\168\243\154^\238\7\162\188~\222E\2004\224?ç\201\28\156Y\218\30\160\130\173\235\209{\245{tԷ\29\159i\157\227s\u{601}r\203F\0254\218\\\163\192N\210\248\231\238ގ\180\219\206\30\144\2293\204\199\193\tn\216ҹ\250\1996p@\0151\135\202?\137I\162Ez\196\198d\224\12\20~\254P\230\12\17\189\127\6,\150\226U_\133\25+R 3\238\254Ό~a\2119AJ{,_IL\194\211o+\133\221\250d\177s\19[\225\132\16Y\173\146\189\12\252p\188\195\197\27\232T\137\190\242\153S\nM\180׀S\132Y!\194N\149\221x\16\12l\1676N\133\153O\2dқ*\219#\25V~\181\149\8\251p\145\2520`\234\152p\175h\229\241\166<\253\0064~\139\236\239.\142^\225\174o\11\176R\18\213h\129\191\163\214R\234+\186\179\144)Qe\203*\249NM\143\226F\27\171\175\161\181\157\229p\232ږb\139\176 JR\192\185\149uL\129\188\233m\5\177\183\31\178s\213H\232\16\176T\171\144\215Ӱ\250 c\209\17#\4լN\249\22\\\175W\27Z\19\234\236\176\0203\226\128\18߮\185\\\241E:^\169\1558\208\211\222\219T`\133M\208\201\244\131\245\233#i\229\225!m\185-\136\1\153\184\167\139C\178!\22\174\156\235}P6\184\196\15*a\248ޒ\12d\131\224&M\177\193e\145\227\147>f\253r\234ūU\130\4\234\230&c\19\11\221\193P\173\158\167\3:\251v\0161x\182G\172A\24\172O\244\22%\17\142\179\210B\180?!\1RM\246\168;\168\18s\152\188\244Ϳ\142\198m1\4EĴ\235EP\n;\t\157\14\250\167V\234һs@\186\194ԟ\232l\12 \250\218W\242\2542\0\3\204\1TA\161|\223\238\r\n\212N\228)i_\1RlX\133j\219\238\218(R\3#J\246ў\163#\226\157\19p\143<\30@\24\141\247b\182\184\147C`\157\2E\219q\189\217I\22\28ą\15\132\233s\155\203\26L\3\137\1\19\211ƍ\226\12\158|\195\235\224/qT\216p\145\226@G\24U93\u{381}H\1718\148䓙\247\1789\"x\17h\n\189*=J[C\159\18a\131\149\146\137\207^\145o\165\159J杗\133\213ɫ\u{88}w\133c4\"\190_Fa\237\194\240\235@\160H{\243\249>[\252\204\1\219D\213\22\181\241\142\193\211}\1391\253zu|\151\171\204\209Ǜ\236\232\254A\232\17l(\232\227\166]o\2297v\162\159`̐\174\238Pw\137\175\197\29`H\224>&\225\175A\2009g\206K\t`7\31\193c\155YM\138\219l\8\1\164\25\151\202e\0\19\149\30\151\231=#\8\1824A\176Kk\225A\164\173\161\148\140\133\209\12L\230we\245\246\223\224\2\190p\167\191p\163\"֑\187\171\199\14\144\27u)\199\211U\192\251\146oe\t\\\\\150\152\205\23\132\144\247ƽ\245@8p\251\207>\159\11\187\211{P2\6\\7p\203\15\5\255\\\7\149\209^q\133\239\164q:\229{5\192\215~ͦ\12d\169D\175S\242\223\0087\22h!\229\197C>\6\22G\8V\248G\\\243**\163n\212\242\17\187<ۂ\246\237\194=1\239\222\193\154\160/\21\183R\224\\\1687J\133y\151ơL\154\131\228\150g\202R\156\146ܞ\157\8\150\235\127DA̵\8s\184\233\134ߪܜ\249Z\129\147\u{8E}\182&\131M\28ʩ;t\251\177i\7\188\168\154\22\4\163\132\192^\240\17V\212YiL1\136\\\220?<\145\231܅A\141\244\135H\2277\19\242[5[\157\154\253\18\2\138\27\142\31X\21\135#JH\16[~֍8\152\237i\146!\212m}MÜ\17\187\0\19\130\"{Ca\188\234i\241\226\208\246\151C\177\187\244\155\\\147\154\30\254G\253p\217d\146\197\231\150R\181\5\159v\225\rv\252\23\14\137si\255\181i\218\215Xq\161\3\163\n\195\199\249\226\217َT44@}2\241\20ə\254\24\142\2393Rc\159{_\199S\1571\16\244\167q\145\167D\25\218\225\218c!\4+\189\132I\176\1H\19ؕ\254H\135FB\227\145\219\0!\182\171\223\218\15\134@\2졄\157fe\176c\134&I_U\226\167\217\23\169\18\246\222>\141\145\134\2211\131\240\133x;gw\175\20\250(\1794\24+\175\162\226\228u\232ڝ+\199\198e\16\5/\6\198&\150\218\254$~\29\141\233`\175o\u{7B9}\210\rܚ@k\25,\254\234\176n\19\t\129p\7!\205#0\171\1987k\0042\199Խ\147\236,\129a@>a\24<$\167߂m\12:\206h`\2\243q\"F\183S\135.\241X\200\209 \148A\147\242\170\178qL\162ķ\22S\214\7\20\193\155\247\127K\175\30\215\0\233\254l\249ȹ\182\218~Q\173\244\168\234,%j<,\206\199\231\243\151`\208\251\149\0314\172\143@\171\8m\233x\251\221)]n\143\250ZA\175\191\29\142\2\135\228zg\161u.`8\239g}\243e\1405i\168\237T\150\140\210Mo*Q;\236\1810E.\"\154\153\22\\\11\229\231\23\182R'\135>\215\6\27w\201+[\193\175T\232\158\236\0,\185\171\0257\142r\250\130\254\243\247\141\6\145˰\165Q\130\152\30>\1589\170\27\188'N\152\190\160\4$\192\160\151\231\156a\12\241\21\rh\12\138D\243H\n1\141\207f$Q\198\233\160\228gP\30̏Uf\190\193\2\155\234SS\149\217\"\252\198\16~\220\255 `\151\186]zX\135\247`\190\174\24u\232^:N\230\133$1\159g\196 %j<\"\243ґ\163Y\152\141\157\189\128K\t0\221\\\7g\159\171\184f\153\170\193ɗ!3W\226\1957\215\2360\234\174\229qi\193\128:\203JS\231\16\242\215\196D\161E\198}E\27\158\24a\243\179\228E\247f\239\237\234\29\150\164\196~x\18\178\31\159\16h\166\209JS\156\225\250\254\n_\173\193\6\166\247\148\152\229pn\168\240q&\148imMv\174wK\1806&W\236^\253\250W\175Pd\157\165\\\179\136\21\219\31^4dCح$U\129v\163uhZ\22\138\2215\212\213\22G\1842\216\249\153 \209\219R>3\185\186\21W\211\21\255\199\217\245\12O\211\27~\144\212\15V\199\206\240\140n\213\23+˨7\156H\239W9\2\210\194A\216\229\129\254Z\31\223\237S\251\214+ \30\249\212\2306\149\244\151\183\193\129,\185Z=\tdO7\154\197L\203\225\195\4\1773:\133\174\156\163\218\2049\182\25\215|\31g\197s\30Ml\2421]\251\156\31ǃp\207\27\0\171\3\212\18\131\146\178t\153\136\178\225\186\232\1L\160U\182[\244b\127P\146\239\4\19\234\20\146l{\163\8\196T\244\2395\139\17\141T\245A\226\159z\144O\25\201\221n\190\149UV/I@\145\233+)\148\137s\221\223$tz\129\165pi&q\218n\230W\1822n\\\159\213\27\175\224\5\27\238߭!\168\7\227\149I2\180\235\244q\174\195>0\"\224\n{)L\175Ck]^\18\140-AڸW\147\246\133x,\19\214\222\255!t9\27\192\203\tz\00372'\199\244yq\182\1~\28\138\213=\26\134\142aF\181\198\rm\r)\179+\30\21@\22\1616\146\194g1U\203-ڃ`\148O\166Q\24/\246\15\180\244\223\210\227ŅG\30\176\8۲1\139)\30\142\134+9\248\2241p\242\201\204v\166U\249sr\172G°\150+A\210f\192>GMZ\15\157#QL\171\217>\188\137\160陿\1932(\250\186dy\173\16\18\144\6s\129\203\200\n\209\25\252\141wCЩo\216d\138\182q\197\198\"\232\248\212:\246\214\28\247\134\177\1957\4\215\31\142\233\1573m\252`o\139\215c\179\159k\137\149\164\169\229H\163\16ʺ\14\0210\22Z]U5U\205A\146sT\202(\29\159,%\232\206 \5'\12\231\173\207\27ո\2519\177>/A\145\206\215\199\210&^G\232\142=\131\191\151z\150\146W*ܩ\249NZ\169-\r\30\179\u{EDDC}\198'\202\19ڬE\134!H\20\31\217\255\135\130`\174\22AX\158xxH\240%\253\184\229{-l\153\249\245\15\u{FDEA}\208l\235\248aE\248p\135\246\147Z\140v\153\192P\206\tW\2}x\169\193c\196\241h\7\237Hq[M\226\196\219\\=g\192]\22(\155\t\165+b\1[~\241\224\253M\170\8?\242\136\141\0079GN\190\156\30\139zf\249\129\153\233/\147!H\234\15r0&G)\150\190\20\129\135\u{FC31F}Ρ\205x't\185^\128T\249\31Ј\203\223#\146\184\254fJ\156@\129$(|\234\151-v4\1319ԕ\2\227\216j\6\"ڍ\167H\4\r\159\139ł\243\189\141C7Q\24g\169\187nW] \202\26\192E\171\252+\21m\128*\144\224\1797\159\1364=c\247a\n\167\131\25\180\218ps\29\184\248{O\186G\203\16ORL\20\3\212\213\3\203\253\23v\3\150\178\132㵭<\147\152\188\151G;\214*\2\28\218,\243\133@\1552\t\228\222\2269\251\2278\222\235a\221Ɨ\191W\31>\154\173\207\26\150\182\131\187]\25\155\206\203\16\253\172\199\26>\189\nih\135\179\u{5EC}\t<\174EXd\167\153\r\245\148\239\198\235>\142\178w\203\6P\181R\186\198\30\195\31Rе\187=c\144\170+\251\201η\167\172{aF\1968\129\207W\u{70E}*fh\221\205+\230U\238\193\182#>\180\190\148Kg!(Hx\158$\134{\2324>\4\148\127s\156g\168\210b\201\28\233\137\20|\187\15\208.\186$\179\254\199\219\4\149n\27n!\24W\218\243\18\235=\233\11In\16\143#Es\0\135\2527\167\155*r\169\239\12\174\149S\199\2\164IP\251F\198U2&\n\190\191uuq\170\2090\173s\188\235\228\255\14F\200^7\215\194$&k\237j\137\166_e\8v*1\1536\153\133\254\170\194\31\199М6\229`\196Z\134\137\128\204\212d\241\191~\167\197H\127e,\243\134a\157kf\153M{'\179t\162\138|ս\215Hnꜭ_\236RH£̷L \31\249[\205sP\1Ö\27DB_d#V}\139F\1352\178\0ӷ\179\6\184\128qי\159\156C!\221a\185FJ\\\14\241\245\162\222\193\177\1709\203ܚJqP\"\226P\128\"\2160\144Bŀ\208\14t\167\196\127\144\148t\253\218\223\11+\31\17\1\129\147\189\243\197R\186\230\161\240K[Ƥ\191;2\146\150\11\14\165\224\168R\234\192\1\130\134\168>\174uR$߷`\193B\151\239US\191H7\223y\151\192\217\1\2\247 4\1\205a\162-\t\182\t_\2282\n\2'\14\6\19\2161\155\160N\255\183\227\212ϱ\188\187Goc\148\198U|\253tP\242\143\252\189M\184I7\210\31X*\169\0\170\168\21j\27\245\n]\153B\0317\156\197\229\216\246h\2\148>\185\210\127\11\19\217k\213\199\245l\246Y]\198=*\253l\230\22Y_\142\210\14\141:\179\254'|\11:e\243\200\192w\202!WvP\224\198\249\27\139hyӻ\24!\14\206\19\207PE\1x\200\16\225\251\187g\218\8\224\"\233\147"), tbl28, 289)()
										end
									end

									do
										game:GetService("HttpService")
										str6 = type(script_key) == "string" and script_key ~= "" and script_key or ""
										prosper = getgenv().Prosper
										Players = game:GetService("Players")
										service = game:GetService(v85[175])
										service2 = game:GetService(v85[94])
										ReplicatedStorage = game:GetService("ReplicatedStorage")
										HttpService = game:GetService("HttpService")
										Workspace = game:GetService("Workspace")
										Debris = game:GetService("Debris")
										service3 = game:GetService(v85[46])
										StarterGui = game:GetService("StarterGui")
										game:GetService(v85[157])
										localPlayer = Players.LocalPlayer
										localPlayer:GetMouse()
										Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function(...) end)
										atan2 = math.atan2
										new = Drawing.new
										vector = Vector3.yAxis
										ReplicatedStorage:FindFirstChild("GunBeam")
										ReplicatedStorage:FindFirstChild("SkinAssets")
										Color3.new(v85[196], 0.545098, 0.14902)

										do
											local tbl28 = {}
											local color = Color3.fromRGB(248, 147, 255)
											local color2 = Color3.fromRGB(255, v85[161], v85[105])
											local color3 = Color3.fromRGB(76, 255, 82)
											local color4 = Color3.fromRGB
											tbl28[1] = color
											tbl28[2] = color2
											tbl28[3] = color3

											do
												local values = table.pack(color4(110, 149, 255))
												table.move(values, 1, values.n, 4, tbl28)
											end
										end
									end

									do
										huge = math.huge
										random2 = math.random
										cframe = CFrame.new
										cframe2 = CFrame.Angles
										insert = table.insert
										sort = table.sort
										remove2 = table.remove
										v86 = pairs
										v87 = ipairs
										numberSequence = NumberSequence.new(v85[64])
										exclude = Enum.RaycastFilterType.Exclude
										include = Enum.RaycastFilterType.Include
										fileMesh = Enum.MeshType.FileMesh
										vector2 = Vector2.new
										vector3 = Vector3.new
										vector4 = Vector3.zero
										vector5 = Vector3.new(0, -v85[196], 0)
										cframe3 = CFrame.new
										floor2 = math.floor
										min = math.min
										max = math.max
										clamp = math.clamp
										sqrt = math.sqrt
										abs = math.abs
										originalSizes = {}
										insert2 = table.insert
										find = table.find
										spawn_ = task.spawn
										defer = task.defer
										delay = task.delay
										wait_ = task.wait
										clock = os.clock
										v88 = pcall
										v90 = xpcall

										do
											local v91 = setmetatable
											fn29 = function(R,l) v88 ( v91 ,R,l);return R;end
										end
									end

									v89 = next
									new2 = Instance.new
									raycastParams = RaycastParams.new

									do
										local ignored = Workspace:FindFirstChild("Ignored")
										local v91 = Workspace:FindFirstChild(v85[191])
										local mainModule = ReplicatedStorage:FindFirstChild("MainModule")
										local tbl28 = {}

										if mainModule and mainModule:IsA("ModuleScript") then
											local v92, v93 = v88(require, mainModule)

											if v92 then
											end

											if v92 and v93 and v93.Ignored then
												tbl28 = v93.Ignored
											end
										end

										if #tbl28 == 0 then
											if not (v91 and ignored) then
												if not v91 then
													if ignored then
													end
												end
											end
										end
									end
								end

								do
									local fn32

									do
										local fn33, fn34

										do
											tbl24 = {
												Features = {},
												Connections = {},
												Routines = { RenderStepped = {}, Heartbeat = {} },
												KeyBindings = {},
												State = {
													Targets = {
														SilentAim = nil,
														CameraAimbot = nil,
														TriggerBot = nil,
													},
													Toggles = { NameESP = true, TriggerBot = false },
													IsShooting = false,
													IsAiming = false,
													IsReloading = v85[74],
													IsLowHealth = v85[74],
													IsKnife = v85[74],
													EspEnabled = v85[30],
													SpeedActive = v85[74],
													JumpActive = false,
													DesyncActive = false,
													AssistActive = v85[74],
													TriggerActive = false,
													TriggerHold = false,
													TriggerBotFiring = v85[74],
													AntiStopVel = vector4,
													LeftCtrlHeld = false,
													RightClickHeld = false,
													LeftClickHeld = false,
													IsMouseHeld = false,
													IsAimed = false,
													CamlockActive = v85[74],
													CamlockHold = v85[74],
													CamPressed = v85[74],
													TargetPressed = false,
													EspPressed = v85[74],
													SpeedPressed = false,
													JumpPressed = false,
													PanicGroundPressed = false,
													MouseFiring = false,
													LastEquippedTool = nil,
													LastEquippedWeapon = nil,
												},
												FrameTime = 0,
											}

											fn33 = function(n,R)local l={{n,R}};while#l>0 do R=table.remove(l);n=R[1];for T,L in pairs(R[2])do if type(L)=="table"and type(n[T])=="table"then table.insert(l,{n[T],L});else n[T]=L;end;end;end;end

											do
												local function fn35(n)local R=n:match("^%s*(.-)%s*$");if R:match("^return%s*{")then return R;end;n=R:find("{");if not n then return R;end;return"return "..R:sub(n);end
												fn34 = function(R)if type(R)~="string"then return nil,"code must be a string";end;if type(loadstring)~="function"then return nil,"loadstring is not available";end;local l,T=loadstring( fn35 (R));if type(l)~="function"then return nil,tostring(T);end;return l,nil;end
											end
										end

										do
											local function fn35()if not game then return nil;end;local n,R=pcall(function()return game:GetService("HttpService");end);if not n or type(R)~="Instance"and type(R)~="userdata"then return nil;end;return R;end
											fn32 = function(...) end

											local function fn36()
												error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:42)")
											end
											;({
												Apply = function(R,R)if type(R)~="string"or R==""then return;end;local l= fn34 (R);if not l then return;end;R=getgenv().Prosper;if type(R)~="table"then R={};getgenv().Prosper=R;end;local T,L=pcall(l);if not T then return;end;L=if type(L)~="table"then getgenv().Prosper else L;if type(L)~="table"then return;end;if R~=L then  fn33 (R,L);end;getgenv().Prosper=R;getgenv().LiveCfg=R;end,
												BuildUrl = function()
													error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:2408)")
												end,
												EnforceBan = function()
													error("devirt: symbolic next pc/mode: (r3 Add 1) / 195 (at 195:34)")
												end,
												Checkin = function()
													error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:483)")
												end,
												LongPoll = function()
													error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:12)")
												end,
												Fetch = function()
													error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:25)")
												end,
												Init = function()
													error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:5)")
												end,
											}):Init()
										end
									end

									do
										do
											if getgenv().Loaded then
												return
											end
											tbl24.Connect = function(R,R,l)local T=R:Connect(function(...) v88 (l,...);end); insert2 ( tbl24 .Connections,T);return T;end
											tbl24.AddRoutine = function(R,R,l) insert2 ( tbl24 .Routines[R],l);end
											variables = {}
											tbl24.Variables = variables
											local function fn33()local R= localPlayer .Character;return R and(R:FindFirstChildOfClass("Humanoid"));end
										end

										local function fn33()local R= localPlayer .Character;return R and(R:FindFirstChildOfClass("Tool"));end
									end

									do
										local function fn33()local R= localPlayer .Character;return R and(R:FindFirstChild("HumanoidRootPart"));end
									end

									variables.FovHiddenState = { Silent = false, Trigger = false, Camera = v85[74] }

									tbl24.GameProfiles = {
										[v85[126]] = { Name = "Da Hood", Method = "DaHood", RewriteGun = true },
										["Das Hood"] = {
											Name = "Das Hood",
											Method = "DasHood",
											RewriteGun = true,
											ServerTimeForAll = v85[30],
										},
										[v85[123]] = {
											Name = "Hood Customs",
											Method = "HoodCustoms",
											RewriteGun = false,
										},
										["Hood Customs FFA"] = {
											Name = "Hood Customs FFA",
											Method = "HoodCustoms",
											RewriteGun = v85[74],
										},
										["Der Hood"] = {
											Name = "Der Hood",
											Method = "Der Hood",
											RewriteGun = false,
										},
										[v85[121]] = { Name = "Des Hood", Method = "DesHood", RewriteGun = true },
										[v85[106]] = {
											Name = "Da Uphill",
											Method = "VoidFalls",
											Updater = v85[197],
											RewriteGun = false,
											RemotePath = function()
												return ReplicatedStorage:FindFirstChild(v85[89])
											end,
										},
										["Da Downhill"] = {
											Name = "Da Downhill",
											Method = v85[125],
											Updater = "MOUSE",
											RewriteGun = v85[74],
											RemotePath = function()
												return ReplicatedStorage:FindFirstChild("MAINEVENT")
											end,
										},
										["Da Strike"] = {
											Name = "Da Strike",
											Method = "VoidFalls",
											Updater = v85[197],
											RewriteGun = false,
											RemotePath = function()
												if n29(4737) >= 376 then
													return ReplicatedStorage:FindFirstChild("MAINEVENT")
												end

												while true do
												end
											end,
										},
									}

									do
										local tbl28 = {}

										for k, gameProfile in pairs(tbl24.GameProfiles) do
											local str7 = k:lower()

											if str7 ~= k then
												tbl28[str7] = gameProfile
											end
										end

										for k, v91 in pairs(tbl28) do
											tbl24.GameProfiles[k] = v91
										end
									end

									tbl24.Games = {}
									tbl24.GamesUrl = "https://raw.githubusercontent.com/thedumpstertruck2308/thejewsarehere12/refs/heads/main/jewids.lua"

									tbl24.MergeRemoteGames = function()
										error("devirt: symbolic next pc/mode: (r11 Add 1) / 195 (at 195:734)")
									end

									tbl24.LoadRemoteGames = function()
										error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:36)")
									end
								end
							end

							do
								do
									local v91 = v85[74]

									spawn_(function()
										pcall(function()
											tbl24:LoadRemoteGames()
										end)

										v91 = v85[30]
									end)

									local v92 = clock()

									while not v91 and clock() - v92 < 5 do
										wait_()
									end
								end

								tbl24.CurrentGame = tbl24.Games[game.PlaceId]

								if not tbl24.CurrentGame then
									for _, game_ in pairs(tbl24.Games) do
										if game_.GameId and game_.GameId == game.GameId then
											tbl24.CurrentGame = game_
											break
										end
									end
								end

								if tbl24.CurrentGame and tbl24.CurrentGame.Method == v85[51] then
									tbl24:Connect(service.Heartbeat, function(...) end)
								end

								tbl25 = { GunData = {}, KnifeData = {} }
								tbl24.ShotPellets = {}
								tbl24.ShootDaHood = function(R,R,l,T,L,X,Q)local z= ReplicatedStorage :FindFirstChild("MainEvent");if not z then return;end;local Y=R and R.Parent;local U=Y and(Y:FindFirstChild("Range"));local Y,_=U and U.Value or 200,T-l;local U=_.Magnitude;local E=nil;if U>Y+ max (1.0E-4,Y*1.0E-6)then E,L,X=l+_/U*Y,nil,nil;else E=T;end;if Q then z:FireServer("ShootGun",R,l,E,L,X,Q);else z:FireServer("ShootGun",R,l,E,L,X);end;E=R and R.Parent;U=E and(E:FindFirstChild("ShootingCooldown"));local R=U and(tonumber(U.Value))or 0.3;L= localPlayer .Character;_=L and(L:FindFirstChild("BodyEffects"));E=_ and(_:FindFirstChild("Movement"));if E then X= new2 ("NumberValue");X.Name="ReduceWalk";X.Value=2;X.Parent=E; Debris :AddItem(X,R);end;end
								tbl24.ShootDasHood = function(R,R,l,T,L,X,X)local Q= ReplicatedStorage :FindFirstChild("MainEvent");if Q then Q:FireServer("ShootGun",R,l,L,l,T,X);local l=R and R.Parent;local R=l and(l:FindFirstChild("ShootingCooldown"));local T=R and(tonumber(R.Value))or 0.3;R= localPlayer .Character;l=R and(R:FindFirstChild("BodyEffects"));R=l and(l:FindFirstChild("Movement"));if R then l= new2 ("NumberValue");l.Name="ReduceWalk";l.Value=5;l.Parent=R; Debris :AddItem(l,T);end;end;end
								tbl24.ShootDesHood = function(...) end
								tbl24.Shoot = function(R,...)local R= tbl24 .CurrentGame;if not R then return;end;if R.FireShoot then R.FireShoot(...);return;end;local l=R.Method and  tbl24 .ShootMap[R.Method];if l then l(...);end;end

								tbl24.ShootMap = {
									DaHood = function(...)
										return tbl24:ShootDaHood(...)
									end,
									DasHood = function(...)
										return tbl24:ShootDasHood(...)
									end,
									DesHood = function(...)
										if n28(1894) <= 6203 then
											return tbl24:ShootDesHood(...)
										end

										while true do
										end
									end,
								}

								for _, game_ in pairs(tbl24.Games) do
									if game_.Method == v85[51] then
										game_.FireShoot = function(...)
											return tbl24:ShootDaHood(...)
										end
									elseif game_.Method == v85[181] then
										game_.FireShoot = function(...)
											return tbl24:ShootDasHood(...)
										end
									elseif game_.Method == "DesHood" then
										game_.FireShoot = function(...)
											return tbl24:ShootDesHood(...)
										end
									end
								end

								tbl26 = {}

								do
									local function fn32()
										error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:11)")
									end

									fn32()
									Players.PlayerAdded:Connect(fn32)
								end
							end

							do
								local fn32, fn33

								do
									Players.PlayerRemoving:Connect(function(R)for l=# tbl26 ,1,-1 do if  tbl26 [l]==R then table.remove( tbl26 ,l);break;end;end;end)
									fn30 = function(n)local R=n and n.Character and(n.Character:FindFirstChildOfClass("Humanoid"));return R and R.Health>0;end
									fn31 = function(n)if not n then return false;end;local R=n:IsA("Player")and n.Character or n;if not R then return false;end;n=R:FindFirstChild("BodyEffects");if n then local l=n:FindFirstChild("K.O")or(n:FindFirstChild("KO"))or(n:FindFirstChild("Knocked"));if l and l.Value==true then return true;end;end;if R:GetAttribute("Knocked")==true or R:GetAttribute("KO")==true then return true;end;n=R:FindFirstChildOfClass("Humanoid");if n and(n.Health<=0.5 or n:GetState()==Enum.HumanoidStateType.Dead)then return true;end;return false;end
									fn32 = function(R)local l,T= localPlayer :GetAttribute("CrewID"),R:GetAttribute("CrewID");return l and T and l==T;end

									do
										local tbl28 = {}
										fn33 = function(R)local l=0;if R then l=1; tbl28 [l]=R;end;R= Workspace :FindFirstChild("Ignored");if R then l+=1; tbl28 [l]=R;end;R= Workspace :FindFirstChild("Bush");if R then l+=1; tbl28 [l]=R;end;for R=l+1,# tbl28 ,1 do  tbl28 [R]=nil;end;return  tbl28 ;end
									end
								end

								do
									tbl27 = {
										IsRealPellet = IsRealPellet,
										Bound = fn29({}, { __mode = v85[166] }),
										Entries = fn29({}, { __mode = "k" }),
										Sounds = fn29({}, { __mode = "k" }),
										Patterns = {},
									}

									for _, v91 in ipairs({
										"[Double-Barrel SG]",
										"[TacticalShotgun]",
										"[Shotgun]",
										"[Drum-Shotgun]",
										"[DoubleBarrel]",
									}) do
										tbl27.Patterns[v91] = "Shotgun"
									end

									for _, v91 in ipairs({
										"[Revolver]",
										"[Glock]",
										"[Silencer]",
										"[Deagle]",
										"[Rifle]",
										"[Flintlock]",
									}) do
										tbl27.Patterns[v91] = "Semi"
									end

									for _, v91 in ipairs({
										"[SMG]",
										"[AR]",
										"[AK47]",
										"[P90]",
										"[SilencerAR]",
										"[DrumGun]",
										"[LMG]",
									}) do
										tbl27.Patterns[v91] = v85[172]
									end

									tbl27.Patterns["[AUG]"] = "Burst"

									tbl27.WeaponData = {
										["[SilencerAR]"] = {
											Offset = cframe3(2.5, 0.35, 0),
											Category = v85[34],
											GateOffset = 0.02,
											WaitRaw = true,
										},
										["[DrumGun]"] = {
											Offset = cframe3(0, v85[150], v85[170]),
											Category = "Auto",
											Gate = 0.6,
										},
										["[SMG]"] = { Offset = cframe3(0, 1, 0.5), Category = "Auto", Gate = 0.6 },
										["[P90]"] = {
											Offset = cframe3(0, 0.2, -1.7),
											Category = v85[34],
											Gate = 0.6,
										},
										["[AR]"] = {
											Offset = cframe3(2, 0.35, 0),
											Category = "Auto",
											Gate = v85[154],
										},
										["[AK47]"] = {
											Offset = cframe3(-0.1, 0.5, -2.5),
											Category = "Auto",
											Gate = 0.15,
										},
										["[LMG]"] = {
											Offset = cframe3(0, 0.7, -3.8),
											Category = "Auto",
											Gate = 0.62,
										},
										["[Drum-Shotgun]"] = {
											Offset = cframe3(-0.1, v85[86], -2.5),
											Category = v85[129],
											Shotgun = true,
											ServerTime = true,
											Gate = 0.415,
										},
										["[AUG]"] = { Offset = cframe3(-v85[187], 0.4, 1.8), Category = "Burst" },
										["[Revolver]"] = { Offset = cframe3(-v85[196], 0.4, 0), Category = v85[92] },
										["[TacticalShotgun]"] = {
											Offset = cframe3(v85[64], 0.25, -2.5),
											Category = v85[92],
											Shotgun = v85[30],
											ServerTime = true,
										},
										["[Double-Barrel SG]"] = {
											Offset = cframe3(0, v85[71], -2.2),
											Category = "Single",
											Shotgun = true,
											ServerTime = true,
											GateExtra = 0.05,
										},
										["[Shotgun]"] = {
											Offset = cframe3(0, 0.25, 2.5),
											Category = "Single",
											Shotgun = true,
											ServerTime = true,
											Gate = 1.2,
										},
										["[Rifle]"] = {
											Offset = cframe3(0, 0.25, v85[148]),
											Category = "Single",
											Gate = 1.3095,
										},
										["[Silencer]"] = { Offset = cframe3(0, 0.4, 1.3), Category = "Single" },
										["[Glock]"] = { Offset = cframe3(0.6, 0.25, v85[64]), Category = "Single" },
										["[Flintlock]"] = { Offset = cframe3(0, v85[200], -1.568), Category = "Single" },
										["[Deagle]"] = { Offset = cframe3(0, v85[200], -1.568), Category = v85[92] },
										["[DoubleBarrel]"] = { Category = "Single", Shotgun = true, ServerTime = true },
									}

									tbl27.Shotguns = {}
									tbl27.Autos = {}
									tbl27.Bursts = {}
									tbl27.AutoShotguns = {}
									tbl27.AutoGateAbsolute = {}
									tbl27.AutoGateOffset = {}
									tbl27.AutoWaitRaw = {}
									tbl27.AutoShotgunGateAbsolute = {}
									tbl27.SingleGateAbsolute = {}
									tbl27.SingleGateExtra = {}

									for k, v91 in pairs(tbl27.WeaponData) do
										if v91.Shotgun then
											tbl27.Shotguns[k] = v85[30]
										end

										if v91.Category == v85[34] then
											tbl27.Autos[k] = v85[30]

											if v91.Gate then
												tbl27.AutoGateAbsolute[k] = v91.Gate
											end

											if v91.GateOffset then
												tbl27.AutoGateOffset[k] = v91.GateOffset
											end

											if v91.WaitRaw then
												tbl27.AutoWaitRaw[k] = true
											end
										elseif v91.Category == "AutoShotgun" then
											tbl27.AutoShotguns[k] = true

											if v91.Gate then
												tbl27.AutoShotgunGateAbsolute[k] = v91.Gate
											end
										elseif v91.Category == "Burst" then
											tbl27.Bursts[k] = v85[30]
										else
											if v91.Gate then
												tbl27.SingleGateAbsolute[k] = v91.Gate
											end

											if v91.GateExtra then
												tbl27.SingleGateExtra[k] = v91.GateExtra
											end
										end
									end

									tbl27.ScopedWeapons = {
										"[Shotgun]",
										"[Drum-Shotgun]",
										"[Rifle]",
										"[TacticalShotgun]",
										"[AR]",
										"[AUG]",
										"[AK47]",
										"[LMG]",
										"[SilencerAR]",
									}

									tbl27.ShotgunPatterns = 5
									tbl27.SoundsPlaying = {}
									tbl27.DesHoodPellets = {}
									tbl27.AnimTrackCache = fn29({}, { __mode = v85[166] })
									service2.WindowFocused:Connect(function(...) end)
									service2.WindowFocusReleased:Connect(function(...) end)
									tbl27.IsAimed = function(...) end
									tbl27.GunNames = {}

									do
										local function fn34()
											error("devirt: symbolic next pc/mode: 188 / r1 (at 195:204)")
										end

										for k in pairs(tbl27.Patterns) do
											fn34(k)
										end

										for k in pairs(tbl27.Shotguns) do
											fn34(k)
										end

										for k in pairs(tbl27.Autos) do
											fn34(k)
										end

										for k in pairs(tbl27.Bursts) do
											fn34(k)
										end

										for k in pairs(tbl27.AutoShotguns) do
											fn34(k)
										end

										for _, v91 in ipairs({
											"[rev]",
											"[db]",
											"[tac]",
											"[DoubleBarrel]",
											"[smg]",
											"[usp]",
										}) do
											fn34(v91)
										end
									end
								end

								tbl27.IsShotgun = function(...) end
								tbl27.IsGun = function(...) end
								tbl27.GetCustomSpread = function(R,R)if not R then return  vector4 ;end;if typeof(R)=="Vector3"then return R;end;if type(R)~="table"then return  vector4 ;end;local function l(T)if type(T)~="table"or not T[1]then return 0;end;local L=T[1];local X=T[2]or L;X=type(L)=="table"and L[1]and  random2 ()<=L[1]and L or X;if type(X)~="table"or not X[2]then return 0;end;T=X[2]or 0;L=X[3]or T;return( random2 ()*(L-T)+T)*( random2 ()>0.5 and 1 or-1);end;return  vector3 (l(R.X or R.x),l(R.Y or R.y),(l(R.Z or R.z)));end
								tbl27.GetToolRange = function(n,n)if not n then return 200;end;local R=n:FindFirstChild("Range");if R then return tonumber(R.Value)or 200;end;return 200;end
								tbl27.GetRageRange = function(...) end

								do
									local v91 = raycastParams()
									v91.FilterType = exclude
									v91.IgnoreWater = true
									tbl27.HasRageLineOfSight = function(R,R,l,T)if not R or not l then return false;end;local L=l-R;if L.Magnitude<=1.0E-4 then return true;end; v91 .FilterDescendantsInstances= fn33 ( localPlayer .Character);l= Workspace :Raycast(R,L, v91 );if l and l.Instance and T and not l.Instance:IsDescendantOf(T)then return false;end;return true;end
								end

								tbl27.GetVisibleHittablePart = function(...) end
								tbl27.CanShoot = function(n,n,R)if not n or not R then return false;end;local l=n:FindFirstChildOfClass("Humanoid");if not l or l.Health<=0 or l:GetState()==Enum.HumanoidStateType.Dead then return false;end;if not R:FindFirstChild("Handle")or not(R:FindFirstChild("Ammo")or(R:FindFirstChild("AMMO")))then return false;end;if R.Ammo.Value<=0 then return false;end;if n:FindFirstChild("FORCEFIELD")then return false;end;if n:FindFirstChild("GRABBING_CONSTRAINT")then return false;end;local T=n:FindFirstChild("BodyEffects");if T then local function n(L)local X=T:FindFirstChild(L);return X and(X:IsA("ValueBase"))and X.Value;end;if n("Cuff")or(n("Attacking"))or(n("Grabbed"))or(n("Reload"))or(n("Dead"))or(n("Block"))then return false;end;l=T:FindFirstChild("K.O");if l and l.Value then return false;end;end;l=R:GetAttribute("Cooldown");if l then if type(l)~="number"then return false;end;if tick()<l then return false;end;R:SetAttribute("Cooldown",nil);end;return true;end
								fn29({}, { __mode = v85[166] })
								getMuzzlePos = function(...) end
								tbl27.GetMuzzlePos = getMuzzlePos
								tbl27.IsTargetKnocked = function(R,R)if not R then return false;end;return  fn31 (R);end
								tbl27.IsSelfKnocked = function(R)if  localPlayer :GetAttribute("Knocked")==true then return true;end;local R= localPlayer .Character;if not R then return false;end;if R:GetAttribute("Knocked")==true then return true;end;local n=R:FindFirstChild("BodyEffects");if n then local l=n:FindFirstChild("K.O")or(n:FindFirstChild("KO"));if l and l.Value==true then return true;end;end;n=R:FindFirstChildOfClass("Humanoid");if n and(n.Health<=1 or n:GetState()==Enum.HumanoidStateType.Dead)then return true;end;return false;end
								tbl27.IsSameCrew = function(R,R)if not R then return false;end;return  fn32 (R);end
							end

							tbl11 = {
								PingHistory = {},
								LastPingSample = v85[64],
								MedianPing = nil,
								SmoothPing = nil,
								PingSmoothingSeconds = v85[154],
								GetNetworkPing = function(R)return  localPlayer :GetNetworkPing();end,
								GetRoundTrip = function(R)local R,l=pcall(function()return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue();end);if R and type(l)=="number"and l==l and l>0 and l< huge then return l/1000,"Data";end;R,l=pcall( tbl11 .GetNetworkPing, tbl11 );if not R or type(l)~="number"or l~=l or l<=0 or l== huge then return nil,"Network";end;return l,"Network";end,
								GetMedianPing = function(R) tbl11 :SamplePing(tick());if  tbl11 .SmoothPing~=nil then return  tbl11 .SmoothPing;end;if  tbl11 .MedianPing~=nil then return  tbl11 .MedianPing;end;return  tbl11 :GetRoundTrip();end,
								RefreshPingStats = function(R,R)local l= tbl11 .PingHistory;local T=#l;if T==0 then  tbl11 .MedianPing=nil;return;end;local L={};for X=1,T,1 do L[X]=l[X];end;table.sort(L);if T%2==1 then  tbl11 .MedianPing=L[(T+1)/2];else  tbl11 .MedianPing=(L[T/2]+L[T/2+1])*0.5;end;T=1-math.exp(- max (R or 0.1,0)/ tbl11 .PingSmoothingSeconds);if  tbl11 .SmoothPing then  tbl11 .SmoothPing= tbl11 .SmoothPing+(l[1]- tbl11 .SmoothPing)*T;else  tbl11 .SmoothPing= tbl11 .MedianPing;end;end,
								SamplePing = function(R,R)if R- tbl11 .LastPingSample>=0.1 then  tbl11 .LastPingSample=R;local l,T= tbl11 :GetRoundTrip();if type(l)~="number"or l~=l or l<=0 or l== huge then return;end;local L= tbl11 .LastValidPingSample and R- tbl11 .LastValidPingSample or 0.1; tbl11 .LastValidPingSample=R;if T~= tbl11 .PingSource or L>0.5 then  tbl11 .PingHistory={}; tbl11 .SmoothPing=nil; tbl11 .MedianPing=nil; tbl11 .PingSource=T;end; insert2 ( tbl11 .PingHistory,1,l);while# tbl11 .PingHistory>3 do table.remove( tbl11 .PingHistory);end; tbl11 :RefreshPingStats(L);end;end,
								Pcall = function(R,R,...)return  v88 (R,...);end,
								Xpcall = function(R,R,l)return  v90 (R,l or function(R)return  tbl11 :ErrHandler(R);end);end,
								ErrHandler = function(n,n)end,
							}
						end

						local tbl28, tbl29, v90, tbl30, tbl31

						do
							local tbl32, index, fn32

							do
								do
									tbl32 = {
										StudsPerMetre = 20,
										Gravity = -v85[176],
										LongUiStepsPerSecond = 30,
										UiStepsPerSecond = v85[49],
										WorldStepsPerLongUiStep = 8,
										WorldStepsPerUiStep = 4,
										WorldStepsPerSecond = 240,
										KernelStepsPerWorldStep = 19,
										KernelStepsPerSecond = 4560,
										WorldDeltaTime = 0.0041666666666666666,
										KernelDeltaTime = 0.00021929824561403509,
										AngularDampingKernel = 0.9998,
										AngularDampingWorld = 0.99621,
										AltitudeP = 30000,
										AltitudeD = 1100,
										MoveP = v85[27],
										MovePForPgs = 150,
										TurnP = 7500,
										TurnPForRotatePgs = 450,
										TurnPForFreeFallPgs = 375,
										TurnTorqueMax = v85[144],
										MaxMoveForceY = 10000,
										MinMoveForceY = v85[64],
										MaxLinearMoveForce = 143,
										MaxLinearGroundMoveForce = v85[90],
										BalanceP = 2250,
										BalanceD = 50,
										BalanceMaxTorqueComponent = 4000,
										JumpP = v85[90],
										JumpVelocityGrid = 50,
										JumpTimer = v85[86],
										FreefallTurnSpeed = 6,
										FreefallTurnSpeedPgs = v85[152],
										FreefallVelocityDecay = 0.05,
										FloorVelocityInfluence = v85[43],
										CharacterVelocityInfluence = 0,
										AutoTurnSpeed = 8,
										FallDelay = v85[54],
										MinMoveVelocity = 0.5,
										MaxClimbDistance = 2.45,
										DefaultWalkSpeed = 16,
										DefaultJumpPower = 50,
										DefaultMaxSlopeAngle = 89,
										DefaultHipHeight = v85[64],
										FloorBaseDistance = v85[196],
										FloorHysteresisGrounded = 1.5,
										FloorHysteresisAirborne = 1.1,
										FloorVelocityHysteresisThreshold = v85[100],
										TorsoHalfSizeScale = 0.4,
										MaxCatchUpSteps = 32,
										MaxPredictionSeconds = v85[109],
										GroundAcceleration = 725,
										AirAccelerationScale = v85[189],
										DefaultJumpHeight = 7.2,
										MaxGhostDistance = 1000,
										MaxObservedSpeed = v85[67],
										MaxObservedJump = v85[4],
										MaxObservedGap = 0.1,
									}

									local function fn33()local R= Workspace .Gravity;if R~=R or R<=0 then return  tbl32 .Gravity;end;return-R;end
								end

								do
									local tbl33 = { v85[64], 1, -v85[196], v85[109], -2 }

									local tbl34 = {
										Running = v85[42],
										Freefall = v85[134],
										Jumping = v85[112],
										Landed = v85[11],
										Floating = v85[155],
									}

									local tbl35 = {
										[Enum.HumanoidStateType.Jumping] = tbl34.Jumping,
										[Enum.HumanoidStateType.Freefall] = tbl34.Freefall,
										[Enum.HumanoidStateType.Landed] = tbl34.Landed,
										[Enum.HumanoidStateType.Running] = tbl34.Running,
										[Enum.HumanoidStateType.RunningNoPhysics] = tbl34.Running,
										[Enum.HumanoidStateType.Swimming] = tbl34.Floating,
										[Enum.HumanoidStateType.Climbing] = tbl34.Floating,
										[Enum.HumanoidStateType.Seated] = tbl34.Floating,
									}

									local function fn33(n)local R=n%6.283185307179586;return if R>3.141592653589793 then R-6.283185307179586 else R;end
									local function fn34(R)return  atan2 (-R.X,-R.Z);end
									local function fn35(R)local l=R.X*R.X+R.Y*R.Y+R.Z*R.Z;if l<1.0E-12 then return  vector4 ;end;return R/ sqrt (l);end
									index = {}
									index.__index = index
									index.New = function(...) end
									index.RefreshCharacterMetrics = function(...) end
									index.GetCharacterHipHeight = function(n)if n.IsR15 then return n.HipHeight+0.5*n.RootPart.Size.Y;end;return 0.5*n.RootPart.Size.Y+n.LegHeight+n.HipHeight;end
									index.SenseFloor = function(R)local l=R.Floor;local T=R.TorsoHalfSize;local L=if l.Found then  tbl32 .FloorHysteresisGrounded else  tbl32 .FloorHysteresisAirborne;local X= abs (R.Velocity.Y);local Q= tbl32 .FloorBaseDistance+(if X> tbl32 .FloorVelocityHysteresisThreshold then L+X/ tbl32 .FloorVelocityHysteresisThreshold else L)*R.LegHeight+(if X> tbl32 .FloorVelocityHysteresisThreshold then L+X/ tbl32 .FloorVelocityHysteresisThreshold else L)*R.HipHeight;local X= cframe3 (R.Position)* cframe2 (0,R.Heading,0);local z,Y,U,_,E,Z,x= vector5 *Q,R.RaycastParameters,0.3,0,0,0;local j=Vector3.yAxis;for s=1,# tbl33 ,1 do L= tbl33 [s];Q= Workspace :Raycast(X* vector3 (0,-T.Y,L*T.Z),z,Y);if Q then R=Q.Position.Y;E+=1;Z+=R;if not x and  abs (L)<2 then x,j=Q.Instance,Q.Normal;end;if s>=2 and j.Y>0.999 and  abs (R-Z/E)<0.001 then break;end;end;end;if E==0 then for Q=-1,1,2 do for s=-1,1,2 do R= Workspace :Raycast(X* vector3 (Q*T.X,-T.Y,s*T.Z),z,Y);if R then E+=1;Z+=R.Position.Y;if not x then x,j=R.Instance,R.Normal;end;end;end;end;end;local R=nil;if x then L=x.CustomPhysicalProperties;R,_,U=x.AssemblyLinearVelocity,x.AssemblyAngularVelocity.Y,if L then L.Friction else 0.3;else R= vector4 ;end;l.Found=E>0;if E>0 then l.Height=Z/E;else l.Height=0;end;l.Normal=j;l.Friction=U;l.Velocity=R;l.AngularVelocityY=_;return l;end
									index.RefreshDesiredVelocity = function(R)local l=R.Humanoid;local T=l.MoveDirection;local L= fn35 ( vector3 (T.X,0,T.Z));local X=l.WalkSpeed;if not R.IsLocal then T=R.Velocity;local Q= vector3 (T.X,0,T.Z);local T=Q.Magnitude;if L== vector4 then if T> tbl32 .MinMoveVelocity then X,L=T,( fn35 (Q));end;else X=if T>X then T else X;end;end;local T,Q=L*X,0;if l.AutoRotate and L~= vector4 then X= fn33 ( fn34 (T)-R.Heading);Q= tbl32 .AutoTurnSpeed*X;end;R.DesiredLinear=T;R.DesiredRotationalY=Q;end
									index.AccumulateRunningAcceleration = function(...) end
									index.ComputeHorizontalAcceleration = function(R,l,T,L,X)local Q=l.X-T.X;local z=l.Z-T.Z;l= sqrt (Q*Q+z*z);if l<1.0E-6 then return 0,0;end;local Y=R.GroundAcceleration;Y=if not X then Y* tbl32 .AirAccelerationScale else Y;T=l/L;L=(if Y>T then T else Y)/l;return Q*L,z*L;end
									index.AccumulateFreefallAcceleration = function(R,l)local T,L=R:ComputeHorizontalAcceleration(R.DesiredLinear,R.Velocity,l,false);return  vector3 (T,0,L);end
									index.GetJumpVelocity = function(...) end
									index.ApplyJumpImpulse = function(R)local l=R:GetJumpVelocity();local T=R.Velocity;R.Velocity= vector3 (T.X,l,T.Z);R.JumpFinished=true;end
									index.UpdateState = function(R,l)local T,L=R.Floor,R.StateName;R.StateTimer=R.StateTimer-l;if T.Found then R.NoFloorTimer=0;else R.NoFloorTimer=R.NoFloorTimer+l;end;if L== tbl34 .Jumping then if not T.Found or R.StateTimer<=0 then R.StateName= tbl34 .Freefall;end;return;end;if R.Humanoid.Jump and R:GetJumpVelocity()>0 and(L== tbl34 .Running or L== tbl34 .Landed)then if not R.Anchored then R:ApplyJumpImpulse();end;R.StateName= tbl34 .Jumping;R.StateTimer= tbl32 .JumpTimer;return;end;if T.Found then R.StateName= tbl34 .Running;elseif R.NoFloorTimer> tbl32 .FallDelay then R.StateName= tbl34 .Freefall;end;end
									index.IntegrateFreeFall = function(...) end
									index.IntegrateEuler = function(...) end
									fn32 = function(R,l,T,L,X,Q)if type(Q)~="number"or Q~=Q or Q<=0 or Q== huge then return 0,0;end;X=if type(X)~="number"or X~=X or X== huge then 0 else X;local z=T-R;local Y=L-l;local U= sqrt (z*z+Y*Y);if U<1.0E-6 or X<=0 then return R*Q,l*Q;end;local n=U/X;n=if n>Q then Q else n;local _,E,Z=z/U,Y/U,0.5*n*n;z,Y,U=R*n+_*X*Z,l*n+E*X*Z,Q-n;if U>0 then z+=T*U;Y+=L*U;end;return z,Y;end
									index.Predict = function(...) end
									index.Calibrate = function(R,l)if R.CalibrationSamples>=600 then return;end;local l,T=R.RootPart.AssemblyLinearVelocity,R.LastObservedVelocity;local L=l.X-T.X;local X=l.Z-T.Z;T= sqrt (L*L+X*X);if T<=0 then return;end;L=os.clock();X=L-(R.LastVelocityChange or L);R.LastObservedVelocity=l;R.LastVelocityChange=L;if not R.Floor.Found then return;end;if X<=1.0E-4 or X> tbl32 .MaxObservedGap then return;end;if T<1*X then return;end;if(R.DesiredLinear- vector3 (l.X,0,l.Z)).Magnitude<1 then return;end;L=T/X;if L<=0 or L>10000 then return;end;R.GroundAcceleration=R.GroundAcceleration+(L-R.GroundAcceleration)*0.02;if R.GroundAcceleration< tbl32 .GroundAcceleration then R.GroundAcceleration= tbl32 .GroundAcceleration;end;R.CalibrationSamples=R.CalibrationSamples+1;end
									index.AnchorToLive = function(R,l)local T=R.RootPart;local L=T.Position;R.Position=L;R.Heading= fn34 (T.CFrame.LookVector);R.AngularVelocityY=T.AssemblyAngularVelocity.Y;local X=T.AssemblyLinearVelocity;if R.IsLocal then R.Velocity=X;else local Q=os.clock();local z=L~=R.LastObservedPosition;local Y=X.Magnitude;R.Velocity=if Y> tbl32 .MaxObservedSpeed then X*( tbl32 .MaxObservedSpeed/Y)else X;if z then R.LastObservedPosition=L;R.LastObservedTime=Q;end;end;R:SenseFloor();X=R.Humanoid;T,L=pcall(X.GetState,X);if T then X= tbl35 [L];R.StateKnown=X~=nil;R.StateName=if not X then R.Floor.Found and  tbl34 .Running or  tbl34 .Freefall else X;else R.StateKnown=false;R:UpdateState(l);end;R:RefreshDesiredVelocity();end
									index.Resolve = function(R,l)local l=R.Humanoid;if not l then return R.Velocity,false;end;local T=l.WalkSpeed;local L=R.Velocity;local X=R.DesiredLinear;local Q,z= vector3 (L.X,0,L.Z), vector3 (X.X,0,X.Z);local Y,U=Q.Magnitude,z.Magnitude;if Y>3000 then Q*=3000/Y;Y,L=3000,( vector3 (Q.X,L.Y,Q.Z));end;local _=false;local E=R.LastObservedVelocity;local Z=nil;if E then l=os.clock();local x,j= max (l-(R.LastObservedTime or l),1.0E-4),Q- vector3 (E.X,0,E.Z);if j.Magnitude/x>500 and U>1 then if  fn35 (j):Dot(z.Unit)<0.5 then _,Z=true,( vector3 (X.X,L.Y,X.Z));else Z=L;end;else Z=L;end;else Z=L;end;if not _ then if Y> max ( max (T,30)*1.5,50)then if U>1 then if Q.Unit:Dot(z.Unit)<0.6 then _,Z=true,( vector3 (X.X,L.Y,X.Z));else _,Z=true,L;end;else _,Z=true,L;end;end;end;return Z,_;end
								end
							end

							do
								do
									tbl28 = {
										CharacterPartCache = {},
										CharacterPartConnections = {},
										FOVSplitCache = {},
										PredictionCache = fn29({}, { __mode = "k" }),
										VelocityCache = {},
										PositionCache = {},
										VelocityHistory = {},
										EngineTrackers = {},
										LeadSmooth = {},
										MuzzleSourceCache = fn29({}, { __mode = "k" }),
										VisFilterList = { nil, nil },
										GroundFilterList = { nil, nil },
										GroundRayParams = raycastParams(),
										SilentFOVLines = {},
										TriggerFOVLines = {},
										CameraDeadzoneLines = {},
										FovHiddenState = { Silent = v85[74], Trigger = false, Camera = false },
										CameraFOVLines = {},
									}

									do
										local v91 = raycastParams()
										v91.FilterType = Enum.RaycastFilterType.Exclude
										v91.IgnoreWater = true
									end
								end

								do
									local flag18 = true
									local mainModule = ReplicatedStorage:FindFirstChild("MainModule") and ReplicatedStorage.MainModule:FindFirstChild(v85[156])

									if mainModule then
										mainModule.ChildAdded:Connect(function()
											flag18 = true
										end)

										mainModule.ChildRemoved:Connect(function()
											flag18 = true
										end)
									end
								end
							end

							do
								do
									tbl28.LastClosestPart = fn29({}, { __mode = "k" })
									tbl28.PartStickiness = 14
									tbl28.GetClosestPart = function(...) end
									tbl28.GetClosestPointOnPart = function(...) end
									raycastParams().FilterType = include
									tbl28.GetClosestPointOnPartBasic = function(...) end
									tbl28.GetMuzzlePosition = getMuzzlePos
									tbl28.GroundRayParams.FilterType = exclude
									tbl28.GetGroundY = function(R,R,l)if not R then return 0;end;local T=0;if  localPlayer .Character then  tbl28 .GroundFilterList[1]= localPlayer .Character;T=1;end;if l then T+=1; tbl28 .GroundFilterList[T]=l;end;for L=T+1,# tbl28 .GroundFilterList,1 do  tbl28 .GroundFilterList[L]=nil;end; tbl28 .GroundRayParams.FilterDescendantsInstances= tbl28 .GroundFilterList;l= Workspace :Raycast(R, vector3 (0,-1000,0), tbl28 .GroundRayParams);return l and l.Position.Y or R.Y;end
									index.Track = function(R,R,l)if not l then return nil;end;local T=R[l];if not(T and T.RootPart and T.RootPart.Parent and T.Humanoid and T.Humanoid.Parent)then local L,X=pcall( index .New, index ,l);if not L or not X then R[l]=nil;return nil;end;R[l]=X;T=X;end;l= tbl24 .FrameStamp or 0;if T.AnchorFrame~=l then T.AnchorFrame=l;R= tbl24 .FrameTime or 0;pcall(T.RefreshCharacterMetrics,T);pcall(T.Calibrate,T,R);pcall(T.AnchorToLive,T,R);end;return T;end

									tbl28.YAxis = {
										Modes = {
											[v85[40]] = { Factor = 0.7 },
											["very legit"] = { Factor = 0.35 },
											half = { Factor = 0.5 },
											full = { Factor = v85[196], Clamp = nil },
										},
										SanityClamp = 6,
										GroundedEpsilon = v85[86],
									}

									tbl28.ResolveYAxisMode = function(R,R)local l,T= tbl28 .YAxis.Modes,R["Y Axis"];if type(T)=="string"then local n=l[T:lower()];if n then return n;end;return nil;end;if T==true then return l.full;end;if type(T)=="number"and T>0 then return l.full;end;T=R["Y Stabilizer"];if type(T)=="number"and T>0 then return l.full;end;return nil;end
									tbl28.ApplyYMode = function(R,R,l,T,L)if type(T)~="number"or T~=T or  abs (T)== huge then return 0;end;local X=L and T or T*(R and R.Factor or 1);if l and R and R.Clamp then local T=(( originalSizes [l]or l.Size).Y+2)*R.Clamp;X=( clamp (X,-T,T));end;return X;end
									tbl28.TickStrafeSample = function(R)if not  tbl28 .AutoSampleTime then return;end;local R= tbl24 .State.Targets.SilentAim;local l=R and R.Character;if not l then return;end;R= index :Track( tbl28 .EngineTrackers,l);if not R then return;end; tbl28 :PushVelocitySample(l,R.Velocity, clock ());end
									tbl28.ConsistencyWindow = v85[66]
									tbl28.ConsistencyFloor = v85[139]
									tbl28.ConsistencySpacing = v85[199]
									tbl28.PushVelocitySample = function(R,R,l,T)if not R or not l then return nil;end;local L= tbl28 .VelocityHistory[R];if not L then L={}; tbl28 .VelocityHistory[R]=L;end;R=L[#L];if R and T-R.T+1.0E-6< tbl28 .ConsistencySpacing then return L;end; insert2 (L,{T=T,X=l.X,Z=l.Z});while#L>0 and T-L[1].T> tbl28 .ConsistencyWindow do  remove2 (L,1);end;return L;end
									tbl28.DirectionConsistency = function(R,R)local l=R and  tbl28 .VelocityHistory[R];if not l or#l<4 then return 1;end;local T=0;local L=0;local X=0;for Q=1,#l,1 do R=l[Q];Q= sqrt (R.X*R.X+R.Z*R.Z);if Q>1 then T,L,X=T+R.X,L+R.Z,X+Q;end;end;if X<=1.0E-6 then return 1;end;local R= tbl28 .ConsistencyFloor;local l= sqrt (T*T+L*L)/X;return  clamp (R+(1-R)*l,R,1);end

									tbl28.AutoLead = {
										HorizontalScale = 1.05,
										InterpolationDelay = 0.02,
										FrameFactor = 0.5,
										SendTick = 0.033333333333333333,
										ServerTick = v85[199],
										QueueFactor = v85[86],
										ViewAge = 0.5,
										InterpBuffer = 1,
										RepIntervalMax = 0.05,
										RepAlpha = 0.1,
										RepMergeRatio = 1.75,
										RepMinGapDecay = 1.002,
										MaxPingLead = 1,
										LeadMargin = v85[196],
										RepIntervalPrior = 0.033333333333333333,
									}

									tbl28.RepIntervals = {}
									tbl28.RepGlobal = v85[91]
									tbl28.RepGlobalAlpha = v85[195]
									tbl28.RepFloor = function(R)local R= tbl28 .FrameTimeEMA or  tbl24 .FrameTime;local l=type(R)~="number"or R~=R or R<=0;return  clamp (if(if l then 0.016666666666666666 else R)<0.016666666666666666 then 0.016666666666666666 else if l then 0.016666666666666666 else R,0.016666666666666666, tbl28 .AutoLead.RepIntervalMax);end
									tbl28.SampleRepInterval = function(R,R,l,T)if not R or not l then return  tbl28 .RepGlobal;end;local L,X=l.AssemblyLinearVelocity, tbl28 .RepIntervals[R];l=X;if not X then X={Interval= tbl28 .RepGlobal,LastVX=L.X,LastVY=L.Y,LastVZ=L.Z,LastTick=T}; tbl28 .RepIntervals[R]=X;return X.Interval;end;if L.X~=l.LastVX or L.Y~=l.LastVY or L.Z~=l.LastVZ then R=T-l.LastTick;if R>1.0E-4 and R<= tbl28 .AutoLead.RepIntervalMax then X=l.PrevGap and( max (R,l.PrevGap))or R;l.PrevGap=R;local Q=l.MinGap and( min (X,l.MinGap* tbl28 .AutoLead.RepMinGapDecay))or X;l.MinGap=Q;local X= clamp (R/(if R>Q* tbl28 .AutoLead.RepMergeRatio then( floor2 (R/Q+0.5))else 1), tbl28 :RepFloor(), tbl28 .AutoLead.RepIntervalMax);l.Interval=l.Interval+(X-l.Interval)* tbl28 .AutoLead.RepAlpha; tbl28 .RepGlobal= tbl28 .RepGlobal+(X- tbl28 .RepGlobal)* tbl28 .RepGlobalAlpha;end;l.LastVX,l.LastVY,l.LastVZ=L.X,L.Y,L.Z;l.LastTick=T;end;return l.Interval;end
									tbl28.ComputeAutoLead = function(R,R,R,R,R,R)local l= tbl28 .AutoLead;R=tonumber(R);R= max (if not R or R~=R or  abs (R)== huge then 1 else R,0);local T= tbl28 .FrameTimeEMA or  tbl24 .FrameTime or 0.016666666666666666;T=if T~=T or T<=0 or T== huge then 0.016666666666666666 else T;local L= tbl11 :GetMedianPing()or 0;local X,Q,z= min (if L~=L or L<0 then 0 else L,l.MaxPingLead),T*l.FrameFactor,(l.SendTick+l.ServerTick)*l.QueueFactor;T=(X+l.InterpolationDelay+Q+(if  tbl11 .PingSource=="Data"then 0 else z))*l.LeadMargin*R;if T~=T or T~=T then return 0,0;end;return  clamp (T,0, tbl32 .MaxPredictionSeconds), clamp (T,0, tbl32 .MaxPredictionSeconds);end
									tbl28.IsFiniteVector = function(R,R)return R and R.X==R.X and R.Y==R.Y and R.Z==R.Z and  abs (R.X)< huge and  abs (R.Y)< huge and  abs (R.Z)< huge ;end
									tbl28.LandingCache = fn29({}, { __mode = v85[166] })
									tbl28.VerticalRayParams = raycastParams()
									tbl28.VerticalRayParams.FilterType = exclude
									tbl28.VerticalRayParams.RespectCanCollide = true
									tbl28.VerticalFilter = { nil, nil }
									tbl28.IsGrounded = function(R,R,l,T,L)if L then local X=L.Floor;return X.Found and X.Normal.Y>0.5 and R.Position.Y-X.Height<=T+0.15;end;if not l or l.FloorMaterial==Enum.Material.Air then return false;end;l= Workspace :Raycast(R.Position, vector3 (0,-(T+0.15),0), tbl28 .VerticalRayParams);return l~=nil and l.Normal.Y>0.5;end
									tbl28.VerticalDisplacement = function(R,R,l,T,L,X,Q,z)if L<=0 then return 0;end;local Y=R:FindFirstChildOfClass("Humanoid");local U= abs (T.Y)>= tbl28 .YAxis.GroundedEpsilon;if Y then local _,E=pcall(Y.GetState,Y);U=if _ then E==Enum.HumanoidStateType.Freefall or E==Enum.HumanoidStateType.Jumping or(E==Enum.HumanoidStateType.Running or E==Enum.HumanoidStateType.RunningNoPhysics)and Y.FloorMaterial==Enum.Material.Air else U;end;local _=T.Y*L;local E= originalSizes [l]or l.Size;local Z=(Y and Y.HipHeight or 0)+E.Y*0.5;if Y and Y.RigType==Enum.HumanoidRigType.R6 then E=R:FindFirstChild("Left Leg");Z=if E then Z+( originalSizes [E]or E.Size).Y else Z;end;local E= tbl28 .VerticalFilter;E[1],E[2]=R, localPlayer .Character; tbl28 .VerticalRayParams.FilterDescendantsInstances=E;if  abs (T.Y)< tbl28 .YAxis.GroundedEpsilon and( tbl28 :IsGrounded(l,Y,Z,z))then return 0;end;if not U then return _;end;local R= Workspace .Gravity;if R~=R or R<0 or R== huge then return _;end;_-=0.5*R*L*L;if _>=0 then return _;end;local R=X or L;local L=l.Position+ vector3 (T.X*R,0,T.Z*(Q or R));Y,E= clock (), tbl28 .LandingCache[l];if not E or Y-E.Time>=0.05 or(L-E.Origin).Magnitude>0.5 then Q= Workspace :Raycast(L, vector3 (0,-1000,0), tbl28 .VerticalRayParams);Q,E=if Q and Q.Normal.Y<=0.5 then nil else Q,E or{};E.Time,E.Origin,E.Height=Y,L,Q and Q.Position.Y or nil; tbl28 .LandingCache[l]=E;end;if E.Height then local R=E.Height+Z-l.Position.Y;_=if R<=0 then( max (_,R))else _;end;return _;end
									tbl28.AutoVelocityCache = fn29({}, { __mode = "k" })
									tbl28.AutoTargets = fn29({}, { __mode = "k" })
									tbl28.ResetAutoTarget = function(R,R,l,T,L)local X= tbl28 .AutoTargets[R];if X and X.Character==l and X.Root==T then return;end;if X then local Q= tbl28 .PredictionCache[X.Character];if Q then Q[R]=nil;end;end; tbl28 .AutoTargets[R]={Character=l,Root=T};X= tbl28 .PredictionCache[l];if X then X[R]=nil;end; tbl28 .LandingCache[T]=nil;l= tbl28 .AutoVelocityCache[T];if l and L-l.Time>0.1 then  tbl28 .AutoVelocityCache[T]=nil;end;end
									tbl28.FitAutoWindow = function(R,R,l,T)local L=R[l];local X=T-l+1;if not L or X<2 then return  vector4 ,0;end;local Q=0;local z= vector4 ;for Y=l,T,1 do Q+=R[Y].Time-L.Time;local U=R[Y].Position-L.Position;z+= vector3 (U.X,0,U.Z);end;Q/=X;z/=X;local Y,U,_=0, vector4 ,0;for E=l,T,1 do local l,T=R[E].Time-L.Time-Q,R[E].Position-L.Position;X= vector3 (T.X,0,T.Z)-z;Y,U,_=Y+l*l,U+X*l,_+X:Dot(X);end;if Y<=1.0E-8 then return  vector4 ,0;end;local R=U/Y;if not  tbl28 :IsFiniteVector(R)then return  vector4 ,0;end;return R,_>1.0E-8 and( clamp (U:Dot(U)/(Y*_),0,1))or 0;end

									tbl28.SpeedResolver = {
										SampleInterval = 0.016666666666666666,
										Window = 0.16,
										MinimumWindow = 0.1,
										StaleTime = 0.25,
										GainTime = 0.06,
										NoiseBand = v85[154],
										MinimumQuality = 0.95,
									}

									tbl28.FitAutoSpeedRatio = function(R,R,l,T)local L,X,Q,z={},{},R[l],T-l+1;if z<3 then return nil,0;end;local Y,U,_= vector4 , vector4 , vector4 ;for E=l,T,1 do local Z=R[E];if not Z.Reported then return nil,0;end;if E>l then local x=R[E-1];local j=Z.Time-x.Time;if j<=0 or j>0.05 then return nil,0;end;Y+=(x.Reported+Z.Reported)*(j*0.5);end;local x=Z.Position-Q.Position;E= vector3 (x.X,0,x.Z); insert2 (L,Y); insert2 (X,E);U,_=U+Y,_+E;end;U/=z;_/=z;Y,T,Q=0,0,0;for E=1,z,1 do R,l=L[E]-U,X[E]-_;Y,T,Q=Y+R:Dot(l),T+R:Dot(R),Q+l:Dot(l);end;if T<=1.0E-6 or Q<=1.0E-6 or Y<=0 then return nil,0;end;local R=Y/T;L= clamp (Y*Y/(T*Q),0,1);if R~=R or R== huge then return nil,0;end;return R,L;end
									tbl28.ResolveAutoVelocity = function(R,R,l,T)local L=R.Position;if not  tbl28 :IsFiniteVector(L)or not  tbl28 :IsFiniteVector(l)then return  vector4 ;end;local X= tbl28 .SpeedResolver;local Q= vector3 (l.X,0,l.Z);local z,Y=Q.Magnitude, tbl28 .AutoVelocityCache[R];if not Y or T<Y.Time or T-Y.Time>X.StaleTime then Y={Position=L,Time=T,Samples={},Gain=1,Confidence=0}; tbl28 .AutoVelocityCache[R]=Y;end;R=Y.LastReported;if R and R.Magnitude>1 and z>1 and R:Dot(Q)<0.95*R.Magnitude*z or z<=1 then Y.Samples={};Y.Gain=1;Y.Confidence=0;Y.Position=L;Y.Time=T;end;Y.LastReported=Q;local U=T-Y.Time;local _=Y.Samples;if#_==0 or U+1.0E-6>=X.SampleInterval then local E=L-Y.Position;local Z= sqrt (E.X*E.X+E.Z*E.Z);E= max (z,R and R.Magnitude or z)* max (U,0);if U>0 and(U>0.05 or Z> max (25,E*4))then _={};Y.Samples=_;Y.Gain=1;Y.Confidence=0;end; insert2 (_,{Position=L,Time=T,Reported=Q});while#_>9 or#_>2 and T-_[1].Time>X.Window do table.remove(_,1);end;Y.Position=L;Y.Time=T;Y.Confidence=0;Z=1;if#_>=5 and T-_[1].Time>=X.MinimumWindow then E= floor2 ((#_+1)/2);local R,T= tbl28 :FitAutoSpeedRatio(_,1,E);local L,x= tbl28 :FitAutoSpeedRatio(_,E,#_);local j= tbl28 :FitAutoWindow(_,E,#_);local s=z>1 and j.Magnitude>1 and j:Dot(Q)>=0.95*j.Magnitude*z;if R and L and T>=X.MinimumQuality and x>=X.MinimumQuality and  abs (R-L)<= max (R,L)*X.NoiseBand and s then Y.Confidence= min (T,x);j= tbl28 :FitAutoSpeedRatio(_,1,#_);Z=if j and  abs (j-1)>X.NoiseBand then j else Z;end;end;if Y.Confidence==0 then Y.Gain=1;else E=1-math.exp(- max (U,0)/X.GainTime);Y.Gain=Y.Gain+(Z-Y.Gain)*E;end;end;Y.Mode=Y.Confidence>0 and  abs (Y.Gain-1)>0.001 and"SpeedCorrected"or"Reported";X=Q*Y.Gain;X=if not  tbl28 :IsFiniteVector(X)then Q else X;Y.LastResolved=X;return  vector3 (X.X, clamp (l.Y,- tbl32 .MaxObservedSpeed, tbl32 .MaxObservedSpeed),X.Z);end
									tbl28.AutoSampleRange = function(R,R)if type(R)~="table"or not R.Enabled then return 0;end;local l=R.Prediction;if type(l)~="table"then return 0;end;local T=l.Enabled;if not(if T==nil then l[1]~=nil and l[2]~=nil and l[3]~=nil else T)then return 0;end;T=l["Auto Prediction"];local L=if type(T)=="table"then T.Enabled else nil;if not(if L==nil then l.Auto else L)then return 0;end;local l=tonumber(R.Range)or 1000;return  max (if l~=l then 1000 else l,0);end
									tbl28.SampleAutoCandidates = function(...) end
									tbl28.PredictionReadout = { Enabled = false, Interval = v85[187] }
									tbl28.PredictionReadoutTimes = fn29({}, { __mode = "k" })
									tbl28.PredictionErrorHistory = fn29({}, { __mode = "k" })
									tbl28.SamplePredictionError = function(R,R,l,T,L,X,Q)local z,Y= tbl28 .PredictionErrorHistory[R],l.Position;if not z or z.Root~=l or X<z.Time or X-z.Time>0.25 then z={Root=l,Time=X,Position=Y,Pending={}}; tbl28 .PredictionErrorHistory[R]=z;end;l=X-z.Time;while#z.Pending>0 and z.Pending[1].Due<=X do R=table.remove(z.Pending,1);if l>0 and l<=0.05 and R.Due>=z.Time then local U= clamp ((R.Due-z.Time)/l,0,1);local _=z.Position+(Y-z.Position)*U-R.Expected;z.Forward=_.X*R.X+_.Z*R.Z;z.Side=-_.X*R.Z+_.Z*R.X;z.ErrorTime=X;end;end;z.Position=Y;z.Time=X;l= sqrt (T.X*T.X+T.Z*T.Z);if Q and L>0 and l>1 then local R,Q={Due=X+L,Expected=Y+ vector3 (T.X*L,0,T.Z*L),X=T.X/l,Z=T.Z/l},#z.Pending+1;while Q>1 and z.Pending[Q-1].Due>R.Due do Q-=1;end;table.insert(z.Pending,Q,R);while#z.Pending>32 do table.remove(z.Pending,1);end;end;if z.ErrorTime and X-z.ErrorTime<=0.25 then return string.format("Client error forward %+.2f side %+.2f",z.Forward,z.Side);end;return"Client error waiting";end
									tbl28.PrintPredictionReadout = function(...) end
									tbl28.ManualMotionCache = fn29({}, { __mode = "k" })
									tbl28.ManualLeadScale = 0.98
									tbl28.ResolveManualDirection = function(R,R,l,T)local L= clock ();local X=l.Position;if not  tbl28 :IsFiniteVector(X)then return T;end;local Q= tbl28 .ManualMotionCache[l];local z=Q;if not Q or L-Q.Time>0.15 or L<Q.Time then  tbl28 .ManualMotionCache[l]={Time=L,Position=X,Samples={{T=L,P=X}}};return T;end;l=L-z.Time;if l>=0.016666666666666666 then if(X-z.Position).Magnitude> tbl32 .MaxObservedSpeed*l+2 then z.Samples={};z.Observed=nil;end;z.Time=L;z.Position=X;Q=z.Samples;Q[#Q+1]={T=L,P=X};while#Q>6 or#Q>1 and L-Q[1].T>0.1 do table.remove(Q,1);end;z.Observed=nil;if#Q>=3 and L-Q[1].T>=0.025 then local Y=0;local U= vector4 ;for _,_ in ipairs(Q)do Y,U=Y+(_.T-L),U+(_.P-X);end;Y/=#Q;U/=#Q;local _,E= vector4 ,0;for Z,x in ipairs(Q)do Z=x.T-L-Y;_,E=_+(x.P-X-U)*Z,E+Z*Z;end;if E>1.0E-8 then z.Observed=_/E;end;end;end;X,l=R:FindFirstChildOfClass("Humanoid"),z.Observed;if not X or not l or not  tbl28 :IsFiniteVector(l)then return T;end;Q=X.MoveDirection;if not  tbl28 :IsFiniteVector(Q)then return T;end;z,X,L= vector3 (T.X,0,T.Z), vector3 (l.X,0,l.Z), vector3 (Q.X,0,Q.Z);l,Q,R=z.Magnitude,X.Magnitude,L.Magnitude;if l<0.5 or Q<0.5 or R<0.1 then return T;end;R=L.Unit:Dot(X.Unit);X= abs (Q-l)/ max (Q,l);if R<0.85 or X>0.25 or L.Unit:Dot(z.Unit)<0.5 then return T;end;Q=0.25* clamp ((R-0.85)/0.15,0,1)*(1-X/0.25);X=z.Unit*(1-Q)+L.Unit*Q;if X.Magnitude<1.0E-6 then return T;end;X=X.Unit*l;return  vector3 (X.X,T.Y,X.Z);end
									tbl28.GetPredictedPosition = function(...) end
									tbl28.GetConfiguredHitPart = function(...) end

									tbl27.VoidFallsClientRedirection = {
										Hooked = v85[74],
										FireQueue = {},
										FireWindow = 0.1,
										MuzzleMaxDist = 20,
										AimDotMin = 0.85,
										AttachmentMinDist = 1,
										RestoreFrames = 2,
										ClampRadius = 4,
									}

									tbl27.VoidFallsClientRedirection.ClampToBody = function(...) end
									tbl27.VoidFallsClientRedirection.MarkFired = function(...) end
									tbl27.VoidFallsClientRedirection.OnFire = function(...) end
									tbl27.VoidFallsClientRedirection.HandlePart = function(...) end

									tbl27.VoidFallsClientRedirection.Init = function()
										error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:10)")
									end

									tbl27.HookTool = function(...) end
									tbl28.IsVisible = function(...) end
									tbl28.GetSplitFOV = function(...) end
									tbl28.IsMouseInBoxFOV = function(...) end
									tbl28.IsMouseInSilentFOV = function(R,R)return  tbl28 :IsMouseInBoxFOV("Silent Aimbot",R,false);end
									tbl28.IsMouseInTriggerFOV = function(R)return  tbl28 :IsMouseInBoxFOV("Trigger Bot",nil,false);end
									tbl28.CurveBlocked = function(...) end

									local tbl33 = {
										SilentActive = BrickColor.new(v85[13]),
										SilentInactive = BrickColor.new("Really red"),
										TriggerActive = BrickColor.new(v85[93]),
										TriggerInactive = BrickColor.new(v85[185]),
										LineActive = Color3.fromRGB(v85[7], v85[64], 0),
										LineInactive = Color3.fromRGB(255, v85[7], v85[7]),
									}
								end

								tbl28.CreateFOVLines = function(R)for R=1,8,1 do if not  tbl28 .SilentFOVLines[R]then  tbl28 .SilentFOVLines[R]= new ("Line"); tbl28 .SilentFOVLines[R].Thickness=2; tbl28 .SilentFOVLines[R].Transparency=1; tbl28 .SilentFOVLines[R].Visible=true;end;if not  tbl28 .TriggerFOVLines[R]then  tbl28 .TriggerFOVLines[R]= new ("Line"); tbl28 .TriggerFOVLines[R].Thickness=2; tbl28 .TriggerFOVLines[R].Transparency=1; tbl28 .TriggerFOVLines[R].Visible=true;end;if not  tbl28 .CameraFOVLines[R]then  tbl28 .CameraFOVLines[R]= new ("Line"); tbl28 .CameraFOVLines[R].Thickness=2; tbl28 .CameraFOVLines[R].Transparency=1; tbl28 .CameraFOVLines[R].Visible=true;end;if not  tbl28 .CameraDeadzoneLines[R]then  tbl28 .CameraDeadzoneLines[R]= new ("Line"); tbl28 .CameraDeadzoneLines[R].Thickness=2; tbl28 .CameraDeadzoneLines[R].Transparency=1; tbl28 .CameraDeadzoneLines[R].Visible=true;end;end;end
								tbl28.DestroyFOVLines = function(R)for R=1,8,1 do if  tbl28 .SilentFOVLines[R]then  tbl28 .SilentFOVLines[R]:Remove(); tbl28 .SilentFOVLines[R]=nil;end;if  tbl28 .TriggerFOVLines[R]then  tbl28 .TriggerFOVLines[R]:Remove(); tbl28 .TriggerFOVLines[R]=nil;end;if  tbl28 .CameraFOVLines[R]then  tbl28 .CameraFOVLines[R]:Remove(); tbl28 .CameraFOVLines[R]=nil;end;if  tbl28 .CameraDeadzoneLines[R]then  tbl28 .CameraDeadzoneLines[R]:Remove(); tbl28 .CameraDeadzoneLines[R]=nil;end;end;end
								tbl28:CreateFOVLines()

								tbl29 = {
									RejectTally = {},
									LastReject = v85[115],
									GetBestTarget = function(...) end,
								}

								tbl24.Features.HitboxExpander = {}

								do
									local hitboxExpander = tbl24.Features.HitboxExpander
									hitboxExpander.OriginalSizes = originalSizes
									hitboxExpander.SpoofedTextures = {}
									hitboxExpander.SpoofedDecalParents = {}
									hitboxExpander.Connection = nil
									hitboxExpander.LastTarget = nil
									hitboxExpander.LastScan = 0
									hitboxExpander.ScanTarget = nil
									hitboxExpander.GetConfig = function(...) end
									hitboxExpander.ShouldFixBlood = function(R)local R= hitboxExpander :GetConfig();if not R.Enabled then return false;end;local l= localPlayer .Character and( localPlayer .Character:FindFirstChildWhichIsA("Tool"));if l then local n=R.Weapons and R.Weapons[l.Name];if n and n["Fix Blood"]~=nil then return n["Fix Blood"];end;end;if R["Fix Blood"]~=nil then return R["Fix Blood"];end;return false;end
									hitboxExpander.GetCurrentSize = function(R)local R= hitboxExpander :GetConfig().Weapons;local l= localPlayer .Character and( localPlayer .Character:FindFirstChildWhichIsA("Tool"));local n=l and R and R[l.Name];if not n then for T,T in pairs(R or{})do n=T;break;end;end;if not n then return Vector3.new(2,2,2);end;l=n.Size or n[1];l=if typeof(l)~="table"then n else l;n,R=l[1]or 2,l[2]or 2;local T=l[3]or n;return Vector3.new(n,R,T);end

									hitboxExpander.FaceSizes = {
										[Enum.NormalId.Top] = function(arg)
											return arg.X, arg.Z
										end,
										[Enum.NormalId.Bottom] = function(arg)
											return arg.X, arg.Z
										end,
										[Enum.NormalId.Front] = function(arg)
											local v91 = v85[63]
											if n29(v85[111]) >= v91 then
												return arg.X, arg.Y
											end

											while true do
											end
										end,
										[Enum.NormalId.Back] = function(arg)
											return arg.X, arg.Y
										end,
										[Enum.NormalId.Right] = function(arg)
											return arg.Z, arg.Y
										end,
										[Enum.NormalId.Left] = function(arg)
											return arg.Z, arg.Y
										end,
									}

									hitboxExpander.GetFaceSize = function(R,R,l)local T,L,X= hitboxExpander .FaceSizes[l],R.X,R.Y;if T then L,X=T(R);end;return math.max(L,0.001),math.max(X,0.001);end
									hitboxExpander.GetVisualHitPosition = function(R,R,l,T)local L=R and  hitboxExpander .OriginalSizes[R];if not L then return nil;end;local X=R.CFrame;local Q=X:PointToObjectSpace(l);local z=X:VectorToObjectSpace(T);local Y=L.X*0.5;local U=L.Y*0.5;local _=L.Z*0.5;local E=- huge ;local Z=nil;if math.abs(z.X)>1.0E-4 then R=1/z.X;l,T=(-Y-Q.X)*R,(Y-Q.X)*R;if R<0 then T,l=l,T;end;E,Z=( max (E,l)),( min ( huge ,T));else if Q.X<-Y or Q.X>Y then return nil;end;Z= huge ;end;if math.abs(z.Y)>1.0E-4 then L=1/z.Y;Y,T=(-U-Q.Y)*L,(U-Q.Y)*L;if L<0 then T,Y=Y,T;end;E,Z=( max (E,Y)),( min (Z,T));elseif Q.Y<-U or Q.Y>U then return nil;end;if math.abs(z.Z)>1.0E-4 then l=1/z.Z;T,L=(-_-Q.Z)*l,(_-Q.Z)*l;if l<0 then L,T=T,L;end;E,Z=( max (E,T)),( min (Z,L));elseif Q.Z<-_ or Q.Z>_ then return nil;end;if Z<E or Z<0 then return nil;end;return X:PointToWorldSpace(Q+z*(E>=0 and E or Z));end
									hitboxExpander.HideDecals = function(R,R)local l=R.Parent;local T=l and(l:FindFirstChild("UpperTorso")or(l:FindFirstChild("Torso")));l= hitboxExpander .OriginalSizes[R];for L,X in ipairs(R:GetChildren())do if X:IsA("Decal")then if T then if  hitboxExpander .SpoofedDecalParents[X]~=R then  hitboxExpander .SpoofedDecalParents[X]=R;X.Parent=T;end;elseif l then L= hitboxExpander .SpoofedTextures[X];if not L or L.Parent~=R then local Q,z= hitboxExpander :GetFaceSize(l,X.Face);L=Instance.new("Texture");L.Name="HitboxExpander.Spoofed_"..X.Name;L.Texture=X.Texture;L.Face=X.Face;L.Color3=X.Color3;L.Shiny=X.Shiny;L.Specular=X.Specular;L.ZIndex=X.ZIndex;L.Transparency=X.Transparency;L.StudsPerTileU=Q;L.StudsPerTileV=z;L.OffsetStudsU=0;L.OffsetStudsV=0;L.Parent=R; hitboxExpander .SpoofedTextures[X]=L;end;if X:GetAttribute("HBE_OldTransparency")==nil then X:SetAttribute("HBE_OldTransparency",X.Transparency);end;X.Transparency=1;end;elseif X:IsA("Texture")then local L,Q= hitboxExpander :GetFaceSize(l or R.Size,X.Face);if X.StudsPerTileU>=L-0.001 and X.StudsPerTileV>=Q-0.001 then if T then if  hitboxExpander .SpoofedDecalParents[X]~=R then  hitboxExpander .SpoofedDecalParents[X]=R;X:SetAttribute("HBE_OldStudsU",X.StudsPerTileU);X:SetAttribute("HBE_OldStudsV",X.StudsPerTileV);local L,z= hitboxExpander :GetFaceSize(T.Size,X.Face);X.StudsPerTileU=L;X.StudsPerTileV=z;X.Parent=T;end;elseif not  hitboxExpander .SpoofedDecalParents[X]and l then  hitboxExpander .SpoofedDecalParents[X]=R;X:SetAttribute("HBE_OldStudsU",X.StudsPerTileU);X:SetAttribute("HBE_OldStudsV",X.StudsPerTileV);local L,z= hitboxExpander :GetFaceSize(l,X.Face);X.StudsPerTileU=L;X.StudsPerTileV=z;end;end;Q=X:GetAttribute("HBE_OldTransparency");if Q~=nil then X.Transparency=Q;X:SetAttribute("HBE_OldTransparency",nil);end;elseif X:IsA("BillboardGui")then if T and  hitboxExpander .SpoofedDecalParents[X]~=R then  hitboxExpander .SpoofedDecalParents[X]=R;if X.Adornee then X:SetAttribute("HBE_OldAdornee",X.Adornee);end;X.Adornee=T;X.Parent=T;end;end;end;end
									hitboxExpander.RestoreDecals = function(R,R)for l,T in pairs( hitboxExpander .SpoofedDecalParents)do if T==R and l and l.Parent then if l:IsA("Texture")then local L,X=l:GetAttribute("HBE_OldStudsU"),l:GetAttribute("HBE_OldStudsV");if L then l.StudsPerTileU=L;l:SetAttribute("HBE_OldStudsU",nil);end;if X then l.StudsPerTileV=X;l:SetAttribute("HBE_OldStudsV",nil);end;elseif l:IsA("BillboardGui")then local L=l:GetAttribute("HBE_OldAdornee");if L then l.Adornee=L;l:SetAttribute("HBE_OldAdornee",nil);else l.Adornee=nil;end;end;l.Parent=R;end;if T==R then  hitboxExpander .SpoofedDecalParents[l]=nil;end;end;for l,T in ipairs(R:GetDescendants())do if T:IsA("Decal")then l= hitboxExpander .SpoofedTextures[T];if l and l.Parent==R then l:Destroy(); hitboxExpander .SpoofedTextures[T]=nil;end;local l=T:GetAttribute("HBE_OldTransparency");if l~=nil then T.Transparency=l;T:SetAttribute("HBE_OldTransparency",nil);end;elseif T:IsA("Texture")then local l=T:GetAttribute("HBE_OldTransparency");if l~=nil then T.Transparency=l;T:SetAttribute("HBE_OldTransparency",nil);end;elseif T:IsA("BasePart")then local l=T:GetAttribute("HBE_OldLocalTransparency");if l~=nil then T.LocalTransparencyModifier=l;T:SetAttribute("HBE_OldLocalTransparency",nil);end;elseif T:IsA("SurfaceGui")or(T:IsA("BillboardGui"))then local l=T:GetAttribute("HBE_OldEnabled");if l~=nil then T.Enabled=l;T:SetAttribute("HBE_OldEnabled",nil);end;end;end;for l,T in pairs( hitboxExpander .SpoofedTextures)do if T and T.Parent==R then T:Destroy(); hitboxExpander .SpoofedTextures[l]=nil;end;end;end
									hitboxExpander.ExpandHRP = function(R,R)if not R then return;end;local l=R:FindFirstChild("HumanoidRootPart");if not l then return;end;if not  hitboxExpander .OriginalSizes[l]then  hitboxExpander .OriginalSizes[l]=l.Size;end;l.Size= hitboxExpander :GetCurrentSize();l.Transparency= hitboxExpander :GetConfig()["Show Hitbox"]and 0.5 or 1;l.CanCollide=false;l.CanQuery=true; hitboxExpander :HideDecals(l);end
									hitboxExpander.RestoreHRP = function(R,R)if not R then return;end;local l=R:FindFirstChild("HumanoidRootPart");if not l then return;end;R= hitboxExpander .OriginalSizes[l];if R then l.Size=R; hitboxExpander .OriginalSizes[l]=nil;end; hitboxExpander :RestoreDecals(l);end
									hitboxExpander.ExpandAll = function(R)if not  hitboxExpander :GetConfig().Enabled then if  hitboxExpander .LastTarget then local R= hitboxExpander .LastTarget.Character;if R then  hitboxExpander :RestoreHRP(R);end; hitboxExpander .LastTarget=nil;end;return;end;local R= clock ();if R- hitboxExpander .LastScan>=0.02 then  hitboxExpander .LastScan=R; hitboxExpander .ScanTarget= tbl29 :GetBestTarget("SilentAim",nil,1000,nil,true);end;R= hitboxExpander .ScanTarget;if  hitboxExpander .LastTarget and  hitboxExpander .LastTarget~=R then local l= hitboxExpander .LastTarget.Character;if l then  hitboxExpander :RestoreHRP(l);end; hitboxExpander .LastTarget=nil;end;if R and R.Character and R.Character~= localPlayer .Character then  hitboxExpander :ExpandHRP(R.Character); hitboxExpander .LastTarget=R;end;end
									hitboxExpander.GetHitPart = function(n,n)if n:IsA("BasePart")then return n;end;local R=n.Parent;while R and not R:IsA("BasePart")do R=R.Parent;end;return R;end
									hitboxExpander.FindCharacterFromPoint = function(R,R)local l=30;local T=nil;for L,X in ipairs( Players :GetPlayers())do if X~= localPlayer and X.Character then L=X.Character:FindFirstChild("HumanoidRootPart");if L and(L:IsA("BasePart"))then local n=(L.Position-R).Magnitude;if n<l then l,T=n,X.Character;end;end;end;end;return T;end
									hitboxExpander.GetCharacterFromPart = function(R,R)if not R then return nil;end;local l=R:FindFirstAncestorOfClass("Model");if not l or l== localPlayer .Character then return nil;end;if not l:FindFirstChildOfClass("Humanoid")then return nil;end;return l;end
									hitboxExpander.GetWorldCFrame = function(n,n)if not n then return nil;end;if n:IsA("BasePart")then return n.CFrame;elseif n:IsA("Attachment")then return n.WorldCFrame;end;local R=n.Parent;while R do if R:IsA("BasePart")then return R.CFrame;elseif R:IsA("Attachment")then return R.WorldCFrame;end;R=R.Parent;end;return nil;end
									hitboxExpander.BloodRayParams = raycastParams()
									hitboxExpander.BloodRayParams.FilterType = include
									hitboxExpander.BloodParts = {}
									hitboxExpander.GetBodyParts = function(R,R)local l,T= hitboxExpander .BloodParts,0;for n,n in ipairs(R:GetChildren())do if n:IsA("BasePart")and n.Name~="HumanoidRootPart"then T+=1;l[T]=n;end;end;for n=#l,T+1,-1 do l[n]=nil;end;return l;end
									hitboxExpander.GetShotOrigin = function(...) end
									hitboxExpander.GetImpact = function(...) end
									hitboxExpander.ResolveBloodPoint = function(R,R,l,T)if not R or not T then return nil;end;local L= hitboxExpander :GetShotOrigin();local X=L-T;local Q=X.Magnitude>0.001 and X.Unit or  vector ;if l and(l:IsA("BasePart"))and l.Parent==R and l.Name~="HumanoidRootPart"then return l,T,Q;end;T= hitboxExpander :GetBodyParts(R);if#T==0 then return nil;end;local z,Y=-Q,R:FindFirstChild("HumanoidRootPart");R=X.Magnitude+(Y and Y.Size.Magnitude or 8); hitboxExpander .BloodRayParams.FilterDescendantsInstances=T;X= Workspace :Raycast(L,z*R, hitboxExpander .BloodRayParams);if X and X.Instance then return X.Instance,X.Position,X.Normal;end;R,X,Y=nil;for U,_ in ipairs(T)do l,U=_.CFrame,_.Size*0.5;local E,Z=l:PointToObjectSpace(L),l:VectorToObjectSpace(z);local z=E+Z* max (-E:Dot(Z),0);E= vector3 ( clamp (z.X,-U.X,U.X), clamp (z.Y,-U.Y,U.Y), clamp (z.Z,-U.Z,U.Z));Z=(z-E).Magnitude;if not R or Z<R then R,X,Y=Z,_,(l:PointToWorldSpace(E));end;end;if not X then return nil;end;T=L-Y;return X,Y,T.Magnitude>0.001 and T.Unit or Q;end
									hitboxExpander.HitQueue = {}
									hitboxExpander.ShotgunSpreadIndex = {}
									hitboxExpander.HitQueueMaxSize = v85[105]
									hitboxExpander.HitQueueMaxAge = 1.2
									hitboxExpander.BulletTracker = {}
									hitboxExpander.CleanupHitQueue = function(R)local R=tick();local l=1;while l<=# hitboxExpander .HitQueue do if R- hitboxExpander .HitQueue[l].Time> hitboxExpander .HitQueueMaxAge then table.remove( hitboxExpander .HitQueue,l);else l+=1;end;end;while# hitboxExpander .HitQueue> hitboxExpander .HitQueueMaxSize do table.remove( hitboxExpander .HitQueue,1);end;end
									hitboxExpander.PushHit = function(R,R,l,T)if not R or not l then return;end; hitboxExpander :CleanupHitQueue();table.insert( hitboxExpander .HitQueue,{Character=R,Position=l,Instance=T,Time=tick()});end
									hitboxExpander.GetHitsForBlood = function(R,R,l,T,L)if not R then return{};end; hitboxExpander :CleanupHitQueue();local X,Q,z=tick(),L or 0.08,{};for Y=# hitboxExpander .HitQueue,1,-1 do L= hitboxExpander .HitQueue[Y];if L.Character==R and X-L.Time<=Q then table.insert(z,1,L);if#z>=(T or 8)then break;end;end;end;if#z==0 and l then L,T=math.huge;for Y=# hitboxExpander .HitQueue,1,-1 do Q= hitboxExpander .HitQueue[Y];if Q.Character==R then X=(Q.Position-l).Magnitude;if X<L then L,T=X,Q;end;end;end;if T then table.insert(z,T);end;end;return z;end
									hitboxExpander.GetShotgunSpreadPoint = function(R,R,l)if not R then return l;end;local T= hitboxExpander :GetHitsForBlood(R,l,8,0.15);if#T==0 then return l;end;if#T==1 then return T[1].Position,T[1].Instance;end;l=( hitboxExpander .ShotgunSpreadIndex[R]or 0)%#T+1; hitboxExpander .ShotgunSpreadIndex[R]=l;return T[l].Position,T[l].Instance;end
									hitboxExpander.BulletTrackerConnection = nil
									hitboxExpander.OnBloodParticle = function(R,R)if not  hitboxExpander :GetConfig().Enabled then return;end;if not  hitboxExpander :ShouldFixBlood()then return;end;if not R.Parent or(R:GetAttribute("HBE_Fixed"))then return;end;local l= hitboxExpander :GetHitPart(R);if not l then return;end;local T;if R:IsA("BasePart")then T= hitboxExpander :GetCharacterFromPart(R)or( hitboxExpander :FindCharacterFromPoint(R.Position));else if l.Name~="HumanoidRootPart"then return;end;T=( hitboxExpander :GetCharacterFromPart(l));end;if not T then return;end;R:SetAttribute("HBE_Fixed",true);local L= hitboxExpander :GetWorldCFrame(R)or l.CFrame;local l,X= hitboxExpander :ResolveBloodPoint(T,nil,( hitboxExpander :GetImpact(T,L.Position,nil,false)));if not l then return;end;local T=CFrame.new(l.CFrame:PointToObjectSpace(X))*(l.CFrame:Inverse()*L).Rotation;pcall(function()if R:IsA("BasePart")then R.Anchored=false;R.CanCollide=false;R.CanQuery=false;R.CanTouch=false;R.Massless=true;R.CFrame=l.CFrame*T;R.Parent=l;local L=Instance.new("WeldConstraint");L.Name="HBE_BloodWeld";L.Part0=R;L.Part1=l;L.Parent=R;elseif R:IsA("Attachment")then R.Parent=l;R.CFrame=T;else local L=Instance.new("Attachment");L.Name="HBE_BloodAttach";L.CFrame=T;L.Parent=l;R.Parent=L; Debris :AddItem(L,3);end;end);end
									hitboxExpander.OnHitSound = function(R,R)if not  hitboxExpander :GetConfig().Enabled then return;end;if not  hitboxExpander :ShouldFixBlood()then return;end;if not R:IsA("Sound")then return;end;if R.Name~="BloodSplatter"and R.Name~="HitSound"then return;end;if R:GetAttribute("HBE_Fixed")then return;end;R:SetAttribute("HBE_Fixed",true);local l=R.Parent;while l and not l:IsA("BasePart")do l=l.Parent;end;if not l then return;end;local T= hitboxExpander :GetCharacterFromPart(l);if not T then return;end;local L,X= hitboxExpander :GetImpact(T,l.Position,l,true);local l,Q= hitboxExpander :ResolveBloodPoint(T,X,L);if not l then return;end;local T=Instance.new("Attachment");T.Position=l.CFrame:PointToObjectSpace(Q);if not pcall(function()T.Parent=l;end)then T:Destroy();return;end;R.Parent=T;R:Stop();R:Play(); Debris :AddItem(T,3);end
									hitboxExpander.OnBloodDecal = function(R,R)if not  hitboxExpander :GetConfig().Enabled then return;end;if not  hitboxExpander :ShouldFixBlood()then return;end;if not R:IsA("Decal")and not R:IsA("Texture")then return;end;if R:GetAttribute("HBE_Fixed")then return;end;if R.Name=="face"then return;end;R:SetAttribute("HBE_Fixed",true);local l= hitboxExpander :GetHitPart(R);if not l then return;end;if l:FindFirstAncestorOfClass("Tool")or(l:FindFirstAncestorWhichIsA("Accoutrement"))then return;end;local T= hitboxExpander :GetCharacterFromPart(l);T=if not T then( hitboxExpander :FindCharacterFromPoint(l.Position))else T;if not T then return;end;local L,X= hitboxExpander :GetImpact(T,l.Position,l,true);local l,Q,z= hitboxExpander :ResolveBloodPoint(T,X,L);if not l then return;end;local T=Instance.new("Part");T.Name="Blood_Decal";T:SetAttribute("HBE_Fixed",true);T.Anchored=false;T.Massless=true;T.CanCollide=false;T.CanQuery=false;T.CanTouch=false;T.Transparency=1;T.Size=Vector3.new(0.05,0.05,0.05);T.CFrame=CFrame.new(Q,Q+z);if not pcall(function()T.Parent=l;local L=Instance.new("WeldConstraint");L.Name="HBE_BloodWeld";L.Part0=T;L.Part1=l;L.Parent=T;end)then T:Destroy();return;end;if R:IsA("Texture")then R.StudsPerTileU=0.025;R.StudsPerTileV=0.025;R.OffsetStudsU=0;R.OffsetStudsV=0;end;R.Face=Enum.NormalId.Front;if R.Transparency>0 then R.Transparency=0;end;R.Parent=T; Debris :AddItem(T,1);end

									hitboxExpander.OnCharacterAdded = function()
										error("devirt: symbolic next pc/mode: 598 / r2 (at 195:167)")
									end

									for _, player in ipairs(Players:GetPlayers()) do
										if player.Character then
											task.spawn(function()
												hitboxExpander:OnCharacterAdded(player.Character)
											end)
										end

										player.CharacterAdded:Connect(function(character)
											hitboxExpander:OnCharacterAdded(character)
										end)

										player.CharacterRemoving:Connect(function(R) hitboxExpander :RestoreHRP(R);end)
									end

									Players.PlayerAdded:Connect(function(...) end)

									hitboxExpander.Connection = service.Heartbeat:Connect(function()
										hitboxExpander:ExpandAll()
									end)

									Workspace.DescendantAdded:Connect(function(R)if R.Name=="BloodParticle"then task.defer(function() hitboxExpander :OnBloodParticle(R);end);elseif R.Name=="Blood_Decal"and(R:IsA("Decal")or(R:IsA("Texture")))then task.defer(function() hitboxExpander :OnBloodDecal(R);end);elseif(R.Name=="BloodSplatter"or R.Name=="HitSound")and(R:IsA("Sound"))then task.defer(function() hitboxExpander :OnHitSound(R);end);end;end)
								end
							end

							do
								tbl29.ShouldUnTarget = function(...) end
								tbl29.CleanupTargetVisuals = function(R) tbl28 :DestroyFOVLines();end
								tbl29.ClearToggleLatches = function(...) end
								tbl29.ClearTarget = function(...) end
								v90 = tbl29
								tbl27.IsTargetGrabbed = function(...) end
								tbl28.HandleFOVSection = function(...) end

								tbl28.FOVLineSets = {
									tbl28.SilentFOVLines,
									tbl28.TriggerFOVLines,
									tbl28.CameraFOVLines,
									tbl28.CameraDeadzoneLines,
								}

								tbl28.ClearFOVVisuals = function(R)if  variables .FovVisualsClean then return;end; variables .FovVisualsClean=true; tbl11 :Pcall(function()if  variables .SilentBox then  variables .SilentBox:Destroy();end;if  variables .TriggerBox then  variables .TriggerBox:Destroy();end;if  variables .CameraBox then  variables .CameraBox:Destroy();end;end); variables .SilentBox=nil; variables .TriggerBox=nil; variables .CameraBox=nil;for R,R in ipairs( tbl28 .FOVLineSets)do for n,n in ipairs(R)do if n then n.Visible=false;end;end;end;end
								tbl28.UpdateFOVVisuals = function(...) end
								tbl30 = { Targeting = function(...) end }
								v90.CharacterCache = fn29({}, { __index = function(...) end })
								tbl27.AutoShotguns = { ["[Drum-Shotgun]"] = true }

								do
									local tbl33 = {
										v85[97],
										v85[140],
										"GunClientAutomaticShotgun",
										v85[65],
										"GunClientAutomatic",
									}

									tbl27.CleanScripts = function(R,R)if not R then return;end;local l=R.Name:lower();if l:find("knife")or(l:find("katana"))then return;end;for l,l in ipairs(R:GetChildren())do if  find ( tbl33 ,l.Name)then  v88 (function()l:Destroy();end);end;end;end
								end
							end

							tbl27.GetPattern = function(...) end
							tbl27.GetCooldown = function(...) end
							tbl27.ShootRayParams = raycastParams()
							tbl27.ShootRayParams.FilterType = Enum.RaycastFilterType.Exclude
							tbl27.ShootRayParams.IgnoreWater = true
							tbl27.ShootFilter = {}
							tbl27.Animate = function(...) end
							tbl27.TeleportBullet = function(R,R,l,T)if not R or not l or not T then return;end;local L=l:FindFirstChild("RightHand");local X= localPlayer :FindFirstChild("Backpack");if not L or not X then return;end;local Q=R.Grip;local z=(L.CFrame* cframe3 (0,-1,0,1,0,0,0,0,1,0,-1,0)):ToObjectSpace( cframe3 (T)):Inverse();R.Parent=X;R.Grip=z;R.Parent=l; service .PreRender:Wait();if not R.Parent or R.Parent~=l and R.Parent~=X then return;end;R.Parent=X;R.Grip=Q;R.Parent=l;end
							tbl27.BuildFilter = function(...) end
							tbl27.HasWeaponMuzzleFolder = function(R,R,l,T)if not R or not l or not T then return false;end;local L=T:FindFirstChild("GunSkinMuzzleParticle");if not L then return false;end;local T=l.Name;l=L:FindFirstChild(T);if not l then local X=nil; tbl11 :Pcall(function()X=R:GetAttribute("SkinName");end);if type(X)~="string"or X==""then  tbl11 :Pcall(function()local R=game:GetService("HttpService"):JSONDecode( localPlayer .DataFolder.Information.EquipSkins.Value);X=R and R[T]or nil;end);end;if type(X)~="string"or X==""then X="Default";end;l=(L:FindFirstChild(X));end;return l~=nil;end
							tbl27.MuzzleEmit = function(R,R,l,T,L,X) tbl11 :Xpcall(function()if not R or not l then return;end;local Q=R.Parent;if not Q then return;end;if not Q.Parent then return;end;local z=Q.Name;local Y=nil;if not( tbl24 .CurrentGame and  tbl24 .CurrentGame.Method=="DasHood")then  tbl11 :Pcall(function()Y=R:GetAttribute("SkinName");end);end;local U=l:FindFirstChild("GunSkinMuzzleParticle");if not U then return;end;local l= Players :GetPlayerFromCharacter(Q.Parent);if l and l:GetAttribute("GunFX")==true then return;end;if L then return;end;local L=T and"LeftMuzzle"or"Muzzle";local _= tbl24 .CurrentGame and  tbl24 .CurrentGame.Method=="DasHood";local E=Y;if _ then if type(E)~="string"or E==""then  tbl11 :Pcall(function()local Z=game:GetService("HttpService"):JSONDecode( localPlayer .DataFolder.Information.EquipSkins.Value);Y=Z and Z[z]or nil;end);end;if type(E)~="string"or E==""then Y="Default";else Y=E;end;l=nil;local Z=Q:FindFirstChild("Default");if Z then local x=Z:FindFirstChild("Mesh");l=if x and(x:FindFirstChild(L))then(x:FindFirstChild(L))else if Z:FindFirstChild("Part")and(Z.Part:FindFirstChild(L))then(Z.Part:FindFirstChild(L))else if Z:FindFirstChild("MeshPart")and(Z.MeshPart:FindFirstChild(L))then(Z.MeshPart:FindFirstChild(L))else l;end;l=if not l then(R:FindFirstChild(L))else l;if not l then return;end;Z=U:FindFirstChild(z);Z=if not Z then(U:FindFirstChild(Y))else Z;if not Z then return;end;local Y=Z:FindFirstChild(L);local x=Y or Z;for Z,j in  v87 ((if Y and(Y:FindFirstChild("Different_GunMuzzle"))then Y.Different_GunMuzzle:FindFirstChild(z)or Y else x):GetChildren())do if j:IsA("ParticleEmitter")then Z=j:Clone();Z.Parent=l;Z:Emit(j:GetAttribute("EmitCount")or 1); Debris :AddItem(Z,2);end;end;return;end;_=type(E)=="string"and E~="";local Y=if not(if _ then(U:FindFirstChild(E))else nil)then(U:FindFirstChild(z))else if _ then(U:FindFirstChild(E))else nil;if Y then E,l=Y:FindFirstChild(L),(function()local Z=Q:FindFirstChild("Default");if not Z then return R:FindFirstChild(L);end;if T then local x=Z:FindFirstChild("Mesh");if x then local j=x:FindFirstChild("DualWieldLeftHandMesh");if j and(j:FindFirstChild(L))then return j:FindFirstChild(L);end;end;end;local x={"Mesh","Part","MeshPart"};for j,s in  v87 (x)do j=Z:FindFirstChild(s);if j and(j:FindFirstChild(L))then return j:FindFirstChild(L);end;end;return R:FindFirstChild(L);end)();if E and l then U=if E:FindFirstChild("Different_GunMuzzle")then E.Different_GunMuzzle:FindFirstChild(z)or E else E;if U then for z,z in  v86 (U:GetChildren())do local U,E=z:GetAttribute("EmitCount")or 1,T and z or(z:Clone());E.Parent=l;E:Emit(U);if not T then  delay (E.Lifetime.Max,function()E:Destroy();end);end;end;end;else _=Y:GetChildren();if#_>0 and X then local l=_[ random2 (#_)]:Clone();l.Parent=X;l:Emit(l.Rate); delay (l.Lifetime.Max,function()l:Destroy();end);end;end;else local l=Q:FindFirstChild("Default");local T;if l then local X={"Mesh","Part","MeshPart"};for Q,z in  v87 (X)do Q=l:FindFirstChild(z);if Q and(Q:FindFirstChild(L))then T=(Q:FindFirstChild(L));break;end;end;end;T=if not T then(R:FindFirstChild(L))else T;if T then for R,R in  v86 (T:GetDescendants())do if R:IsA("ParticleEmitter")then R:Emit(R:GetAttribute("EmitCount")or 1);end;end;end;end;end,function(R)return  tbl11 :ErrHandler(R);end);end
							tbl27.SpawnBlood = function(R,R,l)if not R or not l then return;end;local T= ReplicatedStorage :FindFirstChild("Assets");local L=T and(T:FindFirstChild("Particles"));T=L and(L:FindFirstChild("BloodParticle"));if not T then return;end;L=T:Clone();T=L:FindFirstChild("Blood");if T and(T:IsA("Attachment"))then local X=l.CFrame:PointToObjectSpace(R);T.Position=X;T.CFrame=CFrame.new(X);T.Parent=l;for X,X in ipairs(T:GetChildren())do if X:IsA("ParticleEmitter")then X:Emit(10);end;end; Debris :AddItem(T,1);L:Destroy();else L.Position=R;L.Parent=l;if L:FindFirstChild("Blood")then for R,R in ipairs(L.Blood:GetChildren())do if R:IsA("ParticleEmitter")then R:Emit(10);end;end;end; Debris :AddItem(L,1);end;end
							tbl27.GetGroundY = function(R,R,l)if not R then return 0;end;local T={};local L=0;if  localPlayer .Character then T[1]= localPlayer .Character;L=1;end;if l then T[L+1]=l;end;L=RaycastParams.new();L.FilterType=Enum.RaycastFilterType.Exclude;L.IgnoreWater=true;L.FilterDescendantsInstances=T;l= Workspace :Raycast(R, vector3 (0,-1000,0),L);return l and l.Position.Y or R.Y;end
							tbl27.CreateBullet = function(...) end

							tbl31 = {
								Tune = {
									PingSmoothingSeconds = v85[154],
									RepIntervalMin = 0.016666666666666666,
									RepIntervalMax = 0.1,
									SelfRepIntervalPrior = 0.033333333333333333,
									LeadMax = v85[139],
									GroundedEpsilon = 0.5,
									VelocityTauMax = v85[53],
									VelocityTauSpeed = 250,
									SendTick = v85[91],
									SendFactor = 0.5,
									ServerTick = 0.016666666666666666,
									ServerFactor = 0.5,
								},
							}

							do
								local tune = tbl31.Tune
								tbl31.PositionCache = {}
								tbl31.VelocityState = {}
								tbl31.PositionHistorySize = 10
								tbl31.PositionSampleInterval = v85[195]
								tbl31.PositionSampleWindow = 4
								tbl31.TeleportSpeedFloor = v85[67]
								tbl31.TeleportOutlierRatio = v85[118]
								tbl31.PositionStaleGap = 0.25
								tbl31.EngineTrackers = {}
								tbl31.AimVelocity = fn29({}, { __mode = "k" })

								tbl28.StateTables = {
									tbl28.VelocityCache,
									tbl28.PositionCache,
									tbl28.VelocityHistory,
									tbl28.EngineTrackers,
									tbl28.LeadSmooth,
									tbl28.RepIntervals,
									tbl31.PositionCache,
									tbl31.VelocityState,
									tbl31.EngineTrackers,
								}

								tbl28.PurgeDeadState = function()
									error("devirt: symbolic next pc/mode: (r4 Add 1) / 195 (at 195:201)")
								end

								spawn_(function()while true do  wait_ (5); v88 (function()return  tbl28 :PurgeDeadState();end);end;end)
								tbl31.GroundRayParams = raycastParams()
								tbl31.GroundRayParams.FilterType = exclude
								tbl31.GroundRayParams.RespectCanCollide = true
								tbl31.GroundFilterList = { nil, nil }
								tbl31.Net = {}
								tbl31.TrackFrameTime = function(R)local R= tbl28 .FrameTimeEMA or  tbl24 .FrameTime or 0.016666666666666666;if R~=R or R<=0 or R== huge then return 0.016666666666666666;end;return R;end
								tbl31.RoundTrip = function(R) tbl11 :SamplePing(tick());local R= tbl11 .PingHistory[1];if type(R)~="number"or R~=R or R<0 or R== huge then return 0;end;local l,T= tbl31 .Net, tbl11 .LastPingSample;if l.PingStamp~=T or l.PingSource~= tbl11 .PingSource then if not l.PingStamp or l.PingSource~= tbl11 .PingSource or T-l.PingStamp>0.5 then l.Ping=R;else local L=1-math.exp(- max (T-l.PingStamp,0)/ tune .PingSmoothingSeconds);l.Ping=l.Ping+(R-l.Ping)*L;end;l.PingStamp,l.PingSource=T, tbl11 .PingSource;end;return  min (l.Ping or R,1);end
								tbl31.GetGroundY = function(R,R,l)if not R then return 0;end;local T=0;if  localPlayer .Character then  tbl31 .GroundFilterList[1]= localPlayer .Character;T=1;end;if l then T+=1; tbl31 .GroundFilterList[T]=l;end;for l=T+1,# tbl31 .GroundFilterList,1 do  tbl31 .GroundFilterList[l]=nil;end; tbl31 .GroundRayParams.FilterDescendantsInstances= tbl31 .GroundFilterList;T= Workspace :Raycast(R, vector3 (0,-1000,0), tbl31 .GroundRayParams);return T and T.Normal.Y>0.5 and T.Position.Y or nil;end
								tbl31.MotionAgrees = function(R,R,l)if not  tbl28 :IsFiniteVector(R)or not  tbl28 :IsFiniteVector(l)then return false;end;local n,T=R.Magnitude,l.Magnitude;return n>1 and T>n*0.5 and T<n*2 and R:Dot(l)>0.85*n*T;end
								tbl31.Sample = function(R,R,l)if not R or not l then return nil;end;local T= tbl31 .PositionCache[R];if not T or T.Root~=l then T={Root=l}; tbl31 .PositionCache[R]=T; tbl31 .VelocityState[R]=nil;end;local L,X= clock (),T[1];if X and L-X.Time> tbl31 .PositionStaleGap then T={Root=l}; tbl31 .PositionCache[R]=T; tbl31 .VelocityState[R]=nil;X=nil;end;local Q=l.Position;if not  tbl28 :IsFiniteVector(Q)then return T;end;if X then local z,Y=(Q-X.Position).Magnitude,L-X.Time;if Y>0 and z>25 and z/Y> tbl31 .TeleportSpeedFloor then local z=(Q-X.Position)/Y;local Y= tbl31 :MotionAgrees(z,l.AssemblyLinearVelocity);if not Y and T[2]then local U=X.Time-T[2].Time;Y=if U>0.001 then( tbl31 :MotionAgrees(z,(X.Position-T[2].Position)/U))else Y;end;if not Y then T={Root=l,Rejected=true}; tbl31 .PositionCache[R]=T; tbl31 .VelocityState[R]=nil;X=nil;end;end;end;if not X or L-X.Time+1.0E-6>= tbl31 .PositionSampleInterval then T.EstimateTime=nil;if not X or(Q-X.Position).Magnitude>=0.001 then T.LastMovementTime=L;end; insert (T,1,{Position=Q,Time=L});while#T> tbl31 .PositionHistorySize do  remove2 (T);end;end;return T;end
								tbl31.TrackedVelocity = function(R,R)local l=R and  tbl31 .PositionCache[R];if not l or not l[1]then return  vector4 ,0;end;if  clock ()-l[1].Time> tbl31 .PositionStaleGap then  tbl31 .VelocityState[R]=nil;return  vector4 ,0;end;if l.EstimateTime==l[1].Time then return l.Velocity,l.Stability;end;local T=l.Root.AssemblyLinearVelocity;local L=R.Character and  tbl28 .RepIntervals[R.Character];local X,Q,z,Y= max (0.12,3*(L and L.Interval or  tune .SelfRepIntervalPrior)),l[3]and(l[1].Position-l[2].Position).Magnitude<0.001 and(l[2].Position-l[3].Position).Magnitude<0.001;if Q and( tbl28 :IsFiniteVector(T)and T.Magnitude<=1 or  clock ()-(l.LastMovementTime or l[1].Time)>=X)then  tbl31 .VelocityState[R]=nil;z,Y= tbl31 :LerpVelocity(R, vector4 ,1);elseif Q then L= tbl31 .VelocityState[R];z=L and L.Vel or T;Y,z=L and L.Stability or 0.5,if not  tbl28 :IsFiniteVector(z)then  vector4 else z;elseif#l<2 then z=l.Rejected and  vector4 or l.Root.AssemblyLinearVelocity;Y,z=0.5,if not  tbl28 :IsFiniteVector(z)then  vector4 else z;else z,Y= tbl31 :EstimateTrackedVelocity(R);end;l.EstimateTime=l[1].Time;l.Velocity=z;l.Stability=Y;return z,Y;end
								tbl31.EstimateTrackedVelocity = function(R,R)if not R then return  vector4 ,0;end;local l= tbl31 .PositionCache[R];if not l or#l<2 then return  tbl31 :LerpVelocity(R, vector4 ,0);end;local T=#l;T=if T> tbl31 .PositionSampleWindow+1 then  tbl31 .PositionSampleWindow+1 else T;local L=l.StepSpeeds or{};l.StepSpeeds=L;for X=#L,T,-1 do L[X]=nil;end;for X=1,T-1,1 do local Q,z=l[X],l[X+1];local Y=Q.Time-z.Time;L[X]=Y>0.001 and(Q.Position-z.Position).Magnitude/Y or 0;end;local X=l.SortedSpeeds or{};l.SortedSpeeds=X;for Q=#X,T,-1 do X[Q]=nil;end;for Q=1,#L,1 do X[Q]=L[Q];end; sort (X);local Q,z= max ((X[math.ceil(#X/2)]or 0)* tbl31 .TeleportOutlierRatio, tbl31 .TeleportSpeedFloor),T;for Y=1,T-1,1 do if L[Y]>Q then X=l[Y].Time-l[Y+1].Time;if not(Y==1 and X>0.001 and( tbl31 :MotionAgrees((l[Y].Position-l[Y+1].Position)/X,l.Root.AssemblyLinearVelocity)))then z=Y;break;end;end;end;if z<2 then for Y=#l,2,-1 do l[Y]=nil;end; tbl31 .VelocityState[R]=nil;return  tbl31 :LerpVelocity(R, vector4 ,0);end;local Y,U,_,E,Z,x,j,s,C,d,u=l[1].Time,l[1].Position,0,0,0,0,0,0,0,0,0;for S=1,z,1 do T=l[S];local i,c,J=T.Time-Y,1/S,T.Position-U;_,E,Z,x,j,s,C,d,u=_+c,E+c*i,Z+c*i*i,x+c*J.X,j+c*J.Y,s+c*J.Z,C+c*i*J.X,d+c*i*J.Y,u+c*i*J.Z;end;local S=_*Z-E*E;X= abs (S);local i=nil;if X>1.0E-9 then i=( vector3 ((_*C-E*x)/S,(_*d-E*j)/S,(_*u-E*s)/S));else Y,Z=l[1],l[z];Q=Y.Time-Z.Time;if Q<=0.001 then return  tbl31 :LerpVelocity(R, vector4 ,0);end;i=(Y.Position-Z.Position)/Q;end;_=0;for c=1,z-1,1 do _=if L[c]>_ then L[c]else _;end;E,d= max (_*1.2,50),i.Magnitude;if d>E then i,d=i.Unit*E,E;end;U=1;if z>=3 then _=nil;u,X=0,0;for c=1,z-1,1 do Y=l[c].Position-l[c+1].Position;S= vector3 (Y.X,0,Y.Z);x=S.Magnitude;if x>0.01 then L=S/x;if _ then u,X=u+_:Dot(L),X+1;end;_=L;end;end;U=if X>0 then( clamp ((u/X+1)*0.5,0,1))else U;end;Y=R.Character;Z=Y and(Y:FindFirstChild("HumanoidRootPart"));if Z then L=Z.AssemblyLinearVelocity;S=L.Magnitude;i=if S<=E and d>1 and S>1 then if i.Unit:Dot(L.Unit)>0.7 and  abs (S-d)<d*0.5 then i*0.5+L*0.5 else i else i;end;Q=l[1].Time-l[2].Time;if Q>0.001 then S=(l[1].Position-l[2].Position)/Q;d,x= vector3 (S.X,0,S.Z), vector3 (i.X,0,i.Z);s,L=d.Magnitude,x.Magnitude;if s>1 and s<=E then local Q=false;if Z and( tbl28 :IsFiniteVector(Z.AssemblyLinearVelocity))then j=Z.AssemblyLinearVelocity;_= vector3 (j.X,0,j.Z);u=_.Magnitude;Q=u>s*0.5 and u<s*1.5 and d:Dot(_)>0.8*s*u;end;if not Q and z>=3 then Y=l[2].Time-l[3].Time;if Y>0.001 then C=(l[2].Position-l[3].Position)/Y;X= vector3 (C.X,0,C.Z);T=X.Magnitude;Q=T>s*0.5 and T<s*1.5 and d:Dot(X)>0.8*s*T;end;end;i=if Q and(d:Dot(x)<0.5*s*L or s<L*0.6 or s>L*1.2)then( vector3 (S.X,i.Y,S.Z))else i;end;end;return  tbl31 :LerpVelocity(R,i,U);end
								tbl31.LerpVelocity = function(R,R,l,T)local L= tbl31 .PositionCache[R];local X,Q=L and L[1]and L[1].Time or( clock ()), tbl31 .VelocityState[R];L=Q;if not Q then  tbl31 .VelocityState[R]={Vel=l,Stability=T,Time=X};return l,T;end;R= clamp (X-L.Time,0,0.5);local Q=1-math.exp(-R/0.05);local z=L.Vel.X*L.Vel.X+L.Vel.Z*L.Vel.Z;local Y=l.X*l.X+l.Z*l.Z;Q=if R>0 and z>1 and Y>1 and L.Vel.X*l.X+L.Vel.Z*l.Z<=0 then 1 else if(l-L.Vel).Magnitude>30 then( min (Q*3,1))else Q;L.Vel=L.Vel:Lerp(l,Q);L.Stability=L.Stability+(T-L.Stability)*Q;L.Time=X;return L.Vel,L.Stability;end
								tbl31.Tick = function(...) end
								tbl31.Lead = function(R,R,l)local T=R and R.Character;if not T or not T:FindFirstChild("HumanoidRootPart")then return 0;end;R=tonumber(l);R=if not R or R~=R or R<0 or  abs (R)== huge then 1 else R;l= tbl31 :RoundTrip();local L= tbl28 .RepIntervals[T];local T= clamp (L and L.Interval or  tbl28 .RepGlobal, tune .RepIntervalMin, tune .RepIntervalMax);local X= tbl31 :TrackFrameTime();local Q= tune .SendTick* tune .SendFactor+ tune .ServerTick* tune .ServerFactor;L=(l+T+X+(if  tbl11 .PingSource=="Data"then 0 else Q))*R;if L~=L or  abs (L)== huge then return 0;end;return  clamp (L,0, tune .LeadMax);end
								tbl27.GetAim = function(...) end
								tbl31.ResolveVelocity = function(R,R,l,T,L)local X= clock ();local Q=l.AssemblyLinearVelocity;Q=if not  tbl28 :IsFiniteVector(Q)then  vector4 else Q;local z=Q.Magnitude;l= tbl31 :TrackedVelocity(R);l=if not  tbl28 :IsFiniteVector(l)then  vector4 else l;local Y,U,_=l.Magnitude,false;if T then local E,Z,x=pcall(T.Resolve,T,L);if E and Z and( tbl28 :IsFiniteVector(Z))and Z.Magnitude>0.01 then _,U=Z,x==true;else _=Q;end;else _=Q;end;L=_.Magnitude;if Y>0.5 and(L>Y*1.5 or L<Y*0.5 and Y>5)then _,U=l,true;end;if z>60 and Y<2 then _,U=l,true;end;_=if not U and z>0.01 and(z<=L*1.35 or Y>0 and z<=Y*1.35)then Q else _;if z>_.Magnitude*1.25 and z>5 then _,U=Q,true;end;T= tbl31 .AimVelocity[R];if not U and T then Q= tune .VelocityTauMax*(1- clamp (_.Magnitude/ tune .VelocityTauSpeed,0,1));if Q>1.0E-4 then l= clamp (1-math.exp(- clamp (X-T.Time,0,0.5)/Q),0,1);_=T.Velocity+(_-T.Velocity)*l;end;end;if not T then T={}; tbl31 .AimVelocity[R]=T;end;T.Velocity=_;T.Time=X;return _;end
								tbl31.ExtrapolateHorizontal = function(R,R,l,T,L)local X,Q,z=l.X*T,l.Z*T,R:FindFirstChildOfClass("Humanoid");if not z or T<=0 then return X,Q;end;local Y=z.MoveDirection;local U=z.WalkSpeed;if not  tbl28 :IsFiniteVector(Y)or type(U)~="number"or U~=U or U<0 or U== huge then return X,Q;end;local _= sqrt (Y.X*Y.X+Y.Z*Y.Z);if _<0.01 then return X,Q;end;local E= sqrt (l.X*l.X+l.Z*l.Z);if E<=1 then return X,Q;end;local Z=(l.X*Y.X+l.Z*Y.Z)/(E*_);if Z<=0.5 then return X,Q;end;local x=R:FindFirstChild("HumanoidRootPart");R=x and x.AssemblyLinearVelocity;if not  tbl28 :IsFiniteVector(R)then return X,Q;end;x= sqrt (R.X*R.X+R.Z*R.Z);if x<=1 or x<E*0.75 or x>E*1.25 then return X,Q;end;local j=(R.X*Y.X+R.Z*Y.Z)/(x*_);if j<=0.8 then return X,Q;end;R= clamp (U* min (_,1), min (E,x), max (E,x));local E,s,C,d=Y.X/_*R,Y.Z/_*R,pcall(z.GetState,z);if not C then return X,Q;end;Y=d==Enum.HumanoidStateType.Freefall or d==Enum.HumanoidStateType.Jumping or z.FloorMaterial==Enum.Material.Air;if d~=Enum.HumanoidStateType.Running and d~=Enum.HumanoidStateType.RunningNoPhysics and d~=Enum.HumanoidStateType.Freefall and d~=Enum.HumanoidStateType.Jumping then return X,Q;end;local R= tbl32 .GroundAcceleration*(Y and  tbl32 .AirAccelerationScale or 1);x,U= fn32 (l.X,l.Z,E,s,R,T);E= clamp (L or 0,0,1)* clamp ((Z-0.5)*2,0,1)* clamp ((j-0.8)*5,0,1);return X+(x-X)*E,Q+(U-Q)*E;end
								tbl31.VerticalDisplacement = function(R,R,l,T,L,X)if L<=0 then return 0;end;local Q=R:FindFirstChildOfClass("Humanoid");local z= abs (T.Y)>= tune .GroundedEpsilon;if Q then local Y,U=pcall(Q.GetState,Q);z=if Y then U==Enum.HumanoidStateType.Freefall or U==Enum.HumanoidStateType.Jumping or(U==Enum.HumanoidStateType.Running or U==Enum.HumanoidStateType.RunningNoPhysics)and Q.FloorMaterial==Enum.Material.Air else z;end;local Y= originalSizes [l]or l.Size;local U=(Q and Q.HipHeight or 0)+Y.Y*0.5;if Q and Q.RigType==Enum.HumanoidRigType.R6 then Y=R:FindFirstChild("Left Leg");U=if Y then U+( originalSizes [Y]or Y.Size).Y else U;end;local _=l.Position;if  abs (T.Y)< tune .GroundedEpsilon then l=nil;if X then Y=X.Floor;l=Y.Found and Y.Normal.Y>0.5 and Y.Height or nil;else l=if Q and Q.FloorMaterial~=Enum.Material.Air then( tbl31 :GetGroundY(_,R))else l;end;if l and _.Y-l<=U+0.15 then return 0;end;end;l=T.Y*L;if not z then return l;end;local Q= Workspace .Gravity;if Q~=Q or Q<0 or Q== huge then return l;end;l-=0.5*Q*L*L;if l>=0 then return l;end;X= tbl31 :GetGroundY(_+ vector3 (T.X*L,0,T.Z*L),R);if X then local R=X+U-_.Y;l=if R<=0 then( max (l,R))else l;end;return l;end
							end
						end

						local tbl32, fn32, tbl33, tbl34

						do
							do
								do
									tbl31.ComputeInterception = function(...) end
									raycastParams().FilterType = include
									tbl27.RewriteGun = function(...) end

									tbl27.ActivateGun = function()
										error("devirt: symbolic next pc/mode: (r4 Add 1) / 195 (at 195:39)")
									end

									tbl32 = {
										Target = nil,
										CamFOVCircle = nil,
										DeadzoneCircle = nil,
										MouseHistory = {},
										MouseHistoryIndex = v85[64],
										MouseHistoryCount = 0,
										MouseSpeedSum = v85[64],
										NaturalMouseSpeed = v85[64],
										LastMousePos = nil,
										CurveProgress = 0,
										CamlockTarget = nil,
										ToggleHadTarget = false,
										CamLastTarget = nil,
										SnapState = nil,
										ReactionUntil = 0,
										FOVGrace = 0.08,
										AvgDt = v85[199],
									}

									local function fn33(R,l,T)local L=- huge ;local X=nil;if  abs (l.X)<1.0E-4 then if R.X<-T.X or R.X>T.X then return false;end;X= huge ;else local Q,z=(-T.X-R.X)/l.X,(T.X-R.X)/l.X;if Q>z then Q,z=z,Q;end;L,X=if Q>L then Q else L,if z< huge then z else  huge ;if L>X then return false;end;end;if  abs (l.Y)<1.0E-4 then if R.Y<-T.Y or R.Y>T.Y then return false;end;else local Q,z=(-T.Y-R.Y)/l.Y,(T.Y-R.Y)/l.Y;if Q>z then z,Q=Q,z;end;L,X=if Q>L then Q else L,if z<X then z else X;if L>X then return false;end;end;if  abs (l.Z)<1.0E-4 then if R.Z<-T.Z or R.Z>T.Z then return false;end;else local n,Q=(-T.Z-R.Z)/l.Z,(T.Z-R.Z)/l.Z;if n>Q then Q,n=n,Q;end;L,X=if n>L then n else L,if Q<X then Q else X;end;return L<=X and X>=0;end
								end

								tbl32.ResetSnapState = function(R)local R= tbl32 .SnapState;if not R then R={wasLocked=false,wasOnBody=false}; tbl32 .SnapState=R;end;R.wasLocked=false;R.wasOnBody=false; tbl32 .CurveProgress=0;end

								do
									local tbl35 = {
										Inactive = Color3.fromRGB(255, 255, 255),
										Active = Color3.fromRGB(50, 205, 50),
										Deadzone = Color3.fromRGB(255, v85[80], 0),
										DeadzoneInactive = Color3.fromRGB(v85[28], 128, 128),
									}

									tbl32.ComputeCurvedAimPos = function(...) end
									tbl32.TrackMouseHistory = function(R,R)local l= tbl32 .LastMousePos or R;local T=R.X-l.X;local L=R.Y-l.Y;local X= service2 :GetMouseDelta().Magnitude;X=if X<=0 then( sqrt (T*T+L*L))else X; tbl32 .LastMousePos=R;R,T= tbl32 .MouseHistory, tbl32 .MouseHistoryIndex+1;T=if T>60 then 1 else T;l=R[T]or 0;R[T]=X; tbl32 .MouseHistoryIndex=T;T= tbl32 .MouseHistoryCount;if T<60 then T+=1; tbl32 .MouseHistoryCount=T;end; tbl32 .MouseSpeedSum= tbl32 .MouseSpeedSum-l+X; tbl32 .NaturalMouseSpeed= tbl32 .MouseSpeedSum/T;end
									tbl32.DrawCircleFOV = function(R,R,l)local T=R.FOV or{};local R,L,X=T["FOV Type"]or"Circle";if R=="Circle"then L,X=tonumber(T.Circle and T.Circle.Radius)or 365,tonumber(T.Circle and T.Circle["Deadzone Radius"])or 65;else L,X=365,65;end;if  new and(T["Show FOV"]and R=="Circle")then if not  tbl32 .CamFOVCircle then  tbl32 .CamFOVCircle= new ("Circle"); tbl32 .CamFOVCircle.NumSides=32; tbl32 .CamFOVCircle.Thickness=2; tbl32 .CamFOVCircle.Transparency=0.85; tbl32 .CamFOVCircle.Color= tbl35 .Inactive; tbl32 .CamFOVCircle.Visible=true;end; tbl32 .CamFOVCircle.Position=l; tbl32 .CamFOVCircle.Radius=L; tbl32 .CamFOVCircle.Visible=true;elseif  tbl32 .CamFOVCircle then  tbl32 .CamFOVCircle.Visible=false;end;if  new and(T["Show Deadzone FOV"]and R=="Circle")then if not  tbl32 .DeadzoneCircle then  tbl32 .DeadzoneCircle= new ("Circle"); tbl32 .DeadzoneCircle.NumSides=32; tbl32 .DeadzoneCircle.Thickness=2; tbl32 .DeadzoneCircle.Transparency=0.85; tbl32 .DeadzoneCircle.Color= tbl35 .DeadzoneInactive; tbl32 .DeadzoneCircle.Visible=true;end; tbl32 .DeadzoneCircle.Position=l; tbl32 .DeadzoneCircle.Radius=X; tbl32 .DeadzoneCircle.Visible=true;elseif  tbl32 .DeadzoneCircle then  tbl32 .DeadzoneCircle.Visible=false;end;end
								end
							end

							do
								tbl32.RollRange = function(R,R,l,T)local L=type(R)=="table"and R[1];local R,X=type(L)=="table"and(tonumber(L[1]))or l,type(L)=="table"and(tonumber(L[2]))or T;if X<R then X,R=R,X;end;return(R+ random2 ()*(X-R))/1000;end
								tbl32.UsableTarget = function(R,R)return R and R.Character and( fn30 (R))and not  fn31 (R);end
								tbl32.RampBoost = 0.6
								tbl32.RampSpeedBoost = 0.5
								tbl32.RampInner = 0.28
								tbl32.FOVPixelRadius = function(...) end
								tbl32.RampScale = function(R,R,l,T,L,X)local Q= tbl32 :FOVPixelRadius(R,L.Z);local z=Q* tbl32 .RampInner;local Y=0;if Q>z then local U,_=L.X-X.X,L.Y-X.Y;Y=( clamp (( sqrt (U*U+_*_)-z)/(Q-z),0,1));end;if Y<=0 then return 1;end;z,L=1+Y* tbl32 .RampBoost,l.Speed;R=type(L)=="table"and L[1];Q,X=type(R)=="table"and(tonumber(R[1]))or 4,type(R)=="table"and(tonumber(R[2]))or 20;if X<Q then X,Q=Q,X;end;if T and X>Q then l=T.AssemblyLinearVelocity;z+=Y* clamp (( sqrt (l.X*l.X+l.Z*l.Z)-Q)/(X-Q),0,1)* tbl32 .RampSpeedBoost;end;return z;end
								tbl32.ReadSnappiness = function(n,n)if n.Type=="Advanced"then local R=type(n.Advanced)=="table"and n.Advanced[1]or nil;return R and(tonumber(R[1]))or 0.5,R and(tonumber(R[2]))or 0.5;end;local R=tonumber(n.Simple)or 0.5;return R,R;end
								tbl32.ApplyMovement = function(...) end
								tbl32.Update = function(...) end

								tbl12 = {
									LastTool = nil,
									ToolSwitchTime = 0,
									ToolSwitchDelay = 0,
									LastTarget = nil,
									MouseInFOV = v85[74],
									MouseEnterTime = v85[64],
									EntryDelay = 0,
									NextShotTime = fn29({}, { __mode = "k" }),
									HoodCustomsGunData = nil,
									NormNameCache = {},
									WeaponDelayMap = {},
									WeaponDelaysSource = nil,
									ExactFilter = { nil },
									GetExactHit = function(...) end,
									GetWeaponDelays = function(R,R,l)local T=R["Weapon Delays"]or{};if  tbl12 .WeaponDelaysSource~=T then R={};for L,L in pairs(T)do if type(L)=="table"and type(L.Weapons)=="table"then for X,X in ipairs(L.Weapons)do R[X:gsub("[%[%]]","")]=L;end;end;end; tbl12 .WeaponDelayMap=R; tbl12 .WeaponDelaysSource=T;end;T= tbl12 .NormNameCache[l.Name];if not T then T=l.Name:gsub("[%[%]]",""); tbl12 .NormNameCache[l.Name]=T;end;R= tbl12 .WeaponDelayMap[T];if type(R)~="table"or R.Enabled~=true then return nil;end;return R;end,
									RollDelay = function(R,R,l)if not R then return 0;end;local T=R[l];if type(T)~="table"or T[1]~=true then return 0;end;R=tonumber(T[2])or 0;l=tonumber(T[3])or R;if l<R then l,R=R,l;end;return(R+ random2 ()*(l-R))/1000;end,
									GetGunCooldown = function(...) end,
									TrackState = function(R,R,l,T)if R~= tbl12 .LastTool then  tbl12 .LastTool=R; tbl12 .ToolSwitchTime=T; tbl12 .ToolSwitchDelay=nil;end;if l~= tbl12 .LastTarget then  tbl12 .LastTarget=l; tbl12 .MouseInFOV=false;end;end,
									Ready = function(R,R,l,T)if  tbl12 .ToolSwitchDelay==nil then  tbl12 .ToolSwitchDelay= tbl12 :RollDelay(R,"Tool Switch");end;if T- tbl12 .ToolSwitchTime< tbl12 .ToolSwitchDelay then return false;end;if T- tbl12 .MouseEnterTime< tbl12 .EntryDelay then return false;end;return T>=( tbl12 .NextShotTime[l]or 0);end,
									Update = function(...) end,
								}

								fn32 = function(...) end
								tbl27.IsRageModeActive = function(...) end

								do
									local new3 = ColorSequenceKeypoint.new
									local color = Color3.fromRGB
									local v91 = v85[192]

									tbl33 = {
										NumberSequenceZero = NumberSequence.new(v85[64]),
										BeamColorCache = {
											None = ColorSequence.new({
												ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 242, 90)),
												new3(1, color(255, 209, v91)),
											}),
											[v85[39]] = ColorSequence.new(Color3.fromRGB(v85[7], v85[64], 0)),
											Blue = ColorSequence.new(Color3.fromRGB(0, 170, 255)),
											Orange = ColorSequence.new(Color3.fromRGB(255, v85[186], 0)),
											[v85[31]] = ColorSequence.new(Color3.fromRGB(0, 255, 0)),
											Arctic = ColorSequence.new(Color3.fromRGB(170, 255, v85[7])),
											["Blacksteel Dragon"] = ColorSequence.new(Color3.fromRGB(v85[186], 170, 255)),
											["Black Cat"] = ColorSequence.new(Color3.fromRGB(41, 255, 36)),
											Cupid = ColorSequence.new(Color3.fromRGB(237, 148, 255)),
											Beta = ColorSequence.new(Color3.fromRGB(255, v85[143], v85[68])),
											Hallows = ColorSequence.new(Color3.fromRGB(v85[7], 120, v85[109])),
											[v85[193]] = ColorSequence.new(Color3.fromRGB(160, v85[116], 255)),
											Kitty = ColorSequence.new(Color3.fromRGB(237, 148, 255)),
											[v85[122]] = ColorSequence.new(Color3.fromRGB(v85[64], v85[64], 0)),
											White = ColorSequence.new(Color3.fromRGB(255, 255, v85[7])),
										},
										GunNames = {
											"[Revolver]",
											"[DoubleBarrel]",
											"[Shotgun]",
											"[Silencer]",
											"[TacticalShotgun]",
											"[SMG]",
											"[Flintlock]",
											"[Firework Launcher]",
										},
										GunData = {
											["[Revolver]"] = {
												cooldown = v85[189],
												slowdown_time = 0.2,
												damage = v85[168],
												headshot_damage = v85[17],
											},
											["[DoubleBarrel]"] = {
												cooldown = 0.4,
												slowdown_time = 0.4,
												damage = v85[171],
												headshot_damage = 40,
												is_shotgun = true,
											},
											["[TacticalShotgun]"] = {
												cooldown = 0.7,
												slowdown_time = 0.6,
												damage = v85[180],
												headshot_damage = 34,
												is_shotgun = true,
											},
											["[Shotgun]"] = {
												cooldown = 1.35,
												slowdown_time = v85[72],
												damage = v85[171],
												headshot_damage = 40,
												is_shotgun = true,
											},
											["[SMG]"] = {
												cooldown = 0.07,
												slowdown_time = v85[76],
												damage = 10,
												headshot_damage = v85[147],
												auto = v85[30],
											},
											["[Silencer]"] = {
												cooldown = v85[86],
												slowdown_time = 0.4,
												damage = v85[177],
												headshot_damage = 64,
											},
											["[Flintlock]"] = {
												cooldown = 0.2,
												slowdown_time = 0.2,
												damage = 60,
												headshot_damage = v85[100],
											},
										},
										GunDataDefault = {
											cooldown = 0.3,
											slowdown_time = 0.3,
											damage = 20,
											headshot_damage = 40,
										},
									}
								end
							end

							tbl12.HoodCustomsGunData = tbl33.GunData
							tbl33.Maid = { Connections = {} }
							tbl33.Maid.Cleanup = function(n,R)if n.Connections[R]then n.Connections[R]:Disconnect();n.Connections[R]=nil;end;end
							tbl33.Maid.Add = function(n,R,l)n:Cleanup(R);n.Connections[R]=l;end
							tbl33.CanInteract = function(...) end
							tbl33.GetRedirectedTarget = function(...) end
							tbl33.KnifeSpeed = 1000
							tbl33.KnifeSolveSteps = 3
							tbl33.GetKnifeThrowDirection = function(...) end
							tbl33.DisableMotor6Ds = function(n,n)for R,l in ipairs(n:GetDescendants())do if l:IsA("Motor6D")then R=l.Parent and l.Parent.Name;if R~="Head"and R~="RightHand"and R~="LeftHand"and R~="LeftFoot"and R~="RightFoot"then if l.Parent.Parent and(l.Parent.Parent:FindFirstChildOfClass("Humanoid"))then l.Enabled=false;end;end;end;end;end
							tbl33.ReEnableMotor6Ds = function(R,R,l) delay (1,function()if l.Parent and(l.Parent:FindFirstChild("BodyEffects"))and(l.Parent.BodyEffects:FindFirstChild("K.O"))and l.Parent.BodyEffects["K.O"].Value==false then for n,l in ipairs(R:GetDescendants())do if l:IsA("Motor6D")then n=l.Parent and l.Parent.Name;if n~="Head"and n~="RightHand"and n~="LeftHand"and n~="LeftFoot"and n~="RightFoot"then if l.Parent.Parent and(l.Parent.Parent:FindFirstChildOfClass("Humanoid"))then l.Enabled=true;end;end;end;end;end;end);end
							tbl33.ApplyHitDamage = function(R,R,R,l,T,L)local X=T.damage;local Q=false; v88 (function()Q= localPlayer .DataFolder.DisableDamageIndicators.Value;end);if not Q then T= ReplicatedStorage :FindFirstChild("MainBindedEvent");if T then T:Fire("DamageIndicatorText",X,R,L,false);end;end;if l.Health-X<0.5 then l.Health=0.5;R=l.Parent;if R and(R:FindFirstChild("BodyEffects"))and R.BodyEffects.Grabbed.Value==nil then  tbl33 :DisableMotor6Ds(R); tbl33 :ReEnableMotor6Ds(R,l);end;else l:TakeDamage(X);end;end
							tbl33.IsValidHit = function(R,R,l)if not R then return false;end;local T=R.Parent:FindFirstChildOfClass("Humanoid")or R.Parent.Parent and(R.Parent.Parent:FindFirstChildOfClass("Humanoid"))or R.Parent.Parent.Parent and(R.Parent.Parent.Parent:FindFirstChildOfClass("Humanoid"));if not T then return false;end;local L= Players :GetPlayerFromCharacter(T.Parent);local X,Q=R:IsDescendantOf( Workspace :FindFirstChild("Players")and( Workspace .Players:FindFirstChild("InBox"))),l and(l:FindFirstChild("Script"));local l,z=Q and(Q:FindFirstChild("CanHitPlayer"))and Q.CanHitPlayer.Value,Q and(Q:FindFirstChild("CanHitPlayer2"))and Q.CanHitPlayer2.Value;local Q=X and(L==l or L==z);local l=R:IsDescendantOf( Workspace :FindFirstChild("Players")and( Workspace .Players:FindFirstChild("Characters")));local R=false;local L=false; v88 (function()R= localPlayer .DataFolder.PVP.Value;end); v88 (function()L= ReplicatedStorage .SERVER_IS_BOT_TRAINING.Value;end);return Q or l and R or L,T;end
							tbl33.ApplyFlintlockKnockback = function(R,R,l,T,L,X)local Q=R and(R:FindFirstChild("Script"));if Q and(Q:FindFirstChild("CAN_RELOAD"))then Q.CAN_RELOAD.Value=false;end;R= ReplicatedStorage :FindFirstChild("FlintlockExplosion");if R then local z=R:Clone(); Debris :AddItem(z,3);z.Position=T;z.Parent= Workspace :FindFirstChild("Ignored")or  Workspace ;if z:FindFirstChild("Attachment")then for R,R in ipairs(z.Attachment:GetChildren())do if R:IsA("ParticleEmitter")then R:Emit(10);end;end;end;end;local R,z=l and(l:FindFirstChild("HumanoidRootPart")),l and(l:FindFirstChildOfClass("Humanoid"));if not R or not z then return;end;local Y=-(X-R.Position).Unit;l=( vector3 (Y.X,0,Y.Z).Unit+ vector3 (0,Y.Y*2,0)).Unit;Y=(if l.Y<0 and z.FloorMaterial~=Enum.Material.Air then  vector3 (l.X,0,l.Z).Unit else l)*95;Y=if L==nil or(T-X).Magnitude>30 then Y*0.25 else if z.FloorMaterial~=Enum.Material.Air then Y*1.5 else Y;z:ChangeState(Enum.HumanoidStateType.Jumping);local l= new2 ("BodyVelocity");l:SetAttribute("AllowedBM",true);l.Name="IgnoredVelocity";l.MaxForce= vector3 (7000000,7000000,7000000);l.Velocity=Y;l.Parent=R;local T,L,X=tick(),tick(), vector3 (Y.X,0,Y.Z);local Y=X.Magnitude;local U=Y>0 and X/Y or  vector4 ;local X=nil;local _= raycastParams ();_.FilterType=Enum.RaycastFilterType.Exclude;_.FilterDescendantsInstances={ Workspace :FindFirstChild("Ignored"), Workspace :FindFirstChild("Players")};X= service .Heartbeat:Connect(function(E)local Z=tick();local x=Z-T;if(z.FloorMaterial==Enum.Material.Air or x<=0.2)and x<=7 then local T,z=U*(Y+25* min ((Z-L)/0.5,1)), min (x/2,1);local L,Y=(1-z)*60+z* Workspace .Gravity,l.Velocity;z=Y.Y-( Workspace .Gravity-L)*E-25*E;if  Workspace :Raycast(R.Position,Y.Unit*10,_)then l.Velocity= vector4 ;l:Destroy();X:Disconnect();if Q and(Q:FindFirstChild("CAN_RELOAD"))then Q.CAN_RELOAD.Value=true;end;else l.Velocity=T+ vector3 (0,z,0);end;else X:Disconnect();l.Velocity= vector4 ;l:Destroy();if Q and(Q:FindFirstChild("CAN_RELOAD"))then Q.CAN_RELOAD.Value=true;end;end;end);end
							tbl33.GetBulletColor = function(R,R,R,l,T)if not l then return;end;local L= tbl33 .BeamColorCache;if R=="None"then l.Color=L.None;elseif R=="Red"then l.Color=L.Red;elseif R=="Blue"then l.Color=L.Blue;elseif R=="Orange"then l.Color=L.Orange;elseif R=="Green"then l.Color=L.Green;elseif R=="Arctic"then l.Color=L.Arctic;l.Transparency= numberSequence ;elseif R=="Blacksteel Dragon"then l.Color=L["Blacksteel Dragon"];l.Transparency= numberSequence ;elseif R=="Black Cat"then l.Color=L["Black Cat"];l.Texture="rbxassetid://12781848822";l.TextureSpeed=10;l.Width1=1;l.Transparency= numberSequence ;elseif R=="Cupid"then l.Color=L.Cupid;l.Transparency= numberSequence ;l.Brightness=3;elseif R=="Beta"then l.Color=L.Beta;l.Transparency= numberSequence ; spawn_ (function()l.Width0=0.25;l.Width1=0.25; wait_ (0.05);l.Width0=0.07;l.Width1=0.07;repeat l.Width0=l.Width0-0.01;l.Width1=l.Width1-0.01; wait_ (0.03);until l.Parent==nil;end);elseif R=="Hallows"then local X,Q,z=l.Attachment0.WorldPosition,l.Attachment1.WorldPosition,l:Clone(); Debris :AddItem(z,0.4);l.Color=L.Hallows;l.Transparency= numberSequence ;l.Brightness=2.5;l.ZOffset=0.001;z.Color=L.Black;z.Transparency= numberSequence ;z.LightEmission=0;z.Width1=0.3;z.Width0=0.15;z.Parent= Workspace .Ignored; delay (0.2,function()local Y= ReplicatedStorage :FindFirstChild("BatParticles");if Y then local U=Y:Clone(); Debris :AddItem(U,2.5);U.Position=X;U.Parent= Workspace .Ignored; service3 :Create(U,TweenInfo.new(0.5,Enum.EasingStyle.Linear),{Position=Q}):Play(); delay (0.5,function()local X=U:FindFirstChild("ParticleEmitter");if X then X.Enabled=false;end;end);end;for X=1,10,1 do l.Transparency=NumberSequence.new(X*0.1);z.Transparency=NumberSequence.new(X*0.1); wait_ ();end;end);elseif R=="Kirumi"then local X=l:Clone(); Debris :AddItem(X,0.4);l.Color=L.Kirumi;l.Brightness=5;l.Transparency= numberSequence ;l.ZOffset=0.001;X.Color=L.Black;X.Transparency= numberSequence ;X.LightEmission=0;X.Width1=0.25;X.Width0=0.01;X.Parent= Workspace .Ignored;elseif R=="Kitty"then l.Color=L.Cupid;l.Transparency= numberSequence ;l.Brightness=3; spawn_ (function() wait_ (0.05);l.Width0=0.15;l.Width1=0.15; wait_ (0.05);repeat l.Width0=l.Width0-0.05;l.Width1=l.Width1-0.025; wait_ (0.022222222222222223);until l.Parent==nil;end);elseif R=="Rainbow"then l.Transparency= numberSequence ; spawn_ (function()local L=T and T.Value or 0;while l.Parent do L=(L+0.015)%1;if T then T.Value=L;end;l.Color=ColorSequence.new(Color3.fromHSV(L,1,1)); service .Heartbeat:Wait();end;end);elseif R=="Lightning"then l.Transparency=NumberSequence.new(1);end;end
							tbl33.CastRay = function(R,R,l,T)local L= raycastParams ();L.FilterType= exclude ;L.FilterDescendantsInstances=T or{};L.IgnoreWater=true;T= Workspace :Raycast(R,l,L);if T then return T.Instance,T.Position,T.Normal;end;return nil,R+l, vector4 ;end
							tbl33.DoShoot = function(...) end
							tbl33.Held = v85[74]
							tbl33.Pending = nil
							tbl33.Queue = function(R,R) tbl33 .Pending=R or true;end
							tbl33.StartWorker = function(R)if  tbl33 .Worker then return;end; tbl33 .Worker= spawn_ (function()while true do local R= tbl33 .Pending;if R~=nil then  tbl33 .Pending=nil; v88 (function()return  tbl33 :DoShoot(R~=true and R or nil);end);elseif  tbl33 .Held then local R= localPlayer .Character;local l=R and(R:FindFirstChildOfClass("Tool"));R=l and  tbl33 .GunData[l.Name];if R and R.auto then  v88 (function()return  tbl33 :DoShoot(nil);end);end;end; wait_ ();end;end);end
							tbl33.RageRange = 200
							tbl33.RageTool = function(...) end
							tbl33.RageTick = function(R)if not  tbl33 :RageTool()then return;end; tbl33 :StartWorker(); tbl33 :Queue(nil);end
							tbl33.SetupTools = fn29({}, { __mode = v85[166] })
							tbl33.SetupTool = function(...) end

							tbl33.OnCharacterAdded = function()
								error("devirt: symbolic next pc/mode: (r4 Add 1) / 59 (at 59:13)")
							end

							tbl33.Init = function()
								error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:1)")
							end

							tbl33.Shoot = function(R,R,R,R) tbl33 :StartWorker(); tbl33 :Queue(R);end
							tbl33:Init()
							tbl27.VoidFallsClientRedirection.Init()

							if not (tbl24.CurrentGame and tbl24.CurrentGame.Method == v85[55]) then
								do
									local function fn33()
										error("devirt: symbolic next pc/mode: (r3 Add 1) / 195 (at 195:478)")
									end

									if localPlayer.Character then
										fn33(localPlayer.Character)
									end

									localPlayer.CharacterAdded:Connect(fn33)
								end

								if localPlayer.Character then
									tbl27:ActivateGun(localPlayer.Character)
								end

								localPlayer.CharacterAdded:Connect(function(...) end)
							end

							tbl34 = { WallJumpParams = raycastParams() }
							tbl34.WallJumpParams.FilterType = Enum.RaycastFilterType.Exclude
							tbl34.WallJumpFilter = {}
							tbl34.PanicParams = raycastParams()
							tbl34.PanicParams.FilterType = Enum.RaycastFilterType.Exclude
							tbl34.PanicParams.IgnoreWater = true
							tbl34.PanicFilter = {}
							tbl34.GetLocalHumanoid = function(R)local R= localPlayer .Character;return R,R and(R:FindFirstChildOfClass("Humanoid"));end
							tbl34.Update = function(...) end
							tbl34.RemoveJumpPower = function(...) end
							tbl34.UpdateDerHood = function(...) end
							tbl34.WallDetectRange = 3
							tbl34.WallMaxNormalY = 0.5
							tbl34.GetWall = function(R,R,l)local T=1; tbl34 .WallJumpFilter[1]=R;R= Workspace :FindFirstChild("Ignored");if R then T=2; tbl34 .WallJumpFilter[T]=R;end;R= Workspace :FindFirstChild("Bush");if R then T+=1; tbl34 .WallJumpFilter[T]=R;end;for L=T+1,# tbl34 .WallJumpFilter,1 do  tbl34 .WallJumpFilter[L]=nil;end; tbl34 .WallJumpParams.FilterDescendantsInstances= tbl34 .WallJumpFilter;R=l.CFrame;local T,L,X=R.LookVector,R.RightVector, tbl34 .WallDetectRange;R={T,-T,L,-L,T+L,T-L,-T+L,-T-L};for Q,Q in ipairs(R)do L=Q.Unit;if L.X==L.X then T= Workspace :Raycast(l.Position,L*X, tbl34 .WallJumpParams);if T and T.Instance and T.Instance.CanCollide and T.Instance.Transparency<1 and  abs (T.Normal.Y)<= tbl34 .WallMaxNormalY then return T;end;end;end;return nil;end
							tbl34.GetWallJumpPower = function(n,n,R)local l,T=R.Multipliers or{},n:FindFirstChildOfClass("Tool");if T and T.Name=="[Knife]"then return 50*(l.Knife and l.Knife.Multiplier or 1.4);end;return 50*(l.Regular and l.Regular.Multiplier or 1.2);end
							tbl34.SpidermanActive = function(n,n)return n.Mode=="Infinite"and n.Spiderman==true;end
							tbl34.WallJumpsUsed = 0
							tbl34.StepWallJumpReset = function(R)local R,R= tbl34 :GetLocalHumanoid();if not R then return;end;if R.FloorMaterial~=Enum.Material.Air then  tbl34 .WallJumpsUsed=0;end;end

							tbl34.WallJump = function()
								error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:1577)")
							end

							tbl34.StepSpiderman = function(...) end

							tbl24:AddRoutine("Heartbeat", function()
								tbl34:StepSpiderman()
							end)

							tbl24:AddRoutine("Heartbeat", function()
								tbl34:StepWallJumpReset()
							end)

							tbl34.PanicGround = function()
								error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:974)")
							end

							tbl13 = {
								Map = {
									["Proggy Clean"] = Enum.Font.SourceSans,
									["Smallest Pixel-7"] = Enum.Font.SourceSans,
									[v85[104]] = Enum.Font.SourceSans,
									Minecraftia = Enum.Font.SourceSans,
									TahomaBold = Enum.Font.SourceSansBold,
								},
								Downloads = {
									Tahoma = {
										TTF = "https://github.com/LuckyHub1/LuckyHub/raw/main/zekton_rg.ttf",
									},
									Minecraftia = {
										TTF = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Minecraftia.ttf",
									},
									["Smallest Pixel-7"] = {
										TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf",
									},
									["Proggy Clean"] = {
										TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf",
									},
									TahomaBold = {
										TTF = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Tahoma-Modern-Bold.ttf",
									},
								},
								Folder = "Prosper/Fonts",
								Default = Enum.Font.GothamBold,
								Faces = {},
								Failed = {},
								Pending = {},
								WarnShown = false,
								DrawingEnums = {
									[v85[160]] = Enum.Font.Gotham,
									[v85[141]] = Enum.Font.Legacy,
									Plain = Enum.Font.SourceSans,
									Monospace = Enum.Font.Code,
								},
								DrawingIds = {
									UI = v85[64],
									[v85[141]] = 1,
									Plain = 2,
									[v85[24]] = v85[118],
									GothamBold = 0,
									["Proggy Clean"] = 2,
									["Smallest Pixel-7"] = v85[109],
									Tahoma = 1,
									Minecraftia = 2,
									TahomaBold = 1,
								},
								HasFileSystem = function(n)return type(writefile)=="function"and type(isfile)=="function"and type(getcustomasset)=="function";end,
								EnsureFolder = function(R)if type(isfolder)~="function"or type(makefolder)~="function"then return;end;local R=nil;for l in  tbl13 .Folder:gmatch("[^/]+")do R=R and R.."/"..l or l;if not isfolder(R)then  v88 (makefolder,R);end;end;end,
								Download = function(...) end,
								Register = function(...) end,
								Enum = function(R,R)if not R then return  tbl13 .Default;end;local l= tbl13 .Map[R];if l then return l;end;local l,T= v88 (function()return Enum.Font[R];end);if l and T then return T;end;return  tbl13 .Default;end,
								Defaults = {
									["ESP Names"] = { "Custom", "Minecraftia", 12 },
									["ESP Numbers"] = { "Custom", "Smallest Pixel-7", v85[18] },
									["ESP Distance"] = { v85[12], "Smallest Pixel-7", v85[18] },
									Information = { "Roblox", "SourceSansBold", 12 },
								},
								Fallback = { "Roblox", "GothamBold", v85[38] },
								Entry = function(...) end,
								Apply = function(R,R,l)if not R then return;end;local T,L,X= tbl13 :Entry(l);if R.TextSize~=X then R.TextSize=X;end;if T=="Drawing"then X= tbl13 .DrawingEnums[L]or  tbl13 .Default;if R.Font~=X then R.Font=X;end;return;end;if T=="Custom"then X= tbl13 .Faces[L];if X then if R.FontFace~=X then R.FontFace=X;end;return;end;if not  tbl13 .Failed[L]and not  tbl13 .Pending[L]then  tbl13 .Pending[L]=true;task.spawn(function() tbl13 :Register(L); tbl13 .Pending[L]=nil;end);end;l= tbl13 .Map[L];if l then if R.Font~=l then R.Font=l;end;return;end;end;T= tbl13 :Enum(L);if R.Font~=T then R.Font=T;end;end,
								Preload = function()
									error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:18)")
								end,
							}

							tbl13:Preload()

							tbl14 = {
								FeetNames = { "LeftFoot", "RightFoot", "Left Leg", v85[159] },
								GetESPGui = function(...) end,
								CreateEspText = function(R,R)local l= tbl14 :GetESPGui();local T= new2 ("TextLabel");T.BackgroundTransparency=1;T.BorderSizePixel=0;T.AnchorPoint= vector2 (0.5,0.5);T.Size=UDim2.new(0,400,0,14);T.TextXAlignment=Enum.TextXAlignment.Center;T.TextYAlignment=Enum.TextYAlignment.Center;T.TextStrokeTransparency=0;T.TextStrokeColor3=Color3.fromRGB(0,0,0); tbl13 :Apply(T,R);T.Visible=false;T.ZIndex=3;T.Parent=l;return T;end,
							}

							tbl14.CollectParts = function(R,R,l)local T=l and l.Parts;if T then for L=#T,1,-1 do T[L]=nil;end;else T={};if l then l.Parts=T;end;end;local l=0;for L,L in  v86 (R:GetChildren())do if L:IsA("BasePart")and L.Name~="HumanoidRootPart"then l+=1;T[l]=L;end;end;return T,l;end
							tbl14.MeasureExtents = function(R,R,l,T)local L=T.CFrame:Inverse();local X,Q,z,Y,U,_,E= huge ,- huge , huge ,- huge , huge ,- huge ,false;for Z=1,l,1 do T=R[Z];if T.Parent then local R,l=L*T.CFrame,T.Size*0.5;local T=R.RightVector;local L=R.UpVector;local Z=-R.LookVector;local x,j,s,C= abs (T.X)*l.X+ abs (L.X)*l.Y+ abs (Z.X)*l.Z, abs (T.Y)*l.X+ abs (L.Y)*l.Y+ abs (Z.Y)*l.Z, abs (T.Z)*l.X+ abs (L.Z)*l.Y+ abs (Z.Z)*l.Z,R.Position;X,Q,z,Y,U,_,E=if C.X-x<X then C.X-x else X,if C.X+x>Q then C.X+x else Q,if C.Y-j<z then C.Y-j else z,if C.Y+j>Y then C.Y+j else Y,if C.Z-s<U then C.Z-s else U,if C.Z+s>_ then C.Z+s else _,true;end;end;if not E then return nil,nil;end;return  vector3 ((X+Q)*0.5,(z+Y)*0.5,(U+_)*0.5), vector3 ((Q-X)*0.5,(Y-z)*0.5,(_-U)*0.5);end
							tbl14.GetScreenBounds = function(...) end
							tbl14.Updaters = {}
							tbl14.Update = function(R,R)for l,l in  v86 ( tbl14 .Updaters)do  v88 (l,R);end;end
							tbl14.Create = function(...) end

							tbl14.Init = function()
								error("devirt: symbolic next pc/mode: (r3 Add 1) / 195 (at 195:58)")
							end

							tbl14:Init()
							;({
								Active = false,
								NormalizeWeaponName = function()
									error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:319)")
								end,
								WeaponMatches = function()
									error("devirt: symbolic next pc/mode: (r3 Add 1) / 195 (at 195:410)")
								end,
							}).Sort = function()
								error("devirt: symbolic next pc/mode: (r23 Add 1) / 195 (at 195:2603)")
							end

							tbl15 = {
								CopyClasses = {
									"Shirt",
									"Pants",
									v85[79],
									"Accessory",
									"Hat",
									"BodyColors",
									"CharacterMesh",
								},
								Applying = false,
								SkinnyBodyScales = {
									BodyTypeScale = 0,
									DepthScale = v85[86],
									HeadScale = 1,
									HeightScale = v85[196],
									ProportionScale = 0,
									WidthScale = 0.5,
								},
								BodyScaleMap = {
									BodyTypeScale = v85[164],
									DepthScale = "BodyDepthScale",
									HeadScale = v85[32],
									HeightScale = "BodyHeightScale",
									ProportionScale = "BodyProportionScale",
									WidthScale = v85[138],
								},
								AnimIdUrl = "rbxassetid://",
								IsCopyClass = function(R,R)for l,l in ipairs( tbl15 .CopyClasses)do if R==l then return true;end;end;return false;end,
								ResolveUserId = function(R,R)if type(R)=="number"then return R>0 and R or nil;end;if type(R)~="string"then return nil;end;local l=tonumber(R);if l and l>0 then return l;end;local l,T= v88 (function()return  Players :GetUserIdFromNameAsync(R);end);if l and T then return T;end;return nil;end,
								BindSkinnyScaleLock = function(...) end,
								SafeBuildRigFromAttachments = function(R,R)if not R or not R.Parent then return;end; v88 (function()R:BuildRigFromAttachments();end);end,
								SyncAttachments = function(R,R,l)if not R or not l then return;end;for T,T in ipairs(l:GetChildren())do if T:IsA("Attachment")then local l=R:FindFirstChild(T.Name);if l and(l:IsA("Attachment"))then  v88 (function()l.CFrame=T.CFrame;end);end;end;end;end,
								GetBodyScales = function(n,n)local R,l,T=1,1,1;if n then local L,X,Q=n:FindFirstChild("BodyWidthScale"),n:FindFirstChild("BodyHeightScale"),n:FindFirstChild("BodyDepthScale");T,l,R=if Q and(Q:IsA("NumberValue"))then Q.Value else T,if X and(X:IsA("NumberValue"))then X.Value else l,if L and(L:IsA("NumberValue"))then L.Value else R;end;return R,l,T;end,
								ScaleJointCFrame = function(R,R,l,T,L)local X=R.Position;return R-X+ vector3 (X.X*l,X.Y*T,X.Z*L);end,
								SyncJoints = function(R,R,l,T)if not R or not l then return;end;local L,X,Q= tbl15 :GetBodyScales(T);if L~=1 or X~=1 or Q~=1 then return;end;local T,z,Y= tbl15 :GetBodyScales(l:FindFirstChildOfClass("Humanoid"));local U,_,E=T~=0 and L/T or L,z~=0 and X/z or X,Y~=0 and Q/Y or Q;for L,L in ipairs(R:GetChildren())do if L:IsA("BasePart")then T=l:FindFirstChild(L.Name);if T and(T:IsA("BasePart"))then for R,R in ipairs(L:GetChildren())do if R:IsA("Motor6D")then local l=T:FindFirstChild(R.Name);if l and(l:IsA("Motor6D"))then  v88 (function()R.C0= tbl15 :ScaleJointCFrame(l.C0,U,_,E);R.C1= tbl15 :ScaleJointCFrame(l.C1,U,_,E);end);end;end;end;end;end;end;end,
								UniformScale = function(R,R)local l,T,L= tbl15 :GetBodyScales(R);return l==1 and T==1 and L==1;end,
								RelinkJoints = function(R,R,l,T)for L,L in ipairs(l:GetChildren())do if L:IsA("JointInstance")then  v88 (function()L.Parent=T;end);end;end;for L,L in ipairs(R:GetDescendants())do if L:IsA("JointInstance")or(L:IsA("WeldConstraint"))then  v88 (function()if L.Part0==l then L.Part0=T;end;if L.Part1==l then L.Part1=T;end;end);end;end;end,
								SwapPart = function(R,R,l,T,L)if l.Name=="HumanoidRootPart"or l==R.PrimaryPart then return l;end;local X,Q= v88 (function()return T:Clone();end);if not X or not Q then return l;end;Q.Name=l.Name;Q.Anchored=false;Q.CFrame=l.CFrame; v88 (function()Q.CanCollide=l.CanCollide;Q.Massless=l.Massless;Q.Transparency=l.Transparency;Q.CollisionGroup=l.CollisionGroup;end);if not L then  v88 (function()Q.Size=l.Size;end);end;for T,T in ipairs(Q:GetChildren())do if T:IsA("JointInstance")or(T:IsA("WeldConstraint"))then T:Destroy();end;end;Q.Parent=R;for T,T in ipairs(l:GetChildren())do if not(T:IsA("Attachment")or(T:IsA("JointInstance"))or(T:IsA("WeldConstraint"))or(T:IsA("SpecialMesh"))or(T:IsA("Decal"))or(T:IsA("Texture"))or(T:IsA("SurfaceAppearance"))or(T:IsA("WrapTarget")))then  v88 (function()T.Parent=Q;end);end;end; tbl15 :RelinkJoints(R,l,Q); v88 (function()l:Destroy();end);return Q;end,
								CopySurfaceLayers = function(R,R,l)for T,T in ipairs(R:GetChildren())do if T:IsA("SurfaceAppearance")or(T:IsA("WrapTarget"))then T:Destroy();end;end;for T,T in ipairs(l:GetChildren())do if T:IsA("SurfaceAppearance")or(T:IsA("WrapTarget"))then  v88 (function()local n=T:Clone();if n then n.Parent=R;end;end);end;end;end,
								CopyPartGeometry = function(R,R,l,T,L)local X,Q=T:IsA("MeshPart"),l:IsA("MeshPart");if X~=Q then local z= tbl15 :SwapPart(R,l,T,L); tbl15 :SyncAttachments(z,T);return z;end;local R,z=T:FindFirstChildOfClass("SpecialMesh"),l:FindFirstChildOfClass("SpecialMesh");if R then if not z then z=R:Clone();z.Parent=l;else z.MeshId=R.MeshId;z.TextureId=R.TextureId;end; v88 (function()z.Scale=R.Scale;z.Offset=R.Offset;end);elseif z then z:Destroy();end;if X and Q then  v88 (function()l.MeshId=T.MeshId;l.TextureID=T.TextureID;end); tbl15 :CopySurfaceLayers(l,T);end;if L then  v88 (function()l.Size=T.Size;end);end; tbl15 :SyncAttachments(l,T);return l;end,
								CopyBody = function(R,R,l,T)for L,X in ipairs(R:GetChildren())do if X:IsA("BasePart")and X.Name~="Head"and X.Name~="HumanoidRootPart"then L=l:FindFirstChild(X.Name);if L and(L:IsA("BasePart"))then  tbl15 :CopyPartGeometry(R,X,L,T);end;end;end;end,
								ClearCopyClasses = function(R,R)for l,l in ipairs(R:GetChildren())do if  tbl15 :IsCopyClass(l.ClassName)then  v88 (function()l:Destroy();end);end;end;end,
								ApplyFaceTexture = function(R,R,l)local T=R:FindFirstChild("Head");if not T or not l or l==""then return;end;if T:IsA("MeshPart")and(T:FindFirstChildOfClass("FaceControls")or(T:FindFirstChildOfClass("WrapTarget")))then return;end;for L,L in ipairs(T:GetChildren())do if L:IsA("Decal")and(L.Name=="face"or L.Face==Enum.NormalId.Front)then L:Destroy();end;end;R= new2 ("Decal");R.Name="face";R.Face=Enum.NormalId.Front;R.Texture=l;R.Parent=T;end,
								RetargetWeld = function(n,n,R)if not n then return;end;local function l(T)if T and not T:IsDescendantOf(n.Parent)then return R:FindFirstChild(T.Name,true)or T;end;return T;end;n.Part0=l(n.Part0);n.Part1=l(n.Part1);end,
								NumericId = function(n,n)if n==nil then return nil;end;local R=tostring(n):match("%d+");if not R then return nil;end;n=tonumber(R);if not n or n<=0 then return nil;end;return n;end,
								ResolveEmoteId = function(n,n)if type(n)=="table"then return n.AssetId or n.id or n[1];end;return n;end,
								GetFirstAnimId = function(R,R)if not R then return nil;end;if R:IsA("Animation")then return  tbl15 :NumericId(R.AnimationId);end;for l,l in ipairs(R:GetDescendants())do if l:IsA("Animation")then return  tbl15 :NumericId(l.AnimationId);end;end;return nil;end,
								ApplyHead = function(R,R,l,T)local L,X=R:FindFirstChild("Head"),l and(l:FindFirstChild("Head"));if not L or not X then return;end;if not L:IsA("BasePart")or not X:IsA("BasePart")then return;end;l=X:FindFirstChildOfClass("SpecialMesh");if X:IsA("MeshPart")then if L:IsA("MeshPart")then  v88 (function()L.MeshId=X.MeshId;L.TextureID=X.TextureID;L.Color=X.Color;end);for Q,Q in ipairs(L:GetChildren())do if Q:IsA("Decal")or(Q:IsA("SurfaceAppearance"))or(Q:IsA("FaceControls"))or(Q:IsA("WrapTarget"))then Q:Destroy();end;end;for Q,z in ipairs(X:GetChildren())do if z:IsA("Decal")or(z:IsA("SurfaceAppearance"))or(z:IsA("FaceControls"))or(z:IsA("WrapTarget"))then Q=z:Clone();if Q then Q.Parent=L;end;end;end;for Q,Q in ipairs(R:GetDescendants())do if Q:IsA("Motor6D")and Q.Name=="Neck"then Q:Destroy();end;end;else local Q,z= v88 (function()return T.RequiresNeck;end); v88 (function()T.RequiresNeck=false;end);local Y=X:Clone();Y.Name="Head";Y.CanCollide=L.CanCollide;Y.Massless=L.Massless;Y.Transparency=L.Transparency;Y.Anchored=false;Y.CFrame=L.CFrame;for U,U in ipairs(Y:GetChildren())do if U:IsA("Motor6D")or(U:IsA("Weld"))or(U:IsA("ManualWeld"))or(U:IsA("WeldConstraint"))or U.Name=="face"and(U:IsA("Decal"))then U:Destroy();end;end;Y.Parent=R;for Y,Y in ipairs(R:GetDescendants())do if Y:IsA("Motor6D")and Y.Name=="Neck"then Y:Destroy();end;end;L:Destroy(); v88 (function()T.RequiresNeck=Q and z or true;end);end;elseif l and l.MeshId~=""then if L:IsA("MeshPart")then  v88 (function()L.Color=X.Color;end);else local R=L:FindFirstChildOfClass("SpecialMesh");if not R then l:Clone().Parent=L;else R.MeshId=l.MeshId;R.TextureId=l.TextureId;end; v88 (function()L.Color=X.Color;end);end;end;end,
								GetAnimMapFromDescription = function(R,R)local l={};local T={};local L={IdleAnimation="idle",WalkAnimation="walk",RunAnimation="run",JumpAnimation="jump",FallAnimation="fall",ClimbAnimation="climb",SwimAnimation="swim",SwimIdleAnimation="swimidle"};for X,Q in pairs(L)do local z,Y= v88 (function()return R[X];end);if z and( tbl15 :NumericId(Y))then l[Q]= tbl15 :NumericId(Y);end;end;local X,Q= v88 (function()return R:GetEmotes();end);if X and Q then for R,X in pairs(Q)do L= tbl15 :ResolveEmoteId(X);if  tbl15 :NumericId(L)then T[R]= tbl15 :NumericId(L);end;end;end;return l,T;end,
								GetAnimMapFromAnimate = function(R,R)local l={};if not R then return l;end;local T={idle=true,walk=true,run=true,jump=true,fall=true,climb=true,swim=true,swimidle=true};for L,X in ipairs(R:GetChildren())do if T[X.Name]then L= tbl15 :GetFirstAnimId(X);if L then l[X.Name]=L;end;end;end;return l;end,
								GetTargetCharacterAnimate = function(R,R)local l,T= v88 (function()return  Players :GetPlayerByUserId(tonumber(R));end);if l and T and T.Character then return T.Character:FindFirstChild("Animate");end;return nil;end,
								UpdateLocalHumanoidDescription = function(...) end,
								ApplyAnimations = function(R,R,l,T)if not R then return;end;if not(l and( v89 (l)))and not(T and( v89 (T)))then return;end;local L=R.Parent;local X=L and(L:FindFirstChildOfClass("Humanoid"));L=X and(X:FindFirstChildOfClass("Animator"));if L then for Q,Q in ipairs(L:GetPlayingAnimationTracks())do  v88 (function()Q:Stop(0);end);end;end;local function Q(z,Y)if not z then return false;end;local U=z.Parent;if not U then return false;end;local _= new2 ("Animation");_.Name=z.Name;_.AnimationId= tbl15 .AnimIdUrl..Y;_.Parent=U;z:Destroy();return true;end;L=false;if l then for z,Y in pairs(l)do X=R:FindFirstChild(z);if X then if X:IsA("Animation")then L=Q(X,Y)or L;else for z,z in ipairs(X:GetDescendants())do L=if z:IsA("Animation")then Q(z,Y)or L else L;end;end;end;end;end;if T then for X,z in pairs(T)do l=R:FindFirstChild(X);if l then for T,T in ipairs(l:GetChildren())do L=if T:IsA("Animation")then Q(T,z)or L else L;end;end;end;end;if L then R.Disabled=true; wait_ (0.05);R.Disabled=false;end;end,
								ApplyAppearance = function(R,R,l)l= tbl15 :ResolveUserId(l);if not l then return false;end;if not R then return false;end;local T=R:WaitForChild("Humanoid",5);if not T or not T:IsA("Humanoid")then return false;end;local L,X= tbl24 :Connect(R.ChildAdded,function(Q)if  tbl15 .Applying then return;end;if  tbl15 :IsCopyClass(Q.ClassName)then  v88 (function()Q:Destroy();end);end;end),false;local Q,z,Y= tbl24 :Connect(T.Died,function()X=true;end), v88 (function()return  Players :GetHumanoidDescriptionFromUserIdAsync(tonumber(l));end);if not z or not Y then L:Disconnect();Q:Disconnect();return false;end;local U,_= v88 (function()return  Players :CreateHumanoidModelFromDescriptionAsync(Y,T.RigType);end);if not U or not _ then L:Disconnect();Q:Disconnect();return false;end; tbl15 :ClearCopyClasses(R);local E,Z,x=R:FindFirstChild("Animate"), tbl15 :GetAnimMapFromDescription(Y); tbl15 .Applying=true; tbl15 :UpdateLocalHumanoidDescription(T,Y); tbl15 .Applying=false;U=_:FindFirstChild("Animate");if U then for j,s in pairs(( tbl15 :GetAnimMapFromAnimate(U)))do Z[j]=s;end;end;U= tbl15 :GetTargetCharacterAnimate(l);if U then for l,j in pairs(( tbl15 :GetAnimMapFromAnimate(U)))do Z[l]=j;end;end; tbl15 :ApplyAnimations(E,Z,x); tbl15 :CopyBody(R,_,( tbl15 :UniformScale(T))); tbl15 :ApplyHead(R,_,T); tbl15 :SafeBuildRigFromAttachments(T);L:Disconnect();for l,Z in ipairs(_:GetChildren())do if  tbl15 :IsCopyClass(Z.ClassName)then l=Z:Clone();l.Parent=R;if Z.ClassName=="Accessory"or Z.ClassName=="Hat"then  tbl15 :RetargetWeld(l:FindFirstChildWhichIsA("Weld"),R); tbl15 :RetargetWeld(l:FindFirstChildWhichIsA("ManualWeld"),R);end;end;end; tbl15 :SafeBuildRigFromAttachments(T); tbl15 :SyncJoints(R,_,T);U=_:FindFirstChild("Head");local l;if U then for T,T in ipairs(U:GetChildren())do if T:IsA("Decal")and T.Face==Enum.NormalId.Front and T.Texture~=""then l=T.Texture;break;end;end;end;if not l and z and Y and Y.Face and Y.Face~=0 then l="rbxassetid://"..Y.Face;end; tbl15 :ApplyFaceTexture(R,l);E=_:FindFirstChildOfClass("BodyColors");if E then L=R:FindFirstChildOfClass("BodyColors")or( new2 ("BodyColors"));L.HeadColor3=E.HeadColor3;L.LeftArmColor3=E.LeftArmColor3;L.TorsoColor3=E.TorsoColor3;L.RightArmColor3=E.RightArmColor3;L.LeftLegColor3=E.LeftLegColor3;L.RightLegColor3=E.RightLegColor3;L.Parent=R;for T,T in ipairs(R:GetChildren())do if T:IsA("BasePart")then local L=_:FindFirstChild(T.Name);if L and(L:IsA("BasePart"))then  v88 (function()T.Color=L.Color;end);end;end;end;elseif z and Y then U=R:FindFirstChildOfClass("BodyColors")or( new2 ("BodyColors"));if Y.HeadColor then U.HeadColor3=Y.HeadColor;end;if Y.LeftArmColor then U.LeftArmColor3=Y.LeftArmColor;end;if Y.TorsoColor then U.TorsoColor3=Y.TorsoColor;end;if Y.RightArmColor then U.RightArmColor3=Y.RightArmColor;end;if Y.LeftLegColor then U.LeftLegColor3=Y.LeftLegColor;end;if Y.RightLegColor then U.RightLegColor3=Y.RightLegColor;end;U.Parent=R;end;_:Destroy(); spawn_ (function()local T={0.05,0.12,0.24,0.4,0.65,0.95};for L,L in ipairs(T)do  wait_ (L);if not R.Parent or X or R~= localPlayer .Character then Q:Disconnect();return;end; tbl15 :ApplyFaceTexture(R,l);if  tbl15 :HeadlessEnabled()then  tbl15 :FakeHeadless(R);end;end;Q:Disconnect();end);if  tbl15 :HeadlessEnabled()then  tbl15 :FakeHeadless(R);end;Q:Disconnect();return true;end,
								ApplyToCharacter = function(...) end,
								HeadlessEnabled = function(...) end,
								FakeHeadless = function(n,n)if not n then return;end;local R=n:FindFirstChild("Head");if not R then return;end;R.Transparency=1;n=R:FindFirstChild("face")or(R:FindFirstChild("Face"));if n then n:Destroy();end;n=R:FindFirstChildOfClass("SpecialMesh");if n then n:Destroy();end;end,
								FakeKorblox = function(R,R)if not R then return;end;local l=R:FindFirstChild("KorbloxMeshParts");if l then l:Destroy();end;local l,T,L=R:FindFirstChild("RightUpperLeg"),R:FindFirstChild("RightLowerLeg"),R:FindFirstChild("RightFoot");local X= new2 ("Folder");X.Name="KorbloxMeshParts";X.Parent=R;local function R(Q,z,Y)local U= new2 ("Part");U.Size= vector3 (1,1,1);U.Transparency=0;U.CanCollide=false;U.Anchored=true;U.Parent=X;local X= new2 ("SpecialMesh");X.MeshType= fileMesh ;X.MeshId=z;if Y then X.TextureId=Y;end;X.Scale= vector3 (0.6,1.13,0.6);X.Offset= vector3 (0,0.25,0);X.Parent=U;local X=nil;X= service .RenderStepped:Connect(function()if Q and U and U.Parent then U.CFrame=Q.CFrame;else X:Disconnect();end;end);return U;end;if l then l.Transparency=1;R(l,"http://www.roblox.com/asset/?id=902942096","http://www.roblox.com/asset/?id=902843398");end;if T then T.Transparency=1;end;if L then L.Transparency=1;end;end,
								ApplyFakeCosmetics = function(...) end,
								Apply = function(...) end,
							}

							if localPlayer.Character then
								spawn_(function()
									tbl15:Apply(localPlayer.Character)
								end)
							end

							tbl24:Connect(localPlayer.CharacterAdded, function(arg)
								tbl15:Apply(arg)
							end)

							tbl16 = {
								ClientAnimFolder = nil,
								GetClientAnimFolder = function(R)if  tbl16 .ClientAnimFolder and  tbl16 .ClientAnimFolder.Parent then return  tbl16 .ClientAnimFolder;end;local R= Players .LocalPlayer;local l=R and(R:FindFirstChild("PlayerGui")or(R:FindFirstChild("PlayerScripts"))or  Workspace .CurrentCamera);l=if not l then R else l;R=l and(l:FindFirstChild("Prosper_ClientAnims"));if not R then R= new2 ("Folder");R.Name="Prosper_ClientAnims";R.Parent=l;end; tbl16 .ClientAnimFolder=R;return R;end,
								ToClientAnimation = function(R,R)if not R then return nil;end;local l= tbl16 :GetClientAnimFolder();if typeof(R)=="Instance"and(R:IsA("Animation"))then if R:IsDescendantOf(l)then return R;end;local T=R.AnimationId;if not T or T==""then return R;end;local L= new2 ("Animation");L.Name="Client_"..(R.Name or"Anim");L.AnimationId=T;L.Archivable=false;L.Parent=l;return L;elseif typeof(R)=="string"then local T= new2 ("Animation");T.Name="Client_Anim";T.AnimationId=R;T.Archivable=false;T.Parent=l;return T;end;return R;end,
								StripModelControllers = function(R,R)if not R then return;end;for l,l in  v87 (R:GetDescendants())do if l:IsA("AnimationController")or(l:IsA("Animator"))or(l:IsA("Humanoid"))then l:Destroy();end;end;for l,l in  v87 (R:GetChildren())do if l:IsA("AnimationController")or(l:IsA("Animator"))or(l:IsA("Humanoid"))then l:Destroy();end;end;end,
								States = {
									PulloutAnimations = {
										["Golden Age Tanto"] = {
											AnimationId = "rbxassetid://13473404819",
											SoundId = "rbxassetid://5917819099",
										},
										["GPO-Knife"] = { AnimationId = "rbxassetid://14014278925" },
										["GPO-Knife Prestige"] = { AnimationId = "rbxassetid://14014278925" },
										Heaven = { AnimationId = "rbxassetid://14500266726" },
										Portal = { AnimationId = "rbxassetid://16058633881" },
										["Emerald Butterfly"] = { AnimationId = "rbxassetid://14918231706" },
										["RGB Butterfly"] = { AnimationId = "rbxassetid://14918231706" },
										Boy = { AnimationId = "rbxassetid://18789158908" },
										Girl = { AnimationId = "rbxassetid://18789162944" },
										Dragon = { AnimationId = "rbxassetid://14217804400" },
										Void = { AnimationId = "rbxassetid://14774699952" },
										["Wild West"] = { AnimationId = "rbxassetid://16058148839" },
										["Iced Out"] = { AnimationId = "rbxassetid://18465353361" },
										Reptile = { AnimationId = "rbxassetid://18788955930" },
										Ribbon = { AnimationId = "rbxassetid://124102609796063" },
										[v85[110]] = { AnimationId = "rbxassetid://116077835913890" },
										Wither = { AnimationId = "rbxassetid://109289105982608" },
										Music = { AnimationId = "rbxassetid://96811171427126" },
										Wire = { AnimationId = "rbxassetid://97840089951430" },
										[v85[182]] = { AnimationId = "rbxassetid://16769747881" },
										[v85[70]] = { AnimationId = "rbxassetid://14500266726" },
										[v85[36]] = { AnimationId = "rbxassetid://16769825152" },
										["Galaxy Karambit"] = { AnimationId = "rbxassetid://15970366319" },
									},
									CustomAttackAnimations = {
										["GPO-Knife"] = {
											hold = "rbxassetid://121436137419242",
											charge = "rbxassetid://89973862506703",
											slash = "rbxassetid://117745473791741",
										},
										["GPO-Knife Prestige"] = {
											hold = "rbxassetid://121436137419242",
											charge = "rbxassetid://89973862506703",
											slash = "rbxassetid://117745473791741",
										},
									},
									UnanimatedSkins = { Emerald = true },
									KnifeOffsets = {},
									ToolAliases = {
										["[Revolver]"] = { "rev", "revolver", v85[83] },
										["[Double-Barrel SG]"] = { "db", "doublebarrel", "dbanim", "dbeyeanim" },
										["[SMG]"] = { "smg" },
										["[Shotgun]"] = { v85[130] },
										["[TacticalShotgun]"] = { v85[101], "tac", "tactical" },
										["[AK47]"] = { "ak", "ak47" },
										["[Rifle]"] = { "rifle", "sniper" },
										["[DrumGun]"] = { v85[124], v85[62] },
										["[Drum-Shotgun]"] = { "drum", "drumshotgun" },
										["[RPG]"] = { "rpg", "rpganim" },
										["[Flintlock]"] = { "flintlock" },
										["[Flamethrower]"] = { "ft", v85[14], "ftanim", "fteyeanim" },
										["[Deagle]"] = { "deagle" },
										["[Silencer]"] = { v85[1], v85[163] },
									},
								},
								ScanRigForAnimations = function(R,R)local l={};local T={equip={"equip","draw","pullout","knifeequip","knifedraw","draw15","knifestart","runicequip","specialequip","bananaequip"},slash={"slash","swing","attack","knifestart","bananapeel","knifeload"},slash1={"slash1","swing1","attack1"},slash2={"slash2","swing2","attack2"},slash3={"slash3","swing3","attack3"},charge={"charge","charknife","knifechar","knifeload"},hold={"hold","holdslash"}};for L,X in  v87 (R:GetDescendants())do if X:IsA("Animation")then L=X.Name:lower();for R,Q in  v86 (T)do if not l[R]then for T,T in  v87 (Q)do if L==T or(L:find(T))then l[R]=X;break;end;end;end;end;end;end;return l;end,
								AutoDetectAnimations = function(R,R)local l={};if not R then return l;end;local T= ReplicatedStorage :FindFirstChild("SkinAssets");if T then local L=T:FindFirstChild("SkinScriptsStorage");if L then local X=L:FindFirstChild(R);if X then for L,Q in  v87 (X:GetDescendants())do if Q:IsA("Animation")then L=Q.Name:lower();if L:find("equip")or(L:find("draw"))or(L:find("pullout"))then l.equip=Q;elseif L:find("slash")or(L:find("swing"))or(L:find("attack"))then l.slash=Q;elseif L:find("charge")then l.charge=Q;elseif L:find("hold")then l.hold=Q;end;end;end;end;end;end;T= ReplicatedStorage :FindFirstChild("SkinModules");if T and R then local L=T:FindFirstChild("Knives");if L then local T=L:FindFirstChild(R);if T then for R,L in  v86 (( tbl16 :ScanRigForAnimations(T)))do if not l[R]then l[R]=L;end;end;end;end;end;return l;end,
								AppliedSkins = {},
								SKIN_TAG = v85[119],
								ContainerConns = {},
								CleanupSkin = function(R,R)local l= tbl16 .AppliedSkins[R];if l then if l.Clone and l.Clone.Parent then l.Clone:Destroy();end;for T,T in  v87 (l.ExtraParts or{})do if T and T.Parent then T:Destroy();end;end;for T,L in  v86 (l.Hidden or{})do if T and T.Parent then T.LocalTransparencyModifier=L;end;end;if l.Conn then l.Conn:Disconnect();end; tbl16 .AppliedSkins[R]=nil;end;for l,l in  v87 (R:GetChildren())do if l:GetAttribute( tbl16 .SKIN_TAG)then l:Destroy();end;end;end,
								StripJoints = function(R,R)if not R then return;end;for l,l in  v87 (R:GetDescendants())do if l:IsA("WeldConstraint")or(l:IsA("Weld"))or(l:IsA("Motor6D"))or(l:IsA("JointInstance"))then l:Destroy();end;end;end,
							}

							tbl16.ThrownSkins = fn29({}, { __mode = "k" })
							tbl16.HasGeometry = function(n,n)return n:IsA("MeshPart")or(n:IsA("UnionOperation"))or n:FindFirstChildOfClass("SpecialMesh")~=nil or n:FindFirstChildOfClass("SurfaceAppearance")~=nil or n:FindFirstChildOfClass("Decal")~=nil;end
							tbl16.SyncThrownSkin = function(R,R)local l=R and  tbl16 .ThrownSkins[R];if not l or not l.Model or not l.Model.Parent then return;end;local n,T=R.CFrame,l.Parts;for L=1,#T,1 do local X=T[L];L=X.Part;if L and L.Parent then L.CFrame=n*X.Offset;end;end;if l.Hide then R.Transparency=1;R.LocalTransparencyModifier=1;end;end
							tbl16.HideThrownSkin = function(R,R)local l=R and  tbl16 .ThrownSkins[R];R=l and l.Model;if not R or not R.Parent then return;end;for l,l in  v87 (R:GetDescendants())do if l:IsA("BasePart")then l.Transparency=1;l.LocalTransparencyModifier=1;elseif l:IsA("Trail")or(l:IsA("Beam"))or(l:IsA("ParticleEmitter"))then l.Enabled=false;end;end;end
							tbl16.ClearThrownSkin = function(R,R)local l=R and  tbl16 .ThrownSkins[R];local T=l and l.Model;if T and T.Parent then T:Destroy();end;if R then  tbl16 .ThrownSkins[R]=nil;end;end
							tbl16.ThrowWatch = nil
							tbl16.ThrowRange = 30
							tbl16.ThrowSpawnRadius = 8
							tbl16.BladeFrame = function(R,R,l)local T,L=R:GetBoundingBox();local X,Q;if L.X>=L.Y and L.X>=L.Z then X,Q=T.RightVector,L.X;elseif L.Y>=L.Z then X,Q=T.UpVector,L.Y;else X,Q=T.LookVector,L.Z;end;R=(l.Position-T.Position):Dot(X);if Q>0.2 and  abs (R)>Q*0.12 then local T=R>0 and-X or X;return  cframe (l.Position,l.Position+T);end;return l.CFrame;end
							tbl16.DriveThrownSkin = function(R,R)local l=nil;l= service .Heartbeat:Connect(function()if not R.Parent or not  tbl16 .ThrownSkins[R]then  tbl16 :ClearThrownSkin(R);l:Disconnect();return;end; tbl16 :SyncThrownSkin(R);end);end

							tbl16.WatchThrownKnives = function()
								error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:22)")
							end

							tbl16.DressThrownKnife = function(...) end
							tbl24.DressThrownKnife = function(R,l)return  tbl16 :DressThrownKnife(R,l);end
							tbl24.SyncThrownSkin = function(R)return  tbl16 :SyncThrownSkin(R);end
							tbl24.HideThrownSkin = function(R)return  tbl16 :HideThrownSkin(R);end
							tbl24.ClearThrownSkin = function(R)return  tbl16 :ClearThrownSkin(R);end
							tbl16.PickPrimaryPart = function(R,R)if not R then return nil;end;local l=R:FindFirstChild("Handle",true);if l and(l:IsA("BasePart"))then return l;end;local T=-1;local L=nil;for X,Q in  v87 (R:GetDescendants())do if Q:IsA("BasePart")then l=Q.Size;X=l.X*l.Y*l.Z;X=if Q.Transparency<1 then X+1000000 else X;if X>T then T,L=X,Q;end;end;end;return L;end
							tbl16.WeldCloneToPrimary = function(R,R)local l=R.PrimaryPart;if not l then return;end;for T,L in  v87 (R:GetDescendants())do if L:IsA("BasePart")and L~=l then local X,Q={R},false;for R,R in  v87 (X)do for X,X in  v87 (R:GetDescendants())do if(X:IsA("Weld")or(X:IsA("WeldConstraint"))or(X:IsA("Motor6D")))and(X.Part0==L or X.Part1==L)then Q=true;break;end;end;if Q then break;end;end;if not Q then T= new2 ("WeldConstraint");T.Part0=l;T.Part1=L;T.Parent=l;end;end;end;end

							tbl16.HCAliases = {
								["[Double-Barrel SG]"] = "DoubleBarrel",
								["[Revolver]"] = "Revolver",
								["[TacticalShotgun]"] = "TacticalShotgun",
								["[Silencer]"] = "SMG",
								["[Shotgun]"] = "Shotgun",
								["[Knife]"] = "Knife",
							}

							tbl16.ApplyHCGun = function(R,R,l)if not R or not l then return;end; tbl16 :CleanupSkin(R);local T=R:FindFirstChild("Handle");T=if not T then(R:WaitForChild("Handle",5))else T;if not T then return;end; wait_ (0.2);local L=l:Clone();L.Name="SkinClone";if not L.PrimaryPart then L.PrimaryPart= tbl16 :PickPrimaryPart(L);end;if not L.PrimaryPart then L:Destroy();return;end;for X,X in  v87 (L:GetDescendants())do if X:IsA("BasePart")then X.Anchored=false;X.CanCollide=false;X.CanQuery=false;X.CanTouch=false;X.CastShadow=false;X.LocalTransparencyModifier=0;end;end; tbl16 :WeldCloneToPrimary(L);L:PivotTo(T.CFrame);L.Parent=R;l= new2 ("WeldConstraint");l.Part0=T;l.Part1=L.PrimaryPart;l.Parent=L.PrimaryPart;l={};for X,X in  v87 (R:GetDescendants())do if X:IsA("BasePart")and not X:IsDescendantOf(L)then l[X]=X.LocalTransparencyModifier;X.LocalTransparencyModifier=1;end;end;T=R.AncestryChanged:Connect(function(X,X)if not X then  tbl16 :CleanupSkin(R);end;end); tbl16 .AppliedSkins[R]={Clone=L,Hidden=l,Conn=T};end
							tbl16.ApplyHCKnife = function(R,R,l) tbl16 :CleanupSkin(R);local T= ReplicatedStorage :FindFirstChild("Knives");if not T then return;end;local L=T:FindFirstChild(l);if not L then return;end;local X,Q=tostring(l):lower():find("beta")~=nil,R:FindFirstChild("Handle");Q=if not Q then(R:WaitForChild("Handle",5))else Q;if not Q then return;end; wait_ (0.2);if not R.Parent or not Q.Parent then return;end;T=L:FindFirstChild("Handle")or(L:FindFirstChildOfClass("BasePart"));if not T then return;end;local z=T:Clone();z.Name="KnifeSkinPart";z.Anchored=false;z.CanCollide=false;z.CanQuery=false;z.CanTouch=false;z.CastShadow=false;z.Massless=true;z.LocalTransparencyModifier=0;if X then z.Transparency=(z:IsA("MeshPart")or(z:IsA("UnionOperation"))or z:FindFirstChildOfClass("SpecialMesh")~=nil or z:FindFirstChildOfClass("SurfaceAppearance")~=nil or z:FindFirstChildOfClass("Decal")~=nil)and 0 or 1;else z.Transparency=1;end;z.Parent=R;z.CFrame=Q.CFrame;local Y= new2 ("WeldConstraint");Y.Part0=Q;Y.Part1=z;Y.Parent=z;local U={};local _={[z]=true};for E,Z in  v87 (L:GetDescendants())do if Z:IsA("BasePart")and Z~=T then Y=Z:Clone();Y.Anchored=false;Y.CanCollide=false;Y.CanQuery=false;Y.CanTouch=false;Y.CastShadow=false;Y.Massless=true;Y.LocalTransparencyModifier=0;Y.Transparency=(Y:IsA("MeshPart")or(Y:IsA("UnionOperation"))or Y:FindFirstChildOfClass("SpecialMesh")~=nil or Y:FindFirstChildOfClass("SurfaceAppearance")~=nil or Y:FindFirstChildOfClass("Decal")~=nil)and 0 or 1;Y.Parent=R;Y.CFrame=Q.CFrame*T.CFrame:ToObjectSpace(Z.CFrame);E= new2 ("WeldConstraint");E.Part0=z;E.Part1=Y;E.Parent=z;U[#U+1]=Y;_[Y]=true;end;end;T={};if not X then for X,X in  v87 (R:GetDescendants())do if X:IsA("BasePart")and not _[X]and not X:IsDescendantOf(z)then T[X]=X.LocalTransparencyModifier;X.LocalTransparencyModifier=1;end;end;end;L=R.AncestryChanged:Connect(function(X,X)if not X then  tbl16 :CleanupSkin(R);end;end); tbl16 .AppliedSkins[R]={Conn=L,Clone=z,ExtraParts=U,Hidden=T,SkinName=l};end
							tbl16.GetSkinModel = function(R,R,l)local T= ReplicatedStorage :FindFirstChild("Wraps");if not T then return nil;end;local n=T:FindFirstChild("["..R.."]");if not n then return nil;end;return n:FindFirstChild(l);end

							tbl16.HCToolAliases = {
								["[DoubleBarrel]"] = "[Double-Barrel SG]",
								["[Revolver]"] = "[Revolver]",
								["[TacticalShotgun]"] = "[TacticalShotgun]",
								["[SMG]"] = "[Silencer]",
								["[Shotgun]"] = "[Shotgun]",
								["[Knife]"] = "[Knife]",
							}

							tbl16.TrySkinTool = function(...) end

							tbl16.SetupHCBulletBeams = function()
								error("devirt: symbolic next pc/mode: (r14 Add 1) / 195 (at 195:2)")
							end

							tbl16.WatchContainer = function()
								error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:1)")
							end

							tbl16.ApplyToContainer = function()
								error("devirt: symbolic next pc/mode: (r4 Add 1) / 195 (at 195:102)")
							end

							tbl16.ApplySkinChanger = function()
								error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:111)")
							end

							local function fn33()
								error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:245)")
							end
						end

						local tbl35

						do
							do
								spawn_(function(...) end)
								tbl16.GetDHSkinInfo = function(n,n,R)if type(n)~="string"or type(R)~="string"then return nil;end;local l=getgenv().SkinModules;if type(l)~="table"then return nil;end;local T=l[n];n=type(T)=="table"and T[R];if type(n)~="table"then return nil;end;return n;end
								spawn_(function(...) end)
								tbl16.ResolveSkinPart = function(R,R)if type(R)~="table"then return R;end;local l=rawget(R,0);if type(l)~="table"then return nil;end;R=( ReplicatedStorage :FindFirstChild("SkinModules"));for n,n in ipairs(l)do if not R then return nil;end;R=(R:FindFirstChild(n));end;return R;end
								tbl16.DHGunVisuals = fn29({}, { __mode = "k" })
								tbl16.EquipTokens = fn29({}, { __mode = "k" })
								tbl16.ReseatKnife = fn29({}, { __mode = "k" })
								tbl16.Reseating = fn29({}, { __mode = "k" })
								tbl16.DHGunSkinIntact = function(R,R)local l= tbl16 .DHGunVisuals[R];if not l then return false;end;local n=l.Orig;if not n:IsDescendantOf(R)then return false;end;if l.Clone then if l.Clone.Parent~=R or n.Transparency~=1 then return false;end;return not l.Weld or l.Weld.Parent~=nil and l.Weld.Part1==n;end;return n.TextureID==l.TextureID;end
								tbl16.ClearDHMesh = function(R,R,l)if not R or not l then return;end;local T=R:FindFirstChild("Handle");local L=T and(T:GetAttribute("SkinName"));local X,Q=L and L~="",{Aim=true,Muzzle=true,LeftMuzzle=true,RightMuzzle=true,Handle=true};local function L(z)for Y,Y in  v87 (z:GetDescendants())do if Y:IsA("ParticleEmitter")then Y.Enabled=false;Y:Destroy();end;end;end;local function z(Y)for U,U in  v87 (Y:GetChildren())do if U~=T then if U.Name=="CurrentSkin"then L(U);U:Destroy();elseif U:IsA("ParticleEmitter")and not U:GetAttribute("DefaultParticle")and X then U:Destroy();elseif U:IsA("MeshPart")and U~=l and not U:IsDescendantOf(l)then if not Q[U.Name]then U:Destroy();end;elseif U:IsA("Folder")or(U:IsA("Model"))then z(U);end;end;end;end;z(R);end

								tbl16.BuiltKnifeSkins = {
									Galactic = { Blade = Color3.fromRGB(v85[188], 170, v85[142]) },
									["Galactic-Red"] = { Blade = Color3.fromRGB(v85[142], 134, 122) },
								}

								tbl16.BuiltTemplates = {}

								tbl16.GalacticParts = {
									Grip = {
										MeshId = "rbxassetid://13631448149",
										TextureId = "rbxassetid://13631435304",
										Size = vector3(0.41470247, 1.67690396, 0.41470256),
										Offset = 0.0946066,
									},
									Blade = {
										MeshId = "rbxassetid://13631448150",
										Size = vector3(0.22626357, 3.33464503, 0.22626412),
										Offset = 2.31074929,
									},
								}

								tbl16.LiveKnifeSkin = function()
									if not nil then
										error("devirt: symbolic next pc/mode: 406 / r5 (at 195:20)")
									end

									error("devirt: symbolic next pc/mode: (r5 Add 1) / 195 (at 195:7)")
								end

								tbl16.BuildKnifeSkin = function()
									error("devirt: symbolic next pc/mode: (r7 Add 1) / 195 (at 195:22)")
								end

								tbl16.EnsureGalacticBlade = function()
									error("devirt: symbolic next pc/mode: (r3 Add 1) / 195 (at 195:18)")
								end

								tbl16.GalacticSound = "rbxassetid://13633366483"
								tbl16.GalacticIgniteTime = 0.25

								tbl16.IgniteGalacticBlade = function()
									error("devirt: symbolic next pc/mode: (r8 Add 1) / 195 (at 195:1)")
								end

								tbl16.AttachGalacticBlade = function()
									error("devirt: symbolic next pc/mode: (r13 Add 1) / 195 (at 195:2266)")
								end

								tbl16.SkinMeshFolder = function()
									error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:1)")
								end

								tbl16.FindSkinMesh = function()
									error("devirt: symbolic next pc/mode: (r11 Add 1) / 195 (at 195:351)")
								end

								tbl16.ApplyDHGun = function(...) end
								tbl16.CleanDHKnife = function(R,R)local l= tbl25 .KnifeData[R];if l then if l.AnimTracks then for T,T in  v86 (l.AnimTracks)do  v88 (function()T:Stop(0);T:Destroy();end);end;end;if l.connections then for T,T in  v87 (l.connections)do if typeof(T)=="RBXScriptConnection"then T:Disconnect();end;end;end;if l.welds then for T,T in  v87 (l.welds)do if typeof(T)=="RBXScriptConnection"then T:Disconnect();elseif typeof(T)=="Instance"and T.Parent then T:Destroy();end;end;end;if l.sounds then for T,T in  v87 (l.sounds)do if T and T.Parent then T:Destroy();end;end;end; tbl25 .KnifeData[R]=nil;end;for T,T in  v87 (R:GetDescendants())do if T:IsA("BasePart")and T.Name~="Default"and T.Name~="Handle"then T:Destroy();end;if T:IsA("Model")then T:Destroy();end;end;l=R:FindFirstChild("Default")or(R:FindFirstChild("Handle"));if l then for T,T in  v87 (l:GetDescendants())do if T.Name~="THROW_STATE"and T.Name~="Default"and T.Name~="Handle"then T:Destroy();end;end;l.Transparency=0;l.LocalTransparencyModifier=0;end;l=R:FindFirstChild("SkinChangerController");if l then l:Destroy();end;end
								tbl16.ApplyDHKnife = function(...) end
								tbl16.SetDHCurrentSkinAttributes = function(...) end
								tbl16.ApplyDHCurrentSkin = function(...) end
								tbl16.SetupDHTool = function(...) end

								tbl16.WatchDHCharacter = function()
									error("devirt: symbolic next pc/mode: (r4 Add 1) / 195 (at 195:294)")
								end

								spawn_(function(...) end)

								do
									local function fn33()
										error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:19)")
									end

									spawn_(function(...) end)
									fn33()
								end
							end

							tbl17 = {
								Notify = function(R,R,l)if type(R)~="string"then return;end;l=type(l)=="string"and l~=""and l or"Prosper"; v88 (function() StarterGui :SetCore("SendNotification",{Title=l,Text=R,Duration=5,Icon="rbxassetid://0"});end);end,
								ModChecks = {},
								CheckModerator = function()
									error("devirt: symbolic next pc/mode: (r2 Add 1) / 195 (at 195:1667)")
								end,
								ScanModerators = function()
									error("devirt: symbolic next pc/mode: (r3 Add 1) / 195 (at 195:421)")
								end,
								SetupModDetector = function()
									error("devirt: symbolic next pc/mode: 73 / r1 (at 195:58)")
								end,
								SetupReportDetector = function()
									error("devirt: symbolic next pc/mode: (r1 Add 1) / 195 (at 195:21)")
								end,
							}

							tbl35 = {
								BindMatches = function()
									error("devirt: symbolic next pc/mode: (r3 Add 1) / 195 (at 195:927)")
								end,
								SetupTool = function(...) end,
							}
							;(function(...) end)()

							tbl35.OnBegan = function()
								error("devirt: symbolic next pc/mode: (r9 Add 1) / 195 (at 195:11072)")
							end

							tbl35.OnEnded = function()
								error("devirt: symbolic next pc/mode: 3079 / r3 (at 195:16)")
							end

							tbl24:Connect(service2.InputBegan, function(arg, arg2)
								tbl35:OnBegan(arg, arg2)
							end)

							tbl24:Connect(service2.InputEnded, function(arg, arg2)
								tbl35:OnEnded(arg, arg2)
							end)

							do
								local function fn33(R) tbl24 .FrameTime=R;if type(R)=="number"and R==R and R>0 and R< huge then local l,T= tbl28 .FrameTimeEMA,1-math.exp(-R/0.15); tbl28 .FrameTimeEMA=l and l+(R-l)*T or R;end;for l,l in ipairs( tbl24 .Routines.RenderStepped)do  v88 (l,R);end;end
								local function fn34(R)for l,l in ipairs( tbl24 .Routines.Heartbeat)do  v88 (l,R);end;end
								tbl24:Connect(service.RenderStepped, fn33)
								tbl24:Connect(service.Heartbeat, fn34)
							end
						end

						do
							do
								local tbl36 = { OnCharacter = function(...) end }
								tbl24:Connect(localPlayer.CharacterAdded, function(R) tbl36 :OnCharacter(R);end)
								tbl24:Connect(localPlayer.CharacterAdded, function() tbl24 .State.CamlockActive=false; tbl24 .State.CamlockHold=false; tbl24 .State.TriggerBotActive=false; tbl24 .State.TriggerActive=false;end)

								if localPlayer.Character then
									task.spawn(function() tbl36 :OnCharacter( localPlayer .Character);end)
								end
							end
						end

						do
							tbl14.Information = {}
							tbl14.Information.Labels = {}
							tbl14.Information.Margin = 12
							tbl14.Information.Spacing = 2

							tbl14.Information.Anchors = {
								Default = { X = 0.5, Y = 1, MarginX = 0, MarginY = 105 },
								["Top Middle"] = { X = 0.5, Y = 0 },
								["Middle Left"] = { X = v85[64], Y = v85[86] },
								[v85[127]] = { X = 1, Y = 0.5 },
							}

							tbl14.Information.Order = {
								{ Key = "Silent Aimbot", Label = "silent aimbot" },
								{ Key = "Camera Aimbot", Label = "camera aimbot" },
								{ Key = "Trigger Bot", Label = "trigger bot" },
								{ Key = "Target", Label = "target" },
								{ Key = "Knocked", Label = "knocked" },
								{ Key = v85[87], Label = "range" },
								{ Key = "Watermark", Label = "" },
							}

							tbl14.Information.Shown = {}

							tbl14.Information.Themes = {
								Default = {
									[v85[81]] = Color3.fromRGB(0, v85[7], 0),
									Armor = Color3.fromRGB(0, v85[136], 255),
									Label = Color3.fromRGB(v85[7], 255, 255),
									True = Color3.fromRGB(0, 255, v85[64]),
									[v85[178]] = Color3.fromRGB(255, v85[64], 0),
									Target = Color3.fromRGB(160, 160, 160),
									Watermark = Color3.fromRGB(255, 255, v85[7]),
									[v85[75]] = Color3.fromRGB(150, v85[23], 150),
									Outline = Color3.fromRGB(0, v85[64], v85[64]),
								},
								Aurora = {
									Health = Color3.fromRGB(122, 255, 214),
									Armor = Color3.fromRGB(v85[52], 132, v85[7]),
									Label = Color3.fromRGB(v85[103], v85[107], v85[7]),
									True = Color3.fromRGB(122, 255, 214),
									False = Color3.fromRGB(v85[7], 108, 158),
									Target = Color3.fromRGB(v85[161], 160, v85[161]),
									Watermark = Color3.fromRGB(226, 230, 255),
									["Watermark Accent"] = Color3.fromRGB(138, 146, 178),
									Outline = Color3.fromRGB(10, 8, 24),
								},
								Sunset = {
									[v85[81]] = Color3.fromRGB(v85[7], 176, 64),
									Armor = Color3.fromRGB(255, 122, 92),
									Label = Color3.fromRGB(255, 232, 214),
									True = Color3.fromRGB(v85[7], 176, 64),
									[v85[178]] = Color3.fromRGB(214, 62, 88),
									[v85[41]] = Color3.fromRGB(160, v85[161], 160),
									Watermark = Color3.fromRGB(v85[7], v85[107], 176),
									["Watermark Accent"] = Color3.fromRGB(166, 142, v85[28]),
									Outline = Color3.fromRGB(26, 10, 12),
								},
								Ocean = {
									Health = Color3.fromRGB(72, 219, 214),
									Armor = Color3.fromRGB(64, 168, 255),
									Label = Color3.fromRGB(214, 240, 255),
									True = Color3.fromRGB(72, 219, 214),
									False = Color3.fromRGB(255, 92, 122),
									Target = Color3.fromRGB(160, v85[161], v85[161]),
									Watermark = Color3.fromRGB(190, 226, v85[7]),
									["Watermark Accent"] = Color3.fromRGB(130, 152, 174),
									Outline = Color3.fromRGB(6, v85[147], 30),
								},
								Mono = {
									[v85[81]] = Color3.fromRGB(255, 255, 255),
									Armor = Color3.fromRGB(190, 190, 190),
									Label = Color3.fromRGB(235, 235, 235),
									True = Color3.fromRGB(255, 255, 255),
									[v85[178]] = Color3.fromRGB(120, 120, 120),
									Target = Color3.fromRGB(160, 160, 160),
									Watermark = Color3.fromRGB(255, 255, v85[7]),
									["Watermark Accent"] = Color3.fromRGB(150, 150, 150),
									Outline = Color3.fromRGB(v85[64], 0, 0),
								},
							}

							tbl14.Information.Palette = function(...) end
							tbl14.Information.Hex = function(R,R)if typeof(R)~="Color3"then return"FFFFFF";end;return string.format("%02X%02X%02X", floor2 (R.R*255+0.5), floor2 (R.G*255+0.5), floor2 (R.B*255+0.5));end
							tbl14.Information.Escape = function(n,n)return(tostring(n):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"));end
							tbl14.Information.Tag = function(R,R,l)return"<font color=\"#".. tbl14 .Information:Hex(l).."\">"..R.."</font>";end
							tbl14.Information.Engaged = function(R,R,l)local T= tbl24 .State;if R=="Camera Aimbot"then return l=="Always"or l=="Hold"and T.CamlockHold==true or l=="Toggle"and T.CamlockActive==true;end;return l=="Always"or l=="Hold"and T.TriggerActive==true or l=="Toggle"and T.TriggerBotActive==true;end
							tbl14.Information.Armed = function(...) end
							tbl14.Information.Active = function(...) end
							tbl14.Information.Target = function(R)local R= tbl24 .State.Targets;if  tbl14 .Information:Active("Camera Aimbot")then return R.CameraAimbot;end;if  tbl14 .Information:Active("Trigger Bot")then return R.TriggerBot;end;return R.SilentAim or R.CameraAimbot or R.TriggerBot;end
							tbl14.Information.TargetParts = function(R,R)if not R then return nil,nil,nil;end;local l= v90 .CharacterCache[R];local n=l and l.Character or R.Character;if not n then return nil,nil,nil;end;return n,l and l.HumanoidRootPart or(n:FindFirstChild("HumanoidRootPart")),l and l.Humanoid or(n:FindFirstChildOfClass("Humanoid"));end
							tbl14.Information.Armor = function(n,n,R)local l=R and(R:FindFirstChild("BodyEffects"));R=l and(l:FindFirstChild("Armor"));if not R then l=n and(n:FindFirstChild("DataFolder"));local n=l and(l:FindFirstChild("Information"));R=n and(n:FindFirstChild("ArmorSave"));end;return R and(tonumber(R.Value))or 0;end
							tbl14.Information.IgnoringKnocked = function(...) end
							tbl14.Information.Raging = function(...) end
							tbl14.Information.RangeStatus = function(...) end
							tbl14.Information.Visible = function(R,R)if R=="Knocked"then return  tbl14 .Information:IgnoringKnocked()and  tbl14 .Information:Target()~=nil;elseif R=="Range"then return  tbl14 .Information:Raging()and  tbl14 .Information:Target()~=nil;end;return true;end
							tbl14.Information.Line = function(R,R,l,T)local L=T.Label;local X=R.Key;if X=="Watermark"then local Q=l.Watermark;Q=if type(Q)~="string"or Q==""then"/prosperlol"else Q;local z=T.Watermark or L;local Y,U=T["Watermark Accent"]or z,Q:find("/",2,true)or 0;if U<2 then local _=Q:sub(1,1);if _=="/"then return  tbl14 .Information:Tag( tbl14 .Information:Escape(_),Y).. tbl14 .Information:Tag( tbl14 .Information:Escape(Q:sub(2)),z);end;return  tbl14 .Information:Tag( tbl14 .Information:Escape(Q),z);end;return  tbl14 .Information:Tag( tbl14 .Information:Escape(Q:sub(1,U-1)),Y).. tbl14 .Information:Tag( tbl14 .Information:Escape(Q:sub(U)),z);end;l= tbl14 .Information:Escape(R.Label);if X=="Target"then R= tbl14 .Information:Target();local Q=R and(R.DisplayName or R.Name);if type(Q)~="string"or Q==""then return  tbl14 .Information:Tag(l.." = ",L).. tbl14 .Information:Tag("none",T.Target or L);end;local z,Y,Y= tbl14 .Information:TargetParts(R);local U= tbl14 .Information:Tag(l.." = ",L).. tbl14 .Information:Tag( tbl14 .Information:Escape(Q),T.Target or L);if not z then return U;end;local Q,_=Y and( floor2 (Y.Health+0.5))or 0, floor2 ( tbl14 .Information:Armor(R,z)+0.5);return U.. tbl14 .Information:Tag(" ",L).. tbl14 .Information:Tag(tostring(Q),T.Health or L).. tbl14 .Information:Tag("/",L).. tbl14 .Information:Tag(tostring(_),T.Armor or L);end;if X=="Knocked"then local Q= fn31 ( tbl14 .Information:Target());local z=Q and(T.False or L)or(T.True or L);return  tbl14 .Information:Tag(l.." = ",L).. tbl14 .Information:Tag(Q and"true"or"false",z);end;if X=="Range"then local Q,z= tbl14 .Information:RangeStatus( tbl14 .Information:Target());local Y=z and(T.True or L)or(T.False or L);if not Q then return  tbl14 .Information:Tag(l.." = ",L).. tbl14 .Information:Tag("none",Y);end;return  tbl14 .Information:Tag(l.." = ",L).. tbl14 .Information:Tag(tostring( floor2 (Q+0.5)).." studs ",L).. tbl14 .Information:Tag(z and"(valid)"or"(invalid)",Y);end;R= tbl14 .Information:Active(X);X=R and(T.True or L)or(T.False or L);return  tbl14 .Information:Tag(l.." = ",L).. tbl14 .Information:Tag(R and"true"or"false",X);end
							tbl14.Information.Ensure = function(R,R)local l= tbl14 :GetESPGui();for T=# tbl14 .Information.Labels+1,R,1 do local R= new2 ("TextLabel");R.BackgroundTransparency=1;R.BorderSizePixel=0;R.Size=UDim2.new(0,420,0,16);R.RichText=true;R.TextYAlignment=Enum.TextYAlignment.Top;R.TextStrokeTransparency=0;R.TextColor3=Color3.fromRGB(255,255,255);R.ZIndex=4;R.Visible=false;R.Parent=l; tbl14 .Information.Labels[T]=R;end;end
							tbl14.Information.Hide = function(R,R)for l=R,# tbl14 .Information.Labels,1 do local R= tbl14 .Information.Labels[l];if R and R.Visible then R.Visible=false;end;end;end
							tbl14.Information.Update = function(...) end
							tbl24:AddRoutine("RenderStepped", function(R) tbl24 .FrameStamp=( tbl24 .FrameStamp or 0)+1; tbl30 :Targeting(); tbl34 :Update(R); tbl14 :Update(R); tbl14 .Information:Update(); tbl28 :UpdateFOVVisuals(); tbl31 :Tick();end)
							tbl24:Connect(service.PreRender, function(R) v88 ( tbl12 .Update, tbl12 ); v88 ( tbl32 .Update, tbl32 ,R);end)
							tbl24:AddRoutine("Heartbeat", function(R) tbl34 :UpdateDerHood(); fn32 (); v88 (function()return  tbl33 :RageTick();end);end)
							tbl24:AddRoutine("Heartbeat", function(...) end)
							tbl24:AddRoutine("Heartbeat", function() tbl28 :SampleAutoCandidates(); tbl28 :TickStrafeSample(); tbl11 :SamplePing(tick());end)

							do
								local backpack = localPlayer:FindFirstChildOfClass("Backpack") or localPlayer:WaitForChild("Backpack", 5)

								if backpack then
									for _, child in ipairs(backpack:GetChildren()) do
										tbl35:SetupTool(child)
									end

									tbl24:Connect(backpack.ChildAdded, function(arg)
										tbl35:SetupTool(arg)
									end)
								end
							end
						end

						if localPlayer.Character then
							for _, child in ipairs(localPlayer.Character:GetChildren()) do
								tbl35:SetupTool(child)
							end
						end

						tbl24:Connect(localPlayer.CharacterAdded, function(R)for l,l in ipairs(R:GetChildren())do  tbl35 :SetupTool(l);end; tbl24 :Connect(R.ChildAdded,function(R) tbl35 :SetupTool(R);end);end)
						tbl17:SetupModDetector()
						tbl17:SetupReportDetector()

						do
							local v91 = v85[30]
							getgenv().Loaded = v91
						end

						getgenv().LiveCfg = getgenv().Prosper
						return
					end

					while true do
					end
				end
			end
		end
	end
end

fn14(100, v4[fn2("n\218\192\176\129w\151\190\193\1756", 21845944094585)], v4[fn2("-\209 \r\161\128\30\181)\162\169\194\240\156\19Ȣs\0212\188p\207(\188\240\176\157\230\2\142\167\11\226\159&\233", 10693721171687)] .. v33(v64), Color3[v4[fn2("\211\207k", 18772801209419)]](1, 0, 0), v4[fn2(" `\4\162\157", 18561267614598)])
