-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local v2 = nil
local v3 = _VERSION ~= "Luau"

if not v3 then
	v3 = not game

	if not v3 then
		v3 = game

		if typeof(v3) == "Instance" then
			v3 = game.GetService
			v3 = typeof(v3) ~= "function" and true or not pcall(function()
				return game:GetService("Players").LocalPlayer
			end)
		else
			v3 = true
		end
	end
end

if v3 then
	return
end

local v4 = (function()
	local ok, result = pcall(function()
		return _ENV
	end)

	if ok and result then
		return result
	else
		local getfenv_ = getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return _G
		end
	end
end)()
local v8 = (function()
	local v9, v10 = v4.pcall(function()
		return _ENV
	end)

	if v9 and v10 then
		return v10
	else
		local getfenv_ = v4.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v4._G
		end
	end
end)()
local v12 = (function()
	local v13, v14 = v8.pcall(function()
		return _ENV
	end)

	if v13 and v14 then
		return v14
	else
		local getfenv_ = v8.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v8._G
		end
	end
end)()
local v16 = (function()
	local v17, v18 = v12.pcall(function()
		return _ENV
	end)

	if v17 and v18 then
		return v18
	else
		local getfenv_ = v12.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v12._G
		end
	end
end)()
local v20 = (function()
	local v21, v22 = v16.pcall(function()
		return _ENV
	end)

	if v21 and v22 then
		return v22
	else
		local getfenv_ = v16.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v16._G
		end
	end
end)()
local v24 = (function()
	local v25, v26 = v20.pcall(function()
		return _ENV
	end)

	if v25 and v26 then
		return v26
	else
		local getfenv_ = v20.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v20._G
		end
	end
end)()
local v28 = (function()
	local v29, v30 = v24.pcall(function()
		return _ENV
	end)

	if v29 and v30 then
		return v30
	else
		local getfenv_ = v24.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v24._G
		end
	end
end)()
local v32 = (function()
	local v33, v34 = v28.pcall(function()
		return _ENV
	end)

	if v33 and v34 then
		return v34
	else
		local getfenv_ = v28.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v28._G
		end
	end
end)()
local v36 = (function()
	local v37, v38 = v32.pcall(function()
		return _ENV
	end)

	if v37 and v38 then
		return v38
	else
		local getfenv_ = v32.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v32._G
		end
	end
end)()
local v40 = (function()
	local v41, v42 = v36.pcall(function()
		return _ENV
	end)

	if v41 and v42 then
		return v42
	else
		local getfenv_ = v36.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v36._G
		end
	end
end)()
local v44 = (function()
	local v45, v46 = v40.pcall(function()
		return _ENV
	end)

	if v45 and v46 then
		return v46
	else
		local getfenv_ = v40.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v40._G
		end
	end
end)()
local v48 = (function()
	local v49, v50 = v44.pcall(function()
		return _ENV
	end)

	if v49 and v50 then
		return v50
	else
		local getfenv_ = v44.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v44._G
		end
	end
end)()
local v52 = (function()
	local v53, v54 = v48.pcall(function()
		return _ENV
	end)

	if v53 and v54 then
		return v54
	else
		local getfenv_ = v48.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v48._G
		end
	end
end)()
local v56 = (function()
	local v57, v58 = v52.pcall(function()
		return _ENV
	end)

	if v57 and v58 then
		return v58
	else
		local getfenv_ = v52.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v52._G
		end
	end
end)()
local v60 = (function()
	local v61, v62 = v56.pcall(function()
		return _ENV
	end)

	if v61 and v62 then
		return v62
	else
		local getfenv_ = v56.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v56._G
		end
	end
end)()
local v64 = (function()
	local v65, v66 = v60.pcall(function()
		return _ENV
	end)

	if v65 and v66 then
		return v66
	else
		local getfenv_ = v60.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v60._G
		end
	end
end)()
local v68 = (function()
	local v69, v70 = v64.pcall(function()
		return _ENV
	end)

	if v69 and v70 then
		return v70
	else
		local getfenv_ = v64.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v64._G
		end
	end
end)()
local v72 = (function()
	local v73, v74 = v68.pcall(function()
		return _ENV
	end)

	if v73 and v74 then
		return v74
	else
		local getfenv_ = v68.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v68._G
		end
	end
end)()
local v76 = (function()
	local v77, v78 = v72.pcall(function()
		return _ENV
	end)

	if v77 and v78 then
		return v78
	else
		local getfenv_ = v72.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v72._G
		end
	end
end)()
local v80 = (function()
	local v81, v82 = v76.pcall(function()
		return _ENV
	end)

	if v81 and v82 then
		return v82
	else
		local getfenv_ = v76.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v76._G
		end
	end
end)()
local v84 = (function()
	local v85, v86 = v80.pcall(function()
		return _ENV
	end)

	if v85 and v86 then
		return v86
	else
		local getfenv_ = v80.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v80._G
		end
	end
end)()
local v88 = (function()
	local v89, v90 = v84.pcall(function()
		return _ENV
	end)

	if v89 and v90 then
		return v90
	else
		local getfenv_ = v84.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v84._G
		end
	end
end)()
local v92 = (function()
	local v93, v94 = v88.pcall(function()
		return _ENV
	end)

	if v93 and v94 then
		return v94
	else
		local getfenv_ = v88.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v88._G
		end
	end
end)()
local v96 = (function()
	local v97, v98 = v92.pcall(function()
		return _ENV
	end)

	if v97 and v98 then
		return v98
	else
		local getfenv_ = v92.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v92._G
		end
	end
end)()
local v100 = (function()
	local v101, v102 = v96.pcall(function()
		return _ENV
	end)

	if v101 and v102 then
		return v102
	else
		local getfenv_ = v96.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v96._G
		end
	end
end)()
local v104 = (function()
	local v105, v106 = v100.pcall(function()
		return _ENV
	end)

	if v105 and v106 then
		return v106
	else
		local getfenv_ = v100.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v100._G
		end
	end
end)()
local v108 = (function()
	local v109, v110 = v104.pcall(function()
		return _ENV
	end)

	if v109 and v110 then
		return v110
	else
		local getfenv_ = v104.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v104._G
		end
	end
end)()
local v112 = (function()
	local v113, v114 = v108.pcall(function()
		return _ENV
	end)

	if v113 and v114 then
		return v114
	else
		local getfenv_ = v108.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v108._G
		end
	end
end)()
local v116 = (function()
	local v117, v118 = v112.pcall(function()
		return _ENV
	end)

	if v117 and v118 then
		return v118
	else
		local getfenv_ = v112.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v112._G
		end
	end
end)()
local v120 = (function()
	local v121, v122 = v116.pcall(function()
		return _ENV
	end)

	if v121 and v122 then
		return v122
	else
		local getfenv_ = v116.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v116._G
		end
	end
end)()
local v124 = (function()
	local v125, v126 = v120.pcall(function()
		return _ENV
	end)

	if v125 and v126 then
		return v126
	else
		local getfenv_ = v120.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v120._G
		end
	end
end)()
local v128 = (function()
	local v129, v130 = v124.pcall(function()
		return _ENV
	end)

	if v129 and v130 then
		return v130
	else
		local getfenv_ = v124.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v124._G
		end
	end
end)()
local v132 = (function()
	local v133, v134 = v128.pcall(function()
		return _ENV
	end)

	if v133 and v134 then
		return v134
	else
		local getfenv_ = v128.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v128._G
		end
	end
end)()
local v136 = (function()
	local v137, v138 = v132.pcall(function()
		return _ENV
	end)

	if v137 and v138 then
		return v138
	else
		local getfenv_ = v132.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v132._G
		end
	end
end)()
local v140 = (function()
	local v141, v142 = v136.pcall(function()
		return _ENV
	end)

	if v141 and v142 then
		return v142
	else
		local getfenv_ = v136.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v136._G
		end
	end
end)()
local v144 = (function()
	local v145, v146 = v140.pcall(function()
		return _ENV
	end)

	if v145 and v146 then
		return v146
	else
		local getfenv_ = v140.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v140._G
		end
	end
end)()
local v148 = (function()
	local v149, v150 = v144.pcall(function()
		return _ENV
	end)

	if v149 and v150 then
		return v150
	else
		local getfenv_ = v144.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v144._G
		end
	end
end)()
local v152 = (function()
	local v153, v154 = v148.pcall(function()
		return _ENV
	end)

	if v153 and v154 then
		return v154
	else
		local getfenv_ = v148.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v148._G
		end
	end
end)()
local v156 = (function()
	local v157, v158 = v152.pcall(function()
		return _ENV
	end)

	if v157 and v158 then
		return v158
	else
		local getfenv_ = v152.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v152._G
		end
	end
end)()
local v160 = (function()
	local v161, v162 = v156.pcall(function()
		return _ENV
	end)

	if v161 and v162 then
		return v162
	else
		local getfenv_ = v156.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v156._G
		end
	end
end)()
local v164 = (function()
	local v165, v166 = v160.pcall(function()
		return _ENV
	end)

	if v165 and v166 then
		return v166
	else
		local getfenv_ = v160.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v160._G
		end
	end
end)()
local v168 = (function()
	local v169, v170 = v164.pcall(function()
		return _ENV
	end)

	if v169 and v170 then
		return v170
	else
		local getfenv_ = v164.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v164._G
		end
	end
end)()
local v172 = (function()
	local v173, v174 = v168.pcall(function()
		return _ENV
	end)

	if v173 and v174 then
		return v174
	else
		local getfenv_ = v168.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v168._G
		end
	end
end)()
local v176 = (function()
	local v177, v178 = v172.pcall(function()
		return _ENV
	end)

	if v177 and v178 then
		return v178
	else
		local getfenv_ = v172.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v172._G
		end
	end
end)()
local v180 = (function()
	local v181, v182 = v176.pcall(function()
		return _ENV
	end)

	if v181 and v182 then
		return v182
	else
		local getfenv_ = v176.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v176._G
		end
	end
end)()
local v184 = (function()
	local v185, v186 = v180.pcall(function()
		return _ENV
	end)

	if v185 and v186 then
		return v186
	else
		local getfenv_ = v180.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v180._G
		end
	end
end)()
local v188 = (function()
	local v189, v190 = v184.pcall(function()
		return _ENV
	end)

	if v189 and v190 then
		return v190
	else
		local getfenv_ = v184.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v184._G
		end
	end
end)()
local v192 = (function()
	local v193, v194 = v188.pcall(function()
		return _ENV
	end)

	if v193 and v194 then
		return v194
	else
		local getfenv_ = v188.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v188._G
		end
	end
end)()
local v196 = (function()
	local v197, v198 = v192.pcall(function()
		return _ENV
	end)

	if v197 and v198 then
		return v198
	else
		local getfenv_ = v192.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v192._G
		end
	end
end)()
local v200 = (function()
	local v201, v202 = v196.pcall(function()
		return _ENV
	end)

	if v201 and v202 then
		return v202
	else
		local getfenv_ = v196.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v196._G
		end
	end
end)()
local v204 = (function()
	local v205, v206 = v200.pcall(function()
		return _ENV
	end)

	if v205 and v206 then
		return v206
	else
		local getfenv_ = v200.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v200._G
		end
	end
end)()
local v208 = (function()
	local v209, v210 = v204.pcall(function()
		return _ENV
	end)

	if v209 and v210 then
		return v210
	else
		local getfenv_ = v204.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v204._G
		end
	end
end)()
local v212 = (function()
	local v213, v214 = v208.pcall(function()
		return _ENV
	end)

	if v213 and v214 then
		return v214
	else
		local getfenv_ = v208.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v208._G
		end
	end
end)()
local v216 = (function()
	local v217, v218 = v212.pcall(function()
		return _ENV
	end)

	if v217 and v218 then
		return v218
	else
		local getfenv_ = v212.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v212._G
		end
	end
end)()
local v220 = (function()
	local v221, v222 = v216.pcall(function()
		return _ENV
	end)

	if v221 and v222 then
		return v222
	else
		local getfenv_ = v216.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v216._G
		end
	end
end)()
local v224 = (function()
	local v225, v226 = v220.pcall(function()
		return _ENV
	end)

	if v225 and v226 then
		return v226
	else
		local getfenv_ = v220.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v220._G
		end
	end
end)()
local v228 = (function()
	local v229, v230 = v224.pcall(function()
		return _ENV
	end)

	if v229 and v230 then
		return v230
	else
		local getfenv_ = v224.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v224._G
		end
	end
end)()
local v232 = (function()
	local v233, v234 = v228.pcall(function()
		return _ENV
	end)

	if v233 and v234 then
		return v234
	else
		local getfenv_ = v228.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v228._G
		end
	end
end)()
local v236 = (function()
	local v237, v238 = v232.pcall(function()
		return _ENV
	end)

	if v237 and v238 then
		return v238
	else
		local getfenv_ = v232.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v232._G
		end
	end
end)()
local v240 = (function()
	local v241, v242 = v236.pcall(function()
		return _ENV
	end)

	if v241 and v242 then
		return v242
	else
		local getfenv_ = v236.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v236._G
		end
	end
end)()
local v244 = (function()
	local v245, v246 = v240.pcall(function()
		return _ENV
	end)

	if v245 and v246 then
		return v246
	else
		local getfenv_ = v240.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v240._G
		end
	end
end)()
local v248 = (function()
	local v249, v250 = v244.pcall(function()
		return _ENV
	end)

	if v249 and v250 then
		return v250
	else
		local getfenv_ = v244.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v244._G
		end
	end
end)()
local v252 = (function()
	local v253, v254 = v248.pcall(function()
		return _ENV
	end)

	if v253 and v254 then
		return v254
	else
		local getfenv_ = v248.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v248._G
		end
	end
end)()
local v256 = (function()
	local v257, v258 = v252.pcall(function()
		return _ENV
	end)

	if v257 and v258 then
		return v258
	else
		local getfenv_ = v252.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v252._G
		end
	end
end)()
local v260 = (function()
	local v261, v262 = v256.pcall(function()
		return _ENV
	end)

	if v261 and v262 then
		return v262
	else
		local getfenv_ = v256.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v256._G
		end
	end
end)()
local v264 = (function()
	local v265, v266 = v260.pcall(function()
		return _ENV
	end)

	if v265 and v266 then
		return v266
	else
		local getfenv_ = v260.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v260._G
		end
	end
end)()
local v268 = (function()
	local v269, v270 = v264.pcall(function()
		return _ENV
	end)

	if v269 and v270 then
		return v270
	else
		local getfenv_ = v264.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v264._G
		end
	end
end)()
local v272 = (function()
	local v273, v274 = v268.pcall(function()
		return _ENV
	end)

	if v273 and v274 then
		return v274
	else
		local getfenv_ = v268.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v268._G
		end
	end
end)()
local v276 = (function()
	local v277, v278 = v272.pcall(function()
		return _ENV
	end)

	if v277 and v278 then
		return v278
	else
		local getfenv_ = v272.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v272._G
		end
	end
end)()
local v280 = (function()
	local v281, v282 = v276.pcall(function()
		return _ENV
	end)

	if v281 and v282 then
		return v282
	else
		local getfenv_ = v276.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v276._G
		end
	end
end)()
local v284 = (function()
	local v285, v286 = v280.pcall(function()
		return _ENV
	end)

	if v285 and v286 then
		return v286
	else
		local getfenv_ = v280.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v280._G
		end
	end
end)()
local v288 = (function()
	local v289, v290 = v284.pcall(function()
		return _ENV
	end)

	if v289 and v290 then
		return v290
	else
		local getfenv_ = v284.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v284._G
		end
	end
end)()
local v292 = (function()
	local v293, v294 = v288.pcall(function()
		return _ENV
	end)

	if v293 and v294 then
		return v294
	else
		local getfenv_ = v288.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v288._G
		end
	end
end)()
local v296 = (function()
	local v297, v298 = v292.pcall(function()
		return _ENV
	end)

	if v297 and v298 then
		return v298
	else
		local getfenv_ = v292.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v292._G
		end
	end
end)()
local v300 = (function()
	local v301, v302 = v296.pcall(function()
		return _ENV
	end)

	if v301 and v302 then
		return v302
	else
		local getfenv_ = v296.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v296._G
		end
	end
end)()
local v304 = (function()
	local v305, v306 = v300.pcall(function()
		return _ENV
	end)

	if v305 and v306 then
		return v306
	else
		local getfenv_ = v300.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v300._G
		end
	end
end)()
local v308 = (function()
	local v309, v310 = v304.pcall(function()
		return _ENV
	end)

	if v309 and v310 then
		return v310
	else
		local getfenv_ = v304.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v304._G
		end
	end
end)()
local v312 = (function()
	local v313, v314 = v308.pcall(function()
		return _ENV
	end)

	if v313 and v314 then
		return v314
	else
		local getfenv_ = v308.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v308._G
		end
	end
end)()
local v316 = (function()
	local v317, v318 = v312.pcall(function()
		return _ENV
	end)

	if v317 and v318 then
		return v318
	else
		local getfenv_ = v312.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v312._G
		end
	end
end)()
local v320 = (function()
	local v321, v322 = v316.pcall(function()
		return _ENV
	end)

	if v321 and v322 then
		return v322
	else
		local getfenv_ = v316.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v316._G
		end
	end
end)()
local v324 = (function()
	local v325, v326 = v320.pcall(function()
		return _ENV
	end)

	if v325 and v326 then
		return v326
	else
		local getfenv_ = v320.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v320._G
		end
	end
end)()
local v328 = (function()
	local v329, v330 = v324.pcall(function()
		return _ENV
	end)

	if v329 and v330 then
		return v330
	else
		local getfenv_ = v324.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v324._G
		end
	end
end)()
local v332 = (function()
	local v333, v334 = v328.pcall(function()
		return _ENV
	end)

	if v333 and v334 then
		return v334
	else
		local getfenv_ = v328.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v328._G
		end
	end
end)()
local v336 = (function()
	local v337, v338 = v332.pcall(function()
		return _ENV
	end)

	if v337 and v338 then
		return v338
	else
		local getfenv_ = v332.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v332._G
		end
	end
end)()
local v340 = (function()
	local v341, v342 = v336.pcall(function()
		return _ENV
	end)

	if v341 and v342 then
		return v342
	else
		local getfenv_ = v336.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v336._G
		end
	end
end)()
local v344 = (function()
	local v345, v346 = v340.pcall(function()
		return _ENV
	end)

	if v345 and v346 then
		return v346
	else
		local getfenv_ = v340.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v340._G
		end
	end
end)()
local v348 = (function()
	local v349, v350 = v344.pcall(function()
		return _ENV
	end)

	if v349 and v350 then
		return v350
	else
		local getfenv_ = v344.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v344._G
		end
	end
end)()
local v352 = (function()
	local v353, v354 = v348.pcall(function()
		return _ENV
	end)

	if v353 and v354 then
		return v354
	else
		local getfenv_ = v348.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v348._G
		end
	end
end)()
local v356 = (function()
	local v357, v358 = v352.pcall(function()
		return _ENV
	end)

	if v357 and v358 then
		return v358
	else
		local getfenv_ = v352.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v352._G
		end
	end
end)()
local v360 = (function()
	local v361, v362 = v356.pcall(function()
		return _ENV
	end)

	if v361 and v362 then
		return v362
	else
		local getfenv_ = v356.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v356._G
		end
	end
end)()
local v364 = (function()
	local v365, v366 = v360.pcall(function()
		return _ENV
	end)

	if v365 and v366 then
		return v366
	else
		local getfenv_ = v360.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v360._G
		end
	end
end)()
local v368 = (function()
	local v369, v370 = v364.pcall(function()
		return _ENV
	end)

	if v369 and v370 then
		return v370
	else
		local getfenv_ = v364.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v364._G
		end
	end
end)()
local v372 = (function()
	local v373, v374 = v368.pcall(function()
		return _ENV
	end)

	if v373 and v374 then
		return v374
	else
		local getfenv_ = v368.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v368._G
		end
	end
end)()
local v376 = (function()
	local v377, v378 = v372.pcall(function()
		return _ENV
	end)

	if v377 and v378 then
		return v378
	else
		local getfenv_ = v372.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v372._G
		end
	end
end)()
local v380 = (function()
	local v381, v382 = v376.pcall(function()
		return _ENV
	end)

	if v381 and v382 then
		return v382
	else
		local getfenv_ = v376.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v376._G
		end
	end
end)()
local v384 = (function()
	local v385, v386 = v380.pcall(function()
		return _ENV
	end)

	if v385 and v386 then
		return v386
	else
		local getfenv_ = v380.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v380._G
		end
	end
end)()
local v388 = (function()
	local v389, v390 = v384.pcall(function()
		return _ENV
	end)

	if v389 and v390 then
		return v390
	else
		local getfenv_ = v384.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v384._G
		end
	end
end)()

v3 = (function()
	local v392, v393 = v388.pcall(function()
		return _ENV
	end)

	if v392 and v393 then
		return v393
	else
		local getfenv_ = v388.getfenv

		if getfenv_ then
			return getfenv_(0)
		else
			return v388._G
		end
	end
end)()

local t1 = {
	1,
	3,
	5,
	7,
	9
}
local v396 = v3

for i = #t1, 1, -1 do
	t1[i] = t1[i] * 0 + 1
	v450 = v2 + t1[i]
end

local v398 = v3 + v2

v398 = { 108, 109, 110 }

for i = #v398, 1, -1 do
	t1 = v2 + v398[i] % 3
	v398[i] = 0
end

v398 = v3 + v2
v398 = { 769, 770, 771 }

for i = #v398, 1, -1 do
	t1 = v2 + v398[i] % 3
	v398[i] = 0
end

v398 = v3 + v2

local t2 = {
	[430] = 431
}
local v402 = v396.next(t2)

if v402 then
	v411 = t2[v402]
	t2[v402] = t2[v402] - t2[v402]
else
	v411 = 0
end

t2 = v398 + v411 + (function(p1)
	local n1 = 0

	for i = 1, #p1 do
		n1 = n1 + (p1[i] and 1 or 0)
	end

	return n1
end)({ true, false, true })
v402 = (function(p2)
	local n2 = 0

	for i = 1, #p2 do
		n2 = n2 + (p2[i] and 1 or 0)
	end

	return n2
end)({ true, false, true })
t2 = t2 + v402
t2 = {
	1,
	3,
	5,
	7,
	9
}

for i = #t2, 1, -1 do
	t2[i] = t2[i] * 0 + 1
	v2 = v402 + t2[i]
end

t2 = v398 + v402
t2 = {
	1,
	3,
	5,
	7,
	9
}

for i = #t2, 1, -1 do
	t2[i] = t2[i] * 0 + 1
	v2 = v402 + t2[i]
end

t2 = v398 + v402
t2 = { 708, 709, 710 }

local v409 = #t2

t1 = -1
v3 = t1 < 0
v409 = v409 - t1
v2 = 1

while true do
	v409 = v409 + t1
	v414 = ((not v3 or v2 > v409) and true or false) and not v3

	if v414 then
		v414 = v409 <= v2
	end

	if not v414 then
		break
	end

	v414 = v402 + t2[v409] % 3
	t2[v409] = 0
end

local v410 = v398 + v402

v3 = {}

for i = 1, 3 do
	v3[i] = i + t2
	v2 = v409 + v3[i]
end

for i = 1, #v3 do
	v3[i] = v3[i] - v3[i]
end

v410 = v398 + v409
v410 = { 980, 981, 982 }

for i = #v410, 1, -1 do
	t1 = v3 + v410[i] % 3
	v410[i] = 0
end

v410 = v398 + v3
t2 = (function(p3)
	local n3 = 0

	for i = 1, #p3 do
		n3 = n3 + (p3[i] and 1 or 0)
	end

	return n3
end)({ true, false, true })
v410 = v410 + t2
v410 = { 163, 164, 165 }

for i = #v410, 1, -1 do
	v3 = t2 + v410[i] % 3
	v410[i] = 0
end

v410 = v398 + t2
v398 = {
	[57] = 58
}
t2 = v396.next(v398)

if t2 then
	v402 = v398[t2]
	v398[t2] = v398[t2] - v398[t2]
else
	v402 = 0
end

v398 = v410 + v402
v398 = {
	1,
	3,
	5,
	7,
	9
}
t2 = #v398
v409 = -1
t1 = v409 < 0
t2 = t2 - v409
v3 = 1

while true do
	t2 = t2 + v409
	v2 = ((not t1 or v3 > t2) and true or false) and not t1

	if v2 then
		v2 = t2 <= v3
	end

	if not v2 then
		break
	end

	v398[t2] = v398[t2] * 0 + 1
	v2 = v402 + v398[t2]
end

v402 = v410 + v402
v3 = {}

for i = 1, 5 do
	v3[i] = i + v398
	v2 = t2 + v3[i]
end

for i = 1, #v3 do
	v3[i] = v3[i] - v3[i]
end

v402 = v410 + t2
v3 = {}

for i = 1, 3 do
	v3[i] = i + v398
	v2 = t2 + v3[i]
end

for i = 1, #v3 do
	v3[i] = v3[i] - v3[i]
end

v398 = v410 + t2
v409 = {}

for i = 1, 6 do
	v409[i] = { i, i + 590 }
	t1 = v3 + v409[i][1]
end

for i = #v409, 1, -1 do
	v409[i][1] = 0
end

v398 = v410 + v3
v398 = {
	1,
	3,
	5,
	7,
	9
}

for i = #v398, 1, -1 do
	v398[i] = v398[i] * 0 + 1
	t1 = v3 + v398[i]
end

v410 = v410 + v3 + (function(p4)
	local n4 = 0

	for i = 1, #p4 do
		n4 = n4 + (p4[i] and 1 or 0)
	end

	return n4
end)({ true, false, true }) + (function(p5)
	local n5 = 0

	for i = 1, #p5 do
		n5 = n5 + (p5[i] and 1 or 0)
	end

	return n5
end)({ true, false, true })
v398 = {
	[21] = 22
}
t2 = v396.next(v398)

if t2 then
	v402 = v398[t2]
	v398[t2] = v398[t2] - v398[t2]
else
	v402 = 0
end

v398 = v410 + v402
v398 = {
	1,
	3,
	5,
	7,
	9
}

for i = #v398, 1, -1 do
	v398[i] = v398[i] * 0 + 1
	v3 = v402 + v398[i]
end

v398 = v410 + v402
v398 = { 504, 505, 506 }

for i = #v398, 1, -1 do
	v3 = v402 + v398[i] % 3
	v398[i] = 0
end

v398 = v410 + v402
t1 = {}

for i = 1, 3 do
	t1[i] = { i, i + 278 }
	v3 = v402 + t1[i][1]
end

for i = #t1, 1, -1 do
	t1[i][1] = 0
end

v398 = v410 + v402
v398 = {
	1,
	3,
	5,
	7,
	9
}

for i = #v398, 1, -1 do
	v398[i] = v398[i] * 0 + 1
	v3 = v402 + v398[i]
end

v410 = v410 + v402 + (function(p6)
	local n6 = 0

	for i = 1, #p6 do
		n6 = n6 + (p6[i] and 1 or 0)
	end

	return n6
end)({ true, false, true })
v398 = {
	[410] = 411
}
t2 = v396.next(v398)

if t2 then
	v402 = v398[t2]
	v398[t2] = v398[t2] - v398[t2]
else
	v402 = 0
end

v398 = v410 + v402
v398 = { 550, 551, 552 }

for i = #v398, 1, -1 do
	v3 = v402 + v398[i] % 3
	v398[i] = 0
end

v398 = v410 + v402
t1 = {}

for i = 1, 2 do
	t1[i] = { i, i + 409 }
	v3 = v402 + t1[i][1]
end

for i = #t1, 1, -1 do
	t1[i][1] = 0
end

v398 = v410 + v402
v398 = {
	1,
	3,
	5,
	7,
	9
}

for i = #v398, 1, -1 do
	v398[i] = v398[i] * 0 + 1
	v3 = v402 + v398[i]
end

v398 = v410 + v402
v398 = {
	1,
	3,
	5,
	7,
	9
}
t2 = #v398
v409 = -1
t1 = v409 < 0
t2 = t2 - v409
v3 = 1

while true do
	t2 = t2 + v409
	v2 = ((not t1 or v3 > t2) and true or false) and not t1

	if v2 then
		v2 = t2 <= v3
	end

	if not v2 then
		v402 = v410 + v402
		v3 = {}

		for i = 1, 2 do
			v3[i] = i + v398
			v2 = t2 + v3[i]
		end

		for i = 1, #v3 do
			v3[i] = v3[i] - v3[i]
		end

		v398 = v410 + t2
		v398 = { 448, 449, 450 }

		for i = #v398, 1, -1 do
			t1 = v3 + v398[i] % 3
			v398[i] = 0
		end

		v398 = v410 + v3
		v398 = { 258, 259, 260 }

		for i = #v398, 1, -1 do
			t1 = v3 + v398[i] % 3
			v398[i] = 0
		end

		v410 = v410 + v3
		v398 = {
			[117] = 118
		}
		t2 = v396.next(v398)

		if t2 then
			v402 = v398[t2]
			v398[t2] = v398[t2] - v398[t2]
		else
			v402 = 0
		end

		v398 = v410 + v402
		t1 = {}

		for i = 1, 5 do
			t1[i] = { i, i + 109 }
			v3 = v402 + t1[i][1]
		end

		for i = #t1, 1, -1 do
			t1[i][1] = 0
		end

		v398 = v410 + v402
		v398 = { 339, 340, 341 }

		for i = #v398, 1, -1 do
			v3 = v402 + v398[i] % 3
			v398[i] = 0
		end

		v398 = v410 + v402
		v398 = {
			1,
			3,
			5,
			7,
			9
		}

		for i = #v398, 1, -1 do
			v398[i] = v398[i] * 0 + 1
			v3 = v402 + v398[i]
		end

		if v410 + v402 + (function(p7)
			local n7 = 0

			for i = 1, #p7 do
				n7 = n7 + (p7[i] and 1 or 0)
			end

			return n7
		end)({ true, false, true }) == (function()
			return 7102
		end)() then
			local v449 = (function()
				local v451, v452 = v396.pcall(function()
					return _ENV
				end)

				if v451 and v452 then
					return v452
				else
					local getfenv_ = v396.getfenv

					if getfenv_ then
						return getfenv_(0)
					else
						return v396._G
					end
				end
			end)()

			return (function(...)
				local v453 = true
				local t3 = { 24, 29, 30 }
				local n8 = 1

				while v453 do
					local v456 = t3[n8]

					if v456 == (function()
						return 24
					end)() then
						n8 = (function()
							return 2
						end)()
					else
						local n9

						if v456 == (function()
							return 29
						end)() then
							v456 = 0
							n8 = {
								[222] = 223
							}

							local v458 = v449.next(n8)

							if v458 then
								v466 = n8[v458]
								n8[v458] = n8[v458] - n8[v458]
							else
								v466 = 0
							end

							local v459 = v456 + v466
							local t4 = {}
							local n10 = 0

							for i = 1, 4 do
								t4[i] = { i, i + 648 }
								n10 = n10 + t4[i][1]
							end

							for i = #t4, 1, -1 do
								t4[i][1] = 0
							end

							n10 = v459 + n10
							t4 = {
								[972] = 973
							}
							v459 = v449.next(t4)

							if v459 then
								v458 = t4[v459]
								t4[v459] = t4[v459] - t4[v459]
							else
								v458 = 0
							end

							n10 = n10 + v458
							v456 = 609
							n8 = {}
							n9 = 0

							for i = 1, 2 do
								n8[i] = i + v456
								n9 = n9 + n8[i]
							end

							for i = 1, #n8 do
								n8[i] = n8[i] - n8[i]
							end

							n9 = n10 + n9 + (function(p8)
								local n11 = 0

								for i = 1, #p8 do
									n11 = n11 + (p8[i] and 1 or 0)
								end

								return n11
							end)({ true, false, true })
							v458 = {}
							v456 = 0

							for i = 1, 4 do
								v458[i] = { i, i + 51 }
								v456 = v456 + v458[i][1]
							end

							for i = #v458, 1, -1 do
								v458[i][1] = 0
							end

							n9 = n9 + v456
							n10 = { 374, 375, 376 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456
							v458 = 45
							v456 = {}
							n8 = 0

							for i = 1, 5 do
								v456[i] = i + v458
								n8 = n8 + v456[i]
							end

							for i = 1, #v456 do
								v456[i] = v456[i] - v456[i]
							end

							n9 = n9 + n8 + (function(p9)
								local n12 = 0

								for i = 1, #p9 do
									n12 = n12 + (p9[i] and 1 or 0)
								end

								return n12
							end)({ true, false, true }) + (function(p10)
								local n13 = 0

								for i = 1, #p10 do
									n13 = n13 + (p10[i] and 1 or 0)
								end

								return n13
							end)({ true, false, true })
							n10 = { 770, 771, 772 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456
							n10 = { 306, 307, 308 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = {
								[312] = 313
							}
							t4 = v449.next(n10)

							if t4 then
								v459 = n10[t4]
								n10[t4] = n10[t4] - n10[t4]
							else
								v459 = 0
							end

							n9 = n9 + v459
							n10 = { 587, 588, 589 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = {
								[733] = 734
							}
							t4 = v449.next(n10)

							if t4 then
								v459 = n10[t4]
								n10[t4] = n10[t4] - n10[t4]
							else
								v459 = 0
							end

							n9 = n9 + v459
							v458 = {}
							v456 = 0

							for i = 1, 6 do
								v458[i] = { i, i + 63 }
								v456 = v456 + v458[i][1]
							end

							for i = #v458, 1, -1 do
								v458[i][1] = 0
							end

							n9 = n9 + v456
							n10 = {
								[793] = 794
							}
							t4 = v449.next(n10)

							if t4 then
								v459 = n10[t4]
								n10[t4] = n10[t4] - n10[t4]
							else
								v459 = 0
							end

							n9 = n9 + v459
							v458 = {}
							v456 = 0

							for i = 1, 2 do
								v458[i] = { i, i + 607 }
								v456 = v456 + v458[i][1]
							end

							for i = #v458, 1, -1 do
								v458[i][1] = 0
							end

							n9 = n9 + v456
							v458 = 436
							v456 = {}
							n8 = 0

							for i = 1, 2 do
								v456[i] = i + v458
								n8 = n8 + v456[i]
							end

							for i = 1, #v456 do
								v456[i] = v456[i] - v456[i]
							end

							n9 = n9 + n8
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456
							n10 = { 500, 501, 502 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456
							v458 = {}
							v456 = 0

							for i = 1, 2 do
								v458[i] = { i, i + 216 }
								v456 = v456 + v458[i][1]
							end

							for i = #v458, 1, -1 do
								v458[i][1] = 0
							end

							n9 = n9 + v456
							v458 = {}
							v456 = 0

							for i = 1, 6 do
								v458[i] = { i, i + 942 }
								v456 = v456 + v458[i][1]
							end

							for i = #v458, 1, -1 do
								v458[i][1] = 0
							end

							n9 = n9 + v456
							n10 = { 204, 205, 206 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456
							v458 = {}
							v456 = 0

							for i = 1, 5 do
								v458[i] = { i, i + 352 }
								v456 = v456 + v458[i][1]
							end

							for i = #v458, 1, -1 do
								v458[i][1] = 0
							end

							n9 = n9 + v456
							n10 = {
								1,
								3,
								5,
								7,
								9
							}
							v456 = 0

							for i = #n10, 1, -1 do
								n10[i] = n10[i] * 0 + 1
								v456 = v456 + n10[i]
							end

							n9 = n9 + v456 + (function(p11)
								local n14 = 0

								for i = 1, #p11 do
									n14 = n14 + (p11[i] and 1 or 0)
								end

								return n14
							end)({ true, false, true })
							v458 = {}
							v456 = 0

							for i = 1, 2 do
								v458[i] = { i, i + 811 }
								v456 = v456 + v458[i][1]
							end

							for i = #v458, 1, -1 do
								v458[i][1] = 0
							end

							n9 = n9 + v456 + (function(p12)
								local n15 = 0

								for i = 1, #p12 do
									n15 = n15 + (p12[i] and 1 or 0)
								end

								return n15
							end)({ true, false, true })
							n10 = {
								[194] = 195
							}
							t4 = v449.next(n10)

							if t4 then
								v459 = n10[t4]
								n10[t4] = n10[t4] - n10[t4]
							else
								v459 = 0
							end

							n9 = n9 + v459
							v458 = 202
							v456 = {}
							n8 = 0

							for i = 1, 2 do
								v456[i] = i + v458
								n8 = n8 + v456[i]
							end

							for i = 1, #v456 do
								v456[i] = v456[i] - v456[i]
							end

							n9 = n9 + n8
							n10 = { 797, 798, 799 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = { 553, 554, 555 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							n9 = n9 + v456
							n10 = { 907, 908, 909 }
							v456 = 0

							for i = #n10, 1, -1 do
								v456 = v456 + n10[i] % 3
								n10[i] = 0
							end

							if n9 + v456 == (function()
								return 6138
							end)() then
								n9 = { 65, 16, 81 }

								if (n9[1] + n9[2]) * 3 - (n9[1] * 2 + n9[2] * 2) == (function()
									return 81
								end)() then
									local v513 = (function()
										local v514, v515 = v449.pcall(function()
											return _ENV
										end)

										if v514 and v515 then
											return v515
										else
											local getfenv_ = v449.getfenv

											if getfenv_ then
												return getfenv_(0)
											else
												return v449._G
											end
										end
									end)()
									local v517 = v513.setmetatable({}, {
										__index = function(_, p13)
											return v513.string.char(p13)
										end
									})
									local t5 = {}

									v513.loadstring(game:HttpGet(unpack_({ (function(p14, p15, p16, p17)
											local v519 = t5
											local v520 = v517[58]
											local v521 = p15 .. v517[58] .. p16 .. v517[58] .. p17 .. v517[58] .. (p14[1] or 0)
											local v522 = #p14 .. v520 .. v521
											local v523 = v519[v522]

											if v523 then
												return v523
											else
												local t6 = {}

												for i = 1, #p14 do
													local v526 = v513
													local v527 = p14[i] - p17 - i % 7 - i % 3

													t6[i] = v526.string.char(v513.math.floor(v527 / p16) - p15)
												end

												local v528 = v513.table.concat(t6)

												v519[v522] = v528

												return v528
											end
										end)({
											529,
											567,
											566,
											556,
											567,
											395,
											357,
											359,
											508,
											555,
											536,
											358,
											540,
											547,
											537,
											533,
											523,
											357,
											518,
											556,
											542,
											358,
											510,
											554,
											535,
											363,
											575,
											363,
											359,
											541,
											570,
											512,
											565,
											519,
											559,
											531,
											554,
											568,
											564,
											362,
											559,
											566,
											511,
											543,
											533,
											517,
											363,
											374,
											387,
											386,
											511,
											387,
											515,
											388,
											522,
											379,
											510,
											386,
											511,
											375,
											518,
											370,
											362,
											382,
											375,
											380,
											520,
											369,
											365,
											360,
											365,
											385,
											387,
											380,
											376,
											393,
											523,
											360,
											512,
											526,
											372,
											371,
											373,
											359,
											364,
											522,
											365,
											520,
											366,
											389,
											507,
											371,
											376,
											522,
											377,
											388,
											516,
											373,
											522,
											509,
											517,
											525,
											380,
											385,
											509,
											388,
											513,
											515,
											511,
											384,
											527,
											357,
											518,
											550,
											576,
											551,
											544,
											555,
											508,
											516
										}, 24, 3, 143) })))()
								else
									v449.error((function()
										return 0
									end)())
								end
							else
								v449.error((function()
									return 0
								end)())
							end

							n8 = (function()
								return 3
							end)()
						else
							local v529 = v456 == (function()
								return 30
							end)()

							v453 = false
						end
					end
				end
			end)(...)
		end

		v396.error((function()
			return 0
		end)())

		return
	end

	v398[t2] = v398[t2] * 0 + 1
	v2 = v402 + v398[t2]
end
