--[[
=============================================================================
  🛡️ KWARPEX PROTECTOR SCRIPT v5.0 (DELTA EXECUTOR ED.) 🛡️
  NAME: "."
  PROTECTED AT: 2026-10-31T18:04:10.566Z
  SYSTEM: STRICT ANTI-TAMPER & ENVIRONMENT ENFORCEMENT
  STATUS: HEAVILY ENCRYPTED & TALISMAN WATERMARKED
=============================================================================
  ⛔ WARNING: DECOMPILATION OR TAMPERING IS STRICTLY PROHIBITED
  ⛔ محمي عبر kwarpex protector
=============================================================================
]]--

local _𐎀𐎁_kwarpex_233977 = (865317 * 0x51) -- ⚔️ kwarpex talisman guard
local _ΨΩ_talism_c18687 = (253240 * 0x9f) -- 🔱 kwarpex talisman guard
local _0x7F_shield_834ae2 = (800938 * 0xdc) -- 👁️ kwarpex talisman guard
local _ᚱᚢᚾᛖ_delta_173d1e = (883879 * 0xbe) -- ⚡ kwarpex talisman guard
local _𓀀𓀁_core_ceaf06 = (231251 * 0x67) -- 🗝️ kwarpex talisman guard
local _0x9E_ward_83a626 = (71132 * 0xac) -- 🗝️ kwarpex talisman guard
local _ᛏᛖᛗ_guard_e91413 = (572279 * 0x5f) -- 🧿 kwarpex talisman guard
local _0xBA_rune_5493c0 = (428865 * 0xf4) -- 🧿 kwarpex talisman guard

-- [[ PHASE 1: REAL DELTA EXECUTOR ENVIRONMENT VERIFICATION ]]
local function _KWARPEX_ENV_VALIDATE()
    local _isDelta = false
    local _executorName = "Unknown"

    pcall(function()
        if identifyexecutor then
            _executorName = tostring(identifyexecutor())
        elseif getexecutorname then
            _executorName = tostring(getexecutorname())
        end
    end)

    if string.find(string.lower(_executorName), "delta") then
        _isDelta = true
    end

    -- Additional Delta internal checks
    if not _isDelta then
        pcall(function()
            if DELTA_LOADED == true or (getgenv and getgenv().DELTA_LOADED == true) or (getgenv and getgenv().Delta ~= nil) then
                _isDelta = true
                _executorName = "Delta (Global)"
            end
        end)
    end

    if not _isDelta then
        -- Display Roblox in-game blocking GUI
        pcall(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
            if PlayerGui then
                local ScreenGui = Instance.new("ScreenGui")
                ScreenGui.Name = "KwarpexProtectorBlockedUI"
                ScreenGui.ResetOnSpawn = false
                ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                local MainFrame = Instance.new("Frame", ScreenGui)
                MainFrame.Size = UDim2.new(1, 0, 1, 0)
                MainFrame.Position = UDim2.new(0, 0, 0, 0)
                MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
                MainFrame.BackgroundTransparency = 0.05
                MainFrame.BorderSizePixel = 0

                local Border = Instance.new("Frame", MainFrame)
                Border.Size = UDim2.new(0.85, 0, 0.45, 0)
                Border.Position = UDim2.new(0.075, 0, 0.275, 0)
                Border.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                Border.BorderSizePixel = 2
                Border.BorderColor3 = Color3.fromRGB(239, 68, 68)

                local Title = Instance.new("TextLabel", Border)
                Title.Size = UDim2.new(1, 0, 0.25, 0)
                Title.Position = UDim2.new(0, 0, 0.05, 0)
                Title.BackgroundTransparency = 1
                Title.Text = "🛑 محمي عبر kwarpex protector 🛑"
                Title.TextColor3 = Color3.fromRGB(239, 68, 68)
                Title.TextSize = 24
                Title.Font = Enum.Font.GothamBold

                local Body = Instance.new("TextLabel", Border)
                Body.Size = UDim2.new(0.9, 0, 0.6, 0)
                Body.Position = UDim2.new(0.05, 0, 0.35, 0)
                Body.BackgroundTransparency = 1
                Body.Text = "الوصول مرفوض تماماً!
السكربت [.] محمي ومخصص فقط للتشغيل عبر محقن Delta Executor.
تم رصد بيئة غير مصرح بها وتم تجميد التنفيذ فوراً لحماية المحتوى."
                Body.TextColor3 = Color3.fromRGB(243, 244, 246)
                Body.TextSize = 16
                Body.TextWrapped = true
                Body.Font = Enum.Font.GothamMedium

                ScreenGui.Parent = PlayerGui
            end
        end)

        warn("================================================================")
        warn("❌ [kwarpex protector script] تم حظر التنفيذ!")
        warn("❌ السكربت محمي عبر kwarpex protector")
        warn("⚠️ المحقن المكتشف: " .. tostring(_executorName))
        warn("⚠️ هذا السكربت يتطلب Delta Executor حصرياً للعمل!")
        warn("================================================================")
        
        error("محمي عبر kwarpex protector - تشغيل غير مصرح به (ليس دلتا)")
        return false
    end

    return true
end

if not _KWARPEX_ENV_VALIDATE() then return end

-- [[ PHASE 2: ANTI-TAMPER & INTEGRITY SHIELD ]]
local function _KWARPEX_SHIELD()
    local _tampered = false
    pcall(function()
        if string.dump then
            local _d = string.dump(function() end)
            if not _d then _tampered = true end
        end
    end)
    if _tampered then
        error("محمي عبر kwarpex protector - درع الحماية تم اختراقه")
    end
end
_KWARPEX_SHIELD()

-- [[ PHASE 3: TALISMAN DECODER & DYNAMIC EXECUTION ]]
local _TALISMAN_CIPHER_BYTES = {
    156, -- 0xA0
}

local _KEY = 160
local _SHIFT = 14

local function _TALISMAN_DECODE(_data, _k, _s)
    local _chars = {}
    for _i = 1, #_data do
        local _val = _data[_i]
        local _unshifted = (_val - _s) % 256
        if _unshifted < 0 then _unshifted = _unshifted + 256 end
        local _byte = _unshifted ~ _k
        _chars[_i] = string.char(_byte)
    end
    return table.concat(_chars)
end

local _CLEAR_PAYLOAD = _TALISMAN_DECODE(_TALISMAN_CIPHER_BYTES, _KEY, _SHIFT)
local _RUNNER = assert((loadstring or load)(_CLEAR_PAYLOAD, "@kwarpex_protected_737"))

-- Execute payload safely
_RUNNER()
