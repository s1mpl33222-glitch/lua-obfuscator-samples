-- This file was generated at discord.gg/syncrypt

local t1 = {
	["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")),
}

t1["1"].Name = "SwaggWarn"
t1["2"] = Instance.new("Frame", t1["1"])
t1["2"].BorderSizePixel = 0
t1["2"].BackgroundColor3 = Color3.fromRGB(26, 26, 26)
t1["2"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["2"].Size = UDim2.new(0.5, 0, 0.5, 0)
t1["2"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["2"].Name = "Background"
t1["3"] = Instance.new("UICorner", t1["2"])
t1["3"].CornerRadius = UDim.new(0, 15)
t1["4"] = Instance.new("Frame", t1["2"])
t1["4"].ZIndex = 2
t1["4"].BorderSizePixel = 0
t1["4"].BackgroundColor3 = Color3.fromRGB(21, 21, 21)
t1["4"].Size = UDim2.new(1, 0, 0.13, 0)
t1["4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["4"].Name = "Top"
t1["5"] = Instance.new("UICorner", t1["4"])
t1["5"].CornerRadius = UDim.new(0, 15)
t1["6"] = Instance.new("Frame", t1["4"])
t1["6"].BorderSizePixel = 0
t1["6"].BackgroundColor3 = Color3.fromRGB(21, 21, 21)
t1["6"].AnchorPoint = Vector2.new(0.5, 1)
t1["6"].Size = UDim2.new(1, 0, 0.5, 0)
t1["6"].Position = UDim2.new(0.5, 0, 1, 0)
t1["6"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["6"].Name = "Tuff"
t1["7"] = Instance.new("TextLabel", t1["4"])
t1["7"].TextWrapped = true
t1["7"].ZIndex = 2
t1["7"].BorderSizePixel = 0
t1["7"].TextSize = 14
t1["7"].TextXAlignment = Enum.TextXAlignment.Left
t1["7"].TextScaled = true
t1["7"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["7"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["7"].TextColor3 = Color3.fromRGB(241, 255, 74)
t1["7"].BackgroundTransparency = 1
t1["7"].AnchorPoint = Vector2.new(0, 0.5)
t1["7"].Size = UDim2.new(0.3, 0, 1, 0)
t1["7"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["7"].Text = "Warning"
t1["7"].Name = "LibName"
t1["7"].Position = UDim2.new(0.065, 0, 0.5, 0)
t1["8"] = Instance.new("UITextSizeConstraint", t1["7"])
t1["8"].MaxTextSize = 25
t1["9"] = Instance.new("ImageLabel", t1["4"])
t1["9"].ZIndex = 2
t1["9"].BorderSizePixel = 0
t1["9"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["9"].ImageColor3 = Color3.fromRGB(241, 255, 74)
t1["9"].AnchorPoint = Vector2.new(0, 0.5)
t1["9"].Image = "rbxassetid://91979051352733"
t1["9"].Size = UDim2.new(0.04659, 0, 0.61523, 0)
t1["9"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["9"].BackgroundTransparency = 1
t1["9"].Name = "SwaggaIco"
t1["9"].Position = UDim2.new(0.01, 0, 0.5, 0)
t1.a = Instance.new("Frame", t1["4"])
t1.a.ZIndex = 2
t1.a.BorderSizePixel = 0
t1.a.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1.a.AnchorPoint = Vector2.new(1, 0.5)
t1.a.Size = UDim2.new(0.15, 0, 1, 0)
t1.a.Position = UDim2.new(0.99, 0, 0.5, 0)
t1.a.BorderColor3 = Color3.fromRGB(0, 0, 0)
t1.a.Name = "LeftButtons"
t1.a.BackgroundTransparency = 1
t1.b = Instance.new("UIListLayout", t1.a)
t1.b.HorizontalAlignment = Enum.HorizontalAlignment.Right
t1.b.Padding = UDim.new(0.02, 0)
t1.b.VerticalAlignment = Enum.VerticalAlignment.Center
t1.b.SortOrder = Enum.SortOrder.LayoutOrder
t1.b.FillDirection = Enum.FillDirection.Horizontal
t1.c = Instance.new("ImageButton", t1.a)
t1.c.BorderSizePixel = 0
t1.c.ImageTransparency = 1
t1.c.BackgroundTransparency = 1
t1.c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1.c.ZIndex = 3
t1.c.AnchorPoint = Vector2.new(1, 0.5)
t1.c.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
t1.c.Size = UDim2.new(0.31057, 0, 0.61523, 0)
t1.c.LayoutOrder = 3
t1.c.BorderColor3 = Color3.fromRGB(0, 0, 0)
t1.c.Name = "Close"
t1.c.Position = UDim2.new(1, 0, 0.5, 0)
t1.d = Instance.new("ImageLabel", t1.c)
t1.d.ZIndex = 3
t1.d.BorderSizePixel = 0
t1.d.ScaleType = Enum.ScaleType.Fit
t1.d.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1.d.ImageTransparency = 0.3
t1.d.AnchorPoint = Vector2.new(0.5, 0.5)
t1.d.Image = "rbxassetid://11293981586"
t1.d.Size = UDim2.new(0.71429, 0, 0.71429, 0)
t1.d.BorderColor3 = Color3.fromRGB(0, 0, 0)
t1.d.BackgroundTransparency = 1
t1.d.Name = "icon"
t1.d.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.e = Instance.new("StringValue", t1.c)
t1.e.Name = "Twn"
t1.e.Value = "TopButtons"
t1.f = Instance.new("Folder", t1["4"])
t1.f.Name = "Design"
t1["10"] = Instance.new("ImageLabel", t1.f)
t1["10"].BorderSizePixel = 0
t1["10"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["10"].AnchorPoint = Vector2.new(0.5, 0)
t1["10"].Image = "rbxassetid://89529654803210"
t1["10"].Size = UDim2.new(0, 600, 0, 9)
t1["10"].Visible = false
t1["10"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["10"].BackgroundTransparency = 1
t1["10"].Name = "BottomGlowLine"
t1["10"].Position = UDim2.new(0.5, 0, 0.94, 0)
t1["11"] = Instance.new("UIGradient", t1["10"])
t1["11"].Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 59, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(101, 29, 255)),
})
t1["12"] = Instance.new("Frame", t1.f)
t1["12"].BorderSizePixel = 0
t1["12"].BackgroundColor3 = Color3.fromRGB(31, 31, 31)
t1["12"].AnchorPoint = Vector2.new(0.5, 0)
t1["12"].Size = UDim2.new(1, 0, 0.03, 0)
t1["12"].Position = UDim2.new(0.5, 0, 1, 0)
t1["12"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["12"].Name = "BottomLine"
t1["13"] = Instance.new("TextLabel", t1["4"])
t1["13"].TextWrapped = true
t1["13"].ZIndex = 2
t1["13"].BorderSizePixel = 0
t1["13"].TextSize = 14
t1["13"].TextScaled = true
t1["13"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["13"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["13"].TextColor3 = Color3.fromRGB(241, 255, 74)
t1["13"].BackgroundTransparency = 1
t1["13"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["13"].Size = UDim2.new(0.3, 0, 1, 0)
t1["13"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["13"].Text = "Old Loader"
t1["13"].Name = "LibName"
t1["13"].Position = UDim2.new(0.55, 0, 0.5, 0)
t1["14"] = Instance.new("UITextSizeConstraint", t1["13"])
t1["14"].MaxTextSize = 25
t1["15"] = Instance.new("TextLabel", t1["2"])
t1["15"].TextWrapped = true
t1["15"].ZIndex = 2
t1["15"].BorderSizePixel = 0
t1["15"].TextSize = 14
t1["15"].TextScaled = true
t1["15"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["15"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["15"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["15"].BackgroundTransparency = 1
t1["15"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["15"].Size = UDim2.new(0.7, 0, 0.11, 0)
t1["15"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["15"].Text = "Please Switch To The New Loader!"
t1["15"].Name = "LibName"
t1["15"].Position = UDim2.new(0.5, 0, 0.18, 0)
t1["16"] = Instance.new("UITextSizeConstraint", t1["15"])
t1["16"].MaxTextSize = 25
t1["17"] = Instance.new("Frame", t1["2"])
t1["17"].BorderSizePixel = 0
t1["17"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["17"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["17"].Size = UDim2.new(0.63223, 0, 0.765, 0)
t1["17"].Position = UDim2.new(0.31612, 0, 0.6175, 0)
t1["17"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["17"].Name = "List"
t1["17"].BackgroundTransparency = 1
t1["18"] = Instance.new("Frame", t1["17"])
t1["18"].BorderSizePixel = 0
t1["18"].BackgroundColor3 = Color3.fromRGB(31, 31, 31)
t1["18"].Size = UDim2.new(0.94786, 0, 0.44876, 0)
t1["18"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["18"].Name = "Key"
t1["19"] = Instance.new("UICorner", t1["18"])
t1["19"].CornerRadius = UDim.new(0, 15)
t1["1a"] = Instance.new("TextLabel", t1["18"])
t1["1a"].TextWrapped = true
t1["1a"].ZIndex = 2
t1["1a"].BorderSizePixel = 0
t1["1a"].TextSize = 14
t1["1a"].TextScaled = true
t1["1a"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["1a"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["1a"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["1a"].BackgroundTransparency = 1
t1["1a"].AnchorPoint = Vector2.new(0.5, 0)
t1["1a"].Size = UDim2.new(0.9, 0, 0.18, 0)
t1["1a"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["1a"].Text = "New Universal Loader"
t1["1a"].Name = "Vae"
t1["1a"].Position = UDim2.new(0.5, 0, 0.04, 0)
t1["1b"] = Instance.new("UITextSizeConstraint", t1["1a"])
t1["1b"].MaxTextSize = 25
t1["1c"] = Instance.new("ImageButton", t1["18"])
t1["1c"].BorderSizePixel = 0
t1["1c"].AutoButtonColor = false
t1["1c"].ImageTransparency = 1
t1["1c"].BackgroundColor3 = Color3.fromRGB(21, 21, 21)
t1["1c"].ZIndex = 2
t1["1c"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["1c"].Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
t1["1c"].Size = UDim2.new(0.4, 0, 0.4, 0)
t1["1c"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["1c"].Name = "Copy"
t1["1c"].Position = UDim2.new(0.5, 0, 0.6, 0)
t1["1d"] = Instance.new("UICorner", t1["1c"])
t1["1d"].CornerRadius = UDim.new(0, 15)
t1["1e"] = Instance.new("TextLabel", t1["1c"])
t1["1e"].TextWrapped = true
t1["1e"].ZIndex = 3
t1["1e"].BorderSizePixel = 0
t1["1e"].TextSize = 14
t1["1e"].TextScaled = true
t1["1e"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["1e"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["1e"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["1e"].BackgroundTransparency = 1
t1["1e"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["1e"].Size = UDim2.new(1, 0, 1, 0)
t1["1e"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["1e"].Text = "Copy Code"
t1["1e"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["1f"] = Instance.new("UITextSizeConstraint", t1["1e"])
t1["1f"].MaxTextSize = 25
t1["20"] = Instance.new("ImageLabel", t1["1c"])
t1["20"].BorderSizePixel = 0
t1["20"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["20"].ImageColor3 = Color3.fromRGB(103, 255, 76)
t1["20"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["20"].Image = "rbxassetid://110442014659569"
t1["20"].Size = UDim2.new(1.36308, 0, 1.96774, 0)
t1["20"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["20"].BackgroundTransparency = 1
t1["20"].Name = "Glow"
t1["20"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["21"] = Instance.new("UIGradient", t1["20"])
t1["21"].Rotation = 45
t1["21"].Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.4, 0.762),
	NumberSequenceKeypoint.new(0.5, 0.525),
	NumberSequenceKeypoint.new(1, 0),
})
t1["21"].Offset = Vector2.new(1, 0)
t1["22"] = Instance.new("UIScale", t1["1c"])
t1["23"] = Instance.new("StringValue", t1["1c"])
t1["23"].Name = "Twn"
t1["23"].Value = "Button2"
t1["24"] = Instance.new("UIListLayout", t1["17"])
t1["24"].HorizontalAlignment = Enum.HorizontalAlignment.Center
t1["24"].Padding = UDim.new(0.03, 0)
t1["24"].VerticalAlignment = Enum.VerticalAlignment.Center
t1["24"].SortOrder = Enum.SortOrder.LayoutOrder
t1["25"] = Instance.new("Frame", t1["2"])
t1["25"].BorderSizePixel = 0
t1["25"].BackgroundColor3 = Color3.fromRGB(31, 31, 31)
t1["25"].Size = UDim2.new(0.35, 0, 0.709, 0)
t1["25"].Position = UDim2.new(0.633, 0, 0.261, 0)
t1["25"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["25"].Name = "Support"
t1["26"] = Instance.new("UICorner", t1["25"])
t1["26"].CornerRadius = UDim.new(0, 15)
t1["27"] = Instance.new("TextLabel", t1["25"])
t1["27"].TextWrapped = true
t1["27"].ZIndex = 2
t1["27"].BorderSizePixel = 0
t1["27"].TextSize = 14
t1["27"].TextScaled = true
t1["27"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["27"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["27"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["27"].BackgroundTransparency = 1
t1["27"].AnchorPoint = Vector2.new(0.5, 0)
t1["27"].Size = UDim2.new(0.9, 0, 0.1, 0)
t1["27"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["27"].Text = "Support"
t1["27"].Name = "Vae"
t1["27"].Position = UDim2.new(0.5, 0, 0.02, 0)
t1["28"] = Instance.new("UITextSizeConstraint", t1["27"])
t1["28"].MaxTextSize = 35
t1["29"] = Instance.new("Frame", t1["25"])
t1["29"].BorderSizePixel = 0
t1["29"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["29"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["29"].Size = UDim2.new(1, 0, 0.88, 0)
t1["29"].Position = UDim2.new(0.5, 0, 0.56, 0)
t1["29"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["29"].Name = "List"
t1["29"].BackgroundTransparency = 1
t1["2a"] = Instance.new("UIListLayout", t1["29"])
t1["2a"].HorizontalAlignment = Enum.HorizontalAlignment.Center
t1["2a"].VerticalAlignment = Enum.VerticalAlignment.Center
t1["2a"].SortOrder = Enum.SortOrder.LayoutOrder
t1["2b"] = Instance.new("Frame", t1["29"])
t1["2b"].BorderSizePixel = 0
t1["2b"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["2b"].Size = UDim2.new(1, 0, 0.4, 0)
t1["2b"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["2b"].Name = "TopSlot"
t1["2b"].BackgroundTransparency = 1
t1["2c"] = Instance.new("Frame", t1["2b"])
t1["2c"].ZIndex = 2
t1["2c"].BorderSizePixel = 0
t1["2c"].BackgroundColor3 = Color3.fromRGB(21, 21, 21)
t1["2c"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["2c"].Size = UDim2.new(0.69911, 0, 0.42599, 0)
t1["2c"].Position = UDim2.new(0.5, 0, 0.25, 0)
t1["2c"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["2c"].Name = "tbox"
t1["2d"] = Instance.new("UICorner", t1["2c"])
t1["2d"].CornerRadius = UDim.new(0, 15)
t1["2e"] = Instance.new("TextBox", t1["2c"])
t1["2e"].PlaceholderColor3 = Color3.fromRGB(179, 179, 179)
t1["2e"].ZIndex = 3
t1["2e"].BorderSizePixel = 0
t1["2e"].TextEditable = false
t1["2e"].TextWrapped = true
t1["2e"].TextSize = 14
t1["2e"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["2e"].TextScaled = true
t1["2e"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["2e"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["2e"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["2e"].ClearTextOnFocus = false
t1["2e"].Size = UDim2.new(0.9, 0, 1, 0)
t1["2e"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["2e"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["2e"].Text = "https://discord.gg/PcQH3spxXD"
t1["2e"].BackgroundTransparency = 1
t1["2f"] = Instance.new("UITextSizeConstraint", t1["2e"])
t1["2f"].MaxTextSize = 30
t1["30"] = Instance.new("ImageButton", t1["2b"])
t1["30"].BorderSizePixel = 0
t1["30"].AutoButtonColor = false
t1["30"].ImageTransparency = 1
t1["30"].BackgroundColor3 = Color3.fromRGB(21, 21, 21)
t1["30"].ZIndex = 2
t1["30"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["30"].Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
t1["30"].Size = UDim2.new(0.59864, 0, 0.47923, 0)
t1["30"].LayoutOrder = 3
t1["30"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["30"].Name = "Copy"
t1["30"].Position = UDim2.new(0.5, 0, 0.43, 0)
t1["31"] = Instance.new("UICorner", t1["30"])
t1["31"].CornerRadius = UDim.new(0, 15)
t1["32"] = Instance.new("TextLabel", t1["30"])
t1["32"].TextWrapped = true
t1["32"].ZIndex = 3
t1["32"].BorderSizePixel = 0
t1["32"].TextSize = 14
t1["32"].TextScaled = true
t1["32"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["32"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["32"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["32"].BackgroundTransparency = 1
t1["32"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["32"].Size = UDim2.new(1, 0, 1, 0)
t1["32"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["32"].Text = "Copy Link Server"
t1["32"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["33"] = Instance.new("UITextSizeConstraint", t1["32"])
t1["33"].MaxTextSize = 20
t1["34"] = Instance.new("UIScale", t1["30"])
t1["35"] = Instance.new("ImageLabel", t1["30"])
t1["35"].BorderSizePixel = 0
t1["35"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["35"].ImageColor3 = Color3.fromRGB(103, 255, 76)
t1["35"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["35"].Image = "rbxassetid://110442014659569"
t1["35"].Size = UDim2.new(1.55944, 0, 2.25926, 0)
t1["35"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["35"].BackgroundTransparency = 1
t1["35"].Name = "Glow"
t1["35"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["36"] = Instance.new("UIGradient", t1["35"])
t1["36"].Rotation = 45
t1["36"].Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.4, 0.762),
	NumberSequenceKeypoint.new(0.5, 0.525),
	NumberSequenceKeypoint.new(1, 0),
})
t1["36"].Offset = Vector2.new(1, 0)
t1["37"] = Instance.new("StringValue", t1["30"])
t1["37"].Name = "Twn"
t1["37"].Value = "Button2"
t1["38"] = Instance.new("UIListLayout", t1["2b"])
t1["38"].HorizontalAlignment = Enum.HorizontalAlignment.Center
t1["38"].Padding = UDim.new(0.06, 0)
t1["38"].VerticalAlignment = Enum.VerticalAlignment.Center
t1["38"].SortOrder = Enum.SortOrder.LayoutOrder
t1["39"] = Instance.new("Frame", t1["29"])
t1["39"].BorderSizePixel = 0
t1["39"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["39"].Size = UDim2.new(1, 0, 0.4, 0)
t1["39"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["39"].Name = "BottomSlot"
t1["39"].LayoutOrder = 3
t1["39"].BackgroundTransparency = 1
t1["3a"] = Instance.new("Frame", t1["39"])
t1["3a"].ZIndex = 2
t1["3a"].BorderSizePixel = 0
t1["3a"].BackgroundColor3 = Color3.fromRGB(21, 21, 21)
t1["3a"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["3a"].Size = UDim2.new(0.69911, 0, 0.42599, 0)
t1["3a"].Position = UDim2.new(0.5, 0, 0.25, 0)
t1["3a"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["3a"].Name = "tbox"
t1["3b"] = Instance.new("UICorner", t1["3a"])
t1["3b"].CornerRadius = UDim.new(0, 15)
t1["3c"] = Instance.new("TextBox", t1["3a"])
t1["3c"].CursorPosition = -1
t1["3c"].PlaceholderColor3 = Color3.fromRGB(179, 179, 179)
t1["3c"].ZIndex = 3
t1["3c"].BorderSizePixel = 0
t1["3c"].TextEditable = false
t1["3c"].TextWrapped = true
t1["3c"].TextSize = 14
t1["3c"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["3c"].TextScaled = true
t1["3c"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["3c"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["3c"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["3c"].ClearTextOnFocus = false
t1["3c"].Size = UDim2.new(0.9, 0, 1, 0)
t1["3c"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["3c"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["3c"].Text = "<https://discord.com/users/597431652414914567>"
t1["3c"].BackgroundTransparency = 1
t1["3d"] = Instance.new("UITextSizeConstraint", t1["3c"])
t1["3d"].MaxTextSize = 30
t1["3e"] = Instance.new("ImageButton", t1["39"])
t1["3e"].BorderSizePixel = 0
t1["3e"].AutoButtonColor = false
t1["3e"].ImageTransparency = 1
t1["3e"].BackgroundColor3 = Color3.fromRGB(21, 21, 21)
t1["3e"].ZIndex = 2
t1["3e"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["3e"].Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
t1["3e"].Size = UDim2.new(0.59864, 0, 0.47923, 0)
t1["3e"].LayoutOrder = 2
t1["3e"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["3e"].Name = "Copy"
t1["3e"].Position = UDim2.new(0.5, 0, 0.43, 0)
t1["3f"] = Instance.new("UICorner", t1["3e"])
t1["3f"].CornerRadius = UDim.new(0, 15)
t1["40"] = Instance.new("TextLabel", t1["3e"])
t1["40"].TextWrapped = true
t1["40"].ZIndex = 3
t1["40"].BorderSizePixel = 0
t1["40"].TextSize = 14
t1["40"].TextScaled = true
t1["40"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["40"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["40"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["40"].BackgroundTransparency = 1
t1["40"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["40"].Size = UDim2.new(1, 0, 1, 0)
t1["40"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["40"].Text = "Copy Link Manager"
t1["40"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["41"] = Instance.new("UITextSizeConstraint", t1["40"])
t1["41"].MaxTextSize = 20
t1["42"] = Instance.new("UIScale", t1["3e"])
t1["43"] = Instance.new("ImageLabel", t1["3e"])
t1["43"].BorderSizePixel = 0
t1["43"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["43"].ImageColor3 = Color3.fromRGB(103, 255, 76)
t1["43"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["43"].Image = "rbxassetid://110442014659569"
t1["43"].Size = UDim2.new(1.55944, 0, 2.25926, 0)
t1["43"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["43"].BackgroundTransparency = 1
t1["43"].Name = "Glow"
t1["43"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["44"] = Instance.new("UIGradient", t1["43"])
t1["44"].Rotation = 45
t1["44"].Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.4, 0.762),
	NumberSequenceKeypoint.new(0.5, 0.525),
	NumberSequenceKeypoint.new(1, 0),
})
t1["44"].Offset = Vector2.new(1, 0)
t1["45"] = Instance.new("StringValue", t1["3e"])
t1["45"].Name = "Twn"
t1["45"].Value = "Button2"
t1["46"] = Instance.new("UIListLayout", t1["39"])
t1["46"].HorizontalAlignment = Enum.HorizontalAlignment.Center
t1["46"].Padding = UDim.new(0.06, 0)
t1["46"].VerticalAlignment = Enum.VerticalAlignment.Center
t1["46"].SortOrder = Enum.SortOrder.LayoutOrder
t1["47"] = Instance.new("Frame", t1["29"])
t1["47"].BorderSizePixel = 0
t1["47"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["47"].Size = UDim2.new(1, 0, 0.15, 0)
t1["47"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["47"].Name = "Center"
t1["47"].LayoutOrder = 2
t1["47"].BackgroundTransparency = 1
t1["48"] = Instance.new("UIListLayout", t1["47"])
t1["48"].HorizontalAlignment = Enum.HorizontalAlignment.Center
t1["48"].Padding = UDim.new(0.06, 0)
t1["48"].VerticalAlignment = Enum.VerticalAlignment.Center
t1["48"].SortOrder = Enum.SortOrder.LayoutOrder
t1["49"] = Instance.new("TextLabel", t1["47"])
t1["49"].TextWrapped = true
t1["49"].ZIndex = 2
t1["49"].BorderSizePixel = 0
t1["49"].TextSize = 14
t1["49"].TextScaled = true
t1["49"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t1["49"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
t1["49"].TextColor3 = Color3.fromRGB(255, 255, 255)
t1["49"].BackgroundTransparency = 1
t1["49"].AnchorPoint = Vector2.new(0.5, 0)
t1["49"].Size = UDim2.new(0.9, 0, 0.8, 0)
t1["49"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["49"].Text = "OR"
t1["49"].Name = "Vae"
t1["49"].Position = UDim2.new(0.45395, 0, 0.80616, 0)
t1["4a"] = Instance.new("UITextSizeConstraint", t1["49"])
t1["4a"].MaxTextSize = 30
t1["4b"] = Instance.new("ImageLabel", t1["2"])
t1["4b"].ZIndex = -1
t1["4b"].BorderSizePixel = 0
t1["4b"].BackgroundColor3 = Color3.fromRGB(26, 26, 26)
t1["4b"].ImageColor3 = Color3.fromRGB(26, 26, 26)
t1["4b"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["4b"].Image = "rbxassetid://110255645815326"
t1["4b"].Size = UDim2.new(1.14579, 0, 1.22038, 0)
t1["4b"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["4b"].BackgroundTransparency = 1
t1["4b"].Name = "Glow"
t1["4b"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["4c"] = Instance.new("UIGradient", t1["4b"])
t1["4c"].Enabled = false
t1["4c"].Rotation = -120
t1["4c"].Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 21, 21)),
	ColorSequenceKeypoint.new(0.659, Color3.fromRGB(21, 21, 21)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(107, 114, 33)),
})
t1["4d"] = Instance.new("ImageLabel", t1["2"])
t1["4d"].ZIndex = 0
t1["4d"].BorderSizePixel = 0
t1["4d"].BackgroundColor3 = Color3.fromRGB(26, 26, 26)
t1["4d"].ImageTransparency = 0.6
t1["4d"].ImageColor3 = Color3.fromRGB(241, 255, 74)
t1["4d"].AnchorPoint = Vector2.new(0.5, 0.5)
t1["4d"].Image = "rbxassetid://110255645815326"
t1["4d"].Size = UDim2.new(1.14579, 0, 1.22038, 0)
t1["4d"].BorderColor3 = Color3.fromRGB(0, 0, 0)
t1["4d"].BackgroundTransparency = 1
t1["4d"].Name = "GlowYellow"
t1["4d"].Position = UDim2.new(0.5, 0, 0.5, 0)
t1["4e"] = Instance.new("UIGradient", t1["4d"])
t1["4e"].Rotation = 45
t1["4e"].Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.2, 0.9),
	NumberSequenceKeypoint.new(0.5, 1),
	NumberSequenceKeypoint.new(1, 1),
})
t1["4f"] = Instance.new("UIAspectRatioConstraint", t1["2"])
t1["4f"].AspectRatio = 1.51163
t1["50"] = Instance.new("Folder", t1["1"])
t1["50"].Name = "Anims"
t1["51"] = Instance.new("ModuleScript", t1["50"])
t1["51"].Name = "AnimHandle"
t1["52"] = Instance.new("LocalScript", t1["50"])
t1["52"].Name = "TweenDragg"
t1["53"] = Instance.new("LocalScript", t1["50"])
t1["53"].Name = "Main"

local _require = require
local t2 = {}
local u4 = t2
local u5 = require
local v6 = t1["51"]
local t3 = {}
local u8 = t1

function t3.Closure()
	local v15 = u8["51"]
	local TweenService = game:GetService("TweenService")
	local Parent = v15.Parent
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local _ = workspace.CurrentCamera

	game:GetService("Lighting")
	game:GetService("RunService")

	local Mouse = LocalPlayer:GetMouse()
	local t4 = {}
	local u22 = TweenService

	function t4.Scale(p1, p2, p3, p4, p5, p6, p7)
		u22:Create(p1.UIScale, TweenInfo.new(p2, Enum.EasingStyle[p3], Enum.EasingDirection[p4], p5, p6), {
			Scale = p7,
		}):Play()
	end

	local u23 = TweenService

	function t4.Position(p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18)
		local v106 = u23:Create(p8, TweenInfo.new(p9, Enum.EasingStyle[p10], Enum.EasingDirection[p11], p12, p13), {
			Position = UDim2.new(p14, 0, p15, 0),
		})

		v106:Play()

		if p16 ~= true then
			return
		end

		local Completed = v106.Completed
		local u108 = p8

		Completed:Connect(function()
			u108.Position = UDim2.fromScale(p17, p18)
		end)
	end

	local u24 = TweenService

	function t4.Size(p19, p20, p21, p22, p23, p24, p25, p26, _)
		u24:Create(p19, TweenInfo.new(p20, Enum.EasingStyle[p21], Enum.EasingDirection[p22], p23, p24), {
			Size = UDim2.new(p25, 0, p26, 0),
		}):Play()
	end

	local u25 = TweenService

	function t4.Corner(p28, p29, p30, p31, p32, p33, p34, p35)
		u25:Create(p28, TweenInfo.new(p29, Enum.EasingStyle[p30], Enum.EasingDirection[p31], p32, p33), {
			CornerRadius = UDim.new(p34, p35),
		}):Play()
	end

	local u26 = TweenService

	function t4.Thickness(p36, p37, p38, p39, p40, p41, p42)
		u26:Create(p36, TweenInfo.new(p37, Enum.EasingStyle[p38], Enum.EasingDirection[p39], p40, p41), {
			Thickness = p42,
		}):Play()
	end

	local u27 = TweenService

	function t4.SliceScale(p43, p44, p45, p46, p47, p48, p49)
		u27:Create(p43, TweenInfo.new(p44, Enum.EasingStyle[p45], Enum.EasingDirection[p46], p47, p48), {
			SliceScale = p49,
		}):Play()
	end

	local u28 = TweenService

	function t4.SliceCenter(p50, p51, p52, p53, p54, p55, p56, p57, p58, p59)
		u28:Create(p50, TweenInfo.new(p51, Enum.EasingStyle[p52], Enum.EasingDirection[p53], p54, p55), {
			SliceCenter = Rect.new(p56, p57, p58, p59),
		}):Play()
	end

	local u29 = TweenService

	function t4.TileSize(p60, p61, p62, p63, p64, p65, p66, p67)
		u29:Create(p60, TweenInfo.new(p61, Enum.EasingStyle[p62], Enum.EasingDirection[p63], p64, p65), {
			TileSize = UDim2.new(p66, 0, p67, 0),
		}):Play()
	end

	local u30 = TweenService

	function t4.TextTween(p68, p69, p70, p71, p72, p73, p74, p75)
		local IntValue = Instance.new("IntValue")

		IntValue.Parent = p69
		IntValue.Value = p75
		u30:Create(p68, TweenInfo.new(p70, Enum.EasingStyle[p71], Enum.EasingDirection[p72], p73, p74), {
			Value = tostring(p75),
		}):Play()
	end

	local u31 = TweenService

	function t4.BackgroundColor(p76, p77, p78, p79, p80, p81, p82, p83, p84)
		u31:Create(p76, TweenInfo.new(p77, Enum.EasingStyle[p78], Enum.EasingDirection[p79], p80, p81), {
			BackgroundColor3 = Color3.fromRGB(p82, p83, p84),
		}):Play()
	end

	local u32 = TweenService

	function t4.ImageColor(p85, p86, p87, p88, p89, p90, p91, p92, p93)
		u32:Create(p85, TweenInfo.new(p86, Enum.EasingStyle[p87], Enum.EasingDirection[p88], p89, p90), {
			ImageColor3 = Color3.fromRGB(p91, p92, p93),
		}):Play()
	end

	local u33 = TweenService

	function t4.TextColor(p94, p95, p96, p97, p98, p99, p100, p101, p102)
		u33:Create(p94, TweenInfo.new(p95, Enum.EasingStyle[p96], Enum.EasingDirection[p97], p98, p99), {
			TextColor3 = Color3.fromRGB(p100, p101, p102),
		}):Play()
	end

	local u34 = TweenService

	function t4.Color(p103, p104, p105, p106, p107, p108, p109, p110, p111)
		u34:Create(p103, TweenInfo.new(p104, Enum.EasingStyle[p105], Enum.EasingDirection[p106], p107, p108), {
			Color = Color3.fromRGB(p109, p110, p111),
		}):Play()
	end

	local u35 = TweenService

	function t4.BackgroundTransparency(p112, p113, p114, p115, p116, p117, p118)
		u35:Create(p112, TweenInfo.new(p113, Enum.EasingStyle[p114], Enum.EasingDirection[p115], p116, p117), {
			BackgroundTransparency = p118,
		}):Play()
	end

	local u36 = TweenService

	function t4.TextTransparency(p119, p120, p121, p122, p123, p124, p125)
		u36:Create(p119, TweenInfo.new(p120, Enum.EasingStyle[p121], Enum.EasingDirection[p122], p123, p124), {
			TextTransparency = p125,
		}):Play()
	end

	local u37 = TweenService

	function t4.ImageTransparency(p126, p127, p128, p129, p130, p131, p132)
		u37:Create(p126, TweenInfo.new(p127, Enum.EasingStyle[p128], Enum.EasingDirection[p129], p130, p131), {
			ImageTransparency = p132,
		}):Play()
	end

	local u38 = TweenService

	function t4.Transparency(p133, p134, p135, p136, p137, p138, p139)
		u38:Create(p133, TweenInfo.new(p134, Enum.EasingStyle[p135], Enum.EasingDirection[p136], p137, p138), {
			Transparency = p139,
		}):Play()
	end

	local u39 = TweenService

	function t4.Rotation(p140, p141, p142, p143, p144, p145, p146, p147, p148)
		local v241 = u39:Create(p140, TweenInfo.new(p141, Enum.EasingStyle[p142], Enum.EasingDirection[p143], p144, p145), {
			Rotation = p146,
		})

		v241:Play()

		if p147 ~= true then
			return
		end

		local Completed = v241.Completed
		local u243 = p140

		Completed:Connect(function()
			u243.Rotation = p148
		end)
	end

	local u40 = TweenService

	function t4.GradientOffset(p149, p150, p151, p152, p153, p154, p155, p156, p157, p158, p159)
		local v257 = u40:Create(p149.UIGradient, TweenInfo.new(p150, Enum.EasingStyle[p151], Enum.EasingDirection[p152], p153, p154), {
			Offset = Vector2.new(p155, p156),
		})

		v257:Play()

		if p157 == true then
			local Completed = v257.Completed
			local u259 = p149

			Completed:Connect(function()
				u259.UIGradient.Offset = Vector2.new(p158, p159)
			end)
		end
	end

	local u41 = v15

	function t4.SoundActivation(p160, p161, p162)
		local clone = u41.Parent[p161][p162]:Clone()

		clone.Parent = p160
		wait()
		clone.Playing = true
		clone.es.Enabled = true
	end

	local u42 = TweenService

	function t4.Loading(p163, p164)
		u42:Create(p163, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(p164 / 100, 1),
		}):Play()
	end

	local u43 = TweenService

	function t4.Record(p165, p166, p167)
		u43:Create(p165, TweenInfo.new(p167, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.new(p166 / 100, 0, 0, 10),
		}):Play()
	end

	local u44 = TweenService

	function t4.AppearEffect(p168, p169, p170, p171, p172, p173, p174, p175, p176, p177, p178, p179)
		local AbsoluteSizeX = p168.AbsoluteSize.X
		local _ = p168.AbsoluteSize.Y
		local v283 = math.random(0, AbsoluteSizeX)
		local v284 = math.random(p169, p170)
		local v285 = math.random(p173, p174)

		wait()

		local clone = p168.Icon:Clone()

		clone.Parent = p168
		clone.Visible = true
		clone.Size = UDim2.new(0, v284, 0, v284)
		clone.Position = UDim2.new(0, v283, 1.2, 0)
		wait()

		if p172 ~= true then
			local v287 = u44:Create(clone, TweenInfo.new(p171, Enum.EasingStyle[p175], Enum.EasingDirection[p176], p177, p178), {
				Position = UDim2.new(0, clone.Position.X.Offset, p179, 0),
			})

			v287:Play()

			local Completed = v287.Completed
			local u289 = clone

			Completed:Connect(function()
				u289:Destroy()
			end)

			return
		end

		local v290 = u44:Create(clone, TweenInfo.new(v285, Enum.EasingStyle[p175], Enum.EasingDirection[p176], p177, p178), {
			Position = UDim2.new(0, clone.Position.X.Offset, p179, 0),
		})

		v290:Play()

		local Completed = v290.Completed
		local u292 = clone

		Completed:Connect(function()
			u292:Destroy()
		end)
	end
	function t4.ThreeDRotation(p180, p181, p182, p183, p184, p185)
		if p185 ~= true then
			local timestamp = tick()
			local v300 = timestamp * p183
			local v301 = p184 + math.sin(v300) * p181
			local v302 = timestamp * p183
			local v303 = p184 + math.cos(v302) * p182

			p180.Position = UDim2.fromScale(v301, v303)

			return
		end

		local timestamp = tick()
		local v305 = timestamp * p183
		local v306 = p184 - math.sin(v305) * p181
		local v307 = timestamp * p183
		local v308 = p184 - math.cos(v307) * p182

		p180.Position = UDim2.fromScale(v306, v308)
	end

	local u45 = Parent
	local u46 = Mouse
	local u47 = TweenService

	function t4.ScaleObjectAppear(p186, p187, p188, p189, p190, p191, p192)
		local clone = u45.DecalsHandle.AppearSEffect:Clone()

		clone.Position = UDim2.new(0, u46.X - p186.AbsolutePosition.X, 0, u46.Y - p186.AbsolutePosition.Y)
		clone.Parent = p186
		clone.Visible = true
		clone.UIScale.Scale = 0

		local v317 = u47:Create(clone.UIScale, TweenInfo.new(p187, Enum.EasingStyle[p188], Enum.EasingDirection[p189], p190, p191), {
			Scale = p192,
		})
		local v318 = u47:Create(clone, TweenInfo.new(p187, Enum.EasingStyle[p188], Enum.EasingDirection[p189], p190, p191), {
			ImageTransparency = 1,
		})

		v317:Play()
		task.wait()
		v318:Play()
		v318.Completed:Connect(function()
			clone:Destroy()
		end)
	end
	function t4.RandomizeTypingEffect(p193, p194, p195, _)
		local s1 = ""

		for i = 1, #p194 do
			local t5 = {
				"#",
				"@",
				".",
				"&",
				"$",
				"^",
				"*",
				"_",
				"~",
			}
			local v327 = t5[math.random(1, #t5)]

			p193.Text = ""
			p193.TextTransparency = 0

			local _ = s1 .. v327

			p193.Text = s1
			task.wait(p195)

			local _ = s1:sub(1, -2) .. p194:sub(i, i)

			p193.Text = s1
			task.wait(p195)
		end
	end

	local u48 = t4
	local u49 = Mouse

	function t4.Slide(p197, p198, p199)
		local u333 = false

		p198.MouseButton1Up:Connect(function()
			u333 = false
		end)
		p198.MouseLeave:Connect(function()
			u333 = false
		end)

		local MouseButton1Down = p198.MouseButton1Down
		local u335 = p197
		local u336 = p198
		local u337 = p199

		MouseButton1Down:Connect(function(_, _)
			u333 = true
			u48.Size(u335, 0.1, "Quad", "InOut", 0, false, (u49.X - u336.AbsolutePosition.X) / u336.AbsoluteSize.X, 1)
			local v356 = (u49.X - u336.AbsolutePosition.X) / u336.AbsoluteSize.X * 100

			u337.Text = math.round(v356)
		end)

		local Move = u49.Move
		local u339 = p198
		local u340 = p197
		local u341 = p199

		Move:Connect(function()
			while u333 do
				wait()

				if not (u49.X - u339.AbsolutePosition.X < 0) and not ((u49.X - u339.AbsolutePosition.X) / u339.AbsoluteSize.X > 1) then
					u48.Size(u340, 0.1, "Quad", "InOut", 0, false, (u49.X - u339.AbsolutePosition.X) / u339.AbsoluteSize.X, 1)
					local v358 = (u49.X - u339.AbsolutePosition.X) / u339.AbsoluteSize.X * 100

					u341.Text = math.round(v358)
				end
			end
		end)
	end

	return t4
end

t2[v6] = t3

local u9 = t1

task.spawn(function()
	local v50 = u9["52"]
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local u53 = UserInputService;

	(function(p202)
		local u343 = false
		local u344 = nil
		local p203Position = nil
		local Position = nil
		local p202Position = p202.Position
		local RenderStepped = RunService.RenderStepped
		local u349 = p202

		RenderStepped:Connect(function()
			u349.Position = u349.Position:Lerp(p202Position, 0.1)
		end)

		local InputBegan = p202.InputBegan
		local u351 = p202

		InputBegan:Connect(function(p203)
			if (p203.UserInputType == Enum.UserInputType.MouseButton1 or p203.UserInputType == Enum.UserInputType.Touch) and not u53:GetFocusedTextBox() then
				u343 = true
				p203Position = p203.Position
				Position = u351.Position

				local Changed = p203.Changed
				local u361 = p203

				Changed:Connect(function()
					if u361.UserInputState == Enum.UserInputState.End then
						u343 = false
					end
				end)
			end
		end)
		p202.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				u344 = input
			end
		end)
		u53.InputChanged:Connect(function(input)
			if input == u344 and u343 then
				local v364 = input.Position - p203Position

				p202Position = UDim2.new(Position.X.Scale, Position.X.Offset + v364.X, Position.Y.Scale, Position.Y.Offset + v364.Y)
			end
		end)
	end)(v50.Parent.Parent.Background)
end)

local u10 = t1
local u11 = t2
local u12 = _require

task.spawn(function()
	local _ = u10["53"]
	local SwaggWarn = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("SwaggWarn")
	local Background = SwaggWarn.Background
	local AnimHandle = SwaggWarn.Anims.AnimHandle
	local v58 = u11[AnimHandle]
	local v59

	if not v58 then
		v59 = u12(AnimHandle)
	else
		if not v58.Required then
			v58.Required = true
			v58.Value = v58.Closure()
		end

		v59 = v58.Value
	end

	local MouseEnter = Background.Top.LeftButtons.Close.MouseEnter
	local u61 = v59
	local u62 = Background

	MouseEnter:Connect(function()
		u61.ImageTransparency(u62.Top.LeftButtons.Close.icon, 0.2, "Linear", "InOut", 0, false, 0)
	end)

	local MouseLeave = Background.Top.LeftButtons.Close.MouseLeave
	local u64 = v59
	local u65 = Background

	MouseLeave:Connect(function()
		u64.ImageTransparency(u65.Top.LeftButtons.Close.icon, 0.2, "Linear", "InOut", 0, false, 0.3)
	end)

	local Activated = Background.Top.LeftButtons.Close.Activated
	local u67 = SwaggWarn

	Activated:Connect(function()
		u67:Destroy()
	end)
	Background.List.Key.Copy.Activated:Connect(function()
		setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/scyfxre/L.S.S-Lubron-Secure-System-/refs/heads/main/UniversalAuth'))()")
	end)
	Background.Support.List.TopSlot.Copy.Activated:Connect(function()
		setclipboard("https://discord.gg/PcQH3spxXD")
	end)
	Background.Support.List.BottomSlot.Copy.Activated:Connect(function()
		setclipboard("<https://discord.com/users/597431652414914567>")
	end)

	for _, descendant in pairs(Background:GetDescendants()) do
		if descendant:IsA("StringValue") and descendant.Value == "Button2" then
			local descendantParent = descendant.Parent
			local MouseEnter2 = descendantParent.MouseEnter
			local u72 = v59
			local u73 = descendantParent

			MouseEnter2:Connect(function()
				u72.Scale(u73, 0.1, "Linear", "InOut", 0, false, 1.05)
				u72.BackgroundColor(u73, 0.1, "Linear", "InOut", 0, false, 30, 30, 30)
			end)

			local MouseLeave2 = descendantParent.MouseLeave
			local u75 = v59
			local u76 = descendantParent

			MouseLeave2:Connect(function()
				u75.Scale(u76, 0.1, "Linear", "InOut", 0, false, 1)
				u75.BackgroundColor(u76, 0.1, "Linear", "InOut", 0, false, 20, 20, 20)
			end)

			local MouseButton1Down = descendantParent.MouseButton1Down
			local u78 = v59
			local u79 = descendantParent

			MouseButton1Down:Connect(function()
				u78.GradientOffset(u79.Glow, 0.3, "Linear", "InOut", 0, false, 0)
			end)

			local Activated2 = descendantParent.Activated
			local u81 = v59
			local u82 = descendantParent

			Activated2:Connect(function()
				u81.GradientOffset(u82.Glow, 0.3, "Linear", "InOut", 0, true, -1)
				task.wait(0.6)
				u81.GradientOffset(u82.Glow, 0.3, "Linear", "InOut", 0, false, 1)
			end)
		end
	end

	local spawn = task.spawn
	local u84 = v59
	local u85 = Background

	spawn(function()
		while true do
			task.wait()
			u84.ImageTransparency(u85.GlowYellow, 3, "Quad", "In", 0, false, 0.2)
			task.wait(3.5)
			u84.ImageTransparency(u85.GlowYellow, 1, "Quad", "Out", 0, false, 0.6)
			task.wait(3)
		end
	end)
end)

return t1["1"],
	function(p204)
		local v14 = u4[p204]

		if not v14 then
			return u5(p204)
		end

		if not v14.Required then
			v14.Required = true
			v14.Value = v14.Closure()
		end

		return v14.Value
	end
