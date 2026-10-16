-- FynessedHub Universal Loader 1.0.18
local Manifest = {["version"]="1.0.18",["discord"]="https://discord.gg/DQc74htBED",["games"]={{["name"]="GAG2",["place"]="97598239454123",["universe"]="10200395747",["script"]="c01359efd839426aa59112edf4ff763c"},{["name"]="GAG2 · Fall Valley",["place"]="126987765280963",["universe"]="10200395747",["script"]="c01359efd839426aa59112edf4ff763c"},{["name"]="GAG2 · Fall Valley",["place"]="129343810645058",["universe"]="10200395747",["script"]="c01359efd839426aa59112edf4ff763c"},{["name"]="GAG2 · Ghoul Garden",["place"]="102868797705537",["universe"]="10200395747",["script"]="c01359efd839426aa59112edf4ff763c"},{["name"]="Clean All the Leaves!",["place"]="100068273119174",["universe"]="10539411000",["script"]="076c8e0e0b14e0839df9f3a3e7be0f12"},{["name"]="Greedy Growers",["place"]="74102906764176",["universe"]="10440833423",["script"]="013189b1cbef160c13b6c3dd5d4413be"},{["name"]="Jump for Animals",["place"]="126870639873289",["universe"]="10690360998",["script"]="156012fa5f6eaf2d0688d533e0fb8360"},{["name"]="Karinderya",["place"]="116497287371701",["universe"]="10648820673",["script"]="cf1c7966216a00bd769a761f3ba42030"},{["name"]="GAG1",["place"]="126884695634066",["universe"]="7436755782",["script"]="10edd31ce5e603f68c48f09c13e8f7cf"},{["name"]="GAG1 · New-player Garden",["place"]="124977557560410",["universe"]="7436755782",["script"]="10edd31ce5e603f68c48f09c13e8f7cf"},{["name"]="Anime Dice",["place"]="113290951185459",["universe"]="10708913337",["script"]="af2dbbef9803f73fad185ba9c3b50b90"},{["name"]="Anime Card Farm",["place"]="125039473548047",["universe"]="10144587520",["script"]="47067a4b50ba6fce2a2dc3c8a0dab173"},{["name"]="Pull an Egg",["place"]="70640255604878",["universe"]="10649255304",["script"]="61dcfad484235b5fa94dde814a65b432"},{["name"]="Lift a Cube",["place"]="109530157755211",["universe"]="10759860151",["script"]="75e22e433fc0fdc6563a3c882804edec"},{["name"]="Steal and Hatch Anime Eggs",["place"]="76377501906469",["universe"]="10747748563",["script"]="9ad15682348e53b38db9881289235008"},{["name"]="Ride a Pet",["place"]="124216119978534",["universe"]="10035204815",["script"]="2cbe766b05b66a0e807559ee88e6deb4"},{["name"]="Capybara vs Plants",["place"]="104973076655377",["universe"]="8841437826",["message"]="Discontinued â€” unavailable."},{["name"]="Clean All the Leaves! Â· Lobby",["place"]="92637789841354",["universe"]="10539411000",["message"]="Enter a round, then run this loader in the gameplay server."},{["name"]="GAG1 Â· Market",["place"]="129954712878723",["universe"]="7436755782",["message"]="The market is not supported. Run this loader in the garden."},{["name"]="Steal an Egg",["place"]="107778070777162",["universe"]="10563114921",["script"]="06a9d6ac8df570e887be2190508e85f4"},{["name"]="Slayers 2",["place"]="136406881576517",["universe"]="5595353122",["script"]="301b306cf795257cab0c6d11c5eb5b20"},{["name"]="Slayers 2 · Ouwigahara",["place"]="75556147183481",["universe"]="5595353122",["script"]="301b306cf795257cab0c6d11c5eb5b20"},{["name"]="Slayers 2 · Menu",["place"]="16205713724",["universe"]="5595353122",["message"]="Join a Slayers 2 gameplay server, then run this loader again."},{["name"]="+1 Loot to Forge",["place"]="118805555015549",["universe"]="10684750879",["script"]="0d38ed10615c876a3b5edd5b84ad633c"},{["name"]="Pet Universe",["place"]="74629631798007",["universe"]="10759638075",["script"]="4ee6f0fb62414f830be622e41bd98a35"},{["name"]="Bahay Kubo",["place"]="81403703556465",["universe"]="10766420770",["script"]="5f894435ff465f09525b998a9a8e7b5f"}}}
local Core = (function()
-- Pure controller. All I/O is injected; tests never contact Luarmor or execute game scripts.
local Core = {}
Core.keyFile = "FynessedHub-Universal-Key.txt"
function Core.route(manifest, place, universe)
    for _, route in ipairs(manifest.games) do
        if tostring(place) == route.place and tostring(universe) == route.universe then return route end
    end
    return {name = "Unsupported game", message = "This place is not supported by the universal loader."}
end
function Core.claim(env, place, job, route)
    local id = tostring(place) .. ":" .. tostring(job)
    env.FynessedHubUniversal = env.FynessedHubUniversal or {}
    local previous = env.FynessedHubUniversal[id]
    -- Reuse a live key window, but each explicit bootstrap after handoff may run again.
    -- Accept terminal/executing guards from older loader versions in the same server.
    if previous and previous.state == "open" then
        if previous.ui and previous.ui.alive and previous.ui.state == "unsupported"
            and ((route and route.script) or type(previous.ui.countdown) ~= "function") then
            -- Replace legacy permanent notices too, without resetting a live countdown.
            previous.ui:destroy()
            previous.state = "replaced"
        else
            return nil, previous
        end
    end
    local guard = {state = "open"}
    env.FynessedHubUniversal[id] = guard
    return guard
end
local errors = {
    KEY_EXPIRED = "This key has expired. Contact support to renew it.",
    KEY_BANNED = "This key is banned. Contact support for help.",
    KEY_HWID_LOCKED = "This key is linked to another device. Use Reset HWID in Discord or contact support.",
    KEY_INCORRECT = "This key is not valid for the detected game. Check your key and game access.",
    KEY_INVALID = "This key is not valid for the detected game. Check your key and game access.",
    SCRIPT_ID_INCORRECT = "Game validation is unavailable. Contact support.",
    SCRIPT_ID_INVALID = "Game validation is misconfigured (SCRIPT_ID_INVALID). Contact support.",
    INVALID_EXECUTOR = "This executor cannot validate the key. Try a supported executor.",
    SECURITY_ERROR = "Luarmor could not verify this request (SECURITY_ERROR). Retry; if it persists, contact support.",
    TIME_ERROR = "Luarmor rejected the request timing (TIME_ERROR). Check your device clock and retry.",
    UNKNOWN_ERROR = "Luarmor's validation service could not complete the request (UNKNOWN_ERROR). Your key is kept here; try again later.",
}
function Core.new(route, io, guard)
    local self = {route = route, io = io, guard = guard, draft = "", busy = false, autoPending = false}
    function self:report(message, kind) io.status(message, kind or "info") end
    function self:changeKey()
        if self.busy or guard.state ~= "open" then return false end
        self.autoPending = false
        io.present("input")
        self:report("Enter your key, then choose Load Script.")
        return true
    end
    function self:readSaved()
        local ok, value = pcall(io.read, Core.keyFile)
        if ok and type(value) == "string" and #value <= 512 then return value:match("^%s*(.-)%s*$") end
        return ""
    end
    function self:clear()
        if self.busy or guard.state ~= "open" then return false end
        local ok, cleared = pcall(io.clear, Core.keyFile)
        if ok and cleared then
            self.autoPending = false
            self.draft = ""
            io.present("input")
            io.draft("")
            self:report("Saved key cleared. Paste a key when you are ready.")
            return true
        end
        self:report("Could not clear local storage. Your input was kept; check executor file access.", "error")
        return false
    end
    function self:submit(value)
        if self.busy or guard.state ~= "open" then return false end
        if not route.script then io.present("unsupported"); self:report(route.message, "error"); return false end
        self.draft = tostring(value or ""):match("^%s*(.-)%s*$")
        -- SDK uses URL query parameters. Only an unambiguous Luarmor key is accepted.
        if #self.draft == 0 or #self.draft > 512 or not self.draft:match("^[%w_-]+$") then
            io.present("error")
            self:report("Paste your complete key without spaces or punctuation.", "error"); return false
        end
        local key = self.draft
        self.autoPending = false
        self.busy = true
        io.present("checking")
        io.busy(true)
        local function fail(message)
            self.busy = false
            io.present("error")
            io.busy(false)
            self:report(message, "error")
            return false
        end
        self:report("Checking key for " .. route.name .. "…")
        local ok, result = pcall(io.check, route.script, key)
        if not ok or type(result) ~= "table" or type(result.code) ~= "string" then
            return fail("Could not reach key validation. Your key is kept here; try again.")
        end
        if result.code ~= "KEY_VALID" then
            return fail(errors[result.code] or "Key validation could not finish. Retry or contact support.")
        end
        local saved, stored = pcall(io.save, Core.keyFile, key)
        if not saved or not stored then
            self:report("Key valid. Could not remember it on this executor; continuing for this session.", "warning")
            io.pause(2)
        end
        io.present("preparing")
        self:report("Key valid. Preparing " .. route.name .. "…")
        local downloaded, source = pcall(io.download, "https://api.luarmor.net/files/v4/loaders/" .. route.script .. ".lua")
        if not downloaded or type(source) ~= "string" or #source == 0 then
            return fail("Script download failed. Your key is kept here; try again.")
        end
        local compiled, run = pcall(io.compile, source)
        if not compiled or type(run) ~= "function" then
            return fail("Script preparation failed. Try again or use a supported executor.")
        end
        io.present("starting")
        if saved and stored then
            self:report("Key saved. Starting " .. route.name .. "…", "success")
            io.pause(0.5)
        else
            self:report("Starting " .. route.name .. "…")
        end
        -- This controller submits once. A new explicit bootstrap can claim a fresh guard after handoff.
        guard.state = "executing"
        local executed = pcall(function() io.handoff(key); run() end)
        guard.state = executed and "launched" or "uncertain"
        if not executed then io.notify("The protected script stopped after starting. Run the universal loader again to retry.") end
        return executed
    end
    function self:start()
        if not route.script then
            io.present("unsupported")
            self:report(route.message, "error")
            for remaining = 5, 0, -1 do
                if guard.state ~= "open" then return end
                io.countdown(remaining)
                -- Yield one frame at zero so it is visible before dismissal.
                io.pause(remaining > 0 and 1 or 0)
            end
            if guard.state == "open" then
                guard.state = "closed"
                io.dismiss()
            end
            return
        end
        local key = self:readSaved()
        if key ~= "" then
            self.autoPending = true
            io.present("preview")
            self.draft = key
            io.draft(key)
            self:report("Saved key found. Checking access for " .. route.name .. "…")
            io.pause(0.7)
            -- Clearing during the preview cancels automatic submission.
            if self.autoPending and self.draft == key then self:submit(key) end
        else
            io.present("input")
            self:report("Paste your key, then choose Load Script. Your valid key will be remembered when file access is available.")
        end
    end
    return self
end
return Core

end)()
local BrandAsset = (function()
local HttpService = game:GetService("HttpService")

local BrandAsset = {}

local CACHE_FOLDER = "fynessedhub"
local CACHE_FILE = CACHE_FOLDER .. "/fynessed_hub_logo_256_crisp.png"
local LEGACY_CACHE_FILE = "fynessed_hub_logo_256_crisp.png"
local LOGO_BASE64 = "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"
local cachedDefault
local attemptedDefault = false

local function assetLoader()
    if type(getcustomasset) == "function" then return getcustomasset end
    if type(getsynasset) == "function" then return getsynasset end
    return nil
end

local function fileExists(path)
    if type(isfile) ~= "function" then return false end
    local ok, value = pcall(isfile, path)
    return ok and value == true
end

local function decodeLogo()
    local ok, decoded = pcall(function() return HttpService:Base64Decode(LOGO_BASE64) end)
    if ok and type(decoded) == "string" and decoded ~= "" then return decoded end

    local decoders = {}
    if type(crypt) == "table" and type(crypt.base64) == "table" and type(crypt.base64.decode) == "function" then
        table.insert(decoders, crypt.base64.decode)
    end
    if type(syn) == "table"
        and type(syn.crypt) == "table"
        and type(syn.crypt.base64) == "table"
        and type(syn.crypt.base64.decode) == "function"
    then
        table.insert(decoders, syn.crypt.base64.decode)
    end
    if type(base64_decode) == "function" then table.insert(decoders, base64_decode) end

    for _, decoder in ipairs(decoders) do
        local decodeOk, value = pcall(decoder, LOGO_BASE64)
        if decodeOk and type(value) == "string" and value ~= "" then return value end
    end
    return nil
end

local function ensureDefaultFile()
    if fileExists(CACHE_FILE) then return CACHE_FILE end
    if fileExists(LEGACY_CACHE_FILE) then return LEGACY_CACHE_FILE end
    if type(writefile) ~= "function" then return false end
    if type(makefolder) == "function" then pcall(makefolder, CACHE_FOLDER) end
    local decoded = decodeLogo()
    if not decoded then return false end
    local writeOk = pcall(writefile, CACHE_FILE, decoded)
    if writeOk then return CACHE_FILE end
    writeOk = pcall(writefile, LEGACY_CACHE_FILE, decoded)
    return writeOk and LEGACY_CACHE_FILE or false
end

function BrandAsset.Resolve(configured)
    if type(configured) == "string" and configured ~= "" then return configured end
    if configured == false then return nil end
    if attemptedDefault then return cachedDefault end
    attemptedDefault = true
    local loader = assetLoader()
    if not loader then return nil end
    local path = ensureDefaultFile()
    if not path then return nil end
    local ok, asset = pcall(loader, path)
    if ok and type(asset) == "string" and asset ~= "" then cachedDefault = asset end
    return cachedDefault
end


return BrandAsset

end)()
local UI = (function()
-- Self-contained FynessedHub bootstrap: a compact loading view and recoverable key form.
local UI = {}
function UI.create(route, version, parent)
    local input = game:GetService("UserInputService")
    local tweenService = game:GetService("TweenService")
    local colors = {bg=Color3.fromRGB(17,22,29), panel=Color3.fromRGB(27,34,44), line=Color3.fromRGB(57,70,85),
        text=Color3.fromRGB(239,244,250), muted=Color3.fromRGB(177,192,211), accent=Color3.fromRGB(122,207,184),
        error=Color3.fromRGB(255,168,167), warning=Color3.fromRGB(243,212,144), success=Color3.fromRGB(122,207,184)}
    local connections, animations = {}, {}
    local function connect(signal, fn) local c=signal:Connect(fn); table.insert(connections,c); return c end
    local function make(class, props, target)
        local obj=Instance.new(class)
        for k,v in pairs(props) do obj[k]=v end
        obj.Parent=target
        return obj
    end
    local function round(target, radius) make("UICorner",{CornerRadius=UDim.new(0,radius)},target) end
    local function stop(name) if animations[name] then animations[name]:Cancel(); animations[name]=nil end end
    local function animate(name, object, properties, info)
        stop(name)
        local tween=tweenService:Create(object,info or TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),properties)
        animations[name]=tween; tween:Play()
    end
    local screen=make("ScreenGui",{Name="FynessedHubUniversal",ResetOnSpawn=false,IgnoreGuiInset=false,DisplayOrder=10000,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},parent)
    local frame=make("CanvasGroup",{Name="KeyWindow",Size=UDim2.fromOffset(400,280),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=colors.bg,BorderSizePixel=0,Active=true,GroupTransparency=0.25},screen)
    round(frame,14); make("UIStroke",{Color=colors.line,Thickness=1},frame)
    local function label(target,name,text,x,y,w,h,size,color)
        return make("TextLabel",{Name=name,Text=text,Position=UDim2.fromOffset(x,y),Size=UDim2.new(1,w,0,h),BackgroundTransparency=1,
            TextColor3=color or colors.text,Font=Enum.Font.Gotham,TextSize=size,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},target)
    end
    local handle=make("Frame",{Name="DragHandle",Size=UDim2.new(1,0,0,96),BackgroundTransparency=1,Active=true},frame)
    local logoHost=make("Frame",{Name="Logo",Position=UDim2.fromOffset(24,24),Size=UDim2.fromOffset(44,44),BackgroundTransparency=1},handle)
    local logoFallback=make("TextLabel",{Name="LogoFallback",Text="FH",Font=Enum.Font.GothamBold,TextSize=20,TextColor3=colors.text,BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},logoHost)
    round(logoFallback,22); make("UIStroke",{Color=colors.text,Thickness=2,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},logoFallback)
    label(handle,"Brand","FynessedHub",84,23,-108,27,21).Font=Enum.Font.GothamBold
    label(handle,"Game",route.name,84,52,-108,24,14,colors.muted)
    make("Frame",{Name="Divider",Position=UDim2.fromOffset(24,94),Size=UDim2.new(1,-48,0,1),BackgroundColor3=colors.line,BorderSizePixel=0},frame)
    local body=make("ScrollingFrame",{Name="Body",Position=UDim2.fromOffset(0,96),Size=UDim2.new(1,0,1,-96),BackgroundTransparency=1,BorderSizePixel=0,
        CanvasSize=UDim2.new(0,0,0,184),ScrollBarThickness=3,ScrollBarImageColor3=colors.line,ScrollingDirection=Enum.ScrollingDirection.Y,ClipsDescendants=true},frame)
    local function group(name,height)
        return make("CanvasGroup",{Name=name,Size=UDim2.new(1,0,0,height),BackgroundTransparency=1,Visible=false,GroupTransparency=0},body)
    end
    local form=group("KeyForm",294)
    label(form,"KeyCaption","Your key",24,16,-48,20,13,colors.muted)
    local box=make("TextBox",{Name="KeyInput",Position=UDim2.fromOffset(24,42),Size=UDim2.new(1,-48,0,44),BackgroundColor3=colors.panel,BorderSizePixel=0,
        Text="",PlaceholderText="Paste your key here",PlaceholderColor3=colors.muted,TextColor3=colors.text,Font=Enum.Font.Code,TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,MultiLine=false,TextEditable=false},form)
    round(box,8); local focusLine=make("UIStroke",{Color=colors.line,Thickness=1},box)
    make("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12)},box)
    local formStatus=label(form,"FormStatus","",24,100,-48,68,13,colors.muted)
    formStatus.TextYAlignment=Enum.TextYAlignment.Top
    local function button(target,name,text,y,width,x,primary)
        local b=make("TextButton",{Name=name,Text=text,Position=UDim2.new(x,x>0 and 5 or 24,0,y),Size=UDim2.new(width,width==1 and -48 or -29,0,44),BackgroundColor3=primary and colors.accent or colors.panel,
            BorderSizePixel=0,Font=Enum.Font.GothamMedium,TextSize=14,TextColor3=primary and colors.bg or colors.text,AutoButtonColor=true,Selectable=true},target)
        round(b,8); return b
    end
    local load=button(form,"Load","Load Script",178,1,0,true)
    local clear=button(form,"Clear","Clear Saved Key",232,0.5,0,false)
    local join=button(form,"Join","Join Discord",232,0.5,0.5,false)
    local loading=group("LoadingView",184)
    local loadingStatus=label(loading,"LoadingStatus","Detecting game…",24,20,-48,68,14,colors.muted)
    loadingStatus.TextXAlignment=Enum.TextXAlignment.Center
    local indicator=make("Frame",{Name="Activity",Position=UDim2.new(0.5,-24,0,103),Size=UDim2.fromOffset(48,8),BackgroundTransparency=1},loading)
    local dots={}
    for i=1,3 do
        dots[i]=make("Frame",{Name="Dot"..i,Position=UDim2.fromOffset((i-1)*20,0),Size=UDim2.fromOffset(8,8),BackgroundColor3=colors.accent,BackgroundTransparency=0.55,BorderSizePixel=0},indicator)
        round(dots[i],4)
    end
    local change=button(loading,"Change","Change key",124,1,0,false)
    local loadingJoin=button(loading,"Support","Join Discord",124,1,0,false)
    local countdown=label(loading,"DismissCountdown","",24,92,-48,24,13,colors.muted)
    countdown.TextXAlignment=Enum.TextXAlignment.Center
    countdown.Visible=false
    loading.Visible=true; change.Visible=false; loadingJoin.Visible=false; indicator.Visible=false
    local api={screen=screen,frame=frame,box=box,load=load,clear=clear,join=join,change=change,form=form,loading=loading,
        indicator=indicator,connections=connections,animations=animations,alive=true,state="initial",isBusy=false}
    local offset=Vector2.new(0,0)
    local width,height=400,280
    local desiredHeight=280
    local function resize(animated)
        local viewport=screen.AbsoluteSize
        width=math.min(400,math.max(240,viewport.X-24)); height=math.min(desiredHeight,math.max(200,viewport.Y-24))
        offset=Vector2.new(math.clamp(offset.X,-math.max(0,(viewport.X-width)/2-12),math.max(0,(viewport.X-width)/2-12)),
            math.clamp(offset.Y,-math.max(0,(viewport.Y-height)/2-12),math.max(0,(viewport.Y-height)/2-12)))
        stop("size")
        if animated then animate("size",frame,{Size=UDim2.fromOffset(width,height)}) else frame.Size=UDim2.fromOffset(width,height) end
        stop("entrance-position"); frame.Position=UDim2.new(0.5,offset.X,0.5,offset.Y)
    end
    local function motion(on)
        indicator.Visible=on
        for i,dot in ipairs(dots) do
            stop("dot"..i); dot.BackgroundTransparency=0.55
            if on then animate("dot"..i,dot,{BackgroundTransparency=0.05},TweenInfo.new(0.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true,(i-1)*0.12)) end
        end
    end
    function api:present(state)
        if not self.alive then return end
        local wasForm=form.Visible
        self.state=state
        local isForm=state=="input" or state=="error"
        form.Visible=isForm; loading.Visible=not isForm
        change.Visible=state=="preview"; loadingJoin.Visible=state=="unsupported"
        countdown.Visible=state=="unsupported"
        local active=state=="preview" or state=="checking" or state=="preparing" or state=="starting"
        motion(active)
        desiredHeight=isForm and 390 or 280
        body.CanvasSize=UDim2.new(0,0,0,isForm and 294 or 184)
        if wasForm~=isForm then
            body.CanvasPosition=Vector2.new(0,0)
            stop("content"); local target=isForm and form or loading
            target.GroupTransparency=0.2; animate("content",target,{GroupTransparency=0})
            resize(true)
        end
        self:busy(self.isBusy)
    end
    function api:status(text,kind)
        if self.alive then
            formStatus.Text=text; loadingStatus.Text=text
            formStatus.TextColor3=colors[kind] or colors.muted; loadingStatus.TextColor3=colors[kind] or colors.muted
        end
    end
    function api:countdown(seconds)
        if self.alive and self.state=="unsupported" then
            countdown.Text="Closing in "..tostring(seconds).."s"
        end
    end
    function api:busy(value)
        if not self.alive then return end
        self.isBusy=value
        local enabled=not value and route.script~=nil and form.Visible
        load.Active=enabled; load.Selectable=enabled; load.AutoButtonColor=enabled
        clear.Active=enabled; clear.Selectable=enabled; box.TextEditable=enabled
        load.BackgroundColor3=enabled and colors.accent or colors.line
        change.Active=self.state=="preview" and not value; change.Selectable=change.Active
    end
    local dragging,origin,start
    connect(handle.InputBegan,function(event)
        if event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch then dragging=event; origin=event.Position; start=offset end
    end)
    connect(input.InputChanged,function(event)
        if dragging and (event==dragging or (dragging.UserInputType==Enum.UserInputType.MouseButton1 and event.UserInputType==Enum.UserInputType.MouseMovement)) then
            local delta=event.Position-origin; offset=start+Vector2.new(delta.X,delta.Y); resize(false)
        end
    end)
    connect(input.InputEnded,function(event) if event==dragging then dragging=nil end end)
    connect(screen:GetPropertyChangedSignal("AbsoluteSize"),function() resize(false) end)
    connect(box.Focused,function() animate("focus",focusLine,{Color=colors.accent}) end)
    connect(box.FocusLost,function() animate("focus",focusLine,{Color=colors.line}) end)
    local function openDiscord(invite)
        local opened=pcall(function() game:GetService("BrowserService"):OpenBrowserWindow(invite) end)
        if opened then api:status("Discord invite opened in your browser."); return end
        if type(setclipboard)=="function" and pcall(setclipboard,invite) then api:status("Discord invite copied. Open it in your browser."); return end
        api:status(invite .. " — open this invite in your browser.")
    end
    function api:bind(controller,invite)
        connect(load.Activated,function() if load.Active then task.spawn(function() controller:submit(box.Text) end) end end)
        connect(box.FocusLost,function(enter) if enter and box.TextEditable then task.spawn(function() controller:submit(box.Text) end) end end)
        connect(box:GetPropertyChangedSignal("Text"),function() if not controller.busy then controller.draft=box.Text end end)
        connect(clear.Activated,function() if clear.Active then controller:clear() end end)
        connect(change.Activated,function() if change.Active then controller:changeKey() end end)
        connect(join.Activated,function() openDiscord(invite) end)
        connect(loadingJoin.Activated,function() openDiscord(invite) end)
        self:busy(false)
    end
    function api:destroy()
        if not self.alive then return end
        self.alive=false
        for name in pairs(animations) do stop(name) end
        for _,c in ipairs(connections) do c:Disconnect() end
        screen:Destroy()
    end
    resize(false)
    frame.Position=UDim2.new(0.5,offset.X,0.5,offset.Y+10)
    animate("entrance-position",frame,{Position=UDim2.new(0.5,offset.X,0.5,offset.Y)})
    animate("entrance-fade",frame,{GroupTransparency=0})
    -- Asset resolution must not gate key validation or the first frame.
    task.spawn(function()
        local ok,asset=pcall(BrandAsset.Resolve)
        if ok and asset and api.alive then
            -- Local executor assets do not need a second readiness gate. Select the
            -- image exclusively once resolution succeeds; fallback is for missing APIs
            -- or failed resolution, so transparent pixels cannot reveal another badge.
            local image=make("ImageLabel",{Name="FynessedHubLogo",Image=asset,Visible=false,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
                ScaleType=Enum.ScaleType.Fit,ResampleMode=Enum.ResamplerMode.Default},logoHost)
            logoFallback:Destroy()
            image.Visible=true
        end
    end)
    return api
end
return UI

end)()
local env = (type(getgenv)=="function" and getgenv()) or _G
local function notify(text)
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="FynessedHub",Text=text,Duration=12}) end)
end
local route=Core.route(Manifest,game.PlaceId,game.GameId)
local guard, previous = Core.claim(env, game.PlaceId, game.JobId, route)
if not guard then
    if previous.ui and previous.ui.alive then previous.ui.screen.Enabled=true end
    if previous.ui and previous.ui.state=="unsupported" then return end
    notify("The key window is already open or checking your key.")
    return
end
local okParent,parent=pcall(function() return type(gethui)=="function" and gethui() or game:GetService("CoreGui") end)
if not okParent then parent=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
local made,ui=pcall(UI.create,route,Manifest.version,parent)
if not made then
    local okFallback, fallback=pcall(UI.create,route,Manifest.version,game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
    if not okFallback then
        env.FynessedHubUniversal[tostring(game.PlaceId)..":"..tostring(game.JobId)]=nil
        notify("The key window could not open. Try a supported executor."); return
    end
    ui=fallback
end
guard.ui=ui
local function fetch(url) return game:HttpGet(url) end
local function bounded(fn)
    local done,ok,value=false,false,nil
    task.spawn(function() ok,value=pcall(fn); done=true end)
    local deadline=os.clock()+30
    while not done and os.clock()<deadline do task.wait(0.1) end
    if not done or not ok then error("Request unavailable",0) end
    return value
end
local controller=Core.new(route,{
    status=function(text,kind) ui:status(text,kind) end,
    present=function(state) ui:present(state) end,
    busy=function(value) ui:busy(value) end,
    draft=function(value) ui.box.Text=value end,
    pause=function(seconds) task.wait(seconds) end,
    countdown=function(seconds) ui:countdown(seconds) end,
    dismiss=function() ui:destroy(); guard.ui=nil end,
    notify=notify,
    read=function(file)
        if type(readfile)~="function" then return "" end
        return readfile(file)
    end,
    save=function(file,key)
        if type(writefile)~="function" or type(readfile)~="function" then return false end
        writefile(file,key)
        return readfile(file)==key
    end,
    clear=function(file)
        if type(isfile)=="function" and not isfile(file) then return true end
        if type(delfile)=="function" then
            delfile(file)
            if type(isfile)=="function" then return not isfile(file) end
            if type(readfile)=="function" then local exists=pcall(readfile,file); return not exists end
            return true
        end
        if type(writefile)=="function" and type(readfile)=="function" then writefile(file,""); return readfile(file)=="" end
        return false
    end,
    check=function(scriptId,key)
        return bounded(function()
            local source=fetch("https://sdkapi-public.luarmor.net/library.lua")
            local factory=assert(loadstring(source))
            local sdk=factory()
            sdk.script_id=scriptId
            return sdk.check_key(key)
        end)
    end,
    download=function(url) return bounded(function() return fetch(url) end) end,
    compile=function(source) return loadstring(source) end,
    handoff=function(key)
        env.script_key=key
        getfenv().script_key=key
        ui:destroy()
        guard.ui=nil
    end,
},guard)
ui:bind(controller,Manifest.discord)
task.spawn(function() controller:start() end)
