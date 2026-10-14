-- This file was generated at discord.gg/syncrypt

local v28, v29, t62, t63, t64, v271, v274, Players, LocalPlayer, CurrentCamera, v279, _pairs, v281

do
	local function v1(...)
		local t1 = { ... }

		t1.n = select("#", ...)

		return t1
	end

	do
		local v3 = v1(game:HttpGet("https://raw.githubusercontent.com/necodehacks/namename/refs/heads/main/souh"))

		loadstring(unpack(v3, 1, v3.n))()
	end

	do
		local ReplicatedStorage

		do
			local Players2 = game:GetService("Players")

			ReplicatedStorage = game:GetService("ReplicatedStorage")

			local _ = Players2.LocalPlayer
		end

		local _ = ReplicatedStorage.Import.Remotes.Chat
	end

	local v217, Gloves, t53

	do
		local v179, t40

		do
			local LocalPlayer2

			do
				local v53, t13

				do
					local t3
					local t2, v18, v41

					do
						local v25, v30

						do
							local v8 = Library:Window({
								Logo = "126668961511560",
								FadeTime = 0.3,
							})
							local v9 = Library:Watermark("t.me/zeferuswav")
							local v10 = Library:KeybindList()

							t2 = {
								Enabled = false,
								TeamCheck = true,
								Size = Vector3.new(6, 6, 6),
								Transparency = 1,
								Material = Enum.Material.ForceField,
							}
							t3 = {}

							local u19, u20, u21, u22

							do
								local Players3 = game:GetService("Players")

								LocalPlayer2 = Players3.LocalPlayer

								local Workspace = game:GetService("Workspace")
								local u17 = t2

								function v18()
									if u17.Enabled then
										local v355 = Library.Flags.HitboxSizeX or 6
										local v356 = Library.Flags.HitboxSizeY or 6
										local v357 = Library.Flags.HitboxSizeZ or 6

										u17.Size = Vector3.new(v355, v356, v357)

										for k, _ in pairs(t3) do
											if k and k.Parent then
												local Head = k:FindFirstChild("Head")
												local HumanoidRootPart = k:FindFirstChild("HumanoidRootPart")

												if Head then
													Head.Size = u17.Size
													Head.Transparency = u17.Transparency
													Head.Material = u17.Material
												end

												if HumanoidRootPart then
													HumanoidRootPart.Size = u17.Size
													HumanoidRootPart.Transparency = u17.Transparency
													HumanoidRootPart.Material = u17.Material
												end
											end
										end

										return
									end
								end

								u19 = t2
								u20 = LocalPlayer2
								u21 = Workspace
								u22 = Players3
							end

							local wrap = coroutine.wrap

							local function u24()
								if u19.Enabled then
									local v362

									if not u20:FindFirstChild("PlayerStates") or not u20.PlayerStates:FindFirstChild("Team") then
										v362 = nil
									else
										v362 = u20.PlayerStates.Team.Value
									end

									for _, child in pairs(u21:GetChildren()) do
										if child:IsA("Model") then
											local Humanoid = child:FindFirstChildOfClass("Humanoid")
											local Head = child:FindFirstChild("Head")
											local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")

											if not Humanoid or not Head or not HumanoidRootPart or not (Humanoid.Health > 0) or child == u20.Character then
												if t3[child] then
													if Head then
														Head.Size = t3[child].Head.Size
														Head.Transparency = t3[child].Head.Transparency
														Head.Material = t3[child].Head.Material
													end

													if HumanoidRootPart then
														HumanoidRootPart.Size = t3[child].HumanoidRootPart.Size
														HumanoidRootPart.Transparency = t3[child].HumanoidRootPart.Transparency
														HumanoidRootPart.Material = t3[child].HumanoidRootPart.Material
													end

													t3[child] = nil
												end
											else
												local childName = u22:FindFirstChild(child.Name)
												local v369 = true

												if u19.TeamCheck and childName then
													local v370

													if
														not childName
														or not childName:FindFirstChild("PlayerStates")
														or not childName.PlayerStates:FindFirstChild("Team")
													then
														v370 = nil
													else
														v370 = childName.PlayerStates.Team.Value
													end

													if v370 == v362 then
														v369 = false
													end
												end

												if not v369 then
													if t3[child] then
														Head.Size = t3[child].Head.Size
														Head.Transparency = t3[child].Head.Transparency
														Head.Material = t3[child].Head.Material
														HumanoidRootPart.Size = t3[child].HumanoidRootPart.Size
														HumanoidRootPart.Transparency = t3[child].HumanoidRootPart.Transparency
														HumanoidRootPart.Material = t3[child].HumanoidRootPart.Material
														t3[child] = nil
													end
												else
													if not t3[child] then
														t3[child] = {
															Head = {
																Size = Head.Size,
																Transparency = Head.Transparency,
																Material = Head.Material,
															},
															HumanoidRootPart = {
																Size = HumanoidRootPart.Size,
																Transparency = HumanoidRootPart.Transparency,
																Material = HumanoidRootPart.Material,
															},
														}
													end

													Head.Size = u19.Size
													Head.Transparency = u19.Transparency
													Head.Material = u19.Material
													HumanoidRootPart.Size = u19.Size
													HumanoidRootPart.Transparency = u19.Transparency
													HumanoidRootPart.Material = u19.Material
												end
											end
										end
									end

									return
								end
							end

							wrap(function()
								while true do
									u24()
									wait(0.1)
								end
							end)()

							function v25()
								local v380 = Library.Flags.SelectedWeapon or "AWP"
								local v381 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v380]

								if v381 and v381:FindFirstChild("Spread") then
									local Spread = v381.Spread

									if not Library.Flags.NoSpread then
										if Spread:FindFirstChild("Stand") then
											Spread.Stand.Value = 0.01
										end

										if Spread:FindFirstChild("Crouch") then
											Spread.Crouch.Value = 0.005
										end

										if Spread:FindFirstChild("Move") then
											Spread.Move.Value = 0.03
										end

										if Spread:FindFirstChild("Jump") then
											Spread.Jump.Value = 0.1
										end

										if Spread:FindFirstChild("Ladder") then
											Spread.Ladder.Value = 0.05
										end

										if Spread:FindFirstChild("Land") then
											Spread.Land.Value = 0.02
										end
									else
										if Spread:FindFirstChild("Stand") then
											Spread.Stand.Value = 0
										end

										if Spread:FindFirstChild("Crouch") then
											Spread.Crouch.Value = 0
										end

										if Spread:FindFirstChild("Move") then
											Spread.Move.Value = 0
										end

										if Spread:FindFirstChild("Jump") then
											Spread.Jump.Value = 0
										end

										if Spread:FindFirstChild("Ladder") then
											Spread.Ladder.Value = 0
										end

										if Spread:FindFirstChild("Land") then
											Spread.Land.Value = 0

											return
										end
									end
								end
							end
							local v27 = v8:Page({
								Name = "RageBot",
								SubPages = true,
							})

							v28 = v8:Page({
								Name = "Visuals",
								Columns = 2,
							})
							v29 = v8:Page({
								Name = "Misc",
								Columns = 2,
							})
							Library:CreateSettingsPage(v8, v9, v10)
							v30 = v27:SubPage({
								Name = "Weapon",
								Columns = 2,
							})
							v27:SubPage({
								Name = "Anti-Hit",
								Columns = 2,
							})
						end

						local v31 = v30:Section({
							Name = "Weapon Settings",
							Side = 1,
						})
						local t4 = {
							Name = "Weapon",
							Items = {
								"AWP",
								"AK47",
								"M4A1",
								"G3SG1",
								"FAMAS",
								"CZ75",
								"Bizon",
								"MAC10",
								"MP5",
								"MP7",
								"MP9",
								"Five-Seven",
								"DesertEagle",
								"SCAR20",
								"P2000",
								"SSG08",
								"Tec9",
								"UMP",
								"USP",
								"XM1014",
								"M4A4",
							},
							Flag = "SelectedWeapon",
							Default = "AWP",
							Multi = false,
						}
						local u33 = v25

						function t4.Callback(_)
							local v392 = Library.Flags.SelectedWeapon or "AWP"
							local v393 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v392]

							if v393 and v393:FindFirstChild("Ammo") then
								if not Library.Flags.InfiniteAmmo then
									v393.Ammo.Value = 30
								else
									v393.Ammo.Value = 1337
								end
							end

							local v394 = Library.Flags.SelectedWeapon or "AWP"
							local v395 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v394]

							if v395 and v395:FindFirstChild("DamageMultiplier") then
								if not Library.Flags.DamageMultiplierEnabled then
									v395.DamageMultiplier.Value = 1
								else
									v395.DamageMultiplier.Value = Library.Flags.DamageMultiplierValue or 2
								end
							end

							local v396 = Library.Flags.SelectedWeapon or "AWP"
							local v397 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v396]

							if v397 and v397:FindFirstChild("Penetration") then
								if not Library.Flags.IncreasedPenetration then
									v397.Penetration.Value = 1
								else
									v397.Penetration.Value = 100
								end
							end

							local v398 = Library.Flags.SelectedWeapon or "AWP"
							local v399 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v398]

							if v399 and v399:FindFirstChild("MaxSpeed") then
								if not Library.Flags.IncreasedSpeed then
									v399.MaxSpeed.Value = 25
								else
									v399.MaxSpeed.Value = 100
								end
							end

							u33()
						end

						v31:Dropdown(t4)
						v31:Toggle({
							Name = "Infinite Ammo",
							Flag = "InfiniteAmmo",
							Default = false,
							Callback = function(_)
								local v401 = Library.Flags.SelectedWeapon or "AWP"
								local v402 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v401]

								if v402 and v402:FindFirstChild("Ammo") then
									if Library.Flags.InfiniteAmmo then
										v402.Ammo.Value = 1337

										return
									end

									v402.Ammo.Value = 30
								end
							end,
						})
						v31:Toggle({
							Name = "Damage Multiplier",
							Flag = "DamageMultiplierEnabled",
							Default = false,
							Callback = function(_)
								local v404 = Library.Flags.SelectedWeapon or "AWP"
								local v405 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v404]

								if v405 and v405:FindFirstChild("DamageMultiplier") then
									if Library.Flags.DamageMultiplierEnabled then
										v405.DamageMultiplier.Value = Library.Flags.DamageMultiplierValue or 2

										return
									end

									v405.DamageMultiplier.Value = 1
								end
							end,
						})
						v31:Slider({
							Name = "Damage Multiplier Value",
							Flag = "DamageMultiplierValue",
							Min = 1,
							Max = 10,
							Default = 2,
							Decimals = 1,
							Callback = function(_)
								local v407 = Library.Flags.SelectedWeapon or "AWP"
								local v408 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v407]

								if v408 and v408:FindFirstChild("DamageMultiplier") then
									if Library.Flags.DamageMultiplierEnabled then
										v408.DamageMultiplier.Value = Library.Flags.DamageMultiplierValue or 2

										return
									end

									v408.DamageMultiplier.Value = 1
								end
							end,
						})
						v31:Toggle({
							Name = "Increased Penetration",
							Flag = "IncreasedPenetration",
							Default = false,
							Callback = function(_)
								local v410 = Library.Flags.SelectedWeapon or "AWP"
								local v411 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v410]

								if v411 and v411:FindFirstChild("Penetration") then
									if Library.Flags.IncreasedPenetration then
										v411.Penetration.Value = 100

										return
									end

									v411.Penetration.Value = 1
								end
							end,
						})
						v31:Toggle({
							Name = "Increased Speed",
							Flag = "IncreasedSpeed",
							Default = false,
							Callback = function(_)
								local v413 = Library.Flags.SelectedWeapon or "AWP"
								local v414 = game:GetService("ReplicatedStorage").Import.Guns.Weapons[v413]

								if v414 and v414:FindFirstChild("MaxSpeed") then
									if Library.Flags.IncreasedSpeed then
										v414.MaxSpeed.Value = 100

										return
									end

									v414.MaxSpeed.Value = 25
								end
							end,
						})

						local v34 = v30:Section({
							Name = "Spread Settings",
							Side = 2,
						})
						local t5 = {
							Name = "No Spread",
							Flag = "NoSpread",
							Default = false,
						}
						local u36 = v25

						function t5.Callback(_)
							u36()
						end

						v34:Toggle(t5)

						local t6 = {
							Name = "No Move Spread",
							Flag = "NoMoveSpread",
							Default = false,
						}
						local u38 = v25

						function t6.Callback(_)
							u38()
						end

						v34:Toggle(t6)

						local t7 = {
							Name = "No Jump Spread",
							Flag = "NoJumpSpread",
							Default = false,
						}
						local u40 = v25

						function t7.Callback(_)
							u40()
						end

						v34:Toggle(t7)
						v41 = v30:Section({
							Name = "Multi-Points  (DANGER)",
							Side = 1,
						})
					end

					local t8 = {
						Name = "Enabled",
						Flag = "HitboxExpanderEnabled",
						Default = false,
					}
					local u43 = t2

					local function u44()
						for k, _ in pairs(t3) do
							if k and k.Parent then
								local Head = k:FindFirstChild("Head")
								local HumanoidRootPart = k:FindFirstChild("HumanoidRootPart")

								if Head and t3[k] and t3[k].Head then
									Head.Size = t3[k].Head.Size
									Head.Transparency = t3[k].Head.Transparency
									Head.Material = t3[k].Head.Material
								end

								if HumanoidRootPart and t3[k] and t3[k].HumanoidRootPart then
									HumanoidRootPart.Size = t3[k].HumanoidRootPart.Size
									HumanoidRootPart.Transparency = t3[k].HumanoidRootPart.Transparency
									HumanoidRootPart.Material = t3[k].HumanoidRootPart.Material
								end
							end
						end

						t3 = {}
					end

					function t8.Callback(p10)
						u43.Enabled = p10

						if not p10 then
							u44()
						end
					end

					v41:Toggle(t8)

					local t9 = {
						Name = "Team Check",
						Flag = "HitboxTeamCheck",
						Default = true,
					}
					local u46 = t2

					function t9.Callback(p11)
						u46.TeamCheck = p11
					end

					v41:Toggle(t9)

					local t10 = {
						Name = "X",
						Flag = "HitboxSizeX",
						Min = 1,
						Suffix = " studs",
						Max = 144,
						Default = 6,
						Decimals = 1,
					}
					local u48 = v18

					function t10.Callback(_)
						u48()
					end

					v41:Slider(t10)

					local t11 = {
						Name = "Y",
						Flag = "HitboxSizeY",
						Min = 1,
						Suffix = " studs",
						Max = 144,
						Default = 6,
						Decimals = 1,
					}
					local u50 = v18

					function t11.Callback(_)
						u50()
					end

					v41:Slider(t11)

					local t12 = {
						Name = "Z",
						Flag = "HitboxSizeZ",
						Min = 1,
						Suffix = " studs",
						Max = 144,
						Default = 6,
						Decimals = 1,
					}
					local u52 = v18

					function t12.Callback(_)
						u52()
					end

					v41:Slider(t12)
					v53 = v29:Section({
						Name = "Shop",
						Side = 1,
					})
					t13 = {
						Enabled = false,
					}

					local t14 = {
						Name = "Inf. Time Buy",
						Flag = "AutoBuyEnabled",
						Default = false,
					}
					local u56 = t13

					function t14.Callback(p15)
						u56.Enabled = p15
					end

					v53:Toggle(t14)
				end

				local t15 = {
					Enabled = false,
					Message = "ZEFERUS - FREEMIUM VERSION.",
				}
				local t16 = {
					Name = "Kill-Say",
					Flag = "KillSay",
					Default = false,
				}
				local u59 = t15

				function t16.Callback(p16)
					u59.Enabled = p16
				end

				v53:Toggle(t16)

				local wrap = coroutine.wrap
				local u61 = t13

				wrap(function()
					while true do
						if u61.Enabled then
							local BuyStatus = game:GetService("ReplicatedStorage").Import.BindableEvents.BuyStatus

							if not BuyStatus:IsA("BindableEvent") then
								if BuyStatus:IsA("RemoteEvent") then
									BuyStatus:FireServer(true)
								end
							else
								BuyStatus:Fire(true)
							end
						end

						wait(0.1)
					end
				end)()

				local KillsValue = LocalPlayer2.PlayerStates.Kills.Value
				local Changed = LocalPlayer2.PlayerStates.Kills.Changed
				local u64 = t15

				Changed:Connect(function(p17)
					if p17 > KillsValue and u64.Enabled then
						wait(1)

						local Chat = game:GetService("ReplicatedStorage").Import.Remotes.Chat

						if Chat and Chat:IsA("RemoteEvent") then
							Chat:FireServer(u64.Message)
						end
					end

					KillsValue = p17
				end)

				local v65 = v29:Section({
					Name = "Auto Buy Bot",
					Side = 1,
				})
				local t17 = {
					Enabled = false,
					Weapon = "AK47",
					Delay = 1,
				}
				local t18 = {
					Name = "Enabled",
					Flag = "SmartBuyEnabled",
					Default = false,
				}
				local u68 = t17

				function t18.Callback(p18)
					u68.Enabled = p18
				end

				v65:Toggle(t18)

				local t19 = {
					Name = "Weapon",
					Items = {
						"AK47",
						"M4A1",
						"AWP",
						"DesertEagle",
						"P250",
						"UMP",
						"MP5",
						"MP7",
						"MP9",
						"FAMAS",
						"G3SG1",
						"SCAR20",
						"SSG08",
						"XM1014",
						"MAC10",
						"Bizon",
						"Tec9",
						"Five-Seven",
						"P2000",
						"USP",
						"CZ75",
					},
					Flag = "SmartBuyWeapon",
					Default = "AK47",
				}
				local u70 = t17

				function t19.Callback(p19)
					u70.Weapon = p19
				end

				v65:Dropdown(t19)

				local wrap2 = coroutine.wrap
				local u72 = t17
				local u73 = LocalPlayer2

				wrap2(function()
					while true do
						if u72.Enabled then
							local Gun = u73:FindFirstChild("Gun")

							if not Gun or Gun.Value ~= u72.Weapon then
								game:GetService("ReplicatedStorage").Import.Remotes.BuyGun:FireServer(u72.Weapon)
							end
						end

						wait(u72.Delay)
					end
				end)()
			end

			do
				local MiscStorage, CurrentCamera2, t23, Folder

				do
					local v74 = v28:Section({
						Name = "Chamsiki",
						Side = 1,
					})
					local t20 = {
						Enabled = false,
						EnemyColor = Color3.new(1, 0, 0),
						TeamColor = Color3.new(0, 1, 0),
						OutlineColor = Color3.new(1, 1, 1),
						TeamCheck = true,
					}
					local Players4 = game:GetService("Players")
					local LocalPlayer3 = Players4.LocalPlayer
					local Workspace = game:GetService("Workspace")
					local v82, v84

					do
						local u80 = t20
						local u81 = LocalPlayer3

						function v82(p20)
							if u80.Enabled then
								local Character = p20.Character

								if Character and not Character:FindFirstChild("E") and Character:FindFirstChildWhichIsA("Humanoid") then
									local Highlight = Instance.new("Highlight")

									Highlight.Name = "E"
									Highlight.FillTransparency = 1
									Highlight.OutlineTransparency = 0

									if u80.TeamCheck then
										local v435

										if not p20 or not p20:FindFirstChild("PlayerStates") or not p20.PlayerStates:FindFirstChild("Team") then
											v435 = nil
										else
											v435 = p20.PlayerStates.Team.Value
										end

										local v436

										if not u81:FindFirstChild("PlayerStates") or not u81.PlayerStates:FindFirstChild("Team") then
											v436 = nil
										else
											v436 = u81.PlayerStates.Team.Value
										end

										if v435 == v436 then
											Highlight:Destroy()

											return
										end

										Highlight.FillColor = u80.EnemyColor
										Highlight.OutlineColor = u80.OutlineColor
										Highlight.Parent = Character

										return
									end

									Highlight.FillColor = u80.EnemyColor
									Highlight.OutlineColor = u80.OutlineColor
									Highlight.Parent = Character
								end

								return
							end
						end

						local u83 = Players4

						function v84()
							for _, player in ipairs(u83:GetPlayers()) do
								if player.Character and player.Character:FindFirstChild("E") then
									player.Character.E:Destroy()
								end
							end
						end

						local PlayerAdded = Players4.PlayerAdded
						local u86 = t20
						local u87 = v82

						PlayerAdded:Connect(function(p21)
							local CharacterAdded = p21.CharacterAdded
							local u441 = p21

							CharacterAdded:Connect(function(_)
								if u86.Enabled then
									wait(1.3)
									u87(u441)
								end
							end)
						end)

						local _ipairs = ipairs
						local v89 = v1(Players4:GetPlayers())

						for _, v91 in _ipairs(unpack(v89, 1, v89.n)) do
							if v91 ~= LocalPlayer3 then
								local CharacterAdded = v91.CharacterAdded
								local u93 = t20
								local u94 = v82
								local u95 = v91

								CharacterAdded:Connect(function(_)
									if u93.Enabled then
										wait(1.3)
										u94(u95)
									end
								end)
							end
						end
					end

					local wrap = coroutine.wrap
					local u97 = t20
					local u98 = Players4
					local u99 = LocalPlayer3
					local u100 = v82

					wrap(function()
						while true do
							wait(2)

							if u97.Enabled then
								for _, player in ipairs(u98:GetPlayers()) do
									if player ~= u99 then
										u100(player)
									end
								end
							end
						end
					end)()

					local t21 = {
						Name = "Chams HL",
						Flag = "HighlightEnabled",
						Default = false,
					}
					local u102 = t20
					local u103 = Players4
					local u104 = LocalPlayer3
					local u105 = v82
					local u106 = v84

					function t21.Callback(p24)
						u102.Enabled = p24

						if not p24 then
							u106()

							return
						end

						for _, player in ipairs(u103:GetPlayers()) do
							if player ~= u104 then
								task.defer(u105, player)
							end
						end
					end

					v74:Toggle(t21)

					local t22 = {
						Name = "Team Check",
						Flag = "HighlightTeamCheck",
						Default = true,
					}
					local u108 = t20
					local u109 = v84
					local u110 = Players4
					local u111 = LocalPlayer3
					local u112 = v82

					function t22.Callback(p25)
						u108.TeamCheck = p25

						if u108.Enabled then
							u109()

							for _, player in ipairs(u110:GetPlayers()) do
								if player ~= u111 then
									task.defer(u112, player)
								end
							end
						end
					end

					v74:Toggle(t22)
					MiscStorage = Workspace:WaitForChild("MiscStorage")
					CurrentCamera2 = Workspace.CurrentCamera
					t23 = {
						Enabled = false,
						Color = Color3.fromRGB(255, 255, 0),
						Duration = 1.5,
						Thickness = 0.08,
						Offset = Vector3.new(0.5, -0.3, 0),
						Texture = "",
					}
					Folder = Instance.new("Folder")
					Folder.Name = "BulletTracers"
					Folder.Parent = Workspace
				end

				local t24 = {}
				local t25 = {
					Default = "",
					Lightning = "rbxassetid://446111271",
					Laser = "rbxassetid://6757160735",
					Neon = "rbxassetid://2796378399",
				}
				local u119 = t24
				local u120 = t23

				local function v121()
					for _, v in pairs(u119) do
						if v and v.Parent then
							v.Color = ColorSequence.new(u120.Color)

							if u120.Texture ~= "" then
								v.Texture = u120.Texture
							end
						end
					end
				end

				local u122 = t23
				local u123 = CurrentCamera2
				local u124 = Folder
				local u125 = t24

				local function v126(p26)
					if u122.Enabled then
						local v454 = u123.CFrame.Position
							+ u123.CFrame.RightVector * u122.Offset.X
							+ u123.CFrame.UpVector * u122.Offset.Y
							+ u123.CFrame.LookVector * u122.Offset.Z
						local p26Position = p26.Position
						local Attachment = Instance.new("Attachment")

						Attachment.WorldPosition = v454
						Attachment.Parent = u124

						local Attachment2 = Instance.new("Attachment")

						Attachment2.WorldPosition = p26Position
						Attachment2.Parent = u124

						local Beam = Instance.new("Beam")

						Beam.Attachment0 = Attachment
						Beam.Attachment1 = Attachment2
						Beam.Color = ColorSequence.new(u122.Color)
						Beam.Width0 = u122.Thickness
						Beam.Width1 = u122.Thickness
						Beam.FaceCamera = true

						if u122.Texture ~= "" then
							Beam.Texture = u122.Texture
							Beam.TextureSpeed = 2
						end

						Beam.Parent = u124

						local u459 = #u125 + 1

						u125[u459] = Beam

						local timestamp = tick()
						local wrap = coroutine.wrap
						local u462 = Attachment

						wrap(function()
							while tick() - timestamp < u122.Duration do
								local v675 = (tick() - timestamp) / u122.Duration

								Beam.Transparency = NumberSequence.new(v675)
								wait(0.05)
							end

							u462:Destroy()
							Attachment2:Destroy()
							Beam:Destroy()
							u125[u459] = nil
						end)()

						return
					end
				end
				local u129 = MiscStorage
				local u130 = v126
				local v131 = v28:Section({
					Name = "Bullet Tracers",
					Side = 2,
				})
				local t26 = {
					Name = "Bullet-Tracers",
					Flag = "BulletTracerEnabled",
					Default = false,
				}
				local u133 = t23

				function t26.Callback(p27)
					u133.Enabled = p27
				end

				local v134 = v131:Toggle(t26)
				local t27 = {
					Name = "Color",
					Flag = "BulletTracerColor",
					Default = Color3.fromRGB(255, 0, 0),
				}
				local u136 = t23
				local u137 = v121

				function t27.Callback(p28)
					u136.Color = p28
					u137()
				end

				v134:Colorpicker(t27)

				local t28 = {
					Name = "Duration",
					Flag = "BulletTracerDuration",
					Min = 0.5,
					Suffix = "s",
					Max = 5,
					Default = 1.5,
					Decimals = 1,
				}
				local u139 = t23

				function t28.Callback(p29)
					u139.Duration = p29
				end

				v131:Slider(t28)

				local t29 = {
					Name = "Texture",
					Items = {
						"Default",
						"Lightning",
						"Laser",
						"Neon",
					},
					Flag = "BulletTracerTexture",
					Default = "Default",
				}
				local u141 = t23
				local u142 = t25
				local u143 = v121

				function t29.Callback(p30)
					u141.Texture = u142[p30]
					u143()
				end

				v131:Dropdown(t29)

				local ChildAdded = MiscStorage.ChildAdded
				local u145 = v126

				ChildAdded:Connect(function(p31)
					local p31Name = p31.Name

					if tonumber(p31Name) then
						wait(0.1)

						local BulletHole = p31:FindFirstChild("BulletHole")

						if BulletHole and BulletHole:IsA("Part") then
							u145(BulletHole)
						end
					end
				end);
				(function()
					for i = 1, 9 do
						local str = tostring(i)
						local str2 = u129:FindFirstChild(str)

						if str2 then
							local BulletHole = str2:FindFirstChild("BulletHole")

							if BulletHole and BulletHole:IsA("Part") then
								u130(BulletHole)
							end
						end
					end
				end)()
			end

			local v146 = v28:Section({
				Name = "Sounds",
				Side = 2,
			})
			local t30 = {
				Enabled = false,
				SoundId = "rbxassetid://85340682645435",
				Volume = 1,
			}
			local t31 = {
				Primordial = "rbxassetid://85340682645435",
				Neverlose = "rbxassetid://18391691942",
				rifk7 = "rbxassetid://76064874887167",
				BameWare = "rbxassetid://92614567965693",
			}
			local Sound = Instance.new("Sound")

			Sound.SoundId = t30.SoundId
			Sound.Volume = t30.Volume
			Sound.Parent = game:GetService("SoundService")

			local n1 = 0
			local t32 = {
				Enabled = false,
				SoundId = "rbxassetid://6932519682",
				Volume = 1,
			}
			local t33 = {
				Fortinate = "rbxassetid://6932519682",
				Spongebob = "rbxassetid://8904888220",
				Soccer = "rbxassetid://9125967088",
				IDK = "rbxassetid://129056055970493",
				Bruh = "rbxassetid://6349641063",
			}
			local Sound2 = Instance.new("Sound")

			Sound2.SoundId = t32.SoundId
			Sound2.Volume = t32.Volume
			Sound2.Parent = game:GetService("SoundService")

			local n2 = 100
			local t34 = {
				Name = "Hitsound",
				Flag = "HitSoundEnabled",
				Default = false,
			}
			local u156 = t30

			function t34.Callback(p32)
				u156.Enabled = p32
			end

			v146:Toggle(t34)

			local t35 = {
				Name = "Hit Sound",
				Items = {
					"Primordial",
					"Neverlose",
					"rifk7",
					"BameWare",
				},
				Flag = "HitSoundType",
				Default = "Primordial",
			}
			local u158 = t30
			local u159 = t31
			local u160 = Sound

			function t35.Callback(p33)
				u158.SoundId = u159[p33]
				u160.SoundId = u159[p33]
			end

			v146:Dropdown(t35)

			local t36 = {
				Name = "Hit Volume",
				Flag = "HitSoundVolume",
				Min = 1,
				Max = 10,
				Default = 1,
				Decimals = 1,
			}
			local u162 = t30
			local u163 = Sound

			function t36.Callback(p34)
				u162.Volume = p34
				u163.Volume = p34
			end

			v146:Slider(t36)

			local t37 = {
				Name = "Deathsound",
				Flag = "DeathSoundEnabled",
				Default = false,
			}
			local u165 = t32

			function t37.Callback(p35)
				u165.Enabled = p35
			end

			v146:Toggle(t37)

			local t38 = {
				Name = "Death Sound",
				Items = {
					"Fortinate",
					"Spongebob",
					"Soccer",
					"IDK",
					"Bruh",
				},
				Flag = "DeathSoundType",
				Default = "Fortinate",
			}
			local u167 = t32
			local u168 = t33
			local u169 = Sound2

			function t38.Callback(p36)
				u167.SoundId = u168[p36]
				u169.SoundId = u168[p36]
			end

			v146:Dropdown(t38)

			local t39 = {
				Name = "Death Volume",
				Flag = "DeathSoundVolume",
				Min = 1,
				Max = 10,
				Default = 1,
				Decimals = 1,
			}
			local u171 = t32
			local u172 = Sound2

			function t39.Callback(p37)
				u171.Volume = p37
				u172.Volume = p37
			end

			v146:Slider(t39)

			local Changed = game:GetService("Players").LocalPlayer.PlayerStates.Damage.Changed
			local u174 = t30
			local u175 = Sound

			Changed:Connect(function(p38)
				if u174.Enabled and p38 > n1 then
					u175:Play()
				end

				n1 = p38
			end)

			local CharacterAdded = LocalPlayer2.CharacterAdded
			local u177 = t32
			local u178 = Sound2

			CharacterAdded:Connect(function(p39)
				p39:WaitForChild("Humanoid").HealthChanged:Connect(function(p40)
					if u177.Enabled and p40 <= 0 and n2 > 0 then
						u178:Play()
					end

					n2 = p40
				end)
			end)
			v179 = v28:Section({
				Name = "World",
				Side = 2,
			})
			t40 = {
				Enabled = false,
				ClockTime = 12,
				Technology = "Legacy",
				fogenabled = false,
				fogslider = 1000,
				Color = Color3.fromRGB(255, 255, 255),
				FogColor = Color3.fromRGB(255, 255, 255),
			}

			local t41 = {
				Name = "Ambient Color",
				Flag = "WorldColorEnabled",
				Default = false,
			}
			local u182 = t40

			function t41.Callback(p41)
				u182.Enabled = p41

				if not p41 then
					game.Lighting.Ambient = Color3.fromRGB(127, 127, 127)
					game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
					game.Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
					game.Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
					game.Lighting.ClockTime = 12

					return
				end

				game.Lighting.Ambient = u182.Color
				game.Lighting.OutdoorAmbient = u182.Color
				game.Lighting.ColorShift_Bottom = u182.Color
				game.Lighting.ColorShift_Top = u182.Color
				game.Lighting.ClockTime = u182.ClockTime
			end

			local v183 = v179:Toggle(t41)
			local t42 = {
				Name = "Ambient Color",
				Flag = "WorldAmbientColor",
				Default = Color3.fromRGB(255, 255, 255),
			}
			local u185 = t40

			function t42.Callback(p42)
				u185.Color = p42

				if u185.Enabled then
					game.Lighting.Ambient = p42
					game.Lighting.OutdoorAmbient = p42
					game.Lighting.ColorShift_Bottom = p42
					game.Lighting.ColorShift_Top = p42
				end
			end

			v183:Colorpicker(t42)
		end

		local t43 = {
			Name = "Time-Clock",
			Flag = "WorldAmbientClockTime",
			Min = 0,
			Max = 24,
			Default = 12,
			Decimals = 1,
		}
		local u187 = t40

		function t43.Callback(p43)
			u187.ClockTime = p43

			if u187.Enabled then
				game.Lighting.ClockTime = p43
			end
		end

		v179:Slider(t43)

		local t44 = {
			Name = "Lighting Technology",
			Items = {
				"Legacy",
				"Future",
				"ShadowMap",
				"Voxel",
			},
			Flag = "WorldAmbientTechnology",
			Default = "Legacy",
		}
		local u189 = t40

		function t44.Callback(p44)
			u189.Technology = p44

			if p44 ~= "Legacy" then
				if p44 ~= "Future" then
					if p44 ~= "Voxel" then
						if p44 == "ShadowMap" then
							game.Lighting.Technology = Enum.Technology.ShadowMap
						end

						return
					end

					game.Lighting.Technology = Enum.Technology.Voxel

					return
				end

				game.Lighting.Technology = Enum.Technology.Future

				return
			end

			game.Lighting.Technology = Enum.Technology.Legacy
		end

		v179:Dropdown(t44)

		local v190 = v28:Section({
			Name = "Knife-Changer",
			Side = 1,
		})
		local Import = game:GetService("ReplicatedStorage"):WaitForChild("Import")
		local Viewmodels = Import:WaitForChild("Guns"):WaitForChild("Viewmodels")
		local Skins = Import.Assets.Skins
		local t45 = {
			Default = nil,
			Karambit = "v_Karambit",
			Butterfly = "v_ButterflyKnife",
			Bayonet = "v_Bayonet",
			Talon = "v_talon",
			Bowie = "v_bowie",
			Stiletto = "v_stiletto",
			Ursus = "v_ursus",
		}
		local s1 = "Default | Default"
		local t46 = {}
		local u197 = Viewmodels
		local u198 = Skins
		local u199 = Viewmodels
		local u200 = Skins
		local u201 = Viewmodels
		local u202 = Skins
		local u203 = Viewmodels
		local u204 = Skins
		local u205 = t45
		local u206 = Viewmodels

		local function u207(p45)
			for _, v in ipairs({
				"v_CTKnife",
				"v_TKnife",
			}) do
				local v2 = u197:FindFirstChild(v)

				if v2 and v2:FindFirstChild("New Karambit") then
					local v490 = v2["New Karambit"]
					local t47 = {}
					local v492 = v490:FindFirstChild("weapons/models/knife/kn...pon_knife_karambit.v.001")

					if v492 then
						table.insert(t47, v492)

						for _, child in ipairs(v492:GetChildren()) do
							if child:IsA("Part") or child:IsA("MeshPart") then
								table.insert(t47, child)
							end
						end
					end

					local v495 = v490:FindFirstChild("weapons/models/knife/kn...weapon_knife_karambit.v2")

					if v495 then
						table.insert(t47, v495)

						for _, child in ipairs(v495:GetChildren()) do
							if child:IsA("Part") or child:IsA("MeshPart") then
								table.insert(t47, child)
							end
						end
					end

					local v498 = v490:FindFirstChild("weapons/models/knife/kn.../weapon_knife_karambit.v")

					if v498 then
						table.insert(t47, v498)

						for _, child in ipairs(v498:GetChildren()) do
							if child:IsA("Part") or child:IsA("MeshPart") then
								table.insert(t47, child)
							end
						end
					end

					local v501 = v490:FindFirstChild("weapons/models/knife/kn...pon_knife_karambit.vmdl_")

					if v501 then
						table.insert(t47, v501)

						for _, child in ipairs(v501:GetChildren()) do
							if child:IsA("Part") or child:IsA("MeshPart") then
								table.insert(t47, child)
							end
						end
					end

					if p45 == "Default" then
					end

					local p45_2 = u198.karambit:FindFirstChild(p45)

					for _, v4 in ipairs(t47) do
						if v4 then
							for _, child in ipairs(v4:GetChildren()) do
								if child:IsA("SurfaceAppearance") then
									child:Destroy()
								end
							end

							if p45_2 then
								local SurfaceAppearance = p45_2:FindFirstChildOfClass("SurfaceAppearance")

								if SurfaceAppearance then
									SurfaceAppearance:Clone().Parent = v4
								end
							end
						end
					end
				end
			end
		end
		local function u208(p46)
			for _, v in ipairs({
				"v_CTKnife",
				"v_TKnife",
			}) do
				local v5 = u199:FindFirstChild(v)

				if v5 and v5:FindFirstChild("Butterfly") then
					local Butterfly = v5.Butterfly

					if p46 == "Default" then
					end

					local p46_2 = u200.butterflyknife:FindFirstChild(p46)
					local t48 = {}
					local v517 = Butterfly:FindFirstChild("body_legacy_weapon_knife_butterfly.002")
					local body_legacy_weapon_knife_butterfly = Butterfly:FindFirstChild("body_legacy_weapon_knife_butterfly")
					local Latch = Butterfly.Latch
					local Blade = Butterfly.Blade

					t48[1] = v517
					t48[2] = body_legacy_weapon_knife_butterfly
					t48[3] = Latch
					t48[4] = Blade

					for _, v6 in ipairs(t48) do
						if v6 then
							for _, child in ipairs(v6:GetChildren()) do
								if child:IsA("SurfaceAppearance") then
									child:Destroy()
								end
							end

							if p46_2 then
								local SurfaceAppearance = p46_2:FindFirstChildOfClass("SurfaceAppearance")

								if SurfaceAppearance then
									SurfaceAppearance:Clone().Parent = v6
								end
							end
						end
					end
				end
			end
		end
		local function u209(p47)
			for _, v in ipairs({
				"v_CTKnife",
				"v_TKnife",
			}) do
				local v7 = u203:FindFirstChild(v)

				if v7 and v7:FindFirstChild("Talon") then
					local Talon = v7.Talon

					if p47 == "Default" then
					end

					local p47_2 = u204.talon:FindFirstChild(p47)
					local t49 = {}
					local v547 = Talon:FindFirstChild("weapons/models/knife/kn..._knife_talon.vmdl_c.body")

					if v547 then
						table.insert(t49, v547)

						for _, child in ipairs(v547:GetChildren()) do
							if child:IsA("Part") or child:IsA("MeshPart") then
								table.insert(t49, child)
							end
						end
					end

					for _, child in ipairs(Talon:GetChildren()) do
						if (child:IsA("Part") or child:IsA("MeshPart")) and child ~= v547 then
							table.insert(t49, child)
						end
					end

					for _, v11 in ipairs(t49) do
						if v11 then
							for _, child in ipairs(v11:GetChildren()) do
								if child:IsA("SurfaceAppearance") then
									child:Destroy()
								end
							end

							if p47_2 then
								local SurfaceAppearance = p47_2:FindFirstChildOfClass("SurfaceAppearance")

								if SurfaceAppearance then
									SurfaceAppearance:Clone().Parent = v11
								end
							end
						end
					end
				end
			end
		end
		local function u210(p48)
			for _, v in ipairs({
				"v_CTKnife",
				"v_TKnife",
			}) do
				local v12 = u201:FindFirstChild(v)

				if v12 and v12:FindFirstChild("stilleto") then
					local stilleto = v12.stilleto

					if p48 == "Default" then
					end

					local p48_2 = u202.stiletto:FindFirstChild(p48)
					local t50 = {}
					local Blade = stilleto.Blade
					local Handle = stilleto.Handle

					t50[1] = Blade
					t50[2] = Handle

					for _, v13 in ipairs(t50) do
						if v13 then
							for _, child in ipairs(v13:GetChildren()) do
								if child:IsA("SurfaceAppearance") then
									child:Destroy()
								end
							end

							if p48_2 then
								local SurfaceAppearance = p48_2:FindFirstChildOfClass("SurfaceAppearance")

								if SurfaceAppearance then
									SurfaceAppearance:Clone().Parent = v13
								end
							end
						end
					end
				end
			end
		end
		local function v211(p49, p50)
			local v559 = u205[p49]

			for _, v in pairs(t46) do
				local v14 = u206:FindFirstChild(v)

				if v14 then
					v14.Name = v
				end
			end

			t46 = {}

			if v559 then
				local v563 = u206:FindFirstChild(v559)

				if v563 then
					local v_CTKnife = u206:FindFirstChild("v_CTKnife")

					if v_CTKnife then
						v_CTKnife.Name = "temp_ct_old"

						local _ = v559 .. "_CT"
						local clone = v563:Clone()

						clone.Name = "v_CTKnife"
						clone.Parent = u206
						t46.CT = "temp_ct_old"
						v_CTKnife.Name = "temp_ct_old"
					end
				end

				local v568 = u206:FindFirstChild(v559)

				if v568 then
					local v_TKnife = u206:FindFirstChild("v_TKnife")

					if v_TKnife then
						v_TKnife.Name = "temp_t_old"

						local _ = v559 .. "_T"
						local clone = v568:Clone()

						clone.Name = "v_TKnife"
						clone.Parent = u206
						t46.T = "temp_t_old"
						v_TKnife.Name = "temp_t_old"
					end
				end

				task.wait(0.1)

				if p49 ~= "Karambit" then
					if p49 ~= "Butterfly" then
						if p49 ~= "Talon" then
							if p49 == "Stiletto" then
								u210(p50)
							end

							return
						end

						u209(p50)

						return
					end

					u208(p50)

					return
				end

				u207(p50)

				return
			end

			local v_CTKnife = u206:FindFirstChild("v_CTKnife")
			local v_TKnife = u206:FindFirstChild("v_TKnife")

			if v_CTKnife then
				v_CTKnife.Name = "v_CTKnife"
			end

			if v_TKnife then
				v_TKnife.Name = "v_TKnife"
			end
		end

		local t51 = {
			"Default | Default",
			"Karambit | Default",
			"Karambit | Blood Moo",
			"Karambit | Doppleer Sapphire",
			"Butterfly | Default",
			"Butterfly | Doppler Emerald",
			"Butterfly | Doppler Ruby",
			"Butterfly | Doppler Purple Dream",
			"Butterfly | Doppler Sapphire",
			"Butterfly | Gamma Doppler Phase 4",
			"Butterfly | Sandstone",
			"Butterfly | Vespera",
			"Butterfly | Supporter",
			"Talon | Default",
			"Talon | Sea Drift",
			"Talon | Marble Fade",
			"Talon | Doppler Phase 1",
			"Talon | Doppler Emerald",
			"Stiletto | Default",
			"Stiletto | Doppler Phase 1",
			"Stiletto | Doppler Sapphire",
			"Bayonet | Default",
			"Bowie | Default",
			"Ursus | Default",
		}
		local t52 = {
			Name = "Type",
			Items = t51,
			Default = "Default | Default",
		}
		local u214 = v211

		function t52.Callback(p51)
			s1 = p51

			local v576, v577 = p51:match("(.+) | (.+)")

			u214(v576, v577)
		end

		v190:Dropdown(t52)

		local CharacterRemoving = game:GetService("Players").LocalPlayer.CharacterRemoving
		local u216 = v211

		CharacterRemoving:Connect(function()
			task.wait(2)

			local v578, v579 = s1:match("(.+) | (.+)")

			u216(v578, v579)
		end)
		v217 = v28:Section({
			Name = "Glove-Changer",
			Side = 1,
		})

		local Import2 = game:GetService("ReplicatedStorage"):WaitForChild("Import")

		Gloves = Import2:WaitForChild("Assets"):WaitForChild("Gloves")

		local T = Import2:WaitForChild("Guns"):WaitForChild("Viewmodels"):WaitForChild("Teams"):WaitForChild("T")
		local Arms2 = T:WaitForChild("Arms2")
		local Arms1 = T:WaitForChild("Arms1")

		t53 = {}

		local Glove = Arms2:WaitForChild("Right Arm"):WaitForChild("Glove")
		local Glove2 = Arms2:WaitForChild("Left Arm"):WaitForChild("Glove")
		local Glove3 = Arms1:WaitForChild("Right Arm"):WaitForChild("Glove")
		local v227 = v1(Arms1:WaitForChild("Left Arm"):WaitForChild("Glove"))

		t53[1] = Glove
		t53[2] = Glove2
		t53[3] = Glove3;
		(function(p52, p53, p54, p55)
			for i = p55, p54.n do
				local v349 = p54[i]

				p52[i - p55 + p53] = v349
			end
		end)(t53, 4, v227, 1)
	end

	local t54 = {
		Default = nil,
		["King Crimson"] = "HandWraps King-Crimson",
		Leather = "HandWraps Leather",
		NightOps = "HandWraps NightOps",
		White = "HandWraps White-Out",
		Nigblack = "HandWraps Black-Out",
	}
	local s4 = "Default"
	local u230 = Gloves
	local u231 = t53

	local function u232(p56)
		if p56 and p56 ~= "Default" then
			local p56_2 = u230:FindFirstChild(p56)

			if p56_2 then
				local t55 = {}

				for _, descendant in ipairs(p56_2:GetDescendants()) do
					if descendant:IsA("Part") or descendant:IsA("MeshPart") then
						local SurfaceAppearance = descendant:FindFirstChildOfClass("SurfaceAppearance")

						if SurfaceAppearance then
							table.insert(t55, SurfaceAppearance)
						end
					end
				end

				return t55
			end

			return {}
		end

		return {}
	end

	local u233 = t54
	local u234 = t53

	local function u235(p57)
		for _, v in ipairs(u231) do
			if v then
				for _, child in ipairs(v:GetChildren()) do
					if child:IsA("SurfaceAppearance") then
						child:Destroy()
					end
				end
			end
		end

		if p57 ~= "Default" and p57 then
			local v591 = u232(u233[p57])

			if #v591 ~= 0 then
				for _, v in ipairs(u231) do
					if v then
						for _, v15 in ipairs(v591) do
							v15:Clone().Parent = v
						end
					end
				end

				return
			end

			warn("No SurfaceAppearance found for: " .. p57)

			return
		end
	end
	local function v236(p58)
		s4 = p58

		if p58 ~= "Default" then
			u235(p58)

			return
		end

		for _, v in ipairs(u234) do
			if v then
				for _, child in ipairs(v:GetChildren()) do
					if child:IsA("SurfaceAppearance") then
						child:Destroy()
					end
				end
			end
		end
	end

	local t56 = {
		"Default",
		"King Crimson",
		"Leather",
		"NightOps",
		"White",
		"Nigblack",
	}
	local t57 = {
		Name = "Glove Type",
		Items = t56,
		Default = "Default",
	}
	local u239 = v236

	function t57.Callback(p59)
		u239(p59)
	end

	v217:Dropdown(t57)

	local CharacterRemoving = game:GetService("Players").LocalPlayer.CharacterRemoving
	local u241 = v236

	CharacterRemoving:Connect(function()
		task.wait(2)

		if s4 ~= "Default" then
			u241(s4)
		end
	end)

	local spawn = task.spawn
	local u243 = v236

	spawn(function()
		task.wait(1)

		if s4 ~= "Default" then
			u243(s4)
		end
	end)

	local v244 = v28:Section({
		Name = "Weapons",
		Side = 1,
	})
	local Import = game:GetService("ReplicatedStorage"):WaitForChild("Import")
	local Viewmodels = Import:WaitForChild("Guns"):WaitForChild("Viewmodels")
	local ak47 = Import.Assets.Skins.ak47
	local t58 = {}
	local MagNew = Viewmodels.v_AK47.ak47.MagNew
	local HandleNew = Viewmodels.v_AK47.ak47.HandleNew
	local BoltNew = Viewmodels.v_AK47.ak47.BoltNew

	t58[1] = MagNew
	t58[2] = HandleNew
	t58[3] = BoltNew

	local t59 = {
		"Default",
		"Well Worn",
		"VantaBlack",
		"Vanta Black",
		"Sandsoul",
		"LIBERTYWALK",
		"HorribleV2",
		"Horrible",
		"Frost Beast",
		"DoodleAWhite",
		"DoodleAJob",
		"Cody Special",
		"Booster",
		"Baddie Wit Da Flowers",
	}
	local s5 = "Default"
	local u254 = t58

	local function u255()
		for _, v in ipairs(u254) do
			if v then
				for _, child in ipairs(v:GetChildren()) do
					if child:IsA("SurfaceAppearance") then
						child:Destroy()
					end
				end
			end
		end
	end

	local u256 = ak47
	local u257 = t58

	local function v258(p60)
		u255()

		if p60 ~= "Default" then
			local p60_2 = u256:FindFirstChild(p60)

			if p60_2 then
				local t60 = {}

				for _, descendant in ipairs(p60_2:GetDescendants()) do
					if descendant:IsA("SurfaceAppearance") then
						table.insert(t60, descendant)
					end
				end

				if #t60 > 0 then
					for _, v in ipairs(u257) do
						if v then
							for _, v16 in ipairs(t60) do
								v16:Clone().Parent = v
							end
						end
					end
				end

				return
			end

			warn("AK-47 skin not found: " .. p60)

			return
		end
	end
	local t61 = {
		Name = "AK-47 Skin",
		Items = t59,
		Default = "Default",
	}
	local u261 = v258

	function t61.Callback(p61)
		s5 = p61
		u261(p61)
	end

	v244:Dropdown(t61)

	local CharacterRemoving2 = game:GetService("Players").LocalPlayer.CharacterRemoving
	local u263 = v258

	CharacterRemoving2:Connect(function()
		task.wait(2)

		if s5 ~= "Default" then
			local v617 = s5

			s5 = s5
			u263(v617)
		end
	end)

	local spawn2 = task.spawn
	local u265 = v258

	spawn2(function()
		task.wait(1)

		if s5 ~= "Default" then
			local v618 = s5

			s5 = s5
			u265(v618)
		end
	end)
	v29:Section({
		Name = "Movement",
		Side = 2,
	}):Toggle({
		Name = "Bunny-Hope",
		Flag = "BhopEnabled",
		Default = false,
		Callback = function(p62)
			_G.BhopEnabled = p62

			if not p62 then
				if _G.BhopConn then
					_G.BhopConn:Disconnect()
					_G.BhopConn = nil
				end

				return
			end

			local MovementBindables = game:GetService("ReplicatedStorage").MovementBindables
			local RunService = game:GetService("RunService")
			local LocalPlayer4 = game:GetService("Players").LocalPlayer
			local UserInputService = game:GetService("UserInputService")
			local v624 = getconnections(MovementBindables.forceCrouch.Event)[1]
			local u625 = debug.getupvalue(v624.Function, 1)

			for i = 1, 10 do
				local v627 = debug.getupvalue(u625, i)

				if type(v627) == "table" and v627.velocity then
					v627.velocity.jumpRequestCooldown = 0

					break
				end
			end

			MovementBindables.setProperty:Fire("autoBunnyHopping", true)
			MovementBindables.setProperty:Fire("bunnyHoppingEnabled", true)

			if _G.BhopConn then
				_G.BhopConn:Disconnect()
			end
			local Heartbeat = RunService.Heartbeat
			local u630 = LocalPlayer4

			_G.BhopConn = Heartbeat:Connect(function()
				if _G.BhopEnabled then
					local Character = u630.Character

					if Character and Character:FindFirstChild("Humanoid") then
						local Humanoid = Character.Humanoid

						if UserInputService:IsKeyDown(Enum.KeyCode.Space) and Humanoid.FloorMaterial ~= Enum.Material.Air then
							pcall(function()
								u625("jump", Enum.UserInputState.Begin)
							end)
						end
					end

					return
				end
			end)
		end,
	})
	t62 = {
		Enabled = false,
		Color = Color3.fromRGB(255, 0, 0),
		Thickness = 2,
		Transparency = 1,
	}
	t63 = {
		Enabled = false,
		Color = Color3.fromRGB(255, 0, 0),
		Thickness = 2,
		Transparency = 1,
	}
	t64 = {}

	local u269 = t64
	local u270 = t62

	function v271()
		for _, v in pairs(u269) do
			if v and v.boxLines then
				for _, v17 in pairs(v.boxLines) do
					if v17 then
						v17.Color = u270.Color
						v17.Thickness = u270.Thickness
						v17.Transparency = u270.Transparency
					end
				end
			end
		end
	end

	local u272 = t64
	local u273 = t63

	function v274()
		for _, v in pairs(u272) do
			if v and v.tracerLine then
				local tracerLine = v.tracerLine

				if tracerLine then
					tracerLine.Color = u273.Color
					tracerLine.Thickness = u273.Thickness
					tracerLine.Transparency = u273.Transparency
				end
			end
		end
	end

	Players = game:GetService("Players")
	LocalPlayer = Players.LocalPlayer
	CurrentCamera = game:GetService("Workspace").CurrentCamera

	local u278 = t62

	function v279()
		local drawing = Drawing.new("Line")

		drawing.Visible = false
		drawing.From = Vector2.new(0, 0)
		drawing.To = Vector2.new(1, 1)
		drawing.Color = u278.Color
		drawing.Thickness = u278.Thickness
		drawing.Transparency = u278.Transparency

		return drawing
	end

	_pairs = pairs
	v281 = v1(Players:GetChildren())
end

for _, v283 in _pairs(unpack(v281, 1, v281.n)) do
	if v283 ~= LocalPlayer then
		local v286

		do
			local v284

			if not v283 or not v283:FindFirstChild("PlayerStates") or not v283.PlayerStates:FindFirstChild("Team") then
				v284 = nil
			else
				v284 = v283.PlayerStates.Team.Value
			end

			local v285

			if not LocalPlayer or not LocalPlayer:FindFirstChild("PlayerStates") or not LocalPlayer.PlayerStates:FindFirstChild("Team") then
				v285 = nil
			else
				v285 = LocalPlayer.PlayerStates.Team.Value
			end

			if not v284 or not v285 then
				v286 = false
			else
				v286 = v284 == v285
			end
		end

		if not v286 then
			local u288, u289

			do
				local t65 = {
					line1 = v279(),
					line2 = v279(),
					line3 = v279(),
					line4 = v279(),
					line5 = v279(),
					line6 = v279(),
					line7 = v279(),
					line8 = v279(),
					line9 = v279(),
					line10 = v279(),
					line11 = v279(),
					line12 = v279(),
					Tracer = v279(),
				}

				t65.Tracer.Color = t63.Color
				t65.Tracer.Thickness = t63.Thickness
				t65.Tracer.Transparency = t63.Transparency
				t64[v283] = {
					boxLines = t65,
					tracerLine = t65.Tracer,
				}
				u288 = v283
				u289 = t65
			end

			local u290 = LocalPlayer
			local u291 = CurrentCamera
			local u292 = t62
			local u293 = t63

			coroutine.wrap(function()
				game:GetService("RunService").RenderStepped:Connect(function()
					if u288 and u288.Character then
						local Character = u288.Character
						local Humanoid = Character:FindFirstChildOfClass("Humanoid")
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if Humanoid and HumanoidRootPart and not (Humanoid.Health <= 0) then
							local v686 = u290
							local v687

							if not u288 or not u288:FindFirstChild("PlayerStates") or not u288.PlayerStates:FindFirstChild("Team") then
								v687 = nil
							else
								v687 = u288.PlayerStates.Team.Value
							end
							local v688

							if not v686 or not v686:FindFirstChild("PlayerStates") or not v686.PlayerStates:FindFirstChild("Team") then
								v688 = nil
							else
								v688 = v686.PlayerStates.Team.Value
							end
							local v689

							if not v687 or not v688 then
								v689 = false
							else
								v689 = v687 == v688
							end

							if not v689 then
								local _, v691 = u291:WorldToViewportPoint(HumanoidRootPart.Position)

								if not v691 then
									for _, v in pairs(u289) do
										v.Visible = false
									end

									return
								end

								local vector3 = Vector3.new(2, 3, 2)
								local v695 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, vector3.Y, -vector3.Z)).p)
								local v696 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, vector3.Y, vector3.Z)).p)
								local v697 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, vector3.Y, vector3.Z)).p)
								local v698 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, vector3.Y, -vector3.Z)).p)
								local v699 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, -vector3.Y, -vector3.Z)).p)
								local v700 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, -vector3.Y, vector3.Z)).p)
								local v701 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, -vector3.Y, vector3.Z)).p)
								local v702 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, -vector3.Y, -vector3.Z)).p)

								u289.line1.From = Vector2.new(v695.X, v695.Y)
								u289.line1.To = Vector2.new(v696.X, v696.Y)
								u289.line2.From = Vector2.new(v696.X, v696.Y)
								u289.line2.To = Vector2.new(v697.X, v697.Y)
								u289.line3.From = Vector2.new(v697.X, v697.Y)
								u289.line3.To = Vector2.new(v698.X, v698.Y)
								u289.line4.From = Vector2.new(v698.X, v698.Y)
								u289.line4.To = Vector2.new(v695.X, v695.Y)
								u289.line5.From = Vector2.new(v699.X, v699.Y)
								u289.line5.To = Vector2.new(v700.X, v700.Y)
								u289.line6.From = Vector2.new(v700.X, v700.Y)
								u289.line6.To = Vector2.new(v701.X, v701.Y)
								u289.line7.From = Vector2.new(v701.X, v701.Y)
								u289.line7.To = Vector2.new(v702.X, v702.Y)
								u289.line8.From = Vector2.new(v702.X, v702.Y)
								u289.line8.To = Vector2.new(v699.X, v699.Y)
								u289.line9.From = Vector2.new(v699.X, v699.Y)
								u289.line9.To = Vector2.new(v695.X, v695.Y)
								u289.line10.From = Vector2.new(v700.X, v700.Y)
								u289.line10.To = Vector2.new(v696.X, v696.Y)
								u289.line11.From = Vector2.new(v701.X, v701.Y)
								u289.line11.To = Vector2.new(v697.X, v697.Y)
								u289.line12.From = Vector2.new(v702.X, v702.Y)
								u289.line12.To = Vector2.new(v698.X, v698.Y)

								local v703 = u291:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(0, -vector3.Y, 0)).p)

								u289.Tracer.From = Vector2.new(u291.ViewportSize.X / 2, u291.ViewportSize.Y)
								u289.Tracer.To = Vector2.new(v703.X, v703.Y)

								for _, v in pairs(u289) do
									if v == u289.Tracer then
										v.Color = u293.Color
										v.Thickness = u293.Thickness
										v.Transparency = u293.Transparency
									else
										v.Color = u292.Color
										v.Thickness = u292.Thickness
										v.Transparency = u292.Transparency
									end
								end

								if u290.Character and u290.Character:FindFirstChild("HumanoidRootPart") then
									local v706 = 1 / (u290.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude * 100
									local v707 = math.clamp(v706, 0.1, 4)

									for _, v in pairs(u289) do
										v.Thickness = v707
									end
								end

								for _, v in pairs(u289) do
									if v == u289.Tracer then
										v.Visible = u293.Enabled
									else
										v.Visible = u292.Enabled
									end
								end

								return
							end

							for _, v in pairs(u289) do
								v.Visible = false
							end

							return
						end

						for _, v in pairs(u289) do
							v.Visible = false
						end

						return
					end

					for _, v in pairs(u289) do
						v.Visible = false
					end
				end)
			end)()
		end
	end
end

local PlayerAdded = Players.PlayerAdded
local u295 = LocalPlayer
local u296 = v279
local u297 = t63
local u298 = t64
local u299 = CurrentCamera
local u300 = t62

PlayerAdded:Connect(function(p63)
	if p63 ~= u295 then
		local v645 = u295
		local v646

		if not p63 or not p63:FindFirstChild("PlayerStates") or not p63.PlayerStates:FindFirstChild("Team") then
			v646 = nil
		else
			v646 = p63.PlayerStates.Team.Value
		end
		local v647

		if not v645 or not v645:FindFirstChild("PlayerStates") or not v645.PlayerStates:FindFirstChild("Team") then
			v647 = nil
		else
			v647 = v645.PlayerStates.Team.Value
		end
		local v648

		if not v646 or not v647 then
			v648 = false
		else
			v648 = v646 == v647
		end

		if not v648 then
			local t66 = {
				line1 = u296(),
				line2 = u296(),
				line3 = u296(),
				line4 = u296(),
				line5 = u296(),
				line6 = u296(),
				line7 = u296(),
				line8 = u296(),
				line9 = u296(),
				line10 = u296(),
				line11 = u296(),
				line12 = u296(),
				Tracer = u296(),
			}

			t66.Tracer.Color = u297.Color
			t66.Tracer.Thickness = u297.Thickness
			t66.Tracer.Transparency = u297.Transparency
			u298[p63] = {
				boxLines = t66,
				tracerLine = t66.Tracer,
			}

			local u650 = p63
			local u651 = t66

			coroutine.wrap(function()
				game:GetService("RunService").RenderStepped:Connect(function()
					if u650 and u650.Character then
						local Character = u650.Character
						local Humanoid = Character:FindFirstChildOfClass("Humanoid")
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if Humanoid and HumanoidRootPart and not (Humanoid.Health <= 0) then
							local v722 = u295
							local v723

							if not u650 or not u650:FindFirstChild("PlayerStates") or not u650.PlayerStates:FindFirstChild("Team") then
								v723 = nil
							else
								v723 = u650.PlayerStates.Team.Value
							end
							local v724

							if not v722 or not v722:FindFirstChild("PlayerStates") or not v722.PlayerStates:FindFirstChild("Team") then
								v724 = nil
							else
								v724 = v722.PlayerStates.Team.Value
							end
							local v725

							if not v723 or not v724 then
								v725 = false
							else
								v725 = v723 == v724
							end

							if not v725 then
								local _, v727 = u299:WorldToViewportPoint(HumanoidRootPart.Position)

								if not v727 then
									for _, v in pairs(u651) do
										v.Visible = false
									end

									return
								end

								local vector3 = Vector3.new(2, 3, 2)
								local v731 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, vector3.Y, -vector3.Z)).p)
								local v732 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, vector3.Y, vector3.Z)).p)
								local v733 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, vector3.Y, vector3.Z)).p)
								local v734 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, vector3.Y, -vector3.Z)).p)
								local v735 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, -vector3.Y, -vector3.Z)).p)
								local v736 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(-vector3.X, -vector3.Y, vector3.Z)).p)
								local v737 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, -vector3.Y, vector3.Z)).p)
								local v738 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(vector3.X, -vector3.Y, -vector3.Z)).p)

								u651.line1.From = Vector2.new(v731.X, v731.Y)
								u651.line1.To = Vector2.new(v732.X, v732.Y)
								u651.line2.From = Vector2.new(v732.X, v732.Y)
								u651.line2.To = Vector2.new(v733.X, v733.Y)
								u651.line3.From = Vector2.new(v733.X, v733.Y)
								u651.line3.To = Vector2.new(v734.X, v734.Y)
								u651.line4.From = Vector2.new(v734.X, v734.Y)
								u651.line4.To = Vector2.new(v731.X, v731.Y)
								u651.line5.From = Vector2.new(v735.X, v735.Y)
								u651.line5.To = Vector2.new(v736.X, v736.Y)
								u651.line6.From = Vector2.new(v736.X, v736.Y)
								u651.line6.To = Vector2.new(v737.X, v737.Y)
								u651.line7.From = Vector2.new(v737.X, v737.Y)
								u651.line7.To = Vector2.new(v738.X, v738.Y)
								u651.line8.From = Vector2.new(v738.X, v738.Y)
								u651.line8.To = Vector2.new(v735.X, v735.Y)
								u651.line9.From = Vector2.new(v735.X, v735.Y)
								u651.line9.To = Vector2.new(v731.X, v731.Y)
								u651.line10.From = Vector2.new(v736.X, v736.Y)
								u651.line10.To = Vector2.new(v732.X, v732.Y)
								u651.line11.From = Vector2.new(v737.X, v737.Y)
								u651.line11.To = Vector2.new(v733.X, v733.Y)
								u651.line12.From = Vector2.new(v738.X, v738.Y)
								u651.line12.To = Vector2.new(v734.X, v734.Y)

								local v739 = u299:WorldToViewportPoint((HumanoidRootPart.CFrame * CFrame.new(0, -vector3.Y, 0)).p)

								u651.Tracer.From = Vector2.new(u299.ViewportSize.X / 2, u299.ViewportSize.Y)
								u651.Tracer.To = Vector2.new(v739.X, v739.Y)

								for _, v in pairs(u651) do
									if v == u651.Tracer then
										v.Color = u297.Color
										v.Thickness = u297.Thickness
										v.Transparency = u297.Transparency
									else
										v.Color = u300.Color
										v.Thickness = u300.Thickness
										v.Transparency = u300.Transparency
									end
								end

								if u295.Character and u295.Character:FindFirstChild("HumanoidRootPart") then
									local v742 = 1 / (u295.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude * 100
									local v743 = math.clamp(v742, 0.1, 4)

									for _, v in pairs(u651) do
										v.Thickness = v743
									end
								end

								for _, v in pairs(u651) do
									if v == u651.Tracer then
										v.Visible = u297.Enabled
									else
										v.Visible = u300.Enabled
									end
								end

								return
							end

							for _, v in pairs(u651) do
								v.Visible = false
							end

							return
						end

						for _, v in pairs(u651) do
							v.Visible = false
						end

						return
					end

					for _, v in pairs(u651) do
						v.Visible = false
					end
				end)
			end)()

			return
		end
	end
end)

local v301 = v28:Section({
	Name = "Drawing",
	Side = 1,
})
local t67 = {
	Name = "3D Box",
	Flag = "ESP_3DBox",
	Default = false,
}
local u303 = t62
local u304 = v271

function t67.Callback(p64)
	u303.Enabled = p64
	u304()
end

local v305 = v301:Toggle(t67)
local t68 = {
	Name = "Box Color",
	Flag = "ESP_3DBox_Color",
	Default = Color3.fromRGB(255, 0, 0),
}
local u307 = t62
local u308 = v271

function t68.Callback(p65)
	u307.Color = p65
	u308()
end

v305:Colorpicker(t68)

local t69 = {
	Name = "Lines",
	Flag = "ESP_Lines",
	Default = false,
}
local u310 = t63
local u311 = v274

function t69.Callback(p66)
	u310.Enabled = p66
	u311()
end

local v312 = v301:Toggle(t69)
local t70 = {
	Name = "Lines Color",
	Flag = "ESP_Lines_Color",
	Default = Color3.fromRGB(255, 0, 0),
}
local u314 = t63
local u315 = v274

function t70.Callback(p67)
	u314.Color = p67
	u315()
end

v312:Colorpicker(t70)

local Client = game:GetService("ReplicatedStorage"):WaitForChild("Import"):WaitForChild("GunWork"):WaitForChild("Client")
local t71 = {
	enable = false,
	gravity = false,
	jump = 110,
	run = 16,
}
local v318 = v29:Section({
	Name = "Grenade-Modifier",
	Side = 1,
})
local t72 = {
	Name = "Enabled",
	Flag = "ggdenable",
	Default = false,
}
local u320 = t71

function t72.Callback(p68)
	u320.enable = p68
end

v318:Toggle(t72)

local t73 = {
	Name = "Disable Gravity",
	Flag = "ggdgravity_0",
	Default = false,
}
local u322 = t71
local u323 = Client

function t73.Callback(p69)
	u322.gravity = p69

	if not p69 then
		u323.Grenades.Gravity.Value = 0.65

		return
	end

	u323.Grenades.Gravity.Value = 0
end

v318:Toggle(t73)

local t74 = {
	Name = "Jump Velocity Start",
	Flag = "jpvelocity_start",
	Min = 70,
	Max = 200,
	Default = 110,
	Decimals = 1,
}
local u325 = t71
local u326 = Client

function t74.Callback(p70)
	u325.jump = p70

	if u326.Grenades:FindFirstChild("Jump") then
		u326.Grenades.Jump.Value = p70
	end
end

v318:Slider(t74)

local t75 = {
	Name = "Speed VGena",
	Flag = "jpwjay",
	Min = 70,
	Max = 200,
	Default = 16,
	Decimals = 1,
}
local u328 = t71
local u329 = Client

function t75.Callback(p71)
	u328.run = p71

	if u329.Grenades:FindFirstChild("Run") then
		u329.Grenades.Run.Value = p71
	end
end

v318:Slider(t75)

local v330 = v29:Section({
	Name = "Server",
	Side = 2,
})
local LocalPlayer5 = game.Players.LocalPlayer
local u332 = LocalPlayer5.Character or LocalPlayer5.CharacterAdded:Wait()
local HumanoidRootPart = u332:WaitForChild("HumanoidRootPart")
local t76 = {
	enabled = false,
}

local function v335()
	for _, descendant in u332:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
		end
	end

	for _, child in ipairs(u332:GetChildren()) do
		if child:IsA("BasePart") and child ~= HumanoidRootPart then
			Instance.new("BodyForce", child).Force = (child.Position - HumanoidRootPart.Position).Unit * -1333337
		end
	end

	for _, descendant in u332:GetDescendants() do
		if not descendant:IsA("BasePart") or descendant == HumanoidRootPart then
			if descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = 1
			end
		else
			descendant.Transparency = 1
		end
	end
end

local CharacterAdded = LocalPlayer5.CharacterAdded
local u337 = t76
local u338 = v335

CharacterAdded:Connect(function(p72)
	HumanoidRootPart = p72:WaitForChild("HumanoidRootPart")
	if u337.enabled then
		task.wait(1)
		u338()
	end
end)

local t77 = {
	Name = "Invinsible",
	Flag = "invinsible",
	Default = false,
}
local u340 = t76
local u341 = v335

local function u342()
	for _, descendant in u332:GetDescendants() do
		if not descendant:IsA("BasePart") then
			if descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = 0
			end
		else
			descendant.CanCollide = true

			if descendant ~= HumanoidRootPart then
				descendant.Transparency = 0
			end
		end
	end

	for _, child in ipairs(u332:GetChildren()) do
		if child:IsA("BasePart") then
			for _, child2 in ipairs(child:GetChildren()) do
				if child2:IsA("BodyForce") then
					child2:Destroy()
				end
			end
		end
	end
end

function t77.Callback(p73)
	u340.enabled = p73

	if not p73 then
		u342()

		return
	end

	u341()
end

v330:Toggle(t77)
Library:Notification("Loaded!", "Menu took " .. string.format("%.4f", os.clock() - LoadTick) .. " seconds to load", 5)
getgenv().Library = Library

return Library
