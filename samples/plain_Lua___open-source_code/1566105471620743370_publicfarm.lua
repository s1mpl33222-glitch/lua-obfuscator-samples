-- P2TProtect hosted loader / publicfarm
local HttpService=game:GetService("HttpService")
local Players=game:GetService("Players")
local BASE="http://currenthub.kdns.fr:20011"
local SLUG="publicfarm"
local INVITE="https://discord.gg/Qs7dT6w7Kv"
local RAW=BASE.."/raw/"..SLUG
local CHECK=BASE.."/api/public/loader/"..SLUG.."/validate"
local FILE="P2TProtect_"..SLUG..".key"
local player=Players.LocalPlayer

local function enc(v) return HttpService:UrlEncode(tostring(v or "")) end
local function trim(s) s=tostring(s or ""); s=s:gsub("^%s+",""); s=s:gsub("%s+$",""); return s end
local function clientId() local ok,v=pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end); return ok and tostring(v) or "" end
local function notify(msg) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="P2TProtect",Text=tostring(msg),Duration=6}) end) end
local function httpGet(url) local ok,v=pcall(function() return game:HttpGet(url) end); if ok then return v end; return nil,tostring(v) end
local function query(key) return "?key="..enc(key).."&hwid="..enc(clientId()).."&uid="..enc(player.UserId).."&username="..enc(player.Name) end

-- Saved key (one file per script, written only after the server accepts the key)
local function readKey()
 local ok,v=pcall(function() if isfile and readfile and isfile(FILE) then return readfile(FILE) end end)
 if ok and type(v)=="string" then return trim(v) end
 return ""
end
local function saveKey(k) pcall(function() if writefile then writefile(FILE,k) end end) end
local function clearKey() pcall(function() if delfile and isfile and isfile(FILE) then delfile(FILE) elseif writefile then writefile(FILE,"") end end) end

-- Always asks the server. Returns true,data | false,message,networkFailed
local function validate(key)
 local body,err=httpGet(CHECK..query(key))
 if not body then return false,"Could not reach the server: "..tostring(err),true end
 local ok,data=pcall(function() return HttpService:JSONDecode(body) end)
 if not ok or type(data)~="table" then return false,"Unexpected server response.",true end
 if data.ok then return true,data end
 return false,tostring(data.error or "Invalid or expired key"),false
end

local function launch(key)
 local src,err=httpGet(RAW..query(key))
 if not src then notify("Could not load the script: "..tostring(err)); return false end
 if type(loadstring)~="function" then notify("loadstring is unavailable in this executor"); return false end
 local compiled,fn=pcall(loadstring,src)
 if not compiled or type(fn)~="function" then notify("The protected script could not compile"); return false end
 local ran,runErr=pcall(fn)
 if not ran then notify(runErr) end
 return true
end

local function openInvite()
 local copied=false
 pcall(function() if setclipboard then setclipboard(INVITE); copied=true end end)
 local code=INVITE:match("discord%.gg/([%w%-]+)")
 local req=(syn and syn.request) or http_request or request_fn or (type(request)=="function" and request) or nil
 if code and req then
  pcall(function()
   req({Url="http://127.0.0.1:6463/rpc?v=1",Method="POST",Headers={["Content-Type"]="application/json",["Origin"]="https://discord.com"},Body=HttpService:JSONEncode({cmd="INVITE_BROWSER",args={code=code},nonce=HttpService:GenerateGUID(false)})})
  end)
 end
 pcall(function() game:GetService("GuiService"):OpenBrowserWindow(INVITE) end)
 return copied
end

local function showGui(firstMessage)
 local gui=Instance.new("ScreenGui"); gui.Name="P2TProtectKey"; gui.ResetOnSpawn=false
 local parented=pcall(function() gui.Parent=(gethui and gethui()) or game:GetService("CoreGui") end)
 if not parented or not gui.Parent then gui.Parent=player:WaitForChild("PlayerGui") end

 local frame=Instance.new("Frame"); frame.Size=UDim2.fromOffset(340,200); frame.Position=UDim2.new(.5,-170,.5,-100)
 frame.BackgroundColor3=Color3.fromRGB(12,15,22); frame.BorderSizePixel=0; frame.Active=true; frame.Draggable=true; frame.Parent=gui
 local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,12); corner.Parent=frame

 local title=Instance.new("TextLabel"); title.Size=UDim2.new(1,-56,0,32); title.Position=UDim2.fromOffset(16,10); title.BackgroundTransparency=1
 title.Text="P2TProtect  -  Key System"; title.TextColor3=Color3.fromRGB(238,242,255); title.Font=Enum.Font.GothamBold; title.TextSize=15
 title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=frame

 local close=Instance.new("TextButton"); close.Size=UDim2.fromOffset(28,28); close.Position=UDim2.new(1,-40,0,12); close.BackgroundColor3=Color3.fromRGB(35,43,58)
 close.Text="X"; close.TextColor3=Color3.fromRGB(238,242,255); close.Font=Enum.Font.GothamBold; close.TextSize=12; close.Parent=frame
 local closeCorner=Instance.new("UICorner"); closeCorner.CornerRadius=UDim.new(0,8); closeCorner.Parent=close

 local box=Instance.new("TextBox"); box.Size=UDim2.new(1,-32,0,38); box.Position=UDim2.fromOffset(16,52); box.PlaceholderText="Enter your key"; box.Text=""
 box.ClearTextOnFocus=false; box.TextColor3=Color3.fromRGB(238,242,255); box.PlaceholderColor3=Color3.fromRGB(120,132,152); box.BackgroundColor3=Color3.fromRGB(24,29,40)
 box.Font=Enum.Font.Code; box.TextSize=13; box.BorderSizePixel=0; box.Parent=frame
 local boxCorner=Instance.new("UICorner"); boxCorner.CornerRadius=UDim.new(0,8); boxCorner.Parent=box

 local get=Instance.new("TextButton"); get.Size=UDim2.new(.5,-22,0,34); get.Position=UDim2.fromOffset(16,102); get.Text="Get Key"
 get.TextColor3=Color3.fromRGB(238,242,255); get.BackgroundColor3=Color3.fromRGB(35,43,58); get.Font=Enum.Font.GothamBold; get.TextSize=12; get.BorderSizePixel=0; get.Parent=frame
 local getCorner=Instance.new("UICorner"); getCorner.CornerRadius=UDim.new(0,8); getCorner.Parent=get

 local submit=Instance.new("TextButton"); submit.Size=UDim2.new(.5,-22,0,34); submit.Position=UDim2.new(.5,6,0,102); submit.Text="Submit Key"
 submit.TextColor3=Color3.fromRGB(7,10,15); submit.BackgroundColor3=Color3.fromRGB(107,220,177); submit.Font=Enum.Font.GothamBold; submit.TextSize=12; submit.BorderSizePixel=0; submit.Parent=frame
 local submitCorner=Instance.new("UICorner"); submitCorner.CornerRadius=UDim.new(0,8); submitCorner.Parent=submit

 local status=Instance.new("TextLabel"); status.Size=UDim2.new(1,-32,0,44); status.Position=UDim2.fromOffset(16,146); status.BackgroundTransparency=1
 status.Text=firstMessage or "Join the Discord to get a key."; status.TextColor3=Color3.fromRGB(150,163,184); status.Font=Enum.Font.Gotham; status.TextSize=11
 status.TextWrapped=true; status.TextXAlignment=Enum.TextXAlignment.Left; status.TextYAlignment=Enum.TextYAlignment.Top; status.Parent=frame

 local busy=false
 close.MouseButton1Click:Connect(function() gui:Destroy() end)
 get.MouseButton1Click:Connect(function()
  local copied=openInvite()
  status.TextColor3=Color3.fromRGB(150,163,184)
  status.Text=copied and "Discord invite opened and copied. Join and ask for your key." or ("Join the Discord: "..INVITE)
 end)
 submit.MouseButton1Click:Connect(function()
  if busy then return end
  local key=trim(box.Text)
  if key=="" then status.TextColor3=Color3.fromRGB(255,140,140); status.Text="Enter your key first."; return end
  busy=true; status.TextColor3=Color3.fromRGB(150,163,184); status.Text="Checking key..."
  local ok,info=validate(key)
  if ok then
   saveKey(key); status.TextColor3=Color3.fromRGB(107,220,177); status.Text="Key accepted. Loading..."
   gui:Destroy(); launch(key)
  else
   status.TextColor3=Color3.fromRGB(255,140,140); status.Text=tostring(info)
   busy=false
  end
 end)
end

-- On every execution: a saved key is checked with the server first.
local saved=readKey()
local ok,info,netFail=validate(saved)
if ok then
 launch(saved)
elseif saved~="" and not netFail then
 clearKey()
 showGui(tostring(info))
else
 showGui(netFail and tostring(info) or nil)
end