-- This file was generated at discord.gg/syncrypt

return (function(...)
	local t1 = {
		"iGh==",
		"4DE\\H9V2>c",
		"4QL",
		"iA4jSGCq=",
		"iy7w2tl/=",
		"iy7wCb5==",
		"4<%CBQ-dc",
		"icvV2GvO2oLiHADpRoq=="
	}

	for _, v in ipairs({
		{ 1, 8 },
		{ 1, 1 },
		{ 2, 8 }
	}) do
		while v[1] < v[2] do
			local v4 = v[1]
			local v5 = v[2]
			local v6 = t1[v[2]]
			local v7 = t1[v[1]]
			local v8 = v[1] + 1
			local v9 = v[2] - 1

			t1[v4] = v6
			t1[v5] = v7
			v[1] = v8
			v[2] = v9
		end
	end

	local floor = math.floor
	local type_ = type
	local char = string.char
	local len = string.len
	local concat = table.concat
	local sub = string.sub
	local insert = table.insert
	local t2 = {
		J = 35,
		K = 15,
		b = 24,
		A = 28,
		o = 8,
		C = 39,
		W = 55,
		e = 58,
		G = 27,
		m = 17,
		T = 63,
		U = 59,
		j = 9,
		h = 32,
		["0"] = 40,
		a = 54,
		l = 22,
		["9"] = 37,
		N = 2,
		L = 5,
		I = 51,
		x = 0,
		["5"] = 48,
		k = 57,
		["2"] = 44,
		t = 25,
		Q = 34,
		B = 52,
		V = 21,
		X = 3,
		D = 38,
		["4"] = 7,
		Y = 43,
		u = 19,
		["7"] = 53,
		R = 36,
		O = 60,
		v = 6,
		q = 16,
		P = 33,
		i = 29,
		z = 4,
		["3"] = 26,
		f = 62,
		["/"] = 56,
		E = 13,
		n = 30,
		c = 18,
		p = 49,
		g = 12,
		["6"] = 45,
		F = 14,
		r = 11,
		d = 50,
		s = 1,
		Z = 20,
		["1"] = 31,
		M = 46,
		["+"] = 10,
		w = 61,
		H = 47,
		S = 41,
		y = 23,
		["8"] = 42
	}
	local t3 = {
		["<"] = 37,
		d = 80,
		J = 74,
		[")"] = 28,
		["-"] = 31,
		P = 61,
		q = 64,
		["^"] = 19,
		["5"] = 51,
		u = 17,
		t = 72,
		["8"] = 78,
		["\\"] = 40,
		W = 46,
		V = 32,
		N = 50,
		["0"] = 5,
		B = 14,
		G = 1,
		["?"] = 36,
		["2"] = 22,
		["["] = 81,
		D = 30,
		C = 8,
		Z = 48,
		[">"] = 60,
		L = 21,
		m = 45,
		g = 24,
		["$"] = 71,
		E = 55,
		I = 29,
		["\""] = 2,
		e = 34,
		a = 41,
		["6"] = 76,
		["!"] = 67,
		["]"] = 49,
		["#"] = 39,
		["/"] = 52,
		Y = 35,
		["*"] = 69,
		n = 23,
		f = 83,
		["1"] = 75,
		s = 59,
		["="] = 10,
		["%"] = 63,
		["3"] = 3,
		l = 79,
		["@"] = 82,
		["."] = 27,
		[";"] = 26,
		R = 9,
		k = 54,
		h = 73,
		M = 56,
		[","] = 77,
		X = 33,
		["7"] = 57,
		["("] = 0,
		U = 62,
		["`"] = 20,
		Q = 11,
		[":"] = 16,
		_ = 58,
		p = 43,
		A = 13,
		b = 18,
		j = 25,
		["4"] = 66,
		["&"] = 47,
		S = 4,
		["\'"] = 7,
		O = 53,
		T = 70,
		c = 84,
		H = 44,
		i = 42,
		["+"] = 12,
		o = 68,
		["9"] = 65,
		K = 38,
		r = 6,
		F = 15
	}

	for i = 1, #t1 do
		local v20 = t1[i]

		if type_(v20) == "string" then
			local v21 = sub(v20, 1, 1)

			if v21 == "i" then
				local v22 = sub(v20, 2)
				local v23 = len(v22)
				local n1 = 1
				local n2 = 0
				local n3 = 0
				local t4 = {}

				while n1 <= v23 do
					local v28 = sub(v22, n1, n1)
					local v29 = t2[v28]

					if v29 then
						n3 = n3 + v29 * 64 ^ (3 - n2)
						n2 = n2 + 1

						if n2 == 4 then
							insert(t4, (char(floor(n3 / 65536), floor(n3 % 65536 / 256), n3 % 256)))
							n2 = 0
							n3 = 0
						end
					elseif v28 == "=" then
						insert(t4, (char((floor(n3 / 65536)))))

						if v23 <= n1 or sub(v22, n1 + 1, n1 + 1) ~= "=" then
							insert(t4, (char((floor(n3 % 65536 / 256)))))
						end

						break
					end

					n1 = n1 + 1
				end

				t1[i] = concat(t4)
			elseif v21 == "4" then
				local v30 = sub(v20, 2)
				local v31 = len(v30)
				local n4 = 1
				local t5 = {}

				while n4 <= v31 do
					local v34 = v31 - n4 + 1
					local v35 = v34 >= 5 and 5 or v34
					local v36 = v35 > 1
					local n5 = 0

					for i2 = 0, 4 do
						local v39 = i2 >= v35 or t3[sub(v30, n4 + i2, n4 + i2)]

						if not v39 then
							v36 = false

							break
						end

						n5 = n5 * 85 + v39
					end

					if v36 then
						local v40 = floor(n5 / 16777216) % 256
						local v41 = floor(n5 / 65536) % 256
						local v42 = floor(n5 / 256) % 256
						local v43 = n5 % 256

						if v35 == 5 then
							insert(t5, (char(v40, v41, v42, v43)))
						elseif v35 == 4 then
							insert(t5, (char(v40, v41, v42)))
						elseif v35 == 3 then
							insert(t5, (char(v40, v41)))
						elseif v35 == 2 then
							insert(t5, (char(v40)))
						end
					end

					n4 = n4 + v35
				end

				t1[i] = concat(t5)
			end
		end
	end

	local t6 = {
		"__len",
		"__index",
		"#",
		"n",
		"__gc"
	}
	local unpack_ = unpack or table.unpack
	local t7 = {}
	local v47 = t6[4]
	local v48 = t6[3]

	t7[v47] = select(v48, ...)
	__set_list(t7, 1, {...})

	return (function(p1, p2, p3, _, p4, p5, p6, _, p7, p8, p9, p10, _, p11, p12, p13, _, _, p14, p15, p16, p17, _)
		local function v49(...)
			return {
				[t6[4]] = p4(t6[3], ...),
				...
			}
		end
		local function v50(p18)
			return p1(p18, 1, p18[t6[4]])
		end
		local function v51(p19, _, _, p20, p21)
			local v52 = nil

			while p19 do
				p13(p21.print, p21, "Hello, World!")
				v52 = p16()
				p19 = nil
			end

			local _ = #p20

			return p17(v52)
		end
		local function v54(p22, p23, p24)
			local v55 = p12(p23)

			local function v56(...)
				return p11(p22, p16(...), p23, v55, p7 and p7(1) or p24)
			end

			if not p8 then
				return v56
			end

			p8(v56, p24)

			return v56
		end
		local function _(p25)
			for i = 1, #p25 do
				p10[p25[i]] = p10[p25[i]] + 1
			end

			if not p6 then
				return p3({}, {
					[t6[5]] = p14,
					[t6[2]] = p25,
					[t6[1]] = function()
						return 17414
					end
				})
			end

			local v59 = p6(true)
			local v60 = p5(v59)
			local v61 = t6[2]
			local v62 = t6[5]
			local v63 = t6[1]
			local v64 = p14

			v60[v61] = p25
			v60[v62] = v64
			v60[v63] = function()
				return 17414
			end

			return v59
		end
		local function _(p26)
			local v66 = p26[1]
			local n6 = 1

			while v66 do
				local v68 = p10
				local v69 = p10[v66] - 1

				n6 = n6 + 1
				v68[v66] = v69

				if p10[v66] == 0 then
					local v70 = p15

					p10[v66] = nil
					v70[v66] = nil
				end

				v66 = p26[n6]
			end
		end
		local function _(p27, p28, ...)
			if p7 and p27 == p7 then
				local v72 = ...

				if v72 == nil or v72 == 1 then
					return p28
				else
					return p27(...)
				end
			else
				return p27(...)
			end
		end

		local _ = {}
		local _ = {}
		local _ = v49
		local v76 = v50
		local _ = v51

		return v54(4192337, {}, p9)(v76(p2))
	end)(unpack_, t7, setmetatable, error, select, getmetatable, newproxy, tonumber, getfenv, setfenv, getfenv and getfenv() or _ENV)
end)(...)
