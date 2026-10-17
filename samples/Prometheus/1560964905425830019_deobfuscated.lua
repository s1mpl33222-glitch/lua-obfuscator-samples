-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local v4 = unpack or table.unpack
t2.value1 = {
	ServiceId = 34205,
	PlatoSecret = "58d7e2b0-1329-4dd2-b1aa-fa11b8475ae1",
	MainScriptURL = "https://raw.githubusercontent.com/CAVALEIROHAHA/ISUSYEDMAE-CODE/refs/heads/main/BuildThePyramid.obfuscated.luau",
	GateTag = "huakuyyedmae"
}
local MainScriptURL = t2.value1.MainScriptURL
t2.value2 = {
	["107778070777162"] = {
		Name = "Steal An Egg",
		URL = "https://raw.githubusercontent.com/CAVALEIROHAHA/ISUSYEDMAE-CODE/refs/heads/main/Panora.StealAnEgg.keyed.luau",
		Access = "PanoraEggAccess"
	},
	["123720558354386"] = {
		Name = "Build the Pyramid!",
		URL = MainScriptURL,
		Access = "PyramidAccess"
	},
	["114326934417838"] = {
		Name = "Break and Steal an Egg",
		URL = "https://raw.githubusercontent.com/CAVALEIROHAHA/ISUSYEDMAE-CODE/refs/heads/main/PanoraHub.keyed.luau",
		Access = "PanoraAccess"
	}
}
local function v6()
    local v34 = t2.value2[tostring(game.PlaceId)]

    if not v34 then
        error("PANORA HUB does not support this game.", 0)
    end

    return v34
end
local function v7(p1)
    local bxor = bit32.bxor
    local band = bit32.band
    local rshift = bit32.rshift
    local rrotate = bit32.rrotate

    local function v40(p2)
        return (string.char(band(rshift(p2, 24), 255), band(rshift(p2, 16), 255), band(rshift(p2, 8), 255), (band(p2, 255))))
    end

    local v41 = #p1
    local v42 = p1 .. "\128" .. string.rep("\000", (55 - v41) % 64) .. v40((math.floor(v41 / 536870912))) .. v40(v41 * 8 % 4294967296)
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
    local v44 = #v42
    local n1 = 64
    local v46 = n1 < 0
    local v47 = 1 - n1

    while true do
        v47 = n1 + v47

        local v48 = v47 <= v44

        if (not v46 or not (v44 <= v47)) and (v46 or not v48) then
            break
        end

        local t4 = table.create(64)
        local n2 = 16
        local v51 = false
        local n3 = 0

        while true do
            n3 = 1 + n3

            if (not v51 or not (n2 <= n3)) and (v51 or not (n3 <= n2)) then
                break
            end

            local v53, v54, v55, v56 = string.byte(v42, v47 + (n3 - 1) * 4, v47 + (n3 - 1) * 4 + 3)

            t4[n3] = ((v53 * 256 + v54) * 256 + v55) * 256 + v56
        end

        for i = 17, 64 do
            local v58 = t4[i - 15]
            local v59 = t4[i - 2]
            local v60 = t4[i - 16]
            local v61 = bxor(rrotate(v58, 7), rrotate(v58, 18), (rshift(v58, 3)))
            local v62 = t4[i - 7]

            t4[i] = (v60 + v61 + v62 + bxor(rrotate(v59, 17), rrotate(v59, 19), (rshift(v59, 10)))) % 4294967296
        end

        local v63, v64, v65, v66, v67, v68, v69, v70 = table.unpack(t3)
        local n4 = 64
        local v72 = false
        local n5 = 0

        while true do
            n5 = 1 + n5

            local v74 = n5 <= n4

            if (not v72 or not (n4 <= n5)) and (v72 or not v74) then
                break
            end

            local v75 = v70 + bxor(rrotate(v67, 6), rrotate(v67, 11), (rrotate(v67, 25)))
            local v76 = bxor(band(v67, v68), (band(bit32.bnot(v67), v69)))
            local v77 = ({
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
			})[n5]
            local v78 = t4[n5]
            local v79 = (v75 + v76 + v77 + v78) % 4294967296
            local v80 = v79 + (bxor(rrotate(v63, 2), rrotate(v63, 13), (rrotate(v63, 22))) + bxor(band(v63, v64), band(v63, v65), (band(v64, v65)))) % 4294967296

            v70 = v69
            v69 = v68
            v68 = v67
            v67 = (v66 + v79) % 4294967296
            v66 = v65
            v65 = v64
            v64 = v63
            v63 = v80 % 4294967296
        end

        for i = 1, 8 do
            t3[i] = (t3[i] + ({
				v63,
				v64,
				v65,
				v66,
				v67,
				v68,
				v69,
				v70
			})[i]) % 4294967296
        end
    end

    local t5 = {}

    for i = 1, 8 do
        t5[i] = string.format("%08x", t3[i])
    end

    local t6 = { table.concat(t5) }

    return v4(t6)
end
local _request = request
if not _request then
    t1.value1 = http_request
    t1.value2 = t1.value1

    if not t1.value1 then
        t1.value3 = syn_request
        t1.value4 = t1.value3

        if not t1.value3 then
            t1.value4 = syn and syn.request or http and http.request
        end

        t1.value2 = t1.value4
    end

    _request = t1.value2
end
t2.value3 = _request
t2.value4 = game:GetService("HttpService")
t2.value5 = getgenv and getgenv() or _G
t2.value6 = nil
t2.value7 = false
t2.value8 = {
	Link = nil,
	LinkTime = 0,
	Host = nil,
	Identifier = nil
}
function t2.value8.configured()
    local v85 = type(t2.value1.ServiceId) == "number"

    if v85 then
        v85 = t2.value1.ServiceId > 0

        if v85 then
            v85 = t2.value1.ServiceId % 1 == 0

            if v85 then
                v85 = type(t2.value1.PlatoSecret) == "string"

                if v85 then
                    v85 = t2.value1.PlatoSecret ~= ""

                    if v85 then
                        v85 = type(t2.value1.MainScriptURL) == "string" and t2.value1.MainScriptURL:match("^https://") ~= nil
                    end
                end
            end
        end
    end

    return v85
end
local function v9(p3, p4, p5)
    if t2.value7 then
        error("Loader closed.", 0)
    end
    local u89 = false
    local u90
    local thread = task.spawn(function()
        u90 = table.pack(pcall(p5))
        u89 = true
    end)
    local v92 = os.clock() + p3
    while not u89 and (not t2.value7 and v92 > os.clock()) do
        task.wait(0.05)
    end
    if not u89 or t2.value7 then
        pcall(task.cancel, thread)
        error(if not t2.value7 then p4 .. " timed out. Close and retry the loader." else "Loader closed.", 0)
    end
    if not u90[1] then
        error(u90[2], 0)
    end

    return table.unpack(u90, 2, u90.n)
end
local function v10(p6)
    if not t2.value3 then
        error("Your executor must support HTTP requests.", 0)
    end

    local ok, result = pcall(function()
        return v9(20, "HTTP request", function()
            local t7 = { t2.value3(p6) }

            return v4(t7)
        end)
    end)

    if not ok or (type(result) ~= "table" or type(result.StatusCode) ~= "number") then
        error(not ok and tostring(result) or "Connection failed. Try again.", 0)
    end

    if result.StatusCode == 429 then
        error("Too many requests. Wait 20 seconds and try again.", 0)
    end

    if result.StatusCode ~= 200 then
        error("The service returned HTTP " .. tostring(result.StatusCode), 0)
    end

    return result
end
function t2.value8.host()
    if t2.value8.Host then
        return t2.value8.Host
    end

    local v96, v97, v98 = ipairs({
		"https://api.platoboost.com",
		"https://api.platoboost.net"
	})
    local v99

    repeat
        v98, v99 = v96(v97, v98)

        if not v98 then
            error("Platoboost is unavailable. Try again later.", 0)

            return
        end
    until pcall(v10, {
		Url = v99 .. "/public/connectivity",
		Method = "GET"
	})

    t2.value8.Host = v99

    return v99
end
function t2.value8.identifier()
    if t2.value8.Identifier then
        return t2.value8.Identifier
    end
    local v100
    if gethwid then
        local ok, result = pcall(gethwid)

        if ok then
            v100 = result
        end
    end
    if not v100 or tostring(v100) == "" then
        local ok, result = pcall(function()
            return game:GetService("RbxAnalyticsService"):GetClientId()
        end)

        if ok then
            v100 = result
        end
    end
    if not v100 or tostring(v100) == "" then
        error("Cannot read a stable device identifier from this executor.", 0)
    end
    t2.value8.Identifier = v7((tostring(v100)))

    return t2.value8.Identifier
end
local function v11(p7)
    local ok, result = pcall(function()
        return t2.value4:JSONDecode(p7.Body)
    end)
    local v108 = not ok

    if not v108 then
        v108 = type(result) ~= "table"
    end

    if v108 then
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
function t2.value8.getLink()
    v6()

    if not t2.value8.configured() then
        error("The owner must configure ServiceId and PlatoSecret first.", 0)
    end

    if t2.value8.Link and os.time() - t2.value8.LinkTime < 600 then
        return t2.value8.Link
    end

    local v109 = v11
    local v110 = v10
    local v111 = t2.value8.host() .. "/public/start"
    local t8 = {
		["Content-Type"] = "application/json"
	}
    local value4 = t2.value4
    local ServiceId = t2.value1.ServiceId
    local v115 = t2.value8.identifier()
    local v116 = v109(v110({
		Url = v111,
		Method = "POST",
		Headers = t8,
		Body = value4:JSONEncode({
			service = ServiceId,
			identifier = v115
		})
	}))

    if type(v116.url) ~= "string" or not v116.url:match("^https://") then
        error("Platoboost did not return a valid key link.", 0)
    end

    local url = v116.url

    t2.value8.Link = url
    t2.value8.LinkTime = os.time()

    return t2.value8.Link
end
local function v12(p8, p9)
    if p8.valid ~= true then
        return false
    end

    if type(p8.hash) ~= "string" or p8.hash:lower() ~= v7("true-" .. p9 .. "-" .. t2.value1.PlatoSecret) then
        error("Response verification failed. Check the service secret.", 0)
    end

    return true
end
function t2.value8.check(p10)
    v6()

    if not t2.value8.configured() then
        error("The owner must configure ServiceId and PlatoSecret first.", 0)
    end

    if type(p10) ~= "string" or (#p10 < 1 or #p10 > 256) then
        error("Enter a valid key.", 0)
    end

    local v121 = t2.value4:GenerateGUID(false):gsub("-", "")
    local v122 = v11
    local v123 = v10
    local v124 = t2.value8.host()
    local str = tostring(t2.value1.ServiceId)
    local value4 = t2.value4
    local t9 = { t2.value8.identifier() }
    local v128 = value4:UrlEncode(v4(t9))
    local v129 = t2.value4:UrlEncode(p10) .. "&nonce=" .. t2.value4:UrlEncode(v121)

    if v12(v122(v123({
		Url = v124 .. "/public/whitelist/" .. str .. "?identifier=" .. v128 .. "&key=" .. v129,
		Method = "GET"
	})), v121) then
        return true
    end

    if p10:sub(1, 4) == "KEY_" then
        local v130 = t2.value4:GenerateGUID(false):gsub("-", "")
        local v131 = v11
        local v132 = v10
        local v133 = t2.value8.host() .. "/public/redeem/" .. tostring(t2.value1.ServiceId)
        local t10 = {
			["Content-Type"] = "application/json"
		}
        local value4_2 = t2.value4
        local v136 = t2.value8.identifier()

        if v12(v131(v132({
			Url = v133,
			Method = "POST",
			Headers = t10,
			Body = value4_2:JSONEncode({
				identifier = v136,
				key = p10,
				nonce = v130
			})
		})), v130) then
            return true
        end
    end

    error("Key is invalid or expired. Use Get Key to obtain a new key.", 0)
end
function t2.value8.loadMain(p11)
    local v138 = v6()
    local value6 = t2.value6

    t2.value6 = nil

    local v140 = type(value6) ~= "table"

    if not v140 then
        v140 = value6.PlaceId ~= game.PlaceId or value6.Until < os.clock()
    end

    if v140 then
        error("Verify your key before loading.", 0)
    end

    if p11 then
        p11("Downloading " .. v138.Name .. "...")
    end

    local v141 = v10({
		Url = v138.URL,
		Method = "GET",
		Timeout = 20
	})

    if t2.value7 then
        error("Loader closed before download completed.", 0)
    end

    if type(v141.Body) ~= "string" or v141.Body == "" then
        error("GitHub returned an empty script.", 0)
    end

    if p11 then
        p11("Compiling " .. v138.Name .. "...")
    end

    local v142, v143 = loadstring(v141.Body)
    local v144 = v142

    if not v144 then
        error(v143 or "Cannot compile the main script.", 0)
    end

    if t2.value7 then
        error("Loader closed before startup.", 0)
    end

    local value5 = t2.value5
    local Access = v138.Access
    local GateTag = t2.value1.GateTag
    local elapsed = os.clock()
    local PlaceId = game.PlaceId

    value5[Access] = {
		Tag = GateTag,
		Until = elapsed + 30,
		PlaceId = PlaceId
	}

    if p11 then
        p11("Starting " .. v138.Name .. "... (up to 45s)")
    end

    local ok, result = pcall(function()
        return v9(45, "Hub startup", v144)
    end)
    local Access2 = v138.Access

    t2.value5[Access2] = nil

    if not ok then
        error(result, 0)
    end
end
local v13 = gethui and gethui() or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local v14 = v13:FindFirstChild("PanoraKeyGate") or v13:FindFirstChild("PyramidKeyGate")
if v14 then
    v14:Destroy()
end
local function v15(p12, p13, p14)
    local v156 = Instance.new(p12)
    for v159, v160 in pairs(p13) do

        v156[v159] = v160
    end
    v156.Parent = p14

    return v156
end
function t2.value9(p15, p16)
    v15("UICorner", {
		CornerRadius = UDim.new(0, p16)
	}, p15)
end
local color3 = Color3.fromRGB(12, 22, 19)
local color3_2 = Color3.fromRGB(23, 36, 30)
local color3_3 = Color3.fromRGB(110, 231, 183)
local color3_4 = Color3.fromRGB(232, 247, 239)
local color3_5 = Color3.fromRGB(148, 174, 158)
local color3_6 = Color3.fromRGB(255, 155, 145)
t2.value10 = {
	Background = color3,
	Input = color3_2,
	Accent = color3_3,
	Text = color3_4,
	Muted = color3_5,
	Error = color3_6
}
t2.value11 = v15("ScreenGui", {
	Name = "PanoraKeyGate",
	ResetOnSpawn = false,
	DisplayOrder = 10000,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, v13)
t2.value12 = v15("Frame", {
	Name = "KeyCard",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(0.9, 0, 0, 282),
	BackgroundColor3 = t2.value10.Background,
	BorderSizePixel = 0,
	Active = true
}, t2.value11)
v15("UISizeConstraint", {
	MaxSize = Vector2.new(380, 282),
	MinSize = Vector2.new(240, 282)
}, t2.value12)
t2.value9(t2.value12, 13)
v15("UIStroke", {
	Color = Color3.fromRGB(49, 82, 62),
	Transparency = 0.3,
	Thickness = 1
}, t2.value12)
local function v22(p17, p18, p19, p20, p21)
    local v168 = v15
    local uDim2 = UDim2.fromOffset(20, p18)
    local uDim2_2 = UDim2.new(1, -40, 0, p19)

    if not p20 then
        p20 = t2.value10.Text
    end

    local Gotham = Enum.Font.Gotham
    local Left = Enum.TextXAlignment.Left
    local t11 = { v168("TextLabel", {
		Text = p17,
		Position = uDim2,
		Size = uDim2_2,
		BackgroundTransparency = 1,
		TextColor3 = p20,
		Font = Gotham,
		TextSize = p21 or 12,
		TextWrapped = true,
		TextXAlignment = Left
	}, t2.value12) }

    return v4(t11)
end
v22("PANORA", 17, 24, nil, 18).Font = Enum.Font.GothamBold
local v23 = v15("Frame", {
	Position = UDim2.fromOffset(112, 25),
	Size = UDim2.fromOffset(7, 7),
	BackgroundColor3 = t2.value10.Accent,
	BorderSizePixel = 0
}, t2.value12)
t2.value9(v23, 7)
local v24 = t2.value2[tostring(game.PlaceId)] and t2.value2[tostring(game.PlaceId)].Name
local Muted = t2.value10.Muted
v22(v24 or "Unsupported game", 42, 20, Muted, 11)
v15("Frame", {
	Position = UDim2.fromOffset(20, 73),
	Size = UDim2.new(1, -40, 0, 1),
	BackgroundColor3 = Color3.fromRGB(43, 61, 50),
	BorderSizePixel = 0
}, t2.value12)
t2.value13 = v22("Enter your key to unlock PANORA.", 84, 30, t2.value10.Muted, 12)
t2.value14 = v15("TextBox", {
	Name = "KeyInput",
	Position = UDim2.fromOffset(20, 121),
	Size = UDim2.new(1, -40, 0, 38),
	Text = "",
	PlaceholderText = "Paste your access key",
	ClearTextOnFocus = false,
	BackgroundColor3 = t2.value10.Input,
	TextColor3 = t2.value10.Text,
	PlaceholderColor3 = t2.value10.Muted,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	BorderSizePixel = 0,
	TextXAlignment = Enum.TextXAlignment.Left
}, t2.value12)
t2.value9(t2.value14, 7)
v15("UIPadding", {
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12)
}, t2.value14)
t2.value15 = {}
local function v26(p22, p23, p24, p25, p26)
    local v179 = v15
    local uDim2 = UDim2.new(p23, p23 ~= 0 and 4 or 20, p24, 0)
    local v181 = p26 and t2.value10.Accent or t2.value10.Input
    local v182 = p26 and t2.value10.Background or t2.value10.Text
    local v183 = v179("TextButton", {
		Text = p22,
		Position = uDim2,
		Size = p25,
		BackgroundColor3 = v181,
		TextColor3 = v182,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		BorderSizePixel = 0,
		AutoButtonColor = true
	}, t2.value12)

    t2.value9(v183, 7)
    t2.value15[#t2.value15 + 1] = v183

    return v183
end
t2.value16 = v26("Check key", 0, 0, UDim2.new(1, -40, 0, 36), true)
t2.value16.Position = UDim2.fromOffset(20, 170)
local v27 = v26("Get key", 0, 0, UDim2.new(0.5, -24, 0, 32))
v27.Position = UDim2.fromOffset(20, 214)
local v28 = v26("Clear key", 0.5, 0, UDim2.new(0.5, -24, 0, 32))
v28.Position = UDim2.new(0.5, 4, 0, 214)
v22("Your key is saved after verification and checked each launch.", 252, 19, t2.value10.Muted, 9)
local v29 = v15("TextButton", {
	Text = "×",
	Position = UDim2.new(1, -41, 0, 13),
	Size = UDim2.fromOffset(26, 26),
	BackgroundTransparency = 1,
	TextColor3 = t2.value10.Muted,
	Font = Enum.Font.Gotham,
	TextSize = 21
}, t2.value12)
t2.value17 = "BuildThePyramid"
t2.value18 = "BuildThePyramid" .. "/platoboost-key-" .. tostring(t2.value1.ServiceId) .. ".txt"
local _readfile = readfile
if _readfile then
    t1.value5 = writefile
    _readfile = t1.value5

    if t1.value5 then
        t1.value6 = isfile
        t1.value7 = t1.value6

        if t1.value6 then
            t1.value7 = makefolder and isfolder
        end

        _readfile = t1.value7
    end
end
t2.value19 = _readfile
if t2.value19 then
    pcall(function()
        if not isfolder(t2.value17) then
            makefolder(t2.value17)
        end

        if isfile(t2.value18) then
            t2.value14.Text = readfile(t2.value18)
        end
    end)
end
t2.value20 = false
t2.value21 = false
local function v31(p27, p28)
    local value20 = t2.value20
    if not value20 then
        value20 = t2.value21 or not t2.value11.Parent
    end
    if value20 then

        return
    end
    t2.value20 = true
    t2.value13.Text = p27
    local Muted2 = t2.value10.Muted
    t2.value13.TextColor3 = Muted2
    for v191, v192 in ipairs(t2.value15) do

        v192.Active = false
        v192.AutoButtonColor = false
        v192.TextTransparency = 0.3
    end
    t2.value16.Text = "Please wait..."
    task.spawn(function()
        local ok, result = pcall(p28)
        local v218 = not ok

        if v218 then
            v218 = t2.value11.Parent
        end

        if v218 then
            t2.value13.Text = tostring(result)
            t2.value13.TextColor3 = t2.value10.Error
        end

        t2.value20 = false

        if t2.value11.Parent then
            t2.value16.Text = "Check key"
            for v221, v222 in ipairs(t2.value15) do

                v222.Active = true
                v222.AutoButtonColor = true
                v222.TextTransparency = 0
            end
        end
    end)
end
v27.Activated:Connect(function()
    v31("Creating your key link...", function()
        local v223 = t2.value8.getLink()

        if not t2.value11.Parent then

            return
        end

        local v225 = setclipboard or toclipboard

        if v225 then
            v225 = pcall(v225, v223)
        end

        t2.value13.Text = v225 and "Link copied. Open it in your browser to get a key."
    end)
end)
local function v32()
    local v193 = t2.value14.Text:match("^%s*(.-)%s*$")

    v6()

    if t2.value8.check(v193) ~= true then
        error("Key verification failed.", 0)
    end

    if not t2.value11.Parent then
        return
    end

    local elapsed = os.clock()
    local PlaceId = game.PlaceId

    t2.value6 = {
		Key = v193,
		Until = elapsed + 30,
		PlaceId = PlaceId
	}
    t2.value13.Text = "Key verified. Loading PANORA..."
    t2.value8.loadMain(function(p29)
        if t2.value11.Parent then
            t2.value13.Text = p29
        end
    end)
    t2.value21 = true

    if t2.value19 then
        pcall(writefile, t2.value18, v193)
    end

    t2.value11:Destroy()
end
t2.value16.Activated:Connect(function()
    v31("Checking your key...", v32)
end)
t2.value14.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        v31("Checking your key...", v32)
    end
end)
v28.Activated:Connect(function()
    if t2.value20 then

        return
    end

    t2.value14.Text = ""
    t2.value13.Text = "Enter a new key."
    t2.value13.TextColor3 = t2.value10.Muted

    if type(delfile) == "function" and (type(isfile) == "function" and isfile(t2.value18)) then
        pcall(delfile, t2.value18)
    end
end)
t2.value22 = {}
v29.Activated:Connect(function()
    t2.value7 = true
    t2.value6 = nil
    t2.value11:Destroy()
end)
local UserInputService = game:GetService("UserInputService")
t2.value23 = nil
t2.value24 = nil
t2.value25 = nil
t2.value22[#t2.value22 + 1] = t2.value12.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local v201 = input.Position.Y - t2.value12.AbsolutePosition.Y

        if v201 > 73 then
        end

        if v201 > 73 then
            return
        end

        t2.value23 = input
        t2.value24 = input.Position
        t2.value25 = t2.value12.Position
    end
end)
t2.value22[#t2.value22 + 1] = UserInputService.InputChanged:Connect(function(input)
    if not t2.value23 then
        local _ = HhwtdHFcaKOhtJ

        return
    end

    local v204 = input ~= t2.value23

    if v204 then
        v204 = t2.value23.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
    end

    if v204 then
        return
    end

    local v205 = input.Position - t2.value24
    local CurrentCamera = workspace.CurrentCamera
    local v207 = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local v208 = t2.value12.AbsoluteSize / 2
    local v209 = t2.value12.AbsolutePosition + v208 + Vector2.new(v205.X, v205.Y)

    t2.value12.Position = UDim2.fromOffset(math.clamp(v209.X, v208.X, v207.X - v208.X), (math.clamp(v209.Y, v208.Y, v207.Y - v208.Y)))
    t2.value24 = input.Position
end)
t2.value22[#t2.value22 + 1] = UserInputService.InputEnded:Connect(function(input)
    if input == t2.value23 then
        t2.value23 = nil
    end
end)
t2.value11.Destroying:Connect(function()
    t2.value7 = true
    t2.value6 = nil
    for v213, v214 in ipairs(t2.value22) do

        v214:Disconnect()
    end
end)
if not t2.value2[tostring(game.PlaceId)] then
    t2.value13.Text = "This game is not supported by PANORA."

    return
end
t1.value8 = not t2.value8.configured()
if t1.value8 then
    t2.value13.Text = "Key service is not configured."

    return
end
t1.value9 = t2.value14.Text ~= ""
if t1.value9 then
    v31("Checking your saved key...", v32)
end
