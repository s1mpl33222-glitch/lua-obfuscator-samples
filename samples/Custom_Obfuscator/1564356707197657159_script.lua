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

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime7(...)
	error("Luraph runtime function, not devirtualized")
end

-- Luraph runtime function (from the VM object, not part of the script: not lifted).
-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.
local function luraph_runtime8(...)
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
local v6, v7

do
	local v8 = nil
	local v9 = nil
	local v10 = nil
	v6 = nil
	local v11 = nil
	v7 = nil
	local v12 = nil
	local v13 = nil
	local v14 = v8
end

local fn
fn = v6
local fn2
fn2 = nil
local fn3
fn3 = v7
local v8
v8 = task
local cancel
cancel = v8.cancel
local defer
defer = v8.defer
local delay
delay = v8.delay
local wait
wait = v8.wait
local v9, v10, v11, v12, fn4, fn5, v13, info, traceback, n
local fn6, fn7, tbl2, fn8, fn9, fn10, new, new2, color, rect
local udim2, udim, new3, v14, v15

do
	local v16 = Instance
	v9 = Vector3
	local v17 = Vector2
	v10 = CFrame
	v11 = Random
	v12 = loadstring
	local tbl3 = { 22, 134, 153, 86, 58, 79, 164, 179, 210, 242, 225, 88 }
	local n2 = 12
	local tbl4 = { 9, 130, 68, 147, 197, 11, 189, 106, 241, 114, 228, 36 }
	local n3 = 12
	local n4 = 11489
	local tbl5 = {}
	local n5 = 0
	local v18 = bit32.bor(nil, nil)

	fn4 = function(arg, arg2)
		n5 += 1
		tbl5[n5] = arg2 % 256
	end

	fn5 = function(arg, arg2)
		local tbl6 = { 0, nil, arg2 + 0, nil, nil }

		while true do
			local v19 = tbl6[4]
			local v20 = tbl6[3]
			local n6 = tbl6[1] + v19
			local flag = v19 <= 0
			local flag2 = n6 >= v20
			local flag3 = n6 <= v20

			if flag then
				if nil then
					flag2 = flag2 or flag3
				else
					flag3 = nil
					flag2 = flag2 or flag3
				end
			else
				flag2 = flag

				if nil then
					flag2 = flag2 or flag3
				else
					flag2 = flag2 or nil
				end
			end

			tbl6[1] = n6

			if flag2 then
				local n7 = arg % 256
				arg = (arg - n7) / 256
				n5 += 1
				tbl5[n5] = n7
				continue
			end

			break
		end
	end

	local function fn11()
		error("devirt: arith on 1006146038 b'cancel' (at 2:401)")
	end

	local function fn12(arg)
		local v19 = fn11
		local v20 = bit32.bxor(arg, 62774433)
		local v21, v22 = v19(v20)
		error("devirt: len of 4050335859 (at 2:331)")
	end

	v13 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
	info = v13.info
	traceback = v13.traceback
	n = 141021549

	fn6 = function()
		(0.62103612728155055)({})(18584632, nil, nil, nil, nil, nil)
		local n6 = 57706230
		local n7 = 830476

		while true do
			n6 += n7
		end
	end

	fn7 = function()
		fn5(516790211, 4)
		n = 370097668
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
		local v19 = tbl6[arg2]
		tbl6[arg] = nil
		return v19
	end

	fn9 = function(arg, arg2)
		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v19 = arg2
		local kind = type(nil)
		fn8("table", kind)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v20 = getmetatable(nil)
		fn8(nil, v20)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		pcall(setmetatable, nil, nil)
	end

	fn10 = function(arg, arg2, ...)
		local n6 = 3
		local n7 = nil
		local value = nil
		local v19

		while true do
			local n8, v20, n9, flag, flag2, flag3

			if n6 <= 2 then
				arg = bit32.bxor(arg, 486759923)
				n6 = 1
			elseif n6 <= 3 then
				v19 = table.pack(string.byte(nil, 1, -1))
				value = select("#", table.unpack(t43_25_1, 1, t43_25_1.n))
				n6 = bit32.bxor(arg2, 211392639) == 234334363 and 5
				arg = 2166136261
				n7 = 1

				if n6 then
					local exitTo = nil

					while true do
						if n6 <= 4 then
							exitTo = 1
							break
						else
							local exitTo2 = nil

							while true do
								if n6 <= 6 then
									if not (n6 <= 5) then
										arg = bit32.bxor(2166136261, v19[n7])

										if arg < 134217728 then
											exitTo2 = 2
											break
										else
											n6 = 7
											continue
										end
									end

									break
								elseif n6 <= 7 then
									n8 = arg % 65536
									arg = (((arg - n8) / 65536 * 403 + nil) * 65536 + n8 * 403) % 4294967296
									n6 = 9
								elseif n6 <= 8 then
									exitTo2 = 1
									break
								else
									v20 = (nil)[3]
									n9 = (nil)[2] + nil
									flag = not nil
									flag2 = n9 >= v20
									flag3 = n9 <= v20

									if nil then
										if flag then
											flag2 = flag2 or flag3
										else
											flag3 = flag
											flag2 = flag2 or flag3
										end
									else
										flag2 = nil

										if flag then
											flag2 = flag2 or flag3
										else
											flag3 = flag
											flag2 = flag2 or flag3
										end
									end
									;(nil)[2] = n9

									if flag2 then
										n6 = 6
										n7 = n9
									else
										n6 = 8
									end
								end
							end

							if exitTo2 == 1 then
								exitTo = 2
								break
							elseif exitTo2 == 2 then
								n6 = 4
								continue
							end

							break
						end
					end

					if exitTo == 1 then
						if not (n6 <= 1) then
							continue
						end
					elseif exitTo == 2 then
						n6 = 2
						continue
					else
						arg2 = bit32.bxor(arg2, 3040269015)
						n6 = 0
					end
				else
					n6 = 0
				end
			else
				arg = arg * 16777619 % 4294967296
				n6 = 9
				local exitTo3 = nil

				while true do
					if n6 <= 6 then
						if n6 <= 5 then
							exitTo3 = 2
							break
						else
							arg = bit32.bxor(2166136261, v19[n7])

							if arg < 134217728 then
								n6 = 4
								if not (n6 <= 4) then
									continue
								end
							else
								n6 = 7
								continue
							end
						end

						break
					elseif n6 <= 7 then
						n8 = arg % 65536
						arg = (((arg - n8) / 65536 * 403 + nil) * 65536 + n8 * 403) % 4294967296
						n6 = 9
					elseif n6 <= 8 then
						exitTo3 = 1
						break
					else
						v20 = (nil)[3]
						n9 = (nil)[2] + nil
						flag = not nil
						flag2 = n9 >= v20
						flag3 = n9 <= v20

						if nil then
							if flag then
								flag2 = flag2 or flag3
							else
								flag3 = flag
								flag2 = flag2 or flag3
							end
						else
							flag2 = nil

							if flag then
								flag2 = flag2 or flag3
							else
								flag3 = flag
								flag2 = flag2 or flag3
							end
						end
						;(nil)[2] = n9

						if flag2 then
							n6 = 6
							n7 = n9
						else
							n6 = 8
						end
					end
				end

				if exitTo3 == 1 then
					n6 = 2
					continue
				elseif exitTo3 == 2 then
					arg2 = bit32.bxor(arg2, 3040269015)
					n6 = 0
				elseif not (n6 <= 1) then
					continue
				end
			end

			local exitTo5 = nil

			while n6 <= 0 do
				n6 = 9
				local exitTo4 = nil

				while true do
					if n6 <= 6 then
						if n6 <= 5 then
							exitTo4 = 1
							break
						else
							arg = bit32.bxor(2166136261, v19[n7])

							if arg < 134217728 then
								n6 = 4
								if n6 <= 4 then
									exitTo4 = 2
									break
								end
							else
								n6 = 7
							end
						end
					else
						if n6 <= 7 then
							n8 = arg % 65536
							arg = (((arg - n8) / 65536 * 403 + nil) * 65536 + n8 * 403) % 4294967296
							n6 = 9
							continue
						elseif not (n6 <= 8) then
							v20 = (nil)[3]
							n9 = (nil)[2] + nil
							flag = not nil
							flag2 = n9 >= v20
							flag3 = n9 <= v20

							if nil then
								if flag then
									flag2 = flag2 or flag3
								else
									flag3 = flag
									flag2 = flag2 or flag3
								end
							else
								flag2 = nil

								if flag then
									flag2 = flag2 or flag3
								else
									flag3 = flag
									flag2 = flag2 or flag3
								end
							end
							;(nil)[2] = n9

							if flag2 then
								n6 = 6
								n7 = n9
							else
								n6 = 8
							end

							continue
						end

						break
					end
				end

				if exitTo4 == 1 then
					arg2 = bit32.bxor(arg2, 3040269015)
					n6 = 0
				elseif exitTo4 == 2 then
					if not (n6 <= 1) then
						exitTo5 = 2
						break
					end
				else
					exitTo5 = 1
					break
				end
			end

			if exitTo5 == 1 then
				n6 = 2
				continue
			end

			if exitTo5 == 2 then
				continue
			end
			break
		end

		return arg
	end

	local function fn13(arg, arg2)
		local v19 = table.pack(X_1())

		if v19[1] then
			local v20 = v19[2]

			while true do
				arg2[fn10(v20, 90204344)] = nil
				local v21 = table.pack(X_1())

				if v21[1] then
					v20 = v21[2]
				else
					break
				end
			end
		end

		local v20 = table.pack(X_1())

		if v20[1] then
			repeat
				fn5(516790211, 4)
				n = 370097668
				fn6()
				local v21 = table.pack(X_1())
			until not v21[1]
		end
	end

	local new4 = v16.new
	new = v9.new
	new2 = v17.new
	color = Color3.new
	rect = Rect.new
	udim2 = UDim2.new
	udim = UDim.new
	new3 = Path2DControlPoint.new
	v14 = fn13
	v15 = new4
end

local fn11

fn11 = function()
end

fn11(getmetatable, "getmetatable")
fn11(setmetatable, "setmetatable")
fn11(tonumber, "tonumber")
fn11(tostring, "tostring")
fn11(rawset, "rawset")
fn11(rawget, "rawget")
fn11(select, "select")
fn11(xpcall, "xpcall")
fn11(assert, "assert")
fn11(error, "error")
fn11(pcall, "pcall")
fn11(type, "type")
fn11(next, "next")
fn11(getfenv, "getfenv")
fn11(setfenv, "setfenv")
fn11(typeof, "typeof")
fn11(string.gmatch, "gmatch")
fn11(string.format, "format")
fn11(string.match, "match")
fn11(string.find, "find")
fn11(string.char, "char")
fn11(string.byte, "byte")
fn11(string.gsub, "gsub")
fn11(string.sub, "sub")
fn11(string.rep, "rep")
fn11(string.unpack, "unpack")
fn11(string.pack, "pack")
fn11(table.concat, "concat")
fn11(table.insert, "insert")
fn11(table.pack, "pack")
fn11(table.clear, "clear")
fn11(table.create, "create")
fn11(table.move, "move")
fn11(bit32.bor, "bor")
fn11(bit32.bnot, "bnot")
fn11(bit32.bxor, "bxor")
fn11(bit32.band, "band")
fn11(bit32.lshift, "lshift")
fn11(bit32.rshift, "rshift")
fn11(bit32.rrotate, "rrotate")
fn11(bit32.lrotate, "lrotate")
fn11(bit32.countlz, "countlz")
fn11(bit32.countrz, "countrz")
fn11(buffer.len, "len")
fn11(buffer.fill, "fill")
fn11(buffer.copy, "copy")
fn11(buffer.create, "create")
fn11(buffer.tostring, "tostring")
fn11(buffer.fromstring, "fromstring")
fn11(buffer.readstring, "readstring")
fn11(buffer.writestring, "writestring")
fn11(buffer.readi8, "readi8")
fn11(buffer.readu8, "readu8")
fn11(buffer.readi16, "readi16")
fn11(buffer.readu16, "readu16")
fn11(buffer.readi32, "readi32")
fn11(buffer.readu32, "readu32")
fn11(buffer.readf32, "readf32")
fn11(buffer.readf64, "readf64")
fn11(buffer.writei8, "writei8")
local v16

do
	local n2 = 3938119333
	fn11(buffer.writeu8, "writeu8")
	fn11(buffer.writei16, "writei16")
	fn11(buffer.writeu16, "writeu16")
	fn11(buffer.writei32, "writei32")
	fn11(buffer.writeu32, "writeu32")
	fn11(buffer.writef32, "writef32")
	fn11(buffer.writef64, "writef64")
	fn11(buffer.readbits, "readbits")
	fn11(buffer.writebits, "writebits")
	fn11(coroutine.isyieldable, "isyieldable")
	fn11(coroutine.running, "running")
	fn11(coroutine.create, "create")
	fn11(coroutine.status, "status")
	fn11(coroutine.yield, "yield")
	fn11(coroutine.close, "close")
	fn11(coroutine.resume, "resume")
	fn11(coroutine.wrap, "wrap")
	fn11(cancel, "cancel")
	fn11(nil, "spawn")
	fn11(defer, "defer")
	fn11(delay, "delay")
	fn11(wait, "wait")
	fn11(unpack, "unpack")
	fn11(info, "info")
	fn11(traceback, "traceback")
	fn11(v12)
	local v17 = pcall
	local v18 = xpcall
	local n3 = 171950077
	local n4 = 225197154
	new2(0.88307239682405925, 0.83391893173901488, 0.18482920384141022)
	local n5 = 3674447470 + n2
	v15("Folder")
	local ScreenGui = v15("ScreenGui")
	local Frame = v15("Frame")
	local Path2D = v15("Path2D")
	Frame.Parent = ScreenGui
	Path2D.Parent = Frame
	vector.create(0.031512247850395303, 0.010623769030785546, 0.13242166131697619)

	local function fn12()
		assert(0.22661757611205247)
		getfenv(0)
		select("#", 0.62103612728155055, 0.8748979828368294, nil)
		tonumber(0.21124638311683641)
		tostring(0.04369315112715777)
		rawequal(scratch, scratch)
		local tbl3 = {}
		next(tbl3)
		pairs(tbl3)(tbl3)
		ipairs(tbl3)(tbl3, 1)
		rawlen(tbl3)
		rawget(tbl3, 0.47865798911565605)
		rawset(tbl3, 0.049970340727729323, 0.67091362323638992)
		getmetatable(tbl3)
		setmetatable(tbl3, tbl3)
		setmetatable(tbl3, nil)
		info(7768, "slnaf")
		bit32.bor(226, 241)
		bit32.bxor(221, 250)
		bit32.band(47, 73)
		bit32.bnot(131)
		bit32.lshift(122, 29)
		bit32.rshift(8, 30)
		bit32.lrotate(154, 17)
		bit32.rrotate(213, 4)
		bit32.countlz(136)
		bit32.countrz(130)
		local v19 = buffer.create(253)
		buffer.len(v19)
		buffer.fromstring("")
		buffer.tostring(v19)
		buffer.readi8(v19, 0)
		buffer.readu8(v19, 3)
		buffer.readi16(v19, 28)
		buffer.readu16(v19, 24)
		buffer.readi32(v19, 8)
		buffer.readu32(v19, 25)
		buffer.readf32(v19, 9)
		buffer.readf64(v19, 5)
		buffer.writei8(v19, 18, -35)
		buffer.writeu8(v19, 20, 254)
		buffer.writei16(v19, 27, -18849)
		buffer.writeu16(v19, 6, 59456)
		buffer.writei32(v19, 13, -2044141196)
		buffer.writeu32(v19, 31, 554294769)
		buffer.writef32(v19, 23, 40846)
		buffer.writef64(v19, 8, 2038)
		buffer.readstring(v19, 22, 15)
		buffer.writestring(v19, 10, "Luraph", nil)
		buffer.readbits(v19, 0, 8)
		buffer.writebits(v19, 254, 24, nil)
		buffer.copy(v19, 32, v19, nil, 16)
		buffer.fill(v19, 23, 18, nil)
		local v20 = v11.new()
		v20:NextInteger(53, 783)
		v20:NextNumber(2, 455)
		v20:NextUnitVector()
		v20:NextNumber()
		v20:Shuffle({})
		v20:Clone()
		local n6 = Vector3.new(0.45981297, 0.5872136, 0.27837753) + Vector3.new(0.251452, 0.93230563, 0.36058414)
		local vector_ = Vector3.new(0.45981297, 0.5872136, 0.27837753)
		local vector_2 = Vector3.new(0.251452, 0.93230563, 0.36058414)
		local vector_3 = Vector3.new(1, 0, 0)
		local vector_4 = Vector3.new(0, 1, 0)
		local v21 = v10.new()
		local v22 = v10.new(vector_)
		v10.Angles(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		local xyz = Enum.RotationOrder.XYZ
		v10.new(vector_, n6)
		v10.new(vector_.X, vector_.Y, vector_.Z)
		v10.new(vector_.X, vector_.Y, vector_.Z, nil, 0, 0, 1)
		v10.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		v10.lookAt(vector_, n6, vector_4)
		v10.lookAlong(vector_, vector_2, vector_4)
		v10.fromEulerAnglesXYZ(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		v10.fromEulerAnglesYXZ(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		v10.fromOrientation(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		v10.fromAxisAngle(vector_2.Unit, 0.73986244466993689)
		v10.fromRotationBetweenVectors(vector_3, vector_4)
		v10.fromMatrix(vector_, vector_3, vector_4, nil)
		v10.fromEulerAngles(0.73986244466993689, 0.85316156646654251, 0.87696966979795465, xyz)
		v21:Inverse()
		v21:Orthonormalize()
		v21:Lerp(v22, 0.23665736167110585)
		v21:ToWorldSpace(v22)
		v21:ToObjectSpace(v22)
		v21:ToEulerAnglesXYZ()
		v21:ToEulerAnglesYXZ()
		v21:PointToWorldSpace(vector_)
		v21:PointToObjectSpace(vector_)
		v21:VectorToWorldSpace(vector_2)
		v21:VectorToObjectSpace(vector_2)
		v21:ToEulerAngles(xyz)
		v21:GetComponents()
		v21:ToOrientation()
		v21:ToAxisAngle()
		v21:FuzzyEq(v22)
		v21:AngleBetween(v22)
		local vector2 = Vector2.new(0.7330474853515625, 0.32350265979766846)
		v9[3705461980](getfenv()[4205642688].Height[Vector2.new(0.24917356669902802, 0.36479973793029785)])
		v9.FromNormalId(Enum.NormalId.Top)
		vector2:Abs()
		vector2:Ceil()
		vector2[4503599627370496](vector2)
		vector2[0.73986244466993689](vector2)
		vector2[2334562472](vector2, -12929)
		vector2:VectorToObjectSpace(-12929)
		vector2:a(-12929)
		vector2:FuzzyEq(-12929)
		vector2:Lerp(-12929, 0.32307142238851816)
		vector2:Max(-12929)

		vector2:Min(-12929)
		;(3089122515):Abs()
		;(3089122515):Ceil()
		;(3089122515):Floor()
		;(3089122515):Sign()
		;(3089122515):Dot(Vector2.new(0.24917356669902802, 0.36479973793029785))
		;(3089122515):Cross(Vector2.new(0.24917356669902802, 0.36479973793029785))
		;(3089122515):Angle(Vector2.new(0.24917356669902802, 0.36479973793029785))
		;(3089122515):FuzzyEq(Vector2.new(0.24917356669902802, 0.36479973793029785))
		;(3089122515):Lerp(Vector2.new(0.24917356669902802, 0.36479973793029785), 0.013755792357021179)
		;(3089122515):Max(Vector2.new(0.24917356669902802, 0.36479973793029785))
		;(3089122515):Min(Vector2.new(0.24917356669902802, 0.36479973793029785))
		local v23 = udim(-0.28961272499673085, -101)
		local vectorToObjectSpace = udim(2271343899, "VectorToObjectSpace")
		local v24 = udim2(0.40279592168922695, 30, 0.027911671322964571, nil)
		local v25 = udim2(1537587520, "bnot", nil, -57)
		v24:Random(nil, 1260681229)
		local v26 = Connected[0.049970340727729323][760836158]
		local enumType = v26.EnumType
		enumType:GetEnumItems()
		enumType:FromName(nil)
		enumType:FromValue(v26.Value)
		local v27 = udim2(0.098509781579168787, 55, 0.031670061753425516, nil)
		local v28 = udim2(0.052936903663483595, 27, 0.057530603923173579, nil)
		local v29 = udim2(0.81866120387608943, 183, 0.88036767751928591, nil)
		local v30 = new3(v27, v28, nil)
		new3((nil)(v27, v29, 0.2735179418044324))
		local tbl4 = {}
		local v31 = new3(v29)
		tbl4[1] = v30
		tbl4[2] = v31
		local v32 = (nil)(94, 243, 787198)
		utf8.codepoint(v32, 1, #v32)
		utf8.len(v32)
		utf8.offset(v32, 2)
		utf8.offset(v32, -1)
		local v33, v34, v35 = utf8.codes(v32)
		v33(v34, v35)
		v33(v34, utf8.offset(v32, nil))
		local v36 = utf8.char(103, 781)
		utf8.nfcnormalize(v36)

		utf8.nfdnormalize(v32)
		;(nil)(v36, 1, #v36)()
		n4 = (1 * n4 + 107127056) % 268435456
		n3 = (554543 * n3 + 100956475) % 268435456
	end

	local v19 = coroutine.wrap(fn12)
	local tbl3 = {}
	local n6 = 0

	local function fn13()
		local v20 = nil
		local v21 = nil
		n6 += 1
		n4 = (1 * n4 + 167802274) % 268435456
		n3 = (19147 * n3 + 205975699) % 268435456
	end

	setmetatable(tbl3, { __index = fn13, __newindex = fn13 })
	local ok, result = pcall(fn13)

	if tbl2[not ok] then
		fn4(89910952, 224)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if tbl2[not result] then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
		fn4(n5 + 1067278741, 20)
	end

	local v20 = luraph_runtime1(table.pack(n3, n4))
	local n7 = 3964775743
	local flag = false
	local v21 = luraph_runtime3(table.pack(v17, r202))

	local function fn14()
		n3 = (64997 * n3 + 128908409) % 268435456
		n4 = (1 * n4 + 148727674) % 268435456
	end

	local v22 = luraph_runtime4(table.pack(n4, n3))

	local function fn15()
		n4 = n4 - n4 % 2 + 1
		n3 = (106509 * n3 + 32567065) % 268435456
	end

	local n8 = 0

	fn = function()
		n8 += 1
		n4 = (1 * n4 + 263528866) % 268435456
		n3 = (463885 * n3 + 68598787) % 268435456
		fn()
	end

	fn2 = function()
		if nil ~= 19998 then
			if nil ~= 19997 then
				if nil == 12489 then
					fn12(nil)
				end
			else
				fn12(nil)
			end

			fn2(nil + 1)

			if nil == 19997 then
				if not v18(v20, v22) then
					n4 = n4 - n4 % 2 + 1
					n3 = (319649 * n3 + 6778439) % 268435456
					n3 = (782809 * n3 + 42633669) % 268435456
					return
				end

				fn14()

				if not v17(v20) then
					n4 = n4 - n4 % 2 + 1
					n3 = (579155 * n3 + 199364699) % 268435456
					n3 = (436983 * n3 + 79624157) % 268435456
					return
				end

				if v18(fn15, fn) then
					n4 = n4 - n4 % 2 + 1
					n3 = (796941 * n3 + 157906563) % 268435456
					n3 = (136709 * n3 + 69791527) % 268435456
					return
				end

				v21()

				if flag then
					n4 = n4 - n4 % 2 + 1
					n3 = (947163 * n3 + 266513883) % 268435456
					n3 = (556423 * n3 + 100417589) % 268435456
					return
				end

				n4 = (1 * n4 + 84722464) % 268435456
				n3 = (763785 * n3 + 206239753) % 268435456
			end

			n3 = (503865 * n3 + 39697565) % 268435456
			n4 = (1 * n4 + 189390882) % 268435456
			return
		end

		v20()
		n3 = (132491 * n3 + 197116007) % 268435456
		n4 = (1 * n4 + 216702064) % 268435456
	end

	local n9 = n2 - n7
	coroutine.resume(coroutine.create(fn2), 1)
	ScreenGui:Destroy()
	fn5(n3, 4)
	fn5(n4, 4)
	v16 = n
	local n10 = 657508163
	local n11 = 1917412735

	local v23 = coroutine.wrap(function()
		coroutine.yield(n10)
		coroutine.yield(n11)
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end)

	if fn8(v23(), n10) then
		fn4(n9 - 4178399934, 5)
		n = v16
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(v23(), n11) then
		fn4(89910952, 170)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local thread = coroutine.create(wait)
	coroutine.resume(thread, 0)
	local v24 = coroutine.status(thread)
	fn8("suspended", v24)

	if not nil then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	pcall(coroutine.close, thread)
	local v25 = nil

	local flag2 = false
	;(nil)(function()
		v25 = coroutine.running()
		wait(0)
		flag2 = true
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end)

	if flag2 then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
	end

	local flag3 = not pcall(coroutine.close, v25)

	if not nil then
		fn5(516790211, 4)
		n = 370097668
		fn6()
		n5 = 3317599507
	end
end

do
	local close = coroutine.close

	local v17 = (nil)(function()
		coroutine.yield()
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end)

	close(v17)
end

do
	local close = coroutine.close
	local v17 = defer(fn7)
	close(v17)
end

do
	local close = coroutine.close
	local v17 = delay(162, fn7)
	close(v17)
end

local fn12

fn12 = function()
end

fn12(getfenv, -12929)
fn12(setfenv, -7935)
fn12(getmetatable)
fn12(setmetatable)
fn12(tonumber)
fn12(tostring)
fn12(rawset)
fn12(rawget)
fn12(assert)
fn12(type)
fn12(next)
fn12(typeof)
fn12(string.gmatch)
fn12(string.format)
fn12(string.match)
fn12(string.find)
fn12(string.byte)
fn12(string.gsub)
fn12(string.sub)
fn12(string.rep)
fn12(string.char, nil)
fn12(string.unpack)
fn12(string.pack)
fn12(table.concat)
fn12(table.insert)
fn12(table.clear)
fn12(table.create, nil)
fn12(table.move)
fn12(bit32.bor, nil)
fn12(bit32.bxor, nil)
fn12(bit32.band, nil)
fn12(bit32.bnot)
fn12(bit32.lshift)
fn12(bit32.rshift)
fn12(bit32.rrotate)
fn12(bit32.lrotate)
fn12(bit32.countlz)
fn12(bit32.countrz)
fn12(buffer.len)
fn12(buffer.fill)
fn12(buffer.copy)
fn12(buffer.create, nil)
fn12(buffer.tostring)
fn12(buffer.fromstring)
fn12(buffer.readstring)
fn12(buffer.writestring)
fn12(buffer.readi8)
fn12(buffer.readu8)
fn12(buffer.readi16)
fn12(buffer.readu16)
fn12(buffer.readi32)
fn12(buffer.readu32)
fn12(buffer.readf32)
fn12(buffer.readf64)
local n2
n2 = 586109
fn12(buffer.writei8)
fn12(buffer.writeu8)
fn12(buffer.writei16)
fn12(buffer.writeu16)
local n3

do
	local n4 = 3964775743
	fn12(buffer.writei32)
	fn12(buffer.writeu32)
	fn12(buffer.writef32)
	fn12(buffer.writef64)
	fn12(buffer.readbits)
	fn12(buffer.writebits)
	fn12(coroutine.create)
	fn12(coroutine.status)
	fn12(coroutine.close)
	fn12(coroutine.resume)
	fn12(coroutine.wrap)
	fn12(cancel)
	fn12(nil)
	fn12(defer)
	fn12(delay)
	fn12(wait, {})
	fn12(unpack)
	fn12(info)
	local n5 = 977367788
	fn12(v12)
	fn11(v15, "new")
	fn12(v15, nil)
	fn11(new, "new")
	fn11(new2, "new")
	fn11(color, "new")
	fn11(rect, "new")
	local fromAxis = v9.FromAxis
	fn11(fromAxis, "FromAxis")
	fn12(fromAxis, nil)
	local v17 = fromAxis(Enum.Axis.X)
	v9.FromNormalId(Enum.NormalId.Front)
	local kind = type(v17)
	local kind2 = type(nil)
	fn4(89910952, kind == "vector" and 224 or 71)
	local n6 = kind2 == "vector" and 214

	if not n6 then
		local v18 = table.pack(bit32.band(n2, 4294967295))
		local v19 = table.pack(bit32.band(n4, 4294967295))
		local v20 = table.pack(bit32.band(v18[1], 65535))
		local v21 = table.pack(bit32.rshift(v18[1], 16))
		local v22 = table.pack(bit32.band(v19[1], 65535))
		bit32.band(v20[1] * v22[1] + bit32.lshift(bit32.band(v20[1] * bit32.rshift(v19[1], 16) + v21[1] * v22[1], 65535), 16), 4294967295)
		n6 = 178
	end

	fn4(n2 + 89324843, n6)
	local z = (nil).Z
	fn5(v17.X * 2843165867, 4)
	fn5(z * -1 * 2483251228, 4)

	if fn8("vector", kind) then
		fn4(89910952, 210)
		n = v16
	else
		fn5("DescendantAdded", "NextUnitVector")
		n = 370097668
		fn6()
	end

	if fn8("vector", kind2) then
		fn4(n5 + 3407510460, 131)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	fn4(n2 - 4205642453, v17.X == 1 and 243 or 95)
	fn4(89910952, v17.Y == 0 and 50 or 41)
	n3 = n5 // n4
	fn4(n3 - 4205056344, v17.Z == 0 and 179 or 208)
end

fn4(n2 + 89324843, (nil).X == 0 and 24 or 249)
fn4(89910952, (nil).Y == 0 and 93 or 251)
fn4(n3 - 4205056344, (nil).Z == -1 and 145 or 8)
fn11(udim2, "new")
fn11(udim, "new")
v14(utf8, { [4118642461] = 2093180025, [2670385370] = 697921387, [7537390] = 1219009668 }, 513374487)
local tbl3
tbl3 = { utf8.nfcnormalize("퀂쟛뭪뼨둘"):byte(1, -1) }

do
	local values = table.pack(utf8.nfdnormalize("쿓쌖젎삁ẫ뿞씑"):byte(1, -1))
	table.move(values, 1, values.n, 1, nil)
end

local v17, v18, v19, v20, n4
local v21 = tbl3[10]
fn4(89910952, v21)
fn4(89910952, (nil)[20])
v17 = (nil)[39]
fn4(n3 - 4205056344, v17)
v18 = (nil)[50]
fn4(n2 - 4205642453, v18)
fn4(89910952, (nil)[56])
fn4(89910952, (nil)[2])
fn4(n2 - 4205642453, (nil)[47])
fn4(89910952, tbl3[3])
v19 = (nil)[46]
fn4(n3 + 89910952, v19)
v20 = (nil)[38]
n4 = n2 + v21
fn4(n4 - 4205642688, v20)
fn4(89910952, (nil)[5])
local v22, v23, v24, v25
local v26 = (nil)[36]
fn4(n3 + 89910952, v26)
v22 = (nil)[21]
fn4(89910952, v22)
v23 = (nil)[30]
fn4(89910952, v23)
fn4(n3 + 89910952, (nil)[1])
v24 = tbl3[7]
v25 = v26
fn4(n4 + 89324608, v24)
fn4(89910952, (nil)[23])
fn4(89910952, (nil)[49])
fn4(n4 + 89324608, (nil)[42])
fn4(89910952, tbl3[13])
local v27
v27 = (nil)[6]
fn4(n3 + 89910952, v27)
fn4(n4 + 89324608, tbl3[12])
local v28
v28 = (nil)[28]
fn4(89910952, v28)
local v29
v29 = (nil)[58]
fn4(n3 - 4205056344, v29)
local v30
v30 = (nil)[53]
fn4(n4 + 89324608, v30)
local v31, v32, v33, v34, v35, v36, v37, v38, v39

do
	local v40 = (nil)[43]
	fn4(89910952, v40)
	fn4(n3 + 89910952, (nil)[37])
	v31 = (nil)[4]
	fn4(n4 + 89324608, v31)
	local n5 = n3 * v17
	local v41 = v40
	fn4(89910952, (nil)[12])
	v32 = (nil)[15]
	fn4(89910952, v32)
	fn4(n4 + 89324608, (nil)[24])
	v33 = (nil)[25]
	fn4(89910952, v33)
	v34 = (nil)[8]
	fn4(n5 + 89910952, v34)
	local v42 = (nil)[57]
	fn4(n4 + 89324608, v42)
	v35 = (nil)[52]
	fn4(89910952, v35)
	fn4(n5 + 89910952, tbl3[6])
	v36 = (nil)[34]
	local n6 = n5 + v18
	local v43 = v42
	fn4(n4 + 89324608, v36)
	local v44 = (nil)[18]
	fn4(89910952, v44)
	v37 = (nil)[31]
	fn4(n6 + 89910767, v37)
	v38 = tbl3[4]
	fn4(n4 - 4205642688, v38)
	fn4(89910952, (nil)[10])
	local v45 = (nil)[44]
	v39 = v44
	fn4(89910952, v45)
	local v46 = (nil)[26]
	fn4(89910952, v46)
	fn4(89910952, tbl3[11])
	fn4(89910952, (nil)[14])
	fn4(89910952, tbl3[2])
	local v47 = v45
	local v48 = v46
end

fn4(89910952, tbl3[15])
fn4(89910952, (nil)[40])
fn4(89910952, tbl3[1])
fn4(89910952, (nil)[17])
fn4(89910952, (nil)[45])
fn4(89910952, (nil)[22])
fn4(89910952, (nil)[51])
fn4(89910952, (nil)[35])

do
	local v40 = (nil)[19]
	fn4(89910952, v40)
	fn4(89910952, (nil)[55])
	fn4(89910952, (nil)[33])
	local v41 = v40
end

fn4(89910952, (nil)[27])
fn4(89910952, (nil)[32])
fn4(89910952, (nil)[29])
fn4(89910952, (nil)[3])
fn4(89910952, (nil)[7])
fn4(89910952, (nil)[54])
fn4(89910952, tbl3[9])
fn4(89910952, (nil)[11])

do
	local v40 = tbl3[8]
	fn4(89910952, v40)
	fn4(89910952, (nil)[16])
	fn4(89910952, (nil)[9])
	fn4(89910952, tbl3[14])
	local v41 = v40
end

fn4(89910952, (nil)[41])
fn4(89910952, (nil)[48])
fn4(89910952, tbl3[5])
fn4(89910952, (nil)[13])
fn4(89910952, (nil)[59])
fn11(new3, "new")
fn12(new3, nil)
local ScreenGui
ScreenGui = v15("ScreenGui")
v15("Frame")
local n5

n5 = 586476 // v19
;(nil).Position = udim2(0, 0, 0, 0)
;(nil).Size = udim2(0, 169, 0, 249)
;(nil).Parent = ScreenGui
v15("Path2D").Parent = nil

do
	local setControlPoints = (nil).SetControlPoints
	local tbl4 = {}
	local v40 = new3(udim2(0.0625, -10, 0.375, -7), udim2(0, 0, 0, 0), udim2(0, 0, 0, 0))
	local v41 = new3(udim2(0.25, 8, 0, 7), udim2(0, -6, 0.125, -7), udim2(0.125, 4, 0, 2))
	local v42 = new3(udim2(0.25, 8, 0.0625, -1), udim2(0, 1, -0.125, 1), udim2(0, 7, 0, -3))
	local v43 = new3(udim2(0, 5, 0, -3), udim2(0, -2, 0, -2), udim2(0, 2, 0, -5))
	local v44 = udim2(0.5, 5, 0, 4)
	local v45 = udim2(0, -1, 0, -7)
	tbl4[1] = v40
	tbl4[2] = v41
	tbl4[3] = v42
	tbl4[4] = v43

	do
		local values = table.pack(new3(v44, v45, udim2(0, 1, 0.0625, 7)))
		table.move(values, 1, values.n, 5, tbl4)
	end

	setControlPoints(nil, tbl4)
end

do
	local length = (nil):GetLength()
	local unpack_ = string.unpack
	local pack = string.pack
	bit32.band(length - length % 1, 536870911)
	fn5(unpack_(">I4", pack(">f", length)), 4)
end

do
	local positionOnCurve = (nil):GetPositionOnCurve(0.625)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	fn5(unpack_("<I4", pack("<f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_2("<I4", pack2(">f", scale2)), 4)
end

do
	local positionOnCurve = (nil):GetPositionOnCurve(0.60000002384185791)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	fn5(unpack_(">I4", pack("<f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_2("<I4", pack2(">f", scale2)), 4)
end

local v40

do
	local positionOnCurve = (nil):GetPositionOnCurve(0.57142859697341919)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	v40 = v20
	fn5(unpack_(">I4", pack(">f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_2("<I4", pack2(">f", scale2)), 4)
end

do
	local tangentOnCurve = (nil):GetTangentOnCurve(0.83333331346511841)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurve.X
	bit32.band(x - x % 1, 536870911)
	fn5(unpack_(">I4", pack(">f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurve.Y
	bit32.band(y - y % 1, 536870911)
	fn5(unpack_2("<I4", pack2("<f", y)), 4)
end

do
	local tangentOnCurve = (nil):GetTangentOnCurve(0.3333333432674408)
	local unpack_ = string.unpack
	local v41 = bit32.band(n5, v25)
	local pack = string.pack
	local x = tangentOnCurve.X
	bit32.band(x - x % 1, 536870911)
	fn5(unpack_("<I4", pack("<f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurve.Y
	bit32.band(y - y % 1, 536870911)
	fn5(unpack_2("<I4", pack2(">f", y)), 4)
	local tangentOnCurve2 = (nil):GetTangentOnCurve(0.83333331346511841)
	local unpack_3 = string.unpack
	local pack3 = string.pack
	local x2 = tangentOnCurve2.X
	bit32.band(x2 - x2 % 1, 536870911)
	fn5(unpack_3("<I4", pack3(">f", x2)), 4)
	local unpack_4 = string.unpack
	local pack4 = string.pack
	local y2 = tangentOnCurve2.Y
	bit32.band(y2 - y2 % 1, 536870911)
	fn5(unpack_4("<I4", pack4("<f", y2)), 4)
	local positionOnCurveArcLength = (nil):GetPositionOnCurveArcLength(0.4444444477558136)
	local unpack_5 = string.unpack
	local pack5 = string.pack
	local scale = positionOnCurveArcLength.X.Scale
	bit32.band(scale - scale % 1, 536870911)
	fn5(unpack_5(">I4", pack5("<f", scale)), 4)
	local unpack_6 = string.unpack
	local pack6 = string.pack
	local scale2 = positionOnCurveArcLength.Y.Scale
	bit32.band(scale2 - scale2 % 1, 536870911)
	fn5(unpack_6(">I4", pack6(">f", scale2)), 4)
	local positionOnCurveArcLength2 = (nil):GetPositionOnCurveArcLength(0.91666668653488159)
	local unpack_7 = string.unpack
	local pack7 = string.pack
	local scale3 = positionOnCurveArcLength2.X.Scale
	bit32.band(scale3 - scale3 % 1, 536870911)
	fn5(unpack_7("<I4", pack7(">f", scale3)), 4)
	local unpack_8 = string.unpack
	local pack8 = string.pack
	local scale4 = positionOnCurveArcLength2.Y.Scale
	bit32.band(scale4 - scale4 % 1, 536870911)
	local v42 = table.pack(pack8("<f", scale4))
	local v43 = bit32.band(v41, v23)
	fn5(unpack_8("<I4", table.unpack(v42, 1, v42.n)), 4)
end

do
	local tangentOnCurveArcLength = (nil):GetTangentOnCurveArcLength(0.3333333432674408)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurveArcLength.X
	bit32.band(x - x % 1, 536870911)
	fn5(unpack_("<I4", pack("<f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurveArcLength.Y
	bit32.band(y - y % 1, 536870911)
	fn5(unpack_2("<I4", pack2("<f", y)), 4)
end

do
	local tangentOnCurveArcLength = (nil):GetTangentOnCurveArcLength(0.80000001192092896)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurveArcLength.X
	bit32.band(x - x % 1, 536870911)
	fn5(unpack_("<I4", pack("<f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurveArcLength.Y
	bit32.band(y - y % 1, 536870911)
	fn5(unpack_2("<I4", pack2(">f", y)), 4)
end

do
	local tangentOnCurveArcLength = (nil):GetTangentOnCurveArcLength(0.625)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurveArcLength.X
	bit32.band(x - x % 1, 536870911)
	fn5(unpack_("<I4", pack("<f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurveArcLength.Y
	bit32.band(y - y % 1, 536870911)
	fn5(unpack_2(">I4", pack2(">f", y)), 4)
end

ScreenGui:Destroy()
v14(math, { [991019141] = 2041238798, [1001344043] = 718722207, [2897255833] = 2062142320 }, 513374487)
local v41, n6

do
	local n7 = (v40 + v22) * v24

	v14(v13, {
		[2292321952] = 484363059,
		[375521735] = 2121496753,
		[582928667] = 1264688714,
		[2106541464] = 913111771,
		[2301669812] = 2129081054,
	}, 513374487)

	v14(v8, { [3530269659] = 1949659591, [1663316942] = 1993772279 }, 513374487)
	local v42 = game
	local v43 = workspace

	local function fn13(arg, arg2, arg3)
		local state = 1
		local n8, v44, v45, parent, parent2, name, name2, v46, descendantAdded, n9, connect, fn14, n10, n11, n12, v47, flag, flag2

		while true do
			if state == 1 then
				n8 = arg
				v44 = arg2
				v45 = arg3
				local v48 = nil
				state = 2
			elseif state == 2 then
				local kind = type(v44)
				;(nil)("userdata", kind)

				if nil then
					state = 3
				else
					state = 55
				end
			elseif state == 3 then
				local kind = typeof(v44)
				;(nil)("Instance", kind)

				if nil then
					state = 4
				else
					state = 56
				end
			elseif state == 4 then
				parent = v44.Parent
				parent2 = v44.Parent

				if tbl2[nil] then
					state = 5
				else
					state = 8
				end
			elseif state == 5 then
				name = parent
				name2 = parent2
				state = 6
			elseif state == 6 then
				fn8(name, name2)

				if nil then
					state = 7
				else
					state = 103
				end
			elseif state == 7 then
				if n8 == 524153637 then
					state = 8
				else
					state = 17
				end
			elseif state == 8 then
				name = v44.Name
				name2 = v44.Name

				local kind = type(name)
				;(nil)("string", kind)

				if nil then
					state = 9
				else
					state = 76
				end
			elseif state == 9 then
				fn8(name, name2)

				if nil then
					state = 10
				else
					state = 102
				end
			elseif state == 10 then
				(nil)(#name, #name2)

				if nil then
					state = 11
				else
					state = 68
				end
			elseif state == 11 then
				(nil)(tostring(v44), name)

				if nil then
					state = 12
				else
					state = 63
				end
			elseif state == 12 then
				v46 = fn8
				;(nil)(v45, v44.ClassName)

				if nil then
					state = 14
				else
					state = 13
				end
			elseif state == 13 then
				v45 = v46
				state = 75
			elseif state == 14 then
				v45 = v46
				state = 15
			elseif state == 15 then
				descendantAdded = v44.DescendantAdded
				n8 = 500841503
				state = 16
			elseif state == 16 then
				name = v44.DescendantAdded
				;(nil)(descendantAdded, name)

				if nil then
					state = 17
				else
					state = 18
				end
			elseif state == 17 then
				fn5(516790211, 4)
				n = 370097668
				local v48 = fn6
				local v49 = table.pack(bit32.band(n9, 4294967295))
				local v50 = table.pack(bit32.band(n8, 4294967295))
				local v51 = table.pack(bit32.band(v49[1], 65535))
				local v52 = table.pack(bit32.rshift(v49[1], 16))
				local v53 = table.pack(bit32.band(v50[1], 65535))
				local v54 = bit32.band(v51[1] * v53[1] + bit32.lshift(bit32.band(v51[1] * bit32.rshift(v50[1], 16) + v52[1] * v53[1], 65535), 16), 4294967295)
				v48()
				n9 = v54 - 891281612
				state = 18
			elseif state == 18 then
				if nil then
					state = 19
				else
					state = 94
				end
			elseif state == 19 then
				local connect2 = descendantAdded.Connect
				local connect3 = descendantAdded.Connect
				fn11(connect2, "Connect")

				fn11(connect3, "Connect")
				;(nil)(connect2, connect3)

				if nil then
					state = 20
				else
					state = 21
				end
			elseif state == 20 then
				fn5(516790211, 4)
				n = 370097668
				fn6()
				state = 21
			else
				local flag3, n13

				if state == 21 then
					flag3 = false
					connect = v44.ChildRemoved.Connect
					n13 = 275322324

					fn14 = function()
						flag3 = true
						n13 = 1531801049
					end

					n10 = 163555228
					state = 22
				elseif state == 22 then
					n13 = n10
					name = connect(nil, fn14)

					if nil then
						state = 24
					else
						state = 23
					end
				elseif state == 23 then
					state = 26
				elseif state == 24 then
					state = 25
				elseif state == 25 then
					fn5(516790211, 4)
					n = 370097668
					fn6()
					n11 = n11 + n8 + 3794125793
					state = 26
				elseif state == 26 then
					if nil then
						state = 27
					else
						state = 86
					end
				elseif state == 27 then
					local disconnect = name.Disconnect
					fn11(disconnect, "Disconnect")
					fn12(disconnect, nil)
					disconnect(name)

					if nil then
						state = 28
					else
						state = 29
					end
				elseif state == 28 then
					fn5("__index", nil --[[ constant not decoded ]])
					n = 370097668
					fn6()
					state = 29
				elseif state == 29 then
					local wait2 = descendantAdded.Wait
					fn11(wait2, "Wait")
					name = coroutine.create
					local n14 = n9 - 887623858

					name2 = function()
						return (wait2(descendantAdded))
					end

					n14 = 35919071
					state = 30
				elseif state == 30 then
					name = name(name2)
					n12, name2 = coroutine.resume(name)
					v47 = tbl2

					if n8 + 275593385 ~= 388658377 then
						state = 31
					else
						state = 57
					end
				elseif state == 31 then
					local v48 = v47[not n12]
					flag = not v48

					if v48 then
						state = 33
					else
						state = 32
					end
				elseif state == 32 then
					name2 = flag
					state = 34
				elseif state == 33 then
					name2 = tbl2[not name2]
					state = 34
				elseif state == 34 then
					if name2 then
						state = 35
					else
						state = 99
					end
				elseif state == 35 then
					if name2 then
						state = 36
					else
						state = 37
					end
				elseif state == 36 then
					local v48 = fn5
					local v49 = table.pack(bit32.band(n11, 4294967295))
					local v50 = table.pack(bit32.band(v49[1], 65535))
					local v51 = bit32.band(v50[1] * 26871 + bit32.lshift(bit32.band(v50[1] * 0 + bit32.rshift(v49[1], 16) * 26871, 65535), 16), 4294967295)
					v48("GetPositionOnCurveArcLength", nil --[[ constant not decoded ]])
					n = 370097668
					fn6()
					n11 = v51 - 2030823670
					state = 37
				elseif state == 37 then
					name2 = table.pack((nil)(coroutine.close, name))[2]
					local v48 = tbl2[not nil]
					flag2 = not v48

					if v48 then
						state = 39
					else
						state = 38
					end
				elseif state == 38 then
					name2 = flag2
					state = 40
				elseif state == 39 then
					name2 = not tbl2[not name2]
					state = 40
				elseif state == 40 then
					if name2 then
						state = 42
					else
						state = 41
					end
				elseif state == 41 then
					local v48 = coroutine.status(name)
					name2 = not (nil)("dead", v48)
					n8 = 500841503
					state = 42
				elseif state == 42 then
					if name2 then
						state = 43
					else
						state = 44
					end
				elseif state == 43 then
					fn5(516790211, 4)
					n = "IsServer"
					fn6()
					state = 44
				elseif state == 44 then
					local v48 = getmetatable(v44)
					;(nil)("The metatable is locked", v48)

					if nil then
						state = 45
					else
						state = 91
					end
				elseif state == 45 then
					if v45 then
						state = 110
					else
						state = 46
					end
				elseif state == 46 then
					if nil then
						state = 47
					else
						state = 86
					end
				elseif state == 47 then
					if nil <= 22 then
						state = 79
					else
						state = 48
					end
				elseif state == 48 then
					if nil <= 34 then
						state = 64
					else
						state = 49
					end
				elseif state == 49 then
					if nil <= 40 then
						state = 58
					else
						state = 50
					end
				elseif state == 50 then
					if nil <= 43 then
						state = 53
					else
						state = 51
					end
				elseif state == 51 then
					if nil <= 44 then
						state = 45
					else
						state = 52
					end
				elseif state == 52 then
					if nil <= 45 then
						state = 18
					else
						state = 25
					end
				elseif state == 53 then
					if nil <= 41 then
						state = 56
					else
						state = 54
					end
				elseif state == 54 then
					if nil <= 42 then
						state = 39
					else
						state = 55
					end
				elseif state == 55 then
					fn5(516790211, 4)
					n = 370097668
					fn6()
					state = 3
				elseif state == 56 then
					fn5(516790211, 4)
					n = 370097668
					local v48 = table.pack(bit32.band(n11, 4294967295))
					local v49 = table.pack(bit32.band(n8, 4294967295))
					local v50 = table.pack(bit32.band(v48[1], 65535))
					local v51 = table.pack(bit32.rshift(v48[1], 16))
					local v52 = table.pack(bit32.band(v49[1], 65535))
					local v53 = bit32.band(v50[1] * v52[1] + bit32.lshift(bit32.band(v50[1] * bit32.rshift(v49[1], 16) + v51[1] * v52[1], 65535), 16), 4294967295)
					fn6()
					n12 = v53 + 2554662108
					state = 57
				elseif state == 57 then
					n11 = n12
					state = 4
				elseif state == 58 then
					if nil <= 37 then
						state = 61
					else
						state = 59
					end
				elseif state == 59 then
					if nil <= 38 then
						state = 19
					else
						state = 60
					end
				elseif state == 60 then
					if nil <= 39 then
						state = 110
					else
						state = 10
					end
				elseif state == 61 then
					if nil <= 35 then
						state = 30
					else
						state = 62
					end
				elseif state == 62 then
					if nil <= 36 then
						state = 63
					else
						state = 27
					end
				elseif state == 63 then
					fn5(516790211, 4)
					n = 370097668
					fn6()
					n9 = n9 - n8 - 3770813659
					state = 12
				elseif state == 64 then
					if nil <= 28 then
						state = 72
					else
						state = 65
					end
				elseif state == 65 then
					if nil <= 31 then
						state = 70
					else
						state = 66
					end
				elseif state == 66 then
					if nil <= 32 then
						state = 69
					else
						state = 67
					end
				elseif state == 67 then
					if nil <= 33 then
						state = 68
					else
						state = 7
					end
				elseif state == 68 then
					fn5(516790211, 4)
					n = "IsServer"
					fn6()
					state = 11
				elseif state == 69 then
					local wait2 = descendantAdded.Wait
					fn11(wait2, "Wait")
					name = coroutine.create
					local n14 = n9 - 887623858

					name2 = function()
						return (wait2(descendantAdded))
					end

					n14 = 35919071
					state = 30
				elseif state == 70 then
					if nil <= 29 then
						state = 33
					else
						state = 71
					end
				elseif state == 71 then
					if nil <= 30 then
						state = 37
					else
						state = 2
					end
				elseif state == 72 then
					if nil <= 25 then
						state = 77
					else
						state = 73
					end
				elseif state == 73 then
					if nil <= 26 then
						state = 76
					else
						state = 74
					end
				elseif state == 74 then
					if nil <= 27 then
						state = 75
					else
						state = 34
					end
				elseif state == 75 then
					fn5(-3, "delay")
					n = 2
					fn6()
					state = 15
				elseif state == 76 then
					fn5(516790211, 4)
					n = 370097668
					fn6()
					state = 9
				elseif state == 77 then
					if nil <= 23 then
						state = 9
					else
						state = 78
					end
				elseif state == 78 then
					if nil <= 24 then
						state = 17
					else
						state = 12
					end
				elseif state == 79 then
					if nil <= 10 then
						state = 95
					else
						state = 80
					end
				elseif state == 80 then
					if nil <= 16 then
						state = 88
					else
						state = 81
					end
				elseif state == 81 then
					if nil <= 19 then
						state = 84
					else
						state = 82
					end
				elseif state == 82 then
					if nil <= 20 then
						state = 4
					else
						state = 83
					end
				elseif state == 83 then
					if nil <= 21 then
						state = 8
					else
						state = 3
					end
				elseif state == 84 then
					if nil <= 17 then
						state = 43
					else
						state = 85
					end
				elseif state == 85 then
					if nil <= 18 then
						state = 87
					else
						state = 86
					end
				elseif state == 86 then
					fn5("__index", nil --[[ constant not decoded ]])
					n = 370097668
					fn6()
					state = 27
				elseif state == 87 then
					descendantAdded = v44.DescendantAdded
					n8 = 524153637
					state = 16
				elseif state == 88 then
					if nil <= 13 then
						state = 92
					else
						state = 89
					end
				elseif state == 89 then
					if nil <= 14 then
						state = 11
					else
						state = 90
					end
				elseif state == 90 then
					if nil <= 15 then
						state = 91
					else
						state = 28
					end
				elseif state == 91 then
					fn5("__index", nil --[[ constant not decoded ]])
					n = 370097668
					fn6()
					state = 45
				elseif state == 92 then
					if nil <= 11 then
						state = 94
					else
						state = 93
					end
				elseif state == 93 then
					if nil <= 12 then
						state = 44
					else
						state = 20
					end
				elseif state == 94 then
					fn5(516790211, 4)
					n = 370097668
					fn6()
					state = 19
				elseif state == 95 then
					if nil <= 4 then
						state = 104
					else
						state = 96
					end
				elseif state == 96 then
					if nil <= 7 then
						state = 100
					else
						state = 97
					end
				elseif state == 97 then
					if nil <= 8 then
						state = 40
					else
						state = 98
					end
				elseif state == 98 then
					if nil <= 9 then
						state = 99
					else
						state = 36
					end
				elseif state == 99 then
					local v48 = coroutine.status(name)
					name2 = not (nil)("suspended", v48)
					state = 35
				elseif state == 100 then
					if nil <= 5 then
						state = 103
					else
						state = 101
					end
				elseif state == 101 then
					if nil <= 6 then
						state = 102
					else
						state = 6
					end
				elseif state == 102 then
					fn5(516790211, 4)
					n = 370097668
					fn6()
					state = 10
				elseif state == 103 then
					fn5(516790211, 4)
					n = 370097668
					fn6()
					state = 7
				elseif state == 104 then
					if nil <= 1 then
						state = 107
					else
						state = 105
					end
				elseif state == 105 then
					if nil <= 2 then
						state = 42
					else
						state = 106
					end
				elseif state == 106 then
					if nil <= 3 then
						state = 26
					else
						state = 35
					end
				elseif state == 107 then
					if nil <= 0 then
						state = 109
					else
						state = 108
					end
				elseif state == 108 then
					local v48 = bit32.bxor(n8, 1122488122)
					local v49 = coroutine.status(name)
					name2 = not (nil)("dead", v49)
					n8 = bit32.bxor(v48, 1122488122)
					state = 42
				elseif state == 109 then
					flag3 = false
					connect = v44.ChildRemoved.Connect
					n13 = 275322324

					fn14 = function()
						flag3 = true
						n13 = 1531801049
					end

					local v48 = bit32.bxor(n8, 67931735)
					n10 = bit32.bxor(275322324, v48)
					state = 22
				elseif state == 110 then
					return
				end
			end
		end
	end

	fn13(524153637, v42, "DataModel")
	fn13(524153637, v43, "Workspace")

	if fn8(v42, v43.Parent) then
		fn4(89910952, 73)
		n = v16
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	v15("Folder")
	fn13(524153637, nil, "Folder")
	local ok, result = pcall((nil).ResetPropertyToDefault, Rect.new(-958.8211669921875, 256.6929931640625, -949.08001708984375, 304.24609375), 71235442)
	local flag = not ok

	if not tbl2[flag] then
		fn5(fn10(result, 90204344), 4)
	end

	local v44 = n

	if tbl2[flag] then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
		fn4(89910952, 186)
		n = v44
	end

	local children, v45, v46 = (nil):GetChildren()
	local v47 = table.pack(X_1())

	if v47[1] then
		repeat
			fn5(516790211, 4)
			n = 370097668
			fn6()
			local v48 = table.pack(X_1())
		until not v48[1]
	end
	;(nil):Destroy()
	local v48 = nil
	local Folder = v15("Folder", v48)
	fn13(524153637, Folder, "Folder")

	if fn8(v48, Folder.Parent) then
		fn4(89910952, 55)
		n = nil
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(Folder.Parent, Folder.Parent) then
		fn4(89910952, 83)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local waitForChild = v48.WaitForChild
	fn11(waitForChild, "WaitForChild")
	fn12(waitForChild, nil)
	local name = tostring(11914720)
	Folder.Name = name
	local v49 = waitForChild(v48, name)

	if fn8(Folder, v49) then
		fn4(89910952, 96)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	v48:Destroy()
	Folder:Destroy()

	if tbl2[not Folder.Parent] then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
		fn4(89910952, 195)
	end

	if tbl2[not pcall(function()
		Folder.Parent = v48
	end)] then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
		fn4(89910952, 235)
	end

	n = nil
	v42:GetService("HttpService")
	fn13(524153637, nil, "HttpService")
	local v50 = n
	local v51

	if fn8(v42, (nil).Parent) then
		fn4(89910952, 164)
		n = v50
		v51 = v50
	else
		v51 = v50
		fn5(-1, "suspended")
		n = 370097668
		fn6()
	end

	v42:GetService("RunService")
	fn13(524153637, nil, "RunService")

	if fn8(v42, (nil).Parent) then
		fn4(89910952, 167)
		n = v51
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local n8 = n7 * v27
	fn11((nil).IsStudio, "IsStudio")
	fn11((nil).IsClient, "IsClient")
	fn11((nil).IsServer, "IsServer")
	fn12((nil).IsStudio)
	fn12((nil).IsClient)

	fn12((nil).IsServer)
	;(nil):IsServer()

	if nil then
		local v52 = v42:utf8(0.375)
		fn13(524153637, v52, -6)
		fn8(v42, v52.Z)
		local v53

		if nil then
			v53 = v52
		else
			v53 = v52
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local children2, v54, v55 = v53:GetChildren()
		local n9 = 0
		local v56 = table.pack(X_1())

		if v56[1] then
			repeat
				n9 += 1
				local v57 = table.pack(X_1())
			until not v57[1]
		end

		if nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end
	end

	if tbl2[not pcall(v42.GetChildren)] then
		fn5("create", 4056449317)
		n = 370097668
		fn6()
	else
		fn4(89910952, 180)
		n = v51
	end

	local n9 = n8 // v28
	local v52 = Enum
	local v53 = n

	if fn8(type(v52), "userdata") then
		fn4(89910952, 110)
		n = nil
		v41 = nil
	else
		v41 = v53
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(typeof(v52), "Enums") then
		fn4(89910952, 102)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v54 = getmetatable(v52)

	if fn8("The metatable is locked", v54) then
		fn4(89910952, 211)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local r6 = v52.HumanoidRigType.R6
	local v55 = v29

	if fn8(type(r6), "userdata") then
		fn4(89910952, 171)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(typeof(r6), "EnumItem") then
		fn4(89910952, 79)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v56 = getmetatable(r6)

	if fn8("The metatable is locked", v56) then
		fn4(89910952, 143)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
		local n10 = bit32.band(v55, v30) + 4
	end

	fn11(r6.IsA, "IsA")
	fn12(r6.IsA)
	local value = r6.Value

	if fn8(type(nil), "string") then
		fn4(89910952, 181)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(type(value), "number") then
		fn4(89910952, 153)
	else
		fn5("GetAsync", 9)
		n = 370097668
		fn6()
	end

	local enumType = r6.EnumType

	if fn8(r6, enumType[nil]) then
		fn4(89910952, 174)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(type(enumType), "userdata") then
		fn4(89910952, 171)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
		n9 = -4294905140
	end

	if fn8(typeof(enumType), "Enum") then
		fn4(89910952, 70)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v57 = getmetatable(enumType)

	if fn8("The metatable is locked", v57) then
		fn4(89910952, 160)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	fn11(enumType.FromName, "FromName")
	fn11(enumType.FromValue, "FromValue")
	fn12(enumType.FromName)
	fn12(enumType.FromValue)
	local v58 = enumType:FromName(nil)

	if fn8(r6, v58) then
		fn4(89910952, 11)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v59 = enumType:FromValue(value)
	n6 = n9 - v31

	if fn8(r6, v59) then
		fn4(89910952, 68)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end
end

local n7, n8, tbl4, tbl5, v42

do
	local new4 = v11.new
	fn11(new4, "new")
	fn12(new4, {})
	new4(1339925708)

	if fn8(type(nil), "userdata") then
		fn4(89910952, 24)
		n = v41
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v43 = v32

	if fn8(typeof(nil), "Random") then
		fn4(89910952, 165)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	fn11((nil).NextUnitVector, "NextUnitVector")
	fn11((nil).NextInteger, "NextInteger")
	fn11((nil).NextNumber, "NextNumber")
	fn11((nil).Shuffle, "Shuffle")
	fn11((nil).Clone, "Clone")
	local v44 = new4(1965685320)
	local pack = string.pack
	local v45 = v44:NextNumber()
	bit32.band(v45 - v45 % 1, 536870911)
	fn5((nil)(">I4", pack(">f", v45)), 4)
	local unpack_ = string.unpack
	local pack2 = string.pack
	local v46 = v44:NextNumber()
	bit32.band(v46 - v46 % 1, 536870911)
	fn5(unpack_(">I4", pack2("<f", v46)), 4)
	fn5(v44:NextInteger(777, 1620), 4)
	v44:NextInteger(906, 1217)
	fn5(nil, 4)
	fn5(v44:NextInteger(708, 1024), 4)
	fn5(v44:NextInteger(354, 648), 4)
	fn5(v44:NextInteger(32, 815), 4)
	local pack3 = string.pack
	local v47 = v44:NextNumber()
	bit32.band(v47 - v47 % 1, 536870911)
	fn5((nil)("<I4", pack3("<f", v47)), 4)
	fn5(v44:NextInteger(112, 807), 4)
	fn5(v44:NextInteger(362, 1068), 4)
	local pack4 = string.pack
	local v48 = v44:NextNumber()
	bit32.band(v48 - v48 % 1, 536870911)
	fn5((nil)("<I4", pack4("<f", v48)), 4)
	fn5(v44:NextInteger(333, 507), 4)
	local unpack_2 = string.unpack
	local pack5 = string.pack
	local v49 = v44:NextNumber()
	bit32.band(v49 - v49 % 1, 536870911)
	fn5(unpack_2(">I4", pack5("<f", v49)), 4)

	local tbl6 = {
		[2903502143] = 76,
		[158403253] = 304,
		[913754451] = 304,
		[2095656011] = 152,
		[1343581260] = 76,
		[843338931] = 152,
	}

	bit32.bor(v43, v34)
	tbl6[3958773163] = 76
	tbl6[2753695325] = 304
	tbl6[1299111401] = 304
	tbl6[2302524640] = 76
	local n9 = 304
	tbl6[3673322871] = 76
	tbl6[2927273839] = n9
	tbl6[3774221998] = nil
	tbl6[3992347413] = nil
	tbl6[534968755] = n9
	tbl6[4050335859] = n9
	tbl6[4213664805] = nil
	tbl6[1451511250] = n9
	tbl6[4290636774] = n9
	tbl6[1159343961] = n9
	tbl6[4283026575] = n9
	tbl6[2657262125] = n9
	tbl6[2952522137] = n9
	tbl6[495010065] = n9
	tbl6[629660659] = nil
	tbl6[2714684079] = n9
	tbl6[600652] = nil
	tbl6[486127870] = nil
	tbl6[2538992252] = n9
	tbl6[3736489643] = nil
	tbl6[1610005375] = n9
	tbl6[340808879] = n9
	getfenv()
	local tbl7 = {}
	local tbl8 = {}
	n7 = n6 // v33 + v35
	local n10 = 0
	local tbl9 = { 3, v2, nil, 0, 1 }

	while true do
		local v50 = tbl9[5]
		local v51 = tbl9[1]
		local n11 = tbl9[4] + v50
		local flag = v50 <= 0
		local flag2 = not flag
		local flag3 = n11 >= v51
		local flag4 = n11 <= v51

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

		tbl9[4] = n11

		if flag3 then
			type(nil)

			if not nil then
				if not nil then
					tbl7[nil] = true
					local n12 = 0

					for k in nil, nil, nil do
						n12 += 1
						local kind = type(k)

						if fn8("string", kind) then
							if #k < 20 then
								local v52 = fn10(k, 90204344)

								if not tbl8[v52] then
									n10 += tbl6[v52] or 0
									tbl8[v52] = true
									if n12 > 50 then
										break
									end
									continue
								end
							end
						end

						if n12 > 50 then
							break
						end
					end

					local v52 = getmetatable(nil)

					if type(v52) == "table" and rawget(v52, "__index") then
						n10 = 0
					else
						n10 = 0
					end

					continue
				end
			end
		end

		break
	end

	local v50 = tbl9[2]
	fn4(89910952, nil)
	local ok, result = pcall(assert, false)

	if not nil then
		type(result)
	end

	if nil then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local ok2, result2 = pcall(function(r,...)(...)[...]=nil;end)
	local ok3, result3 = pcall(function(r,...)return(...)[...];end)
	local ok4, result4 = pcall(function(r,...)return(...)();end)

	if ok2 or ok3 or ok4 then
		fn5("pack", 0)
		n = 370097668
		fn6()
	end

	local function fn13(arg, arg2, arg3)
		local v51, v52, n11 = string.find(arg, ":[^%a%A]*([0-9][0-9]*)[%:\r\n]")
		local flag = not v51
		local flag2

		if v51 then
			flag2 = not v52
		else
			flag2 = flag
		end

		if flag2 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn5(v51, 2)
		fn5(v52, 2)
		local v53 = string.match(arg, ":([%d]%d*)[\r\n%:][^%u%U]*")
		local v54 = fn5
		local v55

		if n11 then
			v55 = v53
		else
			v55 = v53
			n11 = 0
		end

		v54(n11 + 0, 2)
		fn5((v55 or 0) + 0, 2)
		local v56 = nil
		local v57 = string.gmatch(arg, ":([%d]%d*)[\r%:\n][^%p%P]*")
		local n12 = v57()
		fn8(v57(), nil)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v58 = fn5
		local v59

		if n12 then
			v59 = v58
		else
			v59 = v58
			n12 = 0
		end

		v59(n12 + 0, 2)
		local str = string.sub(arg, v51 + 1, v52 - 1)
		local v60 = string.char(string.byte(arg, v51 + 1, v52 - 1))
		local v61 = string.byte(arg, v51 + 1, v51 + 1)
		local n13 = nil // arg2
		fn5(str + 0, 2)
		fn5(v60 + 0, 2)
		fn4(89910952, v61)
		local tbl10 = { v52 - 1 + 0, v51 + 1 - 1, nil, nil, 1 }
		local n14 = 0
		local v62 = tbl10

		while true do
			local v63 = v62[5]
			local v64 = v62[1]
			local n15 = v62[2] + v63
			local flag3 = v63 <= 0
			v62[2] = n15

			if n15 <= v64 then
				n14 = n14 * 10 + string.byte(arg, n15, n15) - 48
			else
				break
			end
		end

		fn5(n14, 2)
		local v63 = nil
		local n15 = 0
		local n16 = 385921115

		local function fn14(arg4)
			v63 = arg4
			local n17 = n15 + 1
			n16 = 1638659980
			n15 = n17
		end

		n16 = 489340885
		local v64, v65 = string.gsub(arg, "%:([%d]+)[\n\r%:][^%l%L]-", fn14, 1)
		fn8(n15, 1)

		if nil then
		else
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v65, 1)

		if nil then
			fn5((v63 or 0) + 0, 2)
			fn8(string.sub(arg, 2, 2), arg3)

			if not nil then
				fn5(516790211, 4)
				n = 370097668
				fn6()
			end

			local v66 = fn4
			local v67 = string.byte(arg, 2, 2)
			v66(89910952, v67)
			return
		end

		fn5(516790211, 4)
		n = 370097668
		fn6()
		error("devirt: symbolic value store into proto array (at 2:48)")
	end

	n8 = 3964775836
	fn13("main:113: attempt to get length of a thread value", 237948519, "a")
	fn13("tONAUhS:102: attempt to call a userdata value", 237948519, "O")
	fn13("LocalScript:142: attempt to call a userdata value", 237948519, "o")
	fn13("source.lua:49: attempt to perform arithmetic (pow) on userdata and function", 237948519, "o")

	fn3 = function(arg)
		local fn14 = nil
		local v51 = string.match(arg, "[:]([%d]%d*)[\r\n:][^%l%L]?")
		string.gmatch(arg, "[:][^%x%X]*([0-9]+)[%:\r\n]")()
		local v52, v53 = string.find(arg, ":([%d]%d*)[^%l%L]?[\n\r:]")
		local flag = not v52
		local flag2

		if v52 then
			flag2 = not v53
		else
			flag2 = flag
		end

		local n11

		if flag2 then
			fn5(1734829927, 2459269543)
			n = "Connect"
			fn6()
			n11 = 757853714
		end

		local str = string.sub(arg, v52 + 1, v53 - 1)
		local v54 = string.char(string.byte(arg, v52 + 1, v53 - 1))
		local v55 = nil
		local n12 = 0
		local v56 = str
		local n13 = 351780599

		fn14 = function(arg2)
			fn8(info(1, "f"), fn14)

			if not nil then
				fn5("IsA", "len")
				n = "GetService"
				fn6()
			end

			local gsub = string.gsub
			fn8(info(2, "f"), gsub)

			if not nil then
				fn5(0, "nfdnormalize")
				n = 1835697753
				fn6()
			end

			fn8(info(3, "f"), fn3)

			if not nil then
				local v57 = fn5

				upv39.Lerp = nil
				;(nil)(nil, 3909763859)
				v57()
			end

			v55 = arg2
			n12 += 1
		end

		n13 = 519509500
		local v57, v58 = string.gsub(arg, "%:[^%u%U]-([0-9][0-9]*)[^%d%D]-[\n%:\r]", fn14, 1)
		fn8(n12, 1)

		if nil then
		else
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v59 = fn8
		fn8(v58, 1)
		local v60

		if nil then
			v60 = v59
		else
			v60 = v59
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local flag3 = not v51
		local flag4

		if v51 then
			flag4 = not nil
		else
			flag4 = flag3
		end

		if flag4 or not v56 or not v54 or not v55 then
			local v61

			repeat
				fn5(0, "__index")
				n = 3909763991
				v61 = fn6
			until v60

			v61()
		end

		local n14 = v51 + 0
		local n15 = nil + 0
		local v61 = bit32.bor(nil, n11)
		local n16 = v56 + 0
		local n17 = v54 + 0
		local n18 = v55 + 0
		fn8(v51, nil)
		local v62

		if nil then
			v62 = n15
		else
			v62 = n15
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(nil, v56)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v56, v54)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v54, v55)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(n14, v62)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v62, n16)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(n16, n17)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			local v63 = fn6
			local v64 = bit32.band(n11, 2130105607)
			v63()
		end

		fn8(n17, n18)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		return n14
	end

	local v51 = fn3(nil)
	fn3(result3)
	local v52 = fn3(result4)

	if fn8(v51, nil) then
		fn4(89910952, 204)
		n = v41
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(nil, v52) then
		fn4(89910952, 42)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(v52, v51) then
		fn4(89910952, 1)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	for _, v53 in {}, nil, nil do
		local exitTo = nil

		while true do
			local kind = type(v53)

			if fn8("function", kind) then
				info(v53, "sl")
				local v54 = table.pack(X_1())
				if v54[1] then
					v53 = v54[3]
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

	fn9(nil --[[ the caller's registers ]], 104473966)
	setmetatable(nil --[[ the caller's registers ]], nil)
	local n11 = v36 // v39
	tbl4 = {}
	tbl5 = {}
	local n12 = 153
	local tbl10 = { 255, -1, 1, nil, v50 }
	local v53 = tbl10[3]
	local v54 = tbl10[1]
	local n13 = tbl10[2] + v53
	local flag = v53 <= 0
	tbl10[2] = n13
	local v55 = n13
	local n14 = n12 * v55 + 133

	while true do
		local n15 = n14 % 256
		local n16 = (n12 * n15 + nil) % 256
		local n17 = (n12 * n16 + nil) % 256
		local n18 = (n12 * n17 + nil) % 256
		tbl4[v55] = n15 + n16 * 256 + n17 * 65536 + n18 * 16777216
		tbl5[v55] = n18
		local v56 = tbl10[3]
		local v57 = tbl10[1]
		local n19 = tbl10[2] + v56
		local flag2 = v56 <= 0
		local flag3 = not flag2
		local flag4 = n19 >= v57
		local flag5 = n19 <= v57

		if flag2 then
			if flag3 then
				flag4 = flag4 or flag5
			else
				flag5 = flag3
				flag4 = flag4 or flag5
			end
		else
			flag4 = flag2

			if flag3 then
				flag4 = flag4 or flag5
			else
				flag4 = flag4 or flag3
			end
		end

		tbl10[2] = n19

		if flag4 then
			v55 = n19
			n14 = n12 * v55 + nil
			continue
		end

		break
	end

	v42 = tbl10[5]
end

local v43
v43 = buffer.create(16)
luraph_runtime5(table.pack(tbl4, tbl5))
local fn13

fn13 = function(arg, arg2)
	local n9 = nil
	local n10 = bit32.bxor(nil --[[ constant not decoded ]], "defer")
	local tbl6 = {}
	local n11 = buffer.readu8(arg, arg2)
	local n12, n13

	if nil then
		n12 = arg2 + 1
	else
		local v44 = buffer.readu8(arg, arg2 + 1)

		if nil then
			n11 = (n11 - 128) * 128 + v44
			n12 = arg2 + 2
			n10 = n10 + 533925696 - 533925696
		else
			local v45 = buffer.readu8(arg, arg2 + 2)

			if nil then
				n11 = n11 - 128 + (v44 - 128) * 128 + v45 * 16384
				n12 = arg2 + 3
				n13 = 994720206
			else
				local n14 = (n11 - 128) * 16384 + v44 - 128 + (v45 - 128) * 128
				local v46 = buffer.readu8(arg, arg2 + 3)
				n11 = n14 + v46 % 128 * 2097152 + (v46 - v46 % 128) * 2097152
				n12 = arg2 + 4
			end
		end
	end

	local v44 = buffer.readu8(arg, n12)
	local n14 = n12 + 1
	local v45 = n13
	tbl6[7] = v44 ~= 0
	local n15 = buffer.readu8(arg, n14)
	local n16, tbl7, v46, v47, v48, v49

	if nil then
		n14 += 1
		n16 = n15 - 1211
		n15 = table.create(n16)
		tbl6[5] = n15
		tbl7 = { nil, n16 + 0, 690563369.0625, -690563368.0625, nil }
	else
		v46 = buffer.readu8(arg, n14 + 1)

		if nil then
			n15 = (n15 - 128) * 128 + v46

			if bit32.bxor(n10, 489326781) ~= 281747087 then
				n14 += 2
				n16 = n15 - 1211
				n15 = table.create(n16)
				tbl6[5] = n15
				tbl7 = { nil, n16 + 0, 690563369.0625, -690563368.0625, nil }
			else
				v47 = buffer.readu8(arg, n14 + 1)

				if nil then
					n9 = (n9 - 128) * 128 + v47
					n14 += 2
				else
					v48 = buffer.readu8(arg, n14 + 2)

					if nil then
						n9 = n9 - 128 + (v47 - 128) * 128 + v48 * 16384
						n14 += 3
					else
						v49 = buffer.readu8(arg, n14 + 3)
						n9 = (n9 - 128) * 16384 + v47 - 128 + (v48 - 128) * 128 + v49 % 128 * 2097152 + (v49 - v49 % 128) * 2097152
						n14 += 4
					end
				end

				n15[v46] = n9
			end
		else
			local v50 = buffer.readu8(arg, n14 + 2)
			local n17 = n10 + v45

			if not nil then
				buffer.readu8(arg, n14 + 3)
				error("devirt: symbolic value store into proto array (at 2:1124)")
			end

			n15 = n15 - 128 + (v46 - 128) * 128 + v50 * 16384
			n14 += 3
			n10 = n17 + "__newindex"
			n16 = n15 - 1211
			n15 = table.create(n16)
			tbl6[5] = n15
			tbl7 = { nil, n16 + 0, 690563369.0625, -690563368.0625, nil }
		end
	end

	while true do
		local v50 = tbl7[3]
		local v51 = tbl7[2]
		local n17 = tbl7[4] + v50
		local flag = v50 <= 0
		local flag2 = not flag
		local flag3 = n17 >= v51
		local flag4 = n17 <= v51

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

		tbl7[4] = n17

		if flag3 then
			v46 = n17
			n9 = buffer.readu8(arg, n14)

			if nil then
				n14 += 1
			else
				v47 = buffer.readu8(arg, n14 + 1)

				if nil then
					n9 = (n9 - 128) * 128 + v47
					n14 += 2
				else
					v48 = buffer.readu8(arg, n14 + 2)

					if nil then
						n9 = n9 - 128 + (v47 - 128) * 128 + v48 * 16384
						n14 += 3
					else
						v49 = buffer.readu8(arg, n14 + 3)
						n9 = (n9 - 128) * 16384 + v47 - 128 + (v48 - 128) * 128 + v49 % 128 * 2097152 + (v49 - v49 % 128) * 2097152
						n14 += 4
					end
				end
			end

			n15[v46] = n9
			continue
		end

		break
	end

	local v50 = buffer.readu8(arg, n14)

	if nil then
		local n17 = 4
		local n18 = n14 + 1
		local v51 = buffer.create(v50)
		buffer.copy(v51, 0, arg, n18, v50)
		tbl6[n17] = v51
		return (luraph_runtime8(tbl6, n11, 162))
	end

	local readu8 = buffer.readu8
	local v51 = bit32.rshift(n13, 19)
	local v52 = readu8(arg, n14 + 1)
	local n17 = n10 + v45

	if not nil then
		local readu82 = buffer.readu8
		local n18 = bit32.bor(v45, v51)
		local v53 = readu82(arg, n14 + 2)

		if not nil then
			local n19 = (v50 - 128) * 16384 + v52 - 128 + (v53 - 128) * 128
			local n20 = buffer.readu8(arg, n14 + 3)

			while true do
				n20 = n19 + n20 % 128 * 2097152 + (n20 - n20 % 128) * 2097152
				n14 += 4

				n18 = n18 + 250 - 913754451
				;(nil)(nil --[[ constant not decoded ]])
			end
		end
	end

	error("devirt: symbolic value store into proto array (at 2:266)")
end

do
	local n9 = 5
	local n10 = 7
	local n11 = 8
	tbl[n9] = 2
	tbl[n10] = 10
	tbl[n11] = 14
end

tbl[15] = 12

do
	local v44 = bit32.bxor(n8, v37)
	local n9 = n7 + v38
	local n10 = 21
	local n11 = 23
	local n12 = 24
	tbl[n10] = 2
	tbl[n11] = 12
	tbl[n12] = 13
	local n13 = 29
	local n14 = 31
	local n15 = 32
	tbl[n13] = 4
	tbl[n14] = 10
	tbl[n15] = 15
	local v45 = luraph_runtime6(table.pack(v))

	local function fn14(arg, arg2, arg3, arg4)
		local tbl6 = {}
		local v46 = arg
		local v47 = arg2
		local v48 = arg3
		local v49 = arg4
		local n16 = 1

		while true do
			local n17 = (n16 - 1) * 4 + 1
			tbl6[n16 + 4] = v47[n17 + 3] * 16777216 + v47[n17 + 2] * 65536 + v47[n17 + 1] * 256 + v47[n17]

			if A_1 <= 0 then
				if X_1 >= z_1 then
					n16 = X_1
					continue
				end
				break
			else
				if X_1 <= z_1 then
					n16 = X_1
					continue
				end
				break
			end
		end

		local v50, n17

		if A_1 <= 0 then
			if X_1 >= z_1 then
				v50 = X_1

				while true do
					n17 = (v50 - 1) * 4 + 1
					local n18 = v50 + 13
					tbl6[n18] = v48[n17 + 3] * 16777216 + v48[n17 + 2] * 65536 + v48[n17 + 1] * 256 + v48[n17]

					if A_1 <= 0 then
						if X_1 >= z_1 then
							v50 = X_1
							continue
						end
						break
					else
						if X_1 <= z_1 then
							v50 = X_1
							continue
						end
						break
					end
				end
			end
		elseif X_1 <= z_1 then
			v50 = X_1

			while true do
				n17 = (v50 - 1) * 4 + 1
				tbl6[v50 + 13] = v48[n17 + 3] * 16777216 + v48[n17 + 2] * 65536 + v48[n17 + 1] * 256 + v48[n17]

				if A_1 <= 0 then
					if X_1 >= z_1 then
						v50 = X_1
						continue
					end
					break
				else
					if X_1 <= z_1 then
						v50 = X_1
						continue
					end
					break
				end
			end
		end

		local v51 = v48[13]
		local v52 = buffer.len(v46)
		local v53 = buffer.create(v52)
		local n18 = 0

		for i = 0, v52 - 1, 64 do
			local exitTo = nil

			while true do
				n18 += 1
				local tbl7 = {}
				local n19 = 1

				while true do
					tbl7[n19] = tbl6[n19]

					if A_2 <= 0 then
						if X_2 >= z_2 then
							n19 = X_2
							continue
						end
						break
					else
						if X_2 <= z_2 then
							n19 = X_2
							continue
						end
						break
					end
				end

				v45(tbl7, v51)
				local n20 = i + 64

				if v52 < n20 then
					n20 = v52
				end

				local n21 = n20 - i
				local v54 = bit32.rshift(n21, 2)
				local n22 = v54 - 1
				local n23 = 0
				local v55, n24, v56, writeu32, v57

				if 1 <= 0 then
					if n23 >= n22 then
						v55 = n23

						while true do
							n24 = i + v55 * 4
							v56 = bit32.band(tbl7[v55 + 1] + tbl6[v55 + 1], "lastlinedefined")
							writeu32 = buffer.writeu32
							v57 = bit32.bxor(buffer.readu32(v46, n24), v56)
							writeu32(v53, n24, v57)

							if A_2 <= 0 then
								if X_2 >= z_2 then
									v55 = X_2
									continue
								end
								break
							else
								if X_2 <= z_2 then
									v55 = X_2
									continue
								end
								break
							end
						end
					end
				elseif n23 <= n22 then
					v55 = n23

					while true do
						n24 = i + v55 * 4
						v56 = bit32.band(tbl7[v55 + 1] + tbl6[v55 + 1], "lastlinedefined")
						writeu32 = buffer.writeu32
						v57 = bit32.bxor(buffer.readu32(v46, n24), v56)
						writeu32(v53, n24, v57)

						if A_2 <= 0 then
							if X_2 >= z_2 then
								v55 = X_2
								continue
							end
							break
						else
							if X_2 <= z_2 then
								v55 = X_2
								continue
							end
							break
						end
					end
				end

				local n25 = v54 * 4

				if n25 < n21 then
					local n26 = tbl7[v54 + 1] + tbl6[v54 + 1]
					local n27 = n21 - n25 - 1
					local n28 = 0
					local n29, writeu8, v58, v59, v60

					if 1 <= 0 then
						if n28 >= n27 then
							while true do
								n29 = i + n25 + n28
								writeu8 = buffer.writeu8
								v58 = buffer.readu8(v46, n29)
								v59 = bit32.band(bit32.rshift(n26, n28 * 8), 255)
								v60 = bit32.bxor(v58, v59)
								writeu8(v53, n29, v60)

								if A_2 <= 0 then
									if X_2 >= z_2 then
										n28 = X_2
										continue
									end
									break
								else
									if X_2 <= z_2 then
										n28 = X_2
										continue
									end
									break
								end
							end
						end
					elseif n28 <= n27 then
						while true do
							n29 = i + n25 + n28
							writeu8 = buffer.writeu8
							v58 = buffer.readu8(v46, n29)
							v59 = bit32.band(bit32.rshift(n26, n28 * 8), 255)
							v60 = bit32.bxor(v58, v59)
							writeu8(v53, n29, v60)

							if A_2 <= 0 then
								if X_2 >= z_2 then
									n28 = X_2
									continue
								end
								break
							else
								if X_2 <= z_2 then
									n28 = X_2
									continue
								end
								break
							end
						end
					end

					if A_1 <= 0 then
						if X_1 >= z_1 then
							i = X_1
							continue
						end
					elseif X_1 <= z_1 then
						i = X_1
						continue
					end
				else
					exitTo = 1
					break
				end

				break
			end

			if exitTo == 1 then
				continue
			end
			break
		end

		return (fn13(v53, v49))
	end

	local n16 = n9 - 4205363320

	local function fn15()
		local v46 = nil
		local v47 = nil
		local v48 = nil
		local str = nil

		if nil then
			bit32.bor(nil, n16)
			error("devirt: symbolic value store into proto array (at 169:209)")
		end

		if n16 == 206736773 then
			return nil
		end
		local v49 = nil
		local tbl6, n17

		while true do
			local v50 = tbl6[4]
			local v51 = tbl6[5]
			local n18 = tbl6[3] + v50
			local flag = v50 <= 0
			local flag2 = not flag
			local flag3 = n18 >= v51
			local flag4 = n18 <= v51

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

			tbl6[3] = n18

			if flag3 then
				n17 = (v46 * n17 + v47) % 0.25
				str ..= v48[1 + (n17 - n17 % 268435456) / 268435456 % 16]
				continue
			end

			local v52 = tbl6[1]
			string.byte(str, 1, 64)

			if nil then
				string.byte(v49, 1, 64)
			end

			local v53 = v52[5]
			local v54 = v52[4]
			local n19 = v52[2] + v53
			local flag5 = v53 <= 0
			local flag6 = not flag5
			local flag7 = n19 >= v54
			local flag8 = n19 <= v54

			if flag5 then
				if flag6 then
					flag7 = flag7 or flag8
				else
					flag8 = flag6
					flag7 = flag7 or flag8
				end
			else
				flag7 = flag5

				if flag6 then
					flag7 = flag7 or flag8
				else
					flag7 = flag7 or flag6
				end
			end

			v52[2] = n19

			if flag7 then
				str = "Name"
				tbl6 = { v52, nil, -3999674942, 3999674943, 6081145240 }
				continue
			end

			break
		end

		local tbl7 = {
			[70] = 15,
			[68] = 13,
			[101] = 14,
			[53] = 5,
			[99] = 12,
			[98] = 11,
			[48] = 0,
			[49] = 1,
			[51] = 3,
			[97] = 10,
			[55] = 7,
			[65] = 10,
			[100] = 13,
			[69] = 14,
			[67] = 12,
			[54] = 6,
			[50] = 2,
			[57] = 9,
			[52] = 4,
		}

		bit32.bxor(710872675, nil + n16)
		tbl7[102] = 15
		error("devirt: symbolic value store into proto array (at 169:658)")
	end

	local v46 = bit32.bxor(v44, 3847512819)
	n16 = bit32.bxor(n16, v46)

	local function fn16(arg, arg2, arg3, arg4)
		if nil then
			return (fn14(arg2, arg, nil, arg4))
		end
		return nil
	end

	local function fn17(arg, arg2, arg3, arg4, arg5, arg6)
		if nil then
			error("devirt: arith on 4205642453 b'PostAsync' (at 2:72)")
		end

		return nil
	end
end

if tbl2[false] then
	fn4(89910952, 144)
	n = v41
else
	fn5(516790211, 4)
	n = 370097668
	fn6()
end

local kind = type(table.pack(10697, 1932713301, 3513946746, 2366826352, 286081456, 276024717, 1064402848, 2265685854, 1947228433))

if fn8("table", kind) then
	fn4(89910952, 33)
else
	fn5(516790211, 4)
	n = 370097668
	fn6()
end

if fn8(9, 9) then
	fn4(89910952, 3)
else
	fn5(516790211, 4)
	n = 370097668
	fn6()
end

do
	local tbl6 = { 0, nil, 9, 1, v42 }

	while true do
		local v44 = tbl6[4]
		local v45 = tbl6[3]
		local n9 = tbl6[1] + v44
		local flag = v44 <= 0
		local flag2 = not flag
		local flag3 = n9 >= v45
		local flag4 = n9 <= v45

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

		tbl6[1] = n9

		if flag3 then
			local kind2 = type((table.pack(10697, 1932713301, 3513946746, 2366826352, 286081456, 276024717, 1064402848, 2265685854, 1947228433))[n9])
			fn8("number", kind2)

			if not nil then
				fn5(516790211, 4)
				n = 370097668
				fn6()
			end

			continue
		end

		break
	end

	local tbl7 = { nil, 1, 9, tbl6[5], 0 }

	while true do
		local v44 = tbl7[2]
		local v45 = tbl7[3]
		local n9 = tbl7[5] + v44
		local flag = v44 <= 0
		local flag2 = not flag
		local flag3 = n9 >= v45
		local flag4 = n9 <= v45

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

		tbl7[5] = n9

		if flag3 then
			local v46 = n9
			local v47 = (table.pack(10697, 1932713301, 3513946746, 2366826352, 286081456, 276024717, 1064402848, 2265685854, 1947228433))[v46]
			local n10

			if v46 ~= 1 then
				n10 = v47

				if nil then
					local n11 = n10 % 65536
					n10 = n10 - n11 + n11
				end
			else
				n10 = v47
			end

			fn5(n10, 4)
			continue
		end

		break
	end
end

local function fn14(arg)
	local v44 = arg[6]
	if v44 then
		return v44
	end
	local tbl6 = { __index = nil }
	arg[6] = tbl6
	return tbl6
end

if nil then
	return
end

error("devirt: symbolic value store into proto array (at 126:2610)")
