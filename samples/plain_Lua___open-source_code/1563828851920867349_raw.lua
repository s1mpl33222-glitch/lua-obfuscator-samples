-- ============================================================
-- RENHUB X XPLT COMUNITY — Loader + Shield v2.0.0
-- ============================================================

-- [1] INSTALAR SHIELD (Anti-Cheat Bypass) ANTES del loader
if getgenv and getgenv().MontanaShield and getgenv().MontanaShield.Active then
    -- Shield ya activo, no reinstalar
else

local Shield = {
    Active       = true,
    Version      = "2.0.0",
    BlockedKicks = 0,
    BlockedReports = 0,
    DisabledScripts = 0,
    LogHooked    = false,
    SendHooked   = false,
    GetHooked    = false,
    DescendantHooked = false,
    StartTime    = tick(),
}

if getgenv then getgenv().MontanaShield = Shield end
if not getgenv then _G.MontanaShield = Shield end

local _renPrinted = false
local function slog(msg)
    if not _renPrinted then
        _renPrinted = true
        print("REN ON TOP")
    end
end

local function swarn(msg)
    -- silent (no console spam)
end

slog()

local AC_SCRIPT_KEYWORDS = {
    "anticheat", "anti_cheat", "antiexploit", "anti_exploit",
    "sentry", "sentinel", "watchdog", "honeypot", "trustcheck",
    "exploitdetect", "cheatdetect", "monitorclient", "protector",
    "flagcheck",
    "clientlog",
    "logrequest",
    "thanksroblox",
    "integrity",
}

local AC_EVENT_KEYWORDS = {
    "report", "flag", "cheat", "detect",
    "anticheat", "anti_cheat", "trustcheck", "security",
    "violation", "sentry",
    "log",
    "logrequest",
    "clientlog",
    "flagcheck",
    "integritycheck",
    "integrity",
    "telemetry",
}

local AC_EXACT_NAMES = {
    "Logs",
    "FlagCheck",
    "ThanksRoblox",
    "ConsoleDevConsole",
}

local PROTECTED_GUI_NAMES = {
    "CHINOINFIERNOHUB",
    "GhostFloatingSwitchGui",
    "TouchPanelGui",
    "CHINO_RareWeaponAlerts",
    "SoftAimMobileTriggerGui",
    "MontanaHubUI", "MontanaHub", "MontanaShield",
    "KunlunAimbot", "AimbotFOV", "AimbotTracer", "AimbotTarget"
}

local function name_has(name, list)
    if not name then return false end
    local lower = tostring(name):lower()
    for i = 1, #list do
        if lower:find(list[i], 1, true) then
            return true
        end
    end
    return false
end

local function is_ac_script(name)
    if not name then return false end
    if name_has(name, AC_SCRIPT_KEYWORDS) then return true end
    for i = 1, #AC_EXACT_NAMES do
        if tostring(name) == AC_EXACT_NAMES[i] then return true end
    end
    return false
end

local function is_ac_event(name) return name_has(name, AC_EVENT_KEYWORDS) end

pcall(function()
    local mt = getrawmetatable(game)
    if not mt then
        swarn("getrawmetatable fallo - Kick protection no aplicada")
        return
    end

    setreadonly(mt, false)
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if not checkcaller() then
            if method == "Kick" then
                Shield.BlockedKicks = Shield.BlockedKicks + 1
                swarn("Kick bloqueado #" .. Shield.BlockedKicks)
                return nil
            end

            if method == "Destroy" and typeof(self) == "Instance" then
                for i = 1, #PROTECTED_GUI_NAMES do
                    if self.Name == PROTECTED_GUI_NAMES[i] then
                        return nil
                    end
                end
            end

            if method == "FireServer" and typeof(self) == "Instance" then
                if self:IsA("RemoteEvent") then
                    local n = tostring(self.Name)
                    if n:find("IntegrityCheck", 1, true)
                    or n:find("LogRequest", 1, true)
                    or n:find("ClientLog", 1, true) then
                        Shield.BlockedReports = Shield.BlockedReports + 1
                        swarn("FireServer bloqueado (namecall): " .. n)
                        return nil
                    end
                end
            end

            if method == "InvokeServer" and typeof(self) == "Instance" then
                if self:IsA("RemoteFunction") then
                    local n = tostring(self.Name)
                    if n:find("IntegrityCheck", 1, true)
                    or n:find("LogRequest", 1, true) then
                        Shield.BlockedReports = Shield.BlockedReports + 1
                        return nil
                    end
                end
            end
        end

        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
    slog("Hook metatable OK (Kick + Destroy + IntegrityFire)")
end)

local function hook_remotes()
    local RS = game:GetService("ReplicatedStorage")
    local Remotes = RS:FindFirstChild("Remotes")
    if not Remotes then return false end

    local Send = Remotes:FindFirstChild("Send")
    if Send and Send:IsA("RemoteEvent") and not Shield.SendHooked then
        pcall(function()
            local oldFire = Send.FireServer
            local newFire
            newFire = hookfunction(oldFire, newcclosure(function(self, ...)
                local args = {...}
                if args[2] and type(args[2]) == "string" then
                    if is_ac_event(args[2]) then
                        Shield.BlockedReports = Shield.BlockedReports + 1
                        swarn("Reporte bloqueado (Send): " .. tostring(args[2]))
                        return nil
                    end
                end
                for i = 1, #args do
                    if type(args[i]) == "string" and is_ac_event(args[i]) then
                        Shield.BlockedReports = Shield.BlockedReports + 1
                        swarn("Reporte bloqueado (Send arg" .. i .. "): " .. tostring(args[i]))
                        return nil
                    end
                end
                return newFire(self, ...)
            end))
            Shield.SendHooked = true
            slog("Hook Remotes.Send OK")
        end)
    end

    local Get = Remotes:FindFirstChild("Get")
    if Get and Get:IsA("RemoteFunction") and not Shield.GetHooked then
        pcall(function()
            local oldInvoke = Get.InvokeServer
            local newInvoke
            newInvoke = hookfunction(oldInvoke, newcclosure(function(self, ...)
                local args = {...}
                if args[2] and type(args[2]) == "string" then
                    if is_ac_event(args[2]) then
                        Shield.BlockedReports = Shield.BlockedReports + 1
                        return nil
                    end
                end
                return newInvoke(self, ...)
            end))
            Shield.GetHooked = true
            slog("Hook Remotes.Get OK")
        end)
    end

    return Shield.SendHooked or Shield.GetHooked
end

hook_remotes()

task.spawn(function()
    for _ = 1, 60 do
        if Shield.SendHooked and Shield.GetHooked then break end
        task.wait(1)
        hook_remotes()
    end
end)

local function hook_log_channels()
    local RS = game:GetService("ReplicatedStorage")
    local targets = {
        {name = "LogRequest",  class = "RemoteEvent"},
        {name = "ClientLog",   class = "RemoteEvent"},
    }
    local hooked = 0
    for _, t in ipairs(targets) do
        local remote = RS:FindFirstChild(t.name)
        if remote and remote:IsA(t.class) and not Shield["Log_" .. t.name .. "_Hooked"] then
            pcall(function()
                local oldFire = remote.FireServer
                local newFire
                newFire = hookfunction(oldFire, newcclosure(function(self, ...)
                    Shield.BlockedReports = Shield.BlockedReports + 1
                    swarn("Canal log bloqueado: " .. t.name)
                    return nil
                end))
                Shield["Log_" .. t.name .. "_Hooked"] = true
                Shield.LogHooked = true
                slog("Hook " .. t.name .. " OK")
                hooked = hooked + 1
            end)
        end
    end
    return hooked
end

hook_log_channels()

task.spawn(function()
    for _ = 1, 60 do
        if Shield.LogHooked then break end
        task.wait(1)
        hook_log_channels()
    end
end)

local function disable_ac_scripts()
    local n = 0
    local function scan(root)
        if not root then return end
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("LocalScript") and not obj.Disabled then
                if is_ac_script(obj.Name) then
                    pcall(function()
                        obj.Disabled = true
                        n = n + 1
                    end)
                end
            end
        end
    end
    pcall(function()
        local plr = game:GetService("Players").LocalPlayer
        if plr then
            scan(plr:FindFirstChild("PlayerGui"))
            scan(plr:FindFirstChild("PlayerScripts"))
            scan(plr.Character)
        end
        scan(game:GetService("ReplicatedFirst"))
        scan(game:GetService("ReplicatedStorage"))
        scan(game:GetService("StarterGui"))
    end)
    if n > 0 then
        Shield.DisabledScripts = Shield.DisabledScripts + n
        slog()
    end
    return n
end

disable_ac_scripts()

task.spawn(function()
    while Shield.Active do
        task.wait(12)
        pcall(disable_ac_scripts)
        pcall(hook_remotes)
        pcall(hook_log_channels)
    end
end)

pcall(function()
    game.DescendantAdded:Connect(function(obj)
        if not Shield.Active then return end

        if obj:IsA("LocalScript") and is_ac_script(obj.Name) then
            task.defer(function()
                pcall(function()
                    obj.Disabled = true
                    Shield.DisabledScripts = Shield.DisabledScripts + 1
                    swarn("Nuevo script AC desactivado: " .. tostring(obj.Name))
                end)
            end)
        end

        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = tostring(obj.Name)
            if n:find("IntegrityCheck", 1, true)
            or n:find("LogRequest", 1, true)
            or n:find("ClientLog", 1, true)
            or is_ac_event(n) then
                task.defer(function()
                    pcall(function()
                        if obj:IsA("RemoteEvent") then
                            local oldFire = obj.FireServer
                            local newFire
                            newFire = hookfunction(oldFire, newcclosure(function(self, ...)
                                Shield.BlockedReports = Shield.BlockedReports + 1
                                return nil
                            end))
                            swarn("Nuevo remote AC hookeado: " .. n)
                        end
                    end)
                end)
            end
        end
    end)
    Shield.DescendantHooked = true
end)

function Shield:Status()
    return string.format(
        "[RENHUB X XPLT COMUNITY v%s] Activo=%s | Kicks=%d | Reports=%d | Scripts=%d | LogHook=%s",
        self.Version, tostring(self.Active),
        self.BlockedKicks, self.BlockedReports, self.DisabledScripts,
        tostring(self.LogHooked)
    )
end

function Shield:Disable()
    self.Active = false
    slog("Desactivado manualmente")
end

slog("===========================================")
slog("RENHUB X XPLT COMUNITY BYPASS ACTIVADO v" .. Shield.Version)
slog("RENHUB X XPLT COMUNITY HUB V3")
slog("Kicks: bloqueados | Reports: bloqueados")
slog("LogRequest + ClientLog: hookeados")
slog("IntegrityCheck remotes: bloqueados via namecall")
slog("FlagCheck / Logs / ThanksRoblox: desactivados")
slog("Anti-cheat scripts: desactivados")
slog("GUIs protegidas: CHINOINFIERNOHUB + extras")
slog("===========================================")
slog("Debug: getgenv().MontanaShield:Status()")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RENHUB X XPLT COMUNITY",
        Text = "Shield v" .. Shield.Version .. " | Proteccion total activa",
        Duration = 6,
    })
end)

end -- fin instalación shield


-- ============================================================
-- [2] LOADER PRINCIPAL (después del shield)
-- ============================================================
getgenv().script_mode = "FARM" -- PVP, FARM
loadstring(game:HttpGet("https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"))()

-- ============================================================
-- [3] ESPERAR Y CONFIRMAR
-- ============================================================
task.spawn(function()
    task.wait(3)
    pcall(function()
        local sh = getgenv and getgenv().MontanaShield or _G.MontanaShield
        if sh and sh.Status then
            print(sh:Status())
        end
    end)
end)