---@source Ѕоurcе Соԁe Deоbfuѕcаteԁ Ву LeаκD
-- By Bypass Exhub

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime1(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime2(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime3(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime4(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime5(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime6(...)
	error("Luraph runtime function, not devirtualized")
end

local tbl
tbl = {}
local v = nil
local v2
v2 = nil
local v3 = nil
local v4 = nil
local v5 = nil
local v6 = nil
local v7 = nil
local v8 = nil
local v9 = nil
local v10
v10 = nil
local v11 = nil
local v12 = nil
local v13 = v10
local fn
fn = nil
local fn2
fn2 = nil
local fn3
fn3 = nil
local v14
v14 = task
local cancel
cancel = v14.cancel
local n
n = nil + nil
local spawn
spawn = v14.spawn
local defer
defer = v14.defer
local delay
delay = v14.delay
local wait
wait = v14.wait
local v15, v16, v17, v18, fn4, fn5, info, n2, fn6, fn7
local tbl2, fn8, fn9, fn10, fn11, new, new2, new3, color, v19
local traceback

do
	local v20 = Instance
	v15 = Vector3
	local v21 = Vector2
	v16 = CFrame
	v17 = Random
	v18 = loadstring
	local tbl3 = { 147, 84, 161, 39, 193, 8, 231, 47, 168, 122, 181, 68 }
	local n3 = 12
	local tbl4 = { 139, 113, 36, 32, 67, 241, 203, 104, 192, 68, 55, 179 }
	local n4 = 12
	local n5 = 10925
	local tbl5 = {}
	local n6 = 0

	fn4 = function(arg, arg2)
		n6 += 1
		tbl5[n6] = arg2 % 256
	end

	fn5 = function(arg, arg2)
		local tbl6 = { nil, arg2 + 0, 1, nil, 0 }

		while true do
			local v22 = tbl6[3]
			local v23 = tbl6[2]
			local n7 = tbl6[5] + v22
			local flag = v22 <= 0
			local flag2 = not flag
			local flag3 = n7 >= v23
			local flag4 = n7 <= v23

			if flag then
				if flag2 then
					flag3 = flag3 or flag4
				else
					flag4 = flag2
					flag3 = flag3 or flag4
				end
			else
				flag3 = flag

				if flag2 then
					flag3 = flag3 or flag4
				else
					flag3 = flag3 or flag2
				end
			end

			tbl6[5] = n7

			if flag3 then
				local n8 = arg % 256
				arg = (arg - n8) / 256
				n6 += 1
				tbl5[n6] = n8
				continue
			end

			break
		end
	end

	local function fn12()
		error("devirt: arith on 187844740 b'o' (at 46:187)")
	end

	local function fn13()
		local v22, v23 = fn12(nil - "Enums")
		;("EnumItem")(nil, table.pack(r137, r144, fn8, fn5, n2, fn6, tbl2, r219), nil)()
		error("devirt: arith on -1 b'Parent' (at 46:532)")
	end

	local v22 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
	info = v22.info
	n2 = 298134066

	fn6 = function()
		local function fn14(arg, arg2, arg3, arg4, arg5)
			error("devirt: arith on b'X' b'Frame' (at 46:407)")
		end

		fn14(nil, nil, nil, nil, nil, 509554132)
		local n7 = 177975757

		while true do
			n7 += nil
		end
	end

	fn7 = function()
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	tbl2 = { [false] = true, [true] = false }
	local tbl6 = {}

	fn8 = function(arg, arg2)
		if not nil then
			if nil then
				if nil then
					return false
				end

				if nil then
					return true
				end
				return false
			end
		end

		tbl6[arg] = true
		local v23 = tbl6[arg2]
		tbl6[arg] = nil
		return v23
	end

	fn9 = function(arg, arg2)
		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		local kind = type(arg)
		fn8(nil, kind)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		local v23 = getmetatable(arg)
		fn8(nil, v23)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		pcall(setmetatable, nil, nil)
	end

	fn10 = function(arg, arg2, ...)
		local state = 1
		local v23, v24, n7, byte, n8, tbl7, n9, flag, flag2, flag3, flag4

		while true do
			if state == 1 then
				v23 = arg
				v24 = arg2
				n7 = 1
				state = 2
			elseif state == 2 then
				if n7 <= 0 then
					state = 7
				else
					state = 3
				end
			elseif state == 3 then
				byte = string.byte
				n7 = v23 ~= 377093054

				if n7 then
					state = 4
				else
					state = 5
				end
			elseif state == 4 then
				n7 = 3
				state = 5
			elseif state == 5 then
				n8 = 2166136261

				if n7 then
					state = 14
				else
					state = 6
				end
			elseif state == 6 then
				n7 = 6
				state = 8
			elseif state == 7 then
				v24 = bit32.bxor(n8, 429148392)
				n7 = 5
				state = 8
			elseif state == 8 then
				if n7 <= 6 then
					state = 18
				else
					state = 9
				end
			elseif state == 9 then
				if n7 <= 7 then
					state = 17
				else
					state = 10
				end
			elseif state == 10 then
				if n7 <= 8 then
					state = 16
				else
					state = 11
				end
			elseif state == 11 then
				n8 = bit32.bxor(2166136261, v24[byte])

				if n8 < 134217728 then
					state = 13
				else
					state = 12
				end
			elseif state == 12 then
				n7 = 4
				state = 20
			elseif state == 13 then
				n7 = 8
				state = 14
			elseif state == 14 then
				if n7 <= 4 then
					state = 15
				else
					state = 8
				end
			elseif state == 15 then
				if n7 <= 1 then
					state = 2
				else
					state = 20
				end
			elseif state == 16 then
				n8 = n8 * 16777619 % 4294967296
				n7 = 2
				state = 20
			elseif state == 17 then
				tbl7 = tbl7[3]
				n7 = 0
				state = 2
			elseif state == 18 then
				if n7 <= 5 then
					state = 33
				else
					state = 19
				end
			elseif state == 19 then
				n7 = 2
				tbl7 = { 0, nil, tbl7, 1, select("#", table.unpack(t165_93_1, 1, t165_93_1.n)) + 0 }
				v24 = table.pack(byte(v24, 1, -1))
				state = 20
			elseif state == 20 then
				if n7 <= 2 then
					state = 24
				else
					state = 21
				end
			elseif state == 21 then
				if n7 <= 3 then
					state = 23
				else
					state = 22
				end
			elseif state == 22 then
				local n10 = n8 % 65536
				n8 = (((n8 - n10) / 65536 * 403 + n10 * 256) * 65536 + n10 * 403) % 4294967296
				n7 = 2
				state = 20
			elseif state == 23 then
				v23 = bit32.bxor(v23, 2277741731)
				n7 = 6
				state = 8
			elseif state == 24 then
				local v25 = tbl7[4]
				local v26 = tbl7[5]
				n9 = tbl7[1] + v25
				flag = v25 <= 0
				flag2 = not flag
				flag3 = n9 >= v26
				flag4 = n9 <= v26

				if flag then
					state = 26
				else
					state = 25
				end
			elseif state == 25 then
				flag3 = flag

				if flag2 then
					state = 28
				else
					state = 27
				end
			elseif state == 26 then
				if flag2 then
					state = 28
				else
					state = 27
				end
			elseif state == 27 then
				flag4 = flag2

				if flag3 then
					state = 30
				else
					state = 29
				end
			elseif state == 28 then
				if flag3 then
					state = 30
				else
					state = 29
				end
			elseif state == 29 then
				flag3 = flag4
				state = 30
			elseif state == 30 then
				tbl7[1] = n9

				if flag3 then
					state = 32
				else
					state = 31
				end
			elseif state == 31 then
				n7 = 7
				state = 8
			elseif state == 32 then
				n7 = 9
				byte = n9
				state = 8
			elseif state == 33 then
				return v24
			end
		end
	end

	fn11 = function(arg, arg2, arg3)
		local v23 = table.pack(T_1())

		if v23[1] then
			local v24 = v23[2]

			while true do
				arg3[fn10(377093054, v24)] = nil
				local v25 = table.pack(T_1())

				if v25[1] then
					v24 = v25[2]
				else
					break
				end
			end
		end

		local v24 = table.pack(T_1())

		if v24[1] then
			repeat
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
				local v25 = table.pack(T_1())
			until not v25[1]
		end
	end

	new = v20.new
	new2 = v15.new
	new3 = v21.new
	color = Color3.new
	v19 = v22
	traceback = v22.traceback
end

local rect
rect = Rect.new
local udim2
udim2 = UDim2.new
local udim
udim = UDim.new
local new4
new4 = Path2DControlPoint.new
local v20 = table.pack(bit32.band(nil, 4294967295))
local v21 = table.pack(bit32.band(n, 4294967295))
local v22 = table.pack(bit32.band(v20[1], 65535))
local v23 = table.pack(bit32.rshift(v20[1], 16))
local v24 = table.pack(bit32.band(v21[1], 65535))
local v25
v25 = bit32.band(v22[1] * v24[1] + bit32.lshift(bit32.band(v22[1] * bit32.rshift(v21[1], 16) + v23[1] * v24[1], 65535), 16), 4294967295)
local fn12

fn12 = function()
end

fn12(getmetatable, "getmetatable")
fn12(setmetatable, "setmetatable")
fn12(tonumber, "tonumber")
fn12(tostring, "tostring")
fn12(rawset, "rawset")
fn12(rawget, "rawget")
fn12(select, "select")
fn12(xpcall, "xpcall")
fn12(assert, "assert")
fn12(error, "error")
fn12(pcall, "pcall")
fn12(type, "type")
fn12(next, "next")
fn12(typeof, "typeof")
local n3, n4

do
	local n5 = v25 // 96
	fn12(string.gmatch, "gmatch")
	fn12(string.format, "format")
	fn12(string.match, "match")
	fn12(string.find, "find")
	fn12(string.char, "char")
	fn12(string.byte, "byte")
	fn12(string.gsub, "gsub")
	fn12(string.sub, "sub")
	fn12(string.rep, "rep")
	fn12(string.unpack, "unpack")
	fn12(string.pack, "pack")
	fn12(table.concat, "concat")
	fn12(table.insert, "insert")
	fn12(table.pack, "pack")
	fn12(table.clear, "clear")
	fn12(table.create, "create")
	fn12(table.move, "move")
	fn12(bit32.bor, "bor")
	fn12(bit32.bnot, "bnot")
	fn12(bit32.bxor, "bxor")
	fn12(bit32.band, "band")
	fn12(bit32.lshift, "lshift")
	fn12(bit32.rshift, "rshift")
	fn12(bit32.rrotate, "rrotate")
	local v26 = bit32.band(n, n5)
	fn12(bit32.lrotate, "lrotate")
	fn12(bit32.countlz, "countlz")
	fn12(bit32.countrz, "countrz")
	fn12(buffer.len, "len")
	fn12(buffer.fill, "fill")
	fn12(buffer.copy, "copy")
	fn12(buffer.create, "create")
	fn12(buffer.tostring, "tostring")
	fn12(buffer.fromstring, "fromstring")
	fn12(buffer.readstring, "readstring")
	fn12(buffer.writestring, "writestring")
	fn12(buffer.readi8, "readi8")
	local n6 = 429524177 + v25 + v26 + n5
	fn12(buffer.readu8, "readu8")
	local n7 = n5 + n6
	fn12(buffer.readi16, "readi16")
	fn12(buffer.readu16, "readu16")
	fn12(buffer.readi32, "readi32")
	fn12(buffer.readu32, "readu32")
	fn12(buffer.readf32, "readf32")
	fn12(buffer.readf64, "readf64")
	fn12(buffer.writei8, "writei8")
	fn12(buffer.writeu8, "writeu8")
	fn12(buffer.writei16, "writei16")
	fn12(buffer.writeu16, "writeu16")
	fn12(buffer.writei32, "writei32")
	fn12(buffer.writeu32, "writeu32")
	fn12(buffer.writef32, "writef32")
	fn12(buffer.writef64, "writef64")
	fn12(buffer.readbits, "readbits")
	fn12(buffer.writebits, "writebits")
	fn12(coroutine.isyieldable, "isyieldable")
	fn12(coroutine.running, "running")
	fn12(coroutine.create, "create")
	fn12(coroutine.status, "status")
	fn12(coroutine.yield, "yield")
	fn12(coroutine.close, "close")
	fn12(coroutine.resume, "resume")
	local wrap = coroutine.wrap
	local v27 = bit32.band(v26, 1404118634)
	fn12(wrap, "wrap")
	fn12(cancel, "cancel")
	fn12(spawn, "spawn")
	fn12(defer, "defer")
	fn12(delay, "delay")
	fn12(wait, "wait")
	fn12(unpack, "unpack")
	fn12(info, "info")
	fn12(traceback, "traceback")
	fn12(v18)
	local v28 = pcall
	local v29 = xpcall
	local n8 = 180300094
	local n9 = 262653826
	new3(0.88923606421752388, 0.048063810904892201, 0.50800790784244398)
	new("Folder")
	local ScreenGui = new("ScreenGui")
	local Frame = new("Frame")
	local Path2D = new("Path2D")
	Frame.Parent = ScreenGui
	local str = "Parent"
	n3 = bit32.bor(n7, 2731598571)
	Path2D[str] = Frame
	n4 = n6 + n3
	vector.create(0.96016042947283176, 0.0053999550721041123, 0.026660940154078272)

	local function fn13()
		assert(0.037761284268268192)
		select("#", 0.14950692449350922, 0.21133900245117032, 0.9178240073380487)
		tonumber(0.096177447808528882)
		tostring(0.52216976264355086)
		rawequal(scratch, scratch)
		next(nil)
		pairs(nil)(nil)

		ipairs(nil)(nil, 1)
		;(nil)(nil)
		rawget(nil, 0.36613074119467826)
		rawset(nil, 0.22998010244044031, 0.75270758872722776)
		getmetatable(nil)
		setmetatable(nil, nil)
		setmetatable(nil, nil)
		info(19149, "slnaf")
		bit32.bor(169, 195)
		bit32.bxor(5, 46)

		bit32.band(31, 224)
		;(nil)(90)
		bit32.lshift(25, 0)
		bit32.rshift(233, 17)
		bit32.lrotate(71, 11)
		bit32.rrotate(235, 18)
		bit32.countlz(217)
		bit32.countrz(75)
		buffer.create(135)

		buffer.len(nil)
		;(nil)("")
		buffer.tostring(nil)
		buffer.readi8(nil, 16)
		buffer.readu8(nil, 14)
		buffer.readi16(nil, 3)
		buffer.readu16(nil, 22)
		buffer.readi32(nil, 10)
		buffer.readu32(nil, 30)
		buffer.readf32(nil, 18)
		buffer.readf64(nil, 8)
		buffer.writei8(nil, 12, -127)
		buffer.writeu8(nil, 17, 48)
		buffer.writei16(nil, 31, -8395)
		buffer.writeu16(nil, 31, 8310)
		buffer.writei32(nil, 1, -912279845)
		buffer.writeu32(nil, 18, 619335180)
		buffer.writef32(nil, 5, 37221)

		buffer.writef64(nil, 1, 47098)
		;(nil)(nil, 8, 19)
		buffer.writestring(nil, 27, "Luraph", 2)
		buffer.readbits(nil, 252, 9)
		buffer.writebits(nil, 0, 20, 1466113256)
		buffer.copy(nil, 32, nil, 0, 16)
		buffer.fill(nil, 22, 150, 0)

		v17.new()
		;(nil):NextInteger(31, 329)
		;(nil):NextNumber(14, 601)
		;(nil):NextUnitVector()
		;(nil):NextNumber()
		;(nil):Shuffle({})
		;(nil):Clone()
		local n10 = Vector3.new(0.70462644, 0.5246086, 0.81685543) + Vector3.new(0.29080594, 0.9881754, 0.9510481)
		local vector_ = Vector3.new(1, 0, 0)
		local vector_2 = Vector3.new(0, 1, 0)
		local v30 = v16.new()
		local v31 = v16.new(nil)
		v16.Angles(0.45052052814221644, 0.83774369825693618, 0.15181525539499807)
		local xyz = Enum.RotationOrder.XYZ
		v16.new(nil, n10)
		v16.new((nil).X, (nil).Y, (nil).Z)
		v16.new((nil).X, (nil).Y, (nil).Z, 0, 0, 0, 1)
		v16.new((nil).X, (nil).Y, (nil).Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		v16.lookAt(nil, n10, vector_2)
		v16.lookAlong(nil, nil, vector_2)
		v16.fromEulerAnglesXYZ(0.45052052814221644, 0.83774369825693618, 0.15181525539499807)
		v16.fromEulerAnglesYXZ(0.45052052814221644, 0.83774369825693618, 0.15181525539499807)
		v16.fromOrientation(0.45052052814221644, 0.83774369825693618, 0.15181525539499807)
		v16.fromAxisAngle((nil).Unit, 0.45052052814221644)
		v16.fromRotationBetweenVectors(vector_, vector_2)
		v16.fromMatrix(nil, vector_, vector_2, Vector3.new(0, 0, 1))
		v16.fromEulerAngles(0.45052052814221644, 0.83774369825693618, 0.15181525539499807, xyz)
		v30:Inverse()
		v30:Orthonormalize()
		v30:Lerp(v31, 0.19908808031716263)
		v30:ToWorldSpace(v31)
		v30:ToObjectSpace(v31)
		v30:ToEulerAnglesXYZ()
		v30:ToEulerAnglesYXZ()
		v30:PointToWorldSpace(nil)
		v30:PointToObjectSpace(nil)
		v30:VectorToWorldSpace(nil)
		v30:VectorToObjectSpace(nil)
		v30:ToEulerAngles(xyz)
		v30:GetComponents()
		v30:ToOrientation()
		v30:ToAxisAngle()
		v30:FuzzyEq(v31)
		v30:AngleBetween(v31)
		v15.FromAxis(Enum.Axis.X)

		v15.FromNormalId(Enum.NormalId.Top)
		;(nil):Abs()
		;(nil):Ceil()
		;(nil):Floor()
		;(nil):Sign()
		;(nil):Dot(nil)
		;(nil):Cross(nil)
		;(nil):Angle(nil)
		;(nil):FuzzyEq(nil)
		;(nil):Lerp(nil, 0.18432316272291127)
		;(nil):Max(nil)
		;(nil):Min(nil)
		;(Vector2.new(0.044614747166633606, 0.018185429275035858)):Abs()
		;(nil):Ceil()
		;(nil):Floor()
		;(nil):Sign()
		;(nil):Dot(nil)
		;(nil):Cross(nil)
		;(nil):Angle(nil)
		;(nil):FuzzyEq(nil)
		;(nil):Lerp(nil, 0.66253609926988977)
		;(nil):Max(nil)
		;(nil):Min(nil)
		local v32 = udim(0.48507502372870182, -127)

		local v33 = udim(0.15976546405817982, 95)
		;(nil)(nil, 126, -0.30517066416093641, -103):Lerp(udim2(0.84994467275534213, -51, 0.58357858511130467, -77), 0.83333841290335986)
		local LockCenter = (nil):FromName("LockCenter")
		local enumType = LockCenter.EnumType
		enumType:GetEnumItems()
		enumType:FromName(LockCenter.Name)
		enumType:FromValue(LockCenter.Value)
		udim2(0.16380570196101227, 40, 0.054577520184077299, 54)
		udim2(0.058423489265577916, 29, 0.078273035157240406, 9)
		local v34 = udim2(0.65527759843610589, 191, 0.59782315267737296, 156)
		local v35 = new4(nil, nil, nil)
		new4((nil):Lerp(v34, 0.29305052020495048))
		local tbl3 = {}
		local v36 = new4(v34)
		tbl3[1] = v35
		tbl3[2] = v36
		utf8.char(73, 1777, 268257)
		utf8.codepoint(nil, 1, #nil)
		utf8.len(nil)
		utf8.offset(nil, 2)
		utf8.offset(nil, -2)
		local v37, v38, v39 = utf8.codes(nil)
		v37(v38, v39)
		v37(v38, utf8.offset(nil, 2))
		utf8.char(119, 821)
		utf8.nfcnormalize(nil)
		utf8.nfdnormalize(nil)
		utf8.graphemes(nil, 1, #nil)()
		n9 = (1 * n9 + 104400512) % 268435456
		n8 = (559557 * n8 + 26206279) % 268435456
	end

	local v30 = coroutine.wrap(fn13)
	local tbl3 = {}
	local n10 = 0

	local function fn14()
		local v31 = nil
		n10 += 1
		n9 = (1 * n9 + 111133540) % 268435456
		n8 = (572103 * n8 + 86646899) % 268435456
	end

	setmetatable(tbl3, { __index = fn14, __newindex = fn14 })
	local ok, result = pcall(fn14)

	if tbl2[not ok] then
		fn4(n3 + 605078396, 4)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if tbl2[not result] then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	else
		fn4(v27 + 384673585, 110)
	end

	local v31 = luraph_runtime1(nil, table.pack(n8, n9), nil)
	local flag = false
	local v32 = luraph_runtime3(nil, table.pack(v28, v13), nil)

	local function fn15()
		n9 = (1 * n9 + 176712628) % 268435456
		n8 = (20739 * n8 + 39084913) % 268435456
	end

	local v33 = luraph_runtime4(nil, table.pack(n9, n8), nil)

	local function fn16()
		n9 = n9 - n9 % 2 + 1
		n8 = (291409 * n8 + 255691879) % 268435456
		n8 = (674029 * n8 + 246903699) % 268435456
	end

	local n11 = 0

	fn = function()
		n11 += 1
		n8 = (467815 * n8 + 260982875) % 268435456
		n9 = (1 * n9 + 24741444) % 268435456
		fn()
	end

	fn2 = function(arg)
		if arg ~= 19998 then
			if arg ~= 19997 then
				if arg == 17599 then
					(nil)(arg)
				end
			else
				(nil)(arg)
			end
			;(nil)(arg + 1)

			if arg == 19997 then
				(nil)(v31, v33)

				if not nil then
					n9 = nil
					n8 = nil
					n8 = nil
					return
				end
				;(nil)()
				;(nil)(v31)

				if not nil then
					n9 = nil
					n8 = nil
					n8 = nil
					return
				end
				;(nil)(fn16, fn)

				if nil then
					n9 = nil
					n8 = nil
					n8 = nil
					return
				end
				;(nil)()

				if nil then
					n9 = nil
					n8 = nil
					n8 = nil
					return
				end

				n8 = nil
				n9 = nil
			end

			n9 = nil
			n8 = nil
			return
		end
		;(nil)()
		n8 = nil
		n9 = nil
	end

	coroutine.resume(coroutine.create(fn2), 1)
	ScreenGui:Destroy()
	fn5(n8, 4)
	fn5(n9, 4)
end

local v26
v26 = n2
local fn13

do
	local n5 = 1925040250
	local n6 = 207606494
	local n7 = 2375510210

	local v27 = coroutine.wrap(function()
		coroutine.yield(n5)
		coroutine.yield(n6)
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end)

	if fn8(v27(), n5) then
		fn4(386770811, 18)
		n2 = v26
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if fn8(v27(), n6) then
		fn4(386770811, 205)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
		bit32.band(n3, 1570532353)
		n3 = 4076659711
	end

	local thread = coroutine.create(wait)
	coroutine.resume(thread, 0)
	local v28 = coroutine.status(thread)
	fn8("suspended", v28)

	if not nil then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	pcall(coroutine.close, thread)
	local v29 = nil
	local flag = false

	spawn(function()
		v29 = coroutine.running()
		wait(0)
		flag = true
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end)

	if flag then
		fn5("NextInteger", "<f")
		n2 = 187844740
		fn6()
	else
	end

	local flag2 = not pcall(coroutine.close, v29)

	if not nil then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local close = coroutine.close

	local v30 = spawn(function()
		coroutine.yield()
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end)

	close(v30)
	local close2 = coroutine.close
	local v31 = defer(fn7)
	close2(v31)
	local close3 = coroutine.close
	local v32 = delay(899, fn7)
	close3(v32)

	fn13 = function()
	end

	fn13(getmetatable)
	fn13(setmetatable)
	fn13(tonumber)
	fn13(tostring)
	fn13(rawset)
	fn13(rawget)
	fn13(assert)
	fn13(type)
	fn13(next)
	fn13(typeof)
	fn13(string.gmatch)
	fn13(string.format)
	fn13(string.match)
	fn13(string.find)
	fn13(string.byte)
	fn13(string.gsub)
	fn13(string.sub)
	fn13(string.rep)
	fn13(string.char, nil)
	fn13(string.unpack)
	fn13(string.pack)
	fn13(table.concat)
	fn13(table.insert)
	bit32.band(n7, n4)
end

fn13(table.clear)
fn13(table.create, nil)
fn13(table.move)
local n5
n5 = n4 + 1412906114
fn13(bit32.bor, nil)
fn13(bit32.bxor, nil)
fn13(bit32.band, nil)
fn13(bit32.bnot)
fn13(bit32.lshift)
fn13(bit32.rshift)
fn13(bit32.rrotate)
fn13(bit32.lrotate)
fn13(bit32.countlz)
fn13(bit32.countrz)
fn13(buffer.len)
fn13(buffer.fill)
fn13(buffer.copy)
local v27
v27 = n5
fn13(buffer.create, nil)
fn13(buffer.tostring)
fn13(buffer.fromstring)
fn13(buffer.readstring)
fn13(buffer.writestring)
fn13(buffer.readi8)
fn13(buffer.readu8)
fn13(buffer.readi16)
fn13(buffer.readu16)
fn13(buffer.readi32)
fn13(buffer.readu32)
fn13(buffer.readf32)
fn13(buffer.readf64)
fn13(buffer.writei8)
fn13(buffer.writeu8)
fn13(buffer.writei16)
fn13(buffer.writeu16)
fn13(buffer.writei32)
fn13(buffer.writeu32)
fn13(buffer.writef32)
fn13(buffer.writef64)
fn13(buffer.readbits)
fn13(buffer.writebits)
fn13(coroutine.create)
fn13(coroutine.status)
fn13(coroutine.close)
fn13(coroutine.resume)
fn13(coroutine.wrap)
fn13(cancel)
fn13(spawn)
fn13(defer)
fn13(delay)
fn13(wait, {})
fn13(unpack)
fn13(info)
fn13(v18)
fn12(new, "new")
fn13(new, nil)
fn12(new2, "new")
fn12(new3, "new")
fn12(color, "new")
fn12(rect, "new")
local n6, n7, n8

do
	local fromAxis = v15.FromAxis
	n6 = n3 - n5
	fn12(fromAxis, "FromAxis")
	fn13(fromAxis, nil)
	local v28 = fromAxis(Enum.Axis.Y)
	local v29 = v15.FromNormalId(Enum.NormalId.Back)
	local n9 = n5 + v27
	local kind = type(v28)
	local kind2 = type(v29)
	fn4(386770811, kind == "vector" and 106 or 28)
	fn4(386770811, kind2 == "vector" and 192 or 146)
	local z = v29.Z
	fn5(v28.Y * 3791454307, 4)
	fn5(z * 1 * 4010274237, 4)

	if fn8("vector", kind) then
		fn4(n6 + 1534788935, 110)
		n6 = n6 // n9 + 3146949171
		n2 = v26
	else
		fn5(3809111902, 2928498609)
		n2 = 187844740
		fn6()
	end

	if fn8("vector", kind2) then
		fn4(v27 - 542939728, 20)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	fn4(386770811, v28.X == 0 and 176 or 100)
	fn4(n6 - 2760178361, v28.Y == 1 and 87 or 57)
	n7 = v27 // n6
	fn4(n7 + 386770811, v28.Z == 0 and 29 or 62)
	fn4(386770811, v29.X == 0 and 184 or 126)
	fn4(n6 + 1534788935, v29.Y == 0 and 15 or 203)
	fn4(n7 + 386770811, v29.Z == 1 and 146 or 85)
	fn12(udim2, "new")
	fn12(udim, "new")
	fn11(17975890, utf8, { [2612907457] = 1588543146, [4058671622] = 1277417341, [82057205] = 237526869 })
	n8 = n9 + n6
end

local tbl3
tbl3 = { utf8.nfcnormalize("팤뀡켧젾콁죠즊묘뫭"):byte(1, -1) }
local tbl4
tbl4 = { utf8.nfdnormalize("빰궹뺾졸얈숼퇤몧"):byte(1, -1) }
local v28, v29, v30, v31, v32, v33, v34, v35, v36, v37
local n9, v38, v39

do
	local v40 = tbl4[16]
	fn4(386770811, v40)
	v28 = tbl4[44]
	fn4(n6 - 2760178361, v28)
	v29 = tbl3[1]
	fn4(n7 - 3908196485, v29)
	v30 = tbl4[39]
	fn4(386770811, v30)
	v31 = tbl4[60]
	fn4(n6 - 2760178361, v31)
	v32 = tbl4[35]
	fn4(386770811, v32)
	fn4(386770811, tbl3[8])
	v33 = tbl4[57]
	fn4(n6 - 2760178361, v33)
	v34 = tbl4[24]
	fn4(n7 - 3908196485, v34)
	v35 = tbl4[8]
	fn4(386770811, v35)
	fn4(n6 - 2760178361, tbl4[52])
	local v41 = tbl4[11]
	fn4(386770811, v41)
	v36 = tbl4[53]
	fn4(386770811, v36)
	v37 = tbl3[23]
	fn4(n6 + 1534788935, v37)
	n9 = n6 + v40
	v38 = tbl4[55]
	fn4(386770811, v38)
	v39 = v41
end

local n10, v40

do
	local v41 = tbl3[20]
	fn4(386770811, v41)
	fn4(n9 - 2760178586, tbl4[17])
	local v42 = tbl4[72]
	n10 = n8 + v28
	fn4(n7 + 386770811, v42)
	fn4(386770811, tbl4[65])
	v40 = v41
end

local v41, v42, n11, v43
local v44 = tbl4[71]
fn4(386770811, v44)
v41 = tbl4[63]
fn4(n7 + 386770811, v41)
fn4(386770811, tbl4[64])
v42 = tbl3[15]
n11 = n7 - v29
fn4(n9 - 2760178586, v42)
v43 = v44
fn4(386770811, tbl4[51])
local v45
v45 = tbl4[38]
fn4(386770811, v45)
fn4(n9 - 2760178586, tbl4[59])
local v46
v46 = tbl3[14]
fn4(386770811, v46)
local v47
v47 = tbl4[56]
fn4(386770811, v47)
local v48
v48 = tbl3[4]
fn4(386770811, v48)
local v49
v49 = tbl4[34]
fn4(n11 + 386771048, v49)
local v50
v50 = tbl4[67]
fn4(386770811, v50)
local v51
v51 = tbl4[31]
fn4(n9 + 1534788710, v51)
local v52, n12, v53, v54, v55

do
	local v56 = tbl4[2]
	fn4(n11 + 386771048, v56)
	local v57 = tbl4[43]
	fn4(386770811, v57)
	v52 = tbl4[10]
	fn4(n9 - 2760178586, v52)
	n12 = n9 - v30
	v53 = tbl4[70]
	fn4(386770811, v53)
	v54 = v56
	v55 = v57
end

local v56
v56 = tbl4[28]
fn4(386770811, v56)
local v57
v57 = tbl3[7]
fn4(386770811, v57)
fn4(386770811, tbl4[62])
fn4(386770811, tbl4[14])
fn4(386770811, tbl4[48])
fn4(n11 - 3908196248, tbl4[30])
fn4(386770811, tbl4[50])
fn4(386770811, tbl4[5])
fn4(n11 + 386771048, tbl4[26])
fn4(386770811, tbl3[16])
local v58 = v31
fn4(386770811, tbl4[27])
fn4(386770811, tbl4[23])
fn4(386770811, tbl3[17])
fn4(386770811, tbl4[20])
fn4(386770811, tbl3[27])
fn4(386770811, tbl4[46])
fn4(386770811, tbl4[9])
fn4(386770811, tbl4[41])
fn4(386770811, tbl3[3])
fn4(386770811, tbl4[3])
fn4(386770811, tbl3[22])
fn4(386770811, tbl3[12])
local n13

do
	local v59 = tbl4[12]
	fn4(386770811, v59)
	local v60 = tbl4[29]
	n13 = n10 + v32
	fn4(386770811, v60)
	fn4(386770811, tbl3[21])
	fn4(386770811, tbl4[22])
	local v61 = tbl4[37]
	local v62 = v59
	fn4(386770811, v61)
	fn4(386770811, tbl3[2])
	fn4(386770811, tbl4[68])
	fn4(386770811, tbl3[9])
	fn4(386770811, tbl4[15])
	fn4(386770811, tbl3[5])
	local v63 = v61
end

fn4(386770811, tbl4[61])
fn4(386770811, tbl3[10])
fn4(386770811, tbl4[58])
fn4(386770811, tbl4[33])
fn4(386770811, tbl4[40])
fn4(386770811, tbl4[4])
fn4(386770811, tbl4[18])
fn4(386770811, tbl3[18])
fn4(386770811, tbl3[13])
fn4(386770811, tbl4[21])
fn4(386770811, tbl4[42])
fn4(386770811, tbl3[19])
fn4(386770811, tbl3[25])
fn4(386770811, tbl4[66])
fn4(386770811, tbl4[6])
fn4(386770811, tbl4[69])
fn4(386770811, tbl3[24])
fn4(386770811, tbl4[49])
fn4(386770811, tbl3[11])
fn4(386770811, tbl4[32])
fn4(386770811, tbl4[54])
fn4(386770811, tbl4[45])
fn4(386770811, tbl4[47])
fn4(386770811, tbl4[13])
fn4(386770811, tbl4[7])
fn4(386770811, tbl4[19])
fn4(386770811, tbl4[25])
local n14
n14 = n12 - v33 - v34
local n15
n15 = n13 + v35
fn4(386770811, tbl3[6])
fn4(386770811, tbl3[26])
fn4(386770811, tbl4[36])
fn4(386770811, tbl4[1])
fn12(new4, "new")
fn13(new4, nil)
local ScreenGui
ScreenGui = new("ScreenGui")
local v59

do
	local Frame = new("Frame")
	Frame.Position = udim2(0, 0, 0, 0)
	Frame.Size = udim2(0, 232, 0, 232)
	Frame.Parent = ScreenGui
	local Path2D = new("Path2D")
	Path2D.Parent = Frame
	v59 = Path2D
end

do
	local setControlPoints = v59.SetControlPoints
	local tbl5 = {}
	local v60 = new4(udim2(0.5, -7, 0, -10), udim2(-0.125, -3, -0.125, 2), udim2(0, 0, 0, 0))
	local v61 = new4(udim2(0.375, 4, 0, -5), udim2(0, -7, 0, 5), udim2(0, -4, 0, -6))
	local v62 = new4(udim2(0.25, 4, 0.25, -3), udim2(0, 0, 0, 0), udim2(0.0625, -6, 0, 1))
	local v63 = new4(udim2(0, 6, 0, -2), udim2(0, -5, 0, 1), udim2(0, 0, 0, 0))
	local v64 = udim2(0.375, 6, 0.4375, 6)
	local v65 = udim2(0, 0, 0, 0)
	tbl5[1] = v60
	tbl5[2] = v61
	tbl5[3] = v62
	tbl5[4] = v63

	do
		local values = table.pack(new4(v64, v65, udim2(0, 1, 0, -5)))
		table.move(values, 1, values.n, 5, tbl5)
	end

	setControlPoints(v59, tbl5)
end

do
	local length = v59:GetLength()
	local unpack_ = string.unpack
	local pack = string.pack
	bit32.band(length - length % 1, 536870911)
	fn5(unpack_("<I4", pack("<f", length)), 4)
end

local n16
n16 = 0.1666666716337204

do
	local positionOnCurve = v59:GetPositionOnCurve(n16)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	fn5(unpack_("<I4", pack(">f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_2(">I4", pack2(">f", scale2)), 4)
end

do
	local positionOnCurve = v59:GetPositionOnCurve(0.20000000298023224)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	fn5(unpack_(">I4", pack(">f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_2("<I4", pack2(">f", scale2)), 4)
end

do
	local positionOnCurve = v59:GetPositionOnCurve(0.45454546809196472)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	fn5(unpack_(">I4", pack(">f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_2(">I4", pack2("<f", scale2)), 4)
end

do
	local tangentOnCurve = v59:GetTangentOnCurve(0.66666668653488159)
	local unpack_ = string.unpack
	local pack = string.pack
	local n17 = 246 + v39
	local x = tangentOnCurve.X
	bit32.band(x - x % 1, 536870911)
	fn5(unpack_(">I4", pack(">f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurve.Y
	bit32.band(y - y % 1, 536870911)
	local v60 = unpack_2(">I4", pack2("<f", y))
	local v61 = bit32.band(n14, v37)
	fn5(v60, 4)
	local tangentOnCurve2 = v59:GetTangentOnCurve(0.77777779102325439)
	fn5(string.unpack(">I4", string.pack(">f", tangentOnCurve2.X)), 4)
	local unpack_3 = string.unpack
	local pack3 = string.pack
	local y2 = tangentOnCurve2.Y
	bit32.band(y2 - y2 % 1, 536870911)
	fn5(unpack_3("<I4", pack3("<f", y2)), 4)
	local positionOnCurveArcLength = v59:GetPositionOnCurveArcLength(0.60000002384185791)
	local unpack_4 = string.unpack
	local pack4 = string.pack
	local scale = positionOnCurveArcLength.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	fn5(unpack_4(">I4", pack4("<f", scale)), 4)
	local unpack_5 = string.unpack
	local pack5 = string.pack
	local scale2 = positionOnCurveArcLength.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_5("<I4", pack5(">f", scale2)), 4)
	local positionOnCurveArcLength2 = v59:GetPositionOnCurveArcLength(0.40000000596046448)
	local unpack_6 = string.unpack
	local pack6 = string.pack
	local scale3 = positionOnCurveArcLength2.X.Scale
	bit32.band(scale3 - scale3 % 1, 536870911)
	fn5(unpack_6(">I4", pack6(">f", scale3)), 4)
	local unpack_7 = string.unpack
	local pack7 = string.pack
	local scale4 = positionOnCurveArcLength2.Y.Scale
	bit32.band(scale4 - scale4 % 1, 536870911)
	fn5(unpack_7("<I4", pack7("<f", scale4)), 4)
	local positionOnCurveArcLength3 = v59:GetPositionOnCurveArcLength(0.40000000596046448)
	local unpack_8 = string.unpack
	local n18 = v61 - v38
	local pack8 = string.pack
	local scale5 = positionOnCurveArcLength3.X.Scale
	bit32.band(scale5 - scale5 % 1, 536870911)
	fn5(unpack_8("<I4", pack8(">f", scale5)), 4)
	local unpack_9 = string.unpack
	local pack9 = string.pack
	local scale6 = positionOnCurveArcLength3.Y.Scale
	bit32.band(scale6 - scale6 % 1, 536870911)
	fn5(unpack_9(">I4", pack9(">f", scale6)), 4)
end

local n17

do
	local tangentOnCurveArcLength = v59:GetTangentOnCurveArcLength(0.1666666716337204)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurveArcLength.X
	bit32.band(x - x % 1, 536870911)
	fn5(unpack_("<I4", pack(">f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurveArcLength.Y
	bit32.band(y - y % 1, 536870911)
	n17 = n15 + v36 + v40
	fn5(unpack_2("<I4", pack2("<f", y)), 4)
end

local str

do
	local tangentOnCurveArcLength = v59:GetTangentOnCurveArcLength(0.53846156597137451)
	local unpack_ = string.unpack
	local pack = string.pack
	str = "X"
	local v60 = tangentOnCurveArcLength[str]
	bit32.band(v60 - v60 % 1, 536870911)
	fn5(unpack_(">I4", pack(">f", v60)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurveArcLength.Y
	bit32.band(y - y % 1, 536870911)
	fn5(unpack_2(">I4", pack2(">f", y)), 4)
end

-- Bypass Exhub
ScreenGui:Destroy()
fn11(17975890, math, { [1065801118] = 1621921154, [2821163138] = 482056660, [1060657456] = 128574184 })
local n18
n18 = 128

fn11(17975890, v19, {
	[2376574127] = 491023644,
	[2352290747] = 1292725268,
	[640277504] = 2046122956,
	[318051548] = 856938718,
	[2031636611] = 1595101429,
})

fn11(17975890, v14, { [1739794133] = 1229673170, [3606886080] = 792053881 })
local v60
v60 = game
local fn14

do
	local v61 = workspace
	local n19 = n18 + 284834814

	fn14 = function(arg, arg2, arg3)
		local v62 = nil
		local kind = type(arg2)
		fn8("userdata", kind)

		if not nil then
			fn5(145622347, 4)
			local n20 = nil - n19
			n2 = 187844740
			fn6()
			error("devirt: corrupt/encrypted register index 1090 (at 46:41)")
		end

		local kind2 = typeof(arg2)
		fn8("Instance", kind2)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		local n20 = arg + n19
		local parent = arg2.Parent
		local parent2 = arg2.Parent

		if tbl2[not parent] then
			fn8(parent, parent2)

			if not nil then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
			end
		end

		local name = arg2.Name
		local name2 = arg2.Name
		local kind3 = type(name)
		fn8("string", kind3)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(name, name2)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(#name, #name2)

		if not nil then
			fn5(145622347, 4)
			local n21 = nil + n19
			n2 = 187844740
			fn6()
		end

		local v63 = fn8
		fn8(tostring(arg2), name)
		local v64

		if nil then
			v64 = v63
		else
			v64 = v63
			fn5("new", "value")
			n2 = 0.40000000596046448
			fn6()
		end

		while true do
			fn8(arg3, arg2.ClassName)

			if not nil then
				fn5(3705875824, 0.40000000596046448)
				n2 = 1
				fn6()
			end

			local attributeChanged = arg2.AttributeChanged
			fn8(attributeChanged, arg2.AttributeChanged)

			if nil then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
			end

			if not nil then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
			end

			repeat
				local connect = attributeChanged.Connect
				fn12(attributeChanged.Connect, "Connect")
				arg3 = fn12

				fn12(connect, "Connect")
				;(nil)(2760178361, "unpack")
				upv24 = 3503908473
			until not v64
		end
	end

	n19 = 26223816
	fn14(108036427, v60, "DataModel")
	fn14(108036427, v61, "Workspace")

	if fn8(v60, v61.Parent) then
		fn4(386770811, 179)
		n2 = v26
	else
		fn5("string", "Destroy")
		n2 = 187844740
		fn6()
	end
end

local hasTag, v61, n19

do
	local Folder = new("Folder")
	fn14(108036427, Folder, "Folder")
	hasTag = Folder.HasTag
	local ok, result = pcall(hasTag, Vector2.new(-102.61175537109375, 653.5042724609375), 675016297)
	local flag = not ok

	if not tbl2[flag] then
		fn5(fn10(377093054, result), 4)
	end

	local v62 = n2

	if tbl2[flag] then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	else
		fn4(386770811, 186)
		n2 = v62
	end

	local children, v63, v64 = Folder:GetChildren()
	local v65 = table.pack(T_1())

	if v65[1] then
		repeat
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
			local v66 = table.pack(T_1())
		until not v66[1]
	end

	Folder:Destroy()
	local v66 = n2
	local v67 = Folder
	local Folder2 = new("Folder", v67)
	fn14(108036427, Folder2, "Folder")
	local n20 = 4294967207
	local v68

	if fn8(v67, Folder2.Parent) then
		v68 = v66
		fn4(386770811, 124)
		n2 = v68
	else
		v68 = v66
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if fn8(Folder2.Parent, Folder2.Parent) then
		fn4(386770811, 235)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
		n17 = n17 + v43 - 135
	end

	local waitForChild = v67.WaitForChild
	fn12(waitForChild, "WaitForChild")
	fn13(waitForChild, nil)
	local name = tostring(137031383)
	Folder2.Name = name
	local v69 = waitForChild(v67, name)

	if fn8(Folder2, v69) then
		fn4(386770811, 58)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	v67:Destroy()
	Folder2:Destroy()

	if tbl2[not Folder2.Parent] then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	else
		fn4(386770811, 160)
	end

	local n21 = n17 + v41

	if tbl2[not pcall(function()
		Folder2.Parent = v67
	end)] then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	else
		fn4(386770811, 238)
	end

	n2 = v68
	local HttpService = v60:GetService("HttpService")
	fn14(108036427, HttpService, "HttpService")
	local v70 = n2
	local v71

	if fn8(v60, HttpService.Parent) then
		fn4(386770811, 166)
		n2 = v70
		v71 = v70
	else
		v71 = v70
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local RunService = v60:GetService("RunService")
	fn14(108036427, RunService, "RunService")

	if fn8(v60, RunService.Parent) then
		fn4(386770811, 34)
		n2 = v71
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	fn12(RunService.IsStudio, "IsStudio")
	fn12(RunService.IsClient, "IsClient")
	local n22 = n20 // v42
	fn12(RunService.IsServer, "IsServer")
	fn13(RunService.IsStudio)
	fn13(RunService.IsClient)
	fn13(RunService.IsServer)
	RunService:IsServer()

	if nil then
		local StarterPlayer = v60:GetService("StarterPlayer")
		fn14(108036427, StarterPlayer, "StarterPlayer")
		fn8(v60, StarterPlayer[1])
		local v72

		if nil then
			v72 = StarterPlayer
		else
			v72 = StarterPlayer
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		local children2, v73
		children2, v73, hasTag = v72:GetChildren()
		local n23 = 0
		local v74 = table.pack(T_1())

		if v74[1] then
			repeat
				n23 += 1
				local v75 = table.pack(T_1())
			until not v75[1]
		end

		if nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
			n22 = 33294319
		end
	end

	local n23 = n21 + v45

	if tbl2[not pcall(v60.GetChildren)] then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	else
		fn4(386770811, 25)
		n2 = v71
	end

	local v72 = Enum
	local v73 = n2

	if fn8(type(v72), "userdata") then
		fn4(386770811, 181)
		n2 = v73
		v61 = v73
	else
		v61 = v73
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if fn8(typeof(v72), "Enums") then
		fn4(386770811, 43)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local v74 = getmetatable(v72)

	if fn8("The metatable is locked", v74) then
		fn4(386770811, 38)
	else
		fn5(-2, "EnumType")
		n2 = 187844740
		fn6()
	end

	local block = v72.PartType.Block

	if fn8(type(block), "userdata") then
		fn4(386770811, 215)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if fn8(typeof(block), "EnumItem") then
		fn4(386770811, 192)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local v75 = getmetatable(block)

	if fn8("The metatable is locked", v75) then
		fn4(386770811, 56)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	fn12(block.IsA, "IsA")
	fn13(block.IsA)
	local name2 = block.Name
	local value = block.Value

	if fn8(type(name2), "string") then
		fn4(386770811, 211)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if fn8(type(value), "number") then
		fn4(386770811, 125)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local enumType = block.EnumType

	if fn8(block, enumType[name2]) then
		fn4(386770811, 76)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
		n18 = bit32.band(n18, v46)
	end

	if fn8(type(enumType), "userdata") then
		fn4(386770811, 71)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if fn8(typeof(enumType), "Enum") then
		fn4(386770811, 2)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local v76 = getmetatable(enumType)

	if fn8("The metatable is locked", v76) then
		fn4(386770811, 102)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local v77 = bit32.band(n22, v47)
	fn12(enumType.FromName, "FromName")
	fn12(enumType.FromValue, "FromValue")
	fn13(enumType.FromName)
	fn13(enumType.FromValue)
	local v78 = enumType:FromName(name2)
	local n24 = n23 + v48

	if fn8(block, v78) then
		fn4(386770811, 137)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local v79 = enumType:FromValue(value)

	if fn8(block, v79) then
		fn4(386770811, 189)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local new5 = v17.new
	fn12(new5, "new")
	fn13(new5, {})
	local v80 = new5(433013060)

	if fn8(type(v80), "userdata") then
		fn4(386770811, 229)
		n2 = v61
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
		n18 = n18 - v49 + 225
	end

	if fn8(typeof(v80), "Random") then
		fn4(386770811, 131)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	fn12(v80.NextUnitVector, "NextUnitVector")
	fn12(v80.NextInteger, "NextInteger")
	fn12(v80.NextNumber, "NextNumber")
	fn12(v80.Shuffle, "Shuffle")
	fn12(v80.Clone, "Clone")
	local v81 = new5(48486879)
	local clone = v81:Clone()
	fn5(v81:NextInteger(838, 868), 4)
	local unpack_ = string.unpack
	local pack = string.pack
	n19 = n24 + v50
	local v82 = clone:NextNumber()
	bit32.band(v82 - v82 % 1, 536870911)
	fn5(unpack_(">I4", pack("<f", v82)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local v83 = v81:NextNumber()
	bit32.band(v83 - v83 % 1, 536870911)
	fn5(unpack_2(">I4", pack2("<f", v83)), 4)
	fn5(v81:NextInteger(132, 297), 4)
	bit32.band(v77, v51)
	local unpack_3 = string.unpack
	local pack3 = string.pack
	local v84 = v81:NextNumber()
	bit32.band(v84 - v84 % 1, 536870911)
	fn5(unpack_3("<I4", pack3(">f", v84)), 4)
	local clone2 = clone:Clone()
	fn5(clone2:NextInteger(821, 1605), 4)
	fn5(clone2:NextInteger(48, 632), 4)
	fn5(clone2:NextInteger(45, 796), 4)
	local unpack_4 = string.unpack
	local pack4 = string.pack
	local v85 = clone2:NextNumber()
	bit32.band(v85 - v85 % 1, 536870911)
	fn5(unpack_4("<I4", pack4("<f", v85)), 4)
	local unpack_5 = string.unpack
	local pack5 = string.pack
	local v86 = v81:NextNumber()
	bit32.band(v86 - v86 % 1, 536870911)
	fn5(unpack_5("<I4", pack5(">f", v86)), 4)
	fn5(v81:NextInteger(859, 1299), 4)
	local unpack_6 = string.unpack
	local pack6 = string.pack
	local v87 = v81:NextNumber()
	bit32.band(v87 - v87 % 1, 536870911)
	fn5(unpack_6(">I4", pack6("<f", v87)), 4)
end

do
	local ok, result = pcall(assert, false)

	if ok or not result or type(result) ~= "string" then
		fn5("Connect", 660321578)
		n2 = 187844740
		fn6()
	end
end

local v62, n20, n21

do
	local ok, result = pcall(function(L,...)(...)[...]=nil;end)
	v62 = v54
	local ok2, result2 = pcall(function(L,...)return(...)[...];end)
	n20 = n19 + v55
	local ok3, result3 = pcall(function(L,...)return(...)();end)

	if ok or ok2 or ok3 then
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	local function fn15(arg, arg2, arg3)
		local state = 1
		local v63, v64, v65, v66, n22, v67, n23, v68, n24, n25, n26, v69, v70, str2, v71, n27, n28, v72, n29, flag, flag2, flag3, flag4, v73

		while true do
			if state == 1 then
				v63 = arg
				v64 = arg2
				v65 = arg3
				v66 = nil
				n22 = nil
				v67 = nil
				n23 = nil
				v68 = nil
				state = 2
			elseif state == 2 then
				n24, n25, n26 = string.find(v64, ":[^%w%W]?(%d%d*)[\r:\n]")
				state = 3
			elseif state == 3 then
				if nil then
					state = 4
				else
					state = 34
				end
			elseif state == 4 then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()

				if v65 then
					state = 34
				else
					state = 5
				end
			elseif state == 5 then
				if nil then
					state = 6
				else
					state = 3
				end
			elseif state == 6 then
				if nil <= 13 then
					state = 21
				else
					state = 7
				end
			elseif state == 7 then
				if nil <= 20 then
					state = 15
				else
					state = 8
				end
			elseif state == 8 then
				if nil <= 23 then
					state = 13
				else
					state = 9
				end
			elseif state == 9 then
				if nil <= 25 then
					state = 11
				else
					state = 10
				end
			elseif state == 10 then
				if nil <= 26 then
					state = 70
				else
					state = 44
				end
			elseif state == 11 then
				if nil <= 24 then
					state = 12
				else
					state = 3
				end
			elseif state == 12 then
				local v74 = table.pack(bit32.band(v63, 4294967295))
				local v75 = table.pack(bit32.band(v74[1], 65535))
				local v76 = bit32.band(28510 * v75[1] + bit32.lshift(bit32.band(28510 * bit32.rshift(v74[1], 16) + 58122 * v75[1], 65535), 16), 4294967295)
				local v77 = table.pack(bit32.band(bit32.bnot(v63), 4294967295))
				local v78 = table.pack(bit32.band(v77[1], 65535))
				bit32.bxor(nil, v68 + v76 + bit32.band(28510 * v78[1] + bit32.lshift(bit32.band(28510 * bit32.rshift(v77[1], 16) + 58122 * v78[1], 65535), 16), 4294967295))
				v69 = n24
				v70 = v64
				str2 = n25
				v71 = n26
				n27 = nil
				state = 56
			elseif state == 13 then
				if nil <= 21 then
					state = 40
				else
					state = 14
				end
			elseif state == 14 then
				if nil <= 22 then
					state = 54
				else
					state = 65
				end
			elseif state == 15 then
				if nil <= 16 then
					state = 19
				else
					state = 16
				end
			elseif state == 16 then
				if nil <= 18 then
					state = 18
				else
					state = 17
				end
			elseif state == 17 then
				if nil <= 19 then
					state = 66
				else
					state = 42
				end
			elseif state == 18 then
				if nil <= 17 then
					state = 34
				else
					state = 62
				end
			elseif state == 19 then
				if nil <= 14 then
					state = 38
				else
					state = 20
				end
			elseif state == 20 then
				if nil <= 15 then
					state = 2
				else
					state = 45
				end
			elseif state == 21 then
				if nil <= 6 then
					state = 28
				else
					state = 22
				end
			elseif state == 22 then
				if nil <= 9 then
					state = 26
				else
					state = 23
				end
			elseif state == 23 then
				if nil <= 11 then
					state = 25
				else
					state = 24
				end
			elseif state == 24 then
				if nil <= 12 then
					state = 39
				else
					state = 68
				end
			elseif state == 25 then
				if nil <= 10 then
					state = 60
				else
					state = 61
				end
			elseif state == 26 then
				if nil <= 7 then
					state = 63
				else
					state = 27
				end
			elseif state == 27 then
				if nil <= 8 then
					state = 4
				else
					state = 46
				end
			elseif state == 28 then
				if nil <= 2 then
					state = 32
				else
					state = 29
				end
			elseif state == 29 then
				if nil <= 4 then
					state = 31
				else
					state = 30
				end
			elseif state == 30 then
				if nil <= 5 then
					state = 4
				else
					state = 55
				end
			elseif state == 31 then
				if nil <= 3 then
					state = 41
				else
					state = 58
				end
			elseif state == 32 then
				if nil <= 0 then
					state = 47
				else
					state = 33
				end
			elseif state == 33 then
				if nil <= 1 then
					state = 36
				else
					state = 67
				end
			elseif state == 34 then
				fn5(n24, 2)
				fn5(n25, 2)
				n28 = nil + v63
				v72 = string.match(v64, "[:][^%x%X]*([%d]%d*)[:\n\r][^%a%A]*")

				if n26 then
					state = 37
				else
					state = 35
				end
			elseif state == 35 then
				n26 = v72
				state = 36
			elseif state == 36 then
				n23 = n26
				n26 = 0
				state = 38
			elseif state == 37 then
				n23 = v72
				state = 38
			elseif state == 38 then
				(nil)(n26 + 0, 2)
				n26 = fn5

				if n23 then
					state = 40
				else
					state = 39
				end
			elseif state == 39 then
				n23 = 0
				state = 40
			elseif state == 40 then
				n26(n23 + 0, 2)
				local v74 = string.gmatch(v64, ":[^%c%C]*(%d+)[\r\n%:][^%c%C]*")
				n26 = v74()
				fn8(v74(), nil)

				if nil then
					state = 42
				else
					state = 41
				end
			elseif state == 41 then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
				state = 42
			elseif state == 42 then
				local v74 = fn5

				if n26 then
					state = 45
				else
					state = 43
				end
			elseif state == 43 then
				state = 44
			elseif state == 44 then
				n26 = 0
				state = 45
			elseif state == 45 then
				(nil)(n26 + 0, 2)
				local sub = string.sub
				local v74 = bit32.bor(nil, v63)
				n26 = sub(v64, n24 + 1, n25 - 1)
				string.char(string.byte(v64, n24 + 1, n25 - 1))
				n23 = string.byte
				state = 46
			elseif state == 46 then
				local v74 = n23(v64, nil, n24 + 1)
				fn5(n26 + 0, 2)
				fn5(nil + 0, 2)
				fn4(386770811, v74)
				local tbl5 = { nil, 1, n25 - 1 + 0, v67, n24 + 1 - 1 }
				n24 = 0
				v67 = tbl5
				state = 47
			elseif state == 47 then
				local v74 = v67[2]
				local v75 = v67[3]
				n29 = v67[5] + v74
				flag = v74 <= 0
				flag2 = not flag
				flag3 = n29 >= v75
				flag4 = n29 <= v75

				if flag then
					state = 49
				else
					state = 48
				end
			elseif state == 48 then
				flag3 = flag

				if flag2 then
					state = 51
				else
					state = 50
				end
			elseif state == 49 then
				if flag2 then
					state = 51
				else
					state = 50
				end
			elseif state == 50 then
				flag4 = flag2

				if flag3 then
					state = 53
				else
					state = 52
				end
			elseif state == 51 then
				if flag3 then
					state = 53
				else
					state = 52
				end
			elseif state == 52 then
				flag3 = flag4
				state = 53
			elseif state == 53 then
				v67[5] = n29

				if flag3 then
					state = 69
				else
					state = 54
				end
			elseif state == 54 then
				state = 55
			elseif state == 55 then
				fn5(n24, 2)
				v66 = nil
				n22 = 0
				local gsub = string.gsub
				local n30 = n28 + 520942905

				local function fn16(arg4)
					v66 = arg4
					n22 += 1
				end

				local v74 = table.pack(bit32.band(v63, 4294967295))
				local v75 = table.pack(bit32.band(v74[1], 65535))
				local v76 = bit32.band(28510 * v75[1] + bit32.lshift(bit32.band(28510 * bit32.rshift(v74[1], 16) + 58122 * v75[1], 65535), 16), 4294967295)
				local v77 = table.pack(bit32.band(bit32.bnot(v63), 4294967295))
				local v78 = table.pack(bit32.band(v77[1], 65535))
				local n31 = 3956065042 + v76 + bit32.band(28510 * v78[1] + bit32.lshift(bit32.band(28510 * bit32.rshift(v77[1], 16) + 58122 * v78[1], 65535), 16), 4294967295)
				n30 = 4275680569
				v69 = gsub
				v70 = v64
				str2 = "[:]([0-9][0-9]*)[\n:\r]"
				v71 = fn16
				n27 = 1
				state = 56
			elseif state == 56 then
				local v74
				v74, v73 = v69(v70, str2, v71, n27)
				local n30 = 1574416338
				fn8(n22, 1)

				if nil then
					state = 59
				else
					state = 57
				end
			elseif state == 57 then
				n24 = v73
				state = 58
			elseif state == 58 then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
				state = 60
			elseif state == 59 then
				n24 = v73
				state = 60
			elseif state == 60 then
				fn8(n24, 1)

				if nil then
					state = 62
				else
					state = 61
				end
			elseif state == 61 then
				fn5("IsStudio", 1049887061)
				n2 = 255
				fn6()
				state = 62
			elseif state == 62 then
				n24 = fn5

				if v66 then
					state = 64
				else
					state = 63
				end
			elseif state == 63 then
				n25 = 0
				state = 65
			elseif state == 64 then
				n25 = v66
				state = 65
			elseif state == 65 then
				n24(n25 + 0, 2)
				fn8(string.sub(v64, 2, 2), v65)

				if nil then
					state = 67
				else
					state = 66
				end
			elseif state == 66 then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
				state = 67
			elseif state == 67 then
				local v74 = fn4
				local v75 = string.byte(v64, 2, 2)
				v74(386770811, v75)
				state = 68
			elseif state == 68 then
				return
			elseif state == 69 then
				n25 = n29
				state = 70
			elseif state == 70 then
				n24 = n24 * 10 + string.byte(v64, n25, n25) - 48
				state = 47
			end
		end
	end

	fn15(408502975, "main:142: attempt to perform arithmetic (mod) on string and nil", "a")
	fn15(408502975, "LocalScript:52: attempt to call a boolean value", "o")

	fn3 = function(arg)
		local fn16 = nil
		local v63 = string.match(arg, "[%:][^%d%D]*([0-9]+)[^%c%C]?[:\n\r]")
		local v64 = string.gmatch(arg, "[%:](%d%d*)[^%u%U]-[\r\n:][^%x%X]-")()
		local v65, v66 = string.find(arg, "[%:][^%x%X]-(%d%d*)[\n\r:][^%x%X]*")
		local flag = not v65
		local flag2

		if v65 then
			flag2 = not v66
		else
			flag2 = flag
		end

		if flag2 then
			local v67 = fn5
			local v68 = table.pack(bit32.band(nil, 4294967295))
			local v69 = table.pack(bit32.band(nil, 4294967295))
			local v70 = table.pack(bit32.band(v68[1], 65535))
			local v71 = table.pack(bit32.rshift(v68[1], 16))
			local v72 = table.pack(bit32.band(v69[1], 65535))
			local v73 = bit32.band(v70[1] * v72[1] + bit32.lshift(bit32.band(v70[1] * bit32.rshift(v69[1], 16) + v71[1] * v72[1], 65535), 16), 4294967295)
			v67(1030390059, 3132799674)
			n2 = "i"
			fn6()
			error("devirt: bit32.bxor failed: invalid literal for int() with base 10: b'Luraph' (at 46:163)")
		end

		local str2 = string.sub(nil, v65 + 1, v66 - 1)
		local v67 = string.char((nil)(arg, v65 + 1, v66 - 1))
		local v68 = nil
		local v69 = str2
		local n22 = 0
		local n23 = nil - 10867521

		fn16 = function(arg2)
			fn8(info(1, "f"), fn16)

			if not nil then
				fn5(145622347, 4)
				n2 = 187844740
				fn6()
			end

			while true do
				local gsub = string.gsub
				fn8(info(2, "f"), gsub)

				if not nil then
					fn5(145622347, 4)
					n2 = 187844740
					fn6()
				end

				fn8(info(3, "f"), fn3)

				if not nil then
					fn5(145622347, 4)
					n2 = 187844740
					fn6()
				end

				v68 = arg2
			end
		end

		n23 = 423974155
		local v70, v71 = string.gsub(arg, ":[^%s%S]-(%d%d*)[\r%:\n][^%a%A]-", fn16, 1)
		fn8(n22, 1)

		if nil then
		else
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(v71, 1)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		local flag3 = not v63
		local flag4

		if v63 then
			flag4 = not v64
		else
			flag4 = flag3
		end

		if flag4 or not v69 or not v67 or not v68 then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		local n24 = v63 + 0
		local n25 = v64 + 0
		local n26 = v69 + 0
		local n27 = v67 + 0
		local n28 = v68 + 0
		fn8(v63, v64)
		local v72

		if nil then
			v72 = n25
		else
			v72 = n25
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(v64, v69)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(v69, v67)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(v67, v68)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(n24, v72)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(v72, n26)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(n26, n27)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		fn8(n27, n28)

		if not nil then
			fn5(145622347, 4)
			n2 = 187844740
			fn6()
		end

		return n24
	end

	local v63 = fn3(result)
	local v64 = fn3(result2)
	n21 = n18 + v52
	local v65 = fn3(result3)

	if fn8(v63, v64) then
		fn4(386770811, 57)
		n2 = v61
	else
		fn5("spawn", "a")
		n2 = 187844740
		fn6()
	end

	if fn8(v64, v65) then
		fn4(386770811, 21)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end

	if fn8(v65, v63) then
		fn4(386770811, 152)
	else
		fn5(145622347, 4)
		n2 = 187844740
		fn6()
	end
end

for _, v63 in {}, nil, nil do
	local exitTo = nil

	while true do
		hasTag = type(v63)

		if fn8("function", hasTag) then
			info(v63, "sl")
			local v64 = table.pack(T_1())
			if v64[1] then
				v63 = v64[3]
				continue
			end
			break
		else
			exitTo = 1
			break
		end
	end

	if exitTo == 1 then
		continue
	end
	break
end

fn9(nil --[[ the caller's registers ]], 428958460)
setmetatable(nil --[[ the caller's registers ]], nil)
local fn15, v63, v64, n22

do
	local tbl5 = {}
	local tbl6 = {}
	local n23 = -1
	local v65 = nil
	local n24 = 253
	local n25 = 201
	local tbl7 = { v65, v2, 1, 255, n23 }

	while true do
		local v66 = tbl7[3]
		local v67 = tbl7[4]
		local n26 = tbl7[5] + v66
		local flag = v66 <= 0
		local flag2 = not flag
		local flag3 = n26 >= v67
		local flag4 = n26 <= v67

		if flag then
			if flag2 then
				flag3 = flag3 or flag4
			else
				flag4 = flag2
				flag3 = flag3 or flag4
			end
		else
			flag3 = flag

			if flag2 then
				flag3 = flag3 or flag4
			else
				flag3 = flag3 or flag2
			end
		end

		tbl7[5] = n26

		if flag3 then
			local v68 = n26
			local n27 = (n24 * v68 + n25) % 256
			local n28 = (n24 * n27 + n25) % 256
			local n29 = (n24 * n28 + n25) % 256
			local n30 = (n24 * n29 + n25) % 256
			tbl5[v68] = n27 + n28 * 256 + n29 * 65536 + n30 * 16777216
			tbl6[v68] = n30
			continue
		end

		break
	end

	buffer.create(16)
	luraph_runtime5(nil, table.pack(tbl5, tbl6), nil)

	fn15 = function()
		error("devirt: bit32.bxor failed: int() argument must be a string, a bytes-like object or a real number, not 'LTable' (at 46:773)")
	end

	v63 = nil
	v64 = nil

	n22 = 14
	;(9)(n16, fn8)

	hasTag(nil, new3)
	;(nil)(n23, nil)
end

local n23 = v62 + v53
tbl[16] = 16

do
	local n24 = n20 + v56
	local v65 = bit32.bxor(n21, v57)
	local v66 = luraph_runtime6(nil, table.pack(v), nil)
	local v67 = bit32.bxor(n24, 670266353)

	local function fn16()
		while v67 ~= 165264605 do
		end

		error("devirt: symbolic value store into proto array (at 246:32)")
	end

	v67 = bit32.bxor(v67, v65 + 72212692)
	local v68 = bit32.bxor(n24, 604747833)

	local function fn17(arg, arg2, arg3, arg4)
		if v68 == 219581420 then
			if nil then
				bit32.bor(nil, v68)
				error("devirt: arith on 1103450734 b'new' (at 198:186)")
			end

			return nil
		end

		fn16(arg2, nil, arg3, arg4)
		return nil
	end

	v68 = bit32.bxor(v68, v65 - 4236632821)

	local function fn18(arg, arg2, arg3, arg4)
		if nil then
			return (fn16(arg2, arg, arg3, arg4))
		end
		return nil
	end

	local function fn19(arg, arg2, arg3, arg4, arg5, arg6)
		if nil then
			error("devirt: arith on b'Destroy' b'<I4' (at 46:257)")
		end

		return nil
	end
end

do
	local v65 = type
	local v66 = pcall
	local v67 = error
	local n24 = select
	local v68 = rawget
	local v69 = rawset
	local v70 = setmetatable
	local flag = v65(v66) ~= "function"
	local flag2

	if flag then
		flag2 = flag
	else
		flag2 = v65(v67) ~= "function"
	end

	flag2 = flag2 or v65(n24) ~= "function" or v65(v68) ~= "function" or v65(v69) ~= "function" or v65(v70) ~= "function" or v65(string) ~= "table"

	if not flag2 then
		v65(string.char)
		v64[255] = 72
	end

	if flag2 or v65(string.byte) ~= "function" or v65(string.sub) ~= "function" then
		error("devirt: symbolic value store into proto array (at 98:3077)")
	end

	local function fn16(arg, arg2)
		return arg and arg2 or 0
	end

	local v71, v72, v73, v74, v75 = v66(function(...)
		return n24("#", ...), ...
	end, 17, nil, 29)

	local n25 = fn16(v71 == true, 1) + fn16(v72 == 3, 2) + fn16(v73 == 17, 4) + fn16(v74 == nil, 8) + fn16(v75 == 29, 16)
	local tbl5 = {}

	local v76, v77 = v66(function()
		v67(nil, 0)
	end)

	n24 = 65
	n24 = 65
end

n22(nil, v63)
str(nil, nil)
error("devirt: corrupt/encrypted register index 10050 (at 98:17)")
