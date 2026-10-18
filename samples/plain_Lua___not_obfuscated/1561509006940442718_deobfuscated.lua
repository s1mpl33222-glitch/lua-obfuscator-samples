-- This file was generated at discord.gg/syncrypt

local t1 = {}
local env = getfenv and getfenv() or _ENV
local unpack_ = unpack or table.unpack
local t2 = {
	value1 = {
		["ServiceId"] = 34205,
		["PlatoSecret"] = "58d7e2b0-1329-4dd2-b1aa-fa11b8475ae1",
		["MainScriptURL"] = "https://raw.githubusercontent.com/CAVALEIROHAHA/ISUSYEDMAE-CODE/refs/heads/main/BuildThePyramid.obfuscated.luau",
		["GateTag"] = "huakuyyedmae"
	}
}
t2.value2 = {
	["107778070777162"] = {
		["Name"] = "Steal An Egg",
		["URL"] = "https://raw.githubusercontent.com/CAVALEIROHAHA/ISUSYEDMAE-CODE/refs/heads/main/Panora.StealAnEgg.keyed.luau",
		["Access"] = "PanoraEggAccess"
	},
	["123720558354386"] = {
		["Name"] = "Build the Pyramid!",
		["URL"] = t2.value1.MainScriptURL,
		["Access"] = "PyramidAccess"
	},
	["114326934417838"] = {
		["Name"] = "Break and Steal an Egg",
		["URL"] = "https://raw.githubusercontent.com/CAVALEIROHAHA/ISUSYEDMAE-CODE/refs/heads/main/PanoraHub.keyed.luau",
		["Access"] = "PanoraAccess"
	}
}
local function v5()
    local value2 = t2.value2
    local PlaceId = game.PlaceId

    value2 = value2[tostring(PlaceId)]

    if value2 then
        return value2
    end

    error("PANORA HUB does not support this game.", 0)

    return value2
end
local function v8(p1)
    local bxor = bit32.bxor
    local band = bit32.band
    local rshift = bit32.rshift
    local rrotate = bit32.rrotate

    local function v13(p2)
        return string.char(band(rshift(p2, 24), 255), band(rshift(p2, 16), 255), band(rshift(p2, 8), 255), (band(p2, 255)))
    end

    local v14 = #p1
    local v15 = string.rep("\0", (55 - v14) % 64)
    local v16 = v14 / 536870912

    v13 = p1 .. "\128" .. v15 .. v13((math.floor(v16))) .. v13(v14 * 8 % 4294967296)
    v14 = #v13
    v15 = 64
    v16 = v15 < 0

    local v17 = 1 - v15
    local t3 = {
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
	}
    local t4 = {
		1779033703,
		3144134277,
		1013904242,
		2773480762,
		1359893119,
		2600822924,
		528734635,
		1541459225
	}

    while true do
        v17 = v15 + v17

        local v20 = v17 <= v14

        if not (v16 and v14 <= v17 and true or not v16 and v20) then
            rrotate = {}

            for i = 1, 8 do
                rrotate[i] = string.format("%08x", t4[i])
            end

            return unpack_({ table.concat(rrotate) })
        end

        v20 = table.create(64)

        local v22 = v17
        local n1 = 1
        local n2 = 0
        local v25 = false
        local n3 = 16

        while true do
            n2 = n1 + n2
            v29 = ((not v25 or n3 > n2) and true or false) and not v25

            if v29 then
                v29 = n2 <= n3
            end

            if not v29 then
                break
            end

            v29 = v22 + (n2 - 1) * 4
            v30 = v22 + (n2 - 1) * 4 + 3
            v29, v30, v31, v32 = string.byte(v13, v29, v30)
            v20[n2] = ((v29 * 256 + v30) * 256 + v31) * 256 + v32

            continue
        end

        for i = 17, 64 do
            n3 = v20[i - 15]
            v22 = v20[i - 2]
            v29 = v20[i - 16]
            n3 = bxor(rrotate(n3, 7), rrotate(n3, 18), (rshift(n3, 3)))
            v30 = v20[i - 7]
            v20[i] = (v29 + n3 + v30 + bxor(rrotate(v22, 17), rrotate(v22, 19), (rshift(v22, 10)))) % 4294967296
        end

        local v28, v33, v34

        n1, n2, v25, n3, v22, v28, v33, v34 = table.unpack(t4)

        local n4 = 1
        local n5 = 0
        local n6 = 64
        local v35 = false

        while true do
            n5 = n4 + n5

            local v36 = n5 <= n6

            if (not v35 or n6 > n5) and (v35 or not v36) then
                break
            end

            v34 = v34 + bxor(rrotate(v22, 6), rrotate(v22, 11), (rrotate(v22, 25)))
            v36 = bxor(band(v22, v28), (band(bit32.bnot(v22), v33)))

            local v37 = t3[n5]
            local v38 = v20[n5]

            v34 = (v34 + v36 + v37 + v38) % 4294967296
            v36 = v34 + (bxor(rrotate(n1, 2), rrotate(n1, 13), (rrotate(n1, 22))) + bxor(band(n1, n2), band(n1, v25), (band(n2, v25)))) % 4294967296
            n3 = (n3 + v34) % 4294967296
            v34 = v36 % 4294967296

            local v39 = v22

            v22 = n3
            n3 = v25
            v25 = n2
            n2 = n1
            n1 = v34
            v34 = v33
            v33 = v28
            v28 = v39
        end

        n1 = {
			n1,
			n2,
			v25,
			n3,
			v22,
			v28,
			v33,
			v34
		}

        for i = 1, 8 do
            t4[i] = (t4[i] + n1[i]) % 4294967296
        end

        continue
    end
end
local request_ = request
if not request_ then
    t1.value1 = http_request
    t1.value2 = t1.value1

    if not t1.value1 then
        t1.value3 = syn_request
        t1.value4 = t1.value3

        if not t1.value3 then
            request_ = not (syn and syn.request) and http

            if request_ then
                request_ = http.request
            end

            t1.value4 = request_
        end

        t1.value2 = t1.value4
    end

    request_ = t1.value2
end
t2.value3 = request_
t2.value4 = game:GetService("HttpService")
t2.value5 = getgenv and getgenv() or _G
t2.value6 = nil
t2.value7 = false
t2.value8 = {
	["Link"] = nil,
	["LinkTime"] = 0,
	["Host"] = nil,
	["Identifier"] = nil
}
function t2.value8.configured()
    local ServiceId = t2.value1.ServiceId

    ServiceId = type(ServiceId) == "number" and (t2.value1.ServiceId > 0 and t2.value1.ServiceId % 1 == 0)

    if not ServiceId then
        return ServiceId
    end

    ServiceId = t2.value1.PlatoSecret
    ServiceId = type(ServiceId) == "string" and t2.value1.PlatoSecret ~= ""

    if not ServiceId then
        return ServiceId
    end

    ServiceId = t2.value1.MainScriptURL

    if type(ServiceId) == "string" then
        ServiceId = t2.value1.MainScriptURL:match("^https://") ~= nil
    else
        ServiceId = false
    end

    return ServiceId
end
request_ = function(p3, p4, p5)
    if t2.value7 then
        error("Loader closed.", 0)
    end
    local u42 = false
    local u43
    local thread = task.spawn(function()
        u43 = table.pack(pcall(p5))
        u42 = true
    end)
    local v45 = os.clock() + p3
    local v46 = u43
    while true do
        local v47 = not (u42 or t2.value7)

        if v47 then
            v47 = os.clock() < v45
        end

        if not v47 then
            break
        end

        task.wait(0.05)
    end
    if not u42 or t2.value7 then
        pcall(task.cancel, thread)
        error(t2.value7 and "Loader closed." or p4 .. " timed out. Close and retry the loader.", 0)
    end
    if v46[1] then
        return table.unpack(v46, 2, v46.n)
    end
    error(v46[2], 0)

    return table.unpack(v46, 2, v46.n)
end
local function v48(p6)
    if not t2.value3 then
        error("Your executor must support HTTP requests.", 0)
    end

    local ok, result = pcall(function()
        return request_(20, "HTTP request", function()
            return unpack_({ t2.value3(p6) })
        end)
    end)
    local v51 = not ok

    if not v51 then
        if type(result) == "table" then
            v51 = result.StatusCode
            v51 = type(v51) ~= "number"
        else
            v51 = true
        end
    end

    if v51 then
        error(ok and "Connection failed. Try again." or (tostring(result) or "Connection failed. Try again."), 0)
    end

    if result.StatusCode == 429 then
        error("Too many requests. Wait 20 seconds and try again.", 0)
    end

    if result.StatusCode == 200 then
        return result
    end

    ok = error
    v51 = result.StatusCode
    ok("The service returned HTTP " .. tostring(v51), 0)

    return result
end
function t2.value8.host()
    if t2.value8.Host then
        return t2.value8.Host
    else

        for v54, v55 in ipairs({ "https://api.platoboost.com", "https://api.platoboost.net" }) do

            if pcall(v48, {
				["Url"] = v55 .. "/public/connectivity",
				["Method"] = "GET"
			}) then
                t2.value8.Host = v55

                return v55
            end
        end
        error("Platoboost is unavailable. Try again later.", 0)

        return
    end
end
function t2.value8.identifier()
    if t2.value8.Identifier then
        return t2.value8.Identifier
    end
    local ok
    local ok2, result
    if gethwid then
        ok2, result = pcall(gethwid)

        if not ok2 then
            result = ok
        end
    else
        result = ok
    end
    if not result or tostring(result) == "" then
        ok, ok2 = pcall(function()
            return game:GetService("RbxAnalyticsService"):GetClientId()
        end)

        if not ok then
            ok2 = result
        end
    else
        ok2 = result
    end
    if not (not ok2 or tostring(ok2) == "") then
        t2.value8.Identifier = v8((tostring(ok2)))

        return t2.value8.Identifier
    end
    error("Cannot read a stable device identifier from this executor.", 0)
    t2.value8.Identifier = v8((tostring(ok2)))

    return t2.value8.Identifier
end
local function v59(p7)
    local ok, result = pcall(function()
        return t2.value4:JSONDecode(p7.Body)
    end)

    if not ok or type(result) ~= "table" then
        error("Invalid response from Platoboost.", 0)
    end

    if result.success ~= true then
        ok = error

        local message = result.message

        ok(type(message) == "string" and (result.message or "Platoboost rejected the request.") or "Platoboost rejected the request.", 0)
    end

    ok = result.data

    if type(ok) == "table" then
        return result.data
    end

    error("Invalid response from Platoboost.", 0)

    return result.data
end
function t2.value8.getLink()
    v5()

    if not t2.value8.configured() then
        error("The owner must configure ServiceId and PlatoSecret first.", 0)
    end

    local Link = t2.value8.Link

    if Link then
        Link = os.time() - t2.value8.LinkTime < 600
    end

    if Link then
        return t2.value8.Link
    end

    Link = v59(v48({
		["Url"] = t2.value8.host() .. "/public/start",
		["Method"] = "POST",
		["Headers"] = {
			["Content-Type"] = "application/json"
		},
		["Body"] = t2.value4:JSONEncode({
			["service"] = t2.value1.ServiceId,
			["identifier"] = t2.value8.identifier()
		})
	}))

    local url = Link.url

    if not (type(url) ~= "string" and true or not Link.url:match("^https://")) then
        Link = Link.url
        t2.value8.Link = Link
        t2.value8.LinkTime = os.time()

        return t2.value8.Link
    end

    error("Platoboost did not return a valid key link.", 0)
    Link = Link.url
    t2.value8.Link = Link
    t2.value8.LinkTime = os.time()

    return t2.value8.Link
end
v8 = function(p8, p9)
    if p8.valid ~= true then
        return false
    end

    local hash = p8.hash

    if not (type(hash) ~= "string" and true or p8.hash:lower() ~= v8("true-" .. p9 .. "-" .. t2.value1.PlatoSecret)) then
        return true
    end

    error("Response verification failed. Check the service secret.", 0)

    return true
end
function t2.value8.check(p10)
    v5()

    if not t2.value8.configured() then
        error("The owner must configure ServiceId and PlatoSecret first.", 0)
    end

    if not ((type(p10) ~= "string" or #p10 < 1) and true or #p10 > 256) then
        v76 = t2.value4:GenerateGUID(false):gsub("-", "")
        v77 = v59
        v78 = v48
        v79 = t2.value8.host()
        v80 = t2.value1.ServiceId

        if v8(v77(v78({
			["Url"] = v79 .. "/public/whitelist/" .. tostring(v80) .. "?identifier=" .. t2.value4:UrlEncode(unpack_({ t2.value8.identifier() })) .. "&key=" .. t2.value4:UrlEncode(p10) .. "&nonce=" .. t2.value4:UrlEncode(v76),
			["Method"] = "GET"
		})), v76) then
            return true
        else
            if p10:sub(1, 4) == "KEY_" then
                v76 = t2.value4:GenerateGUID(false):gsub("-", "")
                v77 = v59
                v78 = v48
                v79 = t2.value8.host()
                v80 = t2.value1.ServiceId

                if v8(v77(v78({
					["Url"] = v79 .. "/public/redeem/" .. tostring(v80),
					["Method"] = "POST",
					["Headers"] = {
						["Content-Type"] = "application/json"
					},
					["Body"] = t2.value4:JSONEncode({
						["identifier"] = t2.value8.identifier(),
						["key"] = p10,
						["nonce"] = v76
					})
				})), v76) then
                    return true
                else
                    error("Key is invalid or expired. Use Get Key to obtain a new key.", 0)

                    return
                end

                return
            else
                error("Key is invalid or expired. Use Get Key to obtain a new key.", 0)

                return
            end

            return
        end

        return
    end

    error("Enter a valid key.", 0)

    local v66 = t2.value4:GenerateGUID(false):gsub("-", "")
    local v67 = v59
    local v68 = v48
    local v69 = t2.value8.host()
    local ServiceId = t2.value1.ServiceId

    if v8(v67(v68({
		["Url"] = v69 .. "/public/whitelist/" .. tostring(ServiceId) .. "?identifier=" .. t2.value4:UrlEncode(unpack_({ t2.value8.identifier() })) .. "&key=" .. t2.value4:UrlEncode(p10) .. "&nonce=" .. t2.value4:UrlEncode(v66),
		["Method"] = "GET"
	})), v66) then
        return true
    else
        if p10:sub(1, 4) == "KEY_" then
            v66 = t2.value4:GenerateGUID(false):gsub("-", "")
            v67 = v59
            v68 = v48
            v69 = t2.value8.host()
            ServiceId = t2.value1.ServiceId

            if v8(v67(v68({
				["Url"] = v69 .. "/public/redeem/" .. tostring(ServiceId),
				["Method"] = "POST",
				["Headers"] = {
					["Content-Type"] = "application/json"
				},
				["Body"] = t2.value4:JSONEncode({
					["identifier"] = t2.value8.identifier(),
					["key"] = p10,
					["nonce"] = v66
				})
			})), v66) then
                return true
            else
                error("Key is invalid or expired. Use Get Key to obtain a new key.", 0)

                return
            end

            return
        else
            error("Key is invalid or expired. Use Get Key to obtain a new key.", 0)

            return
        end

        return
    end
end
function t2.value8.loadMain(p11)
    local Access = v5()
    local value6 = t2.value6

    t2.value6 = nil

    if type(value6) ~= "table" or (value6.PlaceId ~= game.PlaceId and true or value6.Until < os.clock()) then
        error("Verify your key before loading.", 0)
    end

    if p11 then
        p11("Downloading " .. Access.Name .. "...")
    end

    value6 = v48({
		["Url"] = Access.URL,
		["Method"] = "GET",
		["Timeout"] = 20
	})

    if t2.value7 then
        error("Loader closed before download completed.", 0)
    end

    local Body = value6.Body

    if type(Body) ~= "string" and true or value6.Body == "" then
        error("GitHub returned an empty script.", 0)
    end

    if p11 then
        p11("Compiling " .. Access.Name .. "...")
    end

    value6, Body = loadstring(value6.Body)

    if not value6 then
        error(Body or "Cannot compile the main script.", 0)
    end

    if t2.value7 then
        error("Loader closed before startup.", 0)
    end

    Body = t2.value5

    local Access2 = Access.Access
    local GateTag = t2.value1.GateTag
    local now = os.clock()
    local PlaceId = game.PlaceId

    Body[Access2] = {
		["Tag"] = GateTag,
		["Until"] = now + 30,
		["PlaceId"] = PlaceId
	}

    if p11 then
        p11("Starting " .. Access.Name .. "... (up to 45s)")
    end

    value6, Body = pcall(function()
        return request_(45, "Hub startup", value6)
    end)
    Access = Access.Access
    t2.value5[Access] = nil

    if value6 then
        return
    end

    error(Body, 0)
end
v8 = gethui and gethui() or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
request_ = v8:FindFirstChild("PanoraKeyGate") or v8:FindFirstChild("PyramidKeyGate")

if request_ then
    request_:Destroy()
end
request_ = function(p12, p13, p14)
    local instance = Instance.new(p12)
    for v83, v84 in pairs(p13) do

        instance[v83] = v84
    end
    instance.Parent = p14

    return instance
end
function t2.value9(p15, p16)
    request_("UICorner", {
		["CornerRadius"] = UDim.new(0, p16)
	}, p15)
end
t2.value10 = {
	["Background"] = Color3.fromRGB(12, 22, 19),
	["Input"] = Color3.fromRGB(23, 36, 30),
	["Accent"] = Color3.fromRGB(110, 231, 183),
	["Text"] = Color3.fromRGB(232, 247, 239),
	["Muted"] = Color3.fromRGB(148, 174, 158),
	["Error"] = Color3.fromRGB(255, 155, 145)
}
t2.value11 = request_("ScreenGui", {
	["Name"] = "PanoraKeyGate",
	["ResetOnSpawn"] = false,
	["DisplayOrder"] = 10000,
	["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
}, v8)
t2.value12 = request_("Frame", {
	["Name"] = "KeyCard",
	["AnchorPoint"] = Vector2.new(0.5, 0.5),
	["Position"] = UDim2.fromScale(0.5, 0.5),
	["Size"] = UDim2.new(0.9, 0, 0, 282),
	["BackgroundColor3"] = t2.value10.Background,
	["BorderSizePixel"] = 0,
	["Active"] = true
}, t2.value11)
request_("UISizeConstraint", {
	["MaxSize"] = Vector2.new(380, 282),
	["MinSize"] = Vector2.new(240, 282)
}, t2.value12)
t2.value9(t2.value12, 13)
request_("UIStroke", {
	["Color"] = Color3.fromRGB(49, 82, 62),
	["Transparency"] = 0.3,
	["Thickness"] = 1
}, t2.value12)
unpack_ = function(p17, p18, p19, p20, p21)
    return unpack_({ request_("TextLabel", {
			["Text"] = p17,
			["Position"] = UDim2.fromOffset(20, p18),
			["Size"] = UDim2.new(1, -40, 0, p19),
			["BackgroundTransparency"] = 1,
			["TextColor3"] = p20 or t2.value10.Text,
			["Font"] = Enum.Font.Gotham,
			["TextSize"] = p21 or 12,
			["TextWrapped"] = true,
			["TextXAlignment"] = Enum.TextXAlignment.Left
		}, t2.value12) })
end
unpack_("PANORA", 17, 24, nil, 18).Font = Enum.Font.GothamBold
v8 = request_("Frame", {
	["Position"] = UDim2.fromOffset(112, 25),
	["Size"] = UDim2.fromOffset(7, 7),
	["BackgroundColor3"] = t2.value10.Accent,
	["BorderSizePixel"] = 0
}, t2.value12)
t2.value9(v8, 7)
v8 = t2.value2
v48 = game.PlaceId
v8 = v8[tostring(v48)]

if v8 then
    v8 = t2.value2
    v48 = game.PlaceId
    v8 = v8[tostring(v48)].Name
end
unpack_(v8 or "Unsupported game", 42, 20, t2.value10.Muted, 11)
request_("Frame", {
	["Position"] = UDim2.fromOffset(20, 73),
	["Size"] = UDim2.new(1, -40, 0, 1),
	["BackgroundColor3"] = Color3.fromRGB(43, 61, 50),
	["BorderSizePixel"] = 0
}, t2.value12)
t2.value13 = unpack_("Enter your key to unlock PANORA.", 84, 30, t2.value10.Muted, 12)
t2.value14 = request_("TextBox", {
	["Name"] = "KeyInput",
	["Position"] = UDim2.fromOffset(20, 121),
	["Size"] = UDim2.new(1, -40, 0, 38),
	["Text"] = "",
	["PlaceholderText"] = "Paste your access key",
	["ClearTextOnFocus"] = false,
	["BackgroundColor3"] = t2.value10.Input,
	["TextColor3"] = t2.value10.Text,
	["PlaceholderColor3"] = t2.value10.Muted,
	["Font"] = Enum.Font.Gotham,
	["TextSize"] = 12,
	["BorderSizePixel"] = 0,
	["TextXAlignment"] = Enum.TextXAlignment.Left
}, t2.value12)
t2.value9(t2.value14, 7)
request_("UIPadding", {
	["PaddingLeft"] = UDim.new(0, 12),
	["PaddingRight"] = UDim.new(0, 12)
}, t2.value14)
t2.value15 = {}
v8 = function(p22, p23, p24, p25, p26)
    local TextButton = request_("TextButton", {
		["Text"] = p22,
		["Position"] = UDim2.new(p23, p23 == 0 and 20 or 4, p24, 0),
		["Size"] = p25,
		["BackgroundColor3"] = p26 and t2.value10.Accent or t2.value10.Input,
		["TextColor3"] = p26 and t2.value10.Background or t2.value10.Text,
		["Font"] = Enum.Font.GothamBold,
		["TextSize"] = 12,
		["BorderSizePixel"] = 0,
		["AutoButtonColor"] = true
	}, t2.value12)

    t2.value9(TextButton, 7)
    t2.value15[#t2.value15 + 1] = TextButton

    return TextButton
end
t2.value16 = v8("Check key", 0, 0, UDim2.new(1, -40, 0, 36), true)
t2.value16.Position = UDim2.fromOffset(20, 170)
v48 = v8("Get key", 0, 0, UDim2.new(0.5, -24, 0, 32))
v48.Position = UDim2.fromOffset(20, 214)
v8 = v8("Clear key", 0.5, 0, UDim2.new(0.5, -24, 0, 32))
v8.Position = UDim2.new(0.5, 4, 0, 214)
unpack_("Your key is saved after verification and checked each launch.", 252, 19, t2.value10.Muted, 9)
unpack_ = request_("TextButton", {
	["Text"] = "\195\151",
	["Position"] = UDim2.new(1, -41, 0, 13),
	["Size"] = UDim2.fromOffset(26, 26),
	["BackgroundTransparency"] = 1,
	["TextColor3"] = t2.value10.Muted,
	["Font"] = Enum.Font.Gotham,
	["TextSize"] = 21
}, t2.value12)
t2.value17 = "BuildThePyramid"
request_ = t2.value1.ServiceId
t2.value18 = "BuildThePyramid" .. "/platoboost-key-" .. tostring(request_) .. ".txt"
request_ = readfile
if request_ then
    t1.value5 = writefile
    request_ = t1.value5

    if t1.value5 then
        t1.value6 = isfile
        t1.value7 = t1.value6

        if t1.value6 then
            request_ = makefolder

            if request_ then
                request_ = isfolder
            end

            t1.value7 = request_
        end

        request_ = t1.value7
    end
end
t2.value19 = request_
if t2.value19 then
    pcall(function()
        if not isfolder(t2.value17) then
            makefolder(t2.value17)
        end

        if not isfile(t2.value18) then
            return
        end

        t2.value14.Text = readfile(t2.value18)
    end)
end
t2.value20 = false
t2.value21 = false
request_ = function(_, _)
    if t2.value20 or (t2.value21 or not t2.value11.Parent) then

        return
    end
end
v48.Activated:Connect(function()
    request_("Creating your key link...", function()
        local vR27FuOFHZhbuD = t2.value8.getLink()

        if not t2.value11.Parent then
            vR27FuOFHZhbuD = env.vR27FuOFHZhbuD

            return
        end

        local setclipboard_ = setclipboard or toclipboard

        if not setclipboard_ then
            t2.value13.Text = setclipboard_ and "Link copied. Open it in your browser to get a key."

            return
        end

        setclipboard_ = pcall(setclipboard_, vR27FuOFHZhbuD)
        t2.value13.Text = setclipboard_ and "Link copied. Open it in your browser to get a key."
    end)
end)
v5 = function()
    local match = t2.value14.Text:match("^%s*(.-)%s*$")

    v5()

    if t2.value8.check(match) ~= true then
        error("Key verification failed.", 0)
    end

    if not t2.value11.Parent then
        return
    end

    local now = os.clock()
    local PlaceId = game.PlaceId

    t2.value6 = {
		["Key"] = match,
		["Until"] = now + 30,
		["PlaceId"] = PlaceId
	}
    t2.value13.Text = "Key verified. Loading PANORA..."
    t2.value8.loadMain(function(p27)
        if not t2.value11.Parent then
            return
        end

        t2.value13.Text = p27
    end)
    t2.value21 = true

    if not t2.value19 then
        t2.value11:Destroy()

        return
    end

    pcall(writefile, t2.value18, match)
    t2.value11:Destroy()
end
t2.value16.Activated:Connect(function()
    request_("Checking your key...", v5)
end)
t2.value14.FocusLost:Connect(function(enterPressed)
    if not enterPressed then
        v117 = env.z6lmMb7f44KGZI

        return
    end

    request_("Checking your key...", v5)

    local z6lmMb7f44KGZI = env.z6lmMb7f44KGZI
end)
v8.Activated:Connect(function()
    if t2.value20 then
        v118 = env["8dH1PUOS9Hh3c"]

        return
    end

    t2.value14.Text = ""
    t2.value13.Text = "Enter a new key."
    t2.value13.TextColor3 = t2.value10.Muted

    local delfile_ = delfile

    if type(delfile_) == "function" then
        delfile_ = isfile

        if type(delfile_) == "function" then
            delfile_ = isfile(t2.value18)
        else
            delfile_ = false
        end
    else
        delfile_ = false
    end

    if not delfile_ then
        return
    end

    pcall(delfile, t2.value18)
end)
t2.value22 = {}
unpack_.Activated:Connect(function()
    t2.value7 = true
    t2.value6 = nil
    t2.value11:Destroy()
end)
unpack_ = game:GetService("UserInputService")
t2.value23 = nil
t2.value24 = nil
t2.value25 = nil
t2.value22[#t2.value22 + 1] = t2.value12.InputBegan:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
        return
    end

    local v92 = input.Position.Y - t2.value12.AbsolutePosition.Y
    local _ = v92 > 73 and 14140197 or false

    if v92 > 73 then
        return
    end

    t2.value23 = input
    t2.value24 = input.Position
    t2.value25 = t2.value12.Position
end)
t2.value22[#t2.value22 + 1] = unpack_.InputChanged:Connect(function(input)
    if not t2.value23 then
        v122 = HhwtdHFcaKOhtJ

        return
    end

    local v94 = input ~= t2.value23
    local CurrentCamera, v96, value12, uDim2, X, X2, v101

    if not v94 then
        if v94 then
            return
        else
            v94 = input.Position - t2.value24
            CurrentCamera = workspace.CurrentCamera
            CurrentCamera = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            v96 = t2.value12.AbsoluteSize / 2
            v94 = t2.value12.AbsolutePosition + v96 + Vector2.new(v94.X, v94.Y)
            value12 = t2.value12
            uDim2 = UDim2.fromOffset
            X = v94.X
            X2 = v96.X
            v101 = CurrentCamera.X - v96.X
            X = math.clamp(X, X2, v101)
            v94 = v94.Y
            X2 = v96.Y
            CurrentCamera = CurrentCamera.Y - v96.Y
            value12.Position = uDim2(X, (math.clamp(v94, X2, CurrentCamera)))
            t2.value24 = input.Position

            return
        end

        return
    end

    v94 = t2.value23.UserInputType ~= Enum.UserInputType.MouseButton1

    if not v94 then
        if v94 then
            return
        else
            v94 = input.Position - t2.value24
            CurrentCamera = workspace.CurrentCamera
            CurrentCamera = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            v96 = t2.value12.AbsoluteSize / 2
            v94 = t2.value12.AbsolutePosition + v96 + Vector2.new(v94.X, v94.Y)
            value12 = t2.value12
            uDim2 = UDim2.fromOffset
            X = v94.X
            X2 = v96.X
            v101 = CurrentCamera.X - v96.X
            X = math.clamp(X, X2, v101)
            v94 = v94.Y
            X2 = v96.Y
            CurrentCamera = CurrentCamera.Y - v96.Y
            value12.Position = uDim2(X, (math.clamp(v94, X2, CurrentCamera)))
            t2.value24 = input.Position

            return
        end

        return
    end

    v94 = input.UserInputType == Enum.UserInputType.MouseMovement

    if v94 then
        return
    else
        v94 = input.Position - t2.value24
        CurrentCamera = workspace.CurrentCamera
        CurrentCamera = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        v96 = t2.value12.AbsoluteSize / 2
        v94 = t2.value12.AbsolutePosition + v96 + Vector2.new(v94.X, v94.Y)
        value12 = t2.value12
        uDim2 = UDim2.fromOffset
        X = v94.X
        X2 = v96.X
        v101 = CurrentCamera.X - v96.X
        X = math.clamp(X, X2, v101)
        v94 = v94.Y
        X2 = v96.Y
        CurrentCamera = CurrentCamera.Y - v96.Y
        value12.Position = uDim2(X, (math.clamp(v94, X2, CurrentCamera)))
        t2.value24 = input.Position

        return
    end
end)
t2.value22[#t2.value22 + 1] = unpack_.InputEnded:Connect(function(input)
    if input ~= t2.value23 then
        return
    end

    t2.value23 = nil
end)
t2.value11.Destroying:Connect(function()
    t2.value7 = true
    t2.value6 = nil
    for v104, v105 in ipairs(t2.value22) do

        v105:Disconnect()
    end
end)
env = t2.value2
unpack_ = game.PlaceId
if not env[tostring(unpack_)] then
    t2.value13.Text = "This game is not supported by PANORA."

    return
end
t1.value8 = not t2.value8.configured()
if t1.value8 then
    t2.value13.Text = "Key service is not configured."

    return
end
t1.value9 = t2.value14.Text ~= ""
if not t1.value9 then
    return
end
request_("Checking your saved key...", v5)
