 
local HttpService=game:GetService("HttpService")
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")

local function currentEnvironment()
	local environment=type(_G)=="table" and _G or{}
	if type(getfenv)=="function" then
		local ok,value=pcall(getfenv,0)
		if ok and type(value)=="table" then
			environment=value
		end
	end
	return environment
end

local loaderEnv=currentEnvironment()
local sharedEnv=loaderEnv
if type(getgenv)=="function" then
	local ok,result=pcall(getgenv)
	if ok and type(result)=="table" then
		sharedEnv=result
	end
end
local function liveStartupOwner(name)
 local owner=rawget(sharedEnv,name)
 if type(owner)=="table" and type(owner.Thread)=="thread" then
  local ok,status=pcall(coroutine.status,owner.Thread)
  if ok and status~="dead" then return true end
 elseif type(owner)=="table" then
   
  local screen=rawget(sharedEnv,"GUI_STARTUP_UI")
  if screen and screen.Parent then return true end
 end
 sharedEnv[name]=nil
 return false
end
if liveStartupOwner("GUI_LOADER_BUSY") or liveStartupOwner("GUI_ENTRY_BUSY") then return true end
local function compile(source,name)
	if type(source)~="string" or source=="" then
		return nil,"missing source: "..tostring(name or "script")
	end
	if type(loadstring)~="function" then
		return nil,"executor does not support loadstring"
	end
	local ok,chunk,err=pcall(loadstring,source)
	if not ok or type(chunk)~="function" then
		return nil,"compile failed ("..tostring(name or "source").."): "..tostring((ok and err) or chunk or "unknown")
	end
	 
	 
	if type(setfenv)=="function" then
		pcall(setfenv,chunk,loaderEnv)
	end
	return chunk,nil
end

local previousBootConfig=rawget(sharedEnv,"GUI_BOOT_CONFIG")
local previousLoaderBootConfig=rawget(loaderEnv,"GUI_BOOT_CONFIG")
local config={}
if type(previousBootConfig)=="table" then
	for key,value in pairs(previousBootConfig) do
		config[key]=value
	end
end
config.Fresh=config.Fresh==true

 
local startupScreen,startupPanel,startupLabel,startupPercent,startupSegments,startupContent
local setStartupProgress
local openSupportInvite
local function closeStartup(animated)
	local owned=sharedEnv.GUI_STARTUP_UI==startupScreen
	local screen,panel=startupScreen,startupPanel
	startupScreen=nil
	if screen then
		if animated and panel and panel.Name=="Loading" then
			sharedEnv.GUI_STARTUP_EXITING=screen
			local position=panel.Position
			TweenService:Create(panel,TweenInfo.new(0.07,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
				Position=UDim2.new(position.X.Scale,position.X.Offset-18,position.Y.Scale,position.Y.Offset),
			}):Play()
			task.delay(0.07,function()
				if not(screen.Parent and panel.Parent) then return end
				TweenService:Create(panel,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
					Position=UDim2.new(1,panel.AbsoluteSize.X,position.Y.Scale,position.Y.Offset),
				}):Play()
				task.delay(0.21,function()
					screen:Destroy()
					if sharedEnv.GUI_STARTUP_EXITING==screen then sharedEnv.GUI_STARTUP_EXITING=nil end
				end)
			end)
		else screen:Destroy() end
	end
	if owned then
		sharedEnv.GUI_STARTUP_UI=nil
		sharedEnv.GUI_STARTUP_STATE=nil
		if sharedEnv.GUI_STARTUP_PROGRESS==setStartupProgress then sharedEnv.GUI_STARTUP_PROGRESS=nil end
	end
	if loaderEnv.GUI_STARTUP_PROGRESS==setStartupProgress then loaderEnv.GUI_STARTUP_PROGRESS=nil end
	startupPanel,startupLabel,startupPercent,startupSegments,startupContent=nil,nil,nil,nil,nil
end
local function showStartup(message,failure)
	local exiting=sharedEnv.GUI_STARTUP_EXITING
	if exiting then pcall(function() exiting:Destroy() end) sharedEnv.GUI_STARTUP_EXITING=nil end
	local name=failure and "ErrorToast" or "Loading"
	if startupScreen and startupScreen.Parent and startupPanel and startupPanel.Name==name then
		startupScreen.Enabled=true
		startupLabel.Text=message or "Loading GUI..."
		return
	end
	local prior=not failure and sharedEnv.GUI_STARTUP_STATE
	if type(prior)=="table" and prior.screen and prior.screen.Parent and prior.panel and prior.panel.Name=="Loading" then
		startupScreen,startupPanel,startupLabel,startupPercent,startupSegments,startupContent=
			prior.screen,prior.panel,prior.label,prior.percent,prior.segments,prior.content
		startupScreen.Enabled=true
		startupLabel.Text=message or "loading modules..."
		sharedEnv.GUI_STARTUP_PROGRESS=setStartupProgress
		loaderEnv.GUI_STARTUP_PROGRESS=setStartupProgress
		return
	end
	closeStartup()
	local previous=sharedEnv.GUI_STARTUP_UI
	if previous then pcall(function() previous:Destroy() end) end
	local screen=Instance.new("ScreenGui")
	screen.Name="GuiStartup"
	screen.ResetOnSpawn=false
	screen.IgnoreGuiInset=true
	screen.DisplayOrder=1000001
	local attached=pcall(function() screen.Parent=game:GetService("CoreGui") end)
	if not attached or not screen.Parent then
		local player=Players.LocalPlayer
		local parent=player and player:FindFirstChildOfClass("PlayerGui")
		if not parent then screen:Destroy() return end
		screen.Parent=parent
	end
	startupScreen=screen
	sharedEnv.GUI_STARTUP_UI=screen
	local panel=Instance.new("Frame")
	panel.Name=name
	panel.AnchorPoint=failure and Vector2.new(1,1) or Vector2.new(0.5,0.5)
	panel.Position=failure and UDim2.new(1,-18,1,-18) or UDim2.fromScale(0.5,0.5)
	panel.Size=failure and UDim2.new(0.85,0,0,74) or UDim2.fromOffset(300,220)
	panel.BackgroundColor3=failure and Color3.fromRGB(34,34,36) or Color3.new(0,0,0)
	panel.BorderSizePixel=0
	panel.ClipsDescendants=true
	panel.Parent=screen
	local content,scale
	if failure then
		local constraint=Instance.new("UISizeConstraint")
		constraint.MaxSize=Vector2.new(320,100)
		constraint.Parent=panel
		local accent=Instance.new("Frame")
		accent.Name="Accent"
		accent.Size=UDim2.new(0,3,1,0)
		accent.BackgroundColor3=Color3.fromRGB(203,135,103)
		accent.BorderSizePixel=0
		accent.Parent=panel
	else
		content=Instance.new("Frame")
		content.Name="LoaderContent"
		content.BorderSizePixel=0
		content.AnchorPoint=Vector2.new(0.5,0.5)
		content.Position=UDim2.fromScale(0.5,0.5)
		content.Size=UDim2.fromScale(1,1)
		content.BackgroundTransparency=1
		content.Parent=panel
		startupContent=content
		scale=Instance.new("UIScale")
		scale.Scale=0.94
		scale.Parent=content
		local avatar=Instance.new("ImageLabel")
		avatar.Name="Avatar"
		avatar.AnchorPoint=Vector2.new(0.5,0)
		avatar.Position=UDim2.new(0.5,0,0,12)
		avatar.Size=UDim2.new(0,82,0,82)
		avatar.BackgroundTransparency=1
		local player=Players.LocalPlayer
		avatar.Image=player and ("rbxthumb://type=AvatarHeadShot&id="..tostring(player.UserId).."&w=150&h=150") or ""
		avatar.Parent=content
		startupSegments={}
		for index=1,10 do
			local segment=Instance.new("Frame")
			segment.Name="Segment"..index
			segment.Position=UDim2.new(0,35+(index-1)*24,0,112)
			segment.Size=UDim2.new(0,14,0,32)
			segment.BackgroundColor3=Color3.fromRGB(35,35,35)
			segment.BackgroundTransparency=0.8
			segment.BorderSizePixel=0
			segment.Parent=content
			startupSegments[index]=segment
		end
		local percent=Instance.new("TextLabel")
		percent.BackgroundTransparency=1
		percent.Position=UDim2.new(0,0,0,182)
		percent.Size=UDim2.new(1,0,0,18)
		percent.Font=Enum.Font.Gotham
		percent.TextSize=11
		percent.TextColor3=Color3.fromRGB(238,238,238)
		percent.TextXAlignment=Enum.TextXAlignment.Center
		percent.Text="0%"
		percent.Parent=content
		startupPercent=percent
	end
	local label=Instance.new("TextLabel")
	label.BackgroundTransparency=1
	label.Position=failure and UDim2.fromOffset(16,10) or UDim2.new(0,0,0,158)
	label.Size=failure and UDim2.new(1,-32,1,-20) or UDim2.new(1,0,0,20)
	label.Font=Enum.Font.Gotham
	label.TextSize=failure and 14 or 11
	label.TextColor3=failure and Color3.fromRGB(238,238,238) or Color3.fromRGB(170,170,170)
	label.TextXAlignment=failure and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
	label.TextWrapped=true
	label.Text=message or "Loading GUI..."
	label.Parent=content or panel
	startupPanel,startupLabel=panel,label
	if not failure then
		sharedEnv.GUI_STARTUP_STATE={screen=screen,panel=panel,label=label,percent=startupPercent,segments=startupSegments,content=content}
		sharedEnv.GUI_STARTUP_PROGRESS=setStartupProgress
		loaderEnv.GUI_STARTUP_PROGRESS=setStartupProgress
		TweenService:Create(scale,TweenInfo.new(0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
	end
end
setStartupProgress=function(status,current,total,isProblem)
	if not(startupScreen and startupScreen.Parent and startupPanel and startupPanel.Name=="Loading") then return end
	local fraction=math.clamp((tonumber(current) or 0)/math.max(tonumber(total) or 1,1),0,1)
	startupLabel.Text=tostring(status or "loading modules...")
	startupPercent.Text=math.floor(fraction*100+0.5).."%"
	local filled=math.floor(fraction*10+0.0001)
	for index,segment in ipairs(startupSegments) do
		local active=index<=filled
		local color=active and Color3.fromRGB(isProblem and 254 or 35,isProblem and 94 or 255,isProblem and 86 or 89) or Color3.fromRGB(35,35,35)
		local transparency=active and 0 or 0.8
		if segment.BackgroundColor3~=color or segment.BackgroundTransparency~=transparency then
			TweenService:Create(segment,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
				BackgroundColor3=color,BackgroundTransparency=transparency,
			}):Play()
		end
	end
end
local function showStartupFailure()
	showStartup("GUI could not load.",true)
	if not startupPanel then return end
	if startupPanel:FindFirstChild("SupportLink") then return end
	startupLabel.Size=UDim2.new(1,-44,0,24)
	local link=Instance.new("TextButton")
	link.Name="SupportLink"
	link.BackgroundTransparency=1
	link.Position=UDim2.fromOffset(16,38)
	link.Size=UDim2.new(1,-32,0,24)
	link.Font=Enum.Font.Gotham
	link.TextSize=13
	link.TextColor3=Color3.fromRGB(203,135,103)
	link.TextXAlignment=Enum.TextXAlignment.Left
	link.RichText=true
	link.Text="<u>ERROR: JOIN DISCORD</u>"
	link.Parent=startupPanel
	local busy=false
	link.Activated:Connect(function()
		if busy then return end
		busy=true
		task.spawn(function()
			local ok,status=pcall(function() return openSupportInvite and openSupportInvite() or "Invite unavailable." end)
			if startupLabel and startupLabel.Parent then startupLabel.Text=ok and status or "Invite unavailable. Try again." end
			busy=false
		end)
	end)
end
if not sharedEnv.GUI_LOADER_BUSY then pcall(showStartup,"Loading GUI...") end


local entryOwner={Thread=coroutine.running()}
sharedEnv.GUI_ENTRY_BUSY=entryOwner
local started=os.clock()
local url="https://lint-bot-production.up.railway.app/loader/gui?canonical=1"
local previousSocketRequest=rawget(sharedEnv,"GUI_HTTP_REQUEST")
local previousSocketClose=rawget(sharedEnv,"GUI_SOCKET_CLOSE")
 
local requests,seen={},{}
local function addRequest(fn)
    if type(fn)=="function" and not seen[fn] then
        seen[fn]=true requests[#requests+1]=fn
    end
end
addRequest(loaderEnv.request) addRequest(sharedEnv.request)
addRequest(loaderEnv.http_request) addRequest(sharedEnv.http_request)
for _,api in ipairs({"syn","http","fluxus"}) do
    local value=loaderEnv[api] or sharedEnv[api]
    if type(value)=="table" then addRequest(value.request) end
end
local socketRequest,connectionClose,socketTransport
local connecting,disposed=false,false
local previousEnvRequest,previousSharedRequest=loaderEnv.request,sharedEnv.request
local function closeSocketTransport()
    disposed=true
    if connectionClose then connectionClose() end
    if loaderEnv.request==socketTransport then loaderEnv.request=previousEnvRequest end
    if sharedEnv.request==socketTransport then sharedEnv.request=previousSharedRequest end
    if sharedEnv.GUI_HTTP_REQUEST==socketTransport then sharedEnv.GUI_HTTP_REQUEST=previousSocketRequest end
    if sharedEnv.GUI_SOCKET_CLOSE==closeSocketTransport then sharedEnv.GUI_SOCKET_CLOSE=previousSocketClose end
end
socketTransport=function(options)
    assert(not disposed,"GUI socket closed. Run the loader again.")
    if connecting then
        local deadline=os.clock()+10
        while connecting and not disposed and os.clock()<deadline do task.wait() end
        assert(not connecting and not disposed,"GUI socket connection timed out.")
    end
    if not socketRequest then
        connecting=true
        local connected,result=pcall(function()
 
local sockets=WebSocket or websocket or (type(syn)=="table" and syn.websocket)
assert(type(sockets)=="table" and type(sockets.connect)=="function","Executor needs WebSocket.connect for this loader.")
local HttpService=game:GetService("HttpService")
local env=type(_G)=="table" and _G or {}
if type(getfenv)=="function" then
    local ok,value=pcall(getfenv,0)
    if ok and type(value)=="table" then env=value end
end
local shared=env
if type(getgenv)=="function" then
    local ok,value=pcall(getgenv)
    if ok and type(value)=="table" then shared=value end
end
local socket=sockets.connect("wss://lint-bot-production.up.railway.app/transport/gui")
if disposed then pcall(function() socket:Close() end) error("GUI socket closed.") end
local pending,nextId,closed={},0,false
local requestSocket,close
local messageConnection,closeConnection
close=function()
    local wasClosed=closed
    closed=true
    if messageConnection then pcall(function() messageConnection:Disconnect() end) end
    if closeConnection then pcall(function() closeConnection:Disconnect() end) end
    if socketRequest==requestSocket then socketRequest=nil end
    if connectionClose==close then connectionClose=nil end
    if not wasClosed then pcall(function() socket:Close() end) end
end
connectionClose=close
local function decodeSocketBody(encoded)
    assert(type(encoded)=="string"and #encoded%4==0,"Invalid socket image encoding")
    local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local values={}for i=1,#alphabet do values[alphabet:byte(i)]=i-1 end
    local parts,bytes={},{}
    local function flush()
        if #bytes>0 then parts[#parts+1]=string.char(table.unpack(bytes))table.clear(bytes)end
    end
    for i=1,#encoded,4 do
        local a,b,c,d=values[encoded:byte(i)],values[encoded:byte(i+1)],values[encoded:byte(i+2)],values[encoded:byte(i+3)]
        assert(a and b,"Invalid socket image encoding")
        assert(c or encoded:sub(i+2,i+2)=="=","Invalid socket image encoding")
        assert(d or encoded:sub(i+3,i+3)=="=","Invalid socket image encoding")
        assert((c and d)or i+3==#encoded,"Invalid socket image padding")
        if not c then assert(not d and b%16==0,"Invalid socket image padding")
        elseif not d then assert(c%4==0,"Invalid socket image padding")end
        local number=a*262144+b*4096+(c or 0)*64+(d or 0)
        bytes[#bytes+1]=math.floor(number/65536)%256
        if c then bytes[#bytes+1]=math.floor(number/256)%256 end
        if d then bytes[#bytes+1]=number%256 end
        if #bytes>=384 then flush()end
    end
    flush()return table.concat(parts)
end
local listenersOk=pcall(function()
messageConnection=socket.OnMessage:Connect(function(text)
    local ok,message=pcall(HttpService.JSONDecode,HttpService,text)
    if ok and type(message)=="table" then
        local item=pending[message.id]
        if item then
            if message.BodyEncoding=="base64"then
                local decoded,body=pcall(decodeSocketBody,message.Body)
                if decoded then message.Body=body message.BodyEncoding=nil
                else message={StatusCode=502,Body="GUI image response damaged."}end
            end
            item.Response=message item.Done=true
        end
    end
end)
closeConnection=socket.OnClose:Connect(function()
    closed=true
    if socketRequest==requestSocket then socketRequest=nil end
    if close then close() end
end)
end)
if not listenersOk or closed then close() error("GUI socket signals unavailable.") end
requestSocket=function(options)
    assert(not closed,"GUI socket disconnected. Run the loader again.")
    local route=options.Url:match("^https://lint%-bot%-production%.up%.railway%.app(/.*)$")
    assert(route,"GUI socket received a different service URL.")
    nextId+=1
    local id=tostring(nextId)
    local item={Done=false}
    pending[id]=item
    local sent=pcall(socket.Send,socket,HttpService:JSONEncode({Version=2,id=id,Path=route,Method=options.Method or "GET",Body=options.Body}))
    if not sent then pending[id]=nil close() error("GUI socket send failed.") end
    local deadline=os.clock()+35
    while not item.Done and not closed and os.clock()<deadline do task.wait() end
    pending[id]=nil
    assert(item.Response,"GUI socket request failed. Retry shortly.")
    return item.Response
end
return requestSocket

        end)
        connecting=false
        assert(connected,result)
        socketRequest=result
    end
    return socketRequest(options)
end
local ws=WebSocket or websocket or (type(syn)=="table" and syn.websocket)
if type(ws)=="table" and type(ws.connect)=="function" then
    sharedEnv.GUI_HTTP_REQUEST=socketTransport
    if type(loaderEnv.request)~="function" then loaderEnv.request=socketTransport end
    if type(sharedEnv.request)~="function" then sharedEnv.request=socketTransport end
    sharedEnv.GUI_SOCKET_CLOSE=closeSocketTransport
end
local downloads={}
local function startDownload(transport,call)
    local item={Transport=transport,Done=false}
    downloads[#downloads+1]=item
    task.spawn(function()
        item.Ok,item.Value=pcall(call)
        item.Done=true
    end)
    return item
end
local function sourceBody(value)
    if type(value)=="table" then
        local status=tonumber(value.StatusCode or value.Status or value.status_code or value.status)
        if status and status~=0 and (status<200 or status>=300) then return nil end
        value=value.Body or value.body or value.ResponseBody
    end
    if type(value)~="string" or value=="" or #value>12000000 then return nil end
    if value:sub(1,3)=="\239\187\191" then value=value:sub(4) end
     
    local first=value:match("^%s*(.)")
    if not first or first=="<" or first=="{" or first=="[" then return nil end
    return value
end
local state=startDownload("http",function() return game:HttpGet(url) end)
local deadline=os.clock()+1.25
while not state.Done and not disposed and os.clock()<deadline do task.wait() end
local ok,result=xpcall(function()
    local chunk,transport
    local function completedDownload()
        if disposed then return end
        for _,item in ipairs(downloads) do
            if item.Done and not item.Checked then
                item.Checked=true
                local source=item.Ok and sourceBody(item.Value)
                if source then
                    local candidate=compile(source,"gui-loader")
                    if candidate then return candidate,item.Transport end
                end
            end
        end
    end
    chunk,transport=completedDownload()
    if not chunk then
        local providers={}
        for _,requestApi in ipairs(requests)do
            providers[#providers+1]={name="request",call=function()return requestApi({Url=url,Method="GET"})end}
        end
        if type(ws)=="table"and type(ws.connect)=="function"then
            providers[#providers+1]={name="websocket",call=function()return socketTransport({Url=url,Method="GET"})end}
        end
        local nextProvider,nextHedge=1,os.clock()
        local function advance()
            local provider=providers[nextProvider]
            if not provider then return false end
            nextProvider+=1 nextHedge=os.clock()+0.4
            startDownload(provider.name,provider.call)return true
        end
        advance()
        deadline=started+50
        local retried=false
        repeat
            chunk,transport=completedDownload()
            if chunk then break end
            local pending=false
            for _,item in ipairs(downloads) do if not item.Done then pending=true break end end
            if nextProvider<=#providers and(not pending or os.clock()>=nextHedge)then
                advance()pending=true
            elseif not pending and not retried and not disposed and os.clock()<deadline then
                retried=true
                task.wait(0.35)
                startDownload("http",function() return game:HttpGet(url) end)
                nextProvider=1 nextHedge=os.clock()+0.4
                pending=true
            end
            if disposed or not pending or os.clock()>=deadline then break end
            task.wait()
        until false
    end
    if disposed then return false end
    assert(chunk,"GUI download failed. Retry shortly.")
    sharedEnv.GUI_ENTRY_TIMINGS={Transport=transport,Download=os.clock()-started}
    return chunk()
end,function(err) return tostring(err) end)
if sharedEnv.GUI_ENTRY_BUSY==entryOwner then sharedEnv.GUI_ENTRY_BUSY=nil end
if disposed then pcall(closeStartup) return false end
if not ok or result==false then
    pcall(closeSocketTransport)
elseif type(previousSocketClose)=="function" then
    local previous=previousSocketRequest
    pcall(previousSocketClose)
    previousSocketRequest,previousSocketClose=nil,nil
    if previousEnvRequest==previous then
        previousEnvRequest=loaderEnv.request~=socketTransport and loaderEnv.request or nil
    end
    if previousSharedRequest==previous then
        previousSharedRequest=sharedEnv.request~=socketTransport and sharedEnv.request or nil
    end
    if type(ws)=="table" and type(ws.connect)=="function" then
        if type(loaderEnv.request)~="function" then loaderEnv.request=socketTransport end
        if type(sharedEnv.request)~="function" then sharedEnv.request=socketTransport end
    end
end
if not ok then
    sharedEnv.GUI_LAST_BOOT_ERROR=result
    pcall(showStartupFailure)
    return false
end
return result
