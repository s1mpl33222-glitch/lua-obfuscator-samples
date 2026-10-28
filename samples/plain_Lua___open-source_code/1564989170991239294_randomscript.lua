local envFingerprint
do
  local tempRoot, tempNode, tempConnection
  local verifySucceeded, verifyFingerprint = pcall(function()
    if
      ((type(typeof) ~= "function") or (type(Instance) ~= "table")) or (type(Instance.new) ~= "function")
    then
      return false
    end
    if
      (((type(game) ~= "userdata") or (typeof(game) ~= "Instance")) or (game.ClassName ~= "DataModel"))
      or not game:IsA("DataModel")
    then
      return false
    end
    local runService = game:GetService("RunService")
    if
      ((typeof(runService) ~= "Instance") or not runService:IsA("RunService")) or (runService.Parent ~= game)
    then
      return false
    end
    if (runService ~= game:GetService("RunService")) or (type(runService:IsStudio()) ~= "boolean") then
      return false
    end
    if typeof(runService.Heartbeat) ~= "RBXScriptSignal" then
      return false
    end
    local playersService = game:GetService("Players")
    if
      ((typeof(playersService) ~= "Instance") or not playersService:IsA("Players"))
      or (playersService.Parent ~= game)
    then
      return false
    end
    if playersService ~= game:GetService("Players") then
      return false
    end
    local workspaceService = game:GetService("Workspace")
    if
      (
        ((typeof(workspaceService) ~= "Instance") or not workspaceService:IsA("Workspace"))
        or (workspaceService.Parent ~= game)
      ) or (workspaceService ~= workspace)
    then
      return false
    end
    if ((type(Vector3) ~= "table") or (type(CFrame) ~= "table")) or (type(Enum) ~= "userdata") then
      return false
    end
    local probeVector = Vector3.new(94, 24, 49)
    if
      (((typeof(probeVector) ~= "Vector3") or (probeVector.X ~= 94)) or (probeVector.Y ~= 24))
      or (probeVector.Z ~= 49)
    then
      return false
    end
    local probeSum = probeVector + Vector3.new(1, 2, 3)
    if ((probeSum.X ~= 95) or (probeSum.Y ~= 26)) or (probeSum.Z ~= 52) then
      return false
    end
    local probeCFrame = CFrame.new(probeVector)
    if (typeof(probeCFrame) ~= "CFrame") or (probeCFrame.Position ~= probeVector) then
      return false
    end
    if (typeof(Enum.KeyCode.Unknown) ~= "EnumItem") or (Enum.KeyCode.Unknown.EnumType ~= Enum.KeyCode) then
      return false
    end
    tempRoot = Instance.new("Folder")
    tempNode = Instance.new("Folder")
    if ((type(tempRoot) ~= "userdata") or (typeof(tempRoot) ~= "Instance")) or not tempRoot:IsA("Folder") then
      return false
    end
    tempNode.Name = "v1d7bc494cec52fc1"
    tempNode.Parent = tempRoot
    tempNode:SetAttribute("a137ff265f7ff179c", 569500)
    if
      (tempRoot:FindFirstChild("v1d7bc494cec52fc1") ~= tempNode) or not tempNode:IsDescendantOf(tempRoot)
    then
      return false
    end
    if tempNode:GetAttribute("a137ff265f7ff179c") ~= 569500 then
      return false
    end
    local changedSignal = tempNode:GetAttributeChangedSignal("a137ff265f7ff179c")
    if typeof(changedSignal) ~= "RBXScriptSignal" then
      return false
    end
    tempConnection = changedSignal:Connect(function() end)
    if (typeof(tempConnection) ~= "RBXScriptConnection") or not tempConnection.Connected then
      return false
    end
    tempConnection:Disconnect()
    if tempConnection.Connected then
      return false
    end
    local fingerprintParts =
      { probeVector.X, probeSum.Y, probeCFrame.Position.Z, tempNode:GetAttribute("a137ff265f7ff179c") }
    tempRoot:Destroy()
    if tempNode.Parent ~= nil then
      return false
    end
    return {
      (
        (((fingerprintParts[1] * 27958) + (fingerprintParts[2] * 49913)) + (fingerprintParts[3] * 28590))
        + (fingerprintParts[4] * 40252)
      ) % 4294967296,
      (
        (((fingerprintParts[1] * 49479) + (fingerprintParts[2] * 43894)) + (fingerprintParts[3] * 34485))
        + (fingerprintParts[4] * 3531)
      ) % 4294967296,
      (
        (((fingerprintParts[1] * 5942) + (fingerprintParts[2] * 24019)) + (fingerprintParts[3] * 54967))
        + (fingerprintParts[4] * 27275)
      ) % 4294967296,
      (
        (((fingerprintParts[1] * 43297) + (fingerprintParts[2] * 45296)) + (fingerprintParts[3] * 59980))
        + (fingerprintParts[4] * 49476)
      ) % 4294967296,
      (
        (((fingerprintParts[1] * 19758) + (fingerprintParts[2] * 32185)) + (fingerprintParts[3] * 44165))
        + (fingerprintParts[4] * 32126)
      ) % 4294967296,
      (
        (((fingerprintParts[1] * 42021) + (fingerprintParts[2] * 36893)) + (fingerprintParts[3] * 47065))
        + (fingerprintParts[4] * 21547)
      ) % 4294967296,
      (
        (((fingerprintParts[1] * 59067) + (fingerprintParts[2] * 8178)) + (fingerprintParts[3] * 56594))
        + (fingerprintParts[4] * 52617)
      ) % 4294967296,
      (
        (((fingerprintParts[1] * 19610) + (fingerprintParts[2] * 30350)) + (fingerprintParts[3] * 43798))
        + (fingerprintParts[4] * 36367)
      ) % 4294967296,
    }
  end)
  if tempConnection then
    pcall(function()
      tempConnection:Disconnect()
    end)
  end
  if tempNode then
    pcall(function()
      tempNode:Destroy()
    end)
  end
  if tempRoot then
    pcall(function()
      tempRoot:Destroy()
    end)
  end
  if (not verifySucceeded or (type(verifyFingerprint) ~= "table")) or (#verifyFingerprint ~= 8) then
    error("Roblox environment verification failed", 0)
  end
  envFingerprint = verifyFingerprint
end
local globalEnv = (getfenv and getfenv()) or _ENV
local isLuau = (_VERSION == "Luau") or ((type(typeof) == "function") and (type(bit32) == "table"))
local unpackArgs = table.unpack or unpack
local chr, concatStr, strSub, toNumber = string.char, table.concat, string.sub, tonumber
local typeOf, nextPair, getMetaTable, vmError, selectN, toStr =
  type, next, getmetatable, error, select, tostring
local rawGetField, setMetaTable, newProxyObject = rawget, setmetatable, newproxy
local getFenvFn, setFenvFn, pcallFn = getfenv, setfenv, pcall
local getRawMetaFn, setNamecallFn = globalEnv.getrawmetatable, globalEnv.setnamecallmethod
local proxyRegistry = setMetaTable({}, { __mode = "kv" })
local function packArgs(...)
  return { argCount = selectN("#", ...), ... }
end
local function getEnvOf(fn, fallbackEnv)
  if (typeOf(getFenvFn) == "function") and fn then
    return getFenvFn(fn)
  end
  return fallbackEnv
end
local fastNamecall = {
  ["GetService"] = function(target, args)
    return target:GetService(unpackArgs(args, 2, args.argCount))
  end,
  ["HttpGet"] = function(target, args)
    return target:HttpGet(unpackArgs(args, 2, args.argCount))
  end,
}
local function dispatchNamecall(target, method, args)
  if isLuau and (typeOf(target) == "userdata") then
    local handler = fastNamecall[method]
    if handler then
      return handler(target, args)
    end
  end
  if
    ((typeOf(target) == "userdata") and (typeOf(getRawMetaFn) == "function"))
    and (typeOf(setNamecallFn) == "function")
  then
    local ok, meta = pcallFn(getRawMetaFn, target)
    local namecall = (ok and (typeOf(meta) == "table")) and rawGetField(meta, "__namecall")
    if typeOf(namecall) == "function" then
      setNamecallFn(method)
      return namecall(unpackArgs(args, 1, args.argCount))
    end
  end
  return target[method](unpackArgs(args, 1, args.argCount))
end
local function copyTable(tag)
  local result = {}
  for k2, v2 in nextPair, tag do
    result[k2] = v2
  end
  return result
end
local EMPTY_ARGS = { argCount = 0 }
if typeOf(bit32) ~= "table" then
  vmError("hardened VM requires Luau bit32; use --no-hardening for standard Lua")
end
local bxor, band, rol, rshift = bit32.bxor, bit32.band, bit32.lrotate, bit32.rshift
local bnot = bit32.bnot
local strByte, strGsub = string.byte, string.gsub
local stringUnpack = ((typeOf(string.unpack) == "function") and string.unpack) or nil
local strRep = string.rep
local tableFreeze = ((typeOf(table.freeze) == "function") and table.freeze) or nil
local PACK_FORMATS = { "<I1", "<I2", "<I3", "<I4" }
local packFormatCache = { {}, {}, {}, {} }
local function deepFreeze(value)
  if not tableFreeze then
    return value
  end
  for k1, v1 in nextPair, value do
    if typeOf(v1) == "table" then
      deepFreeze(v1)
    end
  end
  return tableFreeze(value)
end
local envSalt
do
  local probeSalt, probeMix = 3136210318, 2004992395
  local function probeFunction(value, ...)
    local baseIndex, flagArg = ...

    return rol(bxor((probeSalt + value) % 4294967296, probeMix), 18), baseIndex, flagArg, selectN("#", ...)
  end
  local function probeArithmetic(b0, b1)
    return b0 - b1
  end
  local ok, number, baseIndex, flagArg, count = pcall(probeFunction, 3270417427, nil, false)
  local probeOk = (((ok and (typeOf(number) == "number")) and (number >= 0)) and (number <= 4294967295))
    and ((number % 1) == 0)
  probeOk = (((probeOk and (baseIndex == nil)) and (flagArg == false)) and (count == 2))
    and (probeArithmetic(17, 9) == 8)
  local debugInfo = (typeOf(debug) == "table") and debug.info
  if typeOf(debugInfo) == "function" then
    local infoOk, infoParams, infoVararg, infoFunc = pcall(debugInfo, probeFunction, "af")
    probeOk = (((probeOk and infoOk) and (infoParams == 1)) and (infoVararg == true))
      and (infoFunc == probeFunction)
    local infoOk2, infoParams2, infoVararg2, infoFunc2 = pcall(debugInfo, probeArithmetic, "af")
    probeOk = (((probeOk and infoOk2) and (infoParams2 == 2)) and (infoVararg2 == false))
      and (infoFunc2 == probeArithmetic)
    local invalidQueryOk = pcall(debugInfo, probeFunction, "?")
    probeOk = probeOk and not invalidQueryOk
  end
  if not probeOk then
    number = 1383805133
  end
  envSalt = number
end
local vmMasterKey = {
  bxor(1398199958, 1540690586, envSalt, envFingerprint[1]),
  bxor(1161594850, 901505982, envSalt, envFingerprint[2]),
  bxor(1901616311, 1211890930, envSalt, envFingerprint[3]),
  bxor(2800363502, 2657855497, envSalt, envFingerprint[4]),
  bxor(26103128, 594504697, envSalt, envFingerprint[5]),
  bxor(2480967156, 3980343892, envSalt, envFingerprint[6]),
  bxor(3214812824, 3040942521, envSalt, envFingerprint[7]),
  bxor(3447651384, 3460879202, envSalt, envFingerprint[8]),
}
local stringPack = ((typeOf(string.pack) == "function") and string.pack) or nil
local PACK16_FORMAT = "<I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4"
local function chacha20Crypt(buffer, keyWords, packetNonce, counterStart)
  local blocks = {}
  local counter = counterStart or 1
  for offset = 1, #buffer, 64 do
    local x1, x2, x3, x4 = 1634760805, 857760878, 2036477234, 1797285236
    local v1, v2, v3, v4, v5, v6, v7, v8 =
      keyWords[1], keyWords[2], keyWords[3], keyWords[4], keyWords[5], keyWords[6], keyWords[7], keyWords[8]
    local v9, v10, v11, v12 = counter, packetNonce[1], packetNonce[2], packetNonce[3]
    for round = 1, 10 do
      x1 = (x1 + v1) % 4294967296
      v9 = rol(bxor(v9, x1), 16)
      v5 = (v5 + v9) % 4294967296
      v1 = rol(bxor(v1, v5), 12)
      x1 = (x1 + v1) % 4294967296
      v9 = rol(bxor(v9, x1), 8)
      v5 = (v5 + v9) % 4294967296
      v1 = rol(bxor(v1, v5), 7)
      x2 = (x2 + v2) % 4294967296
      v10 = rol(bxor(v10, x2), 16)
      v6 = (v6 + v10) % 4294967296
      v2 = rol(bxor(v2, v6), 12)
      x2 = (x2 + v2) % 4294967296
      v10 = rol(bxor(v10, x2), 8)
      v6 = (v6 + v10) % 4294967296
      v2 = rol(bxor(v2, v6), 7)
      x3 = (x3 + v3) % 4294967296
      v11 = rol(bxor(v11, x3), 16)
      v7 = (v7 + v11) % 4294967296
      v3 = rol(bxor(v3, v7), 12)
      x3 = (x3 + v3) % 4294967296
      v11 = rol(bxor(v11, x3), 8)
      v7 = (v7 + v11) % 4294967296
      v3 = rol(bxor(v3, v7), 7)
      x4 = (x4 + v4) % 4294967296
      v12 = rol(bxor(v12, x4), 16)
      v8 = (v8 + v12) % 4294967296
      v4 = rol(bxor(v4, v8), 12)
      x4 = (x4 + v4) % 4294967296
      v12 = rol(bxor(v12, x4), 8)
      v8 = (v8 + v12) % 4294967296
      v4 = rol(bxor(v4, v8), 7)
      x1 = (x1 + v2) % 4294967296
      v12 = rol(bxor(v12, x1), 16)
      v7 = (v7 + v12) % 4294967296
      v2 = rol(bxor(v2, v7), 12)
      x1 = (x1 + v2) % 4294967296
      v12 = rol(bxor(v12, x1), 8)
      v7 = (v7 + v12) % 4294967296
      v2 = rol(bxor(v2, v7), 7)
      x2 = (x2 + v3) % 4294967296
      v9 = rol(bxor(v9, x2), 16)
      v8 = (v8 + v9) % 4294967296
      v3 = rol(bxor(v3, v8), 12)
      x2 = (x2 + v3) % 4294967296
      v9 = rol(bxor(v9, x2), 8)
      v8 = (v8 + v9) % 4294967296
      v3 = rol(bxor(v3, v8), 7)
      x3 = (x3 + v4) % 4294967296
      v10 = rol(bxor(v10, x3), 16)
      v5 = (v5 + v10) % 4294967296
      v4 = rol(bxor(v4, v5), 12)
      x3 = (x3 + v4) % 4294967296
      v10 = rol(bxor(v10, x3), 8)
      v5 = (v5 + v10) % 4294967296
      v4 = rol(bxor(v4, v5), 7)
      x4 = (x4 + v1) % 4294967296
      v11 = rol(bxor(v11, x4), 16)
      v6 = (v6 + v11) % 4294967296
      v1 = rol(bxor(v1, v6), 12)
      x4 = (x4 + v1) % 4294967296
      v11 = rol(bxor(v11, x4), 8)
      v6 = (v6 + v11) % 4294967296
      v1 = rol(bxor(v1, v6), 7)
    end
    local wordTable = {
      (x1 + 1634760805) % 4294967296,
      (x2 + 857760878) % 4294967296,
      (x3 + 2036477234) % 4294967296,
      (x4 + 1797285236) % 4294967296,
      (v1 + keyWords[1]) % 4294967296,
      (v2 + keyWords[2]) % 4294967296,
      (v3 + keyWords[3]) % 4294967296,
      (v4 + keyWords[4]) % 4294967296,
      (v5 + keyWords[5]) % 4294967296,
      (v6 + keyWords[6]) % 4294967296,
      (v7 + keyWords[7]) % 4294967296,
      (v8 + keyWords[8]) % 4294967296,
      (v9 + counter) % 4294967296,
      (v10 + packetNonce[1]) % 4294967296,
      (v11 + packetNonce[2]) % 4294967296,
      (v12 + packetNonce[3]) % 4294967296,
    }
    if (((offset + 63) <= #buffer) and stringUnpack) and stringPack then
      local w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15 =
        stringUnpack(PACK16_FORMAT, buffer, offset)
      blocks[#blocks + 1] = stringPack(
        PACK16_FORMAT,
        bxor(w0, wordTable[1]),
        bxor(w1, wordTable[2]),
        bxor(w2, wordTable[3]),
        bxor(w3, wordTable[4]),
        bxor(w4, wordTable[5]),
        bxor(w5, wordTable[6]),
        bxor(w6, wordTable[7]),
        bxor(w7, wordTable[8]),
        bxor(w8, wordTable[9]),
        bxor(w9, wordTable[10]),
        bxor(w10, wordTable[11]),
        bxor(w11, wordTable[12]),
        bxor(w12, wordTable[13]),
        bxor(w13, wordTable[14]),
        bxor(w14, wordTable[15]),
        bxor(w15, wordTable[16])
      )
    else
      for i = 1, 16 do
        local pos = offset + ((i - 1) * 4)
        if (pos + 3) <= #buffer then
          local b0, b1, b2, b3 = strByte(buffer, pos, pos + 3)
          local number = wordTable[i]
          blocks[#blocks + 1] = chr(
            bxor(b0, band(number, 255)),
            bxor(b1, band(rshift(number, 8), 255)),
            bxor(b2, band(rshift(number, 16), 255)),
            bxor(b3, rshift(number, 24))
          )
        else
          for j = 0, 3 do
            if (pos + j) <= #buffer then
              blocks[#blocks + 1] =
                chr(bxor(strByte(buffer, pos + j), band(rshift(wordTable[i], j * 8), 255)))
            end
          end
        end
      end
    end
    counter = counter + 1
  end
  return concatStr(blocks)
end
local floorValue, borBits, minValue = math.floor, bit32.bor, math.min
local function addBits(limbs, readByte, bitPos)
  local limbIndex = floorValue(bitPos / 13) + 1
  local value = readByte * (2 ^ (bitPos % 13))
  limbs[limbIndex] = limbs[limbIndex] + (value % 8192)
  if ((bitPos % 13) > 5) and (limbIndex < 10) then
    limbs[limbIndex + 1] = limbs[limbIndex + 1] + floorValue(value / 8192)
  end
end
local function poly1305Tag(buffer, keyStream)
  local result, accumulator = {}, {}
  for i = 1, 10 do
    result[i] = 0
    accumulator[i] = 0
  end
  for i2 = 0, 15 do
    local readByte = strByte(keyStream, i2 + 1)
    if (((i2 == 3) or (i2 == 7)) or (i2 == 11)) or (i2 == 15) then
      readByte = band(readByte, 15)
    elseif ((i2 == 4) or (i2 == 8)) or (i2 == 12) then
      readByte = band(readByte, 252)
    end
    addBits(result, readByte, i2 * 8)
  end
  local h0, h1, h2, h3, h4, h5, h6, h7, h8, h9 =
    result[1],
    result[2],
    result[3],
    result[4],
    result[5],
    result[6],
    result[7],
    result[8],
    result[9],
    result[10]
  local g0, g1, g2, g3, g4, g5, g6, g7, g8 =
    h1 * 5, h2 * 5, h3 * 5, h4 * 5, h5 * 5, h6 * 5, h7 * 5, h8 * 5, h9 * 5
  for offset = 1, #buffer, 16 do
    local chunkLen = minValue(16, (#buffer - offset) + 1)
    if (chunkLen == 16) and stringUnpack then
      local b0, b1, b2, b3 = stringUnpack("<I4I4I4I4", buffer, offset)
      accumulator[1] = accumulator[1] + (b0 % 8192)
      accumulator[2] = accumulator[2] + (floorValue(b0 / 8192) % 8192)
      accumulator[3] = (accumulator[3] + floorValue(b0 / 67108864)) + ((b1 % 128) * 64)
      accumulator[4] = accumulator[4] + (floorValue(b1 / 128) % 8192)
      accumulator[5] = (accumulator[5] + floorValue(b1 / 1048576)) + ((b2 % 2) * 4096)
      accumulator[6] = accumulator[6] + (floorValue(b2 / 2) % 8192)
      accumulator[7] = accumulator[7] + (floorValue(b2 / 16384) % 8192)
      accumulator[8] = (accumulator[8] + floorValue(b2 / 134217728)) + ((b3 % 256) * 32)
      accumulator[9] = accumulator[9] + (floorValue(b3 / 256) % 8192)
      accumulator[10] = (accumulator[10] + floorValue(b3 / 2097152)) + 2048
    else
      for i3 = 0, chunkLen - 1 do
        addBits(accumulator, strByte(buffer, offset + i3), i3 * 8)
      end
      addBits(accumulator, 1, chunkLen * 8)
    end
    local a0, a1, a2, a3, a4, a5, a6, a7, a8, a9 =
      accumulator[1],
      accumulator[2],
      accumulator[3],
      accumulator[4],
      accumulator[5],
      accumulator[6],
      accumulator[7],
      accumulator[8],
      accumulator[9],
      accumulator[10]
    accumulator[1] = (
      (
        (((((((a0 * h0) + (a1 * g8)) + (a2 * g7)) + (a3 * g6)) + (a4 * g5)) + (a5 * g4)) + (a6 * g3))
        + (a7 * g2)
      ) + (a8 * g1)
    ) + (a9 * g0)
    accumulator[2] = (
      (
        (((((((a0 * h1) + (a1 * h0)) + (a2 * g8)) + (a3 * g7)) + (a4 * g6)) + (a5 * g5)) + (a6 * g4))
        + (a7 * g3)
      ) + (a8 * g2)
    ) + (a9 * g1)
    accumulator[3] = (
      (
        (((((((a0 * h2) + (a1 * h1)) + (a2 * h0)) + (a3 * g8)) + (a4 * g7)) + (a5 * g6)) + (a6 * g5))
        + (a7 * g4)
      ) + (a8 * g3)
    ) + (a9 * g2)
    accumulator[4] = (
      (
        (((((((a0 * h3) + (a1 * h2)) + (a2 * h1)) + (a3 * h0)) + (a4 * g8)) + (a5 * g7)) + (a6 * g6))
        + (a7 * g5)
      ) + (a8 * g4)
    ) + (a9 * g3)
    accumulator[5] = (
      (
        (((((((a0 * h4) + (a1 * h3)) + (a2 * h2)) + (a3 * h1)) + (a4 * h0)) + (a5 * g8)) + (a6 * g7))
        + (a7 * g6)
      ) + (a8 * g5)
    ) + (a9 * g4)
    accumulator[6] = (
      (
        (((((((a0 * h5) + (a1 * h4)) + (a2 * h3)) + (a3 * h2)) + (a4 * h1)) + (a5 * h0)) + (a6 * g8))
        + (a7 * g7)
      ) + (a8 * g6)
    ) + (a9 * g5)
    accumulator[7] = (
      (
        (((((((a0 * h6) + (a1 * h5)) + (a2 * h4)) + (a3 * h3)) + (a4 * h2)) + (a5 * h1)) + (a6 * h0))
        + (a7 * g8)
      ) + (a8 * g7)
    ) + (a9 * g6)
    accumulator[8] = (
      (
        (((((((a0 * h7) + (a1 * h6)) + (a2 * h5)) + (a3 * h4)) + (a4 * h3)) + (a5 * h2)) + (a6 * h1))
        + (a7 * h0)
      ) + (a8 * g8)
    ) + (a9 * g7)
    accumulator[9] = (
      (
        (((((((a0 * h8) + (a1 * h7)) + (a2 * h6)) + (a3 * h5)) + (a4 * h4)) + (a5 * h3)) + (a6 * h2))
        + (a7 * h1)
      ) + (a8 * h0)
    ) + (a9 * g8)
    accumulator[10] = (
      (
        (((((((a0 * h9) + (a1 * h8)) + (a2 * h7)) + (a3 * h6)) + (a4 * h5)) + (a5 * h4)) + (a6 * h3))
        + (a7 * h2)
      ) + (a8 * h1)
    ) + (a9 * h0)
    local carry
    repeat
      carry = 0
      for i3 = 1, 10 do
        local value = accumulator[i3] + carry
        accumulator[i3] = value % 8192
        carry = floorValue(value / 8192)
      end
      accumulator[1] = accumulator[1] + (carry * 5)
    until carry == 0
  end
  local isMax = accumulator[1] >= 8187
  for i3 = 2, 10 do
    if accumulator[i3] ~= 8191 then
      isMax = false
    end
  end
  if isMax then
    accumulator[1] = accumulator[1] - 8187
    for i4 = 2, 10 do
      accumulator[i4] = 0
    end
  end
  local packetTag = {}
  local carry = 0
  for i4 = 0, 15 do
    local bitPos = i4 * 8
    local limbIndex = floorValue(bitPos / 13) + 1
    local bitOffset = bitPos % 13
    local readByte = floorValue(accumulator[limbIndex] / (2 ^ bitOffset))
    if bitOffset > 5 then
      readByte = readByte + (accumulator[limbIndex + 1] * (2 ^ (13 - bitOffset)))
    end
    local value = ((readByte % 256) + strByte(keyStream, 17 + i4)) + carry
    packetTag[i4 + 1] = chr(value % 256)
    carry = floorValue(value / 256)
  end
  return concatStr(packetTag)
end
local function u32Bytes(value)
  local bytes = {}
  for i = 1, 8 do
    bytes[i] = chr(value % 256)
    value = floorValue(value / 256)
  end
  return concatStr(bytes)
end
local function computeAuthTag(packetBody, keyWords, packetNonce)
  local MAGIC = "RBXVM2"
  local zeroBlock = strRep(chr(0), 32)
  local keyStream = chacha20Crypt(strSub(zeroBlock, 1, 32), keyWords, packetNonce, 0)
  local tagInput = MAGIC
    .. (
      strSub(zeroBlock, 1, -#MAGIC % 16)
      .. (
        packetBody
        .. (strSub(zeroBlock, 1, -#packetBody % 16) .. (u32Bytes(#MAGIC) .. u32Bytes(#packetBody)))
      )
    )
  return poly1305Tag(tagInput, keyStream)
end
local function deriveKey(blockId, capability)
  local value = rol(
    (
      borBits((bxor(blockId, capability) * 36167) % 4294967296, 3365469579)
      + band((bxor(blockId, capability) * 36167) % 4294967296, 3365469579)
    ) % 4294967296,
    10
  )
  value = bxor(value, rshift(value, 16))
  return value
end
local function transitionPair(pair, state, capability)
  if (typeOf(pair) ~= "table") or (#pair ~= 2) then
    vmError("invalid VM transition")
  end
  local shifted = deriveKey(state, capability)
  return bxor(pair[1], shifted), bxor(pair[2], rol(shifted, 11))
end
local function deriveBlockKeys(saltBase, blockId, blockCapability)
  if
    (((typeOf(blockCapability) ~= "number") or (blockCapability < 0)) or (blockCapability > 4294967295))
    or ((blockCapability % 1) ~= 0)
  then
    vmError("invalid VM block capability")
  end
  local seed = deriveKey(blockId, blockCapability)
  local k0 = rol(
    (((bxor(bxor(saltBase[1], seed), (blockId + 3365469579) % 4294967296) * 36167) % 4294967296) + 3365469579)
      % 4294967296,
    10
  )
  k0 = bxor(k0, rshift(k0, 16))
  seed = k0
  local k1 = rol(
    (
      borBits(
        (bxor(bxor(saltBase[2], seed), (blockId + 6730939158) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
      + band(
        (bxor(bxor(saltBase[2], seed), (blockId + 6730939158) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
    ) % 4294967296,
    10
  )
  k1 = bxor(k1, rshift(k1, 16))
  seed = k1
  local k2 = rol(
    (
      borBits(
        (bxor(bxor(saltBase[3], seed), (blockId + 10096408737) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
      + band(
        (bxor(bxor(saltBase[3], seed), (blockId + 10096408737) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
    ) % 4294967296,
    10
  )
  k2 = bxor(k2, rshift(k2, 16))
  seed = k2
  local k3 = rol(
    (
      ((bxor(bxor(saltBase[4], seed), (blockId + 13461878316) % 4294967296) * 36167) % 4294967296) + 3365469579
    ) % 4294967296,
    10
  )
  k3 = bxor(k3, rshift(k3, 16))
  seed = k3
  local k4 = rol(
    (
      borBits(
        (bxor(bxor(saltBase[5], seed), (blockId + 16827347895) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
      + band(
        (bxor(bxor(saltBase[5], seed), (blockId + 16827347895) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
    ) % 4294967296,
    10
  )
  k4 = bxor(k4, rshift(k4, 16))
  seed = k4
  local k5 = rol(
    (
      borBits(
        (bxor(bxor(saltBase[6], seed), (blockId + 20192817474) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
      + band(
        (bxor(bxor(saltBase[6], seed), (blockId + 20192817474) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
    ) % 4294967296,
    10
  )
  k5 = bxor(k5, rshift(k5, 16))
  seed = k5
  local k6 = rol(
    (
      borBits(
        (bxor(bxor(saltBase[7], seed), (blockId + 23558287053) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
      + band(
        (bxor(bxor(saltBase[7], seed), (blockId + 23558287053) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
    ) % 4294967296,
    10
  )
  k6 = bxor(k6, rshift(k6, 16))
  seed = k6
  local k7 = rol(
    (
      borBits(
        (bxor(bxor(saltBase[8], seed), (blockId + 26923756632) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
      + band(
        (bxor(bxor(saltBase[8], seed), (blockId + 26923756632) % 4294967296) * 36167) % 4294967296,
        3365469579
      )
    ) % 4294967296,
    10
  )
  k7 = bxor(k7, rshift(k7, 16))
  seed = k7
  return { k0, k1, k2, k3, k4, k5, k6, k7 }
end
local function unmaskKey(packet)
  local wordTable = {
    packet[27200],
    packet[37035],
    packet[63968],
    packet[22337],
    packet[11092],
    packet[41993],
    packet[52656],
    packet[47956],
  }
  for i = 1, 8 do
    local number = wordTable[i]
    if (((typeOf(number) ~= "number") or (number < 0)) or (number > 4294967295)) or ((number % 1) ~= 0) then
      vmError("invalid VM packet key")
    end
  end
  return {
    bxor(wordTable[1], 3425530259, envSalt),
    bxor(wordTable[2], 135260372, envSalt),
    bxor(wordTable[3], 2943194001, envSalt),
    bxor(wordTable[4], 2143492518, envSalt),
    bxor(wordTable[5], 3409338475, envSalt),
    bxor(wordTable[6], 3186848619, envSalt),
    bxor(wordTable[7], 3713712065, envSalt),
    bxor(wordTable[8], 4057729383, envSalt),
  }
end
local function openPacket(packetInfo, keyWords)
  if (typeOf(packetInfo) ~= "table") or (typeOf(keyWords) ~= "table") then
    vmError("invalid VM packet key")
  end
  if #keyWords ~= 8 then
    keyWords = unmaskKey(keyWords)
  end
  local packetNonce = packetInfo[2]
  if (typeOf(packetNonce) ~= "table") or (#packetNonce ~= 3) then
    vmError("invalid VM packet nonce")
  end
  for i = 1, 8 do
    local number = keyWords[i]
    if (((typeOf(number) ~= "number") or (number < 0)) or (number > 4294967295)) or ((number % 1) ~= 0) then
      vmError("invalid VM packet key")
    end
  end
  for i2 = 1, 3 do
    local number = packetNonce[i2]
    if (((typeOf(number) ~= "number") or (number < 0)) or (number > 4294967295)) or ((number % 1) ~= 0) then
      vmError("invalid VM packet nonce")
    end
  end
  local packetBody = packetInfo[1]
  if (typeOf(packetBody) ~= "string") or (#packetBody ~= packetInfo[3]) then
    vmError("damaged VM packet length")
  end
  local packetTag = packetInfo[4]
  if (typeOf(packetTag) ~= "string") or (#packetTag ~= 16) then
    vmError("invalid VM authentication tag")
  end
  local expectedTag = computeAuthTag(packetBody, keyWords, packetNonce)
  local tagDiff = 0
  for i3 = 1, 16 do
    tagDiff = borBits(tagDiff, bxor(strByte(expectedTag, i3), strByte(packetTag, i3)))
  end
  if tagDiff ~= 0 then
    vmError("VM packet authentication failed")
  end
  return chacha20Crypt(packetBody, keyWords, packetNonce)
end
local function decodePacket(buffer)
  local pos = 1
  local function readByte()
    local value = strByte(buffer, pos)
    if value == nil then
      vmError("truncated VM packet")
    end
    pos = pos + 1
    return value
  end
  local function readVarInt()
    local valueLength, multiplier = 0, 1
    for i = 1, 5 do
      local b1 = readByte()
      valueLength = valueLength + ((b1 % 128) * multiplier)
      if b1 < 128 then
        if valueLength > 4294967295 then
          vmError("oversized VM integer")
        end
        return valueLength
      end
      multiplier = multiplier * 128
    end
    vmError("invalid VM integer")
  end
  local nonceA, nonceB
  local function readPackedWord(width)
    if ((pos + width) - 1) > #buffer then
      vmError("truncated VM packed word")
    end
    if stringUnpack then
      local value
      value, pos = stringUnpack(PACK_FORMATS[width], buffer, pos)
      return value
    end
    local b0, b1, b2, b3 = strByte(buffer, pos, (pos + width) - 1)
    pos = pos + width
    if width == 1 then
      return b0
    elseif width == 2 then
      return b0 + (b1 * 256)
    elseif width == 3 then
      return (b0 + (b1 * 256)) + (b2 * 65536)
    end
    return ((b0 + (b1 * 256)) + (b2 * 65536)) + (b3 * 16777216)
  end
  local function readPackedWords(count, width)
    if count > (((#buffer - pos) + 1) / width) then
      vmError("truncated VM packed words")
    end
    if count == 0 then
      return {}
    end
    if stringUnpack and (count <= 64) then
      local formatCacheEntry = packFormatCache[width]
      local format = formatCacheEntry[count]
      if not format then
        format = "<" .. strRep("I" .. width, count)
        formatCacheEntry[count] = format
      end
      local values = { stringUnpack(format, buffer, pos) }
      pos = values[count + 1]
      values[count + 1] = nil
      return values
    end
    local values = {}
    for i = 1, count do
      values[i] = readPackedWord(width)
    end
    return values
  end
  local function packetInfo()
    local noncePrefix = readByte()
    if noncePrefix == 1 then
      nonceA = readPackedWord(4)
      nonceB = readPackedWord(4)
    elseif (noncePrefix ~= 0) or (nonceA == nil) then
      vmError("invalid VM packed nonce prefix")
    end
    local counter, chunkLen = readVarInt(), readVarInt()
    if chunkLen > ((#buffer - pos) - 15) then
      vmError("truncated VM packed packet")
    end
    local body = strSub(buffer, pos, (pos + chunkLen) - 1)
    pos = pos + chunkLen
    local packetTag = strSub(buffer, pos, pos + 15)
    pos = pos + 16
    return { body, { nonceA, nonceB, counter }, chunkLen, packetTag }
  end
  local function readRecords(depth, readValue)
    local count = readVarInt()
    local width, layoutKey, layoutValue, layoutExtra = readByte(), readByte(), readByte(), readByte()
    if
      (
        (
          (
            (
              (
                (
                  ((((width < 3) or (width > 16)) or (layoutKey < 1)) or (layoutKey > width))
                  or (layoutValue < 1)
                ) or (layoutValue > width)
              ) or (layoutExtra < 1)
            ) or (layoutExtra > width)
          ) or (layoutKey == layoutValue)
        ) or (layoutKey == layoutExtra)
      ) or (layoutValue == layoutExtra)
    then
      vmError("invalid VM packed record layout")
    end
    local blockCapability = readPackedWord(3)
    if count > (((#buffer - pos) + 1) / 5) then
      vmError("invalid VM packed record count")
    end
    local records = {}
    for i = 1, count do
      local opcode, instrParam
      if (pos + 3) > #buffer then
        vmError("truncated VM packed record")
      end
      if stringUnpack then
        opcode, instrParam, pos = stringUnpack("<I2I2", buffer, pos)
      else
        opcode = readPackedWord(2)
        instrParam = readPackedWord(2)
      end
      local payloadLength = readByte()
      local operands
      if payloadLength == 255 then
        operands = readValue(depth + 1)
        if typeOf(operands) ~= "table" then
          vmError("invalid VM packed operands")
        end
      else
        operands = readPackedWords(payloadLength, 4)
      end
      local record = {}
      local saltBase = (blockCapability + (i * 65521)) % 16777215
      for k = 1, width do
        if ((k ~= layoutKey) and (k ~= layoutValue)) and (k ~= layoutExtra) then
          record[k] = ((saltBase + (k * 257)) % 16777215) + 1
        end
      end
      record[layoutKey] = opcode
      record[layoutValue] = operands
      record[layoutExtra] = instrParam
      records[i] = record
    end
    return records
  end
  local readValue
  readValue = function(depth)
    if depth > 96 then
      vmError("VM packet nesting limit")
    end
    local tag = readByte()
    if tag == 151 then
      return nil
    elseif tag == 216 then
      return false
    elseif tag == 94 then
      return true
    elseif tag == 104 then
      return readVarInt()
    elseif (tag == 9) or (tag == 115) then
      local valueLength = readVarInt()
      if ((pos + valueLength) - 1) > #buffer then
        vmError("truncated VM string")
      end
      local value = strSub(buffer, pos, (pos + valueLength) - 1)
      pos = pos + valueLength
      if tag == 115 then
        return toNumber(value)
      end
      return value
    elseif tag == 178 then
      local valueLength = readVarInt()
      if valueLength > ((#buffer - pos) + 1) then
        vmError("invalid VM array length")
      end
      local array = {}
      for i = 1, valueLength do
        array[i] = readValue(depth + 1)
      end
      return array
    elseif tag == 171 then
      local valueLength = readVarInt()
      if valueLength > (((#buffer - pos) + 1) / 2) then
        vmError("invalid VM map length")
      end
      local map = {}
      local seenKeys = {}
      for i = 1, valueLength do
        local keyWords = readVarInt()
        if seenKeys[keyWords] then
          vmError("duplicate VM map key")
        end
        seenKeys[keyWords] = true
        map[keyWords] = readValue(depth + 1)
      end
      return map
    elseif tag == 45 then
      return readRecords(depth, readValue)
    elseif tag == 198 then
      local width = readByte()
      if (width < 1) or (width > 4) then
        vmError("invalid VM packed word width")
      end
      return readPackedWords(readVarInt(), width)
    elseif tag == 132 then
      local mapWidths = readByte()
      if mapWidths > 15 then
        vmError("invalid VM packed map widths")
      end
      local mapKeyWidth = floorValue(mapWidths / 4) + 1
      local mapValueWidth = (mapWidths % 4) + 1
      local count = readVarInt()
      if count > (((#buffer - pos) + 1) / (mapKeyWidth + mapValueWidth)) then
        vmError("invalid VM packed map length")
      end
      local map = {}
      local seenKeys = {}
      for i = 1, count do
        local keyWords = readPackedWord(mapKeyWidth)
        if seenKeys[keyWords] then
          vmError("duplicate VM map key")
        end
        seenKeys[keyWords] = true
        map[keyWords] = readPackedWord(mapValueWidth)
      end
      return map
    elseif tag == 143 then
      return readPackedWord(4)
    elseif tag == 245 then
      return packetInfo()
    end
    vmError("invalid VM packet tag")
  end
  local value = readValue(0)
  if pos ~= (#buffer + 1) then
    vmError("trailing VM packet bytes")
  end
  return value
end
local BASE85_ALPHABET = {
  [122] = 0,
  [63] = 1,
  [33] = 2,
  [118] = 3,
  [80] = 4,
  [111] = 5,
  [114] = 6,
  [110] = 7,
  [69] = 8,
  [120] = 9,
  [56] = 10,
  [85] = 11,
  [53] = 12,
  [115] = 13,
  [83] = 14,
  [81] = 15,
  [112] = 16,
  [90] = 17,
  [106] = 18,
  [35] = 19,
  [45] = 20,
  [74] = 21,
  [72] = 22,
  [43] = 23,
  [42] = 24,
  [66] = 25,
  [36] = 26,
  [67] = 27,
  [105] = 28,
  [75] = 29,
  [124] = 30,
  [104] = 31,
  [65] = 32,
  [103] = 33,
  [102] = 34,
  [113] = 35,
  [126] = 36,
  [107] = 37,
  [95] = 38,
  [125] = 39,
  [123] = 40,
  [38] = 41,
  [77] = 42,
  [71] = 43,
  [98] = 44,
  [78] = 45,
  [94] = 46,
  [46] = 47,
  [51] = 48,
  [50] = 49,
  [109] = 50,
  [37] = 51,
  [86] = 52,
  [57] = 53,
  [60] = 54,
  [91] = 55,
  [87] = 56,
  [121] = 57,
  [93] = 58,
  [59] = 59,
  [108] = 60,
  [117] = 61,
  [62] = 62,
  [100] = 63,
  [44] = 64,
  [64] = 65,
  [88] = 66,
  [48] = 67,
  [116] = 68,
  [70] = 69,
  [79] = 70,
  [68] = 71,
  [82] = 72,
  [54] = 73,
  [58] = 74,
  [101] = 75,
  [99] = 76,
  [52] = 77,
  [76] = 78,
  [49] = 79,
  [41] = 80,
  [47] = 81,
  [55] = 82,
  [89] = 83,
  [40] = 84,
}
local function decodePayload(blob, payloadLength)
  if #blob ~= ((math.floor((payloadLength + 3) / 4) * 5) + 9) then
    vmError("invalid VM payload encoding")
  end
  if (strSub(blob, 1, 5) ~= "GQUEK") or (strSub(blob, -4) ~= "IPOB") then
    vmError("invalid VM payload framing")
  end
  blob = strSub(blob, 6, #blob - 4)
  local buffer = strGsub(blob, ".....", function(chunk)
    local d0, d1, d2, d3, d4 = strByte(chunk, 1, 5)
    local b0, b1, b2, b3, d42 =
      BASE85_ALPHABET[d0], BASE85_ALPHABET[d3], BASE85_ALPHABET[d1], BASE85_ALPHABET[d4], BASE85_ALPHABET[d2]
    if ((((b0 == nil) or (b1 == nil)) or (b2 == nil)) or (b3 == nil)) or (d42 == nil) then
      vmError("invalid VM payload encoding")
    end
    local number = ((((((((b0 * 85) + b1) * 85) + b2) * 85) + b3) * 85) + d42)
    if number > 4294967295 then
      vmError("invalid VM payload encoding")
    end
    return chr(
      band(rshift(number, 16), 255),
      band(rshift(number, 8), 255),
      band(number, 255),
      rshift(number, 24)
    )
  end)
  for i = payloadLength + 1, #buffer do
    if strByte(buffer, i) ~= 0 then
      vmError("invalid VM payload padding")
    end
  end
  return strSub(buffer, 1, payloadLength)
end
local PAYLOAD_BLOB =
  "GQUEKnqN@9dmd{p3DKr?MO@u_5;XBlD*1-iD+/4A9v-,}<lN)gXGORG@P<HZ>-ReB.irYsn^r5_&9<^A.WPH6RiOF1uPr1AVy[.M~m0CSO^b%4!hO^Aq5*J?5kopp30?+2tBq:l{q>u&S(DnU!*@xDNg5ZR/1oSOLh-*xuJL0WRv#68A3n/WSyq1}lX!G*<V!9tZ5l](5P#NH.st%e7ugr(:ZhRpje&i&kyjiFH9_y/BS.Yh62F09$Ot)4<8{mjD8Q@9f-x:jF83{Ni*@#1zDevd4*YxsjgpKx<V5K}Oht0?2Sc&6?Rf?]mc-0BJ/iC2n)K;$U2|HqF4n.Hv:~@KnXPW{md9)3hm}NbMp*_Hx&?>XOSK!:)dD~q!PcJBqDA$1.9>{}JH$8yA0$Q}_O-!})tBYtco6r46hb60l)V_Cv;q^t<^1c#6gFn4@<O2r4xcq1RC]4R]jvttdRlLElFK;848fNP@%@F-1RGJ)S$1m[;czAU&J7*Bj2DyP?]SK4Kv+/APQE[W>q2)]tJ;)Xp/Vy8f|[CW&5X,E[.<}<zV$Yj&Gq-:f80{[)2]ee6Ar]sJk-:DlJSXB:xrR6l*G3-2.#drOV#ek0h~%[9>})/r$7|];K}olnX1Y5|+hKWjle*>!yRk*<#u:BF7By:9jzKHc}JDb*mi{Dx4/XlqUfyFH$*j!1C|EkHc@+{O[8OVL[VDtM_fHeQ|pXDRS9xrL:HcpfP9%jp7Mv3|mXA1<}F!yruPz2JNiGNGseHx:]*y*LN6DW*+JOs@5xfUZ+o?o8qY6tg*:jA8Pz]igZ_xoV;2ZG^};;++Yx(^Do12ndlVU^9j]hH{E0RcgF#<z+M^2pbo!3X>f~W%?/POc#g8t*EyR/GZN~r+L4k3h2RgRD,]dNetcMNBEYo6~op*(XRO8Of:7y#B0Y54L[394U%4~Q[,/Esuxqu%#RU}OKX.WEZ]P,SZ8GC3muhmm~%PdG#K[tnKfBfULEBnx&WH9r)0h{R5S2M{,#qHvy6:z*B#Hu*R3@{%K]Vbgk&pS270pLL$WomAl$J0WoXQD6Ob&,Hsjd5ox6_PA[|ZXohJquz;mCvBtW:-YxDp#jd^kK::2ry/:G~+RlXcl[!Fgumn:)3zq<r~/%8><b)2+;2MOzu;WfXlfr!;Z5|-.h*9_Rp8$rj4[~$+4C>t;gHm:$5rYMO07OfMW!y+iQDvP[hPs;@.m?3RG$_ttK+D?L_>E|qS2[!QP:<!;@^#+,o4oJs_5O:-86oQG?tky>oug3f:fg|k-3h#0d3OO21.xScD+.#z>pxzEBpvQhd<vVJFbqp06NpZQd6@B2?bhgU%B>MeO$9}d3Zg$9N|LMCWkJd|>eGvmn?mVSBt6MPug6;v{B0hCA{Zv,$0ujXq+~R(lRk9JWN,j^^+/n@Ujr![ME-Ru2XR}:eY9,>C;)*eM!l;qq(+.Ed<-24b<Xk%DnxJe11k/X8KipVoK]KLXy3Wxj/9~YnepZ&[+McCm}]>+1iHcO+JFbbg@Gux3-Q#!/U+.}eht,dC!]hZ9+p+E)&tiCK:WJ8v]{cHoWH^GiHZu?UK.Xq>X2g{sRcoJK$P,&,vg@!^/r)Brpj0Q(5pBH4]p$jH^q9bKeJ7|<E88cQtH4p:Ru<bC>9D:0.[J]oE}]m@.Gg,|#FK>#6D9s[fP5xUy{1p%Vyd}<d9vk|pM9LM71?0c}95~&&rppD-;$&+;i{!1eb:R_^/&YDlrUpuvh4yG4AAusb^3%FGs0/t:$e2KeQgHShjn#A11RNuz}P{60]tL|5x1z[^q4~(hJJ{(lsEjn.HfXHkHFJ)/<G]*k6DnQ;o?*oU(t6)iZVu/xyu3ZjmH4&Hr;XMGhoSbpnrzxn>Ov-0tl_u{j0/,t}*+N>WrKM<@uH#]uW2_0^.3,W~_xE2~xsVVL-k~$)Kj9n5%*CL$y&etzD{y)e&UN1V!;mmOmgRct41ohz+b5U4)pvGiB1fCZdf%,OAH<VDNlZ&H!913qyCd00NX?D+#s,{!$shyKQBhY5s(mD3|K{8t#$M%(f{<NX?1P8Cfjo[jyGn_BJ-}_Cf0}|A>rt[55W{%/Ob^x{3]bYeBN{KyroG;cx]BFNJ.^k>Do:}8Kfz9V3<d](?R;L/9*J,Ntp+$@Q^emLJvPqf>hfH4K#tVu6hl+y<JL4,ZYPY1gHgOUkOGHr^{J{jU<0ORe*X(+j@+]Affxvj?u!p_.r4/>,.e9}eyn,;pqz;MQ{p30v]78&d.?/2^S_d~]L>U9H]5s(Kxy3f]{xY^1%+Uz>VE3?RQW5vHERcUK-YKRkV^OR5u&CdR?#X2j0FGRm,6#M|b&rRR!eoR8{<WC%!APr62G.ymZ+k22N0{+5}9uoyb{^bk/h;c~DR6.DXSF]b0jM@puW$<AuC9A;6hd^;N4M~i^[YgS7V0p]+C;*q^XY3*|)zLN*NH1V}RlDBQj6}R]P#FEb3/;]bY%Fe{8~7S}50{}R8:9KXGj>f%?!1c-s(@gFLS$c#c%Z>[t@qDstrBxb.]#]m>llGN%p_sj664.7oJF#GX}8,_U8LL%VtH4EF-R6ktj!8~*JketgGj*_%8yx1b<cpMsdG&0;]hu]eF!f5CQO{dmfP_}P[P<$P?nQ#1*n.dcVZ$/0nVCUG#G3m0QmL2uLqx2l:C_60Af~5d-/XYZJ,s*[dc~JQZlVpyf7c[[&1K^O6r.Hm<GK.E>-L-h?kR<2KuRYX0ddsyp7s-]*l+$fF6p9zkCO+Uz(.~Y&.3}qf@!}4bW5D19^v3/;2zkj5rkzq^A017<%]LFXUVY<Nu<h$<qQ@8D#;_y:)$n[Axp2y?02muAhtADbFEZAn.h/%8k/*{(G:vX.Pb0xsKu<W}Ds9si*[93|v^c^$4J?<Y>uQ)(E*,kW~uK}1>@&BsA+}WWZ9xKuS&hJ.-96qr4my_2kfUO2U|t5&cf}BOZd)z?Nxmj>Bbup]:kG{<SMe.1rnUpG0Grs|JHKsQdUHM&JdZ{bKc[WBMy([u_6_lu90*?2PsNO+tz;i>6WCCdu4p8#,AG)7:*1(zZ#o!D5W7,WBH(:KZZ_)UOE_eW[W6XDu;P*VgNzW6op?m(4eSEX(gU(ji%BDRQypc>Jnxb4ft$$9&Hr-,27d#sn%&;W#jmWe{#?xkfF.S!~!$(p6r7jS2vl:6~d*R(.<R>*:+m]ns+u>bpO5of+tY+Q!878-CCg@BNb9L?eyuJ#;ddKo;y.qbyu5M*k38KVk3$g?K+A3GhQ9Sf8W{}Rh6oS]OrdnSuWkWZnHG!YA<:^H<.qV*<bL,5KzVeC8@FB[9Oug/8jMs|:n!-GB~ZA#mEWP#Em3-*j1M6/23iCX^_L6CS[to{25v^;oMei7L!ErW[[h:RmdVGgGH{XkmCd98Z}|GlXE1Su9i~V&O*}t.W|5~M+Dp]EiUp|:x>LSr|f@+u,~DX)DPv,.0.4q7%DS6Bmg-Xmm[[P,U4@97DrF/QpmC/O_yJ-z_yhdk{4hd.y);E*@x;{-(5NMq^y3R@K?D!;.qo35|PMhVbneu9Y.6@RzE{xQ.),{X[Gd_(PNs..@lqr.Kx;sy?Dld!>K1k(7]VV~3/pQMfHDUk$cD95Z8ueb4)<*$zEP4fO9~Lx}BPx3nziJokpVcxxVlg5/M{g|_r$^UsNH~~fmy5&l9|t^Z&f|^f/-+sgxbv15C/MHYf8nqWivGycQz_c%zf%@Gf&~z2J]<gv2R6EBDO6n$8@B]voQ_zUgrSi+izHLSxdQoyHF5Omx@{b&_SoSu|t:;@zZHX<49tX|r]m+}B5NembNMmtQ;AJG^@-6XciSZy9(!xd1C}8yG9Cl9j_X~tv;eLl3:Sx#p1rzAm:L|,DNjHedy<;p^%1!-4!~.b-D/@:]{~KxbWA>y&/m7u9L#CZ#p5*4G*eWrJrkoJLfY1~kfx7L-kUmO,3kNCe_Ju:Fdh?O@!3CP;DNSJ{,l!lJbrcFzys^mxyhcbV]/1M/0f^~+HB26*]VytN4-*ZpotOu>V5plAsPz<:]D_kk5RY_<b*ULx3(b(PAUg,Ft:y#i@lNM@umU5ByY%|32y<b<{#M9H|C3m33dXbM*/V!bO?&pB-M*D#k-_+X-Yl,s6@,c4pB@0e{t#yfcXd!#903:pC2n~}NdV6?W!J3yg|!AmNygxd5$Fr6.?Yr~6Jj$^msN$r}5ycBWQ1@]PzO<Dd6MV4Vc2u*c$cP*EBY8kq$YXA;{5M!X$G.>XrdAJ.;[/Q&xGFpL67AFi4*kUllYzPZ]?WSU+<vrdr8.4LBtz)+!9/F9:c>lpF:db*(ERLEsPS9UVDKB?)938CZ&VGPDR/QtkL?tBLr%_}&2)./&HRy{;9&*#*jk7)po^CDrt!BOCyg5sL>hJLc49Rr~nt._mzn&4>j$_G9*QA{Q-KmE*CgZb>&m{VGj$@:P9;F(:-^;,}cL:ogR+2@DGS|V+x%A:b@{,m$4SeihivK;pUFv)gqQ!d-LPz*-Z7eRu4<p:Y#c:.c&8Cjoveu@v91SUb}iXAnH$hq2RbvtDeCXb07~?yB>sm[4M5sj}7_Sy4jHv-@p6z7FCN@LRl2574P99c,&xPuBD;WPRGbrdc|jgUZg*u}_P>M_h1lposO|/2r^goGC$v1L32zz!4FEi@DUAsDM+jBr-}d|LmX^PB9A>44r{L%9#L?Pu|rMDsEjGE~_6c/0rud0>V0bGl#MlS%V>8J.H[([VPjd^_6)6%Ed-B[Mbk]FMZ/rez4QG5m*NzQU+:-F)SV|ymJ1:QtRZR0LQ+)L9x>[fGdRbLDz]RkPj}.^6%VYUP}[!t{nr}*>S:>W-eZG?X|s/LO*b.rU9vsg#OK]m-[2r]s.A;cW>&y%7r:q*(&1s8GN^R-:6[W)v{HE0vG{)5~J%0Mf)hpH:!_[%8h9%-9Af~VtsUMJx!9Rd*&?Qcz~_vA6sL8Xr}}l)nCz-zUvMK43*gcFKsKSebp^Dcos&SCj%-P0n&&Oe*tZQ&@H;?ZM?#?ek~QC.x|F:sJ)}i%NL4])E:b-RH~U0PUkX@*6%4C2^ri5,>GcX{<O1q6KF8mB398{eAh0@$V7:eZ0XCQ.j5@FM[4sA7D?sLe0Aj1Rx(GoB(mA/lnL0jf{J-,AL:xrO&><b1pmrLZG$jJe^oC}^Ys#?WNk0*sBvz3%93bB5tcMh1%b8,doRR+@4ZX%uNeJ|^^V.}vmzy[}1pCsHgEHQ53&!W^)U8kj9BOz]Wr7::6%R507WJ|*2/zce]M;Y[Y06:-W58}R)/vQRRb2b8u?3*5$Fr_Q^Yi]Km|s^pL8bdP2-~l>VAqU%/4+-^0%s^3GbBV[^/Q92%iixe1e|^y]!is)D^PCZsgy),BU51nAM,{23F,@c,$oA)~z[R^o(*X#EGV-y@-d{tYZ|0*VJt2y2>;>6#9}:c%0ig9g%b(z-#[g#MH#qWN9JQls)p9JeSK}FW^R,2G#!ktC,]gk#Ap#5Rqy?zgg:!G<i!lPr80hg<|smzv_|V1r,Q#WV0Y1r1iSH6S-36]ms8G[q1%K,<BJh1DJM{0<f-_W+5j[Zc1OsA:il}|!&iNS5,Z%^35)H!f{+UNJcc_ipqLHP?7o*B,FzDs34E+Mj9xLAU8)QRQN4>l0Lvgb~0#v2{2f0x!J6|;%$riRVl!hOsPg([gmQ_Bm$CPFM6c,D1ldV;)3m:{!$C{mlWn!:hh7VcKxJUrsVGBXzrYS,:tmu,D!(RBkzX[pSB:<v5-Lg78|ZZ,&51[>7tPux)6~l8#k@9z;<d:Pcp0@V2@gG4r?W!F1dhyJ3mg;HBG)6u/b0;X}A}z>|2>yl{7WzP+f3|[RptBo5Ax<f,N#YG[*|yRv%iA!QcPcverML0emrg*t6LBGd7k0#q[]!y@m?{s-5Dvi%0Oo<-)e[BVtte8lHkC@1LL/3X,g}*nW6g>g(fi{tAuMssond9~_&xrHyWScUqnOlcG+^brt#QKA!^t0v>K9gr[e2FZ~z*?.M<|5H6hg;?<V.MU_eZ{gbbikZt~pcE7>9q-gHO&O|4?:6>SStEPONg|)19?D!JGAuCEnGkq<1mn_Nsvf&o8cDh_Jc@,UeptW)*!2z*?:{G_ezQZ:Wk~WAV?vu$&p:&+,PZY(Fm25%*S6Cb0m.,+_}tf);}ns<}QOyB+A-GC;UKm38KPdWK*^vGjF*#|dGSQ7dnBG0Px#u>i]yL*.OUq3(m]PK{}iB]&HH!qW5-3n89m*m%CD?mx|K%pu;&6g~t|2pb3jR20EPGA7j9yUp)+51hVR7*g}7:i$>J#%r^U;gH]vNY)eioC@1N*xOyi/Zh^[rx>VK-odRMnv~NZlc~HZJh_tY3SBL-BABZCMnE}zt]ocvhEr<@Q~DnjvLc$N00emDiC]@y43%0NAoV[VC2|iRbzMqP$Qq|MG/.[h{lmiE>3^^$1Gc:GKRm:0A~FJSM7#.Uydkb%dlHe}7|OtQ@J~qSiK3g5e&{oALDzVnsnf%n]hP$~h<<)/&t6g5s+Q8|7CAmD[Z-16t#|%yZAU!ciQ*tmuhZiyu+06Vgh:;W)WJ>r^QV2?EU.PW<_H;2!_:E:Zk^bgyP1,5Xc.[VUUAqp7SE~zBN;S.cD4+eW[FA]!(1WCBOxBes8{Cs$Ly/@j:]Hfdq)Uxg:1lp!BYlYE5v:iZbAtnd{+/,Dkf*3(Q3cD4+)K0kbq0|:}|R+lH):+@}cmh[uhOE!UxNV}-)rC3jhN?%<(/9U.$h}.s|+V.N)~E^{7AQ<D,rEX3v{EkM?UGrE5dQ-XYknWfo}c@|6er.P4k,|K)AMG[lUx}MJyZ#/OzF/$R5GmH7Bqht;Z_}tE:2u_A+7K#}|SOj.V2FCu6qq#Q9e66gHz!DMB<R|E,-GN)b<E^{Zzze9K?]NrM3L.]0DY6Q>$U/l%^?1D6[b6#.R@5DPJz@4fGccfPR|m8d6<^19{L*,OzSgRHB:PE6j#Gjn[f%G4[vc<^.X5^vPto1y2te8-+}8YZg_PF)v>ZUic*-^0sLpnf?bV:e&BQHs*sR*NP5c*|hijBeb6j,x%_gG$}_+:VZ5(-vRrHW2P/78AY2/>r_jMxA<W)#_/}888zi$[$Yj9V_),YP]2WY!gfi/H.3B?XuX#O&b@Fj&ZV!ZtkRXC/8$00muNDk3c9EJ$AG0GmttMi!ul#/BL%d$YEjAD8hx@|:i4(Pkg8k{:&ZAn;H9mo94J)h|y1pvY)W5^vA?:hZ@<1NcW8E,pc:O.GjE%5*8_/c-$3zE0Q[621{)EOE%vQ9NUzz|_F[X8{m8zt5kqNf!!ql@0X)|jbNWRyU00K]D5Y3{C24[;j>X%M7,HE,_E91<+..B0UN/oyG+$y_yR8OxPmx#8R2{.Y(jJ_LOF[R){8k-HeQ-70Z-[cQq^CKgn>oDk{c(5f}mhjO%l)3$n|$#1<->mv0?5Q3PsJ(#FmDmX.!1#BCn)H,FeiXl3;hEDrL&^#}iN?G.tZd97g.*Q7pCMZ~J[^5i]Mjn$F$PRS<E{gfCxz:|0^>@rk-Y(M!+(_|G1]9Z#4uENBQMFdm1-Ze[<#XAqo0@#cj5t:z1P+k)0#yHg[[Bv89-43N(#vuzV2%k!z^]WL^s6Pk0u%/4,UKRoP*e<+RoXh7qy-fBc#kt>DW_$q*+qYkWX3*6|!}F0)H<GDNXf;j4Wu+b*bUl+~bCetzH5e2OlpW)QMSkbrA4~SSp5fo-SoiOU!%t5Z-~/^BeL#$MO|vyAy8FQqN,yyl5_E&*iV1D>c_in.)hB5vPLNrb(c3UG(<mDj*V0FE:A$[,[N5Q$cs*jguLsyszoe2W</s:zAGy$lEml$$*hz%*@ln|#[@8@:eX#XXU]^LM63<4<v#p5b4)Y3o#z2VJ2|Uu$m}><v.>g,E,;(dEcL|*U]z:Q$KLDvVL>v9~o%HWCB|D@xxgFx++#q:-&gXtm)bYK807N?:?@|6&ck{kbZZHOYE%+sP8S]{3cl&>mB?/U)LVl_C}0z.c/sXX$xoMA$PZ}Q/:B!K[7xm-6qcA%;Y1y/vjk@/16W18BMi9LkE_Oy2.>jzlrbY)1iqxt&_gi+[C/NjH|YMy3Cv^u,*0!O[Ox?AdH[&LbZR^>OU<+l(u)1b)~Wm,3dnyE7^]!i+g&2$oj..1kjGxRt!2<xC/#VbsDWu8lu:H&:nl.u/^m*L{|sz.[2sSv>7.ss%3ZbOv,dn+P4ACyc>2m-Qp{[:K%;:gr+m2dk?GhxL.^7-VH>~KYWU?/sY#78)%S&lpckb41CkJOF>hE<j^8A!+v7Stki+7~L8.+J,BXt^i0<d:z/[}^<14(UuNom2y3n?c#56>~Y05F?gg?gV40C^hXxAD}%<n^l{$8Ai*G[uPBkQ!s~*d7.(mdf6HG[e_h6!hh]vYhhV{7.GPc|!2*6^s{@#n8.+2^9_hP-[E;UjY$38gCvM_@.2{)V!DGlH_?;JCFAtMeJGg~b8]jUCdJOdYW)y[%}eFefWDmJHv}H7[%)kEDp4ZV~>pBjKEp&pN1&i^p.06d|Rh}#+pNL13h96lF@)1xOzhg8QcJSOZE2r(s]64$ZZh#y$V2iN2<|Vmb!Qe~mvy4{Pniz~]q,]|B!XF[S_W>Lr[J0xA@+r~)Z/{DP7^!Ldqj!{1-!@u(W25F!hrJtlj&CYn#v{S|v8u$[WNRExf]4o8~W,v()G4PJlQXlJyN|Po6oU!#uRD!~OkPclQ~MWd.+:Jz$0KbV]tDlPhGX/8Jb1cBebY|YMP)(~cJ~?lX]O!-us08vW)Z97l4r!V^]AL*<1+nnUosPNR0Z8|iyjDW7kluxVro6BEU3LlHb67*KPq12mK0}uZ8])kA5#p8#FeocRg1tX+C<Gfzt,2{E>uWvmd/S>hC-e-Y[26$Y>8Js,VPi*4k#C@5uc+J+_7*(f.4:+fJpZ9XmPSCZ1DlC(*@k,$sPh6p2h]?Kl2~#BE/ECGU?~t1AUWcPb;^%zKv2<S_h/CdW)k#(^o.xO#6v/n,drr^%?N)]qu0z#dixd~[6UQfx(yP]ux#8VApUW1c]8Ej,ffiBj%Kpqnp{7q*J}y$H>r2k$^X}mBO]/BLobi8KD;AU9OM#Gv2-852BGZqh+1}S*yC8vX9EDWOg61p8&:>KAr1k@6tYcJO+008,&jO5s()|7h}U>r.<7LPNEX!oc)vGl}mofAR$Fg/g0HVR!ov9-SneZ!#|.}x?z;XnG,-t$y^D2*Exy0yl?b>B0:v%!nbKPxZp<pxL~/9rs~||WGmS08n7S3Z$jZ*>t%!Dr9K1!m;~z>.r(VigGOeH.PG1v@xLYARJ}W{.z*hN:;ut$cOn+kN]74W#bqCS2-o*R}+8LJ8gU?hc4C#JWyR2L;*dt?+c-sYPr;UNe{Jxk|#13<e)ROEB](R!f<}^_K19h,H)-RZ*fvqM%L,yo+jtCiUi.gA6W9#nZBRm]^dR)Am>*(SeZliM!x114F3L}<?9t,FSV?fd&J@}k+&+>#]H,<2JVEqu$-,@e9m7[zZ-xxK[{RM8::|[!sm0JCh-LzZuhhH*dF*EHg*JbuF5*@M-_!^W3thW)Q-g9L]HGQx[EK;@pbm4Q}Jg^u#S2.$CG6OsOODo^:1SuvX<WWcytcVVHQ*np!)Y{-!E|ysp;4obGR;1c!2u*/S&g*:|@Jqd_[_QB,O.0N@hf*AOcWm^Ly2cqBGMqr!JV<e+]:g&SkE!u*<R.Zeit[^9hBcV3l&k;$~,~Or]?>SW1Cs5L*n5,H3Y-A:6vLjU8LL8?rs1+Zn$Hq;Z;2b3jx|sMf>Mt3*E$5r1UZ_WW4j{O.?Qps.df$J?P~;e8B:[55rlHFC86N);2iWC9Q#&6*+0g?^~E9{~nD5r&u[;7Sl;$d?~NC;g,?sm/}Nf(3.d<05ft(sgp|Ois-7_%k5gN5r*,Sq+~LkKL[mFeV|5f>*rZVOnU#2tQonm,f8l2e%^Eoc6(!55k>.SZ__gWsUj-^j}zp5L%RfK0dhCmQvy0#JE6.>/J*>5A1DA?s,fA|_DHVUt{!j?yp%d0mNEz_~pRe/U+timz6OVefD?P,XM<$B7pk[z&WJd(V!J,m#ur0-Q!.f|NW4W3&<.uoRM$%N)%ELVV@.rU*:-Jcj}!hbSMkeX<r2+lcOXVD?e,%v#kl/[pqW&-Ec}g<!$-J>;BOxm^e}3+HJ7X_{Qk-L#zYxL,0<ctvU]!X58zEtqdzjvVi,Y(]dZt4Pjboe5%dk[cC_iVCDd]4gVu$Ue:r3&-b@6<5oJz94)[lj$Rt6i)-!9,<;0}.9F[>H{5YN5ZqQHVu~~?}[/zGJ/-F?b&OMX{^c8R.2hnK~H/H15GN]kD:+XnVMH@|*~G|cCoFd8Wqv.7dLP:@/UG@]FOn_g>)8fVm[_C47P;ME46pHjh#s<?OPOk1Xc0H)cUbr/[ZoZQ)yxX;0n5C-#[OQ<z&@tsq[]65hh$mKgMd&P?zgG2z69?e,r72E#(l[;0g1UkvzrJK5d[u[cyKmBOSpD~XFsfReU}@1H+h;U+mW[8.m&@7J)@Z7S>:|e*g&i!y?t_P:E6f?~x:gQ7+^V(Q2Kb4F-pG0e[[L@3pZdCX3-Q(oH-(gA/?svexK7Zl8Qe[m*fg&fA.5)n!O7*E89}Zv/zx)NV3(r$bjV8Wh0l~Gi0LZW4bKi[bFusV3ALg.cv|G}{m~7Kb+DhVUAvhB(l,:~e{FA<<]nr$Fl-U{Uh/>,OlD5o{E]LEy3d)WUPn.6&HFWKp|t!eqPdeyeAsQx{0qc/|F9Wx*@N4q-Gt])A.d0g;;pqUAjNCFxl)Md<z_K2Gn/NyQ*v%4jcfJUKH@<!#8(&@n<-er3t$j58-Xyp<#gEjyOCR5*WD&^91&&Lk){GuJ#BSqiq>u#.ZN<eqZS^,ozg3s):@YMr1zL0$lyVQ;}~S9uMV/A0Cb{00s]^d|plDq.A3WqViC{q-nJHU2)CX<}:C-ek#UbG.N]M$tiOXq?Vh+!pvs_ptz<Sn$^]X&4NmgH0fJ$dOd6QSm8(HAjkH!sA+eleK@F+7{<65?dMX|]CHA$WdG0)q)Mh_/YXnldtbC7756HO5+M46&n]9z>l~-t*Q?[hox;DnsA0&:#t]XJZS0(VW0lX>H_QNb!<D1kCEg:|S(x.k;|-gdg[Bg+0+$V!h__ZZ<9$:12A4.j9F2kN[$l9sjc-ZXY{[:coH-![?FthH_!s/l/H*:%o|qu4r2/jx*YQ]Sd^c&zZ|)><O><ON~1dp0m}Ed7.o5E>-kB4Q}jB6FtJ*tSKPAFoojv|K-nE-jB?RS${BDzj}EA/2XNpE*AM[&uK(A}Do(pj{z/Aj}Eij7)l.l2Mv6!q~7phQ6g#:jy!,&&Eh>XPSvWL&]ZfXNZJ9Kg/$SoXP1*:qVR;OmpQW@;@3n0S{Zt]]D_z2x0$B+GCzL_|7Y%XCfKL}nzlE$5bWc8CGO6C<v]XR#XL]cDsZl{P_fCu5JeO~NY,0:Heln_(Pi6Nj(@:)E;NBv%i*n*80_jLn@YJcy$tNK/[H+:!^p5ulW,v>f:#rVG,+WN_]:OPbj~|n-EGkx!%H&r*Hls.^6lmsrSN$~?F)qm[75kA{_;-!k,Rg~~6z#;%tMs!f6+-KO<$dtN%rq6#;o;{fc8h[HOyD.$&rgh<Qd>_N$%#1E-zHGz$WCjH0]7M-3d%z!/-x&yQCU}vufBLozs[X126^@yYj78n#xu3)#<.6AC8Ai]x5J/LB{D{Km{Fq)q!$4@+.fG~~(E8H^G_{1$toV_MQFSd}E1Ji6<8Jg*%Nf!eJqC<ZN*f_^*)iNdlneMnPtKgN_}HlM-~z,fuS[MC;b)>3uF1qSb6>PWZ+OArCE+4-A+,f~UNJ8r#.t1t;C0t.,xq^O.uq4QQCd:1;,Md+SOdHySX0MrYc[LB(u1LU!06:E^rqXthfu!&HVM7,K3UJPpv*|$Hn<})!C!1r_L]H8cDMlJVK>nm*0_%?-ZB4n>3h5htbL*ANGyL:Kbk535M[U3x,8*jpC_Wo*Xy}CSf4HJtcf<K*tjUcu@v<Eyi-QVg{*>foKeuP@4dAv(L#3DWd7L5H]@1]zzf?3Eb}HZ|#ys(nDM|2AG;@e1-&-kDG>iolgS8RHCmP]^7KWloNGJAePbCA8-.NyUxlblfXVbR,>&)4M6!WPMMq*%XPS/Lg6f7YmF>:f;Em)JvK9Fs%A!Y51rzH-,</}n#/EE[yk$F|^R??gVH/g|c3Wsu_~}t]28]{BNxebf+5ooHkgH5ul9VjpLn^s0*{;iHq$#eM,PnsS[cm6u](Oy6drU#GcW%&q2Ax2<8X3FB1.1H}DR__q_d2cQ4eCfYyB2~M#GP|D7WUi{q;vltt7?P[K]WLUFA{&lmj:PM[^MO_66t%QUC!12Jb53?4F$V:]FnX6zBKxLVfXWfq@bPk?n~-WP{>49F;R]y_in^X<m$s?ce8g6P_;F5P,p^!@E;qs/W&pbp[Bro<]Mv9CW|N).X~V6hMQ)P9X^~mAhV9O%[4B]PJj|KyY)bX:4thjqjD|L;WVH{c3W,6~b;x%0(!:*ZkkY$1Lfyvd?kt|%Vn.q<uiyu?&seu]@iAyjm@KMjh:2HKgXKJ)-5Qt1!?P)m,6:z+96/J}hN~XF6]@]U})+9Y9_Cb]4/#Mz^jvK4@g,!vjeEbyd[_dg,/FYF?h)H8H1D?2b]J_mvsuBnL@e]cdpBm-R6AJkV>V#sB5#i4[rd^5,CYAl5WS$|*lPg-.jYXC3]y>oz|55xY_NDopc(tJmP:g{v0[yHbZ~O|&^#kf3Um?<B:l-LJ%xG:@PESm:ePV<_H8L*q-&<:_C/F|F)[u~Y:e@#;89{VEqZZ-B<At]7*(B9lvzW.n%;7*F+s%l5e??hHUem+,L>h{fydA8Nm~^~_3?x*5VD2f/bphC1q36sd|cU>!CH/.N*Hs^4G%[ut~NJcCdA_300c)+(1O]eiVV$(s_>D>WU31eMBHoFtD[zG&u|;Zt3tM@#M_OBKg:|4Ep@&i_k#Yhr294705D[~^0K*kCL/~(b609WttF#*eq/m#/x()0<c)vFBy;%;EH6qBd]1^2cD*[PMftXRC1NZJ]FWY*$ndHb1:K|;UuF7_>u,kKYy;s*?VkZ<sx6%vh%^3U%meHhfrNO^?zG3c{0UW{pt1uq?l8?H?p$KjhhMi3c-m?]O*N^-+&&[;#n;)Q8+$dQ<NsYZ;:yxcYG69)Ufx<03bemDJ_!2&^t9xS%OF6d,ZSC7b_n|453L>~NH{#N*1p,gYr2ns{0curd:3o,UlptHiZ70PX<omDNCn]>WJ-Kq969Q<d$$Pmk%K@oN>Vt1Hc%f!}vEPDME3>V?v<t$66-|Yo7AFs/iHe;^vFK#9O#!e[mz]<,pb-/]Dzb(LOBkSi8|{S@Sm9:Sv)KZdse!;icjG[Kn3f>$2JDW%ljVUgZ)+u%M48BNkg+<XHm5)?G{SgLl;p5jP0SiX>DU!<}0p5C!s;F(x0x,Q__1b[Mtc*R?A+.SZbkhBe)$&u|E^@#e.A!7i@#~(bF^@UjxtS2~&R2Q?KK){M^QS]E*k7~QS5HthblERmy8k)%M4Vz@N@E|Q3c*:k|z>;vyYCQ%uU0[R9iV+;5),|b~/66L^Zfe{PrbygOi*;hpn1cvdOn#6^Eo^&Y}%2nV$pVp3rjJ^&MBZ~2Qd6B#XYHiH{hA.{c&QC]XZWR<blH@Ye3~#to;yPhv[vCPh;Y%e/QC9J$6q-2o~kpNjpLX*%zph{V|M^[#,AURuK,6KKh/Z{<D8?UYjeX6~K!.t@_^V$Ht>D*5ifV>6LZc-/[R?AfRH5nl:dvZh1$Pz+FA^EMERVQU)xlpJ^?l9?e;AHYrbOy6Em|zE&v4x|ol19v+gmF9(-2[/-oq;OE*kcvL/<x4NkS1@oDzLZEW$%KH6^o>H9uMxEQ:V}4M[Bt3K}f8/}i[2-x}fsqW3}(M8v}HChJ*YLobfcS39qYdOJo2bD|Ye7n;>yho<<ymYoQN!lQ.s)Yp-Vyzig_|hDF:2:mn@y>sk?Z!$nKA;3%r6XF<U6Nt,F6do$dYtzg-VLW:V;kyi.ZWdHKZ|V-_9{/u$9j|Au0(Kjg0O2DvK[bFJ1#3#&{q<G1L(Ju@>L9!(b4D-VM1yj,lPXZPvPCj0/)E/[DBH&*5[S5#zf-GV^B1y/[-q8U~G]Mh3OhiW/xW2KdVDxL$f00:4,Vz5#F]8217/x17~bWCX^PrquUuZZD+cXr<c[c$Z~2E*;:|k*JRlHbOY~4ye]AWm]xx93_AHvs?HPQb-n_;.HU~2,s[zj5PUIPOB"
local payloadBytes = decodePayload(PAYLOAD_BLOB, 11295)
local vmProgram = decodePacket(
  openPacket(
    { payloadBytes, { 2959865899, 90057854, 92 }, 11295, "hSV5oN?I\142\154@\153\021\\\137\216" },
    vmMasterKey
  )
)
envFingerprint = nil
payloadBytes = nil
PAYLOAD_BLOB = nil
vmMasterKey = nil
BASE85_ALPHABET = nil
local chunkTable, functionTable = vmProgram[39908], vmProgram[10886]
vmProgram = nil
local allocCache, allocList, allocState = {}, {}, { 0, 0, 0, 0 }
local MAX_BLOCKS, MAX_BYTES = 2048, 1048576
local function allocTouch(limbIndex, entry)
  if allocState[2] == limbIndex then
    return
  end
  local prevIndex, nextIndex = entry[1], entry[2]
  if prevIndex ~= 0 then
    allocList[prevIndex][2] = nextIndex
  else
    allocState[1] = nextIndex
  end
  if nextIndex ~= 0 then
    allocList[nextIndex][1] = prevIndex
  end
  allocList[allocState[2]][2] = limbIndex
  entry[1] = allocState[2]
  entry[2] = 0
  allocState[2] = limbIndex
end
local function allocStore(limbIndex, cacheEntry, payloadLength)
  if payloadLength > MAX_BYTES then
    return
  end
  while
    (allocState[4] > 0) and ((allocState[4] >= MAX_BLOCKS) or ((allocState[3] + payloadLength) > MAX_BYTES))
  do
    local oldestKey = allocState[1]
    local entry = allocList[oldestKey]
    allocState[1] = entry[2]
    allocState[3] = allocState[3] - entry[3]
    allocState[4] = allocState[4] - 1
    allocCache[oldestKey] = nil
    allocList[oldestKey] = nil
    if allocState[1] ~= 0 then
      allocList[allocState[1]][1] = 0
    else
      allocState[2] = 0
    end
  end
  allocList[limbIndex] = { allocState[2], 0, payloadLength }
  if allocState[2] ~= 0 then
    allocList[allocState[2]][2] = limbIndex
  else
    allocState[1] = limbIndex
  end
  allocState[2] = limbIndex
  allocState[3] = allocState[3] + payloadLength
  allocState[4] = allocState[4] + 1
  allocCache[limbIndex] = cacheEntry
end
local function buildConstEnv(lookup)
  local constIndex = {
    __index = function(k1, limbIndex)
      local entryInfo = lookup[limbIndex]
      if not entryInfo then
        vmError("invalid VM constant reference")
      end
      local cached = allocCache[limbIndex]
      if cached then
        allocTouch(limbIndex, allocList[limbIndex])
        return cached[1]
      end
      local value = decodePacket(openPacket(chunkTable[limbIndex], entryInfo))
      local cacheEntry = packArgs(value)
      if tableFreeze then
        tableFreeze(cacheEntry)
      end
      allocStore(limbIndex, cacheEntry, chunkTable[limbIndex][3])
      return value
    end,
  }
  return deepFreeze(setMetaTable({}, deepFreeze(constIndex)))
end
local functionCache = {}
local function loadFunction(limbIndex)
  local frame = functionCache[limbIndex]
  if frame then
    return frame
  end
  local entryInfo = functionTable[limbIndex]
  if not entryInfo then
    vmError("invalid VM function reference")
  end
  frame = decodePacket(openPacket(entryInfo[1], entryInfo[2]))
  frame[31820] = unmaskKey(frame[31820])
  deepFreeze(frame[4356])
  frame[61756] = buildConstEnv(frame[4356])
  frame[36440] = {}
  frame[39814] = { 0, 0, 0, 0 }
  frame[52106] = 64
  functionCache[limbIndex] = frame
  return frame
end
local function loadBlock(frame, blockId, blockCapability)
  local blockTable, capability = frame[36440], frame[39814]
  local cachedBlock = blockTable[blockId]
  if cachedBlock then
    if cachedBlock[6] ~= blockCapability then
      vmError("invalid VM block capability")
    end
    if capability[2] ~= blockId then
      local prevIndex, nextIndex = cachedBlock[3], cachedBlock[4]
      if prevIndex ~= 0 then
        blockTable[prevIndex][4] = nextIndex
      else
        capability[1] = nextIndex
      end
      if nextIndex ~= 0 then
        blockTable[nextIndex][3] = prevIndex
      end
      blockTable[capability[2]][4] = blockId
      cachedBlock[3] = capability[2]
      cachedBlock[4] = 0
      capability[2] = blockId
    end
    return cachedBlock[1], cachedBlock[5]
  end
  local packetInfo = frame[50952][blockId]
  if not packetInfo then
    vmError("invalid VM branch destination")
  end
  local code =
    deepFreeze(decodePacket(openPacket(packetInfo, deriveBlockKeys(frame[31820], blockId, blockCapability))))
  local codeBase = (((blockId * frame[56126]) + frame[53561]) % 65521) * 16
  local payloadLength = packetInfo[3]
  while
    (capability[4] > 0) and ((capability[4] >= frame[52106]) or ((capability[3] + payloadLength) > 262144))
  do
    local oldest = capability[1]
    local entry = blockTable[oldest]
    capability[1] = entry[4]
    capability[3] = capability[3] - entry[2]
    capability[4] = capability[4] - 1
    blockTable[oldest] = nil
    if capability[1] ~= 0 then
      blockTable[capability[1]][3] = 0
    else
      capability[2] = 0
    end
  end
  blockTable[blockId] = { code, payloadLength, capability[2], 0, codeBase, blockCapability }
  if capability[2] ~= 0 then
    blockTable[capability[2]][4] = blockId
  else
    capability[1] = blockId
  end
  capability[2] = blockId
  capability[3] = capability[3] + payloadLength
  capability[4] = capability[4] + 1
  return code, codeBase
end
local function decryptConst(value, shifted, keyWords, rotateBits, step, pos)
  if typeOf(value) == "number" then
    return bxor(((rol(value, rotateBits) - shifted) - (pos * step)) % 4294967296, keyWords)
  end
  if typeOf(value) == "table" then
    local records = {}
    for i = 1, #value do
      records[i] = decryptConst(value[i], shifted, keyWords, rotateBits, step, pos + i)
    end
    return records
  end
  return value
end
local function collectArgs(stack, baseIndex, count, stackStride, stackSlot)
  if count == 0 then
    return EMPTY_ARGS
  end
  if count == 1 then
    return stack[(baseIndex * stackStride) + stackSlot]
  end
  local result = { argCount = 0 }
  for i = 1, count do
    local collected = stack[(((baseIndex + i) - 1) * stackStride) + stackSlot]
    local valueLength = 1
    if i == count then
      valueLength = collected.argCount
    end
    for j = 1, valueLength do
      result.argCount = result.argCount + 1
      result[result.argCount] = collected[j]
    end
  end
  return result
end
local invokeVM, makeClosure
makeClosure = function(limbIndex, upvalues, bindEnv, bindCap)
  local fn
  fn = function(...)
    local args = packArgs(...)
    args.boundSelf = fn
    args.boundEnv = bindEnv
    args.boundCap = bindCap
    return invokeVM(limbIndex, upvalues, args)
  end
  if typeOf(setFenvFn) == "function" then
    setFenvFn(fn, bindEnv)
  end
  return fn
end
invokeVM = function(limbIndex, upvalues, args)
  local selfFn = args.boundSelf
  if not selfFn then
    return makeClosure(limbIndex, upvalues, globalEnv)(unpackArgs(args, 1, args.argCount))
  end
  local globalEnv2 = args.boundEnv or globalEnv
  local frame = loadFunction(limbIndex, args.boundCap)
  local constants = frame[61756]
  local registers = copyTable(upvalues)
  local paramNames = frame[24499]
  for i = 1, #paramNames do
    registers[paramNames[i]] = { [3351] = args[i] }
  end
  local varargs = EMPTY_ARGS
  if frame[60868] and (args.argCount > #paramNames) then
    varargs = { argCount = 0 }
    for i2 = #paramNames + 1, args.argCount do
      varargs.argCount = varargs.argCount + 1
      varargs[varargs.argCount] = args[i2]
    end
  end
  local stack, sp, jumpTarget, loopStates = {}, 0, nil, {}
  local stackStride, stackSlot = frame[59510], frame[37518]
  local opcodeMap = frame[37213]
  local opOffsetA, opOffsetB, opOffsetC
  local rollingBase, rollingMul, rollingStep = frame[46427], frame[43054], frame[63744]
  local blockIndex, blockCap = frame[29230], frame[44236]
  local code, codeBase = loadBlock(frame, blockIndex, blockCap)
  local pc = 1
  local rollingKey = code[codeBase + 52842]
  local instructions, fallthrough = code[codeBase + 46324], code[codeBase + 52097]
  opOffsetA, opOffsetB, opOffsetC = code[codeBase + 34145], code[codeBase + 33538], code[codeBase + 17119]
  while true do
    if pc > #instructions then
      if fallthrough == 0 then
        vmError("invalid VM fallthrough")
      end
      blockIndex, blockCap = transitionPair(fallthrough, blockIndex, rollingKey)
      code, codeBase = loadBlock(frame, blockIndex, blockCap)
      pc = 1
      rollingKey = code[codeBase + 52842]
      instructions, fallthrough = code[codeBase + 46324], code[codeBase + 52097]
      opOffsetA, opOffsetB, opOffsetC = code[codeBase + 34145], code[codeBase + 33538], code[codeBase + 17119]
    end
    local instr = instructions[pc]
    local instrParam = instr[opOffsetC]
    local prevKey = rollingKey
    local opcodeIndex = ((instr[opOffsetA] - instrParam) - rollingKey) % 65536
    local opcode = opcodeMap[opcodeIndex]
    if opcode == nil then
      vmError("invalid VM instruction alias")
    end
    rollingKey = (((rollingKey * rollingStep) + instr[opOffsetA]) + instrParam) % 65536
    pc = pc + 1
    jumpTarget = nil
    local opcodeClass = opcode % 4
    if opcodeClass == 3 then
      if 19603 >= opcode then
        if opcode >= 7724 then
          if opcode < 15640 then
            if not (opcode ~= 13499) then
              local operandData = instr[opOffsetB]
              local methodSeed = rollingBase
                + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local methodKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 13)) + (4294967296 - (methodSeed + 3634)))
                  % 4294967296,
                2790510965
              )
              local target = stack[(sp * stackStride) + stackSlot][1]
              if isLuau then
                stack[(sp * stackStride) + stackSlot] =
                  { argCount = 1, methodSelf = target, methodName = constants[methodKey] }
              else
                stack[(sp * stackStride) + stackSlot] = packArgs(target[constants[methodKey]])
              end
              sp = sp + 1
              stack[(sp * stackStride) + stackSlot] = packArgs(target)
            elseif 15639 == opcode then
              local namesData = instr[opOffsetB]
              local methodSeed = rollingBase
                + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local collected = stack[(sp * stackStride) + stackSlot]
              for i2 = 2, (#namesData + 1) do
                registers[bxor(
                  ((rol(namesData[i2 - 1], 2)) + (4294967296 - (methodSeed + ((i2 - 1) * 174)))) % 4294967296,
                  1243806836
                )] =
                  { [3351] = collected[i2 - 1] }
              end
              stack[(sp * stackStride) + stackSlot] = nil
              sp = sp - 1
            else
              vmError("invalid VM opcode")
            end
          else
            if not (opcode ~= 17519) then
              local target, keyWords, value =
                stack[((sp - 2) * stackStride) + stackSlot][1],
                stack[((sp - 1) * stackStride) + stackSlot][1],
                stack[(sp * stackStride) + stackSlot][1]
              target[keyWords] = value
              stack[(sp * stackStride) + stackSlot] = nil
              stack[((sp - 1) * stackStride) + stackSlot] = nil
              stack[((sp - 2) * stackStride) + stackSlot] = nil
              sp = sp - 3
            elseif opcode == 17239 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local returnKey = bxor(
                ((rol(operandData[(#operandData - 4) + 1], 12)) + (4294967296 - (instrKey + 9836)))
                  % 4294967296,
                228074771
              )
              local loopRef = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 12)) + (4294967296 - (instrKey + 2459)))
                  % 4294967296,
                228074771
              )
              local aliasKey = bxor(
                ((rol(operandData[(#operandData - 2) + 1], 12)) + (4294967296 - (instrKey + 4918)))
                  % 4294967296,
                228074771
              )
              local aliasKey2 = bxor(
                ((rol(operandData[(#operandData - 3) + 1], 12)) + (4294967296 - (instrKey + 7377)))
                  % 4294967296,
                228074771
              )
              local capability = loopStates[loopRef]
              if capability[4] then
                capability[4] = false
              else
                capability[1] = capability[1] + capability[3]
              end
              local valueLength, limit, step = capability[1], capability[2], capability[3]
              if ((step > 0) and (valueLength <= limit)) or ((step <= 0) and (valueLength >= limit)) then
                registers[aliasKey] = { [3351] = valueLength }
              else
                jumpTarget = { aliasKey2, returnKey }
                loopStates[loopRef] = nil
              end
            elseif 19603 == opcode then
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, {} }
              sp = sp + 1
            else
              vmError("invalid VM opcode")
            end
          end
        else
          if not (opcode ~= 7723) then
            stack[(sp * stackStride) + stackSlot] = nil
            sp = sp - 1
          elseif opcode == 7687 then
            local operandData = instr[opOffsetB]
            local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
            local loopCount = bxor(((rol(operandData[1], 15)) - (instrKey + 2101)) % 4294967296, 1538863306)
            local count = loopCount
            local baseIndex = (sp - count) + 1
            local b0 = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
            local callee = stack[((baseIndex - 1) * stackStride) + stackSlot]
            local callable = callee[1]
            for i2 = baseIndex, sp do
              stack[(i2 * stackStride) + stackSlot] = nil
            end
            local callResult
            if callee.methodName then
              callResult = dispatchNamecall(callee.methodSelf, callee.methodName, b0)
            elseif (getFenvFn and (callable == getFenvFn)) and ((b0[1] == nil) or (b0[1] == 1)) then
              callResult = getEnvOf(selfFn, globalEnv2)
            elseif (setFenvFn and (callable == setFenvFn)) and (b0[1] == 1) then
              local envResult = setFenvFn(selfFn, b0[2])
              globalEnv2 = b0[2]
              callResult = envResult
            else
              callResult = callable(unpackArgs(b0, 1, b0.argCount))
            end
            if callable == setMetaTable then
              proxyRegistry[b0[1]] = b0[2]
            elseif (callable == newProxyObject) and (b0[1] == true) then
              proxyRegistry[callResult] = getMetaTable(callResult)
            end
            stack[((baseIndex - 1) * stackStride) + stackSlot] = nil
            sp = baseIndex - 2
          elseif opcode == 6003 then
            local value = stack[(sp * stackStride) + stackSlot]
            sp = sp + 1
            stack[(sp * stackStride) + stackSlot] = value
          else
            vmError("invalid VM opcode")
          end
        end
      else
        if 36199 >= opcode then
          if 30287 < opcode then
            if 31807 < opcode then
              if opcode == 34143 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local aliasKey = bxor(((rol(operandData[2], 17)) - (instrKey + 62)) % 4294967296, 493701976)
                local aliasKey2 = bxor(((rol(operandData[3], 17)) - (instrKey + 93)) % 4294967296, 493701976)
                local aliasKey3 = bxor(((rol(operandData[4], 17)) - (instrKey + 124)) % 4294967296, 493701976)
                local loopRef = bxor(((rol(operandData[1], 17)) - (instrKey + 31)) % 4294967296, 493701976)
                local capability = loopStates[loopRef]
                if capability[4] then
                  capability[4] = false
                else
                  capability[1] = capability[1] + capability[3]
                end
                local valueLength, limit, step = capability[1], capability[2], capability[3]
                if ((step > 0) and (valueLength <= limit)) or ((step <= 0) and (valueLength >= limit)) then
                  registers[aliasKey] = { [3351] = valueLength }
                else
                  jumpTarget = { aliasKey2, aliasKey3 }
                  loopStates[loopRef] = nil
                end
              elseif opcode == 36199 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local constKey = bxor(((rol(operandData[1], 5)) - (instrKey + 1491)) % 4294967296, 2131186383)
                local constKey2 =
                  bxor(((rol(operandData[2], 5)) - (instrKey + 2982)) % 4294967296, 2131186383)
                local constVal1 = constants[constKey]
                local constVal2 = constants[constKey2]
                stack[((sp + 1) * stackStride) + stackSlot] = packArgs(constVal1)
                stack[((sp + 2) * stackStride) + stackSlot] = packArgs(constVal2)
                sp = sp + 2
              else
                vmError("invalid VM opcode")
              end
            else
              if 31807 == opcode then
                local namesData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local opField = bxor(
                  ((rol(namesData[(#namesData - 1) + 1], 20)) + (4294967296 - (instrKey + 1953))) % 4294967296,
                  3211455098
                )
                local b1, b0, opField2 =
                  stack[(sp * stackStride) + stackSlot][1],
                  stack[((sp - 1) * stackStride) + stackSlot][1],
                  opField
                sp = sp - 1
                local result
                if opField2 == 1 then
                  result = b0 + b1
                elseif opField2 == 2 then
                  result = b0 - b1
                elseif opField2 == 3 then
                  result = b0 * b1
                elseif opField2 == 4 then
                  result = b0 / b1
                elseif opField2 == 5 then
                  result = b0 // b1
                elseif opField2 == 6 then
                  result = b0 % b1
                elseif opField2 == 7 then
                  result = b0 ^ b1
                elseif opField2 == 8 then
                  result = b0 .. b1
                elseif opField2 == 9 then
                  result = b0 == b1
                elseif opField2 == 10 then
                  result = b0 ~= b1
                elseif opField2 == 11 then
                  result = b0 < b1
                elseif opField2 == 12 then
                  result = b0 > b1
                elseif opField2 == 13 then
                  result = b0 <= b1
                elseif opField2 == 14 then
                  result = b0 >= b1
                else
                  vmError("invalid VM operator")
                end
                stack[(sp * stackStride) + stackSlot] = { argCount = 1, result }
                stack[((sp + 1) * stackStride) + stackSlot] = nil
              else
                vmError("invalid VM opcode")
              end
            end
          else
            if opcode == 30287 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local constKey = bxor(((rol(operandData[1], 8)) - (instrKey + 3635)) % 4294967296, 2088866645)
              local value = getEnvOf(selfFn, globalEnv2)[constants[constKey]]
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, value }
              sp = sp + 1
            elseif 27443 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local opField3 = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 1)) + (4294967296 - (instrKey + 1234)))
                  % 4294967296,
                246844704
              )
              local b1, b0, opField2 =
                stack[(sp * stackStride) + stackSlot][1],
                stack[((sp - 1) * stackStride) + stackSlot][1],
                opField3
              sp = sp - 1
              local result
              if opField2 == 2 then
                result = b0 - b1
              elseif opField2 == 11 then
                result = b0 < b1
              elseif opField2 == 5 then
                result = b0 // b1
              elseif opField2 == 1 then
                result = b0 + b1
              elseif opField2 == 4 then
                result = b0 / b1
              elseif opField2 == 6 then
                result = b0 % b1
              elseif opField2 == 12 then
                result = b0 > b1
              elseif opField2 == 3 then
                result = b0 * b1
              elseif opField2 == 7 then
                result = b0 ^ b1
              elseif opField2 == 9 then
                result = b0 == b1
              elseif opField2 == 14 then
                result = b0 >= b1
              elseif opField2 == 13 then
                result = b0 <= b1
              elseif opField2 == 8 then
                result = b0 .. b1
              elseif opField2 == 10 then
                result = b0 ~= b1
              else
                vmError("invalid VM operator")
              end
              stack[(sp * stackStride) + stackSlot] = { argCount = 1, result }
              stack[((sp + 1) * stackStride) + stackSlot] = nil
            elseif not (opcode ~= 27007) then
              local target, keyWords, value =
                stack[((sp - 2) * stackStride) + stackSlot][1],
                stack[((sp - 1) * stackStride) + stackSlot][1],
                stack[(sp * stackStride) + stackSlot][1]
              target[keyWords] = value
              stack[(sp * stackStride) + stackSlot] = nil
              stack[((sp - 1) * stackStride) + stackSlot] = nil
              stack[((sp - 2) * stackStride) + stackSlot] = nil
              sp = sp - 3
            else
              vmError("invalid VM opcode")
            end
          end
        else
          if 55815 < opcode then
            if opcode <= 59435 then
              if opcode == 59435 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local constKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 13)) - (instrKey + 3984)) % 4294967296,
                  1855458172
                )
                local constVal = constants[constKey]
                local regVal = stack[(sp * stackStride) + stackSlot][1]
                local isEqual = (regVal == constVal)
                stack[(sp * stackStride) + stackSlot] = packArgs(isEqual)
              else
                vmError("invalid VM opcode")
              end
            else
              if not (opcode ~= 63607) then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local constKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 22)) + (4294967296 - (instrKey + 940)))
                    % 4294967296,
                  2389766467
                )
                local constKey2 = bxor(
                  ((rol(operandData[(#operandData - 2) + 1], 22)) + (4294967296 - (instrKey + 1880)))
                    % 4294967296,
                  2389766467
                )
                local constVal1 = constants[constKey]
                local constVal2 = constants[constKey2]
                stack[((sp + 2) * stackStride) + stackSlot] = { argCount = 1, constVal2 }
                stack[((sp + 1) * stackStride) + stackSlot] = packArgs(constVal1)
                sp = sp + 2
              elseif 60191 == opcode then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local aliasKey = bxor(
                  ((rol(operandData[(#operandData - 2) + 1], 13)) + (4294967296 - (instrKey + 4198)))
                    % 4294967296,
                  4090851529
                )
                local aliasKey2 = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 13)) + (4294967296 - (instrKey + 2099)))
                    % 4294967296,
                  4090851529
                )
                local truthy = not not stack[(sp * stackStride) + stackSlot][1]
                stack[(sp * stackStride) + stackSlot] = nil
                sp = sp - 1
                if truthy then
                  jumpTarget = { aliasKey2, aliasKey }
                end
              elseif not (opcode ~= 61147) then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local regKey = bxor(((rol(operandData[1], 31)) - (instrKey + 1753)) % 4294967296, 2597036957)
                local constKey =
                  bxor(((rol(operandData[2], 31)) - (instrKey + 3506)) % 4294967296, 2597036957)
                local regVal = registers[regKey][3351]
                local constVal = constants[constKey]
                stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, regVal }
                stack[((sp + 2) * stackStride) + stackSlot] = packArgs(constVal)
                sp = sp + 2
              else
                vmError("invalid VM opcode")
              end
            end
          else
            if 49351 < opcode then
              if opcode <= 51275 then
                if opcode == 51275 then
                  local names = instr[opOffsetB]
                  local methodSeed = rollingBase
                    + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                  local collected = stack[(sp * stackStride) + stackSlot]
                  for i2 = 2, (#names + 1) do
                    registers[bxor(
                      ((rol(names[i2 - 1], 8)) + (4294967296 - (methodSeed + ((i2 - 1) * 3314)))) % 4294967296,
                      2126278767
                    )] =
                      { [3351] = collected[i2 - 1] }
                  end
                  stack[(sp * stackStride) + stackSlot] = nil
                  sp = sp - 1
                else
                  vmError("invalid VM opcode")
                end
              else
                if opcode < 53392 then
                  if not (opcode ~= 53391) then
                    local operandData = instr[opOffsetB]
                    local instrKey = rollingBase
                      + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                    local aliasKey =
                      bxor(((rol(operandData[2], 20)) - (instrKey + 1950)) % 4294967296, 857077518)
                    local aliasKey2 =
                      bxor(((rol(operandData[1], 20)) - (instrKey + 975)) % 4294967296, 857077518)
                    local truthy = not not stack[(sp * stackStride) + stackSlot][1]
                    stack[(sp * stackStride) + stackSlot] = nil
                    sp = sp - 1
                    if not truthy then
                      jumpTarget = { aliasKey2, aliasKey }
                    end
                  elseif 53047 == opcode then
                    local operandData = instr[opOffsetB]
                    local methodSeed = rollingBase
                      + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                    local methodKey = bxor(
                      ((rol(operandData[(#operandData - 1) + 1], 14)) - (methodSeed + 46)) % 4294967296,
                      1040372596
                    )
                    local target = stack[(sp * stackStride) + stackSlot][1]
                    if isLuau then
                      stack[(sp * stackStride) + stackSlot] =
                        { argCount = 1, methodSelf = target, methodName = constants[methodKey] }
                    else
                      stack[(sp * stackStride) + stackSlot] = packArgs(target[constants[methodKey]])
                    end
                    sp = sp + 1
                    stack[(sp * stackStride) + stackSlot] = packArgs(target)
                  else
                    vmError("invalid VM opcode")
                  end
                else
                  if not (opcode ~= 55815) then
                    local operandData = instr[opOffsetB]
                    local instrKey = rollingBase
                      + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                    local constKey = bxor(
                      ((rol(operandData[(#operandData - 1) + 1], 19)) + (4294967296 - (instrKey + 92)))
                        % 4294967296,
                      4131651490
                    )
                    local constKey2 = bxor(
                      ((rol(operandData[(#operandData - 2) + 1], 19)) + (4294967296 - (instrKey + 184)))
                        % 4294967296,
                      4131651490
                    )
                    local tableVal = getEnvOf(selfFn, globalEnv2)[constants[constKey]]
                    local keyVal = constants[constKey2]
                    local indexedVal = tableVal[keyVal]
                    stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, indexedVal }
                    sp = sp + 1
                  else
                    vmError("invalid VM opcode")
                  end
                end
              end
            else
              if opcode == 49351 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local regKey =
                  bxor(((rol(operandData[1], 11)) + (4294967296 - (instrKey + 585))) % 4294967296, 2612705878)
                local keyReg = regKey
                sp = sp + 1
                stack[(sp * stackStride) + stackSlot] = { [3351] = registers[keyReg] }
              elseif opcode == 39195 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local regKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 24)) - (instrKey + 1053)) % 4294967296,
                  3366722161
                )
                local regVal = registers[regKey][3351]
                local isFalsy = not regVal
                stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, isFalsy }
                sp = sp + 1
              else
                vmError("invalid VM opcode")
              end
            end
          end
        end
      end
    elseif opcodeClass == 2 then
      if opcode >= 30571 then
        if opcode > 37282 then
          if opcode >= 49027 then
            if 53134 >= opcode then
              if opcode == 52754 then
                local namesData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                for i2 = 2, (#namesData + 1) do
                  registers[bxor(
                    (
                      (rol(namesData[(#namesData - (i2 - 1)) + 1], 20))
                      + (4294967296 - (instrKey + ((i2 - 1) * 1563)))
                    ) % 4294967296,
                    293602345
                  )] =
                    nil
                end
              elseif 53134 == opcode then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local regKey = bxor(((rol(operandData[1], 6)) - (instrKey + 1883)) % 4294967296, 1354517141)
                local constKey = bxor(((rol(operandData[2], 6)) - (instrKey + 3766)) % 4294967296, 1354517141)
                local regVal = registers[regKey][3351]
                local keyVal = constants[constKey]
                local indexedVal = regVal[keyVal]
                stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, indexedVal }
                sp = sp + 1
              else
                vmError("invalid VM opcode")
              end
            else
              if opcode >= 56627 then
                if opcode > 60470 then
                  if opcode == 62014 then
                    local operandData = instr[opOffsetB]
                    local instrKey = rollingBase
                      + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                    local constKey =
                      bxor(((rol(operandData[1], 17)) - (instrKey + 603)) % 4294967296, 3652362776)
                    sp = sp + 1
                    stack[(sp * stackStride) + stackSlot] = { argCount = 1, constants[constKey] }
                  else
                    vmError("invalid VM opcode")
                  end
                else
                  if not (opcode ~= 60470) then
                    sp = sp + 1
                    stack[(sp * stackStride) + stackSlot] = { argCount = 1, {} }
                  elseif opcode == 57590 then
                    local operandData = instr[opOffsetB]
                    local instrKey = rollingBase
                      + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                    local aliasKey = bxor(
                      ((rol(operandData[(#operandData - 1) + 1], 17)) - (instrKey + 593)) % 4294967296,
                      3816998808
                    )
                    local aliasKey2 = bxor(
                      ((rol(operandData[(#operandData - 2) + 1], 17)) - (instrKey + 1186)) % 4294967296,
                      3816998808
                    )
                    local truthy = not not stack[(sp * stackStride) + stackSlot][1]
                    stack[(sp * stackStride) + stackSlot] = nil
                    sp = sp - 1
                    if not truthy then
                      jumpTarget = { aliasKey, aliasKey2 }
                    end
                  else
                    vmError("invalid VM opcode")
                  end
                end
              else
                if opcode == 56626 then
                  stack[((sp + 1) * stackStride) + stackSlot] = stack[(sp * stackStride) + stackSlot]
                  sp = sp + 1
                else
                  vmError("invalid VM opcode")
                end
              end
            end
          else
            if opcode == 49026 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local loopCount = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 5)) - (instrKey + 1099)) % 4294967296,
                1608294759
              )
              local count = loopCount
              local baseIndex = (sp - count) + 1
              local b0 = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
              local callee = stack[((baseIndex - 1) * stackStride) + stackSlot]
              local callable = callee[1]
              for i2 = sp, baseIndex, -1 do
                stack[(i2 * stackStride) + stackSlot] = nil
              end
              local callResult
              if callee.methodName then
                callResult = packArgs(dispatchNamecall(callee.methodSelf, callee.methodName, b0))
              elseif (getFenvFn and (callable == getFenvFn)) and ((b0[1] == nil) or (b0[1] == 1)) then
                callResult = packArgs(getEnvOf(selfFn, globalEnv2))
              elseif (setFenvFn and (callable == setFenvFn)) and (b0[1] == 1) then
                local envResult = setFenvFn(selfFn, b0[2])
                globalEnv2 = b0[2]
                callResult = packArgs(envResult)
              else
                callResult = packArgs(callable(unpackArgs(b0, 1, b0.argCount)))
              end
              if callable == setMetaTable then
                proxyRegistry[b0[1]] = b0[2]
              elseif (callable == newProxyObject) and (b0[1] == true) then
                proxyRegistry[callResult[1]] = getMetaTable(callResult[1])
              end
              sp = baseIndex - 1
              stack[(sp * stackStride) + stackSlot] = callResult
            elseif not (opcode ~= 42570) then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local argCount2 = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 9)) - (instrKey + 2720)) % 4294967296,
                2119043770
              )
              local collected, count = stack[(sp * stackStride) + stackSlot], argCount2
              local baseIndex = sp - count
              for i2 = 1, count do
                local regEntry = stack[(((baseIndex + i2) - 1) * stackStride) + stackSlot]
                regEntry[1][regEntry[2]] = collected[i2]
              end
              for i3 = sp, baseIndex, -1 do
                stack[(i3 * stackStride) + stackSlot] = nil
              end
              sp = baseIndex - 1
            else
              vmError("invalid VM opcode")
            end
          end
        else
          if opcode < 33031 then
            if not (opcode ~= 33030) then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local slotKeys =
                decryptConst(operandData[(#operandData - 2) + 1], instrKey, 3282754226, 29, 2223, 2)
              local upvalueKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 29)) - (instrKey + 2223)) % 4294967296,
                3282754226
              )
              local slotList = slotKeys
              local capturedSlots = {}
              for i2 = 1, #slotList do
                capturedSlots[slotList[i2]] = registers[slotList[i2]]
              end
              sp = sp + 1
              stack[(sp * stackStride) + stackSlot] =
                packArgs(makeClosure(upvalueKey, capturedSlots, getEnvOf(selfFn, globalEnv2), args.boundCap))
            elseif not (opcode ~= 32934) then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local aliasKey = bxor(
                ((rol(operandData[(#operandData - 2) + 1], 7)) - (instrKey + 2074)) % 4294967296,
                1480453192
              )
              local aliasKey2 = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 7)) - (instrKey + 1037)) % 4294967296,
                1480453192
              )
              jumpTarget = { aliasKey2, aliasKey }
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode == 36934 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local regKey = bxor(((rol(operandData[1], 28)) - (instrKey + 3586)) % 4294967296, 945800157)
              local regVal = registers[regKey][3351]
              local regVal2 = stack[(sp * stackStride) + stackSlot][1]
              local sumVal = (regVal2 + regVal)
              stack[(sp * stackStride) + stackSlot] = packArgs(sumVal)
            elseif opcode == 37282 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local loopCount = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 30)) + (4294967296 - (instrKey + 950)))
                  % 4294967296,
                248647448
              )
              local count = loopCount
              local baseIndex = (sp - count) + 1
              local collected = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
              for i2 = baseIndex, sp do
                stack[(i2 * stackStride) + stackSlot] = nil
              end
              sp = baseIndex
              stack[(sp * stackStride) + stackSlot] = collected
            else
              vmError("invalid VM opcode")
            end
          end
        end
      else
        if opcode < 435 then
          if opcode == 434 then
            local operandData = instr[opOffsetB]
            local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
            local selfRef = bxor(
              ((rol(operandData[(#operandData - 1) + 1], 31)) - (instrKey + 3313)) % 4294967296,
              147117494
            )
            local value = selfRef
            value = ((value * value) + value) % 2
          else
            vmError("invalid VM opcode")
          end
        else
          if opcode < 14295 then
            if not (opcode ~= 14294) then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local fieldBits = rol(operandData[(#operandData - 1) + 1], 24)
              local maskSeed = instrKey + 299
              local loopKey = bxor(
                ((bxor(fieldBits, bnot(maskSeed)) + (2 * band(fieldBits, bnot(maskSeed)))) + 1) % 4294967296,
                2372212803
              )
              local collected = stack[(sp * stackStride) + stackSlot]
              local startVal, limit, step =
                toNumber(collected[1]), toNumber(collected[2]), toNumber(collected[3])
              if ((startVal == nil) or (limit == nil)) or (step == nil) then
                vmError("numeric for expects numbers")
              end
              loopStates[loopKey] = { startVal, limit, step, true }
              stack[(sp * stackStride) + stackSlot] = nil
              sp = sp - 1
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode == 25042 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local constKey = bxor(((rol(operandData[2], 21)) - (instrKey + 810)) % 4294967296, 2597020455)
              local regKey = bxor(((rol(operandData[1], 21)) - (instrKey + 405)) % 4294967296, 2597020455)
              local a0 = registers[regKey][3351]
              local constVal = constants[constKey]
              local isEqual = (a0 == constVal)
              stack[((sp + 1) * stackStride) + stackSlot] = packArgs(isEqual)
              sp = sp + 1
            elseif opcode == 30570 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local loopKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 22)) - (instrKey + 2840)) % 4294967296,
                2725099399
              )
              local collected = stack[(sp * stackStride) + stackSlot]
              local startVal, limit, step =
                toNumber(collected[1]), toNumber(collected[2]), toNumber(collected[3])
              if ((startVal == nil) or (limit == nil)) or (step == nil) then
                vmError("numeric for expects numbers")
              end
              loopStates[loopKey] = { startVal, limit, step, true }
              stack[(sp * stackStride) + stackSlot] = nil
              sp = sp - 1
            elseif not (opcode ~= 22822) then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local regKey = bxor(((rol(operandData[1], 19)) - (instrKey + 986)) % 4294967296, 1801055922)
              local constKey = bxor(((rol(operandData[2], 19)) - (instrKey + 1972)) % 4294967296, 1801055922)
              local regVal = registers[regKey][3351]
              local constVal = constants[constKey]
              stack[((sp + 2) * stackStride) + stackSlot] = { argCount = 1, constVal }
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, regVal }
              sp = sp + 2
            else
              vmError("invalid VM opcode")
            end
          end
        end
      end
    elseif opcodeClass == 1 then
      if opcode > 25549 then
        if opcode > 41305 then
          if 53953 < opcode then
            if opcode == 54181 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local regKey = bxor(
                ((rol(operandData[(#operandData - 4) + 1], 11)) + (4294967296 - (instrKey + 13160)))
                  % 4294967296,
                3262682641
              )
              local regKey2 = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 11)) + (4294967296 - (instrKey + 3290)))
                  % 4294967296,
                3262682641
              )
              local constKey = bxor(
                ((rol(operandData[(#operandData - 2) + 1], 11)) + (4294967296 - (instrKey + 6580)))
                  % 4294967296,
                3262682641
              )
              local regKey3 = bxor(
                ((rol(operandData[(#operandData - 3) + 1], 11)) + (4294967296 - (instrKey + 9870)))
                  % 4294967296,
                3262682641
              )
              local regVal = registers[regKey2][3351]
              local keyVal = constants[constKey]
              local indexedVal = regVal[keyVal]
              local regVal2 = registers[regKey3][3351]
              local product = (indexedVal * regVal2)
              local regVal3 = registers[regKey][3351]
              local total = (product + regVal3)
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, total }
              sp = sp + 1
            elseif not (opcode ~= 60893) then
              stack[(sp * stackStride) + stackSlot] =
                { argCount = 1, stack[(sp * stackStride) + stackSlot][1] }
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode < 50046 then
              if 50045 == opcode then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local constKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 3)) - (instrKey + 1125)) % 4294967296,
                  2826833781
                )
                local constVal = constants[constKey]
                local regVal = stack[(sp * stackStride) + stackSlot][1]
                local joined = (regVal .. constVal)
                local regVal2 = stack[((sp - 1) * stackStride) + stackSlot][1]
                local concatResult = (regVal2 .. joined)
                stack[(sp * stackStride) + stackSlot] = nil
                stack[((sp - 1) * stackStride) + stackSlot] = packArgs(concatResult)
                sp = sp - 1
              elseif not (opcode ~= 48617) then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local aliasKey = bxor(
                  ((rol(operandData[(#operandData - 2) + 1], 15)) + (4294967296 - (instrKey + 1560)))
                    % 4294967296,
                  3359779836
                )
                local aliasKey2 = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 15)) + (4294967296 - (instrKey + 780)))
                    % 4294967296,
                  3359779836
                )
                jumpTarget = { aliasKey2, aliasKey }
              else
                vmError("invalid VM opcode")
              end
            else
              if opcode == 53953 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local regKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 9)) + (4294967296 - (instrKey + 2025)))
                    % 4294967296,
                  697187401
                )
                sp = sp + 1
                stack[(sp * stackStride) + stackSlot] = { argCount = 1, registers[regKey][3351] }
              elseif 51489 == opcode then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local constKey =
                  bxor(((rol(operandData[2], 5)) + (4294967296 - (instrKey + 6278))) % 4294967296, 2011643782)
                local constKey2 =
                  bxor(((rol(operandData[1], 5)) + (4294967296 - (instrKey + 3139))) % 4294967296, 2011643782)
                local tableVal = getEnvOf(selfFn, globalEnv2)[constants[constKey2]]
                local keyVal = constants[constKey]
                local indexedVal = tableVal[keyVal]
                stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, indexedVal }
                sp = sp + 1
              else
                vmError("invalid VM opcode")
              end
            end
          end
        else
          if opcode <= 33777 then
            if opcode == 32381 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local loopCount = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 10)) + (4294967296 - (instrKey + 2597)))
                  % 4294967296,
                1562632767
              )
              local collected, count = stack[(sp * stackStride) + stackSlot], loopCount
              local baseIndex = sp - count
              for i2 = 1, count do
                local regEntry = stack[(((baseIndex + i2) - 1) * stackStride) + stackSlot]
                regEntry[1][regEntry[2]] = collected[i2]
              end
              for i3 = baseIndex, sp do
                stack[(i3 * stackStride) + stackSlot] = nil
              end
              sp = baseIndex - 1
            elseif 33777 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local constKey = bxor(
                ((rol(operandData[(#operandData - 2) + 1], 1)) + (4294967296 - (instrKey + 4196)))
                  % 4294967296,
                3565677297
              )
              local regKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 1)) + (4294967296 - (instrKey + 2098)))
                  % 4294967296,
                3565677297
              )
              local regVal = registers[regKey][3351]
              local keyVal = constants[constKey]
              local indexedVal = regVal[keyVal]
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, indexedVal }
              sp = sp + 1
            else
              vmError("invalid VM opcode")
            end
          else
            if 38765 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local unaryOp =
                bxor(((rol(operandData[1], 7)) + (4294967296 - (instrKey + 2527))) % 4294967296, 3363121940)
              local b0 = stack[(sp * stackStride) + stackSlot][1]
              local opField2 = unaryOp
              if opField2 == 1 then
                b0 = -b0
              elseif opField2 == 2 then
                b0 = not b0
              elseif opField2 == 3 then
                b0 = #b0
              else
                vmError("invalid VM operator")
              end
              stack[(sp * stackStride) + stackSlot] = { argCount = 1, b0 }
            elseif not (opcode ~= 41305) then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local loopCount = bxor(((rol(operandData[1], 30)) - (instrKey + 2724)) % 4294967296, 2342483824)
              local count = loopCount
              local baseIndex = (sp - count) + 1
              local collected = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
              for i2 = sp, baseIndex, -1 do
                stack[(i2 * stackStride) + stackSlot] = nil
              end
              sp = baseIndex
              stack[(sp * stackStride) + stackSlot] = collected
            else
              vmError("invalid VM opcode")
            end
          end
        end
      else
        if opcode > 15073 then
          if 25549 == opcode then
            local operandData = instr[opOffsetB]
            local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
            local unaryOp =
              bxor(((rol(operandData[1], 5)) + (4294967296 - (instrKey + 3101))) % 4294967296, 1665497977)
            local b0 = stack[(sp * stackStride) + stackSlot][1]
            local opField2 = unaryOp
            if opField2 == 1 then
              b0 = -b0
            elseif opField2 == 2 then
              b0 = not b0
            elseif opField2 == 3 then
              b0 = #b0
            else
              vmError("invalid VM operator")
            end
            stack[(sp * stackStride) + stackSlot] = { argCount = 1, b0 }
          elseif 15513 == opcode then
            local operandData = instr[opOffsetB]
            local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
            local regKey =
              bxor(((rol(operandData[1], 11)) + (4294967296 - (instrKey + 129))) % 4294967296, 550757152)
            local regVal = registers[regKey][3351]
            local regVal2 = stack[(sp * stackStride) + stackSlot][1]
            local sumVal = (regVal2 + regVal)
            stack[(sp * stackStride) + stackSlot] = { argCount = 1, sumVal }
          elseif not (opcode ~= 15441) then
            sp = sp + 1
            stack[(sp * stackStride) + stackSlot] = varargs
          else
            vmError("invalid VM opcode")
          end
        else
          if 13989 >= opcode then
            if 13989 == opcode then
              sp = sp - 1
              stack[((sp + 1) * stackStride) + stackSlot] = nil
            elseif 285 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local constKey = bxor(((rol(operandData[2], 17)) - (instrKey + 7786)) % 4294967296, 1164322621)
              local regKey = bxor(((rol(operandData[3], 17)) - (instrKey + 11679)) % 4294967296, 1164322621)
              local regKey2 = bxor(((rol(operandData[1], 17)) - (instrKey + 3893)) % 4294967296, 1164322621)
              local regKey3 = bxor(((rol(operandData[4], 17)) - (instrKey + 15572)) % 4294967296, 1164322621)
              local regVal = registers[regKey2][3351]
              local keyVal = constants[constKey]
              local indexedVal = regVal[keyVal]
              local regVal2 = registers[regKey][3351]
              local product = (indexedVal * regVal2)
              local regVal3 = registers[regKey3][3351]
              local total = (product + regVal3)
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, total }
              sp = sp + 1
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode == 15073 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local selfRef =
                bxor(((rol(operandData[1], 17)) + (4294967296 - (instrKey + 3264))) % 4294967296, 2868266157)
              local value = selfRef
              value = ((value * value) + value) % 2
            else
              vmError("invalid VM opcode")
            end
          end
        end
      end
    elseif opcodeClass == 0 then
      if 43364 >= opcode then
        if opcode < 13125 then
          if opcode > 8964 then
            if 13124 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local methodSeed =
                bxor(((rol(operandData[1], 19)) - (instrKey + 1769)) % 4294967296, 3577992992)
              local count = methodSeed
              local baseIndex = (sp - count) + 1
              local b0 = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
              local callee = stack[((baseIndex - 1) * stackStride) + stackSlot]
              local callable = callee[1]
              for i2 = baseIndex, sp do
                stack[(i2 * stackStride) + stackSlot] = nil
              end
              local callResult
              if callee.methodName then
                callResult = packArgs(dispatchNamecall(callee.methodSelf, callee.methodName, b0))
              elseif (getFenvFn and (callable == getFenvFn)) and ((b0[1] == nil) or (b0[1] == 1)) then
                callResult = packArgs(getEnvOf(selfFn, globalEnv2))
              elseif (setFenvFn and (callable == setFenvFn)) and (b0[1] == 1) then
                local envResult = setFenvFn(selfFn, b0[2])
                globalEnv2 = b0[2]
                callResult = packArgs(envResult)
              else
                callResult = packArgs(callable(unpackArgs(b0, 1, b0.argCount)))
              end
              if callable == setMetaTable then
                proxyRegistry[b0[1]] = b0[2]
              elseif (callable == newProxyObject) and (b0[1] == true) then
                proxyRegistry[callResult[1]] = getMetaTable(callResult[1])
              end
              sp = baseIndex - 1
              stack[(sp * stackStride) + stackSlot] = callResult
            elseif 9888 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local constKey =
                bxor(((rol(operandData[1], 26)) + (4294967296 - (instrKey + 2326))) % 4294967296, 1084692351)
              local value = constants[constKey]
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, value }
              sp = sp + 1
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode > 7144 then
              if 8964 == opcode then
                stack[((sp + 1) * stackStride) + stackSlot] = varargs
                sp = sp + 1
              else
                vmError("invalid VM opcode")
              end
            else
              if opcode == 4456 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local loopKeyList =
                  decryptConst(operandData[(#operandData - 2) + 1], instrKey, 1193914332, 25, 831, 2)
                local upvalueKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 25)) - (instrKey + 831)) % 4294967296,
                  1193914332
                )
                local slotList = loopKeyList
                local capturedSlots = {}
                for i2 = 1, #slotList do
                  capturedSlots[slotList[i2]] = registers[slotList[i2]]
                end
                sp = sp + 1
                stack[(sp * stackStride) + stackSlot] = packArgs(
                  makeClosure(upvalueKey, capturedSlots, getEnvOf(selfFn, globalEnv2), args.boundCap)
                )
              elseif opcode == 7144 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local regKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 13)) + (4294967296 - (instrKey + 1042)))
                    % 4294967296,
                  2754342359
                )
                local regVal = registers[regKey][3351]
                local isFalsy = not regVal
                stack[((sp + 1) * stackStride) + stackSlot] = packArgs(isFalsy)
                sp = sp + 1
              else
                vmError("invalid VM opcode")
              end
            end
          end
        else
          if 22504 >= opcode then
            if 19776 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local constKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 16)) + (4294967296 - (instrKey + 1885)))
                  % 4294967296,
                1983058950
              )
              local constVal = constants[constKey]
              local regVal = stack[(sp * stackStride) + stackSlot][1]
              local joined = (regVal .. constVal)
              local regVal2 = stack[((sp - 1) * stackStride) + stackSlot][1]
              local concatResult = (regVal2 .. joined)
              stack[(sp * stackStride) + stackSlot] = nil
              stack[((sp - 1) * stackStride) + stackSlot] = packArgs(concatResult)
              sp = sp - 1
            elseif 19768 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local regKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 13)) - (instrKey + 437)) % 4294967296,
                2680735548
              )
              local constKey = bxor(
                ((rol(operandData[(#operandData - 2) + 1], 13)) - (instrKey + 874)) % 4294967296,
                2680735548
              )
              local regKey2 = bxor(
                ((rol(operandData[(#operandData - 3) + 1], 13)) - (instrKey + 1311)) % 4294967296,
                2680735548
              )
              local constKey2 = bxor(
                ((rol(operandData[(#operandData - 4) + 1], 13)) - (instrKey + 1748)) % 4294967296,
                2680735548
              )
              local regVal = registers[regKey][3351]
              local keyVal = constants[constKey]
              local indexedVal = regVal[keyVal]
              local regVal2 = registers[regKey2][3351]
              local keyVal2 = constants[constKey2]
              local indexedVal2 = regVal2[keyVal2]
              stack[((sp + 1) * stackStride) + stackSlot] = packArgs(indexedVal)
              stack[((sp + 2) * stackStride) + stackSlot] = packArgs(indexedVal2)
              sp = sp + 2
            elseif opcode == 22504 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local regKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 18)) - (instrKey + 1171)) % 4294967296,
                2393162236
              )
              local value = registers[regKey][3351]
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, value }
              sp = sp + 1
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode > 25836 then
              if opcode > 37988 then
                if 43364 == opcode then
                  local operandData = instr[opOffsetB]
                  local instrKey = rollingBase
                    + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                  local methodSeed =
                    bxor(((rol(operandData[1], 8)) - (instrKey + 730)) % 4294967296, 1298177853)
                  local count = methodSeed
                  local baseIndex = (sp - count) + 1
                  local collected = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
                  for i2 = baseIndex, sp do
                    stack[(i2 * stackStride) + stackSlot] = nil
                  end
                  sp = baseIndex
                  stack[(sp * stackStride) + stackSlot] = collected
                  local collected2 = stack[(sp * stackStride) + stackSlot]
                  return unpackArgs(collected2, 1, collected2.argCount)
                else
                  vmError("invalid VM opcode")
                end
              else
                if 34492 == opcode then
                  local operandData = instr[opOffsetB]
                  local instrKey = rollingBase
                    + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                  local aliasKey =
                    bxor(((rol(operandData[2], 24)) - (instrKey + 7956)) % 4294967296, 1685999036)
                  local aliasKey2 =
                    bxor(((rol(operandData[1], 24)) - (instrKey + 3978)) % 4294967296, 1685999036)
                  local truthy = not not stack[(sp * stackStride) + stackSlot][1]
                  stack[(sp * stackStride) + stackSlot] = nil
                  sp = sp - 1
                  if truthy then
                    jumpTarget = { aliasKey2, aliasKey }
                  end
                elseif not (opcode ~= 37988) then
                  local regEntry = stack[(sp * stackStride) + stackSlot]
                  sp = sp + 1
                  stack[(sp * stackStride) + stackSlot] = { argCount = 1, regEntry[1][regEntry[2]] }
                else
                  vmError("invalid VM opcode")
                end
              end
            else
              if opcode == 25836 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local constKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 27)) - (instrKey + 3908)) % 4294967296,
                  3587409531
                )
                sp = sp + 1
                stack[(sp * stackStride) + stackSlot] =
                  { argCount = 1, getEnvOf(selfFn, globalEnv2)[constants[constKey]] }
              elseif not (opcode ~= 23676) then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local methodSeed = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 5)) + (4294967296 - (instrKey + 2318)))
                    % 4294967296,
                  3801731807
                )
                local count = methodSeed
                local baseIndex = (sp - count) + 1
                local b0 = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
                local callee = stack[((baseIndex - 1) * stackStride) + stackSlot]
                local callable = callee[1]
                for i2 = sp, baseIndex, -1 do
                  stack[(i2 * stackStride) + stackSlot] = nil
                end
                local callResult
                if callee.methodName then
                  callResult = dispatchNamecall(callee.methodSelf, callee.methodName, b0)
                elseif (getFenvFn and (callable == getFenvFn)) and ((b0[1] == nil) or (b0[1] == 1)) then
                  callResult = getEnvOf(selfFn, globalEnv2)
                elseif (setFenvFn and (callable == setFenvFn)) and (b0[1] == 1) then
                  local envResult = setFenvFn(selfFn, b0[2])
                  globalEnv2 = b0[2]
                  callResult = envResult
                else
                  callResult = callable(unpackArgs(b0, 1, b0.argCount))
                end
                if callable == setMetaTable then
                  proxyRegistry[b0[1]] = b0[2]
                elseif (callable == newProxyObject) and (b0[1] == true) then
                  proxyRegistry[callResult] = getMetaTable(callResult)
                end
                stack[((baseIndex - 1) * stackStride) + stackSlot] = nil
                sp = baseIndex - 2
              else
                vmError("invalid VM opcode")
              end
            end
          end
        end
      else
        if 54516 < opcode then
          if 54560 < opcode then
            if 61484 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local constKey =
                bxor(((rol(operandData[1], 8)) + (4294967296 - (instrKey + 3149))) % 4294967296, 1382337301)
              local h0 = constants[constKey]
              local regVal = stack[(sp * stackStride) + stackSlot][1]
              local isEqual = (regVal == h0)
              stack[(sp * stackStride) + stackSlot] = packArgs(isEqual)
            elseif 57164 == opcode then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local regKey = bxor(
                ((rol(operandData[(#operandData - 3) + 1], 18)) + (4294967296 - (instrKey + 348)))
                  % 4294967296,
                3287997684
              )
              local constKey = bxor(
                ((rol(operandData[(#operandData - 4) + 1], 18)) + (4294967296 - (instrKey + 464)))
                  % 4294967296,
                3287997684
              )
              local regKey2 = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 18)) + (4294967296 - (instrKey + 116)))
                  % 4294967296,
                3287997684
              )
              local constKey2 = bxor(
                ((rol(operandData[(#operandData - 2) + 1], 18)) + (4294967296 - (instrKey + 232)))
                  % 4294967296,
                3287997684
              )
              local regVal = registers[regKey2][3351]
              local keyVal = constants[constKey2]
              local indexedVal = regVal[keyVal]
              local regVal2 = registers[regKey][3351]
              local keyVal2 = constants[constKey]
              local indexedVal2 = regVal2[keyVal2]
              stack[((sp + 2) * stackStride) + stackSlot] = packArgs(indexedVal2)
              stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, indexedVal }
              sp = sp + 2
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode == 54560 then
              local namesData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              for i2 = 2, (#namesData + 1) do
                registers[bxor(
                  ((rol(namesData[i2 - 1], 16)) - (instrKey + ((i2 - 1) * 2446))) % 4294967296,
                  3861984806
                )] =
                  nil
              end
            else
              vmError("invalid VM opcode")
            end
          end
        else
          if opcode > 51052 then
            if 51776 == opcode then
              stack[(sp * stackStride) + stackSlot] =
                { argCount = 1, stack[(sp * stackStride) + stackSlot][1] }
            elseif opcode == 54516 then
              local operandData = instr[opOffsetB]
              local instrKey = rollingBase + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
              local regKey = bxor(
                ((rol(operandData[(#operandData - 1) + 1], 22)) - (instrKey + 3578)) % 4294967296,
                2282102958
              )
              local keyReg = regKey
              sp = sp + 1
              stack[(sp * stackStride) + stackSlot] = { [3351] = registers[keyReg] }
            else
              vmError("invalid VM opcode")
            end
          else
            if opcode >= 45665 then
              if 51052 == opcode then
                local regEntry = stack[(sp * stackStride) + stackSlot]
                sp = sp + 1
                stack[(sp * stackStride) + stackSlot] = { argCount = 1, regEntry[1][regEntry[2]] }
              elseif opcode == 47944 then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local constKey = bxor(
                  ((rol(operandData[(#operandData - 2) + 1], 16)) - (instrKey + 1460)) % 4294967296,
                  138471107
                )
                local regKey = bxor(
                  ((rol(operandData[(#operandData - 1) + 1], 16)) - (instrKey + 730)) % 4294967296,
                  138471107
                )
                local regVal = registers[regKey][3351]
                local constVal = constants[constKey]
                local isEqual = (regVal == constVal)
                stack[((sp + 1) * stackStride) + stackSlot] = { argCount = 1, isEqual }
                sp = sp + 1
              else
                vmError("invalid VM opcode")
              end
            else
              if 45664 == opcode then
                local operandData = instr[opOffsetB]
                local instrKey = rollingBase
                  + (((instrParam * rollingMul) + (prevKey * rollingStep)) % 1000003)
                local methodSeed = bxor(
                  ((rol(operandData[1], 19)) + (4294967296 - (instrKey + 2470))) % 4294967296,
                  2053276276
                )
                local count = methodSeed
                local baseIndex = (sp - count) + 1
                local collected = collectArgs(stack, baseIndex, count, stackStride, stackSlot)
                for i2 = sp, baseIndex, -1 do
                  stack[(i2 * stackStride) + stackSlot] = nil
                end
                sp = baseIndex
                stack[(sp * stackStride) + stackSlot] = collected
                local collected2 = stack[(sp * stackStride) + stackSlot]
                return unpackArgs(collected2, 1, collected2.argCount)
              else
                vmError("invalid VM opcode")
              end
            end
          end
        end
      end
    else
      vmError("invalid VM opcode")
    end
    if jumpTarget then
      blockIndex, blockCap = transitionPair(jumpTarget, blockIndex, prevKey)
      code, codeBase = loadBlock(frame, blockIndex, blockCap)
      pc = 1
      rollingKey = code[codeBase + 52842]
      instructions, fallthrough = code[codeBase + 46324], code[codeBase + 52097]
      opOffsetA, opOffsetB, opOffsetC = code[codeBase + 34145], code[codeBase + 33538], code[codeBase + 17119]
    end
  end
end
do
  local ok, callResult = pcall(function()
    return packArgs(invokeVM(4, {}, packArgs(40, 4)))
  end)
  local probeOk = (
    (((ok and (typeOf(callResult) == "table")) and (callResult.argCount == 3)) and (callResult[1] == 138))
    and (callResult[2] == nil)
  ) and (callResult[3] == false)
  local debugInfo2 = (typeOf(debug) == "table") and debug.info
  if typeOf(debugInfo2) == "function" then
    local infoOk, infoParams, infoVararg, infoFunc = pcall(debugInfo2, invokeVM, "af")
    probeOk = (((probeOk and infoOk) and (infoParams == 3)) and (infoVararg == false))
      and (infoFunc == invokeVM)
  end
  if not probeOk then
    envSalt = bxor(envSalt, 2291712866)
  end
end
return invokeVM(1, {}, packArgs(...))
