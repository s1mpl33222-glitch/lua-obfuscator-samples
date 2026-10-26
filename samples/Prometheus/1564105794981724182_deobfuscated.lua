-- This file was generated at discord.gg/syncrypt

local v1, v2, v3 = ipairs({
	{ "isfile", isfile },
	{ "writefile", writefile },
	{ "getcustomasset", getcustomasset },
	{ "makefolder", makefolder },
	{ "isfolder", isfolder }
})
local t1 = {}
local v5 = false
local v6 = true
local s1 = "{\n  \"replacement_rules\": [\n    { \"name\": \"Profile 4\", \"replace_ids\": [12307734932], \"mode\": \"cdn\", \"enabled\": true, \"scale\": 2.8, \"texture_id\": 75176051489642, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-leftV2.obj\" },\n    { \"name\": \"Profile 5\", \"replace_ids\": [12307583853], \"mode\": \"cdn\", \"enabled\": true, \"scale\": 2.8, \"texture_id\": 75176051489642, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-rightV2.obj\" },\n    { \"name\": \"Profile 6\", \"replace_ids\": [144076357], \"mode\": \"id\", \"enabled\": true, \"with_id\": 75176051489642 },\n    { \"name\": \"ar body\",  \"replace_ids\": [12613284036], \"mode\": \"local\", \"enabled\": true, \"native_size\": true, \"scale\": 1.35, \"local_path\": \"Vandal/reaver_body.mesh\" },\n    { \"name\": \"ar upper\", \"replace_ids\": [12613284249], \"mode\": \"local\", \"enabled\": true, \"native_size\": true, \"scale\": 1.35, \"local_path\": \"Vandal/reaver_bits.mesh\" },\n    { \"name\": \"ar bolt\",  \"replace_ids\": [12613283355], \"mode\": \"local\", \"enabled\": true, \"native_size\": true, \"scale\": 1.35, \"local_path\": \"Vandal/reaver_bolt.mesh\" },\n    { \"name\": \"ar mag\",   \"replace_ids\": [12613284529], \"mode\": \"local\", \"enabled\": true, \"native_size\": true, \"scale\": 1.35, \"local_path\": \"Vandal/reaver_mag.mesh\" },\n    { \"name\": \"ar hide\",  \"replace_ids\": [12613283569, 14652718299, 12613284768], \"mode\": \"id\", \"enabled\": true },\n    { \"name\": \"ar shoot\", \"replace_ids\": [13087362838], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://github.com/randomck23/Reaver-Vandel/raw/refs/heads/main/reaver%20shoot.mp3\" },\n    { \"name\": \"ar reload1\", \"replace_ids\": [13236549929, 13236549962], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://github.com/randomck23/Reaver-Vandel/raw/refs/heads/main/reaver%20load1.mp3\" },\n    { \"name\": \"ar reload2\", \"replace_ids\": [13455395017], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://github.com/randomck23/Reaver-Vandel/raw/refs/heads/main/reaver%20load2.mp3\" },\n    { \"name\": \"sinper\", \"replace_ids\": [13188892651, 14002915797, 14774727092, 13188893017, 13188893115, 14778413014, 13270206222, 13455394948, 13188892855, 13188893310], \"mode\": \"id\", \"enabled\": true },\n    { \"name\": \"sinper\", \"replace_ids\": [13188892761], \"mode\": \"cdn\", \"enabled\": true, \"splat\": true, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/chamber-sinper/main.obj\" },\n    { \"name\": \"sinper\", \"replace_ids\": [13270206087], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/sound/Preview_TourDeForce_Fire_FP_Full.wav\" },\n    { \"name\": \"sinper\", \"replace_ids\": [13188892532], \"mode\": \"id\", \"enabled\": true },\n    { \"name\": \"sinper\", \"replace_ids\": [13269934368], \"mode\": \"id\", \"enabled\": true, \"with_id\": 89426100452654 },\n    { \"name\": \"sinper\", \"replace_ids\": [13188893310, 13455229188, 13455229044, 13455394948], \"mode\": \"id\", \"enabled\": true },\n    { \"name\": \"dagg\", \"replace_ids\": [73385702554774], \"mode\": \"cdn\", \"enabled\": true, \"splat\": true, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/jett-dagger/main.obj\" },\n    { \"name\": \"dagg\", \"replace_ids\": [124614507878585], \"mode\": \"id\", \"enabled\": true },\n    { \"name\": \"dagg\", \"replace_ids\": [119886777451265], \"mode\": \"id\", \"enabled\": true, \"with_id\": 95318866540833 },\n    { \"name\": \"dagg\", \"replace_ids\": [129248911141724], \"mode\": \"id\", \"enabled\": true, \"with_id\": 92527815421098 },\n    { \"name\": \"dagg\", \"replace_ids\": [107117835992268], \"mode\": \"id\", \"enabled\": true, \"with_id\": 111373555305620 },\n    { \"name\": \"dagg\", \"replace_ids\": [76331161535117], \"mode\": \"id\", \"enabled\": true, \"with_id\": 138921174963297 },\n    { \"name\": \"dagg\", \"replace_ids\": [136507313237137], \"mode\": \"id\", \"enabled\": true, \"with_id\": 95472048087093 },\n    { \"name\": \"dagg\", \"replace_ids\": [91782309305074], \"mode\": \"id\", \"enabled\": true, \"with_id\": 77149665703840 },\n    { \"name\": \"dagg\", \"replace_ids\": [99837158417289], \"mode\": \"id\", \"enabled\": true },\n    { \"name\": \"dagg\", \"replace_ids\": [101759165907297], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/sound/Wushu_AbilX_Cast_Dagger_1P_01.wav\" },\n    { \"name\": \"dagg\", \"replace_ids\": [76357741438822], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/sound/Wushu_AbilX_Cast_Dagger_1P_03.wav\" },\n    { \"name\": \"ar icon 1\", \"replace_ids\": [17160682738], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://github.com/randomck23/Reaver-Vandel/blob/main/reaver%20vandel%20thumbnail.png?raw=true\" },\n    { \"name\": \"ar icon 2\", \"replace_ids\": [13197584241], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://github.com/randomck23/Reaver-Vandel/blob/main/reaver%20vandel%20thumbnail%202.png?raw=true\" },\n    { \"name\": \"dagger\", \"replace_ids\": [91885384580845], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/jett-dagger/daggers.png\" },\n    { \"name\": \"sinper\", \"replace_ids\": [17160799574], \"mode\": \"cdn\", \"enabled\": true, \"cdn_url\": \"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/chamber-sinper/sniper.png\" }\n  ]\n}\n"
local v8 = true

while true do
	local v9

	v3, v9 = v1(v2, v3)

	if not v3 then
		break
	end

	local v10 = v9[2]

	if type(v10) ~= "function" then
		t1[#t1 + 1] = v9[1]
	end
end

if #t1 > 0 then
	warn("[Valorant] Delta is missing: " .. table.concat(t1, ", ") .. " - cannot run")

	return
end

if not isfolder("AWildcat") then
	pcall(makefolder, "AWildcat")
end

if not isfolder("AWildcat/valorant") then
	pcall(makefolder, "AWildcat/valorant")
end

if v5 then
	v5 = listfiles

	if v5 then
		v5 = delfile
	end
end

if v5 then
	for _, v in ipairs(listfiles("AWildcat/valorant")) do
		pcall(delfile, v)
	end

	print("[Valorant] cache cleared")
end

local function v13(p1)
	local t2 = {}
	local t3 = {}
	local t4 = {}

	local function v17(p2, p3)
		if p2 == nil and true or p2 == "" then
			return nil
		else
			local v18 = tonumber(p2)

			if v18 then
				if v18 < 0 then
					return p3 + v18 + 1
				else
					return v18
				end
			else
				return nil
			end
		end
	end

	local v19, v20, v21 = p1:gmatch("[^\r\n]+")

	local function v22(p4, p5, p6)
		local v23 = t2[v17(p4, #t2) or 0]

		if v23 then
			local v24 = t4
			local v25 = #t4
			local v26, v27

			if p6 == nil and true or p6 == "" then
				v26 = nil
			else
				v26 = tonumber(p6)

				if v26 then
					if not (v26 < 0) then
						v31 = v24[v26 or 0] or { 0, 1, 0 }
						v32 = t3
						v33 = #t3

						if p5 == nil and true or p5 == "" then
							v27 = nil
						else
							v27 = tonumber(p5)

							if v27 then
								if not (v27 < 0) then
									v34 = v32[v27 or 0] or { 0, 0 }

									return string.format("[%.5f,%.5f,%.5f][%.4f,%.4f,%.4f][%.5f,%.5f,0]", v23[1], v23[2], v23[3], v31[1], v31[2], v31[3], v34[1], 1 - v34[2])
								end

								v27 = v33 + v27 + 1
							else
								v27 = nil
							end
						end

						v34 = v32[v27 or 0] or { 0, 0 }

						return string.format("[%.5f,%.5f,%.5f][%.4f,%.4f,%.4f][%.5f,%.5f,0]", v23[1], v23[2], v23[3], v31[1], v31[2], v31[3], v34[1], 1 - v34[2])
					end

					v26 = v25 + v26 + 1
				else
					v26 = nil
				end
			end

			local v28 = v24[v26 or 0] or { 0, 1, 0 }
			local v29 = t3
			local v30 = #t3

			if p5 == nil and true or p5 == "" then
				v27 = nil
			else
				v27 = tonumber(p5)

				if v27 then
					if not (v27 < 0) then
						v34 = v29[v27 or 0] or { 0, 0 }

						return string.format("[%.5f,%.5f,%.5f][%.4f,%.4f,%.4f][%.5f,%.5f,0]", v23[1], v23[2], v23[3], v28[1], v28[2], v28[3], v34[1], 1 - v34[2])
					end

					v27 = v30 + v27 + 1
				else
					v27 = nil
				end
			end

			local v35 = v29[v27 or 0] or { 0, 0 }

			return string.format("[%.5f,%.5f,%.5f][%.4f,%.4f,%.4f][%.5f,%.5f,0]", v23[1], v23[2], v23[3], v28[1], v28[2], v28[3], v35[1], 1 - v35[2])
		else
			return nil
		end
	end

	local t5 = {}
	local n1 = 0
	local n2 = 0

	while true do
		v21 = v19(v20, v21)

		if not v21 then
			break
		end

		local v36 = v21:sub(1, 2)

		if v36 == "v " then
			local match, v37, v38 = v21:match("^v%s+(%S+)%s+(%S+)%s+(%S+)")

			t2[#t2 + 1] = { tonumber(match) or 0, tonumber(v37) or 0, tonumber(v38) or 0 }
		elseif v36 == "vt" then
			local match, v40 = v21:match("^vt%s+(%S+)%s+(%S+)")

			t3[#t3 + 1] = { tonumber(match) or 0, tonumber(v40) or 0 }
		elseif v36 == "vn" then
			local match, v42, v43 = v21:match("^vn%s+(%S+)%s+(%S+)%s+(%S+)")

			t4[#t4 + 1] = { tonumber(match) or 0, tonumber(v42) or 1, tonumber(v43) or 0 }
		elseif v36 == "f " then
			local t6 = {}

			for match in v21.gmatch(v21, "%S+") do
				if match ~= "f" then
					local match2, v47, v48 = match:match("^(%-?%d+)/?(%-?%d*)/?(%-?%d*)")

					if match2 then
						match2 = v22(match2, v47, v48)
					end

					if match2 then
						t6[#t6 + 1] = match2
					end
				end
			end

			for i = 2, #t6 - 1 do
				local v50 = t6[1]

				t5[#t5 + 1] = v50

				local v51 = t6[i]

				t5[#t5 + 1] = v51

				local v52 = t6[i + 1]

				t5[#t5 + 1] = v52
				n1 = n1 + 1
			end

			n2 = n2 + 1

			if n2 % 4000 == 0 then
				task.wait()
			end
		end
	end

	if n1 == 0 then
		return nil, 0
	else
		return "version 1.00\n" .. n1 .. "\n" .. table.concat(t5), n1
	end
end
local function v53(p7)
	local n3 = 5381

	for i = 1, #p7 do
		n3 = (n3 * 33 + p7:byte(i)) % 4294967296
	end

	return string.format("%08x", n3)
end
local function v56(p8)
	local ok, result = pcall(function()
		return game:HttpGet(p8)
	end)

	if ok then
		if type(result) == "string" then
			ok = #result > 0
		else
			ok = false
		end
	end

	if ok then
		return result
	end

	local request_ = request

	if not request_ then
		request_ = http_request

		if not request_ then
			request_ = syn

			if request_ then
				request_ = syn.request
			end
		end
	end

	if not request_ then
		return nil
	end

	local ok2, result2 = pcall(request_, {
		Url = p8,
		Method = "GET"
	})

	if ok2 then
	elseif ok2 then
		return result2.Body
	else
		return nil
	end

	if result2 then
		ok2 = result2.StatusCode == 200

		if ok2 then
		elseif ok2 then
			return result2.Body
		else
			return nil
		end

		local Body = result2.Body

		if type(Body) == "string" then
			ok2 = #result2.Body > 0
		else
			ok2 = false
		end
	else
		ok2 = result2
	end

	if ok2 then
		return result2.Body
	else
		return nil
	end
end

local t7 = {
	cached = 0,
	downloaded = 0,
	failed = 0
}

local function v64(p9)
	for _ = 1, 5 do
		if isfile(p9) then
			local ok, result = pcall(getcustomasset, p9)

			if ok and result then
				return result
			end
		end

		task.wait(0.3)
	end

	return nil
end

local t8 = {}
local t9 = {}
local t10 = {}
local s2 = "AWildcat/valorant/splat_v1.png"

local function v72(p10)
	if t9[p10] then
		return t9[p10]
	else
		local v73 = p10:gsub("%?.*$", "")
		local match = v73:match("[^/]+$") or v73
		local v75 = (v73:match("%.(%w+)$") or "bin"):lower()
		local v76

		if v75 == "obj" then
			v76 = v6
		else
			v76 = false
		end

		local v77 = "AWildcat/valorant" .. "/" .. v53(p10) .. "." .. (v76 and "mesh" or v75)

		if isfile(v77) then
			local v78 = t7
			local s3 = "cached"

			v78[s3] = v78[s3] + 1
		else
			print("[Valorant] downloading " .. match)

			local v80 = v56(p10)

			if not v80 then
				local v81 = t7
				local s4 = "failed"

				v81[s4] = v81[s4] + 1
				t8[#t8 + 1] = match .. " (download failed)"

				return nil
			end

			local v83 = #v80 < 200

			if v83 then
				v83 = v80:find("404")
			end

			if v83 then
				local v84 = t7
				local s5 = "failed"

				v84[s5] = v84[s5] + 1
				t8[#t8 + 1] = match .. " (404 not found)"

				return nil
			end

			if v76 then
				local v86

				v80, v86 = v13(v80)

				if not v80 then
					local v87 = t7
					local s6 = "failed"

					v87[s6] = v87[s6] + 1
					t8[#t8 + 1] = match .. " (no faces in obj)"

					return nil
				end

				print(("[Valorant] %s -> %d triangles").format("[Valorant] %s -> %d triangles", match, v86))

				if v86 > 20000 then
					warn("[Valorant] " .. match .. " has over 20k triangles, Roblox may refuse it")
				end
			end

			if not pcall(writefile, v77, v80) then
				local v89 = t7
				local s7 = "failed"

				v89[s7] = v89[s7] + 1
				t8[#t8 + 1] = match .. " (could not save)"

				return nil
			end

			local v91 = t7
			local s8 = "downloaded"

			v91[s8] = v91[s8] + 1
		end

		local v93 = v64(v77)

		if v93 then
			t9[p10] = v93

			return v93
		else
			local v94 = t7
			local s9 = "failed"

			v94[s9] = v94[s9] + 1
			t8[#t8 + 1] = match .. " (getcustomasset failed)"

			return nil
		end
	end
end

for i = 0, 255 do
	local _ = i

	for _ = 1, 8 do
		local v99

		if bit32.band(v99, 1) == 1 then
			local v100 = bit32.rshift(v99, 1)

			v99 = bit32.bxor(3988292384, v100)
		else
			v99 = bit32.rshift(v99, 1)
		end
	end

	t10[UNNAMED_2199032751976] = i
end

local function v101(p11)
	local v102 = #p11
	local n4 = 1
	local n5 = 4294967295
	local n6 = 0

	while n4 <= v102 do
		local v106 = math.min(n4 + 2047, v102)
		local t11 = { string.byte(p11, n4, v106) }

		for i = 1, #t11 do
			local v109 = t10
			local v110 = bit32.band(n5, 255)
			local v111 = t11[i]
			local v112 = v109[bit32.bxor(v110, v111)]
			local v113 = bit32.rshift(n5, 8)

			n5 = bit32.bxor(v112, v113)
		end

		n4 = v106 + 1
		n6 = n6 + 1

		if n6 % 64 == 0 then
			task.wait()
		end
	end

	return bit32.bxor(n5, 4294967295)
end
local function v114(p12)
	local v115 = #p12
	local n7 = 1
	local n8 = 1
	local n9 = 0

	while n7 <= v115 do
		local v119 = math.min(n7 + 2047, v115)
		local t12 = { string.byte(p12, n7, v119) }

		for i = 1, #t12 do
			n8 = n8 + t12[i]
			n9 = n9 + n8
		end

		n8 = n8 % 65521
		n9 = n9 % 65521
		n7 = v119 + 1
	end

	return n9 * 65536 + n8
end

local v122 = nil

local function v123(p13)
	local v124 = #p13
	local n10 = 1
	local t13 = { "x\1" }

	while n10 <= v124 do
		local v127 = n10 + 65534
		local v128 = math.min(v127, v124)
		local v129 = v128 - n10 + 1
		local v130 = 65535 - v129
		local v131 = #t13 + 1
		local v132 = v128 == v124 and 1 or 0
		local v133 = v129 % 256
		local v134 = v129 / 256
		local v135 = math.floor(v134)
		local v136 = v130 % 256
		local v137 = v130 / 256
		local v138 = math.floor(v137)

		t13[v131] = string.char(v132, v133, v135, v136, v138)
		t13[#t13 + 1] = p13:sub(n10, v128)
		n10 = v128 + 1
	end

	t13[#t13 + 1] = v122(v114(p13))

	return table.concat(t13)
end

v122 = function(p14)
	local char = string.char
	local v140 = bit32.rshift(p14, 24)
	local v141 = bit32.band(v140, 255)
	local v142 = bit32.rshift(p14, 16)
	local v143 = bit32.band(v142, 255)
	local v144 = bit32.rshift(p14, 8)

	return char(v141, v143, bit32.band(v144, 255), (bit32.band(p14, 255)))
end

local function v145()
	local v146 = Random.new(20261011)
	local v147 = table.create(262144, 0)
	local v148 = nil

	local function v149(p15, p16, p17, p18)
		local v150 = p17 < 0.7 and 0.7 or p17
		local v151 = p15 + 0.5
		local v152 = math.floor(v151)
		local v153 = p16 + 0.5
		local v154 = math.floor(v153)
		local v155 = math.ceil(v150)
		local v156 = v150 * v150

		for i = -v155, v155 do
			local v158 = v156 - i * i

			if v158 >= 0 then
				local v159 = (v154 + i) % 512 * 512
				local v160 = math.sqrt(v158)
				local v161 = math.floor(v160)

				for i2 = -v161, v161 do
					v148[v159 + (v152 + i2) % 512 + 1] = p18
				end
			end
		end
	end

	v148 = v147

	local v163 = v148

	local function v164(p19, p20, p21, p22)
		v149(p19, p20, p21, 1)

		for _ = 1, v146:NextInteger(9, 16) do
			local v166 = v146
			local v167 = v166.NextNumber(v166) * 6.2832
			local v168 = math.cos(v167)
			local v169 = math.sin(v167)
			local v170 = v146
			local v171 = p21 * (0.7 + v170.NextNumber(v170) * 1.7)
			local v172 = v146
			local v173 = p21 * (0.14 + v172.NextNumber(v172) * 0.22)
			local v174 = math.max(1, v173 * 0.6)
			local v175 = p21 * 0.7
			local v176 = v175 + v171
			local v177 = v175

			while v175 < v176 do
				local v178 = (v175 - v177) / v171

				v149(p19 + v168 * v175, p20 + v169 * v175, v173 * (1 - 0.6 * v178), 1)
				v175 = v175 + v174
			end

			v149(p19 + v168 * v176, p20 + v169 * v176, v173 * (0.9 + v146:NextNumber() * 0.7), 1)

			local v179 = v176 + v173 * (2 + v146:NextNumber() * 4)
			local v180 = v149
			local v181 = p19 + v168 * v179
			local v182 = p20 + v169 * v179
			local v183 = v173 * (0.25 + v146:NextNumber() * 0.4)

			v180(v181, v182, math.max(1.2, v183), 1)
		end

		local v184 = p21 / 2

		for _ = 1, math.floor(v184) do
			local v186 = v146:NextNumber() * 6.2832
			local v187 = p21 * (1.3 + v146:NextNumber() * 2.6)
			local v188 = v149
			local v189 = p19 + math.cos(v186) * v187
			local v190 = p20 + math.sin(v186) * v187
			local v191 = p21 * (0.03 + v146:NextNumber() * 0.08)

			v188(v189, v190, math.max(1.2, v191), 1)
		end

		if not p22 then
			return
		end

		v149(p19, p20, p21 * 0.55, 2)
		v149(p19 + p21 * 0.25, p20 - p21 * 0.2, p21 * 0.28, 1)
	end

	for _ = 1, 7 do
		v164(v146:NextNumber() * 512, v146:NextNumber() * 512, 26 + v146:NextNumber() * 26, true)
	end

	for _ = 1, 10 do
		v164(v146:NextNumber() * 512, v146:NextNumber() * 512, 9 + v146:NextNumber() * 10, false)
	end

	for _ = 1, 140 do
		local v195 = v146:NextNumber()

		v149(v146:NextNumber() * 512, v146:NextNumber() * 512, 1.5 + v195 * v195 * 3.5, 1)
	end

	local t14 = {
		[0] = { 236, 232, 225 },
		[1] = { 255, 70, 85 },
		[2] = { 196, 40, 56 }
	}
	local t15 = {}

	for i = 0, 512 - 1 do
		local v199 = i * 512
		local _ = i
		local n11 = 1
		local t16 = { 0 }

		for i2 = 1, 512 do
			local v204 = t14[v163[v199 + i2]]
			local v205 = n11 + 2
			local v206 = n11 + 3
			local v207 = v204[1]
			local v208 = v204[2]
			local v209 = v204[3]

			t16[n11 + 1] = v207
			t16[v205] = v208
			n11 = n11 + 3
			t16[v206] = v209
		end

		local v210 = #t15 + 1
		local unpack = table.unpack

		t15[v210] = string.char(unpack(t16))

		if i % 64 == 0 then
			task.wait()
		end
	end

	local v212 = v122(512) .. v122(512) .. "\8\2\0\0\0"
	local v213 = v122(#v212) .. "IHDR" .. v212 .. v122(v101("IHDR" .. v212))
	local v214 = v123(table.concat(t15))

	return "\137PNG\r\n\26\n" .. v213 .. (v122(#v214) .. "IDAT" .. v214 .. v122(v101("IDAT" .. v214))) .. v122(0) .. "IEND" .. "" .. v122(v101("IEND"))
end

local u215 = nil

local function v216()
	if not isfile(s2) then
		print("[Valorant] making splat texture (first run only)")

		local ok, result = pcall(v145)

		if not (ok and result) then
			warn("[Valorant] splat texture failed: " .. tostring(result))

			return
		end

		if not pcall(writefile, s2, result) then
			warn("[Valorant] could not save splat texture")

			return
		end
	end

	u215 = v64(s2)

	if u215 then
		return
	end

	warn("[Valorant] splat texture could not be loaded")
end

local game_ = game
local v220 = game_.GetService(game_, "HttpService")
local AssetService = game:GetService("AssetService")
local replacement_rules = v220.JSONDecode(v220, s1).replacement_rules
local t17 = {}

local function v224(p23)
	local v225 = tostring(p23)

	if v225:find("^rbxasset://") then
		return nil
	else
		return tonumber(v225.match(v225, "(%d+)"))
	end
end

local t18 = {}
local n12 = 0

local function v228(p24)
	if p24.mode == "local" then
		local v229 = v64(p24.local_path)

		if v229 then
			return v229
		elseif p24.cdn_url then
			local warn_ = warn
			local local_path = p24.local_path

			warn_("[Valorant] " .. tostring(local_path) .. " not found in workspace, trying download")

			return v72(p24.cdn_url)
		else
			local v232 = t8
			local v233 = #t8 + 1
			local local_path = p24.local_path

			v232[v233] = tostring(local_path) .. " (not found in workspace)"

			return nil
		end
	elseif p24.mode == "cdn" then
		return v72(p24.cdn_url)
	else
		return not p24.with_id and "" or "rbxassetid://" .. p24.with_id
	end
end

local n13 = 0

local function v236(p25, p26)
	for _, v in ipairs(p25) do
		if v.type == "group" then
			v236(v.children or {}, p26)
		elseif v.enabled then
			p26[#p26 + 1] = v
		end
	end

	return p26
end

local v239 = v236(replacement_rules, {})
local v240 = u215
local t19 = {}
local v242 = false

for _, v in ipairs(v239) do
	if v.splat then
		v242 = true

		return
	end
end

if v242 then
	v216()
end

local u245 = #v239
local v246, v247, v248 = ipairs(v239)
local t20 = {}

while true do
	local v250

	v248, v250 = v246(v247, v248)

	if not v248 then
		break
	end

	task.spawn(function()
		local t21 = { pcall(v228, v250) }
		local v252 = t21[2]

		if not t21[1] then
			u245 = u245 - 1

			return
		end

		t20[v248] = v252
		u245 = u245 - 1
	end)
end

while u245 > 0 do
	task.wait()
end

for i, v in ipairs(v239) do
	local v255 = t20[i]

	if v255 ~= nil then
		n12 = n12 + 1

		local texture_id = v.texture_id

		if texture_id then
			texture_id = "rbxassetid://" .. v.texture_id
		end

		local v257 = texture_id or nil
		local v258 = v.mode == "local"

		if v258 then
			local local_path = v.local_path

			v258 = tostring(local_path):lower():find("%.mesh$") ~= nil
		end

		local scale = v.scale
		local t22 = {
			target = v255,
			scale = tonumber(scale) or 1,
			splat = v.splat == true,
			joints = v.scale_joints == true,
			baked = v258,
			texture = v257,
			native = v.native_size == true
		}

		if v258 then
			t19[v255] = true
		end

		for _, replaceId in ipairs(v.replace_ids) do
			local v264 = v224(replaceId)

			if v264 then
				t17[v264] = t22
			end
		end
	end
end

local v265, v266, v267 = pairs(t19)
local n14 = 0

while true do
	v267 = v265(v266, v267)

	if not v267 then
		break
	end

	local u269 = n14 + 1

	task.spawn(function()
		local function v270()
			t18[v267] = AssetService:CreateMeshPartAsync(v267)
		end

		pcall(v270)
		u269 = u269 - 1
	end)
	n14 = u269
end

local now = os.clock()

while true do
	local v272 = n14 > 0

	if v272 then
		v272 = os.clock() - now < 15
	end

	if not v272 then
		local print_ = print
		local cached = t7.cached
		local downloaded = t7.downloaded
		local failed = t7.failed

		print_(("[Valorant] rules ready: %d | cached: %d | downloaded: %d | failed: %d").format("[Valorant] rules ready: %d | cached: %d | downloaded: %d | failed: %d", n12, cached, downloaded, failed))

		for _, v in ipairs(t8) do
			warn("[Valorant] FAILED: " .. v)
		end

		local t23 = {
			MeshPart = { "MeshId", "TextureID" },
			SpecialMesh = { "MeshId", "TextureId" },
			Sound = { "SoundId" },
			Decal = { "Texture" },
			Texture = { "Texture" },
			ImageLabel = { "Image" },
			ImageButton = { "Image" },
			SurfaceAppearance = {
				"ColorMap",
				"NormalMap",
				"MetalnessMap",
				"RoughnessMap"
			}
		}
		local t24 = {
			Sound = true,
			ImageLabel = true,
			ImageButton = true
		}
		local obj = setmetatable({}, {
			__mode = "k"
		})
		local obj2 = setmetatable({}, {
			__mode = "k"
		})
		local obj3 = setmetatable({}, {
			__mode = "k"
		})
		local obj4 = setmetatable({}, {
			__mode = "k"
		})
		local obj5 = setmetatable({}, {
			__mode = "k"
		})
		local obj6 = setmetatable({}, {
			__mode = "k"
		})

		local function v287(p27, p28)
			if not p27:IsA("MeshPart") then
				pcall(function()
					p27.MeshId = p28
				end)

				return
			end

			if "both" ~= "apply" then
				pcall(function()
					p27.MeshId = p28
				end)
			end

			if "both" == "direct" then
				return
			end

			local function v288()
				local v289 = t18[p28]

				if v289 then
					p27:ApplyMesh(v289)

					return
				end

				v289 = AssetService:CreateMeshPartAsync(p28)
				t18[p28] = v289
				p27:ApplyMesh(v289)
			end

			local t25 = { pcall(v288) }
			local v291 = t25[2]

			if t25[1] then
				return
			end

			warn("[Valorant] ApplyMesh failed: " .. tostring(v291))
		end
		local function v292(p29)
			local v293 = nil

			local function v294()
				if v293:IsA("MeshPart") then
					v293.Transparency = 1

					return
				end

				if not v293:IsA("SpecialMesh") then
					return
				end

				v293.Scale = Vector3.new(0, 0, 0)
			end

			v293 = p29
			pcall(v294)
		end
		local function v295(p30, p31)
			return p30[p31]
		end
		local function v296(p32, p33)
			if not p33 then
				return
			end

			local v297 = p32.IsA(p32, "MeshPart")
			local v298 = nil

			local function v299()
				p32[v298] = p33
			end

			v298 = v297 and "TextureID" or "TextureId"
			pcall(v299)
			pcall(function()
				if v297 then
					p32.Color = Color3.new(1, 1, 1)
				else
					p32.VertexColor = Vector3.new(1, 1, 1)
				end
			end)

			local v300, v301, v302 = ipairs(p32:GetChildren())
			local v303 = v298

			while true do
				local v304

				v302, v304 = v300(v301, v302)

				if not v302 then
					break
				end

				if v304:IsA("SurfaceAppearance") then
					v304:Destroy()
				end
			end

			if obj2[p32] then
				return
			end

			obj2[p32] = true
			p32.ChildAdded:Connect(function(child)
				if not child:IsA("SurfaceAppearance") then
					return
				end

				task.defer(function()
					local function v305()
						child:Destroy()
					end

					pcall(v305)
				end)
			end)
			pcall(function()
				p32:GetPropertyChangedSignal(v303):Connect(function()
					if p32[v303] == p33 then
						return
					end

					pcall(function()
						p32[v303] = p33
					end)
				end)
			end)
		end

		local v306 = nil

		local function v307(p34, p35)
			local Model = p34:FindFirstAncestorOfClass("Model") or p34.Parent

			if not Model then
				return
			end

			local ok, result = pcall(function()
				return Model:GetDescendants()
			end)

			if not ok then
				return
			end

			for _, v in ipairs(result) do
				local isJointInstance = v:IsA("JointInstance")

				if isJointInstance then
					isJointInstance = not obj5[v]

					if isJointInstance then
						isJointInstance = v.Part0 == p34 or v.Part1 == p34
					end
				end

				if isJointInstance then
					obj5[v] = true
					pcall(function()
						v.C0 = v306(v.C0, p35)
						v.C1 = v306(v.C1, p35)
					end)
				end
			end
		end

		v306 = function(p36, p37)
			return CFrame.new(p36.Position * p37) * (p36 - p36.Position)
		end

		local function v314(p38, p39, p40, p41, p42)
			task.wait(0.1)

			local function v315()
				if p38:IsA("MeshPart") then
					local Size = obj3[p38]

					if not Size then
						Size = p38.Size
						obj3[p38] = Size
					end

					local v317 = p41

					if v317 then
					elseif v317 then
						p38.Size = v317.Size * p39

						return
					else
						p38.Size = Size * p39

						return
					end

					v317 = t18[p42]

					if v317 then
						p38.Size = v317.Size * p39

						return
					else
						p38.Size = Size * p39

						return
					end
				else
					if not p38:IsA("SpecialMesh") then
						return
					end

					local Scale = obj4[p38]

					if not Scale then
						Scale = p38.Scale
						obj4[p38] = Scale
					end

					p38.Scale = Scale * p39
				end
			end

			pcall(v315)

			if p40 then
				p40 = v8
			end

			if not p40 then
				return
			end

			v307(p38, p39)
		end
		local function v319(p43, p44, p45, p46)
			local target = p45.target

			n13 = n13 + 1

			if n13 <= 15 then
				print("[Valorant] swapped " .. p43.ClassName .. "." .. p44 .. " (" .. tostring(p46) .. ")")
			end

			if p44 == "MeshId" then
				if target == "" then
					v292(p43)

					return
				end

				v287(p43, target)

				if p45.baked then
					v296(p43, "")
				end

				if p45.splat then
					v296(p43, v240)
				end

				if p45.texture then
				elseif p45.scale == 1 then
					return
				else
					v314(p43, p45.scale, p45.joints, p45.native, target)

					return
				end

				v296(p43, p45.texture)
				obj6[p43] = p45.texture

				if p45.scale == 1 then
					return
				else
					v314(p43, p45.scale, p45.joints, p45.native, target)

					return
				end
			end

			pcall(function()
				p43[p44] = target
			end)
		end
		local function v321(p47, p48)
			local ok, result = pcall(v295, p47, p48)

			if not ok or result == "" then
				return false
			else
				local v324 = v224(result)
				local v325

				if v324 then
					v325 = t17[v324]
				else
					v325 = v324
				end

				if v325 then
					task.spawn(v319, p47, p48, v325, v324)

					return true
				else
					return false
				end
			end
		end
		local function v326(descendant)
			local v327 = t23[descendant.ClassName]

			if not v327 or obj[descendant] then
				return
			end

			obj[descendant] = true

			local v328 = t24[descendant.ClassName]

			for i = 1, #v327 do
				local v330 = v327[i]

				if v321(descendant, v330) or v328 then
					pcall(function()
						descendant:GetPropertyChangedSignal(v330):Connect(function()
							v321(descendant, v330)
						end)
					end)
				end
			end
		end

		task.spawn(function()
			while true do
				task.wait(0.25)

				for k, v in pairs(obj6) do
					if k.Parent then
						pcall(function()
							local v333 = k:IsA("MeshPart") and "TextureID" or "TextureId"

							if k[v333] ~= v then
								k[v333] = v
							end

							local isMeshPart = k:IsA("MeshPart")

							if isMeshPart then
								isMeshPart = k.Color ~= Color3.new(1, 1, 1)
							end

							if not isMeshPart then
								v372 = k

								for _, child in ipairs(v372.GetChildren(v372)) do
									if child:IsA("SurfaceAppearance") then
										child:Destroy()
									end
								end

								return
							end

							k.Color = Color3.new(1, 1, 1)

							local v337 = k

							for _, child in ipairs(v337.GetChildren(v337)) do
								if child:IsA("SurfaceAppearance") then
									child:Destroy()
								end
							end
						end)
					end
				end
			end
		end)
		game.DescendantAdded:Connect(v326)
		task.spawn(function()
			local ipairs_ = ipairs
			local game_2 = game
			local n15 = 0

			for _, descendant in ipairs_(game_2.GetDescendants(game_2)) do
				v326(descendant)
				n15 = n15 + 1

				if n15 % 1000 == 0 then
					task.wait()
				end
			end
		end)
		print("[Valorant] loaded")

		return
	end

	task.wait()
end
