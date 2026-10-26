hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death), function() end)
hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Respawn), function() end)
World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

function MaterialMon()
	if _G.SelectMaterial == "Radiactive Material" then
		MMon = "Factory Staff"
		MPos = CFrame.new(-105.889565, 72.8076935, -670.247986, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747)
		SP = "Bar"
	elseif _G.SelectMaterial == "Leather + Scrap Metal" then
		if game.PlaceId ~= 2753915549 then
			if game.PlaceId == 4442272183 then
				MMon = "Mercenary"
				MPos = CFrame.new(-986.774475, 72.8755951, 1088.44653, -0.656062722, 0, 0.754706323, 0, 1, 0, -0.754706323, 0, -0.656062722)
				SP = "DressTown"
			else
				if game.PlaceId ~= 7449423635 then
					return
				end

				MMon = "Pirate Millionaire"
				MPos = CFrame.new(-118.809372, 55.4874573, 5649.17041, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
				SP = "Default"
			end
		else
			MMon = "Pirate"
			MPos = CFrame.new(-967.433105, 13.5999937, 4034.24707, -0.258864403, 0, -0.965913713, 0, 1, 0, 0.965913713, 0, -0.258864403)
			SP = "Pirate"
			MMon = "Brute"
			MPos = CFrame.new(-1191.41235, 15.5999985, 4235.50928, 0.629286051, 0, -0.777173758, 0, 1, 0, 0.777173758, 0, 0.629286051)
			SP = "Pirate"
		end
	elseif _G.SelectMaterial == "Magma Ore" then
		if game.PlaceId ~= 2753915549 then
			if game.PlaceId ~= 4442272183 then
				return
			end

			MMon = "Lava Pirate"
			MPos = CFrame.new(-5158.77051, 14.4791956, -4654.2627, -0.848060489, 0, -0.529899538, 0, 1, 0, 0.529899538, 0, -0.848060489)
			SP = "CircleIslandFire"
		else
			MMon = "Military Soldier"
			MPos = CFrame.new(-5565.60156, 9.10001755, 8327.56934, -0.838688731, 0, -0.544611216, 0, 1, 0, 0.544611216, 0, -0.838688731)
			SP = "Magma"
			MMon = "Military Spy"
			MPos = CFrame.new(-5806.70068, 78.5000458, 8904.46973, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247)
			SP = "Magma"
		end
	elseif _G.SelectMaterial == "Fish Tail" then
		if game.PlaceId ~= 2753915549 then
			if game.PlaceId ~= 7449423635 then
				return
			end

			MMon = "Fishman Captain"
			MPos = CFrame.new(-10828.1064, 331.825989, -9049.14648, -0.0912091732, 0, 0.995831788, 0, 1, 0, -0.995831788, 0, -0.0912091732)
			SP = "PineappleTown"
		else
			MMon = "Fishman Warrior"
			MPos = CFrame.new(60943.9023, 17.9492188, 1744.11133, 0.826706648, 0, -0.562633216, 0, 1, 0, 0.562633216, 0, 0.826706648)
			SP = "Underwater City"
			MMon = "Fishman Commando"
			MPos = CFrame.new(61760.8984, 18.0800781, 1460.11133, -0.632549644, 0, -0.774520278, 0, 1, 0, 0.774520278, 0, -0.632549644)
			SP = "Underwater City"
		end
	elseif _G.SelectMaterial ~= "Angel Wings" then
		if _G.SelectMaterial ~= "Mystic Droplet" then
			if _G.SelectMaterial ~= "Vampire Fang" then
				if _G.SelectMaterial ~= "Gunpowder" then
					if _G.SelectMaterial == "Mini Tusk" then
						MMon = "Mythological Pirate"
						MPos = CFrame.new(-13456.0498, 469.433228, -7039.96436, 0, 0, 1, 0, 1, 0, -1, 0, 0)
						SP = "BigMansion"
					else
						if _G.SelectMaterial ~= "Conjured Cocoa" then
							return
						end

						MMon = "Chocolate Bar Battler"
						MPos = CFrame.new(582.828674, 25.5824986, -12550.7041, -0.766061664, 0, -0.642767608, 0, 1, 0, 0.642767608, 0, -0.766061664)
						SP = "Chocolate"
					end
				else
					MMon = "Pistol Billionaire"
					MPos = CFrame.new(-185.693283, 84.7088699, 6103.62744, 0.90629667, 0, -0.422642082, 0, 1, 0, 0.422642082, 0, 0.90629667)
					SP = "Mansion"
				end
			else
				MMon = "Vampire"
				MPos = CFrame.new(-6132.39453, 9.00769424, -1466.16919, -0.927179813, 0, -0.374617696, 0, 1, 0, 0.374617696, 0, -0.927179813)
				SP = "Graveyard"
			end
		else
			MMon = "Water Fighter"
			MPos = CFrame.new(-3331.70459, 239.138336, -10553.3564, -0.29242146, 0, 0.95628953, 0, 1, 0, -0.95628953, 0, -0.29242146)
			SP = "ForgottenIsland"
		end
	else
		MMon = "Royal Soldier"
		MPos = CFrame.new(-7759.45898, 5606.93652, -1862.70276, -0.866007447, 0, -0.500031412, 0, 1, 0, 0.500031412, 0, -0.866007447)
		SP = "SkyArea2"
	end
end
function CheckQuest()
	MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value

	if World1 then
		if (MyLevel < 1 or MyLevel > 9) and SelectMonster ~= "Bandit" then
			if (MyLevel < 10 or MyLevel > 14) and SelectMonster ~= "Monkey" then
				if (MyLevel < 15 or MyLevel > 29) and SelectMonster ~= "Gorilla" then
					if (MyLevel < 30 or MyLevel > 39) and SelectMonster ~= "Pirate" then
						if (MyLevel < 40 or MyLevel > 59) and SelectMonster ~= "Brute" then
							if (MyLevel < 60 or MyLevel > 74) and SelectMonster ~= "Desert Bandit" then
								if (MyLevel < 75 or MyLevel > 89) and SelectMonster ~= "Desert Officer" then
									if (MyLevel < 90 or MyLevel > 99) and SelectMonster ~= "Snow Bandit" then
										if (MyLevel < 100 or MyLevel > 119) and SelectMonster ~= "Snowman" then
											if (MyLevel < 120 or MyLevel > 149) and SelectMonster ~= "Chief Petty Officer" then
												if (MyLevel < 150 or MyLevel > 174) and SelectMonster ~= "Sky Bandit" then
													if (MyLevel < 175 or MyLevel > 189) and SelectMonster ~= "Dark Master" then
														if (MyLevel < 190 or MyLevel > 209) and SelectMonster ~= "Prisoner" then
															if (MyLevel < 210 or MyLevel > 249) and SelectMonster ~= "Dangerous Prisone" then
																if (MyLevel < 250 or MyLevel > 274) and SelectMonster ~= "Toga Warrior" then
																	if (MyLevel < 275 or MyLevel > 299) and SelectMonster ~= "Gladiator" then
																		if (MyLevel < 300 or MyLevel > 324) and SelectMonster ~= "Military Soldier" then
																			if (MyLevel < 325 or MyLevel > 374) and SelectMonster ~= "Military Spy" then
																				if (MyLevel < 375 or MyLevel > 399) and SelectMonster ~= "Fishman Warrior" then
																					if (MyLevel < 400 or MyLevel > 449) and SelectMonster ~= "Fishman Commando" then
																						if (MyLevel < 450 or MyLevel > 474) and SelectMonster ~= "God\'s Guard" then
																							if (MyLevel < 475 or MyLevel > 524) and SelectMonster ~= "Shanda" then
																								if (MyLevel < 525 or MyLevel > 549) and SelectMonster ~= "Royal Squad" then
																									if (MyLevel < 550 or MyLevel > 624) and SelectMonster ~= "Royal Soldier" then
																										if (MyLevel < 625 or MyLevel > 649) and SelectMonster ~= "Galley Pirate" then
																											if not (MyLevel >= 650 or SelectMonster == "Galley Captain") then
																												return
																											end

																											Mon = "Galley Captain"
																											LevelQuest = 2
																											NameQuest = "FountainQuest"
																											NameMon = "Galley Captain"
																											CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, 0.087131381)
																											CFrameMon = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)
																										else
																											Mon = "Galley Pirate"
																											LevelQuest = 1
																											NameQuest = "FountainQuest"
																											NameMon = "Galley Pirate"
																											CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, 0.087131381)
																											CFrameMon = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)
																										end
																									else
																										Mon = "Royal Soldier"
																										LevelQuest = 2
																										NameQuest = "SkyExp2Quest"
																										NameMon = "Royal Soldier"
																										CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																										CFrameMon = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)
																									end
																								else
																									Mon = "Royal Squad"
																									LevelQuest = 1
																									NameQuest = "SkyExp2Quest"
																									NameMon = "Royal Squad"
																									CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																									CFrameMon = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)
																								end
																							else
																								Mon = "Shanda"
																								LevelQuest = 2
																								NameQuest = "SkyExp1Quest"
																								NameMon = "Shanda"
																								CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, -0, 0.906319618, -0, 1, -0, -0.906319618, -0, -0.422592998)
																								CFrameMon = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)

																								if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																									return
																								end

																								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
																							end
																						else
																							Mon = "God\'s Guard"
																							LevelQuest = 1
																							NameQuest = "SkyExp1Quest"
																							NameMon = "God\'s Guard"
																							CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, -0, 1, -0, 0.0871884301, -0, 0.996191859)
																							CFrameMon = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)

																							if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																								return
																							end

																							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
																						end
																					else
																						Mon = "Fishman Commando"
																						LevelQuest = 2
																						NameQuest = "FishmanQuest"
																						NameMon = "Fishman Commando"
																						CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
																						CFrameMon = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)

																						if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																							return
																						end

																						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
																					end
																				else
																					Mon = "Fishman Warrior"
																					LevelQuest = 1
																					NameQuest = "FishmanQuest"
																					NameMon = "Fishman Warrior"
																					CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
																					CFrameMon = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)

																					if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																						return
																					end

																					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
																				end
																			else
																				Mon = "Military Spy"
																				LevelQuest = 2
																				NameQuest = "MagmaQuest"
																				NameMon = "Military Spy"
																				CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, -0.499959469)
																				CFrameMon = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)
																			end
																		else
																			Mon = "Military Soldier"
																			LevelQuest = 1
																			NameQuest = "MagmaQuest"
																			NameMon = "Military Soldier"
																			CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, -0.499959469)
																			CFrameMon = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875)
																		end
																	else
																		Mon = "Gladiator"
																		LevelQuest = 2
																		NameQuest = "ColosseumQuest"
																		NameMon = "Gladiator"
																		CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, -0, -0.857167721, -0, 1, -0, 0.857167721, -0, -0.515037298)
																		CFrameMon = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)
																	end
																else
																	Mon = "Toga Warrior"
																	LevelQuest = 1
																	NameQuest = "ColosseumQuest"
																	NameMon = "Toga Warrior"
																	CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, -0, -0.857167721, -0, 1, -0, 0.857167721, -0, -0.515037298)
																	CFrameMon = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)
																end
															else
																Mon = "Dangerous Prisoner"
																LevelQuest = 2
																NameQuest = "PrisonerQuest"
																NameMon = "Dangerous Prisoner"
																CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-9, -0.995993316, 1.60817859e-9, 1, -5.16744869e-9, 0.995993316, -2.06384709e-9, -0.0894274712)
																CFrameMon = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)
															end
														else
															Mon = "Prisoner"
															LevelQuest = 1
															NameQuest = "PrisonerQuest"
															NameMon = "Prisoner"
															CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-9, -0.995993316, 1.60817859e-9, 1, -5.16744869e-9, 0.995993316, -2.06384709e-9, -0.0894274712)
															CFrameMon = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)
														end
													else
														Mon = "Dark Master"
														LevelQuest = 2
														NameQuest = "SkyQuest"
														NameMon = "Dark Master"
														CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
														CFrameMon = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)
													end
												else
													Mon = "Sky Bandit"
													LevelQuest = 1
													NameQuest = "SkyQuest"
													NameMon = "Sky Bandit"
													CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
													CFrameMon = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)
												end
											else
												Mon = "Chief Petty Officer"
												LevelQuest = 1
												NameQuest = "MarineQuest2"
												NameMon = "Chief Petty Officer"
												CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, -0, -0, -1, -0, 1, -0, 1, -0, -0)
												CFrameMon = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)
											end
										else
											Mon = "Snowman"
											LevelQuest = 2
											NameQuest = "SnowQuest"
											NameMon = "Snowman"
											CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, -0, 0.939684391, -0, 1, -0, -0.939684391, -0, -0.342042685)
											CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
										end
									else
										Mon = "Snow Bandit"
										LevelQuest = 1
										NameQuest = "SnowQuest"
										NameMon = "Snow Bandit"
										CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, -0, 0.939684391, -0, 1, -0, -0.939684391, -0, -0.342042685)
										CFrameMon = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)
									end
								else
									Mon = "Desert Officer"
									LevelQuest = 2
									NameQuest = "DesertQuest"
									NameMon = "Desert Officer"
									CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, -0, 1, -0, 0.573571265, -0, 0.819155693)
									CFrameMon = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
								end
							else
								Mon = "Desert Bandit"
								LevelQuest = 1
								NameQuest = "DesertQuest"
								NameMon = "Desert Bandit"
								CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, -0, 1, -0, 0.573571265, -0, 0.819155693)
								CFrameMon = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
							end
						else
							Mon = "Brute"
							LevelQuest = 2
							NameQuest = "BuggyQuest1"
							NameMon = "Brute"
							CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, -0, 1, -0, 0.258804798, -0, 0.965929627)
							CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
						end
					else
						Mon = "Pirate"
						LevelQuest = 1
						NameQuest = "BuggyQuest1"
						NameMon = "Pirate"
						CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, -0, 1, -0, 0.258804798, -0, 0.965929627)
						CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
					end
				else
					Mon = "Gorilla"
					LevelQuest = 2
					NameQuest = "JungleQuest"
					NameMon = "Gorilla"
					CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, -0, -0, 1, -0, 1, -0, -1, -0, -0)
					CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
				end
			else
				Mon = "Monkey"
				LevelQuest = 1
				NameQuest = "JungleQuest"
				NameMon = "Monkey"
				CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, -0, -0, 1, -0, 1, -0, -1, -0, -0)
				CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
			end
		else
			Mon = "Bandit"
			LevelQuest = 1
			NameQuest = "BanditQuest1"
			NameMon = "Bandit"
			CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, -0, 1, -0, 0.341998369, -0, 0.939700544)
			CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
		end
	elseif World2 then
		if (MyLevel < 700 or MyLevel > 724) and SelectMonster ~= "Raider" then
			if (MyLevel < 725 or MyLevel > 774) and SelectMonster ~= "Mercenary" then
				if (MyLevel < 775 or MyLevel > 799) and SelectMonster ~= "Swan Pirate" then
					if (MyLevel < 800 or MyLevel > 874) and SelectMonster ~= "Factory Staff" then
						if (MyLevel < 875 or MyLevel > 899) and SelectMonster ~= "Marine Lieutenant" then
							if (MyLevel < 900 or MyLevel > 949) and SelectMonster ~= "Marine Captain" then
								if (MyLevel < 950 or MyLevel > 974) and SelectMonster ~= "Zombie" then
									if (MyLevel < 975 or MyLevel > 999) and SelectMonster ~= "Vampire" then
										if (MyLevel < 1000 or MyLevel > 1049) and SelectMonster ~= "Snow Trooper" then
											if (MyLevel < 1050 or MyLevel > 1099) and SelectMonster ~= "Winter Warrior" then
												if (MyLevel < 1100 or MyLevel > 1124) and SelectMonster ~= "Lab Subordinate" then
													if (MyLevel < 1125 or MyLevel > 1174) and SelectMonster ~= "Horned Warrior" then
														if (MyLevel < 1175 or MyLevel > 1199) and SelectMonster ~= "Magma Ninja" then
															if (MyLevel < 1200 or MyLevel > 1249) and SelectMonster ~= "Lava Pirate" then
																if (MyLevel < 1250 or MyLevel > 1274) and SelectMonster ~= "Ship Deckhand" then
																	if (MyLevel < 1275 or MyLevel > 1299) and SelectMonster ~= "Ship Engineer" then
																		if (MyLevel < 1300 or MyLevel > 1324) and SelectMonster ~= "Ship Steward" then
																			if (MyLevel < 1325 or MyLevel > 1349) and SelectMonster ~= "Ship Officer" then
																				if (MyLevel < 1350 or MyLevel > 1374) and SelectMonster ~= "Arctic Warrior" then
																					if (MyLevel < 1375 or MyLevel > 1424) and SelectMonster ~= "Snow Lurker" then
																						if (MyLevel < 1425 or MyLevel > 1449) and SelectMonster ~= "Sea Soldier" then
																							if not (MyLevel >= 1450 or SelectMonster == "Water Fighter") then
																								return
																							end

																							Mon = "Water Fighter"
																							LevelQuest = 2
																							NameQuest = "ForgottenQuest"
																							NameMon = "Water Fighter"
																							CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, -0, 1, -0, 0.13915664, -0, 0.990270376)
																							CFrameMon = CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875)
																						else
																							Mon = "Sea Soldier"
																							LevelQuest = 1
																							NameQuest = "ForgottenQuest"
																							NameMon = "Sea Soldier"
																							CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, -0, 1, -0, 0.13915664, -0, 0.990270376)
																							CFrameMon = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)
																						end
																					else
																						Mon = "Snow Lurker"
																						LevelQuest = 2
																						NameQuest = "FrostQuest"
																						NameMon = "Snow Lurker"
																						CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, -0, -0.358349502, -0, 1, -0, 0.358349502, -0, -0.933587909)
																						CFrameMon = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)
																					end
																				else
																					Mon = "Arctic Warrior"
																					LevelQuest = 1
																					NameQuest = "FrostQuest"
																					NameMon = "Arctic Warrior"
																					CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, -0, -0.358349502, -0, 1, -0, 0.358349502, -0, -0.933587909)
																					CFrameMon = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)

																					if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																						return
																					end

																					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-6508.5581054688, 5000.034996032715, -132.83953857422))
																				end
																			else
																				Mon = "Ship Officer"
																				LevelQuest = 2
																				NameQuest = "ShipQuest2"
																				NameMon = "Ship Officer"
																				CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
																				CFrameMon = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)

																				if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																					return
																				end

																				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
																			end
																		else
																			Mon = "Ship Steward"
																			LevelQuest = 1
																			NameQuest = "ShipQuest2"
																			NameMon = "Ship Steward"
																			CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
																			CFrameMon = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)

																			if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																				return
																			end

																			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
																		end
																	else
																		Mon = "Ship Engineer"
																		LevelQuest = 2
																		NameQuest = "ShipQuest1"
																		NameMon = "Ship Engineer"
																		CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
																		CFrameMon = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)

																		if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																			return
																		end

																		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
																	end
																else
																	Mon = "Ship Deckhand"
																	LevelQuest = 1
																	NameQuest = "ShipQuest1"
																	NameMon = "Ship Deckhand"
																	CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
																	CFrameMon = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)

																	if not (_G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000) then
																		return
																	end

																	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
																end
															else
																Mon = "Lava Pirate"
																LevelQuest = 2
																NameQuest = "FireSideQuest"
																NameMon = "Lava Pirate"
																CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
																CFrameMon = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
															end
														else
															Mon = "Magma Ninja"
															LevelQuest = 1
															NameQuest = "FireSideQuest"
															NameMon = "Magma Ninja"
															CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
															CFrameMon = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)
														end
													else
														Mon = "Horned Warrior"
														LevelQuest = 2
														NameQuest = "IceSideQuest"
														NameMon = "Horned Warrior"
														CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, -0, 1, -0, 0.891015649, -0, 0.453972578)
														CFrameMon = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)
													end
												else
													Mon = "Lab Subordinate"
													LevelQuest = 1
													NameQuest = "IceSideQuest"
													NameMon = "Lab Subordinate"
													CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, -0, 1, -0, 0.891015649, -0, 0.453972578)
													CFrameMon = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)
												end
											else
												Mon = "Winter Warrior"
												LevelQuest = 2
												NameQuest = "SnowMountainQuest"
												NameMon = "Winter Warrior"
												CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, -0, 0.92718488, -0, 1, -0, -0.92718488, -0, -0.374604106)
												CFrameMon = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)
											end
										else
											Mon = "Snow Trooper"
											LevelQuest = 1
											NameQuest = "SnowMountainQuest"
											NameMon = "Snow Trooper"
											CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, -0, 0.92718488, -0, 1, -0, -0.92718488, -0, -0.374604106)
											CFrameMon = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)
										end
									else
										Mon = "Vampire"
										LevelQuest = 2
										NameQuest = "ZombieQuest"
										NameMon = "Vampire"
										CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, -0, -0.95628953, -0, 1, -0, 0.95628953, -0, -0.29242146)
										CFrameMon = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
									end
								else
									Mon = "Zombie"
									LevelQuest = 1
									NameQuest = "ZombieQuest"
									NameMon = "Zombie"
									CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, -0, -0.95628953, -0, 1, -0, 0.95628953, -0, -0.29242146)
									CFrameMon = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)
								end
							else
								Mon = "Marine Captain"
								LevelQuest = 2
								NameQuest = "MarineQuest3"
								NameMon = "Marine Captain"
								CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
								CFrameMon = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)
							end
						else
							Mon = "Marine Lieutenant"
							LevelQuest = 1
							NameQuest = "MarineQuest3"
							NameMon = "Marine Lieutenant"
							CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, -0, 0.500031412, -0, 1, -0, -0.500031412, -0, 0.866007268)
							CFrameMon = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)
						end
					else
						Mon = "Factory Staff"
						NameQuest = "Area2Quest"
						LevelQuest = 2
						NameMon = "Factory Staff"
						CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
						CFrameMon = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)
					end
				else
					Mon = "Swan Pirate"
					LevelQuest = 1
					NameQuest = "Area2Quest"
					NameMon = "Swan Pirate"
					CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, -0, 0.99026376, -0, 1, -0, -0.99026376, -0, 0.139203906)
					CFrameMon = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)
				end
			else
				Mon = "Mercenary"
				LevelQuest = 2
				NameQuest = "Area1Quest"
				NameMon = "Mercenary"
				CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, -0, -0.974368095, -0, 1, -0, 0.974368095, -0, -0.22495985)
				CFrameMon = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
			end
		else
			Mon = "Raider"
			LevelQuest = 1
			NameQuest = "Area1Quest"
			NameMon = "Raider"
			CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, -0, -0.974368095, -0, 1, -0, 0.974368095, -0, -0.22495985)
			CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
		end
	else
		if not World3 then
			return
		end

		if (MyLevel < 1500 or MyLevel > 1524) and SelectMonster ~= "Pirate Millionaire" then
			if (MyLevel < 1525 or MyLevel > 1574) and SelectMonster ~= "Pistol Billionaire" then
				if (MyLevel < 1575 or MyLevel > 1599) and SelectMonster ~= "Dragon Crew Warrior" then
					if (MyLevel < 1600 or MyLevel > 1624) and SelectMonster ~= "Dragon Crew Archer" then
						if (MyLevel < 1625 or MyLevel > 1649) and SelectMonster ~= "Hydra Enforcer" then
							if (MyLevel < 1650 or MyLevel > 1699) and SelectMonster ~= "Venomous Assailant" then
								if (MyLevel < 1700 or MyLevel > 1724) and SelectMonster ~= "Marine Commodore" then
									if (MyLevel < 1725 or MyLevel > 1774) and SelectMonster ~= "Marine Rear Admiral" then
										if (MyLevel < 1775 or MyLevel > 1799) and SelectMonster ~= "Fishman Raider" then
											if (MyLevel < 1800 or MyLevel > 1824) and SelectMonster ~= "Fishman Captain" then
												if (MyLevel < 1825 or MyLevel > 1849) and SelectMonster ~= "Forest Pirate" then
													if (MyLevel < 1850 or MyLevel > 1899) and SelectMonster ~= "Mythological Pirate" then
														if (MyLevel < 1900 or MyLevel > 1924) and SelectMonster ~= "Jungle Pirate" then
															if (MyLevel < 1925 or MyLevel > 1974) and SelectMonster ~= "Musketeer Pirate" then
																if (MyLevel < 1975 or MyLevel > 1999) and SelectMonster ~= "Reborn Skeleton" then
																	if (MyLevel < 2000 or MyLevel > 2024) and SelectMonster ~= "Living Zombie" then
																		if (MyLevel < 2025 or MyLevel > 2049) and SelectMonster ~= "Demonic Soul" then
																			if (MyLevel < 2050 or MyLevel > 2074) and SelectMonster ~= "Posessed Mummy" then
																				if (MyLevel < 2075 or MyLevel > 2099) and SelectMonster ~= "Peanut Scout" then
																					if (MyLevel < 2100 or MyLevel > 2124) and SelectMonster ~= "Peanut President" then
																						if (MyLevel < 2125 or MyLevel > 2149) and SelectMonster ~= "Ice Cream Chef" then
																							if (MyLevel < 2150 or MyLevel > 2199) and SelectMonster ~= "Ice Cream Commander" then
																								if (MyLevel < 2200 or MyLevel > 2224) and SelectMonster ~= "Cookie Crafter" then
																									if (MyLevel < 2225 or MyLevel > 2249) and SelectMonster ~= "Cake Guard" then
																										if (MyLevel < 2250 or MyLevel > 2274) and SelectMonster ~= "Baking Staff" then
																											if (MyLevel < 2275 or MyLevel > 2299) and SelectMonster ~= "Head Baker" then
																												if (MyLevel < 2300 or MyLevel > 2324) and SelectMonster ~= "Cocoa Warrior" then
																													if (MyLevel < 2325 or MyLevel > 2349) and SelectMonster ~= "Chocolate Bar Battler" then
																														if (MyLevel < 2350 or MyLevel > 2374) and SelectMonster ~= "Sweet Thief" then
																															if (MyLevel < 2375 or MyLevel > 2399) and SelectMonster ~= "Candy Rebel" then
																																if (MyLevel < 2400 or MyLevel > 2424) and SelectMonster ~= "Candy Pirate" then
																																	if (MyLevel < 2425 or MyLevel > 2449) and SelectMonster ~= "Snow Demon" then
																																		if (MyLevel < 2450 or MyLevel > 2474) and SelectMonster ~= "Isle Outlaw" then
																																			if (MyLevel < 2475 or MyLevel > 2524) and SelectMonster ~= "Island Boy" then
																																				if (MyLevel < 2525 or MyLevel > 2550) and SelectMonster ~= "Isle Champion" then
																																					if (MyLevel < 2550 or MyLevel > 2574) and SelectMonster ~= "Serpent Hunter" then
																																						if not (MyLevel >= 2575 or SelectMonster == "Skull Slayer") then
																																							return
																																						end

																																						Mon = "Skull Slayer"
																																						LevelQuest = 2
																																						NameQuest = "TikiQuest3"
																																						NameMon = "Skull Slayer"
																																						CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, -0, 1, -0, 0.308980465, -0, 0.951068401)
																																						CFrameMon = CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, -0, -0.0348687991, -0, 1, -0, 0.0348687991, -0, -0.999392271)
																																					else
																																						Mon = "Serpent Hunter"
																																						LevelQuest = 1
																																						NameQuest = "TikiQuest3"
																																						NameMon = "Serpent Hunter"
																																						CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, -0, 1, -0, 0.308980465, -0, 0.951068401)
																																						CFrameMon = CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, -0, 0.882950008, -0, 1, -0, -0.882950008, -0, 0.469467044)
																																					end
																																				else
																																					Mon = "Isle Champion"
																																					LevelQuest = 2
																																					NameQuest = "TikiQuest2"
																																					NameMon = "Isle Champion"
																																					CFrameQuest = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
																																					CFrameMon = CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375)
																																				end
																																			else
																																				Mon = "Island Boy"
																																				LevelQuest = 2
																																				NameQuest = "TikiQuest1"
																																				NameMon = "Island Boy"
																																				CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
																																				CFrameMon = CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562)
																																			end
																																		else
																																			Mon = "Isle Outlaw"
																																			LevelQuest = 1
																																			NameQuest = "TikiQuest1"
																																			NameMon = "Isle Outlaw"
																																			CFrameQuest = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
																																			CFrameMon = CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656)
																																		end
																																	else
																																		Mon = "Snow Demon"
																																		LevelQuest = 2
																																		NameQuest = "CandyQuest1"
																																		NameMon = "Snow Demon"
																																		CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
																																		CFrameMon = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)
																																	end
																																else
																																	Mon = "Candy Pirate"
																																	LevelQuest = 1
																																	NameQuest = "CandyQuest1"
																																	NameMon = "Candy Pirate"
																																	CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
																																	CFrameMon = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
																																end
																															else
																																Mon = "Candy Rebel"
																																LevelQuest = 2
																																NameQuest = "ChocQuest2"
																																NameMon = "Candy Rebel"
																																CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
																																CFrameMon = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
																															end
																														else
																															Mon = "Sweet Thief"
																															LevelQuest = 1
																															NameQuest = "ChocQuest2"
																															NameMon = "Sweet Thief"
																															CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
																															CFrameMon = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
																														end
																													else
																														Mon = "Chocolate Bar Battler"
																														LevelQuest = 2
																														NameQuest = "ChocQuest1"
																														NameMon = "Chocolate Bar Battler"
																														CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
																														CFrameMon = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
																													end
																												else
																													Mon = "Cocoa Warrior"
																													LevelQuest = 1
																													NameQuest = "ChocQuest1"
																													NameMon = "Cocoa Warrior"
																													CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
																													CFrameMon = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
																												end
																											else
																												Mon = "Head Baker"
																												LevelQuest = 2
																												NameQuest = "CakeQuest2"
																												NameMon = "Head Baker"
																												CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-8, 0.250778586, 4.74911062e-8, 1, 1.49904711e-8, -0.250778586, 2.64211941e-8, -0.96804446)
																												CFrameMon = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
																											end
																										else
																											Mon = "Baking Staff"
																											LevelQuest = 1
																											NameQuest = "CakeQuest2"
																											NameMon = "Baking Staff"
																											CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-8, 0.250778586, 4.74911062e-8, 1, 1.49904711e-8, -0.250778586, 2.64211941e-8, -0.96804446)
																											CFrameMon = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
																										end
																									else
																										Mon = "Cake Guard"
																										LevelQuest = 2
																										NameQuest = "CakeQuest1"
																										NameMon = "Cake Guard"
																										CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-8, 0.288177818, 6.9301187e-8, 1, 7.51931211e-8, -0.288177818, -5.2032135e-8, 0.957576931)
																										CFrameMon = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
																									end
																								else
																									Mon = "Cookie Crafter"
																									LevelQuest = 1
																									NameQuest = "CakeQuest1"
																									NameMon = "Cookie Crafter"
																									CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-8, 0.288177818, 6.9301187e-8, 1, 7.51931211e-8, -0.288177818, -5.2032135e-8, 0.957576931)
																									CFrameMon = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
																								end
																							else
																								Mon = "Ice Cream Commander"
																								LevelQuest = 2
																								NameQuest = "IceCreamIslandQuest"
																								NameMon = "Ice Cream Commander"
																								CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																								CFrameMon = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
																							end
																						else
																							Mon = "Ice Cream Chef"
																							LevelQuest = 1
																							NameQuest = "IceCreamIslandQuest"
																							NameMon = "Ice Cream Chef"
																							CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																							CFrameMon = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
																						end
																					else
																						Mon = "Peanut President"
																						LevelQuest = 2
																						NameQuest = "NutsIslandQuest"
																						NameMon = "Peanut President"
																						CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																						CFrameMon = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
																					end
																				else
																					Mon = "Peanut Scout"
																					LevelQuest = 1
																					NameQuest = "NutsIslandQuest"
																					NameMon = "Peanut Scout"
																					CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																					CFrameMon = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
																				end
																			else
																				Mon = "Posessed Mummy"
																				LevelQuest = 2
																				NameQuest = "HauntedQuest2"
																				NameMon = "Posessed Mummy"
																				CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																				CFrameMon = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
																			end
																		else
																			Mon = "Demonic Soul"
																			LevelQuest = 1
																			NameQuest = "HauntedQuest2"
																			NameMon = "Demonic Soul"
																			CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, -0, -0, -1, -0, 1, -0, 1, -0, -0)
																			CFrameMon = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
																		end
																	else
																		Mon = "Living Zombie"
																		LevelQuest = 2
																		NameQuest = "HauntedQuest1"
																		NameMon = "Living Zombie"
																		CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, -0, -0, 1, -0, 1, -0, -1, -0, -0)
																		CFrameMon = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
																	end
																else
																	Mon = "Reborn Skeleton"
																	LevelQuest = 1
																	NameQuest = "HauntedQuest1"
																	NameMon = "Reborn Skeleton"
																	CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, -0, -0, 1, -0, 1, -0, -1, -0, -0)
																	CFrameMon = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
																end
															else
																Mon = "Musketeer Pirate"
																LevelQuest = 2
																NameQuest = "DeepForestIsland2"
																NameMon = "Musketeer Pirate"
																CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, -0.0871315002)
																CFrameMon = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
															end
														else
															Mon = "Jungle Pirate"
															LevelQuest = 1
															NameQuest = "DeepForestIsland2"
															NameMon = "Jungle Pirate"
															CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, -0, 0.996196866, -0, 1, -0, -0.996196866, -0, -0.0871315002)
															CFrameMon = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
														end
													else
														Mon = "Mythological Pirate"
														LevelQuest = 2
														NameQuest = "DeepForestIsland"
														NameMon = "Mythological Pirate"
														CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, -0, 1, -0, 0.707079291, -0, 0.707134247)
														CFrameMon = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
													end
												else
													Mon = "Forest Pirate"
													LevelQuest = 1
													NameQuest = "DeepForestIsland"
													NameMon = "Forest Pirate"
													CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, -0, 1, -0, 0.707079291, -0, 0.707134247)
													CFrameMon = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
												end
											else
												Mon = "Fishman Captain"
												LevelQuest = 2
												NameQuest = "DeepForestIsland3"
												NameMon = "Fishman Captain"
												CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
												CFrameMon = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)
											end
										else
											Mon = "Fishman Raider"
											LevelQuest = 1
											NameQuest = "DeepForestIsland3"
											NameMon = "Fishman Raider"
											CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, -0, 0.469463557, -0, 1, -0, -0.469463557, -0, -0.882952213)
											CFrameMon = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
										end
									else
										Mon = "Marine Rear Admiral"
										LevelQuest = 2
										NameQuest = "MarineTreeIsland"
										NameMon = "Marine Rear Admiral"
										CFrameQuest = CFrame.new(2481.09228515625, 74.27049255371094, -6779.640625)
										CFrameMon = CFrame.new(3761.81006, 123.912003, -6823.52197, 0.961273968, -0, 0.275594592, -0, 1, -0, -0.275594592, -0, 0.961273968)
									end
								else
									Mon = "Marine Commodore"
									LevelQuest = 1
									NameQuest = "MarineTreeIsland"
									NameMon = "Marine Commodore"
									CFrameQuest = CFrame.new(2481.09228515625, 74.27049255371094, -6779.640625)
									CFrameMon = CFrame.new(2577.25391, 75.6100006, -7739.87207, 0.499959469, -0, 0.866048813, -0, 1, -0, -0.866048813, -0, 0.499959469)
								end
							else
								Mon = "Venomous Assailant"
								NameQuest = "VenomCrewQuest"
								LevelQuest = 2
								NameMon = "Venomous Assailant"
								CFrameQuest = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
								CFrameMon = CFrame.new(4674.92676, 1134.82654, 996.308838, 0.731321394, -0, -0.682033002, -0, 1, -0, 0.682033002, -0, 0.731321394)
							end
						else
							Mon = "Hydra Enforcer"
							NameQuest = "VenomCrewQuest"
							LevelQuest = 1
							NameMon = "Hydra Enforcer"
							CFrameQuest = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
							CFrameMon = CFrame.new(4547.11523, 1003.10217, 334.194824, 0.388810456, -0, -0.921317935, -0, 1, -0, 0.921317935, -0, 0.388810456)
						end
					else
						Mon = "Dragon Crew Archer"
						NameQuest = "DragonCrewQuest"
						LevelQuest = 2
						NameMon = "Dragon Crew Archer"
						CFrameQuest = CFrame.new(6750.4931640625, 127.44916534423828, -711.0308837890625)
						CFrameMon = CFrame.new(6668.76172, 481.376923, 329.12207, -0.121787429, -0, -0.992556155, -0, 1, -0, 0.992556155, -0, -0.121787429)
					end
				else
					Mon = "Dragon Crew Warrior"
					LevelQuest = 1
					NameQuest = "DragonCrewQuest"
					NameMon = "Dragon Crew Warrior"
					CFrameQuest = CFrame.new(6750.4931640625, 127.44916534423828, -711.0308837890625)
					CFrameMon = CFrame.new(6709.76367, 52.3442993, -1139.02966, -0.763515472, -0, 0.645789504, -0, 1, -0, -0.645789504, -0, -0.763515472)
				end
			else
				Mon = "Pistol Billionaire"
				LevelQuest = 2
				NameQuest = "PiratePortQuest"
				NameMon = "Pistol Billionaire"
				CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.957107544, -0, -0.289732844, -0, 1, -0, 0.289732844, -0, 0.957107544)
				CFrameMon = CFrame.new(-54.8110352, 83.7698746, 5947.84082, -0.965929747, -0, 0.258804798, -0, 1, -0, -0.258804798, -0, -0.965929747)
			end
		else
			Mon = "Pirate Millionaire"
			LevelQuest = 1
			NameQuest = "PiratePortQuest"
			NameMon = "Pirate Millionaire"
			CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.957107544, -0, -0.289732844, -0, 1, -0, 0.289732844, -0, 0.957107544)
			CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
		end
	end
end
function Hop()
	local PlaceId = game.PlaceId
	local t1 = {}
	local s1 = ""
	local hour = os.date("!*t").hour

	function TPReturner()
		local data

		if s1 == "" then
			data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
		else
			data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. s1))
		end

		if data.nextPageCursor and (data.nextPageCursor ~= "null" and data.nextPageCursor ~= "null") then
			s1 = data.nextPageCursor
		end

		local n1 = 0

		for _, v in pairs(data.data) do
			local v9 = true
			local v10 = tostring(v.id)

			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				for _, v2 in pairs(t1) do
					if n1 == 0 then
						if tonumber(hour) ~= tonumber(v2) then
							pcall(function()
								t1 = {}
								table.insert(t1, hour)
							end)
						end
					elseif v10 == tostring(v2) then
						v9 = false
					end

					n1 = n1 + 1
				end

				if v9 == true then
					table.insert(t1, v10)
					wait(0.1)
					pcall(function()
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, v10, game.Players.LocalPlayer)
					end)
					wait(0.1)
				end
			end
		end
	end
	function Teleport()
		while wait(0.1) do
			pcall(function()
				TPReturner()

				if s1 == "" then
					return
				end

				TPReturner()
			end)
		end
	end

	Teleport()
end
function CheckItem(p1)
	for _, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
		if v.Name == p1 then
			return v
		end
	end
end
function UpdateIslandESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v17 = child

		pcall(function()
			if IslandESP then
				if v17.Name == "Sea" then
					return
				end

				if v17:FindFirstChild("NameEsp") then
					v17.NameEsp.TextLabel.Text = v17.Name .. "   \n" .. round((game:GetService("Players").LocalPlayer.Character.Head.Position - v17.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v17)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v17
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "GothamSemibold"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			else
				if not v17:FindFirstChild("NameEsp") then
					return
				end

				v17:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function isnil(p2)
	local _ = p2 == nil

	return true
end

local function v21(p3)
	return math.floor(tonumber(p3) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
	for _, child in pairs(game:GetService("Players"):GetChildren()) do
		local v24 = child

		pcall(function()
			if isnil(v24.Character) then
				return
			end

			if ESPPlayer then
				if isnil(v24.Character.Head) or v24.Character.Head:FindFirstChild("NameEsp" .. Number) then
					v24.Character.Head["NameEsp" .. Number].TextLabel.Text = v24.Name .. " | " .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v24.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v21(v24.Character.Humanoid.Health * 100 / v24.Character.Humanoid.MaxHealth) .. "%"
				else
					local BillboardGui = Instance.new("BillboardGui", v24.Character.Head)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v24.Character.Head
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Text = v24.Name .. " \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v24.Character.Head.Position).Magnitude / 3) .. " Distance"
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5

					if v24.Team ~= game.Players.LocalPlayer.Team then
						TextLabel.TextColor3 = Color3.new(255, 0, 0)
					else
						TextLabel.TextColor3 = Color3.new(0, 255, 0)
					end
				end
			else
				if not v24.Character.Head:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v24.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateChestESP()
	for _, v in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
		local v29 = v

		pcall(function()
			if _G.ChestESP then
				if v29:GetAttribute("IsDisabled") then
					return
				end

				if v29:FindFirstChild("ChestEsp") then
					local v30 = v29
					local v31 = v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v30:GetPivot().Position).Magnitude / 3)

					v29.ChestEsp.TextLabel.Text = "Chest\n" .. v31 .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v29)

					BillboardGui.Name = "ChestEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v29
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
				end
			else
				if not v29:FindFirstChild("ChestEsp") then
					return
				end

				v29:FindFirstChild("ChestEsp"):Destroy()
			end
		end)
	end
end

v21 = function(p4)
	return math.floor(p4 + 0.5)
end

function UpdateDevilChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v36 = child

		pcall(function()
			if DevilFruitESP then
				if not string.find(v36.Name, "Fruit") then
					return
				end

				if v36.Handle:FindFirstChild("NameEsp" .. Number) then
					v36.Handle["NameEsp" .. Number].TextLabel.Text = v36.Name .. "   \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v36.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v36.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v36.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = v36.Name .. " \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v36.Handle.Position).Magnitude / 3) .. " Distance"
				end
			else
				if not v36.Handle:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v36.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateFlowerChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v41 = child

		pcall(function()
			if not (v41.Name == "Flower2" or v41.Name == "Flower1") then
				return
			end

			if FlowerESP then
				if v41:FindFirstChild("NameEsp" .. Number) then
					v41["NameEsp" .. Number].TextLabel.Text = v41.Name .. "   \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v41.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v41)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v41
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

					if v41.Name == "Flower1" then
						TextLabel.Text = "Blue Flower" .. " \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v41.Position).Magnitude / 3) .. " Distance"
						TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
					end

					if v41.Name ~= "Flower2" then
						return
					end

					TextLabel.Text = "Red Flower" .. " \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v41.Position).Magnitude / 3) .. " Distance"
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				end
			else
				if not v41:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v41:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateRealFruitChams()
	for _, child in pairs(game.Workspace.AppleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					TextLabel.Text = child.Name .. " \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 174, 0)
					TextLabel.Text = child.Name .. " \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.BananaSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(251, 255, 0)
					TextLabel.Text = child.Name .. " \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end
end
function UpdateIslandESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v58 = child

		pcall(function()
			if IslandESP then
				if v58.Name == "Sea" then
					return
				end

				if v58:FindFirstChild("NameEsp") then
					v58.NameEsp.TextLabel.Text = v58.Name .. "   \n" .. v21((game:GetService("Players").LocalPlayer.Character.Head.Position - v58.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v58)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v58
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "GothamSemibold"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(8, 247, 255)
				end
			else
				if not v58:FindFirstChild("NameEsp") then
					return
				end

				v58:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function isnil(p5)
	local _ = p5 == nil

	return true
end

local function v62(p6)
	return math.floor(tonumber(p6) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
	for _, child in pairs(game:GetService("Players"):GetChildren()) do
		local v65 = child

		pcall(function()
			if isnil(v65.Character) then
				return
			end

			if ESPPlayer then
				if isnil(v65.Character.Head) or v65.Character.Head:FindFirstChild("NameEsp" .. Number) then
					v65.Character.Head["NameEsp" .. Number].TextLabel.Text = v65.Name .. " | " .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v65.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v62(v65.Character.Humanoid.Health * 100 / v65.Character.Humanoid.MaxHealth) .. "%"
				else
					local BillboardGui = Instance.new("BillboardGui", v65.Character.Head)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v65.Character.Head
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Text = v65.Name .. " \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v65.Character.Head.Position).Magnitude / 3) .. " Distance"
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5

					if v65.Team ~= game.Players.LocalPlayer.Team then
						TextLabel.TextColor3 = Color3.new(255, 0, 0)
					else
						TextLabel.TextColor3 = Color3.new(0, 255, 0)
					end
				end
			else
				if not v65.Character.Head:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v65.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateChestESP()
	for _, v in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
		local v70 = v

		pcall(function()
			if _G.ChestESP then
				if v70:GetAttribute("IsDisabled") then
					return
				end

				if v70:FindFirstChild("ChestEsp") then
					local v71 = v70
					local v72 = v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v71:GetPivot().Position).Magnitude / 3)

					v70.ChestEsp.TextLabel.Text = "Chest\n" .. v72 .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v70)

					BillboardGui.Name = "ChestEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v70
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
				end
			else
				if not v70:FindFirstChild("ChestEsp") then
					return
				end

				v70:FindFirstChild("ChestEsp"):Destroy()
			end
		end)
	end
end

v62 = function(p7)
	return math.floor(p7 + 0.5)
end

function UpdateDevilChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v77 = child

		pcall(function()
			if DevilFruitESP then
				if not string.find(v77.Name, "Fruit") then
					return
				end

				if v77.Handle:FindFirstChild("NameEsp" .. Number) then
					v77.Handle["NameEsp" .. Number].TextLabel.Text = v77.Name .. "   \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v77.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v77.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v77.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = v77.Name .. " \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v77.Handle.Position).Magnitude / 3) .. " Distance"
				end
			else
				if not v77.Handle:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v77.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateFlowerChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v82 = child

		pcall(function()
			if not (v82.Name == "Flower2" or v82.Name == "Flower1") then
				return
			end

			if FlowerESP then
				if v82:FindFirstChild("NameEsp" .. Number) then
					v82["NameEsp" .. Number].TextLabel.Text = v82.Name .. "   \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v82.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v82)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v82
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

					if v82.Name == "Flower1" then
						TextLabel.Text = "Blue Flower" .. " \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v82.Position).Magnitude / 3) .. " Distance"
						TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
					end

					if v82.Name ~= "Flower2" then
						return
					end

					TextLabel.Text = "Red Flower" .. " \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v82.Position).Magnitude / 3) .. " Distance"
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				end
			else
				if not v82:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v82:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateRealFruitChams()
	for _, child in pairs(game.Workspace.AppleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					TextLabel.Text = child.Name .. " \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 174, 0)
					TextLabel.Text = child.Name .. " \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.BananaSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(251, 255, 0)
					TextLabel.Text = child.Name .. " \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end
end
function UpdateIslandESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v99 = child

		pcall(function()
			if IslandESP then
				if v99.Name == "Sea" then
					return
				end

				if v99:FindFirstChild("NameEsp") then
					v99.NameEsp.TextLabel.Text = v99.Name .. "   \n" .. v62((game:GetService("Players").LocalPlayer.Character.Head.Position - v99.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v99)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v99
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "GothamSemibold"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(8, 247, 255)
				end
			else
				if not v99:FindFirstChild("NameEsp") then
					return
				end

				v99:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function isnil(p8)
	local _ = p8 == nil

	return true
end

local function v103(p9)
	return math.floor(tonumber(p9) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
	for _, child in pairs(game:GetService("Players"):GetChildren()) do
		local v106 = child

		pcall(function()
			if isnil(v106.Character) then
				return
			end

			if ESPPlayer then
				if isnil(v106.Character.Head) or v106.Character.Head:FindFirstChild("NameEsp" .. Number) then
					v106.Character.Head["NameEsp" .. Number].TextLabel.Text = v106.Name .. " | " .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v106.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v103(v106.Character.Humanoid.Health * 100 / v106.Character.Humanoid.MaxHealth) .. "%"
				else
					local BillboardGui = Instance.new("BillboardGui", v106.Character.Head)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v106.Character.Head
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Text = v106.Name .. " \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v106.Character.Head.Position).Magnitude / 3) .. " Distance"
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5

					if v106.Team == game.Players.LocalPlayer.Team then
						TextLabel.TextColor3 = Color3.new(0, 255, 0)
					else
						TextLabel.TextColor3 = Color3.new(255, 0, 0)
					end
				end
			else
				if not v106.Character.Head:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v106.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateChestESP()
	for _, v in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
		local v111 = v

		pcall(function()
			if _G.ChestESP then
				if v111:GetAttribute("IsDisabled") then
					return
				end

				if v111:FindFirstChild("ChestEsp") then
					local v112 = v111
					local v113 = v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v112:GetPivot().Position).Magnitude / 3)

					v111.ChestEsp.TextLabel.Text = "Chest\n" .. v113 .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v111)

					BillboardGui.Name = "ChestEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v111
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
				end
			else
				if not v111:FindFirstChild("ChestEsp") then
					return
				end

				v111:FindFirstChild("ChestEsp"):Destroy()
			end
		end)
	end
end

v103 = function(p10)
	return math.floor(p10 + 0.5)
end

function UpdateDevilChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v118 = child

		pcall(function()
			if DevilFruitESP then
				if not string.find(v118.Name, "Fruit") then
					return
				end

				if v118.Handle:FindFirstChild("NameEsp" .. Number) then
					v118.Handle["NameEsp" .. Number].TextLabel.Text = v118.Name .. "   \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v118.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v118.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v118.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = v118.Name .. " \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v118.Handle.Position).Magnitude / 3) .. " Distance"
				end
			else
				if not v118.Handle:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v118.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateFlowerChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v123 = child

		pcall(function()
			if not (v123.Name == "Flower2" or v123.Name == "Flower1") then
				return
			end

			if FlowerESP then
				if v123:FindFirstChild("NameEsp" .. Number) then
					v123["NameEsp" .. Number].TextLabel.Text = v123.Name .. "   \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v123.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v123)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v123
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

					if v123.Name == "Flower1" then
						TextLabel.Text = "Blue Flower" .. " \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v123.Position).Magnitude / 3) .. " Distance"
						TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
					end

					if v123.Name ~= "Flower2" then
						return
					end

					TextLabel.Text = "Red Flower" .. " \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v123.Position).Magnitude / 3) .. " Distance"
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				end
			else
				if not v123:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v123:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateRealFruitChams()
	for _, child in pairs(game.Workspace.AppleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					TextLabel.Text = child.Name .. " \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 174, 0)
					TextLabel.Text = child.Name .. " \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.BananaSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(251, 255, 0)
					TextLabel.Text = child.Name .. " \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end
end
function UpdateIslandESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v140 = child

		pcall(function()
			if IslandESP then
				if v140.Name == "Sea" then
					return
				end

				if v140:FindFirstChild("NameEsp") then
					v140.NameEsp.TextLabel.Text = v140.Name .. "   \n" .. v103((game:GetService("Players").LocalPlayer.Character.Head.Position - v140.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v140)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v140
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "GothamSemibold"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			else
				if not v140:FindFirstChild("NameEsp") then
					return
				end

				v140:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function isnil(p11)
	local _ = p11 == nil

	return true
end

local function v144(p12)
	return math.floor(tonumber(p12) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
	for _, child in pairs(game:GetService("Players"):GetChildren()) do
		local v147 = child

		pcall(function()
			if isnil(v147.Character) then
				return
			end

			if ESPPlayer then
				if isnil(v147.Character.Head) or v147.Character.Head:FindFirstChild("NameEsp" .. Number) then
					v147.Character.Head["NameEsp" .. Number].TextLabel.Text = v147.Name .. " | " .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v147.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v144(v147.Character.Humanoid.Health * 100 / v147.Character.Humanoid.MaxHealth) .. "%"
				else
					local BillboardGui = Instance.new("BillboardGui", v147.Character.Head)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v147.Character.Head
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Text = v147.Name .. " \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v147.Character.Head.Position).Magnitude / 3) .. " Distance"
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5

					if v147.Team ~= game.Players.LocalPlayer.Team then
						TextLabel.TextColor3 = Color3.new(255, 0, 0)
					else
						TextLabel.TextColor3 = Color3.new(0, 255, 0)
					end
				end
			else
				if not v147.Character.Head:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v147.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateChestESP()
	for _, v in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
		local v152 = v

		pcall(function()
			if _G.ChestESP then
				if v152:GetAttribute("IsDisabled") then
					return
				end

				if v152:FindFirstChild("ChestEsp") then
					local v153 = v152
					local v154 = v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v153:GetPivot().Position).Magnitude / 3)

					v152.ChestEsp.TextLabel.Text = "Chest\n" .. v154 .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v152)

					BillboardGui.Name = "ChestEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v152
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
				end
			else
				if not v152:FindFirstChild("ChestEsp") then
					return
				end

				v152:FindFirstChild("ChestEsp"):Destroy()
			end
		end)
	end
end

v144 = function(p13)
	return math.floor(p13 + 0.5)
end

function UpdateDevilChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v159 = child

		pcall(function()
			if DevilFruitESP then
				if not string.find(v159.Name, "Fruit") then
					return
				end

				if v159.Handle:FindFirstChild("NameEsp" .. Number) then
					v159.Handle["NameEsp" .. Number].TextLabel.Text = v159.Name .. "   \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v159.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v159.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v159.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = v159.Name .. " \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v159.Handle.Position).Magnitude / 3) .. " Distance"
				end
			else
				if not v159.Handle:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v159.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateFlowerChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v164 = child

		pcall(function()
			if not (v164.Name == "Flower2" or v164.Name == "Flower1") then
				return
			end

			if FlowerESP then
				if v164:FindFirstChild("NameEsp" .. Number) then
					v164["NameEsp" .. Number].TextLabel.Text = v164.Name .. "   \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v164.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v164)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v164
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

					if v164.Name == "Flower1" then
						TextLabel.Text = "Blue Flower" .. " \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v164.Position).Magnitude / 3) .. " Distance"
						TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
					end

					if v164.Name ~= "Flower2" then
						return
					end

					TextLabel.Text = "Red Flower" .. " \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v164.Position).Magnitude / 3) .. " Distance"
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				end
			else
				if not v164:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v164:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateRealFruitChams()
	for _, child in pairs(game.Workspace.AppleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					TextLabel.Text = child.Name .. " \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 174, 0)
					TextLabel.Text = child.Name .. " \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.BananaSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(251, 255, 0)
					TextLabel.Text = child.Name .. " \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end
end
function UpdateIslandESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v181 = child

		pcall(function()
			if IslandESP then
				if v181.Name == "Sea" then
					return
				end

				if v181:FindFirstChild("NameEsp") then
					v181.NameEsp.TextLabel.Text = v181.Name .. "   \n" .. v144((game:GetService("Players").LocalPlayer.Character.Head.Position - v181.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v181)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v181
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "GothamSemibold"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(8, 247, 255)
				end
			else
				if not v181:FindFirstChild("NameEsp") then
					return
				end

				v181:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function isnil(p14)
	local _ = p14 == nil

	return true
end

local function v185(p15)
	return math.floor(tonumber(p15) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
	for _, child in pairs(game:GetService("Players"):GetChildren()) do
		local v188 = child

		pcall(function()
			if isnil(v188.Character) then
				return
			end

			if ESPPlayer then
				if isnil(v188.Character.Head) or v188.Character.Head:FindFirstChild("NameEsp" .. Number) then
					v188.Character.Head["NameEsp" .. Number].TextLabel.Text = v188.Name .. " | " .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v188.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v185(v188.Character.Humanoid.Health * 100 / v188.Character.Humanoid.MaxHealth) .. "%"
				else
					local BillboardGui = Instance.new("BillboardGui", v188.Character.Head)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v188.Character.Head
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Text = v188.Name .. " \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v188.Character.Head.Position).Magnitude / 3) .. " Distance"
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5

					if v188.Team == game.Players.LocalPlayer.Team then
						TextLabel.TextColor3 = Color3.new(0, 255, 0)
					else
						TextLabel.TextColor3 = Color3.new(255, 0, 0)
					end
				end
			else
				if not v188.Character.Head:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v188.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateChestESP()
	for _, v in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
		local v193 = v

		pcall(function()
			if _G.ChestESP then
				if v193:GetAttribute("IsDisabled") then
					return
				end

				if v193:FindFirstChild("ChestEsp") then
					local v194 = v193
					local v195 = v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v194:GetPivot().Position).Magnitude / 3)

					v193.ChestEsp.TextLabel.Text = "Chest\n" .. v195 .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v193)

					BillboardGui.Name = "ChestEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v193
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
				end
			else
				if not v193:FindFirstChild("ChestEsp") then
					return
				end

				v193:FindFirstChild("ChestEsp"):Destroy()
			end
		end)
	end
end

v185 = function(p16)
	return math.floor(p16 + 0.5)
end

function UpdateDevilChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v200 = child

		pcall(function()
			if DevilFruitESP then
				if not string.find(v200.Name, "Fruit") then
					return
				end

				if v200.Handle:FindFirstChild("NameEsp" .. Number) then
					v200.Handle["NameEsp" .. Number].TextLabel.Text = v200.Name .. "   \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v200.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v200.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v200.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = v200.Name .. " \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v200.Handle.Position).Magnitude / 3) .. " Distance"
				end
			else
				if not v200.Handle:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v200.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateFlowerChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v205 = child

		pcall(function()
			if not (v205.Name == "Flower2" or v205.Name == "Flower1") then
				return
			end

			if FlowerESP then
				if v205:FindFirstChild("NameEsp" .. Number) then
					v205["NameEsp" .. Number].TextLabel.Text = v205.Name .. "   \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v205.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v205)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v205
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

					if v205.Name == "Flower1" then
						TextLabel.Text = "Blue Flower" .. " \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v205.Position).Magnitude / 3) .. " Distance"
						TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
					end

					if v205.Name ~= "Flower2" then
						return
					end

					TextLabel.Text = "Red Flower" .. " \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v205.Position).Magnitude / 3) .. " Distance"
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				end
			else
				if not v205:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v205:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateRealFruitChams()
	for _, child in pairs(game.Workspace.AppleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					TextLabel.Text = child.Name .. " \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 174, 0)
					TextLabel.Text = child.Name .. " \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.BananaSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(251, 255, 0)
					TextLabel.Text = child.Name .. " \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end
end
function UpdateIslandESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v222 = child

		pcall(function()
			if IslandESP then
				if v222.Name == "Sea" then
					return
				end

				if v222:FindFirstChild("NameEsp") then
					v222.NameEsp.TextLabel.Text = v222.Name .. "   \n" .. v185((game:GetService("Players").LocalPlayer.Character.Head.Position - v222.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v222)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v222
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "GothamSemibold"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(8, 247, 255)
				end
			else
				if not v222:FindFirstChild("NameEsp") then
					return
				end

				v222:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function isnil(p17)
	local _ = p17 == nil

	return true
end

local function v226(p18)
	return math.floor(tonumber(p18) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
	for _, child in pairs(game:GetService("Players"):GetChildren()) do
		local v229 = child

		pcall(function()
			if isnil(v229.Character) then
				return
			end

			if ESPPlayer then
				if isnil(v229.Character.Head) or v229.Character.Head:FindFirstChild("NameEsp" .. Number) then
					v229.Character.Head["NameEsp" .. Number].TextLabel.Text = v229.Name .. " | " .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v229.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. v226(v229.Character.Humanoid.Health * 100 / v229.Character.Humanoid.MaxHealth) .. "%"
				else
					local BillboardGui = Instance.new("BillboardGui", v229.Character.Head)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v229.Character.Head
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Text = v229.Name .. " \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v229.Character.Head.Position).Magnitude / 3) .. " Distance"
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5

					if v229.Team == game.Players.LocalPlayer.Team then
						TextLabel.TextColor3 = Color3.new(0, 255, 0)
					else
						TextLabel.TextColor3 = Color3.new(255, 0, 0)
					end
				end
			else
				if not v229.Character.Head:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v229.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateChestESP()
	for _, v in pairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
		local v234 = v

		pcall(function()
			if _G.ChestESP then
				if v234:GetAttribute("IsDisabled") then
					return
				end

				if v234:FindFirstChild("ChestEsp") then
					local v235 = v234
					local v236 = v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v235:GetPivot().Position).Magnitude / 3)

					v234.ChestEsp.TextLabel.Text = "Chest\n" .. v236 .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v234)

					BillboardGui.Name = "ChestEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v234
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
				end
			else
				if not v234:FindFirstChild("ChestEsp") then
					return
				end

				v234:FindFirstChild("ChestEsp"):Destroy()
			end
		end)
	end
end

v226 = function(p19)
	return math.floor(p19 + 0.5)
end

function UpdateDevilChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v241 = child

		pcall(function()
			if DevilFruitESP then
				if not string.find(v241.Name, "Fruit") then
					return
				end

				if v241.Handle:FindFirstChild("NameEsp" .. Number) then
					v241.Handle["NameEsp" .. Number].TextLabel.Text = v241.Name .. "   \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v241.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v241.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v241.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.Text = v241.Name .. " \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v241.Handle.Position).Magnitude / 3) .. " Distance"
				end
			else
				if not v241.Handle:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v241.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateFlowerChams()
	for _, child in pairs(game.Workspace:GetChildren()) do
		local v246 = child

		pcall(function()
			if not (v246.Name == "Flower2" or v246.Name == "Flower1") then
				return
			end

			if FlowerESP then
				if v246:FindFirstChild("NameEsp" .. Number) then
					v246["NameEsp" .. Number].TextLabel.Text = v246.Name .. "   \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v246.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", v246)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v246
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

					if v246.Name == "Flower1" then
						TextLabel.Text = "Blue Flower" .. " \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v246.Position).Magnitude / 3) .. " Distance"
						TextLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
					end

					if v246.Name ~= "Flower2" then
						return
					end

					TextLabel.Text = "Red Flower" .. " \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - v246.Position).Magnitude / 3) .. " Distance"
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				end
			else
				if not v246:FindFirstChild("NameEsp" .. Number) then
					return
				end

				v246:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end)
	end
end
function UpdateRealFruitChams()
	for _, child in pairs(game.Workspace.AppleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					TextLabel.Text = child.Name .. " \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(255, 174, 0)
					TextLabel.Text = child.Name .. " \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end

	for _, child in pairs(game.Workspace.BananaSpawner:GetChildren()) do
		if child:IsA("Tool") then
			if RealFruitESP then
				if child.Handle:FindFirstChild("NameEsp" .. Number) then
					child.Handle["NameEsp" .. Number].TextLabel.Text = child.Name .. " " .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				else
					local BillboardGui = Instance.new("BillboardGui", child.Handle)

					BillboardGui.Name = "NameEsp" .. Number
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = child.Handle
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = Enum.Font.GothamSemibold
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(251, 255, 0)
					TextLabel.Text = child.Name .. " \n" .. v226((game:GetService("Players").LocalPlayer.Character.Head.Position - child.Handle.Position).Magnitude / 3) .. " Distance"
				end
			elseif child.Handle:FindFirstChild("NameEsp" .. Number) then
				child.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
			end
		end
	end
end

spawn(function()
	while wait() do
		pcall(function()
			if MobESP then
				for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if child:FindFirstChild("HumanoidRootPart") then
						if not child:FindFirstChild("MobEap") then
							local BillboardGui = Instance.new("BillboardGui")
							local TextLabel = Instance.new("TextLabel")

							BillboardGui.Parent = child
							BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
							BillboardGui.Active = true
							BillboardGui.Name = "MobEap"
							BillboardGui.AlwaysOnTop = true
							BillboardGui.LightInfluence = 1
							BillboardGui.Size = UDim2.new(0, 200, 0, 50)
							BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
							TextLabel.Parent = BillboardGui
							TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							TextLabel.BackgroundTransparency = 1
							TextLabel.Size = UDim2.new(0, 200, 0, 50)
							TextLabel.Font = Enum.Font.GothamBold
							TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
							TextLabel.Text.Size = 35
						end

						local v265 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude)

						child.MobEap.TextLabel.Text = child.Name .. " - " .. v265 .. " Distance"
					end
				end
			else
				for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if child:FindFirstChild("MobEap") then
						child.MobEap:Destroy()
					end
				end
			end
		end)
	end
end)
spawn(function()
	while wait() do
		pcall(function()
			if SeaESP then
				for _, child in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
					if child:FindFirstChild("HumanoidRootPart") then
						if not child:FindFirstChild("Seaesps") then
							local BillboardGui = Instance.new("BillboardGui")
							local TextLabel = Instance.new("TextLabel")

							BillboardGui.Parent = child
							BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
							BillboardGui.Active = true
							BillboardGui.Name = "Seaesps"
							BillboardGui.AlwaysOnTop = true
							BillboardGui.LightInfluence = 1
							BillboardGui.Size = UDim2.new(0, 200, 0, 50)
							BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
							TextLabel.Parent = BillboardGui
							TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							TextLabel.BackgroundTransparency = 1
							TextLabel.Size = UDim2.new(0, 200, 0, 50)
							TextLabel.Font = Enum.Font.GothamBold
							TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
							TextLabel.Text.Size = 35
						end

						local v272 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude)

						child.Seaesps.TextLabel.Text = child.Name .. " - " .. v272 .. " Distance"
					end
				end
			else
				for _, child in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
					if child:FindFirstChild("Seaesps") then
						child.Seaesps:Destroy()
					end
				end
			end
		end)
	end
end)
spawn(function()
	while wait() do
		pcall(function()
			if NpcESP then
				for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
					if child:FindFirstChild("HumanoidRootPart") then
						if not child:FindFirstChild("NpcEspes") then
							local BillboardGui = Instance.new("BillboardGui")
							local TextLabel = Instance.new("TextLabel")

							BillboardGui.Parent = child
							BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
							BillboardGui.Active = true
							BillboardGui.Name = "NpcEspes"
							BillboardGui.AlwaysOnTop = true
							BillboardGui.LightInfluence = 1
							BillboardGui.Size = UDim2.new(0, 200, 0, 50)
							BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
							TextLabel.Parent = BillboardGui
							TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							TextLabel.BackgroundTransparency = 1
							TextLabel.Size = UDim2.new(0, 200, 0, 50)
							TextLabel.Font = Enum.Font.GothamBold
							TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
							TextLabel.Text.Size = 35
						end

						local v279 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude)

						child.NpcEspes.TextLabel.Text = child.Name .. " - " .. v279 .. " Distance"
					end
				end
			else
				for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
					if child:FindFirstChild("NpcEspes") then
						child.NpcEspes:Destroy()
					end
				end
			end
		end)
	end
end)

function isnil(p20)
	local _ = p20 == nil

	return true
end

local function v283(p21)
	return math.floor(tonumber(p21) + 0.5)
end

Number = math.random(1, 1000000)

function UpdateIslandMirageESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v286 = child

		pcall(function()
			if MirageIslandESP then
				if v286.Name ~= "Mirage Island" then
					return
				end

				if v286:FindFirstChild("NameEsp") then
					v286.NameEsp.TextLabel.Text = v286.Name .. "   \n" .. v283((game:GetService("Players").LocalPlayer.Character.Head.Position - v286.Position).Magnitude / 3) .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v286)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v286
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
				end
			else
				if not v286:FindFirstChild("NameEsp") then
					return
				end

				v286:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function UpdatePrehistoricIslandESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v291 = child

		pcall(function()
			if PrehistoricIslandESP then
				if v291.Name ~= "PrehistoricIsland" then
					return
				end

				if v291:FindFirstChild("NameEsp") then
					v291.NameEsp.TextLabel.Text = v291.Name .. "   \n" .. v283((game:GetService("Players").LocalPlayer.Character.Head.Position - v291.Position).Magnitude / 3) .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v291)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v291
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
				end
			else
				if not v291:FindFirstChild("NameEsp") then
					return
				end

				v291:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function UpdateAfdESP()
	for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
		local v296 = child

		pcall(function()
			if AfdESP then
				if v296.Name ~= "Advanced Fruit Dealer" then
					return
				end

				if v296:FindFirstChild("NameEsp") then
					v296.NameEsp.TextLabel.Text = v296.Name .. "   \n" .. v283((game:GetService("Players").LocalPlayer.Character.Head.Position - v296.Position).Magnitude / 3) .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v296)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v296
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
				end
			else
				if not v296:FindFirstChild("NameEsp") then
					return
				end

				v296:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function UpdateAuraESP()
	for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
		local v301 = child

		pcall(function()
			if AuraESP then
				if v301.Name ~= "Master of Enhancement" then
					return
				end

				if v301:FindFirstChild("NameEsp") then
					v301.NameEsp.TextLabel.Text = v301.Name .. "   \n" .. v283((game:GetService("Players").LocalPlayer.Character.Head.Position - v301.Position).Magnitude / 3) .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v301)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v301
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
				end
			else
				if not v301:FindFirstChild("NameEsp") then
					return
				end

				v301:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function UpdateLSDESP()
	for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
		local v306 = child

		pcall(function()
			if LADESP then
				if v306.Name ~= "Legendary Sword Dealer" then
					return
				end

				if v306:FindFirstChild("NameEsp") then
					v306.NameEsp.TextLabel.Text = v306.Name .. "   \n" .. v283((game:GetService("Players").LocalPlayer.Character.Head.Position - v306.Position).Magnitude / 3) .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v306)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v306
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
				end
			else
				if not v306:FindFirstChild("NameEsp") then
					return
				end

				v306:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end

spawn(function()
	while wait() do
		if InfAbility then
			InfAb()
		end
	end
end)

function InfAb()
	if InfAbility then
		if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
			return
		end

		local ParticleEmitter = Instance.new("ParticleEmitter")

		ParticleEmitter.Acceleration = Vector3.new(0, 0, 0)
		ParticleEmitter.Archivable = true
		ParticleEmitter.Drag = 20
		ParticleEmitter.EmissionDirection = Enum.NormalId.Top
		ParticleEmitter.Enabled = true
		ParticleEmitter.Lifetime = NumberRange.new(0, 0)
		ParticleEmitter.LightInfluence = 0
		ParticleEmitter.LockedToPart = true
		ParticleEmitter.Name = "Agility"
		ParticleEmitter.Rate = 500

		local t2 = { NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 4) }

		ParticleEmitter.Size = NumberSequence.new(t2)
		ParticleEmitter.RotSpeed = NumberRange.new(9999, 99999)
		ParticleEmitter.Rotation = NumberRange.new(0, 0)
		ParticleEmitter.Speed = NumberRange.new(30, 30)
		ParticleEmitter.SpreadAngle = Vector2.new(0, 0, 0, 0)
		ParticleEmitter.Texture = ""
		ParticleEmitter.VelocityInheritance = 0
		ParticleEmitter.ZOffset = 2
		ParticleEmitter.Transparency = NumberSequence.new(0)
		ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
		ParticleEmitter.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
	else
		if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
			return
		end

		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
	end
end
function UpdateGeaESP()
	for _, child in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do
		local v313 = child

		pcall(function()
			if GearESP then
				if v313.Name ~= "MeshPart" then
					return
				end

				if v313:FindFirstChild("NameEsp") then
					v313.NameEsp.TextLabel.Text = v313.Name .. "   \n" .. v283((game:GetService("Players").LocalPlayer.Character.Head.Position - v313.Position).Magnitude / 3) .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v313)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v313
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
				end
			else
				if not v313:FindFirstChild("NameEsp") then
					return
				end

				v313:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function UpdateBerriesESP()
	local tagged = game:GetService("CollectionService"):GetTagged("BerryBush")

	for _, v in pairs(tagged) do
		local v319 = v

		pcall(function()
			local v320 = v319

			for _, v2 in pairs(v320:GetAttributes()) do
				if v2 then
					if not v319.Parent:FindFirstChild("BerryESP") then
						local BillboardGui = Instance.new("BillboardGui", v319.Parent)

						BillboardGui.Name = "BerryESP"
						BillboardGui.ExtentsOffset = Vector3.new(0, 2, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = v319.Parent
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.GothamSemibold
						TextLabel.TextSize = 14
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = Enum.TextYAlignment.Top
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
						TextLabel.Text = v2
					end

					if v319.Parent:FindFirstChild("BerryESP") then
						local LocalPlayer = game.Players.LocalPlayer

						if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
							local Position = LocalPlayer.Character.Head.Position
							local Magnitude = (v319.Parent:GetPivot().Position - Position).Magnitude

							v319.Parent.BerryESP.TextLabel.Text = v2 .. "\n" .. math.floor(Magnitude) .. "m"
						end
					end
				elseif v319.Parent:FindFirstChild("NameEsp") then
					v319.Parent:FindFirstChild("NameEsp"):Destroy()
				end
			end
		end)
	end
end
function UpdateIslandKisuneESP()
	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
		local v330 = child

		pcall(function()
			if KitsuneIslandEsp then
				if v330.Name ~= "Kitsune Island" then
					return
				end

				if v330:FindFirstChild("NameEsp") then
					v330.NameEsp.TextLabel.Text = v330.Name .. "   \n" .. v283((game:GetService("Players").LocalPlayer.Character.Head.Position - v330.Position).Magnitude / 3) .. " M"
				else
					local BillboardGui = Instance.new("BillboardGui", v330)

					BillboardGui.Name = "NameEsp"
					BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
					BillboardGui.Size = UDim2.new(1, 200, 1, 30)
					BillboardGui.Adornee = v330
					BillboardGui.AlwaysOnTop = true

					local TextLabel = Instance.new("TextLabel", BillboardGui)

					TextLabel.Font = "Code"
					TextLabel.FontSize = "Size14"
					TextLabel.TextWrapped = true
					TextLabel.Size = UDim2.new(1, 0, 1, 0)
					TextLabel.TextYAlignment = "Top"
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextStrokeTransparency = 0.5
					TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
				end
			else
				if not v330:FindFirstChild("NameEsp") then
					return
				end

				v330:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
function AutoHaki()
	local Character = game:GetService("Players").LocalPlayer.Character
	local CommF_ = Character and not Character:FindFirstChild("HasBuso") and game:GetService("ReplicatedStorage").Remotes.CommF_

	if not CommF_ then
		return
	end

	CommF_:InvokeServer("Buso")
end
function UnEquipWeapon(p22)
	if not game.Players.LocalPlayer.Character:FindFirstChild(p22) then
		return
	end

	_G.NotAutoEquip = true
	wait(0.5)
	game.Players.LocalPlayer.Character:FindFirstChild(p22).Parent = game.Players.LocalPlayer.Backpack
	wait(0.1)
	_G.NotAutoEquip = false
end
function EquipWeapon(p23)
	if _G.NotAutoEquip or not game.Players.LocalPlayer.Backpack:FindFirstChild(p23) then
		return
	end

	Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(p23)
	wait(0.1)
	game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
end

spawn(function()
	local v335 = getrawmetatable(game)
	local __namecall = v335.__namecall

	setreadonly(v335, false)
	v335.__namecall = newcclosure(function(...)
		local v337 = getnamecallmethod()
		local t3 = { ... }

		if tostring(v337) ~= "FireServer" or (tostring(t3[1]) ~= "RemoteEvent" or (tostring(t3[2]) == "true" or (tostring(t3[2]) == "false" or not _G.UseSkill))) then
			return __namecall(...)
		else
			if type(t3[2]) == "vector" then
				t3[2] = PositionSkillMasteryDevilFruit
			else
				t3[2] = CFrame.new(PositionSkillMasteryDevilFruit)
			end

			return __namecall(unpack(t3))
		end
	end)
end)
spawn(function()
	pcall(function()
		while task.wait() do
			for _, child in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
				if child:IsA("Tool") and child:FindFirstChild("RemoteFunctionShoot") then
					CurrentEquipGun = child.Name
				end
			end
		end
	end)
end)

function StopTween(p24)
	local Character = game:GetService("Players").LocalPlayer.Character

	if not p24 then
		_G.StopTween = true
		wait(0.2)
		topos(Character.HumanoidRootPart.CFrame)
		wait(0.2)

		if Character.HumanoidRootPart:FindFirstChild("BodyClip") then
			Character.HumanoidRootPart.BodyClip:Destroy()
		end

		if Character:FindFirstChild("Block") then
			Character.Block:Destroy()
		end

		_G.StopTween = false
		_G.Clip = false
	end

	if not Character:FindFirstChild("Highlight") then
		return
	end

	Character.Highlight:Destroy()
end
function LockTween()
	if _G.LockTween then
		return
	end

	_G.LockTween = true
	wait()

	local Character = game.Players.LocalPlayer.Character
	local HumanoidRootPart = Character and Character:IsDescendantOf(game.Workspace) and Character:WaitForChild("HumanoidRootPart")

	if HumanoidRootPart then
		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame
	end

	wait()

	if Character:FindFirstChild("BodyClip") then
		Character.BodyClip:Destroy()
	end

	if not Character:FindFirstChild("PartTele") then
		_G.LockTween = false

		return
	end

	Character.Block:Destroy()
	_G.LockTween = false
end
function BringMob(p25)
	for _, child in pairs(WS.Enemies:GetChildren()) do
		if child.Name == p25 and (child.Parent and (child:FindFirstChild("HumanoidRootPart") and (child:FindFirstChild("Humanoid") and (child.Humanoid.Health > 0 and (child.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 350)))) then
			child.HumanoidRootPart.CFrame = BringPos
			child.Humanoid.JumpPower = 0
			child.Humanoid.WalkSpeed = 0
			child.HumanoidRootPart.Transparency = 1
			child.HumanoidRootPart.CanCollide = false
			child.Head.CanCollide = false

			if child.Humanoid:FindFirstChild("Animator") then
				child.Humanoid.Animator:Destroy()
			end

			if not child.HumanoidRootPart:FindFirstChild("Lock") then
				local BodyVelocity = Instance.new("BodyVelocity")

				BodyVelocity.Parent = child.HumanoidRootPart
				BodyVelocity.Name = "Lock"
				BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
				BodyVelocity.Velocity = Vector3.new(0, 0, 0)
			end

			sethiddenproperty(plr, "SimulationRadius", math.huge)
			child.Humanoid:ChangeState(11)
		end
	end
end
function CancelTween23()
	if plr.Character.Head:FindFirstChild("BodyVelocity") then
		plr.Character.Head:FindFirstChild("BodyVelocity"):Destroy()
	end

	if not plr.Character:FindFirstChild("PartTele") then
		NoClip = false

		return Tween23(plr.Character.HumanoidRootPart.CFrame)
	end

	plr.Character:FindFirstChild("PartTele"):Destroy()
	NoClip = false

	return Tween23(plr.Character.HumanoidRootPart.CFrame)
end
function KillMob(p26, p27)
	pcall(function()
		thismob = DetectMob2(p26)

		if not (thismob:FindFirstChild("HumanoidRootPart") and thismob.Parent and (thismob:FindFirstChild("Humanoid") and thismob.Humanoid.Health > 0)) then
			return
		end

		repeat
			task.wait()
			Buso()
			EquipWeapon()
			Tween23(thismob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
			BringPos = thismob.HumanoidRootPart.CFrame
			BringMob(p26)
			NoClip = true
		until not thismob.Parent or (not thismob:FindFirstChild("Humanoid") or (thismob:FindFirstChild("Humanoid").Health <= 0 or (not thismob:FindFirstChild("HumanoidRootPart") or p27())))

		NoClip = false
		CancelTween23()
	end)
end

spawn(function()
	while wait() do
		pcall(function()
			if NoClip == true then
				if not plr.Character.Head:FindFirstChild("Nigga") then
					local BodyVelocity = Instance.new("BodyVelocity", plr.Character.Head)

					BodyVelocity.P = 1500
					BodyVelocity.Name = "Nigga"
					BodyVelocity.MaxForce = Vector3.new(0, 100000, 0)
					BodyVelocity.Velocity = Vector3.new(0, 0, 0)
				end

				for _, descendant in pairs(plr.Character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = false
					end
				end
			else
				if not plr.Character.Head:FindFirstChild("Nigga") then
					return
				end

				plr.Character.Head:FindFirstChild("Nigga"):Destroy()
			end
		end)
	end
end)
spawn(function()
	while task.wait() do
		pcall(function()
			local Character = game:GetService("Players").LocalPlayer.Character
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not ((Character.Humanoid.Health <= 0 or not HumanoidRootPart) and Character:FindFirstChild("Block")) then
				return
			end

			Character.Block:Destroy()
		end)
	end
end)
spawn(function()
	while task.wait() do
		pcall(function()
			local Character = game:GetService("Players").LocalPlayer.Character
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not (Character:FindFirstChild("Block") and (HumanoidRootPart.Position - Character.Block.Position).Magnitude >= 100) then
				return
			end

			Character.Block:Destroy()
		end)
	end
end)

function enableNoclip()
	if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
		return
	end

	local BodyVelocity = Instance.new("BodyVelocity")

	BodyVelocity.Name = "BodyClip"
	BodyVelocity.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
	BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
	BodyVelocity.Velocity = Vector3.new(0, 0, 0)
end
function disableNoclip()
	local BodyClip = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip")

	if not BodyClip then
		return
	end

	BodyClip:Destroy()
end
function disableCollisions()
	for _, descendant in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
		end
	end
end

local _ = pcall(function()
	return getgenv().Module
end)

spawn(function()
	pcall(function()
		while task.wait(0.2) do
			if getgenv().Module or (_G.DefendVolcano or getgenv().AutoFarm) then
				enableNoclip()
				disableCollisions()
			else
				disableNoclip()
			end
		end
	end)
end)

function EquipAllWeapon()
	pcall(function()
		for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if child:IsA("Tool") and (child.Name ~= "Summon Sea Beast" and (child.Name ~= "Water Body" and child.Name ~= "Awakening")) then
				local ChildName = game.Players.LocalPlayer.Backpack:FindFirstChild(child.Name)

				game.Players.LocalPlayer.Character.Humanoid:EquipTool(ChildName)
				wait(1)
			end
		end
	end)
end

local u363 = false

function WaitHRP(p28)
	if not p28 then
		return
	end

	local _ = p28.Character.WaitForChild
end
function CheckNearestTeleporter(p29)
	local Position = p29.Position
	local huge = math.huge
	local v367 = nil
	local PlaceId = game.PlaceId
	local t4 = {}
	local t5

	if PlaceId == 2753915549 then
		t5 = {
			Sky3 = Vector3.new(-7894, 5547, -380),
			Sky3Exit = Vector3.new(-4607, 874, -1667),
			UnderWater = Vector3.new(61163, 11, 1819),
			["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
			["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),
			UnderwaterExit = Vector3.new(4050, -1, -1814)
		}
	elseif PlaceId == 4442272183 then
		t5 = {
			["Swan Mansion"] = Vector3.new(-390, 332, 673),
			["Swan Room"] = Vector3.new(2285, 15, 905),
			["Cursed Ship"] = Vector3.new(923, 126, 32852),
			["Zombie Island"] = Vector3.new(-6509, 83, -133)
		}
	else
		t5 = PlaceId == 7449423635 and {
			["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
			["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
			Mansion = Vector3.new(-12462, 375, -7552),
			Castle = Vector3.new(-5036, 315, -3179),
			["Dimensional Shift"] = Vector3.new(-2097.3447265625, 4776.24462890625, -15013.4990234375),
			["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
			["Beautiful Room"] = Vector3.new(5314.58203, 22.5364361, -125.942276, 1, 2.14762768e-8, -1.99111154e-13, -2.14762768e-8, 1, -3.0510602e-8, 1.98455903e-13, 3.0510602e-8, 1),
			["Temple of Time"] = Vector3.new(28286, 14897, 103)
		} or t4
	end

	for _, v in pairs(t5) do
		local Magnitude = (v - Position).Magnitude

		if Magnitude < huge then
			v367 = v
			huge = Magnitude
		end
	end

	if not (huge > (Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) then
		return v367
	end
end
function requestEntrance(p30)
	game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", p30)

	local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

	HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
	task.wait(0.5)
end
function TelePPlayer(p31)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p31
end
function topos(p32)
	local LocalPlayer = game.Players.LocalPlayer

	if not (LocalPlayer.Character and LocalPlayer.Character.Humanoid.Health > 0 and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
		return
	end

	local Magnitude = (p32.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

	if not p32 then
		return
	end

	local v377 = CheckNearestTeleporter(p32)

	if v377 then
		requestEntrance(v377)
	end

	if not LocalPlayer.Character:FindFirstChild("PartTele") then
		local Part = Instance.new("Part", LocalPlayer.Character)

		Part.Size = Vector3.new(10, 1, 10)
		Part.Name = "PartTele"
		Part.Anchored = true
		Part.Transparency = 1
		Part.CanCollide = true
		Part.CFrame = WaitHRP(LocalPlayer).CFrame

		local v379 = Part
		local v380 = v379

		v379.GetPropertyChangedSignal(v380, "CFrame"):Connect(function()
			if not u363 then
				return
			end

			task.wait()

			if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
				return
			end

			WaitHRP(LocalPlayer).CFrame = v379.CFrame
		end)
	end

	u363 = true

	local tween_ = game:GetService("TweenService"):Create(LocalPlayer.Character.PartTele, TweenInfo.new(Magnitude / 360, Enum.EasingStyle.Linear), {
		CFrame = p32
	})

	tween_:Play()
	tween_.Completed:Connect(function(playbackState)
		if playbackState ~= Enum.PlaybackState.Completed then
			return
		end

		if LocalPlayer.Character:FindFirstChild("PartTele") then
			LocalPlayer.Character.PartTele:Destroy()
		end

		u363 = false
	end)
end
function stopTeleport()
	u363 = false

	local LocalPlayer = game.Players.LocalPlayer

	if not LocalPlayer.Character:FindFirstChild("PartTele") then
		return
	end

	LocalPlayer.Character.PartTele:Destroy()
end

spawn(function()
	while task.wait() do
		if not u363 then
			stopTeleport()
		end
	end
end)
spawn(function()
	local LocalPlayer = game.Players.LocalPlayer

	while task.wait() do
		pcall(function()
			if not (LocalPlayer.Character:FindFirstChild("PartTele") and (LocalPlayer.Character.HumanoidRootPart.Position - LocalPlayer.Character.PartTele.Position).Magnitude >= 100) then
				return
			end

			stopTeleport()
		end)
	end
end)

local LocalPlayer = game.Players.LocalPlayer

local function v385(character)
	character:WaitForChild("Humanoid").Died:Connect(function()
		stopTeleport()
	end)
end

LocalPlayer.CharacterAdded:Connect(v385)

if LocalPlayer.Character then
	v385(LocalPlayer.Character)
end

function TP1(p33)
	topos(p33)
end

spawn(function()
	while wait() do
		if _G.SpinPos then
			Pos = CFrame.new(0, PosY, -20)
			wait(0.1)
			Pos = CFrame.new(-20, PosY, 0)
			wait(0.1)
			Pos = CFrame.new(0, PosY, 20)
			wait(0.1)
			Pos = CFrame.new(20, PosY, 0)
		else
			Pos = CFrame.new(0, PosY, 0)
		end
	end
end)
spawn(function()
	while task.wait() do
		pcall(function()
			if _G.FarmBone or (_G.AutoFarm or (_G.Pray or (_G.Trylux or (_G.Hallow or (_G.FarmCake or (_G.FarmDaiBan or (_G.Greybeard or (_G.CursedCaptain or (_G.AutoDarkBoss or (_G.ChiefWarden or (_G.Trident or (_G.Longsword or (_G.GravityBlade or (_G.SwodsFlail or (_G.AutoRengoku or (_G.SwodsDRTrident or (_G.SwodCanvande or (_G.SwodsBuddy or (_G.FarmBlazeEM or (_G.AutoFindPrehistoric or (_G.TweenVolcano or (_G.DefendVolcano or (_G.KillGolem or (_G.SwodTwinHooks or (_G.Fullykatakuri or (_G.AutoBoss or (_G.SwodCanvander or (_G.AutoFarmMaterial or (_G.AutoSecondSea or (_G.Autosaw or (_G.ChiefWarden or (_G.Trident or (_G.AutoSaber or (_G.ThirdSea or (_G.AutoBartilo or (_G.AutoFactory or (_G.Longsword or (_G.GravityBlade or (_G.SwodsFlail or (_G.AutoRengoku or (_G.SwodsDRTrident or (_G.SwodTwinHooks or (_G.SwodCanvander or (_G.AutoRaidPirate or (_G.AutoQuestYama or (_G.AutoYamaQuest or (_G.AutoSaber or (_G.DefendVolcano or (_G.TPB or (_G.SailBoat or (_G.Autoterrorshark or (_G.KillShark or (_G.KillPiranha or (_G.KillFishCrew or (_G.AutoQuestRace or (_G.Dungeon or (_G.AutoLawRaid or (_G.Tweenfruit or (ProjectTrialPro or (_G.TweenMGear or (_G.AutoMysticIsland or (AutoUpgradeRace or (AutoRaceEvo1 or (_G.AutoFarmFruits or (_G.Autopole or (_G.Autosaw or (_G.AutoElitehunter or (FarmMtrFruit or (_G.AutoNear or (_G.CollectBerry or (_G.RipIndraKill or (_G.FarmChocola or (SoulGuitar or (_G.AutoHolyTorch or (_G.AutoGetTushita or (_G.AutoYama or (_G.AutoMobDragon or (_G.AutoHydraTree or (_G.TweenToKitsune or (_G.AutoDooHee or (_G.AutoAzuerEmber or (_G.TweenVolcano or (_G.Dungeon or (_G.AutoLawRaid or (_G.TweenFruit or (_G.Grabfruit or (_G.TeleportIsland or (_G.TeleportNPC or (_G.SafeMode or (_G.AutoPlayerHunter or (_G.AutoKillPlayer or (_G.TeleportPly or (_G.AutoQuestBoss or (_G.AutoAllBoss or (_G.AutoFarmLevelNew or (_G.FarmSummer or _G.BossPain)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) then
				if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					return
				end

				local BodyVelocity = Instance.new("BodyVelocity")

				BodyVelocity.Name = "BodyClip"
				BodyVelocity.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
				BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
				BodyVelocity.Velocity = Vector3.new(0, 0, 0)
			else
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
			end
		end)
	end
end)
spawn(function()
	pcall(function()
		game:GetService("RunService").Stepped:Connect(function()
			if not (_G.FarmBone or (_G.AutoFarm or (_G.Pray or (_G.Trylux or (_G.Hallow or (_G.FarmCake or (_G.FarmDaiBan or (_G.Fullykatakuri or (_G.AutoBoss or (_G.AutoMateria or (_G.AutoSecondSea or (_G.Autosaw or (_G.ChiefWarden or (_G.Trident or (_G.AutoSaber or (_G.Greybeard or (_G.CursedCaptain or (_G.AutoDarkBoss or (_G.ChiefWarden or (_G.Trident or (_G.Longsword or (_G.GravityBlade or (_G.SwodsFlail or (_G.AutoRengoku or (_G.SwodsDRTrident or (_G.SwodCanvande or (_G.SwodTwinHooks or (_G.ThirdSea or (_G.AutoBartilo or (_G.AutoFactory or (_G.Longsword or (_G.GravityBlade or (_G.SwodsFlail or (_G.AutoRengoku or (_G.SwodsDRTrident or (_G.SwodTwinHooks or (_G.SwodCanvander or (_G.SwodsBuddy or (_G.FarmBlazeEM or (_G.AutoFindPrehistoric or (_G.TweenVolcano or (_G.DefendVolcano or (_G.KillGolem or (_G.AutoRaidPirate or (_G.AutoQuestYama or (_G.AutoYamaQuest or (_G.AutoElitehunter or (FarmMtrFruit or (AutoUpgradeRace or (_G.AutoFarmMaterial or (AutoRaceEvo1 or (AutoSaber or (_G.Autopole or (_G.SwodCanvander or (_G.DefendVolcano or (_G.SailBoat or (_G.Autoterrorshark or (_G.KillShark or (_G.KillPiranha or (_G.KillFishCrew or (_G.AutoQuestRace or (_G.Dungeon or (_G.AutoLawRaid or (_G.Tweenfruit or (ProjectTrialPro or (_G.AutoMysticIsland or (_G.TweenMGear or (_G.Autosaw or (_G.AutoNear or (_G.AutoFarmFruits or (_G.CollectBerry or (_G.RipIndraKill or (_G.FarmChocola or (SoulGuitar or (_G.AutoHolyTorch or (_G.AutoGetTushita or (_G.AutoYama or (_G.AutoMobDragon or (_G.AutoHydraTree or (_G.TweenToKitsune or (_G.AutoDooHee or (_G.AutoAzuerEmber or (_G.TweenVolcano or (_G.Dungeon or (_G.AutoLawRaid or (_G.TweenFruit or (_G.Grabfruit or (_G.TeleportIsland or (_G.TeleportNPC or (_G.SafeMode or (_G.AutoPlayerHunter or (_G.AutoKillPlayer or (_G.TeleportPly or (_G.AutoQuestBoss or (_G.AutoAllBoss or (_G.AutoFarmLevelNew or (_G.FarmSummer or _G.BossPain))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) then
				return
			end

			for _, descendant in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end
		end)
	end)
end)

local t6 = {}

function TP13(p34)
	local Magnitude = (p34.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	local v391 = game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Magnitude / TweenSpeed, Enum.EasingStyle.Linear), {
		CFrame = p34
	}):Play()

	function t6.Stop(_)
		v391:Cancel()
	end

	return t6
end
function fastpos(p35)
	Distance = (p35.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	Speed = 1000
	game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), {
		CFrame = p35
	}):Play()
end
function slowpos(p36)
	Distance = (p36.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	Speed = 150
	game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), {
		CFrame = p36
	}):Play()
end
function BTP(p37)
	pcall(function()
		if (p37.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 or (Auto_Raid or game.Players.LocalPlayer.Character.Humanoid.Health <= 0) then
			return
		end

		repeat
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p37
			wait(0.05)
			game.Players.LocalPlayer.Character.Head:Destroy()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p37
		until (p37.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 and game.Players.LocalPlayer.Character.Humanoid.Health > 0
	end)
end
function TelePPlayer(p38)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p38
end
function TPB(p39)
	local TweenService = game:service("TweenService")
	local tweenInfo = TweenInfo.new((game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame.Position - p39.Position).Magnitude / 300, Enum.EasingStyle.Linear)

	tween = TweenService:Create(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat, tweenInfo, {
		CFrame = p39
	})
	tween:Play()

	return {
		Stop = function(_)
			tween:Cancel()
		end
	}
end
function TPP(p40)
	if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health <= 0 or not game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") then
		tween:Cancel()

		repeat
			wait()
		until game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Health > 0

		wait(7)

		return
	end

	local TweenService = game:service("TweenService")
	local tweenInfo = TweenInfo.new((game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - p40.Position).Magnitude / 325, Enum.EasingStyle.Linear)

	tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {
		CFrame = p40
	})
	tween:Play()

	return {
		Stop = function(_)
			tween:Cancel()
		end
	}
end
function StopTween(p41)
	if p41 then
		return
	end

	_G.StopTween = true
	wait()
	topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
	wait()

	if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
	end

	_G.StopTween = false
	_G.Clip = false
end

spawn(function()
	pcall(function()
		while wait() do
			for _, child in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
				if child:IsA("Tool") and child:FindFirstChild("RemoteFunctionShoot") then
					_G.SelectWeaponGun = child.Name
				end
			end
		end
	end)
end)
game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	wait(1)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

function CheckColorRipIndra()
	mmb = {}

	local next_ = next
	local children, key = game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:GetChildren()

	while true do
		local v401

		key, v401 = next_(children, key)

		if key == nil then
			break
		end

		if v401:IsA("Part") and (v401:FindFirstChild("Part") and v401.Part.BrickColor.Name == "Dark stone grey") then
			mmb[v401.BrickColor.Name] = v401
		end
	end

	return mmb
end
function ActivateColor(p42)
	haki = {
		["Hot pink"] = "Winter Sky",
		["Really red"] = "Pure Red",
		Oyster = "Snow White"
	}
	runnay = haki[p42]

	if not runnay then
		return
	end

	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("activateColor", runnay)
end
function AutoActiveColorRip_Indra()
	for k, v in pairs(CheckColorRipIndra()) do
		ActivateColor(k)
		topos(v.CFrame)
		firetouchinterest(v.TouchInterest)
	end
end
function CheckRace()
	local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
	local response2 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1")

	if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
		return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V4"
	elseif response == -2 then
		return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V3"
	elseif response2 == -2 then
		return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V2"
	else
		return game:GetService("Players").LocalPlayer.Data.Race.Value .. " V1"
	end
end

_G.TargTrial = "TargTrial"

function targettrial()
	if _G.TargTrial == "TargTrial" then
		local n2 = 450
		local v407 = nil

		for _, child in pairs(game.Players:GetChildren()) do
			c = (child.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

			if c <= n2 and child ~= game.Players.LocalPlayer then
				n2 = c
				v407 = child
			end
		end

		if v407 == "c" then
			return
		elseif _G.TargTrial ~= "c" then
			return
		else
			_G.TargTrial = v407

			return
		end
	end
end
function CheckPirateBoat()
	local next_ = next
	local children, key = game:GetService("Workspace").Enemies:GetChildren()
	local t7 = { "PirateBrigade", "PirateBrigade" }

	while true do
		local v414

		key, v414 = next_(children, key)

		if key == nil then
			break
		end

		if table.find(t7, v414.Name) and (v414:FindFirstChild("Health") and v414.Health.Value > 0) then
			return v414
		end
	end
end
function CheckPirateBoat()
	local next_ = next
	local children, key = game:GetService("Workspace").Enemies:GetChildren()
	local t8 = { "FishBoat" }

	while true do
		local v419

		key, v419 = next_(children, key)

		if key == nil then
			break
		end

		if table.find(t8, v419.Name) and (v419:FindFirstChild("Health") and v419.Health.Value > 0) then
			return v419
		end
	end
end
function StoreFruit()
	for _, child in pairs(thelocal.Backpack:GetChildren()) do
		if child:IsA("Tool") and string.find(child.Name, "Fruit") then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", child:GetAttribute("OriginalName"), child)
		end
	end
end
function TpEntrance(p43)
	game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", p43)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
	wait(0.5)
end
function CheckItemBPCRBPCR(p44)
	chbp = { game.Players.LocalPlayer.Character, game.Players.LocalPlayer.Backpack }

	for _, v in pairs(chbp) do
		if v:FindFirstChild(p44) then
			return v:FindFirstChild(p44)
		end
	end
end

local v424 = loadstring(game:HttpGet("https://raw.githubusercontent.com/farehamhz/RedzLib/main/RedzLib"))():MakeWindow({
	Title = "redz Hub",
	SubTitle = "by real_redz",
	SaveFolder = "Redz | redz lib v5.lua"
})
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "ControlGUI"
ScreenGui.Parent = game.CoreGui

local ImageButton = Instance.new("ImageButton")

ImageButton.Size = UDim2.new(0, 35, 0, 35)
ImageButton.Position = UDim2.new(0.15, 0, 0.15, 0)
ImageButton.Image = "rbxassetid://80424431930361"
ImageButton.BackgroundTransparency = 1
ImageButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0.25, 0)
UICorner.Parent = ImageButton

local u428 = true
local u429 = nil
local u430 = nil
local Position = nil
local Position2 = nil

local function v433(p45)
	local v434 = p45.Position - Position

	ImageButton.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v434.X, Position2.Y.Scale, Position2.Y.Offset + v434.Y)
end

ImageButton.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
		return
	end

	u429 = true
	Position = input.Position
	Position2 = ImageButton.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		u429 = false
	end)
end)
ImageButton.InputChanged:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		return
	end

	u430 = input
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if not (u429 and input == u430) then
		return
	end

	v433(input)
end)
ImageButton.MouseButton1Click:Connect(function()
	u428 = not u428

	if u428 then
		v424:Minimize(false)
	else
		v424:Minimize(true)
	end
end)

local v435 = v424
local v436 = v424.MakeTab(v435, { "Farming", "home" })
local v437 = v424
local v438 = v424.MakeTab(v437, { "Auto Fishing", "rbxassetid://" })
local v439 = v424
local v440 = v424.MakeTab(v439, { "Quest | Items", "swords" })
local v441 = v424
local v442 = v424.MakeTab(v441, { "Volcano Dojo", "cake" })
local v443 = v424
local v444 = v424.MakeTab(v443, { "Sea Event", "waves" })
local v445 = v424
local v446 = v424.MakeTab(v445, { "Race V4", "crown" })
local v447 = v424
local v448 = v424.MakeTab(v447, { "Raid Fruits", "cherry" })
local v449 = v424
local v450 = v424.MakeTab(v449, { "Fruits | Check Stock", "apple" })
local v451 = v424
local v452 = v424.MakeTab(v451, { "Teleport", "locate" })
local v453 = v424
local v454 = v424.MakeTab(v453, { "PvP,Player", "user" })
local v455 = v424
local v456 = v424.MakeTab(v455, { "Shop", "shoppingCart" })
local v457 = v424
local v458 = v424.MakeTab(v457, { "Settings", "settings" })

v436:AddSection({ "Select Melee,Sword,Gun,Fruit" })
_G.SelectWeapon = "Melee"
task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.SelectWeapon == "Melee" then
				for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if child.ToolTip == "Melee" then
						_G.SelectWeapon = child.Name
					end
				end
			elseif _G.SelectWeapon == "Sword" then
				for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if child.ToolTip == "Sword" then
						_G.SelectWeapon = child.Name
					end
				end
			elseif _G.SelectWeapon ~= "Gun" then
				if not (_G.SelectWeapon == "Fruit" or _G.SelectWeapon == "Blox Fruit") then
					return
				end

				for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if child.ToolTip == "Blox Fruit" then
						_G.SelectWeapon = child.Name
					end
				end
			else
				for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if child.ToolTip == "Gun" then
						_G.SelectWeapon = child.Name
					end
				end
			end
		end)
	end
end)
v436:AddDropdown({
	Name = "Chọn Công Cụ",
	Description = "Chọn công cụ bạn muốn sử dụng",
	Options = {
		"Melee",
		"Sword",
		"Gun",
		"Blox Fruit"
	},
	Default = "Melee",
	Flag = "WeaponType",
	Callback = function(p46)
		_G.SelectWeapon = p46
	end
})
v436:AddSection({ "Main Farm" })
v436:AddToggle({
	Name = "Auto Farm Level",
	Description = "Only Level 1 -> Level 2650",
	Default = false,
	Callback = function(p47)
		_G.AutoFarm = p47
		StopTween(_G.AutoFarm)
	end
})
spawn(function()
	while task.wait() do
		if _G.AutoFarm then
			pcall(function()
				local Text = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

				CheckQuest()

				if not string.find(Text, NameMon) then
					StartBring = false
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
				end

				if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
					StartBring = false

					if BypassTP then
						if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 1500 then
							TP1(CFrameQuest)
						else
							TP1(CFrameQuest)
						end
					else
						TP1(CFrameQuest)
					end

					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then
						return
					end

					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
				else
					if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
						return
					end

					if string.find(Text, "kissed") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if string.find(child.Name, "kissed Warrior") then
								if child:FindFirstChild("HumanoidRootPart") and (child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0) then
									if string.find(Text, NameMon) then
										repeat
											task.wait()
											EquipWeapon(_G.SelectWeapon)
											PosMon = child.HumanoidRootPart.CFrame
											topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
											child.HumanoidRootPart.CanCollide = false
											child.Humanoid.WalkSpeed = 0
											child.Head.CanCollide = false
											child.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
											StartBring = true
											MonFarm = child.Name
											game:GetService("VirtualUser"):CaptureController()
											game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
										until not _G.AutoFarm or (child.Humanoid.Health <= 0 or not child.Parent) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
									else
										StartBring = false
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
									end
								end
							else
								TP1(CFrameMon)
								StartBring = false

								if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
									TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
								end
							end
						end
					elseif game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child:FindFirstChild("HumanoidRootPart") and (child:FindFirstChild("Humanoid") and (child.Humanoid.Health > 0 and child.Name == Mon)) then
								if string.find(Text, NameMon) then
									repeat
										task.wait()
										EquipWeapon(_G.SelectWeapon)
										AutoHaki()
										PosMon = child.HumanoidRootPart.CFrame
										topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
										child.HumanoidRootPart.CanCollide = false
										child.Humanoid.WalkSpeed = 0
										child.Head.CanCollide = false
										child.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
										StartBring = true
										MonFarm = child.Name
										game:GetService("VirtualUser"):CaptureController()
										game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
									until not _G.AutoFarm or (child.Humanoid.Health <= 0 or not child.Parent) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
								else
									StartBring = false
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
								end
							end
						end
					else
						TP1(CFrameMon)
						StartBring = false

						if not game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
					end
				end
			end)
		end
	end
end)
v436:AddToggle({
	Title = "Farm Level New",
	Description = "Only Submerged Island",
	Value = false,
	Callback = function(p48)
		_G.AutoFarmLevelNew = p48
		StopTween(_G.AutoFarmLevelNew)
	end
})

function CheckQuestNew()
	local Value = game.Players.LocalPlayer.Data.Level.Value

	if 2600 <= Value and Value <= 2624 then
		MonNew = "Reef Bandit"
		LevelQuestNew = 1
		NameQuestNew = "SubmergedQuest1"
		NameMonNew = "Reef Bandit"
		CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
		CFrameMonNew = CFrame.new(10736.6191, -2087.8439, 9338.4882)
	elseif Value < 2625 or 2649 < Value then
		if 2650 <= Value and Value <= 2674 then
			MonNew = "Sea Chanter"
			LevelQuestNew = 1
			NameQuestNew = "SubmergedQuest2"
			NameMonNew = "Sea Chanter"
			CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
			CFrameMonNew = CFrame.new(10621.0342, -2087.844, 10102.0332)
		else
			if not (2675 <= Value and Value <= 2750) then
				return
			end

			MonNew = "Ocean Prophet"
			LevelQuestNew = 2
			NameQuestNew = "SubmergedQuest2"
			NameMonNew = "Ocean Prophet"
			CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
			CFrameMonNew = CFrame.new(11056.1445, -2001.6717, 10117.4493)
		end
	else
		MonNew = "Coral Pirate"
		LevelQuestNew = 2
		NameQuestNew = "SubmergedQuest1"
		NameMonNew = "Coral Pirate"
		CFrameQuestNew = CFrame.new(10882.264, -2086.322, 10034.226)
		CFrameMonNew = CFrame.new(10965.1025, -2158.8842, 9177.2597)
	end
end

spawn(function()
	while task.wait() do
		if _G.AutoFarmLevelNew then
			pcall(function()
				local Quest = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest

				CheckQuestNew()

				if Quest.Visible ~= false then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == MonNew and (child:FindFirstChild("HumanoidRootPart") and (child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0)) then
							if string.find(Quest.Container.QuestTitle.Title.Text, NameMonNew) then
								repeat
									task.wait()
									EquipWeapon(_G.SelectWeapon)
									AutoHaki()
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									child.Head.CanCollide = false
									child.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
									StartBring = true
									MonFarmNew = child.Name
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
								until not _G.AutoFarmLevelNew or (child.Humanoid.Health <= 0 or (not child.Parent or Quest.Visible == false))
							else
								StartBring = false
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
							end
						end
					end

					if game:GetService("Workspace").Enemies:FindFirstChild(MonNew) then
						return
					end

					TP1(CFrameMonNew)
					StartBring = false
				else
					StartBring = false

					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuestNew.Position).Magnitude <= 20 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuestNew, LevelQuestNew)
					else
						TP1(CFrameQuestNew)
					end
				end
			end)
		end
	end
end)
v436:AddToggle({
	Name = "Auto Kill Near | Mob Aura",
	Description = "�ánh Quái Gần",
	Default = false,
	Callback = function(p49)
		_G.AutoNear = p49
		StopTween(_G.AutoNear)
	end
})
spawn(function()
	while wait() do
		if _G.AutoNear then
			pcall(function()
				for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
					if child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and (child.Humanoid.Health > 0 and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude <= 5000)) then
						repeat
							wait(_G.Fast_Delay)
							StartBring = true
							AutoHaki()
							EquipWeapon(_G.SelectWeapon)
							topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
							child.HumanoidRootPart.Transparency = 1
							child.Humanoid.JumpPower = 0
							child.Humanoid.WalkSpeed = 0
							child.HumanoidRootPart.CanCollide = false
							FarmPos = child.HumanoidRootPart.CFrame
							MonFarm = child.Name
						until not _G.AutoNear or (not child.Parent or child.Humanoid.Health <= 0) or not game.Workspace.Enemies:FindFirstChild(child.Name)

						StartBring = false
					end
				end
			end)
		end
	end
end)
v436:AddSection({ "Boss" })

local v478 = World1 and {
	"The Gorilla King",
	"Bobby",
	"Yeti",
	"Mob Leader",
	"Vice Admiral",
	"Warden",
	"Chief Warden",
	"Swan",
	"Magma Admiral",
	"Fishman Lord",
	"Wysper",
	"Thunder God",
	"Cyborg",
	"Saber Expert"
} or (World2 and {
	"Diamond",
	"Jeremy",
	"Fajita",
	"Don Swan",
	"Smoke Admiral",
	"Cursed Captain",
	"Darkbeard",
	"Order",
	"Awakened Ice Admiral",
	"Tide Keeper"
} or (World3 and {
	"",
	"Stone",
	"Island Empress",
	"Hydra Leader",
	"Kilo Admiral",
	"Captain Elephant",
	"Beautiful Pirate",
	"rip_indra True Form",
	"Longma",
	"Soul Reaper",
	"Cake Queen"
} or {}))

v436:AddDropdown({
	Name = "Auto Select Boss",
	Description = "Chọn Boss Cần Farm",
	Options = v478,
	Default = v478[1],
	Callback = function(p50)
		_G.SelectBoss = p50
	end
})
v436:AddToggle({
	Name = "Auto Farm Boss",
	Description = "Farm Boss Đã Chọn",
	Default = false,
	Callback = function(p51)
		_G.BossPain = p51
		StopTween(_G.BossPain)
	end
})
task.spawn(function()
	while task.wait() do
		if _G.BossPain and _G.SelectBoss then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == _G.SelectBoss and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
								topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
							until not _G.BossPain or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					if not game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) then
						return
					end

					topos(game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
				end
			end)
		end
	end
end)
v436:AddSection({ "AutoRaidPirate" })
v436:AddToggle({
	Name = "Farm Pirate",
	Description = "�ánh Hải Tặc Trên Pháo Đài Biển",
	Default = false,
	Callback = function(p52)
		_G.AutoRaidPirate = p52
		StopTween(_G.AutoRaidPirate)
	end
})
spawn(function()
	while wait() do
		if _G.AutoRaidPirate then
			pcall(function()
				local cFrame = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-9, 0.380223751, 3.5881019e-8, 1, -1.06665446e-7, -0.380223751, 1.12297109e-7, 0.924894512)

				if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
					if (cFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 1500 then
						TP1(cFrame)
					else
						TP1(cFrame)
					end
				else
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if _G.AutoRaidPirate and (child:FindFirstChild("HumanoidRootPart") and (child:FindFirstChild("Humanoid") and (child.Humanoid.Health > 0 and (child.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000))) then
							repeat
								wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								NeedAttacking = true
								StartMagnet = true
								child.HumanoidRootPart.CanCollide = false
								child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
								topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							until child.Humanoid.Health <= 0 or (not child.Parent or _G.AutoRaidPirate == false)

							NeedAttacking = false
							StartMagnet = false
						end
					end
				end
			end)
		end
	end
end)
v436:AddSection({ "TyrantoftheSkies" })

local v484 = v436:AddParagraph({
	Title = "Check Eyes Status",
	Content = "Loading..."
})

task.spawn(function()
	while task.wait(1) do
		pcall(function()
			local t9 = {
				workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye1"),
				workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye2"),
				workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye3"),
				workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye4")
			}
			local n3 = 0

			for _, v in ipairs(t9) do
				if v and (v:IsA("BasePart") and v.Transparency == 0) then
					n3 = n3 + 1
				end
			end

			v484:Set("Status: " .. n3 .. " Eye(s)" .. (n3 == 4 and " ������" or ""))
		end)
	end
end)
v436:AddToggle({
	Name = "Auto Farm Tyrant",
	Description = "Farm Quái Và Đánh Boss Chim",
	Default = false,
	Callback = function(p53)
		_G.FarmDaiBan = p53
		StopTween(_G.FarmDaiBan)
	end
})

local cFrame = CFrame.new(-16194.0048828125, 155.21844482421875, 1420.719970703125)
local _ = game:GetService("Workspace").Enemies

task.spawn(function()
	while task.wait() do
		if _G.FarmDaiBan then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Tyrant of the Skies") then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == "Tyrant of the Skies" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
								topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0))
								NeedAttacking = true
							until not _G.FarmDaiBan or (not child.Parent or child.Humanoid.Health <= 0)

							wait(1)
						end
					end
				else
					local v493 = false

					for _, v in pairs({
						"Isle Outlaw",
						"Island Boy",
						"Isle Champion",
						"Serpent Hunter",
						"Skull Slayer"
					}) do
						if game:GetService("Workspace").Enemies:FindFirstChild(v) then
							v493 = true

							break
						end
					end

					if v493 then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name ~= "Isle Outlaw" and (child.Name ~= "Island Boy" and (child.Name ~= "Isle Champion" and (child.Name ~= "Serpent Hunter" and child.Name ~= "Skull Slayer"))) or (not child:FindFirstChild("Humanoid") or (not child:FindFirstChild("HumanoidRootPart") or child.Humanoid.Health <= 0)) then
								continue
							end

							while true do
								if true then
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									StartBring = true
									child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									PosMon = child.HumanoidRootPart.CFrame
									MonFarm = child.Name
									child.Head.CanCollide = false
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									NeedAttacking = true

									if child.Name == "Isle Outlaw" then
										Bring(child.Name, CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656))
									elseif child.Name ~= "Island Boy" then
										if child.Name == "Isle Champion" then
											Bring(child.Name, CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375))
										elseif child.Name == "Serpent Hunter" then
											Bring(child.Name, CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, 0, 0.882950008, 0, 1, 0, -0.882950008, 0, 0.469467044))
										elseif child.Name == "Skull Slayer" then
											Bring(child.Name, CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, 0, -0.0348687991, 0, 1, 0, 0.0348687991, 0, -0.999392271))
										end
									else
										Bring(child.Name, CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562))
									end
								end

								if _G.FarmDaiBan and (child.Parent and child.Humanoid.Health > 0) and (game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency ~= 0 and not (game:GetService("ReplicatedStorage"):FindFirstChild("Tyrant of the Skies [Lv. 2600] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Tyrant of the Skies [Lv. 2600] [Raid Boss]"))) then
									continue
								else
									break
								end
							end

							DamageAura = false

							continue
						end
					else
						local v498 = math.random(1, 3)

						if v498 == 1 then
							topos(CFrame.new(-1436.86011, 167.753616, -12296.9512))
						elseif v498 == 2 then
							topos(CFrame.new(-2383.78979, 150.450592, -12126.4961))
						elseif v498 == 3 then
							topos(CFrame.new(-2231.2793, 168.256653, -12845.7559))
						end
					end

					if BypassTP then
						if (playerPos - cFrame.Position).Magnitude <= 1500 then
							topos(cFrame)
						else
							BTP(cFrame)
						end
					else
						topos(cFrame)
					end

					UnEquipWeapon(_G.Selectweapon)
					topos(CFrame.new(-16194.0048828125, 155.21844482421875, 1420.719970703125))
				end
			end)
		end
	end
end)
v436:AddToggle({
	Name = "Summon Tyrant Of The Skies",
	Description = "Tự Động Phá Bình Để Triệu Hồi Boss",
	Default = false,
	Callback = function(p54)
		_G.Farm8Binhs = p54
		StopTween(_G.Farm8Binhs)
	end
})

local t10 = {
	CFrame.new(-16250.2354, 158.167007, 1313.01904, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
	CFrame.new(-16250.2354, 158.167007, 1313.01904, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
	CFrame.new(-16297.0596, 159.322998, 1317.224, -0.463313937, 0, 0.886194229, 0, 1, 0, -0.886194229, 0, -0.463313937),
	CFrame.new(-16335.0967, 159.334, 1324.88599, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
	CFrame.new(-16288.6094, 158.167007, 1470.36804, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
	CFrame.new(-16258.001, 156.761002, 1461.40405, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874),
	CFrame.new(-16245.4121, 158.436996, 1463.36597, -0.993159413, 0, 0.116766132, 0, 1, 0, -0.116766132, 0, -0.993159413),
	CFrame.new(-16212.4688, 158.167007, 1466.34399, 0.999388874, 0, 0.0349550731, 0, 1, 0, -0.0349550731, 0, 0.999388874)
}

function TweenToPosition(p55)
	local Character = game.Players.LocalPlayer.Character
	local TweenService, v502, tween_

	if not Character then
		if Character then
			TweenService = game:GetService("TweenService")
			v502 = (Character.Position - p55.Position).Magnitude / 300
			tween_ = TweenService:Create(Character, TweenInfo.new(v502, Enum.EasingStyle.Linear), {
				CFrame = p55
			})
			tween_:Play()
			tween_.Completed:Wait()
		end

		return
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character then
		TweenService = game:GetService("TweenService")
		v502 = (Character.Position - p55.Position).Magnitude / 300
		tween_ = TweenService:Create(Character, TweenInfo.new(v502, Enum.EasingStyle.Linear), {
			CFrame = p55
		})
		tween_:Play()
		tween_.Completed:Wait()
	end
end
function Skill(p56)
	local VirtualInputManager = game:GetService("VirtualInputManager")

	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[p56], false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[p56], false, game)
end
function Click()
	local VirtualInputManager = game:GetService("VirtualInputManager")

	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
	task.wait(0.05)
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end
function FindWeapon(p57)
	local Backpack = game.Players.LocalPlayer.Backpack

	for _, child in ipairs(Backpack:GetChildren()) do
		if child:IsA("Tool") then
			if p57 == "Melee" and (child.ToolTip == "Melee" or child.Name == "Combat") then
				return child.Name
			end

			if p57 == "Sword" and child.ToolTip == "Sword" then
				return child.Name
			end

			if p57 == "Gun" and child.ToolTip == "Gun" then
				return child.Name
			end

			if p57 == "Fruit" and child.ToolTip == "Blox Fruit" then
				return child.Name
			end
		end
	end

	return nil
end
function EquipWeapon(p58)
	if not p58 then
		return
	end

	local LocalPlayer2 = game.Players.LocalPlayer
	local v510 = LocalPlayer2:WaitForChild("Backpack"):FindFirstChild(p58)

	if not v510 then
		return
	end

	LocalPlayer2.Character.Humanoid:EquipTool(v510)
end
function AttackAllSkills()
	local Melee = FindWeapon("Melee")
	local Sword = FindWeapon("Sword")
	local Fruit = FindWeapon("Fruit")
	local Gun = FindWeapon("Gun")

	if Melee then
		EquipWeapon(Melee)
		Skill("Z")
		Skill("X")
		Skill("C")
		Skill("V")
		Click()
	end

	if Sword then
		EquipWeapon(Sword)
		Skill("Z")
		Skill("X")
		Click()
	end

	if Fruit then
		EquipWeapon(Fruit)
		Skill("Z")
		Skill("X")
		Skill("C")
		Skill("F")
		Click()
	end

	if not Gun then
		return
	end

	EquipWeapon(Gun)
	Skill("Z")
	Skill("X")
	Click()
end

task.spawn(function()
	while task.wait(1) do
		if _G.Farm8Binhs then
			local v515, v516, v517 = ipairs(t10)

			while true do
				local v518

				v517, v518 = v515(v516, v517)

				if v517 == nil or not _G.Farm8Binhs then
					break
				end

				TweenToPosition(v518 * CFrame.new(0, 5, 0))
				task.wait(0.5)
				AttackAllSkills()
				task.wait(3)
			end
		end
	end
end)
v436:AddSection({ "Xương" })

local v519 = v436:AddParagraph({
	Title = "Check Bone",
	Content = "Loading..."
})

task.spawn(function()
	while task.wait(1) do
		pcall(function()
			local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")

			v519:Set("You Have: " .. tostring(response) .. " Bones")
		end)
	end
end)
v436:AddToggle({
	Name = "Fram Bone",
	Description = "Fram Sương",
	Default = false,
	Callback = function(p59)
		_G.FarmBone = p59
		StopTween(_G.FarmBone)
	end
})
spawn(function()
	while wait() do
		local cFrame2 = CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625)

		if _G.FarmBone and World3 then
			pcall(function()
				local v522, v523, v524, v525, v526, v527, v528, v529

				if BypassTP then
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cFrame2.Position).Magnitude <= 2000 then
						if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cFrame2.Position).Magnitude >= 2000 then
							if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton") or (game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie") or (game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy"))) then
								v522, v523, v524 = pairs(game:GetService("Workspace").Enemies:GetChildren())

								while true do
									v524, v525 = v522(v523, v524)

									if v524 == nil then
										break
									end

									if (v525.Name == "Reborn Skeleton" or (v525.Name == "Living Zombie" or (v525.Name == "Demonic Soul" or v525.Name == "Posessed Mummy"))) and (v525:FindFirstChild("Humanoid") and (v525:FindFirstChild("HumanoidRootPart") and v525.Humanoid.Health > 0)) then
										repeat
											task.wait()
											AutoHaki()
											NoAttackAnimation = true
											NeedAttacking = true
											EquipWeapon(_G.SelectWeapon)
											v525.HumanoidRootPart.CanCollide = false
											v525.Humanoid.WalkSpeed = 0
											v525.Head.CanCollide = false
											StartBring = true
											MonFarm = v525.Name
											PosMon = v525.HumanoidRootPart.CFrame
											topos(v525.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
											sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
										until not _G.FarmBone or (not v525.Parent or v525.Humanoid.Health <= 0)
									end
								end
							else
								StartBring = false
								topos(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
								v526, v527, v528 = pairs(game:GetService("ReplicatedStorage"):GetChildren())

								while true do
									v528, v529 = v526(v527, v528)

									if v528 == nil then
										break
									end

									if v529.Name ~= "Reborn Skeleton" then
										if v529.Name == "Living Zombie" then
											topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
										elseif v529.Name == "Demonic Soul" then
											topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
										elseif v529.Name == "Posessed Mummy" then
											topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
										end
									else
										topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
									end
								end
							end

							return
						end

						TP1(cFrame2)
					else
						TP1(cFrame2)
						wait(0.1)

						for _ = 1, 8 do
							game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(cFrame2)
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
							wait(0.1)
						end
					end
				else
					TP1(cFrame2)
				end

				if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton") or (game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie") or (game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy"))) then
					v522, v523, v524 = pairs(game:GetService("Workspace").Enemies:GetChildren())

					while true do
						v524, v525 = v522(v523, v524)

						if v524 == nil then
							break
						end

						if (v525.Name == "Reborn Skeleton" or (v525.Name == "Living Zombie" or (v525.Name == "Demonic Soul" or v525.Name == "Posessed Mummy"))) and (v525:FindFirstChild("Humanoid") and (v525:FindFirstChild("HumanoidRootPart") and v525.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								NoAttackAnimation = true
								NeedAttacking = true
								EquipWeapon(_G.SelectWeapon)
								v525.HumanoidRootPart.CanCollide = false
								v525.Humanoid.WalkSpeed = 0
								v525.Head.CanCollide = false
								StartBring = true
								MonFarm = v525.Name
								PosMon = v525.HumanoidRootPart.CFrame
								topos(v525.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
							until not _G.FarmBone or (not v525.Parent or v525.Humanoid.Health <= 0)
						end
					end
				else
					StartBring = false
					topos(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
					v526, v527, v528 = pairs(game:GetService("ReplicatedStorage"):GetChildren())

					while true do
						v528, v529 = v526(v527, v528)

						if v528 == nil then
							break
						end

						if v529.Name ~= "Reborn Skeleton" then
							if v529.Name == "Living Zombie" then
								topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							elseif v529.Name == "Demonic Soul" then
								topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							elseif v529.Name == "Posessed Mummy" then
								topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							end
						else
							topos(v529.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
						end
					end
				end
			end)
		end
	end
end)
v436:AddToggle({
	Name = "Seperator Hallow Scythe",
	Description = "Triệu hồi và tiêu diệt Soul Reaper",
	Default = false,
	Callback = function(p60)
		_G.Hallow = p60
		StopTween(_G.Hallow)
	end
})
spawn(function()
	while wait() do
		if _G.Hallow then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if string.find(child.Name, "Soul Reaper") then
							repeat
								task.wait()
								EquipWeapon(_G.SelectWeapon)
								AutoHaki()
								child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
								topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								game:GetService("VirtualUser"):CaptureController()
								game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
								child.HumanoidRootPart.Transparency = 1
							until child.Humanoid.Health <= 0 or _G.Hallow == false
						end
					end
				elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hallow Essence") then
					repeat
						TP1(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
						wait()
					until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8

					EquipWeapon("Hallow Essence")
				else
					if not game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper") then
						return
					end

					TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
				end
			end)
		end
	end
end)
v436:AddToggle({
	Name = "Trade Bone",
	Description = "Tự động đổi xương lấy phần thưởng",
	Default = false,
	Callback = function(p61)
		_G.Rdbone = p61
		StopTween(_G.Rdbone)
	end
})
spawn(function()
	while wait(0.1) do
		if _G.Rdbone then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
		end
	end
end)
v436:AddToggle({
	Name = "Auto Pray",
	Description = "",
	Default = false,
	Callback = function(p62)
		_G.Pray = p62
		StopTween(_G.Pray)
	end
})
spawn(function()
	pcall(function()
		while wait(0.1) do
			if _G.Pray then
				TP1(CFrame.new(-8652.99707, 143.450119, 6170.50879, -0.983064115, -2.48005533e-10, 0.18326205, -1.78910387e-9, 1, -8.24392288e-9, -0.18326205, -8.43218029e-9, -0.983064115))
				wait()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 1)
			end
		end
	end)
end)
v436:AddToggle({
	Name = "Auto Try Luck",
	Description = "",
	Default = false,
	Callback = function(p63)
		_G.Trylux = p63
		StopTween(_G.Trylux)
	end
})
spawn(function()
	pcall(function()
		while wait(0.1) do
			if _G.Trylux then
				TP1(CFrame.new(-8652.99707, 143.450119, 6170.50879, -0.983064115, -2.48005533e-10, 0.18326205, -1.78910387e-9, 1, -8.24392288e-9, -0.18326205, -8.43218029e-9, -0.983064115))
				wait()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
			end
		end
	end)
end)
v436:AddSection({ "Katakuri" })

local v533 = v436:AddParagraph({
	Title = "Check Cake Prince",
	Content = "Loading..."
})

task.spawn(function()
	while task.wait(1) do
		pcall(function()
			local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")

			if string.len(response) ~= 88 then
				if string.len(response) == 87 then
					v533:Set("Killed : " .. string.sub(response, 39, 40) .. " / 500")
				elseif string.len(response) ~= 86 then
					v533:Set("Prince King Spawned ✅")
				else
					v533:Set("Killed : " .. string.sub(response, 39, 39) .. " / 500")
				end
			else
				v533:Set("Killed : " .. string.sub(response, 39, 41) .. " / 500")
			end
		end)
	end
end)
v436:AddToggle({
	Name = "Farm Katakuri",
	Description = "Fram Quái Và Đánh Hoàng Tử Bột V1",
	Default = false,
	Callback = function(p64)
		_G.FarmCake = p64
		StopTween(_G.FarmCake)
	end
})

local cFrame2 = CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375)
local _ = game:GetService("Workspace").Enemies

task.spawn(function()
	while task.wait() do
		if _G.FarmCake then
			pcall(function()
				local n4 = 97

				while true do
					local v538

					if n4 < 43 then
						if n4 < 14 then
							local v539

							if n4 < 3 then
								if n4 == 2 then
									local v540 = false

									for _, v in pairs({
										"Cookie Crafter",
										"Cake Guard",
										"Baking Staff",
										"Head Baker"
									}) do
										if game:GetService("Workspace").Enemies:FindFirstChild(v) then
											v540 = true

											return
										end
									end

									if not v540 then
										local v543 = math.random(1, 3)

										if v543 == 1 then
											topos(CFrame.new(-1436.86011, 167.753616, -12296.9512))
										elseif v543 == 2 then
											topos(CFrame.new(-2383.78979, 150.450592, -12126.4961))
										else
											if v543 ~= 3 then
												if BypassTP then
													if (playerPos - cFrame2.Position).Magnitude > 1500 then
														BTP(cFrame2)
													else
														topos(cFrame2)
													end
												else
													topos(cFrame2)
												end

												UnEquipWeapon(_G.Selectweapon)
												topos(CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375))

												return
											end

											topos(CFrame.new(-2231.2793, 168.256653, -12845.7559))
										end

										if BypassTP then
											if (playerPos - cFrame2.Position).Magnitude > 1500 then
												BTP(cFrame2)
											else
												topos(cFrame2)
											end
										else
											topos(cFrame2)
										end

										UnEquipWeapon(_G.Selectweapon)
										topos(CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375))

										return
									end

									local v544, v545

									v544, v545, v539 = pairs(game:GetService("Workspace").Enemies:GetChildren())
									n4 = 13
								else
									break
								end
							elseif n4 < 13 then
								if n4 == 3 then
									local v546, v547

									v546, v547, v538 = pairs(game:GetService("Workspace").Enemies:GetChildren())
									n4 = 72
								else
									break
								end
							elseif n4 == 13 then
								local v548

								v539, v548 = v790(v791, v539)

								if v539 == nil then
									if BypassTP then
										if (playerPos - cFrame2.Position).Magnitude > 1500 then
											BTP(cFrame2)
										else
											topos(cFrame2)
										end
									else
										topos(cFrame2)
									end

									UnEquipWeapon(_G.Selectweapon)
									topos(CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375))

									return
								end

								n4 = 14
							else
								break
							end
						elseif n4 < 28 then
							if n4 == 14 then
								if (v794.Name == "Cookie Crafter" or (v794.Name == "Cake Guard" or (v794.Name == "Baking Staff" or v794.Name == "Head Baker"))) and (v794:FindFirstChild("Humanoid") and (v794:FindFirstChild("HumanoidRootPart") and v794.Humanoid.Health > 0)) then
								end

								n4 = 28
							else
								break
							end
						elseif n4 < 35 then
							if n4 == 28 then
								if true then
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									v794.HumanoidRootPart.CanCollide = false
									v794.Humanoid.WalkSpeed = 0
									StartBring = true
									v794.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									PosMon = v794.HumanoidRootPart.CFrame
									MonFarm = v794.Name
									v794.Head.CanCollide = false
									topos(v794.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									NeedAttacking = true

									if v794.Name == "Cookie Crafter" then
										Bring(v794.Name, CFrame.new(-2212.88965, 37.0051041, -11969.2568, 0.458114207, 0, -0.888893366, 0, 1, 0, 0.888893366, 0, 0.458114207))
									elseif v794.Name ~= "Cake Guard" then
										if v794.Name ~= "Baking Staff" then
											if v794.Name == "Head Baker" then
												Bring(v794.Name, CFrame.new(-2151.37793, 51.0095749, -13033.3975, -0.996587753, 0, 0.0825396702, 0, 1, 0, -0.0825396702, 0, -0.996587753))
											end
										else
											Bring(v794.Name, CFrame.new(-1980.4375, 34.6653099, -12983.8408, -0.254338264, 0, -0.967115223, 0, 1, 0, 0.967115223, 0, -0.254338264))
										end
									else
										Bring(v794.Name, CFrame.new(-1693.98047, 35.2188225, -12436.8438, -0.716115236, 0, -0.697982132, 0, 1, 0, 0.697982132, 0, -0.716115236))
									end
								end

								n4 = 35
							else
								break
							end
						elseif n4 == 35 then
							if _G.FarmCake and (v794.Parent and v794.Humanoid.Health > 0) and (game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency ~= 0 and not (game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]"))) then
							end

							n4 = 43
						else
							break
						end
					elseif n4 < 81 then
						if n4 < 72 then
							if n4 == 43 then
								DamageAura = false

								break
							else
								break
							end
						elseif n4 < 73 then
							if n4 == 72 then
								local v549

								v538, v549 = v792(v793, v538)

								if v538 == nil then
									return
								end

								n4 = 73
							else
								break
							end
						elseif n4 == 73 then
							if v795.Name ~= "Cake Prince" or (not v795:FindFirstChild("Humanoid") or (not v795:FindFirstChild("HumanoidRootPart") or v795.Humanoid.Health <= 0)) then
							end

							n4 = 81
						else
							break
						end
					elseif n4 < 92 then
						if n4 < 89 then
							if n4 == 81 then
								if true then
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									v795.HumanoidRootPart.CanCollide = false
									v795.Humanoid.WalkSpeed = 0
									v795.HumanoidRootPart.Size = Vector3.new(50, 50, 50)

									if game:GetService("Workspace")._WorldOrigin:FindFirstChild("Ring") or (game:GetService("Workspace")._WorldOrigin:FindFirstChild("Fist") or game:GetService("Workspace")._WorldOrigin:FindFirstChild("MochiSwirl")) then
										topos(v795.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
									else
										topos(v795.HumanoidRootPart.CFrame * CFrame.new(4, 10, 10))
									end
								end

								n4 = 89
							else
								break
							end
						elseif n4 == 89 then
							NeedAttacking = true

							if _G.FarmCake and (v795.Parent and v795.Humanoid.Health > 0) then
							end

							n4 = 92
						else
							break
						end
					elseif n4 < 97 then
						if n4 == 92 then
							wait(1)

							break
						else
							break
						end
					elseif n4 == 97 then
						if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") then
						end

						break
					else
						break
					end
				end
			end)
		end
	end
end)
v436:AddToggle({
	Name = "Farm Katakuri V2",
	Description = "Fram Quái Và Đánh Hoàng Tử Bột V2",
	Default = false,
	Callback = function(p65)
		_G.Fullykatakuri = p65
		StopTween(_G.Fullykatakuri)
	end
})
spawn(function()
	while wait() do
		if _G.Fullykatakuri then
			pcall(function()
				if game.Players.LocalPlayer.Backpack:FindFirstChild("God\'s Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("God\'s Chalice") then
					if not string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc"), "Where") then
						return
					end

					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc")
				elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Sweet Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("Sweet Chalice") then
					if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "Do you want to open the portal now?") then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
					elseif game.Workspace.Enemies:FindFirstChild("Baking Staff") or (game.Workspace.Enemies:FindFirstChild("Head Baker") or (game.Workspace.Enemies:FindFirstChild("Cake Guard") or game.Workspace.Enemies:FindFirstChild("Cookie Crafter"))) then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if (child.Name == "Baking Staff" or (child.Name == "Head Baker" or (child.Name == "Cake Guard" or child.Name == "Cookie Crafter"))) and child.Humanoid.Health > 0 then
								repeat
									wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									AutoHaki()
									PosMon = child.HumanoidRootPart.CFrame
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									child.Head.CanCollide = false
									attackGunEnemies(child.Name, 5)
									child.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
									StartBring = false
									MonFarm = child.Name
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
								until _G.Fullykatakuri == false or (game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or (not child.Parent or child.Humanoid.Health <= 0))
							end
						end
					else
						CakeBring = false
						StartBring = false
						topos(CFrame.new(-1820.0634765625, 210.74781799316406, -12297.49609375))
					end
				elseif game.ReplicatedStorage:FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
					if game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Dough King" then
								repeat
									wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
									child.HumanoidRootPart.CanCollide = false
									StartBring = false
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
								until _G.Fullykatakuri == false or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						topos(CFrame.new(-2009.2802734375, 4532.97216796875, -14937.3076171875))
					end
				elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Red Key") or game.Players.LocalPlayer.Character:FindFirstChild("Red Key") then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "CakeScientist", "Check" }))
				elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
					if not (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban"))) then
						return
					end

					if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or (game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if (child.Name == "Diablo" or (child.Name == "Deandre" or child.Name == "Urban")) and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									PosMon = child.HumanoidRootPart.CFrame
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									child.Head.CanCollide = false
									attackGunEnemies(child.Name, 5)
									child.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
									StartBring = false
									MonFarm = child.Name
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until _G.Fullykatakuri == false or (child.Humanoid.Health <= 0 or not child.Parent) or (game.Players.LocalPlayer.Backpack:FindFirstChild("God\'s Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("God\'s Chalice"))
							end
						end
					elseif game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
						topos(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
					elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
						topos(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
							return
						end

						topos(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
					end
				else
					wait(0.5)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
				end
			end)
		end
	end
end)
v436:AddSection({ "Auto Farm Chest And Berry" })
v436:AddToggle({
	Name = "Auto Collect Berry",
	Description = "Tự động Nhặt Berry",
	Default = false,
	Callback = function(p66)
		_G.CollectBerry = p66
		StopTween(_G.CollectBerry)
	end
})
spawn(function()
	while wait() do
		if _G.CollectBerry then
			local LocalPlayer2 = game:GetService("Players").LocalPlayer
			local Position3 = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):GetPivot().Position
			local tagged = game:GetService("CollectionService"):GetTagged("BerryBush")
			local huge = math.huge
			local v560 = nil
			local v561 = nil

			for _, v in ipairs(tagged) do
				for k, v2 in pairs(v:GetAttributes()) do
					local Magnitude = (v.Parent:GetPivot().Position - Position3).Magnitude

					if Magnitude < huge then
						v561 = k
						v560 = v
						huge = Magnitude
					end
				end
			end

			if v560 and v561 then
				local Parent = v560.Parent
				local Position4 = Parent:GetPivot().Position

				TP1(CFrame.new(Position4 + Vector3.new(0, 2, 0)))
				task.wait(0.5)

				local v569 = Parent:FindFirstChild(v561)

				if v569 and v569:IsA("BasePart") then
					TP1(v569.CFrame + Vector3.new(0, 1, 0))
					task.wait(0.3)

					local VirtualInputManager = game:GetService("VirtualInputManager")

					VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
					task.wait(0.1)
					VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
				end
			elseif _G.CollectBerryHop then
				Hop()
			end
		end
	end
end)
v436:AddToggle({
	Name = "Auto Farm Chest [ Tween ]",
	Description = "Tự động Nhặt rương bằng tween",
	Default = false,
	Callback = function(p67)
		_G.FarmChest = p67
		StopTween(_G.FarmChest)
	end
})
spawn(function()
	while wait() do
		if _G.FarmChest then
			local LocalPlayer2 = game:GetService("Players").LocalPlayer
			local Position3 = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):GetPivot().Position
			local tagged = game:GetService("CollectionService"):GetTagged("_ChestTagged")
			local huge = math.huge
			local v575 = nil

			for i = 1, #tagged do
				local v577 = tagged[i]
				local Magnitude = (v577:GetPivot().Position - Position3).Magnitude

				if not v577:GetAttribute("IsDisabled") then
					if Magnitude < huge then
						v575 = v577
						huge = Magnitude
					end
				end
			end

			if v575 then
				local Position4 = v575:GetPivot().Position
				local cFrame3 = CFrame.new(Position4)

				topos(cFrame3)
			end
		end
	end
end)
v436:AddSection({ "Boss Fram" })
v436:AddButton({
	Name = "Cập Nhật Boss",
	Description = "Làm mới danh sách boss",
	Callback = function() end
})

local v581 = v436:AddParagraph({
	Title = "Boss Spawn Status",
	Content = "Initializing..."
})

task.spawn(function()
	while task.wait(1) do
		pcall(function()
			if _G.SelectBoss and (game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) or game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss)) then
				v581:Set("Status: Boss Spawn ✅")
			else
				v581:Set("Status: Boss Not Spawn ❌")
			end
		end)
	end
end)

local v582 = World1 and {
	"The Gorilla King",
	"Bobby",
	"Yeti",
	"Mob Leader",
	"Vice Admiral",
	"Warden",
	"Chief Warden",
	"Swan",
	"Magma Admiral",
	"Fishman Lord",
	"Wysper",
	"Thunder God",
	"Cyborg",
	"Saber Expert"
} or (World2 and {
	"Diamond",
	"Jeremy",
	"Fajita",
	"Don Swan",
	"Smoke Admiral",
	"Cursed Captain",
	"Darkbeard",
	"Order",
	"Awakened Ice Admiral",
	"Tide Keeper"
} or (World3 and {
	"",
	"Tyrant of the Skies",
	"Stone",
	"Island Empress",
	"Kilo Admiral",
	"Captain Elephant",
	"Beautiful Pirate",
	"rip_indra True Form",
	"Longma",
	"Soul Reaper",
	"Cake Queen"
} or {}))

v436:AddDropdown({
	Name = "Auto Select Boss",
	Description = "Chọn Boss Cần Farm",
	Options = v582,
	Default = v582[1],
	Callback = function(p68)
		_G.SelectBoss = p68
	end
})
v436:AddToggle({
	Name = "Farm Boss",
	Description = "Farm Boss Đã Chọn",
	Default = false,
	Callback = function(p69)
		_G.AutoBoss = p69
		StopTween(_G.AutoBoss)
	end
})
task.spawn(function()
	while task.wait() do
		if _G.AutoBoss and _G.SelectBoss then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == _G.SelectBoss and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
								topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
							until not _G.AutoBoss or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					if not game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) then
						return
					end

					topos(game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
				end
			end)
		end
	end
end)
v436:AddSection({ "Material" })

local v585 = World1 and {
	"Magma Ore",
	"Angel Wings",
	"Leather",
	"Scrap Metal"
} or (World2 and {
	"Radioactive",
	"Mystic Droplet",
	"Magma Ore",
	"Leather",
	"Ectoplasm",
	"Scrap Metal"
} or (World3 and {
	"Leather",
	"Scrap Metal",
	"Conjured Cocoa",
	"Dragon Scale",
	"Gunpowder",
	"Fish Tail",
	"Mini Tusk"
} or {}))

function getConfigMaterial(p70)
	if p70 == "Radioactive" and World2 then
		MaterialMon = { "Factory Staff" }
		MaterialPos = CFrame.new(-507.78, 73, -126.45)
	elseif p70 == "Mystic Droplet" and World2 then
		MaterialMon = { "Water Fighter" }
		MaterialPos = CFrame.new(-3352.9, 285.01, -10534.84)
	elseif p70 == "Magma Ore" and World1 then
		MaterialMon = { "Military Spy" }
		MaterialPos = CFrame.new(-5850.28, 77.28, 8848.67)
	elseif p70 == "Magma Ore" and World2 then
		MaterialMon = { "Lava Pirate" }
		MaterialPos = CFrame.new(-5234.6, 51.95, -4732.27)
	elseif p70 == "Angel Wings" and World1 then
		MaterialMon = { "Royal Soldier" }
		MaterialPos = CFrame.new(-7827.15, 5606.91, -1705.58)
	elseif p70 == "Leather" and World1 then
		MaterialMon = { "Pirate" }
		MaterialPos = CFrame.new(-1211.87, 4.78, 3916.83)
	elseif p70 == "Leather" and World2 then
		MaterialMon = { "Marine Captain" }
		MaterialPos = CFrame.new(-2010.5, 73, -3326.62)
	elseif p70 == "Leather" and World3 then
		MaterialMon = { "Jungle Pirate" }
		MaterialPos = CFrame.new(-11975.78, 331.77, -10620.03)
	elseif p70 == "Ectoplasm" and World2 then
		MaterialMon = {
			"Ship Deckhand",
			"Ship Engineer",
			"Ship Steward",
			"Ship Officer"
		}
		MaterialPos = CFrame.new(911.35, 125.95, 33159.53)
	elseif p70 == "Scrap Metal" and World1 then
		MaterialMon = { "Brute" }
		MaterialPos = CFrame.new(-1132.42, 14.84, 4293.3)
	elseif p70 == "Scrap Metal" and World2 then
		MaterialMon = { "Mercenary" }
		MaterialPos = CFrame.new(-972.3, 73.04, 1419.29)
	elseif p70 == "Scrap Metal" and World3 then
		MaterialMon = { "Pirate Millionaire" }
		MaterialPos = CFrame.new(-289.63, 43.82, 5583.66)
	elseif p70 == "Conjured Cocoa" and World3 then
		MaterialMon = { "Chocolate Bar Battler" }
		MaterialPos = CFrame.new(744.79, 24.76, -12637.72)
	elseif p70 == "Dragon Scale" and World3 then
		MaterialMon = { "Dragon Crew Warrior" }
		MaterialPos = CFrame.new(5824.06, 51.38, -1106.69)
	elseif p70 == "Gunpowder" and World3 then
		MaterialMon = { "Pistol Billionaire" }
		MaterialPos = CFrame.new(-379.61, 73.84, 5928.52)
	elseif p70 == "Fish Tail" and World3 then
		MaterialMon = { "Fishman Captain" }
		MaterialPos = CFrame.new(-10961.01, 331.79, -8914.29)
	else
		if not (p70 == "Mini Tusk" and World3) then
			return
		end

		MaterialMon = { "Mithological Pirate" }
		MaterialPos = CFrame.new(-13516.04, 469.81, -6899.16)
	end
end

v436:AddDropdown({
	Name = "Select Material",
	Description = "Chọn vật phẩm cần farm",
	Options = v585,
	Default = v585[1],
	Callback = function(p71)
		_G.SelectMaterial = p71
	end
})
v436:AddToggle({
	Name = "Start Farm",
	Description = "Tự động farm material đã chọn",
	Default = false,
	Callback = function(p72)
		_G.AutoFarmMaterial = p72
		StopTween(_G.AutoFarmMaterial)
	end
})
task.spawn(function()
	while task.wait(0.2) do
		if _G.AutoFarmMaterial and _G.SelectMaterial then
			pcall(function()
				getConfigMaterial(_G.SelectMaterial)

				for _, v in pairs(MaterialMon) do
					if workspace.Enemies:FindFirstChild(v) then
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if child.Name == v and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									PosMon = child.HumanoidRootPart.CFrame
									MonFarm = child.Name
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								until not _G.AutoFarmMaterial or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						UnEquipWeapon(_G.SelectWeapon)

						if _G.SelectMaterial == "Ectoplasm" and (MaterialPos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 18000 then
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21, 126.97, 32852.83))
						end

						topos(MaterialPos)
					end
				end
			end)
		end
	end
end)
v438:AddSection({ "Auto Fishing |  Tự Động Câu Cá" })
v438:AddToggle({
	Title = "Auto Fishing",
	Description = "Tự Động Câu Cá Xoá Hiệu Ứng Khi Câu",
	Default = false,
	Callback = function(p73)
		_G.AutoFishing = p73
	end
})

local _ = workspace
local LocalPlayer2 = game.Players.LocalPlayer
local FishReplicated = game.ReplicatedStorage:WaitForChild("FishReplicated")
local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
local MaxLaunchDistance = require(FishReplicated.FishingClient.Config).Rod.MaxLaunchDistance
local GetWaterHeightAtLocation = require(game.ReplicatedStorage.Util.GetWaterHeightAtLocation)

task.spawn(function()
	while task.wait() do
		if _G.AutoFishing then
			local Character = LocalPlayer2.Character
			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			local Tool_

			if Character then
				Tool_ = Character:FindFirstChildOfClass("Tool")
			else
				Tool_ = Character
			end

			local _GSelectedRod

			if _G.SelectedRod and (not Tool_ or Tool_.Name ~= _G.SelectedRod) then
				_GSelectedRod = LocalPlayer2.Backpack:FindFirstChild(_G.SelectedRod)

				if _GSelectedRod then
					LocalPlayer2.Character.Humanoid:EquipTool(_GSelectedRod)
				else
					_GSelectedRod = Tool_
				end
			else
				_GSelectedRod = Tool_
			end

			if Character and (HumanoidRootPart and _GSelectedRod) then
				local v600 = GetWaterHeightAtLocation(HumanoidRootPart.Position)
				local _, vector3 = workspace:FindPartOnRayWithIgnoreList(Ray.new(Character.Head.Position, HumanoidRootPart.CFrame.LookVector * MaxLaunchDistance), { Character, workspace.Characters, workspace.Enemies })

				if vector3 then
					vector3 = Vector3.new(vector3.X, math.max(vector3.Y, v600), vector3.Z)
				end

				local attribute = _GSelectedRod:GetAttribute("State")
				local attribute2 = _GSelectedRod:GetAttribute("ServerState")

				if (attribute == "ReeledIn" or attribute2 == "ReeledIn") and vector3 then
					FishingRequest:InvokeServer("StartCasting")
					task.wait()
					FishingRequest:InvokeServer("CastLineAtLocation", vector3, 100, true)
				elseif attribute2 == "Biting" then
					FishingRequest:InvokeServer("Catching", true)
					task.wait(0.1)
					FishingRequest:InvokeServer("Catch", 1)
				end
			end
		end
	end
end)
v438:AddDropdown({
	Name = "Select Fishing Lure",
	Description = "Tự Động Chọn Mồi Khi Câu Cá",
	Options = {
		"Basic Bait",
		"Kelp Bait",
		"Good Bait",
		"Abyssal Bait",
		"Frozen Bait",
		"Epic Bait",
		"Carnivore Bait"
	},
	Default = "Basic Bait",
	Callback = function(p74)
		_G.SelectedBait = p74
		FishingRequest:InvokeServer("SelectBait", p74)
	end
})
v438:AddDropdown({
	Name = "Select Fishing Rod",
	Description = "Tự Động Chọn Cần Câu Khi Câu Cá",
	Options = {
		"Fishing Rod",
		"Gold Rod",
		"Shark Rod",
		"Shell Rod",
		"Treasure Rod"
	},
	Default = "Fishing Rod",
	Callback = function(p75)
		_G.SelectedRod = p75
	end
})

if World1 then
	v440:AddSection({ "Quest Sea 1" })
	v440:AddToggle({
		Name = "AutoSecondSea",
		Description = "Tự động Auto Quest Sea 2",
		Default = false,
		Callback = function(p76)
			_G.AutoSecondSea = p76
			StopTween(_G.AutoSecondSea)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoSecondSea then
				pcall(function()
					if game.Players.LocalPlayer.Data.Level.Value < 700 or not World1 then
						return
					end

					_G.AutoFarm = false

					if game.Workspace.Map.Ice.Door.CanCollide ~= true or game.Workspace.Map.Ice.Door.Transparency ~= 0 then
						if game.Workspace.Map.Ice.Door.CanCollide ~= false or game.Workspace.Map.Ice.Door.Transparency ~= 1 then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
						elseif game:GetService("Workspace").Enemies:FindFirstChild("Ice Admiral") then
							for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if child.Name == "Ice Admiral" and child.Humanoid.Health > 0 then
									repeat
										wait()
										AutoHaki()
										EquipWeapon(_G.SelectWeapon)
										child.HumanoidRootPart.CanCollide = false
										StartBring = true
										child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
										child.HumanoidRootPart.Transparency = 1
										topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
										game:GetService("VirtualUser"):CaptureController()
										game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 870), workspace.CurrentCamera.CFrame)
									until child.Humanoid.Health <= 0 or not (child.Parent and _G.AutoSecondSea)

									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
								end
							end
						else
							topos(CFrame.new(1347.7124, 37.3751602, -1325.6488))
						end
					else
						repeat
							wait()
							topos(CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563))
						until (CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoSecondSea

						wait(1)
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
						EquipWeapon("Key")

						local cFrame3 = CFrame.new(1347.7124, 37.3751602, -1325.6488)

						repeat
							wait()
							topos(cFrame3)
						until (cFrame3.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoSecondSea

						wait(3)
					end
				end)
			end
		end
	end)
	v440:AddSection({ "Boss Greybeard" })
	v440:AddToggle({
		Name = "Kill Greybeard",
		Description = "Tự động Đánh Greybeard",
		Default = false,
		Callback = function(p77)
			_G.Greybeard = p77
			StopTween(_G.Greybeard)
		end
	})
	spawn(function()
		while wait() do
			if _G.Greybeard then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Greybeard") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Greybeard" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
									sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
								until not _G.Greybeard or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						topos(CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375))

						if game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard") then
							topos(game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
						else
							if not _G.Greybeardhop then
								return
							end

							Hop()
						end
					end
				end)
			end
		end
	end)
	v440:AddSection({ "Quest Sword" })
	v440:AddToggle({
		Name = "Auto Get Saber",
		Description = "Tự động Lấy Kiếm Saber",
		Default = false,
		Callback = function(p78)
			_G.AutoSaber = p78
			StopTween(_G.AutoSaber)
		end
	})
	spawn(function()
		while task.wait() do
			if _G.AutoSaber and game.Players.LocalPlayer.Data.Level.Value >= 200 then
				pcall(function()
					if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency == 0 then
						if game:GetService("Workspace").Map.Jungle.QuestPlates.Door.Transparency ~= 0 then
							if game:GetService("Workspace").Map.Desert.Burn.Part.Transparency ~= 0 then
								if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") == 0 then
									if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") ~= "RichSon" then
										if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 0 then
											if not (game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") or game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader")) then
												return
											end

											topos(CFrame.new(-2967.59521, -4.91089821, 5328.70703, 0.342208564, -0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, -0.939287126, 0.0184739735, 0.342634559))

											for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
												if child.Name == "Mob Leader" then
													if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
														repeat
															task.wait()
															AutoHaki()
															EquipWeapon(_G.SelectWeapon)
															child.HumanoidRootPart.CanCollide = false
															child.Humanoid.WalkSpeed = 0
															child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
															topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
															game:GetService("VirtualUser"):CaptureController()
															game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
															sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
														until child.Humanoid.Health <= 0 or not _G.AutoSaber
													end

													if game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader [Lv. 120] [Boss]") then
														topos(game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader [Lv. 120] [Boss]").HumanoidRootPart.CFrame * Farm_Mode)
													end
												end
											end
										else
											if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") ~= 1 then
												return
											end

											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
											wait(0.5)
											EquipWeapon("Relic")
											wait(0.5)
											topos(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-9, 0.481375456, 2.53851997e-8, 1, -5.79995607e-8, -0.481375456, 6.30572643e-8, 0.876514494))
										end
									else
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
									end
								else
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
									wait(0.5)
									EquipWeapon("Cup")
									wait(0.5)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", game:GetService("Players").LocalPlayer.Character.Cup)
									wait(0)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
								end
							elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
								EquipWeapon("Torch")
								topos(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-9, 0.761243105, -5.70652914e-10, 1, 1.20584542e-9, -0.761243105, 3.47544882e-10, -0.648466587))
							else
								topos(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 0.0000342372805, -0.258850515, 0.965917408))
							end
						elseif (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-9, -0.928667724, 3.97099491e-8, 1, 1.91679348e-8, 0.928667724, -4.39869794e-8, 0.37091279).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
							topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
							wait(1)
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate1.Button.CFrame
							wait(1)
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate2.Button.CFrame
							wait(1)
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate3.Button.CFrame
							wait(1)
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate4.Button.CFrame
							wait(1)
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate5.Button.CFrame
							wait(1)
						else
							topos(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-9, -0.928667724, 3.97099491e-8, 1, 1.91679348e-8, 0.928667724, -4.39869794e-8, 0.37091279))
						end
					else
						if not (game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert") or game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert")) then
							return
						end

						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and (child.Humanoid.Health > 0 and child.Name == "Saber Expert")) then
								repeat
									task.wait()
									EquipWeapon(_G.SelectWeapon)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
									child.HumanoidRootPart.Transparency = 1
									child.Humanoid.JumpPower = 0
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.CanCollide = false
									FarmPos = child.HumanoidRootPart.CFrame
									MonFarm = child.Name
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672), workspace.CurrentCamera.CFrame)
								until child.Humanoid.Health <= 0 or not _G.AutoSaber

								if child.Humanoid.Health <= 0 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
								end
							end
						end
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Pole",
		Description = "Tự động Lấy Kiếm Pole",
		Default = false,
		Callback = function(p79)
			_G.Autopole = p79
			StopTween(_G.Autopole)
		end
	})
	spawn(function()
		while wait() do
			if _G.Autopole then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Thunder God") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Thunder God" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.Autopole or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Saw",
		Description = "Tự động Lấy Kiếm Saw",
		Default = false,
		Callback = function(p80)
			_G.Autosaw = p80
			StopTween(_G.Autosaw)
		end
	})

	local cFrame3 = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094)

	spawn(function()
		while wait() do
			if _G.Autosaw then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("The Saw") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "The Saw" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait(_G.FastAttackDelay)
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									AttackNoCD()
								until not _G.Autosaw or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if BypassTP then
							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cFrame3.Position).Magnitude <= 1500 then
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cFrame3.Position).Magnitude < 1500 then
									topos(cFrame3)
								end
							else
								BTP(cFrame3)
							end
						else
							topos(cFrame3)
						end

						EquipWeapon(_G.SelectWeapon)
						topos(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))

						if not game:GetService("ReplicatedStorage"):FindFirstChild("The Saw") then
							return
						end

						topos(game:GetService("ReplicatedStorage"):FindFirstChild("The Saw").HumanoidRootPart.CFrame * CFrame.new(2, 40, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Wardens",
		Description = "Tự động Lấy Kiếm Wardens",
		Default = false,
		Callback = function(p81)
			_G.ChiefWarden = p81
			StopTween(_G.ChiefWarden)
		end
	})
	spawn(function()
		while wait() do
			if _G.ChiefWarden then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Chief Warden") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Chief Warden" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.ChiefWarden or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Trident",
		Description = "Tự động Lấy Kiếm Trident",
		Default = false,
		Callback = function(p82)
			_G.Trident = p82
			StopTween(_G.Trident)
		end
	})
	spawn(function()
		while wait() do
			if _G.Trident then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Fishman Lord") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Fishman Lord" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.Trident or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Lord") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Lord").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
end

if World2 then
	v440:AddSection({ "Quest Sea 2" })
	v440:AddToggle({
		Name = "Auto Quest Sea Bartilo",
		Description = "Tự động Làm Nhiệm Vụ Sea Bartilo",
		Default = false,
		Callback = function(p83)
			_G.AutoBartilo = p83
			StopTween(_G.AutoBartilo)
		end
	})
	spawn(function()
		pcall(function()
			while true do
				if not wait(0.1) then
					return
				end

				if not _G.AutoBartilo then
					continue
				end

				if game:GetService("Players").LocalPlayer.Data.Level.Value < 800 or game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 0 then
					if game:GetService("Players").LocalPlayer.Data.Level.Value < 800 or game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 1 then
						if game:GetService("Players").LocalPlayer.Data.Level.Value < 800 or game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 2 then
							continue
						end

						repeat
							topos(CFrame.new(-1850.49329, 13.1789551, 1750.89685))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1850.49329, 13.1789551, 1750.89685)).Magnitude <= 10

						wait(1)

						repeat
							topos(CFrame.new(-1858.87305, 19.3777466, 1712.01807))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1858.87305, 19.3777466, 1712.01807)).Magnitude <= 10

						wait(1)

						repeat
							topos(CFrame.new(-1803.94324, 16.5789185, 1750.89685))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1803.94324, 16.5789185, 1750.89685)).Magnitude <= 10

						wait(1)

						repeat
							topos(CFrame.new(-1858.55835, 16.8604317, 1724.79541))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1858.55835, 16.8604317, 1724.79541)).Magnitude <= 10

						wait(1)

						repeat
							topos(CFrame.new(-1869.54224, 15.987854, 1681.00659))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1869.54224, 15.987854, 1681.00659)).Magnitude <= 10

						wait(1)

						repeat
							topos(CFrame.new(-1800.0979, 16.4978027, 1684.52368))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1800.0979, 16.4978027, 1684.52368)).Magnitude <= 10

						wait(1)

						repeat
							topos(CFrame.new(-1819.26343, 14.795166, 1717.90625))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1819.26343, 14.795166, 1717.90625)).Magnitude <= 10

						wait(1)
						topos(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
						wait()

						if not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1813.51843, 14.8604736, 1724.79541)).Magnitude <= 10 then
							continue
						end
					end

					if game:GetService("Workspace").Enemies:FindFirstChild("Jeremy") then
						Ms = "Jeremy"

						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == Ms then
								OldCFrameBartlio = child.HumanoidRootPart.CFrame

								repeat
									task.wait()
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
									EquipWeapon(_G.SelectWeapon)
									AutoHaki()
									child.HumanoidRootPart.Transparency = 1
									child.HumanoidRootPart.CanCollide = false
									child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									child.HumanoidRootPart.CFrame = OldCFrameBartlio
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not child.Parent or (child.Humanoid.Health <= 0 or _G.AutoBartilo == false)
							end
						end
					elseif game:GetService("ReplicatedStorage"):FindFirstChild("Jeremy") then
						repeat
							topos(CFrame.new(-456.28952, 73.0200958, 299.895966))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10

						wait(1.1)
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
						wait(1)

						repeat
							topos(CFrame.new(2099.88159, 448.931, 648.997375))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10

						wait(2)
					else
						repeat
							topos(CFrame.new(2099.88159, 448.931, 648.997375))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10
					end

					continue
				else
					if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true) then
						if game:GetService("Workspace").Enemies:FindFirstChild("Swan Pirate") then
							Ms = "Swan Pirate"

							for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if child.Name == Ms then
									pcall(function()
										repeat
											task.wait()
											sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
											EquipWeapon(_G.SelectWeapon)
											AutoHaki()
											child.HumanoidRootPart.Transparency = 1
											child.HumanoidRootPart.CanCollide = false
											child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
											topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
											PosMonBarto = child.HumanoidRootPart.CFrame
											game:GetService("VirtualUser"):CaptureController()
											game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
											StartBring = true
										until not child.Parent or (child.Humanoid.Health <= 0 or _G.AutoBartilo == false) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false

										StartBring = false
									end)
								end
							end
						else
							repeat
								topos(CFrame.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119e-8, -0.230443969, 2.67024713e-8, 1, 8.47491108e-8, 0.230443969, 7.63147128e-8, -0.973085582))
								wait()
							until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119e-8, -0.230443969, 2.67024713e-8, 1, 8.47491108e-8, 0.230443969, 7.63147128e-8, -0.973085582)).Magnitude <= 10
						end
					else
						repeat
							topos(CFrame.new(-456.28952, 73.0200958, 299.895966))
							wait()
						until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10

						wait(1.1)
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
					end

					continue
				end
			end
		end)
	end)
	v440:AddToggle({
		Name = "Auto Quest Sea 3",
		Description = "Tự động Làm Nhiệm Vụ Sang Sea 3",
		Default = false,
		Callback = function(p84)
			_G.ThirdSea = p84
			StopTween(_G.ThirdSea)
		end
	})
	spawn(function()
		while wait() do
			if _G.ThirdSea then
				pcall(function()
					if game:GetService("Players").LocalPlayer.Data.Level.Value < 1500 or not World2 then
						return
					end

					_G.AutoFarm = false

					if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "General") ~= 0 then
						return
					end

					topos(CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016))

					if (CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
						wait(1.5)
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
					end

					wait(1.8)

					if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "rip_indra" then
								OldCFrameThird = child.HumanoidRootPart.CFrame

								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									child.HumanoidRootPart.CFrame = OldCFrameThird
									child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until _G.ThirdSea == false or (child.Humanoid.Health <= 0 or not child.Parent)
							end
						end
					else
						if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") or (CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
							return
						end

						TP1(CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016))
					end
				end)
			end
		end
	end)
	v440:AddSection({ "Factory Sea 2" })
	v440:AddToggle({
		Name = "Auto Factory",
		Description = "Tự động Đánh Nhà Máy",
		Default = false,
		Callback = function(p85)
			_G.AutoFactory = p85
			StopTween(_G.AutoFactory)
		end
	})
	spawn(function()
		while wait() do
			spawn(function()
				if not _G.AutoFactory then
					return
				end

				if game:GetService("Workspace").Enemies:FindFirstChild("Core") then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == "Core" and child.Humanoid.Health > 0 then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								topos(CFrame.new(448.46756, 199.356781, -441.389252))
								game:GetService("VirtualUser"):CaptureController()
								game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
							until child.Humanoid.Health <= 0 or _G.AutoFactory == false
						end
					end
				else
					topos(CFrame.new(448.46756, 199.356781, -441.389252))
				end
			end)
		end
	end)
	v440:AddSection({ "Boss Dark Beard" })
	v440:AddToggle({
		Name = "Auto Kill Dark Beard",
		Description = "Tự động Đánh Râu Đen",
		Default = false,
		Callback = function(p86)
			_G.AutoDarkBoss = p86
			StopTween(_G.AutoDarkBoss)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoDarkBoss then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Darkbeard") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Darkbeard" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									NeedAttacking = true
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.AutoDarkBoss or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						NeedAttacking = true

						if not game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard") then
							return
						end

						topos(game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Kill Cursed Captain",
		Description = "Tự động Đánh Cursed Captain",
		Default = false,
		Callback = function(p87)
			_G.CursedCaptain = p87
			StopTween(_G.CursedCaptain)
		end
	})
	spawn(function()
		while wait() do
			if _G.CursedCaptain then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Captain") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Cursed Captain" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									NeedAttacking = true
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									child.Humanoid.WalkSpeed = 0
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.CursedCaptain or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						NeedAttacking = true

						if (Vector3.new(911.35827636719, 125.95812988281, 33159.5390625) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 18000 or not game:GetService("ReplicatedStorage"):FindFirstChild("Cursed Captain") then
							return
						end

						topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cursed Captain").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddSection({ "Auto Buy Haki Màu" })
	v440:AddToggle({
		Name = "Auto Buy Haki Colors",
		Description = "Tự động Mua Haki",
		Default = false,
		Callback = function(p88)
			_G.AutoBuyEnchancementColour = p88
			StopTween(_G.AutoBuyEnchancementColour)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoBuyEnchancementColour then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "ColorsDealer", "2" }))
			end
		end
	end)
	v440:AddToggle({
		Title = "Auto Buy Legendary Sword",
		Value = false,
		Callback = function(p89)
			_G.AutoBuyLegendarySword = p89
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoBuyLegendarySword then
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LegendarySwordDealer", "1" }))
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LegendarySwordDealer", "2" }))
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LegendarySwordDealer", "3" }))
				end)
			end
		end
	end)
	v440:AddSection({ "Quest Sword" })
	v440:AddToggle({
		Name = "Auto Get Longsword",
		Description = "Tự động Get Longsword",
		Default = false,
		Callback = function(p90)
			_G.Longsword = p90
			StopTween(_G.Longsword)
		end
	})
	spawn(function()
		while wait() do
			if _G.Longsword then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Diamond") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Diamond" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.Longsword or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Diamond") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Diamond").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Gravity Blade",
		Description = "Tự động Lấy Gravity Blade",
		Default = false,
		Callback = function(p91)
			_G.GravityBlade = p91
			StopTween(_G.GravityBlade)
		end
	})
	spawn(function()
		while wait() do
			if _G.GravityBlade then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Fajita") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Fajita" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.GravityBlade or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Fajita") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Fajita").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Flail",
		Description = "Tự động Lấy Flail",
		Default = false,
		Callback = function(p92)
			_G.SwodsFlail = p92
			StopTween(_G.SwodsFlail)
		end
	})
	spawn(function()
		while wait() do
			if _G.SwodsFlail then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Smoke Admiral") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Smoke Admiral" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.SwodsFlail or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Smoke Admiral") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Smoke Admiral").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Rengoku",
		Description = "Tự động Lấy Rengoku",
		Default = false,
		Callback = function(p93)
			_G.AutoRengoku = p93
			StopTween(_G.AutoRengoku)
		end
	})
	spawn(function()
		pcall(function()
			while wait() do
				if _G.AutoRengoku then
					if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hidden Key") then
						EquipWeapon("Hidden Key")
						topos(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
					elseif game:GetService("Workspace").Enemies:FindFirstChild("Awakened Ice Admiral") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Awakened Ice Admiral" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									EquipWeapon(_G.SelectWeapon)
									AutoHaki()
									child.HumanoidRootPart.CanCollide = false
									child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									PosMon = child.HumanoidRootPart.CFrame
									MonFarm = child.Name
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									AttackNoCD()
									StartBring = true
								until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or (_G.AutoRengoku == false or (not child.Parent or child.Humanoid.Health <= 0))

								StartBring = false
							end
						end
					else
						StartBring = false
						topos(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
					end
				end
			end
		end)
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Dragon Trident",
		Description = "Tự động Lấy Dragon Trident",
		Default = false,
		Callback = function(p94)
			_G.SwodsDRTrident = p94
			StopTween(_G.SwodsDRTrident)
		end
	})
	spawn(function()
		while wait() do
			if _G.SwodsDRTrident then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Tide Keeper") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Tide Keeper" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.SwodsDRTrident or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
end

if World3 then
	v440:AddSection({ "Quest Sea 3" })
	v440:AddSection({ "Boss Rip indra" })
	v440:AddToggle({
		Name = "Auto kill Rip Indra",
		Description = "Tự động Đánh Rip Indra",
		Default = false,
		Callback = function(p95)
			_G.RipIndraKill = p95
			StopTween(_G.RipIndraKill)
		end
	})

	local cFrame3 = CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781)

	spawn(function()
		pcall(function()
			while wait() do
				if _G.RipIndraKill then
					if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra True Form") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							local Name = child.Name
							local s2 = "rip_indra True Form"

							if not s2 then
								local _ = child.Name == "rip_indra"

								s2 = true
							end

							if Name == s2 and (child.Humanoid.Health > 0 and (child:IsA("Model") and (child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart")))) then
								repeat
									task.wait()
									pcall(function()
										AutoHaki()
										EquipWeapon(_G.SelectWeapon)
										child.HumanoidRootPart.CanCollide = false
										child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
										topos(child.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
										game:GetService("VirtualUser"):CaptureController()
										game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670), workspace.CurrentCamera.CFrame)
									end)
								until _G.RipIndraKill == false or child.Humanoid.Health <= 0
							end
						end
					else
						if BypassTP then
							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cFrame3.Position).Magnitude <= 1500 then
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cFrame3.Position).Magnitude < 1500 then
									TP1(cFrame3)
								end
							else
								TP1(cFrame3)
							end
						else
							TP1(cFrame3)
						end

						TP1(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
					end
				end
			end
		end)
	end)
	v440:AddToggle({
		Name = "Auto Haki Colors",
		Description = "Tự Động Haki Colors",
		Default = false,
		Callback = function(p96)
			_G.RipIndraKill = p96
			StopTween(_G.RipIndraKill)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoBuyEnchancementColour then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "ColorsDealer", "2" }))
			end
		end
	end)
	v440:AddSection({ "Quest Skull Guitar" })
	v440:AddToggle({
		Name = "Auto Skull Guitar",
		Description = "Tự Động Lấy Đàn GuiTar",
		Default = false,
		Callback = function(p97)
			_G.AutoSkullGuitar = p97
			StopTween(_G.AutoSkullGuitar)
		end
	})
	spawn(function()
		while task.wait() do
			if getgenv().AutoSkullGuitar then
				pcall(function()
					if GetWeaponInventory("Skull Guitar") then
						if string.find(game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2), "Error") then
							topos(CFrame.new(-8653.206, 140.985, 6160.033))
						elseif string.find(game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2), "Nothing") then
							topos("Wait Full Moon")
						else
							game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("gravestoneEvent", 2, true)
						end
					else
						local LocalPlayer3 = game:GetService("Players").LocalPlayer
						local Character = LocalPlayer3.Character

						if Character then
							Character = LocalPlayer3.Character:FindFirstChild("HumanoidRootPart")
						end

						if not (Character and (Vector3.new(-9681.458, 6.139, 6341.372) - Character.Position).Magnitude <= 5000) then
							return
						end

						if game:GetService("Workspace").NPCs:FindFirstChild("Skeleton Machine") then
							game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("soulGuitarBuy", true)
						else
							local HauntedCastle = game:GetService("Workspace").Map:FindFirstChild("Haunted Castle")

							if HauntedCastle and HauntedCastle.Candle1.Transparency == 0 then
								local Placard1 = HauntedCastle:FindFirstChild("Placard1")

								if not (Placard1 and Placard1.Left.Part.Transparency == 0) then
									return
								end

								Quest2 = true
								topos(CFrame.new(-8762.691, 176.847, 6171.308))
								task.wait(1)

								for i = 7, 1, -1 do
									local v656 = HauntedCastle:FindFirstChild("Placard" .. i)

									if v656 then
										if v656:FindFirstChild("Left") then
											if v656.Left:FindFirstChild("ClickDetector") then
												fireclickdetector(v656.Left.ClickDetector)
												task.wait(0.5)
											end
										end
									end
								end
							elseif HauntedCastle and HauntedCastle.Tablet and HauntedCastle.Tablet:FindFirstChild("Segment1") then
								local LabPuzzle = HauntedCastle:FindFirstChild("Lab Puzzle")

								if LabPuzzle and LabPuzzle.ColorFloor.Model.Part1:FindFirstChild("ClickDetector") then
									Quest4 = true
									topos(CFrame.new(-9553.599, 65.623, 6041.588))
									task.wait(1)

									for _, v in ipairs({
										3,
										4,
										4,
										4,
										6,
										6,
										8,
										10,
										10,
										10
									}) do
										local v660 = LabPuzzle.ColorFloor.Model:FindFirstChild("Part" .. v)

										if v660 and v660:FindFirstChild("ClickDetector") then
											topos(v660.CFrame)
											task.wait(1)
											fireclickdetector(v660.ClickDetector)
											task.wait(0.5)
										end
									end
								else
									Quest3 = true
								end
							else
								if game:GetService("Workspace").NPCs:FindFirstChild("Ghost") then
									game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("GuitarPuzzleProgress", "Ghost")
								end

								local Enemies = game.Workspace:FindFirstChild("Enemies")

								if Enemies and Enemies:FindFirstChild("Living Zombie") then
									for _, child in pairs(Enemies:GetChildren()) do
										if child:FindFirstChild("HumanoidRootPart") and (child:FindFirstChild("Humanoid") and (child.Humanoid.Health > 0 and child.Name == "Living Zombie")) then
											AutoHaki()
											EquipWeapon(getgenv().SelectWeapon)
											child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
											child.HumanoidRootPart.Transparency = 1
											child.Humanoid.JumpPower = 0
											child.Humanoid.WalkSpeed = 0
											child.HumanoidRootPart.CanCollide = false
											child.HumanoidRootPart.CFrame = Character.CFrame * CFrame.new(0, 20, 0)
											topos(CFrame.new(-10160.787, 138.662, 5955.031))
											task.wait(0.5)

											local VirtualUser = game:GetService("VirtualUser")

											VirtualUser:CaptureController()
											VirtualUser:Button1Down(Vector2.new(1280, 672))
										end
									end
								else
									topos(CFrame.new(-10160.787, 138.662, 5955.031))
								end
							end
						end
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Kill Elite Hunter",
		Description = "Tự Động Đánh Elite Hunter",
		Default = false,
		Callback = function(p98)
			_G.AutoElitehunter = p98
			StopTween(_G.AutoElitehunter)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoElitehunter and World3 then
				pcall(function()
					if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
						if _G.AutoEliteHunterHop and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter") == "I don\'t have anything for you right now. Come back later." then
							Hop()
						else
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
						end
					else
						if not (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban"))) then
							return
						end

						if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or (game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) then
							for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if (child.Name == "Diablo" or (child.Name == "Deandre" or child.Name == "Urban")) and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
									repeat
										wait()
										AutoHaki()
										EquipWeapon(_G.SelectWeapon)
										NeedAttacking = true
										StartBring = true
										child.HumanoidRootPart.CanCollide = false
										child.Humanoid.WalkSpeed = 0
										topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
										game:GetService("VirtualUser"):CaptureController()
										game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
										sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
									until _G.AutoElitehunter == false or (child.Humanoid.Health <= 0 or not child.Parent)
								end
							end
						else
							NeedAttacking = false

							if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
								TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
								TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							else
								if not game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
									return
								end

								TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							end
						end
					end
				end)
			end
		end
	end)
	v440:AddSection({ "Auto CDK" })
	v440:AddToggle({
		Name = "Auto Cdk [Beta]",
		Description = "Tự Động Lấy Xong Kiếm Ô Đen",
		Default = false,
		Callback = function(p99)
			_G.AutoGetCDK = p99
			StopTween(_G.AutoGetCDK)
		end
	})
	task.spawn(function()
		repeat
			task.wait()
		until getgenv().AutoGetCDK

		local LocalPlayer3 = game.Players.LocalPlayer
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Workspace = game:GetService("Workspace")
		local Enemies = Workspace.Enemies
		local u671 = false

		while getgenv().AutoGetCDK do
			task.wait(0.2)
			pcall(function()
				ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
				task.wait(0.2)
				ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
				task.wait(0.2)
				ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Boss")
				task.wait(0.2)

				if Enemies:FindFirstChild("Cursed Skeleton Boss") then
					local v672 = Enemies

					for _, child in pairs(v672:GetChildren()) do
						if child.Name == "Cursed Skeleton Boss" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							local Character = LocalPlayer3.Character
							local Backpack = LocalPlayer3.Backpack

							if Character:FindFirstChild("Yama") or Backpack:FindFirstChild("Yama") then
								EquipWeapon("Yama")
							elseif Character:FindFirstChild("Tushita") or Backpack:FindFirstChild("Tushita") then
								EquipWeapon("Tushita")
							elseif not u671 then
								game.StarterGui:SetCore("SendNotification", {
									Title = "Dum Hub",
									Text = "Use! - Yama or Tushita",
									con = "rbxassetid://80424431930361",
									Duration = 10
								})
								u671 = true
							end

							Buso()
							child.HumanoidRootPart.CanCollide = false
							child.Humanoid.WalkSpeed = 0
							topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

							if syn and not getgenv().SimulationSet then
								sethiddenproperty(LocalPlayer3, "SimulationRadius", math.huge)
								getgenv().SimulationSet = true
							end

							repeat
								task.wait()
							until not getgenv().AutoGetCDK or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					topos(CFrame.new(-12318.193, 601.951, -6538.662))
					task.wait(0.5)
					topos(Workspace.Map.Turtle.Cursed.BossDoor.CFrame)
				end
			end)
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Yama",
		Description = "Tự Động Lấy Kiếm Yama",
		Default = false,
		Callback = function(p100)
			_G.AutoYama = p100
			StopTween(_G.AutoYama)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoYama and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress") >= 30 then
				wait()
				fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)

				if not (game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") or not _G.AutoYama) then
					return
				end
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Holy Torch Tushita",
		Description = "Tự Động Torch Tushita",
		Default = false,
		Callback = function(p101)
			_G.AutoHolyTorch = p101
			StopTween(_G.AutoHolyTorch)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoHolyTorch then
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625))
					wait(1)
					topos(CFrame.new(5711.87451171875, 45.82802963256836, 254.17005920410156))
					wait(15)
					EquipWeapon("Holy Torch")

					repeat
						topos(CFrame.new(-10752, 417, -9366))
						wait()
					until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-10752, 417, -9366)).Magnitude <= 10

					wait(1)

					repeat
						topos(CFrame.new(-11672, 334, -9474))
						wait()
					until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-11672, 334, -9474)).Magnitude <= 10

					wait(1)

					repeat
						topos(CFrame.new(-12132, 521, -10655))
						wait()
					until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-12132, 521, -10655)).Magnitude <= 10

					wait(1)

					repeat
						topos(CFrame.new(-13336, 486, -6985))
						wait()
					until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-13336, 486, -6985)).Magnitude <= 10

					wait(1)

					repeat
						topos(CFrame.new(-13489, 332, -7925))
						wait()
					until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-13489, 332, -7925)).Magnitude <= 10
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Tushita",
		Description = "Tự Động Lấy Tushita",
		Default = false,
		Callback = function(p102)
			_G.AutoGetTushita = p102
			StopTween(_G.AutoGetTushita)
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoGetTushita then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Longma") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Longma" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.AutoGetTushita or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Longma") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddSection({ "Quest Sword" })
	v440:AddToggle({
		Name = "Auto Get Sword Twin Hooks",
		Description = "Tự Động Lấy Kiếm Twin Hooks",
		Default = false,
		Callback = function(p103)
			_G.SwodTwinHooks = p103
			StopTween(_G.SwodTwinHooks)
		end
	})
	spawn(function()
		while wait() do
			if _G.SwodTwinHooks then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Captain Elephant" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.SwodTwinHooks or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Canvander",
		Description = "Tự Động Lấy Kiếm Canvander",
		Default = false,
		Callback = function(p104)
			_G.SwodCanvander = p104
			StopTween(_G.SwodCanvander)
		end
	})
	spawn(function()
		while wait() do
			if _G.SwodCanvander then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Beautiful Pirate" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.SwodCanvander or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
	v440:AddToggle({
		Name = "Auto Get Sword Buddy",
		Description = "Tự Động Lấy Kiếm Buddy",
		Default = false,
		Callback = function(p105)
			_G.SwodsBuddy = p105
			StopTween(_G.SwodsBuddy)
		end
	})
	spawn(function()
		while wait() do
			if _G.SwodsBuddy then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == "Cake Queen" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
								repeat
									task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									child.HumanoidRootPart.CanCollide = false
									StartBring = true
									child.Humanoid.WalkSpeed = 0
									child.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
									sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
								until not _G.SwodsBuddy or (not child.Parent or child.Humanoid.Health <= 0)
							end
						end
					else
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen") then
							return
						end

						TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
					end
				end)
			end
		end
	end)
end

v442:AddButton({
	Title = "Tween Dragon Dojo",
	Value = false,
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.53, 1013.09, -334.96))
		topos(CFrame.new(5841.29, 1208.32, 884.31))
	end
})
v442:AddToggle({
	Name = "Auto Dragon Huntery",
	Description = "Tự Động Farm Blaze",
	Default = false,
	Callback = function(p106)
		_G.FarmBlazeEM = p106
		StopTween(_G.FarmBlazeEM)
	end
})

function checkQuesta()
	local t11 = {
		{
			Context = "Check"
		}
	}
	local response = nil

	pcall(function()
		local t12 = {
			{
				Context = "RequestQuest"
			}
		}

		game:GetService("ReplicatedStorage").Modules.Net["RF/DragonHunter"]:InvokeServer(unpack(t12))
	end)

	local _ = pcall(function()
		response = game:GetService("ReplicatedStorage").Modules.Net["RF/DragonHunter"]:InvokeServer(unpack(t11))
	end)
	local v690 = nil
	local v691 = nil
	local v692 = nil
	local v693, v694

	if response and response.Text then
		v693 = true

		local Text = response.Text

		if string.find(Text, "Defeat") then
			v691 = tonumber(string.sub(Text, 8, 9))

			local v696, v697, v698 = pairs({ "Hydra Enforcer", "Venomous Assailant" })

			v692 = 1

			while true do
				v698, v694 = v696(v697, v698)

				if v698 == nil then
					break
				end

				if string.find(Text, v694) then
					return v693, v694, v691, v692
				end
			end

			v694 = v690
		elseif string.find(Text, "Destroy") then
			v694 = v690
			v691 = 10
			v692 = 2
		else
			v694 = v690
		end
	else
		v694 = v690
		v693 = false
	end

	return v693, v694, v691, v692
end
function BackTODoJo()
	for _, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications:GetChildren()) do
		if not (child.Name ~= "NotificationTemplate" or not string.find(child.Text, "Head back to the Dojo to complete more tasks")) then
			return true
		end
	end

	return false
end
function DragonMobClear(p107, p108, p109)
	if workspace.Enemies:FindFirstChild(p108) then
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == p108 and (Attack.Alive(child) and p107) then
				Attack.Kill(child, p107)
			end
		end
	else
		if not p109 then
			return
		end

		topos(p109)
	end
end

spawn(function()
	while task.wait() do
		if _G.FarmBlazeEM then
			pcall(function()
				local v703, v704, _, v706 = checkQuesta()

				if v703 and not BackTODoJo() then
					if v706 ~= 1 then
						local MeshesBambootree = v706 == 2 and workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true)

						if not MeshesBambootree then
							return
						end

						while true do
							task.wait()
							spawn(function()
								topos(MeshesBambootree.CFrame * CFrame.new(4, 0, 0))
							end)

							if (MeshesBambootree.Position - Root.Position).Magnitude <= 200 then
								MousePos = MeshesBambootree.Position
								Useskills("Melee", "Z")
								Useskills("Melee", "X")
								Useskills("Melee", "C")
								task.wait(0.5)
								Useskills("Sword", "Z")
								Useskills("Sword", "X")
								task.wait(0.5)
								Useskills("Blox Fruit", "Z")
								Useskills("Blox Fruit", "X")
								Useskills("Blox Fruit", "C")
								task.wait(0.5)
								Useskills("Gun", "Z")
								Useskills("Gun", "X")
							end

							if not (_G.FarmBlazeEM and (v703 and not BackTODoJo())) then
								return
							end
						end
					end

					if not (v704 == "Hydra Enforcer" or v704 == "Venomous Assailant") then
						return
					end

					repeat
						task.wait()
						DragonMobClear(true, v704, CFrame.new(4620.61, 1002.29, 399.08))
					until not _G.FarmBlazeEM or (not v703 or BackTODoJo())
				else
					topos(CFrame.new(5813, 1208, 884))
					DragonMobClear(false, nil, nil)
				end
			end)
		end
	end
end)
spawn(function()
	while task.wait(0.1) do
		if _G.FarmBlazeEM then
			pcall(function()
				if not (workspace:FindFirstChild("EmberTemplate") and workspace.EmberTemplate:FindFirstChild("Part")) then
					return
				end

				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.EmberTemplate.Part.CFrame
			end)
		end
	end
end)
v442:AddSection({ "Volcanic Island" })
v442:AddButton({
	Title = "Craft Volcanic Magnet",
	Value = false,
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "CraftItem", "Craft", "Volcanic Magnet" }))
	end
})

local v708 = v442:AddParagraph({
	Title = "Check Prehistoric Island",
	Content = "Loading..."
})

task.spawn(function()
	while task.wait(1) do
		pcall(function()
			if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
				v708:Set("Prehistoric Island Spawning ✅")
			else
				v708:Set("Prehistoric Island Not Spawn ❌")
			end
		end)
	end
end)
v442:AddToggle({
	Name = "Auto Find Prehistoric",
	Description = "Tự Động Tìm Đảo Thời Tiền Sử ( Đảo Núi Lửa )",
	Default = false,
	Callback = function(p110)
		_G.Nocliprock = p110
		StopTween(_G.Nocliprock)
	end
})

local t13 = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local maxSpeed = 350

RunService.RenderStepped:Connect(function()
	for k, v in pairs(t13) do
		if v and (v.Parent and (v.Name == "VehicleSeat" and not v.Occupant)) then
			t13[k] = v
		end
	end
end)

local u717 = false
local u718 = false

RunService.RenderStepped:Connect(function()
	if not _G.AutoFindPrehistoric then
		u718 = false

		return
	end

	local Character = Players.LocalPlayer.Character

	if not (Character and Character:FindFirstChild("Humanoid")) then
		return
	end

	local function v720()
		if u717 then
			return
		end

		u717 = true

		for _, v in pairs(t13) do
			if v and (v.Parent and (v.Name == "VehicleSeat" and not v.Occupant)) then
				topos(v.CFrame)

				break
			end
		end

		u717 = false
	end

	local Humanoid = Character.Humanoid
	local v724 = false
	local v725 = nil

	for _, child in pairs(Workspace.Boats:GetChildren()) do
		local VehicleSeat = child:FindFirstChild("VehicleSeat")

		if VehicleSeat and VehicleSeat.Occupant == Humanoid then
			t13[child.Name] = VehicleSeat
			v725 = VehicleSeat
			v724 = true
		elseif VehicleSeat and VehicleSeat.Occupant == "Name" then
			v720()
		end
	end

	if not v724 then
		return
	end

	v725.MaxSpeed = maxSpeed
	v725.CFrame = CFrame.new(Vector3.new(v725.Position.X, v725.Position.Y, v725.Position.Z)) * v725.CFrame.Rotation
	VirtualInputManager:SendKeyEvent(true, "W", false, game)

	for _, descendant in pairs(Workspace.Boats:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
		end
	end

	for _, descendant in pairs(Character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
		end
	end

	for _, v in ipairs({
		"ShipwreckIsland",
		"SandIsland",
		"TreeIsland",
		"TinyIsland",
		"MysticIsland",
		"KitsuneIsland",
		"FrozenDimension"
	}) do
		local v735 = Workspace.Map:FindFirstChild(v)

		if v735 and v735:IsA("Model") then
			v735:Destroy()
		end
	end

	if not Workspace.Map:FindFirstChild("PrehistoricIsland") then
		return
	end

	VirtualInputManager:SendKeyEvent(false, "W", false, game)
	_G.AutoFindPrehistoric = false

	if u718 then
		return
	end

	u718 = true
end)
v442:AddToggle({
	Name = "Auto Tween Prehistoric Island",
	Description = "Tự Động Bay Vào Đảo Núi Lửa Volcano",
	Default = false,
	Callback = function(p111)
		_G.TweenVolcano = p111
		StopTween(_G.TweenVolcano)
	end
})
spawn(function()
	local PrehistoricIsland = nil

	while not PrehistoricIsland do
		PrehistoricIsland = game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
		wait()
	end

	while wait() do
		local PrehistoricIsland2 = _G.TweenVolcano and game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")

		if PrehistoricIsland2 then
			local Core = PrehistoricIsland2:FindFirstChild("Core")

			if Core then
				Core = PrehistoricIsland2.Core:FindFirstChild("PrehistoricRelic")
			end

			if Core then
				Core = Core:FindFirstChild("Skull")
			end

			if Core then
				TP1(CFrame.new(Core.Position))
				_G.TweenVolcano = false
			end
		end
	end
end)
v442:AddToggle({
	Name = "Auto Defend Prehistoric",
	Description = "Xoá Lava",
	Default = false,
	Callback = function(p112)
		_G.DefendVolcano = p112
		StopTween(_G.DefendVolcano)
	end
})

local function v739(p113)
	game:GetService("VirtualInputManager"):SendKeyEvent(true, p113, false, game)
	game:GetService("VirtualInputManager"):SendKeyEvent(false, p113, false, game)
end
local function v740()
	local InteriorLava = game.Workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava")

	if InteriorLava and InteriorLava:IsA("Model") then
		InteriorLava:Destroy()
	end

	local PrehistoricIsland = game.Workspace.Map:FindFirstChild("PrehistoricIsland")

	if PrehistoricIsland then
		for _, descendant in pairs(PrehistoricIsland:GetDescendants()) do
			if descendant:IsA("Part") and descendant.Name:lower():find("lava") then
				descendant:Destroy()
			end
		end
	end

	if not PrehistoricIsland then
		return
	end

	for _, descendant in pairs(PrehistoricIsland:GetDescendants()) do
		if descendant:IsA("Model") then
			for _, descendant2 in pairs(descendant:GetDescendants()) do
				if descendant2:IsA("MeshPart") and descendant2.Name:lower():find("lava") then
					descendant2:Destroy()
				end
			end
		end
	end
end
local function v749()
	local VolcanoRocks = game.Workspace.Map.PrehistoricIsland.Core.VolcanoRocks

	for _, child in pairs(VolcanoRocks:GetChildren()) do
		if child:IsA("Model") then
			local volcanorock = child:FindFirstChild("volcanorock")

			if volcanorock and volcanorock:IsA("MeshPart") then
				local Color = volcanorock.Color

				if Color == Color3.fromRGB(185, 53, 56) or Color == Color3.fromRGB(185, 53, 57) then
					return volcanorock
				end
			end
		end
	end

	return nil
end
local function v755(p114)
	local LocalPlayer3 = game.Players.LocalPlayer
	local Backpack = LocalPlayer3.Backpack

	for _, child in pairs(Backpack:GetChildren()) do
		if child:IsA("Tool") and child.ToolTip == p114 then
			child.Parent = LocalPlayer3.Character

			for _, v in ipairs({
				"Z",
				"X",
				"C",
				"V",
				"F"
			}) do
				wait()

				local v762 = v

				pcall(function()
					v739(v762)
				end)
			end

			child.Parent = Backpack

			break
		end
	end
end

spawn(function()
	while wait() do
		if _G.DefendVolcano then
			AutoHaki()
			pcall(v740)

			local v763 = v749()

			if v763 then
				local cFrame3 = CFrame.new(v763.Position)

				TP1(cFrame3)

				local Color = v763.Color

				if Color == Color3.fromRGB(185, 53, 56) or Color == Color3.fromRGB(185, 53, 57) then
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v763.Position).Magnitude <= 1 then
						if _G.UseMelee then
							v755("Melee")
						end

						if _G.UseSword then
							v755("Sword")
						end

						if _G.UseGun then
							v755("Gun")
						end
					end

					_G.TpPrehistoric = false
				else
					v749()
				end
			else
				_G.TpPrehistoric = true
			end
		end
	end
end)
v442:AddSection({ "Auto Skill" })
v442:AddToggle({
	Name = "Auto Use Melee",
	Description = "Dùng Melee Để Phá Lava",
	Default = false,
	Callback = function(p115)
		_G.UseMelee = p115
		StopTween(_G.UseMelee)
	end
})
v442:AddToggle({
	Name = "Auto Use Sword",
	Description = "Dùng Sword Để Phá Lava",
	Default = false,
	Callback = function(p116)
		_G.UseSword = p116
		StopTween(_G.UseSword)
	end
})
v442:AddToggle({
	Name = "Auto Use Gun",
	Description = "Dùng Gun Để Phá Lava",
	Default = false,
	Callback = function(p117)
		_G.UseGun = p117
		StopTween(_G.UseGun)
	end
})
v442:AddSection({ "Auto Kill Golem" })
v442:AddToggle({
	Name = "Auto Kill Golem",
	Description = "Tự Động Kill Golem",
	Default = false,
	Callback = function(p118)
		_G.KillGolem = p118
		StopTween(_G.KillGolem)
	end
})
spawn(function()
	while wait() do
		if _G.KillGolem and World3 then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Lava Golem") then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == "Lava Golem" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								child.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
								topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
							until not _G.KillGolem or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					UnEquipWeapon(_G.SelectWeapon)

					if not game:GetService("ReplicatedStorage"):FindFirstChild("Lava Golem") then
						return
					end

					topos(game:GetService("ReplicatedStorage"):FindFirstChild("Lava Golem").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
				end
			end)
		end
	end
end)
v442:AddToggle({
	Name = "Auto Kill Aura Golem",
	Description = "Tự Động Kill Aura Golem",
	Default = false,
	Callback = function(p119)
		_G.Kill_Aura = p119
		StopTween(_G.Kill_Aura)
	end
})
spawn(function()
	pcall(function()
		while wait() do
			if _G.Kill_Aura then
				local LocalPlayer3 = game:GetService("Players").LocalPlayer
				local children = game:GetService("Workspace").Enemies:GetChildren()
				local HumanoidRootPart = LocalPlayer3.Character and LocalPlayer3.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					HumanoidRootPart = LocalPlayer3.Character.HumanoidRootPart.Position
				end

				if HumanoidRootPart then
					for _, child in pairs(children) do
						if child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and (child.Humanoid.Health > 0 and (child.HumanoidRootPart.Position - HumanoidRootPart).Magnitude <= 1000)) then
							pcall(function()
								repeat
									wait()
									sethiddenproperty(LocalPlayer3, "SimulationRadius", math.huge)
									child.Humanoid.Health = 0
									child.HumanoidRootPart.CanCollide = false
								until not _G.Kill_Aura or (not child.Parent or child.Humanoid.Health <= 0)
							end)
						end
					end
				end
			end
		end
	end)
end)
v442:AddSection({ "Auto Collect Bone,Egg" })
v442:AddToggle({
	Name = "Auto Collect Bone",
	Description = "Tự Động Nhặt Sương",
	Default = false,
	Callback = function(p120)
		_G.AutoCollectBone = p120
		StopTween(_G.AutoCollectBone)
	end
})
spawn(function()
	while wait() do
		if _G.AutoCollectBone then
			for _, descendant in pairs(workspace:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.Name == "DinoBone" then
					topos(CFrame.new(descendant.Position))
				end
			end
		end
	end
end)
v442:AddToggle({
	Name = "Auto Collect Egg",
	Description = "Tự Động Nhặt Trứng",
	Default = false,
	Callback = function(p121)
		_G.CollectEgg = p121
		StopTween(_G.CollectEgg)
	end
})
spawn(function()
	while wait() do
		if _G.CollectEgg then
			pcall(function()
				game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/CollectedDragonEgg"):FireServer()
			end)
		end
	end
end)
v444:AddSection({ "Kitsune Island" })

local v775 = v444:AddParagraph({
	Title = "Check Kitsune Island",
	Content = "Loading..."
})

task.spawn(function()
	while task.wait(1) do
		pcall(function()
			if game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") then
				v775:Set("Kitsune Island Spawning ✅")
			else
				v775:Set("Kitsune Island Not Spawn ❌")
			end
		end)
	end
end)
v444:AddToggle({
	Name = "Auto Tween Kitsune island",
	Description = "Bay Vô Đảo Kitsune",
	Default = false,
	Callback = function(p122)
		_G.TweenToKitsune = p122
		StopTween(_G.TweenToKitsune)
	end
})
spawn(function()
	local KitsuneIsland = nil

	while not KitsuneIsland do
		KitsuneIsland = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland")
		wait(1)
	end

	while wait() do
		if _G.TweenToKitsune then
			local ShrineActive = KitsuneIsland:FindFirstChild("ShrineActive")

			if ShrineActive then
				for _, descendant in pairs(ShrineActive:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name:find("NeonShrinePart") then
						Tween(descendant.CFrame)
					end
				end
			end
		end
	end
end)
spawn(function()
	pcall(function()
		while wait() do
			if _G.TweenToKitsune then
				topos(game.Workspace.Map.KitsuneIsland.ShrineActive.NeonShrinePart.CFrame * CFrame.new(0, 0, 10))
			end
		end
	end)
end)
v444:AddToggle({
	Title = "Esp Kitsune Island",
	Value = false,
	Callback = function(p123)
		KitsuneIslandEsp = p123

		if KitsuneIslandEsp then
			task.spawn(function()
				while KitsuneIslandEsp do
					UpdateIslandKisuneESP()
					task.wait(1)
				end
			end)
		else
			UpdateIslandKisuneESP()
		end
	end
})
v444:AddToggle({
	Name = "Auto Azuer Ember",
	Description = "Tự Động Nhặt Linh Hồn Xanh",
	Default = false,
	Callback = function(p124)
		_G.AutoAzuerEmber = p124
		StopTween(_G.AutoAzuerEmber)
	end
})
spawn(function()
	while wait() do
		if _G.AutoAzuerEmber then
			pcall(function()
				if not game:GetService("Workspace"):FindFirstChild("AttachedAzureEmber") then
					return
				end

				TP1(game.Workspace.EmberTemplate.Part.CFrame)
			end)
		end
	end
end)
v444:AddSection({ "Sea Events" })
v444:AddToggle({
	Name = "Auto Drive Boats",
	Description = "Tự Động Lái Thuyền",
	Default = false,
	Callback = function(p125)
		_G.SailBoat = p125
		StopTween(_G.SailBoat)
	end
})
spawn(function()
	while wait() do
		pcall(function()
			local n5 = 49

			while true do
				local v781

				if n5 < 20 then
					if n5 < 14 then
						if n5 < 13 then
							if n5 == 3 then
								return
							else
								break
							end
						elseif n5 == 13 then
							if not game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
								return
							end

							if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit ~= false then
								n5 = 19
							else
								n5 = 18
							end
						else
							break
						end
					elseif n5 < 18 then
						if n5 == 14 then
							buyb = TPP(CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781))

							if (CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then
								return
							end

							if buyb then
								buyb:Stop()
							end

							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "BuyBoat", "PirateBrigade" }))

							break
						else
							break
						end
					elseif n5 < 19 then
						if n5 == 18 then
							TPP(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))

							break
						else
							break
						end
					elseif n5 == 19 then
						local v782, v783

						v782, v783, v781 = pairs(game:GetService("Workspace").Boats:GetChildren())
						n5 = 20
					else
						break
					end
				elseif n5 < 23 then
					if n5 < 21 then
						if n5 == 20 then
							local v784

							v781, v784 = v1191(v1192, v781)

							if v781 == nil then
								return
							end

							n5 = 21
						else
							break
						end
					elseif n5 == 21 then
						if v1193.Name ~= "PirateBrigade" then
						end

						n5 = 23
					else
						break
					end
				elseif n5 < 27 then
					if n5 == 23 then
						if true then
							wait()

							if (CFrame.new(-17013.80078125, 10.962434768676758, 438.0169982910156).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then
								if (CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581e-9, 0.967632651, 2.87320709e-8, 1, 3.21888249e-9, -0.967632651, 2.86144175e-8, -0.252362996).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
									TPB(CFrame.new(-42250.2227, -0.3221744, 9247.07715, -0.45916447, 6.39043236e-8, 0.888351262, -3.36711423e-8, 1, -8.93395651e-8, -0.888351262, -7.09333605e-8, -0.45916447))
								elseif (CFrame.new(-42250.2227, -0.3221744, 9247.07715, -0.45916447, 6.39043236e-8, 0.888351262, -3.36711423e-8, 1, -8.93395651e-8, -0.888351262, -7.09333605e-8, -0.45916447).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
									TPB(CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581e-9, 0.967632651, 2.87320709e-8, 1, 3.21888249e-9, -0.967632651, 2.86144175e-8, -0.252362996))
								end
							else
								TPB(CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581e-9, 0.967632651, 2.87320709e-8, 1, 3.21888249e-9, -0.967632651, 2.86144175e-8, -0.252362996))
							end
						end

						n5 = 27
					else
						break
					end
				elseif n5 < 49 then
					if n5 == 27 then
						if game:GetService("Workspace").Enemies:FindFirstChild("Shark") or (game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or (game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or (game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or _G.SailBoat == false))) then
						end

						break
					else
						break
					end
				elseif n5 == 49 then
					if not (_G.SailBoat and not (game:GetService("Workspace").Enemies:FindFirstChild("Shark") and (game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") and (game:GetService("Workspace").Enemies:FindFirstChild("Piranha") and game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member"))))) then
						return
					end

					if game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
					end

					break
				else
					break
				end
			end
		end)
	end
end)
spawn(function()
	pcall(function()
		while wait() do
			if _G.SailBoat and (game:GetService("Workspace").Enemies:FindFirstChild("Shark") or (game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or (game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member")))) then
				game.Players.LocalPlayer.Character.Humanoid.Sit = false
			end
		end
	end)
end)
v444:AddToggle({
	Name = "Auto Kill Terror Shank",
	Description = "Tự Đánh Terror Shank",
	Default = false,
	Callback = function(p126)
		_G.Autoterrorshark = p126
		StopTween(_G.Autoterrorshark)
	end
})
spawn(function()
	while wait() do
		if _G.Autoterrorshark and World3 then
			pcall(function()
				if not (game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or (game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or (game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or (game:GetService("Workspace").Enemies:FindFirstChild("Shark") or (game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or (game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic"))))))) then
					topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))

					for _, child in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
						if child.Name == "Terrorshark" then
							topos(child.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
						else
							game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
						end
					end

					return
				end

				local v787, v788, v789 = pairs(game:GetService("Workspace").Enemies:GetChildren())

				while true do
					local v796

					v789, v796 = v787(v788, v789)

					if v789 == nil then
						return
					end

					if v796.Name ~= "Terrorshark" or (not v796:FindFirstChild("Humanoid") or (not v796:FindFirstChild("HumanoidRootPart") or v796.Humanoid.Health <= 0)) then
						continue
					end

					while true do
						if true then
							task.wait()
							AutoHaki()
							EquipWeapon(_G.SelectWeapon)
							v796.HumanoidRootPart.CanCollide = false
							v796.Humanoid.WalkSpeed = 0
							v796.Head.CanCollide = false
							topos(v796.HumanoidRootPart.CFrame * CFrame.new(5, 40, 10))
							MonFarm = v796.Name
							PosMon = v796.HumanoidRootPart.CFrame
							game.Players.LocalPlayer.Character.Humanoid.Sit = false

							if game:GetService("Workspace")._WorldOrigin:FindFirstChild("Typhoon Splash") then
								topos(v796.HumanoidRootPart.CFrame * CFrame.new(0, 300, 0))
							else
								topos(v796.HumanoidRootPart.CFrame * CFrame.new(0, 60, 0))
							end
						end

						if _G.Autoterrorshark and (v796.Parent and v796.Humanoid.Health > 0) then
							continue
						else
							break
						end
					end

					continue
				end
			end)
		end
	end
end)
spawn(function()
	while wait() do
		if _G.dao then
			pcall(function()
				if game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
					return
				end

				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
			end)
		end
	end
end)
spawn(function()
	while wait() do
		if _G.dao and game.Players.LocalPlayer.Character.Humanoid.Sit == true then
			TPB(CFrame.new(-25351.8418, 10.7575607, 26430.791, -0.998379767, -0.00721008703, -0.0564435199, -0.00722159958, 0.999973953, -1.53919405e-10, 0.0564420484, 0.000407612359, -0.998405814))
		end
	end
end)
spawn(function()
	while task.wait(0.1) do
		pcall(function()
			if not getgenv().SafeMode then
				return
			end

			local Character = game.Players.LocalPlayer.Character

			if not (Character and (Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart"))) then
				return
			end

			local Humanoid = Character.Humanoid
			local HumanoidRootPart = Character.HumanoidRootPart

			if Humanoid.Health >= 5500 then
				return
			end

			while getgenv().SafeMode and Humanoid.Health < 5500 do
				task.wait(0.1)
				HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 200, 0)
			end
		end)
	end
end)
spawn(function()
	while wait() do
		if _G.Nocliprock then
			if game.Players.LocalPlayer.Character.Humanoid.Sit ~= true then
				if game.Players.LocalPlayer.Character.Humanoid.Sit == false then
					for _, descendant in pairs(game.Workspace.Boats:GetDescendants()) do
						if descendant:IsA("BasePart") and descendant.CanCollide == false then
							descendant.CanCollide = true
						end
					end

					for _, descendant in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if descendant:IsA("BasePart") and descendant.CanCollide == false then
							descendant.CanCollide = true
						end
					end
				end
			else
				for _, descendant in pairs(game.Workspace.Boats:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.CanCollide == true then
						descendant.CanCollide = false
					end
				end

				for _, descendant in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.CanCollide == true then
						descendant.CanCollide = false
					end
				end
			end
		end
	end
end)
v444:AddToggle({
	Name = "Auto Kill Shark",
	Description = "Tự Động Đánh Shark",
	Default = false,
	Callback = function(p127)
		_G.KillShark = p127
		StopTween(_G.KillShark)
	end
})
spawn(function()
	while wait() do
		if _G.KillShark and (World3 and _G.SailBoat) then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Shark") or (game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or (game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or (game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or (game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or (game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic")))))) then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == "Shark" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								child.Head.CanCollide = false
								topos(child.HumanoidRootPart.CFrame * CFrame.new(5, 40, 10))
								MonFarm = child.Name
								PosMon = child.HumanoidRootPart.CFrame
								game.Players.LocalPlayer.Character.Humanoid.Sit = false
							until not _G.KillShark or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))

					for _, child in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
						if not child.Name ~= "Shark" then
							if child.Name == "Shark" then
								topos(child.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							end
						else
							game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
						end
					end
				end
			end)
		end
	end
end)
v444:AddToggle({
	Name = "Auto Kill Piranha",
	Description = "Tự Động Đánh Piranha",
	Default = false,
	Callback = function(p128)
		_G.KillPiranha = p128
		StopTween(_G.KillPiranha)
	end
})
spawn(function()
	while wait() do
		if _G.KillPiranha and World3 then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or (game:GetService("Workspace").Enemies:FindFirstChild("Shark") or (game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or (game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or (game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or (game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic")))))) then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == "Piranha" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								child.Head.CanCollide = false
								topos(child.HumanoidRootPart.CFrame * CFrame.new(5, 40, 10))
								MonFarm = child.Name
								PosMon = child.HumanoidRootPart.CFrame
								game.Players.LocalPlayer.Character.Humanoid.Sit = false
							until not _G.KillPiranha or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))

					for _, child in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
						if not child.Name ~= "Piranha" then
							if child.Name == "Piranha" then
								topos(child.HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
							end
						else
							game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
						end
					end
				end
			end)
		end
	end
end)
v444:AddToggle({
	Name = "Auto Kill Fish Crew Member",
	Description = "Tự Động Thành viên phi hành đoàn Auto Kill Fish",
	Default = false,
	Callback = function(p129)
		_G.KillFishCrew = p129
		StopTween(_G.KillFishCrew)
	end
})
spawn(function()
	while wait() do
		if _G.KillFishCrew and World3 then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or (game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or (game:GetService("Workspace").Enemies:FindFirstChild("Shark") or (game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or (game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or (game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic")))))) then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == "Fish Crew Member" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								child.Head.CanCollide = false
								topos(child.HumanoidRootPart.CFrame * CFrame.new(5, 40, 10))
								MonFarm = child.Name
								PosMon = child.HumanoidRootPart.CFrame
								game.Players.LocalPlayer.Character.Humanoid.Sit = false
							until not _G.KillFishCrew or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))

					for _, child in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
						if not child.Name == "Fish Crew Member" then
							game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
						end
					end
				end
			end)
		end
	end
end)
v444:AddSection({ "Mirage Island" })

local v814 = v444:AddParagraph({
	Title = "Check Mirage Island",
	Content = "Loading..."
})

task.spawn(function()
	while task.wait(1) do
		pcall(function()
			if game.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
				v814:Set("Mirage Island Spawning ✅")
			else
				v814:Set("Mirage Island Not Spawn ❌")
			end
		end)
	end
end)
v444:AddToggle({
	Name = "Tween Mirage Island",
	Description = "Tự Động Bay Tới Đảo Bí Ẩn",
	Default = false,
	Callback = function(p130)
		_G.AutoMysticIsland = p130
		StopTween(_G.AutoMysticIsland)
	end
})
spawn(function()
	while task.wait(0.1) do
		pcall(function()
			if not _G.AutoMysticIsland then
				return
			end

			for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
				if child.Name == "Mirage Island" then
					topos(child.CFrame * CFrame.new(0, 333, 0))
				end
			end
		end)
	end
end)
v444:AddToggle({
	Title = "Esp Mirage Island",
	Description = "�ịnh Vị Đảo Bí Ẩn",
	Value = false,
	Callback = function(p131)
		MirageIslandESP = p131

		if MirageIslandESP then
			task.spawn(function()
				while MirageIslandESP do
					UpdateIslandMirageESP()
					task.wait(1)
				end
			end)
		else
			UpdateIslandMirageESP()
		end
	end
})
v444:AddToggle({
	Name = "Look Moon + Auto V3",
	Description = "Tự Động Nhìn Trăng Và Bật Tộc V3",
	Default = false,
	Callback = function(p132)
		_G.AutoDooHee = p132
		StopTween(_G.AutoDooHee)
	end
})

local VirtualInputManager2 = game:GetService("VirtualInputManager")

spawn(function()
	while wait() do
		pcall(function()
			if not getgenv()._G.AutoDooHee then
				return
			end

			local moonDirection = game.Lighting:GetMoonDirection()
			local v819 = game.Workspace.CurrentCamera.CFrame.p + moonDirection * 100

			game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.p, v819)
			wait(2)
			VirtualInputManager2:SendKeyEvent(true, "T", false, game)
			wait(0.1)
			VirtualInputManager2:SendKeyEvent(false, "T", false, game)
		end)
	end
end)
v444:AddToggle({
	Name = "Auto Tween To Gear",
	Description = "Tự Động Bay Đến Gear",
	Default = false,
	Callback = function(p133)
		_G.TweenMGear = p133
		StopTween(_G.TweenMGear)
	end
})
spawn(function()
	pcall(function()
		while wait() do
			if _G.TweenMGear and game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
				for _, child in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do
					if child:IsA("MeshPart") and child.Material == Enum.Material.Neon then
						topos(child.CFrame)
					end
				end
			end
		end
	end)
end)
v446:AddSection({ "Teleport V4" })
v446:AddButton({
	Title = "Teleport To Top GreatTree",
	Value = false,
	Callback = function()
		Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3030.39453125, 2280.6171875, -7320.18359375)
	end
})
v446:AddButton({
	Title = "Teleport Temple Of Time",
	Value = false,
	Callback = function()
		Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
	end
})
v446:AddButton({
	Title = "Teleport Lever Pull",
	Value = false,
	Callback = function()
		topos(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
	end
})
v446:AddButton({
	Title = "Teleport To The Clock",
	Value = false,
	Callback = function()
		topos(CFrame.new(29553.7812, 15066.6133, -88.2750015, 1, 0, 0, 0, 1, 0, 0, 0, 1))
	end
})
v446:AddSection({ "Trial V4" })
v446:AddButton({
	Title = "Auto Race Door",
	Value = false,
	Callback = function()
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
		wait(0.1)
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
		wait(0.1)
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
		wait(0.1)
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
		wait(0.5)

		if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Human" then
			if game:GetService("Players").LocalPlayer.Data.Race.Value == "Skypiea" then
				topos(CFrame.new(28960.158203125, 14919.6240234375, 235.03948974609375))
			elseif game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Fishman" then
				if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Cyborg" then
					if game:GetService("Players").LocalPlayer.Data.Race.Value == "Ghoul" then
						topos(CFrame.new(28674.244140625, 14890.6767578125, 445.4310607910156))
					else
						if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Mink" then
							return
						end

						topos(CFrame.new(29012.341796875, 14890.9755859375, -380.1492614746094))
					end
				else
					topos(CFrame.new(28502.681640625, 14895.9755859375, -423.7279357910156))
				end
			else
				topos(CFrame.new(28231.17578125, 14890.9755859375, -211.64173889160156))
			end
		else
			topos(CFrame.new(29221.822265625, 14890.9755859375, -205.99114990234375))
		end
	end
})
v446:AddButton({
	Title = "Buy Acient One Quest",
	Value = false,
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
	end
})
v446:AddToggle({
	Name = "Auto Trial Human Ghost",
	Description = "Tự Động Trial",
	Default = false,
	Callback = function(p134)
		_G.Kill_Aura = p134
		StopTween(_G.Kill_Aura)
	end
})
v446:AddToggle({
	Name = "Auto Trailer All Race",
	Description = "Tự Động Trailer All Race",
	Default = false,
	Callback = function(p135)
		_G.AutoQuestRace = p135
		StopTween(_G.AutoQuestRace)
	end
})
spawn(function()
	pcall(function()
		while wait() do
			if _G.AutoQuestRace then
				if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Human" then
					if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Skypiea" then
						if game:GetService("Players").LocalPlayer.Data.Race.Value == "Fishman" then
							for _, descendant in pairs(game:GetService("Workspace").SeaBeasts.SeaBeast1:GetDescendants()) do
								if descendant.Name == "HumanoidRootPart" then
									topos(descendant.CFrame * Pos)

									for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
										if child:IsA("Tool") and child.ToolTip == "Melee" then
											game.Players.LocalPlayer.Character.Humanoid:EquipTool(child)
										end
									end

									game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)

									for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
										if child:IsA("Tool") and child.ToolTip == "Blox Fruit" then
											game.Players.LocalPlayer.Character.Humanoid:EquipTool(child)
										end
									end

									game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.5)

									for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
										if child:IsA("Tool") and child.ToolTip == "Sword" then
											game.Players.LocalPlayer.Character.Humanoid:EquipTool(child)
										end
									end

									game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.5)

									for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
										if child:IsA("Tool") and child.ToolTip == "Gun" then
											game.Players.LocalPlayer.Character.Humanoid:EquipTool(child)
										end
									end

									game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									wait(0.2)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
									game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
								end
							end
						elseif game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Cyborg" then
							if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Ghoul" then
								if game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
									for _, descendant in pairs(game:GetService("Workspace"):GetDescendants()) do
										if descendant.Name == "StartPoint" then
											topos(descendant.CFrame * CFrame.new(0, 3, 0))
											_G.AutoQuestRace = false
											StopTween(_G.AutoQuestRace)
										end
									end
								end
							else
								for _, descendant in pairs(game.Workspace.Enemies:GetDescendants()) do
									if descendant:FindFirstChild("Humanoid") and (descendant:FindFirstChild("HumanoidRootPart") and descendant.Humanoid.Health > 0) then
										pcall(function()
											repeat
												wait(0.1)
												descendant.Humanoid.Health = 0
												descendant.HumanoidRootPart.CanCollide = false
												sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
											until not _G.AutoQuestRace or (not descendant.Parent or descendant.Humanoid.Health <= 0)
										end)
									end
								end
							end
						else
							topos(CFrame.new(28654, 14898.7832, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1))
						end
					else
						for _, descendant in pairs(game:GetService("Workspace").Map.SkyTrial.Model:GetDescendants()) do
							if descendant.Name == "snowisland_Cylinder.081" then
								topos(descendant.CFrame * CFrame.new(0, 0, 0))
							end
						end
					end
				else
					for _, descendant in pairs(game.Workspace.Enemies:GetDescendants()) do
						if descendant:FindFirstChild("Humanoid") and (descendant:FindFirstChild("HumanoidRootPart") and descendant.Humanoid.Health > 0) then
							pcall(function()
								repeat
									wait(0.1)
									descendant.Humanoid.Health = 0
									descendant.HumanoidRootPart.CanCollide = false
									sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
								until not _G.AutoQuestRace or (not descendant.Parent or descendant.Humanoid.Health <= 0)
							end)
						end
					end
				end
			end
		end
	end)
end)
v446:AddToggle({
	Name = "Auto Kill Player Trailer V4",
	Description = "�ánh Người Chơi Trong Trial",
	Default = false,
	Callback = function(p136)
		_G.AutoKillV4 = p136
		StopTween(_G.AutoKillV4)
	end
})
spawn(function()
	while task.wait() do
		if _G.AutoKillV4 then
			pcall(function()
				for _, child in pairs(game.Workspace.Characters:GetChildren()) do
					if child.Name ~= game.Players.LocalPlayer.Name and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and (child.Humanoid.Health > 0 and (child.Parent and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude <= 230)))) then
						repeat
							task.wait()
							AutoHaki()
							EquipWeapon(_G.SelectWeapon)
							topos(child.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2))
							child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
							child.HumanoidRootPart.CanCollide = false
							child.Head.CanCollide = false
							child.Humanoid.WalkSpeed = 0
							sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
						until not _G.AutoKillV4 or (child.Humanoid.Health <= 0 or not (child.Parent and (child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid"))))
					end
				end
			end)
		end
	end
end)
v446:AddSection({ "Auto Skill" })
v446:AddToggle({
	Name = "Auto Skill Z",
	Description = "Tự Động Dùng Skill Z Để Đánh",
	Default = false,
	Callback = function(p137)
		_G.XaiSkillZ = p137
		StopTween(_G.XaiSkillZ)
	end
})
v446:AddToggle({
	Name = "Auto Skill X",
	Description = "Tự Động Dùng Skill X Để Đánh",
	Default = false,
	Callback = function(p138)
		_G.XaiSkillX = p138
		StopTween(_G.XaiSkillX)
	end
})
v446:AddToggle({
	Name = "Auto Skill C",
	Description = "Tự Động Dùng Skill C Để Đánh",
	Default = false,
	Callback = function(p139)
		_G.XaiSkillC = p139
		StopTween(_G.XaiSkillC)
	end
})
v448:AddSection({ "Raid Fruits" })
v448:AddDropdown({
	Name = "Select Chip",
	Options = {
		"Flame",
		"Ice",
		"Sand",
		"Dark",
		"Light",
		"Magma",
		"Quake",
		"Buddha",
		"Spider",
		"Phoenix",
		"Lightning",
		"Dough"
	},
	Default = "Flame",
	Callback = function(p140)
		_G.SelectChip = p140
	end
})
v448:AddToggle({
	Name = "Auto Buy Chip",
	Description = "Tự Động Mua Chip Raid",
	Default = false,
	Callback = function(p141)
		_G.AutoBuyChip = p141
	end
})
task.spawn(function()
	while task.wait() do
		if _G.AutoBuyChip and _G.SelectChip then
			pcall(function()
				local t14 = { "RaidsNpc", "Select", _G.SelectChip }

				game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(t14))
			end)
		end
	end
end)
v448:AddToggle({
	Name = "Auto Start Raid",
	Description = "Bắt Đầu Raid",
	Default = false,
	Callback = function(p142)
		_G.StartRaid = p142
	end
})
task.spawn(function()
	while task.wait() do
		pcall(function()
			if not _G.StartRaid then
				return
			end

			local LocalPlayer3 = game.Players.LocalPlayer

			if LocalPlayer3.PlayerGui.Main.Timer.Visible or (workspace._WorldOrigin.Locations:FindFirstChild("Island 1") or not (LocalPlayer3.Backpack:FindFirstChild("Special Microchip") or LocalPlayer3.Character:FindFirstChild("Special Microchip"))) then
				return
			end

			if World2 then
				topos(CFrame.new(-6438.73, 250.64, -4501.5))
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
				fireclickdetector(workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
			else
				if not World3 then
					return
				end

				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5075.5, 314.51, -3150.02))
				topos(CFrame.new(-5017.4, 314.84, -2823.01))
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
				fireclickdetector(workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
			end
		end)
	end
end)
v448:AddToggle({
	Name = "Auto Farm Raid Next Island",
	Description = "�ánh Quái Và Đi Chuyển Đảo",
	Default = false,
	Callback = function(p143)
		_G.Dungeon = p143
	end
})

local function v844(p144)
	if not workspace._WorldOrigin.Locations:FindFirstChild("Island " .. p144) then
		return
	end

	local n6 = 4500

	for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
		if child.Name == "Island " .. p144 and (child.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < n6 then
			n6 = (child.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
		end
	end

	for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
		if not (child.Name ~= "Island " .. p144 or (child.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > n6) then
			return child
		end
	end
end
local function v850()
	for _, v in pairs({
		5,
		4,
		3,
		2,
		1
	}) do
		if v844(v) and (v844(v).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4500 then
			return v844(v)
		end
	end
end
local function v853()
	local v854, v855, v856 = pairs(workspace.Enemies:GetChildren())
	local t15 = {}

	while true do
		local v858

		v856, v858 = v854(v855, v856)

		if v856 == nil then
			break
		end

		if v858:FindFirstChild("HumanoidRootPart") and (v858:FindFirstChild("Humanoid") and (v858.Humanoid.Health > 0 and (v858.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1000)) then
			table.insert(t15, v858)
		end
	end

	local v859, v860, v861 = pairs(t15)

	while true do
		if not true then
			return
		end

		local v862

		v861, v862 = v859(v860, v861)

		if v861 == nil then
			return
		end

		while true do
			task.wait(0.1)

			if v862:FindFirstChild("Humanoid") and v862.Humanoid.Health > 0 then
				EquipWeapon(_G.SelectWeapon)
				topos(v862.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
			end

			if v862:FindFirstChild("Humanoid") and v862.Humanoid.Health > 0 then
				continue
			else
				break
			end
		end

		continue
	end
end

task.spawn(function()
	while task.wait() do
		if _G.Dungeon then
			v853()

			if v850() then
				topos(v850().CFrame * CFrame.new(0, 60, 0))
			end
		end
	end
end)
v448:AddToggle({
	Name = "Auto Get Fruit Low Beli",
	Description = "Tự Động Lấy Trái Ít Beli",
	Default = false,
	Callback = function(p145)
		_G.Autofruit = p145
	end
})
spawn(function()
	while wait(0.1) do
		pcall(function()
			if not _G.Autofruit then
				return
			end

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Rocket-Rocket" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Spin-Spin" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Chop-Chop" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Spring-Spring" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Bomb-Bomb" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Smoke-Smoke" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Spike-Spike" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Flame-Flame" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Falcon-Falcon" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Ice-Ice" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Sand-Sand" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Dark-Dark" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Ghost-Ghost" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Diamond-Diamond" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Light-Light" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Rubber-Rubber" }))
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadFruit", "Creation-Creation" }))
		end)
	end
end)
v448:AddSection({ "Raid Law Sea 2" })
v448:AddButton({
	Title = "Auto Buy Chip Law",
	Description = "Tự Động Mua Chip Law Raid",
	Value = false,
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "BlackbeardReward", "Microchip", "2" }))
	end
})
v448:AddButton({
	Title = "Auto Start Raid Law",
	Value = false,
	Callback = function()
		fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
	end
})
v448:AddToggle({
	Name = "Auto Farm Law Raid",
	Description = "�ánh Boss Law Raid",
	Default = false,
	Callback = function(p146)
		_G.AutoLawRaid = p146
	end
})
spawn(function()
	while wait() do
		if _G.AutoLawRaid then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Order") then
					for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if child.Name == "Order" and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) then
							repeat
								task.wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								child.HumanoidRootPart.CanCollide = false
								child.Humanoid.WalkSpeed = 0
								topos(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
							until not _G.AutoLawRaid or (not child.Parent or child.Humanoid.Health <= 0)
						end
					end
				else
					NeedAttacking = true

					if not game:GetService("ReplicatedStorage"):FindFirstChild("Order") then
						return
					end

					topos(game:GetService("ReplicatedStorage"):FindFirstChild("Order").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
				end
			end)
		end
	end
end)
v450:AddSection({ "Fruits" })
v450:AddToggle({
	Name = "Auto Random Fruits",
	Description = "Tự Động Random Trái Ác Quỷ",
	Default = false,
	Callback = function(p147)
		_G.RandomAuto = p147
	end
})
spawn(function()
	pcall(function()
		while wait() do
			if _G.RandomAuto then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
			end
		end
	end)
end)
v450:AddToggle({
	Title = "Auto Store Fruits",
	Description = "Tự Động Lưu Trái Ác Quỷ Vào Kho Đồ",
	Value = false,
	Callback = function(p148)
		getgenv().AutoStoreFruit = p148
	end
})
spawn(function()
	while task.wait(0.2) do
		if getgenv().AutoStoreFruit then
			pcall(function()
				local LocalPlayer3 = game:GetService("Players").LocalPlayer
				local Character = LocalPlayer3.Character or LocalPlayer3.CharacterAdded:Wait()
				local Backpack = LocalPlayer3:WaitForChild("Backpack")

				for _, v in ipairs({
					{ "Rocket Fruit", "Rocket-Rocket" },
					{ "Spin Fruit", "Spin-Spin" },
					{ "Blade Fruit", "Blade-Blade" },
					{ "Spring Fruit", "Spring-Spring" },
					{ "Bomb Fruit", "Bomb-Bomb" },
					{ "Smoke Fruit", "Smoke-Smoke" },
					{ "Spike Fruit", "Spike-Spike" },
					{ "Flame Fruit", "Flame-Flame" },
					{ "Eagle Fruit", "Eagle-Eagle" },
					{ "Ice Fruit", "Ice-Ice" },
					{ "Sand Fruit", "Sand-Sand" },
					{ "Dark Fruit", "Dark-Dark" },
					{ "Diamond Fruit", "Diamond-Diamond" },
					{ "Light Fruit", "Light-Light" },
					{ "Rubber Fruit", "Rubber-Rubber" },
					{ "Creation Fruit", "Creation-Creation" },
					{ "Ghost Fruit", "Ghost-Ghost" },
					{ "Magma Fruit", "Magma-Magma" },
					{ "Quake Fruit", "Quake-Quake" },
					{ "Buddha Fruit", "Buddha-Buddha" },
					{ "Love Fruit", "Love-Love" },
					{ "Spider Fruit", "Spider-Spider" },
					{ "Sound Fruit", "Sound-Sound" },
					{ "Phoenix Fruit", "Phoenix-Phoenix" },
					{ "Portal Fruit", "Portal-Portal" },
					{ "Lightning Fruit", "Lightning-Lightning" },
					{ "Pain Fruit", "Pain-Pain" },
					{ "Blizzard Fruit", "Blizzard-Blizzard" },
					{ "Gravity Fruit", "Gravity-Gravity" },
					{ "Mammoth Fruit", "Mammoth-Mammoth" },
					{ "T-Rex Fruit", "T-Rex-T-Rex" },
					{ "Dough Fruit", "Dough-Dough" },
					{ "Shadow Fruit", "Shadow-Shadow" },
					{ "Venom Fruit", "Venom-Venom" },
					{ "Gas Fruit", "Gas-Gas" },
					{ "Control Fruit", "Control-Control" },
					{ "Spirit Fruit", "Spirit-Spirit" },
					{ "Leopard Fruit", "Leopard-Leopard" },
					{ "Yeti Fruit", "Yeti-Yeti" },
					{ "Kitsune Fruit", "Kitsune-Kitsune" },
					{ "Dragon Fruit", "Dragon-Dragon" }
				}) do
					local v870 = v[1]
					local v871 = v[2]
					local v872 = Backpack:FindFirstChild(v870) or Character:FindFirstChild(v870)

					if v872 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v871, v872)

						break
					end
				end
			end)
		end
	end
end)
v450:AddToggle({
	Name = "Teleport To Fruit Spawn",
	Description = "Tự Động Nhặt Trái Ác Quỷ Nếu Xuất Hiện Trong Sever",
	Default = false,
	Callback = function(p149)
		_G.Tweenfruit = p149
	end
})
spawn(function()
	while wait(0.1) do
		if _G.TweenFruit then
			for _, child in pairs(game.Workspace:GetChildren()) do
				if string.find(child.Name, "Fruit") then
					TP1(child.Handle.CFrame)
				end
			end
		end
	end
end)
v450:AddToggle({
	Name = "Auto Teleport Fruits",
	Description = "Tự Động Teleport Đến Trái Ác Quỷ",
	Default = false,
	Callback = function(p150)
		_G.Grabfruit = p150
	end
})
spawn(function()
	while wait(0.1) do
		if _G.Grabfruit then
			for _, child in pairs(game.Workspace:GetChildren()) do
				if string.find(child.Name, "Fruit") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = child.Handle.CFrame
				end
			end
		end
	end
end)
v450:AddSection({ "Check Stock Fruits" })

local function v877(p151)
	local v878 = tostring(p151)

	repeat
		local v879

		v878, v879 = v878:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
	until v879 == 0

	return v878
end

local CommF_ = game:GetService("ReplicatedStorage").Remotes.CommF_

local function v881()
	local s3 = "Advance Fruit Stock\n"
	local ok, result = pcall(function()
		return CommF_:InvokeServer("GetFruits", true)
	end)

	if ok and result then
		local v885 = false

		for _, v in pairs(result) do
			if v.OnSale then
				local v888 = v877(v.Price)

				s3 = s3 .. v.Name .. " - $" .. v888 .. "\n"
				v885 = true
			end
		end

		if not v885 then
			s3 = s3 .. "- Không có trái nào.\n"
		end
	else
		s3 = s3 .. "- ❌ Lỗi khi lấy dữ liệu.\n"
	end

	local v889 = s3 .. "\nNormal Fruit Stock\n"
	local ok2, result2 = pcall(function()
		return CommF_:InvokeServer("GetFruits")
	end)

	if ok2 and result2 then
		local v892 = false

		for _, v in pairs(result2) do
			if v.OnSale then
				local v895 = v877(v.Price)

				v889 = v889 .. v.Name .. " - $" .. v895 .. "\n"
				v892 = true
			end
		end

		if v892 then
			return v889
		end

		v889 = v889 .. "- Không có trái nào.\n"
	else
		v889 = v889 .. "- ❌ Lỗi khi lấy dữ liệu.\n"
	end

	return v889
end

local v896 = v450:AddParagraph({
	Title = "Stock Trái Cây",
	Content = "�ang tải dữ liệu..."
})

task.spawn(function()
	while task.wait(60) do
		pcall(function()
			v896:Set(v881())
		end)
	end
end)
pcall(function()
	v896:Set(v881())
end)
v452:AddSection({ "Teleport Island | Di Chuyển Đến Đảo" })

local function v897(p152)
	pcall(function()
		if type(topos) ~= "function" then
			local LocalPlayer3 = game:GetService("Players").LocalPlayer

			if not (LocalPlayer3 and LocalPlayer3.Character and LocalPlayer3.Character:FindFirstChild("HumanoidRootPart")) then
				return
			end

			LocalPlayer3.Character.HumanoidRootPart.CFrame = p152
		else
			topos(p152)
		end
	end)
end

local v899 = World1 and {
	"WindMill",
	"Marine",
	"Middle Town",
	"Jungle",
	"Pirate Village",
	"Desert",
	"Snow Island",
	"MarineFord",
	"Colosseum",
	"Sky Island 1",
	"Sky Island 2",
	"Sky Island 3",
	"Prison",
	"Magma Village",
	"Under Water Island",
	"Fountain City",
	"Shank Room",
	"Mob Island"
} or (World2 and {
	"The Cafe",
	"Frist Spot",
	"Dark Area",
	"Flamingo Mansion",
	"Flamingo Room",
	"Green Zone",
	"Factory",
	"Colossuim",
	"Zombie Island",
	"Two Snow Mountain",
	"Punk Hazard",
	"Cursed Ship",
	"Ice Castle",
	"Forgotten Island",
	"Ussop Island",
	"Mini Sky Island"
} or (World3 and {
	"Mansion",
	"Port Town",
	"Great Tree",
	"Castle On The Sea",
	"MiniSky",
	"Hydra Island",
	"Floating Turtle",
	"Haunted Castle",
	"Ice Cream Island",
	"Peanut Island",
	"Cake Island",
	"Cocoa Island",
	"Candy Island",
	"Tiki Outpost",
	"Dragon Dojo"
} or { "Spawn" }))

v452:AddDropdown({
	Name = "Select Island",
	Description = "Chọn đảo để teleport",
	Options = v899,
	Default = v899[1],
	Callback = function(p153)
		_G.SelectIsland = p153
	end
})
v452:AddToggle({
	Name = "Auto Tween To Island",
	Description = "Tự động di chuyển tới đảo đã chọn",
	Default = false,
	Callback = function(p154)
		_G.TeleportIsland = p154
		StopTween(_G.TeleportIsland)
	end
})

local function v900()
	if not _G.SelectIsland then
		return
	end

	if _G.SelectIsland == "WindMill" then
		v897(CFrame.new(979.799, 16.516, 1429.047))
	elseif _G.SelectIsland == "Marine" then
		v897(CFrame.new(-2566.43, 6.856, 2045.256))
	elseif _G.SelectIsland == "Middle Town" then
		v897(CFrame.new(-690.331, 15.094, 1582.238))
	elseif _G.SelectIsland == "Jungle" then
		v897(CFrame.new(-1612.796, 36.852, 149.128))
	elseif _G.SelectIsland ~= "Pirate Village" then
		if _G.SelectIsland == "Desert" then
			v897(CFrame.new(944.158, 20.92, 4373.3))
		elseif _G.SelectIsland ~= "Snow Island" then
			if _G.SelectIsland ~= "MarineFord" then
				if _G.SelectIsland == "Colosseum" then
					v897(CFrame.new(-1427.62, 7.288, -2792.772))
				elseif _G.SelectIsland == "Sky Island 1" then
					v897(CFrame.new(-4869.103, 733.461, -2667.018))
				elseif _G.SelectIsland == "Sky Island 2" then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.823, 872.543, -1667.557))
				elseif _G.SelectIsland == "Sky Island 3" then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.618, 5547.142, -380.291))
				elseif _G.SelectIsland == "Prison" then
					v897(CFrame.new(4875.33, 5.652, 734.85))
				elseif _G.SelectIsland ~= "Magma Village" then
					if _G.SelectIsland == "Under Water Island" then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.852, 11.68, 1819.784))
					elseif _G.SelectIsland ~= "Fountain City" then
						if _G.SelectIsland == "Shank Room" then
							v897(CFrame.new(-1442.166, 29.879, -28.355))
						elseif _G.SelectIsland == "Mob Island" then
							v897(CFrame.new(-2850.201, 7.392, 5354.993))
						elseif _G.SelectIsland ~= "The Cafe" then
							if _G.SelectIsland == "Frist Spot" then
								v897(CFrame.new(-11.311, 29.277, 2771.522))
							elseif _G.SelectIsland ~= "Dark Area" then
								if _G.SelectIsland == "Flamingo Mansion" then
									v897(CFrame.new(-483.734, 332.038, 595.327))
								elseif _G.SelectIsland == "Flamingo Room" then
									v897(CFrame.new(2284.414, 15.152, 875.725))
								elseif _G.SelectIsland == "Green Zone" then
									v897(CFrame.new(-2448.53, 73.016, -3210.631))
								elseif _G.SelectIsland ~= "Factory" then
									if _G.SelectIsland ~= "Colossuim" then
										if _G.SelectIsland == "Zombie Island" then
											v897(CFrame.new(-5622.033, 492.196, -781.786))
										elseif _G.SelectIsland ~= "Two Snow Mountain" then
											if _G.SelectIsland ~= "Punk Hazard" then
												if _G.SelectIsland == "Cursed Ship" then
													v897(CFrame.new(923.402, 125.057, 32885.875))
												elseif _G.SelectIsland == "Ice Castle" then
													v897(CFrame.new(6148.412, 294.387, -6741.117))
												elseif _G.SelectIsland == "Forgotten Island" then
													v897(CFrame.new(-3032.764, 317.897, -10075.373))
												elseif _G.SelectIsland ~= "Ussop Island" then
													if _G.SelectIsland == "Mini Sky Island" or _G.SelectIsland == "MiniSky" then
														v897(CFrame.new(-288.741, 49326.316, -35248.594))
													elseif _G.SelectIsland == "Great Tree" then
														v897(CFrame.new(2681.274, 1682.809, -7190.985))
													elseif _G.SelectIsland == "Castle On The Sea" then
														game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5083.26, 314.606, -3175.673))
													elseif _G.SelectIsland == "Port Town" then
														v897(CFrame.new(-226.751, 20.603, 5538.34))
													elseif _G.SelectIsland == "Hydra Island" then
														v897(CFrame.new(5291.249, 1005.443, 393.762))
													elseif _G.SelectIsland ~= "Floating Turtle" then
														if _G.SelectIsland == "Mansion" then
															game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.17, 374.94, -7551.678))
														elseif _G.SelectIsland == "Haunted Castle" then
															v897(CFrame.new(-9515.372, 164.006, 5786.061))
														elseif _G.SelectIsland ~= "Ice Cream Island" then
															if _G.SelectIsland ~= "Peanut Island" then
																if _G.SelectIsland == "Cake Island" then
																	v897(CFrame.new(-1884.775, 19.328, -11666.897))
																elseif _G.SelectIsland == "Cocoa Island" then
																	v897(CFrame.new(87.943, 73.555, -12319.465))
																elseif _G.SelectIsland ~= "Candy Island" then
																	if _G.SelectIsland == "Tiki Outpost" then
																		v897(CFrame.new(-16218.683, 9.086, 445.618))
																	else
																		if _G.SelectIsland ~= "Dragon Dojo" then
																			return
																		end

																		v897(CFrame.new(5743.319, 1206.91, 936.011))
																	end
																else
																	v897(CFrame.new(-1014.424, 149.111, -14555.963))
																end
															else
																v897(CFrame.new(-2062.748, 50.474, -10232.568))
															end
														else
															v897(CFrame.new(-902.568, 79.932, -10988.848))
														end
													else
														v897(CFrame.new(-13274.528, 531.821, -7579.223))
													end
												else
													v897(CFrame.new(4816.862, 8.46, 2863.82))
												end
											else
												v897(CFrame.new(-6127.654, 15.952, -5040.286))
											end
										else
											v897(CFrame.new(753.143, 408.236, -5274.615))
										end
									else
										v897(CFrame.new(-1503.622, 219.796, 1369.31))
									end
								else
									v897(CFrame.new(424.127, 211.162, -427.54))
								end
							else
								v897(CFrame.new(3780.03, 22.652, -3498.586))
							end
						else
							v897(CFrame.new(-380.479, 77.22, 255.826))
						end
					else
						v897(CFrame.new(5127.128, 59.501, 4105.446))
					end
				else
					v897(CFrame.new(-5247.716, 12.884, 8504.969))
				end
			else
				v897(CFrame.new(-4914.821, 50.964, 4281.028))
			end
		else
			v897(CFrame.new(1347.807, 104.668, -1319.737))
		end
	else
		v897(CFrame.new(-1181.309, 4.751, 3803.546))
	end
end

task.spawn(function()
	while task.wait(0.5) do
		if _G.TeleportIsland then
			v900()
		end
	end
end)
v452:AddSection({ "Teleport Sea | Di Chuyển Sea 1,2,3" })
v452:AddButton({
	Name = "Sea 1",
	Description = "Biển 1",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
	end
})
v452:AddButton({
	Name = "Sea 2",
	Description = "Biển 2",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
	end
})
v452:AddButton({
	Name = "Sea 3",
	Description = "Biển 3",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
	end
})
v454:AddSection({ "Teleport Player | Di Chuyển Đến Player" })

local v901, v902, v903 = pairs(game.Players:GetPlayers())
local t16 = {}

while true do
	local v905

	v903, v905 = v901(v902, v903)

	if v903 == nil then
		break
	end

	table.insert(t16, v905.Name)
end

v454:AddButton({
	Title = "Get Quest Elite Players",
	Description = "Nhận Nhiệm Vụ Người Chơi",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
	end
})
v454:AddToggle({
	Title = "Auto Kill Player Quest",
	Description = "Bay Đến Người Chơi Được Nhận Nhiệm Vụ",
	Value = false,
	Callback = function(p155)
		_G.AutoPlayerHunter = p155
		StopTween(_G.AutoPlayerHunter)
	end
})
spawn(function()
	game:GetService("RunService").Heartbeat:connect(function()
		pcall(function()
			if not (_G.AutoPlayerHunter and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")) then
				return
			end

			game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
		end)
	end)
end)
spawn(function()
	pcall(function()
		while wait(0.1) do
			if _G.AutoPlayerHunter and game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
			end
		end
	end)
end)
spawn(function()
	while wait() do
		if _G.AutoPlayerHunter then
			if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= false then
				for _, child in pairs(game:GetService("Workspace").Characters:GetChildren()) do
					if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, child.Name) then
						repeat
							wait()
							AutoHaki()
							EquipWeapon(_G.SelectWeapon)
							Useskill = true
							topos(child.HumanoidRootPart.CFrame * CFrame.new(1, 7, 3))
							child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
							game:GetService("VirtualUser"):CaptureController()
							game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
						until _G.AutoPlayerHunter == false or child.Humanoid.Health <= 0

						Useskill = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
					end
				end
			else
				wait(0.5)
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
			end
		end
	end
end)
v454:AddToggle({
	Name = "Auto Safe Mode",
	Description = "Tự Động An Toàn Di Chuyển Lên Trời An Toàn",
	Default = false,
	Callback = function(p156)
		_G.SafeMode = p156
		StopTween(_G.SafeMode)
	end
})
spawn(function()
	pcall(function()
		while wait() do
			if _G.SafeMode then
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 200, 0)
			end
		end
	end)
end)
v454:AddSection({ "Buff" })

local LocalPlayer3 = game:GetService("Players").LocalPlayer

getgenv().WalkSpeedValue = 30
getgenv().JumpValue = 50

local function v909(p157)
	local Humanoid = p157:WaitForChild("Humanoid", 5)

	if not Humanoid then
		return
	end

	Humanoid.WalkSpeed = getgenv().WalkSpeedValue
	Humanoid.JumpPower = getgenv().JumpValue
	Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		Humanoid.WalkSpeed = getgenv().WalkSpeedValue
	end)
end

LocalPlayer3.CharacterAdded:Connect(function(character)
	v909(character)
end)

if LocalPlayer3.Character then
	v909(LocalPlayer3.Character)
end

v454:AddSlider({
	Title = "Speed Chạy by Dum hub",
	Min = 26,
	Max = 300,
	Default = getgenv().WalkSpeedValue,
	Callback = function(p158)
		getgenv().WalkSpeedValue = p158

		local Character = LocalPlayer3.Character

		if Character then
			Character = LocalPlayer3.Character:FindFirstChild("Humanoid")
		end

		if not Character then
			return
		end

		Character.WalkSpeed = p158
	end
})
v454:AddSlider({
	Title = "Nhảy Cao by Dum hub",
	Min = 50,
	Max = 500,
	Default = getgenv().JumpValue,
	Callback = function(p159)
		getgenv().JumpValue = p159

		local Character = LocalPlayer3.Character

		if Character then
			Character = LocalPlayer3.Character:FindFirstChild("Humanoid")
		end

		if not Character then
			return
		end

		Character.JumpPower = p159
	end
})
v454:AddToggle({
	Name = "Delete Lava",
	Description = "Xoá Lava Tránh Bị Mấy Thằng Kid Lỏ Dìm Lava :))",
	Default = false,
	Callback = function(p160)
		_G.RemoveLava = p160
	end
})
spawn(function()
	while task.wait(1) do
		if _G.RemoveLava then
			for _, descendant in pairs(workspace:GetDescendants()) do
				if descendant:IsA("BasePart") and string.lower(descendant.Name):find("lava") then
					pcall(function()
						descendant:Destroy()
					end)
				end
			end
		end
	end
end)
v454:AddSection({ "Esp | Định Vị..." })
v454:AddToggle({
	Title = "Esp Players",
	Value = false,
	Callback = function(p161)
		ESPPlayer = p161

		if ESPPlayer then
			task.spawn(function()
				while ESPPlayer do
					UpdatePlayerChams()
					task.wait(1)
				end
			end)
		else
			UpdatePlayerChams()
		end
	end
})
v454:AddToggle({
	Title = "Esp Chest",
	Value = false,
	Callback = function(p162)
		_G.ChestESP = p162

		if _G.ChestESP then
			task.spawn(function()
				while _G.ChestESP do
					UpdateChestESP()
					task.wait(1)
				end
			end)
		else
			UpdateChestESP()
		end
	end
})
v454:AddToggle({
	Title = "Esp Fruits",
	Value = false,
	Callback = function(p163)
		DevilFruitESP = p163

		if DevilFruitESP then
			task.spawn(function()
				while DevilFruitESP do
					UpdateDevilChams()
					task.wait(1)
				end
			end)
		else
			UpdateDevilChams()
		end
	end
})
v454:AddToggle({
	Title = "Esp Berry",
	Value = false,
	Callback = function(p164)
		Berry = p164

		if Berry then
			UpdateBerriesESP()
		else
			for _, v in pairs(game:GetService("CollectionService"):GetTagged("BerryBush")) do
				if v.Parent:FindFirstChild("BerryESP") then
					v.Parent.BerryESP:Destroy()
				end
			end
		end
	end
})
v456:AddSection({ "Buy Melee V1" })
v456:AddButton({
	Title = "Buy Black Leg $150,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
	end
})
v456:AddButton({
	Title = "Buy Electro $550,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
	end
})
v456:AddButton({
	Title = "Buy Water Kung Fu $750,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
	end
})
v456:AddButton({
	Title = "Buy Dragon Claw 1,500F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
	end
})
v456:AddSection({ "Buy Melee V2" })
v456:AddButton({
	Title = "Buy Superhuman $3,000,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
	end
})
v456:AddButton({
	Title = "Buy Death Step $5,000,000 5,000F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
	end
})
v456:AddButton({
	Title = "Buy Sharkman Karate $2,500,000 5,000F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
	end
})
v456:AddButton({
	Title = "Buy Electric Claw $3,000,000 5,000F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
	end
})
v456:AddButton({
	Title = "Buy Dragon Talon $3,000,000 5,000F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
	end
})
v456:AddButton({
	Title = "Buy God Human $5,000,000 5,000F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
	end
})
v456:AddButton({
	Title = "Buy Sanguine Art $5,000,000 5,000F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt", true)
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt")
	end
})
v456:AddSection({ "Buy Sea Event Crafting" })
v456:AddButton({
	Title = "Craft Dragonheart",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonheart")
	end
})
v456:AddButton({
	Title = "Craft Dragonstorm",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonstorm")
	end
})
v456:AddButton({
	Title = "Craft DinoHood",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "DinoHood")
	end
})
v456:AddButton({
	Title = "Craft SharkTooth",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkTooth")
	end
})
v456:AddButton({
	Title = "Craft TerrorJaw",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TerrorJaw")
	end
})
v456:AddButton({
	Title = "Craft SharkAnchor",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkAnchor")
	end
})
v456:AddButton({
	Title = "Craft LeviathanCrown",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanCrown")
	end
})
v456:AddButton({
	Title = "Craft LeviathanShield",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanShield")
	end
})
v456:AddButton({
	Title = "Craft LeviathanBoat",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanBoat")
	end
})
v456:AddButton({
	Title = "Craft LegendaryScroll",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LegendaryScroll")
	end
})
v456:AddButton({
	Title = "Craft MythicalScroll",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "MythicalScroll")
	end
})
v456:AddSection({ "Buy Haki,Soru..." })
v456:AddButton({
	Title = "Buy Geppo $10,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
	end
})
v456:AddButton({
	Title = "Buy Buso Haki $25,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
	end
})
v456:AddButton({
	Title = "Buy Soru $25,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
	end
})
v456:AddButton({
	Title = "Buy Observation Haki $750,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk", "Buy")
	end
})
v456:AddSection({ "Buy Sword,Gun" })
v456:AddButton({
	Title = "Buy Cutlass $1,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
	end
})
v456:AddButton({
	Title = "Buy Katana $1,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Katana")
	end
})
v456:AddButton({
	Title = "Buy Iron Mace $25,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
	end
})
v456:AddButton({
	Title = "Buy Dual Katana $12,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana")
	end
})
v456:AddButton({
	Title = "Buy Triple Katana $60,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
	end
})
v456:AddButton({
	Title = "Buy Pipe $100,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
	end
})
v456:AddButton({
	Title = "Buy Dual-Headed Blade $400,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
	end
})
v456:AddButton({
	Title = "Buy Bisento $1,200,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
	end
})
v456:AddButton({
	Title = "Buy Soul Cane $750,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
	end
})
v456:AddButton({
	Title = "Buy Pole V2 5,000F",
	Callback = function()
		game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ThunderGodTalk")
	end
})
v456:AddButton({
	Title = "Buy Slingshot $5,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
	end
})
v456:AddButton({
	Title = "Buy Musket $8,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Musket")
	end
})
v456:AddButton({
	Title = "Buy Flintlock $10,500",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
	end
})
v456:AddButton({
	Title = "Refined Slingshot $30,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock")
	end
})
v456:AddButton({
	Title = "Buy Refined Flintlock $65,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "BuyItem", "Refined Flintlock" }))
	end
})
v456:AddButton({
	Title = "Buy Cannon $100,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
	end
})
v456:AddButton({
	Title = "Buy Kabucha 1,500F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "1")
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
	end
})
v456:AddButton({
	Title = "Buy Bizarre Rifle 250 Ectoplasm",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)
	end
})
v456:AddButton({
	Title = "Buy Black Cape $50,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "BuyItem", "Black Cape" }))
	end
})
v456:AddButton({
	Title = "Swordsman Hat $150,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "BuyItem", "Swordsman Hat" }))
	end
})
v456:AddButton({
	Title = "Buy Tomoe Ring $500,000",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "BuyItem", "Tomoe Ring" }))
	end
})
v456:AddSection({ "Reset Stats , Random Race" })
v456:AddButton({
	Title = "�ổi Tộc Ghoul",
	Description = "",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "Ectoplasm", "Change", 4 }))
	end
})
v456:AddButton({
	Title = "�ổi Tộc Cyborg",
	Description = "",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "CyborgTrainer", "Buy" }))
	end
})
v456:AddButton({
	Title = "Reset Stats 2,500F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
	end
})
v456:AddButton({
	Title = "Random Race 3,000F",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
	end
})
v458:AddSection({ "Settings Farming" })
v458:AddParagraph({
	Title = "Unban Fast Attack - M1 Fruit",
	Content = "On: ✅"
})
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDangNhoEm/TuanAnhIOS/refs/heads/main/koby"))()
v458:AddToggle({
	Name = "Bring Mod",
	Description = "Tự Động Gom Quái",
	Default = true,
	Callback = function(p165)
		_G.BringMonster = p165
		StopTween(_G.BringMonster)
	end
})
spawn(function()
	while task.wait() do
		pcall(function()
			CheckQuest()

			for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
				if _G.BringMonster and (StartBring and child.Name == MonFarm or child.Name == Mon and (child:FindFirstChild("Humanoid") and (child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0)) and (child.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 320) then
					if child.Name ~= "Factory Staff" then
						if (child.Name == MonFarm or child.Name == Mon) and (child.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 320 then
							child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
							child.HumanoidRootPart.CFrame = PosMon
							child.HumanoidRootPart.CanCollide = false
							child.Head.CanCollide = false

							if child.Humanoid:FindFirstChild("Animator") then
								child.Humanoid.Animator:Destroy()
							end

							sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
						end
					elseif (child.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 250 then
						child.Head.CanCollide = false
						child.HumanoidRootPart.CanCollide = false
						child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
						child.HumanoidRootPart.CFrame = PosMon

						if child.Humanoid:FindFirstChild("Animator") then
							child.Humanoid.Animator:Destroy()
						end

						sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
					end
				end
			end
		end)
	end
end)

function InMyNetWork(p166)
	if isnetworkowner then
		return isnetworkowner(p166)
	else
		return (p166.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 320
	end
end

v458:AddToggle({
	Title = "Set Home Point",
	Description = "Lưu Điểm Hồi Sinh",
	Value = false,
	Callback = function(p167)
		_G.CheckPoint = p167
	end
})
spawn(function()
	while wait() do
		if _G.CheckPoint then
			game:GetService("SetSpawnPoint")
		end
	end
end)
v458:AddToggle({
	Title = "Infinite Soru",
	Value = false,
	Callback = function(p168)
		_G.AutoHaki = p168
	end
})
spawn(function()
	while task.wait(0.1) do
		if _G.AutoHaki then
			pcall(AutoHaki)
		end
	end
end)
v458:AddToggle({
	Title = "Auto Active Race V3",
	Description = "Tự Động Bật Tộc V3",
	Value = false,
	Callback = function(p169)
		_G.AutoRaceV3 = p169
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if not _G.AutoRaceV3 then
				return
			end

			game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
		end)
	end
end)
v458:AddToggle({
	Title = "Auto Active Race V4",
	Description = "Tự Động Bật Tộc V4",
	Value = false,
	Callback = function(p170)
		_G.AutoRaceV4 = p170
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if not _G.AutoRaceV4 then
				return
			end

			game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
			wait()
			game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
		end)
	end
end)
v458:AddToggle({
	Title = "Infinite Soru",
	Value = false,
	Callback = function(p171)
		InfiniteSoru = p171
	end
})
spawn(function()
	while task.wait(1) do
		if InfiniteSoru and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= "HumanoidRootPart" then
			pcall(function()
				local next_ = next
				local v920, key = getgc()

				while true do
					local v922

					key, v922 = next_(v920, key)

					if key == nil then
						break
					end

					if getfenv(v922).script == game.Players.LocalPlayer.Character:WaitForChild("Soru") then
						local v923, v924, v925 = pairs(debug.getupvalues(v922))

						while true do
							local v926

							v925, v926 = v923(v924, v925)

							if v925 == nil then
								break
							end

							if type(v926) == "table" and v926.LastUse then
								local v927 = v925

								repeat
									task.wait(0.1)
									setupvalue(v922, v925, {
										LastAfter = 0,
										LastUse = 0
									})
								until not InfiniteSoru or game:GetService("Players").LocalPlayer.Character.Humanoid.Health <= 0

								v925 = v927
							end
						end
					end
				end
			end)
		end
	end
end)
PosY = 30
v458:AddToggle({
	Title = "Dodge No CD",
	Value = false,
	Callback = function(p172)
		DodgewithoutCool = p172
	end
})

function NoCooldown()
	local next_ = next
	local v929, key = getgc()

	while true do
		local v931

		key, v931 = next_(v929, key)

		if key == nil then
			break
		end

		if typeof(v931) == "function" and getfenv(v931).script == game.Players.LocalPlayer.Character:WaitForChild("Dodge") then
			local next_2 = next
			local v933, key2 = getupvalues(v931)

			while true do
				local v935

				key2, v935 = next_2(v933, key2)

				if key2 == nil then
					break
				end

				if tostring(v935) == "0.4" then
					setupvalue(v931, key2, 0)
				end
			end
		end
	end
end

spawn(function()
	while wait() do
		if DodgewithoutCool then
			pcall(function()
				NoCooldown()
			end)
		end
	end
end)
v458:AddToggle({
	Title = "Infinite Geppo",
	Value = false,
	Callback = function(p173)
		InfiniteGeppo = p173
	end
})
spawn(function()
	while task.wait(1) do
		if InfiniteGeppo then
			pcall(function()
				local next_ = next
				local v937, key = getgc()

				while true do
					local v939

					key, v939 = next_(v937, key)

					if key == nil then
						break
					end

					if getfenv(v939).script == game.Players.LocalPlayer.Character:WaitForChild("Geppo") then
						local next_2 = next
						local v941, key2 = getupvalues(v939)

						while true do
							local v943

							key2, v943 = next_2(v941, key2)

							if key2 == nil then
								break
							end

							if tostring(v943) == "0" then
								local v944 = key2

								repeat
									wait(0.1)
									setupvalue(v939, key2, 0)
								until not InfiniteGeppo or game:GetService("Players").LocalPlayer.Character.Humanoid.Health <= 0

								key2 = v944
							end
						end
					end
				end
			end)
		end
	end
end)
v458:AddToggle({
	Title = "Walk on Water",
	Value = true,
	Callback = function(p174)
		_G.WalkWater = p174
	end
})
spawn(function()
	while task.wait() do
		pcall(function()
			if _G.WalkWater then
				game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
			else
				game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
			end
		end)
	end
end)
v458:AddSection({ "Auto Increase Skill Points" })

local Players2 = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer4 = Players2.LocalPlayer
local u948 = false
local u949 = false
local u950 = false
local u951 = false
local u952 = false
local n7 = 1

v458:AddToggle({
	Title = "Melee",
	Description = "Tự Động Nâng Điểm Melee",
	Value = false,
	Callback = function(p175)
		u948 = p175
	end
})
v458:AddToggle({
	Title = "Defense",
	Description = "Tự Động Nâng Điểm Năng Lượng",
	Value = false,
	Callback = function(p176)
		u949 = p176
	end
})
v458:AddToggle({
	Title = "Sword",
	Description = "Tự Động Nâng Điểm Kiếm",
	Value = false,
	Callback = function(p177)
		u950 = p177
	end
})
v458:AddToggle({
	Title = "Gun",
	Description = "Tự Động Nâng Điểm Súng",
	Value = false,
	Callback = function(p178)
		u951 = p178
	end
})
v458:AddToggle({
	Title = "Fruis",
	Description = "Tự Động Nâng Điểm Trái",
	Value = false,
	Callback = function(p179)
		u952 = p179
	end
})
spawn(function()
	while wait() do
		if n7 <= LocalPlayer4.Data.Points.Value then
			local function v954(p180)
				local t17 = { "AddPoint", p180, n7 }

				ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(t17))
			end

			if u948 then
				v954("Melee")
			end

			if u949 then
				v954("Defense")
			end

			if u950 then
				v954("Sword")
			end

			if u951 then
				v954("Gun")
			end

			if u952 then
				v954("Demon Fruit")
			end
		end
	end
end)
v458:AddSection({ "Sea 1,2,3" })
v458:AddButton({
	Title = "Join Sea 1",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
	end
})
v458:AddButton({
	Title = "Join Sea 2",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
	end
})
v458:AddButton({
	Title = "Join Sea 3",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
	end
})
v458:AddSection({ "Other" })
v458:AddButton({
	Title = "Join Pirates Team",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
	end
})
v458:AddButton({
	Title = "Join Marines Team",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
	end
})
v458:AddButton({
	Title = "Open Title Name",
	Callback = function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "getTitles" }))
		game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
	end
})
v458:AddButton({
	Title = "FPS Boost",
	Description = "Tăng Fps",
	Callback = function()
		local game_ = game
		local Workspace2 = game_.Workspace
		local _ = game_.Lighting
		local _ = Workspace2.Terrain

		settings().Rendering.QualityLevel = "Level01"

		local v960 = true

		for _, descendant in pairs(game_:GetDescendants()) do
			if descendant:IsA("Part") or (descendant:IsA("Union") or (descendant:IsA("CornerWedgePart") or descendant:IsA("TrussPart"))) then
				descendant.Material = "Plastic"
				descendant.Reflectance = 0
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") and v960 then
				descendant.Transparency = 1
			elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
				descendant.Lifetime = NumberRange.new(0)
			elseif descendant:IsA("Explosion") then
				descendant.BlastPressure = 1
				descendant.BlastRadius = 1
			elseif descendant:IsA("Fire") or (descendant:IsA("SpotLight") or descendant:IsA("Smoke")) then
				descendant.Enabled = false
			end
		end
	end
})
v458:AddSection({ "Auto Codes" })

local t18 = {
	"NOMOREHACK",
	"BANEXPLOIT",
	"WildDares",
	"BossBuild",
	"GetPranked",
	"EARN_FRUITS",
	"FIGHT4FRUIT",
	"NOEXPLOITER",
	"NOOB2ADMIN",
	"CODESLIDE",
	"ADMINHACKED",
	"ADMINDARES",
	"fruitconcepts",
	"krazydares",
	"TRIPLEABUSE",
	"SEATROLLING",
	"24NOADMIN",
	"REWARDFUN",
	"Chandler",
	"NEWTROLL",
	"KITT_RESET",
	"Sub2CaptainMaui",
	"kittgaming",
	"Sub2Fer999",
	"Enyu_is_Pro",
	"Magicbus",
	"JCWK",
	"Starcodeheo",
	"Bluxxy",
	"fudd10_v2",
	"SUB2GAMERROBOT_EXP1",
	"Sub2NoobMaster123",
	"Sub2UncleKizaru",
	"Sub2Daigrock",
	"Axiore",
	"TantaiGaming",
	"StrawHatMaine",
	"Sub2OfficialNoobie",
	"Fudd10",
	"Bignews",
	"TheGreatAce",
	"SECRET_ADMIN",
	"SUB2GAMERROBOT_RESET1",
	"SUB2OFFICIALNOOBIE",
	"AXIORE",
	"BIGNEWS",
	"BLUXXY",
	"CHANDLER",
	"ENYU_IS_PRO",
	"FUDD10",
	"FUDD10_V2",
	"KITTGAMING",
	"MAGICBUS",
	"STARCODEHEO",
	"STRAWHATMAINE",
	"SUB2CAPTAINMAUI",
	"SUB2DAIGROCK",
	"SUB2FER999",
	"SUB2NOOBMASTER123",
	"SUB2UNCLEKIZARU",
	"TANTAIGAMING",
	"THEGREATACE"
}

v458:AddButton({
	Title = "Codes",
	Description = "Tự Động Nhập Hết Code",
	Callback = function()
		for _, v in ipairs(t18) do
			local t19 = { v }

			pcall(function()
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Redeem"):InvokeServer(unpack(t19))
			end)
			task.wait(0.1)
		end
	end
})
v458:AddSection({ "Sever Hop" })
v458:AddButton({
	Title = "Rejoin Server",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
	end
})
v458:AddButton({
	Title = "Server Hop",
	Callback = function()
		Hop()
	end
})
