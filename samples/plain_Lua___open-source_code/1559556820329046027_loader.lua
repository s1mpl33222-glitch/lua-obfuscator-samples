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
local __K = "dbd7b235036bd326366284a5"
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
