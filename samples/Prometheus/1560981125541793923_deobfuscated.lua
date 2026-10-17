-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("Players"),
	value2 = game:GetService("RunService"),
	value3 = game:GetService("CoreGui"),
	value4 = game:GetService("Workspace"),
	value5 = game:GetService("UserInputService"),
	value6 = game:GetService("HttpService"),
	value7 = game:GetService("StarterGui")
}

t1.value8 = t1.value1.LocalPlayer
while not t1.value8 do
    task.wait(0.1)
    t1.value8 = t1.value1.LocalPlayer
end
t1.value9 = nil
t1.value10 = nil
t1.value11 = {}
t1.value12 = {}
t1.value13 = {}
t1.value14 = {}
t1.value15 = "KIXDEV_AvatarChanger"
t1.value16 = t1.value15 .. "/Avatars"
t1.value17 = t1.value15 .. "/Clans"
function t1.value18(p1, p2, p3)

    local u62 = p2
    local u63 = p3
    pcall(function()
        local value7 = t1.value7
        local SetCore = value7.SetCore
        local v604 = p1
        local v605 = u62
        local v606 = u63 or 4

        SetCore(value7, "SendNotification", {
			Title = v604,
			Text = v605,
			Duration = v606
		})
    end)
end
function t1.value19(p4)
    local u46 = p4
    pcall(function()
        local _syn = syn

        if _syn then
            _syn = type(syn.protect_gui) == "function"
        end

        if _syn then
            syn.protect_gui(u46)

            return
        end
    end)
    pcall(function()
        if type(protect_gui) == "function" then
            protect_gui(u46)
        end
    end)
end
function t1.value20(p5)
    local t2 = {}

    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)

        if ok and result then
            table.insert(t2, result)
        end
    end

    table.insert(t2, t1.value3)

    local value8 = t1.value8

    if value8 then
        value8 = t1.value8:FindFirstChild("PlayerGui")

        if not value8 then
            value8 = t1.value8:WaitForChild("PlayerGui", 3)
        end
    end

    if value8 then
        table.insert(t2, value8)
    end

    for _, v in ipairs(t2) do
        local v57 = v
        local ok = pcall(function()
            p5.Parent = v57
        end)

        if ok then
            ok = v57 == p5.Parent
        end

        if ok then
            return true
        end
    end

    return false
end
t1.value21 = nil
function t1.value21(p6)
    if type(isfile) ~= "function" then
        return false
    end

    local ok, result = pcall(isfile, p6)

    if ok then
        ok = result == true
    end

    return ok
end
function t1.value22(p7)
    if not t1.value21(p7) then
        return nil
    end

    local ok, result = pcall(readfile, p7)

    if ok then
        ok = type(result) == "string"
    end

    if ok then
        return result
    end

    return nil
end
function t1.value23(p8)
    if type(delfile) ~= "function" then
        return false
    end

    return (pcall(delfile, p8))
end
function t1.value24(p9)
    if type(listfiles) ~= "function" then
        return {}
    end

    local ok, result = pcall(listfiles, p9)

    if ok then
        ok = type(result) == "table"
    end

    if ok then
        return result
    end

    return {}
end
t1.value25 = nil
function t1.value25(p10)
    if type(makefolder) ~= "function" then
        return
    end

    local v72

    if type(isfolder) ~= "function" then
        v72 = false
    else
        local result

        v72, result = pcall(isfolder, p10)

        if v72 then
            v72 = result == true
        end
    end

    if v72 then
        return
    end

    pcall(makefolder, p10)
end
function t1.value26()
    local v64 = type(writefile) == "function"

    if v64 then
        v64 = type(readfile) == "function"

        if v64 then
            v64 = type(isfile) == "function"

            if not v64 then
                v64 = type(listfiles) == "function"
            end
        end
    end

    return v64
end
function t1.value27()
    pcall(function()
        t1.value25(t1.value15)
        t1.value25(t1.value16)
        t1.value25(t1.value17)
    end)
end
function t1.value28(p11)
    local _tostring = tostring

    if not p11 then
        p11 = ""
    end

    local v39 = _tostring(p11):gsub("^%s+", ""):gsub("%s+$", "")

    if v39 == "" then
        v39 = "Avatar_" .. tostring(os.time())
    end

    return v39:gsub("[\\/:*?\"<>|]", "_")
end
function t1.value29(p12)
    return t1.value16 .. "/" .. t1.value28(p12) .. ".json"
end
function t1.value30(p13)
    return {
		p13.X,
		p13.Y,
		p13.Z
	}
end
function t1.value31(p14)
    if type(p14) ~= "table" then
        return Vector3.zero
    end

    return Vector3.new(tonumber(p14[1]) or 0, tonumber(p14[2]) or 0, tonumber(p14[3]) or 0)
end
t1.value32 = {
	"Size",
	"Position",
	"AnchorPoint",
	"BackgroundColor3",
	"BackgroundTransparency",
	"BorderSizePixel",
	"BorderColor3",
	"ZIndex",
	"Visible",
	"LayoutOrder",
	"Text",
	"TextColor3",
	"TextTransparency",
	"TextScaled",
	"TextSize",
	"TextWrapped",
	"TextXAlignment",
	"TextYAlignment",
	"Font",
	"FontFace",
	"RichText",
	"TextStrokeTransparency",
	"TextStrokeColor3",
	"LineHeight",
	"Image",
	"ImageColor3",
	"ImageTransparency",
	"ScaleType",
	"SliceCenter",
	"ImageRectOffset",
	"ImageRectSize",
	"TileSize",
	"ExtentsOffset",
	"ExtentsOffsetWorldSpace",
	"StudsOffset",
	"StudsOffsetWorldSpace",
	"AlwaysOnTop",
	"MaxDistance",
	"SizeOffset",
	"LightInfluence",
	"ResetOnSpawn",
	"Active",
	"ClipsDescendants",
	"Brightness",
	"CornerRadius",
	"Thickness",
	"Color",
	"Transparency",
	"Enabled",
	"LineJoinMode",
	"ApplyStrokeMode",
	"Rotation",
	"Offset"
}
function t1.value33(p15, p16)
    if type(p15) ~= "table" then
        return p16
    end

    local v84 = p15[1]
    local v85 = p15[2]
    local v86 = p15[3]

    if type(v84) ~= "number" or v84 ~= v84 then
        v84 = p16 and p16.R or 0
    end

    if type(v85) ~= "number" or v85 ~= v85 then
        v85 = p16 and p16.G or 0
    end

    if type(v86) ~= "number" or v86 ~= v86 then
        v86 = p16 and p16.B or 0
    end

    return Color3.new(v84, v85, v86)
end
t1.value34 = nil
function t1.value34(p17)
    local ClassName = p17.ClassName
    local p17Name = p17.Name
    local t3 = {
		ClassName = ClassName,
		Name = p17Name,
		Properties = {},
		Children = {}
	}
    for v93, v94 in ipairs(t1.value32) do

        local v95 = v94
        local ok, result = pcall(function()
            return p17[v95]
        end)

        if ok then
            ok = result ~= nil
        end

        if ok then
            if typeof(result) == "Color3" then
                local Properties = t3.Properties
                local t4 = {
					result.R,
					result.G,
					result.B
				}

                Properties[v95] = {
					Type = "Color3",
					Value = t4
				}
            elseif typeof(result) == "UDim2" then
                local Properties = t3.Properties
                local t5 = {
					result.X.Scale,
					result.X.Offset,
					result.Y.Scale,
					result.Y.Offset
				}

                Properties[v95] = {
					Type = "UDim2",
					Value = t5
				}
            elseif typeof(result) == "UDim" then
                local Properties = t3.Properties
                local t6 = {
					result.Scale,
					result.Offset
				}

                Properties[v95] = {
					Type = "UDim",
					Value = t6
				}
            elseif typeof(result) == "Vector3" then
                local Properties = t3.Properties
                local t7 = {
					result.X,
					result.Y,
					result.Z
				}

                Properties[v95] = {
					Type = "Vector3",
					Value = t7
				}
            elseif typeof(result) == "Vector2" then
                local Properties = t3.Properties
                local t8 = {
					result.X,
					result.Y
				}

                Properties[v95] = {
					Type = "Vector2",
					Value = t8
				}
            elseif typeof(result) == "Rect" then
                local Properties = t3.Properties
                local t9 = {
					result.Min.X,
					result.Min.Y,
					result.Max.X,
					result.Max.Y
				}

                Properties[v95] = {
					Type = "Rect",
					Value = t9
				}
            elseif typeof(result) == "EnumItem" then
                local Properties = t3.Properties
                local str = tostring(result.EnumType)
                local resultValue = result.Value

                Properties[v95] = {
					Type = "EnumItem",
					EnumType = str,
					Value = resultValue
				}
            elseif typeof(result) == "ColorSequence" then
                local t10 = {}

                for _, v in ipairs(result.Keypoints) do
                    local insert = table.insert
                    local Time = v.Time
                    local t11 = {
						v.Value.R,
						v.Value.G,
						v.Value.B
					}

                    insert(t10, {
						Time = Time,
						Value = t11
					})
                end

                t3.Properties[v95] = {
					Type = "ColorSequence",
					Value = t10
				}
            elseif typeof(result) == "NumberSequence" then
                local t12 = {}

                for _, v in ipairs(result.Keypoints) do
                    local insert = table.insert
                    local Time = v.Time
                    local vValue = v.Value
                    local Envelope = v.Envelope

                    insert(t12, {
						Time = Time,
						Value = vValue,
						Envelope = Envelope
					})
                end

                t3.Properties[v95] = {
					Type = "NumberSequence",
					Value = t12
				}
            elseif typeof(result) == "Font" then
                local Properties = t3.Properties
                local Family = result.Family
                local WeightName = result.Weight.Name
                local StyleName = result.Style.Name

                Properties[v95] = {
					Type = "Font",
					Family = Family,
					Weight = WeightName,
					Style = StyleName
				}
            elseif type(result) == "number" then
                if result == math.huge then
                    t3.Properties[v95] = {
						Type = "Primitive_Huge",
						Value = "Infinity"
					}
                elseif result == -math.huge then
                    t3.Properties[v95] = {
						Type = "Primitive_Huge",
						Value = "-Infinity"
					}
                elseif result == result then
                    t3.Properties[v95] = {
						Type = "Primitive",
						Value = result
					}
                end
            else
                local v130 = type(result) == "string"

                if not v130 then
                    v130 = type(result) == "boolean"
                end

                if v130 then
                    t3.Properties[v95] = {
						Type = "Primitive",
						Value = result
					}
                end
            end
        end
    end
    local ok, result = pcall(function()
        return p17.Adornee
    end)
    if ok then
        ok = result

        if result then
            ok = result:IsA("BasePart")
        end
    end
    if ok then
        t3.AdorneeName = result.Name
    end
    for _, child in ipairs(p17:GetChildren()) do
        table.insert(t3.Children, t1.value34(child))
    end

    return t3
end
t1.value35 = {
	"Size",
	"Position",
	"AnchorPoint",
	"BackgroundColor3",
	"BorderColor3",
	"TextColor3",
	"TextStrokeColor3",
	"ImageColor3",
	"Color",
	"BackgroundTransparency",
	"TextTransparency",
	"TextStrokeTransparency",
	"ImageTransparency",
	"Transparency",
	"Font",
	"FontFace",
	"TextSize",
	"TextScaled"
}
t1.value36 = nil
function t1.value36(p18, p19, p20)
    local u202
    local ok, _ = pcall(function()
        u202 = Instance.new(p18.ClassName)
    end)
    local v205 = not ok
    if not v205 then
        v205 = not u202
    end
    if v205 then
        return nil
    end
    u202.Name = p18.Name
    local t13 = {}
    local function v207(p21, p22)
        if not p22 then
            return
        end

        pcall(function()
            if p22.Type == "Color3" then
                u202[p21] = t1.value33(p22.Value, Color3.new(0, 0, 0))

                return
            end

            if p22.Type == "UDim2" then
                local v834 = p22.Value or {
					0,
					0,
					0,
					0
				}

                u202[p21] = UDim2.new(v834[1] or 0, v834[2] or 0, v834[3] or 0, v834[4] or 0)

                return
            end

            if p22.Type == "UDim" then
                local v835 = p22.Value or {
					0,
					0
				}

                u202[p21] = UDim.new(v835[1] or 0, v835[2] or 0)

                return
            end

            if p22.Type == "Vector3" then
                local v836 = p22.Value or {
					0,
					0,
					0
				}

                u202[p21] = Vector3.new(v836[1] or 0, v836[2] or 0, v836[3] or 0)

                return
            end

            if p22.Type == "Vector2" then
                local v837 = p22.Value or {
					0,
					0
				}

                u202[p21] = Vector2.new(v837[1] or 0, v837[2] or 0)

                return
            end

            if p22.Type == "Rect" then
                local v838 = p22.Value or {
					0,
					0,
					0,
					0
				}

                u202[p21] = Rect.new(v838[1] or 0, v838[2] or 0, v838[3] or 0, v838[4] or 0)

                return
            end

            if p22.Type == "EnumItem" then
                local v839 = Enum[p22.EnumType]

                if v839 then
                    for _, v in ipairs(v839:GetEnumItems()) do
                        if v.Value == p22.Value then
                            u202[p21] = v

                            return
                        end
                    end

                    return
                end
            elseif p22.Type == "ColorSequence" then
                local t14 = {}
                for v845, v846 in ipairs(p22.Value or {}) do

                    local insert = table.insert
                    local new = ColorSequenceKeypoint.new
                    local Time = v846.Time
                    local value33 = t1.value33

                    insert(t14, new(Time or 0, value33(v846.Value, Color3.new(1, 1, 1))))
                end
                if #t14 >= 2 then
                    u202[p21] = ColorSequence.new(t14)

                    return
                end
                if #t14 == 1 then
                    u202[p21] = ColorSequence.new(t14[1].Value)

                    return
                end
            elseif p22.Type == "NumberSequence" then
                local t15 = {}
                for v854, v855 in ipairs(p22.Value or {}) do

                    table.insert(t15, NumberSequenceKeypoint.new(v855.Time or 0, v855.Value or 0, v855.Envelope or 0))
                end
                if #t15 >= 2 then
                    u202[p21] = NumberSequence.new(t15)

                    return
                end
                if #t15 == 1 then
                    u202[p21] = NumberSequence.new(t15[1].Value)

                    return
                end
            else
                if p22.Type == "Font" then
                    local v856 = u202
                    local v857 = p21
                    local new = Font.new
                    local Family = p22.Family
                    local v860 = Enum.FontWeight[p22.Weight]

                    if not v860 then
                        v860 = Enum.FontWeight.Regular
                    end

                    local v861 = Enum.FontStyle[p22.Style]

                    if not v861 then
                        v861 = Enum.FontStyle.Normal
                    end

                    v856[v857] = new(Family, v860, v861)

                    return
                end

                if p22.Type == "Primitive" then
                    u202[p21] = p22.Value

                    return
                end

                if p22.Type == "Primitive_Huge" then
                    if p22.Value == "Infinity" then
                        u202[p21] = 1e999

                        return
                    end

                    if p22.Value == "-Infinity" then
                        u202[p21] = -1e999
                    end
                end
            end
        end)
        t13[p21] = true
    end
    for v210, v211 in ipairs(t1.value35) do

        if p18.Properties[v211] then
            v207(v211, p18.Properties[v211])
        end
    end
    for k, v in pairs(p18.Properties) do
        local v214 = k

        if not t13[v214] then
            v207(v214, v)
        end
    end
    if p18.AdorneeName and p20 then
        local p18AdorneeName = p20:FindFirstChild(p18.AdorneeName)

        if p18AdorneeName then
            pcall(function()
                u202.Adornee = p18AdorneeName
            end)
        end
    end
    for _, v in ipairs(p18.Children) do
        t1.value36(v, u202, p20)
    end
    u202.Parent = p19

    return u202
end
local function v2(p23, p24)
    local t16 = {}

    for _, descendant in ipairs(p23:GetDescendants()) do
        local v223 = descendant:IsA("BillboardGui")

        if not v223 then
            v223 = descendant:IsA("SurfaceGui")
        end

        if v223 then
            local v224

            if p24 then
                v224 = descendant.Name ~= "BubbleChat"

                if v224 then
                    v224 = not descendant:FindFirstChild("HealthBar")
                end
            else
                v224 = true
            end

            if v224 then
                local v225 = t1.value34(descendant)
                local descendantParent = descendant.Parent

                if descendantParent then
                    descendantParent = descendant.Parent.Name
                end

                v225.ParentName = descendantParent or "Head"
                table.insert(t16, v225)
            end
        end
    end

    return t16
end
function t1.value37(p25)
    local t17 = {}
    local GetDescendants = p25.GetDescendants

    for _, v in ipairs(GetDescendants(p25)) do
        local v148 = v:IsA("BillboardGui")

        if not v148 then
            v148 = v:IsA("SurfaceGui")
        end

        if v148 then
            local v149 = v.Name ~= "BubbleChat"

            if v149 then
                v149 = not v:FindFirstChild("HealthBar")
            end

            if v149 then
                local function u150(p26, p27)
                    local t18 = {}
                    pcall(function()
                        t18.Visible = p26.Visible
                    end)
                    pcall(function()
                        if p26.BackgroundColor3 then
                            t18.BackgroundColor3 = {
								p26.BackgroundColor3.R,
								p26.BackgroundColor3.G,
								p26.BackgroundColor3.B
							}
                        end
                    end)
                    pcall(function()
                        t18.BackgroundTransparency = p26.BackgroundTransparency
                    end)
                    pcall(function()
                        if p26.BorderColor3 then
                            t18.BorderColor3 = {
								p26.BorderColor3.R,
								p26.BorderColor3.G,
								p26.BorderColor3.B
							}
                        end
                    end)
                    pcall(function()
                        t18.BorderSizePixel = p26.BorderSizePixel
                    end)
                    pcall(function()
                        t18.ZIndex = p26.ZIndex
                    end)
                    local v628 = p26:IsA("TextLabel")
                    if not v628 then
                        v628 = p26:IsA("TextButton")

                        if not v628 then
                            v628 = p26:IsA("TextBox")
                        end
                    end
                    if v628 then
                        pcall(function()
                            t18.Text = p26.Text
                        end)
                        pcall(function()
                            t18.TextColor3 = {
								p26.TextColor3.R,
								p26.TextColor3.G,
								p26.TextColor3.B
							}
                        end)
                        pcall(function()
                            t18.TextTransparency = p26.TextTransparency
                        end)
                        pcall(function()
                            t18.RichText = p26.RichText
                        end)
                        pcall(function()
                            t18.TextScaled = p26.TextScaled
                        end)
                        pcall(function()
                            t18.TextSize = p26.TextSize
                        end)
                        pcall(function()
                            t18.TextWrapped = p26.TextWrapped
                        end)
                        pcall(function()
                            t18.TextStrokeTransparency = p26.TextStrokeTransparency
                        end)
                        pcall(function()
                            t18.TextStrokeColor3 = {
								p26.TextStrokeColor3.R,
								p26.TextStrokeColor3.G,
								p26.TextStrokeColor3.B
							}
                        end)
                        pcall(function()
                            t18.Font = p26.Font.Name
                        end)
                        pcall(function()
                            if p26.FontFace then
                                local v796 = t18
                                local Family = p26.FontFace.Family
                                local WeightName = p26.FontFace.Weight.Name
                                local StyleName = p26.FontFace.Style.Name

                                v796.FontFace = {
									Family = Family,
									Weight = WeightName,
									Style = StyleName
								}
                            end
                        end)
                        pcall(function()
                            t18.TextXAlignment = p26.TextXAlignment.Name
                        end)
                        pcall(function()
                            t18.TextYAlignment = p26.TextYAlignment.Name
                        end)
                    else
                        local v629 = p26:IsA("ImageLabel")

                        if not v629 then
                            v629 = p26:IsA("ImageButton")
                        end

                        if v629 then
                            pcall(function()
                                t18.Image = p26.Image
                            end)
                            pcall(function()
                                t18.ImageColor3 = {
									p26.ImageColor3.R,
									p26.ImageColor3.G,
									p26.ImageColor3.B
								}
                            end)
                            pcall(function()
                                t18.ImageTransparency = p26.ImageTransparency
                            end)
                            pcall(function()
                                t18.ScaleType = p26.ScaleType.Name
                            end)
                            pcall(function()
                                t18.ImageRectOffset = {
									p26.ImageRectOffset.X,
									p26.ImageRectOffset.Y
								}
                            end)
                            pcall(function()
                                t18.ImageRectSize = {
									p26.ImageRectSize.X,
									p26.ImageRectSize.Y
								}
                            end)
                        elseif p26:IsA("UIGradient") then
                            pcall(function()
                                t18.Color = {}
                                for v802, v803 in ipairs(p26.Color.Keypoints) do

                                    local insert = table.insert
                                    local t18Color = t18.Color
                                    local Time = v803.Time
                                    local t19 = {
										v803.Value.R,
										v803.Value.G,
										v803.Value.B
									}

                                    insert(t18Color, {
										Time = Time,
										Value = t19
									})
                                end
                                t18.Transparency = {}
                                for _, v3 in ipairs(p26.Transparency.Keypoints) do
                                    local insert = table.insert
                                    local t18Transparency = t18.Transparency
                                    local Time = v3.Time
                                    local v3Value = v3.Value
                                    local Envelope = v3.Envelope

                                    insert(t18Transparency, {
										Time = Time,
										Value = v3Value,
										Envelope = Envelope
									})
                                end
                                t18.Rotation = p26.Rotation
                                t18.Offset = {
									p26.Offset.X,
									p26.Offset.Y
								}
                                t18.Enabled = p26.Enabled
                            end)
                        elseif p26:IsA("UIStroke") then
                            pcall(function()
                                t18.Color = {
									p26.Color.R,
									p26.Color.G,
									p26.Color.B
								}
                                t18.Thickness = p26.Thickness
                                t18.Transparency = p26.Transparency
                                t18.Enabled = p26.Enabled
                                t18.ApplyStrokeMode = p26.ApplyStrokeMode.Name
                                t18.LineJoinMode = p26.LineJoinMode.Name
                            end)
                        elseif p26:IsA("UICorner") then
                            pcall(function()
                                t18.CornerRadius = {
									p26.CornerRadius.Scale,
									p26.CornerRadius.Offset
								}
                            end)
                        end
                    end
                    if next(t18) then
                        t17[p27] = t18
                    end
                    for _, child in ipairs(p26:GetChildren()) do
                        u150(child, p27 .. "/" .. child.Name)
                    end
                end

                local vParent = v.Parent

                if vParent then
                    vParent = v.Parent.Name
                end

                local v152 = vParent or "Head"

                if p25 == v.Parent then
                    v152 = "CharacterRoot"
                end

                u150(v, v152 .. "/" .. v.Name)
            end
        end
    end

    return t17
end
function t1.value38(p28)
    if not p28 then
        return nil
    end

    local t20 = {}

    for _, v in ipairs({
		"BackAccessory",
		"FaceAccessory",
		"FrontAccessory",
		"HairAccessory",
		"HatAccessory",
		"NeckAccessory",
		"ShouldersAccessory",
		"WaistAccessory",
		"Face",
		"Head",
		"LeftArm",
		"LeftLeg",
		"RightArm",
		"RightLeg",
		"Torso",
		"GraphicTShirt",
		"Pants",
		"Shirt",
		"ClimbAnimation",
		"FallAnimation",
		"IdleAnimation",
		"JumpAnimation",
		"RunAnimation",
		"SwimAnimation",
		"WalkAnimation",
		"MoodAnimation",
		"DepthScale",
		"HeadScale",
		"HeightScale",
		"ProportionScale",
		"WidthScale",
		"BodyTypeScale",
		"HeadColor",
		"LeftArmColor",
		"LeftLegColor",
		"RightArmColor",
		"RightLegColor",
		"TorsoColor",
		"ShirtAccessory",
		"PantsAccessory",
		"JacketAccessory",
		"SweaterAccessory",
		"ShortsAccessory",
		"LeftShoeAccessory",
		"RightShoeAccessory",
		"DressSkirtAccessory",
		"EyebrowAccessory",
		"EyelashAccessory"
	}) do
        local v231 = v

        pcall(function()
            local v639 = p28[v231]

            if typeof(v639) == "Color3" then
                t20[v231] = {
					v639.R,
					v639.G,
					v639.B
				}

                return
            end

            if v639 ~= nil then
                t20[v231] = v639
            end
        end)
    end

    pcall(function()
        local Accessories = p28:GetAccessories(true)

        if Accessories and #Accessories > 0 then
            local t21 = {}

            for _, v in ipairs(Accessories) do
                local v644 = v
                local t22 = {}

                if v644.AssetId ~= nil then
                    t22.AssetId = v644.AssetId
                end

                if v644.IsLayered ~= nil then
                    t22.IsLayered = v644.IsLayered
                end

                if v644.Order ~= nil then
                    t22.Order = v644.Order
                end

                if v644.Puffiness ~= nil then
                    t22.Puffiness = v644.Puffiness
                end

                if typeof(v644.AccessoryType) == "EnumItem" then
                    t22.AccessoryType = v644.AccessoryType.Value
                elseif type(v644.AccessoryType) == "number" then
                    t22.AccessoryType = v644.AccessoryType
                end

                pcall(function()
                    if typeof(v644.Position) == "Vector3" then
                        t22.Position = {
							v644.Position.X,
							v644.Position.Y,
							v644.Position.Z
						}
                    end
                end)
                pcall(function()
                    if typeof(v644.Rotation) == "Vector3" then
                        t22.Rotation = {
							v644.Rotation.X,
							v644.Rotation.Y,
							v644.Rotation.Z
						}
                    end
                end)
                pcall(function()
                    if typeof(v644.Scale) == "Vector3" then
                        t22.Scale = {
							v644.Scale.X,
							v644.Scale.Y,
							v644.Scale.Z
						}
                    end
                end)
                table.insert(t21, t22)
            end

            t20._LayeredAccessories = t21
        end
    end)

    return t20
end
function t1.value39(p29, p30)
    local v137 = not p29

    if not v137 then
        v137 = type(p30) ~= "table"
    end

    if v137 then
        return
    end

    for k, v in pairs(p30) do
        local v140 = k
        local v141 = v

        if v140 ~= "_LayeredAccessories" then
            pcall(function()
                if type(v141) == "table" and #v141 == 3 then
                    p29[v140] = Color3.new(v141[1], v141[2], v141[3])

                    return
                end

                p29[v140] = v141
            end)
        end
    end

    local v142 = type(p30._LayeredAccessories) == "table"

    if v142 then
        v142 = #p30._LayeredAccessories > 0
    end

    if v142 then
        pcall(function()
            local t23 = {}
            for v610, v611 in ipairs(p30._LayeredAccessories) do

                local v612 = v611
                local t24 = {}

                if v612.AssetId ~= nil then
                    t24.AssetId = v612.AssetId
                end

                if v612.IsLayered ~= nil then
                    t24.IsLayered = v612.IsLayered
                end

                if v612.Order ~= nil then
                    t24.Order = v612.Order
                end

                if v612.Puffiness ~= nil then
                    t24.Puffiness = v612.Puffiness
                end

                if v612.AccessoryType ~= nil then
                    local ok, result = pcall(function()
                        for _, v in ipairs(Enum.AccessoryType:GetEnumItems()) do
                            if v.Value == v612.AccessoryType then
                                return v
                            end
                        end

                        return nil
                    end)

                    if ok and result then
                        t24.AccessoryType = result
                    end
                end

                if type(v612.Position) == "table" then
                    t24.Position = Vector3.new(v612.Position[1] or 0, v612.Position[2] or 0, v612.Position[3] or 0)
                end

                if type(v612.Rotation) == "table" then
                    t24.Rotation = Vector3.new(v612.Rotation[1] or 0, v612.Rotation[2] or 0, v612.Rotation[3] or 0)
                end

                if type(v612.Scale) == "table" then
                    t24.Scale = Vector3.new(v612.Scale[1] or 0, v612.Scale[2] or 0, v612.Scale[3] or 0)
                end

                table.insert(t23, t24)
            end
            if #t23 > 0 and not pcall(function()
                p29:SetAccessories(t23, true)
            end) then
                local t25 = {}

                for _, v in ipairs(t23) do
                    local v619 = #t25 + 1
                    local AssetId = v.AssetId
                    local IsLayered = v.IsLayered
                    local vOrder = v.Order
                    local Puffiness = v.Puffiness
                    local AccessoryType = v.AccessoryType

                    t25[v619] = {
						AssetId = AssetId,
						IsLayered = IsLayered,
						Order = vOrder,
						Puffiness = Puffiness,
						AccessoryType = AccessoryType
					}
                end

                pcall(function()
                    p29:SetAccessories(t25, true)
                end)
            end
        end)
    end
end
function t1.value40(p31)
    local t26 = {}
    if not p31 then
        return t26
    end
    local g173
    local g179
    local v174
    local v180
    for _, child in ipairs(p31:GetChildren()) do
        local v166 = child

        if v166:IsA("BasePart") then
            local t27 = {
				Name = v166.Name
			}
            local u168 = t27
            pcall(function()
                u168.Size = {
					v166.Size.X,
					v166.Size.Y,
					v166.Size.Z
				}
            end)
            pcall(function()
                u168.Transparency = v166.Transparency
            end)
            pcall(function()
                u168.Color = {
					v166.Color.R,
					v166.Color.G,
					v166.Color.B
				}
            end)
            pcall(function()
                u168.Material = v166.Material.Name
            end)
            pcall(function()
                u168.Reflectance = v166.Reflectance
            end)
            pcall(function()
                u168.CastShadow = v166.CastShadow
            end)
            local t30
            local v170, v171, v172 = ipairs(v166:GetChildren())
            repeat
                repeat
                    if not g173 then
                        v172, v174 = v170(v171, v172)
                    end

                    if g173 or not v172 then
                        g173 = false

                        if t30 then
                            u168.Mesh = t30
                        end

                        local t28 = {}

                        for _, child2 in ipairs(v166:GetChildren()) do
                            if child2:IsA("Decal") then
                                local t29 = {
									Name = child2.Name
								}

                                pcall(function()
                                    t29.Texture = child2.Texture
                                end)
                                pcall(function()
                                    t29.Transparency = child2.Transparency
                                end)
                                pcall(function()
                                    t29.Color3 = {
										child2.Color3.R,
										child2.Color3.G,
										child2.Color3.B
									}
                                end)
                                pcall(function()
                                    t29.Face = child2.Face.Name
                                end)
                                table.insert(t28, t29)
                            end
                        end

                        if #t28 > 0 then
                            u168.Decals = t28
                        end

                        table.insert(t26, u168)
                        g179 = true
                    end

                    if g179 then
                        break
                    end

                    v180 = v174
                until v180:IsA("SpecialMesh")

                if g179 then
                    break
                end

                t30 = {}
                pcall(function()
                    t30.MeshId = v180.MeshId
                end)
                pcall(function()
                    t30.TextureId = v180.TextureId
                end)
                pcall(function()
                    t30.Scale = {
						v180.Scale.X,
						v180.Scale.Y,
						v180.Scale.Z
					}
                end)
                pcall(function()
                    t30.Offset = {
						v180.Offset.X,
						v180.Offset.Y,
						v180.Offset.Z
					}
                end)
                pcall(function()
                    t30.VertexColor = {
						v180.VertexColor.X,
						v180.VertexColor.Y,
						v180.VertexColor.Z
					}
                end)
                pcall(function()
                    t30.MeshType = v180.MeshType.Name
                end)
                g173 = true
            until not g173
        end

        g179 = false
    end

    return t26
end
function t1.value41(p32)
    local t31 = {}
    local GetChildren = p32.GetChildren

    for _, v in ipairs(GetChildren(p32)) do
        if v:IsA("Accessory") then
            local Handle = v:FindFirstChild("Handle")
            local v187 = Handle

            if Handle then
                v187 = Handle:FindFirstChildOfClass("Weld")
            end

            if Handle and v187 then
                local v188 = t1.value30(Handle.Size)
                local t32 = {
					0,
					0,
					0
				}
                local SpecialMesh = Handle:FindFirstChildOfClass("SpecialMesh")

                if not SpecialMesh then
                    SpecialMesh = Handle:FindFirstChildOfClass("MeshPart")
                end

                local v191 = SpecialMesh
                local v192 = v191

                if v192 then
                    v192 = v191:IsA("SpecialMesh")
                end

                if v192 then
                    v188 = t1.value30(v191.Scale)
                    pcall(function()
                        t32 = t1.value30(v191.Offset)
                    end)
                end

                local insert = table.insert
                local vName = v.Name
                local t33 = { v187.C0:GetComponents() }
                local t34 = { v187.C1:GetComponents() }
                local v197 = t32
                local HandleTransparency = Handle.Transparency

                insert(t31, {
					Name = vName,
					WeldC0 = t33,
					WeldC1 = t34,
					Scale = v188,
					Offset = v197,
					Transparency = HandleTransparency
				})
            end
        end
    end

    return t31
end
function t1.value42(p33, p34)
    local v242 = not p34

    if not v242 then
        v242 = type(p34) ~= "table"
    end

    if v242 then
        return
    end

    local function v243()
        local t35 = {}

        for _, v in ipairs(p34) do
            local v649 = v

            for _, child in ipairs(p33:GetChildren()) do
                local v652 = child:IsA("Accessory")

                if v652 then
                    v652 = child.Name == v649.Name and not t35[child]
                end

                if v652 then
                    t35[child] = true

                    local Handle = child:FindFirstChild("Handle")
                    local v654 = Handle

                    if v654 then
                        v654 = Handle:FindFirstChildOfClass("Weld")
                    end

                    local v655 = v654

                    if not (Handle and v655) then
                        break
                    end

                    pcall(function()
                        if Handle.Anchored then
                            Handle.Anchored = false
                        end

                        if v649.Transparency ~= nil then
                            Handle.Transparency = v649.Transparency
                        end

                        if v649.WeldC0 then
                            v655.C0 = CFrame.new(unpack(v649.WeldC0))
                        end

                        if v649.WeldC1 then
                            v655.C1 = CFrame.new(unpack(v649.WeldC1))
                        end

                        if v649.Scale then
                            local SpecialMesh = Handle:FindFirstChildOfClass("SpecialMesh")

                            if SpecialMesh then
                                SpecialMesh.Scale = t1.value31(v649.Scale)

                                if v649.Offset then
                                    SpecialMesh.Offset = t1.value31(v649.Offset)

                                    return
                                end
                            else
                                Handle.Size = t1.value31(v649.Scale)
                            end
                        end
                    end)

                    break
                end
            end
        end
    end

    v243()
    task.spawn(function()
        for _ = 1, 8 do
            task.wait(0.05)

            local v657 = not p33

            if not v657 then
                v657 = not p33.Parent
            end

            if v657 then
                return
            end

            v243()
        end
    end)
end
local t36 = {
	WalkAnim = 18537392113,
	RunAnim = 18537384940,
	JumpAnim = 18537380791,
	FallAnim = 18537367238,
	SwimIdle = 18537387180,
	Swim = 18537389531,
	Animation1 = 18537376492,
	Animation2 = 18537371272,
	ClimbAnim = 18537363391
}
local t37 = {
	WalkAnim = 122150855457006,
	RunAnim = 82598234841035,
	JumpAnim = 75290611992385,
	FallAnim = 98600215928904,
	SwimIdle = 109346520324160,
	Swim = 133308483266210,
	Animation1 = 122257458498460,
	Animation2 = 102357151005770,
	ClimbAnim = 88763136693023
}
local t38 = {
	WalkAnim = 83842218823011,
	RunAnim = 118320322718870,
	JumpAnim = 109996626521200,
	FallAnim = 95603166884636,
	SwimIdle = 94922130551805,
	Swim = 134530128383900,
	Animation1 = 110211186840350,
	Animation2 = 114191137265060,
	ClimbAnim = 97824616490448
}
local t39 = {
	WalkAnim = 92072849924640,
	RunAnim = 72301599441680,
	JumpAnim = 104325245285200,
	FallAnim = 121152442762480,
	Animation1 = 118832222982049,
	ClimbAnim = 131326830509780,
	SwimIdle = 113199415118200,
	Swim = 99384245425157,
	Animation2 = 76049494037641
}
local t40 = {
	WalkAnim = 10921111375,
	RunAnim = 10921104374,
	JumpAnim = 10921107367,
	FallAnim = 10921105765,
	SwimIdle = 10921110146,
	Swim = 10921108971,
	ClimbAnim = 10921100400,
	Animation1 = 10921101664,
	Animation2 = 10921102574
}
local t41 = {
	WalkAnim = 10921355261,
	RunAnim = 616163682,
	JumpAnim = 10921351278,
	FallAnim = 10921350320,
	SwimIdle = 10921353442,
	Swim = 10921352344,
	Animation1 = 10921344533,
	Animation2 = 10921345304,
	ClimbAnim = 10921343576
}
local t42 = {
	WalkAnim = 10921152678,
	RunAnim = 10921148209,
	JumpAnim = 10921149743,
	FallAnim = 10921148939,
	SwimIdle = 10921151661,
	Swim = 10921150788,
	ClimbAnim = 10921143404,
	Animation1 = 10921144709,
	Animation2 = 10921145797
}
local t43 = {
	WalkAnim = 109168724482750,
	RunAnim = 81024476153754,
	JumpAnim = 116936326516980,
	FallAnim = 92294537340807,
	SwimIdle = 98854111361360,
	Swim = 134591743181630,
	ClimbAnim = 119377220967550,
	Animation1 = 133806214992291,
	Animation2 = 94970088341563
}
local t44 = {
	WalkAnim = 10921046031,
	RunAnim = 10921039308,
	JumpAnim = 10921042494,
	FallAnim = 10921040576,
	SwimIdle = 10921045006,
	Swim = 10921044000,
	ClimbAnim = 10921032124,
	Animation1 = 10921034824,
	Animation2 = 10921036806
}
local t45 = {
	WalkAnim = 73718308412641,
	RunAnim = 135515454877967,
	JumpAnim = 78508480717326,
	FallAnim = 78147885297412,
	SwimIdle = 129183123083281,
	Swim = 110657013921770,
	ClimbAnim = 129447497744820,
	Animation1 = 92849173543269,
	Animation2 = 132238900951110
}
local t46 = {
	WalkAnim = 10921342074,
	RunAnim = 10921336997,
	JumpAnim = nil,
	FallAnim = 10921337907,
	SwimIdle = 10921341319,
	Swim = 10921340419,
	ClimbAnim = 10921329322,
	Animation1 = 10921330408,
	Animation2 = 10921333667
}
local t47 = {
	WalkAnim = 10921298616,
	RunAnim = 10921291831,
	JumpAnim = 10921294559,
	FallAnim = 10921293373,
	SwimIdle = 10921297391,
	Swim = 10921295495,
	ClimbAnim = 10921286911,
	Animation1 = 10921288909,
	Animation2 = 10921290167
}
local t48 = {
	WalkAnim = 10921312010,
	RunAnim = 10921306285,
	JumpAnim = 10921308158,
	FallAnim = 10921307241,
	SwimIdle = 10921310341,
	Swim = 10921309319,
	ClimbAnim = 10921300839,
	Animation1 = 10921301576,
	Animation2 = nil
}
local t49 = {
	WalkAnim = 18747074203,
	RunAnim = 18747070484,
	JumpAnim = 18747069148,
	FallAnim = 18747062535,
	SwimIdle = 18747071682,
	Swim = 18747073181,
	ClimbAnim = 18747060903,
	Animation1 = 18747067405,
	Animation2 = 18747063918
}
local t50 = {
	WalkAnim = 110358958299415,
	RunAnim = 117333533048080,
	JumpAnim = 119846112151350,
	FallAnim = 129773241321030,
	SwimIdle = 79090109939093,
	Swim = 132697394189920,
	ClimbAnim = 134630013742020,
	Animation1 = 92080889861410,
	Animation2 = 74451233229259
}
local t51 = {
	WalkAnim = 90478085024465,
	RunAnim = 134824450619860,
	JumpAnim = 121454505477200,
	FallAnim = 94788218468396,
	SwimIdle = 129126268464850,
	Swim = 105962919001090,
	ClimbAnim = 121145883950230,
	Animation1 = 98281136301627,
	Animation2 = nil
}
local t52 = {
	WalkAnim = 10921326949,
	RunAnim = 10921320299,
	JumpAnim = 10921322186,
	FallAnim = 10921321317,
	SwimIdle = 10921325443,
	Swim = 10921324408,
	ClimbAnim = 10921314188,
	Animation1 = 10921315373,
	Animation2 = nil
}
local t53 = {
	Run = 656118852,
	Walk = 656121766,
	Jump = 656117878,
	Fall = 656115606,
	Swim = 656119721,
	SwimIdle = 656121397,
	Climb = 656114359,
	Idle = {
		656117400,
		656118341,
		886742569
	}
}
local t54 = {
	Run = 616091570,
	Walk = 616095330,
	Jump = 616090535,
	Fall = 616087089,
	Swim = 616092998,
	SwimIdle = 616094091,
	Climb = 616086039,
	Idle = {
		616088211,
		616089559,
		885531463
	}
}
local t55 = {
	Run = 616010382,
	Walk = 616013216,
	Jump = 616008936,
	Fall = 616005863,
	Swim = 616011509,
	SwimIdle = 616012453,
	Climb = 616003713,
	Idle = {
		616006778,
		616008087,
		886862142
	}
}
local t56 = {
	Run = 616140816,
	Walk = 616146177,
	Jump = 616139451,
	Fall = 616134815,
	Swim = 616143378,
	SwimIdle = 616144772,
	Climb = 616133594,
	Idle = {
		616136790,
		616138447,
		886888594
	}
}
local t57 = {
	Run = 910025107,
	Walk = 910034870,
	Jump = 910016857,
	Fall = 910001910,
	Swim = 910028158,
	SwimIdle = 910030921,
	Climb = 909997997,
	Idle = {
		910004836,
		910009958,
		1018536639
	}
}
local t58 = {
	Run = 742638842,
	Walk = 742640026,
	Jump = 742637942,
	Fall = 742637151,
	Swim = 742639220,
	SwimIdle = 742639812,
	Climb = 742636889,
	Idle = {
		742637544,
		742638445,
		885477856
	}
}
t1.value43 = {
	["Adidas Sports"] = t36,
	["Adidas Community"] = t37,
	["Adidas Aura"] = t38,
	["Wicked Popular"] = t39,
	Elder = t40,
	Zombie = t41,
	Mage = t42,
	["Catwalk Glam"] = t43,
	Astronaut = t44,
	["Wicked \"Dancing Through Life\""] = t45,
	Werewolf = t46,
	Superhero = t47,
	Toy = t48,
	["No Boundaries"] = t49,
	NFL = t50,
	["Amazon Unboxed"] = t51,
	Vampire = t52,
	Ninja = t53,
	Robot = t54,
	Levitation = t55,
	Stylish = t56,
	Bubbly = t57,
	Cartoon = t58
}
t1.value44 = nil
t1.value45 = "AnimPack_Last"
t1.value46 = false
function t1.value47(p35)
    for _ = 1, 40 do
        local Animate = p35:FindFirstChild("Animate")
        local v247 = Animate

        if Animate then
            v247 = Animate:FindFirstChild("idle")

            if v247 then
                v247 = Animate:FindFirstChild("run")

                if v247 then
                    v247 = Animate:FindFirstChild("walk")
                end
            end
        end

        if v247 then
            return Animate
        end

        task.wait(0.1)
    end

    return nil
end
function t1.value48(p36)
    local v249 = t1.value47(p36)

    if v249 and not t1.value44 then
        t1.value44 = {}

        for _, v in ipairs({
			"run",
			"walk",
			"jump",
			"fall",
			"climb",
			"swim",
			"swimidle",
			"idle"
		}) do
            local v4 = v249:FindFirstChild(v)

            if v4 then
                t1.value44[v] = {}

                local GetChildren = v4.GetChildren

                for _, v5 in ipairs(GetChildren(v4)) do
                    if v5:IsA("Animation") then
                        t1.value44[v][v5.Name] = v5.AnimationId
                    end
                end
            end
        end
    end
end
if t1.value8.Character then
    task.spawn(function()
        t1.value48(t1.value8.Character)
    end)
end
function t1.value49(p37, p38)
    if p37 and p38 then
        p37.AnimationId = "rbxassetid://" .. tostring(p38)
    end
end
function t1.value50(p39)
    if not p39 then
        return
    end

    local GetPlayingAnimationTracks = p39.GetPlayingAnimationTracks

    for _, v in ipairs(GetPlayingAnimationTracks(p39)) do
        local v262 = v

        pcall(function()
            v262:Stop(0)
        end)
    end
end
local function v26(p40, p41)
    if not p40 then
        return nil
    end

    local p41_2 = p40:FindFirstChild(p41)

    if not p41_2 then
        p41_2 = Instance.new("Animation")
        p41_2.Name = p41
        p41_2.Parent = p40
    end

    return p41_2
end
function t1.value51(p42, ...)
    for i = 1, select("#", ...) do
        local v278 = p42[select(i, ...)]

        if v278 ~= nil then
            return v278
        end
    end

    return nil
end
function t1.value52()
    local Character = t1.value8.Character

    if not Character or not t1.value44 then
        return false
    end

    local v264 = t1.value47(Character)

    if not v264 then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        t1.value50(Humanoid)
    end

    for k, v in pairs(t1.value44) do
        local k2 = v264:FindFirstChild(k)

        if k2 then
            for k3, v6 in pairs(v) do
                local k3_2 = k2:FindFirstChild(k3)
                local v272 = k3_2

                if k3_2 then
                    v272 = k3_2:IsA("Animation")
                end

                if v272 then
                    k3_2.AnimationId = v6
                end
            end
        end
    end

    v264.Disabled = true
    task.wait(0.05)
    v264.Disabled = false
    pcall(function()
        t1.value8:SetAttribute(t1.value45, "")
    end)

    return true
end
function t1.value53(p43)
    if t1.value46 then
        return false
    end

    local v285 = t1.value43[p43]

    if not v285 then
        return false
    end

    local Character = t1.value8.Character

    if not Character then
        Character = t1.value8.CharacterAdded:Wait()
    end

    local v287 = t1.value47(Character)

    if not v287 then
        return false
    end

    local FindFirstChildOfClass = Character.FindFirstChildOfClass
    local FindFirstChild = v287.FindFirstChild
    local v290 = FindFirstChildOfClass(Character, "Humanoid")

    t1.value50(v290)

    local v291 = v26(FindFirstChild(v287, "run"), "RunAnim")
    local walk = v287:FindFirstChild("walk")
    local v293

    if not walk then
        v293 = nil
    else
        v293 = walk:FindFirstChild("WalkAnim")

        if not v293 then
            v293 = Instance.new("Animation")
            v293.Name = "WalkAnim"
            v293.Parent = walk
        end
    end

    local jump = v287:FindFirstChild("jump")
    local v295

    if not jump then
        v295 = nil
    else
        v295 = jump:FindFirstChild("JumpAnim")

        if not v295 then
            v295 = Instance.new("Animation")
            v295.Name = "JumpAnim"
            v295.Parent = jump
        end
    end

    local fall = v287:FindFirstChild("fall")
    local v297

    if not fall then
        v297 = nil
    else
        v297 = fall:FindFirstChild("FallAnim")

        if not v297 then
            v297 = Instance.new("Animation")
            v297.Name = "FallAnim"
            v297.Parent = fall
        end
    end

    local climb = v287:FindFirstChild("climb")
    local v299

    if not climb then
        v299 = nil
    else
        v299 = climb:FindFirstChild("ClimbAnim")

        if not v299 then
            v299 = Instance.new("Animation")
            v299.Name = "ClimbAnim"
            v299.Parent = climb
        end
    end

    local swim = v287:FindFirstChild("swim")
    local v301

    if not swim then
        v301 = nil
    else
        v301 = swim:FindFirstChild("Swim")

        if not v301 then
            v301 = Instance.new("Animation")
            v301.Name = "Swim"
            v301.Parent = swim
        end
    end

    local swimidle = v287:FindFirstChild("swimidle")
    local v303

    if not swimidle then
        v303 = nil
    else
        v303 = swimidle:FindFirstChild("SwimIdle")

        if not v303 then
            v303 = Instance.new("Animation")
            v303.Name = "SwimIdle"
            v303.Parent = swimidle
        end
    end

    local idle = v287:FindFirstChild("idle")

    t1.value49(v293, t1.value51(v285, "WalkAnim", "Walk"))
    t1.value49(v291, t1.value51(v285, "RunAnim", "Run"))
    t1.value49(v295, t1.value51(v285, "JumpAnim", "Jump"))
    t1.value49(v297, t1.value51(v285, "FallAnim", "Fall"))
    t1.value49(v299, t1.value51(v285, "ClimbAnim", "Climb"))
    t1.value49(v301, t1.value51(v285, "Swim"))

    local value49 = t1.value49
    local v306 = t1.value51(v285, "SwimIdle")

    if not v306 then
        v306 = t1.value51(v285, "Swim")
    end

    value49(v303, v306)

    if idle then
        local v307 = t1.value51(v285, "Animation1")
        local v308 = t1.value51(v285, "Animation2")

        if v307 or v308 then
            if not not idle then
                for i = 1, 2 do
                    local v310 = "Animation" .. i

                    if not idle then
                    elseif not idle:FindFirstChild(v310) then
                        local Animation = Instance.new("Animation")

                        Animation.Name = v310
                        Animation.Parent = idle
                    end
                end
            end

            t1.value49(idle:FindFirstChild("Animation1"), v307 or v308)

            local value49_2 = t1.value49
            local Animation2 = idle:FindFirstChild("Animation2")

            if not v308 then
                v308 = v307 or (v307 or v308)
            end

            value49_2(Animation2, v308)
        elseif v285.Idle and #v285.Idle > 0 then
            local v314 = math.max(2, #v285.Idle)

            if not not idle then
                for i = 1, v314 or 2 do
                    local v316 = "Animation" .. i

                    if not idle then
                    elseif not idle:FindFirstChild(v316) then
                        local Animation = Instance.new("Animation")

                        Animation.Name = v316
                        Animation.Parent = idle
                    end
                end
            end

            t1.value49(idle:FindFirstChild("Animation1"), v285.Idle[1])
            t1.value49(idle:FindFirstChild("Animation2"), v285.Idle[2] or v285.Idle[1])

            for i = 3, #v285.Idle do
                local v319 = i
                local v320 = idle:FindFirstChild("Animation" .. v319)

                if v320 then
                    t1.value49(v320, v285.Idle[v319])
                end
            end
        end
    end

    v287.Disabled = true
    task.wait(0.05)
    v287.Disabled = false
    pcall(function()
        t1.value8:SetAttribute(t1.value45, p43)
    end)

    return true
end
t1.value54 = t1.value8.CharacterAdded:Connect(function(character)
    task.spawn(function()
        t1.value48(character)
    end)
    task.wait(0.6)

    local t1value45 = t1.value8:GetAttribute(t1.value45)
    local v323 = type(t1value45) == "string"

    if v323 then
        v323 = t1value45 ~= "" and t1.value43[t1value45]
    end

    if v323 then
        t1.value53(t1value45)
    end
end)

function t1.value55()
    local Character = t1.value8.Character

    if not Character then
        return
    end

    t1.value11 = {}

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        local value11 = t1.value11
        local DisplayDistanceType = Humanoid.DisplayDistanceType
        local NameDisplayDistance = Humanoid.NameDisplayDistance
        local HealthDisplayDistance = Humanoid.HealthDisplayDistance

        value11[Humanoid] = {
			DisplayDistanceType = DisplayDistanceType,
			NameDisplayDistance = NameDisplayDistance,
			HealthDisplayDistance = HealthDisplayDistance
		}
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.NameDisplayDistance = 0
        Humanoid.HealthDisplayDistance = 0
    end

    local GetDescendants = Character.GetDescendants

    for _, v in ipairs(GetDescendants(Character)) do
        if not v:FindFirstAncestorOfClass("Tool") then
            local v342 = v:IsA("BasePart")

            if not v342 then
                v342 = v:IsA("Decal")

                if not v342 then
                    v342 = v:IsA("Texture")
                end
            end

            if v342 then
                if v.Name ~= "HumanoidRootPart" then
                    local value11 = t1.value11
                    local vTransparency = v.Transparency
                    local v345 = v:IsA("BasePart") and v.CastShadow or nil

                    value11[v] = {
						Transparency = vTransparency,
						CastShadow = v345
					}
                    v.Transparency = 1

                    if v:IsA("BasePart") then
                        v.CastShadow = false
                    end
                end
            else
                local v346 = v:IsA("ParticleEmitter")

                if not v346 then
                    v346 = v:IsA("Trail")

                    if not v346 then
                        v346 = v:IsA("Beam")
                    end
                end

                if v346 then
                    t1.value11[v] = {
						Enabled = v.Enabled
					}
                    v.Enabled = false
                end
            end
        end
    end
end
function t1.value56()
    for k, v in pairs(t1.value11) do
        local v349 = k

        if v349 then
            v349 = k.Parent
        end

        if v349 then
            for k4, v7 in pairs(v) do
                local v352 = v7

                pcall(function()
                    k[k4] = v352
                end)
            end
        end
    end

    t1.value11 = {}
end
function t1.value57(p44)
    local HumanoidRootPart = p44:FindFirstChild("HumanoidRootPart")
    local Humanoid = p44:FindFirstChildOfClass("Humanoid")

    if HumanoidRootPart and Humanoid then
        if Humanoid.RigType == Enum.HumanoidRigType.R15 then
            local HipHeight = Humanoid.HipHeight

            if HipHeight <= 0.1 then
                HipHeight = 2
            end

            return HipHeight + HumanoidRootPart.Size.Y * 0.5
        end

        if Humanoid.RigType == Enum.HumanoidRigType.R6 then
            return 3
        end
    end

    return 3
end
function t1.value58(p45, p46)
    if not t1.value13[p46] then
        local Animation = Instance.new("Animation")

        Animation.AnimationId = "rbxassetid://" .. tostring(p46)

        local ok, result = pcall(function()
            return p45:LoadAnimation(Animation)
        end)

        if ok and result then
            t1.value13[p46] = result
        end
    end

    return t1.value13[p46]
end
function t1.value59(p47, p48)
    local Humanoid = p47:FindFirstChildOfClass("Humanoid")
    local Humanoid2 = p48:FindFirstChildOfClass("Humanoid")
    if not Humanoid or not Humanoid2 then
        return
    end
    local Animator = Humanoid:FindFirstChildOfClass("Animator")
    local Animator2 = Humanoid2:FindFirstChildOfClass("Animator")
    if not Animator or not Animator2 then
        return
    end
    local GetPlayingAnimationTracks = Animator.GetPlayingAnimationTracks
    local t59 = {}
    for _, v in ipairs(GetPlayingAnimationTracks(Animator)) do
        local Animation = v.Animation

        if Animation then
            Animation = v.Animation.AnimationId
        end

        if Animation then
            local v364 = v.Animation.AnimationId:match("%d+")

            if v364 then
                local vTimePosition = v.TimePosition
                local WeightCurrent = v.WeightCurrent
                local vSpeed = v.Speed
                local Looped = v.Looped
                local vPriority = v.Priority

                t59[v364] = {
					timePos = vTimePosition,
					weight = WeightCurrent,
					speed = vSpeed,
					looped = Looped,
					priority = vPriority
				}
            end
        end
    end
    local GetPlayingAnimationTracks2 = Animator2.GetPlayingAnimationTracks
    for v373, v374 in ipairs(GetPlayingAnimationTracks2(Animator2)) do

        local v375 = v374
        local Animation = v375.Animation

        if Animation then
            Animation = v375.Animation.AnimationId:match("%d+")
        end

        if Animation and not t59[Animation] then
            pcall(function()
                v375:Stop(0.1)
            end)
        end
    end
    for k, v in pairs(t59) do
        local v379 = t1.value58(Animator2, k)

        if v379 then
            v379.Looped = v.looped
            v379.Priority = v.priority

            if not v379.IsPlaying then
                v379:Play(0.1, v.weight, v.speed)
                v379.TimePosition = v.timePos
            else
                v379:AdjustSpeed(v.speed)
                v379:AdjustWeight(v.weight)

                if math.abs(v379.TimePosition - v.timePos) > 0.4 then
                    v379.TimePosition = v.timePos
                end
            end
        end
    end
end
t1.value60 = nil
local function v27(p49, p50)
    local GetDescendants = p49.GetDescendants

    for _, v in ipairs(GetDescendants(p49)) do
        if not v:IsA("BillboardGui") then
            continue
        end

        local v385 = false
        local vParent = v.Parent

        while vParent and vParent ~= p49 do
            if vParent:IsA("Tool") then
                v385 = true

                break
            end

            vParent = vParent.Parent
        end

        if not v385 then
            if not t1.value11[v] then
                t1.value11[v] = {
					StudsOffset = v.StudsOffset
				}
            end

            local StudsOffset = t1.value11[v].StudsOffset

            v.StudsOffset = Vector3.new(StudsOffset.X, StudsOffset.Y + p50, StudsOffset.Z)
        end
    end
end
t1.value61 = nil
function t1.value61(p51, p52, p53)
    local children = p52:GetChildren()

    for _, child in ipairs(p51:GetChildren()) do
        for _, v in ipairs(children) do
            local v396 = child.Name == v.Name

            if v396 then
                v396 = child.ClassName == v.ClassName
            end

            if v396 then
                p53[child] = v
                t1.value61(child, v, p53)

                break
            end
        end
    end
end
function t1.value62(p54, p55)
    local t60 = {}
    local g404
    local g425
    local v426
    for _, child in ipairs(p54:GetChildren()) do
        if not child:IsA("Tool") then
            continue
        end

        t60[child.Name] = true

        local Handle = child:FindFirstChild("Handle")
        local v403 = not t1.value14[child]

        if not v403 then
            v403 = Handle ~= t1.value14[child].handle
        end

        if v403 then
            if t1.value14[child] then
                t1.value14[child].fakeModel:Destroy()
                t1.value14[child] = nil
            end

            if not Handle then
                g404 = true
            end

            if not g404 then
                local clone = child:Clone()
                local GetDescendants = clone.GetDescendants
                for v409, v410 in ipairs(GetDescendants(clone)) do

                    local v411 = v410
                    local v412 = v411:IsA("Script")

                    if not v412 then
                        v412 = v411:IsA("LocalScript")
                    end

                    if v412 then
                        pcall(function()
                            v411:Destroy()
                        end)
                    elseif v411:IsA("BasePart") then
                        v411.CanCollide = false
                        v411.Massless = true
                        v411.CanTouch = false
                        v411.CanQuery = false
                        v411.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                    end
                end
                clone.Parent = p55
                local t61 = {}
                t1.value61(child, clone, t61)
                for v416, v417 in pairs(t61) do

                    local v418 = v416:IsA("BasePart")

                    if not v418 then
                        v418 = v416:IsA("Decal")

                        if not v418 then
                            v418 = v416:IsA("Texture")
                        end
                    end

                    if v418 then
                        local v419 = t1.value11[v416]

                        if v419 then
                            v419 = t1.value11[v416].Transparency ~= nil
                        end

                        if v419 then
                            v417.Transparency = t1.value11[v416].Transparency
                        else
                            v417.Transparency = v416.Transparency
                        end
                    else
                        local v420 = v416:IsA("SurfaceGui")

                        if not v420 then
                            v420 = v416:IsA("BillboardGui")

                            if not v420 then
                                v420 = v416:IsA("ParticleEmitter")

                                if not v420 then
                                    v420 = v416:IsA("Trail")

                                    if not v420 then
                                        v420 = v416:IsA("Beam")

                                        if not v420 then
                                            v420 = v416:IsA("Fire")

                                            if not v420 then
                                                v420 = v416:IsA("Smoke")

                                                if not v420 then
                                                    v420 = v416:IsA("Sparkles")
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        if v420 then
                            if v416:GetAttribute("KixOrigUIEnabled") ~= nil then
                                v417.Enabled = v416:GetAttribute("KixOrigUIEnabled")
                            else
                                v417.Enabled = v416.Enabled
                                v416:SetAttribute("KixOrigUIEnabled", v416.Enabled)
                            end
                        end
                    end
                end
                local v421
                local v422, v423, v424 = ipairs(p54:GetDescendants())
                repeat
                    repeat
                        if not g425 then
                            v424, v426 = v422(v423, v424)
                        end

                        if g425 or not v424 then
                            g425 = false

                            local v427 = v421

                            if v421 then
                                v427 = clone:FindFirstChild("Handle")
                            end

                            if v427 then
                                local Part0Name = p55:FindFirstChild(v421.Part0.Name)

                                if Part0Name then
                                    local Weld = Instance.new("Weld")

                                    Weld.Name = "VisualGrip"
                                    Weld.Part0 = Part0Name
                                    Weld.Part1 = clone.Handle
                                    Weld.C0 = v421.C0
                                    Weld.C1 = v421.C1
                                    Weld.Parent = clone.Handle
                                end
                            end

                            t1.value14[child] = {
								fakeModel = clone,
								instancesMap = t61,
								handle = Handle
							}
                            g404 = true
                        end

                        if g404 then
                            break
                        end
                    until v426:IsA("Weld") and Handle == v426.Part1

                    if g404 then
                        break
                    end

                    v421 = v426
                    g425 = true
                until not g425
            end
        end

        g404 = false

        local v430 = t1.value14[child]
        local v431 = v430

        if v430 then
            v431 = v430.handle
        end

        if v431 then
            for k, v in pairs(v430.instancesMap) do
                local v434 = k

                if v434.Parent and v.Parent then
                    if v434:IsA("BasePart") then
                        if v.Transparency ~= v434.Transparency then
                            v.Transparency = v434.Transparency
                        end

                        if v.Color ~= v434.Color then
                            v.Color = v434.Color
                        end
                    elseif v434:IsA("MeshPart") then
                        if v.MeshId ~= v434.MeshId then
                            v.MeshId = v434.MeshId
                        end

                        if v.TextureID ~= v434.TextureID then
                            v.TextureID = v434.TextureID
                        end
                    else
                        local v435 = v434:IsA("Decal")

                        if not v435 then
                            v435 = v434:IsA("Texture")
                        end

                        if v435 then
                            if v.Texture ~= v434.Texture then
                                v.Texture = v434.Texture
                            end

                            if v.Color3 ~= v434.Color3 then
                                v.Color3 = v434.Color3
                            end

                            if v.Transparency ~= v434.Transparency then
                                v.Transparency = v434.Transparency
                            end
                        elseif v434:IsA("SpecialMesh") then
                            if v.MeshId ~= v434.MeshId then
                                v.MeshId = v434.MeshId
                            end

                            if v.TextureId ~= v434.TextureId then
                                v.TextureId = v434.TextureId
                            end

                            if v.Scale ~= v434.Scale then
                                v.Scale = v434.Scale
                            end

                            if v.VertexColor ~= v434.VertexColor then
                                v.VertexColor = v434.VertexColor
                            end
                        else
                            local v436 = v434:IsA("TextLabel")

                            if not v436 then
                                v436 = v434:IsA("TextBox")

                                if not v436 then
                                    v436 = v434:IsA("TextButton")
                                end
                            end

                            if v436 then
                                if v.Text ~= v434.Text then
                                    v.Text = v434.Text
                                end

                                if v.TextColor3 ~= v434.TextColor3 then
                                    v.TextColor3 = v434.TextColor3
                                end

                                if v.TextTransparency ~= v434.TextTransparency then
                                    v.TextTransparency = v434.TextTransparency
                                end

                                if v.BackgroundColor3 ~= v434.BackgroundColor3 then
                                    v.BackgroundColor3 = v434.BackgroundColor3
                                end
                            else
                                local v437 = v434:IsA("ImageLabel")

                                if not v437 then
                                    v437 = v434:IsA("ImageButton")
                                end

                                if v437 then
                                    if v.Image ~= v434.Image then
                                        v.Image = v434.Image
                                    end

                                    if v.ImageColor3 ~= v434.ImageColor3 then
                                        v.ImageColor3 = v434.ImageColor3
                                    end

                                    if v.ImageTransparency ~= v434.ImageTransparency then
                                        v.ImageTransparency = v434.ImageTransparency
                                    end
                                else
                                    local v438 = v434:IsA("SurfaceGui")

                                    if not v438 then
                                        v438 = v434:IsA("BillboardGui")

                                        if not v438 then
                                            v438 = v434:IsA("ParticleEmitter")

                                            if not v438 then
                                                v438 = v434:IsA("Trail")

                                                if not v438 then
                                                    v438 = v434:IsA("Beam")

                                                    if not v438 then
                                                        v438 = v434:IsA("Fire")

                                                        if not v438 then
                                                            v438 = v434:IsA("Smoke")

                                                            if not v438 then
                                                                v438 = v434:IsA("Sparkles")
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    if v438 then
                                        local KixOrigUIEnabled = v434:GetAttribute("KixOrigUIEnabled")

                                        if KixOrigUIEnabled ~= nil and KixOrigUIEnabled ~= v.Enabled then
                                            v.Enabled = KixOrigUIEnabled
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    for k, v in pairs(t1.value14) do
        local v442 = k

        if not t60[v442.Name] then
            if v.fakeModel then
                v.fakeModel:Destroy()
            end

            t1.value14[v442] = nil
        end
    end
end
t1.value60 = nil
function t1.value63()
    if t1.value60 then
        t1.value60:Stop()
        t1.value60:Destroy()
        t1.value60 = nil
    end
end
function t1.value64(p56, p57)
    local v455 = p56:match("%d+")

    if not v455 then
        if p57 then
            p57.Text = "ID tidak valid!"
        end

        task.wait(1.5)

        if p57 then
            p57.Text = ""
        end

        return
    end

    local Character = t1.value8.Character

    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    t1.value63()

    local Animation = Instance.new("Animation")
    local ok, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. v455)
    end)

    if ok then
        ok = result and result[1]
    end

    if ok then
        local v462 = result[1]

        if v462:IsA("Animation") then
            Animation.AnimationId = v462.AnimationId
        else
            local Animation2 = v462:FindFirstChildOfClass("Animation")

            if not Animation2 then
                Animation2 = v462:FindFirstChildWhichIsA("Animation", true)
            end

            if Animation2 then
                Animation.AnimationId = Animation2.AnimationId
            else
                Animation.AnimationId = "rbxassetid://" .. v455
            end
        end
    else
        Animation.AnimationId = "rbxassetid://" .. v455
    end

    local ok2, result2 = pcall(function()
        return Animator:LoadAnimation(Animation)
    end)

    if ok2 and result2 then
        t1.value60 = result2
        t1.value60.Looped = true
        t1.value60:Play()
    else
        if p57 then
            p57.Text = "Gagal memuat animasi!"
        end

        task.wait(1.5)

        if p57 then
            p57.Text = v455
        end
    end
end
function t1.value65()
    t1.value63()
    if t1.value10 then
        t1.value10:Destroy()
        t1.value10 = nil
    end
    for v468, v469 in ipairs(t1.value12) do

        local v470 = v469

        pcall(function()
            v470:Disconnect()
        end)
    end
    for _, v in pairs(t1.value14) do
        local v473 = v

        if v473.fakeModel then
            pcall(function()
                v473.fakeModel:Destroy()
            end)
        end
    end
    pcall(function()
        t1.value2:UnbindFromRenderStep("KixFirstPersonFix")
    end)
    local CurrentCamera = t1.value4.CurrentCamera
    local v475 = CurrentCamera
    if CurrentCamera then
        v475 = t1.value8.Character
    end
    if v475 then
        local Humanoid = t1.value8.Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            CurrentCamera.CameraSubject = Humanoid
        end
    end
    t1.value56()
end
function t1.value66(p58)

    for v446, v447 in ipairs(p58:GetDescendants()) do

        local v448 = v447
        local v449 = v448:IsA("Script")

        if not v449 then
            v449 = v448:IsA("LocalScript")
        end

        if v449 then
            pcall(function()
                v448:Destroy()
            end)
        end
    end
    local Humanoid = p58:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        if not Humanoid:FindFirstChildOfClass("Animator") then
            Instance.new("Animator", Humanoid)
        end

        local CurrentCamera = t1.value4.CurrentCamera

        if CurrentCamera then
            CurrentCamera.CameraSubject = Humanoid
        end
    end
    local HumanoidRootPart = p58:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
        HumanoidRootPart.Anchored = true
    end
    pcall(function()
        t1.value2:UnbindFromRenderStep("KixFirstPersonFix")
    end)
    table.insert(t1.value12, t1.value2.Stepped:Connect(function()
        if not t1.value10 then
            return
        end

        for _, descendant in ipairs(t1.value10:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.Massless = true
            end
        end
    end))
    table.insert(t1.value12, t1.value2.RenderStepped:Connect(function()
        local Character = t1.value8.Character

        if not Character or not t1.value10 then
            return
        end

        local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")
        local n1 = 0

        if HumanoidRootPart2 and HumanoidRootPart then
            local v663 = t1.value57(Character)

            n1 = t1.value57(t1.value10) - v663
            HumanoidRootPart.CFrame = HumanoidRootPart2.CFrame * CFrame.new(0, n1, 0)
        end

        t1.value59(Character, t1.value10)
        t1.value62(Character, t1.value10)
        v27(Character, n1)

        local CurrentCamera = t1.value4.CurrentCamera
        local v665 = t1.value10:FindFirstChild("Head") or Character:FindFirstChild("Head")

        if CurrentCamera and v665 then
            local v666 = (CurrentCamera.CFrame.Position - v665.Position).Magnitude < 2.5
            for v669, v670 in ipairs(Character:GetChildren()) do

                if v670:IsA("Tool") then
                    for _, descendant in ipairs(v670:GetDescendants()) do
                        local v673 = descendant
                        local v674 = v673:IsA("BasePart")

                        if not v674 then
                            v674 = v673:IsA("Decal")

                            if not v674 then
                                v674 = v673:IsA("Texture")
                            end
                        end

                        if v674 then
                            pcall(function()
                                v673.LocalTransparencyModifier = 1
                            end)
                        else
                            local v675 = v673:IsA("SurfaceGui")

                            if not v675 then
                                v675 = v673:IsA("BillboardGui")

                                if not v675 then
                                    v675 = v673:IsA("ParticleEmitter")

                                    if not v675 then
                                        v675 = v673:IsA("Trail")

                                        if not v675 then
                                            v675 = v673:IsA("Beam")

                                            if not v675 then
                                                v675 = v673:IsA("Fire")

                                                if not v675 then
                                                    v675 = v673:IsA("Smoke")

                                                    if not v675 then
                                                        v675 = v673:IsA("Sparkles")
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end

                            if v675 then
                                if v673:GetAttribute("KixOrigUIEnabled") == nil then
                                    v673:SetAttribute("KixOrigUIEnabled", v673.Enabled)
                                end

                                if v673.Enabled == true then
                                    v673:SetAttribute("KixOrigUIEnabled", true)
                                end

                                pcall(function()
                                    v673.Enabled = false
                                end)
                            end
                        end
                    end
                end
            end
            for _, descendant in ipairs(t1.value10:GetDescendants()) do
                local v678 = descendant
                local v679 = v678:IsA("BasePart")

                if not v679 then
                    v679 = v678:IsA("Decal")

                    if not v679 then
                        v679 = v678:IsA("Texture")
                    end
                end

                if v679 then
                    local u680 = not v666 and 0 or 1

                    if v678:FindFirstAncestorOfClass("Tool") then
                        u680 = 0
                    end

                    pcall(function()
                        v678.LocalTransparencyModifier = u680
                    end)
                else
                    local v681 = v678:IsA("ParticleEmitter")

                    if not v681 then
                        v681 = v678:IsA("Fire")

                        if not v681 then
                            v681 = v678:IsA("Smoke")

                            if not v681 then
                                v681 = v678:IsA("Sparkles")

                                if not v681 then
                                    v681 = v678:IsA("Trail")

                                    if not v681 then
                                        v681 = v678:IsA("Beam")
                                    end
                                end
                            end
                        end
                    end

                    if v681 and not v678:FindFirstAncestorOfClass("Tool") then
                        if v678:GetAttribute("KixOrigVFX") == nil then
                            v678:SetAttribute("KixOrigVFX", v678.Enabled)
                        end

                        if v666 then
                            if v678.Enabled then
                                v678:SetAttribute("KixOrigVFX", true)
                            end

                            pcall(function()
                                v678.Enabled = false
                            end)
                        else
                            pcall(function()
                                v678.Enabled = v678:GetAttribute("KixOrigVFX")
                            end)
                        end
                    end
                end
            end
        end
    end))
end
local function v28(p59, p60)
    t1.value65()
    t1.value55()

    local Character = t1.value8.Character
    local R15 = Enum.HumanoidRigType.R15

    if Character and Character:FindFirstChildOfClass("Humanoid") then
        R15 = Character:FindFirstChildOfClass("Humanoid").RigType
    end

    local ok, result = pcall(function()
        return t1.value1:CreateHumanoidModelFromDescription(p59, R15)
    end)
    local v483 = not ok

    if not v483 then
        v483 = not result
    end

    if v483 then
        return false, "Gagal mem-build model avatar!"
    end

    result.Name = "PhantomMorph_" .. p60
    result.Parent = t1.value4
    t1.value10 = result
    t1.value66(result)

    return true, "Berhasil morph menjadi " .. p60
end
function t1.value67(p61)
    local num = tonumber(p61)

    if not num then
        local ok, result = pcall(function()
            return t1.value1:GetUserIdFromNameAsync(p61)
        end)
        local v488 = not ok

        if not v488 then
            v488 = not result
        end

        if v488 then
            return false, "Username tidak ditemukan!"
        end

        num = result
    end

    local ok, result = pcall(function()
        return t1.value1:GetHumanoidDescriptionFromUserId(num)
    end)
    local v491 = not ok

    if not v491 then
        v491 = not result
    end

    if v491 then
        return false, "Gagal mengambil data Avatar."
    end

    return v28(result, p61)
end
function t1.value68(p62)
    local HumanoidDescription = Instance.new("HumanoidDescription")

    if p62.descData then
        t1.value39(HumanoidDescription, p62.descData)
    end

    local v494, v495 = v28(HumanoidDescription, p62.name or "SavedAvatar")

    if not v494 then
        return false, v495
    end

    if p62.accData then
        t1.value42(t1.value10, p62.accData)
    end

    return true, "Berhasil load & morph menjadi " .. p62.name or "SavedAvatar"
end
local color3 = Color3.fromRGB(18, 18, 22)
local color3_2 = Color3.fromRGB(28, 28, 34)
local color3_3 = Color3.fromRGB(80, 140, 255)
local color3_4 = Color3.fromRGB(45, 140, 80)
local color3_5 = Color3.fromRGB(180, 60, 60)
local color3_6 = Color3.fromRGB(230, 230, 230)
local color3_7 = Color3.fromRGB(50, 50, 60)
local t62 = {
	BG = color3,
	Panel = color3_2,
	Accent = color3_3,
	Green = color3_4,
	Red = color3_5,
	Text = color3_6,
	Divider = color3_7
}
t1.value69 = nil
t1.value70 = t62
t1.value69 = nil
function t1.value71()
    local value69 = t1.value69

    if value69 then
        value69 = t1.value69.Parent
    end

    if value69 then
        t1.value69:Destroy()
        t1.value69 = nil
    end
end
function t1.value72(p63, p64, p65, p66)
    t1.value71()
    t1.value69 = Instance.new("ScreenGui")
    t1.value69.Name = "KIX_SaveNameDialog"
    t1.value69.ResetOnSpawn = false
    t1.value69.DisplayOrder = 1000002
    t1.value69.IgnoreGuiInset = true
    t1.value69.Enabled = true
    t1.value19(t1.value69)
    t1.value20(t1.value69)

    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(1, 0, 1, 0)
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BackgroundTransparency = 0.55
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 10
    TextButton.Parent = t1.value69
    TextButton.MouseButton1Click:Connect(t1.value71)

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, 340, 0, 148)
    Frame.Position = UDim2.new(0.5, -170, 0.5, -74)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 11
    Frame.Active = true
    Frame.Parent = t1.value69
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 1.5
    UIStroke.Color = Color3.fromRGB(80, 160, 100)
    UIStroke.Transparency = 0.1
    UIStroke.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, -16, 0, 32)
    TextLabel.Position = UDim2.new(0, 12, 0, 6)
    TextLabel.BackgroundTransparency = 1

    if not p64 then
        p64 = "💾  Nama Avatar Ini"
    end

    TextLabel.Text = p64
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 15
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 12
    TextLabel.Parent = Frame

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Size = UDim2.new(1, -16, 0, 16)
    TextLabel2.Position = UDim2.new(0, 12, 0, 38)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = p65 or "Masukkan nama custom untuk avatar/file ini:"
    TextLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
    TextLabel2.Font = Enum.Font.Gotham
    TextLabel2.TextSize = 12
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.ZIndex = 12
    TextLabel2.Parent = Frame

    local TextBox = Instance.new("TextBox")

    TextBox.Size = UDim2.new(1, -20, 0, 32)
    TextBox.Position = UDim2.new(0, 10, 0, 60)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 14
    TextBox.Text = p66 or ""
    TextBox.ClearTextOnFocus = false
    TextBox.PlaceholderText = "e.g. BajuMabarKeren"
    TextBox.ZIndex = 12
    TextBox.Parent = Frame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 7)

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Size = UDim2.new(0.48, -6, 0, 30)
    TextButton2.Position = UDim2.new(0, 10, 1, -38)
    TextButton2.Text = "✔  Save"
    TextButton2.Font = Enum.Font.GothamBold
    TextButton2.TextSize = 13
    TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton2.BackgroundColor3 = Color3.fromRGB(43, 105, 122)
    TextButton2.ZIndex = 12
    TextButton2.Parent = Frame
    Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 7)

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Size = UDim2.new(0.48, -4, 0, 30)
    TextButton3.Position = UDim2.new(0.52, 0, 1, -38)
    TextButton3.Text = "✕  Batal"
    TextButton3.Font = Enum.Font.GothamBold
    TextButton3.TextSize = 13
    TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton3.BackgroundColor3 = Color3.fromRGB(100, 45, 45)
    TextButton3.ZIndex = 12
    TextButton3.Parent = Frame
    Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 7)
    TextButton3.MouseButton1Click:Connect(t1.value71)
    TextButton2.MouseButton1Click:Connect(function()
        local v682 = t1.value28(TextBox.Text)

        t1.value71()

        if p63 then
            p63(v682)
        end
    end)
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local v684 = t1.value28(TextBox.Text)

            t1.value71()

            if p63 then
                p63(v684)
            end
        end
    end)
    task.wait(0.05)
    pcall(function()
        TextBox:CaptureFocus()
    end)
end
t1.value73 = nil
t1.value74 = nil
t1.value75 = {}
t1.value76 = "FILES"
t1.value77 = nil
t1.value78 = nil
t1.value79 = nil
t1.value80 = nil
function t1.value80()
    local t63 = {}

    if not t1.value26() then
        return t63
    end

    pcall(t1.value27)

    local t64 = {
		{
			path = t1.value16,
			kind = "avatar"
		},
		{
			path = t1.value17,
			kind = "clan"
		}
	}

    for _, v in ipairs(t64) do
        local v520 = t1.value24(v.path)

        for _, v8 in ipairs(v520) do
            local str = tostring(v8)
            local v524 = str:match("([^/\\]+)$") or str

            if v524:lower():match("%.json$") then
                local v525 = t1.value22(str)
                local v526 = v525

                if v526 then
                    v526 = v525 ~= ""
                end

                if v526 then
                    local ok, result = pcall(function()
                        return t1.value6:JSONDecode(v525)
                    end)

                    if ok then
                        ok = type(result) == "table"
                    end

                    if ok then
                        local v529 = v524:sub(1, -6)
                        local insert = table.insert
                        local v531 = result.name or v529
                        local v532 = result.thumbnail or ""
                        local kind = v.kind

                        insert(t63, {
							fileName = v524,
							path = str,
							data = result,
							name = v531,
							thumbnail = v532,
							_kind = kind
						})
                    end
                end
            end
        end
    end

    return t63
end
function t1.value81()
    if t1.value73 then
        pcall(function()
            t1.value73:Destroy()
        end)
    end
    t1.value73 = Instance.new("ScreenGui")
    t1.value73.Name = "KIX_SavedAvatarsPopup"
    t1.value73.ResetOnSpawn = false
    t1.value73.DisplayOrder = 1000001
    t1.value73.IgnoreGuiInset = true
    t1.value73.Enabled = true
    t1.value19(t1.value73)
    t1.value20(t1.value73)
    t1.value74 = Instance.new("Frame")
    t1.value74.Size = UDim2.new(0, 460, 0, 580)
    t1.value74.Position = UDim2.new(0.5, -230, 0.5, -290)
    t1.value74.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    t1.value74.BackgroundTransparency = 0.02
    t1.value74.BorderSizePixel = 0
    t1.value74.ZIndex = 2
    t1.value74.Parent = t1.value73
    t1.value74.Active = true
    t1.value74.ClipsDescendants = true
    Instance.new("UICorner", t1.value74).CornerRadius = UDim.new(0, 14)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1.5
    UIStroke.Color = Color3.fromRGB(80, 80, 100)
    UIStroke.Transparency = 0.15
    UIStroke.Parent = t1.value74
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -120, 0, 44)
    TextLabel.Position = UDim2.new(0, 18, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "📁  Saved Morph Manager"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 16
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 3
    TextLabel.Parent = t1.value74
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(0, 36, 0, 36)
    TextButton.Position = UDim2.new(1, -44, 0, 4)
    TextButton.Text = "✕"
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 18
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.BackgroundColor3 = t1.value70.Red
    TextButton.ZIndex = 3
    TextButton.Parent = t1.value74
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)
    TextButton.MouseButton1Click:Connect(function()
        t1.value73.Enabled = false
        t1.value76 = "FILES"
        t1.value77 = nil
        t1.value78 = nil
    end)
    local TextButton4 = Instance.new("TextButton")
    TextButton4.Size = UDim2.new(0, 36, 0, 36)
    TextButton4.Position = UDim2.new(1, -84, 0, 4)
    TextButton4.Text = "🔄"
    TextButton4.Font = Enum.Font.GothamBold
    TextButton4.TextSize = 16
    TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton4.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    TextButton4.ZIndex = 3
    TextButton4.Parent = t1.value74
    Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 6)
    local TextBox = Instance.new("TextBox")
    TextButton4.MouseButton1Click:Connect(function()
        if TextBox then
            t1.value79(TextBox.Text)
        else
            t1.value79("")
        end

        t1.value18("Manager", "List berhasil di-refresh!", 2)
    end)
    local TextButton5 = Instance.new("TextButton")
    TextButton5.Size = UDim2.new(0, 70, 0, 26)
    TextButton5.Position = UDim2.new(1, -160, 0, 9)
    TextButton5.Text = "⬅ Back"
    TextButton5.Font = Enum.Font.GothamBold
    TextButton5.TextSize = 12
    TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton5.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    TextButton5.ZIndex = 4
    TextButton5.Visible = false
    TextButton5.Parent = t1.value74
    Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 5)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -28, 0, 1)
    Frame.Position = UDim2.new(0, 14, 0, 46)
    Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 3
    Frame.Parent = t1.value74
    TextBox.Size = UDim2.new(1, -24, 0, 34)
    TextBox.Position = UDim2.new(0, 12, 0, 54)
    TextBox.PlaceholderText = "🔍  Cari semua file (Avatar / Clan)..."
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 13
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    TextBox.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
    TextBox.ClearTextOnFocus = false
    TextBox.ZIndex = 3
    TextBox.Parent = t1.value74
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)
    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Size = UDim2.new(1, -24, 0, 22)
    TextLabel3.Position = UDim2.new(0, 12, 0, 94)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.TextColor3 = Color3.fromRGB(140, 140, 160)
    TextLabel3.Font = Enum.Font.Gotham
    TextLabel3.TextSize = 12
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.Text = "0 file tersimpan"
    TextLabel3.ZIndex = 3
    TextLabel3.Parent = t1.value74
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(1, -24, 1, -124)
    Frame2.Position = UDim2.new(0, 12, 0, 118)
    Frame2.BackgroundTransparency = 1
    Frame2.ZIndex = 3
    Frame2.ClipsDescendants = true
    Frame2.Parent = t1.value74
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 120)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ZIndex = 3
    ScrollingFrame.Parent = Frame2
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ScrollingFrame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.PaddingRight = UDim.new(0, 2)
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.Parent = ScrollingFrame
    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Size = UDim2.new(1, 0, 0, 80)
    TextLabel4.Position = UDim2.new(0, 0, 0.25, 0)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.TextColor3 = Color3.fromRGB(110, 110, 130)
    TextLabel4.Font = Enum.Font.Gotham
    TextLabel4.TextSize = 14
    TextLabel4.Text = "Belum ada file JSON tersimpan.\nKlik 'Save 1:1'."
    TextLabel4.TextWrapped = true
    TextLabel4.ZIndex = 4
    TextLabel4.Visible = true
    TextLabel4.Parent = ScrollingFrame
    TextButton5.MouseButton1Click:Connect(function()
        t1.value76 = "FILES"
        t1.value77 = nil
        t1.value78 = nil
        TextBox.Text = ""
        t1.value79("")
    end)
    local function v547(p67, p68)
        local Frame3 = Instance.new("Frame")

        Frame3.Size = UDim2.new(1, 0, 0, 110)
        Frame3.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        Frame3.BorderSizePixel = 0
        Frame3.ZIndex = 4
        Frame3.LayoutOrder = p68
        Frame3.Parent = ScrollingFrame
        Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 9)

        local UIStroke2 = Instance.new("UIStroke")

        UIStroke2.Thickness = 1
        UIStroke2.Color = Color3.fromRGB(55, 55, 75)
        UIStroke2.Parent = Frame3

        local Frame4 = Instance.new("Frame")

        Frame4.Size = UDim2.new(0, 86, 0, 86)
        Frame4.Position = UDim2.new(0, 7, 0, 7)
        Frame4.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        Frame4.BorderSizePixel = 0
        Frame4.ZIndex = 5
        Frame4.Parent = Frame3
        Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 7)

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p67.thumbnail or ""
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.ZIndex = 6
        ImageLabel.Parent = Frame4

        local v691 = not p67.thumbnail

        if not v691 then
            v691 = p67.thumbnail == ""
        end

        if v691 then
            local TextLabel5 = Instance.new("TextLabel")

            TextLabel5.Size = UDim2.new(1, 0, 1, 0)
            TextLabel5.BackgroundTransparency = 1
            TextLabel5.Text = "👤"
            TextLabel5.TextScaled = true
            TextLabel5.Font = Enum.Font.GothamBold
            TextLabel5.TextColor3 = Color3.fromRGB(90, 90, 110)
            TextLabel5.ZIndex = 7
            TextLabel5.Parent = Frame4
        end

        local n2 = 100
        local TextLabel6 = Instance.new("TextLabel")

        TextLabel6.Size = UDim2.new(1, -(n2 + 8), 0, 26)
        TextLabel6.Position = UDim2.new(0, n2, 0, 7)
        TextLabel6.BackgroundTransparency = 1
        TextLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel6.Font = Enum.Font.GothamBold
        TextLabel6.TextSize = 14
        TextLabel6.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel6.Text = p67.name
        TextLabel6.ZIndex = 5
        TextLabel6.Parent = Frame3

        local Frame5 = Instance.new("Frame")

        Frame5.Size = UDim2.new(1, -(n2 + 8), 0, 1)
        Frame5.Position = UDim2.new(0, n2, 0, 35)
        Frame5.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
        Frame5.BorderSizePixel = 0
        Frame5.ZIndex = 5
        Frame5.Parent = Frame3

        local TextLabel7 = Instance.new("TextLabel")

        TextLabel7.Size = UDim2.new(1, -(n2 + 8), 0, 16)
        TextLabel7.Position = UDim2.new(0, n2, 0, 39)
        TextLabel7.BackgroundTransparency = 1
        TextLabel7.TextColor3 = Color3.fromRGB(120, 160, 120)
        TextLabel7.Font = Enum.Font.Gotham
        TextLabel7.TextSize = 11
        TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel7.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel7.Text = "👤 Clan Member"
        TextLabel7.ZIndex = 5
        TextLabel7.Parent = Frame3

        local TextButton6 = Instance.new("TextButton")

        TextButton6.Size = UDim2.new(0, 100, 0, 30)
        TextButton6.Position = UDim2.new(0, n2, 0, 60)
        TextButton6.Text = "▶ Morph"
        TextButton6.Font = Enum.Font.GothamBold
        TextButton6.TextSize = 12
        TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton6.BackgroundColor3 = Color3.fromRGB(40, 130, 70)
        TextButton6.ZIndex = 5
        TextButton6.Parent = Frame3
        Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 6)

        local TextButton7 = Instance.new("TextButton")

        TextButton7.Size = UDim2.new(0, 80, 0, 30)
        TextButton7.Position = UDim2.new(0, n2 + 108, 0, 60)
        TextButton7.Text = "🗑 Delete"
        TextButton7.Font = Enum.Font.GothamBold
        TextButton7.TextSize = 11
        TextButton7.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton7.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
        TextButton7.ZIndex = 5
        TextButton7.Parent = Frame3
        Instance.new("UICorner", TextButton7).CornerRadius = UDim.new(0, 6)
        TextButton7.MouseButton1Click:Connect(function()
            local value77 = t1.value77

            if value77 then
                value77 = t1.value77.items
            end

            if value77 then
                table.remove(t1.value77.items, p68)

                local name = t1.value77.name
                local isClan = t1.value77.isClan
                local items = t1.value77.items
                local t65 = {
					version = 8,
					name = name,
					isClan = isClan,
					items = items
				}
                local ok, result = pcall(function()
                    return t1.value6:JSONEncode(t65)
                end)

                if ok then
                    ok = t1.value78
                end

                if ok then
                    local value78 = t1.value78
                    local _, _ = pcall(writefile, value78, result)

                    t1.value18("Clan Manager", p67.name .. " dihapus.", 3)
                    t1.value79(TextBox.Text)
                end
            end
        end)
        TextButton6.MouseButton1Click:Connect(function()
            task.spawn(function()
                local t66, v881 = t1.value68(p67)
                if t66 then
                    t1.value18("Morph System", "Berhasil morph menjadi " .. p67.name or "Unknown", 3)

                    return
                end
                t1.value18("Morph System", "Gagal: " .. tostring(v881), 3)
            end)
        end)

        return Frame3
    end
    local function v548(p69, p70)
        local Frame6 = Instance.new("Frame")

        Frame6.Size = UDim2.new(1, 0, 0, 110)
        Frame6.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        Frame6.BorderSizePixel = 0
        Frame6.ZIndex = 4
        Frame6.LayoutOrder = p70
        Frame6.Parent = ScrollingFrame
        Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 9)

        local UIStroke3 = Instance.new("UIStroke")

        UIStroke3.Thickness = 1
        UIStroke3.Color = Color3.fromRGB(55, 55, 75)
        UIStroke3.Parent = Frame6

        local Frame7 = Instance.new("Frame")

        Frame7.Size = UDim2.new(0, 86, 0, 86)
        Frame7.Position = UDim2.new(0, 7, 0, 7)
        Frame7.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        Frame7.BorderSizePixel = 0
        Frame7.ZIndex = 5
        Frame7.Parent = Frame6
        Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 7)

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p69.thumbnail or ""
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.ZIndex = 6
        ImageLabel.Parent = Frame7

        local v705 = not p69.thumbnail

        if not v705 then
            v705 = p69.thumbnail == ""
        end

        if v705 then
            local TextLabel8 = Instance.new("TextLabel")

            TextLabel8.Size = UDim2.new(1, 0, 1, 0)
            TextLabel8.BackgroundTransparency = 1
            TextLabel8.Text = "👤"
            TextLabel8.TextScaled = true
            TextLabel8.Font = Enum.Font.GothamBold
            TextLabel8.TextColor3 = Color3.fromRGB(90, 90, 110)
            TextLabel8.ZIndex = 7
            TextLabel8.Parent = Frame7
        end

        local n3 = 100
        local v708 = p69.fileName:gsub("%.json$", ""):gsub("%.JSON$", "")
        local TextLabel9 = Instance.new("TextLabel")

        TextLabel9.Size = UDim2.new(1, -(n3 + 8), 0, 26)
        TextLabel9.Position = UDim2.new(0, n3, 0, 7)
        TextLabel9.BackgroundTransparency = 1
        TextLabel9.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel9.Font = Enum.Font.GothamBold
        TextLabel9.TextSize = 14
        TextLabel9.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel9.Text = v708
        TextLabel9.ZIndex = 5
        TextLabel9.Parent = Frame6

        local Frame8 = Instance.new("Frame")

        Frame8.Size = UDim2.new(1, -(n3 + 8), 0, 1)
        Frame8.Position = UDim2.new(0, n3, 0, 35)
        Frame8.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
        Frame8.BorderSizePixel = 0
        Frame8.ZIndex = 5
        Frame8.Parent = Frame6

        local v711 = p69._kind == "clan"

        if p69._kind ~= "avatar" then
        end

        local v712, color3_8

        if v711 then
            v712 = "👥 Clan Database (" .. (#p69.data.items or {}) .. " Members)"
            color3_8 = Color3.fromRGB(140, 180, 220)
        else
            v712 = "👤 1:1 Outfit Avatar"
            color3_8 = Color3.fromRGB(120, 220, 140)
        end

        local TextLabel10 = Instance.new("TextLabel")

        TextLabel10.Size = UDim2.new(1, -(n3 + 8), 0, 16)
        TextLabel10.Position = UDim2.new(0, n3, 0, 39)
        TextLabel10.BackgroundTransparency = 1
        TextLabel10.TextColor3 = color3_8
        TextLabel10.Font = Enum.Font.Gotham
        TextLabel10.TextSize = 11
        TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel10.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel10.Text = v712
        TextLabel10.ZIndex = 5
        TextLabel10.Parent = Frame6

        local TextButton8 = Instance.new("TextButton")

        TextButton8.Size = UDim2.new(0, 100, 0, 30)
        TextButton8.Position = UDim2.new(0, n3, 0, 60)
        TextButton8.Text = not v711 and "▶ Morph" or "📂 Open"
        TextButton8.Font = Enum.Font.GothamBold
        TextButton8.TextSize = 12
        TextButton8.TextColor3 = Color3.fromRGB(255, 255, 255)

        local v716 = v711

        if v711 then
            v716 = Color3.fromRGB(50, 100, 150)
        end

        if not v716 then
            v716 = Color3.fromRGB(40, 130, 70)
        end

        TextButton8.BackgroundColor3 = v716
        TextButton8.ZIndex = 5
        TextButton8.Parent = Frame6
        Instance.new("UICorner", TextButton8).CornerRadius = UDim.new(0, 6)

        local TextButton9 = Instance.new("TextButton")

        TextButton9.Size = UDim2.new(0, 80, 0, 30)
        TextButton9.Position = UDim2.new(0, n3 + 100 + 8, 0, 60)
        TextButton9.Text = "✏ Rename"
        TextButton9.Font = Enum.Font.GothamBold
        TextButton9.TextSize = 11
        TextButton9.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton9.BackgroundColor3 = Color3.fromRGB(70, 95, 160)
        TextButton9.ZIndex = 5
        TextButton9.Parent = Frame6
        Instance.new("UICorner", TextButton9).CornerRadius = UDim.new(0, 6)

        local TextButton10 = Instance.new("TextButton")

        TextButton10.Size = UDim2.new(0, 80, 0, 30)
        TextButton10.Position = UDim2.new(0, n3 + 100 + 8 + 80 + 8, 0, 60)
        TextButton10.Text = "🗑 Delete"
        TextButton10.Font = Enum.Font.GothamBold
        TextButton10.TextSize = 11
        TextButton10.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton10.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
        TextButton10.ZIndex = 5
        TextButton10.Parent = Frame6
        Instance.new("UICorner", TextButton10).CornerRadius = UDim.new(0, 6)
        TextButton8.MouseButton1Click:Connect(function()
            if v711 then
                t1.value76 = "CLAN"
                t1.value77 = p69.data

                local _ = p69.path

                TextBox.Text = ""
                t1.value79("")

                return
            end

            task.spawn(function()
                local t67, v883 = t1.value68(p69.data)
                if t67 then
                    t1.value18("Morph System", "Berhasil morph menjadi " .. v708, 3)

                    return
                end
                t1.value18("Morph System", "Gagal: " .. tostring(v883), 3)
            end)
        end)
        TextButton9.MouseButton1Click:Connect(function()
            t1.value72(function(p71)
                if p71 == "" or p71 == v708 then
                    return
                end

                local v885 = t1.value22(p69.path)

                if v885 then
                    local ok, result = pcall(function()
                        return t1.value6:JSONDecode(v885)
                    end)
                    local v888 = result

                    if ok then
                        ok = type(v888) == "table"
                    end

                    if ok then
                        v888.name = p71
                        local success, result = pcall(function()
                            return t1.value6:JSONEncode(v888)
                        end)
                        if success then
                            local v891 = p69.path:match("^(.*)[/\\][^/\\]+$") or t1.value15 .. "/" .. t1.value28(p71) .. ".json"

                            if v891 ~= p69.path then
                                local _, _ = pcall(writefile, v891, result)

                                t1.value23(p69.path)
                                t1.value18("Rename", "File diubah menjadi: " .. p71, 3)
                                t1.value79(TextBox.Text)
                            end
                        end
                    end
                end
            end, "✏ Rename File", "Masukkan nama baru untuk file ini:", v708)
        end)
        TextButton10.MouseButton1Click:Connect(function()
            t1.value23(p69.path)
            t1.value18("Delete", "File " .. v708 .. " dihapus.", 3)
            t1.value79(TextBox.Text)
        end)

        return Frame6
    end
    function t1.value79(p72)
        local CanvasPosition = ScrollingFrame.CanvasPosition
        for v723, v724 in ipairs(t1.value75) do

            if v724 and v724.Parent then
                v724:Destroy()
            end
        end
        t1.value75 = {}
        if not p72 then
            p72 = ""
        end
        local v725 = p72:lower()
        local n4 = 0
        if t1.value76 == "FILES" then
            TextButton5.Visible = false
            TextLabel.Text = "📁  Saved Morph Manager"

            local v727 = t1.value80()

            for i, v in ipairs(v727) do
                local v730 = v.fileName:gsub("%.json$", ""):gsub("%.JSON$", "")
                local v731 = tostring(v._kind):lower()
                local v732 = v725 == ""

                if not v732 then
                    v732 = v730:lower():find(v725, 1, true)

                    if not v732 then
                        v732 = v731:find(v725, 1, true)
                    end
                end

                if v732 then
                    local v733 = v548(v, i)

                    table.insert(t1.value75, v733)
                    n4 += 1
                end
            end

            TextLabel4.Text = "Belum ada file JSON tersimpan.\nKlik 'Save Current Avatar'."
        elseif t1.value76 == "CLAN" then
            TextButton5.Visible = true

            local v734 = TextLabel
            local value77 = t1.value77

            if value77 then
                value77 = t1.value77.name
            end

            v734.Text = "👥 Clan: " .. (value77 or "Unknown")

            local value77_2 = t1.value77

            if value77_2 then
                value77_2 = type(t1.value77.items) == "table"
            end

            if value77_2 then
                for i, v in ipairs(t1.value77.items) do
                    local v739 = v725 == ""

                    if not v739 then
                        v739 = tostring(v.name):lower():find(v725, 1, true)
                    end

                    if v739 then
                        local v740 = v547(v, i)

                        table.insert(t1.value75, v740)
                        n4 += 1
                    end
                end
            end

            TextLabel4.Text = "Grup ini kosong."
        end
        TextLabel4.Visible = n4 == 0
        TextLabel3.Text = n4 .. (t1.value76 ~= "FILES" and " member" or " file ditemukan")
        task.wait()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 14)
        ScrollingFrame.CanvasPosition = CanvasPosition
    end
    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        t1.value79(TextBox.Text)
    end)
    t1.value79("")
    local u549 = false
    local inputPosition
    local value74Position
    t1.value74.InputBegan:Connect(function(input)
        local v742 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v742 then
            v742 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v742 then
            u549 = true
            inputPosition = input.Position
            value74Position = t1.value74.Position
        end
    end)
    t1.value5.InputEnded:Connect(function(input)
        local v744 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v744 then
            v744 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v744 then
            u549 = false
        end
    end)
    t1.value5.InputChanged:Connect(function(input)
        local v746 = u549

        if v746 then
            v746 = input.UserInputType == Enum.UserInputType.MouseMovement

            if not v746 then
                v746 = input.UserInputType == Enum.UserInputType.Touch
            end
        end

        if v746 then
            local v747 = input.Position - inputPosition

            t1.value74.Position = UDim2.new(value74Position.X.Scale, value74Position.X.Offset + v747.X, value74Position.Y.Scale, value74Position.Y.Offset + v747.Y)
        end
    end)
end;
(function()
    local s1 = "KixPhantomMorphUI"
    pcall(function()
        local s1_2 = t1.value3:FindFirstChild(s1)

        if s1_2 then
            s1_2:Destroy()
        end
    end)
    pcall(function()
        local v749 = typeof(gethui) == "function" and gethui() or nil

        if v749 then
            local s1_3 = v749:FindFirstChild(s1)

            if s1_3 then
                s1_3:Destroy()
            end
        end
    end)
    local value8 = t1.value8
    if value8 then
        value8 = t1.value8:FindFirstChild("PlayerGui")
    end
    local v554 = value8
    if v554 then
        pcall(function()
            local s1_4 = v554:FindFirstChild(s1)

            if s1_4 then
                s1_4:Destroy()
            end
        end)
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = s1
    ScreenGui.ResetOnSpawn = false
    t1.value19(ScreenGui)
    t1.value20(ScreenGui)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 600)
    Frame.Position = UDim2.new(0, 20, 0.5, -300)
    Frame.BackgroundColor3 = t1.value70.BG
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Frame).Color = t1.value70.Divider
    local Frame9 = Instance.new("Frame")
    Frame9.Size = UDim2.new(1, 0, 0, 36)
    Frame9.BackgroundTransparency = 1
    Frame9.Parent = Frame
    Frame9.Active = true
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -80, 1, 0)
    TextLabel.Position = UDim2.new(0, 12, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "AVATAR CHANGER by KIXDEV"
    TextLabel.TextColor3 = t1.value70.Accent
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame9
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(0, 36, 0, 36)
    TextButton.Position = UDim2.new(1, -72, 0, 0)
    TextButton.Text = "-"
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 18
    TextButton.TextColor3 = t1.value70.Text
    TextButton.BackgroundTransparency = 1
    TextButton.Parent = Frame9
    local TextButton11 = Instance.new("TextButton")
    TextButton11.Size = UDim2.new(0, 36, 0, 36)
    TextButton11.Position = UDim2.new(1, -36, 0, 0)
    TextButton11.Text = "X"
    TextButton11.Font = Enum.Font.GothamBold
    TextButton11.TextSize = 16
    TextButton11.TextColor3 = t1.value70.Red
    TextButton11.BackgroundTransparency = 1
    TextButton11.Parent = Frame9
    local Frame10 = Instance.new("Frame")
    Frame10.Size = UDim2.new(1, 0, 1, -36)
    Frame10.Position = UDim2.new(0, 0, 0, 36)
    Frame10.BackgroundTransparency = 1
    Frame10.Parent = Frame
    local u562 = false
    local inputPosition
    local FramePosition
    Frame9.InputBegan:Connect(function(input)
        local v753 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v753 then
            v753 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v753 then
            u562 = true
            inputPosition = input.Position
            FramePosition = Frame.Position
        end
    end)
    t1.value5.InputEnded:Connect(function(input)
        local v755 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v755 then
            v755 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v755 then
            u562 = false
        end
    end)
    t1.value5.InputChanged:Connect(function(input)
        local v757 = u562

        if v757 then
            v757 = input.UserInputType == Enum.UserInputType.MouseMovement

            if not v757 then
                v757 = input.UserInputType == Enum.UserInputType.Touch
            end
        end

        if v757 then
            local v758 = input.Position - inputPosition

            Frame.Position = UDim2.new(FramePosition.X.Scale, FramePosition.X.Offset + v758.X, FramePosition.Y.Scale, FramePosition.Y.Offset + v758.Y)
        end
    end)
    local u565 = false
    local uDim2 = UDim2.new(0, 280, 0, 600)
    local uDim2_2 = UDim2.new(0, 280, 0, 36)
    TextButton.MouseButton1Click:Connect(function()
        u565 = not u565
        Frame.Size = u565 and uDim2_2 or uDim2
        TextButton.Text = not u565 and "-" or "+"
        Frame10.Visible = not u565
    end)
    TextButton11.MouseButton1Click:Connect(function()
        t1.value65()
        t1.value52()

        if t1.value54 then
            pcall(function()
                t1.value54:Disconnect()
            end)
        end

        if t1.value9 then
            pcall(function()
                t1.value9:Disconnect()
            end)
        end

        if t1.value73 then
            pcall(function()
                t1.value73:Destroy()
            end)
        end

        if t1.value69 then
            pcall(function()
                t1.value69:Destroy()
            end)
        end

        pcall(function()
            ScreenGui:Destroy()
        end)
    end)
    t1.value5.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.Comma then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    local TextLabel11 = Instance.new("TextLabel")
    TextLabel11.Size = UDim2.new(1, -24, 0, 15)
    TextLabel11.Position = UDim2.new(0, 12, 0, 5)
    TextLabel11.BackgroundTransparency = 1
    TextLabel11.Text = "Status: Idle"
    TextLabel11.TextColor3 = Color3.fromRGB(150, 150, 150)
    TextLabel11.Font = Enum.Font.Gotham
    TextLabel11.TextSize = 11
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel11.Parent = Frame10
    local function v569(p73, p74)
        TextLabel11.Text = p73

        local v763 = TextLabel11

        if not p74 then
            p74 = t1.value70.Accent
        end

        v763.TextColor3 = p74
    end
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -24, 0, 30)
    TextBox.Position = UDim2.new(0, 12, 0, 25)
    TextBox.BackgroundColor3 = t1.value70.Panel
    TextBox.TextColor3 = t1.value70.Text
    TextBox.Text = ""
    TextBox.PlaceholderText = "Search by username or ID..."
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 12
    TextBox.Parent = Frame10
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)
    local function v571(p75, p76, p77)
        local TextButton12 = Instance.new("TextButton")

        TextButton12.Size = UDim2.new(1, -24, 0, 28)
        TextButton12.Position = UDim2.new(0, 12, 0, p75)
        TextButton12.BackgroundColor3 = p77
        TextButton12.Text = p76
        TextButton12.TextColor3 = t1.value70.Text
        TextButton12.Font = Enum.Font.GothamBold
        TextButton12.TextSize = 12
        TextButton12.Parent = Frame10
        Instance.new("UICorner", TextButton12).CornerRadius = UDim.new(0, 4)

        return TextButton12
    end
    local v572 = v571(60, "> Morph by Target", t1.value70.Panel)
    local v573 = v571(93, "[X] Unmorph (Restore Self)", t1.value70.Red)
    local function v574()
        local TextBoxText = TextBox.Text

        if TextBoxText == "" then
            return v569("Input kosong!", t1.value70.Red)
        end

        local v769 = 15 - (os.time() - 0)

        if v769 > 0 then
            return v569("Spam terdeteksi! Tunggu " .. v769 .. " detik.", t1.value70.Red)
        end

        v572.Text = "Memproses..."

        local v770 = "Resolving " .. TextBoxText .. "..."
        local value70Text = t1.value70.Text

        TextLabel11.Text = v770

        local v772 = TextLabel11

        if not value70Text then
            value70Text = t1.value70.Accent
        end

        v772.TextColor3 = value70Text

        local v773, v774 = t1.value67(TextBoxText)

        if v773 then
            os.time()
        end

        local v775 = v569

        if v773 then
            v773 = t1.value70.Green
        end

        if not v773 then
            v773 = t1.value70.Red
        end

        v775(v774, v773)
        v572.Text = "> Morph by Target"
    end
    v572.MouseButton1Click:Connect(v574)
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            v574()
        end
    end)
    v573.MouseButton1Click:Connect(function()
        t1.value65()

        local Accent = t1.value70.Accent

        TextLabel11.Text = "Karakter dikembalikan."

        local v778 = TextLabel11

        if not Accent then
            Accent = t1.value70.Accent
        end

        v778.TextColor3 = Accent
    end)
    local Frame11 = Instance.new("Frame")
    Frame11.Size = UDim2.new(1, -24, 0, 1)
    Frame11.Position = UDim2.new(0, 12, 0, 130)
    Frame11.BackgroundColor3 = t1.value70.Divider
    Frame11.BorderSizePixel = 0
    Frame11.Parent = Frame10
    local v576 = v571(138, "💾 Save Current Avatar", Color3.fromRGB(43, 105, 122))
    local v577 = v571(171, "📂 Open Saved Manager", Color3.fromRGB(60, 80, 100))
    v576.MouseButton1Click:Connect(function()
        if not t1.value26() then
            local Red = t1.value70.Red

            TextLabel11.Text = "Executor tidak mendukung File API!"

            local v780 = TextLabel11

            if not Red then
                Red = t1.value70.Accent
            end

            v780.TextColor3 = Red

            return
        end

        local value10 = t1.value10

        if not value10 then
            value10 = t1.value8.Character
        end

        local v782 = value10
        local v783 = v782

        if v783 then
            v783 = v782:FindFirstChildOfClass("Humanoid")
        end

        local v784 = v783

        if not v784 then
            return
        end

        t1.value72(function(p78)
            task.spawn(function()
                local UserId = t1.value8.UserId
                local v895 = p78
                local DisplayName = t1.value8.DisplayName
                local v897 = t1.value38(v784:GetAppliedDescription())
                local v898 = t1.value41(v782)
                local v899 = t1.value40(v782)
                local v900 = v2(v782, not t1.value10)
                local v901 = t1.value37(v782)
                local t69 = {
					version = 8,
					userId = UserId,
					name = v895,
					displayName = DisplayName,
					thumbnail = "",
					descData = v897,
					accData = v898,
					bodyData = v899,
					overheadsData = v900,
					overheadMapData = v901,
					isHeadless = false,
					hideVFX = false
				}

                pcall(function()
                    t69.thumbnail = t1.value1:GetUserThumbnailAsync(t1.value8.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
                end)

                local ok, result = pcall(function()
                    return t1.value6:JSONEncode(t69)
                end)

                if ok then
                    t1.value27()

                    local v905 = t1.value29(p78)
                    local _, _ = pcall(writefile, v905, result)
                    local v908 = "✔ Tersimpan: " .. t1.value28(p78) .. ".json"
                    local Green = t1.value70.Green

                    TextLabel11.Text = v908

                    local v910 = TextLabel11

                    if not Green then
                        Green = t1.value70.Accent
                    end

                    v910.TextColor3 = Green
                    t1.value18("Save Avatar", t1.value28(p78) .. " berhasil disimpan.", 3)

                    return
                end

                local Red = t1.value70.Red

                TextLabel11.Text = "Error JSON Encode"

                local v912 = TextLabel11

                if not Red then
                    Red = t1.value70.Accent
                end

                v912.TextColor3 = Red
            end)
        end)
    end)
    v577.MouseButton1Click:Connect(function()
        if not t1.value73 then
            t1.value81()

            return
        end

        t1.value73.Enabled = true
        t1.value79("")
    end)
    local Frame12 = Instance.new("Frame")
    Frame12.Size = UDim2.new(1, -24, 0, 1)
    Frame12.Position = UDim2.new(0, 12, 0, 208)
    Frame12.BackgroundColor3 = t1.value70.Divider
    Frame12.BorderSizePixel = 0
    Frame12.Parent = Frame10
    local TextLabel12 = Instance.new("TextLabel")
    TextLabel12.Size = UDim2.new(1, -24, 0, 20)
    TextLabel12.Position = UDim2.new(0, 12, 0, 215)
    TextLabel12.BackgroundTransparency = 1
    TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel12.Font = Enum.Font.Gotham
    TextLabel12.TextSize = 12
    TextLabel12.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel12.Text = "Anim Pack: Default"
    TextLabel12.Parent = Frame10
    local TextBox2 = Instance.new("TextBox")
    TextBox2.Size = UDim2.new(1, -24, 0, 30)
    TextBox2.Position = UDim2.new(0, 12, 0, 240)
    TextBox2.BackgroundColor3 = t1.value70.Panel
    TextBox2.TextColor3 = t1.value70.Text
    TextBox2.PlaceholderText = "Search pack..."
    TextBox2.Text = ""
    TextBox2.ClearTextOnFocus = false
    TextBox2.Font = Enum.Font.Gotham
    TextBox2.TextSize = 12
    TextBox2.Parent = Frame10
    Instance.new("UICorner", TextBox2).CornerRadius = UDim.new(0, 4)
    local Frame13 = Instance.new("Frame")
    Frame13.Size = UDim2.new(1, -24, 0, 160)
    Frame13.Position = UDim2.new(0, 12, 0, 275)
    Frame13.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Frame13.BorderSizePixel = 0
    Frame13.Parent = Frame10
    Instance.new("UICorner", Frame13).CornerRadius = UDim.new(0, 6)
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
    ScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Parent = Frame13
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingBottom = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.PaddingRight = UDim.new(0, 4)
    UIPadding.Parent = ScrollingFrame
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        task.wait()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    local TextButton13 = Instance.new("TextButton")
    TextButton13.Size = UDim2.new(1, 0, 0, 30)
    TextButton13.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
    TextButton13.TextColor3 = t1.value70.Text
    TextButton13.Font = Enum.Font.GothamBold
    TextButton13.TextSize = 12
    TextButton13.Text = "🌟 Restore Default Animations"
    TextButton13.AutoButtonColor = true
    TextButton13.LayoutOrder = -1
    TextButton13.BorderSizePixel = 0
    TextButton13.Parent = ScrollingFrame
    Instance.new("UICorner", TextButton13).CornerRadius = UDim.new(0, 4)
    TextButton13.Activated:Connect(function()
        if t1.value52() then
            TextLabel12.Text = "Anim Pack: Default"
        end
    end)
    local t70 = {}
    for i, v in ipairs({
		"Adidas Sports",
		"Adidas Community",
		"Adidas Aura"
	}) do
        t70[v] = i
    end
    local t71 = {}
    for k in pairs(t1.value43) do
        table.insert(t71, k)
    end
    table.sort(t71, function(p79, p80)
        local v787 = t70[p79]
        local v788 = t70[p80]

        if v787 and v788 then
            return v787 < v788
        end

        if v787 then
            return true
        end

        if v788 then
            return false
        end

        return p79:lower() < p80:lower()
    end)
    local t72 = {}
    for i, v in ipairs(t71) do
        local v594 = v
        local TextButton14 = Instance.new("TextButton")

        TextButton14.Size = UDim2.new(1, 0, 0, 30)
        TextButton14.BackgroundColor3 = t1.value70.Panel
        TextButton14.TextColor3 = t1.value70.Text
        TextButton14.Font = Enum.Font.GothamBold
        TextButton14.TextSize = 12
        TextButton14.Text = v594
        TextButton14.AutoButtonColor = true
        TextButton14.LayoutOrder = i
        TextButton14.BorderSizePixel = 0
        TextButton14.Parent = ScrollingFrame
        Instance.new("UICorner", TextButton14).CornerRadius = UDim.new(0, 4)
        TextButton14.Activated:Connect(function()
            TextLabel12.Text = t1.value53(v594) and "Anim Pack: " .. v594 or "Anim Pack: (failed) " .. v594
        end)
        t72[v594] = TextButton14
    end
    task.wait()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    TextBox2:GetPropertyChangedSignal("Text"):Connect(function()
        local v789 = TextBox2.Text:lower()

        for k, v in pairs(t72) do
            v.Visible = v789 == "" or k:lower():find(v789, 1, true) ~= nil
        end

        task.wait()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    local Frame14 = Instance.new("Frame")
    Frame14.Size = UDim2.new(1, -24, 0, 1)
    Frame14.Position = UDim2.new(0, 12, 0, 445)
    Frame14.BackgroundColor3 = t1.value70.Divider
    Frame14.BorderSizePixel = 0
    Frame14.Parent = Frame10
    local TextLabel13 = Instance.new("TextLabel")
    TextLabel13.Size = UDim2.new(1, -24, 0, 20)
    TextLabel13.Position = UDim2.new(0, 12, 0, 455)
    TextLabel13.BackgroundTransparency = 1
    TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel13.Font = Enum.Font.GothamBold
    TextLabel13.TextSize = 12
    TextLabel13.TextColor3 = t1.value70.Accent
    TextLabel13.Text = "Custom Emote Player by ID"
    TextLabel13.Parent = Frame10
    local TextBox3 = Instance.new("TextBox")
    TextBox3.Size = UDim2.new(1, -24, 0, 30)
    TextBox3.Position = UDim2.new(0, 12, 0, 480)
    TextBox3.BackgroundColor3 = t1.value70.Panel
    TextBox3.TextColor3 = t1.value70.Text
    TextBox3.PlaceholderText = "Insert ID Emote..."
    TextBox3.Text = ""
    TextBox3.ClearTextOnFocus = false
    TextBox3.Font = Enum.Font.Gotham
    TextBox3.TextSize = 12
    TextBox3.Parent = Frame10
    Instance.new("UICorner", TextBox3).CornerRadius = UDim.new(0, 4)
    local TextButton15 = Instance.new("TextButton")
    TextButton15.Size = UDim2.new(0.5, -16, 0, 28)
    TextButton15.Position = UDim2.new(0, 12, 0, 515)
    TextButton15.BackgroundColor3 = t1.value70.Green
    TextButton15.Text = "Play"
    TextButton15.TextColor3 = t1.value70.Text
    TextButton15.Font = Enum.Font.GothamBold
    TextButton15.TextSize = 12
    TextButton15.Parent = Frame10
    Instance.new("UICorner", TextButton15).CornerRadius = UDim.new(0, 4)
    local TextButton16 = Instance.new("TextButton")
    TextButton16.Size = UDim2.new(0.5, -16, 0, 28)
    TextButton16.Position = UDim2.new(0.5, 4, 0, 515)
    TextButton16.BackgroundColor3 = t1.value70.Red
    TextButton16.Text = "Stop"
    TextButton16.TextColor3 = t1.value70.Text
    TextButton16.Font = Enum.Font.GothamBold
    TextButton16.TextSize = 12
    TextButton16.Parent = Frame10
    Instance.new("UICorner", TextButton16).CornerRadius = UDim.new(0, 4)
    TextButton15.MouseButton1Click:Connect(function()
        t1.value64(TextBox3.Text, TextBox3)
    end)
    TextButton16.MouseButton1Click:Connect(t1.value63)
    task.defer(function()
        local t1value45 = t1.value8:GetAttribute(t1.value45)
        local v793 = type(t1value45) == "string"

        if v793 then
            v793 = t1value45 ~= "" and t1.value43[t1value45]
        end

        if v793 then
            TextLabel12.Text = "Anim Pack: " .. t1value45 .. " (saved)"

            return
        end

        TextLabel12.Text = "Anim Pack: Default"
    end)
    t1.value9 = t1.value8.CharacterAdded:Connect(function()
        if t1.value10 then
            task.wait(0.5)
            t1.value55()
        end
    end)
end)()
