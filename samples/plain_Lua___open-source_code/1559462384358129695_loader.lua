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
local __K = "dd988f30c1efcbbfe587d027"
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
