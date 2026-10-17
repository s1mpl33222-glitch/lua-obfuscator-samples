local _select = select
local function v52(tbl, idx, ...)
    local va = {
        ...,
    }
    for i = 1, _select("#", ...) do
        tbl[idx + i - 1] = va[i]
    end
end
local match = string.match
local _tonumber = tonumber
local _pcall = pcall
local function u4()
    local function v5(p1)
        if p1 then
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "Shaders"
            ScreenGui.Parent = game.CoreGui
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(0, 200, 0, 200)
            Frame.Position = UDim2.new(0, 0, 0, 0)
            Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            Frame.BorderColor3 = Color3.new(0, 0, 0)
            Frame.BorderSizePixel = 1
            Frame.Active = true
            Frame.BackgroundTransparency = 0
            Frame.Draggable = true
            Frame.Parent = ScreenGui
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = Frame
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Size = UDim2.new(1, 0, 0, 36)
            TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            TextLabel.BorderColor3 = Color3.new(0, 0, 0)
            TextLabel.BorderSizePixel = 1
            TextLabel.Text = "Simple Shader"
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextColor3 = Color3.new(255, 255, 255)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextSize = 18
            TextLabel.Parent = Frame
            local ScrollingFrame = Instance.new("ScrollingFrame")
            ScrollingFrame.Size = UDim2.new(1, -40, 1, -66)
            ScrollingFrame.Position = UDim2.new(0, 20, 0, 46)
            ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
            ScrollingFrame.BorderColor3 = Color3.new(0, 0, 0)
            ScrollingFrame.BorderSizePixel = 1
            ScrollingFrame.ScrollBarThickness = 1
            ScrollingFrame.Parent = Frame
            ScrollingFrame.BackgroundTransparency = 1
            UICorner:Clone().Parent = ScrollingFrame
            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = Color3.new(0, 0, 0)
            UIStroke.Thickness = 1
            UIStroke.Parent = ScrollingFrame
            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)
            UIListLayout.Parent = ScrollingFrame
            local Lighting = game:GetService("Lighting")
            local Terrain = workspace.Terrain
            local function v20(p2, p3)
                local TextButton = Instance.new("TextButton")
                TextButton.Size = UDim2.new(1, 0, 0, 34)
                TextButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                TextButton.BorderColor3 = Color3.new(0, 0, 0)
                TextButton.BorderSizePixel = 1
                TextButton.Text = p2
                TextButton.BackgroundTransparency = 0
                TextButton.TextColor3 = Color3.new(1, 1, 1)
                TextButton.Font = Enum.Font.GothamSemibold
                TextButton.TextSize = 13
                TextButton.Parent = ScrollingFrame
                UICorner:Clone().Parent = TextButton
                TextButton.MouseButton1Click:Connect(function()
                    for _, child in pairs(Lighting:GetChildren()) do
                        if child:IsA("Atmosphere") or child:IsA("Sky") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then
                            child:Destroy()
                        end
                    end
                    for _, child in pairs(Terrain:GetChildren()) do
                        if child:IsA("Clouds") then
                            child:Destroy()
                        end
                    end
                    p3()
                end)
            end
            v20("Daytime", function()
                Lighting.Ambient = Color3.fromRGB(0, 0, 0)
                Lighting.Brightness = 3.13
                Lighting.ClockTime = 14.5
                Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                Lighting.ColorShift_Top = Color3.fromRGB(188, 141, 1)
                Lighting.EnvironmentDiffuseScale = 0.583
                Lighting.EnvironmentSpecularScale = 1
                Lighting.ExposureCompensation = 0
                Lighting.FogColor = Color3.fromRGB(146, 208, 255)
                Lighting.FogEnd = 3000
                Lighting.FogStart = 300
                Lighting.GeographicLatitude = 143
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = Color3.fromRGB(145, 128, 95)
                Lighting.ShadowSoftness = 0.04
                Lighting.TimeOfDay = "14:30:00"
                sethiddenproperty(Lighting, "Technology", Enum.Technology.ShadowMap)
                Terrain.WaterColor = Color3.fromRGB(0, 0, 0)
                Terrain.WaterReflectance = 0.55
                Terrain.WaterTransparency = 0
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 10
                sethiddenproperty(Terrain, "Decoration", true)
                sethiddenproperty(Terrain, "GrassLength", 0.7)
                local BloomEffect = Instance.new("BloomEffect")
                BloomEffect.Intensity = 1
                BloomEffect.Size = 90
                BloomEffect.Threshold = 2
                BloomEffect.Enabled = true
                BloomEffect.Parent = Lighting
                local Sky = Instance.new("Sky")
                Sky.CelestialBodiesShown = false
                Sky.MoonAngularSize = 11
                Sky.MoonTextureId = "rbxassetid://6444320592"
                Sky.SkyboxBk = "rbxassetid://6444884337"
                Sky.SkyboxDn = "rbxassetid://6444884785"
                Sky.SkyboxFt = "rbxassetid://6444884337"
                Sky.SkyboxLf = "rbxassetid://6444884337"
                Sky.SkyboxRt = "rbxassetid://6444884337"
                Sky.SkyboxUp = "rbxassetid://6412503613"
                Sky.StarCount = 0
                Sky.SunAngularSize = 11
                Sky.SunTextureId = "rbxassetid://1084351190"
                Sky.Parent = Lighting
                local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
                ColorCorrectionEffect.Brightness = 0.04
                ColorCorrectionEffect.Contrast = 0.19
                ColorCorrectionEffect.Saturation = 0.12
                ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255)
                ColorCorrectionEffect.Enabled = true
                ColorCorrectionEffect.Parent = Lighting
                Terrain:SetMaterialColor(Enum.Material.Sandstone, Color3.fromRGB(255, 250, 225))
                Terrain:SetMaterialColor(Enum.Material.Limestone, Color3.fromRGB(103, 85, 78))
                Terrain:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(102, 92, 59))
                Terrain:SetMaterialColor(Enum.Material.Glacier, Color3.fromRGB(207, 187, 169))
                Terrain:SetMaterialColor(Enum.Material.Cobblestone, Color3.fromRGB(134, 134, 118))
                Terrain:SetMaterialColor(Enum.Material.Salt, Color3.fromRGB(193, 184, 167))
                Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(106, 127, 63))
                Terrain:SetMaterialColor(Enum.Material.CrackedLava, Color3.fromRGB(232, 156, 74))
                Terrain:SetMaterialColor(Enum.Material.WoodPlanks, Color3.fromRGB(139, 109, 79))
                Terrain:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(115, 132, 74))
                Terrain:SetMaterialColor(Enum.Material.Ice, Color3.fromRGB(129, 194, 224))
                Terrain:SetMaterialColor(Enum.Material.Asphalt, Color3.fromRGB(115, 123, 107))
                Terrain:SetMaterialColor(Enum.Material.Brick, Color3.fromRGB(138, 86, 62))
                Terrain:SetMaterialColor(Enum.Material.Mud, Color3.fromRGB(58, 46, 36))
                Terrain:SetMaterialColor(Enum.Material.Pavement, Color3.fromRGB(148, 148, 140))
                Terrain:SetMaterialColor(Enum.Material.Snow, Color3.fromRGB(195, 199, 218))
                Terrain:SetMaterialColor(Enum.Material.Concrete, Color3.fromRGB(127, 102, 63))
                Terrain:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(193, 184, 167))
                Terrain:SetMaterialColor(Enum.Material.Basalt, Color3.fromRGB(30, 30, 37))
                Terrain:SetMaterialColor(Enum.Material.Rock, Color3.fromRGB(102, 108, 111))
                Terrain:SetMaterialColor(Enum.Material.Sand, Color3.fromRGB(255, 239, 233))
            end)
            v20("Sunset", function()
                Lighting.Ambient = Color3.fromRGB(172, 172, 172)
                Lighting.Brightness = 3.8
                Lighting.ClockTime = 7.1
                Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                Lighting.ColorShift_Top = Color3.fromRGB(255, 174, 43)
                Lighting.EnvironmentDiffuseScale = 0.3
                Lighting.EnvironmentSpecularScale = 0.06
                Lighting.ExposureCompensation = -0.24
                Lighting.FogColor = Color3.fromRGB(0, 0, 0)
                Lighting.FogEnd = 100000000
                Lighting.FogStart = 20
                Lighting.GeographicLatitude = 72
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
                Lighting.ShadowSoftness = 0.1
                Lighting.TimeOfDay = "07:06:00"
                sethiddenproperty(Lighting, "Technology", Enum.Technology.Future)
                Terrain.WaterColor = Color3.fromRGB(74, 85, 92)
                Terrain.WaterReflectance = 1
                Terrain.WaterTransparency = 1
                Terrain.WaterWaveSize = 0.5
                Terrain.WaterWaveSpeed = 10
                sethiddenproperty(Terrain, "Decoration", true)
                sethiddenproperty(Terrain, "GrassLength", 0.7)
                local BloomEffect = Instance.new("BloomEffect")
                BloomEffect.Intensity = 1
                BloomEffect.Size = 56
                BloomEffect.Threshold = 1.824
                BloomEffect.Enabled = true
                BloomEffect.Parent = Lighting
                local Sky = Instance.new("Sky")
                Sky.CelestialBodiesShown = true
                Sky.MoonAngularSize = 0
                Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
                Sky.SkyboxBk = "rbxassetid://1009082031"
                Sky.SkyboxDn = "rbxassetid://1009082487"
                Sky.SkyboxFt = "rbxassetid://1009082252"
                Sky.SkyboxLf = "rbxassetid://1009082137"
                Sky.SkyboxRt = "rbxassetid://1009081946"
                Sky.SkyboxUp = "rbxassetid://1009082428"
                Sky.StarCount = 3000
                Sky.SunAngularSize = 9
                Sky.SunTextureId = "rbxasset://sky/sun.jpg"
                Sky.Parent = Lighting
                local SunRaysEffect = Instance.new("SunRaysEffect")
                SunRaysEffect.Intensity = 0.18
                SunRaysEffect.Spread = 0.12
                SunRaysEffect.Enabled = true
                SunRaysEffect.Parent = Lighting
                local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
                ColorCorrectionEffect.Brightness = 0
                ColorCorrectionEffect.Contrast = 0.1
                ColorCorrectionEffect.Saturation = -0.2
                ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255)
                ColorCorrectionEffect.Enabled = true
                ColorCorrectionEffect.Parent = Lighting
                local Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Color = Color3.fromRGB(199, 170, 107)
                Atmosphere.Decay = Color3.fromRGB(92, 60, 13)
                Atmosphere.Density = 0.42
                Atmosphere.Glare = 0
                Atmosphere.Haze = 0
                Atmosphere.Offset = 0
                Atmosphere.Parent = Lighting
                Terrain:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(109, 109, 109))
                Terrain:SetMaterialColor(Enum.Material.Rock, Color3.fromRGB(75, 75, 75))
                Terrain:SetMaterialColor(Enum.Material.WoodPlanks, Color3.fromRGB(139, 109, 79))
                Terrain:SetMaterialColor(Enum.Material.Brick, Color3.fromRGB(138, 86, 62))
                Terrain:SetMaterialColor(Enum.Material.Cobblestone, Color3.fromRGB(132, 123, 90))
                Terrain:SetMaterialColor(Enum.Material.Sandstone, Color3.fromRGB(137, 90, 71))
                Terrain:SetMaterialColor(Enum.Material.Mud, Color3.fromRGB(48, 89, 66))
                Terrain:SetMaterialColor(Enum.Material.Basalt, Color3.fromRGB(30, 30, 37))
                Terrain:SetMaterialColor(Enum.Material.Concrete, Color3.fromRGB(127, 102, 63))
                Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(84, 102, 71))
                Terrain:SetMaterialColor(Enum.Material.Limestone, Color3.fromRGB(206, 173, 148))
                Terrain:SetMaterialColor(Enum.Material.Glacier, Color3.fromRGB(101, 176, 234))
                Terrain:SetMaterialColor(Enum.Material.Salt, Color3.fromRGB(198, 189, 181))
                Terrain:SetMaterialColor(Enum.Material.Sand, Color3.fromRGB(143, 126, 95))
                Terrain:SetMaterialColor(Enum.Material.Pavement, Color3.fromRGB(148, 148, 140))
                Terrain:SetMaterialColor(Enum.Material.Asphalt, Color3.fromRGB(124, 124, 124))
                Terrain:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(115, 132, 74))
                Terrain:SetMaterialColor(Enum.Material.Ice, Color3.fromRGB(129, 194, 224))
                Terrain:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(95, 87, 68))
                Terrain:SetMaterialColor(Enum.Material.Snow, Color3.fromRGB(195, 199, 218))
                Terrain:SetMaterialColor(Enum.Material.CrackedLava, Color3.fromRGB(232, 156, 74))
            end)
            v20("Night", function()
                Lighting.Ambient = Color3.fromRGB(0, 0, 0)
                Lighting.Brightness = 2
                Lighting.ClockTime = 3
                Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
                Lighting.EnvironmentDiffuseScale = 0
                Lighting.EnvironmentSpecularScale = 0
                Lighting.ExposureCompensation = 0
                Lighting.FogColor = Color3.fromRGB(0, 0, 0)
                Lighting.FogEnd = 700
                Lighting.FogStart = 54325
                Lighting.GeographicLatitude = 41.733
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
                Lighting.ShadowSoftness = 0.2
                Lighting.TimeOfDay = "03:00:00"
                sethiddenproperty(Lighting, "Technology", Enum.Technology.Future)
                Terrain.WaterColor = Color3.fromRGB(12, 84, 92)
                Terrain.WaterReflectance = 1
                Terrain.WaterTransparency = 0.3
                Terrain.WaterWaveSize = 0.15
                Terrain.WaterWaveSpeed = 10
                sethiddenproperty(Terrain, "Decoration", false)
                sethiddenproperty(Terrain, "GrassLength", 0.7)
                local BlurEffect = Instance.new("BlurEffect")
                BlurEffect.Size = 0
                BlurEffect.Enabled = true
                BlurEffect.Parent = Lighting
                local Sky = Instance.new("Sky")
                Sky.CelestialBodiesShown = true
                Sky.MoonAngularSize = 11
                Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
                Sky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
                Sky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
                Sky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
                Sky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
                Sky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
                Sky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
                Sky.StarCount = 5000
                Sky.SunAngularSize = 21
                Sky.SunTextureId = "rbxasset://sky/sun.jpg"
                Sky.Parent = Lighting
                local Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Color = Color3.fromRGB(0, 0, 0)
                Atmosphere.Decay = Color3.fromRGB(0, 0, 0)
                Atmosphere.Density = 0.56
                Atmosphere.Glare = 0
                Atmosphere.Haze = 0
                Atmosphere.Offset = 0
                Atmosphere.Parent = Lighting
                Terrain:SetMaterialColor(Enum.Material.Brick, Color3.fromRGB(138, 86, 62))
                Terrain:SetMaterialColor(Enum.Material.CrackedLava, Color3.fromRGB(232, 156, 74))
                Terrain:SetMaterialColor(Enum.Material.Ice, Color3.fromRGB(129, 194, 224))
                Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(106, 127, 63))
                Terrain:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(115, 132, 74))
                Terrain:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(102, 92, 59))
                Terrain:SetMaterialColor(Enum.Material.Sandstone, Color3.fromRGB(137, 90, 71))
                Terrain:SetMaterialColor(Enum.Material.Limestone, Color3.fromRGB(206, 173, 148))
                Terrain:SetMaterialColor(Enum.Material.Salt, Color3.fromRGB(198, 189, 181))
                Terrain:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(63, 127, 107))
                Terrain:SetMaterialColor(Enum.Material.Concrete, Color3.fromRGB(127, 102, 63))
                Terrain:SetMaterialColor(Enum.Material.Pavement, Color3.fromRGB(148, 148, 140))
                Terrain:SetMaterialColor(Enum.Material.WoodPlanks, Color3.fromRGB(139, 109, 79))
                Terrain:SetMaterialColor(Enum.Material.Sand, Color3.fromRGB(143, 126, 95))
                Terrain:SetMaterialColor(Enum.Material.Snow, Color3.fromRGB(195, 199, 218))
                Terrain:SetMaterialColor(Enum.Material.Basalt, Color3.fromRGB(30, 30, 37))
                Terrain:SetMaterialColor(Enum.Material.Cobblestone, Color3.fromRGB(132, 123, 90))
                Terrain:SetMaterialColor(Enum.Material.Asphalt, Color3.fromRGB(115, 123, 107))
                Terrain:SetMaterialColor(Enum.Material.Glacier, Color3.fromRGB(101, 176, 234))
                Terrain:SetMaterialColor(Enum.Material.Mud, Color3.fromRGB(58, 46, 36))
                Terrain:SetMaterialColor(Enum.Material.Rock, Color3.fromRGB(102, 108, 111))
            end)
            v20("Cloudy", function()
                Lighting.Ambient = Color3.fromRGB(0, 0, 0)
                Lighting.Brightness = 5.63
                Lighting.ClockTime = 17.6289
                Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                Lighting.ColorShift_Top = Color3.fromRGB(207, 114, 0)
                Lighting.EnvironmentDiffuseScale = 0.583
                Lighting.EnvironmentSpecularScale = 1
                Lighting.ExposureCompensation = 0.63
                Lighting.FogColor = Color3.fromRGB(146, 208, 255)
                Lighting.FogEnd = 3000
                Lighting.FogStart = 300
                Lighting.GeographicLatitude = 21.5893
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = Color3.fromRGB(89, 68, 47)
                Lighting.ShadowSoftness = 0.04
                Lighting.TimeOfDay = "17:37:44"
                sethiddenproperty(Lighting, "Technology", Enum.Technology.ShadowMap)
                Terrain.WaterColor = Color3.fromRGB(0, 0, 0)
                Terrain.WaterReflectance = 0.55
                Terrain.WaterTransparency = 0
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 10
                sethiddenproperty(Terrain, "Decoration", true)
                sethiddenproperty(Terrain, "GrassLength", 0.7)
                local BloomEffect = Instance.new("BloomEffect")
                BloomEffect.Intensity = 1
                BloomEffect.Size = 90
                BloomEffect.Threshold = 2
                BloomEffect.Enabled = true
                BloomEffect.Parent = Lighting
                local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
                ColorCorrectionEffect.Brightness = 0.04
                ColorCorrectionEffect.Contrast = 0.15
                ColorCorrectionEffect.Saturation = 0.2
                ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255)
                ColorCorrectionEffect.Enabled = true
                ColorCorrectionEffect.Parent = Lighting
                local Sky = Instance.new("Sky")
                Sky.CelestialBodiesShown = true
                Sky.MoonAngularSize = 1.5
                Sky.MoonTextureId = "rbxassetid://1075087760"
                Sky.SkyboxBk = "rbxassetid://2177969403"
                Sky.SkyboxDn = "rbxassetid://2177972406"
                Sky.SkyboxFt = "rbxassetid://2177970251"
                Sky.SkyboxLf = "rbxassetid://2177969836"
                Sky.SkyboxRt = "rbxassetid://2177968823"
                Sky.SkyboxUp = "rbxassetid://2177971305"
                Sky.StarCount = 500
                Sky.SunAngularSize = 3
                Sky.SunTextureId = "rbxasset://sky/sun.jpg"
                Sky.Parent = Lighting
                local SunRaysEffect = Instance.new("SunRaysEffect")
                SunRaysEffect.Intensity = 0.004
                SunRaysEffect.Spread = 0.167
                SunRaysEffect.Enabled = true
                SunRaysEffect.Parent = Lighting
                local Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Color = Color3.fromRGB(165, 165, 165)
                Atmosphere.Decay = Color3.fromRGB(16, 16, 16)
                Atmosphere.Density = 0.357
                Atmosphere.Glare = 0.21
                Atmosphere.Haze = 1.46
                Atmosphere.Offset = 0
                Atmosphere.Parent = Lighting
                Terrain:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(115, 132, 74))
                Terrain:SetMaterialColor(Enum.Material.Basalt, Color3.fromRGB(30, 30, 37))
                Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(106, 127, 63))
                Terrain:SetMaterialColor(Enum.Material.Cobblestone, Color3.fromRGB(134, 134, 118))
                Terrain:SetMaterialColor(Enum.Material.Sandstone, Color3.fromRGB(255, 250, 225))
                Terrain:SetMaterialColor(Enum.Material.Pavement, Color3.fromRGB(148, 148, 140))
                Terrain:SetMaterialColor(Enum.Material.WoodPlanks, Color3.fromRGB(139, 109, 79))
                Terrain:SetMaterialColor(Enum.Material.Snow, Color3.fromRGB(195, 199, 218))
                Terrain:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(193, 184, 167))
                Terrain:SetMaterialColor(Enum.Material.Sand, Color3.fromRGB(255, 239, 233))
                Terrain:SetMaterialColor(Enum.Material.Glacier, Color3.fromRGB(207, 187, 169))
                Terrain:SetMaterialColor(Enum.Material.Brick, Color3.fromRGB(138, 86, 62))
                Terrain:SetMaterialColor(Enum.Material.Ice, Color3.fromRGB(129, 194, 224))
                Terrain:SetMaterialColor(Enum.Material.Limestone, Color3.fromRGB(103, 85, 78))
                Terrain:SetMaterialColor(Enum.Material.Salt, Color3.fromRGB(193, 184, 167))
                Terrain:SetMaterialColor(Enum.Material.Concrete, Color3.fromRGB(127, 102, 63))
                Terrain:SetMaterialColor(Enum.Material.Asphalt, Color3.fromRGB(115, 123, 107))
                Terrain:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(102, 92, 59))
                Terrain:SetMaterialColor(Enum.Material.Mud, Color3.fromRGB(58, 46, 36))
                Terrain:SetMaterialColor(Enum.Material.Rock, Color3.fromRGB(102, 108, 111))
                Terrain:SetMaterialColor(Enum.Material.CrackedLava, Color3.fromRGB(232, 156, 74))
            end)
            v20("Shore", function()
                Lighting.Ambient = Color3.fromRGB(109, 117, 135)
                Lighting.Brightness = 1.921
                Lighting.ClockTime = -6.39972
                Lighting.ColorShift_Bottom = Color3.fromRGB(248, 165, 159)
                Lighting.ColorShift_Top = Color3.fromRGB(226, 75, 0)
                Lighting.EnvironmentDiffuseScale = 0.172
                Lighting.EnvironmentSpecularScale = 0.638
                Lighting.ExposureCompensation = -0.2
                Lighting.FogColor = Color3.fromRGB(192, 192, 192)
                Lighting.FogEnd = 100000
                Lighting.FogStart = 0
                Lighting.GeographicLatitude = 0
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = Color3.fromRGB(36, 47, 58)
                Lighting.ShadowSoftness = 0.25
                Lighting.TimeOfDay = "-06:23:59"
                sethiddenproperty(Lighting, "Technology", Enum.Technology.ShadowMap)
                Terrain.WaterColor = Color3.fromRGB(58, 74, 85)
                Terrain.WaterReflectance = 1
                Terrain.WaterTransparency = 1
                Terrain.WaterWaveSize = 0.2
                Terrain.WaterWaveSpeed = 6
                sethiddenproperty(Terrain, "Decoration", true)
                sethiddenproperty(Terrain, "GrassLength", 0.5)
                local SunRaysEffect = Instance.new("SunRaysEffect")
                SunRaysEffect.Intensity = 0.024
                SunRaysEffect.Spread = 0.463
                SunRaysEffect.Enabled = true
                SunRaysEffect.Parent = Lighting
                local BloomEffect = Instance.new("BloomEffect")
                BloomEffect.Intensity = 1
                BloomEffect.Size = 50
                BloomEffect.Threshold = 2.2912
                BloomEffect.Enabled = true
                BloomEffect.Parent = Lighting
                local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
                ColorCorrectionEffect.Brightness = 0
                ColorCorrectionEffect.Contrast = 0.2
                ColorCorrectionEffect.Saturation = 0
                ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255)
                ColorCorrectionEffect.Enabled = true
                ColorCorrectionEffect.Parent = Lighting
                local Sky = Instance.new("Sky")
                Sky.CelestialBodiesShown = true
                Sky.MoonAngularSize = 0
                Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
                Sky.SkyboxBk = "rbxassetid://88585370973398"
                Sky.SkyboxDn = "rbxassetid://128014535205529"
                Sky.SkyboxFt = "rbxassetid://85323615042244"
                Sky.SkyboxLf = "rbxassetid://77415797450913"
                Sky.SkyboxRt = "rbxassetid://127566931602371"
                Sky.SkyboxUp = "rbxassetid://102320981098060"
                Sky.StarCount = 5000
                Sky.SunAngularSize = 4
                Sky.SunTextureId = "rbxasset://sky/sun.jpg"
                Sky.Parent = Lighting
                local Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Color = Color3.fromRGB(255, 216, 194)
                Atmosphere.Decay = Color3.fromRGB(123, 151, 182)
                Atmosphere.Density = 0.359
                Atmosphere.Glare = 2.97
                Atmosphere.Haze = 1.52
                Atmosphere.Offset = 0
                Atmosphere.Parent = Lighting
                local BlurEffect = Instance.new("BlurEffect")
                BlurEffect.Size = 4
                BlurEffect.Enabled = false
                BlurEffect.Parent = Lighting
                Terrain:SetMaterialColor(Enum.Material.Snow, Color3.fromRGB(235, 253, 255))
                Terrain:SetMaterialColor(Enum.Material.Basalt, Color3.fromRGB(75, 74, 74))
                Terrain:SetMaterialColor(Enum.Material.Glacier, Color3.fromRGB(221, 228, 229))
                Terrain:SetMaterialColor(Enum.Material.Cobblestone, Color3.fromRGB(134, 134, 118))
                Terrain:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(140, 130, 104))
                Terrain:SetMaterialColor(Enum.Material.Rock, Color3.fromRGB(99, 100, 102))
                Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(173, 179, 203))
                Terrain:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(88, 89, 86))
                Terrain:SetMaterialColor(Enum.Material.LeafyGrass, Color3.fromRGB(106, 134, 64))
                Terrain:SetMaterialColor(Enum.Material.Ice, Color3.fromRGB(204, 210, 223))
                Terrain:SetMaterialColor(Enum.Material.Salt, Color3.fromRGB(255, 255, 254))
                Terrain:SetMaterialColor(Enum.Material.Pavement, Color3.fromRGB(143, 144, 135))
                Terrain:SetMaterialColor(Enum.Material.Asphalt, Color3.fromRGB(80, 84, 84))
                Terrain:SetMaterialColor(Enum.Material.Limestone, Color3.fromRGB(255, 243, 192))
                Terrain:SetMaterialColor(Enum.Material.Mud, Color3.fromRGB(121, 112, 98))
                Terrain:SetMaterialColor(Enum.Material.Brick, Color3.fromRGB(138, 97, 73))
                Terrain:SetMaterialColor(Enum.Material.Sandstone, Color3.fromRGB(148, 124, 95))
                Terrain:SetMaterialColor(Enum.Material.Sand, Color3.fromRGB(207, 203, 167))
                Terrain:SetMaterialColor(Enum.Material.WoodPlanks, Color3.fromRGB(172, 148, 108))
                Terrain:SetMaterialColor(Enum.Material.CrackedLava, Color3.fromRGB(255, 24, 67))
                Terrain:SetMaterialColor(Enum.Material.Concrete, Color3.fromRGB(152, 152, 152))
            end)
        else
            local _ = p1[1]
        end
    end
    local v6 = _tonumber
    local v7 = match
    local v8 = match
    local t1 = {}
    v52(t1, 1, _pcall(v5, nil))
    if v6(v7(v8(t1[2], ":%d+:"), "%d+")) == 1 then
        return v5({})
    end
    return u4()
end
return u4()
