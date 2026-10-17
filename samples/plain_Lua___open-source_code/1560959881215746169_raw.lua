local _savedAntiCrasherPreference=_G.__ZeyHubbAntiCrasherEnabled==true if type(_G.__ZeyHubbStopAntiCrasherRuntime)=="function"then pcall(_G.__ZeyHubbStopAntiCrasherRuntime,true)end _G.__ZeyHubbAntiCrasherEnabled=_savedAntiCrasherPreference if _G.RivalHubRunning then warn("[ZeyHubb.vs] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")end _G.RivalHubRunning=false _G.__RivalHubMainOriginalPos=nil local Players=game:GetService("Players")local RunService=game:GetService("RunService")local UIS=game:GetService("UserInputService")local TS=game:GetService("TweenService")local Lighting=game:GetService("Lighting")local HS=game:GetService("HttpService")local ReplicatedStorage=game:GetService("ReplicatedStorage")local Workspace=game:GetService("Workspace")local LP=Players.LocalPlayer if not LP then local _lpConn _lpConn=Players.PlayerAdded:Connect(function(p)LP=p end)local _t0=tick()while not LP and tick()-_t0<15 do task.wait(0.1)end if _lpConn then _lpConn:Disconnect()end end if not LP then warn("[ZeyHubb.vs] LocalPlayer no disponible en 15s. Abortando.")return end local pgui=LP:WaitForChild("PlayerGui",20)if not pgui then warn("[ZeyHubb.vs] PlayerGui no cargó en 20s. Abortando.")return end local camera=Workspace.CurrentCamera _G.RivalHubRunning=true _G.RivalHubSession=(_G.RivalHubSession or 0)+1 local _mySession=_G.RivalHubSession local RIVALHUB_LANGUAGE="en"local RIVALHUB_TRANSLATIONS={es={["RESET ALL SETTINGS"]="RESTABLECER TODO",["SETTINGS RESET"]="AJUSTES RESTABLECIDOS",["CONFIRM?"]="¿CONFIRMAR?",["ERROR"]="ERROR",["RESET"]="RESTABLECER",["Keybinds"]="TECLAS",["Carry Mode"]="MODO CARGAR",["Lagger Mode"]="MODO LAG",["Auto Left"]="AUTO IZQUIERDA",["Auto Right"]="AUTO DERECHA",["Auto Bat"]="AUTO BATE",["TP Down"]="TP ABAJO",["Drop Brainrot"]="SOLTAR BRAINROT",["Hide GUI"]="OCULTAR MENÚ",["Normal Speed"]="VELOCIDAD NORMAL",["Carry Speed"]="VELOCIDAD CARGAR",["Current Mode"]="MODO ACTUAL",["ACTIVATE"]="ACTIVAR"},pt={["RESET ALL SETTINGS"]="REDEFINIR TUDO",["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS",["CONFIRM?"]="CONFIRMAR?",["ERROR"]="ERRO",["RESET"]="REDEFINIR",["Keybinds"]="TECLAS",["Carry Mode"]="MODO CARREGAR",["Auto Left"]="AUTO ESQUERDA",["Auto Right"]="AUTO DIREITA",["Hide GUI"]="OCULTAR MENU",["Normal Speed"]="VELOCIDADE NORMAL",["Carry Speed"]="VELOCIDADE CARREGAR",["ACTIVATE"]="ATIVAR"},fr={["RESET ALL SETTINGS"]="RÉINITIALISER",["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS",["CONFIRM?"]="CONFIRMER ?",["ERROR"]="ERREUR",["RESET"]="RÉINITIALISER",["Keybinds"]="RACCOURCIS",["Carry Mode"]="MODE PORTER",["Auto Left"]="AUTO GAUCHE",["Auto Right"]="AUTO DROITE",["Hide GUI"]="MASQUER LE MENU",["Normal Speed"]="VITESSE NORMALE",["Carry Speed"]="VITESSE PORTER",["ACTIVATE"]="ACTIVER"},de={["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN",["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT",["CONFIRM?"]="BESTÄTIGEN?",["ERROR"]="FEHLER",["RESET"]="ZURÜCKSETZEN",["Keybinds"]="TASTEN",["Carry Mode"]="TRAGEMODUS",["Auto Left"]="AUTO LINKS",["Auto Right"]="AUTO RECHTS",["Hide GUI"]="MENÜ AUSBLENDEN",["Normal Speed"]="NORMALE GESCHWINDIGKEIT",["Carry Speed"]="TRAGEGESCHWINDIGKEIT",["ACTIVATE"]="AKTIVIEREN"},}local function localizeRivalHubInterface(root)local dictionary=RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]if not dictionary or not root then return end for _,object in ipairs(root:GetDescendants())do if object:IsA("TextLabel")or object:IsA("TextButton")then local source=object:GetAttribute("RivalHubSourceText")or object.Text object:SetAttribute("RivalHubSourceText",source)local translated=dictionary[source]if translated then object.Text=translated end end end end local function rivalHubTranslate(source)local dictionary=RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]return(dictionary and dictionary[source])or source end local _tick=tick local _clamp=math.clamp local _floor=math.floor local _abs=math.abs local _huge=math.huge local _sqrt=math.sqrt local _V3new=Vector3.new local _V3zero=Vector3.zero local _CFnew=CFrame.new local _CFlookAt=CFrame.lookAt local _RayParams_new=RaycastParams.new local _GetPlayersCached do local cache,cacheTime=nil,0 _GetPlayersCached=function()local now=_tick()if cache and now-cacheTime<0.03 then return cache end cache=Players:GetPlayers()cacheTime=now return cache end end local function waitForCharReady(char,timeout)timeout=timeout or 5 local deadline=_tick()+timeout while(not char)or(not char.Parent)or(not char:FindFirstChild("HumanoidRootPart"))or(not char:FindFirstChildOfClass("Humanoid"))do if _tick()>deadline then return false end task.wait(0.05)end return true end NS=60 CS=29 LAGGER_SPEED=15 LAGGER_CARRY_SPEED=24.5 MEDUSA_COOLDOWN=25 BAT_AIMBOT_SPEED=58 BYPASS_AIMBOT_SPEED=60 local State={bypassBatEnabled=false,bypassBatSpeed=BYPASS_AIMBOT_SPEED,}_G.__ZeyHubbBypassBatVersion=_G.__ZeyHubbBypassBatVersion or"v1"_G.__ZeyHubbIntroSongVersion=_G.__ZeyHubbIntroSongVersion or"v1"CONFIG_FILE="RivalHub_"..tostring(LP.UserId)..".json"BAT_V2_HIT_DIST=4.5 _isDraggingButton=false backgroundIndex=1 backgroundImages={"118241258424065","137090941888778","106638406471484","126843729942853","132235750206658",}backgroundImageTransparency=0 backgroundMode="Background 1"backgroundSelectorLabel=nil miniBackgroundImage=nil floatingButtonScale=1 floatingButtonStyle="V2" floatingButtonShape="V1" stealBarScale=1 _floatingUIScales={}TPBatState=TPBatState or{enabled=false,connection=nil,hitCooldown=false,antiDieConnections={},lockedTarget=nil,version="v1",}TPBatState.enabled=false TPBatState.version=TPBatState.version or"v1";_G.__ZeyHubbTPBatVersion=_G.__ZeyHubbTPBatVersion or"v1" _bgAssetCache=_bgAssetCache or{}_bgAssetPending=_bgAssetPending or{}_bgAssetOk=_bgAssetOk or{}function _bgLoads(url)local good=false local img=Instance.new("ImageLabel")img.Image=url pcall(function()game:GetService("ContentProvider"):PreloadAsync({img},function(_,status)if status==Enum.AssetFetchStatus.Success then good=true end end)end)local t=0 while not img.IsLoaded and t<8 do task.wait(0.1);t=t+0.1 end local loaded=img.IsLoaded pcall(function()img:Destroy()end)return good and loaded end function _bgHttpGet(url)local ok,res=pcall(function()return game:HttpGet(url)end)if ok and type(res)=="string"and#res>0 then return res end local req=(syn and syn.request)or(http and http.request)or http_request or request if req then local ok2,r=pcall(req,{Url=url,Method="GET"})if ok2 and r and(r.Success or r.StatusCode==200)and type(r.Body)=="string"and#r.Body>0 then return r.Body end end return nil end function _bgDownloadThumb(id)local getAsset=getcustomasset or getsynasset if not(writefile and getAsset)then return nil end local HttpService=game:GetService("HttpService")local imageUrl for attempt=1,4 do local body=_bgHttpGet("https://thumbnails.roblox.com/v1/assets?assetIds="..id.."&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false")if body then local okJ,data=pcall(function()return HttpService:JSONDecode(body)end)local item=okJ and data and data.data and data.data[1]if item and item.imageUrl and item.imageUrl~=""and item.state=="Completed"then imageUrl=item.imageUrl break end end task.wait(1)end if not imageUrl then return nil end local bytes=_bgHttpGet(imageUrl)if not bytes or#bytes<100 then return nil end local path="RivalHub_bg_"..id..".png"local okW=pcall(writefile,path,bytes)if not okW then return nil end local okA,asset=pcall(getAsset,path)if okA and asset and asset~=""then return asset end return nil end function _bgAsset(id)if id==nil then return""end id=tostring(id)local raw="rbxassetid://"..id local cached=_bgAssetCache[id]if cached then return cached end if not _bgAssetPending[id]then _bgAssetPending[id]=true task.spawn(function()local candidates={}local ok,objs=pcall(function()return game:GetObjects(raw)end)if ok and type(objs)=="table"and objs[1]then local item=objs[1]local found local function pick(o)if o:IsA("Decal")or o:IsA("Texture")then return o.Texture end if o:IsA("ImageLabel")or o:IsA("ImageButton")then return o.Image end return nil end found=pick(item)if not found or found==""then for _,d in ipairs(item:GetDescendants())do local t=pick(d)if t and t~=""then found=t;break end end end if found and found~=""then table.insert(candidates,found)end for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end end if#candidates==0 then pcall(function()local body=game:HttpGet("https://assetdelivery.roblox.com/v2/assetId/"..id)local data=game:GetService("HttpService"):JSONDecode(body)local loc=data and data.locations and data.locations[1]and data.locations[1].location if data and data.assetTypeId==13 and loc then local xml=game:HttpGet(loc)local texId=xml:match("rbxassetid://(%d+)")or xml:match("asset/%?id=(%d+)")or xml:match("id=(%d+)")if texId then table.insert(candidates,"rbxassetid://"..texId)end end end)end table.insert(candidates,raw)table.insert(candidates,"rbxthumb://type=Asset&id="..id.."&w=420&h=420")table.insert(candidates,"http://www.roblox.com/asset/?id="..id)local resolved,loadedOk=raw,false for attempt=1,2 do for _,c in ipairs(candidates)do if _bgLoads(c)then resolved=c;loadedOk=true;break end end if loadedOk then break end task.wait(1)end if not loadedOk then local okD,custom=pcall(_bgDownloadThumb,id)if okD and custom then resolved=custom;loadedOk=true end end if not loadedOk then warn("[ZeyHubb.vs] La imagen de fondo "..id.." no carga (privada, sin aprobar o no es una imagen).")end _bgAssetCache[id]=resolved _bgAssetOk[id]=loadedOk _bgAssetPending[id]=nil if applyBackgroundMode then pcall(applyBackgroundMode,backgroundMode)end end)end return raw end function applyBackgroundMode(mode)if mode=="None"or#backgroundImages==0 then backgroundMode="None"else local n=tonumber(string.match(tostring(mode),"^Background%s+(%d+)$"))if not n or n<1 or n>#backgroundImages then n=backgroundIndex end backgroundIndex=_clamp(n,1,#backgroundImages)backgroundMode="Background "..backgroundIndex end if main then main.BackgroundColor3=Color3.fromRGB(0,0,0)local _curBgId=tostring(backgroundImages[backgroundIndex])main.BackgroundTransparency=(backgroundMode=="None")and 0 or 1 local bgImage=main:FindFirstChild("BackgroundImage")if bgImage then bgImage.Image=_bgAsset(backgroundImages[backgroundIndex])bgImage.ImageTransparency=backgroundMode=="None"and 1 or backgroundImageTransparency end end if miniBackgroundImage then miniBackgroundImage.Image=_bgAsset(backgroundImages[backgroundIndex])miniBackgroundImage.ImageTransparency=backgroundMode=="None"and 1 or math.clamp(backgroundImageTransparency+0.25,0,1)end if backgroundSelectorLabel then backgroundSelectorLabel.Text=backgroundMode end end task.spawn(function()for i=1,#backgroundImages do pcall(_bgAsset,backgroundImages[i])end end)local COLOR_THEMES={["Orange"]=Color3.fromRGB(255,150,40),["Amber"]=Color3.fromRGB(255,190,70),["Gold"]=Color3.fromRGB(255,215,100),["White"]=Color3.fromRGB(245,245,250),["Gray"]=Color3.fromRGB(170,170,170),}RIVAL_TITLE_THEMES={["Orange"]={color=Color3.fromRGB(255,130,20),stroke=nil},["White"]={color=Color3.fromRGB(255,255,255),stroke=nil},["Black"]={color=Color3.fromRGB(0,0,0),stroke=Color3.fromRGB(255,255,255)},["Silver"]={color=Color3.fromRGB(192,197,206),stroke=nil},}currentRivalTitleTheme="Orange"scriptLogoRef=nil rivalTitleSelectorLabel=nil function applyRivalTitleTheme(themeName,noSave)local t=RIVAL_TITLE_THEMES[themeName]if not t then return end currentRivalTitleTheme=themeName if scriptLogoRef and scriptLogoRef.Parent then scriptLogoRef.TextColor3=t.color or Color3.fromRGB(255,230,160)local glow=scriptLogoRef:FindFirstChild("TitleGlow")if glow and glow:IsA("UIStroke")then glow.Color=t.stroke or Color3.fromRGB(255,160,40)end if t.stroke then scriptLogoRef.TextStrokeColor3=t.stroke scriptLogoRef.TextStrokeTransparency=0.5 else scriptLogoRef.TextStrokeTransparency=1 end local shine=scriptLogoRef:FindFirstChild("TitleShine")if not shine then shine=Instance.new("UIGradient",scriptLogoRef)shine.Name="TitleShine"shine.Rotation=0 end local base=t.color or Color3.fromRGB(255,180,60)shine.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,245)),ColorSequenceKeypoint.new(0.30,base:Lerp(Color3.new(1,1,1),0.35)),ColorSequenceKeypoint.new(0.55,base),ColorSequenceKeypoint.new(0.80,base:Lerp(Color3.new(1,1,1),0.2)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,245,200)),})end if rivalTitleSelectorLabel then rivalTitleSelectorLabel.Text=themeName end if not noSave and saveAllSettings then pcall(saveAllSettings)end end currentColorTheme="Orange"selectedColor=COLOR_THEMES["Orange"]function getThemeColor()return selectedColor end ESP_ORANGE=Color3.fromRGB(255,130,20)function rivalHubGradient(c)return ColorSequence.new({ColorSequenceKeypoint.new(0.00,c:Lerp(Color3.new(1,1,1),0.55)),ColorSequenceKeypoint.new(0.45,c),ColorSequenceKeypoint.new(1.00,c:Lerp(Color3.new(0,0,0),0.35)),})end function rivalHubGradientSoft(c)return ColorSequence.new({ColorSequenceKeypoint.new(0.00,c:Lerp(Color3.new(1,1,1),0.75)),ColorSequenceKeypoint.new(0.50,c:Lerp(Color3.new(1,1,1),0.25)),ColorSequenceKeypoint.new(1.00,c:Lerp(Color3.new(0,0,0),0.15)),})end function rivalHubGradientDark(c)return ColorSequence.new({ColorSequenceKeypoint.new(0.00,c:Lerp(Color3.fromRGB(0,0,0),0.35)),ColorSequenceKeypoint.new(0.55,c:Lerp(Color3.fromRGB(0,0,0),0.65)),ColorSequenceKeypoint.new(1.00,c:Lerp(Color3.fromRGB(0,0,0),0.80)),})end function applyRivalHubGradientToLabel(label,c)if not label then return end local grad=label:FindFirstChildOfClass("UIGradient")if not grad then grad=Instance.new("UIGradient",label)end grad.Rotation=0 grad.Color=rivalHubGradient(c)end local _lastThemeUpdate=0 local _lastThemeColor=nil function applyColorTheme(themeName)local color=COLOR_THEMES[themeName]if not color then return end currentColorTheme=themeName selectedColor=color updateAllUIThemeColors(color)saveAllSettings()end _uicStroke=nil _uicAvatarStroke=nil _uicHandle=nil _uicLine=nil function updateAllUIThemeColors(color)local now=_tick()if color==_lastThemeColor and now-_lastThemeUpdate<0.1 then return end _lastThemeUpdate=now _lastThemeColor=color if pbFrame then local border=pbFrame:FindFirstChild("OuterStroke")if border then border.Color=Color3.fromRGB(255,205,100)end local fpsNeon=pbFrame:FindFirstChild("FPSNeon",true)if fpsNeon then fpsNeon.TextColor3=color end local pingNeon=pbFrame:FindFirstChild("PingNeon",true)if pingNeon then pingNeon.TextColor3=color end local divider=pbFrame:FindFirstChild("Divider",true)if divider and divider:IsA("Frame")then divider.BackgroundColor3=color end pbFrame.BackgroundColor3=Color3.fromRGB(0,0,0)pbFrame.BackgroundTransparency=0 end if _uicStroke then _uicStroke.Color=color end if _uicAvatarStroke then _uicAvatarStroke.Color=color end if _uicHandle then _uicHandle.TextColor3=color end if _uicLine then _uicLine.BackgroundColor3=color end local function searchAndUpdateText(parent)for _,child in ipairs(parent:GetDescendants())do if child:IsA("TextLabel")then if child.Name=="DiscordText"then child.TextColor3=color local grad=child:FindFirstChildOfClass("UIGradient")if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,color),ColorSequenceKeypoint.new(0.30,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.70,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(1.00,color),})end elseif child.Name=="SpeedLabel"then local orange=Color3.fromRGB(255,140,30)local silver=Color3.fromRGB(240,245,255)child.TextColor3=orange local grad=child:FindFirstChildOfClass("UIGradient")if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,orange),ColorSequenceKeypoint.new(0.30,silver),ColorSequenceKeypoint.new(0.50,orange),ColorSequenceKeypoint.new(0.70,silver),ColorSequenceKeypoint.new(1.00,orange),})end end end if child:IsA("UIStroke")then if child.Color==Color3.fromRGB(180,180,190)then child.Color=color end end end end if gui then searchAndUpdateText(gui)end for _,tab in ipairs(tabButtons or{})do local isActive=tab:FindFirstChild("Underline")and tab.Underline.Visible if isActive then tab.TextColor3=Color3.fromRGB(245,245,255)tab.BackgroundColor3=color tab.BackgroundTransparency=0.15 local tg=tab:FindFirstChild("TabBgGrad")if tg then tg.Color=rivalHubGradient(color)end else tab.TextColor3=Color3.fromRGB(150,150,165)tab.BackgroundColor3=Color3.fromRGB(26,26,34)tab.BackgroundTransparency=1 end local ul=tab:FindFirstChild("Underline")if ul then ul.BackgroundColor3=color end local s=tab:FindFirstChild("TabStroke")if s then s.Color=color end end if _G.__RivalHubRefreshESPTheme then pcall(_G.__RivalHubRefreshESPTheme,color)end if main then local titleFrame=main:FindFirstChild("Frame")if titleFrame then for _,child in ipairs(titleFrame:GetDescendants())do if child:IsA("UIStroke")and child.Color==Color3.fromRGB(180,180,190)then child.Color=color end end end end if colorSelectorLabel then colorSelectorLabel.Text=currentColorTheme colorSelectorLabel.TextColor3=color end if _G._rivalHubStealSlide then _G._rivalHubStealSlide.BackgroundColor3=color local sg=_G._rivalHubStealSlide:FindFirstChildOfClass("UIGradient")if sg then sg.Color=rivalHubGradient(color)end local ss=_G._rivalHubStealSlide:FindFirstChildOfClass("UIStroke")if ss then ss.Color=color end end if miniBtn then local stroke=miniBtn:FindFirstChildOfClass("UIStroke")if stroke then stroke.Color=Color3.fromRGB(255,150,40)stroke.Transparency=0.05 end local rim=miniBtn:FindFirstChild("Rim")if rim then local rimStroke=rim:FindFirstChildOfClass("UIStroke")if rimStroke then rimStroke.Color=Color3.fromRGB(255,150,40)rimStroke.Transparency=0.05 end end end if MobilePanel then for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")and btn:FindFirstChild("BtnGrad")then paintFloatingBtn(btn,btn:GetAttribute("MobActive")==true)end end end end local HOMERO_CFG={body={10725826963,86500008,86500054,86500036,86500064,86500078},aplicarCuerpo=true,items={{id=103227700418,offset=_CFnew(0,0,0)},{id=84952305140948,offset=_CFnew(0,0,0)},{id=122465238537030,offset=_CFnew(0,0,0)},},shirt=nil,pants="rbxassetid://78591690208112",skinColor=Color3.fromRGB(234,184,146),headColor=Color3.fromRGB(0,0,0),}local TAG="LocalOutfit_"local function loadObjects(id)local ok,res=pcall(function()return game:GetObjects("rbxassetid://"..tostring(id))end)if ok and typeof(res)=="table"and#res>0 then return res end ok,res=pcall(function()return game:GetService("InsertService"):LoadAsset(id)end)if ok and res then return{res}end return nil end local function collectParts(objs)local out={}for _,o in ipairs(objs)do if o:IsA("BasePart")then out[#out+1]=o end for _,d in ipairs(o:GetDescendants())do if d:IsA("BasePart")then out[#out+1]=d end end end return out end local function findAtt(char,name)for _,p in ipairs(char:GetDescendants())do if p:IsA("Attachment")and p.Name==name and p.Parent:IsA("BasePart")then return p end end end local function applyBody(char)local total=0 for _,id in ipairs(HOMERO_CFG.body)do local objs=loadObjects(id)if objs then for _,mp in ipairs(collectParts(objs))do local orig=char:FindFirstChild(mp.Name)if orig and orig:IsA("BasePart")then local c=mp:Clone()c.Name=TAG.."body_"..mp.Name c.CanCollide=false c.Anchored=false c.Massless=true c.Size=orig.Size c.CFrame=orig.CFrame c.Parent=char local w=Instance.new("WeldConstraint")w.Part0=orig w.Part1=c w.Parent=c if orig:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then orig:SetAttribute("RivalHubOutfitOriginalTransparency",orig.Transparency)end orig.Transparency=1 total=total+1 end end for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end end end return total end local function attachItem(char,entry)local objs=loadObjects(entry.id)if not objs then return false end local handle for _,p in ipairs(collectParts(objs))do if p.Name=="Handle"then handle=p;break end if not handle then handle=p end end if not handle then for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end return false end local H=handle:Clone()for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end H.Name=TAG.."item_"..tostring(entry.id)H.CanCollide=false H.Anchored=false H.Massless=true local wrap=H:FindFirstChildWhichIsA("WrapLayer")local target,c0,c1 if wrap then target=char:FindFirstChild("UpperTorso")or char:FindFirstChild("Torso")or char:FindFirstChild("HumanoidRootPart")c0=entry.offset or _CFnew()c1=_CFnew()else local hAtt=H:FindFirstChildOfClass("Attachment")local bAtt=hAtt and findAtt(char,hAtt.Name)if bAtt then target=bAtt.Parent c0=bAtt.CFrame*(entry.offset or _CFnew())c1=hAtt.CFrame else target=char:FindFirstChild("Head")c0=entry.offset or _CFnew(0,1.4,0)c1=_CFnew()end end if not target then H:Destroy();return false end H.CFrame=target.CFrame*c0*c1:Inverse()H.Parent=char local w=Instance.new("Weld")w.Part0=target w.Part1=H w.C0=c0 w.C1=c1 w.Parent=H return true end function applyHomeroOutfit(char)if not char then char=LP.Character end if not char then return end char:WaitForChild("Humanoid",10)char:WaitForChild("Head",10)task.wait(0.4)for _,d in ipairs(char:GetChildren())do if d.Name:sub(1,#TAG)==TAG then pcall(function()d:Destroy()end)end end if HOMERO_CFG.skinColor then local bc=char:FindFirstChildWhichIsA("BodyColors")or Instance.new("BodyColors")bc.HeadColor3=HOMERO_CFG.headColor or HOMERO_CFG.skinColor bc.TorsoColor3=HOMERO_CFG.skinColor bc.LeftArmColor3,bc.RightArmColor3=HOMERO_CFG.skinColor,HOMERO_CFG.skinColor bc.LeftLegColor3,bc.RightLegColor3=HOMERO_CFG.skinColor,HOMERO_CFG.skinColor bc.Parent=char end for _,a in ipairs(char:GetChildren())do if a:IsA("Accessory")then local h=a:FindFirstChild("Handle")if h then h.Transparency=1 end end end if HOMERO_CFG.shirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.Name="Shirt"s.ShirtTemplate=HOMERO_CFG.shirt s.Parent=char end if HOMERO_CFG.pants then local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.Name="Pants"p.PantsTemplate=HOMERO_CFG.pants p.Parent=char end if HOMERO_CFG.aplicarCuerpo then applyBody(char)end for _,e in ipairs(HOMERO_CFG.items)do attachItem(char,e)end end local _originalAppearance=nil local function captureOriginalAppearance(char)if not char or _originalAppearance then return end local data={bodyColors=nil,shirt=nil,pants=nil,headMesh=nil,headTexture=nil,}local bc=char:FindFirstChildWhichIsA("BodyColors")if bc then data.bodyColors={head=bc.HeadColor3,torso=bc.TorsoColor3,leftArm=bc.LeftArmColor3,rightArm=bc.RightArmColor3,leftLeg=bc.LeftLegColor3,rightLeg=bc.RightLegColor3,}end local sh=char:FindFirstChildWhichIsA("Shirt")if sh then data.shirt=sh.ShirtTemplate end local pa=char:FindFirstChildWhichIsA("Pants")if pa then data.pants=pa.PantsTemplate end local head=char:FindFirstChild("Head")if head then local sm=head:FindFirstChildWhichIsA("SpecialMesh")if sm and sm.MeshType==Enum.MeshType.FileMesh then data.headMesh=sm.MeshId data.headTexture=sm.TextureId end end _originalAppearance=data end local function clearPreviousOutfitAssets(char)if not char then return end do local headForFace=char:FindFirstChild("Head")local f=headForFace and headForFace:FindFirstChild("face")if f then local otr=f:GetAttribute("RivalHubOriginalFaceTransparency")if otr~=nil then pcall(function()f.Transparency=otr end)f:SetAttribute("RivalHubOriginalFaceTransparency",nil)end end end for _,child in ipairs(char:GetChildren())do if child.Name:sub(1,#TAG)==TAG or child.Name=="AuFfitAccessory"or child.Name=="BubbleSkinChanger_Hair"or child.Name=="BubbleSkinChanger_Hat"or child.Name=="Korblox_RightLeg"then pcall(function()child:Destroy()end)elseif child:IsA("CharacterMesh")and child.BodyPart==Enum.BodyPart.Head then pcall(function()child:Destroy()end)end end for _,part in ipairs(char:GetDescendants())do if part:IsA("BasePart")then local originalTransparency=part:GetAttribute("RivalHubOutfitOriginalTransparency")if originalTransparency~=nil then part.Transparency=originalTransparency part:SetAttribute("RivalHubOutfitOriginalTransparency",nil)end local originalLocalTransparency=part:GetAttribute("RivalHubOutfitOriginalLocalTransparency")if originalLocalTransparency~=nil then part.LocalTransparencyModifier=originalLocalTransparency part:SetAttribute("RivalHubOutfitOriginalLocalTransparency",nil)end end end if _originalAppearance and _originalAppearance.bodyColors then local bc=char:FindFirstChildWhichIsA("BodyColors")or Instance.new("BodyColors")local o=_originalAppearance.bodyColors bc.HeadColor3,bc.TorsoColor3=o.head,o.torso bc.LeftArmColor3,bc.RightArmColor3=o.leftArm,o.rightArm bc.LeftLegColor3,bc.RightLegColor3=o.leftLeg,o.rightLeg bc.Parent=char end local head=char:FindFirstChild("Head")if head and head:IsA("MeshPart")and head:GetAttribute("RivalHubOutfitModifiedMeshPart")then pcall(function()head.MeshId=head:GetAttribute("RivalHubOutfitOriginalMeshId")or""head.TextureID=head:GetAttribute("RivalHubOutfitOriginalTextureId")or""end)head:SetAttribute("RivalHubOutfitModifiedMeshPart",nil)head:SetAttribute("RivalHubOutfitOriginalMeshId",nil)head:SetAttribute("RivalHubOutfitOriginalTextureId",nil)elseif head then local specialMesh=head:FindFirstChildWhichIsA("SpecialMesh")if specialMesh and specialMesh:GetAttribute("RivalHubOutfitCreatedMesh")then specialMesh:Destroy()elseif specialMesh and specialMesh:GetAttribute("RivalHubOutfitModifiedMesh")then specialMesh.MeshId=specialMesh:GetAttribute("RivalHubOutfitOriginalMeshId")or""specialMesh.TextureId=specialMesh:GetAttribute("RivalHubOutfitOriginalTextureId")or""specialMesh:SetAttribute("RivalHubOutfitModifiedMesh",nil)specialMesh:SetAttribute("RivalHubOutfitOriginalMeshId",nil)specialMesh:SetAttribute("RivalHubOutfitOriginalTextureId",nil)end end end local function applyNoOutfit(char)if not char then char=LP.Character end if not char then return end for _,d in ipairs(char:GetChildren())do if d.Name:sub(1,#TAG)==TAG then pcall(function()d:Destroy()end)end end local oldAcc=char:FindFirstChild("AuFfitAccessory")if oldAcc then pcall(function()oldAcc:Destroy()end)end local oldKorblox=char:FindFirstChild("Korblox_RightLeg")if oldKorblox then pcall(function()oldKorblox:Destroy()end)end for _,d in ipairs(char:GetChildren())do if d:IsA("CharacterMesh")and d.BodyPart==Enum.BodyPart.Head then pcall(function()d:Destroy()end)end end local head=char:FindFirstChild("Head")if head then head.Transparency=0 head.CanCollide=true head.LocalTransparencyModifier=0 local face=head:FindFirstChild("face")if face then face.Transparency=0 end local sm=head:FindFirstChildWhichIsA("SpecialMesh")if sm then if _originalAppearance and _originalAppearance.headMesh then sm.MeshId=_originalAppearance.headMesh sm.TextureId=_originalAppearance.headTexture or""else pcall(function()sm:Destroy()end)end end end pcall(function()local neck=char:FindFirstChild("Neck")if neck then neck.Enabled=true end end)for _,partName in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local limb=char:FindFirstChild(partName)if limb then limb.Transparency=0 end end if _originalAppearance and _originalAppearance.bodyColors then local bc=char:FindFirstChildWhichIsA("BodyColors")or Instance.new("BodyColors")local o=_originalAppearance.bodyColors bc.HeadColor3=o.head bc.TorsoColor3=o.torso bc.LeftArmColor3=o.leftArm bc.RightArmColor3=o.rightArm bc.LeftLegColor3=o.leftLeg bc.RightLegColor3=o.rightLeg bc.Parent=char end if _originalAppearance and _originalAppearance.shirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.ShirtTemplate=_originalAppearance.shirt s.Parent=char end if _originalAppearance and _originalAppearance.pants then local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.PantsTemplate=_originalAppearance.pants p.Parent=char end for _,a in ipairs(char:GetChildren())do if a:IsA("Accessory")then local h=a:FindFirstChild("Handle")if h then h.Transparency=0 end end end for _,item in ipairs(char:GetChildren())do if item:IsA("Accessory")then for _,part in ipairs(item:GetDescendants())do if part:IsA("BasePart")then local original=part:GetAttribute("RivalHubOriginalTransparency")if original~=nil then part.Transparency=original;part:SetAttribute("RivalHubOriginalTransparency",nil)end local originalLocal=part:GetAttribute("RivalHubOriginalLocalTransparency")if originalLocal~=nil then part.LocalTransparencyModifier=originalLocal;part:SetAttribute("RivalHubOriginalLocalTransparency",nil)end end end elseif item:IsA("Shirt")then local original=item:GetAttribute("RivalHubOriginalTemplate")if original~=nil then item.ShirtTemplate=original;item:SetAttribute("RivalHubOriginalTemplate",nil)end elseif item:IsA("Pants")then local original=item:GetAttribute("RivalHubOriginalTemplate")if original~=nil then item.PantsTemplate=original;item:SetAttribute("RivalHubOriginalTemplate",nil)end elseif item:IsA("ShirtGraphic")then local original=item:GetAttribute("RivalHubOriginalGraphic")if original~=nil then item.Graphic=original;item:SetAttribute("RivalHubOriginalGraphic",nil)end end end end local OUTFITS={{label="OFF",customApply=applyNoOutfit},{accessory=10159600649,offset=_V3new(0,1,-0.2),shirt="http://www.roblox.com/asset/?id=9683332638",pants="http://www.roblox.com/asset/?id=93182020184041",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 1",headlessKorblox=true},{accessory=1744060292,offset=_V3new(0,1.3,-0.2),shirt="http://www.roblox.com/asset/?id=9683332638",pants="http://www.roblox.com/asset/?id=93182020184041",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 2",headlessKorblox=true},{accessory=215718515,offset=_V3new(0,1.2,-0.15),shirt="http://www.roblox.com/asset/?id=15998365201",pants="http://www.roblox.com/asset/?id=7689651773",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 3",headlessKorblox=true},{accessory=553970961,offset=_V3new(0,1.15,-0.2),shirt="http://www.roblox.com/asset/?id=9478068776",pants="http://www.roblox.com/asset/?id=6348682339",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 4",headlessKorblox=true},{bubbleShirt=18552805597,bubblePants=5414143509,bubbleHair=84008082880128,label="Outfit 5",headlessKorblox=false},{bubbleShirt=11416036966,bubblePants=5842013905,bubbleHair=86475919719501,bubbleHat=121789170766733,korbloxHeadless=true,label="Outfit 6",headlessKorblox=false},{bubbleShirt=9733132546,bubblePants=101481154733615,bubbleHair=111149505826763,label="Outfit 7",headlessKorblox=false},{bubbleShirt=10796276786,bubblePants=101481154733615,bubbleHair=111149505826763,label="Outfit 8",headlessKorblox=false},}local currentOutfitIndex=1 local outfitSelectorLabel=nil VX7A={index=0,mod=nil,loading=false,busy=false,pending=nil,label=nil,labels={"OFF","ALIEN","OUTFIT","OUTFIT 2","OUTFIT 3","OUTFIT 4","OUTFIT 5","OUTFIT 6","ZeyHubb.vs","NEW SKIN"},}VX7A.src=[==[
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local huiOk, huiResult = pcall(function() return gethui and gethui() end)
local CoreGui = huiOk and huiResult or game:GetService("CoreGui")
local LP = Players.LocalPlayer
local OUTFITS = {
{
id = 10997283529,
label = "ALIEN",
hideOriginal = false,
hideOriginalHead = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {10997283529, 125085889448130},
},
{
label = "OUTFIT",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {125157548394108, 123231522991173, 74827642361405},
},
{
label = "OUTFIT 2",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
face = 86109936998865,
faceMode = "decal",
items = {136644276218918, 132022106987543, 131740907052260},
},
{
label = "OUTFIT 3",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {119331031817124, 84952305140948},
},
{
label = "OUTFIT 4",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
},
{
label = "OUTFIT 5",
hideOriginal = false,
clearOriginalWearables = true,
items = {13935333090, 16110951997, 10632503818},
},
{
label = "OUTFIT 6",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
},
{
label = "ZeyHubb.vs",
hideOriginal = false,
headless = true,
hideRightLeg = true,
localOnly = true,
clearOriginalWearables = true,
items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
},
{
label = "NEW SKIN",
localOnly = true,
preserveRig = true,
hideOriginal = false,
hideLeftLeg = true,
hideRightLeg = true,
clearOriginalWearables = true,
items = {70414871864071,14863917259,133498027006138,82277826177074},
accessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck,
[133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},
},
}
local BODY_PART_NAMES = {
Head = true, UpperTorso = true, LowerTorso = true, Torso = true,
LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
RightUpperArm = true, RightLowerArm = true, RightHand = true,
LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
["Left Arm"] = true, ["Right Arm"] = true,
["Left Leg"] = true, ["Right Leg"] = true,
}
local PART_NAME_ALIASES = {
["Korblox-Deathspeaker-Right-Leg"] = "RightUpperLeg",
}
local state = {
enabled = false,
selected = 1,
visuals = {},
hidden = {},
wearableConn = nil,
headlessConn = nil,
headlessLoop = nil,
statsLoop = nil,
savedWalkSpeed = nil,
savedJumpPower = nil,
originalDescription = nil,
descriptionCharacter = nil,
connections = {},
}
local function currentCharacter()
local character = LP.Character or LP.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)
return character, humanoid, root
end
local function restoreOriginalBody()
for object, saved in pairs(state.hidden) do
if object and object.Parent then
pcall(function()
if type(saved) == "table" and saved.basePart then
object.LocalTransparencyModifier = saved.localTransparency
object.Transparency = saved.transparency
elseif type(saved) == "table" and saved.properties then
for property, value in pairs(saved.properties) do object[property] = value end
elseif type(saved) == "table" and saved.property then
object[saved.property] = saved.value
elseif object:IsA("BasePart") then
object.LocalTransparencyModifier = saved
elseif object:IsA("Decal") or object:IsA("Texture") then
object.Transparency = saved
end
end)
end
end
state.hidden = {}
end
local stopHeadless
local enforceHeadless
local enforceStats
local function clearVisuals()
stopHeadless()
if state.wearableConn then
state.wearableConn:Disconnect()
state.wearableConn = nil
end
for _, object in ipairs(state.visuals) do
if object and object.Parent then pcall(function() object:Destroy() end) end
end
state.visuals = {}
restoreOriginalBody()
end
local function belongsToLocalVisual(object)
for _, visual in ipairs(state.visuals) do
if object == visual or object:IsDescendantOf(visual) then return true end
end
return false
end
local function hideOriginalBody(character)
restoreOriginalBody()
for _, object in ipairs(character:GetDescendants()) do
if not belongsToLocalVisual(object) then
if object:IsA("BasePart") then
state.hidden[object] = object.LocalTransparencyModifier
object.LocalTransparencyModifier = 1
elseif object:IsA("Decal") or object:IsA("Texture") then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
end
local function hideOriginalHead(character)
local head = character:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
if state.hidden[head] == nil then
state.hidden[head] = {
basePart = true,
localTransparency = head.LocalTransparencyModifier,
transparency = head.Transparency,
}
elseif type(state.hidden[head]) ~= "table" then
state.hidden[head] = {
basePart = true,
localTransparency = state.hidden[head],
transparency = head.Transparency,
}
end
head.LocalTransparencyModifier = 1
head.Transparency = 1
for _, object in ipairs(head:GetDescendants()) do
if (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
local function hideLegSide(character, side)
local names = {side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg", side .. "Toe"}
for _, name in ipairs(names) do
local part = character:FindFirstChild(name)
if part and part:IsA("BasePart") then
if state.hidden[part] == nil then
state.hidden[part] = {
basePart = true,
localTransparency = part.LocalTransparencyModifier,
transparency = part.Transparency,
}
elseif type(state.hidden[part]) ~= "table" then
state.hidden[part] = {
basePart = true,
localTransparency = state.hidden[part],
transparency = part.Transparency,
}
end
part.LocalTransparencyModifier = 1
part.Transparency = 1
end
end
end
local function hideLeftLeg(character)
hideLegSide(character, "Left")
end
local function hideRightLeg(character)
hideLegSide(character, "Right")
end
stopHeadless = function()
if state.headlessConn then
pcall(state.headlessConn.Disconnect, state.headlessConn)
state.headlessConn = nil
end
if state.headlessLoop then
pcall(task.cancel, state.headlessLoop)
state.headlessLoop = nil
end
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
end
enforceHeadless = function(character, option)
stopHeadless()
if not option or not character or not (option.headless or option.hideLeftLeg or option.hideRightLeg) then return end
if option.headless then hideOriginalHead(character) end
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
state.headlessConn = character.ChildAdded:Connect(function(child)
if child:IsA("BasePart") and (option.hideLeftLeg or option.hideRightLeg) then
task.defer(function()
if state.enabled and LP.Character==character then
local active=OUTFITS[state.selected]
if active.hideLeftLeg then hideLeftLeg(character) end
if active.hideRightLeg then hideRightLeg(character) end end end) end
if child.Name == "Head" and child:IsA("BasePart") and OUTFITS[state.selected].headless then
task.defer(function()
if state.enabled and LP.Character == character and OUTFITS[state.selected].headless then
pcall(hideOriginalHead, character)
end
end)
end
end)
state.headlessLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local opt = OUTFITS[state.selected]
if opt and opt.headless then
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") and head.LocalTransparencyModifier < 1 then
pcall(hideOriginalHead, character)
end
end
if opt and opt.hideLeftLeg then
pcall(hideLeftLeg, character)
end
if opt and opt.hideRightLeg then
pcall(hideRightLeg, character)
end
task.wait(0.6)
end
end)
end
enforceStats = function(character)
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
state.statsLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
if state.savedWalkSpeed ~= nil and humanoid.WalkSpeed ~= state.savedWalkSpeed then
humanoid.WalkSpeed = state.savedWalkSpeed
end
if state.savedJumpPower ~= nil and humanoid.JumpPower ~= state.savedJumpPower then
humanoid.JumpPower = state.savedJumpPower
end
end
task.wait(0.4)
end
end)
end
local function hideOriginalWearables(character, watchForNew)
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
if not child:GetAttribute("VX7LocalOnly") and state.hidden[child] == nil then
local property = child:IsA("Shirt") and "ShirtTemplate"
or child:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[child] = {property = property, value = child[property]}
child[property] = ""
end
end
end
for _, child in ipairs(character:GetDescendants()) do
if (child:IsA("Accessory") or child:IsA("Accoutrement")) and not child:GetAttribute("VX7LocalOnly") then
local objects = child:GetDescendants()
if child:IsA("BasePart") then table.insert(objects, child) end
for _, object in ipairs(objects) do
if object:IsA("BasePart") then
local saved = state.hidden[object]
if saved == nil then
state.hidden[object] = {
basePart = true,
localTransparency = object.LocalTransparencyModifier,
transparency = object.Transparency,
}
elseif type(saved) ~= "table" then
state.hidden[object] = {
basePart = true,
localTransparency = saved,
transparency = object.Transparency,
}
end
object.LocalTransparencyModifier = 1
object.Transparency = 1
elseif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
elseif (object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")) and state.hidden[object] == nil then
state.hidden[object] = {property = "Enabled", value = object.Enabled}
object.Enabled = false
end
end
end
end
if watchForNew and not state.wearableConn then
state.wearableConn = character.DescendantAdded:Connect(function(object)
if not state.enabled or not OUTFITS[state.selected].clearOriginalWearables then return end
if object:IsA("Accessory") or object:IsA("Accoutrement")
or object:FindFirstAncestorWhichIsA("Accessory")
or object:FindFirstAncestorWhichIsA("Accoutrement") then
task.defer(function()
if state.enabled and character.Parent then hideOriginalWearables(character, false) end
end)
end
end)
end
end
local function loadAssetObjects(assetId)
local insertOk, inserted = pcall(function() return InsertService:LoadAsset(assetId) end)
if insertOk and inserted then return {inserted}, "InsertService" end
local objectOk, objects = pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)
if objectOk and objects and #objects > 0 then return objects, "GetObjects" end
return nil, tostring(inserted or objects or "unknown loading error")
end
local faceTextureCache = {}
local function resolveFaceTexture(faceId)
if faceTextureCache[faceId] then return faceTextureCache[faceId] end
local objects = loadAssetObjects(faceId)
if objects then
local texture
for _, root in ipairs(objects) do
local candidates = {root}
for _, object in ipairs(root:GetDescendants()) do table.insert(candidates, object) end
for _, object in ipairs(candidates) do
if object:IsA("Decal") or object:IsA("Texture") then
texture = object.Texture
if texture and texture ~= "" then break end
end
end
pcall(function() root:Destroy() end)
if texture and texture ~= "" then break end
end
if texture and texture ~= "" then
faceTextureCache[faceId] = texture
return texture
end
end
return "rbxassetid://" .. tostring(faceId)
end
local function applyLocalFace(character, faceId)
local head = character:FindFirstChild("Head")
if not head then return false end
local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
if face and not face:IsA("Decal") then face = nil end
if face then
if state.hidden[face] == nil then
state.hidden[face] = {
properties = {Texture = face.Texture, Transparency = face.Transparency},
}
end
else
face = Instance.new("Decal")
face.Name = "face"
face.Face = Enum.NormalId.Front
face:SetAttribute("VX7LocalOnly", true)
face.Parent = head
table.insert(state.visuals, face)
end
face.Texture = resolveFaceTexture(faceId)
face.Transparency = 0
return true
end
local function applyLocalFaceStable(character, faceId)
pcall(applyLocalFace, character, faceId)
for _, delayTime in ipairs({0.2, 0.8}) do
task.delay(delayTime, function()
local option = OUTFITS[state.selected]
if state.enabled and LP.Character == character and option and option.face == faceId then
pcall(applyLocalFace, character, faceId)
end
end)
end
end
local function findCharacterAttachment(character, name)
for _, object in ipairs(character:GetDescendants()) do
if object:IsA("Attachment") and object.Name == name and not object:FindFirstAncestorWhichIsA("Accessory") then
return object
end
end
end
local function sanitizeVisual(container)
local objects = container:GetDescendants()
if container:IsA("BasePart") then table.insert(objects, container) end
for _, object in ipairs(objects) do
if object:IsA("LuaSourceContainer") then
object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored = false
object.CanCollide = false
object.CanTouch = false
object.CanQuery = false
object.Massless = true
object.CastShadow = false
elseif object:IsA("JointInstance") and object.Name == "AccessoryWeld" then
object:Destroy()
end
end
end
local function weldPart(part, target)
local weld = Instance.new("WeldConstraint")
weld.Name = "VX7LocalVisualWeld"
weld.Part0 = target
weld.Part1 = part
weld.Parent = part
end
local function countStackedAccessories(character, attachmentName)
local count = 0
for _, visual in ipairs(state.visuals) do
if visual:IsA("Accessory") then
local h = visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)
if h then
for _, child in ipairs(h:GetChildren()) do
if child:IsA("Attachment") and child.Name == attachmentName then
count = count + 1
break
end
end
end
end
end
return count
end
local function attachAccessoryLocal(accessory, character, rootPart, assetId)
local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
if not handle then return false end
sanitizeVisual(accessory)
accessory.Name = "VX7_LocalOutfit_" .. tostring(assetId)
accessory:SetAttribute("VX7AssetId", assetId)
accessory:SetAttribute("VX7LocalOnly", true)
local option=OUTFITS[state.selected]
local slot=option and option.accessorySlots and option.accessorySlots[assetId]
if slot then pcall(function() accessory.AccessoryType=slot end) end
accessory.Parent = character
local sourceAttachment
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("Attachment") and findCharacterAttachment(character, child.Name) then
sourceAttachment = child
break
end
end
local targetAttachment = sourceAttachment and findCharacterAttachment(character, sourceAttachment.Name)
local targetPart = targetAttachment and targetAttachment.Parent
if targetAttachment and targetPart and targetPart:IsA("BasePart") then
handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
local stacked = countStackedAccessories(character, sourceAttachment.Name)
if stacked > 0 then
handle.CFrame = handle.CFrame * CFrame.new(0, stacked * 0.15, 0)
end
else
targetPart = character:FindFirstChild("LowerTorso")
or character:FindFirstChild("Torso")
or rootPart
if not targetPart then accessory:Destroy(); return false end
handle.CFrame = rootPart.CFrame
end
weldPart(handle, targetPart)
table.insert(state.visuals, accessory)
return true
end
local function attachLooseVisual(rootObject, character, rootPart, assetId, textureId, targetPart)
local clone = rootObject:Clone()
sanitizeVisual(clone)
clone.Name = "VX7_LocalOutfit_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone.Parent = character
local parts = {}
if clone:IsA("BasePart") then table.insert(parts, clone) end
for _, object in ipairs(clone:GetDescendants()) do
if object:IsA("BasePart") then table.insert(parts, object) end
end
if #parts == 0 then clone:Destroy(); return false end
local anchor = targetPart or rootPart
if textureId then
for _, part in ipairs(parts) do
if part:IsA("MeshPart") then
pcall(function() part.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
end
end
local pivot = clone:IsA("Model") and clone:GetPivot() or parts[1].CFrame
for _, part in ipairs(parts) do
local offset = pivot:ToObjectSpace(part.CFrame)
part.CFrame = anchor.CFrame * offset
weldPart(part, anchor)
end
table.insert(state.visuals, clone)
return true
end
local function attachClassicClothingLocal(rootObject, character, assetId)
local candidates = {}
if rootObject:IsA("Shirt") or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then
table.insert(candidates, rootObject)
end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(candidates, object)
end
end
local added = 0
for _, source in ipairs(candidates) do
for _, existing in ipairs(character:GetChildren()) do
if existing.ClassName == source.ClassName and not existing:GetAttribute("VX7LocalOnly") then
local property = existing:IsA("Shirt") and "ShirtTemplate"
or existing:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[existing] = {property = property, value = existing[property]}
existing[property] = ""
end
end
local clone = source:Clone()
clone.Name = "VX7_LocalClothing_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone:SetAttribute("VX7LocalOnly", true)
clone.Parent = character
table.insert(state.visuals, clone)
added = added + 1
end
return added
end
local function attachBodyPartsLocal(rootObject, character, assetId, textureId)
local holder = Instance.new("Model")
holder.Name = "VX7_LocalBody_" .. tostring(assetId)
holder:SetAttribute("VX7AssetId", assetId)
holder:SetAttribute("VX7LocalOnly", true)
holder.Parent = character
local bodyColors = rootObject:FindFirstChildOfClass("BodyColors")
local colorProperties = {
Head = "HeadColor", UpperTorso = "TorsoColor", LowerTorso = "TorsoColor", Torso = "TorsoColor",
LeftUpperArm = "LeftArmColor", LeftLowerArm = "LeftArmColor", LeftHand = "LeftArmColor", ["Left Arm"] = "LeftArmColor",
RightUpperArm = "RightArmColor", RightLowerArm = "RightArmColor", RightHand = "RightArmColor", ["Right Arm"] = "RightArmColor",
LeftUpperLeg = "LeftLegColor", LeftLowerLeg = "LeftLegColor", LeftFoot = "LeftLegColor", ["Left Leg"] = "LeftLegColor",
RightUpperLeg = "RightLegColor", RightLowerLeg = "RightLegColor", RightFoot = "RightLegColor", ["Right Leg"] = "RightLegColor",
}
local added = 0
local candidates = {}
if rootObject:IsA("BasePart") then table.insert(candidates, rootObject) end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, source in ipairs(candidates) do
local partName = source.Name
if BODY_PART_NAMES[partName] then
local target = character:FindFirstChild(partName)
if not target then
local alias = PART_NAME_ALIASES[partName]
if alias then target = character:FindFirstChild(alias) end
end
if target and target:IsA("BasePart") then
local clone = source:Clone()
for _, child in ipairs(clone:GetDescendants()) do
if child:IsA("JointInstance") or child:IsA("Constraint") or child:IsA("LuaSourceContainer") then
child:Destroy()
end
end
sanitizeVisual(clone)
clone.Name = source.Name
if clone:IsA("MeshPart") and textureId then
pcall(function() clone.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
if bodyColors and colorProperties[source.Name] then
pcall(function() clone.Color = bodyColors[colorProperties[source.Name]].Color end)
end
clone.CFrame = target.CFrame
clone.Parent = holder
weldPart(clone, target)
added = added + 1
end
end
end
if added == 0 then holder:Destroy(); return 0 end
table.insert(state.visuals, holder)
return added
end
local assetInfoCache = {}
local ASSET_INFO_CACHE_FILE="RivalHubAvatarAssets.json"
pcall(function()
if isfile and readfile and isfile(ASSET_INFO_CACHE_FILE) then
local decoded=HttpService:JSONDecode(readfile(ASSET_INFO_CACHE_FILE))
if type(decoded)=="table" then for id,assetType in pairs(decoded) do
local numericId=tonumber(id);local numericType=tonumber(assetType)
if numericId and numericType then assetInfoCache[numericId]=numericType end end end end end)
local assetInfoSaveQueued=false
local function saveAssetInfoCache()
if assetInfoSaveQueued or not writefile then return end
assetInfoSaveQueued=true;task.delay(.4,function()
assetInfoSaveQueued=false;pcall(function()
local encoded={};for id,assetType in pairs(assetInfoCache) do encoded[tostring(id)]=assetType end
writefile(ASSET_INFO_CACHE_FILE,HttpService:JSONEncode(encoded)) end) end) end
local bodyPropertyByType = {
[17] = "Head", [27] = "Torso", [28] = "RightArm",
[29] = "LeftArm", [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",
}
local bodyPartAnchorNames = {
[17] = {"Head"}, [79] = {"Head"},
[27] = {"UpperTorso", "Torso"},
[28] = {"RightUpperArm", "Right Arm"},
[29] = {"LeftUpperArm", "Left Arm"},
[30] = {"LeftUpperLeg", "Left Leg"},
[31] = {"RightUpperLeg", "Right Leg"},
}
local accessoryTypeByAssetType = {
[8] = Enum.AccessoryType.Hat,
[41] = Enum.AccessoryType.Hair,
[42] = Enum.AccessoryType.Face,
[43] = Enum.AccessoryType.Neck,
[44] = Enum.AccessoryType.Shoulder,
[45] = Enum.AccessoryType.Front,
[46] = Enum.AccessoryType.Back,
[47] = Enum.AccessoryType.Waist,
[64] = Enum.AccessoryType.TShirt,
[65] = Enum.AccessoryType.Shirt,
[66] = Enum.AccessoryType.Pants,
[67] = Enum.AccessoryType.Jacket,
[68] = Enum.AccessoryType.Sweater,
[69] = Enum.AccessoryType.Shorts,
[70] = Enum.AccessoryType.LeftShoe,
[71] = Enum.AccessoryType.RightShoe,
[72] = Enum.AccessoryType.DressSkirt,
[76] = Enum.AccessoryType.Eyebrow,
[77] = Enum.AccessoryType.Eyelash,
}
local function getAssetTypeId(assetId)
if assetInfoCache[assetId] then return assetInfoCache[assetId] end
local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, Enum.InfoType.Asset)
if ok and info and info.AssetTypeId then
assetInfoCache[assetId] = info.AssetTypeId
saveAssetInfoCache()
return info.AssetTypeId
end
end
local accessoryDescriptionProperties = {
"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory",
"HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory",
"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory",
"SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory",
"EyebrowAccessory", "EyelashAccessory",
}
local function createDirectDescription(option, humanoid)
local directOutfitId = option.outfitId
local completeOutfitDescription
if directOutfitId then
local ok, outfitDescription = pcall(
Players.GetHumanoidDescriptionFromOutfitId,
Players,
directOutfitId
)
if not ok or not outfitDescription then return nil end
completeOutfitDescription = outfitDescription
if not option.items and not option.face and not option.head then return outfitDescription end
end
local source = completeOutfitDescription or state.originalDescription
if not source then
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
source = applied
end
local description = source:Clone()
if completeOutfitDescription then completeOutfitDescription:Destroy() end
if not directOutfitId then
description.Shirt = 0
description.Pants = 0
description.GraphicTShirt = 0
for _, property in ipairs(accessoryDescriptionProperties) do
pcall(function() description[property] = "" end)
end
pcall(function() description:SetAccessories({}, true) end)
end
local accessories = {}
if directOutfitId then
pcall(function() accessories = description:GetAccessories(true) end)
end
local allItems = {}
for _, id in ipairs(option.bodyItems or {}) do table.insert(allItems, id) end
for _, id in ipairs(option.items or {}) do table.insert(allItems, id) end
for _, id in ipairs(allItems) do
local assetTypeId = getAssetTypeId(id)
if not assetTypeId then description:Destroy(); return nil end
local bodyProperty = bodyPropertyByType[assetTypeId]
local accessoryType = accessoryTypeByAssetType[assetTypeId]
if bodyProperty then
description[bodyProperty] = id
elseif assetTypeId == 11 then
description.Shirt = id
elseif assetTypeId == 12 then
description.Pants = id
elseif assetTypeId == 1 then
description.GraphicTShirt = id
elseif assetTypeId == 18 then
description.Face = id
elseif accessoryType then
local accessory = {
AssetId = id,
AccessoryType = accessoryType,
Order = #accessories + 1,
}
if assetTypeId >= 64 and assetTypeId <= 72 then
accessory.IsLayered = true
accessory.Puffiness = option.layeredPuffiness or 0
end
table.insert(accessories, accessory)
else
description:Destroy()
return nil
end
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
local faceBodyProperty = faceTypeId and bodyPropertyByType[faceTypeId]
local faceAccessoryType = faceTypeId and accessoryTypeByAssetType[faceTypeId]
if option.faceMode == "decal" then
if faceTypeId == 18 then description.Face = option.face end
elseif faceBodyProperty then
description[faceBodyProperty] = option.face
elseif faceAccessoryType then
table.insert(accessories, {
AssetId = option.face,
AccessoryType = faceAccessoryType,
Order = #accessories + 1,
})
elseif faceTypeId == 18 then
description.Face = option.face
end
end
if option.head then description.Head = option.head end
for property, value in pairs(option.scales or {}) do
pcall(function() description[property] = value end)
end
if option.skinColor then
for _, property in ipairs({"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}) do
description[property] = option.skinColor
end
end
if #accessories > 0 then
local ok = pcall(function() description:SetAccessories(accessories, true) end)
if not ok then description:Destroy(); return nil end
end
return description
end
local statusText
local function setStatus(text, good)
if not statusText or not statusText.Parent then return end
statusText.Text = text
statusText.TextColor3 = good and Color3.fromRGB(215, 255, 222) or Color3.fromRGB(190, 190, 198)
end
local function applyOutfit()
local character, humanoid, rootPart = currentCharacter()
if not character or not humanoid or not rootPart then setStatus("Character not found", false); return false end
if state.descriptionCharacter ~= character or not state.originalDescription then
state.descriptionCharacter = character
state.originalDescription = nil
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if ok and applied then state.originalDescription = applied:Clone() end
end
clearVisuals()
setStatus("Loading local visual...", false)
local option = OUTFITS[state.selected]
local assetId = option.id or option.outfitId
state.skipDescriptionRestore=option.preserveRig==true
if option.forceBodyParts or option.localOnly then
setStatus("Local visual only (no rig change)...", false)
end
if (option.bodyItems or option.items or option.outfitId) and not option.forceBodyParts and not option.localOnly then
setStatus(option.outfitId and "Loading complete outfit..." or "Applying outfit and complexion...", false)
local description = createDirectDescription(option, humanoid)
if description then
local savedHead = character:FindFirstChild("Head")
local savedHealth = humanoid.Health
state.savedWalkSpeed = humanoid.WalkSpeed
state.savedJumpPower = humanoid.JumpPower
local savedCFrame = rootPart.CFrame
local savedVelocity = rootPart.AssemblyLinearVelocity
local ok = pcall(function() humanoid:ApplyDescription(description) end)
if not ok then ok = pcall(function() humanoid:ApplyDescriptionReset(description) end) end
description:Destroy()
if ok then
local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
local currentRoot = character:FindFirstChild("HumanoidRootPart")
if currentHumanoid and savedHealth > 0 then
currentHumanoid.Health = math.min(savedHealth, currentHumanoid.MaxHealth)
end
if currentRoot then
currentRoot.CFrame = savedCFrame
currentRoot.AssemblyLinearVelocity = savedVelocity
currentRoot.AssemblyAngularVelocity = Vector3.zero
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
if option.faceMode == "decal" or not faceTypeId or faceTypeId == 18 then
applyLocalFaceStable(character, option.face)
end
end
state.enabled = true
enforceStats(character)
enforceHeadless(character, option)
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
if option.head and character:FindFirstChild("Head") == savedHead then
hideOriginalHead(character)
end
setStatus(option.label .. " applied - native avatar method", true)
return true
end
end
setStatus("Native apply failed; using visual fallback...", false)
end
local assetIds = {}
for _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end
if option.head then table.insert(assetIds, option.head) end
if #assetIds == 0 and assetId and not option.outfitId then table.insert(assetIds, assetId) end
local fallbackFaceType = option.face and getAssetTypeId(option.face)
local faceIsAccessory = option.faceMode ~= "decal"
and fallbackFaceType
and accessoryTypeByAssetType[fallbackFaceType] ~= nil
if faceIsAccessory then table.insert(assetIds, option.face) end
local attached, expected = 0, 0
local lastError
expected = expected + (option.face and not faceIsAccessory and 1 or 0)
for _, currentAssetId in ipairs(assetIds) do
local objects, method = loadAssetObjects(currentAssetId)
if objects then
for _, loadedRoot in ipairs(objects) do
local rootAttached = false
local bodyPartsAttached = false
local classics = {}
if loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then
table.insert(classics, loadedRoot)
end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(classics, object)
end
end
local accessories = {}
if loadedRoot:IsA("Accessory") then
table.insert(accessories, loadedRoot)
else
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Accessory") then table.insert(accessories, object:Clone()) end
end
end
local assetTypeId = getAssetTypeId(currentAssetId)
local isBodyPartAsset = assetTypeId ~= nil and bodyPropertyByType[assetTypeId] ~= nil
local bodyCandidates = 0
local wantsBodyParts = not loadedRoot:IsA("Accessory")
and (option.hideOriginal or option.hideOriginalHead or currentAssetId == option.head or (option.forceBodyParts and isBodyPartAsset))
if wantsBodyParts then
local candidates = {}
if loadedRoot:IsA("BasePart") then table.insert(candidates, loadedRoot) end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, object in ipairs(candidates) do
if BODY_PART_NAMES[object.Name] or PART_NAME_ALIASES[object.Name] then bodyCandidates = bodyCandidates + 1 end
end
end
expected = expected + #classics + #accessories + bodyCandidates
if #accessories == 0 and #classics == 0 and bodyCandidates == 0 then expected = expected + 1 end
if #classics > 0 then
local ok, result = pcall(attachClassicClothingLocal, loadedRoot, character, currentAssetId)
if ok and result and result > 0 then attached = attached + result; rootAttached = true end
end
if wantsBodyParts and bodyCandidates > 0 then
local ok, result = pcall(attachBodyPartsLocal, loadedRoot, character, currentAssetId, option.headTexture)
if ok and result and result > 0 then
attached = attached + result
rootAttached = true
bodyPartsAttached = true
end
end
for _, accessory in ipairs(accessories) do
local ok, result = pcall(attachAccessoryLocal, accessory, character, rootPart, currentAssetId)
if ok and result then
attached = attached + 1
rootAttached = true
else
pcall(function() accessory:Destroy() end)
end
end
if not rootAttached and not bodyPartsAttached and #accessories == 0 and #classics == 0 then
local headAnchor = character:FindFirstChild("Head")
local anchor = rootPart
if currentAssetId == option.head then
anchor = headAnchor
elseif isBodyPartAsset then
local anchorNames = bodyPartAnchorNames[assetTypeId]
if anchorNames then
for _, name in ipairs(anchorNames) do
local target = character:FindFirstChild(name)
if target and target:IsA("BasePart") then anchor = target; break end
end
end
end
local ok, result = pcall(attachLooseVisual, loadedRoot, character, rootPart, currentAssetId, option.headTexture, anchor)
if ok and result then attached = attached + 1 end
end
if loadedRoot.Parent == nil and not table.find(state.visuals, loadedRoot) then
pcall(function() loadedRoot:Destroy() end)
end
end
else
lastError = method
end
end
local faceApplied = false
if option.face and not faceIsAccessory then
local ok, result = pcall(applyLocalFace, character, option.face)
faceApplied = ok and result == true
end
local headlessApplied = false
if option.headless then
enforceHeadless(character, option)
headlessApplied = true
end
local legApplied = false
if option.hideLeftLeg then
hideLeftLeg(character)
legApplied = true
end
if option.hideRightLeg then
hideRightLeg(character)
legApplied = true
end
local totalItems = expected
local loadedItems = attached + (faceApplied and 1 or 0)
state.enabled = attached > 0 or faceApplied or headlessApplied or legApplied
if state.enabled then
if option.preserveRig and (option.hideLeftLeg or option.hideRightLeg) then enforceHeadless(character,option) end
if option.hideOriginal then hideOriginalBody(character) end
if option.hideOriginalHead then hideOriginalHead(character) end
if option.head then hideOriginalHead(character) end
if option.clearOriginalWearables then hideOriginalWearables(character, true) end
setStatus(string.format("%s fallback - %d/%d items", option.label, loadedItems, totalItems), loadedItems == totalItems)
else
setStatus("Could not attach outfit - " .. tostring(lastError or "no 3D parts"), false)
end
return state.enabled
end
local function restoreOriginalDescription()
local description = state.originalDescription
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if description and humanoid and character == state.descriptionCharacter and not state.skipDescriptionRestore then
local clone = description:Clone()
local ok = pcall(function() humanoid:ApplyDescription(clone) end)
if not ok then pcall(function() humanoid:ApplyDescriptionReset(clone) end) end
clone:Destroy()
end
if state.originalDescription then state.originalDescription:Destroy() end
state.originalDescription = nil
state.descriptionCharacter = nil
state.skipDescriptionRestore=false
end
local function removeOutfit()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
setStatus("Local visual removed", true)
end
return {
outfits = OUTFITS,
apply = function(index)
state.selected = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
return applyOutfit()
end,
remove = removeOutfit,
description = function(index)
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local option = OUTFITS[math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)]
if not humanoid or not option then return nil end
local strict = createDirectDescription(option, humanoid)
if strict then return strict end
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
local description = applied:Clone(); applied:Destroy()
description.Shirt=0; description.Pants=0; description.GraphicTShirt=0
for _,property in ipairs(accessoryDescriptionProperties) do pcall(function() description[property]="" end) end
pcall(function() description:SetAccessories({},true) end)
local accessories={}; local all={}
for _,id in ipairs(option.bodyItems or {}) do table.insert(all,id) end
for _,id in ipairs(option.items or {}) do table.insert(all,id) end
for _,id in ipairs(all) do
local assetTypeId=getAssetTypeId(id); local bodyProperty=assetTypeId and bodyPropertyByType[assetTypeId]; local accessoryType=assetTypeId and accessoryTypeByAssetType[assetTypeId]
if bodyProperty then description[bodyProperty]=id elseif assetTypeId==11 then description.Shirt=id elseif assetTypeId==12 then description.Pants=id elseif assetTypeId==1 then description.GraphicTShirt=id elseif assetTypeId==18 then description.Face=id elseif accessoryType then
table.insert(accessories,{AssetId=id,AccessoryType=accessoryType,Order=#accessories+1,IsLayered=assetTypeId>=64 and assetTypeId<=72,Puffiness=option.layeredPuffiness or 0}) end
end
if option.face then local faceType=getAssetTypeId(option.face); if faceType==18 then description.Face=option.face elseif faceType and bodyPropertyByType[faceType] then description[bodyPropertyByType[faceType]]=option.face elseif faceType and accessoryTypeByAssetType[faceType] then table.insert(accessories,{AssetId=option.face,AccessoryType=accessoryTypeByAssetType[faceType],Order=#accessories+1}) end end
if option.head then description.Head=option.head end
for property,value in pairs(option.scales or {}) do pcall(function() description[property]=value end) end
if #accessories>0 then pcall(function() description:SetAccessories(accessories,true) end) end
return description
end,
previewModel = function(index)
local option=OUTFITS[math.clamp(math.floor(tonumber(index) or 1),1,#OUTFITS)]; local character=LP.Character
if not option or not character then return nil end
local oldArchivable=character.Archivable; character.Archivable=true; local ok,clone=pcall(function() return character:Clone() end); character.Archivable=oldArchivable
if not ok or not clone then return nil end
for _,child in ipairs(clone:GetChildren()) do
if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") or child:IsA("Tool") then child:Destroy() end
end
for _,object in ipairs(clone:GetDescendants()) do if object:IsA("LuaSourceContainer") then object:Destroy() elseif object:IsA("BasePart") then object.Transparency=object.Name=="HumanoidRootPart" and 1 or 0; object.LocalTransparencyModifier=0 end end
local root=clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("LowerTorso") or clone:FindFirstChild("Torso")
if not root then clone:Destroy(); return nil end
local savedVisuals,savedHidden,savedWearable=state.visuals,state.hidden,state.wearableConn; state.visuals={}; state.hidden={}; state.wearableConn=nil
local ids={}; for _,id in ipairs(option.bodyItems or {}) do table.insert(ids,id) end; for _,id in ipairs(option.items or {}) do table.insert(ids,id) end
if option.head then table.insert(ids,option.head) end; if option.face and option.faceMode~="decal" then table.insert(ids,option.face) end
for _,id in ipairs(ids) do
local objects=loadAssetObjects(id)
if objects then for _,loadedRoot in ipairs(objects) do
pcall(attachClassicClothingLocal,loadedRoot,clone,id)
local accessories={}; if loadedRoot:IsA("Accessory") then table.insert(accessories,loadedRoot) else for _,object in ipairs(loadedRoot:GetDescendants()) do if object:IsA("Accessory") then table.insert(accessories,object:Clone()) end end end
for _,accessory in ipairs(accessories) do pcall(attachAccessoryLocal,accessory,clone,root,id) end
local isBody=table.find(option.bodyItems or {},id)~=nil or id==option.head
if isBody then pcall(attachBodyPartsLocal,loadedRoot,clone,id,option.headTexture) end
if loadedRoot.Parent and not table.find(state.visuals,loadedRoot) then pcall(function() loadedRoot:Destroy() end) end
end end
end
state.visuals,state.hidden,state.wearableConn=savedVisuals,savedHidden,savedWearable
if option.face and option.faceMode=="decal" then local head=clone:FindFirstChild("Head"); if head then local face=head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal"); if not face then face=Instance.new("Decal"); face.Name="face"; face.Face=Enum.NormalId.Front; face.Parent=head end; face.Texture=resolveFaceTexture(option.face); face.Transparency=0 end end
if option.headless or option.hideOriginalHead then local head=clone:FindFirstChild("Head"); if head then head.Transparency=1; for _,v in ipairs(head:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 end end end end
if option.hideRightLeg then for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do local part=clone:FindFirstChild(name); if part then part.Transparency=1 end end end
return clone
end,
cleanup = function()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
end,
}
]==]function VX7A.load()if VX7A.mod then return VX7A.mod end if VX7A.loading or type(loadstring)~="function"then return nil end VX7A.loading=true local ok,fn=pcall(loadstring,VX7A.src)if ok and type(fn)=="function"then local ok2,res=pcall(fn)if ok2 and type(res)=="table"then VX7A.mod=res end end VX7A.loading=false return VX7A.mod end function VX7A.setLabel()if VX7A.label and VX7A.label.Parent then VX7A.label.Text=VX7A.labels[VX7A.index+1]or"OFF"end end function VX7A.stop()VX7A.pending=nil if VX7A.index~=0 then VX7A.index=0 local m=VX7A.mod if m and m.remove then pcall(m.remove)end end VX7A.setLabel()end function VX7A.apply(index)index=math.clamp(math.floor(tonumber(index)or 0),0,#VX7A.labels-1)if index==0 then VX7A.stop()return end local m=VX7A.load()if not m or type(m.apply)~="function"then warn("[ZeyHubb.vs] No se pudo cargar el modulo de avatares VX7 (loadstring no disponible).")VX7A.setLabel()return end if VX7A.busy then VX7A.pending=index;VX7A.index=index;VX7A.setLabel()return end if currentOutfitIndex~=1 then currentOutfitIndex=1 pcall(function()applyOutfitByIndex(1)end)if outfitSelectorLabel then outfitSelectorLabel.Text=OUTFITS[1].label end end VX7A.index=index VX7A.setLabel()VX7A.busy=true task.spawn(function()pcall(m.apply,index)VX7A.busy=false local nxt=VX7A.pending VX7A.pending=nil if nxt and nxt~=0 and VX7A.index==nxt then VX7A.apply(nxt)end end)end pcall(function()LP.CharacterAdded:Connect(function()if _G.RivalHubSession~=_mySession or VX7A.index==0 then return end task.delay(1.5,function()if _G.RivalHubSession==_mySession and VX7A.index~=0 then VX7A.apply(VX7A.index)end end)end)end)local function loadObjectsStd(id)local ok,res=pcall(function()return game:GetObjects("rbxassetid://"..tostring(id))end)if ok and typeof(res)=="table"and#res>0 then return res end ok,res=pcall(function()return game:GetService("InsertService"):LoadAsset(id)end)if ok and res then return{res}end return nil end local function resolveBubbleTemplate(id,className,propertyName)local fallback="rbxassetid://"..tostring(id)local ok,objects=pcall(function()return game:GetObjects(fallback)end)if ok and objects and objects[1]then local item=objects[1]local obj=item:IsA(className)and item or item:FindFirstChildWhichIsA(className,true)if obj and obj[propertyName]and obj[propertyName]~=""then fallback=obj[propertyName]end for _,v in ipairs(objects)do pcall(function()v:Destroy()end)end end return fallback end local function addBubbleHair(char,assetId,accName)local head=char and char:FindFirstChild("Head")if not head then return false end local objects=loadObjectsStd(assetId)if not objects or not objects[1]then return false end local source=objects[1]local accessory=source:IsA("Accessory")and source or source:FindFirstChildWhichIsA("Accessory",true)if not accessory then for _,v in ipairs(objects)do pcall(function()v:Destroy()end)end return false end local hair=accessory:Clone()hair.Name=accName or"BubbleSkinChanger_Hair"for _,part in ipairs(hair:GetDescendants())do if part:IsA("BasePart")then part.Anchored=false;part.CanCollide=false;part.Massless=true;part.LocalTransparencyModifier=0 end end local humanoid=char:FindFirstChildOfClass("Humanoid")local ok=pcall(function()if humanoid then humanoid:AddAccessory(hair)else hair.Parent=char end end)if not ok then pcall(function()hair:Destroy()end)end if ok then task.wait()if hair.Parent~=char then pcall(function()hair.Parent=char end)end local handle=hair:FindFirstChild("Handle")if handle and handle:IsA("BasePart")and handle.Parent and not handle:FindFirstChildWhichIsA("Weld")and not handle:FindFirstChildWhichIsA("WeldConstraint")then pcall(function()local att=handle:FindFirstChildWhichIsA("Attachment")local target=att and char:FindFirstChild(att.Name,true)local weld=Instance.new("Weld")weld.Name="AccessoryWeld"if target and target:IsA("Attachment")then weld.Part0=target.Parent weld.C0=target.CFrame weld.C1=att.CFrame else weld.Part0=head weld.C0=CFrame.new(0,head.Size.Y/2,0)*hair.AttachmentPoint:Inverse()end weld.Part1=handle weld.Parent=handle end)end end for _,v in ipairs(objects)do pcall(function()v:Destroy()end)end return ok end local function applyHeadlessKorblox(char)if not char then return end pcall(function()LP.CharacterAvatarType=Enum.AvatarType.R6 end)local head=char:FindFirstChild("Head")if head then if head:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then head:SetAttribute("RivalHubOutfitOriginalTransparency",head.Transparency)head:SetAttribute("RivalHubOutfitOriginalLocalTransparency",head.LocalTransparencyModifier)end head.Transparency=1 head.CanCollide=false head.LocalTransparencyModifier=1 local face=head:FindFirstChild("face")if face then face.Transparency=1 end end pcall(function()local neck=char:FindFirstChild("Neck")if neck then neck.Enabled=false end end)for _,v in pairs(char:GetChildren())do if v:IsA("Accessory")then local w=v:FindFirstChildWhichIsA("Weld")or v:FindFirstChildWhichIsA("WeldConstraint")or v:FindFirstChildWhichIsA("Motor6D")if w then local p0,p1=w.Part0,w.Part1 if(p0 and p0.Name=="Head")or(p1 and p1.Name=="Head")then for _,part in ipairs(v:GetDescendants())do if part:IsA("BasePart")then if part:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then part:SetAttribute("RivalHubOutfitOriginalTransparency",part.Transparency)part:SetAttribute("RivalHubOutfitOriginalLocalTransparency",part.LocalTransparencyModifier)end part.Transparency=1 part.LocalTransparencyModifier=1 end end end end end end local rightLegConfig={id="rbxassetid://139607718",targetBodyPart="RightUpperLeg",partsToHide={"RightUpperLeg","RightLowerLeg","RightFoot"},scale=_V3new(1,1,1),offset=_CFnew(0,0,0)}local targetPart=char:FindFirstChild(rightLegConfig.targetBodyPart)if targetPart then local oldAsset=char:FindFirstChild("Korblox_RightLeg")if oldAsset then oldAsset:Destroy()end for _,partName in ipairs(rightLegConfig.partsToHide)do local limb=char:FindFirstChild(partName)if limb and limb:IsA("BasePart")then if limb:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then limb:SetAttribute("RivalHubOutfitOriginalTransparency",limb.Transparency)end limb.Transparency=1 end end local success,objects=pcall(function()return game:GetObjects(rightLegConfig.id)end)if success and objects and#objects>0 then local assetModel=objects[1]assetModel.Name="Korblox_RightLeg"local mainMesh=assetModel:IsA("BasePart")and assetModel or assetModel:FindFirstChildWhichIsA("BasePart",true)if mainMesh then mainMesh.Size=mainMesh.Size*rightLegConfig.scale mainMesh.CanCollide=false mainMesh.CFrame=targetPart.CFrame*rightLegConfig.offset local weld=Instance.new("WeldConstraint")weld.Part0=targetPart weld.Part1=mainMesh weld.Parent=mainMesh assetModel.Parent=char end end end end function applyBubbleKorbloxHeadless(char)if not char then return end local targetPart=char:FindFirstChild("RightUpperLeg")if targetPart then local old=char:FindFirstChild("Korblox_RightLeg")if old then old:Destroy()end for _,partName in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local limb=char:FindFirstChild(partName)if limb and limb:IsA("BasePart")then if limb:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then limb:SetAttribute("RivalHubOutfitOriginalTransparency",limb.Transparency)end limb.Transparency=1 end end local success,objects=pcall(function()return game:GetObjects("rbxassetid://139607718")end)if success and objects and#objects>0 then local assetModel=objects[1]assetModel.Name="Korblox_RightLeg"local mainMesh=assetModel:IsA("BasePart")and assetModel or assetModel:FindFirstChildWhichIsA("BasePart",true)if mainMesh then mainMesh.CanCollide=false mainMesh.CFrame=targetPart.CFrame local weld=Instance.new("WeldConstraint")weld.Part0=targetPart weld.Part1=mainMesh weld.Parent=mainMesh assetModel.Parent=char end end end local head=char:FindFirstChild("Head")if head and head:IsA("BasePart")then if head:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then head:SetAttribute("RivalHubOutfitOriginalTransparency",head.Transparency)head:SetAttribute("RivalHubOutfitOriginalLocalTransparency",head.LocalTransparencyModifier)end head.Transparency=1 head.LocalTransparencyModifier=1 local face=head:FindFirstChild("face")if face and face:IsA("Decal")then if face:GetAttribute("RivalHubOriginalFaceTransparency")==nil then face:SetAttribute("RivalHubOriginalFaceTransparency",face.Transparency)end face.Transparency=1 end end end function applyOutfitByIndex(index)local cfg=OUTFITS[index]if not cfg then return end local char=LP.Character if not char then return end clearPreviousOutfitAssets(char)for _,item in ipairs(char:GetChildren())do if item:IsA("Accessory")and item.Name:sub(1,#TAG)~=TAG then for _,part in ipairs(item:GetDescendants())do if part:IsA("BasePart")then if part:GetAttribute("RivalHubOriginalTransparency")==nil then part:SetAttribute("RivalHubOriginalTransparency",part.Transparency)part:SetAttribute("RivalHubOriginalLocalTransparency",part.LocalTransparencyModifier)end part.Transparency=1 part.LocalTransparencyModifier=1 end end elseif item:IsA("Shirt")then if item:GetAttribute("RivalHubOriginalTemplate")==nil then item:SetAttribute("RivalHubOriginalTemplate",item.ShirtTemplate)end item.ShirtTemplate=""elseif item:IsA("Pants")then if item:GetAttribute("RivalHubOriginalTemplate")==nil then item:SetAttribute("RivalHubOriginalTemplate",item.PantsTemplate)end item.PantsTemplate=""elseif item:IsA("ShirtGraphic")then if item:GetAttribute("RivalHubOriginalGraphic")==nil then item:SetAttribute("RivalHubOriginalGraphic",item.Graphic)end item.Graphic=""end end if cfg.customApply then cfg.customApply(char)if outfitSelectorLabel then outfitSelectorLabel.Text=cfg.label end return end if cfg.bubbleShirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.Name="BubbleSkinChanger_Shirt"s.ShirtTemplate=resolveBubbleTemplate(cfg.bubbleShirt,"Shirt","ShirtTemplate")s.Parent=char local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.Name="BubbleSkinChanger_Pants"p.PantsTemplate=resolveBubbleTemplate(cfg.bubblePants,"Pants","PantsTemplate")p.Parent=char addBubbleHair(char,cfg.bubbleHair)if cfg.bubbleHat then addBubbleHair(char,cfg.bubbleHat,"BubbleSkinChanger_Hat")end if cfg.korbloxHeadless then pcall(applyBubbleKorbloxHeadless,char)end if outfitSelectorLabel then outfitSelectorLabel.Text=cfg.label end return end char:WaitForChild("Head",5)local head=char:FindFirstChild("Head")if not head then return end for _,d in ipairs(char:GetChildren())do if d:IsA("CharacterMesh")and d.BodyPart==Enum.BodyPart.Head then pcall(function()d:Destroy()end)end end local done=false if head:IsA("MeshPart")then done=pcall(function()if not head:GetAttribute("RivalHubOutfitModifiedMeshPart")then head:SetAttribute("RivalHubOutfitOriginalMeshId",head.MeshId)head:SetAttribute("RivalHubOutfitOriginalTextureId",head.TextureID)head:SetAttribute("RivalHubOutfitModifiedMeshPart",true)end head.MeshId=cfg.headMesh head.TextureID=cfg.headTexture or""end)end if not done then local sm=head:FindFirstChildWhichIsA("SpecialMesh")if not sm then sm=Instance.new("SpecialMesh")sm:SetAttribute("RivalHubOutfitCreatedMesh",true)elseif not sm:GetAttribute("RivalHubOutfitModifiedMesh")then sm:SetAttribute("RivalHubOutfitOriginalMeshId",sm.MeshId)sm:SetAttribute("RivalHubOutfitOriginalTextureId",sm.TextureId)sm:SetAttribute("RivalHubOutfitModifiedMesh",true)end sm.Parent=head sm.MeshType=Enum.MeshType.FileMesh sm.MeshId=cfg.headMesh sm.TextureId=cfg.headTexture or""end if cfg.shirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.Name="Shirt"s.ShirtTemplate=cfg.shirt s.Parent=char end if cfg.pants then local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.Name="Pants"p.PantsTemplate=cfg.pants p.Parent=char end local old=char:FindFirstChild("AuFfitAccessory")if old then old:Destroy()end if cfg.accessory and head then local objs=loadObjectsStd(cfg.accessory)if objs then local handle for _,o in ipairs(objs)do if o:IsA("BasePart")then handle=o;break end local f=o:FindFirstChildWhichIsA("BasePart",true)if f then handle=f;break end end if handle then local h=handle:Clone()h.Name="AuFfitAccessory"h.CanCollide=false h.Anchored=false h.Massless=true h.Parent=char local weld=Instance.new("Weld")weld.Part0=head weld.Part1=h weld.C0=_CFnew(cfg.offset)weld.Parent=h end for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end end end if cfg.headlessKorblox then applyHeadlessKorblox(char)else if char then local head2=char:FindFirstChild("Head")if head2 then head2.Transparency=0 head2.CanCollide=true head2.LocalTransparencyModifier=0 local face2=head2:FindFirstChild("face")if face2 then face2.Transparency=0 end end pcall(function()local neck=char:FindFirstChild("Neck")if neck then neck.Enabled=true end end)for _,partName in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local limb=char:FindFirstChild(partName)if limb then limb.Transparency=0 end end local oldKorblox=char:FindFirstChild("Korblox_RightLeg")if oldKorblox then oldKorblox:Destroy()end end end if outfitSelectorLabel then outfitSelectorLabel.Text=cfg.label end end speedMode=false antiRagdollMode="off"antiDieEnabled=false antiBatEnabled=false antiFlingEnabled=false jumpEnabled=false laggerToggled=false laggerCarryToggled=false medusaCounterEnabled=false batCounterEnabled=false unwalkEnabled=false autoLeftEnabled=false autoRightEnabled=false autoBatEnabled=false dropMode=1 antiLagEnabled=false removeAccessoriesEnabled=false stretchEnabled=false stretchFOV=120 uiLocked=false mobileButtonsLocked=false uiScaleValue=78 espEnabled=false espLineEnabled=false vividGraphicsEnabled=false _vividEffects={}setVividVisual=nil hideButtonsEnabled=false setHideButtonsVisual=nil bodyLockEnabled=false bodyLockRange=20 bodyLockRangeBox=nil _bodyLockConn=nil _blSuppressCount=0 _blWasEnabled=false _blRestoreTimer=nil _blSmoothRestore=false savedProgressBarPos=nil savedButtonPositions={}savedMobilePanelPos=nil neonWeatherEnabled=false skyTheme="Off"skySelectorLabel=nil _originalLighting=nil setNeonWeatherVisual=nil currentAnimPack="Off"originalTryardAnims=nil tryardHeartbeatConn=nil animSelectorLabel=nil lastMoveDir=_V3zero local CoreGui=game:GetService("CoreGui")local InfiniteJump={enabled=false,mode="hold",jumpPower=55,minVelocity=35,fallClamp=-120,jumpConn=nil,heartbeatConn=nil,presimConn=nil,}local function applyInfJumpBoost(root)if not root then return end local velocity=root.AssemblyLinearVelocity if velocity.Y<InfiniteJump.minVelocity then root.AssemblyLinearVelocity=_V3new(velocity.X,InfiniteJump.jumpPower,velocity.Z)end if velocity.Y<InfiniteJump.fallClamp then root.AssemblyLinearVelocity=_V3new(velocity.X,InfiniteJump.fallClamp,velocity.Z)end end local function onJumpRequest()if not InfiniteJump.enabled then return end local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if root then pcall(function()root.AssemblyLinearVelocity=_V3new(root.AssemblyLinearVelocity.X,InfiniteJump.jumpPower,root.AssemblyLinearVelocity.Z)end)end end local function onPreSimulation()if not InfiniteJump.enabled then return end if InfiniteJump.mode~="hold"then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum or not root then return end local held=UIS:IsKeyDown(Enum.KeyCode.Space)or UIS:IsKeyDown(Enum.KeyCode.ButtonA)or(hum.Jump==true)if held then applyInfJumpBoost(root)else local v=root.AssemblyLinearVelocity if v.Y<InfiniteJump.fallClamp then root.AssemblyLinearVelocity=_V3new(v.X,InfiniteJump.fallClamp,v.Z)end end end local function connectEvents()if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect()end if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect()end if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect()end InfiniteJump.jumpConn=UIS.JumpRequest:Connect(onJumpRequest)InfiniteJump.presimConn=RunService.PreSimulation:Connect(onPreSimulation)end function InfiniteJump.start()if InfiniteJump.enabled then return end InfiniteJump.enabled=true connectEvents()end function InfiniteJump.stop()InfiniteJump.enabled=false if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect();InfiniteJump.jumpConn=nil end if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect();InfiniteJump.heartbeatConn=nil end if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect();InfiniteJump.presimConn=nil end end function InfiniteJump.setJumpPower(power)power=tonumber(power)or 55 InfiniteJump.jumpPower=_clamp(power,10,200)end function InfiniteJump.setMode(mode)InfiniteJump.mode=mode=="manual"and"manual"or"hold"end function InfiniteJump.isRunning()return InfiniteJump.enabled==true end InfiniteJump.stop()function getActiveMoveSpeed()if laggerCarryToggled then return LAGGER_CARRY_SPEED elseif laggerToggled then return LAGGER_SPEED elseif speedMode then return CS else return NS end end function getSpeedModeName()if laggerToggled or laggerCarryToggled then return"LAGGER"elseif speedMode then return"CARRY"else return"NORMAL"end end local _s2VelState=_G.__RivalHubSpeedHookState if type(_s2VelState)~="table"then _s2VelState={hooked=false,velChecked=setmetatable({},{__mode="k"}),root=nil,v=_V3zero,}_G.__RivalHubSpeedHookState=_s2VelState end local _velChecked=_s2VelState.velChecked local _hookedVelParts={}local _hookVelSupported=nil local function _hookVelHRP(hrp)if not hrp then return end _s2VelState.root=hrp _velChecked[hrp]=true if _s2VelState.hooked then return end if type(getrawmetatable)~="function"or type(setreadonly)~="function"or type(newcclosure)~="function"or type(checkcaller)~="function"then return end local ok=pcall(function()local mt=getrawmetatable(game)if not mt then return end setreadonly(mt,false)local originalIndex=rawget(mt,"__index")local originalNewIndex=rawget(mt,"__newindex")local function isOurRoot(t,k)local tk=tostring(k)if tk~="AssemblyLinearVelocity"and tk~="Velocity"then return false end if typeof(t)~="Instance"or not t:IsA("BasePart")then return false end local tn=t.Name if tn~="HumanoidRootPart"and tn~="Torso"and tn~="UpperTorso"then return false end local char=LP.Character return char~=nil and t:IsDescendantOf(char)end if type(originalIndex)=="function"or type(originalIndex)=="table"then local replacementIndex=newcclosure(function(self,key)if not checkcaller()then local good,mine=pcall(isOurRoot,self,key)if good and mine then return _s2VelState.v end end if type(originalIndex)=="function"then return originalIndex(self,key)else return originalIndex[key]end end)mt.__index=replacementIndex end if type(originalNewIndex)=="function"then local replacementNewIndex=newcclosure(function(self,key,value)if not checkcaller()then local good,mine=pcall(isOurRoot,self,key)if good and mine then _s2VelState.v=value return end end return originalNewIndex(self,key,value)end)mt.__newindex=replacementNewIndex end setreadonly(mt,true)_s2VelState.hooked=true end)if not ok then _s2VelState.hooked=false end end local function _setupVelChecked(char)_velChecked=setmetatable({},{__mode="k"})_s2VelState.velChecked=_velChecked if not char then _s2VelState.root=nil;return nil end local hrp=char:WaitForChild("HumanoidRootPart",5)if hrp then _s2VelState.root=hrp _velChecked[hrp]=true end return hrp end if LP.Character then local _hrp0=_setupVelChecked(LP.Character)_hookVelHRP(_hrp0)end local function _isRagdollState(hum)if not hum then return true end local st=hum:GetState()return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown end local function _applyVelocitySpeed(dir,speed,hrp)if not hrp or not hrp.Parent then return end if autoBatEnabled then return end if type(speed)~="number"or speed~=speed or speed<=0 or speed==math.huge then return end local verticalVelocity=hrp.AssemblyLinearVelocity.Y if _G._ZurichHub_MovementBlocked==true or _G._CrystalHub_MovementBlocked==true then hrp.AssemblyLinearVelocity=_V3new(0,math.min(verticalVelocity,0),0)return end if dir and dir.Magnitude>0.05 then pcall(function()if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP)end end)local unit=dir.Unit hrp.AssemblyLinearVelocity=_V3new(unit.X*speed,verticalVelocity,unit.Z*speed)local visibleSpeed=math.min(speed,20)_s2VelState.v=_V3new(unit.X*visibleSpeed,verticalVelocity,unit.Z*visibleSpeed)_G.__RivalHubLiveSpeed={t=os.clock(),v=speed}else _s2VelState.v=_V3new(0,verticalVelocity,0)hrp.AssemblyLinearVelocity=_V3new(0,verticalVelocity,0)end end function getAutoPathSpeed()if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end return NS end ANIM_PACKS={["Cartoon"]={idle1="rbxassetid://742637544",idle2="rbxassetid://742638445",walk="rbxassetid://742640026",run="rbxassetid://742638842",jump="rbxassetid://742637942",fall="rbxassetid://742637151",climb="rbxassetid://742636889",swim="rbxassetid://742639220",swimidle="rbxassetid://742639812"},["Adidas Community"]={idle1="rbxassetid://122257458498464",idle2="rbxassetid://102357151005774",walk="rbxassetid://122150855457006",run="rbxassetid://82598234841035",jump="rbxassetid://75290611992385",fall="rbxassetid://98600215928904",climb="rbxassetid://88763136693023",swim="rbxassetid://133308483266208",swimidle="rbxassetid://109346520324160"},["Adidas Aura"]={idle1="rbxassetid://110211186840347",idle2="rbxassetid://114191137265065",walk="rbxassetid://83842218823011",run="rbxassetid://118320322718866",jump="rbxassetid://109996626521204",fall="rbxassetid://95603166884636",climb="rbxassetid://97824616490448",swim="rbxassetid://134530128383903",swimidle="rbxassetid://94922130551805"},["Catwalk Glam"]={idle1="rbxassetid://133806214992291",idle2="rbxassetid://94970088341563",walk="rbxassetid://109168724482748",run="rbxassetid://81024476153754",jump="rbxassetid://116936326516985",fall="rbxassetid://92294537340807",climb="rbxassetid://119377220967554",swim="rbxassetid://134591743181628",swimidle="rbxassetid://98854111361360"},["Amazon Unboxed"]={idle1="rbxassetid://98281136301627",idle2="rbxassetid://98281136301627",walk="rbxassetid://90478085024465",run="rbxassetid://134824450619865",jump="rbxassetid://121454505477205",fall="rbxassetid://94788218468396",climb="rbxassetid://121145883950231",swim="rbxassetid://105962919001086",swimidle="rbxassetid://129126268464847"},["Zombie"]={idle1="rbxassetid://616158929",idle2="rbxassetid://616160636",walk="rbxassetid://616168032",run="rbxassetid://616163682",jump="rbxassetid://616161997",fall="rbxassetid://616157476",climb="rbxassetid://616156119",swim="rbxassetid://616165109",swimidle="rbxassetid://616166655"},["Ninja"]={idle1="rbxassetid://656117400",idle2="rbxassetid://656117400",walk="rbxassetid://656121766",run="rbxassetid://656118852",jump="rbxassetid://656117878",fall="rbxassetid://656115606",climb="rbxassetid://656114359",swim="rbxassetid://656117400",swimidle="rbxassetid://656117400"},["Knight"]={idle1="rbxassetid://657595757",idle2="rbxassetid://657595757",walk="rbxassetid://657552124",run="rbxassetid://657564596",jump="rbxassetid://658409194",fall="rbxassetid://657600338",climb="rbxassetid://658360781",swim="rbxassetid://657595757",swimidle="rbxassetid://657595757"},["Elder"]={idle1="rbxassetid://845397899",idle2="rbxassetid://845397899",walk="rbxassetid://845403856",run="rbxassetid://845386501",jump="rbxassetid://845398858",fall="rbxassetid://845397673",climb="rbxassetid://845392038",swim="rbxassetid://845397899",swimidle="rbxassetid://845397899"},["Levitate"]={idle1="rbxassetid://616006778",idle2="rbxassetid://616006778",walk="rbxassetid://616013216",run="rbxassetid://616013216",jump="rbxassetid://616008936",fall="rbxassetid://616005863",climb="rbxassetid://616003713",swim="rbxassetid://616006778",swimidle="rbxassetid://616006778"},["Astronaut"]={idle1="rbxassetid://891621366",idle2="rbxassetid://891621366",walk="rbxassetid://891636393",run="rbxassetid://891636393",jump="rbxassetid://891627522",fall="rbxassetid://891617961",climb="rbxassetid://891609353",swim="rbxassetid://891621366",swimidle="rbxassetid://891621366"},["Pirate"]={idle1="rbxassetid://750781874",idle2="rbxassetid://750781874",walk="rbxassetid://750785693",run="rbxassetid://750783738",jump="rbxassetid://750782230",fall="rbxassetid://750780242",climb="rbxassetid://750779899",swim="rbxassetid://750781874",swimidle="rbxassetid://750781874"},["Toy"]={idle1="rbxassetid://782841498",idle2="rbxassetid://782841498",walk="rbxassetid://782843345",run="rbxassetid://782842708",jump="rbxassetid://782847020",fall="rbxassetid://782846423",climb="rbxassetid://782843869",swim="rbxassetid://782841498",swimidle="rbxassetid://782841498"},["Vampire"]={idle1="rbxassetid://1083445855",idle2="rbxassetid://1083445855",walk="rbxassetid://1083473930",run="rbxassetid://1083462077",jump="rbxassetid://1083455352",fall="rbxassetid://1083443587",climb="rbxassetid://1083439238",swim="rbxassetid://1083445855",swimidle="rbxassetid://1083445855"},["Werewolf"]={idle1="rbxassetid://1083195517",idle2="rbxassetid://1083195517",walk="rbxassetid://1083178339",run="rbxassetid://1083216690",jump="rbxassetid://1083218792",fall="rbxassetid://1083189019",climb="rbxassetid://1083182000",swim="rbxassetid://1083195517",swimidle="rbxassetid://1083195517"},["Rthro"]={idle1="rbxassetid://2510196951",idle2="rbxassetid://2510196951",walk="rbxassetid://2510202577",run="rbxassetid://2510198475",jump="rbxassetid://2510197830",fall="rbxassetid://2510195892",climb="rbxassetid://2510192778",swim="rbxassetid://2510196951",swimidle="rbxassetid://2510196951"},["Stylish"]={idle1="rbxassetid://616136790",idle2="rbxassetid://616136790",walk="rbxassetid://616146177",run="rbxassetid://616140816",jump="rbxassetid://616139451",fall="rbxassetid://616134815",climb="rbxassetid://616133594",swim="rbxassetid://616136790",swimidle="rbxassetid://616136790"},}ANIM_PACK_ORDER={{"Off","Off"},{"Cartoon","Cartoon"},{"Adidas Community","Adidas Community"},{"Adidas Aura","Adidas Aura"},{"Catwalk Glam","Catwalk Glam"},{"Amazon Unboxed","Amazon Unboxed"},{"Zombie","Zombie"},{"Ninja","Ninja"},{"Knight","Knight"},{"Elder","Elder"},{"Levitate","Levitate"},{"Astronaut","Astronaut"},{"Pirate","Pirate"},{"Toy","Toy"},{"Vampire","Vampire"},{"Werewolf","Werewolf"},{"Rthro","Rthro"},{"Stylish","Stylish"}}local function isPackAnim(id)for _,pack in pairs(ANIM_PACKS)do for _,v in pairs(pack)do if v==id then return true end end end return false end local function saveOriginalAnims(char)local animate=char:FindFirstChild("Animate")if not animate then return end local function g(obj)return obj and obj.AnimationId or nil end local ids={idle1=g(animate.idle and animate.idle.Animation1),idle2=g(animate.idle and animate.idle.Animation2),walk=g(animate.walk and animate.walk.WalkAnim),run=g(animate.run and animate.run.RunAnim),jump=g(animate.jump and animate.jump.JumpAnim),fall=g(animate.fall and animate.fall.FallAnim),climb=g(animate.climb and animate.climb.ClimbAnim),swim=g(animate.swim and animate.swim.Swim),swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),}if not isPackAnim(ids.walk)then originalTryardAnims=ids end end local function applyAnimPack(packName)currentAnimPack=packName if animSelectorLabel then animSelectorLabel.Text=packName end if packName=="Off"then if originalTryardAnims and LP.Character then local animate=LP.Character:FindFirstChild("Animate")if animate then local function s(obj,id)if obj then obj.AnimationId=id end end s(animate.idle and animate.idle.Animation1,originalTryardAnims.idle1)s(animate.idle and animate.idle.Animation2,originalTryardAnims.idle2)s(animate.walk and animate.walk.WalkAnim,originalTryardAnims.walk)s(animate.run and animate.run.RunAnim,originalTryardAnims.run)s(animate.jump and animate.jump.JumpAnim,originalTryardAnims.jump)s(animate.fall and animate.fall.FallAnim,originalTryardAnims.fall)s(animate.climb and animate.climb.ClimbAnim,originalTryardAnims.climb)s(animate.swim and animate.swim.Swim,originalTryardAnims.swim)s(animate.swimidle and animate.swimidle.SwimIdle,originalTryardAnims.swimidle)end end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect();tryardHeartbeatConn=nil end return end local pack=ANIM_PACKS[packName]if not pack then return end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect()end tryardHeartbeatConn=RunService.Heartbeat:Connect(function()local c=LP.Character if not c then return end local animate=c:FindFirstChild("Animate")if not animate then return end local function s(obj,id)if obj then obj.AnimationId=id end end s(animate.idle and animate.idle.Animation1,pack.idle1)s(animate.idle and animate.idle.Animation2,pack.idle2)s(animate.walk and animate.walk.WalkAnim,pack.walk)s(animate.run and animate.run.RunAnim,pack.run)s(animate.jump and animate.jump.JumpAnim,pack.jump)s(animate.fall and animate.fall.FallAnim,pack.fall)s(animate.climb and animate.climb.ClimbAnim,pack.climb)s(animate.swim and animate.swim.Swim,pack.swim)s(animate.swimidle and animate.swimidle.SwimIdle,pack.swimidle)end)end local function startAnimPack(packName)local char=LP.Character if char then saveOriginalAnims(char)applyAnimPack(packName)local hum=char:FindFirstChildOfClass("Humanoid")if hum then for _,track in ipairs(hum:GetPlayingAnimationTracks())do track:Stop(0)end hum:ChangeState(Enum.HumanoidStateType.Running)end else applyAnimPack(packName)end currentAnimPack=packName end local function stopAnimPack()currentAnimPack="Off"if animSelectorLabel then animSelectorLabel.Text="Off"end applyAnimPack("Off")end DEFAULT_KB={DropBrainrot={kb=Enum.KeyCode.X,gp=nil},AutoLeft={kb=Enum.KeyCode.Z,gp=nil},AutoRight={kb=Enum.KeyCode.C,gp=nil},AutoBat={kb=Enum.KeyCode.E,gp=nil},TPFloor={kb=Enum.KeyCode.F,gp=nil},GuiHide={kb=Enum.KeyCode.LeftControl,gp=nil},CarryToggle={kb=Enum.KeyCode.Q,gp=nil},LaggerMode={kb=Enum.KeyCode.R,gp=nil},BatV2={kb=Enum.KeyCode.V,gp=nil},TPBat={kb=Enum.KeyCode.T,gp=nil},Float={kb=Enum.KeyCode.B,gp=nil},InstantReset={kb=Enum.KeyCode.K,gp=nil},}KB={DropBrainrot={kb=DEFAULT_KB.DropBrainrot.kb,gp=DEFAULT_KB.DropBrainrot.gp},AutoLeft={kb=DEFAULT_KB.AutoLeft.kb,gp=DEFAULT_KB.AutoLeft.gp},AutoRight={kb=DEFAULT_KB.AutoRight.kb,gp=DEFAULT_KB.AutoRight.gp},AutoBat={kb=DEFAULT_KB.AutoBat.kb,gp=DEFAULT_KB.AutoBat.gp},TPFloor={kb=DEFAULT_KB.TPFloor.kb,gp=DEFAULT_KB.TPFloor.gp},GuiHide={kb=DEFAULT_KB.GuiHide.kb,gp=DEFAULT_KB.GuiHide.gp},CarryToggle={kb=DEFAULT_KB.CarryToggle.kb,gp=DEFAULT_KB.CarryToggle.gp},LaggerMode={kb=DEFAULT_KB.LaggerMode.kb,gp=DEFAULT_KB.LaggerMode.gp},BatV2={kb=DEFAULT_KB.BatV2.kb,gp=DEFAULT_KB.BatV2.gp},TPBat={kb=DEFAULT_KB.TPBat.kb,gp=DEFAULT_KB.TPBat.gp},Float={kb=DEFAULT_KB.Float.kb,gp=DEFAULT_KB.Float.gp},InstantReset={kb=DEFAULT_KB.InstantReset.kb,gp=DEFAULT_KB.InstantReset.gp},}_isResetting=false _lastSavedJSON=nil _isLoading=false CONFIG={AUTO_STEAL_ENABLED=false,STEAL_RANGE=65,HOLD_MIN=0.05,HOLD_MAX=0.15,ENTRY_DELAY=0.1,COOLDOWN=0.2,PRIME_RANGE=60,}local plots=workspace:WaitForChild("Plots")local stealConnection=nil local Steal={AutoStealEnabled=false,StealRadius=CONFIG.STEAL_RANGE,StealDuration=1.3,StealDelay=0.25,Data={}}local isStealing=false local autoStealMode="V1" stealBarStyle="V1"local autoGrabSetDelayRadius=9 local autoGrabStopTime=0.96 local autoGrabStopEnabled=true local _plotsCache=nil local _plotsCacheTime=0 local function getPlotsRoot()local now=_tick()if _plotsCache and now-_plotsCacheTime<2 and _plotsCache.Parent then return _plotsCache end _plotsCache=workspace:FindFirstChild("Plots")_plotsCacheTime=now return _plotsCache end local function isMyPlotByName(plotName)local plotsRoot=getPlotsRoot()if not plotsRoot then return false end local plot=plotsRoot:FindFirstChild(plotName)if not plot then return false end local sign=plot:FindFirstChild("PlotSign")if sign then local yb=sign:FindFirstChild("YourBase")if yb and yb:IsA("BillboardGui")then return yb.Enabled==true end end return false end local function findNearestPrompt()local char=LP.Character if not char then return nil,nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil,nil end local plotsRoot=getPlotsRoot()if not plotsRoot then return nil,nil end local nearestPrompt,nearestDist,nearestName=nil,_huge,nil local rpos=root.Position for _,plot in ipairs(plotsRoot:GetChildren())do if isMyPlotByName(plot.Name)then continue end local pods=plot:FindFirstChild("AnimalPodiums")if not pods then continue end for _,pod in ipairs(pods:GetChildren())do pcall(function()local base=pod:FindFirstChild("Base")local spawn=base and base:FindFirstChild("Spawn")if spawn then local sp=spawn.Position local dx=sp.X-rpos.X local dy=sp.Y-rpos.Y local dz=sp.Z-rpos.Z local dist=_sqrt(dx*dx+dy*dy+dz*dz)if dist<nearestDist and dist<=Steal.StealRadius then local att=spawn:FindFirstChild("PromptAttachment")if att then for _,child in ipairs(att:GetChildren())do if child:IsA("ProximityPrompt")and child.ActionText and child.ActionText:find("Steal")then nearestPrompt=child nearestDist=dist nearestName=pod.Name break end end end end end end)end end return nearestPrompt,nearestName end local function executeSteal(prompt,podName)if isStealing then return end if math.random(30)==1 then for p in pairs(Steal.Data)do if not p.Parent then Steal.Data[p]=nil end end end if not Steal.Data[prompt]then Steal.Data[prompt]={hold={},trigger={},ready=true}pcall(function()if getconnections then for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan))do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function)end end for _,c in ipairs(getconnections(prompt.Triggered))do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function)end end end end)end local data=Steal.Data[prompt]if not data.ready then return end data.ready=false isStealing=true updateStealProgress(0,"STEALING")task.spawn(function()for _,f in ipairs(data.hold)do task.spawn(f)end local startTime=_tick()local duration=Steal.StealDuration local promptFired=false if autoGrabStopEnabled then while isStealing and Steal.AutoStealEnabled do local elapsed=_tick()-startTime if elapsed>=autoGrabStopTime then break end local progress=_clamp(elapsed/duration,0,1)updateStealProgress(progress,"STEALING")if not prompt.Parent or not prompt.Parent.Parent then break end local char=LP.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")if hrp and(hrp.Position-prompt.Parent.Parent.Position).Magnitude>Steal.StealRadius then break end task.wait()end local stopProgress=_clamp(autoGrabStopTime/duration,0,1)updateStealProgress(stopProgress,"STEALING")local phase2Timeout=math.max(2.99-autoGrabStopTime-math.max(duration-autoGrabStopTime,0),0.05)local phase2Start=_tick()while isStealing and Steal.AutoStealEnabled do if _tick()-phase2Start>=phase2Timeout then updateStealProgress(0,"CANCELLED")data.ready=true isStealing=false task.wait()local newPrompt,newName=findNearestPrompt()if newPrompt then executeSteal(newPrompt,newName)end return end if not prompt.Parent or not prompt.Parent.Parent then isStealing=false updateStealProgress(0,"CANCELLED")data.ready=true return end local char=LP.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")if hrp then local dist=(hrp.Position-prompt.Parent.Parent.Position).Magnitude if dist<=autoGrabSetDelayRadius then break elseif dist>Steal.StealRadius then isStealing=false updateStealProgress(0,"CANCELLED")data.ready=true return end end task.wait()end if isStealing and Steal.AutoStealEnabled then local fillStart=_tick()local fillDuration=math.max(duration-autoGrabStopTime,0.05)while true do local fp=_clamp((_tick()-fillStart)/fillDuration,0,1)local totalProgress=stopProgress+fp*(1-stopProgress)updateStealProgress(totalProgress,"STEALING")if fp>=1 and not promptFired then promptFired=true pcall(function()for _,f in ipairs(data.trigger)do task.spawn(f)end local remote=ReplicatedStorage:FindFirstChild("StealAnimal")if remote and podName then remote:FireServer(podName)end if prompt then prompt:Fire()end end)break end task.wait()end end else while isStealing and Steal.AutoStealEnabled do local elapsed=_tick()-startTime local progress=_clamp(elapsed/duration,0,1)updateStealProgress(progress,"STEALING")if not prompt.Parent or not prompt.Parent.Parent then break end local char=LP.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")if hrp and(hrp.Position-prompt.Parent.Parent.Position).Magnitude>Steal.StealRadius then break end if elapsed>=duration and not promptFired then promptFired=true pcall(function()for _,f in ipairs(data.trigger)do task.spawn(f)end local remote=ReplicatedStorage:FindFirstChild("StealAnimal")if remote and podName then remote:FireServer(podName)end if prompt then prompt:Fire()end end)break end task.wait()end end updateStealProgress(0,"READY")data.ready=true isStealing=false end)end function startAutoSteal()if stealConnection then local connected=false pcall(function()connected=stealConnection.Connected==true end)if connected then Steal.StealRadius=CONFIG.STEAL_RANGE Steal.AutoStealEnabled=true CONFIG.AUTO_STEAL_ENABLED=true return true end pcall(function()stealConnection:Disconnect()end)stealConnection=nil end Steal.StealRadius=CONFIG.STEAL_RANGE Steal.AutoStealEnabled=true CONFIG.AUTO_STEAL_ENABLED=true local v2Accumulator=0 stealConnection=RunService.Heartbeat:Connect(function(dt)if not Steal.AutoStealEnabled or isStealing then return end if autoStealMode=="V2"then v2Accumulator=v2Accumulator+(dt or 0)if v2Accumulator<0.25 then return end v2Accumulator=0 end local p,n=findNearestPrompt()if p then executeSteal(p,n)end end)return true end function stopAutoSteal()if stealConnection then stealConnection:Disconnect()stealConnection=nil end isStealing=false Steal.AutoStealEnabled=false CONFIG.AUTO_STEAL_ENABLED=false updateStealProgress(0,"READY")end medusaDebounce=false medusaLastUsed=0 dropActive=false lastDropTime=0 lastMoveDir=_V3new(0,0,0)origFOV=nil fovEnabled=false fovValue=70 customFovConn=nil _anyKeyListening=false _aimbotConn=nil _prevAutoRotate=nil tpBatConn=nil tpBatPrevAutoRotate=nil tpBatHitCD=false TP_BAT_SWING_CD=0.08 enemySpeedConn=nil movementLoop=nil steppedConn=nil alConn=nil arConn=nil infJumpConn=nil stretchConn=nil stretchFovConn=nil antiLagDescConn=nil medusaResetConns={}dropConnections={}enemySpeedLabels={}Conns={autoSteal=nil,batCounter=nil,anchor={},progress=nil,autoLeft=nil,autoRight=nil}keyButtonRefs={}progressFill=nil progressPct=nil progressStatus=nil progressTween=nil pbFrame=nil speedLabel=nil modeValLbl=nil normalBox,carryBox,laggerBox,lagger2Box,radInput,batSpeedBox,uiScaleBox,stealBarScaleBox=nil,nil,nil,nil,nil,nil,nil,nil modeSelectBtn,dropModeBtnRef=nil,nil autoBatSetVisual,autoLeftSetVisual,autoRightSetVisual,setBatCounterVisual,setMedusaVisual=nil,nil,nil,nil,nil setAntiRagVisual,setUnwalkVisual,setAntiLagVisual,setLockUIVisual,setInstaGrab=nil,nil,nil,nil,nil infJumpSetVisual=nil infJumpModeBtn=nil autoStealModeBtn=nil setAntiDieVisual=nil setAntiBatVisual=nil setAntiFlingVisual=nil setESPVIsual=nil setESPLineVisual=nil mobSetAutoBat,mobSetAutoLeft,mobSetAutoRight,mobSetDropBR,mobSetTpDown,mobSetCarry,mobSetLagger1,mobSetLagger2,mobSetBatV2,mobSetBatTP=nil,nil,nil,nil,nil,nil,nil,nil,nil,nil mobSetFloat=nil autoCarryEnabled=false autoCarryMode="On Pick Up"miniBtn,main,gui=nil,nil,nil MobilePanel=nil showGui=nil hideGui=nil mainUIScale=nil animSelectorLabel=nil pbScale=nil tabButtons=nil colorSelectorLabel=nil GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true,}MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,}BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}AP={L1=_V3new(-476.48,-6.28,92.73),L2=_V3new(-483.12,-4.95,94.80),L_FACE=_V3new(-482.25,-4.96,92.09),R1=_V3new(-476.16,-6.52,25.62),R2=_V3new(-483.06,-5.03,25.48),R_FACE=_V3new(-482.06,-6.93,35.47),}function isGamepadInput(inp)return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end function isBindableInput(inp)if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end if inp.UserInputType==Enum.UserInputType.Keyboard then return true end return isGamepadInput(inp)and GAMEPAD_KEYS[inp.KeyCode]==true end function kbMatch(entry,kc)return kc and(kc==entry.kb or(entry.gp and kc==entry.gp))end function updateStealProgress(value,state)value=_clamp(tonumber(value)or 0,0,1)state=state or(value>0 and"STEALING"or"READY")if progressTween then pcall(function()progressTween:Cancel()end)end if progressFill then local isV2=(stealBarStyle=="V2") local pad=isV2 and 2 or 0 local target=UDim2.new(value,pad>0 and -pad*2 or 0,1,pad>0 and -pad*2 or 0)progressFill.Position=UDim2.new(0,pad,0,pad) local dur=(value<=0.001)and 0.05 or 0.08 progressTween=TS:Create(progressFill,TweenInfo.new(dur,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{Size=target})progressTween:Play()local grad=progressFill:FindFirstChild("FillGrad")local lastState=progressFill:GetAttribute("LastStealState")if lastState~=state then progressFill:SetAttribute("LastStealState",state)if state=="CANCELLED"then progressFill.BackgroundColor3=Color3.fromRGB(255,80,90)if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,180,120)),ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255,90,70)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(180,30,40)),})end elseif state=="COMPLETE"then progressFill.BackgroundColor3=Color3.fromRGB(70,255,160)if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(200,255,220)),ColorSequenceKeypoint.new(0.50,Color3.fromRGB(80,255,160)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(30,180,100)),})end else progressFill.BackgroundColor3=Color3.fromRGB(255,160,45)if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,252,230)),ColorSequenceKeypoint.new(0.15,Color3.fromRGB(255,235,150)),ColorSequenceKeypoint.new(0.40,Color3.fromRGB(255,185,65)),ColorSequenceKeypoint.new(0.70,Color3.fromRGB(255,140,35)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(200,80,14)),})end end end end if progressPct then progressPct.Text=_floor(value*100+0.5).."%"progressPct.TextTransparency=0 end if progressStatus then progressStatus.Text=state if state=="STEALING"then progressStatus.TextColor3=Color3.fromRGB(255,220,120)elseif state=="COMPLETE"then progressStatus.TextColor3=Color3.fromRGB(120,255,190)elseif state=="CANCELLED"then progressStatus.TextColor3=Color3.fromRGB(255,120,120)else progressStatus.TextColor3=Color3.fromRGB(255,210,150)end end if pbFrame then local stroke=pbFrame:FindFirstChild("OuterStroke")if stroke then if state=="STEALING"then stroke.Color=Color3.fromRGB(255,200,80)elseif state=="COMPLETE"then stroke.Color=Color3.fromRGB(90,255,160)elseif state=="CANCELLED"then stroke.Color=Color3.fromRGB(255,90,90)else stroke.Color=Color3.fromRGB(255,175,55)end end end end function resetProgressBar()updateStealProgress(0,"READY")end local function doTpDown()pcall(function()local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if not root then return end local _,yaw=root.CFrame:ToEulerAnglesYXZ()root.CFrame=_CFnew(root.Position.X,-7,root.Position.Z)*CFrame.Angles(0,yaw,0)root.AssemblyLinearVelocity=_V3zero root.AssemblyAngularVelocity=_V3zero end)end _G._VynxRunTPDown=doTpDown _G._VynxTPDownIsAutoOn=function()return false end do local old=rawget(_G,"__RivalHubFloat")if type(old)=="table"then local wasOn=old.running==true or old.conn~=nil old.running=false old.cycleToken=(old.cycleToken or 0)+1 if old.thread then pcall(task.cancel,old.thread);old.thread=nil end if old.conn then pcall(function()old.conn:Disconnect()end);old.conn=nil end if wasOn and type(old.groundTP)=="function"then pcall(old.groundTP)end end end _G.__RivalHubFloat={RISE=17,RATE=55,CYCLE=2.5,PAUSE=0.5,SAMPLE=0.08,PIT_MARGIN=15,conn=nil,thread=nil,running=false,locked=false,targetY=nil,baseY=nil,baseGround=nil,safeValid=false,safeX=0,safeZ=0,safeY=0,cycleToken=0,_params=nil,}function _G.__RivalHubFloat.getHRP()local c=LP.Character if not c then return nil,nil end return c:FindFirstChild("HumanoidRootPart"),c:FindFirstChildOfClass("Humanoid")end function _G.__RivalHubFloat.arm()if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource,"float",true)end end function _G.__RivalHubFloat.release()if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource,"float",false)end end function _G.__RivalHubFloat.findGround(char,hrp)local FLOAT=_G.__RivalHubFloat local params=FLOAT._params if not params then params=RaycastParams.new()params.FilterType=Enum.RaycastFilterType.Exclude params.IgnoreWater=true pcall(function()params.RespectCanCollide=true end)FLOAT._params=params end local filter={char}local plist=_GetPlayersCached()for i=1,#plist do local plr=plist[i]if plr~=LP and plr.Character then filter[#filter+1]=plr.Character end end local half=hrp.Size.Y*0.5 if half<=0 then half=1 end local origin=hrp.Position local startY=origin.Y-half-0.1 for _=1,6 do params.FilterDescendantsInstances=filter local res=Workspace:Raycast(Vector3.new(origin.X,startY,origin.Z),Vector3.new(0,-1000,0),params)if not res then return nil,half end local part=res.Instance if part and part:IsA("BasePart")and part.CanCollide then local model=part:FindFirstAncestorOfClass("Model")if not(model and model:FindFirstChildOfClass("Humanoid"))then return res.Position.Y,half end end if part then filter[#filter+1]=part end startY=res.Position.Y-0.05 end return nil,half end function _G.__RivalHubFloat.isSafeGround(g)local FLOAT=_G.__RivalHubFloat if not g then return false end if FLOAT.baseGround and g<FLOAT.baseGround-FLOAT.PIT_MARGIN then return false end return true end function _G.__RivalHubFloat.groundTP()local FLOAT=_G.__RivalHubFloat local char=LP.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if not hrp or not hum or hum.Health<=0 then return end local pos=hrp.Position local x,z=pos.X,pos.Z local groundY,half pcall(function()groundY,half=FLOAT.findGround(char,hrp)end)local relocated=false if not FLOAT.isSafeGround(groundY)and FLOAT.safeValid then x,z,groundY=FLOAT.safeX,FLOAT.safeZ,FLOAT.safeY relocated=true end local targetY if groundY then half=half or math.max(hrp.Size.Y*0.5,1)local off=half*3 if hum.RigType~=Enum.HumanoidRigType.R6 then off=half+(hum.HipHeight or(half*2))end if off~=off or off<1 or off>12 then off=half*3 end targetY=groundY+off+0.15 elseif FLOAT.baseY then targetY=FLOAT.baseY end if targetY and targetY==targetY and targetY>-400 then pcall(function()if not relocated and pos.Y-targetY<0.5 then hrp.AssemblyLinearVelocity=Vector3.zero return end hrp.CFrame=CFrame.new(x,targetY,z)*hrp.CFrame.Rotation hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero end)end end function _G.__RivalHubFloat.startLoop()local FLOAT=_G.__RivalHubFloat if FLOAT.conn then return end FLOAT.locked=false FLOAT.targetY=nil local char0=LP.Character local root0=char0 and char0:FindFirstChild("HumanoidRootPart")local hum0=char0 and char0:FindFirstChildOfClass("Humanoid")if hum0 then pcall(function()hum0:ChangeState(Enum.HumanoidStateType.Freefall)end)end FLOAT.safeValid=false FLOAT.baseGround=nil if char0 and root0 then local ok,g=pcall(FLOAT.findGround,char0,root0)if ok and g then FLOAT.baseGround=g FLOAT.safeX,FLOAT.safeZ,FLOAT.safeY=root0.Position.X,root0.Position.Z,g FLOAT.safeValid=true end end local cChar,cRoot,cHum=nil,nil,nil local sampleT=0 FLOAT.conn=RunService.Heartbeat:Connect(function(dt)local char=LP.Character if char~=cChar or not cRoot or not cRoot.Parent then cChar=char cRoot=char and char:FindFirstChild("HumanoidRootPart")or nil cHum=char and char:FindFirstChildOfClass("Humanoid")or nil end if not cRoot or not cHum or cHum.Health<=0 then return end local cf=cRoot.CFrame local pos=cf.Position local vel=cRoot.AssemblyLinearVelocity sampleT=sampleT+dt if sampleT>=FLOAT.SAMPLE then sampleT=0 local ok,g=pcall(FLOAT.findGround,cChar,cRoot)if ok and FLOAT.isSafeGround(g)then FLOAT.safeX,FLOAT.safeZ,FLOAT.safeY=pos.X,pos.Z,g FLOAT.safeValid=true elseif ok and FLOAT.safeValid then pos=Vector3.new(FLOAT.safeX,pos.Y,FLOAT.safeZ)vel=Vector3.new(0,vel.Y,0)end end if not FLOAT.targetY then FLOAT.baseY=pos.Y FLOAT.targetY=pos.Y+FLOAT.RISE end local y=FLOAT.targetY if not FLOAT.locked then y=math.min(pos.Y+FLOAT.RATE*dt,FLOAT.targetY)if y>=FLOAT.targetY then FLOAT.locked=true end end cRoot.CFrame=CFrame.new(pos.X,y,pos.Z)*cf.Rotation cRoot.AssemblyLinearVelocity=Vector3.new(vel.X,0,vel.Z)end)end function _G.__RivalHubFloat.stopLoop(tpDown)local FLOAT=_G.__RivalHubFloat if FLOAT.conn then pcall(function()FLOAT.conn:Disconnect()end)FLOAT.conn=nil end if tpDown then pcall(FLOAT.groundTP)end end function _G.__RivalHubFloat.waitGrounded(timeout)local FLOAT=_G.__RivalHubFloat local deadline=os.clock()+(timeout or 3)while os.clock()<deadline do if not FLOAT.running then return end local hrp,hum=FLOAT.getHRP()if not hrp or not hum then return end if hum.Health<=0 then return end if hum.FloorMaterial~=Enum.Material.Air then task.wait(FLOAT.PAUSE)return end RunService.Heartbeat:Wait()end end function _G.__RivalHubFloat.spawnCycle()local FLOAT=_G.__RivalHubFloat if FLOAT.thread then pcall(task.cancel,FLOAT.thread);FLOAT.thread=nil end FLOAT.cycleToken=FLOAT.cycleToken+1 local token=FLOAT.cycleToken FLOAT.thread=task.spawn(function()while FLOAT.running and FLOAT.cycleToken==token do task.wait(FLOAT.CYCLE)if not FLOAT.running or FLOAT.cycleToken~=token then break end FLOAT.stopLoop(true)FLOAT.waitGrounded(3)if not FLOAT.running or FLOAT.cycleToken~=token then break end FLOAT.startLoop()end end)end function _G.__RivalHubFloat.enable()local FLOAT=_G.__RivalHubFloat if FLOAT.running then return end FLOAT.running=true FLOAT.arm()FLOAT.startLoop()FLOAT.spawnCycle()end function _G.__RivalHubFloat.disable()local FLOAT=_G.__RivalHubFloat if not FLOAT.running then return end FLOAT.running=false FLOAT.cycleToken=FLOAT.cycleToken+1 if FLOAT.thread then pcall(task.cancel,FLOAT.thread);FLOAT.thread=nil end FLOAT.stopLoop(true)FLOAT.safeValid=false FLOAT.baseGround=nil FLOAT.release()end function _G.__RivalHubFloatToggle()local F=_G.__RivalHubFloat if F.running then F.disable()else F.enable()end if _G.__RivalHubFloatSetVisual then pcall(_G.__RivalHubFloatSetVisual,F.running)end if mobSetFloat then pcall(mobSetFloat,F.running)end end function _G.__RivalHubFloatIsRunning()return _G.__RivalHubFloat.running==true end do local old=rawget(_G,"__RivalHubAutoCarryStop")if type(old)=="function"then pcall(old)end _G._VynxAutoSpeedRange=tonumber(_G._VynxAutoSpeedRange)or 12 local state={active=false,previous=nil,graceUntil=0,conn=nil}local soft={spots={},nextScan=0,latched=false,held=false,armed=true}local function getFamily()if laggerToggled or laggerCarryToggled then return"lagger"end return"normal"end local function getCarry()return(speedMode==true)or(laggerCarryToggled==true)end local function setFamilyCarry(family,carry)carry=carry==true if family=="lagger"then laggerCarryToggled=carry laggerToggled=not carry speedMode=false else laggerToggled=false laggerCarryToggled=false speedMode=carry end end local function refresh()if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel)end if mobSetCarry then pcall(mobSetCarry,speedMode==true)end if mobSetLagger1 then pcall(mobSetLagger1,laggerToggled==true)end if mobSetLagger2 then pcall(mobSetLagger2,laggerCarryToggled==true)end if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end local function isWeaponName(value)local n=tostring(value or""):lower()return n:find("bat")or n:find("slap")or n:find("medusa")or n:find("head")or n:find("stone")end local function isCarrying(character)if not character then return false end if LP:GetAttribute("Stealing")==true or LP:GetAttribute("AntiKick")==true or character:GetAttribute("Stealing")==true then return true end for _,entry in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"})do local inst=character:FindFirstChild(entry,true)if inst and((inst:IsA("BoolValue")and inst.Value)or(inst:IsA("ObjectValue")and inst.Value)or(inst:IsA("StringValue")and inst.Value~=""))then return true end end for _,child in ipairs(character:GetChildren())do local n=child.Name:lower()if child:IsA("Tool")and not isWeaponName(n)then return true end local bp=child:IsA("Model")and child:FindFirstChildWhichIsA("BasePart",true)local hit if bp then hit=n:find("brainrot")or n:find("animal")or n:find("carry")or n:find("grab")or n:find("steal")or n:find("hold")else hit=bp end if hit then return true end end return false end local function enable()if state.active then state.graceUntil=tick()+0.75 return end state.previous={family=getFamily(),carry=getCarry()}state.active=true state.graceUntil=tick()+0.75 setFamilyCarry(getFamily(),true)refresh()end local function restore()if not state.active then return end local previous=state.previous state.active=false state.previous=nil if previous then setFamilyCarry(previous.family,previous.carry)end refresh()end local function softEnable()if not state.active then state.previous={family=getFamily(),carry=getCarry()}state.active=true end state.graceUntil=tick()+0.75 setFamilyCarry(getFamily(),true)refresh()end local function scanSpots()local spots={}local plots=workspace:FindFirstChild("Plots")if not plots then soft.spots=spots;return end for _,child in ipairs(plots:GetChildren())do local sign=child:FindFirstChild("PlotSign")sign=sign and sign:FindFirstChild("YourBase")if not(sign and sign:IsA("BillboardGui")and sign.Enabled==true)then local pods=child:FindFirstChild("AnimalPodiums")if pods then for _,pod in ipairs(pods:GetChildren())do local base=pod:FindFirstChild("Base")base=base and base:FindFirstChild("Spawn")if base then spots[#spots+1]=base.Position end end end end end soft.spots=spots end local function nearStealSpot(character)local root=character and character:FindFirstChild("HumanoidRootPart")if not root then return false end local range=tonumber(_G._VynxAutoSpeedRange)or 15 local target=_G._VantaStealTargetPos or _G._RaVeStealTargetPos if typeof(target)=="Vector3"and(root.Position-target).Magnitude<=range then return true end local now=tick()if soft.nextScan<=now then soft.nextScan=now+0.5 scanSpots()end for _,spot in ipairs(soft.spots)do if(root.Position-spot).Magnitude<=range then return true end end return false end local function startAutoCarry()if state.conn then state.conn:Disconnect()end state.conn=RunService.RenderStepped:Connect(function()if not autoCarryEnabled then restore();return end local character=LP.Character local humanoid=character and character:FindFirstChildOfClass("Humanoid")if not character or not humanoid or humanoid.Health<=0 then restore();return end if autoCarryMode=="Soft Steal"then local near=nearStealSpot(character)local carrying=isCarrying(character)local away=not near if away then soft.armed=true end if away or getCarry()~=true then soft.latched=false end if near and soft.armed and not soft.latched then soft.latched=true soft.held=false softEnable()end if state.active then if carrying then soft.held=true state.graceUntil=tick()+0.75 elseif soft.held then soft.held=false soft.latched=false soft.armed=false restore()else local away2=not near if away2 then away2=tick()>state.graceUntil end if away2 then soft.latched=false restore()end end end return end if isCarrying(character)then enable()elseif state.active then restore()end end)end local function stopAutoCarry()if state.conn then state.conn:Disconnect()state.conn=nil end soft.latched=false soft.held=false soft.armed=true restore()end local charConn=LP.CharacterAdded:Connect(function()soft.latched=false soft.held=false soft.armed=true end)_G.__RivalHubAutoCarryStop=function()stopAutoCarry()pcall(function()charConn:Disconnect()end)end _G.__RivalHubAutoCarryRestore=restore startAutoCarry()end local AntiRagdollV1={}AntiRagdollV1.__index=AntiRagdollV1 local BOOST_SPEED=400 local AR_DEFAULT_SPEED=16 local stateV1={active=false,isBoosting=false,cachedChar=nil,ragdollConnections={},}local function disconnectAllV1()for _,conn in ipairs(stateV1.ragdollConnections)do pcall(function()conn:Disconnect()end)end stateV1.ragdollConnections={}end local function cacheCharacterV1()local char=LP.Character if not char then return false end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum or not root then return false end stateV1.cachedChar={character=char,humanoid=hum,root=root}return true end local function isRagdolledV1()if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end local hum=stateV1.cachedChar.humanoid local st=hum:GetState()local ragdollStates={[Enum.HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=true,}return ragdollStates[st]or false end local function forceExitRagdollV1()if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end local hum=stateV1.cachedChar.humanoid local root=stateV1.cachedChar.root pcall(function()LP:SetAttribute("RagdollEndTime",workspace:GetServerTimeNow())end)for _,descendant in ipairs(stateV1.cachedChar.character:GetDescendants())do if descendant:IsA("BallSocketConstraint")or(descendant:IsA("Attachment")and descendant.Name:find("RagdollAttachment"))then descendant:Destroy()end end if not stateV1.isBoosting then stateV1.isBoosting=true hum.WalkSpeed=BOOST_SPEED end if hum.Health>0 then hum:ChangeState(Enum.HumanoidStateType.Running)end root.Anchored=false end local function heartbeatLoopV1()while stateV1.active do task.wait()if isRagdolledV1()then forceExitRagdollV1()elseif stateV1.isBoosting and not isRagdolledV1()then stateV1.isBoosting=false if stateV1.cachedChar and stateV1.cachedChar.humanoid then stateV1.cachedChar.humanoid.WalkSpeed=AR_DEFAULT_SPEED end end end end function AntiRagdollV1.start()if stateV1.active then return end AntiRagdollV1.stop()if not cacheCharacterV1()then warn("[AntiRagdollV1] No se pudo cachear el personaje")return end stateV1.active=true stateV1.isBoosting=false local camConn=RunService.RenderStepped:Connect(function()local cam=workspace.CurrentCamera if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then cam.CameraSubject=stateV1.cachedChar.humanoid end end)table.insert(stateV1.ragdollConnections,camConn)local respawnConn=LP.CharacterAdded:Connect(function()stateV1.isBoosting=false task.wait(0.5)cacheCharacterV1()end)table.insert(stateV1.ragdollConnections,respawnConn)task.spawn(heartbeatLoopV1)print("[AntiRagdollV1] Activado")end function AntiRagdollV1.stop()stateV1.active=false if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then stateV1.cachedChar.humanoid.WalkSpeed=AR_DEFAULT_SPEED end stateV1.isBoosting=false disconnectAllV1()stateV1.cachedChar=nil print("[AntiRagdollV1] Desactivado")end function AntiRagdollV1.isRunning()return stateV1.active end local AntiRagdollV2={Enabled=false,Connection=nil,ResetCooldown=0,}local function startAntiRagdollV2()if AntiRagdollV2.Connection then return end AntiRagdollV2.Enabled=true AntiRagdollV2.Connection=RunService.Heartbeat:Connect(function()if not AntiRagdollV2.Enabled then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum or not root then return end if hum.Health<=0 or hum:GetState()==Enum.HumanoidStateType.Dead then return end local state=hum:GetState()local now=_tick()if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown then if now-AntiRagdollV2.ResetCooldown>0.15 then AntiRagdollV2.ResetCooldown=now pcall(function()if hum:GetState()==Enum.HumanoidStateType.GettingUp then return end if hum.Health<=0 or hum:GetState()==Enum.HumanoidStateType.Dead then return end hum:ChangeState(Enum.HumanoidStateType.GettingUp)root.Velocity=_V3zero root.RotVelocity=_V3zero root.AssemblyLinearVelocity=_V3zero root.AssemblyAngularVelocity=_V3zero for _,obj in ipairs(char:GetDescendants())do if obj:IsA("Motor6D")then obj.Enabled=true end if obj:IsA("Constraint")then obj.Enabled=true end end workspace.CurrentCamera.CameraSubject=hum local PM=LP.PlayerScripts:FindFirstChild("PlayerModule")if PM then local CM=require(PM:FindFirstChild("ControlModule"))if CM then CM:Enable()end end hum.AutoRotate=true hum.PlatformStand=false hum.Sit=false end)end end end)end local function stopAntiRagdollV2()AntiRagdollV2.Enabled=false if AntiRagdollV2.Connection then AntiRagdollV2.Connection:Disconnect()AntiRagdollV2.Connection=nil end AntiRagdollV2.ResetCooldown=0 end function setAntiRagdollMode(mode)if AntiRagdollV1.isRunning()then AntiRagdollV1.stop()end if AntiRagdollV2.Enabled then stopAntiRagdollV2()end antiRagdollMode=mode if mode=="v1"then AntiRagdollV1.start()elseif mode=="v2"then startAntiRagdollV2()end if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(mode)end saveAllSettings()end _antiDieEnabled=false _antiDieStopped=false _antiDieSources={toggle=false,autobat=false,float=false}_antiDie={enabled=false,loop=nil,healthConn=nil,charConn=nil,lastHealTime=0,invincibleUntil=0,config={healthThreshold=50,invincibilityFrames=0.75,fallDamageProtection=false,ragdollProtection=true,autoRevive=true,},}function _antiDie.SuperHeal(hum)if not hum or not hum.Parent then return end local maxHealth=hum.MaxHealth or 100 if maxHealth<=0 or maxHealth==math.huge then maxHealth=100 end pcall(function()hum.Health=maxHealth if hum.MaxHealth<maxHealth then hum.MaxHealth=maxHealth end end)_antiDie.invincibleUntil=_tick()+_antiDie.config.invincibilityFrames _antiDie.lastHealTime=_tick()pcall(function()local char=hum.Parent if not char then return end for _,child in ipairs(char:GetChildren())do if child:IsA("NumberValue")then local name=child.Name:lower()if name:find("health")or name:find("hp")or name:find("life")then child.Value=maxHealth end end if child:IsA("BoolValue")and child.Name:lower():find("dead")then child.Value=false end end end)end function _antiDie.PreventDamage(root,hum)if not hum then return end if hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end if _tick()<_antiDie.invincibleUntil then if hum.Health<(hum.MaxHealth or 100)then hum.Health=hum.MaxHealth or 100 end end if _antiDie.config.ragdollProtection then local state=hum:GetState()if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Dead then pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)hum:ChangeState(Enum.HumanoidStateType.Running)end)_antiDie.SuperHeal(hum)if root then pcall(function()root.AssemblyAngularVelocity=Vector3.zero end)end end end if hum.Health<=0 then _antiDie.SuperHeal(hum)pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)hum:ChangeState(Enum.HumanoidStateType.Running)end)if root then pcall(function()root.CFrame=CFrame.new(root.Position+Vector3.new(0,2,0))root.AssemblyLinearVelocity=Vector3.zero end)end end end function _antiDie.AutoRevive()if not _antiDie.config.autoRevive then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum then return end if hum.Health<=0 then _antiDie.SuperHeal(hum)pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)hum:ChangeState(Enum.HumanoidStateType.Running)end)if root then pcall(function()root.CFrame=CFrame.new(root.Position+Vector3.new(0,3,0))root.AssemblyLinearVelocity=Vector3.zero end)end end end function _antiDie.AttachHealth(char)if _antiDie.healthConn then _antiDie.healthConn:Disconnect();_antiDie.healthConn=nil end local hum=char and char:FindFirstChildOfClass("Humanoid")if not hum then hum=char and char:WaitForChild("Humanoid",3)end if not hum then return end _antiDie.healthConn=hum:GetPropertyChangedSignal("Health"):Connect(function()if not _antiDie.enabled then return end if hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end if hum.Health<=0 then _antiDie.AutoRevive()end end)if hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end end function _antiDie.StartEngine()if _antiDie.enabled and _antiDie.loop then return end _antiDie.enabled=true _antiDieEnabled=true antiDieEnabled=true if _antiDie.loop then _antiDie.loop:Disconnect();_antiDie.loop=nil end if _antiDie.healthConn then _antiDie.healthConn:Disconnect();_antiDie.healthConn=nil end _antiDie.loop=RunService.Heartbeat:Connect(function()if not _antiDie.enabled then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum then return end if hum.Health<=0 then _antiDie.AutoRevive()elseif hum.Health<=_antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)elseif hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end _antiDie.PreventDamage(root,hum)end)if LP.Character then _antiDie.AttachHealth(LP.Character)end if _antiDie.charConn then _antiDie.charConn:Disconnect();_antiDie.charConn=nil end _antiDie.charConn=LP.CharacterAdded:Connect(function(char)if not _antiDie.enabled then return end task.wait(0.05)_antiDie.AttachHealth(char)local hum=char:FindFirstChildOfClass("Humanoid")if hum then _antiDie.SuperHeal(hum)end end)end function _antiDie.StopEngine()_antiDie.enabled=false _antiDieEnabled=false antiDieEnabled=false if _antiDie.loop then _antiDie.loop:Disconnect();_antiDie.loop=nil end if _antiDie.healthConn then _antiDie.healthConn:Disconnect();_antiDie.healthConn=nil end if _antiDie.charConn then _antiDie.charConn:Disconnect();_antiDie.charConn=nil end pcall(function()local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if not hum then return end hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true)hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)hum.BreakJointsOnDeath=true if hum.MaxHealth==math.huge or hum.MaxHealth<=0 then hum.MaxHealth=100 hum.Health=math.min(hum.Health,100)end end)end function _antiDieSetEnabled(enabled)enabled=enabled==true if enabled==_antiDieEnabled then return end if enabled then _antiDie.StartEngine()else _antiDie.StopEngine()end end function _antiDieRefresh()if _antiDieStopped then return end local manual=_antiDieSources.toggle _antiDieSetEnabled(manual or _antiDieSources.autobat or _antiDieSources.float)end _G.__CrystalAntiDieSource=function(source,enabled)if _antiDieStopped or _antiDieSources[source]==nil then return end _antiDieSources[source]=enabled==true _antiDieRefresh()end _G.__CrystalAntiDieSet=function(enabled)_G.__CrystalAntiDieSource("autobat",enabled)end _G.__CrystalAntiDieIsEnabled=function()return _antiDieEnabled end _G.__CrystalAntiDieStop=function()_antiDieStopped=true _antiDieSources.toggle=false _antiDieSources.autobat=false _antiDieSetEnabled(false)end function activateOnCharacter(char)if not _antiDieEnabled then return end _antiDie.AttachHealth(char)local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then _antiDie.SuperHeal(hum)end end AntiDieModule={enabled=false,start=function()AntiDieModule.enabled=true antiDieEnabled=true _antiDieStopped=false _G.__CrystalAntiDieSource("toggle",true)end,stop=function()AntiDieModule.enabled=false antiDieEnabled=false _G.__CrystalAntiDieSource("toggle",false)end,}_G.AntiDie=AntiDieModule local AntiBat={Connection=nil}local ANTIBAT_RANGE=4000 function stopAntiBat()antiBatEnabled=false if AntiBat.Connection then AntiBat.Connection:Disconnect()AntiBat.Connection=nil end end function startAntiBat()stopAntiBat()antiBatEnabled=true AntiBat.Connection=RunService.Heartbeat:Connect(function()if not antiBatEnabled then return end local character=LP.Character if not character then return end local hrp=character:FindFirstChild("HumanoidRootPart")if not hrp then return end local v=hrp.Velocity hrp.Velocity=Vector3.new(math.random(-ANTIBAT_RANGE,ANTIBAT_RANGE),v.Y,math.random(-ANTIBAT_RANGE,ANTIBAT_RANGE))RunService.RenderStepped:Wait()if hrp and hrp.Parent then hrp.Velocity=v end end)end LP.CharacterAdded:Connect(function()task.wait(0.3)if antiBatEnabled then startAntiBat()end end)setAntiFlingVisual=nil local _antiFlingState={connection=nil,threshold=80,spinThreshold=40,}local _ANTI_FLING_DRIVE_GRACE=0.3 local function _afHubSpeedLive()local live=_G.__RivalHubLiveSpeed if type(live)~="table"then return false end local stamp,speed=tonumber(live.t),tonumber(live.v)if not stamp or not speed or speed<=0 then return false end return(os.clock()-stamp)<=_ANTI_FLING_DRIVE_GRACE end local function _afOwnMoverActive()if autoBatEnabled then return true end if autoLeftEnabled or autoRightEnabled then return true end return false end function startAntiFling()if _antiFlingState.connection then return end antiFlingEnabled=true _antiFlingState.connection=RunService.Heartbeat:Connect(function()if not antiFlingEnabled then return end local character=LP.Character if not character then return end local root=character:FindFirstChild("HumanoidRootPart")if not root then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if humanoid and(humanoid.Health<=0 or humanoid.SeatPart)then return end if dropActive or _G.IsDropping then return end if _afOwnMoverActive()then return end if _afHubSpeedLive()then return end local velocity=root.AssemblyLinearVelocity local flat=Vector3.new(velocity.X,0,velocity.Z)if flat.Magnitude>_antiFlingState.threshold then pcall(function()root.AssemblyLinearVelocity=Vector3.new(0,velocity.Y,0)root.AssemblyAngularVelocity=Vector3.zero end)return end if root.AssemblyAngularVelocity.Magnitude>_antiFlingState.spinThreshold then pcall(function()root.AssemblyAngularVelocity=Vector3.zero end)end end)end function stopAntiFling()antiFlingEnabled=false if _antiFlingState.connection then _antiFlingState.connection:Disconnect()_antiFlingState.connection=nil end end LP.CharacterAdded:Connect(function()task.wait(0.3)if antiFlingEnabled then startAntiFling()end end)local espEnabled=espEnabled or false local espActivePlayers={}local espLoopConn=nil local Camera=workspace.CurrentCamera local GUI2_ESP_COLOR=Color3.fromRGB(139,72,246)local GUI2_ESP_TEXT_STROKE=Color3.fromRGB(48,16,92)local function getESPThemeColors(accent)local c=ESP_ORANGE return c,c end local function createESP()local currentFill,currentLine=getESPThemeColors()local esp={Tracer=Drawing and Drawing.new("Line")or nil,Highlight=Instance.new("Highlight"),Lines={},}if esp.Tracer then esp.Tracer.Color=currentLine esp.Tracer.Thickness=3 esp.Tracer.Transparency=1 esp.Tracer.ZIndex=2 end esp.Highlight.Name="RivalHubESP_Highlight"esp.Highlight.FillColor=currentFill esp.Highlight.OutlineColor=Color3.fromRGB(0,0,0)esp.Highlight.FillTransparency=0.12 esp.Highlight.OutlineTransparency=0.18 esp.Highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop local parentGui local ok,robGui=pcall(function()return game:GetService("CoreGui"):FindFirstChild("RobloxGui")end)if ok and robGui then parentGui=robGui else parentGui=LP:FindFirstChildOfClass("PlayerGui")end if not parentGui then parentGui=game:GetService("CoreGui")end pcall(function()esp.Highlight.Parent=parentGui end)local nameBillboard=Instance.new("BillboardGui")nameBillboard.Name="RivalHubESP_Name"nameBillboard.Size=UDim2.new(0,170,0,28)nameBillboard.StudsOffset=Vector3.new(0,1.3,0)nameBillboard.AlwaysOnTop=true nameBillboard.Parent=parentGui local nameLabel=Instance.new("TextLabel")nameLabel.Size=UDim2.new(0,170,0,28)nameLabel.AnchorPoint=Vector2.new(0.5,0)nameLabel.Position=UDim2.new(0.5,0,0,2)nameLabel.BackgroundTransparency=1 nameLabel.Text=""nameLabel.TextColor3=ESP_ORANGE nameLabel.TextSize=15 nameLabel.Font=Enum.Font.GothamBold nameLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)nameLabel.TextStrokeTransparency=0 nameLabel.TextXAlignment=Enum.TextXAlignment.Center nameLabel.TextYAlignment=Enum.TextYAlignment.Center nameLabel.ZIndex=5 nameLabel.Parent=nameBillboard local nameOutline=Instance.new("UIStroke")nameOutline.Color=Color3.fromRGB(0,0,0)nameOutline.Thickness=2.2 nameOutline.Transparency=0.12 nameOutline.Parent=nameLabel if Drawing then for i=1,14 do local line=Drawing.new("Line")line.Color=currentLine line.Thickness=2 line.Transparency=1 line.ZIndex=3 table.insert(esp.Lines,line)end end esp.NameTag=nameBillboard esp.NameLabel=nameLabel esp.NameOutline=nameOutline return esp end _G.__RivalHubRefreshESPTheme=function(accent,outlineColor)local fillColor,lineColor=getESPThemeColors(accent)for _,data in pairs(espActivePlayers)do if type(data)=="table"and data.esp then local esp=data.esp if esp.Tracer then pcall(function()esp.Tracer.Color=lineColor end)end if esp.Highlight then esp.Highlight.FillColor=fillColor esp.Highlight.OutlineColor=Color3.fromRGB(0,0,0)end if esp.NameLabel then esp.NameLabel.TextColor3=ESP_ORANGE esp.NameLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)end if esp.NameOutline then esp.NameOutline.Color=Color3.fromRGB(0,0,0)end for _,line in ipairs(esp.Lines or{})do pcall(function()line.Color=lineColor end)end end end end local function removeESP(plr)local data=espActivePlayers[plr]if data then if data.esp.Tracer then pcall(function()data.esp.Tracer:Remove()end)end if data.esp.Highlight then pcall(function()data.esp.Highlight:Destroy()end)end if data.esp.NameTag then pcall(function()data.esp.NameTag:Destroy()end)end for _,line in ipairs(data.esp.Lines)do pcall(function()line:Remove()end)end espActivePlayers[plr]=nil end end local function updateESP(plr,esp)if not espEnabled then if esp.Tracer then esp.Tracer.Visible=false end esp.Highlight.Enabled=false for _,line in ipairs(esp.Lines)do line.Visible=false end if esp.NameTag then esp.NameTag.Enabled=false end return end local character=plr.Character local hum=character and character:FindFirstChildOfClass("Humanoid")local trackPart=character and(character:FindFirstChild("HumanoidRootPart")or character.PrimaryPart or character:FindFirstChild("UpperTorso")or character:FindFirstChild("Torso")or character:FindFirstChild("Head"))if character and trackPart and(not hum or hum.Health>0)then esp.Highlight.Adornee=character esp.Highlight.Enabled=espEnabled if esp.Tracer then esp.Tracer.Visible=false end for _,line in ipairs(esp.Lines)do line.Visible=false end if esp.NameTag and esp.NameLabel then pcall(function()esp.NameTag.Adornee=trackPart esp.NameTag.Enabled=espEnabled esp.NameLabel.Text=plr.Name or plr.DisplayName or""esp.NameLabel.TextColor3=ESP_ORANGE end)end else if esp.Tracer then esp.Tracer.Visible=false end esp.Highlight.Enabled=false esp.Highlight.Adornee=nil for _,line in ipairs(esp.Lines)do line.Visible=false end if esp.NameTag then esp.NameTag.Enabled=false end end end local function createESPForPlayer(plr)if plr==LP then return end if espActivePlayers[plr]and espActivePlayers[plr].esp then if espActivePlayers[plr].esp.NameTag then pcall(function()espActivePlayers[plr].esp.NameTag.Enabled=espEnabled end)end return end removeESP(plr)local esp=createESP()espActivePlayers[plr]={esp=esp}end local espJoinConn,espLeaveConn local function enableESP()if espEnabled then return end espEnabled=true for _,plr in pairs(Players:GetPlayers())do if plr~=LP then task.spawn(function()createESPForPlayer(plr)end)end end local espAccumulator=0 if espLoopConn then espLoopConn:Disconnect()end espLoopConn=RunService.Heartbeat:Connect(function(dt)espAccumulator=espAccumulator+(dt or 0)if espAccumulator<0.15 then return end espAccumulator=0 for plr,data in pairs(espActivePlayers)do if typeof(plr)=="Instance"and plr:IsA("Player")and data and data.esp then pcall(function()updateESP(plr,data.esp)end)end end end)espJoinConn=Players.PlayerAdded:Connect(function(plr)if not espEnabled or plr==LP then return end task.wait(0.3)createESPForPlayer(plr)end)espLeaveConn=Players.PlayerRemoving:Connect(function(plr)removeESP(plr)end)end local function disableESP()espEnabled=false if espLoopConn then espLoopConn:Disconnect();espLoopConn=nil end if espJoinConn then pcall(function()espJoinConn:Disconnect()end);espJoinConn=nil end if espLeaveConn then pcall(function()espLeaveConn:Disconnect()end);espLeaveConn=nil end for plr in pairs(espActivePlayers)do if typeof(plr)=="Instance"and plr:IsA("Player")and plr~=LP then removeESP(plr)end end end function toggleESP(on)if on then enableESP()else disableESP()end if setESPVIsual then setESPVIsual(on)end end local _espLineGui=nil local _espLineFrame=nil local _espLineOutline=nil local _espLineConn=nil local _espLineState={scanElapsed=math.huge,targetRoot=nil}local function ensureESPLineGui()if _espLineGui and _espLineGui.Parent then return end _espLineGui=Instance.new("ScreenGui")_espLineGui.Name="RivalHubESPLine"_espLineGui.IgnoreGuiInset=true _espLineGui.ResetOnSpawn=false _espLineGui.DisplayOrder=1000 _espLineGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling local okP=pcall(function()_espLineGui.Parent=game:GetService("CoreGui")end)if not okP then _espLineGui.Parent=LP:WaitForChild("PlayerGui")end _espLineFrame=Instance.new("Frame")_espLineFrame.Name="ESPLine"_espLineFrame.AnchorPoint=Vector2.new(0.5,0.5)_espLineFrame.BorderSizePixel=0 _espLineFrame.Active=false _espLineFrame.Visible=false _espLineFrame.BackgroundColor3=ESP_ORANGE _espLineFrame.ZIndex=1 _espLineFrame.Parent=_espLineGui _espLineOutline=Instance.new("UIStroke",_espLineFrame)_espLineOutline.Color=Color3.fromRGB(255,255,255)_espLineOutline.Thickness=0.7 _espLineOutline.Transparency=0.45 end function stopESPLine()espLineEnabled=false if _espLineConn then _espLineConn:Disconnect();_espLineConn=nil end if _espLineFrame then _espLineFrame.Visible=false end _espLineState.targetRoot=nil _espLineState.scanElapsed=math.huge if _espLineGui and _espLineGui.Parent then pcall(function()_espLineGui:Destroy()end)end _espLineGui=nil _espLineFrame=nil _espLineOutline=nil end function startESPLine()espLineEnabled=true ensureESPLineGui()if _espLineConn then _espLineConn:Disconnect()end _espLineState.scanElapsed=math.huge _espLineState.targetRoot=nil _espLineConn=RunService.RenderStepped:Connect(function(dt)if not espLineEnabled then if _espLineFrame then _espLineFrame.Visible=false end return end local ok=pcall(function()local activeCamera=workspace.CurrentCamera local myChar=LP.Character local myRoot=myChar and(myChar:FindFirstChild("LowerTorso")or myChar:FindFirstChild("HumanoidRootPart")or myChar:FindFirstChild("Torso"))if not activeCamera or not myRoot then if _espLineFrame then _espLineFrame.Visible=false end return end local myPosition=myRoot.Position _espLineState.scanElapsed=_espLineState.scanElapsed+(dt or 0)local cachedRoot=_espLineState.targetRoot local cachedCharacter=cachedRoot and cachedRoot.Parent local cachedHumanoid=cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")local cachedValid=cachedRoot and cachedRoot.Parent and(not cachedHumanoid or cachedHumanoid.Health>0)if _espLineState.scanElapsed>=0.12 or not cachedValid then _espLineState.scanElapsed=0 local closestRoot,closestDistanceSq=nil,math.huge for _,otherPlayer in ipairs(Players:GetPlayers())do if otherPlayer~=LP then local character=otherPlayer.Character local humanoid=character and character:FindFirstChildOfClass("Humanoid")local root=character and(character:FindFirstChild("HumanoidRootPart")or character:FindFirstChild("LowerTorso")or character:FindFirstChild("Torso"))if root and root:IsA("BasePart")and(not humanoid or humanoid.Health>0)then local delta=root.Position-myPosition local distanceSq=delta:Dot(delta)if distanceSq<closestDistanceSq then closestRoot,closestDistanceSq=root,distanceSq end end end end _espLineState.targetRoot=closestRoot end local closestRoot=_espLineState.targetRoot if not closestRoot or not closestRoot.Parent then if _espLineFrame then _espLineFrame.Visible=false end return end local closestPosition=closestRoot.Position local from=activeCamera:WorldToViewportPoint(myPosition-Vector3.new(0,myRoot.Size.Y*0.35,0))local to,targetOnScreen=activeCamera:WorldToViewportPoint(closestPosition)local viewport=activeCamera.ViewportSize local fromPoint=Vector2.new(from.X,from.Y)local targetPoint=Vector2.new(to.X,to.Y)if not targetOnScreen or to.Z<=0 then local center=viewport*0.5 local direction=targetPoint-center if to.Z<=0 then direction=-direction end if direction.Magnitude<0.001 then direction=Vector2.new(0,-1)end local limit=Vector2.new(math.max(8,center.X-8),math.max(8,center.Y-8))local scaleX=limit.X/math.max(math.abs(direction.X),0.001)local scaleY=limit.Y/math.max(math.abs(direction.Y),0.001)targetPoint=center+direction*math.min(scaleX,scaleY)end if from.Z<=0 or fromPoint.X<0 or fromPoint.X>viewport.X or fromPoint.Y<0 or fromPoint.Y>viewport.Y then fromPoint=Vector2.new(viewport.X*0.5,viewport.Y-8)end local delta=targetPoint-fromPoint local midpoint=(fromPoint+targetPoint)*0.5 _espLineFrame.Position=UDim2.fromOffset(midpoint.X,midpoint.Y)_espLineFrame.Size=UDim2.fromOffset(math.max(delta.Magnitude,1),2)_espLineFrame.Rotation=math.deg(math.atan2(delta.Y,delta.X))_espLineFrame.BackgroundColor3=ESP_ORANGE _espLineFrame.Visible=true end)if not ok and _espLineFrame then pcall(function()_espLineFrame.Visible=false end)end end)end ENEMY_SPEED_COLOR=Color3.fromRGB(255,130,20)function _enemySpeedDrop(player)local old=enemySpeedLabels[player]enemySpeedLabels[player]=nil if old then pcall(function()local bb=old.Parent if bb then bb:Destroy()else old:Destroy()end end)end end function updateEnemySpeedLabels()local players=_GetPlayersCached()for i=1,#players do local player=players[i]if player~=LP then local ok=pcall(function()local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")local head=char and char:FindFirstChild("Head")if hrp and hum and head and hum.Health>0 then local label=enemySpeedLabels[player]if label and not(label.Parent and label.Parent.Parent==head)then _enemySpeedDrop(player)label=nil end if not label then local bb=Instance.new("BillboardGui")bb.Name="EnemySpeedGui"bb.Size=UDim2.new(0,100,0,25)bb.StudsOffset=_V3new(0,3.2,0)bb.AlwaysOnTop=true bb.MaxDistance=math.huge bb.ResetOnSpawn=false bb.Adornee=head bb.Parent=head local tl=Instance.new("TextLabel",bb)tl.Size=UDim2.new(1,0,1,0)tl.BackgroundTransparency=1 tl.TextColor3=ENEMY_SPEED_COLOR tl.Font=Enum.Font.GothamBlack tl.TextScaled=true tl.TextStrokeTransparency=0 tl.TextStrokeColor3=Color3.fromRGB(0,0,0)enemySpeedLabels[player]=tl label=tl end local v=hrp.AssemblyLinearVelocity label.Text=string.format("%.1f",_sqrt(v.X*v.X+v.Z*v.Z))if label.TextColor3~=ENEMY_SPEED_COLOR then label.TextColor3=ENEMY_SPEED_COLOR end else _enemySpeedDrop(player)end end)if not ok then _enemySpeedDrop(player)end end end for player in pairs(enemySpeedLabels)do if not player.Parent then _enemySpeedDrop(player)end end end function startEnemySpeed()if enemySpeedConn then enemySpeedConn:Disconnect()end enemySpeedConn=RunService.Heartbeat:Connect(updateEnemySpeedLabels)end function stopEnemySpeed()if enemySpeedConn then enemySpeedConn:Disconnect();enemySpeedConn=nil end for player in pairs(enemySpeedLabels)do _enemySpeedDrop(player)end end local function getClosestTargetBody()local char=LP.Character if not char then return nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil end local rpos=root.Position local closest,minDist=nil,_huge local plist=_GetPlayersCached()for i=1,#plist do local plr=plist[i]if plr~=LP then local c=plr.Character if c then local tRoot=c:FindFirstChild("HumanoidRootPart")if tRoot then local hum=c:FindFirstChildOfClass("Humanoid")if hum and hum.Health>0 then local dx=tRoot.Position.X-rpos.X local dy=tRoot.Position.Y-rpos.Y local dz=tRoot.Position.Z-rpos.Z local d=dx*dx+dy*dy+dz*dz if d<minDist then minDist=d;closest=tRoot end end end end end end return closest end local function _bodyLockTick()local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if not root then return end local hum=char:FindFirstChildOfClass("Humanoid")if not hum then return end local target=getClosestTargetBody()if not target then if not hum.AutoRotate then hum.AutoRotate=true end return end local dist=(target.Position-root.Position).Magnitude if dist>bodyLockRange then if not hum.AutoRotate then hum.AutoRotate=true end return end if hum.AutoRotate then hum.AutoRotate=false end local targetVel=target.AssemblyLinearVelocity local speed3=targetVel.Magnitude local predictTime=_clamp(speed3/80,0.08,0.35)local predictedPos=target.Position+targetVel*predictTime local targetHead=target.Parent and target.Parent:FindFirstChild("Head")local targetHeight=targetHead and targetHead.Position.Y or target.Position.Y local myHeight=root.Position.Y+(hum.HipHeight or 0)local heightDiff=targetHeight-myHeight local verticalCorrection=_clamp(heightDiff*0.15,-1.5,1.5)local flatTarget=_V3new(predictedPos.X,root.Position.Y+verticalCorrection,predictedPos.Z)local toPredict=flatTarget-root.Position if toPredict.Magnitude>0.1 then local goalCF=_CFlookAt(root.Position,flatTarget)local diffCF=root.CFrame:Inverse()*goalCF local _,ry,_=diffCF:ToEulerAnglesXYZ()ry=_clamp(ry,-2.5,2.5)root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(_V3new(0,ry*42,0))end end function startBodyLock()if _bodyLockConn then _bodyLockConn:Disconnect()end local acc=0 _bodyLockConn=RunService.Heartbeat:Connect(function(dt)if not bodyLockEnabled then return end if _blSuppressCount>0 then return end acc=acc+dt if acc<0.033 then return end acc=0 _bodyLockTick()end)end function stopBodyLock()if _bodyLockConn then _bodyLockConn:Disconnect()_bodyLockConn=nil end local c=LP.Character local root=c and c:FindFirstChild("HumanoidRootPart")if root then root.AssemblyAngularVelocity=_V3zero root.AssemblyLinearVelocity=_V3new(root.AssemblyLinearVelocity.X,-0.1,root.AssemblyLinearVelocity.Z)end local hum2=c and c:FindFirstChildOfClass("Humanoid")if hum2 then hum2.AutoRotate=true end end function _suppressBodyLock()_blSuppressCount=_blSuppressCount+1 if _blSuppressCount==1 and bodyLockEnabled then _blWasEnabled=true stopBodyLock()if bodyLockSetVisual then bodyLockSetVisual(false)end if _blRestoreTimer then task.cancel(_blRestoreTimer)_blRestoreTimer=nil end _blSmoothRestore=false end end function _unsuppressBodyLock(delayed)if _blSuppressCount>0 then _blSuppressCount=_blSuppressCount-1 end if _blSuppressCount==0 and _blWasEnabled then _blWasEnabled=false if _blRestoreTimer then pcall(task.cancel,_blRestoreTimer)_blRestoreTimer=nil end local function restore()_blRestoreTimer=nil if bodyLockEnabled then _blSmoothRestore=true startBodyLock()if bodyLockSetVisual then bodyLockSetVisual(true)end task.delay(0.5,function()_blSmoothRestore=false end)end end if delayed then _blRestoreTimer=task.delay(1,restore)else restore()end end end function setupSpeedIndicator(char)local head=char:WaitForChild("Head",5)if not head then return end local oldBB=head:FindFirstChild("RivalHubSpeedIndicator")if oldBB then oldBB:Destroy()end local oldDiscord=head:FindFirstChild("DiscordText")if oldDiscord then oldDiscord:Destroy()end local bb=Instance.new("BillboardGui",head)bb.Name="RivalHubSpeedIndicator"bb.Size=UDim2.fromOffset(200,30)bb.StudsOffset=Vector3.new(0,3.2,0)bb.AlwaysOnTop=true bb.LightInfluence=0 bb.MaxDistance=0 speedLabel=Instance.new("TextLabel",bb)speedLabel.Name="SpeedLabel"speedLabel.Size=UDim2.new(1,0,1,0)speedLabel.Position=UDim2.new(0,0,0,0)speedLabel.BackgroundTransparency=1 speedLabel.Text="0.0  -  "..getSpeedModeName()speedLabel.TextColor3=Color3.fromRGB(255,140,30)speedLabel.Font=Enum.Font.GothamBlack speedLabel.TextSize=22 speedLabel.TextXAlignment=Enum.TextXAlignment.Center speedLabel.TextYAlignment=Enum.TextYAlignment.Center speedLabel.TextStrokeTransparency=0 speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)local slStroke=Instance.new("UIStroke",speedLabel)slStroke.Color=Color3.fromRGB(255,200,100)slStroke.Thickness=1.8 slStroke.Transparency=0.05 applyShimmerToText(speedLabel,0.9,Color3.fromRGB(255,140,30))local dbb=Instance.new("BillboardGui",head)dbb.Name="DiscordText"dbb.Size=UDim2.fromOffset(200,24)dbb.StudsOffset=Vector3.new(0,5.2,0)dbb.AlwaysOnTop=true dbb.LightInfluence=0 dbb.MaxDistance=0 local dLabel=Instance.new("TextLabel",dbb)dLabel.Name="DiscordLabel"dLabel.Size=UDim2.new(1,0,1,0)dLabel.BackgroundTransparency=1 dLabel.Text=".gg/ZeyHubb.vs"dLabel.TextColor3=Color3.fromRGB(255,255,255)dLabel.Font=Enum.Font.GothamBlack dLabel.TextSize=16 dLabel.TextXAlignment=Enum.TextXAlignment.Center dLabel.TextYAlignment=Enum.TextYAlignment.Center dLabel.TextStrokeTransparency=0 dLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)local dStroke=Instance.new("UIStroke",dLabel)dStroke.Color=Color3.fromRGB(255,130,20)dStroke.Thickness=1.4 dStroke.Transparency=0.1 end local unwalkSavedAnimate=nil function startUnwalk()local c=LP.Character if not c then return end local hum=c:FindFirstChildOfClass("Humanoid")if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks())do pcall(function()t:Stop()end)end end local anim=c:FindFirstChild("Animate")if anim then unwalkSavedAnimate=anim:Clone()anim:Destroy()end end function stopUnwalk()local c=LP.Character if c then local existing=c:FindFirstChild("Animate")if not existing then local src=game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")local starterAnim=src and src:FindFirstChild("Animate")if starterAnim then starterAnim:Clone().Parent=c elseif unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c end end end unwalkSavedAnimate=nil end function refreshSpeedModeLabel()if modeValLbl then if laggerCarryToggled then modeValLbl.Text="Lagger Carry"elseif laggerToggled then modeValLbl.Text="Lagger Normal"elseif speedMode then modeValLbl.Text="Carry"else modeValLbl.Text="Normal"end end if setCarryModeVisual then setCarryModeVisual(speedMode)end if setLaggerModeVisual then setLaggerModeVisual(laggerToggled)end if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled)end end function resetMovementState()refreshSpeedModeLabel()if mobSetCarry then mobSetCarry(speedMode)end if setLaggerModeVisual then setLaggerModeVisual(laggerToggled)end if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled)end end function toggleCarryMode()if laggerToggled or laggerCarryToggled then laggerToggled=false;laggerCarryToggled=false;speedMode=true else speedMode=not speedMode end resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function toggleLaggerMode()if laggerCarryToggled then laggerCarryToggled=false end speedMode=false;laggerToggled=not laggerToggled resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function toggleLaggerCarryMode()if laggerToggled then laggerToggled=false end speedMode=false;laggerCarryToggled=not laggerCarryToggled resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function toggleLaggerCycle()if speedMode then speedMode=false laggerToggled=true laggerCarryToggled=false elseif laggerToggled then speedMode=false laggerToggled=false laggerCarryToggled=true else speedMode=true laggerToggled=false laggerCarryToggled=false end resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function stopAutoLeft()if alConn then alConn:Disconnect();alConn=nil end alPhase=1 local char=LP.Character if char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:Move(_V3zero,false)end end if autoLeftSetVisual then autoLeftSetVisual(false)end if mobSetAutoLeft then mobSetAutoLeft(false)end _unsuppressBodyLock(true)end function startAutoLeft()if autoRightEnabled then autoRightEnabled=false stopAutoRight()if autoRightSetVisual then autoRightSetVisual(false)end if mobSetAutoRight then mobSetAutoRight(false)end end disableAllAimbots()_suppressBodyLock()if alConn then alConn:Disconnect()end alPhase=1 alConn=RunService.Heartbeat:Connect(function()if not autoLeftEnabled then return end local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if not root or not hum then return end local spd=NS if alPhase==1 then local tgt=_V3new(AP.L1.X,root.Position.Y,AP.L1.Z)if(tgt-root.Position).Magnitude<1 then alPhase=2 local d=AP.L2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)return end local d=AP.L1-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)elseif alPhase==2 then local tgt=_V3new(AP.L2.X,root.Position.Y,AP.L2.Z)if(tgt-root.Position).Magnitude<1 then hum:Move(_V3zero,false)root.AssemblyLinearVelocity=_V3zero autoLeftEnabled=false if alConn then alConn:Disconnect();alConn=nil end alPhase=1 if autoLeftSetVisual then autoLeftSetVisual(false)end if mobSetAutoLeft then mobSetAutoLeft(false)end _unsuppressBodyLock(true)local facePos=_V3new(AP.L_FACE.X,root.Position.Y,AP.L_FACE.Z)if(facePos-root.Position).Magnitude>0.01 then root.CFrame=_CFnew(root.Position,facePos)end return end local d=AP.L2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)end end)end function stopAutoRight()if arConn then arConn:Disconnect();arConn=nil end arPhase=1 local char=LP.Character if char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:Move(_V3zero,false)end end if autoRightSetVisual then autoRightSetVisual(false)end if mobSetAutoRight then mobSetAutoRight(false)end _unsuppressBodyLock(true)end function startAutoRight()if autoLeftEnabled then autoLeftEnabled=false stopAutoLeft()if autoLeftSetVisual then autoLeftSetVisual(false)end if mobSetAutoLeft then mobSetAutoLeft(false)end end disableAllAimbots()_suppressBodyLock()if arConn then arConn:Disconnect()end arPhase=1 arConn=RunService.Heartbeat:Connect(function()if not autoRightEnabled then return end local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if not root or not hum then return end local spd=NS if arPhase==1 then local tgt=_V3new(AP.R1.X,root.Position.Y,AP.R1.Z)if(tgt-root.Position).Magnitude<1 then arPhase=2 local d=AP.R2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)return end local d=AP.R1-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)elseif arPhase==2 then local tgt=_V3new(AP.R2.X,root.Position.Y,AP.R2.Z)if(tgt-root.Position).Magnitude<1 then hum:Move(_V3zero,false)root.AssemblyLinearVelocity=_V3zero autoRightEnabled=false if arConn then arConn:Disconnect();arConn=nil end arPhase=1 if autoRightSetVisual then autoRightSetVisual(false)end if mobSetAutoRight then mobSetAutoRight(false)end _unsuppressBodyLock(true)local facePos=_V3new(AP.R_FACE.X,root.Position.Y,AP.R_FACE.Z)if(facePos-root.Position).Magnitude>0.01 then root.CFrame=_CFnew(root.Position,facePos)end return end local d=AP.R2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)end end)end function getClosestTarget()local char=LP.Character if not char then return nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil end local rpos=root.Position local closest,minDist=nil,_huge local plist=_GetPlayersCached()for i=1,#plist do local plr=plist[i]if plr~=LP then local c=plr.Character if c then local tRoot=c:FindFirstChild("HumanoidRootPart")if tRoot then local hum=c:FindFirstChildOfClass("Humanoid")if hum and hum.Health>0 then local dx=tRoot.Position.X-rpos.X local dy=tRoot.Position.Y-rpos.Y local dz=tRoot.Position.Z-rpos.Z local d=dx*dx+dy*dy+dz*dz if d<minDist then minDist=d;closest=tRoot end end end end end end return closest end function trySwing()pcall(function()local char=LP.Character if not char then return end local currentTool=char:FindFirstChildOfClass("Tool")if currentTool and not isBatTool(currentTool)then return end local bat=findBat()if bat then if bat.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then pcall(function()hum:EquipTool(bat)end)end end pcall(function()bat:Activate()end)end end)end do local ACTIVATE_DISTANCE=13 local MIN_FOLLOW_DISTANCE=1 local PREDICTION_TIME=0.22 local PREDICT_AHEAD=3 local JUMP_SPEED_BOOST=1.5 local JUMP_THRESHOLD=8 local ACTIVATION_DELAY=0.2 local AIRBORNE_THRESHOLD=0.15 local FLOAT_Y_THRESHOLD=3 local FALLING_THRESHOLD=-8 local RISING_THRESHOLD=8 local VERTICAL_OFFSET_MULTIPLIER=0.15 local JUMPBOOST_Y_THRESHOLD=35 local EXTREME_JUMPBOOST_THRESHOLD=50 local JUMPBOOST_SUSTAINED_TIME=0.15 local MAX_VELOCITY_CHANGE=150 local VELOCITY_SMOOTHING=0.2 local MAX_HORIZONTAL_VELOCITY=80 local ERRATIC_MOVEMENT_THRESHOLD=3 local SERVER_TICKRATE=1/60 local PING_SAMPLE_SIZE=10 local MIN_PING_COMPENSATION=0.03 local MAX_PING_COMPENSATION=0.25 local ACCELERATION_PREDICTION_WEIGHT=0.3 local DIRECTION_CHANGE_DETECTION_TIME=0.12 local QUICK_DIRECTION_CHANGE_MULTIPLIER=1.5 local GRAVITY=196.2 local AIR_CONTROL_FACTOR=0.8 local AERIAL_VELOCITY_DECAY=0.95 local AERIAL_DIRECTION_CHANGE_WEIGHT=0.6 local MIN_AIRBORNE_TIME=0.08 local AERIAL_SMOOTHING=0.15 local STRAFE_DETECTION_THRESHOLD=0.7 local HIGH_JUMP_THRESHOLD=20 local FALLING_SPEED_THRESHOLD=-15 local GRAVITY_PREDICTION_WEIGHT=1.0 local MULTI_JUMP_DETECTION_WINDOW=0.2 local UPWARD_VELOCITY_RESET_THRESHOLD=10 local VERTICAL_POSITION_LEAD=2.5 local FALLING_VERTICAL_LEAD=3.5 local predictionSphere=nil local targetPlayer=nil local lastTargetPos=nil local targetVelocity=Vector3.new(0,0,0)local smoothedVelocity=Vector3.new(0,0,0)local velocityHistory={}local MAX_HISTORY=8 local airborneTime=0 local lastActivationTime=0 local highYVelocityTime=0 local pingHistory={}local currentPing=0.1 local accelerationHistory={}local MAX_ACCEL_HISTORY=4 local lastDirectionChangeTime=0 local previousDirection=nil local wasAirborne=false local aerialVelocityHistory={}local MAX_AERIAL_HISTORY=6 local aerialSmoothVelocity=Vector3.new(0,0,0)local lastYVelocity=0 local peakHeight=0 local groundHeight=0 local lastJumpTime=0 local isMultiJumping=false local verticalVelocityHistory={}local MAX_VERTICAL_HISTORY=5 local function getNearestPlayer()local char=LP.Character if not char then return nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil end local myPos=root.Position local nearestDist=math.huge local nearestPlayer=nil local MAX_TARGET_DISTANCE=250 for _,p in ipairs(Players:GetPlayers())do if p~=LP and p.Character then local otherRoot=p.Character:FindFirstChild("HumanoidRootPart")local otherHum=p.Character:FindFirstChildOfClass("Humanoid")if otherRoot and otherHum and otherHum.Health>0 then local dist=(myPos-otherRoot.Position).Magnitude if dist<=MAX_TARGET_DISTANCE and dist<nearestDist then nearestDist=dist nearestPlayer=p end end end end return nearestPlayer end local function getAverageVelocity()if#velocityHistory==0 then return Vector3.new(0,0,0)end local sum=Vector3.new(0,0,0)for _,vel in ipairs(velocityHistory)do sum=sum+vel end return sum/#velocityHistory end local function getAverageAcceleration()if#accelerationHistory==0 then return Vector3.new(0,0,0)end local sum=Vector3.new(0,0,0)for _,a in ipairs(accelerationHistory)do sum=sum+a end return sum/#accelerationHistory end local function getAverageAerialVelocity()if#aerialVelocityHistory==0 then return Vector3.new(0,0,0)end local sum=Vector3.new(0,0,0)for _,vel in ipairs(aerialVelocityHistory)do sum=sum+Vector3.new(vel.X,0,vel.Z)end return sum/#aerialVelocityHistory end local function getAverageVerticalVelocity()if#verticalVelocityHistory==0 then return 0 end local sum=0 for _,y in ipairs(verticalVelocityHistory)do sum=sum+y end return sum/#verticalVelocityHistory end local function detectMultiJump(currentYVel,wasRising)local t=tick()if lastYVelocity<-5 and currentYVel>UPWARD_VELOCITY_RESET_THRESHOLD then if t-lastJumpTime<MULTI_JUMP_DETECTION_WINDOW then return true end lastJumpTime=t return true end return false end local function isFallingFromHeight(currentPos,yVel)return(currentPos.Y-groundHeight>HIGH_JUMP_THRESHOLD)and yVel<FALLING_SPEED_THRESHOLD end local function isAerialStrafing()if#aerialVelocityHistory<3 then return false end local dc=0 for i=2,#aerialVelocityHistory do local v1=Vector3.new(aerialVelocityHistory[i-1].X,0,aerialVelocityHistory[i-1].Z)local v2=Vector3.new(aerialVelocityHistory[i].X,0,aerialVelocityHistory[i].Z)if v1.Magnitude>3 and v2.Magnitude>3 then if v1.Unit:Dot(v2.Unit)<STRAFE_DETECTION_THRESHOLD then dc=dc+1 end end end return dc>=2 end local function detectDirectionChange(currentVel)local horizontal=Vector3.new(currentVel.X,0,currentVel.Z)if horizontal.Magnitude<5 then return false end if previousDirection then local dot=previousDirection:Dot(horizontal.Unit)if dot<0.5 then local t=tick()if t-lastDirectionChangeTime<DIRECTION_CHANGE_DETECTION_TIME then previousDirection=horizontal.Unit lastDirectionChangeTime=t return true end lastDirectionChangeTime=t end end previousDirection=horizontal.Unit return false end local function isErraticMovement()if#velocityHistory<3 then return false end local changes=0 for i=2,#velocityHistory do local v1=Vector3.new(velocityHistory[i-1].X,0,velocityHistory[i-1].Z)local v2=Vector3.new(velocityHistory[i].X,0,velocityHistory[i].Z)if v1.Magnitude>5 and v2.Magnitude>5 then if v1.Unit:Dot(v2.Unit)<0.3 then changes=changes+1 end end end return changes>=ERRATIC_MOVEMENT_THRESHOLD end local function isInfiniteJumping()if#velocityHistory<3 then return false end local yc=0 for i=2,#velocityHistory do if math.abs(velocityHistory[i].Y-velocityHistory[i-1].Y)>15 then yc=yc+1 end end return yc>=2 end local function isJumpBoostCheat()return math.abs(targetVelocity.Y)>JUMPBOOST_Y_THRESHOLD and highYVelocityTime>JUMPBOOST_SUSTAINED_TIME end local function isExtremeJumpBoost()return math.abs(targetVelocity.Y)>EXTREME_JUMPBOOST_THRESHOLD end local function isFloating()return airborneTime>AIRBORNE_THRESHOLD and math.abs(targetVelocity.Y)>FLOAT_Y_THRESHOLD end local function checkAirborne(targetRoot)local params=RaycastParams.new()params.FilterType=Enum.RaycastFilterType.Exclude params.FilterDescendantsInstances={targetPlayer.Character,LP.Character}local rayResult=workspace:Raycast(targetRoot.Position,Vector3.new(0,-100,0),params)if rayResult then groundHeight=rayResult.Position.Y return false end return true end local function clampVelocityChange(newVel,oldVel,maxChange)local delta=newVel-oldVel if delta.Magnitude>maxChange then return oldVel+(delta.Unit*maxChange)end return newVel end local function smoothVelocity(current,target,alpha)return current:Lerp(target,alpha)end local function predictAerialPosition(currentPos,velocity,dt,isStrafing,isFastFalling,isMultiJump)local horizVel=Vector3.new(velocity.X,0,velocity.Z)local vertVel=velocity.Y if isStrafing then local avgAerial=getAverageAerialVelocity()horizVel=Vector3.new(avgAerial.X,0,avgAerial.Z)*AIR_CONTROL_FACTOR else horizVel=horizVel*AIR_CONTROL_FACTOR end horizVel=horizVel*AERIAL_VELOCITY_DECAY local gravityEffect=GRAVITY*GRAVITY_PREDICTION_WEIGHT if isMultiJump then gravityEffect=gravityEffect*0.3 vertVel=vertVel*0.9 end local verticalDisplacement if isFastFalling then verticalDisplacement=(vertVel*dt)-(0.5*gravityEffect*1.2*dt*dt)-(FALLING_VERTICAL_LEAD*dt)else verticalDisplacement=(vertVel*dt)-(0.5*gravityEffect*dt*dt)end if vertVel>RISING_THRESHOLD and not isMultiJump then verticalDisplacement=verticalDisplacement+(VERTICAL_POSITION_LEAD*dt)end return currentPos+horizVel*dt+Vector3.new(0,verticalDisplacement,0)end local function predictServerPosition(currentPos,velocity,acceleration,ping,isQuickTurn,isAerial,isStrafing,isFastFalling,isMultiJump)local serverDelay=ping+SERVER_TICKRATE if isQuickTurn then serverDelay=serverDelay*QUICK_DIRECTION_CHANGE_MULTIPLIER end if isAerial then return predictAerialPosition(currentPos,velocity,serverDelay,isStrafing,isFastFalling,isMultiJump)end local predictedPos=currentPos+velocity*serverDelay if acceleration.Magnitude>1 then predictedPos=predictedPos+(acceleration*ACCELERATION_PREDICTION_WEIGHT)*(serverDelay*serverDelay*0.5)end return predictedPos end local SPHERE_SMOOTH_SPEED=15 local function createPredictionSphere()if predictionSphere then predictionSphere:Destroy()end predictionSphere=Instance.new("Part")predictionSphere.Name="PredictionSphere"predictionSphere.Shape=Enum.PartType.Ball predictionSphere.Size=Vector3.new(2,2,2)predictionSphere.Anchored=true predictionSphere.CanCollide=false predictionSphere.Material=Enum.Material.Neon predictionSphere.Color=Color3.fromRGB(100,180,255)predictionSphere.Transparency=0.4 local light=Instance.new("PointLight")light.Color=Color3.fromRGB(100,180,255)light.Range=8 light.Brightness=2 light.Parent=predictionSphere predictionSphere.Parent=workspace return predictionSphere end local function updatePredictionSphere(targetPosition,dt)if not predictionSphere then return end local alpha=math.min(1,dt*SPHERE_SMOOTH_SPEED)predictionSphere.CFrame=predictionSphere.CFrame:Lerp(CFrame.new(targetPosition),alpha)end local function updateRotationAngular(lookDirection,rootPart)if not rootPart then return end if lookDirection.Magnitude<0.01 then return end local currentLook=rootPart.CFrame.LookVector local targetDir=lookDirection.Unit local axis=currentLook:Cross(targetDir)local angle=math.asin(math.clamp(axis.Magnitude,-1,1))if axis.Magnitude>0.01 then local rotSpeed=80 rootPart.AssemblyAngularVelocity=axis.Unit*angle*rotSpeed else rootPart.AssemblyAngularVelocity=Vector3.zero end end local circleConnection=nil local circleSafetyConn=nil local function getRivalHubAimbotBat(char)local equipped=char and char:FindFirstChildOfClass("Tool")if equipped then local name=equipped.Name:lower()if name:find("bat",1,true)or name:find("slap",1,true)then return equipped end end local backpack=LP:FindFirstChildOfClass("Backpack")if backpack then for _,tool in ipairs(backpack:GetChildren())do if tool:IsA("Tool")then local name=tool.Name:lower()if name:find("bat",1,true)or name:find("slap",1,true)then return tool end end end end return nil end local function getRivalHubRenderCFrame(root)if not root then return nil end local ok,rendered=pcall(root.GetRenderCFrame,root)return ok and rendered or root.CFrame end local ADAPT_BP_ANG="_AdaptBP_AngV"local ADAPT_BP_ATT="_AdaptBP_Att"local ADAPT_BP_CLEAN={"LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt","AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock",}local ADAPT_BP_SWING_RANGE=12 local adaptBP={equipped=false,target=nil,intendedVelocity=Vector3.zero,angularVelocity=nil,attachment=nil,respawnConn=nil,}_G.__RivalHubBubbleAimbotState=adaptBP local function adaptBPClean(root)if not root then return end pcall(function()for _,n in ipairs(ADAPT_BP_CLEAN)do local c=root:FindFirstChild(n)if c then c:Destroy()end end for _,child in ipairs(root:GetChildren())do if child.Name~=ADAPT_BP_ANG and child.Name~=ADAPT_BP_ATT then local ln=child.Name:lower()if ln:find("lockb")or ln:find("lockangv")or ln:find("batlock")or ln:find("antiaim")or ln:find("velocitylock")then child:Destroy()end end end end)end local function adaptBPEnsureAngular(parent)pcall(function()local a=parent:FindFirstChild(ADAPT_BP_ANG);if a then a:Destroy()end local b=parent:FindFirstChild(ADAPT_BP_ATT);if b then b:Destroy()end end)local att=Instance.new("Attachment")att.Name=ADAPT_BP_ATT att.Parent=parent local angV=Instance.new("AngularVelocity")angV.Name=ADAPT_BP_ANG angV.Attachment0=att angV.RelativeTo=Enum.ActuatorRelativeTo.World angV.MaxTorque=math.huge angV.AngularVelocity=Vector3.zero angV.Parent=parent adaptBP.attachment=att adaptBP.angularVelocity=angV end local function adaptBPRemoveAngular()pcall(function()if adaptBP.angularVelocity and adaptBP.angularVelocity.Parent then adaptBP.angularVelocity:Destroy()end end)pcall(function()if adaptBP.attachment and adaptBP.attachment.Parent then adaptBP.attachment:Destroy()end end)adaptBP.angularVelocity=nil adaptBP.attachment=nil end local function adaptBPFindBat()local char=LP.Character if not char then return nil end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")then local n=child.Name:lower()if n:find("bat")or n:find("slap")then return child end end end local backpack=LP:FindFirstChildOfClass("Backpack")if backpack then for _,child in ipairs(backpack:GetChildren())do if child:IsA("Tool")then local n=child.Name:lower()if n:find("bat")or n:find("slap")then return child end end end end return nil end local function adaptBPNearest(fromRoot)local best,bestDist=nil,math.huge for _,plr in ipairs(Players:GetPlayers())do if plr~=LP and plr.Character then local hrp=plr.Character:FindFirstChild("HumanoidRootPart")local hum=plr.Character:FindFirstChildOfClass("Humanoid")if hrp and hum and hum.Health>0 then local d=(hrp.Position-fromRoot.Position).Magnitude if d<bestDist then bestDist=d;best=hrp end end end end return best,bestDist end startCircleCombat=function()if circleConnection then return end adaptBP.equipped=false adaptBP.target=nil adaptBP.intendedVelocity=Vector3.zero local c0=LP.Character local r0=c0 and c0:FindFirstChild("HumanoidRootPart")if r0 then adaptBPClean(r0)adaptBPEnsureAngular(r0)end circleConnection=RunService.Heartbeat:Connect(function()if not State.bypassBatEnabled then return end local char=LP.Character local humanoid=char and char:FindFirstChildOfClass("Humanoid")local root=char and char:FindFirstChild("HumanoidRootPart")if not root or not humanoid or humanoid.Health<=0 then return end adaptBPClean(root)if not adaptBP.angularVelocity or not adaptBP.angularVelocity.Parent then adaptBPEnsureAngular(root)end if not adaptBP.equipped then adaptBP.equipped=true if not char:FindFirstChildOfClass("Tool")then local b=adaptBPFindBat()if b then pcall(function()humanoid:EquipTool(b)end)end end end local target,dist=adaptBPNearest(root)if not target then adaptBP.target=nil humanoid.AutoRotate=true if adaptBP.angularVelocity then adaptBP.angularVelocity.AngularVelocity=Vector3.zero end return end adaptBP.target=target local aimPos=target.Position+target.CFrame.LookVector*(target.Velocity.Magnitude<0.1 and 1.5 or 5)local delta=aimPos-root.Position local flat=Vector3.new(delta.X,0,delta.Z)humanoid.AutoRotate=false if delta.Magnitude>0.01 and flat.Magnitude>0.01 then local curY=root.Orientation.Y local yawD=(math.deg(math.atan2(-flat.X,-flat.Z))-curY+180)%360-180 local curX=root.Orientation.X local pitchD=(math.deg(math.atan2(delta.Y,flat.Magnitude))-curX+180)%360-180 local rotY=math.clamp(math.rad(yawD)*40,-28,28)local rotX=math.clamp(math.rad(pitchD)*40,-28,28)local yawR=math.rad(root.Orientation.Y)local fwd=Vector3.new(math.cos(yawR),0,-math.sin(yawR))adaptBP.angularVelocity.AngularVelocity=Vector3.new(0,rotY,0)+fwd*rotX else adaptBP.angularVelocity.AngularVelocity=Vector3.zero end local spd=tonumber(State.bypassBatSpeed)or tonumber(BYPASS_AIMBOT_SPEED)or 58 if spd~=spd or spd<=0 or spd==math.huge then spd=58 end adaptBP.intendedVelocity=(flat.Magnitude>0.1 and flat.Unit*spd or Vector3.zero)+(math.abs(delta.Y)>0.8 and Vector3.new(0,math.sign(delta.Y)*spd,0)or Vector3.new(0,-2,0))root.Velocity=adaptBP.intendedVelocity if flat.Magnitude>0.5 then pcall(function()humanoid:Move(flat.Unit,false)end)end if dist<=ADAPT_BP_SWING_RANGE then local bat=char:FindFirstChildOfClass("Tool")if bat and isBatTool and isBatTool(bat)then pcall(function()bat:Activate()local re=bat:FindFirstChildWhichIsA("RemoteEvent")if re then re:FireServer()end end)end end end)circleSafetyConn=RunService.RenderStepped:Connect(function()if not State.bypassBatEnabled then return end local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")if not root then return end local v=root.Velocity if math.abs(v.X)>350 or math.abs(v.Z)>350 then root.Velocity=adaptBP.intendedVelocity end adaptBPClean(root)end)if not adaptBP.respawnConn then adaptBP.respawnConn=LP.CharacterAdded:Connect(function(character)task.wait(0.5)adaptBP.equipped=false adaptBP.target=nil if State.bypassBatEnabled then local root=character:WaitForChild("HumanoidRootPart",5)if root then adaptBPClean(root)adaptBPEnsureAngular(root)end end end)end end stopCircleCombat=function()if circleConnection then circleConnection:Disconnect()circleConnection=nil end if circleSafetyConn then circleSafetyConn:Disconnect()circleSafetyConn=nil end adaptBP.equipped=false adaptBP.target=nil local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if root then pcall(function()root.Velocity=root.Velocity*0.3 end)end if hum then hum.AutoRotate=true end if adaptBP.angularVelocity then pcall(function()adaptBP.angularVelocity.AngularVelocity=Vector3.zero end)end adaptBPRemoveAngular()if root then local a=root:FindFirstChild(ADAPT_BP_ANG);if a then a:Destroy()end local at=root:FindFirstChild(ADAPT_BP_ATT);if at then at:Destroy()end end end end function stopAimbotAdapt()State.bypassBatEnabled=false if stopCircleCombat then pcall(stopCircleCombat)end _aimbotConn=nil local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then hum.AutoRotate=(_prevAutoRotate==nil)and true or _prevAutoRotate hum.PlatformStand=false pcall(function()hum:ChangeState(Enum.HumanoidStateType.Running)end)end if root then root.AssemblyLinearVelocity=_V3new(0,-0.1,0)root.AssemblyAngularVelocity=_V3zero end _prevAutoRotate=nil lastMoveDir=_V3zero _unsuppressBodyLock(true)end function startAimbotAdapt()State.bypassBatSpeed=tonumber(State.bypassBatSpeed)or tonumber(BYPASS_AIMBOT_SPEED)or 60 State.bypassBatEnabled=true _suppressBodyLock()local hum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")if hum0 and _prevAutoRotate==nil then _prevAutoRotate=hum0.AutoRotate end startCircleCombat()end function disableAutoBat()autoBatEnabled=false if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end stopAimbotAdapt()if _G.__ZeyHubbStopBypassBatV2 then pcall(_G.__ZeyHubbStopBypassBatV2)end if _G.__ZeyHubbStopBypassBatV3 then pcall(_G.__ZeyHubbStopBypassBatV3)end if BatAura and BatAura.refresh then pcall(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then pcall(_G.__ZeyHubbBatAuraRefresh)end end function enableAutoBat()if autoLeftEnabled then autoLeftEnabled=false if autoLeftSetVisual then autoLeftSetVisual(false)end stopAutoLeft()end if autoRightEnabled then autoRightEnabled=false if autoRightSetVisual then autoRightSetVisual(false)end stopAutoRight()end autoBatEnabled=true if autoBatSetVisual then autoBatSetVisual(true)end if mobSetAutoBat then mobSetAutoBat(true)end local ver=_G.__ZeyHubbBypassBatVersion or"v1" if ver=="v3" then pcall(function()if stopAimbotAdapt then stopAimbotAdapt()end end)pcall(function()if _G.__ZeyHubbStopBypassBatV2 then _G.__ZeyHubbStopBypassBatV2()end end)if _G.__ZeyHubbStartBypassBatV3 then pcall(_G.__ZeyHubbStartBypassBatV3)end elseif ver=="v2" then pcall(function()if stopAimbotAdapt then stopAimbotAdapt()end end)pcall(function()if _G.__ZeyHubbStopBypassBatV3 then _G.__ZeyHubbStopBypassBatV3()end end)if _G.__ZeyHubbStartBypassBatV2 then pcall(_G.__ZeyHubbStartBypassBatV2)end else pcall(function()if _G.__ZeyHubbStopBypassBatV2 then _G.__ZeyHubbStopBypassBatV2()end end)pcall(function()if _G.__ZeyHubbStopBypassBatV3 then _G.__ZeyHubbStopBypassBatV3()end end)startAimbotAdapt()end if BatAura and BatAura.refresh then pcall(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then pcall(_G.__ZeyHubbBatAuraRefresh)end end function findBat()local char=LP.Character if not char then return nil end for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do local t=char:FindFirstChild(name)if t and t:IsA("Tool")then return t end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do local t=bp:FindFirstChild(name)if t and t:IsA("Tool")then local hum=char:FindFirstChildOfClass("Humanoid")if hum then pcall(function()hum:EquipTool(t)end)end return t end end end for _,ch in ipairs(char:GetChildren())do if ch:IsA("Tool")and(ch.Name:lower():find("bat")or ch.Name:lower():find("slap"))then return ch end end return nil end function isBatTool(tool)if not tool then return false end for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do if tool.Name==name then return true end end return tool.Name:lower():find("bat")or tool.Name:lower():find("slap")end function findBatForCounter()local char=LP.Character if not char then return nil end local backpack=LP:FindFirstChildOfClass("Backpack")for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do local tool=char:FindFirstChild(name)or(backpack and backpack:FindFirstChild(name))if tool then return tool end end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")and(child.Name:lower():find("bat")or child.Name:lower():find("slap"))then return child end end if backpack then for _,child in ipairs(backpack:GetChildren())do if child:IsA("Tool")and(child.Name:lower():find("bat")or child.Name:lower():find("slap"))then return child end end end return nil end function swingBatForCounter(bat,character)local humanoid=character:FindFirstChildOfClass("Humanoid")if bat.Parent~=character and humanoid then pcall(function()humanoid:EquipTool(bat)end)task.wait(0.05)end local remote=bat:FindFirstChildOfClass("RemoteEvent")or bat:FindFirstChildOfClass("RemoteFunction")if remote and remote:IsA("RemoteEvent")then pcall(function()remote:FireServer()end)task.wait(0.1)pcall(function()remote:FireServer()end)else pcall(function()bat:Activate()end)task.wait(0.1)pcall(function()bat:Activate()end)end end batCounterDebounce=false function stopBatCounter()if Conns.batCounter then Conns.batCounter:Disconnect()Conns.batCounter=nil end batCounterDebounce=false end function startBatCounter()if Conns.batCounter then return end Conns.batCounter=RunService.Heartbeat:Connect(function()if not batCounterEnabled then return end if batCounterDebounce then return end local character=LP.Character if not character then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid then return end local state=humanoid:GetState()if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown then batCounterDebounce=true _suppressBodyLock()task.spawn(function()task.wait(0.15)local bat=findBatForCounter()if bat then swingBatForCounter(bat,character)end task.wait(0.3)batCounterDebounce=false _unsuppressBodyLock(true)end)end end)end function findMedusa()local c=LP.Character if not c then return nil end for _,t in ipairs(c:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("medusa")or n:find("head")or n:find("stone")then return t end end end local bp=LP:FindFirstChild("Backpack")if bp then for _,t in ipairs(bp:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("medusa")or n:find("head")or n:find("stone")then return t end end end end return nil end function useMedusaCounter()if medusaDebounce then return end if _tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end local c=LP.Character if not c then return end medusaDebounce=true local med=findMedusa()if not med then medusaDebounce=false;return end if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid")if hum2 then hum2:EquipTool(med)end end pcall(function()med:Activate()end)medusaLastUsed=_tick()medusaDebounce=false end function onAnchorChanged(part)return part:GetPropertyChangedSignal("Anchored"):Connect(function()if medusaCounterEnabled and part.Anchored and part.Transparency==1 then useMedusaCounter()end end)end function setupMedusaCounter(char)for _,c in pairs(Conns.anchor)do pcall(function()c:Disconnect()end)end Conns.anchor={}if not char or not medusaCounterEnabled then return end for _,part in ipairs(char:GetDescendants())do if part:IsA("BasePart")then table.insert(Conns.anchor,onAnchorChanged(part))end end table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)if part:IsA("BasePart")then table.insert(Conns.anchor,onAnchorChanged(part))end end))end function stopMedusaCounter()for _,c in pairs(Conns.anchor)do pcall(function()c:Disconnect()end)end Conns.anchor={}end do _G.RivalMedusaSkinAssets={Skull={mesh="rbxassetid://2050312704",tex="rbxassetid://2050313393",scale=Vector3.new(1,1,1),c0=CFrame.new(0,0.65,-0.4)*CFrame.Angles(math.rad(330),0,0),},GoldenDesertEagle={mesh="rbxassetid://430251413",tex="rbxassetid://435840335",scale=Vector3.new(0.01,0.01,0.01),c0=CFrame.new(0,0,-0.8)*CFrame.Angles(math.rad(330),math.rad(180),0),},NeonSkull={mesh="rbxassetid://2050312704",tex="rbxassetid://2050313393",scale=Vector3.new(1.15,1.15,1.15),c0=CFrame.new(0,0.7,-0.35)*CFrame.Angles(math.rad(330),0,0),},Crystal={mesh="rbxassetid://430251413",tex="rbxassetid://435840335",scale=Vector3.new(0.012,0.012,0.012),c0=CFrame.new(0,0.05,-0.75)*CFrame.Angles(math.rad(320),math.rad(180),0),},Bomb={mesh="rbxassetid://2050312704",tex="rbxassetid://2050313393",scale=Vector3.new(0.85,0.85,0.85),c0=CFrame.new(0,0.55,-0.35)*CFrame.Angles(math.rad(340),0,0),},}_G.RivalMedusaSkin=_G.RivalMedusaSkin or"Default"local function isMedusaTool(tool)if not tool or not tool:IsA("Tool")then return false end local n=tool.Name:lower()return(n:find("medusa")or n:find("stone")or n:find("head"))and true or false end local function clearReplica(tool)local handle=tool and tool:FindFirstChild("Handle")if not handle then return end local rep=handle:FindFirstChild("RivalMedusaReplica")if rep then pcall(function()rep:Destroy()end)end for _,d in ipairs(tool:GetDescendants())do if d:GetAttribute("RivalMedusaHidden")~=nil then local orig=d:GetAttribute("RivalMedusaHidden")pcall(function()d.Transparency=orig end)pcall(function()d:SetAttribute("RivalMedusaHidden",nil)end)end end end local function hideOriginal(tool)for _,d in ipairs(tool:GetDescendants())do if(d:IsA("BasePart")or d:IsA("Decal")or d:IsA("Texture"))and not d:FindFirstAncestor("RivalMedusaReplica")and not d:FindFirstAncestor("ShelMedusaBombSkin")then pcall(function()if d:GetAttribute("RivalMedusaHidden")==nil then d:SetAttribute("RivalMedusaHidden",d.Transparency)end d.Transparency=1 end)end end end local function buildReplica(tool,key)local data=_G.RivalMedusaSkinAssets[key]local handle=tool:FindFirstChild("Handle")if not data or not handle then return end local cur=handle:FindFirstChild("RivalMedusaReplica")if cur and cur:GetAttribute("SkinKey")==key then hideOriginal(tool)for _,d in ipairs(cur:GetDescendants())do if d:IsA("BasePart")then if d.Transparency~=0 then d.Transparency=0 end if d.LocalTransparencyModifier~=0 then d.LocalTransparencyModifier=0 end end end return end clearReplica(tool)hideOriginal(tool)local m=Instance.new("Model")m.Name="RivalMedusaReplica"m:SetAttribute("SkinKey",key)local p=Instance.new("Part")p.Name="MainPart"p.CanCollide=false;p.CanQuery=false;p.CanTouch=false p.Massless=true;p.Anchored=false p.Size=Vector3.new(1,1,1)p.Transparency=0 p.Parent=m local mesh=Instance.new("SpecialMesh")mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId=data.mesh mesh.TextureId=data.tex mesh.Scale=data.scale mesh.Parent=p local w=Instance.new("Motor6D")w.Part0=handle w.Part1=p w.C0=data.c0 w.Parent=p m.Parent=handle end function _G.RivalApplyMedusaSkin()local sk=_G.RivalMedusaSkin or"Default"local containers={}if LP.Character then table.insert(containers,LP.Character)end local bp=LP:FindFirstChildOfClass("Backpack")if bp then table.insert(containers,bp)end for _,container in ipairs(containers)do for _,tool in ipairs(container:GetChildren())do if isMedusaTool(tool)then if sk=="Default"then clearReplica(tool)else buildReplica(tool,sk)end end end end end function _G.RivalSetMedusaSkin(choice)if choice~="Default"and not _G.RivalMedusaSkinAssets[choice]then choice="Default"end _G.RivalMedusaSkin=choice pcall(_G.RivalApplyMedusaSkin)if _G.ShelMedusaSkin and _G.ShelMedusaSkin.apply then pcall(_G.ShelMedusaSkin.apply)end if choice~="Default"then pcall(_G.RivalApplyMedusaSkin)end end task.spawn(function()while true do if(_G.RivalMedusaSkin or"Default")~="Default"then pcall(_G.RivalApplyMedusaSkin)end task.wait(0.6)end end)LP.CharacterAdded:Connect(function()task.wait(0.8)pcall(_G.RivalApplyMedusaSkin)end)end local DROP_ASCEND_DURATION=0.2 local DROP_ASCEND_SPEED=150 local _dropConn=nil function stopDropBrainrot()dropActive=false if _dropConn then _dropConn:Disconnect()_dropConn=nil end for _,t in ipairs(dropConnections)do if type(t)=="thread"then pcall(task.cancel,t)elseif type(t)=="RBXScriptConnection"then pcall(t.Disconnect,t)end end dropConnections={}local c=LP.Character if c then local root=c:FindFirstChild("HumanoidRootPart")if root then root.AssemblyLinearVelocity=_V3zero end end if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end end function runDropBrainrot()if dropActive then return end local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if not root or not hum then return end if dropMode==1 then local speedH=0 if root then local vel=root.AssemblyLinearVelocity speedH=_V3new(vel.X,0,vel.Z).Magnitude end local cooldown=(speedH>5)and 0.6 or 0.25 if _tick()-lastDropTime<cooldown then return end lastDropTime=_tick()dropActive=true if dropBrainrotSetVisual then dropBrainrotSetVisual(true)end if mobSetDropBR then mobSetDropBR(true)end local wasAutoBat=false if autoBatEnabled then wasAutoBat=true disableAutoBat()if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end end local function finishDrop(threadRef)if threadRef and dropConnections then for i=#dropConnections,1,-1 do if dropConnections[i]==threadRef then table.remove(dropConnections,i)break end end end dropActive=false local c=LP.Character if c then local r=c:FindFirstChild("HumanoidRootPart")local h=c:FindFirstChildOfClass("Humanoid")if r then r.AssemblyLinearVelocity=_V3zero r.AssemblyAngularVelocity=_V3zero if r.Position.Y<-100 then r.CFrame=_CFnew(r.Position.X,5,r.Position.Z)end local rp=RaycastParams.new()rp.FilterDescendantsInstances={c}rp.FilterType=Enum.RaycastFilterType.Exclude local rr=workspace:Raycast(r.Position,_V3new(0,-2000,0),rp)if rr then local off=(h and h.HipHeight or 2)+(r.Size.Y/2)r.CFrame=_CFnew(r.Position.X,rr.Position.Y+off,r.Position.Z)end if h and h.Health>0 then h:ChangeState(Enum.HumanoidStateType.Running)end end end if wasAutoBat then enableAutoBat()if autoBatSetVisual then autoBatSetVisual(true)end if mobSetAutoBat then mobSetAutoBat(true)end end if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end end local flingThread=nil flingThread=task.spawn(function()local startTime=_tick()while dropActive and(_tick()-startTime)<0.25 do RunService.Heartbeat:Wait()local c=LP.Character local r=c and c:FindFirstChild("HumanoidRootPart")if not r then break end local vel=r.AssemblyLinearVelocity vel=_V3new(0,vel.Y,0)r.AssemblyLinearVelocity=vel*10000+_V3new(0,10000,0)RunService.RenderStepped:Wait()if r and r.Parent then r.AssemblyLinearVelocity=vel end RunService.Stepped:Wait()if r and r.Parent then r.AssemblyLinearVelocity=vel+_V3new(0,0.1,0)end end finishDrop(flingThread)end)table.insert(dropConnections,flingThread)task.delay(0.35,function()if dropActive then finishDrop(flingThread)end end)return end if autoBatEnabled then autoBatEnabled=false if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end if stopAimbotAdapt then stopAimbotAdapt()end end dropActive=true if dropBrainrotSetVisual then dropBrainrotSetVisual(true)end if mobSetDropBR then mobSetDropBR(false)end local t0=_tick()if _dropConn then _dropConn:Disconnect()end _dropConn=RunService.Heartbeat:Connect(function()local r=char and char:FindFirstChild("HumanoidRootPart")if not r then if _dropConn then _dropConn:Disconnect();_dropConn=nil end dropActive=false if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end return end if _tick()-t0>=DROP_ASCEND_DURATION then if _dropConn then _dropConn:Disconnect();_dropConn=nil end local rp=_RayParams_new()rp.FilterDescendantsInstances={char}rp.FilterType=Enum.RaycastFilterType.Exclude local rr=workspace:Raycast(r.Position,_V3new(0,-2000,0),rp)if rr then local hum2=char:FindFirstChildOfClass("Humanoid")local off=((hum2 and hum2.HipHeight)or 2)+(r.Size.Y/2)r.CFrame=_CFnew(r.Position.X,rr.Position.Y+off,r.Position.Z)r.AssemblyLinearVelocity=_V3zero end dropActive=false if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end return end r.Velocity=_V3new(r.Velocity.X,DROP_ASCEND_SPEED,r.Velocity.Z)end)end function executeDropWithToggle(setVisual)if dropActive then return end task.spawn(function()if setVisual then setVisual(true)end runDropBrainrot()while dropActive do task.wait()end task.wait(0.1)if setVisual then setVisual(false)end end)end local _alSaved=setmetatable({},{__mode="k"})local _alDetached={}local _alAnimators=setmetatable({},{__mode="k"})local _alStoppedTracks=setmetatable({},{__mode="k"})local _alGeneration=0 local _alScanCancel=nil local _alConns={}local _alLightOrig=nil local _alRunning=false local AL_LOW_FLAGS={{"DFIntClusterSenderMaxJoinBandwidthBps","2100000000"},{"DFIntClusterSenderMaxUpdateBandwidthBps","2100000000"},{"DFIntServerFramesBetweenJoins","1"},{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2","10000"},{"DFIntConnectionMTUSize","1400"},{"FIntRakNetResendBufferArrayLength","1024"},{"DFIntRakNetNakResendDelayMsMax","1"},{"DFIntWaitOnUpdateNetworkLoopEndedMS","100"},{"DFIntWaitOnRecvFromLoopEndedMS","100"},{"DFIntLargePacketQueueSizeCutoffMB","1000"},{"DFIntSendRakNetStatsInterval","2147483647"},{"DFIntRakNetLoopMs","1"},{"DFIntRakNetSelectTimeoutMs","1"},{"DFIntNetworkClusterPacketCacheNumParallelTasks","8"},{"DFIntReplicationDataCacheNumParallelTasks","8"},{"DFIntMegaReplicatorNumParallelTasks","16"},{"DFIntMaxProcessPacketsStepsPerCyclic","512"},{"DFIntMaxProcessPacketsStepsAccumulated","0"},{"DFIntMaxProcessPacketsJobScaling","1000"},{"DFIntClientPacketMaxFrameMicroseconds","200000"},{"DFIntClientPacketExcessMicroseconds","10000"},{"DFIntClientPacketMinMicroseconds","1"},{"DFIntClientPacketMaxDelayMs","1"},{"DFIntMaxWaitTimeBeforeForcePacketProcessMS","1"},{"DFIntMaxFrameBufferSize","4"},{"DFIntBufferCompressionThreshold","100"},{"DFIntOverrideISRReplicatorStepBandwidthBytes","131072"},{"DFIntTaskSchedulerJobInitThreads","8"},{"DFIntTaskSchedulerJobInGameThreads","8"},{"FIntTaskSchedulerAutoThreadLimit","16"},{"FIntTaskSchedulerAsyncTasksMinimumThreadCount","4"},{"DFIntRuntimeConcurrency","16"},{"FIntSimWorldTaskQueueParallelTasks","20"},{"DFIntHttpBatchLimit","256"},{"FIntHttpBatchLimit","256"},{"DFIntHttpCurlConnectionCacheSize","512"},{"FIntDefaultMeshCacheSizeMB","512"},{"DFIntMemCacheMaxCapacityMB","256"},{"DFIntNumAssetsMaxToPreload","1"},{"DFFlagEnableSoundPreloading","false"},{"FFlagSlimContentProvider","true"},{"DFFlagDebugSkipMeshVoxelizer","true"},{"DFFlagTextureQualityOverrideEnabled","true"},{"DFIntTextureQualityOverride","0"},{"FIntDebugTextureManagerSkipMips","7"},{"DFIntDebugLimitMinTextureResolutionWhenSkipMips","8"},{"FFlagTM2SkipMipsForUnstreamable2","true"},{"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS","true"},{"FFlagRenderUseTextureManager224","false"},{"DFIntDebugFRMQualityLevelOverride","1"},{"DFFlagDebugPauseVoxelizer","true"},{"FFlagFastGPULightCulling3","true"},{"FIntRenderLocalLightFadeInMs","0"},{"FIntRenderLocalLightUpdatesMax","1"},{"FIntRenderShadowmapBias","0"},{"FIntSSAOMipLevels","0"},{"FIntDebugForceMSAASamples","1"},{"FIntDebugFRMOptionalMSAALevelOverride","0"},{"FIntRobloxGuiBlurIntensity","0"},{"FIntFRMMinGrassDistance","0"},{"FIntFRMMaxGrassDistance","0"},{"DFFlagCoreScriptTelemetry2","false"},{"DFFlagBrowserTrackerIdTelemetryEnabled","false"},{"FFlagPerfDataOnTelemetryV2","false"},{"FFlagSendRenderFidelityTelemetry2","false"},{"FFlagEnableTelemetryServiceMemoryCPUInfo","false"},{"DFIntTelemetryProfilerHundredthsPercentage","0"},{"FIntTelemetryProfilerFrequency","0"},{"FIntPerformanceTelemetryQueueProcessLimit","0"},{"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage","0"},}local function _alApplyLowFlags()local env=(getgenv and getgenv())or _G local setter=rawget(env,"setfflag")or rawget(_G,"set_fflag")local getter=rawget(env,"getfflag")or rawget(_G,"get_fflag")if type(setter)~="function"then return end for _,flag in ipairs(AL_LOW_FLAGS)do local canSet=true if type(getter)=="function"then local ok,current=pcall(getter,flag[1])canSet=ok and current~=nil end if canSet then pcall(setter,flag[1],tostring(flag[2]))end end end local function _alSaveLighting()if _alLightOrig then return end _alLightOrig={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,OutdoorAmbient=Lighting.OutdoorAmbient,Ambient=Lighting.Ambient,GlobalShadows=Lighting.GlobalShadows,EnvironmentDiffuseScale=Lighting.EnvironmentDiffuseScale,EnvironmentSpecularScale=Lighting.EnvironmentSpecularScale,FogStart=Lighting.FogStart,FogEnd=Lighting.FogEnd,}end local function _alApplyLowPermanentSettings()pcall(function()settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)pcall(function()UserSettings():GetService("UserGameSettings").SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1 end)pcall(function()Lighting.GlobalShadows=false Lighting.EnvironmentDiffuseScale=0.35 Lighting.EnvironmentSpecularScale=0.35 Lighting.FogStart=0 Lighting.FogEnd=1e10 Lighting.Brightness=math.max(tonumber(Lighting.Brightness)or 2,2.5)local amb=Lighting.Ambient local out=Lighting.OutdoorAmbient Lighting.Ambient=Color3.fromRGB(math.clamp(amb.R*255*0.9+35,0,255),math.clamp(amb.G*255*0.9+35,0,255),math.clamp(amb.B*255*0.9+35,0,255))Lighting.OutdoorAmbient=Color3.fromRGB(math.clamp(out.R*255*0.9+40,0,255),math.clamp(out.G*255*0.9+40,0,255),math.clamp(out.B*255*0.9+40,0,255))end)pcall(function()local atmosphere=Lighting:FindFirstChildOfClass("Atmosphere")if atmosphere then atmosphere.Density=0 atmosphere.Glare=0 atmosphere.Haze=0 end end)pcall(function()local terrain=workspace:FindFirstChildOfClass("Terrain")if terrain then terrain.Decoration=false terrain.WaterWaveSize=0 terrain.WaterWaveSpeed=0 terrain.WaterReflectance=0 local clouds=terrain:FindFirstChildOfClass("Clouds")if clouds then clouds.Enabled=false end end end)end local function _alChange(object,property,value)pcall(function()local original=object[property]if original==value then return end object[property]=value local bucket=_alSaved[object]if not bucket then bucket={};_alSaved[object]=bucket end if not bucket[property]then bucket[property]={value=original}end end)end local function _alIsProtectedVisual(object)local char=LP.Character if char and(object==char or object:IsDescendantOf(char))then return true end if object:GetAttribute("_AdaptDuelsSky")==true then return true end local parent=object while parent and parent~=workspace do if parent:IsA("LayerCollector")or parent:IsA("GuiObject")or parent:IsA("GuiBase2d")then return true end local name=parent.Name or""if name:match("^Crystal")or name:match("^Eclipse")or name:match("^ESP_")or name:match("^BloodHounds")or name:match("^RivalHub")then return true end parent=parent.Parent end return false end function applyAntiLagDerender(obj)pcall(function()if not _alRunning then return end if _alIsProtectedVisual(obj)then return end if obj:IsA("Terrain")then _alChange(obj,"Decoration",false)_alChange(obj,"WaterWaveSize",0)_alChange(obj,"WaterWaveSpeed",0)_alChange(obj,"WaterReflectance",0)_alChange(obj,"WaterTransparency",1)end if obj:IsA("BasePart")then _alChange(obj,"Material",Enum.Material.Plastic)_alChange(obj,"MaterialVariant","")_alChange(obj,"Reflectance",0)_alChange(obj,"CastShadow",false)if obj:IsA("MeshPart")then _alChange(obj,"TextureID","")_alChange(obj,"RenderFidelity",Enum.RenderFidelity.Performance)_alChange(obj,"DoubleSided",false)elseif obj:IsA("PartOperation")then _alChange(obj,"RenderFidelity",Enum.RenderFidelity.Performance)end elseif obj:IsA("SpecialMesh")then _alChange(obj,"TextureId","")elseif obj:IsA("SurfaceAppearance")then _alDetached[obj]=true _alChange(obj,"Parent",nil)elseif obj:IsA("Decal")or obj:IsA("Texture")then _alChange(obj,"Transparency",1)_alChange(obj,"Texture","")elseif obj:IsA("ParticleEmitter")then _alChange(obj,"Enabled",false)_alChange(obj,"Rate",0)pcall(function()obj:Clear()end)elseif obj:IsA("Trail")then _alChange(obj,"Enabled",false)pcall(function()obj:Clear()end)elseif obj:IsA("Beam")or obj:IsA("Fire")or obj:IsA("Smoke")or obj:IsA("Sparkles")or obj:IsA("Light")or obj:IsA("PostEffect")or obj:IsA("Clouds")then _alChange(obj,"Enabled",false)elseif obj:IsA("Atmosphere")then _alChange(obj,"Density",0)_alChange(obj,"Haze",0)_alChange(obj,"Glare",0)elseif obj:IsA("Sky")then for _,face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"})do _alChange(obj,face,"")end _alChange(obj,"StarCount",0)_alChange(obj,"CelestialBodiesShown",false)elseif obj:IsA("Shirt")then _alChange(obj,"ShirtTemplate","")elseif obj:IsA("Pants")then _alChange(obj,"PantsTemplate","")elseif obj:IsA("ShirtGraphic")then _alChange(obj,"Graphic","")elseif obj:IsA("Animator")then if not _alAnimators[obj]then local char=LP.Character if not(char and obj:IsDescendantOf(char))then _alAnimators[obj]=true local token=_alGeneration local ok,conn=pcall(function()return obj.AnimationPlayed:Connect(function(track)if not _alRunning or _alGeneration~=token then return end task.defer(function()if _alRunning and _alGeneration==token then pcall(function()track:Stop(0)end)end end)end)end)if ok then table.insert(_alConns,conn)end pcall(function()for _,track in ipairs(obj:GetPlayingAnimationTracks())do if track.IsPlaying then _alStoppedTracks[track]={animator=obj,time=track.TimePosition,speed=track.Speed,}track:Stop(0)end end end)end end end end)end function enableAntiLag()if _alRunning then return end _alRunning=true antiLagEnabled=true _alGeneration=_alGeneration+1 local token=_alGeneration _alSaveLighting()_alApplyLowFlags()_alApplyLowPermanentSettings()for _,delaySeconds in ipairs({2,6,12,20})do task.delay(delaySeconds,function()if _alRunning and _alGeneration==token then _alApplyLowFlags()end end)end pcall(function()game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()end)table.insert(_alConns,workspace.DescendantAdded:Connect(function(obj)task.defer(function()if _alRunning and _alGeneration==token then pcall(applyAntiLagDerender,obj)end end)end))table.insert(_alConns,Lighting.DescendantAdded:Connect(function(obj)task.defer(function()if _alRunning and _alGeneration==token then pcall(applyAntiLagDerender,obj)end end)end))local function walkBatched(roots,apply,shouldContinue)task.spawn(function()local pending={}for _,root in ipairs(roots)do if root then local ok,children=pcall(function()return root:GetChildren()end)if ok then for _,c in ipairs(children)do table.insert(pending,c)end end end end while#pending>0 and _alRunning and _alGeneration==token and shouldContinue()do local deadline=os.clock()+0.0008 while#pending>0 and os.clock()<deadline do local obj=table.remove(pending)pcall(apply,obj)local ok,children=pcall(function()return obj:GetChildren()end)if ok then for _,c in ipairs(children)do table.insert(pending,c)end end end RunService.Heartbeat:Wait()end end)end walkBatched({workspace,Lighting},applyAntiLagDerender,function()return _alRunning and _alGeneration==token end)end function disableAntiLag()if not _alRunning then antiLagEnabled=false return end _alRunning=false antiLagEnabled=false _alGeneration=_alGeneration+1 if _alScanCancel then pcall(_alScanCancel);_alScanCancel=nil end for _,conn in ipairs(_alConns)do pcall(function()conn:Disconnect()end)end _alConns={}for object,properties in pairs(_alSaved)do for property,original in pairs(properties)do pcall(function()object[property]=original.value end)end end _alSaved=setmetatable({},{__mode="k"})_alDetached={}_alAnimators=setmetatable({},{__mode="k"})for track,state in pairs(_alStoppedTracks)do pcall(function()if state.animator.Parent and not track.IsPlaying then track:Play(0,1,state.speed)track.TimePosition=state.time end end)end _alStoppedTracks=setmetatable({},{__mode="k"})if _alLightOrig then pcall(function()Lighting.Brightness=_alLightOrig.Brightness Lighting.ClockTime=_alLightOrig.ClockTime Lighting.OutdoorAmbient=_alLightOrig.OutdoorAmbient Lighting.Ambient=_alLightOrig.Ambient Lighting.GlobalShadows=_alLightOrig.GlobalShadows Lighting.EnvironmentDiffuseScale=_alLightOrig.EnvironmentDiffuseScale Lighting.EnvironmentSpecularScale=_alLightOrig.EnvironmentSpecularScale Lighting.FogStart=_alLightOrig.FogStart Lighting.FogEnd=_alLightOrig.FogEnd end)_alLightOrig=nil end end function applyStretchFOV(val)local cam=workspace.CurrentCamera if cam then pcall(function()cam.FieldOfView=val end)end end function enableStretch()if stretchConn then return end stretchEnabled=true local cam=workspace.CurrentCamera if not cam then return end origFOV=cam.FieldOfView or 70 applyStretchFOV(stretchFOV)stretchConn=RunService.RenderStepped:Connect(function()if not stretchEnabled then stretchConn:Disconnect()stretchConn=nil return end local c=workspace.CurrentCamera if c then c.CFrame=c.CFrame*_CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1)end end)if stretchFovConn then stretchFovConn:Disconnect()end stretchFovConn=RunService.RenderStepped:Connect(function()if stretchEnabled then applyStretchFOV(stretchFOV)else stretchFovConn:Disconnect();stretchFovConn=nil end end)end function disableStretch()stretchEnabled=false if stretchConn then stretchConn:Disconnect();stretchConn=nil end if stretchFovConn then stretchFovConn:Disconnect();stretchFovConn=nil end local cam=workspace.CurrentCamera if cam then pcall(function()cam.FieldOfView=origFOV or 70 end)end end local function saveLightingState()if _originalLighting then return end _originalLighting={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,OutdoorAmbient=Lighting.OutdoorAmbient,GlobalShadows=Lighting.GlobalShadows,FogEnd=Lighting.FogEnd,FogStart=Lighting.FogStart,FogColor=Lighting.FogColor,Ambient=Lighting.Ambient,ColorCorrection=nil,Bloom=nil,}for _,e in ipairs(Lighting:GetChildren())do if e:IsA("ColorCorrectionEffect")then _originalLighting.ColorCorrection={Enabled=e.Enabled,Brightness=e.Brightness,Contrast=e.Contrast,Saturation=e.Saturation,TintColor=e.TintColor}elseif e:IsA("BloomEffect")then _originalLighting.Bloom={Enabled=e.Enabled,Intensity=e.Intensity,Size=e.Size,Threshold=e.Threshold}end end end local function restoreLightingState()if not _originalLighting then return end local old=_originalLighting Lighting.Brightness=old.Brightness Lighting.ClockTime=old.ClockTime Lighting.OutdoorAmbient=old.OutdoorAmbient Lighting.GlobalShadows=old.GlobalShadows Lighting.FogEnd=old.FogEnd Lighting.FogStart=old.FogStart Lighting.FogColor=old.FogColor Lighting.Ambient=old.Ambient if old.ColorCorrection then local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")if cc then cc.Enabled=old.ColorCorrection.Enabled;cc.Brightness=old.ColorCorrection.Brightness cc.Contrast=old.ColorCorrection.Contrast;cc.Saturation=old.ColorCorrection.Saturation cc.TintColor=old.ColorCorrection.TintColor end end if old.Bloom then local bloom=Lighting:FindFirstChildOfClass("BloomEffect")if bloom then bloom.Enabled=old.Bloom.Enabled;bloom.Intensity=old.Bloom.Intensity bloom.Size=old.Bloom.Size;bloom.Threshold=old.Bloom.Threshold end end end SKY_PRESETS_LIST={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}SKY_PRESETS={["Off"]={kind="off"},["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},}local function _vC3(t)return Color3.fromRGB(t[1],t[2],t[3])end function _v4mpClearSky()for _,child in ipairs(Lighting:GetChildren())do if child:GetAttribute("_AdaptDuelsSky")then pcall(function()child:Destroy()end)end end local terrain=workspace:FindFirstChildOfClass("Terrain")if terrain then for _,child in ipairs(terrain:GetChildren())do if child:GetAttribute("_AdaptDuelsSky")then pcall(function()child:Destroy()end)end end end end function applyCustomSky(mode)_v4mpClearSky()local preset=SKY_PRESETS[mode]if not preset or preset.kind=="off"then Lighting.ClockTime=14 Lighting.Brightness=2 Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127)Lighting.Ambient=Color3.fromRGB(127,127,127)Lighting.FogEnd=100000 Lighting.GlobalShadows=true skyTheme="Off"return end Lighting.FogStart=0 Lighting.FogEnd=100000 Lighting.FogColor=Color3.fromRGB(200,200,200)Lighting.ColorShift_Top=Color3.fromRGB(0,0,0)Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0)Lighting.GlobalShadows=true Lighting.ClockTime=preset.clock or 14 Lighting.Brightness=math.clamp(tonumber(preset.brightness)or 2,1.2,2.8)if preset.outAmb then Lighting.OutdoorAmbient=_vC3(preset.outAmb)end if preset.ambient then Lighting.Ambient=_vC3(preset.ambient)end local amb=Lighting.Ambient local out=Lighting.OutdoorAmbient local function softLift(c,floor)local r=math.clamp(c.R*255*0.92+floor*0.15,0,255)local g=math.clamp(c.G*255*0.92+floor*0.15,0,255)local b=math.clamp(c.B*255*0.92+floor*0.15,0,255)return Color3.fromRGB(r,g,b)end Lighting.Ambient=softLift(amb,40)Lighting.OutdoorAmbient=softLift(out,45)if preset.sky then local skyInst=Instance.new("Sky")skyInst:SetAttribute("_AdaptDuelsSky",true)if preset.sky.stars then skyInst.StarCount=preset.sky.stars end if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg"end skyInst.Parent=Lighting end if preset.atm then local atm=Instance.new("Atmosphere")atm:SetAttribute("_AdaptDuelsSky",true)atm.Density=math.clamp((preset.atm.dens or 0.3)*0.55,0.05,0.45)atm.Color=_vC3(preset.atm.color)atm.Decay=_vC3(preset.atm.decay)atm.Glare=math.clamp((preset.atm.glare or 1)*0.45,0,1.2)atm.Haze=math.clamp((preset.atm.haze or 1)*0.5,0,2)atm.Parent=Lighting end local terrain=workspace:FindFirstChildOfClass("Terrain")if preset.clouds and terrain then local clouds=Instance.new("Clouds")clouds:SetAttribute("_AdaptDuelsSky",true)clouds.Cover=preset.clouds.cover or 0.5 clouds.Density=preset.clouds.dens or 0.5 clouds.Color=_vC3(preset.clouds.color)clouds.Parent=terrain end skyTheme=mode end function enableVividGraphics()if vividGraphicsEnabled and#_vividEffects>0 then return end vividGraphicsEnabled=true for _,eff in ipairs(_vividEffects)do pcall(function()eff:Destroy()end)end _vividEffects={}local color=Instance.new("ColorCorrectionEffect")color.Parent=Lighting color.Saturation=0.6;color.Contrast=0.4;color.Brightness=0.05 color.TintColor=Color3.fromRGB(255,240,220)table.insert(_vividEffects,color)local bloom=Instance.new("BloomEffect")bloom.Parent=Lighting bloom.Intensity=0.8;bloom.Size=24;bloom.Threshold=1 table.insert(_vividEffects,bloom)local atmosphere=Instance.new("Atmosphere")atmosphere.Parent=Lighting atmosphere.Density=0.3;atmosphere.Offset=0.25 atmosphere.Color=Color3.fromRGB(199,199,255)atmosphere.Decay=Color3.fromRGB(106,112,125)atmosphere.Glare=0.2;atmosphere.Haze=1 table.insert(_vividEffects,atmosphere)local sun=Instance.new("SunRaysEffect")sun.Parent=Lighting sun.Intensity=0.2;sun.Spread=0.8 table.insert(_vividEffects,sun)local dof=Instance.new("DepthOfFieldEffect")dof.Parent=Lighting dof.FocusDistance=25;dof.InFocusRadius=10 dof.NearIntensity=0.2;dof.FarIntensity=0.4 table.insert(_vividEffects,dof)task.spawn(function()while vividGraphicsEnabled and color and color.Parent do color.Contrast=0.35+math.sin(tick()*2)*0.05 task.wait(0.03)end end)end function disableVividGraphics()vividGraphicsEnabled=false for _,eff in ipairs(_vividEffects)do pcall(function()eff:Destroy()end)end _vividEffects={}end function toggleVividGraphics(on)if on then enableVividGraphics()else disableVividGraphics()end saveAllSettings(true)end function applyHideButtons(state)hideButtonsEnabled=state if MobilePanel then for _,child in ipairs(MobilePanel:GetChildren())do if child:IsA("TextButton")then child.Visible=not state end end end end function toggleHideButtons(on)applyHideButtons(on)if setHideButtonsVisual then setHideButtonsVisual(on)end saveAllSettings(true)end function paintFloatingBtn(btnFrame,active)
if not btnFrame then return end
local style=tostring(floatingButtonStyle or "V2")
local shape=tostring(floatingButtonShape or "V1")
local bg=btnFrame:FindFirstChild("BtnGrad")
local label=btnFrame:FindFirstChild("TextLabel")
local stroke=btnFrame:FindFirstChild("NormalStroke") or btnFrame:FindFirstChildOfClass("UIStroke")
local accent=btnFrame:FindFirstChild("AccentBar")
local corner=btnFrame:FindFirstChildOfClass("UICorner")
btnFrame.ClipsDescendants=true

-- REAL shapes (size + corners). V2 = wide rectangle, not a square.
local baseScale=(btnFrame:FindFirstChildOfClass("UIScale") and btnFrame:FindFirstChildOfClass("UIScale").Scale) or floatingButtonScale or 1
local sqW,sqH=62,62
local rectW,rectH=78,50
local circW,circH=62,62
local tw,th=sqW,sqH
local radius=UDim.new(0,14)
if shape=="V2" then
tw,th=rectW,rectH
radius=UDim.new(0,8)
elseif shape=="V3" then
tw,th=circW,circH
radius=UDim.new(1,0)
else
tw,th=sqW,sqH
radius=UDim.new(0,14)
end
-- size only; never move the button on paint/toggle (fixes teleport bug)
local prevShape=btnFrame:GetAttribute("ZeyHubbBtnShape")
btnFrame.Size=UDim2.new(0,tw,0,th)
if prevShape~=shape then
btnFrame:SetAttribute("ZeyHubbBtnShape",shape)
-- only on shape change: keep top-left stable (no center math on AbsolutePosition)
end
if corner then corner.CornerRadius=radius end
if label then
if shape=="V2" then
label.Size=UDim2.new(1,-10,1,-8)
label.Position=UDim2.new(0,5,0,4)
label.TextSize=11
else
label.Size=UDim2.new(1,-8,1,-14)
label.Position=UDim2.new(0,4,0,10)
label.TextSize=10
end
end

local topLight=btnFrame:FindFirstChild("TopLight")
if topLight then topLight.Visible=false end
local glow=btnFrame:FindFirstChild("GlowRing")
if glow then glow.Visible=false end

local shine=btnFrame:FindFirstChild("ActiveShine")
if not shine then
shine=Instance.new("Frame")
shine.Name="ActiveShine"
shine.BackgroundColor3=Color3.fromRGB(255,170,60)
shine.BorderSizePixel=0
shine.Size=UDim2.new(1,0,1,0)
shine.Position=UDim2.new(0,0,0,0)
shine.ZIndex=(btnFrame.ZIndex or 100)+1
shine.Active=false
shine.Parent=btnFrame
local sc=Instance.new("UICorner",shine)
sc.Name="ShineCorner"
local sg=Instance.new("UIGradient",shine)
sg.Name="ShineGrad"
sg.Rotation=90
sg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,230,160)),
ColorSequenceKeypoint.new(0.35,Color3.fromRGB(255,160,50)),
ColorSequenceKeypoint.new(1.00,Color3.fromRGB(180,70,10)),
})
sg.Transparency=NumberSequence.new({
NumberSequenceKeypoint.new(0.00,0.35),
NumberSequenceKeypoint.new(0.45,0.55),
NumberSequenceKeypoint.new(1.00,0.85),
})
end
local shineCorner=shine:FindFirstChild("ShineCorner") or shine:FindFirstChildOfClass("UICorner")
if shineCorner then shineCorner.CornerRadius=radius end
if active then
shine.Visible=true
shine.BackgroundTransparency=0.22
pcall(function()
if TS then TS:Create(shine,TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=0.4}):Play() end
end)
else
shine.Visible=false
shine.BackgroundTransparency=1
end
if label then label.ZIndex=(btnFrame.ZIndex or 100)+3 end
if accent then
accent.ZIndex=(btnFrame.ZIndex or 100)+4
accent.Visible=true
accent.Size=UDim2.new(shape=="V2" and 0.7 or 0.55,0,0,2.5)
accent.Position=UDim2.new(0.5,0,0,shape=="V2" and 5 or 6)
end

local function setLabel(col,sc,st)
if not label then return end
label.Font=Enum.Font.GothamBlack
label.TextColor3=col
local ls=label:FindFirstChildOfClass("UIStroke")
if not ls then ls=Instance.new("UIStroke",label) end
ls.Thickness=1 ls.Color=sc or Color3.fromRGB(0,0,0) ls.Transparency=st or 0.6
end
local function setAccent(on,col)
if not accent then return end
accent.BackgroundColor3=col
accent.BackgroundTransparency=on and 0.05 or 0.28
end
local function applyGrad(rot,a0,a1,a2,b0,b1,b2)
if not bg then return end
bg.Rotation=rot or 90
if active then
bg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0.00,a0),
ColorSequenceKeypoint.new(0.45,a1),
ColorSequenceKeypoint.new(1.00,a2),
})
else
bg.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0.00,b0),
ColorSequenceKeypoint.new(0.50,b1),
ColorSequenceKeypoint.new(1.00,b2),
})
end
end

-- 26 styles
if style=="V1" then
applyGrad(90,Color3.fromRGB(255,190,90),Color3.fromRGB(220,110,25),Color3.fromRGB(50,22,5),Color3.fromRGB(48,48,56),Color3.fromRGB(28,28,34),Color3.fromRGB(12,12,16))
btnFrame.BackgroundColor3=active and Color3.fromRGB(230,110,20) or Color3.fromRGB(28,28,34)
setAccent(active,active and Color3.fromRGB(255,210,130) or Color3.fromRGB(90,90,100))
setLabel(active and Color3.fromRGB(255,245,220) or Color3.fromRGB(200,200,210),Color3.fromRGB(0,0,0),0.55)
elseif style=="V2" then
applyGrad(135,Color3.fromRGB(255,245,210),Color3.fromRGB(255,170,50),Color3.fromRGB(20,10,0),Color3.fromRGB(255,255,255),Color3.fromRGB(230,232,240),Color3.fromRGB(185,190,205))
btnFrame.BackgroundColor3=active and Color3.fromRGB(230,110,20) or Color3.fromRGB(230,232,240)
setAccent(active,active and Color3.fromRGB(255,235,180) or Color3.fromRGB(200,200,210))
setLabel(active and Color3.fromRGB(255,248,230) or Color3.fromRGB(35,38,48),active and Color3.fromRGB(20,10,0) or Color3.fromRGB(180,180,190),0.5)
elseif style=="V3" then
applyGrad(45,Color3.fromRGB(255,160,230),Color3.fromRGB(170,70,255),Color3.fromRGB(40,15,70),Color3.fromRGB(42,30,58),Color3.fromRGB(24,18,34),Color3.fromRGB(12,10,18))
btnFrame.BackgroundColor3=active and Color3.fromRGB(150,50,210) or Color3.fromRGB(24,18,34)
setAccent(active,active and Color3.fromRGB(255,190,255) or Color3.fromRGB(120,100,150))
setLabel(active and Color3.fromRGB(255,245,255) or Color3.fromRGB(210,195,230),Color3.fromRGB(30,15,50),0.55)
elseif style=="V4" then
applyGrad(100,Color3.fromRGB(200,255,255),Color3.fromRGB(60,200,255),Color3.fromRGB(10,40,80),Color3.fromRGB(36,48,60),Color3.fromRGB(20,28,38),Color3.fromRGB(10,14,20))
btnFrame.BackgroundColor3=active and Color3.fromRGB(40,170,230) or Color3.fromRGB(20,28,38)
setAccent(active,active and Color3.fromRGB(180,250,255) or Color3.fromRGB(90,120,140))
setLabel(active and Color3.fromRGB(240,255,255) or Color3.fromRGB(190,210,225),Color3.fromRGB(0,30,50),0.55)
elseif style=="V5" then
applyGrad(90,Color3.fromRGB(180,255,190),Color3.fromRGB(40,210,110),Color3.fromRGB(5,40,20),Color3.fromRGB(30,48,36),Color3.fromRGB(16,28,20),Color3.fromRGB(8,14,10))
btnFrame.BackgroundColor3=active and Color3.fromRGB(30,180,90) or Color3.fromRGB(16,28,20)
setAccent(active,active and Color3.fromRGB(180,255,200) or Color3.fromRGB(70,110,85))
setLabel(active and Color3.fromRGB(235,255,240) or Color3.fromRGB(180,210,190),Color3.fromRGB(0,30,10),0.55)
elseif style=="V6" then
-- pure black / neon lime (very different from V1)
applyGrad(0,Color3.fromRGB(210,255,80),Color3.fromRGB(120,220,20),Color3.fromRGB(20,40,0),Color3.fromRGB(18,18,18),Color3.fromRGB(10,10,10),Color3.fromRGB(0,0,0))
btnFrame.BackgroundColor3=active and Color3.fromRGB(140,230,20) or Color3.fromRGB(10,10,10)
setAccent(active,active and Color3.fromRGB(230,255,120) or Color3.fromRGB(60,60,60))
setLabel(active and Color3.fromRGB(20,30,0) or Color3.fromRGB(210,210,210),Color3.fromRGB(0,0,0),0.4)
elseif style=="V7" then
applyGrad(90,Color3.fromRGB(255,120,140),Color3.fromRGB(220,30,70),Color3.fromRGB(40,0,10),Color3.fromRGB(48,22,28),Color3.fromRGB(28,12,16),Color3.fromRGB(12,6,8))
btnFrame.BackgroundColor3=active and Color3.fromRGB(220,40,80) or Color3.fromRGB(28,12,16)
setAccent(active,active and Color3.fromRGB(255,180,190) or Color3.fromRGB(100,60,70))
setLabel(active and Color3.fromRGB(255,240,245) or Color3.fromRGB(220,190,195),Color3.fromRGB(40,0,10),0.55)
elseif style=="V8" then
applyGrad(120,Color3.fromRGB(180,160,255),Color3.fromRGB(90,70,255),Color3.fromRGB(20,10,60),Color3.fromRGB(30,28,48),Color3.fromRGB(18,16,30),Color3.fromRGB(8,8,16))
btnFrame.BackgroundColor3=active and Color3.fromRGB(100,80,255) or Color3.fromRGB(18,16,30)
setAccent(active,active and Color3.fromRGB(210,200,255) or Color3.fromRGB(90,85,120))
setLabel(active and Color3.fromRGB(245,245,255) or Color3.fromRGB(200,195,230),Color3.fromRGB(20,10,50),0.55)
elseif style=="V9" then
applyGrad(80,Color3.fromRGB(255,200,140),Color3.fromRGB(255,120,40),Color3.fromRGB(60,20,0),Color3.fromRGB(50,34,22),Color3.fromRGB(30,20,12),Color3.fromRGB(14,10,6))
btnFrame.BackgroundColor3=active and Color3.fromRGB(255,120,40) or Color3.fromRGB(30,20,12)
setAccent(active,active and Color3.fromRGB(255,220,160) or Color3.fromRGB(110,80,50))
setLabel(active and Color3.fromRGB(255,250,240) or Color3.fromRGB(220,200,180),Color3.fromRGB(40,15,0),0.55)
elseif style=="V10" then
applyGrad(90,Color3.fromRGB(140,255,230),Color3.fromRGB(20,200,170),Color3.fromRGB(0,40,35),Color3.fromRGB(20,40,38),Color3.fromRGB(12,24,22),Color3.fromRGB(6,12,11))
btnFrame.BackgroundColor3=active and Color3.fromRGB(20,200,170) or Color3.fromRGB(12,24,22)
setAccent(active,active and Color3.fromRGB(180,255,240) or Color3.fromRGB(70,110,100))
setLabel(active and Color3.fromRGB(230,255,250) or Color3.fromRGB(180,220,210),Color3.fromRGB(0,30,25),0.55)
elseif style=="V11" then
applyGrad(90,Color3.fromRGB(255,255,255),Color3.fromRGB(210,210,220),Color3.fromRGB(120,120,140),Color3.fromRGB(40,40,48),Color3.fromRGB(22,22,28),Color3.fromRGB(10,10,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(230,230,240) or Color3.fromRGB(22,22,28)
setAccent(active,active and Color3.fromRGB(255,255,255) or Color3.fromRGB(90,90,100))
setLabel(active and Color3.fromRGB(20,20,28) or Color3.fromRGB(210,210,220),Color3.fromRGB(0,0,0),0.5)
elseif style=="V12" then
applyGrad(90,Color3.fromRGB(255,80,60),Color3.fromRGB(180,20,10),Color3.fromRGB(40,0,0),Color3.fromRGB(40,14,12),Color3.fromRGB(22,8,6),Color3.fromRGB(10,4,3))
btnFrame.BackgroundColor3=active and Color3.fromRGB(200,30,20) or Color3.fromRGB(22,8,6)
setAccent(active,active and Color3.fromRGB(255,150,120) or Color3.fromRGB(100,50,40))
setLabel(active and Color3.fromRGB(255,240,235) or Color3.fromRGB(220,180,170),Color3.fromRGB(40,0,0),0.55)
elseif style=="V13" then
applyGrad(90,Color3.fromRGB(120,200,255),Color3.fromRGB(30,100,255),Color3.fromRGB(0,20,60),Color3.fromRGB(18,28,48),Color3.fromRGB(10,16,30),Color3.fromRGB(4,8,16))
btnFrame.BackgroundColor3=active and Color3.fromRGB(40,110,255) or Color3.fromRGB(10,16,30)
setAccent(active,active and Color3.fromRGB(160,210,255) or Color3.fromRGB(60,80,120))
setLabel(active and Color3.fromRGB(240,250,255) or Color3.fromRGB(180,200,230),Color3.fromRGB(0,15,50),0.55)
elseif style=="V14" then
applyGrad(90,Color3.fromRGB(255,140,200),Color3.fromRGB(255,40,140),Color3.fromRGB(50,0,25),Color3.fromRGB(48,20,34),Color3.fromRGB(28,10,18),Color3.fromRGB(12,4,8))
btnFrame.BackgroundColor3=active and Color3.fromRGB(255,40,140) or Color3.fromRGB(28,10,18)
setAccent(active,active and Color3.fromRGB(255,180,220) or Color3.fromRGB(110,60,85))
setLabel(active and Color3.fromRGB(255,245,250) or Color3.fromRGB(230,190,210),Color3.fromRGB(40,0,20),0.55)
elseif style=="V15" then
applyGrad(90,Color3.fromRGB(255,230,120),Color3.fromRGB(220,160,20),Color3.fromRGB(50,35,0),Color3.fromRGB(44,40,22),Color3.fromRGB(26,24,12),Color3.fromRGB(12,10,6))
btnFrame.BackgroundColor3=active and Color3.fromRGB(220,170,20) or Color3.fromRGB(26,24,12)
setAccent(active,active and Color3.fromRGB(255,240,160) or Color3.fromRGB(110,100,55))
setLabel(active and Color3.fromRGB(40,30,0) or Color3.fromRGB(220,210,170),Color3.fromRGB(0,0,0),0.5)
elseif style=="V16" then
applyGrad(90,Color3.fromRGB(160,255,120),Color3.fromRGB(60,180,30),Color3.fromRGB(10,40,0),Color3.fromRGB(28,40,22),Color3.fromRGB(14,22,10),Color3.fromRGB(6,10,4))
btnFrame.BackgroundColor3=active and Color3.fromRGB(70,190,30) or Color3.fromRGB(14,22,10)
setAccent(active,active and Color3.fromRGB(200,255,160) or Color3.fromRGB(70,100,55))
setLabel(active and Color3.fromRGB(235,255,230) or Color3.fromRGB(190,220,180),Color3.fromRGB(0,25,0),0.55)
elseif style=="V17" then
applyGrad(90,Color3.fromRGB(180,220,255),Color3.fromRGB(100,140,200),Color3.fromRGB(20,30,50),Color3.fromRGB(32,36,48),Color3.fromRGB(18,20,28),Color3.fromRGB(8,10,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(110,150,210) or Color3.fromRGB(18,20,28)
setAccent(active,active and Color3.fromRGB(210,230,255) or Color3.fromRGB(80,90,110))
setLabel(active and Color3.fromRGB(245,250,255) or Color3.fromRGB(190,200,220),Color3.fromRGB(10,15,30),0.55)
elseif style=="V18" then
applyGrad(90,Color3.fromRGB(255,180,100),Color3.fromRGB(200,60,20),Color3.fromRGB(40,10,0),Color3.fromRGB(46,28,18),Color3.fromRGB(28,16,10),Color3.fromRGB(12,6,4))
btnFrame.BackgroundColor3=active and Color3.fromRGB(210,70,20) or Color3.fromRGB(28,16,10)
setAccent(active,active and Color3.fromRGB(255,200,140) or Color3.fromRGB(110,70,45))
setLabel(active and Color3.fromRGB(255,245,235) or Color3.fromRGB(220,190,170),Color3.fromRGB(40,10,0),0.55)
elseif style=="V19" then
applyGrad(90,Color3.fromRGB(220,180,255),Color3.fromRGB(140,60,220),Color3.fromRGB(30,10,50),Color3.fromRGB(36,26,48),Color3.fromRGB(20,14,28),Color3.fromRGB(10,6,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(150,70,230) or Color3.fromRGB(20,14,28)
setAccent(active,active and Color3.fromRGB(230,200,255) or Color3.fromRGB(100,75,120))
setLabel(active and Color3.fromRGB(250,245,255) or Color3.fromRGB(210,195,230),Color3.fromRGB(25,5,45),0.55)
elseif style=="V20" then
applyGrad(90,Color3.fromRGB(120,255,200),Color3.fromRGB(20,180,140),Color3.fromRGB(0,40,30),Color3.fromRGB(20,42,36),Color3.fromRGB(10,24,20),Color3.fromRGB(4,12,10))
btnFrame.BackgroundColor3=active and Color3.fromRGB(20,190,150) or Color3.fromRGB(10,24,20)
setAccent(active,active and Color3.fromRGB(160,255,220) or Color3.fromRGB(60,110,95))
setLabel(active and Color3.fromRGB(230,255,245) or Color3.fromRGB(180,220,205),Color3.fromRGB(0,30,20),0.55)
elseif style=="V21" then
applyGrad(90,Color3.fromRGB(255,100,100),Color3.fromRGB(255,40,40),Color3.fromRGB(50,0,0),Color3.fromRGB(40,16,16),Color3.fromRGB(24,8,8),Color3.fromRGB(10,4,4))
btnFrame.BackgroundColor3=active and Color3.fromRGB(255,40,40) or Color3.fromRGB(24,8,8)
setAccent(active,active and Color3.fromRGB(255,160,160) or Color3.fromRGB(110,50,50))
setLabel(active and Color3.fromRGB(255,245,245) or Color3.fromRGB(230,180,180),Color3.fromRGB(40,0,0),0.55)
elseif style=="V22" then
applyGrad(90,Color3.fromRGB(100,255,255),Color3.fromRGB(0,200,220),Color3.fromRGB(0,40,50),Color3.fromRGB(16,40,44),Color3.fromRGB(8,24,26),Color3.fromRGB(4,12,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(0,200,220) or Color3.fromRGB(8,24,26)
setAccent(active,active and Color3.fromRGB(160,255,255) or Color3.fromRGB(50,110,120))
setLabel(active and Color3.fromRGB(230,255,255) or Color3.fromRGB(170,220,225),Color3.fromRGB(0,30,35),0.55)
elseif style=="V23" then
applyGrad(90,Color3.fromRGB(255,220,180),Color3.fromRGB(200,140,80),Color3.fromRGB(40,25,10),Color3.fromRGB(42,34,26),Color3.fromRGB(24,20,14),Color3.fromRGB(12,10,6))
btnFrame.BackgroundColor3=active and Color3.fromRGB(200,140,80) or Color3.fromRGB(24,20,14)
setAccent(active,active and Color3.fromRGB(255,230,190) or Color3.fromRGB(100,85,60))
setLabel(active and Color3.fromRGB(40,25,10) or Color3.fromRGB(220,200,170),Color3.fromRGB(0,0,0),0.5)
elseif style=="V24" then
applyGrad(90,Color3.fromRGB(200,120,255),Color3.fromRGB(120,0,200),Color3.fromRGB(25,0,45),Color3.fromRGB(34,18,48),Color3.fromRGB(20,10,28),Color3.fromRGB(10,4,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(130,20,210) or Color3.fromRGB(20,10,28)
setAccent(active,active and Color3.fromRGB(220,170,255) or Color3.fromRGB(100,70,120))
setLabel(active and Color3.fromRGB(250,240,255) or Color3.fromRGB(210,190,230),Color3.fromRGB(30,0,50),0.55)
elseif style=="V25" then
applyGrad(90,Color3.fromRGB(180,255,80),Color3.fromRGB(100,200,0),Color3.fromRGB(20,40,0),Color3.fromRGB(28,40,14),Color3.fromRGB(14,22,6),Color3.fromRGB(6,10,2))
btnFrame.BackgroundColor3=active and Color3.fromRGB(120,210,0) or Color3.fromRGB(14,22,6)
setAccent(active,active and Color3.fromRGB(220,255,140) or Color3.fromRGB(80,110,40))
setLabel(active and Color3.fromRGB(20,30,0) or Color3.fromRGB(200,220,160),Color3.fromRGB(0,0,0),0.5)
else
-- V26 sunset dual tone
applyGrad(120,Color3.fromRGB(255,120,180),Color3.fromRGB(255,140,40),Color3.fromRGB(40,10,20),Color3.fromRGB(40,24,32),Color3.fromRGB(24,14,18),Color3.fromRGB(12,6,8))
btnFrame.BackgroundColor3=active and Color3.fromRGB(255,100,80) or Color3.fromRGB(24,14,18)
setAccent(active,active and Color3.fromRGB(255,200,160) or Color3.fromRGB(110,70,80))
setLabel(active and Color3.fromRGB(255,245,240) or Color3.fromRGB(220,190,195),Color3.fromRGB(40,10,15),0.55)
end
if stroke then stroke.Transparency=1 stroke.Thickness=0 end
end
function applyFloatingButtonScale()for _,uiScale in ipairs(_floatingUIScales)do if uiScale and uiScale.Parent then uiScale.Scale=floatingButtonScale end end end local function drag(f,dragZoneHeight)local dn,ds,sp,di=false,nil,nil,nil local endConn=nil local zone=dragZoneHeight or 99999 local function stopDrag()local wasDragging=dn dn=false di=nil if endConn then endConn:Disconnect()endConn=nil end if wasDragging then task.defer(function()pcall(saveAllSettings)end)end end f.InputBegan:Connect(function(i)if uiLocked then return end if _isDraggingButton then return end if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local framePos=f.AbsolutePosition if i.Position.Y>framePos.Y+zone then return end dn=true;ds=i.Position;sp=f.Position if endConn then endConn:Disconnect()end endConn=i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then stopDrag()end end)end end)f.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then stopDrag()end end)UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then stopDrag()end end)f.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)UIS.InputChanged:Connect(function(i)if i==di and dn then if uiLocked then stopDrag();return end if _isDraggingButton then return end if not ds or not sp then return end local nX=sp.X.Offset+(i.Position.X-ds.X)local nY=sp.Y.Offset+(i.Position.Y-ds.Y)f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)end end)end _G.__ZeyHubbDragFrame=drag _G.__RivalHubSpeedEngine=_G.__RivalHubSpeedEngine or{started=false,conn=nil}_G.__RivalHubSpeedEngine.signal=nil do _G.__RivalHubSpeedEngine.signal=RunService.RenderStepped end local function _spd_isRagdollState(hum)if not hum then return true end local st=hum:GetState()return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown end local function _spd_shouldUseStealSpeed(_isStealing)return speedMode==true end local function _spd_getSelectedBoostSpeed()if laggerToggled or laggerCarryToggled then return LAGGER_SPEED end return NS end local function _spd_getSelectedStealSpeed()if laggerCarryToggled then return LAGGER_CARRY_SPEED end if laggerToggled then return LAGGER_SPEED end return CS end local function _spd_getTargetSpeed(isStealing)if _spd_shouldUseStealSpeed(isStealing)then return _spd_getSelectedStealSpeed()end return _spd_getSelectedBoostSpeed()end local function _spd_resetMovement()lastMoveDir=_V3zero _s2VelState.v=_V3new(0,_s2VelState.v.Y or 0,0)end local function _spd_stop()if _G.__RivalHubSpeedEngine.conn then _G.__RivalHubSpeedEngine.conn:Disconnect()_G.__RivalHubSpeedEngine.conn=nil end _spd_resetMovement()end local function _spd_start()_spd_stop()_G.__RivalHubSpeedEngine.started=true _G.__RivalHubSpeedEngine.acc=0 _G.__RivalHubSpeedEngine.conn=_G.__RivalHubSpeedEngine.signal:Connect(function(dt)_G.__RivalHubSpeedEngine.acc=(_G.__RivalHubSpeedEngine.acc or 0)+(dt or 0)if _G.__RivalHubSpeedEngine.acc<0.016 then return end _G.__RivalHubSpeedEngine.acc=0 local character=LP.Character local humanoid=character and character:FindFirstChildOfClass("Humanoid")local root=character and character:FindFirstChild("HumanoidRootPart")if not humanoid or not root or humanoid.Health<=0 then return end if autoBatEnabled or autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping or(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2())then _spd_resetMovement()return end if _spd_isRagdollState(humanoid)then lastMoveDir=_V3zero return end if _s2VelState.root~=root or not _velChecked[root]then lastMoveDir=_V3zero _setupVelChecked(character)_hookVelHRP(root)end local direction if humanoid.MoveDirection.Magnitude>0 then lastMoveDir=humanoid.MoveDirection direction=humanoid.MoveDirection elseif lastMoveDir.Magnitude>0 then for key in pairs(MOVE_KEYS)do if UIS:IsKeyDown(key)then direction=lastMoveDir break end end end local selectedSpeed=_spd_getTargetSpeed(LP:GetAttribute("Stealing")==true)_applyVelocitySpeed(direction,tonumber(selectedSpeed)or 16,root)end)end local function _spd_applyNow()local character=LP.Character local hum=character and character:FindFirstChildOfClass("Humanoid")local root=character and character:FindFirstChild("HumanoidRootPart")if not hum or not root or hum.Health<=0 or _spd_isRagdollState(hum)then return end local direction=hum.MoveDirection.Magnitude>0.05 and hum.MoveDirection or nil _applyVelocitySpeed(direction,_spd_getTargetSpeed(LP:GetAttribute("Stealing")==true),root)end local function _spd_refresh()_spd_start()end _G.__RivalHubRefreshSpeedEngine=_spd_refresh _G.__RivalHubStopSpeedEngine=_spd_stop _G.__RivalHubApplySpeedNow=_spd_applyNow pcall(_spd_start)LP.CharacterAdded:Connect(function(character)task.wait(0.5)_spd_resetMovement()local root=character:WaitForChild("HumanoidRootPart",5)if root then _setupVelChecked(character);_hookVelHRP(root)end _spd_start()end)LP.CharacterRemoving:Connect(function()_spd_stop()_s2VelState.root=nil end)function setupMovementAndIndicators(char)if steppedConn then steppedConn:Disconnect();steppedConn=nil end if movementLoop then movementLoop:Disconnect();movementLoop=nil end local ccAcc=0 steppedConn=RunService.Heartbeat:Connect(function(dt)ccAcc=ccAcc+dt if ccAcc<0.05 then return end ccAcc=0 local plist=_GetPlayersCached()for i=1,#plist do local p=plist[i]if p~=LP then local ch=p.Character if ch then local parts=ch:GetChildren()for j=1,#parts do local part=parts[j]if part:IsA("BasePart")and part.CanCollide then part.CanCollide=false end end end end end end)movementLoop=RunService.RenderStepped:Connect(function()local char2=LP.Character if not char2 then return end local hum=char2:FindFirstChildOfClass("Humanoid")local hrp=char2:FindFirstChild("HumanoidRootPart")if not hum or not hrp then return end if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then if _isRagdollState(hum)then lastMoveDir=_V3zero else local md=hum.MoveDirection if md.Magnitude>0 then lastMoveDir=md end end end if speedLabel then local displaySpeed=getActiveMoveSpeed()speedLabel.Text=string.format("%.1f  -  %s",displaySpeed,getSpeedModeName())end end)setupSpeedIndicator(char)startEnemySpeed()end function toggleLockUI(state)if state==nil then uiLocked=not uiLocked else uiLocked=state end uiLocked=uiLocked==true mobileButtonsLocked=uiLocked if setLockUIVisual then setLockUIVisual(uiLocked)end if not uiLocked then pcall(function()if main then main.Active=true end if scriptHeader then scriptHeader.Active=true end end)end end function disableAllAimbots()if autoBatEnabled then disableAutoBat()if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end end end function stopAllBackgroundTasks()if movementLoop then movementLoop:Disconnect();movementLoop=nil end if steppedConn then steppedConn:Disconnect();steppedConn=nil end stopEnemySpeed()if stretchEnabled then disableStretch()end if stretchConn then stretchConn:Disconnect();stretchConn=nil end if stretchFovConn then stretchFovConn:Disconnect();stretchFovConn=nil end if AntiRagdollV1.isRunning()then AntiRagdollV1.stop()end if AntiRagdollV2.Enabled then stopAntiRagdollV2()end if _G.__RivalHubFloat and _G.__RivalHubFloat.running then pcall(_G.__RivalHubFloat.disable)end if _G.__RivalHubAutoCarryStop then pcall(_G.__RivalHubAutoCarryStop)end if antiDieEnabled then AntiDieModule.stop()end if antiBatEnabled then stopAntiBat()end if antiFlingEnabled then stopAntiFling()end stopBatCounter()if stopBatCounterV2 then stopBatCounterV2()end stopMedusaCounter()stopAutoSteal()disableAutoBat()stopAutoLeft()stopAutoRight()if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end if TPBatState and TPBatState.enabled and tpBatSetEnabled then pcall(tpBatSetEnabled,false)end if unwalkEnabled then stopUnwalk()end if antiLagEnabled then disableAntiLag()end if espEnabled then toggleESP(false)end if espLineEnabled then stopESPLine()end if dropActive then stopDropBrainrot()end if bodyLockEnabled then stopBodyLock()end _blSuppressCount=0 _blWasEnabled=false if _blRestoreTimer then pcall(task.cancel,_blRestoreTimer);_blRestoreTimer=nil end if _bodyLockConn then _bodyLockConn:Disconnect();_bodyLockConn=nil end for _,t in ipairs(dropConnections)do if type(t)=="thread"then pcall(task.cancel,t)elseif type(t)=="RBXScriptConnection"then pcall(t.Disconnect,t)end end dropConnections={}dropActive=false alPhase=1 arPhase=1 lastDropTime=0 medusaDebounce=false medusaLastUsed=0 if _G.__RivalHubStopSpeedEngine then pcall(_G.__RivalHubStopSpeedEngine)end end local _rivalHubSaveState={lastAt=0,queued=false,writing=false,dirty=false,revision=0,retryCount=0,}local function resolveRivalHubFileApi()local env=(type(getgenv)=="function"and getgenv())or _G local synApi=rawget(env,"syn")or rawget(_G,"syn")local readCandidates={rawget(env,"readfile"),synApi and synApi.readfile,rawget(_G,"readfile")}local writeCandidates={rawget(env,"writefile"),synApi and synApi.writefile,rawget(_G,"writefile")}local readFn,writeFn for _,fn in ipairs(readCandidates)do if type(fn)=="function"then readFn=fn;break end end for _,fn in ipairs(writeCandidates)do if type(fn)=="function"then writeFn=fn;break end end return readFn,writeFn end local function rivalHubFileExists(path)local readFn=resolveRivalHubFileApi()if not readFn then return false end local ok,data=pcall(readFn,path)return ok and type(data)=="string"end function buildConfigTable()local config={normalSpeed=NS,carrySpeed=CS,laggerSpeed1=LAGGER_SPEED,laggerSpeed2=LAGGER_CARRY_SPEED,stealRadius=CONFIG.STEAL_RANGE,holdMin=CONFIG.HOLD_MIN,holdMax=CONFIG.HOLD_MAX,entryDelay=CONFIG.ENTRY_DELAY,cooldown=CONFIG.COOLDOWN,primeRange=CONFIG.PRIME_RANGE,antiRagdollMode=antiRagdollMode,antiDieEnabled=antiDieEnabled,antiBat=antiBatEnabled,antiFling=antiFlingEnabled,autoSteal=CONFIG.AUTO_STEAL_ENABLED,autoBat=autoBatEnabled,autoLeft=autoLeftEnabled,autoRight=autoRightEnabled,medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,medusaSkin=_G.RivalMedusaSkin or"Default",batCounterV2=batCounterV2Enabled,unwalkEnabled=unwalkEnabled,laggerToggled=laggerToggled,laggerCarryToggled=laggerCarryToggled,carryMode=speedMode,batAimbotSpeed=BAT_AIMBOT_SPEED,dropMode=dropMode,stretchEnabled=stretchEnabled,stretchFOV=stretchFOV,uiScale=uiScaleValue,animPack=currentAnimPack,espEnabled=espEnabled,espLineEnabled=espLineEnabled,vividGraphics=vividGraphicsEnabled,hideButtons=hideButtonsEnabled,antiLag=antiLagEnabled,skyTheme=skyTheme,mobileButtonPositions=savedButtonPositions,dropBrainrotKey={kb=KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name,gp=KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},autoLeftKey={kb=KB.AutoLeft.kb and KB.AutoLeft.kb.Name,gp=KB.AutoLeft.gp and KB.AutoLeft.gp.Name},autoRightKey={kb=KB.AutoRight.kb and KB.AutoRight.kb.Name,gp=KB.AutoRight.gp and KB.AutoRight.gp.Name},autoBatKey={kb=KB.AutoBat.kb and KB.AutoBat.kb.Name,gp=KB.AutoBat.gp and KB.AutoBat.gp.Name},tpFloorKey={kb=KB.TPFloor.kb and KB.TPFloor.kb.Name,gp=KB.TPFloor.gp and KB.TPFloor.gp.Name},guiHideKey={kb=KB.GuiHide.kb and KB.GuiHide.kb.Name,gp=KB.GuiHide.gp and KB.GuiHide.gp.Name},carryToggleKey={kb=KB.CarryToggle.kb and KB.CarryToggle.kb.Name,gp=KB.CarryToggle.gp and KB.CarryToggle.gp.Name},laggerModeKey={kb=KB.LaggerMode.kb and KB.LaggerMode.kb.Name,gp=KB.LaggerMode.gp and KB.LaggerMode.gp.Name},batV2Key={kb=KB.BatV2.kb and KB.BatV2.kb.Name,gp=KB.BatV2.gp and KB.BatV2.gp.Name},tpBatKey={kb=KB.TPBat.kb and KB.TPBat.kb.Name,gp=KB.TPBat.gp and KB.TPBat.gp.Name},floatKey={kb=KB.Float.kb and KB.Float.kb.Name,gp=KB.Float.gp and KB.Float.gp.Name},instantResetKey={kb=KB.InstantReset.kb and KB.InstantReset.kb.Name,gp=KB.InstantReset.gp and KB.InstantReset.gp.Name},bodyLockEnabled=bodyLockEnabled,bodyLockRange=bodyLockRange,autoCarryEnabled=autoCarryEnabled==true,autoCarryMode=autoCarryMode,progressBarPos=savedProgressBarPos,lockUI=uiLocked,backgroundIndex=backgroundIndex,backgroundImageTransparency=backgroundImageTransparency,backgroundMode=backgroundMode,floatingButtonScale=floatingButtonScale,stealBarScale=stealBarScale,outfitIndex=currentOutfitIndex,vx7AvatarIndex=VX7A.index,themeColor=currentColorTheme,rivalTitleTheme=currentRivalTitleTheme,infiniteJumpEnabled=InfiniteJump.enabled==true,infiniteJumpMode=InfiniteJump.mode=="manual"and"manual"or"hold",autoStealMode=autoStealMode,stealBarStyle=(stealBarStyle=="V2"or stealBarStyle=="V3")and stealBarStyle or"V1",batV2=_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false,batVersion=(_G.__RivalHubBatVersion=="v3")and"v3"or"v2",tpBatVersion=(_G.__ZeyHubbTPBatVersion=="v3" or _G.__ZeyHubbTPBatVersion=="v2")and _G.__ZeyHubbTPBatVersion or"v1",bypassBatVersion=((_G.__ZeyHubbBypassBatVersion=="v2"or _G.__ZeyHubbBypassBatVersion=="v3")and _G.__ZeyHubbBypassBatVersion)or"v1",introSongVersion=(_G.__ZeyHubbIntroSongVersion=="v2")and"v2"or"v1",tpBatEnabled=TPBatState and TPBatState.enabled==true,antiCrasherEnabled=_G.__ZeyHubbAntiCrasherEnabled==true,headlessEnabled=_G.__ZeyHubbHeadlessEnabled==true,korbloxEnabled=_G.__ZeyHubbKorbloxEnabled==true,duelPingAlertEnabled=_G.__ZeyHubbDuelPingEnabled==true,instantResetVersion=(_G.__ZeyHubbInstantResetVersion=="V2")and"V2"or"V1",}if main then local basePos=_G.__RivalHubMainOriginalPos or main.Position config.mainPosition={XScale=basePos.X.Scale,XOffset=basePos.X.Offset,YScale=basePos.Y.Scale,YOffset=basePos.Y.Offset,}end if pbFrame then config.progressBarPos={XScale=pbFrame.Position.X.Scale,XOffset=pbFrame.Position.X.Offset,YScale=pbFrame.Position.Y.Scale,YOffset=pbFrame.Position.Y.Offset}end if MobilePanel then config.mobilePanelPos={XScale=0,XOffset=10,YScale=0,YOffset=0}for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")then savedButtonPositions[btn.Name]={X=btn.Position.X.Offset,Y=btn.Position.Y.Offset}end end config.mobileButtonPositions=savedButtonPositions end return config end local function scheduleRivalHubSave(delaySeconds)if _rivalHubSaveState.queued then return end _rivalHubSaveState.queued=true task.delay(delaySeconds or 0.25,function()_rivalHubSaveState.queued=false if _G.RivalHubRunning and not _isResetting and not _isLoading then pcall(saveAllSettings,true)end end)end function saveAllSettings(force)if _isResetting or _isLoading then return true end local config=buildConfigTable()config.configVersion=2 config.userId=LP.UserId local encodedOk,canonicalJSON=pcall(function()return HS:JSONEncode(config)end)if not encodedOk then warn("[Rival Hub Save] Could not encode settings.")return false end if not force and canonicalJSON==_lastSavedJSON and not _rivalHubSaveState.dirty then return true end _rivalHubSaveState.dirty=true if _rivalHubSaveState.writing then scheduleRivalHubSave(0.25)return true end if not force and _tick()-_rivalHubSaveState.lastAt<0.25 then scheduleRivalHubSave(0.25)return true end local readFn,writeFn=resolveRivalHubFileApi()if not readFn or not writeFn then warn("[Rival Hub Save] Executor file API is unavailable.")scheduleRivalHubSave(1)return false end _rivalHubSaveState.writing=true _rivalHubSaveState.revision=_rivalHubSaveState.revision+1 local writeConfig=config writeConfig.revision=_rivalHubSaveState.revision writeConfig.savedAt=os.time()local json=HS:JSONEncode(writeConfig)local ok=false for attempt=1,3 do local attemptOk=pcall(function()if rivalHubFileExists(CONFIG_FILE)then local previous=readFn(CONFIG_FILE)if type(previous)=="string"then writeFn(CONFIG_FILE..".backup",previous)end end writeFn(CONFIG_FILE,json)local readBack=readFn(CONFIG_FILE)if readBack~=json then error("save verification failed")end HS:JSONDecode(readBack)end)if attemptOk then ok=true break end if attempt<3 then task.wait(0.1*attempt)end end _rivalHubSaveState.writing=false if ok then _rivalHubSaveState.lastAt=_tick()_rivalHubSaveState.retryCount=0 _lastSavedJSON=canonicalJSON _rivalHubSaveState.dirty=false local latestOk,latest=pcall(function()local latestConfig=buildConfigTable()latestConfig.configVersion=2 latestConfig.userId=LP.UserId return HS:JSONEncode(latestConfig)end)if not latestOk or latest~=_lastSavedJSON then _rivalHubSaveState.dirty=true scheduleRivalHubSave(0.25)end else _rivalHubSaveState.retryCount=_rivalHubSaveState.retryCount+1 warn("[Rival Hub Save] Write or verification failed; will retry.")scheduleRivalHubSave(math.min(2,0.5*_rivalHubSaveState.retryCount))end return ok end task.spawn(function()task.wait(5)while _G.RivalHubRunning do task.wait(2)if gui and main and not _isLoading then pcall(saveAllSettings)end end end)pcall(function()game:BindToClose(function()pcall(saveAllSettings,true)end)end)do local readFn,writeFn=resolveRivalHubFileApi()if readFn and writeFn then local legacyPaths={"Fresh_"..tostring(LP.UserId)..".json","Rival_"..tostring(LP.UserId)..".json","BloodHounds_"..tostring(LP.UserId)..".json",}local okNew,_=pcall(readFn,CONFIG_FILE)if not okNew then for _,oldPath in ipairs(legacyPaths)do local okOld,old=pcall(readFn,oldPath)if okOld and type(old)=="string"and#old>0 then pcall(writeFn,CONFIG_FILE,old)warn("[ZeyHubb.vs] Config migrada de "..oldPath.." a "..CONFIG_FILE)break end end end end end function loadAllSettings()local readFn=resolveRivalHubFileApi()if not readFn or not rivalHubFileExists(CONFIG_FILE)then return false end local success,data=pcall(function()return HS:JSONDecode(readFn(CONFIG_FILE))end)if not success or type(data)~="table"then return false end _isLoading=true local function num(v,fallback)local n=tonumber(v)if n==nil or n~=n or n==math.huge or n==-math.huge then return fallback end return n end local function boolOr(v,fallback)if v==nil then return fallback end return v==true end NS=num(data.normalSpeed,NS)CS=num(data.carrySpeed,CS)LAGGER_SPEED=num(data.laggerSpeed1,LAGGER_SPEED)LAGGER_CARRY_SPEED=num(data.laggerSpeed2,LAGGER_CARRY_SPEED)CONFIG.STEAL_RANGE=num(data.stealRadius,CONFIG.STEAL_RANGE)CONFIG.HOLD_MIN=num(data.holdMin,CONFIG.HOLD_MIN)CONFIG.HOLD_MAX=num(data.holdMax,CONFIG.HOLD_MAX)CONFIG.ENTRY_DELAY=num(data.entryDelay,CONFIG.ENTRY_DELAY)CONFIG.COOLDOWN=num(data.cooldown,CONFIG.COOLDOWN)CONFIG.PRIME_RANGE=num(data.primeRange,CONFIG.PRIME_RANGE)if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if num(data.configVersion,1)>=2 and data.lockUI~=nil then uiLocked=boolOr(data.lockUI,false)else uiLocked=false end mobileButtonsLocked=false if data.antiRagdollMode then antiRagdollMode=tostring(data.antiRagdollMode)else antiRagdollMode=data.antiRagdoll and"v2"or"off"end _G.__RivalHubBatVersion=(data.batVersion=="v3")and"v3"or"v2";_G.__ZeyHubbTPBatVersion=(data.tpBatVersion=="v3" or data.tpBatVersion=="v2")and data.tpBatVersion or"v1";_G.__ZeyHubbBypassBatVersion=((data.bypassBatVersion=="v2"or data.bypassBatVersion=="v3")and data.bypassBatVersion)or"v1";_G.__ZeyHubbIntroSongVersion=(data.introSongVersion=="v2")and"v2"or"v1";if introSongSelectorLabel then introSongSelectorLabel.Text=(_G.__ZeyHubbIntroSongVersion=="v2")and"V2"or"V1" end;TPBatState.version=_G.__ZeyHubbTPBatVersion;antiDieEnabled=boolOr(data.antiDieEnabled,false);_G.__ZeyHubbHeadlessEnabled=boolOr(data.headlessEnabled,false)_G.__ZeyHubbKorbloxEnabled=boolOr(data.korbloxEnabled,false)_G.__ZeyHubbDuelPingEnabled=boolOr(data.duelPingAlertEnabled,false)_G.__ZeyHubbInstantResetVersion=data.instantResetVersion=="V2"and"V2"or"V1"if _G.__ZeyHubbInstantResetSetVersion then pcall(_G.__ZeyHubbInstantResetSetVersion,_G.__ZeyHubbInstantResetVersion)end antiBatEnabled=boolOr(data.antiBat,false)antiFlingEnabled=boolOr(data.antiFling,false)CONFIG.AUTO_STEAL_ENABLED=boolOr(data.autoSteal,false)autoBatEnabled=boolOr(data.autoBat,false)autoLeftEnabled=boolOr(data.autoLeft,false)autoRightEnabled=boolOr(data.autoRight,false)autoStealMode=data.autoStealMode=="V2"and"V2"or"V1"stealBarStyle=(type(data.stealBarStyle)=="string"and(data.stealBarStyle=="V2"or data.stealBarStyle=="V3"))and data.stealBarStyle or"V1"if applyStealBarStyle then pcall(applyStealBarStyle,stealBarStyle)elseif _G.__ZeyHubbApplyStealBarStyle then pcall(_G.__ZeyHubbApplyStealBarStyle,stealBarStyle)end InfiniteJump.mode=data.infiniteJumpMode=="manual"and"manual"or"hold"InfiniteJump.enabled=boolOr(data.infiniteJumpEnabled,false)medusaCounterEnabled=boolOr(data.medusaCounter,false)if type(data.medusaSkin)=="string"and _G.RivalSetMedusaSkin then _G.RivalSetMedusaSkin(data.medusaSkin)if _G.RivalMedusaSkinRefreshUI then pcall(_G.RivalMedusaSkinRefreshUI)end end batCounterEnabled=boolOr(data.batCounter,false)batCounterV2Enabled=boolOr(data.batCounterV2,false)unwalkEnabled=boolOr(data.unwalkEnabled,boolOr(data.unwalk,false))antiLagEnabled=boolOr(data.antiLag,false)laggerToggled=boolOr(data.laggerToggled,false)speedMode=boolOr(data.carryMode,false)laggerCarryToggled=boolOr(data.laggerCarryToggled,false)uiScaleValue=_clamp(num(data.uiScale,78),50,150)if mainUIScale then mainUIScale.Scale=uiScaleValue/100 end espEnabled=boolOr(data.espEnabled,false)espLineEnabled=boolOr(data.espLineEnabled,false)if espEnabled then pcall(toggleESP,true)else pcall(toggleESP,false)end vividGraphicsEnabled=boolOr(data.vividGraphics,false)hideButtonsEnabled=boolOr(data.hideButtons,false)TPBatState.enabled=false currentColorTheme=COLOR_THEMES[data.themeColor]and data.themeColor or(data.themeColor=="Cyan"and"Orange"or"Orange")selectedColor=COLOR_THEMES[currentColorTheme]task.defer(function()updateAllUIThemeColors(selectedColor)end)if data.rivalTitleTheme and RIVAL_TITLE_THEMES[data.rivalTitleTheme]then task.defer(function()applyRivalTitleTheme(data.rivalTitleTheme)end)end skyTheme=data.skyTheme or"Off"if skyTheme~="Off"then pcall(applyCustomSky,skyTheme)end if skySelectorLabel then skySelectorLabel.Text=skyTheme end if data.animPack and ANIM_PACKS[data.animPack]then pcall(startAnimPack,data.animPack)else currentAnimPack="Off"stopAnimPack()end local function lk(e,d)if not d then return end if d.kb and Enum.KeyCode[d.kb]then e.kb=Enum.KeyCode[d.kb]end if d.gp and Enum.KeyCode[d.gp]then e.gp=Enum.KeyCode[d.gp]end end lk(KB.DropBrainrot,data.dropBrainrotKey)lk(KB.AutoLeft,data.autoLeftKey)lk(KB.AutoRight,data.autoRightKey)lk(KB.AutoBat,data.autoBatKey)lk(KB.TPFloor,data.tpFloorKey)lk(KB.GuiHide,data.guiHideKey)lk(KB.CarryToggle,data.carryToggleKey)lk(KB.LaggerMode,data.laggerModeKey)lk(KB.BatV2,data.batV2Key)lk(KB.TPBat,data.tpBatKey)lk(KB.Float,data.floatKey)lk(KB.InstantReset,data.instantResetKey)if data.mobileButtonPositions then savedButtonPositions=data.mobileButtonPositions end if data.mobilePanelPos then savedMobilePanelPos=data.mobilePanelPos end if data.mainPosition and main and type(data.mainPosition)=="table"then main.Position=UDim2.new(num(data.mainPosition.XScale,0),num(data.mainPosition.XOffset,20),num(data.mainPosition.YScale,0),num(data.mainPosition.YOffset,2))end if data.progressBarPos and type(data.progressBarPos)=="table"then savedProgressBarPos=data.progressBarPos end if data.bodyLockEnabled~=nil then bodyLockEnabled=boolOr(data.bodyLockEnabled,false)if bodyLockEnabled then task.defer(function()if bodyLockSetVisual then bodyLockSetVisual(true)end startBodyLock()end)end end if data.autoCarryEnabled~=nil then autoCarryEnabled=data.autoCarryEnabled==true end if data.autoCarryMode=="On Pick Up"or data.autoCarryMode=="Soft Steal"then autoCarryMode=data.autoCarryMode end if _G.__RivalHubAutoCarryRefresh then pcall(_G.__RivalHubAutoCarryRefresh)end if data.bodyLockRange~=nil then bodyLockRange=_clamp(num(data.bodyLockRange,20),5,200)if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end end dropMode=num(data.dropMode,1)stretchEnabled=boolOr(data.stretchEnabled,false)stretchFOV=num(data.stretchFOV,120)BAT_AIMBOT_SPEED=num(data.batAimbotSpeed,BAT_AIMBOT_SPEED)BYPASS_AIMBOT_SPEED=BAT_AIMBOT_SPEED if State then State.bypassBatSpeed=BYPASS_AIMBOT_SPEED end backgroundIndex=_clamp(num(data.backgroundIndex,1),1,math.max(#backgroundImages,1))backgroundImageTransparency=_clamp(num(data.backgroundImageTransparency,0),0,1)if data.backgroundMode=="None"or#backgroundImages==0 then backgroundMode="None"else local savedN=nil if type(data.backgroundMode)=="string"then savedN=tonumber(string.match(data.backgroundMode,"^Background%s+(%d+)$"))end if type(savedN)=="number"and savedN>=1 and savedN<=#backgroundImages then backgroundIndex=savedN end backgroundMode="Background "..backgroundIndex end floatingButtonScale=_clamp(num(data.floatingButtonScale,1),0.5,2);if type(data.tpBatEnabled)=="boolean"and data.tpBatEnabled and tpBatSetEnabled then task.defer(function()pcall(tpBatSetEnabled,true);if _G.__ZeyHubbTPBatSetVisual then pcall(_G.__ZeyHubbTPBatSetVisual,true)end;if _G.__ZeyHubbTPBatRefresh then pcall(_G.__ZeyHubbTPBatRefresh)end end)end;stealBarScale=_clamp(num(data.stealBarScale,1),0.4,2)if pbScale then pbScale.Scale=stealBarScale end if type(data.outfitIndex)=="number"and type(OUTFITS)=="table"and#OUTFITS>0 and data.outfitIndex>=1 and data.outfitIndex<=#OUTFITS then currentOutfitIndex=data.outfitIndex task.defer(function()pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel and OUTFITS[currentOutfitIndex]then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end end)end if type(data.vx7AvatarIndex)=="number"and data.vx7AvatarIndex>=1 and data.vx7AvatarIndex<=#VX7A.labels-1 then local _vx7Saved=data.vx7AvatarIndex task.defer(function()task.wait(1.5)pcall(VX7A.apply,_vx7Saved)end)end if vividGraphicsEnabled then task.defer(function()pcall(enableVividGraphics)end)else task.defer(function()pcall(disableVividGraphics)end)end if dropModeBtnRef then dropModeBtnRef.Text=dropMode==1 and"Fling"or"Jump Drop"end refreshSpeedModeLabel()_lastSavedJSON=HS:JSONEncode(buildConfigTable())_isLoading=false local antiCrasherShouldEnable=boolOr(data.antiCrasherEnabled,_G.__ZeyHubbAntiCrasherEnabled==true)if _G.__ZeyHubbSetAntiCrasher then task.defer(function()pcall(_G.__ZeyHubbSetAntiCrasher,antiCrasherShouldEnable,false)end)else _G.__ZeyHubbAntiCrasherEnabled=antiCrasherShouldEnable end if data.batV2==true and _G.__RivalHubStartBatV2 then task.defer(function()pcall(_G.__RivalHubStartBatV2)if mobSetBatV2 then mobSetBatV2(true)end end)end return true end function forceResetUI()if normalBox then normalBox.Text=tostring(NS)end if carryBox then carryBox.Text=tostring(CS)end if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED)end if lagger2Box then lagger2Box.Text=tostring(LAGGER_CARRY_SPEED)end if batSpeedBox then batSpeedBox.Text=tostring(BYPASS_AIMBOT_SPEED)end if uiScaleBox then uiScaleBox.Text=tostring(uiScaleValue)end if stealBarScaleBox then stealBarScaleBox.Text=tostring(_floor((stealBarScale or 1)*100+0.5))end if pbScale then pbScale.Scale=stealBarScale or 1 end if dropModeBtnRef then dropModeBtnRef.Text=dropMode==1 and"Fling"or"Jump Drop"end if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end local function safeSet(fn,val)if fn then fn(val)end end safeSet(autoBatSetVisual,false)safeSet(autoLeftSetVisual,false)safeSet(autoRightSetVisual,false)safeSet(setBatCounterVisual,false)safeSet(setBatCounterV2Visual,false)safeSet(setMedusaVisual,false)safeSet(setUnwalkVisual,false)safeSet(setAntiLagVisual,false)safeSet(setLockUIVisual,false)safeSet(setInstaGrab,false)safeSet(setESPVIsual,false)safeSet(setESPLineVisual,false)safeSet(setVividVisual,false)safeSet(setHideButtonsVisual,false)safeSet(bodyLockSetVisual,false)safeSet(setAntiDieVisual,false)safeSet(setAntiBatVisual,false)safeSet(setAntiFlingVisual,false)safeSet(setAntiRagVisual,false)safeSet(infJumpSetVisual,false)safeSet(mobSetBatV2,false)if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end disableVividGraphics()applyHideButtons(false)if _G.stretchToggleSetter then _G.stretchToggleSetter(false)end safeSet(mobSetAutoBat,false)safeSet(mobSetAutoLeft,false)safeSet(mobSetAutoRight,false)safeSet(mobSetDropBR,false)safeSet(mobSetTpDown,false)safeSet(mobSetCarry,false)safeSet(mobSetLagger1,false)safeSet(mobSetLagger2,false)if _G.__RivalHubFloat and _G.__RivalHubFloat.running then _G.__RivalHubFloat.disable()end safeSet(_G.__RivalHubFloatSetVisual,false)safeSet(mobSetFloat,false)refreshSpeedModeLabel()updateProgressBarVisibility()disableAntiLag()if stopAntiBat then stopAntiBat()end if stopAntiFling then stopAntiFling()end if stopESPLine then stopESPLine()end skyTheme="Off"pcall(applyCustomSky,"Off")if skySelectorLabel then skySelectorLabel.Text="Off"end if antiDieEnabled then AntiDieModule.stop()antiDieEnabled=false end for _,ref in ipairs(keyButtonRefs)do local entry=ref.entry local label=(entry.gp and entry.gp.Name)or(entry.kb and entry.kb.Name)or"None"ref.btn.Text=label end currentColorTheme="Orange"selectedColor=COLOR_THEMES["Orange"]updateAllUIThemeColors(selectedColor)if miniBtn then local stroke=miniBtn:FindFirstChildOfClass("UIStroke")if stroke then stroke.Color=Color3.fromRGB(42,43,47)end end if MobilePanel then for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")then local label=btn:FindFirstChildOfClass("TextLabel")if label then local isActive=btn.BackgroundColor3==selectedColor if not isActive then label.TextColor3=selectedColor end end end end end saveAllSettings()end function resetFloatingPositions()if MobilePanel then savedButtonPositions={}for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")and btn.Name then local defX,defY=getDefaultButtonPosition(btn.Name)btn.Position=UDim2.new(0,defX,0,defY)end end end if pbFrame then pbFrame.Position=UDim2.new(0.5,-150,0.78,0)savedProgressBarPos=nil end savedMobilePanelPos=nil end function resetToFactoryDefaults()_isResetting=true local ok,err=pcall(function()stopAutoSteal()stopBatCounter()if stopBatCounterV2 then stopBatCounterV2()end stopMedusaCounter()if AntiRagdollV2.Enabled then stopAntiRagdollV2()end if antiDieEnabled then AntiDieModule.stop()end if antiBatEnabled and stopAntiBat then stopAntiBat()end if antiFlingEnabled and stopAntiFling then stopAntiFling()end if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end stopUnwalk()InfiniteJump.stop()InfiniteJump.setMode("hold")disableAutoBat()stopBodyLock()if espEnabled then toggleESP(false)end if espLineEnabled and stopESPLine then stopESPLine()end if stretchEnabled then disableStretch()end if antiLagEnabled then disableAntiLag()end if vividGraphicsEnabled then disableVividGraphics()end if hideButtonsEnabled then applyHideButtons(false)end if dropActive then stopDropBrainrot()end skyTheme="Off"pcall(applyCustomSky,"Off")if skySelectorLabel then skySelectorLabel.Text="Off"end if antiDieEnabled then AntiDieModule.stop();antiDieEnabled=false end NS=60;CS=29;LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5 CONFIG.STEAL_RANGE=65 CONFIG.HOLD_MIN=0.05 CONFIG.HOLD_MAX=0.15 CONFIG.ENTRY_DELAY=0.1 CONFIG.COOLDOWN=0.2 CONFIG.PRIME_RANGE=60 speedMode=false;laggerToggled=false;laggerCarryToggled=false antiRagdollMode="off";antiDieEnabled=false _G.__RivalHubBatVersion="v2"antiBatEnabled=false antiFlingEnabled=false medusaCounterEnabled=false;batCounterEnabled=false;batCounterV2Enabled=false autoBatEnabled=false;autoLeftEnabled=false;autoRightEnabled=false unwalkEnabled=false;antiLagEnabled=false uiLocked=false;mobileButtonsLocked=false CONFIG.AUTO_STEAL_ENABLED=false autoStealMode="V1"if _G._rivalHubStealModeSetter then pcall(_G._rivalHubStealModeSetter,"V1")end BAT_AIMBOT_SPEED=58 BYPASS_AIMBOT_SPEED=BAT_AIMBOT_SPEED if State then State.bypassBatSpeed=BYPASS_AIMBOT_SPEED end dropMode=1;stretchEnabled=false;stretchFOV=120 uiScaleValue=78 if mainUIScale then mainUIScale.Scale=1 end if pbScale then pbScale.Scale=1 end espEnabled=false;espLineEnabled=false;vividGraphicsEnabled=false;hideButtonsEnabled=false bodyLockEnabled=false;bodyLockRange=20 autoCarryEnabled=false;autoCarryMode="On Pick Up"if _G.__RivalHubAutoCarryRestore then pcall(_G.__RivalHubAutoCarryRestore)end if _G.__RivalHubAutoCarryRefresh then pcall(_G.__RivalHubAutoCarryRefresh)end backgroundIndex=1;backgroundImageTransparency=0;backgroundMode="Background 1"floatingButtonScale=1 stealBarScale=1 if pbScale then pbScale.Scale=1 end currentAnimPack="Off";stopAnimPack()currentOutfitIndex=1 pcall(VX7A.stop)currentColorTheme="Orange";selectedColor=COLOR_THEMES["Orange"]currentRivalTitleTheme="Orange"applyRivalTitleTheme("White")if main then main.Position=UDim2.new(0,20,0,2);_G.__RivalHubMainOriginalPos=main.Position end for key,val in pairs(DEFAULT_KB)do if KB[key]then KB[key].kb=val.kb;KB[key].gp=val.gp end end resetFloatingPositions()forceResetUI()updateProgressBarVisibility()refreshSpeedModeLabel()_lastSavedJSON=nil end)_isResetting=false if not ok then warn("[resetToFactoryDefaults]",err)end if ok then saveAllSettings(true)end return ok end function updateProgressBarVisibility()if pbFrame then pbFrame.Visible=true end end function applyShimmerToText(obj,speed,baseColor)speed=speed or 0.8 local color=baseColor or Color3.fromRGB(215,215,225)local grad=Instance.new("UIGradient",obj)grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(0.3,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(0.5,color:Lerp(Color3.new(1,1,1),0.55)),ColorSequenceKeypoint.new(0.7,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(1,color),})grad.Rotation=45 grad.Offset=Vector2.new(0,0)task.spawn(function()local t=0 while grad and grad.Parent do t=t+0.02 grad.Offset=Vector2.new(math.sin(t*speed)*0.4,0)grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,color),ColorSequenceKeypoint.new(0.30,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(0.50,color:Lerp(Color3.new(1,1,1),0.55)),ColorSequenceKeypoint.new(0.70,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(1.00,color),})task.wait(0.04)end end)return grad end function getDefaultButtonPosition(btnName)local BTN_W,BTN_H=62,62 local GAP=8 if btnName=="InstantReset"then return 140,288 end local orderMap={DropBR=0,AutoLeft=1,AutoBat=2,AutoRight=3,TpDown=4,Carry=5,Lagger1=6,Lagger2=7,BatV2=8,BatTP=9,Float=10}local order=orderMap[btnName]or 0 local row=_floor(order/2)local col=order%2 return col*(BTN_W+GAP),row*(BTN_H+GAP+10)end local batDesyncTpEnabled=false local batDesyncTpConn=nil local hittingCooldownDesync=false local function updateTpBatButtonWithAntiDie(state)if tpBatFloatingButton then local btnFrame=tpBatFloatingButton:FindFirstChild("Frame")if btnFrame then local label=btnFrame:FindFirstChild("TextLabel")if label then label.Text="TP\nBAT"label.TextColor3=state and Color3.fromRGB(0,0,0)or Color3.fromRGB(255,255,255)end if state then btnFrame.BackgroundColor3=getThemeColor()else paintFloatingBtn(btnFrame,false)end end end end local function tpBatDisconnectAntiDie()for _,conn in ipairs(TPBatState.antiDieConnections)do pcall(function()conn:Disconnect()end)end TPBatState.antiDieConnections={}end local function tpBatHookAntiDie(character)tpBatDisconnectAntiDie()if not TPBatState.enabled or not character then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid then return end pcall(function()humanoid.BreakJointsOnDeath=false humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,false)humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying,false)end)local cooldown=false table.insert(TPBatState.antiDieConnections,humanoid:GetPropertyChangedSignal("Health"):Connect(function()if cooldown or not TPBatState.enabled or not humanoid.Parent or humanoid.Health>0 then return end cooldown=true task.defer(function()pcall(function()if humanoid and humanoid.Parent then humanoid.Health=humanoid.MaxHealth humanoid:ChangeState(Enum.HumanoidStateType.Running)end end)task.wait(0.5)cooldown=false end)end))end local function tpBatFindBat()local character=LP.Character if not character then return nil end local function isBat(tool)if not tool:IsA("Tool")then return false end local name=string.lower(tool.Name)return string.find(name,"bat",1,true)~=nil or string.find(name,"slap",1,true)~=nil end for _,child in ipairs(character:GetChildren())do if isBat(child)then return child end end local backpack=LP:FindFirstChildOfClass("Backpack")if not backpack then return nil end for _,child in ipairs(backpack:GetChildren())do if isBat(child)then local humanoid=character:FindFirstChildOfClass("Humanoid")if humanoid then pcall(function()humanoid:EquipTool(child)end)end return child end end return nil end local function tpBatSwing()if TPBatState.hitCooldown then return end TPBatState.hitCooldown=true pcall(function()local bat=tpBatFindBat()if not bat then return end bat:Activate()local remote=bat:FindFirstChildWhichIsA("RemoteEvent",true)if remote then pcall(function()remote:FireServer()end)end end)task.delay(0.05,function()TPBatState.hitCooldown=false end)end local function tpBatGetVersion()
return _G.__ZeyHubbTPBatVersion or TPBatState.version or"v1"
end
local function tpBatTick()
if not TPBatState.enabled then return end
local character=LP.Character
if not character then return end
local root=character:FindFirstChild("HumanoidRootPart")
local humanoid=character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health<=0 then return end
local version=tpBatGetVersion()
local function isValidTarget(player)
if not player or player==LP or not player.Character then return false end
local tr=player.Character:FindFirstChild("HumanoidRootPart")
local th=player.Character:FindFirstChildOfClass("Humanoid")
return tr and th and th.Health>0
end
if version=="v3" then
-- V3: port du moteur TP Bat H/Yjue (boucle k7, cible la plus proche, TP + vitesse cible).
local closestPlayer,closestDistance=nil,math.huge
for _,player in ipairs(Players:GetPlayers())do
if player~=LP and player.Character then
local targetRoot=player.Character:FindFirstChild("HumanoidRootPart")
local targetHumanoid=player.Character:FindFirstChildOfClass("Humanoid")
if targetRoot and targetHumanoid and targetHumanoid.Health>0 then
local distance=(root.Position-targetRoot.Position).Magnitude
if distance<closestDistance then closestDistance,closestPlayer=distance,player end
end
end
end
if not closestPlayer or closestDistance>100 then return end
local targetCharacter=closestPlayer.Character
local targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
if not targetRoot then return end
root.CFrame=CFrame.new(targetRoot.Position+Vector3.new(0,0.9,0))
root.AssemblyLinearVelocity=targetRoot.AssemblyLinearVelocity
local cam=Workspace.CurrentCamera
if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,targetRoot.Position) end
tpBatSwing()
for _,part in ipairs(character:GetDescendants())do
if part:IsA("BasePart")then part.CanCollide=false end
end
elseif version=="v2" then
-- V2 Crystal-style: lock target, TP behind, aggressive range
local locked=TPBatState.lockedTarget
if locked and not isValidTarget(locked) then
TPBatState.lockedTarget=nil
locked=nil
end
local closestPlayer,closestDistance=locked,math.huge
if locked then
local tr=locked.Character:FindFirstChild("HumanoidRootPart")
closestDistance=(root.Position-tr.Position).Magnitude
if closestDistance>140 then
TPBatState.lockedTarget=nil
closestPlayer,closestDistance=nil,math.huge
end
end
if not closestPlayer then
for _,player in ipairs(Players:GetPlayers())do
if isValidTarget(player) then
local tr=player.Character:FindFirstChild("HumanoidRootPart")
local distance=(root.Position-tr.Position).Magnitude
if distance<closestDistance and distance<=140 then
closestDistance,closestPlayer=distance,player
end
end
end
if closestPlayer then TPBatState.lockedTarget=closestPlayer end
end
if not closestPlayer then return end
local targetRoot=closestPlayer.Character:FindFirstChild("HumanoidRootPart")
if not targetRoot then return end
-- behind the target
local look=targetRoot.CFrame.LookVector
local behind=targetRoot.Position-look*3.2+Vector3.new(0,0.5,0)
if closestDistance>4 then
root.CFrame=CFrame.new(behind,targetRoot.Position)
elseif closestDistance>1.5 then
root.CFrame=CFrame.new(root.Position:Lerp(behind,0.55),targetRoot.Position)
else
root.CFrame=CFrame.new(root.Position,targetRoot.Position)
end
pcall(function()root.AssemblyLinearVelocity=Vector3.zero root.AssemblyAngularVelocity=Vector3.zero end)
local cam=Workspace.CurrentCamera
if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,targetRoot.Position+Vector3.new(0,0.6,0))end
tpBatSwing()
else
-- V1 original
local closestPlayer,closestDistance=nil,math.huge
for _,player in ipairs(Players:GetPlayers())do
if player~=LP and player.Character then
local targetRoot=player.Character:FindFirstChild("HumanoidRootPart")
local targetHumanoid=player.Character:FindFirstChildOfClass("Humanoid")
if targetRoot and targetHumanoid and targetHumanoid.Health>0 then
local distance=(root.Position-targetRoot.Position).Magnitude
if distance<closestDistance then closestDistance,closestPlayer=distance,player end
end
end
end
if not closestPlayer or closestDistance>100 then return end
local targetRoot=closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart")
if not targetRoot then return end
local targetPos=targetRoot.Position+Vector3.new(0,0.9,0)
if closestDistance>5 then root.CFrame=CFrame.new(targetPos,targetRoot.Position)
elseif closestDistance>2 then root.CFrame=CFrame.new(root.Position:Lerp(targetPos,0.35),targetRoot.Position)end
pcall(function()root.AssemblyLinearVelocity=Vector3.zero root.AssemblyAngularVelocity=Vector3.zero end)
local cam=Workspace.CurrentCamera
if cam then cam.CFrame=CFrame.new(cam.CFrame.Position,targetRoot.Position+Vector3.new(0,0.5,0))end
tpBatSwing()
end
end function tpBatSetEnabled(value)TPBatState.enabled=value==true batDesyncTpEnabled=TPBatState.enabled if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end if not TPBatState.enabled then TPBatState.lockedTarget=nil end if TPBatState.enabled then tpBatHookAntiDie(LP.Character)if TPBatState.connection then TPBatState.connection:Disconnect()end TPBatState.connection=RunService.Heartbeat:Connect(tpBatTick)else if TPBatState.connection then TPBatState.connection:Disconnect()TPBatState.connection=nil end tpBatDisconnectAntiDie()local character=LP.Character local root=character and character:FindFirstChild("HumanoidRootPart")if root then pcall(function()if root.SetNetworkOwner then root:SetNetworkOwner(LP)end end)end end updateTpBatButtonWithAntiDie(TPBatState.enabled)if mobSetBatTP then pcall(mobSetBatTP,TPBatState.enabled)end return TPBatState.enabled end function toggleBatTP()return tpBatSetEnabled(not TPBatState.enabled)end LP.CharacterAdded:Connect(function(character)if TPBatState.enabled then task.wait(0.1)tpBatHookAntiDie(character)end end)function buildGui()local ROW_BG=Color3.fromRGB(18,11,4)local ROW_BORDER=Color3.fromRGB(60,40,15)local WHITE=Color3.fromRGB(255,248,235)local INP=Color3.fromRGB(16,10,4)local GUI_W,GUI_H=330,520 local ACCENT=Color3.fromRGB(255,150,40)local ACCENT2=Color3.fromRGB(255,190,70)local MUTED=Color3.fromRGB(160,150,140)local GUI_NAMES={"RivalHub","RivalHubMobilePanel","RivalHubSpeedIndicator","RivalHubBootErrors"}local _okCg,_coreGui=pcall(function()return game:GetService("CoreGui")end)local _pgOld=LP:FindFirstChild("PlayerGui")for _,n in ipairs(GUI_NAMES)do if _okCg and _coreGui then local okFind,oldCg=pcall(function()return _coreGui:FindFirstChild(n)end)if okFind and oldCg then pcall(function()oldCg:Destroy()end)end end if _pgOld then local okFind2,o=pcall(function()return _pgOld:FindFirstChild(n)end)if okFind2 and o then pcall(function()o:Destroy()end)end end end gui=Instance.new("ScreenGui")gui.Name="RivalHub"gui.Enabled=false gui.ResetOnSpawn=false gui.DisplayOrder=10 gui.IgnoreGuiInset=true pcall(function()if syn and syn.protect_gui then syn.protect_gui(gui)end end)local guiOk=pcall(function()gui.Parent=game:GetService("CoreGui")end)if not guiOk then gui.Parent=LP:WaitForChild("PlayerGui")end main=Instance.new("Frame",gui)main.Size=UDim2.new(0,GUI_W,0,GUI_H)main.Position=UDim2.new(0,20,0,2)main.BackgroundColor3=Color3.fromRGB(10,6,2)main.BackgroundTransparency=0.05 main.BorderSizePixel=0 main.ClipsDescendants=true main.Active=true main.Selectable=true pcall(function()local d=_G.__ZeyHubbDragFrame or drag if type(d)=="function"then d(main,72)end end)Instance.new("UICorner",main).CornerRadius=UDim.new(0,18)local mainStroke=Instance.new("UIStroke",main)mainStroke.Name="MainAura"mainStroke.Color=Color3.fromRGB(255,190,80)mainStroke.Thickness=2.5 mainStroke.Transparency=0.12 task.spawn(function()local up=true while main and main.Parent and mainStroke and mainStroke.Parent do local goalT=up and 0.02 or 0.22 local goalTh=up and 3.0 or 2.2 local tw=TS:Create(mainStroke,TweenInfo.new(1.25,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goalT,Thickness=goalTh,Color=up and Color3.fromRGB(255,210,100)or Color3.fromRGB(255,170,55),})tw:Play()tw.Completed:Wait()up=not up end end)local mainInnerGlow=Instance.new("Frame",main)mainInnerGlow.Name="InnerGlow"mainInnerGlow.Size=UDim2.new(1,-4,1,-4)mainInnerGlow.Position=UDim2.new(0,2,0,2)mainInnerGlow.BackgroundTransparency=1 mainInnerGlow.BorderSizePixel=0 mainInnerGlow.ZIndex=1 Instance.new("UICorner",mainInnerGlow).CornerRadius=UDim.new(0,16)local innerStroke=Instance.new("UIStroke",mainInnerGlow)innerStroke.Color=Color3.fromRGB(230,110,20)innerStroke.Thickness=1 innerStroke.Transparency=0.75 local scriptHeader=Instance.new("Frame",main)scriptHeader.Name="ScriptHeader"scriptHeader.Size=UDim2.new(1,0,0,68)scriptHeader.Position=UDim2.new(0,0,0,0)scriptHeader.BackgroundColor3=Color3.fromRGB(14,8,2)scriptHeader.BackgroundTransparency=0.05 scriptHeader.BorderSizePixel=0 scriptHeader.ZIndex=20 scriptHeader.Active=true Instance.new("UICorner",scriptHeader).CornerRadius=UDim.new(0,16)local headerGrad=Instance.new("UIGradient",scriptHeader)headerGrad.Rotation=90 headerGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(40,22,6)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(22,12,4)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(10,6,2)),})local headerLine=Instance.new("Frame",scriptHeader)headerLine.Name="HeaderShine"headerLine.Size=UDim2.new(1,-24,0,2)headerLine.Position=UDim2.new(0,12,1,-2)headerLine.BackgroundColor3=Color3.fromRGB(255,190,70)headerLine.BorderSizePixel=0 headerLine.ZIndex=21 Instance.new("UICorner",headerLine).CornerRadius=UDim.new(1,0)local hlGrad=Instance.new("UIGradient",headerLine)hlGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0.00,1),NumberSequenceKeypoint.new(0.2,0.2),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(0.8,0.2),NumberSequenceKeypoint.new(1.00,1),})local hubTitle=Instance.new("TextLabel",scriptHeader)hubTitle.Name="HubTitle"hubTitle.Size=UDim2.new(0,158,0,34)hubTitle.Position=UDim2.new(0,12,0,4)hubTitle.BackgroundTransparency=1 hubTitle.Text="ZeyHubb.vs"hubTitle.TextColor3=Color3.fromRGB(255,230,160)hubTitle.Font=Enum.Font.GothamBlack hubTitle.TextSize=28 hubTitle.TextXAlignment=Enum.TextXAlignment.Left hubTitle.ZIndex=22 local titleGrad=Instance.new("UIGradient",hubTitle)titleGrad.Name="TitleShine"titleGrad.Rotation=0 titleGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,240)),ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255,220,120)),ColorSequenceKeypoint.new(0.55,Color3.fromRGB(255,170,50)),ColorSequenceKeypoint.new(0.80,Color3.fromRGB(255,200,90)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,240,180)),})local titleStroke=Instance.new("UIStroke",hubTitle)titleStroke.Name="TitleGlow"titleStroke.Color=Color3.fromRGB(255,160,40)titleStroke.Thickness=2.2 titleStroke.Transparency=0.2 scriptLogoRef=hubTitle
do
local dragHandle=scriptHeader
local dragTarget=main
local dragging=false
local dragInput=nil
local dragStart=nil
local startPos=nil
local function update(input)
if not dragging or uiLocked or not dragTarget or not dragTarget.Parent then return end
local delta=input.Position-dragStart
dragTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end
local function beginDrag(input)
if uiLocked or _isDraggingButton then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
dragging=true
dragInput=input
dragStart=input.Position
startPos=dragTarget.Position
end
local function endDrag(input)
if input and dragInput and input~=dragInput then return end
if dragging then
dragging=false
dragInput=nil
task.defer(function()pcall(saveAllSettings)end)
end
end
dragHandle.Active=true
dragHandle.InputBegan:Connect(function(input)
beginDrag(input)
end)
dragHandle.InputEnded:Connect(function(input)
endDrag(input)
end)
UIS.InputChanged:Connect(function(input)
if input==dragInput and dragging then update(input) end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
endDrag(input)
end
end)
-- also allow drag when pressing title labels (they sit on header)
for _,child in ipairs(dragHandle:GetDescendants()) do
if child:IsA("TextLabel") or child:IsA("Frame") then
child.Active=false
end
end
_G.__ZeyHubbMainWindowDragBound=true
end
 task.spawn(function()while hubTitle and hubTitle.Parent and titleGrad and titleGrad.Parent do titleGrad.Offset=Vector2.new(-1,0)local tw=TS:Create(titleGrad,TweenInfo.new(1.8,Enum.EasingStyle.Linear),{Offset=Vector2.new(1,0)})tw:Play()tw.Completed:Wait()task.wait(0.15)end end)task.spawn(function()local up=true while hubTitle and hubTitle.Parent and titleStroke and titleStroke.Parent do local goalT=up and 0.05 or 0.4 local goalTh=up and 2.8 or 1.8 local tw=TS:Create(titleStroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goalT,Thickness=goalTh})tw:Play()tw.Completed:Wait()up=not up end end)local discordTop=Instance.new("Frame",scriptHeader)discordTop.Name="DiscordTop"discordTop.Size=UDim2.new(0,210,0,16)discordTop.Position=UDim2.new(0,14,0,42)discordTop.BackgroundTransparency=1 discordTop.ZIndex=22 local byText="by FH2ONTOP."local byLetters={}local letterW=11 for i=1,#byText do local ch=byText:sub(i,i)local lbl=Instance.new("TextLabel",discordTop)lbl.Name="L"..i lbl.Size=UDim2.new(0,letterW,1,0)lbl.Position=UDim2.new(0,(i-1)*letterW,0,0)lbl.BackgroundTransparency=1 lbl.Text=ch lbl.TextColor3=Color3.fromRGB(200,150,90)lbl.Font=Enum.Font.GothamBold lbl.TextSize=13 lbl.TextXAlignment=Enum.TextXAlignment.Center lbl.ZIndex=23 local ls=Instance.new("UIStroke",lbl)ls.Color=Color3.fromRGB(255,140,30)ls.Thickness=1.1 ls.Transparency=0.85 byLetters[i]={lbl=lbl,stroke=ls}end task.spawn(function()while discordTop and discordTop.Parent do for i,item in ipairs(byLetters)do if not(item.lbl and item.lbl.Parent)then return end item.lbl.TextColor3=Color3.fromRGB(255,245,210)item.stroke.Transparency=0.15 item.stroke.Color=Color3.fromRGB(255,200,80)task.wait(0.07)item.lbl.TextColor3=Color3.fromRGB(255,180,70)item.stroke.Transparency=0.45 task.wait(0.02)end for _,item in ipairs(byLetters)do if item.lbl and item.lbl.Parent then item.lbl.TextColor3=Color3.fromRGB(210,155,90)item.stroke.Transparency=0.75 end end task.wait(0.35)end end)local avatarFrame=Instance.new("Frame",scriptHeader)avatarFrame.Size=UDim2.new(0,30,0,30)avatarFrame.Position=UDim2.new(0,175,0,6)avatarFrame.BackgroundColor3=Color3.fromRGB(24,14,5)avatarFrame.BorderSizePixel=0 avatarFrame.ZIndex=22 Instance.new("UICorner",avatarFrame).CornerRadius=UDim.new(1,0)local avStroke=Instance.new("UIStroke",avatarFrame)avStroke.Color=Color3.fromRGB(255,190,70)avStroke.Thickness=1.8 avStroke.Transparency=0.1 local avatarImg=Instance.new("ImageLabel",avatarFrame)avatarImg.Size=UDim2.new(1,2,1,2)avatarImg.Position=UDim2.new(0,-1,0,-1)avatarImg.BackgroundTransparency=1 avatarImg.Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"avatarImg.ZIndex=23 Instance.new("UICorner",avatarImg).CornerRadius=UDim.new(1,0)local displayNameLbl=Instance.new("TextLabel",scriptHeader)displayNameLbl.Visible=false displayNameLbl.Size=UDim2.new(0,1,0,1)displayNameLbl.BackgroundTransparency=1 displayNameLbl.Text=LP.DisplayName local usernameLbl=Instance.new("TextLabel",scriptHeader)usernameLbl.Visible=false usernameLbl.Size=UDim2.new(0,1,0,1)usernameLbl.BackgroundTransparency=1 usernameLbl.Text="@"..LP.Name local bgImage=Instance.new("ImageLabel",main)bgImage.Name="BackgroundImage"bgImage.Size=UDim2.new(1,0,1,0)bgImage.Position=UDim2.new(0,0,0,0)bgImage.BackgroundTransparency=1 bgImage.Image=_bgAsset(backgroundImages[backgroundIndex])bgImage.ImageTransparency=backgroundImageTransparency bgImage.ScaleType=Enum.ScaleType.Crop bgImage.ZIndex=0 bgImage.ClipsDescendants=true Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,18)mainUIScale=Instance.new("UIScale",main)mainUIScale.Scale=uiScaleValue/100 local closeBtn=Instance.new("TextButton",main)closeBtn.Size=UDim2.new(0,24,0,24)closeBtn.Position=UDim2.new(1,-30,0,16)closeBtn.BackgroundColor3=Color3.fromRGB(24,14,5)closeBtn.BackgroundTransparency=0.2 closeBtn.BorderSizePixel=0 closeBtn.Text="−"closeBtn.TextColor3=Color3.fromRGB(255,170,55)closeBtn.Font=Enum.Font.GothamBold closeBtn.TextSize=22 Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,8)closeBtn.AutoButtonColor=false closeBtn.ZIndex=200 closeBtn.MouseEnter:Connect(function()TS:Create(closeBtn,TweenInfo.new(0.12),{TextColor3=getThemeColor()}):Play()end)closeBtn.MouseLeave:Connect(function()TS:Create(closeBtn,TweenInfo.new(0.12),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)miniBtn=Instance.new("TextButton",gui)miniBtn.Name="MinimizedFrame"miniBtn.Size=UDim2.new(0,360,0,96)miniBtn.Position=UDim2.new(0,18,0,60)do local miniScale=Instance.new("UIScale",miniBtn)miniScale.Name="MiniScale"miniScale.Scale=130/360 end miniBtn.BackgroundColor3=Color3.fromRGB(0,0,0)miniBtn.BackgroundTransparency=0 miniBtn.BorderSizePixel=0 miniBtn.Text=""miniBtn.AutoButtonColor=false miniBtn.ZIndex=21 miniBtn.Visible=false Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,28)local VABEDO_B64="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"local function loadVabedoFont()local getAsset=getcustomasset or getsynasset if type(writefile)~="function"or type(getAsset)~="function"then return nil end local ttfName,jsonName="RivalHub_Vabedo.ttf","RivalHub_Vabedo.json"local okAll,result=pcall(function()local need=true if type(isfile)=="function"then local okF,has=pcall(isfile,ttfName)if okF and has then need=false end end if need then local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"local map={}for i=1,#chars do map[chars:sub(i,i)]=i-1 end local out,n={},0 local buf,bits=0,0 for i=1,#VABEDO_B64 do local v=map[VABEDO_B64:sub(i,i)]if v then buf=buf*64+v bits=bits+6 if bits>=8 then bits=bits-8 local byte=math.floor(buf/(2^bits))buf=buf-byte*(2^bits)n=n+1 out[n]=string.char(byte)end end end local raw={}for i=1,n,4096 do raw[#raw+1]=table.concat(out,"",i,math.min(i+4095,n))end writefile(ttfName,table.concat(raw))end local fam=game:GetService("HttpService"):JSONEncode({name="Vabedo",faces={{name="Regular",weight=400,style="normal",assetId=getAsset(ttfName)}}})writefile(jsonName,fam)return Font.new(getAsset(jsonName),Enum.FontWeight.Regular,Enum.FontStyle.Normal)end)if okAll then return result end return nil end local miniTitle=Instance.new("TextLabel",miniBtn)miniTitle.Name="RivalHubTitle"miniTitle.Size=UDim2.new(0.8,0,0.7,0)miniTitle.AnchorPoint=Vector2.new(0.5,0.5)miniTitle.Position=UDim2.new(0.5,0,0.5,0)miniTitle.BackgroundTransparency=1 miniTitle.Text="ZEYHUBB.VS"miniTitle.Font=Enum.Font.GothamBlack miniTitle.TextScaled=true miniTitle.TextWrapped=false miniTitle.TextSize=44 do local miniTitleLimit=Instance.new("UITextSizeConstraint",miniTitle)miniTitleLimit.MaxTextSize=38 miniTitleLimit.MinTextSize=8 end miniTitle.TextColor3=Color3.fromRGB(255,130,20)miniTitle.TextXAlignment=Enum.TextXAlignment.Center miniTitle.TextYAlignment=Enum.TextYAlignment.Center miniTitle.ZIndex=23 do local vabedo=loadVabedoFont()if vabedo then pcall(function()miniTitle.FontFace=vabedo end)end end local _mainAnimating=false local mainOriginalPos=main.Position _G.__RivalHubMainOriginalPos=mainOriginalPos main:GetPropertyChangedSignal("Position"):Connect(function()if not _mainAnimating then mainOriginalPos=main.Position _G.__RivalHubMainOriginalPos=mainOriginalPos end end)local animScale=Instance.new("UIScale",main)animScale.Scale=1 local _openTween,_closeTween=nil,nil showGui=function()if not main then return end if _openTween then _openTween:Cancel()end if _closeTween then _closeTween:Cancel()end _mainAnimating=true main.Visible=true miniBtn.Visible=false main.Position=UDim2.new(mainOriginalPos.X.Scale,mainOriginalPos.X.Offset-60,mainOriginalPos.Y.Scale,mainOriginalPos.Y.Offset)animScale.Scale=0.5 local info=TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)_openTween=TS:Create(main,info,{Position=mainOriginalPos})TS:Create(animScale,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()_openTween:Play()_openTween.Completed:Connect(function()_openTween=nil _mainAnimating=false end)end hideGui=function()if not main or not main.Visible then return end if _openTween then _openTween:Cancel()end if _closeTween then _closeTween:Cancel()end _mainAnimating=true local targetPos=UDim2.new(mainOriginalPos.X.Scale,mainOriginalPos.X.Offset-60,mainOriginalPos.Y.Scale,mainOriginalPos.Y.Offset)local info=TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In)_closeTween=TS:Create(main,info,{Position=targetPos})TS:Create(animScale,TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Scale=0.5}):Play()_closeTween:Play()_closeTween.Completed:Connect(function()main.Visible=false miniBtn.Visible=true _closeTween=nil _mainAnimating=false end)end closeBtn.Activated:Connect(hideGui)miniBtn.Activated:Connect(showGui)local TAB_H=36 local tabBar=Instance.new("Frame",main)tabBar.Name="TopTabBar"tabBar.Visible=true tabBar.Size=UDim2.new(1,-12,0,TAB_H)tabBar.Position=UDim2.new(0,6,0,72)tabBar.BackgroundColor3=Color3.fromRGB(14,8,3)tabBar.BackgroundTransparency=0.15 tabBar.BorderSizePixel=0 tabBar.ZIndex=15 Instance.new("UICorner",tabBar).CornerRadius=UDim.new(0,12)local barStroke=Instance.new("UIStroke",tabBar)barStroke.Color=Color3.fromRGB(255,195,90)barStroke.Thickness=1.8 barStroke.Transparency=0.18 local tabLayout=Instance.new("UIListLayout",tabBar)tabLayout.FillDirection=Enum.FillDirection.Horizontal tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center tabLayout.SortOrder=Enum.SortOrder.LayoutOrder tabLayout.Padding=UDim.new(0,4)local tabPad=Instance.new("UIPadding",tabBar)tabPad.PaddingLeft=UDim.new(0,5)tabPad.PaddingRight=UDim.new(0,5)tabPad.PaddingTop=UDim.new(0,4)tabPad.PaddingBottom=UDim.new(0,4)local tabContent=Instance.new("Frame",main)tabContent.Name="TabContent"tabContent.Size=UDim2.new(1,-12,1,-116)tabContent.Position=UDim2.new(0,6,0,112)tabContent.BackgroundColor3=Color3.fromRGB(12,7,2)tabContent.BackgroundTransparency=0.35 tabContent.BorderSizePixel=0 tabContent.ClipsDescendants=true tabContent.ZIndex=5 Instance.new("UICorner",tabContent).CornerRadius=UDim.new(0,12)local contentStroke=Instance.new("UIStroke",tabContent)contentStroke.Color=Color3.fromRGB(255,185,70)contentStroke.Thickness=1.7 contentStroke.Transparency=0.25 local tabs={"Speed","Combat","Visual","Steal","Config","Binds"}local tabIcons={Speed=">>",Combat="X",Visual="O",Steal="$",Config="*",Binds="#"}local tabPageKey={Speed="Speed",Combat="Combat",Visual="Visual",Steal="Steal",Config="Config",Binds="Keybinds"}tabButtons={}local contentPages={}local function styleTabInactive(b)local ul=b:FindFirstChild("Underline")if ul then ul.Visible=false end b.BackgroundColor3=Color3.fromRGB(20,12,4)b.BackgroundTransparency=0.3 b.TextColor3=Color3.fromRGB(190,160,130)local bs=b:FindFirstChild("TabStroke")if bs then bs.Transparency=0.55 bs.Color=Color3.fromRGB(120,70,25)bs.Thickness=1.2 end local tg=b:FindFirstChild("TabBgGrad")if tg then tg.Enabled=false end local ts=b:FindFirstChild("TabTextStroke")if ts then ts.Transparency=0.85;ts.Thickness=0.8 end end local function styleTabActive(b)local ul=b:FindFirstChild("Underline")if ul then ul.Visible=true ul.BackgroundColor3=Color3.fromRGB(255,230,140)end b.BackgroundColor3=Color3.fromRGB(255,150,40)b.BackgroundTransparency=0.08 b.TextColor3=Color3.fromRGB(255,252,240)local bs=b:FindFirstChild("TabStroke")if bs then bs.Transparency=0 bs.Color=Color3.fromRGB(255,230,140)bs.Thickness=2 end local tg=b:FindFirstChild("TabBgGrad")if tg then tg.Enabled=true tg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,245,210)),ColorSequenceKeypoint.new(0.40,Color3.fromRGB(255,175,55)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(210,95,15)),})end local ts=b:FindFirstChild("TabTextStroke")if not ts then ts=Instance.new("UIStroke",b)ts.Name="TabTextStroke"ts.ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual end ts.Color=Color3.fromRGB(255,180,50)ts.Thickness=1.2 ts.Transparency=0.35 end for i,name in ipairs(tabs)do local btn=Instance.new("TextButton",tabBar)btn.Name="Tab_"..name btn.Size=UDim2.new(0,50,1,0)btn.LayoutOrder=i btn.BackgroundColor3=Color3.fromRGB(22,13,5)btn.BackgroundTransparency=0.35 btn.BorderSizePixel=0 btn.Text=(tabIcons[name]or"").." "..name btn.TextColor3=Color3.fromRGB(170,145,120)btn.Font=Enum.Font.GothamBold btn.TextSize=10 btn.TextTruncate=Enum.TextTruncate.AtEnd btn.AutoButtonColor=false btn.ZIndex=16 Instance.new("UICorner",btn).CornerRadius=UDim.new(0,9)local tabBgGrad=Instance.new("UIGradient",btn)tabBgGrad.Name="TabBgGrad"tabBgGrad.Rotation=90 tabBgGrad.Enabled=false local tabStroke=Instance.new("UIStroke",btn)tabStroke.Name="TabStroke"tabStroke.Color=Color3.fromRGB(90,55,20)tabStroke.Thickness=1 tabStroke.Transparency=0.7 local underline=Instance.new("Frame",btn)underline.Name="Underline"underline.Size=UDim2.new(0.7,0,0,2)underline.Position=UDim2.new(0.5,0,1,-2)underline.AnchorPoint=Vector2.new(0.5,1)underline.BackgroundColor3=Color3.fromRGB(255,210,100)underline.BorderSizePixel=0 underline.Visible=false underline.ZIndex=17 Instance.new("UICorner",underline).CornerRadius=UDim.new(1,0)local page=Instance.new("ScrollingFrame",tabContent)page.Name="Page_"..name page.Size=UDim2.new(1,-8,1,-8)page.Position=UDim2.new(0,4,0,4)page.BackgroundTransparency=1 page.BorderSizePixel=0 page.ClipsDescendants=true page.ScrollBarThickness=3 page.ScrollBarImageColor3=Color3.fromRGB(255,160,50)page.ScrollBarImageTransparency=0.25 page.CanvasSize=UDim2.new(0,0,0,0)page.AutomaticCanvasSize=Enum.AutomaticSize.Y page.ScrollingDirection=Enum.ScrollingDirection.Y page.ZIndex=6 page.Visible=(i==1)local layout=Instance.new("UIListLayout",page)layout.SortOrder=Enum.SortOrder.LayoutOrder layout.Padding=UDim.new(0,4)local pagePad=Instance.new("UIPadding",page)pagePad.PaddingTop=UDim.new(0,4)pagePad.PaddingLeft=UDim.new(0,4)pagePad.PaddingRight=UDim.new(0,6)pagePad.PaddingBottom=UDim.new(0,12)local pageKey=tabPageKey[name]or name contentPages[pageKey]=page btn:SetAttribute("PageKey",pageKey)btn.Activated:Connect(function()for _,pg2 in pairs(contentPages)do pg2.Visible=false end page.Visible=true for _,b in ipairs(tabButtons)do styleTabInactive(b)end styleTabActive(btn)end)btn.MouseEnter:Connect(function()if btn:FindFirstChild("Underline")and btn.Underline.Visible then return end TS:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0.15,TextColor3=Color3.fromRGB(255,220,160)}):Play()local bs=btn:FindFirstChild("TabStroke")if bs then TS:Create(bs,TweenInfo.new(0.12),{Transparency=0.35,Color=Color3.fromRGB(255,160,50)}):Play()end end)btn.MouseLeave:Connect(function()if btn:FindFirstChild("Underline")and btn.Underline.Visible then return end styleTabInactive(btn)end)table.insert(tabButtons,btn)end if tabButtons[1]then styleTabActive(tabButtons[1])end local pageCounters={}local function getNextOrder(page)if not pageCounters[page]then pageCounters[page]=0 end pageCounters[page]=pageCounters[page]+1 return pageCounters[page]end local function mkSect(page,txt)if not page then return nil end local f=Instance.new("Frame",page)f.Size=UDim2.new(1,0,0,26)f.BackgroundTransparency=1 f.BorderSizePixel=0 f.LayoutOrder=getNextOrder(page)f.ZIndex=7 local accent=Instance.new("Frame",f)accent.Name="SectAccent"accent.Size=UDim2.new(0,3,0,14)accent.Position=UDim2.new(0,2,0.5,0)accent.AnchorPoint=Vector2.new(0,0.5)accent.BackgroundColor3=Color3.fromRGB(255,190,70)accent.BorderSizePixel=0 accent.ZIndex=8 Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)local l=Instance.new("TextLabel",f)l.Size=UDim2.new(1,-16,1,0)l.Position=UDim2.new(0,12,0,0)l.BackgroundTransparency=1 l.Text=string.upper(txt)l.TextColor3=Color3.fromRGB(255,200,100)l.Font=Enum.Font.GothamBlack l.TextSize=11 l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=8 local line=Instance.new("Frame",f)line.Size=UDim2.new(1,-100,0,1)line.Position=UDim2.new(1,-8,0.5,0)line.AnchorPoint=Vector2.new(1,0.5)line.BackgroundColor3=Color3.fromRGB(255,150,40)line.BackgroundTransparency=0.7 line.BorderSizePixel=0 line.ZIndex=8 return f end local function mkRow(page,h)if not page then return Instance.new("Frame")end local f=Instance.new("Frame",page)f.Size=UDim2.new(1,-2,0,h or 40)f.BackgroundColor3=ROW_BG f.BackgroundTransparency=0.12 f.BorderSizePixel=0 f.LayoutOrder=getNextOrder(page)f.ZIndex=7 Instance.new("UICorner",f).CornerRadius=UDim.new(0,11)local rowGrad=Instance.new("UIGradient",f)rowGrad.Name="RowGrad"rowGrad.Rotation=90 rowGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(48,28,10)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(30,18,6)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(14,8,3)),})local stroke=Instance.new("UIStroke",f)stroke.Name="RowStroke"stroke.Color=Color3.fromRGB(255,185,70)stroke.Thickness=1.5 stroke.Transparency=0.28 return f end local function mkLabel(row,txt)local l=Instance.new("TextLabel",row)l.Size=UDim2.new(1,-78,1,0)l.Position=UDim2.new(0,10,0,0)l.BackgroundTransparency=1 l.Text=txt l.TextColor3=Color3.fromRGB(255,245,230)l.Font=Enum.Font.GothamBold l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.TextTruncate=Enum.TextTruncate.AtEnd l.ZIndex=8 return l end local function mkPill(row,offset)local pill=Instance.new("Frame",row)pill.Name="Track"pill.Size=UDim2.new(0,24,0,24)pill.AnchorPoint=Vector2.new(1,0.5)pill.Position=UDim2.new(1,-11,0.5,0)pill.BackgroundColor3=Color3.fromRGB(14,14,16)pill.BorderSizePixel=0 pill.ZIndex=8 Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)local trackStroke=Instance.new("UIStroke",pill)trackStroke.Name="TrackStroke"trackStroke.Color=Color3.fromRGB(50,50,55)trackStroke.Thickness=1.8 trackStroke.Transparency=0.2 local glow=Instance.new("Frame",pill)glow.Name="Glow"glow.Size=UDim2.new(1,10,1,10)glow.Position=UDim2.new(0.5,0,0.5,0)glow.AnchorPoint=Vector2.new(0.5,0.5)glow.BackgroundTransparency=1 glow.ZIndex=7 Instance.new("UICorner",glow).CornerRadius=UDim.new(1,0)local glowStroke=Instance.new("UIStroke",glow)glowStroke.Name="GlowStroke"glowStroke.Color=Color3.fromRGB(255,180,60)glowStroke.Thickness=3 glowStroke.Transparency=1 local dot=Instance.new("Frame",pill)dot.Name="Knob"dot.Size=UDim2.new(1,-8,1,-8)dot.AnchorPoint=Vector2.new(0.5,0.5)dot.Position=UDim2.new(0.5,0,0.5,0)dot.BackgroundColor3=Color3.fromRGB(32,32,36)dot.BorderSizePixel=0 dot.ZIndex=9 Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)local coreGrad=Instance.new("UIGradient",dot)coreGrad.Name="KnobGrad"coreGrad.Rotation=135 coreGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(50,50,55)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(20,20,24)),})local dotStroke=Instance.new("UIStroke",dot)dotStroke.Name="KnobStroke"dotStroke.Color=Color3.fromRGB(45,45,50)dotStroke.Thickness=1 dotStroke.Transparency=0.5 local shine=Instance.new("Frame",dot)shine.Name="Spec"shine.Size=UDim2.new(0.55,0,0.35,0)shine.Position=UDim2.new(0.2,0,0.12,0)shine.BackgroundColor3=Color3.fromRGB(255,255,255)shine.BackgroundTransparency=0.75 shine.BorderSizePixel=0 shine.ZIndex=10 Instance.new("UICorner",shine).CornerRadius=UDim.new(1,0)return pill,dot end local function animPill(pill,dot,on)local dotStroke=dot:FindFirstChild("KnobStroke")local trackStroke=pill:FindFirstChild("TrackStroke")local glow=pill:FindFirstChild("Glow")local glowStroke=glow and glow:FindFirstChild("GlowStroke")local coreGrad=dot:FindFirstChild("KnobGrad")local shine=dot:FindFirstChild("Spec")local fadeInfo=TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)if on then TS:Create(pill,fadeInfo,{BackgroundColor3=Color3.fromRGB(255,145,30)}):Play()TS:Create(dot,fadeInfo,{BackgroundColor3=Color3.fromRGB(255,215,110)}):Play()if coreGrad then coreGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,250,220)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(255,190,70)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(220,100,20)),})end if trackStroke then TS:Create(trackStroke,fadeInfo,{Color=Color3.fromRGB(255,230,140),Transparency=0,Thickness=2.2,}):Play()end if glowStroke then TS:Create(glowStroke,fadeInfo,{Color=Color3.fromRGB(255,180,50),Transparency=0.35,Thickness=4,}):Play()end if dotStroke then TS:Create(dotStroke,fadeInfo,{Color=Color3.fromRGB(255,245,200),Transparency=0.15,}):Play()end if shine then TS:Create(shine,fadeInfo,{BackgroundTransparency=0.35}):Play()end else TS:Create(pill,fadeInfo,{BackgroundColor3=Color3.fromRGB(14,14,16)}):Play()TS:Create(dot,fadeInfo,{BackgroundColor3=Color3.fromRGB(32,32,36)}):Play()if coreGrad then coreGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(50,50,55)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(20,20,24)),})end if trackStroke then TS:Create(trackStroke,fadeInfo,{Color=Color3.fromRGB(50,50,55),Transparency=0.2,Thickness=1.8,}):Play()end if glowStroke then TS:Create(glowStroke,fadeInfo,{Transparency=1,Thickness=3}):Play()end if dotStroke then TS:Create(dotStroke,fadeInfo,{Color=Color3.fromRGB(45,45,50),Transparency=0.5,}):Play()end if shine then TS:Create(shine,fadeInfo,{BackgroundTransparency=0.75}):Play()end end end local function mkToggle(page,txt,cb)local row=mkRow(page,42)mkLabel(row,txt)local pill,dot=mkPill(row,62)local on=false local function sv(s)on=s;animPill(pill,dot,s)end local clk=Instance.new("TextButton",pill)clk.Size=UDim2.new(1,0,1,0)clk.BackgroundTransparency=1 clk.Text=""clk.AutoButtonColor=false clk.ZIndex=10 clk.Activated:Connect(function()on=not on sv(on)pcall(cb,on)task.defer(function()pcall(saveAllSettings)end)end)return sv,row end local function mkSelector(parent,default,options,cb)local container=Instance.new("Frame",parent)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local function styleArrow(btn,stroke)local grad=Instance.new("UIGradient",btn)grad.Rotation=90 grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,195,90)),ColorSequenceKeypoint.new(1,Color3.fromRGB(220,85,15))})local sc=Instance.new("UIScale",btn)sc.Scale=1 btn.MouseEnter:Connect(function()TS:Create(sc,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1.1}):Play()TS:Create(stroke,TweenInfo.new(0.12),{Transparency=0,Thickness=1.9}):Play()end)btn.MouseLeave:Connect(function()TS:Create(sc,TweenInfo.new(0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1}):Play()TS:Create(stroke,TweenInfo.new(0.14),{Transparency=0.05,Thickness=1.4}):Play()end)return sc end local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=Color3.fromRGB(235,105,22)leftBtn.BackgroundTransparency=0.02 leftBtn.BorderSizePixel=0 leftBtn.Text="‹"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=15 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,7)local leftStroke=Instance.new("UIStroke",leftBtn)leftStroke.Color=Color3.fromRGB(255,205,105)leftStroke.Thickness=1.4 leftStroke.Transparency=0.05 local leftScale=styleArrow(leftBtn,leftStroke)local label=Instance.new("TextLabel",container)label.Size=UDim2.new(0,80,0,26)label.Position=UDim2.new(0.5,-40,0.5,-13)label.BackgroundColor3=Color3.fromRGB(22,13,5)label.BackgroundTransparency=0.05 label.Text=default label.TextColor3=Color3.fromRGB(255,235,195)label.Font=Enum.Font.GothamBold label.TextSize=12 label.TextXAlignment=Enum.TextXAlignment.Center label.ZIndex=9 Instance.new("UICorner",label).CornerRadius=UDim.new(0,6)local labelStroke=Instance.new("UIStroke",label)labelStroke.Color=Color3.fromRGB(255,155,45)labelStroke.Thickness=1.2 labelStroke.Transparency=0.15 local leftDivider=Instance.new("Frame",container)leftDivider.Name="SelectorDividerLeft"leftDivider.Size=UDim2.new(0,2,0,18)leftDivider.Position=UDim2.new(0,31,0.5,-9)leftDivider.BackgroundColor3=Color3.fromRGB(255,190,85)leftDivider.BorderSizePixel=0 leftDivider.ZIndex=10 local rightDivider=Instance.new("Frame",container)rightDivider.Name="SelectorDividerRight"rightDivider.Size=UDim2.new(0,2,0,18)rightDivider.Position=UDim2.new(1,-31,0.5,-9)rightDivider.BackgroundColor3=Color3.fromRGB(255,190,85)rightDivider.BorderSizePixel=0 rightDivider.ZIndex=10 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=Color3.fromRGB(235,105,22)rightBtn.BackgroundTransparency=0.02 rightBtn.BorderSizePixel=0 rightBtn.Text="›"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=15 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,7)local rightStroke=Instance.new("UIStroke",rightBtn)rightStroke.Color=Color3.fromRGB(255,205,105)rightStroke.Thickness=1.4 rightStroke.Transparency=0.05 local rightScale=styleArrow(rightBtn,rightStroke)local function updateLabel(newText)label.Text=newText end local function pressAnim(sc)TS:Create(sc,TweenInfo.new(0.07,Enum.EasingStyle.Quad),{Scale=0.88}):Play()task.delay(0.07,function()if sc and sc.Parent then TS:Create(sc,TweenInfo.new(0.12,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)end leftBtn.Activated:Connect(function()pressAnim(leftScale)if cb then cb(-1,updateLabel);task.defer(function()pcall(saveAllSettings)end)end end)rightBtn.Activated:Connect(function()pressAnim(rightScale)if cb then cb(1,updateLabel);task.defer(function()pcall(saveAllSettings)end)end end)return label end local function mkToggleSelector(page,txt,cb,options,getKey,onSelect)local sv,row=mkToggle(page,txt,cb)local n=#options local arrow=Instance.new("TextButton",row)arrow.Name="SelectorArrow"arrow.Size=UDim2.new(0,36,0,30)arrow.AnchorPoint=Vector2.new(1,0.5)arrow.Position=UDim2.new(1,-66,0.5,0)arrow.BackgroundColor3=Color3.fromRGB(255,145,35)arrow.BackgroundTransparency=0 arrow.BorderSizePixel=0 arrow.Text="▼"arrow.Font=Enum.Font.GothamBlack arrow.TextSize=15 arrow.TextColor3=Color3.fromRGB(255,250,230)arrow.TextStrokeColor3=Color3.fromRGB(115,45,0)arrow.TextStrokeTransparency=0.3 arrow.AutoButtonColor=false arrow.ZIndex=14 arrow.ClipsDescendants=true Instance.new("UICorner",arrow).CornerRadius=UDim.new(0,9)local arrowGrad=Instance.new("UIGradient",arrow)arrowGrad.Rotation=90 arrowGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,230,140)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(255,160,40)),ColorSequenceKeypoint.new(1,Color3.fromRGB(210,70,10))})local arrowStroke=Instance.new("UIStroke",arrow)arrowStroke.Thickness=1.9 arrowStroke.Color=Color3.fromRGB(255,220,130)arrowStroke.Transparency=0.05 local arrowScale=Instance.new("UIScale",arrow)arrowScale.Scale=1 local shineFx=Instance.new("Frame",arrow)shineFx.Name="ArrowShineFx"shineFx.Size=UDim2.new(0.55,0,1.4,0)shineFx.Position=UDim2.new(-0.6,0,-0.2,0)shineFx.BackgroundColor3=Color3.fromRGB(255,255,240)shineFx.BackgroundTransparency=0.55 shineFx.BorderSizePixel=0 shineFx.ZIndex=15 shineFx.Rotation=18 Instance.new("UICorner",shineFx).CornerRadius=UDim.new(0,6)local shineGrad=Instance.new("UIGradient",shineFx)shineGrad.Rotation=90 shineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.2),NumberSequenceKeypoint.new(1,1)})task.spawn(function()while arrow and arrow.Parent and shineFx and shineFx.Parent do shineFx.Position=UDim2.new(-0.7,0,-0.2,0)local tw=TS:Create(shineFx,TweenInfo.new(1.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(1.15,0,-0.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.5)end end)arrow.MouseEnter:Connect(function()TS:Create(arrowScale,TweenInfo.new(0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1.1}):Play()TS:Create(arrowStroke,TweenInfo.new(0.14),{Transparency=0,Thickness=2.4}):Play()end)arrow.MouseLeave:Connect(function()TS:Create(arrowScale,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1}):Play()TS:Create(arrowStroke,TweenInfo.new(0.16),{Transparency=0.05,Thickness=1.9}):Play()end)local dd=Instance.new("Frame",page)dd.Name="SelectorOptions"dd.Size=UDim2.new(1,-4,0,0)dd.BackgroundColor3=Color3.fromRGB(18,10,3)dd.BackgroundTransparency=0.02 dd.BorderSizePixel=0 dd.LayoutOrder=getNextOrder(page)dd.Visible=false dd.ClipsDescendants=true dd.ZIndex=7 Instance.new("UICorner",dd).CornerRadius=UDim.new(0,11)local ddStroke=Instance.new("UIStroke",dd)ddStroke.Thickness=1.6 ddStroke.Color=Color3.fromRGB(255,175,70)ddStroke.Transparency=0.08 local ddShine=Instance.new("UIGradient",dd)ddShine.Rotation=0 ddShine.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.4,Color3.fromRGB(255,200,120)),ColorSequenceKeypoint.new(0.6,Color3.fromRGB(40,22,8)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,180,90))})ddShine.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.94),NumberSequenceKeypoint.new(0.45,0.6),NumberSequenceKeypoint.new(0.65,0.94),NumberSequenceKeypoint.new(1,0.98)})task.spawn(function()while dd and dd.Parent do if dd.Visible then ddShine.Offset=Vector2.new(-1.2,0)local tw=TS:Create(ddShine,TweenInfo.new(1.5,Enum.EasingStyle.Linear),{Offset=Vector2.new(1.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.3)else task.wait(0.4)end end end)local slider=Instance.new("Frame",dd)slider.Size=UDim2.new(1/n,-6,1,-8)slider.BackgroundColor3=Color3.fromRGB(255,135,28)slider.BackgroundTransparency=0.02 slider.BorderSizePixel=0 slider.ZIndex=8 Instance.new("UICorner",slider).CornerRadius=UDim.new(0,9)local sliderGrad=Instance.new("UIGradient",slider)sliderGrad.Rotation=90 sliderGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,210,100)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,150,35)),ColorSequenceKeypoint.new(1,Color3.fromRGB(210,70,10))})local sliderStroke=Instance.new("UIStroke",slider)sliderStroke.Color=Color3.fromRGB(255,235,160)sliderStroke.Thickness=1.6 sliderStroke.Transparency=0.05 local labels={}local function selIndex()local cur=getKey()for i,o in ipairs(options)do if o[1]==cur then return i end end return 1 end local function paint(animate)local selTxt=Color3.fromRGB(255,250,225)local idx=selIndex()local pos=UDim2.new((idx-1)/n,3,0,4)slider.BackgroundColor3=Color3.fromRGB(255,135,28)sliderStroke.Color=Color3.fromRGB(255,235,160)sliderStroke.Transparency=0.05 ddStroke.Color=Color3.fromRGB(255,175,70)ddStroke.Transparency=0.08 arrowStroke.Color=Color3.fromRGB(255,220,130)arrow.TextColor3=Color3.fromRGB(255,250,230)if animate then TS:Create(slider,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=pos}):Play()TS:Create(sliderStroke,TweenInfo.new(0.18),{Transparency=0,Thickness=2}):Play()task.delay(0.2,function()if sliderStroke and sliderStroke.Parent then TS:Create(sliderStroke,TweenInfo.new(0.25),{Transparency=0.05,Thickness=1.6}):Play()end end)else slider.Position=pos end for i,l in ipairs(labels)do if i==idx then l.TextColor3=selTxt l.TextTransparency=0 l.TextStrokeTransparency=0.55 else l.TextColor3=Color3.fromRGB(255,205,145)l.TextTransparency=0 l.TextStrokeTransparency=1 end end end for i,o in ipairs(options)do local lbl=Instance.new("TextLabel",dd)lbl.Size=UDim2.new(1/n,0,1,0)lbl.Position=UDim2.new((i-1)/n,0,0,0)lbl.BackgroundTransparency=1 lbl.Text=string.upper(tostring(o[2]))lbl.Font=Enum.Font.GothamBlack lbl.TextSize=12 lbl.TextStrokeColor3=Color3.fromRGB(0,0,0)lbl.ZIndex=9 labels[i]=lbl local b=Instance.new("TextButton",dd)b.Size=UDim2.new(1/n,0,1,0)b.Position=UDim2.new((i-1)/n,0,0,0)b.BackgroundTransparency=1 b.Text=""b.AutoButtonColor=false b.ZIndex=11 b.Activated:Connect(function()pcall(onSelect,o[1])paint(true)task.defer(function()pcall(saveAllSettings)end)end)end for i=1,n-1 do local separator=Instance.new("Frame",dd)separator.Name="OptionSeparator"separator.Size=UDim2.new(0,2,1,-12)separator.Position=UDim2.new(i/n,-1,0,6)separator.BackgroundColor3=Color3.fromRGB(255,190,90)separator.BackgroundTransparency=0.08 separator.BorderSizePixel=0 separator.ZIndex=12 end paint(false)local open,tw=false,nil arrow.Activated:Connect(function()open=not open if tw then tw:Cancel()end TS:Create(arrowScale,TweenInfo.new(0.08,Enum.EasingStyle.Quad),{Scale=0.9}):Play()task.delay(0.08,function()if arrowScale and arrowScale.Parent then TS:Create(arrowScale,TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)if open then paint(false)dd.Visible=true arrow.Text="▲"arrowStroke.Transparency=0 arrowGrad.Rotation=270 TS:Create(arrowStroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(255,235,160),Thickness=2.3}):Play()tw=TS:Create(dd,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(1,-4,0,42)})tw:Play()else arrow.Text="▼"arrowStroke.Transparency=0.05 arrowGrad.Rotation=90 TS:Create(arrowStroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(255,220,130),Thickness=1.9}):Play()tw=TS:Create(dd,TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.new(1,-4,0,0)})tw.Completed:Connect(function()if not open then dd.Visible=false end end)tw:Play()end end)return sv,function()paint(false)end end local function mkBox(parent,default,w,xOff,cb)local tb=Instance.new("TextBox",parent)local bw=w or 50 local xo=math.max(xOff or 56,bw+12)tb.Size=UDim2.new(0,bw,0,24)tb.Position=UDim2.new(1,-xo,0.5,-12)tb.BackgroundColor3=INP tb.BackgroundTransparency=0.7 tb.BorderSizePixel=0 tb.Text=tostring(default)tb.TextColor3=WHITE tb.Font=Enum.Font.GothamMedium tb.TextSize=11 tb.ClearTextOnFocus=false tb.ZIndex=8 Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)local bs=Instance.new("UIStroke",tb)bs.Color=ROW_BORDER bs.Thickness=1.2 bs.Transparency=0.25 tb.Focused:Connect(function()TS:Create(bs,TweenInfo.new(0.12),{Color=getThemeColor(),Transparency=0}):Play()end)tb.FocusLost:Connect(function()TS:Create(bs,TweenInfo.new(0.12),{Color=ROW_BORDER,Transparency=0.25}):Play()if cb then local n=tonumber(tb.Text)if n then cb(n)else tb.Text=tostring(default)end task.defer(function()saveAllSettings()end)end end)return tb end local function mkKeyButton(parent,kbEntry)local btn=Instance.new("TextButton",parent)btn.Size=UDim2.new(0,80,0,60)btn.Position=UDim2.new(1,-88,0.5,-30)btn.BackgroundColor3=INP btn.BackgroundTransparency=0.5 btn.BorderSizePixel=0 local function getLabel()return(kbEntry.gp and kbEntry.gp.Name)or(kbEntry.kb and kbEntry.kb.Name)or"None"end btn.Text=getLabel()btn.TextColor3=WHITE btn.Font=Enum.Font.GothamBold btn.TextWrapped=true btn.TextSize=11 btn.ZIndex=8 btn.AutoButtonColor=false Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)local bs=Instance.new("UIStroke",btn)bs.Color=ROW_BORDER bs.Thickness=1 local li=false;local lc;local pv=btn.Text;local listenStart=0 btn.Activated:Connect(function()if li then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=WHITE;return end pv=btn.Text;li=true;_anyKeyListening=true;listenStart=_tick();btn.Text="...";btn.TextColor3=WHITE lc=UIS.InputBegan:Connect(function(inp)if not li then return end if inp.KeyCode==Enum.KeyCode.Escape then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=WHITE;return end local isGp=isGamepadInput(inp)if isGp and _tick()-listenStart<0.15 then return end if not isBindableInput(inp)then return end btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;btn.TextColor3=WHITE li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end if isGp then kbEntry.gp=inp.KeyCode;kbEntry.kb=nil else kbEntry.kb=inp.KeyCode;kbEntry.gp=nil end task.defer(function()saveAllSettings()end)end)end)table.insert(keyButtonRefs,{btn=btn,entry=kbEntry})return btn end local function addKeybindRow(page,labelText,kbEntry)local row=mkRow(page,60)mkLabel(row,labelText)mkKeyButton(row,kbEntry)end local speedPage=contentPages["Speed"]if not speedPage then speedPage=contentPages["Config"]end mkSect(speedPage,"Speeds")do local row=mkRow(speedPage,42);mkLabel(row,"Normal Speed");normalBox=mkBox(row,NS,50,56,function(v)if v==v and v>0 and v<math.huge then NS=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end do local row=mkRow(speedPage,42);mkLabel(row,"Carry Speed");carryBox=mkBox(row,CS,50,56,function(v)if v==v and v>0 and v<math.huge then CS=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end do local row=mkRow(speedPage,42);mkLabel(row,"Lagger Normal Speed");laggerBox=mkBox(row,LAGGER_SPEED,50,56,function(v)if v==v and v>0 and v<math.huge then LAGGER_SPEED=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end do local row=mkRow(speedPage,42);mkLabel(row,"Lagger Carry Speed");lagger2Box=mkBox(row,LAGGER_CARRY_SPEED,50,56,function(v)if v==v and v>0 and v<math.huge then LAGGER_CARRY_SPEED=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end mkSect(speedPage,"Mode")do local row=mkRow(speedPage,42)mkLabel(row,"Current Mode")modeValLbl=Instance.new("TextLabel",row)modeValLbl.Size=UDim2.new(0,110,1,0)modeValLbl.Position=UDim2.new(1,-118,0,0)modeValLbl.BackgroundTransparency=1 modeValLbl.Text="Normal"modeValLbl.TextColor3=WHITE modeValLbl.Font=Enum.Font.GothamBold modeValLbl.TextSize=12 modeValLbl.TextXAlignment=Enum.TextXAlignment.Right modeValLbl.ZIndex=8 local clk=Instance.new("TextButton",row)clk.Size=UDim2.new(1,0,1,0)clk.BackgroundTransparency=1 clk.Text=""clk.AutoButtonColor=false clk.ZIndex=8 clk.Activated:Connect(function()toggleCarryMode()end)end mkSect(speedPage,"Auto Move")autoLeftSetVisual=mkToggle(speedPage,"Auto Left",function(on)autoLeftEnabled=on if on then startAutoLeft()else stopAutoLeft()end if mobSetAutoLeft then mobSetAutoLeft(on)end end)autoRightSetVisual=mkToggle(speedPage,"Auto Right",function(on)autoRightEnabled=on if on then startAutoRight()else stopAutoRight()end if mobSetAutoRight then mobSetAutoRight(on)end end)mkSect(speedPage,"Float")_G.__RivalHubFloatSetVisual=mkToggle(speedPage,"Float",function(on)if on then _G.__RivalHubFloat.enable()else _G.__RivalHubFloat.disable()end if mobSetFloat then mobSetFloat(on)end end)mkSect(speedPage,"Infinite Jump")infJumpSetVisual=mkToggle(speedPage,"Infinite Jump",function(on)if on then InfiniteJump.start()else InfiniteJump.stop()end end)do local row=mkRow(speedPage,42)mkLabel(row,"Jump Mode")local modes={"hold","manual"}local modeIdx=1 for i,m in ipairs(modes)do if m==(InfiniteJump.mode or"hold")then modeIdx=i break end end local selWrap=Instance.new("Frame",row)selWrap.Name="InfiniteJumpModeSelector"selWrap.Size=UDim2.new(0,168,0,32)selWrap.AnchorPoint=Vector2.new(1,0.5)selWrap.Position=UDim2.new(1,-10,0.5,0)selWrap.BackgroundColor3=Color3.fromRGB(16,9,2)selWrap.BackgroundTransparency=0.08 selWrap.BorderSizePixel=0 selWrap.ZIndex=12 Instance.new("UICorner",selWrap).CornerRadius=UDim.new(0,10)local selStroke=Instance.new("UIStroke",selWrap)selStroke.Color=Color3.fromRGB(255,175,70)selStroke.Thickness=1.6 selStroke.Transparency=0.12 local selShine=Instance.new("UIGradient",selWrap)selShine.Rotation=0 selShine.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.35,Color3.fromRGB(255,200,120)),ColorSequenceKeypoint.new(0.55,Color3.fromRGB(40,22,8)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,180,90))})selShine.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.92),NumberSequenceKeypoint.new(0.4,0.55),NumberSequenceKeypoint.new(0.6,0.92),NumberSequenceKeypoint.new(1,0.98)})task.spawn(function()while selWrap and selWrap.Parent do selShine.Offset=Vector2.new(-1.2,0)local tw=TS:Create(selShine,TweenInfo.new(1.6,Enum.EasingStyle.Linear),{Offset=Vector2.new(1.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.35)end end)local function makePremiumArrow(parent,side,text,xPos)local btn=Instance.new("TextButton",parent)btn.Name=(side=="L"and"Left"or"Right").."JumpModeArrow"btn.Size=UDim2.new(0,30,0,26)btn.Position=UDim2.new(0,xPos,0.5,-13)btn.BackgroundColor3=Color3.fromRGB(255,140,30)btn.BackgroundTransparency=0 btn.BorderSizePixel=0 btn.Text=text btn.TextColor3=Color3.fromRGB(255,250,230)btn.Font=Enum.Font.GothamBlack btn.TextSize=18 btn.TextStrokeColor3=Color3.fromRGB(120,40,0)btn.TextStrokeTransparency=0.25 btn.AutoButtonColor=false btn.ZIndex=14 btn.ClipsDescendants=true Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)local grad=Instance.new("UIGradient",btn)grad.Rotation=90 grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,230,140)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(255,160,40)),ColorSequenceKeypoint.new(1,Color3.fromRGB(210,70,10))})local stroke=Instance.new("UIStroke",btn)stroke.Color=Color3.fromRGB(255,220,130)stroke.Thickness=1.9 stroke.Transparency=0.05 local scale=Instance.new("UIScale",btn)scale.Scale=1 local shineFx=Instance.new("Frame",btn)shineFx.Name="ArrowShineFx"shineFx.Size=UDim2.new(0.55,0,1.4,0)shineFx.Position=UDim2.new(-0.6,0,-0.2,0)shineFx.BackgroundColor3=Color3.fromRGB(255,255,240)shineFx.BackgroundTransparency=0.55 shineFx.BorderSizePixel=0 shineFx.ZIndex=15 shineFx.Rotation=18 Instance.new("UICorner",shineFx).CornerRadius=UDim.new(0,6)local shineGrad=Instance.new("UIGradient",shineFx)shineGrad.Rotation=90 shineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.2),NumberSequenceKeypoint.new(1,1)})task.spawn(function()while btn and btn.Parent and shineFx and shineFx.Parent do shineFx.Position=UDim2.new(-0.7,0,-0.2,0)local tw=TS:Create(shineFx,TweenInfo.new(1.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(1.15,0,-0.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.5)end end)btn.MouseEnter:Connect(function()TS:Create(scale,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1.12}):Play()TS:Create(stroke,TweenInfo.new(0.15),{Transparency=0,Thickness=2.4}):Play()end)btn.MouseLeave:Connect(function()TS:Create(scale,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1}):Play()TS:Create(stroke,TweenInfo.new(0.18),{Transparency=0.05,Thickness=1.9}):Play()end)return btn,scale,stroke end local leftBtn,leftScale=makePremiumArrow(selWrap,"L","‹",4)local rightBtn,rightScale=makePremiumArrow(selWrap,"R","›",134)local modeValue=Instance.new("TextLabel",selWrap)modeValue.Name="InfiniteJumpModeValue"modeValue.Size=UDim2.new(0,90,0,26)modeValue.Position=UDim2.new(0.5,-45,0.5,-13)modeValue.BackgroundColor3=Color3.fromRGB(28,14,4)modeValue.BackgroundTransparency=0.15 modeValue.Text=string.upper(modes[modeIdx])modeValue.TextColor3=Color3.fromRGB(255,240,200)modeValue.Font=Enum.Font.GothamBlack modeValue.TextSize=13 modeValue.TextXAlignment=Enum.TextXAlignment.Center modeValue.ZIndex=13 Instance.new("UICorner",modeValue).CornerRadius=UDim.new(0,7)local valStroke=Instance.new("UIStroke",modeValue)valStroke.Color=Color3.fromRGB(255,185,70)valStroke.Thickness=1.3 valStroke.Transparency=0.2 local valGrad=Instance.new("UIGradient",modeValue)valGrad.Rotation=90 valGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.4,Color3.fromRGB(255,210,120)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,150,40))})valGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.7),NumberSequenceKeypoint.new(0.5,0.85),NumberSequenceKeypoint.new(1,0.95)})infJumpModeBtn=modeValue local switching=false local function applyMode(idx,animate)if switching then return end idx=((idx-1)%#modes)+1 modeIdx=idx local value=modes[modeIdx]switching=true local function finish()InfiniteJump.setMode(value)modeValue.Text=string.upper(value)if InfiniteJump.enabled then InfiniteJump.stop();InfiniteJump.start()end pcall(saveAllSettings,true)switching=false end if animate then local out=TS:Create(modeValue,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{TextTransparency=1,TextStrokeTransparency=1})out:Play()out.Completed:Connect(function()modeValue.Text=string.upper(value)TS:Create(modeValue,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextTransparency=0,TextStrokeTransparency=0.5}):Play()finish()end)TS:Create(valStroke,TweenInfo.new(0.2),{Color=Color3.fromRGB(255,230,140),Transparency=0}):Play()task.delay(0.25,function()if valStroke and valStroke.Parent then TS:Create(valStroke,TweenInfo.new(0.35),{Color=Color3.fromRGB(255,185,70),Transparency=0.2}):Play()end end)else finish()end end leftBtn.Activated:Connect(function()TS:Create(leftScale,TweenInfo.new(0.08,Enum.EasingStyle.Quad),{Scale=0.9}):Play()task.delay(0.08,function()if leftScale and leftScale.Parent then TS:Create(leftScale,TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)applyMode(modeIdx-1,true)end)rightBtn.Activated:Connect(function()TS:Create(rightScale,TweenInfo.new(0.08,Enum.EasingStyle.Quad),{Scale=0.9}):Play()task.delay(0.08,function()if rightScale and rightScale.Parent then TS:Create(rightScale,TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)applyMode(modeIdx+1,true)end)end local combatPage=contentPages["Combat"]or contentPages["Speed"]mkSect(combatPage,"Defense")setAntiBatVisual=mkToggle(combatPage,"Anti Bat",function(on)if on then startAntiBat()else stopAntiBat()end end)setAntiFlingVisual=mkToggle(combatPage,"Anti Fling",function(on)antiFlingEnabled=on if on then startAntiFling()else stopAntiFling()end saveAllSettings()end)if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled)end mkSect(combatPage,"Anti Ragdoll")do local choice=(antiRagdollMode=="v1"or antiRagdollMode=="v2")and antiRagdollMode or"v2"local sv,refresh=mkToggleSelector(combatPage,"Anti Ragdoll",function(on)if on then setAntiRagdollMode(choice)else setAntiRagdollMode("off")end end,{{"v1","V1"},{"v2","V2"}},function()return choice end,function(key)choice=key if antiRagdollMode~="off"then setAntiRagdollMode(key)end end)_G.updateAntiRagdollUI=function(mode)if mode=="v1"or mode=="v2"then choice=mode end sv(mode=="v1"or mode=="v2")refresh()end _G.updateAntiRagdollUI(antiRagdollMode)setAntiRagVisual=function(on)if not on then setAntiRagdollMode("off")end end end mkSect(combatPage,"Bat")do local sv,refresh=mkToggleSelector(combatPage,"Bat",function(on)if on then if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2)end else if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end end if mobSetBatV2 then pcall(mobSetBatV2,on)end end,{{"v2","Bat V2"},{"v3","Bat V3"}},function()return(_G.__RivalHubBatVersion=="v3")and"v3"or"v2"end,function(key)if _G.__RivalHubSetBatVersion then _G.__RivalHubSetBatVersion(key)else _G.__RivalHubBatVersion=key end end)_G.__RivalHubBatSetVisual=sv _G.updateBatVersionUI=function(ver)refresh()end sv(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false)refresh()end
do local sv,refresh=mkToggleSelector(combatPage,"TP Bat",function(on)
if on then pcall(tpBatSetEnabled,true)else pcall(tpBatSetEnabled,false)end
end,{{"v1","V1"},{"v2","V2"},{"v3","V3"}},function()
local version=_G.__ZeyHubbTPBatVersion or TPBatState.version or"v1"
return (version=="v3" or version=="v2")and version or"v1"
end,function(key)
_G.__ZeyHubbTPBatVersion=key
TPBatState.version=key
if TPBatState.enabled then TPBatState.lockedTarget=nil end
pcall(saveAllSettings,true)
end)
_G.__ZeyHubbTPBatSetVisual=sv
_G.__ZeyHubbTPBatRefresh=refresh
sv(TPBatState and TPBatState.enabled)
refresh()
end
setAntiDieVisual=mkToggle(combatPage,"Anti Die",function(on)antiDieEnabled=on if on then AntiDieModule.start()else AntiDieModule.stop()end saveAllSettings()end)if setAntiDieVisual then setAntiDieVisual(antiDieEnabled)end setUnwalkVisual=mkToggle(combatPage,"Unwalk",function(on)unwalkEnabled=on if on then startUnwalk()else stopUnwalk()end end)mkSect(combatPage,"Attack")do local sv,refresh=mkToggleSelector(combatPage,"Bypass Bat",function(on)if on then enableAutoBat()else disableAutoBat()end if mobSetAutoBat then mobSetAutoBat(on)end pcall(saveAllSettings,true)end,{{"v1","V1"},{"v2","V2"},{"v3","V3"}},function()local v=_G.__ZeyHubbBypassBatVersion or"v1" return(v=="v2"or v=="v3")and v or"v1"end,function(key)_G.__ZeyHubbBypassBatVersion=key if autoBatEnabled then disableAutoBat()enableAutoBat()end pcall(saveAllSettings,true)end)autoBatSetVisual=sv if refresh then refresh()end sv(autoBatEnabled==true)end
do local row=mkRow(combatPage,42);mkLabel(row,"Bypass Speed");batSpeedBox=mkBox(row,BYPASS_AIMBOT_SPEED,50,56,function(v)if v==v and v>0 and v<math.huge then BAT_AIMBOT_SPEED=v;BYPASS_AIMBOT_SPEED=v;State.bypassBatSpeed=v;if _G.SnowVS and _G.SnowVS.BatBypass and _G.SnowVS.BatBypass.ZCFG then _G.SnowVS.BatBypass.ZCFG.FOLLOW_SPEED=v end saveAllSettings()end end)end mkSect(combatPage,"Targeting")bodyLockSetVisual=mkToggle(combatPage,"Lock Enemy",function(on)bodyLockEnabled=on if on then if _blSuppressCount==0 then startBodyLock()end else stopBodyLock()end end)do local row=mkRow(combatPage,42)mkLabel(row,"Lock Enemy Range")bodyLockRangeBox=mkBox(row,bodyLockRange,50,56,function(v)if v and v>0 then bodyLockRange=_clamp(_floor(v),5,200)if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end end end)end do local sv,refresh=mkToggleSelector(combatPage,"Auto Carry",function(on)autoCarryEnabled=on if not on and _G.__RivalHubAutoCarryRestore then pcall(_G.__RivalHubAutoCarryRestore)end end,{{"On Pick Up","On Pick Up"},{"Soft Steal","Soft Steal"}},function()return autoCarryMode end,function(key)autoCarryMode=key end)sv(autoCarryEnabled==true)_G.__RivalHubAutoCarrySetVisual=sv _G.__RivalHubAutoCarryRefresh=function()sv(autoCarryEnabled==true);refresh()end end mkSect(combatPage,"Counters")setBatCounterVisual=mkToggle(combatPage,"Bat Counter",function(on)batCounterEnabled=on if on then startBatCounter()else stopBatCounter()end end)setBatCounterV2Visual=mkToggle(combatPage,"Bat Counter V2",function(on)batCounterV2Enabled=on if on then startBatCounterV2()else stopBatCounterV2()end end)setMedusaVisual=mkToggle(combatPage,"Medusa Counter",function(on)medusaCounterEnabled=on if on then if LP.Character then setupMedusaCounter(LP.Character)else stopMedusaCounter()end else stopMedusaCounter()end if setMedusaVisual then setMedusaVisual(on)end end)mkSect(combatPage,"Drop")dropBrainrotSetVisual=mkToggle(combatPage,"Drop Brainrot",function(on)if on then executeDropWithToggle(function(v)dropBrainrotSetVisual(v)if mobSetDropBR then mobSetDropBR(v)end end)end end)setDropVisual=dropBrainrotSetVisual do local row=mkRow(combatPage,42)mkLabel(row,"Drop Mode")dropModeBtnRef=mkSelector(row,dropMode==1 and"Fling"or"Jump Drop",{"Fling","Jump Drop"},function(dir,update)if dropActive then stopDropBrainrot()end dropMode=dropMode==1 and 2 or 1 update(dropMode==1 and"Fling"or"Jump Drop")end)end local stealPage=contentPages["Steal"]or contentPages["Config"]mkSect(stealPage,"Auto Steal")do local sv,refresh=mkToggleSelector(stealPage,"Auto Steal",function(on)CONFIG.AUTO_STEAL_ENABLED=on==true if on then pcall(startAutoSteal)else stopAutoSteal()end updateProgressBarVisibility()pcall(saveAllSettings,true)end,{{"V1","V1"},{"V2","V2"}},function()return autoStealMode=="V2"and"V2"or"V1"end,function(key)autoStealMode=key if CONFIG.AUTO_STEAL_ENABLED then stopAutoSteal();startAutoSteal()end pcall(saveAllSettings,true)end)setInstaGrab=sv autoStealModeBtn=setmetatable({},{__newindex=function(_,k)if k=="Text"then refresh()end end})_G._rivalHubStealModeSetter=function()refresh()end end do local row=mkRow(stealPage,42)mkLabel(row,"Steal Radius")radInput=mkBox(row,CONFIG.STEAL_RANGE,50,56,function(v)if v and v>=5 and v<=300 then CONFIG.STEAL_RANGE=_floor(v+0.5)Steal.StealRadius=CONFIG.STEAL_RANGE radInput.Text=tostring(CONFIG.STEAL_RANGE)saveAllSettings()end end)end mkSect(stealPage,"Auto Carry")do local sv,refresh=mkToggleSelector(stealPage,"Auto Carry",function(on)autoCarryEnabled=on if not on and _G.__RivalHubAutoCarryRestore then pcall(_G.__RivalHubAutoCarryRestore)end pcall(saveAllSettings)end,{{"On Pick Up","On Pick Up"},{"Soft Steal","Soft Steal"}},function()return autoCarryMode or"On Pick Up"end,function(key)autoCarryMode=key pcall(saveAllSettings)end)sv(autoCarryEnabled==true)_G.__RivalHubAutoCarrySetVisual=sv _G.__RivalHubAutoCarryRefresh=function()sv(autoCarryEnabled==true);refresh()end end mkSect(stealPage,"HUD")do local row=mkRow(stealPage,42)mkLabel(row,"Show Auto Steal Bar")local pill,dot=mkPill(row,62)local barOn=true local function setBar(s)barOn=s animPill(pill,dot,s)if pbFrame then pbFrame.Visible=s end end animPill(pill,dot,true)local clk=Instance.new("TextButton",pill)clk.Size=UDim2.new(1,0,1,0)clk.BackgroundTransparency=1 clk.Text=""clk.AutoButtonColor=false clk.ZIndex=10 clk.Activated:Connect(function()setBar(not barOn)end)end do local row=mkRow(stealPage,42)mkLabel(row,"Steal Bar Style")local styles={{"V1","V1"},{"V2","V2"},{"V3","V3"}}local function cur()return (stealBarStyle=="V2"or stealBarStyle=="V3")and stealBarStyle or"V1"end local lbl=mkSelector(row,cur(),{},function(direction,updateLabel)local idx=1 for i,s in ipairs(styles)do if s[1]==cur()then idx=i break end end idx=idx+direction if idx<1 then idx=#styles end if idx>#styles then idx=1 end stealBarStyle=styles[idx][1]if applyStealBarStyle then pcall(applyStealBarStyle,stealBarStyle)elseif _G.__ZeyHubbApplyStealBarStyle then pcall(_G.__ZeyHubbApplyStealBarStyle,stealBarStyle)end updateLabel(styles[idx][2])pcall(saveAllSettings,true)end)end local configPage=contentPages["Config"]mkSect(configPage,"Protection")local antiCrasherConnections={}local antiCrasherActive=false local antiCrasherCount=0 local antiCrasherSetVisual=nil local antiCrasherDestroyed={}local antiCrasherPatterns={"websocket","ws_","_ws","wss","socket","zl","ace","realtime","bridge","gateway","tunnel","relay","handshake","protocol","wschannel","socketio","socket_io"}local function isSuspiciousRemote(obj)if not(obj:IsA("RemoteEvent")or obj:IsA("RemoteFunction")or obj:IsA("BindableEvent")or obj:IsA("BindableFunction"))then return false end local lowerName=string.lower(tostring(obj.Name))for _,pattern in ipairs(antiCrasherPatterns)do if string.find(lowerName,pattern,1,true)then return true end end return false end local function destroySuspiciousRemote(obj)if antiCrasherDestroyed[obj]then return end antiCrasherDestroyed[obj]=true antiCrasherCount+=1 pcall(function()obj:Destroy()end)end local function scanSuspiciousRemotes(root)for _,obj in ipairs(root:GetDescendants())do if isSuspiciousRemote(obj)then destroySuspiciousRemote(obj)end end end local function stopAntiCrasher(preservePreference)antiCrasherActive=false if not preservePreference then _G.__ZeyHubbAntiCrasherEnabled=false end for _,connection in ipairs(antiCrasherConnections)do pcall(function()connection:Disconnect()end)end table.clear(antiCrasherConnections)end local function startAntiCrasher()stopAntiCrasher(true)antiCrasherActive=true _G.__ZeyHubbAntiCrasherEnabled=true antiCrasherCount=0 table.clear(antiCrasherDestroyed)for _,serviceName in ipairs({"ReplicatedStorage","ReplicatedFirst","Workspace"})do local ok,service=pcall(function()return game:GetService(serviceName)end)if ok and service then pcall(scanSuspiciousRemotes,service)table.insert(antiCrasherConnections,service.DescendantAdded:Connect(function(obj)if antiCrasherActive and isSuspiciousRemote(obj)then task.defer(function()if antiCrasherActive and obj.Parent then destroySuspiciousRemote(obj)end end)end end))end end warn("[ZeyHubb.vs Anti-Crasher] Surveillance active. Remotes supprimés : "..tostring(antiCrasherCount))end antiCrasherSetVisual=mkToggle(configPage,"ZeyHubb.vs Anti-Crasher",function(on)if on then startAntiCrasher()else stopAntiCrasher()warn("[ZeyHubb.vs Anti-Crasher] Surveillance désactivée.")end end)_G.__ZeyHubbSetAntiCrasher=function(state,save)state=state==true if state then startAntiCrasher()else stopAntiCrasher()end if antiCrasherSetVisual then pcall(antiCrasherSetVisual,state)end _G.__ZeyHubbAntiCrasherEnabled=state if save and not _isLoading then task.defer(function()pcall(saveAllSettings,true)end)end end _G.__ZeyHubbStopAntiCrasherRuntime=function()stopAntiCrasher(true)end if _G.__ZeyHubbAntiCrasherEnabled==true then task.defer(function()if _G.__ZeyHubbSetAntiCrasher then pcall(_G.__ZeyHubbSetAntiCrasher,true,false)end end)end mkSect(configPage,"Intro Song")do local row=mkRow(configPage,42)mkLabel(row,"Intro Song")local opts={"V1","V2"}local cur=((_G.__ZeyHubbIntroSongVersion=="v2")and"V2"or"V1")introSongSelectorLabel=mkSelector(row,cur,opts,function(direction,updateLabel)local idx=1 for i,v in ipairs(opts)do if v==((_G.__ZeyHubbIntroSongVersion=="v2")and"V2"or"V1")then idx=i break end end idx=idx+direction if idx<1 then idx=#opts elseif idx>#opts then idx=1 end local key=opts[idx] _G.__ZeyHubbIntroSongVersion=(key=="V2")and"v2"or"v1" updateLabel(key) pcall(saveAllSettings,true)end)end mkSect(configPage,"Media") do local row=mkRow(configPage,92) row.Size=UDim2.new(1,0,0,92)
local shell=Instance.new("Frame",row)
shell.Name="MusicPlayerShell"
shell.Size=UDim2.new(1,-10,0,78)
shell.Position=UDim2.new(0,5,0.5,-39)
shell.BackgroundColor3=Color3.fromRGB(12,8,18)
shell.BackgroundTransparency=0.08
shell.BorderSizePixel=0
shell.ZIndex=8
Instance.new("UICorner",shell).CornerRadius=UDim.new(0,16)
local shellStroke=Instance.new("UIStroke",shell)
shellStroke.Name="MusicAura"
shellStroke.Color=Color3.fromRGB(255,70,140)
shellStroke.Thickness=2.2
shellStroke.Transparency=0.15
local shellGrad=Instance.new("UIGradient",shell)
shellGrad.Rotation=25
shellGrad.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0.00,Color3.fromRGB(28,12,32)),
ColorSequenceKeypoint.new(0.45,Color3.fromRGB(55,10,40)),
ColorSequenceKeypoint.new(1.00,Color3.fromRGB(12,6,20)),
})
task.spawn(function()
local up=true
while shell and shell.Parent and shellStroke and shellStroke.Parent do
local tw=TS:Create(shellStroke,TweenInfo.new(1.1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
Transparency=up and 0.02 or 0.28,
Thickness=up and 3.1 or 1.9,
Color=up and Color3.fromRGB(255,120,200) or Color3.fromRGB(180,40,120),
})
tw:Play() tw.Completed:Wait() up=not up
end
end)
local glowRing=Instance.new("Frame",shell)
glowRing.Name="AuraRing"
glowRing.AnchorPoint=Vector2.new(0.5,0.5)
glowRing.Position=UDim2.new(0.5,0,0.5,0)
glowRing.Size=UDim2.new(1,10,1,10)
glowRing.BackgroundTransparency=1
glowRing.ZIndex=7
Instance.new("UICorner",glowRing).CornerRadius=UDim.new(0,18)
local ringStroke=Instance.new("UIStroke",glowRing)
ringStroke.Color=Color3.fromRGB(255,180,220)
ringStroke.Thickness=1.2
ringStroke.Transparency=0.55
task.spawn(function()
local up=true
while glowRing and glowRing.Parent and ringStroke and ringStroke.Parent do
local tw=TS:Create(ringStroke,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
Transparency=up and 0.25 or 0.7,
Thickness=up and 1.8 or 0.9,
})
tw:Play() tw.Completed:Wait() up=not up
end
end)
local openYMP=Instance.new("TextButton",shell)
openYMP.Name="OpenYouTubeMusicPlayer"
openYMP.Size=UDim2.new(1,-16,0,52)
openYMP.Position=UDim2.new(0,8,0.5,-26)
openYMP.BackgroundColor3=Color3.fromRGB(255,45,110)
openYMP.BorderSizePixel=0
openYMP.Text=""
openYMP.AutoButtonColor=false
openYMP.ZIndex=10
Instance.new("UICorner",openYMP).CornerRadius=UDim.new(0,13)
local openStroke=Instance.new("UIStroke",openYMP)
openStroke.Color=Color3.fromRGB(255,200,230)
openStroke.Thickness=1.6
openStroke.Transparency=0.2
local openGrad=Instance.new("UIGradient",openYMP)
openGrad.Rotation=90
openGrad.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,95,160)),
ColorSequenceKeypoint.new(0.45,Color3.fromRGB(220,30,100)),
ColorSequenceKeypoint.new(1.00,Color3.fromRGB(120,10,55)),
})
local openIcon=Instance.new("TextLabel",openYMP)
openIcon.Name="MusicIcon"
openIcon.BackgroundTransparency=1
openIcon.Size=UDim2.new(0,40,1,0)
openIcon.Position=UDim2.new(0,10,0,0)
openIcon.Text="♫"
openIcon.TextColor3=Color3.fromRGB(255,255,255)
openIcon.Font=Enum.Font.GothamBlack
openIcon.TextSize=26
openIcon.ZIndex=11
local openGlow=Instance.new("UIStroke",openIcon)
openGlow.Color=Color3.fromRGB(255,220,240)
openGlow.Thickness=1.1
openGlow.Transparency=0.2
local openTitle=Instance.new("TextLabel",openYMP)
openTitle.Name="OpenTitle"
openTitle.BackgroundTransparency=1
openTitle.Size=UDim2.new(1,-58,0,22)
openTitle.Position=UDim2.new(0,48,0.5,-18)
openTitle.Text="MUSIC PLAYER"
openTitle.TextColor3=Color3.fromRGB(255,255,255)
openTitle.Font=Enum.Font.GothamBlack
openTitle.TextSize=15
openTitle.TextXAlignment=Enum.TextXAlignment.Left
openTitle.ZIndex=11
local openSub=Instance.new("TextLabel",openYMP)
openSub.Name="OpenSub"
openSub.BackgroundTransparency=1
openSub.Size=UDim2.new(1,-58,0,16)
openSub.Position=UDim2.new(0,48,0.5,4)
openSub.Text="OPEN  ·  YouTube Music"
openSub.TextColor3=Color3.fromRGB(255,210,230)
openSub.Font=Enum.Font.GothamMedium
openSub.TextSize=11
openSub.TextXAlignment=Enum.TextXAlignment.Left
openSub.TextTransparency=0.1
openSub.ZIndex=11
local openChevron=Instance.new("TextLabel",openYMP)
openChevron.BackgroundTransparency=1
openChevron.Size=UDim2.new(0,28,1,0)
openChevron.Position=UDim2.new(1,-34,0,0)
openChevron.Text="›"
openChevron.TextColor3=Color3.fromRGB(255,255,255)
openChevron.Font=Enum.Font.GothamBlack
openChevron.TextSize=28
openChevron.ZIndex=11
openYMP.MouseEnter:Connect(function()
TS:Create(openYMP,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(255,80,150)}):Play()
TS:Create(openStroke,TweenInfo.new(0.18),{Transparency=0,Thickness=2.2}):Play()
TS:Create(shellStroke,TweenInfo.new(0.18),{Transparency=0.05,Thickness=3.2}):Play()
end)
openYMP.MouseLeave:Connect(function()
TS:Create(openYMP,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(255,45,110)}):Play()
TS:Create(openStroke,TweenInfo.new(0.18),{Transparency=0.2,Thickness=1.6}):Play()
end)
openYMP.Activated:Connect(function() if _G.__ZeyHubbYMPLaunching then return end if _G.__ZeyHubbYMPLaunched then pcall(function() if frame and frame.Parent then frame.Visible=true end if imageButton and imageButton.Parent then imageButton.Visible=false end end) openYMP.Text="" if openTitle then openTitle.Text="PLAYER OPENED" end if openSub then openSub.Text="Already running" end task.delay(1.2,function() if openYMP and openYMP.Parent then openYMP.Text="" if openTitle then openTitle.Text="MUSIC PLAYER" end if openSub then openSub.Text="OPEN  ·  YouTube Music" end end end) return end _G.__ZeyHubbYMPLaunching=true openYMP.Text="" if openTitle then openTitle.Text="LOADING..." end if openSub then openSub.Text="Please wait" end task.spawn(function() local ok,err=pcall(function() local source=[====[getgenv().YMP = getgenv().YMP or false

if getgenv().YMP then
	return
end

getgenv().YMP = true
task.wait(0.5)

local fn = cloneref or function(arg)
	return arg
end

local tweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tbl = { Ordem = "relevance", Data = "any", Duracao = "any", Pagina = 1 }
local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ordem = "relevance"
local data = "any"
local duracao = "any"
local tbl2 = { "relevance", "view" }
local tbl3 = { "any", "hours", "today", "week", "month", "year" }
local tbl4 = { "any", "short", "medium", "long" }
local tbl5 = {}
local tbl6 = {}
local tbl7 = {}
local tbl8 = {}
local tbl9 = {}
local tbl10 = {}
local tbl11 = {}
local v = fn(game:GetService("CoreGui"))
local v2 = fn(game:GetService("StarterGui"))
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = v
screenGui.IgnoreGuiInset = true
HttpService = fn(game:GetService("HttpService"))
local v3 = fn(game:GetService("Lighting"))
local v4 = fn(game:GetService("Players"))
local userId = v4.LocalPlayer.UserId
local str = v4.LocalPlayer.LocaleId:lower()
local v5 = fn(game:GetService("LogService"))
local v6 = fn(game:GetService("TweenService"))
fn(Instance.new("Sound"))
local v7 = fn(game:GetService("SoundService"))
local v8 = fn(game:GetService("Workspace"))
fn(game:GetService("RunService"))
fn(game:GetService("TextService"))
local v9 = fn(game:GetService("UserInputService"))
local currentCamera = v8.CurrentCamera
local flag = false
local flag2 = false
local screenGui2 = nil
local n = 1
local str2 = "Todos"
local flag3 = false
local flag4 = false
local n2 = 0
local v10 = nil
local tweenInfo4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo5 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo6 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local flag5 = true
local flag6 = false
local str3 = "https://ymp-api.ddns.net"
local websocket_ = WebSocket or websocket or Websocket or syn and syn.websocket or nil
local flag7 = false
local flag8 = false
local str4 = "Auto"
local v11 = nil
local flag9 = false
local v12 = nil
local udim2 = nil
local flag10 = false
local flag11 = false
local flag12 = false
local flag13 = false
local tween = nil
local n3 = 0
local text = nil
local flag14 = false
local layoutOrder = 0
local udim22 = UDim2.new(0, 4, 0, 4)
local udim23 = UDim2.new(0, 4, 1, 4)
local flag15 = true
local tween2 = nil
local v13 = nil
local tween3 = nil
local flag16 = false
local flag17 = false
local request_ = request or http_request or syn_request or syn and syn.request or http and http.request or fluxus and fluxus.request or getgenv and getgenv().request
local requestAsync

if request_ then
	requestAsync = request_
else
	requestAsync = http and http.request_async
end

local writeClipboard = setclipboard or toclipboard or syn and syn.write_clipboard
local setclipboard_

if writeClipboard then
	setclipboard_ = writeClipboard
else
	setclipboard_ = fluxus and fluxus.setclipboard
end

local gethwid_ = gethwid and gethwid()

if not gethwid_ then
	gethwid_ = syn and syn.gethwid and syn.gethwid()
end

gethwid_ = gethwid_ or fluxus and fluxus.gethwid and fluxus.gethwid()
local hwid

if gethwid_ then
	hwid = gethwid_
else
	hwid = getgenv and getgenv().hwid
end

local v14 = hwid or userId
local flag18 = typeof(clonefunction) == "function" and clonefunction or nil
local v15 = flag18 and flag18(pcall) or pcall
local v16 = flag18 and flag18(typeof) or typeof

CheckRequest = function()
	local v17 = v15(function()
		return ishooked
	end) and ishooked or nil

	local v18 = v15(function()
		return restorefunction
	end) and restorefunction or nil

	if v16(v18) == "function" and v16(v17) == "function" then
		local v19, v20 = v15(v17, v17)

		if v19 and v20 then
			v15(v18, v17)
		end
	end

	if v16(v17) == "function" then
		local v19, v20 = v15(v17, requestAsync)
		if v19 and v20 then
			return false
		end
		local v21, v22 = v15(v17, game.HttpGet)
		if v21 and v22 then
			return false
		end
	end

	return true
end

if not CheckRequest() then
	return
end

local ok, result = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Versao")

if not ok or not result or not CheckRequest() then
	return
end

local str5 = result:gsub("%s+", ""):gsub("[^%w.]", "")

if str5 == "off" then
	return
end

if str5 ~= "8.5" then
	getgenv().YMP = false
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/YoutubeMusicPlayer.lua", true))()
	return
end

local ok2, result2 = pcall(function()
	return game:HttpGet("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Notifications")
end)

if ok2 then
	local ok3, result3 = pcall(function()
		return HttpService:JSONDecode(result2)
	end)

	if ok3 and result3 then
		local str6 = (result3.title or ""):gsub("%s+", "")
		local str7 = (result3.text or ""):gsub("%s+", "")

		if str6 ~= "" or str7 ~= "" then
			v2:SetCore("SendNotification", {
				Title = result3.title or "Empty",
				Text = result3.text or "Empty",
				Icon = "rbxassetid://83758613781843",
				Duration = 10,
			})

			task.wait(5)
		end
	end
end

Carregar = function()
	if not flag then
		flag = true
		screenGui2 = Instance.new("ScreenGui")
		screenGui2.Parent = v
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLabel.Size = UDim2.new(0, 0, 0, 0)
		imageLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
		imageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		imageLabel.Image = "rbxassetid://132058030456598"
		imageLabel.Active = true
		imageLabel.Draggable = false
		imageLabel.Parent = screenGui2
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 5)
		uiCorner.Parent = imageLabel
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Thickness = 2
		uiStroke.Color = Color3.fromRGB(255, 0, 0)
		uiStroke.Parent = imageLabel
		local tween4 = v6:Create(imageLabel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0.4, 0, 0.5, 0), Position = UDim2.new(0.5, 0, 0.4, 0) })
		tween4:Play()

		tween4.Completed:Connect(function()
			if not flag then
				return
			end
			flag2 = true

			task.spawn(function()
				while true do
					if flag2 and imageLabel.Parent then
						local tween5 = v6:Create(imageLabel, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0.5, 0, 0.38, 0) })
						local tween6 = v6:Create(imageLabel, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0.5, 0, 0.42, 0) })
						tween5:Play()
						tween5.Completed:Wait()

						if flag2 then
							tween6:Play()
							tween6.Completed:Wait()
							continue
						end
					end

					break
				end
			end)
		end)
	else
		flag = false
		flag2 = false

		if screenGui2 then
			local imageLabel = screenGui2:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				local tween4 = v6:Create(imageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Position = UDim2.new(0.5, 0, -0.5, 0),
					BackgroundTransparency = 1,
					ImageTransparency = 1,
				})

				tween4:Play()

				tween4.Completed:Connect(function()
					if screenGui2 then
						screenGui2:Destroy()
						screenGui2 = nil
					end
				end)
			else
				screenGui2:Destroy()
				screenGui2 = nil
			end
		end
	end
end

Carregar()

Traducao = {
	Sucesso = "Success",
	Erro = "Error",
	Imcompativel = "Your executor does not have support",
	Navegacao = "Navigation",
	Player = "Media Player",
	Add = "Add New",
	Equalizador = "Audio adjustment",
	Welcome = "Welcome",
	Dev = "Creator",
	Hey = "Hey you!",
	Play = "Play a song for me",
	Volume = "Volume",
	Freque = "Sound frequencies",
	Efeitos = "Sound effects",
	Graves = "Bass",
	Medios = "Mids",
	Agudos = "Treble",
	Nenhum = "None",
	Todos = "All",
	Musicas = "Musics",
	Favoritos = "Favorites",
	Favoritado = "Added to favorites",
	Desfavoritado = "Removed from favorites",
	Excluido = "Content deleted",
	Vazio = "Empty",
	VazioTexto = "There is nothing in this category at the moment",
	Search = "Search",
	Pesquisar = "Search for a YouTube title or link",
	Pesquisar2 = "Search for a YouTube title or link, or a Roblox ID",
	PesquiseTitle = "Start a search",
	PesquiseText = "We'll do our best to find your video or music",
	PesquiseTextPL = "We'll search through your entire playlist",
	SemResutadoTitle = "No results",
	SemResutadoText = "We checked everywhere possible, but we couldn't find any results for that search",
	SemResutadoTextPL = "We didn't find any results for that search in your playlist",
	LocalTitle = "Local Audios",
	LocalText = "There's nothing here yet, Add new audio files to the 'Local Audio' folder of the script",
	EscolhaFor = "Select the desired format",
	Musica = "Music",
	Cancelar = "Cancel",
	De = "By",
	In = "In",
	ErroCrackTitle = "Request denied",
	ErroCrackText = "It appears you do not have a valid Premium key",
	ErroTitle = "Something went wrong",
	ErroText = "There was an instability on our servers or in your internet connection, Please try again",
	Aguarde = "Please wait",
	Dados = "We are obtaining data from your file",
	MaisUmPauco = "Almost ready",
	Baixando = "We are downloading your file to add it to your playlist",
	Baixado = "Download complete!",
	Terminou = "Everything went well, and it's already been added to your playlist",
	Priv1 = "Download and play videos",
	Priv2 = "Advanced search",
	PP = "Premium Privilege",
	SobrePri1 = "You will be able to download and watch any YouTube video",
	SobrePri2 = "Have an advanced search that includes search filters and more pages of results",
	SobrePri3 = "You can use MiniPlayer to watch videos or control music on a small floating window",
	SobrePri4 = "Add and listen to any audio from the Roblox library",
	SobrePri5 = "You will be able to interact in Global Chat and converse with other YouTube Music Player users in real time",
	SobrePri6 = "The floating button will have a stylish yellow look!",
	Key = "Enter the Premium key here",
	Link = "Get a free key",
	Robux = "Buy a key with Robux",
	KeyInvalida = "The key you provided is invalid or has expired!",
	KeyErro = "An error occurred while validating your key, Please try again in a few seconds",
	JaTemKey = "It seems to me that you already have a registered key",
	LinkCopiado = "Link copied!",
	Navegador = "Paste the link into your browser to get the key",
	TooMany = "Too many requests",
	RateLi = "You are making too many requests, Wait a few seconds and try again!",
	KeyError = "An error occurred in the key system, Please try again",
	OpcaoBloqueadaTitle = "Option blocked",
	OpcaoBloqueadaText = "Get a Premium key to use this!",
	NenhumaMidia = "No valid tracks found in your playlist's current category!",
	PlayMode = "Playback mode",
	Auto = "Auto-skip: The next track from the current category in your playlist will be selected automatically",
	Repetir = "Repeat: The current track you are listening to will be repeated on a loop",
	Random = "Random: The system will randomly select a track from the current category of your playlist",
	PlayModeRepetir = "No valid tracks found in your playlist's current category, Repeating...",
	DownloadFazendo = "Wait for the system to finish loading the images",
	RecursoTi = "Resource unavailable",
	RecursoTe = "The main equalizer options are not compatible with video",
	RsetadoEqua = "All the changes you made to the equalizer have been removed!",
	NaoPodePagina = "You cannot change pages at the moment",
	NaoPodeFiltro = "Do a search before applying filters!",
	Processando = "Processing...",
	Filter = "Search filters",
	Order = "Order:",
	UploaDate = "Upload Date:",
	Duration = "Duration:",
	AplicarF = "Apply filters",
	RemoverF = "Remove filters",
	Relevance = "Relevance",
	View = "Most viewed",
	Any = "Any",
	Hours = "Last hours",
	Today = "Today",
	Week = "This week",
	Month = "This month",
	Year = "This year",
	Short = "Short(less than 4 minutes)",
	Long = "Long(more than 20 minutes)",
	Medium = "Medium(4 to 20 minutes)",
	JaTemRoblox = "You already have this Roblox ID in your playlist!",
	JaTemMusica = "You already have this song in your playlist!",
	JaTemVideo = "You already have this video in your playlist!",
	FiltrosRemovidos = "All applied filters have been removed!",
	FiltrosJaPadrao = "All filters are already defined by default!",
	Privado = "This audio has been set to private or deleted, It cannot be played",
	VocePremium = "Validated Key",
	Keyless = "Global Chat keyless",
	KeylessOn = "Keyless mode is enabled, Global chat is now unlocked!",
	KeylessOff = "Keyless mode has been disabled, Global Chat is blocked!",
	VocePremiumTexto = "Your Premium has been successfully activated, Enjoy your privileges!",
	Respeito = "Follow the rules to avoid being banned",
	RegrasTi = "Chat Rules",
	Regras = "No insults, No racism, No inappropriate or malicious content, No spam, No suspicious links",
	Sistema = "System",
	EnvieGc = "Write something...",
	GcKey = "Get a premium key to send messages in global chat",
	GcBan = "You have been banned from Global Chat, You can appeal on Discord using your ID:",
	GcUnban = "You have been unbanned from global chat, Behave yourself to avoid being banned again!",
	Banido = "You have been banned",
	Desbanido = "You have been unbanned",
	ExploitIcomGC = "Your executor does not support Global Chat!",
	TraducaoSystem = "Translation",
	TraduOn = "The Global Chat translation system has been enabled",
	TraduOff = "The Global Chat translation system has been disabled",
	TextoCopiado = "Copied message",
	Mutado = "Sounds Removed",
	Desmutado = "Sounds Restored",
	SobreMute = "All game sounds have been removed",
	SobreUnmute = "All the game sounds have been restored",
	AvisoReport1 = "Report Notice — You are about to report the user",
	AvisoReport2 = "on Global Chat, Are you sure you want to continue? False reports that do not involve an actual rule violation may result in a ban.",
	ReportSucesso = "Report sent!",
	ReportSucesso2 = "Your report has been submitted to our staff team, We will review it and take the necessary actions",
	MotivoReport = "Enter the reason for the report here",
	ReportErro = "Report Error",
	ReportErro1 = "For security reasons, you must have a valid Premium key to submit reports",
	ReportErro2 = "The reported message could not be found, Are you attempting to submit a false report?",
	ReportErro3 = "An error occurred while processing the report, Please try again",
	ReportErro4 = "You can only submit new reports every 2 minutes",
	ReportErro5 = "Are you seriously trying to report yourself?",
	ReportErro6 = "You have already reported this message",
	ReportErro7 = "This message has already been reported by another user",
	ReportErro8 = "You are banned and cannot submit reports",
	ReportErro10 = "Write a reason in your report!",
	ReportErro11 = "The reason must be a minimum of 10 characters and a maximum of 200 characters",
	Aviso = "Warning",
	FecharAviso = "Close warn",
	MsgMod = "Message from the moderator:",
	Tutorial = "The link has been copied successfully — Paste it into your browser for instructions on how to resolve download errors",
	Tentando = "Trying Again",
	TentandoTexto = "We will try downloading again",
	GCmudo = "Global Chat muted",
	GCmudoTexto = "New messages will not be notified via the floating button",
	GCunmudo = "Global Chat unmuted",
	GCunmudoTexto = "You will be notified of each new message",
	MidiaErro = "Error loading media",
	MidiaErroMsg = "Could not load: Unsupported executor or corrupted file",
}

pcall(function()
	if str == "en-us" or not Traducao then
		return
	end
	local str6 = str:sub(1, 2)
	local tbl12 = {}
	local tbl13 = {}
	local n4 = 0

	for k, v17 in pairs(Traducao) do
		n4 += 1
		tbl12[n4] = k
		tbl13[n4] = v17
	end

	local str7 = table.concat(tbl13, " || ")

	local ok3, result3 = pcall(function()
		return game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(str7))
	end)

	if ok3 and result3 then
		local data2 = HttpService:JSONDecode(result3)
		local v17 = data2 and data2[1]
		local str8 = ""

		if v17 then
			for _, v18 in ipairs(data2[1]) do
				str8 ..= v18[1] or ""
			end
		end

		local parts = str8:split("||")

		for i = 1, n4 do
			local v18 = parts[i]

			if v18 then
				Traducao[tbl12[i]] = v18:match("^%s*(.-)%s*$")
			end
		end
	end
end)

TraduzirMsg = function(arg)
	local str6 = (str or "en"):sub(1, 2)

	local ok3, result3 = pcall(function()
		local response = game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(arg))
		local data2 = HttpService:JSONDecode(response)

		if data2 and data2[1] then
			if data2[2] == str6 then
				return arg
			end
			local tbl12 = {}

			for _, v17 in ipairs(data2[1]) do
				table.insert(tbl12, v17[1] or "")
			end

			return table.concat(tbl12):match("^%s*(.-)%s*$")
		end

		return arg
	end)

	arg = ok3 and result3 or arg
	return arg
end

local sound = Instance.new("Sound")
sound.Looped = false
sound.Parent = v7

local function fn2(arg)
	sound.SoundId = "rbxassetid://" .. arg
	sound:Play()
end

local function fn3(text2, text3, arg, arg2)
	if type(text2) ~= "string" then
		local v17 = tostring
		text2 = text2 or ""
		text2 = v17(text2)
	end

	if type(text3) ~= "string" then
		local v17 = tostring
		text3 = text3 or ""
		text3 = v17(text3)
	end

	if type(arg) ~= "number" then
		arg = 3
	end

	n2 += 1
	local v17 = n2
	fn2(arg2 ~= nil and type(arg2) == "number" and tostring(arg2) or "129485210015224")
	local notifGui = v4.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("NotifGui")

	if not notifGui then
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "NotifGui"
		notifGui.ResetOnSpawn = false
		notifGui.Parent = v
	end

	if v10 and v10.Parent then
		v10:Destroy()
		v10 = nil
	end

	local imageButton = Instance.new("ImageButton")
	imageButton.Size = UDim2.new(0, 0, 0, 0)
	imageButton.Position = UDim2.new(0.5, 0, 0, 10)
	imageButton.AnchorPoint = Vector2.new(0.5, 0)
	imageButton.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
	imageButton.BackgroundTransparency = 0.08
	imageButton.BorderSizePixel = 0
	imageButton.AutomaticSize = Enum.AutomaticSize.Y
	imageButton.ClipsDescendants = true
	imageButton.Parent = notifGui
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = imageButton
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(178, 34, 34)
	uiStroke.Thickness = 0
	uiStroke.Parent = imageButton
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -10, 0, 25)
	textLabel.Position = UDim2.new(0, 5, 0, 5)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = imageButton
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -10, 0, -2)
	textLabel2.Position = UDim2.new(0, 5, 0, 35)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
	textLabel2.Font = Enum.Font.SourceSans
	textLabel2.Size = UDim2.new(1, -10, 0, 0)
	textLabel2.AutomaticSize = Enum.AutomaticSize.Y
	textLabel2.TextWrapped = true
	textLabel2.TextSize = 20
	textLabel2.Text = ""
	textLabel2.TextXAlignment = Enum.TextXAlignment.Center
	textLabel2.TextYAlignment = Enum.TextYAlignment.Center
	textLabel2.Parent = imageButton
	v10 = imageButton
	local tween4 = v6:Create(imageButton, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = UDim2.new(0.45, 0, 0, 70) })
	imageButton.Size = UDim2.new(0, 0, 0, 70)
	tween4:Play()
	task.wait(0.1)
	uiStroke.Thickness = 2
	textLabel2.Text = text3
	local flag19 = false

	local function fn4()
		if flag19 then
			return
		end
		flag19 = true
		if not imageButton or not imageButton.Parent then
			return
		end
		textLabel.Text = ""
		textLabel2.Text = ""
		local uiStroke2 = imageButton:FindFirstChildOfClass("UIStroke")

		if uiStroke2 then
			uiStroke2:Destroy()
		end

		local tween5 = v6:Create(imageButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, imageButton.Size.Y.Offset) })
		tween5:Play()

		tween5.Completed:Connect(function()
			if not imageButton.Parent then
				return
			end
			local tween6 = v6:Create(imageButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
			tween6:Play()

			tween6.Completed:Connect(function()
				if imageButton then
					imageButton:Destroy()
				end

				if v10 == imageButton then
					v10 = nil
				end
			end)
		end)
	end

	imageButton.MouseButton1Click:Connect(fn4)

	task.delay(arg, function()
		if v17 ~= n2 then
			return
		end
		fn4()
	end)
end

for _, v17 in ipairs({
	"writefile",
	"readfile",
	"isfile",
	"delfile",
	"listfiles",
	"makefolder",
	"isfolder",
	"delfolder",
	"getcustomasset",
}) do
	if type(_G[v17] or getgenv()[v17]) ~= "function" then
		fn3(Traducao.Erro, Traducao.Imcompativel, 15)
		Carregar()
		getgenv().YMP = false
		return
	end
end

if not requestAsync then
	fn3(Traducao.Erro, Traducao.Imcompativel, 15)
	Carregar()
	getgenv().YMP = false
	return
end

if not isfolder("YouTube Music Player") then
	makefolder("YouTube Music Player")
end

if not isfolder("YouTube Music Player/Musics") then
	makefolder("YouTube Music Player/Musics")
end

if not isfolder("YouTube Music Player/Videos") then
	makefolder("YouTube Music Player/Videos")
end

if not isfolder("YouTube Music Player/Roblox IDS") then
	makefolder("YouTube Music Player/Roblox IDS")
end

if not isfolder("YouTube Music Player/Local Audios") then
	makefolder("YouTube Music Player/Local Audios")
end

if not isfolder("YouTube Music Player/Internal") then
	makefolder("YouTube Music Player/Internal")
end

if not isfolder("YouTube Music Player/Internal/Cache") then
	makefolder("YouTube Music Player/Internal/Cache")
end

if isfolder("YouTube Music Player/Cache") then
	delfolder("YouTube Music Player/Cache")
end

if not isfile("YouTube Music Player/Internal/Data.json") then
	writefile("YouTube Music Player/Internal/Data.json", "[{\"Key\":\"\",\"Favorites\":[]}]")
end

if not isfile("YouTube Music Player/[ IMPORTANT ] README.txt") then
	writefile("YouTube Music Player/[ IMPORTANT ] README.txt", [[[ YouTube Music Player ]

This script was developed by @Termux_404
I am deeply grateful for using my script! :D

[>] If you want to add audio files without downloading them using the script's search and download engine, place the MP3 file in the folder "Local Audios"
Make sure the file is not corrupted or too large, otherwise the audio will not play.

[ Social media ]

Discord server: https://discord.gg/kbh2dEdnYP

YouTube channel: https://youtube.com/@termux_404

Scriptblox: https://scriptblox.com/u/Termux_404

Have a good game and enjoy!]])
end

if not isfile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt") then
	writefile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt", [[[YouTube Music Player Cache]

This folder is used to temporarily store images to help things load faster.

All files here will be cleared the first time you execute the script.

You can ignore everything here without any problem! :D]])
end

if isfile("YouTube Music Player/[YMP] README.txt") then
	delfile("YouTube Music Player/[YMP] README.txt")
end

for _, v17 in ipairs(listfiles("YouTube Music Player/Internal/Cache")) do
	if not string.find(v17, "ABOUT CACHE.txt") then
		delfile(v17)
	end
end

if isfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3") then
	delfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3")
end

pcall(function()
	if not isfile("YouTube Music Player/Musics/LvvrO6JifEA.mp3") then
		writefile("YouTube Music Player/Musics/LvvrO6JifEA.mp3", game:HttpGet("https://github.com/Dan41/Roblox-Scripts/raw/refs/heads/main/Youtube%20Music%20Player/Welcome.mp3"))
	end
end)

Corner = function(parent, arg, arg2)
	local uiCorner = Instance.new("UICorner")

	if arg2 == nil then
		uiCorner.CornerRadius = UDim.new(0, arg)
	else
		uiCorner.CornerRadius = UDim.new(arg, arg2)
	end

	uiCorner.Parent = parent
end

Stroke = function(parent, arg, arg2, arg3, thickness, transparency)
	local uiStroke = parent:FindFirstChildOfClass("UIStroke")

	if not uiStroke then
		uiStroke = Instance.new("UIStroke")
		uiStroke.Parent = parent
	end

	uiStroke.Color = Color3.fromRGB(arg, arg2, arg3)
	uiStroke.Thickness = thickness

	if transparency ~= nil then
		uiStroke.Transparency = transparency
	end
end

Draggable = function(arg, arg2)
	if not arg or not arg:IsA("GuiObject") then
		return
	end
	local flag19 = false
	local v17 = nil
	local position = nil
	local position2 = nil
	local n4 = 2
	arg:SetAttribute("Blocked", false)
	arg:SetAttribute("Moved", false)

	local function fn4(arg3)
		local n5 = arg3.Position - position

		if not arg:GetAttribute("Moved") and n5.Magnitude > n4 then
			arg:SetAttribute("Moved", true)
		end

		local n6 = position2.X.Offset + n5.X
		local n7 = position2.Y.Offset + n5.Y

		if arg2 then
			local screenGui3 = arg:FindFirstAncestorWhichIsA("ScreenGui")

			if screenGui3 then
				local absoluteSize = screenGui3.AbsoluteSize
				local absoluteSize2 = arg.AbsoluteSize
				local anchorPoint = arg.AnchorPoint
				local uiStroke = arg:FindFirstChildWhichIsA("UIStroke")
				local enabled = uiStroke and uiStroke.Enabled
				local n8 = 0

				if enabled then
					n8 = uiStroke.Thickness
				end

				local n9 = -position2.Y.Scale * absoluteSize.Y + anchorPoint.Y * absoluteSize2.Y + n8
				local n10 = (1 - position2.Y.Scale) * absoluteSize.Y - (1 - anchorPoint.Y) * absoluteSize2.Y - n8
				n6 = math.clamp(n6, -position2.X.Scale * absoluteSize.X + anchorPoint.X * absoluteSize2.X + n8, (1 - position2.X.Scale) * absoluteSize.X - (1 - anchorPoint.X) * absoluteSize2.X - n8)
				n7 = math.clamp(n7, n9, n10)
			end
		end

		arg.Position = UDim2.new(position2.X.Scale, n6, position2.Y.Scale, n7)
	end

	arg.InputBegan:Connect(function(input)
		if flag19 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag19 = true
			v17 = input
			position = input.Position
			position2 = arg.Position
			arg:SetAttribute("Blocked", true)
			arg:SetAttribute("Moved", false)
			local connection = nil

			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag19 = false
					v17 = nil
					arg:SetAttribute("Blocked", false)
					connection:Disconnect()
				end
			end)
		end
	end)

	arg.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if not v17 then
				v17 = input
			end
		end
	end)

	v9.InputChanged:Connect(function(input)
		if flag19 and input == v17 then
			fn4(input)
		end
	end)
end

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0, 587, 0, 300)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Visible = false
frame.Parent = screenGui
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 50, 0, 50)
imageButton.AnchorPoint = Vector2.new(0.5, 0)
imageButton.Position = UDim2.new(0.5, 0, 0, 20)
imageButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
imageButton.Image = "rbxassetid://83758613781843"
imageButton.Visible = false
imageButton.Parent = screenGui
ContadorJA = Instance.new("Frame")
ContadorJA.Size = UDim2.new(0, 17, 0, 17)
ContadorJA.Position = UDim2.new(0, 36, 0, -3)
ContadorJA.BackgroundColor3 = Color3.fromRGB(250, 92, 92)
ContadorJA.Visible = false
ContadorJA.Parent = imageButton
ContadorJANU = Instance.new("TextLabel")
ContadorJANU.Size = UDim2.new(0, 15, 0, 15)
ContadorJANU.Position = UDim2.new(0, 1, 0, 1)
ContadorJANU.BackgroundTransparency = 1
ContadorJANU.Text = "0"
ContadorJANU.TextColor3 = Color3.fromRGB(0, 0, 0)
ContadorJANU.TextScaled = true
ContadorJANU.Parent = ContadorJA
Draggable(imageButton, true)
Draggable(frame)
Mutar = Instance.new("ImageButton")
Mutar.Size = UDim2.new(0, 30, 0, 30)
Mutar.Position = UDim2.new(0, 6, 0, 6)
Mutar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Mutar.Image = "rbxassetid://109518972658686"
Mutar.Parent = frame
BotaoFechar = Instance.new("ImageButton")
BotaoFechar.Size = UDim2.new(0, 30, 0, 30)
BotaoFechar.Position = UDim2.new(1, -36, 0, 6)
BotaoFechar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
BotaoFechar.Parent = frame
X = Instance.new("ImageLabel")
X.AnchorPoint = Vector2.new(0.5, 0.5)
X.Size = UDim2.new(0, 17, 0, 17)
X.Position = UDim2.new(0.5, 0, 0.5, 0)
X.BackgroundTransparency = 1
X.Image = "rbxassetid://119026663645791"
X.Parent = BotaoFechar
Titulo = Instance.new("Frame")
Titulo.Size = UDim2.new(0, 488, 0, 30)
Titulo.Position = UDim2.new(0, 50, 0, 6)
Titulo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Titulo.Parent = frame
TextoTitulo = Instance.new("TextLabel")
TextoTitulo.Size = UDim2.new(1, 0, 1, -4)
TextoTitulo.Position = UDim2.new(0, 0, 0, 2)
TextoTitulo.BackgroundTransparency = 1
TextoTitulo.Text = "YouTube Music Player V8.5"
TextoTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTitulo.TextScaled = true
TextoTitulo.Font = Enum.Font.Highway
TextoTitulo.Parent = Titulo
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Linha.BorderSizePixel = 0
Linha.Parent = frame
Navegacao = Instance.new("Frame")
Navegacao.Size = UDim2.new(0, 160, 1, -61)
Navegacao.Position = UDim2.new(0, 7, 0, 54)
Navegacao.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Navegacao.BorderSizePixel = 0
Navegacao.Visible = true
Navegacao.ClipsDescendants = true
Navegacao.Parent = frame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Navegacao
TituloNave = Instance.new("Frame")
TituloNave.Size = UDim2.new(0, 150, 0, 32)
TituloNave.Position = UDim2.new(0, 5, 0, 5)
TituloNave.BackgroundColor3 = Color3.fromRGB(185, 34, 34)
TituloNave.Parent = Navegacao
FotoNave = Instance.new("ImageLabel")
FotoNave.Size = UDim2.new(0, 32, 0, 32)
FotoNave.Position = UDim2.new(0, 0, 0, 0)
FotoNave.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoNave.BackgroundTransparency = 0.5
FotoNave.Image = "rbxassetid://123533799129853"
FotoNave.Parent = TituloNave
NomeNave = Instance.new("TextLabel")
NomeNave.Size = UDim2.new(0, 102, 1, 0)
NomeNave.Position = UDim2.new(0, 37, 0, 0)
NomeNave.BackgroundTransparency = 1
NomeNave.Text = Traducao.Navegacao
NomeNave.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeNave.Font = Enum.Font.SourceSansBold
NomeNave.TextScaled = true
NomeNave.Parent = TituloNave
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 193)
BaseSF.Position = UDim2.new(0, 1, 0, 45)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Navegacao
ScrollNave = Instance.new("ScrollingFrame")
ScrollNave.Size = UDim2.new(1, 0, 1, 0)
ScrollNave.Position = UDim2.new(0, 0, 0, 0)
ScrollNave.BackgroundTransparency = 1
ScrollNave.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollNave.ScrollBarImageTransparency = 0.5
ScrollNave.BorderSizePixel = 0
ScrollNave.ScrollBarThickness = 1
ScrollNave.CanvasSize = UDim2.new(0, 0, 0, 271)
ScrollNave.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollNave.ClipsDescendants = false
ScrollNave.Parent = BaseSF
Botao1 = Instance.new("ImageButton")
Botao1.Name = "Botao1"
Botao1.Size = UDim2.new(0, 148, 0, 35)
Botao1.Position = UDim2.new(0, 5, 0, 5)
Botao1.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
Botao1.AutoButtonColor = false
Botao1.Parent = ScrollNave
Botao2 = Instance.new("ImageButton")
Botao2.Name = "Botao2"
Botao2.Size = UDim2.new(0, 148, 0, 35)
Botao2.Position = UDim2.new(0, 5, 0, 50)
Botao2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao2.AutoButtonColor = false
Botao2.Parent = ScrollNave
Botao3 = Instance.new("ImageButton")
Botao3.Name = "Botao3"
Botao3.Size = UDim2.new(0, 148, 0, 35)
Botao3.Position = UDim2.new(0, 5, 0, 95)
Botao3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao3.AutoButtonColor = false
Botao3.Parent = ScrollNave
Botao4 = Instance.new("ImageButton")
Botao4.Name = "Botao4"
Botao4.Size = UDim2.new(0, 148, 0, 35)
Botao4.Position = UDim2.new(0, 5, 0, 140)
Botao4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao4.AutoButtonColor = false
Botao4.Parent = ScrollNave
Botao5 = Instance.new("ImageButton")
Botao5.Name = "Botao5"
Botao5.Size = UDim2.new(0, 148, 0, 35)
Botao5.Position = UDim2.new(0, 5, 0, 185)
Botao5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao5.BackgroundTransparency = 0.9
Botao5.AutoButtonColor = false
Botao5.Parent = ScrollNave
Botao6 = Instance.new("ImageButton")
Botao6.Name = "Botao6"
Botao6.Size = UDim2.new(0, 148, 0, 35)
Botao6.Position = UDim2.new(0, 5, 0, 230)
Botao6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao6.AutoButtonColor = false
Botao6.Parent = ScrollNave
Icone1 = Instance.new("ImageLabel")
Icone1.Size = UDim2.new(0, 35, 0, 35)
Icone1.Position = UDim2.new(0, 0, 0, 0)
Icone1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone1.Image = "rbxassetid://107770126918811"
Icone1.Parent = Botao1
Icone2 = Instance.new("ImageLabel")
Icone2.Size = UDim2.new(0, 35, 0, 35)
Icone2.Position = UDim2.new(0, 0, 0, 0)
Icone2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone2.Image = "rbxassetid://79505391139157"
Icone2.Parent = Botao2
Icone3 = Instance.new("ImageLabel")
Icone3.Size = UDim2.new(0, 35, 0, 35)
Icone3.Position = UDim2.new(0, 0, 0, 0)
Icone3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone3.Image = "rbxassetid://116645068635461"
Icone3.Parent = Botao3
Icone4 = Instance.new("ImageLabel")
Icone4.Size = UDim2.new(0, 35, 0, 35)
Icone4.Position = UDim2.new(0, 0, 0, 0)
Icone4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone4.Image = "rbxassetid://71048917954785"
Icone4.Parent = Botao4
Icone5 = Instance.new("ImageLabel")
Icone5.Size = UDim2.new(0, 35, 0, 35)
Icone5.Position = UDim2.new(0, 0, 0, 0)
Icone5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone5.BackgroundTransparency = 0.9
Icone5.Image = "rbxassetid://140320771062475"
Icone5.ImageTransparency = 0.9
Icone5.Parent = Botao5
Icone6 = Instance.new("ImageLabel")
Icone6.Size = UDim2.new(0, 35, 0, 35)
Icone6.Position = UDim2.new(0, 0, 0, 0)
Icone6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone6.Image = "rbxassetid://75536888881661"
Icone6.Parent = Botao6
Nome1 = Instance.new("TextLabel")
Nome1.Size = UDim2.new(0, 103, 1, 0)
Nome1.Position = UDim2.new(0, 41, 0, 0)
Nome1.BackgroundTransparency = 1
Nome1.Text = "Home"
Nome1.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome1.Font = Enum.Font.SourceSansBold
Nome1.TextScaled = true
Nome1.Parent = Botao1
Nome2 = Instance.new("TextLabel")
Nome2.Size = UDim2.new(0, 103, 1, 0)
Nome2.Position = UDim2.new(0, 41, 0, 0)
Nome2.BackgroundTransparency = 1
Nome2.Text = Traducao.Player
Nome2.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome2.Font = Enum.Font.SourceSansBold
Nome2.TextScaled = true
Nome2.Parent = Botao2
Nome3 = Instance.new("TextLabel")
Nome3.Size = UDim2.new(0, 103, 1, 0)
Nome3.Position = UDim2.new(0, 41, 0, 0)
Nome3.BackgroundTransparency = 1
Nome3.Text = Traducao.Equalizador
Nome3.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome3.Font = Enum.Font.SourceSansBold
Nome3.TextScaled = true
Nome3.Parent = Botao3
Nome4 = Instance.new("TextLabel")
Nome4.Size = UDim2.new(0, 103, 1, 0)
Nome4.Position = UDim2.new(0, 41, 0, 0)
Nome4.BackgroundTransparency = 1
Nome4.Text = Traducao.Add
Nome4.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome4.Font = Enum.Font.SourceSansBold
Nome4.TextScaled = true
Nome4.Parent = Botao4
Nome5 = Instance.new("TextLabel")
Nome5.Size = UDim2.new(0, 103, 1, 0)
Nome5.Position = UDim2.new(0, 41, 0, 0)
Nome5.BackgroundTransparency = 1
Nome5.Text = "Global Chat"
Nome5.TextColor3 = Color3.fromRGB(20, 20, 20)
Nome5.Font = Enum.Font.SourceSansBold
Nome5.TextScaled = true
Nome5.Parent = Botao5
Nome6 = Instance.new("TextLabel")
Nome6.Size = UDim2.new(0, 103, 1, 0)
Nome6.Position = UDim2.new(0, 41, 0, 0)
Nome6.BackgroundTransparency = 1
Nome6.Text = "Premium"
Nome6.TextColor3 = Color3.fromRGB(255, 255, 153)
Nome6.Font = Enum.Font.SourceSansBold
Nome6.TextScaled = true
Nome6.Parent = Botao6
ContadorJABO = Instance.new("Frame")
ContadorJABO.Size = UDim2.new(0, 15, 0, 15)
ContadorJABO.Position = UDim2.new(0, 0, 0, -3)
ContadorJABO.BackgroundColor3 = Color3.fromRGB(250, 92, 92)
ContadorJABO.Visible = false
ContadorJABO.Parent = Icone5
ContadorJANUBO = Instance.new("TextLabel")
ContadorJANUBO.Size = UDim2.new(0, 15, 0, 15)
ContadorJANUBO.Position = UDim2.new(0, 0, 0, 0)
ContadorJANUBO.BackgroundTransparency = 1
ContadorJANUBO.Text = "0"
ContadorJANUBO.TextColor3 = Color3.fromRGB(0, 0, 0)
ContadorJANUBO.TextScaled = true
ContadorJANUBO.Parent = ContadorJABO
Playlist = Instance.new("Frame")
Playlist.Size = UDim2.new(0, 160, 1, -61)
Playlist.Position = UDim2.new(0, 420, 0, 54)
Playlist.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Playlist.BorderSizePixel = 0
Playlist.Parent = frame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Playlist
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 195)
Linha2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha2.BorderSizePixel = 0
Linha2.Parent = Playlist
TituloPlayL = Instance.new("Frame")
TituloPlayL.Size = UDim2.new(0, 150, 0, 32)
TituloPlayL.Position = UDim2.new(0, 5, 0, 5)
TituloPlayL.BackgroundColor3 = Color3.fromRGB(185, 34, 34)
TituloPlayL.Parent = Playlist
FotoPlayL = Instance.new("ImageLabel")
FotoPlayL.Size = UDim2.new(0, 32, 0, 32)
FotoPlayL.Position = UDim2.new(0, 0, 0, 0)
FotoPlayL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoPlayL.BackgroundTransparency = 0.5
FotoPlayL.Image = "rbxassetid://96966806844504"
FotoPlayL.Parent = TituloPlayL
NomePlayL = Instance.new("TextLabel")
NomePlayL.Size = UDim2.new(0, 102, 1, 0)
NomePlayL.Position = UDim2.new(0, 37, 0, 0)
NomePlayL.BackgroundTransparency = 1
NomePlayL.Text = "Playlist"
NomePlayL.TextColor3 = Color3.fromRGB(255, 0, 0)
NomePlayL.Font = Enum.Font.SourceSansBold
NomePlayL.TextScaled = true
NomePlayL.Parent = TituloPlayL
EsquerdaPL = Instance.new("ImageButton")
EsquerdaPL.Size = UDim2.new(0, 32, 0, 32)
EsquerdaPL.Position = UDim2.new(0, 6, 0, 202)
EsquerdaPL.BackgroundColor3 = Color3.fromRGB(237, 76, 66)
EsquerdaPL.Image = "rbxassetid://121046797518772"
EsquerdaPL.Parent = Playlist
DireitaPL = Instance.new("ImageButton")
DireitaPL.Size = UDim2.new(0, 32, 0, 32)
DireitaPL.Position = UDim2.new(0, 122, 0, 202)
DireitaPL.BackgroundColor3 = Color3.fromRGB(237, 76, 66)
DireitaPL.Image = "rbxassetid://132437763424488"
DireitaPL.Parent = Playlist
Vazio = Instance.new("ImageLabel")
Vazio.Size = UDim2.new(0, 70, 0, 70)
Vazio.Position = UDim2.new(0, 45, 0, 63)
Vazio.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Vazio.BackgroundTransparency = 1
Vazio.Image = "rbxassetid://123712679435265"
Vazio.Visible = false
Vazio.Parent = Playlist
VazioLocal = Instance.new("ImageLabel")
VazioLocal.Size = UDim2.new(0, 70, 0, 70)
VazioLocal.Position = UDim2.new(0, 45, 0, 63)
VazioLocal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VazioLocal.BackgroundTransparency = 1
VazioLocal.Image = "rbxassetid://103453753684654"
VazioLocal.Visible = false
VazioLocal.Parent = Playlist
AguardandoPL = Instance.new("ImageLabel")
AguardandoPL.Size = UDim2.new(0, 70, 0, 70)
AguardandoPL.Position = UDim2.new(0, 45, 0, 63)
AguardandoPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AguardandoPL.BackgroundTransparency = 1
AguardandoPL.Image = "rbxassetid://128559285276409"
AguardandoPL.Visible = false
AguardandoPL.Parent = Playlist
SemResultadoPL = Instance.new("ImageLabel")
SemResultadoPL.Size = UDim2.new(0, 70, 0, 70)
SemResultadoPL.Position = UDim2.new(0, 45, 0, 63)
SemResultadoPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SemResultadoPL.BackgroundTransparency = 1
SemResultadoPL.Image = "rbxassetid://109542040841239"
SemResultadoPL.Visible = false
SemResultadoPL.Parent = Playlist
ErroPL = Instance.new("TextLabel")
ErroPL.Size = UDim2.new(0, 150, 0, 42)
ErroPL.Position = UDim2.new(0, 5, 0, 149)
ErroPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ErroPL.BackgroundTransparency = 0.5
ErroPL.RichText = true
ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
ErroPL.Font = Enum.Font.SourceSansBold
ErroPL.TextScaled = true
ErroPL.Visible = false
ErroPL.Parent = Playlist
FrameAbaPL = Instance.new("Frame")
FrameAbaPL.Size = UDim2.new(0, 70, 0, 32)
FrameAbaPL.Position = UDim2.new(0, 45, 0, 202)
FrameAbaPL.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FrameAbaPL.BackgroundTransparency = 0.5
FrameAbaPL.Parent = Playlist
AbaPL = Instance.new("TextLabel")
AbaPL.Size = UDim2.new(1, -6, 1, -6)
AbaPL.Position = UDim2.new(0, 3, 0, 3)
AbaPL.BackgroundTransparency = 1
AbaPL.Text = Traducao.Todos
AbaPL.TextColor3 = Color3.fromRGB(255, 0, 0)
AbaPL.Font = Enum.Font.SourceSansBold
AbaPL.TextScaled = true
AbaPL.Visible = true
AbaPL.Parent = FrameAbaPL
PesquisaPL = Instance.new("TextBox")
PesquisaPL.Size = UDim2.new(1, -6, 1, -6)
PesquisaPL.Position = UDim2.new(0, 3, 0, 3)
PesquisaPL.BackgroundTransparency = 1
PesquisaPL.Text = ""
PesquisaPL.PlaceholderText = Traducao.Search
PesquisaPL.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisaPL.Font = Enum.Font.SourceSansBold
PesquisaPL.TextScaled = true
PesquisaPL.TextWrapped = true
PesquisaPL.Visible = false
PesquisaPL.Parent = FrameAbaPL
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 149)
BaseSF.Position = UDim2.new(0, 1, 0, 45)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Playlist
ScrollTodos = Instance.new("ScrollingFrame")
ScrollTodos.Name = "ScrollTodos"
ScrollTodos.Size = UDim2.new(1, 0, 1, 0)
ScrollTodos.Position = UDim2.new(0, 0, 0, 0)
ScrollTodos.BackgroundTransparency = 1
ScrollTodos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollTodos.ScrollBarImageTransparency = 0.5
ScrollTodos.BorderSizePixel = 0
ScrollTodos.ScrollBarThickness = 1
ScrollTodos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollTodos.CanvasPosition = Vector2.new(0, 0)
ScrollTodos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollTodos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollTodos.Visible = true
ScrollTodos.Parent = BaseSF
ScrollMusicas = Instance.new("ScrollingFrame")
ScrollMusicas.Name = "ScrollMusicas"
ScrollMusicas.Size = UDim2.new(1, 0, 1, 0)
ScrollMusicas.Position = UDim2.new(0, 0, 0, 0)
ScrollMusicas.BackgroundTransparency = 1
ScrollMusicas.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollMusicas.ScrollBarImageTransparency = 0.5
ScrollMusicas.BorderSizePixel = 0
ScrollMusicas.ScrollBarThickness = 1
ScrollMusicas.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollMusicas.CanvasPosition = Vector2.new(0, 0)
ScrollMusicas.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollMusicas.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollMusicas.Visible = false
ScrollMusicas.Parent = BaseSF
ScrollVideos = Instance.new("ScrollingFrame")
ScrollVideos.Name = "ScrollVideos"
ScrollVideos.Size = UDim2.new(1, 0, 1, 0)
ScrollVideos.Position = UDim2.new(0, 0, 0, 0)
ScrollVideos.BackgroundTransparency = 1
ScrollVideos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollVideos.ScrollBarImageTransparency = 0.5
ScrollVideos.BorderSizePixel = 0
ScrollVideos.ScrollBarThickness = 1
ScrollVideos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollVideos.CanvasPosition = Vector2.new(0, 0)
ScrollVideos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollVideos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollVideos.Visible = false
ScrollVideos.Parent = BaseSF
ScrollRoblox = Instance.new("ScrollingFrame")
ScrollRoblox.Name = "ScrollRoblox"
ScrollRoblox.Size = UDim2.new(1, 0, 1, 0)
ScrollRoblox.Position = UDim2.new(0, 0, 0, 0)
ScrollRoblox.BackgroundTransparency = 1
ScrollRoblox.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollRoblox.ScrollBarImageTransparency = 0.5
ScrollRoblox.BorderSizePixel = 0
ScrollRoblox.ScrollBarThickness = 1
ScrollRoblox.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollRoblox.CanvasPosition = Vector2.new(0, 0)
ScrollRoblox.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollRoblox.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollRoblox.Visible = false
ScrollRoblox.Parent = BaseSF
ScrollFav = Instance.new("ScrollingFrame")
ScrollFav.Name = "ScrollFav"
ScrollFav.Size = UDim2.new(1, 0, 1, 0)
ScrollFav.Position = UDim2.new(0, 0, 0, 0)
ScrollFav.BackgroundTransparency = 1
ScrollFav.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFav.ScrollBarImageTransparency = 0.5
ScrollFav.BorderSizePixel = 0
ScrollFav.ScrollBarThickness = 1
ScrollFav.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollFav.CanvasPosition = Vector2.new(0, 0)
ScrollFav.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollFav.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollFav.Visible = false
ScrollFav.Parent = BaseSF
ScrollLocal = Instance.new("ScrollingFrame")
ScrollLocal.Name = "ScrollLocal"
ScrollLocal.Size = UDim2.new(1, 0, 1, 0)
ScrollLocal.Position = UDim2.new(0, 0, 0, 0)
ScrollLocal.BackgroundTransparency = 1
ScrollLocal.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollLocal.ScrollBarImageTransparency = 0.5
ScrollLocal.BorderSizePixel = 0
ScrollLocal.ScrollBarThickness = 1
ScrollLocal.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollLocal.CanvasPosition = Vector2.new(0, 0)
ScrollLocal.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollLocal.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollLocal.Visible = false
ScrollLocal.Parent = BaseSF
ScrollPesquisa = Instance.new("ScrollingFrame")
ScrollPesquisa.Name = "ScrollPesquisa"
ScrollPesquisa.Size = UDim2.new(1, 0, 1, 0)
ScrollPesquisa.Position = UDim2.new(0, 0, 0, 0)
ScrollPesquisa.BackgroundTransparency = 1
ScrollPesquisa.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPesquisa.ScrollBarImageTransparency = 0.5
ScrollPesquisa.BorderSizePixel = 0
ScrollPesquisa.ScrollBarThickness = 1
ScrollPesquisa.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
ScrollPesquisa.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollPesquisa.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollPesquisa.Visible = false
ScrollPesquisa.Parent = BaseSF
Tela1 = Instance.new("Frame")
Tela1.Size = UDim2.new(0, 247, 0, 251)
Tela1.Position = UDim2.new(0, 170, 0, 48)
Tela1.BackgroundTransparency = 1
Tela1.BorderSizePixel = 0
Tela1.Visible = true
Tela1.Parent = frame
Tela2 = Instance.new("Frame")
Tela2.Size = UDim2.new(0, 247, 0, 251)
Tela2.Position = UDim2.new(0, 170, 0, 48)
Tela2.BackgroundTransparency = 1
Tela2.BorderSizePixel = 0
Tela2.Visible = false
Tela2.Parent = frame
Tela3 = Instance.new("Frame")
Tela3.Size = UDim2.new(0, 247, 0, 251)
Tela3.Position = UDim2.new(0, 170, 0, 48)
Tela3.BackgroundTransparency = 1
Tela3.BorderSizePixel = 0
Tela3.Visible = false
Tela3.Parent = frame
Tela4 = Instance.new("Frame")
Tela4.Size = UDim2.new(0, 247, 0, 251)
Tela4.Position = UDim2.new(0, 170, 0, 48)
Tela4.BackgroundTransparency = 1
Tela4.BorderSizePixel = 0
Tela4.Visible = false
Tela4.Parent = frame
Tela5 = Instance.new("Frame")
Tela5.Size = UDim2.new(0, 247, 0, 251)
Tela5.Position = UDim2.new(0, 170, 0, 48)
Tela5.BackgroundTransparency = 1
Tela5.BorderSizePixel = 0
Tela5.Visible = false
Tela5.Parent = frame
Tela6 = Instance.new("Frame")
Tela6.Size = UDim2.new(0, 247, 0, 251)
Tela6.Position = UDim2.new(0, 170, 0, 48)
Tela6.BackgroundTransparency = 1
Tela6.BorderSizePixel = 0
Tela6.Visible = false
Tela6.Parent = frame
Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0, 235, 0, 43)
Welcome.Position = UDim2.new(0, 6, 0, 6)
Welcome.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Welcome.BorderSizePixel = 0
Welcome.Parent = Tela1
NomeWelcome = Instance.new("TextLabel")
NomeWelcome.Size = UDim2.new(1, 0, 1, 0)
NomeWelcome.Position = UDim2.new(0, 0, 0, 0)
NomeWelcome.BackgroundTransparency = 1
NomeWelcome.Text = Traducao.Welcome
NomeWelcome.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeWelcome.Font = Enum.Font.SourceSansBold
NomeWelcome.TextScaled = true
NomeWelcome.Parent = Welcome
Dev = Instance.new("Frame")
Dev.Size = UDim2.new(0, 235, 0, 61)
Dev.Position = UDim2.new(0, 6, 0, 58)
Dev.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Dev.BorderSizePixel = 0
Dev.Parent = Tela1
FotoDev = Instance.new("ImageLabel")
FotoDev.Size = UDim2.new(0, 47, 0, 46)
FotoDev.Position = UDim2.new(0, 7, 0, 8)
FotoDev.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoDev.BackgroundTransparency = 0.5
FotoDev.Image = "rbxassetid://86887253295141"
FotoDev.Parent = Dev
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 62, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Dev
TextoDev = Instance.new("TextLabel")
TextoDev.Size = UDim2.new(1, -70, 1, 0)
TextoDev.Position = UDim2.new(0, 66, 0, 0)
TextoDev.BackgroundTransparency = 1
TextoDev.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoDev.Font = Enum.Font.SourceSansBold
TextoDev.TextScaled = true
TextoDev.RichText = true
TextoDev.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Dev .. "</font>\n<font color=\"rgb(178,34,34)\">Termux_404</font>"
TextoDev.Parent = Dev
Social = Instance.new("Frame")
Social.Size = UDim2.new(0, 235, 0, 117)
Social.Position = UDim2.new(0, 6, 0, 128)
Social.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Social.BorderSizePixel = 0
Social.Parent = Tela1
SocialTitulo = Instance.new("Frame")
SocialTitulo.Size = UDim2.new(1, 0, 0, 30)
SocialTitulo.Position = UDim2.new(0, 0, 0, 0)
SocialTitulo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
SocialTitulo.BorderSizePixel = 0
SocialTitulo.Parent = Social
SocialTexto = Instance.new("TextLabel")
SocialTexto.Size = UDim2.new(1, 0, 1, 0)
SocialTexto.Position = UDim2.new(0, 0, 0, 0)
SocialTexto.BackgroundTransparency = 1
SocialTexto.Text = "Social"
SocialTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
SocialTexto.Font = Enum.Font.SourceSansBold
SocialTexto.TextScaled = true
SocialTexto.Parent = SocialTitulo
Discord = Instance.new("ImageButton")
Discord.Size = UDim2.new(0, 223, 0, 32)
Discord.Position = UDim2.new(0, 6, 0, 40)
Discord.BackgroundColor3 = Color3.fromRGB(143, 42, 234)
Discord.Parent = Social
UIScaleDis = Instance.new("UIScale")
UIScaleDis.Parent = Discord
IconeDiscord = Instance.new("ImageLabel")
IconeDiscord.Size = UDim2.new(0, 32, 0, 32)
IconeDiscord.Position = UDim2.new(0, 0, 0, 0)
IconeDiscord.BackgroundColor3 = Color3.fromRGB(40, 100, 240)
IconeDiscord.Image = "rbxassetid://90602349315916"
IconeDiscord.Parent = Discord
TextoDiscord = Instance.new("TextLabel")
TextoDiscord.Size = UDim2.new(1, -50, 1, 0)
TextoDiscord.Position = UDim2.new(0, 39, 0, 0)
TextoDiscord.BackgroundTransparency = 1
TextoDiscord.Text = "Discord"
TextoDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoDiscord.Font = Enum.Font.Garamond
TextoDiscord.TextScaled = true
TextoDiscord.Parent = Discord
You = Instance.new("ImageButton")
You.Size = UDim2.new(0, 223, 0, 32)
You.Position = UDim2.new(0, 6, 0, 79)
You.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
You.Parent = Social
UIScaleYou = Instance.new("UIScale")
UIScaleYou.Parent = You
IconeYou = Instance.new("ImageLabel")
IconeYou.Size = UDim2.new(0, 32, 0, 32)
IconeYou.Position = UDim2.new(0, 0, 0, 0)
IconeYou.BackgroundColor3 = Color3.fromRGB(40, 100, 240)
IconeYou.Image = "rbxassetid://111196037573101"
IconeYou.Parent = You
TextoYou = Instance.new("TextLabel")
TextoYou.Size = UDim2.new(1, -50, 1, 0)
TextoYou.Position = UDim2.new(0, 39, 0, 0)
TextoYou.BackgroundTransparency = 1
TextoYou.Text = "YouTube"
TextoYou.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoYou.Font = Enum.Font.Garamond
TextoYou.TextScaled = true
TextoYou.Parent = You
Musica = Instance.new("ImageLabel")
Musica.Size = UDim2.new(0, 235, 0, 120)
Musica.Position = UDim2.new(0, 6, 0, 6)
Musica.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Musica.BorderSizePixel = 0
Musica.Visible = true
Musica.ImageRectOffset = Vector2.new(0, 0)
Musica.ImageRectSize = Vector2.new(0, 0)
Musica.Image = "rbxassetid://120329190202259"
Musica.Parent = Tela2
Video = Instance.new("VideoFrame")
Video.Size = UDim2.new(0, 235, 0, 120)
Video.Position = UDim2.new(0, 6, 0, 6)
Video.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Video.BorderSizePixel = 0
Video.Visible = false
Video.Video = ""
Video.Volume = 1
Video.Looped = false
Video.Parent = nil
BotaoTela = Instance.new("ImageButton")
BotaoTela.Size = UDim2.new(0, 235, 0, 120)
BotaoTela.Position = UDim2.new(0, 6, 0, 6)
BotaoTela.BackgroundTransparency = 1
BotaoTela.ClipsDescendants = true
BotaoTela.Visible = true
BotaoTela.ZIndex = 2
BotaoTela.Parent = Tela2
TempoAtual = Instance.new("Frame")
TempoAtual.Size = UDim2.new(0, 55, 0, 20)
TempoAtual.Position = UDim2.new(0, 6, 0, 6)
TempoAtual.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TempoAtual.BackgroundTransparency = 0.5
TempoAtual.ZIndex = 2
TempoAtual.Parent = BotaoTela
TempoTotal = Instance.new("Frame")
TempoTotal.Size = UDim2.new(0, 55, 0, 20)
TempoTotal.Position = UDim2.new(0, 174, 0, 6)
TempoTotal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TempoTotal.BackgroundTransparency = 0.5
TempoTotal.ZIndex = 2
TempoTotal.Parent = BotaoTela
TimerAtual = Instance.new("TextLabel")
TimerAtual.Size = UDim2.new(1, 0, 1, 0)
TimerAtual.Position = UDim2.new(0, 0, 0, 0)
TimerAtual.BackgroundTransparency = 1
TimerAtual.Text = "00:00"
TimerAtual.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerAtual.TextScaled = true
TimerAtual.Font = Enum.Font.SourceSansBold
TimerAtual.ZIndex = 2
TimerAtual.Parent = TempoAtual
TimerTotal = Instance.new("TextLabel")
TimerTotal.Size = UDim2.new(1, 0, 1, 0)
TimerTotal.Position = UDim2.new(0, 0, 0, 0)
TimerTotal.BackgroundTransparency = 1
TimerTotal.Text = "00:00"
TimerTotal.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerTotal.TextScaled = true
TimerTotal.Font = Enum.Font.SourceSansBold
TimerTotal.ZIndex = 2
TimerTotal.Parent = TempoTotal
Repetir = Instance.new("ImageButton")
Repetir.Size = UDim2.new(0, 30, 0, 30)
Repetir.Position = UDim2.new(0.5, -35, 0.5, -54)
Repetir.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Repetir.BackgroundTransparency = 0.5
Repetir.BorderSizePixel = 0
Repetir.Image = "rbxassetid://72571947341676"
Repetir.ZIndex = 2
Repetir.Parent = BotaoTela
Miniplayer = Instance.new("ImageButton")
Miniplayer.Size = UDim2.new(0, 30, 0, 30)
Miniplayer.Position = UDim2.new(0.5, 5, 0.5, -54)
Miniplayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Miniplayer.BackgroundTransparency = 0.5
Miniplayer.BorderSizePixel = 0
Miniplayer.Image = "rbxassetid://102723588572082"
Miniplayer.ZIndex = 2
Miniplayer.Parent = BotaoTela
BarraProgresso = Instance.new("ImageButton")
BarraProgresso.Size = UDim2.new(0, 223, 0, 10)
BarraProgresso.Position = UDim2.new(0, 6, 0, 103)
BarraProgresso.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BarraProgresso.BorderSizePixel = 0
BarraProgresso.AutoButtonColor = false
BarraProgresso.ZIndex = 2
BarraProgresso.Parent = BotaoTela
Rastro = Instance.new("Frame")
Rastro.Size = UDim2.new(0, 0, 1, 0)
Rastro.Position = UDim2.new(0, 0, 0, 0)
Rastro.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Rastro.BorderSizePixel = 0
Rastro.ZIndex = 2
Rastro.Parent = BarraProgresso
BolaProgresso = Instance.new("ImageButton")
BolaProgresso.Size = UDim2.new(0, 16, 0, 16)
BolaProgresso.Position = UDim2.new(0, 0, 0, -3)
BolaProgresso.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
BolaProgresso.BorderSizePixel = 0
BolaProgresso.AnchorPoint = Vector2.new(0, 0)
BolaProgresso.ZIndex = 2
BolaProgresso.Parent = BarraProgresso
MicroBola = Instance.new("Frame")
MicroBola.Size = UDim2.new(0, 6, 0, 6)
MicroBola.Position = UDim2.new(0, 5, 0, 5)
MicroBola.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MicroBola.BorderSizePixel = 0
MicroBola.ZIndex = 2
MicroBola.Parent = BolaProgresso
PlayerInfo = Instance.new("VideoFrame")
PlayerInfo.Size = UDim2.new(0, 235, 0, 61)
PlayerInfo.Position = UDim2.new(0, 6, 0, 135)
PlayerInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PlayerInfo.BorderSizePixel = 0
PlayerInfo.Parent = Tela2
FotoAutor = Instance.new("ImageLabel")
FotoAutor.Size = UDim2.new(0, 50, 0, 49)
FotoAutor.Position = UDim2.new(0, 6, 0, 6)
FotoAutor.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
FotoAutor.BorderSizePixel = 0
FotoAutor.Visible = true
FotoAutor.Image = "rbxassetid://130243480255582"
FotoAutor.Parent = PlayerInfo
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 63, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = PlayerInfo
Linhah = Instance.new("Frame")
Linhah.Size = UDim2.new(0, 2, 1, 0)
Linhah.Position = UDim2.new(0, 170, 0, 0)
Linhah.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linhah.BorderSizePixel = 0
Linhah.Parent = PlayerInfo
TituloMusica = Instance.new("TextLabel")
TituloMusica.Size = UDim2.new(1, -140, 1, -8)
TituloMusica.Position = UDim2.new(0, 70, 0, 4)
TituloMusica.BackgroundTransparency = 1
TituloMusica.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloMusica.Font = Enum.Font.SourceSansBold
TituloMusica.TextScaled = true
TituloMusica.RichText = true
TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
TituloMusica.Parent = PlayerInfo
Disco = Instance.new("ImageLabel")
Disco.Size = UDim2.new(0, 50, 0, 49)
Disco.Position = UDim2.new(0, 179, 0, 6)
Disco.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Disco.BorderSizePixel = 0
Disco.Visible = true
Disco.Image = "rbxassetid://76801681748723"
Disco.ClipsDescendants = true
Disco.Parent = PlayerInfo
Controles = Instance.new("Frame")
Controles.Size = UDim2.new(0, 235, 0, 40)
Controles.Position = UDim2.new(0, 6, 0, 205)
Controles.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Controles.BorderSizePixel = 0
Controles.Parent = Tela2
Voltar = Instance.new("ImageButton")
Voltar.Size = UDim2.new(0, 30, 0, 30)
Voltar.Position = UDim2.new(0, 10, 0.5, -15)
Voltar.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Voltar.BorderSizePixel = 0
Voltar.Image = "rbxassetid://88757150664292"
Voltar.Parent = Controles
Retroceder = Instance.new("ImageButton")
Retroceder.Size = UDim2.new(0, 30, 0, 30)
Retroceder.Position = UDim2.new(0, 55, 0.5, -15)
Retroceder.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Retroceder.BorderSizePixel = 0
Retroceder.Image = "rbxassetid://122950454234379"
Retroceder.Parent = Controles
Play = Instance.new("ImageButton")
Play.Size = UDim2.new(0, 30, 0, 30)
Play.Position = UDim2.new(0.5, -15, 0.5, -15)
Play.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Play.BorderSizePixel = 0
Play.Image = "rbxassetid://110560238983134"
Play.Parent = Controles
Adiantar = Instance.new("ImageButton")
Adiantar.Size = UDim2.new(0, 30, 0, 30)
Adiantar.Position = UDim2.new(1, -85, 0.5, -15)
Adiantar.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Adiantar.BorderSizePixel = 0
Adiantar.Image = "rbxassetid://102857578902137"
Adiantar.Parent = Controles
Pular = Instance.new("ImageButton")
Pular.Size = UDim2.new(0, 30, 0, 30)
Pular.Position = UDim2.new(1, -40, 0.5, -15)
Pular.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Pular.BorderSizePixel = 0
Pular.Image = "rbxassetid://82401540450034"
Pular.Parent = Controles
local imageButton2 = Instance.new("ImageButton")
imageButton2.Size = UDim2.new(0.27, 0, 0.37, 0)
imageButton2.AnchorPoint = Vector2.new(1, 1)
imageButton2.Position = UDim2.new(1, -20, 1, -20)
imageButton2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
imageButton2.BorderSizePixel = 0
imageButton2.BackgroundTransparency = 1
imageButton2.AutoButtonColor = false
imageButton2.Active = true
imageButton2.Visible = false
imageButton2.ZIndex = 3
imageButton2.Parent = nil
Draggable(imageButton2, true)
MiniMusica = Instance.new("ImageLabel")
MiniMusica.Size = UDim2.new(1, 0, 1, 0)
MiniMusica.Position = UDim2.new(0, 0, 0, 0)
MiniMusica.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniMusica.BorderSizePixel = 0
MiniMusica.Visible = true
MiniMusica.ImageRectOffset = Vector2.new(0, 0)
MiniMusica.ImageRectSize = Vector2.new(0, 0)
MiniMusica.Image = "rbxassetid://120329190202259"
MiniMusica.ZIndex = 3
MiniMusica.Parent = imageButton2
MiniVideo = Instance.new("VideoFrame")
MiniVideo.Size = UDim2.new(1, 0, 1, 0)
MiniVideo.Position = UDim2.new(0, 0, 0, 0)
MiniVideo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniVideo.BorderSizePixel = 0
MiniVideo.Visible = false
MiniVideo.Video = ""
MiniVideo.Volume = 1
MiniVideo.Looped = false
MiniVideo.ZIndex = 3
MiniVideo.Parent = imageButton2
MiniBack = Instance.new("ImageButton")
MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniBack.AnchorPoint = Vector2.new(0.5, 1)
MiniBack.Position = UDim2.new(0.105, 0, 0.94, 0)
MiniBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniBack.BackgroundTransparency = 0.5
MiniBack.Image = "rbxassetid://122582556337724"
MiniBack.Visible = false
MiniBack.ZIndex = 3
MiniBack.Parent = imageButton2
MiniRetroceder = Instance.new("ImageButton")
MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniRetroceder.AnchorPoint = Vector2.new(0.5, 1)
MiniRetroceder.Position = UDim2.new(0.3025, 0, 0.94, 0)
MiniRetroceder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniRetroceder.BackgroundTransparency = 0.5
MiniRetroceder.Image = "rbxassetid://95993997488260"
MiniRetroceder.Visible = false
MiniRetroceder.ZIndex = 3
MiniRetroceder.Parent = imageButton2
MiniPlay = Instance.new("ImageButton")
MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniPlay.AnchorPoint = Vector2.new(0.5, 1)
MiniPlay.Position = UDim2.new(0.5, 0, 0.94, 0)
MiniPlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniPlay.BackgroundTransparency = 0.5
MiniPlay.Image = "rbxassetid://119936293795425"
MiniPlay.Visible = false
MiniPlay.ZIndex = 3
MiniPlay.Parent = imageButton2
MiniAvancar = Instance.new("ImageButton")
MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniAvancar.AnchorPoint = Vector2.new(0.5, 1)
MiniAvancar.Position = UDim2.new(0.6975, 0, 0.94, 0)
MiniAvancar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniAvancar.BackgroundTransparency = 0.5
MiniAvancar.Image = "rbxassetid://95582496868769"
MiniAvancar.Visible = false
MiniAvancar.ZIndex = 3
MiniAvancar.Parent = imageButton2
MiniSkip = Instance.new("ImageButton")
MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniSkip.AnchorPoint = Vector2.new(0.5, 1)
MiniSkip.Position = UDim2.new(0.895, 0, 0.94, 0)
MiniSkip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniSkip.BackgroundTransparency = 0.5
MiniSkip.Image = "rbxassetid://101914600863480"
MiniSkip.Visible = false
MiniSkip.ZIndex = 3
MiniSkip.Parent = imageButton2
TelaCheia = Instance.new("ImageButton")
TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
TelaCheia.AnchorPoint = Vector2.new(0.5, 0)
TelaCheia.Position = UDim2.new(0.105, 0, 0.03, 0)
TelaCheia.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TelaCheia.BackgroundTransparency = 0.5
TelaCheia.Image = "rbxassetid://73952228795506"
TelaCheia.Visible = false
TelaCheia.ZIndex = 3
TelaCheia.Parent = imageButton2
FecharMini = Instance.new("ImageButton")
FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
FecharMini.AnchorPoint = Vector2.new(0.5, 0)
FecharMini.Position = UDim2.new(0.895, 0, 0.03, 0)
FecharMini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FecharMini.BackgroundTransparency = 0.5
FecharMini.Image = "rbxassetid://71780293592221"
FecharMini.Visible = false
FecharMini.ZIndex = 3
FecharMini.Parent = imageButton2
TituloEqua = Instance.new("Frame")
TituloEqua.Size = UDim2.new(0, 235, 0, 43)
TituloEqua.Position = UDim2.new(0, 6, 0, 6)
TituloEqua.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloEqua.BorderSizePixel = 0
TituloEqua.Parent = Tela3
NomeEqua = Instance.new("TextLabel")
NomeEqua.Size = UDim2.new(1, 0, 1, 0)
NomeEqua.Position = UDim2.new(0, 0, 0, 0)
NomeEqua.BackgroundTransparency = 1
NomeEqua.Text = Traducao.Equalizador
NomeEqua.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeEqua.Font = Enum.Font.SourceSansBold
NomeEqua.TextScaled = true
NomeEqua.Parent = TituloEqua
EquaFrame = Instance.new("Frame")
EquaFrame.Size = UDim2.new(0, 235, 0, 187)
EquaFrame.Position = UDim2.new(0, 6, 0, 58)
EquaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
EquaFrame.BorderSizePixel = 0
EquaFrame.Parent = Tela3
NoEquaFrame = Instance.new("Frame")
NoEquaFrame.Size = UDim2.new(0, 235, 0, 129)
NoEquaFrame.Position = UDim2.new(0, 6, 0, 116)
NoEquaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
NoEquaFrame.BorderSizePixel = 0
NoEquaFrame.Visible = false
NoEquaFrame.Parent = Tela3
Blockedicon = Instance.new("ImageLabel")
Blockedicon.Size = UDim2.new(0, 60, 0, 60)
Blockedicon.AnchorPoint = Vector2.new(0.5, 0.5)
Blockedicon.Position = UDim2.new(0.5, 0, 0.5, -23)
Blockedicon.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
Blockedicon.BackgroundTransparency = 1
Blockedicon.Image = "rbxassetid://140149151607570"
Blockedicon.Parent = NoEquaFrame
ErroEqua = Instance.new("TextLabel")
ErroEqua.Size = UDim2.new(0, 224, 0, 42)
ErroEqua.Position = UDim2.new(0, 5, 0, 82)
ErroEqua.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ErroEqua.BackgroundTransparency = 0.5
ErroEqua.RichText = true
ErroEqua.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.RecursoTe .. "</font>"
ErroEqua.Font = Enum.Font.SourceSansBold
ErroEqua.TextScaled = true
ErroEqua.Parent = NoEquaFrame
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = EquaFrame
ScrollEqua = Instance.new("ScrollingFrame")
ScrollEqua.Size = UDim2.new(1, -1, 1, 0)
ScrollEqua.Position = UDim2.new(0, 0, 0, 0)
ScrollEqua.BackgroundTransparency = 1
ScrollEqua.BorderSizePixel = 0
ScrollEqua.ScrollBarThickness = 1
ScrollEqua.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollEqua.ScrollBarImageTransparency = 0.5
ScrollEqua.CanvasSize = UDim2.new(0, 0, 0, 1015)
ScrollEqua.CanvasPosition = Vector2.new(0, 0)
ScrollEqua.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollEqua.ScrollingEnabled = true
ScrollEqua.ClipsDescendants = true
ScrollEqua.Parent = BaseSF
Volume = Instance.new("Frame")
Volume.Size = UDim2.new(0, 219, 0, 35)
Volume.Position = UDim2.new(0, 8, 0, 5)
Volume.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Volume.Parent = ScrollEqua
IconeVolume = Instance.new("ImageLabel")
IconeVolume.Size = UDim2.new(0, 35, 0, 35)
IconeVolume.Position = UDim2.new(0, 0, 0, 0)
IconeVolume.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeVolume.BackgroundTransparency = 0
IconeVolume.Image = "rbxassetid://89282663179812"
IconeVolume.Parent = Volume
VolumeBox = Instance.new("TextBox")
VolumeBox.Size = UDim2.new(0, 182, 1, 0)
VolumeBox.Position = UDim2.new(0, 39, 0, 0)
VolumeBox.BackgroundTransparency = 1
VolumeBox.Text = "1"
VolumeBox.PlaceholderText = Traducao.Volume
VolumeBox.TextWrapped = true
VolumeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeBox.Font = Enum.Font.SourceSansBold
VolumeBox.TextScaled = true
VolumeBox.Parent = Volume
Pitch = Instance.new("Frame")
Pitch.Size = UDim2.new(0, 219, 0, 35)
Pitch.Position = UDim2.new(0, 8, 0, 50)
Pitch.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Pitch.Parent = ScrollEqua
IconePitch = Instance.new("ImageLabel")
IconePitch.Size = UDim2.new(0, 35, 0, 35)
IconePitch.Position = UDim2.new(0, 0, 0, 0)
IconePitch.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconePitch.BackgroundTransparency = 0
IconePitch.Image = "rbxassetid://102339134358611"
IconePitch.Parent = Pitch
PitchBox = Instance.new("TextBox")
PitchBox.Size = UDim2.new(0, 182, 1, 0)
PitchBox.Position = UDim2.new(0, 39, 0, 0)
PitchBox.BackgroundTransparency = 1
PitchBox.Text = "1"
PitchBox.PlaceholderText = "Pitch"
PitchBox.TextWrapped = true
PitchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PitchBox.Font = Enum.Font.SourceSansBold
PitchBox.TextScaled = true
PitchBox.Parent = Pitch
FrequenciaTitulo = Instance.new("Frame")
FrequenciaTitulo.Size = UDim2.new(0, 219, 0, 25)
FrequenciaTitulo.Position = UDim2.new(0, 8, 0, 105)
FrequenciaTitulo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FrequenciaTitulo.BackgroundTransparency = 0.6
FrequenciaTitulo.BorderSizePixel = 1
FrequenciaTitulo.Parent = ScrollEqua
TextoFrenquencia = Instance.new("TextLabel")
TextoFrenquencia.Size = UDim2.new(1, -70, 1, -4)
TextoFrenquencia.Position = UDim2.new(0, 35, 0, 2)
TextoFrenquencia.BackgroundTransparency = 1
TextoFrenquencia.Text = Traducao.Freque
TextoFrenquencia.Font = Enum.Font.Garamond
TextoFrenquencia.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoFrenquencia.TextScaled = true
TextoFrenquencia.Parent = FrequenciaTitulo
Graves = Instance.new("Frame")
Graves.Size = UDim2.new(0, 219, 0, 35)
Graves.Position = UDim2.new(0, 8, 0, 150)
Graves.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Graves.Parent = ScrollEqua
IconeGraves = Instance.new("ImageLabel")
IconeGraves.Size = UDim2.new(0, 35, 0, 35)
IconeGraves.Position = UDim2.new(0, 0, 0, 0)
IconeGraves.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeGraves.BackgroundTransparency = 0
IconeGraves.Image = "rbxassetid://91932971942355"
IconeGraves.Parent = Graves
GravesBox = Instance.new("TextBox")
GravesBox.Size = UDim2.new(0, 182, 1, 0)
GravesBox.Position = UDim2.new(0, 39, 0, 0)
GravesBox.BackgroundTransparency = 1
GravesBox.Text = "1"
GravesBox.PlaceholderText = Traducao.Graves
GravesBox.TextWrapped = true
GravesBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GravesBox.Font = Enum.Font.SourceSansBold
GravesBox.TextScaled = true
GravesBox.Parent = Graves
Medios = Instance.new("Frame")
Medios.Size = UDim2.new(0, 219, 0, 35)
Medios.Position = UDim2.new(0, 8, 0, 195)
Medios.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Medios.Parent = ScrollEqua
IconeMedios = Instance.new("ImageLabel")
IconeMedios.Size = UDim2.new(0, 35, 0, 35)
IconeMedios.Position = UDim2.new(0, 0, 0, 0)
IconeMedios.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeMedios.BackgroundTransparency = 0
IconeMedios.Image = "rbxassetid://91932971942355"
IconeMedios.Parent = Medios
MediosBox = Instance.new("TextBox")
MediosBox.Size = UDim2.new(0, 182, 1, 0)
MediosBox.Position = UDim2.new(0, 39, 0, 0)
MediosBox.BackgroundTransparency = 1
MediosBox.Text = "1"
MediosBox.PlaceholderText = Traducao.Medios
MediosBox.TextWrapped = true
MediosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MediosBox.Font = Enum.Font.SourceSansBold
MediosBox.TextScaled = true
MediosBox.Parent = Medios
Agudos = Instance.new("Frame")
Agudos.Size = UDim2.new(0, 219, 0, 35)
Agudos.Position = UDim2.new(0, 8, 0, 240)
Agudos.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Agudos.Parent = ScrollEqua
IconeAgudos = Instance.new("ImageLabel")
IconeAgudos.Size = UDim2.new(0, 35, 0, 35)
IconeAgudos.Position = UDim2.new(0, 0, 0, 0)
IconeAgudos.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeAgudos.BackgroundTransparency = 0
IconeAgudos.Image = "rbxassetid://91932971942355"
IconeAgudos.Parent = Agudos
AgudosBox = Instance.new("TextBox")
AgudosBox.Size = UDim2.new(0, 182, 1, 0)
AgudosBox.Position = UDim2.new(0, 39, 0, 0)
AgudosBox.BackgroundTransparency = 1
AgudosBox.Text = "1"
AgudosBox.PlaceholderText = Traducao.Agudos
AgudosBox.TextWrapped = true
AgudosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AgudosBox.Font = Enum.Font.SourceSansBold
AgudosBox.TextScaled = true
AgudosBox.Parent = Agudos
EfeitosTitulo = Instance.new("Frame")
EfeitosTitulo.Size = UDim2.new(0, 219, 0, 25)
EfeitosTitulo.Position = UDim2.new(0, 8, 0, 295)
EfeitosTitulo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EfeitosTitulo.BackgroundTransparency = 0.6
EfeitosTitulo.BorderSizePixel = 1
EfeitosTitulo.Parent = ScrollEqua
TextoEfeitos = Instance.new("TextLabel")
TextoEfeitos.Size = UDim2.new(1, -70, 1, -4)
TextoEfeitos.Position = UDim2.new(0, 35, 0, 2)
TextoEfeitos.BackgroundTransparency = 1
TextoEfeitos.Text = Traducao.Efeitos
TextoEfeitos.Font = Enum.Font.Garamond
TextoEfeitos.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoEfeitos.TextScaled = true
TextoEfeitos.Parent = EfeitosTitulo
Nenhum = Instance.new("ImageButton")
Nenhum.Name = "Nenhum"
Nenhum.Size = UDim2.new(0, 219, 0, 35)
Nenhum.Position = UDim2.new(0, 8, 0, 340)
Nenhum.AutoButtonColor = false
Nenhum.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
Nenhum.Parent = ScrollEqua
IconeNenhum = Instance.new("ImageLabel")
IconeNenhum.Size = UDim2.new(0, 35, 0, 35)
IconeNenhum.Position = UDim2.new(0, 0, 0, 0)
IconeNenhum.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeNenhum.BackgroundTransparency = 0
IconeNenhum.Image = "rbxassetid://130043384241999"
IconeNenhum.Parent = Nenhum
NenhumTexto = Instance.new("TextLabel")
NenhumTexto.Size = UDim2.new(0, 182, 1, 0)
NenhumTexto.Position = UDim2.new(0, 39, 0, 0)
NenhumTexto.BackgroundTransparency = 1
NenhumTexto.Text = Traducao.Nenhum
NenhumTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
NenhumTexto.Font = Enum.Font.SourceSansBold
NenhumTexto.TextScaled = true
NenhumTexto.Parent = Nenhum
Reverb = Instance.new("ImageButton")
Reverb.Name = "Reverb"
Reverb.Size = UDim2.new(0, 219, 0, 35)
Reverb.Position = UDim2.new(0, 8, 0, 385)
Reverb.AutoButtonColor = false
Reverb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Reverb.Parent = ScrollEqua
IconeReverb = Instance.new("ImageLabel")
IconeReverb.Size = UDim2.new(0, 35, 0, 35)
IconeReverb.Position = UDim2.new(0, 0, 0, 0)
IconeReverb.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeReverb.BackgroundTransparency = 0
IconeReverb.Image = "rbxassetid://72645952367955"
IconeReverb.Parent = Reverb
ReverbTexto = Instance.new("TextLabel")
ReverbTexto.Size = UDim2.new(0, 182, 1, 0)
ReverbTexto.Position = UDim2.new(0, 39, 0, 0)
ReverbTexto.BackgroundTransparency = 1
ReverbTexto.Text = "Reverb"
ReverbTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ReverbTexto.Font = Enum.Font.SourceSansBold
ReverbTexto.TextScaled = true
ReverbTexto.Parent = Reverb
Echo = Instance.new("ImageButton")
Echo.Name = "Echo"
Echo.Size = UDim2.new(0, 219, 0, 35)
Echo.Position = UDim2.new(0, 8, 0, 430)
Echo.AutoButtonColor = false
Echo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Echo.Parent = ScrollEqua
IconeEcho = Instance.new("ImageLabel")
IconeEcho.Size = UDim2.new(0, 35, 0, 35)
IconeEcho.Position = UDim2.new(0, 0, 0, 0)
IconeEcho.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeEcho.BackgroundTransparency = 0
IconeEcho.Image = "rbxassetid://72645952367955"
IconeEcho.Parent = Echo
EchoTexto = Instance.new("TextLabel")
EchoTexto.Size = UDim2.new(0, 182, 1, 0)
EchoTexto.Position = UDim2.new(0, 39, 0, 0)
EchoTexto.BackgroundTransparency = 1
EchoTexto.Text = "Echo"
EchoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
EchoTexto.Font = Enum.Font.SourceSansBold
EchoTexto.TextScaled = true
EchoTexto.Parent = Echo
Distortion = Instance.new("ImageButton")
Distortion.Name = "Distortion"
Distortion.Size = UDim2.new(0, 219, 0, 35)
Distortion.Position = UDim2.new(0, 8, 0, 475)
Distortion.AutoButtonColor = false
Distortion.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Distortion.Parent = ScrollEqua
IconeDistortion = Instance.new("ImageLabel")
IconeDistortion.Size = UDim2.new(0, 35, 0, 35)
IconeDistortion.Position = UDim2.new(0, 0, 0, 0)
IconeDistortion.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeDistortion.Image = "rbxassetid://72645952367955"
IconeDistortion.Parent = Distortion
DistortionTexto = Instance.new("TextLabel")
DistortionTexto.Size = UDim2.new(0, 182, 1, 0)
DistortionTexto.Position = UDim2.new(0, 39, 0, 0)
DistortionTexto.BackgroundTransparency = 1
DistortionTexto.Text = "Distortion"
DistortionTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DistortionTexto.Font = Enum.Font.SourceSansBold
DistortionTexto.TextScaled = true
DistortionTexto.Parent = Distortion
Chorus = Instance.new("ImageButton")
Chorus.Name = "Chorus"
Chorus.Size = UDim2.new(0, 219, 0, 35)
Chorus.Position = UDim2.new(0, 8, 0, 520)
Chorus.AutoButtonColor = false
Chorus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Chorus.Parent = ScrollEqua
IconeChorus = Instance.new("ImageLabel")
IconeChorus.Size = UDim2.new(0, 35, 0, 35)
IconeChorus.Position = UDim2.new(0, 0, 0, 0)
IconeChorus.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeChorus.Image = "rbxassetid://72645952367955"
IconeChorus.Parent = Chorus
ChorusTexto = Instance.new("TextLabel")
ChorusTexto.Size = UDim2.new(0, 182, 1, 0)
ChorusTexto.Position = UDim2.new(0, 39, 0, 0)
ChorusTexto.BackgroundTransparency = 1
ChorusTexto.Text = "Chorus"
ChorusTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ChorusTexto.Font = Enum.Font.SourceSansBold
ChorusTexto.TextScaled = true
ChorusTexto.Parent = Chorus
Flanger = Instance.new("ImageButton")
Flanger.Name = "Flanger"
Flanger.Size = UDim2.new(0, 219, 0, 35)
Flanger.Position = UDim2.new(0, 8, 0, 565)
Flanger.AutoButtonColor = false
Flanger.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Flanger.Parent = ScrollEqua
IconeFlanger = Instance.new("ImageLabel")
IconeFlanger.Size = UDim2.new(0, 35, 0, 35)
IconeFlanger.Position = UDim2.new(0, 0, 0, 0)
IconeFlanger.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeFlanger.Image = "rbxassetid://72645952367955"
IconeFlanger.Parent = Flanger
FlangerTexto = Instance.new("TextLabel")
FlangerTexto.Size = UDim2.new(0, 182, 1, 0)
FlangerTexto.Position = UDim2.new(0, 39, 0, 0)
FlangerTexto.BackgroundTransparency = 1
FlangerTexto.Text = "Flanger"
FlangerTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
FlangerTexto.Font = Enum.Font.SourceSansBold
FlangerTexto.TextScaled = true
FlangerTexto.Parent = Flanger
Tremolo = Instance.new("ImageButton")
Tremolo.Name = "Tremolo"
Tremolo.Size = UDim2.new(0, 219, 0, 35)
Tremolo.Position = UDim2.new(0, 8, 0, 610)
Tremolo.AutoButtonColor = false
Tremolo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Tremolo.Parent = ScrollEqua
IconeTremolo = Instance.new("ImageLabel")
IconeTremolo.Size = UDim2.new(0, 35, 0, 35)
IconeTremolo.Position = UDim2.new(0, 0, 0, 0)
IconeTremolo.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeTremolo.Image = "rbxassetid://72645952367955"
IconeTremolo.Parent = Tremolo
TremoloTexto = Instance.new("TextLabel")
TremoloTexto.Size = UDim2.new(0, 182, 1, 0)
TremoloTexto.Position = UDim2.new(0, 39, 0, 0)
TremoloTexto.BackgroundTransparency = 1
TremoloTexto.Text = "Tremolo"
TremoloTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
TremoloTexto.Font = Enum.Font.SourceSansBold
TremoloTexto.TextScaled = true
TremoloTexto.Parent = Tremolo
Compressor = Instance.new("ImageButton")
Compressor.Name = "Compressor"
Compressor.Size = UDim2.new(0, 219, 0, 35)
Compressor.Position = UDim2.new(0, 8, 0, 655)
Compressor.AutoButtonColor = false
Compressor.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Compressor.Parent = ScrollEqua
IconeCompressor = Instance.new("ImageLabel")
IconeCompressor.Size = UDim2.new(0, 35, 0, 35)
IconeCompressor.Position = UDim2.new(0, 0, 0, 0)
IconeCompressor.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeCompressor.Image = "rbxassetid://72645952367955"
IconeCompressor.Parent = Compressor
CompressorTexto = Instance.new("TextLabel")
CompressorTexto.Size = UDim2.new(0, 182, 1, 0)
CompressorTexto.Position = UDim2.new(0, 39, 0, 0)
CompressorTexto.BackgroundTransparency = 1
CompressorTexto.Text = "Compressor"
CompressorTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CompressorTexto.Font = Enum.Font.SourceSansBold
CompressorTexto.TextScaled = true
CompressorTexto.Parent = Compressor
Radio = Instance.new("ImageButton")
Radio.Name = "Radio"
Radio.Size = UDim2.new(0, 219, 0, 35)
Radio.Position = UDim2.new(0, 8, 0, 700)
Radio.AutoButtonColor = false
Radio.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Radio.Parent = ScrollEqua
IconeRadio = Instance.new("ImageLabel")
IconeRadio.Size = UDim2.new(0, 35, 0, 35)
IconeRadio.Position = UDim2.new(0, 0, 0, 0)
IconeRadio.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeRadio.Image = "rbxassetid://72645952367955"
IconeRadio.Parent = Radio
RadioTexto = Instance.new("TextLabel")
RadioTexto.Size = UDim2.new(0, 182, 1, 0)
RadioTexto.Position = UDim2.new(0, 39, 0, 0)
RadioTexto.BackgroundTransparency = 1
RadioTexto.Text = "Radio"
RadioTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RadioTexto.Font = Enum.Font.SourceSansBold
RadioTexto.TextScaled = true
RadioTexto.Parent = Radio
Cinema = Instance.new("ImageButton")
Cinema.Name = "Cinema"
Cinema.Size = UDim2.new(0, 219, 0, 35)
Cinema.Position = UDim2.new(0, 8, 0, 745)
Cinema.AutoButtonColor = false
Cinema.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Cinema.Parent = ScrollEqua
IconeCinema = Instance.new("ImageLabel")
IconeCinema.Size = UDim2.new(0, 35, 0, 35)
IconeCinema.Position = UDim2.new(0, 0, 0, 0)
IconeCinema.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeCinema.Image = "rbxassetid://72645952367955"
IconeCinema.Parent = Cinema
CinemaTexto = Instance.new("TextLabel")
CinemaTexto.Size = UDim2.new(0, 182, 1, 0)
CinemaTexto.Position = UDim2.new(0, 39, 0, 0)
CinemaTexto.BackgroundTransparency = 1
CinemaTexto.Text = "Cinema"
CinemaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CinemaTexto.Font = Enum.Font.SourceSansBold
CinemaTexto.TextScaled = true
CinemaTexto.Parent = Cinema
Underwater = Instance.new("ImageButton")
Underwater.Name = "Underwater"
Underwater.Size = UDim2.new(0, 219, 0, 35)
Underwater.Position = UDim2.new(0, 8, 0, 790)
Underwater.AutoButtonColor = false
Underwater.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Underwater.Parent = ScrollEqua
IconeUnderwater = Instance.new("ImageLabel")
IconeUnderwater.Size = UDim2.new(0, 35, 0, 35)
IconeUnderwater.Position = UDim2.new(0, 0, 0, 0)
IconeUnderwater.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeUnderwater.Image = "rbxassetid://72645952367955"
IconeUnderwater.Parent = Underwater
UnderwaterTexto = Instance.new("TextLabel")
UnderwaterTexto.Size = UDim2.new(0, 182, 1, 0)
UnderwaterTexto.Position = UDim2.new(0, 39, 0, 0)
UnderwaterTexto.BackgroundTransparency = 1
UnderwaterTexto.Text = "Underwater"
UnderwaterTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
UnderwaterTexto.Font = Enum.Font.SourceSansBold
UnderwaterTexto.TextScaled = true
UnderwaterTexto.Parent = Underwater
Kid = Instance.new("ImageButton")
Kid.Name = "Kid"
Kid.Size = UDim2.new(0, 219, 0, 35)
Kid.Position = UDim2.new(0, 8, 0, 835)
Kid.AutoButtonColor = false
Kid.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Kid.Parent = ScrollEqua
IconeKid = Instance.new("ImageLabel")
IconeKid.Size = UDim2.new(0, 35, 0, 35)
IconeKid.Position = UDim2.new(0, 0, 0, 0)
IconeKid.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeKid.BackgroundTransparency = 0
IconeKid.Image = "rbxassetid://72645952367955"
IconeKid.Parent = Kid
KidTexto = Instance.new("TextLabel")
KidTexto.Size = UDim2.new(0, 182, 1, 0)
KidTexto.Position = UDim2.new(0, 39, 0, 0)
KidTexto.BackgroundTransparency = 1
KidTexto.Text = "Kid"
KidTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
KidTexto.Font = Enum.Font.SourceSansBold
KidTexto.TextScaled = true
KidTexto.Parent = Kid
Robot = Instance.new("ImageButton")
Robot.Name = "Robot"
Robot.Size = UDim2.new(0, 219, 0, 35)
Robot.Position = UDim2.new(0, 8, 0, 880)
Robot.AutoButtonColor = false
Robot.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Robot.Parent = ScrollEqua
IconeRobot = Instance.new("ImageLabel")
IconeRobot.Size = UDim2.new(0, 35, 0, 35)
IconeRobot.Position = UDim2.new(0, 0, 0, 0)
IconeRobot.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeRobot.BackgroundTransparency = 0
IconeRobot.Image = "rbxassetid://72645952367955"
IconeRobot.Parent = Robot
RobotTexto = Instance.new("TextLabel")
RobotTexto.Size = UDim2.new(0, 182, 1, 0)
RobotTexto.Position = UDim2.new(0, 39, 0, 0)
RobotTexto.BackgroundTransparency = 1
RobotTexto.Text = "Bug"
RobotTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RobotTexto.Font = Enum.Font.SourceSansBold
RobotTexto.TextScaled = true
RobotTexto.Parent = Robot
Slowed = Instance.new("ImageButton")
Slowed.Name = "Slowed"
Slowed.Size = UDim2.new(0, 219, 0, 35)
Slowed.Position = UDim2.new(0, 8, 0, 925)
Slowed.AutoButtonColor = false
Slowed.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Slowed.Parent = ScrollEqua
IconeSlowed = Instance.new("ImageLabel")
IconeSlowed.Size = UDim2.new(0, 35, 0, 35)
IconeSlowed.Position = UDim2.new(0, 0, 0, 0)
IconeSlowed.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeSlowed.BackgroundTransparency = 0
IconeSlowed.Image = "rbxassetid://72645952367955"
IconeSlowed.Parent = Slowed
SlowedTexto = Instance.new("TextLabel")
SlowedTexto.Size = UDim2.new(0, 182, 1, 0)
SlowedTexto.Position = UDim2.new(0, 39, 0, 0)
SlowedTexto.BackgroundTransparency = 1
SlowedTexto.Text = "Slowed"
SlowedTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
SlowedTexto.Font = Enum.Font.SourceSansBold
SlowedTexto.TextScaled = true
SlowedTexto.Parent = Slowed
ResetarEqua = Instance.new("ImageButton")
ResetarEqua.Name = "Resetar"
ResetarEqua.Size = UDim2.new(0, 219, 0, 35)
ResetarEqua.Position = UDim2.new(0, 8, 0, 975)
ResetarEqua.AutoButtonColor = false
ResetarEqua.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ResetarEqua.Parent = ScrollEqua
ResetarTexto = Instance.new("TextLabel")
ResetarTexto.Size = UDim2.new(1, 0, 1, 0)
ResetarTexto.Position = UDim2.new(0, 0, 0, 0)
ResetarTexto.BackgroundTransparency = 1
ResetarTexto.Text = "Reset"
ResetarTexto.TextColor3 = Color3.fromRGB(255, 0, 0)
ResetarTexto.Font = Enum.Font.SourceSansBold
ResetarTexto.TextScaled = true
ResetarTexto.Parent = ResetarEqua
Pesquisa = Instance.new("Frame")
Pesquisa.Size = UDim2.new(0, 235, 0, 43)
Pesquisa.Position = UDim2.new(0, 6, 0, 6)
Pesquisa.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Pesquisa.BorderSizePixel = 0
Pesquisa.Parent = Tela4
Lupa = Instance.new("ImageButton")
Lupa.Size = UDim2.new(0, 43, 0, 43)
Lupa.Position = UDim2.new(0, 0, 0, 0)
Lupa.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Lupa.Image = "rbxassetid://78857002895466"
Lupa.Active = true
Lupa.Parent = Pesquisa
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 43, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Pesquisa
PesquisarBox = Instance.new("TextBox")
PesquisarBox.Size = UDim2.new(0, 139, 0, 37)
PesquisarBox.Position = UDim2.new(0, 48, 0, 3)
PesquisarBox.Text = ""
PesquisarBox.PlaceholderText = Traducao.Pesquisar
PesquisarBox.TextScaled = true
PesquisarBox.TextWrapped = true
PesquisarBox.ClearTextOnFocus = false
PesquisarBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.BackgroundTransparency = 1
PesquisarBox.Active = true
PesquisarBox.Parent = Pesquisa
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(0, 2, 1, 0)
Linha2.Position = UDim2.new(0, 190, 0, 0)
Linha2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha2.BorderSizePixel = 0
Linha2.Parent = Pesquisa
Filtro = Instance.new("ImageButton")
Filtro.Size = UDim2.new(0, 33, 0, 33)
Filtro.Position = UDim2.new(0, 197, 0, 5)
Filtro.AutoButtonColor = false
Filtro.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Filtro.Image = "rbxassetid://128216827107080"
Filtro.Parent = Pesquisa
DownloadFrame = Instance.new("Frame")
DownloadFrame.Size = UDim2.new(0, 235, 0, 151)
DownloadFrame.Position = UDim2.new(0, 6, 0, 58)
DownloadFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
DownloadFrame.BorderSizePixel = 0
DownloadFrame.Parent = Tela4
DownloadFrameTexto = Instance.new("TextLabel")
DownloadFrameTexto.Size = UDim2.new(0, 223, 0, 40)
DownloadFrameTexto.Position = UDim2.new(0, 6, 0, 105)
DownloadFrameTexto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DownloadFrameTexto.BackgroundTransparency = 0.5
DownloadFrameTexto.RichText = true
DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
DownloadFrameTexto.Font = Enum.Font.SourceSansBold
DownloadFrameTexto.TextScaled = true
DownloadFrameTexto.Visible = true
DownloadFrameTexto.Parent = DownloadFrame
padding2 = Instance.new("UIPadding")
padding2.PaddingLeft = UDim.new(0, 2)
padding2.PaddingRight = UDim.new(0, 2)
padding2.PaddingTop = UDim.new(0, 2)
padding2.PaddingBottom = UDim.new(0, 2)
padding2.Parent = DownloadFrameTexto
PaginaFrame = Instance.new("Frame")
PaginaFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PaginaFrame.BorderSizePixel = 0
PaginaFrame.Visible = false
PaginaFrame.Parent = Tela4
ScrollPagina = Instance.new("ScrollingFrame")
ScrollPagina.Size = UDim2.new(1, -6, 1, 0)
ScrollPagina.Position = UDim2.new(0, 3, 0, 0)
ScrollPagina.BackgroundTransparency = 1
ScrollPagina.BorderSizePixel = 0
ScrollPagina.ScrollBarThickness = 1
ScrollPagina.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPagina.ScrollBarImageTransparency = 0.5
ScrollPagina.CanvasSize = UDim2.new(0, 280, 0, 0)
ScrollPagina.ScrollingDirection = Enum.ScrollingDirection.X
ScrollPagina.ClipsDescendants = true
ScrollPagina.Parent = PaginaFrame
PaginaEsperandoFrame = Instance.new("Frame")
PaginaEsperandoFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaEsperandoFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaEsperandoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PaginaEsperandoFrame.BorderSizePixel = 0
PaginaEsperandoFrame.Visible = true
PaginaEsperandoFrame.Parent = Tela4
PaginaEsperandoIcon = Instance.new("ImageLabel")
PaginaEsperandoIcon.Size = UDim2.new(0, 27, 0, 27)
PaginaEsperandoIcon.Position = UDim2.new(0, 0, 0, 0)
PaginaEsperandoIcon.BackgroundTransparency = 1
PaginaEsperandoIcon.Image = "rbxassetid://130610275359163"
PaginaEsperandoIcon.Parent = PaginaEsperandoFrame
PaginaEsperandoText = Instance.new("TextLabel")
PaginaEsperandoText.Size = UDim2.new(1, -36, 1, 0)
PaginaEsperandoText.Position = UDim2.new(0, 32, 0, 0)
PaginaEsperandoText.RichText = true
PaginaEsperandoText.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.NaoPodePagina .. "</font>"
PaginaEsperandoText.TextScaled = true
PaginaEsperandoText.Font = Enum.Font.SourceSansBold
PaginaEsperandoText.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PaginaEsperandoText.BackgroundTransparency = 1
PaginaEsperandoText.BorderSizePixel = 0
PaginaEsperandoText.Parent = PaginaEsperandoFrame
Aguardando = Instance.new("ImageLabel")
Aguardando.Size = UDim2.new(0, 80, 0, 80)
Aguardando.AnchorPoint = Vector2.new(0.5, 0.5)
Aguardando.Position = UDim2.new(0.5, 2, 0.5, -20)
Aguardando.BackgroundTransparency = 1
Aguardando.Image = "rbxassetid://130321829564804"
Aguardando.Visible = true
Aguardando.Parent = DownloadFrame
Loading = Instance.new("ImageLabel")
Loading.Size = UDim2.new(0, 75, 0, 75)
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.Position = UDim2.new(0.5, 0, 0.5, -2)
Loading.BackgroundTransparency = 1
Loading.Image = "rbxassetid://124877910068047"
Loading.Visible = false
Loading.Parent = DownloadFrame
SemResultado = Instance.new("ImageLabel")
SemResultado.Size = UDim2.new(0, 80, 0, 80)
SemResultado.AnchorPoint = Vector2.new(0.5, 0.5)
SemResultado.Position = UDim2.new(0.5, 3, 0.5, -20)
SemResultado.BackgroundTransparency = 1
SemResultado.Image = "rbxassetid://94766101394526"
SemResultado.Visible = false
SemResultado.Parent = DownloadFrame
Resultados = Instance.new("Frame")
Resultados.Size = UDim2.new(1, 0, 1, -4)
Resultados.Position = UDim2.new(0, 0, 0, 2)
Resultados.BackgroundTransparency = 1
Resultados.BorderSizePixel = 0
Resultados.ClipsDescendants = true
Resultados.Parent = DownloadFrame
FiltroFrame = Instance.new("Frame")
FiltroFrame.Size = UDim2.new(1, 0, 1, 0)
FiltroFrame.Position = UDim2.new(0, 0, 0, 0)
FiltroFrame.BackgroundTransparency = 1
FiltroFrame.BorderSizePixel = 0
FiltroFrame.Visible = false
FiltroFrame.Parent = Resultados
TituloFiltro = Instance.new("TextLabel")
TituloFiltro.Size = UDim2.new(0, 227, 0, 24)
TituloFiltro.Position = UDim2.new(0, 4, 0, 2)
TituloFiltro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TituloFiltro.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFiltro.BackgroundTransparency = 0.5
TituloFiltro.BorderSizePixel = 0
TituloFiltro.Text = Traducao.Filter
TituloFiltro.TextSize = 12
TituloFiltro.Parent = FiltroFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = FiltroFrame
ScrollFiltro = Instance.new("ScrollingFrame")
ScrollFiltro.Size = UDim2.new(1, -1, 1, -10)
ScrollFiltro.Position = UDim2.new(0, 0, 0, 34)
ScrollFiltro.BackgroundTransparency = 1
ScrollFiltro.BorderSizePixel = 0
ScrollFiltro.ScrollBarThickness = 1
ScrollFiltro.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFiltro.ScrollBarImageTransparency = 0.5
ScrollFiltro.CanvasSize = UDim2.new(0, 0, 0, 210)
ScrollFiltro.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFiltro.ClipsDescendants = true
ScrollFiltro.Parent = FiltroFrame
Relevancia = Instance.new("ImageButton")
Relevancia.Size = UDim2.new(0, 221, 0, 35)
Relevancia.Position = UDim2.new(0, 7, 0, 5)
Relevancia.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Relevancia.BorderSizePixel = 0
Relevancia.AutoButtonColor = false
Relevancia.Parent = ScrollFiltro
DataUpload = Instance.new("ImageButton")
DataUpload.Size = UDim2.new(0, 221, 0, 35)
DataUpload.Position = UDim2.new(0, 7, 0, 50)
DataUpload.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DataUpload.BackgroundTransparency = 0
DataUpload.BorderSizePixel = 0
DataUpload.AutoButtonColor = false
DataUpload.Active = true
DataUpload.Parent = ScrollFiltro
Duracao = Instance.new("ImageButton")
Duracao.Size = UDim2.new(0, 221, 0, 35)
Duracao.Position = UDim2.new(0, 7, 0, 95)
Duracao.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Duracao.BorderSizePixel = 0
Duracao.AutoButtonColor = false
Duracao.Parent = ScrollFiltro
IconeRelevancia = Instance.new("ImageLabel")
IconeRelevancia.Size = UDim2.new(0, 35, 0, 35)
IconeRelevancia.Position = UDim2.new(0, 0, 0, 0)
IconeRelevancia.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeRelevancia.BackgroundTransparency = 0
IconeRelevancia.Image = "rbxassetid://86663364934636"
IconeRelevancia.Parent = Relevancia
IconeDataUpload = Instance.new("ImageLabel")
IconeDataUpload.Size = UDim2.new(0, 35, 0, 35)
IconeDataUpload.Position = UDim2.new(0, 0, 0, 0)
IconeDataUpload.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeDataUpload.BackgroundTransparency = 0
IconeDataUpload.Image = "rbxassetid://102239634857456"
IconeDataUpload.ImageTransparency = 0
IconeDataUpload.Parent = DataUpload
IconeDuracao = Instance.new("ImageLabel")
IconeDuracao.Size = UDim2.new(0, 35, 0, 35)
IconeDuracao.Position = UDim2.new(0, 0, 0, 0)
IconeDuracao.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeDuracao.BackgroundTransparency = 0
IconeDuracao.Image = "rbxassetid://124803568759863"
IconeDuracao.Parent = Duracao
RelevanciaTexto = Instance.new("TextLabel")
RelevanciaTexto.Size = UDim2.new(0, 178, 1, 0)
RelevanciaTexto.Position = UDim2.new(0, 39, 0, 0)
RelevanciaTexto.BackgroundTransparency = 1
RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
RelevanciaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RelevanciaTexto.Font = Enum.Font.SourceSansBold
RelevanciaTexto.TextScaled = true
RelevanciaTexto.Parent = Relevancia
DataUploadTexto = Instance.new("TextLabel")
DataUploadTexto.Size = UDim2.new(0, 178, 1, 0)
DataUploadTexto.Position = UDim2.new(0, 39, 0, 0)
DataUploadTexto.BackgroundTransparency = 1
DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
DataUploadTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DataUploadTexto.Font = Enum.Font.SourceSansBold
DataUploadTexto.TextScaled = true
DataUploadTexto.Parent = DataUpload
DuracaoTexto = Instance.new("TextLabel")
DuracaoTexto.Size = UDim2.new(0, 178, 1, 0)
DuracaoTexto.Position = UDim2.new(0, 39, 0, 0)
DuracaoTexto.BackgroundTransparency = 1
DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
DuracaoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DuracaoTexto.Font = Enum.Font.SourceSansBold
DuracaoTexto.TextScaled = true
DuracaoTexto.Parent = Duracao
AplicarFiltro = Instance.new("ImageButton")
AplicarFiltro.Size = UDim2.new(0, 100, 0, 35)
AplicarFiltro.Position = UDim2.new(0, 7, 0, 145)
AplicarFiltro.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AplicarFiltro.BackgroundTransparency = 0.9
AplicarFiltro.BorderSizePixel = 0
AplicarFiltro.AutoButtonColor = false
AplicarFiltro.Parent = ScrollFiltro
RemoverFiltro = Instance.new("ImageButton")
RemoverFiltro.Size = UDim2.new(0, 100, 0, 35)
RemoverFiltro.Position = UDim2.new(0, 128, 0, 145)
RemoverFiltro.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
RemoverFiltro.BackgroundTransparency = 0.9
RemoverFiltro.BorderSizePixel = 0
RemoverFiltro.AutoButtonColor = false
RemoverFiltro.Parent = ScrollFiltro
NomeAplicarFiltro = Instance.new("TextLabel")
NomeAplicarFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeAplicarFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeAplicarFiltro.BackgroundTransparency = 1
NomeAplicarFiltro.Text = Traducao.AplicarF
NomeAplicarFiltro.TextColor3 = Color3.fromRGB(20, 20, 20)
NomeAplicarFiltro.Font = Enum.Font.SourceSansBold
NomeAplicarFiltro.TextScaled = true
NomeAplicarFiltro.Parent = AplicarFiltro
NomeRemoverFiltro = Instance.new("TextLabel")
NomeRemoverFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeRemoverFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeRemoverFiltro.BackgroundTransparency = 1
NomeRemoverFiltro.Text = Traducao.RemoverF
NomeRemoverFiltro.TextColor3 = Color3.fromRGB(20, 20, 20)
NomeRemoverFiltro.Font = Enum.Font.SourceSansBold
NomeRemoverFiltro.TextScaled = true
NomeRemoverFiltro.Parent = RemoverFiltro
Formato = Instance.new("Frame")
Formato.Size = UDim2.new(1, 0, 1, 0)
Formato.Position = UDim2.new(0, 0, 0, 0)
Formato.BackgroundTransparency = 1
Formato.BorderSizePixel = 0
Formato.Visible = false
Formato.Parent = Resultados
TituloFormato = Instance.new("TextLabel")
TituloFormato.Size = UDim2.new(0, 227, 0, 24)
TituloFormato.Position = UDim2.new(0, 4, 0, 2)
TituloFormato.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TituloFormato.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFormato.BackgroundTransparency = 0.5
TituloFormato.BorderSizePixel = 0
TituloFormato.Text = Traducao.EscolhaFor
TituloFormato.TextSize = 12
TituloFormato.Parent = Formato
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Formato
Thumbfor = Instance.new("ImageLabel")
Thumbfor.Size = UDim2.new(0, 85, 0, 50)
Thumbfor.Position = UDim2.new(0, 7, 0, 39)
Thumbfor.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Thumbfor.Image = "rbxassetid://0"
Thumbfor.ImageRectOffset = Vector2.new(0, 0)
Thumbfor.ImageRectSize = Vector2.new(0, 0)
Thumbfor.Parent = Formato
Titulofor = Instance.new("Frame")
Titulofor.Size = UDim2.new(0, 127, 0, 50)
Titulofor.Position = UDim2.new(0, 101, 0, 39)
Titulofor.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Titulofor.Parent = Formato
TextoTituloFor = Instance.new("TextLabel")
TextoTituloFor.Size = UDim2.new(1, -10, 1, -10)
TextoTituloFor.Position = UDim2.new(0, 5, 0, 5)
TextoTituloFor.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextoTituloFor.BackgroundTransparency = 1
TextoTituloFor.BorderSizePixel = 0
TextoTituloFor.RichText = true
TextoTituloFor.Text = ""
TextoTituloFor.TextScaled = true
TextoTituloFor.Parent = Titulofor
BotaoMp3 = Instance.new("ImageButton")
BotaoMp3.Size = UDim2.new(0, 60, 0, 30)
BotaoMp3.Position = UDim2.new(0, 7, 0, 112)
BotaoMp3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BotaoMp3.BackgroundTransparency = 0
BotaoMp3.AutoButtonColor = true
BotaoMp3.Parent = Formato
BotaoMp4 = Instance.new("ImageButton")
BotaoMp4.Size = UDim2.new(0, 60, 0, 30)
BotaoMp4.Position = UDim2.new(0, 88, 0, 112)
BotaoMp4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BotaoMp4.BackgroundTransparency = 0.9
BotaoMp4.AutoButtonColor = false
BotaoMp4.Parent = Formato
BotaoCancelar = Instance.new("ImageButton")
BotaoCancelar.Size = UDim2.new(0, 60, 0, 30)
BotaoCancelar.Position = UDim2.new(0, 168, 0, 112)
BotaoCancelar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BotaoCancelar.Parent = Formato
NomeMp3 = Instance.new("TextLabel")
NomeMp3.Size = UDim2.new(1, -8, 1, -8)
NomeMp3.Position = UDim2.new(0, 4, 0, 4)
NomeMp3.BackgroundTransparency = 1
NomeMp3.Text = Traducao.Musica
NomeMp3.TextColor3 = Color3.fromRGB(0, 191, 255)
NomeMp3.Font = Enum.Font.SourceSansBold
NomeMp3.TextScaled = true
NomeMp3.Parent = BotaoMp3
NomeMp4 = Instance.new("TextLabel")
NomeMp4.Size = UDim2.new(1, -8, 1, -8)
NomeMp4.Position = UDim2.new(0, 4, 0, 4)
NomeMp4.BackgroundTransparency = 1
NomeMp4.Text = "Video"
NomeMp4.TextColor3 = Color3.fromRGB(144, 238, 144)
NomeMp4.Font = Enum.Font.SourceSansBold
NomeMp4.TextScaled = true
NomeMp4.Parent = BotaoMp4
NomeCancel = Instance.new("TextLabel")
NomeCancel.Size = UDim2.new(1, -8, 1, -8)
NomeCancel.Position = UDim2.new(0, 4, 0, 4)
NomeCancel.BackgroundTransparency = 1
NomeCancel.Text = Traducao.Cancelar
NomeCancel.TextColor3 = Color3.fromRGB(178, 55, 34)
NomeCancel.Font = Enum.Font.SourceSansBold
NomeCancel.TextScaled = true
NomeCancel.Parent = BotaoCancelar
Erro = Instance.new("ImageLabel")
Erro.Size = UDim2.new(0, 80, 0, 80)
Erro.AnchorPoint = Vector2.new(0.5, 0.5)
Erro.Position = UDim2.new(0.5, -3, 0.5, -20)
Erro.BackgroundTransparency = 1
Erro.Image = "rbxassetid://80694922314021"
Erro.Visible = false
Erro.Parent = Resultados
Baixando = Instance.new("ImageLabel")
Baixando.Size = UDim2.new(0, 80, 0, 80)
Baixando.AnchorPoint = Vector2.new(0.5, 0.5)
Baixando.Position = UDim2.new(0.5, -3, 0.5, -20)
Baixando.BackgroundTransparency = 1
Baixando.Image = "rbxassetid://76931060119037"
Baixando.Visible = false
Baixando.Parent = Resultados
Concluido = Instance.new("ImageLabel")
Concluido.Size = UDim2.new(0, 77, 0, 77)
Concluido.AnchorPoint = Vector2.new(0.5, 0.5)
Concluido.Position = UDim2.new(0.5, -3, 0.5, -20)
Concluido.BackgroundTransparency = 1
Concluido.Image = "rbxassetid://135264044346021"
Concluido.Visible = false
Concluido.Parent = Resultados
Tutorial = Instance.new("ImageButton")
Tutorial.Size = UDim2.new(0, 25, 0, 25)
Tutorial.Position = UDim2.new(0, 7, 0, 5)
Tutorial.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Tutorial.BorderSizePixel = 0
Tutorial.Visible = false
Tutorial.Parent = Resultados
TutoTexto = Instance.new("TextLabel")
TutoTexto.Size = UDim2.new(1, 0, 1, 0)
TutoTexto.Position = UDim2.new(0, 0, 0, 0)
TutoTexto.BackgroundTransparency = 1
TutoTexto.Text = "?"
TutoTexto.TextColor3 = Color3.fromRGB(188, 11, 35)
TutoTexto.Font = Enum.Font.SourceSansBold
TutoTexto.TextScaled = true
TutoTexto.Parent = Tutorial
Novamente = Instance.new("ImageButton")
Novamente.Size = UDim2.new(0, 25, 0, 25)
Novamente.Position = UDim2.new(0, 203, 0, 5)
Novamente.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Novamente.BorderSizePixel = 0
Novamente.Visible = false
Novamente.Parent = Resultados
FotoNova = Instance.new("ImageLabel")
FotoNova.Size = UDim2.new(0, 18, 0, 18)
FotoNova.Position = UDim2.new(0, 3, 0, 3)
FotoNova.BackgroundTransparency = 1
FotoNova.ImageTransparency = 0
FotoNova.Image = "rbxassetid://95528695645064"
FotoNova.Parent = Novamente
ScrollDownload = Instance.new("ScrollingFrame")
ScrollDownload.Size = UDim2.new(1, -1, 1, 0)
ScrollDownload.Position = UDim2.new(0, 0, 0, 0)
ScrollDownload.BackgroundTransparency = 1
ScrollDownload.BorderSizePixel = 0
ScrollDownload.ScrollBarThickness = 1
ScrollDownload.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollDownload.ScrollBarImageTransparency = 0.5
ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollDownload.CanvasPosition = Vector2.new(0, 0)
ScrollDownload.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollDownload.ClipsDescendants = true
ScrollDownload.Visible = false
ScrollDownload.Parent = Resultados
TituloGC = Instance.new("Frame")
TituloGC.Size = UDim2.new(0, 235, 0, 43)
TituloGC.Position = UDim2.new(0, 6, 0, 6)
TituloGC.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloGC.BorderSizePixel = 0
TituloGC.Parent = Tela5
NomeGC = Instance.new("TextLabel")
NomeGC.Size = UDim2.new(1, 0, 1, 0)
NomeGC.Position = UDim2.new(0, 0, 0, 0)
NomeGC.BackgroundTransparency = 1
NomeGC.Text = "Global Chat"
NomeGC.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeGC.Font = Enum.Font.SourceSansBold
NomeGC.TextScaled = true
NomeGC.Parent = TituloGC
GCFrame = Instance.new("Frame")
GCFrame.Size = UDim2.new(0, 235, 0, 187)
GCFrame.Position = UDim2.new(0, 6, 0, 58)
GCFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
GCFrame.BorderSizePixel = 0
GCFrame.Parent = Tela5
Regras = Instance.new("TextButton")
Regras.Size = UDim2.new(0, 19, 0, 19)
Regras.Position = UDim2.new(0, 5, 0, 3)
Regras.Text = "R"
Regras.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Regras.TextColor3 = Color3.fromRGB(255, 255, 255)
Regras.BackgroundTransparency = 0.5
Regras.Parent = GCFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 25)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = GCFrame
AvisoGC = Instance.new("TextLabel")
AvisoGC.Size = UDim2.new(0, 177, 0, 19)
AvisoGC.Position = UDim2.new(0, 29, 0, 3)
AvisoGC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AvisoGC.BackgroundTransparency = 0.5
AvisoGC.Text = Traducao.Respeito
AvisoGC.TextColor3 = Color3.fromRGB(255, 255, 255)
AvisoGC.Font = Enum.Font.SourceSansBold
AvisoGC.TextScaled = true
AvisoGC.Visible = true
AvisoGC.Parent = GCFrame
padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 3)
padding.PaddingRight = UDim.new(0, 3)
padding.PaddingTop = UDim.new(0, 3)
padding.PaddingBottom = UDim.new(0, 3)
padding.Parent = AvisoGC
NotificarGC = Instance.new("ImageButton")
NotificarGC.Size = UDim2.new(0, 19, 0, 19)
NotificarGC.Position = UDim2.new(0, 211, 0, 3)
NotificarGC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NotificarGC.BackgroundTransparency = 0.5
NotificarGC.Parent = GCFrame
Sino = Instance.new("ImageLabel")
Sino.Size = UDim2.new(0, 17, 0, 16)
Sino.Position = UDim2.new(0, 1, 0, 1)
Sino.Image = "rbxassetid://115374069603142"
Sino.BackgroundTransparency = 1
Sino.Parent = NotificarGC
EsperandoIMG = Instance.new("ImageLabel")
EsperandoIMG.Size = UDim2.new(0, 90, 0, 90)
EsperandoIMG.AnchorPoint = Vector2.new(0.5, 0.5)
EsperandoIMG.Position = UDim2.new(0.5, -3, 0.5, -5)
EsperandoIMG.BackgroundTransparency = 1
EsperandoIMG.Image = "rbxassetid://18836713445"
EsperandoIMG.Visible = true
EsperandoIMG.Parent = GCFrame
BaseFinalGC = Instance.new("Frame")
BaseFinalGC.Size = UDim2.new(0, 40, 0, 40)
BaseFinalGC.AnchorPoint = Vector2.new(0.5, 0.5)
BaseFinalGC.Position = UDim2.new(0.5, 0, 0.5, 26)
BaseFinalGC.BorderSizePixel = 0
BaseFinalGC.BackgroundTransparency = 1
BaseFinalGC.ZIndex = 2
BaseFinalGC.ClipsDescendants = true
BaseFinalGC.Parent = GCFrame
FinalGC = Instance.new("ImageButton")
FinalGC.Size = UDim2.new(0, 32, 0, 32)
FinalGC.Position = UDim2.new(0, 4, 1, 4)
FinalGC.ZIndex = 2
FinalGC.Image = "rbxassetid://128357204583758"
FinalGC.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FinalGC.Parent = BaseFinalGC
ScrollGC = Instance.new("ScrollingFrame")
ScrollGC.Size = UDim2.new(1, -2, 1, -73)
ScrollGC.Position = UDim2.new(0, 1, 0, 28)
ScrollGC.BackgroundTransparency = 1
ScrollGC.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollGC.ScrollBarImageTransparency = 0.5
ScrollGC.BorderSizePixel = 0
ScrollGC.ScrollBarThickness = 1
ScrollGC.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollGC.CanvasPosition = Vector2.new(0, 0)
ScrollGC.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollGC.ClipsDescendants = true
ScrollGC.Visible = false
ScrollGC.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollGC.Parent = GCFrame
paddinggc = Instance.new("UIPadding")
paddinggc.PaddingLeft = UDim.new(0, 5)
paddinggc.PaddingRight = UDim.new(0, 5)
paddinggc.PaddingTop = UDim.new(0, 5)
paddinggc.PaddingBottom = UDim.new(0, 5)
paddinggc.Parent = ScrollGC
layoutgc = Instance.new("UIListLayout")
layoutgc.Parent = ScrollGC
layoutgc.SortOrder = Enum.SortOrder.LayoutOrder
layoutgc.Padding = UDim.new(0, 9)
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 143)
Linha2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha2.BorderSizePixel = 0
Linha2.Parent = GCFrame
MsgFrame = Instance.new("Frame")
MsgFrame.Size = UDim2.new(0, 223, 0, 32)
MsgFrame.Position = UDim2.new(0, 6, 0, 150)
MsgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MsgFrame.BorderSizePixel = 0
MsgFrame.Parent = GCFrame
MsgErroGC = Instance.new("TextLabel")
MsgErroGC.Size = UDim2.new(0, 215, 0, 28)
MsgErroGC.Position = UDim2.new(0, 4, 0, 2)
MsgErroGC.Text = Traducao.GcKey
MsgErroGC.TextScaled = true
MsgErroGC.TextColor3 = Color3.fromRGB(220, 220, 220)
MsgErroGC.BackgroundTransparency = 1
MsgErroGC.Visible = true
MsgErroGC.Parent = MsgFrame
Traduzir = Instance.new("ImageButton")
Traduzir.Size = UDim2.new(0, 24, 0, 24)
Traduzir.Position = UDim2.new(0, 4, 0, 4)
Traduzir.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Traduzir.Visible = false
Traduzir.Parent = MsgFrame
FotoTradu = Instance.new("ImageLabel")
FotoTradu.Size = UDim2.new(0, 18, 0, 18)
FotoTradu.Position = UDim2.new(0, 3, 0, 3)
FotoTradu.BackgroundTransparency = 1
FotoTradu.ImageTransparency = 0
FotoTradu.Image = "rbxassetid://84867288877251"
FotoTradu.Parent = Traduzir
LinhaTraducao = Instance.new("Frame")
LinhaTraducao.Size = UDim2.new(0, 1, 1, 0)
LinhaTraducao.Position = UDim2.new(0, 32, 0, 0)
LinhaTraducao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LinhaTraducao.BorderSizePixel = 0
LinhaTraducao.Visible = false
LinhaTraducao.Parent = MsgFrame
GCBox = Instance.new("TextBox")
GCBox.Size = UDim2.new(0, 151, 0, 28)
GCBox.Position = UDim2.new(0, 36, 0, 2)
GCBox.Text = ""
GCBox.ClearTextOnFocus = false
GCBox.PlaceholderText = Traducao.EnvieGc
GCBox.TextScaled = true
GCBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GCBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
GCBox.BackgroundTransparency = 1
GCBox.Active = false
GCBox.Visible = false
GCBox.Parent = MsgFrame
SendGC = Instance.new("ImageButton")
SendGC.Size = UDim2.new(0, 32, 0, 32)
SendGC.Position = UDim2.new(0, 191, 0, 0)
SendGC.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SendGC.Visible = false
SendGC.Parent = MsgFrame
Aviao = Instance.new("ImageLabel")
Aviao.Size = UDim2.new(0, 24, 0, 24)
Aviao.Position = UDim2.new(0, 4, 0, 4)
Aviao.BackgroundTransparency = 1
Aviao.ImageTransparency = 0
Aviao.Image = "rbxassetid://111380412941011"
Aviao.Parent = SendGC
TituloPremium = Instance.new("Frame")
TituloPremium.Size = UDim2.new(0, 235, 0, 43)
TituloPremium.Position = UDim2.new(0, 6, 0, 6)
TituloPremium.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloPremium.BorderSizePixel = 0
TituloPremium.Parent = Tela6
NomePremium = Instance.new("TextLabel")
NomePremium.Size = UDim2.new(1, 0, 1, 0)
NomePremium.Position = UDim2.new(0, 0, 0, 0)
NomePremium.BackgroundTransparency = 1
NomePremium.Text = "Premium"
NomePremium.TextColor3 = Color3.fromRGB(255, 255, 0)
NomePremium.Font = Enum.Font.SourceSansBold
NomePremium.TextScaled = true
NomePremium.Parent = TituloPremium
Privilegios = Instance.new("Frame")
Privilegios.Size = UDim2.new(0, 235, 0, 100)
Privilegios.Position = UDim2.new(0, 6, 0, 58)
Privilegios.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Privilegios.BorderSizePixel = 0
Privilegios.Parent = Tela6
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Visible = true
BaseSF.Parent = Privilegios
ScrollPremium = Instance.new("ScrollingFrame")
ScrollPremium.Size = UDim2.new(1, -2, 1, 0)
ScrollPremium.Position = UDim2.new(0, 0, 0, 0)
ScrollPremium.BackgroundTransparency = 1
ScrollPremium.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPremium.ScrollBarImageTransparency = 0.5
ScrollPremium.BorderSizePixel = 0
ScrollPremium.ScrollBarThickness = 1
ScrollPremium.CanvasSize = UDim2.new(0, 0, 0, 270)
ScrollPremium.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollPremium.ClipsDescendants = false
ScrollPremium.Parent = BaseSF
Priv1 = Instance.new("ImageButton")
Priv1.Size = UDim2.new(0, 221, 0, 35)
Priv1.Position = UDim2.new(0, 7, 0, 5)
Priv1.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
Priv1.AutoButtonColor = false
Priv1.Parent = ScrollPremium
Priv2 = Instance.new("ImageButton")
Priv2.Size = UDim2.new(0, 221, 0, 35)
Priv2.Position = UDim2.new(0, 7, 0, 50)
Priv2.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
Priv2.AutoButtonColor = false
Priv2.Parent = ScrollPremium
Priv3 = Instance.new("ImageButton")
Priv3.Size = UDim2.new(0, 221, 0, 35)
Priv3.Position = UDim2.new(0, 7, 0, 95)
Priv3.BackgroundColor3 = Color3.fromRGB(72, 61, 139)
Priv3.AutoButtonColor = false
Priv3.Parent = ScrollPremium
Priv4 = Instance.new("ImageButton")
Priv4.Size = UDim2.new(0, 221, 0, 35)
Priv4.Position = UDim2.new(0, 7, 0, 140)
Priv4.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Priv4.AutoButtonColor = false
Priv4.Parent = ScrollPremium
Priv5 = Instance.new("ImageButton")
Priv5.Size = UDim2.new(0, 221, 0, 35)
Priv5.Position = UDim2.new(0, 7, 0, 185)
Priv5.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Priv5.AutoButtonColor = false
Priv5.Parent = ScrollPremium
Priv6 = Instance.new("ImageButton")
Priv6.Size = UDim2.new(0, 221, 0, 35)
Priv6.Position = UDim2.new(0, 7, 0, 230)
Priv6.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Priv6.AutoButtonColor = false
Priv6.Parent = ScrollPremium
IconePriv1 = Instance.new("ImageLabel")
IconePriv1.Size = UDim2.new(0, 35, 0, 35)
IconePriv1.Position = UDim2.new(0, 0, 0, 0)
IconePriv1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv1.Image = "rbxassetid://140605327166526"
IconePriv1.Parent = Priv1
IconePriv2 = Instance.new("ImageLabel")
IconePriv2.Size = UDim2.new(0, 35, 0, 35)
IconePriv2.Position = UDim2.new(0, 0, 0, 0)
IconePriv2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv2.Image = "rbxassetid://128999640209878"
IconePriv2.Parent = Priv2
IconePriv3 = Instance.new("ImageLabel")
IconePriv3.Size = UDim2.new(0, 35, 0, 35)
IconePriv3.Position = UDim2.new(0, 0, 0, 0)
IconePriv3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv3.Image = "rbxassetid://126724539196702"
IconePriv3.Parent = Priv3
IconePriv4 = Instance.new("ImageLabel")
IconePriv4.Size = UDim2.new(0, 35, 0, 35)
IconePriv4.Position = UDim2.new(0, 0, 0, 0)
IconePriv4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv4.Image = "rbxassetid://77651842919295"
IconePriv4.Parent = Priv4
IconePriv5 = Instance.new("ImageLabel")
IconePriv5.Size = UDim2.new(0, 35, 0, 35)
IconePriv5.Position = UDim2.new(0, 0, 0, 0)
IconePriv5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv5.Image = "rbxassetid://129506682254424"
IconePriv5.Parent = Priv5
IconePriv6 = Instance.new("ImageLabel")
IconePriv6.Size = UDim2.new(0, 35, 0, 35)
IconePriv6.Position = UDim2.new(0, 0, 0, 0)
IconePriv6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv6.Image = "rbxassetid://135757623745817"
IconePriv6.Parent = Priv6
TextoPriv1 = Instance.new("TextLabel")
TextoPriv1.Size = UDim2.new(0, 160, 1, 0)
TextoPriv1.Position = UDim2.new(0, 45, 0, 0)
TextoPriv1.BackgroundTransparency = 1
TextoPriv1.Text = Traducao.Priv1
TextoPriv1.TextColor3 = Color3.fromRGB(144, 238, 144)
TextoPriv1.Font = Enum.Font.SourceSansBold
TextoPriv1.TextScaled = true
TextoPriv1.Parent = Priv1
TextoPriv2 = Instance.new("TextLabel")
TextoPriv2.Size = UDim2.new(0, 160, 1, 0)
TextoPriv2.Position = UDim2.new(0, 45, 0, 0)
TextoPriv2.BackgroundTransparency = 1
TextoPriv2.Text = Traducao.Priv2
TextoPriv2.TextColor3 = Color3.fromRGB(173, 216, 230)
TextoPriv2.Font = Enum.Font.SourceSansBold
TextoPriv2.TextScaled = true
TextoPriv2.Parent = Priv2
TextoPriv3 = Instance.new("TextLabel")
TextoPriv3.Size = UDim2.new(0, 160, 1, 0)
TextoPriv3.Position = UDim2.new(0, 45, 0, 0)
TextoPriv3.BackgroundTransparency = 1
TextoPriv3.Text = "MiniPlayer"
TextoPriv3.TextColor3 = Color3.fromRGB(186, 85, 211)
TextoPriv3.Font = Enum.Font.SourceSansBold
TextoPriv3.TextScaled = true
TextoPriv3.Parent = Priv3
TextoPriv4 = Instance.new("TextLabel")
TextoPriv4.Size = UDim2.new(0, 160, 1, 0)
TextoPriv4.Position = UDim2.new(0, 45, 0, 0)
TextoPriv4.BackgroundTransparency = 1
TextoPriv4.Text = "Roblox Audio"
TextoPriv4.TextColor3 = Color3.fromRGB(255, 99, 71)
TextoPriv4.Font = Enum.Font.SourceSansBold
TextoPriv4.TextScaled = true
TextoPriv4.Parent = Priv4
TextoPriv5 = Instance.new("TextLabel")
TextoPriv5.Size = UDim2.new(0, 160, 1, 0)
TextoPriv5.Position = UDim2.new(0, 45, 0, 0)
TextoPriv5.BackgroundTransparency = 1
TextoPriv5.Text = "Global Chat"
TextoPriv5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoPriv5.Font = Enum.Font.SourceSansBold
TextoPriv5.TextScaled = true
TextoPriv5.Parent = Priv5
TextoPriv6 = Instance.new("TextLabel")
TextoPriv6.Size = UDim2.new(0, 160, 1, 0)
TextoPriv6.Position = UDim2.new(0, 45, 0, 0)
TextoPriv6.BackgroundTransparency = 1
TextoPriv6.Text = "Premium UI"
TextoPriv6.TextColor3 = Color3.fromRGB(139, 69, 19)
TextoPriv6.Font = Enum.Font.SourceSansBold
TextoPriv6.TextScaled = true
TextoPriv6.Parent = Priv6
local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(0, 235, 0, 78)
frame2.Position = UDim2.new(0, 6, 0, 167)
frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
frame2.BorderSizePixel = 0
frame2.Visible = false
frame2.Parent = Tela6
IconeKeyOk = Instance.new("ImageLabel")
IconeKeyOk.Size = UDim2.new(0, 40, 0, 40)
IconeKeyOk.AnchorPoint = Vector2.new(0.5, 0)
IconeKeyOk.Position = UDim2.new(0.5, 0, 0, 2)
IconeKeyOk.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeKeyOk.BackgroundTransparency = 1
IconeKeyOk.Image = "rbxassetid://132948829118667"
IconeKeyOk.Parent = frame2
PremiumOkTexto = Instance.new("TextLabel")
PremiumOkTexto.Size = UDim2.new(0, 225, 0, 30)
PremiumOkTexto.Position = UDim2.new(0, 5, 0, 44)
PremiumOkTexto.RichText = true
PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
PremiumOkTexto.TextScaled = true
PremiumOkTexto.Font = Enum.Font.SourceSansBold
PremiumOkTexto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PremiumOkTexto.BackgroundTransparency = 0.5
PremiumOkTexto.BorderSizePixel = 0
PremiumOkTexto.Parent = frame2
KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 235, 0, 43)
KeyFrame.Position = UDim2.new(0, 6, 0, 167)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = true
KeyFrame.Parent = Tela6
SendKey = Instance.new("ImageButton")
SendKey.Size = UDim2.new(0, 43, 0, 43)
SendKey.Position = UDim2.new(0, 0, 0, 0)
SendKey.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
SendKey.Parent = KeyFrame
IconeKey = Instance.new("ImageLabel")
IconeKey.Size = UDim2.new(0, 30, 0, 30)
IconeKey.Position = UDim2.new(0, 6, 0, 6)
IconeKey.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeKey.BackgroundTransparency = 1
IconeKey.Image = "rbxassetid://108124574887969"
IconeKey.Parent = SendKey
KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 186, 0, 41)
KeyBox.Position = UDim2.new(0, 47, 0, 1)
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.PlaceholderText = Traducao.Key
KeyBox.TextScaled = true
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.BackgroundTransparency = 1
KeyBox.Active = true
KeyBox.Parent = KeyFrame
GetKey = Instance.new("ImageButton")
GetKey.Size = UDim2.new(0, 235, 0, 26)
GetKey.Position = UDim2.new(0, 6, 0, 219)
GetKey.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
GetKey.Visible = true
GetKey.Parent = Tela6
SetaES = Instance.new("ImageButton")
SetaES.Size = UDim2.new(0, 26, 0, 26)
SetaES.Position = UDim2.new(0, 0, 0, 0)
SetaES.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
SetaES.Parent = GetKey
SetaDI = Instance.new("ImageButton")
SetaDI.Size = UDim2.new(0, 26, 0, 26)
SetaDI.Position = UDim2.new(0, 209, 0, 0)
SetaDI.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
SetaDI.Parent = GetKey
Esquerda = Instance.new("TextLabel")
Esquerda.Size = UDim2.new(0, 20, 0, 20)
Esquerda.Position = UDim2.new(0, 3, 0, 2)
Esquerda.BackgroundTransparency = 1
Esquerda.Text = "<"
Esquerda.TextColor3 = Color3.fromRGB(0, 0, 0)
Esquerda.Font = Enum.Font.SourceSansBold
Esquerda.TextSize = 25
Esquerda.Parent = SetaES
Direita = Instance.new("TextLabel")
Direita.Size = UDim2.new(0, 20, 0, 20)
Direita.Position = UDim2.new(0, 3, 0, 2)
Direita.BackgroundTransparency = 1
Direita.Text = ">"
Direita.TextColor3 = Color3.fromRGB(0, 0, 0)
Direita.Font = Enum.Font.SourceSansBold
Direita.TextSize = 25
Direita.Parent = SetaDI
GetKeyTexto = Instance.new("TextLabel")
GetKeyTexto.Size = UDim2.new(0, 165, 1, 0)
GetKeyTexto.Position = UDim2.new(0, 35, 0, 0)
GetKeyTexto.BackgroundTransparency = 1
GetKeyTexto.Text = Traducao.Link
GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
GetKeyTexto.Font = Enum.Font.SourceSansBold
GetKeyTexto.TextScaled = true
GetKeyTexto.Parent = GetKey
ReportFrame = Instance.new("Frame")
ReportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ReportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ReportFrame.Size = UDim2.new(0, 300, 0, 250)
ReportFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ReportFrame.BorderSizePixel = 0
ReportFrame.Visible = false
ReportFrame.Parent = screenGui
TituloReportFrame = Instance.new("Frame")
TituloReportFrame.Size = UDim2.new(0, 286, 0, 30)
TituloReportFrame.Position = UDim2.new(0, 7, 0, 6)
TituloReportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloReportFrame.Parent = ReportFrame
TextoTituloReportFrame = Instance.new("TextLabel")
TextoTituloReportFrame.Size = UDim2.new(1, 0, 1, -4)
TextoTituloReportFrame.Position = UDim2.new(0, 0, 0, 2)
TextoTituloReportFrame.BackgroundTransparency = 1
TextoTituloReportFrame.Text = "Report"
TextoTituloReportFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloReportFrame.TextScaled = true
TextoTituloReportFrame.Font = Enum.Font.Highway
TextoTituloReportFrame.Parent = TituloReportFrame
LinhaReport = Instance.new("Frame")
LinhaReport.Size = UDim2.new(1, 0, 0, 5)
LinhaReport.Position = UDim2.new(0, 0, 0, 42)
LinhaReport.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LinhaReport.BorderSizePixel = 0
LinhaReport.Parent = ReportFrame
TextoReportFrameFrame = Instance.new("Frame")
TextoReportFrameFrame.Size = UDim2.new(0, 286, 0, 135)
TextoReportFrameFrame.Position = UDim2.new(0, 7, 0, 54)
TextoReportFrameFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TextoReportFrameFrame.Parent = ReportFrame
TextoReportFrame = Instance.new("TextLabel")
TextoReportFrame.Size = UDim2.new(0, 276, 0, 90)
TextoReportFrame.Position = UDim2.new(0, 5, 0, 5)
TextoReportFrame.BackgroundTransparency = 1
TextoReportFrame.Text = ""
TextoReportFrame.TextXAlignment = Enum.TextXAlignment.Left
TextoReportFrame.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoReportFrame.TextScaled = true
TextoReportFrame.Font = Enum.Font.Highway
TextoReportFrame.Parent = TextoReportFrameFrame
LinhaMotivo = Instance.new("Frame")
LinhaMotivo.Size = UDim2.new(1, 0, 0, 2)
LinhaMotivo.Position = UDim2.new(0, 0, 0, 100)
LinhaMotivo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LinhaMotivo.BorderSizePixel = 0
LinhaMotivo.Parent = TextoReportFrameFrame
Motivo = Instance.new("Frame")
Motivo.Size = UDim2.new(0, 274, 0, 23)
Motivo.Position = UDim2.new(0, 6, 0, 107)
Motivo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Motivo.BorderSizePixel = 0
Motivo.Parent = TextoReportFrameFrame
MotivoBox = Instance.new("TextBox")
MotivoBox.Size = UDim2.new(1, -6, 1, -6)
MotivoBox.Position = UDim2.new(0, 3, 0, 3)
MotivoBox.BackgroundTransparency = 1
MotivoBox.Text = ""
MotivoBox.PlaceholderText = Traducao.MotivoReport
MotivoBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MotivoBox.Font = Enum.Font.SourceSansBold
MotivoBox.TextScaled = true
MotivoBox.ClearTextOnFocus = false
MotivoBox.Parent = Motivo
Denunciar = Instance.new("ImageButton")
Denunciar.Size = UDim2.new(0, 100, 0, 30)
Denunciar.Position = UDim2.new(0, 193, 0, 210)
Denunciar.BackgroundColor3 = Color3.fromRGB(207, 55, 52)
Denunciar.Active = true
Denunciar.Parent = ReportFrame
FotoReport = Instance.new("ImageLabel")
FotoReport.Size = UDim2.new(0, 40, 0, 40)
FotoReport.Position = UDim2.new(0, 131, 0, 200)
FotoReport.BackgroundTransparency = 1
FotoReport.Image = ""
FotoReport.Parent = ReportFrame
CancelarReport = Instance.new("ImageButton")
CancelarReport.Size = UDim2.new(0, 100, 0, 30)
CancelarReport.Position = UDim2.new(0, 7, 0, 210)
CancelarReport.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
CancelarReport.Active = true
CancelarReport.Parent = ReportFrame
DenunciarTexto = Instance.new("TextLabel")
DenunciarTexto.Size = UDim2.new(1, -6, 1, -6)
DenunciarTexto.Position = UDim2.new(0, 3, 0, 3)
DenunciarTexto.BackgroundTransparency = 1
DenunciarTexto.Text = "Report"
DenunciarTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DenunciarTexto.TextScaled = true
DenunciarTexto.Parent = Denunciar
CancelarReportTexto = Instance.new("TextLabel")
CancelarReportTexto.Size = UDim2.new(1, -6, 1, -6)
CancelarReportTexto.Position = UDim2.new(0, 3, 0, 3)
CancelarReportTexto.BackgroundTransparency = 1
CancelarReportTexto.Text = Traducao.Cancelar
CancelarReportTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelarReportTexto.TextScaled = true
CancelarReportTexto.Parent = CancelarReport
BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = v3
Warn = Instance.new("Frame")
Warn.AnchorPoint = Vector2.new(0.5, 0.5)
Warn.Position = UDim2.new(0.5, 0, 0.5, 0)
Warn.Size = UDim2.new(0, 300, 0, 250)
Warn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Warn.BorderSizePixel = 0
Warn.Visible = false
Warn.Parent = screenGui
TituloWarn = Instance.new("Frame")
TituloWarn.Size = UDim2.new(0, 286, 0, 30)
TituloWarn.Position = UDim2.new(0, 7, 0, 6)
TituloWarn.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloWarn.Parent = Warn
TextoTituloWarn = Instance.new("TextLabel")
TextoTituloWarn.Size = UDim2.new(1, 0, 1, -4)
TextoTituloWarn.Position = UDim2.new(0, 0, 0, 2)
TextoTituloWarn.BackgroundTransparency = 1
TextoTituloWarn.Text = Traducao.Aviso
TextoTituloWarn.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloWarn.TextScaled = true
TextoTituloWarn.Font = Enum.Font.Highway
TextoTituloWarn.Parent = TituloWarn
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Linha.BorderSizePixel = 0
Linha.Parent = Warn
TextoWarnFrame = Instance.new("Frame")
TextoWarnFrame.Size = UDim2.new(0, 286, 0, 125)
TextoWarnFrame.Position = UDim2.new(0, 7, 0, 54)
TextoWarnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TextoWarnFrame.Parent = Warn
TextoWarn = Instance.new("TextLabel")
TextoWarn.Size = UDim2.new(0, 276, 0, 115)
TextoWarn.Position = UDim2.new(0, 5, 0, 5)
TextoWarn.BackgroundTransparency = 1
TextoWarn.Text = ""
TextoWarn.TextXAlignment = Enum.TextXAlignment.Left
TextoWarn.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoWarn.TextScaled = true
TextoWarn.Font = Enum.Font.Highway
TextoWarn.Parent = TextoWarnFrame
CloseWarn = Instance.new("ImageButton")
CloseWarn.Size = UDim2.new(0, 150, 0, 30)
CloseWarn.AnchorPoint = Vector2.new(0.5, 0.5)
CloseWarn.Position = UDim2.new(0.5, 0, 0, 215)
CloseWarn.BackgroundColor3 = Color3.fromRGB(207, 55, 52)
CloseWarn.BackgroundTransparency = 0
CloseWarn.Parent = Warn
CloseWarnTexto = Instance.new("TextLabel")
CloseWarnTexto.Size = UDim2.new(1, -6, 1, -6)
CloseWarnTexto.Position = UDim2.new(0, 3, 0, 3)
CloseWarnTexto.BackgroundTransparency = 1
CloseWarnTexto.Text = Traducao.FecharAviso
CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseWarnTexto.TextScaled = true
CloseWarnTexto.Parent = CloseWarn

YmpHwid = function()
	return v14
end

YmpClipboard = function(arg)
	if setclipboard_ then
		pcall(function()
			setclipboard_(arg)
		end)
	end
end

YmpRequest = function(...)
	return requestAsync(...)
end

scrolls = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }

ApiInfo = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/info?url=" .. "https://youtu.be/" .. arg)
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Author, data2.Thumbnail, data2.AuthorUrl
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(2)
	end

	return nil
end

ApiRoblox = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/roblox?assetId=" .. tostring(arg))
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Creator.Id, data2.Creator.Name, data2.Public
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(2)
	end

	return nil
end

local flag19 = false
local flag20 = false

processQueue = function()
	if flag7 then
		return
	end
	flag7 = true

	while #tbl7 > 0 do
		table.remove(tbl7, 1)()
	end

	flag7 = false
end

FavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v17 = ok3 and result3
			local tbl12

			if v17 then
				tbl12 = v17
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for _, favorite in ipairs(favorites) do
				if favorite == arg then
					tbl6 = favorites
					return
				end
			end

			table.insert(favorites, arg)
			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

DesfavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			ok3 = ok3 and result3
			local tbl12

			if ok3 then
				tbl12 = ok3
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for i, favorite in ipairs(favorites) do
				if favorite == arg then
					table.remove(favorites, i)
					break
				end
			end

			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Favorites then
		tbl6 = data2[1].Favorites
	end
end)

local sound2 = Instance.new("Sound")
sound2.Parent = v7
sound2.Looped = false
sound2.Volume = 1
sound2.SoundId = ""
sound2.PlaybackSpeed = 1
Equalizer = Instance.new("EqualizerSoundEffect")
Equalizer.LowGain = 1
Equalizer.MidGain = 1
Equalizer.HighGain = 1
Equalizer.Parent = sound2
VolumesOriginais = {}
MuteCon = nil
Mutado = false

GlobalMute = function(arg)
	pcall(function()
		if arg then
			if Mutado then
				return
			end
			Mutado = true

			local function fn4(arg2)
				pcall(function()
					if not arg2:IsA("Sound") then
						return
					end

					if arg2 == sound2 or arg2 == sound then
						return
					end

					if VolumesOriginais[arg2] == nil then
						VolumesOriginais[arg2] = arg2.Volume
					end

					arg2.Volume = 0
				end)
			end

			for _, descendant in ipairs(game:GetDescendants()) do
				fn4(descendant)
			end

			MuteCon = game.DescendantAdded:Connect(function(descendant)
				if Mutado then
					fn4(descendant)
				end
			end)
		else
			if not Mutado then
				return
			end
			Mutado = false

			if MuteCon then
				MuteCon:Disconnect()
				MuteCon = nil
			end

			for k, v17 in pairs(VolumesOriginais) do
				pcall(function()
					if k and k.Parent and k ~= sound2 then
						k.Volume = v17
					end
				end)
			end

			table.clear(VolumesOriginais)
		end
	end)
end

Mutar.MouseButton1Click:Connect(function()
	if Mutar.Image == "rbxassetid://109518972658686" then
		Mutar.Image = "rbxassetid://139303337799549"
		fn3(Traducao.Mutado, Traducao.SobreMute, 5)
		GlobalMute(true)
	else
		Mutar.Image = "rbxassetid://109518972658686"
		fn3(Traducao.Desmutado, Traducao.SobreUnmute, 5)
		GlobalMute(false)
	end
end)

BibliotecaMusicas = {}
BilbliotecaVideos = {}
BibliotecaRoblox = {}
BibliotecaLocal = {}
Girando = false
Congelado = false
GiroBackup = 1
GiroSpeed = 1

Girar = function(arg)
	if arg then
		Girando = true
		Congelado = false
	else
		Girando = false
		Disco.Rotation = 0
		Congelado = false
	end
end

SetFreeze = function(arg)
	Congelado = arg
end

task.spawn(function()
	while true do
		if Girando and not Congelado and GiroSpeed > 0 then
			local v17 = Disco
			v17.Rotation = v17.Rotation + GiroSpeed
		end

		task.wait(0.02)
	end
end)

formatar = function(arg)
	local n4 = math.floor(arg / 60)
	local n5 = math.floor(arg % 60)
	return string.format("%02d:%02d", n4, n5)
end

Reset = function()
	Rastro.Size = UDim2.new(0, 0, 1, 0)
	BolaProgresso.AnchorPoint = Vector2.new(0, 0.5)
	BolaProgresso.Position = UDim2.new(0, 0, 0.5, 0)
	TimerAtual.Text = "00:00"
end

setProgress = function(arg)
	local n4 = math.clamp(arg, 0, 1)
	Rastro.Size = UDim2.new(n4, 0, 1, 0)
	BolaProgresso.AnchorPoint = Vector2.new(n4, 0.5)
	BolaProgresso.Position = UDim2.new(n4, 0, 0.5, 0)
end

getProgress = function(arg)
	local x = BarraProgresso.AbsolutePosition.X
	local x2 = BarraProgresso.AbsoluteSize.X
	if x2 <= 0 then
		return 0
	end
	return math.clamp((arg - x) / x2, 0, 1)
end

seek = function(arg)
	local v17 = v12
	local flag21 = v12

	if v17 then
		flag21 = v17.TimeLength > 0
	end

	if flag21 then
		TimerAtual.Text = formatar(arg * v17.TimeLength)
	end
end

BarraProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
			local v18 = getProgress(input.Position.X)
			setProgress(v18)
			seek(v18)
		end
	end
end)

BolaProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
		end
	end
end)

v9.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if flag8 then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local timeLength = v17.TimeLength
				v17.TimePosition = math.clamp(getProgress(input.Position.X), 0, 0.999) * timeLength
			end

			flag8 = false
		end
	end
end)

v9.InputChanged:Connect(function(input)
	if flag8 then
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local n4 = math.clamp(getProgress(input.Position.X), 0, 0.999)
				setProgress(n4)
				seek(n4)
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and not flag8 then
			local timePosition = v17.TimePosition
			setProgress(timePosition / v17.TimeLength)
			TimerAtual.Text = formatar(timePosition)
		end
	end
end)

Equalizador = function(arg)
	if arg == true then
		EquaFrame.Size = UDim2.new(0, 235, 0, 187)
		NoEquaFrame.Visible = false
		ScrollEqua.ScrollingEnabled = true
	else
		EquaFrame.Size = UDim2.new(0, 235, 0, 49)
		NoEquaFrame.Visible = true
		ScrollEqua.CanvasPosition = Vector2.new(0, 0)
		ScrollEqua.ScrollingEnabled = false
	end
end

Selecionar = function(arg, arg2)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }
	local v17 = nil

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				local v19 = string.split(child.Name, ":")
				if v19[1] == arg2 and v19[2] == arg then
					v17 = child
					break
				end
			end
		end

		if not v17 then
			continue
		end
		break
	end

	if not v17 then
		return
	end

	local function fn4(arg3)
		local imageLabel = arg3:FindFirstChildOfClass("ImageLabel")
		arg3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end

		Stroke(arg3, 50, 50, 50, 2)

		for _, child in ipairs(arg3:GetChildren()) do
			if child:IsA("ImageButton") then
				Stroke(child, 50, 50, 50, 2)
			end
		end
	end

	if BotaoSelecionadoAtual == v17 then
		for _, v18 in ipairs(tbl12) do
			for _, child in ipairs(v18:GetChildren()) do
				if child:IsA("ImageButton") then
					fn4(child)
				end
			end
		end

		BotaoSelecionadoAtual = nil
		return
	end

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				fn4(child)
			end
		end
	end

	local imageLabel = v17:FindFirstChildOfClass("ImageLabel")
	v17.BackgroundColor3 = Color3.fromRGB(139, 0, 0)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	Stroke(v17, 255, 0, 0, 2)

	for _, child in ipairs(v17:GetChildren()) do
		if child:IsA("ImageButton") then
			Stroke(child, 255, 0, 0, 2)
		end
	end

	BotaoSelecionadoAtual = v17
end

CurrentMediaId = nil
thumbAtual = nil
BloquearMidia = false

resetSound = function(arg)
	if arg then
		pcall(function()
			arg:Stop()
			arg.SoundId = ""
			arg.TimePosition = 0
		end)
	end
end

resetVideo = function(arg)
	if arg then
		pcall(function()
			arg:Pause()
			arg.Video = ""
			arg.TimePosition = 0
		end)
	end
end

local function fn4(arg, arg2)
	if not arg2 or not arg then
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end
	resetSound(sound2)
	resetVideo(Video)
	resetVideo(MiniVideo)
	BloquearMidia = true
	local n4 = math.random()
	CurrentRequestId = n4
	task.wait(0.05)
	CurrentMediaId = arg2
	thumbAtual = nil
	local currentPlaying = arg .. ":" .. arg2
	Selecionar(arg, arg2)
	local visible = imageButton2.Visible

	if _G.CurrentPlaying == currentPlaying then
		_G.CurrentPlaying = nil
		Reset()
		Play.Image = "rbxassetid://110560238983134"
		MiniPlay.Image = "rbxassetid://119936293795425"
		flag9 = false
		Girar(false)
		Equalizador(true)
		GiroSpeed = GiroBackup
		BloquearMidia = false

		if visible then
			Musica.Image = "rbxassetid://109021809317392"
		else
			Musica.Image = "rbxassetid://120329190202259"
		end

		Musica.ImageRectOffset = Vector2.new(0, 0)
		Musica.ImageRectSize = Vector2.new(0, 0)
		MiniMusica.Image = "rbxassetid://120329190202259"
		MiniMusica.ImageRectOffset = Vector2.new(0, 0)
		MiniMusica.ImageRectSize = Vector2.new(0, 0)
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = false
		MiniVideo.Visible = false
		TimerTotal.Text = "00:00"
		FotoAutor.Image = "rbxassetid://130243480255582"
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
		return
	end

	_G.CurrentPlaying = currentPlaying
	Play.Image = "rbxassetid://80704722265943"
	MiniPlay.Image = "rbxassetid://110232191351528"
	flag9 = true

	if sound2 then
		pcall(function()
			sound2:Stop()
			sound2.TimePosition = 0
		end)
	end

	if Video then
		pcall(function()
			Video:Pause()
			Video.TimePosition = 0
		end)
	end

	if MiniVideo then
		pcall(function()
			MiniVideo:Pause()
			MiniVideo.TimePosition = 0
		end)
	end

	local function fn5(arg3)
		v12 = arg3 and (visible and MiniVideo or Video) or sound2
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = arg3 and not visible
		MiniVideo.Visible = arg3 and visible
	end

	local function fn6(arg3, arg4)
		return "<font color=\"rgb(255,255,255)\">" .. arg3 .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. arg4 .. "</font>"
	end

	local function fn7(arg3)
		local n5 = math.floor(arg3 or 0)
		return string.format("%02d:%02d", math.floor(n5 / 60), n5 % 60)
	end

	local function fn8(arg3)
		local ok3, result3 = pcall(function()
			return getcustomasset(arg3)
		end)

		if ok3 and typeof(result3) == "string" then
			return result3
		end
		return nil
	end

	local function fn9(arg3, arg4)
		local str6 = "YouTube Music Player/Internal/Cache/" .. arg4 .. ".png"
		if isfile(str6) then
			return fn8(str6)
		end

		local ok3 = pcall(function()
			local response = game:HttpGet(arg3)
			if not response or typeof(response) ~= "string" or #response < 50 then
				return
			end
			writefile(str6, response)
		end)

		task.wait(0.08)
		if not ok3 or not isfile(str6) then
			return nil
		end
		return fn8(str6)
	end

	local function fn10()
		if arg == "Musica" then
			for _, v17 in ipairs(BibliotecaMusicas) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Video" then
			for _, v17 in ipairs(BilbliotecaVideos) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Roblox" then
			for _, v17 in ipairs(BibliotecaRoblox) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Local" then
			for _, v17 in ipairs(BibliotecaLocal) do
				if v17.name == arg2 then
					return v17
				end
			end
		end
	end

	local v17 = fn10()
	if not v17 then
		return
	end
	TimerTotal.Text = "00:00"
	Girar(true)

	if arg == "Musica" or arg == "Video" then
		fn5(arg == "Video")
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://108154884074176"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		FotoAutor.Image = "rbxassetid://108154884074176"
		TituloMusica.Text = fn6(v17.name, v17.author)

		task.spawn(function()
			task.wait(0.05)
			if CurrentRequestId ~= n4 then
				return
			end
			local authorUrl = v17.authorUrl and fn9(v17.authorUrl, "author_" .. arg2)
			if CurrentRequestId ~= n4 then
				return
			end
			FotoAutor.Image = authorUrl or "rbxassetid://106804518898726"

			if arg == "Musica" and v17.thumb then
				local v19 = fn9(v17.thumb, "thumb_" .. arg2)
				if CurrentRequestId ~= n4 then
					return
				end

				if v19 then
					v18.Image = v19
					thumbAtual = v19
					v18.ImageRectOffset = Vector2.new(0, 45)
					v18.ImageRectSize = Vector2.new(480, 270)
				else
					v18.Image = "rbxassetid://110787075859454"
					v18.ImageRectOffset = Vector2.new(0, 0)
					v18.ImageRectSize = Vector2.new(0, 0)
				end
			end

			BloquearMidia = false
		end)

		if arg == "Musica" then
			pcall(function()
				sound2.SoundId = getcustomasset("YouTube Music Player/Musics/" .. arg2 .. ".mp3")
				sound2:Play()
				Equalizador(true)
				GiroSpeed = GiroBackup

				task.spawn(function()
					local n5 = 0

					while sound2.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(sound2.TimeLength)
				end)
			end)
		else
			pcall(function()
				local v19 = getcustomasset("YouTube Music Player/Videos/" .. arg2 .. ".webm")
				local v20 = visible and MiniVideo or Video
				v20.Video = v19
				v20:Play()
				Equalizador(false)
				GiroSpeed = 1

				task.spawn(function()
					local n5 = 0

					while v20.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(v20.TimeLength)
				end)
			end)
		end
	elseif arg == "Roblox" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://100415102639682"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. v17.name .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. v17.creatorName .. "</font>"
		FotoAutor.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. v17.creatorId .. "&width=420&height=420&format=png"

		pcall(function()
			sound2.SoundId = "rbxassetid://" .. arg2
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	elseif arg == "Local" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://84131152943912"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.In .. " " .. Traducao.LocalTitle .. "</font>"
		FotoAutor.Image = "rbxassetid://99316239950686"

		pcall(function()
			sound2.SoundId = getcustomasset("YouTube Music Player/Local Audios/" .. arg2 .. ".mp3")
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	end
end

SetMiniPlayer = function(visible)
	imageButton2.Visible = visible

	local function fn5(arg)
		if arg then
			pcall(function()
				arg:Pause()
				arg:Stop()
				arg.Video = nil
			end)
		end
	end

	local function fn6(arg)
		local v17 = nil

		pcall(function()
			v17 = getcustomasset(arg)
		end)

		return v17
	end

	local function fn7(arg, arg2)
		if not arg then
			return
		end

		if arg2 then
			arg.ImageRectOffset = Vector2.new(0, 45)
			arg.ImageRectSize = Vector2.new(480, 270)
		else
			arg.ImageRectOffset = Vector2.new(0, 0)
			arg.ImageRectSize = Vector2.new(0, 0)
		end
	end

	local function fn8(arg)
		if arg == "rbxassetid://108154884074176" then
			return "loading"
		end

		if arg == "rbxassetid://110787075859454" then
			return "empty"
		end

		if arg == "rbxassetid://84131152943912" then
			return "special"
		end

		if arg == "rbxassetid://109021809317392" then
			return "mini"
		end

		if arg == "rbxassetid://100415102639682" then
			return "roblox"
		end
		return "default"
	end

	local function fn9(arg, arg2)
		if arg2 == "loading" then
			arg.Image = "rbxassetid://108154884074176"
			fn7(arg, false)
		elseif arg2 == "empty" then
			arg.Image = "rbxassetid://110787075859454"
			fn7(arg, false)
		elseif arg2 == "special" then
			arg.Image = "rbxassetid://84131152943912"
			fn7(arg, false)
		elseif arg2 == "mini" then
			arg.Image = "rbxassetid://109021809317392"
			fn7(arg, false)
		elseif arg2 == "roblox" then
			arg.Image = "rbxassetid://100415102639682"
			fn7(arg, false)
		else
			arg.Image = "rbxassetid://120329190202259"
			fn7(arg, false)
		end
	end

	if visible then
		if Musica then
			Musica.Visible = true
			local v17 = fn8(Musica.Image)
			fn9(MiniMusica, v17)
			Musica.Image = "rbxassetid://109021809317392"
			fn7(Musica, false)
		end

		if MiniMusica then
			MiniMusica.Visible = true

			if thumbAtual then
				MiniMusica.Image = thumbAtual
				fn7(MiniMusica, true)
				Musica.Image = "rbxassetid://109021809317392"
				fn7(Musica, false)
			end
		end

		if Video and Video.Visible then
			local timePosition = Video.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(Video)

			if MiniVideo and v17 then
				fn5(MiniVideo)
				MiniVideo.Visible = true
				MiniVideo.Video = v17
				MiniVideo.TimePosition = timePosition
				MiniVideo:Play()
				v12 = MiniVideo
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end

			Video.Visible = false
		elseif MiniVideo and MiniVideo.Visible then
			Video.Visible = false
		end
	else
		if MiniVideo and MiniVideo.Visible then
			local timePosition = MiniVideo.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(MiniVideo)

			if Video and v17 then
				fn5(Video)
				Video.Visible = true
				Video.Video = v17
				Video.TimePosition = timePosition
				Video:Play()
				v12 = Video
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end
		end

		if Musica then
			Musica.Visible = true

			if MiniMusica then
				MiniMusica.Visible = true
			end

			if MiniMusica then
				local v17 = fn8(MiniMusica.Image)
				fn9(Musica, v17)

				if thumbAtual then
					Musica.Image = thumbAtual
					fn7(Musica, true)
				end
			end
		end
	end
end

SortMedia = function(arg, arg2)
	local attribute = arg:GetAttribute("Build")
	local attribute2 = arg2:GetAttribute("Build")
	if attribute and not attribute2 then
		return true
	end

	if attribute2 and not attribute then
		return false
	end
	local tag = arg:FindFirstChild("tag")
	local tag2 = arg2:FindFirstChild("tag")

	if tag then
		tag = tag.Text:match("^%s*(.-)%s*$"):lower()
	end

	tag = tag or ""

	if tag2 then
		tag2 = tag2.Text:match("^%s*(.-)%s*$"):lower()
	end

	return tag < (tag2 or "")
end

GetScrollAtual = function()
	for _, v17 in ipairs(scrolls) do
		if v17.Visible then
			return v17
		end
	end
end

GetLista = function(arg)
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("ImageButton") then
			if not child:GetAttribute("Privado") then
				local match, v17 = child.Name:match("(.+):(.+)")

				if match and v17 then
					if not ((v17 == "Video" or v17 == "Roblox") and not flag19) then
						table.insert(tbl12, child)
					end
				end
			end
		end
	end

	table.sort(tbl12, SortMedia)
	return tbl12
end

GetSelecionado = function(arg)
	for _, v17 in ipairs(arg) do
		if v17.BackgroundColor3 == Color3.fromRGB(139, 0, 0) then
			return v17
		end
	end
end

PlayBtn = function(arg)
	local match, v17 = arg.Name:match("(.+):(.+)")

	if match and v17 then
		fn4(v17, match)
	end
end

Pause = function()
	if not v12 or not flag9 then
		return
	end

	if v12:IsA("Sound") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Resume()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	elseif v12:IsA("VideoFrame") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Play()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	end
end

Avancar10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition + 10

	if v17.TimeLength < timePosition then
		timePosition = v17.TimeLength
	end

	v17.TimePosition = timePosition
end

Retroceder10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition - 10

	if timePosition < 0 then
		timePosition = 0
	end

	v17.TimePosition = timePosition
end

Skip = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 + 1

	if n4 > #v18 then
		n4 = 1
	end

	PlayBtn(v18[n4])
end

Back = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 - 1

	if n4 < 1 then
		n4 = #v18
	end

	PlayBtn(v18[n4])
end

EscolherRandom = function(arg)
	local tbl12 = {}
	local v17 = GetSelecionado(arg)

	for _, v18 in ipairs(arg) do
		if v18 ~= v17 and not tbl5[v18] then
			table.insert(tbl12, v18)
		end
	end

	if #tbl12 == 0 then
		tbl5 = {}

		for _, v18 in ipairs(arg) do
			if v18 ~= v17 then
				table.insert(tbl12, v18)
			end
		end
	end

	if #tbl12 == 0 then
		return v17
	end
	local v18 = tbl12[math.random(1, #tbl12)]
	tbl5[v18] = true
	return v18
end

HandleEnded = function(arg)
	if str4 == "nill" then
		return
	end
	task.wait()
	arg.Looped = false
	local v17 = GetScrollAtual()

	if v17 ~= v11 then
		tbl5 = {}
		v11 = v17
	end

	if not v17 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v18 = GetLista(v17)

	if #v18 == 0 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v19 = GetSelecionado(v18)

	if v19 then
		tbl5[v19] = true
	end

	if #v18 == 1 then
		if not v19 then
			PlayBtn(v18[1])
		else
			fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
			v12.TimePosition = 0
			v12:Play()
		end

		return
	end

	if str4 == "Random" then
		local v20 = EscolherRandom(v18)

		if v20 then
			PlayBtn(v20)
		end

		return
	end

	Skip()
end

sound2.Ended:Connect(function()
	HandleEnded(sound2)
end)

Video.Ended:Connect(function()
	if Video and Video.Visible then
		HandleEnded(Video)
	end
end)

MiniVideo.Ended:Connect(function()
	if MiniVideo and MiniVideo.Visible then
		HandleEnded(MiniVideo)
	end
end)

Deletar = function(arg, arg2)
	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if _G.CurrentPlaying then
		local match, v17 = _G.CurrentPlaying:match("^(.-)%:(.+)$")

		if v17 == arg then
			fn4(match, v17)
		end
	end

	local tbl12 = {
		"YouTube Music Player/Internal/Cache/author_" .. arg .. ".png",
		"YouTube Music Player/Internal/Cache/thumb_" .. arg .. ".png",
	}

	for _, v17 in ipairs({
		"YouTube Music Player/Musics/" .. arg .. ".mp3",
		"YouTube Music Player/Videos/" .. arg .. ".webm",
		"YouTube Music Player/Roblox IDS/" .. arg .. ".rbx",
		"YouTube Music Player/Local Audios/" .. arg .. ".mp3",
	}) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for _, v17 in ipairs(tbl12) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for i = #BibliotecaMusicas, 1, -1 do
		if BibliotecaMusicas[i].id == arg then
			table.remove(BibliotecaMusicas, i)
		end
	end

	for i = #BilbliotecaVideos, 1, -1 do
		if BilbliotecaVideos[i].id == arg then
			table.remove(BilbliotecaVideos, i)
		end
	end

	for i = #BibliotecaRoblox, 1, -1 do
		if BibliotecaRoblox[i].id == arg then
			table.remove(BibliotecaRoblox, i)
		end
	end

	for i = #BibliotecaLocal, 1, -1 do
		if BibliotecaLocal[i].name == arg then
			table.remove(BibliotecaLocal, i)
		end
	end

	DesfavoritarFile(arg)
	fn3(Traducao.Excluido, arg2, 8)

	local function fn5(arg3)
		for _, child in ipairs(arg3:GetChildren()) do
			local name = child:IsA("ImageButton") and child.Name and arg

			if name then
				local str6 = arg .. ":"
				name = child.Name:sub(1, #arg + 1) == str6
			end

			if name then
				child:Destroy()
			end
		end
	end

	task.wait(0.1)
	fn5(ScrollTodos)
	fn5(ScrollMusicas)
	fn5(ScrollVideos)
	fn5(ScrollRoblox)
	fn5(ScrollLocal)
	fn5(ScrollFav)
	fn5(ScrollPesquisa)
end

-- https://discord.gg/AwGHNh7Z7T
local function fn5(text2, arg, arg2, arg3)
	local tbl12 = {}
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Name = arg2 .. ":" .. arg
	imageButton3.Size = UDim2.new(0, 148, 0, 35)
	imageButton3.Position = UDim2.new(0, 5, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton3.BackgroundTransparency = 0
	imageButton3.AutoButtonColor = false
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 35, 0, 35)
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageLabel.BackgroundTransparency = 0
	local v17 = ScrollTodos
	local v18

	if arg == "Musica" then
		imageLabel.Image = "rbxassetid://136933987460149"

		if str2 == "Musicas" then
			v18 = ScrollMusicas
		else
			v18 = v17
		end
	elseif arg == "Video" then
		imageLabel.Image = "rbxassetid://105308603886068"

		if str2 == "Videos" then
			v18 = ScrollVideos
		else
			v18 = v17
		end
	elseif arg == "Roblox" then
		imageLabel.Image = "rbxassetid://118724747640040"

		if str2 ~= "Roblox" then
			v18 = v17
		else
			v18 = ScrollRoblox
		end
	elseif arg == "Local" then
		imageLabel.Image = "rbxassetid://93635917640466"

		if str2 ~= "Local" then
			v18 = v17
		else
			v18 = ScrollLocal
		end
	else
		v18 = v17
	end

	imageButton3.Parent = v18
	imageLabel.Parent = imageButton3
	imageLabel.ImageTransparency = 0
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 107, 1, 0)
	textLabel.Position = UDim2.new(0, 38, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.Name = "tag"
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 35, 0, 35)
	imageButton4.Position = UDim2.new(1, 8, 0, 0)
	imageButton4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton4.Parent = imageButton3
	local v19 = ipairs
	local v20 = tbl6
	local tbl13

	if tbl6 then
		tbl13 = v20
	else
		tbl13 = {}
	end

	local flag21 = false

	for _, v21 in v19(tbl13) do
		if v21 == arg2 then
			flag21 = true
			break
		end
	end

	if flag21 then
		imageButton4.Image = "rbxassetid://122765197997575"
	else
		imageButton4.Image = "rbxassetid://102097543764342"
	end

	local imageButton5 = Instance.new("ImageButton")
	imageButton5.Size = UDim2.new(0, 35, 0, 35)
	imageButton5.Position = UDim2.new(1, 51, 0, 0)
	imageButton5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton5.BackgroundTransparency = 0
	imageButton5.Image = "rbxassetid://125370105968945"
	imageButton5.Parent = imageButton3

	if arg2 == "LvvrO6JifEA" then
		imageButton5.ImageTransparency = 0.8
		imageButton5.Active = false
		imageButton3:SetAttribute("Build", true)
	end

	Corner(imageButton3, 5)
	Corner(imageLabel, 5)
	Corner(imageButton4, 5)
	Corner(imageButton5, 5)
	Stroke(imageButton3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton4, 50, 50, 50, 2)
	Stroke(imageButton5, 50, 50, 50, 2)

	if arg == "Roblox" and arg3 == false then
		imageButton3:SetAttribute("Privado", true)
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	end

	if (arg == "Video" or arg == "Roblox") and not flag19 then
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	end

	tbl12[#tbl12 + 1] = imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" and arg3 == false then
			fn3(Traducao.Erro, Traducao.Privado, 10)
			return
		end

		if (arg == "Video" or arg == "Roblox") and not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		else
			fn4(arg, arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton4.MouseButton1Click:Connect(function()
		if imageButton4.Image == "rbxassetid://122765197997575" then
			imageButton4.Image = "rbxassetid://102097543764342"
			fn3(Traducao.Desfavoritado, text2, 8)
			DesfavoritarFile(arg2)

			if str2 == "Favoritos" then
				local v21 = ScrollTodos

				if arg == "Musica" then
					v21 = ScrollMusicas
				elseif arg == "Video" then
					v21 = ScrollVideos
				elseif arg == "Roblox" then
					v21 = ScrollRoblox
				end

				if imageButton3.Parent ~= v21 then
					imageButton3.Parent = v21
				end
			end
		else
			imageButton4.Image = "rbxassetid://122765197997575"
			fn3(Traducao.Favoritado, text2, 8)
			FavoritarFile(arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton5.MouseButton1Click:Connect(function()
		if not imageButton5.Active then
			return
		end
		Deletar(arg2, textLabel.Text)
	end)

	imageButton3.Destroying:Connect(function()
		for _, v21 in ipairs(tbl12) do
			pcall(function()
				v21:Disconnect()
			end)
		end

		tbl12 = {}
	end)
end

Parent = function(arg)
	local tbl12 = {}

	local v17 = ({
		Musica = ScrollMusicas,
		Video = ScrollVideos,
		Roblox = ScrollRoblox,
		Local = ScrollLocal,
		Todos = ScrollTodos,
		Favoritos = ScrollFav,
	})[arg]

	if not v17 then
		return
	end

	for i = 1, #scrolls do
		local children = scrolls[i]:GetChildren()

		for i2 = 1, #children do
			local v18 = children[i2]

			if v18:IsA("GuiObject") then
				tbl12[#tbl12 + 1] = v18
			end
		end
	end

	if arg == "Todos" then
		for i = 1, #tbl12 do
			tbl12[i].Parent = v17
		end
	elseif arg == "Favoritos" then
		local v18 = tbl6

		for i = 1, #tbl12 do
			local v19 = tbl12[i]
			local match = v19.Name:match("^(.-):")

			if table.find(v18, match) then
				v19.Parent = v17
			end
		end
	else
		for i = 1, #tbl12 do
			local v18 = tbl12[i]
			local match, v19 = v18.Name:match("^(.-):(.+)$")

			if v19 == arg then
				v18.Parent = v17
			end
		end
	end

	v17.CanvasPosition = Vector2.zero
end

AtualizarScroll = function(arg)
	if arg == ScrollLocal and #arg:GetChildren() == 0 then
		arg.Visible = false
		VazioLocal.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.LocalTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.LocalText .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		Vazio.Visible = false
		return
	end

	if #arg:GetChildren() > 0 then
		arg.Visible = true
		Vazio.Visible = false
		VazioLocal.Visible = false
		ErroPL.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
	else
		arg.Visible = false
		Vazio.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		VazioLocal.Visible = false
	end
end

Abas = {
	Todos = {
		parent = "Todos",
		text = function()
			return Traducao.Todos
		end,
		scroll = ScrollTodos,
	},
	Musicas = {
		parent = "Musica",
		text = function()
			return Traducao.Musicas
		end,
		scroll = ScrollMusicas,
	},
	Videos = {
		parent = "Video",
		text = function()
			return "Videos"
		end,
		scroll = ScrollVideos,
	},
	Roblox = {
		parent = "Roblox",
		text = function()
			return "Roblox IDS"
		end,
		scroll = ScrollRoblox,
	},
	Favoritos = {
		parent = "Favoritos",
		text = function()
			return Traducao.Favoritos
		end,
		scroll = ScrollFav,
	},
	Local = {
		parent = "Local",
		text = function()
			return Traducao.LocalTitle
		end,
		scroll = ScrollLocal,
	},
}

Ordem = { "Todos", "Musicas", "Videos", "Roblox", "Favoritos", "Local", "Pesquisar" }

OcultarScrolls = function()
	ScrollTodos.Visible = false
	ScrollMusicas.Visible = false
	ScrollVideos.Visible = false
	ScrollRoblox.Visible = false
	ScrollFav.Visible = false
	ScrollLocal.Visible = false
	ScrollPesquisa.Visible = false
end

ToTab = function(arg)
	str2 = arg
	OcultarScrolls()

	if arg == "Pesquisar" then
		AbaPL.Visible = false
		PesquisaPL.Visible = true
		AguardandoPL.Visible = true
		Vazio.Visible = false
		ErroPL.Visible = true
		PesquisaPL.Text = ""
		VazioLocal.Visible = false
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local v17 = Abas[arg]
	if not v17 then
		return
	end
	Parent(v17.parent)
	AbaPL.Text = v17.text()
	AbaPL.Visible = true
	PesquisaPL.Visible = false
	AtualizarScroll(v17.scroll)
end

ProximaAba = function(arg)
	local v17 = nil

	for i, v18 in ipairs(Ordem) do
		if v18 == str2 then
			v17 = i
			break
		else
			v17 = nil
		end
	end

	if not v17 then
		return
	end
	local n4 = v17 + arg

	if #Ordem < n4 then
		n4 = 1
	end

	if n4 < 1 then
		n4 = #Ordem
	end

	return Ordem[n4]
end

DireitaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(1))
end)

EsquerdaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(-1))
end)

OrganizarSF = function(arg)
	task.wait()
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("GuiObject") then
			table.insert(tbl12, child)
		end
	end

	table.sort(tbl12, SortMedia)
	local n4 = 5

	for _, v17 in ipairs(tbl12) do
		v17.Position = UDim2.new(0, 5, 0, n4)
		n4 = n4 + v17.Size.Y.Offset + 10
	end

	arg.CanvasSize = UDim2.new(0, 243, 0, math.max(n4 - 6, 0))
end

Pesquisando = false

PesquisarPL = function(arg)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal }
	ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
	Pesquisando = true

	for _, child in ipairs(ScrollPesquisa:GetChildren()) do
		if child:IsA("ImageButton") then
			child.Parent = ScrollTodos
		end
	end

	Pesquisando = false

	if not arg or arg:match("^%s*$") then
		ScrollPesquisa.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local str6 = arg:lower()
	local visible = false

	for _, v17 in ipairs(tbl12) do
		for _, child in ipairs(v17:GetChildren()) do
			if child:IsA("GuiObject") then
				local tag = child:FindFirstChild("tag")

				if tag and tag.Text then
					if string.find(tag.Text:lower(), str6, 1, true) then
						child.Parent = ScrollPesquisa
						visible = true
					end
				end
			end
		end
	end

	ScrollPesquisa.Visible = visible
	AguardandoPL.Visible = false
	local visible2 = not visible
	SemResultadoPL.Visible = visible2
	ErroPL.Visible = visible2

	if visible2 then
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.SemResutadoTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.SemResutadoTextPL .. "</font>"
	end
end

Scrolls = {
	Todos = ScrollTodos,
	Musicas = ScrollMusicas,
	Videos = ScrollVideos,
	Roblox = ScrollRoblox,
	Favoritos = ScrollFav,
	Local = ScrollLocal,
}

ConectarScroll = function(arg, arg2)
	arg2.ChildAdded:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)

	arg2.ChildRemoved:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)
end

for k, v17 in pairs(Scrolls) do
	ConectarScroll(k, v17)
end

ScrollPesquisa.ChildAdded:Connect(function()
	OrganizarSF(ScrollPesquisa)
end)

ScrollPesquisa.ChildRemoved:Connect(function()
	if ScrollPesquisa.Visible and not Pesquisando then
		PesquisarPL(PesquisaPL.Text)
	end
end)

PesquisaPL.Focused:Connect(function()
	PesquisarPL()
end)

PesquisaPL.FocusLost:Connect(function()
	local match = PesquisaPL.Text:match("^%s*(.-)%s*$")
	PesquisaPL.Text = match

	if match ~= "" then
		PesquisarPL(match)
	end
end)

FixNome = function()
	local str6 = "YouTube Music Player/Local Audios"

	for _, v17 in ipairs(listfiles("YouTube Music Player/Local Audios")) do
		pcall(function()
			local match = v17:match("[^/\\]+$")

			if match and match:sub(-4) == ".mp3" then
				local str7 = match:sub(1, -5)

				if #str7 > 90 then
					local str8 = str6 .. "/" .. str7:sub(1, 80) .. "_" .. tostring(math.random(10000, 99999)) .. ".mp3"

					if not isfile(str8) then
						local v18 = readfile(v17)
						writefile(str8, v18)
						delfile(v17)
						local n4 = 0

						while isfile(v17) and n4 < 50 do
							task.wait()
							n4 += 1
						end
					end
				end
			end
		end)
	end
end

UpdatePlaylist = function()
	task.spawn(function()
		local tbl12 = {
			Musics = "YouTube Music Player/Musics",
			Videos = "YouTube Music Player/Videos",
			Roblox = "YouTube Music Player/Roblox IDS",
			Local = "YouTube Music Player/Local Audios",
		}

		FixNome()

		for _, v17 in pairs(tbl12) do
			if not isfolder(v17) then
				makefolder(v17)
			end
		end

		local function fn6(arg)
			local ok3, result3 = pcall(listfiles, arg)
			return ok3 and result3 or {}
		end

		local function fn7(arg)
			return arg:match("[^/\\]+$")
		end

		local function fn8(arg, arg2)
			return arg:gsub(arg2:gsub("%.", "%%."), "")
		end

		local tbl13 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }

		for _, v17 in pairs(BibliotecaMusicas) do
			tbl13.Musics[v17.id] = true
		end

		for _, v17 in pairs(BilbliotecaVideos) do
			tbl13.Videos[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaRoblox) do
			tbl13.Roblox[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaLocal) do
			tbl13.Local[v17.name] = true
		end

		local tbl14 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }
		local v17 = ipairs
		local v18 = fn6(tbl12.Musics)

		for _, v19 in v17(v18) do
			local v20 = fn8(fn7(v19), ".mp3")
			tbl14.Musics[v20] = true

			if not tbl13.Musics[v20] then
				task.spawn(function()
					local v21, v22, v23, v24 = ApiInfo(v20)
					if not (v21 and v22 and v23) then
						return
					end
					table.insert(BibliotecaMusicas, { id = v20, name = v21, author = v22, thumb = v23, authorUrl = v24 })
					fn5(v21, "Musica", v20)
				end)
			end
		end

		local v19 = ipairs
		local v20 = fn6(tbl12.Videos)

		for _, v21 in v19(v20) do
			local v22 = fn8(fn7(v21), ".webm")
			tbl14.Videos[v22] = true

			if not tbl13.Videos[v22] then
				task.spawn(function()
					local v23, v24, v25, v26 = ApiInfo(v22)
					if not (v23 and v24 and v25) then
						return
					end
					table.insert(BilbliotecaVideos, { id = v22, name = v23, author = v24, thumb = v25, authorUrl = v26 })
					fn5(v23, "Video", v22)
				end)
			end
		end

		local v21 = ipairs
		local v22 = fn6(tbl12.Roblox)

		for _, v23 in v21(v22) do
			local v24 = fn8(fn7(v23), ".rbx")
			tbl14.Roblox[v24] = true

			if not tbl13.Roblox[v24] then
				task.spawn(function()
					local v25, v26, v27, v28 = ApiRoblox(v24)
					if not (v25 and v26 and v27) then
						return
					end
					table.insert(BibliotecaRoblox, { id = v24, name = v25, creatorId = v26, creatorName = v27 })
					fn5(v25, "Roblox", v24, v28)
				end)
			end
		end

		local v23 = ipairs
		local v24 = fn6(tbl12.Local)

		for _, v25 in v23(v24) do
			local match = fn7(v25):match("^(.*)%.mp3$")
			tbl14.Local[match] = true

			if not tbl13.Local[match] then
				table.insert(BibliotecaLocal, { name = match })
				fn5(match, "Local", match)
			end
		end

		for i = #BibliotecaMusicas, 1, -1 do
			local v25 = BibliotecaMusicas[i]

			if not tbl14.Musics[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaMusicas, i)
			end
		end

		for i = #BilbliotecaVideos, 1, -1 do
			local v25 = BilbliotecaVideos[i]

			if not tbl14.Videos[v25.id] then
				Deletar(v25.id)
				table.remove(BilbliotecaVideos, i)
			end
		end

		for i = #BibliotecaRoblox, 1, -1 do
			local v25 = BibliotecaRoblox[i]

			if not tbl14.Roblox[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaRoblox, i)
			end
		end

		for i = #BibliotecaLocal, 1, -1 do
			local v25 = BibliotecaLocal[i]

			if not tbl14.Local[v25.name] then
				Deletar(v25.name)
				table.remove(BibliotecaLocal, i)
			end
		end
	end)
end

UpdatePlaylist()
CACHE_LINK = nil
KEY_ATUAL = nil
VIDEO_ATUAL = nil
DownloadAtual = nil
DOWNLOAD_SESSION = nil
DOWNLOAD_TOKEN = nil
DOWNLOAD_CLEARANCE = nil

ApiSearchFree = function(arg)
	local str6 = str3 .. "/search/youtube/free/" .. HttpService:UrlEncode(arg)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v17 = string.lower(result3)
	if string.find(v17, "too many requests") then
		return "rate"
	end

	if string.find(v17, "no results") then
		return "sem"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

ApiSearchPremium = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
	local v17 = HttpService
	local str6 = str3 .. "/search/youtube/premium/" .. tostring(arg) .. "/" .. tostring(arg2) .. "/" .. tostring(arg3) .. "/" .. tostring(arg4) .. "/" .. tostring(arg5) .. "/" .. tostring(YmpHwid()) .. "/" .. v17:UrlEncode(arg7)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v18 = string.lower(result3)
	if string.find(v18, "no results") then
		return "sem"
	end

	if string.find(v18, "request denied") then
		return "denied"
	end

	if string.find(v18, "too many requests") then
		return "rate"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

DownloadLog = function(arg, arg2)
	if not CheckRequest() then
		return
	end

	task.spawn(function()
		pcall(function()
			YmpRequest({
				Url = str3 .. "/dl",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode({ tipo = arg2, link = arg }),
			})
		end)
	end)
end

local tbl12 = {
	1116352408,
	1899447441,
	3049323471,
	3921009573,
	961987163,
	1508970993,
	2453635748,
	2870763221,
	3624381080,
	310598401,
	607225278,
	1426881987,
	1925078388,
	2162078206,
	2614888103,
	3248222580,
	3835390401,
	4022224774,
	264347078,
	604807628,
	770255983,
	1249150122,
	1555081692,
	1996064986,
	2554220882,
	2821834349,
	2952996808,
	3210313671,
	3336571891,
	3584528711,
	113926993,
	338241895,
	666307205,
	773529912,
	1294757372,
	1396182291,
	1695183700,
	1986661051,
	2177026350,
	2456956037,
	2730485921,
	2820302411,
	3259730800,
	3345764771,
	3516065817,
	3600352804,
	4094571909,
	275423344,
	430227734,
	506948616,
	659060556,
	883997877,
	958139571,
	1322822218,
	1537002063,
	1747873779,
	1955562222,
	2024104815,
	2227730452,
	2361852424,
	2428436474,
	2756734187,
	3204031479,
	3329325298,
}

local str6 = "https://p.savenow.to"
local str7 = "https://en.loader.to/"
local str8 = "dfcb6d76f2f6a9894gjkege8a4ab232222"
local n4 = 200
local n5 = 0.003
local n6 = 30

local str9 = str:gsub("^(%a+)%-(%a+)$", function(arg, arg2)
	return arg .. "-" .. arg2:upper()
end) .. "," .. (str:match("^(%a+)") or "en") .. ";q=0.9,en-US;q=0.8,en;q=0.7"

local v17 = nil
local n7 = 0
local flag21 = false

local function fn6(arg, arg2)
	return bit32.rrotate(arg, arg2)
end

local function fn7(...)
	local v18 = table.pack(...)
	local n8 = 0

	for i = 1, select("#", ...) do
		n8 = bit32.band(n8 + select(i, table.unpack(v18, 1, v18.n)), 4294967295)
	end

	return n8
end

local function fn8(arg)
	local n8 = #arg
	local tbl13 = { string.byte(arg, 1, n8) }
	local n9 = n8 * 8
	tbl13[#tbl13 + 1] = 128

	while #tbl13 % 64 ~= 56 do
		tbl13[#tbl13 + 1] = 0
	end

	local n10 = math.floor(n9 / 4294967296)
	local n11 = n9 % 4294967296

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n10, i), 255)
	end

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n11, i), 255)
	end

	local n12 = 1779033703
	local n13 = 3144134277
	local n14 = 1013904242
	local n15 = 2773480762
	local n16 = 1359893119
	local n17 = 2600822924
	local n18 = 528734635
	local n19 = 1541459225

	for i = 1, #tbl13, 64 do
		local tbl14 = {}

		for i2 = 0, 15 do
			local n20 = i + i2 * 4
			tbl14[i2 + 1] = bit32.bor(bit32.lshift(tbl13[n20], 24), bit32.lshift(tbl13[n20 + 1], 16), bit32.lshift(tbl13[n20 + 2], 8), tbl13[n20 + 3])
		end

		for i2 = 17, 64 do
			local v18 = tbl14[i2 - 15]
			local v19 = tbl14[i2 - 2]
			local rshift = bit32.rshift
			local v20 = bit32.bxor(fn6(v18, 7), fn6(v18, 18), rshift(v18, 3))
			local rshift2 = bit32.rshift
			local v21 = bit32.bxor(fn6(v19, 17), fn6(v19, 19), rshift2(v19, 10))
			tbl14[i2] = fn7(tbl14[i2 - 16], v20, tbl14[i2 - 7], v21)
		end

		local v18 = n16
		local v19 = n17
		local v20 = n18
		local v21 = n19
		local v22 = n12
		local v23 = n13
		local v24 = n14
		local v25 = n15

		for i2 = 1, 64 do
			local bxor = bit32.bxor
			local v26 = tbl12[i2]
			local v27 = tbl14[i2]
			local v28 = fn7(v21, bit32.bxor(fn6(v18, 6), fn6(v18, 11), fn6(v18, 25)), bxor(bit32.band(v18, v19), bit32.band(bit32.bnot(v18), v20)), v26, v27)
			local v29 = bit32.bxor(fn6(v22, 2), fn6(v22, 13), fn6(v22, 22))
			local band = bit32.band
			local v30 = bit32.bxor(bit32.band(v22, v23), bit32.band(v22, v24), band(v23, v24))
			local v31 = fn7(v29, v30)
			local v32 = fn7(v25, v28)
			v21 = v20
			v25 = v24
			v20 = v19
			v24 = v23
			v19 = v18
			v23 = v22
			v18 = v32
			v22 = fn7(v28, v31)
		end

		n12 = fn7(n12, v22)
		n13 = fn7(n13, v23)
		n14 = fn7(n14, v24)
		n15 = fn7(n15, v25)
		n16 = fn7(n16, v18)
		n17 = fn7(n17, v19)
		n18 = fn7(n18, v20)
		n19 = fn7(n19, v21)
	end

	return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", n12, n13, n14, n15, n16, n17, n18, n19)
end

local function fn9(arg, arg2)
	local num = tonumber(arg2)
	if not num then
		return nil
	end
	local str10 = string.rep("0", num)
	local n8 = #str10
	local str11 = tostring(arg) .. ":"
	local n9 = 0

	while true do
		local now = os.clock()
		local exitTo = nil

		while fn8(str11 .. tostring(n9)):sub(1, n8) ~= str10 do
			n9 += 1
			if n5 <= os.clock() - now then
				exitTo = 1
				break
			end
		end

		if exitTo == 1 then
			task.wait()
			continue
		end
		break
	end

	return tostring(n9)
end

local function fn10(arg, arg2)
	local tbl13 = {
		accept = "*/*",
		["accept-language"] = str9,
		referer = str7,
		["sec-ch-ua"] = "\"Chromium\";v=\"137\", \"Not/A)Brand\";v=\"24\"",
		["sec-ch-ua-mobile"] = "?1",
		["sec-ch-ua-platform"] = "\"Android\"",
		["sec-fetch-dest"] = "empty",
		["sec-fetch-mode"] = "cors",
		["sec-fetch-site"] = "cross-site",
	}

	if arg2 then
		tbl13["content-type"] = "application/json"
	end

	if arg then
		tbl13.authorization = "Bearer " .. arg
	end

	return tbl13
end

local function fn11(arg)
	if not arg then
		return nil
	end
	local body = arg.Body or arg.body
	if type(body) ~= "string" then
		return nil
	end
	local ok3, result3 = pcall(HttpService.JSONDecode, HttpService, body)
	if not ok3 or type(result3) ~= "table" then
		return nil
	end
	return result3
end

local function fn12()
	local now = os.time()
	if v17 and now < n7 - n6 then
		return v17
	end

	if flag21 then
		local now2 = os.clock()

		while flag21 do
			if not (os.clock() - now2 >= 10) then
				task.wait()
				continue
			end
			break
		end

		local now3 = os.time()
		if v17 and now3 < n7 - n6 then
			return v17
		end
	end

	flag21 = true

	local ok3, result3, result4 = pcall(function()
		local v18 = YmpRequest({ Url = str6 .. "/api/pow/challenge", Method = "GET", Headers = fn10() })
		local v19 = fn11(v18)
		if not v19 then
			return nil
		end

		if v19.salt == nil or v19.difficulty == nil or v19.expires_at == nil or v19.signature == nil then
			return nil
		end
		local v20 = fn9(v19.salt, v19.difficulty)
		if not v20 then
			return nil
		end

		local v21 = YmpRequest({
			Url = str6 .. "/api/pow/verify",
			Method = "POST",
			Headers = fn10(nil, true),
			Body = HttpService:JSONEncode({
				salt = v19.salt,
				difficulty = v19.difficulty,
				expires_at = v19.expires_at,
				signature = v19.signature,
				nonce = v20,
			}),
		})

		local v22 = fn11(v21)
		if not v22 or v22.success ~= true or type(v22.token) ~= "string" then
			return nil
		end
		return v22.token, tonumber(v22.expires_at) or tonumber(v19.expires_at) or os.time() + 300
	end)

	flag21 = false
	if not ok3 or type(result3) ~= "string" then
		return nil
	end
	v17 = result3
	n7 = tonumber(result4) or os.time() + 300
	return v17
end

local function fn13(arg, arg2, arg3)
	local now = os.clock()
	local v18 = fn12()
	local v19 = HttpService
	local str10 = "&apikey=" .. str8
	local str11 = str6 .. "/api/v2/download?format=" .. HttpService:UrlEncode(arg2) .. "&url=" .. v19:UrlEncode(arg) .. str10
	local v20 = fn10(v18)

	local ok3, result3 = pcall(function()
		return YmpRequest({ Url = str11, Method = "GET", Headers = v20 })
	end)

	if not ok3 then
		return "error"
	end
	local v21 = fn11(result3)
	if not v21 or v21.success == false or type(v21.progress_url) ~= "string" then
		return "error"
	end
	local progressUrl = v21.progress_url
	task.wait(2)
	local v22

	while true do
		v22 = nil

		if os.clock() - now <= n4 then
			local ok4, result4 = pcall(function()
				return YmpRequest({ Url = progressUrl, Method = "GET", Headers = v20 })
			end)

			if ok4 then
				local v23 = fn11(result4)

				if v23 then
					if v23.progress == 1000 and type(v23.download_url) == "string" then
						v22 = v23
						break
					else
						task.wait(2)
					end
				else
					task.wait(2)
				end
			else
				task.wait(2)
			end
		else
			break
		end
	end

	if not v22 then
		return "error"
	end
	local tbl13 = {}

	if type(v22.download_url) == "string" then
		tbl13[#tbl13 + 1] = v22.download_url
	end

	if type(v22.alternative_download_urls) == "table" then
		for _, alternativeDownloadUrl in ipairs(v22.alternative_download_urls) do
			if not (#tbl13 >= 4) then
				if type(alternativeDownloadUrl) == "table" and type(alternativeDownloadUrl.url) == "string" and alternativeDownloadUrl.url ~= v22.download_url then
					tbl13[#tbl13 + 1] = alternativeDownloadUrl.url
				end

				continue
			end

			break
		end
	end

	if #tbl13 == 0 then
		return "error"
	end
	DownloadLog(arg, arg3)
	local v23 = table.create(math.min(#tbl13, 4))

	for i = 1, math.min(#tbl13, 4) do
		v23[i] = "Download" .. i .. ": " .. tbl13[i]
	end

	return table.concat(v23, "\n")
end

DownloadMusic = function(arg)
	return fn13(arg, "mp3", "music")
end

DownloadVideo = function(arg)
	return fn13(arg, "360", "video")
end

DesativarBusca = function(arg)
	if arg then
		PesquisarBox.Text = Traducao.Processando
		PesquisarBox.Active = false
		PaginaFrame.Visible = false
		PaginaEsperandoFrame.Visible = true
	else
		PesquisarBox.Text = text
		PesquisarBox.Active = true
		PaginaFrame.Visible = true
		PaginaEsperandoFrame.Visible = false
	end
end

CancelarBusca = function()
	ScrollDownload.Visible = false
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)
	Aguardando.Visible = true
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
	DownloadFrameTexto.Visible = true
	Concluido.Visible = false
	PaginaFrame.Visible = false
	PaginaEsperandoFrame.Visible = true
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	FiltroFrame.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = false
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	DownloadAtual = nil

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end

Carregando = function(arg)
	if arg then
		flag12 = true
		Loading.Visible = true
		ScrollDownload.Visible = false
		Aguardando.Visible = false

		task.spawn(function()
			while flag12 do
				local v18 = Loading
				v18.Rotation = v18.Rotation + 5
				task.wait(0.04)
			end
		end)
	else
		flag12 = false
		Loading.Visible = false
	end
end

CarregandoRoblox = function(arg)
	if arg then
		if flag13 then
			return
		end
		flag13 = true
		Baixando.Visible = true

		task.spawn(function()
			while flag13 do
				local n8 = Baixando.Rotation + 360
				tween = v6:Create(Baixando, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Rotation = n8 })
				tween:Play()
				tween.Completed:Wait()
				local n9 = 0

				while n9 < 0.35 and flag13 do
					n9 += task.wait()
				end
			end
		end)
	else
		flag13 = false

		if tween then
			tween:Cancel()
			tween = nil
		end

		Baixando.Visible = false
		Baixando.Rotation = 0
	end
end

AddRoblox = function(arg)
	local str10 = "YouTube Music Player/Roblox IDS" .. "/" .. tostring(arg) .. ".rbx"

	pcall(function()
		if not isfolder("YouTube Music Player/Roblox IDS") then
			makefolder("YouTube Music Player/Roblox IDS")
		end

		writefile(str10, "")
	end)

	CancelarBusca()
	UpdatePlaylist()
end

TelaDownload = function(arg, arg2, arg3)
	VIDEO_ATUAL = arg
	ScrollDownload.Visible = false
	Formato.Visible = true
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. tostring(arg) .. ".jpg"

	if isfile and isfile(str10) then
		Thumbfor.Image = getcustomasset(str10)
		Thumbfor.ImageRectOffset = Vector2.new(0, 45)
		Thumbfor.ImageRectSize = Vector2.new(480, 270)
	else
		Thumbfor.Image = "rbxassetid://110787075859454"
		Thumbfor.ImageRectOffset = Vector2.new(0, 0)
		Thumbfor.ImageRectSize = Vector2.new(0, 0)
	end

	local str11 = "Youtube Music Player/Musics/" .. tostring(arg) .. ".mp3"
	local str12 = "Youtube Music Player/Videos/" .. tostring(arg) .. ".webm"
	local v18 = isfile and isfile(str11)
	local v19 = flag19 and isfile and isfile(str12)

	if v18 then
		BotaoMp3.BackgroundTransparency = 0.9
		BotaoMp3.AutoButtonColor = false
		NomeMp3.TextColor3 = Color3.fromRGB(20, 20, 20)
	else
		BotaoMp3.BackgroundTransparency = 0
		BotaoMp3.AutoButtonColor = true
		NomeMp3.TextColor3 = Color3.fromRGB(0, 191, 255)
	end

	if flag19 then
		if v19 then
			BotaoMp4.BackgroundTransparency = 0.9
			BotaoMp4.AutoButtonColor = false
			NomeMp4.TextColor3 = Color3.fromRGB(20, 20, 20)
		else
			BotaoMp4.BackgroundTransparency = 0
			BotaoMp4.AutoButtonColor = true
			NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
		end
	end

	TextoTituloFor.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. arg3 .. "</font>"
end

CriarResultado = function(arg, arg2, arg3, arg4, arg5, arg6)
	local tbl13 = {}
	local flag22 = false
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. arg2 .. ".jpg"
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0, 221, 0, 43)
	frame3.Position = UDim2.new(0, 7, 0, 5)
	frame3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	frame3.BorderSizePixel = 0
	frame3.Parent = ScrollDownload
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 60, 0, 43)
	imageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 25, 0, 10)
	frame4.Position = UDim2.new(0, 3, 0, 3)
	frame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame4.BackgroundTransparency = 0.5
	frame4.BorderSizePixel = 0
	frame4.Visible = arg6 ~= nil
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = tostring(arg6 or "00:00")
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 2, 1, 0)
	frame5.Position = UDim2.new(0, 60, 0, 0)
	frame5.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame5.BorderSizePixel = 0
	frame5.Parent = frame3
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(0, 108, 1, -6)
	textLabel2.Position = UDim2.new(0, 65, 0, 3)
	textLabel2.BackgroundTransparency = 1
	textLabel2.RichText = true
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s %s</font>", arg3, Traducao.De, arg4)
	textLabel2.Parent = frame3
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 2, 1, 0)
	frame6.Position = UDim2.new(0, 176, 0, 0)
	frame6.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 33, 0, 33)
	imageButton3.Position = UDim2.new(0, 183, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton3.AutoButtonColor = false
	imageButton3.Parent = frame3
	Corner(frame3, 5)
	Corner(imageLabel, 5)
	Corner(frame4, 5)
	Corner(imageButton3, 5)
	Stroke(frame3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton3, 50, 50, 50, 2)

	if arg == "Roblox" then
		local str11 = tostring(arg2) .. ".rbx"

		pcall(function()
			if isfolder and isfolder("YouTube Music Player/Roblox IDS") then
				for _, v18 in ipairs(listfiles("YouTube Music Player/Roblox IDS")) do
					if string.find(v18, str11) then
						flag22 = true
						break
					end
				end
			end
		end)

		imageButton3.Image = flag22 and "rbxassetid://75203635436406" or "rbxassetid://125446601626694"
		imageLabel.Image = "rbxassetid://112075012925512"
	else
		imageButton3.Image = "rbxassetid://126311565377599"

		task.spawn(function()
			if not pcall(function()
				if not isfolder("Youtube Music Player/Internal/Cache") then
					makefolder("Youtube Music Player/Internal/Cache")
				end

				local response = game:HttpGet(arg5)
				writefile(str10, response)
				imageLabel.Image = getcustomasset(str10)
				imageLabel.ImageRectOffset = Vector2.new(0, 45)
				imageLabel.ImageRectSize = Vector2.new(480, 270)
			end) then
				imageLabel.Image = "rbxassetid://110787075859454"
			end
		end)
	end

	table.insert(tbl13, imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" then
			if not flag19 then
				return
			end

			if flag22 then
				fn3(Traducao.Erro, Traducao.JaTemRoblox, 5)
			else
				AddRoblox(arg2)
			end
		else
			TelaDownload(arg2, arg3, arg4)
		end
	end))

	frame3.Destroying:Connect(function()
		for _, v18 in ipairs(tbl13) do
			v18:Disconnect()
		end

		if arg ~= "Roblox" then
			pcall(function()
				if delfile and isfile(str10) then
					delfile(str10)
				end
			end)
		end
	end)
end

organizarItens = function()
	n3 = 0

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child.Position = UDim2.new(0, 7, 0, n3 + 5)
			n3 += 58
		end
	end

	ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, n3 - 3)
end

Buscar = function(arg)
	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	DesativarBusca(true)
	Carregando(true)
	DownloadFrameTexto.Visible = false
	FiltroFrame.Visible = false

	local function fn14()
		DesativarBusca(false)
		Carregando(false)
	end

	local function fn15(arg2, arg3, arg4)
		ScrollDownload.Visible = false

		if arg4 then
			SemResultado.Visible = true
		else
			Erro.Visible = true
			Tutorial.Visible = true
		end

		DownloadFrameTexto.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s</font>", arg2, arg3)
		DownloadFrameTexto.Visible = true
		fn14()
	end

	if not CheckRequest() then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end
	local v18 = nil
	local flag22 = false

	task.spawn(function()
		if flag19 then
			v18 = ApiSearchPremium(tbl.Ordem or "relevance", tbl.Data or "any", tbl.Duracao or "any", tbl.Pagina or 1, KEY_ATUAL, YmpHwid(), arg)
		else
			v18 = ApiSearchFree(arg)
		end

		flag22 = true
	end)

	local now = tick()

	while true do
		task.wait(0.1)
		if not (flag22 or tick() - now > 15) then
			continue
		end
		break
	end

	if not flag22 or v18 == "error" or not v18 then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end

	if v18 == "denied" then
		fn15(Traducao.ErroCrackTitle, Traducao.ErroCrackText)
		return
	end

	if v18 == "rate" then
		fn15(Traducao.TooMany, Traducao.RateLi)
		return
	end

	if v18 == "sem" then
		fn15(Traducao.SemResutadoTitle, Traducao.SemResutadoText, true)
		return
	end

	for _, v19 in ipairs(v18) do
		if flag19 and v19.type == "roblox" then
			CriarResultado("Roblox", v19.id, v19.Name, v19.CreatorName, nil, nil)
		else
			CriarResultado("YouTube", v19.id, v19.name, v19.author, v19.thumbnail, v19.duration)
		end
	end

	fn14()
	ScrollDownload.Visible = true
end

SetPag = function(pagina)
	if not flag19 then
		return
	end

	if tbl.Pagina == pagina then
		return
	end
	tbl.Pagina = pagina
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") then
			local uiStroke = child:FindFirstChildOfClass("UIStroke")

			if child.Name == tostring(pagina) then
				child.BackgroundColor3 = Color3.fromRGB(139, 0, 0)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(255, 0, 0)
				end
			else
				child.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(50, 50, 50)
				end
			end
		end
	end
end

Baixar = function(arg)
	Formato.Visible = false
	FiltroFrame.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	DesativarBusca(true)
	CarregandoRoblox(true)
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Aguarde .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Dados .. "</font>"
	DownloadFrameTexto.Visible = true
	local v18 = VIDEO_ATUAL
	local str10 = "https://youtu.be/" .. tostring(v18)

	local function fn14(arg2)
		if type(arg2) ~= "string" then
			return nil
		end
		local tbl13 = {}

		for match in string.gmatch(arg2, "[^\n]+") do
			local v19, v20 = string.match(match, "Download(%d+):%s*(.+)")

			if v19 and v20 then
				tbl13[tonumber(v19)] = v20
			end
		end

		return tbl13
	end

	local v19

	if arg == "Musica" then
		v19 = DownloadMusic(str10)
	else
		v19 = nil

		if arg == "Video" then
			v19 = DownloadVideo(str10)
		end
	end

	if v19 == "error" or v19 == "rate" or v19 == "denied" or not CheckRequest() then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local v20 = fn14(v19)

	if not v20 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.MaisUmPauco .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Baixando .. "</font>"
	local v21 = nil

	for i = 1, 4 do
		local v22 = v20[i]

		if v22 and type(v22) == "string" then
			for i2 = 1, 2 do
				local ok3, result3 = pcall(function()
					return game:HttpGet(v22)
				end)

				if ok3 and result3 then
					v21 = result3
					break
				else
					task.wait(0.5)
				end
			end

			if not v21 then
				continue
			end
		else
			continue
		end

		break
	end

	if not v21 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local str11 = "YouTube Music Player/" .. (arg == "Video" and "Videos" or "Musics")
	local str12 = arg == "Video" and ".webm" or ".mp3"
	local str13 = str11 .. "/" .. tostring(v18) .. str12

	pcall(function()
		if not isfolder(str11) then
			makefolder(str11)
		end

		writefile(str13, v21)
	end)

	task.wait(1)
	UpdatePlaylist()
	CarregandoRoblox(false)
	DesativarBusca(false)
	Concluido.Visible = true

	if not frame.Visible or not Tela4.Visible then
		fn3(Traducao.Baixado, Traducao.Terminou, 10)
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Baixado .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Terminou .. "</font>"
end

for i = 1, 10 do
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 21, 0, 21)
	imageButton3.Position = UDim2.new(0, 3 + (i - 1) * 28, 0, 3)
	imageButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton3.BackgroundTransparency = 0.9
	imageButton3.Name = i
	imageButton3.Parent = ScrollPagina
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Text = tostring(i)
	textLabel.Parent = imageButton3
	Corner(imageButton3, 20)
	Stroke(imageButton3, 50, 50, 50, 1)
	local uiStroke = imageButton3:FindFirstChildOfClass("UIStroke")

	if i == 1 then
		imageButton3.BackgroundTransparency = 0
		imageButton3.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

		if uiStroke then
			uiStroke.Color = Color3.fromRGB(255, 0, 0)
		end
	end

	imageButton3.MouseButton1Click:Connect(function()
		if i == tbl.Pagina then
			return
		end

		if not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
			return
		end

		if Loading.Visible or Baixando.Visible then
			return
		end
		SetPag(i)
		Concluido.Visible = false
		DownloadFrameTexto.Visible = false
		SemResultado.Visible = false
		Erro.Visible = false
		Tutorial.Visible = false
		Novamente.Visible = false
		Buscar(text)
	end)
end

AplicarFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if not PaginaFrame.Visible then
		fn3(Traducao.Erro, Traducao.NaoPodeFiltro, 10)
		return
	end
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	SetPag(1)
	Buscar(text)
end)

RemoverFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if ordem == "relevance" and data == "any" and duracao == "any" then
		fn3(Traducao.Erro, Traducao.FiltrosJaPadrao, 10)
		return
	end
	ordem = "relevance"
	data = "any"
	duracao = "any"
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	fn3(Traducao.Sucesso, Traducao.FiltrosRemovidos, 5)

	if PaginaFrame.Visible then
		Formato.Visible = false
		ScrollDownload.Visible = true
		TextoTituloFor.Text = ""
		Thumbfor.Image = "rbxassetid://0"
		SetPag(1)
		Buscar(text)
	end
end)

Relevancia.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl2) do
		if v18 == ordem then
			ordem = tbl2[i % #tbl2 + 1]
			break
		end
	end

	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao[ordem:gsub("^%l", string.upper)]
end)

DataUpload.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl3) do
		if v18 == data then
			data = tbl3[i % #tbl3 + 1]
			break
		end
	end

	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao[data:gsub("^%l", string.upper)]
end)

Duracao.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl4) do
		if v18 == duracao then
			duracao = tbl4[i % #tbl4 + 1]
			break
		end
	end

	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao[duracao:gsub("^%l", string.upper)]
end)

Filtro.MouseButton1Click:Connect(function()
	if Loading.Visible or Baixando.Visible then
		return
	end

	if not FiltroFrame.Visible then
		tbl10 = {}

		for _, v18 in ipairs({
			DownloadFrameTexto,
			Aguardando,
			Loading,
			SemResultado,
			Formato,
			ScrollDownload,
			Concluido,
			SemResultado,
			Erro,
		}) do
			if v18.Visible then
				table.insert(tbl10, v18)
				v18.Visible = false
			end
		end

		FiltroFrame.Visible = true
	else
		for _, v18 in ipairs(tbl10) do
			if v18 then
				v18.Visible = true
			end
		end

		tbl10 = {}
		FiltroFrame.Visible = false
	end
end)

ClearSearch = function()
	pcall(function()
		if isfolder("Youtube Music Player/Internal/Cache") then
			local Cache = listfiles("Youtube Music Player/Internal/Cache")

			for _, v18 in ipairs(Cache) do
				if string.find(v18, "Search_") then
					delfile(v18)
				end
			end
		end
	end)
end

PesquisarBox.FocusLost:Connect(function()
	local match = PesquisarBox.Text:match("^%s*(.-)%s*$")
	if match == "" then
		PesquisarBox.Text = ""
		return
	end
	ClearSearch()
	text = tostring(match)
	SetPag(1)
	Buscar(text)
end)

PesquisarBox.Focused:Connect(function()
	CancelarBusca()
end)

Lupa.MouseButton1Down:Connect(function()
	if not PesquisarBox.Active then
		return
	end
	flag14 = PesquisarBox:IsFocused()
end)

Lupa.MouseButton1Click:Connect(function()
	if not PesquisarBox.Active then
		return
	end

	if flag14 then
		PesquisarBox:ReleaseFocus()
	else
		PesquisarBox:CaptureFocus()
	end
end)

BotaoMp3.MouseButton1Click:Connect(function()
	if isfile("YouTube Music Player/Musics" .. "/" .. tostring(VIDEO_ATUAL) .. ".mp3") then
		fn3(Traducao.Erro, Traducao.JaTemMusica, 5)
		return
	end
	Baixar("Musica")
	DownloadAtual = "M"
end)

BotaoMp4.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if isfile("YouTube Music Player/Videos" .. "/" .. tostring(VIDEO_ATUAL) .. ".webm") then
		fn3(Traducao.Erro, Traducao.JaTemVideo, 5)
		return
	end
	Baixar("Video")
	DownloadAtual = "V"
end)

BotaoCancelar.MouseButton1Click:Connect(function()
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
end)

Novamente.MouseButton1Click:Connect(function()
	if DownloadAtual == "M" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Musica")
	elseif DownloadAtual == "V" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Video")
	end
end)

Tutorial.MouseButton1Click:Connect(function()
	fn3(Traducao.LinkCopiado, Traducao.Tutorial, 8)
	YmpClipboard("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Tutorial.txt")
end)

ScrollDownload.ChildAdded:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

ScrollDownload.ChildRemoved:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

SetVolume = function(volume)
	sound2.Volume = volume
	Video.Volume = volume
	MiniVideo.Volume = volume
	VolumeBox.Text = tostring(volume)
end

SetPitch = function(playbackSpeed)
	sound2.PlaybackSpeed = playbackSpeed
	GiroSpeed = playbackSpeed
	GiroBackup = playbackSpeed
	PitchBox.Text = tostring(playbackSpeed)
end

SetEqualizer = function(lowGain, midGain, highGain)
	Equalizer.LowGain = lowGain
	Equalizer.MidGain = midGain
	Equalizer.HighGain = highGain
	GravesBox.Text = tostring(lowGain)
	MediosBox.Text = tostring(midGain)
	AgudosBox.Text = tostring(highGain)
end

EquaValue = function(arg, arg2)
	local v18 = string.match(string.gsub(string.gsub(arg, "^%s+", ""), "%s+$", ""), "-?%d+%.?%d*")
	if not v18 then
		return arg2
	end
	local num = tonumber(v18)
	if not num then
		return arg2
	end
	return (math.clamp(num, -1000, 1000))
end

SetEffect = function(arg)
	for _, child in pairs(sound2:GetChildren()) do
		if child:IsA("SoundEffect") then
			child:Destroy()
		end
	end

	SetPitch(1)
	SetEqualizer(1, 1, 1)
	if arg == "Nenhum" then
		return
	end

	if arg == "Reverb" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 2.6
		reverbSoundEffect.Density = 0.75
		reverbSoundEffect.Diffusion = 0.9
		reverbSoundEffect.WetLevel = -9
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(-1, 0, -3)
	elseif arg == "Echo" then
		local echoSoundEffect = Instance.new("EchoSoundEffect", sound2)
		echoSoundEffect.Delay = 0.7
		echoSoundEffect.Feedback = 0.5
		echoSoundEffect.WetLevel = -6
		echoSoundEffect.DryLevel = 0
	elseif arg == "Distortion" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.4
		SetEqualizer(-4, 2, -2)
	elseif arg == "Chorus" then
		local chorusSoundEffect = Instance.new("ChorusSoundEffect", sound2)
		chorusSoundEffect.Depth = 0.25
		chorusSoundEffect.Rate = 1.2
		chorusSoundEffect.Mix = 0.6
	elseif arg == "Flanger" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.4
		flangeSoundEffect.Rate = 2
		flangeSoundEffect.Mix = 0.5
	elseif arg == "Tremolo" then
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 0.5
		tremoloSoundEffect.Frequency = 8
	elseif arg == "Compressor" then
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -25
		compressorSoundEffect.Ratio = 15
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.1
	elseif arg == "Radio" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.25
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -10
		compressorSoundEffect.Ratio = 12
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.08
		local equalizerSoundEffect = Instance.new("EqualizerSoundEffect", sound2)
		equalizerSoundEffect.LowGain = -10
		equalizerSoundEffect.MidGain = 10
		equalizerSoundEffect.HighGain = -12
		SetPitch(0.97)
	elseif arg == "Cinema" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 5
		reverbSoundEffect.Density = 0.7
		reverbSoundEffect.WetLevel = -15
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(6, -2, 2)
	elseif arg == "Underwater" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 1.5
		reverbSoundEffect.Density = 1
		reverbSoundEffect.WetLevel = -6
		reverbSoundEffect.DryLevel = -4
		SetEqualizer(4, -12, -25)
	elseif arg == "Kid" then
		SetPitch(1.45)
		SetEqualizer(-5, 2, 4)
	elseif arg == "Robot" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.5
		flangeSoundEffect.Rate = 3
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 1
		tremoloSoundEffect.Frequency = 4
		SetEqualizer(-5, 5, 2)
	elseif arg == "Slowed" then
		SetPitch(0.72)
		Instance.new("DistortionSoundEffect", sound2).Level = 0.35
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 4
		reverbSoundEffect.WetLevel = -10
		SetEqualizer(8, -2, -12)
	end
end

SelecionarEqua = function(arg)
	local children = ScrollEqua:GetChildren()

	local function fn14(arg2)
		if not arg2:IsA("ImageButton") or arg2.Name == "Resetar" then
			return
		end
		local imageLabel = arg2:FindFirstChildOfClass("ImageLabel")
		arg2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Stroke(arg2, 50, 50, 50, 2)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end
	end

	for _, child in ipairs(children) do
		fn14(child)
	end

	local imageLabel = arg:FindFirstChildOfClass("ImageLabel")
	arg.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
	Stroke(arg, 255, 0, 0, 2)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	if arg.Name == "Nenhum" then
		SetEffect("Nenhum")
	elseif arg.Name == "Reverb" then
		SetEffect("Reverb")
	elseif arg.Name == "Echo" then
		SetEffect("Echo")
	elseif arg.Name == "Distortion" then
		SetEffect("Distortion")
	elseif arg.Name == "Chorus" then
		SetEffect("Chorus")
	elseif arg.Name == "Flanger" then
		SetEffect("Flanger")
	elseif arg.Name == "Tremolo" then
		SetEffect("Tremolo")
	elseif arg.Name == "Compressor" then
		SetEffect("Compressor")
	elseif arg.Name == "Radio" then
		SetEffect("Radio")
	elseif arg.Name == "Cinema" then
		SetEffect("Cinema")
	elseif arg.Name == "Underwater" then
		SetEffect("Underwater")
	elseif arg.Name == "Kid" then
		SetEffect("Kid")
	elseif arg.Name == "Robot" then
		SetEffect("Robot")
	elseif arg.Name == "Slowed" then
		SetEffect("Slowed")
	end
end

VolumeBox.FocusLost:Connect(function()
	SetVolume(EquaValue(VolumeBox.Text, 1))
end)

PitchBox.FocusLost:Connect(function()
	SetPitch(EquaValue(PitchBox.Text, 1))
end)

GravesBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

MediosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

AgudosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

for _, child in ipairs(ScrollEqua:GetChildren()) do
	if child:IsA("ImageButton") and child.Name ~= "Resetar" then
		child.MouseButton1Click:Connect(function()
			SelecionarEqua(child)
		end)
	end
end

ResetarEqua.MouseButton1Click:Connect(function()
	SetVolume(1)
	SetPitch(1)
	SelecionarEqua(Nenhum)
	fn3(Traducao.Sucesso, Traducao.RsetadoEqua, 5)
end)

NumeroGC = function(arg)
	if arg == false then
		ContadorJA.Visible = false
		ContadorJABO.Visible = false
		ContadorJANU.Text = "0"
		ContadorJANUBO.Text = "0"
		return
	end

	ContadorJA.Visible = not flag17
	ContadorJABO.Visible = true
	local text2 = ContadorJANUBO.Text
	if text2 == "9+" then
		return
	end
	local n8 = tonumber(text2) or 1

	if n8 < 9 then
		local n9 = n8 + 1
		ContadorJANU.Text = tostring(n9)
		ContadorJANUBO.Text = tostring(n9)
	else
		ContadorJANU.Text = "9+"
		ContadorJANUBO.Text = "9+"
	end
end

if websocket_ then
	Botao5.BackgroundTransparency = 0
	Icone5.BackgroundTransparency = 0
	Icone5.ImageTransparency = 0
	Nome5.TextColor3 = Color3.fromRGB(255, 255, 255)
	Stroke(Nome5, 0, 0, 0, 1.5)
end

Tela = function(arg)
	if arg == n then
		return
	end
	local tbl13 = { Tela1, Tela2, Tela3, Tela4, Tela5, Tela6 }
	local v18 = ScrollNave:FindFirstChild("Botao" .. arg)
	if arg == 5 and v18 and v18.BackgroundTransparency > 0 then
		fn3(Traducao.Erro, Traducao.ExploitIcomGC, 5)
		return
	end
	n = arg

	if arg == 5 then
		NumeroGC(false)
	end

	for i = 1, #tbl13 do
		tbl13[i].Visible = false
	end

	fn2("102702078778790")

	for _, child in ipairs(ScrollNave:GetChildren()) do
		if child:IsA("ImageButton") then
			child.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			local uiStroke = child:FindFirstChild("UIStroke")

			if uiStroke then
				uiStroke.Color = Color3.fromRGB(50, 50, 50)
			end

			local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

				if uiStroke2 then
					uiStroke2.Color = Color3.fromRGB(50, 50, 50)
				end
			end
		end
	end

	if tbl13[arg] then
		tbl13[arg].Visible = true
	end

	if v18 then
		local color = Color3.fromRGB(139, 0, 0)
		local color2 = Color3.fromRGB(255, 0, 0)

		if arg == 6 then
			color = Color3.fromRGB(255, 215, 0)
			color2 = Color3.fromRGB(184, 134, 11)
		end

		v18.BackgroundColor3 = color
		local uiStroke = v18:FindFirstChild("UIStroke")

		if uiStroke then
			uiStroke.Color = color2
		end

		local imageLabel = v18:FindFirstChildWhichIsA("ImageLabel")

		if imageLabel then
			local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

			if uiStroke2 then
				uiStroke2.Color = color2
			end
		end
	end
end

Botao1.MouseButton1Click:Connect(function()
	Tela(1)
end)

Botao2.MouseButton1Click:Connect(function()
	Tela(2)
end)

Botao3.MouseButton1Click:Connect(function()
	Tela(3)
end)

Botao4.MouseButton1Click:Connect(function()
	Tela(4)
end)

Botao5.MouseButton1Click:Connect(function()
	Tela(5)
end)

Botao6.MouseButton1Click:Connect(function()
	Tela(6)
end)

Discord.MouseButton1Click:Connect(function()
	if flag3 then
		return
	end
	flag3 = true
	local tween4 = v6:Create(UIScaleDis, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeDiscord, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleDis, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeDiscord, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3(Traducao.LinkCopiado, "https://discord.gg/kbh2dEdnYP", 10)
	YmpClipboard("https://discord.gg/kbh2dEdnYP")
	tween6.Completed:Wait()
	flag3 = false
end)

You.MouseButton1Click:Connect(function()
	if flag4 then
		return
	end
	flag4 = true
	local tween4 = v6:Create(UIScaleYou, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeYou, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleYou, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeYou, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3("YouTube", "@Termux_404", 10)
	tween6.Completed:Wait()
	flag4 = false
end)

local tbl13 = {}
local tween4 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, 6, 0, 6) })
local tween5 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 174, 0, 6) })
local tween6 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -54) })
local tween7 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -54) })
local create = v6.Create
local v18 = BarraProgresso
local tbl14 = { Position = UDim2.new(0, 6, 0, 103) }
tbl13[1] = tween4
tbl13[2] = tween5
tbl13[3] = tween6
tbl13[4] = tween7

do
	local values = table.pack(create(v6, v18, tweenInfo4, tbl14))
	table.move(values, 1, values.n, 5, tbl13)
end

tweensMostrar = tbl13
local tbl15 = {}
local tween8 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, -60, 0, 6) })
local tween9 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 235, 0, 6) })
local tween10 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -120) })
local tween11 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -120) })
local create2 = v6.Create
local v19 = BarraProgresso
local tbl16 = { Position = UDim2.new(0, 6, 0, 125) }
tbl15[1] = tween8
tbl15[2] = tween9
tbl15[3] = tween10
tbl15[4] = tween11

do
	local values = table.pack(create2(v6, v19, tweenInfo4, tbl16))
	table.move(values, 1, values.n, 5, tbl15)
end

tweensOcultar = tbl15
infoTweenMini = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
listaControlesMini = { MiniBack, MiniRetroceder, MiniPlay, MiniAvancar, MiniSkip, TelaCheia, FecharMini }

Exibir = function()
	if flag6 then
		return
	end
	flag6 = true
	fn2("123430321654900")
	task.wait(0.1)
	flag5 = not flag5
	local v20 = flag5 and tweensMostrar or tweensOcultar

	for _, v21 in ipairs(v20) do
		v21:Play()
	end

	v20[1].Completed:Wait()
	flag6 = false
end

BotaoTela.MouseButton1Click:Connect(function()
	Exibir()
end)

Repetir.MouseButton1Click:Connect(function()
	if Repetir.Image == "rbxassetid://72571947341676" then
		Repetir.Image = "rbxassetid://133261841375114"
		fn3(Traducao.PlayMode, Traducao.Repetir, 8)
		str4 = "nill"
		sound2.Looped = true
		Video.Looped = true
		MiniVideo.Looped = true
	elseif Repetir.Image == "rbxassetid://133261841375114" then
		Repetir.Image = "rbxassetid://70388482182322"
		fn3(Traducao.PlayMode, Traducao.Random, 8)
		str4 = "Random"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	else
		Repetir.Image = "rbxassetid://72571947341676"
		fn3(Traducao.PlayMode, Traducao.Auto, 8)
		str4 = "Auto"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	end
end)

Miniplayer.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if Miniplayer.Image == "rbxassetid://102723588572082" then
		Miniplayer.Image = "rbxassetid://84519235983477"
		fn2("85730811347567")
		SetMiniPlayer(true)
	elseif Miniplayer.Image == "rbxassetid://84519235983477" then
		Miniplayer.Image = "rbxassetid://102723588572082"
		fn2("85730811347567")
		SetMiniPlayer(false)
	end
end)

aplicarVisibilidadeMini = function(arg)
	flag11 = true
	local n8 = #listaControlesMini

	for _, v20 in ipairs(listaControlesMini) do
		if arg then
			v20.Visible = true
		end

		local tbl17 = {}

		if v20:IsA("ImageButton") or v20:IsA("ImageLabel") then
			tbl17.ImageTransparency = arg and 0 or 1
		end

		if v20:IsA("TextButton") or v20:IsA("TextLabel") then
			tbl17.TextTransparency = arg and 0 or 1
		end

		if v20.BackgroundTransparency ~= nil then
			tbl17.BackgroundTransparency = arg and 0 or 1
		end

		local tween12 = v6:Create(v20, infoTweenMini, tbl17)
		tween12:Play()

		tween12.Completed:Once(function()
			n8 -= 1

			if not arg then
				v20.Visible = false
			end

			if n8 <= 0 then
				flag11 = false
			end
		end)
	end
end

imageButton2.MouseButton1Click:Connect(function()
	if flag11 then
		return
	end

	if imageButton2:GetAttribute("Blocked") then
		return
	end

	if imageButton2:GetAttribute("Moved") then
		imageButton2:SetAttribute("Moved", false)
		return
	end
	estadoMiniUI = not estadoMiniUI
	aplicarVisibilidadeMini(estadoMiniUI)
end)

imageButton.MouseButton1Click:Connect(function()
	if imageButton:GetAttribute("Blocked") then
		return
	end

	if imageButton:GetAttribute("Moved") then
		imageButton:SetAttribute("Moved", false)
		return
	end
	imageButton.Visible = false
	frame.Visible = true

	if Tela5.Visible then
		NumeroGC(false)
	end

	fn2("122954374321453")
end)

BotaoFechar.MouseButton1Click:Connect(function()
	frame.Visible = false
	task.wait(0.2)
	imageButton.Visible = true
end)

animar = function(arg)
	if tbl8[arg] then
		return
	end
	tbl8[arg] = true
	local size = arg.Size
	local position = arg.Position

	if tbl9[arg] then
		for _, v20 in ipairs(tbl9[arg]) do
			v20:Cancel()
		end
	end

	tbl9[arg] = {}
	fn2("136328893130485")
	local tween12 = v6:Create(arg, tweenInfo5, { Size = size - UDim2.new(0, 6, 0, 6), Position = position + UDim2.new(0, 3, 0, 3) })
	local tween13 = v6:Create(arg, tweenInfo6, { Size = size, Position = position })
	local tween14 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 6 })
	local tween15 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = -6 })
	local tween16 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 0 })
	table.insert(tbl9[arg], tween12)
	table.insert(tbl9[arg], tween13)
	table.insert(tbl9[arg], tween14)
	table.insert(tbl9[arg], tween15)
	table.insert(tbl9[arg], tween16)
	tween12:Play()
	tween12.Completed:Wait()
	tween13:Play()
	tween14:Play()
	tween14.Completed:Wait()
	tween15:Play()
	tween15.Completed:Wait()
	tween16:Play()
	tween16.Completed:Wait()
	tbl8[arg] = nil
end

FecharMini.MouseButton1Click:Connect(function()
	fn2("85730811347567")
	Miniplayer.Image = "rbxassetid://102723588572082"
	SetMiniPlayer(false)
end)

Voltar.MouseButton1Click:Connect(function()
	Back()
	animar(Voltar)
end)

Retroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(Retroceder)
end)

Play.MouseButton1Click:Connect(function()
	Pause()
	animar(Play)
end)

Adiantar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(Adiantar)
end)

Pular.MouseButton1Click:Connect(function()
	Skip()
	animar(Pular)
end)

MiniBack.MouseButton1Click:Connect(function()
	Back()
	animar(MiniBack)
end)

MiniRetroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(MiniRetroceder)
end)

MiniPlay.MouseButton1Click:Connect(function()
	Pause()
	animar(MiniPlay)
end)

MiniAvancar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(MiniAvancar)
end)

MiniSkip.MouseButton1Click:Connect(function()
	Skip()
	animar(MiniSkip)
end)

TelaCheia.MouseButton1Click:Connect(function()
	if isAnimating then
		return
	end
	isAnimating = true
	flag10 = not flag10
	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
		TelaCheia.Image = "rbxassetid://104681366724942"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.29, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.29, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.29, 0)
	else
		udim24 = udim2
		TelaCheia.Image = "rbxassetid://73952228795506"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
	end

	local tween12 = v6:Create(imageButton2, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = udim24 })
	tween12:Play()

	tween12.Completed:Connect(function()
		isAnimating = false
	end)
end)

REPORT_ID = nil
REPORT_MOTIVO = nil

local function fn14(arg)
	if REPORT_MOTIVO == nil then
		fn3(Traducao.ReportErro, Traducao.ReportErro10, 8)
		return
	end
	local n8 = #REPORT_MOTIVO
	if n8 < 10 or n8 > 200 then
		fn3(Traducao.ReportErro, Traducao.ReportErro11, 8)
		return
	end
	Denunciar.Active = false
	CancelarReport.Active = false
	DenunciarTexto.Text = "..."
	CancelarReportTexto.Text = "..."

	local ok3, result3 = pcall(function()
		return YmpRequest({
			Url = str3 .. "/report",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), msgid = tostring(arg), reason = REPORT_MOTIVO }),
		})
	end)

	if ok3 then
		local str10 = tostring(result3.Body or result3):gsub("^\"", ""):gsub("\"$", "")

		if str10 == "request denied" then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 8)
		elseif str10 == "invalid report" then
			fn3(Traducao.ReportErro, Traducao.ReportErro2, 8)
		elseif str10 == "server error" then
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		elseif str10 == "too many reports" then
			fn3(Traducao.ReportErro, Traducao.ReportErro4, 8)
		elseif str10 == "reporting to oneself is not allowed" then
			fn3(Traducao.ReportErro, Traducao.ReportErro5, 8)
		elseif str10 == "already reported by you" then
			fn3(Traducao.ReportErro, Traducao.ReportErro6, 8)
		elseif str10 == "already reported by another" then
			fn3(Traducao.ReportErro, Traducao.ReportErro7, 8)
		elseif str10 == "banned" then
			fn3(Traducao.ReportErro, Traducao.ReportErro8, 8)
		elseif string.find(tostring(str10), "reported") then
			fn3(Traducao.ReportSucesso, Traducao.ReportSucesso2, 8)
			task.wait(0.5)
			REPORT_ID = nil
			REPORT_MOTIVO = nil
			TextoReportFrame.Text = ""
			MotivoBox.Text = ""
			FotoReport.Image = ""
			ReportFrame.Visible = false
			frame.Visible = true
		else
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		end
	else
		fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
	end

	task.wait(0.5)
	Denunciar.Active = true
	CancelarReport.Active = true
	DenunciarTexto.Text = "Report"
	CancelarReportTexto.Text = Traducao.Cancelar
end

Reportar = function(arg, arg2, image)
	REPORT_ID = arg2
	TextoReportFrame.Text = Traducao.AvisoReport1 .. " '{" .. arg .. "}' " .. Traducao.AvisoReport2
	FotoReport.Image = image
	ReportFrame.Visible = true
	frame.Visible = false
end

local function fn15(arg)
	if Warn.Visible then
		return
	end

	if v12 and v12.Playing then
		Pause()
	end

	if frame.Visible then
		frame.Visible = false
	end

	if imageButton.Visible then
		imageButton.Visible = false
	end

	if ReportFrame.Visible then
		REPORT_ID = nil
		TextoReportFrame.Text = ""
		FotoReport.Image = ""
		ReportFrame.Visible = false
	end

	task.wait(0.1)
	CloseWarn.BackgroundTransparency = 0.7
	CloseWarnTexto.TextColor3 = Color3.fromRGB(20, 20, 20)
	Warn.Visible = true
	BlurEffect.Size = 56
	fn2("107089652181213")
	TextoWarn.Text = Traducao.MsgMod .. " " .. arg
	task.wait(5)
	CloseWarn.BackgroundTransparency = 0
	CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
end

ProFinal = function()
	local n8 = ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y

	if tween3 then
		tween3:Cancel()
	end

	tween3 = v6:Create(ScrollGC, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(0, n8) })
	tween3:Play()
end

ChekFinal = function()
	local y = ScrollGC.CanvasPosition.Y
	return math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 5
end

local function fn16(arg, text2, arg2, arg3)
	layoutOrder += 1
	task.wait()

	local function fn17(arg4)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg4
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg4)
		end)

		return ok3 and result3 or arg4
	end

	local v20 = fn17(arg2 or "")
	local result3 = nil

	if arg ~= "ymp" then
		local num = tonumber(arg)
		if not num then
			return
		end

		if tbl11[num] then
			result3 = tbl11[num]
		else
			local ok3

			ok3, result3 = pcall(function()
				local response = game:HttpGet("https://users.roblox.com/v1/users/" .. num)

				return {
					displayName = game:GetService("HttpService"):JSONDecode(response).displayName,
					image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. num .. "&width=420&height=420&format=png",
				}
			end)

			if not ok3 or not result3 or not result3.displayName then
				return
			end
			tbl11[num] = result3
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 1, 0, 1)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
	frame4.BorderSizePixel = 0
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BackgroundTransparency = 1
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, 0, 1, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 17, 0, 17)
	imageButton4.Position = UDim2.new(0, 200, 0, 12)
	imageButton4.BackgroundTransparency = 1
	imageButton4.BorderSizePixel = 0
	imageButton4.Visible = arg ~= tostring(userId) and arg ~= "ymp"
	imageButton4.Parent = imageLabel
	local imageLabel2 = Instance.new("ImageLabel")
	imageLabel2.Size = UDim2.new(0, 10, 0, 10)
	imageLabel2.Position = UDim2.new(0, 4, 0, 4)
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Image = "rbxassetid://74995247007994"
	imageLabel2.Parent = imageButton4
	local textSize = game:GetService("TextService"):GetTextSize(v20, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 180, 0, textSize.Y + 10)
	frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame6.BackgroundTransparency = 0.7
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(0, 170, 0, textSize.Y)
	textLabel4.BackgroundTransparency = 1
	textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel4.Font = Enum.Font.SourceSansBold
	textLabel4.TextWrapped = true
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.TextYAlignment = Enum.TextYAlignment.Top
	textLabel4.TextSize = 14
	textLabel4.Text = v20
	textLabel4.Parent = frame6
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, v20, 5)
		YmpClipboard(v20)
	end)

	if arg == "ymp" then
		imageLabel.Image = "rbxassetid://83758613781843"
		imageLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		textLabel.Text = "YMP OFFICIAL"
		textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel2.Text = Traducao.Sistema
		textLabel2.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(imageButton4, 255, 255, 255, 1)
		Stroke(textLabel2, 255, 255, 255, 0.5)
		Stroke(textLabel3, 255, 255, 255, 0.5)
		Stroke(textLabel, 255, 255, 255, 0.5)
	else
		imageLabel.Image = result3.image and result3.image ~= "" and result3.image or "rbxassetid://106804518898726"
		textLabel.Text = result3.displayName
		textLabel2.Text = text2
		Stroke(imageLabel, 50, 50, 50, 1)
		Stroke(frame4, 50, 50, 50, 1)
		Stroke(frame5, 50, 50, 50, 1)
		Stroke(imageButton3, 50, 50, 50, 1)
		Stroke(imageButton4, 50, 50, 50, 1)
		Stroke(textLabel, 50, 50, 50, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(imageButton4, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	imageButton4.MouseButton1Click:Connect(function()
		if not flag19 then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 10)
			return
		end
		Reportar(text2, arg3, imageLabel.Image)
	end)

	if v21 then
		task.wait()
		ProFinal()
	end
end

local function fn17(arg, text2, arg2, arg3, arg4)
	layoutOrder += 1
	task.wait()
	local str10 = arg4 or ""

	local function fn18(arg5)
		local tbl17 = {}
		local n8 = 1

		while n8 <= #arg5 do
			local v20, v21, v22, v23 = string.find(arg5, "<:([%w_]+):(%d+)>", n8)

			if v20 then
				if v20 > n8 then
					table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8, v20 - 1) })
				end

				table.insert(tbl17, { tipo = "emoji", id = v23 })
				n8 = v21 + 1
			else
				table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8) })
				break
			end
		end

		return tbl17
	end

	local function fn19(arg5)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg5
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg5)
		end)

		return ok3 and result3 or arg5
	end

	local v20 = fn18(str10)

	for _, v21 in ipairs(v20) do
		if v21.tipo == "texto" then
			v21.valor = fn19(v21.valor)
		end
	end

	local tbl17 = {}

	for _, v21 in ipairs(v20) do
		if v21.tipo == "emoji" then
			local id = v21.id
			local str11 = "YouTube Music Player/internal/Cache/emoji_" .. id .. ".png"

			if isfile and isfile(str11) then
				tbl17[id] = getcustomasset(str11)
			else
				local ok3, result3 = pcall(function()
					return game:HttpGet("https://cdn.discordapp.com/emojis/" .. id .. ".png")
				end)

				ok3 = ok3 and result3 and writefile
				local str12 = "rbxassetid://110787075859454"

				if ok3 then
					if pcall(function()
						writefile(str11, result3)
					end) and getcustomasset then
						str12 = getcustomasset(str11)
					end
				end

				tbl17[id] = str12
			end
		end
	end

	local str11 = "YouTube Music Player/internal/Cache/Dc_" .. tostring(arg) .. ".jpg"
	local image

	if isfile and isfile(str11) then
		image = getcustomasset(str11)
	else
		local ok3, result3 = pcall(function()
			return game:HttpGet(arg3)
		end)

		ok3 = ok3 and writefile
		image = "rbxassetid://106804518898726"

		if ok3 then
			if pcall(function()
				writefile(str11, result3)
			end) and getcustomasset then
				image = getcustomasset(str11)
			end
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 4, 0, 4)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2 or ""
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(1, -10, 0, 0)
	frame6.AutomaticSize = Enum.AutomaticSize.Y
	frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame6.BackgroundTransparency = 0.7
	frame6.Parent = frame3
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, -7, 1, 0)
	textLabel3.Position = UDim2.new(0, 3, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout2.Wraps = true
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.Padding = UDim.new(0, 2)
	uiListLayout2.Parent = frame6
	local uiPadding3 = Instance.new("UIPadding")
	uiPadding3.PaddingLeft = UDim.new(0, 5)
	uiPadding3.PaddingTop = UDim.new(0, 5)
	uiPadding3.PaddingRight = UDim.new(0, 5)
	uiPadding3.PaddingBottom = UDim.new(0, 5)
	uiPadding3.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, arg4, 5)
		YmpClipboard(arg4)
	end)

	local function fn20(text3)
		if text3 == "" then
			return
		end
		local textLabel4 = Instance.new("TextLabel")
		textLabel4.BackgroundTransparency = 1
		textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel4.Font = Enum.Font.SourceSansBold
		textLabel4.TextSize = 14
		textLabel4.TextWrapped = true
		textLabel4.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4.TextYAlignment = Enum.TextYAlignment.Top
		textLabel4.Text = text3
		local textSize = game:GetService("TextService"):GetTextSize(text3, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
		local max = math.max
		local y = textSize.Y
		textLabel4.Size = UDim2.new(0, math.min(textSize.X, 170), 0, max(y, 21))
		textLabel4.Parent = frame6
	end

	local function fn21(arg5)
		local imageLabel2 = Instance.new("ImageLabel")
		imageLabel2.Size = UDim2.new(0, 21, 0, 21)
		imageLabel2.BackgroundTransparency = 1
		imageLabel2.Image = tbl17[arg5]
		imageLabel2.Parent = frame6
	end

	for _, v22 in ipairs(v20) do
		if v22.tipo == "texto" then
			fn20(v22.valor)
		else
			fn21(v22.id)
		end
	end

	if arg2 == "Mod" then
		textLabel.TextColor3 = Color3.fromRGB(255, 160, 122)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		frame5.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		imageButton3.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		textLabel2.Text = "Mod"
		textLabel2.TextColor3 = Color3.fromRGB(255, 160, 122)
		textLabel3.TextColor3 = Color3.fromRGB(255, 160, 122)
		Stroke(frame4, 255, 160, 122, 1)
		Stroke(imageLabel, 255, 160, 122, 1.5)
		Stroke(frame5, 255, 160, 122, 1)
		Stroke(imageButton3, 255, 160, 122, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Admin" then
		textLabel.TextColor3 = Color3.fromRGB(220, 20, 60)
		frame4.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		frame5.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		imageButton3.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		textLabel2.Text = "Admin"
		textLabel2.TextColor3 = Color3.fromRGB(220, 20, 60)
		textLabel3.TextColor3 = Color3.fromRGB(220, 20, 60)
		Stroke(frame4, 220, 20, 60, 1)
		Stroke(imageLabel, 220, 20, 60, 1)
		Stroke(frame5, 220, 20, 60, 1)
		Stroke(imageButton3, 220, 20, 60, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Dev" then
		textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		imageButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		textLabel2.Text = "Dev"
		textLabel2.TextColor3 = Color3.fromRGB(255, 215, 0)
		textLabel3.TextColor3 = Color3.fromRGB(255, 215, 0)
		Stroke(frame4, 0, 0, 0, 1.5)
		Stroke(imageLabel, 0, 0, 0, 1.5)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(frame5, 0, 0, 0, 1.5)
		Stroke(imageButton3, 0, 0, 0, 1.5)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	else
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		frame4.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		frame5.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		imageButton3.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		textLabel2.Text = "Discord"
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(textLabel, 0, 0, 0, 0.5)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(textLabel2, 0, 0, 0, 0.5)
		Stroke(textLabel3, 0, 0, 0, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	if v21 then
		task.wait()
		ProFinal()
	end
end

IndoFinal = function(arg)
	if arg == v13 then
		return
	end
	estadoAtual = arg
	local v20 = arg and udim23 or udim22

	if v13 then
		tween2:Cancel()
	end

	tween2 = v6:Create(FinalGC, tweenInfo3, { Position = v20 })
	tween2:Play()
end

ScrollGC:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	local y = ScrollGC.CanvasPosition.Y
	local flag22 = math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 120

	if flag22 ~= flag15 then
		flag15 = flag22
		IndoFinal(flag22)
	end
end)

FinalGC.MouseButton1Click:Connect(function()
	ProFinal()
end)

ScrollGC.ChildAdded:Connect(function()
	local tbl17 = {}
	EsperandoIMG.Visible = false
	ScrollGC.Visible = true

	for _, child in ipairs(ScrollGC:GetChildren()) do
		if child:IsA("Frame") then
			table.insert(tbl17, child)
		end
	end

	if #tbl17 > 30 then
		table.sort(tbl17, function(arg, arg2)
			return arg.LayoutOrder < arg2.LayoutOrder
		end)

		task.wait()
		tbl17[1]:Destroy()
	end
end)

local function fn18(arg)
	MsgErroGC.Visible = true
	MsgErroGC.Text = Traducao.GcBan .. " " .. tostring(arg or "")
	GCBox.Active = false
	GCBox.Visible = false
	SendGC.Visible = false
	Traduzir.Visible = false
	LinhaTraducao.Visible = false
	fn3(Traducao.Banido, Traducao.GcBan .. " " .. tostring(arg or ""), 10)
end

local function fn19()
	fn3(Traducao.Desbanido, Traducao.GcUnban, 10)

	if flag19 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	else
		MsgErroGC.Text = Traducao.GcKey
	end
end

local function fn20(arg)
	if arg == flag20 then
		return
	end

	if flag19 then
		return
	end

	if arg then
		if not flag16 and websocket_ ~= nil then
			flag20 = true
			MsgErroGC.Visible = false
			GCBox.Active = true
			GCBox.Visible = true
			SendGC.Visible = true
			Traduzir.Visible = true
			LinhaTraducao.Visible = true
			fn3(Traducao.Keyless, Traducao.KeylessOn, 15, 93360393539898)
		end
	elseif not flag19 and not flag16 then
		flag20 = false
		MsgErroGC.Visible = true
		MsgErroGC.Text = Traducao.GcKey
		GCBox.Active = false
		GCBox.Visible = false
		SendGC.Visible = false
		Traduzir.Visible = false
		LinhaTraducao.Visible = false
		fn3(Traducao.Keyless, Traducao.KeylessOff, 15, 93360393539898)
	end
end

hwidUrl = "wss://ymp-api.ddns.net/gc" .. "?hwid=" .. tostring(YmpHwid())

task.spawn(function()
	local flag22 = false
	local v20 = nil
	local n8 = 0
	local n9 = 0

	local function fn21()
		if not websocket_ then
			return
		end

		if flag22 then
			return
		end
		flag22 = true
		n8 += 1

		local ok3, result3 = pcall(function()
			local connect = websocket_.connect or websocket_.Connect or websocket_.new or websocket_.New
			if not connect then
				return nil
			end
			return connect(hwidUrl)
		end)

		if not ok3 or not result3 then
			flag22 = false
			return
		end
		v20 = result3
		flag22 = false

		if v20.OnClose then
			v20.OnClose:Connect(function()
				v20 = nil
			end)
		end

		local onMessage = result3.OnMessage or result3.onmessage or result3.MessageReceived

		if onMessage then
			onMessage:Connect(function(arg)
				if not arg then
					return
				end

				if arg == "keyless" then
					fn20(true)
					return
				end

				if arg == "unkeyless" then
					fn20(false)
					return
				end

				if arg:sub(1, 6) == "banned" then
					local match = arg:match("banned:%s*(%S+)")
					flag16 = true
					fn18(match)
					return
				end

				if arg == "unbanned" then
					flag16 = false
					fn19()
					return
				end

				if arg:sub(1, 6) == "warned" then
					fn15(arg:match("reason:%s*(.+)") or "")
					return
				end

				if arg:sub(1, 6) == "system" then
					local match = arg:match("message:%s*(.+)")

					if match then
						fn16("ymp", "a", match, "0")
						fn3(Traducao.Sistema, match, 10)
					else
						local match2 = arg:match("system\n(.+)")

						if match2 then
							fn16("ymp", "a", match2, "0")
						end
					end

					return
				end

				if arg:sub(1, 7) == "discord" then
					local match = arg:match("id:%s*([^\n]+)")
					local match2 = arg:match("name:%s*([^\n]+)")
					local match3 = arg:match("rank:%s*([^\n]+)")
					local match4 = arg:match("image:%s*([^\n]*)")
					local match5 = arg:match("message:%s*(.+)")

					if match and match2 and match3 and match5 then
						fn17(match, match2, match3, match4 ~= "" and match4 or nil, match5)
					end

					return
				end

				local match = arg:match("UserId:%s*(%d+)")
				local match2 = arg:match("id:%s*(%S+)")
				local match3 = arg:match("message:%s*(.+)")
				local match4 = arg:match("msgid:%s*(%d+)")

				if match and match2 and match3 then
					fn16(match, match2, match3, match4)
				end
			end)
		end
	end

	task.spawn(function()
		while task.wait(2) do
			if websocket_ then
				if not flag22 then
					if not v20 then
						if not (os.clock() - n9 < 3) then
							n9 = os.clock()
							fn21()
						end
					end
				end
			end
		end
	end)

	fn21()
end)

local function fn21(arg)
	if not arg or arg == "" then
		return
	end

	if not CheckRequest() then
		return
	end

	local v20 = YmpRequest({
		Url = str3 .. "/sendgc",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), Userid = userId, msg = arg }),
	})

	if v20 and v20.Body then
		local str10 = tostring(v20.Body):gsub("%s+", ""):gsub("\"", "")

		if str10 == "banned" then
			flag16 = true
			fn18()
		elseif str10 == "requestdenied" then
			fn3(Traducao.ErroCrackTitle, Traducao.ErroCrackText, 10)
		end
	end

	return v20
end

SendGC.MouseButton1Click:Connect(function()
	if Aviao.ImageTransparency ~= 0 then
		return
	end
	local text2 = GCBox.Text

	if text2 and text2 ~= "" then
		GCBox.Text = ""
		Aviao.ImageTransparency = 0.7
		fn21(text2)
		task.wait(3)
		Aviao.ImageTransparency = 0
	end
end)

GCBox.FocusLost:Connect(function()
	local match = GCBox.Text:gsub("[\r\n]", ""):match("^%s*(.-)%s*$")
	if match == "" then
		GCBox.Text = ""
		return
	end

	if #match > 200 then
		match = match:sub(1, 200)
	end

	GCBox.Text = match
end)

Regras.MouseButton1Click:Connect(function()
	fn3(Traducao.RegrasTi, Traducao.Regras, 10)
end)

NotificarGC.MouseButton1Click:Connect(function()
	if Sino.Image == "rbxassetid://115374069603142" then
		Sino.Image = "rbxassetid://89973491623305"
		fn3(Traducao.GCmudo, Traducao.GCmudoTexto, 6)
		flag17 = true
	else
		Sino.Image = "rbxassetid://115374069603142"
		fn3(Traducao.GCunmudo, Traducao.GCunmudoTexto, 6)
		flag17 = false
	end
end)

Denunciar.MouseButton1Click:Connect(function()
	if not Denunciar.Active then
		return
	end
	fn14(REPORT_ID)
end)

MotivoBox.FocusLost:Connect(function()
	local match = MotivoBox.Text:match("^%s*(.-)%s*$")

	if match == "" then
		MotivoBox.Text = ""
		REPORT_MOTIVO = nil
	else
		REPORT_MOTIVO = match
	end
end)

CancelarReport.MouseButton1Click:Connect(function()
	if not CancelarReport.Active then
		return
	end
	REPORT_ID = nil
	REPORT_MOTIVO = nil
	TextoReportFrame.Text = ""
	MotivoBox.Text = ""
	FotoReport.Image = ""
	ReportFrame.Visible = false
	frame.Visible = true
end)

CloseWarn.MouseButton1Click:Connect(function()
	if CloseWarn.BackgroundTransparency ~= 0 then
		return
	end
	Warn.Visible = false
	BlurEffect.Size = 0
	imageButton.Visible = true
	fn2("88442833509532")
end)

Traduzir.MouseButton1Click:Connect(function()
	if FotoTradu.Image == "rbxassetid://84867288877251" then
		FotoTradu.Image = "rbxassetid://72657045512999"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOn, 5)
	else
		FotoTradu.Image = "rbxassetid://84867288877251"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOff, 5)
	end
end)

Priv1.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri1, 8)
end)

Priv2.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri2, 8)
end)

Priv3.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri3, 8)
end)

Priv4.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri4, 8)
end)

Priv5.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri5, 8)
end)

Priv6.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri6, 8)
end)

local function fn22()
	pcall(function()
		game:GetService("Players").LocalPlayer:Kick("[Sussy Activity]\nPlease do not attempt to crack the script!")
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Remove()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Destroy()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer.Parent = nil
	end)

	task.wait(2)

	while true do
	end
end

LockedUIS = { Video, imageButton2, frame2 }

for _, v20 in ipairs(LockedUIS) do
	if v20:IsA("GuiObject") then
		v20:GetPropertyChangedSignal("Visible"):Connect(function()
			if v20.Visible == true and flag19 == false then
				fn22()
			end
		end)
	end
end

SetKey = function(key)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v20 = ok3 and result3
			local tbl17

			if v20 then
				tbl17 = v20
			else
				tbl17 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl17[1] = tbl17[1] or { Key = "", Favorites = {} }
			tbl17[1].Key = key or ""

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl17))
			end)
		end)

		processQueue()
	end)
end

local function fn23()
	if flag19 == true then
		return
	end
	flag19 = true
	KeyFrame.Visible = false
	GetKey.Visible = false
	PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
	frame2.Visible = true
	imageButton2.Parent = screenGui
	Video.Parent = Tela2
	BotaoMp4.BackgroundTransparency = 0
	NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
	BotaoMp4.AutoButtonColor = true
	AplicarFiltro.BackgroundTransparency = 0
	RemoverFiltro.BackgroundTransparency = 0
	NomeAplicarFiltro.TextColor3 = Color3.fromRGB(154, 205, 50)
	NomeRemoverFiltro.TextColor3 = Color3.fromRGB(178, 34, 34)
	AplicarFiltro.AutoButtonColor = true
	RemoverFiltro.AutoButtonColor = true
	PesquisarBox.PlaceholderText = Traducao.Pesquisar2
	imageButton.Image = "rbxassetid://76673896881913"
	fn3(Traducao.VocePremium, Traducao.VocePremiumTexto, 15)
	imageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Stroke(imageButton, 255, 215, 0, 3)

	if not flag16 and websocket_ ~= nil and not flag20 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	end

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") and child.Name ~= "1" then
			child.BackgroundTransparency = 0
			local textLabel = child:FindFirstChildOfClass("TextLabel")

			if textLabel then
				textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end

	for _, v20 in ipairs(scrolls) do
		for _, child in ipairs(v20:GetChildren()) do
			if child:IsA("ImageButton") and not child:GetAttribute("Privado") then
				local match = child.Name:match(":(.+)$")
				child.Name:match("^(.-):")
				local tag = child:FindFirstChild("tag")
				local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

				if match and tag and imageLabel then
					if match == "Video" or match == "Roblox" then
						child.BackgroundTransparency = 0
						imageLabel.BackgroundTransparency = 0
						imageLabel.ImageTransparency = 0
						tag.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	end
end

Token = nil

local function fn24()
	pcall(function()
		local fn25

		fn25 = function(arg, arg2)
			local tbl17 = arg2 or {}
			local kind = typeof(arg)
			if kind == "nil" then
				return "nil"
			end

			if kind == "string" then
				return arg
			end

			if kind == "number" then
				if arg ~= arg then
					return "nan"
				end
				local str10 = ""

				if arg < 0 then
					arg = -arg
					str10 = "-"
				end

				local n8 = math.floor(arg)
				local n9 = arg - n8
				local str11 = ""

				repeat
					str11 = string.char(48 + n8 % 10) .. str11
					n8 = math.floor(n8 / 10)
				until n8 == 0

				if n9 > 0 then
					str11 ..= "."
					local n10 = 0

					while n9 > 0 and n10 < 6 do
						local n11 = n9 * 10
						local n12 = math.floor(n11)
						str11 ..= string.char(48 + n12)
						n9 = n11 - n12
						n10 += 1
					end
				end

				return str10 .. str11
			end

			if kind == "boolean" then
				if arg then
					return "true"
				end
				return "false"
			end

			if kind == "table" then
				if tbl17[arg] then
					return "{cycle}"
				end
				tbl17[arg] = true
				local tbl18 = {}

				for k, v20 in pairs(arg) do
					table.insert(tbl18, "[" .. fn25(k, tbl17) .. "]=" .. fn25(v20, tbl17))
				end

				return "{ " .. table.concat(tbl18, ", ") .. " }"
			end

			return "<" .. kind .. ">"
		end

		local jobId = game.JobId
		local str10 = HttpService:GenerateGUID(false) .. HttpService:GenerateGUID(false) .. jobId .. tick() .. os.clock() .. os.time() .. os.date("%Y%m%d%H%M%S") .. math.random() .. fn25({})
		local n8 = 2166136261

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			local n9 = bit32.bxor(n8, v20) * 16777619 % 4294967296
			n8 = bit32.bxor(n9, bit32.rshift(n9, 13)) * 2246822519 % 4294967296
		end

		math.randomseed(n8)
		local str11 = ""
		local n9 = 1

		while true do
			local n10 = math.random(1, 62)
			local str12 = str11 .. string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", n10, n10)
			local n11 = bit32.bxor(n8, n10 * n9) * 3266489917 % 4294967296
			n8 = bit32.bxor(n11, bit32.lshift(n11, 11))

			if #str12 > 10 and bit32.band(n8, 3) == 0 then
				local n12 = math.floor(#str12 / 2)
				local str13 = string.sub(str12, 1, n12)
				str12 = string.sub(str12, n12 + 1) .. str13
			end

			if #str12 > 15 and bit32.band(n8, 7) == 1 then
				str11 = ""

				for i = #str12, 1, -1 do
					str11 ..= string.sub(str12, i, i)
				end
			else
				str11 = str12
			end

			local v20 = bit32.band(n8, 15)
			if not (#str11 > 110 and v20 == 0 or #str11 > 111) then
				n9 += 1
				continue
			end
			break
		end

		Token = str11
	end)
end

local function fn25(arg)
	local tbl17 = { bit32.bxor, bit32.lrotate, string.byte, string.format, tostring }

	if typeof(ishooked) == "function" and typeof(restorefunction) == "function" then
		local ok3, result3 = pcall(ishooked, ishooked)

		if ok3 and result3 then
			pcall(restorefunction, ishooked)
		end

		local v20 = ishooked

		for _, v21 in ipairs(tbl17) do
			local ok4, result4 = pcall(v20, v21)
			if not ok4 or result4 then
				return
			end
		end
	end

	local function fn26(arg2)
		local str10 = tostring(arg2 or "nil")
		local n8 = 2246822507
		local n9 = 3266489909
		local n10 = 2146245185

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			n8 = (bit32.lrotate(bit32.bxor(n8, v20 + i), 13) * 5 + 3864292196) % 4294967296
			n9 = (bit32.lrotate(bit32.bxor(n9, n8 + v20), 17) * 3 + 2246822507) % 4294967296
			n10 = (bit32.lrotate(bit32.bxor(n10, n9 + i), 19) * 7 + 2815685321) % 4294967296
		end

		local v20 = bit32.bxor(n8, n9, n10, 2674666769)
		local str11 = string.format("%08x%08x%08x%08x%08x", n8, n9, n10, 2674666769, v20)
		return (str11 .. string.reverse(str11)):sub(1, 40)
	end

	if arg == fn26(Token) and #Token > 110 then
		fn23()
	else
		SetKey("")
	end
end

local function fn26(arg)
	local now = os.clock()
	local flag22 = false
	local str10 = nil

	task.spawn(function()
		local v20 = HttpService
		local str11 = str3 .. "/check/" .. arg .. "/" .. YmpHwid() .. "/" .. v20:UrlEncode(Token)

		local ok3, result3 = pcall(function()
			return game:HttpGet(str11)
		end)

		if not CheckRequest() then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		if not (ok3 and result3) then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		local v21 = string.lower(result3)

		if string.find(v21, "request denied") then
			str10 = "invalid"
			flag22 = true
			return
		end

		if string.find(v21, "too many request") then
			str10 = "too"
			flag22 = true
			return
		end

		if string.find(v21, "already registered") then
			str10 = "already"
			flag22 = true
			return
		end

		local v22 = string.match(result3, "Ok:%s*(.+)")

		if not v22 then
			str10 = "error"
			flag22 = true
			return
		end

		task.wait(1)
		fn25(v22)
		SetKey(arg)
		str10 = "ok"
		flag22 = true
	end)

	while not flag22 do
		if os.clock() - now > 10 then
			return "error"
		end
		task.wait()
	end

	return str10 or "error"
end

local function fn27()
	if CACHE_LINK ~= nil then
		YmpClipboard(CACHE_LINK)
		fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
		return CACHE_LINK
	end

	if not CheckRequest() then
		return nil
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str3 .. "/getkey?hwid=" .. tostring(YmpHwid()))
	end)

	if not ok3 or not result3 then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	local data2 = nil

	pcall(function()
		data2 = game:GetService("HttpService"):JSONDecode(result3)
	end)

	if not data2 or not data2.success or not data2.url then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	CACHE_LINK = data2.url
	YmpClipboard(CACHE_LINK)
	fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
	return CACHE_LINK
end

SetaES.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		GetKey.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaES.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaDI.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(255, 255, 153)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		GetKey.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaES.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaDI.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
	end
end)

SetaDI.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		GetKey.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaES.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaDI.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(255, 255, 153)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		GetKey.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaES.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaDI.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
	end
end)

local function fn28(text2)
	fn3("Premium Key", text2, 5)
	KeyBox.Active = false
	KeyBox.TextColor3 = Color3.fromRGB(255, 0, 0)
	KeyBox.Text = text2
	task.wait(2)
	KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	KeyBox.Text = ""
	KeyBox.Active = true
end

local function fn29()
	if KEY_ATUAL and KEY_ATUAL ~= "" then
		KeyBox.Active = false
		fn24()

		if not KEY_ATUAL:match("^KEY_") and not KEY_ATUAL:match("^FREE_") then
			fn28(Traducao.KeyInvalida)
			SetKey("")
			return
		end

		local v20 = fn26(KEY_ATUAL)
		if v20 == true then
			return
		end

		if v20 == "invalid" then
			fn28(Traducao.KeyInvalida)
			SetKey("")
		elseif v20 == "error" then
			fn28(Traducao.KeyErro)
		elseif v20 == "already" then
			fn28(Traducao.JaTemKey)
		elseif v20 == "too" then
			fn28(Traducao.RateLi)
		end
	end
end

KeyBox.FocusLost:Connect(function()
	if KeyBox.Active and KeyBox.Text then
		local match = KeyBox.Text:match("^%s*(.-)%s*$")
		if match == "" then
			KeyBox.Text = ""
			return
		end
		KEY_ATUAL = match
		fn29()
	end
end)

GetKey.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		fn3(Traducao.LinkCopiado, "https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase", 8)
		YmpClipboard("https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase")
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		fn27()
	end
end)

uiScale = frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", frame)

Resize = function()
	local viewportSize = currentCamera.ViewportSize
	uiScale.Scale = math.min(viewportSize.X * 0.8 / frame.AbsoluteSize.X / uiScale.Scale, viewportSize.Y * 0.8 / frame.AbsoluteSize.Y / uiScale.Scale, 1)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)

	task.defer(function()
		if flag8 then
			return
		end
		local v20 = v12
		local flag22 = v12

		if v20 then
			flag22 = v20.TimeLength > 0
		end

		if flag22 then
			setProgress(v20.TimePosition / v20.TimeLength)
		end
	end)
end

ResizeJa = function()
	imageButton.AnchorPoint = Vector2.new(0.5, 0)
	imageButton.Position = UDim2.new(0.5, 0, 0, 20)
end

ResizeMiniPlayer = function()
	local viewportSize = currentCamera.ViewportSize

	if viewportSize.Y > viewportSize.X then
		udim2 = UDim2.new(0.45, 0, 0.1, 0)
	else
		udim2 = UDim2.new(0.27, 0, 0.37, 0)
	end

	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
	else
		udim24 = udim2
	end

	imageButton2.Size = udim24
	imageButton2.Position = UDim2.new(1, -20, 1, -20)
end

currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	Resize()
	ResizeJa()
	ResizeMiniPlayer()
end)

Resize()
ResizeJa()
ResizeMiniPlayer()

game:GetService("GuiService").MenuOpened:Connect(function()
	if flag or not frame.Visible then
		return
	end
	frame.Visible = false
	imageButton.Visible = true
end)

v5.MessageOut:Connect(function(arg)
	if type(arg) ~= "string" then
		return
	end
	local str10 = arg:lower():gsub("%s+", "")

	if str10:match("^failedtoloadrbxasset://.+%.mp3$") or str10:match("^failedtoloadrbxasset://.+%.webm$") then
		fn3(Traducao.MidiaErro, Traducao.MidiaErroMsg, 10)
	end
end)

Corner(frame, 5)
Corner(imageButton, 30)
Corner(ContadorJA, 30)
Corner(ContadorJABO, 30)
Corner(Titulo, 30)
Corner(Mutar, 30)
Corner(BotaoFechar, 22)
Corner(Welcome, 5)
Corner(Navegacao, 5)
Corner(Playlist, 5)
Corner(TituloNave, 32)
Corner(FotoNave, 32)
Corner(TituloPlayL, 32)
Corner(FotoPlayL, 32)
Corner(Botao1, 5)
Corner(Botao2, 5)
Corner(Botao3, 5)
Corner(Botao4, 5)
Corner(Botao5, 5)
Corner(Botao6, 5)
Corner(Icone1, 5)
Corner(Icone2, 5)
Corner(Icone3, 5)
Corner(Icone4, 5)
Corner(Icone5, 5)
Corner(Icone6, 5)
Corner(EsquerdaPL, 5)
Corner(FrameAbaPL, 5)
Corner(DireitaPL, 5)
Corner(ErroPL, 5)
Corner(Dev, 5)
Corner(FotoDev, 50)
Corner(Social, 5)
Corner(SocialTitulo, 5)
Corner(You, 32)
Corner(IconeYou, 32)
Corner(Discord, 32)
Corner(IconeDiscord, 32)
Corner(Musica, 5)
Corner(Video, 5)
Corner(TempoAtual, 5)
Corner(TempoTotal, 5)
Corner(Repetir, 30)
Corner(Novamente, 30)
Corner(Miniplayer, 30)
Corner(BarraProgresso, 30)
Corner(Rastro, 30)
Corner(BolaProgresso, 30)
Corner(MicroBola, 10)
Corner(PlayerInfo, 5)
Corner(FotoAutor, 50)
Corner(Disco, 50)
Corner(Controles, 5)
Corner(Voltar, 40)
Corner(Retroceder, 40)
Corner(Play, 40)
Corner(Adiantar, 40)
Corner(Pular, 40)
Corner(MiniMusica, 10)
Corner(MiniVideo, 10)
Corner(MiniBack, 2, 0)
Corner(MiniRetroceder, 2, 0)
Corner(MiniPlay, 1, 0)
Corner(MiniAvancar, 1, 0)
Corner(MiniSkip, 1, 0)
Corner(TelaCheia, 1, 0)
Corner(FecharMini, 1, 0)
Corner(TituloEqua, 5)
Corner(EquaFrame, 5)
Corner(NoEquaFrame, 5)
Corner(ErroEqua, 5)
Corner(Volume, 5)
Corner(IconeVolume, 5)
Corner(Pitch, 5)
Corner(IconePitch, 5)
Corner(FrequenciaTitulo, 5)
Corner(Graves, 5)
Corner(IconeGraves, 5)
Corner(Medios, 5)
Corner(IconeMedios, 5)
Corner(Agudos, 5)
Corner(IconeAgudos, 5)
Corner(EfeitosTitulo, 5)
Corner(Nenhum, 5)
Corner(IconeNenhum, 5)
Corner(Reverb, 5)
Corner(IconeReverb, 5)
Corner(Echo, 5)
Corner(IconeEcho, 5)
Corner(Distortion, 5)
Corner(IconeDistortion, 5)
Corner(Chorus, 5)
Corner(IconeChorus, 5)
Corner(Flanger, 5)
Corner(IconeFlanger, 5)
Corner(Tremolo, 5)
Corner(IconeTremolo, 5)
Corner(Compressor, 5)
Corner(IconeCompressor, 5)
Corner(Radio, 5)
Corner(IconeRadio, 5)
Corner(Cinema, 5)
Corner(IconeCinema, 5)
Corner(Underwater, 5)
Corner(IconeUnderwater, 5)
Corner(Kid, 5)
Corner(IconeKid, 5)
Corner(Robot, 5)
Corner(IconeRobot, 5)
Corner(Slowed, 5)
Corner(IconeSlowed, 5)
Corner(ResetarEqua, 5)
Corner(Pesquisa, 5)
Corner(Lupa, 5)
Corner(Filtro, 5)
Corner(DownloadFrame, 5)
Corner(PaginaFrame, 5)
Corner(PaginaEsperandoFrame, 5)
Corner(PaginaEsperandoIcon, 5)
Corner(SemResultadoTexto, 5)
Corner(ErroTexto, 5)
Corner(Tutorial, 30)
Corner(BaixandoTexto, 5)
Corner(DownloadFrameTexto, 5)
Corner(Relevancia, 5)
Corner(DataUpload, 5)
Corner(Duracao, 5)
Corner(IconeRelevancia, 5)
Corner(IconeDataUpload, 5)
Corner(IconeDuracao, 5)
Corner(AplicarFiltro, 5)
Corner(RemoverFiltro, 5)
Corner(Thumbfor, 5)
Corner(Titulofor, 5)
Corner(TituloFiltro, 30)
Corner(TituloFormato, 30)
Corner(BotaoMp3, 5)
Corner(BotaoMp4, 5)
Corner(BotaoCancelar, 5)
Corner(TituloGC, 5)
Corner(GCFrame, 5)
Corner(Traduzir, 5)
Corner(SendGC, 5)
Corner(MsgFrame, 5)
Corner(AvisoGC, 30)
Corner(FinalGC, 32)
Corner(TituloPremium, 5)
Corner(Privilegios, 5)
Corner(Priv1, 35)
Corner(Priv2, 35)
Corner(Priv3, 35)
Corner(Priv4, 35)
Corner(Priv5, 35)
Corner(Priv6, 35)
Corner(IconePriv1, 35)
Corner(IconePriv2, 35)
Corner(IconePriv3, 35)
Corner(IconePriv4, 35)
Corner(IconePriv5, 35)
Corner(IconePriv6, 35)
Corner(frame2, 5)
Corner(PremiumOkTexto, 5)
Corner(KeyFrame, 5)
Corner(SendKey, 5)
Corner(GetKey, 5)
Corner(SetaES, 5)
Corner(SetaDI, 5)
Corner(ReportFrame, 5)
Corner(TituloReportFrame, 30)
Corner(TextoReportFrameFrame, 5)
Corner(Motivo, 5)
Corner(CancelarReport, 7)
Corner(FotoReport, 50)
Corner(Denunciar, 7)
Corner(Warn, 5)
Corner(TituloWarn, 30)
Corner(TextoWarnFrame, 5)
Corner(CloseWarn, 7)
Stroke(frame, 255, 0, 0, 5)
Stroke(imageButton, 255, 255, 255, 3)
Stroke(ContadorJA, 255, 255, 255, 1)
Stroke(ContadorJANU, 255, 255, 255, 0.5)
Stroke(ContadorJABO, 255, 255, 255, 1)
Stroke(ContadorJANUBO, 255, 255, 255, 0.5)
Stroke(Mutar, 255, 255, 255, 1)
Stroke(BotaoFechar, 255, 255, 255, 1)
Stroke(Titulo, 50, 50, 50, 1.5)
Stroke(TextoTitulo, 0, 0, 0, 1.5)
Stroke(Welcome, 50, 50, 50, 1.5)
Stroke(NomeWelcome, 255, 255, 255, 1)
Stroke(Navegacao, 50, 50, 50, 1.5)
Stroke(Playlist, 50, 50, 50, 1.5)
Stroke(TituloNave, 255, 255, 255, 1)
Stroke(FotoNave, 255, 255, 255, 1)
Stroke(NomeNave, 255, 255, 255, 1)
Stroke(TituloPlayL, 255, 255, 255, 1)
Stroke(FotoPlayL, 255, 255, 255, 1)
Stroke(NomePlayL, 255, 255, 255, 1)
Stroke(AbaPL, 255, 255, 255, 1)
Stroke(Botao1, 255, 0, 0, 2)
Stroke(Botao2, 50, 50, 50, 2)
Stroke(Botao3, 50, 50, 50, 2)
Stroke(Botao4, 50, 50, 50, 2)
Stroke(Botao5, 50, 50, 50, 2)
Stroke(Botao6, 50, 50, 50, 2)
Stroke(Icone1, 255, 0, 0, 2)
Stroke(Icone2, 50, 50, 50, 2)
Stroke(Icone3, 50, 50, 50, 2)
Stroke(Icone4, 50, 50, 50, 2)
Stroke(Icone5, 50, 50, 50, 2)
Stroke(Icone6, 50, 50, 50, 2)
Stroke(Nome1, 0, 0, 0, 1.5)
Stroke(Nome2, 0, 0, 0, 1.5)
Stroke(Nome3, 0, 0, 0, 1.5)
Stroke(Nome4, 0, 0, 0, 1.5)
Stroke(Nome6, 0, 0, 0, 1.5)
Stroke(EsquerdaPL, 255, 255, 255, 1)
Stroke(FrameAbaPL, 255, 255, 255, 1)
Stroke(DireitaPL, 255, 255, 255, 1)
Stroke(Dev, 50, 50, 50, 1.5)
Stroke(FotoDev, 178, 34, 34, 1.5)
Stroke(TextoDev, 0, 0, 0, 2)
Stroke(Social, 50, 50, 50, 1.5)
Stroke(SocialTitulo, 50, 50, 50, 1.5)
Stroke(SocialTexto, 0, 0, 0, 2)
Stroke(Discord, 0, 0, 0, 1.5)
Stroke(IconeDiscord, 0, 0, 0, 1.5)
Stroke(TextoDiscord, 0, 0, 0, 1.5)
Stroke(You, 255, 255, 255, 1.5)
Stroke(IconeYou, 255, 255, 255, 1.5)
Stroke(TextoYou, 0, 0, 0, 1.5)
Stroke(Musica, 50, 50, 50, 1.5)
Stroke(Video, 50, 50, 50, 1.5)
Stroke(TempoAtual, 50, 50, 50, 1)
Stroke(TempoTotal, 50, 50, 50, 1)
Stroke(Repetir, 50, 50, 50, 1)
Stroke(Novamente, 50, 50, 50, 1)
Stroke(Miniplayer, 50, 50, 50, 1)
Stroke(BolaProgresso, 255, 255, 255, 1)
Stroke(BarraProgresso, 50, 50, 50, 1.5)
Stroke(PlayerInfo, 50, 50, 50, 1.5)
Stroke(FotoAutor, 178, 34, 34, 1.5)
Stroke(Disco, 178, 34, 34, 1.5)
Stroke(Controles, 178, 34, 34, 1.5)
Stroke(Voltar, 255, 255, 255, 1)
Stroke(Retroceder, 255, 255, 255, 1)
Stroke(Play, 255, 255, 255, 1)
Stroke(Adiantar, 255, 255, 255, 1)
Stroke(Pular, 255, 255, 255, 1)
Stroke(TituloMusica, 0, 0, 0, 1)
Stroke(MiniMusica, 255, 255, 255, 1, 0.5)
Stroke(MiniVideo, 255, 255, 255, 1, 0.5)
Stroke(TituloEqua, 50, 50, 50, 1.5)
Stroke(NomeEqua, 255, 255, 255, 1)
Stroke(EquaFrame, 50, 50, 50, 1.5)
Stroke(NoEquaFrame, 50, 50, 50, 1.5)
Stroke(Volume, 50, 50, 50, 2)
Stroke(IconeVolume, 50, 50, 50, 2)
Stroke(VolumeBox, 0, 0, 0, 1)
Stroke(Pitch, 50, 50, 50, 2)
Stroke(IconePitch, 50, 50, 50, 2)
Stroke(PitchBox, 0, 0, 0, 1)
Stroke(FrequenciaTitulo, 50, 50, 50, 2)
Stroke(TextoFrenquencia, 255, 255, 255, 0.4)
Stroke(Graves, 50, 50, 50, 2)
Stroke(IconeGraves, 50, 50, 50, 2)
Stroke(GravesBox, 0, 0, 0, 1)
Stroke(Medios, 50, 50, 50, 2)
Stroke(IconeMedios, 50, 50, 50, 2)
Stroke(MediosBox, 0, 0, 0, 1)
Stroke(Agudos, 50, 50, 50, 2)
Stroke(IconeAgudos, 50, 50, 50, 2)
Stroke(AgudosBox, 0, 0, 0, 1)
Stroke(EfeitosTitulo, 50, 50, 50, 2)
Stroke(Nenhum, 255, 0, 0, 2)
Stroke(IconeNenhum, 255, 0, 0, 2)
Stroke(NenhumTexto, 0, 0, 0, 1)
Stroke(Reverb, 50, 50, 50, 2)
Stroke(IconeReverb, 50, 50, 50, 2)
Stroke(ReverbTexto, 0, 0, 0, 1)
Stroke(Echo, 50, 50, 50, 2)
Stroke(IconeEcho, 50, 50, 50, 2)
Stroke(EchoTexto, 0, 0, 0, 1)
Stroke(Distortion, 50, 50, 50, 2)
Stroke(IconeDistortion, 50, 50, 50, 2)
Stroke(DistortionTexto, 0, 0, 0, 1)
Stroke(Chorus, 50, 50, 50, 2)
Stroke(IconeChorus, 50, 50, 50, 2)
Stroke(ChorusTexto, 0, 0, 0, 1)
Stroke(Flanger, 50, 50, 50, 2)
Stroke(IconeFlanger, 50, 50, 50, 2)
Stroke(FlangerTexto, 0, 0, 0, 1)
Stroke(Tremolo, 50, 50, 50, 2)
Stroke(IconeTremolo, 50, 50, 50, 2)
Stroke(TremoloTexto, 0, 0, 0, 1)
Stroke(Compressor, 50, 50, 50, 2)
Stroke(IconeCompressor, 50, 50, 50, 2)
Stroke(CompressorTexto, 0, 0, 0, 1)
Stroke(Radio, 50, 50, 50, 2)
Stroke(IconeRadio, 50, 50, 50, 2)
Stroke(RadioTexto, 0, 0, 0, 1)
Stroke(Cinema, 50, 50, 50, 2)
Stroke(IconeCinema, 50, 50, 50, 2)
Stroke(CinemaTexto, 0, 0, 0, 1)
Stroke(Underwater, 50, 50, 50, 2)
Stroke(IconeUnderwater, 50, 50, 50, 2)
Stroke(UnderwaterTexto, 0, 0, 0, 1)
Stroke(Kid, 50, 50, 50, 2)
Stroke(IconeKid, 50, 50, 50, 2)
Stroke(KidTexto, 0, 0, 0, 1)
Stroke(Robot, 50, 50, 50, 2)
Stroke(IconeRobot, 50, 50, 50, 2)
Stroke(RobotTexto, 0, 0, 0, 1)
Stroke(Slowed, 50, 50, 50, 2)
Stroke(IconeSlowed, 50, 50, 50, 2)
Stroke(SlowedTexto, 0, 0, 0, 1)
Stroke(ResetarEqua, 20, 20, 20, 2)
Stroke(ResetarTexto, 255, 255, 255, 1)
Stroke(TextoEfeitos, 255, 255, 255, 0.4)
Stroke(Pesquisa, 50, 50, 50, 1.5)
Stroke(Lupa, 50, 50, 50, 1.5)
Stroke(PesquisarBox, 255, 0, 0, 0.3)
Stroke(Filtro, 50, 50, 50, 2)
Stroke(Tutorial, 50, 50, 50, 1.5)
Stroke(TutoTexto, 255, 255, 255, 0.5)
Stroke(DownloadFrame, 50, 50, 50, 1.5)
Stroke(PaginaFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoIcon, 50, 50, 50, 1.5)
Stroke(Relevancia, 50, 50, 50, 2)
Stroke(DataUpload, 50, 50, 50, 2)
Stroke(Duracao, 50, 50, 50, 2)
Stroke(IconeRelevancia, 50, 50, 50, 2)
Stroke(IconeDataUpload, 50, 50, 50, 2)
Stroke(IconeDuracao, 50, 50, 50, 2)
Stroke(AplicarFiltro, 50, 50, 50, 2)
Stroke(RemoverFiltro, 50, 50, 50, 2)
Stroke(Thumbfor, 50, 50, 50, 1.5)
Stroke(Titulofor, 50, 50, 50, 1.5)
Stroke(BotaoMp3, 50, 50, 50, 1.5)
Stroke(BotaoMp4, 50, 50, 50, 1.5)
Stroke(BotaoCancelar, 50, 50, 50, 1.5)
Stroke(TituloGC, 50, 50, 50, 1.5)
Stroke(NomeGC, 255, 255, 255, 1)
Stroke(GCFrame, 50, 50, 50, 1.5)
Stroke(MsgFrame, 50, 50, 50, 1)
Stroke(Traduzir, 50, 50, 50, 1)
Stroke(SendGC, 50, 50, 50, 1)
Stroke(FinalGC, 255, 255, 255, 1)
Stroke(TituloPremium, 50, 50, 50, 1.5)
Stroke(NomePremium, 0, 0, 200, 1)
Stroke(Privilegios, 50, 50, 50, 1.5)
Stroke(Priv1, 0, 0, 0, 2)
Stroke(Priv2, 0, 0, 0, 2)
Stroke(Priv3, 0, 0, 0, 2)
Stroke(Priv4, 0, 0, 0, 2)
Stroke(Priv5, 0, 0, 0, 2)
Stroke(Priv6, 0, 0, 0, 2)
Stroke(IconePriv1, 0, 0, 0, 2)
Stroke(IconePriv2, 0, 0, 0, 2)
Stroke(IconePriv3, 0, 0, 0, 2)
Stroke(IconePriv4, 0, 0, 0, 1.5)
Stroke(IconePriv5, 0, 0, 0, 2)
Stroke(IconePriv6, 0, 0, 0, 2)
Stroke(TextoPriv1, 0, 0, 0, 1)
Stroke(TextoPriv2, 0, 0, 0, 1)
Stroke(TextoPriv3, 0, 0, 0, 1)
Stroke(TextoPriv4, 0, 0, 0, 1)
Stroke(TextoPriv5, 0, 0, 0, 1)
Stroke(TextoPriv6, 0, 0, 0, 1)
Stroke(frame2, 50, 50, 50, 1.5)
Stroke(KeyFrame, 50, 50, 50, 1.5)
Stroke(SendKey, 50, 50, 50, 1.5)
Stroke(KeyBox, 0, 0, 0, 1.5)
Stroke(GetKey, 0, 0, 0, 1.5)
Stroke(SetaES, 0, 0, 0, 1.5)
Stroke(SetaDI, 0, 0, 0, 1.5)
Stroke(GetKeyTexto, 0, 0, 0, 1.5)
Stroke(ReportFrame, 255, 0, 0, 5)
Stroke(TituloReportFrame, 50, 50, 50, 1.5)
Stroke(TextoTituloReportFrame, 0, 0, 0, 1.5)
Stroke(TextoReportFrameFrame, 50, 50, 50, 1.5)
Stroke(CancelarReport, 0, 0, 0, 1.5)
Corner(Regras, 30)
Corner(NotificarGC, 30)
Stroke(Motivo, 50, 50, 50, 1)
Stroke(FotoReport, 50, 50, 50, 1.5)
Stroke(Denunciar, 0, 0, 0, 1.5)
Stroke(DenunciarTexto, 0, 0, 0, 1.5)
Stroke(CancelarReportTexto, 0, 0, 0, 1.5)
Stroke(Warn, 255, 0, 0, 5)
Stroke(TituloWarn, 50, 50, 50, 1.5)
Stroke(TextoTituloWarn, 0, 0, 0, 1.5)
Stroke(TextoWarnFrame, 50, 50, 50, 1.5)
Stroke(CloseWarn, 0, 0, 0, 1.5)
Stroke(CloseWarnTexto, 0, 0, 0, 1.5)

local ok3, result3 = pcall(function()
	return game:HttpGet(str3 .. "/iskeyless")
end)

if ok3 and result3 and CheckRequest() and string.gsub(result3, "%s+", "") == "{\"keyless\":true}" then
	fn20(true)
	task.wait(3)
end

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Key and data2[1].Key ~= "" then
		KEY_ATUAL = data2[1].Key
		KeyBox.Text = KEY_ATUAL
		fn29()
	end
end)

Carregar()
task.wait(0.5)
frame.Visible = true
]====] local loader=loadstring if type(loader)~="function" then error("loadstring is not supported by this executor") end local fn=loader(source) if type(fn)~="function" then error("Could not compile YouTube Music Player") end fn() end) _G.__ZeyHubbYMPLaunching=false if ok then _G.__ZeyHubbYMPLaunched=true openYMP.Text="" if openTitle then openTitle.Text="PLAYER OPENED" end if openSub then openSub.Text="Already running" end else warn("[ZeyHubb.vs] YouTube Music Player: "..tostring(err)) openYMP.Text="FAILED TO OPEN - CHECK CONSOLE" end task.delay(2,function() if openYMP and openYMP.Parent then openYMP.Text="" if openTitle then openTitle.Text="MUSIC PLAYER" end if openSub then openSub.Text="OPEN  ·  YouTube Music" end end end) end) end) end mkSect(configPage,"Config")do local row=mkRow(configPage,44)row.Size=UDim2.new(1,0,0,44)local saveBtn=Instance.new("TextButton",row)saveBtn.Size=UDim2.new(1,-12,0.8,0)saveBtn.Position=UDim2.new(0,6,0.1,0)saveBtn.BackgroundColor3=Color3.fromRGB(245,245,250)saveBtn.BorderSizePixel=0 saveBtn.Text="SAVE CONFIG"saveBtn.TextColor3=Color3.fromRGB(20,20,25)saveBtn.Font=Enum.Font.GothamBold saveBtn.TextSize=13 saveBtn.AutoButtonColor=false saveBtn.ZIndex=8 Instance.new("UICorner",saveBtn).CornerRadius=UDim.new(0,10)local saveStroke=Instance.new("UIStroke",saveBtn)saveStroke.Color=getThemeColor()saveStroke.Thickness=1.5 saveStroke.Transparency=0.4 saveBtn.MouseEnter:Connect(function()TS:Create(saveBtn,TweenInfo.new(0.15),{BackgroundColor3=getThemeColor()}):Play()TS:Create(saveBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)saveBtn.MouseLeave:Connect(function()TS:Create(saveBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(245,245,250)}):Play()TS:Create(saveBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(20,20,25)}):Play()end)saveBtn.Activated:Connect(function()local ok=saveAllSettings(true)saveBtn.Text=ok and"SAVED"or"ERROR"task.delay(1.2,function()if saveBtn and saveBtn.Parent then saveBtn.Text="SAVE CONFIG"end end)end)end do local row=mkRow(configPage,44)row.Size=UDim2.new(1,0,0,44)local resetPosBtn=Instance.new("TextButton",row)resetPosBtn.Size=UDim2.new(1,-12,0.8,0)resetPosBtn.Position=UDim2.new(0,6,0.1,0)resetPosBtn.BackgroundColor3=Color3.fromRGB(245,245,250)resetPosBtn.BorderSizePixel=0 resetPosBtn.Text="RESET POSITIONS"resetPosBtn.TextColor3=Color3.fromRGB(20,20,25)resetPosBtn.Font=Enum.Font.GothamBold resetPosBtn.TextSize=13 resetPosBtn.AutoButtonColor=false resetPosBtn.ZIndex=8 Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,10)local resetStroke=Instance.new("UIStroke",resetPosBtn)resetStroke.Color=getThemeColor()resetStroke.Thickness=1.5 resetStroke.Transparency=0.4 resetPosBtn.MouseEnter:Connect(function()TS:Create(resetPosBtn,TweenInfo.new(0.15),{BackgroundColor3=getThemeColor()}):Play()TS:Create(resetPosBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)resetPosBtn.MouseLeave:Connect(function()TS:Create(resetPosBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(245,245,250)}):Play()TS:Create(resetPosBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(20,20,25)}):Play()end)local resetDebounce=false resetPosBtn.Activated:Connect(function()if resetDebounce then return end resetDebounce=true resetFloatingPositions()resetPosBtn.Text="RESET"task.delay(1.2,function()if resetPosBtn and resetPosBtn.Parent then resetPosBtn.Text="RESET POSITIONS"resetDebounce=false end end)end)end do local row=mkRow(configPage,44)row.Size=UDim2.new(1,0,0,44)local delBtn=Instance.new("TextButton",row)delBtn.Size=UDim2.new(1,-12,0.8,0)delBtn.Position=UDim2.new(0,6,0.1,0)delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.BorderSizePixel=0 delBtn.Text="RESET ALL SETTINGS"delBtn.TextColor3=Color3.fromRGB(170,30,50)delBtn.Font=Enum.Font.GothamBold delBtn.TextSize=13 delBtn.AutoButtonColor=false delBtn.ZIndex=8 Instance.new("UICorner",delBtn).CornerRadius=UDim.new(0,10)local delStroke=Instance.new("UIStroke",delBtn)delStroke.Color=Color3.fromRGB(200,60,80)delStroke.Thickness=1.5 delStroke.Transparency=0.4 delBtn.MouseEnter:Connect(function()TS:Create(delBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,50,70)}):Play()TS:Create(delBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)delBtn.MouseLeave:Connect(function()TS:Create(delBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(245,245,250)}):Play()TS:Create(delBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(170,30,50)}):Play()end)local deleteState=0 local originalDeleteText="RESET ALL SETTINGS"local delDebounce=false delBtn.Activated:Connect(function()if delDebounce then return end if deleteState==0 then deleteState=1 delBtn.Text="CONFIRM?"delBtn.BackgroundColor3=Color3.fromRGB(255,220,220)delBtn.TextColor3=Color3.fromRGB(160,0,0)task.delay(2,function()if delBtn and delBtn.Parent and deleteState==1 then deleteState=0 delBtn.Text=originalDeleteText delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.TextColor3=Color3.fromRGB(170,30,50)end end)elseif deleteState==1 then delDebounce=true local invoked,success=pcall(resetToFactoryDefaults)success=invoked and success delBtn.Text=success and"SETTINGS RESET"or"ERROR"delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.TextColor3=Color3.fromRGB(170,30,50)deleteState=0 task.delay(1.5,function()if delBtn and delBtn.Parent then delBtn.Text=originalDeleteText delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.TextColor3=Color3.fromRGB(170,30,50)delDebounce=false end end)end end)end local keyPage=contentPages["Keybinds"]or contentPages["Config"]mkSect(keyPage,"Keybinds")mkSect(keyPage,"Movement")addKeybindRow(keyPage,"Carry Mode",KB.CarryToggle)addKeybindRow(keyPage,"Lagger Mode",KB.LaggerMode)addKeybindRow(keyPage,"Auto Left",KB.AutoLeft)addKeybindRow(keyPage,"Auto Right",KB.AutoRight)addKeybindRow(keyPage,"Float",KB.Float)mkSect(keyPage,"Combat")addKeybindRow(keyPage,"Bypass Bat",KB.AutoBat)addKeybindRow(keyPage,"Bat V2",KB.BatV2)addKeybindRow(keyPage,"TP Bat",KB.TPBat)mkSect(keyPage,"Utility")addKeybindRow(keyPage,"Drop Brainrot",KB.DropBrainrot)addKeybindRow(keyPage,"TP Down",KB.TPFloor)addKeybindRow(keyPage,"Hide GUI",KB.GuiHide)addKeybindRow(keyPage,"Instant Reset",KB.InstantReset)local spacer=Instance.new("Frame",keyPage)spacer.Size=UDim2.new(1,0,0,16)spacer.BackgroundTransparency=1 spacer.LayoutOrder=getNextOrder(keyPage)spacer.ZIndex=7 local visualPage=contentPages["Visual"]or contentPages["Speed"]local instantResetVersion=(_G.__ZeyHubbInstantResetVersion=="V2")and"V2"or"V1"_G.__ZeyHubbInstantResetVersion=instantResetVersion local headlessEnabled=false local korbloxEnabled=false local duelPingAlertEnabled=false local duelPingAlertTask=nil local duelPingLastState=nil local headlessConnections={}local korbloxConnections={}local resetCameraConnection=nil local resetCameraSaved=nil local instantResetBusy=false local resetGaveUp=false local function lockResetCamera()local cam=workspace.CurrentCamera if not cam then return end if resetCameraConnection then pcall(function()resetCameraConnection:Disconnect()end)end resetCameraConnection=nil resetCameraSaved={cframe=cam.CFrame,type=cam.CameraType,subject=cam.CameraSubject}cam.CameraType=Enum.CameraType.Scriptable resetCameraConnection=RunService.RenderStepped:Connect(function()local current=workspace.CurrentCamera local saved=resetCameraSaved if not current or not saved then return end if current.CameraType~=Enum.CameraType.Scriptable then current.CameraType=Enum.CameraType.Scriptable end current.CFrame=saved.cframe end)end local function unlockResetCamera()if resetCameraConnection then pcall(function()resetCameraConnection:Disconnect()end);resetCameraConnection=nil end local saved=resetCameraSaved resetCameraSaved=nil if not saved then return end local cam=workspace.CurrentCamera if not cam then return end pcall(function()local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")cam.CameraType=(saved.type==Enum.CameraType.Scriptable)and Enum.CameraType.Custom or saved.type cam.CameraSubject=hum or saved.subject end)end local function doInstantResetV1()resetGaveUp=false local character=LP.Character if not character then resetGaveUp=true;return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid then resetGaveUp=true;return end local originalHipHeight=humanoid.HipHeight local attempts,done=0,false while character and character.Parent and humanoid and humanoid.Health>0 and LP.Character==character and attempts<40 do pcall(function()humanoid.HipHeight=1e30 humanoid.AutoRotate=true for _,part in ipairs(character:GetChildren())do if part:IsA("BasePart")then part.CanCollide=false end end end)if not character.Parent or humanoid.Health<=0 or LP.Character~=character then done=true;break end attempts=attempts+1 task.wait(0.05)end if not done and character and character.Parent and humanoid and humanoid.Health>0 then pcall(function()humanoid.Health=0 end)task.wait(0.1)if not character.Parent or humanoid.Health<=0 then done=true end end if not done then resetGaveUp=true if character and character.Parent and humanoid then pcall(function()humanoid.HipHeight=originalHipHeight for _,part in ipairs(character:GetChildren())do if part:IsA("BasePart")then part.CanCollide=true end end end)end end end local function doInstantResetV2()resetGaveUp=false local character=LP.Character if not character then resetGaveUp=true;return end local humanoid=character:FindFirstChildOfClass("Humanoid")local root=character:FindFirstChild("HumanoidRootPart")if not humanoid or not root then resetGaveUp=true;return end local savedPlatform,savedBreak=humanoid.PlatformStand,humanoid.BreakJointsOnDeath local BURST,WINDOW,FLING=500,0.3,1e9 local function applyFling(hum,r)hum.BreakJointsOnDeath=true hum.PlatformStand=true hum:ChangeState(Enum.HumanoidStateType.Physics)r.AssemblyAngularVelocity=Vector3.zero r.AssemblyLinearVelocity=Vector3.new(0,FLING,0)end local function attempt()local ch=LP.Character if ch~=character or not character.Parent then return false end local hum=ch:FindFirstChildOfClass("Humanoid")if not hum or hum.Health<=0 then return false end local r=ch:FindFirstChild("HumanoidRootPart")if r then pcall(applyFling,hum,r)end return true end local t0=os.clock()for _=1,BURST do if not attempt()then return end end while os.clock()-t0<WINDOW do RunService.Heartbeat:Wait()if not attempt()then return end end if not character.Parent or LP.Character~=character or humanoid.Health<=0 then return end resetGaveUp=true pcall(function()humanoid.PlatformStand=savedPlatform humanoid.BreakJointsOnDeath=savedBreak humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)root.AssemblyLinearVelocity=Vector3.zero end)end local function runInstantReset()if instantResetBusy then return end instantResetBusy=true resetGaveUp=false local oldCharacter=LP.Character local wasAntiDie=antiDieEnabled==true pcall(function()if _G.__CrystalAntiDieIsEnabled then wasAntiDie=(_G.__CrystalAntiDieIsEnabled()==true)or wasAntiDie end end)if wasAntiDie then if _G.__CrystalAntiDieStop then pcall(_G.__CrystalAntiDieStop)elseif AntiDieModule and AntiDieModule.stop then pcall(function()AntiDieModule.stop()end)end end lockResetCamera()task.spawn(function()local ok,err=pcall(function()if instantResetVersion=="V2"then doInstantResetV2()else doInstantResetV1()end end)if not ok then warn("[ZeyHubb Instant Reset] "..tostring(err));resetGaveUp=true end end)task.spawn(function()local deadline=os.clock()+25 while os.clock()<deadline do if resetGaveUp then break end local ch=LP.Character if ch and ch.Parent and ch~=oldCharacter then local hum=ch:FindFirstChildOfClass("Humanoid")local root=ch:FindFirstChild("HumanoidRootPart")if hum and root and hum.Health>0 then break end end task.wait(0.05)end unlockResetCamera()if wasAntiDie then local aliveDeadline=os.clock()+20 while os.clock()<aliveDeadline do local ch=LP.Character local hum=ch and ch:FindFirstChildOfClass("Humanoid")if ch and ch.Parent and hum and hum.Health>0 then break end task.wait(0.1)end if AntiDieModule and AntiDieModule.start then pcall(function()AntiDieModule.start()end)elseif _G.__CrystalAntiDieSet then pcall(_G.__CrystalAntiDieSet,true)end if setAntiDieVisual then pcall(setAntiDieVisual,true)end end instantResetBusy=false end)end _G.__ZeyHubbRunInstantReset=runInstantReset local function cleanConnections(list)for _,conn in ipairs(list)do pcall(function()conn:Disconnect()end)end table.clear(list)end local function setHeadless(on)headlessEnabled=on==true cleanConnections(headlessConnections)local char=LP.Character local head=char and char:FindFirstChild("Head")if not head then return end if headlessEnabled then head.Transparency=1 head.CanCollide=false local face=head:FindFirstChild("face")if face then pcall(function()face:Destroy()end)end if not head:FindFirstChild("HeadlessMesh")then local mesh=Instance.new("SpecialMesh")mesh.Name="HeadlessMesh"mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId="rbxassetid://1095708"mesh.Scale=Vector3.new(0.001,0.001,0.001)mesh.Parent=head end table.insert(headlessConnections,head:GetPropertyChangedSignal("Transparency"):Connect(function()if headlessEnabled and head.Parent and head.Transparency~=1 then head.Transparency=1 end end))table.insert(headlessConnections,head.ChildAdded:Connect(function(child)if headlessEnabled and child.Name=="face"and child:IsA("Decal")then pcall(function()child:Destroy()end)end end))else local mesh=head:FindFirstChild("HeadlessMesh")if mesh then pcall(function()mesh:Destroy()end)end head.Transparency=0 head.CanCollide=true end end local function setKorblox(on)korbloxEnabled=on==true cleanConnections(korbloxConnections)local char=LP.Character if not char then return end local humanoid=char:FindFirstChildOfClass("Humanoid")if not korbloxEnabled then local rightLeg=char:FindFirstChild("Right Leg")if rightLeg then local mesh=rightLeg:FindFirstChild("KorbloxMesh")if mesh then pcall(function()mesh:Destroy()end)end end local korbloxLeg=char:FindFirstChild("KorbloxLeg")if korbloxLeg then pcall(function()korbloxLeg:Destroy()end)end for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local part=char:FindFirstChild(name)if part and part:IsA("BasePart")then part.Transparency=0 end end local r6=char:FindFirstChild("Right Leg")if r6 and r6:IsA("BasePart")then r6.Color=Color3.fromRGB(163,162,165)end return end if not humanoid then return end task.spawn(function()task.wait(0.1)if not korbloxEnabled or LP.Character~=char or not char.Parent then return end local meshId,textureId="rbxassetid://101851696","rbxassetid://101851254"local dark=Color3.fromRGB(64,64,64)if humanoid.RigType==Enum.HumanoidRigType.R6 then local rightLeg=char:FindFirstChild("Right Leg")if not rightLeg or rightLeg:FindFirstChild("KorbloxMesh")then return end for _,child in ipairs(rightLeg:GetChildren())do if child:IsA("SpecialMesh")or child:IsA("CharacterMesh")then pcall(function()child:Destroy()end)end end rightLeg.Color=dark table.insert(korbloxConnections,rightLeg:GetPropertyChangedSignal("Color"):Connect(function()if korbloxEnabled and rightLeg.Parent and rightLeg.Color~=dark then rightLeg.Color=dark end end))local mesh=Instance.new("SpecialMesh")mesh.Name="KorbloxMesh"mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId=meshId mesh.TextureId=textureId mesh.Scale=Vector3.one mesh.Parent=rightLeg elseif humanoid.RigType==Enum.HumanoidRigType.R15 then local upper=char:FindFirstChild("RightUpperLeg")if not upper or char:FindFirstChild("KorbloxLeg")then return end upper.Transparency=1 local lower,foot=char:FindFirstChild("RightLowerLeg"),char:FindFirstChild("RightFoot")if lower then lower.Transparency=1 end if foot then foot.Transparency=1 end local leg=Instance.new("Part")leg.Name="KorbloxLeg"leg.Size=Vector3.new(1,2,1)leg.Anchored=false leg.CanCollide=false leg.Massless=true leg.Color=dark leg.Parent=char local mesh=Instance.new("SpecialMesh")mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId=meshId mesh.TextureId=textureId mesh.Scale=Vector3.one mesh.Parent=leg local weld=Instance.new("Weld")weld.Part0=upper weld.Part1=leg weld.C0=CFrame.new(0,-0.45,0)weld.Parent=leg end end)end local function showDuelPingNotification(_,pingMs)local parent=gui and gui.Parent or pgui if not parent then return end local existing=parent:FindFirstChild("ZeyHubbPingWarning")if existing then return end local warningGui=Instance.new("ScreenGui")warningGui.Name="ZeyHubbPingWarning"warningGui.ResetOnSpawn=false warningGui.IgnoreGuiInset=true warningGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling warningGui.DisplayOrder=99999 warningGui.Parent=parent _G.__ZeyHubbPingWarningNextAllowed=tick()+13.5 local warningFrame=Instance.new("Frame")warningFrame.Name="WarningFrame"warningFrame.Size=UDim2.new(0,246,0,34)warningFrame.Position=UDim2.new(0.5,-123,0,-42)warningFrame.BackgroundColor3=Color3.fromRGB(35,22,10)warningFrame.BackgroundTransparency=0.08 warningFrame.BorderSizePixel=0 warningFrame.ZIndex=1000 warningFrame.Parent=warningGui Instance.new("UICorner",warningFrame).CornerRadius=UDim.new(0,10)local warningGradient=Instance.new("UIGradient")warningGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(74,43,16)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(35,22,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,55,15)),})warningGradient.Rotation=0 warningGradient.Parent=warningFrame local warningStroke=Instance.new("UIStroke",warningFrame)warningStroke.Color=Color3.fromRGB(255,157,43)warningStroke.Thickness=1.6 warningStroke.Transparency=0.02 warningStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border local glowTween=TS:Create(warningStroke,TweenInfo.new(0.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Transparency=0.48,Thickness=2.4,Color=Color3.fromRGB(255,205,105)})glowTween:Play()local gradientGlowTween=TS:Create(warningGradient,TweenInfo.new(1.8,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1),{Rotation=360})gradientGlowTween:Play()local warningIcon=Instance.new("TextLabel")warningIcon.Name="WarningIcon"warningIcon.Size=UDim2.new(0,24,1,0)warningIcon.Position=UDim2.new(0,7,0,0)warningIcon.BackgroundTransparency=1 warningIcon.Text="⚡"warningIcon.TextColor3=Color3.fromRGB(255,255,255)warningIcon.Font=Enum.Font.GothamBlack warningIcon.TextSize=17 warningIcon.TextXAlignment=Enum.TextXAlignment.Center warningIcon.ZIndex=1001 warningIcon.Parent=warningFrame local warningText=Instance.new("TextLabel")warningText.Name="WarningText"warningText.Size=UDim2.new(1,-36,1,0)warningText.Position=UDim2.new(0,32,0,0)warningText.BackgroundTransparency=1 warningText.Text="MORE THAN 120 PING DONT DUEL"warningText.TextColor3=Color3.fromRGB(255,255,255)warningText.Font=Enum.Font.GothamBlack warningText.TextSize=11 warningText.TextXAlignment=Enum.TextXAlignment.Left warningText.TextStrokeColor3=Color3.fromRGB(0,0,0)warningText.TextStrokeTransparency=0.65 warningText.ZIndex=1001 warningText.Parent=warningFrame TS:Create(warningFrame,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-123,0,14)}):Play()task.delay(3,function()if warningGui and warningGui.Parent then TS:Create(warningFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-123,0,-42),BackgroundTransparency=1}):Play()TS:Create(warningText,TweenInfo.new(0.2),{TextTransparency=1}):Play()TS:Create(warningIcon,TweenInfo.new(0.2),{TextTransparency=1}):Play()task.wait(0.35)pcall(function()glowTween:Cancel()end)pcall(function()gradientGlowTween:Cancel()end)pcall(function()warningGui:Destroy()end)_G.__ZeyHubbPingWarningNextAllowed=tick()+10 end end)end local function setDuelPingAlert(on)duelPingAlertEnabled=on==true if duelPingAlertTask then pcall(task.cancel,duelPingAlertTask);duelPingAlertTask=nil end duelPingLastState=nil if not duelPingAlertEnabled then local parent=gui and gui.Parent or pgui local existing=parent and parent:FindFirstChild("ZeyHubbPingWarning")if existing then pcall(function()existing:Destroy()end)end return end duelPingAlertTask=task.spawn(function()while duelPingAlertEnabled do local pingMs=0 pcall(function()local ping=LP:GetNetworkPing()if type(ping)=="number"and ping>=0 then pingMs=math.floor(ping*1000+0.5)end end)local now=tick()if pingMs>120 and now>=(_G.__ZeyHubbPingWarningNextAllowed or 0)then showDuelPingNotification(false,pingMs)end task.wait(0.5)end end)end LP.CharacterAdded:Connect(function(char)task.wait(0.35)if headlessEnabled then pcall(setHeadless,true)end if korbloxEnabled then pcall(setKorblox,true)end end)mkSect(visualPage,"Character Protection")do local sv,refresh sv,refresh=mkToggleSelector(visualPage,"Instant Reset",function(on)if on then local run=_G.__ZeyHubbRunInstantReset if type(run)=="function"then local ok,err=pcall(run)if not ok then warn("[ZeyHubb Instant Reset] "..tostring(err))end else warn("[ZeyHubb] Instant Reset engine is not ready.")end if sv then task.delay(0.1,function()pcall(sv,false)end)end end end,{{"V1","V1"},{"V2","V2"}},function()return instantResetVersion end,function(key)instantResetVersion=(key=="V2")and"V2"or"V1"_G.__ZeyHubbInstantResetVersion=instantResetVersion saveAllSettings()end)_G.__ZeyHubbInstantResetSetVisual=sv _G.__ZeyHubbInstantResetRefreshSelector=refresh _G.__ZeyHubbInstantResetSetVersion=function(v)instantResetVersion=(v=="V2")and"V2"or"V1"_G.__ZeyHubbInstantResetVersion=instantResetVersion pcall(refresh)end refresh()end local setHeadlessVisual=mkToggle(visualPage,"Headless",function(on)_G.__ZeyHubbHeadlessEnabled=on==true setHeadless(on)saveAllSettings()end)_G.__ZeyHubbHeadlessSetVisual=setHeadlessVisual _G.__ZeyHubbHeadlessApply=setHeadless local setKorbloxVisual=mkToggle(visualPage,"Korblox",function(on)_G.__ZeyHubbKorbloxEnabled=on==true setKorblox(on)saveAllSettings()end)_G.__ZeyHubbKorbloxSetVisual=setKorbloxVisual _G.__ZeyHubbKorbloxApply=setKorblox local setDuelPingVisual=mkToggle(visualPage,"High Ping Warning",function(on)_G.__ZeyHubbDuelPingEnabled=on==true setDuelPingAlert(on)saveAllSettings()end)_G.__ZeyHubbDuelPingSetVisual=setDuelPingVisual _G.__ZeyHubbDuelPingApply=setDuelPingAlert mkSect(visualPage,"UI Layout")do local row=mkRow(visualPage,42)mkLabel(row,"Background")local options={"None"}for i=1,#backgroundImages do table.insert(options,"Background "..i)end local function currentOptionIndex()if backgroundMode=="None"then return 1 end local n=tonumber(string.match(backgroundMode,"^Background%s+(%d+)$"))or 1 return _clamp(n+1,1,#options)end backgroundSelectorLabel=mkSelector(row,backgroundMode,options,function(direction,updateLabel)local idx=currentOptionIndex()+direction if idx<1 then idx=#options end if idx>#options then idx=1 end applyBackgroundMode(options[idx])updateLabel(backgroundMode)end)applyBackgroundMode(backgroundMode)end rhLockSetB=mkToggle(visualPage,"Lock UI",function(on)toggleLockUI(on);mobileButtonsLocked=on end)setLockUIVisual=function(v)if rhLockSetB then rhLockSetB(v)end end if uiLocked then setLockUIVisual(true)end setHideButtonsVisual=mkToggle(visualPage,"Hide Button",function(on)toggleHideButtons(on)end)if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled)end mkSect(visualPage,"Scale")do local row=mkRow(visualPage,42)mkLabel(row,"UI Scale")uiScaleBox=mkBox(row,uiScaleValue,50,56,function(v)local n=_clamp(_floor(v+0.5),50,150)uiScaleValue=n if mainUIScale then mainUIScale.Scale=n/100 end saveAllSettings()end)end do local row=mkRow(visualPage,42)mkLabel(row,"Button Scale")rhButtonScaleBox=mkBox(row,_floor(floatingButtonScale*100),50,56,function(v)local val=_clamp(v,50,200)floatingButtonScale=val/100 applyFloatingButtonScale()saveAllSettings()end)setSmallButtonsVisual=function()if rhButtonScaleBox then rhButtonScaleBox.Text=tostring(_floor(floatingButtonScale*100+0.5))end end end do local row=mkRow(visualPage,42)mkLabel(row,"Floating Button Style")local opts={"V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20","V21","V22","V23","V24","V25","V26"}local function repaintFloatingButtons()if not MobilePanel then return end for _,btn in ipairs(MobilePanel:GetDescendants())do if btn:IsA("TextButton")and btn:FindFirstChild("BtnGrad")then paintFloatingBtn(btn,btn:GetAttribute("MobActive")==true)end end for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")then paintFloatingBtn(btn,btn:GetAttribute("MobActive")==true)end end end local current=floatingButtonStyle or"V2"local floatingStyleLabel=mkSelector(row,current,opts,function(direction,updateLabel)local idx=1 for i,v in ipairs(opts)do if v==floatingButtonStyle then idx=i break end end idx=idx+direction if idx<1 then idx=#opts elseif idx>#opts then idx=1 end floatingButtonStyle=opts[idx] repaintFloatingButtons() updateLabel(floatingButtonStyle) pcall(saveAllSettings,true)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Floating Button Shape")local shapeOpts={"V1","V2","V3"}local function repaintShapes()if repaintFloatingButtons then repaintFloatingButtons()elseif MobilePanel then for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")then paintFloatingBtn(btn,btn:GetAttribute("MobActive")==true)end end end end local shapeCurrent=floatingButtonShape or"V1"mkSelector(row,shapeCurrent,shapeOpts,function(direction,updateLabel)local idx=1 for i,v in ipairs(shapeOpts)do if v==floatingButtonShape then idx=i break end end idx=idx+direction if idx<1 then idx=#shapeOpts elseif idx>#shapeOpts then idx=1 end floatingButtonShape=shapeOpts[idx] repaintShapes() updateLabel(floatingButtonShape) pcall(saveAllSettings,true)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Auto Steal Scale")stealBarScaleBox=mkBox(row,_floor((stealBarScale or 1)*100),50,56,function(v)local val=_clamp(v,40,200)stealBarScale=val/100 if pbScale then pbScale.Scale=stealBarScale end saveAllSettings()end)end mkSect(visualPage,"Avatar & Skins")do local row=mkRow(visualPage,42)mkLabel(row,"Anim Pack")local currentIndex=1 for i,entry in ipairs(ANIM_PACK_ORDER)do if entry[2]==currentAnimPack then currentIndex=i;break end end local container=Instance.new("Frame",row)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)animSelectorLabel=Instance.new("TextLabel",container)animSelectorLabel.Size=UDim2.new(0,80,0,26)animSelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)animSelectorLabel.BackgroundTransparency=1 animSelectorLabel.Text=ANIM_PACK_ORDER[currentIndex][2]animSelectorLabel.TextColor3=WHITE animSelectorLabel.Font=Enum.Font.GothamBold animSelectorLabel.TextSize=12 animSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center animSelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function updateAnimSelector(direction)local idx=1 for i,entry in ipairs(ANIM_PACK_ORDER)do if entry[2]==currentAnimPack then idx=i;break end end local newIdx=idx+direction if newIdx<1 then newIdx=#ANIM_PACK_ORDER end if newIdx>#ANIM_PACK_ORDER then newIdx=1 end local packName=ANIM_PACK_ORDER[newIdx][2]if packName=="Off"then stopAnimPack()else startAnimPack(packName)end end leftBtn.Activated:Connect(function()updateAnimSelector(-1)end)rightBtn.Activated:Connect(function()updateAnimSelector(1)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Outfit")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)outfitSelectorLabel=Instance.new("TextLabel",container)outfitSelectorLabel.Size=UDim2.new(0,80,0,26)outfitSelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)outfitSelectorLabel.BackgroundTransparency=1 outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label outfitSelectorLabel.TextColor3=WHITE outfitSelectorLabel.Font=Enum.Font.GothamBold outfitSelectorLabel.TextSize=12 outfitSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center outfitSelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function updateOutfit(direction)pcall(VX7A.stop)local newIdx=currentOutfitIndex+direction if newIdx<1 then newIdx=#OUTFITS end if newIdx>#OUTFITS then newIdx=1 end currentOutfitIndex=newIdx pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end saveAllSettings()end leftBtn.Activated:Connect(function()updateOutfit(-1)end)rightBtn.Activated:Connect(function()updateOutfit(1)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Best Avatars")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)VX7A.label=Instance.new("TextLabel",container)VX7A.label.Size=UDim2.new(0,80,0,26)VX7A.label.Position=UDim2.new(0.5,-40,0.5,-13)VX7A.label.BackgroundTransparency=1 VX7A.label.Text=VX7A.labels[VX7A.index+1]or"OFF"VX7A.label.TextColor3=WHITE VX7A.label.Font=Enum.Font.GothamBold VX7A.label.TextSize=12 VX7A.label.TextXAlignment=Enum.TextXAlignment.Center VX7A.label.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function stepVX7Avatar(direction)local pos=VX7A.index+1+direction if pos<1 then pos=#VX7A.labels end if pos>#VX7A.labels then pos=1 end VX7A.apply(pos-1)task.defer(function()pcall(saveAllSettings)end)end leftBtn.Activated:Connect(function()stepVX7Avatar(-1)end)rightBtn.Activated:Connect(function()stepVX7Avatar(1)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Medusa Skin")local SKINS={{id="Default",text="Default"},{id="Skull",text="Skull"},{id="GoldenDesertEagle",text="Golden Eagle"},{id="NeonSkull",text="Neon Skull"},{id="Crystal",text="Crystal"},{id="Bomb",text="Bomb"},}local function curIndex()local cur=_G.RivalMedusaSkin or"Default"for i,sk in ipairs(SKINS)do if sk.id==cur then return i end end return 1 end local medusaLabel medusaLabel=mkSelector(row,SKINS[curIndex()].text,{},function(direction,updateLabel)local idx=curIndex()+direction if idx<1 then idx=#SKINS end if idx>#SKINS then idx=1 end if _G.RivalSetMedusaSkin then _G.RivalSetMedusaSkin(SKINS[idx].id)end updateLabel(SKINS[idx].text)end)medusaLabel.Size=UDim2.new(0,96,0,26)medusaLabel.Position=UDim2.new(0.5,-48,0.5,-13)_G.RivalMedusaSkinRefreshUI=function()medusaLabel.Text=SKINS[curIndex()].text end end mkSect(visualPage,"Graphics")do local row=mkRow(visualPage,42)mkLabel(row,"Title Color")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)rivalTitleSelectorLabel=Instance.new("TextLabel",container)rivalTitleSelectorLabel.Size=UDim2.new(0,80,0,26)rivalTitleSelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)rivalTitleSelectorLabel.BackgroundTransparency=1 rivalTitleSelectorLabel.Text=currentRivalTitleTheme rivalTitleSelectorLabel.TextColor3=WHITE rivalTitleSelectorLabel.Font=Enum.Font.GothamBold rivalTitleSelectorLabel.TextSize=12 rivalTitleSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center rivalTitleSelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local RIVAL_THEME_LIST={"Orange","White","Black","Silver"}local function cycleRivalTitle(dir)local idx=1 for i,name in ipairs(RIVAL_THEME_LIST)do if name==currentRivalTitleTheme then idx=i;break end end local newIdx=idx+dir if newIdx<1 then newIdx=#RIVAL_THEME_LIST end if newIdx>#RIVAL_THEME_LIST then newIdx=1 end applyRivalTitleTheme(RIVAL_THEME_LIST[newIdx])end leftBtn.Activated:Connect(function()cycleRivalTitle(-1)end)rightBtn.Activated:Connect(function()cycleRivalTitle(1)end)end setVividVisual=mkToggle(visualPage,"Vivid Graphics",function(on)toggleVividGraphics(on)if setVividVisual then setVividVisual(on)end end)if setVividVisual then setVividVisual(vividGraphicsEnabled)end do local row=mkRow(visualPage,42)mkLabel(row,"Stretch Rez")local stretchPill,stretchDot=mkPill(row,48)local stretchOn=false local function setStretch(s)stretchOn=s animPill(stretchPill,stretchDot,s)if s then enableStretch()else disableStretch()end stretchEnabled=s end local stretchClk=Instance.new("TextButton",stretchPill)stretchClk.Size=UDim2.new(1,0,1,0)stretchClk.BackgroundTransparency=1 stretchClk.Text=""stretchClk.AutoButtonColor=false stretchClk.ZIndex=10 stretchClk.Activated:Connect(function()setStretch(not stretchOn)end)_G.stretchToggleSetter=setStretch end setAntiLagVisual=mkToggle(visualPage,"Anti Lag",function(on)if on then enableAntiLag()else disableAntiLag()end antiLagEnabled=on==true pcall(saveAllSettings,true)end)do local row=mkRow(visualPage,42)mkLabel(row,"Sky Theme")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)skySelectorLabel=Instance.new("TextLabel",container)skySelectorLabel.Size=UDim2.new(0,96,0,26)skySelectorLabel.Position=UDim2.new(0.5,-48,0.5,-13)skySelectorLabel.BackgroundTransparency=1 skySelectorLabel.Text=skyTheme skySelectorLabel.TextColor3=WHITE skySelectorLabel.Font=Enum.Font.GothamBold skySelectorLabel.TextSize=11 skySelectorLabel.TextXAlignment=Enum.TextXAlignment.Center skySelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function updateSkySelector(direction)local idx=1 for i,name in ipairs(SKY_PRESETS_LIST)do if name==skyTheme then idx=i;break end end local newIdx=idx+direction if newIdx<1 then newIdx=#SKY_PRESETS_LIST end if newIdx>#SKY_PRESETS_LIST then newIdx=1 end local name=SKY_PRESETS_LIST[newIdx]skyTheme=name pcall(applyCustomSky,name)if skySelectorLabel then skySelectorLabel.Text=name end pcall(saveAllSettings,true)end leftBtn.Activated:Connect(function()updateSkySelector(-1)end)rightBtn.Activated:Connect(function()updateSkySelector(1)end)end mkSect(visualPage,"ESP & Overlays")setESPVIsual=mkToggle(visualPage,"Player ESP",function(on)toggleESP(on)end)setESPLineVisual=mkToggle(visualPage,"ESP Line",function(on)if on then startESPLine()else stopESPLine()end end)do -- Brainrot Transparent (Mano + Base) removed from UI
if _G.RHBrainrotTransparency then
pcall(_G.RHBrainrotTransparency.SetHeld,false)
pcall(_G.RHBrainrotTransparency.SetBase,false)
end
end pbFrame=Instance.new("Frame",gui)pbFrame.Name="ZeyHubbAutoStealHud"local BAR_W,BAR_H=260,46 pbFrame.Size=UDim2.new(0,BAR_W,0,BAR_H)pbFrame.Position=UDim2.new(1,-BAR_W-14,0,14)pbFrame.BackgroundColor3=Color3.fromRGB(12,7,2)pbFrame.BackgroundTransparency=0.05 pbFrame.BorderSizePixel=0 pbFrame.Active=true pbFrame.Visible=false pbFrame.ZIndex=500 Instance.new("UICorner",pbFrame).CornerRadius=UDim.new(0,14)pbScale=Instance.new("UIScale",pbFrame)pbScale.Scale=stealBarScale or 1 local pbStroke=Instance.new("UIStroke",pbFrame)pbStroke.Name="OuterStroke"pbStroke.Color=Color3.fromRGB(255,205,100)pbStroke.Thickness=1.05 pbStroke.Transparency=0.22 local pbGrad=Instance.new("UIGradient",pbFrame)pbGrad.Rotation=90 pbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(28,16,6)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(12,7,2)),})local topLine=Instance.new("Frame",pbFrame)topLine.Name="TopAccent"topLine.Size=UDim2.new(1,-20,0,2)topLine.Position=UDim2.new(0,10,0,0)topLine.BackgroundColor3=Color3.fromRGB(255,180,60)topLine.BorderSizePixel=0 topLine.ZIndex=507 Instance.new("UICorner",topLine).CornerRadius=UDim.new(1,0)local topLineGrad=Instance.new("UIGradient",topLine)topLineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0.00,1),NumberSequenceKeypoint.new(0.25,0.15),NumberSequenceKeypoint.new(0.50,0),NumberSequenceKeypoint.new(0.75,0.15),NumberSequenceKeypoint.new(1.00,1),})local hudTitle=Instance.new("TextLabel",pbFrame)hudTitle.Name="AutoStealTitle"hudTitle.Size=UDim2.new(0,100,0,14)hudTitle.Position=UDim2.new(0,10,0,5)hudTitle.BackgroundTransparency=1 hudTitle.Text="ZeyHubb.vs"hudTitle.TextColor3=Color3.fromRGB(255,230,150)hudTitle.Font=Enum.Font.GothamBlack hudTitle.TextSize=12 hudTitle.TextXAlignment=Enum.TextXAlignment.Left hudTitle.ZIndex=505 local hudGrad=Instance.new("UIGradient",hudTitle)hudGrad.Name="HudShine"hudGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,245)),ColorSequenceKeypoint.new(0.30,Color3.fromRGB(255,210,100)),ColorSequenceKeypoint.new(0.55,Color3.fromRGB(255,160,40)),ColorSequenceKeypoint.new(0.80,Color3.fromRGB(255,200,90)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,245,200)),})local hudStroke=Instance.new("UIStroke",hudTitle)hudStroke.Color=Color3.fromRGB(255,150,40)hudStroke.Thickness=1.2 hudStroke.Transparency=0.4 task.spawn(function()while hudTitle and hudTitle.Parent and hudGrad and hudGrad.Parent do hudGrad.Offset=Vector2.new(-1,0)local tw=TS:Create(hudGrad,TweenInfo.new(1.4,Enum.EasingStyle.Linear),{Offset=Vector2.new(1,0)})tw:Play()tw.Completed:Wait()task.wait(0.2)end end)task.spawn(function()local up=true while hudTitle and hudTitle.Parent and hudStroke and hudStroke.Parent do local goal=up and 0.15 or 0.55 local tw=TS:Create(hudStroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goal})tw:Play()tw.Completed:Wait()up=not up end end)progressStatus=Instance.new("TextLabel",pbFrame)progressStatus.Name="StealProgressStatus"progressStatus.Size=UDim2.new(0,75,0,14)progressStatus.Position=UDim2.new(0,112,0,5)progressStatus.BackgroundTransparency=1 progressStatus.Text="READY"progressStatus.TextColor3=Color3.fromRGB(255,210,150)progressStatus.Font=Enum.Font.GothamBold progressStatus.TextSize=11 progressStatus.TextXAlignment=Enum.TextXAlignment.Left progressStatus.ZIndex=505 infoLabel=Instance.new("TextLabel",pbFrame)infoLabel.Name="PerformanceStats"infoLabel.Size=UDim2.new(0,90,0,14)infoLabel.Position=UDim2.new(1,-98,0,5)infoLabel.BackgroundTransparency=1 infoLabel.Text="FPS --  MS --"infoLabel.TextColor3=Color3.fromRGB(180,160,130)infoLabel.Font=Enum.Font.GothamMedium infoLabel.TextSize=10 infoLabel.TextXAlignment=Enum.TextXAlignment.Right infoLabel.ZIndex=505 local stealTrack=Instance.new("Frame",pbFrame)stealTrack.Name="StealProgressTrack"stealTrack.Size=UDim2.new(1,-20,0,12)stealTrack.Position=UDim2.new(0,10,1,-18)stealTrack.BackgroundColor3=Color3.fromRGB(22,12,4)stealTrack.BackgroundTransparency=0.1 stealTrack.BorderSizePixel=0 stealTrack.ClipsDescendants=true stealTrack.ZIndex=502 Instance.new("UICorner",stealTrack).CornerRadius=UDim.new(1,0)local trackStroke=Instance.new("UIStroke",stealTrack)trackStroke.Color=Color3.fromRGB(255,205,100)trackStroke.Thickness=1.0 trackStroke.Transparency=0.25 progressFill=Instance.new("Frame",stealTrack)progressFill.Name="StealProgressFill"progressFill.Size=UDim2.new(0,0,1,0)progressFill.BackgroundColor3=Color3.fromRGB(255,150,40)progressFill.BackgroundTransparency=0 progressFill.BorderSizePixel=0 progressFill.ZIndex=503 Instance.new("UICorner",progressFill).CornerRadius=UDim.new(1,0)local fillGrad=Instance.new("UIGradient",progressFill)fillGrad.Name="FillGrad"fillGrad.Rotation=0 fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,230)),ColorSequenceKeypoint.new(0.15,Color3.fromRGB(255,230,140)),ColorSequenceKeypoint.new(0.40,Color3.fromRGB(255,180,60)),ColorSequenceKeypoint.new(0.70,Color3.fromRGB(255,130,30)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(180,70,10)),})local fillGlow=Instance.new("Frame",progressFill)fillGlow.Name="FillGlow"fillGlow.Size=UDim2.new(1,0,0,5)fillGlow.Position=UDim2.new(0,0,0,0)fillGlow.BackgroundColor3=Color3.fromRGB(255,255,245)fillGlow.BackgroundTransparency=1 fillGlow.BorderSizePixel=0 fillGlow.Visible=false fillGlow.ZIndex=504 local shimmer=Instance.new("Frame",progressFill)shimmer.Name="Shimmer"shimmer.Size=UDim2.new(0,28,1,0)shimmer.Position=UDim2.new(-0.2,0,0,0)shimmer.BackgroundColor3=Color3.fromRGB(255,255,255)shimmer.BackgroundTransparency=0.55 shimmer.BorderSizePixel=0 shimmer.Visible=true shimmer.ZIndex=505 local shGrad=Instance.new("UIGradient",shimmer)shGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0.00,1),NumberSequenceKeypoint.new(0.40,0.15),NumberSequenceKeypoint.new(0.60,0.15),NumberSequenceKeypoint.new(1.00,1),})task.spawn(function()while shimmer and shimmer.Parent do shimmer.Position=UDim2.new(-0.35,0,0,0)local tw=TS:Create(shimmer,TweenInfo.new(0.75,Enum.EasingStyle.Linear),{Position=UDim2.new(1.25,0,0,0)})tw:Play()tw.Completed:Wait()task.wait(0.12)end end)progressPct=Instance.new("TextLabel",stealTrack)progressPct.Name="StealProgressPercent"progressPct.Size=UDim2.new(1,-8,1,0)progressPct.Position=UDim2.new(0,4,0,0)progressPct.BackgroundTransparency=1 progressPct.Text="0%"progressPct.TextColor3=Color3.fromRGB(255,255,255)progressPct.Font=Enum.Font.GothamBlack progressPct.TextSize=11 progressPct.TextXAlignment=Enum.TextXAlignment.Center progressPct.TextStrokeTransparency=0.35 progressPct.TextStrokeColor3=Color3.fromRGB(20,8,0)progressPct.ZIndex=506 updateStealProgress(0,"READY")
function applyStealBarStyle(style)
style = style or stealBarStyle or "V1"
stealBarStyle = style
if not pbFrame or not pbFrame.Parent then return end
local track = pbFrame:FindFirstChild("StealProgressTrack")
local title = pbFrame:FindFirstChild("AutoStealTitle")
local status = pbFrame:FindFirstChild("StealProgressStatus")
local stats = pbFrame:FindFirstChild("PerformanceStats") or (track and track:FindFirstChild("PerformanceStats"))
local fill = track and track:FindFirstChild("StealProgressFill")
local pct = (track and track:FindFirstChild("StealProgressPercent")) or pbFrame:FindFirstChild("StealProgressPercent")
local top = pbFrame:FindFirstChild("TopAccent")
local pbStroke = pbFrame:FindFirstChild("OuterStroke")
local pbCorner = pbFrame:FindFirstChildOfClass("UICorner")
local pbGrad = pbFrame:FindFirstChildOfClass("UIGradient")
local trackCorner = track and track:FindFirstChildOfClass("UICorner")
local fillCorner = fill and fill:FindFirstChildOfClass("UICorner")
local trackStroke = track and track:FindFirstChildOfClass("UIStroke")
-- always kill the bright top line on the fill
if fill then
	local glow = fill:FindFirstChild("FillGlow")
	if glow then glow.Visible = false glow.BackgroundTransparency = 1 end
end
if style == "V3" then
local BAR_W, BAR_H = 320, 62
pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H)
pbFrame.Position = UDim2.new(1, -BAR_W-14, 0, 14)
pbFrame.BackgroundTransparency = 0.04
pbFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 2)
if pbStroke then
	pbStroke.Enabled = true
	pbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	pbStroke.Color = Color3.fromRGB(255, 210, 100)
	pbStroke.Transparency = 0.20
	pbStroke.Thickness = 1.05
end
if pbGrad then
	pbGrad.Enabled = true
	pbGrad.Rotation = 90
	pbGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 24, 8)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 6, 2))
	})
end
if pbCorner then pbCorner.CornerRadius = UDim.new(0, 14) end
if title then
	title.Visible = true
	title.Parent = pbFrame
	title.Size = UDim2.new(0, 90, 0, 15)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Text = "ZeyHubb.vs"
	title.TextSize = 11
	title.TextWrapped = false
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Font = Enum.Font.GothamBlack
	title.TextColor3 = Color3.fromRGB(255, 235, 170)
	title.ZIndex = 505
end
if status then
	status.Visible = true
	status.Parent = pbFrame
	status.Size = UDim2.new(0, 82, 0, 15)
	status.Position = UDim2.new(0, 105, 0, 5)
	status.TextSize = 10
	status.TextWrapped = false
	status.TextTruncate = Enum.TextTruncate.AtEnd
	status.ZIndex = 505
end
if top then
	top.Visible = true
	top.Size = UDim2.new(0.35, 0, 0, 2)
	top.Position = UDim2.new(0.325, 0, 0, 0)
	top.BackgroundColor3 = Color3.fromRGB(255, 215, 115)
end
if track then
	track.Size = UDim2.new(1, -20, 0, 30)
	track.Position = UDim2.new(0, 10, 0, 27)
	track.BackgroundColor3 = Color3.fromRGB(16, 9, 3)
	track.BackgroundTransparency = 0.04
	track.BorderSizePixel = 0
	track.ClipsDescendants = true
	if trackCorner then trackCorner.CornerRadius = UDim.new(1, 0) end
	if not trackStroke then
		trackStroke = Instance.new("UIStroke")
		trackStroke.Name = "TrackStroke"
		trackStroke.Parent = track
	end
	trackStroke.Enabled = true
	trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	trackStroke.Thickness = 1.0
	trackStroke.Transparency = 0.20
	trackStroke.Color = Color3.fromRGB(255, 205, 100)
end
if fill then
	if fillCorner then fillCorner.CornerRadius = UDim.new(1, 0) end
	fill.BackgroundColor3 = Color3.fromRGB(255, 170, 50)
	fill.Position = UDim2.new(0, 0, 0, 0)
	local fg = fill:FindFirstChildOfClass("UIGradient")
	if not fg then fg = Instance.new("UIGradient") fg.Parent = fill end
	fg.Rotation = 0
	fg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 252, 230)),
		ColorSequenceKeypoint.new(0.18, Color3.fromRGB(255, 235, 155)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 180, 60)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 135, 32)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(215, 90, 14))
	})
	local glow = fill:FindFirstChild("FillGlow")
	if glow then glow.Visible = false glow.BackgroundTransparency = 1 end
	for _, child in ipairs(fill:GetChildren()) do
		if child:IsA("Frame") and child.Name:lower():find("shimmer") then
			child.Visible = true
			child.BackgroundTransparency = 0.50
		end
	end
end
if stats then
	stats.Visible = true
	stats.Parent = pbFrame
	stats.Size = UDim2.new(0, 115, 0, 15)
	stats.Position = UDim2.new(0, 195, 0, 5)
	stats.BackgroundTransparency = 1
	stats.TextSize = 9
	stats.TextWrapped = false
	stats.TextTruncate = Enum.TextTruncate.AtEnd
	stats.Font = Enum.Font.GothamMedium
	stats.TextColor3 = Color3.fromRGB(235, 215, 180)
	stats.TextXAlignment = Enum.TextXAlignment.Right
	stats.TextYAlignment = Enum.TextYAlignment.Center
	stats.ZIndex = 505
end
if pct then
	pct.Visible = true
	pct.Parent = track or pbFrame
	pct.Size = UDim2.new(1, -8, 1, 0)
	pct.Position = UDim2.new(0, 4, 0, 0)
	pct.BackgroundTransparency = 1
	pct.TextSize = 13
	pct.TextWrapped = false
	pct.Font = Enum.Font.GothamBlack
	pct.TextColor3 = Color3.fromRGB(255, 255, 255)
	pct.TextXAlignment = Enum.TextXAlignment.Center
	pct.TextYAlignment = Enum.TextYAlignment.Center
	pct.ZIndex = 506
end
elseif style == "V2" then
-- V2: fill strictement dans les contours, 0 overflow, pas de ligne brillante
local BAR_W, BAR_H = 300, 30
pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H)
pbFrame.BackgroundTransparency = 1
if pbStroke then pbStroke.Enabled = false end
if pbGrad then pbGrad.Enabled = false end
if pbCorner then pbCorner.CornerRadius = UDim.new(0, 0) end
if title then title.Visible = false end
if status then status.Visible = false end
if top then top.Visible = false end
if track then
	track.Size = UDim2.new(1, 0, 1, 0)
	track.Position = UDim2.new(0, 0, 0, 0)
	track.BackgroundColor3 = Color3.fromRGB(12, 7, 2)
	track.BackgroundTransparency = 0.02
	track.BorderSizePixel = 0
	track.ClipsDescendants = true
	if trackCorner then trackCorner.CornerRadius = UDim.new(0, 6) end
	if not trackStroke then
		trackStroke = Instance.new("UIStroke")
		trackStroke.Name = "TrackStroke"
		trackStroke.Parent = track
	end
	trackStroke.Enabled = true
	trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	trackStroke.LineJoinMode = Enum.LineJoinMode.Round
	trackStroke.Thickness = 1.0
	trackStroke.Transparency = 0.12
	trackStroke.Color = Color3.fromRGB(255, 215, 110)
end
if fill then
	-- inset 2px so fill never depasse le contour interieur
	if fillCorner then fillCorner.CornerRadius = UDim.new(0, 4) end
	fill.BackgroundColor3 = Color3.fromRGB(255, 175, 55)
	fill.BorderSizePixel = 0
	fill.Position = UDim2.new(0, 2, 0, 2)
	-- height inset handled via Size Y scale with offset in update; set base height here
	local curX = fill.Size.X.Scale
	fill.Size = UDim2.new(curX, -4, 1, -4)
	local fg = fill:FindFirstChildOfClass("UIGradient")
	if not fg then fg = Instance.new("UIGradient") fg.Parent = fill end
	fg.Rotation = 0
	fg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 252, 235)),
		ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 240, 170)),
		ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 190, 70)),
		ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 145, 40)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(225, 100, 18))
	})
	local glow = fill:FindFirstChild("FillGlow")
	if glow then glow.Visible = false glow.BackgroundTransparency = 1 end
	for _, child in ipairs(fill:GetChildren()) do
		if child:IsA("Frame") and child.Name:lower():find("shimmer") then
			-- pas de shimmer en V2 (cause la ligne qui debordait)
			child.Visible = false
		end
	end
end
if stats then
	stats.Visible = true
	stats.Parent = track or pbFrame
	stats.Size = UDim2.new(0.55, -8, 1, 0)
	stats.Position = UDim2.new(0, 8, 0, 0)
	stats.BackgroundTransparency = 1
	stats.TextSize = 12
	stats.Font = Enum.Font.GothamBold
	stats.TextColor3 = Color3.fromRGB(255, 250, 225)
	stats.TextXAlignment = Enum.TextXAlignment.Left
	stats.TextYAlignment = Enum.TextYAlignment.Center
	stats.ZIndex = 510
end
if pct then
	pct.Visible = true
	pct.Parent = track or pbFrame
	pct.Size = UDim2.new(0.45, -8, 1, 0)
	pct.Position = UDim2.new(0.55, 0, 0, 0)
	pct.BackgroundTransparency = 1
	pct.TextSize = 13
	pct.Font = Enum.Font.GothamBlack
	pct.TextColor3 = Color3.fromRGB(255, 255, 255)
	pct.TextXAlignment = Enum.TextXAlignment.Right
	pct.TextYAlignment = Enum.TextYAlignment.Center
	pct.ZIndex = 510
end
else
-- V1
local BAR_W, BAR_H = 260, 46
pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H)
pbFrame.BackgroundTransparency = 0.04
pbFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 2)
if pbStroke then
	pbStroke.Enabled = true
	pbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	pbStroke.Color = Color3.fromRGB(255, 205, 100)
	pbStroke.Transparency = 0.22
	pbStroke.Thickness = 1.05
end
if pbGrad then pbGrad.Enabled = true end
if pbCorner then pbCorner.CornerRadius = UDim.new(0, 12) end
if title then
	title.Visible = true
	title.Parent = pbFrame
	title.Size = UDim2.new(0, 100, 0, 14)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Text = "ZeyHubb.vs"
	title.TextSize = 12
	title.Font = Enum.Font.GothamBlack
	title.TextColor3 = Color3.fromRGB(255, 235, 170)
	title.ZIndex = 505
end
if status then
	status.Visible = true
	status.Parent = pbFrame
	status.Size = UDim2.new(0, 75, 0, 14)
	status.Position = UDim2.new(0, 112, 0, 5)
	status.TextSize = 11
	status.ZIndex = 505
end
if top then
	top.Visible = true
	top.Size = UDim2.new(1, -20, 0, 2)
	top.BackgroundColor3 = Color3.fromRGB(255, 210, 105)
end
if track then
	track.Size = UDim2.new(1, -20, 0, 12)
	track.Position = UDim2.new(0, 10, 1, -18)
	track.BackgroundColor3 = Color3.fromRGB(16, 9, 3)
	track.BackgroundTransparency = 0.08
	track.ClipsDescendants = true
	if trackCorner then trackCorner.CornerRadius = UDim.new(1, 0) end
	if not trackStroke then
		trackStroke = Instance.new("UIStroke")
		trackStroke.Name = "TrackStroke"
		trackStroke.Parent = track
	end
	trackStroke.Enabled = true
	trackStroke.Thickness = 1.0
	trackStroke.Transparency = 0.25
	trackStroke.Color = Color3.fromRGB(255, 205, 100)
end
if fill and fillCorner then fillCorner.CornerRadius = UDim.new(1, 0) end
if fill then
	fill.Position = UDim2.new(0, 0, 0, 0)
	local fg = fill:FindFirstChildOfClass("UIGradient")
	if not fg then fg = Instance.new("UIGradient") fg.Parent = fill end
	fg.Rotation = 0
	fg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 252, 230)),
		ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 235, 150)),
		ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 185, 65)),
		ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 140, 35)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 80, 14))
	})
	local glow = fill:FindFirstChild("FillGlow")
	if glow then glow.Visible = false glow.BackgroundTransparency = 1 end
	for _, child in ipairs(fill:GetChildren()) do
		if child:IsA("Frame") and child.Name:lower():find("shimmer") then
			child.Visible = true
			child.BackgroundTransparency = 0.50
		end
	end
end
if stats then
	stats.Visible = true
	stats.Parent = pbFrame
	stats.Size = UDim2.new(0, 90, 0, 14)
	stats.Position = UDim2.new(1, -98, 0, 5)
	stats.TextSize = 10
	stats.Font = Enum.Font.GothamMedium
	stats.TextColor3 = Color3.fromRGB(210, 190, 160)
	stats.TextXAlignment = Enum.TextXAlignment.Right
	stats.TextYAlignment = Enum.TextYAlignment.Center
	stats.ZIndex = 505
end
if pct then
	pct.Visible = true
	pct.Parent = track or pbFrame
	pct.Size = UDim2.new(1, -8, 1, 0)
	pct.Position = UDim2.new(0, 4, 0, 0)
	pct.TextSize = 11
	pct.Font = Enum.Font.GothamBlack
	pct.TextColor3 = Color3.fromRGB(255, 255, 255)
	pct.TextXAlignment = Enum.TextXAlignment.Center
	pct.TextYAlignment = Enum.TextYAlignment.Center
	pct.ZIndex = 506
end
end
if pbScale then pbScale.Scale = stealBarScale or 1 end
end
_G.__ZeyHubbApplyStealBarStyle = applyStealBarStyle
task.defer(function() pcall(applyStealBarStyle, stealBarStyle) end)
task.spawn(function()local up=true while pbFrame and pbFrame.Parent and pbStroke and pbStroke.Parent do local goal=up and 0.02 or 0.22 local tw=TS:Create(pbStroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goal})tw:Play()tw.Completed:Wait()up=not up end end)task.spawn(function()local frames,fps,last=0,60,_tick()local fpsConn=RunService.RenderStepped:Connect(function()frames=frames+1 end)while pbFrame and pbFrame.Parent do local now=_tick()local elapsed=now-last if elapsed>0 then fps=_floor(frames/elapsed+0.5)end frames,last=0,now local ms=0 pcall(function()local p=LP:GetNetworkPing()if type(p)=="number"and p>=0 then ms=_floor(p*1000+0.5)end end)if infoLabel and infoLabel.Parent then infoLabel.Text=string.format("FPS %d  MS %d",fps,ms)end task.wait(0.5)end if fpsConn then fpsConn:Disconnect()end end)drag(pbFrame)pcall(function()if main then drag(main,72)end end)end do local BAV2_ANG="_GB_AngV"local BAV2_ATT="_GB_Att"local BAV2_CLEAN={"LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt","AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"}local V2={enabled=false,conn=nil,safetyConn=nil,target=nil,equipped=false,intendedVelocity=Vector3.zero,attachment=nil,angularVelocity=nil,speed=58,swingRange=12,}_G.__RivalHubBatV2=V2 local function cleanMovers(root)if not root then return end pcall(function()for _,n in ipairs(BAV2_CLEAN)do local c=root:FindFirstChild(n)if c then c:Destroy()end end for _,child in ipairs(root:GetChildren())do if child.Name~=BAV2_ANG and child.Name~=BAV2_ATT then local ln=child.Name:lower()if ln:find("lockb")or ln:find("lockangv")or ln:find("batlock")or ln:find("antiaim")or ln:find("velocitylock")then child:Destroy()end end end end)end local function ensureAngular(root)if not root then return end pcall(function()local a=root:FindFirstChild(BAV2_ANG);if a then a:Destroy()end local b=root:FindFirstChild(BAV2_ATT);if b then b:Destroy()end end)local att=Instance.new("Attachment")att.Name=BAV2_ATT att.Parent=root local angV=Instance.new("AngularVelocity")angV.Name=BAV2_ANG angV.Attachment0=att angV.RelativeTo=Enum.ActuatorRelativeTo.World angV.MaxTorque=math.huge angV.AngularVelocity=Vector3.zero angV.Parent=root V2.attachment=att V2.angularVelocity=angV end local function removeAngular()pcall(function()if V2.angularVelocity and V2.angularVelocity.Parent then V2.angularVelocity:Destroy()end end)pcall(function()if V2.attachment and V2.attachment.Parent then V2.attachment:Destroy()end end)V2.angularVelocity=nil V2.attachment=nil end local function pickTarget(root)local best,bestD=nil,math.huge for _,p in ipairs(Players:GetPlayers())do if p~=LP and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart")local hum=p.Character:FindFirstChildOfClass("Humanoid")if hrp and hum and hum.Health>0 then local d=(hrp.Position-root.Position).Magnitude if d<bestD then bestD=d;best=hrp end end end end return best,bestD end local function getBat(char)local eq=char and char:FindFirstChildOfClass("Tool")if eq then local n=eq.Name:lower()if n:find("bat")or n:find("slap")then return eq end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,t in ipairs(bp:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("bat")or n:find("slap")then return t end end end end return nil end local function stopBatV2()V2.enabled=false if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end V2.equipped=false V2.target=nil if V2.conn then V2.conn:Disconnect();V2.conn=nil end if V2.safetyConn then V2.safetyConn:Disconnect();V2.safetyConn=nil end local c=LP.Character local root=c and c:FindFirstChild("HumanoidRootPart")if root then pcall(function()root.Velocity=root.Velocity*0.3 end)end local hum=c and c:FindFirstChildOfClass("Humanoid")if hum then hum.AutoRotate=true end if V2.angularVelocity then pcall(function()V2.angularVelocity.AngularVelocity=Vector3.zero end)end removeAngular()if _unsuppressBodyLock then pcall(_unsuppressBodyLock,true)end end local function startBatV2()stopBatV2()V2.enabled=true if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end V2.equipped=false V2.target=nil V2.intendedVelocity=Vector3.zero V2.speed=tonumber(State and State.bypassBatSpeed)or 58 if _suppressBodyLock then pcall(_suppressBodyLock)end local c=LP.Character local root=c and c:FindFirstChild("HumanoidRootPart")if root then cleanMovers(root)ensureAngular(root)end V2.conn=RunService.Heartbeat:Connect(function()if not V2.enabled then return end local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")local hrp=char and char:FindFirstChild("HumanoidRootPart")if not hrp or not hum or hum.Health<=0 then return end cleanMovers(hrp)if not V2.angularVelocity or not V2.angularVelocity.Parent then ensureAngular(hrp)end if not V2.equipped then V2.equipped=true if not char:FindFirstChildOfClass("Tool")then local b=getBat(char)if b then pcall(function()hum:EquipTool(b)end)end end end local target,dist=pickTarget(hrp)if not target then V2.target=nil hum.AutoRotate=true if V2.angularVelocity then V2.angularVelocity.AngularVelocity=Vector3.zero end return end V2.target=target local aimPos=target.Position+target.CFrame.LookVector*(target.Velocity.Magnitude<0.1 and 1.5 or 5)local delta=aimPos-hrp.Position local flat=Vector3.new(delta.X,0,delta.Z)hum.AutoRotate=false if delta.Magnitude>0.01 and flat.Magnitude>0.01 then local curY=hrp.Orientation.Y local yawD=(math.deg(math.atan2(-flat.X,-flat.Z))-curY+180)%360-180 local curX=hrp.Orientation.X local pitchD=(math.deg(math.atan2(delta.Y,flat.Magnitude))-curX+180)%360-180 local rotY=math.clamp(math.rad(yawD)*40,-28,28)local rotX=math.clamp(math.rad(pitchD)*40,-28,28)local yawR=math.rad(hrp.Orientation.Y)local fwd=Vector3.new(math.cos(yawR),0,-math.sin(yawR))V2.angularVelocity.AngularVelocity=Vector3.new(0,rotY,0)+fwd*rotX else V2.angularVelocity.AngularVelocity=Vector3.zero end local spd=tonumber(V2.speed)or 58 V2.intendedVelocity=(flat.Magnitude>0.1 and flat.Unit*spd or Vector3.zero)+(math.abs(delta.Y)>0.8 and Vector3.new(0,math.sign(delta.Y)*spd,0)or Vector3.new(0,-2,0))hrp.AssemblyLinearVelocity=V2.intendedVelocity hrp.Velocity=V2.intendedVelocity if flat.Magnitude>0.3 then pcall(function()hum:Move(flat.Unit,false)end)else pcall(function()hum:Move(Vector3.zero,false)end)end if dist<=V2.swingRange then local bat=char:FindFirstChildOfClass("Tool")if bat and(bat.Name:lower():find("bat")or bat.Name:lower():find("slap"))then pcall(function()bat:Activate()local re=bat:FindFirstChildWhichIsA("RemoteEvent")if re then re:FireServer()end end)end end end)V2.safetyConn=RunService.RenderStepped:Connect(function()if not V2.enabled then return end local char=LP.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if not hrp or not hum then return end if V2.target and V2.target.Parent then local delta=V2.target.Position-hrp.Position local flat=Vector3.new(delta.X,0,delta.Z)if flat.Magnitude>0.3 then pcall(function()hum:Move(flat.Unit,false)end)end if math.abs(hrp.AssemblyLinearVelocity.X-V2.intendedVelocity.X)>30 or math.abs(hrp.AssemblyLinearVelocity.Z-V2.intendedVelocity.Z)>30 then hrp.AssemblyLinearVelocity=V2.intendedVelocity end end local v=hrp.Velocity if math.abs(v.X)>350 or math.abs(v.Z)>350 then hrp.Velocity=V2.intendedVelocity end cleanMovers(hrp)end)end local V3={enabled=false,conn=nil,cfg={FOLLOW_SPEED=55,ACTIVATE_DISTANCE=13,MIN_FOLLOW_DISTANCE=1,PREDICTION_TIME=0.22,PREDICT_AHEAD=3,MAX_VELOCITY_CHANGE=150,VELOCITY_SMOOTHING=0.2,MAX_HORIZONTAL_VELOCITY=80,SERVER_TICKRATE=1/60,MIN_PING_COMPENSATION=0.03,MAX_PING_COMPENSATION=0.25,ACCELERATION_PREDICTION_WEIGHT=0.3,DIRECTION_CHANGE_DETECTION_TIME=0.12,QUICK_DIRECTION_CHANGE_MULTIPLIER=1.5,GRAVITY=196.2,AIR_CONTROL_FACTOR=0.8,MIN_AIRBORNE_TIME=0.08,SWING_COOLDOWN=0.08,},st={targetPlayer=nil,lastTargetPos=nil,targetVelocity=Vector3.zero,smoothedVelocity=Vector3.zero,velocityHistory={},accelerationHistory={},aerialVelocityHistory={},verticalVelocityHistory={},previousDirection=nil,lastDirectionChangeTime=0,airborneTime=0,lastYVelocity=0,lastActivationTime=0,currentPing=0.1,realPingMs=0,previousAutoRotate=nil,previousHumanoid=nil,swingLocked=false,nextSwingAt=0,},}function V3.avg(list)if#list==0 then return Vector3.zero end local sum=Vector3.zero for _,v in ipairs(list)do sum=sum+v end return sum/#list end function V3.push(list,value,maxSize)table.insert(list,value)if#list>maxSize then table.remove(list,1)end end function V3.reset()local s=V3.st s.targetPlayer=nil;s.lastTargetPos=nil s.targetVelocity=Vector3.zero;s.smoothedVelocity=Vector3.zero s.velocityHistory={};s.accelerationHistory={}s.aerialVelocityHistory={};s.verticalVelocityHistory={}s.previousDirection=nil;s.airborneTime=0;s.lastYVelocity=0 end function V3.findBat()local char=LP.Character if not char then return nil end local equipped=char:FindFirstChildOfClass("Tool")if equipped then local n=equipped.Name:lower()if n:find("bat")or n:find("slap")then return equipped end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,tool in ipairs(bp:GetChildren())do if tool:IsA("Tool")then local n=tool.Name:lower()if n:find("bat")or n:find("slap")then return tool end end end end return nil end function V3.nearest(myRoot)local nearest,nearestDist=nil,math.huge for _,player in ipairs(Players:GetPlayers())do if player~=LP and player.Character then local tr=player.Character:FindFirstChild("HumanoidRootPart")local th=player.Character:FindFirstChildOfClass("Humanoid")if tr and th and th.Health>0 then local d=(tr.Position-myRoot.Position).Magnitude if d<nearestDist then nearestDist=d;nearest=player end end end end return nearest,nearestDist end function V3.face(myRoot,direction)if direction.Magnitude<0.01 then return end local cross=myRoot.CFrame.LookVector:Cross(direction.Unit)local angle=math.asin(math.clamp(cross.Magnitude,-1,1))myRoot.AssemblyAngularVelocity=cross.Magnitude>0.01 and cross.Unit*angle*80 or Vector3.zero end function V3.updatePing()local ok,ping=pcall(function()return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()end)if ok and type(ping)=="number"then V3.st.realPingMs=math.floor(ping)end V3.st.currentPing=math.clamp(V3.st.realPingMs/1000,V3.cfg.MIN_PING_COMPENSATION,V3.cfg.MAX_PING_COMPENSATION)end function V3.swing()local s,cfg=V3.st,V3.cfg local now=tick()if s.swingLocked or now<s.nextSwingAt then return end s.swingLocked=true s.nextSwingAt=now+cfg.SWING_COOLDOWN pcall(function()local char=LP.Character if not char then return end local bat=V3.findBat()if not bat then return end if bat.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:EquipTool(bat)end end bat:Activate()local remote=bat:FindFirstChildWhichIsA("RemoteEvent")if remote then remote:FireServer()end end)task.delay(cfg.SWING_COOLDOWN,function()s.swingLocked=false end)end function V3.loop(dt)local s,cfg=V3.st,V3.cfg local spd=tonumber(State and State.bypassBatSpeed)or tonumber(BYPASS_AIMBOT_SPEED)or 55 if spd~=spd or spd<=0 or spd==math.huge then spd=55 end cfg.FOLLOW_SPEED=spd if not V3.enabled then return end local char=LP.Character if not char then return end local myRoot=char:FindFirstChild("HumanoidRootPart")local myHum=char:FindFirstChildOfClass("Humanoid")if not myRoot or not myHum or myHum.Health<=0 then return end myHum.AutoRotate=false if not char:FindFirstChildOfClass("Tool")then local bat=V3.findBat()if bat and bat.Parent~=char then pcall(function()myHum:EquipTool(bat)end)end end local target=V3.nearest(myRoot)if not target or not target.Character then V3.reset();return end local targetRoot=target.Character:FindFirstChild("HumanoidRootPart")local targetHum=target.Character:FindFirstChildOfClass("Humanoid")if not targetRoot or not targetHum or targetHum.Health<=0 then V3.reset();return end if s.targetPlayer~=target then V3.reset()end s.targetPlayer=target V3.updatePing()local targetPos=targetRoot.Position local dtc=math.max(dt,1/240)if s.lastTargetPos then local instantVel=(targetPos-s.lastTargetPos)/dtc local accel=instantVel-s.targetVelocity if accel.Magnitude>cfg.MAX_VELOCITY_CHANGE then instantVel=s.targetVelocity+accel.Unit*cfg.MAX_VELOCITY_CHANGE end local hv=Vector3.new(instantVel.X,0,instantVel.Z)if hv.Magnitude>cfg.MAX_HORIZONTAL_VELOCITY then hv=hv.Unit*cfg.MAX_HORIZONTAL_VELOCITY instantVel=Vector3.new(hv.X,instantVel.Y,hv.Z)end V3.push(s.accelerationHistory,(instantVel-s.targetVelocity)/dtc,4)V3.push(s.velocityHistory,instantVel,8)V3.push(s.verticalVelocityHistory,instantVel.Y,5)s.targetVelocity=instantVel s.smoothedVelocity=s.smoothedVelocity:Lerp(instantVel,cfg.VELOCITY_SMOOTHING)end s.lastTargetPos=targetPos local isAirborne=targetHum.FloorMaterial==Enum.Material.Air s.airborneTime=isAirborne and(s.airborneTime+dtc)or 0 if isAirborne and s.airborneTime>=cfg.MIN_AIRBORNE_TIME then V3.push(s.aerialVelocityHistory,s.targetVelocity,6)elseif not isAirborne then s.aerialVelocityHistory={}end local smoothedVel=s.smoothedVelocity if isAirborne and#s.aerialVelocityHistory>0 then local avgAerial=V3.avg(s.aerialVelocityHistory)smoothedVel=Vector3.new(avgAerial.X,s.targetVelocity.Y,avgAerial.Z)*cfg.AIR_CONTROL_FACTOR end local isQuickTurn=false local htv=Vector3.new(s.targetVelocity.X,0,s.targetVelocity.Z)if htv.Magnitude>5 then local newDir=htv.Unit if s.previousDirection and s.previousDirection:Dot(newDir)<0.5 then isQuickTurn=(tick()-s.lastDirectionChangeTime)<cfg.DIRECTION_CHANGE_DETECTION_TIME s.lastDirectionChangeTime=tick()end s.previousDirection=newDir end local serverDelay=s.currentPing+cfg.SERVER_TICKRATE local adjustedDelay=isQuickTurn and(serverDelay*cfg.QUICK_DIRECTION_CHANGE_MULTIPLIER)or serverDelay local avgAccel=V3.avg(s.accelerationHistory)local accelContribution=avgAccel*cfg.ACCELERATION_PREDICTION_WEIGHT*(adjustedDelay*adjustedDelay*0.5)local predictedPos=targetPos+smoothedVel*adjustedDelay+accelContribution local predictionTime=cfg.PREDICTION_TIME*1.1 if isAirborne then predictedPos=predictedPos+smoothedVel*predictionTime+Vector3.new(0,-0.5*cfg.GRAVITY*predictionTime*predictionTime,0)else predictedPos=predictedPos+smoothedVel*predictionTime end local hs=Vector3.new(smoothedVel.X,0,smoothedVel.Z)if hs.Magnitude>1 then predictedPos=predictedPos+hs.Unit*cfg.PREDICT_AHEAD end local direction=predictedPos-myRoot.Position V3.face(myRoot,direction)if(targetPos-myRoot.Position).Magnitude<=cfg.ACTIVATE_DISTANCE then if tick()-s.lastActivationTime>=0.3 then V3.swing()s.lastActivationTime=tick()end end if direction.Magnitude>cfg.MIN_FOLLOW_DISTANCE then myRoot.AssemblyLinearVelocity=direction.Unit*cfg.FOLLOW_SPEED else local cv=myRoot.AssemblyLinearVelocity myRoot.AssemblyLinearVelocity=Vector3.new(0,cv.Y*0.5,0)end end function V3.start()if V3.enabled then return end V3.enabled=true if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end if _suppressBodyLock then pcall(_suppressBodyLock)end local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then V3.st.previousHumanoid=hum V3.st.previousAutoRotate=hum.AutoRotate hum.AutoRotate=false end V3.reset()V3.st.lastActivationTime=0 V3.conn=RunService.RenderStepped:Connect(function(dt)if _mySession~=_G.RivalHubSession then if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end return end pcall(V3.loop,dt)end)end function V3.stop()if not V3.enabled then return end V3.enabled=false if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end if V3.conn then V3.conn:Disconnect();V3.conn=nil end local char=LP.Character if char then local myRoot=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if myRoot then myRoot.AssemblyLinearVelocity=Vector3.zero myRoot.AssemblyAngularVelocity=Vector3.zero end local prev=V3.st.previousHumanoid if prev and prev.Parent then prev.AutoRotate=V3.st.previousAutoRotate==nil and true or V3.st.previousAutoRotate elseif hum then hum.AutoRotate=true end end V3.st.previousHumanoid=nil V3.st.previousAutoRotate=nil V3.reset()if _unsuppressBodyLock then pcall(_unsuppressBodyLock,true)end end _G.__RivalHubBatVersion=(_G.__RivalHubBatVersion=="v3")and"v3"or"v2"
-- === Bat Aura Light (bypass / V2 / V3 / TP Bat) ===
local BatAura={token=0,followConn=nil}
local function _batAuraAnyOn()
	if autoBatEnabled==true then return true end
	if TPBatState and TPBatState.enabled==true then return true end
	if type(V2)=="table" and V2.enabled==true then return true end
	if type(V3)=="table" and V3.enabled==true then return true end
	return false
end
local function _batAuraGetRoot(char)
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("UpperTorso")
		or char:FindFirstChild("Torso")
end
local function _batAuraStrip(char)
	if not char then return end
	local folder=char:FindFirstChild("ZeyHubbBatAura")
	if folder then pcall(function() folder:Destroy() end) end
	local root=_batAuraGetRoot(char)
	if root then
		local pl=root:FindFirstChild("ZeyHubbBatAuraLight")
		if pl then pcall(function() pl:Destroy() end) end
	end
	for _,d in ipairs(char:GetDescendants()) do
		if d.Name=="ZeyHubbBatAuraLight" or d.Name=="BatAuraCore" or d.Name=="BatAuraHalo" or d.Name=="ZeyHubbBatAura" then
			pcall(function() d:Destroy() end)
		end
	end
end
function BatAura.clear()
	BatAura.token=(BatAura.token or 0)+1
	if BatAura.followConn then
		pcall(function() BatAura.followConn:Disconnect() end)
		BatAura.followConn=nil
	end
	_batAuraStrip(LP.Character)
end
function BatAura.apply()
	local char=LP.Character
	if not char then return end
	local hrp=_batAuraGetRoot(char)
	if not hrp then return end
	_batAuraStrip(char)
	local folder=Instance.new("Folder")
	folder.Name="ZeyHubbBatAura"
	folder.Parent=char
	-- main light parented to HRP so it follows physics
	local light=Instance.new("PointLight")
	light.Name="ZeyHubbBatAuraLight"
	light.Color=Color3.fromRGB(255, 180, 60)
	light.Brightness=6
	light.Range=16
	light.Shadows=false
	light.Parent=hrp
	-- glowing core welded to body (torso preferred)
	local body=char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or hrp
	local core=Instance.new("Part")
	core.Name="BatAuraCore"
	core.Shape=Enum.PartType.Ball
	core.Size=Vector3.new(0.5,0.5,0.5)
	core.Material=Enum.Material.Neon
	core.Color=Color3.fromRGB(255, 235, 130)
	core.Transparency=0.1
	core.CanCollide=false
	core.CanTouch=false
	core.CanQuery=false
	core.Massless=true
	core.CastShadow=false
	core.Anchored=false
	core.CFrame=body.CFrame
	core.Parent=folder
	local w=Instance.new("Weld")
	w.Name="BatAuraWeld"
	w.Part0=body
	w.Part1=core
	w.C0=CFrame.new(0, 0.15, 0)
	w.C1=CFrame.new()
	w.Parent=core
	local light2=Instance.new("PointLight")
	light2.Name="BatAuraCoreLight"
	light2.Color=Color3.fromRGB(255, 210, 90)
	light2.Brightness=3.5
	light2.Range=9
	light2.Shadows=false
	light2.Parent=core
	local halo=Instance.new("Part")
	halo.Name="BatAuraHalo"
	halo.Shape=Enum.PartType.Ball
	halo.Size=Vector3.new(1.2,1.2,1.2)
	halo.Material=Enum.Material.Neon
	halo.Color=Color3.fromRGB(255, 155, 40)
	halo.Transparency=0.8
	halo.CanCollide=false
	halo.CanTouch=false
	halo.CanQuery=false
	halo.Massless=true
	halo.CastShadow=false
	halo.Anchored=false
	halo.CFrame=body.CFrame
	halo.Parent=folder
	local w2=Instance.new("Weld")
	w2.Name="BatAuraHaloWeld"
	w2.Part0=body
	w2.Part1=halo
	w2.C0=CFrame.new(0, 0.15, 0)
	w2.C1=CFrame.new()
	w2.Parent=halo
	-- force-follow every frame (si le weld lache un frame, on resync)
	if BatAura.followConn then pcall(function() BatAura.followConn:Disconnect() end) end
	local myTok=BatAura.token
	BatAura.followConn=RunService.Heartbeat:Connect(function()
		if BatAura.token~=myTok or not _batAuraAnyOn() then
			pcall(function() if BatAura.followConn then BatAura.followConn:Disconnect() end end)
			BatAura.followConn=nil
			return
		end
		local c=LP.Character
		if not c or not core or not core.Parent then return end
		local b=c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or c:FindFirstChild("HumanoidRootPart")
		if b and core.Parent then
			-- weld handles it; just keep light alive on current root
			local root=_batAuraGetRoot(c)
			if root and light and light.Parent~=root then
				light.Parent=root
			end
		end
	end)
	-- pulse
	task.spawn(function()
		local t0=tick()
		while BatAura.token==myTok and _batAuraAnyOn() do
			if not light or not light.Parent then break end
			local pulse=0.55+0.45*math.abs(math.sin((tick()-t0)*3.4))
			light.Brightness=4.5+pulse*2.8
			light.Range=13+pulse*5
			if light2 and light2.Parent then light2.Brightness=2.4+pulse*2 end
			if core and core.Parent then core.Transparency=0.06+pulse*0.12 end
			if halo and halo.Parent then
				halo.Transparency=0.74+pulse*0.12
				local s=1.15+pulse*0.22
				halo.Size=Vector3.new(s,s,s)
			end
			task.wait(0.03)
		end
	end)
end
function BatAura.refresh()
	if _batAuraAnyOn() then
		pcall(BatAura.apply)
	else
		pcall(BatAura.clear)
	end
end
_G.__ZeyHubbBatAuraRefresh=BatAura.refresh
_G.__ZeyHubbBatAuraClear=BatAura.clear
pcall(function()
	LP.CharacterAdded:Connect(function(char)
		task.delay(0.4,function()
			if _batAuraAnyOn() then pcall(BatAura.apply) end
		end)
	end)
end)

BatCtl={}function BatCtl.isOn()return V2.enabled==true or V3.enabled==true end function BatCtl.stop()if V3.enabled then V3.stop()end stopBatV2()end function BatCtl.start()if V3.enabled then V3.stop()end if V2.enabled then stopBatV2()end if _G.__RivalHubBatVersion=="v3"then V3.start()else startBatV2()end end function BatCtl.setVersion(ver)ver=(ver=="v3")and"v3"or"v2"local wasOn=BatCtl.isOn()if wasOn then BatCtl.stop()end _G.__RivalHubBatVersion=ver if _G.updateBatVersionUI then pcall(_G.updateBatVersionUI,ver)end if _G.__RivalHubRefreshBatLabel then pcall(_G.__RivalHubRefreshBatLabel)end if wasOn then BatCtl.start()end if saveAllSettings then pcall(saveAllSettings)end end _G.__RivalHubStartBatV2=BatCtl.start _G.__RivalHubStopBatV2=BatCtl.stop _G.__RivalHubIsBatV2=BatCtl.isOn _G.__RivalHubSetBatVersion=BatCtl.setVersion LP.CharacterAdded:Connect(function()task.wait(0.5)if V2.enabled then V2.equipped=false V2.target=nil local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if hrp then cleanMovers(hrp)ensureAngular(hrp)end end end)end function createMobilePanel()local panel=Instance.new("ScreenGui")panel.Name="RivalHubMobilePanel"panel.Enabled=false panel.ResetOnSpawn=false panel.ZIndexBehavior=Enum.ZIndexBehavior.Sibling panel.DisplayOrder=10000 panel.IgnoreGuiInset=true pcall(function()if syn and syn.protect_gui then syn.protect_gui(panel)end end)local okPanel=pcall(function()panel.Parent=game:GetService("CoreGui")end)if not okPanel then panel.Parent=LP:WaitForChild("PlayerGui")end local BTN_W,BTN_H=62,62 local buttons={}local buttonNames={"DropBR","AutoLeft","AutoBat","AutoRight","TpDown","Carry","Lagger1","Lagger2","BatV2","BatTP","Float","InstantReset"}local buttonTexts={"DROP\nBR","AUTO\nLEFT","BYPASS\nBAT","AUTO\nRIGHT","TP\nDOWN","CARRY\nSPEED","LAGGER\nNORMAL","LAGGER\nCARRY","BAT\nV2","BAT\nTP","FLOAT","INSTANT\nRESET"}local function createButton(name,text,order,isToggle,callback)local btn=Instance.new("TextButton",panel)btn.Name=name btn.Size=UDim2.new(0,BTN_W,0,BTN_H)btn.BackgroundColor3=Color3.fromRGB(10,10,10)btn.BorderSizePixel=0 btn.Text=""btn.AutoButtonColor=false btn.Active=true btn.Selectable=true btn.ZIndex=100 local savedPos=savedButtonPositions[name]if name=="InstantReset"and savedPos then local cam=Workspace.CurrentCamera local view=cam and cam.ViewportSize or Vector2.new(390,800)if type(savedPos.X)~="number"or type(savedPos.Y)~="number"or savedPos.X<0 or savedPos.Y<0 or savedPos.X>view.X-BTN_W or savedPos.Y>view.Y-BTN_H then savedPos=nil end end if savedPos then btn.Position=UDim2.new(0,savedPos.X or 0,0,savedPos.Y or 0)else local defX,defY=getDefaultButtonPosition(name)btn.Position=UDim2.new(0,defX,0,defY)if name=="InstantReset"then savedButtonPositions[name]={X=defX,Y=defY}end end if name=="InstantReset"then btn.Visible=true btn:SetAttribute("ZeyHubbInstantResetButton",true)end btn.BackgroundColor3=Color3.fromRGB(245,245,250)Instance.new("UICorner",btn).CornerRadius=UDim.new(0,16)local bgGrad=Instance.new("UIGradient",btn)bgGrad.Name="BtnGrad"bgGrad.Rotation=90 bgGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(230,232,240)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(185,190,205)),})local stroke=Instance.new("UIStroke",btn)stroke.Color=Color3.fromRGB(255,255,255)stroke.Thickness=0 stroke.Transparency=1 stroke.Name="NormalStroke"local accentBar=Instance.new("Frame",btn)accentBar.Name="AccentBar"accentBar.Size=UDim2.new(0.55,0,0,3)accentBar.Position=UDim2.new(0.5,0,0,6)accentBar.AnchorPoint=Vector2.new(0.5,0)accentBar.BackgroundColor3=Color3.fromRGB(200,200,210)accentBar.BorderSizePixel=0 accentBar.Active=false accentBar.ZIndex=102 Instance.new("UICorner",accentBar).CornerRadius=UDim.new(1,0)local label=Instance.new("TextLabel",btn)label.Name="TextLabel"label.Size=UDim2.new(1,-8,1,-14)label.Position=UDim2.new(0,4,0,10)label.BackgroundTransparency=1 label.Text=text label.TextColor3=Color3.fromRGB(35,38,48)label.Font=Enum.Font.GothamBlack label.TextSize=10 label.TextWrapped=true label.Active=false label.Selectable=false label.ZIndex=101 local uiScale=Instance.new("UIScale",btn)uiScale.Scale=floatingButtonScale table.insert(_floatingUIScales,uiScale)local active=false local function setActive(state)active=state btn:SetAttribute("MobActive",state and true or false)paintFloatingBtn(btn,state)end setActive(false)local dragging=false local hasMoved=false local dragStart=nil local startPos=nil local movedDistance=0 local dragConn=nil local touchConn=nil local lockedTapInput=nil local lockedTapHandled=false local function runButtonCallback()if isToggle then if callback then pcall(callback,setActive)end else if callback then pcall(callback,setActive,active)end end end local function endDrag(input)if lockedTapInput then if input~=lockedTapInput or lockedTapHandled then return end lockedTapHandled=true local p=input.Position local ap,as=btn.AbsolutePosition,btn.AbsoluteSize local releasedInside=p.X>=ap.X and p.X<=ap.X+as.X and p.Y>=ap.Y and p.Y<=ap.Y+as.Y if releasedInside then runButtonCallback()end lockedTapInput=nil return end if not dragging then return end if movedDistance<8 and not hasMoved then runButtonCallback()elseif hasMoved then savedButtonPositions[name]={X=btn.Position.X.Offset,Y=btn.Position.Y.Offset}task.defer(function()pcall(saveAllSettings)end)end dragging=false hasMoved=false dragStart=nil startPos=nil movedDistance=0 _isDraggingButton=false if dragConn then dragConn:Disconnect();dragConn=nil end if touchConn then touchConn:Disconnect();touchConn=nil end end btn.Activated:Connect(function()end)local function updateDragPosition(input)if not dragging or not dragStart or not startPos then return end local delta=input.Position-dragStart movedDistance=delta.Magnitude if uiLocked or mobileButtonsLocked then return end if movedDistance>=6 then hasMoved=true local cam=Workspace.CurrentCamera local viewport=cam and cam.ViewportSize or Vector2.new(390,800)local maxX=math.max(0,viewport.X-btn.AbsoluteSize.X)local maxY=math.max(0,viewport.Y-btn.AbsoluteSize.Y)local x=math.clamp(startPos.X.Offset+delta.X,0,maxX)local y=math.clamp(startPos.Y.Offset+delta.Y,0,maxY)btn.Position=UDim2.new(0,x,0,y)end end btn.InputBegan:Connect(function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if uiLocked or mobileButtonsLocked then lockedTapInput=input lockedTapHandled=false return end dragging=true hasMoved=false movedDistance=0 dragStart=input.Position startPos=btn.Position _isDraggingButton=true if dragConn then dragConn:Disconnect()end if touchConn then touchConn:Disconnect()end dragConn=UIS.InputChanged:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then updateDragPosition(inp)end end)if input.UserInputType==Enum.UserInputType.Touch then touchConn=UIS.TouchMoved:Connect(function(inp)updateDragPosition(inp)end)end end)btn.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then endDrag(input)end end)UIS.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then endDrag(input)end end)buttons[name]={btn=btn,setActive=setActive,label=label}return setActive end for i,name in ipairs(buttonNames)do local text=buttonTexts[i]local callback if name=="DropBR"then callback=function(setActive)if autoBatEnabled then return end setActive(true)executeDropWithToggle(function(v)if dropBrainrotSetVisual then dropBrainrotSetVisual(v)end end)task.delay(0.3,function()setActive(false)end)end elseif name=="AutoLeft"then callback=function(setActive)autoLeftEnabled=not autoLeftEnabled setActive(autoLeftEnabled)if autoLeftEnabled then startAutoLeft()else stopAutoLeft()end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled)end end elseif name=="AutoBat"then callback=function(setActive)if not autoBatEnabled then enableAutoBat()else disableAutoBat()end setActive(autoBatEnabled)end elseif name=="AutoRight"then callback=function(setActive)autoRightEnabled=not autoRightEnabled setActive(autoRightEnabled)if autoRightEnabled then startAutoRight()else stopAutoRight()end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled)end end elseif name=="TpDown"then callback=function(setActive)doTpDown()setActive(true)task.delay(0.2,function()setActive(false)end)end elseif name=="Carry"then callback=function(setActive)if not speedMode then speedMode=true;laggerToggled=false;laggerCarryToggled=false;setActive(true)if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false)end if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false)end else speedMode=false;setActive(false)end refreshSpeedModeLabel()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end elseif name=="Lagger1"then callback=function(setActive)if speedMode then speedMode=false;if mobSetCarry then mobSetCarry(false)end end if not laggerToggled then laggerToggled=true;laggerCarryToggled=false;setActive(true)if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false)end else laggerToggled=false;setActive(false)end refreshSpeedModeLabel()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end elseif name=="Lagger2"then callback=function(setActive)if speedMode then speedMode=false;if mobSetCarry then mobSetCarry(false)end end if not laggerCarryToggled then laggerCarryToggled=true;laggerToggled=false;setActive(true)if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false)end else laggerCarryToggled=false;laggerToggled=false;setActive(false)end refreshSpeedModeLabel()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end elseif name=="BatV2"then callback=function(setActive)if not _G.__RivalHubIsBatV2()then _G.__RivalHubStartBatV2()setActive(true)else _G.__RivalHubStopBatV2()setActive(false)end if _G.__RivalHubBatSetVisual then pcall(_G.__RivalHubBatSetVisual,_G.__RivalHubIsBatV2()==true)end end elseif name=="BatTP"then callback=function(setActive)local on=not(TPBatState and TPBatState.enabled)if tpBatSetEnabled then pcall(tpBatSetEnabled,on)end setActive(TPBatState and TPBatState.enabled or false)end elseif name=="InstantReset"then callback=function(setActive)local run=_G.__ZeyHubbRunInstantReset if type(run)=="function"then setActive(true)pcall(run)task.delay(0.35,function()setActive(false)end)else setActive(false)warn("[ZeyHubb] Instant Reset engine is not ready.")end end end if name=="Float"then callback=function(setActive)if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle()end setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning()or false)end end local setActive=createButton(name,text,i-1,true,callback)if name=="Float"then mobSetFloat=setActive end if name=="AutoBat"then mobSetAutoBat=setActive end if name=="AutoLeft"then mobSetAutoLeft=setActive end if name=="AutoRight"then mobSetAutoRight=setActive end if name=="DropBR"then mobSetDropBR=setActive end if name=="TpDown"then mobSetTpDown=setActive end if name=="Carry"then mobSetCarry=setActive end if name=="Lagger1"then mobSetLagger1=setActive end if name=="Lagger2"then mobSetLagger2=setActive end if name=="BatV2"then mobSetBatV2=setActive end if name=="BatTP"then mobSetBatTP=setActive end end _G.__RivalHubRefreshBatLabel=function()local b=buttons.BatV2 if b and b.label then b.label.Text=(_G.__RivalHubBatVersion=="v3")and"BAT\nV3"or"BAT\nV2"end end pcall(_G.__RivalHubRefreshBatLabel)if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled)end if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled)end if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled)end if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode)end if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled)end if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled)end if buttons.BatV2 and buttons.BatV2.setActive then buttons.BatV2.setActive(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false)end if buttons.BatTP and buttons.BatTP.setActive then buttons.BatTP.setActive(TPBatState and TPBatState.enabled or false)end if buttons.Float and buttons.Float.setActive then buttons.Float.setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning()or false)end if buttons.InstantReset and buttons.InstantReset.setActive then buttons.InstantReset.btn.Visible=true buttons.InstantReset.setActive(false)else warn("[ZeyHubb] Instant Reset floating button was not created.")end pcall(function()local bv=buttons.BatV2 and buttons.BatV2.btn local bt=buttons.BatTP and buttons.BatTP.btn if bv and bt then local gap=8 local placeRight=bv.Position.X.Offset+BTN_W+gap local placeY=bv.Position.Y.Offset local saved=savedButtonPositions["BatTP"]local near=false if saved and type(saved.X)=="number"and type(saved.Y)=="number"then local dx=math.abs((saved.X or 0)-bv.Position.X.Offset)local dy=math.abs((saved.Y or 0)-bv.Position.Y.Offset)if dx<200 and dy<100 then near=true end end if not near then bt.Position=UDim2.new(0,placeRight,0,placeY)savedButtonPositions["BatTP"]={X=placeRight,Y=placeY}end end end)pcall(function()local cam=Workspace.CurrentCamera local viewport=cam and cam.ViewportSize or Vector2.new(390,800)local gap,margin=8,12 local names={"DropBR","AutoRight","AutoBat","AutoLeft","TpDown","Carry","Lagger1","Lagger2","InstantReset","Float","BatTP","BatV2"}local function put(name,x,y)local item=buttons[name]local btn=item and item.btn if not btn then return end local saved=savedButtonPositions[name]if type(saved)=="table"and type(saved.X)=="number"and type(saved.Y)=="number"then local sx=math.clamp(saved.X,0,math.max(0,viewport.X-BTN_W))local sy=math.clamp(saved.Y,0,math.max(0,viewport.Y-BTN_H))btn.Position=UDim2.new(0,sx,0,sy)savedButtonPositions[name]={X=sx,Y=sy}return end x=math.clamp(x,0,math.max(0,viewport.X-BTN_W))y=math.clamp(y,0,math.max(0,viewport.Y-BTN_H))btn.Position=UDim2.new(0,x,0,y)savedButtonPositions[name]={X=x,Y=y}end if viewport.X>=900 then local totalW=6*BTN_W+5*gap local startX=math.max(margin,viewport.X-totalW-margin)local topY=math.max(margin,24)local actionX=startX+4*(BTN_W+gap)put("InstantReset",startX,topY+BTN_H+gap)put("Float",startX+(BTN_W+gap),topY+BTN_H+gap)put("BatTP",startX+2*(BTN_W+gap),topY+BTN_H+gap)put("BatV2",startX+3*(BTN_W+gap),topY+BTN_H+gap)local grid={{"DropBR","AutoRight"},{"AutoBat","AutoLeft"},{"TpDown","Carry"},{"Lagger1","Lagger2"},}for r,pair in ipairs(grid)do put(pair[1],actionX,topY+(r-1)*(BTN_H+gap))put(pair[2],actionX+BTN_W+gap,topY+(r-1)*(BTN_H+gap))end else local startX=math.max(margin,viewport.X-(2*BTN_W+gap)-margin)local startY=math.max(margin,24)for i,name in ipairs(names)do local index=i-1 local col=index%2 local row=math.floor(index/2)put(name,startX+col*(BTN_W+gap),startY+row*(BTN_H+gap))end end end)return panel end batCounterV2Enabled=false batCounterV2Debounce=false batCounterV2Conn=nil batCounterV2HitCooldown=false BAT_COUNTER_V2_SWING_CD=0.08 setBatCounterV2Visual=nil local _batCounterV2OriginalTpState=false local _batCounterV2SuppressCount=0 local _lastBatCounterV2Time=0 local _batCounterV2Cooldown=0.01 local function isPlayerRagdolled(player)if not player or not player.Character then return false end local hum=player.Character:FindFirstChildOfClass("Humanoid")if not hum then return false end local state=hum:GetState()return state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown end local function hasAnimalEquipped(player)if not player or not player.Character then return false end for _,child in ipairs(player.Character:GetChildren())do if child:IsA("Tool")then if child:FindFirstChild("Handle")or child.Name:find("Animal")or child.Name:find("Pet")then return true end end end return false end local function getAttackingPlayerWithAnimal()local myChar=LP.Character if not myChar then return nil end local myRoot=myChar:FindFirstChild("HumanoidRootPart")if not myRoot then return nil end local closest,minDist=nil,_huge for _,plr in ipairs(Players:GetPlayers())do if plr~=LP and plr.Character then if not hasAnimalEquipped(plr)then continue end local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")local hum=plr.Character:FindFirstChildOfClass("Humanoid")if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-myRoot.Position).Magnitude if dist<12 and dist<minDist then minDist=dist;closest=plr end end end end return closest end local function getBatV2Counter()local char=LP.Character if not char then return nil end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")then local name=child.Name:lower()if name:find("bat")or name:find("slap")or name:find("sword")or name:find("knife")then return child end end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,child in ipairs(bp:GetChildren())do if child:IsA("Tool")then local name=child.Name:lower()if name:find("bat")or name:find("slap")or name:find("sword")or name:find("knife")then child.Parent=char return child end end end end if bp then for _,child in ipairs(bp:GetChildren())do if child:IsA("Tool")then child.Parent=char;return child end end end return nil end local function tryHitBatCounterV2()if batCounterV2HitCooldown then return end batCounterV2HitCooldown=true pcall(function()local bat=getBatV2Counter()if bat then bat:Activate()local ev=bat:FindFirstChildWhichIsA("RemoteEvent")if ev then ev:FireServer()end end end)task.delay(BAT_COUNTER_V2_SWING_CD,function()batCounterV2HitCooldown=false end)end local function executeBatCounterV2()local now=_tick()if now-(_lastBatCounterV2Time or 0)<(_batCounterV2Cooldown or 0.01)then return end if batCounterV2Debounce then return end batCounterV2Debounce=true _lastBatCounterV2Time=now local attacker=getAttackingPlayerWithAnimal()if not attacker then batCounterV2Debounce=false;return end if isPlayerRagdolled(attacker)then batCounterV2Debounce=false;return end if not hasAnimalEquipped(attacker)then batCounterV2Debounce=false;return end local function doCounterHit()local char=LP.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart")if not hrp then return end local attChar=attacker.Character if not attChar then return end local attRoot=attChar:FindFirstChild("HumanoidRootPart")if not attRoot then return end if not hasAnimalEquipped(attacker)then batCounterV2Debounce=false;return end if sethiddenproperty then sethiddenproperty(hrp,"PhysicsRepRootPart",attRoot)end local targetPos=attRoot.Position+_V3new(0,0.9,0)if(hrp.Position-targetPos).Magnitude>8 then hrp.CFrame=_CFnew(targetPos)end tryHitBatCounterV2()task.delay(0.05,function()tryHitBatCounterV2()end)task.delay(0.1,function()tryHitBatCounterV2()end)end doCounterHit()task.delay(0.2,function()batCounterV2Debounce=false end)end function stopBatCounterV2()if batCounterV2Conn then batCounterV2Conn:Disconnect()batCounterV2Conn=nil end batCounterV2Debounce=false batCounterV2HitCooldown=false end function startBatCounterV2()if batCounterV2Conn then return end batCounterV2Conn=RunService.Heartbeat:Connect(function()if not batCounterV2Enabled then return end if batCounterV2Debounce then return end local character=LP.Character if not character then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid or humanoid.Health<=0 then return end local state=humanoid:GetState()local isBeingAttacked=state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.GettingUp or state==Enum.HumanoidStateType.Stunned if isBeingAttacked then local attacker=getAttackingPlayerWithAnimal()if attacker then if not isPlayerRagdolled(attacker)then if hasAnimalEquipped(attacker)then executeBatCounterV2()end end end end end)end function toggleBatCounterV2()batCounterV2Enabled=not batCounterV2Enabled if batCounterV2Enabled then startBatCounterV2()else stopBatCounterV2()end return batCounterV2Enabled end function updateUIFromLoaded()task.wait()if normalBox then normalBox.Text=tostring(NS)end if carryBox then carryBox.Text=tostring(CS)end if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED)end if lagger2Box then lagger2Box.Text=tostring(LAGGER_CARRY_SPEED)end if batSpeedBox then batSpeedBox.Text=tostring(BYPASS_AIMBOT_SPEED)end if uiScaleBox then uiScaleBox.Text=tostring(uiScaleValue)end if stealBarScaleBox then stealBarScaleBox.Text=tostring(_floor((stealBarScale or 1)*100+0.5))end if pbScale then pbScale.Scale=stealBarScale or 1 end if dropModeBtnRef then dropModeBtnRef.Text=dropMode==1 and"Fling"or"Jump Drop"end if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end if infJumpModeBtn then infJumpModeBtn.Text=string.upper(InfiniteJump.mode=="manual"and"manual"or"hold")end if autoStealModeBtn then autoStealModeBtn.Text=autoStealMode=="V2"and"V2"or"V1"end refreshSpeedModeLabel()local savedInfJumpEnabled=InfiniteJump.enabled==true InfiniteJump.stop()if savedInfJumpEnabled then InfiniteJump.start()if infJumpSetVisual then infJumpSetVisual(true)end elseif infJumpSetVisual then infJumpSetVisual(false)end for _,ref in ipairs(keyButtonRefs)do local entry=ref.entry local label=(entry.gp and entry.gp.Name)or(entry.kb and entry.kb.Name)or"None"ref.btn.Text=label end if savedProgressBarPos and pbFrame then pbFrame.Position=UDim2.new(savedProgressBarPos.XScale or 0.5,savedProgressBarPos.XOffset or-160,savedProgressBarPos.YScale or 0.80,savedProgressBarPos.YOffset or 0)end applyBackgroundMode(backgroundMode)applyFloatingButtonScale()if setSmallButtonsVisual then setSmallButtonsVisual()end if uiLocked and setLockUIVisual then setLockUIVisual(true)end if _G.updateBatVersionUI then pcall(_G.updateBatVersionUI,_G.__RivalHubBatVersion or"v2")end if _G.__RivalHubRefreshBatLabel then pcall(_G.__RivalHubRefreshBatLabel)end if antiRagdollMode=="v1"or antiRagdollMode=="v2"then if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode)end setAntiRagdollMode(antiRagdollMode)else if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI("off")end end if antiDieEnabled then if setAntiDieVisual then setAntiDieVisual(true)end AntiDieModule.start()else if setAntiDieVisual then setAntiDieVisual(false)end end if antiBatEnabled then if setAntiBatVisual then setAntiBatVisual(true)end startAntiBat()else if setAntiBatVisual then setAntiBatVisual(false)end end if antiFlingEnabled then if setAntiFlingVisual then setAntiFlingVisual(true)end startAntiFling()else if setAntiFlingVisual then setAntiFlingVisual(false)end stopAntiFling()end if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true);pcall(startAutoSteal)end if medusaCounterEnabled then if setMedusaVisual then setMedusaVisual(true)end if LP.Character then setupMedusaCounter(LP.Character)end else if setMedusaVisual then setMedusaVisual(false)end stopMedusaCounter()end if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true)startBatCounter()end if batCounterV2Enabled and setBatCounterV2Visual then setBatCounterV2Visual(true)startBatCounterV2()end if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true)task.spawn(function()task.wait(0.5);startUnwalk()end)end if antiLagEnabled then if setAntiLagVisual then setAntiLagVisual(true)end enableAntiLag()else if setAntiLagVisual then setAntiLagVisual(false)end disableAntiLag()end if espEnabled then toggleESP(true)if setESPVIsual then setESPVIsual(true)end else toggleESP(false)if setESPVIsual then setESPVIsual(false)end end if espLineEnabled then if setESPLineVisual then setESPLineVisual(true)end startESPLine()else if setESPLineVisual then setESPLineVisual(false)end stopESPLine()end if vividGraphicsEnabled then enableVividGraphics()if setVividVisual then setVividVisual(true)end else disableVividGraphics()if setVividVisual then setVividVisual(false)end end if stretchEnabled then enableStretch()if _G.stretchToggleSetter then _G.stretchToggleSetter(true)end else if _G.stretchToggleSetter then _G.stretchToggleSetter(false)end end if mobSetAutoBat then mobSetAutoBat(autoBatEnabled)end if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled)end if mobSetAutoRight then mobSetAutoRight(autoRightEnabled)end if mobSetCarry then mobSetCarry(speedMode)end if mobSetLagger1 then mobSetLagger1(laggerToggled)end if mobSetLagger2 then mobSetLagger2(laggerCarryToggled)end if mobSetBatV2 then mobSetBatV2(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false)end if bodyLockEnabled and bodyLockSetVisual then if _blSuppressCount==0 then bodyLockSetVisual(true)startBodyLock()else bodyLockSetVisual(false)end end updateProgressBarVisibility()startEnemySpeed()toggleLockUI(uiLocked)mobileButtonsLocked=uiLocked==true pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel and OUTFITS[currentOutfitIndex]then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end end local _bootErrors={}local function playZeyHubbIntro(onDone)local doneCalled=false local function safeDone()if doneCalled then return end doneCalled=true pcall(function()if onDone then onDone()end end)end task.delay(((_G.__ZeyHubbIntroSongVersion or"v1")=="v2")and 22 or 12.5,safeDone)local ok,err=pcall(function()local parentGui=nil pcall(function()if gethui then parentGui=gethui()end end)if not parentGui then parentGui=LP:FindFirstChild("PlayerGui")or game:GetService("CoreGui")end if not parentGui then safeDone()return end local introGui=Instance.new("ScreenGui")introGui.Name="ZeyHubbIntro"introGui.ResetOnSpawn=false introGui.IgnoreGuiInset=true introGui.DisplayOrder=999999 introGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling introGui.Parent=parentGui pcall(function()if main then main.Visible=false end if miniBtn then miniBtn.Visible=false end if pbFrame then pbFrame.Visible=false end if MobilePanel then if MobilePanel:IsA("ScreenGui")then MobilePanel.Enabled=false end end end)local dim=Instance.new("Frame",introGui)dim.Size=UDim2.new(1,0,1,0)dim.BackgroundColor3=Color3.fromRGB(0,0,0)dim.BackgroundTransparency=0.25 dim.BorderSizePixel=0 dim.ZIndex=1 local introSound=Instance.new("Sound")introSound.Name="ZeyHubbIntroMusic"introSound.Volume=0.65 introSound.Looped=false introSound.Parent=game:GetService("SoundService")task.spawn(function()local ver=_G.__ZeyHubbIntroSongVersion or"v1"local file=(ver=="v2")and"ZeyHubb_IntroSong_V2.mp3"or"ZeyHubb_IntroSong_FromVideo.mp3"local getAsset=getcustomasset or getsynasset local writeFn=writefile or(syn and syn.writefile)if not(getAsset and writeFn)then return end local b64V1="SUQzBAAAAAABA1RYWFgAAAASAAADbWFqb3JfYnJhbmQAbXA0MgBUWFhYAAAAEQAAA21pbm9yX3ZlcnNpb24AMQBUWFhYAAAAIAAAA2NvbXBhdGlibGVfYnJhbmRzAGlzb21tcDQxbXA0MgBUU1NFAAAADgAAA0xhdmY2MS43LjEwMwAAAAAAAAAAAAAA//NwwAAAAAAAAAAAAEluZm8AAAAPAAACLQAAqzkAAwYJDA0QExYYGh0gIiQnKiwvMTQ3OTs+QUNGSEtNUFJVWFpdX2JkZ2lsbnF0dnh7foGDhYiLjY+SlZiZnJ+ipKaprK6ws7a5ur3Aw8XHys3P0dTX2tze4eTm6Ovu8PP1+Pr9AAAAAExhdmM2MS4xOQAAAAAAAAAAAAAAACQDUAAAAAAAAKs5QvhnHAAAAAAAAAAAAAAAAAD/8zDEAAAAA0gAAAAATEFNRVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEQQAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxIMAAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVURuuA/0FBQyQFAaDnd/0T+fic/CH//////hnuc/4TntKIEDC4oJMnqiAkLgADESMVtqIIoHLt6gFBIuP/zMsS9AAADSAAAAAAADESMnbpBlQz2ujbpG3tQhnnDJo50gYXBAkTRtqBQkTBAMKkZPRAgsgYtHqgoFDEBHw7HI9HA7HQ5HA5FYA/ByE3/8zDEvgAAA0gAAAAABQN36HgDx83fhyOCmUXH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AFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMsS9AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMsS9AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMsS9AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMsS9AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV"local b64V2="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iHwyCLBEROnf5f/zMMSkECFWxAtYKAB/lkE+DVEud1xCfMRyk5RqmJ0hTahrLlhOVCYsFWuKKBERXDoyeaHIAYCIiu2t8z+W+vJhCBsCQknvBUUZIIURCf/zMMSkGUHerAGaaAAQhGhsQEZdA2yiISxdBkDQZNI3TCM8zCiKkqjPNw5wAAwhC/NSzxm5UtcLONMTRElMQU1FMy4xMDBVVVVVVVVVVf/zMsSADoDlrAnPYANVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEiA0w6NBIS8zFVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDElAAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMsS9AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMsS9AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxL4AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MyxL0AAANIAAAAAFVVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMMS+AAADSAAAAABVVVVVVVVMQU1FMy4xMDBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zMsS9AAADSAAAAABVVVVVVVVVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zDEvgAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/8zLEvQAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV"local b64=(ver=="v2")and b64V2 or b64V1 local function b64dec(data)local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' data=string.gsub(data,'[^'..b..'=]','')return(data:gsub('.',function(x)if x=='='then return''end local r,f='',(b:find(x)-1)for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and'1'or'0')end return r end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(x)if #x~=8 then return''end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1'and 2^(8-i)or 0)end return string.char(c)end))end local okFile,exists=pcall(function()return isfile and isfile(file)end)if not(okFile and exists)then local okBin,bin=pcall(b64dec,b64)if not okBin or not bin or #bin<100 then return end pcall(function()writeFn(file,bin)end)end local okAsset,asset=pcall(function()return getAsset(file)end)if okAsset and asset and introGui and introGui.Parent then introSound.SoundId=asset pcall(function()introSound:Play()end)end end)local holder=Instance.new("Frame",introGui)holder.AnchorPoint=Vector2.new(0.5,0.5)holder.Position=UDim2.new(0.5,0,0.42,0)holder.Size=UDim2.new(0,620,0,150)holder.BackgroundTransparency=1 holder.ZIndex=10 local scale=Instance.new("UIScale",holder)scale.Scale=0.2 local titleStr="ZeyHubb.vs"local letterSize=56 local letterFrames={}local startX=-(#titleStr*letterSize)/2 for i=1,#titleStr do local ch=titleStr:sub(i,i)local x=startX+(i-1)*letterSize+letterSize/2 local wrap=Instance.new("Frame",holder)wrap.Size=UDim2.new(0,letterSize,0,96)wrap.Position=UDim2.new(0.5,x,0,0)wrap.BackgroundTransparency=1 wrap.Visible=false wrap.ZIndex=11 local ps=Instance.new("UIScale",wrap)ps.Name="PopScale"ps.Scale=0.15 wrap:SetAttribute("BaseX",x)local depths={{0,8,5,Color3.fromRGB(70,20,0)},{0,6,4,Color3.fromRGB(130,50,0)},{0,4,2,Color3.fromRGB(200,100,15)},{0,2,1,Color3.fromRGB(255,160,40)},}for _,d in ipairs(depths)do local lbl=Instance.new("TextLabel",wrap)lbl.Size=UDim2.new(1,0,1,0)lbl.Position=UDim2.new(0,d[3],0,d[2])lbl.BackgroundTransparency=1 lbl.Text=ch lbl.Font=Enum.Font.GothamBlack lbl.TextSize=76 lbl.TextColor3=d[4]lbl.TextXAlignment=Enum.TextXAlignment.Center lbl.ZIndex=11+d[2]end local main=Instance.new("TextLabel",wrap)main.Name="MainLetter"main.Size=UDim2.new(1,0,1,0)main.BackgroundTransparency=1 main.Text=ch main.Font=Enum.Font.GothamBlack main.TextSize=76 main.TextColor3=Color3.fromRGB(255,230,120)main.TextXAlignment=Enum.TextXAlignment.Center main.ZIndex=20 main.TextStrokeColor3=Color3.fromRGB(60,20,0)main.TextStrokeTransparency=0.15 local g=Instance.new("UIGradient",main)g.Name="LetterShine"g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255,240,160)),ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255,180,50)),ColorSequenceKeypoint.new(0.75,Color3.fromRGB(255,140,30)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,220,120)),})local st=Instance.new("UIStroke",main)st.Color=Color3.fromRGB(255,190,70)st.Thickness=2.4 st.Transparency=0.25 letterFrames[i]=wrap end local sub=Instance.new("TextLabel",holder)sub.Name="ByLine"sub.Size=UDim2.new(1,0,0,28)sub.Position=UDim2.new(0,0,0,112)sub.BackgroundTransparency=1 sub.Text=""sub.Visible=false sub.Font=Enum.Font.GothamBlack sub.TextSize=20 sub.TextColor3=Color3.fromRGB(255,210,100)sub.TextTransparency=1 sub.TextXAlignment=Enum.TextXAlignment.Center sub.ZIndex=15 sub.TextStrokeColor3=Color3.fromRGB(120,50,0)sub.TextStrokeTransparency=0.35 local subGrad=Instance.new("UIGradient",sub)subGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,240)),ColorSequenceKeypoint.new(0.40,Color3.fromRGB(255,180,60)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,230,150)),})local subStroke=Instance.new("UIStroke",sub)subStroke.Color=Color3.fromRGB(255,160,40)subStroke.Thickness=1.4 subStroke.Transparency=0.5 local skip=Instance.new("TextLabel",introGui)skip.Size=UDim2.new(0,220,0,28)skip.Position=UDim2.new(0.5,-110,0.82,0)skip.BackgroundTransparency=1 skip.Text="DOUBLE TAP TO SKIP"skip.Font=Enum.Font.GothamBold skip.TextSize=13 skip.TextColor3=Color3.fromRGB(210,210,210)skip.TextTransparency=0.25 skip.ZIndex=51 local finished=false local floatConn=nil local lastTap=0 local inputConn=nil local function finish()if finished then return end finished=true if inputConn then pcall(function()inputConn:Disconnect()end)inputConn=nil end
-- soft letter settle (stop hard beat jumps)
pcall(function()
if floatConn then floatConn:Disconnect() floatConn=nil end
end)
pcall(function()
local fadeInfo=TweenInfo.new(0.55,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
if dim then TS:Create(dim,fadeInfo,{BackgroundTransparency=1}):Play() end
if scale then TS:Create(scale,TweenInfo.new(0.55,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Scale=0.92}):Play() end
if sub then TS:Create(sub,fadeInfo,{TextTransparency=1}):Play() end
if skip then TS:Create(skip,fadeInfo,{TextTransparency=1}):Play() end
for _,w in ipairs(letterFrames)do
if w and w.Parent then
TS:Create(w,fadeInfo,{Rotation=0}):Play()
local ps=w:FindFirstChild("PopScale")
if ps then TS:Create(ps,fadeInfo,{Scale=1}):Play() end
for _,d in ipairs(w:GetDescendants())do
if d:IsA("TextLabel")then
TS:Create(d,fadeInfo,{TextTransparency=1,TextStrokeTransparency=1}):Play()
end
if d:IsA("UIStroke")then
TS:Create(d,fadeInfo,{Transparency=1}):Play()
end
end
end
end
end)
task.spawn(function()
local snd=introSound
if snd and snd.Parent then
local startVol=tonumber(snd.Volume)or 0.65
local t0=tick()
local fadeT=0.7
while snd and snd.Parent and tick()-t0<fadeT do
local a=(tick()-t0)/fadeT
snd.Volume=startVol*(1-a)*(1-a)
task.wait()
end
pcall(function()if snd then snd:Stop() snd:Destroy() end end)
end
if introSound and introSound.Parent and introSound~=snd then
pcall(function()introSound:Stop() introSound:Destroy() end)
end
end)
task.delay(0.75,function()
pcall(function()if introGui then introGui:Destroy() end end)
task.defer(function()safeDone()end)
end)
end local function onSkipTap()if finished then return end local now=tick()if now-lastTap<=0.55 then finish()return end lastTap=now skip.Text="TAP AGAIN TO SKIP"skip.TextColor3=Color3.fromRGB(255,200,100)task.delay(0.6,function()if not finished and skip and skip.Parent then skip.Text="DOUBLE TAP TO SKIP"skip.TextColor3=Color3.fromRGB(210,210,210)lastTap=0 end end)end inputConn=UIS.InputBegan:Connect(function(input)if finished then return end if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then onSkipTap()end end)TS:Create(scale,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()task.spawn(function()for i,w in ipairs(letterFrames)do if finished then return end w.Visible=true local ps=w:FindFirstChild("PopScale")if ps then TS:Create(ps,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end task.wait(0.1)end if finished then return end task.wait(0.1)TS:Create(sub,TweenInfo.new(0.4),{TextTransparency=0}):Play()task.spawn(function()while not finished and subGrad and subGrad.Parent do subGrad.Offset=Vector2.new(-1,0)local tw=TS:Create(subGrad,TweenInfo.new(1.2,Enum.EasingStyle.Linear),{Offset=Vector2.new(1,0)})tw:Play()tw.Completed:Wait()task.wait(0.15)end end)task.spawn(function()local up=true while not finished and subStroke and subStroke.Parent do local tw=TS:Create(subStroke,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=up and 0.15 or 0.55})tw:Play()tw.Completed:Wait()up=not up end end)task.spawn(function()while not finished do for _,w in ipairs(letterFrames)do if finished then return end local main=w:FindFirstChild("MainLetter")local g=main and main:FindFirstChild("LetterShine")if g then g.Offset=Vector2.new(-1,0)TS:Create(g,TweenInfo.new(0.5,Enum.EasingStyle.Linear),{Offset=Vector2.new(1,0)}):Play()end task.wait(0.05)end task.wait(0.3)end end)end)floatConn=RunService.RenderStepped:Connect(function()if finished or not holder.Parent then return end local t=tick()
-- ~128 BPM pulse (matches typical short intro tracks)
local bpm=(((_G.__ZeyHubbIntroSongVersion or"v1")=="v2")and 108 or 128)
local beatPhase=(t*bpm/60)%1
local beat=math.max(0,1-beatPhase*3.2)
beat=beat*beat
local bounce=beat*14
local pulse=1+beat*0.08
scale.Scale=pulse
holder.Position=UDim2.new(0.5,math.sin(t*1.2)*5,0.42,math.sin(t*1.6)*4-bounce*0.35)
for i,w in ipairs(letterFrames)do
if w.Visible then
local baseX=w:GetAttribute("BaseX")or 0
local stagger=(i-1)*0.04
local localBeat=math.max(0,1-((beatPhase+stagger)%1)*3.2)
localBeat=localBeat*localBeat
local y=math.sin(t*2.2+i*0.4)*3-localBeat*16
local x=baseX+math.sin(t*1.5+i*0.3)*2.5
w.Position=UDim2.new(0.5,x,0,y)
w.Rotation=math.sin(t*2.0+i*0.5)*3+localBeat*math.sin(i)*2
local ps=w:FindFirstChild("PopScale")
if ps then ps.Scale=1+localBeat*0.12 end
local main=w:FindFirstChild("MainLetter")
if main then
main.TextTransparency=0
local st=main:FindFirstChildOfClass("UIStroke")
if st then st.Transparency=0.15-localBeat*0.1 st.Thickness=2.4+localBeat*1.6 end
end
end
end
end)task.spawn(function()
local isV2=((_G.__ZeyHubbIntroSongVersion or"v1")=="v2")
local totalDur=isV2 and 19.5 or 10.5
local fadeStart=isV2 and 17.2 or 8.2
local t0=tick()
while not finished do
local elapsed=tick()-t0
if introSound and introSound.Parent and elapsed>=fadeStart then
local a=math.clamp((elapsed-fadeStart)/math.max(0.01,totalDur-fadeStart),0,1)
local base=introSound.Volume
if base>0.65 then base=0.65 end
introSound.Volume=0.65*(1-a*a)
end
if elapsed>=totalDur then break end
task.wait(0.03)
end
if not finished then finish() end
end)end)if not ok then warn("[ZeyHubb Intro] error: ",err)safeDone()end end local function _bootSection(name,fn)print("[Rival Hub Boot] Iniciando:",name)local ok,err=pcall(fn)if not ok then print("[Rival Hub Boot] FALLÓ:",name,tostring(err))table.insert(_bootErrors,{name=name,err=tostring(err)})warn("[Rival Hub Boot] Error en '"..name.."': "..tostring(err))else print("[Rival Hub Boot] OK:",name)end return ok end _bootSection("buildGui",function()buildGui()end)if gui and main then pcall(function()gui.Enabled=false main.Visible=false if miniBtn then miniBtn.Visible=false end if pbFrame then pbFrame.Visible=false end end)_bootSection("loadAllSettings",function()if loadAllSettings()then updateUIFromLoaded()if _G.__ZeyHubbHeadlessApply then pcall(_G.__ZeyHubbHeadlessApply,_G.__ZeyHubbHeadlessEnabled==true)end if _G.__ZeyHubbHeadlessSetVisual then pcall(_G.__ZeyHubbHeadlessSetVisual,_G.__ZeyHubbHeadlessEnabled==true)end if _G.__ZeyHubbKorbloxApply then pcall(_G.__ZeyHubbKorbloxApply,_G.__ZeyHubbKorbloxEnabled==true)end if _G.__ZeyHubbKorbloxSetVisual then pcall(_G.__ZeyHubbKorbloxSetVisual,_G.__ZeyHubbKorbloxEnabled==true)end if _G.__ZeyHubbDuelPingApply then pcall(_G.__ZeyHubbDuelPingApply,_G.__ZeyHubbDuelPingEnabled==true)end if _G.__ZeyHubbDuelPingSetVisual then pcall(_G.__ZeyHubbDuelPingSetVisual,_G.__ZeyHubbDuelPingEnabled==true)end if _G.__ZeyHubbInstantResetRefreshSelector then pcall(_G.__ZeyHubbInstantResetRefreshSelector)end end end)_bootSection("createMobilePanel",function()MobilePanel=createMobilePanel()if MobilePanel then MobilePanel.Enabled=false end end)if hideButtonsEnabled then _bootSection("applyHideButtons",function()applyHideButtons(true)if setHideButtonsVisual then setHideButtonsVisual(true)end end)end _bootSection("localizeRivalHubInterface",function()if gui then localizeRivalHubInterface(gui)end if MobilePanel then localizeRivalHubInterface(MobilePanel)end end)task.spawn(function()playZeyHubbIntro(function()pcall(function()if gui then gui.Enabled=true end if main then main.Visible=true local s=main:FindFirstChildOfClass("UIScale")if s then s.Scale=0.6 TS:Create(s,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=(uiScaleValue or 78)/100}):Play()end end if pbFrame then pbFrame.Visible=true end if MobilePanel then MobilePanel.Enabled=true end end)end)end)if LP.Character then task.spawn(function()task.wait(0.1)if waitForCharReady(LP.Character,5)then pcall(function()captureOriginalAppearance(LP.Character)end)pcall(function()setupMovementAndIndicators(LP.Character)end)if currentAnimPack~="Off"then pcall(function()startAnimPack(currentAnimPack)end)end pcall(function()applyOutfitByIndex(currentOutfitIndex)end)end end)end if#_bootErrors>0 then task.defer(function()pcall(function()local env=(getgenv and getgenv())or _G local writeFn=env.writefile or(syn and syn.writefile)if type(writeFn)=="function"then local log="[Rival Hub Boot Errors] "..os.date("%Y-%m-%d %H:%M:%S").."\n"for _,e in ipairs(_bootErrors)do log=log..e.name..": "..e.err.."\n"end pcall(writeFn,"RivalHub_boot_errors.txt",log)warn("[ZeyHubb.vs] Errores escritos a RivalHub_boot_errors.txt")end end)end)task.defer(function()pcall(function()local errGui=Instance.new("ScreenGui")errGui.Name="RivalHubBootErrors"errGui.ResetOnSpawn=false errGui.DisplayOrder=999 local okCg,cg=pcall(function()return game:GetService("CoreGui")end)if okCg and cg then pcall(function()errGui.Parent=cg end)end if not errGui.Parent then errGui.Parent=LP:WaitForChild("PlayerGui")end local frame=Instance.new("Frame",errGui)frame.Size=UDim2.new(0,460,0,60+#_bootErrors*22)frame.Position=UDim2.new(0,10,1,-80-#_bootErrors*22)frame.BackgroundColor3=Color3.fromRGB(40,10,15)frame.BorderSizePixel=0 Instance.new("UICorner",frame).CornerRadius=UDim.new(0,10)local stroke=Instance.new("UIStroke",frame)stroke.Color=Color3.fromRGB(255,80,90)stroke.Thickness=1.5 local title=Instance.new("TextLabel",frame)title.Size=UDim2.new(1,-20,0,24)title.Position=UDim2.new(0,10,0,8)title.BackgroundTransparency=1 title.Text="⚠ ZeyHubb.vs: "..#_bootErrors.." sección(es) fallaron"title.TextColor3=Color3.fromRGB(255,100,110)title.Font=Enum.Font.GothamBold title.TextSize=13 title.TextXAlignment=Enum.TextXAlignment.Left for i,e in ipairs(_bootErrors)do local lbl=Instance.new("TextLabel",frame)lbl.Size=UDim2.new(1,-20,0,18)lbl.Position=UDim2.new(0,10,0,34+(i-1)*20)lbl.BackgroundTransparency=1 lbl.Text="• "..e.name..": "..e.err:sub(1,110)lbl.TextColor3=Color3.fromRGB(255,180,180)lbl.Font=Enum.Font.Code lbl.TextSize=10 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.TextTruncate=Enum.TextTruncate.AtEnd end local copyBtn=Instance.new("TextButton",frame)copyBtn.Size=UDim2.new(0,100,0,22)copyBtn.Position=UDim2.new(0,10,1,-30)copyBtn.BackgroundColor3=Color3.fromRGB(80,20,30)copyBtn.Text="COPIAR LOG"copyBtn.TextColor3=Color3.fromRGB(255,200,200)copyBtn.Font=Enum.Font.GothamBold copyBtn.TextSize=11 copyBtn.BorderSizePixel=0 Instance.new("UICorner",copyBtn).CornerRadius=UDim.new(0,6)copyBtn.Activated:Connect(function()local buf=""for _,e in ipairs(_bootErrors)do buf=buf..e.name..": "..e.err.."\n"end pcall(function()if setclipboard then setclipboard(buf)end end)copyBtn.Text="¡COPIADO!"task.delay(1.2,function()copyBtn.Text="COPIAR LOG"end)end)local closeBtn=Instance.new("TextButton",frame)closeBtn.Size=UDim2.new(0,60,0,22)closeBtn.Position=UDim2.new(1,-70,1,-30)closeBtn.BackgroundColor3=Color3.fromRGB(80,20,30)closeBtn.Text="CERRAR"closeBtn.TextColor3=Color3.fromRGB(255,200,200)closeBtn.Font=Enum.Font.GothamBold closeBtn.TextSize=11 closeBtn.BorderSizePixel=0 Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)closeBtn.Activated:Connect(function()pcall(function()errGui:Destroy()end)end)task.delay(60,function()pcall(function()errGui:Destroy()end)end)end)end)end else warn("[Rival Hub Boot] Fatal: buildGui falló. El script no puede continuar.")end if LP and LP.CharacterAdded then pcall(function()local _respawnQueue=0 LP.CharacterAdded:Connect(function(char)pcall(function()_respawnQueue=_respawnQueue+1 local myId=_respawnQueue if stealConnection then stealConnection:Disconnect();stealConnection=nil end isStealing=false if stopAutoLeft then stopAutoLeft()end if stopAutoRight then stopAutoRight()end if stopBatCounter then stopBatCounter()end if stopBatCounterV2 then stopBatCounterV2()end if stopMedusaCounter then stopMedusaCounter()end if stopUnwalk then stopUnwalk()end if stopDropBrainrot then stopDropBrainrot()end if autoBatEnabled and disableAutoBat then disableAutoBat()end if bodyLockEnabled and stopBodyLock then stopBodyLock()end local deadline=_tick()+5 while(not char.Parent)or(not char:FindFirstChild("HumanoidRootPart"))or(not char:FindFirstChildOfClass("Humanoid"))do if _tick()>deadline then return end if myId~=_respawnQueue then return end task.wait(0.05)end _hookedVelParts={}local _hrpRespawn=_setupVelChecked(char)_hookVelHRP(_hrpRespawn)if not _originalAppearance then task.defer(function()captureOriginalAppearance(char)end)end if setupMovementAndIndicators then setupMovementAndIndicators(char)end if antiRagdollMode=="v1"then AntiRagdollV1.start()elseif antiRagdollMode=="v2"then startAntiRagdollV2()end if antiBatEnabled then startAntiBat()end if antiFlingEnabled then startAntiFling()end if AntiDieModule.enabled then task.defer(function()activateOnCharacter(char)end)end if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal)end if bodyLockEnabled and _blSuppressCount==0 then startBodyLock()end if medusaCounterEnabled then setupMedusaCounter(char)if setMedusaVisual then setMedusaVisual(true)end else stopMedusaCounter()if setMedusaVisual then setMedusaVisual(false)end end if batCounterEnabled then startBatCounter()end if batCounterV2Enabled then startBatCounterV2()end if unwalkEnabled then startUnwalk()end if currentAnimPack~="Off"then task.wait(0.3);startAnimPack(currentAnimPack)end updateProgressBarVisibility()refreshSpeedModeLabel()pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel and OUTFITS[currentOutfitIndex]then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end end)end)end)end local lastLaggerToggle=0 local LAGGER_COOLDOWN=0.3 UIS.InputBegan:Connect(function(input,gpe)if _anyKeyListening then return end if input.UserInputType==Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox()then return end elseif not isGamepadInput(input)then return end if not isBindableInput(input)then return end local kc=input.KeyCode if not kc then return end if kbMatch(KB.LaggerMode,kc)then if _tick()-lastLaggerToggle>=LAGGER_COOLDOWN then lastLaggerToggle=_tick()toggleLaggerCycle()end return end if kbMatch(KB.CarryToggle,kc)then toggleCarryMode();return end if kbMatch(KB.DropBrainrot,kc)then if not dropActive then if dropBrainrotSetVisual then dropBrainrotSetVisual(true)end executeDropWithToggle(dropBrainrotSetVisual)end return end if kbMatch(KB.TPFloor,kc)then doTpDown();return end if kbMatch(KB.AutoLeft,kc)then autoLeftEnabledReleased=not autoLeftEnabled if autoLeftEnabled then startAutoLeft()else stopAutoLeft()end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled)end if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled)end return end if kbMatch(KB.AutoRight,kc)then autoRightEnabled=not autoRightEnabled if autoRightEnabled then startAutoRight()else stopAutoRight()end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled)end if mobSetAutoRight then mobSetAutoRight(autoRightEnabled)end return end if kbMatch(KB.AutoBat,kc)then if not autoBatEnabled then enableAutoBat()if autoBatSetVisual then autoBatSetVisual(true)end if mobSetAutoBat then mobSetAutoBat(true)end else disableAutoBat()if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end end return end if kbMatch(KB.TPBat,kc)then toggleBatTP()return end if kbMatch(KB.BatV2,kc)then if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()then if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end if mobSetBatV2 then mobSetBatV2(false)end else if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2)end if mobSetBatV2 then mobSetBatV2(true)end end return end if kbMatch(KB.Float,kc)then if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle()end return end if kbMatch(KB.InstantReset,kc)then local resetFn=_G.__ZeyHubbRunInstantReset if type(resetFn)=="function"then pcall(resetFn)end return end if kbMatch(KB.GuiHide,kc)then if main then if main.Visible then hideGui()else showGui()end end return end end)do local introGeneration=0 local wasHoldingBrainrot=false local activeIntroGui=nil local function isHoldingBrainrot()local char=LP and LP.Character if not char then return false end if LP:GetAttribute("Stealing")==true or char:GetAttribute("Stealing")==true then return true end local function nameIsBrainrot(n)n=tostring(n or""):lower()if n==""then return false end if n:find("bat",1,true)or n:find("sword",1,true)or n:find("katana",1,true)or n:find("gun",1,true)or n:find("medusa",1,true)or n:find("slap",1,true)or n:find("weapon",1,true)or n:find("bypass",1,true)or n:find("tool",1,true)then return false end return n:find("brainrot",1,true)~=nil or n:find("animal",1,true)~=nil or n:find("stolen",1,true)~=nil end for _,entry in ipairs({"StealHold","IsCarrying","Carrying"})do local inst=char:FindFirstChild(entry,true)if inst and inst:IsA("BoolValue")and inst.Value==true then for _,child in ipairs(char:GetChildren())do if(child:IsA("Tool")or child:IsA("Model"))and nameIsBrainrot(child.Name)then return true end end end end for _,child in ipairs(char:GetChildren())do if(child:IsA("Tool")or child:IsA("Model"))and nameIsBrainrot(child.Name)then return true end end return false end local function playBrainrotIntro(myGeneration)if activeIntroGui then pcall(function()activeIntroGui:Destroy()end)end local playerGui=LP and(LP:FindFirstChildOfClass("PlayerGui")or LP:WaitForChild("PlayerGui",5))if not playerGui or myGeneration~=introGeneration or not isHoldingBrainrot()then return end local introGui=Instance.new("ScreenGui")introGui.Name="BrainrotEnterIntro"introGui.ResetOnSpawn=false introGui.IgnoreGuiInset=true introGui.DisplayOrder=1000000 introGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling introGui.Parent=playerGui activeIntroGui=introGui local strip=Instance.new("Frame")strip.Name="EnterStrip"strip.AnchorPoint=Vector2.new(0.5,0.5)strip.Position=UDim2.new(0.5,0,-0.18,0)strip.Size=UDim2.fromOffset(240,40)strip.BackgroundColor3=Color3.fromRGB(12,7,2)strip.BorderSizePixel=0 strip.ClipsDescendants=true strip.ZIndex=2 strip.Parent=introGui Instance.new("UICorner",strip).CornerRadius=UDim.new(1,0)local completeBorder=Instance.new("UIStroke",strip)completeBorder.Name="CompleteLoadingBorder"completeBorder.Color=Color3.fromRGB(255,170,50)completeBorder.Thickness=2.2 completeBorder.Transparency=0.2 completeBorder.ZIndex=6 local scale=Instance.new("UIScale",strip)scale.Scale=0.9 local lineFill=Instance.new("Frame",strip)lineFill.Name="LoadingLine"lineFill.Size=UDim2.new(0,0,1,0)lineFill.Position=UDim2.new(0,0,0,0)lineFill.BackgroundColor3=Color3.fromRGB(255,150,40)lineFill.BackgroundTransparency=0.15 lineFill.BorderSizePixel=0 lineFill.ZIndex=3 Instance.new("UICorner",lineFill).CornerRadius=UDim.new(1,0)local lfGrad=Instance.new("UIGradient",lineFill)lfGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,240,200)),ColorSequenceKeypoint.new(0.35,Color3.fromRGB(255,170,50)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(200,90,15)),})local label=Instance.new("TextLabel",strip)label.Name="EnterLabel"label.Size=UDim2.new(1,-32,1,-16)label.Position=UDim2.fromOffset(16,8)label.BackgroundTransparency=1 label.Text="DON'T ENTER"label.TextColor3=Color3.fromRGB(255,230,190)label.TextStrokeTransparency=0.4 label.TextStrokeColor3=Color3.fromRGB(20,8,0)label.Font=Enum.Font.GothamBlack label.TextScaled=true label.TextWrapped=true label.ZIndex=5 local limit=Instance.new("UITextSizeConstraint",label)limit.MinTextSize=10 limit.MaxTextSize=16 local function stillValid()return myGeneration==introGeneration and introGui.Parent~=nil and isHoldingBrainrot()end local function abortIf()if stillValid()then return false end if introGui.Parent then introGui:Destroy()end if activeIntroGui==introGui then activeIntroGui=nil end return true end local arrival=TS:Create(strip,TweenInfo.new(0.52,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.fromScale(0.5,0.12)})TS:Create(scale,TweenInfo.new(0.52,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()arrival:Play()arrival.Completed:Wait()if abortIf()then return end local revealTime=1.9 local elapsed=0 while elapsed<revealTime do lineFill.Size=UDim2.new(math.clamp(elapsed/revealTime,0,1),0,1,0)elapsed=elapsed+task.wait()if abortIf()then return end end lineFill.Size=UDim2.new(1,0,1,0)completeBorder.Transparency=0 label.Text="ENTER"label.TextTransparency=1 TS:Create(label,TweenInfo.new(0.18),{TextTransparency=0}):Play()task.wait(0.3)if abortIf()then return end TS:Create(scale,TweenInfo.new(0.38,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Scale=1.35}):Play()TS:Create(strip,TweenInfo.new(0.38),{BackgroundTransparency=1}):Play()TS:Create(lineFill,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()TS:Create(label,TweenInfo.new(0.25),{TextTransparency=1}):Play()TS:Create(completeBorder,TweenInfo.new(0.25),{Transparency=1}):Play()task.wait(0.4)if introGui.Parent then introGui:Destroy()end if activeIntroGui==introGui then activeIntroGui=nil end end task.spawn(function()while true do local holding=isHoldingBrainrot()if holding and not wasHoldingBrainrot then introGeneration=introGeneration+1 local thisGeneration=introGeneration task.spawn(function()playBrainrotIntro(thisGeneration)end)elseif not holding and wasHoldingBrainrot then introGeneration=introGeneration+1 if activeIntroGui then pcall(function()activeIntroGui:Destroy()end)activeIntroGui=nil end end wasHoldingBrainrot=holding task.wait(0.1)end end)end do local CleanKatanaPlayers=game:GetService("Players")local CleanKatanaLP=CleanKatanaPlayers.LocalPlayer local CLEAN_SLASH_SOUND="rbxassetid://111808555599832"local cleanKatanaController local function createKatanaSkinController()local katanaPlayersService=game:GetService("Players")local katanaInsertService=game:GetService("InsertService")local katanaLighting=game:GetService("Lighting")local katanaReplicatedStorage=game:GetService("ReplicatedStorage")local katanaPlayer=katanaPlayersService.LocalPlayer local katanaColors={red=Color3.new(0.784314,0,0),red2=Color3.new(1,0,0.392157),gold=Color3.new(1,0.843137,0),}local katanaState={Skin="KATANA",SkinOrder={"KATANA","NONE"},LastBat=nil,LastAppliedSkin=nil,OriginalKatanaTemplate=nil,ExactTemplates={},ExactTemplateSearched={},ExactAssetIds={KATANA=""},Original={},}local function findBat()local character=katanaPlayer.Character if character then local bat=character:FindFirstChild("Bat")if bat and bat:IsA("Tool")then return bat end end local backpack=katanaPlayer:FindFirstChildOfClass("Backpack")if backpack then local bat=backpack:FindFirstChild("Bat")if bat and bat:IsA("Tool")then return bat end end backpack=katanaPlayer:FindFirstChildOfClass("Backpack")for _,container in ipairs({katanaPlayer.Character,backpack})do if container then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and tool.Name:lower():find("bat",1,true)then return tool end end end end return nil end local function configureVisualPart(part)if not part or not part:IsA("BasePart")then return end part.Anchored=false part.CanCollide=false part.CanTouch=false part.CanQuery=false part.Massless=true end local function weldToHandle(part1,part0)if not part1 or not part0 or not part1:IsA("BasePart")or not part0:IsA("BasePart")then return end configureVisualPart(part1)local wc=Instance.new("WeldConstraint")wc.Name="FlowerSkin_AssetWeld"wc.Part0=part0 wc.Part1=part1 wc.Parent=part1 end local function cacheOriginalBatState(batTool)if not batTool then return end local handle=batTool:FindFirstChild("Handle")local slash=batTool:FindFirstChild("Slash")katanaState.Original[batTool]=katanaState.Original[batTool]or{}local o=katanaState.Original[batTool]if handle and handle:IsA("BasePart")and not o.Handle then o.Handle={Transparency=handle.Transparency,LocalTransparencyModifier=handle.LocalTransparencyModifier,CastShadow=handle.CastShadow}end if slash and slash:IsA("Sound")and not o.SlashSoundId then o.SlashSoundId=slash.SoundId end end local function captureOriginalKatanaTemplate()if katanaState.OriginalKatanaTemplate then return end local function scanContainer(container)if not container then return end local bat=container:FindFirstChild("Bat")if not bat then return end local f=bat:FindFirstChild("FlowerSkin_KatanaRealistic")f=f and f:FindFirstChild("FlowerSkin_AssetKatana")if f then katanaState.OriginalKatanaTemplate=f:Clone()end end scanContainer(katanaPlayer:FindFirstChildOfClass("Backpack"))scanContainer(katanaPlayer.Character)end local function setBatHandleHidden(batTool,hidden)local handle523=batTool and batTool:FindFirstChild("Handle")if not handle523 or not handle523:IsA("BasePart")then return end cacheOriginalBatState(batTool)if hidden then handle523.LocalTransparencyModifier=1 handle523.Transparency=1 handle523.CastShadow=false else local h=katanaState.Original[batTool]and katanaState.Original[batTool].Handle handle523.LocalTransparencyModifier=h and h.LocalTransparencyModifier or 0 handle523.Transparency=h and h.Transparency or 0 handle523.CastShadow=h and h.CastShadow if handle523.CastShadow==nil then handle523.CastShadow=true end end end local function setBatSlashSound(batTool,soundId)cacheOriginalBatState(batTool)local slash=batTool and batTool:FindFirstChild("Slash")if slash and slash:IsA("Sound")then if not soundId then soundId=katanaState.Original[batTool]and katanaState.Original[batTool].SlashSoundId or slash.SoundId end slash.SoundId=soundId end end local function restoreOriginalBatVisual(batTool)if not batTool then return end local f=batTool:FindFirstChild("FlowerSkin_KatanaRealistic")if f then f:Destroy()end local fa=batTool:FindFirstChild("FlowerSkin_AssetKatana")if fa then fa:Destroy()end setBatHandleHidden(batTool,false)setBatSlashSound(batTool,nil)end local function addKatanaRedEffects(parent)if not parent or not parent:IsA("BasePart")then return end local old=parent:FindFirstChild("FictionHubSpeedIndicator")if old then old:Destroy()end local topAtt=Instance.new("Attachment")topAtt.Name="FlowerSkin_ExtraRedVFX"topAtt.Position=Vector3.new(0,parent.Size.Y*0.5,0)topAtt.Parent=parent local botAtt=Instance.new("Attachment")botAtt.Name="FlowerSkin_ExtraRedVFX_End"botAtt.Position=Vector3.new(0,-parent.Size.Y*0.5,0)botAtt.Parent=parent local trail=Instance.new("Trail")trail.Name="FlowerSkin_ExtraRedVFX"trail.Attachment0=topAtt trail.Attachment1=botAtt trail.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,katanaColors.red2),ColorSequenceKeypoint.new(1,Color3.new(0.54902,0,0)),})trail.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.35),NumberSequenceKeypoint.new(1,1),})trail.Lifetime=0.18 trail.LightEmission=0.55 trail.Parent=parent local pe=Instance.new("ParticleEmitter")pe.Name="FlowerSkin_ExtraRedVFX"pe.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.784314,0,0)),ColorSequenceKeypoint.new(1,katanaColors.red2),})pe.LightEmission=0.55 pe.Rate=14 pe.Lifetime=NumberRange.new(0.3,0.45)pe.Speed=NumberRange.new(0.2,0.7)pe.SpreadAngle=Vector2.new(12,12)pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.08),NumberSequenceKeypoint.new(1,0),})pe.Texture="rbxasset://textures/particles/sparkles_main.dds"pe.Parent=parent end local function createKatanaPart(parent,name,size,cfOffset,color,material)local part=Instance.new("Part")part.Name=name part.Size=size part.Color=color part.Material=material or Enum.Material.Neon part.TopSurface=Enum.SurfaceType.Smooth part.BottomSurface=Enum.SurfaceType.Smooth configureVisualPart(part)part.Parent=parent return part,cfOffset or CFrame.identity end local katanaCandidateNames={KATANA={"FlowerSkin_AssetKatana","Katana","FlowerSkin_KatanaRealistic"}}local function isScriptInstance(instance)return instance:IsA("Script")or instance:IsA("LocalScript")or instance:IsA("ModuleScript")end local function removeScripts(root)if not root then return end if isScriptInstance(root)then root:Destroy();return end for _,d in ipairs(root:GetDescendants())do if isScriptInstance(d)then d:Destroy()end end end local function hasBasePart(candidate)if not candidate then return false end if candidate:IsA("BasePart")then return true end return candidate:FindFirstChildWhichIsA("BasePart",true)~=nil end local function isGeneratedSkin(candidate)local ok,result=pcall(function()return candidate:GetAttribute("CursedBatSkinsGenerated")end)return ok and result==true end local function validateSkinCandidate(candidate)if not candidate or isGeneratedSkin(candidate)then return nil end if candidate:IsA("Model")or candidate:IsA("Tool")or candidate:IsA("Accessory")or candidate:IsA("BasePart")then if hasBasePart(candidate)then return candidate end end return nil end local function findNamedSkinCandidate(root,candidateNames)if not root then return nil end for _,entry in ipairs(candidateNames)do if root.Name~=entry then continue end local c=validateSkinCandidate(root)if c then return c end end for _,cn in ipairs(candidateNames)do local inst=root:FindFirstChild(cn,true)local v=validateSkinCandidate(inst)if v then return v end end return nil end local function normalizeAssetId(assetId)local n=tostring(assetId or""):gsub("%s+","")if n==""then return nil end if n:match("^rbxassetid://")or n:match("^rbxasset://")then return n end if n:match("^%d+$")then return"rbxassetid://"..n end return n end local function loadAssetSkinTemplate(skinName)local uri=normalizeAssetId(katanaState.ExactAssetIds[skinName])if not uri then return nil end local loaded={}pcall(function()loaded=game:GetObjects(uri)end)if#loaded==0 then local m=tostring(uri):match("(%d+)")if m then pcall(function()table.insert(loaded,katanaInsertService:LoadAsset(tonumber(m)))end)end end local names=katanaCandidateNames[skinName]or{}for _,entry in ipairs(loaded)do local c=findNamedSkinCandidate(entry,names)or validateSkinCandidate(entry)if c then local clone=c:Clone()removeScripts(clone)return clone end end return nil end local function findExistingSkinTemplate(skinName)local names=katanaCandidateNames[skinName]if not names then return nil end local roots={katanaPlayer.Character,katanaPlayer:FindFirstChildOfClass("Backpack"),katanaReplicatedStorage,katanaLighting,workspace}for _,entry in ipairs(roots)do local c=findNamedSkinCandidate(entry,names)if c then local clone=c:Clone()removeScripts(clone)return clone end end return nil end local function getSkinTemplate(skinName)if skinName=="KATANA"and katanaState.OriginalKatanaTemplate then return katanaState.OriginalKatanaTemplate end if katanaState.ExactTemplates[skinName]then return katanaState.ExactTemplates[skinName]end if katanaState.ExactTemplateSearched[skinName]then return nil end katanaState.ExactTemplateSearched[skinName]=true local t=loadAssetSkinTemplate(skinName)or findExistingSkinTemplate(skinName)if t then katanaState.ExactTemplates[skinName]=t end return t end local normalizeSkinModel normalizeSkinModel=function(source,parent)if source:IsA("Model")then source.Name="FlowerSkin_AssetKatana";source.Parent=parent;return source end if source:IsA("BasePart")then local m=Instance.new("Model")m.Name="FlowerSkin_AssetKatana"m.Parent=parent source.Parent=m return m end if source:IsA("Tool")or source:IsA("Folder")then local f=source:FindFirstChild("FlowerSkin_AssetKatana")or source:FindFirstChildWhichIsA("Model")or source:FindFirstChildWhichIsA("BasePart")if f and f.Parent==source then f.Parent=nil source:Destroy()return normalizeSkinModel(f,parent)end local m=Instance.new("Model")m.Name="FlowerSkin_AssetKatana"m.Parent=parent for _,c in ipairs(source:GetChildren())do if not isScriptInstance(c)then c.Parent=m end end source:Destroy()return m end return nil end local function applyExactSkinTemplate(batTool,skinName)local handle=batTool and batTool:FindFirstChild("Handle")if not handle or not handle:IsA("BasePart")then return false end local template=getSkinTemplate(skinName)if not template then return false end local folder=Instance.new("Folder")folder.Name="FlowerSkin_KatanaRealistic"folder.Parent=batTool local skinModel=normalizeSkinModel(template:Clone(),folder)if not skinModel or not hasBasePart(skinModel)then folder:Destroy();return false end removeScripts(skinModel)pcall(function()skinModel:SetAttribute("CursedBatSkinsExactMesh",true)end)local firstPart for _,d in ipairs(skinModel:GetDescendants())do if d:IsA("BasePart")then firstPart=firstPart or d configureVisualPart(d)end end if not firstPart then folder:Destroy();return false end if skinModel:IsA("Model")then skinModel.PrimaryPart=skinModel.PrimaryPart or firstPart pcall(function()skinModel:PivotTo(handle.CFrame)end)end for _,d in ipairs(skinModel:GetDescendants())do if d:IsA("BasePart")then weldToHandle(d,handle)end end local weaponPart=skinModel:FindFirstChild("SharpParts",true)or skinModel:FindFirstChild("WeaponPart",true)or skinModel:FindFirstChild("Handle",true)or firstPart if weaponPart and not weaponPart:FindFirstChild("FlowerSkin_ExtraRedVFX")then addKatanaRedEffects(weaponPart)end return true end local function createProceduralKatana(batTool,skinName)local handle=batTool and batTool:FindFirstChild("Handle")if not handle or not handle:IsA("BasePart")then return nil end local folder=Instance.new("Folder")folder.Name="FlowerSkin_KatanaRealistic"folder.Parent=batTool local model=Instance.new("Model")model.Name="FlowerSkin_AssetKatana"model:SetAttribute("CursedBatSkinsGenerated",true)model.Parent=folder local created={}local function createPart(name,size,cfOffset,color,material)local p,off=createKatanaPart(model,name,size,cfOffset,color,material)p.CFrame=handle.CFrame*off weldToHandle(p,handle)table.insert(created,p)return p end if skinName=="KATANA"then createPart("Handle2",Vector3.new(0.22,1,0.22),CFrame.new(0,-0.48,0),Color3.new(0.176471,0.176471,0.045),Enum.Material.Metal)local sp=createPart("SharpParts",Vector3.new(0.18,2.4,0.12),CFrame.new(0,1.05,0),katanaColors.red2,Enum.Material.Neon)createPart("WeaponPart",Vector3.new(0.3,2.7,0.08),CFrame.new(0.08,1.15,0),katanaColors.red,Enum.Material.Neon)createPart("GoldAccent",Vector3.new(0.5,0.12,0.08),CFrame.new(0,-0.28,0),katanaColors.gold,Enum.Material.Neon)addKatanaRedEffects(sp)end model.PrimaryPart=created[1]return model end local slashSoundIds={KATANA="rbxassetid://111808555599832"}return{State=katanaState,ApplySkin=function(skinName)captureOriginalKatanaTemplate()local lastBat=findBat()if not lastBat then katanaState.LastBat=nil katanaState.LastAppliedSkin=nil return false end cacheOriginalBatState(lastBat)restoreOriginalBatVisual(lastBat)if skinName=="NONE"then katanaState.LastBat=lastBat katanaState.LastAppliedSkin=skinName return true end setBatHandleHidden(lastBat,true)setBatSlashSound(lastBat,slashSoundIds[skinName])if not applyExactSkinTemplate(lastBat,skinName)then createProceduralKatana(lastBat,skinName)end local handle=lastBat:FindFirstChild("Handle")if handle then local fire=handle:FindFirstChildOfClass("Fire")or handle:FindFirstChild("Fire")if fire and fire:IsA("Fire")then fire.Enabled=true fire.Color=katanaColors.red fire.SecondaryColor=katanaColors.red2 end end katanaState.LastBat=lastBat katanaState.LastAppliedSkin=skinName return true end,SetExactAssetId=function(assetId)katanaState.ExactAssetIds.KATANA=tostring(assetId or"")katanaState.ExactTemplateSearched.KATANA=nil katanaState.ExactTemplates.KATANA=nil end,}end cleanKatanaController=createKatanaSkinController()_G.CursedBatKatana=cleanKatanaController _G.CleanKatana={controller=cleanKatanaController,slashSound=CLEAN_SLASH_SOUND}task.spawn(function()while true do pcall(function()local char=CleanKatanaLP.Character local backpack=CleanKatanaLP:FindFirstChildOfClass("Backpack")local bat=nil for _,container in ipairs({char,backpack})do if container and not bat then local b=container:FindFirstChild("Bat")if b and b:IsA("Tool")then bat=b end end end if not bat then for _,container in ipairs({char,backpack})do if container and not bat then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and tool.Name:lower():find("bat",1,true)then bat=tool break end end end end end if bat then local st=cleanKatanaController.State if bat~=st.LastBat or st.LastAppliedSkin~="KATANA"then cleanKatanaController.ApplySkin("KATANA")end local slash=bat:FindFirstChild("Slash")if slash and slash:IsA("Sound")and slash.SoundId~=CLEAN_SLASH_SOUND then slash.SoundId=CLEAN_SLASH_SOUND end end end)task.wait(0.5)end end)end do local SkinPlayers=game:GetService("Players")local SkinLP=SkinPlayers.LocalPlayer local function isMedusaSkinTool(obj)if not obj or not obj:IsA("Tool")then return false end local n=obj.Name:lower()return n:find("medusa",1,true)~=nil or n:find("head",1,true)~=nil or n:find("stone",1,true)~=nil end local function removeBombSkin(tool)local f=tool:FindFirstChild("ShelMedusaBombSkin")if f then f:Destroy()end if tool:GetAttribute("ShelMedusaBombSkin")then tool:SetAttribute("ShelMedusaBombSkin",nil)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("BasePart")then obj.LocalTransparencyModifier=0 end end end end local function applyMedusaSkin(tool)if not isMedusaSkinTool(tool)then return end if(_G.RivalMedusaSkin or"Default")~="Default"then removeBombSkin(tool)return end if tool:GetAttribute("ShelMedusaBombSkin")and tool:FindFirstChild("ShelMedusaBombSkin")then return end local handle=tool:FindFirstChild("Handle")or tool:FindFirstChildWhichIsA("BasePart",true)if not handle or not handle:IsA("BasePart")then return end tool:SetAttribute("ShelMedusaBombSkin",true)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("BasePart")then obj.LocalTransparencyModifier=1 end end local bomb=Instance.new("Folder")bomb.Name="ShelMedusaBombSkin"bomb.Parent=tool local function block(name,size,color,offset,shape,material)local part=Instance.new("Part")part.Name=name part.Size=size part.Shape=shape or Enum.PartType.Block part.Color=color part.Material=material or Enum.Material.SmoothPlastic part.CFrame=handle.CFrame*offset part.CanCollide=false part.CanTouch=false part.CanQuery=false part.CastShadow=false part.Massless=true part.Anchored=false part.Parent=bomb local weld=Instance.new("WeldConstraint")weld.Part0=handle weld.Part1=part weld.Parent=part return part end local black=Color3.fromRGB(12,12,15)local darkRed=Color3.fromRGB(95,8,12)local red=Color3.fromRGB(225,25,32)local fuse=Color3.fromRGB(255,150,35)block("BombBody",Vector3.new(1.25,1.25,1.25),black,CFrame.new(0,0,0),Enum.PartType.Ball)block("BombBand",Vector3.new(1.32,0.18,1.32),darkRed,CFrame.new(0,0.02,0))block("BombCore",Vector3.new(0.72,0.72,0.72),red,CFrame.new(0,0,-0.57),Enum.PartType.Ball,Enum.Material.Neon)block("BombCap",Vector3.new(0.42,0.22,0.42),darkRed,CFrame.new(0,0.73,0))block("BombFuse",Vector3.new(0.14,0.48,0.14),fuse,CFrame.new(0,1.03,0),Enum.PartType.Cylinder,Enum.Material.Neon)block("BombSpark",Vector3.new(0.24,0.24,0.24),Color3.fromRGB(255,235,100),CFrame.new(0,1.34,0),Enum.PartType.Ball,Enum.Material.Neon)if not tool:GetAttribute("ShelMedusaDescHook")then tool:SetAttribute("ShelMedusaDescHook",true)tool.DescendantAdded:Connect(function(obj)if(_G.RivalMedusaSkin or"Default")~="Default"then return end if obj:FindFirstAncestor("ShelMedusaBombSkin")then return end if obj:IsA("BasePart")then obj.LocalTransparencyModifier=1 end end)end end local function watchSkinContainer(container)if not container then return end for _,child in ipairs(container:GetChildren())do if child:IsA("Tool")then task.defer(applyMedusaSkin,child)end end if not container:GetAttribute("ShelMedusaSkinWatch")then container:SetAttribute("ShelMedusaSkinWatch",true)container.ChildAdded:Connect(function(child)if not child:IsA("Tool")then return end task.wait()applyMedusaSkin(child)end)end end local function scanSkinTools()watchSkinContainer(SkinLP:FindFirstChildOfClass("Backpack"))watchSkinContainer(SkinLP.Character)end scanSkinTools()SkinLP.ChildAdded:Connect(function(child)if child:IsA("Backpack")then watchSkinContainer(child)end end)SkinLP.CharacterAdded:Connect(function(character)task.wait(0.5)watchSkinContainer(character)scanSkinTools()end)task.spawn(function()while task.wait(1)do scanSkinTools()end end)_G.ShelMedusaSkin={apply=scanSkinTools}end do local LPl=game:GetService("Players").LocalPlayer local ALPHA_HELD=0.85 local ALPHA_BASE=0.7 local ATTR="RHBrOrigT"local state={held=false,base=false,heldDirty=false,baseDirty=false}local BODY={Head=1,Torso=1,UpperTorso=1,LowerTorso=1,HumanoidRootPart=1,["Left Arm"]=1,["Right Arm"]=1,["Left Leg"]=1,["Right Leg"]=1,LeftUpperArm=1,LeftLowerArm=1,LeftHand=1,RightUpperArm=1,RightLowerArm=1,RightHand=1,LeftUpperLeg=1,LeftLowerLeg=1,LeftFoot=1,RightUpperLeg=1,RightLowerLeg=1,RightFoot=1,}local function isMedusaPiece(inst)local cur=inst while cur and cur~=workspace and cur~=game do if cur.Name=="RivalMedusaReplica"or cur.Name=="ShelMedusaBombSkin"or cur.Name:lower():find("medusa",1,true)then return true end if cur:IsA("Tool")then local n=cur.Name:lower()if n:find("medusa",1,true)or n:find("stone",1,true)or n:find("head",1,true)then return true end end cur=cur.Parent end return false end local function setT(inst,on,alpha)if inst:IsA("BasePart")or inst:IsA("Decal")or inst:IsA("Texture")then local o=inst:GetAttribute(ATTR)if isMedusaPiece(inst)then if o~=nil then inst.Transparency=o inst:SetAttribute(ATTR,nil)end return end if on then if o==nil then o=inst.Transparency;inst:SetAttribute(ATTR,o)end local want=math.max(o,alpha)if inst.Transparency~=want then inst.Transparency=want end elseif o~=nil then inst.Transparency=o inst:SetAttribute(ATTR,nil)end end end local function setXray(root,on)local hl=root:FindFirstChild("RHBrXray")if on then if not hl then hl=Instance.new("Highlight")hl.Name="RHBrXray"hl.Adornee=root hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.FillColor=Color3.fromRGB(255,130,20)hl.FillTransparency=1 hl.OutlineColor=Color3.fromRGB(255,215,130)hl.OutlineTransparency=1 hl.Parent=root else hl.FillTransparency=1 hl.OutlineTransparency=1 end elseif hl then hl:Destroy()end end local function applyTree(root,on,alpha)setT(root,on,alpha)for _,d in ipairs(root:GetDescendants())do setT(d,on,alpha)end setXray(root,on)end local function topOf(part,char)local top=part local m=part:FindFirstAncestorOfClass("Model")while m and m~=workspace and m~=char and not m:IsDescendantOf(char)do top=m m=m.Parent and m.Parent:FindFirstAncestorOfClass("Model")end return top end local function heldTargets(char)local list,seen={},{}local function add(o)if o and not seen[o]then seen[o]=true;list[#list+1]=o end end for _,child in ipairs(char:GetChildren())do if child:IsA("Model")then add(child)elseif child:IsA("BasePart")and not BODY[child.Name]then add(child)end end local root=char:FindFirstChild("HumanoidRootPart")if root then local ok,connected=pcall(function()return root:GetConnectedParts(true)end)if ok and connected then for _,p in ipairs(connected)do if not p:IsDescendantOf(char)then add(topOf(p,char))end end end end return list end local function myPlot()local plots=workspace:FindFirstChild("Plots")if not plots then return nil end for _,plot in ipairs(plots:GetChildren())do local sign=plot:FindFirstChild("PlotSign")local yb=sign and sign:FindFirstChild("YourBase")if yb and yb:IsA("BillboardGui")and yb.Enabled then return plot end end return nil end local lastHeld={}local function processHeld(on)local char=LPl.Character if not char then return end local targets=heldTargets(char)for _,o in ipairs(targets)do applyTree(o,on,ALPHA_HELD)lastHeld[o]=true end local current={}for _,o in ipairs(targets)do current[o]=true end for o in pairs(lastHeld)do if not current[o]then if o.Parent then applyTree(o,false,ALPHA_HELD)end lastHeld[o]=nil end end end local lastBase={}local printed={}local function baseTargets()local list,seen={},{}local function add(o)if o and not seen[o]then seen[o]=true;list[#list+1]=o end end local plot=myPlot()local pods=plot and plot:FindFirstChild("AnimalPodiums")if not pods then return list end local function isContainer(inst)return inst==workspace or inst==plot or inst==pods or inst.Parent==pods or inst:IsA("Folder")end for _,pod in ipairs(pods:GetChildren())do local podBase=pod:FindFirstChild("Base")for _,c in ipairs(pod:GetChildren())do if c~=podBase and c:IsA("Model")and not c:FindFirstChildOfClass("Humanoid")then add(c)end end local spawnPart=podBase and podBase:FindFirstChild("Spawn")if spawnPart and spawnPart:IsA("BasePart")then local ok,parts=pcall(function()return workspace:GetPartBoundsInRadius(spawnPart.Position+Vector3.new(0,3,0),6)end)if ok and parts then for _,part in ipairs(parts)do if not part:IsDescendantOf(LPl.Character or workspace)or not LPl.Character then local top=nil local cur=part.Parent while cur and not isContainer(cur)do if cur:IsA("Model")then top=cur end cur=cur.Parent end if top and top~=pod and top~=podBase and not top:IsAncestorOf(podBase)and not top:FindFirstChild("Spawn",true)and not top:FindFirstChildOfClass("Humanoid")and not top:IsDescendantOf(podBase)and not(LPl.Character and top:IsDescendantOf(LPl.Character))then add(top)end end end end end end return list end local function processBase(on)local targets=baseTargets()local current={}for _,o in ipairs(targets)do current[o]=true applyTree(o,on,ALPHA_BASE)lastBase[o]=true if on and not printed[o]then printed[o]=true pcall(function()print("[ZeyHubb.vs] Brainrot base transparente:",o:GetFullName())end)end end for o in pairs(lastBase)do if not current[o]then if o.Parent then applyTree(o,false,ALPHA_BASE)end lastBase[o]=nil end end end _G.RHBrainrotTransparency={SetHeld=function(v)state.held=v and true or false;state.heldDirty=true end,SetBase=function(v)state.base=v and true or false;state.baseDirty=true end,}task.spawn(function()while true do pcall(function()if state.held or state.heldDirty then processHeld(state.held);state.heldDirty=false end end)task.wait(0.1)end end)task.spawn(function()while true do pcall(function()if state.base or state.baseDirty then processBase(state.base);state.baseDirty=false end end)task.wait(0.4)end end)end

-- ZeyHubb Bat Bypass V2 engine (from Nezux), appended
do
  local Players = game:GetService("Players")
  local RunService = game:GetService("RunService")
  local LP = Players.LocalPlayer
  _G.SnowVS = _G.SnowVS or {}
  local SnowVS = _G.SnowVS
  SnowVS.BatBypass = SnowVS.BatBypass or {}
  local BB = SnowVS.BatBypass
  BB.Enabled = false
  BB.Connection = nil
  BB.Z = {
    targetPlayer = nil,
    lastTargetPos = nil,
    targetVelocity = Vector3.zero,
    smoothedVelocity = Vector3.zero,
    velocityHistory = {},
    accelerationHistory = {},
    aerialVelocityHistory = {},
    previousDirection = nil,
    lastDirectionChangeTime = 0,
    airborneTime = 0,
    lastActivationTime = 0,
    currentPing = 0.1,
  }
  BB.ZCFG = {
    FOLLOW_SPEED = 55,
    ACTIVATE_DISTANCE = 13,
    MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.22,
    PREDICT_AHEAD = 3,
    MAX_HORIZONTAL_VELOCITY = 80,
    SERVER_TICKRATE = 1/60,
    MIN_PING_COMPENSATION = 0.03,
    MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
    VELOCITY_SMOOTHING = 0.2,
  }
  local function avg(history)
    if #history == 0 then return Vector3.zero end
    local total = Vector3.zero
    for i = 1, #history do total = total + history[i] end
    return total / #history
  end
  local function push(history, value, maximum)
    history[#history + 1] = value
    if #history > maximum then table.remove(history, 1) end
  end
  local function findBat()
    local char = LP.Character
    if not char then return nil end
    local eq = char:FindFirstChildOfClass("Tool")
    if eq then
      local n = string.lower(eq.Name)
      if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return eq end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
      for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
          local n = string.lower(tool.Name)
          if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return tool end
        end
      end
    end
    return nil
  end
  local function resetTarget()
    local Z = BB.Z
    Z.targetPlayer = nil
    Z.lastTargetPos = nil
    Z.targetVelocity = Vector3.zero
    Z.smoothedVelocity = Vector3.zero
    Z.velocityHistory = {}
    Z.accelerationHistory = {}
    Z.aerialVelocityHistory = {}
    Z.previousDirection = nil
    Z.airborneTime = 0
  end
  local function nearestTarget(root)
    local nearest, best = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LP and plr.Character then
        local tr = plr.Character:FindFirstChild("HumanoidRootPart")
        local th = plr.Character:FindFirstChildOfClass("Humanoid")
        if tr and th and th.Health > 0 then
          local d = (tr.Position - root.Position).Magnitude
          if d < best then nearest = plr best = d end
        end
      end
    end
    return nearest
  end
  local function rotateRoot(root, direction)
    if direction.Magnitude < 0.05 then return end
    local flat = Vector3.new(direction.X, 0, direction.Z)
    if flat.Magnitude < 0.05 then return end
    root.CFrame = CFrame.new(root.Position, root.Position + flat)
  end
  task.spawn(function()
    while true do
      pcall(function()
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        if type(ping) == "number" then
          local sec = ping / 1000
          if sec < BB.ZCFG.MIN_PING_COMPENSATION then sec = BB.ZCFG.MIN_PING_COMPENSATION end
          if sec > BB.ZCFG.MAX_PING_COMPENSATION then sec = BB.ZCFG.MAX_PING_COMPENSATION end
          BB.Z.currentPing = sec
        end
      end)
      task.wait(0.5)
    end
  end)
  BB.Stop = function()
    BB.Enabled = false
    if BB.Connection then BB.Connection:Disconnect() BB.Connection = nil end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum then hum.AutoRotate = true end
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    resetTarget()
    BB.Z.lastActivationTime = 0
  end
  BB.Start = function()
    if BB.Connection then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    BB.Enabled = true
    hum.AutoRotate = false
    local bat = findBat()
    if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
    BB.Connection = RunService.RenderStepped:Connect(function(dt)
      if not BB.Enabled then BB.Stop() return end
      local Z = BB.Z
      local ZCFG = BB.ZCFG
      if State and State.bypassBatSpeed then
        local spd = tonumber(State.bypassBatSpeed)
        if spd then ZCFG.FOLLOW_SPEED = spd end
      end
      local cchar = LP.Character
      local croot = cchar and cchar:FindFirstChild("HumanoidRootPart")
      local chum = cchar and cchar:FindFirstChildOfClass("Humanoid")
      if not croot or not chum or chum.Health <= 0 then return end
      chum.AutoRotate = false
      root = croot
      hum = chum
      bat = cchar:FindFirstChildOfClass("Tool") or findBat()
      if bat and bat.Parent ~= cchar then pcall(function() chum:EquipTool(bat) end) end
      Z.targetPlayer = nearestTarget(root)
      local tchar = Z.targetPlayer and Z.targetPlayer.Character
      local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")
      local thum = tchar and tchar:FindFirstChildOfClass("Humanoid")
      if not troot or not thum or thum.Health <= 0 then resetTarget() return end
      local targetPos = troot.Position
      local safeDt = math.max(dt, 1/240)
      if Z.lastTargetPos then
        local raw = (targetPos - Z.lastTargetPos) / safeDt
        local horiz = Vector3.new(raw.X, 0, raw.Z)
        if horiz.Magnitude > ZCFG.MAX_HORIZONTAL_VELOCITY then
          horiz = horiz.Unit * ZCFG.MAX_HORIZONTAL_VELOCITY
          raw = Vector3.new(horiz.X, raw.Y, horiz.Z)
        end
        push(Z.velocityHistory, raw, 6)
        push(Z.accelerationHistory, (raw - Z.targetVelocity) / safeDt, 4)
        Z.targetVelocity = raw
        Z.smoothedVelocity = Z.smoothedVelocity:Lerp(raw, ZCFG.VELOCITY_SMOOTHING)
      end
      Z.lastTargetPos = targetPos
      local airborne = thum.FloorMaterial == Enum.Material.Air
      if airborne then
        Z.airborneTime = Z.airborneTime + safeDt
        push(Z.aerialVelocityHistory, Z.smoothedVelocity, 4)
      else
        Z.airborneTime = 0
      end
      local predVel = Z.smoothedVelocity
      if airborne and Z.airborneTime >= ZCFG.MIN_AIRBORNE_TIME then
        local aerial = avg(Z.aerialVelocityHistory)
        predVel = Vector3.new(aerial.X, Z.targetVelocity.Y, aerial.Z) * ZCFG.AIR_CONTROL_FACTOR
      end
      local quickTurn = false
      local hvel = Vector3.new(Z.targetVelocity.X, 0, Z.targetVelocity.Z)
      if hvel.Magnitude > 5 then
        local dir = hvel.Unit
        if Z.previousDirection and Z.previousDirection:Dot(dir) < 0.5 then
          quickTurn = (tick() - Z.lastDirectionChangeTime) < ZCFG.DIRECTION_CHANGE_DETECTION_TIME
          Z.lastDirectionChangeTime = tick()
        end
        Z.previousDirection = dir
      end
      local serverDelay = Z.currentPing + ZCFG.SERVER_TICKRATE
      if quickTurn then serverDelay = serverDelay * ZCFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end
      local predicted = targetPos + predVel * serverDelay
      local accel = avg(Z.accelerationHistory)
      predicted = predicted + accel * ZCFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)
      local ptime = ZCFG.PREDICTION_TIME * 1.1
      if airborne then
        predicted = predicted + predVel * ptime
        predicted = predicted + Vector3.new(0, -0.5 * ZCFG.GRAVITY * ptime * ptime, 0)
      else
        predicted = predicted + predVel * ptime
      end
      local flatPred = Vector3.new(predVel.X, 0, predVel.Z)
      if flatPred.Magnitude > 1 then
        predicted = predicted + flatPred.Unit * ZCFG.PREDICT_AHEAD
      end
      local toTarget = predicted - root.Position
      rotateRoot(root, toTarget)
      if (targetPos - root.Position).Magnitude <= ZCFG.ACTIVATE_DISTANCE and (tick() - Z.lastActivationTime) >= 0.3 then
        if bat then pcall(function() bat:Activate() end) end
        Z.lastActivationTime = tick()
      end
      if toTarget.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
        root.AssemblyLinearVelocity = toTarget.Unit * ZCFG.FOLLOW_SPEED
      else
        root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
      end
    end)
  end
  _G.__ZeyHubbStartBypassBatV2 = function()
    local spd = 60
    if State and State.bypassBatSpeed then
      spd = tonumber(State.bypassBatSpeed) or spd
    elseif BYPASS_AIMBOT_SPEED then
      spd = tonumber(BYPASS_AIMBOT_SPEED) or spd
    end
    BB.ZCFG.FOLLOW_SPEED = spd
    BB.Start()
  end
  _G.__ZeyHubbStopBypassBatV2 = function()
    BB.Stop()
  end
end


-- ===== Bypass Bat V3 = exact JolyDuels BatBypass engine =====
    BAT_V2_SPEED = BAT_V2_SPEED or 55
    BAT_V2_HIT_DIST = BAT_V2_HIT_DIST or 13
    BAT_V2_LEAD_STUDS = BAT_V2_LEAD_STUDS or 3
    BAT_V2_BODY_LOCK_RANGE = BAT_V2_BODY_LOCK_RANGE or 60
    snowVS = _G.SnowVS or {}
    _G.SnowVS = snowVS
    snowVS.BatBypassJoly = snowVS.BatBypassJoly or {}
    -- AimbotBypassV2 kept on Nezux engine
    do
        local batBypass = snowVS.BatBypassJoly
        batBypass.Enabled = batBypass.Enabled or false
        batBypass.Connection = batBypass.Connection or nil
        batBypass.Z = batBypass.Z
            or {
                targetPlayer = nil,
                lastTargetPos = nil,
                targetVelocity = Vector3.zero,
                smoothedVelocity = Vector3.zero,
                velocityHistory = {},
                accelerationHistory = {},
                aerialVelocityHistory = {},
                previousDirection = nil,
                lastDirectionChangeTime = 0,
                airborneTime = 0,
                lastActivationTime = 0,
                currentPing = 0.1,
                realPingMs = 0,
            }
        batBypass.ZCFG = batBypass.ZCFG
            or {
                FOLLOW_SPEED = BAT_V2_SPEED,
                ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
                MIN_FOLLOW_DISTANCE = 1,
                PREDICTION_TIME = 0.22,
                PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
                MAX_VELOCITY_CHANGE = 150,
                VELOCITY_SMOOTHING = 0.2,
                MAX_HORIZONTAL_VELOCITY = 80,
                SERVER_TICKRATE = 0.016666666666666666,
                MIN_PING_COMPENSATION = 0.03,
                MAX_PING_COMPENSATION = 0.25,
                ACCELERATION_PREDICTION_WEIGHT = 0.3,
                DIRECTION_CHANGE_DETECTION_TIME = 0.12,
                QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
                GRAVITY = 196.2,
                AIR_CONTROL_FACTOR = 0.8,
                MIN_AIRBORNE_TIME = 0.08,
            }
        local function averageVectors(vectors)
            if #vectors == 0 then
                return Vector3.zero
            end
            local sum = Vector3.zero
            for _, entry in ipairs(vectors) do
                sum = sum + (entry)
            end
            return sum / #vectors
        end
        local function pushBounded(history, entry, maxEntries)
            table.insert(history, entry)
            if #history > maxEntries then
                table.remove(history, 1)
            end
        end
        batBypass.FindBat = function()
            local character = LP.Character
            if not character then
                return nil
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local lowercaseText = tool.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                    return tool
                end
            end
            local backpack = LP:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowercaseText = child.Name:lower()
                        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                            return child
                        end
                    end
                end
            end
            return nil
        end
        local function resetPredictionState()
            local z = batBypass.Z
            z.targetPlayer = nil
            z.lastTargetPos = nil
            z.targetVelocity = Vector3.zero
            z.smoothedVelocity = Vector3.zero
            z.velocityHistory = {}
            z.accelerationHistory = {}
            z.aerialVelocityHistory = {}
            z.previousDirection = nil
            z.airborneTime = 0
        end
        local function findClosestPlayer(rootPart)
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < closestDistance then
                            closestDistance = magnitude
                            closestPlayer = player
                        end
                    end
                end
            end
            return closestPlayer
        end
        local function applyAngularAim(rootPart, direction)
            if direction.Magnitude < 0.01 then
                return
            end
            local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
            local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
            rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
                or Vector3.zero
        end
        local function updatePing()
            local ok, result = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            local z = batBypass.Z
            if ok and type(result) == "number" then
                z.realPingMs = math.floor(result)
            end
            z.currentPing = math.clamp(
                z.realPingMs / 1000,
                batBypass.ZCFG.MIN_PING_COMPENSATION,
                batBypass.ZCFG.MAX_PING_COMPENSATION
            )
        end
        batBypass.PingLoopStarted = batBypass.PingLoopStarted or false
        if not batBypass.PingLoopStarted then
            batBypass.PingLoopStarted = true
            task.spawn(function()
                while true do
                    pcall(updatePing)
                    task.wait(0.5)
                end
            end)
        end
        batBypass.StartBodyLock = function() end
        batBypass.StopBodyLock = function() end
        batBypass.Stop = function()
            local z = batBypass.Z
            batBypass.Enabled = false
            if batBypass.Connection then
                batBypass.Connection:Disconnect()
                batBypass.Connection = nil
            end
            local character = LP.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            character = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.AutoRotate = true
            end
            if character then
                character.AssemblyAngularVelocity = Vector3.zero
            end
            resetPredictionState()
            z.lastActivationTime = 0
        end
        batBypass.Start = function()
            if batBypass.Connection then
                return
            end
            local character = LP.Character
            local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid1387 or not rootPart then
                return
            end
            batBypass.Enabled = true
            humanoid1387.AutoRotate = false
            local tool = batBypass.FindBat()
            if tool and tool.Parent ~= character then
                pcall(function()
                    humanoid1387:EquipTool(tool)
                end)
            end
            batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
                if not batBypass.Enabled then
                    batBypass.Stop()
                    return
                end
                local z = batBypass.Z
                local zcfg = batBypass.ZCFG
                if _G.AceGetAntiBypassAimbotSpeed then
                    zcfg.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
                end
                local character2 = LP.Character
                local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
                    return
                end
                humanoid.AutoRotate = false
                rootPart = rootPart1394
                humanoid1387 = humanoid
                tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
                if tool and tool.Parent ~= character2 then
                    pcall(humanoid.EquipTool, humanoid, tool)
                end
                z.targetPlayer = findClosestPlayer(rootPart)
                local character3 = z.targetPlayer and z.targetPlayer.Character
                local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
                character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
                if not rootPart1442 or not character3 or character3.Health <= 0 then
                    resetPredictionState()
                    return
                end
                local position = rootPart1442.Position
                local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local vector = targetVelocity - z.targetVelocity
                    if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                        targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                    end
                    local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                        local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
                    end
                    pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    pushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local isAirborne = character3.FloorMaterial == Enum.Material.Air
                z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
                if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                    pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not isAirborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if isAirborne and #z.aerialVelocityHistory > 0 then
                    local vector = averageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
                end
                local changedDirectionQuickly = false
                local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if vector3.Magnitude > 5 then
                    local unit = vector3.Unit
                    if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                        local lastDirectionChangeTime = z.lastDirectionChangeTime
                        changedDirectionQuickly = tick() - lastDirectionChangeTime
                            < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = tick()
                    end
                    z.previousDirection = unit
                end
                local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
                if changedDirectionQuickly then
                    predictionTime = predictionTime * (zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER)
                end
                local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + averageVectors(z.accelerationHistory)
                        * accelerationPredictionWeight
                        * predictionTime
                        * predictionTime
                        * 0.5
                local leadTime = zcfg.PREDICTION_TIME * 1.1
                local leadPosition
                if isAirborne then
                    leadPosition = predictedPosition
                        + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if vector4.Magnitude > 1 then
                    leadPosition = leadPosition + (vector4.Unit * zcfg.PREDICT_AHEAD)
                end
                local targetDirection = leadPosition - rootPart.Position
                applyAngularAim(rootPart, targetDirection)
                local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
                if withinActivationRange then
                    local lastActivationTime = z.lastActivationTime
                    withinActivationRange = tick() - lastActivationTime >= 0.3
                end
                if withinActivationRange then
                    if tool then
                        pcall(tool.Activate, tool)
                    end
                    z.lastActivationTime = tick()
                end
                if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end
        batBypass.Toggle = function()
            if batBypass.Enabled then
                batBypass.Stop()
            else
                batBypass.Start()
            end
        end
    end
_G.__ZeyHubbStartBypassBatV3 = function()
    local BB = _G.SnowVS and _G.SnowVS.BatBypassJoly
    if not BB then return end
    local spd = 60
    if State and State.bypassBatSpeed then spd = tonumber(State.bypassBatSpeed) or spd
    elseif BYPASS_AIMBOT_SPEED then spd = tonumber(BYPASS_AIMBOT_SPEED) or spd end
    if BB.ZCFG then BB.ZCFG.FOLLOW_SPEED = spd end
    if BB.Start then BB.Start() end
end
_G.__ZeyHubbStopBypassBatV3 = function()
    local BB = _G.SnowVS and _G.SnowVS.BatBypassJoly
    if BB and BB.Stop then BB.Stop() end
end
-- ===== end JolyDuels BatBypass V3 =====
