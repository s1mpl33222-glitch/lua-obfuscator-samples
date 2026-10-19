-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value1 = game:GetService("Players"),
	value2 = game:GetService("Workspace"),
	value3 = game:GetService("HttpService")
}
local UserInputService = game:GetService("UserInputService")
t1.value4 = game:GetService("Lighting")
t1.value5 = game:GetService("ReplicatedStorage")
t1.value6 = game:GetService("RunService")
t1.value7 = game:GetService("TeleportService")
t1.value8 = game:GetService("Stats")
t1.value9 = game:GetService("VirtualUser")
game:GetService("TweenService")
t1.value10 = game:GetService("MarketplaceService")
t1.value11 = game:GetService("VirtualInputManager")
t1.value12 = t1.value1.LocalPlayer
t1.value13 = t1.value12.Name
t1.value14 = t1.value12
t1.value15 = t1.value12:WaitForChild("PlayerGui")
t1.value16 = game.PlaceId
t1.value17 = t1.value12.Character or t1.value12.CharacterAdded:Wait()
t1.value17:WaitForChild("Humanoid")
local value17 = t1.value17
t1.value18 = nil
t1.value19 = nil
t1.value20 = value17:WaitForChild("HumanoidRootPart")
t1.value21 = t1.value2.CurrentCamera
t1.value2:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    t1.value21 = t1.value2.CurrentCamera
end)
t1.value22 = nil
t1.value23 = nil
t1.value24 = {}
t1.value25 = nil
t1.value26 = "https://discord.gg/DPCKQRJmdF"
t1.value27 = "https://pastebin.com/raw/iYvRJrSf"
t1.value28 = nil
t1.value29 = "https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/RT3-Changelogs.lua"
t1.value30 = "https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/BoostFPS.lua"
t1.value31 = nil
t1.value32 = "https://discord.com/api/webhooks/1458434045623926958/NZ8klkIkbBWACZFGJBKBRLq2cLiIyEPWLEOtxnGoyYRfgHI5gmaXwtIro9SjEbRjUi5Z"
t1.value31 = 1
pcall(function()
    if not isfolder("Samuraa1Hub") then
        makefolder("Samuraa1Hub")
    end
    if not isfile("Samuraa1Hub/execs.txt") then
        v5 = writefile
        v6 = t1.value31
        v5("Samuraa1Hub/execs.txt", (tostring(v6)))

        return
    end
    local writefile_ = t1
    writefile_.value31 = (tonumber(readfile("Samuraa1Hub/execs.txt")) or 0) + 1
    writefile_ = writefile
    local readfile_ = t1.value31
    writefile_("Samuraa1Hub/execs.txt", (tostring(readfile_)))
end)
shared._execs = t1.value31
function t1.value33()
    local ok, result = pcall(function()

        if type(identifyexecutor) == "function" then
            return identifyexecutor()
        else
            return
        end
    end)

    if ok then
        if type(result) == "string" then
            ok = result ~= ""
        else
            ok = false
        end
    end

    if ok then
        return result
    end

    ok, result = pcall(function()

        if type(getexecutorname) == "function" then
            return getexecutorname()
        else
            return
        end
    end)

    if not ok then
        return not ok and "Unknown" or result
    end

    if type(result) == "string" then
        ok = result ~= ""
    else
        ok = false
    end

    return not ok and "Unknown" or result
end
t1.value34 = nil
t1.value34 = nil
function t1.value35()
    if t1.value34 then
        return t1.value34
    end

    local ok, result = pcall(function()
        return t1.value10:GetProductInfo(t1.value16)
    end)

    if not ok then
        if ok then
            t1.value34 = result.Name

            return t1.value34
        else
            t1.value34 = game.Name

            return t1.value34
        end

        return
    end

    if type(result) == "table" then
        ok = result.Name

        if type(ok) == "string" then
            ok = result.Name ~= ""
        else
            ok = false
        end
    else
        ok = false
    end

    if ok then
        t1.value34 = result.Name

        return t1.value34
    else
        t1.value34 = game.Name

        return t1.value34
    end
end
function t1.value36(p1)
    local t2 = {
		["name"] = "\240\159\145\164 User",
		["value"] = t1.value13,
		["inline"] = true
	}
    local UserId = t1.value12.UserId

    t2 = {
		{
			["title"] = "Samuraa1 Hub Feedback",
			["description"] = p1,
			["color"] = 5814783,
			["fields"] = {
				t2,
				{
					["name"] = "\240\159\134\148 User ID",
					["value"] = tostring(UserId),
					["inline"] = true
				},
				{
					["name"] = "\240\159\142\174 Game",
					["value"] = t1.value35(),
					["inline"] = false
				},
				{
					["name"] = "\240\159\140\144 Executor",
					["value"] = t1.value33(),
					["inline"] = true
				}
			},
			["footer"] = {
				["text"] = "Feedback System"
			}
		}
	}
    t2 = t1.value3:JSONEncode({
		["embeds"] = t2,
		["username"] = "Feedback"
	})

    return pcall(function()
        local syn_ = syn

        if not syn_ then
            if syn_ then
                syn.request({
					["Url"] = t1.value32,
					["Method"] = "POST",
					["Headers"] = {
						["Content-Type"] = "application/json"
					},
					["Body"] = t2
				})

                return
            else
                if request then
                    request({
						["Url"] = t1.value32,
						["Method"] = "POST",
						["Headers"] = {
							["Content-Type"] = "application/json"
						},
						["Body"] = t2
					})

                    return
                else
                    if http_post then
                        http_post(t1.value32, t2, "application/json")

                        return
                    else
                        t1.value3:PostAsync(t1.value32, t2, Enum.HttpContentType.ApplicationJson)

                        return
                    end

                    return
                end

                return
            end

            return
        end

        syn_ = syn.request

        if syn_ then
            syn.request({
				["Url"] = t1.value32,
				["Method"] = "POST",
				["Headers"] = {
					["Content-Type"] = "application/json"
				},
				["Body"] = t2
			})

            return
        else
            if request then
                request({
					["Url"] = t1.value32,
					["Method"] = "POST",
					["Headers"] = {
						["Content-Type"] = "application/json"
					},
					["Body"] = t2
				})

                return
            else
                if http_post then
                    http_post(t1.value32, t2, "application/json")

                    return
                else
                    t1.value3:PostAsync(t1.value32, t2, Enum.HttpContentType.ApplicationJson)

                    return
                end

                return
            end

            return
        end
    end)
end
value17 = t1.value5:WaitForChild("Events")
t1.value37 = nil
t1.value38 = value17.Restaurant.TaskCompleted
t1.value39 = value17.Restaurant.CustomerActionReplicated
t1.value40 = value17.Cook:WaitForChild("CookInputRequested")
t1.value41 = value17.Restaurant:FindFirstChild("GrabFood")
t1.value42 = value17.Restaurant:FindFirstChild("TipsCollected")
t1.value43 = value17.Restaurant.Customers:FindFirstChild("GetRudeCustomerDialog")
t1.value44 = nil
t1.value45 = value17.Dialog:FindFirstChild("DialogCompleted")
t1.value46 = nil
t1.value47 = {
	["AutoCustomer"] = false,
	["PickupCash"] = false,
	["PickupDishes"] = false,
	["AutoTakeOrder"] = false,
	["AutoCook"] = false,
	["InstantCook"] = false,
	["AutoGiveFood"] = false,
	["AutoDriveThru"] = false,
	["AutoTips"] = false
}
_G.AutoCalmRude = _G.AutoCalmRude or false
t1.value48 = 0.016666666666667
value17 = t1.value6.Heartbeat
value17:Connect(function(p2)
    t1.value48 = t1.value48 * 0.9 + math.clamp(p2, 0.0041666666666667, 0.2) * 0.1
end)
value17 = function()
    if t1.value48 > 0.03125 then
        return 1, 0.05
    else
        if t1.value48 > 0.022222222222222 then
            return 3, 0.025
        else
            return 6, 0.012
        end

        return
    end
end
t1.value49 = 260
t1.value50 = 0
t1.value51 = 0
t1.value52 = 0.5
function t1.value53(p3, ...)
    return pcall(p3.FireServer, p3, ...)
end
function t1.value54(p4, ...)
    return pcall(p4.InvokeServer, p4, ...)
end
t1.value55 = nil
t1.value56 = 0
function t1.value57()
    local os_ = os
    local value55 = t1.value55

    os_ = os_.clock()

    local Parent = value55 and value55.Parent

    if Parent then
        Parent = os_ < t1.value56
    end

    if Parent then
        return value55
    end

    value55 = nil
    Parent = t1.value2:FindFirstChild("Tycoons")

    local v19

    if Parent then
        local GetChildren = Parent.GetChildren
        local v21, v22

        GetChildren, v21, v22 = ipairs(GetChildren(Parent))

        local isObjectValue

        while true do
            v22, v19 = GetChildren(v21, v22)

            if not v22 then
                v19 = value55

                break
            end

            local Owner = v19:FindFirstChild("Owner")

            if Owner then
                isObjectValue = Owner:IsA("ObjectValue")

                if isObjectValue then
                    isObjectValue = Owner.Value == t1.value14
                end
            else
                isObjectValue = Owner
            end

            if isObjectValue then
                break
            end
        end

        if v19 then
            os_ = os_ + (v19 and 4 or 0.5)

            return v19
        end

        value55 = Parent.GetChildren

        for _, v in ipairs(value55(Parent)) do
            for _, child in ipairs(v:GetChildren()) do
                isObjectValue = child:IsA("ObjectValue")

                if isObjectValue then
                    isObjectValue = child.Value == t1.value14
                end

                if isObjectValue then
                    v19 = v

                    break
                end
            end

            if v19 then
                os_ = os_ + (v19 and 4 or 0.5)

                return v19
            end
        end
    else
        v19 = value55
    end

    os_ = os_ + (v19 and 4 or 0.5)

    return v19
end
function t1.value58(p5)
    if p5 then
        v34 = p5.Parent
    else
        v34 = p5
    end

    if not v34 then
        return
    end

    local HoldDuration = p5.HoldDuration
    local MaxActivationDistance = p5.MaxActivationDistance

    if HoldDuration ~= 0 then
        p5.HoldDuration = 0
    end

    if MaxActivationDistance < 100 then
        p5.MaxActivationDistance = 100
    end

    p5:InputHoldBegin()
    task.wait()

    if p5.Parent then
        p5:InputHoldEnd()
    end

    local v31

    if HoldDuration == 0 then
        v31 = false
    else
        v31 = p5.Parent
    end

    if v31 then
        p5.HoldDuration = HoldDuration
    end

    if MaxActivationDistance < 100 then
        HoldDuration = p5.Parent
    else
        HoldDuration = false
    end

    if not HoldDuration then
        return
    end

    p5.MaxActivationDistance = MaxActivationDistance
end
function t1.value59(p6, p7, p8)
    local value38 = t1.value38

    if value38 then
        if os.clock() - t1.value51 >= t1.value52 then
            t1.value50 = 0
        end

        if t1.value50 + 1 <= t1.value49 then
            value38 = t1
            value38.value50 = value38.value50 + 1
            value38 = true
        else
            value38 = false
        end
    end

    if not value38 then
        return
    end

    t1.value53(t1.value38, {
		["Tycoon"] = p8,
		["Name"] = p6,
		["FurnitureModel"] = p7
	})
end
function t1.value60(p9, p10, p11)
    local value38 = t1.value38

    if value38 then
        value38 = t1.value39
    end

    if not value38 then
        return
    end

    if not (os.clock() - t1.value51 >= t1.value52) then
        if t1.value50 + 2 <= t1.value49 then
            value38 = t1
            value38.value50 = value38.value50 + 2
            value38 = true
        else
            value38 = false
        end

        if value38 then
            t1.value53(t1.value38, {
				["GroupId"] = p10,
				["Tycoon"] = p11,
				["Name"] = "TakeOrder",
				["CustomerId"] = p9
			})
            t1.value53(t1.value39, p11, "SetCustomerState", p9, p10, "WaitingForDish")

            return
        else
            return
        end

        return
    end

    t1.value50 = 0

    if t1.value50 + 2 <= t1.value49 then
        value38 = t1
        value38.value50 = value38.value50 + 2
        value38 = true
    else
        value38 = false
    end

    if value38 then
        t1.value53(t1.value38, {
			["GroupId"] = p10,
			["Tycoon"] = p11,
			["Name"] = "TakeOrder",
			["CustomerId"] = p9
		})
        t1.value53(t1.value39, p11, "SetCustomerState", p9, p10, "WaitingForDish")

        return
    else
        return
    end
end
t1.value61 = nil
t1.value61 = {
	["list"] = {},
	["byKey"] = {},
	["byCust"] = {},
	["valid"] = false,
	["buildTime"] = 0
}
t1.value62 = nil
function t1.value63()
    local ipairs_ = ipairs
    local value15 = t1.value15
    local list = {}
    local byKey = {}
    local byCust = {}

    for _, child in ipairs_(value15:GetChildren()) do
        if child.Name == "CustomerSpeechUI" then
            local Adornee = child.Adornee

            if Adornee then
                Adornee = Adornee:FindFirstAncestorOfClass("Model")

                local Parent

                if Adornee then
                    Parent = Adornee.Parent
                else
                    Parent = Adornee
                end

                if Adornee and Parent then
                    local Header = child:FindFirstChild("Header", true)
                    local isTextLabel

                    if Header then
                        isTextLabel = Header:IsA("TextLabel")
                    else
                        isTextLabel = Header
                    end

                    if isTextLabel then
                        Adornee = Adornee.Name
                        Parent = Parent.Name

                        local t3 = {
							["ui"] = child,
							["customerId"] = Adornee,
							["groupId"] = Parent,
							["header"] = Header,
							["key"] = Parent .. ":" .. Adornee
						}

                        list[#list + 1] = t3
                        byKey[t3.key] = t3

                        if not byCust[Adornee] then
                            byCust[Adornee] = t3
                        end
                    end
                end
            end
        end
    end

    t1.value61.list = list
    t1.value61.byKey = byKey
    t1.value61.byCust = byCust
    t1.value61.valid = true
    t1.value61.buildTime = os.clock()
end
t1.value15.ChildAdded:Connect(function(child)
    if child.Name ~= "CustomerSpeechUI" then
        return
    end

    t1.value61.valid = false
end)
t1.value15.ChildRemoved:Connect(function(child)
    if child.Name ~= "CustomerSpeechUI" then
        return
    end

    t1.value61.valid = false
end)
function t1.value64()
    if not (not t1.value61.valid or os.clock() - t1.value61.buildTime > 0.5) then
        return t1.value61.list
    end

    t1.value63()

    return t1.value61.list
end
function t1.value65(p12)
    local Parent

    if not p12 then
        if p12 then
            Parent = p12.Parent
        else
            Parent = p12
        end

        if Parent then
            Parent = p12.Text

            if not Parent or Parent == "" then
                return false
            else
                return string.find(string.lower(Parent), "table for", 1, true) ~= nil
            end

            return
        else
            return false
        end

        return
    end

    p12 = p12.header

    if p12 then
        Parent = p12.Parent
    else
        Parent = p12
    end

    if Parent then
        Parent = p12.Text

        if not Parent or Parent == "" then
            return false
        else
            return string.find(string.lower(Parent), "table for", 1, true) ~= nil
        end

        return
    else
        return false
    end
end
function t1.value66(p13)
    if not p13 then
        if p13 then
            return p13:FindFirstChild("Food") or p13:FindFirstChild("Foods")
        else
            return nil
        end

        return
    end

    p13 = p13:FindFirstChild("Objects")

    if p13 then
        return p13:FindFirstChild("Food") or p13:FindFirstChild("Foods")
    else
        return nil
    end
end
function t1.value67(p14, p15)
    if p14 then
        local attribute = p14:GetAttribute(p15)

        if attribute == nil then
            attribute = p14:FindFirstChild(p15)

            local isStringValue

            if attribute then
                isStringValue = attribute:IsA("StringValue") or (attribute:IsA("IntValue") or attribute:IsA("NumberValue"))
            else
                isStringValue = attribute
            end

            if isStringValue then
                return tostring(attribute.Value)
            else
                return nil
            end

            return
        else
            return tostring(attribute)
        end

        return
    else
        return nil
    end
end
t1.value68 = nil
t1.value69 = nil
t1.value70 = 0
t1.value71 = {}
t1.value72 = nil
t1.value73 = 1
t1.value74 = 1
function t1.value75(p16)
    local now = os.clock()

    if t1.value68 == p16 then
        v68 = now < t1.value70
    else
        v68 = false
    end

    if v68 then
        return t1.value71
    end

    local t4 = {}

    if p16 then
        p16 = p16:FindFirstChild("ClientCars")
    end

    if p16 then
        for _, child in ipairs(p16:GetChildren()) do
            local Name = child.Name

            if tonumber(Name) then
                t4[#t4 + 1] = child.Name
            end
        end

        table.sort(t4, function(p17, p18)
            return tonumber(p17) < tonumber(p18)
        end)
    end

    now = now + 0.2

    if not (t1.value74 > #t4) then
        return t4
    end

    t1.value74 = 1

    return t4
end
t1.value69 = {}
t1.value62 = 0
function t1.value76(p19, p20)
    local now = os.clock()

    for i = 1, #p20 do
        local v56 = p20[i]

        if not t1.value65(v56) then
            local key = v56.key
            local v58 = t1.value69[key]

            if not v58 or now - v58 >= 0.35 then
                t1.value60(v56.customerId, v56.groupId, p19)
                t1.value69[key] = now
            end
        end
    end

    if not (now - t1.value62 > 5) then
        return
    end

    t1.value62 = now

    for k, v in pairs(t1.value69) do
        if now - v > 10 then
            t1.value69[k] = nil
        end
    end
end
t1.value77 = nil
t1.value78 = 0
t1.value79 = {}
t1.value72 = {}
t1.value46 = 0
function t1.value80(p21)
    local now = os.clock()

    if t1.value77 == p21 then
        v85 = now < t1.value78
    else
        v85 = false
    end

    if v85 then
        return t1.value79
    end

    local t5 = {}
    local t6 = {}
    local Items = p21:FindFirstChild("Items")

    if Items then
        Items = Items:FindFirstChild("Surface")
    end

    if Items then
        local GetChildren = Items.GetChildren

        for _, v in ipairs(GetChildren(Items)) do
            if v.Name:match("^T%d+$") then
                t5[#t5 + 1] = v

                local GetDescendants = v.GetDescendants
                local t7 = {}

                for _, v2 in ipairs(GetDescendants(v)) do
                    if v2:IsA("Seat") then
                        t7[#t7 + 1] = v2
                    end
                end

                t6[v] = t7
            end
        end
    end

    now = now + 1

    if not (t1.value46 > #t5) then
        return t5
    end

    t1.value46 = 0

    return t5
end
function t1.value81(p22)
    if not (p22 and p22.Parent) then
        return false
    end

    if p22:FindFirstChild("Bill") or p22:FindFirstChild("Trash") then
        return false
    end

    if p22:GetAttribute("Occupied") or (p22:GetAttribute("IsOccupied") or (p22:GetAttribute("InUse") or p22:GetAttribute("Taken"))) then
        return false
    end

    local v72 = t1.value72[p22]

    if not v72 then
        return true
    end

    for i = 1, #v72 do
        if v72[i].Occupant then
            return false
        end
    end

    return true
end
t1.value18 = {}
t1.value19 = 0
function t1.value82(p23, p24)
    local v74 = t1.value80(p23)
    local v75 = #v74

    if v75 == 0 then
        return
    end

    local now = os.clock()
    local t8 = {}

    for i = 1, #p24 do
        local groupId = p24[i]

        if t1.value65(groupId) then
            groupId = groupId.groupId

            if not t8[groupId] then
                t8[groupId] = true

                local v80 = t1.value18[groupId]

                if not v80 or now - v80 >= 0.25 then
                    local v81
                    for i2 = 1, v75 do
                        local value46 = (t1.value46 + i2 - 1) % v75 + 1
                        local v84 = v74[value46]

                        if t1.value81(v84) then
                            t1.value46 = value46
                            v81 = v84

                            break
                        end
                    end
                    if v81 then
                        if os.clock() - t1.value51 >= t1.value52 then
                            t1.value50 = 0
                        end

                        if t1.value50 + 1 <= t1.value49 then
                            v80 = t1
                            v80.value50 = v80.value50 + 1
                            v80 = true
                        else
                            v80 = false
                        end
                    else
                        v80 = v81
                    end
                    if v80 then
                        t1.value53(t1.value38, {
							["FurnitureModel"] = v81,
							["Tycoon"] = p23,
							["Name"] = "SendToTable",
							["GroupId"] = groupId
						})
                        t1.value18[groupId] = now
                    end
                end
            end
        end
    end

    if not (now - t1.value19 > 6) then
        return
    end

    t1.value19 = now

    for k, v in pairs(t1.value18) do
        if now - v > 12 then
            t1.value18[k] = nil
        end
    end
end
function t1.value83(p25, p26, p27, p28)
    local v87
    local Items = p25:FindFirstChild("Items")
    local v89
    if not Items then
        if Items then
            v89 = p28 or (1 / 0)

            for _, child in ipairs(Items:GetChildren()) do
                if child:FindFirstChild(p26) then
                    t1.value59(p27, child, p25)
                    v87 = v87 + 1

                    if v89 <= v87 then
                        return
                    end
                end
            end

            return
        else
            return
        end

        return
    end
    Items = Items:FindFirstChild("Surface")
    if Items then
        v89 = p28 or (1 / 0)

        for _, child in ipairs(Items:GetChildren()) do
            if child:FindFirstChild(p26) then
                t1.value59(p27, child, p25)
                v87 = v87 + 1

                if v89 <= v87 then
                    return
                end
            end
        end

        return
    else
        return
    end
end
t1.value84 = 1
t1.value85 = 1
function t1.value86(p29, p30)
    local v94 = t1.value66(p29)

    if not (v94 and t1.value41) then
        return
    end

    local children = v94:GetChildren()
    local v96 = #children

    if v96 == 0 then
        t1.value84 = 1
        t1.value85 = 1

        return
    end

    local t9 = {}

    for i = 1, #p30 do
        v134 = p30[i]

        if not t1.value65(v134) then
            t9[#t9 + 1] = v134
        end
    end

    local v99 = #t9

    if v99 == 0 then
        t1.value85 = 1

        return
    end

    if v96 < t1.value84 then
        t1.value84 = 1
    end

    if v99 < t1.value85 then
        t1.value85 = 1
    end

    local v100 = t1.value48 > 0.03125 and 1 or (t1.value48 > 0.022222222222222 and 3 or 6)
    local v101 = math.min(v96, v100)
    local byKey = t1.value61.byKey
    local byCust = t1.value61.byCust

    for i = 1, v101 do
        local v105 = children[t1.value84]

        if not v105 or v105.Parent ~= v94 then
            return
        end

        if os.clock() - t1.value51 >= t1.value52 then
            t1.value50 = 0
        end

        if t1.value50 + 1 <= t1.value49 then
            v138 = t1
            v138.value50 = v138.value50 + 1
            v138 = true
        else
            v138 = false
        end

        if v138 then
            t1.value54(t1.value41, v105)
        end

        local v106 = t1.value67(v105, "CustomerId")
        local value85 = t1.value67(v105, "GroupId")

        if v106 then
            v106 = value85 and byKey[value85 .. ":" .. v106] or byCust[v106]
        else
            v106 = nil
        end

        if v106 then
            if os.clock() - t1.value51 >= t1.value52 then
                t1.value50 = 0
            end

            if t1.value50 + 1 <= t1.value49 then
                value85 = t1
                value85.value50 = value85.value50 + 1
                value85 = true
            else
                value85 = false
            end

            if value85 then
                t1.value53(t1.value38, {
					["Name"] = "Serve",
					["Tycoon"] = p29,
					["FoodModel"] = v105,
					["CustomerId"] = v106.customerId,
					["GroupId"] = v106.groupId
				})
            end
        else
            v106 = v100 >= 5 and 3 or v100
            v106 = math.min(v99, v106)
            value85 = t1.value85

            local n1 = 0
            local n2 = 1
            local v110 = false

            while true do
                n1 = n1 + n2

                local v111 = ((not v110 or v106 > n1) and true or false) and not v110

                if v111 then
                    v111 = n1 <= v106
                end

                if not v111 then
                    break
                end

                v111 = t9[value85]

                local v112

                if v111 then
                    if os.clock() - t1.value51 >= t1.value52 then
                        t1.value50 = 0
                    end

                    if t1.value50 + 1 <= t1.value49 then
                        v112 = t1
                        v112.value50 = v112.value50 + 1
                        v112 = true
                    else
                        v112 = false
                    end
                else
                    v112 = v111
                end

                if v112 then
                    t1.value53(t1.value38, {
						["Name"] = "Serve",
						["Tycoon"] = p29,
						["FoodModel"] = v105,
						["CustomerId"] = v111.customerId,
						["GroupId"] = v111.groupId
					})
                end

                value85 = value85 + 1
                value85 = v99 < value85 and 1 or value85
            end

            t1.value85 = value85
        end

        v105 = t1
        v105.value84 = v105.value84 + 1

        if v96 < t1.value84 then
            t1.value84 = 1
        end
    end
end
function t1.value87(p31)
    local v113 = t1.value66(p31)

    if not (v113 and t1.value41) then
        return
    end

    local children = v113:GetChildren()
    local v115 = #children

    if v115 == 0 then
        t1.value73 = 1
        t1.value74 = 1

        return
    end

    local v116 = t1.value75(p31)
    local v117 = #v116

    if v117 == 0 then
        t1.value74 = 1

        return
    end

    if v115 < t1.value73 then
        t1.value73 = 1
    end

    if v117 < t1.value74 then
        t1.value74 = 1
    end

    local v118 = t1.value48 > 0.03125 and 1 or (t1.value48 > 0.022222222222222 and 3 or 6)

    v118 = math.min(v118, 4)
    v118 = math.min(v115, v118)

    local v119 = v115
    local n3 = 0
    local n4 = 1
    local v122 = false

    while true do
        n3 = n3 + n4

        local v123 = ((not v122 or v118 > n3) and true or false) and not v122

        if v123 then
            v123 = n3 <= v118
        end

        if not v123 then
            return
        end

        v123 = children[t1.value73]

        if not v123 or v123.Parent ~= v113 then
            return
        end

        if os.clock() - t1.value51 >= t1.value52 then
            t1.value50 = 0
        end

        if t1.value50 + 1 <= t1.value49 then
            v157 = t1
            v157.value50 = v157.value50 + 1
            v157 = true
        else
            v157 = false
        end

        if v157 then
            t1.value54(t1.value41, v123)
        end

        local v124 = t1.value67(v123, "CarId")
        local v125 = v124 or v116[t1.value74]
        local v126

        if v125 then
            if os.clock() - t1.value51 >= t1.value52 then
                t1.value50 = 0
            end

            if t1.value50 + 2 <= t1.value49 then
                v126 = t1
                v126.value50 = v126.value50 + 2
                v126 = true
            else
                v126 = false
            end
        else
            v126 = v125
        end

        if v126 then
            t1.value53(t1.value38, {
				["Name"] = "Serve",
				["Tycoon"] = p31,
				["FoodModel"] = v123,
				["CarId"] = v125
			})
            t1.value53(t1.value38, {
				["Name"] = "CollectDriveThruBill",
				["Tycoon"] = p31,
				["CarId"] = v125
			})
        end

        if not v124 then
            v123 = t1
            v123.value74 = v123.value74 + 1

            if v117 < t1.value74 then
                t1.value74 = 1
            end
        end

        v123 = t1
        v123.value73 = v123.value73 + 1

        if v119 < t1.value73 then
            t1.value73 = 1
        end
    end
end
t1.value28 = 1
function t1.value88(p32, p33)
    local value43 = t1.value43

    if value43 then
        value43 = t1.value45
    end

    if not value43 then
        return
    end

    value43 = #p33

    if value43 == 0 then
        t1.value28 = 1

        return
    end

    if value43 < t1.value28 then
        t1.value28 = 1
    end

    for _ = 1, math.min(value43, 3) do
        local v129 = p33[t1.value28]
        local v130 = t1

        v130.value28 = v130.value28 + 1

        if value43 < t1.value28 then
            t1.value28 = 1
        end

        v130 = v129 and not t1.value65(v129)

        if v130 then
            if os.clock() - t1.value51 >= t1.value52 then
                t1.value50 = 0
            end

            if t1.value50 + 1 <= t1.value49 then
                v130 = t1
                v130.value50 = v130.value50 + 1
                v130 = true
            else
                v130 = false
            end
        end

        if v130 then
            local v131

            v130, v131 = t1.value54(t1.value43, p32, v129.customerId, v129.groupId)

            if v130 then
                if type(v131) == "string" then
                    v131 = string.lower(v131)
                    v130 = v131 ~= "" and not string.find(v131, "already", 1, true)

                    if v130 then
                        v130 = not string.find(v131, "not rude", 1, true)
                    end
                else
                    v130 = v131 ~= nil
                end
            else
                v130 = false
            end

            if v130 then
                if os.clock() - t1.value51 >= t1.value52 then
                    t1.value50 = 0
                end

                if t1.value50 + 1 <= t1.value49 then
                    value43 = t1
                    value43.value50 = value43.value50 + 1
                    value43 = true
                else
                    value43 = false
                end

                if value43 then
                    t1.value54(t1.value43, p32, v129.customerId, v129.groupId, "We really appreciate you bringing this to our attention.")
                end

                if not (os.clock() - t1.value51 >= t1.value52) then
                    if t1.value50 + 1 <= t1.value49 then
                        value43 = t1
                        value43.value50 = value43.value50 + 1
                        value43 = true
                    else
                        value43 = false
                    end

                    if value43 then
                        t1.value53(t1.value45)

                        return
                    else
                        return
                    end

                    return
                end

                t1.value50 = 0

                if t1.value50 + 1 <= t1.value49 then
                    value43 = t1
                    value43.value50 = value43.value50 + 1
                    value43 = true
                else
                    value43 = false
                end

                if value43 then
                    t1.value53(t1.value45)

                    return
                else
                    return
                end

                return
            end
        end
    end
end
t1.value37 = {}
t1.value89 = {}
t1.value44 = true
function t1.value90(p34)
    local isProximityPrompt = p34:IsA("ProximityPrompt")

    if isProximityPrompt then
        isProximityPrompt = not t1.value37[p34]
    end

    if not isProximityPrompt then
        return
    end

    t1.value37[p34] = true
    t1.value44 = true
end
t1.value91 = nil
function t1.value91(p35)
    if not t1.value37[p35] then
        return
    end

    t1.value37[p35] = nil
    t1.value44 = true
end
function t1.value92(p36)
    if not p36 or p36:GetAttribute("_rt3_autofarm_watched") then
        return
    else
        p36:SetAttribute("_rt3_autofarm_watched", true)

        local GetDescendants = p36.GetDescendants

        for _, v in ipairs(GetDescendants(p36)) do
            t1.value90(v)
        end

        p36.DescendantAdded:Connect(t1.value90)
        p36.DescendantRemoving:Connect(t1.value91)

        return
    end
end
t1.value92(t1.value2:FindFirstChild("Temp"))
t1.value2.ChildAdded:Connect(function(child)
    if child.Name ~= "Temp" then
        return
    end

    t1.value92(child)
end)
local function v136()
    if not t1.value44 then
        return t1.value89
    end

    local value89 = {}

    for k in pairs(t1.value37) do
        if k.Parent then
            if k.ActionText == "Cook" then
                value89[#value89 + 1] = k
            end
        else
            t1.value37[k] = nil
        end
    end

    t1.value89 = value89

    return t1.value89
end
task.spawn(function()
    while true do
        task.wait(0.6)
        t1.value61.valid = false
    end
end)
task.spawn(function()
    local n5 = 0
    local n6 = 0
    local n7 = 0
    local n8 = 0

    while true do
        task.wait()

        local now

        if t1.value47.AutoTakeOrder or (t1.value47.AutoCustomer or (t1.value47.AutoGiveFood or _G.AutoCalmRude)) then
            local v144 = t1.value57()

            if v144 then
                now = os.clock()

                local v145 = t1.value64()
                local value = select(2, value17())
                local AutoTakeOrder = t1.value47.AutoTakeOrder

                if AutoTakeOrder then
                    AutoTakeOrder = now - n5 >= 0.05
                end

                if AutoTakeOrder then
                    t1.value76(v144, v145)
                    n5 = now
                end

                AutoTakeOrder = t1.value47.AutoCustomer

                if AutoTakeOrder then
                    AutoTakeOrder = now - n6 >= 0.06
                end

                if AutoTakeOrder then
                    t1.value82(v144, v145)
                    n6 = now
                end

                AutoTakeOrder = t1.value47.AutoGiveFood

                if AutoTakeOrder then
                    AutoTakeOrder = value <= now - n7
                end

                if AutoTakeOrder then
                    t1.value86(v144, v145)
                    n7 = now
                end

                value = _G.AutoCalmRude

                if value then
                    value = now - n8 >= 0.18
                end

                if value then
                    t1.value88(v144, v145)
                else
                    now = n8
                end
            else
                now = n8
            end
        else
            now = n8
        end

        n8 = now
    end
end)
task.spawn(function()
    local n9 = 0
    local n10 = 0

    while true do
        task.wait()

        local AutoCook = t1.value47.AutoCook
        local InstantCook = t1.value47.InstantCook
        local now

        if (AutoCook or InstantCook) and t1.value57() then
            now = os.clock()

            local v153 = t1.value48 > 0.03125 and 6 or 12

            if AutoCook then
                AutoCook = now - n9 >= 0.07
            end

            if AutoCook then
                n9 = v136()
                AutoCook = #n9

                if AutoCook > 0 then
                    local v154

                    for i = 1, math.min(AutoCook, 6) do
                        v154 = n9[i]

                        local Parent

                        if v154 then
                            Parent = v154.Parent
                        else
                            Parent = v154
                        end

                        if Parent then
                            task.spawn(t1.value58, v154)
                        end
                    end

                    n9 = v153 - 4
                    n9 = n9 < 4 and 4 or n9
                    AutoCook = 0

                    local n11 = 1
                    local v158 = false

                    while true do
                        AutoCook = AutoCook + n11
                        v154 = ((not v158 or n9 > AutoCook) and true or false) and not v158

                        if v154 then
                            v154 = AutoCook <= n9
                        end

                        if not v154 then
                            break
                        end

                        if os.clock() - t1.value51 >= t1.value52 then
                            t1.value50 = 0
                        end

                        if t1.value50 + 1 <= t1.value49 then
                            v154 = t1
                            v154.value50 = v154.value50 + 1
                            v154 = true
                        else
                            v154 = false
                        end

                        if v154 then
                            t1.value53(t1.value40, "Interact", t1.value2, "Oven")
                        end
                    end
                end

                n9 = now
            end

            if InstantCook then
                InstantCook = now - n10 >= 0.04
            end

            if InstantCook then
                for i = 1, v153 do
                    if os.clock() - t1.value51 >= t1.value52 then
                        t1.value50 = 0
                    end

                    if t1.value50 + 1 <= t1.value49 then
                        v153 = t1
                        v153.value50 = v153.value50 + 1
                        v153 = true
                    else
                        v153 = false
                    end

                    if v153 then
                        t1.value53(t1.value40, "Interact", t1.value2, "Oven")
                    end
                end
            else
                now = n10
            end
        else
            now = n10
        end

        n10 = now
    end
end)
task.spawn(function()
    local n12 = 0

    while true do
        task.wait()

        local now

        if t1.value47.AutoDriveThru then
            local v162 = t1.value57()

            if v162 then
                now = os.clock()

                local value = select(2, value17())

                if value <= now - n12 then
                    t1.value87(v162)
                else
                    now = n12
                end
            else
                now = n12
            end
        else
            now = n12
        end

        n12 = now
    end
end)
task.spawn(function()
    local n13 = 0
    local n14 = 0
    local n15 = 0

    while true do
        task.wait(0.05)

        local now

        if t1.value47.PickupCash or (t1.value47.PickupDishes or t1.value47.AutoTips) then
            local v168 = t1.value57()

            if v168 then
                now = os.clock()

                local PickupCash = t1.value47.PickupCash

                if PickupCash then
                    PickupCash = now - n13 >= 0.1
                end

                if PickupCash then
                    t1.value83(v168, "Bill", "CollectBill", 12)
                    n13 = now
                end

                PickupCash = t1.value47.PickupDishes

                if PickupCash then
                    PickupCash = now - n14 >= 0.1
                end

                if PickupCash then
                    t1.value83(v168, "Trash", "CollectDishes", 12)
                    n14 = now
                end

                PickupCash = t1.value47.AutoTips and t1.value42

                if PickupCash then
                    PickupCash = now - n15 >= 0.4
                end

                if PickupCash then
                    if os.clock() - t1.value51 >= t1.value52 then
                        t1.value50 = 0
                    end

                    if t1.value50 + 1 <= t1.value49 then
                        n15 = t1
                        n15.value50 = n15.value50 + 1
                        n15 = true
                    else
                        n15 = false
                    end

                    if n15 then
                        t1.value53(t1.value42, v168)
                    end
                else
                    now = n15
                end
            else
                now = n15
            end
        else
            now = n15
        end

        n15 = now
    end
end)
_G.AutoTestRewardq = true
task.spawn(function()
    local function v170(p37)
        local SelectButton = p37:FindFirstChild("SelectButton", true)

        if not SelectButton then
            return
        end

        for _ = 1, 2 do
            if SelectButton and SelectButton.Parent then
                local function v173()
                    if firesignal then
                        firesignal(SelectButton.MouseButton1Click)
                        firesignal(SelectButton.Activated)

                        return
                    else
                        local v174 = SelectButton.AbsolutePosition + SelectButton.AbsoluteSize / 2

                        t1.value11:SendMouseButtonEvent(v174.X, v174.Y, 0, true, game, 0)
                        task.wait(0.15)
                        t1.value11:SendMouseButtonEvent(v174.X, v174.Y, 0, false, game, 0)

                        return
                    end
                end

                pcall(v173)
            end

            task.wait(0.4)
        end
    end
    local function v175()
        task.wait(1.5)

        local RewardDisplay = t1.value14.PlayerGui:FindFirstChild("RewardDisplay")

        if RewardDisplay then
            RewardDisplay = RewardDisplay.Frame.Buttons:FindFirstChild("AddToMenu")
        end

        local Visible

        if RewardDisplay then
            Visible = RewardDisplay.Visible
        else
            Visible = RewardDisplay
        end

        if not Visible then
            return
        end

        for i = 1, 3 do
            if RewardDisplay and RewardDisplay.Parent then
                local function v179()
                    if firesignal then
                        firesignal(RewardDisplay.MouseButton1Click)
                        firesignal(RewardDisplay.Activated)

                        return
                    else
                        local v180 = RewardDisplay.AbsolutePosition + RewardDisplay.AbsoluteSize / 2

                        t1.value11:SendMouseButtonEvent(v180.X, v180.Y, 0, true, game, 0)
                        task.wait(0.15)
                        t1.value11:SendMouseButtonEvent(v180.X, v180.Y, 0, false, game, 0)

                        return
                    end
                end

                pcall(v179)
            end

            task.wait(0.5)
        end
    end

    local CollectRewardButton = t1.value14.PlayerGui:WaitForChild("Objectives"):WaitForChild("Frame"):WaitForChild("Standard"):WaitForChild("CollectRewardButton")

    task.spawn(function()
        while task.wait(0.5) do
            local AutoTestRewardq = _G.AutoTestRewardq

            if AutoTestRewardq then
                AutoTestRewardq = CollectRewardButton.Visible
            end

            if AutoTestRewardq then
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Rewards"):WaitForChild("RewardRequested"):FireServer("Obejctives")
                end)
                task.wait(1)
            end
        end
    end)
    CollectRewardButton = t1.value14.PlayerGui:WaitForChild("SelectReward")
    CollectRewardButton.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
        local Visible = CollectRewardButton.Frame.Visible

        if Visible then
            Visible = _G.AutoTestRewardq
        end

        if not Visible then
            return
        end

        task.wait(2.8)

        if not CollectRewardButton.Frame.Visible then
            return
        end

        local v184, v185

        Visible, v184, v185 = ipairs(CollectRewardButton.Frame.List:GetChildren())

        local t10 = {}

        while true do
            local v187

            v185, v187 = Visible(v184, v185)

            if not v185 then
                break
            end

            local isImageLabel = v187:IsA("ImageLabel")

            if isImageLabel then
                isImageLabel = v187.Name:match("^Reward_%d+$")
            end

            if isImageLabel then
                table.insert(t10, v187)
            end
        end

        if not (#t10 > 0) then
            return
        end

        v170(t10[math.random(1, #t10)])
        task.wait(3.5)
        v175()
    end)
end)
t1.value93 = {}
t1.value94 = {}
for _, v in ipairs({
	{
		["Name"] = "TipJar",
		["Price"] = 150
	},
	{
		["Name"] = "WaiterTray",
		["Price"] = 200
	},
	{
		["Name"] = "Drinks",
		["Price"] = 250
	},
	{
		["Name"] = "Level2Kitchens",
		["Price"] = 400
	},
	{
		["Name"] = "PosterAdvertising",
		["Price"] = 600
	},
	{
		["Name"] = "KidsMenu",
		["Price"] = 600
	},
	{
		["Name"] = "ManagerDesk",
		["Price"] = 700
	},
	{
		["Name"] = "RestaurantStorage",
		["Price"] = 800
	},
	{
		["Name"] = "WaiterCart",
		["Price"] = 900
	},
	{
		["Name"] = "RestaurantControls",
		["Price"] = 950
	},
	{
		["Name"] = "LeftExpansion1",
		["Price"] = 1200
	},
	{
		["Name"] = "RightExpansion1",
		["Price"] = 1200
	},
	{
		["Name"] = "Franchise",
		["Price"] = 1200
	},
	{
		["Name"] = "Security",
		["Price"] = 1250
	},
	{
		["Name"] = "Level3Kitchens",
		["Price"] = 1500
	},
	{
		["Name"] = "NewspaperAdvertising",
		["Price"] = 1600
	},
	{
		["Name"] = "CardPayments",
		["Price"] = 1750
	},
	{
		["Name"] = "BackExpansion1",
		["Price"] = 1800
	},
	{
		["Name"] = "DriveThru",
		["Price"] = 2000
	},
	{
		["Name"] = "BillboardAdvertising",
		["Price"] = 2750
	},
	{
		["Name"] = "LeftExpansion2",
		["Price"] = 3400
	},
	{
		["Name"] = "RightExpansion2",
		["Price"] = 3400
	},
	{
		["Name"] = "BackExpansion2",
		["Price"] = 4200
	},
	{
		["Name"] = "TVAdvertising",
		["Price"] = 5500
	},
	{
		["Name"] = "LeftExpansion3",
		["Price"] = 6000
	},
	{
		["Name"] = "RightExpansion3",
		["Price"] = 6000
	},
	{
		["Name"] = "SecondFloor",
		["Price"] = 12500
	},
	{
		["Name"] = "ThirdFloor",
		["Price"] = 45000
	}
}) do
    v265 = v.Name .. " (" .. v.Price .. "$)"
    v266 = #t1.value93 + 1
    t1.value93[v266] = v265
    t1.value94[v265] = v
end
t1.value95 = t1.value5.Events.Upgrades.UnlockUpgradeRequested
t1.value96 = t1.value5.Events.Farming.RequestCropPlant
t1.value97 = t1.value5.Events.Farming.RequestHarvest
_G.AutoPlant = false
_G.AutoHarvest = false
_G.SelectedCrops = {}
_G.AutoBuySupermarket = false
_G.SupermarketIngredients = {}
_G.AutoBuyButcher = false
_G.ButcherIngredients = {}
_G.AutoBuyFishmonger = false
_G.FishmongerIngredients = {}
_G.AutoBuyBakery = false
_G.BakeryIngredients = {}
value17 = {
	"Onion",
	"Wheat",
	"Sugarcane",
	"Tomato",
	"Carrot",
	"Potato",
	"Berry Bush",
	"Lettuce",
	"Apple Tree"
}
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoUpgrade then
            local value25 = t1.value25

            if value25 then
                value25 = t1.value25.Flags

                if value25 then
                    value25 = t1.value25.Flags.UpgradeDropdown
                end
            end

            if type(value25) == "table" then
                local v192 = t1.value57()
                local Cash = t1.value14:FindFirstChild("Cash")

                if v192 and Cash then
                    for _, v in ipairs(value25) do
                        local v196 = t1.value94[v]
                        local v197

                        if v196 then
                            v197 = Cash.Value >= v196.Price
                        else
                            v197 = v196
                        end

                        if v197 then
                            pcall(function()
                                t1.value95:FireServer(v192, v196.Name)
                            end)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while true do
        if _G.AutoPlant then
            local SelectedCrops = _G.SelectedCrops

            if not SelectedCrops or #SelectedCrops == 0 then
                task.wait(0.3)
            else
				-- NumForInit
                local n16, n17, n18 = 1, 8, 1

-- end NumForInit
                while true do
                    n16 = n16 + n18

                    if (0 >= n18 or n16 > n17) and (n18 > 0 or n17 > n16) then
                        break
                    end

                    if not _G.AutoPlant then
                        break
                    end

                    local v205 = SelectedCrops[math.random(1, #SelectedCrops)]

                    if v205 then
                        t1.value96:InvokeServer(v205, "Tile" .. n16)
                    end

                    task.wait(0.3)

                    continue
                end
            end
        end

        task.wait(0.5)

        continue
    end
end)
task.spawn(function()
    while true do
        if _G.AutoHarvest then
			-- NumForInit
            local n19, n20, n21 = 1, 8, 1

-- end NumForInit
            while true do
                n19 = n19 + n21

                if (0 >= n21 or n19 > n20) and (n21 > 0 or n20 > n19) then
                    break
                end

                if not _G.AutoHarvest then
                    break
                end

                t1.value97:InvokeServer("Tile" .. n19)
                task.wait(0.3)

                continue
            end
        end

        task.wait(0.5)

        continue
    end
end)
task.spawn(function()
    while true do
        repeat
            task.wait(0.5)
            v247 = _G.CollectDropMoney and t1.value2:FindFirstChild("DropFolder")
        until v247
        local Character = t1.value12.Character
        if Character then
            Character = t1.value12.Character:FindFirstChild("HumanoidRootPart")
        end
        if not Character then
            continue
        end
        local children = v247:GetChildren()
        local CFrame_ = Character.CFrame
		-- NumForInit
        local n22, v219, n23 = 1, #children, 1

-- end NumForInit
        while true do
            n22 = n22 + n23

            if (0 >= n23 or n22 > v219) and (n23 > 0 or v219 > n22) then
                break
            end

            if not _G.CollectDropMoney then
                break
            end

            local v221 = children[n22]
            local isBasePart

            if v221 then
                isBasePart = v221:IsA("BasePart")
            else
                isBasePart = v221
            end

            if isBasePart then
                Character.CFrame = v221.CFrame
                task.wait(0.2)
            end

            continue
        end
        Character.CFrame = CFrame_
        task.wait(4)

        continue
    end
end)
task.spawn(function()
    while true do
        repeat
            task.wait(0.1)
            t1.value57()
        until v223

        local SupermarketIngredients = _G.AutoBuySupermarket and _G.SupermarketIngredients

        if SupermarketIngredients then
            SupermarketIngredients = #_G.SupermarketIngredients > 0
        end

        if SupermarketIngredients then
            for _, supermarketIngredient in ipairs(_G.SupermarketIngredients) do
                game:GetService("ReplicatedStorage").Events.Food.PurchaseIngredientRequested:FireServer(v254, supermarketIngredient, "Supermarket")
                task.wait(0.1)
            end
        end

        SupermarketIngredients = _G.AutoBuyButcher

        if SupermarketIngredients then
            SupermarketIngredients = _G.ButcherIngredients

            if SupermarketIngredients then
                SupermarketIngredients = #_G.ButcherIngredients > 0
            end
        end

        if SupermarketIngredients then
            for _, butcherIngredient in ipairs(_G.ButcherIngredients) do
                game:GetService("ReplicatedStorage").Events.Food.PurchaseIngredientRequested:FireServer(v254, butcherIngredient, "Butcher")
                task.wait(0.1)
            end
        end

        SupermarketIngredients = _G.AutoBuyFishmonger

        if SupermarketIngredients then
            SupermarketIngredients = _G.FishmongerIngredients

            if SupermarketIngredients then
                SupermarketIngredients = #_G.FishmongerIngredients > 0
            end
        end

        if SupermarketIngredients then
            for _, fishmongerIngredient in ipairs(_G.FishmongerIngredients) do
                game:GetService("ReplicatedStorage").Events.Food.PurchaseIngredientRequested:FireServer(v254, fishmongerIngredient, "Fishmonger")
                task.wait(0.1)
            end
        end

        SupermarketIngredients = _G.AutoBuyBakery

        if SupermarketIngredients then
            SupermarketIngredients = _G.BakeryIngredients

            if SupermarketIngredients then
                SupermarketIngredients = #_G.BakeryIngredients > 0
            end
        end

        if SupermarketIngredients then
            for _, bakeryIngredient in ipairs(_G.BakeryIngredients) do
                game:GetService("ReplicatedStorage").Events.Food.PurchaseIngredientRequested:FireServer(v254, bakeryIngredient, "Bakery")
                task.wait(0.1)
            end
        end
    end
end)
_G.AutoCalmRude = false
v136 = {
	"Default",
	"Original",
	"Disco",
	"Synthwave",
	"Lounge",
	"Jazz",
	"Classical",
	"Lofi",
	"Electro",
	"Tobu"
}
local t11 = {
	"Disco",
	"Synthwave",
	"Lounge",
	"Jazz",
	"Classical",
	"Lofi",
	"Electro",
	"Tobu"
}
t1.value25 = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"))()
local value25 = t1.value25
local TouchEnabled = UserInputService.TouchEnabled
value25 = value25:Window({
	["Name"] = "Samuraa1 Hub",
	["SubName"] = "Restaurant Tycoon 3 | v2.0.0",
	["Logo"] = "97594400820219",
	["MobileScale"] = TouchEnabled and 0.72 or TouchEnabled or nil
})
if UserInputService.TouchEnabled then
    TouchEnabled = nil
else
    TouchEnabled = t1.value25:KeybindList("Keybinds") or nil
end
t1.value98 = {}
value25:Category("Overview")
value25:TabDivider()
local v236 = value25:DashboardPage({
	["Name"] = "Dashboard",
	["Icon"] = "layout-dashboard",
	["WelcomeText"] = "WELCOME TO",
	["HubName"] = "SAMURAA1 HUB",
	["StatusText"] = "free forever \226\128\148 for everyone",
	["Badge"] = "PLAYER",
	["Links"] = {
		{
			["Icon"] = "copy",
			["Tooltip"] = "Copy Discord link",
			["Callback"] = function()
    local function v237()
        setclipboard(t1.value26)
    end

    pcall(v237)
    t1.value25:Notification({
					["Title"] = "Copied",
					["Description"] = "Discord link copied.",
					["Duration"] = 2,
					["Icon"] = "97594400820219"
				})
end
		},
		{
			["Icon"] = "users",
			["Tooltip"] = "Join Discord server",
			["Callback"] = function()
    pcall(function()
        loadstring(game:HttpGet(t1.value27))()
    end)
end
		},
		{
			["Icon"] = "file-text",
			["Tooltip"] = "View changelogs",
			["Callback"] = function()
    local function v238()
        loadstring(game:HttpGet(t1.value29))()
    end

    pcall(v238)
end
		},
		{
			["Icon"] = "zap",
			["Tooltip"] = "Boost FPS",
			["Callback"] = function()
    local function v239()
        loadstring(game:HttpGet(t1.value30))()
    end

    pcall(v239)
end
		}
	},
	["GameName"] = "RESTAURANT TYCOON 3",
	["GameDescription"] = "Welcome to one of the best Restaurant Tycoon 3 scripts!\nEnjoy tons of features waiting for you.\n\nCredits: Samuraa1 (Script Creator), BBD5 (Developer), samet (UI Library Creator).",
	["Stats"] = {
		{
			["Name"] = "UPTIME",
			["Icon"] = "clock",
			["GetValue"] = function()
    local ok, result = pcall(function()
        return math.floor(t1.value2.DistributedGameTime)
    end)

    if ok and result then
        ok = result / 3600
        ok = math.floor(ok)

        local v242 = result % 3600 / 60

        v242 = math.floor(v242)
        result = result % 60

        return ok > 0 and ("%dh %dm"):format(ok, v242) or ("%dm %ds"):format(v242, result)
    else
        return "\226\128\148"
    end
end
		},
		{
			["Name"] = "PING",
			["Icon"] = "wifi",
			["GetValue"] = function()
    local function v243()
        local value = t1.value8.Network.ServerStatsItem["Data Ping"]:GetValue()

        return math.floor(value)
    end

    local result

    v243, result = pcall(v243)

    return v243 and result .. " ms" or "\226\128\148"
end
		},
		{
			["Name"] = "EXECS",
			["Icon"] = "terminal",
			["GetValue"] = function()
    return tostring(shared._execs or 1)
end
		}
	},
	["Credits"] = {
		{
			["Name"] = "Samuraa1",
			["Role"] = "Script Creator"
		},
		{
			["Name"] = "BBD5",
			["Role"] = "Developer"
		},
		{
			["Name"] = "samet",
			["Role"] = "UI Library Creator"
		}
	},
	["QuickAccess"] = {}
})
value25:Category("Game")
value25:TabDivider()
local v246 = value25:Page({
	["Name"] = "Main",
	["Icon"] = "utensils-crossed"
})
local v248 = value25:Page({
	["Name"] = "Events",
	["Icon"] = "calendar-check"
})
local v249 = value25:Page({
	["Name"] = "Farm",
	["Icon"] = "carrot"
})
local v250 = value25:Page({
	["Name"] = "Shops",
	["Icon"] = "shopping-bag"
})
local v251 = value25:Page({
	["Name"] = "Misc",
	["Icon"] = "layers"
})
local v252 = value25:Page({
	["Name"] = "Local Player",
	["Icon"] = "user-round"
})
local v253 = value25:Page({
	["Name"] = "Visuals",
	["Icon"] = "eye"
})
local v255 = value25:Page({
	["Name"] = "Server",
	["Icon"] = "globe"
})
value25:TabDivider()
value25:Category("Settings")
v236:AddCard({
	["Name"] = "MAIN",
	["Description"] = "Auto farm, teleports, upgrades",
	["Icon"] = "utensils-crossed",
	["Tab"] = v246
})
v236:AddCard({
	["Name"] = "EVENTS",
	["Description"] = "Scavenger hunt",
	["Icon"] = "calendar-check",
	["Tab"] = v248
})
v236:AddCard({
	["Name"] = "FARM",
	["Description"] = "Crops & farm teleport",
	["Icon"] = "carrot",
	["Tab"] = v249
})
v236:AddCard({
	["Name"] = "SHOPS",
	["Description"] = "Buy ingredients from shops",
	["Icon"] = "shopping-bag",
	["Tab"] = v250
})
v236:AddCard({
	["Name"] = "LOCAL",
	["Description"] = "Movement, fly, noclip",
	["Icon"] = "user-round",
	["Tab"] = v252
})
v236:AddCard({
	["Name"] = "SERVER",
	["Description"] = "Hop, rejoin, JobId",
	["Icon"] = "globe",
	["Tab"] = v255
})
v236 = v246:Section({
	["Name"] = "Auto Farm",
	["Icon"] = "chef-hat",
	["Side"] = 1
})
v236:Button({
	["Name"] = "Select Everything",
	["Icon"] = "check-square",
	["Tooltip"] = "Enable all auto farm toggles",
	["Callback"] = function()
    for _, v in ipairs({
			"AutoCook",
			"InstantCook",
			"AutoCustomer",
			"AutoTakeOrder",
			"AutoGiveFood",
			"PickupDishes",
			"CollectBills",
			"AutoTips",
			"CollectDropMoney",
			"AutoDriveThru",
			"AutoCalmRude"
		}) do
        if t1.value98[v] then
            t1.value98[v]:Set(true)
        end
    end
end
})
v236:Button({
	["Name"] = "Select Nothing",
	["Icon"] = "square",
	["Tooltip"] = "Disable all auto farm toggles",
	["Callback"] = function()
    for _, v in ipairs({
			"AutoCook",
			"InstantCook",
			"AutoCustomer",
			"AutoTakeOrder",
			"AutoGiveFood",
			"PickupDishes",
			"CollectBills",
			"AutoTips",
			"CollectDropMoney",
			"AutoDriveThru",
			"AutoCalmRude"
		}) do
        if t1.value98[v] then
            t1.value98[v]:Set(false)
        end
    end
end
})
t1.value98.AutoCook = v236:Toggle({
	["Name"] = "Auto Cook Food",
	["Flag"] = "AutoCook",
	["Default"] = false,
	["Tooltip"] = "Automatically cook when prompts are available",
	["Callback"] = function(p38)
    t1.value47.AutoCook = p38
end
})
t1.value98.InstantCook = v236:Toggle({
	["Name"] = "Only Instant Cook",
	["Flag"] = "InstantCook",
	["Default"] = false,
	["Tooltip"] = "Force instant cooking without other automation",
	["Callback"] = function(p39)
    t1.value47.InstantCook = p39
end
})
t1.value98.AutoCustomer = v236:Toggle({
	["Name"] = "Auto Seat Customers",
	["Flag"] = "AutoCustomer",
	["Default"] = false,
	["Tooltip"] = "Automatically seat customers at available tables",
	["Callback"] = function(p40)
    t1.value47.AutoCustomer = p40
end
})
t1.value98.AutoTakeOrder = v236:Toggle({
	["Name"] = "Auto Take Orders",
	["Flag"] = "AutoTakeOrder",
	["Default"] = false,
	["Tooltip"] = "Automatically take orders from waiting customers",
	["Callback"] = function(p41)
    t1.value47.AutoTakeOrder = p41
end
})
t1.value98.AutoGiveFood = v236:Toggle({
	["Name"] = "Auto Give Food",
	["Flag"] = "AutoGiveFood",
	["Default"] = false,
	["Tooltip"] = "Automatically serve cooked food to customers",
	["Callback"] = function(p42)
    t1.value47.AutoGiveFood = p42
end
})
t1.value98.PickupDishes = v236:Toggle({
	["Name"] = "Auto Pickup Dirty Dishes",
	["Flag"] = "PickupDishes",
	["Default"] = false,
	["Tooltip"] = "Automatically collect dirty dishes from tables",
	["Callback"] = function(p43)
    t1.value47.PickupDishes = p43
end
})
t1.value98.CollectBills = v236:Toggle({
	["Name"] = "Auto Collect Bills",
	["Flag"] = "CollectBills",
	["Default"] = false,
	["Tooltip"] = "Automatically collect bills from tables",
	["Callback"] = function(p44)
    t1.value47.PickupCash = p44
end
})
v236:Divider()
t1.value98.AutoTips = v236:Toggle({
	["Name"] = "Auto Collect Tips",
	["Flag"] = "AutoTips",
	["Default"] = false,
	["Tooltip"] = "Automatically collect tip rewards",
	["Callback"] = function(p45)
    t1.value47.AutoTips = p45
end
})
v236:Divider()
t1.value98.CollectDropMoney = v236:Toggle({
	["Name"] = "Auto Collect Drop Money / Food Critic",
	["Flag"] = "CollectDropMoney",
	["Default"] = false,
	["Tooltip"] = "Collect dropped money and food critic rewards automatically",
	["Callback"] = function(p46)
    _G.CollectDropMoney = p46
end
})
v236:Divider()
t1.value98.AutoDriveThru = v236:Toggle({
	["Name"] = "Auto Serve Drive Thru",
	["Flag"] = "AutoDriveThru",
	["Default"] = false,
	["Tooltip"] = "Automatically serve drive-thru cars",
	["Callback"] = function(p47)
    t1.value47.AutoDriveThru = p47
end
})
v236:Divider()
t1.value98.AutoCalmRude = v236:Toggle({
	["Name"] = "Auto Calm Rude Customer",
	["Flag"] = "AutoCalmRude",
	["Default"] = false,
	["Tooltip"] = "Automatically calm rude customers",
	["Callback"] = function(p48)
    _G.AutoCalmRude = p48
end
})
v236:Divider("Note")
v236:Label("Note: Sometimes Auto Give Food may work slowly due to game mechanics")
v236 = v246:Section({
	["Name"] = "Teleports",
	["Icon"] = "navigation-2",
	["Side"] = 1
})
v236:Button({
	["Name"] = "Teleport to Your Tycoon",
	["Tooltip"] = "Teleport directly to your own tycoon",
	["Callback"] = function()
    t1.value5.Events.Teleports.TeleportRequestedClient:Fire("Tycoon")
end
})
v236:Button({
	["Name"] = "Teleport to Plaza",
	["Tooltip"] = "Teleport to the plaza area",
	["Callback"] = function()
    t1.value5.Events.Teleports.TeleportRequestedClient:Fire("Plaza")
end
})
v236:Button({
	["Name"] = "Teleport to EKEA",
	["Tooltip"] = "Teleport to the EKEA location",
	["Callback"] = function()
    t1.value5.Events.Teleports.TeleportRequestedClient:Fire("EKEA")
end
})
v236:Button({
	["Name"] = "Teleport to Campsite",
	["Tooltip"] = "Teleport to the campsite",
	["Callback"] = function()
    t1.value5.Events.Teleports.TeleportRequestedClient:Fire("Campsite")
end
})
v236 = v246:Section({
	["Name"] = "Restaurant",
	["Icon"] = "store",
	["Side"] = 2
})
v236:Button({
	["Name"] = "Close Restaurant",
	["Tooltip"] = "Close your restaurant to stop customers from entering",
	["Callback"] = function()
    t1.value5.Events.Restaurant.RestaurantStatusUpdated:FireServer(t1.value57(), "Closed")
end
})
v236:Button({
	["Name"] = "Open Restaurant",
	["Tooltip"] = "Open your restaurant to allow customers",
	["Callback"] = function()
    t1.value5.Events.Restaurant.RestaurantStatusUpdated:FireServer(t1.value57(), "Open")
end
})
v236:Button({
	["Name"] = "Kick All Customers",
	["Tooltip"] = "Force all current customers to leave",
	["Callback"] = function()
    t1.value5.Events.Restaurant.RestaurantStatusUpdated:FireServer(t1.value57(), "Empty")
end
})
v236:Divider("Change Name")
v236:Textbox({
	["Flag"] = "RestaurantName",
	["Default"] = "",
	["Numeric"] = false,
	["Placeholder"] = "New restaurant name\226\128\166",
	["Finished"] = false,
	["Tooltip"] = "Enter a new name for your restaurant"
})
v236:Button({
	["Name"] = "Change Restaurant Name",
	["Icon"] = "type",
	["Tooltip"] = "Apply the new restaurant name",
	["Callback"] = function()
    local RestaurantName = t1.value25.Flags.RestaurantName
    local v259 = t1.value57()

    if v259 then
        if not RestaurantName or RestaurantName == "" then
            t1.value25:Notification({
					["Title"] = "Error",
					["Description"] = "Enter a name.",
					["Duration"] = 5,
					["Icon"] = "97594400820219"
				})

            return
        end

        return
    else
        t1.value25:Notification({
				["Title"] = "Error",
				["Description"] = "Restaurant not found!",
				["Duration"] = 5,
				["Icon"] = "97594400820219"
			})

        return
    end
end
})
v236 = v246:Section({
	["Name"] = "Rewards",
	["Icon"] = "trophy",
	["Side"] = 2
})
v236:Toggle({
	["Name"] = "Auto Claim Daily Reward",
	["Flag"] = "ClaimDailyReward",
	["Default"] = false,
	["Tooltip"] = "Automatically claim the daily reward when available",
	["Callback"] = function(p49)
    _G.AutoDailyReward = p49

    if not p49 then
        return
    end

    task.spawn(function()
        while _G.AutoDailyReward do
            task.wait(5)
            t1.value5.Events.DailyRewards.DailyRewardClaimed:FireServer()
        end
    end)
end
})
v236:Toggle({
	["Name"] = "Auto Collect Objectives",
	["Flag"] = "AutoCollectObjectives",
	["Default"] = false,
	["Tooltip"] = "Automatically redeem objective rewards",
	["Callback"] = function(p50)
    _G.AutoTestRewardq = p50
end
})
v236 = v246:Section({
	["Name"] = "Codes",
	["Icon"] = "ticket",
	["Side"] = 2
})
v236:Button({
	["Name"] = "Redeem All Valid Codes",
	["Tooltip"] = "Redeem known valid codes",
	["Callback"] = function()
    t1.value5.Events.Shop.CodeSubmitted:FireServer("dineanddash")
    t1.value5.Events.Shop.CodeSubmitted:FireServer("UltrawEats")
end
})
v236 = v246:Section({
	["Name"] = "Restaurant Upgrades",
	["Icon"] = "trending-up",
	["Side"] = 2
})
v236:Label("Auto upgrade when you have enough cash (prices in labels)")
v236:Divider("Auto Upgrade")
v246 = {
	["Name"] = "Select Upgrades",
	["Flag"] = "UpgradeDropdown",
	["Items"] = t1.value93,
	["Multi"] = true,
	["Search"] = true,
	["Tooltip"] = "Select upgrades to buy automatically",
	["Callback"] = function()
end
}
t1.value99 = v236:Dropdown(v246)
v236:Toggle({
	["Name"] = "Auto Upgrade",
	["Flag"] = "AutoUpgrade",
	["Default"] = false,
	["Tooltip"] = "Automatically purchase selected upgrades",
	["Callback"] = function(p51)
    getgenv().AutoUpgrade = p51
end
})
v236:Button({
	["Name"] = "Select All Upgrades",
	["Tooltip"] = "Select every available upgrade",
	["Callback"] = function()
    local value99 = t1.value99

    if value99 then
        value99 = t1.value99.Set
    end

    if not value99 then
        return
    end

    t1.value99:Set(t1.value93, true)
end
})
v236:Button({
	["Name"] = "Clear Selection",
	["Tooltip"] = "Clear all selected upgrades",
	["Callback"] = function()
    local value99 = t1.value99

    if value99 then
        value99 = t1.value99.Set
    end

    if not value99 then
        return
    end

    t1.value99:Set({}, true)
end
})
v236 = v248:Section({
	["Name"] = "Scavenger Hunt",
	["Icon"] = "ghost",
	["Side"] = 1
})
v236:Button({
	["Name"] = "Find All Hidden Ghosts",
	["Icon"] = "search",
	["Tooltip"] = "Teleport to every hidden ghost location",
	["Callback"] = function()
    if not (t1.value14 and t1.value20) then
        return
    end

    local Map = t1.value2:FindFirstChild("Map")
    local CFrame_, v264, v267, isModel, t12, PrimaryPart, isModel2

    if not Map then
        if Map then
            CFrame_ = t1.value20.CFrame
            v264, v267, isModel = ipairs(Map:GetDescendants())
            t12 = {}

            while true do
                isModel, PrimaryPart = v264(v267, isModel)

                if not isModel then
                    break
                end

                isModel2 = PrimaryPart:IsA("Model")

                if isModel2 then
                    isModel2 = PrimaryPart.PrimaryPart
                end

                if isModel2 then
                    PrimaryPart = PrimaryPart.PrimaryPart
                    table.insert(t12, PrimaryPart)
                end
            end

            for _, v in ipairs(t12) do
                t1.value20.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                task.wait(1)
            end

            t1.value20.CFrame = CFrame_
            CFrame_ = Map.GetDescendants
            v264 = 0

            for _, v in ipairs(CFrame_(Map)) do
                isModel = v:IsA("Model")

                if isModel then
                    isModel = v.PrimaryPart
                end

                if isModel then
                    v264 = v264 + 1
                end
            end

            if v264 ~= 0 then
                return
            end

            t1.value25:Notification({
					["Title"] = "Ghosts",
					["Description"] = "All hidden ghosts found.",
					["Duration"] = 5,
					["Icon"] = "97594400820219"
				})

            return
        else
            return
        end

        return
    end

    Map = t1.value2.Map:FindFirstChild("ScavengerHunt")

    if Map then
        CFrame_ = t1.value20.CFrame
        v264, v267, isModel = ipairs(Map:GetDescendants())
        t12 = {}

        while true do
            isModel, PrimaryPart = v264(v267, isModel)

            if not isModel then
                break
            end

            isModel2 = PrimaryPart:IsA("Model")

            if isModel2 then
                isModel2 = PrimaryPart.PrimaryPart
            end

            if isModel2 then
                PrimaryPart = PrimaryPart.PrimaryPart
                table.insert(t12, PrimaryPart)
            end
        end

        for _, v in ipairs(t12) do
            t1.value20.CFrame = v.CFrame + Vector3.new(0, 5, 0)
            task.wait(1)
        end

        t1.value20.CFrame = CFrame_
        CFrame_ = Map.GetDescendants
        v264 = 0

        for _, v in ipairs(CFrame_(Map)) do
            isModel = v:IsA("Model")

            if isModel then
                isModel = v.PrimaryPart
            end

            if isModel then
                v264 = v264 + 1
            end
        end

        if v264 ~= 0 then
            return
        end

        t1.value25:Notification({
				["Title"] = "Ghosts",
				["Description"] = "All hidden ghosts found.",
				["Duration"] = 5,
				["Icon"] = "97594400820219"
			})

        return
    else
        return
    end
end
})
v236 = v249:Section({
	["Name"] = "Crops",
	["Icon"] = "leaf",
	["Side"] = 1
})
v236:Dropdown({
	["Name"] = "Crops to plant",
	["Flag"] = "CropSelection",
	["Items"] = value17,
	["Multi"] = true,
	["Search"] = true,
	["Tooltip"] = "Choose which crops to automatically plant",
	["Callback"] = function(p52)
    _G.SelectedCrops = type(p52) == "table" and p52 and p52 or {}
end
})
v236:Toggle({
	["Name"] = "Auto Plant Crops",
	["Flag"] = "AutoPlant",
	["Default"] = false,
	["Tooltip"] = "Automatically plant selected crops",
	["Callback"] = function(p53)
    _G.AutoPlant = p53
end
})
v236:Toggle({
	["Name"] = "Auto Harvest Crops (needs Fridge)",
	["Flag"] = "AutoHarvest",
	["Default"] = false,
	["Tooltip"] = "Automatically harvest crops when ready",
	["Callback"] = function(p54)
    _G.AutoHarvest = p54
end
})
v236:Button({
	["Name"] = "Destroy All Crops",
	["Tooltip"] = "Remove all planted crops",
	["Callback"] = function()
    for i = 1, 8 do
        t1.value5.Events.Farming.CropRemoved:FireServer("Tile" .. i)
    end
end
})
value17 = v249:Section({
	["Name"] = "Ingredients",
	["Icon"] = "shopping-cart",
	["Side"] = 1,
	["LayoutOrder"] = 2
})
value17:Toggle({
	["Name"] = "Auto Buy Ingredients",
	["Flag"] = "AutoBuyIngredients",
	["Default"] = false,
	["Tooltip"] = "Automatically buy selected ingredients",
	["Callback"] = function(p55)
    _G.AutoBuyIngredients = p55

    if not p55 then
        return
    end

    task.spawn(function()
        while _G.AutoBuyIngredients do
            task.wait(0.1)

            local v279 = t1.value57()
            local IngredientsToBuy

            if v279 then
                IngredientsToBuy = _G.IngredientsToBuy
            else
                IngredientsToBuy = v279
            end

            if IngredientsToBuy then
                for _, v in ipairs(_G.IngredientsToBuy) do
                    t1.value5.Events.Food.PurchaseIngredientRequested:FireServer(v279, v, "FarmShop")
                    task.wait(0.1)
                end
            end
        end
    end)
end
})
value17:Dropdown({
	["Name"] = "Ingredients to Buy",
	["Flag"] = "IngredientsToBuy",
	["Multi"] = true,
	["Search"] = true,
	["Items"] = {
		"Sugar",
		"Onion",
		"Mushroom",
		"Tomato",
		"Pepper",
		"Cheese",
		"Milk",
		"Lettuce"
	},
	["Tooltip"] = "Select ingredients to automatically purchase",
	["Callback"] = function(p56)
    _G.IngredientsToBuy = type(p56) == "table" and p56 and p56 or {}
end
})
value17 = v249:Section({
	["Name"] = "Teleport",
	["Icon"] = "compass",
	["Side"] = 2
})
value17:Button({
	["Name"] = "Teleport to Farm",
	["Tooltip"] = "Teleport to your farm area",
	["Callback"] = function()
    t1.value5.Events.Teleports.TeleportRequestedClient:Fire("Farm")
end
})
value17 = function(p57)
    local value172 = t1.value17

    if value172 then
        value172 = t1.value17:FindFirstChild("Humanoid")
    end

    if not value172 then
        return
    end

    if t1.value17.PrimaryPart then
        t1.value17:SetPrimaryPartCFrame(CFrame.new(p57))

        return
    end

    value172 = t1.value17:FindFirstChild("HumanoidRootPart")

    if not value172 then
        return
    end

    t1.value17.PrimaryPart = value172
    t1.value17:SetPrimaryPartCFrame(unpack_({ CFrame.new(p57) }))
end
v236 = v250:Section({
	["Name"] = "Supermarket",
	["Icon"] = "store",
	["Side"] = 1
})
v236:Dropdown({
	["Name"] = "Ingredients to Buy",
	["Flag"] = "SupermarketIngredients",
	["Multi"] = true,
	["Search"] = true,
	["Items"] = {
		"Pasta",
		"Ice",
		"Egg",
		"Bread",
		"Cheese",
		"Milk",
		"Chocolate"
	},
	["Tooltip"] = "Select ingredients to automatically buy from supermarket",
	["Callback"] = function(p58)
    _G.SupermarketIngredients = type(p58) == "table" and p58 and p58 or {}
end
})
v236:Toggle({
	["Name"] = "Auto Buy Ingredients",
	["Flag"] = "AutoBuySupermarket",
	["Default"] = false,
	["Tooltip"] = "Automatically buy selected ingredients from supermarket",
	["Callback"] = function(p59)
    _G.AutoBuySupermarket = p59
end
})
v236:Divider("Teleport")
v236:Button({
	["Name"] = "Teleport to Supermarket",
	["Tooltip"] = "Teleport to the supermarket",
	["Callback"] = function()
    value17(Vector3.new(1332.6, -30.1, 1675.1))
end
})
v236 = v250:Section({
	["Name"] = "Butcher Shop",
	["Icon"] = "beef",
	["Side"] = 2
})
v236:Dropdown({
	["Name"] = "Ingredients to Buy",
	["Flag"] = "ButcherIngredients",
	["Multi"] = true,
	["Search"] = true,
	["Items"] = {
		"Beef",
		"Chicken",
		"Pork",
		"Lamb"
	},
	["Tooltip"] = "Select ingredients to automatically buy from butcher",
	["Callback"] = function(p60)
    _G.ButcherIngredients = type(p60) == "table" and p60 and p60 or {}
end
})
v236:Toggle({
	["Name"] = "Auto Buy Ingredients",
	["Flag"] = "AutoBuyButcher",
	["Default"] = false,
	["Tooltip"] = "Automatically buy selected ingredients from butcher",
	["Callback"] = function(p61)
    _G.AutoBuyButcher = p61
end
})
v236:Divider("Teleport")
v236:Button({
	["Name"] = "Teleport to Butcher Shop",
	["Tooltip"] = "Teleport to the butcher shop",
	["Callback"] = function()
    value17(Vector3.new(1160.2, -30.1, 1652.7))
end
})
v236 = v250:Section({
	["Name"] = "Fishmonger",
	["Icon"] = "fish",
	["Side"] = 1
})
v236:Dropdown({
	["Name"] = "Ingredients to Buy",
	["Flag"] = "FishmongerIngredients",
	["Multi"] = true,
	["Search"] = true,
	["Items"] = { "Fish" },
	["Tooltip"] = "Select ingredients to automatically buy from fishmonger",
	["Callback"] = function(p62)
    _G.FishmongerIngredients = type(p62) == "table" and p62 and p62 or {}
end
})
v236:Toggle({
	["Name"] = "Auto Buy Ingredients",
	["Flag"] = "AutoBuyFishmonger",
	["Default"] = false,
	["Tooltip"] = "Automatically buy selected ingredients from fishmonger",
	["Callback"] = function(p63)
    _G.AutoBuyFishmonger = p63
end
})
v236:Divider("Teleport")
v236:Button({
	["Name"] = "Teleport to Fishmonger",
	["Tooltip"] = "Teleport to the fishmonger",
	["Callback"] = function()
    value17(Vector3.new(1179.6, -46.8, -1433.3))
end
})
v236 = v250:Section({
	["Name"] = "Bakery",
	["Icon"] = "croissant",
	["Side"] = 2
})
v236:Dropdown({
	["Name"] = "Ingredients to Buy",
	["Flag"] = "BakeryIngredients",
	["Multi"] = true,
	["Search"] = true,
	["Items"] = {
		"Flour",
		"Egg",
		"Sugar",
		"Bread"
	},
	["Tooltip"] = "Select ingredients to automatically buy from bakery",
	["Callback"] = function(p64)
    _G.BakeryIngredients = type(p64) == "table" and p64 and p64 or {}
end
})
v236:Toggle({
	["Name"] = "Auto Buy Ingredients",
	["Flag"] = "AutoBuyBakery",
	["Default"] = false,
	["Tooltip"] = "Automatically buy selected ingredients from bakery",
	["Callback"] = function(p65)
    _G.AutoBuyBakery = p65
end
})
v236:Divider("Teleport")
v236:Button({
	["Name"] = "Teleport to Bakery",
	["Tooltip"] = "Teleport to the bakery",
	["Callback"] = function()
    value17(Vector3.new(1128.3, -28.7, 1526.6))
end
})
value17 = v251:Section({
	["Name"] = "Performance",
	["Icon"] = "gauge",
	["Side"] = 1
})
value17:Slider({
	["Name"] = "Set FPS cap",
	["Flag"] = "FPSSlider",
	["Min"] = 1,
	["Max"] = 999,
	["Default"] = 120,
	["Suffix"] = "",
	["Tooltip"] = "Cap frame rate to reduce lag on low-end devices",
	["Callback"] = function(p66)
    local v284
    local function v285()
        setfpscap(v284)
    end
    v284 = p66
    pcall(v285)
end
})
value17 = v251:Section({
	["Name"] = "Music",
	["Icon"] = "music",
	["Side"] = 2
})
value17:Dropdown({
	["Name"] = "Play Music",
	["Flag"] = "PlayMusic",
	["Items"] = v136,
	["Search"] = true,
	["Tooltip"] = "Choose a music track to play in your restaurant",
	["Callback"] = function(p67)
    local v286 = t1.value57()

    if not v286 then
        return
    end

    t1.value5.Events.Restaurant.SetMusicRequested:FireServer(v286, p67)
end
})
value17:Divider("Buy")
value17:Dropdown({
	["Name"] = "Buy Music",
	["Flag"] = "BuyMusic",
	["Items"] = t11,
	["Search"] = true,
	["Tooltip"] = "Purchase a music track for your restaurant",
	["Callback"] = function(p68)
    t1.value5.Events.Restaurant.BuyMusicRequested:FireServer(p68)
end
})
value17 = v252:Section({
	["Name"] = "General",
	["Icon"] = "circle-user-round",
	["Side"] = 1
})
t1.value98.AntiAFK = value17:Toggle({
	["Name"] = "Anti AFK",
	["Flag"] = "AntiAFK",
	["Default"] = true,
	["Tooltip"] = "Prevents idle kick by simulating activity",
	["Callback"] = function(p69)
    if not t1.value22 then
        if not p69 then
            return
        end

        return
    end

    t1.value22:Disconnect()

    if not p69 then
        return
    end
end
})
task.defer(function()
    if not t1.value25.Flags.AntiAFK then
        return
    end

    if t1.value22 then
        t1.value22:Disconnect()
    end

    t1.value12.Idled:Connect(function()
        t1.value9:CaptureController()
        t1.value9:ClickButton2(Vector2.new())
    end)
end)
t1.value100 = false
t1.value98.InfiniteJump = value17:Toggle({
	["Name"] = "Infinite Jump",
	["Flag"] = "InfiniteJump",
	["Default"] = false,
	["Tooltip"] = "Allow repeated jumping in midair",
	["Callback"] = function(p70)
    t1.value100 = p70
end
})
value17:Keybind({
	["Name"] = "Inf Jump Keybind",
	["Flag"] = "InfJumpKey",
	["Default"] = Enum.KeyCode.V,
	["SyncFlag"] = "InfiniteJump",
	["Tooltip"] = "Bind a key to toggle infinite jump",
	["Callback"] = function()
    if not t1.value98.InfiniteJump then
        return
    end

    t1.value98.InfiniteJump:Set(not t1.value25.Flags.InfiniteJump)
end
})
UserInputService.JumpRequest:Connect(function()
    if not t1.value100 then
        return
    end

    local Character = t1.value12.Character

    if Character then
        Character = t1.value12.Character:FindFirstChildOfClass("Humanoid")
    end

    if not Character then
        return
    end

    Character:ChangeState(Enum.HumanoidStateType.Jumping)
end)
t1.value101 = false
t1.value102 = 100
t1.value103 = nil
t1.value104 = nil
t1.value105 = {
	["W"] = false,
	["A"] = false,
	["S"] = false,
	["D"] = false,
	["Up"] = false,
	["Down"] = false
}
t1.value106 = nil
t1.value107 = nil
t1.value108 = nil
v136 = function(p71)
    t1.value103 = p71:WaitForChild("Humanoid", 8)
    t1.value104 = p71:WaitForChild("HumanoidRootPart", 8)

    local value101 = t1.value101

    if value101 then
        value101 = t1.value98.Fly
    end

    if not value101 then
        t1.value101 = false

        return
    end

    t1.value98.Fly:Set(false)
    t1.value101 = false
end
if t1.value12.Character then
    v136(t1.value12.Character)
end
t1.value12.CharacterAdded:Connect(v136)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    local KeyCode = input.KeyCode

    if KeyCode == Enum.KeyCode.W then
        t1.value105.W = true

        return
    end

    if KeyCode == Enum.KeyCode.A then
        t1.value105.A = true

        return
    end

    if KeyCode == Enum.KeyCode.S then
        t1.value105.S = true

        return
    end

    if KeyCode == Enum.KeyCode.D then
        t1.value105.D = true

        return
    end

    if KeyCode == Enum.KeyCode.Space then
        t1.value105.Up = true

        return
    end

    if KeyCode ~= Enum.KeyCode.LeftControl then
        return
    end

    t1.value105.Down = true
end)
UserInputService.InputEnded:Connect(function(input)
    local KeyCode = input.KeyCode

    if KeyCode == Enum.KeyCode.W then
        t1.value105.W = false

        return
    end

    if KeyCode == Enum.KeyCode.A then
        t1.value105.A = false

        return
    end

    if KeyCode == Enum.KeyCode.S then
        t1.value105.S = false

        return
    end

    if KeyCode == Enum.KeyCode.D then
        t1.value105.D = false

        return
    end

    if KeyCode == Enum.KeyCode.Space then
        t1.value105.Up = false

        return
    end

    if KeyCode ~= Enum.KeyCode.LeftControl then
        return
    end

    t1.value105.Down = false
end)
function t1.value109()
    if t1.value108 then
        t1.value108:Disconnect()
    end

    if t1.value106 then
        t1.value106:Destroy()
        t1.value106 = nil
    end

    if t1.value107 then
        t1.value107:Destroy()
        t1.value107 = nil
    end

    if not t1.value103 then
        return
    end

    t1.value103.PlatformStand = false
    t1.value103.AutoRotate = true
    t1.value103:ChangeState(Enum.HumanoidStateType.GettingUp)
    t1.value103:ChangeState(Enum.HumanoidStateType.Running)
end
function t1.value110()
    if not (t1.value103 and t1.value104) then
        return
    end
end
value17:Divider()
t1.value98.Fly = value17:Toggle({
	["Name"] = "Fly",
	["Flag"] = "Fly",
	["Default"] = false,
	["Tooltip"] = "Enable flight mode",
	["Callback"] = function(p72)
    t1.value101 = p72

    if p72 then
        t1.value110()

        return
    else
        t1.value109()

        return
    end
end
})
value17:Keybind({
	["Name"] = "Fly Keybind",
	["Flag"] = "FlyBind",
	["Default"] = Enum.KeyCode.G,
	["SyncFlag"] = "Fly",
	["Tooltip"] = "Bind a key to toggle fly",
	["Callback"] = function()
    if not t1.value98.Fly then
        return
    end

    t1.value98.Fly:Set(not t1.value25.Flags.Fly)
end
})
value17:Slider({
	["Name"] = "Fly Speed",
	["Flag"] = "FlySpeedRT3",
	["Min"] = 20,
	["Max"] = 1000,
	["Default"] = 100,
	["Tooltip"] = "Change speed while flying",
	["Callback"] = function(p73)
    t1.value102 = p73
end
})
value17:Divider()
t1.value98.Noclip = value17:Toggle({
	["Name"] = "Noclip",
	["Flag"] = "Noclip",
	["Default"] = false,
	["Tooltip"] = "Walk through walls and objects",
	["Callback"] = function(p74)
    local Character, Parent

    if not t1.value23 then
        if p74 then
            Character = t1.value12.Character

            if not Character then
                return
            end

            return
        else
            for k, v in pairs(t1.value24) do
                Parent = k and k.Parent

                if Parent then
                    Parent = k:IsA("BasePart")
                end

                if Parent then
                    k.CanCollide = v
                end
            end

            return
        end

        return
    end

    t1.value23:Disconnect()

    if p74 then
        Character = t1.value12.Character

        if not Character then
            return
        end

        return
    else
        for k, v in pairs(t1.value24) do
            Parent = k and k.Parent

            if Parent then
                Parent = k:IsA("BasePart")
            end

            if Parent then
                k.CanCollide = v
            end
        end

        return
    end
end
})
UserInputService = Enum.KeyCode
value17:Keybind({
	["Name"] = "Noclip Keybind",
	["Flag"] = "NoclipKey",
	["Default"] = UserInputService.N,
	["SyncFlag"] = "Noclip",
	["Tooltip"] = "Bind a key to toggle noclip",
	["Callback"] = function()
    if not t1.value98.Noclip then
        return
    end

    t1.value98.Noclip:Set(not t1.value25.Flags.Noclip)
end
})
UserInputService = v252:Section({
	["Name"] = "Camera",
	["Icon"] = "aperture",
	["Side"] = 1
})
UserInputService:Slider({
	["Name"] = "Field Of View",
	["Flag"] = "FOVValue",
	["Min"] = 50,
	["Max"] = 120,
	["Default"] = 70,
	["Suffix"] = "\194\176",
	["Tooltip"] = "Adjust the camera field of view",
	["Callback"] = function(p75)
    local CurrentCamera = t1.value2.CurrentCamera

    if not CurrentCamera then
        return
    end

    CurrentCamera.FieldOfView = p75
end
})
UserInputService:Divider()
t1.value111 = UserInputService:Slider({
	["Name"] = "Camera Zoom",
	["Flag"] = "CameraZoom",
	["Min"] = 128,
	["Max"] = 9999,
	["Default"] = 128,
	["Suffix"] = " studs",
	["Tooltip"] = "Adjust camera zoom distance",
	["Callback"] = function(p76)
    if p76 == 0 then
        t1.value12.CameraMaxZoomDistance = (1 / 0)
        t1.value12.CameraMinZoomDistance = 0

        return
    else
        t1.value12.CameraMaxZoomDistance = p76

        local value12 = t1.value12
        local v299 = p76 / 2

        value12.CameraMinZoomDistance = math.min(0.5, v299)

        return
    end
end
})
UserInputService:Button({
	["Name"] = "Reset Camera Zoom",
	["Icon"] = "rotate-ccw",
	["Tooltip"] = "Reset camera zoom to default",
	["Callback"] = function()
    t1.value12.CameraMaxZoomDistance = 128
    t1.value12.CameraMinZoomDistance = 0.5
    t1.value25.Flags.CameraZoom = 128

    local value111 = t1.value111

    if value111 then
        value111 = t1.value111.Set
    end

    if not value111 then
        return
    end

    t1.value111:Set(128, true)
end
})
UserInputService = v252:Section({
	["Name"] = "Movement",
	["Icon"] = "footprints",
	["Side"] = 2
})
t1.value112 = "Normal"
t1.value113 = false
t1.value114 = 40
t1.value98.WalkSpeedEnabled = UserInputService:Toggle({
	["Name"] = "Enable WalkSpeed",
	["Flag"] = "WalkSpeedEnabled",
	["Default"] = false,
	["Tooltip"] = "Enable custom player walk speed",
	["Callback"] = function(p77)
    t1.value113 = p77

    if p77 then
        return
    end

    local Character = t1.value12.Character

    if Character then
        Character = t1.value12.Character:FindFirstChild("Humanoid")
    end

    if not Character then
        return
    end

    Character.WalkSpeed = 24
end
})
value17 = {
	["Name"] = "WalkSpeed Keybind",
	["Flag"] = "WalkSpeedKey",
	["Default"] = Enum.KeyCode.C,
	["Tooltip"] = "Bind a key to toggle walk speed",
	["Callback"] = function()
    if not t1.value98.WalkSpeedEnabled then
        return
    end

    t1.value98.WalkSpeedEnabled:Set(not t1.value25.Flags.WalkSpeedEnabled)
end
}
UserInputService:Keybind(value17)
UserInputService:Dropdown({
	["Name"] = "WalkSpeed Method",
	["Flag"] = "WalkSpeedMethod",
	["Default"] = "Normal",
	["Items"] = { "Normal", "CFrame" },
	["Tooltip"] = "Choose how walk speed is applied",
	["Callback"] = function(p78)
    t1.value112 = p78
end
})
UserInputService:Slider({
	["Name"] = "WalkSpeed Value",
	["Flag"] = "WalkSpeedValue",
	["Min"] = 24,
	["Max"] = 500,
	["Default"] = 40,
	["Tooltip"] = "Set your player move speed",
	["Callback"] = function(p79)
    t1.value114 = p79
end
})
UserInputService:Divider()
UserInputService:Slider({
	["Name"] = "JumpPower",
	["Flag"] = "JumpPower",
	["Min"] = 0,
	["Max"] = 1000,
	["Default"] = 50,
	["Tooltip"] = "Adjust jump strength",
	["Callback"] = function(p80)
    local Character = t1.value12.Character

    if Character then
        Character = t1.value12.Character:FindFirstChild("Humanoid")
    end

    if not Character then
        return
    end

    Character.JumpPower = p80
    Character.UseJumpPower = true
end
})
UserInputService:Slider({
	["Name"] = "Gravity",
	["Flag"] = "GravityValue",
	["Min"] = 0,
	["Max"] = 500,
	["Default"] = 196.2,
	["Tooltip"] = "Change game gravity",
	["Callback"] = function(p81)
    t1.value2.Gravity = p81
end
})
task.spawn(function()
    while task.wait(0.02) do
        if t1.value113 then
            local Character = t1.value12.Character

            if Character then
                Character = t1.value12.Character:FindFirstChild("Humanoid")
            end

            if Character then
                if t1.value112 == "CFrame" then
                    if Character.WalkSpeed ~= 16 then
                        Character.WalkSpeed = 16
                    end

                    Character = Character.MoveDirection

                    if Character.Magnitude > 0 then
                        t1.value12.Character:TranslateBy(Character.Unit * (t1.value114 / 100))
                    end
                elseif Character.WalkSpeed ~= t1.value114 then
                    Character.WalkSpeed = t1.value114
                end
            end
        end
    end
end)
t1.value12.CharacterAdded:Connect(function(character)
    task.wait()

    local Humanoid = character:WaitForChild("Humanoid")

    if t1.value113 then
        Humanoid.WalkSpeed = t1.value114
    end

    Humanoid.JumpPower = t1.value25.Flags.JumpPower or 50
    Humanoid.UseJumpPower = true
    Humanoid = t1.value25.Flags.GravityValue

    local v305

    if not Humanoid then
        Humanoid = t1.value25.Flags.CameraZoom

        if Humanoid then
            v305 = Humanoid > 0
        else
            v305 = Humanoid
        end

        if v305 then
            t1.value12.CameraMaxZoomDistance = Humanoid

            return
        else
            t1.value12.CameraMaxZoomDistance = (1 / 0)

            return
        end

        return
    end

    t1.value2.Gravity = Humanoid
    Humanoid = t1.value25.Flags.CameraZoom

    if Humanoid then
        v305 = Humanoid > 0
    else
        v305 = Humanoid
    end

    if v305 then
        t1.value12.CameraMaxZoomDistance = Humanoid

        return
    else
        t1.value12.CameraMaxZoomDistance = (1 / 0)

        return
    end
end)
UserInputService = v253:Section({
	["Name"] = "Main",
	["Icon"] = "monitor",
	["Side"] = 1,
	["LayoutOrder"] = 1
})
t1.value115 = nil
t1.value116 = nil
t1.value117 = nil
UserInputService:Toggle({
	["Name"] = "Infinite Cash (Visual)",
	["Flag"] = "InfCashVisual",
	["Default"] = false,
	["Tooltip"] = "Sets cash display very high (visual only). Restores when off",
	["Callback"] = function(p82)
    local v306
    local function v307()
        local Amount = t1.value12.PlayerGui.other["HUD Elements"].Left.CashBase.Cash.Amount

        if v306 then
            t1.value115 = Amount.Text
            Amount.Text = tostring((1 / 0))

            return
        else
            Amount.Text = t1.value115 or Amount.Text

            return
        end
    end
    v306 = p82
    if pcall(v307) then
        return
    end
end
})
UserInputService:Label("Note: Visual only \226\128\148 not actual money.")
UserInputService:Divider("Leaderstats")
t1.value118 = {}
UserInputService:Toggle({
	["Name"] = "Infinite Cash on Leaderstats (Visual)",
	["Flag"] = "InfCashLeaderstatsVisual",
	["Default"] = false,
	["Tooltip"] = "Leaderstats IntValues with \"Cash\" in the name \226\128\148 visual only",
	["Callback"] = function(p83)
    local function v309()
        local leaderstats = t1.value12:FindFirstChild("leaderstats")

        if leaderstats then
            local GetChildren = leaderstats.GetChildren

            for _, v in ipairs(GetChildren(leaderstats)) do
                local isIntValue = v:IsA("IntValue")

                if isIntValue then
                    isIntValue = string.find(v.Name, "Cash")
                end

                if isIntValue then
                    if p83 then
                        t1.value118[v] = v.Value
                        v.Value = 999999999999
                    else
                        isIntValue = t1.value118[v]

                        if isIntValue ~= nil then
                            v.Value = isIntValue
                        end

                        t1.value118[v] = nil
                    end
                end
            end

            return
        else
            return
        end
    end

    pcall(v309)
end
})
UserInputService:Divider("Other")
UserInputService:Toggle({
	["Name"] = "Infinite Diamonds (Visual)",
	["Flag"] = "InfDiamondsVisual",
	["Default"] = false,
	["Tooltip"] = "Diamonds value \226\128\148 visual only",
	["Callback"] = function(p84)
    local v315
    local function v316()
        local Diamonds = t1.value12:FindFirstChild("Diamonds")

        if Diamonds then
            if v315 then
                t1.value117 = Diamonds.Value
                Diamonds.Value = 1000000000000

                return
            else
                Diamonds.Value = t1.value117 or Diamonds.Value

                return
            end

            return
        else
            return
        end
    end
    v315 = p84
    pcall(v316)
end
})
UserInputService = v253:Section({
	["Name"] = "Ambient",
	["Icon"] = "sun",
	["Side"] = 1,
	["LayoutOrder"] = 2
})
t1.value119 = {
	["Ambient"] = t1.value4.Ambient,
	["OutdoorAmbient"] = t1.value4.OutdoorAmbient,
	["Brightness"] = t1.value4.Brightness,
	["ClockTime"] = t1.value4.ClockTime,
	["FogEnd"] = t1.value4.FogEnd,
	["GlobalShadows"] = t1.value4.GlobalShadows,
	["ExposureCompensation"] = t1.value4.ExposureCompensation
}
t1.value120 = {}
value17 = UserInputService.Toggle(UserInputService, {
	["Name"] = "Enable Ambient",
	["Flag"] = "AmbientToggle",
	["Default"] = false,
	["Tooltip"] = "Overrides ambient lighting with a custom color",
	["Callback"] = function(p85)
    if p85 then
        t1.value4.Ambient = t1.value25.Flags.AmbientColor or Color3.new(1, 1, 1)
        t1.value4.OutdoorAmbient = t1.value25.Flags.AmbientColor or Color3.new(1, 1, 1)

        return
    else
        t1.value4.Ambient = t1.value119.Ambient
        t1.value4.OutdoorAmbient = t1.value119.OutdoorAmbient

        return
    end
end
}):Settings(200):Label("Ambient Color")
v136 = {
	["Name"] = "Ambient Color",
	["Flag"] = "AmbientColor",
	["Default"] = Color3.new(1, 1, 1),
	["Callback"] = function(p86)
    if t1.value25.Flags.AmbientToggle then
        t1.value4.Ambient = p86
        t1.value4.OutdoorAmbient = p86

        return
    else
        return
    end
end
}
value17:Colorpicker(v136)
UserInputService:Divider()
UserInputService:Toggle({
	["Name"] = "Fullbright",
	["Flag"] = "Fullbright",
	["Default"] = false,
	["Tooltip"] = "Maximizes lighting; reduces shadows, fog, blur and atmosphere",
	["Callback"] = function(p87)
    if p87 then
        t1.value120 = {}
        t1.value4.Brightness = 10
        t1.value4.ClockTime = 14
        t1.value4.FogEnd = 1000000000
        t1.value4.GlobalShadows = false
        t1.value4.Ambient = Color3.fromRGB(255, 255, 255)
        t1.value4.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        t1.value4.ExposureCompensation = 1

        local ipairs_ = ipairs
        local value4 = t1.value4

        for _, child in ipairs_(value4:GetChildren()) do
            if child:IsA("BlurEffect") or (child:IsA("ColorCorrectionEffect") or child:IsA("SunRaysEffect") or (child:IsA("BloomEffect") or child:IsA("Atmosphere"))) then
                t1.value120[child] = child.Enabled
                child.Enabled = false
            end
        end

        return
    else
        t1.value4.Brightness = t1.value119.Brightness
        t1.value4.ClockTime = t1.value119.ClockTime
        t1.value4.FogEnd = t1.value119.FogEnd
        t1.value4.GlobalShadows = t1.value119.GlobalShadows
        t1.value4.Ambient = t1.value119.Ambient
        t1.value4.OutdoorAmbient = t1.value119.OutdoorAmbient
        t1.value4.ExposureCompensation = t1.value119.ExposureCompensation or 0

        for k, v in pairs(t1.value120) do
            if k.Parent then
                k.Enabled = v
            end
        end

        return
    end
end
})
function t1.value121(p88)
    t1.value4.ClockTime = p88
    task.spawn(function()
        for _ = 1, 40 do
            t1.value4.ClockTime = p88
            task.wait(0.05)
        end
    end)
end
UserInputService = v253:Section({
	["Name"] = "World Effects",
	["Icon"] = "globe",
	["Side"] = 2,
	["LayoutOrder"] = 999
})
UserInputService:Button({
	["Name"] = "Set Day",
	["Icon"] = "sun",
	["Tooltip"] = "ClockTime 14",
	["Callback"] = function()
    t1.value121(14)
end
})
UserInputService:Button({
	["Name"] = "Set Night",
	["Icon"] = "moon",
	["Tooltip"] = "ClockTime 0",
	["Callback"] = function()
    t1.value121(0)
end
})
UserInputService:Divider()
UserInputService:Toggle({
	["Name"] = "X-Ray",
	["Flag"] = "XRay",
	["Tooltip"] = "Semi-transparent non-character parts",
	["Callback"] = function(p89)
    local ipairs_ = ipairs
    local value2 = t1.value2

    for _, descendant in ipairs_(value2:GetDescendants()) do
        local isBasePart = descendant:IsA("BasePart")
        if isBasePart then
            isBasePart = not descendant:IsDescendantOf(t1.value12.Character)
        end
        if isBasePart then
            descendant.LocalTransparencyModifier = p89 and 0.7 or 0
        end
    end
end
})
t1.value122 = nil
function t1.value122(p90, p91)
    local v330 = t1.value25.Flags[p90]

    if typeof(v330) == "Color3" then
        return v330
    else
        local Color

        if typeof(v330) == "table" then
            Color = v330.Color
        else
            Color = false
        end

        if Color then
            return v330.Color
        else
            return p91
        end

        return
    end
end
UserInputService = v253:Section({
	["Name"] = "ESP",
	["Icon"] = "crosshair",
	["Side"] = 2
})
t1.value123 = false
t1.value124 = {}
UserInputService:Toggle({
	["Name"] = "Players Chams",
	["Flag"] = "PlayersChams",
	["Default"] = false,
	["Tooltip"] = "Highlight other players through walls",
	["Callback"] = function(p92)
    t1.value123 = p92

    for _, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value1.LocalPlayer then
            local ipairs_

            if player.Character then
                local isBasePart

                if p92 then
                    ipairs_ = ipairs

                    local Character = player.Character

                    for _, descendant in ipairs_(Character:GetDescendants()) do
                        isBasePart = descendant:IsA("BasePart")

                        if isBasePart then
                            isBasePart = not descendant:FindFirstChild("PlayerCham")
                        end

                        if isBasePart then
                            isBasePart = Instance.new("Highlight")
                            isBasePart.Name = "PlayerCham"
                            isBasePart.FillColor = Color3.fromRGB(0, 100, 255)
                            isBasePart.OutlineColor = Color3.fromRGB(0, 200, 255)
                            isBasePart.FillTransparency = 0.3
                            isBasePart.OutlineTransparency = 0
                            isBasePart.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            isBasePart.Parent = descendant
                        end
                    end
                else
                    for _, descendant in ipairs(player.Character:GetDescendants()) do
                        isBasePart = descendant:IsA("Highlight")

                        if isBasePart then
                            isBasePart = descendant.Name == "PlayerCham"
                        end

                        if isBasePart then
                            descendant:Destroy()
                        end
                    end
                end
            end

            if p92 then
                ipairs_ = function(character)
                    task.wait(0.5)

                    if t1.value123 then
                        for _, descendant in ipairs(character:GetDescendants()) do
                            local isBasePart = descendant:IsA("BasePart")

                            if isBasePart then
                                isBasePart = not descendant:FindFirstChild("PlayerCham")
                            end

                            if isBasePart then
                                isBasePart = Instance.new("Highlight")
                                isBasePart.Name = "PlayerCham"
                                isBasePart.FillColor = Color3.fromRGB(0, 100, 255)
                                isBasePart.OutlineColor = Color3.fromRGB(0, 200, 255)
                                isBasePart.FillTransparency = 0.3
                                isBasePart.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                isBasePart.Parent = descendant
                            end
                        end

                        return
                    else
                        return
                    end
                end
                t1.value124[player] = player.CharacterAdded:Connect(ipairs_)
            elseif t1.value124[player] then
                t1.value124[player]:Disconnect()
                t1.value124[player] = nil
            end
        end
    end
end
})
v253:Section({
	["Name"] = "Lighting",
	["Icon"] = "sun",
	["Side"] = 2,
	["LayoutOrder"] = 2
}):Toggle({
	["Name"] = "No Shadows",
	["Flag"] = "NoShadows",
	["Tooltip"] = "Disables global shadows",
	["Callback"] = function(p93)
    t1.value4.GlobalShadows = not p93
end
})
UserInputService = tick()
t1.value125 = 0
t1.value126 = UserInputService
t1.value127 = 0
t1.value6.RenderStepped:Connect(function()
    local v344 = t1

    v344.value125 = v344.value125 + 1

    if not (tick() - t1.value126 >= 1) then
        return
    end

    t1.value127 = t1.value125
end)
UserInputService = v255:Section({
	["Name"] = "Main",
	["Icon"] = "terminal",
	["Side"] = 1
})
value17 = v255:Section({
	["Name"] = "Server Info",
	["Icon"] = "chart-bar",
	["Side"] = 2
})
UserInputService:Button({
	["Name"] = "Server Hop",
	["Icon"] = "shuffle",
	["Tooltip"] = "Teleport to another server with an open slot",
	["Callback"] = function()
    local v345 = "https://games.roblox.com/v1/games/" .. t1.value16 .. "/servers/Public?sortOrder=Desc&limit=100"
    local v346
    while true do
        local pcall_ = pcall
        local HttpGet = game.HttpGet
        local game_ = game

        if v346 then
            v346 = "&cursor=" .. v346
        end

        v346, pcall_ = pcall_(HttpGet, game_, v345 .. v346 or "")

        if not v346 then
            return
        end

        v346 = t1.value3:JSONDecode(pcall_)
        pcall_ = next
        HttpGet = v346.data
        game_ = nil

        while true do
            local v350

            game_, v350 = pcall_(HttpGet, game_)

            if not game_ then
                break
            end

            local v351

            if v350.playing < v350.maxPlayers then
                v351 = v350.id ~= game.JobId
            else
                v351 = false
            end

            if v351 and pcall(t1.value7.TeleportToPlaceInstance, t1.value7, t1.value16, v350.id, t1.value12) then
                return
            end
        end

        v346 = v346.nextPageCursor

        if not v346 then
            return
        end
    end
end
})
UserInputService:Button({
	["Name"] = "Join Smallest Server",
	["Icon"] = "users",
	["Tooltip"] = "Least populated server from the list",
	["Callback"] = function()
    local v352 = "https://games.roblox.com/v1/games/" .. t1.value16 .. "/servers/Public?sortOrder=Asc&limit=100"

    v352 = { pcall(game.HttpGet, game, v352) }

    local v353 = v352[2]

    if not v352[1] then
        return
    end

    v352 = t1.value3:JSONDecode(v353).data[1]

    if not v352 then
        return
    end

    t1.value7:TeleportToPlaceInstance(t1.value16, v352.id, t1.value12)
end
})
UserInputService:Button({
	["Name"] = "Rejoin Server",
	["Icon"] = "refresh-cw",
	["Tooltip"] = "Rejoin current server",
	["Callback"] = function()
    t1.value7:TeleportToPlaceInstance(t1.value16, game.JobId, t1.value12)
end
})
UserInputService:Divider("JobId")
UserInputService:Textbox({
	["Flag"] = "JobIdInput",
	["Default"] = "",
	["Numeric"] = false,
	["Placeholder"] = "Enter JobId here...",
	["Finished"] = false
})
UserInputService:Button({
	["Name"] = "Join by JobId",
	["Icon"] = "log-in",
	["Tooltip"] = "Teleport by JobId",
	["Callback"] = function()
    local JobIdInput = t1.value25.Flags.JobIdInput

    if not JobIdInput or JobIdInput == "" then
        t1.value25:Notification({
				["Title"] = "Error",
				["Description"] = "Please enter a JobId.",
				["Duration"] = 3,
				["Icon"] = "97594400820219"
			})

        return
    else
        if #JobIdInput ~= 36 and true or not JobIdInput:match("^[a-f0-9%-]+$") then
            t1.value25:Notification({
					["Title"] = "Invalid",
					["Description"] = "Not a valid JobId format.",
					["Duration"] = 3,
					["Icon"] = "97594400820219"
				})

            return
        else
            t1.value7:TeleportToPlaceInstance(t1.value16, JobIdInput, t1.value12)

            return
        end

        return
    end
end
})
UserInputService:Button({
	["Name"] = "Copy JobId",
	["Icon"] = "copy",
	["Tooltip"] = "Copy this server\'s JobId",
	["Callback"] = function()
    pcall(setclipboard, game.JobId)
    t1.value25:Notification({
			["Title"] = "Copied",
			["Description"] = "Current JobId copied.",
			["Duration"] = 2,
			["Icon"] = "97594400820219"
		})
end
})
t1.value128 = value17:Label("Players: 0 / 0")
t1.value129 = value17:Label("Memory: \226\128\148")
t1.value130 = value17:Label("PlaceId: \226\128\148")
t1.value131 = value17:Label("FPS: \226\128\148")
task.spawn(function()
    while true do
        task.wait(1)

        local value128 = t1.value128
        local v356 = #t1.value1:GetPlayers()
        local MaxPlayers = t1.value1.MaxPlayers

        value128:SetText(unpack_({ ("Players: %d / %d").format("Players: %d / %d", v356, MaxPlayers) }))
        value128 = function()
            return t1.value8:GetTotalMemoryUsageMb()
        end
        value128, v356 = pcall(value128)

        if value128 then
            value128 = type(v356) == "number"
        end

        if value128 then
            t1.value129:SetText(("Memory: %.0f MB").format("Memory: %.0f MB", v356))
        end

        t1.value130:SetText(("PlaceId: %d"):format(t1.value16))
        value128 = t1.value131
        v356 = t1.value127
        value128:SetText(("FPS: %d").format("FPS: %d", v356))
    end
end)
value25:TabDivider()
t1.value132 = t1.value25:CreateSettingsPage(value25, TouchEnabled)
pcall(function()
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"))()

    lib:SetLibrary(t1.value25)
    lib:SetFolder("Samuraa1Hub")
    lib:BuildThemeSection(t1.value132)
    lib:ApplySavedDefault()
end)
pcall(function()
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"))()

    lib:SetLibrary(t1.value25)
    lib:SetFolder("Samuraa1Hub/RestaurantTycoon3")

    local LoadAutoloadConfig = lib.LoadAutoloadConfig

    if type(LoadAutoloadConfig) ~= "function" then
        return
    end

    pcall(function()
        lib:LoadAutoloadConfig()
    end)
end)
unpack_ = syn
if unpack_ then
    unpack_ = syn.queue_on_teleport
end
if not unpack_ then
    unpack_ = queue_on_teleport

    if not unpack_ then
        unpack_ = fluxus

        if unpack_ then
            unpack_ = fluxus.queue_on_teleport
        end

        if not unpack_ then
            unpack_ = not (krnl and krnl.queue_on_teleport) and delta

            if unpack_ then
                unpack_ = delta.queue_on_teleport
            end
        end
    end
end
t1.value133 = unpack_
t1.value134 = "loadstring(game:HttpGet(\'https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/rt3-new_ui.lua\'))()"
unpack_ = t1.value132:Section({
	["Name"] = "Feedback",
	["Icon"] = "messages-square",
	["Side"] = 1,
	["LayoutOrder"] = -100
})
t1.value135 = unpack_:Textbox({
	["Flag"] = "FeedbackText",
	["Default"] = "",
	["Numeric"] = false,
	["Placeholder"] = "Your message\226\128\166",
	["Finished"] = false,
	["Tooltip"] = "Enter your feedback message here"
})
unpack_:Button({
	["Name"] = "Send to developer",
	["Icon"] = "send",
	["Tooltip"] = "Send your feedback to the developer",
	["Callback"] = function()
    local FeedbackText = t1.value25.Flags.FeedbackText

    if not FeedbackText or #FeedbackText == 0 then
        t1.value25:Notification({
				["Title"] = "Empty",
				["Description"] = "Type something in the box first.",
				["Duration"] = 2.5,
				["Icon"] = "97594400820219"
			})

        return
    else
        if #FeedbackText > 1800 then
            t1.value25:Notification({
					["Title"] = "Too long",
					["Description"] = "Shorten the message (max ~1800 chars).",
					["Duration"] = 3,
					["Icon"] = "97594400820219"
				})

            return
        else
            t1.value25:Notification({
					["Title"] = "Sending",
					["Description"] = "One moment\226\128\166",
					["Duration"] = 1.5,
					["Icon"] = "97594400820219"
				})

            if t1.value36(FeedbackText) then
                t1.value25:Notification({
						["Title"] = "Sent",
						["Description"] = "Thanks \226\128\148 your note was delivered.",
						["Duration"] = 3,
						["Icon"] = "97594400820219"
					})
                t1.value135:Set("")

                return
            else
                t1.value25:Notification({
						["Title"] = "Not sent",
						["Description"] = "Webhook failed \226\128\148 check executor / network.",
						["Duration"] = 4,
						["Icon"] = "97594400820219"
					})

                return
            end

            return
        end

        return
    end
end
})
unpack_ = t1.value132:Section({
	["Name"] = "Script",
	["Icon"] = "file-code-2",
	["Side"] = 1,
	["LayoutOrder"] = 10
})
unpack_:Toggle({
	["Name"] = "Auto Execute on Teleport",
	["Flag"] = "AutoExec",
	["Default"] = false,
	["Tooltip"] = "Automatically execute the script after teleporting to another server",
	["Callback"] = function(p94)
    if p94 then
        p94 = t1.value133
    end

    if not p94 then
        return
    end

    local value134 = t1.value134

    t1.value133(value134)
end
})
unpack_ = t1.value132:Section({
	["Name"] = "Actions",
	["Icon"] = "power",
	["Side"] = 2,
	["LayoutOrder"] = 10
})
unpack_:Button({
	["Name"] = "Unload Script",
	["Icon"] = "circle-x",
	["Tooltip"] = "Unload the script and disable all features",
	["Callback"] = function()
    _G.AutoDailyReward = false
    _G.CollectDropMoney = false
    _G.AutoPlant = false
    _G.AutoHarvest = false
    _G.AutoCalmRude = false
    getgenv().AutoUpgrade = false
    t1.value25:Unload()
end
})
value25:Init()
t1.value5.Events.NotificationAdded:Fire("Hello " .. t1.value13 .. "! Loading\226\128\166")
task.defer(function()
    t1.value25:Notification({
		["Title"] = "Info",
		["Description"] = "Execution logger: nickname, game & executor logged only",
		["Duration"] = 8,
		["Icon"] = "97594400820219"
	})
end)
task.defer(function()
    t1.value25:Notification({
		["Title"] = "Loaded",
		["Description"] = "Samuraa1 Hub \226\128\148 Restaurant Tycoon 3",
		["Duration"] = 6,
		["Icon"] = "97594400820219"
	})
end)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/RT3-Executions.lua"))()
end)
t1.value5.Events.NotificationAdded:Fire("Loaded Samuraa1 Hub Successfully!")
