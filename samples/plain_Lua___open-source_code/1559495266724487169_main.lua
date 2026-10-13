-- SIFF controlled-delivery loader
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local API = "https://siff.xyz"
local LOADER_ID = "siff_main_loader_v1"
local HEARTBEAT_INTERVAL = 30
local HEARTBEAT_GRACE = 300
local bit = bit32
local MOD = 4294967296
local runtimeGuardEnvironment = nil
local runtimeGuardKey = "__siff_runtime_guard_v1"
local runtimeGuard = nil

local function releaseRuntimeGuard()
  if type(runtimeGuardEnvironment) == "table"
    and rawget(runtimeGuardEnvironment, runtimeGuardKey) == runtimeGuard then
    rawset(runtimeGuardEnvironment, runtimeGuardKey, nil)
  end
end

local function rejectRuntime(message)
  releaseRuntimeGuard()
  local text = "SIFF: " .. tostring(message or "Authorization was rejected.")
  pcall(function()
    local player = game:GetService("Players").LocalPlayer
    if player then player:Kick(text) end
  end)
  error(text, 0)
end

local key = script_key
if type(key) ~= "string" then
  local environmentOk, environment = pcall(getgenv)
  if environmentOk and type(environment) == "table" then
    key = rawget(environment, "script_key")
  end
end
if type(key) ~= "string" and type(_G) == "table" then
  key = rawget(_G, "script_key")
end
if type(key) ~= "string" or #key < 16 then
  rejectRuntime("The license key is missing or invalid.")
end

local requestFn = (syn and syn.request) or http_request or request
if type(requestFn) ~= "function" then
  rejectRuntime("Your executor does not provide the required HTTP request support.")
end

do
  local environmentOk, environment = pcall(getgenv)
  if environmentOk and type(environment) == "table" then
    local existing = rawget(environment, runtimeGuardKey)
    local now = os.clock()
    local recentlyStarting = type(existing) == "table"
      and existing.starting == true
      and now - (tonumber(existing.started_at) or now) < 45
    if type(existing) == "table" and (existing.active == true or recentlyStarting) then
      return
    end
    runtimeGuardEnvironment = environment
    runtimeGuard = { starting = true, active = false, started_at = now }
    rawset(environment, runtimeGuardKey, runtimeGuard)
  end
end

local K = {
  1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,
  3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,
  3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,
  2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,
  666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,
  2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,
  430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,
  1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298
}

local function sha256Bytes(message)
  local messageLength = #message
  local bitLength = messageLength * 8
  local paddedLength = messageLength + 9
  paddedLength = paddedLength + ((64 - (paddedLength % 64)) % 64)
  local function paddedByte(position)
    if position <= messageLength then
      return string.byte(message, position)
    end
    if position == messageLength + 1 then
      return 128
    end
    local lengthStart = paddedLength - 7
    if position >= lengthStart then
      local shift = (paddedLength - position) * 8
      return math.floor(bitLength / (256 ^ (shift / 8))) % 256
    end
    return 0
  end
  local h = {1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225}
  for offset = 1, paddedLength, 64 do
    local w = {}
    for i = 0, 15 do
      local j = offset + i * 4
      w[i] = (((paddedByte(j) * 256 + paddedByte(j + 1)) * 256 + paddedByte(j + 2)) * 256 + paddedByte(j + 3)) % MOD
    end
    for i = 16, 63 do
      local s0 = bit.bxor(bit.rrotate(w[i - 15], 7), bit.rrotate(w[i - 15], 18), bit.rshift(w[i - 15], 3))
      local s1 = bit.bxor(bit.rrotate(w[i - 2], 17), bit.rrotate(w[i - 2], 19), bit.rshift(w[i - 2], 10))
      w[i] = (w[i - 16] + s0 + w[i - 7] + s1) % MOD
    end
    local a,b,c,d,e,f,g,hh = h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
    for i = 0, 63 do
      local s1 = bit.bxor(bit.rrotate(e, 6), bit.rrotate(e, 11), bit.rrotate(e, 25))
      local ch = bit.bxor(bit.band(e, f), bit.band(bit.bnot(e), g))
      local t1 = (hh + s1 + ch + K[i + 1] + w[i]) % MOD
      local s0 = bit.bxor(bit.rrotate(a, 2), bit.rrotate(a, 13), bit.rrotate(a, 22))
      local maj = bit.bxor(bit.band(a, b), bit.band(a, c), bit.band(b, c))
      local t2 = (s0 + maj) % MOD
      hh,g,f,e,d,c,b,a = g,f,e,(d + t1) % MOD,c,b,a,(t1 + t2) % MOD
    end
    local values = {a,b,c,d,e,f,g,hh}
    for i = 1, 8 do h[i] = (h[i] + values[i]) % MOD end
  end
  local output = {}
  for i = 1, 8 do
    for shift = 3, 0, -1 do
      table.insert(output, string.char(math.floor(h[i] / (256 ^ shift)) % 256))
    end
  end
  return table.concat(output)
end

local function hmacSha256Bytes(secret, message)
  if #secret > 64 then secret = sha256Bytes(secret) end
  secret = secret .. string.rep("\0", 64 - #secret)
  local inner, outer = {}, {}
  for i = 1, 64 do
    local byte = string.byte(secret, i)
    inner[i] = string.char(bit.bxor(byte, 54))
    outer[i] = string.char(bit.bxor(byte, 92))
  end
  return sha256Bytes(table.concat(outer) .. sha256Bytes(table.concat(inner) .. message))
end

local function hmacSha256Hex(secret, message)
  local digest = hmacSha256Bytes(secret, message)
  return (digest:gsub(".", function(char) return string.format("%02x", string.byte(char)) end))
end

local function sha256Hex(message)
  return (sha256Bytes(message):gsub(".", function(char)
    return string.format("%02x", string.byte(char))
  end))
end

local requestBindingKey = nil
local requestTimeOffset = 0

local function requestNonce()
  local ok, value = pcall(HttpService.GenerateGUID, HttpService, false)
  if not ok or type(value) ~= "string" or #value < 32 then
    value = sha256Hex(table.concat({
      tostring(os.clock()), tostring(math.random()), tostring(game.GameId), tostring(game.PlaceId)
    }, ":"))
  end
  return tostring(os.time() + requestTimeOffset) .. "." .. value
end

local function send(method, path, body, bearer)
  local headers = {}
  local bodyText = nil
  if body ~= nil then bodyText = HttpService:JSONEncode(body) end
  if bearer then
    if type(requestBindingKey) ~= "string" or #requestBindingKey ~= 32 then
      error("Runtime request binding is unavailable", 0)
    end
    local nonce = requestNonce()
    local canonical = table.concat({
      string.upper(method), path, sha256Hex(bodyText or ""), nonce
    }, "\n")
    headers["Authorization"] = "Bearer " .. bearer
    headers["X-SIFF-Nonce"] = nonce
    headers["X-SIFF-Proof"] = hmacSha256Hex(requestBindingKey, canonical)
  end
  local options = {
    Url = API .. path,
    Method = method,
    Headers = headers,
    Timeout = 15
  }
  if bodyText ~= nil then
    headers["Content-Type"] = "application/siff+json"
    options.Body = bodyText
  end
  return requestFn(options)
end

local function jsonRequest(method, path, body, bearer, rejectImmediately)
  local lastError = "transport failure"
  for attempt = 1, 3 do
    local ok, response = pcall(send, method, path, body, bearer)
    if ok and type(response) == "table" then
      local status = response.StatusCode or response.Status
      if status and status >= 200 and status < 300 then
        local decodedOk, decoded = pcall(HttpService.JSONDecode, HttpService, response.Body or "")
        assert(decodedOk and type(decoded) == "table", "Authorization response was malformed")
        return decoded
      end
      if status and status < 500 and status ~= 429 then
        local decodedOk, decoded = pcall(HttpService.JSONDecode, HttpService, response.Body or "")
        local message = decodedOk and type(decoded) == "table"
          and type(decoded.error) == "table" and decoded.error.message
          or ("Authorization rejected (" .. tostring(status) .. ")")
        if rejectImmediately == false then
          return nil, status
        end
        rejectRuntime(message)
      end
      lastError = "HTTP " .. tostring(status)
    end
    if attempt < 3 then task.wait((0.35 * (2 ^ (attempt - 1))) * (0.75 + math.random() * 0.5)) end
  end
  error("Authorization service unavailable: " .. lastError)
end

local function textRequest(method, path, bearer)
  local lastError = "transport failure"
  for attempt = 1, 3 do
    local ok, response = pcall(send, method, path, nil, bearer)
    if ok and type(response) == "table" then
      local status = response.StatusCode or response.Status
      if status and status >= 200 and status < 300 then
        return response.Body or ""
      end
      if status and status < 500 and status ~= 429 then
        local decodedOk, decoded = pcall(HttpService.JSONDecode, HttpService, response.Body or "")
        local message = decodedOk and type(decoded) == "table"
          and type(decoded.error) == "table" and decoded.error.message
          or ("Protected payload rejected (" .. tostring(status) .. ")")
        rejectRuntime(message)
      end
      lastError = "HTTP " .. tostring(status)
    end
    if attempt < 3 then task.wait((0.35 * (2 ^ (attempt - 1))) * (0.75 + math.random() * 0.5)) end
  end
  error("Protected payload unavailable: " .. lastError)
end

local hwid = nil
pcall(function()
  if gethwid then hwid = gethwid() end
end)
local executorName = "Unknown"
pcall(function()
  if type(identifyexecutor) == "function" then
    local name, version = identifyexecutor()
    executorName = tostring(name or "Unknown")
    if version ~= nil and tostring(version) ~= "" then
      executorName = executorName .. " " .. tostring(version)
    end
  elseif type(getexecutorname) == "function" then
    executorName = tostring(getexecutorname() or "Unknown")
  end
end)

local function runtimePresence()
  local snapshot = {
    universe_id = tostring(game.GameId),
    place_id = tostring(game.PlaceId)
  }
  local jobId = tostring(game.JobId or "")
  if jobId ~= "" then snapshot.job_id = jobId end
  local player = Players.LocalPlayer
  if player then
    snapshot.roblox_user_id = tostring(player.UserId)
    snapshot.roblox_username = string.sub(tostring(player.Name), 1, 64)
    snapshot.roblox_display_name = string.sub(tostring(player.DisplayName), 1, 100)
  end
  pcall(function()
    snapshot.player_count = #Players:GetPlayers()
  end)
  pcall(function()
    snapshot.server_capacity = tonumber(Players.MaxPlayers)
  end)
  return snapshot
end

local challenge = jsonRequest("POST", "/v1/runtime/challenge", { loader_id = LOADER_ID })
assert(type(challenge.challenge) == "string" and type(challenge.project_id) == "string", "Challenge response was malformed")
local canonical = table.concat({"sentinel-auth-v1", LOADER_ID, challenge.project_id, challenge.challenge, hwid or ""}, "\n")
local proof = hmacSha256Hex(key, canonical)
local authRequest = {
  loader_id = LOADER_ID,
  project_id = challenge.project_id,
  challenge = challenge.challenge,
  key = key,
  proof = proof,
  hwid = hwid,
  executor_name = string.sub(executorName, 1, 100)
}
for field, value in pairs(runtimePresence()) do authRequest[field] = value end
local auth = jsonRequest("POST", "/v1/runtime/authenticate", authRequest)
assert(auth.protocol_version == 2 and auth.runtime_protocol == "siff-runtime-v2", "Runtime request protocol was not accepted")
assert(type(auth.request_binding_salt) == "string" and #auth.request_binding_salt >= 32, "Runtime request binding response was malformed")
assert(type(auth.server_epoch_seconds) == "number", "Runtime server time response was malformed")
assert(type(auth.session_token) == "string" and type(auth.heartbeat_interval) == "number", "Authentication response was malformed")
local localEpoch = os.time()
local serverEpoch = math.floor(auth.server_epoch_seconds)
assert(serverEpoch >= 1577836800 and serverEpoch <= 4102444800, "Runtime server time was outside the supported range")
assert(math.abs(serverEpoch - localEpoch) <= 315576000, "Local system time was outside the supported range")
requestTimeOffset = serverEpoch - localEpoch
requestBindingKey = hmacSha256Bytes(
  proof,
  "siff-runtime-request-v1\n" .. auth.request_binding_salt .. "\n" .. auth.session_token
)
authRequest = nil
script_key = nil
pcall(function() getgenv().script_key = nil end)
pcall(function() _G.script_key = nil end)
key, proof = nil, nil

local session = auth.session_token
local state = { authorized = true, reason = nil }
getgenv().siff_authorization_state = state
local stopped = false
local preservingKickMessage = false
local terminalKickIssued = false
local lastSuccess = os.clock()
local deliveryCapabilities = {}
local deliveryExecutionProofs = {}
local deliveryManifests = {}
local deliveryCompletions = {}
local adaptiveBodyTokens = {}

local function idempotencyKey()
  local ok, value = pcall(HttpService.GenerateGUID, HttpService, false)
  if ok and type(value) == "string" and #value >= 32 then return value end
  return sha256Hex(table.concat({
    tostring(os.clock()),
    tostring(math.random()),
    tostring(game.GameId),
    tostring(game.PlaceId)
  }, ":"))
end

local function confirmStageExecution(attestation, executionProof)
  if deliveryCompletions[attestation] == true then return true end
  local manifest = deliveryManifests[attestation]
  if type(manifest) ~= "table" then return false end
  local submittedProof = executionProof
  if manifest.proof_mode == "bound" then
    submittedProof = hmacSha256Hex(
      executionProof,
      manifest.attestation .. "\n" .. manifest.delivery_token
    )
  end
  local completionPath = "/v1/runtime/stages/complete"
  local completionBody = {
    delivery_token = manifest.delivery_token,
    execution_proof = submittedProof
  }
  if manifest.component == "broker" and type(manifest.capsule_id) == "string" then
    completionPath = "/v1/runtime/capsules/" .. manifest.capsule_id .. "/broker/complete"
    completionBody.idempotency_key = manifest.completion_idempotency_key
  end
  local completion = jsonRequest("POST", completionPath, completionBody, session)
  if type(completion) ~= "table" or completion.completed ~= true then
    return false
  end
  if manifest.component == "broker" then
    if type(completion.body_token) ~= "string" or #completion.body_token < 32 then
      return false
    end
    adaptiveBodyTokens[manifest.capsule_id] = completion.body_token
  end
  deliveryCompletions[attestation] = true
  deliveryExecutionProofs[attestation] = nil
  return true
end

local function runtimeCapability(label, watermark, attestation, innerLabel, executionProof, phase)
  if preservingKickMessage or terminalKickIssued then
    return deliveryCapabilities[attestation] == (label .. "\n" .. watermark)
  end
  if stopped or state.authorized ~= true then return false end
  if os.clock() - lastSuccess > HEARTBEAT_GRACE then
    stopped = true
    state.authorized = false
    state.reason = "heartbeat_grace_expired"
    return false
  end
  if type(label) ~= "string" or type(watermark) ~= "string" or type(attestation) ~= "string" then
    return false
  end
  if deliveryCapabilities[attestation] ~= (label .. "\n" .. watermark) then
    return false
  end
  if innerLabel ~= nil and innerLabel ~= label then return false end
  if phase == "complete" then
    if type(executionProof) ~= "string" or #executionProof < 32 or #executionProof > 128 then
      return false
    end
    deliveryExecutionProofs[attestation] = executionProof
    local manifest = deliveryManifests[attestation]
    if type(manifest) == "table" and manifest.component == "broker" then
      return true
    end
    return confirmStageExecution(attestation, executionProof)
  end
  return true
end

local function payloadFromManifest(manifest)
  assert(type(manifest.delivery_token) == "string", "Protected delivery manifest was malformed")
  local minimumPartCount = manifest.component == "broker" and 1 or 3
  assert(type(manifest.part_count) == "number" and manifest.part_count >= minimumPartCount and manifest.part_count <= 12, "Protected delivery part count was invalid")
  assert(type(manifest.sha256) == "string" and #manifest.sha256 == 64, "Protected delivery digest was invalid")
  assert(type(manifest.label) == "string" and type(manifest.watermark) == "string" and type(manifest.attestation) == "string", "Protected delivery attestation was invalid")
  assert(manifest.proof_mode == "bound" or manifest.proof_mode == "legacy", "Protected delivery proof mode was invalid")
  local parts = {}
  for index = 0, manifest.part_count - 1 do
    parts[index + 1] = textRequest(
      "GET",
      "/v1/runtime/stages/" .. manifest.delivery_token .. "/" .. tostring(index),
      session
    )
  end
  local payload = table.concat(parts)
  if sha256Hex(payload) ~= string.lower(manifest.sha256) then
    rejectRuntime("Protected delivery integrity verification failed.")
  end
  deliveryCapabilities[manifest.attestation] = manifest.label .. "\n" .. manifest.watermark
  deliveryManifests[manifest.attestation] = manifest
  return payload, manifest
end

local function completeStage(manifest)
  if deliveryCompletions[manifest.attestation] == true then
    deliveryManifests[manifest.attestation] = nil
    return
  end
  local executionProof = deliveryExecutionProofs[manifest.attestation]
  if type(executionProof) ~= "string" then
    rejectRuntime("Protected stage execution could not be verified.")
  end
  if not confirmStageExecution(manifest.attestation, executionProof) then
    rejectRuntime("Protected stage execution confirmation failed.")
  end
  deliveryManifests[manifest.attestation] = nil
end

local function adaptivePayload(kind, placeId)
  local requestBody = {
    kind = kind,
    idempotency_key = idempotencyKey()
  }
  if placeId ~= nil then requestBody.place_id = tostring(placeId) end
  local capsule, status = jsonRequest(
    "POST",
    "/v1/runtime/capsules",
    requestBody,
    session,
    false
  )
  if capsule == nil then
    rejectRuntime("Adaptive protected delivery could not be started (HTTP " .. tostring(status) .. ").")
  end
  assert(type(capsule) == "table" and type(capsule.delivery) == "table", "Adaptive delivery manifest was malformed")
  if capsule.mode == "legacy" then
    return payloadFromManifest(capsule.delivery)
  end
  assert(capsule.mode == "adaptive", "Adaptive delivery mode was invalid")
  assert(type(capsule.capsule_id) == "string" and #capsule.capsule_id >= 32, "Adaptive capsule identifier was invalid")

  local brokerManifest = capsule.delivery
  brokerManifest.capsule_id = capsule.capsule_id
  brokerManifest.component = "broker"
  brokerManifest.completion_idempotency_key = requestBody.idempotency_key
  local brokerPayload = payloadFromManifest(brokerManifest)
  local brokerExecutable, brokerCompileError = loadstring(brokerPayload)
  brokerPayload = nil
  assert(type(brokerExecutable) == "function", "Security broker could not compile: " .. tostring(brokerCompileError))
  local brokerExecuted, brokerResult = pcall(brokerExecutable, runtimeCapability)
  if not brokerExecuted then error("Security broker failed: " .. tostring(brokerResult)) end
  completeStage(brokerManifest)
  brokerManifest = nil
  if brokerResult == false then rejectRuntime("Security broker rejected this session.") end

  local bodyToken = adaptiveBodyTokens[capsule.capsule_id]
  adaptiveBodyTokens[capsule.capsule_id] = nil
  assert(type(bodyToken) == "string", "Adaptive body token was not issued")
  local body = jsonRequest("POST", "/v1/runtime/capsules/body", {
    body_token = bodyToken,
    idempotency_key = idempotencyKey()
  }, session)
  bodyToken = nil
  assert(type(body) == "table" and body.mode == "adaptive", "Adaptive body response was malformed")
  assert(body.capsule_id == capsule.capsule_id and type(body.delivery) == "table", "Adaptive body did not match its broker")
  body.delivery.capsule_id = capsule.capsule_id
  body.delivery.component = "body"
  return payloadFromManifest(body.delivery)
end

task.spawn(function()
  local failures = 0
  local function heartbeatWaitSeconds()
    if failures == 0 then
      return HEARTBEAT_INTERVAL
    end

    -- A failed heartbeat needs a quicker recovery attempt, not exponential
    -- backoff. Slow backoff can consume the entire authorization grace window
    -- during a brief executor, network, proxy, or API interruption.
    local retryBase = math.max(3, math.min(8, HEARTBEAT_INTERVAL / 4))
    local retryCeiling = math.max(retryBase, HEARTBEAT_INTERVAL / 2)
    return math.min(retryBase * (2 ^ math.min(failures - 1, 2)), retryCeiling)
  end
  local function stopForHeartbeatLoss()
    if terminalKickIssued then return end
    terminalKickIssued = true
    preservingKickMessage = true
    stopped = true
    state.authorized = false
    state.reason = "heartbeat_connection_lost"
    releaseRuntimeGuard()
    local callback = rawget(getgenv(), "siff_on_revoked")
    if type(callback) == "function" then pcall(callback, state.reason) end
    pcall(function()
      local player = Players.LocalPlayer
      if player then
        player:Kick("SIFF: Connection to authorization service was lost. Please rejoin and execute the script again.")
      end
    end)
  end
  while not stopped do
    local base = heartbeatWaitSeconds()
    task.wait(base * (0.85 + math.random() * 0.3))
    local ok, heartbeatResult, heartbeatStatus = pcall(function()
      return jsonRequest("POST", "/v1/runtime/heartbeat", runtimePresence(), session, false)
    end)
    if ok and type(heartbeatResult) == "table" then
      failures = 0
      lastSuccess = os.clock()
      local command = heartbeatResult.command
      if type(command) == "table" and command.type == "kick" then
        stopped = true
        preservingKickMessage = true
        state.reason = "owner_kick"
        releaseRuntimeGuard()
        local message = type(command.message) == "string" and command.message or "Removed by a SIFF administrator."
        local kicked = pcall(function()
          local player = Players.LocalPlayer
          if player then player:Kick(message) end
        end)
        if not kicked then
          preservingKickMessage = false
          state.authorized = false
        else
          task.delay(12, function()
            preservingKickMessage = false
            state.authorized = false
          end)
        end
        return
      end
    elseif ok and (heartbeatStatus == 401 or heartbeatStatus == 403) then
      terminalKickIssued = true
      preservingKickMessage = true
      stopped = true
      state.authorized = false
      state.reason = "authorization_revoked"
      releaseRuntimeGuard()
      local callback = rawget(getgenv(), "siff_on_revoked")
      if type(callback) == "function" then pcall(callback, state.reason) end
      pcall(function()
        local player = Players.LocalPlayer
        if player then player:Kick("SIFF: This authorization session is no longer active. Please rejoin and execute the script again.") end
      end)
    else
      failures += 1
      if os.clock() - lastSuccess > HEARTBEAT_GRACE then
        stopForHeartbeatLoss()
      end
    end
  end
end)

local mainPayload, mainManifest = adaptivePayload("main")
local mainExecutable, mainCompileError = loadstring(mainPayload)
mainPayload = nil
assert(type(mainExecutable) == "function", "Main loader could not compile: " .. tostring(mainCompileError))
local mainExecuted, mainResult = pcall(mainExecutable, runtimeCapability)
if not mainExecuted then error("Main loader failed: " .. tostring(mainResult)) end
completeStage(mainManifest)
mainManifest = nil
if mainResult == false then
  releaseRuntimeGuard()
  return nil
end

local libraryPayload, libraryManifest = adaptivePayload("library")
local libraryExecutable, libraryCompileError = loadstring(libraryPayload)
libraryPayload = nil
assert(type(libraryExecutable) == "function", "UI library could not compile: " .. tostring(libraryCompileError))
local libraryExecuted, libraryResult = pcall(libraryExecutable, runtimeCapability)
if not libraryExecuted then error("UI library failed: " .. tostring(libraryResult)) end
completeStage(libraryManifest)
libraryManifest = nil

local gamePayload, gameManifest = adaptivePayload("game", game.GameId)
local gameExecutable, gameCompileError = loadstring(gamePayload)
gamePayload = nil
assert(type(gameExecutable) == "function", "Game payload could not compile: " .. tostring(gameCompileError))
local gameExecuted, gameResult = pcall(gameExecutable, runtimeCapability, libraryResult)
libraryResult = nil
if not gameExecuted then error("Game payload failed: " .. tostring(gameResult)) end
completeStage(gameManifest)
gameManifest = nil
if type(runtimeGuard) == "table" then
  runtimeGuard.starting = false
  runtimeGuard.active = true
end
return gameResult
