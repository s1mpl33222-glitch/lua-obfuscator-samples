-- 32e4 deobf | Obfuscator: Luraph v15.1
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
local v7
v7 = nil
local v8 = nil
local v9 = nil
local v10
v10 = nil
local v11
v11 = nil
local v12 = nil
local v13 = v7
local fn
fn = v10
local fn2
fn2 = nil
local fn3
fn3 = v11
local v14
v14 = task
local cancel
cancel = v14.cancel
local spawn
spawn = v14.spawn
local defer
defer = v14.defer
local delay
delay = v14.delay
local wait
wait = v14.wait
local v15, v16, v17, v18, fn4, fn5, v19, info, n, fn6
local fn7, tbl2, v20, fn8, fn9, fn10, new, new2, color, rect
local udim2, udim, new3, v21, v22, fn11, v23

do
	local v24 = Instance
	v15 = Vector3
	local v25 = Vector2
	v16 = CFrame
	v17 = Random
	v18 = loadstring
	local tbl3 = { 22, 134, 153, 86, 58, 79, 164, 179, 210, 242, 225, 88 }
	local n2 = 12
	local tbl4 = { 9, 130, 68, 147, 197, 11, 189, 106, 241, 114, 228, 36 }
	local n3 = 12
	local n4 = 11489
	local tbl5 = {}
	local n5 = 0
	local v26 = bit32.bor(nil, nil)

	fn4 = function(arg, arg2)
		n5 += 1
		tbl5[n5] = arg2 % 256
	end

	fn5 = function(arg, arg2)
		local tbl6 = { 0, nil, arg2 + 0, 1, nil }

		while true do
			local v27 = tbl6[4]
			local v28 = tbl6[3]
			local n6 = tbl6[1] + v27
			local flag = v27 <= 0
			local flag2 = not flag
			local flag3 = n6 >= v28
			local flag4 = n6 <= v28

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

			tbl6[1] = n6

			if flag3 then
				local n7 = arg % 256
				arg = (arg - n7) / 256
				n5 += 1
				tbl5[n5] = n7
				continue
			end

			break
		end
	end

	local function fn12()
		error("devirt: arith on 1006146038 b'cancel' (at 2:401)")
	end

	local function fn13(arg)
		local v27 = fn12
		local v28 = bit32.bxor(arg, 62774433)
		local v29, v30 = v27(v28)
		error("devirt: len of 4050335859 (at 2:331)")
	end

	v19 = assert(debug, "The debug library is required on Luau platforms. Please open a support ticket.")
	info = v19.info
	n = 141021549

	fn6 = function()
		(0.62103612728155055)({})(18584632, nil, nil, {}, {}, {})
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

	tbl2 = {}
	v20 = bit32.bxor(nil, 447181466)
	tbl2[false] = true
	tbl2[true] = false
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
		local v27 = tbl6[arg2]
		tbl6[arg] = nil
		return v27
	end

	fn9 = function(arg, arg2)
		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v27 = arg2
		local kind = type(arg)
		fn8("table", kind)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v28 = getmetatable(arg)
		fn8(nil, v28)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		pcall(setmetatable, arg, nil)
	end

	fn10 = function(arg, arg2, ...)
		local n6 = 3
		local n7 = nil
		local value = nil
		local n8 = nil
		local v27, tbl7

		while true do
			local n9, v28, v29, n10, flag, flag2, flag3, flag4

			if n6 <= 2 then
				arg = bit32.bxor(arg, 486759923)
				n6 = 1
			elseif n6 <= 3 then
				v27 = table.pack(string.byte(arg, 1, -1))
				value = select("#", table.unpack(t43_25_1, 1, t43_25_1.n))
				n6 = bit32.bxor(arg2, 211392639) == 234334363 and 5
				arg = 2166136261
				n7 = 1
				n8 = 1

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
										arg = bit32.bxor(arg, v27[n7])

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
									n9 = arg % 65536
									arg = (((arg - n9) / 65536 * 403 + n9 * 256) * 65536 + n9 * 403) % 4294967296
									n6 = 9
								elseif n6 <= 8 then
									exitTo2 = 1
									break
								else
									v28 = tbl7[1]
									v29 = tbl7[3]
									n10 = tbl7[2] + v28
									flag = v28 <= 0
									flag2 = not flag
									flag3 = n10 >= v29
									flag4 = n10 <= v29

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
											flag4 = flag2
											flag3 = flag3 or flag4
										end
									end

									tbl7[2] = n10

									if flag3 then
										n6 = 6
										n7 = n10
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
						tbl7 = tbl7[4]
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
							arg = bit32.bxor(arg, v27[n7])

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
						n9 = arg % 65536
						arg = (((arg - n9) / 65536 * 403 + n9 * 256) * 65536 + n9 * 403) % 4294967296
						n6 = 9
					elseif n6 <= 8 then
						exitTo3 = 1
						break
					else
						v28 = tbl7[1]
						v29 = tbl7[3]
						n10 = tbl7[2] + v28
						flag = v28 <= 0
						flag2 = not flag
						flag3 = n10 >= v29
						flag4 = n10 <= v29

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
								flag4 = flag2
								flag3 = flag3 or flag4
							end
						end

						tbl7[2] = n10

						if flag3 then
							n6 = 6
							n7 = n10
						else
							n6 = 8
						end
					end
				end

				if exitTo3 == 1 then
					tbl7 = tbl7[4]
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
				local n11 = n8 + 0
				n6 = 9
				tbl7 = { n11, n7 - n11, value + 0, tbl7, nil }
				local exitTo4 = nil

				while true do
					if n6 <= 6 then
						if n6 <= 5 then
							exitTo4 = 1
							break
						else
							arg = bit32.bxor(arg, v27[n7])

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
							n9 = arg % 65536
							arg = (((arg - n9) / 65536 * 403 + n9 * 256) * 65536 + n9 * 403) % 4294967296
							n6 = 9
							continue
						elseif not (n6 <= 8) then
							v28 = tbl7[1]
							v29 = tbl7[3]
							n10 = tbl7[2] + v28
							flag = v28 <= 0
							flag2 = not flag
							flag3 = n10 >= v29
							flag4 = n10 <= v29

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
									flag4 = flag2
									flag3 = flag3 or flag4
								end
							end

							tbl7[2] = n10

							if flag3 then
								n6 = 6
								n7 = n10
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
				tbl7 = tbl7[4]
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

	local function fn14(arg, arg2, arg3)
		local v27 = table.pack(X_1())

		if v27[1] then
			local v28 = v27[2]

			while true do
				local v29 = fn10
				local v30 = bit32.bxor(arg3, 469307823)
				arg2[v29(v28, v30)] = nil
				local v31 = table.pack(X_1())

				if v31[1] then
					v28 = v31[2]
				else
					break
				end
			end
		end

		local v28 = table.pack(X_1())

		if v28[1] then
			repeat
				fn5(516790211, 4)
				n = 370097668
				fn6()
				local v29 = table.pack(X_1())
			until not v29[1]
		end
	end

	local new4 = v24.new
	new = v15.new
	new2 = v25.new
	color = Color3.new
	rect = Rect.new
	udim2 = UDim2.new
	udim = UDim.new
	new3 = Path2DControlPoint.new
	v21 = fn14
	v22 = new4

	fn11 = function()
	end

	fn11(getmetatable, "getmetatable")
	v23 = bit32.bxor(v26, v20)
end

fn11(setmetatable, "setmetatable")
fn11(tonumber, "tonumber")
fn11(tostring, "tostring")
fn11(rawset, "rawset")
fn11(rawget, "rawget")
fn11(select, "select")
fn11(xpcall, "xpcall")
fn11(assert, "assert")
local v24
local v25 = error
v24 = bit32.bxor(427697756, v20)
fn11(v25, "error")
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
local v26

do
	local pack = table.pack
	local v27 = bit32.band(v20, 4103408155)
	fn11(pack, "pack")
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
	local create = buffer.create
	local v28 = table.pack(bit32.band(v23, 4294967295))
	local v29 = table.pack(bit32.band(v27, 4294967295))
	local v30 = table.pack(bit32.band(v28[1], 65535))
	local v31 = table.pack(bit32.rshift(v28[1], 16))
	local v32 = table.pack(bit32.band(v29[1], 65535))
	v26 = bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(v29[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295)
	fn11(create, "create")
end

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
local v27
v27 = v24
fn11(buffer.writeu8, "writeu8")
local v28
v28 = bit32.bxor(v24, 3964775743)
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
fn11(spawn, "spawn")
fn11(defer, "defer")
fn11(delay, "delay")
fn11(wait, "wait")
fn11(unpack, "unpack")
fn11(info, "info")
fn11(nil, "traceback")
fn11(v18)
local n2, v29, n3

do
	local v30 = pcall
	local v31 = xpcall
	local n4 = 171950077
	local n5 = 225197154
	new2(0.88307239682405925, 0.83391893173901488, 0.18482920384141022)
	n2 = v26 + v27
	v22("Folder")
	v22("ScreenGui")
	local Frame = v22("Frame")
	local Path2D = v22("Path2D")
	Frame.Parent = nil
	Path2D.Parent = Frame
	vector.create(0.031512247850395303, 0.010623769030785546, 0.13242166131697619)

	local function fn12()
		assert(0.22661757611205247)
		getfenv(0)
		select("#", 0.62103612728155055, 0.8748979828368294, 0.041017940621545401)
		tonumber(0.21124638311683641)
		tostring(0.04369315112715777)
		rawequal(scratch, scratch)
		local tbl3 = {}
		next(tbl3)

		pairs(tbl3)(tbl3)
		;(nil)(tbl3)(tbl3, 1)
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
		local v32 = buffer.create(253)
		buffer.len(v32)
		buffer.fromstring("")
		buffer.tostring(v32)
		buffer.readi8(v32, 0)
		buffer.readu8(v32, 3)
		buffer.readi16(v32, 28)
		buffer.readu16(v32, 24)
		buffer.readi32(v32, 8)
		buffer.readu32(v32, 25)

		buffer.readf32(v32, 9)
		;(nil)(v32, 5)
		buffer.writei8(v32, 18, -35)
		buffer.writeu8(v32, 20, 254)
		buffer.writei16(v32, 27, -18849)
		buffer.writeu16(v32, 6, 59456)
		buffer.writei32(v32, 13, -2044141196)
		buffer.writeu32(v32, 31, 554294769)

		buffer.writef32(v32, 23, 40846)
		;(nil)(v32, 8, 2038)
		buffer.readstring(v32, 22, 15)
		buffer.writestring(v32, 10, "Luraph", 4)
		buffer.readbits(v32, 0, 8)
		buffer.writebits(v32, 254, 24, 1791431217)
		buffer.copy(v32, 32, v32, 0, 16)
		buffer.fill(v32, 23, 18, 25)
		local v33 = v17.new()
		v33:NextInteger(53, 783)
		v33:NextNumber(2, 455)
		v33:NextUnitVector()
		v33:NextNumber()
		v33:Shuffle({})
		v33:Clone()
		local n6 = Vector3.new(0.45981297, 0.5872136, 0.27837753) + Vector3.new(0.251452, 0.93230563, 0.36058414)
		local vector_ = Vector3.new(0.45981297, 0.5872136, 0.27837753)
		local vector_2 = Vector3.new(1, 0, 0)
		local vector_3 = Vector3.new(0, 1, 0)
		local v34 = v16.new()
		local v35 = v16.new(vector_)
		v16.Angles(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		local xyz = Enum.RotationOrder.XYZ
		v16.new(vector_, n6)
		v16.new(vector_.X, vector_.Y, vector_.Z)
		v16.new(vector_.X, vector_.Y, vector_.Z, 0, 0, 0, 1)
		v16.new(vector_.X, vector_.Y, vector_.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		v16.lookAt(vector_, n6, vector_3)
		v16.lookAlong(vector_, nil, vector_3)
		v16.fromEulerAnglesXYZ(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		v16.fromEulerAnglesYXZ(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		v16.fromOrientation(0.73986244466993689, 0.85316156646654251, 0.87696966979795465)
		v16.fromAxisAngle((nil).Unit, 0.73986244466993689)
		v16.fromRotationBetweenVectors(vector_2, vector_3)
		v16.fromMatrix(vector_, vector_2, vector_3, Vector3.new(0, 0, 1))
		v16.fromEulerAngles(0.73986244466993689, 0.85316156646654251, 0.87696966979795465, xyz)
		v34:Inverse()
		v34:Orthonormalize()
		v34:Lerp(v35, 0.23665736167110585)
		v34:ToWorldSpace(v35)
		v34:ToObjectSpace(v35)
		v34:ToEulerAnglesXYZ()
		v34:ToEulerAnglesYXZ()
		v34:PointToWorldSpace(vector_)
		v34:PointToObjectSpace(vector_)
		v34:VectorToWorldSpace(nil)
		v34:VectorToObjectSpace(nil)
		v34:ToEulerAngles(xyz)
		v34:GetComponents()
		v34:ToOrientation()
		v34:ToAxisAngle()
		v34:FuzzyEq(v35)
		v34:AngleBetween(v35)
		local vector_4 = Vector3.new(0.34673735, 0.04355741, 0.16386238)
		v15.FromAxis(Enum.Axis.X)
		v15.FromNormalId(Enum.NormalId.Top)
		vector_4:Abs()
		vector_4:Ceil()
		vector_4:Floor()
		vector_4:Sign()
		vector_4:Dot(nil)
		vector_4:Cross(nil)
		vector_4:Angle(nil)
		vector_4:FuzzyEq(nil)
		vector_4:Lerp(nil, 0.32307142238851816)
		vector_4:Max(nil)
		vector_4:Min(nil)
		local vector2 = Vector2.new(0.7330474853515625, 0.32350265979766846)
		vector2:Abs()
		vector2:Ceil()
		vector2:Floor()
		vector2:Sign()
		vector2:Dot(Vector2.new(0.24917356669902802, 0.36479973793029785))
		vector2:Cross(Vector2.new(0.24917356669902802, 0.36479973793029785))
		vector2:Angle(Vector2.new(0.24917356669902802, 0.36479973793029785))
		vector2:FuzzyEq(Vector2.new(0.24917356669902802, 0.36479973793029785))
		vector2:Lerp(Vector2.new(0.24917356669902802, 0.36479973793029785), 0.013755792357021179)
		vector2:Max(Vector2.new(0.24917356669902802, 0.36479973793029785))
		vector2:Min(nil)
		local v36 = udim(-0.28961272499673085, -101)
		udim(-0.83651887380169776, -84)
		udim2(0.40279592168922695, 30, 0.027911671322964571, 14):Lerp(udim2(0.37246096704242637, -67, 0.039546295853083224, -57), 0.38235753241618098)
		local v37 = Enum.HumanoidDisplayDistanceType[nil]
		local enumType = v37.EnumType
		enumType:GetEnumItems()
		enumType:FromName(v37.Name)
		enumType:FromValue(v37.Value)
		local v38 = udim2(0.098509781579168787, 55, 0.031670061753425516, 14)
		udim2(0.052936903663483595, 27, 0.057530603923173579, 27)
		local v39 = udim2(0.81866120387608943, 183, 0.88036767751928591, 171)
		local v40 = new3(v38, nil, nil)
		new3(v38:Lerp(v39, 0.2735179418044324))
		local tbl4 = {}
		local v41 = new3(v39)
		tbl4[1] = v40
		tbl4[2] = v41
		local v42 = utf8.char(94, 243, 787198)
		utf8.codepoint(v42, 1, #v42)
		utf8.len(v42)
		utf8.offset(v42, 2)
		utf8.offset(v42, -1)
		local v43, v44, v45 = utf8.codes(v42)
		v43(v44, v45)
		v43(v44, utf8.offset(v42, 2))
		utf8.char(103, 781)
		utf8.nfcnormalize(nil)
		utf8.nfdnormalize(v42)
		utf8.graphemes(nil, 1, #nil)()
		n5 = (1 * n5 + 107127056) % 268435456
		n4 = (554543 * n4 + 100956475) % 268435456
	end

	local v32 = coroutine.wrap(fn12)
	local tbl3 = {}
	local n6 = 0

	local function fn13()
		local v33 = nil
		n6 = nil
		n5 = nil
		n4 = nil
	end

	setmetatable(tbl3, { __index = fn13, __newindex = fn13 })
	local ok, result = pcall(fn13)

	if tbl2[not ok] then
		fn4(bit32.bxor(v28, 61910322), 224)
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
		fn4(n2 + 1067278741, 20)
	end

	local v33 = luraph_runtime1(table.pack(n4, n5))
	v29 = bit32.bxor(v28, v27)
	local flag = false
	local v34 = luraph_runtime3(table.pack(v30, v13))

	local function fn14()
		n4 = (64997 * n4 + 128908409) % 268435456
		n5 = (1 * n5 + 148727674) % 268435456
	end

	local v35 = luraph_runtime4(table.pack(n5, n4))

	local function fn15()
		n5 = n5 - n5 % 2 + 1
		n4 = (106509 * n4 + 32567065) % 268435456
	end

	local n7 = 0

	fn = function()
		n7 += 1
		n5 = (1 * n5 + 263528866) % 268435456
		n4 = (463885 * n4 + 68598787) % 268435456
		fn()
	end

	fn2 = function(arg)
		if arg ~= 19998 then
			if arg ~= 19997 then
				if arg == 12489 then
					fn12(arg)
				end
			else
				fn12(arg)
			end

			fn2(arg + 1)

			if arg == 19997 then
				if not v31(v33, v35) then
					n5 = n5 - n5 % 2 + 1
					n4 = (319649 * n4 + 6778439) % 268435456
					n4 = (782809 * n4 + 42633669) % 268435456
					return
				end

				fn14()

				if not v30(v33) then
					n5 = n5 - n5 % 2 + 1
					n4 = (579155 * n4 + 199364699) % 268435456
					n4 = (436983 * n4 + 79624157) % 268435456
					return
				end

				if v31(fn15, fn) then
					n5 = n5 - n5 % 2 + 1
					n4 = (796941 * n4 + 157906563) % 268435456
					n4 = (136709 * n4 + 69791527) % 268435456
					return
				end

				v34()

				if flag then
					n5 = n5 - n5 % 2 + 1
					n4 = (947163 * n4 + 266513883) % 268435456
					n4 = (556423 * n4 + 100417589) % 268435456
					return
				end

				n5 = (1 * n5 + 84722464) % 268435456
				n4 = (763785 * n4 + 206239753) % 268435456
			end

			n4 = (503865 * n4 + 39697565) % 268435456
			n5 = (1 * n5 + 189390882) % 268435456
			return
		end

		v33()
		n4 = (132491 * n4 + 197116007) % 268435456
		n5 = (1 * n5 + 216702064) % 268435456
	end

	n3 = v27 - v29

	coroutine.resume(coroutine.create(fn2), 1)
	;(nil):Destroy()
	fn5(n4, 4)
	fn5(n5, 4)
end

do
	local n4 = 657508163
	local n5 = 1917412735

	local v30 = coroutine.wrap(function()
		coroutine.yield(n4)
		coroutine.yield(n5)
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end)

	if fn8(v30(), n4) then
		fn4(n3 - 4178399934, 5)
		n = nil
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(v30(), n5) then
		fn4(bit32.bxor(v29, 3909763991), 170)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end
end

do
	local thread = coroutine.create(wait)
	coroutine.resume(thread, 0)
	local v30 = coroutine.status(thread)
	fn8("suspended", v30)

	if not nil then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	pcall(coroutine.close, thread)
end

do
	local v30 = nil
	local flag = false

	spawn(function()
		v30 = coroutine.running()
		wait(0)
		flag = true
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end)

	if flag then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
	end

	local flag2 = not pcall(coroutine.close, v30)
end

if not nil then
	local v30 = bit32.bxor(n2, 4294967295)
	fn5(516790211, 4)
	n = 370097668
	fn6()
	n2 = bit32.bxor(v30, 4294967295)
end

do
	local close = coroutine.close

	local v30 = spawn(function()
		coroutine.yield()
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end)

	close(v30)
end

do
	local close = coroutine.close
	local v30 = defer(fn7)
	close(v30)
end

do
	local close = coroutine.close
	local v30 = delay(162, fn7)
	close(v30)
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
local n4, v30

do
	local v31 = bit32.bxor(n3, 4130980822)
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
	local bnot = bit32.bnot
	local v32 = bit32.bxor(v29, n2)
	fn12(bnot)
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
	n4 = v31 // 238
	fn12(buffer.writei8)
	fn12(buffer.writeu8)
	fn12(buffer.writei16)
	fn12(buffer.writeu16)
	local writei32 = buffer.writei32
	v30 = bit32.bxor(v32, n2)
	fn12(writei32)
end

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
fn12(spawn)
fn12(defer)
fn12(delay)
fn12(wait, {})
fn12(unpack)
fn12(info)
local n5

do
	local v31 = bit32.bxor(n2, 4294967295)
	fn12(v18)
	fn11(v22, "new")
	fn12(v22, nil)
	fn11(new, "new")
	fn11(new2, "new")
	fn11(color, "new")
	fn11(rect, "new")
	local fromAxis = v15.FromAxis
	fn11(fromAxis, "FromAxis")
	fn12(fromAxis, nil)
	local v32 = fromAxis(Enum.Axis.X)
	local v33 = v15.FromNormalId(Enum.NormalId.Front)
	local kind = type(v32)
	local kind2 = type(v33)
	local n6 = kind == "vector" and 224 or 71
	fn4(bit32.bxor(v31, 1058708548), n6)
	local n7 = kind2 == "vector" and 214

	if not n7 then
		local v34 = table.pack(bit32.band(n4, 4294967295))
		local v35 = table.pack(bit32.band(v30, 4294967295))
		local v36 = table.pack(bit32.band(v34[1], 65535))
		local v37 = table.pack(bit32.rshift(v34[1], 16))
		local v38 = table.pack(bit32.band(v35[1], 65535))
		n4 = bit32.bxor(bit32.band(v36[1] * v38[1] + bit32.lshift(bit32.band(v36[1] * bit32.rshift(v35[1], 16) + v37[1] * v38[1], 65535), 16), 4294967295), 2985891774)
		n7 = 178
	end

	fn4(n4 + 89324843, n7)
	local z = v33.Z
	fn5(v32.X * 2843165867, 4)
	fn5(z * -1 * 2483251228, 4)

	if fn8("vector", kind) then
		fn4(bit32.bxor(v30, 3909763991), 210)
		n = nil
	else
		fn5("DescendantAdded", "NextUnitVector")
		n = 370097668
		fn6()
	end

	if fn8("vector", kind2) then
		fn4(v31 + 3407510460, 131)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	fn4(n4 - 4205642453, v32.X == 1 and 243 or 95)
	local n8 = v32.Y == 0 and 50 or 41
	fn4(bit32.bxor(v30, 3909763991), n8)
	n5 = v31 // v30
	fn4(n5 - 4205056344, v32.Z == 0 and 179 or 208)
	fn4(n4 + 89324843, v33.X == 0 and 24 or 249)
	local n9 = v33.Y == 0 and 93 or 251
	fn4(bit32.bxor(v30, 3909763991), n9)
	fn4(n5 - 4205056344, v33.Z == -1 and 145 or 8)
end

fn11(udim2, "new")
fn11(udim, "new")
v21(utf8, { [4118642461] = 2093180025, [2670385370] = 697921387, [7537390] = 1219009668 }, 513374487)
local tbl3
tbl3 = { utf8.nfcnormalize("퀂쟛뭪뼨둘"):byte(1, -1) }
local tbl4
tbl4 = { utf8.nfdnormalize("쿓쌖젎삁ẫ뿞씑"):byte(1, -1) }
local v31, v32, v33, v34, v35, v36, v37, n6, v38, v39
local v40, v41, v42, v43, v44

do
	local v45 = tbl3[10]
	bit32.bxor(3789, v45)
	fn4(bit32.bxor(n4, 89333717), v45)
	local v46 = tbl4[20]
	bit32.bxor(3748, v46)
	fn4(bit32.bxor(v30, 3909763991), v46)
	v31 = tbl4[39]
	bit32.bxor(3730, v31)
	fn4(n5 - 4205056344, v31)
	v32 = tbl4[50]
	bit32.bxor(3080, v32)
	fn4(n4 - 4205642453, v32)
	v33 = tbl4[56]
	bit32.bxor(3087, v33)
	fn4(bit32.bxor(v30, 3909763991), v33)
	v34 = tbl4[2]
	bit32.bxor(3143, v34)
	fn4(bit32.bxor(n5, 89910952), v34)
	local v47 = tbl4[47]
	bit32.bxor(3170, v47)
	fn4(n4 - 4205642453, v47)
	v35 = tbl3[3]
	bit32.bxor(119, v35)
	fn4(bit32.bxor(v30, 3909763991), v35)
	v36 = tbl4[46]
	bit32.bxor(107, v36)
	fn4(n5 + 89910952, v36)
	v37 = tbl4[38]
	n6 = n4 + v45
	bit32.bxor(25, v37)
	fn4(n6 - 4205642688, v37)
	v38 = tbl4[5]
	bit32.bxor(90, v38)
	fn4(bit32.bxor(v30, 3909763991), v38)
	local v48 = tbl4[36]
	bit32.bxor(8812, v48)
	fn4(n5 + 89910952, v48)
	v39 = tbl4[21]
	bit32.bxor(8746, v39)
	fn4(bit32.bxor(n6, 89332928), v39)
	v40 = tbl4[30]
	bit32.bxor(8943, v40)
	fn4(bit32.bxor(v30, 3909763991), v40)
	v41 = bit32.bxor(v30, v46)
	v42 = tbl4[1]
	bit32.bxor(8890, v42)
	fn4(n5 + 89910952, v42)
	v43 = tbl3[7]
	v44 = v48
end

bit32.bxor(340, v43)
fn4(n6 + 89324608, v43)
local v45
v45 = tbl4[23]
bit32.bxor(292, v45)
fn4(bit32.bxor(v41, 3909763859), v45)
local v46
v46 = tbl4[49]
bit32.bxor(308, v46)
fn4(bit32.bxor(n5, 89910952), v46)
local v47 = tbl4[42]
bit32.bxor(331, v47)
fn4(n6 + 89324608, v47)
local v48
v48 = tbl3[13]
bit32.bxor(337, v48)
fn4(bit32.bxor(v41, 3909763859), v48)
local v49
v49 = tbl4[6]
bit32.bxor(2898, v49)
fn4(n5 + 89910952, v49)
local v50
v50 = tbl3[12]
bit32.bxor(2886, v50)
fn4(n6 + 89324608, v50)
local v51
v51 = tbl4[28]
bit32.bxor(2819, v51)
fn4(bit32.bxor(v41, 3909763859), v51)
local v52
v52 = tbl4[58]
bit32.bxor(2902, v52)
fn4(n5 - 4205056344, v52)
local v53
v53 = tbl4[53]
bit32.bxor(2929, v53)
fn4(n6 + 89324608, v53)
local v54, v55, v56, v57, v58, v59, v60, v61, v62, v63
local v64, v65, v66, v67, v68

do
	local v69 = tbl4[43]
	bit32.bxor(7771, v69)
	fn4(bit32.bxor(v41, 3909763859), v69)
	v54 = tbl4[37]
	bit32.bxor(7830, v54)
	fn4(n5 + 89910952, v54)
	v55 = tbl4[4]
	bit32.bxor(7689, v55)
	fn4(n6 + 89324608, v55)
	local n7 = n5 * v31
	local v70 = tbl4[12]
	bit32.bxor(8078, v70)
	v56 = v69
	fn4(bit32.bxor(v41, 3909763859), v70)
	v57 = tbl4[15]
	bit32.bxor(6272, v57)
	fn4(bit32.bxor(n7, 89910952), v57)
	v58 = tbl4[24]
	bit32.bxor(6313, v58)
	fn4(n6 + 89324608, v58)
	v59 = tbl4[25]
	bit32.bxor(6310, v59)
	fn4(bit32.bxor(v41, 3909763859), v59)
	v60 = tbl4[8]
	bit32.bxor(6328, v60)
	fn4(n7 + 89910952, v60)
	local v71 = tbl4[57]
	bit32.bxor(5681, v71)
	fn4(n6 + 89324608, v71)
	v61 = tbl4[52]
	bit32.bxor(5689, v61)
	fn4(bit32.bxor(v41, 3909763859), v61)
	v62 = tbl3[6]
	bit32.bxor(5708, v62)
	fn4(n7 + 89910952, v62)
	v63 = tbl4[34]
	local n8 = n7 + v32
	bit32.bxor(5670, v63)
	v64 = v71
	fn4(n6 + 89324608, v63)
	local v72 = tbl4[18]
	bit32.bxor(2112, v72)
	fn4(bit32.bxor(v41, 3909763859), v72)
	v65 = tbl4[31]
	bit32.bxor(2091, v65)
	fn4(n8 + 89910767, v65)
	v66 = tbl3[4]
	v67 = bit32.bxor(v41, v33)
	bit32.bxor(2104, v66)
	fn4(n6 - 4205642688, v66)
	local v73 = tbl4[10]
	bit32.bxor(2049, v73)
	fn4(89910952, v73)
	local v74 = tbl4[44]
	v68 = v72
	bit32.bxor(1216, v74)
	fn4(89910952, v74)
	local v75 = tbl4[26]
	bit32.bxor(790, v75)
	fn4(89910952, v75)
	local v76 = tbl3[11]
	bit32.bxor(828, v76)
	fn4(89910952, v76)
	local v77 = tbl4[14]
	bit32.bxor(776, v77)
	fn4(89910952, v77)
	local v78 = tbl3[2]
	bit32.bxor(810, v78)
	fn4(89910952, v78)
	local v79 = tbl3[15]
	bit32.bxor(825, v79)
	local v80 = v74
	local v81 = v75
	fn4(89910952, v79)
end

local v69 = tbl4[40]
bit32.bxor(629, v69)
fn4(89910952, v69)
local v70 = tbl3[1]
bit32.bxor(582, v70)
fn4(89910952, v70)
local v71 = tbl4[17]
bit32.bxor(566, v71)
fn4(89910952, v71)
local v72 = tbl4[45]
bit32.bxor(637, v72)
fn4(89910952, v72)
local v73 = tbl4[22]
bit32.bxor(583, v73)
fn4(89910952, v73)
local v74 = tbl4[51]
bit32.bxor(576, v74)
fn4(89910952, v74)
local v75 = tbl4[35]
bit32.bxor(635, v75)
fn4(89910952, v75)
local v76

do
	local v77 = tbl4[19]
	bit32.bxor(514, v77)
	fn4(89910952, v77)
	local v78 = tbl4[55]
	bit32.bxor(621, v78)
	fn4(89910952, v78)
	local v79 = tbl4[33]
	bit32.bxor(611, v79)
	fn4(89910952, v79)
	local v80 = tbl4[27]
	bit32.bxor(614, v80)
	v76 = bit32.bxor(n6, v34)
	local v81 = v77
	fn4(89910952, v80)
end

local v77 = tbl4[32]
bit32.bxor(1639, v77)
fn4(89910952, v77)
local v78 = tbl4[29]
bit32.bxor(1645, v78)
fn4(89910952, v78)
local v79 = tbl4[3]
bit32.bxor(1608, v79)
fn4(89910952, v79)
local v80 = tbl4[7]
bit32.bxor(1557, v80)
fn4(89910952, v80)
local v81 = tbl4[54]
bit32.bxor(2020, v81)
fn4(89910952, v81)
local v82 = tbl3[9]
bit32.bxor(1622, v82)
fn4(89910952, v82)
local v83 = tbl4[11]
bit32.bxor(4832, v83)
fn4(89910952, v83)

do
	local v84 = tbl3[8]
	bit32.bxor(4588, v84)
	fn4(89910952, v84)
	local v85 = tbl4[16]
	bit32.bxor(4586, v85)
	fn4(89910952, v85)
	local v86 = tbl4[9]
	bit32.bxor(4150, v86)
	fn4(89910952, v86)
	local v87 = tbl3[14]
	bit32.bxor(4323, v87)
	fn4(89910952, v87)
	local v88 = tbl4[41]
	local v89 = v84
	bit32.bxor(6522, v88)
	fn4(89910952, v88)
end

local v84 = tbl4[48]
bit32.bxor(6452, v84)
fn4(89910952, v84)
local v85 = tbl3[5]
bit32.bxor(6479, v85)
fn4(89910952, v85)
local v86 = tbl4[13]
bit32.bxor(6405, v86)
fn4(89910952, v86)
local v87
v87 = bit32.bxor(v67, v35)
local v88 = tbl4[59]
bit32.bxor(6502, v88)
fn4(89910952, v88)
fn11(new3, "new")
fn12(new3, nil)
local ScreenGui
ScreenGui = v22("ScreenGui")
local n7, v89

do
	local Frame = v22("Frame")
	n7 = v76 // v36
	Frame.Position = udim2(0, 0, 0, 0)
	Frame.Size = udim2(0, 169, 0, 249)
	Frame.Parent = ScreenGui
	local Path2D = v22("Path2D")
	Path2D.Parent = Frame
	v89 = Path2D
end

do
	local setControlPoints = v89.SetControlPoints
	local tbl5 = {}
	local v90 = new3(udim2(0.0625, -10, 0.375, -7), udim2(0, 0, 0, 0), udim2(0, 0, 0, 0))
	local v91 = new3(udim2(0.25, 8, 0, 7), udim2(0, -6, 0.125, -7), udim2(0.125, 4, 0, 2))
	local v92 = new3(udim2(0.25, 8, 0.0625, -1), udim2(0, 1, -0.125, 1), udim2(0, 7, 0, -3))
	local v93 = new3(udim2(0, 5, 0, -3), udim2(0, -2, 0, -2), udim2(0, 2, 0, -5))
	local v94 = udim2(0.5, 5, 0, 4)
	local v95 = udim2(0, -1, 0, -7)
	tbl5[1] = v90
	tbl5[2] = v91
	tbl5[3] = v92
	tbl5[4] = v93

	do
		local values = table.pack(new3(v94, v95, udim2(0, 1, 0.0625, 7)))
		table.move(values, 1, values.n, 5, tbl5)
	end

	setControlPoints(v89, tbl5)
end

do
	local length = v89:GetLength()
	local unpack_ = string.unpack
	local pack = string.pack
	local v90 = bit32.band(length - length % 1, 536870911)
	bit32.bxor(6318, v90)
	fn5(unpack_(">I4", pack(">f", length)), 4)
end

do
	local positionOnCurve = v89:GetPositionOnCurve(0.625)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	local v90 = bit32.band(scale - scale % 1, 536870911)
	bit32.bxor(6449, v90)
	fn5(unpack_("<I4", pack("<f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	local v91 = bit32.band(scale2 - scale2 % 1, 536870911)
	bit32.bxor(6431, v91)
	fn5(unpack_2("<I4", pack2(">f", scale2)), 4)
end

do
	local positionOnCurve = v89:GetPositionOnCurve(0.60000002384185791)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	local v90 = bit32.band(scale - scale % 1, 536870911)
	bit32.bxor(5285, v90)
	fn5(unpack_(">I4", pack("<f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	local v91 = bit32.band(scale2 - scale2 % 1, 536870911)
	bit32.bxor(5267, v91)
	fn5(unpack_2("<I4", pack2(">f", scale2)), 4)
end

local v90, v91

do
	local positionOnCurve = v89:GetPositionOnCurve(0.57142859697341919)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurve.X.Scale
	local v92 = bit32.band(scale - scale % 1, 536870911)
	bit32.bxor(2801, v92)
	v90 = v37
	fn5(unpack_(">I4", pack(">f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurve.Y.Scale
	local v93 = bit32.band(scale2 - scale2 % 1, 536870911)
	bit32.bxor(8326, v93)
	local v94 = unpack_2("<I4", pack2(">f", scale2))
	v91 = bit32.bxor(v87, v38)
	fn5(v94, 4)
end

do
	local tangentOnCurve = v89:GetTangentOnCurve(0.83333331346511841)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurve.X
	local v92 = bit32.band(x - x % 1, 536870911)
	bit32.bxor(8399, v92)
	fn5(unpack_(">I4", pack(">f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurve.Y
	local v93 = bit32.band(y - y % 1, 536870911)
	bit32.bxor(8345, v93)
	fn5(unpack_2("<I4", pack2("<f", y)), 4)
end

local v92

do
	local tangentOnCurve = v89:GetTangentOnCurve(0.3333333432674408)
	local unpack_ = string.unpack
	v92 = bit32.band(n7, v44)
	local pack = string.pack
	local x = tangentOnCurve.X
	local v93 = bit32.band(x - x % 1, 536870911)
	bit32.bxor(2963, v93)
	fn5(unpack_("<I4", pack("<f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurve.Y
	local v94 = bit32.band(y - y % 1, 536870911)
	bit32.bxor(536867907, v94)
	fn5(unpack_2("<I4", pack2(">f", y)), 4)
end

do
	local tangentOnCurve = v89:GetTangentOnCurve(0.83333331346511841)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurve.X
	local v93 = bit32.band(x - x % 1, 536870911)
	bit32.bxor(4855, v93)
	fn5(unpack_("<I4", pack(">f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local y = tangentOnCurve.Y
	local v94 = bit32.band(y - y % 1, 536870911)
	bit32.bxor(4777, v94)
	fn5(unpack_2("<I4", pack2("<f", y)), 4)
end

do
	local positionOnCurveArcLength = v89:GetPositionOnCurveArcLength(0.4444444477558136)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurveArcLength.X.Scale
	local v93 = bit32.band(scale - scale % 1, 536870911)
	bit32.bxor(4623, v93)
	fn5(unpack_(">I4", pack("<f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurveArcLength.Y.Scale
	local v94 = bit32.band(scale2 - scale2 % 1, 536870911)
	bit32.bxor(4926, v94)
	fn5(unpack_2(">I4", pack2(">f", scale2)), 4)
end

local v93

do
	local positionOnCurveArcLength = v89:GetPositionOnCurveArcLength(0.91666668653488159)
	local unpack_ = string.unpack
	local pack = string.pack
	local scale = positionOnCurveArcLength.X.Scale
	local v94 = bit32.band(scale - scale % 1, 536870911)
	bit32.bxor(3792, v94)
	fn5(unpack_("<I4", pack(">f", scale)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local scale2 = positionOnCurveArcLength.Y.Scale
	local v95 = bit32.band(scale2 - scale2 % 1, 536870911)
	bit32.bxor(536867105, v95)
	local v96 = table.pack(pack2("<f", scale2))
	v93 = bit32.band(v92, v40)
	fn5(unpack_2("<I4", table.unpack(v96, 1, v96.n)), 4)
end

local n8, v94

do
	local tangentOnCurveArcLength = v89:GetTangentOnCurveArcLength(0.3333333432674408)
	local unpack_ = string.unpack
	local pack = string.pack
	local x = tangentOnCurveArcLength.X
	local v95 = bit32.band(x - x % 1, 536870911)
	bit32.bxor(6307, v95)
	fn5(unpack_("<I4", pack("<f", x)), 4)
	local unpack_2 = string.unpack
	local pack2 = string.pack
	local v96 = bit32.bxor(v91, v42)
	local y = tangentOnCurveArcLength.Y
	local v97 = bit32.band(y - y % 1, 536870911)
	bit32.bxor(536869403, v97)
	fn5(unpack_2("<I4", pack2("<f", y)), 4)
	local tangentOnCurveArcLength2 = v89:GetTangentOnCurveArcLength(0.80000001192092896)
	local unpack_3 = string.unpack
	local pack3 = string.pack
	local x2 = tangentOnCurveArcLength2.X
	local v98 = bit32.band(x2 - x2 % 1, 536870911)
	bit32.bxor(1523, v98)
	fn5(unpack_3("<I4", pack3("<f", x2)), 4)
	local unpack_4 = string.unpack
	local pack4 = string.pack
	local y2 = tangentOnCurveArcLength2.Y
	local v99 = bit32.band(y2 - y2 % 1, 536870911)
	bit32.bxor(1524, v99)
	fn5(unpack_4("<I4", pack4(">f", y2)), 4)
	local tangentOnCurveArcLength3 = v89:GetTangentOnCurveArcLength(0.625)
	local unpack_5 = string.unpack
	local pack5 = string.pack
	local x3 = tangentOnCurveArcLength3.X
	local v100 = bit32.band(x3 - x3 % 1, 536870911)
	bit32.bxor(536868451, v100)
	fn5(unpack_5("<I4", pack5("<f", x3)), 4)
	local unpack_6 = string.unpack
	local pack6 = string.pack
	local y3 = tangentOnCurveArcLength3.Y
	local v101 = bit32.band(y3 - y3 % 1, 536870911)
	bit32.bxor(536868391, v101)
	fn5(unpack_6(">I4", pack6(">f", y3)), 4)
	ScreenGui:Destroy()
	v21(math, { [991019141] = 2041238798, [1001344043] = 718722207, [2897255833] = 2062142320 }, 513374487)
	n8 = (v90 + v39) * v43

	v21(v19, {
		[2292321952] = 484363059,
		[375521735] = 2121496753,
		[582928667] = 1264688714,
		[2106541464] = 913111771,
		[2301669812] = 2129081054,
	}, 513374487)

	local tbl5 = {}
	v94 = bit32.bxor(v96, v45)
	tbl5[3530269659] = 1949659591
	tbl5[1663316942] = 1993772279
	v21(v14, tbl5, 513374487)
end

local v95
v95 = game
local fn13
local v96 = workspace

fn13 = function(arg, arg2, arg3)
	local state = 1
	local v97, v98, v99, parent, parent2, name, name2, descendantAdded, n9, n10, n11, v100, flag, flag2

	while true do
		if state == 1 then
			v97 = arg
			v98 = arg2
			v99 = arg3
			local v101 = nil
			state = 2
		elseif state == 2 then
			local kind = type(v98)
			fn8("userdata", kind)

			if nil then
				state = 3
			else
				state = 52
			end
		elseif state == 3 then
			local kind = typeof(v98)
			fn8("Instance", kind)

			if nil then
				state = 4
			else
				state = 53
			end
		elseif state == 4 then
			parent = v98.Parent
			parent2 = v98.Parent

			if tbl2[not parent] then
				state = 5
			else
				state = 8
			end
		elseif state == 5 then
			name = parent
			name2 = parent2
			state = 6
		elseif state == 6 then
			(nil)(name, name2)

			if nil then
				state = 7
			else
				state = 99
			end
		elseif state == 7 then
			if v97 == 524153637 then
				state = 8
			else
				state = 16
			end
		elseif state == 8 then
			name = v98.Name
			name2 = v98.Name
			local kind = type(name)
			fn8("string", kind)

			if nil then
				state = 9
			else
				state = 73
			end
		elseif state == 9 then
			(nil)(name, name2)

			if nil then
				state = 10
			else
				state = 98
			end
		elseif state == 10 then
			fn8(#name, #name2)

			if nil then
				state = 11
			else
				state = 65
			end
		elseif state == 11 then
			tostring(v98)
			fn8(nil, name)

			if nil then
				state = 12
			else
				state = 60
			end
		elseif state == 12 then
			fn8(v99, v98.ClassName)

			if nil then
				state = 14
			else
				state = 13
			end
		elseif state == 13 then
			v99 = nil
			state = 72
		elseif state == 14 then
			v99 = nil
			state = 15
		elseif state == 15 then
			descendantAdded = v98.DescendantAdded
			v97 = bit32.bxor(v97, 48746298)
			name = v98.DescendantAdded
			fn8(nil, name)

			if nil then
				state = 16
			else
				state = 17
			end
		elseif state == 16 then
			fn5(516790211, 4)
			n = 370097668
			local v101 = fn6
			local v102 = table.pack(bit32.band(n9, 4294967295))
			local v103 = table.pack(bit32.band(v97, 4294967295))
			local v104 = table.pack(bit32.band(v102[1], 65535))
			local v105 = table.pack(bit32.rshift(v102[1], 16))
			local v106 = table.pack(bit32.band(v103[1], 65535))
			local v107 = bit32.band(v104[1] * v106[1] + bit32.lshift(bit32.band(v104[1] * bit32.rshift(v103[1], 16) + v105[1] * v106[1], 65535), 16), 4294967295)
			v101()
			n9 = v107 - 891281612
			state = 17
		elseif state == 17 then
			if nil then
				state = 18
			else
				state = 90
			end
		elseif state == 18 then
			local connect = descendantAdded.Connect
			local connect2 = descendantAdded.Connect
			fn11(connect, "Connect")
			fn11(connect2, "Connect")
			fn8(connect, connect2)

			if nil then
				state = 19
			else
				state = 20
			end
		elseif state == 19 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			state = 20
		elseif state == 20 then
			local childRemoved = v98.ChildRemoved
			local v101 = childRemoved
			local connect = childRemoved.Connect
			local v102 = bit32.bxor(n10, 3144439253)
			local v103 = bit32.bxor(v97, 67931735)
			bit32.bxor(v102, v103)
			name = connect(v101, nil)

			if nil then
				state = 22
			else
				state = 21
			end
		elseif state == 21 then
			state = 24
		elseif state == 22 then
			state = 23
		elseif state == 23 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			n10 = n10 + v97 + 3794125793
			state = 24
		elseif state == 24 then
			if nil then
				state = 25
			else
				state = 83
			end
		elseif state == 25 then
			local disconnect = name.Disconnect
			fn11(disconnect, "Disconnect")
			fn12(disconnect, nil)
			disconnect(name)

			if nil then
				state = 26
			else
				state = 27
			end
		elseif state == 26 then
			fn5("__index", nil --[[ constant not decoded ]])
			n = 370097668
			fn6()
			state = 27
		elseif state == 27 then
			local wait2 = descendantAdded.Wait
			fn11(wait2, "Wait")
			name = coroutine.create
			local n12 = n9 - 887623858

			name2 = function()
				local v101 = wait2
				local flag3 = bit32.bxor(n12, 502999721) == 225624165
				return (v101(descendantAdded))
			end

			local v101 = bit32.bxor(n10, 2766072406)
			n12 = bit32.bxor(n12, v101)
			state = 28
		elseif state == 28 then
			name = name(name2)
			n11, name2 = coroutine.resume(name)
			v100 = tbl2

			if v97 + 275593385 ~= 388658377 then
				state = 29
			else
				state = 54
			end
		elseif state == 29 then
			local v101 = v100[not n11]
			flag = not v101

			if v101 then
				state = 31
			else
				state = 30
			end
		elseif state == 30 then
			name2 = flag
			state = 32
		elseif state == 31 then
			name2 = tbl2[not name2]
			state = 32
		elseif state == 32 then
			if name2 then
				state = 33
			else
				state = 95
			end
		elseif state == 33 then
			if name2 then
				state = 34
			else
				state = 35
			end
		elseif state == 34 then
			local v101 = fn5
			local v102 = table.pack(bit32.band(n10, 4294967295))
			local v103 = table.pack(bit32.band(v102[1], 65535))
			local v104 = bit32.band(v103[1] * 26871 + bit32.lshift(bit32.band(v103[1] * 0 + bit32.rshift(v102[1], 16) * 26871, 65535), 16), 4294967295)
			v101("GetPositionOnCurveArcLength", nil --[[ constant not decoded ]])
			n = 370097668
			fn6()
			n10 = v104 - 2030823670
			state = 35
		elseif state == 35 then
			name2 = nil
			local v101 = tbl2[not pcall(nil, name)]
			flag2 = not v101

			if v101 then
				state = 37
			else
				state = 36
			end
		elseif state == 36 then
			name2 = flag2
			state = 38
		elseif state == 37 then
			name2 = not tbl2[not name2]
			state = 38
		elseif state == 38 then
			if name2 then
				state = 39
			else
				state = 104
			end
		elseif state == 39 then
			if name2 then
				state = 40
			else
				state = 41
			end
		elseif state == 40 then
			fn5(516790211, 4)
			n = "IsServer"
			fn6()
			state = 41
		elseif state == 41 then
			local v101 = getmetatable(v98)
			fn8("The metatable is locked", v101)

			if nil then
				state = 42
			else
				state = 87
			end
		elseif state == 42 then
			if v99 then
				state = 105
			else
				state = 43
			end
		elseif state == 43 then
			if nil then
				state = 44
			else
				state = 83
			end
		elseif state == 44 then
			if nil <= 22 then
				state = 76
			else
				state = 45
			end
		elseif state == 45 then
			if nil <= 34 then
				state = 61
			else
				state = 46
			end
		elseif state == 46 then
			if nil <= 40 then
				state = 55
			else
				state = 47
			end
		elseif state == 47 then
			if nil <= 43 then
				state = 50
			else
				state = 48
			end
		elseif state == 48 then
			if nil <= 44 then
				state = 42
			else
				state = 49
			end
		elseif state == 49 then
			if nil <= 45 then
				state = 17
			else
				state = 23
			end
		elseif state == 50 then
			if nil <= 41 then
				state = 53
			else
				state = 51
			end
		elseif state == 51 then
			if nil <= 42 then
				state = 37
			else
				state = 52
			end
		elseif state == 52 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			state = 3
		elseif state == 53 then
			fn5(516790211, 4)
			n = 370097668
			local v101 = table.pack(bit32.band(n10, 4294967295))
			local v102 = table.pack(bit32.band(v97, 4294967295))
			local v103 = table.pack(bit32.band(v101[1], 65535))
			local v104 = table.pack(bit32.rshift(v101[1], 16))
			local v105 = table.pack(bit32.band(v102[1], 65535))
			local v106 = bit32.band(v103[1] * v105[1] + bit32.lshift(bit32.band(v103[1] * bit32.rshift(v102[1], 16) + v104[1] * v105[1], 65535), 16), 4294967295)
			fn6()
			n11 = v106 + 2554662108
			state = 54
		elseif state == 54 then
			n10 = n11
			state = 4
		elseif state == 55 then
			if nil <= 37 then
				state = 58
			else
				state = 56
			end
		elseif state == 56 then
			if nil <= 38 then
				state = 18
			else
				state = 57
			end
		elseif state == 57 then
			if nil <= 39 then
				state = 105
			else
				state = 10
			end
		elseif state == 58 then
			if nil <= 35 then
				state = 28
			else
				state = 59
			end
		elseif state == 59 then
			if nil <= 36 then
				state = 60
			else
				state = 25
			end
		elseif state == 60 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			n9 = n9 - v97 - 3770813659
			state = 12
		elseif state == 61 then
			if nil <= 28 then
				state = 69
			else
				state = 62
			end
		elseif state == 62 then
			if nil <= 31 then
				state = 67
			else
				state = 63
			end
		elseif state == 63 then
			if nil <= 32 then
				state = 66
			else
				state = 64
			end
		elseif state == 64 then
			if nil <= 33 then
				state = 65
			else
				state = 7
			end
		elseif state == 65 then
			fn5(516790211, 4)
			n = "IsServer"
			fn6()
			state = 11
		elseif state == 66 then
			local wait2 = descendantAdded.Wait
			fn11(wait2, "Wait")
			name = coroutine.create
			local n12 = n9 - 887623858

			name2 = function()
				local v101 = wait2
				local flag3 = bit32.bxor(n12, 502999721) == 225624165
				return (v101(descendantAdded))
			end

			local v101 = bit32.bxor(n10, 2766072406)
			n12 = bit32.bxor(n12, v101)
			state = 28
		elseif state == 67 then
			if nil <= 29 then
				state = 31
			else
				state = 68
			end
		elseif state == 68 then
			if nil <= 30 then
				state = 35
			else
				state = 2
			end
		elseif state == 69 then
			if nil <= 25 then
				state = 74
			else
				state = 70
			end
		elseif state == 70 then
			if nil <= 26 then
				state = 73
			else
				state = 71
			end
		elseif state == 71 then
			if nil <= 27 then
				state = 72
			else
				state = 32
			end
		elseif state == 72 then
			fn5(-3, "delay")
			n = 2
			fn6()
			state = 15
		elseif state == 73 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			state = 9
		elseif state == 74 then
			if nil <= 23 then
				state = 9
			else
				state = 75
			end
		elseif state == 75 then
			if nil <= 24 then
				state = 16
			else
				state = 12
			end
		elseif state == 76 then
			if nil <= 10 then
				state = 91
			else
				state = 77
			end
		elseif state == 77 then
			if nil <= 16 then
				state = 84
			else
				state = 78
			end
		elseif state == 78 then
			if nil <= 19 then
				state = 81
			else
				state = 79
			end
		elseif state == 79 then
			if nil <= 20 then
				state = 4
			else
				state = 80
			end
		elseif state == 80 then
			if nil <= 21 then
				state = 8
			else
				state = 3
			end
		elseif state == 81 then
			if nil <= 17 then
				state = 40
			else
				state = 82
			end
		elseif state == 82 then
			if nil <= 18 then
				state = 15
			else
				state = 83
			end
		elseif state == 83 then
			fn5("__index", nil --[[ constant not decoded ]])
			n = 370097668
			fn6()
			state = 25
		elseif state == 84 then
			if nil <= 13 then
				state = 88
			else
				state = 85
			end
		elseif state == 85 then
			if nil <= 14 then
				state = 11
			else
				state = 86
			end
		elseif state == 86 then
			if nil <= 15 then
				state = 87
			else
				state = 26
			end
		elseif state == 87 then
			fn5("__index", nil --[[ constant not decoded ]])
			n = 370097668
			fn6()
			state = 42
		elseif state == 88 then
			if nil <= 11 then
				state = 90
			else
				state = 89
			end
		elseif state == 89 then
			if nil <= 12 then
				state = 41
			else
				state = 19
			end
		elseif state == 90 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			state = 18
		elseif state == 91 then
			if nil <= 4 then
				state = 100
			else
				state = 92
			end
		elseif state == 92 then
			if nil <= 7 then
				state = 96
			else
				state = 93
			end
		elseif state == 93 then
			if nil <= 8 then
				state = 38
			else
				state = 94
			end
		elseif state == 94 then
			if nil <= 9 then
				state = 95
			else
				state = 34
			end
		elseif state == 95 then
			local v101 = coroutine.status(name)
			name2 = not fn8("suspended", v101)
			state = 33
		elseif state == 96 then
			if nil <= 5 then
				state = 99
			else
				state = 97
			end
		elseif state == 97 then
			if nil <= 6 then
				state = 98
			else
				state = 6
			end
		elseif state == 98 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			state = 10
		elseif state == 99 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
			state = 7
		elseif state == 100 then
			if nil <= 1 then
				state = 103
			else
				state = 101
			end
		elseif state == 101 then
			if nil <= 2 then
				state = 39
			else
				state = 102
			end
		elseif state == 102 then
			if nil <= 3 then
				state = 24
			else
				state = 33
			end
		elseif state == 103 then
			if nil <= 0 then
				state = 20
			else
				state = 104
			end
		elseif state == 104 then
			local v101 = bit32.bxor(v97, n9)
			local v102 = coroutine.status(name)
			name2 = not fn8("dead", v102)
			v97 = bit32.bxor(v101, 1122488122)
			state = 39
		elseif state == 105 then
			return
		end
	end
end

fn13(524153637, v95, "DataModel")
fn13(524153637, v96, "Workspace")

if fn8(v95, v96.Parent) then
	fn4(89910952, 73)
	n = nil
else
	fn5(516790211, 4)
	n = 370097668
	fn6()
end

do
	local Folder = v22("Folder")
	fn13(524153637, Folder, "Folder")
	local ok, result = pcall(Folder.ResetPropertyToDefault, Rect.new(-958.8211669921875, 256.6929931640625, -949.08001708984375, 304.24609375), 71235442)
	local flag = not ok

	if not tbl2[flag] then
		local v97 = fn10(result, 90204344)
		local v98 = bit32.bxor(v93, v46)
		fn5(v97, 4)
	end

	local v97 = n

	if tbl2[flag] then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
		fn4(89910952, 186)
		n = v97
	end

	local children, v98, v99 = Folder:GetChildren()
	local v100 = table.pack(X_1())

	if v100[1] then
		repeat
			fn5(516790211, 4)
			n = 370097668
			fn6()
			local v101 = table.pack(X_1())
		until not v101[1]
	end

	Folder:Destroy()
	local v101 = n
	local v102 = Folder
	local Folder2 = v22("Folder", v102)
	fn13(524153637, Folder2, "Folder")
	local v103

	if fn8(v102, Folder2.Parent) then
		v103 = v101
		fn4(89910952, 55)
		n = v103
	else
		v103 = v101
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(Folder2.Parent, Folder2.Parent) then
		fn4(89910952, 83)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local waitForChild = v102.WaitForChild
	fn11(waitForChild, "WaitForChild")
	fn12(waitForChild, nil)
	local name = tostring(11914720)
	Folder2.Name = name
	local v104 = waitForChild(v102, name)

	if fn8(Folder2, v104) then
		fn4(89910952, 96)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	v102:Destroy()
	Folder2:Destroy()

	if tbl2[not Folder2.Parent] then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
		fn4(89910952, 195)
	end

	if tbl2[not pcall(function()
		Folder2.Parent = v102
	end)] then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	else
		fn4(89910952, 235)
	end

	n = v103
end

local v97, v98, n9

do
	local HttpService = v95:GetService("HttpService")
	fn13(524153637, HttpService, "HttpService")
	local v99 = n
	local v100

	if fn8(v95, HttpService.Parent) then
		fn4(89910952, 164)
		n = v99
		v100 = v99
	else
		v100 = v99
		fn5(-1, "suspended")
		n = 370097668
		fn6()
	end

	local RunService = v95:GetService("RunService")
	fn13(524153637, RunService, "RunService")

	if fn8(v95, RunService.Parent) then
		fn4(89910952, 167)
		n = v100
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local isStudio = RunService.IsStudio
	local v101 = bit32.bxor(v94, v48)
	local n10 = n8 * v49
	fn11(isStudio, "IsStudio")
	fn11(RunService.IsClient, "IsClient")
	fn11(RunService.IsServer, "IsServer")
	fn12(RunService.IsStudio)
	fn12(RunService.IsClient)
	fn12(RunService.IsServer)
	RunService:IsServer()

	if nil then
		local v102 = v95:utf8(0.375)
		fn13(524153637, v102, -6)
		fn8(v95, v102.Z)
		local v103

		if nil then
			v103 = v102
		else
			v103 = v102
			fn5(516790211, 4)
			n = 370097668
			fn6()
			v101 = bit32.bxor(bit32.bxor(v101, v50), 168)
		end

		local children, v104, v105 = v103:GetChildren()
		local n11 = 0
		local v106 = table.pack(X_1())

		if v106[1] then
			repeat
				n11 += 1
				local v107 = table.pack(X_1())
			until not v107[1]
		end

		if nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end
	end

	if tbl2[not pcall(v95.GetChildren)] then
		fn5("create", 4056449317)
		n = 370097668
		fn6()
	else
		fn4(89910952, 180)
		n = v100
	end

	local n11 = n10 // v51
	local v102 = Enum
	local v103 = n

	if fn8(type(v102), "userdata") then
		fn4(89910952, 110)
		n = v103
		v97 = v103
	else
		v97 = v103
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(typeof(v102), "Enums") then
		fn4(89910952, 102)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v104 = getmetatable(v102)

	if fn8("The metatable is locked", v104) then
		fn4(89910952, 211)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local r6 = v102.HumanoidRigType.R6
	local v105 = v52

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

	local v106 = getmetatable(r6)

	if fn8("The metatable is locked", v106) then
		fn4(89910952, 143)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
		local n12 = bit32.band(v105, v53) + 4
	end

	fn11(r6.IsA, "IsA")
	fn12(r6.IsA)
	local name = r6.Name
	local value = r6.Value

	if fn8(type(name), "string") then
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

	if fn8(r6, enumType[name]) then
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
		n11 = bit32.bxor(n11, v56) - 4294967164
	end

	v98 = bit32.bxor(v101, v54)

	if fn8(typeof(enumType), "Enum") then
		fn4(89910952, 70)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v107 = getmetatable(enumType)

	if fn8("The metatable is locked", v107) then
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
	local v108 = enumType:FromName(name)

	if fn8(r6, v108) then
		fn4(89910952, 11)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local v109 = enumType:FromValue(value)
	n9 = n11 - v55

	if fn8(r6, v109) then
		fn4(89910952, 68)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end
end

local v99, v100

do
	local new4 = v17.new
	fn11(new4, "new")
	fn12(new4, {})
	local v101 = new4(1339925708)

	if fn8(type(v101), "userdata") then
		fn4(89910952, 24)
		n = v97
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	v99 = v57

	if fn8(typeof(v101), "Random") then
		fn4(89910952, 165)
		v98 = bit32.bxor(bit32.bxor(v98, v58), 165)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	fn11(v101.NextUnitVector, "NextUnitVector")
	fn11(v101.NextInteger, "NextInteger")
	fn11(v101.NextNumber, "NextNumber")
	fn11(v101.Shuffle, "Shuffle")
	fn11(v101.Clone, "Clone")
	v100 = new4(1965685320)
end

do
	local unpack_ = string.unpack
	local pack = string.pack
	local v101 = v100:NextNumber()
	local v102 = bit32.band(v101 - v101 % 1, 536870911)
	bit32.bxor(3292, v102)
	fn5(unpack_(">I4", pack(">f", v101)), 4)
end

do
	local unpack_ = string.unpack
	local pack = string.pack
	local v101 = v100:NextNumber()
	local v102 = bit32.band(v101 - v101 % 1, 536870911)
	bit32.bxor(3336, v102)
	fn5(unpack_(">I4", pack("<f", v101)), 4)
end

local v101 = v100:NextInteger(777, 1620)
bit32.bxor(3759, v101)
fn5(v101, 4)
local v102 = v100:NextInteger(906, 1217)
bit32.bxor(2316, v102)
fn5(v102, 4)
local v103 = v100:NextInteger(708, 1024)
bit32.bxor(2174, v103)
fn5(v103, 4)
local v104 = v100:NextInteger(354, 648)
bit32.bxor(2364, v104)
fn5(v104, 4)
local v105 = v100:NextInteger(32, 815)
bit32.bxor(2309, v105)
fn5(v105, 4)

do
	local unpack_ = string.unpack
	local pack = string.pack
	local v106 = v100:NextNumber()
	local v107 = bit32.band(v106 - v106 % 1, 536870911)
	bit32.bxor(9095, v107)
	fn5(unpack_("<I4", pack("<f", v106)), 4)
end

local v106 = v100:NextInteger(112, 807)
bit32.bxor(8710, v106)
fn5(v106, 4)
local v107 = v100:NextInteger(362, 1068)
bit32.bxor(8283, v107)
fn5(v107, 4)

do
	local unpack_ = string.unpack
	local pack = string.pack
	local v108 = v100:NextNumber()
	local v109 = bit32.band(v108 - v108 % 1, 536870911)
	bit32.bxor(6544, v109)
	fn5(unpack_("<I4", pack("<f", v108)), 4)
end

local v108 = v100:NextInteger(333, 507)
bit32.bxor(6213, v108)
fn5(v108, 4)

do
	local unpack_ = string.unpack
	local pack = string.pack
	local v109 = v100:NextNumber()
	local v110 = bit32.band(v109 - v109 % 1, 536870911)
	bit32.bxor(6515, v110)
	fn5(unpack_(">I4", pack("<f", v109)), 4)
end

local n10, v109, tbl5, tbl6, v110

do
	local tbl7 = {
		[2903502143] = 76,
		[158403253] = 304,
		[913754451] = 304,
		[2095656011] = 152,
		[1343581260] = 76,
		[843338931] = 152,
	}

	bit32.bor(v99, v60)
	tbl7[3958773163] = 76
	tbl7[2753695325] = 304
	tbl7[1299111401] = 304
	tbl7[2302524640] = 76
	local n11 = 304
	tbl7[3673322871] = 76
	tbl7[2927273839] = n11
	tbl7[3774221998] = 76
	tbl7[3992347413] = 76
	tbl7[534968755] = n11
	tbl7[4050335859] = n11
	tbl7[4213664805] = 76
	tbl7[1451511250] = n11
	tbl7[4290636774] = n11
	local v111 = bit32.bxor(v98, v64)
	tbl7[1159343961] = n11
	tbl7[4283026575] = n11
	tbl7[2657262125] = n11
	tbl7[2952522137] = n11
	tbl7[495010065] = n11
	tbl7[629660659] = 76
	tbl7[2714684079] = n11
	tbl7[600652] = 76
	tbl7[486127870] = 76
	tbl7[2538992252] = n11
	tbl7[3736489643] = 76
	tbl7[1610005375] = n11
	tbl7[340808879] = n11
	local env = getfenv()
	local tbl8 = {}
	local tbl9 = {}
	n10 = n9 // v59 + v61
	local n12 = 0
	local tbl10 = { 3, v2, nil, 0, 1 }

	while true do
		local v112 = tbl10[5]
		local v113 = tbl10[1]
		local n13 = tbl10[4] + v112
		local flag = v112 <= 0
		local flag2 = not flag
		local flag3 = n13 >= v113
		local flag4 = n13 <= v113

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

		tbl10[4] = n13

		if flag3 then
			type(env)

			if not nil then
				if not nil then
					tbl8[env] = true
					local n14 = 0

					for k in env, nil, nil do
						n14 += 1
						local kind = type(k)

						if fn8("string", kind) then
							if #k < 20 then
								local v114 = fn10(k, 90204344)

								if not tbl9[v114] then
									n12 += tbl7[v114] or 0
									tbl9[v114] = true
									if n14 > 50 then
										break
									end
									continue
								end
							end
						end

						if n14 > 50 then
							break
						end
					end

					local v114 = n12
					local v115 = getmetatable(env)
					local flag5 = type(v115) == "table"
					local v116, value

					if flag5 then
						v116 = v114
						value = rawget(v115, "__index")
					else
						v116 = v114
						value = flag5
					end

					if value then
						local v117 = v116
						env = value
						n12 = v117
					else
						n12 = v116
						env = nil
					end

					continue
				end
			end
		end

		break
	end

	local v112 = tbl10[2]
	fn4(89910952, n12 < n11 and 10 or 202)

	if nil then
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	local ok, result = pcall(assert, false)

	if ok or not result or type(result) ~= "string" then
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

	local function fn14(arg, arg2, arg3)
		local v113, v114, n13 = string.find(arg, ":[^%a%A]*([0-9][0-9]*)[%:\r\n]")
		local flag = not v113
		local flag2

		if v113 then
			flag2 = not v114
		else
			flag2 = flag
		end

		if flag2 then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn5(v113, 2)
		fn5(v114, 2)
		local v115 = string.match(arg, ":([%d]%d*)[\r\n%:][^%u%U]*")
		local v116 = fn5
		local v117

		if n13 then
			v117 = v115
		else
			v117 = v115
			n13 = 0
		end

		v116(n13 + 0, 2)
		fn5((v117 or 0) + 0, 2)
		local v118 = nil
		local v119 = string.gmatch(arg, ":([%d]%d*)[\r%:\n][^%p%P]*")
		local n14 = v119()
		fn8(v119(), nil)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v120 = fn5
		local v121

		if n14 then
			v121 = v120
		else
			v121 = v120
			n14 = 0
		end

		v121(n14 + 0, 2)
		local str = string.sub(arg, v113 + 1, nil)
		local v122 = string.char(string.byte(arg, v113 + 1, nil))
		local v123 = string.byte(arg, v113 + 1, nil)
		local n15 = nil // arg2
		fn5(str + 0, 2)
		fn5(v122 + 0, 2)
		fn4(89910952, v123)
		local tbl11 = { v114 - 1 + 0, v113 + 1 - 1, nil, nil, 1 }
		local n16 = 0
		local v124 = tbl11

		while true do
			local v125 = v124[5]
			local v126 = v124[1]
			local n17 = v124[2] + v125
			local flag3 = v125 <= 0
			v124[2] = n17

			if n17 <= v126 then
				n16 = n16 * 10 + string.byte(arg, n17, n17) - 48
			else
				break
			end
		end

		fn5(n16, 2)
		local v125 = nil
		local gsub = string.gsub
		local v126 = bit32.bxor(n15, 385921110)
		local v127 = bit32.bxor(v118, 3051828995)
		bit32.bxor(v126, v127)
		local v128, v129 = gsub(arg, "%:([%d]+)[\n\r%:][^%l%L]-", nil, 1)
		fn8(0, 1)

		if nil then
		else
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v129, 1)

		if nil then
			fn5((v125 or 0) + 0, 2)
			fn8(string.sub(arg, 2, nil), arg3)

			if not nil then
				fn5(516790211, 4)
				n = 370097668
				fn6()
			end

			local v130 = fn4
			local v131 = string.byte(arg, 2, nil)
			v130(89910952, v131)
			return
		end

		fn5(516790211, 4)
		n = 370097668
		fn6()
		error("devirt: symbolic value store into proto array (at 2:48)")
	end

	v109 = bit32.bxor(v111, v62)
	fn14("main:113: attempt to get length of a thread value", 237948519, "a")
	fn14("tONAUhS:102: attempt to call a userdata value", 237948519, "O")
	fn14("LocalScript:142: attempt to call a userdata value", 237948519, "o")
	fn14("source.lua:49: attempt to perform arithmetic (pow) on userdata and function", 237948519, "o")

	fn3 = function(arg)
		local fn15 = nil
		local v113 = string.match(arg, "[:]([%d]%d*)[\r\n:][^%l%L]?")
		local v114 = string.gmatch(arg, "[:][^%x%X]*([0-9]+)[%:\r\n]")()
		local v115, v116 = string.find(arg, ":([%d]%d*)[^%l%L]?[\n\r:]")
		local flag = not v115
		local flag2

		if v115 then
			flag2 = not v116
		else
			flag2 = flag
		end

		local n13

		if flag2 then
			fn5(1734829927, 2459269543)
			n = "Connect"
			local v117 = fn6
			local v118 = bit32.bxor(nil, nil)
			v117()
			n13 = v118 + 397504976
		end

		local str = string.sub(arg, v115 + 1, v116 - 1)
		local v117 = string.char(string.byte(arg, v115 + 1, v116 - 1))
		local v118 = nil
		local n14 = 0
		local v119 = str
		local v120 = bit32.bxor(n13, 970739941)

		fn15 = function(arg2)
			fn8(info(1, "f"), fn15)

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

			local v121 = info(3, "f")
			local v122 = fn3
			local v123 = fn8
			bit32.bxor(v120, 278215474)
			v123(v121, v122)

			if not nil then
				local v124 = fn5

				upv39.Lerp = nil
				;(nil)(nil, 3909763859)
				v124()
			end

			v118 = arg2
			n14 += 1
		end

		local gsub = string.gsub
		v120 = bit32.bxor(v120, nil + 3517913275)
		local v121, v122 = gsub(arg, "%:[^%u%U]-([0-9][0-9]*)[^%d%D]-[\n%:\r]", fn15, 1)
		fn8(n14, 1)

		if nil then
		else
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local v123 = fn8
		fn8(v122, 1)
		local v124

		if nil then
			v124 = v123
		else
			v124 = v123
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		local flag3 = not v113
		local flag4

		if v113 then
			flag4 = not v114
		else
			flag4 = flag3
		end

		if flag4 or not v119 or not v117 or not v118 then
			local v125

			repeat
				fn5(0, "__index")
				n = 3909763991
				v125 = fn6
			until v124

			v125()
		end

		local n15 = v113 + 0
		local n16 = v114 + 0
		local v125 = bit32.bor(nil, n13)
		local n17 = v119 + 0
		local n18 = v117 + 0
		local n19 = v118 + 0
		fn8(v113, v114)
		local v126

		if nil then
			v126 = n16
		else
			v126 = n16
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v114, v119)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v119, v117)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v117, v118)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(n15, v126)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(v126, n17)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		fn8(n17, n18)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			local v127 = fn6
			local v128 = bit32.band(n13, 2130105607)
			v127()
		end

		fn8(n18, n19)

		if not nil then
			fn5(516790211, 4)
			n = 370097668
			fn6()
		end

		return n15
	end

	local v113 = fn3(result2)
	local v114 = fn3(result3)
	local v115 = fn3(result4)

	if fn8(v113, v114) then
		fn4(89910952, 204)
		n = v97
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(v114, v115) then
		fn4(89910952, 42)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	if fn8(v115, v113) then
		fn4(89910952, 1)
	else
		fn5(516790211, 4)
		n = 370097668
		fn6()
	end

	for _, v116 in {}, nil, nil do
		local exitTo = nil

		while true do
			local kind = type(v116)

			if fn8("function", kind) then
				info(v116, "sl")
				local v117 = table.pack(X_1())
				if v117[1] then
					v116 = v117[3]
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
	local n13 = v63 // v68
	tbl5 = {}
	tbl6 = {}
	local n14 = 153
	local n15 = 133
	local tbl11 = { 255, -1, 1, nil, v112 }

	while true do
		local v116, n16, flag

		do
			local v117 = tbl11[3]
			v116 = tbl11[1]
			n16 = tbl11[2] + v117
			flag = v117 <= 0
		end

		do
			local flag2 = not flag
			local flag3 = n16 >= v116
			local flag4 = n16 <= v116

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

			tbl11[2] = n16

			if flag3 then
				do
					local v117 = n16
					local n17 = (n14 * v117 + n15) % 256
					local n18 = (n14 * n17 + n15) % 256
					local n19 = (n14 * n18 + n15) % 256
					local n20 = (n14 * n19 + n15) % 256
					tbl5[v117] = n17 + n18 * 256 + n19 * 65536 + n20 * 16777216
					tbl6[v117] = n20
				end

				continue
			end
		end

		break
	end

	v110 = tbl11[5]
end

local v111
v111 = buffer.create(16)
luraph_runtime5(table.pack(tbl5, tbl6))
local fn14

fn14 = function()
	error("devirt: builtin bit32.bxor on symbolic values (at 2:465)")
end

do
	local n11 = 5
	local n12 = 6
	local n13 = 7
	local n14 = 8
	tbl[n11] = 2
	tbl[n12] = 6
	tbl[n13] = 10
	tbl[n14] = 14
end

do
	local n11 = 15
	local n12 = 16
	tbl[n11] = 12
	tbl[n12] = 16
end

do
	local v112 = bit32.bxor(v109, v65)
	local n11 = n10 + v66
	local n12 = 21
	local n13 = 22
	local n14 = 23
	local n15 = 24
	tbl[n12] = 2
	tbl[n13] = 7
	tbl[n14] = 12
	tbl[n15] = 13
	local n16 = 29
	local n17 = 30
	local n18 = 31
	local n19 = 32
	tbl[n16] = 4
	tbl[n17] = 5
	tbl[n18] = 10
	tbl[n19] = 15
	local v113 = luraph_runtime6(table.pack(v))

	local function fn15(arg, arg2, arg3, arg4)
		local tbl7 = {}
		local v114 = arg
		local v115 = arg2
		local v116 = arg3
		local v117 = arg4
		local n20 = 1

		while true do
			local n21 = (n20 - 1) * 4 + 1
			tbl7[n20 + 4] = v115[n21 + 3] * 16777216 + v115[n21 + 2] * 65536 + v115[n21 + 1] * 256 + v115[n21]

			if A_1 <= 0 then
				if X_1 >= z_1 then
					n20 = X_1
					continue
				end
				break
			else
				if X_1 <= z_1 then
					n20 = X_1
					continue
				end
				break
			end
		end

		local v118, n21

		if A_1 <= 0 then
			if X_1 >= z_1 then
				v118 = X_1

				while true do
					n21 = (v118 - 1) * 4 + 1
					local n22 = v118 + 13
					tbl7[n22] = v116[n21 + 3] * 16777216 + v116[n21 + 2] * 65536 + v116[n21 + 1] * 256 + v116[n21]

					if A_1 <= 0 then
						if X_1 >= z_1 then
							v118 = X_1
							continue
						end
						break
					else
						if X_1 <= z_1 then
							v118 = X_1
							continue
						end
						break
					end
				end
			end
		elseif X_1 <= z_1 then
			v118 = X_1

			while true do
				n21 = (v118 - 1) * 4 + 1
				tbl7[v118 + 13] = v116[n21 + 3] * 16777216 + v116[n21 + 2] * 65536 + v116[n21 + 1] * 256 + v116[n21]

				if A_1 <= 0 then
					if X_1 >= z_1 then
						v118 = X_1
						continue
					end
					break
				else
					if X_1 <= z_1 then
						v118 = X_1
						continue
					end
					break
				end
			end
		end

		local v119 = v116[13]
		local v120 = buffer.len(v114)
		local v121 = buffer.create(v120)
		local n22 = 0

		for i = 0, v120 - 1, 64 do
			while true do
				n22 += 1
				local tbl8 = {}
				local n23 = 1

				while true do
					tbl8[n23] = tbl7[n23]

					if A_2 <= 0 then
						if X_2 >= z_2 then
							n23 = X_2
							continue
						end
						break
					else
						if X_2 <= z_2 then
							n23 = X_2
							continue
						end
						break
					end
				end

				v113(tbl8, v119)
				local n24 = i + 64

				if v120 < n24 then
					n24 = v120
				end

				local n25 = n24 - i
				local v122 = bit32.rshift(n25, 2)
				local n26 = v122 - 1
				local n27 = 0
				local v123

				if 1 <= 0 then
					if n27 >= n26 then
						v123 = n27
						error("devirt: builtin bit32.band on symbolic values (at 126:231)")
					end
				elseif n27 <= n26 then
					v123 = n27
					error("devirt: builtin bit32.band on symbolic values (at 126:231)")
				end

				local n28 = v122 * 4

				if n28 < n25 then
					local n29 = tbl8[v122 + 1] + tbl7[v122 + 1]
					local n30 = n25 - n28 - 1
					local n31, writeu8, v124, v125, v126

					if 1 <= 0 then
						if n27 >= n30 then
							while true do
								n31 = i + n28 + n27
								writeu8 = buffer.writeu8
								v124 = buffer.readu8(v114, n31)
								v125 = bit32.band(bit32.rshift(n29, n27 * 8), 255)
								v126 = bit32.bxor(v124, v125)
								writeu8(v121, n31, v126)

								if A_2 <= 0 then
									if X_2 >= z_2 then
										n27 = X_2
										continue
									end
									break
								else
									if X_2 <= z_2 then
										n27 = X_2
										continue
									end
									break
								end
							end
						end
					elseif n27 <= n30 then
						while true do
							n31 = i + n28 + n27
							writeu8 = buffer.writeu8
							v124 = buffer.readu8(v114, n31)
							v125 = bit32.band(bit32.rshift(n29, n27 * 8), 255)
							v126 = bit32.bxor(v124, v125)
							writeu8(v121, n31, v126)

							if A_2 <= 0 then
								if X_2 >= z_2 then
									n27 = X_2
									continue
								end
								break
							else
								if X_2 <= z_2 then
									n27 = X_2
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
						return (fn14(v121, v117))
					end

					if X_1 <= z_1 then
						i = X_1
						continue
					end
					return (fn14(v121, v117))
				end

				break
			end
		end

		return (fn14(v121, v117))
	end

	local n20 = n11 - 4205363320

	local function fn16()
		local v114 = nil
		local v115 = nil
		local v116 = nil
		local str = nil

		if nil then
			bit32.bor(nil, n20)
			error("devirt: symbolic value store into proto array (at 169:209)")
		end

		if n20 == 206736773 then
			return nil
		end
		local v117 = nil
		local tbl7, n21

		while true do
			local v118 = tbl7[4]
			local v119 = tbl7[5]
			local n22 = tbl7[3] + v118
			local flag = v118 <= 0
			local flag2 = not flag
			local flag3 = n22 >= v119
			local flag4 = n22 <= v119

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

			tbl7[3] = n22

			if flag3 then
				n21 = (v114 * n21 + v115) % 0.25
				str ..= v116[1 + (n21 - n21 % 268435456) / 268435456 % 16]
				continue
			end

			local v120 = tbl7[1]
			string.byte(str, 1, 64)

			if nil then
				string.byte(v117, 1, 64)
			end

			local v121 = v120[5]
			local v122 = v120[4]
			local n23 = v120[2] + v121
			local flag5 = v121 <= 0
			local flag6 = not flag5
			local flag7 = n23 >= v122
			local flag8 = n23 <= v122

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

			v120[2] = n23

			if flag7 then
				str = "Name"
				tbl7 = { v120, nil, -3999674942, 3999674943, 6081145240 }
				continue
			end

			break
		end

		local tbl8 = {
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

		bit32.bxor(nil, nil + n20)
		tbl8[102] = 15
		error("devirt: symbolic value store into proto array (at 169:658)")
	end

	local v114 = bit32.bxor(v112, 3847512819)
	n20 = bit32.bxor(n20, v114)

	local function fn17(arg, arg2, arg3, arg4)
		if nil then
			return (fn15(arg2, arg, arg3, arg4))
		end
		return nil
	end

	local function fn18(arg, arg2, arg3, arg4, arg5, arg6)
		if nil then
			error("devirt: arith on 4205642453 b'PostAsync' (at 2:72)")
		end

		return nil
	end
end

if tbl2[false] then
	fn4(89910952, 144)
	n = v97
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
	local tbl7 = { 0, nil, 9, 1, v110 }

	while true do
		local v112 = tbl7[4]
		local v113 = tbl7[3]
		local n11 = tbl7[1] + v112
		local flag = v112 <= 0
		local flag2 = not flag
		local flag3 = n11 >= v113
		local flag4 = n11 <= v113

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

		tbl7[1] = n11

		if flag3 then
			local kind2 = type((table.pack(10697, 1932713301, 3513946746, 2366826352, 286081456, 276024717, 1064402848, 2265685854, 1947228433))[n11])
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

	local tbl8 = { nil, 1, 9, tbl7[5], 0 }

	while true do
		local v112 = tbl8[2]
		local v113 = tbl8[3]
		local n11 = tbl8[5] + v112
		local flag = v112 <= 0
		local flag2 = not flag
		local flag3 = n11 >= v113
		local flag4 = n11 <= v113

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

		tbl8[5] = n11

		if flag3 then
			local v114 = n11
			local v115 = (table.pack(10697, 1932713301, 3513946746, 2366826352, 286081456, 276024717, 1064402848, 2265685854, 1947228433))[v114]
			local n12

			if v114 ~= 1 then
				n12 = v115

				if nil then
					local n13 = n12 % 65536
					bit32.bxor(52836, n13)
					n12 = n12 - n13 + n13
				end
			else
				n12 = v115
				bit32.bxor(9205, n12)
			end

			fn5(n12, 4)
			continue
		end

		break
	end
end

local function fn15(arg)
	local v112 = arg[6]
	if v112 then
		return v112
	end
	local v113 = arg[5]

	local tbl7 = { __index = function()
		error("devirt: builtin bit32.bxor on symbolic values (at 174:4055)")
	end }

	arg[6] = tbl7
	return tbl7
end

if nil then
	return
end

error("devirt: symbolic value store into proto array (at 126:2610)")
