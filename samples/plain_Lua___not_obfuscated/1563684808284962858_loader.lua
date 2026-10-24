-- Fixed loader; the server selects the latest approved payload after license verification.
do
local checksum = (function()
-- SHA-256 checksum only; authentication remains HTTPS and server-side license validation.
local function sha256(message: string): string
    local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
    local ror, shr = bit32.rrotate, bit32.rshift
    local constants = {
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,
    }
    local state = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
    local length = #message
    local bits = length * 8
    local suffix = ""
    for shift = 7, 0, -1 do suffix ..= string.char(math.floor(bits / 256 ^ shift) % 256) end
    local input = message .. "\128" .. string.rep("\0", (55 - length) % 64) .. suffix
    local words = table.create(64, 0)
    local function add(...: number): number
        local sum = 0
        for index = 1, select("#", ...) do sum += select(index, ...) end
        return sum % 4294967296
    end
    for offset = 1, #input, 64 do
        for index = 0, 15 do
            local a,b,c,d = string.byte(input, offset + index * 4, offset + index * 4 + 3)
            words[index + 1] = ((a * 256 + b) * 256 + c) * 256 + d
        end
        for index = 17, 64 do
            local x, y = words[index - 15], words[index - 2]
            words[index] = add(words[index - 16], bxor(ror(x,7),ror(x,18),shr(x,3)), words[index - 7], bxor(ror(y,17),ror(y,19),shr(y,10)))
        end
        local a,b,c,d,e,f,g,h = table.unpack(state)
        for index = 1, 64 do
            local first = add(h, bxor(ror(e,6),ror(e,11),ror(e,25)), bxor(band(e,f),band(bnot(e),g)), constants[index], words[index])
            local second = add(bxor(ror(a,2),ror(a,13),ror(a,22)), bxor(band(a,b),band(a,c),band(b,c)))
            h,g,f,e,d,c,b,a = g,f,e,add(d,first),c,b,a,add(first,second)
        end
        for index, value in {a,b,c,d,e,f,g,h} do state[index] = add(state[index],value) end
    end
    local result = ""
    for _, value in state do result ..= string.format("%08x", value) end
    return result
end
return sha256
end)()
local loader = (function()
-- Fixed-origin loader. Product payload is never cached on disk or executed before verification.
local function createNoirbyteLoader(options: any): boolean
    local realTask, realCoroutine = task, coroutine
    local env = options.env
    local player = game:GetService("Players").LocalPlayer
    local HttpService = game:GetService("HttpService")
    if not player then return false end
    local runtime = env._NOIRBYTE_LICENSE_RUNTIME_V1
    if type(runtime) == "table" and runtime.jobId == game.JobId and type(runtime.isActive) == "function" and runtime.isActive() then return false end
    local slot = "_NOIRBYTE_LOADER_V1"
    local previous = env[slot]
    if type(previous) == "table" and previous.jobId == game.JobId and previous.running then return false end
    local owner = {jobId = game.JobId, running = true}
    env[slot] = owner
    local words = {
        en = {title="NOIRBYTE", key="License key", activate="Activate", close="Close", ready="Enter your key", connecting="Connecting…", invalid="Check your key", locked="Key temporarily locked", offline="Connection interrupted. Please retry.", update="Update unavailable. Please retry.", expired="Your NoirByte key has expired. Renew your key to continue."},
        vi = {title="NOIRBYTE", key="Key bản quyền", activate="Kích hoạt", close="Đóng", ready="Nhập key của bạn", connecting="Đang kết nối…", invalid="Kiểm tra lại key", locked="Key tạm khóa", offline="Kết nối gián đoạn. Vui lòng thử lại.", update="Bản cập nhật chưa sẵn sàng. Vui lòng thử lại.", expired="Key NoirByte đã hết hạn. Vui lòng gia hạn để tiếp tục."},
        zh = {title="NOIRBYTE", key="许可证密钥", activate="激活", close="关闭", ready="请输入密钥", connecting="正在连接…", invalid="请检查密钥", locked="密钥暂时锁定", offline="连接中断，请重试。", update="更新暂不可用，请重试。", expired="您的 NoirByte 密钥已过期。请续期后继续使用。"},
    }
    local language = if words[env.NoirByteLanguage or ""] then env.NoirByteLanguage else "en"
    local function text(name: string): string return words[language][name] or words.en[name] end
    local stopped, busy = false, false
    local networkThread: thread? = nil
    local connections = {}
    local screen: ScreenGui? = nil
    local box: TextBox? = nil
    local action: TextButton? = nil
    local status: TextLabel? = nil
    local close: TextButton? = nil
    local statusName = "ready"
    local generation = 0
    local requestKey: string? = nil
    local function normalize(raw: any): string?
        if type(raw) ~= "string" then return nil end
        local key = string.upper(raw:match("^%s*(.-)%s*$") or "")
        return if #key == 67 and key:match("^NB%-%x+$") then key else nil
    end
    requestKey = normalize(env.NoirByteKey)
    local function redraw()
        if box then box.PlaceholderText = text("key") end
        if action then action.Text = text("activate") end
        if close then close.Text = text("close") end
        if status then status.Text = text(statusName) end
    end
    local function cleanup(keepOwnership: boolean?)
        stopped = true
        if keepOwnership ~= true then
            owner.running = false
            if env[slot] == owner then env[slot] = nil end
        end
        for _, connection in connections do connection:Disconnect() end
        table.clear(connections)
        if screen then screen:Destroy(); screen = nil end
        if networkThread and networkThread ~= realCoroutine.running() and realCoroutine.status(networkThread) ~= "dead" then pcall(realTask.cancel, networkThread) end
    end
    local function show()
        if screen then return end
        screen = Instance.new("ScreenGui"); screen.Name = "NoirByteLoader"; screen.ResetOnSpawn = false; screen.DisplayOrder = 100000
        local frame = Instance.new("Frame"); frame.AnchorPoint = Vector2.new(0.5,0.5); frame.Position = UDim2.fromScale(0.5,0.5)
        frame.Size = UDim2.fromOffset(400,260); frame.BackgroundColor3 = Color3.fromRGB(10,13,18); frame.Parent = screen
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,12); corner.Parent = frame
        local border = Instance.new("UIStroke"); border.Color = Color3.fromRGB(32,224,224); border.Thickness = 1; border.Parent = frame
        local function item(className: string, y: number, height: number): any
            local object = Instance.new(className); object.Position = UDim2.fromOffset(24,y); object.Size = UDim2.new(1,-48,0,height)
            object.BackgroundTransparency = 1; object.TextColor3 = Color3.fromRGB(225,239,243); object.Font = Enum.Font.Gotham; object.TextSize = 14; object.Parent = frame
            return object
        end
        local title = item("TextLabel",20,30); title.Text = "NOIRBYTE"; title.TextSize = 24; title.Font = Enum.Font.GothamBold; title.TextColor3 = Color3.fromRGB(32,224,224)
        box = item("TextBox",78,38); local input = box :: TextBox; input.Text = ""; input.ClearTextOnFocus = false
        input.BackgroundTransparency = 0; input.BackgroundColor3 = Color3.fromRGB(22,29,36); input.TextSize = 13
        action = item("TextButton",126,36); local button = action :: TextButton; button.BackgroundTransparency = 0; button.BackgroundColor3 = Color3.fromRGB(16,121,132)
        status = item("TextLabel",168,30); status.TextSize = 12
        local function submit()
            if stopped or statusName == "connecting" then return end
            local key = normalize(input.Text)
            if not key then statusName = "invalid"; redraw(); return end
            generation += 1; requestKey = key
        end
        table.insert(connections, button.Activated:Connect(submit))
        table.insert(connections, input.FocusLost:Connect(function(enter: boolean) if enter then submit() end end))
        table.insert(connections, input:GetPropertyChangedSignal("Text"):Connect(function()
            if stopped then return end
            generation += 1; requestKey = nil; statusName = "ready"; redraw()
        end))
        for index, entry in {{"en","EN"},{"vi","VI"},{"zh","中文"}} do
            local selectLanguage = item("TextButton",214,24); selectLanguage.Position = UDim2.fromOffset(24+(index-1)*56,214)
            selectLanguage.Size = UDim2.fromOffset(48,24); selectLanguage.Text = entry[2]
            table.insert(connections, selectLanguage.Activated:Connect(function() language = entry[1]; redraw() end))
        end
        close = item("TextButton",214,24); close.Position = UDim2.fromOffset(290,214); close.Size = UDim2.fromOffset(86,24)
        table.insert(connections, close.Activated:Connect(cleanup))
        local parent = player:WaitForChild("PlayerGui",10)
        if not parent then cleanup(); return end
        screen.Parent = parent; redraw()
    end
    local function post(path: string, body: any, deadline: number): any
        if stopped or busy then return nil end
        busy = true
        local finished, result = false, nil
        local target = realCoroutine.create(function()
            local ok, reply = pcall(options.request, {Url=options.baseUrl..path, Method="POST",
                Headers={["Content-Type"]="application/json",["Accept"]="application/json, text/plain"}, Body=HttpService:JSONEncode(body), Timeout=20})
            if ok and type(reply) == "table" then
                local code = tonumber(reply.StatusCode or reply.Status or reply.status_code)
                local raw = reply.Body or reply.body
                if code and code >= 100 and code <= 599 and code % 1 == 0 and type(raw) == "string" and #raw <= 2097152 then
                    if path == "/payload" and code >= 200 and code < 300 then result = {status=code, payload=raw}
                    elseif #raw <= 16384 then
                        local decoded, data = pcall(HttpService.JSONDecode, HttpService, raw)
                        if decoded and type(data) == "table" then result = {status=code, data=data} end
                    end
                end
            end
            finished = true; busy = false
        end)
        networkThread = target; realTask.spawn(target)
        local untilTime = math.min(deadline,os.clock()+22)
        while not finished and not stopped and os.clock() < untilTime do realTask.wait(0.1) end
        if not finished then pcall(realTask.cancel,target); return nil end -- latch busy; never overlap a hung native request
        return result
    end
    local function transient(reply: any): boolean
        return reply == nil or reply.status == 408 or reply.status == 429 or reply.status >= 500
            or (reply.data and (reply.data.code == "busy" or reply.data.code == "unavailable"))
    end
    local function pause(attempt: number, reply: any, deadline: number)
        local requested = if reply and reply.data then tonumber(reply.data.retryAfterSeconds) or 0 else 0
        local untilTime = math.min(deadline,os.clock()+math.max(math.min(10,2^math.min(attempt,4))+math.random(),math.clamp(requested,0,30)))
        while not stopped and os.clock() < untilTime do realTask.wait(0.1) end
    end
    local function attempt(key: string, version: number): (string?, string?)
        local deadline, retries = os.clock()+90, 0
        while not stopped and version == generation and os.clock() < deadline do
            local grant = post("/bootstrap",{key=key,userId=tostring(player.UserId),username=player.Name},deadline)
            if stopped or version ~= generation then return nil,"stale" end
            if transient(grant) then
                if busy then return nil,"offline" end
                retries += 1; pause(retries,grant,deadline); continue
            end
            if grant.status < 200 or grant.status >= 300 or not grant.data or grant.data.ok ~= true then
                return nil, if grant.data and grant.data.code == "license_expired" then "expired" elseif grant.data and grant.data.code == "locked" then "locked" else "invalid"
            end
            local data = grant.data
            if type(data.ticket) ~= "string" or #data.ticket ~= 43 or not data.ticket:match("^[%w_%-]+$")
                or type(data.sha256) ~= "string" or #data.sha256 ~= 64 or not data.sha256:match("^[a-f0-9]+$")
                or type(data.bytes) ~= "number" or data.bytes % 1 ~= 0 or data.bytes < 1 or data.bytes > 2097152
                or type(data.expiresInSeconds) ~= "number" or data.expiresInSeconds <= 0 or data.expiresInSeconds > 60 then return nil,"update" end
            local payload = post("/payload",{ticket=data.ticket},deadline)
            if stopped or version ~= generation then return nil,"stale" end
            if payload and payload.payload then
                local hashed, digest = pcall(options.hash,payload.payload)
                if #payload.payload ~= data.bytes or not hashed or digest ~= data.sha256 then return nil,"update" end
                return payload.payload,nil
            end
            if payload and not transient(payload) and payload.data then
                if payload.data.code == "license_expired" then return nil,"expired" end
                if payload.data.code == "locked" then return nil,"locked" end
                if payload.data.code ~= "invalid_ticket" then return nil,"invalid" end
            end
            if busy then return nil,"offline" end
            retries += 1; pause(retries,payload,deadline) -- burned/interrupted ticket is replaced, never replayed
        end
        return nil, if stopped or version ~= generation then "stale" else "offline"
    end
    show()
    while not stopped do
        if requestKey then
            local key, version = requestKey, generation; requestKey = nil; statusName = "connecting"; redraw()
            local payload, failure = attempt(key,version)
            if stopped then return false end
            if version ~= generation then continue end
            if failure == "expired" then local message = text("expired"); cleanup(); pcall(function() player:Kick(message) end); return false end
            if payload then
                local ok, chunk = pcall(options.compile,payload,"NoirByte")
                if stopped or version ~= generation then continue end
                if ok and type(chunk) == "function" then
                    env.NoirByteKey = key; env.NoirByteLanguage = language
                    cleanup(true)
                    local executed = pcall(chunk)
                    owner.running = false
                    if env[slot] == owner then env[slot] = nil end
                    if not executed then warn("NoirByte • E2") end
                    return executed
                end
                failure = "update"
            end
            statusName = if failure == "locked" then "locked" elseif failure == "invalid" then "invalid" elseif failure == "update" then "update" else "offline"
            redraw()
        else realTask.wait(0.1) end
    end
    return false
end
return createNoirbyteLoader
end)()
local environment = if type(getgenv) == "function" then getgenv() else _G
local send = request or http_request or (syn and syn.request) or (http and http.request)
if type(send) ~= "function" or type(loadstring) ~= "function" then
    warn("NoirByte • E1")
else
    local ok = pcall(loader,{baseUrl="https://radianceai.online/api/noirbyte/runtime",env=environment,request=send,hash=checksum,compile=loadstring})
    if not ok then warn("NoirByte • E1") end
end
end
