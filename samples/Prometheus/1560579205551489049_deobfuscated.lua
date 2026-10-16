-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local v3 = getfenv and getfenv() or _ENV
local v4 = unpack or table.unpack
t2.value1 = "https://api.aurorax.site"
t2.value2 = "/api/auth"
t2.value3 = "/api/script"
t2.value4 = "AuroraXGate"
t2.value5 = "--[AuroraXGate"
local request = v3.request
if not request then
    t1.value1 = http_request
    request = t1.value1

    if not t1.value1 then
        t1.value2 = syn and syn.request
        t1.value3 = t1.value2

        if not t1.value2 then
            t1.value3 = http and http.request
        end

        request = t1.value3
    end
end
t2.value6 = request
function t2.value7(p1)
    local t3 = { tostring(p1):gsub("[^%w%-_%.~]", function(p2)
        return string.format("%%%02X", string.byte(p2))
    end) }

    return v4(t3)
end
function t2.value8(p3, p4)
    local s1 = ""

    if p4 then

        for v26, v27 in pairs(p4) do

            s1 ..= (s1 ~= "" and "&" or "?") .. v26 .. "=" .. t2.value7(v27)
        end
    end

    local v28 = t2.value1 .. p3 .. s1

    if t2.value6 then
        local ok, result = pcall(t2.value6, {
			Url = v28,
			Method = "GET"
		})

        if ok then
            ok = type(result) == "table"
        end

        if ok then
            local v31 = result.Body or result.body

            if type(v31) == "string" and #v31 > 0 then

                return v31
            end
        end
    end

    return game:HttpGet(v28)
end
local t4 = {
	t2.value6,
	t2.value1
}
t1.value4 = "Your key expired - get a new one at aurorax.site."
t1.value5 = t4
local function v7(p5, p6)
    if not t2.value6 then
        return nil
    end
    local t5 = {}
    for v38, v39 in pairs(p6) do

        t5[#t5 + 1] = "\"" .. v38 .. "\":\"" .. tostring(v39):gsub("[%c\"\\]", "") .. "\""
    end
    local ok, result = pcall(t2.value6, {
		Url = t2.value1 .. p5,
		Method = "POST",
		Headers = {
			["content-type"] = "application/json"
		},
		Body = "{" .. table.concat(t5, ",") .. "}"
	})
    if ok then
        ok = type(result) == "table"
    end
    if ok then
        local v42 = result.Body or result.body

        if type(v42) == "string" and #v42 > 0 then
            return v4({ v42 })
        end
    end

    return nil
end
t1.value6 = {}
t1.value7 = "hwid_mismatch"
local function v8(p7)
    if task and task.wait then
        pcall(function()
            task.wait(p7)
        end)

        return
    end

    if wait then
        pcall(function()
            wait(p7)
        end)
    end
end
local function v9(p8, p9)
    return tostring(p8):match("\"" .. p9 .. "\"%s*:%s*\"([^\"]*)\"")
end
t1.value8 = {}
t1.value9 = {}
local function v10(p10, p11)
    return tostring(p10):match("\"" .. p11 .. "\"%s*:%s*true") ~= nil
end
local function v11()
    local s2 = ""

    pcall(function()
        if gethwid then
            s2 = tostring(gethwid())
        end
    end)

    if s2 == "" then
        pcall(function()
            s2 = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        end)
    end

    if s2 == "" then
        s2 = "unknown"
    end

    return s2
end
t1.value10 = {}
local function v12()
    local t6 = {}

    pcall(function()
        local __namecall = getrawmetatable(game).__namecall

        if __namecall then
            local v122 = debug.getinfo(__namecall, "S")

            if v122 and v122.what == "Lua" then
                t6[#t6 + 1] = "namecall_hook"
            end
        end
    end)

    return t6
end
t2.value9 = {
	bad_request = "Missing data (key/hwid).",
	invalid_key = "Invalid or nonexistent key.",
	expired = "Your key expired - get a new one at aurorax.site.",
	revoked = "Your key was revoked.",
	key_shared = "Your key was shared and got blocked.",
	hwid_mismatch = "This key is linked to another device.",
	banned = "You are banned from the system.",
	rate_limited = "Too many requests - wait a moment.",
	invalid_token = "Invalid token - rejoin the game.",
	expired_token = "Session expired - revalidating.",
	script_unavailable = "Script is not available right now.",
	node_denied = "This node rejected the client - run the loader directly from your executor.",
	network = "No connection to the server - try again.",
	check_failed = "Server error - try again in a moment."
}
t2.value10 = nil
local function v13()
    pcall(function()
        if t2.value10 then
            t2.value10:Destroy()
        end
    end)
    t2.value10 = nil
end
t2.value11 = nil
local function v14(p12, p13, p14, p15)
    print("[AuroraX] " .. p12)
    v13()
    pcall(function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AuroraXGate"
        ScreenGui.ResetOnSpawn = false
        local u124 = false
        pcall(function()
            ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
            u124 = true
        end)
        if not u124 then
            pcall(function()
                ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            end)
        end
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(0, 340, 0, 30)
        TextLabel.Position = UDim2.new(0.5, -170, 0, 8)
        TextLabel.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
        TextLabel.TextColor3 = Color3.fromRGB(p13, p14, p15)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 13
        TextLabel.Text = p12
        TextLabel.BorderSizePixel = 0
        TextLabel.Parent = ScreenGui
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = TextLabel
        t2.value10 = ScreenGui
    end)
    local value10
    value10 = t2.value10
    pcall(function()
        if task and task.delay then
            task.delay(6, function()
                if t2.value10 == value10 then
                    v13()
                end

                local _ = KwjmdSsjryqGZ
            end)

            return
        end
        local spawn2 = spawn
        if spawn2 then
            spawn2 = wait
        end
        if spawn2 then
            spawn(function()
                wait(6)
                if t2.value10 == value10 then
                    v13()
                end
            end)
        end
    end)
end
t1.value11 = {
	t2.value8,
	t2.value3,
	t2.value5,
	v9,
	v14,
	t2.value11,
	v8
}
function t1.value4(p16)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "AuroraXGate"
    ScreenGui.ResetOnSpawn = false

    local u60 = false

    pcall(function()
        ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
        u60 = true
    end)

    if not u60 then
        pcall(function()
            ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end)
    end

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, 380, 0, 200)
    Frame.Position = UDim2.new(0.5, -190, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 0, 40)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "AuroraX - Gate"
    TextLabel.TextColor3 = Color3.fromRGB(255, 32, 56)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 20
    TextLabel.Parent = Frame

    local clone = TextLabel:Clone()

    clone.Size = UDim2.new(1, 0, 0, 16)
    clone.Position = UDim2.new(0, 0, 0, 38)
    clone.Text = "Enter your key to load the script"
    clone.TextColor3 = Color3.fromRGB(140, 140, 150)
    clone.Font = Enum.Font.Gotham
    clone.TextSize = 12
    clone.Parent = Frame

    local TextBox = Instance.new("TextBox")

    TextBox.Size = UDim2.new(1, -40, 0, 36)
    TextBox.Position = UDim2.new(0, 20, 0, 64)
    TextBox.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    TextBox.BorderSizePixel = 0
    TextBox.PlaceholderText = "AURORA-XXXX-XXXX-XXXX"
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(240, 240, 245)
    TextBox.Font = Enum.Font.Code
    TextBox.TextSize = 14
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = Frame

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 6)
    UICorner2.Parent = TextBox

    local clone2 = clone:Clone()

    clone2.Size = UDim2.new(1, -40, 0, 16)
    clone2.Position = UDim2.new(0, 20, 0, 106)
    clone2.Text = ""
    clone2.TextColor3 = Color3.fromRGB(120, 200, 120)
    clone2.Parent = Frame

    local function v68(p17, p18, p19)
        local TextButton = Instance.new("TextButton")

        TextButton.Size = UDim2.new(0, 165, 0, 36)
        TextButton.Position = UDim2.new(0, p19, 0, 136)
        TextButton.BackgroundColor3 = p18
        TextButton.Text = p17
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.Font = Enum.Font.GothamBold
        TextButton.TextSize = 14
        TextButton.BorderSizePixel = 0
        TextButton.Parent = Frame

        local UICorner3 = Instance.new("UICorner")

        UICorner3.CornerRadius = UDim.new(0, 6)
        UICorner3.Parent = TextButton

        return TextButton
    end

    local v69 = v68("Get key", Color3.fromRGB(40, 40, 52), 20)
    local v70 = v68("Load", Color3.fromRGB(255, 32, 56), 195)

    local function v71()
        local v135 = TextBox.Text:gsub("%s", "")

        if #v135 < 10 then
        end

        if #v135 < 10 then
            clone2.Text = "Invalid key"
            clone2.TextColor3 = Color3.fromRGB(255, 90, 90)

            return
        end

        ScreenGui:Destroy()
        p16(v135)
    end

    v69.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("https://aurorax.site")
            end
        end)
        clone2.Text = "aurorax.site copied to clipboard"
        clone2.TextColor3 = Color3.fromRGB(255, 190, 77)
    end)
    v70.MouseButton1Click:Connect(v71)
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            v71()
        end
    end)
end
function t2.value11(p20, p21)
    for i = 1, 3 do
        local v75 = v7(t2.value2, {
			key = p20,
			hwid = p21
		})

        if not v75 then
            local ok, result = pcall(t2.value8, t2.value2, {
				key = p20,
				hwid = p21
			})

            if ok then
                ok = type(result) == "string" and #result > 0
            end

            if ok then
                v75 = result
            end
        end

        if type(v75) == "string" and #v75 > 0 then
            if v75:sub(1, 9) == "<!DOCTYPE" or v75:sub(1, 8) == "AURORAX " then
                return nil, "node_denied"
            end

            if v10(v75, "success") then
                local v78 = v9(v75, "token")

                if v78 and #v78 >= 24 then

                    return v78
                end

                return nil, "check_failed"
            end

            local v80 = v9(v75, "code") or "check_failed"

            if v80 == "rate_limited" and i < 3 then
                v8(3)

                continue
            end

            return nil, v80
        end

        v8(2)
    end

    return nil, "network"
end
t1.value7 = {
	t2.value9,
	v14
}
function t2.value12(p22, p23, p24)
    local n1 = 4
    local n2 = 1
    local v86 = n2 < 0
    local v87 = 1 - n2

    while true do
        v87 += n2

        local v88 = v87 <= n1

        if (not v86 or not (n1 <= v87)) and (v86 or not v88) then
            break
        end

        local ok, result = pcall(t2.value8, t2.value3, {
			token = p24,
			hwid = p23
		})

        if ok then
            ok = type(result) == "string" and #result > 0
        end

        if ok then
            local v91 = result:sub(1, #t2.value5)
            local value5 = t2.value5
            if v91 == value5 then
            end
            if v91 == value5 then
                return result
            end
            if result:sub(1, 9) == "<!DOCTYPE" or result:sub(1, 8) == "AURORAX " then
                return nil, "node_denied"
            end
            local v93 = v9(result, "code") or "check_failed"
            local v94 = v93 == "expired_token"
            if v94 or v93 == "invalid_token" then
                v14("Session expired - revalidating...", 255, 190, 77)

                local v96

                p24, v96 = t2.value11(p22, p23)

                if not p24 then
                    return nil, v96
                end

                continue
            end
            if v93 == "rate_limited" and v87 < 4 then
                v8(3)

                continue
            end

            return nil, v93
        end

        v8(2)
    end

    return nil, "network"
end
local function v15(p25)
    local v98 = t2.value9[p25]
    if not v98 then
        v98 = t2.value9.check_failed
    end
    v14(v98, 255, 90, 90)
end
local function v16(p26)
    local u101 = tostring(p26):gsub("%s", "")
    local v102 = v11()
    local v103 = v12()
    if #v103 > 0 then
        print("[AuroraX] Suspicious environment (" .. table.concat(v103, ",") .. ").")
        print("[AuroraX] Close your other scripts/hooks and run this directly from the console.")

        return
    end
    v14("Validating key...", 255, 190, 77)
    local v104, v105 = t2.value11(u101, v102)
    if not v104 then
        v15(v105)

        return
    end
    v14("Downloading script...", 255, 190, 77)
    local v106, v107 = t2.value12(u101, v102, v104)
    if not v106 then
        v15(v107)

        return
    end
    pcall(function()
        getgenv().AuroraXKey = u101
    end)
    pcall(function()
        getgenv().Key = u101
    end)
    pcall(function()
        if writefile then
            writefile("aurorax.key", u101)
        end
    end)
    v14("Ready - executing script", 120, 200, 120)
    local v109, v110 = loadstring(v106, "=" .. t2.value4)
    if not v109 then
        print("[AuroraX] Script integrity check failed: " .. tostring(v110))

        return
    end
    local v111, v112 = pcall(v109)
    v8(2)
    v13()
    if not v111 then
        print("[AuroraX] " .. tostring(v112))
    end
end
local _type = type
t1.value7 = ({ ... })[1]
if _type(t1.value7) ~= "string" then
    t1.value7 = nil
end
t2.value13 = nil
t2.value13 = nil
pcall(function()
    t2.value13 = getgenv().Key
end)
if type(t2.value13) ~= "string" or t2.value13 == "" then
    t1.value12 = { t2.value13 }

    function t1.value13()
        t2.value13 = getgenv().script_key
    end

    pcall(t1.value13)
end
if type(t2.value13) ~= "string" or t2.value13 == "" then
    t2.value13 = t1.value7
end
if type(t2.value13) ~= "string" or t2.value13 == "" then
    pcall(function()
        t2.value13 = getgenv().AuroraXKey
    end)
end
if not t2.value13 or t2.value13 == "" then
    t2.value13 = (function()
        local v49, v50 = pcall(function()
            local _isfile = isfile
            if _isfile then
                _isfile = readfile and isfile("aurorax.key")
            end
            if _isfile then
                local v117 = readfile("aurorax.key")

                if type(v117) == "string" then
                    local v118 = v117:gsub("[^%w%-]", "")

                    if #v118 >= 20 then

                        return v118
                    end
                end
            end
        end)
        if v49 then
            v49 = type(v50) == "string" and #v50 >= 20
        end
        if v49 then
            return v50
        end
    end)()
end
if not t2.value13 or t2.value13 == "" then
    t1.value4(function(p27)
        v16(p27)
    end)
else
    v16(t2.value13)
end
