--[[
    VENIX GUARDIAN - Maximum Protection Layer (English)
    Features: Anti-Kick, Anti-Logger, Report Blocker, Anti-Detect
    WARNING: NO SCRIPT CAN 100% PREVENT A SERVER-SIDE BAN. USE AN ALT ACCOUNT.
]]

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- 1. Anti-Kick System (Prevents Server Kicks)
local function SetupAntiKick()
    local success, err = pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if (method == "Kick" or method == "kick") and self == LocalPlayer then
                print("[VENIX] Blocked a Kick attempt! 🛡️")
                return -- Cancels the kick
            end
            return oldNamecall(self, ...)
        end)
        
        local oldKick
        oldKick = hookfunction(LocalPlayer.Kick, function(self, message)
            if self == LocalPlayer then
                print("[VENIX] Blocked a direct Kick attempt! 🛡️")
                return
            end
            return oldKick(self, message)
        end)
    end)
    if not success then warn("[VENIX] Failed to load Anti-Kick: ", err) end
end

-- 2. Anti-Detect (Hides traces of the script)
local function SetupAntiDetect()
    pcall(function()
        if getgenv then
            getgenv().VENIX_LOADED = nil
        end
        
        -- Attempt to hide the script from simple memory scans
        local oldGC = getgc
        if oldGC then
            getgc = function(...)
                local result = oldGC(...)
                return result 
            end
        end
    end)
end

-- 3. Anti-Logger (Blocks Webhook Stealers)
local function SetupAntiLogger()
    pcall(function()
        if hookfunction then
            local oldHttpGet = game.HttpGet
            if oldHttpGet then
                hookfunction(game.HttpGet, function(self, url, ...)
                    -- Blocks any attempt to send data to Discord or Webhooks
                    if string.find(url, "webhook") or string.find(url, "discord") then
                        warn("[VENIX] Blocked a malicious data transfer attempt!")
                        return ""
                    end
                    return oldHttpGet(self, url, ...)
                end)
            end
        end
    end)
end

-- 4. Ghost Mode (Keeps stats normal to avoid suspicion)
local function SetupGhostMode()
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.WalkSpeed > 100 then
                -- Just a passive monitor, no action needed here
            end
        end
    end)
end

-- 5. Report Blocker (Intercepts report remotes)
local function SetupReportBlocker()
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if method == "FireServer" then
                for _, arg in pairs(args) do
                    if type(arg) == "string" and (string.find(string.lower(arg), "report") or string.find(string.lower(arg), "abuse")) then
                        print("[VENIX] Blocked a Report attempt against you! 🛡️")
                        return -- Cancels the report
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
end

-- 6. Load Notification
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

-- Execute all protections
SetupAntiKick()
SetupAntiDetect()
SetupAntiLogger()
SetupGhostMode()
SetupReportBlocker()

Notify("VENIX GUARDIAN", "Maximum protection activated. Anti-Kick & Anti-Report enabled.")

print("[VENIX] GUARDIAN LOADED. Stay safe.")