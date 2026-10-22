local _lp=game:GetService("Players").LocalPlayer
local _base="https://krulhub.dev"
local _pid="roclothes-krul"
local _inv="discord.gg/SBUuYsnShf"
local _nce="tnakft.mvbcygk7.22da065ebd3a88ec636a88df407d2c5f"
local _nm="RoClothes:Krul"
local _done=false
local _accept=false
local _sg=Instance.new("ScreenGui")
_sg.Name="KrulHub"
_sg.ResetOnSpawn=false
_sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function() _sg.Parent=game:GetService("CoreGui") end)
if not _sg.Parent then _sg.Parent=_lp:WaitForChild("PlayerGui") end
local _bg=Instance.new("Frame")
_bg.Size=UDim2.new(1,0,1,0)
_bg.BackgroundColor3=Color3.fromRGB(0,0,0)
_bg.BackgroundTransparency=1
_bg.ZIndex=100
_bg.Parent=_sg
local _card=Instance.new("Frame")
_card.Size=UDim2.new(0,500,0,370)
_card.AnchorPoint=Vector2.new(0.5,0.5)
_card.Position=UDim2.new(0.5,0,0.5,0)
_card.BackgroundColor3=Color3.fromRGB(7,7,15)
_card.BorderSizePixel=0
_card.ZIndex=101
_card.Parent=_sg
Instance.new("UICorner",_card).CornerRadius=UDim.new(0,12)
local _brd=Instance.new("UIStroke",_card)
_brd.Color=Color3.fromRGB(28,28,48)
_brd.Thickness=1.5
local _cam=workspace.CurrentCamera
local _usc=Instance.new("UIScale",_card)
local function _fit()
  local _vp=(_cam and _cam.ViewportSize) or Vector2.new(1280,720)
  local _s=math.min(_vp.X*0.85/500,_vp.Y*0.70/370,1)
  if _s<0.4 then _s=0.4 end
  _usc.Scale=_s
end
_fit()
if _cam then _cam:GetPropertyChangedSignal("ViewportSize"):Connect(_fit) end
local _hl=Instance.new("TextLabel",_card)
_hl.Size=UDim2.new(1,-52,0,26)
_hl.Position=UDim2.new(0,18,0,14)
_hl.BackgroundTransparency=1
_hl.Text="KrulHub - Script Loader"
_hl.TextColor3=Color3.fromRGB(244,63,142)
_hl.TextXAlignment=Enum.TextXAlignment.Left
_hl.Font=Enum.Font.GothamBold
_hl.TextSize=16
_hl.ZIndex=102
local _xb=Instance.new("TextButton",_card)
_xb.Size=UDim2.new(0,26,0,26)
_xb.Position=UDim2.new(1,-38,0,12)
_xb.BackgroundColor3=Color3.fromRGB(28,28,48)
_xb.BorderSizePixel=0
_xb.Text="X"
_xb.TextColor3=Color3.fromRGB(150,150,180)
_xb.Font=Enum.Font.GothamBold
_xb.TextSize=14
_xb.ZIndex=102
Instance.new("UICorner",_xb).CornerRadius=UDim.new(0,5)
local _nl=Instance.new("TextLabel",_card)
_nl.Size=UDim2.new(1,-36,0,22)
_nl.Position=UDim2.new(0,18,0,46)
_nl.BackgroundTransparency=1
_nl.Text=_nm
_nl.TextColor3=Color3.fromRGB(226,232,240)
_nl.TextXAlignment=Enum.TextXAlignment.Left
_nl.Font=Enum.Font.GothamBold
_nl.TextSize=15
_nl.ZIndex=102
local _sl=Instance.new("TextLabel",_card)
_sl.Size=UDim2.new(1,-36,0,16)
_sl.Position=UDim2.new(0,18,0,70)
_sl.BackgroundTransparency=1
_sl.Text="Hosted & protected by KrulHub"
_sl.TextColor3=Color3.fromRGB(100,116,139)
_sl.TextXAlignment=Enum.TextXAlignment.Left
_sl.Font=Enum.Font.Gotham
_sl.TextSize=11
_sl.ZIndex=102
local _dv=Instance.new("Frame",_card)
_dv.Size=UDim2.new(1,-36,0,1)
_dv.Position=UDim2.new(0,18,0,90)
_dv.BackgroundColor3=Color3.fromRGB(28,28,48)
_dv.BorderSizePixel=0
_dv.ZIndex=102
local _ck={"Only your UserId and IP, briefly, for online count and rate limits.","Only executes after you press Continue — tap X to cancel at any time.","Not responsible for game ban/account ban."}
local _yo=100
for _i,_t in ipairs(_ck) do
  local _l=Instance.new("TextLabel",_card)
  _l.Size=UDim2.new(1,-58,0,44)
  _l.Position=UDim2.new(0,28,0,_yo)
  _l.BackgroundTransparency=1
  _l.Text=tostring(_i)..". ".._t
  _l.TextColor3=Color3.fromRGB(226,232,240)
  _l.TextXAlignment=Enum.TextXAlignment.Left
  _l.Font=Enum.Font.GothamBold
  _l.TextSize=13
  _l.TextWrapped=true
  _l.ZIndex=102
  _yo=_yo+46
end
local _btn=Instance.new("TextButton",_card)
_btn.Size=UDim2.new(1,-36,0,50)
_btn.Position=UDim2.new(0,18,0,_yo+8)
_btn.BackgroundColor3=Color3.fromRGB(244,63,142)
_btn.BorderSizePixel=0
_btn.Text="Continue"
_btn.TextColor3=Color3.fromRGB(255,255,255)
_btn.Font=Enum.Font.GothamBold
_btn.TextSize=16
_btn.ZIndex=102
Instance.new("UICorner",_btn).CornerRadius=UDim.new(0,8)
_btn.MouseButton1Click:Connect(function() _accept=true _done=true end)
local _db=Instance.new("TextButton",_card)
_db.Size=UDim2.new(1,-36,0,36)
_db.Position=UDim2.new(0,18,0,_yo+64)
_db.BackgroundColor3=Color3.fromRGB(88,101,242)
_db.BorderSizePixel=0
_db.Text="Join Discord"
_db.TextColor3=Color3.fromRGB(255,255,255)
_db.Font=Enum.Font.GothamBold
_db.TextSize=13
_db.ZIndex=102
Instance.new("UICorner",_db).CornerRadius=UDim.new(0,8)
_db.MouseButton1Click:Connect(function()
  pcall(setclipboard,_inv)
  _db.Text=_inv .. " - Copied!"
  task.delay(2,function() _db.Text="Join Discord" end)
end)
_xb.MouseButton1Click:Connect(function() _done=true end)
_xb.MouseEnter:Connect(function() _xb.BackgroundColor3=Color3.fromRGB(60,60,100) end)
_xb.MouseLeave:Connect(function() _xb.BackgroundColor3=Color3.fromRGB(28,28,48) end)
repeat task.wait(0.05) until _done
_sg:Destroy()
if _accept then
  local _u=_base.."/p/".._pid..(_nce~="" and ("?n=".._nce) or "")
  local _body
  local _hreq=request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
  if type(_hreq)=="function" then
    local _ok,_r=pcall(_hreq,{Url=_u,Method="GET",Headers={["User-Agent"]="Roblox/WinInet"}})
    if _ok and _r and (_r.StatusCode==200 or _r.Status==200) then _body=_r.Body or _r.body end
  end
  if not _body then
    local _ok,_r=pcall(function() return game:HttpGet(_u) end)
    if _ok then _body=_r end
  end
  if _body then
    local _fn,_fe=(loadstring or load)(_body)
    if _fn then _fn() else warn("[KrulHub] payload parse failed: "..tostring(_fe)) end
    task.spawn(function()
      local _hbu=_base.."/api/heartbeat?u="..tostring(_lp.UserId)
      while task.wait(60) do pcall(game.HttpGet,game,_hbu) end
    end)
  else
    warn("[KrulHub] payload fetch failed - executor lacks request() and HttpGet")
  end
end