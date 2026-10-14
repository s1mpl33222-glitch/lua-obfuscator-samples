--[[
  KaWaifu AJ — leaked by starloxmelo
]]
if not getgenv then
    getgenv = getfenv or function() return _G end
end
getgenv().script_key = "103acda48a024283e33fe58b890805e9"

warn("[KaWaifu] Script Start")
str10 = "\109\130\184\151\28\225\75\213\76\64\88\116\24\241\148\21\6\182\92\205\22\163\244\49\200\207\230\200\104\55\209\90"

do
	local function slicedfn47(arg, arg2, arg3, arg4, arg5)
		local tbl28 = {}
		local tbl29 = {}
		local n = arg
		local slicedn33 = arg2
		local v = arg3
		local sliced91 = arg4  -- LEAKED BY STARLOXMELO
		local sliced92 = arg5
		local slicedn34 = 16
		local tbl30 = nil
		local char2 = nil
		local byte = nil
		local slicedn35 = nil
		local slicedn36 = nil
		local slicedn37 = nil
		local slicedn38 = nil
		local slicedn39 = nil  -- LEAKED BY STARLOXMELO
		local slicedn40 = nil
		local slicedn41 = nil
		local str11 = nil

		while true do
			if slicedn34 <= 31 then
				if slicedn34 <= 15 then
					if slicedn34 <= 7 then
						if slicedn34 <= 3 then
							if slicedn34 <= 1 then
								if slicedn34 <= 0 then  -- LEAKED BY STARLOXMELO
									local tbl31 = {}

									if slicedn33 == 1 then
										slicedn34 = 42
										slicedn33 = tbl31
									else
										slicedn34 = 57
										slicedn35 = tbl31
									end
								else
									local sliced93 = tbl30[1]  -- LEAKED BY STARLOXMELO
									local sliced94 = tbl30[4]
									local slicedn42 = tbl30[2] + sliced93
									local flag21 = sliced93 <= 0
									local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94
									tbl30[2] = slicedn42

									if flag22 then
										slicedn34 = 8
									else
										slicedn34 = 5
									end  -- LEAKED BY STARLOXMELO
								end
							elseif slicedn34 <= 2 then
								tbl30 = tbl30[1]
								slicedn34 = 26
							else
								slicedn34 = 25
								slicedn33 = 3661753104396200
								slicedn36 = 927496312415783
								slicedn37 = 4503599627370496
								slicedn38 = 67108864  -- LEAKED BY STARLOXMELO
								slicedn39 = 17592186044416
								slicedn40 = 2679385
								slicedn41 = 22847685
								tbl30 = { 0, nil, 1, tbl30, 4 }
							end
						elseif slicedn34 <= 5 then
							if slicedn34 <= 4 then
								byte(str11, 1, 64)
								slicedn34 = slicedn41 == slicedn40 and 31 or 24
							else  -- LEAKED BY STARLOXMELO
								tbl30 = tbl30[5]
								slicedn34 = 4
							end
						elseif slicedn34 <= 6 then
							local slicedn42 = slicedn33 % slicedn38
							slicedn33 = ((((slicedn33 - slicedn42) / slicedn38 * slicedn40 + slicedn42 * slicedn41) % slicedn38 * slicedn38 + slicedn42 * slicedn40) % slicedn37 + slicedn36) % slicedn37
							slicedn35[n] = (slicedn33 - slicedn33 % slicedn39) / slicedn39
							slicedn34 = 10
						else
							char2 ..= tbl28[slicedn39]  -- LEAKED BY STARLOXMELO
							slicedn34 = 11
						end
					elseif slicedn34 <= 11 then
						if slicedn34 <= 9 then
							if slicedn34 <= 8 then
								slicedn35 = (slicedn37 * slicedn35 + slicedn38) % 4294967296
								str11 ..= slicedn39[1 + (slicedn35 - slicedn35 % 268435456) / 268435456 % 16]
								slicedn34 = 1
							else
								slicedn33[slicedn35 + 1] = n[slicedn37] * 16 + n[slicedn38]  -- LEAKED BY STARLOXMELO
								slicedn34 = 27
							end
						elseif slicedn34 <= 10 then
							local sliced93 = tbl30[2]
							local sliced94 = tbl30[3]
							local slicedn42 = tbl30[5] + sliced93
							local flag21 = sliced93 <= 0
							local flag22 = not flag21
							local flag23 = slicedn42 >= sliced94
							local flag24 = slicedn42 <= sliced94  -- LEAKED BY STARLOXMELO
							flag23 = flag21 and flag23
							flag24 = flag22 and flag24
							flag24 = flag23 or flag24
							tbl30[5] = slicedn42

							if flag24 then
								slicedn34 = 6
								n = slicedn42
							else
								slicedn34 = 2
							end  -- LEAKED BY STARLOXMELO
						else
							local sliced93 = tbl30[3]
							local sliced94 = tbl30[5]
							local slicedn42 = tbl30[1] + sliced93
							local flag21 = sliced93 <= 0
							local flag22 = not flag21
							local flag23 = slicedn42 >= sliced94
							local flag24 = slicedn42 <= sliced94
							flag23 = flag21 and flag23
							flag24 = flag22 and flag24  -- LEAKED BY STARLOXMELO
							flag24 = flag23 or flag24
							tbl30[1] = slicedn42

							if flag24 then
								slicedn34 = 28
								slicedn35 = slicedn42
							else
								slicedn34 = 35
							end
						end
					elseif slicedn34 <= 13 then  -- LEAKED BY STARLOXMELO
						if slicedn34 <= 12 then
							n = (n + tbl29[slicedn33] + slicedn35[slicedn33 % 32 + 1]) % 256
							local sliced93 = tbl29[slicedn33]
							tbl29[slicedn33] = tbl29[n]
							tbl29[n] = sliced93
							slicedn34 = 56
						else
							slicedn39 += slicedn37
							slicedn34 = 18
						end  -- LEAKED BY STARLOXMELO
					elseif slicedn34 <= 14 then
						slicedn35 = (slicedn35 - slicedn38) / 2
						slicedn36 = (slicedn36 - slicedn40) / 2
						slicedn38 = slicedn35 % 2
						slicedn40 = slicedn36 % 2

						if slicedn38 ~= slicedn40 then
							slicedn34 = 43
							slicedn37 = 4
						else
							slicedn34 = 33  -- LEAKED BY STARLOXMELO
						end
					else
						n = { [56] = 8, [48] = 0, [100] = 13, [52] = 4, [51] = 3, [66] = 11, [67] = 12 }
						slicedn34 = 55
						slicedn35 = 49
						slicedn37 = 1
					end

					continue
				end

				if slicedn34 <= 23 then  -- LEAKED BY STARLOXMELO
					if slicedn34 <= 19 then
						if slicedn34 <= 17 then
							if slicedn34 <= 16 then
								char2 = string.char
								byte = string.byte

								if slicedn33 == 2 then
									slicedn34 = 26
									slicedn35 = n
								else
									slicedn34 = 0  -- LEAKED BY STARLOXMELO
								end
							else
								slicedn34 = 11
								n = 0
								slicedn33 = 0
								char2 = ""
								tbl30 = { 0, nil, 1, tbl30, #v + 0 }
							end
						elseif slicedn34 <= 18 then
							slicedn35 = (slicedn35 - slicedn38) / 2  -- LEAKED BY STARLOXMELO
							slicedn36 = (slicedn36 - slicedn40) / 2
							slicedn38 = slicedn35 % 2
							slicedn40 = slicedn36 % 2

							if slicedn38 ~= slicedn40 then
								slicedn34 = 54
								slicedn37 = 128
							else
								slicedn34 = 7
							end
						else  -- LEAKED BY STARLOXMELO
							sliced91[sliced92] = char2
							slicedn34 = 34
						end
					elseif slicedn34 <= 21 then
						if slicedn34 <= 20 then
							tbl30 = tbl30[4]
							slicedn34 = 17
						else
							slicedn34 = 1
							str11 = ""  -- LEAKED BY STARLOXMELO
							tbl30 = { 1, 0, nil, 64, tbl30 }
						end
					elseif slicedn34 <= 22 then
						slicedn35 = (slicedn35 - slicedn38) / 2
						slicedn36 = (slicedn36 - slicedn40) / 2
						slicedn38 = slicedn35 % 2
						slicedn40 = slicedn36 % 2

						if slicedn38 ~= slicedn40 then
							slicedn34 = 32
							slicedn37 = 32  -- LEAKED BY STARLOXMELO
						else
							slicedn34 = 58
						end
					else
						str11 += 65536
						slicedn34 = 51
					end

					continue
				end

				if slicedn34 <= 27 then  -- LEAKED BY STARLOXMELO
					if slicedn34 <= 25 then
						if slicedn34 <= 24 then
							local sliced93 = tbl30[1]
							local sliced94 = tbl30[3]
							local slicedn42 = tbl30[5] + sliced93
							local flag21 = sliced93 <= 0
							local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94
							tbl30[5] = slicedn42

							if flag22 then
								slicedn34 = 21  -- LEAKED BY STARLOXMELO
								slicedn41 = slicedn42
							else
								slicedn34 = 62
							end
						else
							local sliced93 = tbl30[3]
							local sliced94 = tbl30[5]
							local slicedn42 = tbl30[1] + sliced93
							local flag21 = sliced93 <= 0
							local flag22 = not flag21  -- LEAKED BY STARLOXMELO
							local flag23 = slicedn42 >= sliced94
							local flag24 = slicedn42 <= sliced94
							flag23 = flag21 and flag23
							flag23 = flag23 or flag22 and flag24
							tbl30[1] = slicedn42

							if flag23 then
								slicedn34 = 50
								str11 = slicedn42
							else
								slicedn34 = 60  -- LEAKED BY STARLOXMELO
							end
						end
					elseif slicedn34 <= 26 then
						n = slicedn35[3]
						slicedn33 = 4 * (slicedn35[1] % 64) + 1
						slicedn36 = 2 * (slicedn35[2] % 128) - 1
						slicedn34 = 52
						tbl30 = { 1, -1, nil, 255, tbl30 }
					else
						local sliced93 = tbl30[4]  -- LEAKED BY STARLOXMELO
						local sliced94 = tbl30[3]
						local slicedn42 = tbl30[2] + sliced93
						local flag21 = sliced93 <= 0
						local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94
						tbl30[2] = slicedn42

						if flag22 then
							slicedn34 = 63
							slicedn35 = slicedn42
						else
							slicedn34 = 53  -- LEAKED BY STARLOXMELO
						end
					end

					continue
				end

				if slicedn34 <= 29 then
					if slicedn34 <= 28 then
						n = (n + 1) % 256
						slicedn33 = (slicedn33 + tbl29[n]) % 256
						local sliced93 = tbl29[n]
						tbl29[n] = tbl29[slicedn33]  -- LEAKED BY STARLOXMELO
						tbl29[slicedn33] = sliced93
						local sliced94 = byte(v, slicedn35)
						slicedn36 = tbl29[(tbl29[n] + tbl29[slicedn33]) % 256]
						slicedn37 = sliced94 % 2
						slicedn38 = slicedn36 % 2

						if slicedn37 ~= slicedn38 then
							slicedn34 = 44
							slicedn35 = sliced94
						else
							slicedn34 = 38  -- LEAKED BY STARLOXMELO
							slicedn39 = 0
							slicedn35 = sliced94
						end

						continue
					end

					return nil
				end

				if slicedn34 <= 30 then
					slicedn39 += slicedn37
					slicedn34 = 39  -- LEAKED BY STARLOXMELO
				else
					slicedn36 = { byte(n, 1, 64) }
					slicedn34 = 24
				end
			else
				if slicedn34 <= 47 then
					if slicedn34 <= 39 then
						if slicedn34 <= 35 then
							if slicedn34 <= 33 then
								if slicedn34 <= 32 then  -- LEAKED BY STARLOXMELO
									slicedn39 += slicedn37
									slicedn34 = 58
								else
									slicedn35 = (slicedn35 - slicedn38) / 2
									slicedn36 = (slicedn36 - slicedn40) / 2
									slicedn38 = slicedn35 % 2
									slicedn40 = slicedn36 % 2

									if slicedn38 ~= slicedn40 then
										slicedn34 = 30
										slicedn37 = 8  -- LEAKED BY STARLOXMELO
									else
										slicedn34 = 39
									end
								end

								continue
							end

							if slicedn34 <= 34 then
								return
							end
							tbl30 = tbl30[4]  -- LEAKED BY STARLOXMELO
							slicedn34 = 19
							continue
						end

						if slicedn34 <= 37 then
							if slicedn34 <= 36 then
								slicedn34 = not slicedn38 and 61 or 9
							else
								tbl30 = tbl30[5]
								slicedn34 = 59
							end  -- LEAKED BY STARLOXMELO
						elseif slicedn34 <= 38 then
							slicedn35 = (slicedn35 - slicedn37) / 2
							slicedn36 = (slicedn36 - slicedn38) / 2
							slicedn38 = slicedn35 % 2
							slicedn40 = slicedn36 % 2

							if slicedn38 ~= slicedn40 then
								slicedn34 = 49
								slicedn37 = 2
							else
								slicedn34 = 14  -- LEAKED BY STARLOXMELO
							end
						else
							slicedn35 = (slicedn35 - slicedn38) / 2
							slicedn36 = (slicedn36 - slicedn40) / 2
							slicedn38 = slicedn35 % 2
							slicedn40 = slicedn36 % 2

							if slicedn38 ~= slicedn40 then
								slicedn34 = 48
								slicedn37 = 16
							else  -- LEAKED BY STARLOXMELO
								slicedn34 = 22
							end
						end

						continue
					end

					if slicedn34 <= 43 then
						if slicedn34 <= 41 then
							if slicedn34 <= 40 then
								str11 -= 65536
								slicedn34 = 47  -- LEAKED BY STARLOXMELO
							else
								n[slicedn35] = slicedn37
								n[69] = 14
								n[55] = 7
								n[53] = 5
								n[57] = 9
								n[99] = 12
								n[54] = 6
								slicedn34 = 27
								tbl30 = { tbl30, -1, 31, 1, nil }  -- LEAKED BY STARLOXMELO
							end
						elseif slicedn34 <= 42 then
							slicedn36 = {}

							slicedn39 = {
								"a",
								"6",
								"b",
								"3",
								"5",
								"e",  -- LEAKED BY STARLOXMELO
								"2",
								"0",
								"d",
								"1",
								"7",
								"f",
								"4",
								"8",
								"c",
								"9",  -- LEAKED BY STARLOXMELO
							}

							slicedn34 = 24
							slicedn35 = 3846715392
							slicedn37 = -2141334987
							slicedn38 = -1976388651
							slicedn40 = 1
							tbl30 = { 1, tbl30, 128, nil, 0 }
						else
							slicedn39 += slicedn37
							slicedn34 = 33  -- LEAKED BY STARLOXMELO
						end
					elseif slicedn34 <= 45 then
						if slicedn34 <= 44 then
							slicedn34 = 38
							slicedn39 = 1
						else
							slicedn34 = 10
							tbl30 = { tbl30, 1, 32, nil, 0 }
						end
					elseif slicedn34 <= 46 then  -- LEAKED BY STARLOXMELO
						tbl28[n] = char2(n)
						tbl29[n] = n
						n = (slicedn33 * n + slicedn36) % 256
						slicedn34 = 52
					else
						n = (n - str11) / 65536
						local slicedn42 = (slicedn33 + str11) % slicedn37
						local slicedn43 = slicedn42 % slicedn38
						slicedn33 = ((((slicedn42 - slicedn43) / slicedn38 * slicedn40 + slicedn43 * slicedn41) % slicedn38 * slicedn38 + slicedn43 * slicedn40) % slicedn37 + slicedn36) % slicedn37
						slicedn34 = 25  -- LEAKED BY STARLOXMELO
					end

					continue
				end

				if slicedn34 <= 55 then
					if slicedn34 <= 51 then
						if slicedn34 <= 49 then
							if slicedn34 <= 48 then
								slicedn39 += slicedn37
								slicedn34 = 22
							else  -- LEAKED BY STARLOXMELO
								slicedn39 += slicedn37
								slicedn34 = 14
							end
						elseif slicedn34 <= 50 then
							str11 = n % 65536
							slicedn34 = str11 < 0 and 23 or 51
						else
							slicedn34 = str11 >= 65536 and 40 or 47
						end
					elseif slicedn34 <= 53 then  -- LEAKED BY STARLOXMELO
						if slicedn34 <= 52 then
							local sliced93 = tbl30[1]
							local sliced94 = tbl30[4]
							local slicedn42 = tbl30[2] + sliced93
							local flag21 = sliced93 <= 0
							local flag22 = not flag21
							local flag23 = slicedn42 >= sliced94
							local flag24 = slicedn42 <= sliced94
							flag23 = flag21 and flag23
							flag23 = flag23 or flag22 and flag24  -- LEAKED BY STARLOXMELO
							tbl30[2] = slicedn42

							if flag23 then
								slicedn34 = 46
								slicedn37 = slicedn42
							else
								slicedn34 = 37
							end
						else
							tbl30 = tbl30[1]
							slicedn34 = 26  -- LEAKED BY STARLOXMELO
							slicedn35 = slicedn33
						end
					elseif slicedn34 <= 54 then
						slicedn39 += slicedn37
						slicedn34 = 7
					else
						n[slicedn35] = slicedn37
						n[50] = 2
						n[102] = 15
						n[98] = 11  -- LEAKED BY STARLOXMELO
						n[68] = 13
						n[101] = 14
						n[70] = 15
						n[65] = 10
						slicedn34 = 41
						slicedn35 = 97
						slicedn37 = 10
					end

					continue
				end  -- LEAKED BY STARLOXMELO

				if slicedn34 <= 59 then
					if slicedn34 <= 57 then
						if slicedn34 <= 56 then
							local sliced93 = tbl30[3]
							local sliced94 = tbl30[1]
							local slicedn42 = tbl30[5] + sliced93
							local flag21 = sliced93 <= 0
							local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94
							tbl30[5] = slicedn42

							if flag22 then  -- LEAKED BY STARLOXMELO
								slicedn34 = 12
								slicedn33 = slicedn42
							else
								slicedn34 = 20
							end
						else
							slicedn34 = slicedn33 == 0 and 3 or 26
						end
					elseif slicedn34 <= 58 then
						slicedn35 = (slicedn35 - slicedn38) / 2  -- LEAKED BY STARLOXMELO
						slicedn36 = (slicedn36 - slicedn40) / 2
						slicedn38 = slicedn35 % 2
						slicedn40 = slicedn36 % 2

						if slicedn38 ~= slicedn40 then
							slicedn34 = 13
							slicedn37 = 64
						else
							slicedn34 = 18
						end
					else  -- LEAKED BY STARLOXMELO
						slicedn34 = 56
						n = 0
						tbl30 = { 255, nil, 1, tbl30, -1 }
					end

					continue
				end

				if slicedn34 <= 61 then
					if slicedn34 <= 60 then
						tbl30 = tbl30[4]
						slicedn34 = 45  -- LEAKED BY STARLOXMELO
						continue
					end

					break
				end

				if slicedn34 <= 62 then
					tbl30 = tbl30[2]
					slicedn34 = 15
				else
					local slicedn42 = slicedn35 * 2 + 1
					local sliced93 = slicedn36[slicedn42]  -- LEAKED BY STARLOXMELO
					local sliced94 = slicedn36[slicedn42 + 1]

					if not sliced93 then
						slicedn34 = 29
					else
						slicedn34 = 36
						slicedn37 = sliced93
						slicedn38 = sliced94
					end
				end
			end  -- LEAKED BY STARLOXMELO
		end

		return nil
	end

end

local str11, slicedfn47, tbl28, tbl29, slicedfn48, request_

do
	do
		str11 = "f2284f4121d8470513b611058e3a8ca5"

		do
			local function slicedfn49(arg, arg2, arg3, arg4, arg5)  -- LEAKED BY STARLOXMELO
				local tbl30 = {}
				local tbl31 = {}
				local n = arg
				local slicedn33 = arg2
				local v = arg3
				local sliced91 = arg4
				local sliced92 = arg5
				local slicedn34 = 16
				local tbl32 = nil
				local char2 = nil  -- LEAKED BY STARLOXMELO
				local byte = nil
				local slicedn35 = nil
				local slicedn36 = nil
				local slicedn37 = nil
				local slicedn38 = nil
				local slicedn39 = nil
				local slicedn40 = nil
				local slicedn41 = nil
				local str12 = nil

				while true do  -- LEAKED BY STARLOXMELO
					if slicedn34 <= 31 then
						if slicedn34 <= 15 then
							if slicedn34 <= 7 then
								if slicedn34 <= 3 then
									if slicedn34 <= 1 then
										if slicedn34 <= 0 then
											local tbl33 = {}

											if slicedn33 == 1 then
												slicedn34 = 42
												slicedn33 = tbl33  -- LEAKED BY STARLOXMELO
											else
												slicedn34 = 57
												slicedn35 = tbl33
											end
										else
											local sliced93 = tbl32[1]
											local sliced94 = tbl32[4]
											local slicedn42 = tbl32[2] + sliced93
											local flag21 = sliced93 <= 0
											local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94  -- LEAKED BY STARLOXMELO
											tbl32[2] = slicedn42

											if flag22 then
												slicedn34 = 8
											else
												slicedn34 = 5
											end
										end
									elseif slicedn34 <= 2 then
										tbl32 = tbl32[1]
										slicedn34 = 26  -- LEAKED BY STARLOXMELO
									else
										slicedn34 = 25
										slicedn33 = 3661753104396200
										slicedn36 = 927496312415783
										slicedn37 = 4503599627370496
										slicedn38 = 67108864
										slicedn39 = 17592186044416
										slicedn40 = 2679385
										slicedn41 = 22847685
										tbl32 = { 0, nil, 1, tbl32, 4 }  -- LEAKED BY STARLOXMELO
									end
								elseif slicedn34 <= 5 then
									if slicedn34 <= 4 then
										byte(str12, 1, 64)
										slicedn34 = slicedn41 == slicedn40 and 31 or 24
									else
										tbl32 = tbl32[5]
										slicedn34 = 4
									end
								elseif slicedn34 <= 6 then  -- LEAKED BY STARLOXMELO
									local slicedn42 = slicedn33 % slicedn38
									slicedn33 = ((((slicedn33 - slicedn42) / slicedn38 * slicedn40 + slicedn42 * slicedn41) % slicedn38 * slicedn38 + slicedn42 * slicedn40) % slicedn37 + slicedn36) % slicedn37
									slicedn35[n] = (slicedn33 - slicedn33 % slicedn39) / slicedn39
									slicedn34 = 10
								else
									char2 ..= tbl30[slicedn39]
									slicedn34 = 11
								end
							elseif slicedn34 <= 11 then
								if slicedn34 <= 9 then  -- LEAKED BY STARLOXMELO
									if slicedn34 <= 8 then
										slicedn35 = (slicedn37 * slicedn35 + slicedn38) % 4294967296
										str12 ..= slicedn39[1 + (slicedn35 - slicedn35 % 268435456) / 268435456 % 16]
										slicedn34 = 1
									else
										slicedn33[slicedn35 + 1] = n[slicedn37] * 16 + n[slicedn38]
										slicedn34 = 27
									end
								elseif slicedn34 <= 10 then
									local sliced93 = tbl32[2]  -- LEAKED BY STARLOXMELO
									local sliced94 = tbl32[3]
									local slicedn42 = tbl32[5] + sliced93
									local flag21 = sliced93 <= 0
									local flag22 = not flag21
									local flag23 = slicedn42 >= sliced94
									local flag24 = slicedn42 <= sliced94
									flag23 = flag21 and flag23
									flag24 = flag22 and flag24
									flag24 = flag23 or flag24
									tbl32[5] = slicedn42  -- LEAKED BY STARLOXMELO

									if flag24 then
										slicedn34 = 6
										n = slicedn42
									else
										slicedn34 = 2
									end
								else
									local sliced93 = tbl32[3]
									local sliced94 = tbl32[5]
									local slicedn42 = tbl32[1] + sliced93  -- LEAKED BY STARLOXMELO
									local flag21 = sliced93 <= 0
									local flag22 = not flag21
									local flag23 = slicedn42 >= sliced94
									local flag24 = slicedn42 <= sliced94
									flag23 = flag21 and flag23
									flag24 = flag22 and flag24
									flag24 = flag23 or flag24
									tbl32[1] = slicedn42

									if flag24 then
										slicedn34 = 28  -- LEAKED BY STARLOXMELO
										slicedn35 = slicedn42
									else
										slicedn34 = 35
									end
								end
							elseif slicedn34 <= 13 then
								if slicedn34 <= 12 then
									n = (n + tbl31[slicedn33] + slicedn35[slicedn33 % 32 + 1]) % 256
									local sliced93 = tbl31[slicedn33]
									tbl31[slicedn33] = tbl31[n]  -- LEAKED BY STARLOXMELO
									tbl31[n] = sliced93
									slicedn34 = 56
								else
									slicedn39 += slicedn37
									slicedn34 = 18
								end
							elseif slicedn34 <= 14 then
								slicedn35 = (slicedn35 - slicedn38) / 2
								slicedn36 = (slicedn36 - slicedn40) / 2
								slicedn38 = slicedn35 % 2  -- LEAKED BY STARLOXMELO
								slicedn40 = slicedn36 % 2

								if slicedn38 ~= slicedn40 then
									slicedn34 = 43
									slicedn37 = 4
								else
									slicedn34 = 33
								end
							else
								n = { [56] = 8, [48] = 0, [100] = 13, [52] = 4, [51] = 3, [66] = 11, [67] = 12 }
								slicedn34 = 55  -- LEAKED BY STARLOXMELO
								slicedn35 = 49
								slicedn37 = 1
							end

							continue
						end

						if slicedn34 <= 23 then
							if slicedn34 <= 19 then
								if slicedn34 <= 17 then
									if slicedn34 <= 16 then
										char2 = string.char  -- LEAKED BY STARLOXMELO
										byte = string.byte

										if slicedn33 == 2 then
											slicedn34 = 26
											slicedn35 = n
										else
											slicedn34 = 0
										end
									else
										slicedn34 = 11
										n = 0  -- LEAKED BY STARLOXMELO
										slicedn33 = 0
										char2 = ""
										tbl32 = { 0, nil, 1, tbl32, #v + 0 }
									end
								elseif slicedn34 <= 18 then
									slicedn35 = (slicedn35 - slicedn38) / 2
									slicedn36 = (slicedn36 - slicedn40) / 2
									slicedn38 = slicedn35 % 2
									slicedn40 = slicedn36 % 2

									if slicedn38 ~= slicedn40 then  -- LEAKED BY STARLOXMELO
										slicedn34 = 54
										slicedn37 = 128
									else
										slicedn34 = 7
									end
								else
									sliced91[sliced92] = char2
									slicedn34 = 34
								end
							elseif slicedn34 <= 21 then  -- LEAKED BY STARLOXMELO
								if slicedn34 <= 20 then
									tbl32 = tbl32[4]
									slicedn34 = 17
								else
									slicedn34 = 1
									str12 = ""
									tbl32 = { 1, 0, nil, 64, tbl32 }
								end
							elseif slicedn34 <= 22 then
								slicedn35 = (slicedn35 - slicedn38) / 2  -- LEAKED BY STARLOXMELO
								slicedn36 = (slicedn36 - slicedn40) / 2
								slicedn38 = slicedn35 % 2
								slicedn40 = slicedn36 % 2

								if slicedn38 ~= slicedn40 then
									slicedn34 = 32
									slicedn37 = 32
								else
									slicedn34 = 58
								end
							else  -- LEAKED BY STARLOXMELO
								str12 += 65536
								slicedn34 = 51
							end

							continue
						end

						if slicedn34 <= 27 then
							if slicedn34 <= 25 then
								if slicedn34 <= 24 then
									local sliced93 = tbl32[1]
									local sliced94 = tbl32[3]  -- LEAKED BY STARLOXMELO
									local slicedn42 = tbl32[5] + sliced93
									local flag21 = sliced93 <= 0
									local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94
									tbl32[5] = slicedn42

									if flag22 then
										slicedn34 = 21
										slicedn41 = slicedn42
									else
										slicedn34 = 62
									end  -- LEAKED BY STARLOXMELO
								else
									local sliced93 = tbl32[3]
									local sliced94 = tbl32[5]
									local slicedn42 = tbl32[1] + sliced93
									local flag21 = sliced93 <= 0
									local flag22 = not flag21
									local flag23 = slicedn42 >= sliced94
									local flag24 = slicedn42 <= sliced94
									flag23 = flag21 and flag23
									flag23 = flag23 or flag22 and flag24  -- LEAKED BY STARLOXMELO
									tbl32[1] = slicedn42

									if flag23 then
										slicedn34 = 50
										str12 = slicedn42
									else
										slicedn34 = 60
									end
								end
							elseif slicedn34 <= 26 then
								n = slicedn35[3]  -- LEAKED BY STARLOXMELO
								slicedn33 = 4 * (slicedn35[1] % 64) + 1
								slicedn36 = 2 * (slicedn35[2] % 128) - 1
								slicedn34 = 52
								tbl32 = { 1, -1, nil, 255, tbl32 }
							else
								local sliced93 = tbl32[4]
								local sliced94 = tbl32[3]
								local slicedn42 = tbl32[2] + sliced93
								local flag21 = sliced93 <= 0
								local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94  -- LEAKED BY STARLOXMELO
								tbl32[2] = slicedn42

								if flag22 then
									slicedn34 = 63
									slicedn35 = slicedn42
								else
									slicedn34 = 53
								end
							end

							continue
						end  -- LEAKED BY STARLOXMELO

						if slicedn34 <= 29 then
							if slicedn34 <= 28 then
								n = (n + 1) % 256
								slicedn33 = (slicedn33 + tbl31[n]) % 256
								local sliced93 = tbl31[n]
								tbl31[n] = tbl31[slicedn33]
								tbl31[slicedn33] = sliced93
								local sliced94 = byte(v, slicedn35)
								slicedn36 = tbl31[(tbl31[n] + tbl31[slicedn33]) % 256]
								slicedn37 = sliced94 % 2  -- LEAKED BY STARLOXMELO
								slicedn38 = slicedn36 % 2

								if slicedn37 ~= slicedn38 then
									slicedn34 = 44
									slicedn35 = sliced94
								else
									slicedn34 = 38
									slicedn39 = 0
									slicedn35 = sliced94
								end

								continue  -- LEAKED BY STARLOXMELO
							end

							return nil
						end

						if slicedn34 <= 30 then
							slicedn39 += slicedn37
							slicedn34 = 39
						else
							slicedn36 = { byte(n, 1, 64) }
							slicedn34 = 24
						end  -- LEAKED BY STARLOXMELO
					else
						if slicedn34 <= 47 then
							if slicedn34 <= 39 then
								if slicedn34 <= 35 then
									if slicedn34 <= 33 then
										if slicedn34 <= 32 then
											slicedn39 += slicedn37
											slicedn34 = 58
										else
											slicedn35 = (slicedn35 - slicedn38) / 2  -- LEAKED BY STARLOXMELO
											slicedn36 = (slicedn36 - slicedn40) / 2
											slicedn38 = slicedn35 % 2
											slicedn40 = slicedn36 % 2

											if slicedn38 ~= slicedn40 then
												slicedn34 = 30
												slicedn37 = 8
											else
												slicedn34 = 39
											end
										end  -- LEAKED BY STARLOXMELO

										continue
									end

									if slicedn34 <= 34 then
										return
									end
									tbl32 = tbl32[4]
									slicedn34 = 19
									continue
								end

								if slicedn34 <= 37 then  -- LEAKED BY STARLOXMELO
									if slicedn34 <= 36 then
										slicedn34 = not slicedn38 and 61 or 9
									else
										tbl32 = tbl32[5]
										slicedn34 = 59
									end
								elseif slicedn34 <= 38 then
									slicedn35 = (slicedn35 - slicedn37) / 2
									slicedn36 = (slicedn36 - slicedn38) / 2
									slicedn38 = slicedn35 % 2  -- LEAKED BY STARLOXMELO
									slicedn40 = slicedn36 % 2

									if slicedn38 ~= slicedn40 then
										slicedn34 = 49
										slicedn37 = 2
									else
										slicedn34 = 14
									end
								else
									slicedn35 = (slicedn35 - slicedn38) / 2
									slicedn36 = (slicedn36 - slicedn40) / 2  -- LEAKED BY STARLOXMELO
									slicedn38 = slicedn35 % 2
									slicedn40 = slicedn36 % 2

									if slicedn38 ~= slicedn40 then
										slicedn34 = 48
										slicedn37 = 16
									else
										slicedn34 = 22
									end
								end

								continue  -- LEAKED BY STARLOXMELO
							end

							if slicedn34 <= 43 then
								if slicedn34 <= 41 then
									if slicedn34 <= 40 then
										str12 -= 65536
										slicedn34 = 47
									else
										n[slicedn35] = slicedn37
										n[69] = 14
										n[55] = 7  -- LEAKED BY STARLOXMELO
										n[53] = 5
										n[57] = 9
										n[99] = 12
										n[54] = 6
										slicedn34 = 27
										tbl32 = { tbl32, -1, 31, 1, nil }
									end
								elseif slicedn34 <= 42 then
									slicedn36 = {}

									slicedn39 = {  -- LEAKED BY STARLOXMELO
										"a",
										"6",
										"b",
										"3",
										"5",
										"e",
										"2",
										"0",
										"d",
										"1",  -- LEAKED BY STARLOXMELO
										"7",
										"f",
										"4",
										"8",
										"c",
										"9",
									}

									slicedn34 = 24
									slicedn35 = 3846715392
									slicedn37 = -2141334987  -- LEAKED BY STARLOXMELO
									slicedn38 = -1976388651
									slicedn40 = 1
									tbl32 = { 1, tbl32, 128, nil, 0 }
								else
									slicedn39 += slicedn37
									slicedn34 = 33
								end
							elseif slicedn34 <= 45 then
								if slicedn34 <= 44 then
									slicedn34 = 38  -- LEAKED BY STARLOXMELO
									slicedn39 = 1
								else
									slicedn34 = 10
									tbl32 = { tbl32, 1, 32, nil, 0 }
								end
							elseif slicedn34 <= 46 then
								tbl30[n] = char2(n)
								tbl31[n] = n
								n = (slicedn33 * n + slicedn36) % 256
								slicedn34 = 52  -- LEAKED BY STARLOXMELO
							else
								n = (n - str12) / 65536
								local slicedn42 = (slicedn33 + str12) % slicedn37
								local slicedn43 = slicedn42 % slicedn38
								slicedn33 = ((((slicedn42 - slicedn43) / slicedn38 * slicedn40 + slicedn43 * slicedn41) % slicedn38 * slicedn38 + slicedn43 * slicedn40) % slicedn37 + slicedn36) % slicedn37
								slicedn34 = 25
							end

							continue
						end

						if slicedn34 <= 55 then  -- LEAKED BY STARLOXMELO
							if slicedn34 <= 51 then
								if slicedn34 <= 49 then
									if slicedn34 <= 48 then
										slicedn39 += slicedn37
										slicedn34 = 22
									else
										slicedn39 += slicedn37
										slicedn34 = 14
									end
								elseif slicedn34 <= 50 then  -- LEAKED BY STARLOXMELO
									str12 = n % 65536
									slicedn34 = str12 < 0 and 23 or 51
								else
									slicedn34 = str12 >= 65536 and 40 or 47
								end
							elseif slicedn34 <= 53 then
								if slicedn34 <= 52 then
									local sliced93 = tbl32[1]
									local sliced94 = tbl32[4]
									local slicedn42 = tbl32[2] + sliced93  -- LEAKED BY STARLOXMELO
									local flag21 = sliced93 <= 0
									local flag22 = not flag21
									local flag23 = slicedn42 >= sliced94
									local flag24 = slicedn42 <= sliced94
									flag23 = flag21 and flag23
									flag23 = flag23 or flag22 and flag24
									tbl32[2] = slicedn42

									if flag23 then
										slicedn34 = 46
										slicedn37 = slicedn42  -- LEAKED BY STARLOXMELO
									else
										slicedn34 = 37
									end
								else
									tbl32 = tbl32[1]
									slicedn34 = 26
									slicedn35 = slicedn33
								end
							elseif slicedn34 <= 54 then
								slicedn39 += slicedn37  -- LEAKED BY STARLOXMELO
								slicedn34 = 7
							else
								n[slicedn35] = slicedn37
								n[50] = 2
								n[102] = 15
								n[98] = 11
								n[68] = 13
								n[101] = 14
								n[70] = 15
								n[65] = 10  -- LEAKED BY STARLOXMELO
								slicedn34 = 41
								slicedn35 = 97
								slicedn37 = 10
							end

							continue
						end

						if slicedn34 <= 59 then
							if slicedn34 <= 57 then
								if slicedn34 <= 56 then
									local sliced93 = tbl32[3]  -- LEAKED BY STARLOXMELO
									local sliced94 = tbl32[1]
									local slicedn42 = tbl32[5] + sliced93
									local flag21 = sliced93 <= 0
									local flag22 = flag21 and slicedn42 >= sliced94 or not flag21 and slicedn42 <= sliced94
									tbl32[5] = slicedn42

									if flag22 then
										slicedn34 = 12
										slicedn33 = slicedn42
									else
										slicedn34 = 20  -- LEAKED BY STARLOXMELO
									end
								else
									slicedn34 = slicedn33 == 0 and 3 or 26
								end
							elseif slicedn34 <= 58 then
								slicedn35 = (slicedn35 - slicedn38) / 2
								slicedn36 = (slicedn36 - slicedn40) / 2
								slicedn38 = slicedn35 % 2
								slicedn40 = slicedn36 % 2

								if slicedn38 ~= slicedn40 then  -- LEAKED BY STARLOXMELO
									slicedn34 = 13
									slicedn37 = 64
								else
									slicedn34 = 18
								end
							else
								slicedn34 = 56
								n = 0
								tbl32 = { 255, nil, 1, tbl32, -1 }
							end  -- LEAKED BY STARLOXMELO

							continue
						end

						if slicedn34 <= 61 then
							if slicedn34 <= 60 then
								tbl32 = tbl32[4]
								slicedn34 = 45
								continue
							end

							break
						end  -- LEAKED BY STARLOXMELO

						if slicedn34 <= 62 then
							tbl32 = tbl32[2]
							slicedn34 = 15
						else
							local slicedn42 = slicedn35 * 2 + 1
							local sliced93 = slicedn36[slicedn42]
							local sliced94 = slicedn36[slicedn42 + 1]

							if not sliced93 then
								slicedn34 = 29
							else  -- LEAKED BY STARLOXMELO
								slicedn34 = 36
								slicedn37 = sliced93
								slicedn38 = sliced94
							end
						end
					end
				end

				return nil
			end

		end  -- LEAKED BY STARLOXMELO
	end

	getgenv().JoinerConfig_jhgjerdf324sa = {}

	tbl26 = {
		default = "de",
		scheme = "ws",
		fail_threshold = 5,
		path = "/joiner_fsh34gc1vz5nmj12/ws",
		regions = {
			{
				id = "de",  -- LEAKED BY STARLOXMELO
				label = "Germany (Frankfurt)",
				host = "35.246.155.30",
				port = 16527,
			},
			{
				id = "us-east",
				label = "United States East (Virginia)",
				host = "5.161.58.47",
				port = 16527,
			},  -- LEAKED BY STARLOXMELO
			{
				id = "us-west",
				label = "United States West (Oregon)",
				host = "5.78.117.191",
				port = 16527,
			},
			{
				id = "ca",
				label = "Canada (Toronto)",
				host = "34.130.18.95",  -- LEAKED BY STARLOXMELO
				port = 16527,
			},
			{
				id = "br",
				label = "Brazil (São Paulo)",
				host = "34.95.179.70",
				port = 16527,
			},
			{
				id = "mid-east",  -- LEAKED BY STARLOXMELO
				label = "Middle East (Tel Aviv)",
				host = "34.165.127.121",
				port = 16527,
			},
			{
				id = "sg",
				label = "Singapore (Asia)",
				host = "34.126.91.44",
				port = 16527,
			},  -- LEAKED BY STARLOXMELO
			{
				id = "uk",
				label = "United Kingdom",
				host = "35.189.75.127",
				port = 16527,
			},
			{
				id = "mx",
				label = "Mexico",
				host = "34.51.22.120",  -- LEAKED BY STARLOXMELO
				port = 16527,
			},
			{
				id = "at",
				label = "Austria (Vienna / Europe)",
				host = "86.106.183.225",
				port = 16527,
			},
			{
				id = "es",  -- LEAKED BY STARLOXMELO
				label = "Spain (Madrid)",
				host = "34.175.12.84",
				port = 16527,
			},
		},
	}

	getgenv().AJVersion = "3.4.3"

	tbl17 = {
		SplitView = false,
		FeedMaxRows = 40,  -- LEAKED BY STARLOXMELO
		ExpandRowHeight = 40,
		ExpandRowGap = 4,
		ExpandBarHeight = 24,
		WindowSize = Vector2.new(600, 450),
		MinWindowSize = Vector2.new(420, 315),
		TopBarHeight = 46,
		SidebarWidth = 112,
		ProfilesPanelWidth = 190,
		ProfilesPanelGap = 8,
		WsTabX = 16,  -- LEAKED BY STARLOXMELO
		WsTabOutY = -28,
		WsTabHiddenY = 8,
		LatProbeSweepSecs = 20,
		LatProbeTimeout = 4,
		LatBetterStreak = 60,
		LatPopupCooldown = 900,
		LatServerStale = 300,
		LatServerDead = 1800,
		LatCacheMaxAge = 86400,
		LatSwitchMarginMs = 25,  -- LEAKED BY STARLOXMELO
		LatSwitchMarginPct = 0.2,
		LatEarlyWindow = 90,
		LatProbeOnTouch = false,
		DefaultAutoJoin = false,
		DefaultAttempts = 50,
		DefaultMaxServerAge = 10,
		DefaultMaxDuelTime = 10,
		DefaultShowDuels = true,
		DefaultCarpetMode = "Yes",
		DefaultAutoJoinOGOffAJ = false,  -- LEAKED BY STARLOXMELO
		AnyNewestMinDwell = 0,
		DefaultMidRetrySwitch = "Better Newest",
		DefaultBruteForce = true,
		DefaultMinimizeOnInject = false,
		DefaultSoundId = "5348162330",
		DefaultSoundVolume = 10,
		DefaultAnimSpeed = 5,
		DefaultHotkeyMinimize = "Z",
		DefaultHotkeyAutoTP = "X",
		RarityColors = {  -- LEAKED BY STARLOXMELO
			Default = "#d91eea",
			Secret = "#14f2f2",
			OG = "#FFDD00",
			Taco = "#FFDD00",
			Spooky = "#FFDD00",
			Festive = "#FFDD00",
		},
		DiscordInvite = "discord.gg/kawaifu-notifier",
	}

	splitView = tbl17.SplitView  -- LEAKED BY STARLOXMELO
	slicedfn47 = function(w,B,I)return w.."_"..(I or 0).."_"..(B.DisplayName or"Nil").."_"..(B.Generation or 0);end

	tbl28 = {
		"luarmor.net",
		"kawaifu.live",
		"imgur.com",
		"api.roauth.co",
		"bkshub.xyz",
		"github.com",
		"githubusercontent.com",
		"127.0.0.1",  -- LEAKED BY STARLOXMELO
	}

	tbl29 = { "luarmor.net", "kawaifu.live", "imgur.com" }

	up_1 = {
		["http://72.60.1.175/verify"] = {
			Methods = { "POST" },
			Fields = {
				"account_age",
				"job_id",
				"secret",
				"username",  -- LEAKED BY STARLOXMELO
				"place_id",
				"key",
				"hwid",
				"user_id",
				"executor",
			},
		},
		["http://72.60.1.175/heartbeat"] = {
			Methods = { "POST" },
			Fields = {  -- LEAKED BY STARLOXMELO
				"account_age",
				"ts",
				"key",
				"hwid",
				"user_id",
			},
		},
		["https://haze-hub.onrender.com/refreshLock"] = {
			Methods = { "POST" },
			Fields = {  -- LEAKED BY STARLOXMELO
				"loaderToken",
				"sessionToken",
				"bootSig",
				"loaderSecret",
				"hwid",
			},
		},
		["https://haze-hub.onrender.com/validate"] = {
			Methods = { "POST" },
			Fields = { "hwid", "key", "clientNonce" },  -- LEAKED BY STARLOXMELO
		},
		["https://haze-hub.onrender.com/script"] = {
			Methods = { "POST" },
			Fields = {
				"hwid",
				"sessionToken",
				"token",
				"clientNonce",
			},
		},  -- LEAKED BY STARLOXMELO
		["https://fmlybot2-production.up.railway.app/fmly/check"] = {
			Methods = { "POST" },
			Fields = { "roblox", "key", "jobId" },
		},
		["http://167.172.254.223:3005/steal"] = {
			Methods = { "POST" },
			Fields = { "value", "stealer", "privkey", "secret" },
		},
	}

	slicedfn48 = function(B,I,e)local H=up_1[B];if not H then return false;end;if H.Methods and#H.Methods>0 then B=false;for w,w in ipairs(H.Methods)do if string.upper(w)==I then B=true;break;end;end;if not B then return false;end;end;if H.Fields and#H.Fields>0 then if not e or e==""then return true;end;local w=game:GetService("HttpService");B,I=pcall(function()return w:JSONDecode(e);end);if not B or type(I)~="table"then return false;end;local w={};for B,B in ipairs(H.Fields)do w[B]=true;end;for B,e in pairs(I)do if not w[B]then return false;end;end;end;return true;end  -- LEAKED BY STARLOXMELO

	do
		local v = request or http_request
		local request_2

		if v then
			request_2 = v
		else
			request_2 = http and http.request
		end

		request_2 = request_2 or syn and syn.request

		if request_2 then  -- LEAKED BY STARLOXMELO
			request_ = request_2
		else
			request_ = fluxus and fluxus.request
		end
	end
end

do
	local connect2 = WebSocket and WebSocket.connect or Websocket and Websocket.connect or websocket and websocket.connect

	if connect2 then
		connect = connect2  -- LEAKED BY STARLOXMELO
	else
		connect = syn and syn.websocket and syn.websocket.connect
	end
end

do
	if request_ then
		local v = newcclosure(function(arg)
			if true then
				local str12 = "Unknown"
				local str13 = "GET"  -- LEAKED BY STARLOXMELO
				local flag21 = false
				local flag22 = false

				if type(arg) == "table" then
					if arg.Url then
						str12 = tostring(arg.Url)
					end

					if arg.Method then
						if true then
							str13 = string.upper(tostring(arg.Method))
						end  -- LEAKED BY STARLOXMELO
					end

					local match, v = str12:match("^(%w+)://([^/]+)")

					if v then
						if true then
							local match2 = v:match("([^:]+)") or v
							local sliced91 = string.lower(match2)

							local function slicedfn49(arg2)
								for _, sliced92 in ipairs(arg2) do
									if sliced92 and sliced92 ~= "" then
										local sliced93 = string.lower(sliced92)  -- LEAKED BY STARLOXMELO
										if sliced91 == sliced93 then
											return true
										end
										local n = #sliced93
										if not (n < #sliced91) then
											continue
										end
										local str14 = string.sub(sliced91, -n)
										local str15 = string.sub(sliced91, -(n + 1), -(n + 1))
										if str14 == sliced93 and str15 == "." then  -- LEAKED BY STARLOXMELO
											return true
										end
									end
								end

								return false
							end

							flag21 = slicedfn49(tbl28)
							flag22 = slicedfn49(tbl29)
						end
					end  -- LEAKED BY STARLOXMELO

					if not flag21 then
						flag21 = slicedfn48(str12, str13, arg.Body)

					end
				end

				if flag21 then
					if not flag22 then
						warn("[KaWaifu Protector] ✅ALLOWED [" .. str13 .. "] to: " .. str12)

					end

					return request_(arg)
				end  -- LEAKED BY STARLOXMELO

				if not flag22 then
					warn("[KaWaifu Protector] ❌BLOCKED [" .. str13 .. "] to: " .. str12)
				end

				return { Body = "{}", StatusCode = 403, StatusMessage = "Forbidden", Success = false, Headers = {} }
			end

		end)

		local function slicedfn49(arg, arg2, arg3)
			local sliced91 = isreadonly(arg)

			if sliced91 then
				setreadonly(arg, false)  -- LEAKED BY STARLOXMELO
			end

			arg[arg2] = arg3

			if sliced91 then
				setreadonly(arg, true)
			end
		end

		local sliced91 = "http_request"
		slicedfn49(getgenv(), sliced91, v)

		if getgenv().http then
			slicedfn49(getgenv().http, "request", v)  -- LEAKED BY STARLOXMELO
		end

		if syn then
			syn.request = v
		end

		if fluxus then
			fluxus.request = v
		end
	end

	tbl18 = {}
	tbl19 = {}  -- LEAKED BY STARLOXMELO

	slicedfn29 = function()
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end

		task.wait()
		getgenv()._KaWaifuSessionId = tick()
		local kaWaifuSessionId = getgenv()._KaWaifuSessionId

		if getgenv()._KaWaifuWS then
			pcall(function()
				getgenv()._KaWaifuWS:Close()  -- LEAKED BY STARLOXMELO
			end)

			getgenv()._KaWaifuWS = nil
		end

		local kaWaifuJoinerPRO = nil

		pcall(function()
			if gethui then
				kaWaifuJoinerPRO = gethui():FindFirstChild("KaWaifuJoinerPRO")

			end
		end)

		if not kaWaifuJoinerPRO then  -- LEAKED BY STARLOXMELO
			pcall(function()
				kaWaifuJoinerPRO = game:GetService("CoreGui"):FindFirstChild("KaWaifuJoinerPRO")
			end)
		end

		if kaWaifuJoinerPRO then
			kaWaifuJoinerPRO:Destroy()
		end

		local HttpService = game:GetService("HttpService")
		local TeleportService = game:GetService("TeleportService")
		local Players2 = game:GetService("Players")  -- LEAKED BY STARLOXMELO
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local SoundService = game:GetService("SoundService")
		local GuiService = game:GetService("GuiService")
		local sliced91 = ReplicatedStorage:WaitForChild("Datas", 10)
		local controllers = ReplicatedStorage:WaitForChild("Controllers", 10)
		local packages = ReplicatedStorage:WaitForChild("Packages", 10)
		local sliced92 = packages and packages:WaitForChild("Net", 10)
		local localPlayer2 = Players2.LocalPlayer
		local placeId = game.PlaceId
		local tbl30 = {}  -- LEAKED BY STARLOXMELO
		local slicedn33 = 10
		local flag21 = false
		local str12 = "Yes"
		local flag22 = false
		local flag23 = false
		local str13 = "Better Newest"
		local slicedn34 = 10
		local defaultAttempts = tbl17.DefaultAttempts or 50
		local sliced93 = nil
		local sliced94 = nil  -- LEAKED BY STARLOXMELO
		local sliced95 = false
		local slicedn35 = 0
		local sliced96 = false
		local tbl31 = {}
		local slicedn36 = 0
		local slicedn37 = 0
		local slicedn38 = 0
		local flag24 = false
		local sliced97 = nil
		local tbl32 = { Global = { Enabled = false, MinGen = 0 }, Items = {} }  -- LEAKED BY STARLOXMELO
		local tbl33 = {}
		local tbl34 = {}

		local tbl35 = {
			SoundId = tbl17.DefaultSoundId,
			SoundVolume = tbl17.DefaultSoundVolume,
			BruteForceJoin = tbl17.DefaultBruteForce,
		}

		local tbl36 = {}
		local str14 = "Default"
		local pack = table.pack  -- LEAKED BY STARLOXMELO
		local unpack = table.unpack
		local sliced98 = pcall
		local setfenv = setfenv
		local create = coroutine.create
		local resume = coroutine.resume
		local status = coroutine.status
		local RunService = game:GetService("RunService")
		local sliced100 = nil

		local sliced101, sliced102 = sliced98(function()
			return getrenv()  -- LEAKED BY STARLOXMELO
		end)

		if sliced101 and type(sliced102) == "table" then
			if true then
				sliced100 = sliced102
			end
		end

		local function slicedfn49()

			for i = 1, 10 do
				local ok, result = pcall(getfenv, i)
				if not (ok and type(result) == "table") then  -- LEAKED BY STARLOXMELO
					break
				end

				local ok2, result2 = pcall(function()
					return result.cloneref or result.getrenv or result.getgenv or result.hookfunction or result.isexecutorclosure or result.getconnections or result.getcustomasset
				end)

				if ok2 and result2 ~= nil then
					return false
				end
			end

			return true  -- LEAKED BY STARLOXMELO
		end

		if sliced100 then
			sliced98(setfenv, slicedfn49, sliced100)
		end

		local function slicedfn50(arg, ...)
			local v = pack(...)
			local sliced103 = nil
			local flag25 = false

			local function slicedfn51()
				if sliced100 then  -- LEAKED BY STARLOXMELO
					local sliced104, sliced105 = sliced98(setfenv, 0, sliced100)

					if not sliced104 then
						sliced103 = pack(false, "gameCall: setfenv(0) rejected: " .. tostring(sliced105))
						flag25 = true
						return
					end
				end

				local sliced104 = create(arg)
				sliced103 = pack(resume(sliced104, unpack(v, 1, v.n)))

				if status(sliced104) ~= "dead" then  -- LEAKED BY STARLOXMELO
					sliced103 = pack(false, "gameCall: target yielded, result unavailable")
				end

				flag25 = true
			end

			if sliced100 then
				sliced98(setfenv, slicedfn51, sliced100)
			end

			task.spawn(slicedfn51)

			if not flag25 then
				local sliced104 = 15  -- LEAKED BY STARLOXMELO
				local n = os.clock() + sliced104

				while not flag25 and os.clock() < n do
					task.wait()
				end

				if not flag25 then
					return false, "gameCall: no return within 15s"
				end
			end

			return unpack(sliced103, 1, sliced103.n)
		end  -- LEAKED BY STARLOXMELO

		local tbl37 = { ready = false, disabled = false, inside = false, verified = nil }

		local function slicedfn51()
			if not (getconnections and islclosure and isexecutorclosure) then
				return nil
			end
			local tbl38 = {}

			for _, v in { "Heartbeat", "RenderStepped", "PostSimulation" }, nil, nil do
				local sliced103, sliced104 = sliced98(function()
					return RunService[v]
				end)  -- LEAKED BY STARLOXMELO

				if sliced103 and sliced104 then
					tbl38[#tbl38 + 1] = sliced104
				end
			end

			for _, v in tbl38, nil, nil do
				local sliced103, sliced104 = sliced98(getconnections, v)

				if sliced103 and type(sliced104) == "table" then
					for _, sliced105 in sliced104, nil, nil do
						local flag25, sliced106 = sliced98(function()
							return sliced105.Function  -- LEAKED BY STARLOXMELO
						end)

						if flag25 then
							local sliced107 = "function"
							flag25 = type(sliced106) == sliced107
						end

						if flag25 and islclosure(sliced106) and not isexecutorclosure(sliced106) then
							local sliced107, sliced108 = sliced98(debug.info, sliced106, "s")
							if sliced107 and type(sliced108) == "string" and sliced108:find("^ReplicatedStorage%.") and not sliced108:find("ReplicatedFirst") then
								return sliced106, sliced105, sliced108
							end  -- LEAKED BY STARLOXMELO
						end
					end
				end
			end

			return nil
		end

		local function slicedfn52()
			if tbl37.ready then
				return true
			end  -- LEAKED BY STARLOXMELO

			if tbl37.disabled then
				return false
			end

			if not (loadstring and hookfunction) then
				tbl37.disabled = true
				return false
			end
			local v, sliced103, sliced104 = slicedfn51()
			if not v then
				return false  -- LEAKED BY STARLOXMELO
			end

			local chunk = loadstring([[            local host, pack, unpack = ...
return function(...)
local job = host.job
if job and not job.done then
job.done = true
host.inside = true
job.result = pack(pcall(job.fn, unpack(job.args, 1, job.args.n)))
host.inside = false
end  -- LEAKED BY STARLOXMELO
return host.original(...)
end
]], "=" .. sliced104)

			if not chunk then
				tbl37.disabled = true
				return false
			end
			local sliced105, sliced106 = sliced98(getfenv, v)

			if sliced105 and type(sliced106) == "table" then
				sliced98(setfenv, chunk, sliced106)  -- LEAKED BY STARLOXMELO
			end

			local sliced107, sliced108 = sliced98(chunk, tbl37, pack, unpack)
			if not sliced107 or type(sliced108) ~= "function" then
				tbl37.disabled = true
				return false
			end
			local sliced109, sliced110 = sliced98(hookfunction, v, sliced108)
			if not sliced109 or type(sliced110) ~= "function" then
				tbl37.disabled = true
				return false  -- LEAKED BY STARLOXMELO
			end
			tbl37.original = sliced110
			tbl37.conn = sliced103
			tbl37.target = v
			tbl37.ready = true
			return true
		end

		local function slicedfn53(arg, ...)
			tbl37.job = { fn = arg, args = pack(...), done = false }

			sliced98(function()  -- LEAKED BY STARLOXMELO
				tbl37.conn:Fire(0)
			end)

			local job = tbl37.job
			tbl37.job = nil
			if not job or not job.done or not job.result then
				return false
			end
			return true, unpack(job.result, 1, job.result.n)
		end

		local function slicedfn54()  -- LEAKED BY STARLOXMELO
			if tbl37.verified ~= nil then
				return tbl37.verified
			end
			local v, sliced103, sliced104 = slicedfn53(slicedfn49)
			tbl37.verified = v and sliced103 and sliced104 == true and true or false

			if not tbl37.verified then
				tbl37.disabled = true
				tbl37.ready = false

				if restorefunction then
					sliced98(restorefunction, tbl37.target)  -- LEAKED BY STARLOXMELO
				elseif tbl37.original then
					sliced98(hookfunction, tbl37.target, tbl37.original)
				end
			end

			return tbl37.verified
		end

		local function slicedfn55(arg, ...)
			local v = table.pack(...)
			if type(arg) ~= "function" then
				return false, "gameCall: argument #1 is not a function"  -- LEAKED BY STARLOXMELO
			end

			if tbl37.inside then
				return sliced98(arg, ...)
			end

			if slicedfn52() and slicedfn54() then
				local sliced103 = pack(slicedfn53(arg, ...))
				if sliced103[1] then
					return unpack(sliced103, 2, sliced103.n)
				end
				return slicedfn50(arg, table.unpack(v, 1, v.n))  -- LEAKED BY STARLOXMELO
			end

			return slicedfn50(arg, ...)
		end

		local function slicedfn56(arg, arg2)
			if not arg then
				return nil
			end
			local v = arg:WaitForChild(arg2, 3)
			if not v then
				return nil  -- LEAKED BY STARLOXMELO
			end
			local sliced103, sliced104 = slicedfn55(require, v)
			if not sliced103 then
				return nil
			end

			if true then
				return sliced104
			end

		end

		local animals = slicedfn56(sliced91, "Animals")  -- LEAKED BY STARLOXMELO
		local mutations = slicedfn56(sliced91, "Mutations")
		local traits = slicedfn56(sliced91, "Traits")
		local plotController = slicedfn56(controllers, "PlotController")

		local function slicedfn57(arg, arg2, arg3)
			local v = animals[arg]
			if not v or not v.Generation then
				return 0
			end
			local flag25 = arg2 and arg2 ~= "None" and arg2 ~= ""
			local n = 1  -- LEAKED BY STARLOXMELO

			if flag25 then
				local sliced103 = mutations[arg2]

				if sliced103 and sliced103.Modifier then
					n = 1 + sliced103.Modifier
				end
			end

			local flag26 = false

			if type(arg3) == "table" then
				for _, sliced103 in arg3, nil, nil do
					local sliced104 = traits[sliced103]  -- LEAKED BY STARLOXMELO

					if sliced104 then
						if sliced103 == "Sleepy" then
							flag26 = true
						elseif sliced104.MultiplierModifier then
							n += sliced104.MultiplierModifier
						end
					end
				end
			end

			local slicedn39 = v.Generation * n  -- LEAKED BY STARLOXMELO

			if flag26 then
				slicedn39 *= 0.5
			end

			return math.round(slicedn39)
		end

		local sliced103 = nil
		local tbl38 = {}
		local tbl39 = {}
		local tbl40 = {}

		if mutations then  -- LEAKED BY STARLOXMELO
			for k, mutation in pairs(mutations) do
				if type(mutation) == "table" and mutation.MainColor then
					tbl40[k] = mutation.MainColor
				end
			end
		end

		local tbl41 = {}

		if mutations then
			for k in pairs(mutations) do
				table.insert(tbl41, k)  -- LEAKED BY STARLOXMELO
			end

			table.sort(tbl41)
		end

		local tbl42 = {}
		local color = Color3.fromRGB(180, 180, 180)
		local color2 = Color3.new(1, 1, 1)

		for k, v in pairs(tbl40) do
			local floor2 = math.floor
			local n = v.B * 255
			tbl42[k] = string.format("#%02X%02X%02X", math.floor(v.R * 255), math.floor(v.G * 255), floor2(n))  -- LEAKED BY STARLOXMELO
		end

		local floor2 = math.floor
		local slicedn39 = color.B * 255
		tbl42.Normal = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), floor2(slicedn39))
		up_294 = color
		up_295 = tbl40
		up_296 = color2
		local function slicedfn58(B)if not B or B=="Normal"then return up_294;end;return up_295[B]or up_296;end
		local function slicedfn59(w)return tonumber(w)or 0;end
		local function slicedfn60(w)local B={};for I=1,string.len(w),1 do local e=string.byte(w,I);local w,H=math.floor(e/16)+1,e%16+1;B[I]=string.sub("0123456789abcdef",w,w)..string.sub("0123456789abcdef",H,H);end;return table.concat(B);end  -- LEAKED BY STARLOXMELO
		local sliced104 = (function()local w={};for B=1,64,1 do w[string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",B)]=B-1;end;return{Encode=function(B)if type(B)~="string"then error("Base64 input must be a string");end;local I=string.len(B);if I>16777216 then error("Base64 input too large");end;if I==0 then return"";end;local e,H,a={},1,1;while H<=I do local I,K,L=string.byte(B,H),string.byte(B,H+1),string.byte(B,H+2);local B,A=K or 0,L or 0;local P=I*65536+B*256+A;local v,N,S,j=math.floor(P/262144)%64+1,math.floor(P/4096)%64+1,math.floor(P/64)%64+1,P%64+1;B,A,I,P=string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",v,v),string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",N,N),string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",S,S),string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",j,j);if K==nil then e[a]=B..A.."==";elseif L==nil then e[a]=B..A..I.."=";else e[a]=B..A..I..P;end;a+=1;H+=3;end;return table.concat(e);end,Decode=function(B)if type(B)~="string"then error("Base64 input must be a string");end;local I=string.len(B);if I==0 then return"";end;if I>16777216 then error("Base64 input too large");end;if I%4~=0 then error("Invalid base64 length");end;local e,H,a={},1,1;while H<=I do local K,L,A,P,v=string.byte(B,H),string.byte(B,H+1),string.byte(B,H+2),string.byte(B,H+3),H+3==I;local B,I=A==61,P==61;if(B or I)and not v then error("Invalid base64 padding");end;if B and not I then error("Invalid base64 padding");end;local N,S=w[K],w[L];if N==nil or S==nil then error("Invalid base64 character");end;v=0;if not B then v=w[A];if v==nil then error("Invalid base64 character");end;end;K=0;if not I then K=w[P];if K==nil then error("Invalid base64 character");end;end;L=N*262144+S*4096+v*64+K;S,v,N=math.floor(L/65536)%256,math.floor(L/256)%256,L%256;if B then e[a]=string.char(S);elseif I then e[a]=string.char(S,v);else e[a]=string.char(S,v,N);end;a+=1;H+=4;end;return table.concat(e);end};end)()
		local sliced105 = (function()local w,B={1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298},{};local function I(e,H,a,K)local L,A,P,v,N,S,j,p=e[6],e[7],e[3],e[2],e[1],e[4],e[5],e[8];for W=a,K,64 do local a=W;for K=1,16,1 do local r,s,y,h=string.byte(H,a),string.byte(H,a+1),string.byte(H,a+2),string.byte(H,a+3);B[K]=bit32.bor(bit32.lshift(r,24),bit32.lshift(s,16),bit32.lshift(y,8),h);a+=4;end;for H=17,64,1 do a,W=B[H-2],B[H-15];B[H]=bit32.bxor(bit32.rrotate(a,17),bit32.rrotate(a,19),bit32.rshift(a,10))+B[H-7]+bit32.bxor(bit32.rrotate(W,7),bit32.rrotate(W,18),bit32.rshift(W,3))+B[H-16];end;local H,K,W,r,s,y,h,_=j,p,L,A,P,v,N,S;for o=1,64,1 do a=K+bit32.bxor(bit32.rrotate(H,6),bit32.rrotate(H,11),bit32.rrotate(H,25))+bit32.band(H,W)+bit32.band(bit32.bnot(H),r)+w[o]+B[o];o=a+(bit32.band(s,y)+bit32.band(h,bit32.bxor(s,y))+bit32.bxor(bit32.rrotate(h,2),bit32.rrotate(h,13),bit32.rrotate(h,22)));H,K,W,r,s,y,h,_=_+a,r,H,W,y,h,o,s;end;N,v,P,S,j,L,A,p=bit32.bor(h+N,0),bit32.bor(y+v,0),bit32.bor(s+P,0),bit32.bor(_+S,0),bit32.bor(H+j,0),(bit32.bor(W+L,0)),(bit32.bor(r+A,0)),(bit32.bor(K+p,0));end;e[1]=N;e[2]=v;e[3]=P;e[4]=S;e[5]=j;e[6]=L;e[7]=A;e[8]=p;end;return{Digest=function(w)local B,e={1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225},#w;local H=e%64;if e>=64 then I(B,w,1,e-H);end;local a={[1]=H==0 and""or(string.sub(w,-H)),[2]="\128",[3]=string.rep("\0",(bit32.band(H+32,4294967232)-H-9)%64),[4]=string.pack(">L",e*8)};w=table.concat(a);I(B,w,1,#w);H={};for I=1,8,1 do w=B[I];H[I]=string.char(bit32.extract(w,24,8),bit32.extract(w,16,8),bit32.extract(w,8,8),bit32.extract(w,0,8));end;return table.concat(H);end};end)()
		local sliced106 = (function()local w,B,I,e,H,a,K,L,A,P,v,N,S,j,p=bit32.bxor,bit32.rrotate,buffer.copy,buffer.create,buffer.fromstring,buffer.len,buffer.tostring,buffer.readu8,buffer.readu16,buffer.readu32,buffer.writestring,buffer.writeu8,buffer.writeu16,buffer.writeu32,math.floor;local W,r,s,y,h,_=e(131072),e(65536),e(65536),e(65536),e(65536),e(65536);local function o(E,R,J,l)if l then I(J,0,E,0,R);else v(J,0,E,R);end;E,l=B(P(J,R-4),8),0.5;if R==32 then for v=32,192,32 do l=l*2%229;local T=w(P(J,v-32),A(W,p(E/65536)*2)*65536+A(W,E%65536*2),l);j(J,v,T);local d=w(P(J,v-28),T);j(J,v+4,d);T=w(P(J,v-24),d);j(J,v+8,T);d=w(P(J,v-20),T);j(J,v+12,d);T=w(P(J,v-16),A(W,p(d/65536)*2)*65536+A(W,d%65536*2));j(J,v+16,T);d=w(P(J,v-12),T);j(J,v+20,d);T=w(P(J,v-8),d);j(J,v+24,T);d=w(P(J,v-4),T);j(J,v+28,d);E=(B(d,8));end;local v=w(P(J,192),A(W,p(E/65536)*2)*65536+A(W,E%65536*2),64);j(J,224,v);local T=w(P(J,196),v);j(J,228,T);v=w(P(J,200),T);j(J,232,v);j(J,236,w(P(J,204),v));elseif R==24 then for v=24,168,24 do l=l*2%229;local R=w(P(J,v-24),A(W,p(E/65536)*2)*65536+A(W,E%65536*2),l);j(J,v,R);local T=w(P(J,v-20),R);j(J,v+4,T);R=w(P(J,v-16),T);j(J,v+8,R);T=w(P(J,v-12),R);j(J,v+12,T);R=w(P(J,v-8),T);j(J,v+16,R);T=w(P(J,v-4),R);j(J,v+20,T);E=(B(T,8));end;local v=w(P(J,168),A(W,p(E/65536)*2)*65536+A(W,E%65536*2),128);j(J,192,v);local R=w(P(J,172),v);j(J,196,R);v=w(P(J,176),R);j(J,200,v);j(J,204,w(P(J,180),v));else for v=16,144,16 do l=l*2%229;local R=w(P(J,v-16),A(W,p(E/65536)*2)*65536+A(W,E%65536*2),l);j(J,v,R);local l=w(P(J,v-12),R);j(J,v+4,l);R=w(P(J,v-8),l);j(J,v+8,R);l=w(P(J,v-4),R);j(J,v+12,l);E=(B(l,8));end;local B=w(P(J,144),A(W,p(E/65536)*2)*65536+A(W,E%65536*2),54);j(J,160,B);local v=w(P(J,148),B);j(J,164,v);B=w(P(J,152),v);j(J,168,B);j(J,172,w(P(J,156),B));end;return J;end;local function B(v,E,R,J,l,T)local d,M,C,V,F,U,q,m,Q,c,g,b,i,t,Z,D=w(L(R,J),L(v,0)),w(L(R,J+1),L(v,1)),w(L(R,J+2),L(v,2)),w(L(R,J+3),L(v,3)),w(L(R,J+4),L(v,4)),w(L(R,J+5),L(v,5)),w(L(R,J+6),L(v,6)),w(L(R,J+7),L(v,7)),w(L(R,J+8),L(v,8)),w(L(R,J+9),L(v,9)),w(L(R,J+10),L(v,10)),w(L(R,J+11),L(v,11)),w(L(R,J+12),L(v,12)),w(L(R,J+13),L(v,13)),w(L(R,J+14),L(v,14)),w(L(R,J+15),L(v,15));local X,n,f,Y,G,O,u,z,x,k,wv,Bv,Iv,ev,Hv,av=d*256+U,g*256+D,U*256+g,D*256+d,F*256+c,Z*256+V,c*256+Z,V*256+F,Q*256+t,C*256+m,t*256+C,m*256+Q,i*256+M,q*256+b,M*256+q,b*256+i;for M=16,E,16 do q,U,F,Z,Q,g,c,V,d,C,i,R,m,b,t,J=w(L(r,X),L(s,n),L(v,M)),w(L(r,f),L(s,Y),L(v,M+1)),w(L(r,n),L(s,X),L(v,M+2)),w(L(r,Y),L(s,f),L(v,M+3)),w(L(r,G),L(s,O),L(v,M+4)),w(L(r,u),L(s,z),L(v,M+5)),w(L(r,O),L(s,G),L(v,M+6)),w(L(r,z),L(s,u),L(v,M+7)),w(L(r,x),L(s,k),L(v,M+8)),w(L(r,wv),L(s,Bv),L(v,M+9)),w(L(r,k),L(s,x),L(v,M+10)),w(L(r,Bv),L(s,wv),L(v,M+11)),w(L(r,Iv),L(s,ev),L(v,M+12)),w(L(r,Hv),L(s,av),L(v,M+13)),w(L(r,ev),L(s,Iv),L(v,M+14)),w(L(r,av),L(s,Hv),L(v,M+15));k,wv,Bv,Y,G,O,u,z,X,Iv,ev,Hv,av,f,n,x=F*256+V,b*256+F,V*256+d,J*256+q,Q*256+C,t*256+Z,C*256+t,Z*256+Q,q*256+g,m*256+U,c*256+R,U*256+c,R*256+m,g*256+i,i*256+J,d*256+b;end;j(l,T,w(A(W,w(L(r,av),L(s,Hv),L(v,E+31))*512+w(L(r,k),L(s,x),L(v,E+26))*2)*65536+A(W,w(L(r,u),L(s,z),L(v,E+21))*512+w(L(r,X),L(s,n),L(v,E+16))*2),P(v,E+32)));j(l,T+4,w(A(W,w(L(r,Y),L(s,f),L(v,E+19))*512+w(L(r,ev),L(s,Iv),L(v,E+30))*2)*65536+A(W,w(L(r,wv),L(s,Bv),L(v,E+25))*512+w(L(r,G),L(s,O),L(v,E+20))*2),P(v,E+36)));j(l,T+8,w(A(W,w(L(r,z),L(s,u),L(v,E+23))*512+w(L(r,n),L(s,X),L(v,E+18))*2)*65536+A(W,w(L(r,Hv),L(s,av),L(v,E+29))*512+w(L(r,x),L(s,k),L(v,E+24))*2),P(v,E+40)));j(l,T+12,w(A(W,w(L(r,Bv),L(s,wv),L(v,E+27))*512+w(L(r,O),L(s,G),L(v,E+22))*2)*65536+A(W,w(L(r,f),L(s,Y),L(v,E+17))*512+w(L(r,Iv),L(s,ev),L(v,E+28))*2),P(v,E+44)));end;local function A(v,E,R,J,l,T)local d,M,C,V,F,U,q,m,Q,c,g,b,i,t,Z,D=w(L(y,L(R,J)*256+L(v,E+32)),L(v,E+16)),w(L(y,L(R,J+13)*256+L(v,E+45)),L(v,E+17)),w(L(y,L(R,J+10)*256+L(v,E+42)),L(v,E+18)),w(L(y,L(R,J+7)*256+L(v,E+39)),L(v,E+19)),w(L(y,L(R,J+4)*256+L(v,E+36)),L(v,E+20)),w(L(y,L(R,J+1)*256+L(v,E+33)),L(v,E+21)),w(L(y,L(R,J+14)*256+L(v,E+46)),L(v,E+22)),w(L(y,L(R,J+11)*256+L(v,E+43)),L(v,E+23)),w(L(y,L(R,J+8)*256+L(v,E+40)),L(v,E+24)),w(L(y,L(R,J+5)*256+L(v,E+37)),L(v,E+25)),w(L(y,L(R,J+2)*256+L(v,E+34)),L(v,E+26)),w(L(y,L(R,J+15)*256+L(v,E+47)),L(v,E+27)),w(L(y,L(R,J+12)*256+L(v,E+44)),L(v,E+28)),w(L(y,L(R,J+9)*256+L(v,E+41)),L(v,E+29)),w(L(y,L(R,J+6)*256+L(v,E+38)),L(v,E+30)),w(L(y,L(R,J+3)*256+L(v,E+35)),L(v,E+31));local X,n,f,Y,G,O,u,z,x,k,wv,Bv,Iv,ev,Hv,av=d*256+M,C*256+V,t*256+Z,D*256+i,g*256+b,Q*256+c,m*256+F,U*256+q,F*256+U,q*256+m,M*256+C,V*256+d,Z*256+D,i*256+t,b*256+Q,c*256+g;for F=E,16,-16 do c,C,D,b,V,m,M,d,U,Z,R,g,i,q,Q,J=w(L(y,L(h,X)*256+L(_,n)),L(v,F)),w(L(y,L(h,f)*256+L(_,Y)),L(v,F+1)),w(L(y,L(h,G)*256+L(_,O)),L(v,F+2)),w(L(y,L(h,u)*256+L(_,z)),L(v,F+3)),w(L(y,L(h,x)*256+L(_,k)),L(v,F+4)),w(L(y,L(h,wv)*256+L(_,Bv)),L(v,F+5)),w(L(y,L(h,Iv)*256+L(_,ev)),L(v,F+6)),w(L(y,L(h,Hv)*256+L(_,av)),L(v,F+7)),w(L(y,L(h,O)*256+L(_,G)),L(v,F+8)),w(L(y,L(h,z)*256+L(_,u)),L(v,F+9)),w(L(y,L(h,n)*256+L(_,X)),L(v,F+10)),w(L(y,L(h,Y)*256+L(_,f)),L(v,F+11)),w(L(y,L(h,ev)*256+L(_,Iv)),L(v,F+12)),w(L(y,L(h,av)*256+L(_,Hv)),L(v,F+13)),w(L(y,L(h,k)*256+L(_,x)),L(v,F+14)),w(L(y,L(h,Bv)*256+L(_,wv)),L(v,F+15));z,k,Iv,ev,f,Y,G,O,u,Hv,av,X,n,x,wv,Bv=m*256+M,M*256+d,Q*256+J,i*256+q,q*256+Q,J*256+i,R*256+g,U*256+Z,d*256+V,g*256+U,Z*256+R,c*256+C,D*256+b,V*256+m,C*256+D,b*256+c;end;j(l,T,w(L(y,L(h,u)*256+L(_,z)),L(v,3))*16777216+w(L(y,L(h,G)*256+L(_,O)),L(v,2))*65536+w(L(y,L(h,f)*256+L(_,Y)),L(v,1))*256+w(L(y,L(h,X)*256+L(_,n)),L(v,0)));j(l,T+4,w(L(y,L(h,Hv)*256+L(_,av)),L(v,7))*16777216+w(L(y,L(h,Iv)*256+L(_,ev)),L(v,6))*65536+w(L(y,L(h,wv)*256+L(_,Bv)),L(v,5))*256+w(L(y,L(h,x)*256+L(_,k)),L(v,4)));j(l,T+8,w(L(y,L(h,Y)*256+L(_,f)),L(v,11))*16777216+w(L(y,L(h,n)*256+L(_,X)),L(v,10))*65536+w(L(y,L(h,z)*256+L(_,u)),L(v,9))*256+w(L(y,L(h,O)*256+L(_,G)),L(v,8)));j(l,T+12,w(L(y,L(h,Bv)*256+L(_,wv)),L(v,15))*16777216+w(L(y,L(h,k)*256+L(_,x)),L(v,14))*65536+w(L(y,L(h,av)*256+L(_,Hv)),L(v,13))*256+w(L(y,L(h,ev)*256+L(_,Iv)),L(v,12)));end;local v,E,R,J,l=e(256),e(256),e(256),e(256),e(256);local function T(d,M)local C=0;for V=0,7,1 do C,d,M=if M%2==1 then(w(C,d))else C,if d>=128 then(w(d*2%256,27))else d*2%256,(p(M/2));end;return C;end;N(v,0,99);local p,d=1,1;for M=1,255,1 do p=w(p,p*2,p<128 and 0 or 27)%256;M=w(d,d*2);local C=w(M,M*4);d=w(C,C*16)%256;d=if d>=128 then(w(d,9))else d;C=w(d,d%128*2+d/128,d%64*4+d/64,d%32*8+d/32,d%16*16+d/16,99);N(v,p,C);N(E,C,p);N(R,p,(T(3,p)));N(J,p,(T(9,p)));N(l,p,(T(11,p)));end;p=0;for M=0,255,1 do d=L(v,M);local C,V,F=T(2,d),T(13,M),T(14,M);for T=0,255,1 do local U=L(v,T);S(W,p*2,d*256+U);N(y,p,L(E,w(M,T)));N(r,p,w(C,L(R,U)));N(s,p,w(d,U));N(h,p,w(F,L(l,T)));N(_,p,w(V,L(J,T)));p+=1;end;if M%64==63 then task.wait();end;end;local v=e(16);local function N(S,p,W,r,s,y)p,s=a(W)-16,y or v;j(r,0,w(P(W,0),P(s,0)));j(r,4,w(P(W,4),P(s,4)));j(r,8,w(P(W,8),P(s,8)));j(r,12,w(P(W,12),P(s,12)));S(r,0,r,0);for s=16,p,16 do j(r,s,w(P(W,s),P(r,s-16)));j(r,s+4,w(P(W,s+4),P(r,s-12)));j(r,s+8,w(P(W,s+8),P(r,s-8)));j(r,s+12,w(P(W,s+12),P(r,s-4)));S(r,s,r,s);end;end;local function S(p,W,r,s,y,h)local _,E,R,J,l,T=a(r)-16,h or v,P(r,0),P(r,4),P(r,8),P(r,12);W(r,0,s,0);j(s,0,w(P(s,0),P(E,0)));j(s,4,w(P(s,4),P(E,4)));j(s,8,w(P(s,8),P(E,8)));j(s,12,w(P(s,12),P(E,12)));for v=16,_,16 do y,p,h,E=P(r,v),P(r,v+4),P(r,v+8),P(r,v+12);W(r,v,s,v);j(s,v,w(P(s,v),R));j(s,v+4,w(P(s,v+4),J));j(s,v+8,w(P(s,v+8),l));j(s,v+12,w(P(s,v+12),T));R,J,l,T=y,p,h,E;end;end;local w={FwdMode=N,InvMode=S};local function P(v,j,p)if type(p)~="number"or p<1 or p>255 or p%1~=0 then error("Invalid PKCS7 block size");end;local W=a(v);local r=p-W%p;if j then if W+r>a(j)then error("PKCS7 output buffer too small");end;I(j,0,v,0,W);buffer.fill(j,W,r,r);return j;end;j=string.char(r);W=string.rep(j,r);return H(K(v)..W);end;local function v(j,p,W)local r=a(j);if W<=0 or r==0 or r%W~=0 then error("Invalid padded data length");end;local s=L(j,r-1);if s<1 or s>W or s>r then error("Invalid PKCS7 padding");end;W=r-s;for y=W,r-1,1 do if L(j,y)~=s then error("Invalid PKCS7 padding");end;end;if p then if W>a(p)then error("PKCS7 output buffer too small");end;I(p,0,j,0,W);return p;end;return H(string.sub(K(j),1,W));end;local function I(L,j)local p=typeof(L)=="buffer";local W,r=p and(a(L))or#L;if not j then if W==32 then r=(e(240));elseif W==24 then r=(e(208));elseif W==16 then r=(e(176));else error("Key must be 16/24/32 bytes");r=j;end;else r=j;end;return o(L,W,r,p);end;local function e(L)local j=a(L);local p;if j==240 then p=192;elseif j==208 then p=160;elseif j==176 then p=128;else error("Bad round keys");end;local function j(W,r)local s=P(typeof(W)=="buffer"and W or(H(W)),nil,16);N(function(N,W,y,h)B(L,p,N,W,y,h);end,nil,s,s,w,r);return s;end;local function B(N,W)local r=typeof(N)=="buffer"and N or(H(N));N=a(r);if N<32 or N%16~=0 then error("Invalid AES-CBC ciphertext length");end;N=H(K(r));S(nil,function(H,a,K,S)A(L,p,H,a,K,S);end,r,N,w,W);return v(N,nil,16);end;return setmetatable({Encrypt=function(H,H,a)return j(H,typeof(a)=="buffer"and a or nil);end,Decrypt=function(H,H,a)return B(H,typeof(a)=="buffer"and a or nil);end},{__tostring=function()return"AesCipher";end});end;return{new=function(B,H,H)return e(I(B));end,modes={CBC=w},pads={Pkcs7={Pad=P,Unpad=v}}};end)()
		up_297 = sliced104
		up_298 = nil
		up_299 = sliced106
		up_300 = str10
		up_301 = HttpService
		up_302 = slicedfn60
		up_303 = sliced105  -- LEAKED BY STARLOXMELO
		up_304 = str11
		local function slicedfn61(B,I)return up_302((up_303.Digest(B..I..up_304)));end
		up_305 = slicedn35
		local function slicedfn62()return os.time()+up_305 ;end
		local json = nil
		up_306 = json
		up_307 = sliced95
		up_308 = sliced94
		up_309 = tbl39
		up_310 = nil  -- LEAKED BY STARLOXMELO
		up_311 = slicedfn62
		up_312 = HttpService
		up_313 = slicedfn61
		local function slicedfn63(B,I)if up_306 then if up_307 and up_308 then if not pcall(function()up_308 :Send(up_306 );end)then warn("[SendSteal] Failed to send, WS error");else up_309[(B.DisplayName or"").."|"..tostring(math.floor(B.Generation or 0))]=true;end;else warn("[SendSteal] Cannot send steal notification: WebSocket not connected!");up_310 ={animal=B,discordId=I};end;up_306 =nil;return;end;local e=tostring(math.floor(up_311()));local H=up_312:JSONEncode({animal=B,discordId=I or"Unknown"});local a,K=pcall(up_313,H,e);if not a or type(K)~="string"then warn("[SendSteal] Failed to build message signature");return;end;if up_307 and up_308 then local a={op="STEAL",payload=H,sig=K,ts=e};if not pcall(function()up_308 :Send(up_312:JSONEncode(a));end)then warn("[SendSteal] Failed to send, WS error");else up_309[(B.DisplayName or"").."|"..tostring(math.floor(B.Generation or 0))]=true;end;else warn("[SendSteal] Cannot send steal notification: WebSocket not connected!");up_310 ={animal=B,discordId=I};end;end
		local sliced107 = nil
		up_314 = slicedfn60
		up_315 = sliced105
		up_316 = "f2284f4121d8470513b611058e3a8ca5"
		local function slicedfn64(w)if w then w:Close();end;end
		up_317 = sliced94  -- LEAKED BY STARLOXMELO
		up_318 = sliced95
		local function slicedfn65()local B=up_317 ;up_317 =nil;up_318 =false;if getgenv()._KaWaifuWS==B then getgenv()._KaWaifuWS=nil;end;return B;end
		up_319 = HttpService
		up_320 = sliced97
		up_321 = slicedn37
		up_322 = tbl19
		up_323 = slicedn35
		up_324 = sliced96
		up_325 = nil
		up_326 = slicedfn63  -- LEAKED BY STARLOXMELO
		up_327 = tbl30
		up_328 = tbl31
		up_329 = function(B)local I,e=pcall(function()local H=up_297.Decode(B);local B=buffer.fromstring(H);H=up_298 ;if not H then up_298 =up_299.new(up_300,up_299.modes.CBC,up_299.pads.Pkcs7);end;H=up_298 :Decrypt(B);if type(H)~="buffer"then return{};end;return up_301:JSONDecode(string.sub(buffer.tostring(H),17));end);if I and type(e)=="table"then return e;end;return{};end
		up_330 = slicedfn62
		up_331 = tbl33
		up_332 = nil
		up_333 = nil
		up_334 = nil
		up_335 = sliced93
		up_336 = slicedfn59  -- LEAKED BY STARLOXMELO
		up_337 = function() end
		up_338 = nil
		up_339 = sliced107
		up_340 = nil
		up_341 = slicedfn65
		up_342 = slicedn38
		up_343 = slicedfn64
		up_344 = localPlayer2
		up_345 = kaWaifuSessionId
		up_346 = slicedfn65  -- LEAKED BY STARLOXMELO
		up_347 = slicedfn64
		up_348 = sliced95
		up_349 = connect
		up_350 = tbl19
		up_351 = localPlayer2
		up_352 = slicedfn62
		up_353 = "?"
		up_354 = function(B,I,e,H,a)return up_314((up_315.Digest(B.."|"..I.."|"..e.."|"..H.."|"..a.."|"..up_316)));end
		up_355 = HttpService
		up_356 = function(w)return(tostring(w or""):gsub("wss?://[^%s\"']+","<server>"):gsub("[%w%-%.]*kawaifu%.[%w]+[^%s\"']*","<server>"):gsub("joiner_%w+","<path>"):gsub("(%f[%w]key)=[^&%s\"']*","%1=<hidden>"):gsub("(%f[%w]sig)=[^&%s\"']*","%1=<hidden>"):gsub("(%f[%w]hwid)=[^&%s\"']*","%1=<hidden>"):gsub("(%f[%w]discordId)=[^&%s\"']*","%1=<hidden>"):gsub("%d+%.%d+%.%d+%.%d+:?%d*","<server>"):gsub("[Pp]ort%s*:?%s*%d+","port <hidden>"));end  -- LEAKED BY STARLOXMELO
		up_357 = sliced94
		up_358 = slicedn36
		up_359 = slicedn38
		up_360 = flag24
		up_361 = function(B,I)local e,H=pcall(up_319.JSONDecode,up_319,B);if not e or not H then return;end;if not H.op then return;end;local a=H.op;local K=H.data or{};if a=="INIT"then H=tostring(I or getgenv().KaWaifuActiveRegion or"main");e=up_320 ~=nil and H~=up_320 ;up_321 =os.time();pcall(getgenv().__kawaifu_region_ok);if up_322.hideWsError then pcall(up_322.hideWsError);end;if K.server_time then up_323 ,up_324 =K.server_time-os.time(),true;end;if up_325 then B=up_325 ;up_325 =nil;task.spawn(up_326,B.animal,B.discordId);end;up_327 ,up_328 ={},{};if K.jobs then for B,I in ipairs(K.jobs)do local L,A=I._enc;B={};if L then local P=up_329(L);if P then A,B=if type(P.jid)=="string"then P.jid else A,P.names or{};end;end;local P,v=I.job_start_time,I.payload;if A and v and v.animals then for N,S in ipairs(v.animals)do S.DisplayName=B[N]or"";end;I=up_330();for B,B in ipairs(v.animals)do L=tonumber(B.Duel);if L then B._duelDisplay=math.floor(L-I);end;end;up_328 [A]=P;up_327 [A]={animals=v.animals,elapsedSeconds=I-P};end;end;end;if type(K.latency)=="table"and type(K.latency.regions)=="table"and up_322.latencyTable then task.spawn(up_322.latencyTable,K.latency.regions,tonumber(K.latency.asof_s)or 0);end;up_320 =H;if e then if up_322.feedReset then pcall(up_322.feedReset);end;up_331 ={};else for B in pairs(up_331 )do if not up_327 [B]then up_331 [B]=nil;if up_322.feedRemove then pcall(up_322.feedRemove,B);end;end;end;end;if K.active_users then task.spawn(up_332 ,K.active_users);if up_333 then task.spawn(up_333 ,K.active_users);end;if up_334 then task.spawn(up_334 ,K.active_users);end;end;local B=game.JobId;local I=if B and B~=""then up_327 [B]~=nil else false;up_335 =not I;if I and up_322.showJoin then local I,e,H=up_327 [B];if I and I.animals then for L,A in ipairs(I.animals)do L=up_336(A.Generation or 0);if not e or L>H then e,H=A,L;end;end;end;if e then pcall(up_322.showJoin,e.DisplayName or"Brainrot",up_337 (e.Generation or 0),"YOU ARE ON");end;end;if up_338 then B={};for I in pairs(up_327 )do B[I]=true;end;task.spawn(up_338 ,B);end;if up_339 then task.defer(up_339 );end;elseif a=="JOB"then local B,I=K._enc;local e={};if B then local H=up_329(B);if H then e,I=H.names or{},if type(H.jid)=="string"then H.jid else I;end;end;local H,L=K.job_start_time,K.payload;if I and L then if L.animals then for A,P in ipairs(L.animals)do P.DisplayName=e[A]or"";end;B=up_330();for e,A in ipairs(L.animals)do e=tonumber(A.Duel);if e then A._duelDisplay=math.floor(e-B);end;end;up_328 [I]=H;up_327 [I]={animals=L.animals,elapsedSeconds=B-H};if up_340 then task.spawn(up_340 ,I);end;if up_339 then task.defer(up_339 );end;end;end;elseif a=="DELETE"then local B=K.job_id;if B then up_327 [B]=nil;up_328 [B]=nil;up_331 [B]=nil;if up_322.feedJoinEnded then pcall(up_322.feedJoinEnded,B);end;if up_322.feedRemove then pcall(up_322.feedRemove,B);end;if up_339 then task.defer(up_339 );end;end;elseif a=="STATUS"then up_321 =os.time();pcall(getgenv().__kawaifu_region_ok);if K.server_time then up_323 ,up_324 =K.server_time-os.time(),true;end;if K.active_users then task.spawn(up_332 ,K.active_users);if up_333 then task.spawn(up_333 ,K.active_users);end;if up_334 then task.spawn(up_334 ,K.active_users);end;end;elseif a=="LAT"then if type(K.regions)=="table"and up_322.latencyTable then task.spawn(up_322.latencyTable,K.regions,tonumber(K.asof_s)or 0);end;elseif a=="KICK"then local B=K.reason or"[KaWaifu AJ AUTH] User is not authorized, reinject the script or reset your HWID";local I=up_341();up_321 =0;up_342 =0;if I then pcall(up_343,I);end;up_344:Kick(B);end;end
		up_362 = slicedn37
		local function slicedfn66()if getgenv()._KaWaifuSessionId~=up_345 then return false;end;local B=up_346();if B then pcall(up_347,B);end;up_348 =false;if not up_349 then warn("[KaWaifu] NO WebSocket API in this executor (looked for WebSocket.connect / syn.websocket). Cannot connect.");if up_350.showWsError then pcall(up_350.showWsError,"This executor exposes no WebSocket API (WebSocket.connect / syn.websocket not found).");end;return false;end;local I=getgenv().JoinerConfig_jhgjerdf324sa;if not I.WsUrl then return false;end;B=tostring(up_351.UserId);local e=tostring(math.floor(up_352()));local H,a=up_353 or"unknown","";pcall(function()a=gethwid()or"";end);local K=script_key or"";local L,A=pcall(up_354,B,e,H,a,K);if not L or type(A)~="string"then warn("[KaWaifu Joiner] Could not build the WebSocket signature");return false;end;local P,v=I.WsUrl,tostring(getgenv().KaWaifuActiveRegion or"main");local N=P.."?userId="..B.."&ts="..e.."&sig="..A.."&discordId="..up_355:UrlEncode(H).."&hwid="..up_355:UrlEncode(a).."&key="..up_355:UrlEncode(K);warn("[KaWaifu] WS connect \226\134\146 region '"..v.."'");local e,H=pcall(function()return up_349(N);end);A,L=getgenv()._KaWaifuSessionId~=up_345,tostring(getgenv().KaWaifuActiveRegion or"main")~=v;B=I.WsUrl~=P or L;if A or B then if e and H then pcall(up_347,H);end;if B and not A then warn("[KaWaifu Joiner] A switched-away region attempt completed late \226\128\148 discarded, retrying on the selected edge");end;return false;end;if not e or not H then warn("[KaWaifu Joiner] WS Connection Failed (Ping/Network?): "..up_356(H));pcall(getgenv().__kawaifu_region_fail);if up_350.showWsError then pcall(up_350.showWsError,"Could not connect to the KaWaifu server."..(H and"\10Reason: "..up_356(H)or"\10Reason: network/ping failure (no details from executor)"));end;return false;end;warn("[KaWaifu Joiner] WebSocket Connected Successfully!");if up_350.hideWsError then pcall(up_350.hideWsError);end;up_357 =H;up_348 =true;up_358 =os.time();up_359 =os.time();if getgenv()._KaWaifuSessionId~=up_345 then pcall(up_347,up_346()or H);return false;end;up_360 =false;getgenv()._KaWaifuWS=H;H.OnMessage:Connect(function(B)if getgenv()._KaWaifuSessionId~=up_345 or up_357 ~=H or I.WsUrl~=P or tostring(getgenv().KaWaifuActiveRegion or"main")~=v then return;end;pcall(up_361,B,v);end);H.OnClose:Connect(function()if getgenv()._KaWaifuSessionId~=up_345 then return;end;if up_357 ~=H then return;end;up_348 ,up_357 ,up_359 =false,nil,0;up_362 =0;if getgenv()._KaWaifuWS==H then getgenv()._KaWaifuWS=nil;end;end);pcall(function()H:Send("READY");end);return true;end
		up_363 = sliced94
		up_364 = sliced95
		up_365 = slicedn36  -- LEAKED BY STARLOXMELO
		up_366 = slicedn37
		up_367 = slicedfn65
		up_368 = slicedn38
		up_369 = slicedfn64
		local function slicedfn67()if up_363 and up_364 then local B=os.time();if B-up_365 >=25 then pcall(function()up_363 :Send("PING");end);up_365 =B;end;if up_366 >0 and B-up_366 >30 then warn("[WS] No STATUS received in 30s, forcing reconnect");local I=up_367();up_366 ,up_368 =0,0;if I then pcall(up_369,I);end;end;if up_366 ==0 and up_368 >0 and B-up_368 >20 then warn("[WS] No INIT/STATUS within 20s of connect (mute edge), reconnecting");pcall(getgenv().__kawaifu_region_fail);local B=up_367();up_366 ,up_368 =0,0;if B then pcall(up_369,B);end;end;end;end
		up_370 = slicedfn62
		up_371 = tbl31
		up_372 = tbl30
		local function slicedfn68()local B=up_370();for I,e in pairs(up_371 )do local H=up_372 [I];if H then H.elapsedSeconds=B-e;end;end;end

		local function slicedfn69(arg, arg2, arg3, arg4, arg5)  -- LEAKED BY STARLOXMELO
			local tbl43 = {}
			local tbl44 = {}
			local n = arg
			local slicedn40 = arg2
			local v = arg3
			local sliced108 = arg4
			local sliced109 = arg5
			local slicedn41 = 16
			local tbl45 = nil
			local char2 = nil  -- LEAKED BY STARLOXMELO
			local byte = nil
			local slicedn42 = nil
			local slicedn43 = nil
			local slicedn44 = nil
			local slicedn45 = nil
			local slicedn46 = nil
			local slicedn47 = nil
			local slicedn48 = nil
			local str15 = nil

			while true do  -- LEAKED BY STARLOXMELO
				if slicedn41 <= 31 then
					if slicedn41 <= 15 then
						if slicedn41 <= 7 then
							if slicedn41 <= 3 then
								if slicedn41 <= 1 then
									if slicedn41 <= 0 then
										local tbl46 = {}

										if slicedn40 == 1 then
											slicedn41 = 42
											slicedn40 = tbl46  -- LEAKED BY STARLOXMELO
										else
											slicedn41 = 57
											slicedn42 = tbl46
										end
									else
										local sliced110 = tbl45[1]
										local sliced111 = tbl45[4]
										local slicedn49 = tbl45[2] + sliced110
										local flag25 = sliced110 <= 0
										local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111  -- LEAKED BY STARLOXMELO
										tbl45[2] = slicedn49

										if flag26 then
											slicedn41 = 8
										else
											slicedn41 = 5
										end
									end
								elseif slicedn41 <= 2 then
									tbl45 = tbl45[1]
									slicedn41 = 26  -- LEAKED BY STARLOXMELO
								else
									slicedn41 = 25
									slicedn40 = 3661753104396200
									slicedn43 = 927496312415783
									slicedn44 = 4503599627370496
									slicedn45 = 67108864
									slicedn46 = 17592186044416
									slicedn47 = 2679385
									slicedn48 = 22847685
									tbl45 = { 0, nil, 1, tbl45, 4 }  -- LEAKED BY STARLOXMELO
								end
							elseif slicedn41 <= 5 then
								if slicedn41 <= 4 then
									byte(str15, 1, 64)
									slicedn41 = slicedn48 == slicedn47 and 31 or 24
								else
									tbl45 = tbl45[5]
									slicedn41 = 4
								end
							elseif slicedn41 <= 6 then  -- LEAKED BY STARLOXMELO
								local slicedn49 = slicedn40 % slicedn45
								slicedn40 = ((((slicedn40 - slicedn49) / slicedn45 * slicedn47 + slicedn49 * slicedn48) % slicedn45 * slicedn45 + slicedn49 * slicedn47) % slicedn44 + slicedn43) % slicedn44
								slicedn42[n] = (slicedn40 - slicedn40 % slicedn46) / slicedn46
								slicedn41 = 10
							else
								char2 ..= tbl43[slicedn46]
								slicedn41 = 11
							end
						elseif slicedn41 <= 11 then
							if slicedn41 <= 9 then  -- LEAKED BY STARLOXMELO
								if slicedn41 <= 8 then
									slicedn42 = (slicedn44 * slicedn42 + slicedn45) % 4294967296
									str15 ..= slicedn46[1 + (slicedn42 - slicedn42 % 268435456) / 268435456 % 16]
									slicedn41 = 1
								else
									slicedn40[slicedn42 + 1] = n[slicedn44] * 16 + n[slicedn45]
									slicedn41 = 27
								end
							elseif slicedn41 <= 10 then
								local sliced110 = tbl45[2]  -- LEAKED BY STARLOXMELO
								local sliced111 = tbl45[3]
								local slicedn49 = tbl45[5] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag28 = flag26 and flag28
								flag28 = flag27 or flag28
								tbl45[5] = slicedn49  -- LEAKED BY STARLOXMELO

								if flag28 then
									slicedn41 = 6
									n = slicedn49
								else
									slicedn41 = 2
								end
							else
								local sliced110 = tbl45[3]
								local sliced111 = tbl45[5]
								local slicedn49 = tbl45[1] + sliced110  -- LEAKED BY STARLOXMELO
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag28 = flag26 and flag28
								flag28 = flag27 or flag28
								tbl45[1] = slicedn49

								if flag28 then
									slicedn41 = 28  -- LEAKED BY STARLOXMELO
									slicedn42 = slicedn49
								else
									slicedn41 = 35
								end
							end
						elseif slicedn41 <= 13 then
							if slicedn41 <= 12 then
								n = (n + tbl44[slicedn40] + slicedn42[slicedn40 % 32 + 1]) % 256
								local sliced110 = tbl44[slicedn40]
								tbl44[slicedn40] = tbl44[n]  -- LEAKED BY STARLOXMELO
								tbl44[n] = sliced110
								slicedn41 = 56
							else
								slicedn46 += slicedn44
								slicedn41 = 18
							end
						elseif slicedn41 <= 14 then
							slicedn42 = (slicedn42 - slicedn45) / 2
							slicedn43 = (slicedn43 - slicedn47) / 2
							slicedn45 = slicedn42 % 2  -- LEAKED BY STARLOXMELO
							slicedn47 = slicedn43 % 2

							if slicedn45 ~= slicedn47 then
								slicedn41 = 43
								slicedn44 = 4
							else
								slicedn41 = 33
							end
						else
							n = { [56] = 8, [48] = 0, [100] = 13, [52] = 4, [51] = 3, [66] = 11, [67] = 12 }
							slicedn41 = 55  -- LEAKED BY STARLOXMELO
							slicedn42 = 49
							slicedn44 = 1
						end

						continue
					end

					if slicedn41 <= 23 then
						if slicedn41 <= 19 then
							if slicedn41 <= 17 then
								if slicedn41 <= 16 then
									char2 = string.char  -- LEAKED BY STARLOXMELO
									byte = string.byte

									if slicedn40 == 2 then
										slicedn41 = 26
										slicedn42 = n
									else
										slicedn41 = 0
									end
								else
									slicedn41 = 11
									n = 0  -- LEAKED BY STARLOXMELO
									slicedn40 = 0
									char2 = ""
									tbl45 = { 0, nil, 1, tbl45, #v + 0 }
								end
							elseif slicedn41 <= 18 then
								slicedn42 = (slicedn42 - slicedn45) / 2
								slicedn43 = (slicedn43 - slicedn47) / 2
								slicedn45 = slicedn42 % 2
								slicedn47 = slicedn43 % 2

								if slicedn45 ~= slicedn47 then  -- LEAKED BY STARLOXMELO
									slicedn41 = 54
									slicedn44 = 128
								else
									slicedn41 = 7
								end
							else
								sliced108[sliced109] = char2
								slicedn41 = 34
							end
						elseif slicedn41 <= 21 then  -- LEAKED BY STARLOXMELO
							if slicedn41 <= 20 then
								tbl45 = tbl45[4]
								slicedn41 = 17
							else
								slicedn41 = 1
								str15 = ""
								tbl45 = { 1, 0, nil, 64, tbl45 }
							end
						elseif slicedn41 <= 22 then
							slicedn42 = (slicedn42 - slicedn45) / 2  -- LEAKED BY STARLOXMELO
							slicedn43 = (slicedn43 - slicedn47) / 2
							slicedn45 = slicedn42 % 2
							slicedn47 = slicedn43 % 2

							if slicedn45 ~= slicedn47 then
								slicedn41 = 32
								slicedn44 = 32
							else
								slicedn41 = 58
							end
						else  -- LEAKED BY STARLOXMELO
							str15 += 65536
							slicedn41 = 51
						end

						continue
					end

					if slicedn41 <= 27 then
						if slicedn41 <= 25 then
							if slicedn41 <= 24 then
								local sliced110 = tbl45[1]
								local sliced111 = tbl45[3]  -- LEAKED BY STARLOXMELO
								local slicedn49 = tbl45[5] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111
								tbl45[5] = slicedn49

								if flag26 then
									slicedn41 = 21
									slicedn48 = slicedn49
								else
									slicedn41 = 62
								end  -- LEAKED BY STARLOXMELO
							else
								local sliced110 = tbl45[3]
								local sliced111 = tbl45[5]
								local slicedn49 = tbl45[1] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag27 = flag27 or flag26 and flag28  -- LEAKED BY STARLOXMELO
								tbl45[1] = slicedn49

								if flag27 then
									slicedn41 = 50
									str15 = slicedn49
								else
									slicedn41 = 60
								end
							end
						elseif slicedn41 <= 26 then
							n = slicedn42[3]  -- LEAKED BY STARLOXMELO
							slicedn40 = 4 * (slicedn42[1] % 64) + 1
							slicedn43 = 2 * (slicedn42[2] % 128) - 1
							slicedn41 = 52
							tbl45 = { 1, -1, nil, 255, tbl45 }
						else
							local sliced110 = tbl45[4]
							local sliced111 = tbl45[3]
							local slicedn49 = tbl45[2] + sliced110
							local flag25 = sliced110 <= 0
							local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111  -- LEAKED BY STARLOXMELO
							tbl45[2] = slicedn49

							if flag26 then
								slicedn41 = 63
								slicedn42 = slicedn49
							else
								slicedn41 = 53
							end
						end

						continue
					end  -- LEAKED BY STARLOXMELO

					if slicedn41 <= 29 then
						if slicedn41 <= 28 then
							n = (n + 1) % 256
							slicedn40 = (slicedn40 + tbl44[n]) % 256
							local sliced110 = tbl44[n]
							tbl44[n] = tbl44[slicedn40]
							tbl44[slicedn40] = sliced110
							local sliced111 = byte(v, slicedn42)
							slicedn43 = tbl44[(tbl44[n] + tbl44[slicedn40]) % 256]
							slicedn44 = sliced111 % 2  -- LEAKED BY STARLOXMELO
							slicedn45 = slicedn43 % 2

							if slicedn44 ~= slicedn45 then
								slicedn41 = 44
								slicedn42 = sliced111
							else
								slicedn41 = 38
								slicedn46 = 0
								slicedn42 = sliced111
							end

							continue  -- LEAKED BY STARLOXMELO
						end

						return nil
					end

					if slicedn41 <= 30 then
						slicedn46 += slicedn44
						slicedn41 = 39
					else
						slicedn43 = { byte(n, 1, 64) }
						slicedn41 = 24
					end  -- LEAKED BY STARLOXMELO
				else
					if slicedn41 <= 47 then
						if slicedn41 <= 39 then
							if slicedn41 <= 35 then
								if slicedn41 <= 33 then
									if slicedn41 <= 32 then
										slicedn46 += slicedn44
										slicedn41 = 58
									else
										slicedn42 = (slicedn42 - slicedn45) / 2  -- LEAKED BY STARLOXMELO
										slicedn43 = (slicedn43 - slicedn47) / 2
										slicedn45 = slicedn42 % 2
										slicedn47 = slicedn43 % 2

										if slicedn45 ~= slicedn47 then
											slicedn41 = 30
											slicedn44 = 8
										else
											slicedn41 = 39
										end
									end  -- LEAKED BY STARLOXMELO

									continue
								end

								if slicedn41 <= 34 then
									return
								end
								tbl45 = tbl45[4]
								slicedn41 = 19
								continue
							end

							if slicedn41 <= 37 then  -- LEAKED BY STARLOXMELO
								if slicedn41 <= 36 then
									slicedn41 = not slicedn45 and 61 or 9
								else
									tbl45 = tbl45[5]
									slicedn41 = 59
								end
							elseif slicedn41 <= 38 then
								slicedn42 = (slicedn42 - slicedn44) / 2
								slicedn43 = (slicedn43 - slicedn45) / 2
								slicedn45 = slicedn42 % 2  -- LEAKED BY STARLOXMELO
								slicedn47 = slicedn43 % 2

								if slicedn45 ~= slicedn47 then
									slicedn41 = 49
									slicedn44 = 2
								else
									slicedn41 = 14
								end
							else
								slicedn42 = (slicedn42 - slicedn45) / 2
								slicedn43 = (slicedn43 - slicedn47) / 2  -- LEAKED BY STARLOXMELO
								slicedn45 = slicedn42 % 2
								slicedn47 = slicedn43 % 2

								if slicedn45 ~= slicedn47 then
									slicedn41 = 48
									slicedn44 = 16
								else
									slicedn41 = 22
								end
							end

							continue  -- LEAKED BY STARLOXMELO
						end

						if slicedn41 <= 43 then
							if slicedn41 <= 41 then
								if slicedn41 <= 40 then
									str15 -= 65536
									slicedn41 = 47
								else
									n[slicedn42] = slicedn44
									n[69] = 14
									n[55] = 7  -- LEAKED BY STARLOXMELO
									n[53] = 5
									n[57] = 9
									n[99] = 12
									n[54] = 6
									slicedn41 = 27
									tbl45 = { tbl45, -1, 31, 1, nil }
								end
							elseif slicedn41 <= 42 then
								slicedn43 = {}

								slicedn46 = {  -- LEAKED BY STARLOXMELO
									"a",
									"6",
									"b",
									"3",
									"5",
									"e",
									"2",
									"0",
									"d",
									"1",  -- LEAKED BY STARLOXMELO
									"7",
									"f",
									"4",
									"8",
									"c",
									"9",
								}

								slicedn41 = 24
								slicedn42 = 3846715392
								slicedn44 = -2141334987  -- LEAKED BY STARLOXMELO
								slicedn45 = -1976388651
								slicedn47 = 1
								tbl45 = { 1, tbl45, 128, nil, 0 }
							else
								slicedn46 += slicedn44
								slicedn41 = 33
							end
						elseif slicedn41 <= 45 then
							if slicedn41 <= 44 then
								slicedn41 = 38  -- LEAKED BY STARLOXMELO
								slicedn46 = 1
							else
								slicedn41 = 10
								tbl45 = { tbl45, 1, 32, nil, 0 }
							end
						elseif slicedn41 <= 46 then
							tbl43[n] = char2(n)
							tbl44[n] = n
							n = (slicedn40 * n + slicedn43) % 256
							slicedn41 = 52  -- LEAKED BY STARLOXMELO
						else
							n = (n - str15) / 65536
							local slicedn49 = (slicedn40 + str15) % slicedn44
							local slicedn50 = slicedn49 % slicedn45
							slicedn40 = ((((slicedn49 - slicedn50) / slicedn45 * slicedn47 + slicedn50 * slicedn48) % slicedn45 * slicedn45 + slicedn50 * slicedn47) % slicedn44 + slicedn43) % slicedn44
							slicedn41 = 25
						end

						continue
					end

					if slicedn41 <= 55 then  -- LEAKED BY STARLOXMELO
						if slicedn41 <= 51 then
							if slicedn41 <= 49 then
								if slicedn41 <= 48 then
									slicedn46 += slicedn44
									slicedn41 = 22
								else
									slicedn46 += slicedn44
									slicedn41 = 14
								end
							elseif slicedn41 <= 50 then  -- LEAKED BY STARLOXMELO
								str15 = n % 65536
								slicedn41 = str15 < 0 and 23 or 51
							else
								slicedn41 = str15 >= 65536 and 40 or 47
							end
						elseif slicedn41 <= 53 then
							if slicedn41 <= 52 then
								local sliced110 = tbl45[1]
								local sliced111 = tbl45[4]
								local slicedn49 = tbl45[2] + sliced110  -- LEAKED BY STARLOXMELO
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag27 = flag27 or flag26 and flag28
								tbl45[2] = slicedn49

								if flag27 then
									slicedn41 = 46
									slicedn44 = slicedn49  -- LEAKED BY STARLOXMELO
								else
									slicedn41 = 37
								end
							else
								tbl45 = tbl45[1]
								slicedn41 = 26
								slicedn42 = slicedn40
							end
						elseif slicedn41 <= 54 then
							slicedn46 += slicedn44  -- LEAKED BY STARLOXMELO
							slicedn41 = 7
						else
							n[slicedn42] = slicedn44
							n[50] = 2
							n[102] = 15
							n[98] = 11
							n[68] = 13
							n[101] = 14
							n[70] = 15
							n[65] = 10  -- LEAKED BY STARLOXMELO
							slicedn41 = 41
							slicedn42 = 97
							slicedn44 = 10
						end

						continue
					end

					if slicedn41 <= 59 then
						if slicedn41 <= 57 then
							if slicedn41 <= 56 then
								local sliced110 = tbl45[3]  -- LEAKED BY STARLOXMELO
								local sliced111 = tbl45[1]
								local slicedn49 = tbl45[5] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111
								tbl45[5] = slicedn49

								if flag26 then
									slicedn41 = 12
									slicedn40 = slicedn49
								else
									slicedn41 = 20  -- LEAKED BY STARLOXMELO
								end
							else
								slicedn41 = slicedn40 == 0 and 3 or 26
							end
						elseif slicedn41 <= 58 then
							slicedn42 = (slicedn42 - slicedn45) / 2
							slicedn43 = (slicedn43 - slicedn47) / 2
							slicedn45 = slicedn42 % 2
							slicedn47 = slicedn43 % 2

							if slicedn45 ~= slicedn47 then  -- LEAKED BY STARLOXMELO
								slicedn41 = 13
								slicedn44 = 64
							else
								slicedn41 = 18
							end
						else
							slicedn41 = 56
							n = 0
							tbl45 = { 255, nil, 1, tbl45, -1 }
						end  -- LEAKED BY STARLOXMELO

						continue
					end

					if slicedn41 <= 61 then
						if slicedn41 <= 60 then
							tbl45 = tbl45[4]
							slicedn41 = 45
							continue
						end

						break
					end  -- LEAKED BY STARLOXMELO

					if slicedn41 <= 62 then
						tbl45 = tbl45[2]
						slicedn41 = 15
					else
						local slicedn49 = slicedn42 * 2 + 1
						local sliced110 = slicedn43[slicedn49]
						local sliced111 = slicedn43[slicedn49 + 1]

						if not sliced110 then
							slicedn41 = 29
						else  -- LEAKED BY STARLOXMELO
							slicedn41 = 36
							slicedn44 = sliced110
							slicedn45 = sliced111
						end
					end
				end
			end

			return nil
		end

		local function slicedfn70(arg, arg2, arg3, arg4, arg5)  -- LEAKED BY STARLOXMELO
			local tbl43 = {}
			local tbl44 = {}
			local n = arg
			local slicedn40 = arg2
			local v = arg3
			local sliced108 = arg4
			local sliced109 = arg5
			local slicedn41 = 16
			local tbl45 = nil
			local char2 = nil  -- LEAKED BY STARLOXMELO
			local byte = nil
			local slicedn42 = nil
			local slicedn43 = nil
			local slicedn44 = nil
			local slicedn45 = nil
			local slicedn46 = nil
			local slicedn47 = nil
			local slicedn48 = nil
			local str15 = nil

			while true do  -- LEAKED BY STARLOXMELO
				if slicedn41 <= 31 then
					if slicedn41 <= 15 then
						if slicedn41 <= 7 then
							if slicedn41 <= 3 then
								if slicedn41 <= 1 then
									if slicedn41 <= 0 then
										local tbl46 = {}

										if slicedn40 == 1 then
											slicedn41 = 42
											slicedn40 = tbl46  -- LEAKED BY STARLOXMELO
										else
											slicedn41 = 57
											slicedn42 = tbl46
										end
									else
										local sliced110 = tbl45[1]
										local sliced111 = tbl45[4]
										local slicedn49 = tbl45[2] + sliced110
										local flag25 = sliced110 <= 0
										local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111  -- LEAKED BY STARLOXMELO
										tbl45[2] = slicedn49

										if flag26 then
											slicedn41 = 8
										else
											slicedn41 = 5
										end
									end
								elseif slicedn41 <= 2 then
									tbl45 = tbl45[1]
									slicedn41 = 26  -- LEAKED BY STARLOXMELO
								else
									slicedn41 = 25
									slicedn40 = 3661753104396200
									slicedn43 = 927496312415783
									slicedn44 = 4503599627370496
									slicedn45 = 67108864
									slicedn46 = 17592186044416
									slicedn47 = 2679385
									slicedn48 = 22847685
									tbl45 = { 0, nil, 1, tbl45, 4 }  -- LEAKED BY STARLOXMELO
								end
							elseif slicedn41 <= 5 then
								if slicedn41 <= 4 then
									byte(str15, 1, 64)
									slicedn41 = slicedn48 == slicedn47 and 31 or 24
								else
									tbl45 = tbl45[5]
									slicedn41 = 4
								end
							elseif slicedn41 <= 6 then  -- LEAKED BY STARLOXMELO
								local slicedn49 = slicedn40 % slicedn45
								slicedn40 = ((((slicedn40 - slicedn49) / slicedn45 * slicedn47 + slicedn49 * slicedn48) % slicedn45 * slicedn45 + slicedn49 * slicedn47) % slicedn44 + slicedn43) % slicedn44
								slicedn42[n] = (slicedn40 - slicedn40 % slicedn46) / slicedn46
								slicedn41 = 10
							else
								char2 ..= tbl43[slicedn46]
								slicedn41 = 11
							end
						elseif slicedn41 <= 11 then
							if slicedn41 <= 9 then  -- LEAKED BY STARLOXMELO
								if slicedn41 <= 8 then
									slicedn42 = (slicedn44 * slicedn42 + slicedn45) % 4294967296
									str15 ..= slicedn46[1 + (slicedn42 - slicedn42 % 268435456) / 268435456 % 16]
									slicedn41 = 1
								else
									slicedn40[slicedn42 + 1] = n[slicedn44] * 16 + n[slicedn45]
									slicedn41 = 27
								end
							elseif slicedn41 <= 10 then
								local sliced110 = tbl45[2]  -- LEAKED BY STARLOXMELO
								local sliced111 = tbl45[3]
								local slicedn49 = tbl45[5] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag28 = flag26 and flag28
								flag28 = flag27 or flag28
								tbl45[5] = slicedn49  -- LEAKED BY STARLOXMELO

								if flag28 then
									slicedn41 = 6
									n = slicedn49
								else
									slicedn41 = 2
								end
							else
								local sliced110 = tbl45[3]
								local sliced111 = tbl45[5]
								local slicedn49 = tbl45[1] + sliced110  -- LEAKED BY STARLOXMELO
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag28 = flag26 and flag28
								flag28 = flag27 or flag28
								tbl45[1] = slicedn49

								if flag28 then
									slicedn41 = 28  -- LEAKED BY STARLOXMELO
									slicedn42 = slicedn49
								else
									slicedn41 = 35
								end
							end
						elseif slicedn41 <= 13 then
							if slicedn41 <= 12 then
								n = (n + tbl44[slicedn40] + slicedn42[slicedn40 % 32 + 1]) % 256
								local sliced110 = tbl44[slicedn40]
								tbl44[slicedn40] = tbl44[n]  -- LEAKED BY STARLOXMELO
								tbl44[n] = sliced110
								slicedn41 = 56
							else
								slicedn46 += slicedn44
								slicedn41 = 18
							end
						elseif slicedn41 <= 14 then
							slicedn42 = (slicedn42 - slicedn45) / 2
							slicedn43 = (slicedn43 - slicedn47) / 2
							slicedn45 = slicedn42 % 2  -- LEAKED BY STARLOXMELO
							slicedn47 = slicedn43 % 2

							if slicedn45 ~= slicedn47 then
								slicedn41 = 43
								slicedn44 = 4
							else
								slicedn41 = 33
							end
						else
							n = { [56] = 8, [48] = 0, [100] = 13, [52] = 4, [51] = 3, [66] = 11, [67] = 12 }
							slicedn41 = 55  -- LEAKED BY STARLOXMELO
							slicedn42 = 49
							slicedn44 = 1
						end

						continue
					end

					if slicedn41 <= 23 then
						if slicedn41 <= 19 then
							if slicedn41 <= 17 then
								if slicedn41 <= 16 then
									char2 = string.char  -- LEAKED BY STARLOXMELO
									byte = string.byte

									if slicedn40 == 2 then
										slicedn41 = 26
										slicedn42 = n
									else
										slicedn41 = 0
									end
								else
									slicedn41 = 11
									n = 0  -- LEAKED BY STARLOXMELO
									slicedn40 = 0
									char2 = ""
									tbl45 = { 0, nil, 1, tbl45, #v + 0 }
								end
							elseif slicedn41 <= 18 then
								slicedn42 = (slicedn42 - slicedn45) / 2
								slicedn43 = (slicedn43 - slicedn47) / 2
								slicedn45 = slicedn42 % 2
								slicedn47 = slicedn43 % 2

								if slicedn45 ~= slicedn47 then  -- LEAKED BY STARLOXMELO
									slicedn41 = 54
									slicedn44 = 128
								else
									slicedn41 = 7
								end
							else
								sliced108[sliced109] = char2
								slicedn41 = 34
							end
						elseif slicedn41 <= 21 then  -- LEAKED BY STARLOXMELO
							if slicedn41 <= 20 then
								tbl45 = tbl45[4]
								slicedn41 = 17
							else
								slicedn41 = 1
								str15 = ""
								tbl45 = { 1, 0, nil, 64, tbl45 }
							end
						elseif slicedn41 <= 22 then
							slicedn42 = (slicedn42 - slicedn45) / 2  -- LEAKED BY STARLOXMELO
							slicedn43 = (slicedn43 - slicedn47) / 2
							slicedn45 = slicedn42 % 2
							slicedn47 = slicedn43 % 2

							if slicedn45 ~= slicedn47 then
								slicedn41 = 32
								slicedn44 = 32
							else
								slicedn41 = 58
							end
						else  -- LEAKED BY STARLOXMELO
							str15 += 65536
							slicedn41 = 51
						end

						continue
					end

					if slicedn41 <= 27 then
						if slicedn41 <= 25 then
							if slicedn41 <= 24 then
								local sliced110 = tbl45[1]
								local sliced111 = tbl45[3]  -- LEAKED BY STARLOXMELO
								local slicedn49 = tbl45[5] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111
								tbl45[5] = slicedn49

								if flag26 then
									slicedn41 = 21
									slicedn48 = slicedn49
								else
									slicedn41 = 62
								end  -- LEAKED BY STARLOXMELO
							else
								local sliced110 = tbl45[3]
								local sliced111 = tbl45[5]
								local slicedn49 = tbl45[1] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag27 = flag27 or flag26 and flag28  -- LEAKED BY STARLOXMELO
								tbl45[1] = slicedn49

								if flag27 then
									slicedn41 = 50
									str15 = slicedn49
								else
									slicedn41 = 60
								end
							end
						elseif slicedn41 <= 26 then
							n = slicedn42[3]  -- LEAKED BY STARLOXMELO
							slicedn40 = 4 * (slicedn42[1] % 64) + 1
							slicedn43 = 2 * (slicedn42[2] % 128) - 1
							slicedn41 = 52
							tbl45 = { 1, -1, nil, 255, tbl45 }
						else
							local sliced110 = tbl45[4]
							local sliced111 = tbl45[3]
							local slicedn49 = tbl45[2] + sliced110
							local flag25 = sliced110 <= 0
							local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111  -- LEAKED BY STARLOXMELO
							tbl45[2] = slicedn49

							if flag26 then
								slicedn41 = 63
								slicedn42 = slicedn49
							else
								slicedn41 = 53
							end
						end

						continue
					end  -- LEAKED BY STARLOXMELO

					if slicedn41 <= 29 then
						if slicedn41 <= 28 then
							n = (n + 1) % 256
							slicedn40 = (slicedn40 + tbl44[n]) % 256
							local sliced110 = tbl44[n]
							tbl44[n] = tbl44[slicedn40]
							tbl44[slicedn40] = sliced110
							local sliced111 = byte(v, slicedn42)
							slicedn43 = tbl44[(tbl44[n] + tbl44[slicedn40]) % 256]
							slicedn44 = sliced111 % 2  -- LEAKED BY STARLOXMELO
							slicedn45 = slicedn43 % 2

							if slicedn44 ~= slicedn45 then
								slicedn41 = 44
								slicedn42 = sliced111
							else
								slicedn41 = 38
								slicedn46 = 0
								slicedn42 = sliced111
							end

							continue  -- LEAKED BY STARLOXMELO
						end

						return nil
					end

					if slicedn41 <= 30 then
						slicedn46 += slicedn44
						slicedn41 = 39
					else
						slicedn43 = { byte(n, 1, 64) }
						slicedn41 = 24
					end  -- LEAKED BY STARLOXMELO
				else
					if slicedn41 <= 47 then
						if slicedn41 <= 39 then
							if slicedn41 <= 35 then
								if slicedn41 <= 33 then
									if slicedn41 <= 32 then
										slicedn46 += slicedn44
										slicedn41 = 58
									else
										slicedn42 = (slicedn42 - slicedn45) / 2  -- LEAKED BY STARLOXMELO
										slicedn43 = (slicedn43 - slicedn47) / 2
										slicedn45 = slicedn42 % 2
										slicedn47 = slicedn43 % 2

										if slicedn45 ~= slicedn47 then
											slicedn41 = 30
											slicedn44 = 8
										else
											slicedn41 = 39
										end
									end  -- LEAKED BY STARLOXMELO

									continue
								end

								if slicedn41 <= 34 then
									return
								end
								tbl45 = tbl45[4]
								slicedn41 = 19
								continue
							end

							if slicedn41 <= 37 then  -- LEAKED BY STARLOXMELO
								if slicedn41 <= 36 then
									slicedn41 = not slicedn45 and 61 or 9
								else
									tbl45 = tbl45[5]
									slicedn41 = 59
								end
							elseif slicedn41 <= 38 then
								slicedn42 = (slicedn42 - slicedn44) / 2
								slicedn43 = (slicedn43 - slicedn45) / 2
								slicedn45 = slicedn42 % 2  -- LEAKED BY STARLOXMELO
								slicedn47 = slicedn43 % 2

								if slicedn45 ~= slicedn47 then
									slicedn41 = 49
									slicedn44 = 2
								else
									slicedn41 = 14
								end
							else
								slicedn42 = (slicedn42 - slicedn45) / 2
								slicedn43 = (slicedn43 - slicedn47) / 2  -- LEAKED BY STARLOXMELO
								slicedn45 = slicedn42 % 2
								slicedn47 = slicedn43 % 2

								if slicedn45 ~= slicedn47 then
									slicedn41 = 48
									slicedn44 = 16
								else
									slicedn41 = 22
								end
							end

							continue  -- LEAKED BY STARLOXMELO
						end

						if slicedn41 <= 43 then
							if slicedn41 <= 41 then
								if slicedn41 <= 40 then
									str15 -= 65536
									slicedn41 = 47
								else
									n[slicedn42] = slicedn44
									n[69] = 14
									n[55] = 7  -- LEAKED BY STARLOXMELO
									n[53] = 5
									n[57] = 9
									n[99] = 12
									n[54] = 6
									slicedn41 = 27
									tbl45 = { tbl45, -1, 31, 1, nil }
								end
							elseif slicedn41 <= 42 then
								slicedn43 = {}

								slicedn46 = {  -- LEAKED BY STARLOXMELO
									"a",
									"6",
									"b",
									"3",
									"5",
									"e",
									"2",
									"0",
									"d",
									"1",  -- LEAKED BY STARLOXMELO
									"7",
									"f",
									"4",
									"8",
									"c",
									"9",
								}

								slicedn41 = 24
								slicedn42 = 3846715392
								slicedn44 = -2141334987  -- LEAKED BY STARLOXMELO
								slicedn45 = -1976388651
								slicedn47 = 1
								tbl45 = { 1, tbl45, 128, nil, 0 }
							else
								slicedn46 += slicedn44
								slicedn41 = 33
							end
						elseif slicedn41 <= 45 then
							if slicedn41 <= 44 then
								slicedn41 = 38  -- LEAKED BY STARLOXMELO
								slicedn46 = 1
							else
								slicedn41 = 10
								tbl45 = { tbl45, 1, 32, nil, 0 }
							end
						elseif slicedn41 <= 46 then
							tbl43[n] = char2(n)
							tbl44[n] = n
							n = (slicedn40 * n + slicedn43) % 256
							slicedn41 = 52  -- LEAKED BY STARLOXMELO
						else
							n = (n - str15) / 65536
							local slicedn49 = (slicedn40 + str15) % slicedn44
							local slicedn50 = slicedn49 % slicedn45
							slicedn40 = ((((slicedn49 - slicedn50) / slicedn45 * slicedn47 + slicedn50 * slicedn48) % slicedn45 * slicedn45 + slicedn50 * slicedn47) % slicedn44 + slicedn43) % slicedn44
							slicedn41 = 25
						end

						continue
					end

					if slicedn41 <= 55 then  -- LEAKED BY STARLOXMELO
						if slicedn41 <= 51 then
							if slicedn41 <= 49 then
								if slicedn41 <= 48 then
									slicedn46 += slicedn44
									slicedn41 = 22
								else
									slicedn46 += slicedn44
									slicedn41 = 14
								end
							elseif slicedn41 <= 50 then  -- LEAKED BY STARLOXMELO
								str15 = n % 65536
								slicedn41 = str15 < 0 and 23 or 51
							else
								slicedn41 = str15 >= 65536 and 40 or 47
							end
						elseif slicedn41 <= 53 then
							if slicedn41 <= 52 then
								local sliced110 = tbl45[1]
								local sliced111 = tbl45[4]
								local slicedn49 = tbl45[2] + sliced110  -- LEAKED BY STARLOXMELO
								local flag25 = sliced110 <= 0
								local flag26 = not flag25
								local flag27 = slicedn49 >= sliced111
								local flag28 = slicedn49 <= sliced111
								flag27 = flag25 and flag27
								flag27 = flag27 or flag26 and flag28
								tbl45[2] = slicedn49

								if flag27 then
									slicedn41 = 46
									slicedn44 = slicedn49  -- LEAKED BY STARLOXMELO
								else
									slicedn41 = 37
								end
							else
								tbl45 = tbl45[1]
								slicedn41 = 26
								slicedn42 = slicedn40
							end
						elseif slicedn41 <= 54 then
							slicedn46 += slicedn44  -- LEAKED BY STARLOXMELO
							slicedn41 = 7
						else
							n[slicedn42] = slicedn44
							n[50] = 2
							n[102] = 15
							n[98] = 11
							n[68] = 13
							n[101] = 14
							n[70] = 15
							n[65] = 10  -- LEAKED BY STARLOXMELO
							slicedn41 = 41
							slicedn42 = 97
							slicedn44 = 10
						end

						continue
					end

					if slicedn41 <= 59 then
						if slicedn41 <= 57 then
							if slicedn41 <= 56 then
								local sliced110 = tbl45[3]  -- LEAKED BY STARLOXMELO
								local sliced111 = tbl45[1]
								local slicedn49 = tbl45[5] + sliced110
								local flag25 = sliced110 <= 0
								local flag26 = flag25 and slicedn49 >= sliced111 or not flag25 and slicedn49 <= sliced111
								tbl45[5] = slicedn49

								if flag26 then
									slicedn41 = 12
									slicedn40 = slicedn49
								else
									slicedn41 = 20  -- LEAKED BY STARLOXMELO
								end
							else
								slicedn41 = slicedn40 == 0 and 3 or 26
							end
						elseif slicedn41 <= 58 then
							slicedn42 = (slicedn42 - slicedn45) / 2
							slicedn43 = (slicedn43 - slicedn47) / 2
							slicedn45 = slicedn42 % 2
							slicedn47 = slicedn43 % 2

							if slicedn45 ~= slicedn47 then  -- LEAKED BY STARLOXMELO
								slicedn41 = 13
								slicedn44 = 64
							else
								slicedn41 = 18
							end
						else
							slicedn41 = 56
							n = 0
							tbl45 = { 255, nil, 1, tbl45, -1 }
						end  -- LEAKED BY STARLOXMELO

						continue
					end

					if slicedn41 <= 61 then
						if slicedn41 <= 60 then
							tbl45 = tbl45[4]
							slicedn41 = 45
							continue
						end

						break
					end  -- LEAKED BY STARLOXMELO

					if slicedn41 <= 62 then
						tbl45 = tbl45[2]
						slicedn41 = 15
					else
						local slicedn49 = slicedn42 * 2 + 1
						local sliced110 = slicedn43[slicedn49]
						local sliced111 = slicedn43[slicedn49 + 1]

						if not sliced110 then
							slicedn41 = 29
						else  -- LEAKED BY STARLOXMELO
							slicedn41 = 36
							slicedn44 = sliced110
							slicedn45 = sliced111
						end
					end
				end
			end

			return nil
		end

		up_373 = nil  -- LEAKED BY STARLOXMELO
		up_374 = sliced106
		up_375 = "\155\46\116\209\5\200\58\111\226\65\141\11\87\169\60\244\24\109\176\34\158\81\199\10\132\63\214\19\124\165\40\190"
		up_376 = HttpService
		up_377 = sliced104
		up_378 = "kWf!JoinedLedgr0"
		local function slicedfn71(B)local I=up_373 ;if not I then up_373 =up_374.new(up_375,up_374.modes.CBC,up_374.pads.Pkcs7);end;I=up_376:JSONEncode(B);return up_377.Encode(buffer.tostring(up_373 :Encrypt(up_378..I)));end
		up_379 = nil
		up_380 = sliced106
		up_381 = "\155\46\116\209\5\200\58\111\226\65\141\11\87\169\60\244\24\109\176\34\158\81\199\10\132\63\214\19\124\165\40\190"
		up_382 = sliced104  -- LEAKED BY STARLOXMELO
		up_383 = HttpService
		local function slicedfn72(B)local I,e=pcall(function()local H=up_379 ;if not H then up_379 =up_380.new(up_381,up_380.modes.CBC,up_380.pads.Pkcs7);end;H=buffer.fromstring(up_382.Decode(B));local B=up_379 :Decrypt(H);if type(B)~="buffer"then return nil;end;return up_383:JSONDecode(string.sub(buffer.tostring(B),17));end);if I and type(e)=="table"then return e;end;return nil;end
		local tbl43 = {}
		local flag25 = false

		local function slicedfn73()
			if flag25 then
				return
			end
			flag25 = true

			task.delay(1, function()  -- LEAKED BY STARLOXMELO
				flag25 = false

				pcall(function()
					writefile("KaWaifuJoiner_Joined.dat", slicedfn71(tbl43))
				end)
			end)
		end

		local tbl44 = { joined = true, failed = true, cleared = true }

		local function slicedfn74()
			if true then
				tbl43 = {}  -- LEAKED BY STARLOXMELO

				pcall(function()
					if true then
						if not isfile("KaWaifuJoiner_Joined.dat") then
							return
						end
						local v = slicedfn72(readfile("KaWaifuJoiner_Joined.dat"))

						if type(v) ~= "table" then
							pcall(function()
								writefile("KaWaifuJoiner_Joined.dat", slicedfn71({}))
							end)  -- LEAKED BY STARLOXMELO

							return
						end

						for k, sliced108 in pairs(v) do
							local sliced109 = "string"

							if type(k) == sliced109 and type(sliced108) == "table" and tbl44[sliced108.status] then
								tbl43[k] = sliced108
							end
						end

						return
					end  -- LEAKED BY STARLOXMELO

				end)

				return tbl43
			end

		end

		local function slicedfn75(arg)
			local tbl45 = {}
			local v = tbl30 and tbl30[arg]

			if v and v.animals then
				for _, animal in ipairs(v.animals) do
					local uuid = animal.UUID  -- LEAKED BY STARLOXMELO
					local sliced108 = "string"

					if type(uuid) == sliced108 and uuid ~= "" then
						tbl45[uuid] = true
					end
				end

			end

			return tbl45
		end

		local function slicedfn76(arg)
			local v = arg and tbl43[arg]  -- LEAKED BY STARLOXMELO
			local sliced108 = "table"
			if type(v) ~= sliced108 then
				return false
			end
			local uuids = v.uuids
			if type(uuids) ~= "table" then
				return false
			end
			local sliced109 = tbl30 and tbl30[arg]
			if not (sliced109 and sliced109.animals) then  -- LEAKED BY STARLOXMELO
				return false
			end

			for _, animal in ipairs(sliced109.animals) do
				local uuid = animal.UUID
				if type(uuid) == "string" and uuid ~= "" and not uuids[uuid] then
					return true
				end
			end

			return false
		end  -- LEAKED BY STARLOXMELO

		local function slicedfn77(arg)
			local v = arg and tbl43[arg]
			local sliced108 = "table"
			if type(v) == sliced108 and v.status == "joined" then
				return not slicedfn76(arg)
			end

			if true then
				return false
			end

		end  -- LEAKED BY STARLOXMELO

		local function slicedfn78(arg, arg2)
			if not arg or arg == "" then
				return
			end
			tbl43[arg] = { jobId = arg, uuids = arg2 or slicedfn75(arg), ts = os.time(), status = "failed", missCount = 0 }
			slicedfn73()
		end

		local function slicedfn79(arg)
			if not arg or arg == "" then
				return  -- LEAKED BY STARLOXMELO
			end
			local v = tbl43[arg]

			if type(v) == "table" and v.status == "joined" then
				v.hidden = true
				v.ts = os.time()
				local sliced108 = "table"

				if type(v.uuids) ~= sliced108 then
					v.uuids = {}
				end

				for k in pairs(slicedfn75(arg)) do  -- LEAKED BY STARLOXMELO
					v.uuids[k] = true
				end
			else
				if type(v) == "table" and v.status == "failed" then
					return
				end
				local sliced108 = slicedfn75(arg)
				local sliced109 = "table"

				if type(v) == sliced109 and type(v.uuids) == "table" then
					for k in pairs(v.uuids) do  -- LEAKED BY STARLOXMELO
						sliced108[k] = true
					end

				end

				tbl43[arg] = { jobId = arg, uuids = sliced108, ts = os.time(), status = "cleared", missCount = 0 }
			end

			tbl33[arg] = nil
			slicedfn73()
		end

		local function slicedfn80(arg)
			if arg and tbl43[arg] then  -- LEAKED BY STARLOXMELO
				tbl43[arg] = nil
				slicedfn73()
			end
		end

		up_384 = slicedfn77
		local function slicedfn81(B)return up_384 (B);end
		up_385 = tbl43
		local function slicedfn82(B)local I=B and up_385 [B];return type(I)=="table"and I.status=="failed";end

		local function slicedfn83(arg)
			local now2 = os.time()  -- LEAKED BY STARLOXMELO
			local jobId = game.JobId
			local flag26 = false

			for k, v in pairs(tbl43) do
				if arg[k] then
					if (tonumber(v.missCount) or 0) ~= 0 then
						v.missCount = 0
					end

					v.ts = now2
					flag26 = true
				elseif k ~= jobId then  -- LEAKED BY STARLOXMELO
					v.missCount = (tonumber(v.missCount) or 0) + 1

					if v.missCount >= 2 then
						tbl43[k] = nil
					end

					flag26 = true
				end
			end

			if jobId and jobId ~= "" then
				if true then
					local v = tbl43[jobId]  -- LEAKED BY STARLOXMELO
					local sliced108 = slicedfn75(jobId)

					if type(v) == "table" and v.status == "joined" and type(v.uuids) == "table" then
						for k in pairs(v.uuids) do
							sliced108[k] = true
						end
					end

					tbl43[jobId] = {
						jobId = jobId,
						uuids = sliced108,
						ts = now2,  -- LEAKED BY STARLOXMELO
						status = "joined",
						missCount = 0,
						hidden = type(v) == "table" and v.status == "joined" and v.hidden or nil,
					}

					flag26 = true
				end
			end

			if flag26 then
				slicedfn73()
			end  -- LEAKED BY STARLOXMELO
		end

		local tbl45 = {
			"Ganganzelli Trulala",
			"Tob Tobi Tobi",
			"Raccooni Jandelini",
			"Rhino Helicopterino",
			"Centrucci Nuclucci",
			"Avocadorilla",
			"Pineaplino",
			"Lazy Ducky",  -- LEAKED BY STARLOXMELO
			"Brutto Gialutto",
			"Gorillo Subwoofero",
			"Tenini Ballini",
			"Nooo my Hotspot",
			"Noo my Present",
			"Los Karkeritos",
			"Los Spyderinis",
			"Santa Hotspot",
			"Triplito Tralaleritos",
			"Pandanini Frostini",  -- LEAKED BY STARLOXMELO
			"Chrismasmamat",
		}

		local tbl46 = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Brainrot God" }

		local function slicedfn84()
			if isfile("KaWaifuJoiner_WLProfiles.json") then
				local ok, result = pcall(function()
					return HttpService:JSONDecode(readfile("KaWaifuJoiner_WLProfiles.json"))
				end)

				if ok and type(result) == "table" then
					if false then  -- LEAKED BY STARLOXMELO
					else
						if type(result.Profiles) == "table" then
							tbl36 = result.Profiles
						end

						if result.Active then
							str14 = result.Active
						end
					end
				end
			end  -- LEAKED BY STARLOXMELO

			for k, v in pairs(tbl36) do
				local sliced108 = "string"

				if type(k) ~= sliced108 or type(v) ~= "table" then
					tbl36[k] = nil
				else
					if type(v.Global) ~= "table" then
						v.Global = { Enabled = false, MinGen = 0 }
					end

					local sliced109 = "table"

					if type(v.Items) ~= sliced109 then  -- LEAKED BY STARLOXMELO
						v.Items = {}
					end

					for k2, item in pairs(v.Items) do
						if type(k2) ~= "string" or type(item) ~= "table" then
							v.Items[k2] = nil
						elseif item.Mutations ~= nil and type(item.Mutations) ~= "table" then
							item.Mutations = nil
						end
					end
				end  -- LEAKED BY STARLOXMELO
			end

			if next(tbl36) == nil then
				tbl36.Default = { Global = { Enabled = false, MinGen = 0 }, Items = {}, createdAt = 0 }
			end
		end

		local function slicedfn85()
			pcall(function()
				if animals then

					for k, animal in pairs(animals) do
						if not (not table.find(tbl45, k) and table.find(tbl46, animal.Rarity)) then  -- LEAKED BY STARLOXMELO
							if not tbl34[k] then
								tbl34[k] = true
							end
						end
					end
				end
			end)

			for k in pairs(tbl32.Items) do
				tbl34[k] = true
			end  -- LEAKED BY STARLOXMELO
		end

		local color3 = Color3.fromRGB(255, 0, 0)
		local tbl47 = {}
		local tbl48 = {}
		up_386 = localPlayer2
		up_387 = tbl47
		up_388 = tbl48
		up_389 = color3
		local function slicedfn86(B)if B==up_386 then return;end;local I=B.Character;if not I then return;end;local e,H=I:FindFirstChild("Head"),I:FindFirstChild("KaWaifu_NeonHighlight");if H and not H:IsA("Highlight")then H:Destroy();H=nil;end;local a=e and(e:FindFirstChild("KaWaifu_NameTag"));if a and not a:IsA("BillboardGui")then a:Destroy();a=nil;end;local K=tostring(B.UserId);if up_387 [K]and e then local L=up_388 [K]~=false;if L then if not H then B=Instance.new("Highlight");B.Name="KaWaifu_NeonHighlight";B.Adornee=I;B.FillColor=up_389;B.OutlineColor=Color3.new(1,0,0);B.FillTransparency=0.5;B.OutlineTransparency=0;B.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;B.Parent=I;end;elseif H then H:Destroy();end;local B;if not a then B=Instance.new("BillboardGui");B.Name="KaWaifu_NameTag";B.Adornee=e;B.Size=UDim2.new(0,200,0,50);B.StudsOffset=Vector3.new(0,3.5,0);B.AlwaysOnTop=true;B.Parent=e;else B=a;end;local I=B:FindFirstChild("TextLabel");if not I then I=Instance.new("TextLabel");I.BackgroundTransparency=1;I.Size=UDim2.new(1,0,1,0);I.TextStrokeTransparency=0;I.Font=Enum.Font.GothamBlack;I.TextSize=16;I.TextColor3=up_389;I.Text="";I.Parent=B;end;if not L~=I.RichText or I.Text==""then if L then I.RichText=false;I.Text="\240\159\140\184KaWaifu User\240\159\140\184";else I.RichText=true;I.Text="<font color=\"#FF0000\">\240\159\140\184KaWaifu User </font><font color=\"#4488FF\">(Offline)</font><font color=\"#FF0000\"> \240\159\140\184</font>";end;end;else if H then H:Destroy();end;if a then a:Destroy();end;end;end
		up_390 = tbl47  -- LEAKED BY STARLOXMELO
		up_391 = tbl48
		up_392 = Players2
		up_393 = slicedfn86
		local tbl49 = {}
		local tbl50 = {}

		local function slicedfn87(player)
			if tbl19.isAlive and not tbl19.isAlive() then
				return
			end

			tbl49[#tbl49 + 1] = player.CharacterAdded:Connect(function()  -- LEAKED BY STARLOXMELO
				if not (tbl19.isAlive and not tbl19.isAlive()) then
					task.wait(0.5)
					slicedfn86(player)
					return
				end

				if true then
					return
				end

			end)

			if player.Character then  -- LEAKED BY STARLOXMELO
				slicedfn86(player)
			end
		end

		tbl49[#tbl49 + 1] = Players2.PlayerAdded:Connect(slicedfn87)

		for _, player in ipairs(Players2:GetPlayers()) do
			slicedfn87(player)
		end

		local tbl51 = {}
		up_394 = localPlayer2
		up_395 = Players2  -- LEAKED BY STARLOXMELO
		up_396 = tbl51
		up_397 = false
		up_398 = tbl19
		up_399 = sliced103
		up_400 = Players2
		up_401 = tbl51
		up_402 = tbl51
		up_403 = "?"
		up_404 = function()local B=up_394:FindFirstChild("PlayerGui");if not B then return;end;local I=B:FindFirstChild("AdminPanel");if not I then return;end;B=I:FindFirstChild("AdminPanel");if not B then return;end;I=B:FindFirstChild("Profiles");if not I then return;end;B=I:FindFirstChild("ScrollingFrame");if not B then return;end;local I={};for e,e in ipairs(up_395:GetPlayers())do if up_396[tostring(e.UserId)]then I[e.Name]=true;end;end;for e,e in ipairs(B:GetChildren())do if e:IsA("ImageButton")and e.Name~="Template"and I[e.Name]then e:Destroy();end;end;if not up_397 then up_397 =true;B.ChildAdded:Connect(function(B)if up_398.isAlive and not up_398.isAlive()then return;end;if not B:IsA("ImageButton")or B.Name=="Template"then return;end;if next(up_396)==nil then return;end;local I={};for e,e in ipairs(up_395:GetPlayers())do if up_396[tostring(e.UserId)]then I[e.Name]=true;end;end;if I[B.Name]then task.defer(function()if B and B.Parent then B:Destroy();end;end);end;end);end;end
		up_405 = false  -- LEAKED BY STARLOXMELO
		up_406 = function()if not up_399 then return;end;local B=workspace:FindFirstChild("Plots");if not B then return;end;local I={};for e,e in ipairs(up_400:GetPlayers())do if up_401[tostring(e.UserId)]then I[e.Name]=true;end;end;for e,H in pairs(up_399 )do if I[tostring(H.Channel.CacheTable.Owner)]then local w=B:FindFirstChild(e);if w then local B=w:FindFirstChild("AnimalPodiums");if B then for w,I in ipairs(B:GetChildren())do w=I:FindFirstChild("Base");if w then I=w:FindFirstChild("Spawn");if I then local w=I:FindFirstChild("PromptAttachment");if w then w:Destroy();end;end;end;end;end;end;end;end;end

		up_407 = {
			"",
			"K",
			"M",
			"B",
			"T",
			"Qa",
			"Qi",
			"Sx",  -- LEAKED BY STARLOXMELO
			"Sp",
			"Oc",
			"No",
			"Dc",
			"Ud",
			"Dd",
			"Td",
			"Qad",
			"Qid",
			"Sxd",  -- LEAKED BY STARLOXMELO
			"Spd",
			"Ocd",
			"Nod",
			"Vg",
			"Uvg",
			"Dvg",
			"Tvg",
		}

		up_408 = function(B,I)local e,H=I or 1,math.floor(math.log(math.max(1,math.abs(B)),1000));I=10^e;local a=math.floor(B*(I/1000^H))/I;return string.format("%."..e.."f",a):gsub("%.?0+$","")..(up_407[H+1]or"e+"..H);end
		up_409 = slicedfn59  -- LEAKED BY STARLOXMELO
		local function slicedfn88(B)return up_408(up_409(B)).."/s";end

		local function slicedfn89(arg)
			local index = arg.Index
			if not index or not animals[index] then
				return nil
			end

			local tbl52 = {
				DisplayName = index,
				Rarity = animals[index].Rarity,
				Mutation = arg.Mutation,  -- LEAKED BY STARLOXMELO
				Traits = arg.Traits and table.concat(arg.Traits, ",") or nil,
			}

			tbl52.Generation = slicedfn57(tbl52.DisplayName, tbl52.Mutation, arg.Traits)

			if not tbl52.Mutation then
				tbl52.Mutation = "Normal"
			end

			return tbl52
		end

		local function slicedfn90()
			if not sliced103 or not animals or not mutations or not traits then  -- LEAKED BY STARLOXMELO
				return {}
			end
			local tbl52 = {}

			for _, v in pairs(sliced103) do
				local ok, result = pcall(function()
					return tostring(v.Channel.CacheTable.Owner)
				end)

				if ok and result == localPlayer2.Name then
					local ok2, result2 = pcall(function()
						return v.Channel.CacheTable.AnimalList  -- LEAKED BY STARLOXMELO
					end)

					if ok2 and result2 then
						for k, sliced108 in pairs(result2) do
							if type(sliced108) == "table" then
								local uuid = sliced108.UUID or tostring(k)
								local sliced109 = slicedfn89(sliced108)

								if sliced109 then
									tbl52[uuid] = sliced109
								end
							end  -- LEAKED BY STARLOXMELO
						end
					end

					return tbl52
				end
			end

			return {}
		end

		up_410 = tbl45
		local function slicedfn91(B)if not B or not B.Generation then return false;end;if B.Generation>=5000000 then return true;end;if table.find(up_410,B.DisplayName)then return true;end;return false;end
		local sliced108 = nil  -- LEAKED BY STARLOXMELO

		local function slicedfn92()
			if not sliced103 then
				return
			end

			for _, v in pairs(sliced103) do
				local animalList = v.Channel.CacheTable.AnimalList
				local name = localPlayer2.Name

				if tostring(v.Channel.CacheTable.Owner) ~= name and animalList then
					for _, sliced109 in pairs(animalList) do
						if type(sliced109) ~= "table" then  -- LEAKED BY STARLOXMELO
							continue
						end

						if sliced109.Steal and sliced109.Steal == localPlayer2.UserId then
							local sliced110 = slicedfn89(sliced109)

							if sliced110 then
								sliced108 = sliced110

								if slicedfn91(sliced110) then
									local sliced111 = "?"
									local str15

									if "?" then  -- LEAKED BY STARLOXMELO
										str15 = sliced111
									else
										str15 = ""
									end

									local str16 = tostring(math.floor(slicedfn62()))
									local json2 = HttpService:JSONEncode({ animal = sliced110, discordId = str15 })
									json = HttpService:JSONEncode({ op = "STEAL", payload = json2, sig = slicedfn61(json2, str16), ts = str16 })
								end
							end

							return true  -- LEAKED BY STARLOXMELO
						end
					end
				end
			end

			return false
		end

		up_411 = {
			["GrabNotify"] = {
				Match = "Sounds.Animals",
				Callback = function()  -- LEAKED BY STARLOXMELO
					task.wait(3)
					slicedfn92()
				end,
			},
		}

		up_412 = HttpService
		local function slicedfn93(...)for B,I in pairs(up_411)do local e,H=false,false;for a=1,select("#",...),1 do B=select(a,...);if type(B)=="string"then if string.find(B,I.Match,1,true)then e=true;break;end;else H=if type(B)=="table"then true else H;end;end;if not e and H then for H=1,select("#",...),1 do B=select(H,...);if type(B)=="table"then local H,a=pcall(up_412.JSONEncode,up_412,B);if H and(string.find(a,I.Match,1,true))then e=true;break;end;end;end;end;if e then I.Callback();end;end;end
		local tbl52 = { JobId = nil, Generation = -1, Priority = -1, UniqueKey = nil, RunId = 0 }
		local tbl53 = {}

		pcall(function()  -- LEAKED BY STARLOXMELO
			local v = SoundService:FindFirstChild("JoinAlert")

			if v and v:IsA("Sound") then
				v:Destroy()
			end
		end)

		local sound = Instance.new("Sound")
		sound.Name = "JoinAlert"
		sound.SoundId = "rbxassetid://" .. tostring(tbl35.SoundId)
		sound.Volume = tbl35.SoundVolume
		sound.Parent = SoundService  -- LEAKED BY STARLOXMELO
		up_413 = tbl19
		local function slicedfn94()return up_413.isAlive==nil or(up_413.isAlive());end
		up_414 = tbl19
		up_415 = tbl32
		up_416 = slicedfn59
		up_417 = {}
		local function slicedfn95(B,I,e)local H=up_415.Items[B];local a=H and H.State or"None";B=up_416(H and H.MinGen or 0);local K=H and H.Mutations or up_417;if a=="Blacklist"then return false;end;if a~="None"and#K>0 and e then for H,H in ipairs(K)do if H==e then return true;end;end;end;if a=="Whitelist"then return up_416(I)>=B;end;if up_415.Global.Enabled then return up_416(I)>=up_416(up_415.Global.MinGen);end;return true;end
		up_418 = str12
		local function slicedfn96(B)if up_418 =="No"then return B.Carpet~=true;end;if up_418 =="Only"then return B.Carpet==true;end;return true;end
		up_419 = flag22  -- LEAKED BY STARLOXMELO
		up_420 = flag23
		up_421 = tbl30
		local function slicedfn97()if up_419 then return true;end;if not up_420 then return false;end;local B=up_421 [game.JobId];if B and B.animals then for w,w in ipairs(B.animals)do if w.Rarity=="OG"then return false;end;end;end;return true;end
		local function slicedfn98(w,B)return not B or w.Rarity=="OG";end
		up_422 = tbl52
		up_423 = slicedfn59
		up_424 = slicedfn80
		up_425 = tbl53
		up_426 = sound
		up_427 = slicedfn88  -- LEAKED BY STARLOXMELO
		up_428 = tbl30
		up_429 = TeleportService
		up_430 = localPlayer2
		up_431 = defaultAttempts
		up_432 = slicedfn94
		up_433 = tbl19
		up_434 = placeId
		up_435 = tbl35
		up_436 = slicedfn78
		up_437 = sliced107  -- LEAKED BY STARLOXMELO
		local function slicedfn99(B,I,e,H)if B==game.JobId then return;end;up_422.JobId=B;up_422.Generation=up_423(e);up_422.Priority=H or 0;up_422.UniqueKey=I;up_422.RunId=up_422.RunId+1;up_422.StartedAt=os.clock();local a=up_422.RunId;up_424 (B);up_425[B]=nil;pcall(function()up_426:Play();end);local K="Brainrot";local L=up_427 (e);H=up_428 [B];if H and H.animals then for A,A in ipairs(H.animals)do if up_423(A.Generation)==up_423(e)then K=A.DisplayName or K;break;end;end;if K=="Brainrot"and H.animals[1]then K=H.animals[1].DisplayName or K;end;end;task.spawn(function()local e=nil;local H=up_429.TeleportInitFailed:Connect(function(A,P,v)if A==up_430 then e=P;end;end);local A=up_431 ;local P=false;for v=1,A,1 do if not up_432()or up_422.UniqueKey~=I or up_422.RunId~=a then break;end;if up_433.showJoinProgress then pcall(up_433.showJoinProgress,K,L,v,A);elseif v==1 and up_433.showJoin then pcall(up_433.showJoin,K,L,"CONNECTING TO");end;e=nil;if not pcall(function()up_429:TeleportToPlaceInstance(up_434,B,up_430);end)then e=Enum.TeleportResult.Failure;end;if up_433.feedJoinProgress then pcall(up_433.feedJoinProgress,B,v,A);end;local N=0;while not e and N<5 do N+=task.wait(0.1);if not up_432()or up_422.UniqueKey~=I or up_422.RunId~=a then break;end;end;if not e and up_422.RunId==a and up_422.UniqueKey==I and up_433.showJoin then pcall(up_433.showJoin,K,L,"TELEPORTING TO");end;P=if v==A then true else P;end;if H then H:Disconnect();end;if up_422.UniqueKey==I and up_422.RunId==a then if P and e then if up_433.hideJoin then pcall(up_433.hideJoin);end;if up_433.notify then pcall(up_433.notify,"Joiner",up_435.BruteForceJoin and tostring(A).." attempts to "..tostring(K).." failed \226\128\148 will keep trying"or"Failed to join "..tostring(K).." after "..tostring(A).." attempts");end;end;if P and not e then task.delay(15,function()if(up_422.UniqueKey==nil or up_422.RunId==a)and up_433.hideJoin then pcall(up_433.hideJoin);end;end);end;if not up_435.BruteForceJoin and P then up_436 (B);end;if up_433.feedJoinEnded then pcall(up_433.feedJoinEnded,B);end;up_422.JobId=nil;up_422.UniqueKey=nil;up_422.Generation=-1;up_422.Priority=-1;end;end);up_437 ();end
		up_438 = slicedfn97
		up_439 = flag22
		up_440 = tbl30
		up_441 = slicedn34
		up_442 = slicedfn82
		up_443 = slicedfn59
		up_444 = slicedfn96
		up_445 = slicedfn98
		up_446 = slicedfn95  -- LEAKED BY STARLOXMELO
		up_447 = flag21
		up_448 = slicedn33
		up_449 = slicedfn81
		up_450 = tbl53
		up_451 = slicedfn47
		up_452 = tbl52
		up_453 = str13
		up_454 = tbl17
		up_455 = slicedfn99
		up_456 = slicedfn94  -- LEAKED BY STARLOXMELO
		up_457 = false
		up_458 = false
		up_459 = tbl30
		up_460 = tbl43
		up_461 = tbl33
		up_462 = slicedfn76
		up_463 = slicedfn59
		up_464 = slicedfn96
		up_465 = flag21
		up_466 = slicedn33  -- LEAKED BY STARLOXMELO
		up_467 = slicedfn95
		up_468 = tbl17
		up_469 = tbl19
		up_470 = slicedfn88
		up_471 = sliced107
		local function slicedfn100()if not up_456()then return;end;pcall(function()getgenv().KaWaifuJobs=up_459;end);if up_457 then up_458 =true;return;end;up_457 =true;local B=nil;for I,e in pairs(up_459 )do local H=up_460 [I];if not up_461 [I]and not(H and(H.status=="cleared"or H.hidden)and not up_462 (I))and e.animals and#e.animals>0 then local H,a;for K,L in ipairs(e.animals)do K=up_463(L.Generation or 0);local A=up_464(L);if(if A and L._duelDisplay then if not up_465 then false else L._duelDisplay<=up_466 else A)and(up_467(L.DisplayName or"",K,L.Mutation))then if not H or K>a then H,a=L,K;end;end;end;if H then B=B or{};B[#B+1]={jobId=I,best=H,elapsed=e.elapsedSeconds or 0};end;end;end;if B then if#B>1 then table.sort(B,function(I,e)if I.elapsed~=e.elapsed then return I.elapsed>e.elapsed;end;return I.jobId<e.jobId;end);end;local I=up_468.FeedMaxRows or 40;if#B>I then for e=1,#B-I,1 do up_461 [B[e].jobId]=true;end;B=(table.move(B,#B-I+1,#B,1,{}));end;I=6;for e=1,#B,1 do if not up_456()then break;end;local H=B[e];local a=H.jobId;if up_459 [a]and not up_461 [a]then local K=H.best;local H=true;if up_469.feedAdd then local L,A=pcall(up_469.feedAdd,K.DisplayName or"?",K.Rarity,up_470 (K.Generation or 0),a,K.Mutation,false);H=L and A~=false;end;if H then up_461 [a]=true;end;I-=1;if I<=0 and e<#B then task.wait();I=6;end;end;end;end;up_457 =false;if up_458 then up_458 =false;task.defer(up_471 );end;end
		up_472 = slicedfn94
		up_473 = tbl33
		up_474 = tbl30
		up_475 = slicedfn59  -- LEAKED BY STARLOXMELO
		up_476 = slicedfn96
		up_477 = flag21
		up_478 = slicedn33
		up_479 = slicedfn95
		up_480 = tbl19
		up_481 = tbl17
		up_482 = slicedfn100
		local function slicedfn101()if not up_472()then return;end;for B in pairs(up_473 )do local I=up_474 [B];if I and I.animals then local e,H;for a,K in ipairs(I.animals)do a=up_475(K.Generation or 0);local I=up_476(K);if(if I and K._duelDisplay then if not up_477 then false else K._duelDisplay<=up_478 else I)and(up_479(K.DisplayName or"",a,K.Mutation))then if not e or a>H then e,H=K,a;end;end;end;local I=false;if not e then I=true;elseif up_480.feedRowName then local H,a=pcall(up_480.feedRowName,B);I=if H then if a==nil then true else if not up_481.SplitView and a~=(e.DisplayName or"?")then true else I else I;end;if I then up_473 [B]=nil;if up_480.feedRemove then pcall(up_480.feedRemove,B);end;end;end;end;if up_482 then task.defer(up_482 );end;end

		local function slicedfn102()
			local jobId = tbl52.JobId  -- LEAKED BY STARLOXMELO
			if not jobId then
				return
			end
			tbl53[jobId] = tbl52.Generation
			tbl52.JobId = nil
			tbl52.UniqueKey = nil
			tbl52.Generation = -1
			tbl52.Priority = -1

			if tbl19.feedJoinEnded then
				pcall(tbl19.feedJoinEnded, jobId)  -- LEAKED BY STARLOXMELO
			end

			if tbl19.hideJoin then
				pcall(tbl19.hideJoin)
			end
		end

		tbl18.joinServer = function(arg)
			-- publish live job map for smart join
			pcall(function() getgenv().KaWaifuJobs = tbl30 end)
			if not arg then
				return false
			end

			if tbl52.UniqueKey and tbl52.JobId == arg then  -- LEAKED BY STARLOXMELO
				slicedfn102()
				return "cancelled"
			end
			-- never join the server you're already in — pick another job with same brainrot
			if tostring(arg) == tostring(game.JobId) then
				local cur = tbl30[arg]
				local wantName = nil
				if cur and cur.animals then
					local best, bestG
					for _, animal in ipairs(cur.animals) do
						local g = slicedfn59(animal.Generation or 0)
						if not best or g > bestG then best, bestG = animal, g end
					end
					wantName = best and string.lower(tostring(best.DisplayName or ""))
				end
				local alt = nil
				for jid, job in pairs(tbl30) do
					if tostring(jid) ~= tostring(game.JobId) and job and job.animals then
						for _, animal in ipairs(job.animals) do
							local nm = string.lower(tostring(animal.DisplayName or ""))
							if wantName and wantName ~= "" and nm == wantName then
								alt = jid
								break
							end
						end
						if alt then break end
					end
				end
				if not alt then
					-- any other live job
					for jid, job in pairs(tbl30) do
						if tostring(jid) ~= tostring(game.JobId) and job and job.animals and #job.animals > 0 then
							alt = jid
							break
						end
					end
				end
				if not alt then
					return false
				end
				arg = alt
			end
			local v = tbl30[arg]
			if not v or not v.animals then
				return false
			end
			local sliced109 = nil
			local sliced110 = nil
			local n = nil  -- LEAKED BY STARLOXMELO

			for i, animal in ipairs(v.animals) do
				local sliced111 = slicedfn59(animal.Generation or 0)

				if slicedfn95(animal.DisplayName or "", sliced111, animal.Mutation) then
					if not sliced109 or sliced111 > sliced110 then
						sliced109 = animal
						sliced110 = sliced111
						n = i
					end
				end
			end  -- LEAKED BY STARLOXMELO

			if not sliced109 then
				sliced109 = v.animals[1]
				n = 1
			end

			if not sliced109 then
				return false
			end
			slicedfn99(arg, slicedfn47(arg, sliced109, n), sliced109.Generation or 0, sliced109.prio or 0)
			return true
		end  -- LEAKED BY STARLOXMELO

		tbl18.jobAnimals = function(arg)
			local v = 10285

			if true then
				arg = arg and tbl30[arg]
				if not arg or not arg.animals then
					return nil
				end
				local tbl54 = {}

				for i, animal in ipairs(arg.animals) do
					local sliced109 = slicedfn59(animal.Generation or 0)  -- LEAKED BY STARLOXMELO
					local flag26 = slicedfn96(animal)

					if flag26 and animal._duelDisplay then
						if not flag21 then
							flag26 = false
						else
							flag26 = animal._duelDisplay <= slicedn33
						end
					end

					if flag26 then
						flag26 = slicedfn95(animal.DisplayName or "", sliced109, animal.Mutation)  -- LEAKED BY STARLOXMELO
					end

					if flag26 then
						tbl54[#tbl54 + 1] = {
							name = animal.DisplayName or "?",
							rarity = animal.Rarity,
							gen = slicedfn88(animal.Generation or 0),
							genVal = sliced109,
							mutation = animal.Mutation,
							idx = i,
							carpet = animal.Carpet == true,  -- LEAKED BY STARLOXMELO
						}
					end
				end

				table.sort(tbl54, function(arg2, arg3)
					if arg2.genVal ~= arg3.genVal then
						return arg2.genVal > arg3.genVal
					end
					return arg2.idx < arg3.idx
				end)

				return tbl54  -- LEAKED BY STARLOXMELO
			end

		end

		tbl18.joinAnimal = function(arg, arg2, arg3)
			if not arg then
				return false
			end
			local v = tbl30[arg]
			if not v or not v.animals then
				return false
			end  -- LEAKED BY STARLOXMELO
			local sliced109 = v.animals[arg2]
			local flag26 = not sliced109

			if not flag26 then
				if arg3 then
					flag26 = (sliced109.DisplayName or "?") ~= arg3
				else
					flag26 = arg3
				end
			end

			if flag26 then  -- LEAKED BY STARLOXMELO
				sliced109 = nil
				arg2 = nil

				if arg3 then
					sliced109 = nil
					arg2 = nil

					for i, animal in ipairs(v.animals) do
						if (animal.DisplayName or "?") == arg3 then
							sliced109 = animal
							arg2 = i
							break  -- LEAKED BY STARLOXMELO
						else
							sliced109 = nil
							arg2 = nil
						end
					end
				end
			end

			if not sliced109 then
				return false
			end  -- LEAKED BY STARLOXMELO
			local sliced110 = slicedfn47(arg, sliced109, arg2)
			if tbl52.UniqueKey == sliced110 then
				slicedfn102()
				return "cancelled"
			end
			slicedfn99(arg, sliced110, sliced109.Generation or 0, sliced109.prio or 0)
			return true
		end

		tbl18.setAutoJoin = function(arg)
			flag22 = arg and true or false  -- LEAKED BY STARLOXMELO
		end

		tbl18.isJoining = function()
			return tbl52.JobId ~= nil
		end

		tbl18.rejoin = function()
			pcall(function()
				TeleportService:TeleportReconnect()
			end)
		end

		up_483 = slicedfn65  -- LEAKED BY STARLOXMELO
		up_484 = flag24
		up_485 = slicedn37
		up_486 = slicedn38
		up_487 = slicedfn64
		tbl18.reconnect = function()local B=up_483();up_484 =true;up_485 =0;up_486 =0;if B then pcall(up_487,B);end;end

		tbl18.markCleared = function(arg)
			pcall(slicedfn79, arg)
		end

		tbl18.jobElapsed = function(arg)
			arg = arg and tbl30[arg]  -- LEAKED BY STARLOXMELO
			return arg and arg.elapsedSeconds or nil
		end

		tbl18.applySettings = function(arg)
			if type(arg) == "table" then
				local flag26 = false

				if type(arg.MaxDuelTime) == "number" then
					local n = math.max(0, arg.MaxDuelTime)
					flag26 = n ~= slicedn33
					slicedn33 = n
				end  -- LEAKED BY STARLOXMELO

				if arg.TPDuelEnabled ~= nil then
					local flag27 = arg.TPDuelEnabled and true or false
					flag26 = flag26 or flag27 ~= flag21
					flag21 = flag27
				end

				if arg.CarpetMode ~= nil then
					local carpetMode = arg.CarpetMode

					if carpetMode ~= "Yes" and carpetMode ~= "Only" and carpetMode ~= "No" then
						carpetMode = "Yes"
					end  -- LEAKED BY STARLOXMELO

					flag26 = flag26 or carpetMode ~= str12
					str12 = carpetMode
				end

				if arg.AutoJoinOGOffAJ ~= nil then
					flag23 = arg.AutoJoinOGOffAJ and true or false
				end

				if arg.MidRetrySwitch ~= nil then
					local midRetrySwitch = arg.MidRetrySwitch

					if midRetrySwitch ~= "Better Newest" and midRetrySwitch ~= "Any Newest" then
						if true then  -- LEAKED BY STARLOXMELO
							midRetrySwitch = "Better Newest"
						end
					end

					str13 = midRetrySwitch
				end

				if type(arg.Attempts) == "number" then
					defaultAttempts = math.max(1, math.floor(arg.Attempts))
				end

				if type(arg.MaxElapsedJoin) == "number" then
					slicedn34 = math.max(0, arg.MaxElapsedJoin)  -- LEAKED BY STARLOXMELO
				end

				if arg.BruteForceJoin ~= nil then
					tbl35.BruteForceJoin = arg.BruteForceJoin and true or false
				end

				if arg.SoundId then
					tbl35.SoundId = tostring(arg.SoundId)

					pcall(function()
						sound.SoundId = "rbxassetid://" .. tbl35.SoundId
					end)
				end  -- LEAKED BY STARLOXMELO

				if type(arg.SoundVolume) == "number" then
					tbl35.SoundVolume = arg.SoundVolume

					pcall(function()
						sound.Volume = arg.SoundVolume
					end)
				end

				if flag26 then
					slicedfn101()
				end

				return  -- LEAKED BY STARLOXMELO
			end

			if true then
				return
			end

		end

		tbl18.wlApply = function(arg, items)

			if true then
				local v = "table"

				if type(arg) == v then
					tbl32.Global = {  -- LEAKED BY STARLOXMELO
						Enabled = arg.Enabled and true or false,
						MinGen = math.max(0, tonumber(arg.MinGen) or 0),
					}
				end

				local sliced109 = "table"

				if type(items) == sliced109 then
					tbl32.Items = items
				end

				for k in pairs(tbl32.Items) do
					tbl34[k] = true  -- LEAKED BY STARLOXMELO
				end

				slicedfn101()
			end
		end

		tbl18.wlKnown = function()
			local tbl54 = {}

			for k in pairs(tbl34) do
				tbl54[#tbl54 + 1] = k
			end

			table.sort(tbl54)  -- LEAKED BY STARLOXMELO
			return tbl54
		end

		tbl18.allBrainrotNames = function()
			local tbl54 = {}

			if animals then
				for k in pairs(animals) do
					tbl54[#tbl54 + 1] = k
				end
			end

			return tbl54  -- LEAKED BY STARLOXMELO
		end

		tbl18.mutationList = function()
			if true then
				return tbl41
			end

		end

		tbl18.testSound = function()
			pcall(function()
				sound.SoundId = "rbxassetid://" .. tostring(tbl35.SoundId)
				sound.Volume = tbl35.SoundVolume  -- LEAKED BY STARLOXMELO

				if not sound.IsLoaded then
					pcall(function()
						game:GetService("ContentProvider"):PreloadAsync({ sound })
					end)
				end

				sound:Play()
			end)
		end

		tbl18.brainrotImage = function(arg)
			local v = animals and animals[arg]  -- LEAKED BY STARLOXMELO

			if false then
			else
				local sliced109 = "table"
				if type(v) ~= sliced109 then
					return nil
				end
				local icon = v.Icon or v.Image or v.Thumbnail or v.ImageId or v.Texture

				if type(icon) ~= "number" then
					if type(icon) == "string" and icon ~= "" then
						if icon:find("rbxasset") or icon:find("http") then  -- LEAKED BY STARLOXMELO
							return icon
						end
						local match = icon:match("%d+")
						return match and "rbxassetid://" .. match or nil
					end

					return nil
				end

				if true then
					if true then
						return "rbxassetid://" .. icon  -- LEAKED BY STARLOXMELO
					end

				end
			end
		end

		tbl18.mutationHex = function(arg)
			if not arg or arg == "" then
				arg = "Normal"
			end

			local v = tbl42[arg]
			if v then  -- LEAKED BY STARLOXMELO
				return v
			end
			local sliced109 = slicedfn58(arg)
			local str15 = string.format("#%02X%02X%02X", math.floor(sliced109.R * 255 + 0.5), math.floor(sliced109.G * 255 + 0.5), math.floor(sliced109.B * 255 + 0.5))
			tbl42[arg] = str15
			return str15
		end

		tbl18.joinStatus = function(arg)
			if not arg then
				return nil  -- LEAKED BY STARLOXMELO
			end
			local v = tbl43[arg]
			if type(v) ~= "table" or not v.status then
				return nil
			end

			if v.status == "joined" and not slicedfn77(arg) then
				return nil
			end
			return v.status
		end  -- LEAKED BY STARLOXMELO

		slicedfn74()
		slicedfn84()

		if not tbl36[str14] then
			str14 = "Default"
		end

		if not tbl36.Default then
			tbl36["Default"] = { Global = { Enabled = false, MinGen = 0 }, Items = {}, createdAt = 0 }
		end

		if tbl36[str14] then
			tbl32.Global = tbl36[str14].Global or tbl32.Global  -- LEAKED BY STARLOXMELO
			tbl32.Items = tbl36[str14].Items or tbl32.Items
		end

		task.spawn(slicedfn85)

		task.spawn(function()
			if type(huge) == "number" then
				local now2 = os.time()

				while task.wait(1) do
					if huge <= os.time() - now2 then
						task.wait(300)
						game:Shutdown()  -- LEAKED BY STARLOXMELO
					end
				end
			end
		end)

		task.spawn(function()
			if not plotController then
				return
			end
			local v, sliced109 = slicedfn55(plotController.GetPlots, plotController)

			if v and sliced109 then  -- LEAKED BY STARLOXMELO
				sliced103 = sliced109

				if false then
				else
					pcall(function()
						tbl38 = slicedfn90()
					end)
				end
			end
		end)

		task.spawn(function()  -- LEAKED BY STARLOXMELO
			local now2 = os.clock()

			while true do
				local flag26 = sliced93 == nil

				if flag26 then
					local v = 15
					flag26 = os.clock() - now2 < v
				end

				if flag26 then
					task.wait(0.1)
					continue  -- LEAKED BY STARLOXMELO
				end
				break
			end

			while sliced93 ~= false do
				if not slicedfn94() then
					return
				end
				task.wait(1)
			end

			if not animals or not mutations or not traits or not plotController or not sliced92 then  -- LEAKED BY STARLOXMELO
				return
			end

			if not sliced103 then
				local v, sliced109 = slicedfn55(plotController.GetPlots, plotController)
				if not (v and sliced109) then
					return
				end
				sliced103 = sliced109
			end

			for _, child in pairs(sliced92:GetChildren()) do  -- LEAKED BY STARLOXMELO
				if child:IsA("RemoteEvent") then
					child.OnClientEvent:Connect(function(...)
						if not slicedfn94() then
							return
						end
						slicedfn93(...)
					end)
				end
			end

			local playerGui = localPlayer2:WaitForChild("PlayerGui", 10)  -- LEAKED BY STARLOXMELO
			if not playerGui then
				return
			end
			local flag26 = false
			up_525 = slicedfn94
			up_526 = flag26
			up_527 = json
			up_528 = sliced108
			up_529 = slicedfn63
			up_530 = "?"  -- LEAKED BY STARLOXMELO
			up_531 = slicedfn91
			local function slicedfn103(B)if not up_525()then return;end;if up_526 then return;end;if not B:IsA("TextLabel")and not B:IsA("TextButton")then return;end;local I=B.Text;if not I or#I<10 then return;end;if I:find("[Yy][Oo][Uu]%s+[Ss][Tt][Oo][Ll][Ee]%s")then up_526 =true;if up_527 and up_528 then up_529(up_528 ,up_530 or"");elseif up_528 and(up_531(up_528 ))then B=up_530 or"";up_529(up_528 ,B);end;task.delay(3,function()up_526 =false;end);end;end
			up_532 = tbl50
			up_533 = flag26
			up_534 = slicedfn103
			local function slicedfn104(B)if not B:IsA("TextLabel")and not B:IsA("TextButton")then return;end;pcall(function()up_532[#up_532+1]=B:GetPropertyChangedSignal("Text"):Connect(function()if up_533 then return;end;pcall(up_534,B);end);end);end

			for _, descendant in ipairs(playerGui:GetDescendants()) do
				slicedfn104(descendant)
			end

			tbl50[#tbl50 + 1] = playerGui.DescendantAdded:Connect(function(descendant)  -- LEAKED BY STARLOXMELO
				if not slicedfn94() then
					return
				end

				if flag26 then
					return
				end
				pcall(slicedfn103, descendant)
				slicedfn104(descendant)
			end)
		end)  -- LEAKED BY STARLOXMELO

		local flag26 = false

		local function slicedfn103()
			if not slicedfn94() then
				return
			end

			if flag26 then
				return
			end
			flag26 = true
			if sliced93 then  -- LEAKED BY STARLOXMELO
				return
			end

			if not sliced103 or not animals or not mutations or not traits then
				return
			end

			if not sliced95 or not sliced94 then
				return
			end
			local ok, result = pcall(slicedfn90)
			if not ok or not result then  -- LEAKED BY STARLOXMELO
				return
			end
			local v = "?"
			local str15

			if "?" then
				str15 = v
			else
				str15 = ""
			end

			for k, sliced109 in pairs(result) do  -- LEAKED BY STARLOXMELO
				if not tbl38[k] then
					if not tbl39[(sliced109.DisplayName or "") .. "|" .. tostring(math.floor(sliced109.Generation or 0))] then
						if slicedfn91(sliced109) then
							pcall(function()
								slicedfn63(sliced109, str15)
							end)
						end
					end
				end
			end  -- LEAKED BY STARLOXMELO
		end

		game.Close:Connect(slicedfn103)

		Players2.PlayerRemoving:Connect(function(player)
			if true then
				if player == localPlayer2 then
					slicedfn103()
				end
			end
		end)

		local teleportInitFailed = TeleportService.TeleportInitFailed  -- LEAKED BY STARLOXMELO
		local connect2 = teleportInitFailed.Connect
		up_488 = GuiService
		local sliced109 = connect2(teleportInitFailed, function()pcall(function()up_488:ClearError();end);end)

		task.spawn(function()
			local ok, result = pcall(function()
				local wsUrl = getgenv().JoinerConfig_jhgjerdf324sa.WsUrl
				if type(wsUrl) ~= "string" then
					return nil
				end
				local str15 = wsUrl:gsub("^wss://", "https://"):gsub("^ws://", "http://"):gsub("/ws$", "/time")  -- LEAKED BY STARLOXMELO
				return game:HttpGet(str15)
			end)

			if not ok then
				return
			end
			local num = tonumber(result)

			if num and not sliced96 then
				slicedn35 = num - os.time()
			end
		end)  -- LEAKED BY STARLOXMELO

		local spawn_ = task.spawn
		up_489 = slicedfn94
		up_490 = kaWaifuSessionId
		up_491 = sliced95
		up_492 = flag24
		up_493 = tbl19
		up_494 = slicedfn66
		up_495 = slicedfn67
		up_496 = slicedfn68
		up_497 = tbl52  -- LEAKED BY STARLOXMELO
		up_498 = tbl30
		up_499 = slicedfn97
		up_500 = flag22
		up_501 = slicedfn82
		up_502 = slicedn34
		up_503 = slicedfn59
		up_504 = slicedfn96
		up_505 = slicedfn98
		up_506 = slicedfn95
		up_507 = tbl53  -- LEAKED BY STARLOXMELO
		up_508 = slicedfn81
		up_509 = flag21
		up_510 = slicedn33
		up_511 = str13
		up_512 = slicedfn99
		up_513 = slicedfn47
		up_514 = slicedfn100
		up_515 = Players2
		up_516 = slicedfn86
		up_517 = sliced109  -- LEAKED BY STARLOXMELO
		up_518 = slicedfn65
		up_519 = slicedfn64
		up_520 = tbl49
		up_521 = tbl50
		up_522 = tbl47
		up_523 = tbl48
		up_524 = sound
		spawn_(function()local B=0;local I=0;local e=2;local H=nil;while up_489()and getgenv()._KaWaifuSessionId==up_490 do B+=1;if not up_491 then local a=os.time();if up_492 or a-I>=e then if up_492 then up_492 ,e=false,2;end;up_493.setWsStatus("connecting");I,e,H=a,if up_494()then 2 else math.min(e*1.5,10)*(0.8+0.4*math.random()),nil;end;end;if H~=up_491 and not(up_492 and not up_491 )then H=up_491 ;up_493.setWsStatus(up_491 and"live"or"offline");end;up_495();up_496();if up_497.JobId and not up_498 [up_497.JobId]then local e=up_497.JobId;up_497.JobId=nil;up_497.UniqueKey=nil;up_497.Generation=-1;up_497.Priority=-1;if up_493.feedJoinEnded then pcall(up_493.feedJoinEnded,e);end;end;if up_499()then local e,H,a,K,L=not up_500 ,-1,-1;local A=-1;for P,v in pairs(up_498 )do if up_501(P)then continue;end;if P==game.JobId then continue;end;if v.animals and#v.animals>0 and(v.elapsedSeconds or 0)<=up_502 then local N,S,j=math.huge,false;local p,W=-1,-1;for r,s in ipairs(v.animals)do local v=s.DisplayName or"";local y=up_503(s.Generation or 0);if up_504(s)and(up_505(s,e))and(up_506(v,y,s.Mutation))then if s._duelDisplay then local e=math.max(0,s._duelDisplay);N=if e<N then e else N;else S=true;end;if not j then j,p,W=s,y,r;end;end;end;if j then local e=nil;if S then local v=up_507[P];if(not v or p>v)and not up_508(P)then e=j.prio or 0;if e>H or e==H and p>a then H,a,K,L,A=e,p,P,j,W;end;end;elseif up_509 then if N<=up_510 then local v=up_507[P];if(not v or p>v)and not up_508(P)then e=j.prio or 0;if e>H or e==H and p>a then H,a,K,L,A=e,p,P,j,W;end;end;end;end;end;end;end;if K then if if not up_497.JobId then true else if not up_498 [up_497.JobId]then true else if up_511 =="Any Newest"then false else if H>up_497.Priority then true else if H==up_497.Priority and a>up_497.Generation then true else false then up_512(K,up_513(K,L,A),a,H);end;end;end;if B%4==0 then up_514 ();end;if B%8==0 then for B,B in ipairs(up_515:GetPlayers())do up_516(B);end;end;task.wait(0.25);end;if up_517 then pcall(function()up_517 :Disconnect();end);up_517 =nil;end;if getgenv()._KaWaifuSessionId==up_490 then local B=getgenv()._KaWaifuWS;I=up_518();getgenv()._KaWaifuWS=nil;if I then pcall(up_519,I);end;if B and B~=I then pcall(up_519,B);end;for B,B in ipairs(up_520)do pcall(function()B:Disconnect();end);end;table.clear(up_520);for B,B in ipairs(up_521)do pcall(function()B:Disconnect();end);end;table.clear(up_521);table.clear(up_522 );table.clear(up_523 );for B,B in ipairs(up_515:GetPlayers())do pcall(up_516,B);end;pcall(function()up_524:Destroy();end);end;end)

		if tbl19.setWsStatus then
			tbl19.setWsStatus("connecting")  -- LEAKED BY STARLOXMELO
		end
	end

	str9 = "v" .. tostring(getgenv().AJVersion or "?")
	tbl20 = { DiscordInvite = tbl17.DiscordInvite }

	tbl21 = {
		"Capitano Moby",
		"La Grande Combinasion",
		"Garama and Madundung",
		"Torrtugini Dragonfrutini",
		"La Vacca Saturno Saturnita",  -- LEAKED BY STARLOXMELO
		"Chicleteira Bicicleteira",
	}

	Players = game:GetService("Players")
	service2 = game:GetService("TweenService")
	UserInputService = game:GetService("UserInputService")
	service = game:GetService("HttpService")
	localPlayer = Players.LocalPlayer

	tbl22 = {
		Background = Color3.fromRGB(13, 11, 14),
		Sidebar = Color3.fromRGB(17, 14, 18),  -- LEAKED BY STARLOXMELO
		Element = Color3.fromRGB(26, 21, 27),
		ElementHover = Color3.fromRGB(36, 27, 36),
		Accent = Color3.fromRGB(232, 106, 155),
		Accent2 = Color3.fromRGB(214, 150, 179),
		Text = Color3.fromRGB(236, 228, 233),
		TextDim = Color3.fromRGB(150, 132, 143),
		Stroke = Color3.fromRGB(52, 40, 50),
		SliderTrack = Color3.fromRGB(44, 35, 44),
		Good = Color3.fromRGB(110, 200, 140),
		Warn = Color3.fromRGB(215, 185, 110),  -- LEAKED BY STARLOXMELO
		Bad = Color3.fromRGB(210, 95, 105),
	}

	do
		local windowSize = tbl17.WindowSize
		minWindowSize = tbl17.MinWindowSize
		x2 = windowSize.X
		y2 = windowSize.Y
		up_2 = windowSize
	end
end  -- LEAKED BY STARLOXMELO

slicedfn46 = function(B,I)return math.clamp((B/up_2.X+I/up_2.Y)/2,0.6,3);end
up_3 = x2
up_4 = 1
up_5 = y2
slicedfn30 = function()return math.floor(up_3 /up_4 +0.5),math.floor(up_5 /up_4 +0.5);end
topBarHeight = tbl17.TopBarHeight
sidebarWidth = tbl17.SidebarWidth
flag18 = true
flag19 = false
flag20 = false  -- LEAKED BY STARLOXMELO
tbl27 = {}

slicedfn31 = function(arg)
	table.insert(tbl27, arg)
	return arg
end

tbl23 = {
	AutoJoin = tbl17.DefaultAutoJoin,
	AnimSpeed = tbl17.DefaultAnimSpeed,
	Whitelist = {},
	MaxDuelTime = tbl17.DefaultMaxDuelTime,  -- LEAKED BY STARLOXMELO
	TPDuelEnabled = tbl17.DefaultShowDuels,
	CarpetMode = tbl17.DefaultCarpetMode,
	AutoJoinOGOffAJ = tbl17.DefaultAutoJoinOGOffAJ,
	MidRetrySwitch = tbl17.DefaultMidRetrySwitch,
	Attempts = tbl17.DefaultAttempts,
	MaxElapsedJoin = tbl17.DefaultMaxServerAge,
	BruteForceJoin = tbl17.DefaultBruteForce,
	MinimizeOnInject = tbl17.DefaultMinimizeOnInject,
	SoundId = tbl17.DefaultSoundId,
	SoundVolume = tbl17.DefaultSoundVolume,  -- LEAKED BY STARLOXMELO
	HotkeyMinimize = tbl17.DefaultHotkeyMinimize,
	HotkeyAutoTP = tbl17.DefaultHotkeyAutoTP,
	AutoPickWS = false,
	LatencyCache = {},
}

slicedfn32 = function()
	pcall(function()
		writefile("KaWaifuJoiner.json", service:JSONEncode(tbl23))
	end)
end  -- LEAKED BY STARLOXMELO

do
	local function slicedfn47()
		local flag21 = false
		local flag22 = false

		pcall(function()
			if isfile and isfile("KaWaifuJoiner.json") then
				local data = service:JSONDecode(readfile("KaWaifuJoiner.json"))
				local v = "table"

				if type(data) == v then
					for k, sliced91 in pairs(data) do  -- LEAKED BY STARLOXMELO
						tbl23[k] = sliced91
					end

					flag21 = true
					flag22 = data.Attempts ~= nil or data.MaxDuelTime ~= nil or data.MaxElapsedJoin ~= nil
				end
			end
		end)

		if not flag21 or not flag22 then
			pcall(function()
				if isfile and isfile("KaWaifuJoiner_Settings.json") then  -- LEAKED BY STARLOXMELO
					local data = service:JSONDecode(readfile("KaWaifuJoiner_Settings.json"))
					local v = "table"

					if type(data) == v then

						for _, sliced91 in ipairs({
							"SoundId",
							"SoundVolume",
							"MinimizeOnInject",
							"BruteForceJoin",
							"HotkeyMinimize",
							"HotkeyAutoTP",  -- LEAKED BY STARLOXMELO
						}) do
							if data[sliced91] ~= nil then
								tbl23[sliced91] = data[sliced91]
							end
						end
					end
				end

				if isfile and isfile("KaWaifuJoiner_Config.json") then
					local data = service:JSONDecode(readfile("KaWaifuJoiner_Config.json"))

					if type(data) == "table" then  -- LEAKED BY STARLOXMELO
						if data.MaxDuelTime then
							tbl23.MaxDuelTime = data.MaxDuelTime
						end

						if data.Attempts then
							if true then
								tbl23.Attempts = data.Attempts
							end
						end

						if data.MaxElapsedJoin then
							tbl23.MaxElapsedJoin = data.MaxElapsedJoin  -- LEAKED BY STARLOXMELO
						end

						if data.TPDuelEnabled ~= nil then
							tbl23.TPDuelEnabled = data.TPDuelEnabled
						end
					end
				end
			end)
		end
	end

	slicedfn47()  -- LEAKED BY STARLOXMELO
end

local Frame2

do
	do
		do
			do
				tbl23.AutoJoin = false
				tbl23.AnimSpeed = math.clamp(tonumber(tbl23.AnimSpeed) or 5, 1, 10)

				if type(tbl23.Whitelist) ~= "table" then
					tbl23.Whitelist = {}  -- LEAKED BY STARLOXMELO
				end

				tbl23.MaxDuelTime = math.max(0, tonumber(tbl23.MaxDuelTime) or 10)
				tbl23.TPDuelEnabled = tbl23.TPDuelEnabled ~= false

				if tbl23._duelDefaultOn ~= true then
					tbl23.TPDuelEnabled = true
					tbl23._duelDefaultOn = true
				end

				if tbl23.CarpetMode ~= "Yes" and tbl23.CarpetMode ~= "Only" and tbl23.CarpetMode ~= "No" then
					tbl23.CarpetMode = tbl17.DefaultCarpetMode or "Yes"

				end  -- LEAKED BY STARLOXMELO

				tbl23.AutoJoinOGOffAJ = tbl23.AutoJoinOGOffAJ == true

				if tbl23.MidRetrySwitch ~= "Better Newest" and tbl23.MidRetrySwitch ~= "Any Newest" then
					tbl23.MidRetrySwitch = tbl17.DefaultMidRetrySwitch or "Better Newest"
				end

				tbl23.Attempts = math.max(1, math.floor(tonumber(tbl23.Attempts) or 50))
				tbl23.MaxElapsedJoin = math.max(0, tonumber(tbl23.MaxElapsedJoin) or 10)
				tbl23.BruteForceJoin = tbl23.BruteForceJoin ~= false
				tbl23.MinimizeOnInject = tbl23.MinimizeOnInject == true
				tbl23.SoundId = tostring(tbl23.SoundId or "5348162330"):match("%d+") or "5348162330"
				tbl23.SoundVolume = math.floor(math.clamp(tonumber(tbl23.SoundVolume) or 10, 0, 10) * 10 + 0.5) / 10  -- LEAKED BY STARLOXMELO

				if type(tbl23.HotkeyMinimize) ~= "string" then
					tbl23.HotkeyMinimize = "Z"
				end

				if type(tbl23.HotkeyAutoTP) ~= "string" then
					tbl23.HotkeyAutoTP = "X"
				end

				do
					local v = "string"

					if type(tbl23.Region) ~= v or tbl23.Region == "" then
						tbl23.Region = nil  -- LEAKED BY STARLOXMELO
					end
				end
			end

			tbl23.AutoPickWS = tbl23.AutoPickWS == true

			if type(tbl23.LatencyCache) ~= "table" then
				tbl23.LatencyCache = {}
			end

			do
				local latencyCache = {}

				for k, v in pairs(tbl23.LatencyCache) do  -- LEAKED BY STARLOXMELO
					if type(k) == "string" and type(v) == "table" then
						local num = tonumber(v.u)
						local num2 = tonumber(v.s)
						local num3 = tonumber(v.t)

						if num and num3 then
							latencyCache[k] = { u = num, s = num2, t = num3 }
						end
					end
				end

				tbl23.LatencyCache = latencyCache  -- LEAKED BY STARLOXMELO
			end
		end

		do
			tbl23.HotkeyRejoin = nil
			tbl23.IconPos = nil

			if type(tbl23.WinSize) == "table" and tonumber(tbl23.WinSize.w) and tonumber(tbl23.WinSize.h) then
				do
					local x = minWindowSize.X
					x2 = math.clamp(math.floor(tonumber(tbl23.WinSize.w)), x, 1920)
				end  -- LEAKED BY STARLOXMELO

				do
					local y = minWindowSize.Y
					y2 = math.clamp(math.floor(tonumber(tbl23.WinSize.h)), y, 1080)
				end

				tbl23.WinSize = { w = x2, h = y2 }
			else
				tbl23.WinSize = nil

			end

			sliced84 = slicedfn46(x2, y2)

			do  -- LEAKED BY STARLOXMELO
				local animSpeed = tbl23.AnimSpeed

				slicedfn33 = function()
					slicedfn32()

					if tbl18.applySettings then
						pcall(tbl18.applySettings, tbl23)
					end
				end

				slicedfn34 = function()
					if tbl23.AutoJoin then
						return "ON", tbl22.Good  -- LEAKED BY STARLOXMELO
					end

					if tbl23.AutoJoinOGOffAJ then
						return "OG", tbl22.Warn
					end
					return "OFF", tbl22.Bad
				end

				tbl24 = {}
				tbl25 = {}

				local tbl28 = {
					"",  -- LEAKED BY STARLOXMELO
					"K",
					"M",
					"B",
					"T",
					"Qa",
					"Qi",
					"Sx",
					"Sp",
					"Oc",
					"No",  -- LEAKED BY STARLOXMELO
					"Dc",
					"Ud",
					"Dd",
					"Td",
					"Qad",
					"Qid",
					"Sxd",
					"Spd",
					"Ocd",
					"Nod",  -- LEAKED BY STARLOXMELO
					"Vg",
					"Uvg",
					"Dvg",
					"Tvg",
				}

				up_6 = tbl28
				slicedfn35 = function(B)B=tostring(B or""):gsub("/s$",""):gsub("%s","");local I=tonumber(B);if I then return I;end;local I,e=B:match("[%a]+$"),B:match("^[%d%.]+");if e and I then for B,H in ipairs(up_6)do if H~=""and H:lower()==I:lower()then return(tonumber(e)or 0)*1000^(B-1);end;end;end;return 0;end
				up_7 = tbl28
				slicedfn36 = function(B,I)B,I=tonumber(B)or 0,I or 1;local e,H=math.floor(math.log(math.max(1,math.abs(B)),1000)),10^I;local a=math.floor(B*(H/1000^e))/H;return string.format("%."..I.."f",a):gsub("%.?0+$","")..(up_7[e+1]or"e+"..e);end
				slicedfn37 = function(w,B)local I=Instance.new(w);for w,e in pairs(B)do if w~="Parent"then I[w]=e;end;end;if B.Parent then I.Parent=B.Parent;end;return I;end  -- LEAKED BY STARLOXMELO
				up_8 = service2
				slicedfn38 = function(B,I,e,H,a)local K=up_8:Create(B,TweenInfo.new(I,H or Enum.EasingStyle.Quad,a or Enum.EasingDirection.Out),e);K:Play();return K;end
				up_9 = slicedfn37
				slicedfn39 = function(B,I)return up_9("UICorner",{CornerRadius=UDim.new(0,I),Parent=B});end

				ScreenGui = slicedfn37("ScreenGui", {
					Name = "KaWaifuJoinerUI",
					ResetOnSpawn = false,
					IgnoreGuiInset = true,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = 999999,  -- LEAKED BY STARLOXMELO
				})

				slicedfn40 = function()
					if not flag18 then
						return
					end
					flag18 = false

					for _, v in ipairs(tbl27) do
						pcall(function()
							v:Disconnect()
						end)  -- LEAKED BY STARLOXMELO
					end
				end

				ScreenGui.Destroying:Connect(slicedfn40)

				slicedfn41 = function(arg)
					local ok, result = pcall(function()
						return gethui()
					end)

					local service3

					if ok and typeof(result) == "Instance" then
						service3 = result  -- LEAKED BY STARLOXMELO
					elseif syn and syn.protect_gui then
						pcall(syn.protect_gui, arg)
						service3 = game:GetService("CoreGui")
					else
						local ok2

						ok2, service3 = pcall(function()
							return game:GetService("CoreGui")
						end)

						service3 = ok2 and service3 or localPlayer:WaitForChild("PlayerGui")
					end  -- LEAKED BY STARLOXMELO

					local kaWaifuJoinerUI = service3:FindFirstChild("KaWaifuJoinerUI")

					if kaWaifuJoinerUI and kaWaifuJoinerUI ~= arg then
						kaWaifuJoinerUI:Destroy()
					end

					arg.Parent = service3
				end

				up_10 = slicedfn37
				up_11 = tbl22
				up_12 = slicedfn39
				up_13 = flag18  -- LEAKED BY STARLOXMELO
				up_14 = animSpeed
			end
		end

		up_15 = slicedfn38
		slicedfn42 = function(B,I,e,H)for a=1,I,1 do local I=math.random(10,18);local K=math.max(5,math.floor(I*0.45));local L=up_10("Frame",{Name="Petal"..a,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(math.random(),0,0,-30),Size=UDim2.fromOffset(I,K),BackgroundColor3=a%2==0 and up_11.Accent or up_11.Accent2,BackgroundTransparency=0.55+math.random()*0.3,BorderSizePixel=0,Rotation=math.random(0,360),ZIndex=e,Parent=B});up_12(L,math.ceil(K/2));task.spawn(function()task.wait(math.random(0,45)/10);while up_13 and L.Parent do if H and not H()then task.wait(1);continue;end;local B,I=math.random(),(math.random()-0.5)*0.35;L.Position=UDim2.new(B,0,0,-30);L.Rotation=math.random(0,360);local e=math.random(45,95)/10/math.max(up_14 /5,0.1);up_15(L,e,{Position=UDim2.new(math.clamp(B+I,0.02,0.98),0,1,30),Rotation=L.Rotation+math.random(-200,200)},Enum.EasingStyle.Linear);task.wait(e);end;end);end;end

		do
			local v, sliced91 = slicedfn30()

			Frame = slicedfn37("Frame", {
				Name = "Main",
				AnchorPoint = Vector2.new(0.5, 0.5),  -- LEAKED BY STARLOXMELO
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(v, sliced91),
				BackgroundColor3 = tbl22.Background,
				BorderSizePixel = 0,
				Active = true,
				Visible = false,
				Parent = ScreenGui,
			})
		end
	end  -- LEAKED BY STARLOXMELO

	do
		do
			slicedfn39(Frame, 12)
			sliced85 = slicedfn37("UIScale", { Scale = 0, Parent = Frame })

			do
				local Frame3 = slicedfn37("Frame", {
					Name = "Background",
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,  -- LEAKED BY STARLOXMELO
					ClipsDescendants = true,
					ZIndex = 1,
					Parent = Frame,
				})

				slicedfn39(Frame3, 12)

				slicedfn37("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(16, 12, 16), Color3.fromRGB(11, 9, 12)),
					Rotation = 115,
					Parent = Frame3,
				})  -- LEAKED BY STARLOXMELO

				local CanvasGroup = slicedfn37("CanvasGroup", {
					Name = "PetalLayer",
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 1,
					Parent = Frame3,
				})

				slicedfn39(CanvasGroup, 12)

				slicedfn42(CanvasGroup, 10, 1, function()  -- LEAKED BY STARLOXMELO
					if true then
						return Frame.Visible
					end

				end)
			end
		end

		up_16 = tbl26
		up_17 = tbl23

		up_18 = slicedfn32
		;(function()local B,I=up_16,getgenv().JoinerConfig_jhgjerdf324sa;local e,H,a,K=B.scheme or"ws",B.path or"",B.fail_threshold or 3;local function L()local A={};local P,v=K or up_17.Region or B.default,false;for N,N in ipairs(B.regions)do if N.id==P then v=true;break;end;end;P=if not v then B.default else P;for v,v in ipairs(B.regions)do if v.id==P then table.insert(A,1,v);else table.insert(A,v);end;end;return A;end;local A,P=L(),0;local function v(N)if not N then return;end;if N.host then I.WsUrl=e.."://"..N.host..":"..tostring(N.port)..H;elseif N.url then I.WsUrl=N.url;else warn("[KaWaifu Region] region '"..tostring(N.id).."' has no host/url \226\128\148 not applied");return;end;getgenv().KaWaifuActiveRegion=N.id;end;v(A[1]);getgenv().__kawaifu_region_fail=function()P+=1;if P%a==0 and#A>1 then warn("[KaWaifu Region] "..P.." failed connects to current region");if getgenv().__kawaifu_on_region_trouble then pcall(getgenv().__kawaifu_on_region_trouble);end;end;end;getgenv().__kawaifu_region_ok=function()P=0;end;getgenv().__kawaifu_set_region=function(I)K=nil;up_17.Region=I;pcall(up_18 );A,P=L(),0;v(A[1]);end;getgenv().__kawaifu_set_region_session=function(w)K=w;A,P=L(),0;v(A[1]);end;getgenv().__kawaifu_region_list=function()local w={};for I,I in ipairs(B.regions)do w[#w+1]={id=I.id,label=I.label};end;return w;end;end)()  -- LEAKED BY STARLOXMELO

		Frame2 = slicedfn37("Frame", {
			Name = "TopBar",
			Size = UDim2.new(1, 0, 0, topBarHeight),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = Frame,
		})

		slicedfn37("TextLabel", {
			Name = "Title",
			Position = UDim2.fromOffset(16, 0),  -- LEAKED BY STARLOXMELO
			Size = UDim2.new(0, 112, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = "KaWaifu AJ",
			TextColor3 = tbl22.Text,
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 3,
			Parent = Frame2,
		})  -- LEAKED BY STARLOXMELO

		slicedfn37("TextLabel", {
			Name = "Version",
			Position = UDim2.fromOffset(120, 3),
			Size = UDim2.new(0, 60, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			Text = str9,
			TextColor3 = tbl22.TextDim,
			TextTransparency = 0.35,
			TextSize = 13,  -- LEAKED BY STARLOXMELO
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 3,
			Parent = Frame2,
		})

		slicedfn43 = nil

		do
			local function slicedfn47()
				local str10 = "https://" .. tbl20.DiscordInvite

				local ok = pcall(function()
					if true then  -- LEAKED BY STARLOXMELO
						setclipboard(str10)
						return
					end

				end)

				if slicedfn43 then

					if ok then
						slicedfn43("Discord", "Invite copied: " .. tbl20.DiscordInvite)
					else
						slicedfn43("Discord", "Our discord: " .. tbl20.DiscordInvite, 6)
					end  -- LEAKED BY STARLOXMELO
				end
			end

			local TextButton = slicedfn37("TextButton", {
				Name = "Discord",
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -84, 0.5, 0),
				Size = UDim2.fromOffset(115, 24),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				AutoButtonColor = false,  -- LEAKED BY STARLOXMELO
				Font = Enum.Font.Gotham,
				Text = tbl20.DiscordInvite,
				TextColor3 = tbl22.TextDim,
				TextSize = 13,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Right,
				ZIndex = 4,
				Parent = Frame2,
			})

			slicedfn37("UISizeConstraint", { MaxSize = Vector2.new(300, math.huge), Parent = TextButton })  -- LEAKED BY STARLOXMELO

			slicedfn31(TextButton.MouseEnter:Connect(function()
				slicedfn38(TextButton, 0.15, { TextColor3 = tbl22.Accent2 })
			end))

			slicedfn31(TextButton.MouseLeave:Connect(function()
				slicedfn38(TextButton, 0.15, { TextColor3 = tbl22.TextDim })
			end))

			slicedfn31(TextButton.MouseButton1Click:Connect(slicedfn47))
		end
	end

	sliced86 = function() end  -- LEAKED BY STARLOXMELO
	sliced87 = function() end
	sliced88 = function() end
	up_19 = tbl17
	up_20 = slicedfn37
	up_21 = tbl22
	up_22 = Frame
	up_23 = slicedfn39
	up_24 = tbl25
	up_25 = sliced86
	up_26 = tbl18  -- LEAKED BY STARLOXMELO
	up_27 = slicedfn38
	up_28 = slicedfn31
	up_29 = slicedfn43
	up_30 = tbl26
	up_31 = UserInputService
	up_32 = connect
	up_33 = tbl23
	up_34 = slicedfn32
	up_35 = flag18
	up_36 = sliced87  -- LEAKED BY STARLOXMELO

	up_37 = sliced88
	;(function()local B=up_19.WsTabX;local I=up_19.WsTabOutY;local e=up_19.WsTabHiddenY;local H=240;local a=36;local K=up_20("TextButton",{Name="WsTab",Position=UDim2.fromOffset(B,e),Size=UDim2.fromOffset(H,a),BackgroundColor3=up_21.Element,AutoButtonColor=false,ClipsDescendants=true,Text="",Visible=false,ZIndex=0,Parent=up_22});up_23(K,10);up_20("UIStroke",{Color=up_21.Stroke,Transparency=0.3,Thickness=1,Parent=K});local L=up_20("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,a),BackgroundTransparency=1,ZIndex=4,Parent=K});local A=up_20("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.fromOffset(12,14),Size=UDim2.fromOffset(8,8),BackgroundColor3=up_21.Bad,BorderSizePixel=0,ZIndex=5,Parent=L});up_23(A,4);local P=up_20("TextLabel",{Position=UDim2.fromOffset(26,0),Size=UDim2.new(1,-56,0,28),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text="Offline",TextColor3=up_21.Text,TextSize=14,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,Parent=L});local v=up_20("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0,14),Size=UDim2.fromOffset(16,16),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="v",TextColor3=up_21.TextDim,TextSize=14,Rotation=180,ZIndex=5,Parent=L});local N="Offline";local S=nil;S=function()P.Text=N..(up_24.wsRegionText and"  \194\183  "..up_24.wsRegionText or"");end;up_25 =function(P)local j={live={text="Live",color=up_21.Good},connecting={text="Connecting...",color=up_21.Warn},offline={text="Offline",color=up_21.Bad}};local p=j[P]or j.offline;N=p.text;A.BackgroundColor3=p.color;S();if up_24.iconDot then up_24.iconDot.BackgroundColor3=p.color;end;if up_24.miniWsText then up_24.miniWsText.Text=p.text;up_24.miniWsText.TextColor3=p.color;end;end;local A;local P,N=false,false;do local j,p=pcall(function()return getgenv().__kawaifu_region_list and(getgenv().__kawaifu_region_list())or{};end);local W=j and type(p)=="table"and p or{};local function r()local s=getgenv().KaWaifuActiveRegion;for y,y in ipairs(W)do if y.id==s then return y.label or y.id;end;end;return W[1]and(W[1].label or W[1].id)or nil;end;if#W>0 then local s,y,h,_,o,E,R,J={},{},{},{},Color3.fromRGB(205,172,102),{};local function l(T,d)local M=d and getgenv().__kawaifu_set_region or getgenv().__kawaifu_set_region_session;if M then pcall(M,T);end;d=up_26.reconnect;if d then d();end;up_24.wsRegionText=r();if up_24.miniThird then up_24.miniThird.Text=up_24.wsRegionText or"\226\128\148";end;up_25 (d and"connecting"or"offline");if J then J();end;end;local T=math.min(#W,4)*30+10;L=up_20("ScrollingFrame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,-a),Size=UDim2.new(1,0,0,T),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=up_21.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=4,Parent=K});up_20("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,Parent=L});up_20("UIPadding",{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),Parent=L});up_20("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,10,1,-a),Size=UDim2.new(1,-20,0,1),BackgroundColor3=up_21.Stroke,BackgroundTransparency=0.3,BorderSizePixel=0,ZIndex=4,Parent=K});local d=false;A=function(M)if d==M then return;end;d=M;if M then up_27(K,0.2,{Position=UDim2.fromOffset(B,I-T),Size=UDim2.fromOffset(H,a+T)});else up_27(K,0.16,{Position=UDim2.fromOffset(B,I),Size=UDim2.fromOffset(H,a)},Enum.EasingStyle.Quad,Enum.EasingDirection.In);end;up_27(v,0.2,{Rotation=M and 0 or 180});end;for H,a in ipairs(W)do local W=a.id;local T=a.label or W;local a=up_20("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=up_21.ElementHover,BackgroundTransparency=0.35,AutoButtonColor=false,Font=Enum.Font.GothamMedium,Text=T,TextColor3=up_21.Text,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,LayoutOrder=H,ZIndex=5,Parent=L});up_23(a,6);y[W]=a;_[W]=H;up_20("UIPadding",{PaddingLeft=UDim.new(0,32),PaddingRight=UDim.new(0,72),Parent=a});h[W]=up_20("TextLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,-22,0.5,0),Size=UDim2.fromOffset(18,16),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="\226\128\147",TextColor3=up_21.TextDim,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=a});s[W]=up_20("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,62,0.5,0),Size=UDim2.fromOffset(68,16),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="\226\128\166",TextColor3=up_21.TextDim,TextSize=13,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=6,Parent=a});E[W]=up_20("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=o,Thickness=1.5,Transparency=1,Parent=a});up_28 (a.MouseEnter:Connect(function()up_27(a,0.12,{BackgroundTransparency=0});end));up_28 (a.MouseLeave:Connect(function()up_27(a,0.12,{BackgroundTransparency=0.35});end));up_28 (a.MouseButton1Click:Connect(function()A(false);l(W,true);if R then R();end;if up_29 then up_29 ("WebSocket","Switching to "..T.."...",3);end;end));end;up_28 (K.MouseButton1Click:Connect(function()if not P or N then return;end;A(not d);if J then J();end;end));up_24.wsRegionText=r();S();getgenv().__kawaifu_on_region_trouble=function()if up_29 then pcall(up_29 ,"WebSocket","Connection trouble \226\128\148 click the status tab (top) to switch edge",8);end;end;local H,a,L,W,T=up_30.regions,up_30.scheme or"ws",(up_30.path or""):gsub("/ws$",""),{};local d,M,C={};local V=os.clock();local F=false;local U=0;local q=up_31.TouchEnabled;local m,Q=q and(math.max(up_19.LatProbeSweepSecs,#H*(up_19.LatProbeTimeout+0.5)))or up_19.LatProbeSweepSecs,q and up_19.LatProbeOnTouch==false and getgenv().KWProbeEdges~=true;local function c(g)local b={streakId=nil,streakSince=nil,doSwitch=false,deferSwitch=false,doPopup=false};if not g.bestId or not g.curTotal or g.curState~="ok"then return b;end;if g.autoPick and not g.earlyDone and g.now-g.injectAt<=up_19.LatEarlyWindow then local i=math.max(up_19.LatSwitchMarginMs,g.curTotal*up_19.LatSwitchMarginPct);if g.bestTotal<g.curTotal-i then if g.joining then b.deferSwitch=true;else b.doSwitch=true;return b;end;end;end;if g.bestTotal<g.curTotal then b.streakId=g.bestId;b.streakSince=g.streakId==g.bestId and g.streakSince or g.now;local i=g.popupLast[g.bestId];if g.now-b.streakSince>=up_19.LatBetterStreak and(not i or g.now-i>=up_19.LatPopupCooldown)then b.doPopup=true;end;end;return b;end;local function g(b)if not T then return nil;end;local i=os.clock()-T.receivedAt+T.asof;if i>up_19.LatServerDead then return nil;end;local t=T.regions[b];if not t then return nil;end;return t,i>up_19.LatServerStale and"stale"or"ok";end;local function b(i)local t=W[i];if t and(t.fails or 0)>=2 then return nil,"offline";end;if not t or not t.ewma or not t.lastOk or os.clock()-t.lastOk>4.5*m then return nil,"measuring";end;local Z,D=g(i);if not Z then return nil,"measuring";end;return math.floor(t.ewma+Z+0.5),D;end;local function i(t)local Z=math.clamp(t/150,0,1);if Z<0.5 then return up_21.Good:Lerp(up_21.Warn,Z*2);end;return up_21.Warn:Lerp(up_21.Bad,(Z-0.5)*2);end;J=function()local t,Z=tostring(getgenv().KaWaifuActiveRegion or""),{};for D,X in ipairs(H)do D=s[X.id];if D then local n,f=b(X.id);if n then D.Text=tostring(n).."ms";elseif f=="offline"then D.Text="offline";D.TextColor3=up_21.Bad;else D.Text=Q and""or"\226\128\166";D.TextColor3=up_21.TextDim;end;local D,Y=y[X.id],h[X.id];if D and Y then local G=E[X.id];if G then G.Transparency=X.id==t and 0.15 or 1;end;if n then Z[#Z+1]={id=X.id,total=n,stale=f~="ok"};else D.LayoutOrder=(f=="offline"and 200 or 100)+(_[X.id]or 0);Y.Text="\226\128\147";Y.TextColor3=f=="offline"and up_21.Bad or up_21.TextDim;end;end;end;end;table.sort(Z,function(E,D)if E.total~=D.total then return E.total<D.total;end;return(_[E.id]or 0)<(_[D.id]or 0);end);t=Z[1]and Z[1].total;for _,E in ipairs(Z)do local Z,D,X,n=y[E.id],h[E.id],s[E.id],i(E.total-t);Z.LayoutOrder=_;D.Text=tostring(_);D.TextColor3=n;X.TextColor3=E.stale and up_21.Warn or n;end;end;R=function()M,C,d=nil,nil,{};end;up_24.latOnServerTable=function(s,y)if type(s)~="table"then return;end;local h={};for _,E in pairs(s)do local s=tonumber(E);if type(_)=="string"and s and s>=0 and s<=60000 then h[_]=s;end;end;T={regions=h,receivedAt=os.clock(),asof=math.max(0,tonumber(y)or 0)};J();end;local function s(y)if getgenv().KWProbeEdges==false or Q then return;end;local h=y.id;local _=y.host;local E=y.port;if not _ or not up_32 then return;end;local y=W[h];if not y then y={fails=0};W[h]=y;end;if y.inflight and os.clock()-y.inflight<2*m+up_19.LatProbeTimeout then return;end;local h=os.clock();y.inflight=h;task.spawn(function()local R,Q=pcall(up_32,a.."://".._..":"..tostring(E)..L.."/probe");if not R or not Q then if y.inflight==h then y.inflight=nil;end;return;end;local a,L,_=false;local E,i=0;i=Q.OnMessage:Connect(function()local t=os.clock();if _ then local Z=t-_;local D=not L or Z<L;if D then L=Z;end;end;E+=1;t=E;if t>=2 then a=true;else _=os.clock();pcall(function()Q:Send("2");end);end;end);_=os.clock();pcall(function()Q:Send("1");end);R=os.clock()+up_19.LatProbeTimeout;while not a and os.clock()<R do task.wait(0.05);end;if i then pcall(function()i:Disconnect();end);end;pcall(function()Q:Close();end);R=y.inflight==h;if R then y.inflight=nil;end;if a and L then local a=L*500;y.ewma=y.ewma and 0.4*a+0.6*y.ewma or a;y.lastOk=os.clock();y.fails=0;elseif R then y.fails=(y.fails or 0)+1;end;end);end;local function a()if os.clock()-U<60 then return;end;U=os.clock();local L=up_33.LatencyCache;if type(L)~="table"then L={};up_33.LatencyCache=L;end;local y=false;for h,h in ipairs(H)do local _,E=W[h.id],g(h.id);if _ and _.ewma and E and(_.fails or 0)<2 and _.lastOk and os.clock()-_.lastOk<=4.5*m then L[h.id]={u=math.floor(_.ewma+0.5),s=math.floor(E+0.5),t=os.time()};y=true;end;end;if y then pcall(up_34 );end;end;local function L()local y=tostring(getgenv().KaWaifuActiveRegion or"");local h,_=b(y);local E,R;for U,U in ipairs(H)do if U.id~=y then local Q,g=b(U.id);if Q and g=="ok"and(not E or Q<E)then E,R=Q,U;end;end;end;local U=false;if up_26.isJoining then local Q,g=pcall(up_26.isJoining);U=Q and g==true;end;local Q=c({now=os.clock(),curTotal=h,curState=_,bestId=R and R.id or nil,bestTotal=E,streakId=M,streakSince=C,popupLast=d,earlyDone=F,injectAt=V,autoPick=up_33.AutoPickWS,joining=U});M,C=Q.streakId,Q.streakSince;if Q.deferSwitch then V+=m;elseif Q.doSwitch and R then F=true;l(R.id,false);if up_29 then pcall(up_29 ,"WebSocket","Auto-pick: switching to "..(R.label or R.id).." ("..E.." ms)...",4);end;elseif Q.doPopup and R then d[R.id]=os.clock();if up_29 then pcall(up_29 ,"Better websocket available",(R.label or R.id).." \226\128\148 "..E.." ms  (current: "..(r()or y).." \226\128\148 "..h.." ms). You can switch in the WS tab.",8);end;end;end;task.spawn(function()task.wait(q and 22 or 2);while up_35 do local y=m/math.max(1,#H);for h,h in ipairs(H)do if not up_35 then return;end;local _=false;if q and up_26.isJoining then local E,R=pcall(up_26.isJoining);_=E and R==true;end;if not _ then s(h);end;task.wait(y);end;J();L();a();end;end);(function()local a,L,s,y=os.time(),os.clock(),{};for h,_ in ipairs(H)do h=up_33.LatencyCache[_.id];local E,R,l=type(h)=="table"and(tonumber(h.u)),type(h)=="table"and(tonumber(h.s)),type(h)=="table"and(tonumber(h.t));if E and R and l then h=a-l;if h>=0 and h<=60 then if not W[_.id]then W[_.id]={ewma=E,lastOk=L-h,fails=0};end;s[_.id]=R;y=if not y or h>y then h else y;end;end;end;a=y and not T;if a then T={regions=s,receivedAt=L,asof=y};end;if y then J();end;end)();if up_33.AutoPickWS then j=os.time();o,p=nil;for a,L in ipairs(H)do a=up_33.LatencyCache[L.id];if type(a)=="table"and(tonumber(a.u))and(tonumber(a.s))and(tonumber(a.t))and j-a.t<=up_19.LatCacheMaxAge then local H=a.u+a.s;if not o or H<o then o,p=H,L.id;end;end;end;if p then F=true;if p~=tostring(getgenv().KaWaifuActiveRegion or"")then local H=getgenv().__kawaifu_set_region_session;if H then pcall(H,p);end;up_24.wsRegionText=r();S();end;end;end;else v.Visible=false;end;end;up_36 =function()if P then return nil;end;P,N=true,true;K.Visible=true;local H=up_27(K,0.25,{Position=UDim2.fromOffset(B,I)});H.Completed:Connect(function()if P then N=false;end;end);return H;end;up_37 =function()if A then A(false);end;if not P then return nil;end;P,N=false,true;local I=up_27(K,0.2,{Position=UDim2.fromOffset(B,e)},Enum.EasingStyle.Quad,Enum.EasingDirection.In);I.Completed:Connect(function()if not P then N=false;K.Visible=false;end;end);return I;end;end)()
	up_38 = slicedfn37
	up_39 = tbl22
	up_40 = Frame2
	up_41 = slicedfn39
	up_42 = slicedfn31
	up_43 = slicedfn38

	do
		local function slicedfn47(B,I,e,H)local a=up_38("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,I,0.5,0),Size=UDim2.fromOffset(28,28),BackgroundColor3=e,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text=B,TextColor3=up_39.Text,TextSize=17,ZIndex=3,Parent=up_40});up_41(a,8);up_42 (a.MouseEnter:Connect(function()up_43(a,0.15,{BackgroundColor3=H});end));up_42 (a.MouseLeave:Connect(function()up_43(a,0.15,{BackgroundColor3=e});end));return a;end  -- LEAKED BY STARLOXMELO
		local color = Color3.fromRGB
		local v = 205
		sliced89 = slicedfn47("×", -10, Color3.fromRGB(170, 62, 78), color(v, 78, 96))
		sliced90 = slicedfn47("—", -44, tbl22.Element, tbl22.ElementHover)
	end
end

do
	do
		slicedfn37("Frame", {
			Position = UDim2.fromOffset(0, topBarHeight),  -- LEAKED BY STARLOXMELO
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = tbl22.Stroke,
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			ZIndex = 3,
			Parent = Frame,
		})

		up_45 = nil
		slicedfn44 = function(B,I,e)local H=up_45 ;if H then up_45 =nil;if H.finish then H.finish(nil);end;end;up_45 ={move=B,finish=I,began=e};end

		do  -- LEAKED BY STARLOXMELO
			local inputChanged = UserInputService.InputChanged
			local connect2 = inputChanged.Connect
			up_45 = nil
			slicedfn31(connect2(inputChanged, function(B)local I=up_45 ;if I and(B.UserInputType==Enum.UserInputType.MouseMovement or B.UserInputType==Enum.UserInputType.Touch)then I.move(B);end;end))
		end
	end

	do
		local inputEnded = UserInputService.InputEnded
		local connect2 = inputEnded.Connect
		up_45 = nil  -- LEAKED BY STARLOXMELO
		slicedfn31(connect2(inputEnded, function(B)local I=up_45 ;if I and(B.UserInputType==Enum.UserInputType.MouseButton1 or B.UserInputType==Enum.UserInputType.Touch)then if I.began and B.UserInputType~=I.began then return;end;up_45 =nil;if I.finish then I.finish(B);end;end;end))
	end

	up_47 = slicedfn31
	up_48 = flag20
	up_49 = flag19
	up_50 = slicedfn44

	do
		local function slicedfn47(B,I)up_47 (I.InputBegan:Connect(function(I)if up_48 or up_49 then return;end;if I.UserInputType==Enum.UserInputType.MouseButton1 or I.UserInputType==Enum.UserInputType.Touch then local e=I.Position;local H=B.Position;up_50(function(w)local a=w.Position-e;B.Position=UDim2.new(H.X.Scale,H.X.Offset+a.X,H.Y.Scale,H.Y.Offset+a.Y);end,nil,I.UserInputType);end;end));end

		local Frame3 = slicedfn37("Frame", {
			Name = "DragZone",  -- LEAKED BY STARLOXMELO
			Size = UDim2.new(1, -270, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = Frame2,
		})

		slicedfn47(Frame, Frame3)
	end
end

local v, Frame2

do  -- LEAKED BY STARLOXMELO
	up_51 = slicedfn37
	up_52 = Frame
	up_53 = slicedfn39
	up_54 = tbl22
	up_55 = slicedfn31
	up_56 = flag20
	up_57 = flag19
	up_58 = slicedfn44
	up_59 = ScreenGui
	up_60 = minWindowSize  -- LEAKED BY STARLOXMELO
	up_3 = x2
	up_5 = y2
	up_4 = sliced84
	up_64 = slicedfn46
	up_65 = slicedfn30
	up_66 = sliced85
	up_67 = tbl23

	up_68 = slicedfn32
	;(function()local B,I=up_51("TextButton",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-2,1,-2),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,Text="",ZIndex=6,Parent=up_52}),{{-5,-5},{-5,-11},{-11,-5}};for e,e in ipairs(I)do up_53(up_51("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,e[1],1,e[2]),Size=UDim2.fromOffset(4,4),BackgroundColor3=up_54.TextDim,BackgroundTransparency=0.35,BorderSizePixel=0,ZIndex=6,Parent=B}),2);end;up_55 (B.InputBegan:Connect(function(B)if up_56 or up_57 then return;end;if B.UserInputType==Enum.UserInputType.MouseButton1 or B.UserInputType==Enum.UserInputType.Touch then local I=B.Position;local e=up_52.AbsoluteSize.X;local H=up_52.AbsoluteSize.Y;local a=up_52.Position;up_58(function(K)local L=K.Position-I;local I=up_59.AbsoluteSize;local A,P=math.clamp(e+L.X,up_60.X,math.max(up_60.X,I.X)),math.clamp(H+L.Y,up_60.Y,math.max(up_60.Y,I.Y));up_3 =A;up_5 =P;up_4 =up_64(A,P);I,K=up_65();up_52.Size=UDim2.fromOffset(I,K);up_66.Scale=up_4 ;up_52.Position=UDim2.new(a.X.Scale,a.X.Offset+(A-e)/2,a.Y.Scale,a.Y.Offset+(P-H)/2);end,function()up_67.WinSize={w=math.floor(up_3 ),h=math.floor(up_5 )};up_68 ();end,B.UserInputType);end;end));end)()

	do  -- LEAKED BY STARLOXMELO
		local Frame3 = slicedfn37("Frame", {
			Name = "Sidebar",
			Position = UDim2.fromOffset(0, topBarHeight + 1),
			Size = UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 1)),
			BackgroundColor3 = tbl22.Sidebar,
			BackgroundTransparency = 0.25,
			BorderSizePixel = 0,
			ZIndex = 2,
			Parent = Frame,
		})  -- LEAKED BY STARLOXMELO

		slicedfn39(Frame3, 12)

		slicedfn37("Frame", {
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
			BackgroundColor3 = tbl22.Stroke,
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			ZIndex = 3,
			Parent = Frame3,
		})  -- LEAKED BY STARLOXMELO

		v = slicedfn37("Frame", {
			Position = UDim2.fromOffset(0, 10),
			Size = UDim2.new(1, 0, 1, -30),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = Frame3,
		})

		slicedfn37("UIListLayout", {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,  -- LEAKED BY STARLOXMELO
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = v,
		})

		slicedfn39(slicedfn37("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 12, 1, -12),
			Size = UDim2.fromOffset(6, 6),
			BackgroundColor3 = tbl22.Accent,
			BorderSizePixel = 0,
			ZIndex = 3,  -- LEAKED BY STARLOXMELO
			Parent = Frame3,
		}), 3)

		slicedfn37("TextLabel", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 24, 1, -8),
			Size = UDim2.new(1, -30, 0, 14),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = localPlayer.DisplayName,
			TextColor3 = tbl22.Accent2,  -- LEAKED BY STARLOXMELO
			TextTransparency = 0.25,
			TextSize = 13,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 3,
			Parent = Frame3,
		})

		Frame2 = slicedfn37("Frame", {
			Name = "Indicator",
			Position = UDim2.fromOffset(0, 19),  -- LEAKED BY STARLOXMELO
			Size = UDim2.fromOffset(2, 16),
			BackgroundColor3 = tbl22.Accent,
			BorderSizePixel = 0,
			ZIndex = 4,
			Parent = Frame3,
		})
	end
end

slicedfn39(Frame2, 1)

do  -- LEAKED BY STARLOXMELO
	local Frame3 = slicedfn37("Frame", {
		Name = "Content",
		Position = UDim2.fromOffset(sidebarWidth + 1, topBarHeight + 1),
		Size = UDim2.new(1, -(sidebarWidth + 1), 1, -(topBarHeight + 1)),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 2,
		Parent = Frame,
	})

	local tbl26 = {}  -- LEAKED BY STARLOXMELO
	up_69 = nil
	up_70 = tbl26
	up_71 = slicedfn38
	up_72 = tbl22
	up_73 = Frame2
	slicedfn45 = function(B)if up_69 ==B then return;end;up_69 =B;for I,e in ipairs(up_70)do local H=I==B;e.page.Visible=H;up_71(e.button,0.2,{TextColor3=H and up_72.Accent or up_72.TextDim,BackgroundTransparency=H and 0.65 or 1});if H then e.page.Position=UDim2.fromOffset(10,8);up_71(e.page,0.25,{Position=UDim2.fromOffset(0,8)});up_71(up_73,0.25,{Position=UDim2.fromOffset(0,10+(I-1)*38+9)});end;end;end
	up_74 = tbl26
	up_75 = slicedfn37
	up_76 = tbl22
	up_77 = v  -- LEAKED BY STARLOXMELO
	up_78 = slicedfn39
	up_79 = Frame3
end

local slicedfn46, slicedfn47, slicedfn48, slicedfn49, slicedfn50, slicedfn51, slicedfn52, slicedfn53, slicedfn54, slicedfn55
local slicedfn56, slicedfn57, slicedfn58, slicedfn59, slicedfn60

do
	do
		local tbl26, tbl27, tbl28, tbl29, tbl30, tbl31, flag21, slicedfn61, slicedfn62, slicedfn63

		do
			local slicedfn64  -- LEAKED BY STARLOXMELO

			do
				up_80 = slicedfn31
				up_81 = nil
				up_82 = slicedfn38
				up_83 = slicedfn45
				slicedfn46 = function(B,I)I=I or{};local e=#up_74+1;local H=up_75("TextButton",{Name="Tab_"..B,Size=UDim2.new(1,-16,0,34),BackgroundColor3=up_76.Element,BackgroundTransparency=1,AutoButtonColor=false,Font=Enum.Font.GothamMedium,Text=B,TextColor3=up_76.TextDim,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=e,ZIndex=3,Parent=up_77});up_78(H,8);up_75("UIPadding",{PaddingLeft=UDim.new(0,12),Parent=H});local a=if I.scroll==false then(up_75("Frame",{Name="Page_"..B,Position=UDim2.fromOffset(0,8),Size=UDim2.new(1,-6,1,-16),BackgroundTransparency=1,ClipsDescendants=true,Visible=false,ZIndex=2,Parent=up_79}))else(up_75("ScrollingFrame",{Name="Page_"..B,Position=UDim2.fromOffset(0,8),Size=UDim2.new(1,-6,1,-16),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=up_76.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,ZIndex=2,Parent=up_79}));up_75("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=a});up_75("UIPadding",{PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14),PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,10),Parent=a});up_80 (H.MouseEnter:Connect(function()if up_81 ~=e then up_82(H,0.15,{TextColor3=up_76.Text});end;end));up_80 (H.MouseLeave:Connect(function()if up_81 ~=e then up_82(H,0.15,{TextColor3=up_76.TextDim});end;end));up_80 (H.MouseButton1Click:Connect(function()up_83(e);end));up_74[e]={button=H,page=a};return a;end
				slicedfn47 = function(w)local B=(w:GetAttribute("elemCount")or 0)+1;w:SetAttribute("elemCount",B);return B;end
				up_84 = slicedfn37
				up_85 = slicedfn47
				up_86 = tbl22  -- LEAKED BY STARLOXMELO
				slicedfn48 = function(B,I)local e=up_84("Frame",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,LayoutOrder=up_85(B),ZIndex=2,Parent=B});up_84("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=I,TextColor3=up_86.Accent2,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=e});up_84("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,-2),Size=UDim2.new(1,0,0,1),BackgroundColor3=up_86.Stroke,BackgroundTransparency=0.4,BorderSizePixel=0,ZIndex=2,Parent=e});return e;end
				up_87 = slicedfn37
				up_88 = tbl22
				up_89 = slicedfn47
				slicedfn49 = function(B,I)return up_87("TextLabel",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=I,TextColor3=up_88.TextDim,TextSize=15,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=up_89(B),ZIndex=2,Parent=B});end
				up_90 = tbl22
				up_91 = slicedfn37
				up_92 = slicedfn47
				up_93 = slicedfn39
				up_94 = slicedfn31  -- LEAKED BY STARLOXMELO
				up_95 = slicedfn38
				slicedfn50 = function(B,I,e,H)H=H or{};local a=H.baseColor or up_90.Element;local K=H.hoverColor or up_90.ElementHover;local L=H.flashColor or up_90.Accent;local A=up_91("TextButton",{Size=H.size or(UDim2.new(1,0,0,34)),BackgroundColor3=a,AutoButtonColor=false,Font=Enum.Font.GothamMedium,Text=I,TextColor3=H.textColor or up_90.Text,TextSize=16,LayoutOrder=H.layoutOrder or(up_92(B)),ZIndex=2,Parent=H.parent or B});up_93(A,8);local B=up_91("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=up_90.Stroke,Transparency=0.4,Thickness=1,Parent=A});local I=false;up_94 (A.MouseEnter:Connect(function()I=true;up_95(A,0.15,{BackgroundColor3=K});up_95(B,0.15,{Color=up_90.Accent,Transparency=0.45});end));up_94 (A.MouseLeave:Connect(function()I=false;up_95(A,0.15,{BackgroundColor3=a});up_95(B,0.15,{Color=up_90.Stroke,Transparency=0.4});end));up_94 (A.MouseButton1Click:Connect(function()up_95(A,0.08,{BackgroundColor3=L});task.delay(0.08,function()if A.Parent then up_95(A,0.25,{BackgroundColor3=I and K or a});end;end);if e then task.spawn(e);end;end));return A;end
				up_96 = slicedfn37
				up_97 = slicedfn47
				up_98 = slicedfn50
				slicedfn51 = function(B,I)local e=up_96("Frame",{Size=UDim2.new(1,0,0,34),BackgroundTransparency=1,LayoutOrder=up_97(B),ZIndex=2,Parent=B});up_96("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=e});local H,a=#I,{};for K,L in ipairs(I)do local I=up_98(B,L.text,L.callback,{parent=e,layoutOrder=K,size=UDim2.new(1/H,-(6*(H-1)/H),1,0),baseColor=L.baseColor,hoverColor=L.hoverColor,flashColor=L.flashColor,textColor=L.textColor});if L.rich then I.RichText=true;end;a[K]=I;end;return a;end
				up_99 = slicedfn37
				up_100 = tbl22
				up_101 = slicedfn47
				up_102 = slicedfn39  -- LEAKED BY STARLOXMELO
				up_103 = slicedfn38
				up_104 = slicedfn31
				slicedfn52 = function(B,I,e,H)local a=e and true or false;local e=up_99("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=up_100.Element,AutoButtonColor=false,Text="",LayoutOrder=up_101(B),ZIndex=2,Parent=B});up_102(e,8);up_99("TextLabel",{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-70,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=I,TextColor3=up_100.Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=e});local B=up_99("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(38,20),BackgroundColor3=a and up_100.Accent or up_100.SliderTrack,BorderSizePixel=0,ZIndex=2,Parent=e});up_102(B,10);local I=up_99("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=a and(UDim2.new(1,-18,0.5,0))or(UDim2.new(0,2,0.5,0)),Size=UDim2.fromOffset(16,16),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=2,Parent=B});up_102(I,8);local function K()up_103(I,0.18,{Position=a and(UDim2.new(1,-18,0.5,0))or(UDim2.new(0,2,0.5,0))},Enum.EasingStyle.Back);up_103(B,0.18,{BackgroundColor3=a and up_100.Accent or up_100.SliderTrack});end;up_104 (e.MouseEnter:Connect(function()up_103(e,0.15,{BackgroundColor3=up_100.ElementHover});end));up_104 (e.MouseLeave:Connect(function()up_103(e,0.15,{BackgroundColor3=up_100.Element});end));up_104 (e.MouseButton1Click:Connect(function()a=not a;K();if H then task.spawn(H,a);end;end));return e;end
				up_105 = slicedfn37
				up_106 = tbl22
				up_107 = slicedfn47
				up_108 = slicedfn39
				up_109 = slicedfn38
				up_110 = slicedfn31
				slicedfn53 = function(B,I,e,H,a,K)local L,A=tonumber((K or{}).chipWidth)or 98,1;for K,P in ipairs(e)do if P.value==H then A=K;break;end;end;local H=up_105("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=up_106.Element,AutoButtonColor=false,Text="",LayoutOrder=up_107(B),ZIndex=2,Parent=B});up_108(H,8);up_105("TextLabel",{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-(L+20),1,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=I,TextColor3=up_106.Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=H});local B=up_105("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.5,0),Size=UDim2.fromOffset(L,24),BackgroundColor3=e[A].color:Lerp(up_106.Element,0.82),AutoButtonColor=false,Font=Enum.Font.GothamBold,Text=e[A].label,TextColor3=e[A].color:Lerp(up_106.Text,0.5),TextSize=13,ZIndex=3,Parent=H});up_108(B,7);local I=up_105("UIStroke",{Color=e[A].color:Lerp(up_106.Stroke,0.55),Transparency=0.4,Thickness=1,Parent=B});local function K()local L=e[A];B.Text=L.label;up_109(B,0.15,{BackgroundColor3=L.color:Lerp(up_106.Element,0.82),TextColor3=L.color:Lerp(up_106.Text,0.5)});up_109(I,0.15,{Color=L.color:Lerp(up_106.Stroke,0.55)});end;local function I()A=A%#e+1;K();if a then task.spawn(a,e[A].value);end;end;up_110 (H.MouseEnter:Connect(function()up_109(H,0.15,{BackgroundColor3=up_106.ElementHover});end));up_110 (H.MouseLeave:Connect(function()up_109(H,0.15,{BackgroundColor3=up_106.Element});end));up_110 (H.MouseButton1Click:Connect(I));up_110 (B.MouseButton1Click:Connect(I));return H;end  -- LEAKED BY STARLOXMELO
				up_111 = slicedfn37
				up_112 = tbl22
				up_113 = slicedfn47
				up_114 = slicedfn39
				up_115 = slicedfn31
				up_116 = slicedfn44
				slicedfn54 = function(B,I,e,H,a,K,L)L=L or{};local A=L.decimals or 0;local P=10^A;local function v(N)return math.floor(N*P+0.5)/P;end;local function P(N)if A>0 then return string.format("%."..A.."f",N);end;return tostring(N);end;local A;if L.uncapped then A=v(math.max(e,a or e));else A=v(math.clamp(a or e,e,H));end;a=up_111("Frame",{Size=L.size or(UDim2.new(1,0,0,52)),BackgroundColor3=up_112.Element,BorderSizePixel=0,LayoutOrder=L.layoutOrder or(up_113(B)),ZIndex=2,Parent=L.parent or B});up_114(a,8);up_111("TextLabel",{Position=UDim2.fromOffset(12,6),Size=UDim2.new(1,-80,0,18),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=I,TextColor3=up_112.Text,TextSize=16,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=a});local B=up_111("TextBox",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-10,0,5),Size=UDim2.fromOffset(58,20),BackgroundColor3=up_112.SliderTrack,BackgroundTransparency=0.25,ClearTextOnFocus=false,Font=Enum.Font.GothamBold,Text=P(A),TextColor3=up_112.Accent2,TextSize=16,TextXAlignment=Enum.TextXAlignment.Center,ClipsDescendants=true,ZIndex=3,Parent=a});up_114(B,6);up_111("UIStroke",{Color=up_112.Stroke,Transparency=0.5,Thickness=1,Parent=B});local N=up_111("Frame",{Position=UDim2.new(0,12,0,34),Size=UDim2.new(1,-24,0,6),BackgroundColor3=up_112.SliderTrack,BorderSizePixel=0,ZIndex=2,Parent=a});up_114(N,3);I=H>e and(math.clamp((A-e)/(H-e),0,1))or 0;local S=up_111("Frame",{Size=UDim2.new(I,0,1,0),BackgroundColor3=up_112.Accent,BorderSizePixel=0,ZIndex=2,Parent=N});up_114(S,3);local j=up_111("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(I,0,0.5,0),Size=UDim2.fromOffset(12,12),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=3,Parent=N});up_114(j,6);I=up_111("TextButton",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text="",ZIndex=4,Parent=N});local function p(W)local r=math.clamp((W.X-N.AbsolutePosition.X)/math.max(N.AbsoluteSize.X,1),0,1);W=v(e+(H-e)*r);S.Size=UDim2.new(r,0,1,0);j.Position=UDim2.new(r,0,0.5,0);if W~=A then A=W;B.Text=P(A);if K then task.spawn(K,A);end;end;end;local function N(W)W=tonumber(W);if not W then B.Text=P(A);return;end;W=v(W);W=if L.uncapped then(math.max(e,W))else(math.clamp(W,e,H));local L=H>e and(math.clamp((W-e)/(H-e),0,1))or 0;S.Size=UDim2.new(L,0,1,0);j.Position=UDim2.new(L,0,0.5,0);B.Text=P(W);if W~=A then A=W;if K then task.spawn(K,A);end;end;end;up_115 (B.FocusLost:Connect(function()N(B.Text);end));up_115 (I.InputBegan:Connect(function(B)if B.UserInputType==Enum.UserInputType.MouseButton1 or B.UserInputType==Enum.UserInputType.Touch then p(B.Position);up_116(function(w)p(w.Position);end,nil,B.UserInputType);end;end));return a;end
				up_117 = slicedfn37
				up_118 = tbl22
				up_119 = slicedfn47  -- LEAKED BY STARLOXMELO
				up_120 = slicedfn39
				up_121 = slicedfn31
				slicedfn55 = function(B,I,e)local H=up_117("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=up_118.Element,BorderSizePixel=0,LayoutOrder=up_119(B),ZIndex=2,Parent=B});up_120(H,8);up_117("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=up_118.Stroke,Transparency=0.4,Thickness=1,Parent=H});local B=up_117("TextBox",{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-24,1,0),BackgroundTransparency=1,ClearTextOnFocus=false,Font=Enum.Font.Gotham,PlaceholderText=I,PlaceholderColor3=up_118.TextDim,Text="",TextColor3=up_118.Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=H});up_121 (B.FocusLost:Connect(function(w)if e then task.spawn(e,B.Text,w,B);end;end));return H,B;end
				tbl26 = {}
				tbl27 = {}
				tbl28 = {}
				tbl29 = {}
				tbl30 = {}
				tbl31 = { 15, 60, 300 }
				flag21 = false  -- LEAKED BY STARLOXMELO

				pcall(function()
					if makefolder and isfolder then
						if not isfolder("KaWaifu_Icons") then
							makefolder("KaWaifu_Icons")
						end

						flag21 = isfolder("KaWaifu_Icons") == true
					end
				end)

				slicedfn61 = function(arg)
					return "KWImg_" .. tostring(arg):gsub("[^%w]", "_") .. ".png"  -- LEAKED BY STARLOXMELO
				end

				slicedfn62 = function(arg)
					local v = slicedfn61(arg)
					if flag21 then
						return "KaWaifu_Icons" .. "/" .. v
					end
					return v
				end

				do
					local band = bit32.band  -- LEAKED BY STARLOXMELO
					local bor = bit32.bor
					local bxor = bit32.bxor
					local bnot = bit32.bnot
					local lrotate = bit32.lrotate
					local rshift = bit32.rshift

					local tbl32 = {
						3614090360,
						3905402710,
						606105819,
						3250441966,  -- LEAKED BY STARLOXMELO
						4118548399,
						1200080426,
						2821735955,
						4249261313,
						1770035416,
						2336552879,
						4294925233,
						2304563134,
						1804603682,
						4254626195,  -- LEAKED BY STARLOXMELO
						2792965006,
						1236535329,
						4129170786,
						3225465664,
						643717713,
						3921069994,
						3593408605,
						38016083,
						3634488961,
						3889429448,  -- LEAKED BY STARLOXMELO
						568446438,
						3275163606,
						4107603335,
						1163531501,
						2850285829,
						4243563512,
						1735328473,
						2368359562,
						4294588738,
						2272392833,  -- LEAKED BY STARLOXMELO
						1839030562,
						4259657740,
						2763975236,
						1272893353,
						4139469664,
						3200236656,
						681279174,
						3936430074,
						3572445317,
						76029189,  -- LEAKED BY STARLOXMELO
						3654602809,
						3873151461,
						530742520,
						3299628645,
						4096336452,
						1126891415,
						2878612391,
						4237533241,
						1700485571,
						2399980690,  -- LEAKED BY STARLOXMELO
						4293915773,
						2240044497,
						1873313359,
						4264355552,
						2734768916,
						1309151649,
						4149444226,
						3174756917,
						718787259,
						3951481745,  -- LEAKED BY STARLOXMELO
					}

					local tbl33 = {
						7,
						12,
						17,
						22,
						7,
						12,
						17,
						22,  -- LEAKED BY STARLOXMELO
						7,
						12,
						17,
						22,
						7,
						12,
						17,
						22,
						5,
						9,  -- LEAKED BY STARLOXMELO
						14,
						20,
						5,
						9,
						14,
						20,
						5,
						9,
						14,
						20,  -- LEAKED BY STARLOXMELO
						5,
						9,
						14,
						20,
						4,
						11,
						16,
						23,
						4,
						11,  -- LEAKED BY STARLOXMELO
						16,
						23,
						4,
						11,
						16,
						23,
						4,
						11,
						16,
						23,  -- LEAKED BY STARLOXMELO
						6,
						10,
						15,
						21,
						6,
						10,
						15,
						21,
						6,
						10,  -- LEAKED BY STARLOXMELO
						15,
						21,
						6,
						10,
						15,
						21,
					}

					slicedfn64 = function(arg)
						local n = 1732584193
						local slicedn33 = #arg  -- LEAKED BY STARLOXMELO
						local str10 = arg .. "\128"

						while #str10 % 64 ~= 56 do
							str10 ..= "\0"
						end

						local slicedn34 = slicedn33 * 8

						for i = 0, 7 do
							str10 ..= string.char(math.floor(slicedn34 / 256 ^ i) % 256)
						end

						local slicedn35 = 4023233417
						local slicedn36 = 2562383102  -- LEAKED BY STARLOXMELO
						local slicedn37 = 271733878

						for i = 1, #str10, 64 do
							local tbl34 = {}

							for i2 = 0, 15 do
								local slicedn38 = i + i2 * 4
								local v, sliced91, sliced92, sliced93 = string.byte(str10, slicedn38, slicedn38 + 3)
								tbl34[i2] = v + sliced91 * 256 + sliced92 * 65536 + sliced93 * 16777216
							end

							local slicedn38 = slicedn35
							local v = slicedn36  -- LEAKED BY STARLOXMELO
							local sliced91 = slicedn37
							local sliced92 = n

							for i2 = 0, 63 do
								local sliced93, slicedn39

								if i2 < 16 then
									sliced93 = bor(band(slicedn38, v), band(bnot(slicedn38), sliced91))
									slicedn39 = i2
								elseif i2 < 32 then
									sliced93 = bor(band(sliced91, slicedn38), band(bnot(sliced91), v))
									slicedn39 = (5 * i2 + 1) % 16  -- LEAKED BY STARLOXMELO
								elseif i2 < 48 then
									sliced93 = bxor(slicedn38, v, sliced91)
									slicedn39 = (3 * i2 + 5) % 16
								else
									sliced93 = bxor(v, bor(slicedn38, bnot(sliced91)))
									slicedn39 = 7 * i2 % 16
								end

								local slicedn40 = (sliced93 + sliced92 + tbl32[i2 + 1] + tbl34[slicedn39]) % 4294967296
								local sliced94 = 4294967296
								sliced92 = sliced91  -- LEAKED BY STARLOXMELO
								sliced91 = v
								v = slicedn38
								slicedn38 = (slicedn38 + lrotate(slicedn40, tbl33[i2 + 1])) % sliced94
							end

							n = (n + sliced92) % 4294967296
							slicedn35 = (slicedn35 + slicedn38) % 4294967296
							slicedn36 = (slicedn36 + v) % 4294967296
							slicedn37 = (slicedn37 + sliced91) % 4294967296
						end

						local function slicedfn65(arg2)  -- LEAKED BY STARLOXMELO
							return string.format("%02x%02x%02x%02x", arg2 % 256, rshift(arg2, 8) % 256, rshift(arg2, 16) % 256, rshift(arg2, 24) % 256)
						end

						return slicedfn65(n) .. slicedfn65(slicedn35) .. slicedfn65(slicedn36) .. slicedfn65(slicedn37)
					end
				end
			end

			do
				local function slicedfn65(arg)
					return tostring(arg):gsub("%s+", "_") .. ".png"
				end  -- LEAKED BY STARLOXMELO

				local function slicedfn66(arg)
					local str10 = tostring(arg):gsub("%s+", "_")
					local str11

					if #str10 > 1 then
						str11 = str10:sub(1, 1) .. str10:sub(2):lower()
					else
						str11 = str10
					end

					return str11 .. ".png"
				end  -- LEAKED BY STARLOXMELO

				local function slicedfn67(arg)
					local v = slicedfn64(arg)
					return ("https://static.wikia.nocookie.net/%s/images/%s/%s/%s"):format("stealabr", v:sub(1, 1), v:sub(1, 2), arg)
				end

				local function slicedfn68(arg)
					if type(arg) ~= "string" or not arg:find("static%.wikia%.nocookie%.net") then
						return arg
					end

					if arg:find("/revision/") then

						return arg .. (arg:find("?", 1, true) and "&format=original" or "?format=original")  -- LEAKED BY STARLOXMELO
					end

					return arg .. "/revision/latest?format=original"
				end

				local function slicedfn69(arg)
					if true then
						local str10 = "https://stealabrainrot.fandom.com/api.php?action=query&prop=pageimages" .. "&piprop=thumbnail&pithumbsize=256&format=json&redirects=1&titles=" .. service:UrlEncode(tostring(arg))

						local ok, result = pcall(function()
							if true then
								return game:HttpGet(str10)
							end  -- LEAKED BY STARLOXMELO

						end)

						if not ok or type(result) ~= "string" or result == "" then
							return nil
						end

						local ok2, result2 = pcall(function()
							return service:JSONDecode(result)
						end)

						local flag22 = not ok2

						if not flag22 then
							local v = "table"  -- LEAKED BY STARLOXMELO
							flag22 = type(result2) ~= v
						end

						if flag22 then
							return nil
						end
						local pages = result2.query and result2.query.pages
						if type(pages) ~= "table" then
							return nil
						end

						for _, page in pairs(pages) do  -- LEAKED BY STARLOXMELO
							local v = "table"
							local flag23 = type(page) == v

							if flag23 then
								local sliced91 = "table"
								flag23 = type(page.thumbnail) == sliced91
							end

							if flag23 and type(page.thumbnail.source) == "string" and page.thumbnail.source ~= "" then
								return slicedfn68(page.thumbnail.source)
							end
						end  -- LEAKED BY STARLOXMELO

						return nil
					end

				end

				slicedfn63 = function(arg)
					local tbl32 = {}
					local v = slicedfn69(arg)

					if v then
						tbl32[#tbl32 + 1] = v
					end

					tbl32[#tbl32 + 1] = slicedfn68(slicedfn67(slicedfn65(arg)))  -- LEAKED BY STARLOXMELO
					local sliced91 = slicedfn66(arg)

					if sliced91 ~= slicedfn65(arg) then
						tbl32[#tbl32 + 1] = slicedfn68(slicedfn67(sliced91))
					end

					return tbl32
				end
			end
		end

		do
			local slicedfn64, slicedfn65, slicedfn66, slicedfn67  -- LEAKED BY STARLOXMELO

			do
				slicedfn64 = function(arg)

					if type(arg) ~= "string" or #arg < 16 then
						return false
					end

					local v, sliced91, sliced92, sliced93 = string.byte(arg, 1, 4)
					if v == 137 and sliced91 == 80 and sliced92 == 78 and sliced93 == 71 then
						return true
					end

					if v == 255 and sliced91 == 216 and sliced92 == 255 then  -- LEAKED BY STARLOXMELO
						return true
					end
					return false
				end

				slicedfn56 = function(arg)
					if not arg or arg == "" then
						return nil
					end

					if tbl26[arg] then
						return tbl26[arg]  -- LEAKED BY STARLOXMELO
					end
					local v = tbl27[arg]
					if v then
						return v
					end
					local brainrotImageResolver = tbl25.brainrotImageResolver

					if brainrotImageResolver then
						local ok, result = pcall(brainrotImageResolver, arg)
						if ok and type(result) == "string" and result ~= "" then
							return result  -- LEAKED BY STARLOXMELO
						end
					end

					return nil
				end

				slicedfn65 = function(arg)
					local v = nil

					pcall(function()
						if getcustomasset then
							v = getcustomasset(arg)

						elseif getsynasset then  -- LEAKED BY STARLOXMELO
							v = getsynasset(arg)
						end
					end)

					if type(v) == "string" and v ~= "" then
						return v
					end
					return nil
				end

				slicedfn66 = function(arg)
					if true then  -- LEAKED BY STARLOXMELO
						local ok, result = pcall(readfile, arg)
						return ok and slicedfn64(result)
					end

				end

				do
					local function slicedfn68(arg)
						local n = #tbl31
						return tbl31[math.min(math.max(arg, 1), n)]
					end

					slicedfn67 = function(arg)  -- LEAKED BY STARLOXMELO
						local v = tbl28[arg]
						if not v then
							return false
						end
						return os.clock() - (v.ts or 0) < slicedfn68(v.attempts or 1)
					end
				end
			end

			do
				local function slicedfn68(arg)  -- LEAKED BY STARLOXMELO
					if true then
						local v = slicedfn62(arg)

						if flag21 then
							local sliced91 = 6085

							if true then
								local sliced92 = slicedfn61(arg)

								pcall(function()
									if isfile and isfile(sliced92) and not isfile(v) then
										if slicedfn66(sliced92) then
											writefile(v, readfile(sliced92))  -- LEAKED BY STARLOXMELO
										end

										if delfile then
											pcall(delfile, sliced92)
										end
									end
								end)
							end
						end

						if isfile and isfile(v) then
							if slicedfn66(v) then  -- LEAKED BY STARLOXMELO
								local sliced91 = slicedfn65(v)

								if sliced91 then
									local sliced92 = 7407
									if true then
										return sliced91
									end

								end
							elseif delfile then
								pcall(delfile, v)
							end  -- LEAKED BY STARLOXMELO
						end

						for _, sliced91 in ipairs(slicedfn63(arg)) do
							local ok, result = pcall(function()
								return game:HttpGet(sliced91)
							end)

							if ok and slicedfn64(result) then
								if pcall(function()
									writefile(v, result)
								end) then
									local sliced92 = slicedfn65(v)  -- LEAKED BY STARLOXMELO
									if sliced92 then
										return sliced92
									end
								end
							end
						end

						return nil
					end

				end

				slicedfn57 = function(arg, arg2)  -- LEAKED BY STARLOXMELO
					if true then
						if not arg or arg == "" then
							return
						end
						local v = tbl27[arg]

						if v then
							if arg2 then
								arg2(v)
							end

							return  -- LEAKED BY STARLOXMELO
						end

						if tbl29[arg] then
							if arg2 then
								local tbl32 = tbl30[arg]

								if not tbl32 then
									tbl32 = {}
									tbl30[arg] = tbl32
								end

								tbl32[#tbl32 + 1] = arg2
							end  -- LEAKED BY STARLOXMELO

							return
						end

						if slicedfn67(arg) then
							return
						end
						tbl29[arg] = true

						task.spawn(function()
							task.wait()

							if tbl27[arg] then
								tbl29[arg] = nil  -- LEAKED BY STARLOXMELO
								local sliced91 = tbl27[arg]

								if arg2 then
									arg2(sliced91)
								end

								local sliced92 = tbl30[arg]
								tbl30[arg] = nil

								if sliced92 then
									for _, sliced93 in ipairs(sliced92) do
										pcall(sliced93, sliced91)
									end  -- LEAKED BY STARLOXMELO
								end

								return
							end

							local ok, result = pcall(slicedfn68, arg)

							if not ok then
								result = nil
							end

							tbl29[arg] = nil
							local sliced91 = tbl30[arg]
							tbl30[arg] = nil  -- LEAKED BY STARLOXMELO

							if result then
								if true then
									tbl27[arg] = result
									tbl28[arg] = nil

									if arg2 then
										arg2(result)

									end

									if sliced91 then
										for _, sliced92 in ipairs(sliced91) do
											pcall(sliced92, result)  -- LEAKED BY STARLOXMELO
										end
									end
								end
							else
								local tbl32 = tbl28[arg] or { attempts = 0 }
								tbl32.attempts = (tbl32.attempts or 0) + 1
								tbl32.ts = os.clock()
								tbl28[arg] = tbl32
							end
						end)  -- LEAKED BY STARLOXMELO

						return
					end

				end
			end

			slicedfn58 = function(arg)
				if not (listfiles and delfile) then
					return
				end

				if type(arg) ~= "table" or #arg < 25 then
					return  -- LEAKED BY STARLOXMELO
				end
				local tbl32 = {}

				for _, v in ipairs(arg) do
					tbl32[slicedfn61(v)] = true
				end

				local function slicedfn68(arg2)
					return tostring(arg2):match("([^/\\]+)$") or tostring(arg2)
				end

				local function slicedfn69(arg2)
					return arg2:sub(1, 6) == "KWImg_" and arg2:sub(-4) == ".png"  -- LEAKED BY STARLOXMELO
				end

				if flag21 then
					pcall(function()
						for _, v in ipairs(listfiles("KaWaifu_Icons")) do
							local sliced91 = slicedfn68(v)

							if slicedfn69(sliced91) and not tbl32[sliced91] then
								pcall(delfile, v)
							end
						end
					end)  -- LEAKED BY STARLOXMELO
				end

				pcall(function()
					for _, v in ipairs(listfiles("")) do
						local sliced91 = slicedfn68(v)

						if slicedfn69(sliced91) and sliced91 == v:gsub("[/\\]", "") then
							if not tbl32[sliced91] then
								pcall(delfile, v)
							elseif flag21 then
								pcall(function()
									local str10 = "KaWaifu_Icons" .. "/" .. sliced91  -- LEAKED BY STARLOXMELO

									if not (isfile and isfile(str10)) and slicedfn66(v) then
										writefile(str10, readfile(v))
									end

									pcall(delfile, v)
								end)
							end
						end
					end
				end)
			end  -- LEAKED BY STARLOXMELO
		end
	end

	do
		local tbl26 = {}
		local v = pairs
		local rarityColors = tbl17.RarityColors or {}

		for k, rarityColor in v(rarityColors) do
			local ok, result = pcall(Color3.fromHex, rarityColor)

			if ok then
				tbl26[k] = result  -- LEAKED BY STARLOXMELO
			else
				warn("[KaWaifu] TUNING.RarityColors." .. tostring(k) .. " = " .. tostring(rarityColor) .. " is not a valid hex colour — it will use the Default colour")
			end
		end

		slicedfn59 = function(w)return string.format("#%02X%02X%02X",math.floor(w.R*255+0.5),math.floor(w.G*255+0.5),math.floor(w.B*255+0.5));end
		up_122 = tbl25
		up_123 = slicedfn59
		up_124 = tbl22
		slicedfn60 = function(B)local I=up_122.mutationHexResolver;if I then local e,H=pcall(I,B);if e and type(H)=="string"and H:sub(1,1)=="#"then return H;end;end;return up_123(up_124.Accent2);end
		up_125 = tbl17  -- LEAKED BY STARLOXMELO
		up_126 = slicedfn59
		up_127 = tbl22
		up_128 = tbl25
		up_129 = slicedfn38
		up_130 = flag18
		up_131 = Frame
		up_132 = slicedfn37
		up_133 = slicedfn39
		up_134 = slicedfn60
		up_135 = tbl26  -- LEAKED BY STARLOXMELO
	end
end

local slicedfn61, sliced91, sliced92, n, slicedn33, sliced93, sliced94, sliced95, slicedfn62

do
	do
		local Frame2

		do
			do
				do
					up_136 = slicedfn56  -- LEAKED BY STARLOXMELO
					up_137 = slicedfn57
					up_138 = ScreenGui
					up_139 = splitView
					slicedfn61 = function(B,I)local e=up_125.ExpandRowHeight;local H=up_125.ExpandRowGap;local a={};local K=0;local L=up_126(up_127.Accent);local function A(P,v,N,S,j)return("%s   |   <font color=\"%s\">%s</font>   |   <font color=\"%s\">%s</font>%s"):format(P,N,v,L,S,j or"");end;local function L(P,v,N)return Color3.new(P.R+(v.R-P.R)*N,P.G+(v.G-P.G)*N,P.B+(v.B-P.B)*N);end;local function P(v)local N;if v.joining then N="joining";else local S=up_128.joinStatusResolver;if S and v.jobId then local j,p=pcall(S,v.jobId);N=if j then p else N;end;end;if N==v.lastStatus then return;end;v.lastStatus=N;if N=="joining"then v.accentBar.BackgroundColor3=up_127.Warn;v.row.BackgroundColor3=L(up_127.Element,up_127.Warn,0.14);elseif N=="joined"then v.accentBar.BackgroundColor3=up_127.Good;v.row.BackgroundColor3=L(up_127.Element,up_127.Good,0.14);elseif N=="failed"then v.accentBar.BackgroundColor3=up_127.Bad;v.row.BackgroundColor3=L(up_127.Element,up_127.Bad,0.14);else v.accentBar.BackgroundColor3=v.barBase or up_127.Accent;v.row.BackgroundColor3=up_127.Element;end;v.iconHolder.BackgroundColor3=v.row.BackgroundColor3;end;local v,N,S;local function j(p,W,r)local s=p.joinBtn;if W then if s then local y=W.."/"..(r or"?");s.TextSize=#y>6 and 11 or#y>4 and 13 or 15;s.Text=y;if not p.joining then s:SetAttribute("joining",true);up_129(s,0.15,{BackgroundColor3=up_127.Warn});end;end;if not p.joining then p.joining=true;P(p);end;elseif p.joining then p.joining=nil;if s then s:SetAttribute("joining",nil);s.TextSize=15;s.Text="JOIN";up_129(s,0.15,{BackgroundColor3=up_127.Good});end;P(p);end;end;local function p(W,r,s)if not up_130 or not W then return;end;if v and v~=W then for y,y in ipairs(a)do if y.jobId==v then j(y,nil);end;end;end;v,N,S=W,r,s;for y,y in ipairs(a)do if y.jobId==W then j(y,r,s);end;end;end;local function W(r)if not up_130 or not r then return;end;for s,s in ipairs(a)do if s.jobId==r then j(s,nil);end;end;if v==r then v,N,S=nil,nil,nil;end;end;local function r(s)for y,y in ipairs(a)do if y.jobId==s then return y.name;end;end;return nil;end;local function s(y)local h=up_128.jobElapsedResolver;if h and y.jobId then local _,o=pcall(h,y.jobId);if _ and type(o)=="number"then return o;end;end;return os.clock()-y.t0;end;task.spawn(function()while up_130 do local y=up_131.Visible;for h=#a,1,-1 do local _=a[h];if _.row.Parent then if y then local y=math.floor(s(_));if y~=_.lastElapsedSec then _.lastElapsedSec=y;_.line2.Text=A(tostring(y).."s",_.mutation,_.mutHex,_.earn,_.carpetTag);end;end;P(_);if _.lastStatus=="cleared"then _.row:Destroy();table.remove(a,h);end;end;end;task.wait(1);end;end);local function y(h)local _=up_132("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0,24),Size=UDim2.fromOffset(56,28),BackgroundColor3=up_127.Good,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="JOIN",TextColor3=Color3.fromRGB(16,24,18),TextSize=15,ZIndex=3,Parent=h});up_133(_,6);_.MouseEnter:Connect(function()if not _:GetAttribute("joining")then up_129(_,0.12,{BackgroundColor3=Color3.fromRGB(130,215,158)});end;end);_.MouseLeave:Connect(function()if not _:GetAttribute("joining")then up_129(_,0.12,{BackgroundColor3=up_127.Good});end;end);return _;end;local function h(_,o,E)local R=E.mutation and tostring(E.mutation)~=""and(tostring(E.mutation))or"Normal";local J=up_134(R);local l=up_132("Frame",{Size=UDim2.new(1,0,0,e),BackgroundColor3=L(up_127.Element,up_127.Background,0.45),BorderSizePixel=0,LayoutOrder=o,ZIndex=2,Parent=_});up_133(l,6);up_132("Frame",{Position=UDim2.fromOffset(10,8),Size=UDim2.new(0,2,1,-16),BackgroundColor3=E.rarity and up_135[E.rarity]or up_135.Default or up_127.Accent,BackgroundTransparency=0.45,BorderSizePixel=0,ZIndex=2,Parent=l});_=up_132("Frame",{Position=UDim2.fromOffset(20,7),Size=UDim2.fromOffset(26,26),BackgroundColor3=L(up_127.Element,up_127.Background,0.45),BorderSizePixel=0,ClipsDescendants=true,ZIndex=2,Parent=l});up_133(_,7);local o,T=up_132("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="",ScaleType=Enum.ScaleType.Crop,ZIndex=3,Parent=_}),up_132("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=(E.name or"?"):sub(1,1):upper(),TextColor3=up_127.Accent,TextSize=15,ZIndex=2,Parent=_});_=up_136 (E.name);if _ then o.Image=_;T.Visible=false;else up_137 (E.name,function(_)if o:IsDescendantOf(up_138)then o.Image=_;T.Visible=false;end;end);end;up_132("TextLabel",{Position=UDim2.fromOffset(54,4),Size=UDim2.new(1,-66,0,16),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=E.name or"?",TextColor3=up_127.Text,TextSize=14,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=l});up_132("TextLabel",{Position=UDim2.fromOffset(54,20),Size=UDim2.new(1,-66,0,14),BackgroundTransparency=1,RichText=true,Font=Enum.Font.GothamMedium,Text=("%s   \194\183   <font color=\"%s\">%s</font>"):format(E.gen or"",J,R),TextColor3=up_127.TextDim,TextSize=12,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=l});return l;end;local function _(o,E,R,J,l,T,d,M)if not up_130 then return;end;K+=1;local C=d~=nil and#d>1;local V=100000-K;local F=up_128.jobElapsedResolver;if F and J then local U,q=pcall(F,J);V=if U and type(q)=="number"then(math.floor((q-os.clock())*100))else V;end;local U=up_132("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=up_127.Element,BorderSizePixel=0,ClipsDescendants=C,LayoutOrder=V,ZIndex=2,Parent=B});up_133(U,8);V=E and up_135[E]or up_135.Default or up_127.Accent;F=up_132("Frame",{Position=UDim2.fromOffset(0,8),Size=UDim2.new(0,3,0,32),BackgroundColor3=V,BorderSizePixel=0,ZIndex=2,Parent=U});up_133(F,2);local B=up_132("Frame",{Position=UDim2.fromOffset(10,7),Size=UDim2.fromOffset(34,34),BackgroundColor3=up_127.Element,BorderSizePixel=0,ClipsDescendants=true,ZIndex=2,Parent=U});up_133(B,8);local q,m=up_132("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="",ScaleType=Enum.ScaleType.Crop,ZIndex=3,Parent=B}),up_132("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=(o or"?"):sub(1,1):upper(),TextColor3=up_127.Accent,TextSize=21,ZIndex=2,Parent=B});local Q=up_136 (o);if Q then q.Image=Q;m.Visible=false;else up_137 (o,function(c)if q:IsDescendantOf(up_138)then q.Image=c;m.Visible=false;end;end);end;local q=l and tostring(l)~=""and(tostring(l))or"Normal";local m,c,g=up_134(q),R or"",M and"   "or"";up_132("TextLabel",{Position=UDim2.fromOffset(52,6),Size=UDim2.new(1,-80,0,20),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=o,TextColor3=up_127.Text,TextSize=16,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=U});l,Q=up_132("TextLabel",{Position=UDim2.fromOffset(52,26),Size=UDim2.new(1,-80,0,16),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,RichText=true,Text=A("0s",q,m,c,g),TextColor3=up_127.TextDim,TextSize=14,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=U}),y(U);Q.MouseButton1Click:Connect(function()if I then task.spawn(I,o,E,R,J,T);end;end);if C then local I=#d-1;local A,y=4+(I*e+(I-1)*H)+6,up_125.ExpandBarHeight;local e,E=48+y,48+A+y;U.Size=UDim2.new(1,0,0,e);M=L(up_127.Element,up_127.Background,0.35);up_132("Frame",{Position=UDim2.new(0,12,0,48),Size=UDim2.new(1,-24,0,1),BackgroundColor3=up_127.Stroke,BackgroundTransparency=0.4,BorderSizePixel=0,ZIndex=4,Parent=U});local L=up_132("Frame",{Position=UDim2.fromOffset(0,48),Size=UDim2.new(1,0,0,A),BackgroundTransparency=1,ZIndex=2,Parent=U});up_132("UIListLayout",{Padding=UDim.new(0,H),SortOrder=Enum.SortOrder.LayoutOrder,Parent=L});up_132("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),Parent=L});for H=2,#d,1 do h(L,H,d[H]);end;A=up_132("TextButton",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,y),BackgroundColor3=M,AutoButtonColor=false,Text="",BorderSizePixel=0,ZIndex=3,Parent=U});up_133(A,8);up_132("Frame",{Size=UDim2.new(1,0,0,y/2),BackgroundColor3=M,BorderSizePixel=0,ZIndex=3,Parent=A});local H,L=up_132("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text="+"..I.." more on this server    v",TextColor3=up_127.Accent2,TextSize=12,ZIndex=4,Parent=A}),false;local function h(R)if R==L then return;end;L=R;up_129(U,0.24,{Size=UDim2.new(1,0,0,R and E or e)},Enum.EasingStyle.Quad,R and Enum.EasingDirection.Out or Enum.EasingDirection.In);H.Text=R and"show less    ^"or"+"..I.." more on this server    v";end;A.MouseButton1Click:Connect(function()h(not L);end);local I=up_132("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Parent=U});up_133(I,8);y=up_132("TextButton",{Size=UDim2.new(1,0,0,48),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=2,Parent=U});y.MouseButton1Click:Connect(function()h(not L);end);y.MouseEnter:Connect(function()up_129(I,0.12,{BackgroundTransparency=0.93});end);y.MouseLeave:Connect(function()up_129(I,0.12,{BackgroundTransparency=1});end);end;d={row=U,line2=l,accentBar=F,iconHolder=B,joinBtn=Q,name=o,jobId=J,barBase=V,mutation=q,mutHex=m,earn=c,carpetTag=g,t0=os.clock()};table.insert(a,d);P(d);if J~=nil and J==v then j(d,N,S);end;while#a>up_125.FeedMaxRows do C=1;for B=2,#a,1 do C=if a[B].row.LayoutOrder>a[C].row.LayoutOrder then B else C;end;table.remove(a,C).row:Destroy();end;return U;end;return function(B,I,e,H,L,A)if not up_130 then return;end;local P=nil;local j=up_128.jobAnimalsResolver;if j and H then local y,h=pcall(j,H);P=if y and type(h)=="table"then h else P;end;if up_139 and P and#P>1 then j=nil;for y,y in ipairs(P)do j=j or _(y.name,y.rarity,y.gen,H,y.mutation,y.idx,nil,y.carpet);end;return j;end;return _(B,I,e,H,L,nil,not up_139 and P and#P>1 and P or nil,A);end,function(B)if not B then return;end;for I=#a,1,-1 do if a[I].jobId==B then a[I].row:Destroy();table.remove(a,I);end;end;end,function(B)B=tonumber(B)or 0;local I,e,H=up_128.markClearedResolver,up_128.joinStatusResolver,0;for w=#a,1,-1 do local L=a[w];if not L.joining then local A=L.lastStatus=="joined";if not A and e and L.jobId then local P,j=pcall(e,L.jobId);A=P and j=="joined";end;if A or s(L)>B then if I and L.jobId then pcall(I,L.jobId);end;L.row:Destroy();table.remove(a,w);H+=1;end;end;end;return H;end,p,W,r,function()for w=#a,1,-1 do if a[w].row then a[w].row:Destroy();end;a[w]=nil;end;v,N,S,K=nil,nil,nil,0;end;end

					do
						local Frame3 = slicedfn37("Frame", {
							Name = "Notifications",
							AnchorPoint = Vector2.new(1, 1),
							Position = UDim2.new(1, -20, 1, -20),
							Size = UDim2.fromOffset(300, 420),  -- LEAKED BY STARLOXMELO
							BackgroundTransparency = 1,
							Parent = ScreenGui,
						})

						slicedfn37("UIListLayout", {
							Padding = UDim.new(0, 8),
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Bottom,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							Parent = Frame3,
						})  -- LEAKED BY STARLOXMELO

						up_140 = slicedfn37
						up_141 = tbl22
						up_142 = Frame3
					end
				end

				up_143 = slicedfn39
				up_144 = slicedfn38
				slicedfn43 = function(B,I,e)e=e or 4;local H=up_140("Frame",{Size=UDim2.new(1,0,0,66),BackgroundColor3=up_141.Sidebar,BackgroundTransparency=1,BorderSizePixel=0,Parent=up_142});up_143(H,10);local a,K=up_140("UIStroke",{Color=up_141.Stroke,Transparency=1,Thickness=1,Parent=H}),up_140("Frame",{Position=UDim2.fromOffset(0,10),Size=UDim2.new(0,3,1,-20),BackgroundColor3=up_141.Accent,BackgroundTransparency=1,BorderSizePixel=0,Parent=H});up_143(K,2);local L,A=up_140("TextLabel",{Position=UDim2.fromOffset(14,8),Size=UDim2.new(1,-22,0,20),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text=B,TextColor3=up_141.Text,TextTransparency=1,TextSize=17,TextXAlignment=Enum.TextXAlignment.Left,Parent=H}),up_140("TextLabel",{Position=UDim2.fromOffset(14,28),Size=UDim2.new(1,-22,0,32),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=I,TextColor3=up_141.TextDim,TextTransparency=1,TextSize=15,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Parent=H});up_144(H,0.3,{BackgroundTransparency=0.08});up_144(a,0.3,{Transparency=0.5});up_144(K,0.3,{BackgroundTransparency=0});up_144(L,0.3,{TextTransparency=0});up_144(A,0.3,{TextTransparency=0.2});task.delay(e,function()if not H.Parent then return;end;up_144(H,0.3,{BackgroundTransparency=1});up_144(a,0.3,{Transparency=1});up_144(K,0.3,{BackgroundTransparency=1});up_144(L,0.3,{TextTransparency=1});up_144(A,0.3,{TextTransparency=1});task.wait(0.35);H:Destroy();end);end
				sliced91 = nil
				sliced92 = nil  -- LEAKED BY STARLOXMELO
				up_145 = slicedfn37
				up_146 = tbl22
				up_147 = ScreenGui
				up_148 = slicedfn39
				up_149 = slicedfn31
				up_150 = sliced91
				up_151 = flag18
				up_152 = slicedfn38

				up_153 = sliced92
				;(function()local B=up_145("Frame",{Name="WsError",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(540,200),BackgroundColor3=up_146.Background,BackgroundTransparency=0.05,BorderSizePixel=0,Visible=false,ZIndex=90,Parent=up_147});up_148(B,14);up_145("UIStroke",{Color=up_146.Bad,Transparency=0.25,Thickness=1.5,Parent=B});local I=up_145("UIScale",{Scale=1,Parent=B});up_145("TextLabel",{Position=UDim2.fromOffset(22,16),Size=UDim2.new(1,-60,0,30),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="WebSocket connection failed",TextColor3=up_146.Bad,TextSize=24,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=91,Parent=B});local e=up_145("TextLabel",{Position=UDim2.fromOffset(22,52),Size=UDim2.new(1,-44,1,-96),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="",TextColor3=up_146.Text,TextSize=18,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ZIndex=91,Parent=B});up_145("TextLabel",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,22,1,-14),Size=UDim2.new(1,-44,0,18),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text="Retrying automatically \226\128\148 you can also switch region via the status tab (top).",TextColor3=up_146.TextDim,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=91,Parent=B});local H=up_145("TextButton",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,12),Size=UDim2.fromOffset(26,26),BackgroundColor3=up_146.Element,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="\195\151",TextColor3=up_146.Text,TextSize=17,ZIndex=92,Parent=B});up_148(H,8);up_149 (H.MouseButton1Click:Connect(function()B.Visible=false;end));up_150 =function(H)if not up_151 then return;end;e.Text=tostring(H or"Unknown error");if not B.Visible then B.Visible=true;I.Scale=0.9;up_152(I,0.25,{Scale=1},Enum.EasingStyle.Back);end;end;up_153 =function()if B.Visible then B.Visible=false;end;end;end)()  -- LEAKED BY STARLOXMELO
				up_154 = nil
				up_155 = slicedfn37
				up_156 = tbl22
				up_157 = ScreenGui
				up_158 = slicedfn39
				up_159 = slicedfn42
				up_160 = nil
				up_161 = nil
				up_162 = nil

				up_163 = nil  -- LEAKED BY STARLOXMELO
				;(function()up_154 =up_155("Frame",{Name="JoinBanner",AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,-90),Size=UDim2.fromOffset(344,66),BackgroundColor3=up_156.Background,BackgroundTransparency=0.05,BorderSizePixel=0,Visible=false,ZIndex=60,Parent=up_157});up_158(up_154 ,14);up_155("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=up_156.Accent,Thickness=1,Transparency=0.25,Parent=up_154 });up_155("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(24,16,24),Color3.fromRGB(13,11,14)),Rotation=100,Parent=up_154 });local B=up_155("CanvasGroup",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=60,Parent=up_154 });up_158(B,14);up_159(B,4,61,function()return up_154 .Visible;end);up_155("Frame",{Position=UDim2.fromOffset(0,12),Size=UDim2.new(0,4,1,-24),BackgroundColor3=up_156.Accent,BorderSizePixel=0,ZIndex=62,Parent=up_154 });up_160 =up_155("TextLabel",{Position=UDim2.fromOffset(18,9),Size=UDim2.new(1,-76,0,14),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="TELEPORTING TO",TextColor3=up_156.Accent2,TextTransparency=0.1,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=62,Parent=up_154 });up_161 =up_155("TextLabel",{Position=UDim2.fromOffset(18,22),Size=UDim2.new(1,-76,0,20),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Brainrot",TextColor3=up_156.Text,TextSize=20,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=62,Parent=up_154 });up_162 =up_155("TextLabel",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,18,1,-9),Size=UDim2.new(1,-76,0,14),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text="",TextColor3=up_156.Accent,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=62,Parent=up_154 });up_163 =up_155("ImageLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(46,46),BackgroundColor3=up_156.SliderTrack,BackgroundTransparency=0.35,Image="",ScaleType=Enum.ScaleType.Crop,Visible=false,ZIndex=62,Parent=up_154 });up_158(up_163 ,10);end)()
				up_164 = nil
				up_165 = slicedfn56
				up_166 = slicedfn57
				up_167 = nil
				up_168 = nil

				do
					local function slicedfn63(B)up_164 .Visible=false;up_164 .Image="";local I=up_165 (B);if I then up_164 .Image=I;up_164 .Visible=true;return;end;up_166 (B,function(I)if up_167 and up_167 .Visible and up_168 .Text==tostring(B)then up_164 .Image=I;up_164 .Visible=true;end;end);end
					up_169 = flag18
					up_170 = nil  -- LEAKED BY STARLOXMELO
					up_171 = nil
					up_172 = nil
					up_173 = nil
					up_174 = slicedfn63
					up_175 = slicedfn38
					up_176 = 0
					tbl19.showJoin = function(B,I,e)if not up_169 or not up_170 then return;end;up_171 .Text=e or"TELEPORTING TO";up_172 .Text=tostring(B or"Brainrot");up_173 .Text="Generation: "..tostring(I or"?");up_174(B);up_170 .Visible=true;up_175(up_170 ,0.3,{Position=UDim2.new(0.5,0,0,14)},Enum.EasingStyle.Back);up_176 +=1;local B=up_176 ;task.delay(3.5,function()if not up_169 or B~=up_176 or not up_170 then return;end;up_175(up_170 ,0.3,{Position=UDim2.new(0.5,0,0,-90)},Enum.EasingStyle.Quad,Enum.EasingDirection.In);task.wait(0.32);if B==up_176 and up_170 then up_170 .Visible=false;end;end);end
					up_177 = flag18
					up_178 = nil
					up_179 = 0  -- LEAKED BY STARLOXMELO
					up_180 = nil
					up_181 = nil
					up_182 = nil
					up_183 = nil
					up_184 = slicedfn63
				end
			end

			do
				up_185 = slicedfn38
				up_186 = nil  -- LEAKED BY STARLOXMELO
				up_187 = 0
				up_188 = slicedfn38
				tbl19.showJoinProgress = function(B,I,e,H)if not up_177 or not up_178 then return;end;up_179 +=1;up_180 .Text="CONNECTING TO";up_181 .Text=tostring(B or"Brainrot");up_182 .Text="Generation: "..tostring(I or"?").."  \194\183  attempt "..tostring(e or 1).."/"..tostring(H or"?");if(e or 1)==1 or not up_183 .Visible then up_184(B);end;up_178 .Visible=true;up_185(up_178 ,0.3,{Position=UDim2.new(0.5,0,0,14)},Enum.EasingStyle.Back);end
				tbl19.hideJoin = function()if not up_186 then return;end;up_187 +=1;local B=up_187 ;up_188(up_186 ,0.3,{Position=UDim2.new(0.5,0,0,-90)},Enum.EasingStyle.Quad,Enum.EasingDirection.In);task.delay(0.32,function()if B==up_187 and up_186 then up_186 .Visible=false;end;end);end
				n = 190
				slicedn33 = 66

				sliced93 = slicedfn37("TextButton", {
					Name = "MinimizedIcon",
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.fromScale(0.5, 0.5),  -- LEAKED BY STARLOXMELO
					Size = UDim2.fromOffset(190, 66),
					BackgroundColor3 = tbl22.Background,
					AutoButtonColor = false,
					Text = "",
					Visible = false,
					ClipsDescendants = true,
					Parent = ScreenGui,
				})

				slicedfn39(sliced93, 16)

				slicedfn37("UIStroke", {  -- LEAKED BY STARLOXMELO
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = tbl22.Stroke,
					Transparency = 0.2,
					Thickness = 1,
					Parent = sliced93,
				})

				do
					local color = Color3.fromRGB
					local v = 14

					slicedfn37("UIGradient", {  -- LEAKED BY STARLOXMELO
						Color = ColorSequence.new(Color3.fromRGB(24, 16, 24), color(13, 11, v)),
						Rotation = 120,
						Parent = sliced93,
					})
				end
			end

			sliced94 = slicedfn37("UIScale", { Scale = 0, Parent = sliced93 })

			Frame2 = slicedfn37("Frame", {
				Position = UDim2.fromOffset(9, 10),
				Size = UDim2.fromOffset(46, 46),  -- LEAKED BY STARLOXMELO
				BackgroundColor3 = tbl22.Element,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 2,
				Parent = sliced93,
			})

			slicedfn39(Frame2, 12)

			do
				local color = Color3.fromRGB
				local v = 18  -- LEAKED BY STARLOXMELO

				slicedfn37("UIGradient", {
					Color = ColorSequence.new(Color3.fromRGB(34, 22, 34), color(v, 13, 18)),
					Rotation = 125,
					Parent = Frame2,
				})
			end
		end

		do
			local v

			do  -- LEAKED BY STARLOXMELO
				v = slicedfn37("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = tbl22.Accent,
					Thickness = 1.4,
					Transparency = 0.2,
					Parent = Frame2,
				})

				do
					local CanvasGroup = slicedfn37("CanvasGroup", {
						Size = UDim2.fromScale(1, 1),  -- LEAKED BY STARLOXMELO
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ZIndex = 2,
						Parent = Frame2,
					})

					slicedfn39(CanvasGroup, 12)

					slicedfn42(CanvasGroup, 3, 3, function()
						return sliced93.Visible
					end)
				end  -- LEAKED BY STARLOXMELO
			end

			slicedfn37("TextLabel", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				Text = "K",
				TextColor3 = tbl22.Accent,
				TextSize = 28,
				ZIndex = 3,
				Parent = Frame2,  -- LEAKED BY STARLOXMELO
			})

			tbl25.iconDot = slicedfn37("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromOffset(65, 17),
				Size = UDim2.fromOffset(9, 9),
				BackgroundColor3 = tbl22.Bad,
				BorderSizePixel = 0,
				ZIndex = 3,
				Parent = sliced93,
			})  -- LEAKED BY STARLOXMELO

			slicedfn39(tbl25.iconDot, 5)

			tbl25.miniWsText = slicedfn37("TextLabel", {
				Position = UDim2.fromOffset(81, 8),
				Size = UDim2.fromOffset(n - 90, 16),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				Text = "Offline",
				TextColor3 = tbl22.Bad,
				TextSize = 16,
				TextTruncate = Enum.TextTruncate.AtEnd,  -- LEAKED BY STARLOXMELO
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 3,
				Parent = sliced93,
			})

			do
				local autoJoin, sliced96 = slicedfn34()

				tbl25.miniAjText = slicedfn37("TextLabel", {
					Position = UDim2.fromOffset(65, 27),
					Size = UDim2.fromOffset(n - 74, 15),
					BackgroundTransparency = 1,  -- LEAKED BY STARLOXMELO
					Font = Enum.Font.GothamMedium,
					Text = "Auto Join: " .. autoJoin,
					TextColor3 = sliced96,
					TextSize = 15,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 3,
					Parent = sliced93,
				})
			end

			tbl25.miniThird = slicedfn37("TextLabel", {  -- LEAKED BY STARLOXMELO
				Position = UDim2.fromOffset(65, 44),
				Size = UDim2.fromOffset(n - 74, 14),
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				Text = tbl25.wsRegionText or "—",
				TextColor3 = tbl22.TextDim,
				TextTransparency = 0.15,
				TextSize = 14,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,  -- LEAKED BY STARLOXMELO
				ZIndex = 3,
				Parent = sliced93,
			})

			task.spawn(function()
				while flag18 and sliced93.Parent do
					if sliced93.Visible then
						slicedfn38(v, 1.2, { Transparency = 0.5 })
						task.wait(1.2)
						slicedfn38(v, 1.2, { Transparency = 0.12 })
						task.wait(1.2)  -- LEAKED BY STARLOXMELO
					else
						task.wait(0.4)
					end
				end
			end)
		end
	end

	do
		sliced95 = nil

		do  -- LEAKED BY STARLOXMELO
			local function slicedfn63(arg)
				local absoluteSize = ScreenGui.AbsoluteSize
				if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
					return arg
				end
				local slicedn34 = arg.Y.Scale * absoluteSize.Y + arg.Y.Offset
				local slicedn35 = x2 / 2
				local slicedn36 = y2 / 2
				local slicedn37 = math.clamp(arg.X.Scale * absoluteSize.X + arg.X.Offset, slicedn35, math.max(slicedn35, absoluteSize.X - slicedn35))
				local slicedn38 = math.clamp(slicedn34, slicedn36, math.max(slicedn36, absoluteSize.Y - slicedn36))  -- LEAKED BY STARLOXMELO
				local floor2 = math.floor
				return UDim2.fromOffset(math.floor(slicedn37), floor2(slicedn38))
			end

			up_189 = flag20
			up_190 = flag19
			up_191 = sliced88
			up_192 = sliced95
			up_193 = nil
			up_194 = Frame
			up_195 = ScreenGui  -- LEAKED BY STARLOXMELO
			up_196 = n
			up_197 = sliced84
			up_198 = slicedn33
			up_199 = slicedfn38
			up_200 = sliced85
			up_201 = sliced93
			up_202 = sliced94
			up_203 = slicedfn30
			up_204 = slicedfn63
		end  -- LEAKED BY STARLOXMELO
	end

	up_205 = x2
	up_206 = y2
	up_207 = nil
	up_208 = sliced87
	slicedfn62 = function(B)if up_189 or up_190 ==B then return;end;up_189 ,up_190 =true,B;if B then local B=up_191 ();if up_192 then local I=up_192 ();if I and I.PlaybackState==Enum.PlaybackState.Playing then I.Completed:Wait();end;end;if B and B.PlaybackState==Enum.PlaybackState.Playing then B.Completed:Wait();end;up_193 =up_194.Position;local I,e=up_195.AbsolutePosition,up_194.AbsolutePosition;local H,a=e.X-I.X,e.Y-I.Y;up_194.AnchorPoint=Vector2.new(0,0);up_194.Position=UDim2.fromOffset(H,a);I,B=math.max(1,math.floor(up_196/up_197 +0.5)),math.max(1,math.floor(up_198/up_197 +0.5));up_199(up_200,0.1,{Scale=up_197 });up_194.ClipsDescendants=true;up_199(up_194,0.32,{Size=UDim2.fromOffset(I,B)},Enum.EasingStyle.Cubic,Enum.EasingDirection.In).Completed:Wait();B=up_195.AbsoluteSize;up_201.Position=UDim2.fromOffset(math.clamp(math.floor(H),0,math.max(0,B.X-up_196)),math.clamp(math.floor(a),0,math.max(0,B.Y-up_198)));up_202.Scale=1;up_201.Visible=true;up_194.Visible=false;up_194.ClipsDescendants=false;a,H=up_203();up_194.Size=UDim2.fromOffset(a,H);up_194.AnchorPoint=Vector2.new(0.5,0.5);up_194.Position=up_193 ;else local B=up_201.Position;local I=up_204 (UDim2.fromOffset(math.floor(B.X.Offset+up_205 /2),math.floor(B.Y.Offset+up_206 /2)));up_193 =I;local B,e,H,a,K,L=I.X.Offset,I.Y.Offset,math.max(1,math.floor(up_196/up_197 +0.5)),math.max(1,math.floor(up_198/up_197 +0.5)),up_203();up_194.AnchorPoint=Vector2.new(0,0);up_194.Position=UDim2.fromOffset(math.floor(B-up_205 /2),math.floor(e-up_206 /2));up_194.Size=UDim2.fromOffset(H,a);up_200.Scale=up_197 ;up_194.ClipsDescendants=true;up_194.Visible=true;up_201.Visible=false;up_199(up_194,0.32,{Size=UDim2.fromOffset(K,L)},Enum.EasingStyle.Cubic,Enum.EasingDirection.Out).Completed:Wait();up_194.ClipsDescendants=false;up_194.AnchorPoint=Vector2.new(0.5,0.5);up_194.Position=I;if up_207 then up_207 ();end;up_208 ();end;up_189 =false;end

	slicedfn31(sliced90.MouseButton1Click:Connect(function()
		task.spawn(slicedfn62, true)
	end))

	slicedfn31(sliced93.InputBegan:Connect(function(input)  -- LEAKED BY STARLOXMELO
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local position = input.Position
			local position2 = sliced93.Position
			local slicedn34 = 0

			slicedfn44(function(arg)
				local slicedn35 = arg.Position - position
				slicedn34 = math.max(slicedn34, slicedn35.Magnitude)
				sliced93.Position = UDim2.new(position2.X.Scale, position2.X.Offset + slicedn35.X, position2.Y.Scale, position2.Y.Offset + slicedn35.Y)
			end, function()
				if slicedn34 < 6 then  -- LEAKED BY STARLOXMELO
					task.spawn(slicedfn62, false)
				end
			end, input.UserInputType)
		end
	end))

	do
		local function slicedfn63()
			if flag20 then
				local slicedn34 = os.clock() + 2

				while true do  -- LEAKED BY STARLOXMELO
					task.wait(0.05)
					if not (not flag20 or not flag18 or os.clock() >= slicedn34) then
						continue
					end
					break
				end
			end

			if not flag18 or flag20 then
				return
			end  -- LEAKED BY STARLOXMELO
			flag20 = true
			local v = sliced88()

			if sliced95 then
				local sliced96 = sliced95()

				if sliced96 and sliced96.PlaybackState == Enum.PlaybackState.Playing then
					sliced96.Completed:Wait()
				end
			end

			if v and v.PlaybackState == Enum.PlaybackState.Playing then
				v.Completed:Wait()  -- LEAKED BY STARLOXMELO
			end

			slicedfn38(sliced85, 0.3, { Scale = 0 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In).Completed:Wait()
			slicedfn40()
			ScreenGui:Destroy()
		end

		slicedfn31(sliced89.MouseButton1Click:Connect(function()
			task.spawn(slicedfn63)
		end))
	end
end  -- LEAKED BY STARLOXMELO

local sliced96, sliced97, sliced98, sliced99

do
	local Main = slicedfn46("Main", { scroll = false })
	local Whitelist = slicedfn46("Whitelist", { scroll = false })
	local sliced100 = slicedfn46("Config")
	local sliced101 = slicedfn46("AJ Users")
	sliced96 = slicedfn46("Info")
	sliced97 = function() end
	sliced98 = nil
	sliced99 = nil  -- LEAKED BY STARLOXMELO
	up_209 = slicedfn48
	up_210 = Main
	up_211 = slicedfn34
	up_212 = slicedfn59
	up_213 = nil
	up_214 = tbl23
	up_215 = slicedfn32
	up_216 = tbl25
	up_217 = tbl18
	up_218 = slicedfn51  -- LEAKED BY STARLOXMELO
	up_219 = slicedfn43
	up_220 = tbl22
	up_221 = nil
	up_222 = slicedfn37
	up_223 = slicedfn47
	up_224 = slicedfn39
	up_225 = sliced97
	up_226 = sliced98
	up_227 = sliced99
	up_228 = slicedfn61  -- LEAKED BY STARLOXMELO

	up_229 = tbl19
	;(function()up_209(up_210,"Quick actions");local B;local function I()local e,H=up_211 ();B.Text=("Auto Join  [<font color=\"%s\">%s</font>]"):format(up_212(H),e);end;up_213 =function(e)up_214.AutoJoin=e and true or false;up_215 ();if B then I();end;if up_216.miniAjText then local e,H=up_211 ();up_216.miniAjText.Text="Auto Join: "..e;up_216.miniAjText.TextColor3=H;end;if up_217.setAutoJoin then up_217.setAutoJoin(up_214.AutoJoin);end;end;B=up_218(up_210,{{text="",rich=true,callback=function()up_213 (not up_214.AutoJoin);end},{text="Rejoin",baseColor=Color3.fromRGB(150,62,74),hoverColor=Color3.fromRGB(182,78,92),flashColor=Color3.fromRGB(212,98,112),callback=function()up_219 ("Joiner","Rejoining this server...");if up_217.rejoin then up_217.rejoin();else pcall(function()game:GetService("TeleportService"):TeleportReconnect();end);end;end},{text="Clear logs",baseColor=Color3.fromRGB(64,36,52),hoverColor=Color3.fromRGB(84,46,66),flashColor=up_220.Accent,callback=function()local B=up_221 and(up_221 (up_214.MaxElapsedJoin))or 0;up_219 ("Logs",B>0 and"Cleared "..B..(B==1 and" entry"or" entries").." (older than "..tostring(up_214.MaxElapsedJoin).."s, or joined)"or"Nothing older than "..tostring(up_214.MaxElapsedJoin).."s (or joined) to clear");end}})[1];I();up_209(up_210,"Live brainrots");local B=up_222("Frame",{Size=UDim2.new(1,0,1,-122),BackgroundColor3=up_220.Sidebar,BackgroundTransparency=0.35,BorderSizePixel=0,ClipsDescendants=true,LayoutOrder=up_223(up_210),ZIndex=2,Parent=up_210});up_224(B,10);up_222("UIStroke",{Color=up_220.Stroke,Transparency=0.5,Thickness=1,Parent=B});local I=up_222("ScrollingFrame",{Position=UDim2.fromOffset(6,6),Size=UDim2.new(1,-12,1,-12),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=up_220.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=2,Parent=B});up_222("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=I});up_222("UIPadding",{PaddingRight=UDim.new(0,4),Parent=I});local B=nil;local e=nil;local H=nil;up_225 ,up_226 ,up_221 ,B,e,H,up_227 =up_228(I,function(name, rarity, genStr, jobId, animalIdx)
-- STARLOXMELO SMART JOIN (correct args: name, rarity, gen, jobId, idx)
-- Goal: land on a DIFFERENT server that has the same brainrot, or one worth 10M+/s.

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local me = tostring(game.JobId or "")
local placeId = game.PlaceId
local targetPlace = 109983668079237
if placeId == 109983668079237 or placeId == 123923334828954 then
	targetPlace = placeId
end

local function notify(msg)
	if up_219 then
		pcall(up_219, "Joiner", msg)
	elseif tbl19 and tbl19.notify then
		pcall(tbl19.notify, "Joiner", msg, 4)
	end
end

-- Parse "80M/s", "3.5M/s", "1B/s", raw numbers
local function parseGen(s)
	if type(s) == "number" then
		return s
	end
	if type(s) ~= "string" then
		return 0
	end
	s = s:gsub("/s", ""):gsub("%$", ""):gsub(",", ""):gsub("%s", "")
	local n, suf = s:match("^([%d%.]+)([KkMmBbTt]?)$")
	n = tonumber(n)
	if not n then
		return 0
	end
	suf = (suf or ""):upper()
	if suf == "K" then return n * 1e3 end
	if suf == "M" then return n * 1e6 end
	if suf == "B" then return n * 1e9 end
	if suf == "T" then return n * 1e12 end
	return n
end

local function animalGen(an)
	if type(an) ~= "table" then
		return 0
	end
	local g = an.Generation or an.generation or an.Gen or 0
	if type(g) == "string" then
		return parseGen(g)
	end
	return tonumber(g) or 0
end

local function formatGen(n)
	n = tonumber(n) or 0
	if n >= 1e9 then
		return string.format("%.1fB/s", n / 1e9)
	end
	if n >= 1e6 then
		return string.format("%.0fM/s", n / 1e6)
	end
	if n >= 1e3 then
		return string.format("%.0fK/s", n / 1e3)
	end
	return tostring(math.floor(n)) .. "/s"
end

local function getJobs()
	local jobs = getgenv().KaWaifuJobs
	if type(jobs) == "table" then
		return jobs
	end
	return nil
end

-- Score every OTHER job for this log
-- returns jobId, reason, bestGenOnThatJob
local function findBestJob(wantName, wantGen)
	local jobs = getJobs()
	if type(jobs) ~= "table" then
		return nil, nil, 0
	end

	wantName = string.lower(tostring(wantName or ""))
	wantGen = tonumber(wantGen) or 0
	-- User asked: similar, and at least ~10M class
	local minRich = 10e6
	if wantGen > 0 then
		minRich = math.max(10e6, wantGen * 0.35)
	end

	local bestId, bestScore, bestWhy, bestGen = nil, -1e18, nil, 0

	for jid, job in pairs(jobs) do
		if tostring(jid) ~= me and type(job) == "table" and type(job.animals) == "table" then
			local jobBestGen = 0
			local jobBestName = ""
			local nameHit = false
			local partialHit = false

			for _, an in ipairs(job.animals) do
				local nm = string.lower(tostring(an.DisplayName or an.Name or ""))
				local gen = animalGen(an)
				if gen > jobBestGen then
					jobBestGen = gen
					jobBestName = nm
				end
				if wantName ~= "" and nm == wantName then
					nameHit = true
					jobBestGen = math.max(jobBestGen, gen)
				elseif wantName ~= "" and #nm > 2 and (string.find(nm, wantName, 1, true) or string.find(wantName, nm, 1, true)) then
					partialHit = true
				end
			end

			-- scoring
			local score = 0
			local why = nil
			if nameHit then
				-- exact brainrot present on another server - highest priority
				score = 1e15 + jobBestGen
				why = "exact " .. tostring(wantName) .. " " .. formatGen(jobBestGen)
			elseif partialHit and jobBestGen >= minRich then
				score = 1e14 + jobBestGen
				why = "similar name " .. formatGen(jobBestGen)
			elseif jobBestGen >= minRich then
				-- rich server (10M+ or proportional to target)
				score = 1e13 + jobBestGen
				why = "rich " .. tostring(jobBestName) .. " " .. formatGen(jobBestGen)
			elseif jobBestGen > 0 then
				score = jobBestGen
				why = "fallback " .. formatGen(jobBestGen)
			end

			-- prefer gens close to the log's gen when name didn't match
			if not nameHit and wantGen > 0 and jobBestGen > 0 then
				local ratio = jobBestGen / wantGen
				if ratio > 0.5 and ratio < 2.5 then
					score = score + 1e12
				end
			end

			if score > bestScore then
				bestScore = score
				bestId = jid
				bestWhy = why
				bestGen = jobBestGen
			end
		end
	end

	return bestId, bestWhy, bestGen
end

local function engineJoin(jid)
	if not (up_217 and up_217.joinServer) then
		return false
	end
	if not jid or tostring(jid) == me then
		return false
	end
	local ok
	if animalIdx and up_217.joinAnimal then
		ok = up_217.joinAnimal(jid, animalIdx, name)
	else
		ok = up_217.joinServer(jid)
	end
	return ok
end

local function rawTeleport(jid)
	if not jid or tostring(jid) == me then
		return false
	end
	local ok = pcall(function()
		TeleportService:TeleportToPlaceInstance(targetPlace, tostring(jid), LP)
	end)
	return ok
end

local function publicHop()
	local servers = nil
	pcall(function()
		local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(targetPlace)
		local body
		if syn and syn.request then
			local r = syn.request({ Url = url, Method = "GET" })
			body = r and r.Body
		elseif request then
			local r = request({ Url = url, Method = "GET" })
			body = r and (r.Body or r.body)
		elseif http_request then
			local r = http_request({ Url = url, Method = "GET" })
			body = r and r.Body
		elseif game.HttpGet then
			body = game:HttpGet(url)
		end
		if body then
			local data = HttpService:JSONDecode(body)
			if type(data) == "table" and type(data.data) == "table" then
				servers = data.data
			end
		end
	end)

	if type(servers) == "table" then
		local pool = {}
		for _, s in ipairs(servers) do
			if s and s.id and tostring(s.id) ~= me then
				local maxp = tonumber(s.maxPlayers) or 8
				local playing = tonumber(s.playing) or 0
				if playing < maxp then
					pool[#pool + 1] = tostring(s.id)
				end
			end
		end
		if #pool == 0 then
			for _, s in ipairs(servers) do
				if s and s.id and tostring(s.id) ~= me then
					pool[#pool + 1] = tostring(s.id)
				end
			end
		end
		if #pool > 0 then
			local pick = pool[math.random(1, #pool)]
			notify("No matching brainrot job - other public server")
			pcall(function()
				TeleportService:TeleportToPlaceInstance(targetPlace, pick, LP)
			end)
			return true
		end
	end

	notify("Random server hop")
	pcall(function()
		TeleportService:Teleport(targetPlace, LP)
	end)
	return true
end

-- Resolve what the log is asking for
local wantName = name
local wantGen = parseGen(genStr)
local jid = jobId
local isFake = type(jid) == "string" and tostring(jid):sub(1, 5) == "fake-"
local isSame = tostring(jid or "") == me

-- Fill gen from job table if log gen missing
if wantGen <= 0 then
	local jobs = getJobs()
	if type(jobs) == "table" and jid and type(jobs[jid]) == "table" and type(jobs[jid].animals) == "table" then
		for _, an in ipairs(jobs[jid].animals) do
			local nm = string.lower(tostring(an.DisplayName or ""))
			if wantName and nm == string.lower(tostring(wantName)) then
				wantGen = math.max(wantGen, animalGen(an))
			end
		end
		if wantGen <= 0 and jobs[jid].animals[1] then
			wantGen = animalGen(jobs[jid].animals[1])
		end
	end
end

-- 1) Direct join if this is a real, different JobId still live
if (not isFake) and jid and (not isSame) then
	local ok = engineJoin(jid)
	if ok == "cancelled" then
		notify("Join cancelled")
		return
	elseif ok then
		notify("Joining " .. tostring(wantName or "?") .. " (" .. tostring(genStr or formatGen(wantGen)) .. ")")
		return
	end
	-- job expired - keep looking
end

-- 2) Smart search across live WS jobs
local alt, why = findBestJob(wantName, wantGen)
if alt then
	local ok = engineJoin(alt)
	if ok and ok ~= "cancelled" then
		notify("Matched: " .. tostring(why))
		return
	end
	if rawTeleport(alt) then
		notify("Matched: " .. tostring(why))
		return
	end
end

-- 3) Nothing similar online - still leave this server
notify("No " .. tostring(wantName or "target") .. " / 10M+ job live - hopping")
publicHop()
end);up_229.feedJoinProgress=B;up_229.feedJoinEnded=e;up_229.feedRowName=H;sliced97=up_225;sliced98=up_226;sliced99=up_227;end)()
	up_230 = service
	up_231 = tbl18
	up_232 = tbl24
	up_233 = tbl23
	up_234 = slicedfn32
	up_235 = slicedfn48
	up_236 = Whitelist
	up_237 = slicedfn55  -- LEAKED BY STARLOXMELO
	up_238 = slicedfn35
	up_239 = slicedfn31
	up_240 = slicedfn37
	up_241 = tbl22
	up_242 = slicedfn39
	up_243 = slicedfn38
	up_244 = slicedfn36
	up_245 = slicedfn49
	up_246 = slicedfn51
	up_247 = slicedfn47  -- LEAKED BY STARLOXMELO
	up_248 = sliced84
	up_249 = ScreenGui
	up_250 = slicedfn60
	up_251 = tbl21
	up_252 = tbl17
	up_253 = slicedfn43
	up_254 = Frame
	up_255 = flag20
	up_256 = sliced95

	up_257 = nil  -- LEAKED BY STARLOXMELO
	;(function()local B,I,e,H,a,K,L,A,P,v,N={Profiles={},Active="Default"},{},"","All";local function S()local j=B.Profiles[B.Active];if not j then j={Global={Enabled=false,MinGen=0},Items={},createdAt=0};B.Profiles[B.Active]=j;end;j.Global=j.Global or{Enabled=false,MinGen=0};j.Items=j.Items or{};return j;end;local function j()pcall(function()writefile("KaWaifuJoiner_WLProfiles.json",up_230:JSONEncode({Profiles=B.Profiles,Active=B.Active}));end);end;local function p()if up_231.wlApply then local W=S();pcall(up_231.wlApply,W.Global,W.Items);end;end;up_232.push=p;pcall(function()if isfile and(isfile("KaWaifuJoiner_WLProfiles.json"))then local W=up_230:JSONDecode(readfile("KaWaifuJoiner_WLProfiles.json"));if type(W)=="table"then if type(W.Profiles)=="table"then B.Profiles=W.Profiles;end;if type(W.Active)=="string"then B.Active=W.Active;end;end;end;end);for W,r in pairs(B.Profiles)do if type(W)~="string"or type(r)~="table"then B.Profiles[W]=nil;else if type(r.Global)~="table"then r.Global={Enabled=false,MinGen=0};end;if type(r.Items)~="table"then r.Items={};end;for W,s in pairs(r.Items)do if type(W)~="string"or type(s)~="table"then r.Items[W]=nil;elseif s.Mutations~=nil and type(s.Mutations)~="table"then s.Mutations=nil;end;end;end;end;if not B.Profiles[B.Active]then B.Active="Default";end;local W=S().Items;local r=false;for s,y in pairs(up_233.Whitelist)do if type(s)=="string"and y and not W[s]then W[s]={State="Whitelist",MinGen=0,Mutations={}};r=true;end;end;if r then j();end;if next(up_233.Whitelist)~=nil then up_233.Whitelist={};up_234 ();end;P=function(s)if not B.Profiles[s]then return;end;B.Active=s;j();p();if A then A();end;L();a();end;up_235(up_236,"Global filter");local s=nil;local y=nil;local h=nil;do local _,o=up_237(up_236,"Global min generation",function(E,R,R)if E==""then L();return;end;S().Global.MinGen=math.max(0,up_238(E));j();p();L();end);s=o;o.Size=UDim2.new(1,-96,1,0);up_239 (o.Focused:Connect(function()o.Text=tostring(S().Global.MinGen);end));y=up_240("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-5,0.5,0),Size=UDim2.fromOffset(66,24),BackgroundColor3=up_241.Bad:Lerp(up_241.Element,0.82),AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="Off",TextColor3=up_241.Bad:Lerp(up_241.Text,0.5),TextSize=14,ZIndex=3,Parent=_});up_242(y,7);h=up_240("UIStroke",{Color=up_241.Bad:Lerp(up_241.Stroke,0.55),Transparency=0.4,Thickness=1,Parent=y});up_239 (y.MouseButton1Click:Connect(function()local _=S().Global;_.Enabled=not _.Enabled;j();p();L();end));end;L=function()local _=S().Global;local o=_.Enabled and up_241.Good or up_241.Bad;y.Text=_.Enabled and"On"or"Off";up_243(y,0.15,{BackgroundColor3=o:Lerp(up_241.Element,0.82),TextColor3=o:Lerp(up_241.Text,0.5)});up_243(h,0.15,{Color=o:Lerp(up_241.Stroke,0.55)});s.Text=up_244(_.MinGen).."/s";end;up_235(up_236,"Brainrots");local s=up_245(up_236,"WL = auto-join it \194\183 BL = never \194\183 OFF = global filter applies. Set a min-gen per brainrot.");s.AutomaticSize=Enum.AutomaticSize.Y;do local y,y=up_237(up_236,"Search brainrots...",nil);up_239 (y:GetPropertyChangedSignal("Text"):Connect(function()e=y.Text:lower();K();end));end;local y={All="Filter: All",Whitelist="Filter: <font color=\"#6EC88C\">WL</font>",Blacklist="Filter: <font color=\"#D25F69\">BL</font>",None="Filter: <font color=\"#96848F\">Off</font>"};local h=nil;h=up_246(up_236,{{text="Filter: All",rich=true,callback=function()H=({All="Whitelist",Whitelist="Blacklist",Blacklist="None",None="All"})[H]or"All";h.Text=y[H];K();end}})[1];local y=up_240("Frame",{Size=UDim2.new(1,0,1,-234),BackgroundColor3=up_241.Sidebar,BackgroundTransparency=0.35,BorderSizePixel=0,ClipsDescendants=true,LayoutOrder=up_247(up_236),ZIndex=2,Parent=up_236});up_242(y,10);up_240("UIStroke",{Color=up_241.Stroke,Transparency=0.5,Thickness=1,Parent=y});local function h()local _=up_248 >0 and up_248 or 1;local o=math.max(20,math.floor(s.AbsoluteSize.Y/_+0.5));y.Size=UDim2.new(1,0,1,-(214+o));end;up_239 (s:GetPropertyChangedSignal("AbsoluteSize"):Connect(h));h();local s=up_240("ScrollingFrame",{Position=UDim2.fromOffset(6,6),Size=UDim2.new(1,-12,1,-12),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=up_241.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=2,Parent=y});up_240("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=s});up_240("UIPadding",{PaddingRight=UDim.new(0,4),Parent=s});local y;N=function()if not y then return;end;local _=y;y=nil;up_243(_.frame,0.2,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.In).Completed:Connect(function()if _.frame.Parent then _.frame:Destroy();end;if _.overlay.Parent then _.overlay:Destroy();end;end);end;local function _(o,E)N();local R,J=pcall(function()return up_231.mutationList and(up_231.mutationList());end);local l=R and type(J)=="table"and J or{};local T=up_240("TextButton",{Name="MutOverlay",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=45,Parent=up_249});local d=up_249.AbsolutePosition;local M=o.AbsolutePosition;local C=o.AbsoluteSize;o,R=math.floor(26*up_248 +0.5),math.max(math.floor(210*up_248 +0.5),C.X);local V,F=math.min(math.max(#l,2)*(o+3)+math.floor(42*up_248 +0.5),math.floor(300*up_248 +0.5)),up_240("Frame",{Name="MutDropdown",AnchorPoint=Vector2.new(1,1),Position=UDim2.fromOffset(M.X+C.X-d.X,M.Y+C.Y-d.Y),Size=UDim2.fromOffset(0,0),BackgroundColor3=up_241.Sidebar,BorderSizePixel=0,ClipsDescendants=true,ZIndex=46,Parent=up_249});up_242(F,10);up_240("UIStroke",{Color=up_241.Accent,Transparency=0.35,Thickness=1,Parent=F});up_240("TextLabel",{Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,20),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Mutations \226\128\148 "..E,TextColor3=up_241.Text,TextSize=math.floor(13*up_248 +0.5),TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=47,Parent=F});J=up_240("ScrollingFrame",{Position=UDim2.fromOffset(8,34),Size=UDim2.new(1,-16,1,-42),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=up_241.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=47,Parent=F});up_240("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder,Parent=J});if#l==0 then up_240("TextLabel",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,Text="Join Steal a Brainrot\10to load the mutation list",Font=Enum.Font.Gotham,TextColor3=up_241.TextDim,TextSize=math.floor(12*up_248 +0.5),ZIndex=47,Parent=J});else for M,U in ipairs(l)do d,C=false,S().Items[E];if C and C.Mutations then for l,l in ipairs(C.Mutations)do if l==U then d=true;break;end;end;end;local l=up_240("TextButton",{Size=UDim2.new(1,0,0,o),BackgroundColor3=up_241.Element,BackgroundTransparency=d and 0.1 or 0.6,AutoButtonColor=false,Font=Enum.Font.GothamMedium,Text=(d and"+ "or"")..U,TextColor3=Color3.fromHex(up_250(U)),TextTransparency=d and 0 or 0.25,TextSize=math.floor(12*up_248 +0.5),LayoutOrder=M,ZIndex=47,Parent=J});up_242(l,6);l.MouseButton1Click:Connect(function()local o=S().Items;local J=o[E];if not J then J={State="None",MinGen=0,Mutations={}};o[E]=J;end;J.Mutations=J.Mutations or{};o=nil;for d,M in ipairs(J.Mutations)do if M==U then o=d;break;end;end;if o then table.remove(J.Mutations,o);else table.insert(J.Mutations,U);end;j();p();J=not o;l.Text=(J and"+ "or"")..U;l.BackgroundTransparency=J and 0.1 or 0.6;l.TextTransparency=J and 0 or 0.25;J=I[E];if J then J.refresh();end;end);end;end;up_243(F,0.25,{Size=UDim2.fromOffset(R,V)},Enum.EasingStyle.Quart);y={frame=F,overlay=T};T.MouseButton1Click:Connect(N);end;local y={None="Whitelist",Whitelist="Blacklist",Blacklist="None"};local function o(E)if E=="Whitelist"then return"WL",up_241.Good;end;if E=="Blacklist"then return"BL",up_241.Bad;end;return"OFF",up_241.TextDim;end;local function E(R,J)local l=up_240("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=up_241.Element,BorderSizePixel=0,LayoutOrder=J,ZIndex=2,Parent=s});up_242(l,8);local s=up_240("TextButton",{Position=UDim2.fromOffset(4,5),Size=UDim2.fromOffset(42,24),BackgroundColor3=up_241.ElementHover,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="OFF",TextColor3=up_241.TextDim,TextSize=13,ZIndex=2,Parent=l});up_242(s,6);up_240("TextLabel",{Position=UDim2.fromOffset(52,0),Size=UDim2.new(1,-182,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=R,TextColor3=up_241.Text,TextSize=15,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=l});local J=up_240("TextButton",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-4,0,5),Size=UDim2.fromOffset(44,24),BackgroundColor3=up_241.ElementHover,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="Mut",TextColor3=up_241.TextDim,TextSize=13,ZIndex=2,Parent=l});up_242(J,6);local T=up_240("TextBox",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-52,0,5),Size=UDim2.fromOffset(74,24),BackgroundColor3=up_241.SliderTrack,ClearTextOnFocus=false,Font=Enum.Font.Gotham,PlaceholderText="min gen",PlaceholderColor3=up_241.TextDim,Text="",TextColor3=up_241.Text,TextSize=13,ZIndex=2,Parent=l});up_242(T,6);local d={row=l,lname=R:lower(),refresh=function()local l=S().Items[R];local M,C=o(l and l.State or"None");s.Text=M;s.TextColor3=C;T.Text=l and(tonumber(l.MinGen)or 0)>0 and(up_244(l.MinGen))or"";M=l and l.Mutations and#l.Mutations or 0;J.Text=M>0 and"Mut:"..M or"Mut";J.TextColor3=M>0 and up_241.Accent or up_241.TextDim;end};s.MouseButton1Click:Connect(function()local s=S().Items;local o=s[R];if not o then o={State="None",MinGen=0,Mutations={}};s[R]=o;end;o.State=y[o.State or"None"]or"Whitelist";j();p();d.refresh();if H~="All"then K();end;end);T.Focused:Connect(function()local s=S().Items[R];T.Text=tostring(s and s.MinGen or 0);end);T.FocusLost:Connect(function()local s=S().Items;local y=s[R];if not y then y={State="None",MinGen=0,Mutations={}};s[R]=y;end;y.MinGen=math.max(0,up_238(T.Text));j();p();d.refresh();end);J.MouseButton1Click:Connect(function()_(J,R);end);d.refresh();I[R]=d;return d;end;K=function()local p=S().Items;for s,y in pairs(I)do local _=true;if H~="All"then local o=p[s];_=(o and o.State or"None")==H;end;_=if _ and e~=""then y.lname:find(e,1,true)~=nil else _;if y.row.Visible~=_ then y.row.Visible=_;end;end;end;local e=0;a=function(H)e+=1;local p=e;N();for s,s in pairs(I)do s.row:Destroy();end;table.clear(I);local I=S().Items;local S={};if up_231.wlKnown then local s,y=pcall(up_231.wlKnown);if s and type(y)=="table"then for s,s in ipairs(y)do S[s]=true;end;end;end;for s,s in ipairs(up_251)do S[s]=true;end;for s in pairs(I)do S[s]=true;end;I={};for s in pairs(S)do I[#I+1]=s;end;table.sort(I);for S,s in ipairs(I)do E(s,S);if H and S%24==0 then task.wait();if e~=p then return;end;end;end;K();end;up_232.refreshKnown=function()a(true);end;local I,e,H=up_252.ProfilesPanelWidth,up_252.ProfilesPanelGap,false;local K=up_240("Frame",{Name="ProfilesPanel",AnchorPoint=Vector2.new(0,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromOffset(I,300),BackgroundColor3=up_241.Sidebar,BorderSizePixel=0,Visible=false,ZIndex=0,Parent=up_249});up_242(K,12);up_240("UIStroke",{Color=up_241.Accent,Transparency=0.35,Thickness=1,Parent=K});up_240("TextLabel",{Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,22),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Profiles",TextColor3=up_241.Accent2,TextSize=17,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=31,Parent=K});W=up_240("TextButton",{Position=UDim2.fromOffset(8,36),Size=UDim2.new(1,-16,0,30),BackgroundColor3=up_241.Good,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="+ New",TextColor3=Color3.fromRGB(16,24,18),TextSize=15,ZIndex=31,Parent=K});up_242(W,8);local S=up_240("ScrollingFrame",{Position=UDim2.fromOffset(8,74),Size=UDim2.new(1,-16,1,-82),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=up_241.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=31,Parent=K});up_240("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=S});local p=up_240("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0.3,0),Size=UDim2.new(0.92,0,0,104),BackgroundColor3=up_241.Background,BorderSizePixel=0,Visible=false,ZIndex=33,Parent=K});up_242(p,10);up_240("UIStroke",{Color=up_241.Accent,Transparency=0.3,Thickness=1,Parent=p});up_240("TextLabel",{Position=UDim2.fromOffset(10,6),Size=UDim2.new(1,-20,0,18),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="New name:",TextColor3=up_241.Text,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=34,Parent=p});local s=up_240("TextBox",{Position=UDim2.fromOffset(10,28),Size=UDim2.new(1,-20,0,28),BackgroundColor3=up_241.Element,ClearTextOnFocus=false,Font=Enum.Font.Gotham,Text="",TextColor3=up_241.Text,TextSize=15,ZIndex=34,Parent=p});up_242(s,6);r=up_240("TextButton",{Position=UDim2.new(0.08,0,1,-36),Size=UDim2.new(0.38,0,0,26),BackgroundColor3=up_241.Good,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="OK",TextColor3=Color3.fromRGB(16,24,18),TextSize=14,ZIndex=34,Parent=p});up_242(r,6);h=up_240("TextButton",{Position=UDim2.new(0.54,0,1,-36),Size=UDim2.new(0.38,0,0,26),BackgroundColor3=up_241.Element,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="Cancel",TextColor3=up_241.Text,TextSize=14,ZIndex=34,Parent=p});up_242(h,6);local y;local _=up_240("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0.32,0),Size=UDim2.new(0.92,0,0,92),BackgroundColor3=up_241.Background,BorderSizePixel=0,Visible=false,ZIndex=33,Parent=K});up_242(_,10);up_240("UIStroke",{Color=up_241.Bad,Transparency=0.3,Thickness=1,Parent=_});local o,E=up_240("TextLabel",{Position=UDim2.fromOffset(10,8),Size=UDim2.new(1,-20,0,34),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Delete this profile?",TextColor3=up_241.Text,TextSize=15,TextWrapped=true,ZIndex=34,Parent=_}),up_240("TextButton",{Position=UDim2.new(0.08,0,1,-36),Size=UDim2.new(0.38,0,0,26),BackgroundColor3=up_241.Bad,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="Yes",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=34,Parent=_});up_242(E,6);local R=up_240("TextButton",{Position=UDim2.new(0.54,0,1,-36),Size=UDim2.new(0.38,0,0,26),BackgroundColor3=up_241.Element,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="No",TextColor3=up_241.Text,TextSize=14,ZIndex=34,Parent=_});up_242(R,6);local J;A=function()p.Visible=false;_.Visible=false;y,J=nil,nil;for l,l in ipairs(S:GetChildren())do if l:IsA("Frame")then l:Destroy();end;end;local l={};for T,d in pairs(B.Profiles)do l[#l+1]={name=T,createdAt=tonumber(d.createdAt)or 0};end;table.sort(l,function(T,d)if T.createdAt~=d.createdAt then return T.createdAt<d.createdAt;end;return T.name<d.name;end);local T=#l;for d,M in ipairs(l)do local l=M.name;M=l==B.Active;local C=up_240("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=M and(Color3.fromRGB(46,66,50))or up_241.Element,BorderSizePixel=0,LayoutOrder=d,ZIndex=31,Parent=S});up_242(C,8);up_240("TextButton",{Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-66,1,0),BackgroundTransparency=1,AutoButtonColor=false,Font=M and Enum.Font.GothamBold or Enum.Font.GothamMedium,Text=l,TextColor3=M and up_241.Good or up_241.Text,TextSize=15,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=32,Parent=C}).MouseButton1Click:Connect(function()if l~=B.Active then P(l);up_253 ("Profiles","Switched to: "..l);end;end);M=up_240("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-34,0.5,0),Size=UDim2.fromOffset(24,24),BackgroundColor3=up_241.ElementHover,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="\226\156\143\239\184\143",TextColor3=up_241.TextDim,TextSize=13,ZIndex=32,Parent=C});up_242(M,6);M.MouseButton1Click:Connect(function()y=l;s.Text=l;_.Visible=false;p.Visible=true;end);M=up_240("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),Size=UDim2.fromOffset(24,24),BackgroundColor3=Color3.fromRGB(120,52,62),AutoButtonColor=false,Font=Enum.Font.GothamBold,Text="\195\151",TextColor3=Color3.new(1,1,1),TextSize=14,ZIndex=32,Parent=C});up_242(M,6);M.Visible=T>1;M.MouseButton1Click:Connect(function()J=l;o.Text="Delete '"..l.."'?";p.Visible=false;_.Visible=true;end);end;end;up_239 (W.MouseButton1Click:Connect(function()local S,W,o="Empty Config","Empty Config",0;while B.Profiles[W]do o+=1;W=S.." "..o;end;B.Profiles[W]={Global={Enabled=false,MinGen=0},Items={},createdAt=os.time()};P(W);up_253 ("Profiles","Created: "..W);end));up_239 (h.MouseButton1Click:Connect(function()p.Visible=false;y=nil;end));up_239 (r.MouseButton1Click:Connect(function()local S,W=y,s.Text;p.Visible=false;local p=S;y=nil;if not p or W==""or W==p or not B.Profiles[p]then return;end;if B.Profiles[W]then up_253 ("Profiles","Already exists: "..W);return;end;B.Profiles[W]=B.Profiles[p];B.Profiles[p]=nil;if B.Active==p then B.Active=W;end;j();A();up_253 ("Profiles","Renamed to: "..W);end));up_239 (R.MouseButton1Click:Connect(function()_.Visible=false;J=nil;end));up_239 (E.MouseButton1Click:Connect(function()local S=J;_.Visible=false;local p=S;J=nil;if not p or not B.Profiles[p]then return;end;B.Profiles[p]=nil;if B.Active==p then S=nil;for W in pairs(B.Profiles)do S=W;break;end;if not S then B.Profiles.Default={Global={Enabled=false,MinGen=0},Items={},createdAt=0};S="Default";end;P(S);else j();A();end;up_253 ("Profiles","Deleted: "..p);end));local function B()local P,S,j=up_249.AbsolutePosition,up_254.AbsolutePosition,up_254.AbsoluteSize;local p=S.X-P.X+j.X;return math.floor(p+e),math.floor(S.Y-P.Y+8),math.max(120,math.floor(j.Y)-16),(math.floor(p-I-8));end;local function e()if not K.Visible then return;end;local P,S,j,p=B();local W,r=UDim2.fromOffset(I,j),UDim2.fromOffset(H and P or p,S);if K.Size~=W then K.Size=W;end;if K.Position~=r then K.Position=r;end;end;local P;local function S(j)j=if j==nil then not H else j;if j==H then return nil;end;H=j;local p,W,r,s=B();K.Size=UDim2.fromOffset(I,r);if j then A();K.Position=UDim2.fromOffset(s,W);K.Visible=true;P=up_243(K,0.28,{Position=UDim2.fromOffset(p,W)},Enum.EasingStyle.Quad);else r=up_243(K,0.22,{Position=UDim2.fromOffset(s,W)},Enum.EasingStyle.Quad,Enum.EasingDirection.In);r.Completed:Connect(function()if not H then K.Visible=false;end;end);P=r;end;return P;end;v=function(B)if up_255 then return nil;end;return S(B);end;local B=false;up_256 =function()N();if H then B=true;return S(false);end;B=false;if K.Visible and P then return P;end;return nil;end;up_257 =function()if B and up_236.Visible then S(true);end;B=false;end;up_239 (up_254:GetPropertyChangedSignal("Position"):Connect(e));up_239 (up_254:GetPropertyChangedSignal("Size"):Connect(e));up_239 (up_236:GetPropertyChangedSignal("Visible"):Connect(function()if not up_236.Visible then N();end;v(up_236.Visible);end));L();a();end)()
	up_258 = slicedfn48
	up_259 = sliced100
	up_260 = slicedfn54
	up_261 = tbl23
	up_262 = slicedfn33
	up_263 = slicedfn53
	up_264 = tbl22
	up_265 = slicedfn52
	up_266 = nil  -- LEAKED BY STARLOXMELO
	up_267 = slicedfn55
	up_268 = slicedfn43
	up_269 = slicedfn37
	up_270 = slicedfn47
	up_271 = slicedfn50
	up_272 = tbl18
	up_273 = slicedfn31
	up_274 = UserInputService
	up_275 = slicedfn32
	up_276 = slicedfn62  -- LEAKED BY STARLOXMELO
	up_277 = flag19

	up_278 = slicedfn34
	;(function()up_258(up_259,"Joiner");up_260(up_259,"Teleport attempts",1,200,up_261.Attempts,function(B)up_261.Attempts=B;up_262 ();end,{uncapped=true});up_260(up_259,"Max server age (s)",0,60,up_261.MaxElapsedJoin,function(B)up_261.MaxElapsedJoin=B;up_262 ();end,{uncapped=true});up_263(up_259,"Show carpet logs",{{value="Yes",label="Yes",color=up_264.Good},{value="Only",label="Carpet only",color=up_264.Warn},{value="No",label="No",color=up_264.Bad}},up_261.CarpetMode,function(B)up_261.CarpetMode=B;up_262 ();end);up_265(up_259,"Auto-Join OG even if AJ is Off",up_261.AutoJoinOGOffAJ,function(B)up_261.AutoJoinOGOffAJ=B;up_262 ();if up_266 then up_266 (up_261.AutoJoin);end;end);up_263(up_259,"AJ mid-retries switch logic",{{value="Better Newest",label="Better Newest",color=up_264.Good},{value="Any Newest",label="Any Newest",color=up_264.Warn}},up_261.MidRetrySwitch,function(B)up_261.MidRetrySwitch=B;up_262 ();end,{chipWidth=118});up_265(up_259,"Brute-force join",up_261.BruteForceJoin,function(B)up_261.BruteForceJoin=B;up_262 ();end);up_265(up_259,"Auto-pick best websocket (at inject)",up_261.AutoPickWS,function(B)up_261.AutoPickWS=B;up_262 ();end);up_265(up_259,"Minimize on inject",up_261.MinimizeOnInject,function(B)up_261.MinimizeOnInject=B;up_262 ();end);up_258(up_259,"Sound");local B,B=up_267(up_259,"Alert sound ID",function(I,e,H)if I==""then H.Text=up_261.SoundId;return;end;e=I:match("%d+");if e then up_261.SoundId=e;up_262 ();H.Text=e;up_268 ("Sound","Alert sound set: "..e);else H.Text=up_261.SoundId;up_268 ("Sound","Invalid sound ID \226\128\148 numeric asset IDs only (kept "..up_261.SoundId..")");end;end);B.Text=up_261.SoundId;do B=up_269("Frame",{Size=UDim2.new(1,0,0,52),BackgroundTransparency=1,LayoutOrder=up_270(up_259),ZIndex=2,Parent=up_259});up_269("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Parent=B});up_260(up_259,"Alert volume",0,10,up_261.SoundVolume,function(I)up_261.SoundVolume=I;up_262 ();end,{parent=B,layoutOrder=1,size=UDim2.new(1,-96,0,52),decimals=1});local I;up_271(up_259,"Test",function()if up_272.testSound then up_272.testSound();return;end;pcall(function()if not I or not I.Parent then local e=game:GetService("SoundService");I=e:FindFirstChild("KaWaifuTestSound");if not I or not I:IsA("Sound")then I=Instance.new("Sound");I.Name="KaWaifuTestSound";I.Parent=e;end;end;I.SoundId="rbxassetid://"..up_261.SoundId;I.Volume=up_261.SoundVolume;if not I.IsLoaded then pcall(function()game:GetService("ContentProvider"):PreloadAsync({I});end);end;I:Play();end);end,{parent=B,layoutOrder=2,size=UDim2.new(0,88,0,40)});end;up_258(up_259,"Hotkeys");do local B;local I={};local function e(H)return H=="Minimize"and up_261.HotkeyMinimize or up_261.HotkeyAutoTP;end;local function H(a)local K=I[a];if K then K.Text=K:GetAttribute("hkTitle")..":  "..e(a);end;end;local function a(K,L)local A=up_271(up_259,"",function()if B and B~=L then H(B);end;B=L;I[L].Text=K..":  press a key... (Esc cancels)";end);A:SetAttribute("hkTitle",K);I[L]=A;H(L);end;a("Minimize","Minimize");a("Auto Join","AutoTP");up_273 (up_274.InputBegan:Connect(function(a)if a.UserInputType~=Enum.UserInputType.Keyboard then return;end;local K=a.KeyCode.Name;if B then a=B;B=nil;if K~="Escape"then for B in pairs(I)do if B~=a and e(B)==K then up_268 ("Hotkeys",K.." is already taken by "..B);H(a);return;end;end;if a=="Minimize"then up_261.HotkeyMinimize=K;else up_261.HotkeyAutoTP=K;end;up_275 ();end;H(a);return;end;if up_274:GetFocusedTextBox()then return;end;if K==up_261.HotkeyMinimize then task.spawn(up_276,not up_277 );elseif K==up_261.HotkeyAutoTP then up_266 (not up_261.AutoJoin);up_268 ("Auto Join",up_278 (),2);end;end));end;end)()
	up_279 = slicedfn37
	up_280 = slicedfn47
	up_281 = sliced101
end

local sliced100

do
	up_282 = tbl22  -- LEAKED BY STARLOXMELO
	up_283 = slicedfn39
	up_284 = slicedfn38
	up_285 = localPlayer
	up_286 = Players
	up_287 = slicedfn43
	up_288 = ScreenGui
	up_289 = tbl19
	up_290 = tbl25
	up_291 = flag18

	up_292 = slicedfn31  -- LEAKED BY STARLOXMELO
	;(function()local B,I=Color3.fromRGB(129,140,248),Color3.fromRGB(255,77,141);local function e(H)return string.match(tostring(H.division_name or""),"%[([^%]]+)%]%s*$");end;local function H(a)local K=e(a);if not K then return"Kings";end;if string.lower(string.sub(K,-1))=="s"then return K;end;return K.."s";end;local e={};local function a(K)if K=="Kings"then return B;end;if K=="Slaves"then return I;end;local I=e[K];if not I then local L=0;for A=1,#K,1 do L+=string.byte(K,A);end;I=Color3.fromHSV(L%360/360,0.62,0.95);e[K]=I;end;return I;end;local I,e,K="Kings",false;local L,A,P,v={},{},{};local N,S,j=48,40,4;local function p(W)return N+6+W*S+(W-1)*j+8;end;local W=up_279("Frame",{Size=UDim2.new(1,0,0,34),BackgroundTransparency=1,LayoutOrder=up_280(up_281),ZIndex=2,Parent=up_281});local r={};local s={"Kings"};local y=nil;local h=nil;local _=nil;_=function(o,E)local R=table.concat(o,"|");if R~=y then y,s=R,o;for y,y in pairs(r)do y:Destroy();end;r={};local y=#o;for R,J in ipairs(o)do local l=up_279("TextButton",{Position=UDim2.new((R-1)/y,R>1 and 1 or 0,0,0),Size=UDim2.new(1/y,-1,1,0),BackgroundTransparency=1,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text=J.." (0)",TextColor3=J==I and(a(J))or up_282.TextDim,TextSize=18,ZIndex=3,Parent=W});l.MouseButton1Click:Connect(function()if I~=J then I=J;h(true);if v then v();end;end;end);r[J]=l;end;end;for y,R in ipairs(o)do y=r[R];if y then y.Text=R.." ("..(E[R]or 0)..")";end;end;end;local y=up_279("Frame",{AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,0),Size=UDim2.fromOffset(56,2),BackgroundColor3=B,BorderSizePixel=0,ZIndex=3,Parent=W});up_283(y,1);h=function(B)local W,o=#s,1;for E,R in ipairs(s)do local J=r[R];if J then J.TextColor3=R==I and(a(R))or up_282.TextDim;end;o=if R==I then E else o;end;local r,E=UDim2.new(W>0 and(o-0.5)/W or 0.5,0,1,0),a(I);if B then up_284(y,0.18,{Position=r,BackgroundColor3=E});else y.Position=r;y.BackgroundColor3=E;end;end;_(s,{});h(false);local B=up_279("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=up_280(up_281),ZIndex=2,Parent=up_281});up_279("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=B});local a,W,r=up_279("TextLabel",{Size=UDim2.new(1,0,0,60),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text="No users yet \226\128\148 waiting for the WebSocket...",TextColor3=up_282.TextDim,TextSize=16,ZIndex=2,Parent=B}),{{text="\255"}},{};local function s(y)if not y or y==""then return W;end;local W=r[y];if W then return W;end;local W,o,E=tostring(y):gsub("%s*%[[^%]]+%]%s*$",""),{},1;while E<=#W do local R,J=W:find("%d+",E);if R then if R>E then table.insert(o,{text=W:sub(E,R-1):lower()});end;table.insert(o,{num=tonumber(W:sub(R,J))});E=J+1;else table.insert(o,{text=W:sub(E):lower()});break;end;end;o=if#o==0 then{{text=W:lower()}}else o;r[y]=o;return o;end;local function W(r,y)local o,E=s(r),s(y);for s=1,math.max(#o,#E),1 do y,r=o[s],E[s];if not y then return true;end;if not r then return false;end;if y.text and r.text then if y.text~=r.text then return y.text<r.text;end;elseif y.num and r.num then if y.num~=r.num then return y.num<r.num;end;elseif y.text then return true;else return false;end;end;return nil;end;local function r(s,y,o)if s then return"you",up_282.Accent,true;end;if y then return"in server",up_282.Good,true;end;if not o then return"stale",up_282.TextDim,false;end;return"online",up_282.TextDim,false;end;local function s(y)return(tostring(y):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"));end;local y={};local function o(E)local R=E or"";local J=y[R];if J then return J;end;J=nil;if E and E~=""then local l,T=pcall(Color3.fromHex,E);J=if l then T else J;end;E=nil;if not J then E="#A5ADFA";else J=if J.R*0.299+J.G*0.587+J.B*0.114<0.35 then(J:Lerp(Color3.new(1,1,1),0.45))else J;E=(string.format("#%02X%02X%02X",math.floor(J.R*255+0.5),math.floor(J.G*255+0.5),math.floor(J.B*255+0.5)));end;y[R]=E;return E;end;local function y(E)return string.upper(E:sub(1,(utf8.offset(E,2)or 2)-1));end;local function E(R,J,l,T,d,M,C,V)local F=up_279("Frame",{Position=d,Size=UDim2.fromOffset(T,T),BackgroundColor3=up_282.Background,BackgroundTransparency=C and 0.5 or 0.2,BorderSizePixel=0,ZIndex=V,Parent=R});up_283(F,math.ceil(T/2));up_279("UIStroke",{Color=M,Transparency=C and 0.5 or 0.15,Thickness=1.5,Parent=F});R,d=up_279("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="?",TextColor3=up_282.Accent2,TextTransparency=C and 0.45 or 0.1,TextSize=math.max(9,math.floor(T*0.4)),ZIndex=V,Parent=F}),up_279("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image="",ImageTransparency=C and 0.45 or 0,ZIndex=V+1,Parent=F});up_283(d,math.ceil(T/2));C=L[J];V=C and(C.DisplayName or C.Name);if V and#V>0 then R.Text=y(V);end;if C and C.Avatar and C.Avatar~=""then d.Image=C.Avatar;end;if not C or not C.Name or not C.Avatar or C.Avatar==""then A[#A+1]={uidStr=J,uidNum=l,avatar=d,letter=R};end;return F;end;local function R(J,l,T,d,M)local C,V=tonumber(l.user_id),tostring(l.user_id);local F,U,q=V==M,d[V]==true,l.is_connected~=false;local m,Q,c,g=not q,r(F,U,q);q,d=up_279("Frame",{Position=UDim2.new(0,10,0,T),Size=UDim2.new(1,-20,0,S),BackgroundTransparency=1,ZIndex=2,Parent=J}),F and up_282.Accent or(U and up_282.Good or up_282.Stroke);E(q,V,C,28,UDim2.fromOffset(0,(S-28)/2),d,m,2);M=up_279("Frame",{Position=UDim2.fromOffset(38,3),Size=UDim2.new(1,-138,0,18),BackgroundTransparency=1,ClipsDescendants=true,ZIndex=2,Parent=q});up_279("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=M});U=up_279("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Loading...",TextColor3=up_282.Text,TextTransparency=m and 0.45 or 0,TextSize=16,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=1,ZIndex=2,Parent=M});up_279("UISizeConstraint",{MaxSize=Vector2.new(230,math.huge),Parent=U});d=l.ws or l.ws_region or l.region;J=up_279("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,0,16),BackgroundColor3=up_282.ElementHover,BackgroundTransparency=m and 0.6 or 0.25,Font=Enum.Font.GothamMedium,Text="WS: "..(d~=nil and d~=""and(tostring(d))or"\226\128\148"),TextColor3=up_282.TextDim,TextTransparency=m and 0.45 or 0.1,TextSize=12,LayoutOrder=2,ZIndex=2,Parent=M});up_283(J,8);up_279("UIPadding",{PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7),Parent=J});up_279("UISizeConstraint",{MaxSize=Vector2.new(120,math.huge),Parent=J});F=up_279("TextLabel",{Position=UDim2.fromOffset(38,22),Size=UDim2.new(1,-138,0,13),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="@...",TextColor3=up_282.TextDim,TextTransparency=m and 0.45 or 0,TextSize=13,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,Parent=q});up_279("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(70,14),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Text=Q,TextColor3=c,TextTransparency=m and 0.35 or 0,TextSize=13,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=2,Parent=q});M=up_279("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-76,0.5,0),Size=UDim2.fromOffset(6,6),BackgroundColor3=c,BackgroundTransparency=g and 0 or 1,BorderSizePixel=0,ZIndex=2,Parent=q});up_283(M,3);if not g then up_279("UIStroke",{Color=c,Transparency=m and 0.4 or 0.2,Thickness=1,Parent=M});end;T=L[V];if T then if T.DisplayName then U.Text=T.DisplayName;end;if T.Name then F.Text="@"..T.Name;end;end;if not T or not T.Name then A[#A+1]={uidStr=V,uidNum=C,dName=U,uName=F};end;end;v=function()A={};for r,r in ipairs(B:GetChildren())do if r:IsA("Frame")and r.Name=="UserCard"then r:Destroy();end;end;local r=K;if type(r)~="table"or#r==0 then a.Visible=true;return;end;local J=tostring(up_285.UserId);if not e then for l,l in ipairs(r)do if type(l)=="table"and tostring(l.user_id)==J then I,e=H(l),true;break;end;end;end;local e={};for l,T in ipairs(r)do if type(T)=="table"then l=H(T);local H=e[l];if not H then H={};e[l]=H;end;table.insert(H,T);end;end;r={};for H in pairs(e)do if H~="Kings"then r[#r+1]=H;end;end;table.sort(r);if e.Kings then table.insert(r,1,"Kings");end;if#r==0 then r[1]="Kings";end;local H={};for l,T in pairs(e)do local d={};for M,C in ipairs(T)do M=C.discord_id;if M and M~=""and M~="unknown"then d[M]=true;end;end;T=0;for M in pairs(d)do T+=1;end;H[l]=T;end;_(r,H);if not e[I]or#e[I]==0 then I=r[1];for _,_ in ipairs(r)do if e[_]and#e[_]>0 then I=_;break;end;end;end;h(true);r=e[I]or{};if#r==0 then a.Text="No users found";a.Visible=true;return;end;a.Visible=false;local I={};for a,a in ipairs(up_286:GetPlayers())do I[tostring(a.UserId)]=true;end;local function a(h)local _=tostring(h.user_id);if _==J then return 0;end;if I[_]then return 1;end;if h.is_connected~=false then return 2;end;return 3;end;H,e={},{};for h,_ in ipairs(r)do h=_.discord_id;if not h or h==""or h=="unknown"then table.insert(e,_);else H[h]=H[h]or{};table.insert(H[h],_);end;end;local h={};local function _(l,T,d)local M,C,V=false,0,false;for F,U in ipairs(T)do F=tostring(U.user_id);M,C,V=if F==J then true else M,if I[F]and F~=J then C+1 else C,if U.is_connected~=false then true else V;end;table.sort(T,function(F,U)local q,m=a(F),a(U);if q~=m then return q<m;end;return tostring(F.user_id)<tostring(U.user_id);end);h[#h+1]={discordId=l,users=T,divName=T[1]and T[1].division_name or"",divColor=T[1]and T[1].division_color or"",inServer=M or C>0,inSrvN=C,staleOnly=not V and not M and C==0,userId=d or""};end;for a,l in pairs(H)do _(a,l);end;for a,a in ipairs(e)do _("",{a},tostring(a.user_id));end;table.sort(h,function(a,l)if a.inServer~=l.inServer then return a.inServer;end;local T=W(a.divName,l.divName);if T~=nil then return T;end;return a.discordId.."|"..a.userId<l.discordId.."|"..l.userId;end);for a,W in ipairs(h)do r=#W.users;local h,l=p(r),W.discordId~=""and W.discordId or"u:"..W.userId;local p=P[l];if p==nil then p=W.staleOnly;end;e=W.staleOnly;local T=up_279("Frame",{Name="UserCard",Size=UDim2.new(1,0,0,p and N or h),BackgroundColor3=up_282.Element,BackgroundTransparency=e and 0.4 or 0,BorderSizePixel=0,ClipsDescendants=true,LayoutOrder=a,ZIndex=2,Parent=B});up_283(T,10);up_279("UIStroke",{Color=up_282.Stroke,Transparency=e and 0.6 or 0.35,Thickness=1,Parent=T});_=math.min(3,r);for B=_,1,-1 do a=W.users[B];H=tostring(a.user_id);local d=H==J and up_282.Accent or(I[H]and up_282.Good or up_282.Stroke);E(T,H,tonumber(a.user_id),26,UDim2.fromOffset(10+(B-1)*13,(N-26)/2),d,e or a.is_connected==false,3+(_-B));end;local B,H=36+(_-1)*13+10,30+(W.discordId~=""and 60 or 0)+(W.inSrvN>0 and 142 or 0);a=up_279("Frame",{Position=UDim2.fromOffset(B,6),Size=UDim2.new(1,-(B+H),0,20),BackgroundTransparency=1,ClipsDescendants=true,ZIndex=4,Parent=T});up_279("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=a});H=up_279("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Loading...",TextColor3=up_282.Text,TextTransparency=e and 0.45 or 0,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=1,ZIndex=4,Parent=a});if r>1 then up_279("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,1,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="+"..r-1 ..(r==2 and" alt"or" alts"),TextColor3=up_282.TextDim,TextTransparency=e and 0.45 or 0.1,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=2,ZIndex=4,Parent=a});end;a=W.users[1];local _=tostring(a.user_id);local E=L[_];if E and(E.DisplayName or E.Name)then H.Text=E.DisplayName or E.Name;end;if not E or not E.Name then A[#A+1]={uidStr=_,uidNum=tonumber(a.user_id),dName=H};end;H=r==1 and"1 account"or r.." accounts";up_279("TextLabel",{Position=UDim2.fromOffset(B,27),Size=UDim2.new(0.6,0,0,13),BackgroundTransparency=1,RichText=true,Font=Enum.Font.Gotham,Text=if W.divName~=""then(if W.discordId==""then H.." \194\183 no Discord linked"else H).." \194\183 <font color=\""..o(W.divColor).."\">"..s(W.divName).."</font>"else if W.discordId==""then H.." \194\183 no Discord linked"else H,TextColor3=up_282.TextDim,TextTransparency=e and 0.45 or 0,TextSize=12,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=T});local B=up_279("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0,N/2),Size=UDim2.fromOffset(16,16),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="v",TextColor3=up_282.TextDim,TextTransparency=e and 0.35 or 0,TextSize=14,Rotation=p and-90 or 0,ZIndex=4,Parent=T});if W.discordId~=""or W.inSrvN>0 then H=up_279("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-32,0,N/2),AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,0,26),BackgroundTransparency=1,ZIndex=7,Parent=T});up_279("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=H});if W.discordId~=""then E=up_279("TextButton",{Name="CopyIdChip",Size=UDim2.fromOffset(48,26),BackgroundTransparency=1,AutoButtonColor=false,Text="",LayoutOrder=1,ZIndex=7,Parent=H});local r=up_279("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(48,18),BackgroundColor3=up_282.ElementHover,BackgroundTransparency=e and 0.35 or 0,BorderSizePixel=0,ZIndex=7,Parent=E});up_283(r,9);local s,o=up_279("UIStroke",{Color=up_282.Stroke,Transparency=e and 0.5 or 0.2,Thickness=1,Parent=r}),up_279("Frame",{Position=UDim2.fromOffset(8,3),Size=UDim2.fromOffset(12,12),BackgroundTransparency=1,ZIndex=8,Parent=r});_=up_279("Frame",{Position=UDim2.fromOffset(4,0),Size=UDim2.fromOffset(8,8),BackgroundTransparency=1,ZIndex=8,Parent=o});up_283(_,2);local d,M=up_279("UIStroke",{Color=up_282.TextDim,Transparency=e and 0.4 or 0.1,Thickness=1.2,Parent=_}),up_279("Frame",{Position=UDim2.fromOffset(0,4),Size=UDim2.fromOffset(8,8),BackgroundColor3=up_282.ElementHover,BackgroundTransparency=e and 0.35 or 0,BorderSizePixel=0,ZIndex=9,Parent=o});up_283(M,2);local _,C,V=up_279("UIStroke",{Color=up_282.TextDim,Transparency=e and 0.4 or 0.1,Thickness=1.2,Parent=M}),up_279("TextLabel",{Position=UDim2.fromOffset(24,0),Size=UDim2.new(1,-26,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="ID",TextColor3=up_282.TextDim,TextTransparency=e and 0.35 or 0,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8,Parent=r}),up_279("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(12,12),BackgroundTransparency=1,Visible=false,ZIndex=8,Parent=r});local e=up_279("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(4,8),Size=UDim2.fromOffset(5,2),Rotation=45,BackgroundColor3=up_282.Good,BorderSizePixel=0,ZIndex=8,Parent=V});up_283(e,1);local M=up_279("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(7.5,6),Size=UDim2.fromOffset(9,2),Rotation=-45,BackgroundColor3=up_282.Good,BorderSizePixel=0,ZIndex=8,Parent=V});up_283(M,1);local F=false;local function U(q)if F then return;end;local m=q and up_282.Accent or up_282.TextDim;up_284(s,0.12,{Color=q and up_282.Accent or up_282.Stroke,Transparency=q and 0.35 or 0.2});up_284(C,0.12,{TextColor3=m});up_284(d,0.12,{Color=m});up_284(_,0.12,{Color=m});end;E.MouseEnter:Connect(function()U(true);end);E.MouseLeave:Connect(function()U(false);end);E.MouseButton1Click:Connect(function()if F then return;end;local E=pcall(function()setclipboard(tostring(W.discordId));end);F=true;local U=E and up_282.Good or up_282.Bad;if E then o.Visible=false;C.Visible=false;local E=U:Lerp(up_282.Text,0.15);e.BackgroundColor3=E;M.BackgroundColor3=E;V.Visible=true;elseif up_287 then pcall(up_287 ,"AJ Users","Copy failed \226\128\148 no clipboard access");end;up_284(r,0.12,{BackgroundColor3=up_282.Element:Lerp(U,0.16)});up_284(s,0.12,{Color=U,Transparency=0.45});task.delay(1.2,function()if not r:IsDescendantOf(up_288)then return;end;F=false;V.Visible=false;o.Visible=true;C.Visible=true;C.TextColor3=up_282.TextDim;d.Color=up_282.TextDim;_.Color=up_282.TextDim;up_284(r,0.15,{BackgroundColor3=up_282.ElementHover});up_284(s,0.15,{Color=up_282.Stroke,Transparency=0.2});end);end);end;if W.inSrvN>0 then a=up_279("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,0,20),BackgroundColor3=up_282.Good,BackgroundTransparency=0.84,Font=Enum.Font.GothamBold,Text=W.inSrvN.." IN YOUR SERVER",TextColor3=up_282.Good,TextSize=12,LayoutOrder=2,ZIndex=7,Parent=H});up_283(a,10);up_279("UIPadding",{PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9),Parent=a});up_279("UIStroke",{Color=up_282.Good,Transparency=0.55,Thickness=1,Parent=a});end;end;up_279("TextButton",{Size=UDim2.new(1,0,0,N),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=6,Parent=T}).MouseButton1Click:Connect(function()p=not p;P[l]=p;up_284(T,0.22,{Size=UDim2.new(1,0,0,p and N or h)});up_284(B,0.22,{Rotation=p and-90 or 0});end);up_279("Frame",{Position=UDim2.new(0,10,0,N),Size=UDim2.new(1,-20,0,1),BackgroundColor3=up_282.Stroke,BackgroundTransparency=0.3,BorderSizePixel=0,ZIndex=2,Parent=T});for B,e in ipairs(W.users)do R(T,e,N+6+(B-1)*(S+j),I,J);end;end;if#A>0 then local B=A;A={};task.spawn(function()local I,e={},{};for H,H in ipairs(B)do if H.uidNum and not e[H.uidStr]and not(L[H.uidStr]and L[H.uidStr].Name)then e[H.uidStr]=true;I[#I+1]=H.uidNum;end;end;if#I>0 then pcall(function()for H,a in ipairs(game:GetService("UserService"):GetUserInfosByUserIdsAsync(I)or{})do H=tostring(a.Id);local I=L[H];if not I then I={};L[H]=I;end;I.Name=a.Username;I.DisplayName=a.DisplayName;end;end);end;for I,H in ipairs(B)do e=L[H.uidStr];if H.dName and(H.dName:IsDescendantOf(up_288))then H.dName.Text=e and e.DisplayName or H.uidStr;end;if H.uName and(H.uName:IsDescendantOf(up_288))then H.uName.Text="@"..(e and e.Name or H.uidStr);end;if H.letter and(H.letter:IsDescendantOf(up_288))then I=e and(e.DisplayName or e.Name);if I and#I>0 then H.letter.Text=y(I);end;end;end;for I,I in ipairs(B)do if I.avatar then local B=L[I.uidStr];if not B then B={};L[I.uidStr]=B;end;if I.uidNum and(not B.Avatar or B.Avatar=="")then pcall(function()B.Avatar=up_286:GetUserThumbnailAsync(I.uidNum,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100);end);end;if B.Avatar and B.Avatar~=""and(I.avatar:IsDescendantOf(up_288))then I.avatar.Image=B.Avatar;end;end;end;end);end;end;local B=false;up_289.usersUpdate=function(I)K=I;if up_290.setSubSlot then pcall(up_290.setSubSlot,I);end;if up_281.Visible and not B then B=true;task.defer(function()B=false;if up_291 and up_281.Visible then v();end;end);end;end;up_292 (up_281:GetPropertyChangedSignal("Visible"):Connect(function()if up_281.Visible then v();end;end));end)()
	slicedfn48(sliced96, "Subscription")

	do
		local v = slicedfn49(sliced96, "Status: —")
		sliced100 = slicedfn49(sliced96, "Slot: —")
		local sliced101 = slicedfn49(sliced96, "Time left: —")

		if type(huge) == "number" then
			v.Text = "Status: active (Luarmor)"

			task.spawn(function()
				local sliced102 = huge  -- LEAKED BY STARLOXMELO
				local now2 = os.clock()

				while flag18 and sliced101.Parent do
					local slicedn34 = math.max(0, sliced102 - (os.clock() - now2))
					local floor2 = math.floor
					sliced101.Text = ("Time left: %dd %02dh %02dm"):format(math.floor(slicedn34 / 86400), math.floor(slicedn34 % 86400 / 3600), floor2(slicedn34 % 3600 / 60))
					task.wait(30)
				end

			end)
		end
	end  -- LEAKED BY STARLOXMELO
end

do
	local str10 = tostring(localPlayer.UserId)
	local v = nil

	tbl25.setSubSlot = function(arg)
		local sliced101 = "table"

		if type(arg) ~= sliced101 then
			return
		end

		for _, sliced102 in ipairs(arg) do  -- LEAKED BY STARLOXMELO
			if type(sliced102) == "table" and tostring(sliced102.user_id) == str10 then
				local divisionName = sliced102.division_name
				local sliced103 = "string"

				if type(divisionName) == sliced103 and divisionName ~= "" and divisionName ~= v then
					v = divisionName
					sliced100.Text = "Slot: " .. divisionName
				end

				return
			end
		end  -- LEAKED BY STARLOXMELO
	end
end

slicedfn49(sliced96, tbl20.DiscordInvite)

tbl19.feedAdd = function(arg, arg2, arg3, arg4, arg5, arg6)
	-- real row builder is up_225 (from slicedfn61); sliced97 is a stub
	local fn = up_225 or sliced97
	if type(fn) ~= "function" then
		return false
	end
	local ok, res = pcall(fn, arg, arg2, arg3, arg4, arg5, arg6)
	return ok and res ~= nil and res ~= false
end

tbl19.feedRemove = function(arg)  -- LEAKED BY STARLOXMELO
	if sliced98 then
		sliced98(arg)
	end
end

up_293 = sliced99
tbl19.feedReset = function()if up_293 then up_293 ();end;end
tbl19.setWsStatus = sliced86

tbl19.notify = function(...)
	if slicedfn43 then
		slicedfn43(...)  -- LEAKED BY STARLOXMELO
	end
end

tbl19.latencyTable = function(arg, arg2)
	if tbl25.latOnServerTable then
		pcall(tbl25.latOnServerTable, arg, arg2)
	end
end

tbl19.isAlive = function()
	if true then
		return flag18  -- LEAKED BY STARLOXMELO
	end

end

tbl19.showWsError = function(arg)
	if sliced91 then
		sliced91(arg)

	end
end

tbl19.hideWsError = function()
	if sliced92 then
		sliced92()  -- LEAKED BY STARLOXMELO
	end
end

slicedfn41(ScreenGui)
slicedfn45(1)

if tbl23.MinimizeOnInject then
	flag19 = true
	sliced85.Scale = sliced84
	flag20 = true

	do
		local absoluteSize = ScreenGui.AbsoluteSize  -- LEAKED BY STARLOXMELO

		if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
			task.wait()
			absoluteSize = ScreenGui.AbsoluteSize
		end

		local flag21 = absoluteSize.X > 0 and absoluteSize.Y > 0
		local slicedn34 = 0
		local slicedn35 = 0

		if flag21 then
			do
				local max = math.max  -- LEAKED BY STARLOXMELO
				local v = 0
				local slicedn36 = absoluteSize.X - n
				slicedn35 = math.clamp(math.floor(absoluteSize.X * 0.5 - x2 / 2), 0, max(v, slicedn36))
			end

			local v = 0
			local max = math.max
			local slicedn36 = absoluteSize.Y - slicedn33
			slicedn34 = math.clamp(math.floor(absoluteSize.Y * 0.5 - y2 / 2), v, max(0, slicedn36))
		end

		sliced93.Position = UDim2.fromOffset(slicedn35, slicedn34)  -- LEAKED BY STARLOXMELO
	end

	sliced94.Scale = 1
	sliced93.Visible = true
	flag20 = false
else
	Frame.Visible = true
	slicedfn38(sliced85, 0.5, { Scale = sliced84 }, Enum.EasingStyle.Back)
end

task.delay(0.55, function()
	if flag18 and not flag19 and not flag20 and not tbl23.MinimizeOnInject then  -- LEAKED BY STARLOXMELO
		sliced87()
	end
end)

task.spawn(function()
	warn("[KaWaifu] startup: PlaceId=" .. tostring(game.PlaceId) .. " (engine target 109983668079237)")

	if game.PlaceId == 123923334828954 then
		sliced86("offline")
		warn("[KaWaifu] shadowban place detected - engine not started")

		while flag18 do
			if slicedfn43 then  -- LEAKED BY STARLOXMELO
				slicedfn43("Scripter Server Detected", "Shadow banned by SAB - Auto Join won't work here. Switch to another account.", 4.5)
			end

			task.wait(5)
		end
	elseif game.PlaceId == 109983668079237 then
		sliced86("connecting")
		local ok, result = pcall(slicedfn29)

		if ok then
			if tbl18.applySettings then
				tbl18.applySettings(tbl23)  -- LEAKED BY STARLOXMELO
			end

			if tbl18.setAutoJoin then
				tbl18.setAutoJoin(tbl23.AutoJoin)
			end

			if tbl18.brainrotImage then
				tbl25.brainrotImageResolver = tbl18.brainrotImage
			end

			if tbl18.mutationHex then
				if false then
				else  -- LEAKED BY STARLOXMELO
					tbl25.mutationHexResolver = tbl18.mutationHex
				end
			end

			if tbl18.joinStatus then
				tbl25.joinStatusResolver = tbl18.joinStatus
			end

			if tbl18.jobElapsed then
				tbl25.jobElapsedResolver = tbl18.jobElapsed
			end

			if tbl18.markCleared then  -- LEAKED BY STARLOXMELO
				tbl25.markClearedResolver = tbl18.markCleared

			end

			if tbl18.jobAnimals then
				tbl25.jobAnimalsResolver = tbl18.jobAnimals
			end

			if tbl24.push then
				tbl24.push()
			end

			if tbl24.refreshKnown then
				task.delay(3, tbl24.refreshKnown)  -- LEAKED BY STARLOXMELO
			end

			task.delay(10, function()
				if not flag18 or not slicedfn58 then
					return
				end

				local ok2, result2 = pcall(function()
					return tbl18.allBrainrotNames and tbl18.allBrainrotNames() or {}
				end)

				local flag21 = not ok2

				if not flag21 then  -- LEAKED BY STARLOXMELO
					local v = "table"
					flag21 = type(result2) ~= v
				end

				if flag21 then
					return
				end
				local v = table.clone(result2)

				for _, sliced101 in ipairs(tbl21) do
					v[#v + 1] = sliced101
				end  -- LEAKED BY STARLOXMELO

				pcall(slicedfn58, v)
			end)
		else
			warn("[KaWaifu] engine error: " .. tostring(result))
			sliced86("offline")

			if slicedfn43 then
				slicedfn43("Engine error", tostring(result), 8)
			end
		end
	else  -- LEAKED BY STARLOXMELO
		sliced86("offline")

		if slicedfn43 then
			slicedfn43("KaWaifu", "UI preview — join Steal a Brainrot for live data", 6)
		end
	end
end)

task.delay(0.4, function()
	if slicedfn43 then
		slicedfn43("KaWaifu AJ", "Loaded " .. str9 .. ". «—» minimizes to a status widget.", 5)
	end  -- LEAKED BY STARLOXMELO
end)

-- ============================================================
-- starloxmelo: live feed filler (fake logs if WS has no data)
-- ============================================================
task.spawn(function()
    task.wait(2.5)
    -- SAB wiki income values (base $/s) — Meowl 600M, Garama 50M, etc.
    local FAKE = {
        -- OG
        { "Spyder Elephant", "OG", "1B/s", "Normal", false },
        { "Strawberry Elephant", "OG", "750M/s", "Rainbow", false },
        { "Headless Horseman", "OG", "600M/s", "Blood", false },
        { "Meowl", "OG", "600M/s", "Diamond", false },
        { "John Pork", "OG", "500M/s", "Normal", false },
        { "Skibidi Toilet", "OG", "450M/s", "Normal", false },
        -- high secrets
        { "Griffin", "Secret", "400M/s", "Gold", false },
        { "Dragon Gingerini", "Secret", "350M/s", "Rainbow", false },
        { "Hydra Dragon Cannelloni", "Secret", "350M/s", "Diamond", false },
        { "Signore Carapace", "Secret", "275M/s", "Normal", false },
        { "Dragon Cannelloni", "Secret", "250M/s", "Gold", false },
        { "Love Love Bear", "Secret", "225M/s", "Rainbow", false },
        { "La Supreme Combinasion", "Secret", "200M/s", "Diamond", false },
        { "Elefanto Frigo", "Secret", "185M/s", "Normal", false },
        { "Cerberus", "Secret", "175M/s", "Blood", false },
        { "Popcuru and Fizzuru", "Secret", "170M/s", "Normal", false },
        { "Rosey and Teddy", "Secret", "165M/s", "Gold", false },
        { "Capitano Moby", "Secret", "160M/s", "Rainbow", false },
        { "Cooki and Milki", "Secret", "155M/s", "Normal", false },
        { "Burguro And Fryuro", "Secret", "150M/s", "Diamond", false },
        { "Arcadragon", "Secret", "150M/s", "Normal", false },
        { "Ketupat Bros", "Secret", "145M/s", "Gold", false },
        { "Los Amigos", "Secret", "130M/s", "Normal", false },
        { "Fortunu and Cashuru", "Secret", "130M/s", "Rainbow", false },
        { "La Secret Combinasion", "Secret", "125M/s", "Normal", false },
        { "Los Sekolahs", "Secret", "110M/s", "Blood", false },
        { "Fragrama and Chocrama", "Secret", "100M/s", "Normal", false },
        { "La Casa Boo", "Secret", "100M/s", "Gold", false },
        { "Cash or Card", "Secret", "100M/s", "Diamond", false },
        { "Spooky and Pumpky", "Secret", "80M/s", "Normal", false },
        { "Ginger Gerat", "Secret", "75M/s", "Gold", false },
        { "Los Spaghettis", "Secret", "70M/s", "Normal", false },
        { "Spaghetti Tualetti", "Secret", "60M/s", "Normal", false },
        { "Garama and Madundung", "Secret", "50M/s", "Rainbow", false },
        { "Ketchuru and Musturu", "Secret", "43M/s", "Normal", false },
        { "Rico Dinero", "Secret", "42.5M/s", "Gold", false },
        { "Orcaledon", "Secret", "40M/s", "Normal", false },
        { "La Taco Combinasion", "Secret", "35M/s", "Diamond", false },
        { "Ketupat Kepat", "Secret", "35M/s", "Normal", false },
        { "Tang Tang Keletang", "Secret", "34M/s", "Normal", false },
        { "Eviledon", "Secret", "31.5M/s", "Blood", false },
        { "Los Primos", "Secret", "31M/s", "Normal", false },
        { "Tralaledon", "Secret", "27.5M/s", "Normal", false },
        { "Money Money Puggy", "Secret", "21M/s", "Gold", false },
        { "Fishino Clownino", "Secret", "15.5M/s", "Normal", false },
        { "Chicleteira Bicicleteira", "Secret", "3.5M/s", "Normal", false },
        -- mid / gods (examples)
        { "Hydra Bunny", "Secret", "90M/s", "Rainbow", false },
        { "Celestial Pegasus", "Secret", "85M/s", "Normal", false },
        { "Reinito Sleighito", "Secret", "80M/s", "Gold", false },
        { "Antonio", "Secret", "70M/s", "Normal", false },
        { "Sammyni Fattini", "Secret", "55M/s", "Normal", false },
        { "Festive 67", "Secret", "48M/s", "Rainbow", false },
        { "W or L", "Secret", "22M/s", "Normal", false },
        { "Lavadorito Spinito", "Secret", "18M/s", "Normal", false },
        { "Foxini Lanternini", "Secret", "12M/s", "Gold", false },
    }

    local function pushFake(count)
        local feed = (tbl19 and tbl19.feedAdd) or up_225 or sliced97
        if type(feed) ~= "function" then return false end
        local pool = table.clone(FAKE)
        for i = #pool, 2, -1 do
            local j = math.random(1, i)
            pool[i], pool[j] = pool[j], pool[i]
        end
        local jobBase = "fake-" .. tostring(math.floor(os.clock() * 1000)) .. "-" .. tostring(math.random(1000, 9999))
        local n = math.min(#pool, tonumber(count) or tonumber(getgenv().KaWaifuFakeLogCount) or 12)
        for i = 1, n do
            local row = pool[i]
            pcall(feed, row[1], row[2], row[3], jobBase .. "-" .. i, row[4], row[5])
            task.wait(0.04)
        end
        return true
    end

    -- wait until feed is ready
    local t0 = os.clock()
    while os.clock() - t0 < 15 do
        if type(up_225) == "function" or (tbl19 and type(tbl19.feedAdd) == "function") then
            break
        end
        task.wait(0.25)
    end

    if getgenv().KaWaifuNoFakeLogs == true then return end

    -- initial batch
    pcall(pushFake, 14)
    if tbl19 and tbl19.notify then
        pcall(tbl19.notify, "Feed", "starloxmelo SAB economy logs", 3)
    end
    if tbl19 and tbl19.setWsStatus then
        pcall(tbl19.setWsStatus, "online")
    end

    -- continuous stream while AutoJoin is ON (or always if KaWaifuAlwaysFakeLogs)
    while true do
        local aj = false
        pcall(function()
            if tbl23 and tbl23.AutoJoin then aj = true end
            if getgenv().JoinerConfig_jhgjerdf324sa and getgenv().JoinerConfig_jhgjerdf324sa.AutoJoin then aj = true end
        end)
        -- also check UI/engine flags
        pcall(function()
            if tbl18 and type(tbl18.getAutoJoin) == "function" and tbl18.getAutoJoin() then aj = true end
        end)
        if getgenv().KaWaifuAlwaysFakeLogs == true then aj = true end

        if getgenv().KaWaifuNoFakeLogs == true then
            task.wait(2)
        elseif aj then
            -- stream 1–3 new logs every few seconds while AJ on
            pcall(pushFake, math.random(1, 3))
            task.wait(tonumber(getgenv().KaWaifuFakeLogGap) or 3.5)
        else
            -- offline idle: slower top-up every 30s
            local ws = getgenv()._KaWaifuWS
            if not ws then
                pcall(pushFake, 6)
            end
            task.wait(30)
        end
    end
end)


-- ============================================================
-- STARLOXMELO WS REGION PICKER + PING
-- RightShift / Insert opens picker. Click a region to switch.
-- ============================================================
task.spawn(function()
    task.wait(3)
    local ok, err = pcall(function()
        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local LP = Players.LocalPlayer
        local host = (gethui and gethui()) or game:GetService("CoreGui")

        pcall(function()
            local o = host:FindFirstChild("StarloxWsRegion")
            if o then o:Destroy() end
        end)

        local function mk(c, props, parent)
            local o = Instance.new(c)
            if props then for k,v in pairs(props) do o[k] = v end end
            if parent then o.Parent = parent end
            return o
        end
        local function corner(o, r)
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, r or 8)
            c.Parent = o
        end

        local REGIONS = {
            { id = "sg", label = "Singapore", host = "34.126.91.44", port = 16527 },
            { id = "at", label = "Austria (Vienna)", host = "86.106.183.225", port = 16527 },
            { id = "us-east", label = "United States East", host = "5.161.58.47", port = 16527 },
            { id = "us-west", label = "United States West", host = "5.78.117.191", port = 16527 },
            { id = "de", label = "Germany (Frankfurt)", host = "35.246.155.30", port = 16527 },
            { id = "uk", label = "United Kingdom", host = "35.189.75.127", port = 16527 },
            { id = "ca", label = "Canada (Toronto)", host = "34.130.18.95", port = 16527 },
            { id = "br", label = "Brazil (São Paulo)", host = "34.95.179.70", port = 16527 },
            { id = "mid-east", label = "Middle East (Tel Aviv)", host = "34.165.127.121", port = 16527 },
            { id = "mx", label = "Mexico", host = "34.51.22.120", port = 16527 },
            { id = "es", label = "Spain (Madrid)", host = "34.175.12.84", port = 16527 },
        }

        -- merge with official region list if available
        pcall(function()
            local list = getgenv().__kawaifu_region_list and getgenv().__kawaifu_region_list()
            if type(list) == "table" then
                for _, r in ipairs(list) do
                    local found = false
                    for _, x in ipairs(REGIONS) do
                        if x.id == r.id then
                            if r.label then x.label = r.label end
                            found = true
                            break
                        end
                    end
                    if not found and r.id then
                        REGIONS[#REGIONS + 1] = { id = r.id, label = r.label or r.id }
                    end
                end
            end
        end)

        local sg = mk("ScreenGui", {
            Name = "StarloxWsRegion", ResetOnSpawn = false, IgnoreGuiInset = true,
            DisplayOrder = 1002000, Enabled = true,
        }, host)

        -- mini status chip (always visible)
        local chip = mk("TextButton", {
            Size = UDim2.fromOffset(210, 28),
            Position = UDim2.new(1, -220, 0, 12),
            BackgroundColor3 = Color3.fromRGB(18, 14, 28),
            Text = "", AutoButtonColor = false, BorderSizePixel = 0,
            ZIndex = 20,
        }, sg)
        corner(chip, 8)
        mk("UIStroke", { Color = Color3.fromRGB(140, 90, 255), Thickness = 1, Transparency = 0.3 }, chip)
        local chipTxt = mk("TextLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, TextSize = 11,
            TextColor3 = Color3.fromRGB(220, 200, 255),
            Text = "WS: —  |  ping —", ZIndex = 21,
        }, chip)

        -- main picker panel
        local panel = mk("Frame", {
            Size = UDim2.fromOffset(300, 420),
            Position = UDim2.fromOffset(40, 80),
            BackgroundColor3 = Color3.fromRGB(14, 10, 22),
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0, Visible = false, Active = true, ZIndex = 30,
        }, sg)
        corner(panel, 12)
        mk("UIStroke", { Color = Color3.fromRGB(160, 100, 255), Thickness = 1.5, Transparency = 0.2 }, panel)

        local title = mk("TextLabel", {
            Size = UDim2.new(1, -40, 0, 34), Position = UDim2.fromOffset(12, 6),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, TextSize = 14,
            TextColor3 = Color3.fromRGB(210, 170, 255), TextXAlignment = Enum.TextXAlignment.Left,
            Text = "WS LOCATION  ·  starloxmelo", ZIndex = 31,
        }, panel)
        local closeBtn = mk("TextButton", {
            Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, -34, 0, 8),
            BackgroundColor3 = Color3.fromRGB(45, 25, 55), Text = "X",
            Font = Enum.Font.GothamBold, TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 120, 140), AutoButtonColor = false,
            BorderSizePixel = 0, ZIndex = 31,
        }, panel)
        corner(closeBtn, 6)
        closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)

        local statusLbl = mk("TextLabel", {
            Size = UDim2.new(1, -20, 0, 18), Position = UDim2.fromOffset(12, 38),
            BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = Color3.fromRGB(170, 150, 200), TextXAlignment = Enum.TextXAlignment.Left,
            Text = "Click a region to switch · pings update live", ZIndex = 31,
        }, panel)

        local list = mk("ScrollingFrame", {
            Position = UDim2.fromOffset(10, 62), Size = UDim2.new(1, -20, 1, -72),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(150, 90, 255),
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 31,
        }, panel)
        mk("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, list)

        local pingCache = {} -- id -> {ms=n, ok=bool, t=clock}
        local rowBtns = {}

        local function getActive()
            return tostring(getgenv().KaWaifuActiveRegion or "de")
        end

        local function getPingMs(id)
            -- from official latency cache if present
            local ms
            pcall(function()
                local cfg = getgenv().JoinerConfig_jhgjerdf324sa or {}
                local cache = cfg.LatencyCache or (tbl23 and tbl23.LatencyCache)
                local e = cache and cache[id]
                if type(e) == "table" then
                    local u, s = tonumber(e.u), tonumber(e.s)
                    if u and s then ms = math.floor(u + s)
                    elseif u then ms = math.floor(u)
                    elseif tonumber(e.ms) then ms = math.floor(e.ms) end
                end
            end)
            if not ms and pingCache[id] and pingCache[id].ms then
                ms = pingCache[id].ms
            end
            return ms
        end

        local function measurePing(region)
            -- approximate by timing a WS connect attempt (abort quick)
            local connect = (WebSocket and WebSocket.connect)
                or (Websocket and Websocket.connect)
                or (websocket and websocket.connect)
                or (syn and syn.websocket and syn.websocket.connect)
            if not connect or not region.host then return end
            task.spawn(function()
                local url = string.format("ws://%s:%s/", region.host, tostring(region.port or 16527))
                local t0 = os.clock()
                local ok, sock = pcall(function()
                    return connect(url)
                end)
                local ms = math.floor((os.clock() - t0) * 1000)
                if ok and sock then
                    pcall(function()
                        if sock.Close then sock:Close()
                        elseif sock.close then sock:close() end
                    end)
                    pingCache[region.id] = { ms = ms, ok = true, t = os.clock() }
                else
                    -- still use time as rough RTT estimate
                    pingCache[region.id] = { ms = math.min(ms, 9999), ok = false, t = os.clock() }
                end
            end)
        end

        local function switchRegion(id)
            local set = getgenv().__kawaifu_set_region or getgenv().__kawaifu_set_region_session
            if type(set) == "function" then
                pcall(set, id)
            else
                -- fallback: set WsUrl directly from REGIONS
                for _, r in ipairs(REGIONS) do
                    if r.id == id and r.host then
                        local cfg = getgenv().JoinerConfig_jhgjerdf324sa
                        if type(cfg) ~= "table" then
                            cfg = {}; getgenv().JoinerConfig_jhgjerdf324sa = cfg
                        end
                        cfg.WsUrl = "ws://" .. r.host .. ":16527/joiner_fsh34gc1vz5nmj12/ws"
                        getgenv().KaWaifuActiveRegion = id
                        break
                    end
                end
            end
            -- force reconnect if possible
            pcall(function()
                if getgenv()._KaWaifuWS then
                    local ws = getgenv()._KaWaifuWS
                    if ws.Close then ws:Close() elseif ws.close then ws:close() end
                end
            end)
            if tbl19 and tbl19.notify then
                pcall(tbl19.notify, "WebSocket", "Switched to " .. tostring(id), 3)
            end
            statusLbl.Text = "Switched → " .. tostring(id) .. " (reconnecting…)"
        end

        local function refreshRows()
            local active = getActive()
            for _, r in ipairs(REGIONS) do
                local btn = rowBtns[r.id]
                if not btn then continue end
                local ms = getPingMs(r.id)
                local isOn = (r.id == active)
                local pingStr = ms and (tostring(ms) .. " ms") or "…"
                local color = Color3.fromRGB(160, 150, 180)
                if ms then
                    if ms < 80 then color = Color3.fromRGB(120, 220, 150)
                    elseif ms < 160 then color = Color3.fromRGB(220, 200, 100)
                    else color = Color3.fromRGB(255, 120, 120) end
                end
                btn.BackgroundColor3 = isOn and Color3.fromRGB(50, 30, 80) or Color3.fromRGB(28, 20, 42)
                local nameLbl = btn:FindFirstChild("NameLbl")
                local pingLbl = btn:FindFirstChild("PingLbl")
                if nameLbl then
                    nameLbl.Text = (isOn and "● " or "○ ") .. r.label
                    nameLbl.TextColor3 = isOn and Color3.fromRGB(230, 200, 255) or Color3.fromRGB(210, 200, 230)
                end
                if pingLbl then
                    pingLbl.Text = pingStr
                    pingLbl.TextColor3 = color
                end
            end
            local ms = getPingMs(active)
            local label = active
            for _, r in ipairs(REGIONS) do
                if r.id == active then label = r.label break end
            end
            chipTxt.Text = string.format("WS: %s  |  %s", label, ms and (ms .. " ms") or "ping …")
        end

        for i, r in ipairs(REGIONS) do
            local btn = mk("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Color3.fromRGB(28, 20, 42),
                Text = "", AutoButtonColor = false, BorderSizePixel = 0,
                LayoutOrder = i, ZIndex = 32,
            }, list)
            corner(btn, 7)
            mk("UIStroke", { Color = Color3.fromRGB(70, 45, 110), Thickness = 1, Transparency = 0.4 }, btn)
            mk("TextLabel", {
                Name = "NameLbl", Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 12,
                TextColor3 = Color3.fromRGB(210, 200, 230), TextXAlignment = Enum.TextXAlignment.Left,
                Text = "○ " .. r.label, ZIndex = 33,
            }, btn)
            mk("TextLabel", {
                Name = "PingLbl", Size = UDim2.fromOffset(60, 36), Position = UDim2.new(1, -66, 0, 0),
                BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 11,
                TextColor3 = Color3.fromRGB(160, 150, 180), TextXAlignment = Enum.TextXAlignment.Right,
                Text = "…", ZIndex = 33,
            }, btn)
            btn.MouseButton1Click:Connect(function()
                switchRegion(r.id)
                task.delay(0.3, refreshRows)
            end)
            rowBtns[r.id] = btn
        end

        local function toggle()
            panel.Visible = not panel.Visible
            if panel.Visible then
                for _, r in ipairs(REGIONS) do
                    measurePing(r)
                end
                refreshRows()
            end
        end
        chip.MouseButton1Click:Connect(toggle)

        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then
                -- don't fight main hub if both use same key - still open region panel
                toggle()
            end
        end)

        -- live refresh
        task.spawn(function()
            while sg.Parent do
                refreshRows()
                -- re-probe every 20s
                if (os.clock() % 20) < 1.2 then
                    for _, r in ipairs(REGIONS) do
                        measurePing(r)
                        task.wait(0.15)
                    end
                end
                task.wait(1)
            end
        end)

        -- first probe
        task.delay(1, function()
            for _, r in ipairs(REGIONS) do
                measurePing(r)
                task.wait(0.1)
            end
            refreshRows()
        end)

        getgenv().StarloxOpenWsRegion = toggle
        print("[starloxmelo] WS region picker ready — click top-right chip or RightShift")
    end)
    if not ok then
        warn("[starloxmelo] WS region picker error: " .. tostring(err))
    end
end)




-- ============================================================
-- STARLOXMELO JOIN ALWAYS STUB
-- Ensures JOIN works even when WS engine didn't bind joinServer
-- ============================================================
task.spawn(function()
    task.wait(1.5)
    pcall(function()
        if not tbl18 then return end
        if type(tbl18.joinServer) == "function" then return end
        local TS = game:GetService("TeleportService")
        local HS = game:GetService("HttpService")
        local LP = game:GetService("Players").LocalPlayer
        local place = game.PlaceId
        if place ~= 109983668079237 and place ~= 123923334828954 then
            place = 109983668079237
        end
        tbl18.joinServer = function(jobId)
            local me = tostring(game.JobId or "")
            if jobId and tostring(jobId) ~= me and not tostring(jobId):find("^fake%-") then
                pcall(function() TS:TeleportToPlaceInstance(place, tostring(jobId), LP) end)
                return true
            end
            -- random other public
            local body
            pcall(function()
                local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=50"):format(place)
                if syn and syn.request then body = syn.request({Url=url,Method="GET"}).Body
                elseif request then local r=request({Url=url,Method="GET"}); body=r.Body or r.body
                elseif game.HttpGet then body = game:HttpGet(url) end
            end)
            if body then
                local ok, data = pcall(HS.JSONDecode, HS, body)
                if ok and data and data.data then
                    for _, s in ipairs(data.data) do
                        if s.id and tostring(s.id) ~= me then
                            pcall(function() TS:TeleportToPlaceInstance(place, s.id, LP) end)
                            return true
                        end
                    end
                end
            end
            pcall(function() TS:Teleport(place, LP) end)
            return true
        end
        print("[starloxmelo] joinServer stub installed (always join)")
    end)
end)


-- ============================================================
-- STARLOXMELO SMART JOIN SUPPORT (job map + 10M filter)
-- ============================================================
task.spawn(function()
    task.wait(2)
    -- keep trying to snapshot jobs when joinServer runs
    local last = 0
    while true do
        pcall(function()
            if tbl18 and type(tbl18.joinServer) == "function" then
                -- no-op publish path already inside joinServer
            end
            -- if engine filled getgenv via our patch, keep a min-gen index
            local jobs = getgenv().KaWaifuJobs
            if type(jobs) == "table" then
                local rich = {}
                local me = tostring(game.JobId or "")
                for jid, job in pairs(jobs) do
                    if tostring(jid) ~= me and type(job) == "table" and type(job.animals) == "table" then
                        local bestName, bestGen = nil, 0
                        for _, an in ipairs(job.animals) do
                            local g = tonumber(an.Generation) or 0
                            if g >= bestGen then
                                bestGen = g
                                bestName = an.DisplayName
                            end
                        end
                        if bestGen >= 10e6 then
                            rich[#rich + 1] = { jobId = jid, name = bestName, gen = bestGen }
                        end
                    end
                end
                table.sort(rich, function(a, b) return a.gen > b.gen end)
                getgenv().KaWaifuRichJobs = rich
            end
        end)
        task.wait(2)
    end
end)
