-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
cheesy.AddonInfo = {
	Name = "HonchoESP",
	Title = "Honcho ESP",
	Description = "Color-coded box and terminal ESP for The Archives",
	Game = "TheArchives"
}
t2.value1 = game:GetService("Workspace")
t2.value2 = game:GetService("Players").LocalPlayer
t2.value3 = 5
t2.value4 = 10
t2.value5 = {
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 170, 255),
	Color3.fromRGB(180, 80, 255),
	Color3.fromRGB(255, 150, 0),
	Color3.fromRGB(255, 60, 60)
}
t2.value6 = Color3.fromRGB(255, 255, 255)
t2.value7 = nil
t2.value8 = false
t2.value9 = false
t2.value10 = false
t2.value11 = nil
t2.value12 = {}
t2.value7 = {}
function t2.value13()
    for _, v in ipairs(t2.value7) do
        if v then
            v:Disconnect()
        end
    end

    table.clear(t2.value7)
end
function t2.value14(p1, p2)
    local connection = p1:Connect(p2)

    table.insert(t2.value7, connection)

    return connection
end
function t2.value15(p3)
    local Handle = p3:FindFirstChild("Handle")

    if not Handle then
        return nil
    end

    local Label = Handle:FindFirstChild("Label")

    if not Label then
        return nil
    end

    local Text = Label:FindFirstChild("Text")

    if not Text then
        return nil
    end

    local Label2 = Text:FindFirstChild("Label")

    if Label2 and Label2:IsA("TextLabel") then
        return Label2
    end

    return nil
end
function t2.value16(p4)
    local Screen = p4:FindFirstChild("Screen")

    if not Screen then
        return nil
    end

    local Text = Screen:FindFirstChild("Text")

    if not Text then
        return nil
    end

    local Label = Text:FindFirstChild("Label")
    local v28 = Label

    if Label then
        v28 = Label:IsA("TextLabel")
    end

    if v28 then
        return Label
    end

    return nil
end
function t2.value17(p5)
    if not p5 then
        return nil
    end

    if p5:IsA("BasePart") then
        return p5.Position
    end

    if p5:IsA("Model") then
        if p5.PrimaryPart then
            return p5.PrimaryPart.Position
        end

        return p5:GetPivot().Position
    end

    return nil
end
function t2.value18(p6)
    if p6 then
        local v14 = p6 ~= ""

        if v14 then
            v14 = p6 ~= "---"

            if v14 then
                v14 = string.match(p6, "^%u%-%d+$") ~= nil
            end
        end

        p6 = v14
    end

    return p6
end
t2.value19 = nil
function t2.value19(p7, p8, p9)
    if not p7 or not p7.Parent then
        return
    end

    local p9_2 = p7:FindFirstChild(p9)
    local v39 = not p9_2

    if not v39 then
        v39 = not p9_2:IsA("Highlight")
    end

    if v39 then
        p9_2 = Instance.new("Highlight")
        p9_2.Name = p9
        p9_2.FillTransparency = 0.3
        p9_2.OutlineTransparency = 0
        p9_2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        p9_2.Parent = p7
    end

    p9_2.FillColor = p8
    p9_2.OutlineColor = t2.value6
end
t2.value20 = nil
function t2.value20(p10, p11)
    if not p10 then
        return
    end

    local p11_2 = p10:FindFirstChild(p11)

    if p11_2 then
        p11_2:Destroy()
    end
end
function t2.value21()
    for _, v in pairs(t2.value12) do

        for v65 in pairs(v.terminals) do

            if v65 and v65.Parent then
                t2.value20(v65, "HonchoTerminalESP")
            end
        end
        for k in pairs(v.boxes) do
            local v67 = k

            if v67 and v67.Parent then
                t2.value20(v67, "HonchoBoxESP")
            end
        end
    end
end
function t2.value22(p12)
    if not t2.value11 or not p12 then
        return nil
    end

    while p12 and p12.Parent ~= t2.value11 do
        p12 = p12.Parent
    end

    if p12 and p12.Parent == t2.value11 then
        return p12
    end

    return nil
end
local function v3(p13)
    if not p13 then
        return nil
    end

    if t2.value12[p13] then
        return t2.value12[p13]
    end

    t2.value12[p13] = {
		terminals = {},
		boxes = {}
	}

    return t2.value12[p13]
end
function t2.value23(p14)
    local v41 = t2.value12[p14]
    if not v41 then
        return
    end
    local t3 = {}
    for v45, v46 in pairs(v41.terminals) do

        if v45 and v45.Parent then
            table.insert(t3, v45)

            local label = v46.label

            if label and label.Parent then
                local labelText = label.Text

                if t2.value18(labelText) then
                    v46.target = labelText
                else
                    v46.target = nil
                end
            else
                v46.target = nil
            end
        else
            v41.terminals[v45] = nil
        end
    end
    table.sort(t3, function(p15, p16)
        local GetFullName = p16.GetFullName

        return p15:GetFullName() < GetFullName(p16)
    end)
    for i, v in ipairs(t3) do
        local v51 = v41.terminals[v]
        local v52 = math.min(i, #t2.value5)

        v51.colorIndex = v52
        v51.color = t2.value5[v52]

        if t2.value8 and not t2.value10 then
            t2.value19(v, v51.color, "HonchoTerminalESP")
        end
    end
end
t2.value24 = nil
function t2.value24(p17, p18)
    local v55 = t2.value12[p17]

    if not v55 then
        return nil
    end

    for k, v in pairs(v55.terminals) do
        if p18 == v.target then
            return k
        end
    end

    return nil
end
function t2.value25(p19, p20)
    local v75 = t2.value12[p20]

    if not v75 then
        return
    end

    local v76 = v75.boxes[p19]

    if not v76 then
        return
    end

    local terminal = v76.terminal

    if terminal then
        terminal = v76.terminal.Parent

        if terminal then
            terminal = v76.target and v76.color
        end
    end

    if terminal then
        if t2.value8 and not t2.value10 then
            t2.value19(p19, v76.color, "HonchoBoxESP")
        end

        return
    end

    local v78 = t2.value15(p19)

    if not v78 then
        return
    end

    local Text = v78.Text

    if not t2.value18(Text) then
        return
    end

    local v80 = t2.value24(p20, Text)

    if not v80 then
        return
    end

    local v81 = v75.terminals[v80]

    if not v81 then
        return
    end

    v76.target = Text
    v76.terminal = v80
    v76.colorIndex = v81.colorIndex
    v76.color = v81.color

    if t2.value8 and not t2.value10 then
        t2.value19(p19, v76.color, "HonchoBoxESP")
    end
end
local function v4(p21)
    if not t2.value8 then
        return
    end

    if not p21:IsA("Model") then
        return
    end

    local v86 = t2.value22(p21)

    if not v86 then
        return
    end

    local v87 = v3(v86)

    if v87.boxes[p21] then
        t2.value25(p21, v86)

        return
    end

    v87.boxes[p21] = {
		target = nil,
		terminal = nil,
		colorIndex = nil,
		color = nil
	}

    local v88 = t2.value15(p21)

    if v88 then
        t2.value14(v88:GetPropertyChangedSignal("Text"), function()
            local value8 = t2.value8

            if value8 then
                value8 = p21.Parent
            end

            if value8 then
                local v142 = t2.value22(p21)

                if v142 then
                    t2.value25(p21, v142)
                end
            end
        end)
    end

    t2.value25(p21, v86)
    task.delay(0.15, function()
        local value8 = t2.value8

        if value8 then
            value8 = p21.Parent

            if value8 then
                value8 = v87.boxes[p21]
            end
        end

        if value8 then
            local v144 = t2.value22(p21)

            if v144 then
                t2.value25(p21, v144)
            end
        end
    end)
end
function t2.value26(p22, p23)
    if not t2.value12[p23] then
        return
    end

    t2.value20(p22, "HonchoBoxESP")
end
t2.value27 = nil
function t2.value27(p24)
    if not t2.value8 then
        return
    end

    if p24.Name ~= "ArchivesPackageDeposit" then
        return
    end

    local v92 = t2.value22(p24)

    if not v92 then
        return
    end

    local v93 = v3(v92)

    if v93.terminals[p24] then
        return
    end

    local v94 = t2.value16(p24)

    if not v94 then
        task.delay(0.15, function()
            local value8 = t2.value8

            if value8 then
                value8 = p24

                if value8 then
                    value8 = p24.Parent
                end
            end

            if value8 then
                t2.value27(p24)
            end
        end)

        return
    end

    local terminals = v93.terminals
    local v96 = t2.value5[1]

    terminals[p24] = {
		label = v94,
		target = nil,
		colorIndex = 1,
		color = v96
	}
    t2.value14(v94:GetPropertyChangedSignal("Text"), function()
        if not t2.value8 then
            return
        end

        t2.value23(v92)

        local v146 = t2.value12[v92]

        if not v146 then
            return
        end

        for k in pairs(v146.boxes) do
            local v148 = k

            if v148 and v148.Parent then
                t2.value25(v148, v92)
            end
        end
    end)
    t2.value23(v92)

    for k in pairs(v93.boxes) do
        local v98 = k

        if v98 and v98.Parent then
            t2.value25(v98, v92)
        end
    end
end
function t2.value28(p25, p26)
    local v84 = t2.value12[p26]

    if not v84 then
        return
    end

    t2.value20(p25, "HonchoTerminalESP")
    v84.terminals[p25] = nil
    t2.value23(p26)
end
function t2.value29(p27)
    if not p27 then
        return
    end
    local v100 = v3(p27)
    local GetDescendants = p27.GetDescendants
    for v104, v105 in ipairs(GetDescendants(p27)) do

        if v105.Name == "ArchivesPackageDeposit" then
            t2.value27(v105)
        else
            local v106 = v105.Name == "ArchivesStorageBox"

            if v106 then
                v106 = v105:IsA("Model")
            end

            if v106 then
                v4(v105)
            end
        end
    end
    t2.value23(p27)
    for k in pairs(v100.boxes) do
        local v108 = k

        if v108 and v108.Parent then
            t2.value25(v108, p27)
        end
    end
end
t2.value30 = nil
function t2.value30()
    if not t2.value11 then
        return
    end

    for _, child in ipairs(t2.value11:GetChildren()) do
        t2.value29(child)
    end
end
t2.value31 = nil
function t2.value31(p28, p29)
    if not p28 or not p28.Parent then
        return false
    end

    if not p29 or not p29.Parent then
        return false
    end

    local v70 = t2.value17(p28)
    local v71 = t2.value17(p29)

    if not v70 or not v71 then
        return false
    end

    return (v70 - v71).Magnitude <= t2.value4
end
function t2.value32()
    if not t2.value8 or t2.value10 then
        return
    end

    for k, v in pairs(t2.value12) do
        for k2, v2 in pairs(v.boxes) do
            local v128 = k2

            if not v128 then
                v.boxes[v128] = nil
            elseif v128.Parent then
                local v129 = t2.value22(v128)

                if v129 then
                    v129 = v129 == k

                    if v129 then
                        v129 = v2.terminal

                        if v129 then
                            v129 = v2.terminal.Parent
                        end
                    end
                end

                if v129 and t2.value31(v128, v2.terminal) then
                    t2.value20(v128, "HonchoBoxESP")
                    v.boxes[v128] = nil
                end
            end
        end
    end
end
function t2.value33()
    if not t2.value8 or t2.value10 then
        return
    end

    t2.value30()

    for _, v in pairs(t2.value12) do
        local _pairs = pairs
        for v116, v117 in _pairs(v.terminals) do

            local v118 = v116

            if v116 then
                v118 = v116.Parent and v117.color
            end

            if v118 then
                t2.value19(v116, v117.color, "HonchoTerminalESP")
            end
        end
        local _pairs2 = pairs
        for v120, v121 in _pairs2(v.boxes) do
            local v122 = v120
            local v123 = v122

            if v122 then
                v123 = v122.Parent

                if v123 then
                    v123 = v121.terminal and v121.color
                end
            end

            if v123 then
                _pairs2 = t2.value22

                if _pairs2(v122) then
                    _pairs2 = t2.value19
                    _pairs2(v122, v121.color, "HonchoBoxESP")
                end
            end
        end
    end
end
function t2.value34()
    if not t2.value2 then
        return false
    end

    local PlayerGui = t2.value2:FindFirstChild("PlayerGui")

    if PlayerGui and (PlayerGui:FindFirstChild("BossHealthBar", true) or PlayerGui:FindFirstChild("HonchoIndicator", true)) then
        return true
    end

    local Honcho = t2.value1:FindFirstChild("Honcho")
    local v60 = Honcho ~= nil

    if v60 then
        v60 = Honcho:IsA("Model")
    end

    return v60
end
function t2.value35()
    for k, v in pairs(t2.value12) do
        local v132 = k

        if not v132 or not v132.Parent then

            for v135 in pairs(v.terminals) do

                t2.value20(v135, "HonchoTerminalESP")
            end
            for k3 in pairs(v.boxes) do
                t2.value20(k3, "HonchoBoxESP")
            end
            t2.value12[v132] = nil
        end
    end
end
local function v5()
    if not t2.value11 then
        return
    end

    t2.value14(t2.value11.ChildAdded, function(p30)
        if not t2.value8 then
            return
        end

        task.delay(0.1, function()
            local value8 = t2.value8

            if value8 then
                value8 = p30

                if value8 then
                    value8 = p30.Parent == t2.value11
                end
            end

            if value8 then
                t2.value29(p30)
            end
        end)
    end)
    t2.value14(t2.value11.DescendantAdded, function(p31)
        if not t2.value8 then
            return
        end

        local v151 = p31.Name == "ArchivesStorageBox"

        if v151 then
            v151 = p31:IsA("Model")
        end

        if v151 then
            v4(p31)

            return
        end

        if p31.Name == "ArchivesPackageDeposit" then
            t2.value27(p31)
        end
    end)
    t2.value14(t2.value11.DescendantRemoving, function(p32)
        local v153 = t2.value22(p32)

        if not v153 then
            return
        end

        local v154 = t2.value12[v153]

        if not v154 then
            return
        end

        if v154.boxes[p32] then
            t2.value26(p32, v153)

            return
        end

        if v154.terminals[p32] then
            t2.value28(p32, v153)
        end
    end)
end
function t2.value36()
    t2.value13()
    table.clear(t2.value12)
    t2.value9 = false
    t2.value10 = false
    t2.value11 = t2.value1:FindFirstChild("CurrentRooms")

    if not t2.value11 then
        warn("[Cheesy] CurrentRooms was not found.")

        return
    end

    t2.value30()
    v5()
    task.spawn(function()
        while t2.value8 do
            if t2.value34() then
                t2.value9 = true
            elseif t2.value9 then
                t2.value9 = false
                t2.value10 = true
                t2.value21()

                return
            end

            t2.value32()
            t2.value35()
            task.wait(t2.value3)

            if t2.value8 and not t2.value10 then
                t2.value33()
            end
        end
    end)
end
function t2.value37()
    t2.value21()
    t2.value13()
    table.clear(t2.value12)
    t2.value11 = nil
    t2.value9 = false
    t2.value10 = false
end
local Groupbox = cheesy.Groupbox
local AddToggle = Groupbox.AddToggle
local t4 = {
	Text = "Enable Honcho ESP",
	Tooltip = "Color-coded ESP for Archives boxes and terminals",
	Default = false,
	Func = function(p33)
    t2.value8 = p33

    if p33 then
        print("[Cheesy] Honcho ESP enabled")
        t2.value36()

        return
    end

    print("[Cheesy] Honcho ESP disabled")
    t2.value37()
end
}
t1.value1 = AddToggle
t1.value2 = t4
t1.value1(Groupbox, "HonchoESPToggle", t1.value2)

local Groupbox2 = cheesy.Groupbox
t1.value1 = Groupbox2.AddButton
t1.value1(Groupbox2, {
	Text = "Rescan",
	Func = function()
    if not t2.value8 then
        return
    end

    print("[Cheesy] Rescanning Archives...")
    t2.value30()
    print("[Cheesy] Rescan complete.")
end
})
cheesy.Groupbox:AddDivider()
local Groupbox3 = cheesy.Groupbox
local t5 = {
	Text = "Matching boxes and terminals share the same color.",
	DoesWrap = true
}
local AddLabel = Groupbox3.AddLabel
t1.value3 = t5
t1.value1 = AddLabel
t1.value1(Groupbox3, t1.value3)
cheesy.Groupbox:AddLabel({
	Text = "Box highlights stay active when players carry or drop them.",
	DoesWrap = true
})
cheesy.Groupbox:AddLabel({
	Text = "A safety rescan runs every 5 seconds to catch anything missed.",
	DoesWrap = true
})
print("[Cheesy] Honcho ESP loaded!")
