-- This file was generated at discord.gg/syncrypt

local v1 = getfenv and getfenv() or _ENV
local v2 = unpack or table.unpack
local t1 = {
	ServiceId = 34205,
	PlatoSecret = "58d7e2b0-1329-4dd2-b1aa-fa11b8475ae1",
	MainScriptURL = "https://raw.githubusercontent.com/CAVALEIROHAHA/build-the-pyramid/refs/heads/main/BuildThePyramid.obfuscated.luau",
	GateTag = "huakuyyedmae"
}
local MainScriptURL = t1.MainScriptURL
local t2 = {
	["123720558354386"] = {
		Name = "Build the Pyramid!",
		URL = MainScriptURL,
		Access = "PyramidAccess"
	},
	["114326934417838"] = {
		Name = "Break and Steal an Egg",
		URL = "https://raw.githubusercontent.com/CAVALEIROHAHA/build-the-pyramid/refs/heads/main/PanoraHub.keyed.luau",
		Access = "PanoraAccess"
	}
}
local function v6()
    local v39 = t2[tostring(game.PlaceId)]

    if not v39 then
        error("PANORA HUB does not support this game.", 0)
    end

    return v39
end
local function v7(p1)
    local bxor = bit32.bxor
    local band = bit32.band
    local rshift = bit32.rshift
    local rrotate = bit32.rrotate

    local function v45(p2)
        return (string.char(band(rshift(p2, 24), 255), band(rshift(p2, 16), 255), band(rshift(p2, 8), 255), (band(p2, 255))))
    end

    local v46 = #p1
    local v47 = p1 .. "\128" .. string.rep("\000", (55 - v46) % 64) .. v45((math.floor(v46 / 536870912))) .. v45(v46 * 8 % 4294967296)
    local n1 = 64
    local v49 = #v47
    local t3 = {
		1779033703,
		3144134277,
		1013904242,
		2773480762,
		1359893119,
		2600822924,
		528734635,
		1541459225
	}
    local v51 = n1 < 0
    local v52 = 1 - n1

    while true do
        v52 = n1 + v52

        if (not v51 or not (v49 <= v52)) and (v51 or not (v52 <= v49)) then
            break
        end

        local t4 = table.create(64)

        for i = 1, 16 do
            local v55, v56, v57, v58 = string.byte(v47, v52 + (i - 1) * 4, v52 + (i - 1) * 4 + 3)

            t4[i] = ((v55 * 256 + v56) * 256 + v57) * 256 + v58
        end

        local n2 = 64
        local n3 = 1
        local v61 = n3 < 0
        local v62 = 17 - n3

        while true do
            v62 += n3

            local v63 = v62 <= n2

            if (not v61 or not (n2 <= v62)) and (v61 or not v63) then
                break
            end

            local v64 = t4[v62 - 15]
            local v65 = t4[v62 - 2]
            local v66 = t4[v62 - 16]
            local v67 = bxor(rrotate(v64, 7), rrotate(v64, 18), (rshift(v64, 3)))
            local v68 = t4[v62 - 7]

            t4[v62] = (v66 + v67 + v68 + bxor(rrotate(v65, 17), rrotate(v65, 19), (rshift(v65, 10)))) % 4294967296
        end

        local v69, v70, v71, v72, v73, v74, v75, v76 = table.unpack(t3)
        local n4 = 64
        local n5 = 1
        local v79 = n5 < 0
        local v80 = 1 - n5

        while true do
            v80 = n5 + v80

            if (not v79 or not (n4 <= v80)) and (v79 or not (v80 <= n4)) then
                break
            end

            local v81 = v76 + bxor(rrotate(v73, 6), rrotate(v73, 11), rrotate(v73, 25))
            local v82 = bxor(band(v73, v74), (band(bit32.bnot(v73), v75)))
            local v83 = ({
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
				3329325298
			})[v80]
            local v84 = v81 + v82
            local v85 = t4[v80]
            local v86 = (v84 + v83 + v85) % 4294967296
            local v87 = bxor(rrotate(v69, 2), rrotate(v69, 13), rrotate(v69, 22)) + bxor(band(v69, v70), band(v69, v71), (band(v70, v71)))
            local v88 = v73

            v73 = (v72 + v86) % 4294967296
            v72 = v71

            local v89 = v69

            v76 = v75
            v71 = v70
            v75 = v74
            v69 = (v86 + v87 % 4294967296) % 4294967296
            v70 = v89
            v74 = v88
        end

        for i = 1, 8 do
            t3[i] = (t3[i] + ({
				v69,
				v70,
				v71,
				v72,
				v73,
				v74,
				v75,
				v76
			})[i]) % 4294967296
        end
    end

    local t5 = {}

    for i = 1, 8 do
        t5[i] = string.format("%08x", t3[i])
    end

    local t6 = { table.concat(t5) }

    return v2(t6)
end
local request = v1.request
if not request then
    request = http_request

    if not request then
        request = syn_request

        if not request then
            request = syn and syn.request or http and http.request
        end
    end
end
local v9 = request
local HttpService = game:GetService("HttpService")
local v11 = getgenv and getgenv() or _G
local t7 = {
	Link = nil,
	LinkTime = 0,
	Host = nil,
	Identifier = nil,
	configured = function()
    local v94 = type(t1.ServiceId) == "number"

    if v94 then
        v94 = t1.ServiceId > 0
        if v94 then
            v94 = t1.ServiceId % 1 == 0

            if v94 then
                v94 = type(t1.PlatoSecret) == "string"

                if v94 then
                    v94 = t1.PlatoSecret ~= ""

                    if v94 then
                        v94 = type(t1.MainScriptURL) == "string"
                        if v94 then
                            v94 = t1.MainScriptURL:match("^https://") ~= nil
                        end
                    end
                end
            end
        end
    end

    return v94
end
}
local function v13(p3)

    if not v9 then
        error("Your executor must support HTTP requests.", 0)
    end
    local ok, result = pcall(v9, p3)
    local v101 = not ok
    if not v101 then
        v101 = type(result) ~= "table" or type(result.StatusCode) ~= "number"
    end
    if v101 then
        error("Connection failed. Try again.", 0)
    end
    if result.StatusCode == 429 then
        error("Too many requests. Wait 20 seconds and try again.", 0)
    end
    if result.StatusCode ~= 200 then
        error("The service returned HTTP " .. tostring(result.StatusCode), 0)
    end

    return result
end
function t7.host()
    if t7.Host then
        return t7.Host
    end

    local v102, v103, v104 = ipairs({
		"https://api.platoboost.com",
		"https://api.platoboost.net"
	})
    local v105

    repeat
        v104, v105 = v102(v103, v104)

        if not v104 then
            error("Platoboost is unavailable. Try again later.", 0)

            return
        end
    until pcall(v13, {
		Url = v105 .. "/public/connectivity",
		Method = "GET"
	})

    t7.Host = v105

    return v105
end
function t7.identifier()
    if t7.Identifier then
        return t7.Identifier
    end
    local v106
    if gethwid then
        local ok, result = pcall(gethwid)

        if ok then
            v106 = result
        end
    end
    if not v106 or tostring(v106) == "" then
        local ok, result = pcall(function()
            local t8 = { game:GetService("RbxAnalyticsService"):GetClientId() }

            return v2(t8)
        end)
        if ok then
            v106 = result
        end
    end
    if not v106 or tostring(v106) == "" then
        error("Cannot read a stable device identifier from this executor.", 0)
    end
    t7.Identifier = v7((tostring(v106)))

    return t7.Identifier
end
local function u15(p4)
    local ok, result = pcall(function()
        return HttpService:JSONDecode(p4.Body)
    end)
    local v115 = not ok

    if not v115 then
        v115 = type(result) ~= "table"
    end

    if v115 then
        error("Invalid response from Platoboost.", 0)
    end

    if result.success ~= true then
        error(type(result.message) == "string" and result.message or "Platoboost rejected the request.", 0)
    end

    if type(result.data) ~= "table" then
        error("Invalid response from Platoboost.", 0)
    end

    return result.data
end
function t7.getLink()
    if not t2[tostring(game.PlaceId)] then
        status.Text = "Supported: Build the Pyramid! and Break and Steal an Egg."
    elseif not t7.configured() then
        error("The owner must configure ServiceId and PlatoSecret first.", 0)
    end

    if t7.Link and os.time() - t7.LinkTime < 600 then
        return t7.Link
    end

    local v116 = u15
    local v117 = v13
    local v118 = t7.host()
    local t9 = {
		["Content-Type"] = "application/json"
	}
    local v120 = v118 .. "/public/start"
    local v121 = HttpService
    local ServiceId = t1.ServiceId
    local v123 = t7.identifier()
    local v124 = v116(v117({
		Url = v120,
		Method = "POST",
		Headers = t9,
		Body = v121:JSONEncode({
			service = ServiceId,
			identifier = v123
		})
	}))

    if type(v124.url) ~= "string" or not v124.url:match("^https://") then
        error("Platoboost did not return a valid key link.", 0)
    end

    t7.Link = v124.url
    t7.LinkTime = os.time()

    return t7.Link
end
local function v16(p5, p6)
    local valid = p5.valid

    if valid ~= true then
    end

    if valid ~= true then
        return false
    end

    if type(p5.hash) ~= "string" or p5.hash:lower() ~= v7("true-" .. p6 .. "-" .. t1.PlatoSecret) then
        error("Response verification failed. Check the service secret.", 0)
    end

    return true
end
function t7.check(p7)
    if not t2[tostring(game.PlaceId)] then
        status.Text = "Supported: Build the Pyramid! and Break and Steal an Egg."
    elseif not t7.configured() then
        error("The owner must configure ServiceId and PlatoSecret first.", 0)
    end

    local v129 = type(p7) ~= "string"

    if not v129 then
        v129 = #p7 < 1 or #p7 > 256
    end

    if v129 then
        error("Enter a valid key.", 0)
    end

    local v130 = HttpService:GenerateGUID(false):gsub("-", "")
    local v131 = u15(v13({
		Url = t7.host() .. "/public/whitelist/" .. tostring(t1.ServiceId) .. "?identifier=" .. HttpService:UrlEncode(t7.identifier()) .. "&key=" .. HttpService:UrlEncode(p7) .. "&nonce=" .. HttpService:UrlEncode(v130),
		Method = "GET"
	}))

    if v16(v131, v130) then
        return true
    end

    if p7:sub(1, 4) == "KEY_" then
        local v132 = HttpService:GenerateGUID(false):gsub("-", "")
        local v133 = u15
        local v134 = v13
        local v135 = t7.host() .. "/public/redeem/" .. tostring(t1.ServiceId)
        local t10 = {
			["Content-Type"] = "application/json"
		}
        local json = HttpService:JSONEncode({
			identifier = t7.identifier(),
			key = p7,
			nonce = v132
		})
        local v138 = v133(v2({ v134({
			Url = v135,
			Method = "POST",
			Headers = t10,
			Body = json
		}) }))

        if v16(v138, v132) then
            return true
        end
    end

    error("Key is invalid or expired. Use Get Key to obtain a new key.", 0)
end
function t7.loadMain()
    local v139 = v6()
    local v140 = v13
    local URL = v139.URL
    local v142, v143 = loadstring(v140({
		Url = URL,
		Method = "GET"
	}).Body)

    if not v142 then
        error(v143 or "Cannot compile the main script.", 0)
    end

    local v144 = v11
    local Access = v139.Access
    local GateTag = t1.GateTag
    local elapsed = os.clock()
    local PlaceId = game.PlaceId

    v144[Access] = {
		Tag = GateTag,
		Until = elapsed + 30,
		PlaceId = PlaceId
	}

    local ok, result = pcall(v142)

    v11[v139.Access] = nil

    if not ok then
        error(result, 0)
    end

    local _ = WjvSpPjLwMYF
end
local LocalPlayer = game:GetService("Players").LocalPlayer
local v18 = gethui and gethui()
if not v18 then
    v18 = LocalPlayer:WaitForChild("PlayerGui")
end
local PanoraKeyGate = v18:FindFirstChild("PanoraKeyGate")
if not PanoraKeyGate then
    PanoraKeyGate = v18:FindFirstChild("PyramidKeyGate")
end
if PanoraKeyGate then
    PanoraKeyGate:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PanoraKeyGate"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10000
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = v18
local function v23(p8, p9, p10)
    local v155 = Instance.new(p8)
    for v158, v159 in pairs(p9) do

        v155[v158] = v159
    end
    v155.Parent = p10

    return v155
end
local function v24(p11, p12)
    v23("UICorner", {
		CornerRadius = UDim.new(0, p12)
	}, p11)
end
local v25 = v23("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(0.9, 0, 0, 308),
	BackgroundColor3 = Color3.fromRGB(26, 34, 41),
	BorderSizePixel = 0
}, ScreenGui)
v23("UISizeConstraint", {
	MaxSize = Vector2.new(440, 308),
	MinSize = Vector2.new(260, 308)
}, v25)
v24(v25, 14)
local function v26(p13, p14, p15, p16, p17)
    local v167 = v23
    local uDim2 = UDim2.fromOffset(22, p14)
    local uDim2_2 = UDim2.new(1, -44, 0, p15)
    if not p16 then
        p16 = Color3.fromRGB(233, 241, 243)
    end
    local Gotham = Enum.Font.Gotham
    local Left = Enum.TextXAlignment.Left
    local t11 = { v167("TextLabel", {
		Text = p13,
		Position = uDim2,
		Size = uDim2_2,
		BackgroundTransparency = 1,
		TextColor3 = p16,
		TextSize = p17 or 14,
		Font = Gotham,
		TextWrapped = true,
		TextXAlignment = Left
	}, v25) }

    return v2(t11)
end
v26("PANORA HUB", 15, 32, nil, 20).Font = Enum.Font.GothamBold
v26((t2[tostring(game.PlaceId)] and t2[tostring(game.PlaceId)].Name or "Unsupported game") .. " | Platoboost key", 51, 34, Color3.fromRGB(158, 176, 187), 12)
local v27 = v23("TextBox", {
	Position = UDim2.fromOffset(22, 100),
	Size = UDim2.new(1, -44, 0, 44),
	Text = "",
	PlaceholderText = "Paste your key here",
	ClearTextOnFocus = false,
	BackgroundColor3 = Color3.fromRGB(16, 24, 30),
	TextColor3 = Color3.fromRGB(216, 244, 230),
	PlaceholderColor3 = Color3.fromRGB(141, 159, 171),
	Font = Enum.Font.Code,
	TextSize = 13,
	BorderSizePixel = 0
}, v25)
v24(v27, 8)
local v28 = v26("Ready", 215, 54, Color3.fromRGB(158, 176, 187), 12)
local function v29(p18, p19, p20)
    local v177 = v23("TextButton", {
		Position = UDim2.new(p19, p19 ~= 0 and 5 or 22, 0, 162),
		Size = UDim2.new(0.5, -27, 0, 40),
		Text = p18,
		BackgroundColor3 = Color3.fromRGB(154, 230, 196),
		TextColor3 = Color3.fromRGB(17, 38, 30),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		BorderSizePixel = 0
	}, v25)

    v24(v177, 8)
    v177.Activated:Connect(p20)

    return v177
end
local v30 = "BuildThePyramid" .. "/platoboost-key-" .. tostring(t1.ServiceId) .. ".txt"
local _readfile = readfile
if _readfile then
    _readfile = writefile and (isfile and (makefolder and isfolder))
end
local v32 = _readfile
if v32 then
    pcall(function()
        if not isfolder("BuildThePyramid") then
            makefolder("BuildThePyramid")
        end

        if isfile(v30) then
            v27.Text = readfile(v30)
        end
    end)
end
local u33 = false
local u34 = false
local function u36(p21, p22)
    if u33 or (u34 or not ScreenGui.Parent) then
        return
    end

    u33 = true
    v28.Text = p21
    task.spawn(function()
        local ok, result = pcall(p22)
        local v189 = not ok

        if v189 then
            v189 = ScreenGui.Parent
        end

        if v189 then
            v28.Text = tostring(result)
        end

        u33 = false
    end)
end
v29("Get Key", 0, function()
    u36("Creating your key link...", function()
        v6()
        local v184 = t7.getLink()
        if not ScreenGui.Parent then
            return
        end
        local v185 = setclipboard or toclipboard
        if v185 then
            v28.Text = pcall(v185, v184) and "Key link copied. Open it in your browser." or v184
        else
            v28.Text = v184
        end
    end)
end)
local u37
function u37()
    local v180 = v27.Text:match("^%s*(.-)%s*$")

    v6()
    t7.check(v180)

    if not ScreenGui.Parent then

        return
    end

    v28.Text = "Key accepted. Loading hub..."
    t7.loadMain()
    u34 = true

    if v32 then
        pcall(writefile, v30, v180)
    end

    ScreenGui:Destroy()
end
v29("Check Key", 0.5, function()
    u36("Checking key...", u37)
end)
if not t2[tostring(game.PlaceId)] then
    v28.Text = "Supported: Build the Pyramid! and Break and Steal an Egg."
elseif not t7.configured() then
    v28.Text = "Setup required: configure your Platoboost Service ID and service secret."
elseif v27.Text ~= "" then
    u36("Checking saved key...", u37)
end
v23("TextButton", {
	Text = "Close",
	Position = UDim2.new(1, -76, 0, 279),
	Size = UDim2.fromOffset(54, 20),
	BackgroundTransparency = 1,
	TextColor3 = Color3.fromRGB(158, 176, 187),
	Font = Enum.Font.Gotham,
	TextSize = 11
}, v25).Activated:Connect(function()
    ScreenGui:Destroy()
end)
