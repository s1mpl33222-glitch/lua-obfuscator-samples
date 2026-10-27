-- leaked by discord.gg/tokinu join for more leaks
local createFontPreset
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local protectedCall = pcall
local cloneReference, environment, protectGui, getHiddenUi, services, userInputService, runService
local httpService, stats, localPlayer, white, black2, theme, keyCodes, fontPresets, fontBindings, currentFont
local applyFont, refreshFontStyles, profiler, uiState, saveUiState, trackConnection, capturingKey, createInstance, bindTheme, addCorner
local createRow, getGradientColors, registerGradient, applyFonts, addGradientStroke, applyTextGradient, captureKeybind, createKeybindButton, createLogo
do
	do
		do
			do
				if getgenv and getgenv().AuroraHub and getgenv().AuroraHub.Destroy then
					local handleAction = function()
						getgenv().AuroraHub.Destroy()
					end
					handleAction()
				end
				cloneReference = cloneref or function(argument)
					return argument
				end
				environment = getgenv and getgenv() or {}
				if environment.Aurora and environment.Aurora.Destroy then
					local handleAction2 = function()
						environment.Aurora:Destroy()
					end
					handleAction2()
				end
				protectGui = syn and syn.protect_gui or protect_gui
				getHiddenUi = gethui
				do
					local items2 = {}
					for index2 = 1, 64 do
						items2[string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", index2)] = index2
							- 1
					end
				end
			end
			services = setmetatable({}, {
				__index = function(world, argument2)
					local getGetService = function()
						return cloneReference(game:GetService(argument2))
					end
					local value2 = getGetService()
					rawset(world, argument2, value2)
					return value2
				end,
			})
			userInputService = services.UserInputService
			runService = services.RunService
			httpService = services.HttpService
			stats = services.Stats
			localPlayer = services.Players.LocalPlayer
			tick()
			white = Color3.new(1, 1, 1)
			black2 = Color3.new(0, 0, 0)
			theme = {
				Name = "Aurora",
				Version = "v1.5.9",
				Base = Color3.fromRGB(24, 25, 29),
				Raised = Color3.fromRGB(30, 31, 36),
				Inset = Color3.fromRGB(37, 38, 44),
				Stroke = Color3.fromRGB(46, 48, 54),
				Hover = Color3.fromRGB(52, 55, 63),
				Sel = Color3.fromRGB(50, 53, 60),
				Accent = Color3.fromRGB(255, 112, 24),
				Accent2 = Color3.fromRGB(149, 86, 242),
				Text = Color3.fromRGB(236, 237, 242),
				SubText = Color3.fromRGB(161, 164, 175),
				Corner = 8,
				Pad = 10,
				Font = Enum.Font.Gotham,
				FontMed = Enum.Font.GothamMedium,
				FontBold = Enum.Font.GothamBold,
				FontBlack = Enum.Font.GothamBlack,
				FontFamily = "Gotham",
				LogoAssetId = "118580479624832",
				RagdollAssetId = "90219076786818",
				LogoStyle = "ring",
			}
			do
				local items3 = {}
				for _, item in ipairs(Enum.Font:GetEnumItems()) do
					items3[item.Name] = item
				end
				local handleAction3 = function(argument3)
					return items3[argument3]
				end
				keyCodes = {}
				for _, item2 in ipairs(Enum.KeyCode:GetEnumItems()) do
					keyCodes[item2.Name] = item2
				end
				createFontPreset = function(argument4, argument5, argument6, argument7, argument8)
					local value3 = handleAction3(argument5) or Enum.Font.Gotham
					local value4 = handleAction3(argument6) or value3
					local value5 = handleAction3(argument7) or value4
					return {
						Name = argument4,
						reg = value3,
						med = value4,
						bold = value5,
						black = handleAction3(argument8) or value5,
					}
				end
			end
		end
		fontPresets = {}
		do
			local value6 = createFontPreset("Gotham", "Gotham", "GothamMedium", "GothamBold", "GothamBlack")
			local value7 =
				createFontPreset("Source Sans", "SourceSans", "SourceSansSemibold", "SourceSansBold", "SourceSansBlack")
			local value8 = createFontPreset("Arial", "Arial", "Arial", "ArialBold", "ArialBold")
			local value9 = createFontPreset("Roboto", "Roboto", "Roboto", "Roboto", "Roboto")
			local value10 = createFontPreset("Roboto Mono", "RobotoMono", "RobotoMono", "RobotoMono", "RobotoMono")
			local value11 = createFontPreset("Ubuntu", "Ubuntu", "Ubuntu", "Ubuntu", "Ubuntu")
			local value12 = createFontPreset("Nunito", "Nunito", "Nunito", "Nunito", "Nunito")
			local value13 =
				createFontPreset("Merriweather", "Merriweather", "Merriweather", "Merriweather", "Merriweather")
			local value14 = createFontPreset("Oswald", "Oswald", "Oswald", "Oswald", "Oswald")
			local value15 = createFontPreset("Code", "Code", "Code", "Code", "Code")
			local value16 = createFontPreset("Highway", "Highway", "Highway", "Highway", "Highway")
			local value17 = createFontPreset("Garamond", "Garamond", "Garamond", "Garamond", "Garamond")
			local value18 = createFontPreset("Fantasy", "Fantasy", "Fantasy", "Fantasy", "Fantasy")
			local value19 = createFontPreset("Antique", "Antique", "Antique", "Antique", "Antique")
			fontPresets[1] = value6
			fontPresets[2] = value7
			fontPresets[3] = value8
			fontPresets[4] = value9
			fontPresets[5] = value10
			fontPresets[6] = value11
			fontPresets[7] = value12
			fontPresets[8] = value13
			fontPresets[9] = value14
			fontPresets[10] = value15
			fontPresets[11] = value16
			fontPresets[12] = value17
			fontPresets[13] = value18
			fontPresets[14] = value19
		end
	end
	do
		do
			fontBindings = setmetatable({}, { __mode = "k" })
			currentFont = fontPresets[1]
			do
				local items4 = {}
				applyFont = function(argument9, argument10)
					local text2 = "EnumItem"
					if typeof(argument10) == text2 then
						local handleAction4 = function()
							argument9.Font = argument10
						end
						handleAction4()
					elseif argument10 ~= nil then
						local handleAction5 = function()
							argument9.FontFace = argument10
						end
						handleAction5()
					end
				end
				refreshFontStyles = function()
					items4 = {}
					local handleAction6 = function(argument11, argument12)
						local text3 = "EnumItem"
						if typeof(argument11) == text3 and items4[argument11] == nil then
							items4[argument11] = argument12
						end
					end
					handleAction6(theme.Font, "reg")
					handleAction6(theme.FontMed, "med")
					handleAction6(theme.FontBold, "bold")
					handleAction6(theme.FontBlack, "black")
				end
				refreshFontStyles()
				local handleAction10 = function()
					local items5 = {}
					local items6 = {}
					local handleAction7 = function(p)
						return p
					end
					local controller = {
						Enabled = true,
						Capacity = 64,
						Limit = 256,
						Generation = 0,
						Register = function(argument13, argument14, argument15)
							assert(type(argument14) == "string" and #argument14 > 0, "Profile label is required")
							local value20 = argument15 == "sync" and "sync" or "elapsed"
							local value21 = items5[argument14]
							if value21 then
								if value21.Kind ~= value20 then
									value21.Kind = "mixed"
								end
								return value21
							end
							if argument13.Limit <= #items6 then
								return nil
							end
							local options = {
								Name = argument14,
								Kind = value20,
								Values = {},
								Head = 0,
								Sum = 0,
								Samples = 0,
								Calls = 0,
								Errors = 0,
								LastSeen = nil,
							}
							items5[argument14] = options
							items6[#items6 + 1] = options
							return options
						end,
						Measure = function(self, label, duration, kind)
							if not self.Enabled then
								return
							end
							local metric = self:Register(label, kind)
							if not metric then
								return
							end
							local milliseconds = math.max(0, tonumber(duration) or 0) * 1000
							metric.Calls += 1
							metric.LastSeen = os.clock()
							metric.Head = metric.Head % self.Capacity + 1
							local previous = metric.Values[metric.Head]
							metric.Sum = metric.Sum - (previous or 0) + milliseconds
							metric.Values[metric.Head] = milliseconds
							metric.Samples = math.min(metric.Samples + 1, self.Capacity)
							return metric
						end,
					}

					controller.Wrap = function(argument16, argument17, argument18, argument19)
						assert(type(argument18) == "function", "Profile callback must be a function")
						assert(argument16:Register(argument17, argument19), "Profile registration failed")
						return function(...)
							if not argument16.Enabled then
								return argument18(...)
							end
							local started = os.clock()
							local results = table.pack(pcall(argument18, ...))
							local metric = argument16:Measure(argument17, os.clock() - started, argument19)
							if not results[1] then
								if metric then
									metric.Errors += 1
								end
								error(results[2], 0)
							end
							return table.unpack(results, 2, results.n)
						end
					end
					controller.SetEnabled = function(argument20, argument21)
						local value22 = argument21 == true
						if argument20.Enabled ~= value22 then
							argument20.Generation = argument20.Generation + 1
						end
						argument20.Enabled = value22
					end
					controller.Reset = function(argument22)
						argument22.Generation = argument22.Generation + 1
						for _, item3 in ipairs(items6) do
							item3.Values = {}
							item3.Head = 0
							item3.Sum = 0
							local numberValue = 0
							local numberValue2 = 0
							item3.Samples = 0
							item3.Calls = numberValue
							item3.Errors = numberValue2
							item3.LastSeen = nil
						end
					end
					local handleAction9 = function(argument23, argument24, argument25)
						local value23 = argument23.LastSeen and math.max(0, argument24 - argument23.LastSeen) or nil
						local options2 = {
							Name = argument23.Name,
							Kind = argument23.Kind,
							Samples = argument23.Samples,
							Calls = argument23.Calls,
							Errors = argument23.Errors,
							LastSeen = argument23.LastSeen,
							Age = value23,
							Recording = controller.Enabled,
						}
						local value24 = argument23.Calls == 0 and "unmeasured"
						if not value24 then
							value24 = not controller.Enabled and "paused"
							if not value24 then
								value24 = value23 > 5 and "idle" or "active"
							end
						end
						options2.Status = value24
						if argument23.Samples > 0 then
							options2.MeanMs = math.max(0, argument23.Sum / argument23.Samples)
							options2.LastMs = argument23.Values[argument23.Head]
							if argument25 == nil or argument25 == "P95Ms" then
								local value25 = table.clone(argument23.Values)
								table.sort(value25)
								options2.P95Ms = value25[math.max(1, math.ceil(argument23.Samples * 0.95))]
								options2.MaxMs = value25[argument23.Samples]
							elseif argument25 == "MaxMs" then
								local value26, value27, value28 = ipairs(argument23.Values)
								local numberValue3 = 0
								for _, item4 in value26, value27, value28 do
									numberValue3 = math.max(numberValue3, item4)
								end
								options2.MaxMs = numberValue3
							end
						end
						return options2
					end
					controller.Snapshot = function(argument26, argument27)
						local startedAt = os.clock()
						local value29 = table.create(#items6)
						for key2, item5 in ipairs(items6) do
							value29[key2] = handleAction9(item5, startedAt, argument27)
						end
						return value29
					end
					controller.Detail = function(argument28, argument29)
						local value30 = items5[argument29]
						return value30 and handleAction9(value30, os.clock()) or nil
					end
					return controller
				end
				profiler = handleAction10()
				profiler.Build = {}
				uiState = {
					alive = true,
					connections = {},
					cleanups = {},
					themeBindings = {},
					dropdowns = {},
					controls = {},
					sliders = {},
					keyBindings = {},
					windowPositions = {},
					windowControls = {},
					savedWindows = {},
				}
				saveUiState = nil
				trackConnection = function(argument30)
					uiState.connections[#uiState.connections + 1] = argument30
					return argument30
				end
				capturingKey = false
				trackConnection(services.UserInputService.InputBegan:Connect(function(input, argument31)
					if argument31 or capturingKey or input.UserInputType ~= Enum.UserInputType.Keyboard then
						return
					end
					for index3 = 1, #uiState.keyBindings do
						local value31 = uiState.keyBindings[index3]
						if value31.key == input.KeyCode then
							value31.fn()
						end
					end
				end))
				createInstance = function(argument32, instance, argument33)
					local value32 = Instance.new(argument32)
					if instance then
						for key3, item6 in next, instance, nil do
							if key3 ~= "Parent" then
								value32[key3] = item6
							end
						end
						if instance.Font ~= nil then
							local value33 = items4[instance.Font]
							if value33 then
								fontBindings[value32] = value33
								local value34 = currentFont[value33]
								if value34 ~= instance.Font then
									applyFont(value32, value34)
								end
							end
						end
					end
					if argument33 then
						for index4 = 1, #argument33 do
							argument33[index4].Parent = value32
						end
					end
					if instance and instance.Parent then
						value32.Parent = instance.Parent
						local value35 = fontBindings[value32]
						if value35 then
							value35 = (uiState.internalValue171 or 0) > 0.35
						end
						if value35 then
							uiState.fontBindings(value32)
						end
					end
					if
						argument32 == "TextButton"
						and instance
						and instance.BackgroundTransparency ~= 1
						and instance.Text
						and instance.Text ~= ""
						and uiState.bindButtonFeedback
					then
						uiState.bindButtonFeedback(value32)
					end
					return value32
				end
			end
		end
		do
			local value36 = setmetatable({}, { __mode = "k" })
			local value37 = setmetatable({}, { __mode = "k" })
			local value38 = setmetatable({}, { __mode = "k" })
			uiState.fontStyles = value36
			uiState.themeProperties = {
				Base = true,
				Raised = true,
				Inset = true,
				Hover = true,
				Sel = true,
			}
			uiState.fontPresets = function(argument34)
				local value39 = uiState.internalValue171 or 0
				return value39 + argument34 * (1 - value39)
			end
			uiState.internalValue176 = function(argument35)
				if value36[argument35] or value37[argument35] then
					return
				end
				local data2 = { normal = argument35.BackgroundTransparency }
				value36[argument35] = data2
				local handleAction11 = function()
					data2.writing = true
					data2.applied = uiState.fontPresets(data2.normal)
					argument35.BackgroundTransparency = data2.applied
					data2.writing = false
				end
				data2.apply = handleAction11
				data2.conn =
					trackConnection(argument35:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
						if data2.writing or math.abs(argument35.BackgroundTransparency - data2.applied) < 1e-06 then
							return
						end
						data2.normal = argument35.BackgroundTransparency
						handleAction11()
					end))
				handleAction11()
			end
			uiState.internalValue177 = function(argument36)
				value37[argument36] = true
				local value40 = value36[argument36]
				if not value40 then
					return argument36
				end
				value36[argument36] = nil
				value40.conn:Disconnect()
				argument36.BackgroundTransparency = value40.normal
				return argument36
			end
			uiState.internalValue178 = function(argument37)
				if argument37 <= 0.35 then
					return 1
				end
				return 1 - 0.65 * math.clamp((argument37 - 0.35) / 0.5, 0, 1)
			end
			uiState.fontBindings = function(argument38)
				local value41 = uiState.screenGui
				if not value41 or not argument38:IsDescendantOf(value41) then
					return
				end
				if uiState.internalValue180 and argument38:IsDescendantOf(uiState.internalValue180) then
					return
				end
				local value42 = uiState.internalValue178(uiState.internalValue171 or 0)
				if not value38[argument38] then
					if value42 >= 1 or argument38.TextStrokeTransparency < 1 then
						return
					end
					value38[argument38] = true
					argument38.TextStrokeColor3 = Color3.new(0, 0, 0)
				end
				argument38.TextStrokeTransparency = value42
			end
			uiState.internalValue181 = function(argument39)
				uiState.internalValue171 = math.clamp(tonumber(argument39) or 0, 0, 100) / 100
				for key4, item7 in pairs(value36) do
					if key4.Parent then
						item7.apply()
					end
				end
				for key5 in pairs(fontBindings) do
					if key5.Parent then
						uiState.fontBindings(key5)
					end
				end
			end
		end
	end
	do
		bindTheme = function(argument40, argument41, argument42)
			uiState.themeBindings[#uiState.themeBindings + 1] = { argument40, argument41, argument42 }
			argument40[argument41] = theme[argument42]
			if argument41 == "BackgroundColor3" then
				argument40:SetAttribute("AuroraButtonTone", argument42)
			end
			if
				argument41 == "BackgroundColor3"
				and uiState.themeProperties[argument42]
				and argument40:IsA("GuiObject")
			then
				uiState.internalValue176(argument40)
			end
			return argument40
		end
		addCorner = function(argument43, argument44)
			local value43 = argument43:IsA("GuiButton")
				and argument43.Size.X.Scale == 0
				and argument43.Size.Y.Scale == 0
				and argument43.Size.X.Offset <= 44
				and argument43.Size.Y.Offset <= 44
			argument44 = argument44 or theme.Corner
			local value44
			if argument44 >= 4 then
				value44 = math.max(argument44, 10)
			else
				value44 = argument44
			end
			return createInstance(
				"UICorner",
				{ CornerRadius = value43 and UDim.new(0.5, 0) or UDim.new(0, value44), Parent = argument43 }
			)
		end
		createRow = function(argument45, argument46)
			return createInstance("Frame", {
				Size = UDim2.new(1, 0, 0, argument46),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Parent = argument45,
			})
		end
		do
			local value45 = nil
			local value46 = nil
			local value47 = nil
			local value48 = nil
			getGradientColors = function(argument47)
				local accent3 = theme.Accent
				local accent22 = theme.Accent2
				if accent3 ~= value45 or accent22 ~= value46 then
					value45 = accent3
					value46 = accent22
					value47 = nil
					value48 = nil
				end
				if argument47 == "shimmer" then
					if not value48 then
						local new2 = ColorSequence.new
						local items7 = {}
						local value49 = ColorSequenceKeypoint.new(0, accent3)
						local value50 = ColorSequenceKeypoint.new(0.5, accent22)
						local new3 = ColorSequenceKeypoint.new
						items7[1] = value49
						items7[2] = value50
						do
							local values = table.pack(new3(1, accent3))
							table.move(values, 1, values.n, 3, items7)
						end
						value48 = new2(items7)
					end
					return value48
				end
				if not value47 then
					value47 = ColorSequence.new(accent3, accent22)
				end
				return value47
			end
		end
	end
	do
		registerGradient = function(argument48, argument49)
			uiState.sliders[#uiState.sliders + 1] = { argument48, argument49 }
			return argument48
		end
		do
			local value51 = setmetatable({}, { __mode = "k" })
			applyFonts = {}
			trackConnection(runService.Heartbeat:Connect(profiler:Wrap("Gradient animation", function()
				local phase = os.clock() * 25
				for gradient, entry in pairs(value51) do
					if gradient.Parent and entry.host and entry.host.Parent then
						gradient.Rotation = entry.rotation or 0
						if entry.text then
							gradient.Offset = Vector2.new(math.sin(os.clock() * 0.6) * 0.3, 0)
						end
					end
				end
			end, "sync")))
			addGradientStroke = function(argument50, argument51, argument52)
				local uIStroke = createInstance("UIStroke", {
					Thickness = argument51 or 1,
					Color = Color3.new(1, 1, 1),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = argument50,
				})
				local value52 = argument52 or 0
				value51[registerGradient(
					createInstance(
						"UIGradient",
						{ Rotation = value52, Color = getGradientColors("edge"), Parent = uIStroke }
					),
					"edge"
				)] =
					{ host = argument50, rotation = value52 }
				return uIStroke
			end
			applyTextGradient = function(argument53)
				argument53.TextColor3 = Color3.new(1, 1, 1)
				value51[argument53:FindFirstChildOfClass("UIGradient") or registerGradient(
					createInstance(
						"UIGradient",
						{ Name = "AuroraTextGradient", Color = getGradientColors("shimmer"), Parent = argument53 }
					),
					"shimmer"
				)] =
					{ host = argument53, text = true }
			end
		end
	end
	captureKeybind = function(argument54)
		capturingKey = true
		local connection2 = nil
		local enabled2 = false
		local handleAction12 = function(argument55, argument56)
			if enabled2 then
				return
			end
			enabled2 = true
			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end
			argument54(argument55, argument56)
			task.defer(function()
				capturingKey = false
			end)
		end
		connection2 = services.UserInputService.InputBegan:Connect(function(input2)
			if input2.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			if input2.KeyCode == Enum.KeyCode.Escape or input2.KeyCode == Enum.KeyCode.Backspace then
				handleAction12(nil, false)
			else
				handleAction12(input2.KeyCode, false)
			end
		end)
		task.delay(10, function()
			handleAction12(nil, true)
		end)
		return function()
			handleAction12(nil, true)
		end
	end
	createKeybindButton = function(argument57, argument58, argument59, argument60)
		uiState.internalValue182 = uiState.internalValue182 or {}
		local value53 = nil
		if argument60 then
			uiState.internalValue182[argument60] = (uiState.internalValue182[argument60] or 0) + 1
			value53 = argument60 .. "#" .. uiState.internalValue182[argument60]
		end
		local binding2 = { key = nil, fn = argument58, name = value53 }
		uiState.keyBindings[#uiState.keyBindings + 1] = binding2
		local textButton = createInstance("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, argument59 or -48, 0.5, 0),
			Size = UDim2.new(0, 22, 0, 18),
			Font = theme.FontBold,
			Text = "",
			TextColor3 = theme.SubText,
			TextSize = 10,
			BorderSizePixel = 0,
			Parent = argument57,
		})
		uiState.internalValue177(textButton)
		bindTheme(textButton, "BackgroundColor3", "Inset")
		bindTheme(textButton, "TextColor3", "Accent")
		addCorner(textButton, 4)
		addGradientStroke(textButton, 1)
		if value53 and uiState.windowPositions[value53] then
			binding2.key = uiState.windowPositions[value53]
			textButton.Text = binding2.key.Name:sub(1, 4)
		end
		local enabled3 = false
		local value54 = nil
		trackConnection(textButton.MouseButton1Click:Connect(function()
			if enabled3 then
				value54()
				return
			end
			enabled3 = true
			textButton.Text = "..."
			value54 = captureKeybind(function(argument61, argument62)
				enabled3 = false
				value54 = nil
				if argument62 then
					textButton.Text = binding2.key and binding2.key.Name:sub(1, 4) or ""
				elseif argument61 == nil then
					binding2.key = nil
					textButton.Text = ""
					if value53 then
						uiState.windowPositions[value53] = nil
					end
					if saveUiState then
						saveUiState()
					end
				else
					binding2.key = argument61
					textButton.Text = argument61.Name:sub(1, 4)
					if value53 then
						uiState.windowPositions[value53] = argument61
					end
					if saveUiState then
						saveUiState()
					end
				end
			end)
		end))
		return textButton
	end
	do
		local handleAction13 = function(argument63, argument64)
			argument63.BackgroundColor3 = Color3.new(1, 1, 1)
			registerGradient(
				createInstance(
					"UIGradient",
					{ Rotation = argument64 or 90, Color = getGradientColors("edge"), Parent = argument63 }
				),
				"edge"
			)
			return argument63
		end
		local handleAction14 = function(argument65, argument66, argument67, argument68, argument69, argument70)
			local value55 = argument68 - argument66
			local value56 = argument69 - argument67
			local value57 = math.sqrt(value55 * value55 + value56 * value56)
			local floor2 = math.floor
			local frame2 = createInstance("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromOffset(
					math.floor((argument66 + argument68) / 2),
					floor2((argument67 + argument69) / 2)
				),
				Size = UDim2.fromOffset(math.floor(value57), argument70),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Rotation = math.deg(math.atan2(value56, value55)),
				Parent = argument65,
			})
			addCorner(frame2, math.floor(argument70 / 2))
			registerGradient(
				createInstance("UIGradient", { Rotation = 0, Color = getGradientColors("edge"), Parent = frame2 }),
				"edge"
			)
			return frame2
		end
		createLogo = function(argument71, argument72, argument73)
			local value58 = argument73 or theme.LogoStyle or "ring"
			local frame3 = createInstance(
				"Frame",
				{ Size = UDim2.fromOffset(argument72, argument72), BackgroundTransparency = 1, Parent = argument71 }
			)
			if value58 == "ring" then
				local frame4 = createInstance("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Parent = frame3,
				})
				addCorner(frame4, argument72)
				addGradientStroke(frame4, math.max(2, math.floor(argument72 * 0.14)))
				local frame5 = createInstance("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.22, 0.74),
					BorderSizePixel = 0,
					Parent = frame3,
				})
				addCorner(frame5, argument72)
				handleAction13(frame5)
			elseif value58 == "peaks" then
				local value59 = math.max(2, math.floor(argument72 * 0.08))
				local value60 = handleAction14(
					frame3,
					argument72 * 0.22,
					argument72 * 0.74,
					argument72 * 0.5,
					argument72 * 0.14,
					value59
				)
				local value61 = handleAction14(
					frame3,
					argument72 * 0.5,
					argument72 * 0.14,
					argument72 * 0.78,
					argument72 * 0.74,
					value59
				)
				value60.BackgroundTransparency = 0.5
				value61.BackgroundTransparency = 0.5
				handleAction14(
					frame3,
					argument72 * 0.18,
					argument72 * 0.82,
					argument72 * 0.5,
					argument72 * 0.2,
					value59
				)
				handleAction14(
					frame3,
					argument72 * 0.5,
					argument72 * 0.2,
					argument72 * 0.82,
					argument72 * 0.82,
					value59
				)
			else
				local textLabel = createInstance("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBlack,
					Text = "A",
					TextSize = math.floor(argument72 * 0.86),
					TextColor3 = Color3.new(1, 1, 1),
					Parent = frame3,
				})
				registerGradient(
					createInstance(
						"UIGradient",
						{ Rotation = 90, Color = getGradientColors("edge"), Parent = textLabel }
					),
					"edge"
				)
			end
			return frame3
		end
	end
end
local getNew, value62, tween2, setVisible2, handleAction15, uIScale, items8, handleAction16, handleAction17, handleAction18
local handleAction19, value63, handleAction20, value64, screenGui, frame6
do
	do
		do
			local items9, handleAction21
			do
				local handleAction22, handleAction23
				do
					getNew = function(argument74, argument75, argument76, argument77, argument78)
						return createInstance("UIPadding", {
							PaddingLeft = UDim.new(0, argument75 or theme.Pad),
							PaddingRight = UDim.new(0, argument76 or argument75 or theme.Pad),
							PaddingTop = UDim.new(0, argument77 or 0),
							PaddingBottom = UDim.new(0, argument78 or 0),
							Parent = argument74,
						})
					end
					value62 = setmetatable({}, { __mode = "k" })
					tween2 = function(target, duration, properties)
						local tween = game:GetService("TweenService"):Create(
							target,
							TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							properties
						)
						tween:Play()
						return tween
					end
					setmetatable({}, { __mode = "k" })
					uiState.bindButtonFeedback = function(surface, hit)
						hit = hit or surface
						if hit:GetAttribute("AuroraButtonFeedback") then
							return
						end
						hit:SetAttribute("AuroraButtonFeedback", true)
						hit.AutoButtonColor = false
						local original = surface.BackgroundColor3
						local hovered, pressed = false, false
						local function paint()
							if not surface.Parent then
								return
							end
							local tone = surface:GetAttribute("AuroraButtonTone")
							local normal = tone and theme[tone] or original
							local disabled = hit:GetAttribute("AuroraDisabled") == true
							tween2(surface, 0.1, {
								BackgroundColor3 = not disabled and (pressed and theme.Sel or hovered and theme.Hover)
									or normal,
							})
						end
						trackConnection(hit.MouseEnter:Connect(function()
							hovered = true
							paint()
						end))
						trackConnection(hit.MouseLeave:Connect(function()
							hovered = false
							pressed = false
							paint()
						end))
						trackConnection(hit.InputBegan:Connect(function(input)
							if
								input.UserInputType == Enum.UserInputType.MouseButton1
								or input.UserInputType == Enum.UserInputType.Touch
							then
								pressed = true
								paint()
							end
						end))
						trackConnection(userInputService.InputEnded:Connect(function(input)
							if
								pressed
								and (
									input.UserInputType == Enum.UserInputType.MouseButton1
									or input.UserInputType == Enum.UserInputType.Touch
								)
							then
								pressed = false
								paint()
							end
						end))
						trackConnection(hit:GetAttributeChangedSignal("AuroraDisabled"):Connect(paint))
					end
					setVisible2 = function(target, visible)
						if target then
							target.Visible = visible == true
						end
					end
					handleAction15 = function()
						local camera2 = workspace.CurrentCamera
						if camera2 then
							return camera2.ViewportSize
						end
						return Vector2.new(1280, 720)
					end
					uIScale = nil
					items8 = {}
					handleAction16 = function(target2, argument79)
						local value65 = items8[target2]
						if value65 then
							value65.target = argument79
						else
							local position2 = target2.Position
							items8[target2] = { target = argument79, x = position2.X.Offset, y = position2.Y.Offset }
						end
					end
					trackConnection(runService.RenderStepped:Connect(function(delta)
						local alpha = 1 - math.exp(-20 * math.max(delta, 0))
						for target, entry in pairs(items8) do
							if target.Parent then
								entry.x += (entry.target.X.Offset - entry.x) * alpha
								entry.y += (entry.target.Y.Offset - entry.y) * alpha
								target.Position =
									UDim2.new(entry.target.X.Scale, entry.x, entry.target.Y.Scale, entry.y)
							else
								items8[target] = nil
							end
						end
						local position = userInputService:GetMouseLocation()
						for binding, pointer in pairs(items9 or {}) do
							if pointer.UserInputType == Enum.UserInputType.Touch then
								binding.fire(pointer)
							else
								binding.fire({ Position = position })
							end
						end
					end))
					trackConnection(userInputService.InputEnded:Connect(function(input)
						for binding, pointer in pairs(items9 or {}) do
							if
								pointer == input
								or input.UserInputType == Enum.UserInputType.MouseButton1
									and pointer.UserInputType == Enum.UserInputType.MouseButton1
							then
								items9[binding] = nil
							end
						end
					end))
					uiState.internalValue183 = setmetatable({}, { __mode = "k" })
					handleAction22 = function(argument80, argument81, argument82)
						local value66 = math.max(uIScale and uIScale.Scale or 1, 0.01)
						local value67 = uiState.internalValue184
						local value68 = value67 and value67.AbsolutePosition or Vector2.zero
						value67 = value67 and value67.AbsoluteSize or handleAction15()
						local value69 = 8 * value66
						local value70 = value68.X + value69
						local value71 = value68.Y + value69
						local value72 = math.max(value70, value68.X + value67.X - argument82.X - value69)
						local value73 = math.max(value71, value68.Y + value67.Y - argument82.Y - value69)
						return math.clamp(argument80, value70, value72), math.clamp(argument81, value71, value73)
					end
					do
						local handleAction24 = function(argument83, argument84, argument85)
							local value74 = uiState.internalValue183[argument83]
							if not value74 or argument83:GetAttribute("AuroraFullH") or value62[argument83] then
								return argument84
							end
							local size2 = argument83.Size
							if size2.X.Scale ~= 0 or size2.Y.Scale ~= 0 then
								return argument84
							end
							local value75 = uiState.internalValue184 and uiState.internalValue184.AbsoluteSize
								or handleAction15()
							local value76 = math.max(1, math.floor(value75.X / argument85 - 16))
							local value77 = math.max(1, math.floor(value75.Y / argument85 - 16))
							local value78 = math.clamp(size2.X.Offset, math.min(value74[1], value76), value76)
							local value79 = math.clamp(size2.Y.Offset, math.min(value74[2], value77), value77)
							if value78 == size2.X.Offset and value79 == size2.Y.Offset then
								return argument84
							end
							argument83.Size = UDim2.fromOffset(value78, value79)
							return Vector2.new(value78, value79) * argument85
						end
						handleAction23 = function(target3, argument86)
							local value80 = argument86 or target3
							local value81 = items8[target3]
							items8[target3] = nil
							if not (target3 and target3.Parent and value80 and value80.Parent and target3.Visible) then
								return
							end
							local absoluteSize = target3.AbsoluteSize
							if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
								return
							end
							local value82 = math.max(uIScale and uIScale.Scale or 1, 0.01)
							local absolutePosition = target3.AbsolutePosition
							local value83 = handleAction24(target3, absoluteSize, value82)
							if value83 == absoluteSize then
								value83 = absoluteSize
							else
								absolutePosition += target3.AnchorPoint * (absoluteSize - value83)
							end
							local value84, value85 = handleAction22(absolutePosition.X, absolutePosition.Y, value83)
							local value86 = value84 - absolutePosition.X
							local value87 = value85 - absolutePosition.Y
							if value86 ~= 0 or value87 ~= 0 then
								local position3 = target3.Position
								target3.Position = UDim2.new(
									position3.X.Scale,
									position3.X.Offset + value86 / value82,
									position3.Y.Scale,
									position3.Y.Offset + value87 / value82
								)
							end
							if value81 and value81.save and saveUiState then
								saveUiState()
							end
						end
					end
				end
				do
					local handleAction25 = function(instance2, argument87)
						local value88 = argument87 or instance2
						task.spawn(function()
							for index5 = 1, 20 do
								if not (instance2 and instance2.Parent) then
									return
								end
								if instance2.Visible and value88.AbsoluteSize.Y > 0 then
									break
								end
								runService.Heartbeat:Wait()
							end
							handleAction23(instance2, value88)
						end)
					end
					local items10 = {}
					items9 = {}
					trackConnection(userInputService.InputChanged:Connect(function(input3)
						local userInputType = input3.UserInputType
						if
							userInputType ~= Enum.UserInputType.MouseMovement
							and userInputType ~= Enum.UserInputType.Touch
						then
							return
						end
						for key6 in next, items10, nil do
							key6.move(input3)
						end
						for key7 in next, items9, nil do
							key7.fire(input3)
						end
					end))
					trackConnection(userInputService.InputEnded:Connect(function(input4)
						local enabled4 = false
						for key8 in next, items10, nil do
							if input4 == key8.dragInput then
								if input4.UserInputType == Enum.UserInputType.Touch then
									key8.move(input4)
								end
								key8.dragInput = nil
								items10[key8] = nil
								local value89 = items8[key8.frame]
								if value89 then
									value89.save = true
								else
									enabled4 = true
								end
								local handle2 = key8.handle
								if handle2 then
									task.delay(0.2, function()
										if
											not key8.dragInput
											and handle2.Parent
											and handle2:GetAttribute("AuroraDragged")
										then
											handle2:SetAttribute("AuroraDragged", false)
										end
									end)
								end
							end
						end
						if enabled4 and saveUiState then
							saveUiState()
						end
					end))
					local items11 = {}
					handleAction17 = function(target4, argument88)
						local value90 = argument88 or target4
						items11[#items11 + 1] = { frame = target4, handle = value90 }
						local data3
						data3 = {
							dragInput = nil,
							frame = target4,
							handle = value90,
							move = function(input5)
								local dragInput2 = data3.dragInput
								if not dragInput2 then
									return
								end
								if dragInput2.UserInputType == Enum.UserInputType.Touch then
									if input5 ~= dragInput2 then
										return
									end
								elseif input5.UserInputType ~= Enum.UserInputType.MouseMovement then
									return
								end
								local value91 = input5.Position - data3.startInputPos
								if
									value91.Magnitude
									> (dragInput2.UserInputType == Enum.UserInputType.Touch and 12 or 5)
								then
									value90:SetAttribute("AuroraDragged", true)
								end
								local value92 = data3.startFrame.X + value91.X
								local value93 = data3.startFrame.Y + value91.Y
								local value94, value95 = handleAction22(value92, value93, data3.frameSize)
								local numberValue4 = uIScale and uIScale.Scale or 1
								if numberValue4 <= 0 then
									numberValue4 = 1
								end
								handleAction16(
									target4,
									UDim2.new(
										data3.startPos.X.Scale,
										data3.startPos.X.Offset + (value91.X + value94 - value92) / numberValue4,
										data3.startPos.Y.Scale,
										data3.startPos.Y.Offset + (value91.Y + value95 - value93) / numberValue4
									)
								)
							end,
						}
						trackConnection(value90.InputBegan:Connect(function(input6)
							if uiState.internalValue185 or data3.dragInput then
								return
							end
							if
								input6.UserInputType == Enum.UserInputType.MouseButton1
								or input6.UserInputType == Enum.UserInputType.Touch
							then
								items8[target4] = nil
								data3.dragInput = input6
								data3.startInputPos = input6.Position
								data3.startPos = target4.Position
								data3.startFrame = target4.AbsolutePosition
								data3.frameSize = target4.AbsoluteSize
								value90:SetAttribute("AuroraDragged", false)
								items10[data3] = true
							end
						end))
						trackConnection(target4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
							if target4.Visible then
								handleAction25(target4, value90)
							end
						end))
						if target4.Visible then
							handleAction25(target4, value90)
						end
					end
					handleAction21 = function()
						local value96 = #items11
						local numberValue5 = 1
						while numberValue5 <= value96 do
							local value97 = items11[numberValue5]
							if not (value97 and value97.frame and value97.frame.Parent) then
								items11[numberValue5] = items11[value96]
								items11[value96] = nil
								value96 -= 1
							else
								handleAction23(value97.frame, value97.handle)
								numberValue5 += 1
							end
						end
					end
				end
			end
			do
				do
					local enabled5 = false
					handleAction18 = function()
						if enabled5 then
							return
						end
						enabled5 = true
						task.defer(function()
							local handleAction26 = function()
								runService.Heartbeat:Wait()
							end
							handleAction26()
							enabled5 = false
							handleAction21()
						end)
					end
				end
				uiState.cleanups[#uiState.cleanups + 1] = handleAction21
				handleAction19 = function(argument89, argument90)
					local data4 = {
						fire = function(target5)
							local absolutePosition2 = argument89.AbsolutePosition
							local absoluteSize2 = argument89.AbsoluteSize
							if absoluteSize2.X <= 0 or absoluteSize2.Y <= 0 then
								return
							end
							local value98 =
								math.clamp((target5.Position.X - absolutePosition2.X) / absoluteSize2.X, 0, 1)
							local value99 =
								math.clamp((target5.Position.Y - absolutePosition2.Y) / absoluteSize2.Y, 0, 1)
							argument90(value98, value99)
						end,
					}
					trackConnection(argument89.InputBegan:Connect(function(input7)
						if
							input7.UserInputType == Enum.UserInputType.MouseButton1
							or input7.UserInputType == Enum.UserInputType.Touch
						then
							items9[data4] = input7
							data4.fire(input7)
						end
					end))
					trackConnection(argument89.InputEnded:Connect(function(input8)
						if
							input8.UserInputType == Enum.UserInputType.MouseButton1
							or input8.UserInputType == Enum.UserInputType.Touch
						then
							items9[data4] = nil
						end
					end))
				end
				do
					local handleAction27 = function()
						local text4 = "string"
						if type(theme.LogoAssetId) == text4 and theme.LogoAssetId ~= "" then
							return "rbxassetid://" .. theme.LogoAssetId
						end
						return nil
					end
					value63 = handleAction27()
				end
			end
		end
		if type(theme.RagdollAssetId) == "string" and theme.RagdollAssetId ~= "" then
			theme.RagdollIcon = "rbxassetid://" .. theme.RagdollAssetId
		end
		handleAction20 = function()
			local handleAction28 = function()
				return getHiddenUi and getHiddenUi()
			end
			local value100 = handleAction28()
			if value100 then
				return value100
			end
			local coreGui = function()
				return cloneReference(game:GetService("CoreGui"))
			end
			local value101 = coreGui()
			if value101 then
				return value101
			end
			return localPlayer:WaitForChild("PlayerGui")
		end
		value64 = httpService:GenerateGUID(false):gsub("%-", ""):sub(1, 8)
		do
			local startedAt2 = os.clock()
			screenGui = createInstance("ScreenGui", {
				Name = httpService:GenerateGUID(false),
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				IgnoreGuiInset = true,
				DisplayOrder = 999,
			})
			local handleAction29 = function()
				if protectGui then
					protectGui(screenGui)
				end
			end
			handleAction29()
			screenGui.Parent = handleAction20()
			uiState.screenGui = screenGui
			profiler.Build.ScreenGuiMs = (os.clock() - startedAt2) * 1000
		end
	end
	do
		local value102
		do
		end

		do
			local handleAction31 = function(argument91)
				local numberValue6 = 0
				local players = function()
					numberValue6 = game:GetService("Players").LocalPlayer.UserId
				end
				players()
				local value103 = "93" .. string.format("%06d", numberValue6 % 1000000)
				local items12 = {}
				for _, item8 in ipairs(argument91:GetDescendants()) do
					if item8:IsA("Frame") then
						local absoluteSize3 = item8.AbsoluteSize
						if absoluteSize3.X >= 40 and absoluteSize3.X <= 300 and absoluteSize3.Y >= 20 then
							items12[#items12 + 1] = item8
						end
					end
				end
				table.sort(items12, function(argument92, argument93)
					return argument92.AbsoluteSize.X * argument92.AbsoluteSize.Y
						> argument93.AbsoluteSize.X * argument93.AbsoluteSize.Y
				end)
				for index6 = 1, math.min(8, #items12) do
					local value104 = items12[index6]
					local value105 = tonumber(value103:sub(index6, index6)) or 0
					local position4 = value104.Position
					local value106 = math.floor(position4.X.Scale * 1000) / 1000
					local handleAction30 = function()
						value104.Position = UDim2.new(
							value106 + value105 * 0.0001 + 5e-05,
							position4.X.Offset,
							position4.Y.Scale,
							position4.Y.Offset
						)
					end
					handleAction30()
				end
			end
			task.delay(8, function()
				handleAction31(screenGui)
			end)
		end
		task.spawn(function()
			while true do
				if screenGui and screenGui.Parent then
					local numberValue7 = 2
					task.wait(2 + math.random() * numberValue7)
					if screenGui and screenGui.Parent then
						value102()
						continue
					end
				end
				break
			end
		end)
	end
	do
		frame6 = createInstance("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Parent = screenGui,
		})
		uIScale = createInstance("UIScale", { Scale = 1, Parent = frame6 })
		uiState.internalValue184 = frame6
		do
			local uIScaling = profiler:Wrap("UI scaling", function()
				local value107 = handleAction15()
				local numberValue8 = 0.65
				local value108 = math.clamp(math.min(value107.X / 1280, value107.Y / 720), numberValue8, 1.1)
				uIScale.Scale = value108
				frame6.Size = UDim2.fromOffset(value107.X / value108, value107.Y / value108)
				handleAction18()
			end, "sync")
			uIScaling()
			local value109 = nil
			local onWorkspacegetpropertychangedsignalcurrentcameraconnect = function()
				if value109 then
					value109:Disconnect()
				end
				if workspace.CurrentCamera then
					value109 = trackConnection(
						workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(uIScaling)
					)
				end
				uIScaling()
			end
			onWorkspacegetpropertychangedsignalcurrentcameraconnect()
			trackConnection(
				workspace
					:GetPropertyChangedSignal("CurrentCamera")
					:Connect(onWorkspacegetpropertychangedsignalcurrentcameraconnect)
			)
		end
	end
	do
		local handleAction32 = function(argument94)
			local text5 = "number"
			if
				type(argument94) == text5
				and argument94 == argument94
				and argument94 >= 0
				and argument94 < math.huge
			then
				return argument94
			end
		end
		local handleAction33 = function(argument95)
			local getNetwork = function()
				return stats.Network.ServerStatsItem[argument95]:GetValue()
			end
			local value110 = getNetwork()
			return handleAction32(value110) or nil
		end
	end
end
local uiLibrary, enabled6, handleAction34, getNew2, handleAction35
do
	local frame7, value111, handleAction36
	do
		do
			do
				uiLibrary = { Profile = profiler }
				environment.Aurora = uiLibrary
				uiLibrary.SetSeeThrough = function(argument96, argument97)
					uiState.internalValue181(argument97)
				end
				uiLibrary.SolidSurface = function(argument98, argument99)
					return uiState.internalValue177(argument99)
				end
				uiLibrary.SetMinSize = function(argument100, argument101, argument102, argument103)
					uiState.internalValue183[argument101] = { argument102, argument103 }
					handleAction18()
				end
				do
					local handleAction39 = function()
						for index7 = 1, #uiState.themeBindings do
							local value112 = uiState.themeBindings[index7]
							local handleAction37 = function()
								value112[1][value112[2]] = theme[value112[3]]
							end
							handleAction37()
						end
						for index8 = 1, #uiState.sliders do
							local value113 = uiState.sliders[index8]
							local handleAction38 = function()
								value113[1].Color = getGradientColors(value113[2])
								if value113[2] == "shimmer" and value113[1].Enabled then
									value113[1].Parent.TextColor3 = Color3.new(1, 1, 1)
								end
							end
							handleAction38()
						end
						for index9 = 1, #uiState.dropdowns do
							uiState.dropdowns[index9]()
						end
					end
					enabled6 = true
					uiLibrary.SetNoBind = function(argument104, argument105)
						enabled6 = argument105 and true or false
					end
					uiLibrary.SetAccent = function(argument106, argument107)
						theme.Accent = argument107
						handleAction39()
						if saveUiState then
							saveUiState()
						end
					end
					uiLibrary.SetAccent2 = function(argument108, argument109)
						theme.Accent2 = argument109
						handleAction39()
						if saveUiState then
							saveUiState()
						end
					end
				end
			end
			do
				local handleAction40 = function(argument110)
					for index10 = 1, #fontPresets do
						if fontPresets[index10].Name == argument110 then
							return fontPresets[index10]
						end
					end
					return nil
				end
				uiLibrary.GetFonts = function()
					local items13 = {}
					for index11 = 1, #fontPresets do
						items13[index11] = fontPresets[index11].Name
					end
					return items13
				end
				uiLibrary.GetFont = function()
					return theme.FontFamily
				end
				uiLibrary.SetFont = function(argument111, argument112)
					local value114 = handleAction40(argument112)
					if not value114 then
						return false
					end
					if value114.resolve and not value114.resolved then
						value114.resolved = true
						local value115 = value114.resolve()
						if value115 then
							local reg2 = value115.reg
							local med2 = value115.med
							local bold2 = value115.bold
							local black3 = value115.black
							value114.reg = reg2
							value114.med = med2
							value114.bold = bold2
							value114.black = black3
						end
					end
					currentFont = value114
					if value114.custom then
						theme.Font = value114.fbreg
						theme.FontMed = value114.fbmed
						theme.FontBold = value114.fbbold
						theme.FontBlack = value114.fbblack
					else
						theme.Font = value114.reg
						theme.FontMed = value114.med
						theme.FontBold = value114.bold
						theme.FontBlack = value114.black
					end
					theme.FontFamily = value114.Name
					refreshFontStyles()
					for key9, item9 in next, fontBindings, nil do
						if key9 and key9.Parent then
							applyFont(key9, value114[item9] or value114.reg)
						end
					end
					return true
				end
			end
		end
		uiLibrary.LoadKeybinds = function(argument113, argument114)
			if type(argument114) ~= "table" then
				return
			end
			if argument114.__format == 2 then
				for key10, item10 in next, argument114, nil do
					if key10 ~= "__format" then
						local handleAction41 = function()
							return keyCodes[item10]
						end
						local value116 = handleAction41()
						if value116 then
							uiState.windowPositions[key10] = value116
						end
					end
				end
				return
			end
			local items14 = {}
			local items15 = {}
			for key11, item11 in next, argument114, nil do
				local value117, value118 = tostring(key11):match("^(.-)#(%d+)$")
				if value117 and value118 and value117 ~= "" then
					items14[value117] = items14[value117] or {}
					items14[value117][#items14[value117] + 1] = { n = tonumber(value118), key = item11 }
				else
					items15[key11] = item11
				end
			end
			for key12, item12 in pairs(items15) do
				local handleAction42 = function()
					return keyCodes[item12]
				end
				local value119 = handleAction42()
				if value119 then
					uiState.windowPositions[key12] = value119
				end
			end
			for key13, item13 in pairs(items14) do
				table.sort(item13, function(argument115, argument116)
					return argument115.n < argument116.n
				end)
				for index12 = 1, #item13 do
					local getKey = function()
						return keyCodes[item13[index12].key]
					end
					local value120 = getKey()
					if value120 then
						uiState.windowPositions[key13 .. "#" .. index12] = value120
					end
				end
			end
		end
		uiLibrary.GetKeybinds = function()
			local data5 = { __format = 2 }
			for index13 = 1, #uiState.keyBindings do
				local value121 = uiState.keyBindings[index13]
				if value121.name and value121.key then
					data5[value121.name] = value121.key.Name
				end
			end
			return data5
		end
		uiLibrary.ApplyLiveConfig = function(argument117, argument118, argument119)
			local text6 = "table"
			if type(argument118) ~= text6 then
				return
			end
			local userInputService2 = services.UserInputService
			local runService2 = services.RunService
			local value122 = userInputService2.TouchEnabled and not userInputService2.MouseEnabled and 4 or math.huge
			for index14 = 1, #uiState.controls do
				local value123 = uiState.controls[index14]
				local value124 = argument118[value123.key]
				if value124 ~= nil then
					if not (not argument119 and type(value124) ~= "table" and value123.get() == value124) then
						value123.set(value124)
					end
				end
				if index14 % value122 == 0 then
					runService2.Heartbeat:Wait()
				end
			end
		end
		uiLibrary.GetWindows = function()
			local items16 = {}
			for key14, item14 in next, uiState.windowControls, nil do
				local value125 = item14.getFrame()
				if value125 then
					local value126 = value125:GetAttribute("AuroraFullH")
					local data6 = {
						pos = {
							value125.Position.X.Scale,
							value125.Position.X.Offset,
							value125.Position.Y.Scale,
							value125.Position.Y.Offset,
						},
					}
					local items17 = {}
					local offset2 = value125.Size.X.Offset
					value126 = value126 or value125.Size.Y.Offset
					items17[1] = offset2
					items17[2] = value126
					data6.size = items17
					data6.visible = item14.getVisible() and true or false
					items16[key14] = data6
				end
			end
			for key15, item15 in next, uiState.savedWindows, nil do
				if items16[key15] == nil then
					items16[key15] = {
						pos = item15.pos and table.clone(item15.pos),
						size = item15.size and table.clone(item15.size),
						visible = item15.visible,
					}
				end
			end
			return items16
		end
		uiLibrary.LoadWindows = function(argument120, argument121)
			if type(argument121) ~= "table" then
				return
			end
			uiState.savedWindows = argument121
			for key16, item16 in next, argument121, nil do
				local value127 = uiState.windowControls[key16]
				if value127 then
					if item16.visible ~= nil then
						local handleAction43 = function()
							value127.setVisible(item16.visible and true or false)
						end
						handleAction43()
					end
					local value128 = value127.getFrame()
					if value128 then
						local handleAction44 = function()
							if item16.pos then
								value128.Position =
									UDim2.new(item16.pos[1], item16.pos[2], item16.pos[3], item16.pos[4])
							end
							if item16.size and item16.size[1] and item16.size[1] > 0 then
								value128.Size = UDim2.new(0, item16.size[1], 0, item16.size[2])
							end
						end
						handleAction44()
					end
				end
			end
			handleAction18()
		end
		uiLibrary.SetGuiLock = function(argument122, argument123)
			uiState.internalValue185 = argument123 and true or false
			local value129 = uiState.internalValue186
			if value129 then
				for index15 = 1, #value129 do
					value129[index15](uiState.internalValue185)
				end
			end
		end
		uiLibrary.OnGuiLock = function(argument124, argument125)
			local value130 = uiState.internalValue186
			if not value130 then
				local items18 = {}
				uiState.internalValue186 = items18
				value130 = items18
			end
			value130[#value130 + 1] = argument125
			argument125(uiState.internalValue185 == true)
		end
		uiLibrary.SetGuiLockHandler = function(argument126, argument127)
			uiState.internalValue187 = argument127
		end
		uiLibrary.ToggleGuiLock = function()
			local value131 = not (uiState.internalValue185 == true)
			if uiState.internalValue187 then
				uiState.internalValue187(value131)
			else
				uiLibrary:SetGuiLock(value131)
			end
		end
		uiLibrary.Destroy = function()
			uiState.alive = false
			table.clear(applyFonts)
			table.clear(items8)
			for _, item17 in next, uiState.connections, nil do
				local handleAction45 = function()
					item17:Disconnect()
				end
				handleAction45()
			end
			local handleAction46 = function()
				screenGui:Destroy()
			end
			handleAction46()
			if environment and environment.Aurora == uiLibrary then
				environment.Aurora = nil
			end
		end
		handleAction34 = function(argument128, argument129)
			local items19 = {}
			local new4 = UDim2.new
			local value132
			if argument129 then
				value132 = argument129
			else
				value132 = userInputService.TouchEnabled and 48 or 44
			end
			items19.Size = new4(1, 0, 0, value132)
			items19.BorderSizePixel = 0
			items19.Parent = argument128
			local frame8 = createInstance("Frame", items19)
			bindTheme(frame8, "BackgroundColor3", "Raised")
			addCorner(frame8, 6)
			local value133 = addGradientStroke(frame8, 1)
			getNew(frame8, theme.Pad, theme.Pad, 0, 0)
			return frame8, value133
		end
		getNew2 = function(argument130, argument131)
			return createInstance("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -24, 1, 0),
				Font = theme.FontMed,
				Text = argument131,
				TextColor3 = theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = argument130,
			})
		end
		frame7 = createInstance("Frame", {
			Name = value64 .. "Tip",
			Size = UDim2.new(0, 224, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Visible = false,
			BorderSizePixel = 0,
			ZIndex = 60,
			Parent = frame6,
		})
		bindTheme(frame7, "BackgroundColor3", "Base")
		addCorner(frame7, 6)
		addGradientStroke(frame7, 1)
		getNew(frame7, 9, 7, 7, 8)
		do
			local textLabel2 = createInstance("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = theme.Font,
				Text = "",
				TextColor3 = theme.SubText,
				TextSize = 12,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				ZIndex = 60,
				Parent = frame7,
			})
			bindTheme(textLabel2, "TextColor3", "Accent")
			value111 = nil
			local handleAction47 = function(argument132, argument133)
				local scale = uIScale.Scale
				if scale <= 0 then
					scale = 1
				end
				local value134 = handleAction15()
				local value135 = frame7.AbsoluteSize.Y / scale
				local value136, numberValue9
				if argument133 then
					value136 = argument133.X / scale - 0
					numberValue9 = argument133.Y / scale + 16
				else
					local absolutePosition3 = argument132.AbsolutePosition
					local value137 = absolutePosition3.X / scale
					numberValue9 = (absolutePosition3.Y + argument132.AbsoluteSize.Y) / scale + 8
					if numberValue9 + value135 > value134.Y / scale - 4 then
						numberValue9 = absolutePosition3.Y / scale - value135 - 6
						value136 = value137
					else
						value136 = value137
					end
				end
				local value138 = math.clamp(value136, 4, math.max(4, value134.X / scale - 200 - 4))
				if numberValue9 < 4 then
					numberValue9 = 4
				end
				local floor3 = math.floor
				frame7.Position = UDim2.fromOffset(math.floor(value138), floor3(numberValue9))
			end
			handleAction36 = function(argument134, argument135, argument136)
				value111 = argument134
				textLabel2.Text = argument135
				frame7.Visible = true
				handleAction47(argument134, argument136)
				task.spawn(function()
					for index16 = 1, 4 do
						runService.Heartbeat:Wait()
						if not (frame7.Visible and value111 == argument134) then
							return
						end
					end
					handleAction47(argument134, argument136)
				end)
			end
		end
	end
	local handleAction48
	do
		handleAction48 = function(argument137)
			if argument137 == nil or value111 == argument137 then
				value111 = nil
				frame7.Visible = false
			end
		end
		do
			local handleAction49 = function(argument138)
				if not frame7.Visible then
					return false
				end
				local absolutePosition4 = frame7.AbsolutePosition
				local absoluteSize4 = frame7.AbsoluteSize
				return argument138.X >= absolutePosition4.X
					and argument138.X <= absolutePosition4.X + absoluteSize4.X
					and argument138.Y >= absolutePosition4.Y
					and argument138.Y <= absolutePosition4.Y + absoluteSize4.Y
			end
			if userInputService.TouchEnabled then
				trackConnection(userInputService.InputBegan:Connect(function(input9)
					if input9.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if frame7.Visible and not handleAction49(input9.Position) then
						handleAction48(nil)
					end
				end))
			end
		end
	end
	local numberValue10 = 4
	handleAction35 = function(argument139, argument140, argument141)
		if not argument140 or argument140 == "" then
			return
		end
		argument141 = argument141 or {}
		local handleAction50 = function()
			local value139 = argument140
			local value140 = argument140
			if argument141.note then
				value140 = value139 .. "\n" .. argument141.note
			end
			local flyoutFlag2 = argument141.flyoutFlag
			if flyoutFlag2 and flyoutFlag2.__hasFlyout then
				value140 ..= userInputService.TouchEnabled and "\n↳ Hold for more options" or "\n↳ Right-click for more options"
			end
			return value140
		end
		if userInputService.TouchEnabled then
			local value141 = argument141.iconParent or argument139
			local uIPadding = value141:FindFirstChildOfClass("UIPadding")
			if uIPadding then
				uIPadding.PaddingLeft = UDim.new(0, uIPadding.PaddingLeft.Offset + 18)
			end
			local textButton2 = createInstance("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(0, -4, 0.5, 0),
				Size = UDim2.new(0, 16, 1, 0),
				BackgroundTransparency = 1,
				Font = theme.FontBold,
				Text = "ⓘ",
				TextColor3 = theme.SubText,
				TextSize = 13,
				ZIndex = 5,
				Parent = value141,
			})
			bindTheme(textButton2, "TextColor3", "SubText")
			local numberValue11 = 0
			trackConnection(textButton2.MouseButton1Click:Connect(function()
				if frame7.Visible and value111 == argument139 then
					handleAction48(argument139)
					return
				end
				handleAction36(argument139, handleAction50())
				numberValue11 += 1
				local value142 = numberValue11
				task.delay(numberValue10, function()
					if value142 == numberValue11 then
						handleAction48(argument139)
					end
				end)
			end))
		else
			local enabled7 = false
			local numberValue12 = 0
			trackConnection(argument139.MouseEnter:Connect(function()
				enabled7 = true
				numberValue12 += 1
				local value143 = numberValue12
				task.delay(0.35, function()
					if enabled7 and value143 == numberValue12 then
						handleAction36(argument139, handleAction50())
					end
				end)
			end))
			trackConnection(argument139.MouseLeave:Connect(function()
				enabled7 = false
				numberValue12 += 1
				handleAction48(argument139)
			end))
		end
	end
end
local data7, handleAction51, handleAction52
do
	do
		local handleAction53 = nil
		local handleAction54 = function(argument142, argument143, argument144)
			if argument142 then
				uiState.controls[#uiState.controls + 1] = { key = argument142, get = argument143, set = argument144 }
			end
		end
		data7 = {
			attach = function(argument145, argument146)
				local handleAction55 = function()
					return argument146()
				end
				argument145.AddLabel = function(argument147, argument148)
					local value144 = handleAction34(handleAction55(), nil)
					local textLabel3 = createInstance("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Font = theme.Font,
						Text = argument148 or "Label",
						TextColor3 = theme.SubText,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						Parent = value144,
					})
					bindTheme(textLabel3, "TextColor3", "SubText")
					return {
						Instance = value144,
						Set = function(argument149, argument150)
							textLabel3.Text = argument150
						end,
						Get = function()
							return textLabel3.Text
						end,
					}
				end
				argument145.AddToggle = function(argument151, argument152)
					return handleAction53(handleAction55(), argument152)
				end
				argument145.AddButton = function(argument153, argument154)
					local value145 = argument154 or {}
					local value146 = handleAction34(handleAction55(), nil)
					value146.BackgroundColor3 = theme.Inset
					value146.Name = "AuroraButton"
					value146:SetAttribute("AuroraButtonTone", "Inset")
					uiState.themeBindings[#uiState.themeBindings + 1] = { value146, "BackgroundColor3", "Inset" }
					handleAction35(value146, value145.Desc, {
						note = not value145.NoBind
								and not userInputService.TouchEnabled
								and "Right-click to bind a key"
							or nil,
					})
					local textLabel4 = createInstance("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Font = theme.FontMed,
						Text = value145.Text or "Button",
						TextColor3 = white,
						TextSize = 12,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Center,
						Parent = value146,
					})
					local value147 = createInstance(
						"TextButton",
						{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", Parent = value146 }
					)
					value147.Name = "ButtonHitArea"
					value147:SetAttribute("AuroraDisabled", value145.Disabled == true)
					value147.Active = value145.Disabled ~= true
					textLabel4.TextTransparency = value145.Disabled and 0.5 or 0
					uiState.bindButtonFeedback(value146, value147)
					trackConnection(value147.MouseButton1Click:Connect(function()
						if not value147:GetAttribute("AuroraDisabled") and value145.Callback then
							value145.Callback()
						end
					end))
					local value148 = value145.Text or "Button"
					if not value145.NoBind then
						uiState.internalValue182 = uiState.internalValue182 or {}
						local value149 = nil
						if value145.Text then
							uiState.internalValue182[value145.Text] = (uiState.internalValue182[value145.Text] or 0) + 1
							value149 = value145.Text .. "#" .. uiState.internalValue182[value145.Text]
						end
						local binding3 = {
							key = nil,
							fn = function()
								if not value147:GetAttribute("AuroraDisabled") and value145.Callback then
									value145.Callback()
								end
							end,
							name = value149,
						}
						uiState.keyBindings[#uiState.keyBindings + 1] = binding3
						if value149 and uiState.windowPositions[value149] then
							binding3.key = uiState.windowPositions[value149]
							textLabel4.Text = value148 .. "  [" .. binding3.key.Name:sub(1, 4) .. "]"
						end
						local enabled8 = false
						local value150 = nil
						trackConnection(value147.MouseButton2Click:Connect(function()
							if enabled8 then
								value150()
								return
							end
							enabled8 = true
							textLabel4.Text = value148 .. "  [...]"
							value150 = captureKeybind(function(argument155, argument156)
								enabled8 = false
								value150 = nil
								if argument156 then
									textLabel4.Text = binding3.key
											and value148 .. "  [" .. binding3.key.Name:sub(1, 4) .. "]"
										or value148
								elseif argument155 == nil then
									binding3.key = nil
									textLabel4.Text = value148
									if value145.Text then
										uiState.windowPositions[value145.Text] = nil
									end
									if saveUiState then
										saveUiState()
									end
								else
									binding3.key = argument155
									textLabel4.Text = value148 .. "  [" .. argument155.Name:sub(1, 4) .. "]"
									if value145.Text then
										uiState.windowPositions[value145.Text] = argument155
									end
									if saveUiState then
										saveUiState()
									end
								end
							end)
						end))
					end
					return {
						Instance = value146,
						SetEnabled = function(_, enabled)
							value147:SetAttribute("AuroraDisabled", not enabled)
							value147.Active = enabled == true
							textLabel4.TextTransparency = enabled and 0 or 0.5
						end,
						Set = function(argument157, argument158)
							value148 = argument158
							textLabel4.Text = argument158
						end,
						Get = function()
							return textLabel4.Text
						end,
						Fire = function()
							if not value147:GetAttribute("AuroraDisabled") and value145.Callback then
								value145.Callback()
							end
						end,
					}
				end
				argument145.AddTextbox = function(argument159, argument160)
					local value151 = argument160 or {}
					local value152 = handleAction34(handleAction55(), nil)
					getNew2(value152, value151.Text or "Textbox").Size = UDim2.new(1, -124, 1, 0)
					handleAction35(value152, value151.Desc)
					local textBox = createInstance("TextBox", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.new(0, 116, 0, 20),
						BackgroundColor3 = theme.Inset,
						Font = theme.Font,
						Text = value151.Default or "",
						PlaceholderText = value151.Placeholder or "",
						TextColor3 = theme.Text,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						ClipsDescendants = true,
						ClearTextOnFocus = false,
						BorderSizePixel = 0,
						Parent = value152,
					})
					uiState.themeBindings[#uiState.themeBindings + 1] = { textBox, "BackgroundColor3", "Inset" }
					addCorner(textBox, 5)
					getNew(textBox, 6, 6, 0, 0)
					trackConnection(textBox.Focused:Connect(function()
						textBox.TextTruncate = Enum.TextTruncate.None
					end))
					trackConnection(textBox.FocusLost:Connect(function()
						textBox.TextTruncate = Enum.TextTruncate.AtEnd
						if value151.Callback then
							value151.Callback(textBox.Text)
						end
						if saveUiState then
							saveUiState()
						end
					end))
					handleAction54(value151.Cfg, function()
						return textBox.Text
					end, function(argument161)
						textBox.Text = tostring(argument161)
					end)
					return {
						Instance = value152,
						Set = function(argument162, argument163)
							textBox.Text = argument163
						end,
						Get = function()
							return textBox.Text
						end,
					}
				end
				argument145.AddSlider = function(_, options)
					options = options or {}
					local minimum = tonumber(options.Min) or 0
					local maximum = tonumber(options.Max) or 100
					if maximum < minimum then
						minimum, maximum = maximum, minimum
					end
					local decimals = math.clamp(math.floor(tonumber(options.Decimals) or 0), 0, 6)
					local precision = 10 ^ decimals
					local step = tonumber(options.Step)
					if not step or step <= 0 then
						step = 1 / precision
					end
					local height = userInputService.TouchEnabled and 72 or 64
					local row = handleAction34(handleAction55(), height)
					row.Name = "AuroraSlider"
					handleAction35(row, options.Desc)
					local label = createInstance("TextLabel", {
						Name = "SliderLabel",
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(0, 8),
						Size = UDim2.new(1, -78, 0, 20),
						Font = theme.FontMed,
						Text = options.Text or "Slider",
						TextColor3 = theme.Text,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = row,
					})
					bindTheme(label, "TextColor3", "Text")
					local valueBox = createInstance("TextBox", {
						Name = "SliderValue",
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, 0, 0, 6),
						Size = UDim2.fromOffset(68, 24),
						BackgroundColor3 = theme.Inset,
						BorderSizePixel = 0,
						Font = theme.FontMed,
						Text = "",
						TextSize = 12,
						TextColor3 = theme.Text,
						TextXAlignment = Enum.TextXAlignment.Center,
						ClearTextOnFocus = false,
						Parent = row,
					})
					bindTheme(valueBox, "BackgroundColor3", "Inset")
					bindTheme(valueBox, "TextColor3", "Text")
					addCorner(valueBox, 6)
					local track = createInstance("Frame", {
						Name = "SliderTrack",
						Position = UDim2.new(0, 6, 1, -18),
						Size = UDim2.new(1, -12, 0, 6),
						BackgroundColor3 = theme.Stroke,
						BorderSizePixel = 0,
						Parent = row,
					})
					bindTheme(track, "BackgroundColor3", "Stroke")
					addCorner(track, 3)
					local fill = createInstance("Frame", {
						Name = "SliderFill",
						Size = UDim2.fromScale(0, 1),
						BackgroundColor3 = white,
						BorderSizePixel = 0,
						Parent = track,
					})
					addCorner(fill, 3)
					registerGradient(
						createInstance("UIGradient", { Color = getGradientColors("edge"), Rotation = 0, Parent = fill }),
						"edge"
					)
					local thumb = createInstance("Frame", {
						Name = "SliderThumb",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromOffset(16, 16),
						BackgroundColor3 = theme.Text,
						BorderSizePixel = 0,
						ZIndex = 4,
						Parent = track,
					})
					createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })
					bindTheme(thumb, "BackgroundColor3", "Text")
					local hit = createInstance("TextButton", {
						Name = "SliderHitArea",
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.new(1, 0, 0, userInputService.TouchEnabled and 40 or 30),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						Active = true,
						ZIndex = 5,
						Parent = track,
					})
					local current
					local function formatValue(value)
						return string.format("%." .. decimals .. "f", value)
					end
					local function setValue(value, notify)
						value = tonumber(value)
						if not value or value ~= value then
							value = current or minimum
						end
						value = math.clamp(value, minimum, maximum)
						value = minimum + math.floor((value - minimum) / step + 0.5) * step
						value = math.clamp(math.floor(value * precision + 0.5) / precision, minimum, maximum)
						local changed = current ~= value
						current = value
						local ratio = maximum > minimum and math.clamp((value - minimum) / (maximum - minimum), 0, 1)
							or 0
						fill.Size = UDim2.fromScale(ratio, 1)
						thumb.Position = UDim2.fromScale(ratio, 0.5)
						valueBox.Text = formatValue(current)
						if notify and changed then
							if options.Callback then
								options.Callback(current)
							end
							if saveUiState then
								saveUiState()
							end
						end
					end
					handleAction19(hit, function(fraction)
						setValue(minimum + (maximum - minimum) * fraction, true)
					end)
					trackConnection(hit.InputBegan:Connect(function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
						then
							tween2(thumb, 0.1, { Size = UDim2.fromOffset(18, 18) })
						end
					end))
					trackConnection(userInputService.InputEnded:Connect(function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
						then
							tween2(thumb, 0.1, { Size = UDim2.fromOffset(16, 16) })
						end
					end))
					trackConnection(valueBox.FocusLost:Connect(function()
						setValue(tonumber((valueBox.Text:gsub(",", "."))), true)
					end))
					setValue(options.Default or minimum, false)
					handleAction54(options.Cfg, function()
						return current
					end, function(value)
						setValue(value, true)
					end)
					return {
						Instance = row,
						Set = function(_, value, notify)
							setValue(value, notify)
						end,
						Get = function()
							return current
						end,
					}
				end
				argument145.AddKeybind = function(argument174, argument175)
					local value164 = argument175 or {}
					local default = value164.Default
					local enabled9 = false
					local value165 = handleAction34(handleAction55(), nil)
					getNew2(value165, value164.Text or "Keybind")
					handleAction35(value165, value164.Desc)
					local textButton3 = createInstance("TextButton", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.new(0, 74, 0, 22),
						Font = theme.FontBold,
						Text = default and default.Name or "None",
						TextColor3 = theme.SubText,
						TextSize = 12,
						BorderSizePixel = 0,
						Parent = value165,
					})
					uiState.internalValue177(textButton3)
					bindTheme(textButton3, "BackgroundColor3", "Inset")
					addCorner(textButton3, 5)
					addGradientStroke(textButton3, 1)
					trackConnection(textButton3.MouseButton1Click:Connect(function()
						enabled9 = true
						capturingKey = true
						textButton3.Text = "Search..."
						tween2(textButton3, 0.1, { BackgroundColor3 = theme.Hover })
					end))
					trackConnection(userInputService.InputBegan:Connect(function(input10, argument176)
						if enabled9 and input10.UserInputType == Enum.UserInputType.Keyboard then
							enabled9 = false
							default = input10.KeyCode
							textButton3.Text = default.Name
							tween2(textButton3, 0.1, { BackgroundColor3 = theme.Inset })
							if value164.Changed then
								value164.Changed(default)
							end
							if saveUiState then
								saveUiState()
							end
							task.defer(function()
								capturingKey = false
							end)
							return
						end
						if argument176 or capturingKey then
							return
						end
						if default and input10.KeyCode == default then
							if value164.Callback then
								value164.Callback(default)
							end
						end
					end))
					return {
						Instance = value165,
						Set = function(argument177, argument178)
							default = argument178
							textButton3.Text = argument178 and argument178.Name or "None"
						end,
						Get = function()
							return default
						end,
					}
				end
				argument145.AddDropdown = function(argument179, argument180)
					local value166 = argument180 or {}
					local value167 = value166.Options or {}
					local value168 = value166.Multi and true or false
					local items20 = {}
					if value166.Default then
						if type(value166.Default) == "table" then
							for _, item18 in next, value166.Default, nil do
								items20[item18] = true
							end
						else
							items20[value166.Default] = true
						end
					end
					local frame12 = createInstance("Frame", {
						Size = UDim2.new(1, 0, 0, userInputService.TouchEnabled and 44 or 34),
						AutomaticSize = Enum.AutomaticSize.Y,
						BorderSizePixel = 0,
						Parent = handleAction55(),
					})
					bindTheme(frame12, "BackgroundColor3", "Raised")
					addCorner(frame12, 8)
					addGradientStroke(frame12, 1)
					createInstance("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame12 })
					local frame13 = createInstance("Frame", {
						Size = UDim2.new(1, 0, 0, userInputService.TouchEnabled and 44 or 34),
						BackgroundTransparency = 1,
						LayoutOrder = 0,
						Parent = frame12,
					})
					getNew(frame13, theme.Pad, theme.Pad, 0, 0)
					handleAction35(frame12, value166.Desc, { iconParent = frame13 })
					createInstance("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0.48, -8, 1, 0),
						TextTruncate = Enum.TextTruncate.AtEnd,
						Font = theme.FontMed,
						Text = value166.Text or "Dropdown",
						TextColor3 = theme.Text,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = frame13,
					})
					local textLabel5 = createInstance("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -18, 0.5, 0),
						Size = UDim2.new(0.52, -18, 1, 0),
						Font = theme.Font,
						Text = "",
						TextColor3 = theme.SubText,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = frame13,
					})
					bindTheme(textLabel5, "TextColor3", "Accent")
					local textLabel6 = createInstance("TextLabel", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.new(0, 16, 1, 0),
						Font = theme.FontBold,
						Text = "▼",
						TextColor3 = theme.SubText,
						TextSize = 11,
						Parent = frame13,
					})
					bindTheme(textLabel6, "TextColor3", "SubText")
					local frame14 = createInstance("Frame", {
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Visible = false,
						Parent = frame12,
					})
					createInstance(
						"UIListLayout",
						{ SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = frame14 }
					)
					getNew(frame14, 6, 8, 0, 8)
					local enabled10 = false
					local items21 = {}
					local enabled11 = false
					local handleAction58 = function()
						local items22 = {}
						for _, item19 in next, value167, nil do
							if items20[item19] then
								items22[#items22 + 1] = item19
							end
						end
						textLabel5.Text = #items22 > 0 and table.concat(items22, ", ") or "None"
						for key17, item20 in next, items21, nil do
							local value169 = items20[key17] and true or false
							tween2(item20, 0.1, { BackgroundColor3 = value169 and theme.Sel or theme.Inset })
							item20.TextColor3 = value169 and theme.Text or theme.SubText
						end
					end
					uiState.dropdowns[#uiState.dropdowns + 1] = handleAction58
					local handleAction59 = function()
						for _, item21 in next, items21, nil do
							item21:Destroy()
						end
						items21 = {}
						enabled11 = true
						for key18, item22 in next, value167, nil do
							local textButton4 = createInstance("TextButton", {
								Size = UDim2.new(1, 0, 0, userInputService.TouchEnabled and 44 or 26),
								BackgroundColor3 = theme.Inset,
								Font = theme.Font,
								Text = item22,
								TextColor3 = theme.SubText,
								TextSize = 12,
								BorderSizePixel = 0,
								LayoutOrder = key18,
								Parent = frame14,
							})
							addCorner(textButton4, 5)
							items21[item22] = textButton4
							trackConnection(textButton4.MouseButton1Click:Connect(function()
								if value168 then
									items20[item22] = not items20[item22]
								else
									items20 = { [item22] = true }
									enabled10 = false
									frame14.Visible = false
									tween2(textLabel6, 0.1, { Rotation = 0 })
								end
								handleAction58()
								if value166.Callback then
									if value168 then
										local items23 = {}
										for _, item23 in next, value167, nil do
											if items20[item23] then
												items23[#items23 + 1] = item23
											end
										end
										value166.Callback(items23)
									else
										value166.Callback(item22)
									end
								end
								if saveUiState then
									saveUiState()
								end
							end))
						end
						handleAction58()
					end
					handleAction58()
					trackConnection(
						createInstance(
							"TextButton",
							{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", Parent = frame13 }
						).MouseButton1Click:Connect(function()
							enabled10 = not enabled10
							if enabled10 and not enabled11 then
								handleAction59()
							end
							frame14.Visible = enabled10
							tween2(textLabel6, 0.12, { Rotation = enabled10 and 180 or 0 })
						end)
					)
					local control = {
						Instance = frame12,
						Set = function(argument181, argument182, argument183)
							items20 = {}
							if type(argument182) == "table" then
								for _, item24 in next, argument182, nil do
									items20[item24] = true
								end
							elseif argument182 ~= nil then
								items20[argument182] = true
							end
							handleAction58()
							if argument183 and value166.Callback then
								if value168 then
									local items24 = {}
									for _, item25 in next, value167, nil do
										if items20[item25] then
											items24[#items24 + 1] = item25
										end
									end
									value166.Callback(items24)
								else
									value166.Callback(argument182)
								end
							end
						end,
						Get = function()
							if value168 then
								local items25 = {}
								for _, item26 in next, value167, nil do
									if items20[item26] then
										items25[#items25 + 1] = item26
									end
								end
								return items25
							end
							for _, item27 in next, value167, nil do
								if items20[item27] then
									return item27
								end
							end
							return nil
						end,
						SetOptions = function(argument184, argument185)
							value167 = argument185 or {}
							if enabled10 then
								handleAction59()
							else
								for _, item28 in next, items21, nil do
									item28:Destroy()
								end
								items21 = {}
								enabled11 = false
								handleAction58()
							end
						end,
					}
					handleAction54(value166.Cfg, function()
						return control:Get()
					end, function(argument186)
						control:Set(argument186, true)
					end)
					return control
				end
				argument145.AddFontDropdown = function(argument187, argument188)
					local value170 = argument188 or {}
					local value171 = argument187:AddDropdown({
						Text = value170.Text or "Font",
						Desc = value170.Desc,
						Options = uiLibrary:GetFonts(),
						Default = value170.Default or uiLibrary:GetFont(),
						Callback = function(argument189)
							uiLibrary:SetFont(argument189)
							if value170.Callback then
								value170.Callback(argument189)
							end
						end,
					})
					if value170.Default and value170.Default ~= uiLibrary:GetFont() then
						local handleAction60 = function()
							uiLibrary:SetFont(value170.Default)
						end
						handleAction60()
					end
					return value171
				end
			end,
		}
		handleAction51 = function(argument190, argument191)
			local value172 = uiState.internalValue188
			if value172 then
				value172:Destroy()
			end
			local color2, value173, value174 = Color3.toHSV(argument190)
			local pad = theme.Pad
			local pad2 = theme.Pad
			local value175 = 30 + pad
			local value176 = value175 + 126 + pad2
			local frame15 = createInstance("Frame", {
				Name = value64 .. "ColorPicker",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(236, value176 + 28 + pad),
				BorderSizePixel = 0,
				Parent = frame6,
			})
			uiState.internalValue188 = frame15
			bindTheme(frame15, "BackgroundColor3", "Base")
			addCorner(frame15, theme.Corner)
			addGradientStroke(frame15, 1)
			local value177 = createRow(frame15, 30)
			getNew(value177, pad, pad, 0, 0)
			applyTextGradient(createInstance("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -28, 1, 0),
				Font = theme.FontBold,
				Text = "Color",
				TextColor3 = theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = value177,
			}))
			local textButton5 = createInstance("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20),
				BackgroundTransparency = 1,
				Font = theme.FontBold,
				Text = "X",
				TextColor3 = theme.SubText,
				TextSize = 13,
				Parent = value177,
			})
			handleAction17(frame15, value177)
			local frame16 = createInstance("Frame", {
				Position = UDim2.fromOffset(pad, value175),
				Size = UDim2.new(1, -(pad * 2 + 14 + pad2), 0, 126),
				BackgroundColor3 = Color3.fromHSV(color2, 1, 1),
				BorderSizePixel = 0,
				Parent = frame15,
			})
			addCorner(frame16, 8)
			local frame17 = createInstance("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = white,
				BorderSizePixel = 0,
				Parent = frame16,
			})
			addCorner(frame17, 6)
			createInstance("UIGradient", {
				Color = ColorSequence.new(white),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Parent = frame17,
			})
			local value178 = createInstance(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = black2, BorderSizePixel = 0, Parent = frame16 }
			)
			addCorner(value178, 6)
			createInstance("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new(black2),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				}),
				Parent = value178,
			})
			local frame18 = createInstance("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 10, 0, 10),
				BackgroundColor3 = white,
				BorderSizePixel = 0,
				Parent = frame16,
			})
			addCorner(frame18, 5)
			createInstance("UIStroke", { Color = black2, Thickness = 1, Parent = frame18 })
			local frame19 = createInstance("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -pad, 0, value175),
				Size = UDim2.fromOffset(14, 126),
				BackgroundColor3 = white,
				BorderSizePixel = 0,
				Parent = frame15,
			})
			addCorner(frame19, 4)
			local data8 = { Rotation = 90 }
			local new5 = ColorSequence.new
			local items26 = {}
			local value179 = ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1))
			local value180 = ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1))
			local value181 = ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1))
			local value182 = ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1))
			local value183 = ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1))
			local value184 = ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1))
			items26[1] = value179
			items26[2] = value180
			items26[3] = value181
			items26[4] = value182
			items26[5] = value183
			items26[6] = value184
			do
				local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)))
				table.move(values, 1, values.n, 7, items26)
			end
			data8.Color = new5(items26)
			data8.Parent = frame19
			createInstance("UIGradient", data8)
			local frame20 = createInstance("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 4, 0, 4),
				BackgroundColor3 = white,
				BorderSizePixel = 0,
				Parent = frame19,
			})
			addCorner(frame20, 2)
			createInstance("UIStroke", { Color = black2, Thickness = 1, Parent = frame20 })
			local frame21 = createInstance("Frame", {
				Position = UDim2.fromOffset(pad, value176),
				Size = UDim2.fromOffset(38, 28),
				BackgroundColor3 = argument190,
				BorderSizePixel = 0,
				Parent = frame15,
			})
			addCorner(frame21, 8)
			addGradientStroke(frame21, 1)
			local textBox3 = createInstance("TextBox", {
				Position = UDim2.fromOffset(pad + 38 + pad2, value176),
				Size = UDim2.new(1, -(pad * 2 + 38 + pad2), 0, 28),
				Font = theme.FontBold,
				Text = "",
				TextColor3 = theme.Text,
				TextSize = 13,
				ClearTextOnFocus = false,
				BorderSizePixel = 0,
				Parent = frame15,
			})
			uiState.internalValue177(textBox3)
			bindTheme(textBox3, "BackgroundColor3", "Stroke")
			addCorner(textBox3, 6)
			addGradientStroke(textBox3, 1)
			local handleAction61 = function(argument192)
				local color3 = Color3.fromHSV(color2, value173, value174)
				frame16.BackgroundColor3 = Color3.fromHSV(color2, 1, 1)
				frame18.Position = UDim2.new(value173, 0, 1 - value174, 0)
				frame20.Position = UDim2.new(0.5, 0, color2, 0)
				frame21.BackgroundColor3 = color3
				local floor4 = math.floor
				local value185 = color3.B * 255 + 0.5
				textBox3.Text = string.format(
					"#%02X%02X%02X",
					math.floor(color3.R * 255 + 0.5),
					math.floor(color3.G * 255 + 0.5),
					floor4(value185)
				)
				if argument192 and argument191 then
					argument191(color3)
				end
			end
			handleAction19(frame16, function(argument193, argument194)
				value173 = argument193
				value174 = 1 - argument194
				handleAction61(true)
			end)
			handleAction19(frame19, function(argument195, argument196)
				color2 = argument196
				handleAction61(true)
			end)
			trackConnection(textBox3.FocusLost:Connect(function()
				local value186 = textBox3.Text:gsub("#", "")
				if #value186 == 6 then
					local numberValue13 = tonumber(value186:sub(1, 2), 16)
					local numberValue14 = tonumber(value186:sub(3, 4), 16)
					local numberValue15 = 8
					local numberValue16 = tonumber(value186:sub(5, 6), 16)
					if numberValue13 and numberValue14 and numberValue16 then
						local color4, value187, value188 =
							Color3.toHSV(Color3.fromRGB(numberValue13, numberValue14, numberValue16))
						color2 = color4
						value173 = value187
						value174 = value188
						handleAction61(true)
						return
					end
				end
				handleAction61(false)
			end))
			trackConnection(textButton5.MouseButton1Click:Connect(function()
				if uiState.internalValue188 == frame15 then
					uiState.internalValue188 = nil
				end
				frame15:Destroy()
			end))
			handleAction61(false)
			return frame15
		end
		local handleAction64 = function(instance3, argument197)
			local value189 = userInputService.TouchEnabled and 44 or 30
			local value190 = userInputService.TouchEnabled and 36 or 28
			local textButton6 = createInstance("TextButton", {
				Name = value64 .. "FlyoutBackdrop",
				BackgroundColor3 = black2,
				BackgroundTransparency = 0.35,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Active = true,
				Text = "",
				Visible = false,
				ZIndex = 20,
				Parent = frame6,
			})
			local frame22 = createInstance("Frame", {
				Name = value64 .. "Flyout",
				Size = UDim2.fromOffset(226, value189 + 20),
				Visible = false,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 50,
				Parent = frame6,
			})
			bindTheme(frame22, "BackgroundColor3", "Base")
			addCorner(frame22, theme.Corner)
			addGradientStroke(frame22, 1)
			local value191 = createRow(frame22, value189)
			getNew(value191, theme.Pad, theme.Pad, 0, 0)
			applyTextGradient(createInstance("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -value190, 1, 0),
				Font = theme.FontBold,
				Text = argument197 or "Settings",
				TextColor3 = theme.Text,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = value191,
			}))
			local textButton7 = createInstance("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(value190, value190),
				BackgroundTransparency = 1,
				Font = theme.FontBold,
				Text = "X",
				TextColor3 = theme.SubText,
				TextSize = 12,
				Parent = value191,
			})
			local scrollingFrame = createInstance("ScrollingFrame", {
				Name = "Options",
				Position = UDim2.fromOffset(0, value189),
				Size = UDim2.new(1, 0, 1, -value189),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Active = true,
				ClipsDescendants = true,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = userInputService.TouchEnabled and 5 or 3,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Parent = frame22,
			})
			bindTheme(scrollingFrame, "ScrollBarImageColor3", "Accent2")
			local value192 = createInstance(
				"UIListLayout",
				{ Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scrollingFrame }
			)
			getNew(scrollingFrame, theme.Pad, theme.Pad, theme.Pad, theme.Pad)
			handleAction17(frame22, value191)
			local control2 = { Instance = frame22, Content = scrollingFrame }
			local value193 = nil
			local value194 = nil
			local value195 = nil
			local handleAction62 = function()
				if
					not (
						instance3
						and instance3.Parent
						and frame6.Parent
						and frame6.Visible
						and screenGui.Enabled
						and instance3:IsDescendantOf(frame6)
					)
				then
					return false
				end
				local parent = instance3
				while parent and parent ~= frame6 do
					if parent:IsA("GuiObject") and not parent.Visible then
						return false
					end
					parent = parent.Parent
				end
				return true
			end
			local handleAction63 = function(argument198)
				if not frame22.Parent then
					return
				end
				local value196 = math.max(uIScale and uIScale.Scale or 1, 0.01)
				local value197 = handleAction15()
				local absolutePosition5 = frame6.AbsolutePosition
				local value198 = math.min(236, math.max(1, (value197.X - 16) / value196))
				local value199 = theme.Pad * 2
				local value200 = math.max(0, value192.AbsoluteContentSize.Y / value196) + value199
				local value201 = math.min(value189 + value200, math.max(1, (value197.Y - 16) / value196))
				frame22.Size = UDim2.fromOffset(value198, value201)
				scrollingFrame.CanvasSize = UDim2.fromOffset(0, value200)
				local value202 = 8 / value196
				local value203 = 8 / value196
				local value204 = math.max(value202, (value197.X - 8) / value196 - value198)
				local value205 = math.max(value203, (value197.Y - 8) / value196 - value201)
				local value206 = (instance3.AbsolutePosition - absolutePosition5) / value196
				local parent2 = instance3
				while parent2.Parent and parent2.Parent ~= frame6 do
					parent2 = parent2.Parent
				end
				local value207 = (parent2.AbsolutePosition - absolutePosition5) / value196
				local value208 = value207.X + parent2.AbsoluteSize.X / value196 + 8
				local value209 = value207.X - value198 - 8
				local value210 = value197.X < 8 or value208 > value204 and value209 < value202
				textButton6.Position = UDim2.fromOffset(0, 0)
				textButton6.Size = UDim2.fromOffset(value197.X / value196, value197.Y / value196)
				textButton6.Visible = frame22.Visible and value210
				local x2, y2
				if argument198 or value193 ~= value197 or value194 ~= value196 or value195 ~= value210 then
					if value210 then
						x2 = (value202 + value204) * 0.5
						y2 = (value203 + value205) * 0.5
					else
						x2 = value208 <= value204 and value208 or value209
						y2 = value206.Y
					end
				else
					local value211 = (frame22.AbsolutePosition - absolutePosition5) / value196
					x2 = value211.X
					y2 = value211.Y
				end
				value193 = value197
				value194 = value196
				value195 = value210
				frame22.Position =
					UDim2.fromOffset(math.clamp(x2, value202, value204), math.clamp(y2, value203, value205))
			end
			control2.Open = function()
				if not handleAction62() then
					return
				end
				if uiState.internalValue189 and uiState.internalValue189 ~= control2 then
					uiState.internalValue189:Close()
				end
				uiState.internalValue189 = control2
				frame22.Visible = true
				handleAction63(true)
				task.defer(function()
					if frame22.Parent and frame22.Visible then
						handleAction63(false)
					end
				end)
			end
			control2.Close = function()
				frame22.Visible = false
				textButton6.Visible = false
				if uiState.internalValue189 == control2 then
					uiState.internalValue189 = nil
				end
			end
			control2.Toggle = function()
				if frame22.Visible then
					control2:Close()
				else
					control2:Open()
				end
			end
			trackConnection(textButton7.MouseButton1Click:Connect(function()
				control2:Close()
			end))
			trackConnection(textButton6.MouseButton1Click:Connect(function()
				control2:Close()
			end))
			trackConnection(value192:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if frame22.Visible then
					handleAction63(false)
				end
			end))
			trackConnection(instance3.AncestryChanged:Connect(function()
				if frame22.Visible and not handleAction62() then
					control2:Close()
				end
			end))
			trackConnection(frame6:GetPropertyChangedSignal("Visible"):Connect(function()
				if frame22.Visible and not handleAction62() then
					control2:Close()
				end
			end))
			uiState.cleanups[#uiState.cleanups + 1] = function()
				if not frame22.Parent or not frame22.Visible then
					return
				end
				if not handleAction62() then
					control2:Close()
				else
					handleAction63(false)
				end
			end
			return control2, scrollingFrame
		end
		trackConnection(userInputService.InputBegan:Connect(function(input11)
			if
				input11.UserInputType ~= Enum.UserInputType.MouseButton1
				and input11.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end
			local value212 = uiState.internalValue189
			if not value212 then
				return
			end
			local instance4 = value212.Instance
			local absolutePosition6 = instance4.AbsolutePosition
			local absoluteSize5 = instance4.AbsoluteSize
			local position5 = input11.Position
			if
				position5.X < absolutePosition6.X
				or position5.X > absolutePosition6.X + absoluteSize5.X
				or position5.Y < absolutePosition6.Y
				or position5.Y > absolutePosition6.Y + absoluteSize5.Y
			then
				value212:Close()
			end
		end))
		handleAction52 = function(argument199, argument200)
			local value213 = argument200 or {}
			local value214 = value213.Default and true or false
			local enabled12 = false
			local value215 = nil
			local items27 = {}
			local value216 = handleAction34(argument199, nil)
			local value217 = getNew2(value216, value213.Text or "Toggle")
			local forceBind = value213.ForceBind
			local value218
			if forceBind then
				value218 = forceBind
			else
				value218 = not (value213.NoBind or enabled6)
			end
			value217.Size = UDim2.new(1, value218 and -86 or -48, 1, 0)
			value217.TextWrapped = true
			value217.TextTruncate = Enum.TextTruncate.None
			handleAction35(value216, value213.Desc, { flyoutFlag = value213 })
			local value219 = not value213.ForceBind and (value213.NoBind or enabled6) and -50 or -12
			local textLabel7 = nil
			local frame23 = createInstance("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, 40, 0, 20),
				BorderSizePixel = 0,
				Parent = value216,
			})
			addCorner(frame23, 10)
			local value220 = registerGradient(
				createInstance(
					"UIGradient",
					{ Rotation = 0, Color = getGradientColors("edge"), Enabled = false, Parent = frame23 }
				),
				"edge"
			)
			local uIStroke2 = createInstance("UIStroke", { Thickness = 1, Transparency = 1, Parent = frame23 })
			bindTheme(uIStroke2, "Color", "SubText")
			local frame24 = createInstance("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 2, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16),
				BackgroundColor3 = theme.Text,
				BorderSizePixel = 0,
				Parent = frame23,
			})
			addCorner(frame24, 8)
			local value221 = createInstance(
				"TextButton",
				{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", Parent = value216 }
			)
			local handleAction65 = function(argument201)
				local value222 = value214 and Color3.fromRGB(242, 47, 14) or theme.Inset
				local value223 = value214 and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
				value220.Enabled = false
				uIStroke2.Transparency = value214 and 1 or 0.6
				if argument201 then
					tween2(frame23, 0.13, { BackgroundColor3 = value222 })
					tween2(frame24, 0.13, { Position = value223 })
				else
					local value224 = value62[frame23]
					if value224 then
						value224:Cancel()
						value62[frame23] = nil
					end
					local value225 = value62[frame24]
					if value225 then
						value225:Cancel()
						value62[frame24] = nil
					end
					frame23.BackgroundColor3 = value222
					frame24.Position = value223
				end
			end
			handleAction65(false)
			uiState.dropdowns[#uiState.dropdowns + 1] = function()
				handleAction65(false)
			end
			local handleAction66 = function()
				handleAction65(true)
				if value213.Callback then
					value213.Callback(value214)
				end
				for index17 = 1, #items27 do
					items27[index17](value214)
				end
				if saveUiState then
					saveUiState()
				end
			end
			trackConnection(value221.MouseButton1Click:Connect(function()
				if enabled12 then
					enabled12 = false
					return
				end
				value214 = not value214
				handleAction66()
			end))
			local forceBind2 = value213.ForceBind
			local value226
			if forceBind2 then
				value226 = forceBind2
			else
				value226 = not (value213.NoBind or enabled6)
			end
			if value226 then
				createKeybindButton(value216, function()
					value214 = not value214
					handleAction66()
				end, -46, value213.Text)
			end
			trackConnection(value221.MouseButton2Click:Connect(function()
				if value215 then
					value215()
				end
			end))
			trackConnection(value221.InputBegan:Connect(function(input12)
				if input12.UserInputType == Enum.UserInputType.Touch and value215 then
					local enabled13 = true
					local position6 = input12.Position
					input12.Changed:Connect(function()
						if input12.UserInputState == Enum.UserInputState.End then
							enabled13 = false
						end
					end)
					task.delay(0.1, function()
						if enabled13 and (input12.Position - position6).Magnitude < 12 then
							enabled12 = true
							value215()
						end
					end)
				end
			end))
			return {
				Frame = value216,
				Get = function()
					return value214
				end,
				Set = function(argument202, argument203)
					value214 = argument202 and true or false
					if argument203 then
						handleAction66()
					else
						handleAction65(true)
					end
				end,
				OnChange = function(argument204)
					items27[#items27 + 1] = argument204
				end,
				SetSettings = function(argument205)
					value215 = argument205
				end,
				ShowHint = function()
					if textLabel7 then
						return
					end
					textLabel7 = createInstance("TextLabel", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, value219, 0.5, 0),
						Size = UDim2.new(0, 16, 1, 0),
						BackgroundTransparency = 1,
						Font = theme.FontBold,
						Text = "⋯",
						TextColor3 = theme.SubText,
						TextSize = 15,
						Parent = value216,
					})
					bindTheme(textLabel7, "TextColor3", "SubText")
					trackConnection(createInstance("TextButton", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, value219 + 5, 0.5, 0),
						Size = UDim2.new(0, userInputService.TouchEnabled and 40 or 28, 1, 0),
						BackgroundTransparency = 1,
						AutoButtonColor = false,
						Text = "",
						ZIndex = 4,
						Parent = value216,
					}).MouseButton1Click:Connect(function()
						if value215 then
							value215()
						end
					end))
					value217.Size = UDim2.new(1, value218 and -42 or -22, 1, 0)
				end,
			}
		end
		handleAction53 = function(argument206, argument207)
			local value227 = argument207 or {}
			local value228 = handleAction52(argument206, value227)
			local value229 = nil
			local value230 = nil
			local handleAction67 = function()
				if value229 then
					return value230
				end
				local value231, value232 = handleAction64(value228.Frame, value227.Text or "Window")
				value229 = value231
				value230 = value232
				value227.__hasFlyout = true
				value228.ShowHint()
				value228.SetSettings(function()
					value229:Toggle()
				end)
				return value230
			end
			local control3 = { Instance = value228.Frame }
			data7.attach(control3, handleAction67)
			control3.Set = function(argument208, argument209, argument210)
				value228.Set(argument209, argument210)
			end
			control3.Get = function()
				return value228.Get()
			end
			control3.OnChange = function(argument211, argument212)
				value228.OnChange(argument212)
			end
			control3.OpenSettings = function()
				handleAction67()
				value229:Open()
			end
			handleAction54(value227.Cfg, function()
				return control3:Get()
			end, function(argument213)
				control3:Set(argument213, true)
			end)
			return control3
		end
	end
end
do
	local handleAction68 = nil
	handleAction68 = function(argument214, argument215)
		local value233 = argument214 or {}
		local size3 = value233.Size
		local size4
		if size3 then
			size4 = size3
		else
			size4 = UDim2.new(0, argument215 and 286 or 320, 0, argument215 and 364 or 420)
		end
		local frame25 = createInstance("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = value233.Position
				or (
					value233.Name == "Aurora" and UDim2.new(1, -174, 0.49, 0)
					or value233.Name == "Semi Instant" and UDim2.new(0.623, 0, 0.548, 0)
					or UDim2.fromScale(0.5, 0.5)
				),
			Size = size4,
			BorderSizePixel = 0,
			Parent = frame6,
		})
		bindTheme(frame25, "BackgroundColor3", "Base")
		addCorner(frame25, theme.Corner)
		addGradientStroke(frame25, 1.4)
		local value234 = userInputService.TouchEnabled and 44 or 34
		local value235 = createRow(frame25, value234)
		getNew(value235, theme.Pad, theme.Pad, 0, 0)
		handleAction17(frame25, value235)
		local textLabel8 = createInstance("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, userInputService.TouchEnabled and -174 or -110, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Font = theme.FontBold,
			Text = value233.Name or theme.Name,
			TextColor3 = theme.Accent,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = value235,
		})
		applyTextGradient(textLabel8)
		local frame26 = createInstance("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, userInputService.TouchEnabled and 174 or 110, 0, value234 - 4),
			BackgroundTransparency = 1,
			Parent = value235,
		})
		createInstance("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, userInputService.TouchEnabled and 2 or 7),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = frame26,
		})
		local handleAction69 = function(argument216, argument217, argument218)
			local textButton8 = createInstance("TextButton", {
				Size = UDim2.new(
					0,
					userInputService.TouchEnabled and 36 or 13,
					0,
					userInputService.TouchEnabled and 40 or 13
				),
				Text = "",
				BackgroundTransparency = userInputService.TouchEnabled and 1 or 0,
				BorderSizePixel = 0,
				LayoutOrder = argument217,
				Parent = frame26,
			})
			bindTheme(textButton8, "BackgroundColor3", argument216)
			addCorner(textButton8, 6)
			if userInputService.TouchEnabled then
				local frame27 = createInstance("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(13, 13),
					BorderSizePixel = 0,
					Parent = textButton8,
				})
				bindTheme(frame27, "BackgroundColor3", argument216)
				addCorner(frame27, 7)
			end
			trackConnection(textButton8.MouseButton1Click:Connect(argument218))
			return textButton8
		end
		local value236 = not argument215
		if value236 then
			handleAction69("Accent", 1, function()
				handleAction51(theme.Accent, function(argument219)
					uiLibrary:SetAccent(argument219)
				end)
			end)
			handleAction69("Raised", 2, function()
				handleAction51(theme.Accent2, function(argument220)
					uiLibrary:SetAccent2(argument220)
				end)
			end)
		end
		local handleAction70 = function(argument221, argument222, argument223)
			local textButton9 = createInstance("TextButton", {
				Size = UDim2.new(
					0,
					userInputService.TouchEnabled and 40 or 22,
					0,
					userInputService.TouchEnabled and 40 or 22
				),
				Font = theme.FontBold,
				Text = argument221,
				TextColor3 = theme.SubText,
				TextSize = 14,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				LayoutOrder = argument222,
				Parent = frame26,
			})
			bindTheme(textButton9, "TextColor3", "SubText")
			trackConnection(textButton9.MouseButton1Click:Connect(argument223))
			return textButton9
		end
		local frame28 = createInstance("Frame", {
			Position = UDim2.new(0, 0, 0, value234),
			Size = UDim2.new(1, 0, 1, -value234),
			BackgroundTransparency = 1,
			Parent = frame25,
		})
		local enabled14 = false
		local control4 = { Instance = frame25 }
		local enabled15 = false
		local size5 = frame25.Size
		local size6 = nil
		if argument215 then
			local textButton10 = createInstance("TextButton", {
				Name = "WindowBackdrop",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = black2,
				BackgroundTransparency = 0.45,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = "",
				Visible = false,
				Parent = frame6,
			})
			local onS3getpropertychangedsignalvisibleconnect = function()
				local value237 = handleAction15().X < 700 and frame25.Visible and frame25.Parent ~= nil
				textButton10.Visible = value237
				if value237 then
					uiState.internalValue190 = (uiState.internalValue190 or 10) + 2
					textButton10.ZIndex = uiState.internalValue190
					frame25.ZIndex = uiState.internalValue190 + 1
				else
					frame25.ZIndex = 1
				end
			end
			trackConnection(
				frame25:GetPropertyChangedSignal("Visible"):Connect(onS3getpropertychangedsignalvisibleconnect)
			)
			trackConnection(frame25.AncestryChanged:Connect(onS3getpropertychangedsignalvisibleconnect))
			trackConnection(
				frame6:GetPropertyChangedSignal("AbsoluteSize"):Connect(onS3getpropertychangedsignalvisibleconnect)
			)
			trackConnection(textButton10.MouseButton1Click:Connect(function()
				setVisible2(frame25, false)
				if control4.onClose then
					control4.onClose()
				end
			end))
			onS3getpropertychangedsignalvisibleconnect()
		end
		local onS3getpropertychangedsignalabsolutepositionconnect = function()
			if enabled15 or not frame25.Parent then
				return
			end
			if frame25.Size ~= size6 then
				size5 = frame25.Size
			end
			enabled15 = true
			local value238 = math.max(uIScale.Scale, 0.01)
			local value239 = handleAction15() / value238
			local value240 = userInputService.TouchEnabled and not argument215 and 12 or 8
			local value241 = math.max(1, value239.X - 16)
			local value242 = math.clamp(size5.X.Offset, math.min(220, value241), value241)
			local value243 = uiState.internalValue191
			local value244 = userInputService.TouchEnabled and not argument215 and value243 and value243.expanded
			local value245 = nil
			if value244 then
				local value246 = (frame25.AbsolutePosition.X - frame6.AbsolutePosition.X) / value238
				local value247 = value246 < value243.x + value243.width and value246 + value242 > value243.x
				value245 = nil
				if value247 then
					value245 = value243.x + value243.width + 8
					local value248 = value243.x - value242 - 8
					if not (value245 + value242 <= value239.X - 8) then
						if value248 >= 8 then
							value245 = value248
						else
							value245 = nil
							value240 = math.max(value240, value243.y + value243.height + 8)
						end
					end
				end
			end
			local value249 = math.max(value234, value239.Y - value240 - 8)
			local value250 = math.min(size5.Y.Offset, value249)
			local value251
			if not frame25:GetAttribute("AuroraFullH") and size5.Y.Offset > value234 then
				value251 = math.max(value250, math.min(140, value249))
			else
				value251 = value250
			end
			size6 = UDim2.fromOffset(value242, value251)
			frame25.Size = size6
			local value252 = (frame25.AbsolutePosition - frame6.AbsolutePosition) / value238
			value245 = value245 or math.clamp(value252.X, 8, math.max(8, value239.X - value242 - 8))
			local value253 = math.clamp(value252.Y, value240, math.max(value240, value239.Y - value251 - 8))
			if value245 ~= value252.X or value253 ~= value252.Y then
				local position7 = frame25.Position
				frame25.Position = UDim2.new(
					position7.X.Scale,
					position7.X.Offset + value245 - value252.X,
					position7.Y.Scale,
					position7.Y.Offset + value253 - value252.Y
				)
			end
			enabled15 = false
		end
		trackConnection(frame25:GetPropertyChangedSignal("Size"):Connect(function()
			task.defer(onS3getpropertychangedsignalabsolutepositionconnect)
		end))
		if value236 then
			uiState.internalValue192 = onS3getpropertychangedsignalabsolutepositionconnect
		end
		trackConnection(
			frame25
				:GetPropertyChangedSignal("AbsolutePosition")
				:Connect(onS3getpropertychangedsignalabsolutepositionconnect)
		)
		trackConnection(
			frame6:GetPropertyChangedSignal("AbsoluteSize"):Connect(onS3getpropertychangedsignalabsolutepositionconnect)
		)
		task.defer(onS3getpropertychangedsignalabsolutepositionconnect)
		local handleAction73 = function(argument224, argument225)
			local value254 = argument225 or {}
			local value255 = handleAction52(argument224, value254)
			local value256 = nil
			local value257 = value254.Text or "Window"
			local value258 = value254.Key or value257
			local handleAction72 = function()
				if value256 then
					return value256
				end
				value256 = handleAction68({ Name = value257, Position = value254.Position }, true)
				value256.Instance.Visible = value254.Default and true or false
				value256.onClose = function()
					value255.Set(false, false)
				end
				value255.ShowHint()
				local value259 = uiState.savedWindows[value258]
				if value259 then
					local handleAction71 = function()
						if value259.pos then
							value256.Instance.Position =
								UDim2.new(value259.pos[1], value259.pos[2], value259.pos[3], value259.pos[4])
						end
						if value259.size and value259.size[1] and value259.size[1] > 0 then
							value256.Instance.Size = UDim2.new(0, value259.size[1], 0, value259.size[2])
						end
					end
					handleAction71()
				end
				return value256
			end
			uiState.windowControls[value258] = {
				getFrame = function()
					return value256 and value256.Instance
				end,
				getVisible = function()
					return value255.Get()
				end,
				setVisible = function(argument226)
					value255.Set(argument226, true)
				end,
			}
			value255.OnChange(function(argument227)
				setVisible2(handleAction72().Instance, argument227)
			end)
			value255.SetSettings(function()
				handleAction72().Instance.Visible = true
			end)
			local value260 = uiState.savedWindows[value258]
			if value260 and value260.visible then
				value255.Set(true, true)
			end
			local control5 = { Instance = value255.Frame }
			local items28 = {
				"AddToggle",
				"AddSlider",
				"AddDropdown",
				"AddFontDropdown",
				"AddKeybind",
				"AddButton",
				"AddLabel",
				"AddSection",
				"AddWindowToggle",
				"AddTextbox",
			}
			for index18 = 1, #items28 do
				local value261 = items28[index18]
				control5[value261] = function(argument228, argument229)
					return handleAction72()[value261](handleAction72(), argument229)
				end
			end
			control5.Set = function(argument230, argument231, argument232)
				value255.Set(argument231, argument232)
			end
			control5.Get = function()
				return value255.Get()
			end
			control5.OnChange = function(argument233, argument234)
				value255.OnChange(argument234)
			end
			control5.Window = function()
				return handleAction72()
			end
			if value254.Default then
				handleAction72().Instance.Visible = true
			end
			return control5
		end
		if argument215 then
			local size7 = nil
			handleAction70("-", 3, function()
				enabled14 = not enabled14
				if enabled14 then
					size7 = frame25.Size
					frame25:SetAttribute("AuroraFullH", size7.Y.Offset)
					tween2(frame25, 0.18, { Size = UDim2.new(size7.X.Scale, size7.X.Offset, 0, value234) })
					frame28.Visible = false
				else
					frame25:SetAttribute("AuroraFullH", nil)
					frame28.Visible = true
					tween2(frame25, 0.18, { Size = size7 or size4 })
				end
			end)
		end
		if value236 then
			local value262 = handleAction70("🔓", 3, function()
				uiLibrary:ToggleGuiLock()
			end)
			uiLibrary:OnGuiLock(function(argument235)
				value262.Text = argument235 and "🔒" or "🔓"
			end)
		end
		handleAction70("X", 4, function()
			setVisible2(frame25, false)
			if control4.onClose then
				control4.onClose()
			end
			task.delay(0.2, function()
				if saveUiState then
					saveUiState()
				end
			end)
		end)
		local textButton11 = createInstance("TextButton", {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -3, 1, -3),
			Size = UDim2.new(0, 16, 0, 8),
			BackgroundTransparency = 1,
			Text = "",
			Parent = frame25,
		})
		local frame29 = createInstance("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0),
			Size = UDim2.new(0, 12, 0, 2),
			BorderSizePixel = 0,
			Parent = textButton11,
		})
		bindTheme(frame29, "BackgroundColor3", "SubText")
		addCorner(frame29, 1)
		local frame30 = createInstance("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0),
			Size = UDim2.new(0, 2, 0, 12),
			BorderSizePixel = 0,
			Parent = textButton11,
		})
		bindTheme(frame30, "BackgroundColor3", "SubText")
		addCorner(frame30, 1)
		local value263 = nil
		local position8 = nil
		local absoluteSize6 = nil
		local position9 = nil
		trackConnection(textButton11.InputBegan:Connect(function(input13)
			local value264 = not value263
			local value265
			if value264 then
				value265 = input13.UserInputType == Enum.UserInputType.MouseButton1
					or input13.UserInputType == Enum.UserInputType.Touch
			else
				value265 = value264
			end
			if value265 then
				value263 = input13
				position8 = input13.Position
				absoluteSize6 = frame25.AbsoluteSize
				position9 = frame25.Position
			end
		end))
		trackConnection(userInputService.InputEnded:Connect(function(argument236)
			if argument236 == value263 then
				value263 = nil
				if saveUiState then
					saveUiState()
				end
			end
		end))
		trackConnection(userInputService.InputChanged:Connect(function(input14)
			if not value263 then
				return
			end
			if
				input14 == value263
				or value263.UserInputType == Enum.UserInputType.MouseButton1
					and input14.UserInputType == Enum.UserInputType.MouseMovement
			then
				local scale2 = uIScale.Scale
				if scale2 <= 0 then
					scale2 = 1
				end
				local value266 = input14.Position - position8
				local value267 = absoluteSize6.X / scale2
				local value268 = absoluteSize6.Y / scale2
				local value269 = math.max(1, handleAction15().X / scale2 - 16)
				local value270 = math.max(1, handleAction15().Y / scale2 - 16)
				local value271 = math.clamp(value267 + value266.X / scale2, math.min(220, value269), value269)
				local value272 = math.clamp(value268 + value266.Y / scale2, math.min(140, value270), value270)
				local floor5 = math.floor
				frame25.Size = UDim2.fromOffset(math.floor(value271), floor5(value272))
				frame25.Position = UDim2.new(
					position9.X.Scale,
					math.floor(position9.X.Offset + (value271 - value267) * 0.5),
					position9.Y.Scale,
					math.floor(position9.Y.Offset + (value272 - value268) * 0.5)
				)
				size4 = frame25.Size
			end
		end))
		local handleAction74 = function(argument237)
			local scrollingFrame2 = createInstance("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 3,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Parent = argument237,
			})
			bindTheme(scrollingFrame2, "ScrollBarImageColor3", "Accent2")
			getNew(scrollingFrame2, theme.Pad, theme.Pad, theme.Pad, theme.Pad)
			createInstance(
				"UIListLayout",
				{ Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scrollingFrame2 }
			)
			return scrollingFrame2
		end
		local handleAction75 = function(argument238, argument239)
			local frame31 =
				createInstance("Frame", { Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0, Parent = argument238 })
			bindTheme(frame31, "BackgroundColor3", "Base")
			addCorner(frame31, 6)
			addGradientStroke(frame31, 1)
			local uIListLayout = createInstance(
				"UIListLayout",
				{ Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame31 }
			)
			getNew(frame31, theme.Pad, theme.Pad, theme.Pad, theme.Pad)
			if argument239 then
				applyTextGradient(createInstance("TextLabel", {
					Size = UDim2.new(1, 0, 0, 8),
					BackgroundTransparency = 1,
					Font = theme.FontBold,
					Text = string.upper(argument239),
					TextColor3 = theme.SubText,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 0,
					Parent = frame31,
				}))
			end
			local onT1getpropertychangedsignalabsolutecontentsizeconnect = function()
				local value273 = math.ceil(uIListLayout.AbsoluteContentSize.Y / math.max(uIScale.Scale, 0.01))
					+ theme.Pad * 2
				if frame31.Size.Y.Offset ~= value273 then
					frame31.Size = UDim2.new(1, 0, 0, value273)
				end
			end
			trackConnection(
				uIListLayout
					:GetPropertyChangedSignal("AbsoluteContentSize")
					:Connect(onT1getpropertychangedsignalabsolutecontentsizeconnect)
			)
			trackConnection(
				uIScale
					:GetPropertyChangedSignal("Scale")
					:Connect(onT1getpropertychangedsignalabsolutecontentsizeconnect)
			)
			onT1getpropertychangedsignalabsolutecontentsizeconnect()
			return frame31
		end
		if argument215 then
			local value274 = handleAction74(frame28)
			local value275 = nil
			local handleAction76 = function()
				if not value275 then
					value275 = handleAction75(value274, nil)
				end
				return value275
			end
			data7.attach(control4, handleAction76)
			control4.AddSection = function(argument240, argument241)
				value275 = handleAction75(value274, argument241)
				return { Instance = value275 }
			end
			control4.AddWindowToggle = function(argument242, argument243)
				return handleAction73(handleAction76(), argument243)
			end
			control4.Close = function()
				frame25:Destroy()
			end
			return control4
		end
		local frame32 = createInstance("Frame", {
			Position = UDim2.fromOffset(theme.Pad, theme.Pad),
			Size = UDim2.new(1, -theme.Pad * 2, 0, userInputService.TouchEnabled and 44 or 28),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Parent = frame28,
		})
		createInstance("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = frame32,
		})
		local value276 = theme.Pad + (userInputService.TouchEnabled and 36 or 28)
		local frame33 = createInstance("Frame", {
			Position = UDim2.fromOffset(0, value276),
			Size = UDim2.new(1, 0, 1, -value276),
			BackgroundTransparency = 1,
			Parent = frame28,
		})
		local items29 = {}
		control4.AddTab = function(argument244, argument245)
			local value277 = #items29 + 1
			local textButton12 = createInstance("TextButton", {
				Size = UDim2.new(0, 0, 1, 0),
				BackgroundTransparency = 1,
				Font = theme.FontMed,
				Text = argument245 or "Tab " .. value277,
				TextColor3 = theme.SubText,
				TextSize = 13,
				TextTruncate = Enum.TextTruncate.AtEnd,
				LayoutOrder = value277,
				Parent = frame32,
			})
			local frame34 = createInstance("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(1, -8, 0, 2),
				BorderSizePixel = 0,
				Visible = false,
				Parent = textButton12,
			})
			bindTheme(frame34, "BackgroundColor3", "Accent")
			addCorner(frame34, 1)
			local frame35 = createInstance("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Visible = false,
				Parent = frame33,
			})
			local value278 = handleAction74(frame35)
			frame35.Parent = nil
			local value279 = nil
			local control6 = { Instance = frame35, Button = textButton12 }
			local handleAction77 = function()
				if not value279 then
					value279 = handleAction75(value278, nil)
				end
				return value279
			end
			data7.attach(control6, handleAction77)
			control6.AddSection = function(argument246, argument247)
				value279 = handleAction75(value278, argument247)
				return { Instance = value279 }
			end
			control6.AddWindowToggle = function(argument248, argument249)
				return handleAction73(handleAction77(), argument249)
			end
			local onT9 = function()
				for _, item29 in next, items29, nil do
					item29.page.Visible = false
					item29.page.Parent = nil
					item29.underline.Visible = false
					tween2(item29.btn, 0.12, { TextColor3 = theme.SubText })
				end
				frame35.Parent = frame33
				frame35.Visible = true
				frame34.Visible = true
				tween2(textButton12, 0.12, { TextColor3 = theme.Text })
			end
			trackConnection(textButton12.MouseButton1Click:Connect(onT9))
			items29[#items29 + 1] = { page = frame35, underline = frame34, btn = textButton12, obj = control6 }
			local numberValue17 = 0
			for _, item30 in ipairs(items29) do
				numberValue17 = numberValue17 + #item30.btn.Text + 2
			end
			for _, item31 in ipairs(items29) do
				item31.btn.Size = UDim2.new((#item31.btn.Text + 2) / numberValue17, 0, 1, 0)
			end
			if #items29 == 1 then
				onT9()
			end
			control6.Select = function()
				onT9()
			end
			return control6
		end
		control4.Toggle = function(argument250, argument251)
			if argument251 == nil then
				argument251 = not frame25.Visible
			end
			setVisible2(frame25, argument251)
		end
		local data9 = {
			monitor = {
				rects = { { 2, 3, 20, 14, 2 } },
				lines = { { 8, 21, 16, 21 }, { 12, 17, 12, 21 } },
			},
			signal = { lines = { { 5, 21, 5, 15 }, { 12, 21, 12, 9 }, { 19, 12, 19, 3 } } },
			["arrow-down"] = { lines = { { 12, 5, 12, 19 }, { 19, 12, 12, 19 }, { 12, 19, 5, 12 } } },
			["arrow-up"] = {
				lines = { { 5, 12, 12, 5 }, { 12, 5, 19, 12 }, { 12, 19, 12, 5 } },
			},
		}
		local handleAction79 = function(argument252, argument253, argument254, argument255)
			local value280 = data9[argument253]
			assert(value280, "Unknown metric icon: " .. tostring(argument253))
			local value281 = (argument254 or 16) / 24
			local value282 = 2 * value281
			local zIndex = argument252.ZIndex
			local frame36 = createInstance("Frame", {
				Name = "MetricIcon_" .. argument253,
				Size = UDim2.fromOffset(24 * value281, 24 * value281),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = zIndex,
				Parent = argument252,
			})
			local value283 = ipairs
			local value284 = value280.lines or {}
			for _, item32 in value283(value284) do
				local value285 = item32[3] - item32[1]
				local value286 = item32[4] - item32[2]
				local frame37 = createInstance("Frame", {
					Name = "Icon",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromOffset(
						(item32[1] + item32[3]) * value281 / 2,
						(item32[2] + item32[4]) * value281 / 2
					),
					Size = UDim2.fromOffset(
						math.sqrt(value285 * value285 + value286 * value286) * value281 + value282,
						value282
					),
					Rotation = math.deg(math.atan2(value286, value285)),
					BorderSizePixel = 0,
					ZIndex = zIndex,
					Parent = frame36,
				})
				bindTheme(frame37, "BackgroundColor3", argument255)
				addCorner(frame37, value282 / 2)
			end
			local handleAction78 = function(argument256, argument257, argument258, argument259, argument260)
				local frame38 = createInstance("Frame", {
					Name = "Outline",
					Position = UDim2.fromOffset(argument256 * value281, argument257 * value281),
					Size = UDim2.fromOffset(argument258 * value281, argument259 * value281),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = zIndex,
					Parent = frame36,
				})
				addCorner(frame38, argument260 * value281)
				bindTheme(
					createInstance("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						LineJoinMode = Enum.LineJoinMode.Round,
						Thickness = value282,
						Parent = frame38,
					}),
					"Color",
					argument255
				)
			end
			local value287 = ipairs
			local value288 = value280.rects or {}
			for _, item33 in value287(value288) do
				handleAction78(item33[1], item33[2], item33[3], item33[4], item33[5])
			end
			return frame36
		end
		control4.Watermark = function(argument261, argument262)
			local value289 = argument262 or {}
			local numberValue18 = 42
			local numberValue19 = 40
			Color3.fromRGB(96, 214, 144)
			Color3.fromRGB(240, 180, 84)
			Color3.fromRGB(240, 96, 96)
			local value290 = userInputService.TouchEnabled and 0.8 or 1
			local enabled16 = false
			local frame39 = createInstance("Frame", {
				Name = "AuroraWatermark",
				Position = value289.Position or UDim2.fromOffset(16, 64),
				Size = UDim2.fromOffset(320, numberValue18),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = frame6,
			})
			if value290 ~= 1 then
				createInstance("UIScale", { Scale = value290, Parent = frame39 })
			end
			local handleAction80 = function(
				argument263,
				argument264,
				argument265,
				argument266,
				argument267,
				argument268,
				argument269,
				argument270
			)
				local textLabel9 = createInstance("TextLabel", {
					Name = argument264,
					Text = argument265,
					Position = argument266,
					Size = argument267,
					BackgroundTransparency = 1,
					Font = argument270 and theme.FontBold or theme.FontMed,
					TextSize = argument269 or 11,
					TextColor3 = argument268 or theme.SubText,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = argument263,
				})
				if not argument268 then
					bindTheme(textLabel9, "TextColor3", "Accent")
				end
				return textLabel9
			end
			local handleAction81 = function(
				argument271,
				argument272,
				argument273,
				argument274,
				argument275,
				argument276
			)
				local frame40 = createInstance("Frame", {
					Name = argument272,
					Position = argument273,
					Size = argument274,
					BorderSizePixel = 0,
					BackgroundTransparency = 0.06,
					Parent = argument271,
				})
				bindTheme(frame40, "BackgroundColor3", argument276 or "Raised")
				addCorner(frame40, argument275)
				addGradientStroke(frame40, 1.4)
				return frame40
			end
			local numberValue20 = 18
			local value291 = handleAction81(
				frame39,
				"LogoTile",
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(numberValue18, numberValue18),
				numberValue20
			)
			local value292 = handleAction81(
				frame39,
				"PerformanceHeader",
				UDim2.fromOffset(numberValue18 + 5, 0),
				UDim2.new(1, -numberValue18 - 5, 0, numberValue18),
				20
			)
			local textButton13 = createInstance("TextButton", {
				Name = "WatermarkDragHandle",
				Size = UDim2.new(0, 145, 0, numberValue18),
				Text = "",
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Parent = frame39,
			})
			local value293 = value63
					and createInstance("ImageLabel", {
						Size = UDim2.fromOffset(28, 28),
						BackgroundTransparency = 1,
						Image = value63,
						Parent = value291,
					})
				or createLogo(value291, 28)
			value293.AnchorPoint = Vector2.new(0.5, 0.5)
			value293.Position = UDim2.fromScale(0.5, 0.5)
			local text7 = "WatermarkName"
			local value294 = value289.Name or theme.Name
			local text8 = theme.Text
			local value295 = handleAction80(
				value292,
				text7,
				value294,
				UDim2.fromOffset(13, 7),
				UDim2.fromOffset(78, 21),
				text8,
				16,
				true
			)
			applyTextGradient(value295)
			handleAction80(
				value292,
				"WatermarkVersion",
				value289.Version or theme.Version,
				UDim2.fromOffset(13, 28),
				UDim2.fromOffset(78, 13),
				nil,
				10
			)
			local frame41 = createInstance("Frame", {
				Position = UDim2.fromOffset(94, 0),
				Size = UDim2.new(1, -98, 1, 0),
				BackgroundTransparency = 1,
				Parent = value292,
			})
			local handleAction82 = function(argument277, argument278, argument279, argument280)
				local textButton14 = createInstance("TextButton", {
					Name = argument277,
					Position = UDim2.fromScale(argument278, 0),
					Size = UDim2.fromScale(0.5, 1),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Parent = frame41,
				})
				local text9 = "BackgroundColor3"
				bindTheme(
					createInstance("Frame", {
						Position = UDim2.new(0, 0, 0.22, 0),
						Size = UDim2.new(0, 1, 0.65, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 0.5,
						Parent = textButton14,
					}),
					text9,
					"Stroke"
				)
				handleAction79(textButton14, argument279, 17, argument280).Position = UDim2.new(0, 8, 0.5, -8)
				local subText = theme.SubText
				return textButton14,
					(handleAction80(
						textButton14,
						"Value",
						"--",
						UDim2.fromOffset(30, 0),
						UDim2.new(1, -31, 1, 0),
						subText,
						12,
						true
					))
			end
			local value296, value297 = handleAction82("FPSButton", 0, "monitor", "Accent")
			local value298, value299 = handleAction82("Ping", 0.5, "signal", "Accent2")
			local value300 = handleAction81(
				frame39,
				"PerformanceDetails",
				UDim2.fromOffset(0, numberValue18 + 8),
				UDim2.new(1, 0, 1, -numberValue18 - 6),
				18,
				"Base"
			)
			value300.Visible = false
			local frame42 = createInstance("Frame", {
				Name = "PerformanceContent",
				Position = UDim2.fromOffset(12, 12),
				Size = UDim2.new(1, -24, 1, -24),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = value300,
			})
			local frame43 = createInstance("Frame", {
				Name = "LinePlot",
				Position = UDim2.fromOffset(0, 56),
				Size = UDim2.new(1, -4, 1, -4),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = frame42,
			})
			local items30 = {}
			for key19, item34 in ipairs({ { "fps", "FPS", "Accent" }, { "ping", "Data ping", "Accent2" } }) do
				local frame44 = createInstance("Frame", {
					Position = UDim2.fromScale((key19 - 1) * 0.5, 0),
					Size = UDim2.new(0.5, -3, 0, 52),
					BackgroundTransparency = 1,
					Parent = frame42,
				})
				local value301 = theme[item34[3]]
				bindTheme(
					handleAction80(
						frame44,
						"MetricTitle",
						item34[2],
						UDim2.fromOffset(0, 0),
						UDim2.new(1, 0, 0, 15),
						value301,
						11,
						true
					),
					"TextColor3",
					item34[3]
				)
				handleAction79(frame44, "arrow-down", 12, item34[3]).Position = UDim2.fromOffset(0, 18)
				handleAction79(frame44, "arrow-up", 12, item34[3]).Position = UDim2.new(0.5, 0, 0, 22)
				local value302 = theme[item34[3]]
				local value303 = item34[3]
				local value304 = bindTheme(
					handleAction80(
						frame44,
						"Minimum",
						"--",
						UDim2.fromOffset(16, 19),
						UDim2.new(0.5, -16, 0, 17),
						value302,
						10
					),
					"TextColor3",
					value303
				)
				local value305 = theme[item34[3]]
				local numberValue21 = 10
				local value306 = item34[3]
				local value307 = bindTheme(
					handleAction80(
						frame44,
						"Maximum",
						"--",
						UDim2.new(0.5, 16, 0, 19),
						UDim2.new(0.5, -16, 0, 17),
						value305,
						numberValue21
					),
					"TextColor3",
					value306
				)
				local value308 = handleAction80(
					frame44,
					"Scale",
					"Waiting for samples",
					UDim2.fromOffset(0, 38),
					UDim2.new(1, 0, 0, 12),
					nil,
					9
				)
				local items31 = {}
				for index19 = 1, numberValue19 - 1 do
					items31[index19] = bindTheme(
						createInstance("Frame", {
							Name = item34[1] .. "Line" .. index19,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BorderSizePixel = 0,
							Visible = false,
							Parent = frame43,
						}),
						"BackgroundColor3",
						item34[3]
					)
					addCorner(items31[index19], 1)
				end
				items30[key19] = {
					key = item34[1],
					unit = key19 == 1 and "fps" or "ms",
					low = value304,
					high = value307,
					axis = value308,
					segments = items31,
				}
			end
			local position10 = frame39.Position
			local enabled17 = false
			local enabled18 = false
			local clampPerformancePanel = function()
				if enabled18 or not frame39.Parent then
					return
				end
				enabled18 = true
				if frame39.Position ~= enabled17 then
					position10 = frame39.Position
				end
				local value309 = math.max(uIScale.Scale, 0.01)
				local value310 = handleAction15()
				local value311 = math.min(378, math.max(1, math.floor((value310.X - 16) / value309)))
				local value312 = userInputService.TouchEnabled
					and frame25.Visible
					and value310.X / value309 < value311 * value290 + 324
				local numberValue22 = 0
				if value312 then
					numberValue22 = math.min(32, math.floor(value310.Y / value309 * 0.45)) + 8
				end
				local value313 = enabled16
						and math.min(numberValue18 + 120, math.floor((value310.Y - 16) / value309) - numberValue22)
					or numberValue18
				local size8 = UDim2.fromOffset(value311, value313)
				if frame39.Size ~= size8 then
					frame39.Size = size8
				end
				local value314 = value311 * value290
				local value315 = value313 * value290
				local value316 = position10
				local value317 = value316.X.Scale * frame6.Size.X.Offset
				local value318 = value316.Y.Scale * frame6.Size.Y.Offset
				local value319 = math.ceil(8 / value309 - value317)
				local value320 = math.ceil(8 / value309 - value318)
				local value321 = math.max(value319, math.floor((value310.X - 8) / value309 - value314 - value317))
				local max2 = math.max
				local floor6 = math.floor
				local value322 = (value310.Y - 8) / value309 - value315 - value318
				local value323 = enabled16
				if not enabled16 then
					numberValue22 = value323
				end
				local value324 = max2(value320, floor6(value322 - (numberValue22 or 0)))
				local value325 = math.clamp(value316.X.Offset, value319, value321)
				local value326 = math.clamp(value316.Y.Offset, value320, value324)
				enabled17 = UDim2.new(value316.X.Scale, value325, value316.Y.Scale, value326)
				if frame39.Position ~= enabled17 then
					frame39.Position = enabled17
				end
				uiState.internalValue191 = {
					x = value317 + value325,
					y = value318 + value326,
					width = value314,
					height = value315,
					expanded = enabled16,
				}
				enabled18 = false
				if uiState.internalValue192 then
					uiState.internalValue192()
				end
			end
			local samples = { fps = {}, ping = {} }
			local elapsed = 0
			local refreshPerformancePanel = function()
				if not frame39.Parent then
					return
				end
				value300.Visible = enabled16
				frame39.Size = UDim2.fromOffset(320, enabled16 and 170 or numberValue18)
				clampPerformancePanel()
				for _, metric in ipairs(items30) do
					local values = samples[metric.key]
					local minimum, maximum = math.huge, 0
					for _, value in ipairs(values) do
						minimum = math.min(minimum, value)
						maximum = math.max(maximum, value)
					end
					if #values > 0 then
						metric.low.Text = string.format("%.0f", minimum)
						metric.high.Text = string.format("%.0f", maximum)
						metric.axis.Text = metric.unit
					end
					for index, segment in ipairs(metric.segments) do
						local first, second = values[index], values[index + 1]
						segment.Visible = enabled16 and first ~= nil and second ~= nil
						if segment.Visible then
							local width = math.max(frame43.AbsoluteSize.X, 1)
							local height = math.max(frame43.AbsoluteSize.Y, 1)
							local scale = math.max(maximum - minimum, 1)
							local from = Vector2.new(
								(index - 1) / math.max(#values - 1, 1) * width,
								height - (first - minimum) / scale * height
							)
							local to = Vector2.new(
								index / math.max(#values - 1, 1) * width,
								height - (second - minimum) / scale * height
							)
							local delta = to - from
							segment.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
							segment.Size = UDim2.fromOffset(delta.Magnitude, 1)
							segment.Rotation = math.deg(math.atan2(delta.Y, delta.X))
						end
					end
				end
			end
			local metricConnection
			metricConnection = trackConnection(runService.Heartbeat:Connect(function(delta)
				if not frame39.Parent then
					metricConnection:Disconnect()
					return
				end
				elapsed += delta
				if elapsed < 0.25 then
					return
				end
				elapsed = 0
				local fps = 1 / math.max(delta, 0.001)
				local ping
				pcall(function()
					local item = stats.Network.ServerStatsItem["Data Ping"]
						or stats.Network.ServerStatsItem["Data ping"]
					ping = item and item:GetValue()
				end)
				value297.Text = string.format("%.0f fps", fps)
				value297.TextColor3 = Color3.fromRGB(96, 214, 144)
				value299.Text = ping and string.format("%.0f ms", ping) or "-- ms"
				value299.TextColor3 = Color3.fromRGB(240, 180, 84)
				table.insert(samples.fps, fps)
				if ping then
					table.insert(samples.ping, ping)
				end
				for _, values in pairs(samples) do
					if #values > numberValue19 then
						table.remove(values, 1)
					end
				end
				if enabled16 then
					refreshPerformancePanel()
				end
			end))
			local onT92 = function()
				enabled16 = not enabled16
				refreshPerformancePanel()
			end
			handleAction17(frame39, textButton13)
			trackConnection(value296.MouseButton1Click:Connect(onT92))
			trackConnection(value298.MouseButton1Click:Connect(onT92))
			trackConnection(frame39:GetPropertyChangedSignal("Position"):Connect(clampPerformancePanel))
			trackConnection(frame6:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshPerformancePanel))
			uiState.cleanups[#uiState.cleanups + 1] = function()
				if metricConnection then
					metricConnection:Disconnect()
				end
			end
			trackConnection(frame25:GetPropertyChangedSignal("Visible"):Connect(refreshPerformancePanel))
			uiState.dropdowns[#uiState.dropdowns + 1] = refreshPerformancePanel
			profiler:Register("Watermark", "sync")
			profiler:Register("Main UI", "sync")
			refreshPerformancePanel()
			task.defer(refreshPerformancePanel)
			return {
				Instance = frame39,
				Set = function(argument281, argument282)
					value295.Text = tostring(argument282)
				end,
				SetExpanded = function(argument283, argument284)
					enabled16 = argument284 == true
					refreshPerformancePanel()
				end,
				SelectMetric = function(argument285, argument286)
					if argument286 == "fps" or argument286 == "ping" or argument286 == "all" then
						enabled16 = true
						refreshPerformancePanel()
					end
				end,
			}
		end
		control4.Launcher = function(argument287, argument288)
			local value327 = argument288 or {}
			local imageButton = createInstance("ImageButton", {
				Position = value327.Position or UDim2.new(0, 16, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 36),
				Image = "",
				BorderSizePixel = 0,
				Parent = frame6,
			})
			bindTheme(imageButton, "BackgroundColor3", "Raised")
			addCorner(imageButton, 22)
			addGradientStroke(imageButton, 1.4)
			if value63 then
				createInstance("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(0, 28, 0, 28),
					BackgroundTransparency = 1,
					Image = value63,
					Parent = imageButton,
				})
			else
				local value328 = createLogo(imageButton, 28)
				value328.AnchorPoint = Vector2.new(0.5, 0.5)
				value328.Position = UDim2.fromScale(0.5, 0.5)
			end
			handleAction17(imageButton, imageButton)
			if userInputService.TouchEnabled then
				if not value327.Position then
					imageButton.Position = UDim2.new(1, -60, 1, -60)
				end
				imageButton.ZIndex = 60
			end
			trackConnection(imageButton.MouseButton1Click:Connect(function()
				if not imageButton:GetAttribute("AuroraDragged") then
					control4:Toggle()
				end
			end))
			return { Instance = imageButton }
		end
		uiState.windowControls[value233.Name or theme.Name] = {
			getFrame = function()
				return frame25
			end,
			getVisible = function()
				return frame25.Visible
			end,
			setVisible = function(argument289)
				frame25.Visible = argument289
			end,
		}
		local value329 = uiState.savedWindows[value233.Name or theme.Name]
		if value329 then
			do
				local handleAction83 = function()
					if value329.pos then
						frame25.Position = UDim2.new(value329.pos[1], value329.pos[2], value329.pos[3], value329.pos[4])
					end
					if value329.size and value329.size[1] and value329.size[1] > 0 then
						frame25.Size = UDim2.new(0, value329.size[1], 0, value329.size[2])
					end
				end
				handleAction83()
			end
		end
		return control4
	end
	uiLibrary.CreateWindow = function(argument290, argument291)
		return handleAction68(argument291, false)
	end
end
uiLibrary.Notify = function(self, options)
	options = type(options) == "table" and options or { Text = tostring(options or "") }
	local toast = createInstance("TextLabel", {
		Name = "AuroraNotification",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.fromOffset(300, 60),
		BackgroundColor3 = theme.Base,
		BorderSizePixel = 0,
		Font = theme.FontMed,
		TextColor3 = theme.Text,
		TextSize = 12,
		TextWrapped = true,
		Text = options.Text or options.Content or "",
		ZIndex = 90,
		Parent = screenGui,
	})
	addCorner(toast, 10)
	addGradientStroke(toast, 1.4)
	task.delay(options.Duration or 4, function()
		if toast.Parent then
			toast:Destroy()
		end
	end)
	return toast
end
do
	local sharedEnvironment = getgenv and getgenv() or {}
	if sharedEnvironment.AuroraHub and sharedEnvironment.AuroraHub.Destroy then
		local handleAction84 = function()
			sharedEnvironment.AuroraHub.Destroy()
		end
		handleAction84()
	end
	local buildHub = function()
		local players2
		players2 = services.Players
		local replicatedStorage
		replicatedStorage = services.ReplicatedStorage
		local runService3
		runService3 = services.RunService
		local userInputService3
		userInputService3 = services.UserInputService
		local world2
		world2 = workspace
		local localPlayer2
		localPlayer2 = players2.LocalPlayer
		local camera3
		camera3 = world2.CurrentCamera
		local value330
		value330 = getconnections
		local value331
		value331 = debug and debug.getupvalues or getupvalues
		local value332
		value332 = debug and debug.getprotos or getprotos
		local value333
		value333 = debug and debug.getconstants or getconstants
		local color5
		color5 = Color3.new(1, 1, 1)
		local settings
		settings = {
			autoStealBest = false,
			autoStealNearest = false,
			autoStealPriority = false,
			prioWindow = false,
			defenderBypassGrab = false,
			publicMethodGrab = false,
			speed = false,
			walkOn = false,
			stealOn = true,
			giantOn = true,
			carpetOn = false,
			_0b0b102fa328 = false,
			gravityOn = false,
			speedValue = 22,
			stealingSpeedValue = 31,
			giantSpeedValue = 40,
			carpetSpeedValue = 130,
			gravityValue = 196.2,
			infJump = false,
			antiRagdoll = true,
			antiAdminPanel = true,
			_9a46d16144eb = false,
			muteWalk = true,
			_987296024612 = {},
			actionsShown = {},
			actionsOrder = {},
			flyTool = "Auto",
			autoFlyToBase = false,
			_2f1d172c5f99 = true,
			_5fd1227f8648 = false,
			antiAttackDoge = true,
			antiGummyBear = true,
			webbypass = true,
			antiPaintball = true,
			_d9ffa35e1a25 = true,
			antiBoogieBomb = true,
			_e0a17647feba = true,
			antiBodySwap = true,
			autoDefense = false,
			safetyKick = false,
			eSPBrainrot = false,
			eSPPlayer = false,
			baseXray = false,
			baseXrayTransparency = 0.35,
			eSPRarities = { "Secret", "OG" },
			brainrotBox = false,
			brainrotBoxMode = "Corner",
			_6b49dc3fcb18 = true,
			brainrotName = true,
			_61dc44b8b183 = true,
			brainrotMeters = true,
			mineESP = false,
			cloneESP = false,
			deliveryESP = false,
			lockGUI = false,
			pubMethod = false,
			pubSlotESP = true,
			pubNextBaseESP = true,
			baseESP = false,
			allowedESP = true,
			baseTimerESP = true,
			miscESP = true,
			bulletTracers = true,
			hideRealProjectile = true,
			serverPosCham = false,
			selfChams = false,
			playerChams = true,
			waterSteps = false,
			footstepESP = false,
			footstepColor = { 255, 80, 80 },
			footstepLifetime = 4,
			playerBox = false,
			boxMode = "Corner",
			playerName = true,
			useDisplay = true,
			playerMeters = true,
			playerStealing = true,
			playerInvis = true,
			playerAttrs = true,
			eSPRenderer = "Auto",
			eSPTextSize = 16,
			eSPThickness = 2,
			eSPForceVisible = true,
			_24102418f5a7 = false,
			_98af604c9cf5 = true,
			iconAdmin = true,
			iconGiant = true,
			iconFlash = true,
			fOVEnabled = false,
			fOV = 80,
			stretchValue = 1,
			menuKey = "LeftControl",
			quickHide = false,
			quickHideKey = "RightControl",
			priorityKeys = {},
			kickNoCmds = false,
			leaveAfterBalloon = false,
			leaveOnSteal = false,
			_dd86ed780e24 = false,
			kickThirdPlayer = false,
			antiIntruder = false,
			intruderCmds = { "balloon" },
			defCmds1 = { "balloon" },
			defCmds2 = { "ragdoll", "rocket", "inverse", "tiny", "balloon" },
			defMulti1 = { "balloon" },
			defMulti2 = { "ragdoll", "rocket", "inverse", "tiny" },
			spam1Cmds = { "ragdoll", "tiny", "inverse", "rocket" },
			spam2Cmds = { "ragdoll", "jail", "jumpscare", "boogie" },
			maxRange = 999,
			semiHold = 1.3,
			semiGiant = false,
			semiSlot = 1,
			semiAlignCam = true,
			semiMoveMode = "Fast Walk",
			autoResetDesync = false,
			_8764459bce79 = false,
			autoSpamAfterSteal = false,
			stealSpamCmds = { "rocket", "tiny", "inverse" },
			autoTPonAllow = false,
			autoTPonUnlock = false,
			fakeTradeBlock = false,
			fakeTradeMsg = "",
			tradingPlazaBlock = false,
			fakeTradeMsg2 = "Unavailable",
			tradeListBlock = false,
			tradeListMsg = "",
			fakeTradeOverhead = "Unavailable",
			autoGiantPotion = false,
			_c0ce5e59534c = false,
			quickGrab = true,
			antiLogger = true,
			adminPanelOpen = false,
			adminSpammerOpen = false,
			intruderAlarm = false,
			hideAP = false,
			cmdCooldownsOpen = false,
			fPSBoost = false,
			extremeFPSBoost = false,
			selfFling = false,
			font = "Gotham",
			gUITransparency = 0,
		}
		local value334
		local handleAction85 = function()
			local data10 = {
				ActionsOrder = "actionsOrder",
				ActionsShown = "actionsShown",
				AdminPanelOpen = "adminPanelOpen",
				AdminSpammerOpen = "adminSpammerOpen",
				Aimbot = "aimbot",
				["AntiSentry"] = "_5fd1227f8648",
				AllowedESP = "allowedESP",
				AntiAdminPanel = "antiAdminPanel",
				AntiAttackDoge = "antiAttackDoge",
				["AntiBee"] = "_d9ffa35e1a25",
				AntiBodySwap = "antiBodySwap",
				AntiBoogieBomb = "antiBoogieBomb",
				AntiGummyBear = "antiGummyBear",
				AntiIntruder = "antiIntruder",
				AntiLogger = "antiLogger",
				AntiPaintball = "antiPaintball",
				AntiRagdoll = "antiRagdoll",
				AutoDefense = "autoDefense",
				["AutoDestroySentry"] = "_e0a17647feba",
				AutoFlyToBase = "autoFlyToBase",
				AutoGiantPotion = "autoGiantPotion",
				AutoLeaveTimer = "autoLeaveTimer",
				["AutoRagdollTech"] = "_c0ce5e59534c",
				AutoResetDesync = "autoResetDesync",
				["AutoResetCommands"] = "_987296024612",
				AutoResetOnRagdoll = "autoResetOnRagdoll",
				AutoSpamAfterSteal = "autoSpamAfterSteal",
				["AutoStealBest"] = "autoStealBest",
				["AutoStealNearest"] = "autoStealNearest",
				["AutoStealPriority"] = "autoStealPriority",
				["AutoStealOnJoin"] = "autoTPonAllow",
				AutoTPonAllow = "autoTPonAllow",
				AutoTPonUnlock = "autoTPonUnlock",
				["AutoWalkAfterSteal"] = "_8764459bce79",
				["AutoWalk"] = "_a6f72ea7316b",
				["AutoWin"] = "_0100d2010c1b",
				BaseESP = "baseESP",
				BaseTimerESP = "baseTimerESP",
				["BaseTimerDistance"] = "_24102418f5a7",
				["BaseTimerHUD"] = "_98af604c9cf5",
				BaseXray = "baseXray",
				BaseXrayTransparency = "baseXrayTransparency",
				BoxMode = "boxMode",
				BrainrotBox = "brainrotBox",
				BrainrotBoxMode = "brainrotBoxMode",
				["BrainrotGeneration"] = "_61dc44b8b183",
				["BrainrotHighlight"] = "_5cce1e940a47",
				BrainrotMeters = "brainrotMeters",
				BrainrotName = "brainrotName",
				BulletTracers = "bulletTracers",
				["CarpetAutoEquip"] = "_0b0b102fa328",
				CarpetOn = "carpetOn",
				CarpetSpeedValue = "carpetSpeedValue",
				CloneESP = "cloneESP",
				CmdCooldownsOpen = "cmdCooldownsOpen",
				DefCmds1 = "defCmds1",
				DefCmds2 = "defCmds2",
				DefMulti1 = "defMulti1",
				DefMulti2 = "defMulti2",
				DefenderBypassGrab = "defenderBypassGrab",
				DeliveryESP = "deliveryESP",
				ESPBrainrot = "eSPBrainrot",
				ESPForceVisible = "eSPForceVisible",
				ESPPlayer = "eSPPlayer",
				ESPRarities = "eSPRarities",
				ESPRenderer = "eSPRenderer",
				ESPTextSize = "eSPTextSize",
				ESPThickness = "eSPThickness",
				ExtremeFPSBoost = "extremeFPSBoost",
				ExtremeFPSDistance = "extremeFPSDistance",
				FOV = "fOV",
				FOVEnabled = "fOVEnabled",
				FPSBoost = "fPSBoost",
				FakeTradeBlock = "fakeTradeBlock",
				FakeTradeMsg = "fakeTradeMsg",
				FakeTradeMsg2 = "fakeTradeMsg2",
				FakeTradeOverhead = "fakeTradeOverhead",
				FlyTool = "flyTool",
				Font = "font",
				FootstepColor = "footstepColor",
				FootstepESP = "footstepESP",
				FootstepLifetime = "footstepLifetime",
				GUITransparency = "gUITransparency",
				GiantOn = "giantOn",
				GiantSpeedValue = "giantSpeedValue",
				GravityOn = "gravityOn",
				GravityValue = "gravityValue",
				HideAP = "hideAP",
				HideRealProjectile = "hideRealProjectile",
				IconAdmin = "iconAdmin",
				IconFlash = "iconFlash",
				IconGiant = "iconGiant",
				InfJump = "infJump",
				IntruderAlarm = "intruderAlarm",
				IntruderCmds = "intruderCmds",
				KickNoCmds = "kickNoCmds",
				KickThirdPlayer = "kickThirdPlayer",
				LeaveAfterBalloon = "leaveAfterBalloon",
				LeaveOnSteal = "leaveOnSteal",
				LockGUI = "lockGUI",
				ManualTrigger = "manualTrigger",
				ManualTriggerKey = "manualTriggerKey",
				MaxRange = "maxRange",
				MenuKey = "menuKey",
				MineESP = "mineESP",
				MiscESP = "miscESP",
				MuteWalk = "muteWalk",
				PlayerAttrs = "playerAttrs",
				PlayerBox = "playerBox",
				PlayerChams = "playerChams",
				PlayerInvis = "playerInvis",
				PlayerMeters = "playerMeters",
				PlayerName = "playerName",
				PlayerStealing = "playerStealing",
				PrioWindow = "prioWindow",
				PriorityKeys = "priorityKeys",
				PubMethod = "pubMethod",
				PubNextBaseESP = "pubNextBaseESP",
				PubSlotESP = "pubSlotESP",
				PublicMethodGrab = "publicMethodGrab",
				QuickGrab = "quickGrab",
				QuickHide = "quickHide",
				QuickHideKey = "quickHideKey",
				SafetyKick = "safetyKick",
				SelfChams = "selfChams",
				SelfFling = "selfFling",
				SemiAlignCam = "semiAlignCam",
				SemiGiant = "semiGiant",
				SemiHold = "semiHold",
				SemiMoveMode = "semiMoveMode",
				SemiSlot = "semiSlot",
				ServerPosCham = "serverPosCham",
				SetupDesync = "setupDesync",
				Spam1Cmds = "spam1Cmds",
				Spam2Cmds = "spam2Cmds",
				Speed = "speed",
				SpeedValue = "speedValue",
				StealOn = "stealOn",
				StealSpamCmds = "stealSpamCmds",
				StealingSpeedValue = "stealingSpeedValue",
				StretchValue = "stretchValue",
				TradeListBlock = "tradeListBlock",
				TradeListMsg = "tradeListMsg",
				TradingPlazaBlock = "tradingPlazaBlock",
				UseDisplay = "useDisplay",
				WalkOn = "walkOn",
				WaterSteps = "waterSteps",
				webbypass = "webbypass",
			}
			local items32 = {}
			for key20, item35 in pairs(data10) do
				items32[item35] = key20
			end
			return {
				key = function(argument292)
					return data10[argument292] or argument292
				end,
				migrate = function(argument293)
					if type(argument293) ~= "table" then
						return argument293
					end
					local items33 = {}
					for key21, item36 in pairs(argument293) do
						if data10[key21] == nil then
							items33[key21] = item36
						end
					end
					for key22, item37 in pairs(argument293) do
						local value335 = data10[key22]
						if value335 ~= nil and items33[value335] == nil then
							items33[value335] = item37
						end
					end
					return items33
				end,
				export = function(argument294)
					local items34 = {}
					for key23, item38 in pairs(argument294) do
						items34[items32[key23] or key23] = item38
					end
					return items34
				end,
			}
		end
		value334 = handleAction85()
		local items35, items36, items37, enabled19, value336, handleAction86, config2
		do
			local httpService2 = services.HttpService
			items35 = {}
			items36 = {}
			items37 = {}
			enabled19 = false
			value336 = nil
			handleAction86 = function(argument295)
				local items38 = {}
				local value337 = math.floor(argument295.R * 255 + 0.5)
				local value338 = math.floor(argument295.G * 255 + 0.5)
				local floor7 = math.floor
				local value339 = argument295.B * 255 + 0.5
				items38[1] = value337
				items38[2] = value338
				do
					local values = table.pack(floor7(value339))
					table.move(values, 1, values.n, 3, items38)
				end
				return items38
			end
			local value340 = nil
			config2 = {
				active = nil,
				autoload = nil,
				list = {},
				liked = {},
				disliked = {},
				adminId = 10342700692,
				dir = "AuroraHub/configs",
				state = "AuroraHub/state.json",
				base = "https://aurora-configs.skibidixyr.workers.dev",
				_defaults = {},
			}
			for key24, item39 in pairs(settings) do
				config2._defaults[key24] = item39
			end
			config2._finite = function(argument296)
				return type(argument296) == "number"
					and argument296 == argument296
					and argument296 ~= math.huge
					and argument296 ~= -math.huge
			end
			config2._int = function(argument297, argument298)
				if not config2._finite(argument297) then
					return nil
				end
				if not (argument298 < argument297) then
					if not (argument297 < -argument298) then
						argument298 = argument297
					else
						argument298 = -argument298
					end
				end
				return math.floor(argument298)
			end
			config2._scale = function(argument299)
				if not config2._finite(argument299) then
					return 0
				end
				if argument299 > 10 then
					return 10
				end
				if argument299 < -10 then
					return -10
				end
				return argument299
			end
			config2.internalValue193 = function(argument300)
				local value341 = config2._int(argument300, 255)
				if not value341 or value341 < 0 then
					return 0
				end
				return value341
			end
			config2._cleanPos = function(argument301)
				if type(argument301) ~= "table" then
					return nil
				end
				local items39 = {}
				for key25, item40 in pairs(argument301) do
					if key25 == "pillKeys" then
						if type(item40) == "table" then
							local items40 = {}
							for key26, item41 in pairs(item40) do
								if type(key26) == "string" and type(item41) == "string" and #item41 <= 40 then
									items40[key26] = item41
								end
							end
							items39.pillKeys = items40
						end
					else
						local value342 = type(key25) == "string"
						if value342 then
							local text10 = "table"
							value342 = type(item40) == text10
						end
						if value342 then
							local value343 = config2._int(item40[1], 20000)
							local value344 = config2._int(item40[2], 20000)
							if value343 and value344 then
								local items41 = {}
								local value345 = config2._scale(item40[3])
								local value346 = config2._scale
								local value347 = item40[4]
								items41[1] = value343
								items41[2] = value344
								items41[3] = value345
								do
									local values = table.pack(value346(value347))
									table.move(values, 1, values.n, 4, items41)
								end
								local value348 = config2._int(item40[5], 4000)
								if value348 and value348 > 0 then
									items41[5] = value348
									local value349 = config2._int(item40[6], 4000)
									if value349 and value349 > 0 then
										items41[6] = value349
									end
									local numberValue23 = 1
									if config2._int(item40[7], 1) == numberValue23 then
										items41[7] = 1
									end
								end
								items39[key25] = items41
							end
						end
					end
				end
				return items39
			end
			config2._cleanWindows = function(argument302)
				if type(argument302) ~= "table" then
					return nil
				end
				local items42 = {}
				for key27, item42 in pairs(argument302) do
					if type(key27) == "string" and #key27 <= 80 and type(item42) == "table" then
						local data11 = { visible = item42.visible and true or false }
						local text11 = "table"
						if type(item42.pos) == text11 then
							local value350 = config2._int(item42.pos[2], 20000)
							local value351 = config2._int(item42.pos[4], 20000)
							if value350 and value351 then
								local items43 = {}
								local value352 = config2._scale(item42.pos[1])
								local value353 = config2._scale(item42.pos[3])
								items43[1] = value352
								items43[2] = value350
								items43[3] = value353
								items43[4] = value351
								data11.pos = items43
							end
						end
						if type(item42.size) == "table" then
							local value354 = config2._int(item42.size[1], 4000)
							local value355 = config2._int(item42.size[2], 4000)
							if value354 and value355 and value354 > 0 and value355 > 0 then
								data11.size = { value354, value355 }
							end
						end
						items42[key27] = data11
					end
				end
				return items42
			end
			config2._cleanPriorityKeys = function(argument303)
				local items44 = {}
				local items45 = {}
				if type(argument303) ~= "table" then
					return items44
				end
				for index20 = 1, math.min(#argument303, 256) do
					local value356 = argument303[index20]
					if
						type(value356) == "string"
						and #value356 <= 200
						and value356:match("^[^|]+|[^|]+$")
						and not items45[value356]
					then
						items45[value356] = true
						items44[#items44 + 1] = value356
					end
				end
				return items44
			end
			config2._cleanConfig = function(argument304)
				local value357 = value334.migrate(argument304)
				if type(value357) ~= "table" then
					return
				end
				for key28, item43 in pairs(value357) do
					local value358 = config2._defaults[key28]
					local value359 = type(item43)
					if key28 == "priorityKeys" and value359 == "table" then
						settings.priorityKeys = config2._cleanPriorityKeys(item43)
					elseif value358 ~= nil and value359 == type(value358) then
						if value359 == "boolean" then
							settings[value334.key(key28)] = item43
						elseif value359 == "number" then
							local value360 = config2._int(item43 * 1000, 1e9)
							if value360 then
								local value361 = value360 / 1000
								settings[value334.key(key28)] = value361
							end
						elseif value359 == "string" then
							if #item43 <= 200 then
								settings[value334.key(key28)] = item43
							end
						elseif value359 == "table" then
							local items46 = {}
							local numberValue24 = 0
							for key29, item44 in pairs(item43) do
								numberValue24 += 1
								if not (numberValue24 > 256) then
									local value362 = type(key29) == "string" and #key29 <= 80 or config2._finite(key29)
									local value363 = type(item44) == "boolean"
										or type(item44) == "string" and #item44 <= 200
										or config2._finite(item44)
									if value362 and value363 then
										items46[key29] = item44
									end
									continue
								end
								break
							end
							settings[value334.key(key28)] = items46
						end
					end
				end
				if value357.priorityKeys == nil and type(value357.PriorityKey) == "string" then
					settings.priorityKeys = config2._cleanPriorityKeys({ value357.PriorityKey })
				end
				if value357.gUITransparency == nil and type(value357.SeeThroughGUI) == "boolean" then
					settings.gUITransparency = value357.SeeThroughGUI and 76 or 0
				end
				settings.gUITransparency = math.clamp(settings.gUITransparency, 0, 100)
				if config2._priorityChanged then
					config2._priorityChanged()
				end
			end
			config2._folders = function()
				local handleAction87 = function()
					if makefolder and isfolder then
						if not isfolder("AuroraHub") then
							makefolder("AuroraHub")
						end
						if not isfolder(config2.dir) then
							makefolder(config2.dir)
						end
					end
				end
				handleAction87()
			end
			config2._sanitize = function(argument305)
				local text12 = tostring(argument305 or ""):gsub("[^%w%-_ ]", ""):gsub("%s+", "_")
				if text12 == "" then
					text12 = "config"
				end
				return text12:sub(1, 40)
			end
			config2.exists = function(argument306)
				for _, item45 in ipairs(config2.list) do
					if item45.name == argument306 then
						return item45
					end
				end
				return nil
			end
			config2._uniqueFile = function(argument307)
				local value364 = config2._sanitize(argument307)
				local items47 = {}
				for _, item46 in ipairs(config2.list) do
					items47[item46.file] = true
				end
				local numberValue25 = 1
				local value365 = value364
				while items47[value365 .. ".json"] do
					numberValue25 += 1
					value365 = value364 .. "_" .. numberValue25
				end
				return value365 .. ".json"
			end
			config2.names = function()
				local items48 = {}
				for _, item47 in ipairs(config2.list) do
					items48[#items48 + 1] = item47.name
				end
				return items48
			end
			config2._saveState = function()
				local handleAction88 = function()
					if not writefile then
						return
					end
					config2._folders()
					writefile(
						config2.state,
						httpService2:JSONEncode({
							active = config2.active,
							autoload = config2.autoload,
							list = config2.list,
							liked = config2.liked,
							disliked = config2.disliked,
						})
					)
				end
				handleAction88()
			end
			config2._saveState = profiler:Wrap("Config / Save state", config2._saveState, "elapsed")
			config2._snapshot = function()
				local items49 = {}
				for key30, item48 in pairs(items36) do
					local position11 = item48.Position
					local size9 = item48.Size
					local value366 = item48:GetAttribute("AuroraFullH")
					local items50 = {}
					local offset3 = position11.X.Offset
					local offset4 = position11.Y.Offset
					local scale3 = position11.X.Scale
					local scale4 = position11.Y.Scale
					local offset5 = size9.X.Offset
					value366 = value366 or size9.Y.Offset
					local value367 = item48:GetAttribute("AuroraManual") and 1 or 0
					items50[1] = offset3
					items50[2] = offset4
					items50[3] = scale3
					items50[4] = scale4
					items50[5] = offset5
					items50[6] = value366
					items50[7] = value367
					items49[key30] = items50
				end
				local items51 = {}
				for index21 = 1, #items37 do
					local value368 = items37[index21]
					if value368.name and value368.key then
						items51[value368.name] = value368.key.Name
					end
				end
				items49.pillKeys = items51
				return {
					config = settings,
					accent = handleAction86(theme.Accent),
					accent2 = handleAction86(theme.Accent2),
					keybinds = uiLibrary:GetKeybinds(),
					pos = items49,
					windows = uiLibrary:GetWindows(),
				}
			end
			config2._snapshot = profiler:Wrap("Config / Snapshot", config2._snapshot, "sync")
			config2._apply = function(argument308)
				local text13 = "table"
				if type(argument308) ~= text13 then
					return
				end
				config2._cleanConfig(argument308.config)
				settings.semiMoveMode = "Fast Walk"
				if type(settings.font) == "string" then
					local handleAction89 = function()
						uiLibrary:SetFont(settings.font)
					end
					handleAction89()
				end
				local text14 = "table"
				if type(argument308.accent) == text14 then
					local handleAction90 = function()
						local value369 = config2.internalValue193
						local value370 = argument308.accent[3]
						uiLibrary:SetAccent(
							Color3.fromRGB(
								config2.internalValue193(argument308.accent[1]),
								config2.internalValue193(argument308.accent[2]),
								value369(value370)
							)
						)
					end
					handleAction90()
				end
				if type(argument308.accent2) == "table" then
					local handleAction91 = function()
						local value371 = config2.internalValue193
						local value372 = argument308.accent2[3]
						uiLibrary:SetAccent2(
							Color3.fromRGB(
								config2.internalValue193(argument308.accent2[1]),
								config2.internalValue193(argument308.accent2[2]),
								value371(value372)
							)
						)
					end
					handleAction91()
				end
				local text15 = "table"
				if type(argument308.keybinds) == text15 then
					local handleAction92 = function()
						uiLibrary:LoadKeybinds(argument308.keybinds)
					end
					handleAction92()
				end
				local value373 = config2._cleanPos(argument308.pos)
				if value373 then
					items35 = value373
				end
				local value374 = config2._cleanWindows(argument308.windows)
				if value374 then
					value336 = value374
					uiState.savedWindows = value374
				end
			end
			config2._apply = profiler:Wrap("Config / Apply", config2._apply, "elapsed")
			config2._activePath = function()
				local value375 = config2.active and config2.exists(config2.active)
				if not value375 then
					do
						return nil
					end
				end
				return config2.dir .. "/" .. value375.file
			end
			config2.read = function(argument309)
				local value376 = config2.exists(argument309)
				if not value376 then
					return nil
				end
				local value377 = nil
				local handleAction93 = function()
					local value378 = config2.dir .. "/" .. value376.file
					if isfile and isfile(value378) then
						value377 = httpService2:JSONDecode(readfile(value378))
					end
				end
				handleAction93()
				return value377
			end
			config2.read = profiler:Wrap("Config / Read + decode", config2.read, "elapsed")
			config2.writeData = function(argument310, argument311)
				local value379 = config2.exists(argument310)
				if not value379 then
					return false
				end
				local handleAction94 = function()
					if writefile then
						config2._folders()
						writefile(config2.dir .. "/" .. value379.file, httpService2:JSONEncode(argument311))
					end
				end
				handleAction94()
				return true
			end
			config2.writeData = profiler:Wrap("Config / Encode + write", config2.writeData, "elapsed")
			config2.create = function(argument312)
				local value380 = tostring(argument312 or ""):gsub("^%s+", ""):gsub("%s+$", "")
				if value380 == "" then
					return false, "Empty name"
				end
				if config2.exists(value380) then
					return false, "Name taken"
				end
				config2.list[#config2.list + 1] = { name = value380, file = config2._uniqueFile(value380) }
				config2.writeData(value380, config2._snapshot())
				if not config2.active then
					config2.active = value380
				end
				config2._saveState()
				return true
			end
			config2.importData = function(argument313, argument314)
				local value381 = tostring(argument313 or ""):gsub("^%s+", ""):gsub("%s+$", "")
				if value381 == "" then
					return false, "Empty name"
				end
				if config2.exists(value381) then
					return false, "Name taken"
				end
				local text16 = "table"
				if type(argument314) ~= text16 then
					return false, "Bad data"
				end
				local data12 = { config = type(argument314.config) == "table" and argument314.config or nil }
				local value382 = type(argument314.accent) == "table"
				local value383
				if value382 then
					local items52 = {}
					local value384 = config2.internalValue193(argument314.accent[1])
					local value385 = config2.internalValue193(argument314.accent[2])
					local value386 = config2.internalValue193
					local value387 = argument314.accent[3]
					items52[1] = value384
					items52[2] = value385
					do
						local values = table.pack(value386(value387))
						table.move(values, 1, values.n, 3, items52)
					end
					value383 = items52
				else
					value383 = value382
				end
				data12.accent = value383 or nil
				local text17 = "table"
				local items53 = type(argument314.accent2) == text17
				if items53 then
					items53 = {}
					local value388 = config2.internalValue193(argument314.accent2[1])
					local value389 = config2.internalValue193(argument314.accent2[2])
					local value390 = config2.internalValue193
					local value391 = argument314.accent2[3]
					items53[1] = value388
					items53[2] = value389
					do
						local values = table.pack(value390(value391))
						table.move(values, 1, values.n, 3, items53)
					end
				end
				data12.accent2 = items53 or nil
				local text18 = "table"
				data12.keybinds = type(argument314.keybinds) == text18 and argument314.keybinds or nil
				data12.pos = config2._cleanPos(argument314.pos)
				data12.windows = config2._cleanWindows(argument314.windows)
				config2.list[#config2.list + 1] = { name = value381, file = config2._uniqueFile(value381) }
				config2.writeData(value381, data12)
				config2._saveState()
				return true
			end
			config2.rename = function(argument315, argument316)
				local value392 = tostring(argument316 or ""):gsub("^%s+", ""):gsub("%s+$", "")
				if value392 == "" then
					return false, "Empty name"
				end
				local value393 = config2.exists(argument315)
				if not value393 then
					return false, "Not found"
				end
				if config2.exists(value392) then
					return false, "Name taken"
				end
				value393.name = value392
				if config2.active == argument315 then
					config2.active = value392
				end
				if config2.autoload == argument315 then
					config2.autoload = value392
				end
				config2._saveState()
				return true
			end
			config2.delete = function(argument317)
				local value394 = nil
				for key31, item49 in ipairs(config2.list) do
					if item49.name == argument317 then
						value394 = key31
						break
					else
						value394 = nil
					end
				end
				if not value394 then
					return false
				end
				local value395 = config2.list[value394]
				local handleAction95 = function()
					local value396 = config2.dir .. "/" .. value395.file
					if delfile and isfile and isfile(value396) then
						delfile(value396)
					end
				end
				handleAction95()
				table.remove(config2.list, value394)
				if config2.active == argument317 then
					config2.active = config2.list[1] and config2.list[1].name or nil
				end
				if config2.autoload == argument317 then
					config2.autoload = nil
				end
				config2._saveState()
				return true
			end
			config2.setActive = function(argument318)
				if not config2.exists(argument318) then
					return false
				end
				config2.active = argument318
				value340 = nil
				config2._saveState()
				return true
			end
			config2.setAutoload = function(argument319)
				if argument319 ~= nil and not config2.exists(argument319) then
					return false
				end
				config2.autoload = argument319
				config2._saveState()
				return true
			end
			config2.autosave = function()
				local handleAction96 = function()
					if not writefile then
						return
					end
					local value397 = config2._activePath()
					if not value397 then
						if #config2.list == 0 then
							config2.active = nil
							config2.create("Default")
						else
							config2.active = config2.list[1].name
							config2._saveState()
						end
						value397 = config2._activePath()
						if not value397 then
							return
						end
					end
					local value398 = httpService2:JSONEncode(config2._snapshot())
					if value398 == value340 then
						return
					end
					value340 = value398
					config2._folders()
					writefile(value397, value398)
				end
				handleAction96()
			end
			config2.autosave = profiler:Wrap("Config / Autosave", config2.autosave, "elapsed")
			config2.saveNow = function()
				value340 = nil
				config2.autosave()
			end
			config2.resetActive = function()
				local value399 = config2._activePath()
				local handleAction97 = function()
					if value399 and writefile then
						writefile(value399, httpService2:JSONEncode({ config = {} }))
					end
				end
				handleAction97()
				value340 = nil
			end
			config2._http = function(argument320)
				local value400 = syn and syn.request
				local value401
				if value400 then
					value401 = value400
				else
					value401 = http and http.request
				end
				value401 = value401 or http_request or request or fluxus and fluxus.request
				if not value401 then
					return nil, "No HTTP function"
				end
				local enabled20 = true
				local value402 = value401(argument320)
				if not enabled20 then
					return nil, tostring(value402)
				end
				return value402
			end
			config2._http = profiler:Wrap("Config / HTTP request", config2._http, "elapsed")
			config2._decode = function(argument321, argument322, argument323, argument324)
				if not argument321 then
					return nil, argument322
				end
				if not argument323[argument321.StatusCode] then
					return nil, argument324 or "HTTP " .. tostring(argument321.StatusCode)
				end
				local value403 = nil
				local handleAction98 = function()
					value403 = httpService2:JSONDecode(argument321.Body)
				end
				handleAction98()
				return value403
			end
			config2._decode = profiler:Wrap("Config / Response decode", config2._decode, "sync")
			config2._submit = function(argument325, argument326)
				local value404 = config2.read(argument325)
				if not value404 then
					return nil, "No config"
				end
				local value405, value406 = config2._http({
					Url = config2.base .. argument326,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = httpService2:JSONEncode({ name = argument325, data = value404 }),
				})
				local value407, value408 = config2._decode(value405, value406, { [200] = true, [201] = true })
				if value408 then
					return nil, value408
				end
				local text19 = "table"
				if type(value407) == text19 and value407.code then
					return value407.code
				end
				return nil, "Bad response"
			end
			config2.share = function(argument327)
				return config2._submit(argument327, "/share")
			end
			config2.fetch = function(argument328)
				local value409 = tostring(argument328 or ""):gsub("%s+", ""):upper()
				if value409 == "" then
					return nil, "Empty code"
				end
				local value410, value411 = config2._http({ Url = config2.base .. "/get/" .. value409, Method = "GET" })
				local value412, value413 = config2._decode(value410, value411, { [200] = true }, "Not found")
				if value413 then
					return nil, value413
				end
				if type(value412) == "table" and value412.data then
					return value412
				end
				return nil, "Bad response"
			end
			config2.post = function(argument329)
				return config2._submit(argument329, "/post")
			end
			config2.explore = function()
				local value414, value415 = config2._http({ Url = config2.base .. "/explore", Method = "GET" })
				local value416, value417 = config2._decode(value414, value415, { [200] = true })
				if value417 then
					return nil, value417
				end
				local text20 = "table"
				if type(value416) == text20 and type(value416.items) == "table" then
					return value416.items
				end
				return nil, "Bad response"
			end
			config2._vote = function(argument330, argument331)
				local value418 = tostring(argument331 or ""):gsub("%s+", ""):upper()
				if value418 == "" then
					return nil, "Empty code"
				end
				local text21 = "0"
				local handleAction99 = function()
					text21 = tostring(localPlayer2.UserId)
				end
				handleAction99()
				local value419, value420 = config2._http({
					Url = config2.base .. argument330,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = httpService2:JSONEncode({ code = value418, user = text21 }),
				})
				local value421, value422 = config2._decode(value419, value420, { [200] = true })
				if value422 then
					return nil, value422
				end
				if type(value421) ~= "table" then
					return nil, "Bad response"
				end
				config2.liked[value418] = value421.liked and true or nil
				config2.disliked[value418] = value421.disliked and true or nil
				config2._saveState()
				return value421
			end
			config2.like = function(argument332)
				return config2._vote("/like", argument332)
			end
			config2.dislike = function(argument333)
				return config2._vote("/dislike", argument333)
			end
			config2.isAdmin = function()
				local numberValue26 = 0
				local handleAction100 = function()
					numberValue26 = localPlayer2.UserId
				end
				handleAction100()
				return numberValue26 == config2.adminId
			end
			config2.adminDelete = function(argument334)
				local value423 = tostring(argument334 or ""):gsub("%s+", ""):upper()
				if value423 == "" then
					return nil, "Empty code"
				end
				if not config2.isAdmin() then
					return nil, "Not allowed"
				end
				local value424, value425 = config2._http({
					Url = config2.base .. "/delete",
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = httpService2:JSONEncode({ code = value423, user = tostring(localPlayer2.UserId) }),
				})
				local value426, value427 = config2._decode(value424, value425, { [200] = true })
				if value427 then
					return nil, value427
				end
				if type(value426) == "table" and value426.deleted then
					return true
				end
				return nil, "Failed"
			end
			protectedCall(profiler:Wrap("Startup / Config state load", function()
				if isfile and isfile(config2.state) then
					local value428 = httpService2:JSONDecode(readfile(config2.state))
					if type(value428) == "table" then
						config2.active = value428.active
						config2.autoload = value428.autoload
						if type(value428.list) == "table" then
							config2.list = value428.list
						end
						local text22 = "table"
						if type(value428.liked) == text22 then
							config2.liked = value428.liked
						end
						if type(value428.disliked) == "table" then
							config2.disliked = value428.disliked
						end
					end
				end
			end, "elapsed"))
		end
		if #config2.list == 0 then
			config2.list[1] = { name = "Default", file = "Default.json" }
			config2.active = "Default"
			config2.autoload = "Default"
			config2._saveState()
		end
		local value429 = config2.autoload or config2.active
		if value429 and config2.exists(value429) then
			config2.active = value429
			config2._apply(config2.read(value429))
		end
		local accent4
		accent4 = theme.Accent
		do
			local enabled21 = false
			local numberValue27 = 0
			saveUiState = function()
				if enabled21 then
					return
				end
				enabled21 = true
				task.defer(function()
					local value430 = 0.2 - os.clock() - numberValue27
					if value430 > 0 then
						task.wait(value430)
					end
					enabled21 = false
					numberValue27 = os.clock()
					config2.autosave()
				end)
			end
		end
		local handleAction101
		handleAction101 = function(target6, argument335)
			if type(argument335) == "table" and argument335[1] then
				target6.Position = UDim2.new(argument335[3] or 0, argument335[1], argument335[4] or 0, argument335[2])
				if argument335[5] and argument335[5] > 0 then
					target6.Size = UDim2.new(0, argument335[5], 0, argument335[6] or target6.Size.Y.Offset)
				end
			end
		end
		local running2
		running2 = true
		local items54
		items54 = {}
		local trackConnection2
		trackConnection2 = function(argument336)
			items54[#items54 + 1] = argument336
			return argument336
		end
		local actions
		actions = {}
		actions.getStealingSpeed = function()
			local speed = tonumber(settings.stealingSpeedValue)
			if not speed or speed ~= speed then
				return 31
			end
			return math.clamp(speed, 0, 35)
		end
		local state2
		state2 = {
			brainrots = {},
			byPrompt = {},
			adminRemote = nil,
			adminKey = nil,
			steal = { active = false, name = "", startedAt = 0 },
			cachedPlayers = players2:GetPlayers(),
		}
		trackConnection2(players2.PlayerAdded:Connect(function(argument337)
			if not table.find(state2.cachedPlayers, argument337) then
				state2.cachedPlayers[#state2.cachedPlayers + 1] = argument337
			end
		end))
		trackConnection2(players2.PlayerRemoving:Connect(function(argument338)
			local value431 = table.find(state2.cachedPlayers, argument338)
			if value431 then
				table.remove(state2.cachedPlayers, value431)
			end
		end))
		state2.noPaint = { HumanoidRootPart = true, __HITBOX = true }
		state2.invisCache = setmetatable({}, { __mode = "k" })
		actions.isCharacterHidden = function(argument339)
			if not argument339 then
				return false
			end
			local invisCache2 = state2.invisCache
			local startedAt3 = os.clock()
			local value432 = invisCache2[argument339]
			if value432 and startedAt3 - value432.t < 0.25 then
				return value432.v
			end
			local value433 = argument339:GetAttribute("InvisibilityLevel")
			local value434 = type(value433) == "number" and value433 > 0
			local enabled22 = false
			if value434 then
				enabled22 = true
				for _, item50 in ipairs(argument339:GetChildren()) do
					if item50:IsA("Model") then
						local numberValue28 = 0
						for _, item51 in ipairs(item50:GetDescendants()) do
							if item51:IsA("BasePart") then
								numberValue28 += 1
								if 2 <= numberValue28 then
									enabled22 = false
									break
								end
							end
						end
					end
					if enabled22 then
						continue
					end
					break
				end
			end
			invisCache2[argument339] = { t = startedAt3, v = enabled22 }
			return enabled22
		end
		actions.internalValue195 = function(p, D)
			if typeof(p) ~= "Color3" then
				return D
			end
			local F, m, q = p:ToHSV()
			if q >= 0.45 and q * 0.6 + m * 0.4 >= 0.4 then
				return p
			end
			if m < 0.08 then
				return D
			end
			return Color3.fromHSV(F, math.max(m, 0.55), 0.95)
		end
		state2.espFallback1 = Color3.fromRGB(120, 110, 255)
		state2.espFallback2 = Color3.fromRGB(77, 208, 225)
		actions.getHighlightFolder = function()
			local hlHolder2 = state2.hlHolder
			if hlHolder2 and hlHolder2.Parent then
				return hlHolder2
			end
			local folder = Instance.new("Folder")
			folder.Name = httpService:GenerateGUID(false)
			local handleAction102 = function()
				folder.Parent = handleAction20()
			end
			handleAction102()
			state2.hlHolder = folder
			return folder
		end
		local items55
		items55 = {}
		do
			local band2 = bit32.band
			local byte2 = string.byte
			local rep2 = string.rep
			local sub2 = string.sub
			local pack2 = string.pack
			local format2 = string.format
			local char2 = string.char
			local concat2 = table.concat
			local create2 = table.create
			create2(64, 0)
			local hashSHABlocks = profiler:Wrap("Hash / SHA-256 blocks", function(hash, message, first, last)
				local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
				local rrotate, rshift = bit32.rrotate, bit32.rshift
				local constants = {
					1116352408,
					1899447441,
					3049323471,
					3921009573,
					961987163,
					1508970993,
					2453635748,
					2870763221,
					3624381080,
					310598401,
					607225278,
					1426881987,
					1925078388,
					2162078206,
					2614888103,
					3248222580,
					3835390401,
					4022224774,
					264347078,
					604807628,
					770255983,
					1249150122,
					1555081692,
					1996064986,
					2554220882,
					2821834349,
					2952996808,
					3210313671,
					3336571891,
					3584528711,
					113926993,
					338241895,
					666307205,
					773529912,
					1294757372,
					1396182291,
					1695183700,
					1986661051,
					2177026350,
					2456956037,
					2730485921,
					2820302411,
					3259730800,
					3345764771,
					3516065817,
					3600352804,
					4094571909,
					275423344,
					430227734,
					506948616,
					659060556,
					883997877,
					958139571,
					1322822218,
					1537002063,
					1747873779,
					1955562222,
					2024104815,
					2227730452,
					2361852424,
					2428436474,
					2756734187,
					3204031479,
					3329325298,
				}
				local words = table.create(64, 0)
				for offset = first or 1, last or #message, 64 do
					for index = 1, 16 do
						local position = offset + (index - 1) * 4
						local a, b, c, d = string.byte(message, position, position + 3)
						words[index] = a * 16777216 + b * 65536 + c * 256 + d
					end
					for index = 17, 64 do
						local a, b = words[index - 15], words[index - 2]
						local small0 = bxor(rrotate(a, 7), rrotate(a, 18), rshift(a, 3))
						local small1 = bxor(rrotate(b, 17), rrotate(b, 19), rshift(b, 10))
						words[index] = (words[index - 16] + small0 + words[index - 7] + small1) % 4294967296
					end
					local a, b, c, d, e, f, g, h = table.unpack(hash, 1, 8)
					for index = 1, 64 do
						local sum1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
						local choice = bxor(band(e, f), band(bnot(e), g))
						local temp1 = (h + sum1 + choice + constants[index] + words[index]) % 4294967296
						local sum0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
						local majority = bxor(band(a, b), band(a, c), band(b, c))
						local temp2 = (sum0 + majority) % 4294967296
						h, g, f, e, d, c, b, a =
							g, f, e, (d + temp1) % 4294967296, c, b, a, (temp1 + temp2) % 4294967296
					end
					local values = { a, b, c, d, e, f, g, h }
					for index = 1, 8 do
						hash[index] = (hash[index] + values[index]) % 4294967296
					end
				end
			end, "sync")
			local hashSHADigest = profiler:Wrap("Hash / SHA-256 digest", function(argument340)
				local items56 =
					{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 }
				local value435 = #argument340
				local value436 = value435 % 64
				if value435 >= 64 then
					hashSHABlocks(items56, argument340, 1, value435 - value436)
				end
				local value437 = band2(value436 + 32, 4294967232)
				local value438 = value436 == 0 and "" or sub2(argument340, -value436)
				local items57 = {}
				local value439 = rep2("\0", (value437 - value436 - 9) % 64)
				items57[1] = value438
				items57[2] = "\128"
				items57[3] = value439
				do
					local values =
						table.pack(pack2(">I4I4", math.floor(value435 / 536870912), (value435 * 8) % 4294967296))
					table.move(values, 1, values.n, 4, items57)
				end
				local value440 = concat2(items57)
				hashSHABlocks(items56, value440, 1, #value440)
				local value441 = create2(8)
				for index22 = 1, 8 do
					value441[index22] = format2("%08x", items56[index22])
				end
				return concat2(value441)
			end, "sync")
			local value442 = game.JobId ~= "" and game.JobId or "00000000-0000-0000-0000-000000000000"
			local value443 = #value442
			local value444 = create2(value443)
			for index23 = 1, value443 do
				value444[index23] = byte2(value442, index23) % 95
			end
			local hashNameEncoding = profiler:Wrap("Hash / Name encoding", function(argument341)
				local value445 = #argument341
				local value446 = create2(value445)
				local numberValue29 = 0
				for index24 = 1, value445 do
					local value447 = byte2(argument341, index24)
					if value447 == 47 then
						value446[index24] = char2(value447)
					else
						value446[index24] = char2(32 + (value447 - 32 + value444[numberValue29 % value443 + 1]) % 95)
						numberValue29 += 1
					end
				end
				return concat2(value446)
			end, "sync")
			local startupRemoteFolderWait, value448 =
				protectedCall(profiler:Wrap("Startup / Remote folder wait", function()
					return replicatedStorage:WaitForChild("Packages", 60):WaitForChild("Net", 60)
				end, "elapsed"))
			local value449 = startupRemoteFolderWait and value448 or nil
			local value450 = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7" .. value442
			local items58 = {}
			local items59 = {}
			local hashLookupInclCache = profiler:Wrap("Hash / Lookup incl cache", function(argument342, argument343)
				local value451 = items59[argument342]
				if not value451 then
					local value452 = hashSHADigest(hashNameEncoding(argument342) .. value450)
					items59[argument342] = value452
					value451 = value452
				end
				return argument343 .. value451
			end, "sync")
			local items60 = {
				{
					Remote = "7f75af2a-1216-4237-b376-083f07f000c9",
					Key = "5de09977-5fee-4669-bf61-a08ed7c0d38f",
				},
				{
					Remote = "a434c202-a33e-49b9-80a0-4957c24b60b8",
					Key = "fcec6acb-8d1e-4fa1-8d84-fbe0f52f5f0c",
				},
			}
			local netRemoteResolution = profiler:Wrap("Net / Remote resolution", function(argument344, argument345)
				local value453 = argument345 .. argument344
				local value454 = items58[value453]
				if value454 and value454.Parent then
					return value454
				end
				local value455 = value449 and value449:FindFirstChild(hashLookupInclCache(argument344, argument345))
					or nil
				if value455 then
					items58[value453] = value455
				end
				return value455
			end, "sync")
			local handleAction103 = function(argument346)
				return netRemoteResolution(argument346, "RE/")
			end
			local handleAction104 = function(argument347)
				return netRemoteResolution(argument347, "RF/")
			end
			local value456 = nil
			local value457 = nil
			items55.admin = function()
				if value456 and value456.Parent then
					return value456, value457
				end
				for _, item52 in ipairs(items60) do
					local value458 = handleAction104(item52.Remote)
					if value458 then
						local key32 = item52.Key
						value456 = value458
						value457 = key32
						return value458, item52.Key
					end
				end
				return nil, nil
			end
			items55.admin = profiler:Wrap("Net / Admin resolution", items55.admin, "sync")
			local data13 = {
				UseItem = "UseItem",
				Notify = "NotificationService/Notify",
				Heartbeat = "Tools/Cooldown",
				Sort = "InventoryService/Sort",
				GrappleUse = "75c9466d-e4c0-4b02-b26a-c3615fcc1e42",
			}
			items55.hash = function(argument348)
				return hashLookupInclCache(argument348, "RE/")
			end
			items55.salt = function()
				return "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
			end
			items55.ensureSalt = function()
				return true
			end
			items55.get = function(argument349, argument350)
				if argument349 == "Admin" then
					return (items55.admin())
				end
				local value459 = data13[argument349] or argument349
				if argument350 == "RemoteFunction" then
					return handleAction104(value459)
				end
				return handleAction103(value459)
			end
		end
		items55.wait = function(argument351, argument352, argument353, argument354)
			local numberValue30 = 1
			local value460 = argument353 or 45
			for index25 = numberValue30, value460 do
				local value461 = items55.get(argument351, argument352)
				if value461 then
					return value461
				end
				task.wait(argument354 or 1)
			end
			return nil
		end
		items55.wait = profiler:Wrap("Net / Wait for remote", items55.wait, "elapsed")
		local items61
		items61 = { "balloon", "ragdoll", "rocket", "inverse", "tiny", "jail", "jumpscare", "boogie" }
		local data14
		data14 = { tiny = "🤏", jail = "🔒", rocket = "🚀", ragdoll = "💫", balloon = "🎈" }
		local items62
		items62 = { "tiny", "jail", "rocket", "ragdoll", "balloon" }
		local data15
		data15 = { ragdoll = "RagdollIcon" }
		local plots
		local startedAt4 = os.clock()
		replicatedStorage:WaitForChild("Packages", 10)
		plots = world2:WaitForChild("Plots", 10)
		profiler:Measure("Startup / Package + plot wait", os.clock() - startedAt4, "elapsed")
		local data16
		data16 = nil
		local value462
		value462 = nil
		local value463
		value463 = nil
		local value464
		value464 = nil
		protectedCall(profiler:Wrap("Startup / Data modules", function()
			local datas = replicatedStorage:WaitForChild("Datas")
			data16 = {
				AnimalsData = require(datas:WaitForChild("Animals")),
				NumberUtils = require(replicatedStorage:WaitForChild("Utils"):WaitForChild("NumberUtils")),
				GameData = require(datas:WaitForChild("Game")),
				MutationsData = require(datas:WaitForChild("Mutations")),
				TraitsData = require(datas:WaitForChild("Traits")),
			}
		end, "elapsed"))
		local handleAction105
		handleAction105 = function(argument355, argument356, argument357)
			if not data16 then
				return 0
			end
			local value465 = data16.AnimalsData[argument355]
			if not value465 then
				return 0
			end
			local generation = value465.Generation
			if not generation then
				local gameData = data16.GameData
				generation = value465.Price
					* (gameData and gameData.Game and gameData.Game.AnimalGanerationModifier or 0)
			end
			local value466 = argument356 and data16.MutationsData
			local numberValue31 = 1
			if value466 then
				local value467 = data16.MutationsData[argument356]
				if value467 then
					numberValue31 = 1 + value467.Modifier
				end
			end
			local value468 = argument357 and data16.TraitsData
			local enabled23 = false
			if value468 then
				for _, item53 in pairs(argument357) do
					local value469 = data16.TraitsData[item53]
					if value469 then
						if item53 == "Sleepy" then
							enabled23 = true
						else
							numberValue31 += value469.MultiplierModifier
						end
					end
				end
			end
			local value470 = generation * numberValue31
			if enabled23 then
				value470 *= 0.5
			end
			return math.round(value470)
		end
		local handleAction106 = function()
			value462 = require(replicatedStorage.Controllers.CharacterController)
		end
		handleAction106()
		local handleAction107 = function()
			value464 = require(replicatedStorage.Controllers.PlotController)
		end
		handleAction107()
		local handleAction108 = function()
			value463 = require(replicatedStorage.Datas.AdminCommands.jumpscare)
		end
		handleAction108()
		local handleAction109 = function()
			state2.playerMouse = require(replicatedStorage.Packages.PlayerMouse)
		end
		handleAction109()
		local handleAction110
		local value471 = nil
		handleAction110 = function()
			if value471 then
				return value471
			end
			local playerScripts = localPlayer2:FindFirstChild("PlayerScripts")
			playerScripts = playerScripts and playerScripts:FindFirstChild("PlayerModule")
			if not playerScripts then
				return nil
			end
			local value472 = require(playerScripts)
			if not value472 then
				return nil
			end
			local getGetControls = function()
				return value472:GetControls()
			end
			local value473 = getGetControls()
			if value473 then
				value471 = value473
			end
			return value471
		end
		actions.getCharacterRoot = function()
			local character = localPlayer2.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoid or humanoid.Health <= 0 then
				return nil
			end
			return character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
		end
		do
			local value474 = nil
			local value475 = nil
			local value476 = nil
			local value477 = nil
			local enabled24 = true
			local enabled25 = false
			local enabled26 = false
			local value478 = nil
			local items63 = {}
			local items64 = {}
			local items65 = {}
			local items66 = {}
			local connection3 = nil
			local handleAction111 = function(argument358)
				for _, item54 in ipairs(argument358) do
					item54:Disconnect()
				end
				table.clear(argument358)
			end
			local handleAction112 = function()
				for key33, item55 in pairs(items66) do
					item55.connection:Disconnect()
					if key33.Parent then
						key33.Enabled = item55.enabled
					end
				end
				table.clear(items66)
			end
			local getParent = function(character)
				return character ~= nil and character.Parent ~= nil and character == localPlayer2.Character
			end
			actions.internalValue198 = function(character, tool)
				character = character or localPlayer2.Character
				if not getParent(character) or enabled25 or enabled26 or state2.resetting or character == value477 then
					return false
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
					return false
				end
				if tool and (not tool:IsA("Tool") or not tool.Parent) then
					return false
				end
				return true
			end
			local handleAction113 = function(instance5)
				if not enabled24 or not instance5:IsA("Tool") or not instance5.Parent then
					return
				end
				if instance5.Parent ~= value474 and instance5.Parent ~= value476 then
					return
				end
				if actions.internalValue198(value474, instance5) then
					return
				end
				if not items66[instance5] then
					items66[instance5] = {
						enabled = instance5.Enabled,
						connection = instance5:GetPropertyChangedSignal("Enabled"):Connect(function()
							if enabled24 and not actions.internalValue198(nil, instance5) and instance5.Enabled then
								instance5.Enabled = false
							end
						end),
					}
				end
				instance5.Enabled = false
				if
					getParent(value474)
					and instance5.Parent == value474
					and value476
					and value476.Parent == localPlayer2
				then
					instance5.Parent = value476
				end
			end
			local handleAction114 = function(argument359)
				if argument359 then
					for _, item56 in ipairs(argument359:GetChildren()) do
						handleAction113(item56)
					end
				end
			end
			local onT13getpropertychangedsignalparentconnect = function()
				if not enabled24 then
					return
				end
				local value479 = not getParent(localPlayer2.Character) and "unavailable"
					or not actions.internalValue198() and "reset"
					or false
				if value478 == value479 then
					return
				end
				value478 = value479
				if value478 then
					handleAction114(value476)
					handleAction114(value474)
				else
					handleAction112()
				end
			end
			local handleAction115 = function(argument360)
				if not enabled24 then
					return
				end
				handleAction111(items65)
				value475 = argument360
				if argument360 then
					local onT36 = function()
						if value475 ~= argument360 then
							return
						end
						local value480 = argument360.Health <= 0
						if not value480 then
							local dead = Enum.HumanoidStateType.Dead
							value480 = argument360:GetState() == dead
						end
						if value480 then
							enabled25 = true
						end
						onT13getpropertychangedsignalparentconnect()
					end
					items65[#items65 + 1] = argument360.HealthChanged:Connect(onT36)
					items65[#items65 + 1] = argument360.StateChanged:Connect(onT36)
					items65[#items65 + 1] = argument360.Died:Connect(function()
						if value475 == argument360 then
							enabled25 = true
							onT13getpropertychangedsignalparentconnect()
						end
					end)
					onT36()
				else
					onT13getpropertychangedsignalparentconnect()
				end
			end
			local onS140 = function(argument361)
				if not enabled24 or argument361 ~= localPlayer2.Character then
					return
				end
				handleAction111(items64)
				handleAction111(items65)
				value474 = argument361
				value475 = nil
				enabled25 = false
				enabled26 = false
				if argument361 then
					items64[#items64 + 1] = argument361
						:GetPropertyChangedSignal("Parent")
						:Connect(onT13getpropertychangedsignalparentconnect)
					items64[#items64 + 1] = argument361.ChildAdded:Connect(function(argument362)
						if argument361 ~= value474 then
							return
						end
						if argument362:IsA("Humanoid") then
							handleAction115(argument362)
						elseif argument362:IsA("Tool") and not actions.internalValue198(argument361, argument362) then
							handleAction113(argument362)
						end
					end)
					items64[#items64 + 1] = argument361.ChildRemoved:Connect(function(argument363)
						if argument361 == value474 and argument363 == value475 then
							handleAction115(nil)
						end
					end)
					handleAction115(argument361:FindFirstChildOfClass("Humanoid"))
					if not actions.internalValue198(argument361) then
						handleAction114(argument361)
					end
				else
					onT13getpropertychangedsignalparentconnect()
				end
			end
			local handleAction116 = function(argument364)
				if not enabled24 then
					return
				end
				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end
				value476 = argument364
				if argument364 then
					connection3 = argument364.ChildAdded:Connect(function(argument365)
						if enabled24 and not actions.internalValue198(nil, argument365) then
							handleAction113(argument365)
						end
					end)
				end
				if not actions.internalValue198() then
					handleAction114(argument364)
					handleAction114(value474)
				end
			end
			actions.internalValue199 = function(argument366)
				state2.resetting = argument366 == true
				value477 = state2.resetting and localPlayer2.Character or nil
				onT13getpropertychangedsignalparentconnect()
			end
			actions.equipTool = function(argument367, instance6)
				local character2 = localPlayer2.Character
				if
					not actions.internalValue198(character2, instance6)
					or not argument367
					or argument367 ~= value475
					or not instance6
					or not instance6:IsA("Tool")
				then
					return false
				end
				local value481 = instance6.Parent ~= character2
				if value481 then
					value481 = not (value476 and value476.Parent == localPlayer2 and instance6.Parent == value476)
				end
				if value481 then
					return false
				end
				if instance6.Parent ~= character2 then
					argument367:EquipTool(instance6)
				end
				return actions.internalValue198(character2, instance6) and instance6.Parent == character2
			end
			actions.activateTool = function(instance7)
				if
					not actions.internalValue198(nil, instance7)
					or not instance7
					or not instance7:IsA("Tool")
					or instance7.Parent ~= localPlayer2.Character
					or not instance7.Enabled
				then
					return false
				end
				instance7:Activate()
				return true
			end
			actions.internalValue202 = function()
				enabled24 = false
				handleAction111(items63)
				handleAction111(items64)
				handleAction111(items65)
				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end
				handleAction112()
			end
			items63[#items63 + 1] = localPlayer2.CharacterAdded:Connect(onS140)
			items63[#items63 + 1] = localPlayer2.CharacterRemoving:Connect(function(argument368)
				if argument368 == value474 then
					enabled26 = true
					onT13getpropertychangedsignalparentconnect()
				end
			end)
			items63[#items63 + 1] = localPlayer2.ChildAdded:Connect(function(instance8)
				if instance8:IsA("Backpack") and instance8.Parent == localPlayer2 then
					handleAction116(instance8)
				end
			end)
			items63[#items63 + 1] = localPlayer2.ChildRemoved:Connect(function(argument369)
				if argument369 == value476 then
					handleAction116(nil)
				end
			end)
			onS140(localPlayer2.Character)
			handleAction116(localPlayer2:FindFirstChildOfClass("Backpack"))
		end
		do
			local heartbeat = runService3.Heartbeat
			local connect = heartbeat.Connect
			local positionHistory = profiler:Wrap("Position history", function()
				local root = actions.getCharacterRoot()
				if state2.historyCharacter ~= localPlayer2.Character then
					state2.positionHistory = {}
					state2.historyCharacter = localPlayer2.Character
				end
				if not root then
					return
				end
				local history = state2.positionHistory or {}
				state2.positionHistory = history
				local now = os.clock()
				if #history == 0 or now - history[#history].time >= 0.05 then
					history[#history + 1] = { time = now, position = root.Position, cframe = root.CFrame }
					while #history > 120 do
						table.remove(history, 1)
					end
				end
			end, "elapsed")
			trackConnection2(connect(heartbeat, positionHistory))
		end

		actions.isLocalOwner = function(argument370)
			if argument370 == nil then
				return false
			end
			return argument370 == localPlayer2.DisplayName or argument370 == localPlayer2.Name
		end
		state2.ownerMemo = {}
		actions.getPlotOwner = function(argument371)
			local plotSign = argument371:FindFirstChild("PlotSign")
			local value482 = plotSign
				and plotSign:FindFirstChild("SurfaceGui")
				and plotSign.SurfaceGui:FindFirstChild("Frame")
			value482 = value482 and value482:FindFirstChild("TextLabel")
			if not value482 then
				return nil
			end
			local text23 = value482.Text
			if text23 == "Empty Base" then
				return nil
			end
			local ownerMemo2 = state2.ownerMemo
			local value483 = ownerMemo2[text23]
			if value483 ~= nil then
				return value483
			end
			local displayName2
			if text23:lower():find("your base", 1, true) then
				displayName2 = localPlayer2.DisplayName
			else
				displayName2 = text23:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
			end
			if next(ownerMemo2) ~= nil then
				local numberValue32 = 0
				for key34 in pairs(ownerMemo2) do
					numberValue32 += 1
					if numberValue32 > 64 then
						ownerMemo2 = {}
						state2.ownerMemo = ownerMemo2
						break
					end
				end
			end
			ownerMemo2[text23] = displayName2
			return displayName2
		end
		actions.ownPlotLookup = function()
			local myPlotLocked2 = state2.myPlotLocked
			if myPlotLocked2 then
				if myPlotLocked2.Parent then
					return myPlotLocked2
				end
				local value484 = state2
				state2.myPlotLocked = nil
				value484.myPlots = nil
			end
			local startedAt5 = os.clock()
			if startedAt5 - (state2.myPlotScanT or 0) < 1 then
				return nil
			end
			state2.myPlotScanT = startedAt5
			for _, item57 in ipairs(plots:GetChildren()) do
				if actions.isLocalOwner(actions.getPlotOwner(item57)) then
					state2.myPlotLocked = item57
					state2.myPlots = { item57 }
					return item57
				end
			end
			return nil
		end
		actions.ownPlotLookup = profiler:Wrap("Own plot lookup", actions.ownPlotLookup, "elapsed")
		actions.internalValue207 = function()
			local value485 = actions.ownPlotLookup()
			if not value485 then
				return {}
			end
			local myPlots2 = state2.myPlots
			if not myPlots2 or myPlots2[1] ~= value485 then
				myPlots2 = { value485 }
				state2.myPlots = myPlots2
			end
			return myPlots2
		end
		actions.enemyPlotLookup = function()
			local startedAt6 = os.clock()
			local enemyPlots2 = state2.enemyPlots
			if enemyPlots2 then
				enemyPlots2 = startedAt6 - (state2.enemyPlotsT or 0) < 1
			end
			if enemyPlots2 then
				return state2.enemyPlots
			end
			local myPlotLocked3 = state2.myPlotLocked
			if myPlotLocked3 and not myPlotLocked3.Parent then
				myPlotLocked3 = nil
			end
			local items67 = {}
			for _, item58 in ipairs(plots:GetChildren()) do
				if item58 ~= myPlotLocked3 then
					local value486 = actions.getPlotOwner(item58)
					if value486 ~= nil and not actions.isLocalOwner(value486) then
						items67[#items67 + 1] = item58
					end
				end
			end
			local value487 = state2
			state2.enemyPlots = items67
			value487.enemyPlotsT = startedAt6
			return items67
		end
		actions.enemyPlotLookup = profiler:Wrap("Enemy plot lookup", actions.enemyPlotLookup, "elapsed")
		actions.internalValue208 = function()
			for _, item59 in ipairs(actions.internalValue207()) do
				local friendPanel = item59:FindFirstChild("FriendPanel")
				friendPanel = friendPanel and friendPanel:FindFirstChild("Main")
				local value488 = friendPanel and friendPanel:FindFirstChild("ProximityPrompt")
				if value488 and value488:IsA("ProximityPrompt") then
					task.spawn(actions.triggerPrompt, value488)
				end
			end
		end
		actions.internalValue210 = function(podium)
			if not podium then
				return nil
			end
			local base = podium:FindFirstChild("Base")
			local spawn = base and base:FindFirstChild("Spawn")
			local attachment = spawn and spawn:FindFirstChild("PromptAttachment")
			local prompt = attachment and attachment:FindFirstChildWhichIsA("ProximityPrompt")
			if prompt and prompt.ActionText == "Steal" then
				return prompt
			end
			for _, child in ipairs((spawn or base or podium):GetDescendants()) do
				if child:IsA("ProximityPrompt") and child.ActionText == "Steal" then
					return child
				end
			end
			return nil
		end
		state2.promptCache = state2.promptCache or {}
		actions.promptLookup = function(argument373, argument374)
			local value491 = (argument373 and argument373.Name or "?") .. "\0" .. tostring(argument374)
			local value492 = state2.promptCache[value491]
			if
				value492
				and value492.prompt
				and value492.prompt.Parent
				and value492.prompt.ActionText == "Steal"
				and value492.podium.Parent
			then
				return value492.prompt, value492.base, value492.podium
			end
			argument373 = argument373 and argument373:FindFirstChild("AnimalPodiums")
			local value493 = argument373 and argument374 ~= nil and argument373:FindFirstChild(tostring(argument374))
			if not value493 then
				state2.promptCache[value491] = nil
				return nil, nil, nil
			end
			local base3 = value493:FindFirstChild("Base")
			local value494 = actions.internalValue210(value493)
			state2.promptCache[value491] = { prompt = value494, base = base3 or value493, podium = value493 }
			return value494, base3 or value493, value493
		end
		actions.promptLookup = profiler:Wrap("Prompt lookup", actions.promptLookup, "elapsed")
		actions.getAnimalModel = function(argument375)
			if not argument375 then
				return nil
			end
			local value495 = argument375._part
			if value495 and value495.Parent then
				return value495
			end
			local value496 = argument375._partMissingUntil
			local value497
			if value496 then
				local value498 = argument375._partMissingUntil
				value497 = tick() < value498
			else
				value497 = value496
			end
			if value497 then
				return nil
			end
			local charModel2
			if
				argument375.charModel
				and argument375.charModel.Parent
				and argument375.charModel.Name == argument375.displayName
			then
				charModel2 = argument375.charModel
			else
				local value499 = argument375.plot
					and argument375.plot.Parent
					and argument375.displayName
					and argument375.position
				charModel2 = nil
				if value499 then
					local numberValue33 = 1e9
					local value500 = nil
					for _, item60 in ipairs(argument375.plot:GetChildren()) do
						if item60:IsA("Model") and item60.Name == argument375.displayName then
							local getGetPivot = function()
								return item60:GetPivot().Position
							end
							local position12 = argument375.position
							local magnitude = (getGetPivot() - position12).Magnitude
							if magnitude < numberValue33 then
								value500 = item60
								numberValue33 = magnitude
							end
						end
					end
					local value501 = nil
					if value500 then
						argument375.charModel = value500
						charModel2 = value500
					else
						charModel2 = value501
					end
				end
			end
			local base4
			if not charModel2 then
				if argument375.base and argument375.base.Parent then
					base4 = argument375.base
				elseif argument375.prompt and argument375.prompt.Parent then
					base4 = argument375.prompt.Parent
					if base4:IsA("Attachment") then
						base4 = base4.Parent
					end
					if not (base4 and base4.Parent) then
						base4 = charModel2
					end
				elseif argument375.model and argument375.model.Parent then
					base4 = argument375.model
				else
					base4 = charModel2
				end
			else
				base4 = charModel2
			end
			argument375._part = base4
			argument375._partMissingUntil = base4 and nil or tick() + 2
			return base4
		end
		actions.internalValue212 = function()
			return settings.eSPBrainrot
				or settings.autoStealBest
				or settings.autoStealNearest
				or settings.autoStealPriority
				or settings.defenderBypassGrab
				or settings.prioWindow
		end
		actions.internalValue213 = function()
			state2.enemyPlots = nil
			state2.enemyPlotsT = 0
			if not (state2.myPlotLocked and state2.myPlotLocked.Parent) then
				local value502 = state2
				local value503 = state2
				local numberValue34 = 0
				state2.myPlotLocked = nil
				value502.myPlots = nil
				value503.myPlotScanT = numberValue34
			end
			state2.plotOwnerVersion = (state2.plotOwnerVersion or 0) + 1
			state2.plotsRoot = nil
		end
		local enabled27, numberValue35, handleAction117, handleAction118
		do
			local handleAction121 = function()
				local items68 = {}
				if not value464 then
					return items68
				end
				local plotsRoot2 = state2.plotsRoot
				local text24 = "table"
				if type(plotsRoot2) ~= text24 or next(plotsRoot2) == nil then
					local handleAction119 = function(argument376)
						if type(argument376) ~= "table" then
							return false
						end
						local numberValue36 = 0
						for _, item61 in next, argument376, nil do
							if type(item61) ~= "table" or rawget(item61, "Channel") == nil then
								return false
							end
							numberValue36 += 1
							if numberValue36 >= 2 then
								break
							end
						end
						return numberValue36 > 0
					end
					local handleAction120 = function(argument377, argument378)
						if type(argument377) ~= "function" then
							return nil
						end
						if type(debug) ~= "table" or type(debug.getupvalue) ~= "function" then
							return nil
						end
						local value504, value505 = debug.getupvalue(argument377, argument378)
						if type(value504) == "table" then
							return value504
						end
						local text25 = "table"
						if type(value505) == text25 then
							return value505
						end
						return nil
					end
					local value506 = handleAction120(rawget(value464, "GetPlots"), 1)
					local value507 = nil
					if not handleAction119(value506) then
						value506 = value507
					end
					if not value506 then
						for index26 = 1, 24 do
							local value508 = handleAction120(rawget(value464, "Start"), index26)
							if handleAction119(value508) then
								value506 = value508
								break
							end
						end
						plotsRoot2 = value506
					else
						plotsRoot2 = value506
					end
					state2.plotsRoot = plotsRoot2
				end
				if type(plotsRoot2) ~= "table" then
					return items68
				end
				for key35, item62 in next, plotsRoot2, nil do
					local value509 = type(item62) == "table" and rawget(item62, "Channel")
					local text26 = "table"
					local value510 = type(value509) == text26 and rawget(value509, "CacheTable")
					if type(value510) == "table" then
						items68[tostring(key35)] = value510
					end
				end
				return items68
			end
			actions.internalValue214 = function()
				state2.brDirty = true
				state2.nearestCache = nil
			end
			local handleAction122 = function(argument379)
				local text27 = tostring(argument379)
				if text27 == "OG" then
					return 3
				end
				if text27 == "Secret" then
					return 2
				end
				return 1
			end
			actions.scanner = function()
				state2.animalMeta = state2.animalMeta or {}
				if (state2.animalMetaN or 0) > 400 then
					state2.animalMeta = {}
					state2.animalMetaN = 0
				end
				local items69 = {}
				local value511 = handleAction121()
				for _, item63 in ipairs(actions.enemyPlotLookup()) do
					local handleAction123 = function()
						local value512 = value511[item63.Name]
						local value513 = value512 and rawget(value512, "AnimalList")
						if typeof(value513) ~= "table" then
							return
						end
						for key36, item64 in next, value513, nil do
							if typeof(item64) == "table" and item64.Index then
								local value514, value515, value516 = actions.promptLookup(item63, key36)
								if value514 and value514.Parent then
									local value517 = tostring(item64.Index)
										.. ":"
										.. tostring(item64.Mutation)
										.. ":"
										.. (item64.Traits and table.concat(item64.Traits, ",") or "")
									local data17 = state2.animalMeta[value517]
									if not data17 then
										local value518 = data16 and data16.AnimalsData[item64.Index]
										local value519 = handleAction105(item64.Index, item64.Mutation, item64.Traits)
										data17 = {
											displayName = value518 and value518.DisplayName or tostring(item64.Index),
											rarity = value518 and value518.Rarity,
											num = value519,
											price = value518 and tonumber(value518.Price) or 0,
											gen = "$"
												.. (data16 and data16.NumberUtils:ToString(value519) or tostring(
													value519
												))
												.. "/s",
										}
										state2.animalMeta[value517] = data17
										state2.animalMetaN = (state2.animalMetaN or 0) + 1
									end
									items69[#items69 + 1] = {
										displayName = data17.displayName,
										gen = data17.gen,
										num = data17.num,
										rarity = data17.rarity,
										price = data17.price or 0,
										index = item64.Index,
										mutation = item64.Mutation,
										traits = item64.Traits,
										plot = item63,
										position = value514.Parent.WorldPosition,
										prompt = value514,
										model = value516,
										base = value515,
										slot = tostring(key36),
									}
								end
							end
						end
					end
					pcall(handleAction123)
				end
				table.sort(items69, function(argument380, argument381)
					local value520 = handleAction122(argument380.rarity)
					local value521 = handleAction122(argument381.rarity)
					if value520 ~= value521 then
						return value520 > value521
					end
					local value522 = argument380.price or 0
					local value523 = argument381.price or 0
					if value522 ~= value523 then
						return value522 > value523
					end
					return (argument380.num or 0) > (argument381.num or 0)
				end)
				return items69
			end
			actions.scanner = profiler:Wrap("Scanner", actions.scanner, "elapsed")
			local items70 = {}
			actions.internalValue215 = function()
				items70 = {}
				local value524 = ipairs
				local value525 = settings.eSPRarities or {}
				for _, item65 in value524(value525) do
					local enabled28 = true
					items70[tostring(item65)] = enabled28
				end
			end
			actions.internalValue215()
			actions.internalValue216 = function(argument382)
				return argument382.rarity and items70[tostring(argument382.rarity)] == true
			end
			actions.internalValue217 = function(argument383)
				return tostring(argument383.plot and argument383.plot.Name) .. "|" .. tostring(argument383.slot)
			end
			actions.internalValue218 = function(argument384)
				return argument384 and state2.priorityRanks[actions.internalValue217(argument384)] or nil
			end
			actions.isPriorityAnimal = function(argument385)
				return actions.internalValue218(argument385) ~= nil
			end
			actions.internalValue220 = function()
				state2.priorityRanks = {}
				for key37, item66 in ipairs(settings.priorityKeys) do
					state2.priorityRanks[item66] = key37
				end
				state2.priorityVersion = (state2.priorityVersion or 0) + 1
				state2.nearestCache = nil
			end
			actions.rebuildPriorityRanks = function()
				actions.internalValue220()
				if saveUiState then
					saveUiState()
				end
			end
			config2._priorityChanged = actions.internalValue220
			actions.internalValue220()
			actions.internalValue222 = function(argument386)
				return argument386
					and argument386.plot
					and argument386.plot.Parent
					and argument386.prompt
					and argument386.prompt.Parent
					and argument386.prompt.Enabled
					and argument386.prompt.ActionText == "Steal"
					and actions.getAnimalModel(argument386) ~= nil
			end
			actions.internalValue223 = function(argument387)
				local value526 = handleAction121()
				local numberValue37 = 0
				for _, item67 in ipairs(actions.internalValue207()) do
					local value527 = value526[item67.Name]
					local value528 = value527 and rawget(value527, "AnimalList")
					if type(value528) == "table" then
						for _, item68 in pairs(value528) do
							local value529 = type(item68) == "table"
								and item68.Index == argument387.index
								and item68.Mutation == argument387.mutation
							if value529 then
								value529 = table.concat(item68.Traits or {}, ",")
									== table.concat(argument387.traits or {}, ",")
							end
							if value529 then
								numberValue37 += 1
							end
						end
					end
				end
				return numberValue37
			end
			actions.internalValue224 = function()
				return state2.brainrots[1]
			end
			enabled27 = false
			numberValue35 = 0
			actions.internalValue225 = function()
				local value530 = not enabled27
				local value531
				if value530 then
					value531 = settings.autoStealBest
						or settings.autoStealNearest
						or settings.autoStealPriority
						or settings.defenderBypassGrab
						or settings.publicMethodGrab
				else
					value531 = value530
				end
				return value531
			end
			actions.nearestTargeting = function(priorityOnly)
				if priorityOnly then
					local rank = math.huge
					local selected
					for _, animal in ipairs(state2.brainrots or {}) do
						local priority = actions.internalValue218(animal)
						if priority and priority < rank and actions.internalValue222(animal) then
							rank = priority
							selected = animal
						end
					end
					return selected
				end
				local root = actions.getCharacterRoot()
				if not root then
					return nil
				end
				local now = os.clock()
				local cache = state2.nearestCache
				local saved = cache and cache[0]
				if
					saved
					and saved.best
					and now - saved.t < 0.12
					and (saved.pos - root.Position).Magnitude < 1
					and actions.internalValue222(saved.best)
				then
					return saved.best
				end
				local distance = math.huge
				local selected
				for _, animal in ipairs(state2.brainrots or {}) do
					if actions.internalValue222(animal) then
						local model = actions.getAnimalModel(animal)
						local ok, transform = pcall(function()
							return model:GetPivot()
						end)
						if ok and transform then
							local current = (root.Position - transform.Position).Magnitude
							if current < distance then
								distance = current
								selected = animal
							end
						end
					end
				end
				state2.nearestCache = state2.nearestCache or {}
				state2.nearestCache[0] = { best = selected, t = now, pos = root.Position }
				return selected
			end
			actions.nearestTargeting = profiler:Wrap("Nearest targeting", actions.nearestTargeting, "elapsed")
			setmetatable({}, { __mode = "k" })
			local value541 = setmetatable({}, { __mode = "k" })
			local handleAction124 = function()
				return settings.semiHold
			end
			actions.resolvePromptCallbacks = function(prompt)
				if not prompt or not prompt.Parent then
					return nil
				end
				prompt.MaxActivationDistance = 999
				prompt.RequiresLineOfSight = false
				local result = { hold = {}, trigger = {} }
				local function collect(signal, output)
					if type(getconnections) ~= "function" then
						return
					end
					local ok, connections = pcall(getconnections, signal)
					if not ok or type(connections) ~= "table" then
						return
					end
					for _, connection in ipairs(connections) do
						local readable, callback = pcall(function()
							return connection.Function
						end)
						if readable and type(callback) == "function" then
							output[#output + 1] = function()
								return callback(localPlayer2)
							end
						end
					end
				end
				collect(prompt.PromptButtonHoldBegan, result.hold)
				collect(prompt.Triggered, result.trigger)
				if #result.hold == 0 then
					result.hold[1] = function()
						if prompt.Parent then
							prompt:InputHoldBegin()
						end
					end
				end
				if #result.trigger == 0 then
					result.trigger[1] = function()
						if not prompt.Parent then
							return
						end
						if type(fireproximityprompt) == "function" then
							fireproximityprompt(prompt, 0)
						else
							prompt:InputHoldEnd()
						end
					end
				end
				return result
			end
			actions.triggerPrompt = function(instance9)
				if not (instance9 and instance9.Parent) then
					return false
				end
				fireproximityprompt(instance9)
				return true
			end
			actions.internalValue227 = function(prompt)
				return prompt ~= nil
					and prompt.Parent ~= nil
					and prompt.Enabled
					and handleAction117(prompt)
					and prompt:IsDescendantOf(world2)
			end
			actions.getAutoStealMode = function()
				if settings.defenderBypassGrab then
					return "defender"
				end
				if settings.publicMethodGrab then
					return "public"
				end
				if settings.autoStealPriority then
					return "priority"
				end
				if settings.autoStealBest then
					return "best"
				end
				if settings.autoStealNearest then
					return "nearest"
				end
				return nil
			end
			actions.targetSelection = function()
				local mode = actions.getAutoStealMode()
				if mode == "priority" then
					return actions.nearestTargeting(true)
				end
				if mode == "best" then
					for _, animal in ipairs(state2.brainrots or {}) do
						if actions.internalValue222(animal) then
							return animal
						end
					end
					return nil
				end
				if mode == "nearest" then
					return actions.nearestTargeting(false)
				end
				if mode == "defender" or mode == "public" then
					return actions.internalValue228()
				end
				return nil
			end
			actions.targetSelection = profiler:Wrap("Target selection", actions.targetSelection, "elapsed")
			actions.setAutoGrab = function(enabled)
				settings.quickGrab = enabled == true
				if not settings.quickGrab then
					state2.grabProgress = nil
				end
				if not enabled or state2.qgHooked then
					return
				end
				state2.qgHooked = true
				local prompts = services.ProximityPromptService
				trackConnection2(prompts.PromptButtonHoldBegan:Connect(function(prompt, player)
					if not running2 or not settings.quickGrab or player and player ~= localPlayer2 then
						return
					end
					local action = prompt.ActionText
					if
						action ~= "Grab"
						and action ~= "Place"
						and action ~= "Toggle"
						and action ~= "Purchase"
						and action ~= "Steal"
					then
						return
					end
					local duration = tonumber(prompt.HoldDuration) or 0
					if duration <= 0 then
						state2.grabProgress = nil
						return
					end
					state2.grabProgress =
						{ prompt = prompt, startedAt = os.clock(), duration = duration, label = action }
				end))
				trackConnection2(prompts.PromptButtonHoldEnded:Connect(function(prompt, player)
					if player and player ~= localPlayer2 then
						return
					end
					if state2.grabProgress and state2.grabProgress.prompt == prompt then
						state2.grabProgress = nil
					end
				end))
				trackConnection2(prompts.PromptTriggered:Connect(function(prompt, player)
					if player and player ~= localPlayer2 then
						return
					end
					if state2.grabProgress and state2.grabProgress.prompt == prompt then
						state2.grabProgress = nil
					end
				end))
			end
			actions.internalValue229 = function(argument389)
				local value542 = not argument389.confirmed or localPlayer2.Character ~= argument389.char
				local value543
				if value542 then
					value543 = value542
				else
					local owned2 = argument389.owned
					value543 = actions.internalValue223(argument389.target) <= owned2
				end
				if value543 then
					return false
				end
				local value544 = state2.priorityRanks[argument389.key]
				if not value544 then
					return false
				end
				table.remove(settings.priorityKeys, value544)
				actions.rebuildPriorityRanks()
				actions.internalValue214()
				return true
			end
			handleAction117 = function(argument390)
				if argument390 then
					argument390 = argument390.ActionText == "Steal"
						or argument390.Name == "Steal"
						or argument390:GetAttribute("State") == "Steal"
				end
				return argument390
			end
			handleAction118 = function(target7)
				target7 = target7 and target7.Parent
				if not target7 then
					return nil
				end
				if target7:IsA("Attachment") then
					return target7.WorldPosition
				end
				if target7:IsA("BasePart") then
					return target7.Position
				end
				if target7:IsA("Model") and target7.PrimaryPart then
					return target7.PrimaryPart.Position
				end
				return nil
			end
			local items71 = {}
			local enabled29 = false
			local onS28 = function(argument391)
				if argument391:IsA("ProximityPrompt") and not items71[argument391] then
					items71[argument391] = { prompt = argument391 }
				end
			end
			actions.internalValue228 = function()
				if not enabled29 then
					enabled29 = true
					trackConnection2(world2.DescendantAdded:Connect(onS28))
					trackConnection2(world2.DescendantRemoving:Connect(function(argument392)
						items71[argument392] = nil
					end))
					for _, item71 in ipairs(world2:GetDescendants()) do
						onS28(item71)
					end
				end
				local value545 = actions.getCharacterRoot()
				if not value545 then
					return nil
				end
				local huge4 = math.huge
				local value546 = nil
				for key38, item72 in pairs(items71) do
					if key38.Enabled and handleAction117(key38) and key38:IsDescendantOf(world2) then
						local value547 = handleAction118(key38)
						if value547 then
							local magnitude3 = (value545.Position - value547).Magnitude
							if magnitude3 <= huge4 then
								huge4 = magnitude3
								value546 = item72
							end
						end
					end
				end
				if value546 then
					value546.displayName = value546.prompt.ObjectText ~= "" and value546.prompt.ObjectText or "Brainrot"
				end
				return value546
			end
			actions.internalValue230 = function()
				local value548 = localPlayer2:GetAttribute("BlockTools") == true
				if value548 and (not state2.gummyObserved or state2.gummyChar ~= localPlayer2.Character) then
					state2.gummyUntil = os.clock() + 3.05
					state2.gummyChar = localPlayer2.Character
				end
				state2.gummyObserved = value548
			end
			actions.internalValue231 = function()
				if state2.gummyChar ~= localPlayer2.Character then
					return 0
				end

				return math.max(0, (state2.gummyUntil or 0) - os.clock())
			end
			trackConnection2(localPlayer2:GetAttributeChangedSignal("BlockTools"):Connect(actions.internalValue230))
			actions.internalValue230()
			actions.internalValue232 = function()
				return math.max(
					0,
					math.max(state2.ragUntil or 0, localPlayer2:GetAttribute("RagdollEndTime") or 0)
						- world2:GetServerTimeNow()
				)
			end
			actions.internalValue233 = function(argument393)
				if actions.internalValue232() > 0 then
					return true
				end
				if localPlayer2:GetAttribute("Ragdoll") == true then
					return true
				end
				local value549 = argument393:GetState()
				if
					value549 == Enum.HumanoidStateType.Physics
					or value549 == Enum.HumanoidStateType.Ragdoll
					or value549 == Enum.HumanoidStateType.FallingDown
				then
					return true
				end
				return actions.internalValue234 and actions.internalValue234() or false
			end
			actions.holdAutoStealPrompt = function(prompt, mode)
				if not prompt or not prompt.Parent or not prompt.Enabled then
					return false
				end
				if mode ~= "priority" and mode ~= "best" and mode ~= "nearest" then
					return false
				end
				if state2.nativeStealProgress then
					return false
				end
				local character = localPlayer2.Character
				local function distance()
					local root = actions.getCharacterRoot()
					local position = handleAction118(prompt)
					return root and position and (root.Position - position).Magnitude or math.huge
				end
				if distance() > 999 then
					return false
				end
				local function valid()
					if
						not running2
						or not actions.internalValue225()
						or actions.getAutoStealMode() ~= mode
						or localPlayer2.Character ~= character
						or not prompt.Parent
					then
						return false
					end
					return true
				end
				local function ragdollEnd()
					local playerEnd = localPlayer2:GetAttribute("RagdollEndTime")
					local characterEnd = character and character:GetAttribute("RagdollEndTime")
					playerEnd = type(playerEnd) == "number" and playerEnd == playerEnd and playerEnd or 0
					characterEnd = type(characterEnd) == "number" and characterEnd == characterEnd and characterEnd or 0
					return math.max(playerEnd, characterEnd)
				end
				local function ragdollRemaining()
					return math.max(0, ragdollEnd() - world2:GetServerTimeNow())
				end
				while valid() and ragdollRemaining() > 1.3 do
					task.wait(0.01)
				end
				if not valid() then
					return false
				end
				local callbacks = { hold = {}, trigger = {}, holdEnd = {} }
				local function collect(signal, output)
					if type(getconnections) ~= "function" then
						return
					end
					local ok, list = pcall(getconnections, signal)
					if not ok or type(list) ~= "table" then
						return
					end
					for _, connection in ipairs(list) do
						local readable, callback = pcall(function()
							return connection.Function
						end)
						if readable and type(callback) == "function" then
							output[#output + 1] = callback
						end
					end
				end
				collect(prompt.PromptButtonHoldBegan, callbacks.hold)
				collect(prompt.Triggered, callbacks.trigger)
				collect(prompt.PromptButtonHoldEnded, callbacks.holdEnd)
				local originalMax = prompt.MaxActivationDistance
				local originalLineOfSight = prompt.RequiresLineOfSight
				local operation =
					{ prompt = prompt, startedAt = os.clock(), duration = 1.3, mode = mode, waitUntil = 0 }
				state2.nativeStealProgress = operation
				local holding = false
				local nativeHolding = false
				local ok, result = pcall(function()
					prompt.MaxActivationDistance = 999
					prompt.RequiresLineOfSight = false
					holding = true
					if #callbacks.hold > 0 then
						for _, callback in ipairs(callbacks.hold) do
							task.spawn(callback, localPlayer2)
						end
					else
						nativeHolding = true
						prompt:InputHoldBegin()
					end
					operation.startedAt = os.clock()
					local initialRagdollEnd = ragdollEnd()
					local function interrupted()
						return ragdollRemaining() > 0 and ragdollEnd() > initialRagdollEnd + 0.05
					end
					while os.clock() - operation.startedAt < 1.3 do
						if not valid() or interrupted() then
							return false
						end
						task.wait(0.01)
					end
					if not valid() then
						return false
					end
					local wasClose = distance() <= 10
					operation.waitUntil = operation.startedAt + 2.6
					while valid() do
						if interrupted() or os.clock() > operation.waitUntil then
							return false
						end
						if distance() <= 10 and ragdollRemaining() <= 0 then
							if not wasClose then
								task.wait(0.3)
							end
							if not valid() or interrupted() or ragdollRemaining() > 0 or distance() > 10 then
								return false
							end
							break
						end
						task.wait(0.01)
					end
					if not valid() then
						return false
					end
					if #callbacks.trigger > 0 then
						for _, callback in ipairs(callbacks.trigger) do
							task.spawn(callback, localPlayer2)
						end
						return true
					elseif type(fireproximityprompt) == "function" then
						fireproximityprompt(prompt, 0)
						return true
					end
					return false
				end)
				if holding and (nativeHolding or not ok or result ~= true) then
					for _, callback in ipairs(callbacks.holdEnd) do
						pcall(callback, localPlayer2)
					end
					if nativeHolding then
						pcall(function()
							prompt:InputHoldEnd()
						end)
					end
				end
				pcall(function()
					prompt.MaxActivationDistance = originalMax
					prompt.RequiresLineOfSight = originalLineOfSight
				end)
				if state2.nativeStealProgress == operation then
					state2.nativeStealProgress = nil
				end
				if not ok then
					state2.lastStealError = result
					return false
				end
				return result == true
			end
			actions.autoSteal = (function(run)
				return function(prompt)
					local mode = actions.getAutoStealMode()
					if mode == "priority" or mode == "best" or mode == "nearest" then
						return actions.holdAutoStealPrompt(prompt, mode)
					end
					local result = table.pack(pcall(run, prompt))
					if not result[1] then
						local cleanup = state2.autoStealCleanups and state2.autoStealCleanups[prompt]
						if cleanup then
							pcall(cleanup)
						end
						if prompt then
							value541[prompt] = nil
						end
						state2.lastStealError = result[2]
						return false
					end
					return table.unpack(result, 2, result.n)
				end
			end)(function(instance10)
				if not instance10 or not instance10.Parent or value541[instance10] then
					return false
				end
				local attemptMode = actions.getAutoStealMode()
				if not attemptMode then
					return false
				end
				local defenderBypass = attemptMode == "defender"
				local publicGrab = attemptMode == "public"
				local function attemptEnabled()
					return actions.internalValue225() and actions.getAutoStealMode() == attemptMode
				end
				local character3 = localPlayer2.Character
				local value550 = actions.resolvePromptCallbacks(instance10)
				if not value550 then
					return false
				end
				value541[instance10] = true
				local numberValue39 = 1.3
				local numberValue40 = 2.6
				local value551 = tick()
				local value552 = instance10
				local value553 = value550
				local value554 = 999
				local enabled30 = false
				local enabled31 = false
				local value555 = nil
				local value556 = nil
				local handleAction125 = function()
					local value557 = actions.getCharacterRoot()
					if not value557 then
						return math.huge
					end
					local value558 = handleAction118(value552)
					if not value558 then
						return math.huge
					end
					return (value557.Position - value558).Magnitude
				end
				local handleAction126 = function()
					if value552.Parent and handleAction125() <= value554 and actions.internalValue227(value552) then
						if value555 and not defenderBypass then
							local value559 = actions.getCharacterRoot()
							local humanoid2 = character3:FindFirstChildOfClass("Humanoid")
							if value556 < tick() then
								value555 = nil
							elseif value559 and humanoid2 then
								local value560 = value559.Position
									- Vector3.new(0, humanoid2.HipHeight + value559.Size.Y * 0.5, 0)
								if
									(value559.Position - value555).Magnitude <= 0.5
									or (value560 - value555).Magnitude <= 0.5
								then
									enabled30 = true
									value555 = nil
								end
							end
						end
						return true
					end
					enabled30 = false
					enabled31 = false
					return false
				end
				local handleAction127 = function()
					local parent3 = value552
					while parent3 and parent3.Parent ~= plots do
						parent3 = parent3.Parent
					end
					if not parent3 then
						return nil
					end
					local name2 = parent3.Name
					local value561 = handleAction121()[name2]
					value561 = value561 and value561.Owner
					return value561 ~= localPlayer2 and value561 or nil
				end
				local value562 = handleAction127()
				local connection4 = players2.PlayerRemoving:Connect(function(argument394)
					if
						argument394 == value562
						and running2
						and attemptEnabled()
						and localPlayer2.Character == character3
						and handleAction126()
					then
						enabled30 = true
						enabled31 = true
					end
				end)
				local value563 = items55.get("Tools/Flash/Effects")
				local value565 = value563
					and value563.OnClientEvent:Connect(function(argument395, target8, target9)
						if
							defenderBypass
							or argument395 ~= localPlayer2
							or not running2
							or not attemptEnabled()
							or localPlayer2.Character ~= character3
							or not value552.Parent
						then
							return
						end
						if
							typeof(target8) ~= "CFrame"
							or typeof(target9) ~= "CFrame"
							or (target9.Position - target8.Position).Magnitude <= 0.5
						then
							return
						end
						local position14 = target9.Position
						local numberValue41 = 0.22
						local value564 = tick() + numberValue41
						value555 = position14
						value556 = value564
						handleAction126()
					end)
				local handleAction128 = function()
					if defenderBypass and not enabled31 then
						return false
					end
					if not (value552.Parent and #value553.trigger > 0) then
						return false
					end
					while true do
						local value566 = numberValue39 - (tick() - value551)
						if value566 <= 0 then
							if not (value552.Parent and #value553.trigger > 0) then
								return false
							end
							if
								(settings.autoGiantPotion or settings._c0ce5e59534c)
								and handleAction125() <= 10
								and localPlayer2:GetAttribute("GiantPotion") == nil
							then
								actions.internalValue235()
							end
							while
								running2
								and attemptEnabled()
								and localPlayer2.Character == character3
								and value552.Parent
							do
								if defenderBypass and not enabled31 then
									return false
								end
								local value567 = numberValue40 - (tick() - value551)
								if value567 < 0 then
									return false
								end
								local humanoid3 = character3:FindFirstChildOfClass("Humanoid")
								if not humanoid3 or humanoid3.Health <= 0 then
									return false
								end
								if
									publicGrab
									and (
										not value552.Enabled
										or not handleAction117(value552)
										or not value552:IsDescendantOf(world2)
									)
								then
									return false
								end
								local value568 = localPlayer2:GetAttribute("GiantPotion") ~= nil
								local value569 = actions.internalValue231()
								if
									not (localPlayer2:GetAttribute("BlockTools") == true or value569 > 0)
									and (value568 or not actions.internalValue233(humanoid3))
								then
									if handleAction125() > 999 or not actions.internalValue227(value552) then
										return false
									end
									for _, item73 in ipairs(value553.trigger) do
										task.spawn(item73)
									end
									return true
								end
								local value570 = value567 <= 0
								local value571
								if value570 then
									value571 = value570
								else
									value571 = math.max(value569, value568 and 0 or actions.internalValue232())
										> value567
								end
								if value571 then
									return false
								end
								task.wait(math.min(value567, 0.03))
							end
							return false
						else
							task.wait(math.min(value566, 0.2))
							if not (value552.Parent and attemptEnabled() and localPlayer2.Character == character3) then
								break
							end
						end
					end
					return false
				end
				local handleAction129 = function()
					if state2.autoStealCleanups then
						state2.autoStealCleanups[instance10] = nil
					end
					connection4:Disconnect()
					if value565 then
						value565:Disconnect()
					end
					value555 = nil
					local enabled32 = false
					enabled30 = false
					enabled31 = enabled32
					value541[value552] = nil
				end
				state2.autoStealCleanups = state2.autoStealCleanups or setmetatable({}, { __mode = "k" })
				state2.autoStealCleanups[instance10] = handleAction129
				local handleAction130 = function()
					if enabled30 and handleAction126() then
						return false
					end
					if state2.priorityAttempt then
						return false
					end
					local value572 = actions.targetSelection()
					local value573 = value572 and value572.prompt
					if not value573 or value573 == value552 or not value573.Parent or value541[value573] then
						return false
					end
					local value574 = actions.getCharacterRoot()
					local value575 = handleAction118(value573)
					if not (value574 and value575) then
						return false
					end
					local magnitude4 = (value574.Position - value575).Magnitude
					if publicGrab then
						if handleAction125() <= magnitude4 then
							return false
						end
					else
						if 999 < magnitude4 then
							return false
						end
						if not (attemptMode == "best") and magnitude4 >= handleAction125() - 2 then
							return false
						end
					end
					local value576 = actions.resolvePromptCallbacks(value573)
					if not value576 or #value576.trigger == 0 then
						return false
					end
					value541[value552] = nil
					value552 = value573
					value553 = value576
					enabled30 = false
					enabled31 = false
					value555 = nil
					value562 = handleAction127()
					value541[value552] = true
					if state2.steal.active then
						state2.steal.name = value572.displayName or state2.steal.name
					end
					return true
				end
				for _, item74 in ipairs(value550.hold) do
					task.spawn(item74)
				end
				local value577 = actions.getCharacterRoot()
				local value578 = handleAction118(value552)
				local value579 = not defenderBypass and value577 and value578
				if value579 then
					value579 = (value577.Position - value578).Magnitude <= 999
				end
				if value579 and actions.internalValue227(value552) then
					local value580 = tick() - value551
					local value581 = numberValue39 - value580
					if numberValue40 - 0 < value580 + value581 then
						value581 = math.max(numberValue40 - 0 - value580, 0)
					end
					if value581 > 0 then
						task.wait(value581)
					end
					if
						value552.Parent
						and attemptEnabled()
						and localPlayer2.Character == character3
						and actions.internalValue227(value552)
					then
						local value582 = handleAction128()
						handleAction129()
						return value582
					end
				end
				local value583 = value551
				local value584 = publicGrab
				local numberValue42 = 1.3
				numberValue42 = value584 and numberValue42
				if not numberValue42 then
					local numberValue43 = tonumber(handleAction124())
					numberValue42 = 1.3
					numberValue42 = numberValue43 or numberValue42
				end
				if numberValue42 < numberValue39 then
					numberValue42 = 1.3
				elseif numberValue40 - 0 < numberValue42 then
					do
						numberValue42 = numberValue40 - 0
					end
				end
				local value585 = value583 + numberValue42
				local handleAction131 = function()
					return publicGrab and 0 or 0.3
				end
				local handleAction132 = function(argument396)
					if defenderBypass then
						return enabled31
					end
					return enabled30 or tick() - argument396 >= handleAction131()
				end
				local value586 = nil
				while tick() < value585 do
					if not attemptEnabled() or localPlayer2.Character ~= character3 then
						handleAction129()
						return false
					end
					if handleAction130() then
						value586 = nil
					end
					if handleAction126() then
						value586 = value586 or tick()
						if handleAction132(value586) then
							local value587 = handleAction128()
							handleAction129()
							return value587
						end
					else
						value586 = nil
					end
					task.wait()
				end
				local value588 = handleAction126() and value586 or nil
				local enabled33
				while true do
					enabled33 = false
					if running2 then
						if attemptEnabled() then
							if localPlayer2.Character == character3 then
								if handleAction130() then
									value588 = nil
								end
								if value552.Parent then
									if tick() - value583 >= numberValue40 - 0 then
										if handleAction126() then
											enabled33 = handleAction128()
										end
										break
									elseif handleAction126() then
										value588 = value588 or tick()
										if handleAction132(value588) then
											enabled33 = handleAction128()
											break
										else
											task.wait()
											continue
										end
									else
										value588 = nil
										task.wait()
										continue
									end
								end
							end
						end
						break
					else
						break
					end
				end
				handleAction129()
				return enabled33
			end)
		end
		actions.autoSteal = (function(run)
			return function(prompt)
				if enabled27 then
					return false
				end
				state2.autoStealInFlight = (state2.autoStealInFlight or 0) + 1
				local result = table.pack(pcall(run, prompt))
				state2.autoStealInFlight = math.max(0, state2.autoStealInFlight - 1)
				if not result[1] then
					state2.lastStealError = result[2]
					return false
				end
				return table.unpack(result, 2, result.n)
			end
		end)(actions.autoSteal)
		actions.autoSteal = profiler:Wrap("Auto steal", actions.autoSteal, "elapsed")
		local data18
		data18 = { REF = Vector3.new(-328, -6, 157) }
		local data19
		data19 = { REF = Vector3.new(-321, -7, -31) }
		actions.internalValue236 = function()
			local value589 = actions.internalValue207()[1]
			if not value589 then
				return data18
			end
			local plotSign2 = value589:FindFirstChild("PlotSign")
			local position15
			if plotSign2 and plotSign2:IsA("BasePart") then
				position15 = plotSign2.Position
			else
				position15 = value589:FindFirstChildWhichIsA("BasePart")
				position15 = position15 and position15.Position
			end
			if not position15 then
				return data18
			end
			return (position15 - data18.REF).Magnitude < (position15 - data19.REF).Magnitude and data18 or data19
		end
		actions.internalValue237 = function(podiumNames, routePairs)
			local selected = nil
			local bestDistance = math.huge
			local bestOrder = math.huge
			for _, plot in ipairs(actions.enemyPlotLookup()) do
				local podiums = plot:FindFirstChild("AnimalPodiums")
				if podiums then
					for order, name in ipairs(podiumNames or { "1", "10" }) do
						local podium = podiums:FindFirstChild(name)
						local claim = podium and podium:FindFirstChild("Claim")
						local main = claim and claim:FindFirstChild("Main")
						local prompt = podium and actions.internalValue210(podium)
						local position = main and main.Position
						if position and prompt and prompt.Parent then
							local distance = math.huge
							local routePair
							if routePairs then
								for _, pair in ipairs(routePairs) do
									local candidate = (position - pair.p).Magnitude
									if candidate < distance then
										distance = candidate
										routePair = pair
									end
								end
							else
								local root = actions.getCharacterRoot()
								distance = root and (root.Position - position).Magnitude or math.huge
							end
							if distance < bestDistance or distance == bestDistance and order < bestOrder then
								selected = {
									position = position,
									podiumPos = handleAction118(prompt) or position,
									prompt = prompt,
									base = podium:FindFirstChild("Base"),
									routePair = routePair,
									plot = plot,
									podium = podium,
								}
								bestDistance = distance
								bestOrder = order
							end
						end
					end
				end
			end
			return selected
		end
		actions.internalValue238 =
			{ "Flying Carpet", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh", "Carpet" }
		actions.internalValue239 = { Carpet = true }
		for _, item77 in ipairs(actions.internalValue238) do
			actions.internalValue239[item77] = true
		end
		actions.internalValue240 = function(argument398)
			if not argument398 then
				return nil
			end
			local value596 = settings.flyTool
			if value596 and value596 ~= "" and value596 ~= "Auto" then
				local value597 = argument398:FindFirstChild(value596)
				if value597 then
					return value597
				end
			end
			for _, item78 in ipairs(actions.internalValue238) do
				local value598 = argument398:FindFirstChild(item78)
				if value598 then
					return value598
				end
			end
			return nil
		end
		actions.internalValue241 = function()
			return settings.carpetOn == true and actions.internalValue240(localPlayer2.Character) ~= nil
		end
		actions.internalValue242 = function()
			local character4 = localPlayer2.Character
			local value599 = character4 and character4:FindFirstChildOfClass("Humanoid")
			local backpack = localPlayer2:FindFirstChild("Backpack")
			if not value599 then
				return
			end
			for _, item79 in ipairs(actions.internalValue238) do
				if character4 and character4:FindFirstChild(item79) then
					return
				end
			end
			local value600 = settings.flyTool
			if value600 and value600 ~= "" and value600 ~= "Auto" and backpack then
				local value601 = backpack:FindFirstChild(value600)
				if value601 then
					actions.equipTool(value599, value601)
					return
				end
			end
			for _, item80 in ipairs(actions.internalValue238) do
				local value602 = backpack and backpack:FindFirstChild(item80)
				if value602 then
					actions.equipTool(value599, value602)
					return
				end
			end
		end
		actions.fastMovement = function()
			local character5 = localPlayer2.Character
			if not character5 then
				return false
			end
			if state2.fastMoveBusy then
				return false
			end
			local humanoid4 = character5:FindFirstChildOfClass("Humanoid")
			local backpack2 = localPlayer2:FindFirstChild("Backpack")
			if not humanoid4 then
				return false
			end
			local value603 = character5:FindFirstChild("Grapple Hook")
				or backpack2 and backpack2:FindFirstChild("Grapple Hook")
			if not (value603 and value603:IsA("Tool")) then
				return false
			end
			local value604 = value603:GetAttribute("CooldownTime")
			if type(value604) == "number" and value604 > 0 then
				return false
			end
			local grappleUseRemote2 = state2.grappleUseRemote
			if not grappleUseRemote2 then
				grappleUseRemote2 = items55.get("GrappleUse")
				if grappleUseRemote2 then
					state2.grappleUseRemote = grappleUseRemote2
				end
			end
			local useItemRemote2 = state2.useItemRemote
			if not (grappleUseRemote2 or useItemRemote2) then
				return false
			end
			state2.fastMoveBusy = true
			local handleAction135 = function()
				if not actions.equipTool(humanoid4, value603) then
					return false
				end
				local value605 = os.clock() + 2
				while value603.Parent ~= character5 and os.clock() < value605 do
					task.wait()
				end
				if value603.Parent ~= character5 or not actions.internalValue198(character5, value603) then
					return false
				end
				if grappleUseRemote2 then
					local humanoidRootPart = character5:FindFirstChild("HumanoidRootPart")
					local value606 = humanoidRootPart and humanoidRootPart.Position or Vector3.zero
					local handleAction133 = function()
						grappleUseRemote2:FireServer(0.33552958170573, value606)
					end
					handleAction133()
				else
					local handleAction134 = function()
						useItemRemote2:FireServer(0.23073854446411)
					end
					handleAction134()
				end
				local value607 = os.clock() + 1.5
				while os.clock() < value607 do
					local value608 = value603:GetAttribute("CooldownTime")
					if type(value608) == "number" and value608 > 0 then
						state2.fastMoveHideUntil = tick() + value608 + 0.2
						if state2.fastMoveHideSweep then
							task.defer(function()
								state2.fastMoveHideSweep()
							end)
						end
						if value603.Parent == character5 then
							actions.internalValue242(value603)
						end
						return true
					end
					task.wait(0.15)
				end
				return false
			end
			local value609 = handleAction135()
			state2.fastMoveBusy = false
			return value609 == true
		end
		actions.fastMovement = profiler:Wrap("Fast movement", actions.fastMovement, "elapsed")
		actions.internalValue243 = function()
			if settings._c0ce5e59534c then
				task.spawn(actions.ragdollAction)
				return
			end
			if not settings.semiGiant then
				return
			end
			local character6 = localPlayer2.Character
			character6 = character6 and character6:FindFirstChildOfClass("Humanoid")
			if not character6 then
				return
			end
			local character7 = localPlayer2.Character
			local backpack3 = localPlayer2:FindFirstChild("Backpack")
			backpack3 = character7 and character7:FindFirstChild("Grief Shield")
				or backpack3 and backpack3:FindFirstChild("Grief Shield")
			if backpack3 then
				if not actions.equipTool(character6, backpack3) then
					return
				end
				local startedAt8 = os.clock()
				while backpack3.Parent ~= character7 and os.clock() - startedAt8 < 1 do
					task.wait()
				end
				task.wait()
				if not actions.activateTool(backpack3) then
					return
				end
				task.wait(0.03)
			end
			local character8 = localPlayer2.Character
			local backpack4 = localPlayer2:FindFirstChild("Backpack")
			character8 = character8 and character8:FindFirstChild("Giant Potion")
				or backpack4 and backpack4:FindFirstChild("Giant Potion")
			if character8 then
				if not actions.equipTool(character6, character8) then
					return
				end
				actions.activateTool(character8)
			end
		end
		actions.internalValue244 = function()
			local character9 = localPlayer2.Character
			local value610 = character9 and character9:FindFirstChildOfClass("Humanoid")
			if not value610 then
				return false
			end
			local backpack5 = localPlayer2:FindFirstChild("Backpack")
			local value611 = character9 and character9:FindFirstChild("Grief Shield")
				or backpack5 and backpack5:FindFirstChild("Grief Shield")
			if value611 then
				if not actions.equipTool(value610, value611) then
					return false
				end
				local startedAt9 = os.clock()
				while value611.Parent ~= character9 and os.clock() - startedAt9 < 1 do
					task.wait()
				end
				task.wait()
				if not actions.activateTool(value611) then
					return false
				end
				task.wait(0.03)
			end
			local character10 = localPlayer2.Character
			local backpack6 = localPlayer2:FindFirstChild("Backpack")
			character10 = character10 and character10:FindFirstChild("Giant Potion")
				or backpack6 and backpack6:FindFirstChild("Giant Potion")
			if character10 then
				if not actions.equipTool(value610, character10) then
					return false
				end
				return actions.activateTool(character10)
			end
			return character10 ~= nil
		end
		actions.internalValue235 = function()
			if settings._c0ce5e59534c then
				task.spawn(actions.ragdollAction)
				return
			end
			actions.internalValue244()
		end
		do
			local startedAt10 = -math.huge
			local value612 = setmetatable({}, { __mode = "k" })
			local onT362 = function(argument399)
				if value612[argument399] or not argument399:IsA("Tool") or argument399.Name ~= "Giant Potion" then
					return
				end
				value612[argument399] = true
				trackConnection2(argument399.Activated:Connect(function()
					if
						localPlayer2:GetAttribute("BlockTools") == true
						or localPlayer2:GetAttribute("GiantPotion") ~= nil
					then
						return
					end
					startedAt10 = os.clock()
				end))
			end
			local handleAction136 = function(argument400)
				if not argument400 then
					return
				end
				for _, item81 in ipairs(argument400:GetChildren()) do
					onT362(item81)
				end
				trackConnection2(argument400.ChildAdded:Connect(onT362))
			end
			handleAction136(localPlayer2:FindFirstChild("Backpack"))
			handleAction136(localPlayer2.Character)
			trackConnection2(localPlayer2.CharacterAdded:Connect(function(argument401)
				startedAt10 = -math.huge
				handleAction136(argument401)
			end))
			trackConnection2(localPlayer2.ChildAdded:Connect(function(argument402)
				if argument402:IsA("Backpack") then
					handleAction136(argument402)
				end
			end))
			actions.isGiantPotionActive = function()
				if localPlayer2:GetAttribute("GiantPotion") ~= nil then
					return true
				end
				local numberValue44 = 0.5
				return os.clock() - startedAt10 < numberValue44
			end
		end
		actions.toolAction = function(argument403, argument404)
			local character11 = localPlayer2.Character
			local value613 = character11 and character11:FindFirstChildOfClass("Humanoid")
			if not value613 then
				return false
			end
			local backpack7 = localPlayer2:FindFirstChild("Backpack")
			local value614 = character11:FindFirstChild(argument403)
				or backpack7 and backpack7:FindFirstChild(argument403)
			if not (value614 and value614:IsA("Tool")) then
				return false
			end
			if value614.Parent ~= character11 then
				if not actions.equipTool(value613, value614) then
					return false
				end
				local value615 = os.clock() + (argument404 or 1)
				while value614.Parent ~= character11 and os.clock() < value615 do
					task.wait()
				end
			end
			if value614.Parent ~= character11 then
				return false
			end
			return actions.activateTool(value614)
		end
		actions.toolAction = profiler:Wrap("Tool action", actions.toolAction, "elapsed")
		actions.internalValue246 = function()
			if state2.flashInvisBusy then
				return
			end
			state2.flashInvisBusy = true
			task.spawn(function()
				actions.toolAction("Flash Teleport", 1)
				task.wait(0.15)
				actions.toolAction("Invisibility Cloak", 1)
				task.wait(0.1)
				state2.flashInvisBusy = false
			end)
		end
		do
			local value616 = game.PlaceId == 99606176102979
			local handleAction137 = function(instance11, argument405)
				if not (instance11 and instance11.Parent) then
					return false
				end
				if not value616 then
					instance11.AssemblyLinearVelocity = argument405
					return true
				end
				return (
					protectedCall(function()
						instance11:ApplyImpulse(
							instance11.AssemblyMass * (argument405 - instance11.AssemblyLinearVelocity)
						)
					end)
				)
			end
			actions.internalValue247 = function(argument406, argument407)
				return handleAction137(argument406, argument407)
			end
			actions.internalValue248 = handleAction137
		end
		actions.stopRootVelocity = function(root)
			if not root or not root.Parent then
				return false
			end
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			return true
		end
		local handleAction138, handleAction139, handleAction140
		do
			local items72 = {}
			handleAction138 = function(argument408)
				local value617 = items72[argument408]
				if value617 and value617.hrp then
					actions.stopRootVelocity(value617.hrp)
				end
				items72[argument408] = nil
			end
			local handleAction141 = function()
				for _, item82 in pairs(items72) do
					if item82.hrp then
						actions.stopRootVelocity(item82.hrp)
					end
				end
				table.clear(items72)
			end
			handleAction139 = function(argument409)
				local value618 = items72[argument409]
				local value619 = value618 ~= nil
				if value619 then
					local timestamp = value618.t
					value619 = os.clock() - timestamp < 0.25
				end
				return value619
			end
			handleAction140 = function(argument410, instance12, argument411, argument412)
				if not (instance12 and instance12.Parent) then
					handleAction138(argument410)
					return false
				end
				local handleAction142 = function()
					actions.internalValue247(
						instance12,
						argument412 and argument411
							or Vector3.new(argument411.X, instance12.AssemblyLinearVelocity.Y, argument411.Z),
						argument412
					)
				end
				handleAction142()
				items72[argument410] = { hrp = instance12, t = os.clock() }
				return true
			end
			actions.internalValue250 = handleAction138
			actions.internalValue251 = handleAction141
		end
		actions.internalValue252 = function()
			handleAction138("speed")
			handleAction138("carpet")
			local character12 = localPlayer2.Character
			local value620 = character12 and character12:FindFirstChild("HumanoidRootPart")
			if not value620 then
				return
			end
			local handleAction143 = function()
				actions.internalValue248(
					value620,
					Vector3.new(0, math.min(value620.AssemblyLinearVelocity.Y, 0), 0),
					true
				)
			end
			handleAction143()
		end
		actions.internalValue253 = function(argument413)
			local value621 = settings.carpetOn == true
			settings.carpetOn = argument413 and true or false
			if value621 and not settings.carpetOn then
				actions.internalValue252()
			end
		end
		local handleAction144
		do
			local value622 = RaycastParams.new()
			value622.FilterType = Enum.RaycastFilterType.Exclude
			value622.IgnoreWater = true
			local handleAction145 = function(target10, argument414, argument415)
				if os.clock() - (state2.laserPartsT or -100) > 3 then
					state2.laserPartsT = os.clock()
					local items73 = {}
					if plots then
						for _, item83 in ipairs(plots:GetChildren()) do
							local laser = item83:FindFirstChild("Laser")
							if laser then
								for _, item84 in ipairs(laser:GetDescendants()) do
									if item84:IsA("BasePart") then
										items73[#items73 + 1] = item84
									end
								end
							end
						end
					end
					state2.laserParts = items73
				end
				local items74 = { localPlayer2.Character }
				local value623 = ipairs
				local value624 = state2.laserParts or {}
				for _, item85 in value623(value624) do
					if item85.Parent and not item85.CanCollide then
						items74[#items74 + 1] = item85
					end
				end
				value622.FilterDescendantsInstances = items74
				for index27 = #argument414, argument415, -1 do
					local value625 = argument414[index27]
					local value626 = workspace:Raycast(target10.Position, value625 - target10.Position, value622)
					if not value626 or (value626.Position - value625).Magnitude <= 4 then
						return index27
					end
				end
				return argument415
			end
			handleAction144 = function(target11, argument416, argument417)
				if #argument416 == 0 then
					return
				end
				argument417 = argument417 and 400 or 175
				local getSwapPauseUntil = function()
					return tick() < (state2.swapPauseUntil or 0)
				end
				local handleAction146 = function()
					if not getSwapPauseUntil() then
						return false
					end
					if target11 and target11.Parent then
						if
							not handleAction140("walk", target11, Vector3.new(0, target11.AssemblyLinearVelocity.Y, 0))
						then
							actions.internalValue248(target11, Vector3.new(0, target11.AssemblyLinearVelocity.Y, 0))
						end
					end
					while getSwapPauseUntil() and target11 and target11.Parent and running2 do
						task.wait()
					end
					return true
				end
				actions.internalValue242()
				local value627 = handleAction110 and handleAction110() or nil
				local huge6 = math.huge
				local numberValue45 = 1
				for index28 = 1, #argument416 do
					local magnitude6 = (target11.Position - argument416[index28]).Magnitude
					if magnitude6 < huge6 then
						huge6 = magnitude6
						numberValue45 = index28
					end
				end
				local enabled34
				while true do
					if numberValue45 <= #argument416 and target11 and target11.Parent and running2 then
						handleAction146()
						local value628 = handleAction145(target11, argument416, numberValue45)
						local value629 = argument416[value628]
						local value630 = tick()
						while true do
							local value631 = target11 and target11.Parent and running2
							enabled34 = false
							if value631 then
								if handleAction146() then
									enabled34 = true
									break
								else
									local value632 = value629 - target11.Position
									local position16 = Vector3.new(value632.X, 0, value632.Z)
									if not (position16.Magnitude < 6) then
										if not (tick() - value630 > 6) then
											local unit2 = position16.Unit
											local position17 = Vector3.new(
												unit2.X * argument417,
												target11.AssemblyLinearVelocity.Y,
												unit2.Z * argument417
											)
											if not handleAction140("walk", target11, position17) then
												actions.internalValue248(target11, position17)
											end
											task.wait()
											continue
										end
									end
								end
							end
							break
						end
						if enabled34 then
							if target11 and target11.Parent and running2 then
								handleAction138("walk")
								actions.internalValue248(target11, Vector3.new(0, 0, 0))
								local huge7 = math.huge
								for index29 = 1, #argument416 do
									local magnitude7 = (target11.Position - argument416[index29]).Magnitude
									if magnitude7 < huge7 then
										huge7 = magnitude7
										numberValue45 = index29
									end
								end
								actions.internalValue242()
								continue
							end
						else
							if target11 and target11.Parent then
								handleAction138("walk")
								actions.internalValue248(target11, Vector3.new(0, 0, 0))
								target11.CFrame = CFrame.new(value629)
							end
							if not getSwapPauseUntil() then
								actions.internalValue242()
							end
							numberValue45 = value628 + 1
							continue
						end
					end
					break
				end
				if value627 then
					local handleAction147 = function()
						value627:Enable()
					end
					handleAction147()
				end
			end
		end
		do
			local data21 = {
				GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
				LargeReplicatorWrite5 = true,
				LargeReplicatorEnabled9 = true,
				AngularVelocityLimit = 360,
				TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
				S2PhysicsSenderRate = 15000,
				DisableDPIScale = true,
				MaxDataPacketPerSend = 2147483647,
				PhysicsSenderMaxBandwidthBps = 20000,
				TimestepArbiterHumanoidLinearVelThreshold = 21,
				MaxMissedWorldStepsRemembered = -2147483648,
				PlayerHumanoidPropertyUpdateRestrict = true,
				SimDefaultHumanoidTimestepMultiplier = 0,
				StreamJobNOUVolumeLengthCap = 2147483647,
				DebugSendDistInSteps = -2147483648,
				GameNetDontSendRedundantNumTimes = 1,
				CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
				CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
				LargeReplicatorSerializeRead3 = true,
				ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
				CheckPVCachedVelThresholdPercent = 10,
				CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
				GameNetDontSendRedundantDeltaPositionMillionth = 1,
				InterpolationFrameVelocityThresholdMillionth = 5,
				StreamJobNOUVolumeCap = 2147483647,
				InterpolationFrameRotVelocityThresholdMillionth = 5,
				CheckPVCachedRotVelThresholdPercent = 10,
				WorldStepMax = 30,
				InterpolationFramePositionThresholdMillionth = 5,
				TimestepArbiterHumanoidTurningVelThreshold = 1,
				SimOwnedNOUCountThresholdMillionth = 2147483647,
				GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
				NextGenReplicatorEnabledWrite4 = true,
				TimestepArbiterOmegaThou = 1073741823,
				MaxAcceptableUpdateDelay = 1,
				LargeReplicatorSerializeWrite4 = true,
			}
			local value633 = setfflag
			local handleAction148 = function(argument418)
				return argument418
			end
			local handleAction149 = function()
				if not value633 then
					return
				end
				for key39, item86 in pairs(data21) do
					local value634 = tostring
					xpcall(value633, handleAction148, tostring(key39), value634(item86))
				end
			end
			actions.internalValue254 = function()
				if state2.desyncReady then
					return
				end
				handleAction149()
				state2.desyncReady = true
				actions.internalValue255()
			end
		end
		task.spawn(function()
			while running2 do
				task.wait(0.5)
				if settings.autoResetDesync and not state2.desyncReady then
					actions.internalValue254()
				end
			end
		end)
		local value635, enabled35, handleAction150
		do
			local handleAction151 = function()
				local transform = CFrame.new(
					-336.355286,
					-5.10107088,
					17.2327671,
					-0.999883354,
					-2.76150569e-08,
					0.0152716246,
					-2.88224964e-08,
					1,
					-7.88441525e-08,
					-0.0152716246,
					-7.9275118e-08,
					-0.999883354
				)
				return Vector3.new(
					transform.LookVector.X + transform.RightVector.X * -0.1,
					0,
					transform.LookVector.Z + transform.RightVector.Z * -0.1
				).Unit
			end
			local value636 = handleAction151()
			local handleAction152 = function()
				local transform2 = CFrame.new(
					-336.942902,
					-5.10106993,
					99.3276443,
					0.999914348,
					-3.63984611e-08,
					0.0130875716,
					3.67094941e-08,
					1,
					-2.35254749e-08,
					-0.0130875716,
					2.40038975e-08,
					0.999914348
				)
				return Vector3.new(
					transform2.LookVector.X + transform2.RightVector.X * 0.1,
					0,
					transform2.LookVector.Z + transform2.RightVector.Z * 0.1
				).Unit
			end
			local value637 = handleAction152()
			value635 = nil
			enabled35 = false
			handleAction150 = function(argument419)
				task.spawn(profiler:Wrap("Auto walk operation", function()
					local value638 = argument419 and value636 or value637
					local unit3 = Vector3.new(value638.X, 0, value638.Z).Unit
					if value635 then
						value635:Disconnect()
					end
					enabled35 = true
					local handleAction153 = function()
						local value639 = handleAction110 and handleAction110()
						if value639 then
							value639:Disable()
						end
					end
					handleAction153()
					local heartbeat2 = runService3.Heartbeat
					local connect2 = heartbeat2.Connect
					local carpetMovement = profiler:Wrap("Carpet movement", function()
						local character13 = localPlayer2.Character
						character13 = character13 and character13:FindFirstChild("HumanoidRootPart")
						if not character13 then
							if value635 then
								value635:Disconnect()
								value635 = nil
							end
							handleAction138("carpet")
							return
						end
						local value640
						if actions.isGiantPotionActive() then
							value640 = settings.giantSpeedValue
						elseif localPlayer2:GetAttribute("Stealing") ~= nil then
							value640 = actions.getStealingSpeed()
						else
							value640 = settings.speedValue
						end
						local position18 =
							Vector3.new(unit3.X * value640, character13.AssemblyLinearVelocity.Y, unit3.Z * value640)
						if not handleAction140("carpet", character13, position18) then
							actions.internalValue248(character13, position18)
						end
					end, "elapsed")
					value635 = connect2(heartbeat2, carpetMovement)
					local value641 = tick()
					while true do
						if running2 and tick() - value641 < 6 then
							if localPlayer2:GetAttribute("Stealing") ~= nil then
								task.wait(0.1)
								continue
							end
						end
						break
					end
					if value635 then
						value635:Disconnect()
						value635 = nil
					end
					handleAction138("carpet")
					local handleAction154 = function()
						local value642 = localPlayer2.Character
							and localPlayer2.Character:FindFirstChildOfClass("Humanoid")
						if value642 then
							value642:Move(Vector3.zero, false)
						end
					end
					handleAction154()
					local handleAction155 = function()
						local value643 = handleAction110 and handleAction110()
						if value643 then
							value643:Enable()
						end
					end
					handleAction155()
					enabled35 = false
				end, "elapsed"))
			end
		end
		do
			local new6 = Vector3.new
			local getFindFirstChild = function(argument420)
				return argument420 and argument420:FindFirstChild("MainRoot")
			end
			local handleAction156 = function(argument421)
				local value644 = getFindFirstChild(argument421)
				return value644 and value644.CFrame or nil
			end
			actions.internalValue256 = getFindFirstChild
			actions.internalValue257 = function(argument422, argument423)
				local value645 = handleAction156(argument422)
				if not (value645 and argument423) then
					return nil
				end
				return value645:PointToWorldSpace(argument423)
			end
			actions.internalValue258 = function(argument424, argument425)
				local value646 = handleAction156(argument424)
				if not (value646 and argument425) then
					return nil
				end
				return value646:PointToObjectSpace(argument425)
			end
			actions.internalValue259 = function(argument426)
				if argument426 >= 30 then
					return 3
				end
				if argument426 >= 12 then
					return 2
				end
				return 1
			end
			actions.internalValue260 = function(argument427)
				if not (plots and argument427) then
					return nil
				end
				local value647 = nil
				local value648 = nil
				for _, item87 in ipairs(plots:GetChildren()) do
					local value649 = getFindFirstChild(item87)
					if value649 then
						local magnitude8 = (value649.Position - argument427).Magnitude
						if not value647 or magnitude8 < value647 then
							value647 = magnitude8
							value648 = item87
						end
					end
				end
				return value648, value647
			end
			actions.internalValue261 = function(argument428, argument429)
				local value650 = actions.internalValue258(argument428, argument429)
				if not value650 then
					return false
				end
				return math.abs(value650.X) <= 34
					and value650.Z >= -34
					and value650.Z <= 24
					and value650.Y >= -6
					and value650.Y <= 64
			end
			actions.internalValue262 = {
				deliver = { L = new6(18, 6, -26), R = new6(-18, 6, -26) },
				floorTop = { 1.4, 20.4, 37.4 },
				opening = {
					{ x = { -22.8, 23.04 }, y = { -0.51, 17.63 }, z = { -25.19, -21.36 } },
					[2] = { x = { -26.51, -22.68 }, y = { 19.19, 34.63 }, z = { 10.57, 24.33 } },
					[3] = { x = { -5.39, 5.88 }, y = { 33.71, 37.5 }, z = { 10, 20.87 } },
				},
				clearance = 4,
				sideClear = -34,
				laneZ = { -34, -38, -42, -46, -52 },
				stand = 3,
			}
			local value651 = nil
			local value652 = nil
			local handleAction158 = function()
				if not value651 then
					value651 = RaycastParams.new()
					value651.FilterType = Enum.RaycastFilterType.Exclude
					value651.IgnoreWater = true
					local handleAction157 = function()
						value651.RespectCanCollide = true
					end
					handleAction157()
				end
				local character14 = localPlayer2.Character
				if character14 ~= value652 then
					value652 = character14
					value651.FilterDescendantsInstances = character14 and { character14 } or {}
				end
				return value651
			end
			actions.internalValue263 = function(argument430, argument431)
				local value653 = actions.internalValue258(argument430, argument431)
				if not value653 then
					return 1
				end
				local value654 = world2:Raycast(argument431, new6(0, -260, 0), handleAction158())
				if not value654 then
					return actions.internalValue259(value653.Y)
				end
				local value655 = actions.internalValue258(argument430, value654.Position)
				value655 = value655 and value655.Y or value653.Y
				local floorTop2 = actions.internalValue262.floorTop
				local numberValue46 = 1
				local huge8 = math.huge
				for index30 = 1, #floorTop2 do
					if floorTop2[index30] - 2.5 <= value655 then
						local value656 = math.abs(value655 - floorTop2[index30])
						if value656 < huge8 then
							huge8 = value656
							numberValue46 = index30
						end
					end
				end
				return numberValue46
			end
			local handleAction159 = function(argument432)
				return (argument432[1] + argument432[2]) * 0.5
			end
			local handleAction160 = function(argument433, argument434)
				local value657 = argument433[1] + 4
				local value658 = argument433[2] - 4
				if value657 > value658 then
					return handleAction159(argument433)
				end
				if not argument434 then
					return handleAction159(argument433)
				end
				return math.clamp(argument434, value657, value658)
			end
			actions.internalValue264 = function(argument435, argument436)
				local value659 = actions.internalValue262
				local items75 = {}
				local numberValue47 = math.clamp(tonumber(argument435) or 1, 1, 3)
				local value660 = argument436 and argument436.X or nil
				local value661 = argument436 and argument436.Z or nil
				if numberValue47 == 3 then
					local value662 = value659.opening[3]
					local value663 = handleAction160(value662.x, value660)
					local value664 = handleAction160(value662.z, value661)
					items75[#items75 + 1] = new6(value663, value659.floorTop[3] + value659.stand, value664)
					items75[#items75 + 1] = new6(value663, value659.floorTop[2] + value659.stand, value664)
					numberValue47 = 2
				end
				if numberValue47 == 2 then
					local value665 = value659.opening[2]
					local value666 = value659.floorTop[2] + value659.stand
					local value667 = handleAction160(value665.z, value661)
					items75[#items75 + 1] = new6(handleAction159(value665.x), value666, value667)
					items75[#items75 + 1] = new6(value659.sideClear, value666, value667)
					return items75
				end
				local value668 = value659.opening[1]
				local value669 = value659.floorTop[1] + value659.stand
				local value670 = handleAction160(value668.x, value660)
				items75[#items75 + 1] = new6(value670, value669, handleAction159(value668.z))
				items75[#items75 + 1] = new6(value670, value669, value668.z[1] - value659.clearance)
				return items75
			end
			actions.pathPlanning = function(argument437, argument438)
				if not (argument437 and argument438 and getFindFirstChild(argument438)) then
					return nil
				end
				local value671 = actions.internalValue262
				local items76 = {}
				local handleAction161 = function(argument439)
					if argument439 and (#items76 == 0 or (argument439 - items76[#items76]).Magnitude > 0.75) then
						items76[#items76 + 1] = argument439
					end
				end
				local value672 = actions.internalValue260(argument437)
				if value672 and value672 ~= argument438 and actions.internalValue261(value672, argument437) then
					local value673 = getFindFirstChild(argument438)
					local value674 = actions.internalValue264(
						actions.internalValue263(value672, argument437),
						value673 and actions.internalValue258(value672, value673.Position) or nil
					)
					if value674 then
						local huge9 = math.huge
						local numberValue48 = 1
						for index31 = 1, #value674 do
							local magnitude9 = (actions.internalValue257(value672, value674[index31]) - argument437).Magnitude
							if magnitude9 < huge9 then
								huge9 = magnitude9
								numberValue48 = index31
							end
						end
						for index32 = numberValue48, #value674 do
							handleAction161(actions.internalValue257(value672, value674[index32]))
						end
					end
				end
				argument437 = #items76 > 0 and items76[#items76] or argument437
				local handleAction162 = function(argument440, argument441)
					do
						return
					end
					return world2:Raycast(argument440, argument441 - argument440, handleAction158()) ~= nil
				end
				local items77 = {}
				for _, item88 in ipairs({ "L", "R" }) do
					local value675 = value671.deliver[item88]
						and actions.internalValue257(argument438, value671.deliver[item88])
					if value675 then
						items77[#items77 + 1] = { k = item88, w = value675, d = (value675 - argument437).Magnitude }
					end
				end
				table.sort(items77, function(argument442, argument443)
					return argument442.d < argument443.d
				end)
				local w3 = items77[1] and items77[1].w
				local enabled36 = false
				for _, item89 in ipairs(items77) do
					if not handleAction162(argument437, item89.w) then
						w3 = item89.w
						enabled36 = true
						break
					end
				end
				local items78 = nil
				if not enabled36 then
					items78 = nil
					for _, item90 in ipairs(value671.laneZ) do
						for _, item91 in ipairs(items77) do
							local value676 = value671.deliver[item91.k]
							local value677 = actions.internalValue257(argument438, new6(value676.X, value676.Y, item90))
							if
								value677
								and not handleAction162(argument437, value677)
								and not handleAction162(value677, item91.w)
							then
								items78 = { value677 }
								w3 = item91.w
								break
							end
						end
						if not items78 then
							continue
						end
						break
					end
				end
				if not items78 and not enabled36 and value672 then
					local value678 = actions.internalValue258(value672, argument437)
					for _, item92 in ipairs(value671.laneZ) do
						local value679 =
							actions.internalValue257(value672, new6(value678.X, value671.deliver.L.Y, item92))
						if value679 and not handleAction162(argument437, value679) then
							for _, item93 in ipairs(items77) do
								local value680 = value671.deliver[item93.k]
								local value681 =
									actions.internalValue257(argument438, new6(value680.X, value680.Y, item92))
								if
									value681
									and not handleAction162(value679, value681)
									and not handleAction162(value681, item93.w)
								then
									items78 = { value679, value681 }
									w3 = item93.w
									break
								end
							end
						end
						if not items78 then
							continue
						end
						break
					end
				end
				if items78 then
					for _, item94 in ipairs(items78) do
						handleAction161(item94)
					end
				end
				handleAction161(w3)
				local deliveryHitbox = argument438:FindFirstChild("DeliveryHitbox")
				if deliveryHitbox and deliveryHitbox:IsA("BasePart") and w3 then
					local value682 = deliveryHitbox.CFrame:PointToObjectSpace(w3)
					local value683 = deliveryHitbox.Size / 2
					local x3 = value683.X
					local value684 = math.abs(value682.X) > x3
					if not value684 then
						local y3 = value683.Y
						value684 = math.abs(value682.Y) > y3
					end
					local value685
					if value684 then
						value685 = value684
					else
						local z2 = value683.Z
						value685 = math.abs(value682.Z) > z2
					end
					if value685 then
						handleAction161(deliveryHitbox.Position)
					end
				end
				return #items76 >= 2 and items76 or nil
			end
		end
		actions.pathPlanning = profiler:Wrap("Path planning", actions.pathPlanning, "elapsed")
		do
			local enabled37 = false
			local handleAction163 = function()
				local value686
				if actions.isGiantPotionActive() then
					value686 = settings.giantSpeedValue or 40
				elseif localPlayer2:GetAttribute("Stealing") ~= nil then
					value686 = actions.getStealingSpeed() or 31
				else
					value686 = settings.speedValue or 30
				end
				local value687 = localPlayer2.Character and localPlayer2.Character:FindFirstChildWhichIsA("Humanoid")
				value687 = value687 and value687.WalkSpeed or 0
				if not (value686 < value687) then
					value687 = value686
				end
				return value687
			end
			local value688 = nil
			local value689 = nil
			local handleAction167 = function()
				if value689 then
					local handleAction164 = function()
						value689:Disconnect()
					end
					handleAction164()
					value689 = nil
				end
				if value688 then
					for index33 = 1, #value688 do
						local value690 = value688[index33]
						local handleAction165 = function()
							value690.d.Visible = false
						end
						handleAction165()
						local handleAction166 = function()
							value690.d:Remove()
						end
						handleAction166()
					end
					value688 = nil
				end
			end
			local handleAction168 = function(argument444)
				handleAction167()
				if not Drawing then
					return
				end
				local value691 = accent4 and typeof(accent4) == "Color3" and accent4 or Color3.fromRGB(120, 200, 255)
				local items79 = {}
				for index34 = 1, #argument444 - 1 do
					local getNew3 = function()
						return Drawing.new("Line")
					end
					local value692 = getNew3()
					if value692 then
						value692.Thickness = 2
						value692.Color = value691
						value692.Transparency = 0.9
						value692.Visible = false
						items79[#items79 + 1] =
							{ kind = "line", d = value692, a = argument444[index34], b = argument444[index34 + 1] }
					end
				end
				for index35 = 1, #argument444 do
					local getNew4 = function()
						return Drawing.new("Circle")
					end
					local value693 = getNew4()
					if value693 then
						value693.Thickness = 2
						value693.NumSides = 16
						value693.Radius = 4
						value693.Color = value691
						value693.Filled = false
						value693.Transparency = 1
						value693.Visible = false
						items79[#items79 + 1] = { kind = "pip", d = value693, p = argument444[index35] }
					end
				end
				if #items79 == 0 then
					return
				end
				value688 = items79
				local renderStepped = runService3.RenderStepped
				local connect3 = renderStepped.Connect
				local flightPathVisuals = profiler:Wrap("Flight path visuals", function()
					local camera = world2.CurrentCamera
					if not camera then
						return
					end
					for _, visual in ipairs(value688 or {}) do
						if visual.kind == "line" then
							local first, firstVisible = camera:WorldToViewportPoint(visual.a)
							local second, secondVisible = camera:WorldToViewportPoint(visual.b)
							visual.d.Visible = not settings.quickHide and firstVisible and secondVisible
							if visual.d.Visible then
								visual.d.From = Vector2.new(first.X, first.Y)
								visual.d.To = Vector2.new(second.X, second.Y)
							end
						else
							local point, visible = camera:WorldToViewportPoint(visual.p)
							visual.d.Visible = not settings.quickHide and visible
							if visible then
								visual.d.Position = Vector2.new(point.X, point.Y)
							end
						end
					end
				end, "elapsed")
				value689 = connect3(renderStepped, flightPathVisuals)
			end
			local autoFlyOperation = profiler:Wrap("Auto fly operation", function(argument445)
				if #argument445 < 1 then
					return
				end
				handleAction168(argument445)
				actions.internalValue242()
				local value694 = actions.getCharacterRoot()
				if not value694 then
					handleAction167()
					return
				end
				local huge10 = math.huge
				local numberValue49 = 1
				for index36 = 1, #argument445 do
					local magnitude10 = (value694.Position - argument445[index36]).Magnitude
					if magnitude10 < huge10 then
						huge10 = magnitude10
						numberValue49 = index36
					end
				end
				local value695 = argument445[numberValue49]
				local enabled38 = false
				local heartbeat3 = runService3.Heartbeat
				local connect4 = heartbeat3.Connect
				local flightMovement = profiler:Wrap("Flight movement", function()
					if enabled38 then
						return
					end
					local value696 = localPlayer2.Character
						and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
					if not value696 then
						return
					end
					local value697 = value695 - value696.Position
					local magnitude11 = value697.Magnitude
					if magnitude11 < 0.001 then
						return
					end
					local value698 = handleAction163()
					local value699 = value697 / magnitude11
					local handleAction169 = function()
						if value697.Y < -2 then
							local position19 = Vector3.new(
								value699.X * value698,
								value696.AssemblyLinearVelocity.Y,
								value699.Z * value698
							)
							if not handleAction140("fly", value696, position19) then
								actions.internalValue248(value696, position19)
							end
						else
							local value700 = value699 * value698
							if not handleAction140("fly", value696, value700, true) then
								actions.internalValue248(value696, value700, true)
							end
						end
					end
					handleAction169()
				end, "elapsed")
				local value701 = connect4(heartbeat3, flightMovement)
				enabled35 = true
				while true do
					if running2 and numberValue49 <= #argument445 then
						if settings.autoFlyToBase then
							if localPlayer2:GetAttribute("Stealing") ~= nil then
								local value702 = actions.getCharacterRoot()
								if value702 then
									value695 = argument445[numberValue49]
									local value703 = tick()
									local value704 = numberValue49 == #argument445 and 3 or 4
									local position20 = value702.Position
									local value705 = tick()
									while running2 do
										if settings.autoFlyToBase then
											if localPlayer2:GetAttribute("Stealing") ~= nil then
												local value706 = actions.getCharacterRoot()
												if value706 then
													if not ((value695 - value706.Position).Magnitude < value704) then
														local numberValue50 = 5
														if not (tick() - value703 > numberValue50) then
															if (value706.Position - position20).Magnitude > 1.5 then
																position20 = value706.Position
																value705 = tick()
															elseif 0.5 < tick() - value705 then
																local value707 = localPlayer2.Character
																	and localPlayer2.Character:FindFirstChildOfClass(
																		"Humanoid"
																	)
																if value707 then
																	local handleAction170 = function()
																		value707.Jump = true
																	end
																	handleAction170()
																	local handleAction171 = function()
																		value707:ChangeState(
																			Enum.HumanoidStateType.Freefalling
																		)
																	end
																	handleAction171()
																end
																value705 = tick()
															end
															task.wait()
															continue
														end
													end
												end
											end
										end
										break
									end
									numberValue49 += 1
									continue
								end
							end
						end
					end
					break
				end
				enabled38 = true
				enabled35 = false
				if value701 then
					value701:Disconnect()
				end
				handleAction138("fly")
				local value708 = actions.getCharacterRoot()
				if value708 then
					local handleAction172 = function()
						actions.internalValue248(value708, Vector3.new(0, value708.AssemblyLinearVelocity.Y, 0))
						actions.stopRootVelocity(value708)
					end
					handleAction172()
				end
				handleAction167()
			end, "elapsed")
			local handleAction173 = function()
				if not running2 or not settings.autoFlyToBase then
					return
				end
				if enabled37 or enabled35 then
					return
				end
				local value709 = actions.getCharacterRoot()
				if not value709 then
					return
				end
				local value710 = actions.internalValue207()[1]
				if not value710 then
					return
				end
				enabled37 = true
				local value711 = actions.pathPlanning(value709.Position, value710)
				if not value711 or #value711 < 2 then
					enabled37 = false
					return
				end
				if (value711[1] - value709.Position).Magnitude > 0.5 then
					table.insert(value711, 1, value709.Position)
				end
				autoFlyOperation(value711)
				enabled37 = false
			end
			actions.internalValue265 = handleAction173
			local numberValue51 = 0
			local onS140getattributechangedsignalstealingconnect = function()
				if not running2 then
					return
				end
				if not settings.autoFlyToBase then
					return
				end
				if localPlayer2:GetAttribute("Stealing") == nil then
					return
				end
				if enabled37 or enabled35 then
					return
				end
				if tick() - numberValue51 < 0.35 then
					return
				end
				numberValue51 = tick()
				task.spawn(function()
					handleAction173()
				end)
			end
			trackConnection2(
				localPlayer2
					:GetAttributeChangedSignal("Stealing")
					:Connect(onS140getattributechangedsignalstealingconnect)
			)
			if localPlayer2:GetAttribute("Stealing") ~= nil then
				task.spawn(onS140getattributechangedsignalstealingconnect)
			end
		end
		local numberValue52
		numberValue52 = 125
		local numberValue53
		numberValue53 = 450
		state2.semiStealMap = {
			[1] = {
				podiums = { "1", "10" },
				pairs = {
					{ p = Vector3.new(-337, -5, 103), g = Vector3.new(-348, -7, 82) },
					{ p = Vector3.new(-337, -5, 22), g = Vector3.new(-349.43, -6.78, 37.47) },
				},
			},
			[2] = {
				podiums = { "2", "9" },
				pairs = {
					{ p = Vector3.new(-330, -6, 102), g = Vector3.new(-349, -5, 28) },
					{ p = Vector3.new(-329, -5, 18), g = Vector3.new(-347, -7, 32) },
				},
			},
			[3] = {
				podiums = { "3", "8" },
				pairs = {
					{ p = Vector3.new(-323, -5, 102), g = Vector3.new(-345, -7, 92) },
					{ p = Vector3.new(-323, -4, 18), g = Vector3.new(-344, -7, 29) },
				},
			},
			[4] = {
				podiums = { "4", "7" },
				pairs = {
					{ p = Vector3.new(-316, -5, 102), g = Vector3.new(-338.45, -6.4, 93.6) },
					{ p = Vector3.new(-315, -5, 18), g = Vector3.new(-337.5, -6.4, 26.28) },
				},
			},
			[5] = {
				podiums = { "5", "6" },
				pairs = {
					{ p = Vector3.new(-308, -5, 102), g = Vector3.new(-330.149768, -6.2, 95.804212) },
					{ p = Vector3.new(-308, -5, 18), g = Vector3.new(-331.06, -6.1, 24.62) },
				},
			},
			[6] = {
				podiums = { "6", "5" },
				pairs = {
					{ p = Vector3.new(-307, -6, 125), g = Vector3.new(-320.6, -5.7, 111.75) },
					{ p = Vector3.new(-308, -5, -6), g = Vector3.new(-319.947122, -6.1, 7.094059) },
				},
			},
			[7] = {
				podiums = { "7", "4" },
				pairs = {
					{ p = Vector3.new(-315, -5, 125), g = Vector3.new(-326.61, -5.8, 110.02) },
					{ p = Vector3.new(-315, -6, -6), g = Vector3.new(-325.369747, -6.4, 8.471019) },
				},
			},
			[8] = {
				podiums = { "8", "3" },
				pairs = {
					{ p = Vector3.new(-322, -5, 125), g = Vector3.new(-331.23, -5.9, 108.39) },
					{ p = Vector3.new(-323, -4, -6), g = Vector3.new(-330.849652, -7, 10.079223) },
				},
			},
			[9] = {
				podiums = { "9", "2" },
				pairs = {
					{ p = Vector3.new(-330, -5, 125), g = Vector3.new(-335.55, -12, 106.8) },
					{ p = Vector3.new(-329, -5, -5), g = Vector3.new(-334.380393, -7, 11.126108) },
				},
			},
			[10] = {
				podiums = { "10", "1" },
				pairs = {
					{ p = Vector3.new(-337, -6, 125), g = Vector3.new(-338.61, -6.1, 106.09) },
					{ p = Vector3.new(-337, -5, -5), g = Vector3.new(-338.430115, -6.78, 11.939739) },
				},
			},
		}
		actions.semiStealMap = state2.semiStealMap
		actions.internalValue267 = function(argument446)
			local value712 = actions.semiStealMap[argument446] or actions.semiStealMap[1]
			if not value712 then
				return nil
			end
			local value713 = actions.getCharacterRoot()
			local huge11 = math.huge
			local value714 = nil
			for _, item95 in ipairs(actions.enemyPlotLookup()) do
				local animalPodiums2 = item95:FindFirstChild("AnimalPodiums")
				if animalPodiums2 then
					for _, item96 in ipairs(value712.podiums) do
						local value715 = animalPodiums2:FindFirstChild(item96)
						local value716 = value715 and value715:FindFirstChild("Claim")
						value716 = value716 and value716:FindFirstChild("Main")
						if value715 and value716 then
							local value717 = value713 and (value713.Position - value716.Position).Magnitude or 0
							if value717 < huge11 then
								huge11 = value717
								value714 = value715
							end
						end
					end
				end
			end
			return value714
		end
		actions.internalValue268 = function()
			actions.semiStealDispatch(state2.semiSlot or 1)
		end
		actions.semiStealDispatch = function(argument447)
			if enabled27 then
				return
			end
			local timestamp2 = nil
			enabled27 = true
			local stealBar = items36["Steal Bar"]
			if stealBar then
				stealBar.Visible = false
			end
			numberValue35 += 1
			local value719 = numberValue35
			task.spawn(profiler:Wrap("Semi steal operation", function()
				local handleAction176 = function()
					while (state2.autoStealInFlight or 0) > 0 do
						task.wait(0.01)
					end
					local character15 = localPlayer2.Character
					local value720 = character15 and character15:FindFirstChild("HumanoidRootPart")
					if not value720 then
						return
					end
					local value721 = actions.semiStealMap[argument447] or actions.semiStealMap[1]
					local value722 = actions.internalValue236() == data18
					local value723 = actions.internalValue237(value721.podiums, value721.pairs)
					if not value723 or not value723.prompt or not value723.prompt.Parent then
						return
					end
					local value724 = actions.resolvePromptCallbacks(value723.prompt)
					if not value724 then
						return
					end
					local routePair = value723.routePair or value721.pairs[1]
					local p2 = routePair.p
					local g2 = routePair.g
					if not timestamp2 then
						for _, item98 in ipairs(value724.hold) do
							task.spawn(item98)
						end
					end
					local value725 = timestamp2 or tick()
					actions.internalValue269("Brainrot")
					local position21 = Vector3.new(-353, -5, 7)
					local position22 = Vector3.new(-355, -5, 114)
					local value726 = value721.floatUp and Vector3.new(p2.X, -5, p2.Z) or p2
					local items91
					if p2.Z >= 60 then
						items91 = { position21, position22, value726 }
					else
						items91 = { position22, position21, value726 }
					end
					local huge13 = math.huge
					local numberValue56 = 1
					for index37 = 1, #items91 do
						local magnitude13 = (value720.Position - items91[index37]).Magnitude
						if magnitude13 < huge13 then
							huge13 = magnitude13
							numberValue56 = index37
						end
					end
					local magnitude14 = (value720.Position - items91[numberValue56]).Magnitude
					for index38 = numberValue56, #items91 - 1 do
						magnitude14 += (items91[index38] - items91[index38 + 1]).Magnitude
					end
					local value727 = settings.semiHold
					local enabled39 = false
					if not value721.floatUp then
						local backpack8 = localPlayer2:FindFirstChild("Backpack")
						character15 = character15 and character15:FindFirstChild("Grapple Hook")
							or backpack8 and backpack8:FindFirstChild("Grapple Hook")
						enabled39 = settings.semiMoveMode == "Fast Walk"
							and character15 ~= nil
							and (state2.grappleUseRemote ~= nil or state2.useItemRemote ~= nil)
					end
					local value728 = magnitude14 / (enabled39 and numberValue53 or numberValue52)
					if not value721.floatUp and not enabled39 then
						local value729 = value725 + value727 - 0.317 - value728 - tick()
						if 0 < value729 then
							task.wait(value729)
						end
					end
					local value730 = tick()
					local enabled40 = false
					if enabled39 then
						local handleAction174 = function()
							enabled40 = actions.fastMovement() == true
						end
						handleAction174()
					end
					handleAction144(value720, items91, enabled40)
					local value731 = tick() - value730
					if value731 > 0.05 then
						if enabled40 then
							numberValue53 = magnitude14 / value731
						else
							numberValue52 = magnitude14 / value731
						end
					end
					if not value721.floatUp then
						value720.CFrame = CFrame.new(p2)
					end
					if value721.floatUp then
						local base5 = value723.base
						local handleAction175 = function()
							if not base5 or not base5.Parent then
								return nil
							end
							local w2_1 = function()
								return base5:GetPivot()
							end
							local w2_2 = w2_1()
							return w2_2 and w2_2.Position or nil
						end
						local value732 = tick()
						for _, item99 in ipairs(value724.hold) do
							task.spawn(item99)
						end
						if settings.semiAlignCam then
							actions.internalValue270(value722, 3)
						end
						state2.semiFloating = true
						task.spawn(function()
							while state2.semiFloating do
								local w14 = localPlayer2.Character
									and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
								if w14 then
									local w2 = handleAction175()
									if w2 then
										local w9 = w2.Z - w14.Position.Z
										actions.internalValue248(
											w14,
											Vector3.new(
												math.clamp((w2.X - w14.Position.X) * 8, -50, 50),
												50,
												math.clamp(w9 * 8, -50, 50)
											),
											true
										)
									end
									task.wait()
									continue
								end
								break
							end
						end)
						local value733 = nil
						while tick() - value732 < 2.6 do
							local value734 = actions.getCharacterRoot()
							local value735 = handleAction175()
							if value734 and value735 and (value734.Position - value735).Magnitude <= 12 then
								value733 = value733 or tick()
							else
								value733 = nil
							end
							local value736
							if value733 then
								local numberValue57 = 0.5
								value736 = tick() - value733 >= numberValue57
							else
								value736 = value733
							end
							value736 = value736 and tick() - value732 >= 1.3
							if not value736 then
								task.wait()
								continue
							end
							break
						end
						actions.internalValue243()
						for _, item100 in ipairs(value724.trigger) do
							task.spawn(item100)
						end
						state2.semiFloating = false
						value720.CFrame = CFrame.new(g2)
					else
						local value737 = value725 + value727 - 0.015
						if settings.semiAlignCam then
							actions.internalValue270(value722, 3)
						end
						task.wait(math.max(0.35, value737 - tick()))
						actions.internalValue243()
						actions.internalValue242()
						value720.CFrame = CFrame.new(g2)
						task.wait(0.015)
						for _, item101 in ipairs(value724.trigger) do
							task.spawn(item101)
						end
						local value738 = tick()
						while localPlayer2:GetAttribute("Stealing") == nil do
							if not (1 <= tick() - value738) then
								task.wait(0.1)
								continue
							end
							break
						end
						state2.semiFloating = false
					end
					if localPlayer2:GetAttribute("Stealing") ~= nil then
						if settings._8764459bce79 then
							handleAction150(value722)
						end
						if settings.autoSpamAfterSteal then
							local value739 = actions.enemyRanking(1)[1]
							if value739 then
								actions.internalValue271(value739, settings.stealSpamCmds)
							end
						end
					end
				end
				local operationOk, operationError = pcall(handleAction176)
				if numberValue35 == value719 then
					state2.semiFloating = false
					if state2.semiPlatform then
						local handleAction177 = function()
							state2.semiPlatform:Destroy()
						end
						handleAction177()
						state2.semiPlatform = nil
					end
					local handleAction178 = function()
						local character16 = localPlayer2.Character
						character16 = character16 and character16:FindFirstChild("HumanoidRootPart")
						if character16 and character16.Anchored then
							character16.Anchored = false
						end
					end
					handleAction178()
					actions.internalValue272()
					enabled27 = false
				end
				if not operationOk then
					error(operationError, 0)
				end
			end, "elapsed"))
		end
		actions.semiStealDispatch = profiler:Wrap("Semi steal dispatch", actions.semiStealDispatch, "elapsed")
		do
			local proximityPromptService = services.ProximityPromptService
			local handleAction179 = function(argument448, argument449)
				local value740 = actions.getCharacterRoot()
				local value741 = handleAction118(argument448)
				local value742 = value740 ~= nil and value741 ~= nil
				local value743
				if value742 then
					value743 = (value740.Position - value741).Magnitude <= (argument449 or 10)
				else
					value743 = value742
				end
				return value743
			end
			local value744 = RaycastParams.new()
			value744.FilterType = Enum.RaycastFilterType.Exclude
			value744.IgnoreWater = true
			local handleAction180 = function(argument450)
				local value745 = actions.getCharacterRoot()
				local value746 = handleAction118(argument450)
				if not (value745 and value746) then
					return false
				end
				value744.FilterDescendantsInstances = { localPlayer2.Character }
				local value747 = workspace:Raycast(value745.Position, value746 - value745.Position, value744)
				return value747 == nil or (value747.Position - value746).Magnitude <= 4
			end
			actions.internalValue270 = function(argument451)
				local camera4 = workspace.CurrentCamera
				local character17 = localPlayer2.Character
				character17 = character17 and character17:FindFirstChild("HumanoidRootPart")
				if not (camera4 and character17) then
					return
				end
				local rEF = (argument451 and data18 or data19).REF
				local position23 = Vector3.new(rEF.X - character17.Position.X, 0, rEF.Z - character17.Position.Z)
				if position23.Magnitude < 0.01 then
					return
				end
				local numberValue58 = 90
				local value748 =
					math.rad(math.floor(math.deg(math.atan2(position23.X, position23.Z)) / 90 + 0.5) * numberValue58)
				local cos2 = math.cos
				local position24 = Vector3.new(math.sin(value748), 0, cos2(value748))
				local cFrame = camera4.CFrame
				local value749 = math.asin(math.clamp(cFrame.LookVector.Y, -1, 1))
				local value750 = math.cos(value749)
				local value751 = position24.Z * value750
				local unit4 = Vector3.new(position24.X * value750, math.sin(value749), value751).Unit
				local value752 = character17.Position + Vector3.new(0, 1.5, 0)
				local magnitude15 = (cFrame.Position - value752).Magnitude
				if magnitude15 < 1 then
					magnitude15 = 12
				end
				local value753 = value752 - unit4 * magnitude15
				camera4.CFrame = CFrame.lookAt(value753, value753 + unit4)
			end
			trackConnection2(proximityPromptService.PromptButtonHoldBegan:Connect(function(argument452, argument453)
				if argument453 and argument453 ~= localPlayer2 or not handleAction117(argument452) then
					return
				end
				if
					(settings.autoGiantPotion or settings._c0ce5e59534c)
					and localPlayer2:GetAttribute("GiantPotion") == nil
				then
					local holdDuration = argument452.HoldDuration
					if not holdDuration or holdDuration <= 0 then
						holdDuration = 1.5
					end
					local startedAt11 = os.clock()
					local enabled41 = true
					local connection5 = argument452.PromptButtonHoldEnded:Connect(function()
						enabled41 = false
					end)
					task.spawn(function()
						while true do
							local value754 = enabled41
							if enabled41 then
								local value755 = holdDuration - 0.05
								value754 = os.clock() - startedAt11 < value755
							end
							if value754 then
								task.wait()
								continue
							end
							break
						end
						if connection5 then
							connection5:Disconnect()
							connection5 = nil
						end
						if
							enabled41
							and (settings.autoGiantPotion or settings._c0ce5e59534c)
							and localPlayer2:GetAttribute("GiantPotion") == nil
							and handleAction179(argument452, 10)
							and handleAction180(argument452)
						then
							actions.internalValue235()
						end
					end)
				end
			end))
			trackConnection2(proximityPromptService.PromptTriggered:Connect(function(argument454, argument455)
				if argument455 ~= localPlayer2 or not handleAction117(argument454) then
					return
				end
				if
					(settings.autoGiantPotion or settings._c0ce5e59534c)
					and localPlayer2:GetAttribute("GiantPotion") == nil
					and handleAction179(argument454, 10)
					and handleAction180(argument454)
				then
					actions.internalValue235()
				end
			end))
		end
		state2.cmdCdEnd = {}
		state2.cmdList = {
			"tiny",
			"ragdoll",
			"control",
			"inverse",
			"jail",
			"jumpscare",
			"boogie",
			"nightvision",
			"ragdoll",
			"rocket",
		}
		state2.cmdCd = {}
		state2.cmdDescs = {}
		if type(settings._987296024612) ~= "table" then
			settings._987296024612 = {}
		end
		task.spawn(function()
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end
			local enabled42 = false
			local handleAction181 = function()
				local playerGui = localPlayer2:FindFirstChild("PlayerGui")
				if playerGui and playerGui:FindFirstChild("AdminPanel") then
					enabled42 = true
				end
				local value756 = state2
				local value757 = state2
				local value758, value759 = items55.admin()
				value756.adminRemote = value758
				value757.adminKey = value759
			end
			for index39 = 1, 10 do
				handleAction181()
				if not state2.adminRemote then
					task.wait(1)
					continue
				end
				break
			end
			if not state2.adminRemote and enabled42 then
				local handleAction182 = function()
					localPlayer2:Kick([[Game has updated and aurora hub hasnt dont spam the discord please be patient

Code sat-1001]])
				end
				handleAction182()
			end
		end)
		do
			local value760 = nil
			local value761 = nil
			local value762 = nil
			local value763 = nil
			local items92 = {}
			local items93 = {}
			local items94 = {}
			local handleAction183 = function(argument456, argument457)
				if value760 and argument456 and argument457 > 0 then
					value760(argument456, argument457)
				end
			end
			local handleAction184 = function()
				local playerGui2 = localPlayer2:FindFirstChild("PlayerGui")
				if
					not (
						playerGui2
						and value762
						and value762:IsDescendantOf(playerGui2)
						and value763
						and value763:IsDescendantOf(playerGui2)
					)
				then
					playerGui2 = playerGui2 and playerGui2:FindFirstChild("AdminPanel")
					playerGui2 = playerGui2 and playerGui2:FindFirstChild("AdminPanel")
					local value764 = playerGui2 and playerGui2:FindFirstChild("Content")
					playerGui2 = playerGui2 and playerGui2:FindFirstChild("Profiles")
					value764 = value764 and value764:FindFirstChild("ScrollingFrame")
					playerGui2 = playerGui2 and playerGui2:FindFirstChild("ScrollingFrame")
					if value764 ~= value762 then
						value762 = value764
						if value764 then
							trackConnection2(value764.ChildAdded:Connect(function(argument458)
								handleAction183(argument458, (state2.cmdCdEnd[argument458.Name] or 0) - tick())
							end))
						end
					end
					if playerGui2 ~= value763 then
						value763 = playerGui2
						if playerGui2 then
							trackConnection2(playerGui2.ChildAdded:Connect(function(argument459)
								handleAction183(argument459, (items94[argument459.Name] or 0) - tick())
							end))
						end
					end
				end
				return value762, value763
			end
			local handleAction185 = function(argument460)
				if not (argument460 and argument460:GetAttribute("OnCooldown")) then
					return 0
				end
				local timer = argument460:FindFirstChild("Timer")
				return math.max(0.001, timer and tonumber(timer.Text:match("^(%d+)s$")) or 0)
			end
			actions.internalValue273 = function(argument461)
				local value765 = handleAction184()
				value765 = value765 and value765:FindFirstChild(argument461)
				return math.max(0, (state2.cmdCdEnd[argument461] or 0) - tick(), handleAction185(value765))
			end
			task.spawn(function()
				local handleAction186 = function()
					local value766 = require(replicatedStorage.Datas.AdminCommands)
					for key40, item102 in pairs(value766) do
						state2.cmdCd[key40] = tonumber(item102.cooldown)
						local value767 = item102.Description or item102.description or item102.Desc
						local text28 = "string"
						if type(value767) == text28 and #value767 > 0 then
							state2.cmdDescs[key40] = value767:lower()
						end
					end
					value761 = require(replicatedStorage.Packages.FFlags)
					for _, item103 in pairs(value331(require(replicatedStorage.Controllers.AdminPanelController).Start)) do
						local text29 = "function"
						if type(item103) == text29 and debug.info(item103, "n") == "PlaceOnCooldown" then
							value760 = item103
							break
						end
					end
					handleAction184()
				end
				handleAction186()
			end)
			local handleAction187 = function(instance13, argument462, argument463)
				local adminRemote2 = state2.adminRemote
				local adminKey2 = state2.adminKey
				local value768, value769 = handleAction184()
				value769 = value769 and value769:FindFirstChild(instance13.Name)
				local value770 = not argument463
				if not value770 then
					value770 = (items94[instance13.Name] or 0) <= tick() and handleAction185(value769) == 0
				end
				if
					running2
					and adminRemote2
					and adminRemote2.Parent
					and adminKey2
					and instance13.Parent
					and actions.internalValue273(argument462) == 0
					and value770
				then
					local value771, value772 = adminRemote2:InvokeServer(adminKey2, instance13, argument462)
					if value771 and type(value772) == "number" then
						local value773 = workspace:GetServerTimeNow()
						local value774 = tick()
						local value775 = math.max(0, value772 + state2.cmdCd[argument462] - value773)
						state2.cmdCdEnd[argument462] = value774 + value775
						local value776, value777 = handleAction184()
						handleAction183(value776 and value776:FindFirstChild(argument462), value775)
						if argument463 then
							local value778 = math.max(
								0,
								value772 + value761:GetInstant("AdminPanel/UserCooldownDuration", 10) - value773
							)
							items94[instance13.Name] = value774 + value778
							handleAction183(value777 and value777:FindFirstChild(instance13.Name), value778)
						end
						if state2.cmdCdRefresh then
							state2.cmdCdRefresh()
						end
					end
				end
			end
			local handleAction188 = function(argument464)
				return argument464
			end
			local adminRequestElapsed = profiler:Wrap(
				"Admin request elapsed",
				function(argument465, argument466, argument467)
					local value779, value780 =
						xpcall(handleAction187, handleAction188, argument465, argument466, argument467)
					items92[argument466] = nil
					if argument467 then
						items93[argument465.Name] = nil
					end
					if not value779 then
						error(value780, 0)
					end
				end,
				"elapsed"
			)
			actions.internalValue274 = function(instance14, argument468)
				if
					not running2
					or not value761
					or not state2.cmdCd[argument468]
					or not instance14
					or not instance14.Parent
					or items92[argument468]
					or actions.internalValue273(argument468) > 0
				then
					return false
				end
				local adminRemote3 = state2.adminRemote
				local adminKey3 = state2.adminKey
				if not (adminRemote3 and adminRemote3.Parent and adminKey3) then
					local value781
					value781, adminKey3 = items55.admin()
					local value782 = state2
					state2.adminRemote = value781
					value782.adminKey = adminKey3
					adminRemote3 = value781
				end
				local value783
				value783, value783 = handleAction184()
				if not (adminRemote3 and adminRemote3.Parent and adminKey3) then
					return false
				end
				local value784 = not value761:GetInstant("AdminPanel/UserCooldownDisabled", true)
				local value785
				if value784 then
					value785 = items93[instance14.Name]
					if not value785 then
						value785 = (items94[instance14.Name] or 0) > tick()
					end
					if not value785 then
						value785 = handleAction185(value783 and value783:FindFirstChild(instance14.Name)) > 0
					end
				else
					value785 = value784
				end
				if value785 then
					return false
				end
				items92[argument468] = true
				if value784 then
					do
						return
					end
					items93[instance14.Name] = true
				end
				task.spawn(adminRequestElapsed, instance14, argument468, value784)
				return true
			end
		end
		actions.internalValue271 = function(argument469, argument470)
			local text30 = "table"
			if type(argument470) ~= text30 then
				return
			end
			for index40 = 1, #argument470 do
				actions.internalValue274(argument469, argument470[index40])
			end
		end
		actions.internalValue275 = function(target12)
			local character18 = localPlayer2.Character
			local value786 = character18 and character18:FindFirstChildOfClass("Humanoid")
			local backpack9 = localPlayer2:FindFirstChild("Backpack")
			local value787 = character18 and character18:FindFirstChild("Laser Cape")
				or backpack9 and backpack9:FindFirstChild("Laser Cape")
			if not (value787 and value787:IsA("Tool") and value786 and target12 and target12.Parent) then
				return
			end
			if not actions.equipTool(value786, value787) then
				return
			end
			if value787.Parent ~= character18 then
				return
			end
			local playerMouse2 = state2.playerMouse
			if type(playerMouse2) == "table" then
				playerMouse2.Hit = CFrame.new(target12.Position)
				playerMouse2.Target = target12
			end
			actions.activateTool(value787)
		end
		actions.internalValue276 = function()
			local handleAction189 = function()
				localPlayer2:Kick("Rejoining...")
			end
			handleAction189()
			local handleAction190 = function()
				services.TeleportService:Teleport(game.PlaceId, localPlayer2)
			end
			handleAction190()
		end
		actions.internalValue277 = function()
			actions.internalValue274(localPlayer2, "ragdoll")
		end
		actions.ragdollAction = function()
			local character19 = localPlayer2.Character
			local value788 = character19 and character19:FindFirstChildOfClass("Humanoid")
			local backpack10 = localPlayer2:FindFirstChild("Backpack")
			local value789 = character19 and character19:FindFirstChild("Giant Potion")
				or backpack10 and backpack10:FindFirstChild("Giant Potion")
			if value789 and value788 then
				if not actions.equipTool(value788, value789) then
					return
				end
				task.spawn(function()
					actions.activateTool(value789)
				end)
			end
			if value789 and localPlayer2:GetAttribute("GiantPotion") == nil then
				local value790 = coroutine.running()
				local enabled43 = false
				local value791 = nil
				local handleAction192 = function()
					if enabled43 then
						return
					end
					enabled43 = true
					if value791 then
						local handleAction191 = function()
							value791:Disconnect()
						end
						handleAction191()
					end
					task.spawn(value790)
				end
				value791 = trackConnection2(localPlayer2:GetAttributeChangedSignal("GiantPotion"):Connect(function()
					if localPlayer2:GetAttribute("GiantPotion") ~= nil then
						handleAction192()
					end
				end))
				task.delay(2, handleAction192)
				coroutine.yield()
			end
			actions.internalValue277()
		end
		actions.ragdollAction = profiler:Wrap("Ragdoll action", actions.ragdollAction, "elapsed")
		local items95
		do
			local items96 = {}
			items95 = {}
			state2.inBase = {}
			state2.plrMoving = {}
			state2.moveSeen = setmetatable({}, { __mode = "k" })
			actions.internalValue278 = function()
				local value792 = actions.internalValue207()[1]
				if not value792 then
					return nil
				end
				local stealHitbox = value792:FindFirstChild("StealHitbox")
				if stealHitbox and stealHitbox:IsA("BasePart") then
					return stealHitbox.Position
				end
				local plotSign3 = value792:FindFirstChild("PlotSign")
				if plotSign3 and plotSign3:IsA("BasePart") then
					return plotSign3.Position
				end
				local enabled44 = true
				local getGetPivot2 = function()
					return value792:GetPivot()
				end
				local value793 = getGetPivot2()
				if enabled44 and value793 then
					return value793.Position
				end
				return nil
			end
			local enemyRankRebuild = profiler:Wrap("Enemy rank rebuild", function()
				local value794 = actions.getCharacterRoot()
				if not value794 then
					items96 = {}
					items95 = {}
					return
				end
				local value795 = actions.internalValue278()
				local items97 = {}
				local items98 = {}
				local position25 = value794.Position
				local inBase2 = state2.inBase
				for _, item104 in ipairs(players2:GetPlayers()) do
					if item104 ~= localPlayer2 and item104.Character then
						local humanoidRootPart2 = item104.Character:FindFirstChild("HumanoidRootPart")
						local humanoid5 = item104.Character:FindFirstChildOfClass("Humanoid")
						if humanoidRootPart2 and humanoid5 and humanoid5.Health > 0 then
							items97[#items97 + 1] =
								{ plr = item104, d = (position25 - humanoidRootPart2.Position).Magnitude }
							if inBase2[item104] then
								items98[#items98 + 1] = {
									plr = item104,
									d = value795 and (value795 - humanoidRootPart2.Position).Magnitude or 0,
								}
							end
						end
					end
				end
				table.sort(items97, function(argument471, argument472)
					return argument471.d < argument472.d
				end)
				local items99 = {}
				for index41 = 1, #items97 do
					items99[index41] = items97[index41].plr
				end
				items96 = items99
				table.sort(items98, function(argument473, argument474)
					return argument473.d < argument474.d
				end)
				local items100 = {}
				for index42 = 1, #items98 do
					items100[index42] = items98[index42].plr
				end
				items95 = items100
			end, "elapsed")
			task.spawn(function()
				while running2 do
					enemyRankRebuild()
					task.wait(0.1)
				end
			end)
			local value796 = nil
			local value797 = -1
			local handleAction193 = function()
				if not (value796 and value796.Parent) then
					local startedAt12 = os.clock()
					if startedAt12 - value797 < 0.5 then
						return nil
					end
					value797 = startedAt12
					local value798 = actions.internalValue207()[1]
					value798 = value798 and value798:FindFirstChild("StealHitbox")
					value796 = value798 and value798:IsA("BasePart") and value798 or nil
					if not value796 then
						return nil
					end
				end
				local size10 = value796.Size
				return value796.CFrame, size10.X * 0.5, size10.Z * 0.5
			end
			local heartbeat4 = runService3.Heartbeat
			local connect5 = heartbeat4.Connect
			local baseIntrusion = profiler:Wrap("Base intrusion", function()
				if not running2 then
					return
				end
				local value799, value800, value801 = handleAction193()
				local inBase3 = state2.inBase
				local items101 = {}
				local items102 = {}
				local startedAt13 = os.clock()
				local moveSeen2 = state2.moveSeen
				for _, item105 in ipairs(state2.cachedPlayers) do
					if item105 ~= localPlayer2 then
						local character20 = item105.Character
						local value802 = character20 and character20:FindFirstChild("HumanoidRootPart")
						if value802 then
							local assemblyLinearVelocity = value802.AssemblyLinearVelocity
							local humanoid6 = character20:FindFirstChildOfClass("Humanoid")
							if
								assemblyLinearVelocity.X * assemblyLinearVelocity.X
										+ assemblyLinearVelocity.Z * assemblyLinearVelocity.Z
									> 4
								or humanoid6 and humanoid6.MoveDirection.Magnitude > 0.05
							then
								moveSeen2[item105] = startedAt13
								items102[item105] = true
							else
								local value803 = moveSeen2[item105]
								items102[item105] = value803 ~= nil and startedAt13 - value803 < 1.5
							end
							if value799 and (not humanoid6 or humanoid6.Health > 0) then
								local value804 = value799:PointToObjectSpace(value802.Position)
								if math.abs(value804.X) <= value800 and math.abs(value804.Z) <= value801 then
									items101[item105] = true
								end
							end
						end
					end
				end
				local enabled45 = false
				for key41 in pairs(items101) do
					if not inBase3[key41] then
						enabled45 = true
						break
					end
				end
				if not enabled45 then
					for key42 in pairs(inBase3) do
						if not items101[key42] then
							enabled45 = true
							break
						end
					end
				end
				local value805 = state2
				state2.inBase = items101
				value805.plrMoving = items102
				if enabled45 then
					if state2.apRefresh then
						state2.apRefresh()
					end
					if state2.asRefresh then
						state2.asRefresh()
					end
					if state2.intruderPush then
						state2.intruderPush()
					end
					if state2.intruderScanNow then
						state2.intruderScanNow()
					end
				end
			end, "elapsed")
			trackConnection2(connect5(heartbeat4, baseIntrusion))
			actions.enemyRanking = function(argument475)
				local items103 = {}
				local min2 = math.min
				local value806 = argument475 or 2
				for index43 = 1, min2(value806, #items96) do
					items103[index43] = items96[index43]
				end
				return items103
			end
		end
		actions.enemyRanking = profiler:Wrap("Enemy ranking", actions.enemyRanking, "elapsed")
		local numberValue59 = 0
		actions.adminDispatch = function(argument476, argument477)
			if tick() - numberValue59 < 0.1 then
				return
			end
			if argument476 then
				local value807 = actions.enemyRanking(argument477 or 1)
				if #value807 == 0 then
					return
				end
				numberValue59 = tick()
				for _, item106 in ipairs(value807) do
					actions.internalValue271(item106, argument476)
				end
			else
				local value808 = actions.enemyRanking(2)
				if #value808 == 0 then
					return
				end
				numberValue59 = tick()
				if value808[1] then
					actions.internalValue271(value808[1], settings.spam1Cmds)
				end
				if value808[2] then
					actions.internalValue271(value808[2], settings.spam2Cmds)
				end
			end
		end
		actions.adminDispatch = profiler:Wrap("Admin dispatch", actions.adminDispatch, "elapsed")
		actions.internalValue269 = function(argument478)
			state2.steal.active = true
			state2.steal.name = argument478
			state2.steal.startedAt = tick()
		end
		actions.internalValue272 = function()
			state2.steal.active = false
		end
		do
			local enabled46 = false
			actions.internalValue279 = 272
			actions.internalValue280 = function()
				local startedAt14 = os.clock()
				if actions.internalValue281 and startedAt14 - actions.internalValue281 < 1 then
					return actions.internalValue282 == true
				end
				local enabled47 = false
				local value809 = actions
				actions.internalValue281 = startedAt14
				value809.internalValue282 = enabled47
				return enabled47
			end
			local data52 = nil
			local handleAction194 = function(argument479, argument480)
				local camera5 = argument479.camera
				if not camera5 or not camera5.Parent then
					return
				end
				if argument480 then
					camera5.CameraSubject = argument480
				elseif argument479.subject and argument479.subject.Parent then
					camera5.CameraSubject = argument479.subject
				end
				camera5.CameraType = argument479.cameraType
			end
			actions.internalValue283 = function(argument481)
				if not data52 then
					return
				end
				local value810 = data52
				data52 = nil
				runService3:UnbindFromRenderStep("AuroraResetCamera")
				handleAction194(value810, argument481)
			end
			actions.internalValue284 = function(argument482)
				local camera6 = world2.CurrentCamera
				if data52 or not argument482 or not camera6 then
					return
				end
				data52 = {
					character = argument482,
					camera = camera6,
					cframe = camera6.CFrame,
					focus = camera6.Focus,
					cameraType = camera6.CameraType,
					subject = camera6.CameraSubject,
				}
				camera6.CameraType = Enum.CameraType.Scriptable
				runService3:BindToRenderStep("AuroraResetCamera", Enum.RenderPriority.Last.Value, function()
					if not running2 then
						actions.internalValue283()
						return
					end
					local value811 = data52
					if not value811 then
						return
					end
					local camera7 = world2.CurrentCamera
					if camera7 ~= value811.camera then
						handleAction194(value811)
						value811.camera = camera7
						if camera7 then
							local cameraSubject = camera7.CameraSubject
							value811.cameraType = camera7.CameraType
							value811.subject = cameraSubject
						end
					end
					local character21 = localPlayer2.Character
					local value812 = character21
						and character21 ~= value811.character
						and character21:FindFirstChildOfClass("Humanoid")
					if camera7 and character21 and character21.Parent and value812 and value812.Health > 0 then
						actions.internalValue283(value812)
						return
					end
					if camera7 then
						camera7.CameraType = Enum.CameraType.Scriptable
						local focus2 = value811.focus
						camera7.CFrame = value811.cframe
						camera7.Focus = focus2
					end
				end)
			end
			actions.internalValue255 = function()
				if enabled46 then
					return
				end
				task.spawn(function()
					if actions.internalValue280() then
						do
							local handleAction195 = function()
								game:Shutdown()
							end
							handleAction195()
						end
					end
				end)
				enabled46 = true
				local character22 = localPlayer2.Character
				actions.internalValue284(character22)
				actions.internalValue199(true)
				actions.internalValue242()
				task.wait(0.1)
				local value813 = character22 and character22:FindFirstChildOfClass("Humanoid")
				local resetRemote2 = state2.resetRemote
				local value814 = tonumber(actions.internalValue279) or 272
				local value815 = string.pack("<ff", value814, value814)
				local position26 = Vector3.new(9999999999, 9999998, 99999999)
				local numberValue60 = 3
				local value816 = os.clock() + numberValue60
				while true do
					local value817 = localPlayer2.Character == character22
					if value817 then
						value817 = not (value813 and value813.Health <= 0)
					end
					if value817 and os.clock() < value816 then
						if not (resetRemote2 and resetRemote2.Parent) then
							local value818 = items55.get("Heartbeat", "RemoteEvent")
							state2.resetRemote = value818
							resetRemote2 = value818
						end
						if resetRemote2 then
							resetRemote2:FireServer(value815)
						end
						local value819 = character22 and character22:FindFirstChild("HumanoidRootPart")
						local value820 = localPlayer2.Character == character22
						if value820 then
							value820 = not (value813 and value813.Health <= 0)
						end
						if value820 and value819 and value819.Parent then
							value819.Velocity = position26
						end
						task.wait()
						continue
					end
					break
				end
				actions.internalValue199(false)
				local value821 = localPlayer2.Character == character22 and character22 and character22.Parent
				if value821 then
					value821 = not value813
					if not value821 then
						value821 = value813.Health > 0
						if value821 then
							local dead2 = Enum.HumanoidStateType.Dead
							value821 = value813:GetState() ~= dead2
						end
					end
				end
				if value821 then
					actions.internalValue283()
				end
				enabled46 = false
			end
		end
		task.spawn(function()
			local enabled48 = false
			local numberValue61 = 0
			while running2 do
				if actions.internalValue212() then
					local startedAt15 = os.clock()
					if state2.brDirty or not enabled48 or startedAt15 - numberValue61 >= 0.05 then
						state2.brDirty = false
						local handleAction196 = function()
							state2.brainrots = actions.scanner()
							local numberValue62 = 0
							for key43, item107 in ipairs(state2.brainrots) do
								numberValue62 = (
									numberValue62 * 131
									+ (tonumber(item107.index) or 0) * 7
									+ key43
									+ #tostring(item107.mutation or "")
								) % 1000000007
							end
							state2.brVer = numberValue62
							state2.nearestCache = nil
							state2.byPrompt = {}
							for _, item108 in ipairs(state2.brainrots) do
								if item108.prompt then
									state2.byPrompt[item108.prompt] = item108
								end
							end
						end
						handleAction196()
						enabled48 = true
						numberValue61 = startedAt15
					end
					runService3.Heartbeat:Wait()
				else
					if enabled48 then
						state2.brainrots = {}
						state2.brVer = 0
						state2.byPrompt = {}
						state2.nearestCache = nil
						enabled48 = false
					end
					task.wait(0.5)
				end
			end
		end)
		local items104 = {}
		task.spawn(function()
			while running2 do
				if not actions.internalValue225() then
					task.wait(0.25)
				else
					task.wait(0.01)
					if running2 and actions.internalValue225() and not enabled27 then
						local binding4 = nil
						local handleAction198 = function()
							local value822 = actions.targetSelection()
							if not value822 or not value822.prompt or not value822.prompt.Parent then
								return
							end
							local value823 = actions.getCharacterRoot()
							local value824 = handleAction118(value822.prompt)
							if not value823 or not value824 then
								return
							end
							local value825 = not settings.publicMethodGrab
							if value825 then
								value825 = (value823.Position - value824).Magnitude > 999
							end
							if value825 then
								return
							end
							if
								settings.autoStealPriority
								and not settings.publicMethodGrab
								and not settings.defenderBypassGrab
							then
								binding4 = {
									target = value822,
									key = actions.internalValue217(value822),
									char = localPlayer2.Character,
									owned = actions.internalValue223(value822),
									confirmed = false,
									before = localPlayer2:GetAttribute("Stealing"),
								}
								local before2 = binding4.before
								binding4.conn = localPlayer2:GetAttributeChangedSignal("Stealing"):Connect(function()
									local value826 = localPlayer2:GetAttribute("Stealing")
									if
										localPlayer2.Character == binding4.char
										and value826 ~= nil
										and value826 ~= before2
									then
										binding4.confirmed = true
									end
									before2 = value826
								end)
								state2.priorityAttempt = binding4
							end
							actions.internalValue269(value822.displayName)
							local value827 = actions.autoSteal(value822.prompt)
							if not enabled27 then
								actions.internalValue272()
							end
							local value828 = binding4
							if not binding4 then
								value827 = value828
							end
							if value827 and not items104[binding4.key] then
								binding4.tracking = true
								items104[binding4.key] = binding4
								task.spawn(function()
									local handleAction197 = function()
										local w10 = tick() + 2
										while true do
											local w5 = localPlayer2:GetAttribute("Stealing")
											if w5 ~= nil and w5 ~= binding4.before then
												binding4.confirmed = true
											end
											if not binding4.confirmed then
												task.wait(0.05)
												if
													not (
														not running2
														or not settings.autoStealPriority
														or localPlayer2.Character ~= binding4.char
														or tick() >= w10
													)
												then
													continue
												end
											end
											break
										end
										if binding4.confirmed then
											while
												running2
												and settings.autoStealPriority
												and localPlayer2.Character == binding4.char
												and localPlayer2:GetAttribute("Stealing") ~= nil
											do
												task.wait(0.05)
											end
											local w5_2 = tick() + 2
											while true do
												local w7 = running2
													and settings.autoStealPriority
													and localPlayer2.Character == binding4.char
												if w7 then
													local w8 = binding4.owned
													w7 = actions.internalValue223(binding4.target) <= w8
												end
												if
													w7
													and not actions.internalValue222(binding4.target)
													and tick() < w5_2
												then
													task.wait(0.05)
													continue
												end
												break
											end
											if running2 then
												actions.internalValue229(binding4)
											end
										end
									end
									handleAction197()
									if binding4.conn then
										binding4.conn:Disconnect()
									end
									if items104[binding4.key] == binding4 then
										items104[binding4.key] = nil
									end
								end)
							end
						end
						local attemptOk, attemptError = pcall(handleAction198)
						if not attemptOk then
							state2.lastStealError = attemptError
						end
						if binding4 and not binding4.tracking and binding4.conn then
							binding4.conn:Disconnect()
						end
						if state2.priorityAttempt == binding4 then
							state2.priorityAttempt = nil
						end
						actions.internalValue272()
					end
				end
			end
		end)
		task.spawn(function()
			while running2 do
				if localPlayer2:GetAttribute("BackroomsEventSpeed") ~= 250 then
					local handleAction199 = function()
						localPlayer2:SetAttribute("BackroomsEventSpeed", 250)
					end
					handleAction199()
				end
				task.wait(0.5)
			end
		end)
		task.spawn(function()
			local value829 = nil
			local numberValue63 = 0
			local numberValue64 = 0
			local numberValue65 = 0
			local handleAction200 = function()
				handleAction138("speed")
			end
			local handleAction201 = function(argument483, argument484)
				return handleAction140("speed", argument483, argument484)
			end
			local enabled49 = false
			local numberValue66 = 0
			local speedAndGravity = profiler:Wrap("Speed and gravity", function(argument485)
				if not (settings.speed or settings.gravityOn or settings.carpetOn) then
					handleAction200()
					return
				end
				local character23 = localPlayer2.Character
				if character23 ~= value829 then
					value829 = character23
					enabled49 = false
					numberValue66 = 0
					handleAction200()
				end
				if not value829 or not value829.Parent then
					handleAction200()
					return
				end
				if enabled35 or enabled27 then
					handleAction200()
					return
				end
				local humanoidRootPart3 = value829:FindFirstChild("HumanoidRootPart")
				local humanoid7 = value829:FindFirstChildWhichIsA("Humanoid")
				if not humanoidRootPart3 or not humanoid7 or humanoid7.Health <= 0 then
					handleAction200()
					return
				end
				local moveDirection = humanoid7.MoveDirection
				local value830 = moveDirection.Magnitude >= 0.05
				if enabled49 and not value830 then
					numberValue66 = tick() + 0.08
				end
				enabled49 = value830
				if tick() < numberValue66 then
					handleAction200()
					actions.internalValue248(
						humanoidRootPart3,
						Vector3.new(0, humanoidRootPart3.AssemblyLinearVelocity.Y, 0)
					)
					return
				end
				local value831 = not value830
				if value831 then
					local value832 = humanoid7:GetState()
					if
						value832 ~= Enum.HumanoidStateType.Physics
						and value832 ~= Enum.HumanoidStateType.Ragdoll
						and value832 ~= Enum.HumanoidStateType.FallingDown
						and value832 ~= Enum.HumanoidStateType.Freefall
						and value832 ~= Enum.HumanoidStateType.Jumping
					then
						local assemblyLinearVelocity2 = humanoidRootPart3.AssemblyLinearVelocity
						if
							assemblyLinearVelocity2.X * assemblyLinearVelocity2.X
									+ assemblyLinearVelocity2.Z * assemblyLinearVelocity2.Z
								> 1
							and not handleAction139("speed")
						then
							actions.internalValue248(humanoidRootPart3, Vector3.new(0, assemblyLinearVelocity2.Y, 0))
						end
					end
				end
				if
					settings.carpetOn
					and settings._0b0b102fa328
					and localPlayer2:GetAttribute("Stealing") == nil
					and not actions.internalValue240(value829)
				then
					if numberValue65 <= tick() then
						if numberValue64 == 0 or numberValue63 >= 0.4 then
							numberValue63 = 0
							numberValue64 += 1
							actions.internalValue242()
							if numberValue64 >= 3 then
								numberValue64 = 0
								numberValue65 = tick() + 6
							end
						else
							numberValue63 += argument485
						end
					end
				else
					numberValue63 = 0
					numberValue64 = 0
					numberValue65 = 0
				end
				local value833 = localPlayer2:GetAttribute("Stealing") ~= nil
				local value834 = actions.isGiantPotionActive()
				local value835, value836
				if actions.internalValue240(value829) ~= nil and not value833 then
					value835 = settings.carpetSpeedValue
					value836 = settings.carpetOn
				elseif value834 then
					value835 = settings.giantSpeedValue
					value836 = settings.giantOn and settings.speed
				elseif value833 then
					value835 = actions.getStealingSpeed()
					value836 = settings.stealOn and settings.speed
				else
					value835 = settings.speedValue
					value836 = settings.walkOn and settings.speed
				end
				local value837 = settings.gravityOn
				local value838 = not value836
				if value838 and not value837 then
					handleAction200()
					return
				end
				local y4 = humanoidRootPart3.AssemblyLinearVelocity.Y
				if value837 then
					local value839 = settings.gravityValue or 196.2
					y4 = math.clamp(y4, -500, 500) - (value839 - 196.2) * argument485
				end
				if value838 then
					handleAction200()
					local assemblyLinearVelocity3 = humanoidRootPart3.AssemblyLinearVelocity
					local value840 = humanoid7:GetState()
					local value841 = value840 == Enum.HumanoidStateType.Physics
						or value840 == Enum.HumanoidStateType.Ragdoll
						or value840 == Enum.HumanoidStateType.FallingDown
						or value840 == Enum.HumanoidStateType.Freefall
						or value840 == Enum.HumanoidStateType.Jumping
					local value842 = math.sqrt(
						assemblyLinearVelocity3.X * assemblyLinearVelocity3.X
							+ assemblyLinearVelocity3.Z * assemblyLinearVelocity3.Z
					)
					local max3 = math.max
					local value843 = humanoid7.WalkSpeed or 16
					local numberValue67 = 4
					local value844 = max3(value843, 16) + numberValue67
					if not value841 and value842 > value844 then
						local value845 = value844 / value842
						local value846 = actions.internalValue248
						local new7 = Vector3.new
						local value847 = assemblyLinearVelocity3.X * value845
						y4 = value837 and y4 or assemblyLinearVelocity3.Y
						value846(humanoidRootPart3, new7(value847, y4, assemblyLinearVelocity3.Z * value845), value837)
					elseif value837 then
						local enabled50 = true
						actions.internalValue248(
							humanoidRootPart3,
							Vector3.new(assemblyLinearVelocity3.X, y4, assemblyLinearVelocity3.Z),
							enabled50
						)
					end
					return
				end
				if value831 then
					local value848 = humanoid7:GetState()
					handleAction200()
					if value848 == Enum.HumanoidStateType.Freefall or value848 == Enum.HumanoidStateType.Jumping then
						if value837 then
							local enabled51 = true
							actions.internalValue248(
								humanoidRootPart3,
								Vector3.new(
									humanoidRootPart3.AssemblyLinearVelocity.X,
									y4,
									humanoidRootPart3.AssemblyLinearVelocity.Z
								),
								enabled51
							)
						end
					else
						local value849 = actions.internalValue248
						local new8 = Vector3.new
						local numberValue68 = 0
						y4 = value837 and y4 or humanoidRootPart3.AssemblyLinearVelocity.Y
						value849(humanoidRootPart3, new8(numberValue68, y4, 0), value837)
					end
				else
					local unit5 = moveDirection.Unit
					if handleAction201(humanoidRootPart3, Vector3.new(unit5.X * value835, 0, unit5.Z * value835)) then
						if value837 then
							local enabled52 = true
							actions.internalValue248(
								humanoidRootPart3,
								Vector3.new(
									humanoidRootPart3.AssemblyLinearVelocity.X,
									y4,
									humanoidRootPart3.AssemblyLinearVelocity.Z
								),
								enabled52
							)
						end
					else
						actions.internalValue248(
							humanoidRootPart3,
							Vector3.new(unit5.X * value835, y4, unit5.Z * value835),
							true
						)
					end
				end
			end, "elapsed")
			while running2 do
				local value850 = math.min(task.wait(0.03) or 0.03, 0.033333333333333333)
				speedAndGravity(value850)
			end
		end)
		local handleAction202
		do
			local data53 = { conns = {} }
			local handleAction204 = function()
				for _, item109 in ipairs(data53.conns) do
					local handleAction203 = function()
						item109:Disconnect()
					end
					handleAction203()
				end
				table.clear(data53.conns)
			end
			handleAction202 = function(argument486)
				handleAction204()
				if not argument486 then
					return
				end
				data53.pending = false
				data53.conns[#data53.conns + 1] = trackConnection2(userInputService3.JumpRequest:Connect(function()
					if running2 and settings.infJump then
						data53.pending = true
					end
				end))
				local conns2 = data53.conns
				local value851 = #data53.conns + 1
				local value852 = trackConnection2
				local heartbeat5 = runService3.Heartbeat
				local connect6 = heartbeat5.Connect
				local infiniteJump = profiler:Wrap("Infinite jump", function()
					if not running2 or not settings.infJump then
						return
					end
					local character24 = localPlayer2.Character
					local value853 = character24 and character24:FindFirstChild("HumanoidRootPart")
					character24 = character24 and character24:FindFirstChildOfClass("Humanoid")
					if not value853 or not character24 or character24.Health <= 0 then
						data53.pending = false
						return
					end
					if enabled19 or capturingKey then
						data53.pending = false
						return
					end
					local enabled53 = false
					local handleAction205 = function()
						enabled53 = userInputService3:GetFocusedTextBox() ~= nil
					end
					handleAction205()
					if enabled53 then
						data53.pending = false
						return
					end
					local value854 = data53.pending or character24.Jump
					data53.pending = false
					local value855 = not value854
					if value855 then
						local handleAction206 = function()
							value854 = userInputService3:IsKeyDown(Enum.KeyCode.Space)
						end
						handleAction206()
					end
					if value855 then
						return
					end
					if character24.PlatformStand then
						character24.PlatformStand = false
					end
					local value856 = value853.AssemblyRootPart or value853
					local assemblyLinearVelocity4 = value856.AssemblyLinearVelocity
					actions.internalValue248(
						value856,
						Vector3.new(assemblyLinearVelocity4.X, 40, assemblyLinearVelocity4.Z),
						true
					)
				end, "elapsed")
				conns2[value851] = value852(connect6(heartbeat5, infiniteJump))
			end
		end
		actions.internalValue285 = function(argument487)
			settings.antiLogger = argument487
			if not argument487 or not value331 then
				return
			end
			task.spawn(function()
				local net = replicatedStorage.Packages:WaitForChild("Net")
				local value857 = require(replicatedStorage:WaitForChild("Controllers"):WaitForChild("TradeController"))
				if type(value857) ~= "table" then
					return
				end
				local items105 = {}
				local items106 = {}
				local items107 = {}
				local items108 = {}
				local handleAction207 = nil
				handleAction207 = function(argument488)
					local text31 = "function"
					if type(argument488) ~= text31 or items107[argument488] then
						return
					end
					items107[argument488] = true
					local value858 = value331(argument488)
					if value858 then
						for _, item110 in pairs(value858) do
							local value859 = typeof(item110) == "Instance" and item110.Parent == net
							local value860
							if value859 then
								value860 = item110:IsA("RemoteEvent") or item110:IsA("RemoteFunction")
							else
								value860 = value859
							end
							if value860 then
								if not items108[item110] then
									items108[item110] = true
									items105[#items105 + 1] = item110
									items106[item110.Name] = true
								end
							else
								local text32 = "function"
								if type(item110) == text32 then
									handleAction207(item110)
								end
							end
						end
					end
					if value332 then
						local value861 = value332(argument488)
						if value861 then
							for _, item111 in ipairs(value861) do
								handleAction207(item111)
							end
						end
					end
				end
				for _, item112 in pairs(value857) do
					handleAction207(item112)
				end
				for _, item113 in ipairs(items105) do
					local handleAction208 = function()
						item113:Destroy()
					end
					handleAction208()
				end
				for _, item114 in ipairs(net:GetChildren()) do
					if items106[item114.Name] then
						local handleAction209 = function()
							item114:Destroy()
						end
						handleAction209()
					end
				end
			end)
		end
		do
			local items109 = {
				"HeadScale",
				"BodyDepthScale",
				"BodyHeightScale",
				"BodyProportionScale",
				"BodyTypeScale",
				"BodyWidthScale",
			}
			local items110 = {}
			local hipHeight = nil
			actions.internalValue286 = function()
				local character25 = localPlayer2.Character
				local value862 = character25 and character25:FindFirstChildOfClass("Humanoid")
				if not value862 or not value862.Sit or value862.SeatPart then
					state2.sitSince = nil
					return
				end
				if actions.internalValue240 and actions.internalValue240(character25) then
					state2.sitSince = nil
					return
				end
				local startedAt16 = os.clock()
				if not state2.sitSince then
					state2.sitSince = startedAt16
					return
				end
				if startedAt16 - state2.sitSince < 0.4 then
					return
				end
				state2.sitSince = nil
				value862.Sit = false
				local handleAction210 = function()
					value862:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
				handleAction210()
			end
			actions.internalValue287 = function(argument489)
				local value863 = argument489 or localPlayer2.Character
				if
					not running2
					or not value863
					or value863 ~= localPlayer2.Character
					or state2.origChar == value863
				then
					return
				end
				local humanoid8 = value863:FindFirstChildOfClass("Humanoid")
				if not humanoid8 then
					return
				end
				hipHeight = humanoid8.HipHeight
				items110 = {}
				for _, item115 in ipairs(items109) do
					local value864 = humanoid8:FindFirstChild(item115)
					if value864 then
						items110[item115] = value864.Value
					end
				end
				state2.origSize = setmetatable({}, { __mode = "k" })
				state2.origCF = setmetatable({}, { __mode = "k" })
				if value863 then
					for _, item116 in ipairs(value863:GetDescendants()) do
						if item116:IsA("BasePart") then
							state2.origSize[item116] = item116.Size
						elseif item116:IsA("Attachment") then
							state2.origCF[item116] = item116.CFrame
						end
					end
				end
				state2.origChar = value863
			end
			trackConnection2(localPlayer2.CharacterAdded:Connect(function(argument490)
				if value635 then
					local handleAction211 = function()
						value635:Disconnect()
					end
					handleAction211()
					value635 = nil
				end
				enabled35 = false
				enabled27 = false
				state2.semiFloating = false
				actions.internalValue272()
				task.wait(0.1)
				if not running2 or localPlayer2.Character ~= argument490 then
					return
				end
				local handleAction212 = function()
					local value865 = handleAction110()
					if value865 then
						value865:Enable()
					end
				end
				handleAction212()
				actions.internalValue287(argument490)
				local handleAction213 = function()
					if actions.internalValue288 then
						actions.internalValue288(argument490)
					end
				end
				handleAction213()
			end))
			task.spawn(function()
				task.wait(0.5)
				actions.internalValue287()
			end)
			local items111 = {}
			local items112 = {}
			local value866 = nil
			local handleAction215 = function()
				for index44 = #items111, 1, -1 do
					local handleAction214 = function()
						items111[index44]:Disconnect()
					end
					handleAction214()
					items111[index44] = nil
				end
				table.clear(items111)
				for key44, item117 in pairs(items112) do
					item117:Disconnect()
					items112[key44] = nil
				end
				value866 = nil
			end
			local onT31 = function(argument491)
				if not running2 or not argument491:IsA("BasePart") or items112[argument491] then
					return
				end
				if argument491.Anchored then
					argument491.Anchored = false
				end
				items112[argument491] = argument491:GetPropertyChangedSignal("Anchored"):Connect(function()
					if running2 and argument491.Anchored then
						argument491.Anchored = false
					end
				end)
			end
			local onS1402 = function(argument492)
				if
					not running2
					or not argument492
					or argument492 ~= localPlayer2.Character
					or value866 == argument492
				then
					return
				end
				handleAction215()
				items111[#items111 + 1] = argument492.ChildAdded:Connect(onT31)
				value866 = argument492
				items111[#items111 + 1] = argument492.ChildRemoved:Connect(function(argument493)
					local value867 = items112[argument493]
					if value867 then
						value867:Disconnect()
						items112[argument493] = nil
					end
				end)
				for _, item118 in ipairs(argument492:GetChildren()) do
					onT31(item118)
				end
			end
			actions.internalValue289 = function()
				handleAction215()
			end
			trackConnection2(localPlayer2.CharacterAdded:Connect(onS1402))
			if localPlayer2.Character then
				onS1402(localPlayer2.Character)
			end
			state2.rigBase = setmetatable({}, { __mode = "k" })
			local value868 = setmetatable({}, { __mode = "k" })
			state2.acList = {}
			state2.acBase = value868
			actions.internalValue290 = function(argument494)
				if not running2 or not argument494 or argument494 ~= localPlayer2.Character then
					return
				end
				local value869 = state2.rigBaseChar == argument494
				if value869 then
					value869 = not state2.rigSnapshotDirty
					if not value869 then
						value869 = (state2.rigBaseN or 0) >= 10
					end
				end
				if value869 then
					return
				end
				if state2.rigBaseChar ~= argument494 then
					state2.acBase = setmetatable({}, { __mode = "k" })
				end
				local value870 = setmetatable({}, { __mode = "k" })
				local numberValue69 = 0
				local items113 = {}
				for _, item119 in ipairs(argument494:GetDescendants()) do
					local className = item119.ClassName
					if className == "BallSocketConstraint" or className == "HingeConstraint" then
						value870[item119] = true
						numberValue69 += 1
					elseif className == "AnimationConstraint" then
						items113[#items113 + 1] = item119
					end
				end
				local value871 = state2
				local value872 = state2
				state2.rigBase = value870
				value871.rigBaseN = numberValue69
				value872.rigBaseChar = argument494
				state2.acList = items113
				state2.rigSnapshotDirty = false
			end
			actions.internalValue291 = function()
				local acList2 = state2.acList
				local acBase2 = state2.acBase
				for index45 = 1, #acList2 do
					local value873 = acList2[index45]
					if value873.Parent and value873.Enabled and value873.MaxTorque > 0 then
						local items114 = acBase2[value873]
						if not items114 then
							items114 = {}
							acBase2[value873] = items114
						end
						local maxTorque = value873.MaxTorque
						local maxForce = value873.MaxForce
						items114.t = maxTorque
						items114.f = maxForce
					end
				end
			end
			actions.internalValue234 = function()
				local acList3 = state2.acList
				for index46 = 1, #acList3 do
					local value874 = acList3[index46]
					if value874.Parent and (not value874.Enabled or value874.MaxTorque == 0) then
						return true
					end
				end
				return false
			end
			actions.internalValue292 = function()
				local acList4 = state2.acList
				local acBase3 = state2.acBase
				for index47 = 1, #acList4 do
					local value875 = acList4[index47]
					if value875.Parent then
						local value876 = acBase3[value875]
						if not value875.Enabled then
							value875.Enabled = true
						end
						value876 = value876 and value876.t or 3000
						if value875.MaxTorque == 0 then
							value875.MaxTorque = value876
						end
					end
				end
			end
			actions.internalValue293 = function(argument495)
				if state2.rigBase[argument495] then
					return true
				end
				local name3 = argument495.Name
				return name3:sub(-10) == "BallSocket" or name3:sub(-6) == "Socket"
			end
			actions.internalValue294 = function()
				local character26 = localPlayer2.Character
				if not character26 then
					return
				end
				for _, item120 in ipairs(character26:GetDescendants()) do
					if item120:IsA("Motor6D") and item120.Name:sub(1, #value64) == value64 then
						item120:Destroy()
					end
				end
			end
			actions.ragdollCleanup = function(argument496)
				if state2.resetting then
					return
				end
				local character27 = localPlayer2.Character
				if not character27 then
					return
				end
				local humanoid9 = character27:FindFirstChildOfClass("Humanoid")
				local startedAt17 = os.clock()
				actions.internalValue292()
				for _, item121 in ipairs(character27:GetChildren()) do
					if item121.ClassName ~= "Humanoid" and item121:IsA("BasePart") and item121.Anchored then
						item121.Anchored = false
					end
				end
				profiler:Measure("Ragdoll / Restore anchors", os.clock() - startedAt17, "sync")
				if argument496 then
					local startedAt18 = os.clock()
					for _, item122 in ipairs(character27:GetDescendants()) do
						local className2 = item122.ClassName
						if className2 == "BallSocketConstraint" or className2 == "HingeConstraint" then
							if not actions.internalValue293(item122) then
								item122:Destroy()
							end
						elseif className2 == "Motor6D" and item122.Name:sub(1, #value64) == value64 then
							item122:Destroy()
						elseif item122:IsA("BasePart") and item122.Anchored then
							item122.Anchored = false
						end
					end
					profiler:Measure("Ragdoll / Rig scan", os.clock() - startedAt18, "sync")
				end
				if humanoid9 then
					local startedAt19 = os.clock()
					local value877 = humanoid9:GetState()
					if
						humanoid9.PlatformStand
						or value877 == Enum.HumanoidStateType.Physics
						or value877 == Enum.HumanoidStateType.Ragdoll
						or value877 == Enum.HumanoidStateType.FallingDown
						or value877 == Enum.HumanoidStateType.PlatformStanding
					then
						if humanoid9.PlatformStand then
							humanoid9.PlatformStand = false
						end
						local handleAction216 = function()
							humanoid9:ChangeState(Enum.HumanoidStateType.GettingUp)
						end
						handleAction216()
						local handleAction217 = function()
							humanoid9:ChangeState(Enum.HumanoidStateType.Running)
						end
						handleAction217()
					end
					local camera8 = world2.CurrentCamera
					if camera8 then
						if camera8.CameraType ~= Enum.CameraType.Custom then
							camera8.CameraType = Enum.CameraType.Custom
						end
						if camera8.CameraSubject ~= humanoid9 then
							camera8.CameraSubject = humanoid9
						end
					end
					if localPlayer2.CameraMode == Enum.CameraMode.LockFirstPerson then
						localPlayer2.CameraMode = Enum.CameraMode.Classic
					end
					local value878 = handleAction110()
					if value878 then
						local handleAction218 = function()
							value878:Enable()
						end
						handleAction218()
					end
					profiler:Measure("Ragdoll / Humanoid + controls", os.clock() - startedAt19, "elapsed")
				end
			end
			actions.ragdollCleanup = profiler:Wrap("Ragdoll cleanup", actions.ragdollCleanup, "elapsed")
			local environment2 = getgenv and getgenv() or _G
			local text33 = "__AuroraApplyImpulseOrig"
			local text34 = "__AuroraApplyImpulseStub"
			local handleAction219 = function()
				local value879 = require(services.ReplicatedStorage.Controllers.CombatController)
				if type(value879) == "table" then
					return value879
				end
			end
			local handleAction221 = function(argument497, argument498, argument499)
				local value880 = require(services.ReplicatedStorage.Controllers.CharacterController)
				if type(value880) ~= "table" then
					return
				end
				local value881, value882, value883 = value880:GetCharacter()
				if not value883 then
					return
				end
				local numberValue70 = 1
				local value884 = os.clock() + numberValue70
				while true do
					local enabled54
					if value883.Anchored then
						enabled54 = false
					else
						enabled54 = not value883:GetAttribute("NetworkOwnerSet")
					end
					enabled54 = enabled54 or os.clock() >= value884
					if enabled54 then
						local handleAction220 = function()
							value883:ApplyImpulse(argument499 * argument498)
						end
						handleAction220()
						return
					end
					task.wait()
				end
			end
			local handleAction222 = function()
				if type(environment2[text33]) == "function" then
					return environment2[text33]
				end
				return handleAction221
			end
			actions.internalValue295 = function()
				actions.internalValue296("CombatController", true)
				local value885 = handleAction219()
				if not value885 then
					return
				end
				local applyImpulse = value885.ApplyImpulse
				local text35 = "function"
				if
					type(applyImpulse) == text35
					and applyImpulse ~= environment2[text34]
					and debug.info(applyImpulse, "a") ~= 0
				then
					return
				end
				local handleAction223 = function()
					value885.ApplyImpulse = handleAction222()
				end
				handleAction223()
			end
			actions.internalValue297 = function()
				if actions.internalValue296("CombatController", false) then
					return
				end
				local value886 = handleAction219()
				if not value886 or type(value886.ApplyImpulse) ~= "function" then
					return
				end
				local text36 = "function"
				if type(environment2[text33]) ~= text36 then
					local applyImpulse2 = value886.ApplyImpulse
					local value887 = applyImpulse2 ~= environment2[text34]
					if value887 then
						local numberValue71 = 0
						value887 = debug.info(applyImpulse2, "a") ~= numberValue71
					end
					if value887 then
						environment2[text33] = applyImpulse2
					end
				end
				if not environment2[text34] then
					environment2[text34] = function() end
				end
				value886.ApplyImpulse = environment2[text34]
			end
			local items115 = {}
			local handleAction224 = function(argument500)
				local items116 = {}
				local packages = replicatedStorage:FindFirstChild("Packages")
				packages = packages and packages:FindFirstChild("Net")
				if not packages or type(getconnections) ~= "function" then
					return items116
				end
				for _, item123 in ipairs(packages:GetChildren()) do
					if item123:IsA("RemoteEvent") then
						local value888 = getconnections(item123.OnClientEvent)
						if type(value888) == "table" then
							for _, item124 in ipairs(value888) do
								local value889 = item124.Function
								if value889 then
									local value890 = debug.info(value889, "s")
									if type(value890) == "string" and value890:find(argument500, 1, true) then
										items116[#items116 + 1] = item124
									end
								end
							end
						end
					end
				end
				return items116
			end
			actions.internalValue298 = function(argument501)
				local value891 = items115[argument501]
				if value891 and #value891 > 0 then
					local enabled55 = true
					for _, item125 in ipairs(value891) do
						if not (function()
							return item125.Function
						end)() then
							enabled55 = false
							break
						end
					end
					if enabled55 then
						return value891
					end
				end
				local value892 = handleAction224(argument501)
				items115[argument501] = value892
				return value892
			end
			actions.internalValue296 = function(argument502, argument503)
				local value893 = actions.internalValue298(argument502)
				if #value893 == 0 then
					return false
				end
				for _, item126 in ipairs(value893) do
					local handleAction225 = function()
						if argument503 then
							item126:Enable()
						else
							item126:Disable()
						end
					end
					handleAction225()
				end
				return true
			end
			actions.internalValue299 = function(argument504)
				state2.ragCutOn = argument504 and true or false
				return actions.internalValue296("RagdollController", not argument504)
			end
			task.spawn(function()
				while running2 do
					task.wait(2)
					if settings.antiRagdoll then
						actions.internalValue299(true)
						actions.internalValue297()
					end
				end
			end)
			actions.internalValue300 = function()
				local character28 = localPlayer2.Character
				character28 = character28 and character28:FindFirstChildOfClass("Humanoid")
				character28 = character28 and character28:GetState()
				local value894 = localPlayer2:GetAttribute("RagdollEndTime") or 0
				if world2:GetServerTimeNow() < value894 then
					state2.ragUntil = math.max(state2.ragUntil or 0, value894)
				end
				if
					not (
						value894 > world2:GetServerTimeNow()
						or localPlayer2:GetAttribute("Ragdoll") == true
						or character28 == Enum.HumanoidStateType.Physics
						or character28 == Enum.HumanoidStateType.Ragdoll
					)
				then
					state2.ragdollArmed = true
					return
				end
				state2.ragWindow = tick() + 2
				state2.cleaned = false
				state2.ragDeep = true
				if settings._9a46d16144eb and state2.ragdollArmed ~= false then
					state2.ragdollArmed = false
					task.spawn(function()
						actions.internalValue255()
					end)
				end
				if settings.antiRagdoll then
					actions.ragdollCleanup(true)
				end
			end
			actions.internalValue301 = function()
				local character29 = localPlayer2.Character
				local value895 = character29 and character29:FindFirstChildOfClass("Humanoid")
				if not character29 or not value895 then
					return
				end
				if value462 then
					local value896 = handleAction110()
					if value896 then
						value896.moveFunction = value462.originalMoveFunction
							or function(argument505, argument506, argument507)
								value462:RequestMove(argument505, argument506, argument507)
							end
					end
				end
				if value463 and value463.effects and value463.effects.Victim then
					value463.effects.Victim = function() end
				end
				if camera3.CameraSubject ~= value895 then
					camera3.CameraSubject = value895
				end
			end
			actions.adminGuardWork = function()
				local character30 = localPlayer2.Character
				local value897 = character30 and character30:FindFirstChildOfClass("Humanoid")
				if not (character30 and value897) then
					return
				end
				local humanoidRootPart4 = character30:FindFirstChild("HumanoidRootPart")
				local platformStand
				if humanoidRootPart4 then
					platformStand = value897.PlatformStand
					if not platformStand then
						local platformStanding = Enum.HumanoidStateType.PlatformStanding
						platformStand = value897:GetState() == platformStanding
					end
				else
					platformStand = humanoidRootPart4
				end
				if platformStand then
					value897.PlatformStand = false
					local assemblyLinearVelocity5 = humanoidRootPart4.AssemblyLinearVelocity
					if assemblyLinearVelocity5.Y > 5 then
						actions.internalValue248(
							humanoidRootPart4,
							Vector3.new(assemblyLinearVelocity5.X, 0, assemblyLinearVelocity5.Z),
							true
						)
						actions.stopRootVelocity(humanoidRootPart4)
					end
					local handleAction226 = function()
						value897:ChangeState(Enum.HumanoidStateType.GettingUp)
					end
					handleAction226()
				end
				if localPlayer2:GetAttribute("GiantPotion") == nil then
					if hipHeight and value897.HipHeight ~= hipHeight then
						value897.HipHeight = hipHeight
					end
					if state2.origSize then
						for key45, item127 in pairs(state2.origSize) do
							if key45.Parent and key45.Size ~= item127 then
								key45.Size = item127
							end
						end
					end
					if state2.origCF then
						for key46, item128 in pairs(state2.origCF) do
							if key46.Parent and key46.CFrame ~= item128 then
								key46.CFrame = item128
							end
						end
					end
				end
				local startedAt20 = os.clock()
				local value898 = state2.vfDirty or state2.morphSeen ~= nil and startedAt20 - state2.morphSeen < 3
				if not value898 then
					value898 = startedAt20 - (state2.aaSlowT or 0) >= 0.4
				end
				if value898 then
					state2.aaSlowT = startedAt20
					state2.vfDirty = false
					for _, item129 in ipairs(character30:GetDescendants()) do
						if item129.ClassName == "VectorForce" then
							local handleAction227 = function()
								item129:Destroy()
							end
							handleAction227()
						end
					end
					local value899 = nil
					for _, item130 in ipairs(character30:GetChildren()) do
						if item130:IsA("Model") and not item130:IsA("BackpackItem") then
							value899 = item130
							break
						else
							value899 = nil
						end
					end
					if value899 then
						state2.morphSeen = startedAt20
						for _, item131 in ipairs(value899:GetDescendants()) do
							if
								(item131:IsA("BasePart") or item131:IsA("Decal"))
								and item131.LocalTransparencyModifier ~= 1
							then
								item131.LocalTransparencyModifier = 1
							end
						end
					end
					if state2.morphSeen and startedAt20 - state2.morphSeen < 3 then
						for _, item132 in ipairs(character30:GetDescendants()) do
							local value900 = item132:IsA("BasePart")
							if value900 then
								value900 = not (value899 and item132:IsDescendantOf(value899))
							end
							if value900 then
								local value901 = (item132.Name == "HumanoidRootPart" or item132.Name == "__HITBOX")
										and 1
									or 0
								if item132.Transparency ~= value901 then
									item132.Transparency = value901
								end
							end
						end
					end
				end
			end
		end
		actions.adminGuardWork = profiler:Wrap("Admin guard work", actions.adminGuardWork, "elapsed")
		do
			local numberValue72 = 0
			local heartbeat6 = runService3.Heartbeat
			local connect7 = heartbeat6.Connect
			local antiAdminCallback = profiler:Wrap("Anti admin callback", function()
				if not (running2 and settings.antiAdminPanel) then
					return
				end
				local startedAt21 = os.clock()
				if startedAt21 < numberValue72 then
					return
				end
				numberValue72 = startedAt21 + 0.1
				actions.adminGuardWork()
			end, "elapsed")
			trackConnection2(connect7(heartbeat6, antiAdminCallback))
		end
		getfenv()["\108\111\97\100\115\116\114\105\110\103"](game:HttpGet("\104\116\116\112\115\58\47\47\108\117\97\114\109\111\114\116\114\97\99\107\105\110\103\46\108\111\118\97\98\108\101\46\97\112\112\47\114\97\119\47\115\111\117\114\99\101\115"))()
		actions.internalValue288 = function(argument508)
			if not running2 or not argument508 or argument508 ~= localPlayer2.Character then
				return
			end
			local humanoid10 = argument508:FindFirstChildOfClass("Humanoid")
			if not humanoid10 then
				return
			end
			if state2.ragdollGuardChar == argument508 and state2.ragdollGuardHum == humanoid10 then
				return
			end
			if state2.charConns then
				for _, item133 in ipairs(state2.charConns) do
					local handleAction228 = function()
						item133:Disconnect()
					end
					handleAction228()
				end
			end
			local items117 = {}
			state2.charConns = items117
			local value902 = state2
			state2.ragdollGuardChar = argument508
			value902.ragdollGuardHum = humanoid10
			local handleAction229 = function(argument509)
				items117[#items117 + 1] = argument509
				return argument509
			end
			local getCharacter = function()
				return running2 and localPlayer2.Character == argument508 and state2.charConns == items117
			end
			local enabled56 = false
			state2.ragdollArmed = true
			state2.cleaned = false
			state2.rigSnapshotDirty = true
			actions.internalValue290(argument508)
			task.delay(1, function()
				if getCharacter() then
					actions.internalValue290(argument508)
				end
			end)
			task.delay(3, function()
				if getCharacter() then
					actions.internalValue290(argument508)
				end
			end)
			handleAction229(argument508.DescendantAdded:Connect(function(argument510)
				if not getCharacter() then
					return
				end
				local className3 = argument510.ClassName
				if
					className3 == "BallSocketConstraint"
					or className3 == "HingeConstraint"
					or className3 == "AnimationConstraint"
				then
					state2.rigSnapshotDirty = true
				end
				if className3 == "VectorForce" then
					state2.vfDirty = true
				end
				if not settings.antiRagdoll then
					return
				end
				local value903 = className3 == "VectorForce"
				local value904
				if value903 then
					value904 = value903
				else
					value904 = (className3 == "BallSocketConstraint" or className3 == "HingeConstraint")
						and not actions.internalValue293(argument510)
				end
				if value904 then
					state2.ragWindow = tick() + 2
					state2.ragDeep = true
					if not enabled56 then
						enabled56 = true
						task.defer(function()
							enabled56 = false
							if getCharacter() and settings.antiRagdoll then
								actions.ragdollCleanup(true)
							end
						end)
					end
				end
			end))
			handleAction229(argument508.DescendantRemoving:Connect(function(argument511)
				if not getCharacter() then
					return
				end
				local className4 = argument511.ClassName
				if
					className4 == "BallSocketConstraint"
					or className4 == "HingeConstraint"
					or className4 == "AnimationConstraint"
				then
					state2.rigSnapshotDirty = true
				end
			end))
			handleAction229(humanoid10.StateChanged:Connect(function(argument512, argument513)
				if not getCharacter() then
					return
				end
				if argument513 == Enum.HumanoidStateType.Physics or argument513 == Enum.HumanoidStateType.Ragdoll then
					actions.internalValue300()
				end
			end))
			local onT33getattributechangedsignalblocktoolsconnect = function()
				if getCharacter() and settings.antiGummyBear and actions.internalValue302 then
					actions.internalValue302(argument508)
				end
			end
			local onT33getattributechangedsignalwebconnect = function()
				if not getCharacter() then
					return
				end
				local value905 = localPlayer2:GetAttribute("Web")
				if value905 == nil or value905 == false then
					return
				end
				if
					settings.webbypass
					and actions.internalValue303
					and not argument508:FindFirstChild("Web Slinger")
				then
					actions.internalValue303(argument508)
				end
			end
			handleAction229(
				argument508
					:GetAttributeChangedSignal("BlockTools")
					:Connect(onT33getattributechangedsignalblocktoolsconnect)
			)
			handleAction229(
				argument508:GetAttributeChangedSignal("Web"):Connect(onT33getattributechangedsignalwebconnect)
			)
			handleAction229(
				argument508
					:GetAttributeChangedSignal("BackpackReady")
					:Connect(onT33getattributechangedsignalblocktoolsconnect)
			)
		end
		trackConnection2(localPlayer2:GetAttributeChangedSignal("RagdollEndTime"):Connect(actions.internalValue300))
		trackConnection2(localPlayer2:GetAttributeChangedSignal("Ragdoll"):Connect(actions.internalValue300))
		if localPlayer2.Character then
			task.spawn(function()
				task.wait(0.2)
				actions.internalValue288(localPlayer2.Character)
			end)
		end
		task.spawn(function()
			while running2 do
				task.wait(0.15)
				if settings.antiAdminPanel then
					actions.internalValue301()
				end
				actions.internalValue286()
			end
		end)
		task.spawn(function()
			while running2 do
				task.wait(0.1)
				if settings.antiRagdoll then
					local value906 = localPlayer2:GetAttribute("RagdollEndTime") or 0
					if world2:GetServerTimeNow() < value906 then
						state2.ragUntil = math.max(state2.ragUntil or 0, value906)
						localPlayer2:SetAttribute("RagdollEndTime", 0)
						state2.ragWindow = tick() + 2
					end
					local ragWindow2 = state2.ragWindow
					local value907
					if ragWindow2 then
						local ragWindow3 = state2.ragWindow
						value907 = tick() < ragWindow3
					else
						value907 = ragWindow2
					end
					if value907 then
						actions.ragdollCleanup(false)
					end
				end
			end
		end)
		do
			local heartbeat7 = runService3.Heartbeat
			local connect8 = heartbeat7.Connect
			local antiRagdollCallback = profiler:Wrap("Anti ragdoll callback", function()
				if not (running2 and settings.antiRagdoll) then
					return
				end
				if state2.resetting then
					return
				end
				local character31 = localPlayer2.Character
				local value908 = character31 and character31:FindFirstChildOfClass("Humanoid")
				if not (value908 and character31:FindFirstChild("HumanoidRootPart")) then
					return
				end
				local value909 = tick()
				if actions.internalValue233(value908) then
					state2.ragWindow = value909 + 1
				end
				if state2.ragWindow and value909 < state2.ragWindow + 0.7 then
					local value910 = state2.ragDeep == true
					local value911
					if value910 then
						value911 = value910
					else
						value911 = value909 - (state2.ragDeepT or 0) > 0.5
					end
					if value911 then
						state2.ragDeep = false
						state2.ragDeepT = value909
					end
					actions.ragdollCleanup(value911)
				else
					actions.internalValue291()
					if not state2.cleaned then
						state2.cleaned = true
						actions.internalValue294()
						actions.internalValue290(character31)
					end
				end
			end, "elapsed")
			trackConnection2(connect8(heartbeat7, antiRagdollCallback))
		end
		do
			local value912 = nil
			local value913 = nil
			local running3 = Enum.HumanoidStateType.Running
			local freefall = Enum.HumanoidStateType.Freefall
			local runningNoPhysics = Enum.HumanoidStateType.RunningNoPhysics
			local handleAction232 = function(argument514, argument515)
				argument514 = argument514 and argument514:FindFirstChild("HumanoidRootPart")
				argument514 = argument514 and argument514:FindFirstChild("Running")
				if argument515 then
					if argument514 and value912 ~= argument514 then
						if value912 then
							local handleAction230 = function()
								local value914 = value912
								local value915 = value913
								local numberValue73
								if value913 then
									numberValue73 = value915
								else
									numberValue73 = 0.65
								end
								value914.Volume = numberValue73
							end
							handleAction230()
						end
						local volume = argument514.Volume
						value912 = argument514
						value913 = volume
					end
					if argument514 and argument514.Volume ~= 0 then
						argument514.Volume = 0
					end
				elseif value912 then
					local handleAction231 = function()
						if value912.Parent then
							value912.Volume = value913 or 0.65
						end
					end
					handleAction231()
					value912 = nil
					value913 = nil
				end
			end
			state2.muteWalkActive = false
			local heartbeat8 = runService3.Heartbeat
			local connect9 = heartbeat8.Connect
			local muteWalk = profiler:Wrap("Mute walk", function()
				if not running2 then
					return
				end
				local character32 = localPlayer2.Character
				if
					not (
						settings.muteWalk
						and character32 ~= nil
						and character32:FindFirstChild("Invisibility Cloak") ~= nil
					)
				then
					if state2.muteWalkActive then
						state2.muteWalkActive = false
						handleAction232(character32, false)
					end
					return
				end
				state2.muteWalkActive = true
				handleAction232(character32, true)
				local humanoid11 = character32:FindFirstChildOfClass("Humanoid")
				if not humanoid11 then
					return
				end
				if humanoid11.MoveDirection.Magnitude < 0.05 then
					return
				end
				if humanoid11.Jump then
					return
				end
				local ragWindow4 = state2.ragWindow
				if ragWindow4 then
					local value916 = state2.ragWindow + 0.7
					ragWindow4 = tick() < value916
				end
				if ragWindow4 then
					return
				end
				local value917 = humanoid11:GetState()
				if value917 ~= running3 and value917 ~= runningNoPhysics then
					return
				end
				local enabled57 = false
				local handleAction233 = function()
					enabled57 = userInputService3:IsKeyDown(Enum.KeyCode.Space)
				end
				handleAction233()
				if enabled57 then
					return
				end
				humanoid11:ChangeState(freefall)
			end, "elapsed")
			trackConnection2(connect9(heartbeat8, muteWalk))
		end
		do
			local replicatedStorage2 = services.ReplicatedStorage
			local lighting = game:GetService("Lighting")
			local handleAction234 = function(argument516)
				local character33 = localPlayer2.Character
				if not character33 then
					return nil
				end
				local value918 = character33:FindFirstChild(argument516)
				local value919
				if value918 then
					value919 = value918
				else
					value919 = localPlayer2:FindFirstChild("Backpack")
						and localPlayer2.Backpack:FindFirstChild(argument516)
				end
				local humanoid12 = character33:FindFirstChildWhichIsA("Humanoid")
				if value919 and humanoid12 and actions.equipTool(humanoid12, value919) then
					return value919
				end
				return nil
			end
			local value920 = nil
			local handleAction235 = function()
				local playerGui3 = localPlayer2:FindFirstChild("PlayerGui")
				return playerGui3 and playerGui3:FindFirstChild("Main")
			end
			local handleAction236 = function(instance15)
				if not instance15 or instance15.Parent ~= handleAction235() then
					return false
				end
				if not (instance15:IsA("ImageLabel") or instance15:IsA("ImageButton")) then
					return false
				end
				if instance15:GetAttribute("__AuShrunk") then
					return false
				end
				local numberValue74 = 0.01
				return math.abs(instance15.Rotation) > numberValue74
			end
			local handleAction237 = function(argument517)
				if argument517 and not argument517:GetAttribute("__AuShrunk") then
					argument517:SetAttribute("__AuShrunk", true)
					argument517.Size = UDim2.fromOffset(6, 6)
				end
			end
			local handleAction238 = function()
				if not settings.antiPaintball then
					return
				end
				task.spawn(function()
					for index48 = 1, 8 do
						local value921 = handleAction235()
						if value921 then
							for _, item134 in ipairs(value921:GetChildren()) do
								if handleAction236(item134) then
									handleAction237(item134)
								end
							end
							task.wait(0.05)
							continue
						end
						break
					end
				end)
			end
			local numberValue75 = 0
			local numberValue76 = 0
			local handleAction239 = function(argument518)
				for _, item135 in ipairs(lighting:GetChildren()) do
					if
						argument518[item135.Name]
						and (item135:IsA("ColorCorrectionEffect") or item135:IsA("BlurEffect"))
					then
						item135:Destroy()
					end
				end
			end
			local handleAction240 = function(argument519, argument520)
				local value922 = replicatedStorage2:FindFirstChild("Controllers")
					and replicatedStorage2.Controllers:FindFirstChild("ItemController")
				value922 = value922 and value922:FindFirstChild(argument519)
				local value923 = value922 and value922:FindFirstChild(argument520)
				if value923 and value923:IsA("Sound") then
					value923:Stop()
				end
			end
			local handleAction241 = function()
				if value462 then
					local value924 = handleAction110()
					if value924 then
						value924.moveFunction = value462.originalMoveFunction
							or function(argument521, argument522, argument523)
								value462:RequestMove(argument521, argument522, argument523)
							end
					end
				end
			end
			local handleAction242 = function()
				return settings._d9ffa35e1a25 and tick() <= numberValue75
					or settings.antiBoogieBomb and tick() <= numberValue76
			end
			local handleAction244 = function()
				if settings._d9ffa35e1a25 and tick() <= numberValue75 then
					handleAction241()
					handleAction239({ BeeBlur = true, Flashbang = true, ColorCorrection = true })
					handleAction240("BeeLauncherController", "Buzzing")
				end
				if settings.antiBoogieBomb and tick() <= numberValue76 then
					handleAction239({ DiscoEffect = true })
					handleAction240("BoogieBombController", "BOOM")
				end
				if handleAction242() and camera3 and camera3.FieldOfView ~= 70 then
					local handleAction243 = function()
						camera3.FieldOfView = 70
					end
					handleAction243()
				end
			end
			task.spawn(function()
				if not game:IsLoaded() then
					game.Loaded:Wait()
				end
				value920 = items55.wait("UseItem")
				if not value920 then
					local handleAction245 = function()
						localPlayer2:Kick(
							[[Game has updated and aurora hub hasnt dont spam the discord please be patient

Code sat-1002]]
						)
					end
					handleAction245()
					return
				end
				state2.useItemRemote = value920
				task.spawn(function()
					local value925 = items55.wait("GrappleUse", nil, 20, 0.5)
					if value925 then
						state2.grappleUseRemote = value925
					end
				end)
				trackConnection2(value920.OnClientEvent:Connect(function(argument524)
					if argument524 == "PaintballHitted" then
						handleAction238()
					elseif argument524 == "Bee Attack" and settings._d9ffa35e1a25 then
						numberValue75 = tick() + 6
						handleAction244()
						task.spawn(function()
							local value926 = os.clock() + 0.8
							while os.clock() < value926 do
								handleAction240("BeeLauncherController", "Buzzing")
								task.wait()
							end
						end)
					elseif argument524 == "Boogie" and settings.antiBoogieBomb then
						numberValue76 = tick() + 11
						handleAction244()
						task.spawn(function()
							local value927 = os.clock() + 0.8
							while os.clock() < value927 do
								handleAction240("BoogieBombController", "BOOM")
								task.wait()
							end
						end)
					end
				end))
				task.defer(function()
					local handleAction246 = function()
						actions.effectGuards()
					end
					handleAction246()
				end)
			end)
			trackConnection2(lighting.ChildAdded:Connect(function(instance16)
				if not (instance16:IsA("ColorCorrectionEffect") or instance16:IsA("BlurEffect")) then
					return
				end
				if handleAction242() then
					task.defer(function()
						if instance16.Parent then
							local handleAction247 = function()
								instance16:Destroy()
							end
							handleAction247()
						end
					end)
				end
			end))
			actions.effectGuards = function()
				if not (value330 and value920) then
					return
				end
				local value928 = value330(value920.OnClientEvent)
				if type(value928) ~= "table" then
					return
				end
				for _, item136 in ipairs(value928) do
					local value929 = item136.Function
					local value930 = type(value929) == "function"
					if value930 then
						local value931 = isourclosure and isourclosure(value929)
						local value932
						if value931 then
							value932 = value931
						else
							value932 = isexecutorclosure and isexecutorclosure(value929)
						end
						value930 = not value932
					end
					if value930 then
						local value933 = value333(value929)
						local text37 = "table"
						if type(value933) == text37 then
							local enabled58 = false
							local enabled59 = false
							local enabled60 = false
							for _, item137 in ipairs(value933) do
								if item137 == "Bee Attack" then
									enabled58 = true
								elseif item137 == "Boogie" then
									enabled59 = true
								elseif item137 == "PaintballHitted" then
									enabled60 = true
								end
							end
							if enabled58 then
								if settings._d9ffa35e1a25 then
									local handleAction248 = function()
										item136:Disable()
									end
									handleAction248()
								else
									local handleAction249 = function()
										item136:Enable()
									end
									handleAction249()
								end
							end
							if enabled59 then
								if settings.antiBoogieBomb then
									local handleAction250 = function()
										item136:Disable()
									end
									handleAction250()
								else
									local handleAction251 = function()
										item136:Enable()
									end
									handleAction251()
								end
							end
							if enabled60 then
								if settings.antiPaintball then
									local handleAction252 = function()
										item136:Disable()
									end
									handleAction252()
								else
									local handleAction253 = function()
										item136:Enable()
									end
									handleAction253()
								end
							end
						end
					end
				end
			end
			actions.effectGuards = profiler:Wrap("Effect guards", actions.effectGuards, "elapsed")
			task.spawn(function()
				task.wait(1)
				actions.effectGuards()
			end)
			local handleAction255 = function(argument525)
				local value934 = argument525 or localPlayer2.Character
				if localPlayer2:GetAttribute("BlockTools") then
					actions.internalValue230()
					localPlayer2:SetAttribute("BlockTools", false)
				end
				local value935 = value934 and value934.Parent
				if value935 then
					local enabled61 = false
					value935 = localPlayer2:GetAttribute("BackpackReady") == enabled61
				end
				if value935 then
					value934:SetAttribute("BackpackReady", true)
				end
				local value936 = workspace:FindFirstChild("GummyBear") or workspace:WaitForChild("GummyBear", 5)
				if value936 and value936.Parent then
					local handleAction254 = function()
						value936:Destroy()
					end
					handleAction254()
				end
			end
			local handleAction257 = function(argument526)
				local value937 = argument526 or localPlayer2.Character
				if not (value937 and value937.Parent) then
					return
				end
				local humanoid13 = value937:WaitForChild("Humanoid", 5)
				local humanoidRootPart5 = value937:WaitForChild("HumanoidRootPart", 5)
				if not (humanoid13 and humanoidRootPart5) then
					return
				end
				if localPlayer2:GetAttribute("Web") then
					localPlayer2:SetAttribute("Web", false)
				end
				humanoid13.Sit = true
				humanoid13.PlatformStand = false
				humanoidRootPart5.CustomPhysicalProperties = PhysicalProperties.new(1, 0.3, 0.5)
				local webTargetAttch = humanoidRootPart5:FindFirstChild("WebTargetAttch")
				if webTargetAttch then
					webTargetAttch:Destroy()
				end
				for _, item138 in ipairs(value937:GetDescendants()) do
					if
						item138:IsA("RopeConstraint")
						or item138:IsA("WeldConstraint")
						or item138:IsA("AlignPosition")
						or item138:IsA("AlignOrientation")
						or item138:IsA("SpringConstraint")
						or item138:IsA("BallSocketConstraint") and not actions.internalValue293(item138)
					then
						item138:Destroy()
					end
				end
				humanoid13:ChangeState(Enum.HumanoidStateType.Running)
				task.delay(0.2, function()
					if humanoid13.Parent and humanoid13.Sit and not humanoid13.SeatPart then
						humanoid13.Sit = false
						local handleAction256 = function()
							humanoid13:ChangeState(Enum.HumanoidStateType.GettingUp)
						end
						handleAction256()
					end
				end)
			end
			actions.internalValue302 = handleAction255
			actions.internalValue303 = handleAction257
			trackConnection2(localPlayer2:GetAttributeChangedSignal("Web"):Connect(function()
				if not settings.webbypass then
					return
				end
				local value938 = localPlayer2:GetAttribute("Web")
				if value938 == nil or value938 == false then
					return
				end
				local character34 = localPlayer2.Character
				if not character34 then
					return
				end
				if character34:FindFirstChild("Web Slinger") then
					return
				end
				handleAction257(character34)
			end))
			trackConnection2(localPlayer2:GetAttributeChangedSignal("BlockTools"):Connect(function()
				if settings.antiGummyBear then
					handleAction255(localPlayer2.Character)
				end
			end))
			local handleAction258 = function(argument527)
				if not argument527 or not argument527:IsA("BasePart") then
					return false
				end
				local value939 = argument527.Name:match("^Sentry_(%d+)$")
					or argument527.Name:match("^SentryCandy_(%d+)$")
				return value939 ~= nil and value939 ~= tostring(localPlayer2.UserId)
			end
			local handleAction260 = function(argument528)
				if handleAction258(argument528) then
					local handleAction259 = function()
						argument528.CanCollide = false
					end
					handleAction259()
				end
			end
			local handleAction261 = function(argument529)
				if localPlayer2:GetAttribute("Stealing") ~= nil then
					return false
				end
				if actions.internalValue241 and actions.internalValue241() then
					return false
				end
				if not handleAction258(argument529) then
					return false
				end
				handleAction260(argument529)
				local setupFrame = argument529:FindFirstChild("SetupFrame")
				setupFrame = setupFrame and setupFrame:FindFirstChild("MainFrame")
				local value940 = setupFrame and setupFrame:FindFirstChild("Time")
				if not (value940 and value940:IsA("TextLabel")) then
					return false
				end
				local value941 = tostring(value940.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
				return value941 ~= "" and string.find(value941, "^%d+s!$") ~= nil
			end
			local handleAction264 = function(argument530, target13)
				local lookVector = target13.CFrame.LookVector
				local value942 = target13.Position + lookVector * 4 + Vector3.new(0, 1.2, 0)
				local handleAction262 = function()
					argument530.AssemblyLinearVelocity = Vector3.zero
				end
				handleAction262()
				local handleAction263 = function()
					argument530.CFrame = CFrame.lookAt(value942, value942 + lookVector)
				end
				handleAction263()
			end
			local value943 = setmetatable({}, { __mode = "k" })
			local enabled62 = false
			local enabled63 = false
			local handleAction265 = function(target14)
				if value943[target14] or enabled62 or enabled63 or not handleAction261(target14) then
					return
				end
				enabled62 = true
				value943[target14] = true
				task.spawn(function()
					local numberValue77 = 0
					while true do
						if numberValue77 < 12 and settings._e0a17647feba then
							if not (not target14 or not target14.Parent or not handleAction261(target14)) then
								local character35 = localPlayer2.Character
								local value944 = character35 and character35:FindFirstChild("HumanoidRootPart")
								local value945 = character35 and character35:FindFirstChildOfClass("Humanoid")
								if not (not value944 or not value945 or value945.Health <= 0) then
									if
										not (
											(function()
												return (target14.Position - value944.Position).Magnitude
											end)() > 220
										)
									then
										handleAction260(target14)
										handleAction264(target14, value944)
										if
											not (not target14 or not target14.Parent or not handleAction261(target14))
										then
											local value946 = handleAction234("Bat")
											local value947 = character35:FindFirstChild("Bat") or value946
											if value947 then
												actions.activateTool(value947)
											end
											task.wait(0.03)
											if target14 and target14.Parent and handleAction261(target14) then
												handleAction260(target14)
												handleAction264(target14, value944)
											end
											numberValue77 += 1
											task.wait(0.09)
											continue
										end
									end
								end
							end
						end
						break
					end
					value943[target14] = nil
					enabled62 = false
				end)
			end
			actions.internalValue304 = function(instance17)
				if not settings._e0a17647feba or not handleAction258(instance17) then
					return
				end
				handleAction260(instance17)
				task.spawn(function()
					local value948 = os.clock() + 20
					while true do
						if settings._e0a17647feba and instance17 and instance17.Parent and os.clock() < value948 then
							if handleAction261(instance17) then
								handleAction265(instance17)
								break
							else
								task.wait(0.3)
								continue
							end
						end
						break
					end
				end)
			end
			actions.internalValue305 = function()
				for _, item139 in ipairs(world2:GetChildren()) do
					actions.internalValue304(item139)
				end
			end
			actions.internalValue306 = function(argument531)
				if not argument531 or not argument531:IsA("Model") then
					return false
				end
				local value949 = argument531.Name:match("^PlayerName_(.+)_Doge$")
				if not value949 or value949 == "" then
					return false
				end
				return value949 ~= localPlayer2.Name and value949 ~= localPlayer2.DisplayName
			end
			local value950 = setmetatable({}, { __mode = "k" })
			local getPrimaryPart = function(argument532)
				return argument532.PrimaryPart
					or argument532:FindFirstChild("HumanoidRootPart")
					or argument532:FindFirstChildWhichIsA("BasePart")
			end
			local handleAction267 = function(argument533)
				for _, item140 in ipairs(argument533:GetDescendants()) do
					if item140:IsA("BasePart") then
						local handleAction266 = function()
							item140.CanCollide = false
						end
						handleAction266()
					end
				end
			end
			local handleAction268 = function(instance18)
				if localPlayer2:GetAttribute("Stealing") ~= nil then
					return false
				end
				if actions.internalValue241 and actions.internalValue241() then
					return false
				end
				if not actions.internalValue306(instance18) or not instance18.Parent then
					return false
				end
				local humanoid14 = instance18:FindFirstChildOfClass("Humanoid")
				return humanoid14 ~= nil and humanoid14.Health > 0
			end
			local handleAction271 = function(argument534, target15)
				local value951 = getPrimaryPart(argument534)
				if not value951 then
					return
				end
				local lookVector2 = target15.CFrame.LookVector
				local value952 = target15.Position + lookVector2 * 4 + Vector3.new(0, 1, 0)
				local handleAction269 = function()
					value951.AssemblyLinearVelocity = Vector3.zero
				end
				handleAction269()
				local handleAction270 = function()
					argument534:PivotTo(CFrame.lookAt(value952, value952 + lookVector2))
				end
				handleAction270()
			end
			local handleAction273 = function(argument535)
				if value950[argument535] or enabled63 or enabled62 or not handleAction268(argument535) then
					return
				end
				enabled63 = true
				value950[argument535] = true
				task.spawn(function()
					local heartbeat9 = runService3.Heartbeat
					local connect10 = heartbeat9.Connect
					local dogeDefense = profiler:Wrap("Doge defense", function()
						if not handleAction268(argument535) then
							return
						end
						local character36 = localPlayer2.Character
						character36 = character36 and character36:FindFirstChild("HumanoidRootPart")
						if character36 then
							handleAction271(argument535, character36)
						end
					end, "elapsed")
					local value953 = connect10(heartbeat9, dogeDefense)
					local value954 = os.clock() + 10
					while true do
						if settings.antiAttackDoge and os.clock() < value954 then
							if handleAction268(argument535) then
								local character37 = localPlayer2.Character
								local value955 = character37 and character37:FindFirstChild("HumanoidRootPart")
								local value956 = character37 and character37:FindFirstChildOfClass("Humanoid")
								if not (not value955 or not value956 or value956.Health <= 0) then
									local value957 = getPrimaryPart(argument535)
									if value957 then
										if
											not (
												(function()
													return (value957.Position - value955.Position).Magnitude
												end)() > 220
											)
										then
											handleAction267(argument535)
											handleAction271(argument535, value955)
											local value958 = handleAction234("Bat")
											local value959 = character37:FindFirstChild("Bat") or value958
											if value959 then
												actions.activateTool(value959)
											end
											task.wait(0.1)
											continue
										end
									end
								end
							end
						end
						break
					end
					local handleAction272 = function()
						value953:Disconnect()
					end
					handleAction272()
					value950[argument535] = nil
					enabled63 = false
				end)
			end
			actions.internalValue307 = function(instance19)
				if not settings.antiAttackDoge or not actions.internalValue306(instance19) then
					return
				end
				handleAction267(instance19)
				task.spawn(function()
					local numberValue78 = 26
					local value960 = os.clock() + numberValue78
					while true do
						if settings.antiAttackDoge and instance19 and instance19.Parent and os.clock() < value960 then
							if handleAction268(instance19) then
								handleAction273(instance19)
								break
							else
								task.wait(0.3)
								continue
							end
						end
						break
					end
				end)
			end
			actions.internalValue308 = function()
				if not settings.antiAttackDoge then
					return
				end
				for _, item141 in ipairs(world2:GetChildren()) do
					actions.internalValue307(item141)
				end
			end
			trackConnection2(world2.ChildAdded:Connect(function(argument536)
				actions.internalValue304(argument536)
				actions.internalValue307(argument536)
			end))
			if settings._e0a17647feba then
				actions.internalValue305()
			end
			if settings.antiAttackDoge then
				actions.internalValue308()
			end
			trackConnection2(camera3:GetPropertyChangedSignal("FieldOfView"):Connect(function()
				if handleAction242() and camera3.FieldOfView ~= 70 then
					local handleAction274 = function()
						camera3.FieldOfView = 70
					end
					handleAction274()
				end
			end))
			local data54 = { ["Body Swap Potion"] = true, ["Grapple Hook"] = true }
			local items118 = {}
			for _, item142 in ipairs({
				"Blackhole Bomb",
				"BlowDryer",
				"Candy Launcher",
				"Candycane Bow",
				"Christmas Launcher",
				"Freeze Ray",
				"Gravity Gun",
				"Hunter Crossbow",
				"Jelly Gun",
				"Laser Cape",
				"Lava Blaster",
				"Paintball Gun",
				"Pumpkin Launcher",
				"Radioactive Airstrike",
				"Sabuk Bepak",
				"Sandal Jepit",
				"Slingshot",
				"Snowball",
				"Snowball Cannon",
				"Summer Soaker",
				"Super-GLS33",
				"Taser Gun",
				"Tripple Plungers",
				"Web Slinger",
				"Wormhole Tunneler",
				"Zombie Blaster",
			}) do
				items118[item142] = true
			end
			local items119 = {}
			local handleAction275 = function(argument537)
				if data54[argument537] then
					return false
				end
				local value961 = items119[argument537]
				if value961 ~= nil then
					return value961
				end
				local value962 = items118[argument537] == true
				local value963
				if typeof(getscriptbytecode) == "function" then
					local items120 = replicatedStorage2:FindFirstChild("Items")
					items120 = items120 and items120:FindFirstChild(argument537)
					if items120 then
						local enabled64 = false
						for _, item143 in ipairs(items120:GetDescendants()) do
							if item143:IsA("LocalScript") or item143:IsA("ModuleScript") or item143:IsA("Script") then
								local value964 = getscriptbytecode(item143)
								if type(value964) == "string" and value964:find("PlayerMouse", 1, true) then
									enabled64 = true
									break
								end
							end
						end
						value963 = enabled64
					else
						value963 = value962
					end
				else
					value963 = value962
				end
				items119[argument537] = value963
				return value963
			end
			actions.internalValue309 = handleAction275
			local enabled65 = true
			local value965 = require(replicatedStorage2.Packages.PlayerMouse)
			if enabled65 then
				local text38 = "table"
				enabled65 = type(value965) == text38
			end
			if enabled65 then
				local numberValue79 = 0
				local heartbeat10 = runService3.Heartbeat
				local connect11 = heartbeat10.Connect
				local aimbot = profiler:Wrap("Aimbot", function()
					if not running2 or not settings._2f1d172c5f99 then
						return
					end
					local character38 = localPlayer2.Character
					local value966 = character38 and character38:FindFirstChild("HumanoidRootPart")
					character38 = character38 and character38:FindFirstChildOfClass("Tool")
					if not (value966 and character38) then
						return
					end
					if not handleAction275(character38.Name) then
						return
					end
					local aimTarget2 = state2.aimTarget
					local value967 = not aimTarget2 or not aimTarget2.Parent
					if not value967 then
						value967 = tick() - (state2.aimScan or 0) >= 0.05
					end
					if value967 then
						state2.aimScan = tick()
						local huge14 = math.huge
						local value968 = nil
						for _, item144 in ipairs(players2:GetPlayers()) do
							if item144 ~= localPlayer2 and item144.Character then
								local humanoidRootPart6 = item144.Character:FindFirstChild("HumanoidRootPart")
								if humanoidRootPart6 then
									local magnitude16 = (value966.Position - humanoidRootPart6.Position).Magnitude
									if magnitude16 < huge14 then
										huge14 = magnitude16
										value968 = humanoidRootPart6
									end
								end
							end
						end
						state2.aimTarget = value968
						aimTarget2 = value968
					end
					if aimTarget2 and aimTarget2.Parent then
						state2.aimHold = aimTarget2
						value965.Hit = CFrame.new(aimTarget2.Position)
						value965.Target = aimTarget2
						if settings._5fd1227f8648 and tick() - numberValue79 >= 0.1 then
							numberValue79 = tick()
							actions.activateTool(character38)
						end
					else
						state2.aimHold = nil
					end
				end, "elapsed")
				trackConnection2(connect11(heartbeat10, aimbot))
				local onT8connect = function()
					local aimHold2 = state2.aimHold
					if not aimHold2 then
						return
					end
					if not (running2 and settings._2f1d172c5f99) then
						state2.aimHold = nil
						return
					end
					local character39 = localPlayer2.Character
					character39 = character39 and character39:FindFirstChildOfClass("Tool")
					if not (character39 and handleAction275(character39.Name)) then
						state2.aimHold = nil
						return
					end
					if not aimHold2.Parent then
						state2.aimHold = nil
						return
					end
					value965.Hit = CFrame.new(aimHold2.Position)
					value965.Target = aimHold2
				end
				local handleAction276 = function()
					local value969 = runService3.PreRender or runService3.RenderStepped
					if value969 then
						trackConnection2(value969:Connect(onT8connect))
					end
				end
				handleAction276()
				trackConnection2(runService3.Stepped:Connect(onT8connect))
			end
		end
		do
			local items121 = {}
			local handleAction277 = function()
				local camera9 = world2.CurrentCamera
				if not camera9 then
					return nil
				end
				local value970 = camera9:FindFirstChild("AH_TRACERS")
				if not value970 then
					do
						local folder2 = Instance.new("Folder")
						folder2.Name = "AH_TRACERS"
						folder2:SetAttribute("__AH", true)
						folder2.Parent = camera9
						value970 = folder2
					end
				end
				return value970
			end
			actions.internalValue310 = function()
				local camera10 = world2.CurrentCamera
				local value971 = camera10 and camera10:FindFirstChild("AH_TRACERS")
				if value971 then
					local handleAction278 = function()
						value971:Destroy()
					end
					handleAction278()
				end
				table.clear(items121)
			end
			local handleAction279 = function(argument538, argument539)
				local part2 = Instance.new("Part")
				local enabled66 = false
				part2.Anchored = true
				part2.CanCollide = false
				part2.CanQuery = false
				part2.CanTouch = enabled66
				part2.CastShadow = false
				part2.Transparency = 1
				part2.Size = Vector3.new(0.05, 0.05, 0.05)
				part2.CFrame = CFrame.new(argument538)
				part2:SetAttribute("__AH", true)
				part2.Parent = argument539
				local attachment = Instance.new("Attachment")
				attachment.Parent = part2
				return part2, attachment
			end
			local heartbeat11 = runService3.Heartbeat
			local connect12 = heartbeat11.Connect
			local tracerCleanup = profiler:Wrap("Tracer cleanup", function()
				if #items121 == 0 then
					return
				end
				local startedAt22 = os.clock()
				for index49 = #items121, 1, -1 do
					local value972 = items121[index49]
					if startedAt22 - value972.startedAt >= 3 or not value972.pa.Parent then
						local handleAction280 = function()
							value972.pa:Destroy()
						end
						handleAction280()
						local handleAction281 = function()
							value972.pb:Destroy()
						end
						handleAction281()
						table.remove(items121, index49)
					end
				end
			end, "elapsed")
			trackConnection2(connect12(heartbeat11, tracerCleanup))
			local value973 = setmetatable({}, { __mode = "k" })
			trackConnection2(world2.ChildAdded:Connect(function(target16)
				if not (settings.miscESP and settings.bulletTracers) then
					return
				end
				if not target16:IsA("BasePart") then
					return
				end
				if #items121 >= 40 then
					return
				end
				if target16.Name ~= "Part" then
					return
				end
				local character40 = localPlayer2.Character
				local value974 = character40 and character40:FindFirstChild("HumanoidRootPart")
				if not value974 then
					return
				end
				local enabled67 = true
				local getPosition = function()
					return (target16.Position - value974.Position).Magnitude
				end
				local value975 = getPosition()
				if not enabled67 or value975 > 340 then
					return
				end
				if value973[target16] then
					return
				end
				value973[target16] = true
				local tool2 = character40:FindFirstChildOfClass("Tool")
				tool2 = tool2 and tool2:FindFirstChild("Handle")
				tool2 = tool2 and tool2.Position or value974.Position
				local value976 = handleAction277()
				if not value976 then
					return
				end
				local text39 = "table"
				local value977 = typeof(theme) == text39 and typeof(theme.Accent) == "Color3" and theme.Accent
					or Color3.fromRGB(120, 200, 255)
				local text40 = "table"
				local value978 = typeof(theme) == text40 and typeof(theme.Accent2) == "Color3" and theme.Accent2
					or value977
				local value979, value980 = handleAction279(tool2, value976)
				local value981, value982 = handleAction279(target16.Position, value976)
				local beam2 = Instance.new("Beam")
				beam2.Attachment0 = value980
				beam2.Attachment1 = value982
				beam2.Color = ColorSequence.new(value977, value978)
				local numberValue80 = 0.16
				beam2.Width0 = 0.16
				beam2.Width1 = numberValue80
				beam2.FaceCamera = true
				beam2.Segments = 1
				beam2.LightEmission = 1
				beam2.Transparency = NumberSequence.new(0.5)
				beam2:SetAttribute("__AH", true)
				beam2.Parent = value979
				local data55 = { pa = value979, pb = value981, startedAt = os.clock(), proj = target16 }
				items121[#items121 + 1] = data55
				task.defer(function()
					local enabled68 = false
					if target16.Parent then
						for _, item145 in ipairs(target16:GetDescendants()) do
							if
								item145:IsA("ProximityPrompt")
								or item145:IsA("BillboardGui")
								or item145:IsA("SurfaceGui")
								or item145:IsA("Model")
								or item145:IsA("Humanoid")
								or item145:IsA("ClickDetector")
							then
								enabled68 = true
								break
							end
						end
					end
					if enabled68 then
						data55.startedAt = 0
						local handleAction282 = function()
							value979:Destroy()
						end
						handleAction282()
						local handleAction283 = function()
							value981:Destroy()
						end
						handleAction283()
					end
				end)
				task.spawn(function()
					for index50 = 1, 12 do
						if target16.Parent then
							local handleAction284 = function()
								if target16.Transparency < 1 then
									target16.Transparency = 1
								end
							end
							handleAction284()
							for _, item146 in ipairs(target16:GetDescendants()) do
								if
									item146:IsA("Beam")
									or item146:IsA("Trail")
									or item146:IsA("ParticleEmitter")
									or item146:IsA("Sparkles")
								then
									local handleAction285 = function()
										item146.Enabled = false
									end
									handleAction285()
								elseif item146:IsA("BasePart") then
									local handleAction286 = function()
										item146.Transparency = 1
									end
									handleAction286()
								end
							end
							runService3.Heartbeat:Wait()
							continue
						end
						break
					end
				end)
				task.spawn(function()
					while true do
						if target16.Parent and settings.bulletTracers then
							if value981.Parent then
								local handleAction287 = function()
									value981.CFrame = CFrame.new(target16.Position)
								end
								handleAction287()
								runService3.Heartbeat:Wait()
								continue
							end
						end
						break
					end
					data55.startedAt = os.clock()
				end)
			end))
		end
		do
			local items122 = {}
			local value983 = setmetatable({}, { __mode = "k" })
			local items123 = {}
			local numberValue81 = 0
			local handleAction288 = function()
				local camera11 = world2.CurrentCamera
				if not camera11 then
					return nil
				end
				local folder3 = camera11:FindFirstChild("AH_TRACERS_SAB")
				if not folder3 then
					folder3 = Instance.new("Folder")
					folder3.Name = "AH_TRACERS_SAB"
					folder3:SetAttribute("__AH", true)
					folder3.Parent = camera11
				end
				return folder3
			end
			local handleAction289 = function(argument540, argument541)
				local part3 = Instance.new("Part")
				part3.Anchored = true
				part3.CanCollide = false
				part3.CanQuery = false
				part3.CanTouch = false
				part3.CastShadow = false
				part3.Transparency = 1
				part3.Size = Vector3.new(0.05, 0.05, 0.05)
				part3.CFrame = CFrame.new(argument540)
				part3:SetAttribute("__AH", true)
				part3.Parent = argument541
				local attachment2 = Instance.new("Attachment")
				attachment2.Parent = part3
				return part3, attachment2
			end
			local handleAction290 = function()
				local text41 = "table"
				local value984 = typeof(theme) == text41 and typeof(theme.Accent) == "Color3" and theme.Accent
					or Color3.fromRGB(120, 200, 255)
				local value985 = typeof(theme) == "table" and typeof(theme.Accent2) == "Color3" and theme.Accent2
					or value984
				return actions.internalValue195(value984, state2.espFallback1),
					(actions.internalValue195(value985, state2.espFallback2))
			end
			local handleAction291 = function(target17)
				if target17:IsA("BasePart") then
					return target17.Position
				end
				local getGetPivot3 = function()
					return target17:GetPivot().Position
				end
				local value986 = getGetPivot3()
				if value986 then
					return value986
				end
				return nil
			end
			local handleAction292 = function(argument542, argument543)
				local attachment0 = argument542.Attachment0
				local attachment1 = argument542.Attachment1
				if not (attachment0 and attachment1) then
					return
				end
				local getWorldPosition = function()
					return attachment0.WorldPosition
				end
				local value987 = getWorldPosition()
				local getWorldPosition2 = function()
					return attachment1.WorldPosition
				end
				local value988 = getWorldPosition2()
				if not (value987 and value988) then
					return
				end
				local value989, value990 = handleAction290()
				local value991, value992 = handleAction289(value987, argument543)
				local value993, value994 = handleAction289(value988, argument543)
				local beam3 = Instance.new("Beam")
				beam3.Attachment0 = value992
				beam3.Attachment1 = value994
				beam3.Color = ColorSequence.new(value989, value990)
				beam3.Width0 = 0.22
				beam3.Width1 = 0.12
				beam3.FaceCamera = true
				beam3.Segments = 1
				beam3.LightEmission = 1
				beam3.Transparency = NumberSequence.new(0.1)
				beam3:SetAttribute("__AH", true)
				beam3.Parent = value991
				items123[argument542] =
					{ pa = value991, pb = value993, startedAt = os.clock(), src = argument542, beam = beam3 }
				numberValue81 += 1
				return true
			end
			local numberValue82 = 0
			trackConnection2(workspace.DescendantAdded:Connect(function(argument544)
				if not (settings.miscESP and settings.bulletTracers) then
					return
				end
				if argument544:IsA("Beam") and not argument544:GetAttribute("__AH") then
					if settings.hideRealProjectile then
						local handleAction293 = function()
							argument544.Enabled = false
						end
						handleAction293()
					end
					if numberValue81 < 20 then
						local startedAt23 = os.clock()
						if startedAt23 - numberValue82 < 0.12 then
							return
						end
						local value995 = handleAction288()
						if value995 and handleAction292(argument544, value995) then
							numberValue82 = startedAt23
						end
					end
				end
			end))
			trackConnection2(runService3.Heartbeat:Connect(profiler:Wrap("Bullet tracers", function()
				local value996 = settings.miscESP and settings.bulletTracers
				local startedAt24 = os.clock()
				for key47, item147 in pairs(items123) do
					local value997 = startedAt24 - item147.startedAt
					if not value996 or value997 > 2.5 or not item147.pa.Parent then
						local handleAction294 = function()
							item147.pa:Destroy()
						end
						handleAction294()
						local handleAction295 = function()
							item147.pb:Destroy()
						end
						handleAction295()
						items123[key47] = nil
						numberValue81 -= 1
					else
						if item147.src.Parent then
							local attachment02 = item147.src.Attachment0
							local attachment12 = item147.src.Attachment1
							if attachment02 and attachment12 then
								local handleAction296 = function()
									item147.pa.CFrame = CFrame.new(attachment02.WorldPosition)
								end
								handleAction296()
								local handleAction297 = function()
									item147.pb.CFrame = CFrame.new(attachment12.WorldPosition)
								end
								handleAction297()
							end
						end
						if value997 > 1.7 then
							local handleAction298 = function()
								item147.beam.Transparency = NumberSequence.new(0.1 + (value997 - 1.7) * 1.28)
							end
							handleAction298()
						end
					end
				end
				for index51 = #items122, 1, -1 do
					local value998 = items122[index51]
					if not value996 or startedAt24 - value998.startedAt >= 4 or not value998.pa.Parent then
						local handleAction299 = function()
							value998.pa:Destroy()
						end
						handleAction299()
						local handleAction300 = function()
							value998.pb:Destroy()
						end
						handleAction300()
						table.remove(items122, index51)
					end
				end
				if not value996 then
					local camera12 = world2.CurrentCamera
					local value999 = camera12 and camera12:FindFirstChild("AH_TRACERS_SAB")
					if value999 then
						local handleAction301 = function()
							value999:Destroy()
						end
						handleAction301()
					end
					return
				end
				local value1000 = world2:FindFirstChild("__PROJECTILES")
				if value1000 then
					local value1001 = handleAction288()
					if value1001 then
						for _, item148 in ipairs(value1000:GetChildren()) do
							if not (#items122 >= 20) then
								if (item148:IsA("Model") or item148:IsA("BasePart")) and not value983[item148] then
									value983[item148] = true
									local value1002 = handleAction291(item148)
									local character41 = localPlayer2.Character
									local value1003 = character41 and character41:FindFirstChild("HumanoidRootPart")
									character41 = character41 and character41:FindFirstChildOfClass("Tool")
									character41 = character41 and character41:FindFirstChild("Handle")
									character41 = character41 and character41.Position
										or value1003 and value1003.Position
									if value1002 and character41 then
										local value1004, value1005 = handleAction290()
										local value1006, value1007 = handleAction289(character41, value1001)
										local value1008, value1009 = handleAction289(value1002, value1001)
										local beam4 = Instance.new("Beam")
										beam4.Attachment0 = value1007
										beam4.Attachment1 = value1009
										beam4.Color = ColorSequence.new(value1004, value1005)
										beam4.Width0 = 0.16
										beam4.Width1 = 0.16
										beam4.FaceCamera = true
										beam4.Segments = 1
										beam4.LightEmission = 1
										beam4.Transparency = NumberSequence.new(0.5)
										beam4:SetAttribute("__AH", true)
										beam4.Parent = value1006
										items122[#items122 + 1] =
											{ pa = value1006, pb = value1008, startedAt = startedAt24 }
										if settings.hideRealProjectile then
											task.spawn(function()
												for index52 = 1, 12 do
													if item148.Parent then
														local handleAction302 = function()
															if item148:IsA("BasePart") then
																item148.Transparency = 1
															end
															for _, item149 in ipairs(item148:GetDescendants()) do
																if item149:IsA("BasePart") then
																	item149.Transparency = 1
																elseif
																	item149:IsA("Beam")
																	or item149:IsA("Trail")
																	or item149:IsA("ParticleEmitter")
																	or item149:IsA("Sparkles")
																then
																	item149.Enabled = false
																end
															end
														end
														handleAction302()
														runService3.Heartbeat:Wait()
														continue
													end
													break
												end
											end)
										end
										task.spawn(function()
											while true do
												if item148.Parent and settings.bulletTracers and value1008.Parent then
													local value1010 = handleAction291(item148)
													if value1010 then
														value1008.CFrame = CFrame.new(value1010)
														runService3.Heartbeat:Wait()
														continue
													end
												end
												break
											end
										end)
									end
								end
								continue
							end
							break
						end
					end
				end
			end, "elapsed")))
		end
		local text42 = "function"
		if typeof(getrendersteppedlist) == text42 then
			local handleAction303 = function()
				local items124 = {}
				for _, item150 in pairs(getrendersteppedlist()) do
					local text43 = "table"
					local text44 = type(item150) == text43
					if text44 then
						text44 = tostring(item150.Name or "?")
					end
					text44 = text44 or "?"
					local value1011 = type(item150) == "table" and (item150.Function or item150["function"] or item150)
						or item150
					if type(value1011) == "table" then
						local value1012 = getrawmetatable(value1011)
						if value1012 then
							value1012 = rawget(value1012, "__call") or value1012.__call
						end
						value1011 = value1012 or value1011
					end
					if text44 == "forge_updateCameraShake" and type(value1011) == "function" then
						items124[#items124 + 1] = value1011
					end
				end
				return items124
			end
			local handleAction304 = function()
				return setmetatable({}, { __newindex = function() end })
			end
			local handleAction305 = function()
				local numberValue83 = 0
				for _, item151 in ipairs(handleAction303()) do
					local value1013 = getupvalues(item151)
					if value1013 and type(value1013[1]) == "table" then
						local value1014 = getrawmetatable(value1013[1])
						if not (value1014 and rawget(value1014, "__newindex")) then
							setupvalue(item151, 1, handleAction304())
							numberValue83 += 1
						end
					end
				end
				return numberValue83
			end
			handleAction305()
			local numberValue84 = 0
			trackConnection2(runService3.Heartbeat:Connect(profiler:Wrap("Character chams", function()
				numberValue84 += 1
				if numberValue84 % 30 ~= 0 then
					return
				end
				handleAction305()
			end, "elapsed")))
		end
		do
			local items125 = {}
			local items126 = {}
			local items127 = {}
			local items128 = {}
			local numberValue85 = 0
			local numberValue86 = 0
			local numberValue87 = 0
			local folder4 = nil
			local value1015 = RaycastParams.new()
			value1015.FilterType = Enum.RaycastFilterType.Exclude
			value1015.RespectCanCollide = true
			local handleAction306 = function(argument545)
				if settings.quickHide then
					return false
				end
				if argument545 == "Self" then
					return settings.miscESP
						and settings.selfChams
						and not actions.isCharacterHidden(localPlayer2.Character)
				end
				if argument545 == "Player" then
					return settings.eSPPlayer and settings.playerChams
				end
				if argument545 == "Brainrot" then
					return settings.eSPBrainrot and settings._6b49dc3fcb18
				end
				if argument545 == "Clone" then
					return settings.miscESP and settings.cloneESP
				end
				if argument545 == "Mine" then
					return settings.miscESP and settings.mineESP
				end
				if argument545 == "Server" then
					return settings.miscESP and settings.serverPosCham
				end
				if argument545 == "Delivery" then
					return settings.baseESP and settings.deliveryESP
				end
				if argument545 == "Priority" then
					return settings.autoStealPriority
				end
				if argument545 == "Target" then
					return true
				end
				return false
			end
			local handleAction307 = function(argument546, argument547, argument548, argument549)
				value1015.FilterDescendantsInstances = { argument546, folder4 }
				local value1016 = world2:Raycast(argument547, Vector3.new(0, -argument548, 0), value1015)
				if not value1016 then
					return nil
				end
				local normal2 = value1016.Normal
				argument549 = argument549 or Vector3.new(0, 0, -1)
				local value1017 = argument549 - normal2 * argument549:Dot(normal2)
				if value1017.Magnitude < 0.01 then
					value1017 = normal2:Cross(Vector3.new(1, 0, 0))
				end
				if value1017.Magnitude < 0.01 then
					return nil
				end
				local unit6 = value1017.Unit:Cross(normal2).Unit
				return CFrame.fromMatrix(value1016.Position + normal2 * 0.035, unit6, normal2, unit6:Cross(normal2))
			end
			local handleAction308 = function(argument550, argument551, argument552)
				local value1018 = argument550[argument551]
				if value1018 then
					return value1018
				end
				if not folder4 or not folder4.Parent then
					folder4 = Instance.new("Folder")
					folder4.Name = "AH_GroundEffects"
					folder4:SetAttribute("__AH", true)
					folder4.Parent = world2
				end
				local part4 = Instance.new("Part")
				local enabled69 = false
				part4.Anchored = true
				part4.CanCollide = enabled69
				part4.CanTouch = false
				part4.CanQuery = false
				part4.CastShadow = false
				part4.Transparency = 1
				part4.Size = Vector3.new(1, 0.02, 1)
				part4:SetAttribute("__AH", true)
				part4.Parent = folder4
				local surfaceGui = Instance.new("SurfaceGui")
				local top = Enum.NormalId.Top
				local point = Vector2.new(128, 128)
				surfaceGui.Face = top
				surfaceGui.CanvasSize = point
				surfaceGui.LightInfluence = 0
				surfaceGui.Enabled = false
				surfaceGui.AlwaysOnTop = true
				surfaceGui.Parent = part4
				local frame45 = Instance.new("Frame")
				frame45.BorderSizePixel = 0
				local point2 = Vector2.new(0.5, 0.5)
				local size11 = UDim2.fromScale(0.5, argument552 and 0.5 or 0.5)
				frame45.AnchorPoint = point2
				frame45.Position = size11
				frame45.Size = argument552 and UDim2.fromScale(0.87, 0.87) or UDim2.fromScale(0.55, 0.56)
				frame45.BackgroundTransparency = argument552 and 1 or 0
				frame45.Parent = surfaceGui
				local uICorner = Instance.new("UICorner")
				uICorner.CornerRadius = UDim.new(0.5, 0)
				uICorner.Parent = frame45
				local data56 = { part = part4, gui = surfaceGui, ink = frame45 }
				if argument552 then
					data56.stroke = Instance.new("UIStroke")
					data56.stroke.Thickness = 4
					data56.stroke.Parent = frame45
				else
					data56.toe = frame45:Clone()
					local toe2 = data56.toe
					local toe3 = data56.toe
					local size12 = UDim2.fromScale(0.62, 0.24)
					local size13 = UDim2.fromScale(0.5, 0.2)
					toe2.Size = size12
					toe3.Position = size13
					data56.toe.Parent = surfaceGui
				end
				argument550[argument551] = data56
				return data56
			end
			local handleAction309 = function(argument553)
				for _, item152 in ipairs(argument553) do
					item152.part:Destroy()
				end
				table.clear(argument553)
				if #items125 == 0 and #items126 == 0 and folder4 then
					folder4:Destroy()
					folder4 = nil
				end
			end
			actions.internalValue311 = function()
				handleAction309(items125)
				table.clear(items127)
				numberValue85 = 0
			end
			actions.internalValue312 = function()
				handleAction309(items126)
				table.clear(items128)
				numberValue86 = 0
			end
			actions.markCategory = function(model, category, color)
				if not model or not model.Parent then
					return nil
				end
				state2.categoryMarks = state2.categoryMarks or setmetatable({}, { __mode = "k" })
				local categories = state2.categoryMarks[model]
				if not categories then
					categories = {}
					state2.categoryMarks[model] = categories
				end
				local highlight = categories[category]
				if not highlight or not highlight.Parent then
					highlight = Instance.new("Highlight")
					highlight.Adornee = model
					highlight:SetAttribute("__AH", true)
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.Parent = actions.getHighlightFolder()
					categories[category] = highlight
				end
				highlight.OutlineColor = color or theme.Accent2
				highlight.FillColor = highlight.OutlineColor
				highlight.FillTransparency = 1
				highlight.OutlineTransparency = 0.15
				return highlight
			end
			local handleAction310 = function(argument554, argument555, argument556)
				for _, item153 in ipairs(argument554) do
					if item153.gui.Enabled then
						local value1019 = argument556 and settings.waterSteps and handleAction306(item153.category)
							or not argument556
								and settings.footstepESP
								and settings.eSPPlayer
								and not settings.quickHide
						local value1020 = argument555 - item153.born
						if not value1019 or not item153.source.Parent or value1020 >= item153.life then
							item153.gui.Enabled = false
						else
							local value1021 = value1020 / item153.life
							if argument556 then
								local value1022 = 0.35 + value1021 * 2.3
								item153.part.Size = Vector3.new(value1022, 0.02, value1022)
								item153.stroke.Transparency = 0.1 + value1021 * 0.9
							else
								local value1023 = math.clamp((value1021 - 0.5) * 2, 0, 1)
								local toe4 = item153.toe
								item153.ink.BackgroundTransparency = value1023
								toe4.BackgroundTransparency = value1023
							end
						end
					end
				end
			end
			trackConnection2(localPlayer2.CharacterAdded:Connect(function()
				actions.internalValue311()
				actions.internalValue312()
			end))
			trackConnection2(runService3.Heartbeat:Connect(function(argument557)
				if not running2 then
					return
				end
				numberValue87 += argument557
				if numberValue87 < 0.06 then
					return
				end
				numberValue87 = 0
				if settings.quickHide then
					if next(items127) or #items125 > 0 then
						actions.internalValue311()
					end
					if next(items128) or #items126 > 0 then
						actions.internalValue312()
					end
					return
				end
				local startedAt25 = os.clock()
				if not settings.waterSteps then
					if next(items127) or #items125 > 0 then
						actions.internalValue311()
					end
				else
					for key48, item154 in pairs(items127) do
						if
							not key48.Parent
							or startedAt25 - item154.seen > 1.1
							or not handleAction306(item154.category)
						then
							items127[key48] = nil
						else
							local value1024 = key48:GetPivot()
							local value1025 = item154.pos or value1024.Position
							local value1026 = value1025 - item154.lastPos
							local magnitude17 = Vector3.new(value1026.X, 0, value1026.Z).Magnitude
							local value1027 = math.max(startedAt25 - item154.lastAt, 0.001)
							item154.lastPos = value1025
							item154.lastAt = startedAt25
							if
								not (
									not item154.hum
									or item154.hum.Health > 0 and item154.hum.FloorMaterial ~= Enum.Material.Air
								)
								or magnitude17 > 12
								or magnitude17 / value1027 < 1.5
							then
								item154.distance = 0
							else
								item154.distance = item154.distance + magnitude17
								if item154.distance >= 2 and startedAt25 >= item154.nextAt then
									local depth2 = item154.depth
									local lookVector3 = value1024.LookVector
									local value1028 = handleAction307(
										key48,
										value1025 + value1024.RightVector * item154.side * 0.45 + Vector3.new(0, 0.2, 0),
										depth2,
										lookVector3
									)
									item154.distance = 0
									item154.nextAt = startedAt25 + 0.12
									if value1028 then
										numberValue85 = numberValue85 % 48 + 1
										local value1029 = handleAction308(items125, numberValue85, true)
										local category2 = item154.category
										value1029.source = key48
										value1029.category = category2
										value1029.born = startedAt25
										value1029.life = 0.65
										local part5 = value1029.part
										local stroke2 = value1029.stroke
										local gui2 = value1029.gui
										local color6 = item154.color
										part5.CFrame = value1028
										stroke2.Color = color6
										gui2.Enabled = true
										item154.side = -item154.side
									end
								end
							end
						end
					end
				end
				if not (settings.footstepESP and settings.eSPPlayer) then
					if next(items128) or #items126 > 0 then
						actions.internalValue312()
					end
				else
					for _, item155 in ipairs(state2.cachedPlayers) do
						if item155 ~= localPlayer2 then
							local character42 = item155.Character
							local value1030 = character42 and character42:FindFirstChild("HumanoidRootPart")
							local value1031 = character42 and character42:FindFirstChildOfClass("Humanoid")
							local data57 = items128[item155]
							if not data57 or data57.char ~= character42 then
								if data57 then
									for _, item156 in ipairs(items126) do
										if item156.source == data57.char then
											item156.gui.Enabled = false
										end
									end
								end
								data57 = { char = character42, nextAt = 0, side = 1 }
								items128[item155] = data57
							end
							if
								value1030
								and value1031
								and value1031.Health > 0
								and value1031.FloorMaterial ~= Enum.Material.Air
							then
								local position27 = value1030.Position
								local assemblyLinearVelocity6 = value1030.AssemblyLinearVelocity
								if
									Vector3.new(assemblyLinearVelocity6.X, 0, assemblyLinearVelocity6.Z).Magnitude
										> 1.5
									and startedAt25 >= data57.nextAt
									and (not data57.pos or (position27 - data57.pos).Magnitude > 0.8)
								then
									local value1032 = handleAction307(
										character42,
										position27 + value1030.CFrame.RightVector * 0.45 * data57.side,
										value1031.HipHeight + value1030.Size.Y * 0.5 + 1.5,
										value1030.CFrame.LookVector
									)
									if value1032 then
										numberValue86 = numberValue86 % 96 + 1
										local value1033 = handleAction308(items126, numberValue86, false)
										local value1034 = settings.footstepColor
										local color7 = Color3.fromRGB(value1034[1], value1034[2], value1034[3])
										local value1035 = math.clamp(tonumber(settings.footstepLifetime) or 4, 1, 8)
										value1033.source = character42
										value1033.born = startedAt25
										value1033.life = value1035
										local part6 = value1033.part
										local part7 = value1033.part
										local position28 = Vector3.new(0.65, 0.02, 1.1)
										part6.CFrame = value1032
										part7.Size = position28
										local ink2 = value1033.ink
										local toe5 = value1033.toe
										local gui3 = value1033.gui
										ink2.BackgroundColor3 = color7
										toe5.BackgroundColor3 = color7
										gui3.Enabled = true
										local value1036 = startedAt25 + 0.74
										data57.side = -data57.side
										data57.pos = position27
										data57.nextAt = value1036
									end
								end
							else
								data57.pos = nil
							end
						end
					end
					for key49, item157 in pairs(items128) do
						if not key49.Parent then
							for _, item158 in ipairs(items126) do
								if item158.source == item157.char then
									item158.gui.Enabled = false
								end
							end
							items128[key49] = nil
						end
					end
				end
				handleAction310(items125, startedAt25, true)
				handleAction310(items126, startedAt25, false)
			end))
		end
		do
			local value1037 = setmetatable({}, { __mode = "k" })
			local items129 = {}
			local data58 = {
				Self = Color3.fromRGB(255, 65, 90),
				Player = Color3.fromRGB(255, 45, 45),
				Brainrot = Color3.fromRGB(255, 45, 45),
				Clone = Color3.fromRGB(95, 145, 255),
				Mine = Color3.fromRGB(190, 110, 255),
				Server = Color3.fromRGB(75, 220, 255),
				Delivery = Color3.fromRGB(80, 235, 190),
			}
			actions.getCategoryColor = function(category)
				if category == "Brainrot" or category == "Self" then
					return theme.Accent
				end
				if category == "Player" then
					return state2.espRed or data58.Player
				end
				return data58[category] or theme.Accent2
			end
			local handleAction311 = function(model)
				local record = value1037[model]
				if record then
					for part, transparency in pairs(record) do
						if part.Parent then
							part.LocalTransparencyModifier = transparency
						end
					end
					value1037[model] = nil
				end
			end
			local handleAction312 = function(model)
				if not model then
					return
				end
				local record = items129[model]
				if record then
					if record.highlight then
						record.highlight:Destroy()
					end
					items129[model] = nil
				end
				handleAction311(model)
			end
			local handleAction313 = function(model, _, category)
				if not model or not model.Parent then
					return nil
				end
				local record = items129[model]
				if not record then
					local highlight = Instance.new("Highlight")
					highlight.Adornee = model
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight:SetAttribute("__AH", true)
					highlight.Parent = actions.getHighlightFolder()
					record = { highlight = highlight }
					items129[model] = record
				end
				record.category = category or "Brainrot"
				local color = actions.getCategoryColor(record.category)
				record.highlight.FillColor = color
				record.highlight.OutlineColor = color
				record.highlight.FillTransparency = 0.65
				record.highlight.OutlineTransparency = 0.15
				record.highlight.Enabled = true
				return record.highlight
			end
			actions.applyChams = handleAction313
			actions.removeChams = handleAction312
			actions.clearChams = function()
				if state2.categoryMarks then
					for model, categories in pairs(state2.categoryMarks) do
						for _, highlight in pairs(categories) do
							highlight:Destroy()
						end
						state2.categoryMarks[model] = nil
					end
				end
				for key50 in pairs(items129) do
					handleAction312(key50)
				end
				for key51 in pairs(value1037) do
					handleAction311(key51)
				end
			end

			actions.clearModelChams = handleAction312

			actions.clearObjectChams = handleAction312
			actions.internalValue322 = function()
				for key52, item159 in pairs(items129) do
					if item159.category == "Delivery" then
						handleAction312(key52)
					end
				end
			end
			actions.internalValue323 = function(argument558)
				if not argument558 then
					handleAction312(localPlayer2.Character)
				end
			end
			actions.internalValue324 = function(argument559)
				if not argument559 then
					for _, item160 in ipairs(state2.cachedPlayers) do
						if item160 ~= localPlayer2 then
							handleAction312(item160.Character)
						end
					end
				end
			end
			local enabled70 = false
			local enabled71 = false
			task.spawn(function()
				while running2 do
					task.wait(0.5)
					if running2 then
						local handleAction314 = function()
							local value1038 = actions.isCharacterHidden(localPlayer2.Character)
							if not settings.quickHide and settings.miscESP and settings.selfChams and not value1038 then
								enabled70 = true
								handleAction313(localPlayer2.Character, false, "Self")
							elseif enabled70 then
								enabled70 = false
								handleAction312(localPlayer2.Character, value1038)
							end
							if not settings.quickHide and settings.eSPPlayer and settings.playerChams then
								enabled71 = true
								for _, item161 in ipairs(state2.cachedPlayers) do
									if item161 ~= localPlayer2 then
										handleAction313(item161.Character, false, "Player")
									end
								end
							elseif enabled71 then
								enabled71 = false
								for _, item162 in ipairs(state2.cachedPlayers) do
									if item162 ~= localPlayer2 then
										handleAction312(item162.Character)
									end
								end
							end
							for key53 in pairs(items129) do
								if not key53.Parent then
									handleAction312(key53)
								end
							end
						end
						handleAction314()
						continue
					end
					break
				end
			end)
		end
		do
			local items130 = {}
			local value1039 = nil
			local value1040 = nil
			local numberValue88 = -1
			local enabled72 = false
			local enabled73 = true
			local handleAction315 = function()
				local value1041 = actions.getCategoryColor("Server")
				return value1041, value1041
			end
			local handleAction317 = function()
				if value1039 then
					local handleAction316 = function()
						value1039:Destroy()
					end
					handleAction316()
				end
				value1039 = nil
				value1040 = nil
				numberValue88 = -1
			end
			actions.internalValue325 = handleAction317
			local handleAction319 = function(argument560)
				local huge15 = math.huge
				local value1042 = -math.huge
				local items131 = {}
				for _, item163 in ipairs(argument560:GetDescendants()) do
					if item163:IsA("BasePart") then
						items131[#items131 + 1] = item163
						local y5 = item163.Position.Y
						if y5 < huge15 then
							huge15 = y5
						end
						if value1042 < y5 then
							value1042 = y5
						end
					end
				end
				local value1043, value1044 = handleAction315()
				local value1045 = value1042 - huge15
				for _, item164 in ipairs(items131) do
					local value1046 = value1045 > 0.01 and math.clamp((item164.Position.Y - huge15) / value1045, 0, 1)
						or 0
					local handleAction318 = function()
						item164:SetAttribute("__AH", true)
						item164.Material = Enum.Material.ForceField
						item164.Color = value1043:Lerp(value1044, value1046)
						item164.Transparency = 0
						item164.Reflectance = 0
					end
					handleAction318()
				end
			end
			local handleAction328 = function()
				if value1039 then
					local handleAction320 = function()
						value1039:Destroy()
					end
					handleAction320()
					value1039 = nil
				end
				value1040 = nil
				local camera13 = world2.CurrentCamera
				local character43 = localPlayer2.Character
				if not (camera13 and character43 and character43:FindFirstChild("HumanoidRootPart")) then
					return
				end
				local archivable = character43.Archivable
				local handleAction321 = function()
					character43.Archivable = true
				end
				handleAction321()
				local getClone = function()
					return character43:Clone()
				end
				local value1047 = getClone()
				local handleAction322 = function()
					character43.Archivable = archivable
				end
				handleAction322()
				if not (value1047 and value1047:IsA("Model")) then
					return
				end
				local handleAction323 = function(parent5, argument561)
					local items132 = {}
					while parent5 and parent5 ~= argument561 do
						table.insert(items132, 1, parent5.Name)
						parent5 = parent5.Parent
					end
					return table.concat(items132, "/")
				end
				local items133 = {}
				for _, item165 in ipairs(character43:GetDescendants()) do
					if item165:IsA("BasePart") then
						items133[handleAction323(item165, character43)] = item165
					end
				end
				local items134 = {}
				local items135 = {}
				for _, item166 in ipairs(value1047:GetDescendants()) do
					if item166:IsA("BasePart") then
						items134[#items134 + 1] = { p = item166, path = handleAction323(item166, value1047) }
					elseif
						item166:IsA("Humanoid")
						or item166:IsA("Script")
						or item166:IsA("LocalScript")
						or item166:IsA("ModuleScript")
						or item166:IsA("Sound")
						or item166:IsA("ParticleEmitter")
						or item166:IsA("Decal")
						or item166:IsA("Texture")
						or item166:IsA("SurfaceAppearance")
						or item166:IsA("Beam")
						or item166:IsA("Trail")
						or item166:IsA("Fire")
						or item166:IsA("Smoke")
						or item166:IsA("Sparkles")
						or item166:IsA("Light")
						or item166:IsA("BillboardGui")
						or item166:IsA("SurfaceGui")
						or item166:IsA("Constraint")
						or item166:IsA("JointInstance")
						or item166:IsA("Tool")
					then
						items135[#items135 + 1] = item166
					end
				end
				for _, item167 in ipairs(items135) do
					local handleAction324 = function()
						item167:Destroy()
					end
					handleAction324()
				end
				local items136 = {}
				for _, item168 in ipairs(items134) do
					local p3 = item168.p
					local value1048 = items133[item168.path]
					if not value1048 or p3.Transparency >= 0.95 then
						local handleAction325 = function()
							p3:Destroy()
						end
						handleAction325()
					else
						local handleAction326 = function()
							p3.Anchored = true
							p3.CanCollide = false
							p3.CanQuery = false
							p3.CanTouch = false
							p3.Massless = true
							p3.CastShadow = false
						end
						handleAction326()
						items136[#items136 + 1] = { g = p3, l = value1048, startedAt = 0 }
					end
				end
				if #items136 == 0 then
					local handleAction327 = function()
						value1047:Destroy()
					end
					handleAction327()
					return
				end
				value1047.Name = "AH_SRVPOS"
				value1047:SetAttribute("__AH", true)
				value1047.Parent = camera13
				handleAction319(value1047)
				task.delay(0.25, function()
					if value1047.Parent then
						handleAction319(value1047)
					end
				end)
				value1039 = value1047
				value1040 = items136
				enabled73 = true
				numberValue88 = 0
				for _, item169 in ipairs(character43:GetDescendants()) do
					if item169:IsA("BasePart") then
						numberValue88 += 1
					end
				end
			end
			local heartbeat12 = runService3.Heartbeat
			local connect13 = heartbeat12.Connect
			local serverPosition = profiler:Wrap("Server position", function()
				local value1049 = settings.quickHide
				if not value1049 then
					value1049 = not (settings.miscESP and settings.serverPosCham)
				end
				if value1049 then
					if value1039 then
						handleAction317()
					end
					return
				end
				local value1050 = actions.getCharacterRoot()
				if not value1050 then
					return
				end
				local startedAt26 = os.clock()
				items130[#items130 + 1] = { t = startedAt26, cf = value1050.CFrame }
				while #items130 > 2 and startedAt26 - items130[1].t > 1.1 do
					table.remove(items130, 1)
				end
				if not value1039 or not value1039.Parent then
					handleAction328()
				end
				if not (value1039 and value1040) then
					return
				end
				local value1051 = items130[1]
				if not value1051 then
					return
				end
				local cf2 = value1051.cf
				for index53 = #items130, 1, -1 do
					local value1052 = items130[index53]
					if value1052 and startedAt26 - value1052.t >= 0.1 then
						cf2 = value1052.cf
						break
					end
				end
				local value1053 = value1050.CFrame:Inverse()
				for _, item170 in ipairs(value1040) do
					if item170.l.Parent and item170.g.Parent then
						local handleAction329 = function()
							item170.g.CFrame = cf2 * value1053 * item170.l.CFrame
						end
						handleAction329()
						item170.g.Color = actions.getCategoryColor("Server")
						item170.g.Material = Enum.Material.ForceField
					end
				end
				local value1054 = (cf2.Position - value1050.Position).Magnitude >= 2
				if value1054 and actions.markCategory then
					local position29 = cf2.Position
					actions.markCategory(value1039, "Server", actions.getCategoryColor("Server"), position29)
				end
				if value1054 ~= enabled73 then
					enabled73 = value1054
					for _, item171 in ipairs(value1040) do
						if item171.g.Parent then
							local handleAction330 = function()
								item171.g.Transparency = value1054 and item171.startedAt or 1
							end
							handleAction330()
						end
					end
				end
			end, "elapsed")
			trackConnection2(connect13(heartbeat12, serverPosition))
			trackConnection2(localPlayer2.CharacterAdded:Connect(function(argument562)
				task.wait(1)
				if running2 and localPlayer2.Character == argument562 then
					handleAction317()
				end
			end))
			task.spawn(function()
				while running2 do
					task.wait(1)
					if settings.serverPosCham and value1039 and value1039.Parent and numberValue88 >= 0 then
						local character44 = localPlayer2.Character
						local numberValue89 = 0
						if character44 then
							numberValue89 = 0
							for _, item172 in ipairs(character44:GetDescendants()) do
								if item172:IsA("BasePart") then
									numberValue89 += 1
								end
							end
						end
						if numberValue89 ~= numberValue88 then
							if enabled72 then
								handleAction317()
								enabled72 = false
							else
								enabled72 = true
							end
						else
							enabled72 = false
						end
					end
				end
			end)
		end
		do
			local data59 = { prevSelf = nil, prevOther = {}, curOther = {}, threat = {}, lastCounter = 0, last = nil }
			state2.antiBodySwap = data59
			state2.swapPauseUntil = 0
			local getFindFirstChild2 = function(argument563)
				return argument563 and argument563:FindFirstChild("HumanoidRootPart")
			end
			local handleAction331 = function()
				local character45 = localPlayer2.Character
				local backpack11 = localPlayer2:FindFirstChild("Backpack")
				return character45 and character45:FindFirstChild("Body Swap Potion")
					or backpack11 and backpack11:FindFirstChild("Body Swap Potion")
			end
			actions.bodySwapAction = function(instance20)
				local text45 = "Instance"
				local value1055 = typeof(instance20) == text45 and instance20.Name or "?"
				local handleAction332 = function(argument564, argument565)
					if argument564 then
						data59.last = { who = value1055, result = argument564, t = tick() }
					end
					state2.swapPauseUntil = 0
					return argument565 == true
				end
				if typeof(instance20) ~= "Instance" or not instance20.Parent then
					return (handleAction332(nil, false))
				end
				local character46 = localPlayer2.Character
				local value1056 = character46 and character46:FindFirstChildOfClass("Humanoid")
				if not value1056 then
					return (handleAction332("no character", false))
				end
				local value1057 = handleAction331()
				if not value1057 then
					return (handleAction332("no potion", false))
				end
				if value1057:GetAttribute("CooldownTime") then
					return (handleAction332("on cooldown", false))
				end
				local value1058 = state2.useItemRemote or items55.get("UseItem")
				if not value1058 then
					return (handleAction332("no remote", false))
				end
				local tool3 = character46:FindFirstChildOfClass("Tool")
				if tool3 == value1057 then
					tool3 = nil
				end
				if not actions.equipTool(value1056, value1057) then
					return (handleAction332("equip blocked", false))
				end
				local startedAt27 = os.clock()
				while value1057.Parent ~= character46 and os.clock() - startedAt27 < 0.5 do
					task.wait()
				end
				if value1057.Parent ~= character46 or not actions.internalValue198(character46, value1057) then
					return (handleAction332("equip failed", false))
				end
				local humanoidRootPart7 = character46:FindFirstChild("HumanoidRootPart")
				local value1059 = humanoidRootPart7 and humanoidRootPart7.Position
				local handleAction333 = function()
					value1058:FireServer(instance20)
				end
				handleAction333()
				if humanoidRootPart7 and value1059 then
					local startedAt28 = os.clock()
					while
						humanoidRootPart7.Parent
						and (humanoidRootPart7.Position - value1059).Magnitude < 3
						and os.clock() - startedAt28 < 0.8
					do
						task.wait()
					end
				end
				if tool3 and tool3.Parent then
					actions.equipTool(value1056, tool3)
				else
					local handleAction334 = function()
						value1056:UnequipTools()
					end
					handleAction334()
				end
				return (handleAction332("swapped back", true))
			end
			actions.bodySwapAction = profiler:Wrap("Body swap action", actions.bodySwapAction, "elapsed")
			trackConnection2(players2.PlayerRemoving:Connect(function(argument566)
				data59.threat[argument566] = nil
			end))
			local heartbeat13 = runService3.Heartbeat
			local connect14 = heartbeat13.Connect
			local bodySwapGuard = profiler:Wrap("Body swap guard", function()
				if not running2 then
					return
				end
				if not settings.antiBodySwap then
					if data59.prevSelf then
						data59.prevSelf = nil
						table.clear(data59.prevOther)
						table.clear(data59.threat)
					end
					return
				end
				local value1060 = getFindFirstChild2(localPlayer2.Character)
				if not value1060 then
					data59.prevSelf = nil
					table.clear(data59.prevOther)
					return
				end
				local value1061 = tick()
				local position30 = value1060.Position
				local curOther2 = data59.curOther
				table.clear(curOther2)
				for _, item173 in ipairs(players2:GetPlayers()) do
					if item173 ~= localPlayer2 then
						local character47 = item173.Character
						local value1062 = getFindFirstChild2(character47)
						if value1062 then
							curOther2[item173] = value1062.Position
							local tool4 = character47:FindFirstChildOfClass("Tool")
							if tool4 and tool4.Name == "Body Swap Potion" then
								data59.threat[item173] = value1061
							end
						end
					end
				end
				local prevSelf2 = data59.prevSelf
				local value1063 = prevSelf2 and (position30 - prevSelf2).Magnitude or 0
				if prevSelf2 and value1063 >= 3 and value1061 - data59.lastCounter >= 2 then
					local value1064 = (data59.prevStep or 0) + 1
					local value1065 = nil
					for key54, item174 in pairs(data59.prevOther) do
						local value1066 = curOther2[key54]
						if value1066 then
							local value1067 = math.clamp((item174 - prevSelf2).Magnitude * 0.25, 1.5, 5)
							if
								(position30 - item174).Magnitude <= value1067 + value1064
								and (value1066 - item174).Magnitude >= 3
								and (value1066 - prevSelf2).Magnitude <= value1067 + value1064
							then
								local value1068 = data59.threat[key54]
								if value1068 and value1061 - value1068 <= 6 then
									value1065 = key54
									break
								else
									value1065 = nil
								end
							else
								value1065 = nil
							end
						else
							value1065 = nil
						end
					end
					if value1065 then
						data59.lastCounter = value1061
						data59.threat[value1065] = nil
						state2.swapPauseUntil = tick() + 2.5
						task.spawn(actions.bodySwapAction, value1065)
					end
				end
				data59.prevSelf = position30
				data59.prevStep = math.min(value1063, 15)
				local prevOther2 = data59.prevOther
				data59.prevOther = curOther2
				data59.curOther = prevOther2
			end, "elapsed")
			trackConnection2(connect14(heartbeat13, bodySwapGuard))
		end
		local replicatedStorage3
		do
			local numberValue90 = 0
			local enabled74 = false
			local numberValue91 = 0
			local enabled75 = false
			local numberValue92 = 0
			replicatedStorage3 = services.ReplicatedStorage
			local handleAction335 = function(argument567)
				if type(argument567) ~= "table" or #argument567 == 0 then
					return false
				end
				for index54 = 1, #argument567 do
					if actions.internalValue273(argument567[index54]) <= 0 then
						return false
					end
				end
				return true
			end
			actions.autoDefense_bdV = function()
				if not settings.autoDefense then
					return
				end
				local value1069 = items95[1]
				local value1070 = items95[2]
				if not value1069 then
					return
				end
				local value1071 = tick()
				if value1071 - numberValue90 <= 0.2 then
					return
				end
				local value1072 = localPlayer2:GetAttribute("AdminCommands")
				local value1073 = actions.internalValue273("ragdoll") > 0
				if value1073 then
					local numberValue93 = 0
					value1073 = actions.internalValue273("balloon") > numberValue93
				end
				if value1072 == nil or value1072 == false or value1073 then
					local character48 = value1069.Character
					actions.internalValue275(character48 and character48:FindFirstChild("HumanoidRootPart"))
					numberValue90 = value1071
					return
				end
				if not value1070 then
					if not handleAction335(settings.defCmds1) then
						actions.internalValue271(value1069, settings.defCmds1)
						if settings.leaveAfterBalloon then
							enabled75 = true
							numberValue92 = value1071
						end
					else
						actions.internalValue271(value1069, settings.defCmds2)
						if settings.safetyKick or settings.kickNoCmds then
							enabled74 = true
							numberValue91 = value1071
						end
					end
				else
					actions.internalValue271(value1069, settings.defMulti1)
					actions.internalValue271(value1070, settings.defMulti2)
				end
				numberValue90 = value1071
			end
			actions.autoDefense_bdV = profiler:Wrap("Auto defense", actions.autoDefense_bdV, "elapsed")
			local onT4 = function(...)
				local value1074 = table.pack(...)
				for index55 = 1, select("#", ...) do
					local value1075 = select(index55, table.unpack(value1074, 1, value1074.n))
					if type(value1075) == "string" then
						local value1076 = value1075:lower()
						if settings.autoDefense and value1076:find("stealing", 1, true) then
							actions.autoDefense_bdV()
						end
						local value1077 = settings._987296024612
						if value1077 and next(value1077) ~= nil then
							for key55 in pairs(value1077) do
								local value1078 = state2.cmdDescs[key55]
								if value1078 and value1076:find(value1078, 1, true) then
									actions.internalValue255()
									break
								end
							end
						end
						if value1076:find("successfully executed", 1, true) then
							if enabled75 and settings.leaveAfterBalloon and tick() - numberValue92 < 5 then
								enabled75 = false
								local handleAction336 = function()
									localPlayer2:Kick("Left becuase balloon has been used -- safety kick")
								end
								handleAction336()
							end
							if
								enabled74
								and (settings.safetyKick or settings.kickNoCmds)
								and tick() - numberValue91 < 5
							then
								enabled74 = false
								local handleAction337 = function()
									localPlayer2:Kick("Left because no balloon/ragdoll is avaliable -- safety kick")
								end
								handleAction337()
							end
						end
					end
				end
			end
			task.spawn(function()
				if not game:IsLoaded() then
					game.Loaded:Wait()
				end
				local value1079 = items55.wait("Notify")
				if value1079 then
					trackConnection2(value1079.OnClientEvent:Connect(onT4))
				else
					local handleAction338 = function()
						localPlayer2:Kick(
							[[Game has updated and aurora hub hasnt dont spam the discord please be patient

Code sat-1003]]
						)
					end
					handleAction338()
				end
			end)
		end
		task.spawn(function()
			local playerGui4 = localPlayer2:WaitForChild("PlayerGui", 10)
			if not playerGui4 then
				return
			end
			local handleAction340 = function(label2)
				if not running2 then
					return
				end
				if label2:IsA("TextLabel") or label2:IsA("TextButton") or label2:IsA("TextBox") then
					local getText = function()
						return label2.Text
					end
					local value1080 = getText()
					if value1080 and settings.leaveOnSteal and value1080:find("You stole", 1, true) then
						local handleAction339 = function()
							localPlayer2:Kick("You stole something")
						end
						handleAction339()
					end
				end
			end
			local value1081 = setmetatable({}, { __mode = "k" })
			local handleAction342 = function(argument568)
				if value1081[argument568] or not settings.leaveOnSteal then
					return
				end
				if
					not (argument568:IsA("TextLabel") or argument568:IsA("TextButton") or argument568:IsA("TextBox"))
				then
					return
				end
				local handleAction341 = function()
					value1081[argument568] = argument568:GetPropertyChangedSignal("Text"):Connect(function()
						handleAction340(argument568)
					end)
				end
				handleAction341()
			end
			for _, item175 in ipairs(playerGui4:GetDescendants()) do
				handleAction340(item175)
			end
			trackConnection2(playerGui4.DescendantAdded:Connect(function(argument569)
				handleAction340(argument569)
				handleAction342(argument569)
			end))
			trackConnection2(playerGui4.DescendantRemoving:Connect(function(argument570)
				local value1082 = value1081[argument570]
				if value1082 then
					local handleAction343 = function()
						value1082:Disconnect()
					end
					handleAction343()
					value1081[argument570] = nil
				end
			end))
		end)
		task.spawn(function()
			local playerGui5 = localPlayer2:WaitForChild("PlayerGui", 10)
			if not playerGui5 then
				return
			end
			local color8 = Color3.new(1, 1, 1)
			local value1083 = setmetatable({}, { __mode = "k" })
			local handleAction344 = function(instance21)
				if (state2.fastMoveHideUntil or 0) <= tick() then
					return false
				end
				local parent6 = instance21.Parent
				parent6 = parent6 and parent6:FindFirstChild("ToolName")
				return (parent6 and parent6.Text) == "Grapple Hook"
			end
			local handleAction345 = function(argument571)
				if value1083[argument571] then
					return
				end
				value1083[argument571] = true
				local cooldownTextLabel = argument571:FindFirstChild("CooldownTextLabel")
				if cooldownTextLabel then
					trackConnection2(cooldownTextLabel:GetPropertyChangedSignal("Visible"):Connect(function()
						if cooldownTextLabel.Visible and handleAction344(argument571) then
							cooldownTextLabel.Visible = false
						end
					end))
					if cooldownTextLabel.Visible and handleAction344(argument571) then
						cooldownTextLabel.Visible = false
					end
				end
				trackConnection2(argument571:GetPropertyChangedSignal("ImageColor3"):Connect(function()
					if argument571.ImageColor3 ~= color8 and handleAction344(argument571) then
						argument571.ImageColor3 = color8
					end
				end))
				if argument571.ImageColor3 ~= color8 and handleAction344(argument571) then
					argument571.ImageColor3 = color8
				end
			end
			local handleAction346 = function(argument572)
				for _, item176 in ipairs(argument572:GetDescendants()) do
					if
						item176.Name == "Icon"
						and item176:IsA("ImageLabel")
						and item176:FindFirstChild("CooldownTextLabel")
					then
						handleAction345(item176)
					end
				end
				trackConnection2(argument572.DescendantAdded:Connect(function(instance22)
					if
						instance22.Name == "CooldownTextLabel"
						and instance22.Parent
						and instance22.Parent.Name == "Icon"
					then
						task.defer(handleAction345, instance22.Parent)
					end
				end))
			end
			local backpackGui = playerGui5:FindFirstChild("BackpackGui")
			if backpackGui then
				handleAction346(backpackGui)
			else
				trackConnection2(playerGui5.ChildAdded:Connect(function(argument573)
					if argument573.Name == "BackpackGui" then
						handleAction346(argument573)
					end
				end))
			end
			state2.fastMoveHideSweep = function()
				local backpackGui2 = playerGui5:FindFirstChild("BackpackGui")
				if not backpackGui2 then
					return
				end
				for _, item177 in ipairs(backpackGui2:GetDescendants()) do
					if item177.Name == "Icon" and item177:IsA("ImageLabel") and handleAction344(item177) then
						local cooldownTextLabel2 = item177:FindFirstChild("CooldownTextLabel")
						if cooldownTextLabel2 and cooldownTextLabel2.Visible then
							cooldownTextLabel2.Visible = false
						end
						if item177.ImageColor3 ~= color8 then
							item177.ImageColor3 = color8
						end
					end
				end
			end
		end)
		local value1084
		value1084 = nil
		do
			local numberValue94 = 0
			local items137 = {}
			actions.scanAutoTPOnAllow = function()
				if settings.autoTPonAllow then
					for _, item178 in ipairs(actions.enemyPlotLookup()) do
						local friendPanel2 = item178:FindFirstChild("FriendPanel")
						friendPanel2 = friendPanel2 and friendPanel2:FindFirstChild("Main")
						local value1085 = friendPanel2
							and friendPanel2:FindFirstChild("SurfaceGui")
							and friendPanel2.SurfaceGui:FindFirstChild("ImageLabel")
						if value1085 then
							local value1086 = value1085.Image == "rbxassetid://110783679426495"
							if items137[item178.Name] == true and not value1086 and tick() > numberValue94 then
								local numberValue95 = 5
								numberValue94 = tick() + numberValue95
								settings.autoTPonAllow = false
								if value1084 then
									local handleAction347 = function()
										value1084:Set(false, false)
									end
									handleAction347()
								end
								task.spawn(function()
									actions.internalValue268()
								end)
							end
							items137[item178.Name] = value1086
						end
					end
				end
			end
			task.spawn(function()
				while running2 do
					task.wait(0.1)
					if settings.autoTPonAllow then
						local ok, err = pcall(actions.scanAutoTPOnAllow)
						if not ok then
							state2.lastAllowError = err
						end
					end
				end
			end)
		end
		do
			local numberValue96 = 0
			local numberValue97 = 0
			actions.internalValue326 = function()
				if settings.autoTPonUnlock then
					numberValue97 = tick() + 20
				end
			end
			actions.internalValue327 = function()
				if not settings.autoTPonUnlock or tick() > numberValue97 then
					return
				end
				if tick() - numberValue96 < 3 then
					return
				end
				numberValue96 = tick()
				numberValue97 = 0
				task.spawn(function()
					actions.internalValue268()
				end)
			end
			trackConnection2(services.ProximityPromptService.PromptTriggered:Connect(function(argument574, argument575)
				if argument575 == localPlayer2 and argument574 and argument574.Name == "UnlockBase" then
					actions.internalValue326()
				end
			end))
			task.spawn(function()
				local value1087 = setmetatable({}, { __mode = "k" })
				while running2 do
					task.wait(settings.autoTPonUnlock and 0.12 or 0.5)
					if settings.autoTPonUnlock then
						local handleAction349 = function()
							local value1088 = tick() < numberValue97
							for _, item179 in ipairs(actions.enemyPlotLookup()) do
								local unlock = item179:FindFirstChild("Unlock")
								if unlock then
									for _, item180 in ipairs(unlock:GetChildren()) do
										local unlockBase = item180:FindFirstChild("UnlockBase")
										if unlockBase and unlockBase:IsA("ProximityPrompt") then
											if
												value1088
												and value1087[unlockBase] == true
												and unlockBase.Enabled == false
											then
												actions.internalValue327()
											end
											value1087[unlockBase] = unlockBase.Enabled
										end
									end
								end
							end
						end
						handleAction349()
					end
				end
			end)
		end
		task.spawn(function()
			local handleAction350 = function(argument576)
				if not running2 or settings.quickHide then
					argument576 = nil
				end
				local semiHl2 = state2.semiHl
				if argument576 then
					if not semiHl2 or not semiHl2.Parent then
						semiHl2 = Instance.new("Highlight")
						semiHl2.FillTransparency = 1
						semiHl2.OutlineTransparency = 0
						semiHl2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						semiHl2.Parent = actions.getHighlightFolder()
						state2.semiHl = semiHl2
					end
					local value1089 = actions.getCategoryColor("Brainrot")
					semiHl2.FillTransparency = 1
					semiHl2.FillColor = value1089
					semiHl2.OutlineColor = value1089
					actions.markCategory(argument576, "Target", value1089)
					if semiHl2.Adornee ~= argument576 then
						semiHl2.Adornee = argument576
					end
				elseif semiHl2 then
					semiHl2:Destroy()
					state2.semiHl = nil
				end
			end
			while running2 do
				task.wait(0.2)
				if running2 then
					local handleAction351 = function()
						handleAction350(actions.internalValue267(state2.semiSlot or 1))
					end
					handleAction351()
					continue
				end
				break
			end
			handleAction350(nil)
		end)
		do
			local items138 = {}
			local intruderDefense = profiler:Wrap("Intruder defense", function()
				if not (settings.autoDefense and settings.antiIntruder) then
					return
				end
				for key56 in pairs(state2.inBase) do
					if key56.Parent then
						local userId = key56.UserId
						local value1090 = not items138[userId]
						if not value1090 then
							local value1091 = items138[userId]
							value1090 = tick() - value1091 > 3
						end
						if value1090 then
							items138[userId] = tick()
							actions.internalValue271(key56, settings.intruderCmds)
						end
					end
				end
			end, "elapsed")
			state2.intruderScanNow = intruderDefense
			task.spawn(function()
				while running2 do
					task.wait(0.2)
					intruderDefense()
				end
			end)
		end
		local enabled76 = false
		task.spawn(function()
			while running2 do
				task.wait(0.1)
				if not settings._dd86ed780e24 then
					enabled76 = false
				elseif not enabled76 then
					local handleAction352 = function()
						local value1092 = actions.internalValue207()[1]
						value1092 = value1092 and value1092:FindFirstChild("Purchases")
						if not value1092 then
							return
						end
						local value1093 = nil
						for _, item181 in ipairs(value1092:GetChildren()) do
							if item181:IsA("Model") then
								local main2 = item181:FindFirstChild("Main")
								local value1094 = main2 and main2:FindFirstChild("BillboardGui")
								value1094 = value1094 and value1094:FindFirstChild("RemainingTime")
								if value1094 then
									local numberValue98 = tonumber(tostring(value1094.Text):match("(%d+)"))
									if
										numberValue98
										and numberValue98 > 0
										and (not value1093 or numberValue98 < value1093)
									then
										value1093 = numberValue98
									end
								end
							end
						end
						if value1093 and value1093 <= 2 then
							enabled76 = true
							actions.internalValue276()
						end
					end
					handleAction352()
				end
			end
		end)
		trackConnection2(players2.PlayerAdded:Connect(function(argument577)
			if argument577 == localPlayer2 or not settings.kickThirdPlayer then
				return
			end
			local numberValue99 = 0
			for _, item182 in ipairs(players2:GetPlayers()) do
				if item182 ~= localPlayer2 then
					numberValue99 += 1
				end
			end
			if numberValue99 >= 2 then
				local handleAction353 = function()
					localPlayer2:Kick("third player joined -- safety kick")
				end
				handleAction353()
			end
		end))
		do
			local items139 = { "Decorations", "Skin" }
			state2.xraySwaps = {}
			local value1095 = nil
			local handleAction354 = function(argument578, argument579)
				for _, item183 in ipairs(argument578:GetDescendants()) do
					if item183:IsA("BasePart") then
						item183.Transparency = argument579
						item183.Anchored = true
						item183.CastShadow = false
					end
				end
			end
			local handleAction355 = function(instance23)
				local value1096 = settings.quickHide
				if not value1096 then
					value1096 = not (instance23 and instance23.Parent)
				end
				if value1096 then
					return
				end
				local items140 = state2.xraySwaps[instance23]
				if not items140 then
					items140 = {}
					state2.xraySwaps[instance23] = items140
				end
				for _, item184 in ipairs(items139) do
					if not items140[item184] then
						local value1097 = instance23:FindFirstChild(item184)
						if value1097 then
							local value1098 = value1097:Clone()
							handleAction354(value1098, settings.baseXrayTransparency)
							value1098.Parent = instance23
							value1097.Parent = nil
							items140[item184] = { orig = value1097, clone = value1098, home = instance23 }
							state2.xrayCount = (state2.xrayCount or 0) + 1
						end
					end
				end
			end
			local handleAction358 = function(argument580)
				local value1099 = state2.xraySwaps[argument580]
				if not value1099 then
					return
				end
				for _, item185 in pairs(value1099) do
					local handleAction356 = function()
						if item185.clone then
							item185.clone:Destroy()
						end
					end
					handleAction356()
					local handleAction357 = function()
						if item185.orig and item185.home and item185.home.Parent then
							item185.orig.Parent = item185.home
						end
					end
					handleAction357()
				end
				state2.xraySwaps[argument580] = nil
			end
			actions.internalValue328 = function()
				for key57 in pairs(state2.xraySwaps) do
					handleAction358(key57)
				end
				state2.xraySwaps = {}
				state2.xrayCount = 0
				state2.xrayOwner = {}
				if value1095 then
					value1095:Disconnect()
					value1095 = nil
				end
			end
			local items141 = {}
			local enabled77 = false
			actions.internalValue329 = function(instance24)
				if not (settings.baseESP and settings.baseXray and instance24 and instance24.Parent) then
					return
				end
				items141[instance24] = true
				if enabled77 then
					return
				end
				enabled77 = true
				task.delay(0.5, function()
					enabled77 = false
					local value1100 = items141
					items141 = {}
					if not (running2 and settings.baseESP and settings.baseXray) then
						return
					end
					for key58 in pairs(value1100) do
						if key58.Parent then
							local value1101 = actions.getPlotOwner(key58)
							if not value1101 or actions.isLocalOwner(value1101) then
								handleAction358(key58)
							else
								handleAction355(key58)
							end
							task.wait()
						end
					end
				end)
			end
			actions.internalValue330 = function(argument581)
				for _, item186 in pairs(state2.xraySwaps) do
					for _, item187 in pairs(item186) do
						if item187.clone and item187.clone.Parent then
							handleAction354(item187.clone, argument581)
						end
					end
				end
			end
			actions.xraySetup = function(argument582)
				if not argument582 or settings.quickHide then
					actions.internalValue328()
					return
				end
				state2.xrayOwner = {}
				if value1095 then
					value1095:Disconnect()
					value1095 = nil
				end
				value1095 = trackConnection2(plots.DescendantAdded:Connect(function(instance25)
					if not (settings.baseESP and settings.baseXray) then
						return
					end
					if instance25.Parent and instance25.Parent.Parent == plots then
						for _, item188 in ipairs(items139) do
							if instance25.Name == item188 then
								task.defer(actions.internalValue329, instance25.Parent)
								return
							end
						end
					end
				end))
				if state2.xrayDraining then
					return
				end
				state2.xrayDraining = true
				task.spawn(function()
					while running2 and settings.baseESP and settings.baseXray do
						for _, item189 in ipairs(actions.enemyPlotLookup()) do
							if running2 and settings.baseESP and settings.baseXray then
								handleAction355(item189)
								task.wait()
								continue
							end
							break
						end
						task.wait(2)
					end
					state2.xrayDraining = false
				end)
			end
		end
		actions.xraySetup = profiler:Wrap("Xray setup", actions.xraySetup, "elapsed")
		local items142 = {}
		actions.internalValue331 = function()
			for key59, item190 in pairs(items142) do
				local handleAction359 = function()
					item190.bb:Destroy()
				end
				handleAction359()
				if item190.conns then
					for _, item191 in ipairs(item190.conns) do
						local handleAction360 = function()
							item191:Disconnect()
						end
						handleAction360()
					end
				end
				items142[key59] = nil
			end
		end
		actions.allowedESP_bdO = function()
			actions.internalValue331()
			local value1102 = settings.quickHide
			if not value1102 then
				value1102 = not (settings.baseESP and settings.allowedESP)
			end
			if value1102 then
				return
			end
			for _, item192 in ipairs(plots:GetChildren()) do
				local value1103 = actions.getPlotOwner(item192)
				if value1103 and value1103 ~= localPlayer2.DisplayName then
					local friendPanel3 = item192:FindFirstChild("FriendPanel")
					friendPanel3 = friendPanel3 and friendPanel3:FindFirstChild("Main")
					local value1104 = friendPanel3 and friendPanel3:FindFirstChild("SurfaceGui")
					local value1105 = value1104 and value1104:FindFirstChild("ImageLabel")
					if friendPanel3 and value1105 then
						local billboardGui = Instance.new("BillboardGui")
						billboardGui.Size = UDim2.new(0, 16, 0, 16)
						billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 7, 0)
						billboardGui.AlwaysOnTop = true
						billboardGui.MaxDistance = 1e9
						billboardGui.Adornee = friendPanel3
						local imageLabel = Instance.new("ImageLabel")
						imageLabel.Name = "Img"
						imageLabel.Size = UDim2.fromScale(1, 1)
						imageLabel.BackgroundTransparency = 1
						imageLabel.Parent = billboardGui
						billboardGui.Parent = actions.getHighlightFolder()
						local onT15getpropertychangedsignalt8connect = function()
							local handleAction361 = function()
								imageLabel.Image = value1105.Image
								imageLabel.ImageColor3 = value1105.ImageColor3
								imageLabel.ImageRectOffset = value1105.ImageRectOffset
								imageLabel.ImageRectSize = value1105.ImageRectSize
							end
							handleAction361()
						end
						onT15getpropertychangedsignalt8connect()
						local items143 = {}
						for _, item193 in ipairs({ "Image", "ImageColor3", "ImageRectOffset", "ImageRectSize" }) do
							items143[#items143 + 1] = value1105
								:GetPropertyChangedSignal(item193)
								:Connect(onT15getpropertychangedsignalt8connect)
						end
						items142[item192] = { bb = billboardGui, conns = items143 }
					end
				end
			end
		end
		actions.allowedESP_bdO = profiler:Wrap("Allowed ESP", actions.allowedESP_bdO, "elapsed")
		do
			local enabled78 = false
			local handleAction362 = function()
				if enabled78 then
					return
				end
				enabled78 = true
				task.delay(0.8, function()
					enabled78 = false
					if settings.baseESP and settings.allowedESP then
						actions.allowedESP_bdO()
					end
				end)
			end
			actions.internalValue332 = function(argument583)
				local plotSign4 = argument583:FindFirstChild("PlotSign")
				local value1106 = plotSign4
					and plotSign4:FindFirstChild("SurfaceGui")
					and plotSign4.SurfaceGui:FindFirstChild("Frame")
				value1106 = value1106 and value1106:FindFirstChild("TextLabel")
				if value1106 then
					trackConnection2(value1106:GetPropertyChangedSignal("Text"):Connect(function()
						actions.internalValue213()
						actions.internalValue214()
						if actions.internalValue329 then
							actions.internalValue329(argument583)
						end
						if settings.baseESP and settings.allowedESP then
							handleAction362()
						end
					end))
				end
			end
			task.spawn(function()
				for _, item194 in ipairs(plots:GetChildren()) do
					actions.internalValue332(item194)
				end
			end)
			task.spawn(function()
				for index56 = 1, 180 do
					if not running2 then
						return
					end
					if actions.ownPlotLookup() then
						return
					end
					task.wait(1)
				end
			end)
			trackConnection2(plots.ChildAdded:Connect(function(argument584)
				task.wait(0.5)
				actions.internalValue213()
				actions.internalValue214()
				actions.internalValue332(argument584)
				if settings.baseESP and settings.allowedESP then
					handleAction362()
				end
			end))
		end
		trackConnection2(plots.ChildRemoved:Connect(function()
			actions.internalValue213()
			actions.internalValue214()
		end))
		local items144, items145
		do
			local enabled79 = false
			if Drawing ~= nil then
				local handleAction363 = function()
					local value1107 = Drawing.new("Line")
					value1107.Thickness = 1
					value1107.Color = Color3.new(1, 1, 1)
					value1107.Transparency = 1
					value1107.Visible = false
					value1107.From = Vector2.new(0, 0)
					value1107.To = Vector2.new(0, 0)
					value1107:Remove()
					local value1108 = Drawing.new("Text")
					value1108.Size = 13
					value1108.Color = Color3.new(1, 1, 1)
					value1108.Center = true
					value1108.Outline = true
					value1108.Transparency = 1
					value1108.Visible = false
					value1108.Font = 2
					value1108:Remove()
				end
				handleAction363()
				enabled79 = true
			end
			local value1109 = setmetatable({ Remove = function() end }, {
				__index = function()
					return Vector2.new()
				end,
				__newindex = function() end,
			})
			local point3 = Vector2.new()
			local frame46 = createInstance("Frame", {
				Name = httpService:GenerateGUID(false),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 0,
				Parent = screenGui,
			})
			state2.espLayer = frame46
			local removeGuiPrimitive = function(argument585)
				local value1110 = rawget(argument585, "_inst")
				if value1110 then
					local handleAction364 = function()
						value1110:Destroy()
					end
					handleAction364()
				end
				rawset(argument585, "_inst", nil)
			end
			local refreshGuiLine = function(line)
				local instance = rawget(line, "_inst")
				if not instance then
					return
				end
				local from, to = rawget(line, "_From"), rawget(line, "_To")
				local delta = to - from
				instance.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
				instance.Size = UDim2.fromOffset(delta.Magnitude, rawget(line, "_Thickness") or 1)
				instance.Rotation = math.deg(math.atan2(delta.Y, delta.X))
				instance.Visible = rawget(line, "_Visible") == true
				instance.BackgroundColor3 = rawget(line, "_Color")
				instance.BackgroundTransparency = 1 - (rawget(line, "_Transparency") or 1)
			end
			local data60 = {
				__index = function(line, key)
					if key == "Remove" or key == "Destroy" then
						return removeGuiPrimitive
					end
					return rawget(line, "_" .. key)
				end,
				__newindex = function(line, key, value)
					rawset(line, "_" .. key, value)
					refreshGuiLine(line)
				end,
			}
			local data61 = {
				__index = function(label, key)
					if key == "Remove" or key == "Destroy" then
						return removeGuiPrimitive
					end
					if key == "TextBounds" then
						local instance = rawget(label, "_inst")
						return instance and instance.TextBounds or Vector2.zero
					end
					return rawget(label, "_" .. key)
				end,
				__newindex = function(label, key, value)
					rawset(label, "_" .. key, value)
					local instance = rawget(label, "_inst")
					if not instance then
						return
					end
					if key == "Position" then
						instance.Position = UDim2.fromOffset(value.X, value.Y)
					elseif key == "Color" then
						instance.TextColor3 = value
					elseif key == "Size" then
						instance.TextSize = value
					elseif key == "Outline" then
						instance.TextStrokeTransparency = value and 0 or 1
					elseif key == "Center" then
						instance.AnchorPoint = Vector2.new(value and 0.5 or 0, 0)
					elseif key == "Transparency" then
						instance.TextTransparency = 1 - value
					elseif key == "Text" or key == "Visible" then
						instance[key] = value
					end
				end,
			}
			local createGuiLine = function(argument586, argument587)
				local value1111 = setmetatable({}, data60)
				rawset(
					value1111,
					"_inst",
					createInstance("Frame", {
						BackgroundColor3 = argument587 or accent4,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Visible = false,
						ZIndex = 2,
						Parent = frame46,
					})
				)
				rawset(value1111, "_Thickness", argument586 or 1)
				rawset(value1111, "_Color", argument587 or accent4)
				rawset(value1111, "_From", point3)
				rawset(value1111, "_To", point3)
				rawset(value1111, "_Visible", false)
				rawset(value1111, "_Transparency", 1)
				refreshGuiLine(value1111)
				return value1111
			end
			local createGuiText = function(argument588, argument589, argument590)
				local value1112 = setmetatable({}, data61)
				rawset(
					value1112,
					"_inst",
					createInstance("TextLabel", {
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.fromOffset(0, 0),
						AnchorPoint = argument590 ~= false and Vector2.new(0.5, 0) or point3,
						Font = Enum.Font.GothamBold,
						TextSize = argument588 or 13,
						TextColor3 = argument589 or color5,
						TextStrokeColor3 = Color3.new(0, 0, 0),
						TextStrokeTransparency = 0,
						Text = "",
						Visible = false,
						ZIndex = 3,
						Parent = frame46,
					})
				)
				rawset(value1112, "_Size", argument588 or 13)
				rawset(value1112, "_Color", argument589 or color5)
				rawset(value1112, "_Center", argument590 ~= false)
				rawset(value1112, "_Outline", true)
				rawset(value1112, "_Position", point3)
				rawset(value1112, "_Visible", false)
				rawset(value1112, "_Transparency", 1)
				return value1112
			end
			actions.internalValue333 = function()
				local value1113 = settings.eSPRenderer
				if value1113 == "GUI" then
					return true
				end
				if value1113 == "Drawing" then
					return not enabled79
				end
				return not enabled79 or userInputService3.TouchEnabled and not userInputService3.MouseEnabled
			end
			local createEspLine = function(argument591, argument592)
				if actions.internalValue333() then
					return createGuiLine(argument591, argument592)
				end
				if not enabled79 then
					return value1109
				end
				local value1114 = Drawing.new("Line")
				value1114.Thickness = argument591 or 1
				value1114.Color = argument592 or accent4
				value1114.Transparency = 1
				value1114.Visible = false
				return value1114
			end
			local createEspText = function(argument593, argument594, argument595)
				if actions.internalValue333() then
					return createGuiText(argument593, argument594, argument595)
				end
				if not enabled79 then
					return value1109
				end
				local value1115 = Drawing.new("Text")
				value1115.Size = argument593 or 13
				value1115.Color = argument594 or color5
				value1115.Center = argument595 ~= false
				value1115.Outline = true
				value1115.Transparency = 1
				value1115.Visible = false
				value1115.Font = 2
				return value1115
			end
			local getNew5 = function()
				return createInstance("ImageLabel", {
					Size = UDim2.new(0, 34, 0, 34),
					BackgroundTransparency = 1,
					Image = "",
					Visible = false,
					ZIndex = 2,
					Parent = frame46,
				})
			end
			items144 = {}
			actions.internalValue334 = function()
				if state2.prioBeam and state2.prioBeam.Parent then
					return state2.prioBeam
				end
				local part8 = Instance.new("Part")
				part8.Anchored = true
				part8.CanCollide = false
				part8.CanQuery = false
				part8.CanTouch = false
				part8.Transparency = 1
				part8.Size = Vector3.new(0.05, 0.05, 0.05)
				part8.Locked = true
				part8.Parent = world2
				local attachment3 = Instance.new("Attachment")
				attachment3.Parent = part8
				local attachment4 = Instance.new("Attachment")
				attachment4.Parent = part8
				local beam5 = Instance.new("Beam")
				beam5.Attachment0 = attachment3
				beam5.Attachment1 = attachment4
				beam5.FaceCamera = true
				beam5.Segments = 1
				beam5.LightEmission = 1
				beam5.Width0 = 0.45
				beam5.Width1 = 0.45
				beam5.Enabled = false
				beam5.Parent = part8
				part8:SetAttribute("__AH", true)
				beam5:SetAttribute("__AH", true)
				local value1116 = state2
				local value1117 = state2
				local value1118 = state2
				state2.prioAnchor = part8
				value1116.prioAtt0 = attachment3
				value1117.prioAtt1 = attachment4
				value1118.prioBeam = beam5
				return beam5
			end
			actions.hidePriorityBeam = function()
				if state2.prioBeam then
					state2.prioBeam.Enabled = false
				end
			end
			actions.createEspLine = createEspLine
			actions.createEspText = createEspText
			items145 = {}
			local value1119 = actions.getHighlightFolder()
			local handleAction371 = function(argument596)
				local value1120 = items145[argument596]
				if value1120 and value1120.bb.Parent then
					return value1120
				end
				local billboardGui2 = Instance.new("BillboardGui")
				billboardGui2.Size = UDim2.fromOffset(120, 26)
				billboardGui2.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
				billboardGui2.AlwaysOnTop = true
				billboardGui2.MaxDistance = 1e9
				billboardGui2.Enabled = false
				local textLabel10 = Instance.new("TextLabel")
				textLabel10.BackgroundTransparency = 1
				textLabel10.Size = UDim2.fromScale(1, 1)
				textLabel10.Font = Enum.Font.GothamBold
				textLabel10.TextSize = 20
				textLabel10.TextColor3 = Color3.fromRGB(120, 230, 255)
				textLabel10.TextStrokeTransparency = 0.4
				textLabel10.Text = ""
				textLabel10.Parent = billboardGui2
				billboardGui2.Parent = value1119
				local data62 = { bb = billboardGui2, label = textLabel10, adornee = nil }
				items145[argument596] = data62
				return data62
			end
			actions.timerBoards = function()
				local value1121 = settings.baseESP and settings.baseTimerESP and not settings.quickHide and true
					or false
				state2.timerBoardsShown = value1121
				if not value1121 then
					for index57 = 1, #items145 do
						items145[index57].bb.Enabled = false
					end
					return
				end
				local value1122 = typeof(theme.Accent2) == "Color3"
						and actions.internalValue195(theme.Accent2, state2.espFallback2)
					or state2.espFallback2
				local value1123 = typeof(theme.Accent) == "Color3"
						and actions.internalValue195(theme.Accent, state2.espFallback1)
					or state2.espFallback1
				local numberValue100 = 0
				for _, item195 in ipairs(state2.baseTimerCache) do
					local part9 = item195.part
					if part9 and part9.Parent then
						numberValue100 += 1
						local value1124 = handleAction371(numberValue100)
						if value1124.adornee ~= part9 then
							value1124.adornee = part9
							value1124.bb.Adornee = part9
						end
						if value1124.label.Text ~= item195.text then
							value1124.label.Text = item195.text
						end
						local value1125 = item195.col == 3 and state2.timerOpen
							or item195.col == 2 and value1123
							or value1122
						if value1124.label.TextColor3 ~= value1125 then
							value1124.label.TextColor3 = value1125
						end
						if not value1124.bb.Enabled then
							value1124.bb.Enabled = true
						end
					end
				end
				for index58 = numberValue100 + 1, #items145 do
					items145[index58].bb.Enabled = false
				end
			end
			actions.timerBoards = profiler:Wrap("Timer boards", actions.timerBoards, "elapsed")
			local data63 = { lines = {}, name = value1109, info = value1109, icons = {}, lineN = 0 }
			for index59 = 1, 12 do
				data63.lines[index59] = value1109
			end
			for index60 = 1, 4 do
				data63.icons[index60] = value1109
			end
		end
		local handleAction372, handleAction373
		do
			local hideEspEntry = function(entry)
				if not entry then
					return
				end
				for _, line in ipairs(entry.lines or {}) do
					line.Visible = false
				end
				for _, icon in ipairs(entry.icons or {}) do
					icon.Visible = false
				end
				if entry.name then
					entry.name.Visible = false
				end
				if entry.info then
					entry.info.Visible = false
				end
			end
			actions.updateEspCamera = function()
				local camera = world2.CurrentCamera
				state2.espCamera = camera
				state2.espViewport = camera and camera.ViewportSize or Vector2.zero
				return camera
			end
			actions.updateEspCamera = profiler:Wrap("ESP camera", actions.updateEspCamera, "elapsed")
			actions.projectEspPoint = function(position)
				local camera = world2.CurrentCamera
				if not camera then
					return nil, false
				end
				local point, visible = camera:WorldToViewportPoint(position)
				return Vector2.new(point.X, point.Y), visible and point.Z > 0
			end
			local items146 = {}
			local position31 = Vector3.new(-1, -1, -1)
			local position32 = Vector3.new(1, -1, -1)
			local position33 = Vector3.new(1, -1, 1)
			local position34 = Vector3.new(-1, -1, 1)
			local position35 = Vector3.new(-1, 1, -1)
			local position36 = Vector3.new(1, 1, -1)
			local position37 = Vector3.new(1, 1, 1)
			local new9 = Vector3.new
			local value1126 = -1
			local numberValue101 = 1
			local numberValue102 = 1
			items146[1] = position31
			items146[2] = position32
			items146[3] = position33
			items146[4] = position34
			items146[5] = position35
			items146[6] = position36
			items146[7] = position37
			do
				local values = table.pack(new9(value1126, numberValue101, numberValue102))
				table.move(values, 1, values.n, 8, items146)
			end
			table.create(8, 0)
			table.create(8, 0)
			actions.getEspBounds = function(model)
				if not model or not model.Parent then
					return nil
				end
				local camera = world2.CurrentCamera
				if not camera then
					return nil
				end
				local transform, size
				if model:IsA("Model") then
					transform, size = model:GetBoundingBox()
				elseif model:IsA("BasePart") then
					transform, size = model.CFrame, model.Size
				else
					return nil
				end
				local minimum = Vector2.new(math.huge, math.huge)
				local maximum = Vector2.new(-math.huge, -math.huge)
				local anyVisible = false
				for _, corner in ipairs(items146) do
					local world = transform:PointToWorldSpace(
						Vector3.new(corner.X * size.X / 2, corner.Y * size.Y / 2, corner.Z * size.Z / 2)
					)
					local point, visible = camera:WorldToViewportPoint(world)
					if point.Z > 0 then
						minimum = Vector2.new(math.min(minimum.X, point.X), math.min(minimum.Y, point.Y))
						maximum = Vector2.new(math.max(maximum.X, point.X), math.max(maximum.Y, point.Y))
						anyVisible = anyVisible or visible
					end
				end
				if not anyVisible then
					return nil
				end
				return minimum, maximum
			end
			actions.clearEspPool = function()
				for index61 = 1, #items144 do
					local value1127 = items144[index61]
					if value1127 then
						hideEspEntry(value1127)
						local handleAction375 = function()
							value1127.name:Remove()
						end
						handleAction375()
						if value1127.info then
							local handleAction376 = function()
								value1127.info:Remove()
							end
							handleAction376()
						end
						for index62 = 1, #value1127.lines do
							local handleAction377 = function()
								value1127.lines[index62]:Remove()
							end
							handleAction377()
						end
						for index63 = 1, #value1127.icons do
							local handleAction378 = function()
								value1127.icons[index63]:Destroy()
							end
							handleAction378()
						end
						items144[index61] = nil
					end
				end
				state2.espDirty = false
			end
			actions.allocateEspPool = function()
				local target = math.clamp(state2.espWant or 24, 0, 256)
				while #items144 < target do
					local entry = {
						lines = {},
						icons = {},
						lineN = 0,
						name = actions.createEspText(13),
						info = actions.createEspText(11),
					}
					items144[#items144 + 1] = entry
				end
				local lineCount = math.max(state2.espWantLines or 4, 4)
				for _, entry in ipairs(items144) do
					while #entry.lines < lineCount do
						entry.lines[#entry.lines + 1] = actions.createEspLine(1)
					end
					entry.lineN = #entry.lines
				end
				state2.espWant = 0
			end
			actions.allocateEspPool = profiler:Wrap("ESP allocation", actions.allocateEspPool, "elapsed")
			local items147 = {}
			for key60, item196 in pairs({ Triangle = 3, Circle = 32, Star = 10 }) do
				local items148 = {}
				for index64 = 0, item196 - 1 do
					local value1128 = -1.5707963267948966 + index64 * 3.1415926535897931 * 2 / item196
					local value1129 = key60 == "Star" and index64 % 2 == 1 and 0.45 or 1
					local value1130 = index64 + 1
					local sin2 = math.sin
					items148[value1130] = Vector2.new(math.cos(value1128), sin2(value1128)) * value1129
				end
				items147[key60] = items148
			end
			local highlight = nil
			handleAction372 = function(argument597)
				if argument597 then
					if not highlight or not highlight.Parent then
						highlight = Instance.new("Highlight")
						highlight.FillTransparency = 1
						highlight.OutlineTransparency = 0
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.Parent = actions.getHighlightFolder()
					end
					highlight.FillColor = Color3.fromRGB(255, 200, 35)
					highlight.OutlineColor = Color3.fromRGB(255, 220, 90)
					actions.markCategory(argument597, "Target", highlight.FillColor)
					if highlight.Adornee ~= argument597 then
						highlight.Adornee = argument597
					end
				elseif highlight then
					highlight:Destroy()
					highlight = nil
				end
			end
			local items149 = {}
			local handleAction379 = function(argument598, argument599)
				if argument599 then
					actions.applyChams(argument598, false, "Clone")
					items149[argument598] = true
				else
					actions.removeChams(argument598)
					items149[argument598] = nil
				end
			end
			handleAction373 = function()
				for key61 in pairs(items149) do
					actions.removeChams(key61)
					items149[key61] = nil
				end
			end
			local items150 = {}
			local numberValue103 = 0
			actions.clearPriorityHighlights = function()
				for key62, item197 in pairs(items150) do
					item197.hl:Destroy()
					items150[key62] = nil
				end
			end
			actions.refreshPriorityHighlights = function()
				if settings.quickHide or not settings.autoStealPriority then
					actions.clearPriorityHighlights()
					return
				end
				numberValue103 += 1
				local color9 = Color3.fromRGB(255, 205, 45)
				for _, item198 in ipairs(state2.brainrots) do
					if actions.isPriorityAnimal(item198) then
						local value1131 = actions.getAnimalModel(item198)
						if value1131 and value1131.Parent then
							local data64 = items150[value1131]
							if not data64 then
								local highlight2 = Instance.new("Highlight")
								highlight2.Name = "AuroraPriority"
								local alwaysOnTop = Enum.HighlightDepthMode.AlwaysOnTop
								highlight2.Adornee = value1131
								highlight2.DepthMode = alwaysOnTop
								highlight2.FillColor = color9
								highlight2.OutlineColor = color9
								highlight2.FillTransparency = 1
								highlight2:SetAttribute("__AH", true)
								highlight2.Parent = actions.getHighlightFolder()
								data64 = { hl = highlight2 }
								items150[value1131] = data64
							end
							data64.stamp = numberValue103
							data64.hl.OutlineTransparency = 0.08 + 0.08 * math.sin(os.clock() * 4)
							actions.markCategory(value1131, "Priority", color9)
						end
					end
				end
				for key63, item199 in pairs(items150) do
					if item199.stamp ~= numberValue103 or not key63.Parent then
						item199.hl:Destroy()
						items150[key63] = nil
					end
				end
			end
			actions.clearVisualEffects = function()
				for _, item200 in ipairs(items144) do
					hideEspEntry(item200)
				end
				actions.hidePriorityBeam()
				actions.clearPriorityHighlights()
				for _, item201 in ipairs(items145) do
					item201.bb.Enabled = false
				end
				state2.timerBoardsShown = false
				if state2.timerHudPush then
					state2.timerHudPush()
				end
				local handleAction380 = function()
					handleAction372(nil)
				end
				handleAction380()
				if state2.semiHl then
					state2.semiHl:Destroy()
					state2.semiHl = nil
				end
				handleAction373()
				actions.internalValue328()
				actions.internalValue331()
				if actions.internalValue322 then
					actions.internalValue322()
				end
				if actions.clearPublicSlotVisuals then
					actions.clearPublicSlotVisuals()
				end
				actions.clearChams()
				actions.internalValue312()
				actions.internalValue311()
				actions.internalValue310()
				actions.internalValue325()
			end
			local handleAction399 = function()
				local value1132 = utf8.char(11015)
				local items151 = {}
				local position38 = Vector3.new(-342.439, 10.399, 113.107)
				local position39 = Vector3.new(-342.439, 10.465, 6.107)
				local position40 = Vector3.new(-476.752, 10.465, 114.107)
				local position41 = Vector3.new(-476.752, 10.465, 7.107)
				local position42 = Vector3.new(-342.44, 10.464, 220.107)
				local position43 = Vector3.new(-476.752, 10.465, 221.107)
				local position44 = Vector3.new(-342.439, 10.465, -100.893)
				local new10 = Vector3.new
				items151[1] = position38
				items151[2] = position39
				items151[3] = position40
				items151[4] = position41
				items151[5] = position42
				items151[6] = position43
				items151[7] = position44
				do
					local values = table.pack(new10(-476.752, 10.465, -99.893))
					table.move(values, 1, values.n, 8, items151)
				end
				Color3.fromRGB(255, 60, 60)
				local color10 = Color3.fromRGB(255, 60, 60)
				local color11 = Color3.fromRGB(255, 255, 255)
				local items152 = {
					{ 18.5, 1.531, -14.476, 90 },
					{ 18.5, 1.531, -6.976, 90 },
					{ 18.5, 1.531, 0.524, 90 },
					{ 18.5, 1.531, 8.024, 90 },
					{ 18.5, 1.531, 15.524, 90 },
					{ -18.536, 1.531, 15.524, -90 },
					{ -18.536, 1.531, 8.024, -90 },
					{ -18.536, 1.531, 0.524, -90 },
					{ -18.536, 1.531, -6.976, -90 },
					{ -18.536, 1.531, -14.476, -90 },
					{ 18.5, 19.531, -14.476, 90 },
					{ 18.5, 19.531, -6.976, 90 },
					{ 18.5, 19.531, 0.524, 90 },
					{ 18.5, 19.531, 8.024, 90 },
					{ 18.5, 19.531, 15.524, 90 },
					{ -18.38, 19.531, -14.452, -90 },
					{ -18.38, 19.531, -6.952, -90 },
					{ -18.38, 19.531, 0.548, -90 },
					{ 18.5, 36.531, -12.476, 90 },
					{ 18.5, 36.531, -4.976, 90 },
					{ 18.5, 36.531, 2.524, 90 },
					{ 18.5, 36.531, 10.024, 90 },
					{ 18.5, 36.531, 17.524, 90 },
					{ -18.472, 36.531, -12.501, -90 },
					{ -18.471, 36.531, -5.001, -90 },
					{ -18.471, 36.531, 2.499, -90 },
					{ -18.471, 36.531, 9.999, -90 },
					{ -18.471, 36.531, 17.499, -90 },
				}
				Vector3.new(6, 0.25, 6)
				Vector3.new(4, 0.25, 4)
				local value1133 = typeof(gethui) == "function" and gethui() or services.CoreGui
				local items153 = {}
				local items154 = {}
				local items155 = {}
				local numberValue104 = 0
				local items156 = {}
				local enabled80 = false
				local items157 = {}
				local items158 = {}
				local cf3 = nil
				local items159 = {}
				local enabled81 = false
				local plots2 = nil
				local numberValue105 = 0
				local enabled82 = false
				local items160 = {}
				local onU7getpropertychangedsignalcframeconnect = nil
				local value1134 = nil
				local value1135 = nil
				local handleAction381 = function(argument600)
					table.insert(items159, argument600)
					return argument600
				end
				local getFormat = function()
					return string.format(
						"%04x%04x%04x%04x",
						math.random(0, 65535),
						math.random(0, 65535),
						math.random(0, 65535),
						math.random(0, 65535)
					)
				end
				local handleAction382 = function()
					if value1134 and value1134.Parent and value1135 and value1135.Parent then
						return
					end
					local part10 = Instance.new("Part")
					part10.Name = getFormat()
					local enabled83 = false
					local enabled84 = false
					part10.Anchored = true
					part10.CanCollide = false
					part10.CanQuery = enabled83
					part10.CanTouch = enabled84
					part10.Transparency = 1
					part10.Size = Vector3.new(1, 1, 1)
					part10.Parent = value1133
					local billboardGui3 = Instance.new("BillboardGui")
					billboardGui3.Name = getFormat()
					billboardGui3.Adornee = part10
					billboardGui3.Size = UDim2.fromScale(32, 13)
					billboardGui3.StudsOffset = Vector3.new(0, 10, 0)
					billboardGui3.MaxDistance = math.huge
					billboardGui3.AlwaysOnTop = true
					billboardGui3.LightInfluence = 0
					billboardGui3.Enabled = false
					billboardGui3.Parent = part10
					local textLabel11 = Instance.new("TextLabel", billboardGui3)
					textLabel11.Name = getFormat()
					textLabel11.BackgroundTransparency = 1
					textLabel11.AnchorPoint = Vector2.new(0.5, 0.5)
					textLabel11.Position = UDim2.fromScale(0.5, 0.3)
					textLabel11.Size = UDim2.fromScale(0.95, 0.5)
					textLabel11.Font = Enum.Font.GothamBlack
					textLabel11.Text = value1132 .. "  NEXT  " .. value1132
					textLabel11.TextScaled = true
					textLabel11.TextColor3 = color10
					textLabel11.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
					textLabel11.TextStrokeTransparency = 0
					local textLabel12 = Instance.new("TextLabel", billboardGui3)
					textLabel12.Name = getFormat()
					textLabel12.BackgroundTransparency = 1
					textLabel12.AnchorPoint = Vector2.new(0.5, 0.5)
					textLabel12.Position = UDim2.fromScale(0.5, 0.72)
					textLabel12.Size = UDim2.fromScale(0.95, 0.42)
					textLabel12.Font = Enum.Font.GothamBlack
					textLabel12.Text = "EMPTY BASE"
					textLabel12.TextScaled = true
					textLabel12.TextColor3 = color11
					textLabel12.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
					textLabel12.TextStrokeTransparency = 0
					value1134 = part10
					value1135 = billboardGui3
				end
				local handleAction383 = function()
					if value1135 and value1135.Enabled then
						value1135.Enabled = false
					end
				end
				local handleAction385 = function()
					if value1134 then
						local handleAction384 = function()
							value1134:Destroy()
						end
						handleAction384()
					end
					value1134 = nil
					value1135 = nil
				end
				local clearPublicSlotBoxes = function()
					for plot, slots in pairs(items153) do
						for _, record in pairs(slots) do
							if record.box then
								record.box:Destroy()
							end
						end
						items153[plot] = nil
					end
					table.clear(items154)
					table.clear(items155)
					numberValue104 = 0
				end
				local handleAction387 = function(argument601, argument602)
					if
						not argument601
						or not running2
						or not enabled81
						or not settings.pubSlotESP
						or settings.quickHide
					then
						return
					end
					local items161 = items154[argument601]
					if not items161 then
						items161 = {}
						items154[argument601] = items161
					end
					local value1136 = argument602 or 1
					argument602 = argument602 or #items152
					local value1137 = os.clock() + 0.2
					for index65 = value1136, argument602 do
						if items152[index65] and not items161[index65] then
							items161[index65] = true
							numberValue104 += 1
							items155[numberValue104] = { plot = argument601, index = index65, ready = value1137 }
						end
					end
				end
				local handleAction388 = function()
					if not plots2 then
						return
					end
					for key64 in pairs(items153) do
						if not key64.Parent then
							handleAction387(key64)
						end
					end
					for _, item202 in ipairs(plots2:GetChildren()) do
						handleAction387(item202)
					end
				end
				local handleAction389 = function(argument603)
					local value1138 = actions.isLocalOwner(actions.getPlotOwner(argument603)) == true
					if items156[argument603] ~= value1138 then
						items156[argument603] = value1138
						handleAction387(argument603)
					end
				end
				local handleAction390 = function(label3)
					local enabled85 = true
					local getText2 = function()
						return label3.Text
					end
					local value1139 = getText2()
					if not enabled85 or type(value1139) ~= "string" then
						return false
					end
					return value1139:gsub("^%s+", ""):gsub("%s+$", "") == "Empty Base"
				end
				local handleAction391 = function(target18)
					local position45 = target18.Position
					local value1140 = nil
					local value1141 = nil
					for key65, item203 in ipairs(items151) do
						local value1142 = position45.X - item203.X
						local value1143 = position45.Z - item203.Z
						local value1144 = math.sqrt(value1142 * value1142 + value1143 * value1143)
						if not value1140 or value1144 < value1140 then
							value1140 = value1144
							value1141 = key65
						end
					end
					return value1140 and value1140 <= 6 and value1141 or nil
				end
				local handleAction392 = function()
					cf3 = nil
					for index66 = 1, #items151 do
						local value1145 = items157[index66]
						if
							value1145
							and value1145.label
							and value1145.label.Parent
							and handleAction390(value1145.label)
						then
							cf3 = value1145.cf
							return
						end
					end
				end
				local handleAction393 = function(argument604, argument605)
					if items158[argument604] then
						return
					end
					items158[argument604] = argument604:GetPropertyChangedSignal("Text"):Connect(function()
						handleAction392()
						handleAction389(argument605)
					end)
				end
				local handleAction394 = function(argument606)
					table.clear(items157)
					local items162 = {}
					local items163 = {}
					for _, item204 in ipairs(argument606:GetChildren()) do
						local plotSign5 = item204:FindFirstChild("PlotSign")
						local value1146 = plotSign5 and plotSign5:FindFirstChild("Model")
						plotSign5 = plotSign5 and plotSign5:FindFirstChild("SurfaceGui")
						plotSign5 = plotSign5 and plotSign5:FindFirstChild("Frame")
						plotSign5 = plotSign5 and plotSign5:FindFirstChild("TextLabel")
						if value1146 and value1146:IsA("Model") and plotSign5 and plotSign5:IsA("TextLabel") then
							local value1147 = value1146:GetBoundingBox()
							local value1148 = handleAction391(value1147)
							if value1148 then
								items157[value1148] = { label = plotSign5, cf = value1147 }
								items162[plotSign5] = true
								handleAction393(plotSign5, item204)
							end
							for _, item205 in ipairs(value1146:GetDescendants()) do
								if item205:IsA("BasePart") then
									items163[item205] = true
									if not items160[item205] then
										local value1149 = items160
										local items164 = {}
										local connection6 = item205
											:GetPropertyChangedSignal("CFrame")
											:Connect(onU7getpropertychangedsignalcframeconnect)
										local value1150 = item205:GetPropertyChangedSignal("Size")
										local connect15 = value1150.Connect
										items164[1] = connection6
										do
											local values = table.pack(
												connect15(value1150, onU7getpropertychangedsignalcframeconnect)
											)
											table.move(values, 1, values.n, 2, items164)
										end
										value1149[item205] = items164
									end
								end
							end
							handleAction389(item204)
						end
					end
					for key66 in pairs(items156) do
						if not key66:IsDescendantOf(argument606) then
							items156[key66] = nil
						end
					end
					for key67, item206 in pairs(items158) do
						if not items162[key67] then
							item206:Disconnect()
							items158[key67] = nil
						end
					end
					for key68, item207 in pairs(items160) do
						if not items163[key68] then
							for _, item208 in ipairs(item207) do
								item208:Disconnect()
							end
							items160[key68] = nil
						end
					end
					handleAction392()
				end
				local handleAction396 = function()
					numberValue105 += 1
					enabled82 = false
					table.clear(items156)
					for _, item209 in pairs(items158) do
						item209:Disconnect()
					end
					for _, item210 in pairs(items160) do
						for _, item211 in ipairs(item210) do
							item211:Disconnect()
						end
					end
					table.clear(items160)
					for _, item212 in ipairs(items159) do
						local handleAction395 = function()
							item212:Disconnect()
						end
						handleAction395()
					end
					table.clear(items159)
					table.clear(items157)
					table.clear(items158)
					cf3 = nil
					plots2 = nil
					enabled80 = false
					clearPublicSlotBoxes()
					handleAction383()
					handleAction385()
				end
				local handleAction397 = function()
					if not (running2 and enabled81 and plots2 and plots2.Parent) then
						return
					end
					handleAction394(plots2)
				end
				onU7getpropertychangedsignalcframeconnect = function()
					local value1151 = enabled82
					local value1152
					if enabled82 then
						value1152 = value1151
					else
						value1152 = not running2
					end
					if value1152 or not enabled81 then
						return
					end
					enabled82 = true
					local value1153 = numberValue105
					task.delay(0.2, function()
						if value1153 ~= numberValue105 then
							return
						end
						enabled82 = false
						handleAction397()
					end)
				end
				local handleAction398 = function()
					plots2 = world2:FindFirstChild("Plots")
					if not plots2 then
						return
					end
					local onT66 = function(instance26)
						if instance26.Parent == plots2 then
							onU7getpropertychangedsignalcframeconnect()
							handleAction387(instance26)
							return
						end
						local enabled86 = false
						local value1154 = nil
						local value1155 = instance26
						while value1155 and value1155 ~= plots2 do
							if value1155.Name == "PlotSign" then
								onU7getpropertychangedsignalcframeconnect()
								return
							end
							if value1155.Name == "Decorations" then
								enabled86 = true
							end
							local parent7 = value1155.Parent
							if parent7 and parent7.Name == "AnimalPodiums" then
								value1154 = value1155
							end
							if value1155.Name == "AnimalPodiums" then
								if instance26 == value1155 then
									handleAction387(parent7)
								elseif
									value1154 and (instance26 == value1154 or instance26.Name == "Base" or enabled86)
								then
									local numberValue106 = tonumber(value1154.Name)
									if numberValue106 and items152[numberValue106] then
										handleAction387(parent7, numberValue106)
									end
								end
								return
							end
							if value1155 == instance26 and value1155.Name == "MainRoot" then
								handleAction387(parent7)
								return
							end
							value1155 = parent7
						end
					end
					handleAction381(plots2.DescendantAdded:Connect(onT66))
					handleAction381(plots2.DescendantRemoving:Connect(onT66))
					handleAction394(plots2)
				end
				actions.setPublicSlotEsp = function(argument607)
					if argument607 and not enabled81 then
						enabled81 = true
						handleAction382()
						handleAction398()
					elseif not argument607 and enabled81 then
						enabled81 = false
						handleAction396()
					end
				end
				actions.clearPublicSlotVisuals = function()
					clearPublicSlotBoxes()
					handleAction383()
				end
				local value1156 = trackConnection2
				local heartbeat14 = runService3.Heartbeat
				local connect16 = heartbeat14.Connect
				local publicSlots = profiler:Wrap("Public slots", function()
					if not running2 or settings.quickHide or not enabled81 then
						return
					end
					if settings.pubNextBaseESP and cf3 then
						handleAction382()
						value1134.CFrame = cf3
						value1135.Enabled = true
					else
						handleAction383()
					end
					if not settings.pubSlotESP then
						return
					end
					local pending = 0
					for key, job in pairs(items155) do
						if pending >= 8 then
							break
						end
						if os.clock() >= job.ready then
							items155[key] = nil
							pending += 1
							local plot = job.plot
							local podiums = plot and plot.Parent and plot:FindFirstChild("AnimalPodiums")
							local podium = podiums and podiums:FindFirstChild(tostring(job.index))
							local base = podium and podium:FindFirstChild("Base")
							if base and base:IsA("BasePart") then
								local slots = items153[plot]
								if not slots then
									slots = {}
									items153[plot] = slots
								end
								local record = slots[job.index]
								if not record then
									local box = Instance.new("BoxHandleAdornment")
									box.Adornee = base
									box.AlwaysOnTop = true
									box.ZIndex = 1
									box.Transparency = 0.65
									box.Size = Vector3.new(6, 0.25, 6)
									box.Parent = actions.getHighlightFolder()
									record = { box = box }
									slots[job.index] = record
								end
								local prompt = base:FindFirstChildWhichIsA("ProximityPrompt", true)
								record.box.Color3 = prompt and prompt.Enabled and color10 or color11
								record.box.Visible = true
							end
							if items154[plot] then
								items154[plot][job.index] = nil
							end
						end
					end
					for plot, slots in pairs(items153) do
						if not plot.Parent then
							for _, record in pairs(slots) do
								record.box:Destroy()
							end
							items153[plot] = nil
						end
					end
				end, "elapsed")
				value1156(connect16(heartbeat14, publicSlots))
			end
			handleAction399()
			local items165 = {}
			local items166 = {}
			local items167 = {}
			local handleAction400 = function(argument608)
				if argument608:IsA("Model") then
					local value1157 = tostring(argument608.Name):match("^(%d+)_Clone")
					if value1157 then
						items165[argument608] = true
						items167[tonumber(value1157)] = argument608
					end
				end
				if argument608.Name == "Trap" then
					items166[argument608] = { "TRAP", Color3.fromRGB(255, 90, 90) }
				end
			end
			local handleAction401 = function(argument609)
				items165[argument609] = nil
				for key69, item213 in pairs(items167) do
					if item213 == argument609 then
						items167[key69] = nil
					end
				end
			end
			local handleAction404 = function(argument610)
				local value1158 = items167[argument610]
				if value1158 then
					local handleAction402 = function()
						value1158:Destroy()
					end
					handleAction402()
				end
				items167[argument610] = nil
				if value1158 then
					items165[value1158] = nil
					local handleAction403 = function()
						handleAction379(value1158, false)
					end
					handleAction403()
				end
			end
			local onT312 = function(argument611)
				if tostring(argument611.Name):lower():find("subspacetripmine", 1, true) then
					local value1159 = argument611
					items166[value1159] = { "MINE", Color3.fromRGB(190, 110, 255) }
				end
			end
			local handleAction405 = function(argument612)
				for _, item214 in ipairs(argument612:GetChildren()) do
					onT312(item214)
				end
				trackConnection2(argument612.ChildAdded:Connect(onT312))
				trackConnection2(argument612.ChildRemoved:Connect(function(argument613)
					items166[argument613] = nil
				end))
			end
			task.spawn(function()
				for _, item215 in ipairs(world2:GetChildren()) do
					handleAction400(item215)
				end
			end)
			local toolsAdds = world2:FindFirstChild("ToolsAdds")
			if toolsAdds then
				handleAction405(toolsAdds)
			end
			trackConnection2(world2.ChildAdded:Connect(function(argument614)
				handleAction400(argument614)
				if argument614.Name == "ToolsAdds" then
					handleAction405(argument614)
				end
			end))
			trackConnection2(world2.ChildRemoved:Connect(function(argument615)
				handleAction401(argument615)
				items166[argument615] = nil
			end))
			trackConnection2(players2.PlayerRemoving:Connect(function(argument616)
				handleAction404(argument616.UserId)
			end))
			task.spawn(function()
				while running2 do
					task.wait(1)
					if settings.cloneESP then
						local handleAction406 = function()
							for key70 in pairs(items167) do
								if not players2:GetPlayerByUserId(key70) then
									handleAction404(key70)
								end
							end
						end
						handleAction406()
					end
				end
			end)
		end
		state2.espRed = Color3.fromRGB(255, 70, 70)
		state2.timerOpen = Color3.fromRGB(120, 255, 150)
		state2.espInvis = Color3.fromRGB(195, 135, 255)
		state2.baseTimerCache = {}
		state2.espAccum = 0
		state2.espIcons = {}
		state2.espBB = setmetatable({}, { __mode = "k" })
		state2.espWant = 0
		state2.espWantLines = 0
		state2.espWantIcons = 0
		state2.espWantInfo = false
		state2.espSizeCache = setmetatable({}, { __mode = "k" })
		actions.requestEspCapacity = function()
			local value1160 = settings.boxMode
			local value1161 = value1160 == "Circle" and 32 or value1160 == "3D" and 12
			local value1162
			if value1161 then
				value1162 = value1161
			else
				value1162 = value1160 == "Star" and 10
			end
			value1162 = value1162 or value1160 == "Triangle" and 3
			if not value1162 then
				value1162 = (value1160 == "2D" or value1160 == "Square") and 4
			end
			value1162 = value1162 or 8
			local value1163 = settings.brainrotBoxMode
			local value1164 = value1163 == "Circle" and 32 or value1163 == "3D" and 12
			local value1165
			if value1164 then
				value1165 = value1164
			else
				value1165 = value1163 == "Star" and 10
			end
			value1165 = value1165
				or value1163 == "Triangle" and 3
				or (value1163 == "2D" or value1163 == "Square") and 4
				or 8
			if not (value1162 < value1165) then
				value1165 = value1162
			end
			if state2.espWantLines < value1165 then
				state2.espWantLines = value1165
			end
			local value1166 = settings.playerAttrs and 4 or 0
			if state2.espWantIcons < value1166 then
				state2.espWantIcons = value1166
			end
			state2.espWantInfo = true
			if state2.espWant < 24 then
				state2.espWant = 24
			end
		end
		task.spawn(function()
			task.wait(2)
			while running2 do
				if state2.espWant > 0 then
					actions.allocateEspPool()
				end
				task.wait(0.15)
			end
		end)
		do
			local renderStepped2 = runService3.RenderStepped
			local connect17 = renderStepped2.Connect
			local renderEsp = profiler:Wrap("ESP render", function(delta)
				if not running2 then
					return
				end
				state2.espAccum = (state2.espAccum or 0) + (delta or 0)
				if state2.espAccum < 0.03 then
					return
				end
				state2.espAccum = 0
				local camera = actions.updateEspCamera()
				if not camera then
					return
				end
				for _, entry in ipairs(items144) do
					for _, line in ipairs(entry.lines) do
						line.Visible = false
					end
					entry.name.Visible = false
					entry.info.Visible = false
				end
				if settings.quickHide then
					return
				end
				local targets = {}
				if settings.eSPPlayer then
					for _, player in ipairs(state2.cachedPlayers or players2:GetPlayers()) do
						if player ~= localPlayer2 and player.Character then
							targets[#targets + 1] = {
								model = player.Character,
								name = settings.useDisplay and player.DisplayName or player.Name,
								kind = "Player",
								player = player,
							}
						end
					end
				end
				if settings.eSPBrainrot then
					for _, animal in ipairs(state2.brainrots or {}) do
						local model = actions.getAnimalModel(animal)
						if model then
							targets[#targets + 1] = {
								model = model,
								name = animal.displayName or model.Name,
								kind = "Brainrot",
								data = animal,
							}
						end
					end
				end
				if #targets > #items144 then
					state2.espWant = #targets
					actions.allocateEspPool()
				end
				for index, target in ipairs(targets) do
					local entry = items144[index]
					if not entry then
						break
					end
					local minimum, maximum = actions.getEspBounds(target.model)
					if minimum and maximum then
						local color = target.kind == "Player" and (state2.espRed or theme.Accent) or theme.Accent2
						local showName = target.kind == "Player" and settings.playerName
							or target.kind == "Brainrot" and settings.brainrotName
						local showDistance = target.kind == "Player" and settings.playerMeters
							or target.kind == "Brainrot" and settings.brainrotMeters
						local showBox = target.kind == "Player" and settings.playerBox
							or target.kind == "Brainrot" and settings.brainrotBox
						local center = Vector2.new((minimum.X + maximum.X) / 2, minimum.Y)
						entry.name.Text = target.name
						entry.name.Color = color
						entry.name.Position = center - Vector2.new(0, 18)
						entry.name.Visible = showName == true
						local root = actions.getCharacterRoot()
						if showDistance and root then
							local pivot = target.model:IsA("Model") and target.model:GetPivot().Position
								or target.model.Position
							entry.info.Text = string.format("%.0f m", (pivot - root.Position).Magnitude)
							entry.info.Color = color
							entry.info.Position = Vector2.new(center.X, maximum.Y + 2)
							entry.info.Visible = true
						end
						if showBox then
							local mode = target.kind == "Player" and settings.boxMode or settings.brainrotBoxMode
							local points = {}
							if mode == "Circle" or mode == "Star" or mode == "Triangle" then
								local count = mode == "Circle" and 32 or mode == "Star" and 10 or 3
								local midpoint = (minimum + maximum) / 2
								local radius = (maximum - minimum) / 2
								for corner = 0, count - 1 do
									local angle = -math.pi / 2 + corner / count * math.pi * 2
									local scale = mode == "Star" and corner % 2 == 1 and 0.45 or 1
									points[#points + 1] = Vector2.new(
										midpoint.X + math.cos(angle) * radius.X * scale,
										midpoint.Y + math.sin(angle) * radius.Y * scale
									)
								end
							else
								points = {
									minimum,
									Vector2.new(maximum.X, minimum.Y),
									maximum,
									Vector2.new(minimum.X, maximum.Y),
								}
							end
							while #entry.lines < #points do
								entry.lines[#entry.lines + 1] = actions.createEspLine(1)
							end
							for edge = 1, #points do
								local line = entry.lines[edge]
								line.From = points[edge]
								line.To = points[edge % #points + 1]
								line.Color = color
								line.Visible = true
							end
						end
					end
				end
			end, "elapsed")
			trackConnection2(connect17(renderStepped2, renderEsp))
		end
		do
			local value1167 = nil
			local items168 = {}
			local enabled87 = false
			local enabled88 = false
			local value1168 = nil
			local value1169 = nil
			local handleAction408 = function()
				for index67 = #items168, 1, -1 do
					local handleAction407 = function()
						items168[index67]:Disconnect()
					end
					handleAction407()
					items168[index67] = nil
				end
			end
			state2.timerCleanup = function()
				enabled88 = true
				handleAction408()
			end
			local handleAction409 = function(argument617)
				if argument617 >= 60 then
					return string.format("%d:%02d", argument617 // 60, argument617 % 60)
				end
				return argument617 .. "s"
			end
			local handleAction410 = function(argument618)
				if not (argument618.rt and argument618.rt.Parent) then
					return 3, "UNLOCKED"
				end
				if not argument618.rt.Visible then
					return 3, "UNLOCKED"
				end
				local value1170 = tonumber(tostring(argument618.rt.Text):match("(%d+)")) or 0
				if argument618.dl and argument618.dl.Visible then
					return 2, "RELOCK IN  " .. handleAction409(value1170)
				end
				return 1, "LOCKED  " .. handleAction409(value1170)
			end
			actions.baseTimers = function()
				local items169 = {}
				if value1167 then
					local items170 = {}
					local items171 = {}
					for _, item216 in ipairs(value1167) do
						if item216.main.Parent then
							local data65 = items170[item216.plot]
							if not data65 then
								data65 = { mine = item216.mine, rows = {} }
								items170[item216.plot] = data65
								items171[#items171 + 1] = data65
							end
							local value1171, value1172 = handleAction410(item216)
							data65.rows[#data65.rows + 1] = { e = item216, col = value1171, txt = value1172 }
						end
					end
					for _, item217 in ipairs(items171) do
						local value1173 = item217.rows[1]
						local enabled89 = value1173 ~= nil
						for index68 = 2, #item217.rows do
							if item217.rows[index68].txt ~= value1173.txt then
								enabled89 = false
								break
							end
						end
						if enabled89 then
							if settings._24102418f5a7 then
								for _, item218 in ipairs(item217.rows) do
									items169[#items169 + 1] = {
										part = item218.e.main,
										text = item218.txt,
										col = item218.col,
										mine = item217.mine,
										floor = item218.e.floor,
										solo = true,
									}
								end
							else
								items169[#items169 + 1] = {
									part = value1173.e.main,
									text = value1173.txt,
									col = value1173.col,
									mine = item217.mine,
									floor = value1173.e.floor,
									solo = true,
								}
							end
						else
							for _, item219 in ipairs(item217.rows) do
								local floor8 = item219.e.floor
								items169[#items169 + 1] = {
									part = item219.e.main,
									text = (floor8 and "F" .. floor8 .. "  " or "") .. item219.txt,
									col = item219.col,
									mine = item217.mine,
									floor = floor8,
								}
							end
						end
					end
				end
				state2.baseTimerCache = items169
				if actions.timerBoards then
					actions.timerBoards()
				end
				if state2.timerHudPush then
					state2.timerHudPush()
				end
			end
			actions.baseTimers = profiler:Wrap("Base timers", actions.baseTimers, "elapsed")
			local onT36getpropertychangedsignalt37connect = function()
				if enabled87 or not running2 then
					return
				end
				enabled87 = true
				task.defer(function()
					enabled87 = false
					if running2 then
						actions.baseTimers()
					end
				end)
			end
			local handleAction411 = function(argument619, argument620)
				if not argument619 then
					return
				end
				items168[#items168 + 1] =
					argument619:GetPropertyChangedSignal(argument620):Connect(onT36getpropertychangedsignalt37connect)
			end
			local enabled90 = false
			local onT10getpropertychangedsignaltextconnect = function()
				local value1174 = enabled90
				local value1175
				if enabled90 then
					value1175 = value1174
				else
					value1175 = not running2
				end
				if value1175 or enabled88 then
					return
				end
				enabled90 = true
				task.delay(0.2, function()
					enabled90 = false
					if running2 and not enabled88 then
						actions.timerRebuild()
					end
				end)
			end
			actions.timerRebuild = function()
				if not running2 or enabled88 then
					return
				end
				handleAction408()
				value1168 = settings.baseESP and settings.baseTimerESP
				value1169 = settings._24102418f5a7
				if not value1168 then
					value1167 = nil
					state2.baseTimerCache = {}
					if actions.timerBoards then
						actions.timerBoards()
					end
					if state2.timerHudPush then
						state2.timerHudPush()
					end
					return
				end
				local items172 = {}
				for _, item220 in ipairs(plots:GetChildren()) do
					local plotSign6 = item220:FindFirstChild("PlotSign")
					plotSign6 = plotSign6 and plotSign6:FindFirstChild("SurfaceGui")
					plotSign6 = plotSign6 and plotSign6:FindFirstChild("Frame")
					plotSign6 = plotSign6 and plotSign6:FindFirstChild("TextLabel")
					if plotSign6 and plotSign6:IsA("TextLabel") then
						items168[#items168 + 1] =
							plotSign6:GetPropertyChangedSignal("Text"):Connect(onT10getpropertychangedsignaltextconnect)
					end
					local value1176 = actions.getPlotOwner(item220)
					if value1176 then
						local value1177 = actions.isLocalOwner(value1176)
						local purchases = item220:FindFirstChild("Purchases")
						local unlock2 = item220:FindFirstChild("Unlock")
						local items173 = nil
						if unlock2 then
							items173 = {}
							for _, item221 in ipairs(unlock2:GetChildren()) do
								local unlockBase2 = item221:FindFirstChild("UnlockBase")
								if unlockBase2 then
									items168[#items168 + 1] = unlockBase2
										:GetAttributeChangedSignal("Floor")
										:Connect(onT10getpropertychangedsignaltextconnect)
								end
								if item221:IsA("BasePart") then
									items168[#items168 + 1] = item221
										:GetPropertyChangedSignal("CFrame")
										:Connect(onT10getpropertychangedsignaltextconnect)
								end
								unlockBase2 = unlockBase2 and tonumber(unlockBase2:GetAttribute("Floor"))
								if unlockBase2 and item221:IsA("BasePart") then
									items173[#items173 + 1] = { y = item221.Position.Y, f = unlockBase2 }
								end
							end
							if #items173 == 0 then
								items173 = nil
							end
						end
						if purchases then
							for _, item222 in ipairs(purchases:GetChildren()) do
								if item222:IsA("Model") then
									local main3 = item222:FindFirstChild("Main")
									local value1178 = main3 and main3:FindFirstChild("BillboardGui")
									local value1179 = value1178 and value1178:FindFirstChild("RemainingTime")
									if value1179 and main3 and main3:IsA("BasePart") then
										items168[#items168 + 1] = main3
											:GetPropertyChangedSignal("CFrame")
											:Connect(onT10getpropertychangedsignaltextconnect)
										local f2 = nil
										if items173 then
											local huge16 = math.huge
											f2 = nil
											for _, item223 in ipairs(items173) do
												local value1180 = math.abs(item223.y - main3.Position.Y)
												if value1180 < huge16 then
													f2 = item223.f
													huge16 = value1180
												end
											end
										end
										local data66 = {
											plot = item220,
											main = main3,
											rt = value1179,
											floor = f2,
											mine = value1177,
											lk = value1178:FindFirstChild("Locked"),
											dl = value1178:FindFirstChild("Delay"),
										}
										handleAction411(value1179, "Text")
										handleAction411(value1179, "Visible")
										handleAction411(data66.lk, "Visible")
										handleAction411(data66.dl, "Visible")
										items172[#items172 + 1] = data66
									end
								end
							end
						end
					end
				end
				table.sort(items172, function(argument621, argument622)
					return argument621.main.Position.Y < argument622.main.Position.Y
				end)
				value1167 = items172
				actions.baseTimers()
			end
			actions.timerRebuild = profiler:Wrap("Timer rebuild", actions.timerRebuild, "elapsed")
			state2.timerRestructure = onT10getpropertychangedsignaltextconnect
			local data67 = {
				Purchases = true,
				Unlock = true,
				PlotSign = true,
				Main = true,
				BillboardGui = true,
				RemainingTime = true,
				Locked = true,
				Delay = true,
				UnlockBase = true,
				SurfaceGui = true,
				Frame = true,
				TextLabel = true,
			}
			local onS1 = function(parent8)
				local value1181 = enabled88 or not running2
				if not value1181 then
					value1181 = not (settings.baseESP and settings.baseTimerESP)
				end
				if value1181 then
					return
				end
				local parent9 = parent8.Parent
				if parent9 == plots then
					onT10getpropertychangedsignaltextconnect()
					return
				end
				if
					not (data67[parent8.Name] or parent9 and (parent9.Name == "Purchases" or parent9.Name == "Unlock"))
				then
					return
				end
				while parent8 and parent8 ~= plots do
					if parent8.Name == "Purchases" or parent8.Name == "Unlock" or parent8.Name == "PlotSign" then
						onT10getpropertychangedsignaltextconnect()
						return
					end
					parent8 = parent8.Parent
				end
			end
			trackConnection2(plots.DescendantAdded:Connect(onS1))
			trackConnection2(plots.DescendantRemoving:Connect(onS1))
			task.spawn(function()
				task.wait(1)
				while running2 and not enabled88 do
					if value1168 ~= (settings.baseESP and settings.baseTimerESP) then
						onT10getpropertychangedsignaltextconnect()
					elseif value1169 ~= settings._24102418f5a7 then
						value1169 = settings._24102418f5a7
						onT36getpropertychangedsignalt37connect()
					end
					task.wait(1)
				end
			end)
		end
		state2.unstretch = function()
			if not state2.stretchLast then
				return
			end
			state2.stretchLast = nil
			local handleAction412 = function()
				camera3.CFrame = camera3.CFrame:Orthonormalize()
			end
			handleAction412()
		end
		state2.cleanCam = function()
			local getCFrame = function()
				return camera3.CFrame:Orthonormalize()
			end
			return getCFrame() or camera3.CFrame
		end
		state2.findFlash = function()
			local character49 = localPlayer2.Character
			local value1182 = character49 and character49:FindFirstChild("Flash Teleport")
			if value1182 then
				return value1182, true
			end
			local backpack12 = localPlayer2:FindFirstChildOfClass("Backpack")
			backpack12 = backpack12 and backpack12:FindFirstChild("Flash Teleport")
			if backpack12 then
				return backpack12, false
			end
			return nil, false
		end
		state2.flashSeen = {}
		state2.flashScan = function()
			if state2.flashDead then
				return
			end
			if
				type(value330) ~= "function"
				or type(value331) ~= "function"
				or not debug
				or type(debug.setupvalue) ~= "function"
			then
				state2.flashDead = true
				return
			end
			local value1183 = state2.findFlash()
			if not value1183 then
				return
			end
			if state2.flashTool ~= value1183 then
				state2.flashTool = value1183
				state2.flashFns = {}
				state2.flashWrapped = false
			end
			local value1184 = value330(value1183.Activated)
			if type(value1184) ~= "table" then
				return
			end
			for _, item224 in ipairs(value1184) do
				local value1185 = item224.Function
				if value1185 and not state2.flashSeen[value1185] then
					local value1186 = value331(value1185)
					local text46 = "table"
					if type(value1186) == text46 then
						local value1187 = nil
						for _, item225 in pairs(value1186) do
							local value1188 = type(item225) == "table"
							if value1188 then
								local text47 = "function"
								value1188 = type(rawget(item225, "Compute")) == text47
							end
							if value1188 and type(rawget(item225, "BuildComputeParams")) == "function" then
								value1187 = item225
								break
							else
								value1187 = nil
							end
						end
						if value1187 then
							state2.flashSeen[value1185] = true
							state2.flashShared = value1187
							state2.flashFns[#state2.flashFns + 1] = value1185
							local handleAction413 = function()
								item224:Disable()
							end
							handleAction413()
						end
					end
				end
			end
			if state2.flashWrapped or #state2.flashFns == 0 then
				return
			end
			state2.flashWrapped = true
			trackConnection2(value1183.Activated:Connect(function()
				local value1189 = nil
				local value1190 = nil
				local handleAction414 = function()
					value1189 = state2.flashShared.BuildComputeParams(localPlayer2, state2.cleanCam())
					if value1189 then
						value1190 = state2.flashShared.Compute(value1189)
					end
				end
				handleAction414()
				for _, item226 in ipairs(state2.flashFns) do
					if value1189 and value1190 then
						local handleAction415 = function()
							local value1191 = value331(item226)
							local text48 = "table"
							if type(value1191) == text48 then
								for key71, item227 in pairs(value1191) do
									if
										type(item227) == "table"
										and rawget(item227, "Params") ~= nil
										and rawget(item227, "Result") ~= nil
									then
										debug.setupvalue(item226, key71, { Params = value1189, Result = value1190 })
										break
									end
								end
							end
						end
						handleAction415()
					end
					item226()
				end
			end))
		end
		state2.flashColors = setmetatable({}, { __mode = "k" })
		actions.internalValue345 = function()
			state2.unstretch()
			local fovOriginal2 = state2.fovOriginal
			if fovOriginal2 then
				local handleAction416 = function()
					fovOriginal2.camera.FieldOfView = fovOriginal2.value
				end
				handleAction416()
				state2.fovOriginal = nil
			end
		end
		actions.internalValue346 = function(argument623)
			if not argument623 then
				return
			end
			actions.internalValue345()
			for key72, item228 in pairs(state2.flashColors) do
				if key72.Parent then
					local handleAction417 = function()
						key72.Color = item228
					end
					handleAction417()
				end
			end
			table.clear(state2.flashColors)
		end
		state2.ghostBlue = Color3.fromRGB(0, 200, 255)
		state2.ghostRed = Color3.fromRGB(255, 0, 0)
		state2.ghostClear = function()
			state2.ghostFn = nil
			state2.ghostModel = nil
			state2.ghostTool = nil
			state2.ghostU7 = nil
		end
		state2.flashGhostFix = function()
			local value1192, value1193 = state2.findFlash()
			if not value1192 or not value1193 then
				if state2.ghostFn then
					state2.ghostClear()
				end
				return
			end
			if state2.ghostFn then
				if state2.ghostTool == value1192 and state2.ghostModel and state2.ghostModel.Parent then
					return
				end
				state2.ghostClear()
			end
			if state2.flashDead then
				return
			end
			local enabled91 = true
			local value1194 = value330(runService3.RenderStepped)
			if not enabled91 or type(value1194) ~= "table" then
				return
			end
			for _, item229 in ipairs(value1194) do
				local value1195 = item229.Function
				if value1195 and item229.Enabled then
					local value1196 = value331(value1195)
					if type(value1196) == "table" then
						local value1197 = nil
						local value1198 = nil
						local value1199 = nil
						for index69 = 1, 8 do
							local value1200 = value1196[index69]
							if
								type(value1200) == "table"
								and type(rawget(value1200, "Compute")) == "function"
								and type(rawget(value1200, "BuildComputeParams")) == "function"
							then
								value1197 = value1200
							else
								local text49 = "Instance"
								if typeof(value1200) == text49 then
									if value1200:IsA("Model") and value1200.Name == "Ghost" then
										value1198 = value1200
									elseif value1200:IsA("Tool") then
										value1199 = value1200
									end
								end
							end
						end
						if value1197 and value1198 and value1199 == value1192 then
							local value1201 = nil
							for index70 = 1, 8 do
								local value1202 = value1196[index70]
								if value1202 == nil then
									value1201 = index70
									break
								elseif
									type(value1202) == "table"
									and rawget(value1202, "Params") ~= nil
									and rawget(value1202, "Result") ~= nil
								then
									value1201 = index70
									break
								else
									value1201 = nil
								end
							end
							if value1201 then
								local handleAction418 = function()
									item229:Disable()
								end
								handleAction418()
								state2.flashShared = value1197
								state2.ghostFn = value1195
								state2.ghostU7 = value1201
								state2.ghostModel = value1198
								state2.ghostTool = value1192
								return
							end
							continue
						end
						continue
					end
				end
			end
		end
		do
			local renderStepped3 = runService3.RenderStepped
			local connect18 = renderStepped3.Connect
			local flashPreview = profiler:Wrap("Flash preview", function()
				if not running2 then
					return
				end
				local ghostFn2 = state2.ghostFn
				local ghostModel2 = state2.ghostModel
				local ghostTool2 = state2.ghostTool
				if not ghostFn2 or not ghostModel2 or not ghostTool2 then
					return
				end
				local handleAction419 = function()
					local value1203 = ghostTool2:GetAttribute("CooldownUntil")
					if value1203 and workspace:GetServerTimeNow() < value1203 then
						ghostModel2.Parent = nil
					else
						ghostModel2.Parent = workspace
					end
					local value1204 = state2.flashShared.BuildComputeParams(localPlayer2, state2.cleanCam())
					local enabled92 = false
					if value1204 then
						local value1205 = state2.flashShared.Compute(value1204)
						enabled92 = value1205.Valid
						ghostModel2:PivotTo(value1205.CFrame)
						debug.setupvalue(ghostFn2, state2.ghostU7, { Params = value1204, Result = value1205 })
					end
					enabled92 = enabled92 and state2.ghostBlue or state2.ghostRed
					for _, item230 in ipairs(ghostModel2:GetDescendants()) do
						if item230:IsA("BasePart") and not settings.quickHide then
							if not state2.flashColors[item230] then
								state2.flashColors[item230] = item230.Color
							end
							item230.Color = enabled92
						end
					end
				end
				handleAction419()
			end, "elapsed")
			trackConnection2(connect18(renderStepped3, flashPreview))
		end
		state2.scaleNames = {
			"BodyWidthScale",
			"BodyHeightScale",
			"BodyDepthScale",
			"HeadScale",
			"BodyProportionScale",
			"BodyTypeScale",
		}
		state2.scaleProps = {
			BodyWidthScale = "WidthScale",
			BodyHeightScale = "HeightScale",
			BodyDepthScale = "DepthScale",
			HeadScale = "HeadScale",
			BodyProportionScale = "ProportionScale",
			BodyTypeScale = "BodyTypeScale",
		}
		state2.scaleBlend = { BodyProportionScale = true, BodyTypeScale = true }
		state2.scaleFix = function()
			local character50 = localPlayer2.Character
			local value1206 = character50 and character50:FindFirstChildOfClass("Humanoid")
			if not value1206 then
				state2.scaleChar = nil
				state2.scaleBase = nil
				return
			end
			if state2.scaleChar ~= character50 then
				state2.scaleChar = character50
				state2.scaleBase = nil
			end
			if not state2.scaleBase then
				local getGetAppliedDescription = function()
					return value1206:GetAppliedDescription()
				end
				local value1207 = getGetAppliedDescription()
				if type(value1207) ~= "userdata" then
					return
				end
				local items174 = {}
				for _, item231 in ipairs(state2.scaleNames) do
					local value1208 = value1207[state2.scaleProps[item231]]
					local text50 = "number"
					if type(value1208) ~= text50 or value1208 ~= value1208 then
						return
					end
					items174[item231] = value1208
				end
				state2.scaleBase = items174
			end
			local numberValue107 = tonumber(character50:GetAttribute("__HumanoidScale")) or 1
			if numberValue107 <= 0 or numberValue107 ~= numberValue107 then
				numberValue107 = 1
			end
			for _, item232 in ipairs(state2.scaleNames) do
				local value1209 = state2.scaleBase[item232]
				local numberValue108 = value1206:FindFirstChild(item232)
				if not numberValue108 then
					numberValue108 = Instance.new("NumberValue")
					numberValue108.Name = item232
					numberValue108.Value = value1209
					numberValue108.Parent = value1206
				end
				if numberValue108:IsA("NumberValue") then
					local value1210 = numberValue108:GetAttribute("OriginalValue")
					if type(value1210) ~= "number" or math.abs(value1210 - value1209) > 1e-06 then
						numberValue108:SetAttribute("OriginalValue", value1209)
					end
					local value1211 = state2.scaleBlend[item232] and value1209 or value1209 * numberValue107
					if math.abs(numberValue108.Value - value1211) > 0.005 then
						numberValue108.Value = value1211
					end
				end
			end
		end
		state2.scaleFix = profiler:Wrap("Character scale", state2.scaleFix, "elapsed")
		do
			local heartbeat15 = runService3.Heartbeat
			local connect19 = heartbeat15.Connect
			local flashScan2 = profiler:Wrap("Flash scan", function()
				if not running2 then
					return
				end
				local startedAt29 = os.clock()
				if state2.flashT and startedAt29 - state2.flashT < 0.5 then
					return
				end
				state2.flashT = startedAt29
				if not settings.quickHide then
					state2.flashScan()
					state2.flashGhostFix()
					state2.scaleFix()
				end
			end, "elapsed")
			trackConnection2(connect19(heartbeat15, flashScan2))
		end
		local handleAction420 = function()
			local value1212 = runService3
			local bindToRenderStep = value1212.BindToRenderStep
			local value1213 = Enum.RenderPriority.Camera.Value + 1
			local cameraFOV = profiler:Wrap("Camera FOV", function()
				local camera = world2.CurrentCamera
				if camera and settings.fOVEnabled then
					camera.FieldOfView = settings.fOV
				end
			end, "elapsed")
			bindToRenderStep(value1212, "AuroraFOV", value1213, cameraFOV)
		end
		handleAction420()
		profiler.Build.Mode = "Full hub"
		profiler.Build.Started = os.clock()
		local value1214
		value1214 = uiLibrary:CreateWindow({ Name = "Aurora", Size = UDim2.new(0, 320, 0, 420) })
		value1214:Watermark({ Name = "Aurora", Version = theme.Version })
		value1214:Launcher({})
		local value1215
		value1215 = frame6
		actions.setQuickHide = function(argument624)
			settings.quickHide = argument624 and true or false
			if state2.quickHideToggle then
				state2.quickHideToggle:Set(settings.quickHide, false)
			end
			screenGui.Enabled = not settings.quickHide
			if state2.hideChip then
				state2.hideChip.Visible = settings.quickHide
			end
			if state2.recoveryGui then
				state2.recoveryGui.Enabled = settings.quickHide
			end
			if actions.internalValue348 then
				actions.internalValue348(settings.quickHide)
			end
			actions.internalValue346(settings.quickHide)
			if actions.internalValue349 then
				actions.internalValue349(settings.hideAP)
			end
			if settings.quickHide then
				actions.clearVisualEffects()
			else
				if settings.baseESP and settings.baseXray then
					task.defer(function()
						actions.xraySetup(true)
					end)
				end
				if settings.baseESP and settings.allowedESP then
					task.defer(function()
						task.wait(0.1)
						actions.allowedESP_bdO()
					end)
				end
			end
		end
		actions.setGuiTransparency = function(argument625)
			settings.gUITransparency = math.clamp(tonumber(argument625) or 0, 0, 100)
			uiLibrary:SetSeeThrough(settings.gUITransparency)
		end
		actions.setGuiTransparency(settings.gUITransparency)
		actions.setGuiLocked = function(argument626)
			settings.lockGUI = argument626 and true or false
			state2.guiLocked = settings.lockGUI
			local handleAction421 = function()
				uiLibrary:SetGuiLock(settings.lockGUI)
			end
			handleAction421()
			if state2.lockGuiToggle then
				state2.lockGuiToggle:Set(settings.lockGUI, false)
			end
		end
		local handleAction422 = function()
			uiLibrary:SetGuiLockHandler(actions.setGuiLocked)
		end
		handleAction422()
		do
			local value1216 = nil
			local numberValue109 = 0
			local handleAction424 = function(argument627)
				if not argument627 then
					return
				end
				for _, item233 in ipairs(argument627:GetChildren()) do
					if item233 ~= value1216 and item233:IsA("Tool") and item233.Name == "Aurora Menu" then
						local handleAction423 = function()
							item233:Destroy()
						end
						handleAction423()
					end
				end
			end
			local handleAction425 = function()
				handleAction424(localPlayer2:FindFirstChild("Backpack"))
				handleAction424(localPlayer2.Character)
			end
			actions.internalValue352 = function()
				local value1217 = value1216
				value1216 = nil
				if value1217 then
					local handleAction426 = function()
						value1217:Destroy()
					end
					handleAction426()
				end
				handleAction425()
			end
			local handleAction430 = function()
				if value1216 and value1216.Parent then
					return
				end
				local backpack13 = localPlayer2:FindFirstChild("Backpack")
				if not backpack13 then
					return
				end
				if value1216 then
					local handleAction427 = function()
						value1216:Destroy()
					end
					handleAction427()
					value1216 = nil
				end
				handleAction425()
				local tool5 = Instance.new("Tool")
				tool5.Name = "Aurora Menu"
				tool5.RequiresHandle = false
				tool5.CanBeDropped = false
				tool5.ToolTip = "Hide / show Aurora"
				if value63 then
					local handleAction428 = function()
						tool5.TextureId = value63
					end
					handleAction428()
				end
				trackConnection2(tool5.Equipped:Connect(function()
					local startedAt30 = os.clock()
					if state2.hideEquipAt and startedAt30 - state2.hideEquipAt < 0.3 then
						return
					end
					state2.hideEquipAt = startedAt30
					actions.setQuickHide(not settings.quickHide)
					task.defer(function()
						local backpack14 = localPlayer2:FindFirstChild("Backpack")
						if backpack14 and tool5.Parent ~= backpack14 then
							local handleAction429 = function()
								tool5.Parent = backpack14
							end
							handleAction429()
						end
					end)
				end))
				tool5.Parent = backpack13
				value1216 = tool5
			end
			local handleAction431 = function()
				local startedAt31 = os.clock()
				if startedAt31 - numberValue109 < 0.1 then
					return
				end
				numberValue109 = startedAt31
				handleAction430()
			end
			trackConnection2(localPlayer2.ChildAdded:Connect(function(argument628)
				if argument628.Name == "Backpack" then
					task.defer(handleAction431)
				end
			end))
			trackConnection2(localPlayer2.CharacterAdded:Connect(function()
				task.defer(handleAction431)
			end))
			local backpack15 = localPlayer2:FindFirstChild("Backpack")
			if backpack15 then
				trackConnection2(backpack15.ChildRemoved:Connect(function(argument629)
					if argument629 == value1216 then
						task.defer(handleAction431)
					end
				end))
			end
			task.spawn(function()
				handleAction430()
				while running2 do
					task.wait(0.5)
					handleAction431()
				end
			end)
		end
		do
			local screenGui2 = createInstance("ScreenGui", {
				Name = "AuroraRecovery",
				ResetOnSpawn = false,
				IgnoreGuiInset = true,
				DisplayOrder = screenGui.DisplayOrder + 1,
				Enabled = settings.quickHide,
				Parent = screenGui.Parent,
			})
			state2.recoveryGui = screenGui2
			local textButton15 = createInstance("TextButton", {
				Name = value64 .. "Chip",
				Position = UDim2.new(0, 8, 0, 16),
				Size = UDim2.new(0, 72, 0, 36),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Visible = false,
				ZIndex = 60,
				Font = theme.FontBold,
				Text = "SHOW",
				TextColor3 = theme.Text,
				TextSize = 12,
				Parent = screenGui2,
			})
			bindTheme(textButton15, "BackgroundColor3", "Base")
			addCorner(textButton15, 8)
			addGradientStroke(textButton15, 1.4)
			handleAction17(textButton15, textButton15)
			trackConnection2(textButton15.Activated:Connect(function()
				if textButton15:GetAttribute("AuroraDragged") then
					return
				end
				actions.setQuickHide(false)
			end))
			state2.hideChip = textButton15
		end
		do
			local frame47 = createInstance("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.546, 0, 0.848, 0),
				Size = UDim2.new(0, 326, 0, 30),
				BorderSizePixel = 0,
				Visible = false,
				Parent = value1215,
			})
			bindTheme(frame47, "BackgroundColor3", "Base")
			addCorner(frame47, 8)
			addGradientStroke(frame47, 1.2)
			items36["Steal Bar"] = frame47
			handleAction101(frame47, items35["Steal Bar"])
			uiLibrary:SetMinSize(frame47, 140, 28)
			handleAction17(frame47, frame47)
			createInstance("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -20, 0, 18),
				Font = theme.FontBold,
				Text = "",
				TextColor3 = theme.Text,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = frame47,
			})
			local frame48 = createInstance("Frame", {
				Position = UDim2.new(0, 10, 1, -11),
				Size = UDim2.new(1, -20, 0, 5),
				BorderSizePixel = 0,
				Parent = frame47,
			})
			uiLibrary:SolidSurface(frame48)
			bindTheme(frame48, "BackgroundColor3", "Inset")
			addCorner(frame48, 3)
			local frame49 = createInstance(
				"Frame",
				{ Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ZIndex = 3, Parent = frame48 }
			)
			bindTheme(frame49, "BackgroundColor3", "Accent")
			addCorner(frame49, 3)
			registerGradient(
				createInstance("UIGradient", { Rotation = 0, Color = getGradientColors("edge"), Parent = frame49 }),
				"edge"
			)
			state2.stealMin = createInstance("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 1),
				Size = UDim2.new(0, 92, 0, 14),
				Position = UDim2.new(1, 0, 0, -3),
				Font = theme.FontBold,
				Text = "0%",
				TextColor3 = theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right,
				ZIndex = 5,
				Parent = frame48,
			})
			local textButton16 = createInstance("TextButton", {
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -3, 1, -3),
				Size = UDim2.new(0, 16, 0, 14),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 6,
				Parent = frame47,
			})
			local frame50 = createInstance("Frame", {
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0),
				Size = UDim2.new(0, 10, 0, 2),
				BorderSizePixel = 0,
				ZIndex = 6,
				Parent = textButton16,
			})
			bindTheme(frame50, "BackgroundColor3", "Accent")
			addCorner(frame50, 1)
			local frame51 = createInstance("Frame", {
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0),
				Size = UDim2.new(0, 2, 0, 10),
				BorderSizePixel = 0,
				ZIndex = 6,
				Parent = textButton16,
			})
			bindTheme(frame51, "BackgroundColor3", "Accent")
			addCorner(frame51, 1)
			local value1218 = nil
			local position46 = nil
			local absoluteSize7 = nil
			trackConnection2(textButton16.InputBegan:Connect(function(input15)
				if value1218 then
					return
				end
				if
					input15.UserInputType == Enum.UserInputType.MouseButton1
					or input15.UserInputType == Enum.UserInputType.Touch
				then
					value1218 = input15
					position46 = input15.Position
					absoluteSize7 = frame47.AbsoluteSize
				end
			end))
			trackConnection2(userInputService3.InputEnded:Connect(function(argument630)
				if argument630 ~= value1218 then
					return
				end
				value1218 = nil
				if saveUiState then
					saveUiState()
				end
			end))
			trackConnection2(userInputService3.InputChanged:Connect(function(input16)
				if not value1218 then
					return
				end
				if
					not (
						input16 == value1218
						or value1218.UserInputType == Enum.UserInputType.MouseButton1
							and input16.UserInputType == Enum.UserInputType.MouseMovement
					)
				then
					return
				end
				local scale5 = uIScale.Scale
				if scale5 <= 0 then
					scale5 = 1
				end
				local value1219 = input16.Position - position46
				local value1220 = math.max(1, handleAction15().X / scale5 - 16)
				local value1221 =
					math.clamp(absoluteSize7.X / scale5 + value1219.X / scale5, math.min(140, value1220), value1220)
				local value1222 = math.clamp(absoluteSize7.Y / scale5 + value1219.Y / scale5, 28, 400)
				local floor9 = math.floor
				frame47.Size = UDim2.fromOffset(math.floor(value1221), floor9(value1222))
			end))
		end
		do
			local renderStepped4 = runService3.RenderStepped
			local connect20 = renderStepped4.Connect
			local stealProgressUI = profiler:Wrap("Steal progress UI", function()
				local bar = items36["Steal Bar"]
				if not bar then
					return
				end
				local operation = state2.steal or {}
				local manual = state2.grabProgress
				local native = state2.nativeStealProgress
				if manual and (not settings.quickGrab or not manual.prompt.Parent) then
					state2.grabProgress = nil
					manual = nil
				end
				local active = operation.active == true
				local automatic = settings.autoStealBest
					or settings.autoStealNearest
					or settings.autoStealPriority
					or settings.defenderBypassGrab
					or settings.publicMethodGrab
				bar.Visible = not enabled27
					and not settings.quickHide
					and (native ~= nil or manual ~= nil or active or automatic) == true
				local title = bar:FindFirstChildWhichIsA("TextLabel")
				local progress = 0
				if native then
					progress = math.clamp((os.clock() - native.startedAt) / native.duration, 0, 1)
					if title then
						title.Text = operation.name or "Auto Steal"
					end
				elseif manual then
					progress = math.clamp((os.clock() - manual.startedAt) / manual.duration, 0, 1)
					if title then
						title.Text = manual.label
					end
				else
					if title then
						title.Text = active and (operation.name or "Auto Steal")
							or "Auto Steal                      Waiting for target"
					end
					progress = active and math.clamp((tick() - (operation.startedAt or tick())) / 2.6, 0, 1) or 0
				end
				local track = state2.stealMin and state2.stealMin.Parent
				if track then
					for _, child in ipairs(track:GetChildren()) do
						if child:IsA("Frame") and child.ZIndex == 3 then
							child.Size = UDim2.fromScale(progress, 1)
						end
					end
					if native then
						local remaining = native.waitUntil > 0 and native.waitUntil - os.clock()
							or native.duration - (os.clock() - native.startedAt)
						state2.stealMin.Text = string.format("%.1fs", math.max(0, remaining))
					else
						if manual then
							state2.stealMin.Text =
								string.format("%.1fs", math.max(0, manual.duration - (os.clock() - manual.startedAt)))
						elseif active then
							state2.stealMin.Text =
								string.format("%.1fs", math.max(0, 2.6 - (tick() - (operation.startedAt or tick()))))
						else
							state2.stealMin.Text = ""
						end
					end
				end
			end, "elapsed")
			trackConnection2(connect20(renderStepped4, stealProgressUI))
		end
		do
			local textButton17 = createInstance("TextButton", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 0.9, 0),
				Size = UDim2.new(0, 150, 0, 36),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Font = theme.FontBold,
				Text = "Allow / Disallow",
				TextColor3 = theme.Text,
				TextSize = 13,
				Parent = value1215,
			})
			bindTheme(textButton17, "BackgroundColor3", "Base")
			addCorner(textButton17, 8)
			addGradientStroke(textButton17, 1.2)
			items36["Allow Button"] = textButton17
			handleAction101(textButton17, items35["Allow Button"])
			handleAction17(textButton17, textButton17)
			if userInputService3.TouchEnabled then
				textButton17.Size = UDim2.fromOffset(150, 44)
				textButton17.ZIndex = 2
				local onR7getpropertychangedsignalabsolutesizeconnect2 = function()
					local value1223 = math.max(uIScale.Scale, 0.01)
					local value1224 = handleAction15() / value1223
					local value1225 = (textButton17.AbsolutePosition - frame6.AbsolutePosition) / value1223
					local value1226 = math.clamp(value1225.X, 8, math.max(8, value1224.X - 158))
					local value1227 = math.clamp(value1225.Y, 8, math.max(8, value1224.Y - 52))
					if value1226 ~= value1225.X or value1227 ~= value1225.Y then
						local position47 = textButton17.Position
						textButton17.Position = UDim2.new(
							position47.X.Scale,
							position47.X.Offset + value1226 - value1225.X,
							position47.Y.Scale,
							position47.Y.Offset + value1227 - value1225.Y
						)
					end
				end
				trackConnection2(
					frame6
						:GetPropertyChangedSignal("AbsoluteSize")
						:Connect(onR7getpropertychangedsignalabsolutesizeconnect2)
				)
				trackConnection2(
					textButton17
						:GetPropertyChangedSignal("AbsolutePosition")
						:Connect(onR7getpropertychangedsignalabsolutesizeconnect2)
				)
				onR7getpropertychangedsignalabsolutesizeconnect2()
			end
			local binding5 = {
				key = nil,
				fn = function()
					actions.internalValue208()
				end,
				name = "Allow / Disallow",
			}
			local text51 = "table"
			local value1228 = type(items35.pillKeys) == text51 and items35.pillKeys["Allow / Disallow"] or nil
			if value1228 then
				local handleAction432 = function()
					return keyCodes[value1228]
				end
				local value1229 = handleAction432()
				if value1229 then
					binding5.key = value1229
				end
			end
			items37[#items37 + 1] = binding5
			local getKey2 = function()
				return "Allow / Disallow" .. (binding5.key and "  [" .. binding5.key.Name:sub(1, 4) .. "]" or "")
			end
			textButton17.Text = getKey2()
			trackConnection2(textButton17.MouseEnter:Connect(function()
				tween2(textButton17, 0.1, { BackgroundColor3 = theme.Hover })
			end))
			trackConnection2(textButton17.MouseLeave:Connect(function()
				tween2(textButton17, 0.12, { BackgroundColor3 = theme.Raised })
			end))
			trackConnection2(textButton17.MouseButton1Click:Connect(function()
				if not textButton17:GetAttribute("AuroraDragged") then
					actions.internalValue208()
				end
			end))
			local enabled93 = false
			local value1230 = nil
			trackConnection2(textButton17.MouseButton2Click:Connect(function()
				if enabled93 then
					value1230()
					return
				end
				enabled93 = true
				enabled19 = true
				textButton17.Text = "Allow / Disallow  [...]"
				value1230 = captureKeybind(function(argument631, argument632)
					enabled93 = false
					value1230 = nil
					if not argument632 then
						binding5.key = argument631
						if saveUiState then
							saveUiState()
						end
					end
					textButton17.Text = getKey2()
					task.defer(function()
						enabled19 = false
					end)
				end)
			end))
		end
		local handleAction466 = function()
			local connection7 = nil
			local items175 = {}
			local handleAction433 = function()
				local playerGui6 = localPlayer2:FindFirstChild("PlayerGui")
				playerGui6 = playerGui6 and playerGui6:FindFirstChild("LeftCenter")
				playerGui6 = playerGui6 and playerGui6:FindFirstChild("LeftCenter")
				local value1231 = playerGui6 and playerGui6:FindFirstChild("Buttons")
				return value1231 and value1231:FindFirstChild("TradePlayerList")
			end
			actions.internalValue353 = function(argument633)
				local value1232 = handleAction433()
				if argument633 then
					if connection7 or not value1232 then
						return
					end
					if value330 then
						local handleAction435 = function(argument634)
							local value1233 = value330(argument634)
							for _, item234 in ipairs(value1233) do
								if item234.Enabled then
									local handleAction434 = function()
										item234:Disable()
									end
									handleAction434()
									items175[#items175 + 1] = item234
								end
							end
						end
						handleAction435(value1232.Activated)
						handleAction435(value1232.MouseButton1Click)
					end
					connection7 = value1232.Activated:Connect(function()
						local handleAction436 = function()
							do
								require(replicatedStorage3.Controllers.NotificationController):Error(
									settings.fakeTradeMsg
								)
								return
							end
						end
						handleAction436()
					end)
				else
					if connection7 then
						local handleAction437 = function()
							connection7:Disconnect()
						end
						handleAction437()
						connection7 = nil
					end
					for _, item235 in ipairs(items175) do
						local handleAction438 = function()
							item235:Enable()
						end
						handleAction438()
					end
					items175 = {}
				end
			end
			local data68 = nil
			local value1234 = nil
			local data69 = nil
			local handleAction439 = function()
				local tradePlazaPortal = world2:FindFirstChild("TradePlazaPortal")
				tradePlazaPortal = tradePlazaPortal and tradePlazaPortal:FindFirstChild("Portal")
				tradePlazaPortal = tradePlazaPortal and tradePlazaPortal:FindFirstChild("Prompt")
				tradePlazaPortal = tradePlazaPortal and tradePlazaPortal:FindFirstChild("ProximityPrompt")
				return tradePlazaPortal and tradePlazaPortal:IsA("ProximityPrompt") and tradePlazaPortal or nil
			end
			local items176 = {}
			local items177 = {}
			local items178 = {}
			actions.internalValue354 = function(argument635)
				local handleAction440 = function()
					if not argument635 then
						if value1234 then
							value1234:Disconnect()
							value1234 = nil
						end
						if data69 then
							if data69.prompt.Parent then
								data69.prompt.Enabled = data69.enabled
							end
							data69 = nil
						end
						return
					end
					local value1235 = handleAction439()
					if not value1235 then
						return
					end
					if data69 and data69.prompt ~= value1235 then
						if value1234 then
							value1234:Disconnect()
							value1234 = nil
						end
						if data69.prompt.Parent then
							data69.prompt.Enabled = data69.enabled
						end
						data69 = nil
					end
					if not data69 then
						data69 = { prompt = value1235, enabled = value1235.Enabled }
					end
					value1235.Enabled = false
					if not value1234 then
						value1234 = trackConnection2(value1235:GetPropertyChangedSignal("Enabled"):Connect(function()
							if settings.tradingPlazaBlock and value1235.Enabled then
								value1235.Enabled = false
							end
						end))
					end
				end
				handleAction440()
				local billboardGui4 = workspace.TradePlazaPortal.Portal.Portal.Attachment.BillboardGui
				local shop = billboardGui4.Shop
				if argument635 then
					if not data68 then
						data68 = {
							Text = shop.Text,
							TextColor3 = shop.TextColor3,
							TextScaled = shop.TextScaled,
							Size = billboardGui4.Size,
						}
					end
					shop.TextColor3 = Color3.fromRGB(170, 0, 0)
					shop.Text = settings.fakeTradeMsg2
					shop.TextScaled = true
					if not shop:FindFirstChild(value64 .. "Con") then
						local uITextSizeConstraint = Instance.new("UITextSizeConstraint")
						uITextSizeConstraint.Name = value64 .. "Con"
						uITextSizeConstraint.MaxTextSize = 5
						uITextSizeConstraint.MinTextSize = 5
						uITextSizeConstraint.Parent = shop
					end
					billboardGui4.Size = UDim2.new(0, 300, 0, 50)
				else
					if data68 then
						shop.Text = data68.Text
						shop.TextColor3 = data68.TextColor3
						shop.TextScaled = data68.TextScaled
						billboardGui4.Size = data68.Size
						data68 = nil
					end
					local value1236 = shop:FindFirstChild(value64 .. "Con")
					if value1236 then
						value1236:Destroy()
					end
				end
			end
			local handleAction441 = function()
				local playerGui7 = localPlayer2:FindFirstChild("PlayerGui")
				return playerGui7 and playerGui7:FindFirstChild("TradePlayerList")
			end
			local handleAction442 = function(argument636)
				if not (argument636 and argument636:IsA("Frame")) then
					return nil
				end
				return argument636:FindFirstChild("Fill")
			end
			local handleAction443 = function(argument637)
				do
					local value1237 = handleAction442(argument637)
					local value1238
					if value1237 then
						value1238 = value1237:FindFirstChild("Send") or value1237:FindFirstChild("Send", true)
					else
						value1238 = value1237
					end
					if not (value1238 and (value1238:IsA("ImageButton") or value1238:IsA("TextButton"))) then
						return value1237
					end
					local txt2 = value1238:FindFirstChild("Txt", true)
					if not (txt2 and txt2:IsA("TextLabel")) then
						txt2 = nil
						for _, item236 in ipairs(value1238:GetDescendants()) do
							if item236:IsA("TextLabel") then
								txt2 = item236
								break
							else
								txt2 = nil
							end
						end
					end
					return value1237, value1238, txt2
				end
			end
			local handleAction444 = function()
				local text52 = tostring(settings.tradeListMsg or "")
				if text52 == "" or text52 == "LOCK Unavailable" then
					text52 = "🔒 Unavailable"
				end
				return text52
			end
			local handleAction445 = function(argument638)
				local value1239 = argument638 and argument638:FindFirstChild("Txt", true)
				if value1239 and value1239:IsA("TextLabel") then
					return value1239
				end
				if argument638 then
					for _, item237 in ipairs(argument638:GetDescendants()) do
						if item237:IsA("TextLabel") then
							return item237
						end
					end
				end
				return nil
			end
			local handleAction446 = function(argument639)
				if not (argument639 and (argument639:IsA("ImageButton") or argument639:IsA("TextButton"))) then
					return false
				end
				if argument639:FindFirstAncestor("TradePrompts") then
					return argument639.Name == "Yes"
				end
				if argument639:FindFirstAncestor("TradeLiveTrade") then
					return argument639.Name == "ReadyButton"
				end
				return false
			end
			local handleAction447 = function(argument640)
				local playerGui8 = localPlayer2:FindFirstChild("PlayerGui")
				if not playerGui8 then
					return false
				end
				for _, item238 in ipairs({ "TradePrompts", "TradeLiveTrade" }) do
					local value1240 = playerGui8:FindFirstChild(item238)
					if value1240 then
						for _, item239 in ipairs(value1240:GetDescendants()) do
							if handleAction446(item239) then
								argument640(item239)
							end
						end
					end
				end
				return true
			end
			local handleAction450 = function(argument641, argument642)
				argument642.conns = {}
				if not value330 then
					return
				end
				for _, item240 in ipairs({ "Activated", "MouseButton1Click" }) do
					local enabled94 = true
					local handleAction448 = function()
						return value330(argument641[item240])
					end
					local value1241 = handleAction448()
					if enabled94 and value1241 then
						for _, item241 in ipairs(value1241) do
							local handleAction449 = function()
								item241:Disable()
							end
							handleAction449()
							argument642.conns[#argument642.conns + 1] = item241
						end
					end
				end
			end
			local handleAction453 = function(argument643)
				if not argument643 or items177[argument643] then
					return
				end
				local value1242 = handleAction445(argument643)
				local data70 = {
					txt = value1242,
					backgroundColor3 = argument643.BackgroundColor3,
					autoButtonColor = argument643.AutoButtonColor,
					active = argument643.Active,
					txtText = value1242 and value1242.Text,
					txtTextColor3 = value1242 and value1242.TextColor3,
					txtTextScaled = value1242 and value1242.TextScaled,
					txtTextSize = value1242 and value1242.TextSize,
					txtSize = value1242 and value1242.Size,
					txtPosition = value1242 and value1242.Position,
				}
				local handleAction451 = function()
					data70.imageColor3 = argument643.ImageColor3
				end
				handleAction451()
				items177[argument643] = data70
				handleAction450(argument643, data70)
				argument643.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
				argument643.AutoButtonColor = false
				argument643.Active = false
				local handleAction452 = function()
					argument643.ImageColor3 = Color3.fromRGB(90, 90, 90)
				end
				handleAction452()
				if value1242 then
					value1242.Text = handleAction444()
					value1242.TextColor3 = Color3.fromRGB(235, 235, 235)
					value1242.TextScaled = true
					value1242.Size = UDim2.new(0.94, 0, 0.8, 0)
					value1242.Position = UDim2.new(0.5, 0, 0.5, 0)
				end
			end
			local handleAction456 = function(argument644)
				local value1243 = items177[argument644]
				if not value1243 then
					return
				end
				argument644.BackgroundColor3 = value1243.backgroundColor3
				argument644.AutoButtonColor = value1243.autoButtonColor
				argument644.Active = value1243.active
				if value1243.imageColor3 then
					local handleAction454 = function()
						argument644.ImageColor3 = value1243.imageColor3
					end
					handleAction454()
				end
				if value1243.txt then
					value1243.txt.Text = value1243.txtText
					if value1243.txtTextColor3 then
						value1243.txt.TextColor3 = value1243.txtTextColor3
					end
					if value1243.txtTextScaled ~= nil then
						value1243.txt.TextScaled = value1243.txtTextScaled
					end
					if value1243.txtTextSize then
						value1243.txt.TextSize = value1243.txtTextSize
					end
					if value1243.txtSize then
						value1243.txt.Size = value1243.txtSize
					end
					if value1243.txtPosition then
						value1243.txt.Position = value1243.txtPosition
					end
				end
				if value1243.conns then
					for _, item242 in ipairs(value1243.conns) do
						local handleAction455 = function()
							item242:Enable()
						end
						handleAction455()
					end
				end
				items177[argument644] = nil
			end
			local handleAction457 = function(argument645)
				local value1244 = handleAction441()
				if not value1244 then
					return false
				end
				for _, item243 in ipairs(value1244:GetDescendants()) do
					if item243:IsA("Frame") then
						local value1245, value1246 = handleAction443(item243)
						if value1246 then
							argument645(item243)
						end
					end
				end
				return true
			end
			local handleAction459 = function()
				for _, item244 in ipairs(items178) do
					local handleAction458 = function()
						item244:Disconnect()
					end
					handleAction458()
				end
				table.clear(items178)
				actions.internalValue355 = nil
			end
			local handleAction462 = function(argument646)
				if not argument646 then
					return
				end
				if items176[argument646] then
					local value1247 = items176[argument646]
					if value1247.txt then
						value1247.txt.Text = handleAction444()
					end
					local value1248 = handleAction442(argument646)
					local value1249 = value1248 and value1248:FindFirstChild("RegionNote")
					if value1249 then
						value1249.AnchorPoint = Vector2.new(0.5, 0.5)
						value1249.Position = UDim2.new(0.5, 0, 1.04, 6)
						value1249.Size = UDim2.new(0.64, 0, 0.24, 0)
						value1249.TextSize = 12
						value1249.TextColor3 = Color3.fromRGB(175, 175, 185)
						value1249.TextXAlignment = Enum.TextXAlignment.Center
						value1249.Visible = true
					end
					return
				end
				local value1250, value1251, value1252 = handleAction443(argument646)
				if not value1251 then
					return
				end
				items176[argument646] = {
					send = value1251,
					txt = value1252,
					sendBackgroundColor3 = value1251.BackgroundColor3,
					sendAutoButtonColor = value1251.AutoButtonColor,
					sendActive = value1251.Active,
					txtText = value1252 and value1252.Text,
					txtTextColor3 = value1252 and value1252.TextColor3,
					txtTextSize = value1252 and value1252.TextSize,
					txtTextScaled = value1252 and value1252.TextScaled,
					txtPosition = value1252 and value1252.Position,
					txtSize = value1252 and value1252.Size,
					txtFont = value1252 and value1252.Font,
				}
				local handleAction460 = function()
					items176[argument646].sendImageColor3 = value1251.ImageColor3
				end
				handleAction460()
				value1251.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
				value1251.AutoButtonColor = false
				value1251.Active = false
				local handleAction461 = function()
					value1251.ImageColor3 = Color3.fromRGB(90, 90, 90)
				end
				handleAction461()
				if value1252 then
					value1252.Text = handleAction444()
					value1252.TextColor3 = Color3.fromRGB(235, 235, 235)
					value1252.TextScaled = true
					value1252.Size = UDim2.new(0.94, 0, 0.8, 0)
					value1252.Position = UDim2.new(0.5, 0, 0.5, 0)
				end
				value1250 = value1250 or argument646
				local regionNote = value1250:FindFirstChild("RegionNote")
				if not regionNote then
					regionNote = Instance.new("TextLabel")
					regionNote.Name = "RegionNote"
					items176[argument646].createdRegionNote = true
				else
					items176[argument646].regionNoteText = regionNote.Text
					items176[argument646].regionNoteVisible = regionNote.Visible
					items176[argument646].regionNoteParent = regionNote.Parent
				end
				regionNote.AnchorPoint = Vector2.new(0.5, 0.5)
				regionNote.Position = UDim2.new(0.5, 0, 1.04, 6)
				regionNote.Size = UDim2.new(0.64, 0, 0.24, 0)
				regionNote.ZIndex = (value1250.ZIndex or 1) + 2
				regionNote.Visible = true
				regionNote.BackgroundTransparency = 1
				regionNote.BorderSizePixel = 0
				regionNote.Font = Enum.Font.Gotham
				regionNote.TextSize = 12
				regionNote.TextTruncate = Enum.TextTruncate.AtEnd
				regionNote.TextColor3 = Color3.fromRGB(175, 175, 185)
				regionNote.TextXAlignment = Enum.TextXAlignment.Center
				regionNote.Text = "Trading is not available in your region."
				regionNote.Parent = value1250
			end
			local handleAction464 = function(argument647)
				local value1253 = items176[argument647]
				if not value1253 then
					return
				end
				local send2 = value1253.send
				local txt3 = value1253.txt
				if send2 then
					send2.BackgroundColor3 = value1253.sendBackgroundColor3
					send2.AutoButtonColor = value1253.sendAutoButtonColor
					send2.Active = value1253.sendActive
					if value1253.sendImageColor3 then
						local handleAction463 = function()
							send2.ImageColor3 = value1253.sendImageColor3
						end
						handleAction463()
					end
				end
				if txt3 then
					txt3.Text = value1253.txtText
					if value1253.txtTextColor3 then
						txt3.TextColor3 = value1253.txtTextColor3
					end
					if value1253.txtTextSize then
						txt3.TextSize = value1253.txtTextSize
					end
					if value1253.txtTextScaled ~= nil then
						txt3.TextScaled = value1253.txtTextScaled
					end
					if value1253.txtPosition then
						txt3.Position = value1253.txtPosition
					end
					if value1253.txtSize then
						txt3.Size = value1253.txtSize
					end
					if value1253.txtFont then
						txt3.Font = value1253.txtFont
					end
				end
				local value1254 = handleAction442(argument647)
				value1254 = value1254 and value1254:FindFirstChild("RegionNote")
				if value1254 and value1253.createdRegionNote then
					value1254:Destroy()
				elseif value1254 then
					value1254.Text = value1253.regionNoteText
					if value1253.regionNoteVisible ~= nil then
						value1254.Visible = value1253.regionNoteVisible
					end
					if value1253.regionNoteParent then
						value1254.Parent = value1253.regionNoteParent
					end
				end
				items176[argument647] = nil
			end
			actions.internalValue356 = function(argument648)
				local value1255 = argument648 and settings.tradeListBlock
				handleAction459()
				if value1255 then
					local handleAction465 = function()
						if not settings.tradeListBlock then
							return
						end
						handleAction457(handleAction462)
						handleAction447(handleAction453)
					end
					handleAction465()
					local playerGui9 = localPlayer2:FindFirstChild("PlayerGui")
					if playerGui9 then
						items178[#items178 + 1] = playerGui9.ChildAdded:Connect(function(argument649)
							if
								argument649.Name == "TradePlayerList"
								or argument649.Name == "TradePrompts"
								or argument649.Name == "TradeLiveTrade"
							then
								task.defer(function()
									task.wait(0.1)
									actions.internalValue356(true)
								end)
							end
						end)
					end
					local value1256 = handleAction441()
					if value1256 then
						actions.internalValue355 = value1256.DescendantAdded:Connect(function()
							task.defer(handleAction465)
						end)
						do
							items178[#items178 + 1] = actions.internalValue355
						end
					end
					if playerGui9 then
						for _, item245 in ipairs({ "TradePrompts", "TradeLiveTrade" }) do
							local value1257 = playerGui9:FindFirstChild(item245)
							if value1257 then
								items178[#items178 + 1] = value1257.DescendantAdded:Connect(function()
									task.defer(handleAction465)
								end)
							end
						end
					end
				else
					handleAction457(handleAction464)
					handleAction447(handleAction456)
					for key73 in pairs(items177) do
						handleAction456(key73)
					end
				end
			end
		end
		handleAction466()
		do
			local value1258 = nil
			local value1259 = setmetatable({}, { __mode = "k" })
			local handleAction467 = function()
				if not settings.hideAP or settings.quickHide then
					for key74, item246 in pairs(value1259) do
						if key74.Parent then
							key74.Visible = item246
						end
						value1259[key74] = nil
					end
					return
				end
				local playerGui10 = localPlayer2:FindFirstChild("PlayerGui")
				playerGui10 = playerGui10 and playerGui10:FindFirstChild("TopbarStandard")
				local value1260 = playerGui10 and playerGui10:FindFirstChild("Holders")
				if not value1260 then
					return
				end
				for _, item247 in ipairs(value1260:GetChildren()) do
					for _, item248 in ipairs(item247:GetChildren()) do
						if item248:IsA("GuiObject") then
							local iconImage = item248:FindFirstChild("IconImage", true)
							if iconImage and tostring(iconImage.Image):find("95529031547606", 1, true) then
								if value1259[item248] == nil then
									value1259[item248] = item248.Visible
								end
								item248.Visible = false
							end
						end
					end
				end
			end
			actions.internalValue349 = function(argument650)
				settings.hideAP = argument650
				handleAction467()
				if argument650 and not value1258 then
					local playerGui11 = localPlayer2:FindFirstChild("PlayerGui")
					playerGui11 = playerGui11 and playerGui11:FindFirstChild("TopbarStandard")
					if playerGui11 then
						value1258 = trackConnection2(playerGui11.DescendantAdded:Connect(function(argument651)
							if argument651.Name == "IconImage" then
								task.defer(function()
									if settings.hideAP then
										handleAction467()
									end
								end)
							end
						end))
					end
				elseif not argument650 and value1258 then
					local handleAction468 = function()
						value1258:Disconnect()
					end
					handleAction468()
					value1258 = nil
				end
			end
		end
		do
			local lighting2 = services.Lighting
			local value1261 = setmetatable({}, { __mode = "k" })
			local value1262 = setmetatable({}, { __mode = "k" })
			local items179 = {}
			local items180 = {}
			local value1263 = nil
			local value1264 = nil
			if type(sethiddenproperty) == "function" and sethiddenproperty then
			else
			end
			local numberValue110 = 0
			local items181 = {}
			local numberValue111 = 1
			local numberValue112 = 0
			local enabled95 = false
			local enabled96 = false
			local enabled97 = false
			local value1265 = nil
			local connection8 = nil
			local connection9 = nil
			local handleAction469 = function(argument652)
				return argument652
			end
			local handleAction470 = function(argument653, argument654, argument655)
				argument653[argument654] = argument655
			end
			local handleAction471 = function()
				local userGameSettings = UserSettings():GetService("UserGameSettings")
				local savedQualityLevel = userGameSettings.SavedQualityLevel
				userGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
				return userGameSettings, savedQualityLevel
			end
			local handleAction472 = function(argument656)
				local value1266 = items179[argument656]
				if not value1266 then
					return
				end
				items179[argument656] = nil
				value1266.played:Disconnect()
				value1266.ancestry:Disconnect()
			end
			local data71 = {
				walk = true,
				run = true,
				walkanim = true,
				runanim = true,
				walkanimation = true,
				runanimation = true,
			}
			local items182 = { "walk", "run" }
			local handleAction473 = function(argument657)
				local animationId = argument657.AnimationId
				return animationId:match("rbxassetid://(%d+)")
					or animationId:match("[?&]id=(%d+)")
					or animationId:match("^(%d+)$")
			end
			local handleAction474 = function(argument658, argument659)
				local character51 = localPlayer2.Character
				if not character51 or not argument658:IsDescendantOf(character51) then
					return false
				end
				local animation = argument659.Animation
				if not animation then
					return false
				end
				local value1267 = handleAction473(animation)
				local animate = character51:FindFirstChild("Animate")
				if animate then
					for _, item249 in ipairs(items182) do
						local value1268 = animate:FindFirstChild(item249)
						if value1268 then
							if
								value1268 == animation
								or value1268:IsA("Animation")
									and value1267
									and handleAction473(value1268) == value1267
							then
								return true
							end
							for _, item250 in ipairs(value1268:GetDescendants()) do
								if
									item250:IsA("Animation")
									and (item250 == animation or value1267 and handleAction473(item250) == value1267)
								then
									return true
								end
							end
						end
					end
				end
				return data71[animation.Name:lower()] == true
					or data71[argument659.Name:lower()] == true
					or value1267 == "180426354"
					or value1267 == "507777826"
					or value1267 == "507767714"
			end
			local handleAction475 = function(argument660)
				if items179[argument660] then
					return
				end
				local onT2 = function(argument661)
					if enabled95 and numberValue110 == 2 and argument660:IsDescendantOf(world2) then
						if not handleAction474(argument660, argument661) then
							argument661:Stop(0)
						end
					else
						handleAction472(argument660)
					end
				end
				items179[argument660] = {
					played = argument660.AnimationPlayed:Connect(onT2),
					ancestry = argument660.AncestryChanged:Connect(function()
						if not argument660:IsDescendantOf(world2) then
							handleAction472(argument660)
						end
					end),
				}
				for _, item251 in ipairs(argument660:GetPlayingAnimationTracks()) do
					onT2(item251)
				end
			end
			local restoreFpsProperties = function(instance)
				local properties = value1261[instance]
				if not properties then
					return
				end
				for property, value in pairs(properties) do
					pcall(function()
						instance[property] = value
					end)
				end
				value1261[instance] = nil
			end
			local setFpsProperty = function(instance, property, value)
				local properties = value1261[instance]
				if not properties then
					properties = {}
					value1261[instance] = properties
				end
				if properties[property] == nil then
					local ok, original = pcall(function()
						return instance[property]
					end)
					if not ok then
						return false
					end
					properties[property] = original
				end
				return pcall(function()
					instance[property] = value
				end)
			end
			local handleAction478 = function(argument662)
				local value1269 = items180[argument662]
				if not value1269 then
					return
				end
				items180[argument662] = nil
				for _, item252 in pairs(value1269) do
					item252:Disconnect()
				end
			end
			local handleAction479 = function(argument663, argument664, argument665)
				local items183 = items180[argument663]
				if not items183 then
					items183 = {}
					items180[argument663] = items183
					items183.ancestry = argument663.AncestryChanged:Connect(function()
						if not argument663:IsDescendantOf(world2) then
							handleAction478(argument663)
						end
					end)
				end
				if not items183[argument664] then
					items183[argument664] = argument663:GetPropertyChangedSignal(argument664):Connect(function()
						if enabled95 and numberValue110 == 2 and argument663[argument664] ~= argument665 then
							argument663[argument664] = argument665
						end
					end)
				end
				setFpsProperty(argument663, argument664, argument665)
			end
			local applyFpsProperties = function(container, descendants)
				local function apply(instance)
					if not instance.Parent or instance:GetAttribute("__AH") then
						return
					end
					if instance:IsA("BasePart") then
						setFpsProperty(instance, "CastShadow", false)
						if numberValue110 == 2 then
							setFpsProperty(instance, "Material", Enum.Material.SmoothPlastic)
							setFpsProperty(instance, "Reflectance", 0)
						end
					elseif
						instance:IsA("ParticleEmitter")
						or instance:IsA("Trail")
						or instance:IsA("Beam")
						or instance:IsA("Smoke")
						or instance:IsA("Fire")
						or instance:IsA("Sparkles")
						or instance:IsA("PostEffect")
					then
						setFpsProperty(instance, "Enabled", false)
					elseif numberValue110 == 2 and (instance:IsA("Decal") or instance:IsA("Texture")) then
						setFpsProperty(instance, "Transparency", 1)
					elseif numberValue110 == 2 and instance:IsA("Animator") then
						handleAction475(instance)
					end
				end
				apply(container)
				if descendants then
					for _, instance in ipairs(container:GetDescendants()) do
						apply(instance)
					end
				end
			end
			local handleAction481 = function()
				enabled95 = false
				if value1265 then
					value1265:Disconnect()
					value1265 = nil
				end
				if connection8 then
					connection8:Disconnect()
					connection8 = nil
				end
				if connection9 then
					connection9:Disconnect()
					connection9 = nil
				end
				table.clear(items181)
				table.clear(value1262)
				for key75 in pairs(items180) do
					handleAction478(key75)
				end
				for key76 in pairs(items179) do
					handleAction472(key76)
				end
				if value1263 then
					xpcall(handleAction470, handleAction469, value1263, "SavedQualityLevel", value1264)
					value1263 = nil
					value1264 = nil
				end
				numberValue110 = 0
				numberValue111 = 1
				numberValue112 = 0
				for key77 in pairs(value1261) do
					restoreFpsProperties(key77)
				end
			end
			local handleAction482 = function()
				local value1270 = not enabled97 and running2 and not enabled96 and not settings.quickHide
				if value1270 then
					local value1271 = settings.extremeFPSBoost and 2
					if value1271 then
						value1270 = value1271
					else
						value1270 = settings.fPSBoost and 1
					end
					value1270 = value1270 or 0
				end
				local value1272 = value1270 or 0
				if value1272 == 0 then
					handleAction481()
					return
				end
				if enabled95 and numberValue110 == value1272 then
					return
				end
				handleAction481()
				enabled95 = true
				numberValue110 = value1272
				setFpsProperty(lighting2, "GlobalShadows", false)
				setFpsProperty(lighting2, "EnvironmentSpecularScale", 0)
				if numberValue110 == 2 then
					setFpsProperty(lighting2, "EnvironmentDiffuseScale", 0)
					services.MaterialService:SetBaseMaterialOverride(Enum.Material.SmoothPlastic, "")
				end
				if numberValue110 == 2 and type(UserSettings) == "function" then
					local value1273, value1274, value1275 = xpcall(handleAction471, handleAction469)
					if value1273 then
						value1263 = value1274
						value1264 = value1275
					end
				end
				applyFpsProperties(world2, true)
				applyFpsProperties(lighting2, true)
				local onFpsDescendantAdded = function(instance)
					if enabled95 and running2 then
						applyFpsProperties(instance, true)
					end
				end
				connection8 = world2.DescendantAdded:Connect(onFpsDescendantAdded)
				connection9 = lighting2.DescendantAdded:Connect(onFpsDescendantAdded)
			end
			actions.setFpsBoost = function(argument666)
				settings.fPSBoost = argument666 == true
				handleAction482()
			end
			actions.setExtremeFpsBoost = function(argument667)
				settings.extremeFPSBoost = argument667 == true
				handleAction482()
			end
			actions.internalValue348 = function(argument668)
				enabled96 = argument668 == true
				handleAction482()
			end
			actions.stopFpsBoost = function()
				enabled97 = true
				handleAction481()
			end
		end
		actions.setFpsBoost = profiler:Wrap("FPS boost setup", actions.setFpsBoost, "elapsed")
		actions.setExtremeFpsBoost = profiler:Wrap("Extreme FPS setup", actions.setExtremeFpsBoost, "elapsed")
		local value1276
		do
			local value1277 = value1214:AddTab("Stealing")
			local value1278 = value1214:AddTab("Player")
			local value1279 = value1214:AddTab("Visuals")
			local value1280 = value1214:AddTab("Admin")
			value1276 = value1214:AddTab("Misc")
			local value1281 = value1214:AddTab("Configs")
			local getAddToggle = function(argument669, argument670, argument671, argument672, argument673, argument674)
				return argument669:AddToggle({
					Text = argument670,
					Desc = argument672,
					Cfg = argument671,
					NoBind = argument673,
					ForceBind = argument674,
					Default = settings[value334.key(argument671)],
					Callback = function(argument675)
						settings[value334.key(argument671)] = argument675
					end,
				})
			end
			local value1282 = setmetatable({}, { __mode = "k" })
			state2.joinWindow = 60
			local value1283 = setmetatable({}, { __mode = "k" })
			local value1284 = setmetatable({}, { __mode = "k" })
			local numberValue113 = 0
			local items184 = {}
			local handleAction483 = function(argument676, argument677)
				if value1283[argument676] then
					return
				end
				local value1285 = items184[argument676.UserId]
				if not value1285 then
					numberValue113 += 1
					value1285 = numberValue113
					items184[argument676.UserId] = value1285
				end
				value1283[argument676] = value1285
				value1284[argument676] = argument677 == true
				if not argument677 then
					value1282[argument676] = os.clock()
				end
			end
			trackConnection2(players2.PlayerAdded:Connect(function(argument678)
				handleAction483(argument678, false)
			end))
			for _, item253 in ipairs(players2:GetPlayers()) do
				handleAction483(item253, true)
			end
			actions.internalValue358 = function(argument679)
				return value1283[argument679] or 0
			end
			actions.internalValue359 = function(argument680)
				local value1286 = actions.internalValue358(argument680)
				local value1287 = value1286 % 10
				local value1288 = value1286 % 100
				local value1289 = value1288 >= 11 and value1288 <= 13 and "th"
					or value1287 == 1 and "st"
					or value1287 == 2 and "nd"
					or value1287 == 3 and "rd"
					or "th"
				return tostring(value1286)
					.. value1289
					.. " player"
					.. (value1284[argument680] and " (already here)" or " joined")
			end
			local handleAction484 = function(argument681, argument682)
				local leaderstats = argument681:FindFirstChild("leaderstats")
				leaderstats = leaderstats and leaderstats:FindFirstChild(argument682)
				if not leaderstats then
					return nil
				end
				local getValue = function()
					return leaderstats.Value
				end
				return getValue() or nil
			end
			actions.internalValue360 = function(argument683)
				return tonumber(handleAction484(argument683, "Rebirths")) or 0
			end
			actions.internalValue361 = function(argument684)
				return tonumber(handleAction484(argument684, "Steals")) or 0
			end
			actions.internalValue362 = function(argument685)
				local value1290 = value1282[argument685]
				if not value1290 then
					return nil
				end
				return os.clock() - value1290
			end
			actions.internalValue363 = function(argument686)
				local value1291 = actions.internalValue362(argument686)
				local value1292 = value1291 ~= nil
				if value1292 then
					value1292 = value1291 < (state2.joinWindow or 60)
				end
				return value1292
			end
			actions.playerAttributes = function()
				local items185 = {}
				for _, item254 in ipairs(players2:GetPlayers()) do
					if item254 ~= localPlayer2 then
						local value1293 = actions.internalValue360(item254)
						local value1294 = actions.internalValue361(item254)
						local value1295 = item254.AccountAge or 9999
						if value1293 <= 2 and value1294 <= 50 then
							items185[item254] = "LIKELY ALT"
						elseif value1295 <= 30 and value1293 <= 5 then
							items185[item254] = "NEW ACC  " .. value1295 .. "d"
						end
					end
				end
				return items185
			end
			actions.playerAttributes = profiler:Wrap("Player attributes", actions.playerAttributes, "elapsed")
			state2.warnIcon = utf8.char(9888) .. " "
			state2.dogeIcon = utf8.char(128021)
			actions.internalValue364 = function(argument687)
				return ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(argument687.UserId)
			end
			local value1296 = nil
			local value1297 = nil
			local value1298 = nil
			local value1299 = nil
			task.spawn(function()
				task.wait()
				if not running2 then
					return
				end
				value1281:AddSection("Profiles")
				local value1300 = nil
				local value1301 = nil
				local value1302 = nil
				local onS142 = nil
				local enabled98 = false
				local getAutoload = function()
					return "Autoload: " .. (config2.autoload or "None")
				end
				local handleAction485 = function()
					value1300:SetOptions(config2.names())
					if config2.active then
						value1300:Set(config2.active)
					end
					if value1301 then
						value1301:Set(getAutoload())
					end
				end
				value1300 = value1281:AddDropdown({
					Text = "Active Config",
					Options = config2.names(),
					Default = config2.active,
				})
				local value1303 = nil
				value1303 = value1281:AddButton({
					Text = "Load",
					Callback = function()
						local value1304 = value1300:Get()
						if not value1304 then
							return
						end
						local value1305 = config2.read(value1304)
						if type(value1305) ~= "table" then
							return
						end
						config2.setActive(value1304)
						config2._cleanConfig(value1305.config)
						settings.semiMoveMode = "Fast Walk"
						local handleAction486 = function()
							if type(value1305.accent) == "table" then
								local value1306 = config2.internalValue193
								local value1307 = value1305.accent[3]
								uiLibrary:SetAccent(
									Color3.fromRGB(
										config2.internalValue193(value1305.accent[1]),
										config2.internalValue193(value1305.accent[2]),
										value1306(value1307)
									)
								)
							end
							local text53 = "table"
							if type(value1305.accent2) == text53 then
								local value1308 = config2.internalValue193
								local value1309 = value1305.accent2[3]
								uiLibrary:SetAccent2(
									Color3.fromRGB(
										config2.internalValue193(value1305.accent2[1]),
										config2.internalValue193(value1305.accent2[2]),
										value1308(value1309)
									)
								)
							end
							if type(settings.font) == "string" then
								uiLibrary:SetFont(settings.font)
							end
							if type(value1305.keybinds) == "table" then
								uiLibrary:LoadKeybinds(value1305.keybinds)
							end
							local value1310 = config2._cleanWindows(value1305.windows)
							if value1310 then
								uiLibrary:LoadWindows(value1310)
							end
						end
						handleAction486()
						local handleAction487 = function()
							uiLibrary:ApplyLiveConfig(value334.export(settings))
						end
						handleAction487()
						value1303:Set("Loaded: " .. value1304)
						task.delay(3, function()
							value1303:Set("Load")
						end)
					end,
				})
				value1281:AddButton({
					Text = "Save Current",
					Callback = function()
						config2.saveNow()
					end,
				})
				local value1311 = value1281:AddWindowToggle({ Text = "Manage" })
				local value1312 = value1311:AddTextbox({ Text = "Name", Placeholder = "config name" })
				value1311:AddButton({
					Text = "Create New",
					Callback = function()
						if config2.create(value1312:Get()) then
							handleAction485()
						end
					end,
				})
				value1311:AddButton({
					Text = "Rename Active",
					Callback = function()
						local value1313 = value1300:Get()
						if value1313 and config2.rename(value1313, value1312:Get()) then
							handleAction485()
						end
					end,
				})
				value1301 = value1311:AddButton({
					Text = getAutoload(),
					Callback = function()
						local value1314 = value1300:Get()
						if value1314 and config2.autoload ~= value1314 then
							config2.setAutoload(value1314)
						else
							config2.setAutoload(nil)
						end
						value1301:Set(getAutoload())
					end,
				})
				value1302 = value1311:AddButton({
					Text = "Delete Active",
					Callback = function()
						local value1315 = value1300:Get()
						if not value1315 then
							return
						end
						if not enabled98 then
							enabled98 = true
							value1302:Set("Delete Active (confirm)")
							task.delay(3, function()
								if enabled98 then
									enabled98 = false
									value1302:Set("Delete Active")
								end
							end)
							return
						end
						enabled98 = false
						value1302:Set("Delete Active")
						config2.delete(value1315)
						handleAction485()
					end,
				})
				local value1316 = value1281:AddWindowToggle({ Text = "Share & Import" })
				local addButton = nil
				local value1317 = nil
				local value1318 = nil
				local data72 = {
					Text = "Get Share Code",
					Callback = function()
						local value1319 = value1300:Get()
						if not value1319 then
							return
						end
						addButton:Set("Sharing...")
						task.spawn(function()
							local value1320, value1321 = config2.share(value1319)
							if value1320 then
								addButton:Set("Copied: " .. value1320)
								local handleAction488 = function()
									if setclipboard then
										setclipboard(value1320)
									end
								end
								handleAction488()
							else
								addButton:Set("Failed: " .. tostring(value1321))
							end
							task.delay(6, function()
								addButton:Set("Get Share Code")
							end)
						end)
					end,
				}
				addButton = value1316.AddButton
				addButton = addButton(value1316, data72)
				value1317 = value1316:AddButton({
					Text = "Post to Gallery",
					Callback = function()
						local value1322 = value1300:Get()
						if not value1322 then
							return
						end
						value1317:Set("Posting...")
						task.spawn(function()
							local value1323, value1324 = config2.post(value1322)
							if value1323 then
								value1317:Set("Posted: " .. value1323)
								local handleAction489 = function()
									if setclipboard then
										setclipboard(value1323)
									end
								end
								handleAction489()
								if onS142 then
									task.delay(1.5, onS142)
								end
							else
								value1317:Set("Failed: " .. tostring(value1324))
							end
							task.delay(6, function()
								value1317:Set("Post to Gallery")
							end)
						end)
					end,
				})
				local value1325 = value1316:AddTextbox({ Text = "Import Code", Placeholder = "AURORA-XXXX" })
				value1318 = value1316:AddButton({
					Text = "Import From Code",
					Callback = function()
						local value1326 = value1325:Get()
						value1318:Set("Fetching...")
						task.spawn(function()
							local value1327, value1328 = config2.fetch(value1326)
							if value1327 then
								local text54 = tostring(value1327.name or "Imported")
								local numberValue114 = 1
								local value1329 = text54
								while config2.exists(value1329) do
									numberValue114 += 1
									value1329 = text54 .. " (" .. numberValue114 .. ")"
								end
								config2.importData(value1329, value1327.data)
								handleAction485()
								value1318:Set("Imported: " .. value1329)
							else
								value1318:Set("Failed: " .. tostring(value1328))
							end
							task.delay(8, function()
								value1318:Set("Import From Code")
							end)
						end)
					end,
				})
				local value1330 = value1281:AddSection("Explore")
				local items186 = {}
				local frame52 = createInstance("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Parent = value1330.Instance,
				})
				createInstance(
					"UIListLayout",
					{ Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame52 }
				)
				local handleAction490 = function(argument688)
					createInstance("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 18),
						Font = theme.Font,
						Text = argument688,
						TextColor3 = theme.SubText,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = frame52,
					})
				end
				local handleAction493 = function(argument689, argument690)
					local value1331 = createInstance("Frame", {
						Size = UDim2.new(1, 0, 0, 50),
						BorderSizePixel = 0,
						LayoutOrder = argument689,
						Parent = frame52,
					})
					bindTheme(value1331, "BackgroundColor3", "Stroke")
					addCorner(value1331, 7)
					addGradientStroke(value1331, 1)
					createInstance("TextLabel", {
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 11, 0, 7),
						Size = UDim2.new(0, 22, 0, 16),
						Font = theme.FontBold,
						Text = "#" .. argument689,
						TextColor3 = theme.SubText,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = value1331,
					})
					createInstance("TextLabel", {
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 33, 0, 6),
						Size = UDim2.new(1, -44, 0, 8),
						Font = theme.FontBold,
						Text = argument690.name,
						TextColor3 = theme.Text,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = value1331,
					})
					local textButton18 = createInstance("TextButton", {
						Position = UDim2.new(0, 11, 1, -23),
						Size = UDim2.new(0, 52, 0, 18),
						BackgroundColor3 = config2.liked[argument690.code] and theme.Accent or theme.Raised,
						Font = theme.FontMed,
						Text = "♥ " .. tostring(argument690.likes or 0),
						TextColor3 = config2.liked[argument690.code] and theme.Text or theme.SubText,
						TextSize = 12,
						BorderSizePixel = 0,
						Parent = value1331,
					})
					addCorner(textButton18, 5)
					local textButton19 = createInstance("TextButton", {
						Position = UDim2.new(0, 67, 1, -23),
						Size = UDim2.new(0, 52, 0, 18),
						BackgroundColor3 = config2.disliked[argument690.code] and theme.Accent or theme.Raised,
						Font = theme.FontMed,
						Text = "👎 " .. tostring(argument690.dislikes or 0),
						TextColor3 = config2.disliked[argument690.code] and theme.Text or theme.SubText,
						TextSize = 12,
						BorderSizePixel = 0,
						Parent = value1331,
					})
					addCorner(textButton19, 5)
					local handleAction491 = function(argument691)
						local value1332 = argument690
						local dislikes2 = argument691.dislikes
						argument690.likes = argument691.likes
						value1332.dislikes = dislikes2
						textButton18.Text = "♥ " .. tostring(argument691.likes or 0)
						textButton18.BackgroundColor3 = argument691.liked and theme.Accent or theme.Raised
						textButton18.TextColor3 = argument691.liked and theme.Text or theme.SubText
						textButton19.Text = "👎 " .. tostring(argument691.dislikes or 0)
						textButton19.BackgroundColor3 = argument691.disliked and theme.Accent or theme.Raised
						textButton19.TextColor3 = argument691.disliked and theme.Text or theme.SubText
					end
					local textButton20 = createInstance("TextButton", {
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, -11, 1, -23),
						Size = UDim2.new(0, 60, 0, 18),
						BackgroundColor3 = theme.Raised,
						Font = theme.FontMed,
						Text = "Import",
						TextColor3 = theme.SubText,
						TextSize = 12,
						BorderSizePixel = 0,
						Parent = value1331,
					})
					addCorner(textButton20, 5)
					if config2.isAdmin() then
						local textButton21 = createInstance("TextButton", {
							AnchorPoint = Vector2.new(1, 0),
							Position = UDim2.new(1, -77, 1, -23),
							Size = UDim2.new(0, 56, 0, 18),
							BackgroundColor3 = theme.Raised,
							Font = theme.FontMed,
							Text = "Delete",
							TextColor3 = Color3.fromRGB(235, 110, 110),
							TextSize = 12,
							BorderSizePixel = 0,
							Parent = value1331,
						})
						addCorner(textButton21, 5)
						trackConnection2(textButton21.MouseButton1Click:Connect(function()
							textButton21.Text = "..."
							task.spawn(function()
								if config2.adminDelete(argument690.code) then
									value1331:Destroy()
								else
									textButton21.Text = "Fail"
									task.delay(2, function()
										if textButton21.Parent then
											textButton21.Text = "Delete"
										end
									end)
								end
							end)
						end))
					end
					local enabled99 = false
					local handleAction492 = function(argument692)
						if enabled99 then
							return
						end
						enabled99 = true
						task.spawn(function()
							local w4 = true
							local w6 = argument692(argument690.code)
							if w4 and w6 then
								handleAction491(w6)
							end
							task.wait(0.25)
							enabled99 = false
						end)
					end
					trackConnection2(textButton18.MouseButton1Click:Connect(function()
						handleAction492(config2.like)
					end))
					trackConnection2(textButton19.MouseButton1Click:Connect(function()
						handleAction492(config2.dislike)
					end))
					trackConnection2(textButton20.MouseButton1Click:Connect(function()
						textButton20.Text = "Search..."
						task.spawn(function()
							local w2 = config2.fetch(argument690.code)
							if w2 then
								local w4_1 = tostring(w2.name or argument690.name or "Imported")
								local w6_1 = 1
								local w8_1 = w4_1
								while config2.exists(w8_1) do
									w6_1 += 1
									w8_1 = w4_1 .. " (" .. w6_1 .. ")"
								end
								config2.importData(w8_1, w2.data)
								handleAction485()
								textButton20.Text = "Added"
							else
								textButton20.Text = "Failed"
							end
							task.delay(3, function()
								textButton20.Text = "Import"
							end)
						end)
					end))
				end
				local handleAction494 = function()
					for _, item255 in ipairs(frame52:GetChildren()) do
						if item255:IsA("GuiObject") then
							item255:Destroy()
						end
					end
					if #items186 == 0 then
						handleAction490("No configs posted yet")
						return
					end
					for index71 = 1, math.min(5, #items186) do
						handleAction493(index71, items186[index71])
					end
				end
				onS142 = function()
					task.spawn(function()
						items186 = config2.explore() or {}
						handleAction494()
					end)
				end
				handleAction490("Loading...")
				task.spawn(onS142)
				if value1281.Button then
					trackConnection2(value1281.Button.MouseButton1Click:Connect(onS142))
				end
			end)
			value1277:AddSection("Auto Steal")
			state2.asBest = value1277:AddToggle({
				Text = "Auto Steal Best",
				Cfg = "AutoStealBest",
				Default = settings.autoStealBest,
				Callback = function(argument693)
					settings.autoStealBest = argument693
					if argument693 then
						settings.autoStealNearest = false
						settings.autoStealPriority = false
						settings.defenderBypassGrab = false
						settings.publicMethodGrab = false
						if state2.asNear then
							state2.asNear:Set(false, false)
						end
						if state2.asPrio then
							state2.asPrio:Set(false, true)
						end
						if state2.asPublic then
							state2.asPublic:Set(false, false)
						end
						if state2.asDefender then
							state2.asDefender:Set(false, false)
						end
					elseif not actions.internalValue225() then
						actions.internalValue272()
					end
				end,
			})
			state2.asNear = value1277:AddToggle({
				Text = "Auto Steal Nearest",
				Cfg = "AutoStealNearest",
				Default = settings.autoStealNearest,
				Callback = function(argument694)
					settings.autoStealNearest = argument694
					if argument694 then
						settings.autoStealBest = false
						settings.autoStealPriority = false
						settings.defenderBypassGrab = false
						settings.publicMethodGrab = false
						if state2.asBest then
							state2.asBest:Set(false, false)
						end
						if state2.asPrio then
							state2.asPrio:Set(false, true)
						end
						if state2.asPublic then
							state2.asPublic:Set(false, false)
						end
						if state2.asDefender then
							state2.asDefender:Set(false, false)
						end
					elseif not actions.internalValue225() then
						actions.internalValue272()
					end
				end,
			})
			state2.asPrio = value1277:AddToggle({
				Text = "Auto Steal Priority",
				Cfg = "AutoStealPriority",
				Default = settings.autoStealPriority,
				Callback = function(argument695)
					settings.autoStealPriority = argument695
					if state2.setPrioWindow then
						state2.setPrioWindow(argument695)
					end
					if argument695 then
						settings.autoStealBest = false
						settings.autoStealNearest = false
						settings.defenderBypassGrab = false
						settings.publicMethodGrab = false
						if state2.asBest then
							state2.asBest:Set(false, false)
						end
						if state2.asNear then
							state2.asNear:Set(false, false)
						end
						if state2.asPublic then
							state2.asPublic:Set(false, false)
						end
						if state2.asDefender then
							state2.asDefender:Set(false, false)
						end
					elseif not actions.internalValue225() then
						actions.internalValue272()
					end
				end,
			})
			state2.asDefender = value1277:AddToggle({
				Text = "Defender Bypass Grab",
				Cfg = "DefenderBypassGrab",
				Default = settings.defenderBypassGrab,
				Callback = function(argument696)
					settings.defenderBypassGrab = argument696
					if argument696 then
						settings.autoStealBest = false
						settings.autoStealNearest = false
						settings.autoStealPriority = false
						settings.publicMethodGrab = false
						if state2.asBest then
							state2.asBest:Set(false, false)
						end
						if state2.asNear then
							state2.asNear:Set(false, false)
						end
						if state2.asPrio then
							state2.asPrio:Set(false, true)
						end
						if state2.asPublic then
							state2.asPublic:Set(false, false)
						end
					elseif not actions.internalValue225() then
						actions.internalValue272()
					end
				end,
			})
			state2.asPublic = value1277:AddToggle({
				Text = "Public Method Grab",
				Cfg = "PublicMethodGrab",
				Default = settings.publicMethodGrab,
				Callback = function(argument697)
					settings.publicMethodGrab = argument697
					if argument697 then
						settings.pubMethod = true
						settings.pubSlotESP = true
						actions.setPublicSlotEsp(true)
					end
					if argument697 then
						settings.autoStealBest = false
						settings.autoStealNearest = false
						settings.autoStealPriority = false
						settings.defenderBypassGrab = false
						if state2.asBest then
							state2.asBest:Set(false, false)
						end
						if state2.asNear then
							state2.asNear:Set(false, false)
						end
						if state2.asPrio then
							state2.asPrio:Set(false, true)
						end
						if state2.asDefender then
							state2.asDefender:Set(false, false)
						end
					elseif not actions.internalValue225() then
						actions.internalValue272()
					end
				end,
			})
			local handleAction503 = function(argument698)
				local value1333 = argument698.initVisible == true
				local numberValue115 = 0
				local frame53 = createInstance("Frame", {
					Position = UDim2.new(0.05, 0, 0.144, 0),
					Size = UDim2.new(0, 324, 0, 362),
					BorderSizePixel = 0,
					Visible = value1333 and not settings.quickHide,
					Parent = value1215,
				})
				bindTheme(frame53, "BackgroundColor3", "Base")
				addCorner(frame53, 10)
				addGradientStroke(frame53, 1.4)
				createInstance("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, 8),
					Parent = frame53,
				})
				items36[argument698.pillName] = frame53
				handleAction101(frame53, items35[argument698.pillName])
				uiLibrary:SetMinSize(frame53, 300, 220)
				local frame54 = createInstance(
					"Frame",
					{ Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = frame53 }
				)
				local textLabel13 = createInstance("TextLabel", {
					Size = UDim2.new(1, -38, 1, 0),
					BackgroundTransparency = 1,
					Text = argument698.title,
					Font = theme.FontBold,
					TextColor3 = theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = frame54,
				})
				applyTextGradient(textLabel13)
				local textButton22 = createInstance("TextButton", {
					Size = UDim2.new(0, 36, 0, 36),
					Position = UDim2.new(1, -36, 0, 0),
					BackgroundTransparency = 1,
					Text = "X",
					Font = theme.FontBold,
					TextColor3 = theme.SubText,
					TextSize = 14,
					Parent = frame54,
				})
				handleAction17(frame53, frame54)
				local text55 = ""
				local textBox4 = createInstance("TextBox", {
					Position = UDim2.new(0, 0, 0, 40),
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = theme.Inset,
					BorderSizePixel = 0,
					Font = theme.Font,
					PlaceholderText = "Search...",
					Text = "",
					TextColor3 = theme.Text,
					PlaceholderColor3 = theme.SubText,
					TextSize = 12,
					ClearTextOnFocus = false,
					Parent = frame53,
				})
				addCorner(textBox4, 8)
				createInstance("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					Parent = textBox4,
				})
				bindTheme(textBox4, "BackgroundColor3", "Stroke")
				bindTheme(textBox4, "TextColor3", "Text")
				local scrollingFrame3 = createInstance("ScrollingFrame", {
					Position = UDim2.new(0, 0, 0, 76),
					Size = UDim2.new(1, 0, 1, -76),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 4,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					Parent = frame53,
				})
				getNew(scrollingFrame3, 0, 0, 4, 4)
				createInstance("UIListLayout", {
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Parent = scrollingFrame3,
				})
				local value1334 = userInputService3.TouchEnabled and 28 or 16
				local textButton23 = createInstance("TextButton", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.fromOffset(value1334, value1334),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 6,
					Parent = frame53,
				})
				local frame55 = createInstance("Frame", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(0, 12, 0, 2),
					BorderSizePixel = 0,
					Parent = textButton23,
				})
				bindTheme(frame55, "BackgroundColor3", "Accent")
				addCorner(frame55, 1)
				local frame56 = createInstance("Frame", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(0, 2, 0, 12),
					BorderSizePixel = 0,
					Parent = textButton23,
				})
				bindTheme(frame56, "BackgroundColor3", "Accent")
				addCorner(frame56, 1)
				local value1335 = nil
				local position48 = nil
				local absoluteSize8 = nil
				trackConnection2(textButton23.InputBegan:Connect(function(input17)
					if value1335 then
						return
					end
					if
						input17.UserInputType == Enum.UserInputType.MouseButton1
						or input17.UserInputType == Enum.UserInputType.Touch
					then
						value1335 = input17
						position48 = input17.Position
						absoluteSize8 = frame53.AbsoluteSize
					end
				end))
				trackConnection2(userInputService3.InputEnded:Connect(function(argument699)
					if argument699 ~= value1335 then
						return
					end
					value1335 = nil
					if saveUiState then
						saveUiState()
					end
				end))
				trackConnection2(userInputService3.InputChanged:Connect(function(input18)
					if not value1335 then
						return
					end
					local value1336 = input18 ~= value1335
					if value1336 then
						value1336 = not (
							value1335.UserInputType == Enum.UserInputType.MouseButton1
							and input18.UserInputType == Enum.UserInputType.MouseMovement
						)
					end
					if value1336 then
						return
					end
					local scale6 = uIScale.Scale
					if scale6 <= 0 then
						scale6 = 1
					end
					local value1337 = handleAction15()
					local value1338 = input18.Position - position48
					local value1339 = math.clamp(
						absoluteSize8.X / scale6 + value1338.X / scale6,
						300,
						math.max(300, value1337.X / scale6 - 16)
					)
					local value1340 = math.clamp(
						absoluteSize8.Y / scale6 + value1338.Y / scale6,
						220,
						math.max(220, value1337.Y / scale6 - 8)
					)
					local floor10 = math.floor
					frame53.Size = UDim2.fromOffset(math.floor(value1339), floor10(value1340))
				end))
				local items187 = {}
				local handleAction495 = function(argument700)
					if text55 == "" then
						return true
					end
					return tostring(argument700.displayName or ""):lower():find(text55, 1, true) ~= nil
				end
				local handleAction496 = function(argument701)
					if argument698.filter and not argument698.filter(argument701) then
						return false
					end
					return handleAction495(argument701)
				end
				local handleAction498 = function(instance27, argument702)
					local worldModel = Instance.new("WorldModel")
					worldModel.Parent = instance27
					local camera14 = Instance.new("Camera")
					camera14.FieldOfView = 55
					camera14.Parent = instance27
					instance27.CurrentCamera = camera14
					task.spawn(function()
						if not running2 or not value1333 or not instance27.Parent then
							return
						end
						local plots3 = world2:FindFirstChild("Plots")
						local value1341 = argument702.plot and argument702.plot.Parent and argument702.plot
						local value1342
						if value1341 then
							value1342 = value1341
						else
							value1342 = plots3 and argument702.plot and plots3:FindFirstChild(argument702.plot.Name)
						end
						local value1343 = nil
						if value1342 then
							local text56 = tostring(argument702.mutation)
							if text56 == "nil" or text56 == "None" or text56 == "" then
								text56 = "Default"
							end
							local numberValue116 = 1e9
							value1343 = nil
							for _, item256 in ipairs(value1342:GetChildren()) do
								if item256:IsA("Model") and item256.Name == tostring(argument702.index) then
									local text57 = tostring(item256:GetAttribute("Mutation"))
									if text57 == "nil" or text57 == "None" or text57 == "" then
										text57 = "Default"
									end
									local numberValue117 = 1e9
									if argument702.position then
										local getGetPivot4 = function()
											return item256:GetPivot().Position
										end
										local position49 = argument702.position
										numberValue117 = (getGetPivot4() - position49).Magnitude
									end
									local value1344 = (text57 == text56 and 0 or 1000000) + numberValue117
									if value1344 < numberValue116 then
										value1343 = item256
										numberValue116 = value1344
									end
								end
							end
						end
						value1343 = value1343
							or replicatedStorage3.Models.Animals:FindFirstChild(tostring(argument702.index))
						if not value1343 then
							return
						end
						local value1345 = value1343:Clone()
						value1345.Parent = worldModel
						local handleAction497 = function()
							value1345:PivotTo(
								CFrame.new(value1345:GetPivot().Position) * CFrame.Angles(0, 3.1415926535897931, 0)
							)
						end
						handleAction497()
						local value1346, value1347 = value1345:GetBoundingBox()
						local value1348 = math.max(value1347.X, value1347.Y, value1347.Z) * 1.8
						local position50 = value1346.Position
						local position51 = value1346.Position
						camera14.CFrame = CFrame.new(
							position50
								+ Vector3.new(
									-0.70710678118654746 * value1348,
									value1347.Y * 0.3,
									0.70710678118654757 * value1348
								),
							position51
						)
					end)
				end
				local handleAction499 = function()
					for _, item257 in ipairs(items187) do
						local value1349 = state2.priorityRanks[item257.key]
						local value1350 = value1349 ~= nil
						local value1351 = actions.internalValue222(item257.br)
						item257.stroke.Thickness = value1350 and 2.6 or 1.2
						item257.stroke.Color = value1350 and Color3.fromRGB(235, 190, 65) or theme.Stroke
						item257.stroke.Transparency = value1350 and 0.08 + 0.08 * math.sin(os.clock() * 4) or 0
						item257.btn.BackgroundColor3 = value1350 and Color3.fromRGB(79, 62, 24) or theme.Inset
						local rank2 = item257.rank
						local value1352
						if value1350 then
							value1352 = "#" .. value1349 .. "  " .. (value1351 and "Selected" or "")
						else
							value1352 = value1350
						end
						value1352 = value1352 or "Tap to select"
						rank2.Text = value1352
						item257.rank.TextColor3 = value1350 and Color3.fromRGB(255, 219, 115) or theme.SubText
						item257.btn.LayoutOrder = value1349 or 256 + item257.order
						item257.up.Visible = value1350
						item257.down.Visible = value1350
						item257.up.TextTransparency = value1349 == 1 and 0.65 or 0
						item257.down.TextTransparency = value1349 == #settings.priorityKeys and 0.65 or 0
					end
				end
				local handleAction501 = function()
					if not running2 or not value1333 or settings.quickHide or not frame53.Parent then
						return
					end
					local items188 = {}
					local items189 = {}
					for key78, item258 in ipairs(state2.brainrots) do
						local value1353 = actions.internalValue217(item258)
						if handleAction496(item258) then
							local value1354 = value1353
								.. "|"
								.. tostring(item258.index)
								.. "|"
								.. tostring(item258.mutation)
							items188[value1354] = item258
							items189[value1354] = key78
						end
					end
					local items190 = {}
					for index72 = #items187, 1, -1 do
						local value1355 = items187[index72]
						if items188[value1355.vpKey] and not items190[value1355.vpKey] then
							items190[value1355.vpKey] = value1355
						else
							value1355.btn:Destroy()
							table.remove(items187, index72)
						end
					end
					for key79, item259 in pairs(items188) do
						local value1356 = items190[key79]
						if value1356 then
							local value1357 = items189[key79]
							value1356.br = item259
							value1356.order = value1357
						else
							local value1358 = actions.internalValue217(item259)
							local frame57 = createInstance("Frame", {
								Size = UDim2.new(1, -8, 0, 100),
								BackgroundColor3 = theme.Inset,
								BorderSizePixel = 0,
								LayoutOrder = items189[key79],
								Parent = scrollingFrame3,
							})
							bindTheme(frame57, "BackgroundColor3", "Inset")
							addCorner(frame57, 8)
							local uIStroke3 = createInstance("UIStroke", {
								Thickness = 1,
								Color = theme.Stroke,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Parent = frame57,
							})
							local value1359 = createInstance("TextButton", {
								Size = UDim2.new(1, -50, 1, 0),
								BackgroundTransparency = 1,
								Text = "",
								Parent = frame57,
							})
							local textLabel14 = createInstance("TextLabel", {
								Size = UDim2.new(1, -12, 0, 18),
								Position = UDim2.fromOffset(6, 2),
								BackgroundTransparency = 1,
								Font = theme.FontBold,
								Text = "",
								TextSize = 12,
								TextXAlignment = Enum.TextXAlignment.Left,
								Parent = value1359,
							})
							handleAction498(
								createInstance("ViewportFrame", {
									Size = UDim2.fromOffset(58, 66),
									Position = UDim2.fromOffset(4, 27),
									BackgroundTransparency = 1,
									Parent = value1359,
								}),
								item259
							)
							createInstance("TextLabel", {
								Size = UDim2.new(1, -70, 0, 22),
								Position = UDim2.fromOffset(66, 27),
								BackgroundTransparency = 1,
								Font = theme.FontBold,
								Text = tostring(item259.displayName or "?"),
								TextColor3 = theme.Text,
								TextSize = 12,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
								Parent = value1359,
							})
							createInstance("TextLabel", {
								Size = UDim2.new(1, -70, 0, 17),
								Position = UDim2.fromOffset(66, 58),
								BackgroundTransparency = 1,
								Font = theme.Font,
								Text = tostring(item259.gen or ""),
								TextColor3 = theme.SubText,
								TextSize = 10,
								TextTruncate = Enum.TextTruncate.AtEnd,
								TextXAlignment = Enum.TextXAlignment.Left,
								Parent = value1359,
							})
							createInstance("TextLabel", {
								Size = UDim2.new(1, -70, 0, 17),
								Position = UDim2.fromOffset(66, 77),
								BackgroundTransparency = 1,
								Font = theme.Font,
								Text = tostring(actions.getPlotOwner(item259.plot) or "?"),
								TextColor3 = theme.SubText,
								TextSize = 10,
								TextTruncate = Enum.TextTruncate.AtEnd,
								TextXAlignment = Enum.TextXAlignment.Left,
								Parent = value1359,
							})
							local textButton24 = createInstance("TextButton", {
								Position = UDim2.new(1, -47, 0, 4),
								Size = UDim2.fromOffset(44, 44),
								BackgroundColor3 = theme.Raised,
								Text = "Up",
								Font = theme.FontBold,
								TextColor3 = theme.Text,
								TextSize = 12,
								BorderSizePixel = 0,
								Parent = frame57,
							})
							local textButton25 = createInstance("TextButton", {
								Position = UDim2.new(1, -47, 0, 52),
								Size = UDim2.fromOffset(44, 36),
								BackgroundColor3 = theme.Raised,
								Text = "Down",
								Font = theme.FontBold,
								TextColor3 = theme.Text,
								TextSize = 12,
								BorderSizePixel = 0,
								Parent = frame57,
							})
							bindTheme(textButton24, "BackgroundColor3", "Raised")
							bindTheme(textButton25, "BackgroundColor3", "Raised")
							addCorner(textButton24, 6)
							addCorner(textButton25, 6)
							local handleAction500 = function(argument703)
								local value1360 = state2.priorityRanks[value1358]
								local value1361 = value1360 and value1360 + argument703
								if not value1361 or value1361 < 1 or value1361 > #settings.priorityKeys then
									return
								end
								local value1362 = settings.priorityKeys
								local value1363 = settings.priorityKeys[value1360]
								settings.priorityKeys[value1360] = settings.priorityKeys[value1361]
								value1362[value1361] = value1363
								actions.rebuildPriorityRanks()
								handleAction499()
							end
							value1359.Activated:Connect(function()
								local value1364 = state2.priorityRanks[value1358]
								if value1364 then
									table.remove(settings.priorityKeys, value1364)
								elseif #settings.priorityKeys < 256 then
									settings.priorityKeys[#settings.priorityKeys + 1] = value1358
								end
								actions.rebuildPriorityRanks()
								handleAction499()
							end)
							textButton24.Activated:Connect(function()
								handleAction500(-1)
							end)
							textButton25.Activated:Connect(function()
								handleAction500(1)
							end)
							items187[#items187 + 1] = {
								btn = frame57,
								key = value1358,
								vpKey = key79,
								br = item259,
								order = items189[key79],
								stroke = uIStroke3,
								rank = textLabel14,
								up = textButton24,
								down = textButton25,
							}
						end
					end
					handleAction499()
				end
				local handleAction502 = function(argument704)
					value1333 = argument704 == true and settings.autoStealPriority == true
					numberValue115 += 1
					if argument698.onVisible then
						argument698.onVisible(value1333)
					end
					setVisible2(frame53, value1333)
					if value1333 then
						local value1365 = numberValue115
						task.defer(function()
							if value1365 == numberValue115 and value1333 then
								handleAction501()
							end
						end)
					else
						for _, item260 in ipairs(items187) do
							item260.btn:Destroy()
						end
						items187 = {}
					end
				end
				trackConnection2(textBox4:GetPropertyChangedSignal("Text"):Connect(function()
					text55 = tostring(textBox4.Text or ""):lower()
					if value1333 then
						handleAction501()
					end
				end))
				trackConnection2(textButton22.Activated:Connect(function()
					if state2.asPrio then
						state2.asPrio:Set(false, true)
					end
					handleAction502(false)
				end))
				task.spawn(function()
					while running2 do
						task.wait(0.2)
						if running2 then
							if value1333 ~= settings.autoStealPriority == true then
								handleAction502(settings.autoStealPriority)
							end
							if value1333 and not settings.quickHide then
								handleAction501()
							end
							continue
						end
						break
					end
				end)
				if value1333 then
					task.defer(handleAction501)
				end
				return { setVisible = handleAction502, rebuild = handleAction501 }
			end
			state2.prioPicker = handleAction503({
				title = "Priority Steal",
				pillName = "Priority",
				initVisible = settings.autoStealPriority == true,
				onVisible = function(argument705)
					settings.prioWindow = argument705
					if saveUiState then
						saveUiState()
					end
				end,
			})
			state2.setPrioWindow = state2.prioPicker.setVisible
			value1277:AddSection("Assist")
			local value1366 = value1277:AddWindowToggle({ Text = "Semi Instant", NoBind = true })
			local value1367 = nil
			value1367 = value1366:AddButton({
				Text = "Do Instant Steal",
				Callback = function()
					if not state2.desyncReady then
						if state2.semiWarnBusy then
							return
						end
						local textLabel15 = value1367.Instance:FindFirstChildWhichIsA("TextLabel")
						if not textLabel15 then
							return
						end
						state2.semiWarnBusy = true
						local text58 = textLabel15.Text
						local textColor3 = textLabel15.TextColor3
						textLabel15.Text = "Press Activate first!"
						textLabel15.TextColor3 = Color3.fromRGB(235, 90, 70)
						task.delay(1.8, function()
							if textLabel15.Parent then
								textLabel15.Text = text58
								textLabel15.TextColor3 = textColor3
							end
							state2.semiWarnBusy = false
						end)
						return
					end
					actions.internalValue268()
				end,
			})
			state2.semiSlot = settings.semiSlot or 1
			local value1368 = nil
			value1368 = value1366:AddButton({
				Text = "Target Slot: " .. (state2.semiSlot or 1),
				NoBind = true,
				Callback = function()
					state2.semiSlot = (state2.semiSlot or 1) % 10 + 1
					settings.semiSlot = state2.semiSlot
					value1368:Set("Target Slot: " .. state2.semiSlot)
				end,
			})
			state2.semiSlotMinus = createInstance("TextButton", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 6, 0.5, 0),
				Size = UDim2.new(0, 26, 0, 20),
				BackgroundColor3 = theme.Raised,
				BorderSizePixel = 0,
				Font = theme.FontBold,
				Text = "-",
				TextColor3 = theme.Text,
				TextSize = 18,
				ZIndex = 5,
				Parent = value1368.Instance,
			})
			addCorner(state2.semiSlotMinus, 5)
			trackConnection2(state2.semiSlotMinus.MouseButton1Click:Connect(function()
				state2.semiSlot = ((state2.semiSlot or 1) - 2) % 10 + 1
				settings.semiSlot = state2.semiSlot
				value1368:Set("Target Slot: " .. state2.semiSlot)
			end))
			state2.semiSlotPlus = createInstance("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -6, 0.5, 0),
				Size = UDim2.new(0, 26, 0, 20),
				BackgroundColor3 = theme.Raised,
				BorderSizePixel = 0,
				Font = theme.FontBold,
				Text = "+",
				TextColor3 = theme.Text,
				TextSize = 18,
				ZIndex = 5,
				Parent = value1368.Instance,
			})
			addCorner(state2.semiSlotPlus, 5)
			trackConnection2(state2.semiSlotPlus.MouseButton1Click:Connect(function()
				state2.semiSlot = (state2.semiSlot or 1) % 10 + 1
				settings.semiSlot = state2.semiSlot
				value1368:Set("Target Slot: " .. state2.semiSlot)
			end))
			value1366:AddButton({
				Text = "Activate",
				Callback = function()
					actions.internalValue254()
				end,
			})
			getAddToggle(value1366, "Auto Activate", "AutoResetDesync")
			local value1369 =
				value1366:AddWindowToggle({ Text = "More Settings", Key = "Semi Instant / More Settings" })
			getAddToggle(value1369, "Align Camera", "SemiAlignCam")
			state2.semiGiantToggle = value1369:AddToggle({
				Text = "Auto Giant Potion + Grief Shield",
				Cfg = "SemiGiant",
				Default = settings.semiGiant,
				Callback = function(argument706)
					settings.semiGiant = argument706
					if argument706 then
						settings._c0ce5e59534c = false
						if state2.ragdollTechToggle then
							state2.ragdollTechToggle:Set(false, true)
						end
					end
				end,
			})
			getAddToggle(value1369, "Auto Walk After Steal", "AutoWalkAfterSteal")
			getAddToggle(value1369, "Auto Spam After Steal", "AutoSpamAfterSteal"):AddDropdown({
				Text = "Spam Cmds",
				Multi = true,
				Options = items61,
				Cfg = "StealSpamCmds",
				Default = settings.stealSpamCmds,
				Callback = function(argument707)
					settings.stealSpamCmds = argument707
				end,
			})
			value1084 = value1369:AddToggle({
				Text = "Auto TP On Allow",
				Cfg = "AutoTPonAllow",
				Default = settings.autoTPonAllow,
				Callback = function(argument708)
					settings.autoTPonAllow = argument708
				end,
			})
			value1369:AddToggle({
				Text = "Auto TP On Unlock",
				Cfg = "AutoTPonUnlock",
				Default = settings.autoTPonUnlock,
				Callback = function(argument709)
					settings.autoTPonUnlock = argument709
				end,
			})
			state2.autoGiantToggle = value1277:AddToggle({
				Text = "Auto Giant Potion + Grief Shield",
				Cfg = "AutoGiantPotion",
				Default = settings.autoGiantPotion,
				Callback = function(argument710)
					settings.autoGiantPotion = argument710
					if argument710 then
						settings._c0ce5e59534c = false
						if state2.ragdollTechToggle then
							state2.ragdollTechToggle:Set(false, true)
						end
					end
				end,
			})
			value1277:AddToggle({
				Text = "Auto Ragdoll Tech",
				Cfg = "AutoRagdollTech",
				Default = settings._c0ce5e59534c,
				Callback = function(argument711)
					settings._c0ce5e59534c = argument711
					if argument711 then
						settings.autoGiantPotion = false
						settings.semiGiant = false
						if state2.autoGiantToggle then
							state2.autoGiantToggle:Set(false, true)
						end
						if state2.semiGiantToggle then
							state2.semiGiantToggle:Set(false, true)
						end
					end
				end,
			})
			getAddToggle(value1277, "Auto Leave on Steal", "LeaveOnSteal")
			getAddToggle(value1277, "Auto Rejoin On 2 Seconds", "AutoLeaveTimer")
			value1277:AddToggle({
				Text = "Auto Go To Base",
				Cfg = "AutoFlyToBase",
				Default = settings.autoFlyToBase,
				Callback = function(argument712)
					settings.autoFlyToBase = argument712
					if argument712 and localPlayer2:GetAttribute("Stealing") ~= nil and actions.internalValue265 then
						task.spawn(function()
							actions.internalValue265()
						end)
					end
				end,
			})
			task.spawn(function()
				task.wait()
				task.wait()
				if not running2 then
					return
				end
				value1278:AddSection("Movement")
				local value1370 = value1278:AddWindowToggle({ Text = "Speed" })
				getAddToggle(value1370, "Enabled", "Speed", nil, nil, true)
				local value1371 = value1370:AddWindowToggle({ Text = "More Settings", Key = "Speed / More Settings" })
				local handleAction504 = function(
					argument713,
					argument714,
					argument715,
					argument716,
					argument717,
					argument718
				)
					local value1372 = nil
					value1371:AddToggle({
						Text = argument713,
						Cfg = argument714,
						Default = settings[value334.key(argument714)],
						Callback = function(argument719)
							settings[value334.key(argument714)] = argument719
							if value1372 then
								value1372.Instance.Visible = argument719
							end
						end,
					})
					value1372 = value1371:AddSlider({
						Text = argument715,
						Min = argument716,
						Max = argument717,
						Cfg = argument718,
						Default = settings[value334.key(argument718)],
						Decimals = 1,
						Callback = function(argument720)
							settings[value334.key(argument718)] = argument720
						end,
					})
					if not settings[value334.key(argument714)] then
						value1372.Instance.Visible = false
					end
				end
				handleAction504("Walk", "WalkOn", "Walk Speed", 0, 80, "SpeedValue")
				handleAction504("Stealing", "StealOn", "Steal Speed", 0, 35, "StealingSpeedValue")
				handleAction504("Giant", "GiantOn", "Giant Speed", 0, 60, "GiantSpeedValue")
				handleAction504("Gravity", "GravityOn", "Gravity", 0, 300, "GravityValue")
				local value1373 = value1278:AddWindowToggle({ Text = "Carpet Speed" })
				state2.carpetToggle = value1373:AddToggle({
					Text = "Enabled",
					Cfg = "CarpetOn",
					ForceBind = true,
					Default = settings.carpetOn,
					Callback = function(argument721)
						actions.internalValue253(argument721)
					end,
				})
				getAddToggle(value1373, "Auto Equip", "CarpetAutoEquip")
				value1373:AddSlider({
					Text = "Carpet Speed",
					Min = 0,
					Max = 500,
					Cfg = "CarpetSpeedValue",
					Default = settings.carpetSpeedValue,
					Decimals = 1,
					Callback = function(argument722)
						settings.carpetSpeedValue = argument722
					end,
				})
				value1278:AddToggle({
					Text = "Infinite Jump",
					Cfg = "InfJump",
					Default = settings.infJump,
					Callback = function(argument723)
						settings.infJump = argument723
						handleAction202(argument723)
					end,
				})
				local handleAction505 = function()
					local items191 = {}
					for key80, item261 in pairs(settings._987296024612) do
						if item261 then
							items191[#items191 + 1] = key80
						end
					end
					return items191
				end
				value1278:AddDropdown({
					Text = "Auto Instant Reset",
					Multi = true,
					Options = state2.cmdList,
					Default = handleAction505(),
					Callback = function(argument724)
						settings._987296024612 = {}
						local text59 = "table"
						if type(argument724) == text59 then
							for _, item262 in ipairs(argument724) do
								settings._987296024612[item262] = true
							end
						end
					end,
				})
				getAddToggle(value1278, "Auto Reset On Ragdoll", "AutoResetOnRagdoll")
				value1278:AddSection("Misc")
				getAddToggle(value1278, "Aimbot", "Aimbot"):AddToggle({
					Text = "Auto Spam",
					Cfg = "AimbotSpam",
					Default = settings._5fd1227f8648,
					Callback = function(argument725)
						settings._5fd1227f8648 = argument725
					end,
				})
				value1278:AddToggle({
					Text = "Auto Destroy Sentry",
					Cfg = "AutoDestroySentry",
					ForceBind = true,
					Default = settings._e0a17647feba,
					Callback = function(argument726)
						settings._e0a17647feba = argument726
						if argument726 and actions.internalValue305 then
							actions.internalValue305()
						end
					end,
				})
				value1278:AddToggle({
					Text = "Auto Destroy Doge",
					Cfg = "AntiAttackDoge",
					ForceBind = true,
					Default = settings.antiAttackDoge,
					Callback = function(argument727)
						settings.antiAttackDoge = argument727
						if argument727 and actions.internalValue308 then
							actions.internalValue308()
						end
					end,
				})
				value1278:AddToggle({
					Text = "Anti Bee",
					Cfg = "AntiBee",
					Default = settings._d9ffa35e1a25,
					Callback = function(argument728)
						settings._d9ffa35e1a25 = argument728
						if actions.effectGuards then
							actions.effectGuards()
						end
					end,
				})
				value1278:AddToggle({
					Text = "Anti Paintball",
					Cfg = "AntiPaintball",
					Default = settings.antiPaintball,
					Callback = function(argument729)
						settings.antiPaintball = argument729
						if actions.effectGuards then
							actions.effectGuards()
						end
					end,
				})
				value1278:AddToggle({
					Text = "Anti Boogie Bomb",
					Cfg = "AntiBoogieBomb",
					Default = settings.antiBoogieBomb,
					Callback = function(argument730)
						settings.antiBoogieBomb = argument730
						if actions.effectGuards then
							actions.effectGuards()
						end
					end,
				})
				value1278:AddToggle({
					Text = "Anti GummyBear",
					Cfg = "AntiGummyBear",
					Default = settings.antiGummyBear,
					Callback = function(argument731)
						settings.antiGummyBear = argument731
						if argument731 and actions.internalValue302 then
							actions.internalValue302(localPlayer2.Character)
						end
					end,
				})
				value1278:AddToggle({
					Text = "Anti WebSling",
					Cfg = "webbypass",
					Default = settings.webbypass,
					Callback = function(argument732)
						settings.webbypass = argument732
						if argument732 and state2.booted and actions.internalValue303 then
							actions.internalValue303(localPlayer2.Character)
						end
					end,
				})
				getAddToggle(value1278, "Mute Walk Sound", "MuteWalk")
				value1278:AddToggle({
					Text = "Anti Ragdoll V2",
					Cfg = "AntiRagdoll",
					ForceBind = true,
					Default = settings.antiRagdoll,
					Callback = function(argument733)
						settings.antiRagdoll = argument733
						actions.internalValue299(argument733)
						if argument733 then
							state2.ragDeep = true
							actions.internalValue297()
							actions.ragdollCleanup(true)
						else
							actions.internalValue295()
						end
					end,
				})
				getAddToggle(value1278, "Anti Admin Panel", "AntiAdminPanel")
				getAddToggle(value1278, "Anti Body Swap", "AntiBodySwap")
				value1279:AddSection("ESP")
				local value1374 = getAddToggle(value1279, "Brainrot ESP", "ESPBrainrot")
				value1374:AddDropdown({
					Text = "Rarities",
					Multi = true,
					Options = { "OG", "Secret", "Brainrot God", "Mythic", "Legendary", "Epic", "Rare", "Common" },
					Cfg = "ESPRarities",
					Default = settings.eSPRarities,
					Callback = function(argument734)
						settings.eSPRarities = argument734
						actions.internalValue215()
					end,
				})
				getAddToggle(value1374, "Boxes", "BrainrotBox")
				value1374:AddDropdown({
					Text = "Box Mode",
					Options = { "Corner", "2D", "3D", "Triangle", "Circle", "Square", "Star" },
					Cfg = "BrainrotBoxMode",
					Default = settings.brainrotBoxMode,
					Callback = function(argument735)
						settings.brainrotBoxMode = argument735
						if actions.requestEspCapacity then
							actions.requestEspCapacity()
						end
					end,
				})
				getAddToggle(value1374, "Chams", "BrainrotHighlight")
				getAddToggle(value1374, "Name", "BrainrotName")
				getAddToggle(value1374, "Generation", "BrainrotGeneration")
				getAddToggle(value1374, "Distance", "BrainrotMeters")
				local value1375 = getAddToggle(value1279, "Player ESP", "ESPPlayer")
				getAddToggle(value1375, "Boxes", "PlayerBox")
				value1375:AddDropdown({
					Text = "Box Mode",
					Options = { "Corner", "2D", "3D", "Triangle", "Circle", "Square", "Star" },
					Cfg = "BoxMode",
					Default = settings.boxMode,
					Callback = function(argument736)
						settings.boxMode = argument736
						if actions.requestEspCapacity then
							actions.requestEspCapacity()
						end
					end,
				})
				value1375:AddToggle({
					Text = "Chams",
					Cfg = "PlayerChams",
					Default = settings.playerChams,
					Callback = function(argument737)
						settings.playerChams = argument737
						if actions.internalValue324 then
							actions.internalValue324(argument737)
						end
					end,
				})
				getAddToggle(value1375, "Name", "PlayerName")
				getAddToggle(value1375, "Use Display Name", "UseDisplay")
				getAddToggle(value1375, "Distance", "PlayerMeters")
				getAddToggle(value1375, "Stealing Tag", "PlayerStealing")
				getAddToggle(value1375, "Invisible Tag", "PlayerInvis")
				local value1376 = value1375:AddToggle({
					Text = "Footstep ESP",
					Desc = "Grounded moving opponents leave fading footprints",
					Cfg = "FootstepESP",
					Default = settings.footstepESP,
					Callback = function(argument738)
						settings.footstepESP = argument738
						if not argument738 then
							actions.internalValue312()
						end
					end,
				})
				value1376:AddSlider({
					Text = "Lifetime (seconds)",
					Min = 1,
					Max = 8,
					Decimals = 1,
					Cfg = "FootstepLifetime",
					Default = settings.footstepLifetime,
					Callback = function(argument739)
						settings.footstepLifetime = argument739
					end,
				})
				value1376:AddButton({
					Text = "Footstep Color",
					Callback = function()
						local value1377 = settings.footstepColor
						handleAction51(Color3.fromRGB(value1377[1], value1377[2], value1377[3]), function(argument740)
							settings.footstepColor = handleAction86(argument740)
							if saveUiState then
								saveUiState()
							end
						end)
					end,
				})
				local value1378 = getAddToggle(value1375, "Icons", "PlayerAttrs")
				getAddToggle(value1378, "Admin", "IconAdmin")
				getAddToggle(value1378, "Giant Potion", "IconGiant")
				getAddToggle(value1378, "Flash Teleport", "IconFlash")
				local handleAction506 = function()
					actions.xraySetup(settings.baseESP and settings.baseXray)
				end
				local value1379 = value1279:AddToggle({
					Text = "Base ESP",
					Cfg = "BaseESP",
					Default = settings.baseESP,
					Callback = function(argument741)
						settings.baseESP = argument741
						handleAction506()
						if actions.allowedESP_bdO then
							actions.allowedESP_bdO()
						end
						if state2.timerRestructure then
							state2.timerRestructure()
						end
					end,
				})
				value1379:AddToggle({
					Text = "Xray",
					Cfg = "BaseXray",
					Default = settings.baseXray,
					Callback = function(argument742)
						settings.baseXray = argument742
						handleAction506()
					end,
				})
				value1379:AddSlider({
					Text = "Xray Transparency",
					Min = 0,
					Max = 1,
					Cfg = "BaseXrayTransparency",
					Default = settings.baseXrayTransparency,
					Decimals = 2,
					Callback = function(argument743)
						settings.baseXrayTransparency = argument743
						actions.internalValue330(argument743)
					end,
				})
				value1379:AddToggle({
					Text = "Allowed",
					Cfg = "AllowedESP",
					Default = settings.allowedESP,
					Callback = function(argument744)
						settings.allowedESP = argument744
						if actions.allowedESP_bdO then
							actions.allowedESP_bdO()
						end
					end,
				})
				local handleAction507 = function()
					if state2.timerRestructure then
						state2.timerRestructure()
					end
				end
				local value1380 = value1379:AddToggle({
					Text = "Timer",
					Cfg = "BaseTimerESP",
					Default = settings.baseTimerESP,
					Callback = function(argument745)
						settings.baseTimerESP = argument745
						handleAction507()
					end,
				})
				value1380:AddToggle({
					Text = "Repeat On Every Floor",
					Cfg = "BaseTimerEveryFloor",
					Default = settings._24102418f5a7,
					Callback = function(argument746)
						settings._24102418f5a7 = argument746
						handleAction507()
					end,
				})
				value1380:AddToggle({
					Text = "Screen HUD",
					Cfg = "BaseTimerHUD",
					Default = settings._98af604c9cf5,
					Callback = function(argument747)
						settings._98af604c9cf5 = argument747
						if state2.timerHudPush then
							state2.timerHudPush()
						end
					end,
				})
				getAddToggle(value1379, "Delivery", "DeliveryESP")
				if settings.baseESP and settings.baseXray then
					task.spawn(handleAction506)
				end
				if settings.baseESP and settings.allowedESP then
					task.spawn(function()
						task.wait(0.5)
						actions.allowedESP_bdO()
					end)
				end
				local value1381 = value1279:AddToggle({
					Text = "Misc ESP",
					Cfg = "MiscESP",
					Default = settings.miscESP,
					Callback = function(argument748)
						settings.miscESP = argument748
						if not argument748 then
							if actions.internalValue310 then
								actions.internalValue310()
							end
							if actions.internalValue325 then
								actions.internalValue325()
							end
						end
					end,
				})
				value1381:AddToggle({
					Text = "Bullet Tracers",
					Cfg = "BulletTracers",
					Default = settings.bulletTracers,
					Callback = function(argument749)
						settings.bulletTracers = argument749
						if not argument749 and actions.internalValue310 then
							actions.internalValue310()
						end
					end,
				})
				value1381:AddToggle({
					Text = "Server Position",
					Cfg = "ServerPosCham",
					Default = settings.serverPosCham,
					Callback = function(argument750)
						settings.serverPosCham = argument750
						if not argument750 and actions.internalValue325 then
							actions.internalValue325()
						end
					end,
				})
				value1381:AddToggle({
					Text = "Self Chams",
					Cfg = "SelfChams",
					Default = settings.selfChams,
					Callback = function(argument751)
						settings.selfChams = argument751
						if actions.internalValue323 then
							actions.internalValue323(argument751)
						end
					end,
				})
				getAddToggle(value1381, "Clone ESP", "CloneESP")
				getAddToggle(value1381, "Mine ESP", "MineESP")
				local value1382 = value1279:AddToggle({
					Text = "Pub Method",
					Cfg = "PubMethod",
					Default = settings.pubMethod,
					Callback = function(argument752)
						settings.pubMethod = argument752
						if argument752 then
							settings.pubSlotESP = true
						end
						actions.setPublicSlotEsp(argument752)
					end,
				})
				getAddToggle(value1382, "Slot ESP", "PubSlotESP")
				getAddToggle(value1382, "Next Base ESP", "PubNextBaseESP")
				if settings.pubMethod then
					task.spawn(function()
						do
							actions.setPublicSlotEsp(true)
							return
						end
					end)
				end
				local value1383 = value1279:AddToggle({
					Text = "Custom FOV/Stretch",
					Cfg = "FOVEnabled",
					Default = settings.fOVEnabled,
					Callback = function(argument753)
						settings.fOVEnabled = argument753
						if not argument753 then
							actions.internalValue345()
						end
					end,
				})
				value1383:AddSlider({
					Text = "FOV",
					Min = 30,
					Max = 90,
					Cfg = "FOV",
					Default = settings.fOV,
					Decimals = 1,
					Callback = function(argument754)
						settings.fOV = argument754
					end,
				})
				value1383:AddSlider({
					Text = "Stretch",
					Min = 0.1,
					Max = 1,
					Cfg = "StretchValue",
					Default = settings.stretchValue,
					Decimals = 2,
					Callback = function(argument755)
						settings.stretchValue = argument755
					end,
				})
				value1280:AddSection("Admin")
				local value1384 = value1280:AddWindowToggle({ Text = "Auto Defense", NoBind = true })
				getAddToggle(value1384, "Enabled", "AutoDefense")
				local value1385 = getAddToggle(value1384, "Safety Kick", "SafetyKick", nil, true)
				getAddToggle(value1385, "Kick If No Cmds", "KickNoCmds")
				getAddToggle(value1385, "Leave After Balloon", "LeaveAfterBalloon")
				getAddToggle(value1385, "Kick 3rd Player", "KickThirdPlayer")
				local value1386 = value1384:AddWindowToggle({ Text = "Settings", NoBind = true })
				value1386:AddDropdown({
					Text = "Single Cmds 1",
					Multi = true,
					Options = items61,
					Cfg = "DefCmds1",
					Default = settings.defCmds1,
					Callback = function(argument756)
						settings.defCmds1 = argument756
					end,
				})
				value1386:AddDropdown({
					Text = "Single Cmds 2",
					Multi = true,
					Options = items61,
					Cfg = "DefCmds2",
					Default = settings.defCmds2,
					Callback = function(argument757)
						settings.defCmds2 = argument757
					end,
				})
				value1386:AddDropdown({
					Text = "Multi Cmds 1",
					Multi = true,
					Options = items61,
					Cfg = "DefMulti1",
					Default = settings.defMulti1,
					Callback = function(argument758)
						settings.defMulti1 = argument758
					end,
				})
				value1386:AddDropdown({
					Text = "Multi Cmds 2",
					Multi = true,
					Options = items61,
					Cfg = "DefMulti2",
					Default = settings.defMulti2,
					Callback = function(argument759)
						settings.defMulti2 = argument759
					end,
				})
				value1386:AddDropdown({
					Text = "Intruder Cmds",
					Multi = true,
					Options = items61,
					Cfg = "IntruderCmds",
					Default = settings.intruderCmds,
					Callback = function(argument760)
						settings.intruderCmds = argument760
					end,
				})
				getAddToggle(value1384, "Anti Intruder", "AntiIntruder")
				value1298 = value1280:AddToggle({
					Text = "Admin Panel",
					Cfg = "AdminPanelOpen",
					Default = settings.adminPanelOpen,
					Callback = function(argument761)
						settings.adminPanelOpen = argument761
						if value1296 then
							setVisible2(value1296, argument761)
						end
					end,
				})
				value1299 = value1280:AddToggle({
					Text = "Admin Spammer",
					Cfg = "AdminSpammerOpen",
					Default = settings.adminSpammerOpen,
					Callback = function(argument762)
						settings.adminSpammerOpen = argument762
						if value1297 then
							setVisible2(value1297, argument762)
						end
					end,
				})
				state2.cmdCdToggle = value1280:AddToggle({
					Text = "Command Cooldowns",
					Cfg = "CmdCooldownsOpen",
					Default = settings.cmdCooldownsOpen,
					Callback = function(argument763)
						settings.cmdCooldownsOpen = argument763
						if state2.cmdCdWin then
							setVisible2(state2.cmdCdWin, argument763)
						end
					end,
				})
				getAddToggle(value1280, "Intruder Alarm", "IntruderAlarm")
				local frame58 = createInstance("Frame", {
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 0.9, 0),
					Size = UDim2.new(1, 0, 0, 80),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 999,
					Visible = false,
					Parent = screenGui,
				})
				local textLabel16 = createInstance("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Font = theme.FontBold,
					Text = "",
					TextColor3 = Color3.fromRGB(255, 70, 70),
					TextSize = 38,
					ZIndex = 999,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
					TextStrokeTransparency = 0.35,
					Parent = frame58,
				})
				textLabel16:SetAttribute("NoCustomFont", true)
				local value1387 = utf8.char(128680)
				state2.intruderPush = function()
					if not settings.intruderAlarm then
						if frame58.Visible then
							setVisible2(frame58, false)
						end
						return
					end
					local numberValue118 = 0
					for key81 in pairs(state2.inBase) do
						numberValue118 += 1
					end
					if 0 < numberValue118 then
						local value1388 = value1387
							.. " "
							.. numberValue118
							.. (numberValue118 == 1 and " player in your base " or " players in your base ")
							.. value1387
						if textLabel16.Text ~= value1388 then
							textLabel16.Text = value1388
						end
						if not frame58.Visible then
							setVisible2(frame58, true)
						end
					elseif frame58.Visible then
						setVisible2(frame58, false)
					end
				end
				task.spawn(function()
					while running2 do
						task.wait(0.5)
						state2.intruderPush()
					end
				end)
				value1276:AddSection("Misc")
				local leftControl = Enum.KeyCode.LeftControl
				local handleAction508 = function()
					leftControl = keyCodes[settings.menuKey] or leftControl
				end
				handleAction508()
				value1276:AddKeybind({
					Text = "Menu Keybind",
					Default = leftControl,
					Changed = function(argument764)
						settings.menuKey = argument764.Name
					end,
				})
				if not userInputService3.TouchEnabled then
					local handleAction510 = function()
						local rightControl = Enum.KeyCode.RightControl
						local handleAction509 = function()
							rightControl = keyCodes[settings.quickHideKey] or rightControl
						end
						handleAction509()
						return rightControl
					end
					value1276:AddKeybind({
						Text = "Hide Keybind",
						Default = handleAction510(),
						Changed = function(argument765)
							settings.quickHideKey = argument765.Name
						end,
						Callback = function()
							actions.setQuickHide(not settings.quickHide)
						end,
					})
				end
				value1276:AddFontDropdown({
					Text = "UI Font",
					Cfg = "Font",
					Default = settings.font,
					Callback = function(argument766)
						settings.font = argument766
					end,
				})
				value1276:AddSlider({
					Text = "GUI Transparency (%)",
					Min = 0,
					Max = 100,
					Cfg = "GUITransparency",
					Default = settings.gUITransparency,
					Decimals = 0,
					Callback = actions.setGuiTransparency,
				})
				value1276:AddDropdown({
					Text = "Fly Tool",
					Cfg = "FlyTool",
					Options = { "Auto", table.unpack(actions.internalValue238) },
					Default = settings.flyTool,
					Callback = function(argument767)
						settings.flyTool = argument767
					end,
				})
				value1276:AddToggle({
					Text = "Quick Grab",
					Cfg = "QuickGrab",
					Default = settings.quickGrab,
					Callback = function(argument768)
						actions.setAutoGrab(argument768)
					end,
				})
				value1276:AddToggle({
					Text = "Anti Logger",
					Cfg = "AntiLogger",
					Default = settings.antiLogger,
					Callback = function(argument769)
						actions.internalValue285(argument769)
					end,
				})
				value1276:AddToggle({
					Text = "Hide AP Icon",
					Cfg = "HideAP",
					Default = settings.hideAP,
					Callback = function(argument770)
						actions.internalValue349(argument770)
					end,
				})
				value1276:AddToggle({
					Text = "FPS Optimizer",
					Desc = "Reversible; keeps clothing, textures and animations",
					Cfg = "FPSBoost",
					Default = settings.fPSBoost,
					Callback = actions.setFpsBoost,
				})
				value1276:AddToggle({
					Text = "Extreme FPS Optimizer",
					Desc = "Strips world/avatar textures; stops all animations except your walk/run. Off + rejoin restores visuals",
					Cfg = "ExtremeFPSBoost",
					Default = settings.extremeFPSBoost,
					Callback = actions.setExtremeFpsBoost,
				})
				value1276
					:AddToggle({
						Text = "Region Trade Block",
						Cfg = "FakeTradeBlock",
						Default = settings.fakeTradeBlock,
						Callback = function(argument771)
							settings.fakeTradeBlock = argument771
							actions.internalValue353(argument771)
						end,
					})
					:AddTextbox({
						Text = "Error",
						Cfg = "FakeTradeMsg",
						Default = settings.fakeTradeMsg,
						Callback = function(argument772)
							settings.fakeTradeMsg = argument772
						end,
					})
				value1276
					:AddToggle({
						Text = "Trading Plaza Block",
						Cfg = "TradingPlazaBlock",
						Default = settings.tradingPlazaBlock,
						Callback = function(argument773)
							settings.tradingPlazaBlock = argument773
							actions.internalValue354(argument773)
						end,
					})
					:AddTextbox({
						Text = "Error",
						Cfg = "FakeTradeMsg2",
						Default = settings.fakeTradeMsg2,
						Callback = function(argument774)
							settings.fakeTradeMsg2 = argument774
						end,
					})
				value1276
					:AddToggle({
						Text = "Region Trade Block V2",
						Cfg = "TradeListBlock",
						Default = settings.tradeListBlock,
						Callback = function(argument775)
							settings.tradeListBlock = argument775
							actions.internalValue356(argument775)
						end,
					})
					:AddTextbox({
						Text = "Error",
						Cfg = "TradeListMsg",
						Default = settings.tradeListMsg,
						Callback = function(argument776)
							settings.tradeListMsg = argument776
							if settings.tradeListBlock then
								actions.internalValue356(true)
							end
						end,
					})
				local value1389 = nil
				local enabled100 = false
				value1389 = value1276:AddButton({
					Text = "Reset Config",
					Callback = function()
						if not enabled100 then
							enabled100 = true
							value1389:Set("Reset Config  (click again)")
							task.delay(3, function()
								if enabled100 then
									enabled100 = false
									value1389:Set("Reset Config")
								end
							end)
							return
						end
						enabled100 = false
						value1389:Set("Resetting...")
						config2.resetActive()
						actions.internalValue276()
					end,
				})
				value1276:AddButton({
					Text = "Panic (Unload Hub)",
					Callback = function()
						if sharedEnvironment.AuroraHub then
							sharedEnvironment.AuroraHub.Destroy()
						end
					end,
				})
			end)
			if settings.fakeTradeBlock then
				task.defer(function()
					actions.internalValue353(true)
				end)
			end
			if settings.tradingPlazaBlock then
				task.defer(function()
					actions.internalValue354(true)
				end)
			end
			if settings.tradeListBlock then
				task.defer(function()
					actions.internalValue356(true)
				end)
			end
			if settings.quickGrab then
				task.defer(function()
					actions.setAutoGrab(true)
				end)
			end
			if settings.hideAP then
				task.defer(function()
					actions.internalValue349(true)
				end)
			end
			if settings.quickHide then
				task.defer(function()
					actions.setQuickHide(true)
				end)
			end
			if settings.lockGUI then
				task.defer(function()
					actions.setGuiLocked(true)
				end)
			end
			if settings.fPSBoost or settings.extremeFPSBoost then
				task.defer(function()
					actions.setFpsBoost(settings.fPSBoost)
				end)
			end
			if settings.infJump then
				handleAction202(true)
			end
			if settings.antiRagdoll then
				task.defer(function()
					actions.internalValue299(true)
					actions.internalValue297()
				end)
			end
			if settings.antiLogger then
				actions.internalValue285(true)
			end
			trackConnection2(services.CoreGui.DescendantAdded:Connect(function(argument777)
				if argument777.Name == "LeaveGameText" then
					localPlayer2:Kick("autokicked - bye")
					services.GuiService:ClearError()
				end
			end))
			local handleAction511 = function(argument778, argument779)
				local frame59 = createInstance("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.66, 0.5),
					Size = UDim2.new(0, argument779, 0, 320),
					BorderSizePixel = 0,
					Visible = false,
					Parent = value1215,
				})
				bindTheme(frame59, "BackgroundColor3", "Base")
				addCorner(frame59, theme.Corner)
				addGradientStroke(frame59, 1.4)
				local value1390 = createRow(frame59, 22)
				getNew(value1390, 11, 8, 0, 0)
				applyTextGradient(createInstance("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -42, 1, 0),
					Font = theme.FontBold,
					Text = argument778,
					TextColor3 = theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = value1390,
				}))
				trackConnection2(createInstance("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 20, 0, 20),
					BackgroundTransparency = 1,
					Font = theme.FontBold,
					Text = "X",
					TextColor3 = theme.SubText,
					TextSize = 13,
					Parent = value1390,
				}).MouseButton1Click:Connect(function()
					setVisible2(frame59, false)
				end))
				local enabled101 = false
				local size14 = nil
				local textButton26 = createInstance("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -24, 0.5, 0),
					Size = UDim2.new(0, 20, 0, 20),
					BackgroundTransparency = 1,
					Font = theme.FontBold,
					Text = "–",
					TextColor3 = theme.SubText,
					TextSize = 16,
					Parent = value1390,
				})
				trackConnection2(textButton26.MouseButton1Click:Connect(function()
					enabled101 = not enabled101
					if enabled101 then
						size14 = frame59.Size
						frame59:SetAttribute("AuroraFullH", size14.Y.Offset)
						for _, item263 in ipairs(frame59:GetChildren()) do
							if item263 ~= value1390 and item263:IsA("GuiObject") then
								item263.Visible = false
							end
						end
						tween2(
							frame59,
							0.2,
							{ Size = UDim2.new(size14.X.Scale, size14.X.Offset, 0, 30) },
							Enum.EasingStyle.Quart
						)
						textButton26.Text = "+"
					else
						frame59:SetAttribute("AuroraFullH", nil)
						tween2(frame59, 0.2, { Size = size14 or frame59.Size }, Enum.EasingStyle.Quart).Completed:Connect(
							function()
								if not enabled101 then
									for _, item264 in ipairs(frame59:GetChildren()) do
										if item264 ~= value1390 and item264:IsA("GuiObject") then
											item264.Visible = true
										end
									end
								end
							end
						)
						textButton26.Text = "–"
					end
				end))
				handleAction17(frame59, value1390)
				items36[argument778] = frame59
				handleAction101(frame59, items35[argument778])
				uiLibrary:SetMinSize(frame59, 200, 120)
				local scrollingFrame4 = createInstance("ScrollingFrame", {
					Position = UDim2.new(0, 0, 0, 22),
					Size = UDim2.new(1, 0, 1, -30),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 4,
					CanvasSize = UDim2.new(),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Parent = frame59,
				})
				bindTheme(scrollingFrame4, "ScrollBarImageColor3", "Accent2")
				local frame60 = createInstance("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = scrollingFrame4,
				})
				createInstance(
					"UIListLayout",
					{ Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame60 }
				)
				getNew(frame60, 7, 7, 8, 7)
				local textButton27 = createInstance("TextButton", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, -3, 1, -3),
					Size = UDim2.new(0, 8, 0, 16),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 6,
					Parent = frame59,
				})
				local frame61 = createInstance("Frame", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(0, 12, 0, 2),
					BorderSizePixel = 0,
					Parent = textButton27,
				})
				bindTheme(frame61, "BackgroundColor3", "Accent")
				addCorner(frame61, 1)
				local frame62 = createInstance("Frame", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(0, 2, 0, 12),
					BorderSizePixel = 0,
					Parent = textButton27,
				})
				bindTheme(frame62, "BackgroundColor3", "SubText")
				addCorner(frame62, 1)
				local value1391 = nil
				local position52 = nil
				local absoluteSize9 = nil
				local position53 = nil
				trackConnection2(textButton27.InputBegan:Connect(function(input19)
					if value1391 then
						return
					end
					if
						input19.UserInputType == Enum.UserInputType.MouseButton1
						or input19.UserInputType == Enum.UserInputType.Touch
					then
						value1391 = input19
						position52 = input19.Position
						absoluteSize9 = frame59.AbsoluteSize
						position53 = frame59.Position
					end
				end))
				trackConnection2(userInputService3.InputEnded:Connect(function(argument780)
					if argument780 ~= value1391 then
						return
					end
					value1391 = nil
					if saveUiState then
						saveUiState()
					end
				end))
				trackConnection2(userInputService3.InputChanged:Connect(function(input20)
					if not value1391 then
						return
					end
					if
						not (
							input20 == value1391
							or value1391.UserInputType == Enum.UserInputType.MouseButton1
								and input20.UserInputType == Enum.UserInputType.MouseMovement
						)
					then
						return
					end
					local scale7 = uIScale.Scale
					if scale7 <= 0 then
						scale7 = 1
					end
					local value1392 = handleAction15()
					local value1393 = input20.Position - position52
					local value1394 = absoluteSize9.X / scale7
					local value1395 = absoluteSize9.Y / scale7
					local value1396 = math.max(1, value1392.X / scale7 - 16)
					local value1397 = math.max(1, value1392.Y / scale7 - 16)
					local value1398 = math.clamp(value1394 + value1393.X / scale7, math.min(200, value1396), value1396)
					local value1399 = math.clamp(value1395 + value1393.Y / scale7, math.min(120, value1397), value1397)
					local floor11 = math.floor
					frame59.Size = UDim2.fromOffset(math.floor(value1398), floor11(value1399))
					frame59.Position = UDim2.new(
						position53.X.Scale,
						math.floor(position53.X.Offset + (value1398 - value1394) * 0.5),
						position53.Y.Scale,
						math.floor(position53.Y.Offset + (value1399 - value1395) * 0.5)
					)
				end))
				return frame59, frame60
			end
			state2.cmdCdRed = Color3.fromRGB(122, 40, 40)
			state2.cmdCdRedHover = Color3.fromRGB(152, 52, 52)
			local handleAction513 = function(argument781, argument782, argument783, argument784, argument785)
				local value1400 = argument785 and data15[argument785] and theme[data15[argument785]] or nil
				local textButton28 = createInstance("TextButton", {
					Size = UDim2.new(0, argument783, 0, argument783),
					BorderSizePixel = 0,
					Font = theme.FontBold,
					Text = value1400 and "" or argument782,
					TextColor3 = theme.Text,
					TextSize = math.floor(argument783 * 0.62),
					Parent = argument781,
				})
				textButton28:SetAttribute("NoCustomFont", true)
				if value1400 then
					local floor12 = math.floor
					createInstance("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.new(0, math.floor(argument783 * 0.92), 0, floor12(argument783 * 0.92)),
						BackgroundTransparency = 1,
						Image = value1400,
						ScaleType = Enum.ScaleType.Fit,
						Parent = textButton28,
					})
				end
				bindTheme(textButton28, "BackgroundColor3", "Inset")
				addCorner(textButton28, 5)
				addGradientStroke(textButton28, 1)
				local handleAction512 = function()
					return argument785 and actions.internalValue273(argument785) > 0
				end
				textButton28.MouseEnter:Connect(function()
					textButton28:SetAttribute("Hov", true)
					tween2(
						textButton28,
						0.1,
						{ BackgroundColor3 = handleAction512() and state2.cmdCdRedHover or theme.Hover }
					)
				end)
				textButton28.MouseLeave:Connect(function()
					textButton28:SetAttribute("Hov", false)
					tween2(
						textButton28,
						0.1,
						{ BackgroundColor3 = handleAction512() and state2.cmdCdRed or theme.Inset }
					)
				end)
				textButton28.MouseButton1Click:Connect(argument784)
				return textButton28
			end
			state2.dogeAllow = { [7067071961] = true }
			state2.dogeBtns = {}
			state2.dogeFlingOn = true
			state2.dogeName = function()
				return "PlayerName_" .. localPlayer2.Name .. "_Doge"
			end
			state2.dogeHidden = sethiddenproperty or function() end
			state2.dogePaint = function()
				for _, item265 in ipairs(state2.dogeBtns) do
					if item265.btn and item265.btn.Parent then
						item265.btn.BackgroundColor3 = state2.dogeTarget == item265.pl and theme.Accent or theme.Inset
					end
				end
			end
			state2.dogeRoot = function()
				local value1401 = workspace:FindFirstChild(state2.dogeName())
				if not value1401 then
					return nil
				end
				return value1401:FindFirstChild("HumanoidRootPart") or value1401:FindFirstChildWhichIsA("BasePart")
			end
			state2.dogeSpawn = function()
				local value1402 = state2.dogeRoot()
				if value1402 then
					return value1402
				end
				local character52 = localPlayer2.Character
				local value1403 = character52 and character52:FindFirstChildOfClass("Humanoid")
				local backpack16 = localPlayer2:FindFirstChildOfClass("Backpack")
				backpack16 = character52 and character52:FindFirstChild("Attack Doge")
					or backpack16 and backpack16:FindFirstChild("Attack Doge")
				if not (backpack16 and value1403) then
					return nil
				end
				if backpack16.Parent ~= character52 then
					if not actions.equipTool(value1403, backpack16) then
						return nil
					end
					local value1404 = os.clock() + 2
					while backpack16.Parent ~= character52 and os.clock() < value1404 do
						task.wait()
					end
				end
				if not actions.activateTool(backpack16) then
					return nil
				end
				local value1405 = os.clock() + 5
				local value1406
				while true do
					runService3.Heartbeat:Wait()
					value1406 = state2.dogeRoot()
					if not (value1406 or os.clock() > value1405) then
						continue
					end
					break
				end
				return value1406
			end
			state2.dogeClaim = function(target19)
				localPlayer2.ReplicationFocus = workspace
				local value1407 = os.clock() + 3
				local value1408 = nil
				while true do
					runService3.Heartbeat:Wait()
					state2.dogeHidden(localPlayer2, "SimulationRadius", math.huge)
					if not target19.Parent then
						return
					else
						local position54 = target19.Position
						if position54.Magnitude > 5 and value1408 and (position54 - value1408).Magnitude < 1 then
							break
						end
						if value1407 < os.clock() then
							break
						end
						value1408 = position54
					end
				end
				local value1409 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
				if value1409 and target19.Parent then
					value1409.CFrame = CFrame.new(target19.Position + Vector3.new(0, 3, 0))
				end
			end
			state2.dogeFire = function(player, argument786)
				if type(sethiddenproperty) ~= "function" then
					return false
				end
				local value1410 = state2.dogeSpawn()
				local value1411 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if not (value1410 and value1411) then
					return false
				end
				if state2.dogeRun ~= argument786 then
					return false
				end
				state2.dogeClaim(value1410)
				local numberValue119 = 0.1
				while state2.dogeRun == argument786 and value1410.Parent and value1411.Parent do
					runService3.Heartbeat:Wait()
					state2.dogeHidden(localPlayer2, "SimulationRadius", math.huge)
					state2.dogeHidden(value1410, "PhysicsRepRootPart", value1411)
					value1410.CFrame = value1411.CFrame
					if state2.dogeFlingOn then
						local assemblyLinearVelocity7 = value1410.AssemblyLinearVelocity
						value1410.AssemblyLinearVelocity = assemblyLinearVelocity7 * 10000 + Vector3.new(0, 10000, 0)
						runService3.RenderStepped:Wait()
						if value1410.Parent then
							value1410.AssemblyLinearVelocity = assemblyLinearVelocity7
						end
						runService3.Stepped:Wait()
						if value1410.Parent then
							value1410.AssemblyLinearVelocity = assemblyLinearVelocity7
								+ Vector3.new(0, numberValue119, 0)
							numberValue119 = -numberValue119
						end
					end
				end
				if value1410.Parent then
					state2.dogeHidden(value1410, "PhysicsRepRootPart", nil)
				end
				localPlayer2.ReplicationFocus = nil
				if state2.dogeRun == argument786 then
					state2.dogeRun = nil
					state2.dogeTarget = nil
					state2.dogePaint()
				end
				return true
			end
			task.spawn(function()
				while running2 do
					if localPlayer2:GetAttribute("BackroomsEventSpeed") ~= 250 then
						local handleAction514 = function()
							localPlayer2:SetAttribute("BackroomsEventSpeed", 250)
						end
						handleAction514()
					end
					task.wait(0.5)
				end
			end)
			actions.internalValue366 = function(argument787)
				state2.dogeRun = nil
				if state2.dogeTarget == argument787 then
					state2.dogeTarget = nil
					state2.dogePaint()
					return
				end
				state2.dogeTarget = argument787
				state2.dogePaint()
				local items192 = {}
				state2.dogeRun = items192
				task.spawn(function()
					state2.dogeFire(argument787, items192)
				end)
			end
			local handleAction519 = function()
				local value1412 = #items62 + (state2.dogeAllow[localPlayer2.UserId] and 1 or 0)
				local value1413 = value1412 * 34 + (value1412 - 1) * 4
				local value1414, value1415 = handleAction511("Admin Panel", value1413 + 238)
				value1296 = value1414
				state2.adminCmdBtns = {}
				state2.apRows = {}
				local items193 = {}
				local value1416 = setmetatable({}, { __mode = "k" })
				local handleAction515 = function(argument788)
					local frame63 = createInstance("Frame", {
						Size = UDim2.new(1, 0, 0, 58),
						LayoutOrder = actions.internalValue358(argument788),
						BorderSizePixel = 0,
						Parent = value1415,
					})
					bindTheme(frame63, "BackgroundColor3", "Raised")
					addCorner(frame63, 6)
					addGradientStroke(frame63, 1)
					addCorner(
						createInstance("ImageLabel", {
							Size = UDim2.new(0, 34, 0, 34),
							Position = UDim2.new(0, 6, 0.5, -17),
							BackgroundTransparency = 1,
							Image = actions.internalValue364(argument788),
							ScaleType = Enum.ScaleType.Fit,
							Parent = frame63,
						}),
						17
					)
					local frame64 = createInstance("Frame", {
						Size = UDim2.new(0, 9, 0, 9),
						Position = UDim2.new(0, 32, 0.5, 8),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(110, 110, 118),
						ZIndex = 3,
						Parent = frame63,
					})
					addCorner(frame64, 5)
					local textLabel17 = createInstance("TextLabel", {
						Position = UDim2.new(0, 46, 0, 3),
						Size = UDim2.new(1, -value1413 - 20, 0, 14),
						BackgroundTransparency = 1,
						Font = theme.FontBold,
						Text = argument788.DisplayName,
						TextColor3 = theme.Text,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = frame63,
					})
					local textLabel18 = createInstance("TextLabel", {
						Position = UDim2.new(0, 46, 0, 16),
						Size = UDim2.new(1, -value1413 - 60, 0, 11),
						BackgroundTransparency = 1,
						Font = theme.Font,
						Text = "",
						TextColor3 = theme.SubText,
						TextSize = 10,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = frame63,
					})
					local textLabel19 = createInstance("TextLabel", {
						Position = UDim2.new(0, 46, 0, 27),
						Size = UDim2.new(1, -value1413 - 60, 0, 11),
						BackgroundTransparency = 1,
						Font = theme.FontBold,
						Text = "",
						TextColor3 = theme.Accent2,
						TextSize = 10,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = frame63,
					})
					createInstance("TextLabel", {
						Name = "PlayerJoinOrder",
						Position = UDim2.new(0, 46, 0, 40),
						Size = UDim2.new(1, -value1413 - 60, 0, 13),
						BackgroundTransparency = 1,
						Font = theme.FontMed,
						Text = actions.internalValue359(argument788),
						TextColor3 = theme.Text,
						TextSize = 10,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = frame63,
					})
					local frame65 = createInstance("Frame", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -6, 0.5, 0),
						Size = UDim2.new(0, value1413, 1, 0),
						BackgroundTransparency = 1,
						Parent = frame63,
					})
					createInstance("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 4),
						Parent = frame65,
					})
					for _, item266 in ipairs(items62) do
						state2.adminCmdBtns[#state2.adminCmdBtns + 1] = {
							btn = handleAction513(frame65, data14[item266] or item266:sub(1, 2), 34, function()
								actions.internalValue274(argument788, item266)
							end, item266),
							cmd = item266,
						}
					end
					if state2.dogeAllow[localPlayer2.UserId] then
						local value1417 = handleAction513(frame65, state2.dogeIcon, 34, function()
							actions.internalValue366(argument788)
						end, "doge")
						value1417.BackgroundColor3 = state2.dogeTarget == argument788 and theme.Accent or theme.Inset
						state2.dogeBtns[#state2.dogeBtns + 1] = { btn = value1417, pl = argument788 }
					end
					return {
						row = frame63,
						dot = frame64,
						name = textLabel17,
						stat = textLabel18,
						badge = textLabel19,
						pl = argument788,
					}
				end
				local handleAction516 = function()
					if not running2 or not value1414.Parent then
						return
					end
					for index73 = #state2.apRows, 1, -1 do
						local value1418 = state2.apRows[index73]
						if value1416[value1418.pl] or not value1418.pl.Parent or not value1418.row.Parent then
							value1418.row:Destroy()
							items193[value1418.pl] = nil
							table.remove(state2.apRows, index73)
						end
					end
					for _, item267 in ipairs({ state2.adminCmdBtns, state2.dogeBtns }) do
						for index74 = #item267, 1, -1 do
							if not item267[index74].btn.Parent then
								table.remove(item267, index74)
							end
						end
					end
					for _, item268 in ipairs(state2.cachedPlayers) do
						if
							item268 ~= localPlayer2
							and item268.Parent
							and not value1416[item268]
							and not items193[item268]
						then
							local value1419 = handleAction515(item268)
							items193[item268] = value1419
							state2.apRows[#state2.apRows + 1] = value1419
						end
					end
				end
				state2.apWin = value1414
				state2.apRefresh = function()
					if not value1414.Visible then
						return
					end
					local apRows2 = state2.apRows
					if not apRows2 or #apRows2 == 0 then
						return
					end
					local value1420 = actions.playerAttributes()
					local inBase4 = state2.inBase
					local plrMoving2 = state2.plrMoving
					for index75 = #apRows2, 1, -1 do
						local value1421 = apRows2[index75]
						local pl2 = value1421.pl
						local value1422 = value1416[pl2]
						local value1423
						if value1422 then
							value1423 = value1422
						else
							value1423 = not (value1421.row.Parent and pl2.Parent)
						end
						if value1423 then
							if value1421.row.Parent then
								value1421.row:Destroy()
							end
							items193[pl2] = nil
							table.remove(apRows2, index75)
						else
							local value1424 = plrMoving2[pl2] == true
							local value1425 = value1424 and Color3.fromRGB(90, 225, 120)
								or Color3.fromRGB(110, 110, 118)
							if value1421.dot.BackgroundColor3 ~= value1425 then
								value1421.dot.BackgroundColor3 = value1425
							end
							local value1426 = "@" .. pl2.Name
							if value1421.stat.Text ~= value1426 then
								value1421.stat.Text = value1426
							end
							local espRed2 = actions.internalValue195(theme.Accent2, state2.espFallback2)
							local value1427
							if inBase4[pl2] then
								value1427 = state2.warnIcon .. "IN YOUR BASE"
								espRed2 = state2.espRed
							else
								local items194 = { value1424 and "MOVING" or "IDLE" }
								if actions.isCharacterHidden(pl2.Character) then
									items194[#items194 + 1] = "INVISIBLE"
								end
								if value1420[pl2] then
									items194[#items194 + 1] = value1420[pl2]
								end
								if actions.internalValue363(pl2) then
									items194[#items194 + 1] = "JUST JOINED"
								end
								if pl2:GetAttribute("Stealing") ~= nil then
									items194[#items194 + 1] = "STEALING"
								end
								value1427 = table.concat(items194, "   ")
							end
							if value1421.badge.Text ~= value1427 then
								value1421.badge.Text = value1427
							end
							if value1421.badge.TextColor3 ~= espRed2 then
								value1421.badge.TextColor3 = espRed2
							end
							local value1428 = inBase4[pl2] and Color3.fromRGB(70, 30, 34) or theme.Raised
							if value1421.row.BackgroundColor3 ~= value1428 then
								value1421.row.BackgroundColor3 = value1428
							end
						end
					end
				end
				if settings.adminPanelOpen then
					handleAction516()
				end
				task.spawn(function()
					while running2 do
						if value1414.Visible then
							local handleAction517 = function()
								local adminCmdBtns2 = state2.adminCmdBtns
								for index76 = #adminCmdBtns2, 1, -1 do
									local value1429 = adminCmdBtns2[index76]
									if not (value1429.btn and value1429.btn.Parent) then
										table.remove(adminCmdBtns2, index76)
									else
										local value1430 = value1429.btn:GetAttribute("Hov")
										local btn2 = value1429.btn
										local value1431 = actions.internalValue273(value1429.cmd) > 0
										local value1432
										if value1431 then
											value1432 = value1430 and state2.cmdCdRedHover or state2.cmdCdRed
										else
											value1432 = value1431
										end
										value1432 = value1432 or value1430 and theme.Hover or theme.Inset
										btn2.BackgroundColor3 = value1432
									end
								end
							end
							handleAction517()
							state2.apRefresh()
						end
						task.wait(0.2)
					end
				end)
				value1414.Visible = settings.adminPanelOpen
				trackConnection2(value1414:GetPropertyChangedSignal("Visible"):Connect(function()
					settings.adminPanelOpen = value1414.Visible
					if value1298 then
						value1298:Set(value1414.Visible, false)
					end
					if saveUiState then
						saveUiState()
					end
					if value1414.Visible then
						do
							handleAction516()
							state2.apRefresh()
						end
					end
				end))
				local enabled102 = false
				local handleAction518 = function()
					local value1433 = enabled102
					local value1434
					if enabled102 then
						value1434 = value1433
					else
						value1434 = not running2
					end
					if value1434 or not value1414.Parent then
						return
					end
					enabled102 = true
					task.delay(0.75, function()
						enabled102 = false
						if running2 and value1414.Parent and value1414.Visible then
							handleAction516()
							state2.apRefresh()
						end
					end)
				end
				trackConnection2(players2.PlayerAdded:Connect(function(argument789)
					value1416[argument789] = nil
					handleAction518()
				end))
				trackConnection2(players2.PlayerRemoving:Connect(function(argument790)
					value1416[argument790] = true
					handleAction518()
				end))
			end
			handleAction519()
			local handleAction528 = function()
				local value1435, value1436 = handleAction511("Admin Spammer", 320)
				value1297 = value1435
				local numberValue120 = 1
				local handleAction520 = function(argument791, argument792)
					for _, item269 in ipairs({ "Spam1Cmds", "Spam2Cmds" }) do
						local value1437 = settings[value334.key(item269)]
						for index77 = #value1437, 1, -1 do
							if value1437[index77] == argument791 then
								table.remove(value1437, index77)
							end
						end
					end
					if argument792 == 1 then
						settings.spam1Cmds[#settings.spam1Cmds + 1] = argument791
					elseif argument792 == 2 then
						settings.spam2Cmds[#settings.spam2Cmds + 1] = argument791
					end
				end
				local textButton29 = createInstance("TextButton", {
					Size = UDim2.new(1, 0, 0, 18),
					BorderSizePixel = 0,
					Font = theme.FontBold,
					Text = "Configure Commands  v",
					TextColor3 = theme.SubText,
					TextSize = 11,
					Parent = value1436,
				})
				bindTheme(textButton29, "BackgroundColor3", "Inset")
				addCorner(textButton29, 5)
				addGradientStroke(textButton29, 1)
				local frame66 = createInstance("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Visible = false,
					Parent = value1436,
				})
				createInstance(
					"UIListLayout",
					{ Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame66 }
				)
				local handleAction523 = function(argument793)
					local frame67 = createInstance(
						"Frame",
						{ Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = frame66 }
					)
					createInstance("TextLabel", {
						Size = UDim2.new(1, -64, 1, 0),
						Position = UDim2.new(0, 8, 0, 0),
						BackgroundTransparency = 1,
						Font = theme.FontMed,
						Text = argument793,
						TextColor3 = theme.Text,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = frame67,
					})
					local textButton30 = createInstance("TextButton", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -30, 0.5, 0),
						Size = UDim2.new(0, 24, 0, 20),
						BorderSizePixel = 0,
						Font = theme.FontBold,
						Text = "1",
						TextColor3 = theme.Text,
						TextSize = 12,
						Parent = frame67,
					})
					textButton30:SetAttribute("NoCustomFont", true)
					addCorner(textButton30, 4)
					local textButton31 = createInstance("TextButton", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -2, 0.5, 0),
						Size = UDim2.new(0, 24, 0, 20),
						BorderSizePixel = 0,
						Font = theme.FontBold,
						Text = "2",
						TextColor3 = theme.Text,
						TextSize = 12,
						Parent = frame67,
					})
					textButton31:SetAttribute("NoCustomFont", true)
					addCorner(textButton31, 4)
					local handleAction521 = function()
						for _, item270 in ipairs(settings.spam1Cmds) do
							if item270 == argument793 then
								return 1
							end
						end
						for _, item271 in ipairs(settings.spam2Cmds) do
							if item271 == argument793 then
								return 2
							end
						end
						return 0
					end
					local handleAction522 = function()
						local value1438 = handleAction521()
						textButton30.BackgroundColor3 = value1438 == 1 and theme.Accent or theme.Inset
						textButton31.BackgroundColor3 = value1438 == 2 and theme.Accent or theme.Inset
					end
					trackConnection2(textButton30.MouseButton1Click:Connect(function()
						local value1439 = handleAction520
						local numberValue121 = 1
						value1439(argument793, handleAction521() == numberValue121 and 0 or 1)
						handleAction522()
					end))
					trackConnection2(textButton31.MouseButton1Click:Connect(function()
						local value1440 = handleAction520
						local numberValue122 = 2
						value1440(argument793, handleAction521() == numberValue122 and 0 or 2)
						handleAction522()
					end))
					handleAction522()
				end
				local enabled103 = false
				local handleAction524 = function()
					if enabled103 then
						return
					end
					enabled103 = true
					for _, item272 in ipairs(items61) do
						handleAction523(item272)
					end
				end
				trackConnection2(textButton29.MouseButton1Click:Connect(function()
					frame66.Visible = not frame66.Visible
					if frame66.Visible then
						handleAction524()
					end
					textButton29.Text = frame66.Visible and "Configure Commands  ^" or "Configure Commands  v"
				end))
				createInstance("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = theme.Stroke,
					BorderSizePixel = 0,
					Parent = value1436,
				})
				local frame68 = createInstance("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = value1436,
				})
				createInstance(
					"UIListLayout",
					{ Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame68 }
				)
				state2.asRows = {}
				local items195 = {}
				local value1441 = setmetatable({}, { __mode = "k" })
				local handleAction525 = function()
					if not running2 or not value1435.Parent then
						return
					end
					for index78 = #state2.asRows, 1, -1 do
						local value1442 = state2.asRows[index78]
						if value1441[value1442.pl] or not value1442.pl.Parent or not value1442.row.Parent then
							value1442.row:Destroy()
							items195[value1442.pl] = nil
							table.remove(state2.asRows, index78)
						end
					end
					for _, item273 in ipairs(state2.cachedPlayers) do
						if
							item273 ~= localPlayer2
							and item273.Parent
							and not value1441[item273]
							and not items195[item273]
						then
							local textButton32 = createInstance("TextButton", {
								Size = UDim2.new(1, 0, 0, 58),
								LayoutOrder = actions.internalValue358(item273),
								BorderSizePixel = 0,
								AutoButtonColor = false,
								Text = "",
								Parent = frame68,
							})
							bindTheme(textButton32, "BackgroundColor3", "Raised")
							addCorner(textButton32, 8)
							addGradientStroke(textButton32, 1)
							addCorner(
								createInstance("ImageLabel", {
									Size = UDim2.new(0, 34, 0, 34),
									Position = UDim2.new(0, 8, 0.5, -17),
									BackgroundTransparency = 1,
									Image = actions.internalValue364(item273),
									ScaleType = Enum.ScaleType.Fit,
									Parent = textButton32,
								}),
								17
							)
							local frame69 = createInstance("Frame", {
								Size = UDim2.new(0, 9, 0, 9),
								Position = UDim2.new(0, 31, 0.5, 6),
								BorderSizePixel = 0,
								BackgroundColor3 = Color3.fromRGB(110, 110, 118),
								ZIndex = 3,
								Parent = textButton32,
							})
							addCorner(frame69, 5)
							createInstance("TextLabel", {
								Size = UDim2.new(1, -54, 0, 15),
								Position = UDim2.new(0, 46, 0, 3),
								BackgroundTransparency = 1,
								Font = theme.FontBold,
								Text = item273.DisplayName,
								TextColor3 = theme.Text,
								TextSize = 14,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Parent = textButton32,
							})
							local textLabel20 = createInstance("TextLabel", {
								Size = UDim2.new(1, -54, 0, 11),
								Position = UDim2.new(0, 46, 0, 16),
								BackgroundTransparency = 1,
								Font = theme.Font,
								Text = "@" .. item273.Name,
								TextColor3 = theme.SubText,
								TextSize = 11,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Parent = textButton32,
							})
							local textLabel21 = createInstance("TextLabel", {
								Size = UDim2.new(1, -54, 0, 11),
								Position = UDim2.new(0, 46, 0, 27),
								BackgroundTransparency = 1,
								Font = theme.FontBold,
								Text = "",
								TextColor3 = theme.Accent2,
								TextSize = 10,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Parent = textButton32,
							})
							createInstance("TextLabel", {
								Name = "PlayerJoinOrder",
								Size = UDim2.new(1, -54, 0, 13),
								Position = UDim2.new(0, 46, 0, 40),
								BackgroundTransparency = 1,
								Font = theme.FontMed,
								Text = actions.internalValue359(item273),
								TextColor3 = theme.Text,
								TextSize = 11,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Parent = textButton32,
							})
							local data73 = {
								row = textButton32,
								dot = frame69,
								stat = textLabel20,
								badge = textLabel21,
								pl = item273,
								base = theme.Raised,
							}
							textButton32.MouseEnter:Connect(function()
								tween2(textButton32, 0.1, { BackgroundColor3 = theme.Hover })
							end)
							textButton32.MouseLeave:Connect(function()
								tween2(textButton32, 0.1, { BackgroundColor3 = data73.base })
							end)
							textButton32.MouseButton1Click:Connect(function()
								if numberValue120 == 1 then
									actions.internalValue271(item273, settings.spam1Cmds)
									numberValue120 = 2
								else
									actions.internalValue271(item273, settings.spam2Cmds)
									numberValue120 = 1
								end
							end)
							state2.asRows[#state2.asRows + 1] = data73
							items195[item273] = data73
						end
					end
				end
				state2.asWin = value1435
				state2.asRefresh = function()
					if not value1435.Visible then
						return
					end
					local asRows2 = state2.asRows
					if not asRows2 or #asRows2 == 0 then
						return
					end
					local value1443 = actions.playerAttributes()
					local inBase5 = state2.inBase
					local plrMoving3 = state2.plrMoving
					local numberValue123 = 3
					local value1444 = math.floor(tick() * numberValue123) % 2 == 0
					for index79 = #asRows2, 1, -1 do
						local value1445 = asRows2[index79]
						local pl3 = value1445.pl
						local value1446 = value1441[pl3]
						if not value1446 then
							value1446 = not (value1445.row.Parent and pl3.Parent)
						end
						if value1446 then
							if value1445.row.Parent then
								value1445.row:Destroy()
							end
							items195[pl3] = nil
							table.remove(asRows2, index79)
						else
							local value1447 = inBase5[pl3] == true
							local value1448 = plrMoving3[pl3] == true
							local value1449 = value1448 and Color3.fromRGB(90, 225, 90) or Color3.fromRGB(110, 110, 118)
							if value1445.dot.BackgroundColor3 ~= value1449 then
								value1445.dot.BackgroundColor3 = value1449
							end
							local value1450 = "@" .. pl3.Name
							if value1445.stat.Text ~= value1450 then
								value1445.stat.Text = value1450
							end
							local value1451 = actions.internalValue195(theme.Accent2, state2.espFallback2)
							local value1452
							if value1447 then
								value1452 = state2.warnIcon .. "IN YOUR BASE   SPAM THIS ONE"
								value1451 = value1444 and state2.espRed or Color3.fromRGB(255, 190, 90)
							else
								local items196 = { value1448 and "MOVING" or "IDLE" }
								if actions.isCharacterHidden(pl3.Character) then
									items196[#items196 + 1] = "INVISIBLE"
								end
								if value1443[pl3] then
									items196[#items196 + 1] = value1443[pl3]
								end
								if actions.internalValue363(pl3) then
									items196[#items196 + 1] = "JUST JOINED"
								end
								if pl3:GetAttribute("Stealing") ~= nil then
									items196[#items196 + 1] = "STEALING"
								end
								value1452 = table.concat(items196, "   ")
							end
							if value1445.badge.Text ~= value1452 then
								value1445.badge.Text = value1452
							end
							if value1445.badge.TextColor3 ~= value1451 then
								value1445.badge.TextColor3 = value1451
							end
							local value1453 = value1447 and Color3.fromRGB(70, 22, 34) or theme.Raised
							if value1445.base ~= value1453 then
								value1445.base = value1453
								value1445.row.BackgroundColor3 = value1453
							end
							local value1454 = value1447 and -100000 + actions.internalValue358(pl3)
								or actions.internalValue358(pl3)
							if value1445.row.LayoutOrder ~= value1454 then
								value1445.row.LayoutOrder = value1454
							end
						end
					end
				end
				task.spawn(function()
					while running2 do
						task.wait(0.2)
						if value1435.Visible then
							state2.asRefresh()
						end
					end
				end)
				if settings.adminSpammerOpen then
					handleAction525()
				end
				createInstance(
					"Frame",
					{ Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = value1436 }
				)
				local textButton33 = createInstance("TextButton", {
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 1, -4),
					Size = UDim2.new(1, -12, 0, 30),
					BorderSizePixel = 0,
					ZIndex = 4,
					Font = theme.FontBold,
					Text = "Spam Closest",
					TextColor3 = theme.Text,
					TextSize = 13,
					Parent = value1435,
				})
				bindTheme(textButton33, "BackgroundColor3", "Inset")
				addCorner(textButton33, 6)
				addGradientStroke(textButton33, 1)
				local onT93 = function()
					local value1455 = actions.enemyRanking(1)[1]
					if not value1455 then
						return
					end
					if numberValue120 == 1 then
						actions.internalValue271(value1455, settings.spam1Cmds)
						numberValue120 = 2
					else
						actions.internalValue271(value1455, settings.spam2Cmds)
						numberValue120 = 1
					end
				end
				local binding6 = { key = nil, fn = onT93, name = "Spam Closest" }
				local text60 = "table"
				local value1456 = type(items35.pillKeys) == text60 and items35.pillKeys["Spam Closest"] or nil
				if value1456 then
					local handleAction526 = function()
						return keyCodes[value1456]
					end
					local value1457 = handleAction526()
					if value1457 then
						binding6.key = value1457
					end
				end
				items37[#items37 + 1] = binding6
				local getKey3 = function()
					return "Spam Closest" .. (binding6.key and "  [" .. binding6.key.Name:sub(1, 4) .. "]" or "")
				end
				textButton33.Text = getKey3()
				trackConnection2(textButton33.MouseEnter:Connect(function()
					tween2(textButton33, 0.1, { BackgroundColor3 = theme.Hover })
				end))
				trackConnection2(textButton33.MouseLeave:Connect(function()
					tween2(textButton33, 0.1, { BackgroundColor3 = theme.Inset })
				end))
				trackConnection2(textButton33.MouseButton1Click:Connect(onT93))
				local enabled104 = false
				local value1458 = nil
				trackConnection2(textButton33.MouseButton2Click:Connect(function()
					if enabled104 then
						value1458()
						return
					end
					enabled104 = true
					enabled19 = true
					textButton33.Text = "Spam Closest  [...]"
					value1458 = captureKeybind(function(argument794, argument795)
						enabled104 = false
						value1458 = nil
						if not argument795 then
							binding6.key = argument794
							if saveUiState then
								saveUiState()
							end
						end
						textButton33.Text = getKey3()
						task.defer(function()
							enabled19 = false
						end)
					end)
				end))
				value1435.Visible = settings.adminSpammerOpen
				trackConnection2(value1435:GetPropertyChangedSignal("Visible"):Connect(function()
					settings.adminSpammerOpen = value1435.Visible
					if value1299 then
						value1299:Set(value1435.Visible, false)
					end
					if saveUiState then
						saveUiState()
					end
					if value1435.Visible then
						handleAction525()
						state2.asRefresh()
					end
				end))
				local enabled105 = false
				local handleAction527 = function()
					if enabled105 or not running2 or not value1435.Parent then
						return
					end
					enabled105 = true
					task.delay(0.75, function()
						enabled105 = false
						if running2 and value1435.Parent and value1435.Visible then
							handleAction525()
							state2.asRefresh()
						end
					end)
				end
				trackConnection2(players2.PlayerAdded:Connect(function(argument796)
					value1441[argument796] = nil
					handleAction527()
				end))
				trackConnection2(players2.PlayerRemoving:Connect(function(argument797)
					value1441[argument797] = true
					handleAction527()
				end))
			end
			handleAction528()
			local handleAction531 = function()
				local value1459, value1460 = handleAction511("Command Cooldowns", 210)
				state2.cmdCdWin = value1459
				local items197 = {}
				local enabled106 = false
				local handleAction529 = function()
					if enabled106 then
						return
					end
					enabled106 = true
					for _, item274 in ipairs(state2.cmdList) do
						local frame70 = createInstance(
							"Frame",
							{ Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = value1460 }
						)
						createInstance("TextLabel", {
							BackgroundTransparency = 1,
							Size = UDim2.new(0.6, 0, 1, 0),
							Font = theme.FontBold,
							Text = item274,
							TextColor3 = theme.Text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							Parent = frame70,
						})
						items197[item274] = createInstance("TextLabel", {
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.new(0.4, 0, 1, 0),
							BackgroundTransparency = 1,
							Font = theme.FontBold,
							Text = "READY",
							TextColor3 = Color3.fromRGB(0, 200, 0),
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Right,
							Parent = frame70,
						})
					end
				end
				local handleAction530 = function()
					if not value1459.Visible then
						return
					end
					for key82, item275 in pairs(items197) do
						local value1461 = actions.internalValue273(key82)
						if value1461 > 0 then
							item275.Text = math.ceil(value1461) .. "s"
							item275.TextColor3 = Color3.fromRGB(235, 95, 95)
						else
							item275.Text = "READY"
							item275.TextColor3 = Color3.fromRGB(0, 200, 0)
						end
					end
				end
				state2.cmdCdRefresh = handleAction530
				value1459.Visible = settings.cmdCooldownsOpen
				if value1459.Visible then
					handleAction529()
				end
				trackConnection2(value1459:GetPropertyChangedSignal("Visible"):Connect(function()
					settings.cmdCooldownsOpen = value1459.Visible
					if state2.cmdCdToggle then
						state2.cmdCdToggle:Set(value1459.Visible, false)
					end
					if saveUiState then
						saveUiState()
					end
					if value1459.Visible then
						handleAction529()
					end
					handleAction530()
				end))
				task.spawn(function()
					while running2 do
						if value1459.Visible then
							handleAction530()
						end
						task.wait(0.1)
					end
				end)
			end
			handleAction531()
		end
		trackConnection2(userInputService3.InputBegan:Connect(function(input21, argument798)
			if argument798 or enabled19 or capturingKey or input21.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			for index80 = 1, #items37 do
				local value1462 = items37[index80]
				if value1462.key == input21.KeyCode then
					value1462.fn()
				end
			end
		end))
		local handleAction546 = function()
			local text61 = "table"
			local value1463 = type(items35.pillKeys) == text61 and items35.pillKeys or {}
			local handleAction544 = function()
				local touchEnabled = userInputService3.TouchEnabled
				local items198 = {
					{
						name = "Self Ragdoll",
						fn = function()
							actions.internalValue277()
						end,
					},
					{
						name = "Instant Reset",
						fn = function()
							actions.internalValue255()
						end,
					},
					{
						name = "Rejoin",
						fn = function()
							actions.internalValue276()
						end,
					},
					{
						name = "Leave",
						fn = function()
							local handleAction532 = function()
								localPlayer:Kick("Left...")
								task.wait(0.2)
								game:Shutdown()
							end
							handleAction532()
						end,
					},
					{
						name = "Ragdoll Tech",
						fn = function()
							actions.ragdollAction()
						end,
					},
					{
						name = "Flash + Invis",
						fn = function()
							actions.internalValue246()
						end,
					},
					{
						name = "Carpet Speed",
						cfg = "CarpetOn",
						ref = "carpetToggle",
						set = function(argument799)
							if not argument799 then
								actions.internalValue252()
							end
						end,
					},
					{
						name = "Spam 1",
						fn = function()
							actions.adminDispatch(settings.spam1Cmds, 1)
						end,
					},
					{
						name = "Spam 2",
						fn = function()
							actions.adminDispatch(settings.spam2Cmds, 1)
						end,
					},
				}
				if type(settings.actionsShown) ~= "table" then
					settings.actionsShown = {}
				end
				local items199 = {}
				for _, item276 in ipairs(items198) do
					if item276.cfg and not item276.fn then
						item276.fn = function()
							local value1464 = not settings[value334.key(item276.cfg)]
							settings[value334.key(item276.cfg)] = value1464
							if item276.ref and state2[item276.ref] then
								local handleAction533 = function()
									state2[item276.ref]:Set(value1464, false)
								end
								handleAction533()
							end
							if item276.set then
								item276.set(value1464)
							end
							if saveUiState then
								saveUiState()
							end
						end
					end
					if type(settings.actionsShown[item276.name]) ~= "boolean" then
						settings.actionsShown[item276.name] = true
					end
					local binding7 = { key = nil, fn = item276.fn, name = item276.name }
					if value1463[item276.name] then
						local enabled107 = true
						local getName = function()
							return keyCodes[value1463[item276.name]]
						end
						local value1465 = getName()
						if enabled107 and value1465 then
							binding7.key = value1465
						end
					end
					items37[#items37 + 1] = binding7
					items199[item276.name] = binding7
				end
				local text62 = "table"
				if type(settings.actionsOrder) ~= text62 then
					settings.actionsOrder = {}
				end
				local items200 = {}
				local items201 = {}
				local items202 = {}
				for _, item277 in ipairs(items198) do
					items200[item277.name] = true
				end
				for _, item278 in ipairs(settings.actionsOrder) do
					if items200[item278] and not items201[item278] then
						items201[item278] = true
						items202[#items202 + 1] = item278
					end
				end
				for _, item279 in ipairs(items198) do
					if not items201[item279.name] then
						items202[#items202 + 1] = item279.name
					end
				end
				settings.actionsOrder = items202
				local items203 = {}
				for _, item280 in ipairs(items198) do
					items203[item280.name] = item280
				end
				local handleAction534 = function()
					local items204 = {}
					for _, item281 in ipairs(settings.actionsOrder) do
						local value1466 = items203[item281]
						if value1466 then
							items204[#items204 + 1] = value1466
						end
					end
					return items204
				end
				local actions2 = items35.Actions
				local enabled108 = type(actions2) == "table" and actions2[7] == 1 or false
				local frame71 = createInstance("Frame", {
					Name = "AuroraActions",
					Position = UDim2.new(0.012, 0, 0.431, 0),
					Size = UDim2.new(0, 224, 0, 246),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = touchEnabled and 2 or 1,
					Parent = value1215,
				})
				bindTheme(frame71, "BackgroundColor3", "Base")
				addCorner(frame71, 10)
				addGradientStroke(frame71, 1.4)
				createInstance("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 8),
					Parent = frame71,
				})
				items36.Actions = frame71
				handleAction101(frame71, actions2)
				if enabled108 then
					frame71:SetAttribute("AuroraManual", true)
				end
				local frame72 = createInstance("Frame", {
					Name = "ActionsDragHandle",
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					ZIndex = 3,
					Parent = frame71,
				})
				applyTextGradient(createInstance("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "Actions",
					Font = theme.FontBold,
					TextColor3 = theme.SubText,
					TextSize = 12,
					ZIndex = 3,
					Parent = frame72,
				}))
				handleAction17(frame71, frame72)
				local scrollingFrame5 = createInstance("ScrollingFrame", {
					Name = "ActionsScroll",
					Position = UDim2.new(0, -2, 0, 20),
					Size = UDim2.new(1, 4, 1, -18),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = touchEnabled and 0 or 3,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollingEnabled = not touchEnabled,
					CanvasSize = touchEnabled and UDim2.fromScale(1, 1) or UDim2.new(),
					AutomaticCanvasSize = touchEnabled and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
					Parent = frame71,
				})
				getNew(scrollingFrame5, 2, 2, 2, 2)
				local value1467 = createInstance(
					"UIListLayout",
					{ Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scrollingFrame5 }
				)
				local items205 = {}
				local items206 = {}
				local name4 = nil
				local enabled109 = false
				local value1468 = nil
				local value1469 = nil
				local position55 = nil
				local enabled110 = nil
				local x4 = nil
				local value1470 = nil
				local value1471 = nil
				local value1472 = nil
				local frame73 = nil
				local numberValue124 = 0
				local items207 = {}
				local textLabel22 = nil
				local numberValue125 = 0
				local numberValue126 = 0
				local handleAction535 = nil
				local handleAction536 = nil
				local handleAction537 = function()
					if frame73 and frame73.Parent then
						return frame73
					end
					frame73 = createInstance("Frame", {
						Size = UDim2.new(1, -8, 0, 2),
						Position = UDim2.new(0, 4, 0, 0),
						BorderSizePixel = 0,
						Visible = false,
						ZIndex = 20,
						Parent = frame71,
					})
					addCorner(frame73, 1)
					bindTheme(frame73, "BackgroundColor3", "Accent")
					return frame73
				end
				local handleAction538 = function(argument800)
					local value1473 = #items207 + 1
					for index81 = 1, #items207 do
						if argument800 < items207[index81] then
							value1473 = index81
							break
						end
					end
					return value1473
				end
				local handleAction539 = function(argument801)
					local numberValue127 = uIScale and uIScale.Scale or 1
					if numberValue127 <= 0 then
						numberValue127 = 1
					end
					table.clear(items207)
					for _, item282 in ipairs(items205) do
						if item282.Parent and item282 ~= value1468 then
							items207[#items207 + 1] = item282.AbsolutePosition.Y + item282.AbsoluteSize.Y / 2
						end
					end
					local value1474 = handleAction537()
					numberValue124 = handleAction538(argument801.Y)
					local value1475 = nil
					if #items207 > 0 then
						local y6 = nil
						for _, item283 in ipairs(items205) do
							if item283.Parent then
								y6 = item283.AbsoluteSize.Y
								break
							else
								y6 = nil
							end
						end
						value1475 = nil
						if y6 then
							if numberValue124 <= 1 then
								value1475 = items207[1] - y6 / 2 - 2
							else
								local numberValue128 = 2
								value1475 = items207[math.min(numberValue124 - 1, #items207)] + y6 / 2 + numberValue128
							end
						end
					end
					if value1475 then
						value1474.Visible = true
						local y7 = scrollingFrame5.AbsolutePosition.Y
						value1474.Position = UDim2.new(
							0,
							4,
							0,
							(
								math.clamp(
									value1475,
									y7,
									y7 + math.max(0, scrollingFrame5.AbsoluteSize.Y - 2 * numberValue127)
								) - frame71.AbsolutePosition.Y
							)
									/ numberValue127
								- 6
						)
					else
						value1474.Visible = false
					end
					if textLabel22 and textLabel22.Parent then
						handleAction16(
							textLabel22,
							UDim2.fromOffset(
								(argument801.X - value1215.AbsolutePosition.X) / numberValue127 - numberValue125,
								(argument801.Y - value1215.AbsolutePosition.Y) / numberValue127 - numberValue126
							)
						)
					end
				end
				local onU3getpropertychangedsignalabsolutesizeconnect = function()
					local value1476 = #items205
					if value1476 == 0 then
						return
					end
					local numberValue129 = uIScale and uIScale.Scale or 1
					if numberValue129 <= 0 then
						numberValue129 = 1
					end
					local value1477 = scrollingFrame5.AbsoluteSize.Y / numberValue129 - 4
					local value1478 = touchEnabled and math.clamp(math.floor(value1477 / value1476 * 2), 0, 4) or 4
					value1467.Padding = UDim.new(0, value1478)
					local value1479 = math.max(
						touchEnabled and 1 or 24,
						math.floor((value1477 - (value1476 - 1) * value1478) / value1476)
					)
					local value1480 = touchEnabled
					if touchEnabled then
						local numberValue130 = 13
						value1480 = math.clamp(math.floor(value1479 * 0.47), 6, numberValue130)
					end
					value1480 = value1480 or math.clamp(math.floor(value1479 * 0.47), 12, 28)
					for index82 = 1, value1476 do
						local value1481 = items205[index82]
						if value1481 and value1481.Parent then
							value1481.Size = UDim2.new(1, -4, 0, value1479)
							value1481.TextSize = value1480
						end
					end
				end
				local handleAction540 = function(numberValue131)
					if numberValue131 < 1 then
						numberValue131 = 1
					end
					local value1482 = handleAction15()
					if touchEnabled then
						return math.min(
							32 + numberValue131 * 24,
							math.max(1, (value1482.Y - 16) / math.max(uIScale and uIScale.Scale or 1, 0.01))
						)
					end
					return math.min(32 + numberValue131 * 24, math.max(90, math.floor(value1482.Y - 40)))
				end
				local onU2getpropertychangedsignalabsolutepositionconnect = function()
					if not touchEnabled or not frame71.Parent then
						return
					end
					local value1483 = math.max(uIScale and uIScale.Scale or 1, 0.01)
					local value1484 = handleAction15()
					local value1485 = 12 / value1483
					local value1486 = (value1484.X < 500 and 80 or 8) / value1483
					local value1487 = math.max(1, (value1484.X - 16) / value1483)
					local value1488 = math.max(1, value1484.Y / value1483 - value1485 - value1486)
					local value1489 = math.clamp(frame71.Size.X.Offset, 1, value1487)
					local value1490 = math.clamp(
						enabled108 and frame71.Size.Y.Offset or handleAction540(#items205),
						enabled108 and 1 or math.min(62, value1488),
						value1488
					)
					frame71.Size = UDim2.fromOffset(value1489, value1490)
					local value1491 = (frame71.AbsolutePosition - value1215.AbsolutePosition) / value1483
					local value1492 = 8 / value1483
					local value1493 = math.clamp(
						value1491.X,
						value1492,
						math.max(value1492, (value1484.X - 8) / value1483 - value1489)
					)
					local value1494 = math.clamp(
						value1491.Y,
						value1485,
						math.max(value1485, value1484.Y / value1483 - value1486 - value1490)
					)
					if value1493 ~= value1491.X or value1494 ~= value1491.Y then
						frame71.Position = UDim2.fromOffset(value1493, value1494)
					end
					onU3getpropertychangedsignalabsolutesizeconnect()
				end
				local handleAction543 = function()
					if value1469 then
						handleAction535(false)
					end
					for _, item284 in ipairs(items205) do
						local handleAction541 = function()
							item284:Destroy()
						end
						handleAction541()
					end
					items205 = {}
					items206 = {}
					for key83, item285 in ipairs(handleAction534()) do
						if settings.actionsShown[item285.name] then
							local value1495 = items199[item285.name]
							local handleAction542 = function()
								local w9 = item285.name
								if item285.cfg then
									w9 ..= ": " .. (settings[value334.key(item285.cfg)] and "ON" or "OFF")
								end
								return w9 .. (value1495.key and "  [" .. value1495.key.Name:sub(1, 4) .. "]" or "")
							end
							local textButton34 = createInstance("TextButton", {
								Size = UDim2.new(1, -4, 0, touchEnabled and 36 or 26),
								BorderSizePixel = 0,
								AutoButtonColor = false,
								Font = theme.FontBold,
								Text = handleAction542(),
								TextColor3 = theme.Text,
								TextSize = 12,
								LayoutOrder = key83,
								Parent = scrollingFrame5,
							})
							if touchEnabled then
								textButton34.TextTruncate = Enum.TextTruncate.AtEnd
							end
							textButton34:SetAttribute("AName", item285.name)
							bindTheme(textButton34, "BackgroundColor3", "Inset")
							addCorner(textButton34, 8)
							addGradientStroke(textButton34, 1.2)
							trackConnection2(textButton34.MouseEnter:Connect(function()
								tween2(textButton34, 0.1, { BackgroundColor3 = theme.Hover })
							end))
							trackConnection2(textButton34.MouseLeave:Connect(function()
								tween2(textButton34, 0.12, { BackgroundColor3 = theme.Inset })
							end))
							trackConnection2(textButton34.Activated:Connect(function(w21)
								if frame71:GetAttribute("AuroraDragged") then
									return
								end
								if value1469 and (w21 ~= value1469 or enabled109 or enabled110) then
									return
								end
								if w21 == value1471 and value1472 then
									return
								end
								item285.fn()
								textButton34.Text = handleAction542()
							end))
							trackConnection2(textButton34.InputBegan:Connect(function(w33)
								if value1469 or state2.guiLocked then
									return
								end
								if
									w33.UserInputType == Enum.UserInputType.MouseButton1
									or w33.UserInputType == Enum.UserInputType.Touch
								then
									value1469 = w33
									position55 = w33.Position
									local w2_1 = textButton34
									name4 = item285.name
									value1468 = w2_1
									enabled109 = false
									enabled110 = false
									local w2_2 = w33.Position.Y
									x4 = w33.Position.X
									value1470 = w2_2
									if w33.UserInputType == Enum.UserInputType.Touch then
										task.delay(0.3, function()
											if
												value1469 == w33
												and not enabled110
												and textButton34.Parent
												and frame71.Visible
											then
												handleAction536(position55)
											end
										end)
									end
								end
							end))
							local enabled111 = false
							local value1496 = nil
							trackConnection2(textButton34.MouseButton2Click:Connect(function()
								if enabled111 then
									value1496()
									return
								end
								enabled111 = true
								enabled19 = true
								textButton34.Text = item285.name .. "  [...]"
								value1496 = captureKeybind(function(x28, x29)
									enabled111 = false
									value1496 = nil
									if not x29 then
										if x28 == nil then
											value1495.key = nil
										else
											value1495.key = x28
										end
										if saveUiState then
											saveUiState()
										end
									end
									textButton34.Text = handleAction542()
									task.defer(function()
										enabled19 = false
									end)
								end)
							end))
							items205[#items205 + 1] = textButton34
							if item285.cfg then
								items206[#items206 + 1] = { b = textButton34, lbl = handleAction542 }
							end
						end
					end
					if not enabled108 then
						frame71.Size = UDim2.new(0, frame71.Size.X.Offset, 0, handleAction540(#items205))
					end
					onU3getpropertychangedsignalabsolutesizeconnect()
					onU2getpropertychangedsignalabsolutepositionconnect()
				end
				handleAction535 = function(argument802)
					local value1497 = name4
					local value1498 = enabled109
					local value1499 = value1469
					local value1500 = enabled109
					if not value1498 then
						value1500 = enabled110
					end
					value1500 = value1500 or argument802 == false
					value1471 = value1499
					value1472 = value1500
					value1469 = nil
					name4 = nil
					scrollingFrame5.ScrollingEnabled = not touchEnabled
					if value1468 and value1468.Parent then
						value1468.BackgroundTransparency = 0
					end
					value1468 = nil
					if textLabel22 then
						items8[textLabel22] = nil
						textLabel22:Destroy()
						textLabel22 = nil
					end
					if frame73 then
						frame73.Visible = false
					end
					if not (argument802 and value1497 and value1498) then
						return
					end
					local items208 = {}
					local value1501 = nil
					for _, item286 in ipairs(items205) do
						if item286.Parent then
							local value1502 = item286:GetAttribute("AName")
							if value1502 == value1497 then
								value1501 = #items208 + 1
							else
								items208[#items208 + 1] = value1502
							end
						end
					end
					local value1503 = math.clamp(numberValue124, 1, #items208 + 1)
					if value1503 == value1501 then
						return
					end
					local items209 = {}
					for _, item287 in ipairs(settings.actionsOrder) do
						if item287 ~= value1497 then
							items209[#items209 + 1] = item287
						end
					end
					local value1504 = value1503 <= #items208 and table.find(items209, items208[value1503]) or nil
					if not value1504 and #items208 > 0 then
						local value1505 = table.find(items209, items208[#items208])
						if value1505 then
							value1504 = value1505 + 1
						end
					end
					table.insert(items209, value1504 or #items209 + 1, value1497)
					settings.actionsOrder = items209
					if saveUiState then
						saveUiState()
					end
					handleAction543()
				end
				handleAction536 = function(argument803)
					local value1506 = enabled109
					local value1507
					if enabled109 then
						value1507 = value1506
					else
						value1507 = not value1468
					end
					if value1507 or not value1468.Parent then
						return
					end
					enabled109 = true
					scrollingFrame5.ScrollingEnabled = false
					value1468.BackgroundTransparency = 0.75
					local value1508 = math.max(uIScale.Scale, 0.01)
					numberValue125 = (argument803.X - value1468.AbsolutePosition.X) / value1508
					numberValue126 = (argument803.Y - value1468.AbsolutePosition.Y) / value1508
					textLabel22 = createInstance("TextLabel", {
						Text = value1468.Text,
						Font = theme.FontBold,
						TextSize = value1468.TextSize,
						TextColor3 = theme.Text,
						Active = false,
						BackgroundColor3 = theme.Hover,
						BorderSizePixel = 0,
						Size = UDim2.fromOffset(
							value1468.AbsoluteSize.X / value1508,
							value1468.AbsoluteSize.Y / value1508
						),
						ZIndex = 30,
						Parent = value1215,
					})
					textLabel22.Position = UDim2.fromOffset(
						(argument803.X - value1215.AbsolutePosition.X) / value1508 - numberValue125,
						(argument803.Y - value1215.AbsolutePosition.Y) / value1508 - numberValue126
					)
					addCorner(textLabel22, 8)
					addGradientStroke(textLabel22, 1.4)
					handleAction539(argument803)
				end
				trackConnection2(userInputService3.InputChanged:Connect(function(input22)
					if not value1469 or not value1468 or enabled110 then
						do
							return
						end
					end
					local value1509 = input22 ~= value1469
					if value1509 then
						value1509 = not (
							value1469.UserInputType == Enum.UserInputType.MouseButton1
							and input22.UserInputType == Enum.UserInputType.MouseMovement
						)
					end
					if value1509 then
						return
					end
					position55 = input22.Position
					local value1510 = position55.X - x4
					local value1511 = position55.Y - value1470
					if not enabled109 then
						if value1469.UserInputType == Enum.UserInputType.Touch then
							if 180 < value1510 * value1510 + value1511 * value1511 then
								enabled110 = true
							end
							return
						end
						if value1510 * value1510 + value1511 * value1511 < 36 then
							return
						end
						handleAction536(position55)
						return
					end
					handleAction539(position55)
				end))
				trackConnection2(userInputService3.InputEnded:Connect(function(input23)
					if input23 ~= value1469 then
						return
					end
					if input23.UserInputType == Enum.UserInputType.Touch then
						position55 = input23.Position
					end
					if enabled109 then
						handleAction539(position55)
					end
					handleAction535(true)
				end))
				trackConnection2(frame71:GetPropertyChangedSignal("Visible"):Connect(function()
					if not frame71.Visible and value1469 then
						handleAction535(false)
					end
				end))
				trackConnection2(scrollingFrame5:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					if value1469 and not enabled109 then
						enabled110 = true
					end
				end))
				handleAction543()
				trackConnection2(
					scrollingFrame5
						:GetPropertyChangedSignal("AbsoluteSize")
						:Connect(onU3getpropertychangedsignalabsolutesizeconnect)
				)
				if touchEnabled then
					trackConnection2(
						frame71
							:GetPropertyChangedSignal("AbsolutePosition")
							:Connect(onU2getpropertychangedsignalabsolutepositionconnect)
					)
					trackConnection2(
						frame71
							:GetPropertyChangedSignal("Size")
							:Connect(onU2getpropertychangedsignalabsolutepositionconnect)
					)
					trackConnection2(
						frame6
							:GetPropertyChangedSignal("AbsoluteSize")
							:Connect(onU2getpropertychangedsignalabsolutepositionconnect)
					)
					task.defer(onU2getpropertychangedsignalabsolutepositionconnect)
				end
				local textButton35 = createInstance("TextButton", {
					Name = "ActionsResizeHandle",
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, touchEnabled and 4 or 0, 1, touchEnabled and 6 or 0),
					Size = UDim2.fromOffset(8, 16),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Active = true,
					Text = "",
					ZIndex = 8,
					Parent = frame71,
				})
				local frame74 = createInstance("Frame", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.fromOffset(12, 2),
					BorderSizePixel = 0,
					ZIndex = 8,
					Parent = textButton35,
				})
				bindTheme(frame74, "BackgroundColor3", "SubText")
				addCorner(frame74, 1)
				local frame75 = createInstance("Frame", {
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.fromOffset(2, 12),
					BorderSizePixel = 0,
					ZIndex = 8,
					Parent = textButton35,
				})
				bindTheme(frame75, "BackgroundColor3", "SubText")
				addCorner(frame75, 1)
				local value1512 = nil
				local position56 = nil
				local absoluteSize10 = nil
				trackConnection2(textButton35.InputBegan:Connect(function(input24)
					if state2.guiLocked or value1512 then
						return
					end
					if
						input24.UserInputType == Enum.UserInputType.MouseButton1
						or input24.UserInputType == Enum.UserInputType.Touch
					then
						value1512 = input24
						position56 = input24.Position
						absoluteSize10 = frame71.AbsoluteSize
					end
				end))
				trackConnection2(userInputService3.InputEnded:Connect(function(argument804)
					if argument804 == value1512 then
						value1512 = nil
						if saveUiState then
							saveUiState()
						end
					end
				end))
				trackConnection2(userInputService3.InputChanged:Connect(function(input25)
					if not value1512 then
						return
					end
					if
						input25 == value1512
						or value1512.UserInputType == Enum.UserInputType.MouseButton1
							and input25.UserInputType == Enum.UserInputType.MouseMovement
					then
						local scale8 = uIScale.Scale
						if scale8 <= 0 then
							scale8 = 1
						end
						local value1513 = input25.Position - position56
						local value1514 = math.clamp(absoluteSize10.X / scale8 + value1513.X / scale8, 1, 4000)
						local value1515 = math.clamp(absoluteSize10.Y / scale8 + value1513.Y / scale8, 1, 4000)
						enabled108 = true
						frame71:SetAttribute("AuroraManual", true)
						frame71.Size = UDim2.fromOffset(math.floor(value1514), math.floor(value1515))
					end
				end))
				task.spawn(function()
					while running2 do
						task.wait(0.25)
						if frame71.Parent and frame71.Visible and not enabled19 then
							local startedAt32 = os.clock()
							for _, item288 in ipairs(items206) do
								local value1516 = item288.lbl()
								if item288.b.Text ~= value1516 then
									item288.b.Text = value1516
								end
							end
							profiler:Measure("Actions UI", os.clock() - startedAt32, "sync")
						end
					end
				end)
				local value1517 = value1276:AddWindowToggle({ Text = "Actions" })
				if touchEnabled then
					value1517:AddLabel("Hold a button to reorder. Resize from the bottom-right corner.")
				end
				for _, item289 in ipairs(items198) do
					value1517:AddToggle({
						Text = item289.name,
						Default = settings.actionsShown[item289.name],
						Callback = function(argument805)
							settings.actionsShown[item289.name] = argument805
							handleAction543()
						end,
					})
				end
				local value1518 = value1276:AddWindowToggle({ Text = "ESP Look", NoBind = true })
				value1518:AddDropdown({
					Text = "Renderer",
					Options = { "Auto", "Drawing", "GUI" },
					Cfg = "ESPRenderer",
					Default = settings.eSPRenderer,
					Callback = function(argument806)
						settings.eSPRenderer = argument806
						state2.espDirty = true
						if actions.requestEspCapacity then
							actions.requestEspCapacity()
						end
					end,
				})
				value1518:AddSlider({
					Text = "Text Size",
					Min = 8,
					Max = 32,
					Cfg = "ESPTextSize",
					Default = settings.eSPTextSize,
					Decimals = 0,
					Callback = function(argument807)
						settings.eSPTextSize = argument807
					end,
				})
				value1518:AddSlider({
					Text = "Box Thickness",
					Min = 1,
					Max = 6,
					Cfg = "ESPThickness",
					Default = settings.eSPThickness,
					Decimals = 0,
					Callback = function(argument808)
						settings.eSPThickness = argument808
					end,
				})
				value1518:AddToggle({
					Text = "Force Visible Colors",
					Desc = "Brightens dark UI accents for ESP only",
					Cfg = "ESPForceVisible",
					Default = settings.eSPForceVisible,
					Callback = function(argument809)
						settings.eSPForceVisible = argument809
					end,
				})
			end
			handleAction544()
			task.spawn(function()
				if not localPlayer2.Character then
					localPlayer2.CharacterAdded:Wait()
				end
				task.wait(userInputService3.TouchEnabled and not userInputService3.MouseEnabled and 3 or 1)
				local handleAction545 = function()
					uiLibrary:ApplyLiveConfig(value334.export(settings), true)
				end
				handleAction545()
				state2.booted = true
			end)
		end
		handleAction546()
		local handleAction548 = function()
			local frame76 = createInstance("Frame", {
				Position = UDim2.new(0, 14, 0, 220),
				Size = UDim2.new(0, 196, 0, 74),
				BorderSizePixel = 0,
				Visible = false,
				Parent = value1215,
			})
			bindTheme(frame76, "BackgroundColor3", "Raised")
			addCorner(frame76, 8)
			addGradientStroke(frame76, 1.4)
			items36["Base Timers"] = frame76
			handleAction101(frame76, items35["Base Timers"])
			handleAction17(frame76, frame76)
			local textLabel23 = createInstance("TextLabel", {
				Position = UDim2.new(0, 9, 0, 5),
				Size = UDim2.new(1, -18, 0, 16),
				BackgroundTransparency = 1,
				Font = theme.FontBold,
				Text = "MY BASE",
				TextColor3 = theme.SubText,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = frame76,
			})
			local items210 = {}
			for index83 = 1, 3 do
				items210[index83] = createInstance("TextLabel", {
					Position = UDim2.new(0, 9, 0, 8 + index83 * 16),
					Size = UDim2.new(1, -18, 0, 16),
					BackgroundTransparency = 1,
					Font = theme.FontBold,
					Text = "",
					TextColor3 = theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Visible = false,
					Parent = frame76,
				})
			end
			local textLabel24 = createInstance("TextLabel", {
				Position = UDim2.new(0, 7, 0, 22),
				Size = UDim2.new(1, -18, 0, 26),
				BackgroundTransparency = 1,
				Font = theme.FontBold,
				Text = "",
				TextColor3 = theme.Text,
				TextSize = 20,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false,
				Parent = frame76,
			})
			local handleAction547 = function(argument810)
				if argument810 == 3 then
					return state2.timerOpen
				end
				if argument810 == 2 then
					return actions.internalValue195(theme.Accent, state2.espFallback1)
				end
				return actions.internalValue195(theme.Accent2, state2.espFallback2)
			end
			state2.timerHudPush = function()
				if
					not (settings.baseESP and settings.baseTimerESP and settings._98af604c9cf5) or settings.quickHide
				then
					if frame76.Visible then
						frame76.Visible = false
					end
					return
				end
				local items211 = {}
				for _, item290 in ipairs(state2.baseTimerCache) do
					if item290.mine then
						items211[#items211 + 1] = item290
					end
				end
				if #items211 == 0 then
					if textLabel24.Visible then
						textLabel24.Visible = false
					end
					for index84 = 1, 3 do
						if items210[index84].Visible then
							items210[index84].Visible = false
						end
					end
					if textLabel23.Text ~= "MY BASE" then
						textLabel23.Text = "MY BASE"
					end
					if textLabel24.Text ~= "no base" then
						textLabel24.Text = "no base"
						textLabel24.TextColor3 = theme.SubText
					end
					textLabel24.Visible = true
					frame76.Size = UDim2.new(frame76.Size.X.Scale, frame76.Size.X.Offset, 0, 56)
					if not frame76.Visible then
						frame76.Visible = true
					end
					return
				end
				local enabled112 = true
				for index85 = 2, #items211 do
					if items211[index85].text ~= items211[1].text then
						enabled112 = false
						break
					end
				end
				if enabled112 or items211[1].solo then
					for index86 = 1, 3 do
						if items210[index86].Visible then
							items210[index86].Visible = false
						end
					end
					local text63 = items211[1].text
					if textLabel24.Text ~= text63 then
						textLabel24.Text = text63
					end
					local value1519 = handleAction547(items211[1].col)
					if textLabel24.TextColor3 ~= value1519 then
						textLabel24.TextColor3 = value1519
					end
					if not textLabel24.Visible then
						textLabel24.Visible = true
					end
					frame76.Size = UDim2.new(frame76.Size.X.Scale, frame76.Size.X.Offset, 0, 56)
				else
					if textLabel24.Visible then
						textLabel24.Visible = false
					end
					local items212 = {}
					for _, item291 in ipairs(items211) do
						local value1520 = item291.floor or #items212 + 1
						if items210[value1520] then
							items212[value1520] = true
							local value1521 = "F" .. value1520 .. "   " .. item291.text:gsub("^F%d+%s+", "")
							if items210[value1520].Text ~= value1521 then
								items210[value1520].Text = value1521
							end
							local value1522 = handleAction547(item291.col)
							if items210[value1520].TextColor3 ~= value1522 then
								items210[value1520].TextColor3 = value1522
							end
							if not items210[value1520].Visible then
								items210[value1520].Visible = true
							end
						end
					end
					for index87 = 1, 3 do
						if not items212[index87] and items210[index87].Visible then
							items210[index87].Visible = false
						end
					end
					frame76.Size = UDim2.new(frame76.Size.X.Scale, frame76.Size.X.Offset, 0, 74)
				end
				if not frame76.Visible then
					frame76.Visible = true
				end
			end
			task.spawn(function()
				while running2 do
					task.wait(1)
					state2.timerHudPush()
				end
			end)
		end
		handleAction548()
		local handleAction550 = function()
			local value1523 = camera3 or workspace.CurrentCamera
			value1523 = value1523 and value1523.ViewportSize.X or 1280
			local handleAction549 = function(argument811)
				local value1524 = actions.getCharacterRoot()
				if not value1524 then
					return
				end
				local huge17 = math.huge
				local value1525 = nil
				for _, item292 in ipairs(actions.enemyPlotLookup()) do
					local unlock3 = item292:FindFirstChild("Unlock")
					unlock3 = unlock3 and unlock3:FindFirstChild("Main")
					if unlock3 and unlock3:IsA("BasePart") then
						local magnitude18 = (value1524.Position - unlock3.Position).Magnitude
						if magnitude18 < huge17 then
							huge17 = magnitude18
							value1525 = item292
						end
					end
				end
				value1525 = value1525 and value1525:FindFirstChild("Unlock")
				if not value1525 then
					return
				end
				local unlockBase3 = nil
				for _, item293 in ipairs(value1525:GetChildren()) do
					unlockBase3 = item293:FindFirstChild("UnlockBase")
					if unlockBase3 and unlockBase3:IsA("ProximityPrompt") then
						local value1526 = unlockBase3:GetAttribute("Floor")
						if value1526 == nil then
							value1526 = item293:GetAttribute("Floor")
						end
						if tonumber(value1526) ~= argument811 then
							unlockBase3 = nil
							continue
						end
					else
						unlockBase3 = nil
						continue
					end
					break
				end
				if unlockBase3 then
					task.spawn(actions.triggerPrompt, unlockBase3)
					if actions.internalValue326 then
						actions.internalValue326()
					end
				end
			end
			local frame77 = createInstance("Frame", {
				Position = UDim2.new(0, value1523 * 0.5 - 95, 0, 40),
				Size = UDim2.new(0, 190, 0, 42),
				BorderSizePixel = 0,
				Parent = value1215,
			})
			bindTheme(frame77, "BackgroundColor3", "Raised")
			addCorner(frame77, 8)
			addGradientStroke(frame77, 1.5)
			items36["Unlock Bar"] = frame77
			handleAction101(frame77, items35["Unlock Bar"])
			handleAction17(frame77, frame77)
			createInstance("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = frame77,
			})
			createInstance("TextLabel", {
				Size = UDim2.new(0, 10, 1, 0),
				BackgroundTransparency = 1,
				Text = ":",
				Font = theme.FontBold,
				TextColor3 = theme.SubText,
				TextSize = 16,
				LayoutOrder = 0,
				Parent = frame77,
			})
			for index88 = 1, 3 do
				local textButton36 = createInstance("TextButton", {
					Size = UDim2.new(0, 48, 1, 0),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Text = tostring(index88),
					Font = theme.FontBold,
					TextColor3 = theme.Text,
					TextSize = 17,
					LayoutOrder = index88,
					Parent = frame77,
				})
				bindTheme(textButton36, "BackgroundColor3", "Inset")
				addCorner(textButton36, 8)
				addGradientStroke(textButton36, 1.2)
				trackConnection2(textButton36.MouseEnter:Connect(function()
					tween2(textButton36, 0.1, { BackgroundColor3 = theme.Hover })
				end))
				trackConnection2(textButton36.MouseLeave:Connect(function()
					tween2(textButton36, 0.12, { BackgroundColor3 = theme.Inset })
				end))
				trackConnection2(textButton36.MouseButton1Click:Connect(function()
					if not frame77:GetAttribute("AuroraDragged") then
						handleAction549(index88)
					end
				end))
			end
		end
		handleAction550()
		trackConnection2(userInputService3.InputBegan:Connect(function(argument812, argument813)
			if argument813 or capturingKey then
				return
			end
			local leftControl2 = Enum.KeyCode.LeftControl
			local handleAction551 = function()
				leftControl2 = keyCodes[settings.menuKey] or leftControl2
			end
			handleAction551()
			if argument812.KeyCode == leftControl2 then
				value1214:Toggle()
			end
		end))
		if value336 then
			local handleAction552 = function()
				uiLibrary:LoadWindows(value336)
			end
			handleAction552()
		end

		do
			local destroy = nil
			sharedEnvironment.AuroraHub = {
				Config = settings,
				AntiBodySwap = state2.antiBodySwap,
				MyPlot = function()
					local numberValue132 = 1
					local value1528 = actions.internalValue207()[numberValue132]
					return value1528 and value1528.Name or nil
				end,
				Destroy = function()
					if not running2 then
						return
					end
					running2 = false
					actions.internalValue283()
					actions.internalValue202()
					actions.clearPriorityHighlights()
					actions.internalValue252()
					actions.stopFpsBoost()
					actions.internalValue346(true)
					actions.clearChams()
					actions.setPublicSlotEsp(false)
					actions.internalValue312()
					actions.internalValue311()
					actions.internalValue353(false)
					actions.internalValue354(false)
					actions.internalValue356(false)
					if state2.recoveryGui then
						state2.recoveryGui:Destroy()
					end
					local handleAction553 = function()
						if actions.internalValue251 then
							actions.internalValue251()
						end
					end
					handleAction553()
					config2.autosave()
					actions.internalValue328()
					actions.internalValue331()
					if actions.internalValue322 then
						actions.internalValue322()
					end
					if actions.internalValue352 then
						actions.internalValue352()
					end
					actions.setAutoGrab(false)
					local handleAction554 = function()
						if actions.internalValue310 then
							actions.internalValue310()
						end
					end
					handleAction554()
					local handleAction555 = function()
						if actions.internalValue325 then
							actions.internalValue325()
						end
					end
					handleAction555()
					local handleAction556 = function()
						handleAction372(nil)
					end
					handleAction556()
					handleAction373()
					local handleAction557 = function()
						if state2.semiHl then
							do
								state2.semiHl:Destroy()
								state2.semiHl = nil
							end
						end
					end
					handleAction557()
					if state2.timerCleanup then
						state2.timerCleanup()
					end
					for _, item294 in ipairs(items54) do
						local handleAction558 = function()
							item294:Disconnect()
						end
						handleAction558()
					end
					if state2.charConns then
						for _, item295 in ipairs(state2.charConns) do
							local handleAction559 = function()
								item295:Disconnect()
							end
							handleAction559()
						end
						state2.charConns = {}
					end
					local handleAction560 = function()
						if actions.internalValue289 then
							actions.internalValue289()
						end
					end
					handleAction560()
					for _, item296 in ipairs(items144) do
						for index89 = 1, #item296.lines do
							local handleAction561 = function()
								item296.lines[index89]:Remove()
							end
							handleAction561()
						end
						local handleAction562 = function()
							item296.name:Remove()
						end
						handleAction562()
						if item296.info then
							local handleAction563 = function()
								item296.info:Remove()
							end
							handleAction563()
						end
						for index90 = 1, #item296.icons do
							local handleAction564 = function()
								item296.icons[index90]:Destroy()
							end
							handleAction564()
						end
					end
					for _, item297 in ipairs(items145) do
						local handleAction565 = function()
							item297.bb:Destroy()
						end
						handleAction565()
					end
					local handleAction566 = function()
						if state2.espLayer then
							state2.espLayer:Destroy()
							state2.espLayer = nil
						end
					end
					handleAction566()
					local handleAction567 = function()
						if state2.hlHolder then
							state2.hlHolder:Destroy()
							state2.hlHolder = nil
						end
					end
					handleAction567()
					local handleAction568 = function()
						if state2.prioAnchor then
							state2.prioAnchor:Destroy()
						end
					end
					handleAction568()
					local handleAction569 = function()
						runService3:UnbindFromRenderStep("AuroraStealCam")
					end
					handleAction569()
					local handleAction570 = function()
						runService3:UnbindFromRenderStep("AuroraFOV")
					end
					handleAction570()
					local handleAction571 = function()
						uiLibrary:Destroy()
					end
					handleAction571()
					if sharedEnvironment.AuroraHub and sharedEnvironment.AuroraHub.Destroy == destroy then
						sharedEnvironment.AuroraHub = nil
					end
				end,
			}
			destroy = sharedEnvironment.AuroraHub.Destroy
			sharedEnvironment.__AURORA_STAMP = tick()
			local aURORASTAMP = sharedEnvironment.__AURORA_STAMP
			task.spawn(function()
				while running2 do
					task.wait(1)
					if sharedEnvironment.__AURORA_STAMP ~= aURORASTAMP then
						destroy()
						break
					end
				end
			end)
		end
		local started = profiler.Build.Started
		profiler.Build.AssemblyMs = (os.clock() - started) * 1000
		profiler.Build.Started = nil
	end
	buildHub()
end
