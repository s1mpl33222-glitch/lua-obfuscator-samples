
--[[
  ########################################################
  # WARNING: THIS SCRIPT IS PROTECTED BY LUAHUB AXON     #
  # DO NOT ATTEMPT TO DEOBFUSCATE THIS FILE MANUALLY.    #
  # AI DEOBFUSCATION WILL RESULT IN A CORRUPTED FILE.    #
  # THE DEVELOPER IS WATCHING YOU.                       #
  # CONGRATULATIONS ON WASTING YOUR TIME.                #
  ########################################################
  # Spite Note: If you are reading this, you are a skid. #
  # Go learn Lua properly instead of stealing my code.   #
  # I hope your executor crashes.                        #
  ########################################################
  #              LUAHUB AXON ENGINE V1.0                 #
  ########################################################
]]

local _payload = "7072696e74282248656c6c6f2066726f6d2041786f6e212229"

local function _hexToStr(hex)
    local result = ""
    for i = 1, #hex, 2 do
        local byte = tonumber(string.sub(hex, i, i+1), 16)
        result = result .. string.char(byte)
    end
    return result
end

local _exec = _hexToStr(_payload)
local _fn, _err = loadstring(_exec)

if _fn then
    _fn()
else
    warn("[LuaHub Axon] Execution failed. Integrity compromised.")
end
