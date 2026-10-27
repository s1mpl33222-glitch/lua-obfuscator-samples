
local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local CoreGui=game:GetService("CoreGui")
local lp=Players.LocalPlayer
local BASE="https://keyxenova.netlify.app"
local req=(syn and syn.request) or (http and http.request) or http_request or request
local function hwid()
  local ok,id=pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
  return ok and id or "unknown"
end
local function info(k)
  return {key=k,hwid=hwid(),userId=lp.UserId,username=lp.Name,placeId=game.PlaceId,jobId=game.JobId}
end
local function call(path,body)
  local ok,res=pcall(function()
    local r=req({Url=BASE..path,Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode(body)})
    return HttpService:JSONDecode(r.Body)
  end)
  if ok then return res end
  return {ok=false,msg="เชื่อมต่อเซิร์ฟเวอร์ไม่ได้"}
end
local function showBanner(text,soundId,allowReply,k,h)
  pcall(function()
    local sg=Instance.new("ScreenGui") sg.Name="NVEX_Announce" sg.ResetOnSpawn=false
    pcall(function() sg.Parent=CoreGui end) if not sg.Parent then sg.Parent=lp:WaitForChild("PlayerGui") end
    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,380,0,allowReply and 112 or 72)
    card.Position=UDim2.new(0.5,-190,0,-160)
    card.BackgroundColor3=Color3.fromRGB(20,16,35) card.BorderSizePixel=0
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,16)
    local grad=Instance.new("UIGradient",card)
    grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(130,45,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,60,170))})
    grad.Rotation=45 grad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.82),NumberSequenceKeypoint.new(1,0.82)})
    local stroke=Instance.new("UIStroke",card) stroke.Color=Color3.new(1,1,1) stroke.Transparency=0.7 stroke.Thickness=1.5
    local icon=Instance.new("TextLabel",card) icon.Size=UDim2.new(0,40,0,40) icon.Position=UDim2.new(0,14,0,14)
    icon.BackgroundTransparency=1 icon.Text="📢" icon.TextSize=28
    local title=Instance.new("TextLabel",card) title.Size=UDim2.new(1,-70,0,20) title.Position=UDim2.new(0,64,0,10)
    title.BackgroundTransparency=1 title.TextXAlignment=Enum.TextXAlignment.Left title.Text="ประกาศจากแอดมิน NVEX"
    title.TextColor3=Color3.new(1,1,1) title.Font=Enum.Font.GothamBold title.TextSize=14
    local msg=Instance.new("TextLabel",card) msg.Size=UDim2.new(1,-80,0,26) msg.Position=UDim2.new(0,64,0,32)
    msg.BackgroundTransparency=1 msg.TextXAlignment=Enum.TextXAlignment.Left msg.TextWrapped=true
    msg.Text=tostring(text) msg.TextColor3=Color3.fromRGB(230,225,255) msg.Font=Enum.Font.Gotham msg.TextSize=13
    if soundId and soundId~="" then
      pcall(function() local snd=Instance.new("Sound",card) snd.SoundId="rbxassetid://"..tostring(soundId) snd.Volume=3 snd:Play() snd.Ended:Connect(function() snd:Destroy() end) end)
    end
    if allowReply then
      local rb=Instance.new("TextBox",card) rb.Size=UDim2.new(1,-80,0,28) rb.Position=UDim2.new(0,64,0,68)
      rb.BackgroundColor3=Color3.fromRGB(10,8,20) rb.TextColor3=Color3.new(1,1,1) rb.PlaceholderText="พิมพ์ตอบกลับแล้วกด Enter..."
      rb.Font=Enum.Font.Gotham rb.TextSize=12 Instance.new("UICorner",rb).CornerRadius=UDim.new(0,8)
      rb.FocusLost:Connect(function(enter)
        if enter and rb.Text~="" then
          call("/api/announce-reply",{key=k,hwid=h,username=lp.Name,text=rb.Text})
          rb.Text="✅ ส่งแล้ว" task.wait(1) pcall(function() rb.Text="" end)
        end
      end)
    end
    card:TweenPosition(UDim2.new(0.5,-190,0,20),"Out","Back",0.6,true)
    task.wait(allowReply and 14 or 8)
    card:TweenPosition(UDim2.new(0.5,-190,0,-160),"In","Quad",0.5,true)
    task.wait(0.6) sg:Destroy()
  end)
end
local function pollAnnounce(k,h)
  task.spawn(function()
    while true do
      task.wait(6)
      local res=call("/api/poll-commands",{key=k,hwid=h})
      if res and res.ok and res.commands then
        for _,c in ipairs(res.commands) do
          if c.type=="announcement" then showBanner(c.text,c.soundId,c.allowReply,k,h) end
        end
      end
    end
  end)
end
local function start(k)
  local res=call("/api/verify",info(k))
  if not res.ok then return false,res.msg end
  task.spawn(function()
    while true do
      task.wait(30)
      local h=call("/api/heartbeat",info(k))
      if h.ok==false and h.msg~="เชื่อมต่อเซิร์ฟเวอร์ไม่ได้" then warn("[NVEX] "..tostring(h.msg)) break end
    end
  end)
  pollAnnounce(k,hwid())
  local f,err=loadstring(res.script)
  if f then task.spawn(f) else warn(err) end
  return true
end
local preset=getgenv and getgenv().Key
if preset then
  local ok,msg=start(preset)
  if not ok then warn("[NVEX] "..tostring(msg)) end
  return
end
local gui=Instance.new("ScreenGui") gui.ResetOnSpawn=false
if not pcall(function() gui.Parent=CoreGui end) then gui.Parent=lp:WaitForChild("PlayerGui") end
local f=Instance.new("Frame",gui) f.Size=UDim2.fromOffset(340,180) f.Position=UDim2.new(0.5,-170,0.5,-90)
f.BackgroundColor3=Color3.fromRGB(15,15,22) f.Active=true f.Draggable=true
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
local t=Instance.new("TextLabel",f) t.Size=UDim2.new(1,0,0,40) t.BackgroundTransparency=1 t.Text="NVEX Loader"
t.TextColor3=Color3.fromRGB(190,110,255) t.Font=Enum.Font.GothamBold t.TextSize=15
local box=Instance.new("TextBox",f) box.Size=UDim2.new(1,-40,0,36) box.Position=UDim2.new(0,20,0,48)
box.BackgroundColor3=Color3.fromRGB(25,25,35) box.TextColor3=Color3.new(1,1,1) box.PlaceholderText="NVEX-XXXX-XXXX-XXXX"
box.Text="" box.Font=Enum.Font.Gotham box.TextSize=13 Instance.new("UICorner",box)
local b=Instance.new("TextButton",f) b.Size=UDim2.new(1,-40,0,36) b.Position=UDim2.new(0,20,0,94)
b.BackgroundColor3=Color3.fromRGB(110,40,230) b.TextColor3=Color3.new(1,1,1) b.Text="ตรวจสอบคีย์" b.Font=Enum.Font.GothamBold b.TextSize=13
Instance.new("UICorner",b)
local s=Instance.new("TextLabel",f) s.Size=UDim2.new(1,0,0,30) s.Position=UDim2.new(0,0,0,140) s.BackgroundTransparency=1
s.Text="" s.TextColor3=Color3.fromRGB(150,150,190) s.Font=Enum.Font.Gotham s.TextSize=12
b.MouseButton1Click:Connect(function()
  s.Text="กำลังตรวจสอบ..."
  local ok,msg=start(box.Text:upper():gsub("%s",""))
  if ok then gui:Destroy() else s.TextColor3=Color3.fromRGB(255,70,70) s.Text="❌ "..tostring(msg) end
end)
