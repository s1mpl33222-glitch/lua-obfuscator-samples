-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
("This file was protected with MoonSec V3"):gsub(".+", function(p1) --[[ Line: 2 ]]
	_vjrPHuPaUEvw = p1
end)

local function f1(p1, ...) --[[ Line: 2 ]]
	local count = 0
	local v1 = 24915
	local t = {}
	local v2 = nil
	local v3 = nil
	local v4 = nil
	local v5 = nil
	local v6 = nil
	local v7 = nil

	while count < 347 do
		count = count + 1

		while count < 679 and v1 % 9932 < 4966 do
			count = count + 1

			local v8 = (v1 + 304) % 46620

			if v8 % 6360 >= 3180 then
				v1 = (v8 + 13) % 11626

				while count < 442 and v1 % 3580 < 1790 do
					count = count + 1

					local v9 = (v1 - 726) % 36887

					if v9 % 19932 < 9966 then
						v1 = (v9 - 394) % 23845

						if t[85106] then
							continue
						end

						t[85106] = 1
						v6 = "\4\8tonumberaLLfCxVU\0\6string\4charFElsvIEl\0\6string\3subLchSehUn\0\6string\4bytekrihFPGC\0\5table\6concatDO_bcaYV\0\5table\6insertIFbmkuUY\5"
					else
						if v9 % 2 == 0 then
							v1 = (v9 + 850) % 42408
							count = count + 1

							if t[62906] then
								continue
							end

							t[62906] = 1
							v5 = function(p12) --[[ Line: 2 | Upvalues: v2 (ref), v3 (ref), v4 (ref), p1 (copy) ]]
								local v1 = 1

								local function k(p1) --[[ k | Line: 2 | Upvalues: v1 (ref), p12 (copy) ]]
									v1 = v1 + p1

									return p12:sub(v1 - p1, v1 - 1)
								end

								while true do
									local v22 = k(1)

									if v22 == "\5" then
										break
									end

									local v32 = k((v2.byte(k(1))))

									if v22 == "\2" then
										v32 = v3.aLLfCxVU(v32)
									elseif v22 == "\3" then
										v32 = v32 ~= "\0"
									elseif v22 == "\6" then
										v4[v32] = function(p12, p2) --[[ Line: 2 | Upvalues: p1 (ref) ]]
											return p1(8, nil, p1, p2, p12)
										end
									elseif v22 == "\4" then
										v32 = v4[v32]
									elseif v22 == "\0" then
										v32 = v4[v32][k(v2.byte(k(1)))]
									end

									v3[k(8)] = v32
								end
							end

							continue
						end

						v1 = v9 * 1012 % 14374

						if t[71920] then
							continue
						end

						t[71920] = 1
						v4 = if v4 then v4 else _ENV or v4
					end
				end
			else
				if v8 % 2 == 0 then
					count = count + 1
					v1 = (v8 - 448) % 11404

					while count < 421 and v1 % 11420 < 5710 do
						count = count + 1

						local v11 = (v1 - 611) % 9157

						if v11 % 15350 <= 7675 then
							v1 = (v11 + 979) % 14868

							if t[21287] then
								continue
							end

							t[21287] = 1
							v7 = tonumber
						else
							if v11 % 2 == 0 then
								v1 = (v11 + 41) % 6272
								count = count + 1

								if t[48402] then
									continue
								end

								t[48402] = 1

								continue
							end

							v1 = (v11 + 458) % 31039

							if t[90279] then
								continue
							end

							t[90279] = 1
						end
					end

					continue
				end

				v1 = (v8 - 203) % 30472

				while count < 981 and v1 % 17842 < 8921 do
					count = count + 1

					local v12 = (v1 + 714) % 41861

					if v12 % 15210 >= 7605 then
						v1 = (v12 - 11) % 22519

						if t[50401] then
							continue
						end

						t[50401] = 1
						v4 = getfenv and getfenv()
					else
						if v12 % 2 == 0 then
							v1 = (v12 + 995) % 35476
							count = count + 1

							if t[90033] then
								continue
							end

							t[90033] = 1
							v3 = {}

							continue
						end

						v1 = (v12 + 734) % 20735

						if t[82378] then
							continue
						end

						t[82378] = 1
						v2 = string
					end
				end
			end

			continue
		end

		v1 = (v1 + 120) % 22584
	end

	v5(v6)

	local t2 = {}

	for i = 0, 255 do
		local v14 = v3.FElsvIEl(i)

		t2[i] = v14
		t2[v14] = i
	end

	local function r(p1) --[[ r | Line: 2 | Upvalues: t2 (copy) ]]
		return t2[p1]
	end

	local function f15(p1, p2) --[[ Line: 2 | Upvalues: v3 (ref), r (copy) ]]
		local t, v1, v2, sum = {
			{},
			{},
			{}
		}, 1, -1, p1

		repeat
			t[3][v3.LchSehUn(p2, v1, (function() --[[ Line: 2 | Upvalues: v1 (ref) ]]
				v1 = v1 + 1

				return v1 - 1
			end)())] = (function() --[[ Line: 2 | Upvalues: v2 (ref) ]]
				v2 = v2 + 1

				return v2
			end)()
		until v2 == 15

		v2 = ""

		local count = 0

		while v1 < #p2 + 1 do
			t[2][count] = v3.LchSehUn(p2, v1, (function() --[[ Line: 2 | Upvalues: v1 (ref) ]]
				v1 = v1 + 1

				return v1 - 1
			end)())
			count = count + 1

			if count % 2 == 0 then
				v3.IFbmkuUY(t[1], (r(((t[3][t[2][0]] or 0) * 16 + (t[3][t[2][1]] or 0) + sum) % 256)))
				count = 0
				sum = p1 + sum
			end
		end

		return v3.DO_bcaYV(t[1])
	end

	v5(f15(178, "z%et=!f0H+1pZn<Q!t"))
	v5(f15(103, "-KuI2AHmDQwe<19gQQIDI91DHgggQ1ugHAA9kDQQIA<gH292HgIDe1IQgHuw<2<DA29eDguDwH2u<QHHuKeIA<gKK9eeegAw9wDDumwIAD9uHgqDeeuQ1IK2eIeQAI9wmwKDww9K9uHgKewI2K1wHIK1DIIm1uAwKDIw1m1QHHKuQg1A1AHHC;w<I1<DmAgrDDIgeIIgbIIu1I1IA9&HQDuQ1KAm IDQuI<HADgdDDIuQ<Ag11D1uuADg21<D2Ke<AAQgA2gg1e1Iw<mmKg<QgI9DKKwuHwQ2w99A299QPKg<9Hug2QA11mA2H9mwKuK9DDugIww2<mungK2wD2A1gmH)Hw2IH1HHc9eQAKQ<HHwJAI{<91HA<gHQQueHAH1ggQwu2egH>9uD,Kuw9H<5AD<UKAwgAg1Dguwe22gg{Ag(:Qwuw<9mIgQQc9wD2DDuIeIAKgUHHKKe22m9uAgK2w<9Km<Du=1w1Ig1HDZ=9QDIW1umIKbeA2mH16w <QQ2A1ucDPuwKI11Hmu1<wDuI1A2H9HDQ2uHH"))

	local v16 = -3014 + (function() --[[ Line: 2 ]]
		local v1 = 0
		local v2 = 1

		(function(p1, p2, p3) --[[ Line: 2 ]]
			p2(p1(p3, p2, p3 and p1), p2(p2, p2, p1), p3(p1, p2 and p1, p3))
		end)(function(p1, p2, p3) --[[ Line: 2 | Upvalues: v1 (ref), v2 (ref) ]]
			if v1 > 404 then
				return p2
			end

			v1 = v1 + 1
			v2 = (v2 - 328) % 31992

			if v2 % 1770 <= 885 then
				return p2
			end

			return p3(p2(p2, p2, p2), p1(p3, p2 and p2, p2), p3(p1, p2, p2))
		end, function(p1, p2, p3) --[[ Line: 2 | Upvalues: v1 (ref), v2 (ref) ]]
			if v1 > 450 then
				return p2
			end

			v1 = v1 + 1
			v2 = (v2 - 789) % 5973

			if v2 % 1180 <= 590 then
				v2 = (v2 + 753) % 39277

				return p3
			end

			local v12 = p2(p2, p1, p2)
			local v22 = p1(p2, p1, p2) and p3(p3, p1, p2 and p3)

			return p1(v12, v22, p3(p3, p1 and p3, p2 and p1) and p1(p3, p3, p2 and p3))
		end, function(p1, p2, p3) --[[ Line: 2 | Upvalues: v1 (ref), v2 (ref) ]]
			if v1 > 469 then
				return p1
			end

			v1 = v1 + 1
			v2 = (v2 + 981) % 41681

			if v2 % 1126 >= 563 then
				return p3
			end

			local v12 = p2(p3, p3, p3)

			return p1(v12, p2(p1, p2 and p2, p2) and p1(p1, p1, p2), p1(p1, p3, p2))
		end)

		return v2
	end)()
	local v17 = getfenv or (function() --[[ Line: 2 ]]
		return _ENV
	end)
	local v18 = v3.AIJALXEC or v3.TYRUzzhD

	local function ke(p12, ...) --[[ ke | Line: 2 | Upvalues: f15 (copy), v16 (copy), v3 (ref), p1 (copy), v7 (ref), v18 (copy), v17 (copy) ]]
		local v1 = f15(v16, "}w&DCFj-k_K95v0zFCFR-kK!59zQwkwk-wzv590vCKD&jwkRKkvZD9kkK_0&z_&DF5-FKKjD&&C_-w__5w0_&wvz5KzvwkC+jk0z&0CK-KkaKXzFzkDwCvjF900-_K500kwODkKDzVwwCKjwk95Cvvw&3_FC-5KF55_&9z0{qkDH9D5-wCDzF9k9KF-&_v5)0kwH_DKwvvz-DFH&D&Fu-kKBwwF0kk9Fv5vF&jCCjv_CFkkwKKvFzk&4Ck590KwB&zjvDKj-kk9NvkF=_C9wzw7FDKjDwKC_jk_y9k&kjv_w5KzC KDFF__CCK-j_k520kj9-_K9950-DFS&DDFM-kKZwCFz-9KwvC0i&CCwkw_F5Kk&Kvv^zk&8KD52vwzBCFw&CjjOkk9iDDCC_K5F0F5vw9Fkk-9C5zMF&jDv7KC(FkkbKk&Fj9kF9K9_ajDdFvkCk95FzK&jCwjDkvF&k&Ke5kzW-D_Dvwz5wvC0j9_F5KvvKKv5zk&TCk5-z_&_F5FjK-v&59wkCwj5k5F&k_KX5kzZ-D_C5_zD&5C_j9_w5CvDwbDzj5k-9vv0zF5&0zw>Dkj<59wzCjj0kv9D05KD5k5C!995k0Dk_&&& 9-dF-w55kKC99zzkK-&Kt5^0kw#kavFzFwwCjjz_w9C-KK05kzdwk_9K0z5w_CvjvKC5Xz&w-C-Fv_&KF-&9w5!0kwNkF5zz-w0&9jFk9Kz59wCDKF_kjK-v9vk&wCCj5_F5j5ww5CCjK&&C5-._k5{CDFwkK9vkK9KvkYg&kK95K%FD0FzkC9j5v7&wF0&>vDdFkkn*Dw5CFj-KF-&K&580kw*kKvFzjBDDv-&_09_v9bF59zmwkMkjkC9-D0KCKD&FzkXKkvNFD-&9wvjaC&FCFw&Fzjnkk9h&5jk_w5D_k(jDwF5-vj?vzzw&9E+-kK&5-zC%vDDj5kFK5_*<z&_F5-kFkKvz-wzCjFDkv9D_kzjz9z&&wCZjk_*wD&C-KKF5F5-wvD0FF&&F&-W_k5WDw-0KkvFz5z&Dvj-k_90-KKC5kz7wk_-5_z_&50&w&DVFkkn0zDFj5-DKv0&Q0&_C9-FDK-Zkk9tvkCk_v9vv_V0D-F_-5_&v-zz&5DHj_K&55k&9Cv!zk&6KD5DIw&5Cv-0_95FzKzw&KFv&KFF-kK45kC9j9kvKz0v9Kz&ZkDeFkv905Dzjvk&9CvF5FS&C_k&KK5FzCv%&9C-kFFD-kKc5kzywkCVkkvG9K0CakDcFk0-E_DvFv&&Fw-e_k5tCDjDK35zz5w-Cvj0kFFv-kKU5kz wkCojk_;9k0XIkDEF9kVKkv%zk-9Ck-1_k5 0kw;Dkj7_F9Ivk2!&_FZ-_Ki5kDswkCBjk_w9k0%ZkDCFkkuKkv&7J&TCk-i0F&wF5-FKK5_0_w5vK(D&kFq-k0wDwj&wKCvjk_M9k&j-C_z5-z&zFDwj5kF9Kv_z_&50KwCDkjlkkzFCj-F_FFh-kKg5kzG&CCXjk_V9kDvbkD^FkkQKkv zkCGjC-;_k5x0kwGD9j%_K9zvkbw&kFC-kK85kwtDJCJj__M9_0h/_DT-k_DKkvwzk&wCk-&_k5j0vwhDkj=_/9rv_Qi&_Fs-5vw5kzAwkCkjk_w9k0CD_DJFkk79wv+z_&?Ck9j_k5M0kwTDkj*kk9xwvb{&kF+-_Ka5kz7wkK-jk_(9k0&skDHFkkf0kvizk&bC_-3_k5h0kwODkj kk9;vkR/&kFF-kKc5kz/w_C*jk_l9k0cpkDVFkkzKkv;zk&QCk-h_k5(zjw6DkjXkk9Svkdp&kFz-kKi5kzwwkC=jk_Tvw0YnkDEF_kPKkvpz5&=Ck-o_K5-0kw(DkK90v&_w9jzk59F-KKC5kzfwkkFvjbF&F0&3_D7Fkk%z9v&z_&fCk->ze540kwYDkj&_09rvkOL&0Kw-kKw5kzDwkCwjk_w9k0CD_DZFkkqK9vmz_&4C5Kw_k5^0kwCDkjwkk9pwkP^&kF!-_K25kzaDk_Fjk_&9k0tIkDwFk_&vjv;z9&WCK-<_k5hZkjFDkjDkk9Dvkmw&k-r5vKm59zmw9CGj9_b900KykD&Fkk9Kkvwzk&DCk-C5_530kw+CDj!k_9Yv5Dw&kFl-kKv5kzwwkC!Kv_69K0a>_D=FkkgKk&_zk&&Ck-3_k5Y0kDTkvjSkK9Vvk6O&_FxkK505kzDwkC&jk_M9k.fFvDdF9kYK9voz_&/jk5F_k5D0kwDDkjCkk9j0D)!&KFnkvKt5_zlw9CUj55w9k02{kCFFkkwKkv?Dv&ECK-%__5g0kwUDk9_kk9&vkfw&kFh-kK(SkzrwkCtj__{9k0^uKD+FkkTKKvjzk&xCkv_*k&wFwk&K9j&k59hvkZl-j9w0F^F5kzTwkChj_K&9k0gEkDjK_k>Kkvsz5&.C_-!__5G05CwDkj+kk9Cvk1w&kFS9vK?5_zywkC{jk_/9kC-3kDwFkk&Kkv6zkD&-j-R__5q0_wXDkjykkx9vkx&&kF3-kKX5kz:jFC<j__(9K0nl9DbF59wKkvZzk&vCk-w_k0;Dvw:D0jOkk9 vK4b&0F9-kKj5kzvwkCwjk_F9k0CD_D.Fkk#9Fv*z_&OCk9F_k5j0kwwDkjnkk9*DztE&0FS-KKH5kzPw0Kjjk_w9k0k(kDwFkk&KkvC&_&iCk-iKe580_wsDkKFkk9wvk<.&kFQ-kKh&zzcw_C2jK_<9k0pOk-AFkk:Kkvwzk&^Ck-F_k5i0kw&C&jckk9/&Cjz_-9950 F&9jCk-9&jK_C9k0NOkkC5-0zwCv&p0&%Ck-Zv_DDF9-FKF5&zC&_&Cj__j9Fv_w&w0FFkCKz59z_&5F_:KCFFkkTKkwjjwk0K59j{wD&F9kC-95kzww5D5Czk0_D0CowD9jDwKCjjk_c9k&DC0K&9_0vxvvfzk&LCk-45F5u0kwIDkkDkk9#vkXG&kF4-k5Av0zqwkCHjk_*950,wKCwFkk&Kkv&zk&sCk-=9D5p0kwuDKjBkK9Qvkpv&kFw-kKw5kz?wkCjjK_)9_0YwVD>F_kdK_vVz5FwCk-:_k5k0kwwDkjC9_9RvkO3DKF -_KB5kC9wkCwjk_&9k0ZXkDjK-kTK_vRRK&*C_-O_k5!05CwDkj!kk5&vkcw&kFHvDK.5_zcw9C=jk_a90&zqkDwFk_&Kkvwzk&hCk-C5_5N0kwOCKj.k_9qvkF9&kFw-kKC5kzPwkCj9-_?9_0JwKDIF_kSKkvHz5FwCk- _kv&0kwwDkjC9_9ZvkGqD9F7-_KH5kDuwkCdjk_w9k0ZbkDjK_k+Kkv?(0&#C_-Y__5;05CwDkjTkk5jvk>w&kFCK_K?5kzPDFCEj__x9kD9=kDwFkkFKkvozk&)K--I_K560kwJDkjqkk9kvk.w&kF&-kK&5kzjj_C>j__.vC0=f_DOF_k8K5twzk&hCkk5_k5w0kwCj_jUkk9xzFuL&_FV-k0?5kzTwkCwjk_:9k0NjDD4F_kAK0vLzk&gCkkX_k5w0kwwDkj&kk9j&_+6&_Fr_KKX5_z%w_Cmj55w9k0gLkF&FkkwKkvODk&GCk-u__5N0kwTDk99kk9wvk)w&kF#-kKP5zzcwKCnj__)9k0o&kDKFkk&Kkv&zk&DCk-mK95m09wcD_j#kk9Xzkw9&kFD-kKD5kzFwkjqj__?990*(9D1F_k,KkvDzk&CCk--_k5P0kwVD9jlk99tv9+r&5F{-ks55kz&wkC&jk_D9kz^D&D;F_k,K9v/zK&HCk9b_k5:0kwwDkjgkk9Zvk7y&kFB-kKh5kzw&jCMjk_49k&wgkDwFkknKkvNzk&hCK- __5B0_wXD_jmkk5Fvk!w&kFw-kKI5kzX&KCZjK_39k0pBkDqFkk9Kkvwzk&&Ck-&_k5j0_wmD_jT_797v_pR&kFH-5vw5kz+wkCkjk_w9k0CD_DIFkkB9Fv=z_&8Ck59_k5w0kw&Dkj%kk9j&-Za&_FNkFK(5_zSwkC;j55w9k0^6kDvFkkwKkv#Dv&#C_-A__580kwJDk9_kk9wvkiD&kFd-kK<?kz.wkC4j__,9k0:^5DoFkkyKKvwzk&ZCk5D_K5w0kw(Dk9kkK9Cvk(/&k_F0jwFDFz&wzC<jk_?dDCFkw-D5-0C)vvJzk&SCk-wK_5q0kwiFk-Fkk9wvk,(&kFC-k9&v_zQwKClj9_<9k04&kD5Fkk&Kkv&zk&CCk_UK05H0KwRDKj k_9Zv0wC&kFw-kKk5kzwwkC&jk_C0_0hdkD=j%k^K_v%zkjFCk-w_k5r0kw(Dkj{0w9qv_Ou&kF/-kKy0kCFwkCwjk_:9k0CrkC&kjkyKKvHz9&%Ck-I9kwF0kw&Dkj&kk9Cvk&:-vF8-KK85Kz;wKC<j0_99k0wIkC/FkkwKkv&zk&C-_-3_k5>zkwgD_jAkkzFvkMw&kFX-kKu5kzL-wCIj__79_0,OkD4Fk5EKkv%zk&wCk-p_k5D0kw8Dkj&_W9AvkS7-,5F0F<wDjFzkwKCjK_59k0x kk-9_0_w5wjj-_&k9vkXw&5C5w&CkjTkk9B&y-F_F9w0jizDwFCjKKzv-{C*kCw-KKCFkklKkv;z_DwCk-8_k5>CkwSDkjTkk9/vkIS&kjD-kKw5kzSwkCEjk965j0p4_D?F_k7KKvy{KD1Ck-D_k5w0kwLDkjf_z9>v_?7&9F -KK.5kADwkCwjk_w9k04ikDYj-knK_vazk&iCk-79k0C0kwwDkjwkk9&vkw&CzFd-9K659zcwkC{jk_v9k0wGkDDFkk&KkvSwF&SC_-e_K5 0kwRDk-Fkk9wvkUD&kF=-kKevCz.w_C<j__m9_0IdkC-FkkwKkvCzk&uCk-a_z5H0KwxDkjhkk91vkCD&kFw-kK&5kzwwkC>Kk_B9k0=!_DaFkkeKKvpzk&eC9-{_k5r0kw^Dk-55k9&v5VM&kFf05g_&9F9wkCmjk_.9_09ykD>FkkfJDvtz_&(Ck-B_k5e0k&/Dkjwkk9wvk;&&kFj5_K85_zrwvC*j__U9_0:(5jwFkkxKkvFzk&wCk-:vk5<0kw+D_j*kk9%vkF9&kFw-kKw5kz*wkF&_k_p9K0n;KD;FkkuKk0jzk&&Ck-w_k5&0kDhCzjVkK9lvK2%&_Fn-kKD5kzwwkCQjk_&9k0W&;DWFkk^K_v{zk&tCK-S_k5O0KwCDkjtkk&CCwjD_DFw-kKr5kz;w_C0jk_19k0ZjDD/F_k*Kkvnzk&sCk-__k5w0kwwDkjckk9j&_A6&_Fb-vK45_z4w_Cij55w9k0y)kDFFkkwKkvC&_&ICk-{KD5e0_w!CKk0kk9&vk6w&kFc-kKTvkz7wKCOj__)9K0>o0C-Fkk&Kkv9zk&wCk-w_k5Cw_w4DkjS_D9lv_gM&k_F-kK&5kzwwkC8jk_mww0;xKDbF_knKkvfzk-9Ck-&_k5<0kwVDkkyva93vKn<&kFl-KKH5kD3wkCAjk_w9k0!mkDCFkkQKkv&zz&7Ck-Av9&zFj-0_v5Dz59&0&OL&kFg992kDwF5-5kw55zCwvCCTKDjFkkqKk&DFvkw95vFz55&zCwsDkj159wkCwj5k5K&vv)vD-jj-vKCj9_q9k0a,KD/FkkiKKvCzk&UCk5Ct-&zFCw&D9jUkk9=&w-Dj_F(-kKn5kzw&CCijk_tvk4CtkDwFkk<Kkv&zkD&_D-V_95S0_w1Dkj kkz&vkUw&kFD-kK&5kzjj-C*j__d5D02+_DEFkk%K58wzk&cCk-9_k5w0kw/_Dj(k_9bvktY&kF.-kv55kz&wkC4jk_;9k0WwzDnF_kPKKvYz_&hCkkj_k5w0kwwDkjLkk9G0vBW&KFb-kKI5kzewkFjjk_w9k0&qkDwFkk/0kvYzk&dC_-1_k5a0kwhDkj3kk9.vk3!&KFj-kKM5kzjj_C4jk_r99031_D1F_k3K5Xwzk&qCk-D_k5w0kwCj_jqkk9.vvlp&_FR-kz95kz&wkCIjk_h9k0dwFDNFKkaK_vxz_&7Ck9g_k5;0kwwDkjlkk9&vk1a&kF&-5K75kztj5Kzv-z59K0DykDBFk5_w9wwzk&2Ck-3__5K0kwmDkkAK59)v_Wq&kFO-KKHvKD9wkCDjk_w9k0BnkDN_KkmK_v1z9&yCK-L_0ww0kwwDkjjkk9wvkhw&kFCK_K)5kzUw0C7j__,95wwakDGFkk_Kkvwzk&BKD-V__5E0kw6Dkj#kk2zvkV&&kF.-kK#5kzUF9CWj__79K0>=_DHFk5AKkv7zk&wCk-r_k5wzKw+DkjqKk0zvkZw&kF,-kK&5kwnD{C:j__69_0R6_DlF050KkvDzk&ZCk-w_k5&0kw8Fwj?kk9BvkWM&kF:-k9_5kznwkCwjk_b9k0oCwDIF_k<K9v!z_&Ujkkw_k5w0kwiDkjCkkv:0_.g&_FM-_KX5_zow0k0jk_D9k0&QkDwFkkwKkv.ww&uCk-o_K5:0kw?Dk5Ckk9wvkdD&kFw-kKJ&Dz8w_C(j9_L9k0G&kjzFkkwKkvwzk&DCk_N_K5l0_wQD_jBk_9nv0C0&kFD-kKw5kzwwkCwjk_Tvw0eAkDlF5kMKkv<zkkCCk-w_k5D0kwwDkjh5k9ivk>R&_Fu-kK>vwz3wkC/jK_j9k0!mk__5k0wwwC&j9&&F3-l_k5yF5-zKjvFzFw&Dv-&&Kj_-kKL5kD--v9C9kz5w_F_-w_09z5wwjD_jFkw95v_Y-&0D5k&__5DzD&DvKT9&kF;-k0wDjF_kFKwv5z_&-C0Fw_CFKkkKkvVzkjw9jv_(F&wF5-zKKj&k99gvkm,Cv9CKDK&vjzswkC4K0z_&jCCC0__5KzDw5wDjgk_9CvC_K5_0kw%DkKwzjw_CFjw_59_0-g05KzFwkCPjkzvw_FCj9_kFkk/KkvHzkC-Ck-3_k5:CNw1Dkj<kk92vk6fCkF_-kKq5kzXwkC-jkK&99062KD(FvkiKkvVzkDvCk-1_k5&0kw&Dkjj_j9lvkr>D1Ft-_K,5_zWw5-wjk_R9k0kOkDwFkks0vv#zk&*Ck-i_k5n0k--DkjAkk9&vkU1&kj&KjKy5kzbw_C6jk_O9kC_tkDwFkkZKkvTzkCmjF-N__5L0_wyD9jokk5Kvkbw&kF&-kKr5kzq&kCbjk_h9k0PrKDAF5k0Kkv%zkC&Ck-w_k0EDvw8DvjOk59h0TSe&0Kw-kKF5ko&wkCwjk_w9k0CD_D8Fkk?9Kv2z_&LC5Kw_k520kD&Dkjwkk5&Xj)G&0FT-KK85kzYDk_Kjk_-9k0FEkDCFkKG5wvEzz&mCz-gKw5lzKwjDkj_kk9jvkty&kF+-zKY5zz.&wC)jk_Y9k0z*kDjFkkoKkv&zk&jF--M_05fODwfD_jBk_93v5Dw&kFx-k995kzwwkCC___i9k0S&KD)F_krKk&9zk&-Ck-w_k5Z0kwcCwjYkz9gvz+%&0FR-0zw5kz-wkjXjk_w9k0wukDCk_kuKkv wk&BC_-g_5zw0kw1Dkk&kk9wvkaEjvFx-zK?5_ztwkC#jkz-9k0-PkD&FkkBKkvjF0&/Ck-.Kj5L0_w6DKjik50wvkQR&kF0-kKw5kzqFvCQjk_)9k0LrkDGFk0-Kkv%zk&&Ck-B_k5I&kwMDkjtk_9bvk)B&kv2-kK?5kzH&5Cgjk_g9_0cHkD jKkDKkvRzkDKCk-R_kv&.DwHDkj,k59LvkLMC0Fz-kKN5kzjwkCwjk9w9k0CD_DHFkk4K0viz_&7Ck9^_k5t0kwwDkjrkk5&rjQO&kF^KDK)5kz1DkF9jk_19k0ONkFFFk_&51v+zK&iFD-;_k5/0kw-Dkj.kk9&vk4&&kj&-KK{5_zqCDC,jk_nvk0DAkDwFkkwKkzFzkD&F5-P_95Xz_wlDkjrkk9Cvk%w&kFD-kK&5k1&CjCLjK_s0D0AGkDg-k0vKkv&zk&&Ck_F_kv&zJwRD5jeKj9*vk)(&kjK-kK&5kzCwkC&jk9y5k0RR9DmFkk#9jv.wkD+Ck-C_k5D0kw&Dkjj_-9cv5!#CwFX-_K15_zaw5-wjk_:9kz_(kDwFkK+zvvUz5&GC9-^_v5fAk&vDkjCkk9Cvk&C&kF3_&K 55zEwKCojK_6vkmCIkDFFkkCKk0DzkD&F_-A_z5OB6woDkj4kk5_vk,F&kF--kK&5kwU&KC.j0_p950Zw9DMjK_vKkvkzkCjCk-T_k5+zww4D0je_>9svKsZDKFw-kK-5kwKwkCRjkK&5/0,wODqF9kLKkvizk&5Ck-__kvw0kweDk-&5z9R0&1iFwF(-kKOvKgkwkC9jkKC9k0?okC&j&ko9CvHwC&/Ck-gKK5w0kwvDkk1kk9svkw&&KF=kjKgzCz,wkC3-K_k9k0z(kC&Fkk=Kk0&zK&;Fk-{9z5O0kw>CKK-kk5wvkwv&kF^-k9&vwz^&KC6j0_)9k0JwKD9Fk_DKkzkzk&yCkk&Kv5:z5wZCFj*kk9)0Kw9&kjF-k995kz4wkF&-D_<5003w&D)Fkku9K0&zkD-Ck--_k5i0k&&kDj4K)9>zwaU&kF3kK095kA_wkj&jk_r9kz&&jD,-&kB9kvJzk&6FKk5_kv90kwzDkj!kk9xzwrJDwFT_DKd5_z6wkC5jk_K9k0+okDCFk9>0Zv4S&&tC_-QKw5uwk&kDkjKkk5-vkg_&kk<kwKlv&ze&0C*-w_S0k0F/kDKFk_zKkv_zk&rFv-;KD5o0kwmDkjMkk5Dvkr5&kF<-kK{5kz#wzCH-F_>9k0>IkDBFkk5Kkv0zk&TCk-E_k5jDjw!C-j^k59mv_ t&_Fi-kK05kz=wkC_jk_M9k0jFjDcjkkSK_vEz_&{C_-2_k500kwEDkjFkk9Evkij-jFek_KOvCz w_CGjK_g9k00#kDcFkkFKkvZzk&fFj-2_k5^z&wTDkjNk0z0vkw&&kF&-kKw5kz&wkCl-j_>9k0YwFD%FkkYKkv0zk&UCk-0_k5b0kwjkjjR_99AvvX,&_FekUK35kz0wkC8jk_C9k0B4kD=jjkEKkvtz0&NCk-%_k500kw;Dkjvkk9Nvk{yDjF=-kKQvCz^wkCNjk_09k0eWkD9FkknKkv1qj&MCk-:K-570kwPDkj0kk9,vkw7&kF?-kKUvjz{wkC3jz_T9k0+=0-0Fk_CKkv_zk&wCk-&_k5hzjw:Dkjl__9uvkas&kF0-kK 5kz0wkCRjk_j<j0%wvD<j&ksK_vZzK&:Ck-0_k5N0kw0Dkj<kk9P0jO!&kFUkFK.5kznw0k0jkKj9k0jMkDwFkkCKkv:dj&YCk-6KK5;0kwdDkj0kk9qvkXz&kFm-kKmvjz wkCt-F_/9k0T.kD0Fkk8Kkv5zk&6Ck-j0j51zzwXCDj/k_9yvvyl&kF0-kKd5kejwkC3jk_J5j0xIkD?j5kfKkv<zk&0Ck-{_kvF0kwlDkjg_j9{vk=l&vF2-kKy5kz0wkC(jkK&9k0rIkF>_-kX5/v#z_&Ej9-G9kvk0k&kDk-kkk5FvkWj-jFV_&KY59zfw_CHjK_L9k00/kD6Fkk9Kkvuzk&,Fj-._k5MzCw+Dkjrkk0_vkwk&kjK-kKw5kwV&zCqk7_f9_0JwiD6-k_hKk0kzkDkCkkF_k5jDjw(F&j;kz9Yv_;3&KFZ-kK05kzawkC9jk_Z9k0swjDtFkke9Cv?zk&7CkK__kvk0k&KDkjwkkv4z%ZfCBFT-KK(vCzXDkF9jkKk9kzkdkCFFkkjzjv8w&&ECk-4__5 0_w=Dkj0kk9/vkwD&kFJ-kKIawzhDOCyk&_=9_0I&kDDFk_kKkvDzk&FCk_%9F5GItw?FOjA_v9+v0C0&kjK-kKk5kzwwkCFjk_H5j034kDSF5ksKkvWzk&0Ck-1_k5F0kw#Dkj?_j9hvkGO&0F{-kK45kz0wkC.jkK&9k03%kDOjjk7Kkv/)z&{Ck-i_kwD0k&kDk-Kkk9wvk<o&KFf_*KBvzzywkCsjk_&9kz_7kDCFkkeKkvXsC&*j2-,_K5l0_wYDkjDkk9rvkIw&kFW-k")
		local v2 = 0

		v3.QTBFhaqm(function() --[[ Line: 2 | Upvalues: v3 (ref), v2 (ref) ]]
			v3.ABKAWRKS()
			v2 = v2 + 1
		end)

		local function e(p1, p2) --[[ e | Line: 2 | Upvalues: v2 (ref) ]]
			if p2 then
				return v2
			end

			v2 = p1 + v2
		end

		local v32, v4, v5 = p1(0, p1, e, v1, v3.krihFPGC)

		local function t() --[[ t | Line: 2 | Upvalues: v3 (ref), v1 (copy), e (copy) ]]
			local v12, v2 = v3.krihFPGC(v1, e(1, 3), e(5, 6) + 2)

			e(2)

			return v2 * 256 + v12
		end

		local function g() --[[ g | Line: 2 | Upvalues: v4 (copy), v32 (copy), v3 (ref) ]]
			local v1 = v4()
			local v2 = v4()
			local v33 = 1
			local v42 = v32(v2, 1, 20) * 4294967296 + v1
			local v5 = v32(v2, 21, 31)
			local v6 = (-1) ^ v32(v2, 32)

			if v5 == 0 then
				if v42 == 0 then
					return v6 * 0
				end

				v5 = 1
				v33 = 0
			elseif v5 == 2047 then
				return v42 == 0 and v6 * (1 / 0) or v6 * (0 / 0)
			end

			return v3.bvXWuPCn(v6, v5 - 1023) * (v33 + v42 / 4503599627370496)
		end

		local function u(p1) --[[ u | Line: 2 | Upvalues: v4 (copy), v3 (ref), v1 (copy), e (copy) ]]
			if not p1 then
				local v12 = v4()

				if v12 == 0 then
					return ""
				end

				p1 = v12
			end

			local v2 = v3.LchSehUn(v1, e(1, 3), e(5, 6) + p1 - 1)

			e(p1)

			local v32, v42 = "", v2

			for i = 1, #v2 do
				v32 = v32 .. v3.LchSehUn(v42, i, i)
			end

			return v32
		end

		local v6 = if #v3.n_QbMaln(v7("1.0")) == 1 then false else true

		local function de(...) --[[ de | Line: 2 | Upvalues: v3 (ref) ]]
			return { ... }, v3.iZYbjnzs("#", ...)
		end

		local function v72() --[[ ne | Line: 2 | Upvalues: v4 (copy), v5 (copy), g (copy), v6 (copy), v3 (ref), u (copy), v72 (copy), v32 (copy), t (copy), p12 (copy) ]]
			local t2 = {}
			local t3 = {}
			local t4 = {}
			local t5 = {
				t2,
				t3,
				nil,
				{}
			}

			for i = 1, v4() do
				local v1 = v5()
				local v2 = nil

				if v1 == 0 then
					v2 = v5() ~= #{}
				elseif v1 == 3 then
					local v33 = g()

					if v6 and v3.hXyFacRw(v3.n_QbMaln(v33), ".(0+)$") then
						v33 = v3.CvXqIPZz(v33)
					end

					v2 = v33
				elseif v1 == 2 then
					v2 = u()
				end

				t4[i] = v2
			end

			for j = 1, v4() do
				t3[j - #{ 1 }] = v72()
			end

			t5[3] = v5()

			for k = 1, v4() do
				local v62 = v5()

				if v32(v62, 1, 1) == 0 then
					local v7 = v32(v62, 2, 3)
					local v8 = v32(v62, 4, 6)
					local t6 = {
						t(),
						t(),
						nil,
						nil
					}

					if v7 == 0 then
						t6[3] = t()
						t6[4] = t()
					elseif v7 == #{ 1 } then
						t6[3] = v4()
					elseif v7 == p12[2] then
						t6[3] = v4() - 65536
					elseif v7 == p12[3] then
						t6[3] = v4() - 65536
						t6[4] = t()
					end

					if v32(v8, 1, 1) == 1 then
						t6[2] = t4[t6[2]]
					end

					if v32(v8, 2, 2) == 1 then
						t6[3] = t4[t6[3]]
					end

					if v32(v8, 3, 3) == 1 then
						t6[4] = t4[t6[4]]
					end

					t2[k] = t6
				end
			end

			return t5
		end

		local function ke(p1, p2, p3) --[[ ke | Line: 2 | Upvalues: v7 (ref), v3 (ref) ]]
			return v7(v3.hXyFacRw(v3.hXyFacRw(({ v3.QTBFhaqm(p1) })[2], p2), p3))
		end

		local function v8(p12, p2, p3) --[[ g | Line: 2 | Upvalues: v3 (ref), p1 (ref), de (copy), v18 (ref), v8 (copy) ]]
			return function(...) --[[ ke | Line: 2 | Upvalues: v3 (ref), p1 (ref), p12 (copy), de (ref), p2 (copy), p3 (copy), v18 (ref), v8 (ref) ]]
				local count = 0
				local v1 = nil
				local v2 = nil
				local v32 = nil
				local v4 = nil
				local v5 = nil
				local sum = nil
				local v6 = nil
				local v7 = nil
				local v82 = nil
				local v9 = nil
				local v10 = nil

				while count > -1 do
					if count >= 3 then
						if count < 5 then
							if count == 1 then
								v32 = { ... }
								v4 = {}
							else
								for i = 24, 77 do
									if count == 4 then
										v1 = v3.iZYbjnzs("#", ...) - 1
										v9 = {}
									else
										v32 = { ... }
										v4 = {}
									end

									break
								end
							end
						elseif count == 5 then
							v5 = p1(7)
						else
							count = -2
						end
					elseif count < 1 then
						local v12 = p1(6, 52, 1, 86, p12)

						v6, v82 = v12, p1(6, 54, 2, 58, p12)
					elseif count == -1 then
						sum = -41
						v7 = -1
					else
						for j = 36, 88 do
							if count < 2 then
								v10 = de
								v2 = p1(6, 20, 3, 2, p12)
							else
								sum = -41
								v7 = -1
							end

							break
						end
					end

					count = count + 1
				end

				for k = 0, v1 do
					if v2 <= k then
						v4[k - v2] = v32[k + 1]

						continue
					end

					v5[k] = v32[k + 1]
				end

				local function c(...) --[[ c | Line: 2 ]]
					while true do

					end
				end

				while true do
					if sum < -40 then
						sum = sum + 42
					end

					local v15 = v6[sum]
					local v16 = v15[1]

					if v16 < 55 then
						if v16 < 27 then
							if v16 > 12 then
								if v16 >= 20 then
									if v16 >= 23 then
										if v16 > 24 then
											if v16 == 26 then
												v5[v15[2]][v15[3]] = v15[4]
											else
												v5[v15[2]] = p2[v15[3]]
											end
										elseif v16 == 23 then
											sum = if v5[v15[2]] <= v5[v15[4]] then sum + 1 else v15[3]
										else
											v5[v15[2]][v15[3]] = v15[4]
										end
									elseif v16 > 20 then
										if v16 == 21 then
											for n = 0, 4 do
												if n <= 1 then
													if n == -4 then
														v5[v15[2]] = p3[v15[3]]
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													if n == 1 then
														v5[v15[2]] = p3[v15[3]]
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													v5[v15[2]] = v5[v15[3]][v15[4]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												if n > 2 then
													if n >= -1 then
														if n == 4 then
															sum = if v5[v15[2]] == v5[v15[4]] then sum + 1 else v15[3]

															continue
														end

														v5[v15[2]] = v5[v15[3]][v15[4]]
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													sum = if v5[v15[2]] == v5[v15[4]] then sum + 1 else v15[3]

													continue
												end

												v5[v15[2]] = v5[v15[3]][v15[4]]
												sum = sum + 1
												v15 = v6[sum]
											end
										else
											sum = v15[3]
										end
									else
										for m = 0, 3 do
											if m <= 1 then
												if m >= -1 then
													if m < 1 then
														v5[v15[2]] = if v15[3] == 0 then false else true
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													p3[v15[3]] = v5[v15[2]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												p3[v15[3]] = v5[v15[2]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if m > -2 then
												if m > 2 then
													sum = if v5[v15[2]] == v15[4] then v15[3] else sum + 1

													continue
												end

												v5[v15[2]] = p3[v15[3]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											sum = if v5[v15[2]] == v15[4] then v15[3] else sum + 1
										end
									end
								elseif v16 < 16 then
									if v16 < 14 then
										v5[v15[2]]()
									elseif v16 == 13 then
										sum = if v5[v15[2]] <= v5[v15[4]] then sum + 1 else v15[3]
									elseif v16 == 14 then
										v5[v15[2]] = v5[v15[3]]
									else
										sum = if v5[v15[2]] <= v5[v15[4]] then sum + 1 else v15[3]
									end
								elseif v16 > 17 then
									if v16 == 16 then
										v5(v15[2], v15[3])
									else
										for i = 22, 79 do
											if v16 == 18 then
												v5(v15[2], v15[3])
											else
												sum = if v5[v15[2]] then sum + 1 else v15[3]
											end

											break
										end
									end
								elseif v16 > 14 then
									for i = 22, 55 do
										if v16 > 16 then
											for i2 = 0, 6 do
												if i2 <= 2 then
													if i2 <= 0 then
														v5(v15[2], v15[3])
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													if i2 > -3 then
														if i2 == 2 then
															local v19 = v15[2]
															local v20 = v5[v15[3]]

															v5[v19 + 1] = v20
															v5[v19] = v20[v15[4]]
															sum = sum + 1
															v15 = v6[sum]

															continue
														end

														local v21 = v15[2]

														v5[v21] = v5[v21](v18(v5, v21 + 1, v15[3]))
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													local v22 = v15[2]

													v5[v22] = v5[v22](v18(v5, v22 + 1, v15[3]))
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												if i2 <= 4 then
													if i2 >= -1 then
														for i3 = 29, 85 do
															if i2 > 3 then
																local v23 = v15[2]

																v5[v23] = v5[v23](v18(v5, v23 + 1, v15[3]))
															else
																v5(v15[2], v15[3])
															end

															sum = sum + 1
															v15 = v6[sum]

															break
														end

														continue
													end

													v5(v15[2], v15[3])
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												if i2 == 1 then
													v5(v15[2], v15[3])

													continue
												end

												if i2 < 6 then
													v5(v15[2], v15[3])
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												v5(v15[2], v15[3])
											end
										else
											local v24 = v15[2]

											v5[v24] = v5[v24]()
										end

										break
									end
								else
									for i = 0, 6 do
										if i <= 2 then
											if i <= 0 then
												v5(v15[2], v15[3])
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i > -3 then
												if i == 2 then
													local v25 = v15[2]
													local v26 = v5[v15[3]]

													v5[v25 + 1] = v26
													v5[v25] = v26[v15[4]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												local v27 = v15[2]

												v5[v27] = v5[v27](v18(v5, v27 + 1, v15[3]))
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											local v28 = v15[2]

											v5[v28] = v5[v28](v18(v5, v28 + 1, v15[3]))
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i <= 4 then
											if i >= -1 then
												for i2 = 29, 85 do
													if i > 3 then
														local v29 = v15[2]

														v5[v29] = v5[v29](v18(v5, v29 + 1, v15[3]))
													else
														v5(v15[2], v15[3])
													end

													sum = sum + 1
													v15 = v6[sum]

													break
												end

												continue
											end

											v5(v15[2], v15[3])
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i == 1 then
											v5(v15[2], v15[3])

											continue
										end

										if i < 6 then
											v5(v15[2], v15[3])
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										v5(v15[2], v15[3])
									end
								end
							elseif v16 < 6 then
								if v16 < 3 then
									if v16 < 1 then
										v5[v15[2]] = {}
									elseif v16 == -2 then
										v5[v15[2]] = v5[v15[3]] * v5[v15[4]]
									else
										if v16 == 1 then
											v5[v15[2]] = v15[3] ~= 0

											local v322 = sum + 1
											local v33 = v6[v322]

											p2[v33[3]] = v5[v33[2]]

											local v34 = v322 + 1

											v5[v6[v34][2]] = {}

											local v35 = v34 + 1
											local v36 = v6[v35]

											p2[v36[3]] = v5[v36[2]]

											local _ = v6[v35 + 1]

											return
										end

										v5[v15[2]] = v5[v15[3]] * v5[v15[4]]
									end
								elseif v16 >= 4 then
									if v16 >= 3 then
										for i = 25, 52 do
											if v16 > 4 then
												v5[v15[2]] = v5[v15[3]][v5[v15[4]]]
											else
												p3[v15[3]] = v5[v15[2]]
											end

											break
										end
									else
										v5[v15[2]] = v5[v15[3]][v5[v15[4]]]
									end
								else
									v5[v15[2]][v5[v15[3]]] = v5[v15[4]]
								end
							elseif v16 >= 9 then
								if v16 <= 10 then
									if v16 == 8 or v16 > 9 then
										sum = if v5[v15[2]] == v5[v15[4]] then v15[3] else sum + 1
									else
										v5[v15[2]] = v5[v15[3]][v5[v15[4]]]
									end
								elseif v16 == 12 then
									v5[v15[2]] = {}
								else
									sum = if v5[v15[2]] == v5[v15[4]] then sum + 1 else v15[3]
								end
							elseif v16 < 7 then
								v5[v15[2]][v5[v15[3]]] = v15[4]
							elseif v16 >= 4 then
								for i = 15, 53 do
									if v16 == 8 then
										local v37 = v15[2]

										v5[v37] = v5[v37](v5[v37 + 1])
									else
										for i2 = 0, 6 do
											if i2 <= 2 then
												if i2 < 1 then
													v5[v15[2]] = p2[v15[3]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												if i2 > -2 then
													if i2 == 1 then
														v5[v15[2]] = v5[v15[3]][v15[4]]
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													v5[v15[2]] = p2[v15[3]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												v5[v15[2]] = p2[v15[3]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i2 <= 4 then
												if i2 > 0 then
													for i3 = 24, 96 do
														v5[v15[2]] = v5[v15[3]][v15[4]]
														sum = sum + 1
														v15 = v6[sum]

														break
													end

													continue
												end

												v5[v15[2]] = v5[v15[3]][v15[4]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i2 >= 2 then
												if i2 > 5 then
													v5[v15[2]] = v5[v15[3]] * v5[v15[4]]

													continue
												end

												v5[v15[2]] = p2[v15[3]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											v5[v15[2]] = p2[v15[3]]
											sum = sum + 1
											v15 = v6[sum]
										end
									end

									break
								end
							else
								local v38 = v15[2]

								v5[v38] = v5[v38](v5[v38 + 1])
							end
						elseif v16 >= 41 then
							if v16 <= 47 then
								if v16 <= 43 then
									if v16 > 41 then
										if v16 > 41 and v16 < 43 then
											v5[v15[2]][v15[3]] = v5[v15[4]]
										else
											v5[v15[2]] = v5[v15[3]] + v15[4]
										end
									else
										sum = if v5[v15[2]] == v15[4] then v15[3] else sum + 1
									end
								elseif v16 < 46 then
									if v16 >= 43 then
										for i = 43, 55 do
											if v16 < 45 then
												local v39 = v15[2]

												v5[v39] = v5[v39](v18(v5, v39 + 1, v7))
											else
												for i2 = 0, 6 do
													if i2 >= 3 then
														if i2 > 4 then
															if i2 > 4 then
																for i3 = 13, 94 do
																	if i2 == 5 then
																		v5(v15[2], v15[3])
																		sum = sum + 1
																		v15 = v6[sum]
																	else
																		v5(v15[2], v15[3])
																	end

																	break
																end

																continue
															end

															v5(v15[2], v15[3])

															continue
														end

														if i2 > -1 then
															if i2 == 4 then
																v5(v15[2], v15[3])
																sum = sum + 1
																v15 = v6[sum]

																continue
															end

															v5(v15[2], v15[3])
															sum = sum + 1
															v15 = v6[sum]

															continue
														end

														v5(v15[2], v15[3])
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													if i2 <= 0 then
														v5(v15[2], v15[3])
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													if i2 == -2 then
														v5(v15[2], v15[3])
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													for i3 = 39, 54 do
														v5(v15[2], v15[3])
														sum = sum + 1
														v15 = v6[sum]

														break
													end
												end
											end

											break
										end
									else
										for i = 0, 6 do
											if i >= 3 then
												if i > 4 then
													if i > 4 then
														for i2 = 13, 94 do
															if i == 5 then
																v5(v15[2], v15[3])
																sum = sum + 1
																v15 = v6[sum]
															else
																v5(v15[2], v15[3])
															end

															break
														end

														continue
													end

													v5(v15[2], v15[3])

													continue
												end

												if i > -1 then
													if i == 4 then
														v5(v15[2], v15[3])
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													v5(v15[2], v15[3])
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												v5(v15[2], v15[3])
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i <= 0 then
												v5(v15[2], v15[3])
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i == -2 then
												v5(v15[2], v15[3])
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											for i2 = 39, 54 do
												v5(v15[2], v15[3])
												sum = sum + 1
												v15 = v6[sum]

												break
											end
										end
									end
								elseif v16 >= 45 then
									for i = 19, 80 do
										if v16 < 47 then
											v5[v15[2]] = p3[v15[3]]
										else
											local v40 = v15[2]
											local v42 = v40 + 2
											local t = { v5[v40](v5[v40 + 1], v5[v42]) }

											for i2 = 1, v15[4] do
												v5[v42 + i2] = t[i2]
											end

											local v43 = t[1]

											if v43 then
												v5[v42] = v43
												sum = v15[3]
											else
												sum = sum + 1
											end
										end

										break
									end
								else
									v5[v15[2]] = p3[v15[3]]
								end
							elseif v16 > 50 then
								if v16 > 52 then
									if v16 < 54 then
										v5[v15[2]] = v15[3] ~= 0
									else
										for i = 0, 2 do
											if i >= 1 then
												if i == 1 then
													v5[v15[2]] = v5[v15[3]][v15[4]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												local v46 = v15[2]
												local v47 = v5[v15[3]]

												v5[v46 + 1] = v47
												v5[v46] = v47[v15[4]]

												continue
											end

											local v48 = v15[2]

											v5[v48](v18(v5, v48 + 1, v15[3]))
											sum = sum + 1
											v15 = v6[sum]
										end
									end
								elseif v16 >= 47 then
									if v16 > 51 then
										sum = if v5[v15[2]] == v5[v15[4]] then sum + 1 else v15[3]
									else
										local v49 = v15[2]

										v5[v49] = v5[v49](v18(v5, v49 + 1, v15[3]))
									end
								else
									sum = if v5[v15[2]] == v5[v15[4]] then sum + 1 else v15[3]
								end
							else
								if v16 <= 48 then
									v5[v15[2]] = p3[v15[3]]

									local v50 = sum + 1
									local v51 = v6[v50][2]

									v5[v51] = v5[v51]()

									local v52 = v50 + 1
									local v53 = v6[v52]

									v5[v53[2]] = v5[v53[3]] + v53[4]

									local v54 = v52 + 1
									local v55 = v6[v54]

									v5[v55[2]][v5[v55[3]]] = v5[v55[4]]

									local _ = v6[v54 + 1]

									return
								end

								if v16 == 45 then
									v5[v15[2]] = p3[v15[3]]
								elseif v16 < 50 then
									sum = v15[3]
								else
									v5[v15[2]] = p3[v15[3]]
								end
							end
						elseif v16 >= 34 then
							if v16 < 37 then
								if v16 >= 35 then
									if v16 == 35 then
										v5[v15[2]] = p2[v15[3]]

										local v56 = sum + 1
										local v57 = v6[v56]
										local v58 = v57[2]
										local v59 = v5[v57[3]]

										v5[v58 + 1] = v59
										v5[v58] = v59[v57[4]]

										local v60 = v56 + 1
										local v61 = v6[v60]

										v5(v61[2], v61[3])

										local v62 = v60 + 1
										local v63 = v6[v62]
										local v64 = v63[2]

										v5[v64] = v5[v64](v18(v5, v64 + 1, v63[3]))

										local v65 = v62 + 1
										local v66 = v6[v65]

										v5[v66[2]] = p2[v66[3]]

										local v67 = v65 + 1
										local v68 = v6[v67]

										sum = if v5[v68[2]] then v68[3] else v67 + 1
									else
										local v69 = v15[2]
										local v70 = v5[v15[3]]

										v5[v69 + 1] = v70
										v5[v69] = v70[v15[4]]
									end
								else
									local v71 = v15[2]
									local t = { v5[v71](v18(v5, v71 + 1, v7)) }
									local count2 = 0

									for i = v71, v15[4] do
										count2 = count2 + 1
										v5[i] = t[count2]
									end
								end
							elseif v16 <= 38 then
								if v16 == 34 then
									local v72 = v15[2]
									local t = { v5[v72](v5[v72 + 1]) }
									local count2 = 0

									for i = v72, v15[4] do
										count2 = count2 + 1
										v5[i] = t[count2]
									end
								elseif v16 < 38 then
									v5[v15[2]] = v15[3] ~= 0
									sum = sum + 1
								else
									local v75 = v15[2]
									local t = { v5[v75](v5[v75 + 1]) }
									local count2 = 0

									for i = v75, v15[4] do
										count2 = count2 + 1
										v5[i] = t[count2]
									end
								end
							elseif v16 == 40 then
								p2[v15[3]] = v5[v15[2]]
							else
								for i = 0, 6 do
									if i < 3 then
										if i > 0 then
											if i > 0 then
												if i == 1 then
													local v76 = v15[2]

													v5[v76] = v5[v76](v18(v5, v76 + 1, v15[3]))
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												p2[v15[3]] = v5[v15[2]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											local v77 = v15[2]

											v5[v77] = v5[v77](v18(v5, v77 + 1, v15[3]))
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										v5(v15[2], v15[3])
										sum = sum + 1
										v15 = v6[sum]

										continue
									end

									if i >= 5 then
										if i == 1 then
											v5[v15[2]] = p2[v15[3]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										for i2 = 22, 78 do
											if i < 6 then
												v5[v15[2]] = p2[v15[3]]
												sum = sum + 1
												v15 = v6[sum]
											else
												v5[v15[2]] = p2[v15[3]]
											end

											break
										end

										continue
									end

									if i == 1 then
										v5[v15[2]] = p2[v15[3]]
										sum = sum + 1
										v15 = v6[sum]

										continue
									end

									for i2 = 29, 70 do
										if i == 3 then
											v5[v15[2]] = p2[v15[3]]
										else
											v5[v15[2]]()
										end

										sum = sum + 1
										v15 = v6[sum]

										break
									end
								end
							end
						elseif v16 <= 29 then
							if v16 <= 27 then
								local v78 = nil
								local v79 = nil
								local v80 = nil
								local v81 = nil
								local v822 = nil

								for i = 0, 6 do
									if i >= 3 then
										if i >= 5 then
											if i == 6 then
												local v83 = v15[2]

												v5[v83] = v5[v83](v18(v5, v83 + 1, v15[3]))

												continue
											end

											v5(v15[2], v15[3])
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i >= 2 then
											for i2 = 38, 97 do
												if i == 3 then
													v5[v15[2]] = p3[v15[3]]
												else
													local v84 = v15[2]
													local v85 = v5[v15[3]]

													v5[v84 + 1] = v85
													v5[v84] = v85[v15[4]]
												end

												sum = sum + 1
												v15 = v6[sum]

												break
											end

											continue
										end

										local v86 = v15[2]
										local v87 = v5[v15[3]]

										v5[v86 + 1] = v87
										v5[v86] = v87[v15[4]]
										sum = sum + 1
										v15 = v6[sum]

										continue
									end

									if i <= 0 then
										local v88 = v15[2]
										local v89 = v5[v15[3]]

										v5[v88 + 1] = v89
										v5[v88] = v89[v15[4]]
										sum = sum + 1
										v15 = v6[sum]

										continue
									end

									if i == 1 then
										local count2 = 0

										while count2 > -1 do
											if count2 <= 2 then
												if count2 < 1 then
													v822 = v15
												elseif count2 == -3 then
													v79 = 2
												else
													for i2 = 44, 56 do
														if count2 > 1 then
															v78 = 3
														else
															v79 = 2
														end

														break
													end
												end
											elseif count2 < 5 then
												if count2 > 1 then
													for i2 = 40, 75 do
														if count2 == 3 then
															v81 = v822[v78]
														else
															v80 = v822[v79]
														end

														break
													end
												else
													v81 = v822[v78]
												end
											elseif count2 > 5 then
												count2 = -2
											else
												v5(v80, v81)
											end

											count2 = count2 + 1
										end

										sum = sum + 1
										v15 = v6[sum]

										continue
									end

									local v90 = v15[2]

									v5[v90] = v5[v90](v18(v5, v90 + 1, v15[3]))
									sum = sum + 1
									v15 = v6[sum]
								end
							elseif v16 >= 25 then
								if v16 < 29 then
									local v91 = v15[2]
									local v92 = v5[v15[3]]

									v5[v91 + 1] = v92
									v5[v91] = v92[v15[4]]
								else
									for i = 0, 1 do
										if i == 0 then
											local v93 = v15[2]
											local v94 = v5[v15[3]]

											v5[v93 + 1] = v94
											v5[v93] = v94[v15[4]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										local v95 = v15[2]

										v5[v95] = v5[v95](v5[v95 + 1])
									end
								end
							else
								for i = 0, 1 do
									if i == 0 then
										local v96 = v15[2]
										local v97 = v5[v15[3]]

										v5[v96 + 1] = v97
										v5[v96] = v97[v15[4]]
										sum = sum + 1
										v15 = v6[sum]

										continue
									end

									local v98 = v15[2]

									v5[v98] = v5[v98](v5[v98 + 1])
								end
							end
						elseif v16 >= 32 then
							if v16 == 33 then
								sum = if v5[v15[2]] == v15[4] then v15[3] else sum + 1
							else
								local t = {}
								local v101 = v3.dctEoTkg({}, {
									__index = function(p1, p2) --[[ __index | Line: 2 | Upvalues: t (copy) ]]
										local v1 = t[p2]

										return v1[1][v1[2]]
									end,
									__newindex = function(p1, p2, p3) --[[ __newindex | Line: 2 | Upvalues: t (copy) ]]
										local v1 = t[p2]

										v1[1][v1[2]] = p3
									end
								})

								for i = 1, v15[4] do
									sum = sum + 1

									local v102 = v6[sum]

									if v102[1] == 14 then
										t[i - 1] = { v5, v102[3] }
									else
										t[i - 1] = { p2, v102[3] }
									end

									v9[#v9 + 1] = t
								end

								v5[v15[2]] = v8(v82[v15[3]], v101, p3)
							end
						elseif v16 >= 28 then
							for i = 31, 56 do
								if v16 < 31 then
									for i2 = 0, 2 do
										if i2 >= 1 then
											if i2 == 1 then
												v5(v15[2], v15[3])
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											local v103 = v15[2]
											local v104 = v5[v103]

											for i3 = v103 + 1, v15[3] do
												v3.IFbmkuUY(v104, v5[i3])
											end

											continue
										end

										v5(v15[2], v15[3])
										sum = sum + 1
										v15 = v6[sum]
									end
								else
									for i2 = 0, 2 do
										if i2 > 0 then
											if i2 >= -3 then
												if i2 < 2 then
													v5[v15[2]] = v5[v15[3]][v15[4]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												local v105 = v15[2]
												local v106 = v5[v15[3]]

												v5[v105 + 1] = v106
												v5[v105] = v106[v15[4]]

												continue
											end

											local v107 = v15[2]
											local v108 = v5[v15[3]]

											v5[v107 + 1] = v108
											v5[v107] = v108[v15[4]]

											continue
										end

										local v109 = v15[2]

										v5[v109](v18(v5, v109 + 1, v15[3]))
										sum = sum + 1
										v15 = v6[sum]
									end
								end

								break
							end
						else
							for i = 0, 2 do
								if i >= 1 then
									if i == 1 then
										v5(v15[2], v15[3])
										sum = sum + 1
										v15 = v6[sum]

										continue
									end

									local v110 = v15[2]
									local v111 = v5[v110]

									for i2 = v110 + 1, v15[3] do
										v3.IFbmkuUY(v111, v5[i2])
									end

									continue
								end

								v5(v15[2], v15[3])
								sum = sum + 1
								v15 = v6[sum]
							end
						end
					elseif v16 < 82 then
						if v16 < 68 then
							if v16 > 60 then
								if v16 > 63 then
									if v16 <= 65 then
										if v16 > 61 then
											for i = 40, 52 do
												if v16 ~= 65 then
													return
												end

												local v112 = nil
												local v113 = nil
												local v114 = nil
												local v115 = nil
												local v116 = nil
												local v117 = nil

												for i2 = 0, 5 do
													if i2 >= 3 then
														if i2 <= 3 then
															local count2 = 0

															while count2 > -1 do
																if count2 < 4 then
																	if count2 < 2 then
																		if count2 < 1 then
																			v115 = v15
																		else
																			v112 = 2
																		end
																	elseif count2 == 0 or count2 == 3 then
																		v117 = v5
																	else
																		v116 = 3
																	end
																elseif count2 < 6 then
																	if count2 > 3 then
																		for i3 = 38, 77 do
																			if count2 < 5 then
																				v114 = v117[v115[v116]]
																			else
																				v113 = v115[v112]
																			end

																			break
																		end
																	else
																		v113 = v115[v112]
																	end
																elseif count2 > 2 then
																	for i3 = 19, 86 do
																		if count2 > 6 then
																			count2 = -2
																		else
																			v5[v113] = v114
																		end

																		break
																	end
																else
																	count2 = -2
																end

																count2 = count2 + 1
															end

															sum = sum + 1
															v15 = v6[sum]

															continue
														end

														if i2 == 3 then
															sum = if v5[v15[2]] then sum + 1 else v15[3]

															continue
														end

														for i3 = 27, 65 do
															if i2 < 5 then
																local v118 = v15[2]

																v5[v118] = v5[v118](v5[v118 + 1])
																sum = sum + 1
																v15 = v6[sum]
															else
																sum = if v5[v15[2]] then sum + 1 else v15[3]
															end

															break
														end

														continue
													end

													if i2 >= 1 then
														if i2 > -2 then
															if i2 < 2 then
																v5[v15[2]]()
																sum = sum + 1
																v15 = v6[sum]

																continue
															end

															v5[v15[2]] = p2[v15[3]]
															sum = sum + 1
															v15 = v6[sum]

															continue
														end

														v5[v15[2]]()
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													v5[v15[2]] = p2[v15[3]]
													sum = sum + 1
													v15 = v6[sum]
												end

												break
											end
										else
											local v119 = nil
											local v120 = nil
											local v121 = nil
											local v122 = nil
											local v123 = nil
											local v124 = nil

											for i = 0, 5 do
												if i >= 3 then
													if i <= 3 then
														local count2 = 0

														while count2 > -1 do
															if count2 < 4 then
																if count2 < 2 then
																	if count2 < 1 then
																		v122 = v15
																	else
																		v119 = 2
																	end
																elseif count2 == 0 or count2 == 3 then
																	v124 = v5
																else
																	v123 = 3
																end
															elseif count2 < 6 then
																if count2 > 3 then
																	for i2 = 38, 77 do
																		if count2 < 5 then
																			v121 = v124[v122[v123]]
																		else
																			v120 = v122[v119]
																		end

																		break
																	end
																else
																	v120 = v122[v119]
																end
															elseif count2 > 2 then
																for i2 = 19, 86 do
																	if count2 > 6 then
																		count2 = -2
																	else
																		v5[v120] = v121
																	end

																	break
																end
															else
																count2 = -2
															end

															count2 = count2 + 1
														end

														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													if i == 3 then
														sum = if v5[v15[2]] then sum + 1 else v15[3]

														continue
													end

													for i2 = 27, 65 do
														if i < 5 then
															local v125 = v15[2]

															v5[v125] = v5[v125](v5[v125 + 1])
															sum = sum + 1
															v15 = v6[sum]
														else
															sum = if v5[v15[2]] then sum + 1 else v15[3]
														end

														break
													end

													continue
												end

												if i >= 1 then
													if i > -2 then
														if i < 2 then
															v5[v15[2]]()
															sum = sum + 1
															v15 = v6[sum]

															continue
														end

														v5[v15[2]] = p2[v15[3]]
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													v5[v15[2]]()
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												v5[v15[2]] = p2[v15[3]]
												sum = sum + 1
												v15 = v6[sum]
											end
										end
									elseif v16 == 67 then
										local v126 = v15[2]

										v5[v126](v5[v126 + 1])
									else
										local v127 = v15[2]

										v5[v127] = v5[v127](v18(v5, v127 + 1, v15[3]))
									end
								elseif v16 < 62 then
									local v128 = v15[2]

									v5[v128](v18(v5, v128 + 1, v15[3]))
								elseif v16 == 60 then
									for i = 0, 1 do
										if i == -1 then
											v5[v15[2]] = v5[v15[3]][v15[4]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										for i2 = 44, 77 do
											if i == 1 then
												local v129 = v15[2]
												local v130 = v5[v15[3]]

												v5[v129 + 1] = v130
												v5[v129] = v130[v15[4]]
											else
												v5[v15[2]] = v5[v15[3]][v15[4]]
												sum = sum + 1
												v15 = v6[sum]
											end

											break
										end
									end
								elseif v16 == 62 then
									v5[v15[2]] = v5[v15[3]] + v5[v15[4]]
								else
									for i = 0, 1 do
										if i == -1 then
											v5[v15[2]] = v5[v15[3]][v15[4]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										for i2 = 44, 77 do
											if i == 1 then
												local v131 = v15[2]
												local v132 = v5[v15[3]]

												v5[v131 + 1] = v132
												v5[v131] = v132[v15[4]]
											else
												v5[v15[2]] = v5[v15[3]][v15[4]]
												sum = sum + 1
												v15 = v6[sum]
											end

											break
										end
									end
								end
							elseif v16 >= 58 then
								if v16 >= 59 then
									if v16 == 57 then
										for i = 0, 4 do
											if i >= 2 then
												if i < 3 then
													v5[v15[2]] = p2[v15[3]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												if i == 4 then
													local v133 = v15[2]

													v5[v133](v5[v133 + 1])

													continue
												end

												v5[v15[2]] = v5[v15[3]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i < 1 then
												v5[v15[2]] = v5[v15[3]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											local v134 = v15[2]

											v5[v134](v5[v134 + 1])
											sum = sum + 1
											v15 = v6[sum]
										end
									else
										for i = 20, 66 do
											if v16 < 60 then
												sum = if v5[v15[2]] == v5[v15[4]] then v15[3] else sum + 1
											else
												for i2 = 0, 4 do
													if i2 >= 2 then
														if i2 < 3 then
															v5[v15[2]] = p2[v15[3]]
															sum = sum + 1
															v15 = v6[sum]

															continue
														end

														if i2 == 4 then
															local v135 = v15[2]

															v5[v135](v5[v135 + 1])

															continue
														end

														v5[v15[2]] = v5[v15[3]]
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													if i2 < 1 then
														v5[v15[2]] = v5[v15[3]]
														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													local v136 = v15[2]

													v5[v136](v5[v136 + 1])
													sum = sum + 1
													v15 = v6[sum]
												end
											end

											break
										end
									end
								else
									local v137 = v15[2]

									v5[v137] = v5[v137](v5[v137 + 1])
								end
							elseif v16 >= 56 then
								if v16 > 54 then
									if v16 < 57 then
										v5[v15[2]][v15[3]] = v15[4]

										local v138 = sum + 1
										local v139 = v6[v138]

										v5[v139[2]][v139[3]] = v139[4]

										local v140 = v138 + 1
										local v141 = v6[v140]

										v5[v141[2]][v141[3]] = v141[4]

										local v142 = v140 + 1
										local v143 = v6[v142]

										v5[v143[2]][v143[3]] = v143[4]

										local v144 = v142 + 1
										local v145 = v6[v144]

										v5[v145[2]] = v145[3] ~= 0

										local v148 = v144 + 1
										local v149 = v6[v148]

										v5[v149[2]] = if v149[3] == 0 then false else true
										sum = v148 + 1

										local v152 = v6[sum]

										v5[v152[2]] = if v152[3] == 0 then false else true
									else
										for i = 0, 2 do
											if i <= 0 then
												local v155 = v15[2]

												v5[v155](v18(v5, v155 + 1, v15[3]))
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i == 2 then
												local v156 = v15[2]
												local v157 = v5[v15[3]]

												v5[v156 + 1] = v157
												v5[v156] = v157[v15[4]]

												continue
											end

											v5[v15[2]] = v5[v15[3]][v15[4]]
											sum = sum + 1
											v15 = v6[sum]
										end
									end
								else
									v5[v15[2]][v15[3]] = v15[4]

									local v158 = sum + 1
									local v159 = v6[v158]

									v5[v159[2]][v159[3]] = v159[4]

									local v160 = v158 + 1
									local v161 = v6[v160]

									v5[v161[2]][v161[3]] = v161[4]

									local v162 = v160 + 1
									local v163 = v6[v162]

									v5[v163[2]][v163[3]] = v163[4]

									local v164 = v162 + 1
									local v165 = v6[v164]

									v5[v165[2]] = v165[3] ~= 0

									local v168 = v164 + 1
									local v169 = v6[v168]

									v5[v169[2]] = if v169[3] == 0 then false else true
									sum = v168 + 1

									local v172 = v6[sum]

									v5[v172[2]] = if v172[3] == 0 then false else true
								end
							else
								local v175 = v15[2]
								local v176, v177 = v10(v5[v175](v18(v5, v175 + 1, v15[3])))

								v7 = v177 + v175 - 1

								local count2 = 0

								for i = v175, v7 do
									count2 = count2 + 1
									v5[i] = v176[count2]
								end
							end
						elseif v16 <= 74 then
							if v16 >= 71 then
								if v16 < 73 then
									if v16 > 67 and v16 == 71 then
										local v178 = nil
										local v179 = nil
										local v180 = nil
										local v181 = nil
										local v182 = nil

										for i = 0, 6 do
											if i <= 2 then
												if i <= 0 then
													v5(v15[2], v15[3])
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												if i >= 0 then
													if i == 1 then
														local count2 = 0

														while count2 > -1 do
															if count2 <= 2 then
																if count2 >= 1 then
																	if count2 > -3 and count2 == 2 then
																		v181 = 3
																	else
																		v180 = 2
																	end
																else
																	v179 = v15
																end
															elseif count2 >= 5 then
																if count2 == 5 then
																	v5(v182, v178)
																else
																	count2 = -2
																end
															elseif count2 == 2 then
																v182 = v179[v180]
															else
																for i2 = 13, 88 do
																	if count2 == 3 then
																		v178 = v179[v181]
																	else
																		v182 = v179[v180]
																	end

																	break
																end
															end

															count2 = count2 + 1
														end

														sum = sum + 1
														v15 = v6[sum]

														continue
													end

													v5(v15[2], v15[3])
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												local count2 = 0

												while count2 > -1 do
													if count2 <= 2 then
														if count2 >= 1 then
															if count2 > -3 and count2 == 2 then
																v181 = 3
															else
																v180 = 2
															end
														else
															v179 = v15
														end
													elseif count2 >= 5 then
														if count2 == 5 then
															v5(v182, v178)
														else
															count2 = -2
														end
													elseif count2 == 2 then
														v182 = v179[v180]
													else
														for i2 = 13, 88 do
															if count2 == 3 then
																v178 = v179[v181]
															else
																v182 = v179[v180]
															end

															break
														end
													end

													count2 = count2 + 1
												end

												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i >= 5 then
												if i >= 2 then
													if i > 5 then
														v5(v15[2], v15[3])

														continue
													end

													v5(v15[2], v15[3])
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												v5(v15[2], v15[3])

												continue
											end

											if i > 0 then
												for i2 = 28, 83 do
													v5(v15[2], v15[3])
													sum = sum + 1
													v15 = v6[sum]

													break
												end

												continue
											end

											v5(v15[2], v15[3])
											sum = sum + 1
											v15 = v6[sum]
										end
									else
										v5[v15[2]][v5[v15[3]]] = v15[4]
									end
								elseif v16 == 69 then
									local v183 = v15[2]
									local v184, v185 = v10(v5[v183](v5[v183 + 1]))

									v7 = v185 + v183 - 1

									local count2 = 0

									for i = v183, v7 do
										count2 = count2 + 1
										v5[i] = v184[count2]
									end
								else
									for i = 44, 61 do
										if not (v16 > 73) then
											return
										end

										local v186 = v15[2]
										local v187, v188 = v10(v5[v186](v5[v186 + 1]))

										v7 = v188 + v186 - 1

										local count2 = 0

										for i2 = v186, v7 do
											count2 = count2 + 1
											v5[i2] = v187[count2]
										end

										break
									end
								end
							elseif v16 <= 68 then
								v5[v15[2]][v5[v15[3]]] = v5[v15[4]]
							elseif v16 > 65 and v16 == 69 then
								v5[v15[2]] = v15[3] ~= 0
							else
								v5[v15[2]] = v15[3] ~= 0
								sum = sum + 1
							end
						elseif v16 <= 77 then
							if v16 <= 75 then
								v5(v15[2], v15[3])
							elseif v16 >= 74 then
								for i = 18, 69 do
									if v16 == 76 then
										v5[v15[2]] = v5[v15[3]] + v15[4]
									else
										local v195 = v15[2]
										local t = { v5[v195](v5[v195 + 1]) }
										local count2 = 0

										for i2 = v195, v15[4] do
											count2 = count2 + 1
											v5[i2] = t[count2]
										end
									end

									break
								end
							else
								local v196 = v15[2]
								local t = { v5[v196](v5[v196 + 1]) }
								local count2 = 0

								for i = v196, v15[4] do
									count2 = count2 + 1
									v5[i] = t[count2]
								end
							end
						elseif v16 <= 79 then
							if v16 > 78 then
								sum = if v5[v15[2]] then sum + 1 else v15[3]
							else
								local t = {}
								local v199 = v3.dctEoTkg({}, {
									__index = function(p1, p2) --[[ __index | Line: 2 | Upvalues: t (copy) ]]
										local v1 = t[p2]

										return v1[1][v1[2]]
									end,
									__newindex = function(p1, p2, p3) --[[ __newindex | Line: 2 | Upvalues: t (copy) ]]
										local v1 = t[p2]

										v1[1][v1[2]] = p3
									end
								})

								for i = 1, v15[4] do
									sum = sum + 1

									local v200 = v6[sum]

									if v200[1] == 14 then
										t[i - 1] = { v5, v200[3] }
									else
										t[i - 1] = { p2, v200[3] }
									end

									v9[#v9 + 1] = t
								end

								v5[v15[2]] = v8(v82[v15[3]], v199, p3)
							end
						elseif v16 >= 76 then
							for i = 32, 82 do
								if v16 < 81 then
									local v201 = v15[2]
									local v202 = v5[v201]

									for i2 = v201 + 1, v15[3] do
										v3.IFbmkuUY(v202, v5[i2])
									end
								else
									sum = if v5[v15[2]] then v15[3] else sum + 1
								end

								break
							end
						else
							sum = if v5[v15[2]] then v15[3] else sum + 1
						end
					elseif v16 > 95 then
						if v16 > 102 then
							if v16 > 105 then
								if v16 < 108 then
									if v16 >= 103 then
										if v16 > 106 then
											p3[v15[3]] = v5[v15[2]]
										else
											local v203 = v15[2]
											local v204 = v5[v203]

											for i = v203 + 1, v15[3] do
												v3.IFbmkuUY(v204, v5[i])
											end
										end
									else
										local v205 = v15[2]
										local v206 = v5[v205]

										for i = v205 + 1, v15[3] do
											v3.IFbmkuUY(v206, v5[i])
										end
									end
								elseif v16 > 105 then
									if v16 < 109 then
										v5[v15[2]] = v5[v15[3]] + v5[v15[4]]
									else
										for i = 0, 5 do
											if i >= 3 then
												if i <= 3 then
													v5[v15[2]] = v5[v15[3]][v15[4]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												if i >= 1 then
													if i > 4 then
														sum = if v5[v15[2]] then v15[3] else sum + 1

														continue
													end

													v5[v15[2]] = v5[v15[3]][v15[4]]
													sum = sum + 1
													v15 = v6[sum]

													continue
												end

												v5[v15[2]] = v5[v15[3]][v15[4]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i < 1 then
												local v207 = v15[2]
												local v208 = v5[v15[3]]

												v5[v207 + 1] = v208
												v5[v207] = v208[v15[4]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i > 1 then
												local v209 = v15[2]

												v5[v209] = v5[v209](v18(v5, v209 + 1, v15[3]))
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											v5(v15[2], v15[3])
											sum = sum + 1
											v15 = v6[sum]
										end
									end
								else
									for i = 0, 5 do
										if i >= 3 then
											if i <= 3 then
												v5[v15[2]] = v5[v15[3]][v15[4]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i >= 1 then
												if i > 4 then
													sum = if v5[v15[2]] then v15[3] else sum + 1

													continue
												end

												v5[v15[2]] = v5[v15[3]][v15[4]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											v5[v15[2]] = v5[v15[3]][v15[4]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i < 1 then
											local v210 = v15[2]
											local v211 = v5[v15[3]]

											v5[v210 + 1] = v211
											v5[v210] = v211[v15[4]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i > 1 then
											local v212 = v15[2]

											v5[v212] = v5[v212](v18(v5, v212 + 1, v15[3]))
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										v5(v15[2], v15[3])
										sum = sum + 1
										v15 = v6[sum]
									end
								end
							else
								if v16 < 104 then
									return v5[v15[2]]
								end

								if v16 > 104 then
									for i = 0, 4 do
										if i <= 1 then
											if i < 1 then
												v5[v15[2]] = p2[v15[3]]
												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											local v213 = v15[2]
											local v214 = v5[v15[3]]

											v5[v213 + 1] = v214
											v5[v213] = v214[v15[4]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i < 3 then
											local v215 = v15[2]
											local v216, v217 = v10(v5[v215](v5[v215 + 1]))

											v7 = v217 + v215 - 1
											count2 = 0
											v218 = v216

											for i2 = v215, v7 do
												count2 = count2 + 1
												v5[i2] = v218[count2]
											end

											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i == -1 then
											sum = v15[3]

											continue
										end

										for i2 = 20, 98 do
											if i == 3 then
												local v219 = v15[2]
												local count2, v220 = 0, { v5[v219](v18(v5, v219 + 1, v7)) }

												for i3 = v219, v15[4] do
													count2 = count2 + 1
													v5[i3] = v220[count2]
												end

												sum = sum + 1
												v15 = v6[sum]
											else
												sum = v15[3]
											end

											break
										end
									end
								else
									local v221 = v15[2]
									local v222, v223 = v10(v5[v221](v18(v5, v221 + 1, v15[3])))

									v7 = v223 + v221 - 1

									local count2 = 0

									for i = v221, v7 do
										count2 = count2 + 1
										v5[i] = v222[count2]
									end
								end
							end
						elseif v16 < 99 then
							if v16 > 96 then
								if v16 == 97 then
									sum = if v5[v15[2]] then v15[3] else sum + 1
								else
									v5[v15[2]] = v5[v15[3]] * v5[v15[4]]
								end
							else
								p2[v15[3]] = v5[v15[2]]

								local v224 = sum + 1
								local v225 = v6[v224]

								v5[v225[2]] = p2[v225[3]]

								local v226 = v224 + 1
								local v227 = v6[v226]
								local v228 = v227[2]
								local v229 = v5[v227[3]]

								v5[v228 + 1] = v229
								v5[v228] = v229[v227[4]]

								local v230 = v226 + 1
								local v231 = v6[v230]

								v5(v231[2], v231[3])

								local v232 = v230 + 1
								local v233 = v6[v232]
								local v234 = v233[2]

								v5[v234] = v5[v234](v18(v5, v234 + 1, v233[3]))

								local v235 = v232 + 1
								local v236 = v6[v235]

								p2[v236[3]] = v5[v236[2]]
								sum = v235 + 1

								local v237 = v6[sum]

								v5[v237[2]] = p2[v237[3]]
							end
						elseif v16 > 100 then
							if v16 == 101 then
								local v238 = v15[2]

								v5[v238] = v5[v238](v18(v5, v238 + 1, v7))
							else
								local v239 = v15[2]
								local v241 = v239 + 2
								local t = { v5[v239](v5[v239 + 1], v5[v241]) }

								for i = 1, v15[4] do
									v5[v241 + i] = t[i]
								end

								local v242 = t[1]

								if v242 then
									v5[v241] = v242
									sum = v15[3]
								else
									sum = sum + 1
								end
							end
						elseif v16 == 100 then
							local v243 = v15[2]

							v5[v243](v18(v5, v243 + 1, v15[3]))
						else
							local v244 = v15[2]
							local v245, v246 = v10(v5[v244](v5[v244 + 1]))

							v7 = v246 + v244 - 1

							local count2 = 0

							for i = v244, v7 do
								count2 = count2 + 1
								v5[i] = v245[count2]
							end
						end
					elseif v16 > 88 then
						if v16 > 91 then
							if v16 > 93 then
								if v16 >= 92 then
									for i = 21, 74 do
										if v16 > 94 then
											v5[v15[2]] = v5[v15[3]]
										else
											v5[v15[2]] = v5[v15[3]][v15[4]]
										end

										break
									end
								else
									v5[v15[2]] = v5[v15[3]][v15[4]]
								end
							elseif v16 == 92 then
								v5[v15[2]]()
							else
								v5[v15[2]] = p2[v15[3]]

								local v247 = sum + 1
								local v248 = v6[v247]

								v5[v248[2]] = v5[v248[3]][v248[4]]

								local v249 = v247 + 1
								local v250 = v6[v249]

								v5[v250[2]] = p3[v250[3]]

								local v251 = v249 + 1
								local v252 = v6[v251]

								v5[v252[2]] = v5[v252[3]][v252[4]]

								local v253 = v251 + 1
								local v254 = v6[v253]

								v5[v254[2]] = v5[v254[3]][v254[4]]

								local v255 = v253 + 1
								local v256 = v6[v255]

								sum = if v5[v256[2]] == v5[v256[4]] then v256[3] else v255 + 1
							end
						elseif v16 < 90 then
							p2[v15[3]] = v5[v15[2]]
						elseif v16 == 90 then
							v5[v15[2]] = v5[v15[3]][v15[4]]

							local v257 = sum + 1
							local v258 = v6[v257]
							local v259 = v258[2]
							local v260 = v5[v258[3]]

							v5[v259 + 1] = v260
							v5[v259] = v260[v258[4]]

							local v261 = v257 + 1
							local v262 = v6[v261]

							v5(v262[2], v262[3])

							local v263 = v261 + 1
							local v264 = v6[v263]
							local v265 = v264[2]
							local v266, v267 = v10(v5[v265](v18(v5, v265 + 1, v264[3])))
							local v268 = v266

							v7 = v267 + v265 - 1

							local count2 = 0

							for i = v265, v7 do
								count2 = count2 + 1
								v5[i] = v268[count2]
							end

							local v269 = v263 + 1
							local v270 = v6[v269][2]

							v5[v270] = v5[v270](v18(v5, v270 + 1, v7))

							local v271 = v269 + 1
							local v272 = v6[v271]

							sum = if v5[v272[2]] then v272[3] else v271 + 1
						else
							v5[v15[2]] = p2[v15[3]]
						end
					elseif v16 <= 84 then
						if v16 <= 82 then
							local v273 = v15[2]
							local t = { v5[v273](v18(v5, v273 + 1, v7)) }
							local count2 = 0

							for i = v273, v15[4] do
								count2 = count2 + 1
								v5[i] = t[count2]
							end
						else
							if not (v16 > 80) then
								local v274 = v15[2]

								v5[v274](v18(v5, v274 + 1, v15[3]))

								local v275 = sum + 1
								local v276 = v6[v275]

								v5[v276[2]] = v5[v276[3]]

								local v277 = v275 + 1
								local v278 = v6[v277]

								v5[v278[2]] = v5[v278[3]]

								local v279 = v277 + 1
								local v280 = v6[v279][2]

								v5[v280](v5[v280 + 1])

								local _ = v6[v279 + 1]

								return
							end

							if v16 < 84 then
								local v281 = v15[2]

								v5[v281](v18(v5, v281 + 1, v15[3]))

								local v282 = sum + 1
								local v283 = v6[v282]

								v5[v283[2]] = v5[v283[3]]

								local v284 = v282 + 1
								local v285 = v6[v284]

								v5[v285[2]] = v5[v285[3]]

								local v286 = v284 + 1
								local v287 = v6[v286][2]

								v5[v287](v5[v287 + 1])

								local _ = v6[v286 + 1]

								return
							end

							v5[v15[2]][v15[3]] = v5[v15[4]]
						end
					elseif v16 > 86 then
						if v16 >= 83 then
							for i = 28, 62 do
								if v16 == 87 then
									local v288 = v15[2]

									v5[v288] = v5[v288]()
								else
									local v289 = nil
									local v290 = nil
									local v291 = nil
									local v292 = nil
									local v293 = nil

									for i2 = 0, 4 do
										if i2 > 1 then
											if i2 < 3 then
												local count2 = 0

												while count2 > -1 do
													if count2 > 2 then
														if count2 >= 5 then
															if count2 >= 3 then
																for i3 = 16, 85 do
																	if count2 > 5 then
																		count2 = -2
																	else
																		v5(v290, v291)
																	end

																	break
																end
															else
																v5(v290, v291)
															end
														elseif count2 == 4 then
															v290 = v292[v293]
														else
															v291 = v292[v289]
														end
													elseif count2 > 0 then
														if count2 > -2 then
															if count2 == 1 then
																v293 = 2
															else
																v289 = 3
															end
														else
															v293 = 2
														end
													else
														v292 = v15
													end

													count2 = count2 + 1
												end

												sum = sum + 1
												v15 = v6[sum]

												continue
											end

											if i2 > 3 then
												sum = if v5[v15[2]] then v15[3] else sum + 1

												continue
											end

											local v294 = v15[2]

											v5[v294] = v5[v294](v18(v5, v294 + 1, v15[3]))
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										if i2 == 1 then
											local v295 = v15[2]
											local v296 = v5[v15[3]]

											v5[v295 + 1] = v296
											v5[v295] = v296[v15[4]]
											sum = sum + 1
											v15 = v6[sum]

											continue
										end

										v5[v15[2]] = p2[v15[3]]
										sum = sum + 1
										v15 = v6[sum]
									end
								end

								break
							end
						else
							local v297 = v15[2]

							v5[v297] = v5[v297]()
						end
					elseif v16 == 82 then
						local v298 = v15[2]

						v5[v298](v5[v298 + 1])
					elseif v16 > 85 then
						local v299 = v15[2]

						v5[v299](v5[v299 + 1])
					else
						v5[v15[2]] = v5[v15[3]][v15[4]]
					end

					sum = 1 + sum
				end
			end
		end

		local v9 = 255
		local t2 = {}
		local v10 = 1
		local v11 = ""

		(function(p1) --[[ Line: 2 | Upvalues: v11 (ref), t2 (copy), v10 (ref), v72 (copy), v9 (ref), v17 (ref), ke (copy), v18 (ref) ]]
			local v1 = p1
			local v2 = 0
			local v3 = 0

			v1 = { function(p12) --[[ Line: 2 | Upvalues: v2 (ref), v3 (ref), p1 (copy), v1 (ref), v11 (ref), t2 (ref), v10 (ref), v72 (ref), v9 (ref) ]]
					if v2 > 47 then
						return p12
					end

					v2 = v2 + 1
					v3 = (v3 + 1682 - p12) % 72

					local v12 = v3 % 3 == 1 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 217

						return true
					end)("vzXiq") and v1[2](339 + p12) or (v3 % 3 == 0 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref), v11 (ref), t2 (ref), v10 (ref), v72 (ref), v9 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 42
						v11 = { v11 .. ": a", v11 }
						t2[v10] = v72()
						v10 = v10 + 1
						v11[1] = ":" .. v11[1]
						v9[2] = 255

						return true
					end)("qRffa") and v1[3](p12 + 252) or (v3 % 3 == 2 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 106

						return true
					end)("XRPas") and v1[1](p12 + 211) or p12))

					return v12
				end, function(p12) --[[ Line: 2 | Upvalues: v2 (ref), v3 (ref), p1 (copy), v1 (ref), t2 (ref), v10 (ref), v17 (ref), v9 (ref) ]]
					if v2 > 41 then
						return p12
					end

					v2 = v2 + 1
					v3 = (v3 + 3418 - p12) % 29

					local v12 = v3 % 3 == 0 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 100

						return true
					end)("LoXkx") and v1[3](291 + p12) or (v3 % 3 == 2 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 136

						return true
					end)("FayxE") and v1[2](p12 + 935) or (v3 % 3 == 1 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref), t2 (ref), v10 (ref), v17 (ref), v9 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 151
						t2[v10] = v17()
						v10 = v10 + v9

						return true
					end)("yYkmM") and v1[1](p12 + 736) or p12))

					return v12
				end, function(p12) --[[ Line: 2 | Upvalues: v2 (ref), v3 (ref), p1 (copy), v11 (ref), v9 (ref), v1 (ref), ke (ref), t2 (ref), v18 (ref), v10 (ref) ]]
					if v2 > 44 then
						return p12
					end

					v2 = v2 + 1
					v3 = (v3 + 3281 - p12) % 78

					local v12 = v3 % 3 == 2 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref), v11 (ref), v9 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 246
						v11 = "%"
						v9 = { function() --[[ Line: 2 | Upvalues: v9 (ref) ]]
								v9()
							end }
						v11 = v11 .. "d+"

						return true
					end)("hDiaS") and v1[1](131 + p12) or (v3 % 3 == 1 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref), v9 (ref), ke (ref), t2 (ref), v18 (ref), v11 (ref), v10 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 69
						v9[2] = v9[2] * (ke(function() --[[ Line: 2 | Upvalues: t2 (ref) ]]
							t2()
						end, v18(v11)) - ke(v9[1], v18(v11))) + 1
						t2[v10] = {}
						v9 = v9[2]
						v10 = v10 + v9

						return true
					end)("EyVPt") and v1[2](p12 + 585) or (v3 % 3 == 0 and (function(p12) --[[ Line: 2 | Upvalues: p1 (ref), v3 (ref) ]]
						if p1[p12] then
							return true
						end

						v3 = v3 + 1
						p1[p12] = 107

						return true
					end)("dwiRt") and v1[3](p12 + 390) or p12))

					return v12
				end }
			v1[3](5094)
		end)({})

		return v8(v18(t2))(...)
	end

	return ke((function() --[[ Line: 2 | Upvalues: v3 (ref), ke (copy) ]]
		local t = {}
		local v1 = 1
		local v4 = if v3.hXyFacRw(if v3.qmTFvbEi then v3.qmTFvbEi(ke) else "", v3.WsdXXrGX) then v1 + 0 else v1 + 1

		t[v4] = 2
		t[t[v4] + 1] = 3

		return t
	end)(), ...)
end

return f1(function(p1, p2, p3, p4, p5, p6) --[[ Line: 2 ]]
	if p1 >= 4 then
		if p1 <= 5 then
			if p1 == 5 then
				return function() --[[ Line: 2 | Upvalues: p2 (copy), p3 (copy), p4 (copy) ]]
					local v1 = p2(p3, p4(p4, p4), p4(p4, p4))

					p4(1)

					return v1
				end
			end

			local v1, v2, v3 = p5(2)

			return function() --[[ Line: 2 | Upvalues: p2 (copy), p3 (copy), p4 (copy), v1 (copy), v2 (copy), v3 (copy) ]]
				local v12, v22, v32, v4 = p2(p3, p4(p4, p4), p4(p4, p4) + 3)

				p4(4)

				return v4 * v1 + v32 * v2 + v22 * v3 + v12
			end
		end

		if p1 <= 6 then
			return p5[p3]
		end

		if not (p1 > 4) then
			return setmetatable({}, {
				__call = function(p1, p2, p3, p4, p5) --[[ Line: 2 ]]
					if p5 then
						return p1[p5]
					end

					if p4 then
						return p1
					end

					p1[p2] = p3
				end
			})
		end

		for i = 11, 78 do
			if p1 < 8 then
				return setmetatable({}, {
					__call = function(p1, p2, p3, p4, p5) --[[ Line: 2 ]]
						if p5 then
							return p1[p5]
						end

						if p4 then
							return p1
						end

						p1[p2] = p3
					end
				})
			end

			return p3(p1, nil, p3)
		end

		return
	end

	if p1 <= 1 then
		if p1 < 1 then
			return p2(1), p2(4, p5, p4, p3, p2), p2(5, p5, p4, p3)
		end

		return function(p1, p2, p3) --[[ Line: 2 ]]
			if p3 then
				local v1 = p1 / 2 ^ (p2 - 1) % 2 ^ (p3 - 1 - (p2 - 1) + 1)

				return v1 - v1 % 1
			end

			local v2 = 2 ^ (p2 - 1)

			if v2 <= p1 % (v2 + v2) then
				return 1
			end

			return 0
		end
	end

	if p1 == -2 then
		return p2(1), p2(4, p5, p4, p3, p2), p2(5, p5, p4, p3)
	end

	for j = 10, 76 do
		if p1 == 3 then
			return p2(1), p2(4, p5, p4, p3, p2), p2(5, p5, p4, p3)
		end

		return 16777216, 65536, 256
	end
end, ...)