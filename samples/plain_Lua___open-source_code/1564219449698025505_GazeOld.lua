local _1=setmetatable({},{__index=function(_,k)local c=workspace.CurrentCamera local s=c and c.ViewportSize or Vector2.new(1920,1080)if k=="Width"then return s.X elseif k=="Height"then return s.Y elseif k=="Size"then return s end end})
local _2=game:GetService("UserInputService")
local _3=workspace.CurrentCamera.ViewportSize
local function _4(_a,_b)local _c=_2.TouchEnabled and not _2.KeyboardEnabled local _d,_e=1920,1080 local _f=_c and 2 or 1.5 if _a=="X"then return _b*(_3.X/_d)*_f elseif _a=="Y"then return _b*(_3.Y/_e)*_f end end
local function _5(_a,_b,_c)if type(_b)==_a then return _b end return _c end
local _6=_5("function",cloneref,function(...)return ... end)
local _7=setmetatable({},{__index=function(_,_a)return _6(game:GetService(_a))end})
local _8=_7.Players local _9=_7.RunService local _10=_7.UserInputService local _11=_7.TweenService local _12=_7.AvatarEditorService local _13=_7.HttpService
local _14=_8.LocalPlayer local _15=_14.Character or _14.CharacterAdded:Wait()local _16=_15:WaitForChild("Humanoid")local _isR6=_16.RigType==Enum.HumanoidRigType.R6 local _17=_15.PrimaryPart and _15.PrimaryPart.Position or Vector3.new()
local _35_Ref, _36_Ref, _37_Ref, _39_Ref, _43_Ref;

_14.CharacterAdded:Connect(function(_a)
    _15=_a _16=_a:WaitForChild("Humanoid")_isR6=_16.RigType==Enum.HumanoidRigType.R6 
    if _35_Ref then _35_Ref.Text=_isR6 and "GAZE SMOTES" or "Gaze Emotes" end 
    if _36_Ref then _36_Ref.Text=_isR6 and "Anim" or "Catalog" end 
    if _37_Ref then _37_Ref.Visible=not _isR6 end 
    if _isR6 and _39_Ref and _43_Ref then 
        _39_Ref.Visible=true _43_Ref.Visible=false 
        _36_Ref.BackgroundColor3=Color3.fromRGB(30,30,80) 
        _37_Ref.BackgroundColor3=Color3.fromRGB(20,50,20) 
    end 
    _17=_15.PrimaryPart and _15.PrimaryPart.Position or Vector3.new()
end)

local _18={} _18["Stop Emote When Moving"]=true _18["Fade In"]=0.1 _18["Fade Out"]=0.1 _18["Weight"]=1 
_18["Speed"]=1 _18["Time Position"]=0 _18["Freeze On Finish"]=false _18["Looped"]=true _18["Stop Other Animations On Play"]=true _18["High Priority"]=true
local _19={} local _20="GazeEmotes_NewNEWN3WSaved.json"
local function _21()local _a,_b=pcall(function()if readfile and isfile and isfile(_20)then return _13:JSONDecode(readfile(_20))end return{}end)if _a and type(_b)=="table"then _19=_b else _19={}end for _c,_d in ipairs(_19)do if not _d.AnimationId then if _d.AssetId then _d.AnimationId="rbxassetid://"..tostring(_d.AssetId)else _d.AnimationId="rbxassetid://"..tostring(_d.Id)end end if _d.Favorite==nil then _d.Favorite=false end end end
local function _22()pcall(function()if writefile then writefile(_20,_13:JSONEncode(_19))end end)end
_21()
local _23=nil
local function _24(_a)if _23 then _23:Stop(_18["Fade Out"])end local _b 
local _c,_d=pcall(function()return game:GetObjects("rbxassetid://"..tostring(_a))end)if _c and _d and #_d>0 then local _e=_d[1]if _e:IsA("Animation")then _b=_e.AnimationId else _b="rbxassetid://"..tostring(_a)end else _b="rbxassetid://"..tostring(_a)end local _e=Instance.new("Animation")_e.AnimationId=_b local _f=_16:LoadAnimation(_e)local _g=_18["High Priority"]and Enum.AnimationPriority.Action4 or Enum.AnimationPriority.Action _f.Priority=_g local _h=_18["Weight"]if _h==0 
then _h=0.001 end if _18["Stop Other Animations On Play"]then for _i,_j in pairs(_16.Animator:GetPlayingAnimationTracks())do if _j.Priority~=_g then _j:Stop()end end end _f:Play(_18["Fade In"],_h,_18["Speed"])_23=_f _23.TimePosition=math.clamp(_18["Time Position"],0,1)*(_23.Length or 1)_23.Priority=_g _23.Looped=_18["Looped"]return _f end
_9.RenderStepped:Connect(function()if _18["Looped"]and _23 and _23.IsPlaying then _23.Looped=_18["Looped"]end if _15:FindFirstChild("HumanoidRootPart")then local _a=_15.HumanoidRootPart if _18["Stop Emote When Moving"]and _23 and _23.IsPlaying then local _b=(_a.Position-_17).Magnitude>0.1 local _c=_16 and _16:GetState()==Enum.HumanoidStateType.Jumping if _b or _c then _23:Stop(_18["Fade Out"])_23=nil end end _17=_a.Position end end)
local _25=_7.CoreGui local _26=Instance.new("ScreenGui")_26.Name="GazeEmoteGUI"_26.Parent=_25 _26.Enabled=false _26.DisplayOrder=999
local function _27(_a,_b)local _c=Instance.new("UICorner")_c.CornerRadius=UDim.new(0,_b or 6)_c.Parent=_a return _c end
local function _28(_a,_b,_c)local _d=Instance.new("UIStroke")_d.Color=_b or Color3.fromRGB(60,120,200)_d.Thickness=_c or 1 _d.ApplyStrokeMode=Enum.ApplyStrokeMode.Border _d.Parent=_a return _d end
local function _29(_a)local _b=Instance.new("UIScale")_b.Scale=0.5 _b.Parent=_a _11:Create(_b,TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Scale=1}):Play()end
local _30=Instance.new("Frame")_30.Size=UDim2.new(0,_4("X",470),0,_4("Y",450))_30.Position=UDim2.new(0.5,-_4("X",325),0.5,-_4("Y",225))_30.BackgroundColor3=Color3.fromRGB(15,15,20)_30.BackgroundTransparency=0.15 _30.Active=true _30.Draggable=true _30.Parent=_26 _27(_30,8)_28(_30,Color3.fromRGB(80,80,120),1.5)
local _31=Instance.new("TextButton")_31.Size=UDim2.new(0,24,0,24)_31.Position=UDim2.new(1,-24,1,-24)_31.BackgroundTransparency=1 _31.Text="◢"_31.TextColor3=Color3.fromRGB(100,100,140)_31.TextSize=18 _31.ZIndex=10 _31.Parent=_30
local _32=false local _33 local _34 _31.InputBegan:Connect(function(_a)if _a.UserInputType==Enum.UserInputType.MouseButton1 or _a.UserInputType==Enum.UserInputType.Touch then _32=true _33=_a.Position _34=_30.AbsoluteSize end end)_10.InputChanged:Connect(function(_a)if _32 and(_a.UserInputType==Enum.UserInputType.MouseMovement or _a.UserInputType==Enum.UserInputType.Touch)then local _b=_a.Position-_33 local _c=math.max(150,_34.X+_b.X)local _d=math.max(100,_34.Y+_b.Y)_30.Size=UDim2.new(0,_c,0,_d)end end)_10.InputEnded:Connect(function(_a)if _a.UserInputType==Enum.UserInputType.MouseButton1 or _a.UserInputType==Enum.UserInputType.Touch then _32=false end end)
local _35=Instance.new("TextLabel")_35_Ref=_35 _35.Size=UDim2.new(1,0,0,_4("Y",36))_35.BackgroundColor3=Color3.fromRGB(20,20,25)_35.BackgroundTransparency=0.5 _35.Text=_isR6 and "Gaze Emotes (R6)" or "Gaze Emotes"_35.TextColor3=Color3.new(1,1,1)_35.Font=Enum.Font.GothamBold _35.TextScaled=true _35.Parent=_30 _27(_35,8)
local _36=Instance.new("TextButton")_36_Ref=_36 _36.Size=UDim2.new(0.3,0,0,_4("Y",24))_36.Position=UDim2.new(0.05,0,0,_4("Y",40))_36.BackgroundColor3=Color3.fromRGB(30,30,80)_36.BackgroundTransparency=0.2 _36.Text=_isR6 and "Animation" or "Catalog"_36.TextColor3=Color3.new(1,1,1)_36.Font=Enum.Font.GothamBold _36.TextScaled=true _36.Parent=_30 _27(_36,4)
local _37=Instance.new("TextButton")_37_Ref=_37 _37.Size=UDim2.new(0.3,0,0,_4("Y",24))_37.Position=UDim2.new(0.35,0,0,_4("Y",40))_37.BackgroundColor3=Color3.fromRGB(30,80,30)_37.BackgroundTransparency=0.2 _37.Text="Saved"_37.TextColor3=Color3.new(1,1,1)_37.Font=Enum.Font.GothamBold _37.TextScaled=true _37.Visible=not _isR6 _37.Parent=_30 _27(_37,4)
local _38=Instance.new("Frame")_38.Size=UDim2.new(0,_4("X",2),1,-_4("Y",70))_38.Position=UDim2.new(0.6,-_4("X",1),0,_4("Y",70))_38.BackgroundColor3=Color3.fromRGB(50,50,70)_38.BackgroundTransparency=0.5 _38.Parent=_30
local _39=Instance.new("Frame")_39_Ref=_39 _39.Size=UDim2.new(0.6,-_4("X",10),1,-_4("Y",70))_39.Position=UDim2.new(0,_4("X",5),0,_4("Y",70))_39.BackgroundTransparency=1 _39.Visible=true _39.Parent=_30
local _40=Instance.new("TextBox")_40.Size=UDim2.new(0.6,-_4("X",8),0,_4("Y",28))_40.Position=UDim2.new(0,_4("X",8),0,0)_40.PlaceholderText="Search..."_40.BackgroundColor3=Color3.fromRGB(20,20,25)_40.BackgroundTransparency=0.3 _40.TextColor3=Color3.new(1,1,1)_40.Font=Enum.Font.Gotham _40.TextScaled=true _40.ClearTextOnFocus=false _40.Text=""_40.Parent=_39 
_27(_40,4)_28(_40,Color3.fromRGB(50,50,70),1)
local _41=Instance.new("TextButton")_41.Size=UDim2.new(0.2,-_4("X",4),0,_4("Y",28))_41.Position=UDim2.new(0.6,_4("X",4),0,0)_41.BackgroundColor3=Color3.fromRGB(0,60,150)_41.BackgroundTransparency=0.2 _41.Text="Refresh"_41.Font=Enum.Font.GothamBold _41.TextScaled=true _41.TextColor3=Color3.new(1,1,1)_41.Parent=_39 _27(_41,4)
local _42=Instance.new("TextButton")_42.Size=UDim2.new(0.2,-_4("X",8),0,_4("Y",28))_42.Position=UDim2.new(0.8,_4("X",4),0,0)_42.BackgroundColor3=Color3.fromRGB(40,40,80)_42.BackgroundTransparency=0.2 _42.Text="Sort: Relevance"_42.Font=Enum.Font.GothamBold _42.TextScaled=true _42.TextColor3=Color3.new(1,1,1)_42.Parent=_39 _27(_42,4)
local _43=Instance.new("Frame")_43_Ref=_43 _43.Size=UDim2.new(0.6,-_4("X",10),1,-_4("Y",70))_43.Position=UDim2.new(0,_4("X",5),0,_4("Y",70))_43.BackgroundTransparency=1 _43.Visible=false _43.Parent=_30
local _44=Instance.new("TextBox")_44.Size=UDim2.new(0.7,-_4("X",16),0,_4("Y",28))_44.Position=UDim2.new(0,_4("X",8),0,0)_44.PlaceholderText="Search Saved..."_44.BackgroundColor3=Color3.fromRGB(20,20,25)_44.BackgroundTransparency=0.3 _44.TextColor3=Color3.new(1,1,1)_44.Font=Enum.Font.Gotham _44.TextScaled=true _44.ClearTextOnFocus=false _44.Text=""_44.Parent=_43 _27(_44,4)_28(_44,Color3.fromRGB(50,50,70),1)
local _44a=Instance.new("TextBox")_44a.Size=UDim2.new(0.2,0,0,_4("Y",28))_44a.Position=UDim2.new(0.7,-_4("X",4),0,0)_44a.PlaceholderText="Emote ID"_44a.BackgroundColor3=Color3.fromRGB(20,20,25)_44a.BackgroundTransparency=0.3 _44a.TextColor3=Color3.new(1,1,1)_44a.Font=Enum.Font.Gotham _44a.TextScaled=true _44a.ClearTextOnFocus=false _44a.Text=""_44a.Parent=_43 _27(_44a,4)_28(_44a,Color3.fromRGB(50,50,70),1)
local _44b=Instance.new("TextButton")_44b.Size=UDim2.new(0.1,0,0,_4("Y",28))_44b.Position=UDim2.new(0.9,0,0,0)_44b.BackgroundColor3=Color3.fromRGB(40,100,160)_44b.BackgroundTransparency=0.2 _44b.Text="+"_44b.Font=Enum.Font.GothamBold _44b.TextScaled=true _44b.TextColor3=Color3.new(1,1,1)_44b.Parent=_43 _27(_44b,4)
local _45=Instance.new("ScrollingFrame")_45.Size=UDim2.new(1,-_4("X",16),1,-_4("Y",40))_45.Position=UDim2.new(0,_4("X",8),0,_4("Y",36))_45.CanvasSize=UDim2.new(0,0,0,0)_45.ScrollBarThickness=0 _45.BackgroundTransparency=1 _45.Parent=_43
local _46=Instance.new("TextLabel")_46.Size=UDim2.new(1,0,0,_4("Y",36))_46.Position=UDim2.new(0,0,0.5,-_4("Y",18))_46.BackgroundTransparency=1 
_46.Text="Sorry I Was Changing Save Files Again 😅"_46.TextColor3=Color3.new(1,1,1)_46.Font=Enum.Font.GothamBold _46.TextScaled=true _46.Visible=false _46.Parent=_45
local _47=Instance.new("UIGridLayout")_47.CellSize=UDim2.new(0,_4("X",120),0,_4("Y",200))_47.CellPadding=UDim2.new(0,_4("X",8),0,_4("Y",8))_47.HorizontalAlignment=Enum.HorizontalAlignment.Center _47.Parent=_45
local _48=Instance.new("Frame")_48.Size=UDim2.new(0.4,-_4("X",10),1,-_4("Y",70))_48.Position=UDim2.new(0.6,_4("X",5),0,_4("Y",70))_48.BackgroundTransparency=1 _48.Parent=_30
local _49=Instance.new("TextLabel")_49.Size=UDim2.new(1,0,0,_4("Y",28))_49.BackgroundTransparency=1 _49.Text="Settings"_49.TextColor3=Color3.new(1,1,1)_49.Font=Enum.Font.GothamBold _49.TextScaled=true _49.Parent=_48
local _50=Instance.new("ScrollingFrame")_50.Size=UDim2.new(1,-_4("X",20),1,-_4("Y",40))_50.Position=UDim2.new(0,_4("X",10),0,_4("Y",30))_50.BackgroundTransparency=1 _50.CanvasSize=UDim2.new(0,0,0,0)_50.ScrollBarThickness=4 _50.ScrollBarImageColor3=Color3.fromRGB(100,100,140)_50.Parent=_48
local function _51()_50.CanvasPosition=Vector2.new(0,_50.CanvasPosition.Y)end _50:GetPropertyChangedSignal("CanvasPosition"):Connect(_51)
local _52=Instance.new("UIListLayout",_50)_52.Padding=UDim.new(0,8)_52.FillDirection=Enum.FillDirection.Vertical _52.SortOrder=Enum.SortOrder.LayoutOrder
_52:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()_50.CanvasSize=UDim2.new(0,0,0,_52.AbsoluteContentSize.Y+10)end)
function GetReal(_a)local _b,_c=pcall(function()return game:GetObjects("rbxassetid://"..tostring(_a))end)if _b and _c and #_c>0 then local _d=_c[1]if _d:IsA("Animation")and _d.AnimationId~=""then return tonumber(_d.AnimationId:match("%d+"))elseif _d:FindFirstChildOfClass("Animation")then local _e=_d:FindFirstChildOfClass("Animation")return tonumber(_e.AnimationId:match("%d+"))end end end
local _80
_44b.MouseButton1Click:Connect(function()local _a=tonumber(_44a.Text)if _a then local _b=false for _c,_d in ipairs(_19)do if _d.Id==_a then _b=true 
break end end if not _b then local _e=GetReal(_a)table.insert(_19,{Id=_a,AssetId=_a,Name="Custom ID: ".._a,AnimationId="rbxassetid://"..tostring(_e or _a),Favorite=false})_22()_80()end end end)
_18._sliders={} _18._toggles={}
local function _53(_a,_b,_c,_d)_18[_a]=_d or _b local _e=Instance.new("Frame")_e.Size=UDim2.new(1,0,0,_4("Y",65))_e.BackgroundTransparency=1 _e.Parent=_50 local _f=Instance.new("Frame")_f.Size=UDim2.new(1,0,1,0)_f.BackgroundColor3=Color3.fromRGB(20,20,30)_f.BackgroundTransparency=0.4 _f.Parent=_e _27(_f,6)_28(_f,Color3.fromRGB(60,60,90),1)local _g=Instance.new("TextLabel")_g.Size=UDim2.new(0.5,-_4("X",10),0,_4("Y",20))_g.Position=UDim2.new(0,10,0,5)_g.BackgroundTransparency=1 _g.Text=string.format("%s: %.2f",_a,_18[_a])_g.TextColor3=Color3.new(1,1,1)_g.Font=Enum.Font.Gotham _g.TextScaled=true _g.TextXAlignment=Enum.TextXAlignment.Left _g.Parent=_f local _h=Instance.new("TextBox")_h.Size=UDim2.new(0.5,-_4("X",20),0,_4("Y",20))_h.Position=UDim2.new(0.5,_4("X",10),0,_4("Y",5))_h.BackgroundColor3=Color3.fromRGB(30,30,40)_h.Text=tostring(_18[_a])_h.TextColor3=Color3.new(1,1,1)_h.Font=Enum.Font.Gotham _h.TextScaled=true _h.ClearTextOnFocus=false _h.Parent=_f 
_27(_h,4)local _i=Instance.new("Frame")_i.Size=UDim2.new(1,-_4("X",40),0,_4("Y",12))_i.Position=UDim2.new(0,_4("X",20),0,_4("Y",35))_i.BackgroundColor3=Color3.fromRGB(40,40,50)_i.Parent=_f _27(_i,6)local _j=Instance.new("Frame")_j.Size=UDim2.new(0,0,1,0)_j.BackgroundColor3=Color3.fromRGB(0,140,255)_j.Parent=_i _27(_j,6)local _k=Instance.new("Frame")_k.Size=UDim2.new(0,_4("X",20),0,_4("Y",20))_k.AnchorPoint=Vector2.new(0.5,0.5)_k.Position=UDim2.new(0,0,0.5,0)_k.BackgroundColor3=Color3.fromRGB(220,220,255)_k.Parent=_i _27(_k,10)_28(_k,Color3.fromRGB(0,0,0),1)local function _l(_m)local _n=math.clamp(_m,0,1)_11:Create(_j,TweenInfo.new(0.15),{Size=UDim2.new(_n,0,1,0)}):Play()_11:Create(_k,TweenInfo.new(0.15),{Position=UDim2.new(_n,0,0.5,0)}):Play()end local function _o(_p)_18[_a]=math.clamp(_p,_b,_c)_g.Text=string.format("%s: %.2f",_a,_18[_a])_h.Text=tostring(_18[_a])local _q=(_18[_a]-_b)/(_c-_b)_l(_q)if _23 and _23.IsPlaying then if _a=="Speed"then _23:AdjustSpeed(_18["Speed"])elseif _a=="Weight"then local _r=_18["Weight"]if _r==0 then _r=0.001 end _23:AdjustWeight(_r)elseif _a=="Time Position"then if _23.Length>0 then _23.TimePosition=math.clamp(_p,0,1)*_23.Length end end end end local _s=false local function _t(_u)local _v=math.clamp((_u.Position.X-_i.AbsolutePosition.X)/_i.AbsoluteSize.X,0,1)local _w=math.floor((_b+(_c-_b)*_v)*100)/100 _o(_w)end _i.InputBegan:Connect(function(_x)if _x.UserInputType==Enum.UserInputType.MouseButton1 or _x.UserInputType==Enum.UserInputType.Touch then _s=true _t(_x)end end)_k.InputBegan:Connect(function(_y)if _y.UserInputType==Enum.UserInputType.MouseButton1 or _y.UserInputType==Enum.UserInputType.Touch then _s=true _t(_y)end 
end)_10.InputChanged:Connect(function(_z)if _s and(_z.UserInputType==Enum.UserInputType.MouseMovement or _z.UserInputType==Enum.UserInputType.Touch)then _t(_z)end end)_10.InputEnded:Connect(function(_A)if _s and(_A.UserInputType==Enum.UserInputType.MouseButton1 or _A.UserInputType==Enum.UserInputType.Touch)then _s=false end end)_h.FocusLost:Connect(function(_B)if _B then local _C=tonumber(_h.Text)if _C then _o(_C)else _h.Text=tostring(_18[_a])end end end)_18._sliders[_a]=_o _o(_18[_a])end
local function _54(_a)_18[_a]=_18[_a]or false local _b=Instance.new("Frame")_b.Size=UDim2.new(1,0,0,_4("Y",40))_b.BackgroundColor3=Color3.fromRGB(20,20,30)_b.BackgroundTransparency=0.4 _b.Parent=_50 _27(_b,6)_28(_b,Color3.fromRGB(60,60,90),1)local _c=Instance.new("TextLabel")_c.Size=UDim2.new(1,-_4("X",90),1,0)_c.Position=UDim2.new(0,_4("X",10),0,0)_c.BackgroundTransparency=1 _c.Text=_a _c.TextColor3=Color3.new(1,1,1)_c.Font=Enum.Font.Gotham _c.TextScaled=true _c.TextXAlignment=Enum.TextXAlignment.Left _c.Parent=_b 
local _d=Instance.new("TextButton")_d.Size=UDim2.new(0,_4("X",60),0,_4("Y",24))_d.Position=UDim2.new(1,-_4("X",70),0.5,-_4("Y",12))_d.TextColor3=Color3.new(1,1,1)_d.Font=Enum.Font.GothamBold _d.TextScaled=true _d.Parent=_b _27(_d,4)local function _e(_f)_d.Text=_f and "ON"or "OFF"_d.BackgroundColor3=_f and Color3.fromRGB(0,150,100)or Color3.fromRGB(150,40,40)_d.BackgroundTransparency=0.2 end _d.MouseButton1Click:Connect(function()_18[_a]=not _18[_a]_e(_18[_a])end)_e(_18[_a])_18._toggles[_a]=_e end
function _18:EditSlider(_a,_b)local _c=self._sliders[_a]if _c then _c(_b)end end function _18:EditToggle(_a,_b)local _c=self._toggles[_a]if _c then _18[_a]=_b _c(_b)end end
local function _55(_a,_b)local _c=Instance.new("Frame")_c.Size=UDim2.new(1,0,0,_4("Y",45))_c.BackgroundColor3=Color3.fromRGB(20,20,30)_c.BackgroundTransparency=0.4 _c.Parent=_50 _27(_c,6)local _d=Instance.new("TextButton")_d.Size=UDim2.new(1,-_4("X",20),1,-_4("Y",10))_d.Position=UDim2.new(0,_4("X",10),0,_4("Y",5))_d.BackgroundColor3=Color3.fromRGB(30,90,180)_d.BackgroundTransparency=0.2 _d.Text=_a _d.TextColor3=Color3.new(1,1,1)_d.Font=Enum.Font.GothamBold _d.TextScaled=true _d.Parent=_c _27(_d,6)_d.MouseButton1Click:Connect(function()if typeof(_b)=="function"then _b()end end)return _d end
local _56=_55("Reset Settings",function()end)_54("Stop Emote When Moving")_54("Looped")_53("Speed",0,5,_18["Speed"])_53("Time Position",0,1,_18["Time Position"])_53("Weight",0,1,_18["Weight"])_53("Fade In",0,2,_18["Fade In"])_53("Fade Out",0,2,_18["Fade Out"])_54("Stop Other Animations On Play")_54("High Priority")
_56.MouseButton1Click:Connect(function()_18:EditToggle("Stop Emote When Moving",true)_18:EditToggle("Stop Other Animations On Play",true)_18:EditToggle("High Priority",true)_18:EditSlider("Fade In",0.1)_18:EditSlider("Fade Out",0.1)_18:EditSlider("Weight",1)_18:EditSlider("Speed",1)_18:EditSlider("Time Position",0)_18:EditToggle("Freeze On Finish",false)_18:EditToggle("Looped",true)end)
local _57={{Enum.CatalogSortType.Relevance,"Relevance"},{Enum.CatalogSortType.PriceHighToLow,"Price High→Low"},{Enum.CatalogSortType.PriceLowToHigh,"Price Low→High"},{Enum.CatalogSortType.MostFavorited,"Most Favorited"},{Enum.CatalogSortType.RecentlyCreated,"Recently Created"},{Enum.CatalogSortType.Bestselling,"Bestselling"}}
local _58=1 local _59=""local _60=nil local _61=1 local _TAB=1
local function _62(_a)if _isR6 then return {IsFinished=true,GetCurrentPage=function()return{{Id=115314801778772,Name="Dance If Youre The Best",AssetId=115314801778772}}end,AdvanceToNextPageAsync=function()end}end local _b=CatalogSearchParams.new()_b.SearchKeyword=_a or ""_b.CategoryFilter=Enum.CatalogCategoryFilter.None _b.SalesTypeFilter=Enum.SalesTypeFilter.All _b.AssetTypes={Enum.AvatarAssetType.EmoteAnimation}_b.IncludeOffSale=true _b.SortType=_57[_58][1]_b.Limit=10 local _c,_d=pcall(function()return _12:SearchCatalog(_b)end)if not _c then return nil end return _d end
local function _63(_a)local _b=Instance.new("Frame")_b.Size=UDim2.new(0,_4("X",120),0,_4("Y",180))_b.BackgroundColor3=Color3.fromRGB(25,25,35)_b.BackgroundTransparency=0.2 _27(_b,8)_28(_b,Color3.fromRGB(60,60,90),1)local _c=_a.AssetId or _a.Id local _d=Instance.new("ImageLabel")_d.Size=UDim2.new(1,-_4("X",10),0,_4("Y",90))_d.Position=UDim2.new(0,_4("X",5),0,_4("Y",5))_d.BackgroundTransparency=1 _d.ScaleType=Enum.ScaleType.Fit pcall(function()_d.Image="rbxthumb://type=Asset&id="..tonumber(_c).."&w=150&h=150"end)_d.Parent=_b _27(_d,4)local _e=Instance.new("TextLabel")_e.Size=UDim2.new(1,-_4("X",10),0,_4("Y",28))_e.Position=UDim2.new(0,_4("X",5),0,_4("Y",100))_e.BackgroundTransparency=1 _e.Text=_a.Name or "Unknown"_e.TextScaled=true _e.TextWrapped=true _e.Font=Enum.Font.GothamBold _e.TextColor3=Color3.new(1,1,1)_e.Parent=_b local _f="https://www.roblox.com/catalog/"..tonumber(_a.Id)local _g=Instance.new("TextButton")_g.Parent=_b _g.Size=UDim2.new(0,_4("X",36),0,_4("Y",36))_g.Position=UDim2.new(1,-_4("X",42),0,_4("Y",5))_g.BackgroundColor3=Color3.fromRGB(30,30,45)_g.BackgroundTransparency=0.2 _g.Text="🛒🔗"_g.Font=Enum.Font.GothamBold _g.TextScaled=true _g.TextColor3=Color3.fromRGB(255,255,255)_g.AutoButtonColor=false _27(_g,6)_g.MouseButton1Click:Connect(function()setclipboard(_f)_g.Text="✅"_g.BackgroundColor3=Color3.fromRGB(0,150,100)task.wait(0.7)_g.Text="🛒🔗"_g.BackgroundColor3=Color3.fromRGB(30,30,45)end)local _h=Instance.new("TextButton")_h.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_h.Position=UDim2.new(0,_4("X",5),1,-_4("Y",29))_h.BackgroundColor3=Color3.fromRGB(40,140,80)_h.BackgroundTransparency=0.2 _h.Text="Play"_h.Font=Enum.Font.GothamBold _h.TextScaled=true _h.TextColor3=Color3.new(1,1,1)_h.Parent=_b _27(_h,4)_h.MouseButton1Click:Connect(function()_24(_c)end)local _i=Instance.new("TextButton")_i.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_i.Position=UDim2.new(0.55,0,1,-_4("Y",29))_i.BackgroundColor3=Color3.fromRGB(40,100,160)_i.BackgroundTransparency=0.2 _i.Text="Save"_i.Font=Enum.Font.GothamBold _i.TextScaled=true _i.TextColor3=Color3.new(1,1,1)_i.Parent=_b _27(_i,4)_i.MouseButton1Click:Connect(function()local _j=false for _k,_l in ipairs(_19)do if _l.Id==_a.Id 
then _j=true break end end if not _j then local _m=GetReal(_c)table.insert(_19,{Id=_a.Id,AssetId=_c,Name=_a.Name or "Unknown",AnimationId="rbxassetid://"..tostring(_m or _c),Favorite=false})_22()_i.Text="Saved!"_i.BackgroundColor3=Color3.fromRGB(0,160,100)task.wait(1)_i.Text="Save"_i.BackgroundColor3=Color3.fromRGB(40,100,160)else _i.Text="Already"task.wait(0.7)_i.Text="Save"end end)_29(_b)return _b end
local _64=Instance.new("ScrollingFrame")_64.Size=UDim2.new(1,-_4("X",16),1,-_4("Y",100))_64.Position=UDim2.new(0,_4("X",8),0,_4("Y",36))_64.CanvasSize=UDim2.new(0,0,0,0)_64.ScrollBarThickness=6 _64.ScrollBarImageColor3=Color3.fromRGB(100,100,140)_64.BackgroundTransparency=1 _64.Parent=_39
local _65=Instance.new("UIGridLayout",_64)_65.CellSize=UDim2.new(0,_4("X",120),0,_4("Y",180))_65.CellPadding=UDim2.new(0,_4("X",8),0,_4("Y",8))
local _66=Instance.new("TextLabel",_64)_66.Size=UDim2.new(1,0,0,_4("Y",36))_66.Position=UDim2.new(0,0,0.5,-_4("Y",18))_66.BackgroundTransparency=1 _66.Text="Nothing Silly Here :3 (except me)"_66.TextColor3=Color3.new(1,1,1)_66.Font=Enum.Font.GothamBold _66.TextScaled=true _66.Visible=false
local _67=Instance.new("TextButton",_39)_67.Size=UDim2.new(0.4,-_4("X",6),0,_4("Y",32))_67.Position=UDim2.new(0,_4("X",4),1,-_4("Y",36))_67.BackgroundColor3=Color3.fromRGB(50,50,70)_67.BackgroundTransparency=0.2 _67.Text="< Prev"_67.Font=Enum.Font.GothamBold _67.TextScaled=true _67.TextColor3=Color3.new(1,1,1)_27(_67,6)
local _68=Instance.new("TextButton",_39)_68.Size=UDim2.new(0.4,-_4("X",6),0,_4("Y",32))_68.Position=UDim2.new(0.6,_4("X",2),1,-_4("Y",36))_68.BackgroundColor3=Color3.fromRGB(50,50,70)_68.BackgroundTransparency=0.2 _68.Text="Next >"_68.Font=Enum.Font.GothamBold _68.TextScaled=true _68.TextColor3=Color3.new(1,1,1)_27(_68,6)
local _69=Instance.new("TextBox",_39)_69.Size=UDim2.new(0.2,0,0,_4("Y",32))_69.Position=UDim2.new(0.4,_4("X",2),1,-_4("Y",36))_69.BackgroundTransparency=1 _69.Font=Enum.Font.Gotham _69.TextScaled=true _69.TextColor3=Color3.new(1,1,1)_69.Text="1 / Enter page"
local _70=Instance.new("TextLabel",_39)_70.Size=UDim2.new(0.3,0,0,_4("Y",24))_70.Position=UDim2.new(0.35,0,1,-_4("Y",68))_70.BackgroundTransparency=1 _70.TextColor3=Color3.fromRGB(255,100,100)_70.Font=Enum.Font.Gotham _70.TextScaled=true _70.Text=""_70.Visible=false
local function _71()_67.Visible=(_61>1)if _60 and typeof(_60.IsFinished)=="boolean"then _68.Visible=not _60.IsFinished else _68.Visible=true end end

local _73_id=0
local function _73(_a)
    _73_id=_73_id+1
    local _myId=_73_id
    _69.Text="Loading..."
    for _b,_c in ipairs(_64:GetChildren()) do if _c:IsA("Frame") then _c:Destroy() end end 
    local _d=nil 
    local _e,_f=pcall(function() return _a:GetCurrentPage() end)
    if _e then _d=_f else _69.Text="ERROR" return end 
    if _myId~=_73_id then return end
    if _d and #_d>0 then 
        _66.Visible=false 
        local _myTAB=_TAB 
        local _count=0
        for _g,_h in ipairs(_d) do 
            if _TAB~=_myTAB or _myId~=_73_id then break end 
            _63(_h).Parent=_64 
            _count=_count+1
            if _count%2==0 then _9.RenderStepped:Wait() end
        end 
    else 
        _66.Visible=true 
    end 
    if _myId==_73_id then
        _64.CanvasSize=UDim2.new(0,0,0,_65.AbsoluteContentSize.Y+8)
        _69.Text=tostring(_61).." / Enter page"
        _71()
    end
end

local function _74(_a)local _b=_62(_59)if not _b then return nil end for _c=2,_a do if _b.IsFinished then break end local _d,_e=pcall(function()_b:AdvanceToNextPageAsync()end)if not _d then break end end return _b end
local function _75(_a)_59=_a or ""_61=1 _69.Text="Loading..."_60=_62(_59)if _60 then _73(_60)end end
_41.MouseButton1Click:Connect(function()_75(_40.Text)end)_40.FocusLost:Connect(function(_a)if _a then _75(_40.Text)end end)_42.MouseButton1Click:Connect(function()_58=_58%#_57+1 _42.Text="Sort: ".._57[_58][2]_75(_59)end)
local function _76()if not _60 or _60.IsFinished then return end local _a,_b=pcall(function()_60:AdvanceToNextPageAsync()end)if _a then _61+=1 _73(_60)else local _c=_61+1 local _d=_74(_c)if _d then _60=_d _61=math.min(_c,_61+1)_73(_60)end end end
local function _77()if not _60 or _61<=1 then return end local _a,_b=pcall(function()_60:AdvanceToPreviousPageAsync()end)if _a 
then _61=math.max(1,_61-1)_73(_60)else local _c=math.max(1,_61-1)local _d=_74(_c)if _d then _60=_d _61=_c _73(_60)end end end
_68.MouseButton1Click:Connect(_76)_67.MouseButton1Click:Connect(_77)
_10.InputBegan:Connect(function(_a,_b)if _b then return end if _a.UserInputType==Enum.UserInputType.Keyboard and _a.KeyCode==Enum.KeyCode.Right then _76()elseif _a.KeyCode==Enum.KeyCode.Left then _77()end end)
_69.FocusLost:Connect(function(_a)if not _a then return end local _b=_69.Text:gsub("%s+","")local _c=tonumber(_b:match("%d+"))if not _c or _c<1 then _70.Text="Invalid page number"_70.Visible=true task.delay(2,function()if _70 then _70.Visible=false end end)_69.Text="Page "..tostring(_61)return end local _d=math.floor(_c)if _d==_61 then _69.Text="Page "..tostring(_61)return end _69.Text="Loading..."local _e,_f=pcall(function()return _74(_d)end)if not _e or not _f then _70.Text="Unable to fetch page"_70.Visible=true task.delay(2,function()if _70 then _70.Visible=false end end)_69.Text="Page "..tostring(_61)return end _60=_f _61=math.max(1,_d)_73(_60)end)
local function _78(_a)local _b=Instance.new("Frame")_b.Size=UDim2.new(0,_4("X",120),0,_4("Y",200))_b.BackgroundColor3=Color3.fromRGB(25,25,35)_b.BackgroundTransparency=0.2 _27(_b,8)_28(_b,Color3.fromRGB(60,60,90),1)local _c=Instance.new("ImageLabel")_c.Size=UDim2.new(1,-_4("X",10),0,_4("Y",90))_c.Position=UDim2.new(0,_4("X",5),0,_4("Y",5))_c.BackgroundTransparency=1 _c.ScaleType=Enum.ScaleType.Fit _c.Image="rbxthumb://type=Asset&id=11768914234&w=150&h=150"_c.Parent=_b _27(_c,4)local _d=Instance.new("TextLabel")_d.Size=UDim2.new(1,-_4("X",10),0,_4("Y",28))_d.Position=UDim2.new(0,_4("X",5),0,_4("Y",100))_d.BackgroundTransparency=1 _d.Text=_a.Name or "Unknown"_d.TextScaled=true _d.TextWrapped=true _d.Font=Enum.Font.GothamBold _d.TextColor3=Color3.new(1,1,1)_d.Parent=_b local _e=Instance.new("TextButton")_e.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_e.Position=UDim2.new(0,_4("X",5),1,-_4("Y",29))_e.BackgroundColor3=Color3.fromRGB(40,140,80)_e.BackgroundTransparency=0.2 _e.Text="Play"_e.Font=Enum.Font.GothamBold _e.TextScaled=true _e.TextColor3=Color3.new(1,1,1)_e.Parent=_b 
_27(_e,4)_e.MouseButton1Click:Connect(function()_24(_a.Id)end)local _f=Instance.new("TextButton")_f.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_f.Position=UDim2.new(0.55,0,1,-_4("Y",29))_f.BackgroundColor3=Color3.fromRGB(160,50,50)_f.BackgroundTransparency=0.2 _f.Text="Remove"_f.Font=Enum.Font.GothamBold _f.TextScaled=true _f.TextColor3=Color3.new(1,1,1)_f.Parent=_b _27(_f,4)local _g=Instance.new("TextButton")_g.Size=UDim2.new(0,_4("X",40),0,_4("Y",24))_g.Position=UDim2.new(0.5,-_4("X",20),0,_4("Y",5))_g.BackgroundColor3=Color3.fromRGB(50,50,80)_g.BackgroundTransparency=0.2 _g.Text="Copy AnimId"_g.Font=Enum.Font.GothamBold _g.TextScaled=true _g.TextColor3=Color3.new(1,1,1)_g.Parent=_b _27(_g,4)_g.MouseButton1Click:Connect(function()if setclipboard then setclipboard(_a.AnimationId:gsub("rbxassetid://",""))end _g.Text="Copied!"task.wait(0.7)_g.Text="Copy AnimId"end)local _h=Instance.new("TextButton")_h.Size=UDim2.new(0,_4("X",24),0,_4("Y",24))_h.Position=UDim2.new(1,-_4("X",30),0,_4("Y",5))_h.Text=_a.Favorite and "★"or "☆"_h.Font=Enum.Font.GothamBold _h.TextScaled=true _h.TextColor3=Color3.fromRGB(255,220,50)_h.BackgroundTransparency=1 _h.Parent=_b _h.MouseButton1Click:Connect(function()_a.Favorite=not _a.Favorite _h.Text=_a.Favorite and "★"or "☆"_22()_80()end)_f.MouseButton1Click:Connect(function()for _i,_j in ipairs(_19)do if _j.Id==_a.Id then table.remove(_19,_i)_22()_80()break end end end)_29(_b)return _b end

local _80_id=0
function _80()
    _80_id=_80_id+1
    local _myId=_80_id
    for _a,_b in ipairs(_45:GetChildren())do if _b:IsA("Frame")then _b:Destroy()end end 
    local _c=(_44.Text or ""):lower()
    local _d={} 
    for _e,_f in ipairs(_19) do 
        if _c=="" or (_f.Name and _f.Name:lower():find(_c)) then table.insert(_d,_f) end 
    end 
    table.sort(_d,function(_g,_h)if _g.Favorite~=_h.Favorite then return _g.Favorite else return false end end)
    if #_d>0 then 
        _46.Visible=false 
        local _myTAB=_TAB 
        local _count=0
        for _i,_j in ipairs(_d) do 
            if _TAB~=_myTAB or _myId~=_80_id then break end 
            _78(_j).Parent=_45 
            _count=_count+1
            if _count%25==0 then _9.RenderStepped:Wait() end 
        end 
    else 
        _46.Visible=true 
    end 
    if _myId==_80_id then
        _45.CanvasSize=UDim2.new(0,0,0,_47.AbsoluteContentSize.Y+8)
    end
end

_36.MouseButton1Click:Connect(function()_TAB+=1 _39.Visible=true _43.Visible=false _36.BackgroundColor3=Color3.fromRGB(30,30,80)_37.BackgroundColor3=Color3.fromRGB(20,50,20)end)
_44:GetPropertyChangedSignal("Text"):Connect(_80)
_37.MouseButton1Click:Connect(function()_TAB+=1 _39.Visible=false _43.Visible=true 
_36.BackgroundColor3=Color3.fromRGB(20,20,40)_37.BackgroundColor3=Color3.fromRGB(30,80,30)_80()end)
_75("")local _79=_26 local function _81()_79.Enabled=not _79.Enabled end local _82=Instance.new("ScreenGui")_82.Name="ToggleButtonGui"_82.ResetOnSpawn=false _82.Parent=_25 _82.Enabled=true local _83=Instance.new("TextButton")_83.Parent=_82 _83.Text="G"_83.Font=Enum.Font.GothamSemibold _83.TextScaled=true _83.Size=UDim2.new(0,50,0,50)_83.Position=UDim2.new(0,20,0.5,-50)_83.AnchorPoint=Vector2.new(0,0.5)_83.BackgroundColor3=Color3.fromRGB(25,25,35)_83.BackgroundTransparency=0.2 _83.TextColor3=Color3.new(1,1,1)_83.Active=true pcall(function()_83.Draggable=true end)_27(_83,12)_28(_83,Color3.fromRGB(60,60,100),2)local _84=Instance.new("UIAspectRatioConstraint")_84.Parent=_83 _84.AspectRatio=1 _83.MouseButton1Click:Connect(_81)_10.InputBegan:Connect(function(_a,_b)if _b then return end if _a.UserInputType==Enum.UserInputType.Keyboard and _a.KeyCode==Enum.KeyCode.G then _81()end end)_26.Enabled=true _80()





task.spawn(function()
	local RunService = game:GetService("RunService")
	local Players = game.Players
	local player = Players.LocalPlayer

	local function setupCollision(character)
		local hrp = character:WaitForChild("HumanoidRootPart")
		local bodyParts = {}

		hrp.CanCollide = true

		local function addPart(part)
			if part:IsA("BasePart") and part ~= hrp then
				table.insert(bodyParts, part)
			end
		end

		for _, part in pairs(character:GetDescendants()) do
			addPart(part)
		end

		local descendantConnection = character.DescendantAdded:Connect(addPart)

		local heartbeatConnection
		heartbeatConnection = RunService.Heartbeat:Connect(function()
			if not character or not character.Parent then
				heartbeatConnection:Disconnect()
				descendantConnection:Disconnect()
				return
			end

			for i = 1, #bodyParts do
				local p = bodyParts[i]
				if p and p.Parent then
					p.CanCollide = false
				end
			end
		end)
	end

	if player.Character then
		setupCollision(player.Character)
	end

	player.CharacterAdded:Connect(setupCollision)
end)
