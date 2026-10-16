do
    local STRICT = true
    local WATCH = true
    local Players = game:GetService("Players")
    local env = (getgenv and getgenv()) or _G
    local function kick(why)
        pcall(function() Players.LocalPlayer:Kick("Flexozy Security: " .. tostring(why)) end)
        task.wait(2)
        pcall(function() game:Shutdown() end)
    end
    local function native(fn)
        if type(fn) ~= "function" then return false end
        if islclosure and islclosure(fn) then return false end
        if isfunctionhooked then
            local ok, h = pcall(isfunctionhooked, fn)
            if ok and h then return false end
        end
        if debug and debug.info then
            local ok, s = pcall(debug.info, fn, "s")
            if ok and s ~= "[C]" then return false end
        end
        return true
    end
    local MARK = {"__FlexozyOldLoadstring", "__FlexozyOnHttp", "__FlexozyHttpHooked", "__dumper", "__loadstring_log", "__scriptdump"}
    local NAMES = {"dump", "decompil", "sourceview", "codeview", "loadstringlog", "hookspy", "scriptlog", "flexozyloader"}
    local function badName(n)
        n = string.lower(tostring(n))
        for _, p in ipairs(NAMES) do
            if string.find(n, p, 1, true) then return true end
        end
        return false
    end
    local function roots()
        local list = {}
        pcall(function() if gethui then table.insert(list, gethui()) end end)
        pcall(function() table.insert(list, game:GetService("CoreGui")) end)
        pcall(function() table.insert(list, Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")) end)
        return list
    end
    local function scan()
        for _, k in ipairs(MARK) do
            if rawget(env, k) ~= nil then return "marker" end
        end
        if STRICT then
            if not native(loadstring) then return "hook:loadstring" end
            local ok, hg = pcall(function() return game.HttpGet end)
            if ok and hg ~= nil and not native(hg) then return "hook:HttpGet" end
        end
        for _, r in ipairs(roots()) do
            for _, g in ipairs(r:GetChildren()) do
                if g:IsA("ScreenGui") and g.Name ~= "Flexozy_Hub" then
                    if badName(g.Name) then return "gui" end
                    if r ~= game:GetService("CoreGui") then
                        for _, d in ipairs(g:GetDescendants()) do
                            if (d:IsA("TextLabel") or d:IsA("TextBox")) and d.Font == Enum.Font.Code and #d.Text > 1500 then
                                return "viewer"
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    local why = scan()
    if why then
        kick(why)
        return
    end
    if WATCH then
        task.spawn(function()
            while task.wait(3) do
                local w = scan()
                if w then kick(w) return end
            end
        end)
    end
end
local __K = "6b3c0a45980c89b104d453de"
local __D = "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"
local __T = {}
for i = 1, 64 do __T[string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i)] = i - 1 end
local __o, __acc, __bits, __j, __kl = {}, 0, 0, 0, #__K
for i = 1, #__D do
    local v = __T[string.byte(__D, i)]
    if v then
        __acc = __acc * 64 + v
        __bits = __bits + 6
        if __bits >= 8 then
            __bits = __bits - 8
            local x = math.floor(__acc / 2 ^ __bits)
            __acc = __acc % 2 ^ __bits
            __j = __j + 1
            __o[__j] = string.char(bit32.bxor(x, string.byte(__K, (__j - 1) % __kl + 1), (__j * 7) % 256))
        end
    end
end
local __f = loadstring(table.concat(__o))
if __f then return __f() end
