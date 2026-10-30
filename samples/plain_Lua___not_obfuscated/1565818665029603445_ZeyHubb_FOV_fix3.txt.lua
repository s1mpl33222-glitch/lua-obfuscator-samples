local _savedAntiCrasherPreference=_G.__ZeyHubbAntiCrasherEnabled==true if type(_G.__ZeyHubbStopAntiCrasherRuntime)=="function"then pcall(_G.__ZeyHubbStopAntiCrasherRuntime,true)end _G.__ZeyHubbAntiCrasherEnabled=_savedAntiCrasherPreference if _G.RivalHubRunning then warn("[ZeyHubb.vs] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")end _G.RivalHubRunning=false _G.__RivalHubMainOriginalPos=nil local Players=game:GetService("Players")local RunService=game:GetService("RunService")local UIS=game:GetService("UserInputService")local TS=game:GetService("TweenService")local Lighting=game:GetService("Lighting")local HS=game:GetService("HttpService")local ReplicatedStorage=game:GetService("ReplicatedStorage")local Workspace=game:GetService("Workspace")local LP=Players.LocalPlayer if not LP then local _lpConn _lpConn=Players.PlayerAdded:Connect(function(p)LP=p end)local _t0=tick()while not LP and tick()-_t0<15 do task.wait(0.1)end if _lpConn then _lpConn:Disconnect()end end if not LP then warn("[ZeyHubb.vs] LocalPlayer no disponible en 15s. Abortando.")return end local pgui=LP:WaitForChild("PlayerGui",20)if not pgui then warn("[ZeyHubb.vs] PlayerGui no cargó en 20s. Abortando.")return end local camera=Workspace.CurrentCamera _G.RivalHubRunning=true _G.RivalHubSession=(_G.RivalHubSession or 0)+1 local _mySession=_G.RivalHubSession local RIVALHUB_LANGUAGE="en"local RIVALHUB_TRANSLATIONS={es={["RESET ALL SETTINGS"]="RESTABLECER TODO",["SETTINGS RESET"]="AJUSTES RESTABLECIDOS",["CONFIRM?"]="¿CONFIRMAR?",["ERROR"]="ERROR",["RESET"]="RESTABLECER",["Keybinds"]="TECLAS",["Carry Mode"]="MODO CARGAR",["Lagger Mode"]="MODO LAG",["Auto Left"]="AUTO IZQUIERDA",["Auto Right"]="AUTO DERECHA",["Auto Bat"]="AUTO BATE",["TP Down"]="TP ABAJO",["Drop Brainrot"]="SOLTAR BRAINROT",["Hide GUI"]="OCULTAR MENÚ",["Normal Speed"]="VELOCIDAD NORMAL",["Carry Speed"]="VELOCIDAD CARGAR",["Current Mode"]="MODO ACTUAL",["ACTIVATE"]="ACTIVAR"},pt={["RESET ALL SETTINGS"]="REDEFINIR TUDO",["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS",["CONFIRM?"]="CONFIRMAR?",["ERROR"]="ERRO",["RESET"]="REDEFINIR",["Keybinds"]="TECLAS",["Carry Mode"]="MODO CARREGAR",["Auto Left"]="AUTO ESQUERDA",["Auto Right"]="AUTO DIREITA",["Hide GUI"]="OCULTAR MENU",["Normal Speed"]="VELOCIDADE NORMAL",["Carry Speed"]="VELOCIDADE CARREGAR",["ACTIVATE"]="ATIVAR"},fr={["RESET ALL SETTINGS"]="RÉINITIALISER",["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS",["CONFIRM?"]="CONFIRMER ?",["ERROR"]="ERREUR",["RESET"]="RÉINITIALISER",["Keybinds"]="RACCOURCIS",["Carry Mode"]="MODE PORTER",["Auto Left"]="AUTO GAUCHE",["Auto Right"]="AUTO DROITE",["Hide GUI"]="MASQUER LE MENU",["Normal Speed"]="VITESSE NORMALE",["Carry Speed"]="VITESSE PORTER",["ACTIVATE"]="ACTIVER"},de={["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN",["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT",["CONFIRM?"]="BESTÄTIGEN?",["ERROR"]="FEHLER",["RESET"]="ZURÜCKSETZEN",["Keybinds"]="TASTEN",["Carry Mode"]="TRAGEMODUS",["Auto Left"]="AUTO LINKS",["Auto Right"]="AUTO RECHTS",["Hide GUI"]="MENÜ AUSBLENDEN",["Normal Speed"]="NORMALE GESCHWINDIGKEIT",["Carry Speed"]="TRAGEGESCHWINDIGKEIT",["ACTIVATE"]="AKTIVIEREN"},}local function localizeRivalHubInterface(root)local dictionary=RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]if not dictionary or not root then return end for _,object in ipairs(root:GetDescendants())do if object:IsA("TextLabel")or object:IsA("TextButton")then local source=object:GetAttribute("RivalHubSourceText")or object.Text object:SetAttribute("RivalHubSourceText",source)local translated=dictionary[source]if translated then object.Text=translated end end end end local function rivalHubTranslate(source)local dictionary=RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]return(dictionary and dictionary[source])or source end local _tick=tick local _clamp=math.clamp local _floor=math.floor local _abs=math.abs local _huge=math.huge local _sqrt=math.sqrt local _V3new=Vector3.new local _V3zero=Vector3.zero local _CFnew=CFrame.new local _CFlookAt=CFrame.lookAt local _RayParams_new=RaycastParams.new local _GetPlayersCached do local cache,cacheTime=nil,0 _GetPlayersCached=function()local now=_tick()if cache and now-cacheTime<0.03 then return cache end cache=Players:GetPlayers()cacheTime=now return cache end end local function waitForCharReady(char,timeout)timeout=timeout or 5 local deadline=_tick()+timeout while(not char)or(not char.Parent)or(not char:FindFirstChild("HumanoidRootPart"))or(not char:FindFirstChildOfClass("Humanoid"))do if _tick()>deadline then return false end task.wait(0.05)end return true end NS=60 CS=29 LAGGER_SPEED=15 LAGGER_CARRY_SPEED=24.5 MEDUSA_COOLDOWN=25 BAT_AIMBOT_SPEED=58 BYPASS_AIMBOT_SPEED=60 local State={bypassBatEnabled=false,bypassBatSpeed=BYPASS_AIMBOT_SPEED,}_G.__ZeyHubbBypassBatVersion=_G.__ZeyHubbBypassBatVersion or"v1"_G.__ZeyHubbIntroSongVersion="off"CONFIG_FILE="RivalHub_"..tostring(LP.UserId)..".json"BAT_V2_HIT_DIST=4.5 _isDraggingButton=false backgroundIndex=1 backgroundImages={}backgroundImageTransparency=0 backgroundMode="None"backgroundSelectorLabel=nil miniBackgroundImage=nil floatingButtonScale=1 floatingButtonStyle="V9" floatingButtonShape="V1" stealBarScale=1 _floatingUIScales={}TPBatState=TPBatState or{enabled=false,connection=nil,hitCooldown=false,antiDieConnections={},lockedTarget=nil,version="v1",}TPBatState.enabled=false TPBatState.version=TPBatState.version or"v1";_G.__ZeyHubbTPBatVersion=_G.__ZeyHubbTPBatVersion or"v1" _bgAssetCache=_bgAssetCache or{}_bgAssetPending=_bgAssetPending or{}_bgAssetOk=_bgAssetOk or{}function _bgLoads(url)local good=false local img=Instance.new("ImageLabel")img.Image=url pcall(function()game:GetService("ContentProvider"):PreloadAsync({img},function(_,status)if status==Enum.AssetFetchStatus.Success then good=true end end)end)local t=0 while not img.IsLoaded and t<8 do task.wait(0.1);t=t+0.1 end local loaded=img.IsLoaded pcall(function()img:Destroy()end)return good and loaded end function _bgHttpGet(url)local ok,res=pcall(function()return game:HttpGet(url)end)if ok and type(res)=="string"and#res>0 then return res end local req=(syn and syn.request)or(http and http.request)or http_request or request if req then local ok2,r=pcall(req,{Url=url,Method="GET"})if ok2 and r and(r.Success or r.StatusCode==200)and type(r.Body)=="string"and#r.Body>0 then return r.Body end end return nil end function _bgDownloadThumb(id)local getAsset=getcustomasset or getsynasset if not(writefile and getAsset)then return nil end local HttpService=game:GetService("HttpService")local imageUrl for attempt=1,4 do local body=_bgHttpGet("https://thumbnails.roblox.com/v1/assets?assetIds="..id.."&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false")if body then local okJ,data=pcall(function()return HttpService:JSONDecode(body)end)local item=okJ and data and data.data and data.data[1]if item and item.imageUrl and item.imageUrl~=""and item.state=="Completed"then imageUrl=item.imageUrl break end end task.wait(1)end if not imageUrl then return nil end local bytes=_bgHttpGet(imageUrl)if not bytes or#bytes<100 then return nil end local path="RivalHub_bg_"..id..".png"local okW=pcall(writefile,path,bytes)if not okW then return nil end local okA,asset=pcall(getAsset,path)if okA and asset and asset~=""then return asset end return nil end function _bgAsset(id)if id==nil then return""end id=tostring(id)local raw="rbxassetid://"..id local cached=_bgAssetCache[id]if cached then return cached end if not _bgAssetPending[id]then _bgAssetPending[id]=true task.spawn(function()local candidates={}local ok,objs=pcall(function()return game:GetObjects(raw)end)if ok and type(objs)=="table"and objs[1]then local item=objs[1]local found local function pick(o)if o:IsA("Decal")or o:IsA("Texture")then return o.Texture end if o:IsA("ImageLabel")or o:IsA("ImageButton")then return o.Image end return nil end found=pick(item)if not found or found==""then for _,d in ipairs(item:GetDescendants())do local t=pick(d)if t and t~=""then found=t;break end end end if found and found~=""then table.insert(candidates,found)end for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end end if#candidates==0 then pcall(function()local body=game:HttpGet("https://assetdelivery.roblox.com/v2/assetId/"..id)local data=game:GetService("HttpService"):JSONDecode(body)local loc=data and data.locations and data.locations[1]and data.locations[1].location if data and data.assetTypeId==13 and loc then local xml=game:HttpGet(loc)local texId=xml:match("rbxassetid://(%d+)")or xml:match("asset/%?id=(%d+)")or xml:match("id=(%d+)")if texId then table.insert(candidates,"rbxassetid://"..texId)end end end)end table.insert(candidates,raw)table.insert(candidates,"rbxthumb://type=Asset&id="..id.."&w=420&h=420")table.insert(candidates,"http://www.roblox.com/asset/?id="..id)local resolved,loadedOk=raw,false for attempt=1,2 do for _,c in ipairs(candidates)do if _bgLoads(c)then resolved=c;loadedOk=true;break end end if loadedOk then break end task.wait(1)end if not loadedOk then local okD,custom=pcall(_bgDownloadThumb,id)if okD and custom then resolved=custom;loadedOk=true end end if not loadedOk then warn("[ZeyHubb.vs] La imagen de fondo "..id.." no carga (privada, sin aprobar o no es una imagen).")end _bgAssetCache[id]=resolved _bgAssetOk[id]=loadedOk _bgAssetPending[id]=nil if applyBackgroundMode then pcall(applyBackgroundMode,backgroundMode)end end)end return raw end function applyBackgroundMode(mode)backgroundMode="Logo" do local bgImage=main and main:FindFirstChild("BackgroundImage") if bgImage then bgImage.Image="" bgImage.ImageTransparency=1 bgImage.Visible=false end if main then main.BackgroundColor3=Color3.fromRGB(2,8,18) main.BackgroundTransparency=0 end local img=(type(ZEY_LOGO_ASSET)=="string" and ZEY_LOGO_ASSET~="" and ZEY_LOGO_ASSET) or (type(_zeyLogoResolved)=="string" and _zeyLogoResolved) or "" if headerLogo and headerLogo.Parent and img~="" then headerLogo.Image=img end return end if mode=="None"or#backgroundImages==0 then backgroundMode="None"else local n=tonumber(string.match(tostring(mode),"^Background%s+(%d+)$"))if not n or n<1 or n>#backgroundImages then n=backgroundIndex end backgroundIndex=_clamp(n,1,#backgroundImages)backgroundMode="Background "..backgroundIndex end if main then main.BackgroundColor3=Color3.fromRGB(0,0,0)local _curBgId=tostring(backgroundImages[backgroundIndex])main.BackgroundTransparency=(backgroundMode=="None")and 0 or 1 local bgImage=main:FindFirstChild("BackgroundImage")if bgImage then bgImage.Image=_bgAsset(backgroundImages[backgroundIndex])bgImage.ImageTransparency=backgroundMode=="None"and 1 or backgroundImageTransparency end end if miniBackgroundImage then miniBackgroundImage.Image=_bgAsset(backgroundImages[backgroundIndex])miniBackgroundImage.ImageTransparency=backgroundMode=="None"and 1 or math.clamp(backgroundImageTransparency+0.25,0,1)end if backgroundSelectorLabel then backgroundSelectorLabel.Text=backgroundMode end end task.spawn(function()for i=1,#backgroundImages do pcall(_bgAsset,backgroundImages[i])end end)local COLOR_THEMES={["Blue"]=Color3.fromRGB(40,180,255),["Cyan"]=Color3.fromRGB(0,220,255),["Sky"]=Color3.fromRGB(100,210,255),["White"]=Color3.fromRGB(245,245,250),["Gray"]=Color3.fromRGB(170,170,170),}RIVAL_TITLE_THEMES={["Blue"]={color=Color3.fromRGB(40,190,255),stroke=nil},["White"]={color=Color3.fromRGB(255,255,255),stroke=nil},["Black"]={color=Color3.fromRGB(0,0,0),stroke=Color3.fromRGB(255,255,255)},["Silver"]={color=Color3.fromRGB(192,197,206),stroke=nil},}currentRivalTitleTheme="Blue"scriptLogoRef=nil rivalTitleSelectorLabel=nil function applyRivalTitleTheme(themeName,noSave)local t=RIVAL_TITLE_THEMES[themeName]if not t then return end currentRivalTitleTheme=themeName if scriptLogoRef and scriptLogoRef.Parent then scriptLogoRef.TextColor3=t.color or Color3.fromRGB(150,235,255)local glow=scriptLogoRef:FindFirstChild("TitleGlow")if glow and glow:IsA("UIStroke")then glow.Color=t.stroke or Color3.fromRGB(50,190,255)end if t.stroke then scriptLogoRef.TextStrokeColor3=t.stroke scriptLogoRef.TextStrokeTransparency=0.5 else scriptLogoRef.TextStrokeTransparency=1 end local shine=scriptLogoRef:FindFirstChild("TitleShine")if not shine then shine=Instance.new("UIGradient",scriptLogoRef)shine.Name="TitleShine"shine.Rotation=0 end local base=t.color or Color3.fromRGB(70,210,255)shine.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(245,255,255)),ColorSequenceKeypoint.new(0.30,base:Lerp(Color3.new(1,1,1),0.35)),ColorSequenceKeypoint.new(0.55,base),ColorSequenceKeypoint.new(0.80,base:Lerp(Color3.new(1,1,1),0.2)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(200,245,255)),})end if rivalTitleSelectorLabel then rivalTitleSelectorLabel.Text=themeName end if not noSave and saveAllSettings then pcall(saveAllSettings)end end currentColorTheme="Blue"selectedColor=COLOR_THEMES["Blue"]function getThemeColor()return selectedColor end ESP_BLUE=Color3.fromRGB(30,160,255)function rivalHubGradient(c)return ColorSequence.new({ColorSequenceKeypoint.new(0.00,c:Lerp(Color3.new(1,1,1),0.55)),ColorSequenceKeypoint.new(0.45,c),ColorSequenceKeypoint.new(1.00,c:Lerp(Color3.new(0,0,0),0.35)),})end function rivalHubGradientSoft(c)return ColorSequence.new({ColorSequenceKeypoint.new(0.00,c:Lerp(Color3.new(1,1,1),0.75)),ColorSequenceKeypoint.new(0.50,c:Lerp(Color3.new(1,1,1),0.25)),ColorSequenceKeypoint.new(1.00,c:Lerp(Color3.new(0,0,0),0.15)),})end function rivalHubGradientDark(c)return ColorSequence.new({ColorSequenceKeypoint.new(0.00,c:Lerp(Color3.fromRGB(0,0,0),0.35)),ColorSequenceKeypoint.new(0.55,c:Lerp(Color3.fromRGB(0,0,0),0.65)),ColorSequenceKeypoint.new(1.00,c:Lerp(Color3.fromRGB(0,0,0),0.80)),})end function applyRivalHubGradientToLabel(label,c)if not label then return end local grad=label:FindFirstChildOfClass("UIGradient")if not grad then grad=Instance.new("UIGradient",label)end grad.Rotation=0 grad.Color=rivalHubGradient(c)end local _lastThemeUpdate=0 local _lastThemeColor=nil function applyColorTheme(themeName)local color=COLOR_THEMES[themeName]if not color then return end currentColorTheme=themeName selectedColor=color updateAllUIThemeColors(color)saveAllSettings()end _uicStroke=nil _uicAvatarStroke=nil _uicHandle=nil _uicLine=nil function updateAllUIThemeColors(color)local now=_tick()if color==_lastThemeColor and now-_lastThemeUpdate<0.1 then return end _lastThemeUpdate=now _lastThemeColor=color if pbFrame then local border=pbFrame:FindFirstChild("OuterStroke")if border then border.Color=Color3.fromRGB(100,220,255)end local fpsNeon=pbFrame:FindFirstChild("FPSNeon",true)if fpsNeon then fpsNeon.TextColor3=color end local pingNeon=pbFrame:FindFirstChild("PingNeon",true)if pingNeon then pingNeon.TextColor3=color end local divider=pbFrame:FindFirstChild("Divider",true)if divider and divider:IsA("Frame")then divider.BackgroundColor3=color end pbFrame.BackgroundColor3=Color3.fromRGB(0,0,0)pbFrame.BackgroundTransparency=0 end if _uicStroke then _uicStroke.Color=color end if _uicAvatarStroke then _uicAvatarStroke.Color=color end if _uicHandle then _uicHandle.TextColor3=color end if _uicLine then _uicLine.BackgroundColor3=color end local function searchAndUpdateText(parent)for _,child in ipairs(parent:GetDescendants())do if child:IsA("TextLabel")then if child.Name=="DiscordText"then child.TextColor3=color local grad=child:FindFirstChildOfClass("UIGradient")if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,color),ColorSequenceKeypoint.new(0.30,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.50,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.70,Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(1.00,color),})end elseif child.Name=="SpeedLabel"then local blue=Color3.fromRGB(40,170,255)local silver=Color3.fromRGB(240,245,255)child.TextColor3=blue local grad=child:FindFirstChildOfClass("UIGradient")if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,blue),ColorSequenceKeypoint.new(0.30,silver),ColorSequenceKeypoint.new(0.50,blue),ColorSequenceKeypoint.new(0.70,silver),ColorSequenceKeypoint.new(1.00,blue),})end end end if child:IsA("UIStroke")then if child.Color==Color3.fromRGB(180,180,190)then child.Color=color end end end end if gui then searchAndUpdateText(gui)end for _,tab in ipairs(tabButtons or{})do local isActive=tab:FindFirstChild("Underline")and tab.Underline.Visible if isActive then tab.TextColor3=Color3.fromRGB(245,245,255)tab.BackgroundColor3=color tab.BackgroundTransparency=0.15 local tg=tab:FindFirstChild("TabBgGrad")if tg then tg.Color=rivalHubGradient(color)end else tab.TextColor3=Color3.fromRGB(150,150,165)tab.BackgroundColor3=Color3.fromRGB(26,26,34)tab.BackgroundTransparency=1 end local ul=tab:FindFirstChild("Underline")if ul then ul.BackgroundColor3=color end local s=tab:FindFirstChild("TabStroke")if s then s.Color=color end end if _G.__RivalHubRefreshESPTheme then pcall(_G.__RivalHubRefreshESPTheme,color)end if main then local titleFrame=main:FindFirstChild("Frame")if titleFrame then for _,child in ipairs(titleFrame:GetDescendants())do if child:IsA("UIStroke")and child.Color==Color3.fromRGB(180,180,190)then child.Color=color end end end end if colorSelectorLabel then colorSelectorLabel.Text=currentColorTheme colorSelectorLabel.TextColor3=color end if _G._rivalHubStealSlide then _G._rivalHubStealSlide.BackgroundColor3=color local sg=_G._rivalHubStealSlide:FindFirstChildOfClass("UIGradient")if sg then sg.Color=rivalHubGradient(color)end local ss=_G._rivalHubStealSlide:FindFirstChildOfClass("UIStroke")if ss then ss.Color=color end end if miniBtn then local stroke=miniBtn:FindFirstChildOfClass("UIStroke")if stroke then stroke.Color=Color3.fromRGB(40,180,255)stroke.Transparency=0.05 end local rim=miniBtn:FindFirstChild("Rim")if rim then local rimStroke=rim:FindFirstChildOfClass("UIStroke")if rimStroke then rimStroke.Color=Color3.fromRGB(40,180,255)rimStroke.Transparency=0.05 end end end if MobilePanel then for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")and btn:FindFirstChild("BtnGrad")then paintFloatingBtn(btn,btn:GetAttribute("MobActive")==true)end end end end local HOMERO_CFG={body={10725826963,86500008,86500054,86500036,86500064,86500078},aplicarCuerpo=true,items={{id=103227700418,offset=_CFnew(0,0,0)},{id=84952305140948,offset=_CFnew(0,0,0)},{id=122465238537030,offset=_CFnew(0,0,0)},},shirt=nil,pants="rbxassetid://78591690208112",skinColor=Color3.fromRGB(76,202,255),headColor=Color3.fromRGB(0,0,0),}local TAG="LocalOutfit_"local function loadObjects(id)local ok,res=pcall(function()return game:GetObjects("rbxassetid://"..tostring(id))end)if ok and typeof(res)=="table"and#res>0 then return res end ok,res=pcall(function()return game:GetService("InsertService"):LoadAsset(id)end)if ok and res then return{res}end return nil end local function collectParts(objs)local out={}for _,o in ipairs(objs)do if o:IsA("BasePart")then out[#out+1]=o end for _,d in ipairs(o:GetDescendants())do if d:IsA("BasePart")then out[#out+1]=d end end end return out end local function findAtt(char,name)for _,p in ipairs(char:GetDescendants())do if p:IsA("Attachment")and p.Name==name and p.Parent:IsA("BasePart")then return p end end end local function applyBody(char)local total=0 for _,id in ipairs(HOMERO_CFG.body)do local objs=loadObjects(id)if objs then for _,mp in ipairs(collectParts(objs))do local orig=char:FindFirstChild(mp.Name)if orig and orig:IsA("BasePart")then local c=mp:Clone()c.Name=TAG.."body_"..mp.Name c.CanCollide=false c.Anchored=false c.Massless=true c.Size=orig.Size c.CFrame=orig.CFrame c.Parent=char local w=Instance.new("WeldConstraint")w.Part0=orig w.Part1=c w.Parent=c if orig:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then orig:SetAttribute("RivalHubOutfitOriginalTransparency",orig.Transparency)end orig.Transparency=1 total=total+1 end end for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end end end return total end local function attachItem(char,entry)local objs=loadObjects(entry.id)if not objs then return false end local handle for _,p in ipairs(collectParts(objs))do if p.Name=="Handle"then handle=p;break end if not handle then handle=p end end if not handle then for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end return false end local H=handle:Clone()for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end H.Name=TAG.."item_"..tostring(entry.id)H.CanCollide=false H.Anchored=false H.Massless=true local wrap=H:FindFirstChildWhichIsA("WrapLayer")local target,c0,c1 if wrap then target=char:FindFirstChild("UpperTorso")or char:FindFirstChild("Torso")or char:FindFirstChild("HumanoidRootPart")c0=entry.offset or _CFnew()c1=_CFnew()else local hAtt=H:FindFirstChildOfClass("Attachment")local bAtt=hAtt and findAtt(char,hAtt.Name)if bAtt then target=bAtt.Parent c0=bAtt.CFrame*(entry.offset or _CFnew())c1=hAtt.CFrame else target=char:FindFirstChild("Head")c0=entry.offset or _CFnew(0,1.4,0)c1=_CFnew()end end if not target then H:Destroy();return false end H.CFrame=target.CFrame*c0*c1:Inverse()H.Parent=char local w=Instance.new("Weld")w.Part0=target w.Part1=H w.C0=c0 w.C1=c1 w.Parent=H return true end function applyHomeroOutfit(char)if not char then char=LP.Character end if not char then return end char:WaitForChild("Humanoid",10)char:WaitForChild("Head",10)task.wait(0.4)for _,d in ipairs(char:GetChildren())do if d.Name:sub(1,#TAG)==TAG then pcall(function()d:Destroy()end)end end if HOMERO_CFG.skinColor then local bc=char:FindFirstChildWhichIsA("BodyColors")or Instance.new("BodyColors")bc.HeadColor3=HOMERO_CFG.headColor or HOMERO_CFG.skinColor bc.TorsoColor3=HOMERO_CFG.skinColor bc.LeftArmColor3,bc.RightArmColor3=HOMERO_CFG.skinColor,HOMERO_CFG.skinColor bc.LeftLegColor3,bc.RightLegColor3=HOMERO_CFG.skinColor,HOMERO_CFG.skinColor bc.Parent=char end for _,a in ipairs(char:GetChildren())do if a:IsA("Accessory")then local h=a:FindFirstChild("Handle")if h then h.Transparency=1 end end end if HOMERO_CFG.shirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.Name="Shirt"s.ShirtTemplate=HOMERO_CFG.shirt s.Parent=char end if HOMERO_CFG.pants then local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.Name="Pants"p.PantsTemplate=HOMERO_CFG.pants p.Parent=char end if HOMERO_CFG.aplicarCuerpo then applyBody(char)end for _,e in ipairs(HOMERO_CFG.items)do attachItem(char,e)end end local _originalAppearance=nil local function captureOriginalAppearance(char)if not char or _originalAppearance then return end local data={bodyColors=nil,shirt=nil,pants=nil,headMesh=nil,headTexture=nil,}local bc=char:FindFirstChildWhichIsA("BodyColors")if bc then data.bodyColors={head=bc.HeadColor3,torso=bc.TorsoColor3,leftArm=bc.LeftArmColor3,rightArm=bc.RightArmColor3,leftLeg=bc.LeftLegColor3,rightLeg=bc.RightLegColor3,}end local sh=char:FindFirstChildWhichIsA("Shirt")if sh then data.shirt=sh.ShirtTemplate end local pa=char:FindFirstChildWhichIsA("Pants")if pa then data.pants=pa.PantsTemplate end local head=char:FindFirstChild("Head")if head then local sm=head:FindFirstChildWhichIsA("SpecialMesh")if sm and sm.MeshType==Enum.MeshType.FileMesh then data.headMesh=sm.MeshId data.headTexture=sm.TextureId end end _originalAppearance=data end local function clearPreviousOutfitAssets(char)if not char then return end do local headForFace=char:FindFirstChild("Head")local f=headForFace and headForFace:FindFirstChild("face")if f then local otr=f:GetAttribute("RivalHubOriginalFaceTransparency")if otr~=nil then pcall(function()f.Transparency=otr end)f:SetAttribute("RivalHubOriginalFaceTransparency",nil)end end end for _,child in ipairs(char:GetChildren())do if child.Name:sub(1,#TAG)==TAG or child.Name=="AuFfitAccessory"or child.Name=="BubbleSkinChanger_Hair"or child.Name=="BubbleSkinChanger_Hat"or child.Name=="Korblox_RightLeg"then pcall(function()child:Destroy()end)elseif child:IsA("CharacterMesh")and child.BodyPart==Enum.BodyPart.Head then pcall(function()child:Destroy()end)end end for _,part in ipairs(char:GetDescendants())do if part:IsA("BasePart")then local originalTransparency=part:GetAttribute("RivalHubOutfitOriginalTransparency")if originalTransparency~=nil then part.Transparency=originalTransparency part:SetAttribute("RivalHubOutfitOriginalTransparency",nil)end local originalLocalTransparency=part:GetAttribute("RivalHubOutfitOriginalLocalTransparency")if originalLocalTransparency~=nil then part.LocalTransparencyModifier=originalLocalTransparency part:SetAttribute("RivalHubOutfitOriginalLocalTransparency",nil)end end end if _originalAppearance and _originalAppearance.bodyColors then local bc=char:FindFirstChildWhichIsA("BodyColors")or Instance.new("BodyColors")local o=_originalAppearance.bodyColors bc.HeadColor3,bc.TorsoColor3=o.head,o.torso bc.LeftArmColor3,bc.RightArmColor3=o.leftArm,o.rightArm bc.LeftLegColor3,bc.RightLegColor3=o.leftLeg,o.rightLeg bc.Parent=char end local head=char:FindFirstChild("Head")if head and head:IsA("MeshPart")and head:GetAttribute("RivalHubOutfitModifiedMeshPart")then pcall(function()head.MeshId=head:GetAttribute("RivalHubOutfitOriginalMeshId")or""head.TextureID=head:GetAttribute("RivalHubOutfitOriginalTextureId")or""end)head:SetAttribute("RivalHubOutfitModifiedMeshPart",nil)head:SetAttribute("RivalHubOutfitOriginalMeshId",nil)head:SetAttribute("RivalHubOutfitOriginalTextureId",nil)elseif head then local specialMesh=head:FindFirstChildWhichIsA("SpecialMesh")if specialMesh and specialMesh:GetAttribute("RivalHubOutfitCreatedMesh")then specialMesh:Destroy()elseif specialMesh and specialMesh:GetAttribute("RivalHubOutfitModifiedMesh")then specialMesh.MeshId=specialMesh:GetAttribute("RivalHubOutfitOriginalMeshId")or""specialMesh.TextureId=specialMesh:GetAttribute("RivalHubOutfitOriginalTextureId")or""specialMesh:SetAttribute("RivalHubOutfitModifiedMesh",nil)specialMesh:SetAttribute("RivalHubOutfitOriginalMeshId",nil)specialMesh:SetAttribute("RivalHubOutfitOriginalTextureId",nil)end end end local function applyNoOutfit(char)if not char then char=LP.Character end if not char then return end for _,d in ipairs(char:GetChildren())do if d.Name:sub(1,#TAG)==TAG then pcall(function()d:Destroy()end)end end local oldAcc=char:FindFirstChild("AuFfitAccessory")if oldAcc then pcall(function()oldAcc:Destroy()end)end local oldKorblox=char:FindFirstChild("Korblox_RightLeg")if oldKorblox then pcall(function()oldKorblox:Destroy()end)end for _,d in ipairs(char:GetChildren())do if d:IsA("CharacterMesh")and d.BodyPart==Enum.BodyPart.Head then pcall(function()d:Destroy()end)end end local head=char:FindFirstChild("Head")if head then head.Transparency=0 head.CanCollide=true head.LocalTransparencyModifier=0 local face=head:FindFirstChild("face")if face then face.Transparency=0 end local sm=head:FindFirstChildWhichIsA("SpecialMesh")if sm then if _originalAppearance and _originalAppearance.headMesh then sm.MeshId=_originalAppearance.headMesh sm.TextureId=_originalAppearance.headTexture or""else pcall(function()sm:Destroy()end)end end end pcall(function()local neck=char:FindFirstChild("Neck")if neck then neck.Enabled=true end end)for _,partName in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local limb=char:FindFirstChild(partName)if limb then limb.Transparency=0 end end if _originalAppearance and _originalAppearance.bodyColors then local bc=char:FindFirstChildWhichIsA("BodyColors")or Instance.new("BodyColors")local o=_originalAppearance.bodyColors bc.HeadColor3=o.head bc.TorsoColor3=o.torso bc.LeftArmColor3=o.leftArm bc.RightArmColor3=o.rightArm bc.LeftLegColor3=o.leftLeg bc.RightLegColor3=o.rightLeg bc.Parent=char end if _originalAppearance and _originalAppearance.shirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.ShirtTemplate=_originalAppearance.shirt s.Parent=char end if _originalAppearance and _originalAppearance.pants then local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.PantsTemplate=_originalAppearance.pants p.Parent=char end for _,a in ipairs(char:GetChildren())do if a:IsA("Accessory")then local h=a:FindFirstChild("Handle")if h then h.Transparency=0 end end end for _,item in ipairs(char:GetChildren())do if item:IsA("Accessory")then for _,part in ipairs(item:GetDescendants())do if part:IsA("BasePart")then local original=part:GetAttribute("RivalHubOriginalTransparency")if original~=nil then part.Transparency=original;part:SetAttribute("RivalHubOriginalTransparency",nil)end local originalLocal=part:GetAttribute("RivalHubOriginalLocalTransparency")if originalLocal~=nil then part.LocalTransparencyModifier=originalLocal;part:SetAttribute("RivalHubOriginalLocalTransparency",nil)end end end elseif item:IsA("Shirt")then local original=item:GetAttribute("RivalHubOriginalTemplate")if original~=nil then item.ShirtTemplate=original;item:SetAttribute("RivalHubOriginalTemplate",nil)end elseif item:IsA("Pants")then local original=item:GetAttribute("RivalHubOriginalTemplate")if original~=nil then item.PantsTemplate=original;item:SetAttribute("RivalHubOriginalTemplate",nil)end elseif item:IsA("ShirtGraphic")then local original=item:GetAttribute("RivalHubOriginalGraphic")if original~=nil then item.Graphic=original;item:SetAttribute("RivalHubOriginalGraphic",nil)end end end end local OUTFITS={{label="OFF",customApply=applyNoOutfit},{accessory=10159600649,offset=_V3new(0,1,-0.2),shirt="http://www.roblox.com/asset/?id=9683332638",pants="http://www.roblox.com/asset/?id=93182020184041",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 1",headlessKorblox=true},{accessory=1744060292,offset=_V3new(0,1.3,-0.2),shirt="http://www.roblox.com/asset/?id=9683332638",pants="http://www.roblox.com/asset/?id=93182020184041",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 2",headlessKorblox=true},{accessory=215718515,offset=_V3new(0,1.2,-0.15),shirt="http://www.roblox.com/asset/?id=15998365201",pants="http://www.roblox.com/asset/?id=7689651773",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 3",headlessKorblox=true},{accessory=553970961,offset=_V3new(0,1.15,-0.2),shirt="http://www.roblox.com/asset/?id=9478068776",pants="http://www.roblox.com/asset/?id=6348682339",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918 ",korblox="none",label="Outfit 4",headlessKorblox=true},{bubbleShirt=18552805597,bubblePants=5414143509,bubbleHair=84008082880128,label="Outfit 5",headlessKorblox=false},{bubbleShirt=11416036966,bubblePants=5842013905,bubbleHair=86475919719501,bubbleHat=121789170766733,korbloxHeadless=true,label="Outfit 6",headlessKorblox=false},{bubbleShirt=9733132546,bubblePants=101481154733615,bubbleHair=111149505826763,label="Outfit 7",headlessKorblox=false},{bubbleShirt=10796276786,bubblePants=101481154733615,bubbleHair=111149505826763,label="Outfit 8",headlessKorblox=false},}local currentOutfitIndex=1 local outfitSelectorLabel=nil VX7A={index=0,mod=nil,loading=false,busy=false,pending=nil,label=nil,labels={"OFF","ALIEN","OUTFIT","OUTFIT 2","OUTFIT 3","OUTFIT 4","OUTFIT 5","OUTFIT 6","ZeyHubb.vs","NEW SKIN"},}VX7A.src=[==[
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
]==]function VX7A.load()if VX7A.mod then return VX7A.mod end if VX7A.loading or type(loadstring)~="function"then return nil end VX7A.loading=true local ok,fn=pcall(loadstring,VX7A.src)if ok and type(fn)=="function"then local ok2,res=pcall(fn)if ok2 and type(res)=="table"then VX7A.mod=res end end VX7A.loading=false return VX7A.mod end function VX7A.setLabel()if VX7A.label and VX7A.label.Parent then VX7A.label.Text=VX7A.labels[VX7A.index+1]or"OFF"end end function VX7A.stop()VX7A.pending=nil if VX7A.index~=0 then VX7A.index=0 local m=VX7A.mod if m and m.remove then pcall(m.remove)end end VX7A.setLabel()end function VX7A.apply(index)index=math.clamp(math.floor(tonumber(index)or 0),0,#VX7A.labels-1)if index==0 then VX7A.stop()return end local m=VX7A.load()if not m or type(m.apply)~="function"then warn("[ZeyHubb.vs] No se pudo cargar el modulo de avatares VX7 (loadstring no disponible).")VX7A.setLabel()return end if VX7A.busy then VX7A.pending=index;VX7A.index=index;VX7A.setLabel()return end if currentOutfitIndex~=1 then currentOutfitIndex=1 pcall(function()applyOutfitByIndex(1)end)if outfitSelectorLabel then outfitSelectorLabel.Text=OUTFITS[1].label end end VX7A.index=index VX7A.setLabel()VX7A.busy=true task.spawn(function()pcall(m.apply,index)VX7A.busy=false local nxt=VX7A.pending VX7A.pending=nil if nxt and nxt~=0 and VX7A.index==nxt then VX7A.apply(nxt)end end)end pcall(function()LP.CharacterAdded:Connect(function()if _G.RivalHubSession~=_mySession or VX7A.index==0 then return end task.delay(1.5,function()if _G.RivalHubSession==_mySession and VX7A.index~=0 then VX7A.apply(VX7A.index)end end)end)end)local function loadObjectsStd(id)local ok,res=pcall(function()return game:GetObjects("rbxassetid://"..tostring(id))end)if ok and typeof(res)=="table"and#res>0 then return res end ok,res=pcall(function()return game:GetService("InsertService"):LoadAsset(id)end)if ok and res then return{res}end return nil end local function resolveBubbleTemplate(id,className,propertyName)local fallback="rbxassetid://"..tostring(id)local ok,objects=pcall(function()return game:GetObjects(fallback)end)if ok and objects and objects[1]then local item=objects[1]local obj=item:IsA(className)and item or item:FindFirstChildWhichIsA(className,true)if obj and obj[propertyName]and obj[propertyName]~=""then fallback=obj[propertyName]end for _,v in ipairs(objects)do pcall(function()v:Destroy()end)end end return fallback end local function addBubbleHair(char,assetId,accName)local head=char and char:FindFirstChild("Head")if not head then return false end local objects=loadObjectsStd(assetId)if not objects or not objects[1]then return false end local source=objects[1]local accessory=source:IsA("Accessory")and source or source:FindFirstChildWhichIsA("Accessory",true)if not accessory then for _,v in ipairs(objects)do pcall(function()v:Destroy()end)end return false end local hair=accessory:Clone()hair.Name=accName or"BubbleSkinChanger_Hair"for _,part in ipairs(hair:GetDescendants())do if part:IsA("BasePart")then part.Anchored=false;part.CanCollide=false;part.Massless=true;part.LocalTransparencyModifier=0 end end local humanoid=char:FindFirstChildOfClass("Humanoid")local ok=pcall(function()if humanoid then humanoid:AddAccessory(hair)else hair.Parent=char end end)if not ok then pcall(function()hair:Destroy()end)end if ok then task.wait()if hair.Parent~=char then pcall(function()hair.Parent=char end)end local handle=hair:FindFirstChild("Handle")if handle and handle:IsA("BasePart")and handle.Parent and not handle:FindFirstChildWhichIsA("Weld")and not handle:FindFirstChildWhichIsA("WeldConstraint")then pcall(function()local att=handle:FindFirstChildWhichIsA("Attachment")local target=att and char:FindFirstChild(att.Name,true)local weld=Instance.new("Weld")weld.Name="AccessoryWeld"if target and target:IsA("Attachment")then weld.Part0=target.Parent weld.C0=target.CFrame weld.C1=att.CFrame else weld.Part0=head weld.C0=CFrame.new(0,head.Size.Y/2,0)*hair.AttachmentPoint:Inverse()end weld.Part1=handle weld.Parent=handle end)end end for _,v in ipairs(objects)do pcall(function()v:Destroy()end)end return ok end local function applyHeadlessKorblox(char)if not char then return end pcall(function()LP.CharacterAvatarType=Enum.AvatarType.R6 end)local head=char:FindFirstChild("Head")if head then if head:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then head:SetAttribute("RivalHubOutfitOriginalTransparency",head.Transparency)head:SetAttribute("RivalHubOutfitOriginalLocalTransparency",head.LocalTransparencyModifier)end head.Transparency=1 head.CanCollide=false head.LocalTransparencyModifier=1 local face=head:FindFirstChild("face")if face then face.Transparency=1 end end pcall(function()local neck=char:FindFirstChild("Neck")if neck then neck.Enabled=false end end)for _,v in pairs(char:GetChildren())do if v:IsA("Accessory")then local w=v:FindFirstChildWhichIsA("Weld")or v:FindFirstChildWhichIsA("WeldConstraint")or v:FindFirstChildWhichIsA("Motor6D")if w then local p0,p1=w.Part0,w.Part1 if(p0 and p0.Name=="Head")or(p1 and p1.Name=="Head")then for _,part in ipairs(v:GetDescendants())do if part:IsA("BasePart")then if part:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then part:SetAttribute("RivalHubOutfitOriginalTransparency",part.Transparency)part:SetAttribute("RivalHubOutfitOriginalLocalTransparency",part.LocalTransparencyModifier)end part.Transparency=1 part.LocalTransparencyModifier=1 end end end end end end local rightLegConfig={id="rbxassetid://139607718",targetBodyPart="RightUpperLeg",partsToHide={"RightUpperLeg","RightLowerLeg","RightFoot"},scale=_V3new(1,1,1),offset=_CFnew(0,0,0)}local targetPart=char:FindFirstChild(rightLegConfig.targetBodyPart)if targetPart then local oldAsset=char:FindFirstChild("Korblox_RightLeg")if oldAsset then oldAsset:Destroy()end for _,partName in ipairs(rightLegConfig.partsToHide)do local limb=char:FindFirstChild(partName)if limb and limb:IsA("BasePart")then if limb:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then limb:SetAttribute("RivalHubOutfitOriginalTransparency",limb.Transparency)end limb.Transparency=1 end end local success,objects=pcall(function()return game:GetObjects(rightLegConfig.id)end)if success and objects and#objects>0 then local assetModel=objects[1]assetModel.Name="Korblox_RightLeg"local mainMesh=assetModel:IsA("BasePart")and assetModel or assetModel:FindFirstChildWhichIsA("BasePart",true)if mainMesh then mainMesh.Size=mainMesh.Size*rightLegConfig.scale mainMesh.CanCollide=false mainMesh.CFrame=targetPart.CFrame*rightLegConfig.offset local weld=Instance.new("WeldConstraint")weld.Part0=targetPart weld.Part1=mainMesh weld.Parent=mainMesh assetModel.Parent=char end end end end function applyBubbleKorbloxHeadless(char)if not char then return end local targetPart=char:FindFirstChild("RightUpperLeg")if targetPart then local old=char:FindFirstChild("Korblox_RightLeg")if old then old:Destroy()end for _,partName in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local limb=char:FindFirstChild(partName)if limb and limb:IsA("BasePart")then if limb:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then limb:SetAttribute("RivalHubOutfitOriginalTransparency",limb.Transparency)end limb.Transparency=1 end end local success,objects=pcall(function()return game:GetObjects("rbxassetid://139607718")end)if success and objects and#objects>0 then local assetModel=objects[1]assetModel.Name="Korblox_RightLeg"local mainMesh=assetModel:IsA("BasePart")and assetModel or assetModel:FindFirstChildWhichIsA("BasePart",true)if mainMesh then mainMesh.CanCollide=false mainMesh.CFrame=targetPart.CFrame local weld=Instance.new("WeldConstraint")weld.Part0=targetPart weld.Part1=mainMesh weld.Parent=mainMesh assetModel.Parent=char end end end local head=char:FindFirstChild("Head")if head and head:IsA("BasePart")then if head:GetAttribute("RivalHubOutfitOriginalTransparency")==nil then head:SetAttribute("RivalHubOutfitOriginalTransparency",head.Transparency)head:SetAttribute("RivalHubOutfitOriginalLocalTransparency",head.LocalTransparencyModifier)end head.Transparency=1 head.LocalTransparencyModifier=1 local face=head:FindFirstChild("face")if face and face:IsA("Decal")then if face:GetAttribute("RivalHubOriginalFaceTransparency")==nil then face:SetAttribute("RivalHubOriginalFaceTransparency",face.Transparency)end face.Transparency=1 end end end function applyOutfitByIndex(index)local cfg=OUTFITS[index]if not cfg then return end local char=LP.Character if not char then return end clearPreviousOutfitAssets(char)for _,item in ipairs(char:GetChildren())do if item:IsA("Accessory")and item.Name:sub(1,#TAG)~=TAG then for _,part in ipairs(item:GetDescendants())do if part:IsA("BasePart")then if part:GetAttribute("RivalHubOriginalTransparency")==nil then part:SetAttribute("RivalHubOriginalTransparency",part.Transparency)part:SetAttribute("RivalHubOriginalLocalTransparency",part.LocalTransparencyModifier)end part.Transparency=1 part.LocalTransparencyModifier=1 end end elseif item:IsA("Shirt")then if item:GetAttribute("RivalHubOriginalTemplate")==nil then item:SetAttribute("RivalHubOriginalTemplate",item.ShirtTemplate)end item.ShirtTemplate=""elseif item:IsA("Pants")then if item:GetAttribute("RivalHubOriginalTemplate")==nil then item:SetAttribute("RivalHubOriginalTemplate",item.PantsTemplate)end item.PantsTemplate=""elseif item:IsA("ShirtGraphic")then if item:GetAttribute("RivalHubOriginalGraphic")==nil then item:SetAttribute("RivalHubOriginalGraphic",item.Graphic)end item.Graphic=""end end if cfg.customApply then cfg.customApply(char)if outfitSelectorLabel then outfitSelectorLabel.Text=cfg.label end return end if cfg.bubbleShirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.Name="BubbleSkinChanger_Shirt"s.ShirtTemplate=resolveBubbleTemplate(cfg.bubbleShirt,"Shirt","ShirtTemplate")s.Parent=char local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.Name="BubbleSkinChanger_Pants"p.PantsTemplate=resolveBubbleTemplate(cfg.bubblePants,"Pants","PantsTemplate")p.Parent=char addBubbleHair(char,cfg.bubbleHair)if cfg.bubbleHat then addBubbleHair(char,cfg.bubbleHat,"BubbleSkinChanger_Hat")end if cfg.korbloxHeadless then pcall(applyBubbleKorbloxHeadless,char)end if outfitSelectorLabel then outfitSelectorLabel.Text=cfg.label end return end char:WaitForChild("Head",5)local head=char:FindFirstChild("Head")if not head then return end for _,d in ipairs(char:GetChildren())do if d:IsA("CharacterMesh")and d.BodyPart==Enum.BodyPart.Head then pcall(function()d:Destroy()end)end end local done=false if head:IsA("MeshPart")then done=pcall(function()if not head:GetAttribute("RivalHubOutfitModifiedMeshPart")then head:SetAttribute("RivalHubOutfitOriginalMeshId",head.MeshId)head:SetAttribute("RivalHubOutfitOriginalTextureId",head.TextureID)head:SetAttribute("RivalHubOutfitModifiedMeshPart",true)end head.MeshId=cfg.headMesh head.TextureID=cfg.headTexture or""end)end if not done then local sm=head:FindFirstChildWhichIsA("SpecialMesh")if not sm then sm=Instance.new("SpecialMesh")sm:SetAttribute("RivalHubOutfitCreatedMesh",true)elseif not sm:GetAttribute("RivalHubOutfitModifiedMesh")then sm:SetAttribute("RivalHubOutfitOriginalMeshId",sm.MeshId)sm:SetAttribute("RivalHubOutfitOriginalTextureId",sm.TextureId)sm:SetAttribute("RivalHubOutfitModifiedMesh",true)end sm.Parent=head sm.MeshType=Enum.MeshType.FileMesh sm.MeshId=cfg.headMesh sm.TextureId=cfg.headTexture or""end if cfg.shirt then local s=char:FindFirstChildWhichIsA("Shirt")or Instance.new("Shirt")s.Name="Shirt"s.ShirtTemplate=cfg.shirt s.Parent=char end if cfg.pants then local p=char:FindFirstChildWhichIsA("Pants")or Instance.new("Pants")p.Name="Pants"p.PantsTemplate=cfg.pants p.Parent=char end local old=char:FindFirstChild("AuFfitAccessory")if old then old:Destroy()end if cfg.accessory and head then local objs=loadObjectsStd(cfg.accessory)if objs then local handle for _,o in ipairs(objs)do if o:IsA("BasePart")then handle=o;break end local f=o:FindFirstChildWhichIsA("BasePart",true)if f then handle=f;break end end if handle then local h=handle:Clone()h.Name="AuFfitAccessory"h.CanCollide=false h.Anchored=false h.Massless=true h.Parent=char local weld=Instance.new("Weld")weld.Part0=head weld.Part1=h weld.C0=_CFnew(cfg.offset)weld.Parent=h end for _,o in ipairs(objs)do pcall(function()o:Destroy()end)end end end if cfg.headlessKorblox then applyHeadlessKorblox(char)else if char then local head2=char:FindFirstChild("Head")if head2 then head2.Transparency=0 head2.CanCollide=true head2.LocalTransparencyModifier=0 local face2=head2:FindFirstChild("face")if face2 then face2.Transparency=0 end end pcall(function()local neck=char:FindFirstChild("Neck")if neck then neck.Enabled=true end end)for _,partName in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local limb=char:FindFirstChild(partName)if limb then limb.Transparency=0 end end local oldKorblox=char:FindFirstChild("Korblox_RightLeg")if oldKorblox then oldKorblox:Destroy()end end end if outfitSelectorLabel then outfitSelectorLabel.Text=cfg.label end end speedMode=false antiRagdollMode="off"antiDieEnabled=false antiBatEnabled=false antiFlingEnabled=false jumpEnabled=false laggerToggled=false laggerCarryToggled=false medusaCounterEnabled=false batCounterEnabled=false unwalkEnabled=false autoLeftEnabled=false autoRightEnabled=false autoBatEnabled=false dropMode=1 antiLagEnabled=false removeAccessoriesEnabled=false stretchEnabled=false stretchFOV=120 uiLocked=false mobileButtonsLocked=false uiScaleValue=78 espEnabled=false espLineEnabled=false vividGraphicsEnabled=false _vividEffects={}setVividVisual=nil hideButtonsEnabled=false setHideButtonsVisual=nil
hiddenMobileButtons=hiddenMobileButtons or{}
local MOBILE_BTN_HIDE_ORDER={"DropBR","AutoLeft","AutoBat","AutoRight","BatAimbot","TpDown","Carry","Lagger1","Lagger2","BatV2","BatTP","Float","InstantReset"}
local MOBILE_BTN_HIDE_LABELS={DropBR="Hide Drop BR",AutoLeft="Hide Auto Left",AutoBat="Hide Bypass Bat",AutoRight="Hide Auto Right",BatAimbot="Hide Bat Aimbot",TpDown="Hide TP Down",Carry="Hide Carry Speed",Lagger1="Hide Lagger Normal",Lagger2="Hide Lagger Carry",BatV2="Hide Bat V2",BatTP="Hide Bat TP",Float="Hide Float",InstantReset="Hide Instant Reset"}
function applyMobileButtonVisibility()
if not MobilePanel then return end
for _,child in ipairs(MobilePanel:GetChildren())do
if child:IsA("TextButton")then
local n=child.Name
if hideButtonsEnabled then
child.Visible=false
elseif hiddenMobileButtons[n]==true then
child.Visible=false
else
child.Visible=true
end
end
end
end
 bodyLockEnabled=false bodyLockRange=20 bodyLockRangeBox=nil _bodyLockConn=nil _blSuppressCount=0 _blWasEnabled=false _blRestoreTimer=nil _blSmoothRestore=false savedProgressBarPos=nil savedButtonPositions={}savedMobilePanelPos=nil neonWeatherEnabled=false skyTheme="Off"skySelectorLabel=nil _originalLighting=nil setNeonWeatherVisual=nil currentAnimPack="Off"originalTryardAnims=nil tryardHeartbeatConn=nil animSelectorLabel=nil lastMoveDir=_V3zero local CoreGui=game:GetService("CoreGui")local InfiniteJump={enabled=false,mode="hold",jumpPower=55,minVelocity=35,fallClamp=-120,jumpConn=nil,heartbeatConn=nil,presimConn=nil,}local function applyInfJumpBoost(root)if not root then return end local velocity=root.AssemblyLinearVelocity if velocity.Y<InfiniteJump.minVelocity then root.AssemblyLinearVelocity=_V3new(velocity.X,InfiniteJump.jumpPower,velocity.Z)end if velocity.Y<InfiniteJump.fallClamp then root.AssemblyLinearVelocity=_V3new(velocity.X,InfiniteJump.fallClamp,velocity.Z)end end local function onJumpRequest()if not InfiniteJump.enabled then return end local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if root then pcall(function()root.AssemblyLinearVelocity=_V3new(root.AssemblyLinearVelocity.X,InfiniteJump.jumpPower,root.AssemblyLinearVelocity.Z)end)end end local function onPreSimulation()if not InfiniteJump.enabled then return end if InfiniteJump.mode~="hold"then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum or not root then return end local held=UIS:IsKeyDown(Enum.KeyCode.Space)or UIS:IsKeyDown(Enum.KeyCode.ButtonA)or(hum.Jump==true)if held then applyInfJumpBoost(root)else local v=root.AssemblyLinearVelocity if v.Y<InfiniteJump.fallClamp then root.AssemblyLinearVelocity=_V3new(v.X,InfiniteJump.fallClamp,v.Z)end end end local function connectEvents()if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect()end if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect()end if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect()end InfiniteJump.jumpConn=UIS.JumpRequest:Connect(onJumpRequest)InfiniteJump.presimConn=RunService.PreSimulation:Connect(onPreSimulation)end function InfiniteJump.start()if InfiniteJump.enabled then return end InfiniteJump.enabled=true connectEvents()end function InfiniteJump.stop()InfiniteJump.enabled=false if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect();InfiniteJump.jumpConn=nil end if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect();InfiniteJump.heartbeatConn=nil end if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect();InfiniteJump.presimConn=nil end end function InfiniteJump.setJumpPower(power)power=tonumber(power)or 55 InfiniteJump.jumpPower=_clamp(power,10,200)end function InfiniteJump.setMode(mode)InfiniteJump.mode=mode=="manual"and"manual"or"hold"end function InfiniteJump.isRunning()return InfiniteJump.enabled==true end InfiniteJump.stop()function getActiveMoveSpeed()if laggerCarryToggled then return LAGGER_CARRY_SPEED elseif laggerToggled then return LAGGER_SPEED elseif speedMode then return CS else return NS end end function getSpeedModeName()if laggerToggled or laggerCarryToggled then return"LAGGER"elseif speedMode then return"CARRY"else return"NORMAL"end end local _s2VelState=_G.__RivalHubSpeedHookState if type(_s2VelState)~="table"then _s2VelState={hooked=false,velChecked=setmetatable({},{__mode="k"}),root=nil,v=_V3zero,}_G.__RivalHubSpeedHookState=_s2VelState end local _velChecked=_s2VelState.velChecked local _hookedVelParts={}local _hookVelSupported=nil local function _hookVelHRP(hrp)if not hrp then return end _s2VelState.root=hrp _velChecked[hrp]=true if _s2VelState.hooked then return end if type(getrawmetatable)~="function"or type(setreadonly)~="function"or type(newcclosure)~="function"or type(checkcaller)~="function"then return end local ok=pcall(function()local mt=getrawmetatable(game)if not mt then return end setreadonly(mt,false)local originalIndex=rawget(mt,"__index")local originalNewIndex=rawget(mt,"__newindex")local function isOurRoot(t,k)local tk=tostring(k)if tk~="AssemblyLinearVelocity"and tk~="Velocity"then return false end if typeof(t)~="Instance"or not t:IsA("BasePart")then return false end local tn=t.Name if tn~="HumanoidRootPart"and tn~="Torso"and tn~="UpperTorso"then return false end local char=LP.Character return char~=nil and t:IsDescendantOf(char)end if type(originalIndex)=="function"or type(originalIndex)=="table"then local replacementIndex=newcclosure(function(self,key)if not checkcaller()then local good,mine=pcall(isOurRoot,self,key)if good and mine then return _s2VelState.v end end if type(originalIndex)=="function"then return originalIndex(self,key)else return originalIndex[key]end end)mt.__index=replacementIndex end if type(originalNewIndex)=="function"then local replacementNewIndex=newcclosure(function(self,key,value)if not checkcaller()then local good,mine=pcall(isOurRoot,self,key)if good and mine then _s2VelState.v=value return end end return originalNewIndex(self,key,value)end)mt.__newindex=replacementNewIndex end setreadonly(mt,true)_s2VelState.hooked=true end)if not ok then _s2VelState.hooked=false end end local function _setupVelChecked(char)_velChecked=setmetatable({},{__mode="k"})_s2VelState.velChecked=_velChecked if not char then _s2VelState.root=nil;return nil end local hrp=char:WaitForChild("HumanoidRootPart",5)if hrp then _s2VelState.root=hrp _velChecked[hrp]=true end return hrp end if LP.Character then local _hrp0=_setupVelChecked(LP.Character)_hookVelHRP(_hrp0)end local function _isRagdollState(hum)if not hum then return true end local st=hum:GetState()return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown end local function _applyVelocitySpeed(dir,speed,hrp)if not hrp or not hrp.Parent then return end if autoBatEnabled or _G.__RivalHubBatAimbotIsEnabled==true then return end if type(speed)~="number"or speed~=speed or speed<=0 or speed==math.huge then return end local verticalVelocity=hrp.AssemblyLinearVelocity.Y if _G._ZurichHub_MovementBlocked==true or _G._CrystalHub_MovementBlocked==true then hrp.AssemblyLinearVelocity=_V3new(0,math.min(verticalVelocity,0),0)return end if dir and dir.Magnitude>0.05 then pcall(function()if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP)end end)local unit=dir.Unit hrp.AssemblyLinearVelocity=_V3new(unit.X*speed,verticalVelocity,unit.Z*speed)local visibleSpeed=math.min(speed,20)_s2VelState.v=_V3new(unit.X*visibleSpeed,verticalVelocity,unit.Z*visibleSpeed)_G.__RivalHubLiveSpeed={t=os.clock(),v=speed}else _s2VelState.v=_V3new(0,verticalVelocity,0)hrp.AssemblyLinearVelocity=_V3new(0,verticalVelocity,0)end end function getAutoPathSpeed()if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end return NS end ANIM_PACKS={["Cartoon"]={idle1="rbxassetid://742637544",idle2="rbxassetid://742638445",walk="rbxassetid://742640026",run="rbxassetid://742638842",jump="rbxassetid://742637942",fall="rbxassetid://742637151",climb="rbxassetid://742636889",swim="rbxassetid://742639220",swimidle="rbxassetid://742639812"},["Adidas Community"]={idle1="rbxassetid://122257458498464",idle2="rbxassetid://102357151005774",walk="rbxassetid://122150855457006",run="rbxassetid://82598234841035",jump="rbxassetid://75290611992385",fall="rbxassetid://98600215928904",climb="rbxassetid://88763136693023",swim="rbxassetid://133308483266208",swimidle="rbxassetid://109346520324160"},["Adidas Aura"]={idle1="rbxassetid://110211186840347",idle2="rbxassetid://114191137265065",walk="rbxassetid://83842218823011",run="rbxassetid://118320322718866",jump="rbxassetid://109996626521204",fall="rbxassetid://95603166884636",climb="rbxassetid://97824616490448",swim="rbxassetid://134530128383903",swimidle="rbxassetid://94922130551805"},["Catwalk Glam"]={idle1="rbxassetid://133806214992291",idle2="rbxassetid://94970088341563",walk="rbxassetid://109168724482748",run="rbxassetid://81024476153754",jump="rbxassetid://116936326516985",fall="rbxassetid://92294537340807",climb="rbxassetid://119377220967554",swim="rbxassetid://134591743181628",swimidle="rbxassetid://98854111361360"},["Amazon Unboxed"]={idle1="rbxassetid://98281136301627",idle2="rbxassetid://98281136301627",walk="rbxassetid://90478085024465",run="rbxassetid://134824450619865",jump="rbxassetid://121454505477205",fall="rbxassetid://94788218468396",climb="rbxassetid://121145883950231",swim="rbxassetid://105962919001086",swimidle="rbxassetid://129126268464847"},["Zombie"]={idle1="rbxassetid://616158929",idle2="rbxassetid://616160636",walk="rbxassetid://616168032",run="rbxassetid://616163682",jump="rbxassetid://616161997",fall="rbxassetid://616157476",climb="rbxassetid://616156119",swim="rbxassetid://616165109",swimidle="rbxassetid://616166655"},["Ninja"]={idle1="rbxassetid://656117400",idle2="rbxassetid://656117400",walk="rbxassetid://656121766",run="rbxassetid://656118852",jump="rbxassetid://656117878",fall="rbxassetid://656115606",climb="rbxassetid://656114359",swim="rbxassetid://656117400",swimidle="rbxassetid://656117400"},["Knight"]={idle1="rbxassetid://657595757",idle2="rbxassetid://657595757",walk="rbxassetid://657552124",run="rbxassetid://657564596",jump="rbxassetid://658409194",fall="rbxassetid://657600338",climb="rbxassetid://658360781",swim="rbxassetid://657595757",swimidle="rbxassetid://657595757"},["Elder"]={idle1="rbxassetid://845397899",idle2="rbxassetid://845397899",walk="rbxassetid://845403856",run="rbxassetid://845386501",jump="rbxassetid://845398858",fall="rbxassetid://845397673",climb="rbxassetid://845392038",swim="rbxassetid://845397899",swimidle="rbxassetid://845397899"},["Levitate"]={idle1="rbxassetid://616006778",idle2="rbxassetid://616006778",walk="rbxassetid://616013216",run="rbxassetid://616013216",jump="rbxassetid://616008936",fall="rbxassetid://616005863",climb="rbxassetid://616003713",swim="rbxassetid://616006778",swimidle="rbxassetid://616006778"},["Astronaut"]={idle1="rbxassetid://891621366",idle2="rbxassetid://891621366",walk="rbxassetid://891636393",run="rbxassetid://891636393",jump="rbxassetid://891627522",fall="rbxassetid://891617961",climb="rbxassetid://891609353",swim="rbxassetid://891621366",swimidle="rbxassetid://891621366"},["Pirate"]={idle1="rbxassetid://750781874",idle2="rbxassetid://750781874",walk="rbxassetid://750785693",run="rbxassetid://750783738",jump="rbxassetid://750782230",fall="rbxassetid://750780242",climb="rbxassetid://750779899",swim="rbxassetid://750781874",swimidle="rbxassetid://750781874"},["Toy"]={idle1="rbxassetid://782841498",idle2="rbxassetid://782841498",walk="rbxassetid://782843345",run="rbxassetid://782842708",jump="rbxassetid://782847020",fall="rbxassetid://782846423",climb="rbxassetid://782843869",swim="rbxassetid://782841498",swimidle="rbxassetid://782841498"},["Vampire"]={idle1="rbxassetid://1083445855",idle2="rbxassetid://1083445855",walk="rbxassetid://1083473930",run="rbxassetid://1083462077",jump="rbxassetid://1083455352",fall="rbxassetid://1083443587",climb="rbxassetid://1083439238",swim="rbxassetid://1083445855",swimidle="rbxassetid://1083445855"},["Werewolf"]={idle1="rbxassetid://1083195517",idle2="rbxassetid://1083195517",walk="rbxassetid://1083178339",run="rbxassetid://1083216690",jump="rbxassetid://1083218792",fall="rbxassetid://1083189019",climb="rbxassetid://1083182000",swim="rbxassetid://1083195517",swimidle="rbxassetid://1083195517"},["Rthro"]={idle1="rbxassetid://2510196951",idle2="rbxassetid://2510196951",walk="rbxassetid://2510202577",run="rbxassetid://2510198475",jump="rbxassetid://2510197830",fall="rbxassetid://2510195892",climb="rbxassetid://2510192778",swim="rbxassetid://2510196951",swimidle="rbxassetid://2510196951"},["Stylish"]={idle1="rbxassetid://616136790",idle2="rbxassetid://616136790",walk="rbxassetid://616146177",run="rbxassetid://616140816",jump="rbxassetid://616139451",fall="rbxassetid://616134815",climb="rbxassetid://616133594",swim="rbxassetid://616136790",swimidle="rbxassetid://616136790"},}ANIM_PACK_ORDER={{"Off","Off"},{"Cartoon","Cartoon"},{"Adidas Community","Adidas Community"},{"Adidas Aura","Adidas Aura"},{"Catwalk Glam","Catwalk Glam"},{"Amazon Unboxed","Amazon Unboxed"},{"Zombie","Zombie"},{"Ninja","Ninja"},{"Knight","Knight"},{"Elder","Elder"},{"Levitate","Levitate"},{"Astronaut","Astronaut"},{"Pirate","Pirate"},{"Toy","Toy"},{"Vampire","Vampire"},{"Werewolf","Werewolf"},{"Rthro","Rthro"},{"Stylish","Stylish"}}local function isPackAnim(id)for _,pack in pairs(ANIM_PACKS)do for _,v in pairs(pack)do if v==id then return true end end end return false end local function saveOriginalAnims(char)local animate=char:FindFirstChild("Animate")if not animate then return end local function g(obj)return obj and obj.AnimationId or nil end local ids={idle1=g(animate.idle and animate.idle.Animation1),idle2=g(animate.idle and animate.idle.Animation2),walk=g(animate.walk and animate.walk.WalkAnim),run=g(animate.run and animate.run.RunAnim),jump=g(animate.jump and animate.jump.JumpAnim),fall=g(animate.fall and animate.fall.FallAnim),climb=g(animate.climb and animate.climb.ClimbAnim),swim=g(animate.swim and animate.swim.Swim),swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),}if not isPackAnim(ids.walk)then originalTryardAnims=ids end end local function applyAnimPack(packName)currentAnimPack=packName if animSelectorLabel then animSelectorLabel.Text=packName end if packName=="Off"then if originalTryardAnims and LP.Character then local animate=LP.Character:FindFirstChild("Animate")if animate then local function s(obj,id)if obj then obj.AnimationId=id end end s(animate.idle and animate.idle.Animation1,originalTryardAnims.idle1)s(animate.idle and animate.idle.Animation2,originalTryardAnims.idle2)s(animate.walk and animate.walk.WalkAnim,originalTryardAnims.walk)s(animate.run and animate.run.RunAnim,originalTryardAnims.run)s(animate.jump and animate.jump.JumpAnim,originalTryardAnims.jump)s(animate.fall and animate.fall.FallAnim,originalTryardAnims.fall)s(animate.climb and animate.climb.ClimbAnim,originalTryardAnims.climb)s(animate.swim and animate.swim.Swim,originalTryardAnims.swim)s(animate.swimidle and animate.swimidle.SwimIdle,originalTryardAnims.swimidle)end end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect();tryardHeartbeatConn=nil end return end local pack=ANIM_PACKS[packName]if not pack then return end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect()end tryardHeartbeatConn=RunService.Heartbeat:Connect(function()local c=LP.Character if not c then return end local animate=c:FindFirstChild("Animate")if not animate then return end local function s(obj,id)if obj then obj.AnimationId=id end end s(animate.idle and animate.idle.Animation1,pack.idle1)s(animate.idle and animate.idle.Animation2,pack.idle2)s(animate.walk and animate.walk.WalkAnim,pack.walk)s(animate.run and animate.run.RunAnim,pack.run)s(animate.jump and animate.jump.JumpAnim,pack.jump)s(animate.fall and animate.fall.FallAnim,pack.fall)s(animate.climb and animate.climb.ClimbAnim,pack.climb)s(animate.swim and animate.swim.Swim,pack.swim)s(animate.swimidle and animate.swimidle.SwimIdle,pack.swimidle)end)end local function startAnimPack(packName)local char=LP.Character if char then saveOriginalAnims(char)applyAnimPack(packName)local hum=char:FindFirstChildOfClass("Humanoid")if hum then for _,track in ipairs(hum:GetPlayingAnimationTracks())do track:Stop(0)end hum:ChangeState(Enum.HumanoidStateType.Running)end else applyAnimPack(packName)end currentAnimPack=packName end local function stopAnimPack()currentAnimPack="Off"if animSelectorLabel then animSelectorLabel.Text="Off"end applyAnimPack("Off")end DEFAULT_KB={BatAimbot={kb=Enum.KeyCode.G,gp=nil},DropBrainrot={kb=Enum.KeyCode.X,gp=nil},AutoLeft={kb=Enum.KeyCode.Z,gp=nil},AutoRight={kb=Enum.KeyCode.C,gp=nil},AutoBat={kb=Enum.KeyCode.E,gp=nil},TPFloor={kb=Enum.KeyCode.F,gp=nil},GuiHide={kb=Enum.KeyCode.LeftControl,gp=nil},CarryToggle={kb=Enum.KeyCode.Q,gp=nil},LaggerMode={kb=Enum.KeyCode.R,gp=nil},BatV2={kb=Enum.KeyCode.V,gp=nil},TPBat={kb=Enum.KeyCode.T,gp=nil},Float={kb=Enum.KeyCode.B,gp=nil},InstantReset={kb=Enum.KeyCode.K,gp=nil},}KB={BatAimbot={kb=DEFAULT_KB.BatAimbot.kb,gp=DEFAULT_KB.BatAimbot.gp},DropBrainrot={kb=DEFAULT_KB.DropBrainrot.kb,gp=DEFAULT_KB.DropBrainrot.gp},AutoLeft={kb=DEFAULT_KB.AutoLeft.kb,gp=DEFAULT_KB.AutoLeft.gp},AutoRight={kb=DEFAULT_KB.AutoRight.kb,gp=DEFAULT_KB.AutoRight.gp},AutoBat={kb=DEFAULT_KB.AutoBat.kb,gp=DEFAULT_KB.AutoBat.gp},TPFloor={kb=DEFAULT_KB.TPFloor.kb,gp=DEFAULT_KB.TPFloor.gp},GuiHide={kb=DEFAULT_KB.GuiHide.kb,gp=DEFAULT_KB.GuiHide.gp},CarryToggle={kb=DEFAULT_KB.CarryToggle.kb,gp=DEFAULT_KB.CarryToggle.gp},LaggerMode={kb=DEFAULT_KB.LaggerMode.kb,gp=DEFAULT_KB.LaggerMode.gp},BatV2={kb=DEFAULT_KB.BatV2.kb,gp=DEFAULT_KB.BatV2.gp},TPBat={kb=DEFAULT_KB.TPBat.kb,gp=DEFAULT_KB.TPBat.gp},Float={kb=DEFAULT_KB.Float.kb,gp=DEFAULT_KB.Float.gp},InstantReset={kb=DEFAULT_KB.InstantReset.kb,gp=DEFAULT_KB.InstantReset.gp},}_isResetting=false _lastSavedJSON=nil _isLoading=false CONFIG={AUTO_STEAL_ENABLED=false,STEAL_RANGE=61,HOLD_MIN=0.05,HOLD_MAX=0.15,ENTRY_DELAY=0.1,COOLDOWN=0.2,PRIME_RANGE=60,}local plots=workspace:WaitForChild("Plots")local stealConnection=nil local Steal={AutoStealEnabled=false,StealRadius=(tonumber(CONFIG.STEAL_RANGE) or 61),StealDuration=1.3,StealDelay=0.25,Data={}}
local isStealing=false
local autoStealMode="73"
stealBarStyle="V1"
local autoGrabSetDelayRadius=9
local autoGrabStopTime=0.949
local autoGrabStopEnabled=true
local function applyStealStopPercent(mode)
 local s=tostring(mode or"73"):gsub("%%",""):gsub("%s","")
 local pct=tonumber(s) or 73
 if pct<50 then pct=50 end
 if pct>99 then pct=99 end
 autoStealMode=tostring(math.floor(pct+0.5))
 local dur=tonumber(Steal and Steal.StealDuration) or 1.3
 autoGrabStopTime=dur*(pct/100)
 autoGrabStopEnabled=true
end
applyStealStopPercent(autoStealMode)
local _stealRunId=0
local _stealLockUntil=0
local function isMyPlotByName(plotName)
 local plots=workspace:FindFirstChild("Plots")
 if not plots then return false end
 local plot=plots:FindFirstChild(plotName)
 if not plot then return false end
 local sign=plot:FindFirstChild("PlotSign")
 if sign then
  local yb=sign:FindFirstChild("YourBase")
  if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end
 end
 return false
end
local function findNearestPrompt()
 local char=LP.Character
 if not char then return nil,nil end
 local root=char:FindFirstChild("HumanoidRootPart")
 if not root then return nil,nil end
 local plots=workspace:FindFirstChild("Plots")
 if not plots then return nil,nil end
 local nearestPrompt,nearestDist,nearestName=nil,math.huge,nil
 for _,plot in ipairs(plots:GetChildren()) do
  if not isMyPlotByName(plot.Name) then
   local pods=plot:FindFirstChild("AnimalPodiums")
   if pods then
    for _,pod in ipairs(pods:GetChildren()) do
     pcall(function()
      local base=pod:FindFirstChild("Base")
      local spawn=base and base:FindFirstChild("Spawn")
      if spawn then
       local dist=(spawn.Position-root.Position).Magnitude
       if dist<nearestDist and dist<=Steal.StealRadius then
        local att=spawn:FindFirstChild("PromptAttachment")
        if att then
         for _,child in ipairs(att:GetChildren()) do
          if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
           nearestPrompt=child
           nearestDist=dist
           nearestName=pod.Name
           break
          end
         end
        end
       end
      end
     end)
    end
   end
  end
 end
 return nearestPrompt,nearestName
end
local function executeSteal(prompt,podName)
 if isStealing then return end
 if not Steal.Data[prompt] then
  Steal.Data[prompt]={hold={},trigger={},ready=true}
  pcall(function()
   if getconnections then
    for _,conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
     if conn.Function then table.insert(Steal.Data[prompt].hold,conn.Function) end
    end
    for _,conn in ipairs(getconnections(prompt.Triggered)) do
     if conn.Function then table.insert(Steal.Data[prompt].trigger,conn.Function) end
    end
   end
  end)
 end
 local data=Steal.Data[prompt]
 if not data.ready then return end
 data.ready=false
 isStealing=true
 if updateStealProgress then pcall(updateStealProgress,0,"STEALING") end
 if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
 if progressPct then progressPct.Text="0%" end
 task.spawn(function()
  for _,f in ipairs(data.hold) do task.spawn(f) end
  local startTime=tick()
  local duration=Steal.StealDuration
  local promptFired=false
  if autoGrabStopEnabled then
   while isStealing and Steal.AutoStealEnabled do
    local elapsed=tick()-startTime
    if elapsed>=autoGrabStopTime then break end
    local prog=math.clamp(elapsed/duration,0,1)
    if updateStealProgress then pcall(updateStealProgress,prog,"STEALING") end
    if progressFill then progressFill.Size=UDim2.new(prog,0,1,0) end
    if progressPct then progressPct.Text=math.floor(prog*100).."%" end
    if not prompt.Parent or not prompt.Parent.Parent then break end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if hrp and (hrp.Position-prompt.Parent.Parent.Position).Magnitude>Steal.StealRadius then break end
    task.wait()
   end
   local stopProgress=math.clamp(autoGrabStopTime/duration,0,1)
   if updateStealProgress then pcall(updateStealProgress,stopProgress,"STEALING") end
   if progressFill then progressFill.Size=UDim2.new(stopProgress,0,1,0) end
   if progressPct then progressPct.Text=math.floor(stopProgress*100).."%" end
   local phase2Timeout=math.max(2.99-autoGrabStopTime-math.max(duration-autoGrabStopTime,0),0.05)
   local phase2Start=tick()
   while isStealing and Steal.AutoStealEnabled do
    if tick()-phase2Start>=phase2Timeout then
     if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
     if progressPct then progressPct.Text="0%" end
     if updateStealProgress then pcall(updateStealProgress,0,"READY") end
     data.ready=true
     isStealing=false
     task.wait()
     local newPrompt,newName=findNearestPrompt()
     if newPrompt then executeSteal(newPrompt,newName) end
     return
    end
    if not prompt.Parent or not prompt.Parent.Parent then
     isStealing=false
     if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
     if progressPct then progressPct.Text="0%" end
     if updateStealProgress then pcall(updateStealProgress,0,"READY") end
     data.ready=true
     return
    end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
     local dist=(hrp.Position-prompt.Parent.Parent.Position).Magnitude
     if dist<=autoGrabSetDelayRadius then
      break
     elseif dist>Steal.StealRadius then
      isStealing=false
      if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
      if progressPct then progressPct.Text="0%" end
      if updateStealProgress then pcall(updateStealProgress,0,"READY") end
      data.ready=true
      return
     end
    end
    task.wait()
   end
   if isStealing and Steal.AutoStealEnabled then
    local fillStart=tick()
    local fillDuration=math.max(duration-autoGrabStopTime,0.05)
    while true do
     local fp=math.clamp((tick()-fillStart)/fillDuration,0,1)
     local total=stopProgress+fp*(1-stopProgress)
     if updateStealProgress then pcall(updateStealProgress,total,"STEALING") end
     if progressFill then progressFill.Size=UDim2.new(total,0,1,0) end
     if progressPct then progressPct.Text=math.floor(total*100).."%" end
     if fp>=1 and not promptFired then
      promptFired=true
      pcall(function()
       for _,f in ipairs(data.trigger) do task.spawn(f) end
       local remote=ReplicatedStorage:FindFirstChild("StealAnimal")
       if remote and podName then remote:FireServer(podName) end
       if prompt then prompt:InputHoldEnd() pcall(function() prompt:Fire() end) end
      end)
      break
     end
     task.wait()
    end
   end
  else
   while isStealing and Steal.AutoStealEnabled do
    local elapsed=tick()-startTime
    local progress=math.clamp(elapsed/duration,0,1)
    if updateStealProgress then pcall(updateStealProgress,progress,"STEALING") end
    if progressFill then progressFill.Size=UDim2.new(progress,0,1,0) end
    if progressPct then progressPct.Text=math.floor(progress*100).."%" end
    if not prompt.Parent or not prompt.Parent.Parent then break end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if hrp and (hrp.Position-prompt.Parent.Parent.Position).Magnitude>Steal.StealRadius then break end
    if elapsed>=duration and not promptFired then
     promptFired=true
     pcall(function()
      for _,f in ipairs(data.trigger) do task.spawn(f) end
      local remote=ReplicatedStorage:FindFirstChild("StealAnimal")
      if remote and podName then remote:FireServer(podName) end
      if prompt then pcall(function() prompt:Fire() end) end
     end)
     break
    end
    task.wait()
   end
  end
  if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
  if progressPct then progressPct.Text="0%" end
  if updateStealProgress then pcall(updateStealProgress,0,"READY") end
  data.ready=true
  isStealing=false
 end)
end
function startAutoSteal()
 if stealConnection then
  local connected=false
  pcall(function() connected=stealConnection.Connected==true end)
  if connected then
   Steal.StealRadius=CONFIG.STEAL_RANGE
   Steal.AutoStealEnabled=true
   CONFIG.AUTO_STEAL_ENABLED=true
   return true
  end
  pcall(function() stealConnection:Disconnect() end)
  stealConnection=nil
 end
 Steal.StealRadius=CONFIG.STEAL_RANGE
 Steal.AutoStealEnabled=true
 CONFIG.AUTO_STEAL_ENABLED=true
 isStealing=false
 stealConnection=RunService.Heartbeat:Connect(function()
  if not Steal.AutoStealEnabled or isStealing then return end
  local p,n=findNearestPrompt()
  if p then executeSteal(p,n) end
 end)
 return true
end
function stopAutoSteal()
 if stealConnection then pcall(function() stealConnection:Disconnect() end) stealConnection=nil end
 _stealRunId=(_stealRunId or 0)+1
 isStealing=false
 _stealLockUntil=0
 Steal.AutoStealEnabled=false
 CONFIG.AUTO_STEAL_ENABLED=false
 for _,data in pairs(Steal.Data) do
  if type(data)=="table" then data.ready=true end
 end
 if updateStealProgress then pcall(updateStealProgress,0,"READY") end
 if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
 if progressPct then progressPct.Text="0%" end
end
medusaDebounce=false medusaLastUsed=0 dropActive=false lastDropTime=0 lastMoveDir=_V3new(0,0,0)origFOV=nil fovEnabled=false fovValue=70 customFovConn=nil _anyKeyListening=false _aimbotConn=nil _prevAutoRotate=nil tpBatConn=nil tpBatPrevAutoRotate=nil tpBatHitCD=false TP_BAT_SWING_CD=0.08 enemySpeedConn=nil movementLoop=nil steppedConn=nil alConn=nil arConn=nil infJumpConn=nil stretchConn=nil stretchFovConn=nil antiLagDescConn=nil medusaResetConns={}dropConnections={}enemySpeedLabels={}Conns={autoSteal=nil,batCounter=nil,anchor={},progress=nil,autoLeft=nil,autoRight=nil}keyButtonRefs={}progressFill=nil progressPct=nil progressStatus=nil progressTween=nil pbFrame=nil speedLabel=nil modeValLbl=nil normalBox,carryBox,laggerBox,lagger2Box,radInput,batSpeedBox,uiScaleBox,stealBarScaleBox=nil,nil,nil,nil,nil,nil,nil,nil modeSelectBtn,dropModeBtnRef=nil,nil autoBatSetVisual,autoLeftSetVisual,autoRightSetVisual,setBatCounterVisual,setMedusaVisual=nil,nil,nil,nil,nil setAntiRagVisual,setUnwalkVisual,setAntiLagVisual,setLockUIVisual,setInstaGrab=nil,nil,nil,nil,nil infJumpSetVisual=nil infJumpModeBtn=nil autoStealModeBtn=nil setAntiDieVisual=nil setAntiBatVisual=nil setAntiFlingVisual=nil setESPVIsual=nil setESPLineVisual=nil mobSetAutoBat,mobSetAutoLeft,mobSetAutoRight,mobSetDropBR,mobSetTpDown,mobSetCarry,mobSetLagger1,mobSetLagger2,mobSetBatV2,mobSetBatTP,mobSetBatAimbot=nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil mobSetFloat=nil autoCarryEnabled=false autoCarryMode="On Pick Up"miniBtn,main,gui=nil,nil,nil MobilePanel=nil showGui=nil hideGui=nil mainUIScale=nil animSelectorLabel=nil pbScale=nil tabButtons=nil colorSelectorLabel=nil GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true,}MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,}BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}AP={L1=_V3new(-476.48,-6.28,92.73),L2=_V3new(-483.12,-4.95,94.80),L_FACE=_V3new(-482.25,-4.96,92.09),R1=_V3new(-476.16,-6.52,25.62),R2=_V3new(-483.06,-5.03,25.48),R_FACE=_V3new(-482.06,-6.93,35.47),}function isGamepadInput(inp)return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end function isBindableInput(inp)if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end if inp.UserInputType==Enum.UserInputType.Keyboard then return true end return isGamepadInput(inp)and GAMEPAD_KEYS[inp.KeyCode]==true end function kbMatch(entry,kc)return kc and(kc==entry.kb or(entry.gp and kc==entry.gp))end function updateStealProgress(value,state)value=_clamp(tonumber(value)or 0,0,1)state=state or(value>0 and"STEALING"or"READY")if progressTween then pcall(function()progressTween:Cancel()end)end if progressFill then local isV2=(stealBarStyle=="V2") local pad=isV2 and 2 or 0 local target=UDim2.new(value,pad>0 and -pad*2 or 0,1,pad>0 and -pad*2 or 0)progressFill.Position=UDim2.new(0,pad,0,pad) local dur=(value<=0.001)and 0.05 or 0.08 progressTween=TS:Create(progressFill,TweenInfo.new(dur,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{Size=target})progressTween:Play()local grad=progressFill:FindFirstChild("FillGrad")local lastState=progressFill:GetAttribute("LastStealState")if lastState~=state then progressFill:SetAttribute("LastStealState",state)if state=="CANCELLED"then progressFill.BackgroundColor3=Color3.fromRGB(49,120,220)if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(64,157,252)),ColorSequenceKeypoint.new(0.50,Color3.fromRGB(48,120,220)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(36,70,190)),})end elseif state=="COMPLETE"then progressFill.BackgroundColor3=Color3.fromRGB(70,255,160)if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(200,255,220)),ColorSequenceKeypoint.new(0.50,Color3.fromRGB(80,255,160)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(30,180,100)),})end else progressFill.BackgroundColor3=Color3.fromRGB(53,130,220)if grad then grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,252,230)),ColorSequenceKeypoint.new(0.15,Color3.fromRGB(89,231,255)),ColorSequenceKeypoint.new(0.40,Color3.fromRGB(58,143,233)),ColorSequenceKeypoint.new(0.70,Color3.fromRGB(50,121,220)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(34,120,220)),})end end end end if progressPct then progressPct.Text=_floor(value*100+0.5).."%"progressPct.TextTransparency=0 end if progressStatus then progressStatus.Text=state if state=="STEALING"then progressStatus.TextColor3=Color3.fromRGB(120,225,255)elseif state=="COMPLETE"then progressStatus.TextColor3=Color3.fromRGB(120,255,190)elseif state=="CANCELLED"then progressStatus.TextColor3=Color3.fromRGB(57,140,229)else progressStatus.TextColor3=Color3.fromRGB(84,220,255)end end if pbFrame then local stroke=pbFrame:FindFirstChild("OuterStroke")if stroke then if state=="STEALING"then stroke.Color=Color3.fromRGB(62,151,245)elseif state=="COMPLETE"then stroke.Color=Color3.fromRGB(90,255,160)elseif state=="CANCELLED"then stroke.Color=Color3.fromRGB(50,123,220)else stroke.Color=Color3.fromRGB(56,137,225)end end end end function resetProgressBar()updateStealProgress(0,"READY")end local function doTpDown()pcall(function()local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if not root then return end local _,yaw=root.CFrame:ToEulerAnglesYXZ()root.CFrame=_CFnew(root.Position.X,-7,root.Position.Z)*CFrame.Angles(0,yaw,0)root.AssemblyLinearVelocity=_V3zero root.AssemblyAngularVelocity=_V3zero end)end _G._VynxRunTPDown=doTpDown _G._VynxTPDownIsAutoOn=function()return false end do local old=rawget(_G,"__RivalHubFloat")if type(old)=="table"then local wasOn=old.running==true or old.conn~=nil old.running=false old.cycleToken=(old.cycleToken or 0)+1 if old.thread then pcall(task.cancel,old.thread);old.thread=nil end if old.conn then pcall(function()old.conn:Disconnect()end);old.conn=nil end if wasOn and type(old.groundTP)=="function"then pcall(old.groundTP)end end end _G.__RivalHubFloat={RISE=17,RATE=55,CYCLE=2.5,PAUSE=0.5,SAMPLE=0.08,PIT_MARGIN=15,conn=nil,thread=nil,running=false,locked=false,targetY=nil,baseY=nil,baseGround=nil,safeValid=false,safeX=0,safeZ=0,safeY=0,cycleToken=0,_params=nil,}function _G.__RivalHubFloat.getHRP()local c=LP.Character if not c then return nil,nil end return c:FindFirstChild("HumanoidRootPart"),c:FindFirstChildOfClass("Humanoid")end function _G.__RivalHubFloat.arm()if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource,"float",true)end end function _G.__RivalHubFloat.release()if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource,"float",false)end end function _G.__RivalHubFloat.findGround(char,hrp)local FLOAT=_G.__RivalHubFloat local params=FLOAT._params if not params then params=RaycastParams.new()params.FilterType=Enum.RaycastFilterType.Exclude params.IgnoreWater=true pcall(function()params.RespectCanCollide=true end)FLOAT._params=params end local filter={char}local plist=_GetPlayersCached()for i=1,#plist do local plr=plist[i]if plr~=LP and plr.Character then filter[#filter+1]=plr.Character end end local half=hrp.Size.Y*0.5 if half<=0 then half=1 end local origin=hrp.Position local startY=origin.Y-half-0.1 for _=1,6 do params.FilterDescendantsInstances=filter local res=Workspace:Raycast(Vector3.new(origin.X,startY,origin.Z),Vector3.new(0,-1000,0),params)if not res then return nil,half end local part=res.Instance if part and part:IsA("BasePart")and part.CanCollide then local model=part:FindFirstAncestorOfClass("Model")if not(model and model:FindFirstChildOfClass("Humanoid"))then return res.Position.Y,half end end if part then filter[#filter+1]=part end startY=res.Position.Y-0.05 end return nil,half end function _G.__RivalHubFloat.isSafeGround(g)local FLOAT=_G.__RivalHubFloat if not g then return false end if FLOAT.baseGround and g<FLOAT.baseGround-FLOAT.PIT_MARGIN then return false end return true end function _G.__RivalHubFloat.groundTP()local FLOAT=_G.__RivalHubFloat local char=LP.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if not hrp or not hum or hum.Health<=0 then return end local pos=hrp.Position local x,z=pos.X,pos.Z local groundY,half pcall(function()groundY,half=FLOAT.findGround(char,hrp)end)local relocated=false if not FLOAT.isSafeGround(groundY)and FLOAT.safeValid then x,z,groundY=FLOAT.safeX,FLOAT.safeZ,FLOAT.safeY relocated=true end local targetY if groundY then half=half or math.max(hrp.Size.Y*0.5,1)local off=half*3 if hum.RigType~=Enum.HumanoidRigType.R6 then off=half+(hum.HipHeight or(half*2))end if off~=off or off<1 or off>12 then off=half*3 end targetY=groundY+off+0.15 elseif FLOAT.baseY then targetY=FLOAT.baseY end if targetY and targetY==targetY and targetY>-400 then pcall(function()if not relocated and pos.Y-targetY<0.5 then hrp.AssemblyLinearVelocity=Vector3.zero return end hrp.CFrame=CFrame.new(x,targetY,z)*hrp.CFrame.Rotation hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero end)end end function _G.__RivalHubFloat.startLoop()local FLOAT=_G.__RivalHubFloat if FLOAT.conn then return end FLOAT.locked=false FLOAT.targetY=nil local char0=LP.Character local root0=char0 and char0:FindFirstChild("HumanoidRootPart")local hum0=char0 and char0:FindFirstChildOfClass("Humanoid")if hum0 then pcall(function()hum0:ChangeState(Enum.HumanoidStateType.Freefall)end)end FLOAT.safeValid=false FLOAT.baseGround=nil if char0 and root0 then local ok,g=pcall(FLOAT.findGround,char0,root0)if ok and g then FLOAT.baseGround=g FLOAT.safeX,FLOAT.safeZ,FLOAT.safeY=root0.Position.X,root0.Position.Z,g FLOAT.safeValid=true end end local cChar,cRoot,cHum=nil,nil,nil local sampleT=0 FLOAT.conn=RunService.Heartbeat:Connect(function(dt)local char=LP.Character if char~=cChar or not cRoot or not cRoot.Parent then cChar=char cRoot=char and char:FindFirstChild("HumanoidRootPart")or nil cHum=char and char:FindFirstChildOfClass("Humanoid")or nil end if not cRoot or not cHum or cHum.Health<=0 then return end local cf=cRoot.CFrame local pos=cf.Position local vel=cRoot.AssemblyLinearVelocity sampleT=sampleT+dt if sampleT>=FLOAT.SAMPLE then sampleT=0 local ok,g=pcall(FLOAT.findGround,cChar,cRoot)if ok and FLOAT.isSafeGround(g)then FLOAT.safeX,FLOAT.safeZ,FLOAT.safeY=pos.X,pos.Z,g FLOAT.safeValid=true elseif ok and FLOAT.safeValid then pos=Vector3.new(FLOAT.safeX,pos.Y,FLOAT.safeZ)vel=Vector3.new(0,vel.Y,0)end end if not FLOAT.targetY then FLOAT.baseY=pos.Y FLOAT.targetY=pos.Y+FLOAT.RISE end local y=FLOAT.targetY if not FLOAT.locked then y=math.min(pos.Y+FLOAT.RATE*dt,FLOAT.targetY)if y>=FLOAT.targetY then FLOAT.locked=true end end cRoot.CFrame=CFrame.new(pos.X,y,pos.Z)*cf.Rotation cRoot.AssemblyLinearVelocity=Vector3.new(vel.X,0,vel.Z)end)end function _G.__RivalHubFloat.stopLoop(tpDown)local FLOAT=_G.__RivalHubFloat if FLOAT.conn then pcall(function()FLOAT.conn:Disconnect()end)FLOAT.conn=nil end if tpDown then pcall(FLOAT.groundTP)end end function _G.__RivalHubFloat.waitGrounded(timeout)local FLOAT=_G.__RivalHubFloat local deadline=os.clock()+(timeout or 3)while os.clock()<deadline do if not FLOAT.running then return end local hrp,hum=FLOAT.getHRP()if not hrp or not hum then return end if hum.Health<=0 then return end if hum.FloorMaterial~=Enum.Material.Air then task.wait(FLOAT.PAUSE)return end RunService.Heartbeat:Wait()end end function _G.__RivalHubFloat.spawnCycle()local FLOAT=_G.__RivalHubFloat if FLOAT.thread then pcall(task.cancel,FLOAT.thread);FLOAT.thread=nil end FLOAT.cycleToken=FLOAT.cycleToken+1 local token=FLOAT.cycleToken FLOAT.thread=task.spawn(function()while FLOAT.running and FLOAT.cycleToken==token do task.wait(FLOAT.CYCLE)if not FLOAT.running or FLOAT.cycleToken~=token then break end FLOAT.stopLoop(true)FLOAT.waitGrounded(3)if not FLOAT.running or FLOAT.cycleToken~=token then break end FLOAT.startLoop()end end)end function _G.__RivalHubFloat.enable()local FLOAT=_G.__RivalHubFloat if FLOAT.running then return end FLOAT.running=true FLOAT.arm()FLOAT.startLoop()FLOAT.spawnCycle()end function _G.__RivalHubFloat.disable()local FLOAT=_G.__RivalHubFloat if not FLOAT.running then return end FLOAT.running=false FLOAT.cycleToken=FLOAT.cycleToken+1 if FLOAT.thread then pcall(task.cancel,FLOAT.thread);FLOAT.thread=nil end FLOAT.stopLoop(true)FLOAT.safeValid=false FLOAT.baseGround=nil FLOAT.release()end function _G.__RivalHubFloatToggle()local F=_G.__RivalHubFloat if F.running then F.disable()else F.enable()end if _G.__RivalHubFloatSetVisual then pcall(_G.__RivalHubFloatSetVisual,F.running)end if mobSetFloat then pcall(mobSetFloat,F.running)end end function _G.__RivalHubFloatIsRunning()return _G.__RivalHubFloat.running==true end do local old=rawget(_G,"__RivalHubAutoCarryStop")if type(old)=="function"then pcall(old)end _G._VynxAutoSpeedRange=tonumber(_G._VynxAutoSpeedRange)or 12 local state={active=false,previous=nil,graceUntil=0,conn=nil}local soft={spots={},nextScan=0,latched=false,held=false,armed=true}local function getFamily()if laggerToggled or laggerCarryToggled then return"lagger"end return"normal"end local function getCarry()return(speedMode==true)or(laggerCarryToggled==true)end local function setFamilyCarry(family,carry)carry=carry==true if family=="lagger"then laggerCarryToggled=carry laggerToggled=not carry speedMode=false else laggerToggled=false laggerCarryToggled=false speedMode=carry end end local function refresh()if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel)end if mobSetCarry then pcall(mobSetCarry,speedMode==true)end if mobSetLagger1 then pcall(mobSetLagger1,laggerToggled==true)end if mobSetLagger2 then pcall(mobSetLagger2,laggerCarryToggled==true)end if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end local function isWeaponName(value)local n=tostring(value or""):lower()return n:find("bat")or n:find("slap")or n:find("medusa")or n:find("head")or n:find("stone")end local function isCarrying(character)if not character then return false end if LP:GetAttribute("Stealing")==true or LP:GetAttribute("AntiKick")==true or character:GetAttribute("Stealing")==true then return true end for _,entry in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"})do local inst=character:FindFirstChild(entry,true)if inst and((inst:IsA("BoolValue")and inst.Value)or(inst:IsA("ObjectValue")and inst.Value)or(inst:IsA("StringValue")and inst.Value~=""))then return true end end for _,child in ipairs(character:GetChildren())do local n=child.Name:lower()if child:IsA("Tool")and not isWeaponName(n)then return true end local bp=child:IsA("Model")and child:FindFirstChildWhichIsA("BasePart",true)local hit if bp then hit=n:find("brainrot")or n:find("animal")or n:find("carry")or n:find("grab")or n:find("steal")or n:find("hold")else hit=bp end if hit then return true end end return false end local function enable()if state.active then state.graceUntil=tick()+0.75 return end state.previous={family=getFamily(),carry=getCarry()}state.active=true state.graceUntil=tick()+0.75 setFamilyCarry(getFamily(),true)refresh()end local function restore()if not state.active then return end local previous=state.previous state.active=false state.previous=nil if previous then setFamilyCarry(previous.family,previous.carry)end refresh()end local function softEnable()if not state.active then state.previous={family=getFamily(),carry=getCarry()}state.active=true end state.graceUntil=tick()+0.75 setFamilyCarry(getFamily(),true)refresh()end local function scanSpots()local spots={}local plots=workspace:FindFirstChild("Plots")if not plots then soft.spots=spots;return end for _,child in ipairs(plots:GetChildren())do local sign=child:FindFirstChild("PlotSign")sign=sign and sign:FindFirstChild("YourBase")if not(sign and sign:IsA("BillboardGui")and sign.Enabled==true)then local pods=child:FindFirstChild("AnimalPodiums")if pods then for _,pod in ipairs(pods:GetChildren())do local base=pod:FindFirstChild("Base")base=base and base:FindFirstChild("Spawn")if base then spots[#spots+1]=base.Position end end end end end soft.spots=spots end local function nearStealSpot(character)local root=character and character:FindFirstChild("HumanoidRootPart")if not root then return false end local range=tonumber(_G._VynxAutoSpeedRange)or 15 local target=_G._VantaStealTargetPos or _G._RaVeStealTargetPos if typeof(target)=="Vector3"and(root.Position-target).Magnitude<=range then return true end local now=tick()if soft.nextScan<=now then soft.nextScan=now+0.5 scanSpots()end for _,spot in ipairs(soft.spots)do if(root.Position-spot).Magnitude<=range then return true end end return false end local function startAutoCarry()if state.conn then state.conn:Disconnect()end state.conn=RunService.RenderStepped:Connect(function()if not autoCarryEnabled then restore();return end local character=LP.Character local humanoid=character and character:FindFirstChildOfClass("Humanoid")if not character or not humanoid or humanoid.Health<=0 then restore();return end if autoCarryMode=="Soft Steal"then local near=nearStealSpot(character)local carrying=isCarrying(character)local away=not near if away then soft.armed=true end if away or getCarry()~=true then soft.latched=false end if near and soft.armed and not soft.latched then soft.latched=true soft.held=false softEnable()end if state.active then if carrying then soft.held=true state.graceUntil=tick()+0.75 elseif soft.held then soft.held=false soft.latched=false soft.armed=false restore()else local away2=not near if away2 then away2=tick()>state.graceUntil end if away2 then soft.latched=false restore()end end end return end if isCarrying(character)then enable()elseif state.active then restore()end end)end local function stopAutoCarry()if state.conn then state.conn:Disconnect()state.conn=nil end soft.latched=false soft.held=false soft.armed=true restore()end local charConn=LP.CharacterAdded:Connect(function()soft.latched=false soft.held=false soft.armed=true end)_G.__RivalHubAutoCarryStop=function()stopAutoCarry()pcall(function()charConn:Disconnect()end)end _G.__RivalHubAutoCarryRestore=restore startAutoCarry()end local AntiRagdollV1={}AntiRagdollV1.__index=AntiRagdollV1 local BOOST_SPEED=400 local AR_DEFAULT_SPEED=16 local stateV1={active=false,isBoosting=false,cachedChar=nil,ragdollConnections={},}local function disconnectAllV1()for _,conn in ipairs(stateV1.ragdollConnections)do pcall(function()conn:Disconnect()end)end stateV1.ragdollConnections={}end local function cacheCharacterV1()local char=LP.Character if not char then return false end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum or not root then return false end stateV1.cachedChar={character=char,humanoid=hum,root=root}return true end local function isRagdolledV1()if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end local hum=stateV1.cachedChar.humanoid local st=hum:GetState()local ragdollStates={[Enum.HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=true,}return ragdollStates[st]or false end local function forceExitRagdollV1()if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end local hum=stateV1.cachedChar.humanoid local root=stateV1.cachedChar.root pcall(function()LP:SetAttribute("RagdollEndTime",workspace:GetServerTimeNow())end)for _,descendant in ipairs(stateV1.cachedChar.character:GetDescendants())do if descendant:IsA("BallSocketConstraint")or(descendant:IsA("Attachment")and descendant.Name:find("RagdollAttachment"))then descendant:Destroy()end end if not stateV1.isBoosting then stateV1.isBoosting=true hum.WalkSpeed=BOOST_SPEED end if hum.Health>0 then hum:ChangeState(Enum.HumanoidStateType.Running)end root.Anchored=false end local function heartbeatLoopV1()while stateV1.active do task.wait(0.05)local ok,err=pcall(function()local current=LP.Character if not current then return end if not stateV1.cachedChar or stateV1.cachedChar.character~=current or not stateV1.cachedChar.character.Parent or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.humanoid.Parent or not stateV1.cachedChar.root or not stateV1.cachedChar.root.Parent then stateV1.isBoosting=false if not cacheCharacterV1()then return end end local hum=stateV1.cachedChar and stateV1.cachedChar.humanoid if not hum or hum.Health<=0 then return end if isRagdolledV1()then forceExitRagdollV1()elseif stateV1.isBoosting then stateV1.isBoosting=false if hum and hum.Parent then pcall(function()hum.WalkSpeed=AR_DEFAULT_SPEED end)end end end)if not ok then warn("[AntiRagdollV1] boucle récupérée après erreur: "..tostring(err))end end end function AntiRagdollV1.start()if stateV1.active then if not stateV1.cachedChar or stateV1.cachedChar.character~=LP.Character or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.humanoid.Parent then cacheCharacterV1()end return end AntiRagdollV1.stop()stateV1.active=true stateV1.isBoosting=false if not cacheCharacterV1()then task.spawn(function()local deadline=_tick()+15 while stateV1.active and _tick()<deadline do if cacheCharacterV1()then break end task.wait(0.1)end end)end local camConn=RunService.RenderStepped:Connect(function()local cam=workspace.CurrentCamera if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid and stateV1.cachedChar.humanoid.Parent then cam.CameraSubject=stateV1.cachedChar.humanoid end end)table.insert(stateV1.ragdollConnections,camConn)local respawnConn=LP.CharacterAdded:Connect(function()stateV1.isBoosting=false task.spawn(function()local deadline=_tick()+8 while stateV1.active and _tick()<deadline do if cacheCharacterV1()then break end task.wait(0.1)end end)end)table.insert(stateV1.ragdollConnections,respawnConn)task.spawn(heartbeatLoopV1)print("[AntiRagdollV1] Activado")end function AntiRagdollV1.stop()stateV1.active=false if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then stateV1.cachedChar.humanoid.WalkSpeed=AR_DEFAULT_SPEED end stateV1.isBoosting=false disconnectAllV1()stateV1.cachedChar=nil print("[AntiRagdollV1] Desactivado")end function AntiRagdollV1.isRunning()return stateV1.active end local AntiRagdollV2={Enabled=false,Connection=nil,ResetCooldown=0,}local function startAntiRagdollV2()if AntiRagdollV2.Connection and AntiRagdollV2.Enabled then return end if AntiRagdollV2.Connection then pcall(function()AntiRagdollV2.Connection:Disconnect()end)AntiRagdollV2.Connection=nil end AntiRagdollV2.Enabled=true AntiRagdollV2.Connection=RunService.Heartbeat:Connect(function()if not AntiRagdollV2.Enabled then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum or not root then return end if hum.Health<=0 or hum:GetState()==Enum.HumanoidStateType.Dead then return end local state=hum:GetState()local now=_tick()if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown then if now-AntiRagdollV2.ResetCooldown>0.15 then AntiRagdollV2.ResetCooldown=now pcall(function()if hum:GetState()==Enum.HumanoidStateType.GettingUp then return end if hum.Health<=0 or hum:GetState()==Enum.HumanoidStateType.Dead then return end hum:ChangeState(Enum.HumanoidStateType.GettingUp)root.Velocity=_V3zero root.RotVelocity=_V3zero root.AssemblyLinearVelocity=_V3zero root.AssemblyAngularVelocity=_V3zero for _,obj in ipairs(char:GetDescendants())do if obj:IsA("Motor6D")then obj.Enabled=true end if obj:IsA("Constraint")then obj.Enabled=true end end workspace.CurrentCamera.CameraSubject=hum local PM=LP.PlayerScripts:FindFirstChild("PlayerModule")if PM then local CM=require(PM:FindFirstChild("ControlModule"))if CM then CM:Enable()end end hum.AutoRotate=true hum.PlatformStand=false hum.Sit=false end)end end end)end local function stopAntiRagdollV2()AntiRagdollV2.Enabled=false if AntiRagdollV2.Connection then AntiRagdollV2.Connection:Disconnect()AntiRagdollV2.Connection=nil end AntiRagdollV2.ResetCooldown=0 end function setAntiRagdollMode(mode)if AntiRagdollV1.isRunning()then AntiRagdollV1.stop()end if AntiRagdollV2.Enabled then stopAntiRagdollV2()end antiRagdollMode=mode if mode=="v1"then AntiRagdollV1.start()elseif mode=="v2"then startAntiRagdollV2()end if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(mode)end saveAllSettings()end _antiDieEnabled=false _antiDieStopped=false _antiDieSources={toggle=false,autobat=false,float=false}_antiDie={enabled=false,loop=nil,healthConn=nil,charConn=nil,lastHealTime=0,invincibleUntil=0,config={healthThreshold=50,invincibilityFrames=0.75,fallDamageProtection=false,ragdollProtection=true,autoRevive=true,},}function _antiDie.SuperHeal(hum)if not hum or not hum.Parent then return end local maxHealth=hum.MaxHealth or 100 if maxHealth<=0 or maxHealth==math.huge then maxHealth=100 end pcall(function()hum.Health=maxHealth if hum.MaxHealth<maxHealth then hum.MaxHealth=maxHealth end end)_antiDie.invincibleUntil=_tick()+_antiDie.config.invincibilityFrames _antiDie.lastHealTime=_tick()pcall(function()local char=hum.Parent if not char then return end for _,child in ipairs(char:GetChildren())do if child:IsA("NumberValue")then local name=child.Name:lower()if name:find("health")or name:find("hp")or name:find("life")then child.Value=maxHealth end end if child:IsA("BoolValue")and child.Name:lower():find("dead")then child.Value=false end end end)end function _antiDie.PreventDamage(root,hum)if not hum then return end if hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end if _tick()<_antiDie.invincibleUntil then if hum.Health<(hum.MaxHealth or 100)then hum.Health=hum.MaxHealth or 100 end end if _antiDie.config.ragdollProtection then local state=hum:GetState()if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Dead then pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)hum:ChangeState(Enum.HumanoidStateType.Running)end)_antiDie.SuperHeal(hum)if root then pcall(function()root.AssemblyAngularVelocity=Vector3.zero end)end end end if hum.Health<=0 then _antiDie.SuperHeal(hum)pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)hum:ChangeState(Enum.HumanoidStateType.Running)end)if root then pcall(function()root.CFrame=CFrame.new(root.Position+Vector3.new(0,2,0))root.AssemblyLinearVelocity=Vector3.zero end)end end end function _antiDie.AutoRevive()if not _antiDie.config.autoRevive then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum then return end if hum.Health<=0 then _antiDie.SuperHeal(hum)pcall(function()hum:ChangeState(Enum.HumanoidStateType.GettingUp)hum:ChangeState(Enum.HumanoidStateType.Running)end)if root then pcall(function()root.CFrame=CFrame.new(root.Position+Vector3.new(0,3,0))root.AssemblyLinearVelocity=Vector3.zero end)end end end function _antiDie.AttachHealth(char)if _antiDie.healthConn then _antiDie.healthConn:Disconnect();_antiDie.healthConn=nil end local hum=char and char:FindFirstChildOfClass("Humanoid")if not hum then hum=char and char:WaitForChild("Humanoid",3)end if not hum then return end _antiDie.healthConn=hum:GetPropertyChangedSignal("Health"):Connect(function()if not _antiDie.enabled then return end if hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end if hum.Health<=0 then _antiDie.AutoRevive()end end)if hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end end function _antiDie.StartEngine()if _antiDie.enabled and _antiDie.loop then return end _antiDie.enabled=true _antiDieEnabled=true antiDieEnabled=true if _antiDie.loop then _antiDie.loop:Disconnect();_antiDie.loop=nil end if _antiDie.healthConn then _antiDie.healthConn:Disconnect();_antiDie.healthConn=nil end _antiDie.loop=RunService.Heartbeat:Connect(function()if not _antiDie.enabled then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")local root=char:FindFirstChild("HumanoidRootPart")if not hum then return end if hum.Health<=0 then _antiDie.AutoRevive()elseif hum.Health<=_antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)elseif hum.Health<(hum.MaxHealth or 100)then _antiDie.SuperHeal(hum)end _antiDie.PreventDamage(root,hum)end)if LP.Character then _antiDie.AttachHealth(LP.Character)end if _antiDie.charConn then _antiDie.charConn:Disconnect();_antiDie.charConn=nil end _antiDie.charConn=LP.CharacterAdded:Connect(function(char)if not _antiDie.enabled then return end task.wait(0.05)_antiDie.AttachHealth(char)local hum=char:FindFirstChildOfClass("Humanoid")if hum then _antiDie.SuperHeal(hum)end end)end function _antiDie.StopEngine()_antiDie.enabled=false _antiDieEnabled=false antiDieEnabled=false if _antiDie.loop then _antiDie.loop:Disconnect();_antiDie.loop=nil end if _antiDie.healthConn then _antiDie.healthConn:Disconnect();_antiDie.healthConn=nil end if _antiDie.charConn then _antiDie.charConn:Disconnect();_antiDie.charConn=nil end pcall(function()local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if not hum then return end hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true)hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)hum.BreakJointsOnDeath=true if hum.MaxHealth==math.huge or hum.MaxHealth<=0 then hum.MaxHealth=100 hum.Health=math.min(hum.Health,100)end end)end function _antiDieSetEnabled(enabled)enabled=enabled==true if enabled==_antiDieEnabled then return end if enabled then _antiDie.StartEngine()else _antiDie.StopEngine()end end function _antiDieRefresh()if _antiDieStopped then return end local manual=_antiDieSources.toggle _antiDieSetEnabled(manual or _antiDieSources.autobat or _antiDieSources.float)end _G.__CrystalAntiDieSource=function(source,enabled)if _antiDieStopped or _antiDieSources[source]==nil then return end _antiDieSources[source]=enabled==true _antiDieRefresh()end _G.__CrystalAntiDieSet=function(enabled)_G.__CrystalAntiDieSource("autobat",enabled)end _G.__CrystalAntiDieIsEnabled=function()return _antiDieEnabled end _G.__CrystalAntiDieStop=function()_antiDieStopped=true _antiDieSources.toggle=false _antiDieSources.autobat=false _antiDieSetEnabled(false)end function activateOnCharacter(char)if not _antiDieEnabled then return end _antiDie.AttachHealth(char)local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then _antiDie.SuperHeal(hum)end end AntiDieModule={enabled=false,start=function()AntiDieModule.enabled=true antiDieEnabled=true _antiDieStopped=false _G.__CrystalAntiDieSource("toggle",true)end,stop=function()AntiDieModule.enabled=false antiDieEnabled=false _G.__CrystalAntiDieSource("toggle",false)end,}_G.AntiDie=AntiDieModule local AntiBat={Connection=nil}local ANTIBAT_RANGE=4000 function stopAntiBat()antiBatEnabled=false if AntiBat.Connection then AntiBat.Connection:Disconnect()AntiBat.Connection=nil end end function startAntiBat()stopAntiBat()antiBatEnabled=true AntiBat.Connection=RunService.Heartbeat:Connect(function()if not antiBatEnabled then return end local character=LP.Character if not character then return end local hrp=character:FindFirstChild("HumanoidRootPart")if not hrp then return end local v=hrp.Velocity hrp.Velocity=Vector3.new(math.random(-ANTIBAT_RANGE,ANTIBAT_RANGE),v.Y,math.random(-ANTIBAT_RANGE,ANTIBAT_RANGE))RunService.RenderStepped:Wait()if hrp and hrp.Parent then hrp.Velocity=v end end)end LP.CharacterAdded:Connect(function()task.wait(0.3)if antiBatEnabled then startAntiBat()end end)setAntiFlingVisual=nil local _antiFlingState={connection=nil,threshold=80,spinThreshold=40,}local _ANTI_FLING_DRIVE_GRACE=0.3 local function _afHubSpeedLive()local live=_G.__RivalHubLiveSpeed if type(live)~="table"then return false end local stamp,speed=tonumber(live.t),tonumber(live.v)if not stamp or not speed or speed<=0 then return false end return(os.clock()-stamp)<=_ANTI_FLING_DRIVE_GRACE end local function _afOwnMoverActive()if autoBatEnabled then return true end if autoLeftEnabled or autoRightEnabled then return true end return false end function startAntiFling()if _antiFlingState.connection then return end antiFlingEnabled=true _antiFlingState.connection=RunService.Heartbeat:Connect(function()if not antiFlingEnabled then return end local character=LP.Character if not character then return end local root=character:FindFirstChild("HumanoidRootPart")if not root then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if humanoid and(humanoid.Health<=0 or humanoid.SeatPart)then return end if dropActive or _G.IsDropping then return end if _afOwnMoverActive()then return end if _afHubSpeedLive()then return end local velocity=root.AssemblyLinearVelocity local flat=Vector3.new(velocity.X,0,velocity.Z)if flat.Magnitude>_antiFlingState.threshold then pcall(function()root.AssemblyLinearVelocity=Vector3.new(0,velocity.Y,0)root.AssemblyAngularVelocity=Vector3.zero end)return end if root.AssemblyAngularVelocity.Magnitude>_antiFlingState.spinThreshold then pcall(function()root.AssemblyAngularVelocity=Vector3.zero end)end end)end function stopAntiFling()antiFlingEnabled=false if _antiFlingState.connection then _antiFlingState.connection:Disconnect()_antiFlingState.connection=nil end end LP.CharacterAdded:Connect(function()task.wait(0.3)if antiFlingEnabled then startAntiFling()end end)local espEnabled=espEnabled or false local espActivePlayers={}local espLoopConn=nil local Camera=workspace.CurrentCamera local GUI2_ESP_COLOR=Color3.fromRGB(139,72,246)local GUI2_ESP_TEXT_STROKE=Color3.fromRGB(48,16,92)local function getESPThemeColors(accent)local c=ESP_BLUE return c,c end local function createESP()local currentFill,currentLine=getESPThemeColors()local esp={Tracer=Drawing and Drawing.new("Line")or nil,Highlight=Instance.new("Highlight"),Lines={},}if esp.Tracer then esp.Tracer.Color=currentLine esp.Tracer.Thickness=3 esp.Tracer.Transparency=1 esp.Tracer.ZIndex=2 end esp.Highlight.Name="RivalHubESP_Highlight"esp.Highlight.FillColor=currentFill esp.Highlight.OutlineColor=Color3.fromRGB(0,0,0)esp.Highlight.FillTransparency=0.12 esp.Highlight.OutlineTransparency=0.18 esp.Highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop local parentGui local ok,robGui=pcall(function()return game:GetService("CoreGui"):FindFirstChild("RobloxGui")end)if ok and robGui then parentGui=robGui else parentGui=LP:FindFirstChildOfClass("PlayerGui")end if not parentGui then parentGui=game:GetService("CoreGui")end pcall(function()esp.Highlight.Parent=parentGui end)local nameBillboard=Instance.new("BillboardGui")nameBillboard.Name="RivalHubESP_Name"nameBillboard.Size=UDim2.new(0,170,0,28)nameBillboard.StudsOffset=Vector3.new(0,1.3,0)nameBillboard.AlwaysOnTop=true nameBillboard.Parent=parentGui local nameLabel=Instance.new("TextLabel")nameLabel.Size=UDim2.new(0,170,0,28)nameLabel.AnchorPoint=Vector2.new(0.5,0)nameLabel.Position=UDim2.new(0.5,0,0,2)nameLabel.BackgroundTransparency=1 nameLabel.Text=""nameLabel.TextColor3=ESP_BLUE nameLabel.TextSize=15 nameLabel.Font=Enum.Font.GothamBold nameLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)nameLabel.TextStrokeTransparency=0 nameLabel.TextXAlignment=Enum.TextXAlignment.Center nameLabel.TextYAlignment=Enum.TextYAlignment.Center nameLabel.ZIndex=5 nameLabel.Parent=nameBillboard local nameOutline=Instance.new("UIStroke")nameOutline.Color=Color3.fromRGB(0,0,0)nameOutline.Thickness=2.2 nameOutline.Transparency=0.12 nameOutline.Parent=nameLabel if Drawing then for i=1,14 do local line=Drawing.new("Line")line.Color=currentLine line.Thickness=2 line.Transparency=1 line.ZIndex=3 table.insert(esp.Lines,line)end end esp.NameTag=nameBillboard esp.NameLabel=nameLabel esp.NameOutline=nameOutline return esp end _G.__RivalHubRefreshESPTheme=function(accent,outlineColor)local fillColor,lineColor=getESPThemeColors(accent)for _,data in pairs(espActivePlayers)do if type(data)=="table"and data.esp then local esp=data.esp if esp.Tracer then pcall(function()esp.Tracer.Color=lineColor end)end if esp.Highlight then esp.Highlight.FillColor=fillColor esp.Highlight.OutlineColor=Color3.fromRGB(0,0,0)end if esp.NameLabel then esp.NameLabel.TextColor3=ESP_BLUE esp.NameLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)end if esp.NameOutline then esp.NameOutline.Color=Color3.fromRGB(0,0,0)end for _,line in ipairs(esp.Lines or{})do pcall(function()line.Color=lineColor end)end end end end local function removeESP(plr)local data=espActivePlayers[plr]if data then if data.esp.Tracer then pcall(function()data.esp.Tracer:Remove()end)end if data.esp.Highlight then pcall(function()data.esp.Highlight:Destroy()end)end if data.esp.NameTag then pcall(function()data.esp.NameTag:Destroy()end)end for _,line in ipairs(data.esp.Lines)do pcall(function()line:Remove()end)end espActivePlayers[plr]=nil end end local function updateESP(plr,esp)if not espEnabled then if esp.Tracer then esp.Tracer.Visible=false end esp.Highlight.Enabled=false for _,line in ipairs(esp.Lines)do line.Visible=false end if esp.NameTag then esp.NameTag.Enabled=false end return end local character=plr.Character local hum=character and character:FindFirstChildOfClass("Humanoid")local trackPart=character and(character:FindFirstChild("HumanoidRootPart")or character.PrimaryPart or character:FindFirstChild("UpperTorso")or character:FindFirstChild("Torso")or character:FindFirstChild("Head"))if character and trackPart and(not hum or hum.Health>0)then esp.Highlight.Adornee=character esp.Highlight.Enabled=espEnabled if esp.Tracer then esp.Tracer.Visible=false end for _,line in ipairs(esp.Lines)do line.Visible=false end if esp.NameTag and esp.NameLabel then pcall(function()esp.NameTag.Adornee=trackPart esp.NameTag.Enabled=espEnabled esp.NameLabel.Text=plr.Name or plr.DisplayName or""esp.NameLabel.TextColor3=ESP_BLUE end)end else if esp.Tracer then esp.Tracer.Visible=false end esp.Highlight.Enabled=false esp.Highlight.Adornee=nil for _,line in ipairs(esp.Lines)do line.Visible=false end if esp.NameTag then esp.NameTag.Enabled=false end end end local function createESPForPlayer(plr)if plr==LP then return end if espActivePlayers[plr]and espActivePlayers[plr].esp then if espActivePlayers[plr].esp.NameTag then pcall(function()espActivePlayers[plr].esp.NameTag.Enabled=espEnabled end)end return end removeESP(plr)local esp=createESP()espActivePlayers[plr]={esp=esp}end local espJoinConn,espLeaveConn local function enableESP()if espEnabled then return end espEnabled=true for _,plr in pairs(Players:GetPlayers())do if plr~=LP then task.spawn(function()createESPForPlayer(plr)end)end end local espAccumulator=0 if espLoopConn then espLoopConn:Disconnect()end espLoopConn=RunService.Heartbeat:Connect(function(dt)espAccumulator=espAccumulator+(dt or 0)if espAccumulator<0.15 then return end espAccumulator=0 for plr,data in pairs(espActivePlayers)do if typeof(plr)=="Instance"and plr:IsA("Player")and data and data.esp then pcall(function()updateESP(plr,data.esp)end)end end end)espJoinConn=Players.PlayerAdded:Connect(function(plr)if not espEnabled or plr==LP then return end task.wait(0.3)createESPForPlayer(plr)end)espLeaveConn=Players.PlayerRemoving:Connect(function(plr)removeESP(plr)end)end local function disableESP()espEnabled=false if espLoopConn then espLoopConn:Disconnect();espLoopConn=nil end if espJoinConn then pcall(function()espJoinConn:Disconnect()end);espJoinConn=nil end if espLeaveConn then pcall(function()espLeaveConn:Disconnect()end);espLeaveConn=nil end for plr in pairs(espActivePlayers)do if typeof(plr)=="Instance"and plr:IsA("Player")and plr~=LP then removeESP(plr)end end end function toggleESP(on)if on then enableESP()else disableESP()end if setESPVIsual then setESPVIsual(on)end end local _espLineGui=nil local _espLineFrame=nil local _espLineOutline=nil local _espLineConn=nil local _espLineState={scanElapsed=math.huge,targetRoot=nil}local function ensureESPLineGui()if _espLineGui and _espLineGui.Parent then return end _espLineGui=Instance.new("ScreenGui")_espLineGui.Name="RivalHubESPLine"_espLineGui.IgnoreGuiInset=true _espLineGui.ResetOnSpawn=false _espLineGui.DisplayOrder=1000 _espLineGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling local okP=pcall(function()_espLineGui.Parent=game:GetService("CoreGui")end)if not okP then _espLineGui.Parent=LP:WaitForChild("PlayerGui")end _espLineFrame=Instance.new("Frame")_espLineFrame.Name="ESPLine"_espLineFrame.AnchorPoint=Vector2.new(0.5,0.5)_espLineFrame.BorderSizePixel=0 _espLineFrame.Active=false _espLineFrame.Visible=false _espLineFrame.BackgroundColor3=ESP_BLUE _espLineFrame.ZIndex=1 _espLineFrame.Parent=_espLineGui _espLineOutline=Instance.new("UIStroke",_espLineFrame)_espLineOutline.Color=Color3.fromRGB(255,255,255)_espLineOutline.Thickness=0.7 _espLineOutline.Transparency=0.45 end function stopESPLine()espLineEnabled=false if _espLineConn then _espLineConn:Disconnect();_espLineConn=nil end if _espLineFrame then _espLineFrame.Visible=false end _espLineState.targetRoot=nil _espLineState.scanElapsed=math.huge if _espLineGui and _espLineGui.Parent then pcall(function()_espLineGui:Destroy()end)end _espLineGui=nil _espLineFrame=nil _espLineOutline=nil end function startESPLine()espLineEnabled=true ensureESPLineGui()if _espLineConn then _espLineConn:Disconnect()end _espLineState.scanElapsed=math.huge _espLineState.targetRoot=nil _espLineConn=RunService.RenderStepped:Connect(function(dt)if not espLineEnabled then if _espLineFrame then _espLineFrame.Visible=false end return end local ok=pcall(function()local activeCamera=workspace.CurrentCamera local myChar=LP.Character local myRoot=myChar and(myChar:FindFirstChild("LowerTorso")or myChar:FindFirstChild("HumanoidRootPart")or myChar:FindFirstChild("Torso"))if not activeCamera or not myRoot then if _espLineFrame then _espLineFrame.Visible=false end return end local myPosition=myRoot.Position _espLineState.scanElapsed=_espLineState.scanElapsed+(dt or 0)local cachedRoot=_espLineState.targetRoot local cachedCharacter=cachedRoot and cachedRoot.Parent local cachedHumanoid=cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")local cachedValid=cachedRoot and cachedRoot.Parent and(not cachedHumanoid or cachedHumanoid.Health>0)if _espLineState.scanElapsed>=0.12 or not cachedValid then _espLineState.scanElapsed=0 local closestRoot,closestDistanceSq=nil,math.huge for _,otherPlayer in ipairs(Players:GetPlayers())do if otherPlayer~=LP then local character=otherPlayer.Character local humanoid=character and character:FindFirstChildOfClass("Humanoid")local root=character and(character:FindFirstChild("HumanoidRootPart")or character:FindFirstChild("LowerTorso")or character:FindFirstChild("Torso"))if root and root:IsA("BasePart")and(not humanoid or humanoid.Health>0)then local delta=root.Position-myPosition local distanceSq=delta:Dot(delta)if distanceSq<closestDistanceSq then closestRoot,closestDistanceSq=root,distanceSq end end end end _espLineState.targetRoot=closestRoot end local closestRoot=_espLineState.targetRoot if not closestRoot or not closestRoot.Parent then if _espLineFrame then _espLineFrame.Visible=false end return end local closestPosition=closestRoot.Position local from=activeCamera:WorldToViewportPoint(myPosition-Vector3.new(0,myRoot.Size.Y*0.35,0))local to,targetOnScreen=activeCamera:WorldToViewportPoint(closestPosition)local viewport=activeCamera.ViewportSize local fromPoint=Vector2.new(from.X,from.Y)local targetPoint=Vector2.new(to.X,to.Y)if not targetOnScreen or to.Z<=0 then local center=viewport*0.5 local direction=targetPoint-center if to.Z<=0 then direction=-direction end if direction.Magnitude<0.001 then direction=Vector2.new(0,-1)end local limit=Vector2.new(math.max(8,center.X-8),math.max(8,center.Y-8))local scaleX=limit.X/math.max(math.abs(direction.X),0.001)local scaleY=limit.Y/math.max(math.abs(direction.Y),0.001)targetPoint=center+direction*math.min(scaleX,scaleY)end if from.Z<=0 or fromPoint.X<0 or fromPoint.X>viewport.X or fromPoint.Y<0 or fromPoint.Y>viewport.Y then fromPoint=Vector2.new(viewport.X*0.5,viewport.Y-8)end local delta=targetPoint-fromPoint local midpoint=(fromPoint+targetPoint)*0.5 _espLineFrame.Position=UDim2.fromOffset(midpoint.X,midpoint.Y)_espLineFrame.Size=UDim2.fromOffset(math.max(delta.Magnitude,1),2)_espLineFrame.Rotation=math.deg(math.atan2(delta.Y,delta.X))_espLineFrame.BackgroundColor3=ESP_BLUE _espLineFrame.Visible=true end)if not ok and _espLineFrame then pcall(function()_espLineFrame.Visible=false end)end end)end ENEMY_SPEED_COLOR=Color3.fromRGB(30,160,255)function _enemySpeedDrop(player)local old=enemySpeedLabels[player]enemySpeedLabels[player]=nil if old then pcall(function()local bb=old.Parent if bb then bb:Destroy()else old:Destroy()end end)end end function updateEnemySpeedLabels()local players=_GetPlayersCached()for i=1,#players do local player=players[i]if player~=LP then local ok=pcall(function()local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")local head=char and char:FindFirstChild("Head")if hrp and hum and head and hum.Health>0 then local label=enemySpeedLabels[player]if label and not(label.Parent and label.Parent.Parent==head)then _enemySpeedDrop(player)label=nil end if not label then local bb=Instance.new("BillboardGui")bb.Name="EnemySpeedGui"bb.Size=UDim2.new(0,100,0,25)bb.StudsOffset=_V3new(0,3.2,0)bb.AlwaysOnTop=true bb.MaxDistance=math.huge bb.ResetOnSpawn=false bb.Adornee=head bb.Parent=head local tl=Instance.new("TextLabel",bb)tl.Size=UDim2.new(1,0,1,0)tl.BackgroundTransparency=1 tl.TextColor3=ENEMY_SPEED_COLOR tl.Font=Enum.Font.GothamBlack tl.TextScaled=true tl.TextStrokeTransparency=0 tl.TextStrokeColor3=Color3.fromRGB(0,0,0)enemySpeedLabels[player]=tl label=tl end local v=hrp.AssemblyLinearVelocity label.Text=string.format("%.1f",_sqrt(v.X*v.X+v.Z*v.Z))if label.TextColor3~=ENEMY_SPEED_COLOR then label.TextColor3=ENEMY_SPEED_COLOR end else _enemySpeedDrop(player)end end)if not ok then _enemySpeedDrop(player)end end end for player in pairs(enemySpeedLabels)do if not player.Parent then _enemySpeedDrop(player)end end end function startEnemySpeed()if enemySpeedConn then enemySpeedConn:Disconnect()end enemySpeedConn=RunService.Heartbeat:Connect(updateEnemySpeedLabels)end function stopEnemySpeed()if enemySpeedConn then enemySpeedConn:Disconnect();enemySpeedConn=nil end for player in pairs(enemySpeedLabels)do _enemySpeedDrop(player)end end local function getClosestTargetBody()local char=LP.Character if not char then return nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil end local rpos=root.Position local closest,minDist=nil,_huge local plist=_GetPlayersCached()for i=1,#plist do local plr=plist[i]if plr~=LP then local c=plr.Character if c then local tRoot=c:FindFirstChild("HumanoidRootPart")if tRoot then local hum=c:FindFirstChildOfClass("Humanoid")if hum and hum.Health>0 then local dx=tRoot.Position.X-rpos.X local dy=tRoot.Position.Y-rpos.Y local dz=tRoot.Position.Z-rpos.Z local d=dx*dx+dy*dy+dz*dz if d<minDist then minDist=d;closest=tRoot end end end end end end return closest end local function _bodyLockTick()local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if not root then return end local hum=char:FindFirstChildOfClass("Humanoid")if not hum then return end local target=getClosestTargetBody()if not target then if not hum.AutoRotate then hum.AutoRotate=true end return end local dist=(target.Position-root.Position).Magnitude if dist>bodyLockRange then if not hum.AutoRotate then hum.AutoRotate=true end return end if hum.AutoRotate then hum.AutoRotate=false end local targetVel=target.AssemblyLinearVelocity local speed3=targetVel.Magnitude local predictTime=_clamp(speed3/80,0.08,0.35)local predictedPos=target.Position+targetVel*predictTime local targetHead=target.Parent and target.Parent:FindFirstChild("Head")local targetHeight=targetHead and targetHead.Position.Y or target.Position.Y local myHeight=root.Position.Y+(hum.HipHeight or 0)local heightDiff=targetHeight-myHeight local verticalCorrection=_clamp(heightDiff*0.15,-1.5,1.5)local flatTarget=_V3new(predictedPos.X,root.Position.Y+verticalCorrection,predictedPos.Z)local toPredict=flatTarget-root.Position if toPredict.Magnitude>0.1 then local goalCF=_CFlookAt(root.Position,flatTarget)local diffCF=root.CFrame:Inverse()*goalCF local _,ry,_=diffCF:ToEulerAnglesXYZ()ry=_clamp(ry,-2.5,2.5)root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(_V3new(0,ry*42,0))end end function startBodyLock()if _bodyLockConn then _bodyLockConn:Disconnect()end local acc=0 _bodyLockConn=RunService.Heartbeat:Connect(function(dt)if not bodyLockEnabled then return end if _blSuppressCount>0 then return end acc=acc+dt if acc<0.033 then return end acc=0 _bodyLockTick()end)end function stopBodyLock()if _bodyLockConn then _bodyLockConn:Disconnect()_bodyLockConn=nil end local c=LP.Character local root=c and c:FindFirstChild("HumanoidRootPart")if root then root.AssemblyAngularVelocity=_V3zero root.AssemblyLinearVelocity=_V3new(root.AssemblyLinearVelocity.X,-0.1,root.AssemblyLinearVelocity.Z)end local hum2=c and c:FindFirstChildOfClass("Humanoid")if hum2 then hum2.AutoRotate=true end end function _suppressBodyLock()_blSuppressCount=_blSuppressCount+1 if _blSuppressCount==1 and bodyLockEnabled then _blWasEnabled=true stopBodyLock()if bodyLockSetVisual then bodyLockSetVisual(false)end if _blRestoreTimer then task.cancel(_blRestoreTimer)_blRestoreTimer=nil end _blSmoothRestore=false end end function _unsuppressBodyLock(delayed)if _blSuppressCount>0 then _blSuppressCount=_blSuppressCount-1 end if _blSuppressCount==0 and _blWasEnabled then _blWasEnabled=false if _blRestoreTimer then pcall(task.cancel,_blRestoreTimer)_blRestoreTimer=nil end local function restore()_blRestoreTimer=nil if bodyLockEnabled then _blSmoothRestore=true startBodyLock()if bodyLockSetVisual then bodyLockSetVisual(true)end task.delay(0.5,function()_blSmoothRestore=false end)end end if delayed then _blRestoreTimer=task.delay(1,restore)else restore()end end end function setupSpeedIndicator(char)local head=char:WaitForChild("Head",5)if not head then return end local oldBB=head:FindFirstChild("RivalHubSpeedIndicator")if oldBB then oldBB:Destroy()end local oldDiscord=head:FindFirstChild("DiscordText")if oldDiscord then oldDiscord:Destroy()end local bb=Instance.new("BillboardGui",head)bb.Name="RivalHubSpeedIndicator"bb.Size=UDim2.fromOffset(200,30)bb.StudsOffset=Vector3.new(0,3.2,0)bb.AlwaysOnTop=true bb.LightInfluence=0 bb.MaxDistance=0 speedLabel=Instance.new("TextLabel",bb)speedLabel.Name="SpeedLabel"speedLabel.Size=UDim2.new(1,0,1,0)speedLabel.Position=UDim2.new(0,0,0,0)speedLabel.BackgroundTransparency=1 speedLabel.Text="0.0  -  "..getSpeedModeName()speedLabel.TextColor3=Color3.fromRGB(40,170,255)speedLabel.Font=Enum.Font.GothamBlack speedLabel.TextSize=22 speedLabel.TextXAlignment=Enum.TextXAlignment.Center speedLabel.TextYAlignment=Enum.TextYAlignment.Center speedLabel.TextStrokeTransparency=0 speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)local slStroke=Instance.new("UIStroke",speedLabel)slStroke.Color=Color3.fromRGB(90,215,255)slStroke.Thickness=1.8 slStroke.Transparency=0.05 applyShimmerToText(speedLabel,0.9,Color3.fromRGB(40,170,255))local dbb=Instance.new("BillboardGui",head)dbb.Name="DiscordText"dbb.Size=UDim2.fromOffset(230,28)dbb.StudsOffset=Vector3.new(0,5.0,0)dbb.AlwaysOnTop=true dbb.LightInfluence=0 dbb.MaxDistance=0 local dLabel=Instance.new("TextLabel",dbb)dLabel.Name="DiscordLabel"dLabel.Size=UDim2.new(1,0,1,0)dLabel.BackgroundTransparency=1 dLabel.Text=""dLabel.TextColor3=Color3.fromRGB(235,249,255)dLabel.Font=Enum.Font.GothamBlack dLabel.TextSize=18 dLabel.TextScaled=false dLabel.TextXAlignment=Enum.TextXAlignment.Center dLabel.TextYAlignment=Enum.TextYAlignment.Center dLabel.TextStrokeTransparency=0.45 dLabel.TextStrokeColor3=Color3.fromRGB(35,110,190)applyShimmerToText(dLabel,0.55,Color3.fromRGB(70,175,255))local dGrad=dLabel:FindFirstChildOfClass("UIGradient")if dGrad then dGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.35,Color3.fromRGB(180,230,255)),ColorSequenceKeypoint.new(0.65,Color3.fromRGB(70,175,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(245,252,255))})end task.spawn(function()local fullText=".gg/ZeyHubb.vs" while dLabel.Parent and dbb.Parent do dLabel.Text="" task.wait(0.12) for i=1,#fullText do if not dLabel.Parent then return end dLabel.Text=string.sub(fullText,1,i) task.wait(0.12) end task.wait(3) end end) local bounceTween=TS:Create(dbb,TweenInfo.new(0.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out,-1,true),{StudsOffset=Vector3.new(0,6.2,0)})bounceTween:Play() end local unwalkSavedAnimate=nil function startUnwalk()local c=LP.Character if not c then return end local hum=c:FindFirstChildOfClass("Humanoid")if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks())do pcall(function()t:Stop()end)end end local anim=c:FindFirstChild("Animate")if anim then unwalkSavedAnimate=anim:Clone()anim:Destroy()end end function stopUnwalk()local c=LP.Character if c then local existing=c:FindFirstChild("Animate")if not existing then local src=game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")local starterAnim=src and src:FindFirstChild("Animate")if starterAnim then starterAnim:Clone().Parent=c elseif unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c end end end unwalkSavedAnimate=nil end function refreshSpeedModeLabel()if modeValLbl then if laggerCarryToggled then modeValLbl.Text="Lagger Carry"elseif laggerToggled then modeValLbl.Text="Lagger Normal"elseif speedMode then modeValLbl.Text="Carry"else modeValLbl.Text="Normal"end end if setCarryModeVisual then setCarryModeVisual(speedMode)end if setLaggerModeVisual then setLaggerModeVisual(laggerToggled)end if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled)end end function resetMovementState()refreshSpeedModeLabel()if mobSetCarry then mobSetCarry(speedMode)end if setLaggerModeVisual then setLaggerModeVisual(laggerToggled)end if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled)end end function toggleCarryMode()if laggerToggled or laggerCarryToggled then laggerToggled=false;laggerCarryToggled=false;speedMode=true else speedMode=not speedMode end resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function toggleLaggerMode()if laggerCarryToggled then laggerCarryToggled=false end speedMode=false;laggerToggled=not laggerToggled resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function toggleLaggerCarryMode()if laggerToggled then laggerToggled=false end speedMode=false;laggerCarryToggled=not laggerCarryToggled resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function toggleLaggerCycle()if speedMode then speedMode=false laggerToggled=true laggerCarryToggled=false elseif laggerToggled then speedMode=false laggerToggled=false laggerCarryToggled=true else speedMode=true laggerToggled=false laggerCarryToggled=false end resetMovementState()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end function stopAutoLeft()if alConn then alConn:Disconnect();alConn=nil end alPhase=1 local char=LP.Character if char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:Move(_V3zero,false)end end if autoLeftSetVisual then autoLeftSetVisual(false)end if mobSetAutoLeft then mobSetAutoLeft(false)end _unsuppressBodyLock(true)end function startAutoLeft()if autoRightEnabled then autoRightEnabled=false stopAutoRight()if autoRightSetVisual then autoRightSetVisual(false)end if mobSetAutoRight then mobSetAutoRight(false)end end disableAllAimbots()_suppressBodyLock()if alConn then alConn:Disconnect()end alPhase=1 alConn=RunService.Heartbeat:Connect(function()if not autoLeftEnabled then return end local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if not root or not hum then return end local spd=NS if alPhase==1 then local tgt=_V3new(AP.L1.X,root.Position.Y,AP.L1.Z)if(tgt-root.Position).Magnitude<1 then alPhase=2 local d=AP.L2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)return end local d=AP.L1-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)elseif alPhase==2 then local tgt=_V3new(AP.L2.X,root.Position.Y,AP.L2.Z)if(tgt-root.Position).Magnitude<1 then hum:Move(_V3zero,false)root.AssemblyLinearVelocity=_V3zero autoLeftEnabled=false if alConn then alConn:Disconnect();alConn=nil end alPhase=1 if autoLeftSetVisual then autoLeftSetVisual(false)end if mobSetAutoLeft then mobSetAutoLeft(false)end _unsuppressBodyLock(true)local facePos=_V3new(AP.L_FACE.X,root.Position.Y,AP.L_FACE.Z)if(facePos-root.Position).Magnitude>0.01 then root.CFrame=_CFnew(root.Position,facePos)end return end local d=AP.L2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)end end)end function stopAutoRight()if arConn then arConn:Disconnect();arConn=nil end arPhase=1 local char=LP.Character if char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:Move(_V3zero,false)end end if autoRightSetVisual then autoRightSetVisual(false)end if mobSetAutoRight then mobSetAutoRight(false)end _unsuppressBodyLock(true)end function startAutoRight()if autoLeftEnabled then autoLeftEnabled=false stopAutoLeft()if autoLeftSetVisual then autoLeftSetVisual(false)end if mobSetAutoLeft then mobSetAutoLeft(false)end end disableAllAimbots()_suppressBodyLock()if arConn then arConn:Disconnect()end arPhase=1 arConn=RunService.Heartbeat:Connect(function()if not autoRightEnabled then return end local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if not root or not hum then return end local spd=NS if arPhase==1 then local tgt=_V3new(AP.R1.X,root.Position.Y,AP.R1.Z)if(tgt-root.Position).Magnitude<1 then arPhase=2 local d=AP.R2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)return end local d=AP.R1-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)elseif arPhase==2 then local tgt=_V3new(AP.R2.X,root.Position.Y,AP.R2.Z)if(tgt-root.Position).Magnitude<1 then hum:Move(_V3zero,false)root.AssemblyLinearVelocity=_V3zero autoRightEnabled=false if arConn then arConn:Disconnect();arConn=nil end arPhase=1 if autoRightSetVisual then autoRightSetVisual(false)end if mobSetAutoRight then mobSetAutoRight(false)end _unsuppressBodyLock(true)local facePos=_V3new(AP.R_FACE.X,root.Position.Y,AP.R_FACE.Z)if(facePos-root.Position).Magnitude>0.01 then root.CFrame=_CFnew(root.Position,facePos)end return end local d=AP.R2-root.Position local mv=_V3new(d.X,0,d.Z).Unit hum:Move(mv,false)root.AssemblyLinearVelocity=_V3new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)end end)end function getClosestTarget()local char=LP.Character if not char then return nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil end local rpos=root.Position local closest,minDist=nil,_huge local plist=_GetPlayersCached()for i=1,#plist do local plr=plist[i]if plr~=LP then local c=plr.Character if c then local tRoot=c:FindFirstChild("HumanoidRootPart")if tRoot then local hum=c:FindFirstChildOfClass("Humanoid")if hum and hum.Health>0 then local dx=tRoot.Position.X-rpos.X local dy=tRoot.Position.Y-rpos.Y local dz=tRoot.Position.Z-rpos.Z local d=dx*dx+dy*dy+dz*dz if d<minDist then minDist=d;closest=tRoot end end end end end end return closest end function trySwing()pcall(function()local char=LP.Character if not char then return end local currentTool=char:FindFirstChildOfClass("Tool")if currentTool and not isBatTool(currentTool)then return end local bat=findBat()if bat then if bat.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then pcall(function()hum:EquipTool(bat)end)end end pcall(function()bat:Activate()end)end end)end do local ACTIVATE_DISTANCE=13 local MIN_FOLLOW_DISTANCE=1 local PREDICTION_TIME=0.22 local PREDICT_AHEAD=3 local JUMP_SPEED_BOOST=1.5 local JUMP_THRESHOLD=8 local ACTIVATION_DELAY=0.2 local AIRBORNE_THRESHOLD=0.15 local FLOAT_Y_THRESHOLD=3 local FALLING_THRESHOLD=-8 local RISING_THRESHOLD=8 local VERTICAL_OFFSET_MULTIPLIER=0.15 local JUMPBOOST_Y_THRESHOLD=35 local EXTREME_JUMPBOOST_THRESHOLD=50 local JUMPBOOST_SUSTAINED_TIME=0.15 local MAX_VELOCITY_CHANGE=150 local VELOCITY_SMOOTHING=0.2 local MAX_HORIZONTAL_VELOCITY=80 local ERRATIC_MOVEMENT_THRESHOLD=3 local SERVER_TICKRATE=1/60 local PING_SAMPLE_SIZE=10 local MIN_PING_COMPENSATION=0.03 local MAX_PING_COMPENSATION=0.25 local ACCELERATION_PREDICTION_WEIGHT=0.3 local DIRECTION_CHANGE_DETECTION_TIME=0.12 local QUICK_DIRECTION_CHANGE_MULTIPLIER=1.5 local GRAVITY=196.2 local AIR_CONTROL_FACTOR=0.8 local AERIAL_VELOCITY_DECAY=0.95 local AERIAL_DIRECTION_CHANGE_WEIGHT=0.6 local MIN_AIRBORNE_TIME=0.08 local AERIAL_SMOOTHING=0.15 local STRAFE_DETECTION_THRESHOLD=0.7 local HIGH_JUMP_THRESHOLD=20 local FALLING_SPEED_THRESHOLD=-15 local GRAVITY_PREDICTION_WEIGHT=1.0 local MULTI_JUMP_DETECTION_WINDOW=0.2 local UPWARD_VELOCITY_RESET_THRESHOLD=10 local VERTICAL_POSITION_LEAD=2.5 local FALLING_VERTICAL_LEAD=3.5 local predictionSphere=nil local targetPlayer=nil local lastTargetPos=nil local targetVelocity=Vector3.new(0,0,0)local smoothedVelocity=Vector3.new(0,0,0)local velocityHistory={}local MAX_HISTORY=8 local airborneTime=0 local lastActivationTime=0 local highYVelocityTime=0 local pingHistory={}local currentPing=0.1 local accelerationHistory={}local MAX_ACCEL_HISTORY=4 local lastDirectionChangeTime=0 local previousDirection=nil local wasAirborne=false local aerialVelocityHistory={}local MAX_AERIAL_HISTORY=6 local aerialSmoothVelocity=Vector3.new(0,0,0)local lastYVelocity=0 local peakHeight=0 local groundHeight=0 local lastJumpTime=0 local isMultiJumping=false local verticalVelocityHistory={}local MAX_VERTICAL_HISTORY=5 local function getNearestPlayer()local char=LP.Character if not char then return nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil end local myPos=root.Position local nearestDist=math.huge local nearestPlayer=nil local MAX_TARGET_DISTANCE=250 for _,p in ipairs(Players:GetPlayers())do if p~=LP and p.Character then local otherRoot=p.Character:FindFirstChild("HumanoidRootPart")local otherHum=p.Character:FindFirstChildOfClass("Humanoid")if otherRoot and otherHum and otherHum.Health>0 then local dist=(myPos-otherRoot.Position).Magnitude if dist<=MAX_TARGET_DISTANCE and dist<nearestDist then nearestDist=dist nearestPlayer=p end end end end return nearestPlayer end local function getAverageVelocity()if#velocityHistory==0 then return Vector3.new(0,0,0)end local sum=Vector3.new(0,0,0)for _,vel in ipairs(velocityHistory)do sum=sum+vel end return sum/#velocityHistory end local function getAverageAcceleration()if#accelerationHistory==0 then return Vector3.new(0,0,0)end local sum=Vector3.new(0,0,0)for _,a in ipairs(accelerationHistory)do sum=sum+a end return sum/#accelerationHistory end local function getAverageAerialVelocity()if#aerialVelocityHistory==0 then return Vector3.new(0,0,0)end local sum=Vector3.new(0,0,0)for _,vel in ipairs(aerialVelocityHistory)do sum=sum+Vector3.new(vel.X,0,vel.Z)end return sum/#aerialVelocityHistory end local function getAverageVerticalVelocity()if#verticalVelocityHistory==0 then return 0 end local sum=0 for _,y in ipairs(verticalVelocityHistory)do sum=sum+y end return sum/#verticalVelocityHistory end local function detectMultiJump(currentYVel,wasRising)local t=tick()if lastYVelocity<-5 and currentYVel>UPWARD_VELOCITY_RESET_THRESHOLD then if t-lastJumpTime<MULTI_JUMP_DETECTION_WINDOW then return true end lastJumpTime=t return true end return false end local function isFallingFromHeight(currentPos,yVel)return(currentPos.Y-groundHeight>HIGH_JUMP_THRESHOLD)and yVel<FALLING_SPEED_THRESHOLD end local function isAerialStrafing()if#aerialVelocityHistory<3 then return false end local dc=0 for i=2,#aerialVelocityHistory do local v1=Vector3.new(aerialVelocityHistory[i-1].X,0,aerialVelocityHistory[i-1].Z)local v2=Vector3.new(aerialVelocityHistory[i].X,0,aerialVelocityHistory[i].Z)if v1.Magnitude>3 and v2.Magnitude>3 then if v1.Unit:Dot(v2.Unit)<STRAFE_DETECTION_THRESHOLD then dc=dc+1 end end end return dc>=2 end local function detectDirectionChange(currentVel)local horizontal=Vector3.new(currentVel.X,0,currentVel.Z)if horizontal.Magnitude<5 then return false end if previousDirection then local dot=previousDirection:Dot(horizontal.Unit)if dot<0.5 then local t=tick()if t-lastDirectionChangeTime<DIRECTION_CHANGE_DETECTION_TIME then previousDirection=horizontal.Unit lastDirectionChangeTime=t return true end lastDirectionChangeTime=t end end previousDirection=horizontal.Unit return false end local function isErraticMovement()if#velocityHistory<3 then return false end local changes=0 for i=2,#velocityHistory do local v1=Vector3.new(velocityHistory[i-1].X,0,velocityHistory[i-1].Z)local v2=Vector3.new(velocityHistory[i].X,0,velocityHistory[i].Z)if v1.Magnitude>5 and v2.Magnitude>5 then if v1.Unit:Dot(v2.Unit)<0.3 then changes=changes+1 end end end return changes>=ERRATIC_MOVEMENT_THRESHOLD end local function isInfiniteJumping()if#velocityHistory<3 then return false end local yc=0 for i=2,#velocityHistory do if math.abs(velocityHistory[i].Y-velocityHistory[i-1].Y)>15 then yc=yc+1 end end return yc>=2 end local function isJumpBoostCheat()return math.abs(targetVelocity.Y)>JUMPBOOST_Y_THRESHOLD and highYVelocityTime>JUMPBOOST_SUSTAINED_TIME end local function isExtremeJumpBoost()return math.abs(targetVelocity.Y)>EXTREME_JUMPBOOST_THRESHOLD end local function isFloating()return airborneTime>AIRBORNE_THRESHOLD and math.abs(targetVelocity.Y)>FLOAT_Y_THRESHOLD end local function checkAirborne(targetRoot)local params=RaycastParams.new()params.FilterType=Enum.RaycastFilterType.Exclude params.FilterDescendantsInstances={targetPlayer.Character,LP.Character}local rayResult=workspace:Raycast(targetRoot.Position,Vector3.new(0,-100,0),params)if rayResult then groundHeight=rayResult.Position.Y return false end return true end local function clampVelocityChange(newVel,oldVel,maxChange)local delta=newVel-oldVel if delta.Magnitude>maxChange then return oldVel+(delta.Unit*maxChange)end return newVel end local function smoothVelocity(current,target,alpha)return current:Lerp(target,alpha)end local function predictAerialPosition(currentPos,velocity,dt,isStrafing,isFastFalling,isMultiJump)local horizVel=Vector3.new(velocity.X,0,velocity.Z)local vertVel=velocity.Y if isStrafing then local avgAerial=getAverageAerialVelocity()horizVel=Vector3.new(avgAerial.X,0,avgAerial.Z)*AIR_CONTROL_FACTOR else horizVel=horizVel*AIR_CONTROL_FACTOR end horizVel=horizVel*AERIAL_VELOCITY_DECAY local gravityEffect=GRAVITY*GRAVITY_PREDICTION_WEIGHT if isMultiJump then gravityEffect=gravityEffect*0.3 vertVel=vertVel*0.9 end local verticalDisplacement if isFastFalling then verticalDisplacement=(vertVel*dt)-(0.5*gravityEffect*1.2*dt*dt)-(FALLING_VERTICAL_LEAD*dt)else verticalDisplacement=(vertVel*dt)-(0.5*gravityEffect*dt*dt)end if vertVel>RISING_THRESHOLD and not isMultiJump then verticalDisplacement=verticalDisplacement+(VERTICAL_POSITION_LEAD*dt)end return currentPos+horizVel*dt+Vector3.new(0,verticalDisplacement,0)end local function predictServerPosition(currentPos,velocity,acceleration,ping,isQuickTurn,isAerial,isStrafing,isFastFalling,isMultiJump)local serverDelay=ping+SERVER_TICKRATE if isQuickTurn then serverDelay=serverDelay*QUICK_DIRECTION_CHANGE_MULTIPLIER end if isAerial then return predictAerialPosition(currentPos,velocity,serverDelay,isStrafing,isFastFalling,isMultiJump)end local predictedPos=currentPos+velocity*serverDelay if acceleration.Magnitude>1 then predictedPos=predictedPos+(acceleration*ACCELERATION_PREDICTION_WEIGHT)*(serverDelay*serverDelay*0.5)end return predictedPos end local SPHERE_SMOOTH_SPEED=15 local function createPredictionSphere()if predictionSphere then predictionSphere:Destroy()end predictionSphere=Instance.new("Part")predictionSphere.Name="PredictionSphere"predictionSphere.Shape=Enum.PartType.Ball predictionSphere.Size=Vector3.new(2,2,2)predictionSphere.Anchored=true predictionSphere.CanCollide=false predictionSphere.Material=Enum.Material.Neon predictionSphere.Color=Color3.fromRGB(100,180,255)predictionSphere.Transparency=0.4 local light=Instance.new("PointLight")light.Color=Color3.fromRGB(100,180,255)light.Range=8 light.Brightness=2 light.Parent=predictionSphere predictionSphere.Parent=workspace return predictionSphere end local function updatePredictionSphere(targetPosition,dt)if not predictionSphere then return end local alpha=math.min(1,dt*SPHERE_SMOOTH_SPEED)predictionSphere.CFrame=predictionSphere.CFrame:Lerp(CFrame.new(targetPosition),alpha)end local function updateRotationAngular(lookDirection,rootPart)if not rootPart then return end if lookDirection.Magnitude<0.01 then return end local currentLook=rootPart.CFrame.LookVector local targetDir=lookDirection.Unit local axis=currentLook:Cross(targetDir)local angle=math.asin(math.clamp(axis.Magnitude,-1,1))if axis.Magnitude>0.01 then local rotSpeed=80 rootPart.AssemblyAngularVelocity=axis.Unit*angle*rotSpeed else rootPart.AssemblyAngularVelocity=Vector3.zero end end local circleConnection=nil local circleSafetyConn=nil local function getRivalHubAimbotBat(char)local equipped=char and char:FindFirstChildOfClass("Tool")if equipped then local name=equipped.Name:lower()if name:find("bat",1,true)or name:find("slap",1,true)then return equipped end end local backpack=LP:FindFirstChildOfClass("Backpack")if backpack then for _,tool in ipairs(backpack:GetChildren())do if tool:IsA("Tool")then local name=tool.Name:lower()if name:find("bat",1,true)or name:find("slap",1,true)then return tool end end end end return nil end local function getRivalHubRenderCFrame(root)if not root then return nil end local ok,rendered=pcall(root.GetRenderCFrame,root)return ok and rendered or root.CFrame end local ADAPT_BP_ANG="_AdaptBP_AngV"local ADAPT_BP_ATT="_AdaptBP_Att"local ADAPT_BP_CLEAN={"LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt","AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock",}local ADAPT_BP_SWING_RANGE=12 local adaptBP={equipped=false,target=nil,intendedVelocity=Vector3.zero,angularVelocity=nil,attachment=nil,respawnConn=nil,}_G.__RivalHubBubbleAimbotState=adaptBP local function adaptBPClean(root)if not root then return end pcall(function()for _,n in ipairs(ADAPT_BP_CLEAN)do local c=root:FindFirstChild(n)if c then c:Destroy()end end for _,child in ipairs(root:GetChildren())do if child.Name~=ADAPT_BP_ANG and child.Name~=ADAPT_BP_ATT then local ln=child.Name:lower()if ln:find("lockb")or ln:find("lockangv")or ln:find("batlock")or ln:find("antiaim")or ln:find("velocitylock")then child:Destroy()end end end end)end local function adaptBPEnsureAngular(parent)pcall(function()local a=parent:FindFirstChild(ADAPT_BP_ANG);if a then a:Destroy()end local b=parent:FindFirstChild(ADAPT_BP_ATT);if b then b:Destroy()end end)local att=Instance.new("Attachment")att.Name=ADAPT_BP_ATT att.Parent=parent local angV=Instance.new("AngularVelocity")angV.Name=ADAPT_BP_ANG angV.Attachment0=att angV.RelativeTo=Enum.ActuatorRelativeTo.World angV.MaxTorque=math.huge angV.AngularVelocity=Vector3.zero angV.Parent=parent adaptBP.attachment=att adaptBP.angularVelocity=angV end local function adaptBPRemoveAngular()pcall(function()if adaptBP.angularVelocity and adaptBP.angularVelocity.Parent then adaptBP.angularVelocity:Destroy()end end)pcall(function()if adaptBP.attachment and adaptBP.attachment.Parent then adaptBP.attachment:Destroy()end end)adaptBP.angularVelocity=nil adaptBP.attachment=nil end local function adaptBPFindBat()local char=LP.Character if not char then return nil end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")then local n=child.Name:lower()if n:find("bat")or n:find("slap")then return child end end end local backpack=LP:FindFirstChildOfClass("Backpack")if backpack then for _,child in ipairs(backpack:GetChildren())do if child:IsA("Tool")then local n=child.Name:lower()if n:find("bat")or n:find("slap")then return child end end end end return nil end local function adaptBPNearest(fromRoot)local best,bestDist=nil,math.huge for _,plr in ipairs(Players:GetPlayers())do if plr~=LP and plr.Character then local hrp=plr.Character:FindFirstChild("HumanoidRootPart")local hum=plr.Character:FindFirstChildOfClass("Humanoid")if hrp and hum and hum.Health>0 then local d=(hrp.Position-fromRoot.Position).Magnitude if d<bestDist then bestDist=d;best=hrp end end end end return best,bestDist end startCircleCombat=function()if circleConnection then return end adaptBP.equipped=false adaptBP.target=nil adaptBP.intendedVelocity=Vector3.zero local c0=LP.Character local r0=c0 and c0:FindFirstChild("HumanoidRootPart")if r0 then adaptBPClean(r0)adaptBPEnsureAngular(r0)end circleConnection=RunService.Heartbeat:Connect(function()if not State.bypassBatEnabled then return end local char=LP.Character local humanoid=char and char:FindFirstChildOfClass("Humanoid")local root=char and char:FindFirstChild("HumanoidRootPart")if not root or not humanoid or humanoid.Health<=0 then return end adaptBPClean(root)if not adaptBP.angularVelocity or not adaptBP.angularVelocity.Parent then adaptBPEnsureAngular(root)end if not adaptBP.equipped then adaptBP.equipped=true if not char:FindFirstChildOfClass("Tool")then local b=adaptBPFindBat()if b then pcall(function()humanoid:EquipTool(b)end)end end end local target,dist=adaptBPNearest(root)if not target then adaptBP.target=nil humanoid.AutoRotate=true if adaptBP.angularVelocity then adaptBP.angularVelocity.AngularVelocity=Vector3.zero end return end adaptBP.target=target local aimPos=target.Position+target.CFrame.LookVector*(target.Velocity.Magnitude<0.1 and 1.5 or 5)local delta=aimPos-root.Position local flat=Vector3.new(delta.X,0,delta.Z)humanoid.AutoRotate=false if delta.Magnitude>0.01 and flat.Magnitude>0.01 then local curY=root.Orientation.Y local yawD=(math.deg(math.atan2(-flat.X,-flat.Z))-curY+180)%360-180 local curX=root.Orientation.X local pitchD=(math.deg(math.atan2(delta.Y,flat.Magnitude))-curX+180)%360-180 local rotY=math.clamp(math.rad(yawD)*40,-28,28)local rotX=math.clamp(math.rad(pitchD)*40,-28,28)local yawR=math.rad(root.Orientation.Y)local fwd=Vector3.new(math.cos(yawR),0,-math.sin(yawR))adaptBP.angularVelocity.AngularVelocity=Vector3.new(0,rotY,0)+fwd*rotX else adaptBP.angularVelocity.AngularVelocity=Vector3.zero end local spd=tonumber(State.bypassBatSpeed)or tonumber(BYPASS_AIMBOT_SPEED)or 58 if spd~=spd or spd<=0 or spd==math.huge then spd=58 end adaptBP.intendedVelocity=(flat.Magnitude>0.1 and flat.Unit*spd or Vector3.zero)+(math.abs(delta.Y)>0.8 and Vector3.new(0,math.sign(delta.Y)*spd,0)or Vector3.new(0,-2,0))root.Velocity=adaptBP.intendedVelocity if flat.Magnitude>0.5 then pcall(function()humanoid:Move(flat.Unit,false)end)end if dist<=ADAPT_BP_SWING_RANGE then local bat=char:FindFirstChildOfClass("Tool")if bat and isBatTool and isBatTool(bat)then pcall(function()bat:Activate()local re=bat:FindFirstChildWhichIsA("RemoteEvent")if re then re:FireServer()end end)end end end)circleSafetyConn=RunService.RenderStepped:Connect(function()if not State.bypassBatEnabled then return end local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")if not root then return end local v=root.Velocity if math.abs(v.X)>350 or math.abs(v.Z)>350 then root.Velocity=adaptBP.intendedVelocity end adaptBPClean(root)end)if not adaptBP.respawnConn then adaptBP.respawnConn=LP.CharacterAdded:Connect(function(character)task.wait(0.5)adaptBP.equipped=false adaptBP.target=nil if State.bypassBatEnabled then local root=character:WaitForChild("HumanoidRootPart",5)if root then adaptBPClean(root)adaptBPEnsureAngular(root)end end end)end end stopCircleCombat=function()if circleConnection then circleConnection:Disconnect()circleConnection=nil end if circleSafetyConn then circleSafetyConn:Disconnect()circleSafetyConn=nil end adaptBP.equipped=false adaptBP.target=nil local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if root then pcall(function()root.Velocity=root.Velocity*0.3 end)end if hum then hum.AutoRotate=true end if adaptBP.angularVelocity then pcall(function()adaptBP.angularVelocity.AngularVelocity=Vector3.zero end)end adaptBPRemoveAngular()if root then local a=root:FindFirstChild(ADAPT_BP_ANG);if a then a:Destroy()end local at=root:FindFirstChild(ADAPT_BP_ATT);if at then at:Destroy()end end end end function stopAimbotAdapt()State.bypassBatEnabled=false if stopCircleCombat then pcall(stopCircleCombat)end _aimbotConn=nil local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then hum.AutoRotate=(_prevAutoRotate==nil)and true or _prevAutoRotate hum.PlatformStand=false pcall(function()hum:ChangeState(Enum.HumanoidStateType.Running)end)end if root then root.AssemblyLinearVelocity=_V3new(0,-0.1,0)root.AssemblyAngularVelocity=_V3zero end _prevAutoRotate=nil lastMoveDir=_V3zero _unsuppressBodyLock(true)end function startAimbotAdapt()State.bypassBatSpeed=tonumber(State.bypassBatSpeed)or tonumber(BYPASS_AIMBOT_SPEED)or 60 State.bypassBatEnabled=true _suppressBodyLock()local hum0=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")if hum0 and _prevAutoRotate==nil then _prevAutoRotate=hum0.AutoRotate end startCircleCombat()end function disableAutoBat()autoBatEnabled=false if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end stopAimbotAdapt()if _G.__ZeyHubbStopBypassBatV2 then pcall(_G.__ZeyHubbStopBypassBatV2)end if _G.__ZeyHubbStopBypassBatV3 then pcall(_G.__ZeyHubbStopBypassBatV3)end if BatAura and BatAura.refresh then pcall(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then pcall(_G.__ZeyHubbBatAuraRefresh)end end function enableAutoBat()if autoLeftEnabled then autoLeftEnabled=false if autoLeftSetVisual then autoLeftSetVisual(false)end stopAutoLeft()end if autoRightEnabled then autoRightEnabled=false if autoRightSetVisual then autoRightSetVisual(false)end stopAutoRight()end autoBatEnabled=true if autoBatSetVisual then autoBatSetVisual(true)end if mobSetAutoBat then mobSetAutoBat(true)end local ver=_G.__ZeyHubbBypassBatVersion or"v1" if ver=="v3" then pcall(function()if stopAimbotAdapt then stopAimbotAdapt()end end)pcall(function()if _G.__ZeyHubbStopBypassBatV2 then _G.__ZeyHubbStopBypassBatV2()end end)if _G.__ZeyHubbStartBypassBatV3 then pcall(_G.__ZeyHubbStartBypassBatV3)end elseif ver=="v2" then pcall(function()if stopAimbotAdapt then stopAimbotAdapt()end end)pcall(function()if _G.__ZeyHubbStopBypassBatV3 then _G.__ZeyHubbStopBypassBatV3()end end)if _G.__ZeyHubbStartBypassBatV2 then pcall(_G.__ZeyHubbStartBypassBatV2)end else pcall(function()if _G.__ZeyHubbStopBypassBatV2 then _G.__ZeyHubbStopBypassBatV2()end end)pcall(function()if _G.__ZeyHubbStopBypassBatV3 then _G.__ZeyHubbStopBypassBatV3()end end)startAimbotAdapt()end if BatAura and BatAura.refresh then pcall(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then pcall(_G.__ZeyHubbBatAuraRefresh)end end function findBat()local char=LP.Character if not char then return nil end for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do local t=char:FindFirstChild(name)if t and t:IsA("Tool")then return t end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do local t=bp:FindFirstChild(name)if t and t:IsA("Tool")then local hum=char:FindFirstChildOfClass("Humanoid")if hum then pcall(function()hum:EquipTool(t)end)end return t end end end for _,ch in ipairs(char:GetChildren())do if ch:IsA("Tool")and(ch.Name:lower():find("bat")or ch.Name:lower():find("slap"))then return ch end end return nil end function isBatTool(tool)if not tool then return false end for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do if tool.Name==name then return true end end return tool.Name:lower():find("bat")or tool.Name:lower():find("slap")end function findBatForCounter()local char=LP.Character if not char then return nil end local backpack=LP:FindFirstChildOfClass("Backpack")for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do local tool=char:FindFirstChild(name)or(backpack and backpack:FindFirstChild(name))if tool then return tool end end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")and(child.Name:lower():find("bat")or child.Name:lower():find("slap"))then return child end end if backpack then for _,child in ipairs(backpack:GetChildren())do if child:IsA("Tool")and(child.Name:lower():find("bat")or child.Name:lower():find("slap"))then return child end end end return nil end function swingBatForCounter(bat,character)local humanoid=character:FindFirstChildOfClass("Humanoid")if bat.Parent~=character and humanoid then pcall(function()humanoid:EquipTool(bat)end)task.wait(0.05)end local remote=bat:FindFirstChildOfClass("RemoteEvent")or bat:FindFirstChildOfClass("RemoteFunction")if remote and remote:IsA("RemoteEvent")then pcall(function()remote:FireServer()end)task.wait(0.1)pcall(function()remote:FireServer()end)else pcall(function()bat:Activate()end)task.wait(0.1)pcall(function()bat:Activate()end)end end batCounterDebounce=false function stopBatCounter()if Conns.batCounter then Conns.batCounter:Disconnect()Conns.batCounter=nil end batCounterDebounce=false end function startBatCounter()if Conns.batCounter then return end Conns.batCounter=RunService.Heartbeat:Connect(function()if not batCounterEnabled then return end if batCounterDebounce then return end local character=LP.Character if not character then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid then return end local state=humanoid:GetState()if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown then batCounterDebounce=true _suppressBodyLock()task.spawn(function()task.wait(0.15)local bat=findBatForCounter()if bat then swingBatForCounter(bat,character)end task.wait(0.3)batCounterDebounce=false _unsuppressBodyLock(true)end)end end)end function findMedusa()local c=LP.Character if not c then return nil end for _,t in ipairs(c:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("medusa")or n:find("head")or n:find("stone")then return t end end end local bp=LP:FindFirstChild("Backpack")if bp then for _,t in ipairs(bp:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("medusa")or n:find("head")or n:find("stone")then return t end end end end return nil end function useMedusaCounter()if medusaDebounce then return end if _tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end local c=LP.Character if not c then return end medusaDebounce=true local med=findMedusa()if not med then medusaDebounce=false;return end if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid")if hum2 then hum2:EquipTool(med)end end pcall(function()med:Activate()end)medusaLastUsed=_tick()medusaDebounce=false end function onAnchorChanged(part)return part:GetPropertyChangedSignal("Anchored"):Connect(function()if medusaCounterEnabled and part.Anchored and part.Transparency==1 then useMedusaCounter()end end)end function setupMedusaCounter(char)for _,c in pairs(Conns.anchor)do pcall(function()c:Disconnect()end)end Conns.anchor={}if not char or not medusaCounterEnabled then return end for _,part in ipairs(char:GetDescendants())do if part:IsA("BasePart")then table.insert(Conns.anchor,onAnchorChanged(part))end end table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)if part:IsA("BasePart")then table.insert(Conns.anchor,onAnchorChanged(part))end end))end function stopMedusaCounter()for _,c in pairs(Conns.anchor)do pcall(function()c:Disconnect()end)end Conns.anchor={}end do _G.RivalMedusaSkinAssets={Skull={mesh="rbxassetid://2050312704",tex="rbxassetid://2050313393",scale=Vector3.new(1,1,1),c0=CFrame.new(0,0.65,-0.4)*CFrame.Angles(math.rad(330),0,0),},GoldenDesertEagle={mesh="rbxassetid://430251413",tex="rbxassetid://435840335",scale=Vector3.new(0.01,0.01,0.01),c0=CFrame.new(0,0,-0.8)*CFrame.Angles(math.rad(330),math.rad(180),0),},NeonSkull={mesh="rbxassetid://2050312704",tex="rbxassetid://2050313393",scale=Vector3.new(1.15,1.15,1.15),c0=CFrame.new(0,0.7,-0.35)*CFrame.Angles(math.rad(330),0,0),},Crystal={mesh="rbxassetid://430251413",tex="rbxassetid://435840335",scale=Vector3.new(0.012,0.012,0.012),c0=CFrame.new(0,0.05,-0.75)*CFrame.Angles(math.rad(320),math.rad(180),0),},Bomb={mesh="rbxassetid://2050312704",tex="rbxassetid://2050313393",scale=Vector3.new(0.85,0.85,0.85),c0=CFrame.new(0,0.55,-0.35)*CFrame.Angles(math.rad(340),0,0),},}_G.RivalMedusaSkin=_G.RivalMedusaSkin or"Default"local function isMedusaTool(tool)if not tool or not tool:IsA("Tool")then return false end local n=tool.Name:lower()return(n:find("medusa")or n:find("stone")or n:find("head"))and true or false end local function clearReplica(tool)local handle=tool and tool:FindFirstChild("Handle")if not handle then return end local rep=handle:FindFirstChild("RivalMedusaReplica")if rep then pcall(function()rep:Destroy()end)end for _,d in ipairs(tool:GetDescendants())do if d:GetAttribute("RivalMedusaHidden")~=nil then local orig=d:GetAttribute("RivalMedusaHidden")pcall(function()d.Transparency=orig end)pcall(function()d:SetAttribute("RivalMedusaHidden",nil)end)end end end local function hideOriginal(tool)for _,d in ipairs(tool:GetDescendants())do if(d:IsA("BasePart")or d:IsA("Decal")or d:IsA("Texture"))and not d:FindFirstAncestor("RivalMedusaReplica")and not d:FindFirstAncestor("ShelMedusaBombSkin")then pcall(function()if d:GetAttribute("RivalMedusaHidden")==nil then d:SetAttribute("RivalMedusaHidden",d.Transparency)end d.Transparency=1 end)end end end local function buildReplica(tool,key)local data=_G.RivalMedusaSkinAssets[key]local handle=tool:FindFirstChild("Handle")if not data or not handle then return end local cur=handle:FindFirstChild("RivalMedusaReplica")if cur and cur:GetAttribute("SkinKey")==key then hideOriginal(tool)for _,d in ipairs(cur:GetDescendants())do if d:IsA("BasePart")then if d.Transparency~=0 then d.Transparency=0 end if d.LocalTransparencyModifier~=0 then d.LocalTransparencyModifier=0 end end end return end clearReplica(tool)hideOriginal(tool)local m=Instance.new("Model")m.Name="RivalMedusaReplica"m:SetAttribute("SkinKey",key)local p=Instance.new("Part")p.Name="MainPart"p.CanCollide=false;p.CanQuery=false;p.CanTouch=false p.Massless=true;p.Anchored=false p.Size=Vector3.new(1,1,1)p.Transparency=0 p.Parent=m local mesh=Instance.new("SpecialMesh")mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId=data.mesh mesh.TextureId=data.tex mesh.Scale=data.scale mesh.Parent=p local w=Instance.new("Motor6D")w.Part0=handle w.Part1=p w.C0=data.c0 w.Parent=p m.Parent=handle end function _G.RivalApplyMedusaSkin()local sk=_G.RivalMedusaSkin or"Default"local containers={}if LP.Character then table.insert(containers,LP.Character)end local bp=LP:FindFirstChildOfClass("Backpack")if bp then table.insert(containers,bp)end for _,container in ipairs(containers)do for _,tool in ipairs(container:GetChildren())do if isMedusaTool(tool)then if sk=="Default"then clearReplica(tool)else buildReplica(tool,sk)end end end end end function _G.RivalSetMedusaSkin(choice)if choice~="Default"and not _G.RivalMedusaSkinAssets[choice]then choice="Default"end _G.RivalMedusaSkin=choice pcall(_G.RivalApplyMedusaSkin)if _G.ShelMedusaSkin and _G.ShelMedusaSkin.apply then pcall(_G.ShelMedusaSkin.apply)end if choice~="Default"then pcall(_G.RivalApplyMedusaSkin)end end task.spawn(function()while true do if(_G.RivalMedusaSkin or"Default")~="Default"then pcall(_G.RivalApplyMedusaSkin)end task.wait(0.6)end end)LP.CharacterAdded:Connect(function()task.wait(0.8)pcall(_G.RivalApplyMedusaSkin)end)end local DROP_ASCEND_DURATION=0.2 local DROP_ASCEND_SPEED=150 local _dropConn=nil function stopDropBrainrot()dropActive=false if _dropConn then _dropConn:Disconnect()_dropConn=nil end for _,t in ipairs(dropConnections)do if type(t)=="thread"then pcall(task.cancel,t)elseif type(t)=="RBXScriptConnection"then pcall(t.Disconnect,t)end end dropConnections={}local c=LP.Character if c then local root=c:FindFirstChild("HumanoidRootPart")if root then root.AssemblyLinearVelocity=_V3zero end end if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end end function runDropBrainrot()if dropActive then return end local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if not root or not hum then return end if dropMode==1 then local speedH=0 if root then local vel=root.AssemblyLinearVelocity speedH=_V3new(vel.X,0,vel.Z).Magnitude end local cooldown=(speedH>5)and 0.6 or 0.25 if _tick()-lastDropTime<cooldown then return end lastDropTime=_tick()dropActive=true if dropBrainrotSetVisual then dropBrainrotSetVisual(true)end if mobSetDropBR then mobSetDropBR(true)end local wasAutoBat=false if autoBatEnabled then wasAutoBat=true disableAutoBat()if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end end local function finishDrop(threadRef)if threadRef and dropConnections then for i=#dropConnections,1,-1 do if dropConnections[i]==threadRef then table.remove(dropConnections,i)break end end end dropActive=false local c=LP.Character if c then local r=c:FindFirstChild("HumanoidRootPart")local h=c:FindFirstChildOfClass("Humanoid")if r then r.AssemblyLinearVelocity=_V3zero r.AssemblyAngularVelocity=_V3zero if r.Position.Y<-100 then r.CFrame=_CFnew(r.Position.X,5,r.Position.Z)end local rp=RaycastParams.new()rp.FilterDescendantsInstances={c}rp.FilterType=Enum.RaycastFilterType.Exclude local rr=workspace:Raycast(r.Position,_V3new(0,-2000,0),rp)if rr then local off=(h and h.HipHeight or 2)+(r.Size.Y/2)r.CFrame=_CFnew(r.Position.X,rr.Position.Y+off,r.Position.Z)end if h and h.Health>0 then h:ChangeState(Enum.HumanoidStateType.Running)end end end if wasAutoBat then enableAutoBat()if autoBatSetVisual then autoBatSetVisual(true)end if mobSetAutoBat then mobSetAutoBat(true)end end if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end end local flingThread=nil flingThread=task.spawn(function()local startTime=_tick()while dropActive and(_tick()-startTime)<0.25 do RunService.Heartbeat:Wait()local c=LP.Character local r=c and c:FindFirstChild("HumanoidRootPart")if not r then break end local vel=r.AssemblyLinearVelocity vel=_V3new(0,vel.Y,0)r.AssemblyLinearVelocity=vel*10000+_V3new(0,10000,0)RunService.RenderStepped:Wait()if r and r.Parent then r.AssemblyLinearVelocity=vel end RunService.Stepped:Wait()if r and r.Parent then r.AssemblyLinearVelocity=vel+_V3new(0,0.1,0)end end finishDrop(flingThread)end)table.insert(dropConnections,flingThread)task.delay(0.35,function()if dropActive then finishDrop(flingThread)end end)return end if autoBatEnabled then autoBatEnabled=false if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end if stopAimbotAdapt then stopAimbotAdapt()end end dropActive=true if dropBrainrotSetVisual then dropBrainrotSetVisual(true)end if mobSetDropBR then mobSetDropBR(false)end local t0=_tick()if _dropConn then _dropConn:Disconnect()end _dropConn=RunService.Heartbeat:Connect(function()local r=char and char:FindFirstChild("HumanoidRootPart")if not r then if _dropConn then _dropConn:Disconnect();_dropConn=nil end dropActive=false if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end return end if _tick()-t0>=DROP_ASCEND_DURATION then if _dropConn then _dropConn:Disconnect();_dropConn=nil end local rp=_RayParams_new()rp.FilterDescendantsInstances={char}rp.FilterType=Enum.RaycastFilterType.Exclude local rr=workspace:Raycast(r.Position,_V3new(0,-2000,0),rp)if rr then local hum2=char:FindFirstChildOfClass("Humanoid")local off=((hum2 and hum2.HipHeight)or 2)+(r.Size.Y/2)r.CFrame=_CFnew(r.Position.X,rr.Position.Y+off,r.Position.Z)r.AssemblyLinearVelocity=_V3zero end dropActive=false if dropBrainrotSetVisual then dropBrainrotSetVisual(false)end if mobSetDropBR then mobSetDropBR(false)end return end r.Velocity=_V3new(r.Velocity.X,DROP_ASCEND_SPEED,r.Velocity.Z)end)end function executeDropWithToggle(setVisual)if dropActive then return end task.spawn(function()if setVisual then setVisual(true)end runDropBrainrot()while dropActive do task.wait()end task.wait(0.1)if setVisual then setVisual(false)end end)end local _alSaved=setmetatable({},{__mode="k"})local _alDetached={}local _alAnimators=setmetatable({},{__mode="k"})local _alStoppedTracks=setmetatable({},{__mode="k"})local _alGeneration=0 local _alScanCancel=nil local _alConns={}local _alLightOrig=nil local _alRunning=false local AL_LOW_FLAGS={{"DFIntClusterSenderMaxJoinBandwidthBps","2100000000"},{"DFIntClusterSenderMaxUpdateBandwidthBps","2100000000"},{"DFIntServerFramesBetweenJoins","1"},{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2","10000"},{"DFIntConnectionMTUSize","1400"},{"FIntRakNetResendBufferArrayLength","1024"},{"DFIntRakNetNakResendDelayMsMax","1"},{"DFIntWaitOnUpdateNetworkLoopEndedMS","100"},{"DFIntWaitOnRecvFromLoopEndedMS","100"},{"DFIntLargePacketQueueSizeCutoffMB","1000"},{"DFIntSendRakNetStatsInterval","2147483647"},{"DFIntRakNetLoopMs","1"},{"DFIntRakNetSelectTimeoutMs","1"},{"DFIntNetworkClusterPacketCacheNumParallelTasks","8"},{"DFIntReplicationDataCacheNumParallelTasks","8"},{"DFIntMegaReplicatorNumParallelTasks","16"},{"DFIntMaxProcessPacketsStepsPerCyclic","512"},{"DFIntMaxProcessPacketsStepsAccumulated","0"},{"DFIntMaxProcessPacketsJobScaling","1000"},{"DFIntClientPacketMaxFrameMicroseconds","200000"},{"DFIntClientPacketExcessMicroseconds","10000"},{"DFIntClientPacketMinMicroseconds","1"},{"DFIntClientPacketMaxDelayMs","1"},{"DFIntMaxWaitTimeBeforeForcePacketProcessMS","1"},{"DFIntMaxFrameBufferSize","4"},{"DFIntBufferCompressionThreshold","100"},{"DFIntOverrideISRReplicatorStepBandwidthBytes","131072"},{"DFIntTaskSchedulerJobInitThreads","8"},{"DFIntTaskSchedulerJobInGameThreads","8"},{"FIntTaskSchedulerAutoThreadLimit","16"},{"FIntTaskSchedulerAsyncTasksMinimumThreadCount","4"},{"DFIntRuntimeConcurrency","16"},{"FIntSimWorldTaskQueueParallelTasks","20"},{"DFIntHttpBatchLimit","256"},{"FIntHttpBatchLimit","256"},{"DFIntHttpCurlConnectionCacheSize","512"},{"FIntDefaultMeshCacheSizeMB","512"},{"DFIntMemCacheMaxCapacityMB","256"},{"DFIntNumAssetsMaxToPreload","1"},{"DFFlagEnableSoundPreloading","false"},{"FFlagSlimContentProvider","true"},{"DFFlagDebugSkipMeshVoxelizer","true"},{"DFFlagTextureQualityOverrideEnabled","true"},{"DFIntTextureQualityOverride","0"},{"FIntDebugTextureManagerSkipMips","7"},{"DFIntDebugLimitMinTextureResolutionWhenSkipMips","8"},{"FFlagTM2SkipMipsForUnstreamable2","true"},{"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS","true"},{"FFlagRenderUseTextureManager224","false"},{"DFIntDebugFRMQualityLevelOverride","1"},{"DFFlagDebugPauseVoxelizer","true"},{"FFlagFastGPULightCulling3","true"},{"FIntRenderLocalLightFadeInMs","0"},{"FIntRenderLocalLightUpdatesMax","1"},{"FIntRenderShadowmapBias","0"},{"FIntSSAOMipLevels","0"},{"FIntDebugForceMSAASamples","1"},{"FIntDebugFRMOptionalMSAALevelOverride","0"},{"FIntRobloxGuiBlurIntensity","0"},{"FIntFRMMinGrassDistance","0"},{"FIntFRMMaxGrassDistance","0"},{"DFFlagCoreScriptTelemetry2","false"},{"DFFlagBrowserTrackerIdTelemetryEnabled","false"},{"FFlagPerfDataOnTelemetryV2","false"},{"FFlagSendRenderFidelityTelemetry2","false"},{"FFlagEnableTelemetryServiceMemoryCPUInfo","false"},{"DFIntTelemetryProfilerHundredthsPercentage","0"},{"FIntTelemetryProfilerFrequency","0"},{"FIntPerformanceTelemetryQueueProcessLimit","0"},{"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage","0"},}local function _alApplyLowFlags()local env=(getgenv and getgenv())or _G local setter=rawget(env,"setfflag")or rawget(_G,"set_fflag")local getter=rawget(env,"getfflag")or rawget(_G,"get_fflag")if type(setter)~="function"then return end for _,flag in ipairs(AL_LOW_FLAGS)do local canSet=true if type(getter)=="function"then local ok,current=pcall(getter,flag[1])canSet=ok and current~=nil end if canSet then pcall(setter,flag[1],tostring(flag[2]))end end end local function _alSaveLighting()if _alLightOrig then return end _alLightOrig={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,OutdoorAmbient=Lighting.OutdoorAmbient,Ambient=Lighting.Ambient,GlobalShadows=Lighting.GlobalShadows,EnvironmentDiffuseScale=Lighting.EnvironmentDiffuseScale,EnvironmentSpecularScale=Lighting.EnvironmentSpecularScale,FogStart=Lighting.FogStart,FogEnd=Lighting.FogEnd,}end local function _alApplyLowPermanentSettings()pcall(function()settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)pcall(function()UserSettings():GetService("UserGameSettings").SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1 end)pcall(function()Lighting.GlobalShadows=false Lighting.EnvironmentDiffuseScale=0.35 Lighting.EnvironmentSpecularScale=0.35 Lighting.FogStart=0 Lighting.FogEnd=1e10 Lighting.Brightness=math.max(tonumber(Lighting.Brightness)or 2,2.5)local amb=Lighting.Ambient local out=Lighting.OutdoorAmbient Lighting.Ambient=Color3.fromRGB(math.clamp(amb.R*255*0.9+35,0,255),math.clamp(amb.G*255*0.9+35,0,255),math.clamp(amb.B*255*0.9+35,0,255))Lighting.OutdoorAmbient=Color3.fromRGB(math.clamp(out.R*255*0.9+40,0,255),math.clamp(out.G*255*0.9+40,0,255),math.clamp(out.B*255*0.9+40,0,255))end)pcall(function()local atmosphere=Lighting:FindFirstChildOfClass("Atmosphere")if atmosphere then atmosphere.Density=0 atmosphere.Glare=0 atmosphere.Haze=0 end end)pcall(function()local terrain=workspace:FindFirstChildOfClass("Terrain")if terrain then terrain.Decoration=false terrain.WaterWaveSize=0 terrain.WaterWaveSpeed=0 terrain.WaterReflectance=0 local clouds=terrain:FindFirstChildOfClass("Clouds")if clouds then clouds.Enabled=false end end end)end local function _alChange(object,property,value)pcall(function()local original=object[property]if original==value then return end object[property]=value local bucket=_alSaved[object]if not bucket then bucket={};_alSaved[object]=bucket end if not bucket[property]then bucket[property]={value=original}end end)end local function _alIsProtectedVisual(object)local char=LP.Character if char and(object==char or object:IsDescendantOf(char))then return true end if object:GetAttribute("_AdaptDuelsSky")==true then return true end local parent=object while parent and parent~=workspace do if parent:IsA("LayerCollector")or parent:IsA("GuiObject")or parent:IsA("GuiBase2d")then return true end local name=parent.Name or""if name:match("^Crystal")or name:match("^Eclipse")or name:match("^ESP_")or name:match("^BloodHounds")or name:match("^RivalHub")then return true end parent=parent.Parent end return false end function applyAntiLagDerender(obj)pcall(function()if not _alRunning then return end if _alIsProtectedVisual(obj)then return end if obj:IsA("Terrain")then _alChange(obj,"Decoration",false)_alChange(obj,"WaterWaveSize",0)_alChange(obj,"WaterWaveSpeed",0)_alChange(obj,"WaterReflectance",0)_alChange(obj,"WaterTransparency",1)end if obj:IsA("BasePart")then _alChange(obj,"Material",Enum.Material.Plastic)_alChange(obj,"MaterialVariant","")_alChange(obj,"Reflectance",0)_alChange(obj,"CastShadow",false)if obj:IsA("MeshPart")then _alChange(obj,"TextureID","")_alChange(obj,"RenderFidelity",Enum.RenderFidelity.Performance)_alChange(obj,"DoubleSided",false)elseif obj:IsA("PartOperation")then _alChange(obj,"RenderFidelity",Enum.RenderFidelity.Performance)end elseif obj:IsA("SpecialMesh")then _alChange(obj,"TextureId","")elseif obj:IsA("SurfaceAppearance")then _alDetached[obj]=true _alChange(obj,"Parent",nil)elseif obj:IsA("Decal")or obj:IsA("Texture")then _alChange(obj,"Transparency",1)_alChange(obj,"Texture","")elseif obj:IsA("ParticleEmitter")then _alChange(obj,"Enabled",false)_alChange(obj,"Rate",0)pcall(function()obj:Clear()end)elseif obj:IsA("Trail")then _alChange(obj,"Enabled",false)pcall(function()obj:Clear()end)elseif obj:IsA("Beam")or obj:IsA("Fire")or obj:IsA("Smoke")or obj:IsA("Sparkles")or obj:IsA("Light")or obj:IsA("PostEffect")or obj:IsA("Clouds")then _alChange(obj,"Enabled",false)elseif obj:IsA("Atmosphere")then _alChange(obj,"Density",0)_alChange(obj,"Haze",0)_alChange(obj,"Glare",0)elseif obj:IsA("Sky")then for _,face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"})do _alChange(obj,face,"")end _alChange(obj,"StarCount",0)_alChange(obj,"CelestialBodiesShown",false)elseif obj:IsA("Shirt")then _alChange(obj,"ShirtTemplate","")elseif obj:IsA("Pants")then _alChange(obj,"PantsTemplate","")elseif obj:IsA("ShirtGraphic")then _alChange(obj,"Graphic","")elseif obj:IsA("Animator")then if not _alAnimators[obj]then local char=LP.Character if not(char and obj:IsDescendantOf(char))then _alAnimators[obj]=true local token=_alGeneration local ok,conn=pcall(function()return obj.AnimationPlayed:Connect(function(track)if not _alRunning or _alGeneration~=token then return end task.defer(function()if _alRunning and _alGeneration==token then pcall(function()track:Stop(0)end)end end)end)end)if ok then table.insert(_alConns,conn)end pcall(function()for _,track in ipairs(obj:GetPlayingAnimationTracks())do if track.IsPlaying then _alStoppedTracks[track]={animator=obj,time=track.TimePosition,speed=track.Speed,}track:Stop(0)end end end)end end end end)end function enableAntiLag()if _alRunning then return end _alRunning=true antiLagEnabled=true _alGeneration=_alGeneration+1 local token=_alGeneration _alSaveLighting()_alApplyLowFlags()_alApplyLowPermanentSettings()for _,delaySeconds in ipairs({2,6,12,20})do task.delay(delaySeconds,function()if _alRunning and _alGeneration==token then _alApplyLowFlags()end end)end pcall(function()game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()end)table.insert(_alConns,workspace.DescendantAdded:Connect(function(obj)task.defer(function()if _alRunning and _alGeneration==token then pcall(applyAntiLagDerender,obj)end end)end))table.insert(_alConns,Lighting.DescendantAdded:Connect(function(obj)task.defer(function()if _alRunning and _alGeneration==token then pcall(applyAntiLagDerender,obj)end end)end))local function walkBatched(roots,apply,shouldContinue)task.spawn(function()local pending={}for _,root in ipairs(roots)do if root then local ok,children=pcall(function()return root:GetChildren()end)if ok then for _,c in ipairs(children)do table.insert(pending,c)end end end end while#pending>0 and _alRunning and _alGeneration==token and shouldContinue()do local deadline=os.clock()+0.0008 while#pending>0 and os.clock()<deadline do local obj=table.remove(pending)pcall(apply,obj)local ok,children=pcall(function()return obj:GetChildren()end)if ok then for _,c in ipairs(children)do table.insert(pending,c)end end end RunService.Heartbeat:Wait()end end)end walkBatched({workspace,Lighting},applyAntiLagDerender,function()return _alRunning and _alGeneration==token end)end function disableAntiLag()if not _alRunning then antiLagEnabled=false return end _alRunning=false antiLagEnabled=false _alGeneration=_alGeneration+1 if _alScanCancel then pcall(_alScanCancel);_alScanCancel=nil end for _,conn in ipairs(_alConns)do pcall(function()conn:Disconnect()end)end _alConns={}for object,properties in pairs(_alSaved)do for property,original in pairs(properties)do pcall(function()object[property]=original.value end)end end _alSaved=setmetatable({},{__mode="k"})_alDetached={}_alAnimators=setmetatable({},{__mode="k"})for track,state in pairs(_alStoppedTracks)do pcall(function()if state.animator.Parent and not track.IsPlaying then track:Play(0,1,state.speed)track.TimePosition=state.time end end)end _alStoppedTracks=setmetatable({},{__mode="k"})if _alLightOrig then pcall(function()Lighting.Brightness=_alLightOrig.Brightness Lighting.ClockTime=_alLightOrig.ClockTime Lighting.OutdoorAmbient=_alLightOrig.OutdoorAmbient Lighting.Ambient=_alLightOrig.Ambient Lighting.GlobalShadows=_alLightOrig.GlobalShadows Lighting.EnvironmentDiffuseScale=_alLightOrig.EnvironmentDiffuseScale Lighting.EnvironmentSpecularScale=_alLightOrig.EnvironmentSpecularScale Lighting.FogStart=_alLightOrig.FogStart Lighting.FogEnd=_alLightOrig.FogEnd end)_alLightOrig=nil end end function applyStretchFOV(val)local cam=workspace.CurrentCamera if cam then pcall(function()cam.FieldOfView=val end)end end function enableStretch()if stretchConn then return end stretchEnabled=true local cam=workspace.CurrentCamera if not cam then return end origFOV=cam.FieldOfView or 70 applyStretchFOV(stretchFOV)stretchConn=RunService.RenderStepped:Connect(function()if not stretchEnabled then stretchConn:Disconnect()stretchConn=nil return end local c=workspace.CurrentCamera if c then c.CFrame=c.CFrame*_CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1)end end)if stretchFovConn then stretchFovConn:Disconnect()end stretchFovConn=RunService.RenderStepped:Connect(function()if stretchEnabled then applyStretchFOV(stretchFOV)else stretchFovConn:Disconnect();stretchFovConn=nil end end)end function disableStretch()stretchEnabled=false if stretchConn then stretchConn:Disconnect();stretchConn=nil end if stretchFovConn then stretchFovConn:Disconnect();stretchFovConn=nil end local cam=workspace.CurrentCamera if cam then pcall(function()cam.FieldOfView=origFOV or 70 end)end end local function saveLightingState()if _originalLighting then return end _originalLighting={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,OutdoorAmbient=Lighting.OutdoorAmbient,GlobalShadows=Lighting.GlobalShadows,FogEnd=Lighting.FogEnd,FogStart=Lighting.FogStart,FogColor=Lighting.FogColor,Ambient=Lighting.Ambient,ColorCorrection=nil,Bloom=nil,}for _,e in ipairs(Lighting:GetChildren())do if e:IsA("ColorCorrectionEffect")then _originalLighting.ColorCorrection={Enabled=e.Enabled,Brightness=e.Brightness,Contrast=e.Contrast,Saturation=e.Saturation,TintColor=e.TintColor}elseif e:IsA("BloomEffect")then _originalLighting.Bloom={Enabled=e.Enabled,Intensity=e.Intensity,Size=e.Size,Threshold=e.Threshold}end end end local function restoreLightingState()if not _originalLighting then return end local old=_originalLighting Lighting.Brightness=old.Brightness Lighting.ClockTime=old.ClockTime Lighting.OutdoorAmbient=old.OutdoorAmbient Lighting.GlobalShadows=old.GlobalShadows Lighting.FogEnd=old.FogEnd Lighting.FogStart=old.FogStart Lighting.FogColor=old.FogColor Lighting.Ambient=old.Ambient if old.ColorCorrection then local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")if cc then cc.Enabled=old.ColorCorrection.Enabled;cc.Brightness=old.ColorCorrection.Brightness cc.Contrast=old.ColorCorrection.Contrast;cc.Saturation=old.ColorCorrection.Saturation cc.TintColor=old.ColorCorrection.TintColor end end if old.Bloom then local bloom=Lighting:FindFirstChildOfClass("BloomEffect")if bloom then bloom.Enabled=old.Bloom.Enabled;bloom.Intensity=old.Bloom.Intensity bloom.Size=old.Bloom.Size;bloom.Threshold=old.Bloom.Threshold end end end SKY_PRESETS_LIST={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}SKY_PRESETS={["Off"]={kind="off"},["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},}local function _vC3(t)return Color3.fromRGB(t[1],t[2],t[3])end function _v4mpClearSky()for _,child in ipairs(Lighting:GetChildren())do if child:GetAttribute("_AdaptDuelsSky")then pcall(function()child:Destroy()end)end end local terrain=workspace:FindFirstChildOfClass("Terrain")if terrain then for _,child in ipairs(terrain:GetChildren())do if child:GetAttribute("_AdaptDuelsSky")then pcall(function()child:Destroy()end)end end end end function applyCustomSky(mode)_v4mpClearSky()local preset=SKY_PRESETS[mode]if not preset or preset.kind=="off"then Lighting.ClockTime=14 Lighting.Brightness=2 Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127)Lighting.Ambient=Color3.fromRGB(127,127,127)Lighting.FogEnd=100000 Lighting.GlobalShadows=true skyTheme="Off"return end Lighting.FogStart=0 Lighting.FogEnd=100000 Lighting.FogColor=Color3.fromRGB(200,200,200)Lighting.ColorShift_Top=Color3.fromRGB(0,0,0)Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0)Lighting.GlobalShadows=true Lighting.ClockTime=preset.clock or 14 Lighting.Brightness=math.clamp(tonumber(preset.brightness)or 2,1.2,2.8)if preset.outAmb then Lighting.OutdoorAmbient=_vC3(preset.outAmb)end if preset.ambient then Lighting.Ambient=_vC3(preset.ambient)end local amb=Lighting.Ambient local out=Lighting.OutdoorAmbient local function softLift(c,floor)local r=math.clamp(c.R*255*0.92+floor*0.15,0,255)local g=math.clamp(c.G*255*0.92+floor*0.15,0,255)local b=math.clamp(c.B*255*0.92+floor*0.15,0,255)return Color3.fromRGB(r,g,b)end Lighting.Ambient=softLift(amb,40)Lighting.OutdoorAmbient=softLift(out,45)if preset.sky then local skyInst=Instance.new("Sky")skyInst:SetAttribute("_AdaptDuelsSky",true)if preset.sky.stars then skyInst.StarCount=preset.sky.stars end if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg"end skyInst.Parent=Lighting end if preset.atm then local atm=Instance.new("Atmosphere")atm:SetAttribute("_AdaptDuelsSky",true)atm.Density=math.clamp((preset.atm.dens or 0.3)*0.55,0.05,0.45)atm.Color=_vC3(preset.atm.color)atm.Decay=_vC3(preset.atm.decay)atm.Glare=math.clamp((preset.atm.glare or 1)*0.45,0,1.2)atm.Haze=math.clamp((preset.atm.haze or 1)*0.5,0,2)atm.Parent=Lighting end local terrain=workspace:FindFirstChildOfClass("Terrain")if preset.clouds and terrain then local clouds=Instance.new("Clouds")clouds:SetAttribute("_AdaptDuelsSky",true)clouds.Cover=preset.clouds.cover or 0.5 clouds.Density=preset.clouds.dens or 0.5 clouds.Color=_vC3(preset.clouds.color)clouds.Parent=terrain end skyTheme=mode end function enableVividGraphics()if vividGraphicsEnabled and#_vividEffects>0 then return end vividGraphicsEnabled=true for _,eff in ipairs(_vividEffects)do pcall(function()eff:Destroy()end)end _vividEffects={}local color=Instance.new("ColorCorrectionEffect")color.Parent=Lighting color.Saturation=0.6;color.Contrast=0.4;color.Brightness=0.05 color.TintColor=Color3.fromRGB(255,240,220)table.insert(_vividEffects,color)local bloom=Instance.new("BloomEffect")bloom.Parent=Lighting bloom.Intensity=0.8;bloom.Size=24;bloom.Threshold=1 table.insert(_vividEffects,bloom)local atmosphere=Instance.new("Atmosphere")atmosphere.Parent=Lighting atmosphere.Density=0.3;atmosphere.Offset=0.25 atmosphere.Color=Color3.fromRGB(199,199,255)atmosphere.Decay=Color3.fromRGB(106,112,125)atmosphere.Glare=0.2;atmosphere.Haze=1 table.insert(_vividEffects,atmosphere)local sun=Instance.new("SunRaysEffect")sun.Parent=Lighting sun.Intensity=0.2;sun.Spread=0.8 table.insert(_vividEffects,sun)local dof=Instance.new("DepthOfFieldEffect")dof.Parent=Lighting dof.FocusDistance=25;dof.InFocusRadius=10 dof.NearIntensity=0.2;dof.FarIntensity=0.4 table.insert(_vividEffects,dof)task.spawn(function()while vividGraphicsEnabled and color and color.Parent do color.Contrast=0.35+math.sin(tick()*2)*0.05 task.wait(0.03)end end)end function disableVividGraphics()vividGraphicsEnabled=false for _,eff in ipairs(_vividEffects)do pcall(function()eff:Destroy()end)end _vividEffects={}end function toggleVividGraphics(on)if on then enableVividGraphics()else disableVividGraphics()end saveAllSettings(true)end function applyHideButtons(state)hideButtonsEnabled=state applyMobileButtonVisibility()end function toggleHideButtons(on)applyHideButtons(on)if setHideButtonsVisual then setHideButtonsVisual(on)end saveAllSettings(true)end function paintFloatingBtn(btnFrame,active)
if not btnFrame then return end
local style="V9"
local shape=tostring(floatingButtonShape or "V1")
local bg=btnFrame:FindFirstChild("BtnGrad")
local label=btnFrame:FindFirstChild("TextLabel")
local stroke=btnFrame:FindFirstChild("NormalStroke") or btnFrame:FindFirstChildOfClass("UIStroke")
local accent=btnFrame:FindFirstChild("AccentBar")
local corner=btnFrame:FindFirstChildOfClass("UICorner")
btnFrame.ClipsDescendants=true
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
local prevShape=btnFrame:GetAttribute("ZeyHubbBtnShape")
btnFrame.Size=UDim2.new(0,tw,0,th)
if prevShape~=shape then
btnFrame:SetAttribute("ZeyHubbBtnShape",shape)
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
shine.BackgroundColor3=Color3.fromRGB(56,137,225)
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
ColorSequenceKeypoint.new(0.00,Color3.fromRGB(150,235,255)),
ColorSequenceKeypoint.new(0.35,Color3.fromRGB(55,190,255)),
ColorSequenceKeypoint.new(1.00,Color3.fromRGB(30,150,255)),
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
if style=="V1" then
applyGrad(90,Color3.fromRGB(62,151,245),Color3.fromRGB(41,120,220),Color3.fromRGB(50,22,5),Color3.fromRGB(48,48,56),Color3.fromRGB(28,28,34),Color3.fromRGB(12,12,16))
btnFrame.BackgroundColor3=active and Color3.fromRGB(42,120,220) or Color3.fromRGB(28,28,34)
setAccent(active,active and Color3.fromRGB(69,168,255) or Color3.fromRGB(90,90,100))
setLabel(active and Color3.fromRGB(255,245,220) or Color3.fromRGB(200,200,210),Color3.fromRGB(0,0,0),0.55)
elseif style=="V2" then
applyGrad(135,Color3.fromRGB(210,245,255),Color3.fromRGB(60,200,255),Color3.fromRGB(20,10,0),Color3.fromRGB(255,255,255),Color3.fromRGB(230,232,240),Color3.fromRGB(185,190,205))
btnFrame.BackgroundColor3=active and Color3.fromRGB(42,120,220) or Color3.fromRGB(230,232,240)
setAccent(active,active and Color3.fromRGB(92,237,255) or Color3.fromRGB(200,200,210))
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
applyGrad(0,Color3.fromRGB(82,215,255),Color3.fromRGB(120,220,20),Color3.fromRGB(20,40,0),Color3.fromRGB(18,18,18),Color3.fromRGB(10,10,10),Color3.fromRGB(0,0,0))
btnFrame.BackgroundColor3=active and Color3.fromRGB(140,230,20) or Color3.fromRGB(10,10,10)
setAccent(active,active and Color3.fromRGB(88,228,255) or Color3.fromRGB(60,60,60))
setLabel(active and Color3.fromRGB(20,30,0) or Color3.fromRGB(210,210,210),Color3.fromRGB(0,0,0),0.4)
elseif style=="V7" then
applyGrad(90,Color3.fromRGB(65,178,230),Color3.fromRGB(220,30,70),Color3.fromRGB(40,0,10),Color3.fromRGB(48,22,28),Color3.fromRGB(28,12,16),Color3.fromRGB(12,6,8))
btnFrame.BackgroundColor3=active and Color3.fromRGB(36,120,255) or Color3.fromRGB(28,12,16)
setAccent(active,active and Color3.fromRGB(255,180,190) or Color3.fromRGB(100,60,70))
setLabel(active and Color3.fromRGB(255,240,245) or Color3.fromRGB(220,190,195),Color3.fromRGB(40,0,10),0.55)
elseif style=="V8" then
applyGrad(120,Color3.fromRGB(180,160,255),Color3.fromRGB(90,70,255),Color3.fromRGB(20,10,60),Color3.fromRGB(30,28,48),Color3.fromRGB(18,16,30),Color3.fromRGB(8,8,16))
btnFrame.BackgroundColor3=active and Color3.fromRGB(100,80,255) or Color3.fromRGB(18,16,30)
setAccent(active,active and Color3.fromRGB(210,200,255) or Color3.fromRGB(90,85,120))
setLabel(active and Color3.fromRGB(245,245,255) or Color3.fromRGB(200,195,230),Color3.fromRGB(20,10,50),0.55)
elseif style=="V9" then
-- ZeyHubb icy-blue mobile buttons: blue glass when idle, bright cyan when active.
applyGrad(90,Color3.fromRGB(190,248,255),Color3.fromRGB(55,175,255),Color3.fromRGB(12,65,145),Color3.fromRGB(18,42,68),Color3.fromRGB(10,24,44),Color3.fromRGB(4,12,28))
btnFrame.BackgroundColor3=active and Color3.fromRGB(35,155,255) or Color3.fromRGB(10,24,44)
setAccent(active,active and Color3.fromRGB(210,252,255) or Color3.fromRGB(70,175,235))
setLabel(active and Color3.fromRGB(245,255,255) or Color3.fromRGB(180,235,255),Color3.fromRGB(0,45,100),0.45)
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
applyGrad(90,Color3.fromRGB(46,120,220),Color3.fromRGB(36,60,160),Color3.fromRGB(40,0,0),Color3.fromRGB(40,14,12),Color3.fromRGB(22,8,6),Color3.fromRGB(10,4,3))
btnFrame.BackgroundColor3=active and Color3.fromRGB(40,70,170) or Color3.fromRGB(22,8,6)
setAccent(active,active and Color3.fromRGB(61,148,241) or Color3.fromRGB(20,90,190))
setLabel(active and Color3.fromRGB(255,240,235) or Color3.fromRGB(76,201,255),Color3.fromRGB(40,0,0),0.55)
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
applyGrad(90,Color3.fromRGB(70,171,255),Color3.fromRGB(46,120,220),Color3.fromRGB(50,35,0),Color3.fromRGB(44,40,22),Color3.fromRGB(26,24,12),Color3.fromRGB(12,10,6))
btnFrame.BackgroundColor3=active and Color3.fromRGB(47,120,220) or Color3.fromRGB(26,24,12)
setAccent(active,active and Color3.fromRGB(91,235,255) or Color3.fromRGB(110,100,55))
setLabel(active and Color3.fromRGB(40,30,0) or Color3.fromRGB(82,214,255),Color3.fromRGB(0,0,0),0.5)
elseif style=="V16" then
applyGrad(90,Color3.fromRGB(160,255,120),Color3.fromRGB(60,180,30),Color3.fromRGB(10,40,0),Color3.fromRGB(28,40,22),Color3.fromRGB(14,22,10),Color3.fromRGB(6,10,4))
btnFrame.BackgroundColor3=active and Color3.fromRGB(70,190,30) or Color3.fromRGB(14,22,10)
setAccent(active,active and Color3.fromRGB(87,227,255) or Color3.fromRGB(70,100,55))
setLabel(active and Color3.fromRGB(235,255,230) or Color3.fromRGB(190,220,180),Color3.fromRGB(0,25,0),0.55)
elseif style=="V17" then
applyGrad(90,Color3.fromRGB(180,220,255),Color3.fromRGB(100,140,200),Color3.fromRGB(20,30,50),Color3.fromRGB(32,36,48),Color3.fromRGB(18,20,28),Color3.fromRGB(8,10,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(110,150,210) or Color3.fromRGB(18,20,28)
setAccent(active,active and Color3.fromRGB(210,230,255) or Color3.fromRGB(80,90,110))
setLabel(active and Color3.fromRGB(245,250,255) or Color3.fromRGB(190,200,220),Color3.fromRGB(10,15,30),0.55)
elseif style=="V18" then
applyGrad(90,Color3.fromRGB(62,151,245),Color3.fromRGB(33,140,255),Color3.fromRGB(40,10,0),Color3.fromRGB(46,28,18),Color3.fromRGB(28,16,10),Color3.fromRGB(12,6,4))
btnFrame.BackgroundColor3=active and Color3.fromRGB(35,150,255) or Color3.fromRGB(28,16,10)
setAccent(active,active and Color3.fromRGB(81,214,255) or Color3.fromRGB(110,70,45))
setLabel(active and Color3.fromRGB(255,245,235) or Color3.fromRGB(78,205,255),Color3.fromRGB(40,10,0),0.55)
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
applyGrad(90,Color3.fromRGB(53,128,220),Color3.fromRGB(42,120,255),Color3.fromRGB(50,0,0),Color3.fromRGB(40,16,16),Color3.fromRGB(24,8,8),Color3.fromRGB(10,4,4))
btnFrame.BackgroundColor3=active and Color3.fromRGB(42,120,255) or Color3.fromRGB(24,8,8)
setAccent(active,active and Color3.fromRGB(75,199,255) or Color3.fromRGB(110,50,50))
setLabel(active and Color3.fromRGB(255,245,245) or Color3.fromRGB(78,205,255),Color3.fromRGB(40,0,0),0.55)
elseif style=="V22" then
applyGrad(90,Color3.fromRGB(100,255,255),Color3.fromRGB(0,200,220),Color3.fromRGB(0,40,50),Color3.fromRGB(16,40,44),Color3.fromRGB(8,24,26),Color3.fromRGB(4,12,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(0,200,220) or Color3.fromRGB(8,24,26)
setAccent(active,active and Color3.fromRGB(160,255,255) or Color3.fromRGB(50,110,120))
setLabel(active and Color3.fromRGB(230,255,255) or Color3.fromRGB(170,220,225),Color3.fromRGB(0,30,35),0.55)
elseif style=="V23" then
applyGrad(90,Color3.fromRGB(89,230,255),Color3.fromRGB(49,120,220),Color3.fromRGB(40,25,10),Color3.fromRGB(42,34,26),Color3.fromRGB(24,20,14),Color3.fromRGB(12,10,6))
btnFrame.BackgroundColor3=active and Color3.fromRGB(49,120,220) or Color3.fromRGB(24,20,14)
setAccent(active,active and Color3.fromRGB(255,230,190) or Color3.fromRGB(100,85,60))
setLabel(active and Color3.fromRGB(40,25,10) or Color3.fromRGB(80,210,255),Color3.fromRGB(0,0,0),0.5)
elseif style=="V24" then
applyGrad(90,Color3.fromRGB(200,120,255),Color3.fromRGB(120,0,200),Color3.fromRGB(25,0,45),Color3.fromRGB(34,18,48),Color3.fromRGB(20,10,28),Color3.fromRGB(10,4,14))
btnFrame.BackgroundColor3=active and Color3.fromRGB(130,20,210) or Color3.fromRGB(20,10,28)
setAccent(active,active and Color3.fromRGB(220,170,255) or Color3.fromRGB(100,70,120))
setLabel(active and Color3.fromRGB(250,240,255) or Color3.fromRGB(210,190,230),Color3.fromRGB(30,0,50),0.55)
elseif style=="V25" then
applyGrad(90,Color3.fromRGB(79,207,255),Color3.fromRGB(100,200,0),Color3.fromRGB(20,40,0),Color3.fromRGB(28,40,14),Color3.fromRGB(14,22,6),Color3.fromRGB(6,10,2))
btnFrame.BackgroundColor3=active and Color3.fromRGB(120,210,0) or Color3.fromRGB(14,22,6)
setAccent(active,active and Color3.fromRGB(88,229,255) or Color3.fromRGB(80,110,40))
setLabel(active and Color3.fromRGB(20,30,0) or Color3.fromRGB(80,211,255),Color3.fromRGB(0,0,0),0.5)
else
applyGrad(120,Color3.fromRGB(255,120,180),Color3.fromRGB(50,123,220),Color3.fromRGB(40,10,20),Color3.fromRGB(40,24,32),Color3.fromRGB(24,14,18),Color3.fromRGB(12,6,8))
btnFrame.BackgroundColor3=active and Color3.fromRGB(50,123,220) or Color3.fromRGB(24,14,18)
setAccent(active,active and Color3.fromRGB(83,217,255) or Color3.fromRGB(110,70,80))
setLabel(active and Color3.fromRGB(255,245,240) or Color3.fromRGB(220,190,195),Color3.fromRGB(40,10,15),0.55)
end
if stroke then stroke.Transparency=1 stroke.Thickness=0 end
end
function applyFloatingButtonScale()for _,uiScale in ipairs(_floatingUIScales)do if uiScale and uiScale.Parent then uiScale.Scale=floatingButtonScale end end end local function drag(f,dragZoneHeight)local dn,ds,sp,di=false,nil,nil,nil local endConn=nil local zone=dragZoneHeight or 99999 local function stopDrag()local wasDragging=dn dn=false di=nil if endConn then endConn:Disconnect()endConn=nil end if wasDragging then task.defer(function()pcall(saveAllSettings)end)end end f.InputBegan:Connect(function(i)if uiLocked then return end if _isDraggingButton then return end if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local framePos=f.AbsolutePosition if i.Position.Y>framePos.Y+zone then return end dn=true;ds=i.Position;sp=f.Position if endConn then endConn:Disconnect()end endConn=i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then stopDrag()end end)end end)f.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then stopDrag()end end)UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then stopDrag()end end)f.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)UIS.InputChanged:Connect(function(i)if i==di and dn then if uiLocked then stopDrag();return end if _isDraggingButton then return end if not ds or not sp then return end local nX=sp.X.Offset+(i.Position.X-ds.X)local nY=sp.Y.Offset+(i.Position.Y-ds.Y)f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)end end)end _G.__ZeyHubbDragFrame=drag _G.__RivalHubSpeedEngine=_G.__RivalHubSpeedEngine or{started=false,conn=nil}_G.__RivalHubSpeedEngine.signal=nil do _G.__RivalHubSpeedEngine.signal=RunService.RenderStepped end local function _spd_isRagdollState(hum)if not hum then return true end local st=hum:GetState()return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown end local function _spd_shouldUseStealSpeed(_isStealing)return speedMode==true end local function _spd_getSelectedBoostSpeed()if laggerToggled or laggerCarryToggled then return LAGGER_SPEED end return NS end local function _spd_getSelectedStealSpeed()if laggerCarryToggled then return LAGGER_CARRY_SPEED end if laggerToggled then return LAGGER_SPEED end return CS end local function _spd_getTargetSpeed(isStealing)if _spd_shouldUseStealSpeed(isStealing)then return _spd_getSelectedStealSpeed()end return _spd_getSelectedBoostSpeed()end local function _spd_resetMovement()lastMoveDir=_V3zero _s2VelState.v=_V3new(0,_s2VelState.v.Y or 0,0)end local function _spd_stop()if _G.__RivalHubSpeedEngine.conn then _G.__RivalHubSpeedEngine.conn:Disconnect()_G.__RivalHubSpeedEngine.conn=nil end _spd_resetMovement()end local function _spd_start()_spd_stop()_G.__RivalHubSpeedEngine.started=true _G.__RivalHubSpeedEngine.acc=0 _G.__RivalHubSpeedEngine.conn=_G.__RivalHubSpeedEngine.signal:Connect(function(dt)_G.__RivalHubSpeedEngine.acc=(_G.__RivalHubSpeedEngine.acc or 0)+(dt or 0)if _G.__RivalHubSpeedEngine.acc<0.016 then return end _G.__RivalHubSpeedEngine.acc=0 local character=LP.Character local humanoid=character and character:FindFirstChildOfClass("Humanoid")local root=character and character:FindFirstChild("HumanoidRootPart")if not humanoid or not root or humanoid.Health<=0 then return end if autoBatEnabled or autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping or(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2())then _spd_resetMovement()return end if _spd_isRagdollState(humanoid)then lastMoveDir=_V3zero return end if _s2VelState.root~=root or not _velChecked[root]then lastMoveDir=_V3zero _setupVelChecked(character)_hookVelHRP(root)end local direction if humanoid.MoveDirection.Magnitude>0 then lastMoveDir=humanoid.MoveDirection direction=humanoid.MoveDirection elseif lastMoveDir.Magnitude>0 then for key in pairs(MOVE_KEYS)do if UIS:IsKeyDown(key)then direction=lastMoveDir break end end end local selectedSpeed=_spd_getTargetSpeed(LP:GetAttribute("Stealing")==true)_applyVelocitySpeed(direction,tonumber(selectedSpeed)or 16,root)end)end local function _spd_applyNow()local character=LP.Character local hum=character and character:FindFirstChildOfClass("Humanoid")local root=character and character:FindFirstChild("HumanoidRootPart")if not hum or not root or hum.Health<=0 or _spd_isRagdollState(hum)then return end local direction=hum.MoveDirection.Magnitude>0.05 and hum.MoveDirection or nil _applyVelocitySpeed(direction,_spd_getTargetSpeed(LP:GetAttribute("Stealing")==true),root)end local function _spd_refresh()_spd_start()end _G.__RivalHubRefreshSpeedEngine=_spd_refresh _G.__RivalHubStopSpeedEngine=_spd_stop _G.__RivalHubApplySpeedNow=_spd_applyNow pcall(_spd_start)LP.CharacterAdded:Connect(function(character)task.wait(0.5)_spd_resetMovement()local root=character:WaitForChild("HumanoidRootPart",5)if root then _setupVelChecked(character);_hookVelHRP(root)end _spd_start()end)LP.CharacterRemoving:Connect(function()_spd_stop()_s2VelState.root=nil end)function setupMovementAndIndicators(char)if steppedConn then steppedConn:Disconnect();steppedConn=nil end if movementLoop then movementLoop:Disconnect();movementLoop=nil end local ccAcc=0 steppedConn=RunService.Heartbeat:Connect(function(dt)ccAcc=ccAcc+dt if ccAcc<0.05 then return end ccAcc=0 local plist=_GetPlayersCached()for i=1,#plist do local p=plist[i]if p~=LP then local ch=p.Character if ch then local parts=ch:GetChildren()for j=1,#parts do local part=parts[j]if part:IsA("BasePart")and part.CanCollide then part.CanCollide=false end end end end end end)movementLoop=RunService.RenderStepped:Connect(function()local char2=LP.Character if not char2 then return end local hum=char2:FindFirstChildOfClass("Humanoid")local hrp=char2:FindFirstChild("HumanoidRootPart")if not hum or not hrp then return end if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then if _isRagdollState(hum)then lastMoveDir=_V3zero else local md=hum.MoveDirection if md.Magnitude>0 then lastMoveDir=md end end end if speedLabel then local displaySpeed=getActiveMoveSpeed()speedLabel.Text=string.format("%.1f  -  %s",displaySpeed,getSpeedModeName())end end)setupSpeedIndicator(char)startEnemySpeed()end function toggleLockUI(state)if state==nil then uiLocked=not uiLocked else uiLocked=state end uiLocked=uiLocked==true mobileButtonsLocked=uiLocked if setLockUIVisual then setLockUIVisual(uiLocked)end if not uiLocked then pcall(function()if main then main.Active=true end if scriptHeader then scriptHeader.Active=true end end)end end function disableAllAimbots()if autoBatEnabled then disableAutoBat()if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end end end function stopAllBackgroundTasks()if movementLoop then movementLoop:Disconnect();movementLoop=nil end if steppedConn then steppedConn:Disconnect();steppedConn=nil end stopEnemySpeed()if stretchEnabled then disableStretch()end if stretchConn then stretchConn:Disconnect();stretchConn=nil end if stretchFovConn then stretchFovConn:Disconnect();stretchFovConn=nil end if AntiRagdollV1.isRunning()then AntiRagdollV1.stop()end if AntiRagdollV2.Enabled then stopAntiRagdollV2()end if _G.__RivalHubFloat and _G.__RivalHubFloat.running then pcall(_G.__RivalHubFloat.disable)end if _G.__RivalHubAutoCarryStop then pcall(_G.__RivalHubAutoCarryStop)end if antiDieEnabled then AntiDieModule.stop()end if antiBatEnabled then stopAntiBat()end if antiFlingEnabled then stopAntiFling()end stopBatCounter()if stopBatCounterV2 then stopBatCounterV2()end stopMedusaCounter()stopAutoSteal()disableAutoBat()stopAutoLeft()stopAutoRight()if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end if TPBatState and TPBatState.enabled and tpBatSetEnabled then pcall(tpBatSetEnabled,false)end if unwalkEnabled then stopUnwalk()end if antiLagEnabled then disableAntiLag()end if espEnabled then toggleESP(false)end if espLineEnabled then stopESPLine()end if dropActive then stopDropBrainrot()end if bodyLockEnabled then stopBodyLock()end _blSuppressCount=0 _blWasEnabled=false if _blRestoreTimer then pcall(task.cancel,_blRestoreTimer);_blRestoreTimer=nil end if _bodyLockConn then _bodyLockConn:Disconnect();_bodyLockConn=nil end for _,t in ipairs(dropConnections)do if type(t)=="thread"then pcall(task.cancel,t)elseif type(t)=="RBXScriptConnection"then pcall(t.Disconnect,t)end end dropConnections={}dropActive=false alPhase=1 arPhase=1 lastDropTime=0 medusaDebounce=false medusaLastUsed=0 if _G.__RivalHubStopSpeedEngine then pcall(_G.__RivalHubStopSpeedEngine)end end local _rivalHubSaveState={lastAt=0,queued=false,writing=false,dirty=false,revision=0,retryCount=0,}local function resolveRivalHubFileApi()local env=(type(getgenv)=="function"and getgenv())or _G local synApi=rawget(env,"syn")or rawget(_G,"syn")local readCandidates={rawget(env,"readfile"),synApi and synApi.readfile,rawget(_G,"readfile")}local writeCandidates={rawget(env,"writefile"),synApi and synApi.writefile,rawget(_G,"writefile")}local readFn,writeFn for _,fn in ipairs(readCandidates)do if type(fn)=="function"then readFn=fn;break end end for _,fn in ipairs(writeCandidates)do if type(fn)=="function"then writeFn=fn;break end end return readFn,writeFn end local function rivalHubFileExists(path)local readFn=resolveRivalHubFileApi()if not readFn then return false end local ok,data=pcall(readFn,path)return ok and type(data)=="string"end function buildConfigTable()local config={normalSpeed=NS,carrySpeed=CS,laggerSpeed1=LAGGER_SPEED,laggerSpeed2=LAGGER_CARRY_SPEED,stealRadius=CONFIG.STEAL_RANGE,holdMin=CONFIG.HOLD_MIN,holdMax=CONFIG.HOLD_MAX,entryDelay=CONFIG.ENTRY_DELAY,cooldown=CONFIG.COOLDOWN,primeRange=CONFIG.PRIME_RANGE,antiRagdollMode=antiRagdollMode,antiDieEnabled=antiDieEnabled,antiBat=antiBatEnabled,antiFling=antiFlingEnabled,autoSteal=CONFIG.AUTO_STEAL_ENABLED,autoBat=autoBatEnabled,autoLeft=autoLeftEnabled,autoRight=autoRightEnabled,medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,medusaSkin=_G.RivalMedusaSkin or"Default",batCounterV2=batCounterV2Enabled,unwalkEnabled=unwalkEnabled,laggerToggled=laggerToggled,laggerCarryToggled=laggerCarryToggled,carryMode=speedMode,batAimbotSpeed=BAT_AIMBOT_SPEED,bypassAimbotSpeed=BYPASS_AIMBOT_SPEED,batAimbotKey={kb=KB.BatAimbot.kb and KB.BatAimbot.kb.Name,gp=KB.BatAimbot.gp and KB.BatAimbot.gp.Name},dropMode=dropMode,stretchEnabled=stretchEnabled,stretchFOV=stretchFOV,customFovEnabled=(_G.__ZeyHubbCustomFOV and _G.__ZeyHubbCustomFOV.enabled==true) or false,customFovValue=(_G.__ZeyHubbCustomFOV and tonumber(_G.__ZeyHubbCustomFOV.value)) or 90,uiScale=uiScaleValue,animPack=currentAnimPack,espEnabled=espEnabled,espLineEnabled=espLineEnabled,vividGraphics=vividGraphicsEnabled,hideButtons=hideButtonsEnabled,hiddenMobileButtons=hiddenMobileButtons,antiLag=antiLagEnabled,skyTheme=skyTheme,mobileButtonPositions=savedButtonPositions,dropBrainrotKey={kb=KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name,gp=KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},autoLeftKey={kb=KB.AutoLeft.kb and KB.AutoLeft.kb.Name,gp=KB.AutoLeft.gp and KB.AutoLeft.gp.Name},autoRightKey={kb=KB.AutoRight.kb and KB.AutoRight.kb.Name,gp=KB.AutoRight.gp and KB.AutoRight.gp.Name},autoBatKey={kb=KB.AutoBat.kb and KB.AutoBat.kb.Name,gp=KB.AutoBat.gp and KB.AutoBat.gp.Name},tpFloorKey={kb=KB.TPFloor.kb and KB.TPFloor.kb.Name,gp=KB.TPFloor.gp and KB.TPFloor.gp.Name},guiHideKey={kb=KB.GuiHide.kb and KB.GuiHide.kb.Name,gp=KB.GuiHide.gp and KB.GuiHide.gp.Name},carryToggleKey={kb=KB.CarryToggle.kb and KB.CarryToggle.kb.Name,gp=KB.CarryToggle.gp and KB.CarryToggle.gp.Name},laggerModeKey={kb=KB.LaggerMode.kb and KB.LaggerMode.kb.Name,gp=KB.LaggerMode.gp and KB.LaggerMode.gp.Name},batV2Key={kb=KB.BatV2.kb and KB.BatV2.kb.Name,gp=KB.BatV2.gp and KB.BatV2.gp.Name},tpBatKey={kb=KB.TPBat.kb and KB.TPBat.kb.Name,gp=KB.TPBat.gp and KB.TPBat.gp.Name},floatKey={kb=KB.Float.kb and KB.Float.kb.Name,gp=KB.Float.gp and KB.Float.gp.Name},instantResetKey={kb=KB.InstantReset.kb and KB.InstantReset.kb.Name,gp=KB.InstantReset.gp and KB.InstantReset.gp.Name},bodyLockEnabled=bodyLockEnabled,bodyLockRange=bodyLockRange,autoCarryEnabled=autoCarryEnabled==true,autoCarryMode=autoCarryMode,progressBarPos=savedProgressBarPos,lockUI=uiLocked,backgroundIndex=backgroundIndex,backgroundImageTransparency=backgroundImageTransparency,backgroundMode=backgroundMode,floatingButtonScale=floatingButtonScale,stealBarScale=stealBarScale,outfitIndex=currentOutfitIndex,vx7AvatarIndex=VX7A.index,themeColor=currentColorTheme,rivalTitleTheme=currentRivalTitleTheme,infiniteJumpEnabled=InfiniteJump.enabled==true,infiniteJumpMode=InfiniteJump.mode=="manual"and"manual"or"hold",autoStealMode=autoStealMode,stealBarStyle=(stealBarStyle=="V3")and stealBarStyle or"V1",batV2=_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false,batVersion=(_G.__RivalHubBatVersion=="v3")and"v3"or"v2",tpBatVersion=(_G.__ZeyHubbTPBatVersion=="v3" or _G.__ZeyHubbTPBatVersion=="v2")and _G.__ZeyHubbTPBatVersion or"v1",bypassBatVersion=((_G.__ZeyHubbBypassBatVersion=="v2"or _G.__ZeyHubbBypassBatVersion=="v3")and _G.__ZeyHubbBypassBatVersion)or"v1",introSongVersion="v1",noIntroEnabled=_G.__ZeyHubbNoIntroEnabled==true,noIntroSongEnabled=_G.__ZeyHubbNoIntroSongEnabled==true,spinBotEnabled=_G.__ZeyHubbSpinBotEnabled==true,spinBotSpeed=tonumber(_G.__ZeyHubbSpinBotSpeed)or 720,autoBrainrotEnabled=_G.__ZeyHubbAutoBrainrotEnabled==true,tpBatEnabled=TPBatState and TPBatState.enabled==true,antiCrasherEnabled=_G.__ZeyHubbAntiCrasherEnabled==true,headlessEnabled=_G.__ZeyHubbHeadlessEnabled==true,korbloxEnabled=_G.__ZeyHubbKorbloxEnabled==true,duelPingAlertEnabled=_G.__ZeyHubbDuelPingEnabled==true,instantResetVersion=(_G.__ZeyHubbInstantResetVersion=="V2")and"V2"or"V1",}if main then local basePos=_G.__RivalHubMainOriginalPos or main.Position config.mainPosition={XScale=basePos.X.Scale,XOffset=basePos.X.Offset,YScale=basePos.Y.Scale,YOffset=basePos.Y.Offset,}end if pbFrame then config.progressBarPos={XScale=pbFrame.Position.X.Scale,XOffset=pbFrame.Position.X.Offset,YScale=pbFrame.Position.Y.Scale,YOffset=pbFrame.Position.Y.Offset}end if MobilePanel then config.mobilePanelPos={XScale=0,XOffset=10,YScale=0,YOffset=0}for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")then savedButtonPositions[btn.Name]={X=btn.Position.X.Offset,Y=btn.Position.Y.Offset}end end config.mobileButtonPositions=savedButtonPositions end return config end local function scheduleRivalHubSave(delaySeconds)if _rivalHubSaveState.queued then return end _rivalHubSaveState.queued=true task.delay(delaySeconds or 0.25,function()_rivalHubSaveState.queued=false if _G.RivalHubRunning and not _isResetting and not _isLoading then pcall(saveAllSettings,true)end end)end function saveAllSettings(force)if _isResetting or _isLoading then return true end local config=buildConfigTable()config.configVersion=3 config.userId=LP.UserId local encodedOk,canonicalJSON=pcall(function()return HS:JSONEncode(config)end)if not encodedOk then warn("[Rival Hub Save] Could not encode settings.")return false end if not force and canonicalJSON==_lastSavedJSON and not _rivalHubSaveState.dirty then return true end _rivalHubSaveState.dirty=true if _rivalHubSaveState.writing then scheduleRivalHubSave(0.25)return true end if not force and _tick()-_rivalHubSaveState.lastAt<0.25 then scheduleRivalHubSave(0.25)return true end local readFn,writeFn=resolveRivalHubFileApi()if not readFn or not writeFn then warn("[Rival Hub Save] Executor file API is unavailable.")scheduleRivalHubSave(1)return false end _rivalHubSaveState.writing=true _rivalHubSaveState.revision=_rivalHubSaveState.revision+1 local writeConfig=config writeConfig.revision=_rivalHubSaveState.revision writeConfig.savedAt=os.time()local json=HS:JSONEncode(writeConfig)local ok=false for attempt=1,3 do local attemptOk=pcall(function()if rivalHubFileExists(CONFIG_FILE)then local previous=readFn(CONFIG_FILE)if type(previous)=="string"then writeFn(CONFIG_FILE..".backup",previous)end end writeFn(CONFIG_FILE,json)local readBack=readFn(CONFIG_FILE)if readBack~=json then error("save verification failed")end HS:JSONDecode(readBack)end)if attemptOk then ok=true break end if attempt<3 then task.wait(0.1*attempt)end end _rivalHubSaveState.writing=false if ok then _rivalHubSaveState.lastAt=_tick()_rivalHubSaveState.retryCount=0 _lastSavedJSON=canonicalJSON _rivalHubSaveState.dirty=false local latestOk,latest=pcall(function()local latestConfig=buildConfigTable()latestConfig.configVersion=3 latestConfig.userId=LP.UserId return HS:JSONEncode(latestConfig)end)if not latestOk or latest~=_lastSavedJSON then _rivalHubSaveState.dirty=true scheduleRivalHubSave(0.25)end else _rivalHubSaveState.retryCount=_rivalHubSaveState.retryCount+1 warn("[Rival Hub Save] Write or verification failed; will retry.")scheduleRivalHubSave(math.min(2,0.5*_rivalHubSaveState.retryCount))end return ok end task.spawn(function()task.wait(2)while _G.RivalHubRunning do task.wait(1)if gui and main and not _isLoading then pcall(saveAllSettings)end end end)pcall(function()game:BindToClose(function()pcall(saveAllSettings,true)end)end)do local readFn,writeFn=resolveRivalHubFileApi()if readFn and writeFn then local legacyPaths={"Fresh_"..tostring(LP.UserId)..".json","Rival_"..tostring(LP.UserId)..".json","BloodHounds_"..tostring(LP.UserId)..".json",}local okNew,_=pcall(readFn,CONFIG_FILE)if not okNew then for _,oldPath in ipairs(legacyPaths)do local okOld,old=pcall(readFn,oldPath)if okOld and type(old)=="string"and#old>0 then pcall(writeFn,CONFIG_FILE,old)warn("[ZeyHubb.vs] Config migrada de "..oldPath.." a "..CONFIG_FILE)break end end end end end function loadAllSettings()local readFn=resolveRivalHubFileApi()if not readFn or not rivalHubFileExists(CONFIG_FILE)then return false end local success,data=pcall(function()return HS:JSONDecode(readFn(CONFIG_FILE))end)if not success or type(data)~="table"then return false end _isLoading=true local function num(v,fallback)local n=tonumber(v)if n==nil or n~=n or n==math.huge or n==-math.huge then return fallback end return n end local function boolOr(v,fallback)if v==nil then return fallback end return v==true end _G.__ZeyHubbSpinBotEnabled=boolOr(data.spinBotEnabled,_G.__ZeyHubbSpinBotEnabled==true) _G.__ZeyHubbSpinBotSpeed=num(data.spinBotSpeed,_G.__ZeyHubbSpinBotSpeed or 720) _G.__ZeyHubbAutoBrainrotEnabled=boolOr(data.autoBrainrotEnabled,_G.__ZeyHubbAutoBrainrotEnabled==true) NS=num(data.normalSpeed,NS)CS=num(data.carrySpeed,CS)LAGGER_SPEED=num(data.laggerSpeed1,LAGGER_SPEED)LAGGER_CARRY_SPEED=num(data.laggerSpeed2,LAGGER_CARRY_SPEED)CONFIG.STEAL_RANGE=num(data.stealRadius,CONFIG.STEAL_RANGE)CONFIG.HOLD_MIN=num(data.holdMin,CONFIG.HOLD_MIN)CONFIG.HOLD_MAX=num(data.holdMax,CONFIG.HOLD_MAX)CONFIG.ENTRY_DELAY=num(data.entryDelay,CONFIG.ENTRY_DELAY)CONFIG.COOLDOWN=num(data.cooldown,CONFIG.COOLDOWN)CONFIG.PRIME_RANGE=num(data.primeRange,CONFIG.PRIME_RANGE)if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if num(data.configVersion,1)>=2 and data.lockUI~=nil then uiLocked=boolOr(data.lockUI,false)else uiLocked=false end mobileButtonsLocked=false if data.antiRagdollMode then antiRagdollMode=tostring(data.antiRagdollMode)else antiRagdollMode=data.antiRagdoll and"v2"or"off"end _G.__RivalHubBatVersion=(data.batVersion=="v3")and"v3"or"v2";_G.__ZeyHubbTPBatVersion=(data.tpBatVersion=="v3" or data.tpBatVersion=="v2")and data.tpBatVersion or"v1";_G.__ZeyHubbBypassBatVersion=((data.bypassBatVersion=="v2"or data.bypassBatVersion=="v3")and data.bypassBatVersion)or"v1";_G.__ZeyHubbIntroSongVersion="off";if introSongSelectorLabel then introSongSelectorLabel.Text="V1" end;TPBatState.version=_G.__ZeyHubbTPBatVersion;antiDieEnabled=boolOr(data.antiDieEnabled,false);_G.__ZeyHubbNoIntroEnabled=boolOr(data.noIntroEnabled,false)_G.__ZeyHubbNoIntroSongEnabled=boolOr(data.noIntroSongEnabled,false)_G.__ZeyHubbHeadlessEnabled=boolOr(data.headlessEnabled,false)_G.__ZeyHubbKorbloxEnabled=boolOr(data.korbloxEnabled,false)_G.__ZeyHubbDuelPingEnabled=boolOr(data.duelPingAlertEnabled,false)_G.__ZeyHubbInstantResetVersion=data.instantResetVersion=="V2"and"V2"or"V1"if _G.__ZeyHubbInstantResetSetVersion then pcall(_G.__ZeyHubbInstantResetSetVersion,_G.__ZeyHubbInstantResetVersion)end antiBatEnabled=boolOr(data.antiBat,false)antiFlingEnabled=boolOr(data.antiFling,false)CONFIG.AUTO_STEAL_ENABLED=boolOr(data.autoSteal,false)autoBatEnabled=boolOr(data.autoBat,false)autoLeftEnabled=boolOr(data.autoLeft,false)autoRightEnabled=boolOr(data.autoRight,false)do local m=tostring(data.autoStealMode or"73") if m=="V2"then m="85" elseif m=="V1"then m="73" end if not tonumber(m) then m="73" end autoStealMode=m if applyStealStopPercent then applyStealStopPercent(m) end end stealBarStyle=(type(data.stealBarStyle)=="string"and(data.stealBarStyle=="V3"))and data.stealBarStyle or"V1"if applyStealBarStyle then pcall(applyStealBarStyle,stealBarStyle)elseif _G.__ZeyHubbApplyStealBarStyle then pcall(_G.__ZeyHubbApplyStealBarStyle,stealBarStyle)end InfiniteJump.mode=data.infiniteJumpMode=="manual"and"manual"or"hold"InfiniteJump.enabled=boolOr(data.infiniteJumpEnabled,false)medusaCounterEnabled=boolOr(data.medusaCounter,false)if type(data.medusaSkin)=="string"and _G.RivalSetMedusaSkin then _G.RivalSetMedusaSkin(data.medusaSkin)if _G.RivalMedusaSkinRefreshUI then pcall(_G.RivalMedusaSkinRefreshUI)end end batCounterEnabled=boolOr(data.batCounter,false)batCounterV2Enabled=boolOr(data.batCounterV2,false)unwalkEnabled=boolOr(data.unwalkEnabled,boolOr(data.unwalk,false))antiLagEnabled=boolOr(data.antiLag,false)laggerToggled=boolOr(data.laggerToggled,false)speedMode=boolOr(data.carryMode,false)laggerCarryToggled=boolOr(data.laggerCarryToggled,false)uiScaleValue=_clamp(num(data.uiScale,78),50,150)if mainUIScale then mainUIScale.Scale=uiScaleValue/100 end espEnabled=boolOr(data.espEnabled,false)espLineEnabled=boolOr(data.espLineEnabled,false)if espEnabled then pcall(toggleESP,true)else pcall(toggleESP,false)end vividGraphicsEnabled=boolOr(data.vividGraphics,false)hideButtonsEnabled=boolOr(data.hideButtons,false)
if type(data.hiddenMobileButtons)=="table" then
hiddenMobileButtons={}
for k,v in pairs(data.hiddenMobileButtons) do
if v==true then hiddenMobileButtons[tostring(k)]=true end
end
else
hiddenMobileButtons=hiddenMobileButtons or{}
end
TPBatState.enabled=boolOr(data.tpBatEnabled,false) currentColorTheme=COLOR_THEMES[data.themeColor]and data.themeColor or(data.themeColor=="Cyan"and"Blue"or"Blue")selectedColor=COLOR_THEMES[currentColorTheme]task.defer(function()updateAllUIThemeColors(selectedColor)end)if data.rivalTitleTheme and RIVAL_TITLE_THEMES[data.rivalTitleTheme]then task.defer(function()applyRivalTitleTheme(data.rivalTitleTheme)end)end skyTheme=data.skyTheme or"Off"if skyTheme~="Off"then pcall(applyCustomSky,skyTheme)end if skySelectorLabel then skySelectorLabel.Text=skyTheme end if data.animPack and ANIM_PACKS[data.animPack]then pcall(startAnimPack,data.animPack)else currentAnimPack="Off"stopAnimPack()end local function lk(e,d)if not d then return end if d.kb and Enum.KeyCode[d.kb]then e.kb=Enum.KeyCode[d.kb]end if d.gp and Enum.KeyCode[d.gp]then e.gp=Enum.KeyCode[d.gp]end end lk(KB.DropBrainrot,data.dropBrainrotKey)lk(KB.AutoLeft,data.autoLeftKey)lk(KB.AutoRight,data.autoRightKey)lk(KB.AutoBat,data.autoBatKey)lk(KB.TPFloor,data.tpFloorKey)lk(KB.GuiHide,data.guiHideKey)lk(KB.CarryToggle,data.carryToggleKey)lk(KB.LaggerMode,data.laggerModeKey)lk(KB.BatV2,data.batV2Key)lk(KB.TPBat,data.tpBatKey)lk(KB.Float,data.floatKey)lk(KB.InstantReset,data.instantResetKey)if data.mobileButtonPositions then savedButtonPositions=data.mobileButtonPositions end if data.mobilePanelPos then savedMobilePanelPos=data.mobilePanelPos end if data.mainPosition and main and type(data.mainPosition)=="table"then
local mx=num(data.mainPosition.XOffset,20)
local my=num(data.mainPosition.YOffset,2)
if mx~=mx or my~=my then mx,my=20,2 end
main.Position=UDim2.fromOffset(mx,my)
task.defer(function()if clampMainToScreen then pcall(clampMainToScreen)elseif _G.__ZeyHubbClampMainToScreen then pcall(_G.__ZeyHubbClampMainToScreen)end end)
end if data.progressBarPos and type(data.progressBarPos)=="table"then savedProgressBarPos=data.progressBarPos end if data.bodyLockEnabled~=nil then bodyLockEnabled=boolOr(data.bodyLockEnabled,false)if bodyLockEnabled then task.defer(function()if bodyLockSetVisual then bodyLockSetVisual(true)end startBodyLock()end)end end if data.autoCarryEnabled~=nil then autoCarryEnabled=data.autoCarryEnabled==true end if data.autoCarryMode=="On Pick Up"or data.autoCarryMode=="Soft Steal"then autoCarryMode=data.autoCarryMode end if _G.__RivalHubAutoCarryRefresh then pcall(_G.__RivalHubAutoCarryRefresh)end if data.bodyLockRange~=nil then bodyLockRange=_clamp(num(data.bodyLockRange,20),5,200)if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end end dropMode=num(data.dropMode,1)stretchEnabled=boolOr(data.stretchEnabled,false)stretchFOV=num(data.stretchFOV,120) if type(_G.__ZeyHubbCustomFOV)~="table" then _G.__ZeyHubbCustomFOV={enabled=false,value=90,original=nil} end _G.__ZeyHubbCustomFOV.enabled=boolOr(data.customFovEnabled,false) _G.__ZeyHubbCustomFOV.value=math.clamp(num(data.customFovValue,90),40,180)BAT_AIMBOT_SPEED=num(data.batAimbotSpeed,BAT_AIMBOT_SPEED)BYPASS_AIMBOT_SPEED=num(data.bypassAimbotSpeed,BYPASS_AIMBOT_SPEED) if State then State.bypassBatSpeed=BYPASS_AIMBOT_SPEED end if type(data.batAimbotKey)=="table" then local k=data.batAimbotKey;local kc=k.kb and Enum.KeyCode[k.kb];local gp=k.gp and Enum.KeyCode[k.gp];if kc or gp then KB.BatAimbot={kb=kc,gp=gp} end end backgroundIndex=_clamp(num(data.backgroundIndex,1),1,math.max(#backgroundImages,1))backgroundImageTransparency=_clamp(num(data.backgroundImageTransparency,0),0,1)if data.backgroundMode=="None"or#backgroundImages==0 then backgroundMode="None"else local savedN=nil if type(data.backgroundMode)=="string"then savedN=tonumber(string.match(data.backgroundMode,"^Background%s+(%d+)$"))end if type(savedN)=="number"and savedN>=1 and savedN<=#backgroundImages then backgroundIndex=savedN end backgroundMode="Background "..backgroundIndex end floatingButtonScale=_clamp(num(data.floatingButtonScale,1),0.5,2);if type(data.tpBatEnabled)=="boolean"and data.tpBatEnabled and tpBatSetEnabled then task.defer(function()pcall(tpBatSetEnabled,true);if _G.__ZeyHubbTPBatSetVisual then pcall(_G.__ZeyHubbTPBatSetVisual,true)end;if _G.__ZeyHubbTPBatRefresh then pcall(_G.__ZeyHubbTPBatRefresh)end end)end;stealBarScale=_clamp(num(data.stealBarScale,1),0.4,2)if pbScale then pbScale.Scale=stealBarScale end if type(data.outfitIndex)=="number"and type(OUTFITS)=="table"and#OUTFITS>0 and data.outfitIndex>=1 and data.outfitIndex<=#OUTFITS then currentOutfitIndex=data.outfitIndex task.defer(function()pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel and OUTFITS[currentOutfitIndex]then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end end)end if type(data.vx7AvatarIndex)=="number"and data.vx7AvatarIndex>=1 and data.vx7AvatarIndex<=#VX7A.labels-1 then local _vx7Saved=data.vx7AvatarIndex task.defer(function()task.wait(1.5)pcall(VX7A.apply,_vx7Saved)end)end if vividGraphicsEnabled then task.defer(function()pcall(enableVividGraphics)end)else task.defer(function()pcall(disableVividGraphics)end)end if dropModeBtnRef then dropModeBtnRef.Text=dropMode==1 and"Fling"or"Jump Drop"end refreshSpeedModeLabel()_lastSavedJSON=HS:JSONEncode(buildConfigTable())_isLoading=false local antiCrasherShouldEnable=boolOr(data.antiCrasherEnabled,_G.__ZeyHubbAntiCrasherEnabled==true)if _G.__ZeyHubbSetAntiCrasher then task.defer(function()pcall(_G.__ZeyHubbSetAntiCrasher,antiCrasherShouldEnable,false)end)else _G.__ZeyHubbAntiCrasherEnabled=antiCrasherShouldEnable end if data.batV2==true and _G.__RivalHubStartBatV2 then task.defer(function()pcall(_G.__RivalHubStartBatV2)if mobSetBatV2 then mobSetBatV2(true)end end)end return true end function forceResetUI()if normalBox then normalBox.Text=tostring(NS)end if carryBox then carryBox.Text=tostring(CS)end if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED)end if lagger2Box then lagger2Box.Text=tostring(LAGGER_CARRY_SPEED)end if batSpeedBox then batSpeedBox.Text=tostring(BYPASS_AIMBOT_SPEED)end if uiScaleBox then uiScaleBox.Text=tostring(uiScaleValue)end if stealBarScaleBox then stealBarScaleBox.Text=tostring(_floor((stealBarScale or 1)*100+0.5))end if pbScale then pbScale.Scale=stealBarScale or 1 end if dropModeBtnRef then dropModeBtnRef.Text=dropMode==1 and"Fling"or"Jump Drop"end if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end local function safeSet(fn,val)if fn then fn(val)end end safeSet(autoBatSetVisual,false)safeSet(autoLeftSetVisual,false)safeSet(autoRightSetVisual,false)safeSet(setBatCounterVisual,false)safeSet(setBatCounterV2Visual,false)safeSet(setMedusaVisual,false)safeSet(setUnwalkVisual,false)safeSet(setAntiLagVisual,false)safeSet(setLockUIVisual,false)safeSet(setInstaGrab,false)safeSet(setESPVIsual,false)safeSet(setESPLineVisual,false)safeSet(setVividVisual,false)safeSet(setHideButtonsVisual,false)safeSet(bodyLockSetVisual,false)safeSet(setAntiDieVisual,false)safeSet(setAntiBatVisual,false)safeSet(setAntiFlingVisual,false)safeSet(setAntiRagVisual,false)safeSet(infJumpSetVisual,false)safeSet(mobSetBatV2,false)if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end disableVividGraphics()applyHideButtons(false)if _G.stretchToggleSetter then _G.stretchToggleSetter(false)end safeSet(mobSetAutoBat,false)safeSet(mobSetAutoLeft,false)safeSet(mobSetAutoRight,false)safeSet(mobSetDropBR,false)safeSet(mobSetTpDown,false)safeSet(mobSetCarry,false)safeSet(mobSetLagger1,false)safeSet(mobSetLagger2,false)if _G.__RivalHubFloat and _G.__RivalHubFloat.running then _G.__RivalHubFloat.disable()end safeSet(_G.__RivalHubFloatSetVisual,false)safeSet(mobSetFloat,false)refreshSpeedModeLabel()updateProgressBarVisibility()disableAntiLag()if stopAntiBat then stopAntiBat()end if stopAntiFling then stopAntiFling()end if stopESPLine then stopESPLine()end skyTheme="Off"pcall(applyCustomSky,"Off")if skySelectorLabel then skySelectorLabel.Text="Off"end if antiDieEnabled then AntiDieModule.stop()antiDieEnabled=false end for _,ref in ipairs(keyButtonRefs)do local entry=ref.entry local label=(entry.gp and entry.gp.Name)or(entry.kb and entry.kb.Name)or"None"ref.btn.Text=label end currentColorTheme="Blue"selectedColor=COLOR_THEMES["Blue"]updateAllUIThemeColors(selectedColor)if miniBtn then local stroke=miniBtn:FindFirstChildOfClass("UIStroke")if stroke then stroke.Color=Color3.fromRGB(42,43,47)end end if MobilePanel then for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")then local label=btn:FindFirstChildOfClass("TextLabel")if label then local isActive=btn.BackgroundColor3==selectedColor if not isActive then label.TextColor3=selectedColor end end end end end saveAllSettings()end function resetFloatingPositions()if MobilePanel then savedButtonPositions={}for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")and btn.Name then local defX,defY=getDefaultButtonPosition(btn.Name)btn.Position=UDim2.new(0,defX,0,defY)end end end if pbFrame then pbFrame.Position=UDim2.new(0.5,-150,0.78,0)savedProgressBarPos=nil end savedMobilePanelPos=nil end function resetToFactoryDefaults()_isResetting=true local ok,err=pcall(function()stopAutoSteal()stopBatCounter()if stopBatCounterV2 then stopBatCounterV2()end stopMedusaCounter()if AntiRagdollV2.Enabled then stopAntiRagdollV2()end if antiDieEnabled then AntiDieModule.stop()end if antiBatEnabled and stopAntiBat then stopAntiBat()end if antiFlingEnabled and stopAntiFling then stopAntiFling()end if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end stopUnwalk()InfiniteJump.stop()InfiniteJump.setMode("hold")disableAutoBat()stopBodyLock()if espEnabled then toggleESP(false)end if espLineEnabled and stopESPLine then stopESPLine()end if stretchEnabled then disableStretch()end if antiLagEnabled then disableAntiLag()end if vividGraphicsEnabled then disableVividGraphics()end if hideButtonsEnabled then applyHideButtons(false)end if dropActive then stopDropBrainrot()end skyTheme="Off"pcall(applyCustomSky,"Off")if skySelectorLabel then skySelectorLabel.Text="Off"end if antiDieEnabled then AntiDieModule.stop();antiDieEnabled=false end NS=60;CS=29;LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5 CONFIG.STEAL_RANGE=65 CONFIG.HOLD_MIN=0.05 CONFIG.HOLD_MAX=0.15 CONFIG.ENTRY_DELAY=0.1 CONFIG.COOLDOWN=0.2 CONFIG.PRIME_RANGE=60 speedMode=false;laggerToggled=false;laggerCarryToggled=false antiRagdollMode="off";antiDieEnabled=false _G.__RivalHubBatVersion="v2"antiBatEnabled=false antiFlingEnabled=false medusaCounterEnabled=false;batCounterEnabled=false;batCounterV2Enabled=false autoBatEnabled=false;autoLeftEnabled=false;autoRightEnabled=false unwalkEnabled=false;antiLagEnabled=false uiLocked=false;mobileButtonsLocked=false CONFIG.AUTO_STEAL_ENABLED=false autoStealMode="73"if applyStealStopPercent then applyStealStopPercent("73")end if _G._rivalHubStealModeSetter then pcall(_G._rivalHubStealModeSetter)end BAT_AIMBOT_SPEED=58 BYPASS_AIMBOT_SPEED=BAT_AIMBOT_SPEED if State then State.bypassBatSpeed=BYPASS_AIMBOT_SPEED end dropMode=1;stretchEnabled=false;stretchFOV=120 uiScaleValue=78 if mainUIScale then mainUIScale.Scale=1 end if pbScale then pbScale.Scale=1 end espEnabled=false;espLineEnabled=false;vividGraphicsEnabled=false;hideButtonsEnabled=false bodyLockEnabled=false;bodyLockRange=20 autoCarryEnabled=false;autoCarryMode="On Pick Up"if _G.__RivalHubAutoCarryRestore then pcall(_G.__RivalHubAutoCarryRestore)end if _G.__RivalHubAutoCarryRefresh then pcall(_G.__RivalHubAutoCarryRefresh)end backgroundIndex=1;backgroundImageTransparency=0;backgroundMode="None"floatingButtonScale=1 stealBarScale=1 if pbScale then pbScale.Scale=1 end currentAnimPack="Off";stopAnimPack()currentOutfitIndex=1 pcall(VX7A.stop)currentColorTheme="Blue";selectedColor=COLOR_THEMES["Blue"]currentRivalTitleTheme="Blue"applyRivalTitleTheme("White")if main then main.Position=UDim2.new(0,20,0,2);_G.__RivalHubMainOriginalPos=main.Position end for key,val in pairs(DEFAULT_KB)do if KB[key]then KB[key].kb=val.kb;KB[key].gp=val.gp end end resetFloatingPositions()forceResetUI()updateProgressBarVisibility()refreshSpeedModeLabel()_lastSavedJSON=nil end)_isResetting=false if not ok then warn("[resetToFactoryDefaults]",err)end if ok then saveAllSettings(true)end return ok end function updateProgressBarVisibility()if pbFrame then pbFrame.Visible=true end end function applyShimmerToText(obj,speed,baseColor)speed=speed or 0.8 local color=baseColor or Color3.fromRGB(215,215,225)local grad=Instance.new("UIGradient",obj)grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(0.3,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(0.5,color:Lerp(Color3.new(1,1,1),0.55)),ColorSequenceKeypoint.new(0.7,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(1,color),})grad.Rotation=45 grad.Offset=Vector2.new(0,0)task.spawn(function()local t=0 while grad and grad.Parent do t=t+0.02 grad.Offset=Vector2.new(math.sin(t*speed)*0.4,0)grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,color),ColorSequenceKeypoint.new(0.30,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(0.50,color:Lerp(Color3.new(1,1,1),0.55)),ColorSequenceKeypoint.new(0.70,color:Lerp(Color3.new(0.15,0.15,0.15),0.25)),ColorSequenceKeypoint.new(1.00,color),})task.wait(0.04)end end)return grad end function getDefaultButtonPosition(btnName)
 local cam=Workspace.CurrentCamera
 local view=cam and cam.ViewportSize or Vector2.new(1536,710)
 local scale=tonumber(floatingButtonScale) or 1.8
 local w,h=62*scale,62*scale
 local margin=math.max(12,view.X*0.012)
 local gap=math.max(6,view.X*0.006)
 -- Layout designed to match the supplied landscape screenshot.
 local positions={
  InstantReset={0.625,0.008},
  DropBR={0.793,0.077}, AutoRight={0.871,0.077},
  AutoBat={0.539,0.194}, BatTP={0.617,0.194}, BatV2={0.710,0.194},
  BatAimbot={0.793,0.245}, AutoLeft={0.871,0.245},
  Float={0.625,0.385},
  TpDown={0.791,0.416}, Carry={0.870,0.416},
  Lagger1={0.791,0.595}, Lagger2={0.870,0.587},
 }
 local p=positions[btnName]
 if not p then return margin,margin end
 local x=math.floor(view.X*p[1]); local y=math.floor(view.Y*p[2])
 x=math.clamp(x,margin,math.max(margin,view.X-w-margin))
 y=math.clamp(y,margin,math.max(margin,view.Y-h-margin))
 return x,y
end local batDesyncTpEnabled=false local batDesyncTpConn=nil local hittingCooldownDesync=false local function updateTpBatButtonWithAntiDie(state)if tpBatFloatingButton then local btnFrame=tpBatFloatingButton:FindFirstChild("Frame")if btnFrame then local label=btnFrame:FindFirstChild("TextLabel")if label then label.Text="TP\nBAT"label.TextColor3=state and Color3.fromRGB(0,0,0)or Color3.fromRGB(255,255,255)end if state then btnFrame.BackgroundColor3=getThemeColor()else paintFloatingBtn(btnFrame,false)end end end end local function tpBatDisconnectAntiDie()for _,conn in ipairs(TPBatState.antiDieConnections)do pcall(function()conn:Disconnect()end)end TPBatState.antiDieConnections={}end local function tpBatHookAntiDie(character)tpBatDisconnectAntiDie()if not TPBatState.enabled or not character then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid then return end pcall(function()humanoid.BreakJointsOnDeath=false humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead,false)humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying,false)end)local cooldown=false table.insert(TPBatState.antiDieConnections,humanoid:GetPropertyChangedSignal("Health"):Connect(function()if cooldown or not TPBatState.enabled or not humanoid.Parent or humanoid.Health>0 then return end cooldown=true task.defer(function()pcall(function()if humanoid and humanoid.Parent then humanoid.Health=humanoid.MaxHealth humanoid:ChangeState(Enum.HumanoidStateType.Running)end end)task.wait(0.5)cooldown=false end)end))end local function tpBatFindBat()local character=LP.Character if not character then return nil end local function isBat(tool)if not tool:IsA("Tool")then return false end local name=string.lower(tool.Name)return string.find(name,"bat",1,true)~=nil or string.find(name,"slap",1,true)~=nil end for _,child in ipairs(character:GetChildren())do if isBat(child)then return child end end local backpack=LP:FindFirstChildOfClass("Backpack")if not backpack then return nil end for _,child in ipairs(backpack:GetChildren())do if isBat(child)then local humanoid=character:FindFirstChildOfClass("Humanoid")if humanoid then pcall(function()humanoid:EquipTool(child)end)end return child end end return nil end local function tpBatSwing()if TPBatState.hitCooldown then return end TPBatState.hitCooldown=true pcall(function()local bat=tpBatFindBat()if not bat then return end bat:Activate()local remote=bat:FindFirstChildWhichIsA("RemoteEvent",true)if remote then pcall(function()remote:FireServer()end)end end)task.delay(0.05,function()TPBatState.hitCooldown=false end)end local function tpBatGetVersion()
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
end function tpBatSetEnabled(value)TPBatState.enabled=value==true batDesyncTpEnabled=TPBatState.enabled if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end if not TPBatState.enabled then TPBatState.lockedTarget=nil end if TPBatState.enabled then tpBatHookAntiDie(LP.Character)if TPBatState.connection then TPBatState.connection:Disconnect()end TPBatState.connection=RunService.Heartbeat:Connect(tpBatTick)else if TPBatState.connection then TPBatState.connection:Disconnect()TPBatState.connection=nil end tpBatDisconnectAntiDie()local character=LP.Character local root=character and character:FindFirstChild("HumanoidRootPart")if root then pcall(function()if root.SetNetworkOwner then root:SetNetworkOwner(LP)end end)end end updateTpBatButtonWithAntiDie(TPBatState.enabled)if mobSetBatTP then pcall(mobSetBatTP,TPBatState.enabled)end return TPBatState.enabled end function toggleBatTP()return tpBatSetEnabled(not TPBatState.enabled)end LP.CharacterAdded:Connect(function(character)if TPBatState.enabled then task.wait(0.1)tpBatHookAntiDie(character)end end)function buildGui()local ROW_BG=Color3.fromRGB(12,16,26)local ROW_BORDER=Color3.fromRGB(40,90,160)local WHITE=Color3.fromRGB(245,250,255)local INP=Color3.fromRGB(10,14,22)local GUI_W,GUI_H=348,560 local BANNER_H=100 local ZEY_LOGO_FILE="ZeyHubb_vs_banner.jpg" local ZEY_LOGO_ASSET=""
local _ZEY_LOGO_B64="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"
local function _zeyB64Decode(data)
if type(data)~="string" or data=="" then return nil end
if crypt and crypt.base64 and type(crypt.base64.decode)=="function" then
local ok,r=pcall(crypt.base64.decode,data) if ok and type(r)=="string" then return r end
end
if base64 and type(base64.decode)=="function" then
local ok,r=pcall(base64.decode,data) if ok and type(r)=="string" then return r end
end
if syn and syn.crypt and syn.crypt.base64 and type(syn.crypt.base64.decode)=="function" then
local ok,r=pcall(syn.crypt.base64.decode,data) if ok and type(r)=="string" then return r end
end
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local t={} for i=1,#b do t[b:sub(i,i)]=i-1 end
data=data:gsub("%s",""):gsub("=","")
local out={}
local i=1
local n=#data
while i<=n do
local a=t[data:sub(i,i)] or 0
local c2=t[data:sub(i+1,i+1)] or 0
local c3=t[data:sub(i+2,i+2)] or 0
local c4=t[data:sub(i+3,i+3)] or 0
local n1=a*4+math.floor(c2/16)
local n2=(c2%16)*16+math.floor(c3/4)
local n3=(c3%4)*64+c4
out[#out+1]=string.char(n1%256)
if i+2<=n then out[#out+1]=string.char(n2%256) end
if i+3<=n then out[#out+1]=string.char(n3%256) end
i=i+4
end
return table.concat(out)
end
local function _zeyEnsureLogoFile()
local getAsset=getcustomasset or getsynasset
if type(writefile)~="function" then return nil end
local decoded=_zeyB64Decode(_ZEY_LOGO_B64)
if type(decoded)~="string" or #decoded<100 then return nil end
pcall(writefile,ZEY_LOGO_FILE,decoded)
if type(getAsset)=="function" then
local ok,asset=pcall(getAsset,ZEY_LOGO_FILE)
if ok and type(asset)=="string" and asset~="" then return asset end
end
return nil
end
local _zeyLogoResolved=_zeyEnsureLogoFile()
if type(_zeyLogoResolved)=="string" and _zeyLogoResolved~="" then ZEY_LOGO_ASSET=_zeyLogoResolved end
 local ACCENT=Color3.fromRGB(40,180,255)local ACCENT2=Color3.fromRGB(80,215,255)local MUTED=Color3.fromRGB(160,150,140)local GUI_NAMES={"RivalHub","RivalHubMobilePanel","RivalHubSpeedIndicator","RivalHubBootErrors"}local _okCg,_coreGui=pcall(function()return game:GetService("CoreGui")end)local _pgOld=LP:FindFirstChild("PlayerGui")for _,n in ipairs(GUI_NAMES)do if _okCg and _coreGui then local okFind,oldCg=pcall(function()return _coreGui:FindFirstChild(n)end)if okFind and oldCg then pcall(function()oldCg:Destroy()end)end end if _pgOld then local okFind2,o=pcall(function()return _pgOld:FindFirstChild(n)end)if okFind2 and o then pcall(function()o:Destroy()end)end end end gui=Instance.new("ScreenGui")gui.Name="RivalHub"gui.Enabled=false gui.ResetOnSpawn=false gui.DisplayOrder=10 gui.IgnoreGuiInset=true pcall(function()if syn and syn.protect_gui then syn.protect_gui(gui)end end)local guiOk=pcall(function()gui.Parent=game:GetService("CoreGui")end)if not guiOk then gui.Parent=LP:WaitForChild("PlayerGui")end
-- Petit son discret à chaque clic sur un bouton de l’interface.
local _zeyUiClickSound=Instance.new("Sound")
_zeyUiClickSound.Name="ZeyHubbUIClickSound"
_zeyUiClickSound.SoundId="rbxassetid://6895079853"
_zeyUiClickSound.Volume=0.68
_zeyUiClickSound.Parent=gui
local function _zeyBindClickSound(obj)
 if not obj or not (obj:IsA("TextButton") or obj:IsA("ImageButton")) or obj:GetAttribute("ZeyHubbClickSoundBound") then return end
 obj:SetAttribute("ZeyHubbClickSoundBound",true)
 obj.Activated:Connect(function()
  if not _zeyUiClickSound or not _zeyUiClickSound.Parent then return end
  _zeyUiClickSound:Stop()
  _zeyUiClickSound.TimePosition=0
  _zeyUiClickSound:Play()
 end)
end
for _,obj in ipairs(gui:GetDescendants()) do _zeyBindClickSound(obj) end
gui.DescendantAdded:Connect(function(obj) task.defer(_zeyBindClickSound,obj) end)
main=Instance.new("Frame",gui)main.Size=UDim2.new(0,GUI_W,0,GUI_H)main.Position=UDim2.fromOffset(20,40)main.BackgroundColor3=Color3.fromRGB(6,10,18)main.BackgroundTransparency=0 main.BorderSizePixel=0 main.ClipsDescendants=true main.Active=true main.Selectable=true pcall(function()local d=_G.__ZeyHubbDragFrame or drag if type(d)=="function"then d(main,BANNER_H)end end)Instance.new("UICorner",main).CornerRadius=UDim.new(0,18)local mainStroke=Instance.new("UIStroke",main)mainStroke.Name="MainAura"mainStroke.Color=Color3.fromRGB(61,148,241)mainStroke.Thickness=2.5 mainStroke.Transparency=0.12 task.spawn(function()local up=true while main and main.Parent and mainStroke and mainStroke.Parent do local goalT=up and 0.02 or 0.22 local goalTh=up and 3.0 or 2.2 local tw=TS:Create(mainStroke,TweenInfo.new(1.25,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goalT,Thickness=goalTh,Color=up and Color3.fromRGB(100,220,255)or Color3.fromRGB(56,136,224),})tw:Play()tw.Completed:Wait()up=not up end end)local mainInnerGlow=Instance.new("Frame",main)mainInnerGlow.Name="InnerGlow"mainInnerGlow.Size=UDim2.new(1,-4,1,-4)mainInnerGlow.Position=UDim2.new(0,2,0,2)mainInnerGlow.BackgroundTransparency=1 mainInnerGlow.BorderSizePixel=0 mainInnerGlow.ZIndex=1 Instance.new("UICorner",mainInnerGlow).CornerRadius=UDim.new(0,16)local innerStroke=Instance.new("UIStroke",mainInnerGlow)innerStroke.Color=Color3.fromRGB(42,120,220)innerStroke.Thickness=1 innerStroke.Transparency=0.75 local scriptHeader=Instance.new("Frame",main)scriptHeader.Name="ScriptHeader"scriptHeader.Size=UDim2.new(1,0,0,BANNER_H)scriptHeader.Position=UDim2.new(0,0,0,0)scriptHeader.BackgroundColor3=Color3.fromRGB(2,8,18)scriptHeader.BackgroundTransparency=0 scriptHeader.BorderSizePixel=0 scriptHeader.ClipsDescendants=true scriptHeader.ZIndex=20 scriptHeader.Active=true Instance.new("UICorner",scriptHeader).CornerRadius=UDim.new(0,16)
local headerLogo=Instance.new("ImageLabel",scriptHeader)headerLogo.Name="ZeyLogoBanner"headerLogo.Size=UDim2.new(1,-4,1,-2)headerLogo.Position=UDim2.new(0,2,0,1)headerLogo.BackgroundColor3=Color3.fromRGB(2,10,24)headerLogo.BackgroundTransparency=0 headerLogo.BorderSizePixel=0 headerLogo.ScaleType=Enum.ScaleType.Stretch headerLogo.ImageTransparency=0 headerLogo.ZIndex=20 headerLogo.ClipsDescendants=true headerLogo.Active=false headerLogo.Selectable=false Instance.new("UICorner",headerLogo).CornerRadius=UDim.new(0,14)
do local function resolveZeyLogo()
if type(ZEY_LOGO_ASSET)=="string" and ZEY_LOGO_ASSET~="" then return ZEY_LOGO_ASSET end
if type(_zeyLogoResolved)=="string" and _zeyLogoResolved~="" then return _zeyLogoResolved end
local again=_zeyEnsureLogoFile and _zeyEnsureLogoFile()
if type(again)=="string" and again~="" then ZEY_LOGO_ASSET=again return again end
local getAsset=getcustomasset or getsynasset
if type(getAsset)=="function" and type(isfile)=="function" and isfile(ZEY_LOGO_FILE) then
local ok,asset=pcall(getAsset,ZEY_LOGO_FILE)
if ok and type(asset)=="string" and asset~="" then return asset end
end
return ""
end
local logoImg=resolveZeyLogo()
headerLogo.BackgroundColor3=Color3.fromRGB(2,10,24)
headerLogo.BackgroundTransparency=0
if logoImg~="" then headerLogo.Image=logoImg headerLogo.ImageTransparency=0 else headerLogo.Image="" end
task.defer(function()
local img=resolveZeyLogo()
if img~="" and headerLogo and headerLogo.Parent then headerLogo.Image=img end
end)
_G.__ZeyHubbSetLogo=function(assetOrPath)
if type(assetOrPath)~="string" or assetOrPath=="" then return end
if assetOrPath:find("rbxasset") or assetOrPath:find("http") then headerLogo.Image=assetOrPath;ZEY_LOGO_ASSET=assetOrPath return end
local getAsset=getcustomasset or getsynasset
if type(getAsset)=="function" then local ok,a=pcall(getAsset,assetOrPath) if ok and a then headerLogo.Image=a end end
end
end
local headerFade=Instance.new("Frame",scriptHeader)headerFade.Name="BannerFade"headerFade.Size=UDim2.new(1,0,0,48)headerFade.Position=UDim2.new(0,0,1,-48)headerFade.BackgroundColor3=Color3.fromRGB(2,8,18)headerFade.BorderSizePixel=0 headerFade.ZIndex=21 headerFade.Active=false
local fadeGrad=Instance.new("UIGradient",headerFade)fadeGrad.Rotation=90 fadeGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.35,0.55),NumberSequenceKeypoint.new(1,0)})
local headerLine=Instance.new("Frame",scriptHeader)headerLine.Name="HeaderShine"headerLine.Size=UDim2.new(1,-24,0,2)headerLine.Position=UDim2.new(0,12,1,-2)headerLine.BackgroundColor3=Color3.fromRGB(80,215,255)headerLine.BorderSizePixel=0 headerLine.ZIndex=22 Instance.new("UICorner",headerLine).CornerRadius=UDim.new(1,0)
local hlGrad=Instance.new("UIGradient",headerLine)hlGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0.00,1),NumberSequenceKeypoint.new(0.2,0.2),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(0.8,0.2),NumberSequenceKeypoint.new(1.00,1),})
local hubTitle=Instance.new("TextLabel",scriptHeader)hubTitle.Name="HubTitle"hubTitle.Size=UDim2.new(1,-60,0,28)hubTitle.Position=UDim2.new(0,12,1,-36)hubTitle.BackgroundTransparency=1 hubTitle.Text=""hubTitle.TextColor3=Color3.fromRGB(150,235,255)hubTitle.Font=Enum.Font.GothamBlack hubTitle.TextSize=18 hubTitle.TextXAlignment=Enum.TextXAlignment.Left hubTitle.ZIndex=22 hubTitle.Visible=false
local titleGrad=Instance.new("UIGradient",hubTitle)titleGrad.Name="TitleShine"titleGrad.Rotation=0 titleGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(240,250,255)),ColorSequenceKeypoint.new(0.25,Color3.fromRGB(120,225,255)),ColorSequenceKeypoint.new(0.55,Color3.fromRGB(60,200,255)),ColorSequenceKeypoint.new(0.80,Color3.fromRGB(63,154,248)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(93,239,255)),})
local titleStroke=Instance.new("UIStroke",hubTitle)titleStroke.Name="TitleGlow"titleStroke.Color=Color3.fromRGB(50,190,255)titleStroke.Thickness=2.2 titleStroke.Transparency=0.2 scriptLogoRef=hubTitle
do
local dragHandle=scriptHeader
local dragTarget=main
local dragging=false
local dragInput=nil
local dragStart=nil
local startAbs=nil
local function getViewportSize()
local cam=workspace.CurrentCamera
if cam and cam.ViewportSize then return cam.ViewportSize end
return Vector2.new(1280,720)
end
function clampMainToScreen()
if not main or not main.Parent then return end
local vs=getViewportSize()
local w=main.AbsoluteSize.X
local h=main.AbsoluteSize.Y
if w<10 then w=GUI_W end
if h<10 then h=GUI_H end
local margin=6
local maxX=math.max(margin,vs.X-w-margin)
local maxY=math.max(margin,vs.Y-h-margin)
local abs=main.AbsolutePosition
local x=math.clamp(abs.X,margin,maxX)
local y=math.clamp(abs.Y,margin,maxY)
main.Position=UDim2.fromOffset(math.floor(x+0.5),math.floor(y+0.5))
end
_G.__ZeyHubbClampMainToScreen=clampMainToScreen
local function update(input)
if not dragging or uiLocked or not dragTarget or not dragTarget.Parent or not startAbs then return end
local delta=input.Position-dragStart
local vs=getViewportSize()
local w=dragTarget.AbsoluteSize.X
local h=dragTarget.AbsoluteSize.Y
if w<10 then w=GUI_W end
if h<10 then h=GUI_H end
local margin=6
local maxX=math.max(margin,vs.X-w-margin)
local maxY=math.max(margin,vs.Y-h-margin)
local x=math.clamp(startAbs.X+delta.X,margin,maxX)
local y=math.clamp(startAbs.Y+delta.Y,margin,maxY)
dragTarget.Position=UDim2.fromOffset(math.floor(x+0.5),math.floor(y+0.5))
end
local function beginDrag(input)
if uiLocked or _isDraggingButton then return end
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
dragging=true
dragInput=input
dragStart=input.Position
startAbs=dragTarget.AbsolutePosition
end
local function endDrag(input)
if input and dragInput and input~=dragInput then return end
if dragging then
dragging=false
dragInput=nil
startAbs=nil
pcall(clampMainToScreen)
task.defer(function()pcall(saveAllSettings)end)
end
end
dragHandle.Active=true
dragHandle.InputBegan:Connect(function(input) beginDrag(input) end)
dragHandle.InputEnded:Connect(function(input) endDrag(input) end)
UIS.InputChanged:Connect(function(input)
if input==dragInput and dragging then update(input) end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
endDrag(input)
end
end)
for _,child in ipairs(dragHandle:GetDescendants()) do
if child:IsA("GuiObject") then
child.Active=false
end
end
dragHandle.Active=true
pcall(function()
local cam=workspace.CurrentCamera
if cam then
cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
task.defer(function()pcall(clampMainToScreen)end)
end)
end
end)
task.defer(function()pcall(clampMainToScreen)end)
_G.__ZeyHubbMainWindowDragBound=true
end
 task.spawn(function()while hubTitle and hubTitle.Parent and titleGrad and titleGrad.Parent do titleGrad.Offset=Vector2.new(-1,0)local tw=TS:Create(titleGrad,TweenInfo.new(1.8,Enum.EasingStyle.Linear),{Offset=Vector2.new(1,0)})tw:Play()tw.Completed:Wait()task.wait(0.15)end end)task.spawn(function()local up=true while hubTitle and hubTitle.Parent and titleStroke and titleStroke.Parent do local goalT=up and 0.05 or 0.4 local goalTh=up and 2.8 or 1.8 local tw=TS:Create(titleStroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goalT,Thickness=goalTh})tw:Play()tw.Completed:Wait()up=not up end end)local discordTop=Instance.new("Frame",scriptHeader)discordTop.Name="DiscordTop"discordTop.Visible=false discordTop.Size=UDim2.new(0,1,0,1)discordTop.Position=UDim2.new(0,0,0,0)discordTop.BackgroundTransparency=1 discordTop.ZIndex=1 local byText=""local byLetters={}local letterW=11 for i=1,#byText do local ch=byText:sub(i,i)local lbl=Instance.new("TextLabel",discordTop)lbl.Name="L"..i lbl.Size=UDim2.new(0,letterW,1,0)lbl.Position=UDim2.new(0,(i-1)*letterW,0,0)lbl.BackgroundTransparency=1 lbl.Text=ch lbl.TextColor3=Color3.fromRGB(51,124,220)lbl.Font=Enum.Font.GothamBold lbl.TextSize=13 lbl.TextXAlignment=Enum.TextXAlignment.Center lbl.ZIndex=23 local ls=Instance.new("UIStroke",lbl)ls.Color=Color3.fromRGB(40,170,255)ls.Thickness=1.1 ls.Transparency=0.85 byLetters[i]={lbl=lbl,stroke=ls}end task.spawn(function()while discordTop and discordTop.Parent do for i,item in ipairs(byLetters)do if not(item.lbl and item.lbl.Parent)then return end item.lbl.TextColor3=Color3.fromRGB(210,245,255)item.stroke.Transparency=0.15 item.stroke.Color=Color3.fromRGB(62,151,245)task.wait(0.07)item.lbl.TextColor3=Color3.fromRGB(58,143,233)item.stroke.Transparency=0.45 task.wait(0.02)end for _,item in ipairs(byLetters)do if item.lbl and item.lbl.Parent then item.lbl.TextColor3=Color3.fromRGB(53,128,220)item.stroke.Transparency=0.75 end end task.wait(0.35)end end)local avatarFrame=Instance.new("Frame",scriptHeader)avatarFrame.Visible=false avatarFrame.Size=UDim2.new(0,1,0,1)avatarFrame.Position=UDim2.new(0,0,0,0)avatarFrame.BackgroundTransparency=1 avatarFrame.BorderSizePixel=0 avatarFrame.ZIndex=1 Instance.new("UICorner",avatarFrame).CornerRadius=UDim.new(1,0)local avStroke=Instance.new("UIStroke",avatarFrame)avStroke.Color=Color3.fromRGB(80,215,255)avStroke.Thickness=1.8 avStroke.Transparency=0.1 local avatarImg=Instance.new("ImageLabel",avatarFrame)avatarImg.Size=UDim2.new(1,2,1,2)avatarImg.Position=UDim2.new(0,-1,0,-1)avatarImg.BackgroundTransparency=1 avatarImg.Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"avatarImg.ZIndex=23 Instance.new("UICorner",avatarImg).CornerRadius=UDim.new(1,0)local displayNameLbl=Instance.new("TextLabel",scriptHeader)displayNameLbl.Visible=false displayNameLbl.Size=UDim2.new(0,1,0,1)displayNameLbl.BackgroundTransparency=1 displayNameLbl.Text=LP.DisplayName local usernameLbl=Instance.new("TextLabel",scriptHeader)usernameLbl.Visible=false usernameLbl.Size=UDim2.new(0,1,0,1)usernameLbl.BackgroundTransparency=1 usernameLbl.Text="@"..LP.Name local bgImage=Instance.new("ImageLabel",main)bgImage.Name="BackgroundImage"bgImage.Size=UDim2.new(1,0,1,0)bgImage.Position=UDim2.new(0,0,0,0)bgImage.BackgroundColor3=Color3.fromRGB(2,8,18)bgImage.BackgroundTransparency=0 bgImage.Image="" bgImage.ImageTransparency=1 bgImage.ScaleType=Enum.ScaleType.Crop bgImage.ZIndex=0 bgImage.Visible=false bgImage.ClipsDescendants=true Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,18)
task.defer(function()
local img=(type(ZEY_LOGO_ASSET)=="string" and ZEY_LOGO_ASSET~="" and ZEY_LOGO_ASSET) or (type(_zeyLogoResolved)=="string" and _zeyLogoResolved) or ""
if img=="" and type(_zeyEnsureLogoFile)=="function" then img=_zeyEnsureLogoFile() or "" end
if headerLogo and headerLogo.Parent and img~="" then headerLogo.Image=img end
end)mainUIScale=Instance.new("UIScale",main)mainUIScale.Scale=uiScaleValue/100 local closeBtn=Instance.new("TextButton",main)closeBtn.Size=UDim2.new(0,24,0,24)closeBtn.Position=UDim2.new(1,-32,0,10)closeBtn.BackgroundColor3=Color3.fromRGB(12,18,28)closeBtn.BackgroundTransparency=0.2 closeBtn.BorderSizePixel=0 closeBtn.Text="−"closeBtn.TextColor3=Color3.fromRGB(56,136,224)closeBtn.Font=Enum.Font.GothamBold closeBtn.TextSize=22 Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,8)closeBtn.AutoButtonColor=false closeBtn.ZIndex=250 closeBtn.MouseEnter:Connect(function()TS:Create(closeBtn,TweenInfo.new(0.12),{TextColor3=getThemeColor()}):Play()end)closeBtn.MouseLeave:Connect(function()TS:Create(closeBtn,TweenInfo.new(0.12),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)miniBtn=Instance.new("TextButton",gui)miniBtn.Name="MinimizedFrame"miniBtn.Size=UDim2.new(0,360,0,96)miniBtn.Position=UDim2.new(0,18,0,60)do local miniScale=Instance.new("UIScale",miniBtn)miniScale.Name="MiniScale"miniScale.Scale=130/360 end miniBtn.BackgroundColor3=Color3.fromRGB(0,0,0)miniBtn.BackgroundTransparency=0 miniBtn.BorderSizePixel=0 miniBtn.Text=""miniBtn.AutoButtonColor=false miniBtn.ZIndex=21 miniBtn.Visible=false Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,28)local miniOuterStroke=Instance.new("UIStroke",miniBtn)miniOuterStroke.Name="MiniOuterStroke"miniOuterStroke.Color=Color3.fromRGB(40,180,255)miniOuterStroke.Thickness=2.8 miniOuterStroke.Transparency=0.05 local miniInnerStroke=Instance.new("UIStroke",miniBtn)miniInnerStroke.Name="MiniInnerStroke"miniInnerStroke.Color=Color3.fromRGB(100,210,255)miniInnerStroke.Thickness=1.2 miniInnerStroke.Transparency=0.45 miniInnerStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border local ZEY_BTN_LOGO_B64="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" local function loadZeyBtnLogo()local getAsset=getcustomasset or getsynasset if type(writefile)~="function"or type(getAsset)~="function"then return""end local path="ZeyHubb_btn_logo.jpg" local function b64decode(data)if crypt and type(crypt.base64decode)=="function"then local ok,r=pcall(crypt.base64decode,data)if ok and r then return r end end if base64 and type(base64.decode)=="function"then local ok,r=pcall(base64.decode,data)if ok and r then return r end end local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"local map={}for i=1,#chars do map[chars:sub(i,i)]=i-1 end local out,n={},0 local buf,bits=0,0 for i=1,#data do local v=map[data:sub(i,i)]if v then buf=buf*64+v bits=bits+6 if bits>=8 then bits=bits-8 local byte=math.floor(buf/(2^bits))buf=buf-byte*(2^bits)n=n+1 out[n]=string.char(byte)end end end return table.concat(out)end local raw=b64decode(ZEY_BTN_LOGO_B64)if type(raw)=="string"and #raw>100 then pcall(writefile,path,raw)end local ok,asset=pcall(getAsset,path)if ok and asset and asset~=""then return asset end return""end local miniLogo=Instance.new("ImageLabel",miniBtn)miniLogo.Name="ZeyBtnLogo"miniLogo.Size=UDim2.new(1,-8,1,-8)miniLogo.Position=UDim2.new(0,4,0,4)miniLogo.BackgroundTransparency=1 miniLogo.BorderSizePixel=0 miniLogo.ScaleType=Enum.ScaleType.Fit miniLogo.ZIndex=22 Instance.new("UICorner",miniLogo).CornerRadius=UDim.new(0,24)task.spawn(function()local asset=loadZeyBtnLogo()if asset and asset~=""then miniLogo.Image=asset end end) local VABEDO_B64="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"local function loadVabedoFont()local getAsset=getcustomasset or getsynasset if type(writefile)~="function"or type(getAsset)~="function"then return nil end local ttfName,jsonName="RivalHub_Vabedo.ttf","RivalHub_Vabedo.json"local okAll,result=pcall(function()local need=true if type(isfile)=="function"then local okF,has=pcall(isfile,ttfName)if okF and has then need=false end end if need then local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"local map={}for i=1,#chars do map[chars:sub(i,i)]=i-1 end local out,n={},0 local buf,bits=0,0 for i=1,#VABEDO_B64 do local v=map[VABEDO_B64:sub(i,i)]if v then buf=buf*64+v bits=bits+6 if bits>=8 then bits=bits-8 local byte=math.floor(buf/(2^bits))buf=buf-byte*(2^bits)n=n+1 out[n]=string.char(byte)end end end local raw={}for i=1,n,4096 do raw[#raw+1]=table.concat(out,"",i,math.min(i+4095,n))end writefile(ttfName,table.concat(raw))end local fam=game:GetService("HttpService"):JSONEncode({name="Vabedo",faces={{name="Regular",weight=400,style="normal",assetId=getAsset(ttfName)}}})writefile(jsonName,fam)return Font.new(getAsset(jsonName),Enum.FontWeight.Regular,Enum.FontStyle.Normal)end)if okAll then return result end return nil end local miniTitle=Instance.new("TextLabel",miniBtn)miniTitle.Name="RivalHubTitle"miniTitle.Size=UDim2.new(0,0,0,0)miniTitle.BackgroundTransparency=1 miniTitle.Text=""miniTitle.Visible=false miniTitle.ZIndex=1 local _mainAnimating=false local mainOriginalPos=main.Position _G.__RivalHubMainOriginalPos=mainOriginalPos main:GetPropertyChangedSignal("Position"):Connect(function()if not _mainAnimating then mainOriginalPos=main.Position _G.__RivalHubMainOriginalPos=mainOriginalPos end end)local animScale=Instance.new("UIScale",main)animScale.Scale=1 local _openTween,_closeTween=nil,nil showGui=function()if not main then return end if _openTween then _openTween:Cancel()end if _closeTween then _closeTween:Cancel()end _mainAnimating=true main.Visible=true miniBtn.Visible=false main.Position=UDim2.new(mainOriginalPos.X.Scale,mainOriginalPos.X.Offset-60,mainOriginalPos.Y.Scale,mainOriginalPos.Y.Offset)animScale.Scale=0.5 local info=TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)_openTween=TS:Create(main,info,{Position=mainOriginalPos})TS:Create(animScale,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()_openTween:Play()_openTween.Completed:Connect(function()_openTween=nil _mainAnimating=false pcall(function()if clampMainToScreen then clampMainToScreen()elseif _G.__ZeyHubbClampMainToScreen then _G.__ZeyHubbClampMainToScreen()end end)end)end hideGui=function()if not main or not main.Visible then return end if _openTween then _openTween:Cancel()end if _closeTween then _closeTween:Cancel()end _mainAnimating=true local targetPos=UDim2.new(mainOriginalPos.X.Scale,mainOriginalPos.X.Offset-60,mainOriginalPos.Y.Scale,mainOriginalPos.Y.Offset)local info=TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In)_closeTween=TS:Create(main,info,{Position=targetPos})TS:Create(animScale,TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Scale=0.5}):Play()_closeTween:Play()_closeTween.Completed:Connect(function()main.Visible=false miniBtn.Visible=true _closeTween=nil _mainAnimating=false end)end closeBtn.Activated:Connect(hideGui)miniBtn.Activated:Connect(showGui)local TAB_H=36 local tabBar=Instance.new("Frame",main)tabBar.Name="TopTabBar"tabBar.Visible=true tabBar.Size=UDim2.new(1,-12,0,TAB_H)tabBar.Position=UDim2.new(0,6,0,BANNER_H+4)tabBar.BackgroundColor3=Color3.fromRGB(8,14,24)tabBar.BackgroundTransparency=0.12 tabBar.BorderSizePixel=0 tabBar.ClipsDescendants=true tabBar.ZIndex=15 Instance.new("UICorner",tabBar).CornerRadius=UDim.new(0,12)local barStroke=Instance.new("UIStroke",tabBar)barStroke.Color=Color3.fromRGB(62,153,246)barStroke.Thickness=1.8 barStroke.Transparency=0.18 local tabLayout=Instance.new("UIListLayout",tabBar)tabLayout.FillDirection=Enum.FillDirection.Horizontal tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center tabLayout.SortOrder=Enum.SortOrder.LayoutOrder tabLayout.Padding=UDim.new(0,5)local tabPad=Instance.new("UIPadding",tabBar)tabPad.PaddingLeft=UDim.new(0,4)tabPad.PaddingRight=UDim.new(0,4)tabPad.PaddingTop=UDim.new(0,3)tabPad.PaddingBottom=UDim.new(0,3)local tabContent=Instance.new("Frame",main)tabContent.Name="TabContent"tabContent.Size=UDim2.new(1,-12,1,-(BANNER_H+TAB_H+14))tabContent.Position=UDim2.new(0,6,0,BANNER_H+TAB_H+8)tabContent.BackgroundColor3=Color3.fromRGB(8,12,22)tabContent.BackgroundTransparency=0.15 tabContent.BorderSizePixel=0 tabContent.ClipsDescendants=true tabContent.ZIndex=5 Instance.new("UICorner",tabContent).CornerRadius=UDim.new(0,12)local contentStroke=Instance.new("UIStroke",tabContent)contentStroke.Color=Color3.fromRGB(70,200,255)contentStroke.Thickness=1.7 contentStroke.Transparency=0.25 local tabs={"Speed","Combat","Visual","Settings"}local tabIcons={}local tabPageKey={Speed="Speed",Combat="Combat",Visual="Visual",Settings="Settings"}tabButtons={}local contentPages={}local function styleTabInactive(b)local ul=b:FindFirstChild("Underline")if ul then ul.Visible=false end b.BackgroundColor3=Color3.fromRGB(12,18,28)b.BackgroundTransparency=0.25 b.TextColor3=Color3.fromRGB(90,160,220)local bs=b:FindFirstChild("TabStroke")if bs then bs.Transparency=0.5 bs.Color=Color3.fromRGB(40,120,200)bs.Thickness=1.2 end local tg=b:FindFirstChild("TabBgGrad")if tg then tg.Enabled=false end local ts=b:FindFirstChild("TabTextStroke")if ts then ts.Transparency=0.85;ts.Thickness=0.8 end end local function styleTabActive(b)local ul=b:FindFirstChild("Underline")if ul then ul.Visible=true ul.BackgroundColor3=Color3.fromRGB(140,235,255)end b.BackgroundColor3=Color3.fromRGB(40,180,255)b.BackgroundTransparency=0.08 b.TextColor3=Color3.fromRGB(255,252,240)local bs=b:FindFirstChild("TabStroke")if bs then bs.Transparency=0 bs.Color=Color3.fromRGB(140,235,255)bs.Thickness=2 end local tg=b:FindFirstChild("TabBgGrad")if tg then tg.Enabled=true tg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(210,245,255)),ColorSequenceKeypoint.new(0.40,Color3.fromRGB(56,137,225)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(37,120,220)),})end local ts=b:FindFirstChild("TabTextStroke")if not ts then ts=Instance.new("UIStroke",b)ts.Name="TabTextStroke"ts.ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual end ts.Color=Color3.fromRGB(60,195,255)ts.Thickness=1.2 ts.Transparency=0.35 end for i,name in ipairs(tabs)do local btn=Instance.new("TextButton",tabBar)btn.Name="Tab_"..name local _tabAvail=(GUI_W-12)-8-3*(#tabs-1);local _tabW=math.max(40,math.floor(_tabAvail/#tabs));btn.Size=UDim2.new(0,_tabW,1,-8)btn.LayoutOrder=i btn.BackgroundColor3=Color3.fromRGB(12,18,28)btn.BackgroundTransparency=0.3 btn.BorderSizePixel=0 btn.Text=name btn.TextColor3=Color3.fromRGB(120,180,230)btn.Font=Enum.Font.GothamBold btn.TextSize=12 btn.TextTruncate=Enum.TextTruncate.AtEnd btn.ClipsDescendants=true btn.AutoButtonColor=false btn.ZIndex=16 Instance.new("UICorner",btn).CornerRadius=UDim.new(0,12)local tabBgGrad=Instance.new("UIGradient",btn)tabBgGrad.Name="TabBgGrad"tabBgGrad.Rotation=90 tabBgGrad.Enabled=false local tabStroke=Instance.new("UIStroke",btn)tabStroke.Name="TabStroke"tabStroke.Color=Color3.fromRGB(40,110,190)tabStroke.Thickness=1.2 tabStroke.Transparency=0.55 local underline=Instance.new("Frame",btn)underline.Name="Underline"underline.Size=UDim2.new(0.7,0,0,2)underline.Position=UDim2.new(0.5,0,1,-2)underline.AnchorPoint=Vector2.new(0.5,1)underline.BackgroundColor3=Color3.fromRGB(100,220,255)underline.BorderSizePixel=0 underline.Visible=false underline.ZIndex=17 Instance.new("UICorner",underline).CornerRadius=UDim.new(1,0)local page=Instance.new("ScrollingFrame",tabContent)page.Name="Page_"..name page.Size=UDim2.new(1,-10,1,-10)page.Position=UDim2.new(0,5,0,5)page.BackgroundTransparency=1 page.BorderSizePixel=0 page.ClipsDescendants=true page.ScrollBarThickness=3 page.ScrollBarImageColor3=Color3.fromRGB(55,190,255)page.ScrollBarImageTransparency=0.25 page.CanvasSize=UDim2.new(0,0,0,0)page.AutomaticCanvasSize=Enum.AutomaticSize.Y page.ScrollingDirection=Enum.ScrollingDirection.Y page.ZIndex=6 page.Visible=(i==1)local layout=Instance.new("UIListLayout",page)layout.SortOrder=Enum.SortOrder.LayoutOrder layout.Padding=UDim.new(0,4)local pagePad=Instance.new("UIPadding",page)pagePad.PaddingTop=UDim.new(0,4)pagePad.PaddingLeft=UDim.new(0,4)pagePad.PaddingRight=UDim.new(0,8)pagePad.PaddingBottom=UDim.new(0,10)local pageKey=tabPageKey[name]or name contentPages[pageKey]=page btn:SetAttribute("PageKey",pageKey)btn.Activated:Connect(function()for _,pg2 in pairs(contentPages)do pg2.Visible=false end page.Visible=true for _,b in ipairs(tabButtons)do styleTabInactive(b)end styleTabActive(btn)end)btn.MouseEnter:Connect(function()if btn:FindFirstChild("Underline")and btn.Underline.Visible then return end TS:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0.15,TextColor3=Color3.fromRGB(87,226,255)}):Play()local bs=btn:FindFirstChild("TabStroke")if bs then TS:Create(bs,TweenInfo.new(0.12),{Transparency=0.35,Color=Color3.fromRGB(55,190,255)}):Play()end end)btn.MouseLeave:Connect(function()if btn:FindFirstChild("Underline")and btn.Underline.Visible then return end styleTabInactive(btn)end)table.insert(tabButtons,btn)end if tabButtons[1]then styleTabActive(tabButtons[1])end local pageCounters={}local function getNextOrder(page)if not pageCounters[page]then pageCounters[page]=0 end pageCounters[page]=pageCounters[page]+1 return pageCounters[page]end local function mkSect(page,txt)if not page then return nil end local f=Instance.new("Frame",page)f.Size=UDim2.new(1,-4,0,26)f.BackgroundTransparency=1 f.BorderSizePixel=0 f.ClipsDescendants=true f.LayoutOrder=getNextOrder(page)f.ZIndex=7 local accent=Instance.new("Frame",f)accent.Name="SectAccent"accent.Size=UDim2.new(0,3,0,14)accent.Position=UDim2.new(0,2,0.5,0)accent.AnchorPoint=Vector2.new(0,0.5)accent.BackgroundColor3=Color3.fromRGB(80,215,255)accent.BorderSizePixel=0 accent.ZIndex=8 Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)local l=Instance.new("TextLabel",f)l.Size=UDim2.new(1,-16,1,0)l.Position=UDim2.new(0,12,0,0)l.BackgroundTransparency=1 l.Text=string.upper(txt)l.TextColor3=Color3.fromRGB(90,215,255)l.Font=Enum.Font.GothamBlack l.TextSize=11 l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=8 local line=Instance.new("Frame",f)line.Size=UDim2.new(1,-100,0,1)line.Position=UDim2.new(1,-8,0.5,0)line.AnchorPoint=Vector2.new(1,0.5)line.BackgroundColor3=Color3.fromRGB(40,180,255)line.BackgroundTransparency=0.7 line.BorderSizePixel=0 line.ZIndex=8 return f end local function mkRow(page,h)if not page then return Instance.new("Frame")end local f=Instance.new("Frame",page)f.Size=UDim2.new(1,-4,0,h or 40)f.BackgroundColor3=ROW_BG f.BackgroundTransparency=0.12 f.BorderSizePixel=0 f.ClipsDescendants=true f.LayoutOrder=getNextOrder(page)f.ZIndex=7 Instance.new("UICorner",f).CornerRadius=UDim.new(0,11)local rowGrad=Instance.new("UIGradient",f)rowGrad.Name="RowGrad"rowGrad.Rotation=90 rowGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(22,30,48)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(14,18,30)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(8,12,20)),})local stroke=Instance.new("UIStroke",f)stroke.Name="RowStroke"stroke.Color=Color3.fromRGB(70,200,255)stroke.Thickness=1.5 stroke.Transparency=0.28 return f end local function mkLabel(row,txt)local l=Instance.new("TextLabel",row)l.Size=UDim2.new(1,-88,1,0)l.Position=UDim2.new(0,10,0,0)l.BackgroundTransparency=1 l.Text=txt l.TextColor3=Color3.fromRGB(230,240,255)l.Font=Enum.Font.GothamBold l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.TextTruncate=Enum.TextTruncate.AtEnd l.ZIndex=8 return l end local function mkPill(row,offset)local pill=Instance.new("Frame",row)pill.Name="Track"pill.Size=UDim2.new(0,24,0,24)pill.AnchorPoint=Vector2.new(1,0.5)pill.Position=UDim2.new(1,-11,0.5,0)pill.BackgroundColor3=Color3.fromRGB(14,14,16)pill.BorderSizePixel=0 pill.ZIndex=8 Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)local trackStroke=Instance.new("UIStroke",pill)trackStroke.Name="TrackStroke"trackStroke.Color=Color3.fromRGB(50,50,55)trackStroke.Thickness=1.8 trackStroke.Transparency=0.2 local glow=Instance.new("Frame",pill)glow.Name="Glow"glow.Size=UDim2.new(1,10,1,10)glow.Position=UDim2.new(0.5,0,0.5,0)glow.AnchorPoint=Vector2.new(0.5,0.5)glow.BackgroundTransparency=1 glow.ZIndex=7 Instance.new("UICorner",glow).CornerRadius=UDim.new(1,0)local glowStroke=Instance.new("UIStroke",glow)glowStroke.Name="GlowStroke"glowStroke.Color=Color3.fromRGB(70,210,255)glowStroke.Thickness=3 glowStroke.Transparency=1 local dot=Instance.new("Frame",pill)dot.Name="Knob"dot.Size=UDim2.new(1,-8,1,-8)dot.AnchorPoint=Vector2.new(0.5,0.5)dot.Position=UDim2.new(0.5,0,0.5,0)dot.BackgroundColor3=Color3.fromRGB(32,32,36)dot.BorderSizePixel=0 dot.ZIndex=9 Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)local coreGrad=Instance.new("UIGradient",dot)coreGrad.Name="KnobGrad"coreGrad.Rotation=135 coreGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(50,50,55)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(20,20,24)),})local dotStroke=Instance.new("UIStroke",dot)dotStroke.Name="KnobStroke"dotStroke.Color=Color3.fromRGB(45,45,50)dotStroke.Thickness=1 dotStroke.Transparency=0.5 local shine=Instance.new("Frame",dot)shine.Name="Spec"shine.Size=UDim2.new(0.55,0,0.35,0)shine.Position=UDim2.new(0.2,0,0.12,0)shine.BackgroundColor3=Color3.fromRGB(255,255,255)shine.BackgroundTransparency=0.75 shine.BorderSizePixel=0 shine.ZIndex=10 Instance.new("UICorner",shine).CornerRadius=UDim.new(1,0)return pill,dot end local function animPill(pill,dot,on)local dotStroke=dot:FindFirstChild("KnobStroke")local trackStroke=pill:FindFirstChild("TrackStroke")local glow=pill:FindFirstChild("Glow")local glowStroke=glow and glow:FindFirstChild("GlowStroke")local coreGrad=dot:FindFirstChild("KnobGrad")local shine=dot:FindFirstChild("Spec")local fadeInfo=TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)if on then TS:Create(pill,fadeInfo,{BackgroundColor3=Color3.fromRGB(50,121,220)}):Play()TS:Create(dot,fadeInfo,{BackgroundColor3=Color3.fromRGB(67,164,255)}):Play()if coreGrad then coreGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,250,220)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(80,215,255)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(39,120,220)),})end if trackStroke then TS:Create(trackStroke,fadeInfo,{Color=Color3.fromRGB(140,235,255),Transparency=0,Thickness=2.2,}):Play()end if glowStroke then TS:Create(glowStroke,fadeInfo,{Color=Color3.fromRGB(60,195,255),Transparency=0.35,Thickness=4,}):Play()end if dotStroke then TS:Create(dotStroke,fadeInfo,{Color=Color3.fromRGB(200,245,255),Transparency=0.15,}):Play()end if shine then TS:Create(shine,fadeInfo,{BackgroundTransparency=0.35}):Play()end else TS:Create(pill,fadeInfo,{BackgroundColor3=Color3.fromRGB(14,14,16)}):Play()TS:Create(dot,fadeInfo,{BackgroundColor3=Color3.fromRGB(32,32,36)}):Play()if coreGrad then coreGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(50,50,55)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(20,20,24)),})end if trackStroke then TS:Create(trackStroke,fadeInfo,{Color=Color3.fromRGB(50,50,55),Transparency=0.2,Thickness=1.8,}):Play()end if glowStroke then TS:Create(glowStroke,fadeInfo,{Transparency=1,Thickness=3}):Play()end if dotStroke then TS:Create(dotStroke,fadeInfo,{Color=Color3.fromRGB(45,45,50),Transparency=0.5,}):Play()end if shine then TS:Create(shine,fadeInfo,{BackgroundTransparency=0.75}):Play()end end end local function mkToggle(page,txt,cb)local row=mkRow(page,42)mkLabel(row,txt)local pill,dot=mkPill(row,62)local on=false local rowStroke=row:FindFirstChild("RowStroke")local function sv(s)on=s;animPill(pill,dot,s)if rowStroke then local info=TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)if s then TS:Create(rowStroke,info,{Color=Color3.fromRGB(105,230,255),Transparency=0,Thickness=2.4}):Play()else TS:Create(rowStroke,info,{Color=Color3.fromRGB(70,200,255),Transparency=0.28,Thickness=1.5}):Play()end end end local clk=Instance.new("TextButton",pill)clk.Size=UDim2.new(1,0,1,0)clk.BackgroundTransparency=1 clk.Text=""clk.AutoButtonColor=false clk.ZIndex=10 clk.Activated:Connect(function()on=not on sv(on)pcall(cb,on)task.defer(function()pcall(saveAllSettings)end)end)return sv,row end local function mkSelector(parent,default,options,cb)local container=Instance.new("Frame",parent)container.Size=UDim2.new(0,148,1,0)container.Position=UDim2.new(1,-154,0,0)container.ClipsDescendants=true;container.BackgroundTransparency=1 container.ZIndex=8 local function styleArrow(btn,stroke)local grad=Instance.new("UIGradient",btn)grad.Rotation=90 grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(62,153,246)),ColorSequenceKeypoint.new(1,Color3.fromRGB(37,120,220))})local sc=Instance.new("UIScale",btn)sc.Scale=1 btn.MouseEnter:Connect(function()TS:Create(sc,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1.1}):Play()TS:Create(stroke,TweenInfo.new(0.12),{Transparency=0,Thickness=1.9}):Play()end)btn.MouseLeave:Connect(function()TS:Create(sc,TweenInfo.new(0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1}):Play()TS:Create(stroke,TweenInfo.new(0.14),{Transparency=0.05,Thickness=1.4}):Play()end)return sc end local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=Color3.fromRGB(50,130,240)leftBtn.BackgroundTransparency=0.02 leftBtn.BorderSizePixel=0 leftBtn.Text="‹"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=15 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,7)local leftStroke=Instance.new("UIStroke",leftBtn)leftStroke.Color=Color3.fromRGB(105,225,255)leftStroke.Thickness=1.4 leftStroke.Transparency=0.05 local leftScale=styleArrow(leftBtn,leftStroke)local label=Instance.new("TextLabel",container)label.Size=UDim2.new(0,80,0,26)label.Position=UDim2.new(0.5,-40,0.5,-13)label.BackgroundColor3=Color3.fromRGB(14,18,28)label.BackgroundTransparency=0.05 label.Text=default label.TextColor3=Color3.fromRGB(200,230,255)label.Font=Enum.Font.GothamBold label.TextSize=12 label.TextXAlignment=Enum.TextXAlignment.Center label.ZIndex=9 Instance.new("UICorner",label).CornerRadius=UDim.new(0,6)local labelStroke=Instance.new("UIStroke",label)labelStroke.Color=Color3.fromRGB(53,128,220)labelStroke.Thickness=1.2 labelStroke.Transparency=0.15 local leftDivider=Instance.new("Frame",container)leftDivider.Name="SelectorDividerLeft"leftDivider.Size=UDim2.new(0,2,0,18)leftDivider.Position=UDim2.new(0,31,0.5,-9)leftDivider.BackgroundColor3=Color3.fromRGB(61,150,243)leftDivider.BorderSizePixel=0 leftDivider.ZIndex=10 local rightDivider=Instance.new("Frame",container)rightDivider.Name="SelectorDividerRight"rightDivider.Size=UDim2.new(0,2,0,18)rightDivider.Position=UDim2.new(1,-31,0.5,-9)rightDivider.BackgroundColor3=Color3.fromRGB(61,150,243)rightDivider.BorderSizePixel=0 rightDivider.ZIndex=10 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=Color3.fromRGB(50,130,240)rightBtn.BackgroundTransparency=0.02 rightBtn.BorderSizePixel=0 rightBtn.Text="›"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=15 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,7)local rightStroke=Instance.new("UIStroke",rightBtn)rightStroke.Color=Color3.fromRGB(105,225,255)rightStroke.Thickness=1.4 rightStroke.Transparency=0.05 local rightScale=styleArrow(rightBtn,rightStroke)local function updateLabel(newText)label.Text=newText end local function pressAnim(sc)TS:Create(sc,TweenInfo.new(0.07,Enum.EasingStyle.Quad),{Scale=0.88}):Play()task.delay(0.07,function()if sc and sc.Parent then TS:Create(sc,TweenInfo.new(0.12,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)end leftBtn.Activated:Connect(function()pressAnim(leftScale)if cb then cb(-1,updateLabel);task.defer(function()pcall(saveAllSettings)end)end end)rightBtn.Activated:Connect(function()pressAnim(rightScale)if cb then cb(1,updateLabel);task.defer(function()pcall(saveAllSettings)end)end end)return label end local function mkToggleSelector(page,txt,cb,options,getKey,onSelect)local sv,row=mkToggle(page,txt,cb)local n=#options local arrow=Instance.new("TextButton",row)arrow.Name="SelectorArrow"arrow.Size=UDim2.new(0,36,0,30)arrow.AnchorPoint=Vector2.new(1,0.5)arrow.Position=UDim2.new(1,-66,0.5,0)arrow.BackgroundColor3=Color3.fromRGB(50,123,220)arrow.BackgroundTransparency=0 arrow.BorderSizePixel=0 arrow.Text="▼"arrow.Font=Enum.Font.GothamBlack arrow.TextSize=15 arrow.TextColor3=Color3.fromRGB(230,250,255)arrow.TextStrokeColor3=Color3.fromRGB(23,85,150)arrow.TextStrokeTransparency=0.3 arrow.AutoButtonColor=false arrow.ZIndex=14 arrow.ClipsDescendants=true Instance.new("UICorner",arrow).CornerRadius=UDim.new(0,9)local arrowGrad=Instance.new("UIGradient",arrow)arrowGrad.Rotation=90 arrowGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(140,235,255)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(50,190,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,120,220))})local arrowStroke=Instance.new("UIStroke",arrow)arrowStroke.Thickness=1.9 arrowStroke.Color=Color3.fromRGB(130,230,255)arrowStroke.Transparency=0.05 local arrowScale=Instance.new("UIScale",arrow)arrowScale.Scale=1 local shineFx=Instance.new("Frame",arrow)shineFx.Name="ArrowShineFx"shineFx.Size=UDim2.new(0.55,0,1.4,0)shineFx.Position=UDim2.new(-0.6,0,-0.2,0)shineFx.BackgroundColor3=Color3.fromRGB(240,250,255)shineFx.BackgroundTransparency=0.55 shineFx.BorderSizePixel=0 shineFx.ZIndex=15 shineFx.Rotation=18 Instance.new("UICorner",shineFx).CornerRadius=UDim.new(0,6)local shineGrad=Instance.new("UIGradient",shineFx)shineGrad.Rotation=90 shineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.2),NumberSequenceKeypoint.new(1,1)})task.spawn(function()while arrow and arrow.Parent and shineFx and shineFx.Parent do shineFx.Position=UDim2.new(-0.7,0,-0.2,0)local tw=TS:Create(shineFx,TweenInfo.new(1.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(1.15,0,-0.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.5)end end)arrow.MouseEnter:Connect(function()TS:Create(arrowScale,TweenInfo.new(0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1.1}):Play()TS:Create(arrowStroke,TweenInfo.new(0.14),{Transparency=0,Thickness=2.4}):Play()end)arrow.MouseLeave:Connect(function()TS:Create(arrowScale,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1}):Play()TS:Create(arrowStroke,TweenInfo.new(0.16),{Transparency=0.05,Thickness=1.9}):Play()end)local dd=Instance.new("Frame",page)dd.Name="SelectorOptions"dd.Size=UDim2.new(1,-4,0,0)dd.BackgroundColor3=Color3.fromRGB(18,10,3)dd.BackgroundTransparency=0.02 dd.BorderSizePixel=0 dd.LayoutOrder=getNextOrder(page)dd.Visible=false dd.ClipsDescendants=true dd.ZIndex=7 Instance.new("UICorner",dd).CornerRadius=UDim.new(0,11)local ddStroke=Instance.new("UIStroke",dd)ddStroke.Thickness=1.6 ddStroke.Color=Color3.fromRGB(65,195,255)ddStroke.Transparency=0.08 local ddShine=Instance.new("UIGradient",dd)ddShine.Rotation=0 ddShine.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.4,Color3.fromRGB(67,162,255)),ColorSequenceKeypoint.new(0.6,Color3.fromRGB(40,22,8)),ColorSequenceKeypoint.new(1,Color3.fromRGB(61,148,241))})ddShine.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.94),NumberSequenceKeypoint.new(0.45,0.6),NumberSequenceKeypoint.new(0.65,0.94),NumberSequenceKeypoint.new(1,0.98)})task.spawn(function()while dd and dd.Parent do if dd.Visible then ddShine.Offset=Vector2.new(-1.2,0)local tw=TS:Create(ddShine,TweenInfo.new(1.5,Enum.EasingStyle.Linear),{Offset=Vector2.new(1.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.3)else task.wait(0.4)end end end)local slider=Instance.new("Frame",dd)slider.Size=UDim2.new(1/n,-6,1,-8)slider.BackgroundColor3=Color3.fromRGB(48,120,220)slider.BackgroundTransparency=0.02 slider.BorderSizePixel=0 slider.ZIndex=8 Instance.new("UICorner",slider).CornerRadius=UDim.new(0,9)local sliderGrad=Instance.new("UIGradient",slider)sliderGrad.Rotation=90 sliderGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(100,220,255)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(51,124,220)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,120,220))})local sliderStroke=Instance.new("UIStroke",slider)sliderStroke.Color=Color3.fromRGB(160,240,255)sliderStroke.Thickness=1.6 sliderStroke.Transparency=0.05 local labels={}local function selIndex()local cur=getKey()for i,o in ipairs(options)do if o[1]==cur then return i end end return 1 end local function paint(animate)local selTxt=Color3.fromRGB(255,250,225)local idx=selIndex()local pos=UDim2.new((idx-1)/n,3,0,4)slider.BackgroundColor3=Color3.fromRGB(48,120,220)sliderStroke.Color=Color3.fromRGB(160,240,255)sliderStroke.Transparency=0.05 ddStroke.Color=Color3.fromRGB(65,195,255)ddStroke.Transparency=0.08 arrowStroke.Color=Color3.fromRGB(130,230,255)arrow.TextColor3=Color3.fromRGB(230,250,255)if animate then TS:Create(slider,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=pos}):Play()TS:Create(sliderStroke,TweenInfo.new(0.18),{Transparency=0,Thickness=2}):Play()task.delay(0.2,function()if sliderStroke and sliderStroke.Parent then TS:Create(sliderStroke,TweenInfo.new(0.25),{Transparency=0.05,Thickness=1.6}):Play()end end)else slider.Position=pos end for i,l in ipairs(labels)do if i==idx then l.TextColor3=selTxt l.TextTransparency=0 l.TextStrokeTransparency=0.55 else l.TextColor3=Color3.fromRGB(83,217,255)l.TextTransparency=0 l.TextStrokeTransparency=1 end end end for i,o in ipairs(options)do local lbl=Instance.new("TextLabel",dd)lbl.Size=UDim2.new(1/n,0,1,0)lbl.Position=UDim2.new((i-1)/n,0,0,0)lbl.BackgroundTransparency=1 lbl.Text=string.upper(tostring(o[2]))lbl.Font=Enum.Font.GothamBlack lbl.TextSize=12 lbl.TextStrokeColor3=Color3.fromRGB(0,0,0)lbl.ZIndex=9 labels[i]=lbl local b=Instance.new("TextButton",dd)b.Size=UDim2.new(1/n,0,1,0)b.Position=UDim2.new((i-1)/n,0,0,0)b.BackgroundTransparency=1 b.Text=""b.AutoButtonColor=false b.ZIndex=11 b.Activated:Connect(function()pcall(onSelect,o[1])paint(true)task.defer(function()pcall(saveAllSettings)end)end)end for i=1,n-1 do local separator=Instance.new("Frame",dd)separator.Name="OptionSeparator"separator.Size=UDim2.new(0,2,1,-12)separator.Position=UDim2.new(i/n,-1,0,6)separator.BackgroundColor3=Color3.fromRGB(62,151,245)separator.BackgroundTransparency=0.08 separator.BorderSizePixel=0 separator.ZIndex=12 end paint(false)local open,tw=false,nil arrow.Activated:Connect(function()open=not open if tw then tw:Cancel()end TS:Create(arrowScale,TweenInfo.new(0.08,Enum.EasingStyle.Quad),{Scale=0.9}):Play()task.delay(0.08,function()if arrowScale and arrowScale.Parent then TS:Create(arrowScale,TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)if open then paint(false)dd.Visible=true arrow.Text="▲"arrowStroke.Transparency=0 arrowGrad.Rotation=270 TS:Create(arrowStroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(160,240,255),Thickness=2.3}):Play()tw=TS:Create(dd,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(1,-4,0,42)})tw:Play()else arrow.Text="▼"arrowStroke.Transparency=0.05 arrowGrad.Rotation=90 TS:Create(arrowStroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(130,230,255),Thickness=1.9}):Play()tw=TS:Create(dd,TweenInfo.new(0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.new(1,-4,0,0)})tw.Completed:Connect(function()if not open then dd.Visible=false end end)tw:Play()end end)return sv,function()paint(false)end end local function mkBox(parent,default,w,xOff,cb)local tb=Instance.new("TextBox",parent)local bw=w or 50 local xo=math.max(xOff or 56,bw+12)tb.Size=UDim2.new(0,bw,0,24)tb.Position=UDim2.new(1,-xo,0.5,-12)tb.BackgroundColor3=INP tb.BackgroundTransparency=0.7 tb.BorderSizePixel=0 tb.Text=tostring(default)tb.TextColor3=WHITE tb.Font=Enum.Font.GothamMedium tb.TextSize=11 tb.ClearTextOnFocus=false tb.ZIndex=8 Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)local bs=Instance.new("UIStroke",tb)bs.Color=ROW_BORDER bs.Thickness=1.2 bs.Transparency=0.25 tb.Focused:Connect(function()TS:Create(bs,TweenInfo.new(0.12),{Color=getThemeColor(),Transparency=0}):Play()end)tb.FocusLost:Connect(function()TS:Create(bs,TweenInfo.new(0.12),{Color=ROW_BORDER,Transparency=0.25}):Play()if cb then local n=tonumber(tb.Text)if n then cb(n)else tb.Text=tostring(default)end task.defer(function()saveAllSettings()end)end end)return tb end local function mkKeyButton(parent,kbEntry)local btn=Instance.new("TextButton",parent)btn.Size=UDim2.new(0,80,0,60)btn.Position=UDim2.new(1,-88,0.5,-30)btn.BackgroundColor3=INP btn.BackgroundTransparency=0.5 btn.BorderSizePixel=0 local function getLabel()return(kbEntry.gp and kbEntry.gp.Name)or(kbEntry.kb and kbEntry.kb.Name)or"None"end btn.Text=getLabel()btn.TextColor3=WHITE btn.Font=Enum.Font.GothamBold btn.TextWrapped=true btn.TextSize=11 btn.ZIndex=8 btn.AutoButtonColor=false Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)local bs=Instance.new("UIStroke",btn)bs.Color=ROW_BORDER bs.Thickness=1 local li=false;local lc;local pv=btn.Text;local listenStart=0 btn.Activated:Connect(function()if li then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=WHITE;return end pv=btn.Text;li=true;_anyKeyListening=true;listenStart=_tick();btn.Text="...";btn.TextColor3=WHITE lc=UIS.InputBegan:Connect(function(inp)if not li then return end if inp.KeyCode==Enum.KeyCode.Escape then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=WHITE;return end local isGp=isGamepadInput(inp)if isGp and _tick()-listenStart<0.15 then return end if not isBindableInput(inp)then return end btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;btn.TextColor3=WHITE li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end if isGp then kbEntry.gp=inp.KeyCode;kbEntry.kb=nil else kbEntry.kb=inp.KeyCode;kbEntry.gp=nil end task.defer(function()saveAllSettings()end)end)end)table.insert(keyButtonRefs,{btn=btn,entry=kbEntry})return btn end local function addKeybindRow(page,labelText,kbEntry)local row=mkRow(page,60)mkLabel(row,labelText)mkKeyButton(row,kbEntry)end local speedPage=contentPages["Speed"]if not speedPage then speedPage=contentPages["Settings"]end mkSect(speedPage,"Speeds")do local row=mkRow(speedPage,42);mkLabel(row,"Normal Speed");normalBox=mkBox(row,NS,50,56,function(v)if v==v and v>0 and v<math.huge then NS=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end do local row=mkRow(speedPage,42);mkLabel(row,"Carry Speed");carryBox=mkBox(row,CS,50,56,function(v)if v==v and v>0 and v<math.huge then CS=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end do local row=mkRow(speedPage,42);mkLabel(row,"Lagger Normal Speed");laggerBox=mkBox(row,LAGGER_SPEED,50,56,function(v)if v==v and v>0 and v<math.huge then LAGGER_SPEED=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end do local row=mkRow(speedPage,42);mkLabel(row,"Lagger Carry Speed");lagger2Box=mkBox(row,LAGGER_CARRY_SPEED,50,56,function(v)if v==v and v>0 and v<math.huge then LAGGER_CARRY_SPEED=v;if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end end)end mkSect(speedPage,"Mode")do local row=mkRow(speedPage,42)mkLabel(row,"Current Mode")modeValLbl=Instance.new("TextLabel",row)modeValLbl.Size=UDim2.new(0,110,1,0)modeValLbl.Position=UDim2.new(1,-118,0,0)modeValLbl.BackgroundTransparency=1 modeValLbl.Text="Normal"modeValLbl.TextColor3=WHITE modeValLbl.Font=Enum.Font.GothamBold modeValLbl.TextSize=12 modeValLbl.TextXAlignment=Enum.TextXAlignment.Right modeValLbl.ZIndex=8 local clk=Instance.new("TextButton",row)clk.Size=UDim2.new(1,0,1,0)clk.BackgroundTransparency=1 clk.Text=""clk.AutoButtonColor=false clk.ZIndex=8 clk.Activated:Connect(function()toggleCarryMode()end)end mkSect(speedPage,"Auto Move")autoLeftSetVisual=mkToggle(speedPage,"Auto Left",function(on)autoLeftEnabled=on if on then startAutoLeft()else stopAutoLeft()end if mobSetAutoLeft then mobSetAutoLeft(on)end end)autoRightSetVisual=mkToggle(speedPage,"Auto Right",function(on)autoRightEnabled=on if on then startAutoRight()else stopAutoRight()end if mobSetAutoRight then mobSetAutoRight(on)end end)mkSect(speedPage,"Float")_G.__RivalHubFloatSetVisual=mkToggle(speedPage,"Float",function(on)if on then _G.__RivalHubFloat.enable()else _G.__RivalHubFloat.disable()end if mobSetFloat then mobSetFloat(on)end end)mkSect(speedPage,"Infinite Jump")infJumpSetVisual=mkToggle(speedPage,"Infinite Jump",function(on)if on then InfiniteJump.start()else InfiniteJump.stop()end end)do local row=mkRow(speedPage,42)mkLabel(row,"Jump Mode")local modes={"hold","manual"}local modeIdx=1 for i,m in ipairs(modes)do if m==(InfiniteJump.mode or"hold")then modeIdx=i break end end local selWrap=Instance.new("Frame",row)selWrap.Name="InfiniteJumpModeSelector"selWrap.Size=UDim2.new(0,168,0,32)selWrap.AnchorPoint=Vector2.new(1,0.5)selWrap.Position=UDim2.new(1,-10,0.5,0)selWrap.BackgroundColor3=Color3.fromRGB(16,9,2)selWrap.BackgroundTransparency=0.08 selWrap.BorderSizePixel=0 selWrap.ZIndex=12 Instance.new("UICorner",selWrap).CornerRadius=UDim.new(0,10)local selStroke=Instance.new("UIStroke",selWrap)selStroke.Color=Color3.fromRGB(65,195,255)selStroke.Thickness=1.6 selStroke.Transparency=0.12 local selShine=Instance.new("UIGradient",selWrap)selShine.Rotation=0 selShine.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.35,Color3.fromRGB(67,162,255)),ColorSequenceKeypoint.new(0.55,Color3.fromRGB(40,22,8)),ColorSequenceKeypoint.new(1,Color3.fromRGB(61,148,241))})selShine.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.92),NumberSequenceKeypoint.new(0.4,0.55),NumberSequenceKeypoint.new(0.6,0.92),NumberSequenceKeypoint.new(1,0.98)})task.spawn(function()while selWrap and selWrap.Parent do selShine.Offset=Vector2.new(-1.2,0)local tw=TS:Create(selShine,TweenInfo.new(1.6,Enum.EasingStyle.Linear),{Offset=Vector2.new(1.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.35)end end)local function makePremiumArrow(parent,side,text,xPos)local btn=Instance.new("TextButton",parent)btn.Name=(side=="L"and"Left"or"Right").."JumpModeArrow"btn.Size=UDim2.new(0,30,0,26)btn.Position=UDim2.new(0,xPos,0.5,-13)btn.BackgroundColor3=Color3.fromRGB(40,170,255)btn.BackgroundTransparency=0 btn.BorderSizePixel=0 btn.Text=text btn.TextColor3=Color3.fromRGB(230,250,255)btn.Font=Enum.Font.GothamBlack btn.TextSize=18 btn.TextStrokeColor3=Color3.fromRGB(24,80,150)btn.TextStrokeTransparency=0.25 btn.AutoButtonColor=false btn.ZIndex=14 btn.ClipsDescendants=true Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)local grad=Instance.new("UIGradient",btn)grad.Rotation=90 grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(140,235,255)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(50,190,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,120,220))})local stroke=Instance.new("UIStroke",btn)stroke.Color=Color3.fromRGB(130,230,255)stroke.Thickness=1.9 stroke.Transparency=0.05 local scale=Instance.new("UIScale",btn)scale.Scale=1 local shineFx=Instance.new("Frame",btn)shineFx.Name="ArrowShineFx"shineFx.Size=UDim2.new(0.55,0,1.4,0)shineFx.Position=UDim2.new(-0.6,0,-0.2,0)shineFx.BackgroundColor3=Color3.fromRGB(240,250,255)shineFx.BackgroundTransparency=0.55 shineFx.BorderSizePixel=0 shineFx.ZIndex=15 shineFx.Rotation=18 Instance.new("UICorner",shineFx).CornerRadius=UDim.new(0,6)local shineGrad=Instance.new("UIGradient",shineFx)shineGrad.Rotation=90 shineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.2),NumberSequenceKeypoint.new(1,1)})task.spawn(function()while btn and btn.Parent and shineFx and shineFx.Parent do shineFx.Position=UDim2.new(-0.7,0,-0.2,0)local tw=TS:Create(shineFx,TweenInfo.new(1.15,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(1.15,0,-0.2,0)})tw:Play()tw.Completed:Wait()task.wait(0.5)end end)btn.MouseEnter:Connect(function()TS:Create(scale,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1.12}):Play()TS:Create(stroke,TweenInfo.new(0.15),{Transparency=0,Thickness=2.4}):Play()end)btn.MouseLeave:Connect(function()TS:Create(scale,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1}):Play()TS:Create(stroke,TweenInfo.new(0.18),{Transparency=0.05,Thickness=1.9}):Play()end)return btn,scale,stroke end local leftBtn,leftScale=makePremiumArrow(selWrap,"L","‹",4)local rightBtn,rightScale=makePremiumArrow(selWrap,"R","›",128)local modeValue=Instance.new("TextLabel",selWrap)modeValue.Name="InfiniteJumpModeValue"modeValue.Size=UDim2.new(0,90,0,26)modeValue.Position=UDim2.new(0.5,-45,0.5,-13)modeValue.BackgroundColor3=Color3.fromRGB(28,14,4)modeValue.BackgroundTransparency=0.15 modeValue.Text=string.upper(modes[modeIdx])modeValue.TextColor3=Color3.fromRGB(255,240,200)modeValue.Font=Enum.Font.GothamBlack modeValue.TextSize=13 modeValue.TextXAlignment=Enum.TextXAlignment.Center modeValue.ZIndex=13 Instance.new("UICorner",modeValue).CornerRadius=UDim.new(0,7)local valStroke=Instance.new("UIStroke",modeValue)valStroke.Color=Color3.fromRGB(70,200,255)valStroke.Thickness=1.3 valStroke.Transparency=0.2 local valGrad=Instance.new("UIGradient",modeValue)valGrad.Rotation=90 valGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.4,Color3.fromRGB(68,165,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(40,180,255))})valGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.7),NumberSequenceKeypoint.new(0.5,0.85),NumberSequenceKeypoint.new(1,0.95)})infJumpModeBtn=modeValue local switching=false local function applyMode(idx,animate)if switching then return end idx=((idx-1)%#modes)+1 modeIdx=idx local value=modes[modeIdx]switching=true local function finish()InfiniteJump.setMode(value)modeValue.Text=string.upper(value)if InfiniteJump.enabled then InfiniteJump.stop();InfiniteJump.start()end pcall(saveAllSettings,true)switching=false end if animate then local out=TS:Create(modeValue,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{TextTransparency=1,TextStrokeTransparency=1})out:Play()out.Completed:Connect(function()modeValue.Text=string.upper(value)TS:Create(modeValue,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextTransparency=0,TextStrokeTransparency=0.5}):Play()finish()end)TS:Create(valStroke,TweenInfo.new(0.2),{Color=Color3.fromRGB(140,235,255),Transparency=0}):Play()task.delay(0.25,function()if valStroke and valStroke.Parent then TS:Create(valStroke,TweenInfo.new(0.35),{Color=Color3.fromRGB(70,200,255),Transparency=0.2}):Play()end end)else finish()end end leftBtn.Activated:Connect(function()TS:Create(leftScale,TweenInfo.new(0.08,Enum.EasingStyle.Quad),{Scale=0.9}):Play()task.delay(0.08,function()if leftScale and leftScale.Parent then TS:Create(leftScale,TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)applyMode(modeIdx-1,true)end)rightBtn.Activated:Connect(function()TS:Create(rightScale,TweenInfo.new(0.08,Enum.EasingStyle.Quad),{Scale=0.9}):Play()task.delay(0.08,function()if rightScale and rightScale.Parent then TS:Create(rightScale,TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end end)applyMode(modeIdx+1,true)end)end local spinBotEnabled=_G.__ZeyHubbSpinBotEnabled==true
local spinBotConnection=nil
local spinBotSpeed=math.clamp(tonumber(_G.__ZeyHubbSpinBotSpeed)or 720,180,1800)
local autoBrainrotEnabled=_G.__ZeyHubbAutoBrainrotEnabled==true
local spinBotWasAutoRotating=nil
local spinBotLastHumanoid=nil
local spinBotLastCharacter=nil
local spinBotLastWarn=0
local function spinBotHasBrainrot(character)
 if not character then return false end
 if LP:GetAttribute("Stealing")==true or character:GetAttribute("Stealing")==true then return true end
 for _,entry in ipairs({"CarryingBrainrot","HasBrainrot","IsCarryingBrainrot","Carrying","IsCarrying"}) do
  local obj=character:FindFirstChild(entry,true)
  if obj and ((obj:IsA("BoolValue") and obj.Value) or (obj:IsA("ObjectValue") and obj.Value) or (obj:IsA("StringValue") and obj.Value~="")) then return true end
 end
 for _,obj in ipairs(character:GetDescendants()) do
  local n=tostring(obj.Name or ""):lower()
  if (n:find("brainrot",1,true) or n:find("animalpodium",1,true) or n:find("carriedbrainrot",1,true)) and (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("BoolValue") or obj:IsA("ObjectValue")) then
   if not (obj:IsA("BoolValue") and obj.Value==false) and not (obj:IsA("ObjectValue") and obj.Value==nil) then return true end
  end
 end
 return false
end
local function shouldSpinBotRun()
 if autoBrainrotEnabled then
  local character=LP.Character
  return character~=nil and spinBotHasBrainrot(character)
 end
 return spinBotEnabled
end
local function restoreSpinBotRotation()
 if spinBotLastHumanoid and spinBotLastHumanoid.Parent and spinBotWasAutoRotating~=nil then
  pcall(function() spinBotLastHumanoid.AutoRotate=spinBotWasAutoRotating end)
 end
 spinBotLastHumanoid=nil
 spinBotWasAutoRotating=nil
end
local function setSpinBotEnabled(on)
 spinBotEnabled=on==true
 _G.__ZeyHubbSpinBotEnabled=spinBotEnabled
 if spinBotConnection then pcall(function() spinBotConnection:Disconnect() end);spinBotConnection=nil end
 if not spinBotEnabled and not autoBrainrotEnabled then
  restoreSpinBotRotation()
  local character=LP.Character
  local root=character and character:FindFirstChild("HumanoidRootPart")
  if root then pcall(function() root.AssemblyAngularVelocity=Vector3.zero end) end
  spinBotLastCharacter=nil
  return
 end
 spinBotConnection=RunService.RenderStepped:Connect(function(dt)
  local ok,err=pcall(function()
   local character=LP.Character
   local root=character and character:FindFirstChild("HumanoidRootPart")
   local humanoid=character and character:FindFirstChildOfClass("Humanoid")
   local shouldSpin=shouldSpinBotRun()
   if character~=spinBotLastCharacter then
    restoreSpinBotRotation()
    spinBotLastCharacter=character
   end
   if not character or not root or not humanoid or humanoid.Health<=0 then
    restoreSpinBotRotation()
    return
   end
   if shouldSpin then
    if spinBotLastHumanoid~=humanoid then
     restoreSpinBotRotation()
     spinBotLastHumanoid=humanoid
     spinBotWasAutoRotating=humanoid.AutoRotate
    elseif spinBotWasAutoRotating==nil then
     spinBotWasAutoRotating=humanoid.AutoRotate
    end
    humanoid.AutoRotate=false
    local frameDt=math.clamp(tonumber(dt) or (1/60),0,0.1)
    local speed=math.clamp(tonumber(spinBotSpeed) or 720,180,1800)
    local pos=root.Position
    local _,yaw,_=root.CFrame:ToOrientation()
    local velocity=root.AssemblyLinearVelocity
    root.CFrame=CFrame.new(pos)*CFrame.Angles(0,yaw+math.rad(speed)*frameDt,0)
    root.AssemblyLinearVelocity=velocity
   else
    restoreSpinBotRotation()
   end
  end)
  if not ok and os.clock()-spinBotLastWarn>3 then
   spinBotLastWarn=os.clock()
   warn("[ZeyHubb] Spin Bot update error: ",err)
  end
 end)
end
LP.CharacterAdded:Connect(function()
 restoreSpinBotRotation()
 spinBotLastCharacter=nil
 if spinBotEnabled or autoBrainrotEnabled then task.wait(0.5);setSpinBotEnabled(spinBotEnabled) end
end)
local combatPage=contentPages["Combat"]or contentPages["Speed"]mkSect(combatPage,"Defense")setAntiBatVisual=mkToggle(combatPage,"Anti Bat",function(on)if on then startAntiBat()else stopAntiBat()end end)setAntiFlingVisual=mkToggle(combatPage,"Anti Fling",function(on)antiFlingEnabled=on if on then startAntiFling()else stopAntiFling()end saveAllSettings()end)if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled)end
mkSect(combatPage,"Movement")local setSpinBotVisual=mkToggle(combatPage,"Spin Bot",function(on)setSpinBotEnabled(on);saveAllSettings()end)
local spinSpeedValues={180,360,540,720,900,1080,1440,1800};local spinSpeedIndex=4;local spinSpeedLabelUpdater=nil;local spinSpeedSelectorLabel=nil
do local row=mkRow(combatPage,42);mkLabel(row,"Spin Speed");for i,v in ipairs(spinSpeedValues)do if v==spinBotSpeed then spinSpeedIndex=i;break end end;local selector=mkSelector(row,tostring(spinBotSpeed),{},function(direction,updateLabel) spinSpeedIndex=spinSpeedIndex+direction;if spinSpeedIndex<1 then spinSpeedIndex=#spinSpeedValues elseif spinSpeedIndex>#spinSpeedValues then spinSpeedIndex=1 end;spinBotSpeed=math.clamp(spinSpeedValues[spinSpeedIndex],180,1800);_G.__ZeyHubbSpinBotSpeed=spinBotSpeed;updateLabel(tostring(spinBotSpeed));saveAllSettings(true) end);spinSpeedSelectorLabel=selector;spinSpeedLabelUpdater=function(value)if value then for i,v in ipairs(spinSpeedValues)do if v==value then spinSpeedIndex=i;break end end end end end
_G.__ZeyHubbApplySpinSettings=function() spinBotEnabled=_G.__ZeyHubbSpinBotEnabled==true;autoBrainrotEnabled=_G.__ZeyHubbAutoBrainrotEnabled==true;spinBotSpeed=tonumber(_G.__ZeyHubbSpinBotSpeed)or 720;if spinSpeedLabelUpdater then pcall(spinSpeedLabelUpdater,spinBotSpeed)end;if spinSpeedSelectorLabel then spinSpeedSelectorLabel.Text=tostring(spinBotSpeed)end;if setSpinBotVisual then pcall(setSpinBotVisual,spinBotEnabled)end;if setAutoBrainrotVisual then pcall(setAutoBrainrotVisual,autoBrainrotEnabled)end;setSpinBotEnabled(spinBotEnabled) end
local setAutoBrainrotVisual=mkToggle(combatPage,"Auto Brainrot",function(on)autoBrainrotEnabled=on==true;_G.__ZeyHubbAutoBrainrotEnabled=autoBrainrotEnabled;setSpinBotEnabled(spinBotEnabled);saveAllSettings(true)end)
_G.__ZeyHubbApplySpinSettings=function() spinBotEnabled=_G.__ZeyHubbSpinBotEnabled==true;autoBrainrotEnabled=_G.__ZeyHubbAutoBrainrotEnabled==true;spinBotSpeed=tonumber(_G.__ZeyHubbSpinBotSpeed)or 720;if spinSpeedLabelUpdater then pcall(spinSpeedLabelUpdater,spinBotSpeed)end;if spinSpeedSelectorLabel then spinSpeedSelectorLabel.Text=tostring(spinBotSpeed)end;if setSpinBotVisual then pcall(setSpinBotVisual,spinBotEnabled)end;if setAutoBrainrotVisual then pcall(setAutoBrainrotVisual,autoBrainrotEnabled)end;setSpinBotEnabled(spinBotEnabled) end
mkSect(combatPage,"Anti Ragdoll")do local choice=(antiRagdollMode=="v1"or antiRagdollMode=="v2")and antiRagdollMode or"v2"local sv,refresh=mkToggleSelector(combatPage,"Anti Ragdoll",function(on)if on then setAntiRagdollMode(choice)else setAntiRagdollMode("off")end end,{{"v1","V1"},{"v2","V2"}},function()return choice end,function(key)choice=key if antiRagdollMode~="off"then setAntiRagdollMode(key)end end)_G.updateAntiRagdollUI=function(mode)if mode=="v1"or mode=="v2"then choice=mode end sv(mode=="v1"or mode=="v2")refresh()end _G.updateAntiRagdollUI(antiRagdollMode)setAntiRagVisual=function(on)if not on then setAntiRagdollMode("off")end end end mkSect(combatPage,"Bat Modes")do local sv,refresh=mkToggleSelector(combatPage,"Bat V2 / V3",function(on)if on then if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2)end else if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end end if mobSetBatV2 then pcall(mobSetBatV2,on)end end,{{"v2","Bat V2"},{"v3","Bat V3"}},function()return(_G.__RivalHubBatVersion=="v3")and"v3"or"v2"end,function(key)if _G.__RivalHubSetBatVersion then _G.__RivalHubSetBatVersion(key)else _G.__RivalHubBatVersion=key end end)_G.__RivalHubBatSetVisual=sv _G.updateBatVersionUI=function(ver)refresh()end sv(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false)refresh()end
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
setAntiDieVisual=mkToggle(combatPage,"Anti Die",function(on)antiDieEnabled=on if on then AntiDieModule.start()else AntiDieModule.stop()end saveAllSettings()end)if setAntiDieVisual then setAntiDieVisual(antiDieEnabled)end setUnwalkVisual=mkToggle(combatPage,"Unwalk",function(on)unwalkEnabled=on if on then startUnwalk()else stopUnwalk()end end)mkSect(combatPage,"Attack")do local batAimbotVisual,batAimbotRow=mkToggle(combatPage,"Bat Aimbot",function(on) local toggle=_G.__RivalHubBatAimbotToggle;if type(toggle)=="function" then local ok,res=pcall(toggle);local state=ok and res==true;if not ok then warn("[ZeyHubb.vs] Bat Aimbot toggle failed: "..tostring(res)) end;if _G.__RivalHubBatAimbotSetVisual then pcall(_G.__RivalHubBatAimbotSetVisual,state) end;if mobSetBatAimbot then pcall(mobSetBatAimbot,state) end end;pcall(saveAllSettings,true)end);local batAimbotGlow=Instance.new("UIStroke");batAimbotGlow.Name="BatAimbotActiveGlow";batAimbotGlow.Color=Color3.fromRGB(35,165,255);batAimbotGlow.Thickness=1.8;batAimbotGlow.Transparency=1;batAimbotGlow.Parent=batAimbotRow;local batAimbotBaseVisual=batAimbotVisual;batAimbotVisual=function(state)batAimbotBaseVisual(state);if batAimbotGlow and batAimbotGlow.Parent then batAimbotGlow.Transparency=state and 0 or 1 end end;_G.__RivalHubBatAimbotSetVisual=batAimbotVisual;local batAimbotSpeedBox=nil;do local row=mkRow(combatPage,42);mkLabel(row,"Bat Aimbot Speed");batAimbotSpeedBox=mkBox(row,BAT_AIMBOT_SPEED,50,56,function(v) if v==v and v>0 and v<math.huge then BAT_AIMBOT_SPEED=_clamp(v,1,200);pcall(saveAllSettings,true) end end) end;_G.__ZeyHubbRefreshBatAimbotSpeed=function() if batAimbotSpeedBox then batAimbotSpeedBox.Text=tostring(BAT_AIMBOT_SPEED) end end;if _G.__RivalHubBatAimbotSetVisual then pcall(_G.__RivalHubBatAimbotSetVisual,false) end end mkSect(combatPage,"Bypass")do local sv,refresh=mkToggleSelector(combatPage,"Bypass Bat",function(on)if on then enableAutoBat()else disableAutoBat()end if mobSetAutoBat then mobSetAutoBat(on)end pcall(saveAllSettings,true)end,{{"v1","V1"},{"v2","V2"},{"v3","V3"}},function()local v=_G.__ZeyHubbBypassBatVersion or"v1" return(v=="v2"or v=="v3")and v or"v1"end,function(key)_G.__ZeyHubbBypassBatVersion=key if autoBatEnabled then disableAutoBat()enableAutoBat()end pcall(saveAllSettings,true)end)autoBatSetVisual=sv if refresh then refresh()end sv(autoBatEnabled==true)end
do local row=mkRow(combatPage,42);mkLabel(row,"Bypass Speed");batSpeedBox=mkBox(row,BYPASS_AIMBOT_SPEED,50,56,function(v)if v==v and v>0 and v<math.huge then BYPASS_AIMBOT_SPEED=v;State.bypassBatSpeed=v;if _G.SnowVS and _G.SnowVS.BatBypass and _G.SnowVS.BatBypass.ZCFG then _G.SnowVS.BatBypass.ZCFG.FOLLOW_SPEED=v end saveAllSettings()end end)end mkSect(combatPage,"Targeting")bodyLockSetVisual=mkToggle(combatPage,"Lock Enemy",function(on)bodyLockEnabled=on if on then if _blSuppressCount==0 then startBodyLock()end else stopBodyLock()end end)do local row=mkRow(combatPage,42)mkLabel(row,"Lock Enemy Range")bodyLockRangeBox=mkBox(row,bodyLockRange,50,56,function(v)if v and v>0 then bodyLockRange=_clamp(_floor(v),5,200)if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end end end)end

 mkSect(combatPage,"FOV")
do
 local fovPropConn=nil
 local fovBound=false
 local bindName="ZeyHubbCustomFOV"
 local fovOptions={{"70","70"},{"80","80"},{"90","90"},{"100","100"},{"110","110"},{"120","120"},{"140","140"},{"160","160"},{"180","180"}}
 if type(_G.__ZeyHubbCustomFOV)~="table" then
  _G.__ZeyHubbCustomFOV={enabled=false,value=90,original=nil}
 end
 local FOVST=_G.__ZeyHubbCustomFOV
 FOVST.enabled=(FOVST.enabled==true)
 FOVST.value=tonumber(FOVST.value) or 90
 if FOVST.value~=FOVST.value then FOVST.value=90 end
 FOVST.value=math.clamp(FOVST.value,40,180)

 local function applyFov()
  local cam=Workspace.CurrentCamera
  if not cam or not FOVST.enabled then return end
  local target=FOVST.value
  if target<=120 then
   pcall(function() cam.FieldOfView=target end)
  else
   pcall(function()
    cam.FieldOfView=120
    local factor=target/120
    if factor>1.001 then
     local cf=cam.CFrame
     local inv=1/factor
     cam.CFrame=CFrame.fromMatrix(cf.Position,cf.RightVector*inv,cf.UpVector*inv,-cf.LookVector)
    end
   end)
  end
 end

 local function disconnectFovHooks()
  if fovPropConn then
   pcall(function() fovPropConn:Disconnect() end)
   fovPropConn=nil
  end
 end

 local function hookCurrentCamera()
  disconnectFovHooks()
  local cam=Workspace.CurrentCamera
  if not cam then return end
  fovPropConn=cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
   if not FOVST.enabled then return end
   local cur=cam.FieldOfView
   local want=(FOVST.value<=120) and FOVST.value or 120
   if math.abs(cur-want)>0.05 then
    applyFov()
   end
  end)
 end

 local function stopFovLoop()
  if fovBound then
   pcall(function() RunService:UnbindFromRenderStep(bindName) end)
   fovBound=false
  end
  disconnectFovHooks()
 end

 local function startFovLoop()
  stopFovLoop()
  if not FOVST.enabled then return end
  local priority=200
  if Enum.RenderPriority then
   if Enum.RenderPriority.Last then
    priority=Enum.RenderPriority.Last.Value
   elseif Enum.RenderPriority.Camera then
    priority=Enum.RenderPriority.Camera.Value+50
   end
  end
  local ok=pcall(function()
   RunService:BindToRenderStep(bindName,priority,applyFov)
  end)
  if not ok then
   ok=pcall(function()
    RunService:BindToRenderStep(bindName,250,applyFov)
   end)
  end
  fovBound=ok
  hookCurrentCamera()
  applyFov()
  task.defer(applyFov)
 end

 _G.__ZeyHubbFOVStart=startFovLoop
 _G.__ZeyHubbFOVStop=function()
  FOVST.enabled=false
  stopFovLoop()
  local cam=Workspace.CurrentCamera
  if cam and FOVST.original~=nil then
   pcall(function() cam.FieldOfView=FOVST.original end)
  end
 end
 _G.__ZeyHubbFOVApply=applyFov

 local sv,refresh=mkToggleSelector(combatPage,"FOV",function(on)
  FOVST.enabled=(on==true)
  if FOVST.enabled then
   local cam=Workspace.CurrentCamera
   if cam and FOVST.original==nil then
    FOVST.original=cam.FieldOfView
   end
   startFovLoop()
  else
   stopFovLoop()
   local cam=Workspace.CurrentCamera
   if cam and FOVST.original~=nil then
    pcall(function() cam.FieldOfView=FOVST.original end)
   end
   FOVST.original=nil
  end
  pcall(saveAllSettings,true)
 end,fovOptions,function()
  return tostring(FOVST.value)
 end,function(key)
  local selected=tonumber(key)
  if not selected then return end
  FOVST.value=math.clamp(selected,40,180)
  if FOVST.enabled then
   applyFov()
  end
  pcall(saveAllSettings,true)
 end)

 _G.__ZeyHubbFOVRefreshUI=function()
  if refresh then pcall(refresh) end
  if sv then pcall(sv,FOVST.enabled==true) end
 end

 Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
  if FOVST.enabled then
   task.defer(function()
    local cam=Workspace.CurrentCamera
    if cam and FOVST.original==nil then
     FOVST.original=cam.FieldOfView
    end
    hookCurrentCamera()
    applyFov()
   end)
  end
 end)

 if FOVST.enabled then
  task.defer(function()
   local cam=Workspace.CurrentCamera
   if cam and FOVST.original==nil then
    FOVST.original=cam.FieldOfView
   end
   if sv then pcall(sv,true) end
   startFovLoop()
  end)
 end
 if refresh then refresh() end
 if sv then pcall(sv,FOVST.enabled==true) end
end
mkSect(combatPage,"Counters")setBatCounterVisual=mkToggle(combatPage,"Bat Counter",function(on)batCounterEnabled=on if on then startBatCounter()else stopBatCounter()end end)setBatCounterV2Visual=mkToggle(combatPage,"Bat Counter V2",function(on)batCounterV2Enabled=on if on then startBatCounterV2()else stopBatCounterV2()end end)setMedusaVisual=mkToggle(combatPage,"Medusa Counter",function(on)medusaCounterEnabled=on if on then if LP.Character then setupMedusaCounter(LP.Character)else stopMedusaCounter()end else stopMedusaCounter()end if setMedusaVisual then setMedusaVisual(on)end end)mkSect(combatPage,"Drop")dropBrainrotSetVisual=mkToggle(combatPage,"Drop Brainrot",function(on)if on then executeDropWithToggle(function(v)dropBrainrotSetVisual(v)if mobSetDropBR then mobSetDropBR(v)end end)end end)setDropVisual=dropBrainrotSetVisual do local row=mkRow(combatPage,42)mkLabel(row,"Drop Mode")dropModeBtnRef=mkSelector(row,dropMode==1 and"Fling"or"Jump Drop",{"Fling","Jump Drop"},function(dir,update)if dropActive then stopDropBrainrot()end dropMode=dropMode==1 and 2 or 1 update(dropMode==1 and"Fling"or"Jump Drop")end)end local stealPage=contentPages["Combat"]or contentPages["Settings"]mkSect(stealPage,"Auto Steal")do local sv,refresh=mkToggleSelector(stealPage,"Auto Steal",function(on)CONFIG.AUTO_STEAL_ENABLED=on==true if on then pcall(startAutoSteal)else stopAutoSteal()end updateProgressBarVisibility()pcall(saveAllSettings,true)end,{{"73%","73"},{"80%","80"},{"85%","85"},{"95%","95"}},function()return tostring(autoStealMode or"73").."%" end,function(key)local k=tostring(key or"73"):gsub("%%","")applyStealStopPercent(k)if CONFIG.AUTO_STEAL_ENABLED then stopAutoSteal();startAutoSteal()end pcall(saveAllSettings,true)end)setInstaGrab=sv autoStealModeBtn=setmetatable({},{__newindex=function(_,k)if k=="Text"then refresh()end end})_G._rivalHubStealModeSetter=function()refresh()end end do local row=mkRow(stealPage,42)mkLabel(row,"Steal Radius")radInput=mkBox(row,CONFIG.STEAL_RANGE,50,56,function(v)if v and v>=5 and v<=300 then CONFIG.STEAL_RANGE=_floor(v+0.5)Steal.StealRadius=CONFIG.STEAL_RANGE radInput.Text=tostring(CONFIG.STEAL_RANGE)saveAllSettings()end end)end mkSect(stealPage,"Auto Carry")do local sv,refresh=mkToggleSelector(stealPage,"Auto Carry",function(on)autoCarryEnabled=on if not on and _G.__RivalHubAutoCarryRestore then pcall(_G.__RivalHubAutoCarryRestore)end pcall(saveAllSettings)end,{{"On Pick Up","On Pick Up"},{"Soft Steal","Soft Steal"}},function()return autoCarryMode or"On Pick Up"end,function(key)autoCarryMode=key pcall(saveAllSettings)end)sv(autoCarryEnabled==true)_G.__RivalHubAutoCarrySetVisual=sv _G.__RivalHubAutoCarryRefresh=function()sv(autoCarryEnabled==true);refresh()end end mkSect(stealPage,"HUD")do local row=mkRow(stealPage,42)mkLabel(row,"Show Auto Steal Bar")local pill,dot=mkPill(row,62)local barOn=true local function setBar(s)barOn=s animPill(pill,dot,s)if pbFrame then pbFrame.Visible=s end end animPill(pill,dot,true)local clk=Instance.new("TextButton",pill)clk.Size=UDim2.new(1,0,1,0)clk.BackgroundTransparency=1 clk.Text=""clk.AutoButtonColor=false clk.ZIndex=10 clk.Activated:Connect(function()setBar(not barOn)end)end do local row=mkRow(stealPage,42)mkLabel(row,"Steal Bar Style")local styles={{"V1","V1"},{"V3","V3"}}local function cur()return (stealBarStyle=="V3")and stealBarStyle or"V1"end local lbl=mkSelector(row,cur(),{},function(direction,updateLabel)local idx=1 for i,s in ipairs(styles)do if s[1]==cur()then idx=i break end end idx=idx+direction if idx<1 then idx=#styles end if idx>#styles then idx=1 end stealBarStyle=styles[idx][1]if applyStealBarStyle then pcall(applyStealBarStyle,stealBarStyle)elseif _G.__ZeyHubbApplyStealBarStyle then pcall(_G.__ZeyHubbApplyStealBarStyle,stealBarStyle)end updateLabel(styles[idx][2])pcall(saveAllSettings,true)end)end local configPage=contentPages["Settings"]mkSect(configPage,"Protection")local antiCrasherConnections={}local antiCrasherActive=false local antiCrasherCount=0 local antiCrasherSetVisual=nil local antiCrasherDestroyed={}local antiCrasherPatterns={"websocket","ws_","_ws","wss","socket","zl","ace","realtime","bridge","gateway","tunnel","relay","handshake","protocol","wschannel","socketio","socket_io"}local function isSuspiciousRemote(obj)if not(obj:IsA("RemoteEvent")or obj:IsA("RemoteFunction")or obj:IsA("BindableEvent")or obj:IsA("BindableFunction"))then return false end local lowerName=string.lower(tostring(obj.Name))for _,pattern in ipairs(antiCrasherPatterns)do if string.find(lowerName,pattern,1,true)then return true end end return false end local function destroySuspiciousRemote(obj)if antiCrasherDestroyed[obj]then return end antiCrasherDestroyed[obj]=true antiCrasherCount+=1 pcall(function()obj:Destroy()end)end local function scanSuspiciousRemotes(root)for _,obj in ipairs(root:GetDescendants())do if isSuspiciousRemote(obj)then destroySuspiciousRemote(obj)end end end local function stopAntiCrasher(preservePreference)antiCrasherActive=false if not preservePreference then _G.__ZeyHubbAntiCrasherEnabled=false end for _,connection in ipairs(antiCrasherConnections)do pcall(function()connection:Disconnect()end)end table.clear(antiCrasherConnections)end local function startAntiCrasher()stopAntiCrasher(true)antiCrasherActive=true _G.__ZeyHubbAntiCrasherEnabled=true antiCrasherCount=0 table.clear(antiCrasherDestroyed)for _,serviceName in ipairs({"ReplicatedStorage","ReplicatedFirst","Workspace"})do local ok,service=pcall(function()return game:GetService(serviceName)end)if ok and service then pcall(scanSuspiciousRemotes,service)table.insert(antiCrasherConnections,service.DescendantAdded:Connect(function(obj)if antiCrasherActive and isSuspiciousRemote(obj)then task.defer(function()if antiCrasherActive and obj.Parent then destroySuspiciousRemote(obj)end end)end end))end end warn("[ZeyHubb.vs Anti-Crasher] Surveillance active. Remotes supprimés : "..tostring(antiCrasherCount))end antiCrasherSetVisual=mkToggle(configPage,"ZeyHubb.vs Anti-Crasher",function(on)if on then startAntiCrasher()else stopAntiCrasher()warn("[ZeyHubb.vs Anti-Crasher] Surveillance désactivée.")end end)_G.__ZeyHubbSetAntiCrasher=function(state,save)state=state==true if state then startAntiCrasher()else stopAntiCrasher()end if antiCrasherSetVisual then pcall(antiCrasherSetVisual,state)end _G.__ZeyHubbAntiCrasherEnabled=state if save and not _isLoading then task.defer(function()pcall(saveAllSettings,true)end)end end _G.__ZeyHubbStopAntiCrasherRuntime=function()stopAntiCrasher(true)end if _G.__ZeyHubbAntiCrasherEnabled==true then task.defer(function()if _G.__ZeyHubbSetAntiCrasher then pcall(_G.__ZeyHubbSetAntiCrasher,true,false)end end)end mkSect(configPage,"Utility")do local sv,refresh sv,refresh=mkToggleSelector(configPage,"Instant Reset",function(on)if on then local run=_G.__ZeyHubbRunInstantReset if type(run)=="function"then local ok,err=pcall(run)if not ok then warn("[ZeyHubb Instant Reset] "..tostring(err))end else warn("[ZeyHubb] Instant Reset engine is not ready.")end if sv then task.delay(0.1,function()pcall(sv,false)end)end end end,{{"V1","V1"},{"V2","V2"}},function()return instantResetVersion end,function(key)instantResetVersion=(key=="V2")and"V2"or"V1"_G.__ZeyHubbInstantResetVersion=instantResetVersion saveAllSettings()end)_G.__ZeyHubbInstantResetSetVisual=sv _G.__ZeyHubbInstantResetRefreshSelector=refresh _G.__ZeyHubbInstantResetSetVersion=function(v)instantResetVersion=(v=="V2")and"V2"or"V1"_G.__ZeyHubbInstantResetVersion=instantResetVersion pcall(refresh)end refresh()end mkSect(configPage,"Network")local setDuelPingVisual=mkToggle(configPage,"High Ping Warning",function(on)_G.__ZeyHubbDuelPingEnabled=on==true setDuelPingAlert(on)saveAllSettings()end)_G.__ZeyHubbDuelPingSetVisual=setDuelPingVisual _G.__ZeyHubbDuelPingApply=setDuelPingAlert mkSect(configPage,"Media") do local row=mkRow(configPage,92) row.Size=UDim2.new(1,0,0,92)
local shell=Instance.new("Frame",row) shell.Name="MusicPlayerShell" shell.Size=UDim2.new(1,-10,0,78) shell.Position=UDim2.new(0,5,0.5,-39) shell.BackgroundColor3=Color3.fromRGB(12,8,18) shell.BackgroundTransparency=0.08 shell.BorderSizePixel=0 shell.ZIndex=8 Instance.new("UICorner",shell).CornerRadius=UDim.new(0,16) local shellStroke=Instance.new("UIStroke",shell) shellStroke.Name="MusicAura" shellStroke.Color=Color3.fromRGB(255,70,140) shellStroke.Thickness=2.2 shellStroke.Transparency=0.15 local shellGrad=Instance.new("UIGradient",shell) shellGrad.Rotation=25 shellGrad.Color=ColorSequence.new({ ColorSequenceKeypoint.new(0.00,Color3.fromRGB(28,12,32)), ColorSequenceKeypoint.new(0.45,Color3.fromRGB(55,10,40)), ColorSequenceKeypoint.new(1.00,Color3.fromRGB(12,6,20)), }) task.spawn(function() local up=true while shell and shell.Parent and shellStroke and shellStroke.Parent do local tw=TS:Create(shellStroke,TweenInfo.new(1.1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{ Transparency=up and 0.02 or 0.28, Thickness=up and 3.1 or 1.9, Color=up and Color3.fromRGB(255,120,200) or Color3.fromRGB(180,40,120), }) tw:Play() tw.Completed:Wait() up=not up end end) local glowRing=Instance.new("Frame",shell) glowRing.Name="AuraRing" glowRing.AnchorPoint=Vector2.new(0.5,0.5) glowRing.Position=UDim2.new(0.5,0,0.5,0) glowRing.Size=UDim2.new(1,10,1,10) glowRing.BackgroundTransparency=1 glowRing.ZIndex=7 Instance.new("UICorner",glowRing).CornerRadius=UDim.new(0,18) local ringStroke=Instance.new("UIStroke",glowRing) ringStroke.Color=Color3.fromRGB(255,180,220) ringStroke.Thickness=1.2 ringStroke.Transparency=0.55 task.spawn(function() local up=true while glowRing and glowRing.Parent and ringStroke and ringStroke.Parent do local tw=TS:Create(ringStroke,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{ Transparency=up and 0.25 or 0.7, Thickness=up and 1.8 or 0.9, }) tw:Play() tw.Completed:Wait() up=not up end end) local openYMP=Instance.new("TextButton",shell) openYMP.Name="OpenYouTubeMusicPlayer" openYMP.Size=UDim2.new(1,-16,0,52) openYMP.Position=UDim2.new(0,8,0.5,-26) openYMP.BackgroundColor3=Color3.fromRGB(255,45,110) openYMP.BorderSizePixel=0 openYMP.Text="" openYMP.AutoButtonColor=false openYMP.ZIndex=10 Instance.new("UICorner",openYMP).CornerRadius=UDim.new(0,13) local openStroke=Instance.new("UIStroke",openYMP) openStroke.Color=Color3.fromRGB(255,200,230) openStroke.Thickness=1.6 openStroke.Transparency=0.2 local openGrad=Instance.new("UIGradient",openYMP) openGrad.Rotation=90 openGrad.Color=ColorSequence.new({ ColorSequenceKeypoint.new(0.00,Color3.fromRGB(62,170,221)), ColorSequenceKeypoint.new(0.45,Color3.fromRGB(220,30,100)), ColorSequenceKeypoint.new(1.00,Color3.fromRGB(120,10,55)), }) local openIcon=Instance.new("TextLabel",openYMP) openIcon.Name="MusicIcon" openIcon.BackgroundTransparency=1 openIcon.Size=UDim2.new(0,40,1,0) openIcon.Position=UDim2.new(0,10,0,0) openIcon.Text="♫" openIcon.TextColor3=Color3.fromRGB(255,255,255) openIcon.Font=Enum.Font.GothamBlack openIcon.TextSize=26 openIcon.ZIndex=11 local openGlow=Instance.new("UIStroke",openIcon) openGlow.Color=Color3.fromRGB(255,220,240) openGlow.Thickness=1.1 openGlow.Transparency=0.2 local openTitle=Instance.new("TextLabel",openYMP) openTitle.Name="OpenTitle" openTitle.BackgroundTransparency=1 openTitle.Size=UDim2.new(1,-58,0,22) openTitle.Position=UDim2.new(0,48,0.5,-18) openTitle.Text="MUSIC PLAYER" openTitle.TextColor3=Color3.fromRGB(255,255,255) openTitle.Font=Enum.Font.GothamBlack openTitle.TextSize=15 openTitle.TextXAlignment=Enum.TextXAlignment.Left openTitle.ZIndex=11 local openSub=Instance.new("TextLabel",openYMP) openSub.Name="OpenSub" openSub.BackgroundTransparency=1 openSub.Size=UDim2.new(1,-58,0,16) openSub.Position=UDim2.new(0,48,0.5,4) openSub.Text="OPEN  ·  YouTube Music" openSub.TextColor3=Color3.fromRGB(255,210,230) openSub.Font=Enum.Font.GothamMedium openSub.TextSize=11 openSub.TextXAlignment=Enum.TextXAlignment.Left openSub.TextTransparency=0.1 openSub.ZIndex=11 local openChevron=Instance.new("TextLabel",openYMP) openChevron.BackgroundTransparency=1 openChevron.Size=UDim2.new(0,28,1,0) openChevron.Position=UDim2.new(1,-34,0,0) openChevron.Text="›" openChevron.TextColor3=Color3.fromRGB(255,255,255) openChevron.Font=Enum.Font.GothamBlack openChevron.TextSize=28 openChevron.ZIndex=11 openYMP.MouseEnter:Connect(function() TS:Create(openYMP,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(58,161,220)}):Play() TS:Create(openStroke,TweenInfo.new(0.18),{Transparency=0,Thickness=2.2}):Play() TS:Create(shellStroke,TweenInfo.new(0.18),{Transparency=0.05,Thickness=3.2}):Play() end) openYMP.MouseLeave:Connect(function() TS:Create(openYMP,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(255,45,110)}):Play() TS:Create(openStroke,TweenInfo.new(0.18),{Transparency=0.2,Thickness=1.6}):Play() end) openYMP.Activated:Connect(function() if _G.__ZeyHubbYMPLaunching then return end if _G.__ZeyHubbYMPLaunched then pcall(function() if frame and frame.Parent then frame.Visible=true end if imageButton and imageButton.Parent then imageButton.Visible=false end end) openYMP.Text="" if openTitle then openTitle.Text="PLAYER OPENED" end if openSub then openSub.Text="Already running" end task.delay(1.2,function() if openYMP and openYMP.Parent then openYMP.Text="" if openTitle then openTitle.Text="MUSIC PLAYER" end if openSub then openSub.Text="OPEN  ·  YouTube Music" end end end) return end _G.__ZeyHubbYMPLaunching=true openYMP.Text="" if openTitle then openTitle.Text="LOADING..." end if openSub then openSub.Text="Please wait" end task.spawn(function() local ok,err=pcall(function() local source=[====[getgenv().YMP = getgenv().YMP or false
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
		uiStroke.Color = Color3.fromRGB(51,40,150)
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
	uiStroke.Color = Color3.fromRGB(35,74,184)
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
imageButton.BackgroundColor3 = Color3.fromRGB(51,40,150)
imageButton.Image = "rbxassetid://83758613781843"
imageButton.Visible = false
imageButton.Parent = screenGui
ContadorJA = Instance.new("Frame")
ContadorJA.Size = UDim2.new(0, 17, 0, 17)
ContadorJA.Position = UDim2.new(0, 36, 0, -3)
ContadorJA.BackgroundColor3 = Color3.fromRGB(50,122,220)
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
Mutar.BackgroundColor3 = Color3.fromRGB(51,40,150)
Mutar.Image = "rbxassetid://109518972658686"
Mutar.Parent = frame
BotaoFechar = Instance.new("ImageButton")
BotaoFechar.Size = UDim2.new(0, 30, 0, 30)
BotaoFechar.Position = UDim2.new(1, -36, 0, 6)
BotaoFechar.BackgroundColor3 = Color3.fromRGB(51,40,150)
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
Linha.BackgroundColor3 = Color3.fromRGB(51,40,150)
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
TituloNave.BackgroundColor3 = Color3.fromRGB(37,74,184)
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
NomeNave.TextColor3 = Color3.fromRGB(51,40,150)
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
Botao1.BackgroundColor3 = Color3.fromRGB(27,40,150)
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
Nome6.TextColor3 = Color3.fromRGB(93,240,255)
Nome6.Font = Enum.Font.SourceSansBold
Nome6.TextScaled = true
Nome6.Parent = Botao6
ContadorJABO = Instance.new("Frame")
ContadorJABO.Size = UDim2.new(0, 15, 0, 15)
ContadorJABO.Position = UDim2.new(0, 0, 0, -3)
ContadorJABO.BackgroundColor3 = Color3.fromRGB(50,122,220)
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
TituloPlayL.BackgroundColor3 = Color3.fromRGB(37,74,184)
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
NomePlayL.TextColor3 = Color3.fromRGB(51,40,150)
NomePlayL.Font = Enum.Font.SourceSansBold
NomePlayL.TextScaled = true
NomePlayL.Parent = TituloPlayL
EsquerdaPL = Instance.new("ImageButton")
EsquerdaPL.Size = UDim2.new(0, 32, 0, 32)
EsquerdaPL.Position = UDim2.new(0, 6, 0, 202)
EsquerdaPL.BackgroundColor3 = Color3.fromRGB(39,156,255)
EsquerdaPL.Image = "rbxassetid://121046797518772"
EsquerdaPL.Parent = Playlist
DireitaPL = Instance.new("ImageButton")
DireitaPL.Size = UDim2.new(0, 32, 0, 32)
DireitaPL.Position = UDim2.new(0, 122, 0, 202)
DireitaPL.BackgroundColor3 = Color3.fromRGB(39,156,255)
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
AbaPL.TextColor3 = Color3.fromRGB(51,40,150)
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
NomeWelcome.TextColor3 = Color3.fromRGB(51,40,150)
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
You.BackgroundColor3 = Color3.fromRGB(35,74,184)
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
Rastro.BackgroundColor3 = Color3.fromRGB(35,74,184)
Rastro.BorderSizePixel = 0
Rastro.ZIndex = 2
Rastro.Parent = BarraProgresso
BolaProgresso = Instance.new("ImageButton")
BolaProgresso.Size = UDim2.new(0, 16, 0, 16)
BolaProgresso.Position = UDim2.new(0, 0, 0, -3)
BolaProgresso.BackgroundColor3 = Color3.fromRGB(35,74,184)
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
Voltar.BackgroundColor3 = Color3.fromRGB(35,74,184)
Voltar.BorderSizePixel = 0
Voltar.Image = "rbxassetid://88757150664292"
Voltar.Parent = Controles
Retroceder = Instance.new("ImageButton")
Retroceder.Size = UDim2.new(0, 30, 0, 30)
Retroceder.Position = UDim2.new(0, 55, 0.5, -15)
Retroceder.BackgroundColor3 = Color3.fromRGB(35,74,184)
Retroceder.BorderSizePixel = 0
Retroceder.Image = "rbxassetid://122950454234379"
Retroceder.Parent = Controles
Play = Instance.new("ImageButton")
Play.Size = UDim2.new(0, 30, 0, 30)
Play.Position = UDim2.new(0.5, -15, 0.5, -15)
Play.BackgroundColor3 = Color3.fromRGB(35,74,184)
Play.BorderSizePixel = 0
Play.Image = "rbxassetid://110560238983134"
Play.Parent = Controles
Adiantar = Instance.new("ImageButton")
Adiantar.Size = UDim2.new(0, 30, 0, 30)
Adiantar.Position = UDim2.new(1, -85, 0.5, -15)
Adiantar.BackgroundColor3 = Color3.fromRGB(35,74,184)
Adiantar.BorderSizePixel = 0
Adiantar.Image = "rbxassetid://102857578902137"
Adiantar.Parent = Controles
Pular = Instance.new("ImageButton")
Pular.Size = UDim2.new(0, 30, 0, 30)
Pular.Position = UDim2.new(1, -40, 0.5, -15)
Pular.BackgroundColor3 = Color3.fromRGB(35,74,184)
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
NomeEqua.TextColor3 = Color3.fromRGB(51,40,150)
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
TextoFrenquencia.TextColor3 = Color3.fromRGB(51,40,150)
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
TextoEfeitos.TextColor3 = Color3.fromRGB(51,40,150)
TextoEfeitos.TextScaled = true
TextoEfeitos.Parent = EfeitosTitulo
Nenhum = Instance.new("ImageButton")
Nenhum.Name = "Nenhum"
Nenhum.Size = UDim2.new(0, 219, 0, 35)
Nenhum.Position = UDim2.new(0, 8, 0, 340)
Nenhum.AutoButtonColor = false
Nenhum.BackgroundColor3 = Color3.fromRGB(27,40,150)
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
ResetarTexto.TextColor3 = Color3.fromRGB(51,40,150)
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
PaginaEsperandoText.BackgroundColor3 = Color3.fromRGB(51,40,150)
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
NomeCancel.TextColor3 = Color3.fromRGB(35,95,184)
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
TutoTexto.TextColor3 = Color3.fromRGB(37,51,185)
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
NomeGC.TextColor3 = Color3.fromRGB(51,40,150)
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
NomePremium.TextColor3 = Color3.fromRGB(81,213,255)
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
Priv4.BackgroundColor3 = Color3.fromRGB(35,74,184)
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
Priv6.BackgroundColor3 = Color3.fromRGB(49,120,220)
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
TextoPriv4.TextColor3 = Color3.fromRGB(49,120,220)
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
TextoPriv6.TextColor3 = Color3.fromRGB(27,100,169)
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
LinhaReport.BackgroundColor3 = Color3.fromRGB(51,40,150)
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
Denunciar.BackgroundColor3 = Color3.fromRGB(34,135,255)
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
Linha.BackgroundColor3 = Color3.fromRGB(51,40,150)
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
CloseWarn.BackgroundColor3 = Color3.fromRGB(34,135,255)
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
	v17.BackgroundColor3 = Color3.fromRGB(27,40,150)
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
		if v17.BackgroundColor3 == Color3.fromRGB(27,40,150) then
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
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(27,40,150) then
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
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(27,40,150) then
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
				child.BackgroundColor3 = Color3.fromRGB(27,40,150)
				if uiStroke then
					uiStroke.Color = Color3.fromRGB(51,40,150)
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
		imageButton3.BackgroundColor3 = Color3.fromRGB(27,40,150)
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		if uiStroke then
			uiStroke.Color = Color3.fromRGB(51,40,150)
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
	arg.BackgroundColor3 = Color3.fromRGB(27,40,150)
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
		local color = Color3.fromRGB(27,40,150)
		local color2 = Color3.fromRGB(51,40,150)
		if arg == 6 then
			color = Color3.fromRGB(54,133,220)
			color2 = Color3.fromRGB(38,120,220)
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
		imageLabel.BackgroundColor3 = Color3.fromRGB(51,40,150)
		textLabel.Text = "YMP OFFICIAL"
		textLabel.TextColor3 = Color3.fromRGB(51,40,150)
		textLabel2.Text = Traducao.Sistema
		textLabel2.TextColor3 = Color3.fromRGB(51,40,150)
		textLabel3.TextColor3 = Color3.fromRGB(51,40,150)
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
		textLabel.TextColor3 = Color3.fromRGB(62,152,245)
		frame4.BackgroundColor3 = Color3.fromRGB(49,120,220)
		frame5.BackgroundColor3 = Color3.fromRGB(49,120,220)
		imageButton3.BackgroundColor3 = Color3.fromRGB(49,120,220)
		textLabel2.Text = "Mod"
		textLabel2.TextColor3 = Color3.fromRGB(62,152,245)
		textLabel3.TextColor3 = Color3.fromRGB(62,152,245)
		Stroke(frame4, 255, 160, 122, 1)
		Stroke(imageLabel, 255, 160, 122, 1.5)
		Stroke(frame5, 255, 160, 122, 1)
		Stroke(imageButton3, 255, 160, 122, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Admin" then
		textLabel.TextColor3 = Color3.fromRGB(20, 100, 200)
		frame4.BackgroundColor3 = Color3.fromRGB(35,74,184)
		frame5.BackgroundColor3 = Color3.fromRGB(35,74,184)
		imageButton3.BackgroundColor3 = Color3.fromRGB(35,74,184)
		textLabel2.Text = "Admin"
		textLabel2.TextColor3 = Color3.fromRGB(20, 100, 200)
		textLabel3.TextColor3 = Color3.fromRGB(20, 100, 200)
		Stroke(frame4, 220, 20, 60, 1)
		Stroke(imageLabel, 220, 20, 60, 1)
		Stroke(frame5, 220, 20, 60, 1)
		Stroke(imageButton3, 220, 20, 60, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Dev" then
		textLabel.TextColor3 = Color3.fromRGB(54,133,220)
		frame4.BackgroundColor3 = Color3.fromRGB(81,213,255)
		frame5.BackgroundColor3 = Color3.fromRGB(81,213,255)
		imageButton3.BackgroundColor3 = Color3.fromRGB(81,213,255)
		textLabel2.Text = "Dev"
		textLabel2.TextColor3 = Color3.fromRGB(54,133,220)
		textLabel3.TextColor3 = Color3.fromRGB(54,133,220)
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
	NomeRemoverFiltro.TextColor3 = Color3.fromRGB(35,74,184)
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
		GetKey.BackgroundColor3 = Color3.fromRGB(54,133,220)
		SetaES.BackgroundColor3 = Color3.fromRGB(54,133,220)
		SetaDI.BackgroundColor3 = Color3.fromRGB(54,133,220)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(93,240,255)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(54,133,220) then
		GetKey.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaES.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaDI.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
	end
end)
SetaDI.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		GetKey.BackgroundColor3 = Color3.fromRGB(54,133,220)
		SetaES.BackgroundColor3 = Color3.fromRGB(54,133,220)
		SetaDI.BackgroundColor3 = Color3.fromRGB(54,133,220)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(93,240,255)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(54,133,220) then
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
	KeyBox.TextColor3 = Color3.fromRGB(51,40,150)
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
	if GetKey.BackgroundColor3 == Color3.fromRGB(54,133,220) then
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
]====] local loader=loadstring if type(loader)~="function" then error("loadstring is not supported by this executor") end local fn=loader(source) if type(fn)~="function" then error("Could not compile YouTube Music Player") end fn() end) _G.__ZeyHubbYMPLaunching=false if ok then _G.__ZeyHubbYMPLaunched=true openYMP.Text="" if openTitle then openTitle.Text="PLAYER OPENED" end if openSub then openSub.Text="Already running" end else warn("[ZeyHubb.vs] YouTube Music Player: "..tostring(err)) openYMP.Text="FAILED TO OPEN - CHECK CONSOLE" end task.delay(2,function() if openYMP and openYMP.Parent then openYMP.Text="" if openTitle then openTitle.Text="MUSIC PLAYER" end if openSub then openSub.Text="OPEN  ·  YouTube Music" end end end) end) end) end mkSect(configPage,"Hide Buttons") do for _,btnName in ipairs(MOBILE_BTN_HIDE_ORDER)do local label=MOBILE_BTN_HIDE_LABELS[btnName]or("Hide "..btnName) local setVis setVis=mkToggle(configPage,label,function(on) hiddenMobileButtons[btnName]=on and true or nil if on then hiddenMobileButtons[btnName]=true else hiddenMobileButtons[btnName]=nil end applyMobileButtonVisibility() saveAllSettings() end) if setVis then setVis(hiddenMobileButtons[btnName]==true) end end end mkSect(configPage,"Config")do local row=mkRow(configPage,44)row.Size=UDim2.new(1,0,0,44)local saveBtn=Instance.new("TextButton",row)saveBtn.Size=UDim2.new(1,-12,0.8,0)saveBtn.Position=UDim2.new(0,6,0.1,0)saveBtn.BackgroundColor3=Color3.fromRGB(245,245,250)saveBtn.BorderSizePixel=0 saveBtn.Text="SAVE CONFIG"saveBtn.TextColor3=Color3.fromRGB(20,20,25)saveBtn.Font=Enum.Font.GothamBold saveBtn.TextSize=13 saveBtn.AutoButtonColor=false saveBtn.ZIndex=8 Instance.new("UICorner",saveBtn).CornerRadius=UDim.new(0,10)local saveStroke=Instance.new("UIStroke",saveBtn)saveStroke.Color=getThemeColor()saveStroke.Thickness=1.5 saveStroke.Transparency=0.4 saveBtn.MouseEnter:Connect(function()TS:Create(saveBtn,TweenInfo.new(0.15),{BackgroundColor3=getThemeColor()}):Play()TS:Create(saveBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)saveBtn.MouseLeave:Connect(function()TS:Create(saveBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(245,245,250)}):Play()TS:Create(saveBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(20,20,25)}):Play()end)saveBtn.Activated:Connect(function()local ok=saveAllSettings(true)saveBtn.Text=ok and"SAVED"or"ERROR"task.delay(1.2,function()if saveBtn and saveBtn.Parent then saveBtn.Text="SAVE CONFIG"end end)end)end do local row=mkRow(configPage,44)row.Size=UDim2.new(1,0,0,44)local resetPosBtn=Instance.new("TextButton",row)resetPosBtn.Size=UDim2.new(1,-12,0.8,0)resetPosBtn.Position=UDim2.new(0,6,0.1,0)resetPosBtn.BackgroundColor3=Color3.fromRGB(245,245,250)resetPosBtn.BorderSizePixel=0 resetPosBtn.Text="RESET POSITIONS"resetPosBtn.TextColor3=Color3.fromRGB(20,20,25)resetPosBtn.Font=Enum.Font.GothamBold resetPosBtn.TextSize=13 resetPosBtn.AutoButtonColor=false resetPosBtn.ZIndex=8 Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,10)local resetStroke=Instance.new("UIStroke",resetPosBtn)resetStroke.Color=getThemeColor()resetStroke.Thickness=1.5 resetStroke.Transparency=0.4 resetPosBtn.MouseEnter:Connect(function()TS:Create(resetPosBtn,TweenInfo.new(0.15),{BackgroundColor3=getThemeColor()}):Play()TS:Create(resetPosBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)resetPosBtn.MouseLeave:Connect(function()TS:Create(resetPosBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(245,245,250)}):Play()TS:Create(resetPosBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(20,20,25)}):Play()end)local resetDebounce=false resetPosBtn.Activated:Connect(function()if resetDebounce then return end resetDebounce=true resetFloatingPositions()resetPosBtn.Text="RESET"task.delay(1.2,function()if resetPosBtn and resetPosBtn.Parent then resetPosBtn.Text="RESET POSITIONS"resetDebounce=false end end)end)end do local row=mkRow(configPage,44)row.Size=UDim2.new(1,0,0,44)local delBtn=Instance.new("TextButton",row)delBtn.Size=UDim2.new(1,-12,0.8,0)delBtn.Position=UDim2.new(0,6,0.1,0)delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.BorderSizePixel=0 delBtn.Text="RESET ALL SETTINGS"delBtn.TextColor3=Color3.fromRGB(170,30,50)delBtn.Font=Enum.Font.GothamBold delBtn.TextSize=13 delBtn.AutoButtonColor=false delBtn.ZIndex=8 Instance.new("UICorner",delBtn).CornerRadius=UDim.new(0,10)local delStroke=Instance.new("UIStroke",delBtn)delStroke.Color=Color3.fromRGB(33,140,255)delStroke.Thickness=1.5 delStroke.Transparency=0.4 delBtn.MouseEnter:Connect(function()TS:Create(delBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(33,130,255)}):Play()TS:Create(delBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(255,255,255)}):Play()end)delBtn.MouseLeave:Connect(function()TS:Create(delBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(245,245,250)}):Play()TS:Create(delBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(170,30,50)}):Play()end)local deleteState=0 local originalDeleteText="RESET ALL SETTINGS"local delDebounce=false delBtn.Activated:Connect(function()if delDebounce then return end if deleteState==0 then deleteState=1 delBtn.Text="CONFIRM?"delBtn.BackgroundColor3=Color3.fromRGB(255,220,220)delBtn.TextColor3=Color3.fromRGB(32,40,150)task.delay(2,function()if delBtn and delBtn.Parent and deleteState==1 then deleteState=0 delBtn.Text=originalDeleteText delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.TextColor3=Color3.fromRGB(170,30,50)end end)elseif deleteState==1 then delDebounce=true local invoked,success=pcall(resetToFactoryDefaults)success=invoked and success delBtn.Text=success and"SETTINGS RESET"or"ERROR"delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.TextColor3=Color3.fromRGB(170,30,50)deleteState=0 task.delay(1.5,function()if delBtn and delBtn.Parent then delBtn.Text=originalDeleteText delBtn.BackgroundColor3=Color3.fromRGB(245,245,250)delBtn.TextColor3=Color3.fromRGB(170,30,50)delDebounce=false end end)end end)end local keyPage=contentPages["Settings"]or contentPages["Speed"]mkSect(keyPage,"Keybinds")mkSect(keyPage,"Movement")addKeybindRow(keyPage,"Carry Mode",KB.CarryToggle)addKeybindRow(keyPage,"Lagger Mode",KB.LaggerMode)addKeybindRow(keyPage,"Auto Left",KB.AutoLeft)addKeybindRow(keyPage,"Auto Right",KB.AutoRight)addKeybindRow(keyPage,"Float",KB.Float)mkSect(keyPage,"Combat")addKeybindRow(keyPage,"Bat Aimbot",KB.BatAimbot)addKeybindRow(keyPage,"Bypass Bat",KB.AutoBat)addKeybindRow(keyPage,"Bat V2",KB.BatV2)addKeybindRow(keyPage,"TP Bat",KB.TPBat)mkSect(keyPage,"Utility")addKeybindRow(keyPage,"Drop Brainrot",KB.DropBrainrot)addKeybindRow(keyPage,"TP Down",KB.TPFloor)addKeybindRow(keyPage,"Hide GUI",KB.GuiHide)addKeybindRow(keyPage,"Instant Reset",KB.InstantReset)local spacer=Instance.new("Frame",keyPage)spacer.Size=UDim2.new(1,0,0,16)spacer.BackgroundTransparency=1 spacer.LayoutOrder=getNextOrder(keyPage)spacer.ZIndex=7 local visualPage=contentPages["Visual"]or contentPages["Speed"]local instantResetVersion=(_G.__ZeyHubbInstantResetVersion=="V2")and"V2"or"V1"_G.__ZeyHubbInstantResetVersion=instantResetVersion local headlessEnabled=false local korbloxEnabled=false local duelPingAlertEnabled=false local duelPingAlertTask=nil local duelPingLastState=nil local headlessConnections={}local korbloxConnections={}local resetCameraConnection=nil local resetCameraSaved=nil local instantResetBusy=false local resetGaveUp=false local function lockResetCamera()local cam=workspace.CurrentCamera if not cam then return end if resetCameraConnection then pcall(function()resetCameraConnection:Disconnect()end)end resetCameraConnection=nil resetCameraSaved={cframe=cam.CFrame,type=cam.CameraType,subject=cam.CameraSubject}cam.CameraType=Enum.CameraType.Scriptable resetCameraConnection=RunService.RenderStepped:Connect(function()local current=workspace.CurrentCamera local saved=resetCameraSaved if not current or not saved then return end if current.CameraType~=Enum.CameraType.Scriptable then current.CameraType=Enum.CameraType.Scriptable end current.CFrame=saved.cframe end)end local function unlockResetCamera()if resetCameraConnection then pcall(function()resetCameraConnection:Disconnect()end);resetCameraConnection=nil end local saved=resetCameraSaved resetCameraSaved=nil if not saved then return end local cam=workspace.CurrentCamera if not cam then return end pcall(function()local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")cam.CameraType=(saved.type==Enum.CameraType.Scriptable)and Enum.CameraType.Custom or saved.type cam.CameraSubject=hum or saved.subject end)end local function doInstantResetV1()resetGaveUp=false local character=LP.Character if not character then resetGaveUp=true;return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid then resetGaveUp=true;return end local originalHipHeight=humanoid.HipHeight local attempts,done=0,false while character and character.Parent and humanoid and humanoid.Health>0 and LP.Character==character and attempts<40 do pcall(function()humanoid.HipHeight=1e30 humanoid.AutoRotate=true for _,part in ipairs(character:GetChildren())do if part:IsA("BasePart")then part.CanCollide=false end end end)if not character.Parent or humanoid.Health<=0 or LP.Character~=character then done=true;break end attempts=attempts+1 task.wait(0.05)end if not done and character and character.Parent and humanoid and humanoid.Health>0 then pcall(function()humanoid.Health=0 end)task.wait(0.1)if not character.Parent or humanoid.Health<=0 then done=true end end if not done then resetGaveUp=true if character and character.Parent and humanoid then pcall(function()humanoid.HipHeight=originalHipHeight for _,part in ipairs(character:GetChildren())do if part:IsA("BasePart")then part.CanCollide=true end end end)end end end local function doInstantResetV2()resetGaveUp=false local character=LP.Character if not character then resetGaveUp=true;return end local humanoid=character:FindFirstChildOfClass("Humanoid")local root=character:FindFirstChild("HumanoidRootPart")if not humanoid or not root then resetGaveUp=true;return end local savedPlatform,savedBreak=humanoid.PlatformStand,humanoid.BreakJointsOnDeath local BURST,WINDOW,FLING=500,0.3,1e9 local function applyFling(hum,r)hum.BreakJointsOnDeath=true hum.PlatformStand=true hum:ChangeState(Enum.HumanoidStateType.Physics)r.AssemblyAngularVelocity=Vector3.zero r.AssemblyLinearVelocity=Vector3.new(0,FLING,0)end local function attempt()local ch=LP.Character if ch~=character or not character.Parent then return false end local hum=ch:FindFirstChildOfClass("Humanoid")if not hum or hum.Health<=0 then return false end local r=ch:FindFirstChild("HumanoidRootPart")if r then pcall(applyFling,hum,r)end return true end local t0=os.clock()for _=1,BURST do if not attempt()then return end end while os.clock()-t0<WINDOW do RunService.Heartbeat:Wait()if not attempt()then return end end if not character.Parent or LP.Character~=character or humanoid.Health<=0 then return end resetGaveUp=true pcall(function()humanoid.PlatformStand=savedPlatform humanoid.BreakJointsOnDeath=savedBreak humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)root.AssemblyLinearVelocity=Vector3.zero end)end local function runInstantReset()if instantResetBusy then return end instantResetBusy=true resetGaveUp=false local oldCharacter=LP.Character local wasAntiDie=antiDieEnabled==true pcall(function()if _G.__CrystalAntiDieIsEnabled then wasAntiDie=(_G.__CrystalAntiDieIsEnabled()==true)or wasAntiDie end end)if wasAntiDie then if _G.__CrystalAntiDieStop then pcall(_G.__CrystalAntiDieStop)elseif AntiDieModule and AntiDieModule.stop then pcall(function()AntiDieModule.stop()end)end end lockResetCamera()task.spawn(function()local ok,err=pcall(function()if instantResetVersion=="V2"then doInstantResetV2()else doInstantResetV1()end end)if not ok then warn("[ZeyHubb Instant Reset] "..tostring(err));resetGaveUp=true end end)task.spawn(function()local deadline=os.clock()+25 while os.clock()<deadline do if resetGaveUp then break end local ch=LP.Character if ch and ch.Parent and ch~=oldCharacter then local hum=ch:FindFirstChildOfClass("Humanoid")local root=ch:FindFirstChild("HumanoidRootPart")if hum and root and hum.Health>0 then break end end task.wait(0.05)end unlockResetCamera()if wasAntiDie then local aliveDeadline=os.clock()+20 while os.clock()<aliveDeadline do local ch=LP.Character local hum=ch and ch:FindFirstChildOfClass("Humanoid")if ch and ch.Parent and hum and hum.Health>0 then break end task.wait(0.1)end if AntiDieModule and AntiDieModule.start then pcall(function()AntiDieModule.start()end)elseif _G.__CrystalAntiDieSet then pcall(_G.__CrystalAntiDieSet,true)end if setAntiDieVisual then pcall(setAntiDieVisual,true)end end instantResetBusy=false end)end _G.__ZeyHubbRunInstantReset=runInstantReset local function cleanConnections(list)for _,conn in ipairs(list)do pcall(function()conn:Disconnect()end)end table.clear(list)end local function setHeadless(on)headlessEnabled=on==true cleanConnections(headlessConnections)local char=LP.Character local head=char and char:FindFirstChild("Head")if not head then return end if headlessEnabled then head.Transparency=1 head.CanCollide=false local face=head:FindFirstChild("face")if face then pcall(function()face:Destroy()end)end if not head:FindFirstChild("HeadlessMesh")then local mesh=Instance.new("SpecialMesh")mesh.Name="HeadlessMesh"mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId="rbxassetid://1095708"mesh.Scale=Vector3.new(0.001,0.001,0.001)mesh.Parent=head end table.insert(headlessConnections,head:GetPropertyChangedSignal("Transparency"):Connect(function()if headlessEnabled and head.Parent and head.Transparency~=1 then head.Transparency=1 end end))table.insert(headlessConnections,head.ChildAdded:Connect(function(child)if headlessEnabled and child.Name=="face"and child:IsA("Decal")then pcall(function()child:Destroy()end)end end))else local mesh=head:FindFirstChild("HeadlessMesh")if mesh then pcall(function()mesh:Destroy()end)end head.Transparency=0 head.CanCollide=true end end local function setKorblox(on)korbloxEnabled=on==true cleanConnections(korbloxConnections)local char=LP.Character if not char then return end local humanoid=char:FindFirstChildOfClass("Humanoid")if not korbloxEnabled then local rightLeg=char:FindFirstChild("Right Leg")if rightLeg then local mesh=rightLeg:FindFirstChild("KorbloxMesh")if mesh then pcall(function()mesh:Destroy()end)end end local korbloxLeg=char:FindFirstChild("KorbloxLeg")if korbloxLeg then pcall(function()korbloxLeg:Destroy()end)end for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"})do local part=char:FindFirstChild(name)if part and part:IsA("BasePart")then part.Transparency=0 end end local r6=char:FindFirstChild("Right Leg")if r6 and r6:IsA("BasePart")then r6.Color=Color3.fromRGB(163,162,165)end return end if not humanoid then return end task.spawn(function()task.wait(0.1)if not korbloxEnabled or LP.Character~=char or not char.Parent then return end local meshId,textureId="rbxassetid://101851696","rbxassetid://101851254"local dark=Color3.fromRGB(64,64,64)if humanoid.RigType==Enum.HumanoidRigType.R6 then local rightLeg=char:FindFirstChild("Right Leg")if not rightLeg or rightLeg:FindFirstChild("KorbloxMesh")then return end for _,child in ipairs(rightLeg:GetChildren())do if child:IsA("SpecialMesh")or child:IsA("CharacterMesh")then pcall(function()child:Destroy()end)end end rightLeg.Color=dark table.insert(korbloxConnections,rightLeg:GetPropertyChangedSignal("Color"):Connect(function()if korbloxEnabled and rightLeg.Parent and rightLeg.Color~=dark then rightLeg.Color=dark end end))local mesh=Instance.new("SpecialMesh")mesh.Name="KorbloxMesh"mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId=meshId mesh.TextureId=textureId mesh.Scale=Vector3.one mesh.Parent=rightLeg elseif humanoid.RigType==Enum.HumanoidRigType.R15 then local upper=char:FindFirstChild("RightUpperLeg")if not upper or char:FindFirstChild("KorbloxLeg")then return end upper.Transparency=1 local lower,foot=char:FindFirstChild("RightLowerLeg"),char:FindFirstChild("RightFoot")if lower then lower.Transparency=1 end if foot then foot.Transparency=1 end local leg=Instance.new("Part")leg.Name="KorbloxLeg"leg.Size=Vector3.new(1,2,1)leg.Anchored=false leg.CanCollide=false leg.Massless=true leg.Color=dark leg.Parent=char local mesh=Instance.new("SpecialMesh")mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId=meshId mesh.TextureId=textureId mesh.Scale=Vector3.one mesh.Parent=leg local weld=Instance.new("Weld")weld.Part0=upper weld.Part1=leg weld.C0=CFrame.new(0,-0.45,0)weld.Parent=leg end end)end local function showDuelPingNotification(_,pingMs)local parent=gui and gui.Parent or pgui if not parent then return end local existing=parent:FindFirstChild("ZeyHubbPingWarning")if existing then return end local warningGui=Instance.new("ScreenGui")warningGui.Name="ZeyHubbPingWarning"warningGui.ResetOnSpawn=false warningGui.IgnoreGuiInset=true warningGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling warningGui.DisplayOrder=99999 warningGui.Parent=parent _G.__ZeyHubbPingWarningNextAllowed=tick()+13.5 local warningFrame=Instance.new("Frame")warningFrame.Name="WarningFrame"warningFrame.Size=UDim2.new(0,246,0,34)warningFrame.Position=UDim2.new(0.5,-123,0,-42)warningFrame.BackgroundColor3=Color3.fromRGB(35,22,10)warningFrame.BackgroundTransparency=0.08 warningFrame.BorderSizePixel=0 warningFrame.ZIndex=1000 warningFrame.Parent=warningGui Instance.new("UICorner",warningFrame).CornerRadius=UDim.new(0,10)local warningGradient=Instance.new("UIGradient")warningGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(74,43,16)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(35,22,10)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,95,165)),})warningGradient.Rotation=0 warningGradient.Parent=warningFrame local warningStroke=Instance.new("UIStroke",warningFrame)warningStroke.Color=Color3.fromRGB(53,128,220)warningStroke.Thickness=1.6 warningStroke.Transparency=0.02 warningStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border local glowTween=TS:Create(warningStroke,TweenInfo.new(0.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Transparency=0.48,Thickness=2.4,Color=Color3.fromRGB(105,225,255)})glowTween:Play()local gradientGlowTween=TS:Create(warningGradient,TweenInfo.new(1.8,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1),{Rotation=360})gradientGlowTween:Play()local warningIcon=Instance.new("TextLabel")warningIcon.Name="WarningIcon"warningIcon.Size=UDim2.new(0,24,1,0)warningIcon.Position=UDim2.new(0,7,0,0)warningIcon.BackgroundTransparency=1 warningIcon.Text="⚡"warningIcon.TextColor3=Color3.fromRGB(255,255,255)warningIcon.Font=Enum.Font.GothamBlack warningIcon.TextSize=17 warningIcon.TextXAlignment=Enum.TextXAlignment.Center warningIcon.ZIndex=1001 warningIcon.Parent=warningFrame local warningText=Instance.new("TextLabel")warningText.Name="WarningText"warningText.Size=UDim2.new(1,-36,1,0)warningText.Position=UDim2.new(0,32,0,0)warningText.BackgroundTransparency=1 warningText.Text="MORE THAN 120 PING DONT DUEL"warningText.TextColor3=Color3.fromRGB(255,255,255)warningText.Font=Enum.Font.GothamBlack warningText.TextSize=11 warningText.TextXAlignment=Enum.TextXAlignment.Left warningText.TextStrokeColor3=Color3.fromRGB(0,0,0)warningText.TextStrokeTransparency=0.65 warningText.ZIndex=1001 warningText.Parent=warningFrame TS:Create(warningFrame,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-123,0,14)}):Play()task.delay(3,function()if warningGui and warningGui.Parent then TS:Create(warningFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-123,0,-42),BackgroundTransparency=1}):Play()TS:Create(warningText,TweenInfo.new(0.2),{TextTransparency=1}):Play()TS:Create(warningIcon,TweenInfo.new(0.2),{TextTransparency=1}):Play()task.wait(0.35)pcall(function()glowTween:Cancel()end)pcall(function()gradientGlowTween:Cancel()end)pcall(function()warningGui:Destroy()end)_G.__ZeyHubbPingWarningNextAllowed=tick()+10 end end)end local function setDuelPingAlert(on)duelPingAlertEnabled=on==true if duelPingAlertTask then pcall(task.cancel,duelPingAlertTask);duelPingAlertTask=nil end duelPingLastState=nil if not duelPingAlertEnabled then local parent=gui and gui.Parent or pgui local existing=parent and parent:FindFirstChild("ZeyHubbPingWarning")if existing then pcall(function()existing:Destroy()end)end return end duelPingAlertTask=task.spawn(function()while duelPingAlertEnabled do local pingMs=0 pcall(function()local ping=LP:GetNetworkPing()if type(ping)=="number"and ping>=0 then pingMs=math.floor(ping*1000+0.5)end end)local now=tick()if pingMs>120 and now>=(_G.__ZeyHubbPingWarningNextAllowed or 0)then showDuelPingNotification(false,pingMs)end task.wait(0.5)end end)end LP.CharacterAdded:Connect(function(char)task.wait(0.35)if headlessEnabled then pcall(setHeadless,true)end if korbloxEnabled then pcall(setKorblox,true)end end)mkSect(visualPage,"Character Protection")local setHeadlessVisual=mkToggle(visualPage,"Headless",function(on)_G.__ZeyHubbHeadlessEnabled=on==true setHeadless(on)saveAllSettings()end)_G.__ZeyHubbHeadlessSetVisual=setHeadlessVisual _G.__ZeyHubbHeadlessApply=setHeadless local setKorbloxVisual=mkToggle(visualPage,"Korblox",function(on)_G.__ZeyHubbKorbloxEnabled=on==true setKorblox(on)saveAllSettings()end)_G.__ZeyHubbKorbloxSetVisual=setKorbloxVisual _G.__ZeyHubbKorbloxApply=setKorblox mkSect(visualPage,"UI Layout") rhLockSetB=mkToggle(visualPage,"Lock UI",function(on)toggleLockUI(on);mobileButtonsLocked=on end) setLockUIVisual=function(v)if rhLockSetB then rhLockSetB(v)end end if uiLocked then setLockUIVisual(true)end setHideButtonsVisual=mkToggle(visualPage,"Hide Button",function(on)toggleHideButtons(on)end) if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled)end mkSect(visualPage,"Scale")do local row=mkRow(visualPage,42)mkLabel(row,"UI Scale")uiScaleBox=mkBox(row,uiScaleValue,50,56,function(v)local n=_clamp(_floor(v+0.5),50,150)uiScaleValue=n if mainUIScale then mainUIScale.Scale=n/100 end saveAllSettings()end)end do local row=mkRow(visualPage,42)mkLabel(row,"Button Scale")rhButtonScaleBox=mkBox(row,_floor(floatingButtonScale*100),50,56,function(v)local val=_clamp(v,50,200)floatingButtonScale=val/100 applyFloatingButtonScale()saveAllSettings()end)setSmallButtonsVisual=function()if rhButtonScaleBox then rhButtonScaleBox.Text=tostring(_floor(floatingButtonScale*100+0.5))end end end do local row=mkRow(visualPage,42)mkLabel(row,"Floating Button Shape")local shapeOpts={"V1","V2","V3"}local function repaintShapes()if repaintFloatingButtons then repaintFloatingButtons()elseif MobilePanel then for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")then paintFloatingBtn(btn,btn:GetAttribute("MobActive")==true)end end end end local shapeCurrent=floatingButtonShape or"V1"mkSelector(row,shapeCurrent,shapeOpts,function(direction,updateLabel)local idx=1 for i,v in ipairs(shapeOpts)do if v==floatingButtonShape then idx=i break end end idx=idx+direction if idx<1 then idx=#shapeOpts elseif idx>#shapeOpts then idx=1 end floatingButtonShape=shapeOpts[idx] repaintShapes() updateLabel(floatingButtonShape) pcall(saveAllSettings,true)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Auto Steal Scale")stealBarScaleBox=mkBox(row,_floor((stealBarScale or 1)*100),50,56,function(v)local val=_clamp(v,40,200)stealBarScale=val/100 if pbScale then pbScale.Scale=stealBarScale end saveAllSettings()end)end mkSect(visualPage,"Avatar & Skins")do local row=mkRow(visualPage,42)mkLabel(row,"Anim Pack")local currentIndex=1 for i,entry in ipairs(ANIM_PACK_ORDER)do if entry[2]==currentAnimPack then currentIndex=i;break end end local container=Instance.new("Frame",row)container.Size=UDim2.new(0,148,1,0)container.Position=UDim2.new(1,-154,0,0)container.ClipsDescendants=true;container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)animSelectorLabel=Instance.new("TextLabel",container)animSelectorLabel.Size=UDim2.new(0,80,0,26)animSelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)animSelectorLabel.BackgroundTransparency=1 animSelectorLabel.Text=ANIM_PACK_ORDER[currentIndex][2]animSelectorLabel.TextColor3=WHITE animSelectorLabel.Font=Enum.Font.GothamBold animSelectorLabel.TextSize=12 animSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center animSelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function updateAnimSelector(direction)local idx=1 for i,entry in ipairs(ANIM_PACK_ORDER)do if entry[2]==currentAnimPack then idx=i;break end end local newIdx=idx+direction if newIdx<1 then newIdx=#ANIM_PACK_ORDER end if newIdx>#ANIM_PACK_ORDER then newIdx=1 end local packName=ANIM_PACK_ORDER[newIdx][2]if packName=="Off"then stopAnimPack()else startAnimPack(packName)end end leftBtn.Activated:Connect(function()updateAnimSelector(-1)end)rightBtn.Activated:Connect(function()updateAnimSelector(1)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Outfit")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,148,1,0)container.Position=UDim2.new(1,-154,0,0)container.ClipsDescendants=true;container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)outfitSelectorLabel=Instance.new("TextLabel",container)outfitSelectorLabel.Size=UDim2.new(0,80,0,26)outfitSelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)outfitSelectorLabel.BackgroundTransparency=1 outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label outfitSelectorLabel.TextColor3=WHITE outfitSelectorLabel.Font=Enum.Font.GothamBold outfitSelectorLabel.TextSize=12 outfitSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center outfitSelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function updateOutfit(direction)pcall(VX7A.stop)local newIdx=currentOutfitIndex+direction if newIdx<1 then newIdx=#OUTFITS end if newIdx>#OUTFITS then newIdx=1 end currentOutfitIndex=newIdx pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end saveAllSettings()end leftBtn.Activated:Connect(function()updateOutfit(-1)end)rightBtn.Activated:Connect(function()updateOutfit(1)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Best Avatars")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,148,1,0)container.Position=UDim2.new(1,-154,0,0)container.ClipsDescendants=true;container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)VX7A.label=Instance.new("TextLabel",container)VX7A.label.Size=UDim2.new(0,80,0,26)VX7A.label.Position=UDim2.new(0.5,-40,0.5,-13)VX7A.label.BackgroundTransparency=1 VX7A.label.Text=VX7A.labels[VX7A.index+1]or"OFF"VX7A.label.TextColor3=WHITE VX7A.label.Font=Enum.Font.GothamBold VX7A.label.TextSize=12 VX7A.label.TextXAlignment=Enum.TextXAlignment.Center VX7A.label.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function stepVX7Avatar(direction)local pos=VX7A.index+1+direction if pos<1 then pos=#VX7A.labels end if pos>#VX7A.labels then pos=1 end VX7A.apply(pos-1)task.defer(function()pcall(saveAllSettings)end)end leftBtn.Activated:Connect(function()stepVX7Avatar(-1)end)rightBtn.Activated:Connect(function()stepVX7Avatar(1)end)end do local row=mkRow(visualPage,42)mkLabel(row,"Medusa Skin")local SKINS={{id="Default",text="Default"},{id="Skull",text="Skull"},{id="GoldenDesertEagle",text="Golden Eagle"},{id="NeonSkull",text="Neon Skull"},{id="Crystal",text="Crystal"},{id="Bomb",text="Bomb"},}local function curIndex()local cur=_G.RivalMedusaSkin or"Default"for i,sk in ipairs(SKINS)do if sk.id==cur then return i end end return 1 end local medusaLabel medusaLabel=mkSelector(row,SKINS[curIndex()].text,{},function(direction,updateLabel)local idx=curIndex()+direction if idx<1 then idx=#SKINS end if idx>#SKINS then idx=1 end if _G.RivalSetMedusaSkin then _G.RivalSetMedusaSkin(SKINS[idx].id)end updateLabel(SKINS[idx].text)end)medusaLabel.Size=UDim2.new(0,96,0,26)medusaLabel.Position=UDim2.new(0.5,-48,0.5,-13)_G.RivalMedusaSkinRefreshUI=function()medusaLabel.Text=SKINS[curIndex()].text end end mkSect(visualPage,"Graphics")do local row=mkRow(visualPage,42)mkLabel(row,"Title Color")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,148,1,0)container.Position=UDim2.new(1,-154,0,0)container.ClipsDescendants=true;container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)rivalTitleSelectorLabel=Instance.new("TextLabel",container)rivalTitleSelectorLabel.Size=UDim2.new(0,80,0,26)rivalTitleSelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)rivalTitleSelectorLabel.BackgroundTransparency=1 rivalTitleSelectorLabel.Text=currentRivalTitleTheme rivalTitleSelectorLabel.TextColor3=WHITE rivalTitleSelectorLabel.Font=Enum.Font.GothamBold rivalTitleSelectorLabel.TextSize=12 rivalTitleSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center rivalTitleSelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local RIVAL_THEME_LIST={"Blue","White","Black","Silver"}local function cycleRivalTitle(dir)local idx=1 for i,name in ipairs(RIVAL_THEME_LIST)do if name==currentRivalTitleTheme then idx=i;break end end local newIdx=idx+dir if newIdx<1 then newIdx=#RIVAL_THEME_LIST end if newIdx>#RIVAL_THEME_LIST then newIdx=1 end applyRivalTitleTheme(RIVAL_THEME_LIST[newIdx])end leftBtn.Activated:Connect(function()cycleRivalTitle(-1)end)rightBtn.Activated:Connect(function()cycleRivalTitle(1)end)end setVividVisual=mkToggle(visualPage,"Vivid Graphics",function(on)toggleVividGraphics(on)if setVividVisual then setVividVisual(on)end end)if setVividVisual then setVividVisual(vividGraphicsEnabled)end do local row=mkRow(visualPage,42)mkLabel(row,"Stretch Rez")local stretchPill,stretchDot=mkPill(row,48)local stretchOn=false local function setStretch(s)stretchOn=s animPill(stretchPill,stretchDot,s)if s then enableStretch()else disableStretch()end stretchEnabled=s end local stretchClk=Instance.new("TextButton",stretchPill)stretchClk.Size=UDim2.new(1,0,1,0)stretchClk.BackgroundTransparency=1 stretchClk.Text=""stretchClk.AutoButtonColor=false stretchClk.ZIndex=10 stretchClk.Activated:Connect(function()setStretch(not stretchOn)end)_G.stretchToggleSetter=setStretch end setAntiLagVisual=mkToggle(visualPage,"Anti Lag",function(on)if on then enableAntiLag()else disableAntiLag()end antiLagEnabled=on==true pcall(saveAllSettings,true)end)do local row=mkRow(visualPage,42)mkLabel(row,"Sky Theme")local container=Instance.new("Frame",row)container.Size=UDim2.new(0,148,1,0)container.Position=UDim2.new(1,-154,0,0)container.ClipsDescendants=true;container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,28,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBold leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)skySelectorLabel=Instance.new("TextLabel",container)skySelectorLabel.Size=UDim2.new(0,96,0,26)skySelectorLabel.Position=UDim2.new(0.5,-48,0.5,-13)skySelectorLabel.BackgroundTransparency=1 skySelectorLabel.Text=skyTheme skySelectorLabel.TextColor3=WHITE skySelectorLabel.Font=Enum.Font.GothamBold skySelectorLabel.TextSize=11 skySelectorLabel.TextXAlignment=Enum.TextXAlignment.Center skySelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,28,0,26)rightBtn.Position=UDim2.new(1,-28,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBold rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local function updateSkySelector(direction)local idx=1 for i,name in ipairs(SKY_PRESETS_LIST)do if name==skyTheme then idx=i;break end end local newIdx=idx+direction if newIdx<1 then newIdx=#SKY_PRESETS_LIST end if newIdx>#SKY_PRESETS_LIST then newIdx=1 end local name=SKY_PRESETS_LIST[newIdx]skyTheme=name pcall(applyCustomSky,name)if skySelectorLabel then skySelectorLabel.Text=name end pcall(saveAllSettings,true)end leftBtn.Activated:Connect(function()updateSkySelector(-1)end)rightBtn.Activated:Connect(function()updateSkySelector(1)end)end mkSect(visualPage,"ESP & Overlays")setESPVIsual=mkToggle(visualPage,"Player ESP",function(on)toggleESP(on)end)setESPLineVisual=mkToggle(visualPage,"ESP Line",function(on)if on then startESPLine()else stopESPLine()end end)do  if _G.RHBrainrotTransparency then pcall(_G.RHBrainrotTransparency.SetHeld,false) pcall(_G.RHBrainrotTransparency.SetBase,false) end end pbFrame=Instance.new("Frame",gui)pbFrame.Name="ZeyHubbAutoStealHud"local BAR_W,BAR_H=260,46 pbFrame.Size=UDim2.new(0,BAR_W,0,BAR_H)pbFrame.Position=UDim2.new(1,-BAR_W-14,0,14)pbFrame.BackgroundColor3=Color3.fromRGB(2,7,12)pbFrame.BackgroundTransparency=0.05 pbFrame.BorderSizePixel=0 pbFrame.Active=true pbFrame.Visible=false pbFrame.ZIndex=500 Instance.new("UICorner",pbFrame).CornerRadius=UDim.new(0,14)pbScale=Instance.new("UIScale",pbFrame)pbScale.Scale=stealBarScale or 1 local pbStroke=Instance.new("UIStroke",pbFrame)pbStroke.Name="OuterStroke"pbStroke.Color=Color3.fromRGB(100,220,255)pbStroke.Thickness=1.05 pbStroke.Transparency=0.22 local pbGrad=Instance.new("UIGradient",pbFrame)pbGrad.Rotation=90 pbGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(28,16,6)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(2,7,12)),})local topLine=Instance.new("Frame",pbFrame)topLine.Name="TopAccent"topLine.Size=UDim2.new(1,-20,0,2)topLine.Position=UDim2.new(0,10,0,0)topLine.BackgroundColor3=Color3.fromRGB(70,210,255)topLine.BorderSizePixel=0 topLine.ZIndex=507 Instance.new("UICorner",topLine).CornerRadius=UDim.new(1,0)local topLineGrad=Instance.new("UIGradient",topLine)topLineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0.00,1),NumberSequenceKeypoint.new(0.25,0.15),NumberSequenceKeypoint.new(0.50,0),NumberSequenceKeypoint.new(0.75,0.15),NumberSequenceKeypoint.new(1.00,1),})local stealAvatar=Instance.new("Frame",pbFrame)stealAvatar.Name="StealAvatar"stealAvatar.Size=UDim2.new(0,22,0,22)stealAvatar.Position=UDim2.new(0,10,0,4)stealAvatar.BackgroundColor3=Color3.fromRGB(10,20,30)stealAvatar.BorderSizePixel=0 stealAvatar.ZIndex=508 Instance.new("UICorner",stealAvatar).CornerRadius=UDim.new(1,0)local stealAvStroke=Instance.new("UIStroke",stealAvatar)stealAvStroke.Color=Color3.fromRGB(80,215,255)stealAvStroke.Thickness=1.3 stealAvStroke.Transparency=0.12 local stealAvImg=Instance.new("ImageLabel",stealAvatar)stealAvImg.Size=UDim2.new(1,0,1,0)stealAvImg.BackgroundTransparency=1 stealAvImg.Image="rbxthumb://type=AvatarHeadShot&id="..tostring(LP.UserId).."&w=150&h=150"stealAvImg.ZIndex=509 Instance.new("UICorner",stealAvImg).CornerRadius=UDim.new(1,0) local hudTitle=Instance.new("TextLabel",pbFrame)hudTitle.Name="AutoStealTitle"hudTitle.Visible=false hudTitle.Size=UDim2.new(0,1,0,1)hudTitle.Position=UDim2.new(0,0,0,0)hudTitle.BackgroundTransparency=1 hudTitle.Text="" hudTitle.TextColor3=Color3.fromRGB(88,229,255)hudTitle.Font=Enum.Font.GothamBlack hudTitle.TextSize=1 hudTitle.ZIndex=1 local hudGrad=Instance.new("UIGradient",hudTitle)hudGrad.Name="HudShine"hudGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(245,255,255)),ColorSequenceKeypoint.new(0.30,Color3.fromRGB(100,220,255)),ColorSequenceKeypoint.new(0.55,Color3.fromRGB(50,190,255)),ColorSequenceKeypoint.new(0.80,Color3.fromRGB(63,154,248)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(200,245,255)),})local hudStroke=Instance.new("UIStroke",hudTitle)hudStroke.Color=Color3.fromRGB(40,180,255)hudStroke.Thickness=1.2 hudStroke.Transparency=0.4 task.spawn(function()while hudTitle and hudTitle.Parent and hudGrad and hudGrad.Parent do hudGrad.Offset=Vector2.new(-1,0)local tw=TS:Create(hudGrad,TweenInfo.new(1.4,Enum.EasingStyle.Linear),{Offset=Vector2.new(1,0)})tw:Play()tw.Completed:Wait()task.wait(0.2)end end)task.spawn(function()local up=true while hudTitle and hudTitle.Parent and hudStroke and hudStroke.Parent do local goal=up and 0.15 or 0.55 local tw=TS:Create(hudStroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goal})tw:Play()tw.Completed:Wait()up=not up end end)progressStatus=Instance.new("TextLabel",pbFrame)progressStatus.Name="StealProgressStatus"progressStatus.Size=UDim2.new(0,75,0,14)progressStatus.Position=UDim2.new(0,112,0,5)progressStatus.BackgroundTransparency=1 progressStatus.Text="READY"progressStatus.TextColor3=Color3.fromRGB(84,220,255)progressStatus.Font=Enum.Font.GothamBold progressStatus.TextSize=11 progressStatus.TextXAlignment=Enum.TextXAlignment.Left progressStatus.ZIndex=505 infoLabel=Instance.new("TextLabel",pbFrame)infoLabel.Name="PerformanceStats"infoLabel.Size=UDim2.new(0,90,0,14)infoLabel.Position=UDim2.new(1,-98,0,5)infoLabel.BackgroundTransparency=1 infoLabel.Text="FPS --  MS --"infoLabel.TextColor3=Color3.fromRGB(64,174,226)infoLabel.Font=Enum.Font.GothamMedium infoLabel.TextSize=10 infoLabel.TextXAlignment=Enum.TextXAlignment.Right infoLabel.ZIndex=505 local stealTrack=Instance.new("Frame",pbFrame)stealTrack.Name="StealProgressTrack"stealTrack.Size=UDim2.new(1,-20,0,12)stealTrack.Position=UDim2.new(0,10,1,-18)stealTrack.BackgroundColor3=Color3.fromRGB(22,12,4)stealTrack.BackgroundTransparency=0.1 stealTrack.BorderSizePixel=0 stealTrack.ClipsDescendants=true stealTrack.ZIndex=502 Instance.new("UICorner",stealTrack).CornerRadius=UDim.new(1,0)local trackStroke=Instance.new("UIStroke",stealTrack)trackStroke.Color=Color3.fromRGB(100,220,255)trackStroke.Thickness=1.0 trackStroke.Transparency=0.25 progressFill=Instance.new("Frame",stealTrack)progressFill.Name="StealProgressFill"progressFill.Size=UDim2.new(0,0,1,0)progressFill.BackgroundColor3=Color3.fromRGB(40,180,255)progressFill.BackgroundTransparency=0 progressFill.BorderSizePixel=0 progressFill.ZIndex=503 Instance.new("UICorner",progressFill).CornerRadius=UDim.new(1,0)local fillGrad=Instance.new("UIGradient",progressFill)fillGrad.Name="FillGrad"fillGrad.Rotation=0 fillGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,230)),ColorSequenceKeypoint.new(0.15,Color3.fromRGB(140,235,255)),ColorSequenceKeypoint.new(0.40,Color3.fromRGB(70,210,255)),ColorSequenceKeypoint.new(0.70,Color3.fromRGB(48,120,220)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(30,150,255)),})local fillGlow=Instance.new("Frame",progressFill)fillGlow.Name="FillGlow"fillGlow.Size=UDim2.new(1,0,0,5)fillGlow.Position=UDim2.new(0,0,0,0)fillGlow.BackgroundColor3=Color3.fromRGB(245,255,255)fillGlow.BackgroundTransparency=1 fillGlow.BorderSizePixel=0 fillGlow.Visible=false fillGlow.ZIndex=504 local shimmer=Instance.new("Frame",progressFill)shimmer.Name="Shimmer"shimmer.Size=UDim2.new(0,28,1,0)shimmer.Position=UDim2.new(-0.2,0,0,0)shimmer.BackgroundColor3=Color3.fromRGB(255,255,255)shimmer.BackgroundTransparency=0.55 shimmer.BorderSizePixel=0 shimmer.Visible=true shimmer.ZIndex=505 local shGrad=Instance.new("UIGradient",shimmer)shGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0.00,1),NumberSequenceKeypoint.new(0.40,0.15),NumberSequenceKeypoint.new(0.60,0.15),NumberSequenceKeypoint.new(1.00,1),})task.spawn(function()while shimmer and shimmer.Parent do shimmer.Position=UDim2.new(-0.35,0,0,0)local tw=TS:Create(shimmer,TweenInfo.new(0.75,Enum.EasingStyle.Linear),{Position=UDim2.new(1.25,0,0,0)})tw:Play()tw.Completed:Wait()task.wait(0.12)end end)progressPct=Instance.new("TextLabel",stealTrack)progressPct.Name="StealProgressPercent"progressPct.Size=UDim2.new(1,-8,1,0)progressPct.Position=UDim2.new(0,4,0,0)progressPct.BackgroundTransparency=1 progressPct.Text="0%"progressPct.TextColor3=Color3.fromRGB(255,255,255)progressPct.Font=Enum.Font.GothamBlack progressPct.TextSize=11 progressPct.TextXAlignment=Enum.TextXAlignment.Center progressPct.TextStrokeTransparency=0.35 progressPct.TextStrokeColor3=Color3.fromRGB(20,8,0)progressPct.ZIndex=506 updateStealProgress(0,"READY") function applyStealBarStyle(style) style = style or stealBarStyle or "V1" stealBarStyle = style if not pbFrame or not pbFrame.Parent then return end local track = pbFrame:FindFirstChild("StealProgressTrack") local title = pbFrame:FindFirstChild("AutoStealTitle") local stealAv = pbFrame:FindFirstChild("StealAvatar") if stealAv then stealAv.Visible = true stealAv.Size = UDim2.new(0, 22, 0, 22) stealAv.Position = UDim2.new(0, 10, 0, 4) stealAv.ZIndex = 508 end if title then title.Visible = false title.Text = "" end local status = pbFrame:FindFirstChild("StealProgressStatus") local stats = pbFrame:FindFirstChild("PerformanceStats") or (track and track:FindFirstChild("PerformanceStats")) local fill = track and track:FindFirstChild("StealProgressFill") local pct = (track and track:FindFirstChild("StealProgressPercent")) or pbFrame:FindFirstChild("StealProgressPercent") local top = pbFrame:FindFirstChild("TopAccent") local pbStroke = pbFrame:FindFirstChild("OuterStroke") local pbCorner = pbFrame:FindFirstChildOfClass("UICorner") local pbGrad = pbFrame:FindFirstChildOfClass("UIGradient") local trackCorner = track and track:FindFirstChildOfClass("UICorner") local fillCorner = fill and fill:FindFirstChildOfClass("UICorner") local trackStroke = track and track:FindFirstChildOfClass("UIStroke")  if fill then local glow = fill:FindFirstChild("FillGlow") if glow then glow.Visible = false glow.BackgroundTransparency = 1 end end if style == "V3" then local BAR_W, BAR_H = 320, 62 pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H) pbFrame.Position = UDim2.new(1, -BAR_W-14, 0, 14) pbFrame.BackgroundTransparency = 0.04 pbFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 2) if pbStroke then pbStroke.Enabled = true pbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border pbStroke.Color = Color3.fromRGB(65,160,255) pbStroke.Transparency = 0.20 pbStroke.Thickness = 1.05 end if pbGrad then pbGrad.Enabled = true pbGrad.Rotation = 90 pbGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 24, 8)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 6, 2)) }) end if pbCorner then pbCorner.CornerRadius = UDim.new(0, 14) end if title then title.Visible = false title.Parent = pbFrame title.Size = UDim2.new(0, 1, 0, 1) title.Position = UDim2.new(0, 0, 0, 0) title.Text = "" title.TextSize = 1 title.TextWrapped = false title.TextTruncate = Enum.TextTruncate.AtEnd title.Font = Enum.Font.GothamBlack title.TextColor3 = Color3.fromRGB(91,235,255) title.ZIndex = 505 end if status then status.Visible = true status.Parent = pbFrame status.Size = UDim2.new(0, 82, 0, 15) status.Position = UDim2.new(0, 105, 0, 5) status.TextSize = 10 status.TextWrapped = false status.TextTruncate = Enum.TextTruncate.AtEnd status.ZIndex = 505 end if top then top.Visible = true top.Size = UDim2.new(0.35, 0, 0, 2) top.Position = UDim2.new(0.325, 0, 0, 0) top.BackgroundColor3 = Color3.fromRGB(68,165,255) end if track then track.Size = UDim2.new(1, -20, 0, 30) track.Position = UDim2.new(0, 10, 0, 27) track.BackgroundColor3 = Color3.fromRGB(16, 9, 3) track.BackgroundTransparency = 0.04 track.BorderSizePixel = 0 track.ClipsDescendants = true if trackCorner then trackCorner.CornerRadius = UDim.new(1, 0) end if not trackStroke then trackStroke = Instance.new("UIStroke") trackStroke.Name = "TrackStroke" trackStroke.Parent = track end trackStroke.Enabled = true trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border trackStroke.Thickness = 1.0 trackStroke.Transparency = 0.20 trackStroke.Color = Color3.fromRGB(100, 220, 255) end if fill then if fillCorner then fillCorner.CornerRadius = UDim.new(1, 0) end fill.BackgroundColor3 = Color3.fromRGB(60, 200, 255) fill.Position = UDim2.new(0, 0, 0, 0) local fg = fill:FindFirstChildOfClass("UIGradient") if not fg then fg = Instance.new("UIGradient") fg.Parent = fill end fg.Rotation = 0 fg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 252, 230)), ColorSequenceKeypoint.new(0.18, Color3.fromRGB(90,232,255)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(70, 210, 255)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(49,120,220)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(37,120,220)) }) local glow = fill:FindFirstChild("FillGlow") if glow then glow.Visible = false glow.BackgroundTransparency = 1 end for _, child in ipairs(fill:GetChildren()) do if child:IsA("Frame") and child.Name:lower():find("shimmer") then child.Visible = true child.BackgroundTransparency = 0.50 end end end if stats then stats.Visible = true stats.Parent = pbFrame stats.Size = UDim2.new(0, 115, 0, 15) stats.Position = UDim2.new(0, 195, 0, 5) stats.BackgroundTransparency = 1 stats.TextSize = 9 stats.TextWrapped = false stats.TextTruncate = Enum.TextTruncate.AtEnd stats.Font = Enum.Font.GothamMedium stats.TextColor3 = Color3.fromRGB(85,222,255) stats.TextXAlignment = Enum.TextXAlignment.Right stats.TextYAlignment = Enum.TextYAlignment.Center stats.ZIndex = 505 end if pct then pct.Visible = true pct.Parent = track or pbFrame pct.Size = UDim2.new(1, -8, 1, 0) pct.Position = UDim2.new(0, 4, 0, 0) pct.BackgroundTransparency = 1 pct.TextSize = 13 pct.TextWrapped = false pct.Font = Enum.Font.GothamBlack pct.TextColor3 = Color3.fromRGB(255, 255, 255) pct.TextXAlignment = Enum.TextXAlignment.Center pct.TextYAlignment = Enum.TextYAlignment.Center pct.ZIndex = 506 end elseif style == "V2" then  local BAR_W, BAR_H = 300, 30 pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H) pbFrame.BackgroundTransparency = 1 if pbStroke then pbStroke.Enabled = false end if pbGrad then pbGrad.Enabled = false end if pbCorner then pbCorner.CornerRadius = UDim.new(0, 0) end if title then title.Visible = false end if status then status.Visible = false end if top then top.Visible = false end if track then track.Size = UDim2.new(1, 0, 1, 0) track.Position = UDim2.new(0, 0, 0, 0) track.BackgroundColor3 = Color3.fromRGB(12, 7, 2) track.BackgroundTransparency = 0.02 track.BorderSizePixel = 0 track.ClipsDescendants = true if trackCorner then trackCorner.CornerRadius = UDim.new(0, 6) end if not trackStroke then trackStroke = Instance.new("UIStroke") trackStroke.Name = "TrackStroke" trackStroke.Parent = track end trackStroke.Enabled = true trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border trackStroke.LineJoinMode = Enum.LineJoinMode.Round trackStroke.Thickness = 1.0 trackStroke.Transparency = 0.12 trackStroke.Color = Color3.fromRGB(67,164,255) end if fill then  if fillCorner then fillCorner.CornerRadius = UDim.new(0, 4) end fill.BackgroundColor3 = Color3.fromRGB(56,137,225) fill.BorderSizePixel = 0 fill.Position = UDim2.new(0, 2, 0, 2)  local curX = fill.Size.X.Scale fill.Size = UDim2.new(curX, -4, 1, -4) local fg = fill:FindFirstChildOfClass("UIGradient") if not fg then fg = Instance.new("UIGradient") fg.Parent = fill end fg.Rotation = 0 fg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 252, 235)), ColorSequenceKeypoint.new(0.15, Color3.fromRGB(92,237,255)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(80, 215, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(51,124,220)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40,120,220)) }) local glow = fill:FindFirstChild("FillGlow") if glow then glow.Visible = false glow.BackgroundTransparency = 1 end for _, child in ipairs(fill:GetChildren()) do if child:IsA("Frame") and child.Name:lower():find("shimmer") then  child.Visible = false end end end if stats then stats.Visible = true stats.Parent = track or pbFrame stats.Size = UDim2.new(0.55, -8, 1, 0) stats.Position = UDim2.new(0, 8, 0, 0) stats.BackgroundTransparency = 1 stats.TextSize = 12 stats.Font = Enum.Font.GothamBold stats.TextColor3 = Color3.fromRGB(255, 250, 225) stats.TextXAlignment = Enum.TextXAlignment.Left stats.TextYAlignment = Enum.TextYAlignment.Center stats.ZIndex = 510 end if pct then pct.Visible = true pct.Parent = track or pbFrame pct.Size = UDim2.new(0.45, -8, 1, 0) pct.Position = UDim2.new(0.55, 0, 0, 0) pct.BackgroundTransparency = 1 pct.TextSize = 13 pct.Font = Enum.Font.GothamBlack pct.TextColor3 = Color3.fromRGB(255, 255, 255) pct.TextXAlignment = Enum.TextXAlignment.Right pct.TextYAlignment = Enum.TextYAlignment.Center pct.ZIndex = 510 end else  local BAR_W, BAR_H = 260, 46 pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H) pbFrame.BackgroundTransparency = 0.04 pbFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 2) if pbStroke then pbStroke.Enabled = true pbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border pbStroke.Color = Color3.fromRGB(100, 220, 255) pbStroke.Transparency = 0.22 pbStroke.Thickness = 1.05 end if pbGrad then pbGrad.Enabled = true end if pbCorner then pbCorner.CornerRadius = UDim.new(0, 12) end if title then title.Visible = false title.Parent = pbFrame title.Size = UDim2.new(0, 1, 0, 1) title.Position = UDim2.new(0, 0, 0, 0) title.Text = "" title.TextSize = 1 title.Font = Enum.Font.GothamBlack title.TextColor3 = Color3.fromRGB(91,235,255) title.ZIndex = 505 end if status then status.Visible = true status.Parent = pbFrame status.Size = UDim2.new(0, 75, 0, 14) status.Position = UDim2.new(0, 112, 0, 5) status.TextSize = 11 status.ZIndex = 505 end if top then top.Visible = true top.Size = UDim2.new(1, -20, 0, 2) top.BackgroundColor3 = Color3.fromRGB(66,161,255) end if track then track.Size = UDim2.new(1, -20, 0, 12) track.Position = UDim2.new(0, 10, 1, -18) track.BackgroundColor3 = Color3.fromRGB(16, 9, 3) track.BackgroundTransparency = 0.08 track.ClipsDescendants = true if trackCorner then trackCorner.CornerRadius = UDim.new(1, 0) end if not trackStroke then trackStroke = Instance.new("UIStroke") trackStroke.Name = "TrackStroke" trackStroke.Parent = track end trackStroke.Enabled = true trackStroke.Thickness = 1.0 trackStroke.Transparency = 0.25 trackStroke.Color = Color3.fromRGB(100, 220, 255) end if fill and fillCorner then fillCorner.CornerRadius = UDim.new(1, 0) end if fill then fill.Position = UDim2.new(0, 0, 0, 0) local fg = fill:FindFirstChildOfClass("UIGradient") if not fg then fg = Instance.new("UIGradient") fg.Parent = fill end fg.Rotation = 0 fg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 252, 230)), ColorSequenceKeypoint.new(0.15, Color3.fromRGB(89,231,255)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(58,143,233)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50,121,220)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(34,120,220)) }) local glow = fill:FindFirstChild("FillGlow") if glow then glow.Visible = false glow.BackgroundTransparency = 1 end for _, child in ipairs(fill:GetChildren()) do if child:IsA("Frame") and child.Name:lower():find("shimmer") then child.Visible = true child.BackgroundTransparency = 0.50 end end end if stats then stats.Visible = true stats.Parent = pbFrame stats.Size = UDim2.new(0, 90, 0, 14) stats.Position = UDim2.new(1, -98, 0, 5) stats.TextSize = 10 stats.Font = Enum.Font.GothamMedium stats.TextColor3 = Color3.fromRGB(76,201,255) stats.TextXAlignment = Enum.TextXAlignment.Right stats.TextYAlignment = Enum.TextYAlignment.Center stats.ZIndex = 505 end if pct then pct.Visible = true pct.Parent = track or pbFrame pct.Size = UDim2.new(1, -8, 1, 0) pct.Position = UDim2.new(0, 4, 0, 0) pct.TextSize = 11 pct.Font = Enum.Font.GothamBlack pct.TextColor3 = Color3.fromRGB(255, 255, 255) pct.TextXAlignment = Enum.TextXAlignment.Center pct.TextYAlignment = Enum.TextYAlignment.Center pct.ZIndex = 506 end end if pbScale then pbScale.Scale = stealBarScale or 1 end end _G.__ZeyHubbApplyStealBarStyle = applyStealBarStyle task.defer(function() pcall(applyStealBarStyle, stealBarStyle) end) task.spawn(function()local up=true while pbFrame and pbFrame.Parent and pbStroke and pbStroke.Parent do local goal=up and 0.02 or 0.22 local tw=TS:Create(pbStroke,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=goal})tw:Play()tw.Completed:Wait()up=not up end end)task.spawn(function()local frames,fps,last=0,60,_tick()local fpsConn=RunService.RenderStepped:Connect(function()frames=frames+1 end)while pbFrame and pbFrame.Parent do local now=_tick()local elapsed=now-last if elapsed>0 then fps=_floor(frames/elapsed+0.5)end frames,last=0,now local ms=0 pcall(function()local p=LP:GetNetworkPing()if type(p)=="number"and p>=0 then ms=_floor(p*1000+0.5)end end)if infoLabel and infoLabel.Parent then infoLabel.Text=string.format("FPS %d  MS %d",fps,ms)end task.wait(0.5)end if fpsConn then fpsConn:Disconnect()end end)drag(pbFrame)pcall(function()if main then drag(main,72)end end)end do local BAV2_ANG="_GB_AngV"local BAV2_ATT="_GB_Att"local BAV2_CLEAN={"LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt","AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"}local V2={enabled=false,conn=nil,safetyConn=nil,target=nil,equipped=false,intendedVelocity=Vector3.zero,attachment=nil,angularVelocity=nil,speed=58,swingRange=12,}_G.__RivalHubBatV2=V2 local function cleanMovers(root)if not root then return end pcall(function()for _,n in ipairs(BAV2_CLEAN)do local c=root:FindFirstChild(n)if c then c:Destroy()end end for _,child in ipairs(root:GetChildren())do if child.Name~=BAV2_ANG and child.Name~=BAV2_ATT then local ln=child.Name:lower()if ln:find("lockb")or ln:find("lockangv")or ln:find("batlock")or ln:find("antiaim")or ln:find("velocitylock")then child:Destroy()end end end end)end local function ensureAngular(root)if not root then return end pcall(function()local a=root:FindFirstChild(BAV2_ANG);if a then a:Destroy()end local b=root:FindFirstChild(BAV2_ATT);if b then b:Destroy()end end)local att=Instance.new("Attachment")att.Name=BAV2_ATT att.Parent=root local angV=Instance.new("AngularVelocity")angV.Name=BAV2_ANG angV.Attachment0=att angV.RelativeTo=Enum.ActuatorRelativeTo.World angV.MaxTorque=math.huge angV.AngularVelocity=Vector3.zero angV.Parent=root V2.attachment=att V2.angularVelocity=angV end local function removeAngular()pcall(function()if V2.angularVelocity and V2.angularVelocity.Parent then V2.angularVelocity:Destroy()end end)pcall(function()if V2.attachment and V2.attachment.Parent then V2.attachment:Destroy()end end)V2.angularVelocity=nil V2.attachment=nil end local function pickTarget(root)local best,bestD=nil,math.huge for _,p in ipairs(Players:GetPlayers())do if p~=LP and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart")local hum=p.Character:FindFirstChildOfClass("Humanoid")if hrp and hum and hum.Health>0 then local d=(hrp.Position-root.Position).Magnitude if d<bestD then bestD=d;best=hrp end end end end return best,bestD end local function getBat(char)local eq=char and char:FindFirstChildOfClass("Tool")if eq then local n=eq.Name:lower()if n:find("bat")or n:find("slap")then return eq end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,t in ipairs(bp:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("bat")or n:find("slap")then return t end end end end return nil end local function stopBatV2()V2.enabled=false if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end V2.equipped=false V2.target=nil if V2.conn then V2.conn:Disconnect();V2.conn=nil end if V2.safetyConn then V2.safetyConn:Disconnect();V2.safetyConn=nil end local c=LP.Character local root=c and c:FindFirstChild("HumanoidRootPart")if root then pcall(function()root.Velocity=root.Velocity*0.3 end)end local hum=c and c:FindFirstChildOfClass("Humanoid")if hum then hum.AutoRotate=true end if V2.angularVelocity then pcall(function()V2.angularVelocity.AngularVelocity=Vector3.zero end)end removeAngular()if _unsuppressBodyLock then pcall(_unsuppressBodyLock,true)end end local function startBatV2()stopBatV2()V2.enabled=true if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end V2.equipped=false V2.target=nil V2.intendedVelocity=Vector3.zero V2.speed=tonumber(State and State.bypassBatSpeed)or 58 if _suppressBodyLock then pcall(_suppressBodyLock)end local c=LP.Character local root=c and c:FindFirstChild("HumanoidRootPart")if root then cleanMovers(root)ensureAngular(root)end V2.conn=RunService.Heartbeat:Connect(function()if not V2.enabled then return end local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")local hrp=char and char:FindFirstChild("HumanoidRootPart")if not hrp or not hum or hum.Health<=0 then return end cleanMovers(hrp)if not V2.angularVelocity or not V2.angularVelocity.Parent then ensureAngular(hrp)end if not V2.equipped then V2.equipped=true if not char:FindFirstChildOfClass("Tool")then local b=getBat(char)if b then pcall(function()hum:EquipTool(b)end)end end end local target,dist=pickTarget(hrp)if not target then V2.target=nil hum.AutoRotate=true if V2.angularVelocity then V2.angularVelocity.AngularVelocity=Vector3.zero end return end V2.target=target local aimPos=target.Position+target.CFrame.LookVector*(target.Velocity.Magnitude<0.1 and 1.5 or 5)local delta=aimPos-hrp.Position local flat=Vector3.new(delta.X,0,delta.Z)hum.AutoRotate=false if delta.Magnitude>0.01 and flat.Magnitude>0.01 then local curY=hrp.Orientation.Y local yawD=(math.deg(math.atan2(-flat.X,-flat.Z))-curY+180)%360-180 local curX=hrp.Orientation.X local pitchD=(math.deg(math.atan2(delta.Y,flat.Magnitude))-curX+180)%360-180 local rotY=math.clamp(math.rad(yawD)*40,-28,28)local rotX=math.clamp(math.rad(pitchD)*40,-28,28)local yawR=math.rad(hrp.Orientation.Y)local fwd=Vector3.new(math.cos(yawR),0,-math.sin(yawR))V2.angularVelocity.AngularVelocity=Vector3.new(0,rotY,0)+fwd*rotX else V2.angularVelocity.AngularVelocity=Vector3.zero end local spd=tonumber(V2.speed)or 58 V2.intendedVelocity=(flat.Magnitude>0.1 and flat.Unit*spd or Vector3.zero)+(math.abs(delta.Y)>0.8 and Vector3.new(0,math.sign(delta.Y)*spd,0)or Vector3.new(0,-2,0))hrp.AssemblyLinearVelocity=V2.intendedVelocity hrp.Velocity=V2.intendedVelocity if flat.Magnitude>0.3 then pcall(function()hum:Move(flat.Unit,false)end)else pcall(function()hum:Move(Vector3.zero,false)end)end if dist<=V2.swingRange then local bat=char:FindFirstChildOfClass("Tool")if bat and(bat.Name:lower():find("bat")or bat.Name:lower():find("slap"))then pcall(function()bat:Activate()local re=bat:FindFirstChildWhichIsA("RemoteEvent")if re then re:FireServer()end end)end end end)V2.safetyConn=RunService.RenderStepped:Connect(function()if not V2.enabled then return end local char=LP.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if not hrp or not hum then return end if V2.target and V2.target.Parent then local delta=V2.target.Position-hrp.Position local flat=Vector3.new(delta.X,0,delta.Z)if flat.Magnitude>0.3 then pcall(function()hum:Move(flat.Unit,false)end)end if math.abs(hrp.AssemblyLinearVelocity.X-V2.intendedVelocity.X)>30 or math.abs(hrp.AssemblyLinearVelocity.Z-V2.intendedVelocity.Z)>30 then hrp.AssemblyLinearVelocity=V2.intendedVelocity end end local v=hrp.Velocity if math.abs(v.X)>350 or math.abs(v.Z)>350 then hrp.Velocity=V2.intendedVelocity end cleanMovers(hrp)end)end local V3={enabled=false,conn=nil,cfg={FOLLOW_SPEED=55,ACTIVATE_DISTANCE=13,MIN_FOLLOW_DISTANCE=1,PREDICTION_TIME=0.22,PREDICT_AHEAD=3,MAX_VELOCITY_CHANGE=150,VELOCITY_SMOOTHING=0.2,MAX_HORIZONTAL_VELOCITY=80,SERVER_TICKRATE=1/60,MIN_PING_COMPENSATION=0.03,MAX_PING_COMPENSATION=0.25,ACCELERATION_PREDICTION_WEIGHT=0.3,DIRECTION_CHANGE_DETECTION_TIME=0.12,QUICK_DIRECTION_CHANGE_MULTIPLIER=1.5,GRAVITY=196.2,AIR_CONTROL_FACTOR=0.8,MIN_AIRBORNE_TIME=0.08,SWING_COOLDOWN=0.08,},st={targetPlayer=nil,lastTargetPos=nil,targetVelocity=Vector3.zero,smoothedVelocity=Vector3.zero,velocityHistory={},accelerationHistory={},aerialVelocityHistory={},verticalVelocityHistory={},previousDirection=nil,lastDirectionChangeTime=0,airborneTime=0,lastYVelocity=0,lastActivationTime=0,currentPing=0.1,realPingMs=0,previousAutoRotate=nil,previousHumanoid=nil,swingLocked=false,nextSwingAt=0,},}function V3.avg(list)if#list==0 then return Vector3.zero end local sum=Vector3.zero for _,v in ipairs(list)do sum=sum+v end return sum/#list end function V3.push(list,value,maxSize)table.insert(list,value)if#list>maxSize then table.remove(list,1)end end function V3.reset()local s=V3.st s.targetPlayer=nil;s.lastTargetPos=nil s.targetVelocity=Vector3.zero;s.smoothedVelocity=Vector3.zero s.velocityHistory={};s.accelerationHistory={}s.aerialVelocityHistory={};s.verticalVelocityHistory={}s.previousDirection=nil;s.airborneTime=0;s.lastYVelocity=0 end function V3.findBat()local char=LP.Character if not char then return nil end local equipped=char:FindFirstChildOfClass("Tool")if equipped then local n=equipped.Name:lower()if n:find("bat")or n:find("slap")then return equipped end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,tool in ipairs(bp:GetChildren())do if tool:IsA("Tool")then local n=tool.Name:lower()if n:find("bat")or n:find("slap")then return tool end end end end return nil end function V3.nearest(myRoot)local nearest,nearestDist=nil,math.huge for _,player in ipairs(Players:GetPlayers())do if player~=LP and player.Character then local tr=player.Character:FindFirstChild("HumanoidRootPart")local th=player.Character:FindFirstChildOfClass("Humanoid")if tr and th and th.Health>0 then local d=(tr.Position-myRoot.Position).Magnitude if d<nearestDist then nearestDist=d;nearest=player end end end end return nearest,nearestDist end function V3.face(myRoot,direction)if direction.Magnitude<0.01 then return end local cross=myRoot.CFrame.LookVector:Cross(direction.Unit)local angle=math.asin(math.clamp(cross.Magnitude,-1,1))myRoot.AssemblyAngularVelocity=cross.Magnitude>0.01 and cross.Unit*angle*80 or Vector3.zero end function V3.updatePing()local ok,ping=pcall(function()return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()end)if ok and type(ping)=="number"then V3.st.realPingMs=math.floor(ping)end V3.st.currentPing=math.clamp(V3.st.realPingMs/1000,V3.cfg.MIN_PING_COMPENSATION,V3.cfg.MAX_PING_COMPENSATION)end function V3.swing()local s,cfg=V3.st,V3.cfg local now=tick()if s.swingLocked or now<s.nextSwingAt then return end s.swingLocked=true s.nextSwingAt=now+cfg.SWING_COOLDOWN pcall(function()local char=LP.Character if not char then return end local bat=V3.findBat()if not bat then return end if bat.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:EquipTool(bat)end end bat:Activate()local remote=bat:FindFirstChildWhichIsA("RemoteEvent")if remote then remote:FireServer()end end)task.delay(cfg.SWING_COOLDOWN,function()s.swingLocked=false end)end function V3.loop(dt)local s,cfg=V3.st,V3.cfg local spd=tonumber(State and State.bypassBatSpeed)or tonumber(BYPASS_AIMBOT_SPEED)or 55 if spd~=spd or spd<=0 or spd==math.huge then spd=55 end cfg.FOLLOW_SPEED=spd if not V3.enabled then return end local char=LP.Character if not char then return end local myRoot=char:FindFirstChild("HumanoidRootPart")local myHum=char:FindFirstChildOfClass("Humanoid")if not myRoot or not myHum or myHum.Health<=0 then return end myHum.AutoRotate=false if not char:FindFirstChildOfClass("Tool")then local bat=V3.findBat()if bat and bat.Parent~=char then pcall(function()myHum:EquipTool(bat)end)end end local target=V3.nearest(myRoot)if not target or not target.Character then V3.reset();return end local targetRoot=target.Character:FindFirstChild("HumanoidRootPart")local targetHum=target.Character:FindFirstChildOfClass("Humanoid")if not targetRoot or not targetHum or targetHum.Health<=0 then V3.reset();return end if s.targetPlayer~=target then V3.reset()end s.targetPlayer=target V3.updatePing()local targetPos=targetRoot.Position local dtc=math.max(dt,1/240)if s.lastTargetPos then local instantVel=(targetPos-s.lastTargetPos)/dtc local accel=instantVel-s.targetVelocity if accel.Magnitude>cfg.MAX_VELOCITY_CHANGE then instantVel=s.targetVelocity+accel.Unit*cfg.MAX_VELOCITY_CHANGE end local hv=Vector3.new(instantVel.X,0,instantVel.Z)if hv.Magnitude>cfg.MAX_HORIZONTAL_VELOCITY then hv=hv.Unit*cfg.MAX_HORIZONTAL_VELOCITY instantVel=Vector3.new(hv.X,instantVel.Y,hv.Z)end V3.push(s.accelerationHistory,(instantVel-s.targetVelocity)/dtc,4)V3.push(s.velocityHistory,instantVel,8)V3.push(s.verticalVelocityHistory,instantVel.Y,5)s.targetVelocity=instantVel s.smoothedVelocity=s.smoothedVelocity:Lerp(instantVel,cfg.VELOCITY_SMOOTHING)end s.lastTargetPos=targetPos local isAirborne=targetHum.FloorMaterial==Enum.Material.Air s.airborneTime=isAirborne and(s.airborneTime+dtc)or 0 if isAirborne and s.airborneTime>=cfg.MIN_AIRBORNE_TIME then V3.push(s.aerialVelocityHistory,s.targetVelocity,6)elseif not isAirborne then s.aerialVelocityHistory={}end local smoothedVel=s.smoothedVelocity if isAirborne and#s.aerialVelocityHistory>0 then local avgAerial=V3.avg(s.aerialVelocityHistory)smoothedVel=Vector3.new(avgAerial.X,s.targetVelocity.Y,avgAerial.Z)*cfg.AIR_CONTROL_FACTOR end local isQuickTurn=false local htv=Vector3.new(s.targetVelocity.X,0,s.targetVelocity.Z)if htv.Magnitude>5 then local newDir=htv.Unit if s.previousDirection and s.previousDirection:Dot(newDir)<0.5 then isQuickTurn=(tick()-s.lastDirectionChangeTime)<cfg.DIRECTION_CHANGE_DETECTION_TIME s.lastDirectionChangeTime=tick()end s.previousDirection=newDir end local serverDelay=s.currentPing+cfg.SERVER_TICKRATE local adjustedDelay=isQuickTurn and(serverDelay*cfg.QUICK_DIRECTION_CHANGE_MULTIPLIER)or serverDelay local avgAccel=V3.avg(s.accelerationHistory)local accelContribution=avgAccel*cfg.ACCELERATION_PREDICTION_WEIGHT*(adjustedDelay*adjustedDelay*0.5)local predictedPos=targetPos+smoothedVel*adjustedDelay+accelContribution local predictionTime=cfg.PREDICTION_TIME*1.1 if isAirborne then predictedPos=predictedPos+smoothedVel*predictionTime+Vector3.new(0,-0.5*cfg.GRAVITY*predictionTime*predictionTime,0)else predictedPos=predictedPos+smoothedVel*predictionTime end local hs=Vector3.new(smoothedVel.X,0,smoothedVel.Z)if hs.Magnitude>1 then predictedPos=predictedPos+hs.Unit*cfg.PREDICT_AHEAD end local direction=predictedPos-myRoot.Position V3.face(myRoot,direction)if(targetPos-myRoot.Position).Magnitude<=cfg.ACTIVATE_DISTANCE then if tick()-s.lastActivationTime>=0.3 then V3.swing()s.lastActivationTime=tick()end end if direction.Magnitude>cfg.MIN_FOLLOW_DISTANCE then myRoot.AssemblyLinearVelocity=direction.Unit*cfg.FOLLOW_SPEED else local cv=myRoot.AssemblyLinearVelocity myRoot.AssemblyLinearVelocity=Vector3.new(0,cv.Y*0.5,0)end end function V3.start()if V3.enabled then return end V3.enabled=true if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end if _suppressBodyLock then pcall(_suppressBodyLock)end local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then V3.st.previousHumanoid=hum V3.st.previousAutoRotate=hum.AutoRotate hum.AutoRotate=false end V3.reset()V3.st.lastActivationTime=0 V3.conn=RunService.RenderStepped:Connect(function(dt)if _mySession~=_G.RivalHubSession then if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end return end pcall(V3.loop,dt)end)end function V3.stop()if not V3.enabled then return end V3.enabled=false if BatAura and BatAura.refresh then task.defer(BatAura.refresh)elseif _G.__ZeyHubbBatAuraRefresh then task.defer(_G.__ZeyHubbBatAuraRefresh)end if V3.conn then V3.conn:Disconnect();V3.conn=nil end local char=LP.Character if char then local myRoot=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if myRoot then myRoot.AssemblyLinearVelocity=Vector3.zero myRoot.AssemblyAngularVelocity=Vector3.zero end local prev=V3.st.previousHumanoid if prev and prev.Parent then prev.AutoRotate=V3.st.previousAutoRotate==nil and true or V3.st.previousAutoRotate elseif hum then hum.AutoRotate=true end end V3.st.previousHumanoid=nil V3.st.previousAutoRotate=nil V3.reset()if _unsuppressBodyLock then pcall(_unsuppressBodyLock,true)end end _G.__RivalHubBatVersion=(_G.__RivalHubBatVersion=="v3")and"v3"or"v2"  local BatAura={token=0,followConn=nil} local function _batAuraAnyOn() if _zeyHunterBat and _zeyHunterBat.enabled==true then return true end if autoBatEnabled==true then return true end if TPBatState and TPBatState.enabled==true then return true end if type(V2)=="table" and V2.enabled==true then return true end if type(V3)=="table" and V3.enabled==true then return true end return false end local function _batAuraGetRoot(char) if not char then return nil end return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end local function _batAuraStrip(char) if not char then return end local folder=char:FindFirstChild("ZeyHubbBatAura") if folder then pcall(function() folder:Destroy() end) end local root=_batAuraGetRoot(char) if root then local pl=root:FindFirstChild("ZeyHubbBatAuraLight") if pl then pcall(function() pl:Destroy() end) end end for _,d in ipairs(char:GetDescendants()) do if d.Name=="ZeyHubbBatAuraLight" or d.Name=="BatAuraCore" or d.Name=="BatAuraHalo" or d.Name=="ZeyHubbBatAura" then pcall(function() d:Destroy() end) end end end function BatAura.clear() BatAura.token=(BatAura.token or 0)+1 if BatAura.followConn then pcall(function() BatAura.followConn:Disconnect() end) BatAura.followConn=nil end _batAuraStrip(LP.Character) end function BatAura.apply() local char=LP.Character if not char then return end local hrp=_batAuraGetRoot(char) if not hrp then return end _batAuraStrip(char) local folder=Instance.new("Folder") folder.Name="ZeyHubbBatAura" folder.Parent=char  local light=Instance.new("PointLight") light.Name="ZeyHubbBatAuraLight" light.Color=Color3.fromRGB(70, 210, 255) light.Brightness=6 light.Range=16 light.Shadows=false light.Parent=hrp  local body=char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or hrp local core=Instance.new("Part") core.Name="BatAuraCore" core.Shape=Enum.PartType.Ball core.Size=Vector3.new(0.5,0.5,0.5) core.Material=Enum.Material.Neon core.Color=Color3.fromRGB(88,228,255) core.Transparency=0.1 core.CanCollide=false core.CanTouch=false core.CanQuery=false core.Massless=true core.CastShadow=false core.Anchored=false core.CFrame=body.CFrame core.Parent=folder local w=Instance.new("Weld") w.Name="BatAuraWeld" w.Part0=body w.Part1=core w.C0=CFrame.new(0, 0.15, 0) w.C1=CFrame.new() w.Parent=core local light2=Instance.new("PointLight") light2.Name="BatAuraCoreLight" light2.Color=Color3.fromRGB(64,157,252) light2.Brightness=3.5 light2.Range=9 light2.Shadows=false light2.Parent=core local halo=Instance.new("Part") halo.Name="BatAuraHalo" halo.Shape=Enum.PartType.Ball halo.Size=Vector3.new(1.2,1.2,1.2) halo.Material=Enum.Material.Neon halo.Color=Color3.fromRGB(52,127,220) halo.Transparency=0.8 halo.CanCollide=false halo.CanTouch=false halo.CanQuery=false halo.Massless=true halo.CastShadow=false halo.Anchored=false halo.CFrame=body.CFrame halo.Parent=folder local w2=Instance.new("Weld") w2.Name="BatAuraHaloWeld" w2.Part0=body w2.Part1=halo w2.C0=CFrame.new(0, 0.15, 0) w2.C1=CFrame.new() w2.Parent=halo
 local ground=Instance.new("Part") ground.Name="BatAuraGroundRing" ground.Shape=Enum.PartType.Cylinder ground.Size=Vector3.new(0.08,5.5,5.5) ground.Material=Enum.Material.Neon ground.Color=Color3.fromRGB(35,145,255) ground.Transparency=0.28 ground.CanCollide=false ground.CanTouch=false ground.CanQuery=false ground.Massless=true ground.CastShadow=false ground.Anchored=false ground.CFrame=hrp.CFrame*CFrame.new(0,-(hrp.Size.Y/2+2.55),0)*CFrame.Angles(0,0,math.rad(90)) ground.Parent=folder
 local gw=Instance.new("Weld") gw.Name="BatAuraGroundWeld" gw.Part0=hrp gw.Part1=ground gw.C0=CFrame.new(0,-(hrp.Size.Y/2+2.55),0)*CFrame.Angles(0,0,math.rad(90)) gw.C1=CFrame.new() gw.Parent=ground
 if BatAura.followConn then pcall(function() BatAura.followConn:Disconnect() end) end local myTok=BatAura.token BatAura.followConn=RunService.Heartbeat:Connect(function() if BatAura.token~=myTok or not _batAuraAnyOn() then pcall(function() if BatAura.followConn then BatAura.followConn:Disconnect() end end) BatAura.followConn=nil return end local c=LP.Character if not c or not core or not core.Parent then return end local b=c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or c:FindFirstChild("HumanoidRootPart") if b and core.Parent then  local root=_batAuraGetRoot(c) if root and light and light.Parent~=root then light.Parent=root end end end)  task.spawn(function() local t0=tick() while BatAura.token==myTok and _batAuraAnyOn() do if not light or not light.Parent then break end local pulse=0.55+0.45*math.abs(math.sin((tick()-t0)*3.4)) light.Brightness=4.5+pulse*2.8 light.Range=13+pulse*5 if light2 and light2.Parent then light2.Brightness=2.4+pulse*2 end if core and core.Parent then core.Transparency=0.06+pulse*0.12 end if halo and halo.Parent then halo.Transparency=0.74+pulse*0.12 local s=1.15+pulse*0.22 halo.Size=Vector3.new(s,s,s) end task.wait(0.03) end end) end function BatAura.refresh() if _batAuraAnyOn() then pcall(BatAura.apply) else pcall(BatAura.clear) end end _G.__ZeyHubbBatAuraRefresh=BatAura.refresh _G.__ZeyHubbBatAuraClear=BatAura.clear pcall(function() LP.CharacterAdded:Connect(function(char) task.delay(0.4,function() if _batAuraAnyOn() then pcall(BatAura.apply) end end) end) end) BatCtl={}function BatCtl.isOn()return V2.enabled==true or V3.enabled==true end function BatCtl.stop()if V3.enabled then V3.stop()end stopBatV2()end function BatCtl.start()if V3.enabled then V3.stop()end if V2.enabled then stopBatV2()end if _G.__RivalHubBatVersion=="v3"then V3.start()else startBatV2()end end function BatCtl.setVersion(ver)ver=(ver=="v3")and"v3"or"v2"local wasOn=BatCtl.isOn()if wasOn then BatCtl.stop()end _G.__RivalHubBatVersion=ver if _G.updateBatVersionUI then pcall(_G.updateBatVersionUI,ver)end if _G.__RivalHubRefreshBatLabel then pcall(_G.__RivalHubRefreshBatLabel)end if wasOn then BatCtl.start()end if saveAllSettings then pcall(saveAllSettings)end end _G.__RivalHubStartBatV2=BatCtl.start _G.__RivalHubStopBatV2=BatCtl.stop _G.__RivalHubIsBatV2=BatCtl.isOn _G.__RivalHubSetBatVersion=BatCtl.setVersion LP.CharacterAdded:Connect(function()task.wait(0.5)if V2.enabled then V2.equipped=false V2.target=nil local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if hrp then cleanMovers(hrp)ensureAngular(hrp)end end end)end function createMobilePanel()if savedButtonPositions.__layoutVersion~=2 then savedButtonPositions={} savedButtonPositions.__layoutVersion=2 end local panel=Instance.new("ScreenGui")panel.Name="RivalHubMobilePanel"panel.Enabled=false panel.ResetOnSpawn=false panel.ZIndexBehavior=Enum.ZIndexBehavior.Sibling panel.DisplayOrder=10000 panel.IgnoreGuiInset=true pcall(function()if syn and syn.protect_gui then syn.protect_gui(panel)end end)local okPanel=pcall(function()panel.Parent=game:GetService("CoreGui")end)if not okPanel then panel.Parent=LP:WaitForChild("PlayerGui")end local BTN_W,BTN_H=62,62 local buttons={}local buttonNames={"DropBR","AutoLeft","AutoBat","AutoRight","BatAimbot","TpDown","Carry","Lagger1","Lagger2","BatV2","BatTP","Float","InstantReset"}local buttonTexts={"DROP\nBR","AUTO\nLEFT","BYPASS\nBAT","AUTO\nRIGHT","BAT\nAIMBOT","TP\nDOWN","CARRY\nSPEED","LAGGER\nNORMAL","LAGGER\nCARRY","BAT\nV2","BAT\nTP","FLOAT","INSTANT\nRESET"}local function createButton(name,text,order,isToggle,callback)local btn=Instance.new("TextButton",panel)btn.Name=name btn.Size=UDim2.new(0,BTN_W,0,BTN_H)btn.BackgroundColor3=Color3.fromRGB(10,10,10)btn.BorderSizePixel=0 btn.Text=""btn.AutoButtonColor=false btn.Active=true btn.Selectable=true btn.ZIndex=100 local savedPos=savedButtonPositions[name]if name=="InstantReset"and savedPos then local cam=Workspace.CurrentCamera local view=cam and cam.ViewportSize or Vector2.new(390,800)if type(savedPos.X)~="number"or type(savedPos.Y)~="number"or savedPos.X<0 or savedPos.Y<0 or savedPos.X>view.X-BTN_W or savedPos.Y>view.Y-BTN_H then savedPos=nil end end if savedPos then btn.Position=UDim2.new(0,savedPos.X or 0,0,savedPos.Y or 0)else local defX,defY=getDefaultButtonPosition(name)btn.Position=UDim2.new(0,defX,0,defY)if name=="InstantReset"then savedButtonPositions[name]={X=defX,Y=defY}end end if name=="InstantReset"then btn.Visible=true btn:SetAttribute("ZeyHubbInstantResetButton",true)end btn.BackgroundColor3=Color3.fromRGB(245,245,250)Instance.new("UICorner",btn).CornerRadius=UDim.new(0,16)local bgGrad=Instance.new("UIGradient",btn)bgGrad.Name="BtnGrad"bgGrad.Rotation=90 bgGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(230,232,240)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(185,190,205)),})local stroke=Instance.new("UIStroke",btn)stroke.Color=Color3.fromRGB(255,255,255)stroke.Thickness=0 stroke.Transparency=1 stroke.Name="NormalStroke"local accentBar=Instance.new("Frame",btn)accentBar.Name="AccentBar"accentBar.Size=UDim2.new(0.55,0,0,3)accentBar.Position=UDim2.new(0.5,0,0,6)accentBar.AnchorPoint=Vector2.new(0.5,0)accentBar.BackgroundColor3=Color3.fromRGB(200,200,210)accentBar.BorderSizePixel=0 accentBar.Active=false accentBar.ZIndex=102 Instance.new("UICorner",accentBar).CornerRadius=UDim.new(1,0)local label=Instance.new("TextLabel",btn)label.Name="TextLabel"label.Size=UDim2.new(1,-8,1,-14)label.Position=UDim2.new(0,4,0,10)label.BackgroundTransparency=1 label.Text=text label.TextColor3=Color3.fromRGB(35,38,48)label.Font=Enum.Font.GothamBlack label.TextSize=10 label.TextWrapped=true label.Active=false label.Selectable=false label.ZIndex=101 local uiScale=Instance.new("UIScale",btn)uiScale.Scale=floatingButtonScale table.insert(_floatingUIScales,uiScale)local active=false local function setActive(state)active=state btn:SetAttribute("MobActive",state and true or false)paintFloatingBtn(btn,state)end setActive(false)local dragging=false local hasMoved=false local dragStart=nil local startPos=nil local movedDistance=0 local dragConn=nil local touchConn=nil local lockedTapInput=nil local lockedTapHandled=false local function runButtonCallback()if isToggle then if callback then pcall(callback,setActive)end else if callback then pcall(callback,setActive,active)end end end local function endDrag(input)if lockedTapInput then if input~=lockedTapInput or lockedTapHandled then return end lockedTapHandled=true local p=input.Position local ap,as=btn.AbsolutePosition,btn.AbsoluteSize local releasedInside=p.X>=ap.X and p.X<=ap.X+as.X and p.Y>=ap.Y and p.Y<=ap.Y+as.Y if releasedInside then runButtonCallback()end lockedTapInput=nil return end if not dragging then return end if movedDistance<8 and not hasMoved then runButtonCallback()elseif hasMoved then savedButtonPositions[name]={X=math.floor(btn.Position.X.Offset+0.5),Y=math.floor(btn.Position.Y.Offset+0.5)}task.defer(function()pcall(function()saveAllSettings(true)end)end)end dragging=false hasMoved=false dragStart=nil startPos=nil movedDistance=0 _isDraggingButton=false if dragConn then dragConn:Disconnect();dragConn=nil end if touchConn then touchConn:Disconnect();touchConn=nil end end btn.Activated:Connect(function()end)local function updateDragPosition(input)if not dragging or not dragStart or not startPos then return end local delta=input.Position-dragStart movedDistance=delta.Magnitude if uiLocked or mobileButtonsLocked then return end if movedDistance>=6 then hasMoved=true local cam=Workspace.CurrentCamera local viewport=cam and cam.ViewportSize or Vector2.new(390,800)local maxX=math.max(0,viewport.X-btn.AbsoluteSize.X)local maxY=math.max(0,viewport.Y-btn.AbsoluteSize.Y)local x=math.clamp(startPos.X.Offset+delta.X,0,maxX)local y=math.clamp(startPos.Y.Offset+delta.Y,0,maxY)btn.Position=UDim2.new(0,x,0,y)end end btn.InputBegan:Connect(function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if uiLocked or mobileButtonsLocked then lockedTapInput=input lockedTapHandled=false return end dragging=true hasMoved=false movedDistance=0 dragStart=input.Position startPos=btn.Position _isDraggingButton=true if dragConn then dragConn:Disconnect()end if touchConn then touchConn:Disconnect()end dragConn=UIS.InputChanged:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then updateDragPosition(inp)end end)if input.UserInputType==Enum.UserInputType.Touch then touchConn=UIS.TouchMoved:Connect(function(inp)updateDragPosition(inp)end)end end)btn.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then endDrag(input)end end)UIS.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then endDrag(input)end end)buttons[name]={btn=btn,setActive=setActive,label=label}return setActive end for i,name in ipairs(buttonNames)do local text=buttonTexts[i]local callback if name=="DropBR"then callback=function(setActive)if autoBatEnabled then return end setActive(true)executeDropWithToggle(function(v)if dropBrainrotSetVisual then dropBrainrotSetVisual(v)end end)task.delay(0.3,function()setActive(false)end)end elseif name=="AutoLeft"then callback=function(setActive)autoLeftEnabled=not autoLeftEnabled setActive(autoLeftEnabled)if autoLeftEnabled then startAutoLeft()else stopAutoLeft()end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled)end end elseif name=="AutoBat"then callback=function(setActive)if not autoBatEnabled then enableAutoBat()else disableAutoBat()end setActive(autoBatEnabled)end elseif name=="AutoRight"then callback=function(setActive)autoRightEnabled=not autoRightEnabled setActive(autoRightEnabled)if autoRightEnabled then startAutoRight()else stopAutoRight()end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled)end end elseif name=="TpDown"then callback=function(setActive)doTpDown()setActive(true)task.delay(0.2,function()setActive(false)end)end elseif name=="Carry"then callback=function(setActive)if not speedMode then speedMode=true;laggerToggled=false;laggerCarryToggled=false;setActive(true)if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false)end if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false)end else speedMode=false;setActive(false)end refreshSpeedModeLabel()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end elseif name=="Lagger1"then callback=function(setActive)if speedMode then speedMode=false;if mobSetCarry then mobSetCarry(false)end end if not laggerToggled then laggerToggled=true;laggerCarryToggled=false;setActive(true)if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false)end else laggerToggled=false;setActive(false)end refreshSpeedModeLabel()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end elseif name=="Lagger2"then callback=function(setActive)if speedMode then speedMode=false;if mobSetCarry then mobSetCarry(false)end end if not laggerCarryToggled then laggerCarryToggled=true;laggerToggled=false;setActive(true)if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false)end else laggerCarryToggled=false;laggerToggled=false;setActive(false)end refreshSpeedModeLabel()if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow)end end elseif name=="BatV2"then callback=function(setActive)if not _G.__RivalHubIsBatV2()then _G.__RivalHubStartBatV2()setActive(true)else _G.__RivalHubStopBatV2()setActive(false)end if _G.__RivalHubBatSetVisual then pcall(_G.__RivalHubBatSetVisual,_G.__RivalHubIsBatV2()==true)end end elseif name=="BatTP"then callback=function(setActive)local on=not(TPBatState and TPBatState.enabled)if tpBatSetEnabled then pcall(tpBatSetEnabled,on)end setActive(TPBatState and TPBatState.enabled or false)end elseif name=="InstantReset"then callback=function(setActive)local run=_G.__ZeyHubbRunInstantReset if type(run)=="function"then setActive(true)pcall(run)task.delay(0.35,function()setActive(false)end)else setActive(false)warn("[ZeyHubb] Instant Reset engine is not ready.")end end end -- ZeyHubb.vs Bat Aimbot engine adapted from Hunter Hub's normal Bat Aimbot logic.
-- Isolated state: does not call or enable the Bypass Bat engine.
do
    local _zeyHunterBat = { enabled = false, connection = nil, characterConnection = nil, target = nil, lastScan = 0, swingBusy = false, savedAutoRotate = nil, proxyPart = nil, proxyWeld = nil, characterGlow = nil }
    local function _zeyHunterSetCharacterGlow(character, enabled)
        if _zeyHunterBat.characterGlow then
            pcall(function() _zeyHunterBat.characterGlow:Destroy() end)
            _zeyHunterBat.characterGlow = nil
        end
        if not enabled or not character or not character.Parent then return end
        local glow = Instance.new("Highlight")
        glow.Name = "ZeyHubbBatAimbotGlow"
        glow.Adornee = character
        glow.Enabled = true
        glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        glow.FillColor = Color3.fromRGB(0, 105, 255)
        glow.FillTransparency = 0.72
        glow.OutlineColor = Color3.fromRGB(65, 190, 255)
        glow.OutlineTransparency = 0
        glow.Parent = character
        _zeyHunterBat.characterGlow = glow
    end
    local function _zeyHunterFindBat()
        local character = LP.Character
        if character then
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Tool") and (item.Name:lower():find("bat") or item.Name:lower():find("slap")) then return item end
            end
        end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") and (item.Name:lower():find("bat") or item.Name:lower():find("slap")) then return item end
            end
        end
        return nil
    end
    local function _zeyHunterCleanupProxy()
        if _zeyHunterBat.proxyWeld then pcall(function() _zeyHunterBat.proxyWeld:Destroy() end) end
        if _zeyHunterBat.proxyPart then pcall(function() _zeyHunterBat.proxyPart:Destroy() end) end
        _zeyHunterBat.proxyWeld, _zeyHunterBat.proxyPart = nil, nil
    end
    local function _zeyHunterCreateProxy()
        _zeyHunterCleanupProxy()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local proxy = Instance.new("Part")
        proxy.Name = "AMIRIBatAimbotProxy"
        proxy.Size = Vector3.new(1, 1, 1)
        proxy.Transparency = 1
        proxy.CanCollide = false
        proxy.Massless = true
        proxy.Parent = character
        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = proxy
        weld.C0 = CFrame.new()
        weld.Parent = proxy
        _zeyHunterBat.proxyPart, _zeyHunterBat.proxyWeld = proxy, weld
    end
    local function _zeyHunterClosestTarget(root)
        local now = tick()
        if now - _zeyHunterBat.lastScan < 0.10 and _zeyHunterBat.target and _zeyHunterBat.target.Parent then
            local h = _zeyHunterBat.target.Parent:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then return _zeyHunterBat.target end
        end
        _zeyHunterBat.lastScan = now
        local closest, best = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                local character = player.Character
                local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
                local targetHum = character and character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHum and targetHum.Health > 0 then
                    local distance = (targetRoot.Position - root.Position).Magnitude
                    if distance < best then best, closest = distance, targetRoot end
                end
            end
        end
        _zeyHunterBat.target = closest
        return closest
    end
    local function _zeyHunterSwing()
        if _zeyHunterBat.swingBusy then return end
        _zeyHunterBat.swingBusy = true
        task.spawn(function()
            local character = LP.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local bat = character:FindFirstChildOfClass("Tool")
                if not bat or not (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
                    bat = _zeyHunterFindBat()
                end
                if bat then
                    if bat.Parent ~= character and humanoid then
                        pcall(function() humanoid:EquipTool(bat) end)
                        task.wait(0.05)
                    end
                    local remote
                    for _, descendant in ipairs(bat:GetDescendants()) do
                        if descendant:IsA("RemoteEvent") then
                            remote = descendant
                            break
                        end
                    end
                    if remote then
                        pcall(function() remote:FireServer() end)
                        task.wait(0.12)
                        pcall(function() remote:FireServer() end)
                    else
                        pcall(function() bat:Activate() end)
                        task.wait(0.12)
                        pcall(function() bat:Activate() end)
                    end
                end
            end
            task.delay(0.08, function()
                _zeyHunterBat.swingBusy = false
            end)
        end)
    end
    local function _zeyHunterStop()
        _zeyHunterBat.enabled = false
        if BatAura and BatAura.refresh then task.defer(BatAura.refresh) end
        _G.__RivalHubBatAimbotIsEnabled = false
        if _zeyHunterBat.connection then _zeyHunterBat.connection:Disconnect(); _zeyHunterBat.connection = nil end
        if _zeyHunterBat.characterConnection then _zeyHunterBat.characterConnection:Disconnect(); _zeyHunterBat.characterConnection = nil end
        local character = LP.Character
        _zeyHunterSetCharacterGlow(character, false)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid then humanoid.AutoRotate = (_zeyHunterBat.savedAutoRotate == nil) and true or _zeyHunterBat.savedAutoRotate; humanoid.PlatformStand = false end
        if root then root.AssemblyAngularVelocity = Vector3.zero end
        _zeyHunterBat.savedAutoRotate = nil
        _zeyHunterBat.target = nil
        _zeyHunterBat.swingBusy = false
        _zeyHunterCleanupProxy()
        if _G.__RivalHubBatAimbotSetVisual then pcall(_G.__RivalHubBatAimbotSetVisual, false) end
        return false
    end
    local function _zeyHunterStart()
        if _zeyHunterBat.enabled then return true end
        -- Avoid running the separate Bypass Bat and movement modes simultaneously.
        if type(disableAutoBat) == "function" and autoBatEnabled then pcall(disableAutoBat) end
        if type(stopAimbotAdapt) == "function" then pcall(stopAimbotAdapt) end
        if type(_suppressBodyLock) == "function" then pcall(_suppressBodyLock) end
        _zeyHunterBat.enabled = true
        if BatAura and BatAura.refresh then task.defer(BatAura.refresh) end
        _G.__RivalHubBatAimbotIsEnabled = true
        local initialCharacter = LP.Character
        local initialHumanoid = initialCharacter and initialCharacter:FindFirstChildOfClass("Humanoid")
        if initialHumanoid then _zeyHunterBat.savedAutoRotate = initialHumanoid.AutoRotate; initialHumanoid.AutoRotate = false end
        _zeyHunterSetCharacterGlow(initialCharacter, true)
        _zeyHunterBat.characterConnection = LP.CharacterAdded:Connect(function(character)
            task.wait(0.15)
            if not _zeyHunterBat.enabled then return end
            _zeyHunterSetCharacterGlow(character, true)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then _zeyHunterBat.savedAutoRotate = humanoid.AutoRotate; humanoid.AutoRotate = false end
            _zeyHunterBat.target = nil
        end)
        _zeyHunterBat.connection = RunService.RenderStepped:Connect(function()
            if not _zeyHunterBat.enabled then return end
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not root or not humanoid or humanoid.Health <= 0 then return end
            if not _zeyHunterBat.proxyPart or _zeyHunterBat.proxyPart.Parent ~= character then
                _zeyHunterCreateProxy()
            end
            local bat = _zeyHunterFindBat()
            if bat and bat.Parent ~= character then pcall(function() humanoid:EquipTool(bat) end) end
            local target = _zeyHunterClosestTarget(root)
            if not target then humanoid.AutoRotate = true; root.AssemblyAngularVelocity = Vector3.zero; return end
            humanoid.AutoRotate = false
            local targetVelocity = target.AssemblyLinearVelocity
            local leadTime = math.clamp(targetVelocity.Magnitude / 130, 0.05, 0.15)
            local aimPosition = target.Position + targetVelocity * leadTime + Vector3.new(0, 1, 0)
            local look = aimPosition - root.Position
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
                local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
                local yawRate = math.clamp(math.rad(yawDelta) * 285, -40, 40)
                local pitchRate = math.clamp(math.rad(pitchDelta) * 285, -40, 40)
                local yawRad = math.rad(root.Orientation.Y)
                local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
                root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + rightAxis * pitchRate
            else root.AssemblyAngularVelocity = Vector3.zero end
            local direction = look.Magnitude > 0.01 and look.Unit or Vector3.zero
            local standPosition = aimPosition - direction + Vector3.new(0, 1.6, 0)
            local move = standPosition - root.Position
            local horizontal = Vector3.new(move.X, 0, move.Z)
            local speed = math.clamp(tonumber(BAT_AIMBOT_SPEED) or 58, 1, 200)
            local horizontalVelocity = horizontal.Magnitude > 0.1 and horizontal.Unit * speed or Vector3.zero
            local verticalVelocity = math.abs(move.Y) > 0.1 and Vector3.new(0, math.sign(move.Y) * 52, 0) or Vector3.new(0, -2, 0)
            root.AssemblyLinearVelocity = horizontalVelocity + verticalVelocity
            if horizontal.Magnitude > 0.5 then humanoid:Move(horizontal.Unit, false) end
            if (target.Position - root.Position).Magnitude < 6 then _zeyHunterSwing() end
        end)
        if _G.__RivalHubBatAimbotSetVisual then pcall(_G.__RivalHubBatAimbotSetVisual, true) end
        return true
    end
    _G.__RivalHubBatAimbotToggle = function()
        if _zeyHunterBat.enabled then return _zeyHunterStop() end
        return _zeyHunterStart()
    end
    _G.__RivalHubBatAimbotStop = _zeyHunterStop
    _G.__ZeyHubbBatAimbotToggle = _G.__RivalHubBatAimbotToggle
end

if name=="BatAimbot"then callback=function(setActive) local toggle=_G.__RivalHubBatAimbotToggle if type(toggle)=="function" then local ok,res=pcall(toggle) if ok then setActive(res==true) else setActive(false) warn("[ZeyHubb.vs] Bat Aimbot module failed: "..tostring(res)) end else setActive(false) warn("[ZeyHubb.vs] Bat Aimbot engine is not integrated; button/keybind UI is ready.") end end end if name=="Float"then callback=function(setActive)if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle()end setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning()or false)end end local setActive=createButton(name,text,i-1,true,callback)if name=="Float"then mobSetFloat=setActive end if name=="AutoBat"then mobSetAutoBat=setActive end if name=="AutoLeft"then mobSetAutoLeft=setActive end if name=="AutoRight"then mobSetAutoRight=setActive end if name=="DropBR"then mobSetDropBR=setActive end if name=="BatAimbot"then mobSetBatAimbot=setActive end if name=="TpDown"then mobSetTpDown=setActive end if name=="Carry"then mobSetCarry=setActive end if name=="Lagger1"then mobSetLagger1=setActive end if name=="Lagger2"then mobSetLagger2=setActive end if name=="BatV2"then mobSetBatV2=setActive end if name=="BatTP"then mobSetBatTP=setActive end end _G.__RivalHubRefreshBatLabel=function()local b=buttons.BatV2 if b and b.label then b.label.Text=(_G.__RivalHubBatVersion=="v3")and"BAT\nV3"or"BAT\nV2"end end pcall(_G.__RivalHubRefreshBatLabel)if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled)end if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled)end if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled)end if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode)end if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled)end if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled)end if buttons.BatV2 and buttons.BatV2.setActive then buttons.BatV2.setActive(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false)end if buttons.BatTP and buttons.BatTP.setActive then buttons.BatTP.setActive(TPBatState and TPBatState.enabled or false)end if buttons.Float and buttons.Float.setActive then buttons.Float.setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning()or false)end if buttons.InstantReset and buttons.InstantReset.setActive then buttons.InstantReset.btn.Visible=true buttons.InstantReset.setActive(false)else warn("[ZeyHubb] Instant Reset floating button was not created.")end pcall(function()local bv=buttons.BatV2 and buttons.BatV2.btn local bt=buttons.BatTP and buttons.BatTP.btn if bv and bt then local gap=8 local placeRight=bv.Position.X.Offset+BTN_W+gap local placeY=bv.Position.Y.Offset local saved=savedButtonPositions["BatTP"]local near=false if saved and type(saved.X)=="number"and type(saved.Y)=="number"then local dx=math.abs((saved.X or 0)-bv.Position.X.Offset)local dy=math.abs((saved.Y or 0)-bv.Position.Y.Offset)if dx<200 and dy<100 then near=true end end if not near then bt.Position=UDim2.new(0,placeRight,0,placeY)savedButtonPositions["BatTP"]={X=placeRight,Y=placeY}end end end)pcall(function()local cam=Workspace.CurrentCamera local viewport=cam and cam.ViewportSize or Vector2.new(390,800)local gap,margin=8,12 local names={"DropBR","AutoRight","AutoBat","AutoLeft","BatAimbot","TpDown","Carry","Lagger1","Lagger2","InstantReset","Float","BatTP","BatV2"}local function put(name,x,y)local item=buttons[name]local btn=item and item.btn if not btn then return end local saved=savedButtonPositions[name]if type(saved)=="table"and type(saved.X)=="number"and type(saved.Y)=="number"then local sx=math.clamp(saved.X,0,math.max(0,viewport.X-BTN_W))local sy=math.clamp(saved.Y,0,math.max(0,viewport.Y-BTN_H))btn.Position=UDim2.new(0,sx,0,sy)savedButtonPositions[name]={X=sx,Y=sy}return end x=math.clamp(x,0,math.max(0,viewport.X-BTN_W))y=math.clamp(y,0,math.max(0,viewport.Y-BTN_H))btn.Position=UDim2.new(0,x,0,y)savedButtonPositions[name]={X=x,Y=y}end if viewport.X>=900 then local totalW=6*BTN_W+5*gap local startX=math.max(margin,viewport.X-totalW-margin)local topY=math.max(margin,24)local actionX=startX+4*(BTN_W+gap)put("InstantReset",startX,topY+BTN_H+gap)put("Float",startX+(BTN_W+gap),topY+BTN_H+gap)put("BatTP",startX+2*(BTN_W+gap),topY+BTN_H+gap)put("BatV2",startX+3*(BTN_W+gap),topY+BTN_H+gap)local grid={{"DropBR","AutoRight"},{"AutoBat","AutoLeft"},{"BatAimbot","Carry"},{"TpDown","Lagger1"},{"Lagger2","InstantReset"},}for r,pair in ipairs(grid)do put(pair[1],actionX,topY+(r-1)*(BTN_H+gap))put(pair[2],actionX+BTN_W+gap,topY+(r-1)*(BTN_H+gap))end else local startX=math.max(margin,viewport.X-(2*BTN_W+gap)-margin)local startY=math.max(margin,24)for i,name in ipairs(names)do local index=i-1 local col=index%2 local row=math.floor(index/2)put(name,startX+col*(BTN_W+gap),startY+row*(BTN_H+gap))end end end)task.defer(applyMobileButtonVisibility)return panel end batCounterV2Enabled=false batCounterV2Debounce=false batCounterV2Conn=nil batCounterV2HitCooldown=false BAT_COUNTER_V2_SWING_CD=0.08 setBatCounterV2Visual=nil local _batCounterV2OriginalTpState=false local _batCounterV2SuppressCount=0 local _lastBatCounterV2Time=0 local _batCounterV2Cooldown=0.01 local function isPlayerRagdolled(player)if not player or not player.Character then return false end local hum=player.Character:FindFirstChildOfClass("Humanoid")if not hum then return false end local state=hum:GetState()return state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown end local function hasAnimalEquipped(player)if not player or not player.Character then return false end for _,child in ipairs(player.Character:GetChildren())do if child:IsA("Tool")then if child:FindFirstChild("Handle")or child.Name:find("Animal")or child.Name:find("Pet")then return true end end end return false end local function getAttackingPlayerWithAnimal()local myChar=LP.Character if not myChar then return nil end local myRoot=myChar:FindFirstChild("HumanoidRootPart")if not myRoot then return nil end local closest,minDist=nil,_huge for _,plr in ipairs(Players:GetPlayers())do if plr~=LP and plr.Character then if not hasAnimalEquipped(plr)then continue end local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")local hum=plr.Character:FindFirstChildOfClass("Humanoid")if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-myRoot.Position).Magnitude if dist<12 and dist<minDist then minDist=dist;closest=plr end end end end return closest end local function getBatV2Counter()local char=LP.Character if not char then return nil end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")then local name=child.Name:lower()if name:find("bat")or name:find("slap")or name:find("sword")or name:find("knife")then return child end end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,child in ipairs(bp:GetChildren())do if child:IsA("Tool")then local name=child.Name:lower()if name:find("bat")or name:find("slap")or name:find("sword")or name:find("knife")then child.Parent=char return child end end end end if bp then for _,child in ipairs(bp:GetChildren())do if child:IsA("Tool")then child.Parent=char;return child end end end return nil end local function tryHitBatCounterV2()if batCounterV2HitCooldown then return end batCounterV2HitCooldown=true pcall(function()local bat=getBatV2Counter()if bat then bat:Activate()local ev=bat:FindFirstChildWhichIsA("RemoteEvent")if ev then ev:FireServer()end end end)task.delay(BAT_COUNTER_V2_SWING_CD,function()batCounterV2HitCooldown=false end)end local function executeBatCounterV2()local now=_tick()if now-(_lastBatCounterV2Time or 0)<(_batCounterV2Cooldown or 0.01)then return end if batCounterV2Debounce then return end batCounterV2Debounce=true _lastBatCounterV2Time=now local attacker=getAttackingPlayerWithAnimal()if not attacker then batCounterV2Debounce=false;return end if isPlayerRagdolled(attacker)then batCounterV2Debounce=false;return end if not hasAnimalEquipped(attacker)then batCounterV2Debounce=false;return end local function doCounterHit()local char=LP.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart")if not hrp then return end local attChar=attacker.Character if not attChar then return end local attRoot=attChar:FindFirstChild("HumanoidRootPart")if not attRoot then return end if not hasAnimalEquipped(attacker)then batCounterV2Debounce=false;return end if sethiddenproperty then sethiddenproperty(hrp,"PhysicsRepRootPart",attRoot)end local targetPos=attRoot.Position+_V3new(0,0.9,0)if(hrp.Position-targetPos).Magnitude>8 then hrp.CFrame=_CFnew(targetPos)end tryHitBatCounterV2()task.delay(0.05,function()tryHitBatCounterV2()end)task.delay(0.1,function()tryHitBatCounterV2()end)end doCounterHit()task.delay(0.2,function()batCounterV2Debounce=false end)end function stopBatCounterV2()if batCounterV2Conn then batCounterV2Conn:Disconnect()batCounterV2Conn=nil end batCounterV2Debounce=false batCounterV2HitCooldown=false end function startBatCounterV2()if batCounterV2Conn then return end batCounterV2Conn=RunService.Heartbeat:Connect(function()if not batCounterV2Enabled then return end if batCounterV2Debounce then return end local character=LP.Character if not character then return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid or humanoid.Health<=0 then return end local state=humanoid:GetState()local isBeingAttacked=state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.GettingUp or state==Enum.HumanoidStateType.Stunned if isBeingAttacked then local attacker=getAttackingPlayerWithAnimal()if attacker then if not isPlayerRagdolled(attacker)then if hasAnimalEquipped(attacker)then executeBatCounterV2()end end end end end)end function toggleBatCounterV2()batCounterV2Enabled=not batCounterV2Enabled if batCounterV2Enabled then startBatCounterV2()else stopBatCounterV2()end return batCounterV2Enabled end function updateUIFromLoaded()task.wait() pcall(function() if _G.__ZeyHubbFOVRefreshUI then _G.__ZeyHubbFOVRefreshUI() end if _G.__ZeyHubbCustomFOV and _G.__ZeyHubbCustomFOV.enabled and _G.__ZeyHubbFOVStart then _G.__ZeyHubbFOVStart() end end)pcall(applyMobileButtonVisibility)if normalBox then normalBox.Text=tostring(NS)end if carryBox then carryBox.Text=tostring(CS)end if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED)end if lagger2Box then lagger2Box.Text=tostring(LAGGER_CARRY_SPEED)end if batSpeedBox then batSpeedBox.Text=tostring(BYPASS_AIMBOT_SPEED)end if uiScaleBox then uiScaleBox.Text=tostring(uiScaleValue)end if stealBarScaleBox then stealBarScaleBox.Text=tostring(_floor((stealBarScale or 1)*100+0.5))end if pbScale then pbScale.Scale=stealBarScale or 1 end if dropModeBtnRef then dropModeBtnRef.Text=dropMode==1 and"Fling"or"Jump Drop"end if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end if infJumpModeBtn then infJumpModeBtn.Text=string.upper(InfiniteJump.mode=="manual"and"manual"or"hold")end if autoStealModeBtn then autoStealModeBtn.Text=tostring(autoStealMode or"73").."%" end refreshSpeedModeLabel()local savedInfJumpEnabled=InfiniteJump.enabled==true InfiniteJump.stop()if savedInfJumpEnabled then InfiniteJump.start()if infJumpSetVisual then infJumpSetVisual(true)end elseif infJumpSetVisual then infJumpSetVisual(false)end for _,ref in ipairs(keyButtonRefs)do local entry=ref.entry local label=(entry.gp and entry.gp.Name)or(entry.kb and entry.kb.Name)or"None"ref.btn.Text=label end if savedProgressBarPos and pbFrame then pbFrame.Position=UDim2.new(savedProgressBarPos.XScale or 0.5,savedProgressBarPos.XOffset or-160,savedProgressBarPos.YScale or 0.80,savedProgressBarPos.YOffset or 0)end applyBackgroundMode(backgroundMode)applyFloatingButtonScale()if setSmallButtonsVisual then setSmallButtonsVisual()end if uiLocked and setLockUIVisual then setLockUIVisual(true)end if _G.updateBatVersionUI then pcall(_G.updateBatVersionUI,_G.__RivalHubBatVersion or"v2")end if _G.__RivalHubRefreshBatLabel then pcall(_G.__RivalHubRefreshBatLabel)end if antiRagdollMode=="v1"or antiRagdollMode=="v2"then if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode)end setAntiRagdollMode(antiRagdollMode)else if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI("off")end end if antiDieEnabled then if setAntiDieVisual then setAntiDieVisual(true)end AntiDieModule.start()else if setAntiDieVisual then setAntiDieVisual(false)end end if antiBatEnabled then if setAntiBatVisual then setAntiBatVisual(true)end startAntiBat()else if setAntiBatVisual then setAntiBatVisual(false)end end if antiFlingEnabled then if setAntiFlingVisual then setAntiFlingVisual(true)end startAntiFling()else if setAntiFlingVisual then setAntiFlingVisual(false)end stopAntiFling()end if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true);pcall(startAutoSteal)end if medusaCounterEnabled then if setMedusaVisual then setMedusaVisual(true)end if LP.Character then setupMedusaCounter(LP.Character)end else if setMedusaVisual then setMedusaVisual(false)end stopMedusaCounter()end if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true)startBatCounter()end if batCounterV2Enabled and setBatCounterV2Visual then setBatCounterV2Visual(true)startBatCounterV2()end if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true)task.spawn(function()task.wait(0.5);startUnwalk()end)end if antiLagEnabled then if setAntiLagVisual then setAntiLagVisual(true)end enableAntiLag()else if setAntiLagVisual then setAntiLagVisual(false)end disableAntiLag()end if espEnabled then toggleESP(true)if setESPVIsual then setESPVIsual(true)end else toggleESP(false)if setESPVIsual then setESPVIsual(false)end end if espLineEnabled then if setESPLineVisual then setESPLineVisual(true)end startESPLine()else if setESPLineVisual then setESPLineVisual(false)end stopESPLine()end if vividGraphicsEnabled then enableVividGraphics()if setVividVisual then setVividVisual(true)end else disableVividGraphics()if setVividVisual then setVividVisual(false)end end if stretchEnabled then enableStretch()if _G.stretchToggleSetter then _G.stretchToggleSetter(true)end else if _G.stretchToggleSetter then _G.stretchToggleSetter(false)end end if mobSetAutoBat then mobSetAutoBat(autoBatEnabled)end if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled)end if mobSetAutoRight then mobSetAutoRight(autoRightEnabled)end if mobSetCarry then mobSetCarry(speedMode)end if mobSetLagger1 then mobSetLagger1(laggerToggled)end if mobSetLagger2 then mobSetLagger2(laggerCarryToggled)end if mobSetBatV2 then mobSetBatV2(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()or false)end if bodyLockEnabled and bodyLockSetVisual then if _blSuppressCount==0 then bodyLockSetVisual(true)startBodyLock()else bodyLockSetVisual(false)end end updateProgressBarVisibility()startEnemySpeed()toggleLockUI(uiLocked)mobileButtonsLocked=uiLocked==true pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel and OUTFITS[currentOutfitIndex]then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end if _G.__ZeyHubbApplySpinSettings then task.defer(function()task.wait(0.15);pcall(_G.__ZeyHubbApplySpinSettings)end)end end local _bootErrors={}local function _bootSection(name,fn)print("[Rival Hub Boot] Iniciando:",name)local ok,err=pcall(fn)if not ok then print("[Rival Hub Boot] FALLÓ:",name,tostring(err))table.insert(_bootErrors,{name=name,err=tostring(err)})warn("[Rival Hub Boot] Error en '"..name.."': "..tostring(err))else print("[Rival Hub Boot] OK:",name)end return ok end _bootSection("buildGui",function()buildGui()end)if gui and main then pcall(function()gui.Enabled=false main.Visible=false if miniBtn then miniBtn.Visible=false end if pbFrame then pbFrame.Visible=false end end)_bootSection("loadAllSettings",function()if loadAllSettings()then updateUIFromLoaded()if _G.__ZeyHubbHeadlessApply then pcall(_G.__ZeyHubbHeadlessApply,_G.__ZeyHubbHeadlessEnabled==true)end if _G.__ZeyHubbHeadlessSetVisual then pcall(_G.__ZeyHubbHeadlessSetVisual,_G.__ZeyHubbHeadlessEnabled==true)end if _G.__ZeyHubbKorbloxApply then pcall(_G.__ZeyHubbKorbloxApply,_G.__ZeyHubbKorbloxEnabled==true)end if _G.__ZeyHubbKorbloxSetVisual then pcall(_G.__ZeyHubbKorbloxSetVisual,_G.__ZeyHubbKorbloxEnabled==true)end if _G.__ZeyHubbDuelPingApply then pcall(_G.__ZeyHubbDuelPingApply,_G.__ZeyHubbDuelPingEnabled==true)end if _G.__ZeyHubbDuelPingSetVisual then pcall(_G.__ZeyHubbDuelPingSetVisual,_G.__ZeyHubbDuelPingEnabled==true)end if _G.__ZeyHubbInstantResetRefreshSelector then pcall(_G.__ZeyHubbInstantResetRefreshSelector)end end end)_bootSection("createMobilePanel",function()MobilePanel=createMobilePanel()if MobilePanel then MobilePanel.Enabled=false end end)if hideButtonsEnabled then _bootSection("applyHideButtons",function()applyHideButtons(true)if setHideButtonsVisual then setHideButtonsVisual(true)end end)end _bootSection("localizeRivalHubInterface",function()if gui then localizeRivalHubInterface(gui)end if MobilePanel then localizeRivalHubInterface(MobilePanel)end end)pcall(function()if gui then gui.Enabled=true end if main then main.Visible=true local s=main:FindFirstChildOfClass("UIScale")if s then s.Scale=(uiScaleValue or 78)/100 end end if pbFrame then pbFrame.Visible=true end if MobilePanel then MobilePanel.Enabled=true end end)if LP.Character then task.spawn(function()task.wait(0.1)if waitForCharReady(LP.Character,5)then pcall(function()captureOriginalAppearance(LP.Character)end)pcall(function()setupMovementAndIndicators(LP.Character)end)if currentAnimPack~="Off"then pcall(function()startAnimPack(currentAnimPack)end)end pcall(function()applyOutfitByIndex(currentOutfitIndex)end)end end)end if#_bootErrors>0 then task.defer(function()pcall(function()local env=(getgenv and getgenv())or _G local writeFn=env.writefile or(syn and syn.writefile)if type(writeFn)=="function"then local log="[Rival Hub Boot Errors] "..os.date("%Y-%m-%d %H:%M:%S").."\n"for _,e in ipairs(_bootErrors)do log=log..e.name..": "..e.err.."\n"end pcall(writeFn,"RivalHub_boot_errors.txt",log)warn("[ZeyHubb.vs] Errores escritos a RivalHub_boot_errors.txt")end end)end)task.defer(function()pcall(function()local errGui=Instance.new("ScreenGui")errGui.Name="RivalHubBootErrors"errGui.ResetOnSpawn=false errGui.DisplayOrder=999 local okCg,cg=pcall(function()return game:GetService("CoreGui")end)if okCg and cg then pcall(function()errGui.Parent=cg end)end if not errGui.Parent then errGui.Parent=LP:WaitForChild("PlayerGui")end local frame=Instance.new("Frame",errGui)frame.Size=UDim2.new(0,460,0,60+#_bootErrors*22)frame.Position=UDim2.new(0,10,1,-80-#_bootErrors*22)frame.BackgroundColor3=Color3.fromRGB(40,10,15)frame.BorderSizePixel=0 Instance.new("UICorner",frame).CornerRadius=UDim.new(0,10)local stroke=Instance.new("UIStroke",frame)stroke.Color=Color3.fromRGB(49,120,220)stroke.Thickness=1.5 local title=Instance.new("TextLabel",frame)title.Size=UDim2.new(1,-20,0,24)title.Position=UDim2.new(0,10,0,8)title.BackgroundTransparency=1 title.Text="⚠ ZeyHubb.vs: "..#_bootErrors.." sección(es) fallaron"title.TextColor3=Color3.fromRGB(54,131,220)title.Font=Enum.Font.GothamBold title.TextSize=13 title.TextXAlignment=Enum.TextXAlignment.Left for i,e in ipairs(_bootErrors)do local lbl=Instance.new("TextLabel",frame)lbl.Size=UDim2.new(1,-20,0,18)lbl.Position=UDim2.new(0,10,0,34+(i-1)*20)lbl.BackgroundTransparency=1 lbl.Text="• "..e.name..": "..e.err:sub(1,110)lbl.TextColor3=Color3.fromRGB(81,212,255)lbl.Font=Enum.Font.Code lbl.TextSize=10 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.TextTruncate=Enum.TextTruncate.AtEnd end local copyBtn=Instance.new("TextButton",frame)copyBtn.Size=UDim2.new(0,100,0,22)copyBtn.Position=UDim2.new(0,10,1,-30)copyBtn.BackgroundColor3=Color3.fromRGB(80,20,30)copyBtn.Text="COPIAR LOG"copyBtn.TextColor3=Color3.fromRGB(255,200,200)copyBtn.Font=Enum.Font.GothamBold copyBtn.TextSize=11 copyBtn.BorderSizePixel=0 Instance.new("UICorner",copyBtn).CornerRadius=UDim.new(0,6)copyBtn.Activated:Connect(function()local buf=""for _,e in ipairs(_bootErrors)do buf=buf..e.name..": "..e.err.."\n"end pcall(function()if setclipboard then setclipboard(buf)end end)copyBtn.Text="¡COPIADO!"task.delay(1.2,function()copyBtn.Text="COPIAR LOG"end)end)local closeBtn=Instance.new("TextButton",frame)closeBtn.Size=UDim2.new(0,60,0,22)closeBtn.Position=UDim2.new(1,-70,1,-30)closeBtn.BackgroundColor3=Color3.fromRGB(80,20,30)closeBtn.Text="CERRAR"closeBtn.TextColor3=Color3.fromRGB(255,200,200)closeBtn.Font=Enum.Font.GothamBold closeBtn.TextSize=11 closeBtn.BorderSizePixel=0 Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)closeBtn.Activated:Connect(function()pcall(function()errGui:Destroy()end)end)task.delay(60,function()pcall(function()errGui:Destroy()end)end)end)end)end else warn("[Rival Hub Boot] Fatal: buildGui falló. El script no puede continuar.")end if LP and LP.CharacterAdded then pcall(function()local _respawnQueue=0 LP.CharacterAdded:Connect(function(char)pcall(function()_respawnQueue=_respawnQueue+1 local myId=_respawnQueue if stealConnection then stealConnection:Disconnect();stealConnection=nil end isStealing=false _stealLockUntil=0 if stopAutoLeft then stopAutoLeft()end if stopAutoRight then stopAutoRight()end if stopBatCounter then stopBatCounter()end if stopBatCounterV2 then stopBatCounterV2()end if stopMedusaCounter then stopMedusaCounter()end if stopUnwalk then stopUnwalk()end if stopDropBrainrot then stopDropBrainrot()end if autoBatEnabled and disableAutoBat then disableAutoBat()end if bodyLockEnabled and stopBodyLock then stopBodyLock()end local deadline=_tick()+5 while(not char.Parent)or(not char:FindFirstChild("HumanoidRootPart"))or(not char:FindFirstChildOfClass("Humanoid"))do if _tick()>deadline then return end if myId~=_respawnQueue then return end task.wait(0.05)end _hookedVelParts={}local _hrpRespawn=_setupVelChecked(char)_hookVelHRP(_hrpRespawn)if not _originalAppearance then task.defer(function()captureOriginalAppearance(char)end)end if setupMovementAndIndicators then setupMovementAndIndicators(char)end if antiRagdollMode=="v1"then pcall(function()if AntiRagdollV1.isRunning()then cacheCharacterV1()else AntiRagdollV1.start()end end)elseif antiRagdollMode=="v2"then pcall(function()stopAntiRagdollV2()startAntiRagdollV2()end)end if antiBatEnabled then startAntiBat()end if antiFlingEnabled then startAntiFling()end if AntiDieModule.enabled then task.defer(function()activateOnCharacter(char)end)end if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal)end if bodyLockEnabled and _blSuppressCount==0 then startBodyLock()end if medusaCounterEnabled then setupMedusaCounter(char)if setMedusaVisual then setMedusaVisual(true)end else stopMedusaCounter()if setMedusaVisual then setMedusaVisual(false)end end if batCounterEnabled then startBatCounter()end if batCounterV2Enabled then startBatCounterV2()end if unwalkEnabled then startUnwalk()end if currentAnimPack~="Off"then task.wait(0.3);startAnimPack(currentAnimPack)end updateProgressBarVisibility()refreshSpeedModeLabel()pcall(function()applyOutfitByIndex(currentOutfitIndex)end)if outfitSelectorLabel and OUTFITS[currentOutfitIndex]then outfitSelectorLabel.Text=OUTFITS[currentOutfitIndex].label end end)end)end)end do
local _featureWatchLast=0
task.spawn(function()
while true do
task.wait(1.5)
pcall(function()
if not _G.RivalHubRunning then return end
if CONFIG and CONFIG.AUTO_STEAL_ENABLED then
local alive=false
if stealConnection then pcall(function()alive=stealConnection.Connected==true end)end
if not alive then pcall(startAutoSteal)end
if isStealing and _stealLockUntil and _stealLockUntil>0 and _tick()>_stealLockUntil then isStealing=false _stealLockUntil=0 end
end
if antiRagdollMode=="v1" then
if not AntiRagdollV1.isRunning() then pcall(AntiRagdollV1.start) else pcall(cacheCharacterV1) end
elseif antiRagdollMode=="v2" then
if not AntiRagdollV2.Enabled or not AntiRagdollV2.Connection then pcall(function()stopAntiRagdollV2()startAntiRagdollV2()end) end
end
end)
end
end)
task.spawn(function()
while true do
task.wait(20)
pcall(function()if saveAllSettings then saveAllSettings(false)end end)
end
end)
pcall(function()
game:BindToClose(function()
pcall(function()if saveAllSettings then saveAllSettings(true)end end)
end)
end)
pcall(function()
Players.PlayerRemoving:Connect(function(plr)
if plr==LP then pcall(function()if saveAllSettings then saveAllSettings(true)end end)end
end)
end)
pcall(function()
local TS=game:GetService("TeleportService")
if TS and TS.TeleportInitFailed then
end
local GuiService=game:GetService("GuiService")
end)
pcall(function()
if LP then
LP.OnTeleport:Connect(function()
pcall(function()if saveAllSettings then saveAllSettings(true)end end)
end)
end
end)
end
local lastLaggerToggle=0 local LAGGER_COOLDOWN=0.3 UIS.InputBegan:Connect(function(input,gpe)if _anyKeyListening then return end if input.UserInputType==Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox()then return end elseif not isGamepadInput(input)then return end if not isBindableInput(input)then return end local kc=input.KeyCode if not kc then return end if kbMatch(KB.LaggerMode,kc)then if _tick()-lastLaggerToggle>=LAGGER_COOLDOWN then lastLaggerToggle=_tick()toggleLaggerCycle()end return end if kbMatch(KB.CarryToggle,kc)then toggleCarryMode();return end if kbMatch(KB.DropBrainrot,kc)then if not dropActive then if dropBrainrotSetVisual then dropBrainrotSetVisual(true)end executeDropWithToggle(dropBrainrotSetVisual)end return end if kbMatch(KB.TPFloor,kc)then doTpDown();return end if kbMatch(KB.AutoLeft,kc)then autoLeftEnabledReleased=not autoLeftEnabled if autoLeftEnabled then startAutoLeft()else stopAutoLeft()end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled)end if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled)end return end if kbMatch(KB.AutoRight,kc)then autoRightEnabled=not autoRightEnabled if autoRightEnabled then startAutoRight()else stopAutoRight()end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled)end if mobSetAutoRight then mobSetAutoRight(autoRightEnabled)end return end if kbMatch(KB.BatAimbot,kc)then local toggle=_G.__RivalHubBatAimbotToggle;if type(toggle)=="function" then local ok,res=pcall(toggle);if ok then local state=res==true;if _G.__RivalHubBatAimbotSetVisual then pcall(_G.__RivalHubBatAimbotSetVisual,state) end;if mobSetBatAimbot then pcall(mobSetBatAimbot,state) end;pcall(saveAllSettings,true) else warn("[ZeyHubb.vs] Bat Aimbot keybind failed: "..tostring(res)) end end;return end if kbMatch(KB.AutoBat,kc)then if not autoBatEnabled then enableAutoBat()if autoBatSetVisual then autoBatSetVisual(true)end if mobSetAutoBat then mobSetAutoBat(true)end else disableAutoBat()if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end end return end if kbMatch(KB.TPBat,kc)then toggleBatTP()return end if kbMatch(KB.BatV2,kc)then if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()then if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2)end if mobSetBatV2 then mobSetBatV2(false)end else if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2)end if mobSetBatV2 then mobSetBatV2(true)end end return end if kbMatch(KB.Float,kc)then if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle()end return end if kbMatch(KB.InstantReset,kc)then local resetFn=_G.__ZeyHubbRunInstantReset if type(resetFn)=="function"then pcall(resetFn)end return end if kbMatch(KB.GuiHide,kc)then if main then if main.Visible then hideGui()else showGui()end end return end end)do local introGeneration=0 local wasHoldingBrainrot=false local activeIntroGui=nil local function isHoldingBrainrot()local char=LP and LP.Character if not char then return false end if LP:GetAttribute("Stealing")==true or char:GetAttribute("Stealing")==true then return true end local function nameIsBrainrot(n)n=tostring(n or""):lower()if n==""then return false end if n:find("bat",1,true)or n:find("sword",1,true)or n:find("katana",1,true)or n:find("gun",1,true)or n:find("medusa",1,true)or n:find("slap",1,true)or n:find("weapon",1,true)or n:find("bypass",1,true)or n:find("tool",1,true)then return false end return n:find("brainrot",1,true)~=nil or n:find("animal",1,true)~=nil or n:find("stolen",1,true)~=nil end for _,entry in ipairs({"StealHold","IsCarrying","Carrying"})do local inst=char:FindFirstChild(entry,true)if inst and inst:IsA("BoolValue")and inst.Value==true then for _,child in ipairs(char:GetChildren())do if(child:IsA("Tool")or child:IsA("Model"))and nameIsBrainrot(child.Name)then return true end end end end for _,child in ipairs(char:GetChildren())do if(child:IsA("Tool")or child:IsA("Model"))and nameIsBrainrot(child.Name)then return true end end return false end local function playBrainrotIntro(myGeneration)if activeIntroGui then pcall(function()activeIntroGui:Destroy()end)end local playerGui=LP and(LP:FindFirstChildOfClass("PlayerGui")or LP:WaitForChild("PlayerGui",5))if not playerGui or myGeneration~=introGeneration or not isHoldingBrainrot()then return end local introGui=Instance.new("ScreenGui")introGui.Name="BrainrotEnterIntro"introGui.ResetOnSpawn=false introGui.IgnoreGuiInset=true introGui.DisplayOrder=1000000 introGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling introGui.Parent=playerGui activeIntroGui=introGui local strip=Instance.new("Frame")strip.Name="EnterStrip"strip.AnchorPoint=Vector2.new(0.5,0.5)strip.Position=UDim2.new(0.5,0,-0.18,0)strip.Size=UDim2.fromOffset(240,40)strip.BackgroundColor3=Color3.fromRGB(2,7,12)strip.BorderSizePixel=0 strip.ClipsDescendants=true strip.ZIndex=2 strip.Parent=introGui Instance.new("UICorner",strip).CornerRadius=UDim.new(1,0)local completeBorder=Instance.new("UIStroke",strip)completeBorder.Name="CompleteLoadingBorder"completeBorder.Color=Color3.fromRGB(60,200,255)completeBorder.Thickness=2.2 completeBorder.Transparency=0.2 completeBorder.ZIndex=6 local scale=Instance.new("UIScale",strip)scale.Scale=0.9 local lineFill=Instance.new("Frame",strip)lineFill.Name="LoadingLine"lineFill.Size=UDim2.new(0,0,1,0)lineFill.Position=UDim2.new(0,0,0,0)lineFill.BackgroundColor3=Color3.fromRGB(40,180,255)lineFill.BackgroundTransparency=0.15 lineFill.BorderSizePixel=0 lineFill.ZIndex=3 Instance.new("UICorner",lineFill).CornerRadius=UDim.new(1,0)local lfGrad=Instance.new("UIGradient",lineFill)lfGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,240,200)),ColorSequenceKeypoint.new(0.35,Color3.fromRGB(60,200,255)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(35,120,220)),})local label=Instance.new("TextLabel",strip)label.Name="EnterLabel"label.Size=UDim2.new(1,-32,1,-16)label.Position=UDim2.fromOffset(16,8)label.BackgroundTransparency=1 label.Text="DON'T ENTER"label.TextColor3=Color3.fromRGB(255,230,190)label.TextStrokeTransparency=0.4 label.TextStrokeColor3=Color3.fromRGB(20,8,0)label.Font=Enum.Font.GothamBlack label.TextScaled=true label.TextWrapped=true label.ZIndex=5 local limit=Instance.new("UITextSizeConstraint",label)limit.MinTextSize=10 limit.MaxTextSize=16 local function stillValid()return myGeneration==introGeneration and introGui.Parent~=nil and isHoldingBrainrot()end local function abortIf()if stillValid()then return false end if introGui.Parent then introGui:Destroy()end if activeIntroGui==introGui then activeIntroGui=nil end return true end local arrival=TS:Create(strip,TweenInfo.new(0.52,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.fromScale(0.5,0.12)})TS:Create(scale,TweenInfo.new(0.52,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()arrival:Play()arrival.Completed:Wait()if abortIf()then return end local revealTime=1.9 local elapsed=0 while elapsed<revealTime do lineFill.Size=UDim2.new(math.clamp(elapsed/revealTime,0,1),0,1,0)elapsed=elapsed+task.wait()if abortIf()then return end end lineFill.Size=UDim2.new(1,0,1,0)completeBorder.Transparency=0 label.Text="ENTER"label.TextTransparency=1 TS:Create(label,TweenInfo.new(0.18),{TextTransparency=0}):Play()task.wait(0.3)if abortIf()then return end TS:Create(scale,TweenInfo.new(0.38,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Scale=1.35}):Play()TS:Create(strip,TweenInfo.new(0.38),{BackgroundTransparency=1}):Play()TS:Create(lineFill,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()TS:Create(label,TweenInfo.new(0.25),{TextTransparency=1}):Play()TS:Create(completeBorder,TweenInfo.new(0.25),{Transparency=1}):Play()task.wait(0.4)if introGui.Parent then introGui:Destroy()end if activeIntroGui==introGui then activeIntroGui=nil end end task.spawn(function()while true do local holding=isHoldingBrainrot()if holding and not wasHoldingBrainrot then introGeneration=introGeneration+1 local thisGeneration=introGeneration task.spawn(function()playBrainrotIntro(thisGeneration)end)elseif not holding and wasHoldingBrainrot then introGeneration=introGeneration+1 if activeIntroGui then pcall(function()activeIntroGui:Destroy()end)activeIntroGui=nil end end wasHoldingBrainrot=holding task.wait(0.1)end end)end do local CleanKatanaPlayers=game:GetService("Players")local CleanKatanaLP=CleanKatanaPlayers.LocalPlayer local CLEAN_SLASH_SOUND="rbxassetid://111808555599832"local cleanKatanaController local function createKatanaSkinController()local katanaPlayersService=game:GetService("Players")local katanaInsertService=game:GetService("InsertService")local katanaLighting=game:GetService("Lighting")local katanaReplicatedStorage=game:GetService("ReplicatedStorage")local katanaPlayer=katanaPlayersService.LocalPlayer local katanaColors={red=Color3.new(0.784314,0,0),red2=Color3.new(1,0,0.392157),gold=Color3.new(1,0.843137,0),}local katanaState={Skin="KATANA",SkinOrder={"KATANA","NONE"},LastBat=nil,LastAppliedSkin=nil,OriginalKatanaTemplate=nil,ExactTemplates={},ExactTemplateSearched={},ExactAssetIds={KATANA=""},Original={},}local function findBat()local character=katanaPlayer.Character if character then local bat=character:FindFirstChild("Bat")if bat and bat:IsA("Tool")then return bat end end local backpack=katanaPlayer:FindFirstChildOfClass("Backpack")if backpack then local bat=backpack:FindFirstChild("Bat")if bat and bat:IsA("Tool")then return bat end end backpack=katanaPlayer:FindFirstChildOfClass("Backpack")for _,container in ipairs({katanaPlayer.Character,backpack})do if container then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and tool.Name:lower():find("bat",1,true)then return tool end end end end return nil end local function configureVisualPart(part)if not part or not part:IsA("BasePart")then return end part.Anchored=false part.CanCollide=false part.CanTouch=false part.CanQuery=false part.Massless=true end local function weldToHandle(part1,part0)if not part1 or not part0 or not part1:IsA("BasePart")or not part0:IsA("BasePart")then return end configureVisualPart(part1)local wc=Instance.new("WeldConstraint")wc.Name="FlowerSkin_AssetWeld"wc.Part0=part0 wc.Part1=part1 wc.Parent=part1 end local function cacheOriginalBatState(batTool)if not batTool then return end local handle=batTool:FindFirstChild("Handle")local slash=batTool:FindFirstChild("Slash")katanaState.Original[batTool]=katanaState.Original[batTool]or{}local o=katanaState.Original[batTool]if handle and handle:IsA("BasePart")and not o.Handle then o.Handle={Transparency=handle.Transparency,LocalTransparencyModifier=handle.LocalTransparencyModifier,CastShadow=handle.CastShadow}end if slash and slash:IsA("Sound")and not o.SlashSoundId then o.SlashSoundId=slash.SoundId end end local function captureOriginalKatanaTemplate()if katanaState.OriginalKatanaTemplate then return end local function scanContainer(container)if not container then return end local bat=container:FindFirstChild("Bat")if not bat then return end local f=bat:FindFirstChild("FlowerSkin_KatanaRealistic")f=f and f:FindFirstChild("FlowerSkin_AssetKatana")if f then katanaState.OriginalKatanaTemplate=f:Clone()end end scanContainer(katanaPlayer:FindFirstChildOfClass("Backpack"))scanContainer(katanaPlayer.Character)end local function setBatHandleHidden(batTool,hidden)local handle523=batTool and batTool:FindFirstChild("Handle")if not handle523 or not handle523:IsA("BasePart")then return end cacheOriginalBatState(batTool)if hidden then handle523.LocalTransparencyModifier=1 handle523.Transparency=1 handle523.CastShadow=false else local h=katanaState.Original[batTool]and katanaState.Original[batTool].Handle handle523.LocalTransparencyModifier=h and h.LocalTransparencyModifier or 0 handle523.Transparency=h and h.Transparency or 0 handle523.CastShadow=h and h.CastShadow if handle523.CastShadow==nil then handle523.CastShadow=true end end end local function setBatSlashSound(batTool,soundId)cacheOriginalBatState(batTool)local slash=batTool and batTool:FindFirstChild("Slash")if slash and slash:IsA("Sound")then if not soundId then soundId=katanaState.Original[batTool]and katanaState.Original[batTool].SlashSoundId or slash.SoundId end slash.SoundId=soundId end end local function restoreOriginalBatVisual(batTool)if not batTool then return end local f=batTool:FindFirstChild("FlowerSkin_KatanaRealistic")if f then f:Destroy()end local fa=batTool:FindFirstChild("FlowerSkin_AssetKatana")if fa then fa:Destroy()end setBatHandleHidden(batTool,false)setBatSlashSound(batTool,nil)end local function addKatanaRedEffects(parent)if not parent or not parent:IsA("BasePart")then return end local old=parent:FindFirstChild("FictionHubSpeedIndicator")if old then old:Destroy()end local topAtt=Instance.new("Attachment")topAtt.Name="FlowerSkin_ExtraRedVFX"topAtt.Position=Vector3.new(0,parent.Size.Y*0.5,0)topAtt.Parent=parent local botAtt=Instance.new("Attachment")botAtt.Name="FlowerSkin_ExtraRedVFX_End"botAtt.Position=Vector3.new(0,-parent.Size.Y*0.5,0)botAtt.Parent=parent local trail=Instance.new("Trail")trail.Name="FlowerSkin_ExtraRedVFX"trail.Attachment0=topAtt trail.Attachment1=botAtt trail.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,katanaColors.red2),ColorSequenceKeypoint.new(1,Color3.new(0.54902,0,0)),})trail.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.35),NumberSequenceKeypoint.new(1,1),})trail.Lifetime=0.18 trail.LightEmission=0.55 trail.Parent=parent local pe=Instance.new("ParticleEmitter")pe.Name="FlowerSkin_ExtraRedVFX"pe.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.784314,0,0)),ColorSequenceKeypoint.new(1,katanaColors.red2),})pe.LightEmission=0.55 pe.Rate=14 pe.Lifetime=NumberRange.new(0.3,0.45)pe.Speed=NumberRange.new(0.2,0.7)pe.SpreadAngle=Vector2.new(12,12)pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.08),NumberSequenceKeypoint.new(1,0),})pe.Texture="rbxasset://textures/particles/sparkles_main.dds"pe.Parent=parent end local function createKatanaPart(parent,name,size,cfOffset,color,material)local part=Instance.new("Part")part.Name=name part.Size=size part.Color=color part.Material=material or Enum.Material.Neon part.TopSurface=Enum.SurfaceType.Smooth part.BottomSurface=Enum.SurfaceType.Smooth configureVisualPart(part)part.Parent=parent return part,cfOffset or CFrame.identity end local katanaCandidateNames={KATANA={"FlowerSkin_AssetKatana","Katana","FlowerSkin_KatanaRealistic"}}local function isScriptInstance(instance)return instance:IsA("Script")or instance:IsA("LocalScript")or instance:IsA("ModuleScript")end local function removeScripts(root)if not root then return end if isScriptInstance(root)then root:Destroy();return end for _,d in ipairs(root:GetDescendants())do if isScriptInstance(d)then d:Destroy()end end end local function hasBasePart(candidate)if not candidate then return false end if candidate:IsA("BasePart")then return true end return candidate:FindFirstChildWhichIsA("BasePart",true)~=nil end local function isGeneratedSkin(candidate)local ok,result=pcall(function()return candidate:GetAttribute("CursedBatSkinsGenerated")end)return ok and result==true end local function validateSkinCandidate(candidate)if not candidate or isGeneratedSkin(candidate)then return nil end if candidate:IsA("Model")or candidate:IsA("Tool")or candidate:IsA("Accessory")or candidate:IsA("BasePart")then if hasBasePart(candidate)then return candidate end end return nil end local function findNamedSkinCandidate(root,candidateNames)if not root then return nil end for _,entry in ipairs(candidateNames)do if root.Name~=entry then continue end local c=validateSkinCandidate(root)if c then return c end end for _,cn in ipairs(candidateNames)do local inst=root:FindFirstChild(cn,true)local v=validateSkinCandidate(inst)if v then return v end end return nil end local function normalizeAssetId(assetId)local n=tostring(assetId or""):gsub("%s+","")if n==""then return nil end if n:match("^rbxassetid://")or n:match("^rbxasset://")then return n end if n:match("^%d+$")then return"rbxassetid://"..n end return n end local function loadAssetSkinTemplate(skinName)local uri=normalizeAssetId(katanaState.ExactAssetIds[skinName])if not uri then return nil end local loaded={}pcall(function()loaded=game:GetObjects(uri)end)if#loaded==0 then local m=tostring(uri):match("(%d+)")if m then pcall(function()table.insert(loaded,katanaInsertService:LoadAsset(tonumber(m)))end)end end local names=katanaCandidateNames[skinName]or{}for _,entry in ipairs(loaded)do local c=findNamedSkinCandidate(entry,names)or validateSkinCandidate(entry)if c then local clone=c:Clone()removeScripts(clone)return clone end end return nil end local function findExistingSkinTemplate(skinName)local names=katanaCandidateNames[skinName]if not names then return nil end local roots={katanaPlayer.Character,katanaPlayer:FindFirstChildOfClass("Backpack"),katanaReplicatedStorage,katanaLighting,workspace}for _,entry in ipairs(roots)do local c=findNamedSkinCandidate(entry,names)if c then local clone=c:Clone()removeScripts(clone)return clone end end return nil end local function getSkinTemplate(skinName)if skinName=="KATANA"and katanaState.OriginalKatanaTemplate then return katanaState.OriginalKatanaTemplate end if katanaState.ExactTemplates[skinName]then return katanaState.ExactTemplates[skinName]end if katanaState.ExactTemplateSearched[skinName]then return nil end katanaState.ExactTemplateSearched[skinName]=true local t=loadAssetSkinTemplate(skinName)or findExistingSkinTemplate(skinName)if t then katanaState.ExactTemplates[skinName]=t end return t end local normalizeSkinModel normalizeSkinModel=function(source,parent)if source:IsA("Model")then source.Name="FlowerSkin_AssetKatana";source.Parent=parent;return source end if source:IsA("BasePart")then local m=Instance.new("Model")m.Name="FlowerSkin_AssetKatana"m.Parent=parent source.Parent=m return m end if source:IsA("Tool")or source:IsA("Folder")then local f=source:FindFirstChild("FlowerSkin_AssetKatana")or source:FindFirstChildWhichIsA("Model")or source:FindFirstChildWhichIsA("BasePart")if f and f.Parent==source then f.Parent=nil source:Destroy()return normalizeSkinModel(f,parent)end local m=Instance.new("Model")m.Name="FlowerSkin_AssetKatana"m.Parent=parent for _,c in ipairs(source:GetChildren())do if not isScriptInstance(c)then c.Parent=m end end source:Destroy()return m end return nil end local function applyExactSkinTemplate(batTool,skinName)local handle=batTool and batTool:FindFirstChild("Handle")if not handle or not handle:IsA("BasePart")then return false end local template=getSkinTemplate(skinName)if not template then return false end local folder=Instance.new("Folder")folder.Name="FlowerSkin_KatanaRealistic"folder.Parent=batTool local skinModel=normalizeSkinModel(template:Clone(),folder)if not skinModel or not hasBasePart(skinModel)then folder:Destroy();return false end removeScripts(skinModel)pcall(function()skinModel:SetAttribute("CursedBatSkinsExactMesh",true)end)local firstPart for _,d in ipairs(skinModel:GetDescendants())do if d:IsA("BasePart")then firstPart=firstPart or d configureVisualPart(d)end end if not firstPart then folder:Destroy();return false end if skinModel:IsA("Model")then skinModel.PrimaryPart=skinModel.PrimaryPart or firstPart pcall(function()skinModel:PivotTo(handle.CFrame)end)end for _,d in ipairs(skinModel:GetDescendants())do if d:IsA("BasePart")then weldToHandle(d,handle)end end local weaponPart=skinModel:FindFirstChild("SharpParts",true)or skinModel:FindFirstChild("WeaponPart",true)or skinModel:FindFirstChild("Handle",true)or firstPart if weaponPart and not weaponPart:FindFirstChild("FlowerSkin_ExtraRedVFX")then addKatanaRedEffects(weaponPart)end return true end local function createProceduralKatana(batTool,skinName)local handle=batTool and batTool:FindFirstChild("Handle")if not handle or not handle:IsA("BasePart")then return nil end local folder=Instance.new("Folder")folder.Name="FlowerSkin_KatanaRealistic"folder.Parent=batTool local model=Instance.new("Model")model.Name="FlowerSkin_AssetKatana"model:SetAttribute("CursedBatSkinsGenerated",true)model.Parent=folder local created={}local function createPart(name,size,cfOffset,color,material)local p,off=createKatanaPart(model,name,size,cfOffset,color,material)p.CFrame=handle.CFrame*off weldToHandle(p,handle)table.insert(created,p)return p end if skinName=="KATANA"then createPart("Handle2",Vector3.new(0.22,1,0.22),CFrame.new(0,-0.48,0),Color3.new(0.176471,0.176471,0.045),Enum.Material.Metal)local sp=createPart("SharpParts",Vector3.new(0.18,2.4,0.12),CFrame.new(0,1.05,0),katanaColors.red2,Enum.Material.Neon)createPart("WeaponPart",Vector3.new(0.3,2.7,0.08),CFrame.new(0.08,1.15,0),katanaColors.red,Enum.Material.Neon)createPart("GoldAccent",Vector3.new(0.5,0.12,0.08),CFrame.new(0,-0.28,0),katanaColors.gold,Enum.Material.Neon)addKatanaRedEffects(sp)end model.PrimaryPart=created[1]return model end local slashSoundIds={KATANA="rbxassetid://111808555599832"}return{State=katanaState,ApplySkin=function(skinName)captureOriginalKatanaTemplate()local lastBat=findBat()if not lastBat then katanaState.LastBat=nil katanaState.LastAppliedSkin=nil return false end cacheOriginalBatState(lastBat)restoreOriginalBatVisual(lastBat)if skinName=="NONE"then katanaState.LastBat=lastBat katanaState.LastAppliedSkin=skinName return true end setBatHandleHidden(lastBat,true)setBatSlashSound(lastBat,slashSoundIds[skinName])if not applyExactSkinTemplate(lastBat,skinName)then createProceduralKatana(lastBat,skinName)end local handle=lastBat:FindFirstChild("Handle")if handle then local fire=handle:FindFirstChildOfClass("Fire")or handle:FindFirstChild("Fire")if fire and fire:IsA("Fire")then fire.Enabled=true fire.Color=katanaColors.red fire.SecondaryColor=katanaColors.red2 end end katanaState.LastBat=lastBat katanaState.LastAppliedSkin=skinName return true end,SetExactAssetId=function(assetId)katanaState.ExactAssetIds.KATANA=tostring(assetId or"")katanaState.ExactTemplateSearched.KATANA=nil katanaState.ExactTemplates.KATANA=nil end,}end cleanKatanaController=createKatanaSkinController()_G.CursedBatKatana=cleanKatanaController _G.CleanKatana={controller=cleanKatanaController,slashSound=CLEAN_SLASH_SOUND}task.spawn(function()while true do pcall(function()local char=CleanKatanaLP.Character local backpack=CleanKatanaLP:FindFirstChildOfClass("Backpack")local bat=nil for _,container in ipairs({char,backpack})do if container and not bat then local b=container:FindFirstChild("Bat")if b and b:IsA("Tool")then bat=b end end end if not bat then for _,container in ipairs({char,backpack})do if container and not bat then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and tool.Name:lower():find("bat",1,true)then bat=tool break end end end end end if bat then local st=cleanKatanaController.State if bat~=st.LastBat or st.LastAppliedSkin~="KATANA"then cleanKatanaController.ApplySkin("KATANA")end local slash=bat:FindFirstChild("Slash")if slash and slash:IsA("Sound")and slash.SoundId~=CLEAN_SLASH_SOUND then slash.SoundId=CLEAN_SLASH_SOUND end end end)task.wait(0.5)end end)end do local SkinPlayers=game:GetService("Players")local SkinLP=SkinPlayers.LocalPlayer local function isMedusaSkinTool(obj)if not obj or not obj:IsA("Tool")then return false end local n=obj.Name:lower()return n:find("medusa",1,true)~=nil or n:find("head",1,true)~=nil or n:find("stone",1,true)~=nil end local function removeBombSkin(tool)local f=tool:FindFirstChild("ShelMedusaBombSkin")if f then f:Destroy()end if tool:GetAttribute("ShelMedusaBombSkin")then tool:SetAttribute("ShelMedusaBombSkin",nil)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("BasePart")then obj.LocalTransparencyModifier=0 end end end end local function applyMedusaSkin(tool)if not isMedusaSkinTool(tool)then return end if(_G.RivalMedusaSkin or"Default")~="Default"then removeBombSkin(tool)return end if tool:GetAttribute("ShelMedusaBombSkin")and tool:FindFirstChild("ShelMedusaBombSkin")then return end local handle=tool:FindFirstChild("Handle")or tool:FindFirstChildWhichIsA("BasePart",true)if not handle or not handle:IsA("BasePart")then return end tool:SetAttribute("ShelMedusaBombSkin",true)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("BasePart")then obj.LocalTransparencyModifier=1 end end local bomb=Instance.new("Folder")bomb.Name="ShelMedusaBombSkin"bomb.Parent=tool local function block(name,size,color,offset,shape,material)local part=Instance.new("Part")part.Name=name part.Size=size part.Shape=shape or Enum.PartType.Block part.Color=color part.Material=material or Enum.Material.SmoothPlastic part.CFrame=handle.CFrame*offset part.CanCollide=false part.CanTouch=false part.CanQuery=false part.CastShadow=false part.Massless=true part.Anchored=false part.Parent=bomb local weld=Instance.new("WeldConstraint")weld.Part0=handle weld.Part1=part weld.Parent=part return part end local black=Color3.fromRGB(12,12,15)local darkRed=Color3.fromRGB(95,8,12)local red=Color3.fromRGB(45,65,182)local fuse=Color3.fromRGB(51,124,220)block("BombBody",Vector3.new(1.25,1.25,1.25),black,CFrame.new(0,0,0),Enum.PartType.Ball)block("BombBand",Vector3.new(1.32,0.18,1.32),darkRed,CFrame.new(0,0.02,0))block("BombCore",Vector3.new(0.72,0.72,0.72),red,CFrame.new(0,0,-0.57),Enum.PartType.Ball,Enum.Material.Neon)block("BombCap",Vector3.new(0.42,0.22,0.42),darkRed,CFrame.new(0,0.73,0))block("BombFuse",Vector3.new(0.14,0.48,0.14),fuse,CFrame.new(0,1.03,0),Enum.PartType.Cylinder,Enum.Material.Neon)block("BombSpark",Vector3.new(0.24,0.24,0.24),Color3.fromRGB(85,222,255),CFrame.new(0,1.34,0),Enum.PartType.Ball,Enum.Material.Neon)if not tool:GetAttribute("ShelMedusaDescHook")then tool:SetAttribute("ShelMedusaDescHook",true)tool.DescendantAdded:Connect(function(obj)if(_G.RivalMedusaSkin or"Default")~="Default"then return end if obj:FindFirstAncestor("ShelMedusaBombSkin")then return end if obj:IsA("BasePart")then obj.LocalTransparencyModifier=1 end end)end end local function watchSkinContainer(container)if not container then return end for _,child in ipairs(container:GetChildren())do if child:IsA("Tool")then task.defer(applyMedusaSkin,child)end end if not container:GetAttribute("ShelMedusaSkinWatch")then container:SetAttribute("ShelMedusaSkinWatch",true)container.ChildAdded:Connect(function(child)if not child:IsA("Tool")then return end task.wait()applyMedusaSkin(child)end)end end local function scanSkinTools()watchSkinContainer(SkinLP:FindFirstChildOfClass("Backpack"))watchSkinContainer(SkinLP.Character)end scanSkinTools()SkinLP.ChildAdded:Connect(function(child)if child:IsA("Backpack")then watchSkinContainer(child)end end)SkinLP.CharacterAdded:Connect(function(character)task.wait(0.5)watchSkinContainer(character)scanSkinTools()end)task.spawn(function()while task.wait(1)do scanSkinTools()end end)_G.ShelMedusaSkin={apply=scanSkinTools}end do local LPl=game:GetService("Players").LocalPlayer local ALPHA_HELD=0.85 local ALPHA_BASE=0.7 local ATTR="RHBrOrigT"local state={held=false,base=false,heldDirty=false,baseDirty=false}local BODY={Head=1,Torso=1,UpperTorso=1,LowerTorso=1,HumanoidRootPart=1,["Left Arm"]=1,["Right Arm"]=1,["Left Leg"]=1,["Right Leg"]=1,LeftUpperArm=1,LeftLowerArm=1,LeftHand=1,RightUpperArm=1,RightLowerArm=1,RightHand=1,LeftUpperLeg=1,LeftLowerLeg=1,LeftFoot=1,RightUpperLeg=1,RightLowerLeg=1,RightFoot=1,}local function isMedusaPiece(inst)local cur=inst while cur and cur~=workspace and cur~=game do if cur.Name=="RivalMedusaReplica"or cur.Name=="ShelMedusaBombSkin"or cur.Name:lower():find("medusa",1,true)then return true end if cur:IsA("Tool")then local n=cur.Name:lower()if n:find("medusa",1,true)or n:find("stone",1,true)or n:find("head",1,true)then return true end end cur=cur.Parent end return false end local function setT(inst,on,alpha)if inst:IsA("BasePart")or inst:IsA("Decal")or inst:IsA("Texture")then local o=inst:GetAttribute(ATTR)if isMedusaPiece(inst)then if o~=nil then inst.Transparency=o inst:SetAttribute(ATTR,nil)end return end if on then if o==nil then o=inst.Transparency;inst:SetAttribute(ATTR,o)end local want=math.max(o,alpha)if inst.Transparency~=want then inst.Transparency=want end elseif o~=nil then inst.Transparency=o inst:SetAttribute(ATTR,nil)end end end local function setXray(root,on)local hl=root:FindFirstChild("RHBrXray")if on then if not hl then hl=Instance.new("Highlight")hl.Name="RHBrXray"hl.Adornee=root hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.FillColor=Color3.fromRGB(30,160,255)hl.FillTransparency=1 hl.OutlineColor=Color3.fromRGB(70,170,255)hl.OutlineTransparency=1 hl.Parent=root else hl.FillTransparency=1 hl.OutlineTransparency=1 end elseif hl then hl:Destroy()end end local function applyTree(root,on,alpha)setT(root,on,alpha)for _,d in ipairs(root:GetDescendants())do setT(d,on,alpha)end setXray(root,on)end local function topOf(part,char)local top=part local m=part:FindFirstAncestorOfClass("Model")while m and m~=workspace and m~=char and not m:IsDescendantOf(char)do top=m m=m.Parent and m.Parent:FindFirstAncestorOfClass("Model")end return top end local function heldTargets(char)local list,seen={},{}local function add(o)if o and not seen[o]then seen[o]=true;list[#list+1]=o end end for _,child in ipairs(char:GetChildren())do if child:IsA("Model")then add(child)elseif child:IsA("BasePart")and not BODY[child.Name]then add(child)end end local root=char:FindFirstChild("HumanoidRootPart")if root then local ok,connected=pcall(function()return root:GetConnectedParts(true)end)if ok and connected then for _,p in ipairs(connected)do if not p:IsDescendantOf(char)then add(topOf(p,char))end end end end return list end local function myPlot()local plots=workspace:FindFirstChild("Plots")if not plots then return nil end for _,plot in ipairs(plots:GetChildren())do local sign=plot:FindFirstChild("PlotSign")local yb=sign and sign:FindFirstChild("YourBase")if yb and yb:IsA("BillboardGui")and yb.Enabled then return plot end end return nil end local lastHeld={}local function processHeld(on)local char=LPl.Character if not char then return end local targets=heldTargets(char)for _,o in ipairs(targets)do applyTree(o,on,ALPHA_HELD)lastHeld[o]=true end local current={}for _,o in ipairs(targets)do current[o]=true end for o in pairs(lastHeld)do if not current[o]then if o.Parent then applyTree(o,false,ALPHA_HELD)end lastHeld[o]=nil end end end local lastBase={}local printed={}local function baseTargets()local list,seen={},{}local function add(o)if o and not seen[o]then seen[o]=true;list[#list+1]=o end end local plot=myPlot()local pods=plot and plot:FindFirstChild("AnimalPodiums")if not pods then return list end local function isContainer(inst)return inst==workspace or inst==plot or inst==pods or inst.Parent==pods or inst:IsA("Folder")end for _,pod in ipairs(pods:GetChildren())do local podBase=pod:FindFirstChild("Base")for _,c in ipairs(pod:GetChildren())do if c~=podBase and c:IsA("Model")and not c:FindFirstChildOfClass("Humanoid")then add(c)end end local spawnPart=podBase and podBase:FindFirstChild("Spawn")if spawnPart and spawnPart:IsA("BasePart")then local ok,parts=pcall(function()return workspace:GetPartBoundsInRadius(spawnPart.Position+Vector3.new(0,3,0),6)end)if ok and parts then for _,part in ipairs(parts)do if not part:IsDescendantOf(LPl.Character or workspace)or not LPl.Character then local top=nil local cur=part.Parent while cur and not isContainer(cur)do if cur:IsA("Model")then top=cur end cur=cur.Parent end if top and top~=pod and top~=podBase and not top:IsAncestorOf(podBase)and not top:FindFirstChild("Spawn",true)and not top:FindFirstChildOfClass("Humanoid")and not top:IsDescendantOf(podBase)and not(LPl.Character and top:IsDescendantOf(LPl.Character))then add(top)end end end end end end return list end local function processBase(on)local targets=baseTargets()local current={}for _,o in ipairs(targets)do current[o]=true applyTree(o,on,ALPHA_BASE)lastBase[o]=true if on and not printed[o]then printed[o]=true pcall(function()print("[ZeyHubb.vs] Brainrot base transparente:",o:GetFullName())end)end end for o in pairs(lastBase)do if not current[o]then if o.Parent then applyTree(o,false,ALPHA_BASE)end lastBase[o]=nil end end end _G.RHBrainrotTransparency={SetHeld=function(v)state.held=v and true or false;state.heldDirty=true end,SetBase=function(v)state.base=v and true or false;state.baseDirty=true end,}task.spawn(function()while true do pcall(function()if state.held or state.heldDirty then processHeld(state.held);state.heldDirty=false end end)task.wait(0.1)end end)task.spawn(function()while true do pcall(function()if state.base or state.baseDirty then processBase(state.base);state.baseDirty=false end end)task.wait(0.4)end end)end
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
    BAT_V2_SPEED = BAT_V2_SPEED or 55
    BAT_V2_HIT_DIST = BAT_V2_HIT_DIST or 13
    BAT_V2_LEAD_STUDS = BAT_V2_LEAD_STUDS or 3
    BAT_V2_BODY_LOCK_RANGE = BAT_V2_BODY_LOCK_RANGE or 60
    snowVS = _G.SnowVS or {}
    _G.SnowVS = snowVS
    snowVS.BatBypassJoly = snowVS.BatBypassJoly or {}
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
