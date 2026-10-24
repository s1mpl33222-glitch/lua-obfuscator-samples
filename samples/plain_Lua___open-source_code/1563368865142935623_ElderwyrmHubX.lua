local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;

local Platoboost = (function()
    local Platoboost = {}
    local cloneref = (cloneref or clonereference or function(instance) return instance end)

    function Platoboost.New(Service, Secret)
        local service = Service;
        local secret = Secret;
        local useNonce = true;
        local onMessage = function(message) end;

        repeat task.wait(1) until game:IsLoaded();

        local requestSending = false;
        local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return cloneref(game:GetService("Players")).LocalPlayer.UserId end
        local cachedLink, cachedTime = "", 0;

        local host = "https://api.platoboost.app";
        local hostResponse = fRequest({
            Url = host .. "/public/connectivity",
            Method = "GET"
        });
        if hostResponse.StatusCode ~= 200 and hostResponse.StatusCode ~= 429 then
            host = "https://api.platoboost.net";
        end

        function cacheLink()
            if cachedTime + (10*60) < fOsTime() then
                local response = fRequest({
                    Url = host .. "/public/start",
                    Method = "POST",
                    Body = lEncode({
                        service = service,
                        identifier = lDigest(fGetHwid())
                    }),
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["User-Agent"] = "Roblox/Exploit"
                    }
                });

                if response.StatusCode == 200 then
                    local decoded = lDecode(response.Body);
                    if decoded.success == true then
                        cachedLink = decoded.data.url;
                        cachedTime = fOsTime();
                        return true, cachedLink;
                    else
                        onMessage(decoded.message);
                        return false, decoded.message;
                    end
                elseif response.StatusCode == 429 then
                    local msg = "you are being rate limited, please wait 20 seconds and try again.";
                    onMessage(msg);
                    return false, msg;
                end

                local msg = "Failed to cache link.";
                onMessage(msg);
                return false, msg;
            else
                return true, cachedLink;
            end
        end

        cacheLink();

        local generateNonce = function()
            local str = ""
            for _ = 1, 16 do
                str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
            end
            return str
        end

        for _ = 1, 5 do
            local oNonce = generateNonce();
            task.wait(0.2)
            if generateNonce() == oNonce then
                local msg = "platoboost nonce error.";
                onMessage(msg);
                error(msg);
            end
        end

        local copyLink = function()
            local success, link = cacheLink();
            if success then
                fSetClipboard(link);
            end
        end

        local redeemKey = function(key)
            local nonce = generateNonce();
            local endpoint = host .. "/public/redeem/" .. fToString(service);

            local body = {
                identifier = lDigest(fGetHwid()),
                key = key
            }

            if useNonce then
                body.nonce = nonce;
            end

            local response = fRequest({
                Url = endpoint,
                Method = "POST",
                Body = lEncode(body),
                Headers = {
                    ["Content-Type"] = "application/json"
                }
            });

            if response.StatusCode == 200 then
                local decoded = lDecode(response.Body);
                if decoded.success == true then
                    if decoded.data.valid == true then
                        if useNonce then
                            if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                                return true;
                            else
                                onMessage("failed to verify integrity.");
                                return false;
                            end
                        else
                            return true;
                        end
                    else
                        onMessage("key is invalid.");
                        return false;
                    end
                else
                    if fStringSub(decoded.message, 1, 27) == "unique constraint violation" then
                        onMessage("you already have an active key, please wait for it to expire before redeeming it.");
                        return false;
                    else
                        onMessage(decoded.message);
                        return false;
                    end
                end
            elseif response.StatusCode == 429 then
                onMessage("you are being rate limited, please wait 20 seconds and try again.");
                return false;
            else
                onMessage("server returned an invalid status code, please try again later.");
                return false;
            end
        end

        local verifyKey = function(key)
            if requestSending == true then
                return false, ("A request is already being sent, please slow down.");
            else
                requestSending = true;
            end

            local nonce = generateNonce();
            local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;

            if useNonce then
                endpoint = endpoint .. "&nonce=" .. nonce;
            end

            local response = fRequest({
                Url = endpoint,
                Method = "GET",
            });

            requestSending = false;

            if response.StatusCode == 200 then
                local decoded = lDecode(response.Body);

                if decoded.success == true then
                    if decoded.data.valid == true then
                        if useNonce then
                            if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                                return true, "";
                            else
                                return false, ("failed to verify integrity.");
                            end
                        else
                            return true;
                        end
                    else
                        if fStringSub(key, 1, 4) == "KEY_" then
                            return true, redeemKey(key);
                        else
                            return false, ("Key is invalid.");
                        end
                    end
                else
                    return false, (decoded.message);
                end
            elseif response.StatusCode == 429 then
                return false, ("You are being rate limited, please wait 20 seconds and try again.");
            else
                return false, ("Server returned an invalid status code, please try again later.");
            end
        end

        local getFlag = function(name)
            local nonce = generateNonce();
            local endpoint = host .. "/public/flag/" .. fToString(service) .. "?name=" .. name;

            if useNonce then
                endpoint = endpoint .. "&nonce=" .. nonce;
            end

            local response = fRequest({
                Url = endpoint,
                Method = "GET",
            });

            if response.StatusCode == 200 then
                local decoded = lDecode(response.Body);

                if decoded.success == true then
                    if useNonce then
                        if decoded.data.hash == lDigest(fToString(decoded.data.value) .. "-" .. nonce .. "-" .. secret) then
                            return decoded.data.value;
                        else
                            onMessage("failed to verify integrity.");
                            return nil;
                        end
                    else
                        return decoded.data.value;
                    end
                else
                    onMessage(decoded.message);
                    return nil;
                end
            else
                return nil;
            end
        end

        return {
            Verify = verifyKey,
            GetFlag = getFlag,
            Copy = copyLink,
        }
    end

    return Platoboost
end)()

local Config = {
    ServiceId = 30158,
    PlatoSecret = "42682fb8-db72-44fc-bde9-16a79cae123e",
    KeyFileName = "ElderwyrmHubXUniversal/key.txt",
}

local function safeRequest(options)
    local req = request or http_request or syn_request or (http and http.request)
    if not req then return nil, "HTTP requests not supported" end
    local success, response = pcall(function() return req(options) end)
    if success and type(response) == "table" then
        return response
    else
        return nil, "Connection Error: " .. tostring(response or "Unknown")
    end
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function MakeDraggable(topbarobject, object)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local function Update(input)
        local delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        Dragging = true
        DragStart = input.Position
        StartPosition = object.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://12221967"
    sound.Parent = game:GetService("SoundService")
    sound.Volume = 1
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function isKeylessDay()
    local wday = os.date("*t").wday
    return (wday == 1 or wday == 7)
end

local function getIP()
    local response = safeRequest({Url = "https://api.ipify.org", Method = "GET"})
    if response and response.StatusCode == 200 then
        return response.Body
    end
    return nil
end

local function getIPTime(ip)
    local url = "https://timeapi.io/api/v1/time/current/ip?ipAddress=" .. ip
    local response = safeRequest({Url = url, Method = "GET"})
    if response and response.StatusCode == 200 then
        local success, decoded = pcall(lDecode, response.Body)
        if success and decoded then
            return decoded
        end
    end
    return nil
end

local function parseDate(dateStr)
    local year, month, day = dateStr:match("(%d+)-(%d+)-(%d+)")
    if year and month and day then
        return tonumber(year), tonumber(month), tonumber(day)
    end
    return nil, nil, nil
end

local function getLocalDate()
    local t = os.date("*t")
    return t.year, t.month, t.day
end

local function buildKickInfo(ipYear, ipMonth, ipDay, timezone)
    local localYear, localMonth, localDay = getLocalDate()
    local monthName = os.date("%B", os.time{year=ipYear, month=ipMonth, day=1})
    local deviceType = (game:GetService("UserInputService").TouchEnabled and "Mobile") or "PC"

    local baseMessage = string.format(
        "It seems like your day is invalid and can't be established because your %s's date is incorrect. Make sure your %s's must be set to (Day, %s, %s, %s, in %s). Or Don't Use a VPN",
        deviceType, deviceType, ipDay, monthName, ipYear, timezone
    )

    local localUnix = os.time({year=localYear, month=localMonth, day=localDay})
    local ipUnix = os.time({year=ipYear, month=ipMonth, day=ipDay})
    local diffSeconds = localUnix - ipUnix
    local diffDays = math.abs(math.floor(diffSeconds / 86400))
    local clockStatus = diffSeconds < 0 and "Behind" or "Ahead"

    local clockMessage = string.format("Your clock is %d day(s) %s.", diffDays, clockStatus)
    local title = "🕒 Your clock is " .. clockStatus .. "!"

    return title, baseMessage .. "\n" .. clockMessage
end

local function customKick(title, message)
    warn(message)
    task.spawn(function()
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick(message)
        end)
        task.wait()
        pcall(function()
            local errorPrompt = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt
            errorPrompt.TitleFrame.ErrorTitle.Text = title
            errorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = message
        end)
    end)
end

local function CreateKeyUI(keylessActive, PB)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "ElderwyrmHubXKeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 0.7
    mainFrame.Parent = keyGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

    local gradient = Instance.new("UIGradient", mainFrame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    gradient.Rotation = 0
    task.spawn(function()
        while task.wait(0.03) do
            gradient.Rotation = (gradient.Rotation + 1) % 360
        end
    end)

    local uiStroke = Instance.new("UIStroke", mainFrame)
    uiStroke.Thickness = 3
    local colorA = Color3.fromRGB(80, 180, 255)
    local colorB = Color3.fromRGB(255, 255, 255)
    task.spawn(function()
        local t = 0
        local direction = 1
        while task.wait(0.03) do
            t += direction * 0.02
            if t >= 1 then
                t = 1
                direction = -1
            elseif t <= 0 then
                t = 0
                direction = 1
            end
            uiStroke.Color = colorA:Lerp(colorB, t)
        end
    end)

    local titleFrame = Instance.new("Frame", mainFrame)
    titleFrame.Size = UDim2.new(0.9, 0, 0.2, 0)
    titleFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    titleFrame.BackgroundTransparency = 1

    local titleLabel = Instance.new("TextLabel", titleFrame)
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Elderwyrm Hub X Key System"
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local inputBox = Instance.new("TextBox", mainFrame)
    inputBox.Size = UDim2.new(0.9, 0, 0.15, 0)
    inputBox.Position = UDim2.new(0.05, 0, 0.3, 0)
    inputBox.PlaceholderText = "Enter Key Here"
    inputBox.Text = ""
    inputBox.TextScaled = true
    inputBox.Font = Enum.Font.SourceSansBold
    inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.BackgroundTransparency = 0.7
    inputBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 13)

    local function createButton(parent, text, position)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.4, 0, 0.15, 0)
        btn.Position = position
        btn.Text = text
        btn.TextScaled = true
        btn.Font = Enum.Font.SourceSansBold
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.7
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 13)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 2
        task.spawn(function()
            local t = 0
            local direction = 1
            while task.wait(0.03) do
                t += direction * 0.02
                if t >= 1 then
                    t = 1
                    direction = -1
                elseif t <= 0 then
                    t = 0
                    direction = 1
                end
                stroke.Color = colorA:Lerp(colorB, t)
            end
        end)

        return btn
    end

    local submitBtn = createButton(mainFrame, keylessActive and "Press me :3" or "Submit", UDim2.new(0.05, 0, 0.55, 0))
    local getKeyBtn = createButton(mainFrame, keylessActive and "(Locked)" or "Get Key", UDim2.new(0.55, 0, 0.55, 0))

    MakeDraggable(mainFrame, mainFrame)

    local function attemptVerify(key)
        if not PB then
            submitBtn.Text = "Error"
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key System Status",
                    Text = "Platoboost not connected",
                    Duration = 5
                })
            end)
            task.wait(1.5)
            submitBtn.Text = "Submit"
            return
        end

        if key == "" or key == "Enter Key here" then
            submitBtn.Text = "Error"
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key System Status",
                    Text = "Key Invalid",
                    Duration = 5
                })
            end)
            task.wait(1.5)
            submitBtn.Text = "Submit"
            return
        end

        submitBtn.Text = "Checking..."
        task.spawn(function()
            local success, msg = PB.Verify(key)
            if success then
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Key System Status",
                        Text = "Welcome To the Elderwyrm Hub X",
                        Duration = 10
                    })
                end)
                loadscript()
                keyGui:Destroy()
            else
                submitBtn.Text = "Error"
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Key System Status",
                        Text = msg or "Key Invalid",
                        Duration = 5
                    })
                end)
                task.wait(1.5)
                submitBtn.Text = "Submit"
            end
        end)
    end

    local function keylessPressFlow()
        submitBtn.Text = "Checking..."
        local ip = getIP()
        if not ip then
            submitBtn.Text = "Error"
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key System Status",
                    Text = "Failed to get IP address",
                    Duration = 5
                })
            end)
            task.wait(1.5)
            submitBtn.Text = "Press me :3"
            return
        end

        local ipTime = getIPTime(ip)
        if not ipTime or not ipTime.date or not ipTime.day_of_week or not ipTime.timezone then
            submitBtn.Text = "Error"
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key System Status",
                    Text = "Failed to verify time",
                    Duration = 5
                })
            end)
            task.wait(1.5)
            submitBtn.Text = "Press me :3"
            return
        end

        local ipYear, ipMonth, ipDay = parseDate(ipTime.date)
        if not ipYear or not ipMonth or not ipDay then
            submitBtn.Text = "Error"
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key System Status",
                    Text = "Invalid date from server",
                    Duration = 5
                })
            end)
            task.wait(1.5)
            submitBtn.Text = "Press me :3"
            return
        end

        local localYear, localMonth, localDay = getLocalDate()
        local dateMatches = (localYear == ipYear and localMonth == ipMonth and localDay == ipDay)

        local keylessDays = {["Saturday"] = true, ["Sunday"] = true}

        if not keylessDays[ipTime.day_of_week] then
            if dateMatches then
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Key System Status",
                        Text = "Keyless mode is expired, Restarting Keysystem...",
                        Duration = 5
                    })
                end)
                keyGui:Destroy()
                if not PB then
                    pcall(function()
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Key System",
                            Text = "Connecting to Platoboost Service...",
                            Duration = 5
                        })
                    end)
                    PB = Platoboost.New(Config.ServiceId, Config.PlatoSecret)
                end
                CreateKeyUI(false, PB)
            else
                local title, msg = buildKickInfo(ipYear, ipMonth, ipDay, ipTime.timezone)
                customKick(title, msg)
            end
            return
        end

        if not dateMatches then
            local title, msg = buildKickInfo(ipYear, ipMonth, ipDay, ipTime.timezone)
            customKick(title, msg)
            return
        end

        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Key System Status",
                Text = "Keyless Mode",
                Duration = 10
            })
        end)
        loadscript()
        keyGui:Destroy()
    end

    submitBtn.MouseButton1Click:Connect(function()
        playClickSound()
        if keylessActive then
            keylessPressFlow()
        else
            attemptVerify(inputBox.Text)
        end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        playClickSound()
        if keylessActive then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key System Status",
                    Text = "Unable to Copy Key to clipboard While the keyless mode is active",
                    Duration = 5
                })
            end)
            return
        end
        if not PB then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key System Status",
                    Text = "Platoboost not connected",
                    Duration = 5
                })
            end)
            return
        end
        getKeyBtn.Text = "Loading"
        PB.Copy()
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Key System Status",
                Text = "Key Link Copied to clipboard",
                Duration = 5
            })
        end)
        task.wait(0.8)
        getKeyBtn.Text = "Get Key"
    end)

    if not keylessActive and readfile and isfile and isfile(Config.KeyFileName) then
        local savedKey = readfile(Config.KeyFileName)
        if savedKey ~= "" then
            inputBox.Text = savedKey
            attemptVerify(savedKey)
        end
    end

    return keyGui
end

local initialKeyless = isKeylessDay()
local initialPB = nil
if not initialKeyless then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Key System",
            Text = "Connecting to Platoboost Service...",
            Duration = 5
        })
    end)
    initialPB = Platoboost.New(Config.ServiceId, Config.PlatoSecret)
end

CreateKeyUI(initialKeyless, initialPB)

---------------------------------------------------------------------------------------------------------------------------------------------





















function loadscript()
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vraigos/Fluent-Moded/refs/heads/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vraigos/Fluent-Moded/refs/heads/main/SaveManager.lua"))()
local FBM = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vraigos/Fluent-Moded/refs/heads/main/FloatingButton.Lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vraigos/Fluent-Moded/refs/heads/main/InterfaceManager.lua"))()

if not Fluent or not SaveManager or not InterfaceManager or not FBM then
    return game.Players.LocalPlayer:Kick("Error: Interface didn't load")
end

if _G.ElderwyrmHubXIsAlreadyRunning then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script is already running!",
        Text = ""
    })
    return
end

_G.ElderwyrmHubXIsAlreadyRunning = true

getgenv().ButtonGradients = getgenv().ButtonGradients or {
    Background = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
    }),
    Stroke = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 255))
    })
}

local Window = Fluent:CreateWindow({
    Title = "Elderwyrm Hub X - Evade Overhaul",
    SubTitle = "V2.9.2 Made by Vraigos and Aerave",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Azure",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://7733960981" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farms", Icon = "rbxassetid://10709811110" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "rbxassetid://10734975692" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://7734068321" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "rbxassetid://10709819149" }),
    Info = Window:AddTab({ Title = "Info", Icon = "rbxassetid://10723415903" }),
    Settings = Window:AddTab({ Title = "Configuration", Icon = "rbxassetid://7734052335" }),
    Extension = Window:AddTab({ Title = "Extension", Icon = "rbxassetid://10734930886" })
}

local Options = Fluent.Options

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local CAS = game:GetService("ContextActionService")

local CharacterService = require(ReplicatedStorage:WaitForChild("Services"):WaitForChild("Asset"):WaitForChild("CharacterService"))
local ServerStateRegistryService = require(ReplicatedStorage:WaitForChild("Services"):WaitForChild("Data"):WaitForChild("ServerStateRegistryService"))
local ItemRegistry = require(ReplicatedStorage:WaitForChild("Items"):WaitForChild("Registry"))
local MovementModule = require(ReplicatedStorage.Objects.Game.Character.Client.Movement)
local ClientItemService = require(ReplicatedStorage.Services.Items.ClientItemService)
local EmoteClass = require(ReplicatedStorage.Objects.Items.Emote)
local CameraService = require(ReplicatedStorage.Services.Client.CameraService)
local playerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
local controlModule = require(playerModule:WaitForChild("ControlModule"))


local function GetAutoDuration()
    local dt = RunService.RenderStepped:Wait()
    local fps = 1 / dt
    local duration = 60 / math.clamp(fps, 5, 60)
    return math.clamp(duration, 1, 6)
end

local Duration = GetAutoDuration()

local openshit = Instance.new("ScreenGui")
openshit.Name = "openshit"
openshit.Parent = LocalPlayer.PlayerGui
openshit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
openshit.ResetOnSpawn = false

local mainopen = Instance.new("TextButton")
mainopen.Name = "mainopen"
mainopen.Parent = openshit
mainopen.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainopen.BackgroundTransparency = 1
mainopen.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
mainopen.Size = UDim2.new(0, 64, 0, 42)
mainopen.Text = ""
mainopen.Visible = true

local mainopens = Instance.new("UICorner")
mainopens.Parent = mainopen

local SizeBackMulti = 0.1

local function DownloadAsset(url, filename)
    local request = http_request or (syn and syn.request) or request
    if not request then return nil end
    local ok, response = pcall(function()
        return request({ Url = url, Method = "GET" }).Body
    end)
    if not ok or not response then return nil end
    writefile(filename, response)
    return getcustomasset(filename)
end

local AssetsIcon = DownloadAsset(
    "https://raw.githubusercontent.com/Vraigos/Elderwyrm-Hub-X/03664e8f5718dcf889a6827c5613d51685c98151/images/AssetsIcon.png",
    "AssetsIcon.png"
) or ""

local AssetsBackground = DownloadAsset(
    "https://raw.githubusercontent.com/Vraigos/Elderwyrm-Hub-X/03664e8f5718dcf889a6827c5613d51685c98151/images/AssetsBackground.png",
    "AssetsBackground.png"
) or ""

local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "RotatingBackground"
backgroundImage.Parent = mainopen
backgroundImage.Size = UDim2.new(1.8 + SizeBackMulti, 0, 1.8 + SizeBackMulti, 0)
backgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
backgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = AssetsBackground
backgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
backgroundImage.ZIndex = 0

local WIDTH = 0.85
local HEIGHT = 1

local frontImage = Instance.new("ImageLabel")
frontImage.Name = "StaticIcon"
frontImage.Parent = mainopen
frontImage.Size = UDim2.new(WIDTH, 0, HEIGHT, 0)
frontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
frontImage.AnchorPoint = Vector2.new(0.5, 0.5)
frontImage.BackgroundTransparency = 1
frontImage.Image = AssetsIcon
frontImage.ZIndex = 1
frontImage.ScaleType = Enum.ScaleType.Stretch

local frontCorner = Instance.new("UICorner")
frontCorner.CornerRadius = UDim.new(1, 0)
frontCorner.Parent = frontImage

local rotation = 0
local speed = 90
local lastTime = tick()

task.spawn(function()
    while true do
        local now = tick()
        local delta = now - lastTime
        lastTime = now
        rotation = (rotation + speed * delta) % 360
        backgroundImage.Rotation = rotation
        task.wait()
    end
end)

local function MakeDraggable(topbarobject, object, locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    object:SetAttribute("Locked", locked or false)

    local function Update(input)
        if object:GetAttribute("Locked") then return end
        local delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end

    local function ToggleLock()
        local newState = not object:GetAttribute("Locked")
        object:SetAttribute("Locked", newState)
        Fluent:Notify({
            Title = newState and "Button Locked" or "Button Unlocked",
            Content = newState and "This button is now locked in place." or "This button can now be moved.",
            Duration = 2
        })
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        Dragging = not object:GetAttribute("Locked")
        Holding = true
        DragStart = input.Position
        StartPosition = object.Position

        HoldToken += 1
        local token = HoldToken

        task.delay(HoldTime, function()
            if Holding and token == HoldToken then
                ToggleLock()
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    topbarobject.InputChanged:Connect(function(input)
        if not DragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            if (input.Position - DragStart).Magnitude > MoveCancelThreshold then
                Holding = false
            end
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

MakeDraggable(mainopen, mainopen, false)

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

mainopen.MouseButton1Click:Connect(function()
    local sounds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    playSound(sounds[math.random(#sounds)])
    Window:Minimize()

    local function smoothSpeed(target, duration)
        local start = speed
        local steps = 30
        for i = 1, steps do
            speed = start + (target - start) * (i / steps)
            task.wait(duration / steps)
        end
        speed = target
    end

    smoothSpeed(360, 0.4)
    task.wait(0.5)
    smoothSpeed(180, 0.4)
    task.wait(0.3)
    smoothSpeed(90, 0.4)
end)

local Stats = game:GetService("Stats")

local fpsCounter = Instance.new("ScreenGui")
fpsCounter.Name = "FPSCounter"
fpsCounter.Parent = game.CoreGui
fpsCounter.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fpsCounter.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = fpsCounter
frame.Size = UDim2.new(0, 180, 0, 80)
frame.Position = UDim2.new(0, 300, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.7

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient.Parent = frame

task.spawn(function()
    while task.wait(0.03) do
        gradient.Rotation = (gradient.Rotation + 1) % 360
    end
end)

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(80, 180, 255)
uiStroke.Parent = frame

task.spawn(function()
    local a = Color3.fromRGB(80, 180, 255)
    local b = Color3.fromRGB(255, 255, 255)
    local t, d = 0, 1
    while task.wait(0.03) do
        t += 0.02 * d
        if t >= 1 then t, d = 1, -1 elseif t <= 0 then t, d = 0, 1 end
        uiStroke.Color = a:Lerp(b, t)
    end
end)

local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, -10, 1, -10)
label.Position = UDim2.new(0, 5, 0, 5)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBlack
label.TextSize = 10
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.Text = "FPS: 0 | Ping: 0 ms\nClient Timer: 0h 0m 0s"

MakeDraggable(frame, frame, false)

local function GetPing()
    local n = Stats:FindFirstChild("Network")
    if not n then return 0 end
    local s = n:FindFirstChild("ServerStatsItem")
    if not s then return 0 end
    local p = s:FindFirstChild("Data Ping")
    if not p then return 0 end
    return math.floor(p:GetValue())
end

local startTime = tick()
local lastUpdateTime = startTime
local frameCount = 0
local previousText = ""

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    local dt = now - lastUpdateTime

    if dt >= 1 then
        local fps = math.round(frameCount / dt)
        local elapsed = now - startTime
        local h = math.floor(elapsed / 3600)
        local m = math.floor((elapsed % 3600) / 60)
        local s = math.floor(elapsed % 60)
        local ping = GetPing()

        local text = string.format(
            "FPS: %d | Ping: %d ms\nClient Timer: %dh %dm %ds",
            fps, ping, h, m, s
        )

        if text ~= previousText then
            label.Text = text
            previousText = text
        end

        lastUpdateTime = now
        frameCount = 0
    end
end)

if require then
    print("Supported require()")
end
if firetouchinterest then
    print("Supported firetouchinterest()")
end
if game.Players then
    print("Advance Api")
else
    print("Common Api")
end

local DFunctions = {}
local DConfiguration = {
    ESP = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Tracers = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Highlight = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
        OutlineOnly = false,
    },
    Boxes = {
        Players = false,
        Nextbots = false,
        Tickets = false,
        Objective = false,
    },
    Removals = {
        CameraShake = false,
        Vignette = false,
        InvisibleWalls = false,
        ReducingRewards = false,
    },
    Main = {
        AntiAFK = true,
        AutoRespawn = false,
        RespawnType = "Spawnpoint",
        AutoWhistle = false,
        ShowTimer = false,
        Fly = false,
        FlySpeed = 1,
        isFlyFloating = false,
        FlyoriginalUpdate = false,
        Noclip = false,
    },
    Battlepass = {
        BypassTimer = false,
    },
    AutoFarm = {
        FarmingStates = {
            IsReviving = false,
            IsCompletingObjective = false,
            IsCollectingTickets = false,
            IsCatchingNPC = false,
        },
        AFKFarm = false,
        FarmTickets = false,
        CompleteObjective = false,
        FarmTokens = false,
        VIPAutomations = {
            AutoVote = false,
            MapSection = 1,
            GamemodeSection = 1,
            AutoMap = false,
            MapInput = "DesertBus",
            AutoSpecialRound = false,
            SpecialRoundInput = "Plushie Hell",
            AutoTimer = false,
            TimerInput = "",
            TimerRoundState = 1,
            AutoProMode = false,
            LastMapSet = 0,
            LastSRSet = 0,
            LastTimerSet = 0,
            LastVotingFire = 0,
        },
        PurchaseAutomations = {
            Enabled = false,
            Selected = "Cola",
            Amount = 1,
            Connection = nil,
            LastBuy = 0,
        },
    },
    Combat = {
        AntiNextbot = false,
        AntiNextbotRange = 15,
        AntiNextbotType = "Spawn",
    },
    Misc = {
        PlayerAdjustment = {
            Default = {
                Friction = 5,
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                AirStrafeAcceleration = 182,
                AirAcceleration = 1,
                JumpSpeedMultiplier = 1.45,
                BhopEnabled = false
            },
            Update = {
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                JumpAcceleration = 1.5,
                AirStrafe = 182,
                GroundAcceleration = 5,
                BHOPEnabled = false,
            },
            Saved = {
                Speed = 1500,
                JumpHeight = 3,
                JumpCap = 1,
                JumpAcceleration = 1.5,
                AirStrafe = 182,
                GroundAcceleration = 5,
            },
            Tick = {
                Speed = 0,
                JumpHeight = 0,
                JumpCap = 0,
                JumpAcceleration = 0,
                AirStrafe = 0,
                GroundAcceleration = 0,
                BHOPEnabled = 0,
            },
            Debounce = {
                Speed = false,
                JumpHeight = false,
                JumpCap = false,
                JumpAcceleration = false,
                AirStrafe = false,
                GroundAcceleration = false,
                BHOPEnabled = false,
            },
        },
        Humanoids = {
            WalkspeedCF = false,
            OriginalJumpHeight = false,
            CF = 5,
            JP = 20,
        },
        Utilities = {
            GetCurrentSpeed = 0,
            BounceModification = {
                Enabled = false,
                DefaultBounce = 80,
                EmoteBounce = 120,
                SuperBounce = false,
                SuperBounceStrength = -50,
            },
            EdgeTrimpModification = {
                Enabled = false,
                HeightMultiplier = 1.5,
                DownThreshold = 4.5
            },
            LagSwitch = {
                MSDelay = 200,
                Mode = "Normal",
            },
        },
        CameraAdjustment = {
            StretchX = 1,
            StretchY = 1,
        },
        GunAdjustment = {
            v = nil,
        },
        GameAutomation = {
            Revive = {
                Enabled = false,
                FloatingButton = false,
                Keybind = false,
                WhileEmote = false,
                Delay = 0.1,
            },
            Carry = {
                Enabled = false,
                FloatingButton = false,
                Keybind = false,
                WhileEmote = false,
                lastAttempt = 0,
                Cooldown = 0.5,
                Connection = nil,
            },
            Macro = {
                SelectedEmote = "BoldMarch",
                FloatingButton = false,
                Keybind = false,
            },
        },
        MovementModification = {
            AggressiveEmoteDash = {
                Enabled = false,
                Type = "Blatant",
                Speed = 3000,
                Acceleration = -2,
            },
            SlideModification = {
                FloatingButton = false,
                Enabled = false,
                Acceleration = -3,
            },
            Gravity = {
                FloatingButton = false,
                Keybind = false,
                Value = 10,
            },
            BHOP = {
                Enabled = false,
                Keybind = false,
                HoldKeybind = false,
                FloatingButton = false,
                JumpButton = false,
                HipHeight1 = 0,
                HipHeight2 = 0,
                lastTick = 0.01,
                lastFriction = nil,
                Settings = {
                    AutoAcceleration = {
                        Enabled = false,
                        MaxAccelerate = 3,
                        MinAccelerate = -1,
                        MinSpeed = 70
                    },
                    SpiderHop = false,
                    Backwards = false,
                    Type = "Acceleration",
                    JumpType = "Simulation",
                    Acceleration = -0.1,
                },
            },
            Crouch = {
                FloatingButton = false,
                Keybind = false,
                Type = "Rapid",
                isHolding = false,
                debounce = 0.1,
                lastTick = 0.1,
                lastReleaseTick = 0.1,
            },
        },
    },
    Visual = {
        OriginalCosmetics = {
            Cosmetics1 = "",
            Cosmetics2 = "",
            Cosmetics3 = "",
            Cosmetics4 = "",
        },
        ModifyCosmetics = {
            Cosmetics1 = "",
            Cosmetics2 = "",
            Cosmetics3 = "",
            Cosmetics4 = "",
        },
        OriginalEmotes = {
            Emote1 = "",
            Emote2 = "",
            Emote3 = "",
            Emote4 = "",
            Emote5 = "",
            Emote6 = "",
            Emote7 = "",
            Emote8 = "",
            Emote9 = "",
            Emote10 = "",
            Emote11 = "",
            Emote12 = "",
        },
        ModifyEmotes = {
            Emote1 = "",
            Emote2 = "",
            Emote3 = "",
            Emote4 = "",
            Emote5 = "",
            Emote6 = "",
            Emote7 = "",
            Emote8 = "",
            Emote9 = "",
            Emote10 = "",
            Emote11 = "",
            Emote12 = "",
        },
        CosSwaps = {},
        CurrentEmotes = {},
        SelectEmotes = {},
        EmoteReplacements = {},
    },
    Settings = {
        GuiScale = {
            Respawn = 0,
            SuperBounce = 0,
            AutoCarry = 0,
            AutoEmoteDash = 0,
            Gravity = 0,
            InfiniteSlide = 0,
            AutoJump = 0,
            AutoCrouch = 0,
            LagSwitch = 0,
        },
    },
    SelfRevive = {
        Method = "Spawnpoint",
        Enabled = false,
        HasRevived = false,
        LastSavedPosition = nil,
        IsProcessing = false,
        LastRespawnTime = 0,
        Connections = {
            Heartbeat = nil,
            Character = nil,
        }
    },
    TokenFarm = {
        Enabled = false,
        ReviveTarget = nil,
        FireCount = 0,
        LastReviveFire = 0,
        TokenDelay = 2,
        TokenOffset = Vector3.new(0, -8, 0),
        Connection = nil,
    },
    TimerDisplay = {
        Enabled = false,
        SpecialRoundEnabled = false,
        TimerGui = nil,
        SpecialGui = nil,
        TimerConn = nil,
        SpecialConn = nil,
    },
}

function CreateBillboardESP(Name, Part, Color, TextSize)
    if not Part or Part:FindFirstChild(Name) then return nil end
    local BillboardGui = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")
    local TextStroke = Instance.new("UIStroke")
    BillboardGui.Parent = Part
    BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BillboardGui.Name = Name
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    BillboardGui.MaxDistance = 1000
    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextSize = TextSize or 14
    TextLabel.TextColor3 = Color or Color3.fromRGB(255, 255, 255)
    TextStroke.Parent = TextLabel
    TextStroke.Thickness = 1
    TextStroke.Color = Color3.new(0, 0, 0)
    return BillboardGui
end

function UpdateBillboardESP(Name, Part, NameText, Color, TextSize, CamPos)
    if not Part then return false end
    local esp = Part:FindFirstChild(Name)
    if esp and esp:FindFirstChildOfClass("TextLabel") then
        local label = esp:FindFirstChildOfClass("TextLabel")
        if Color then label.TextColor3 = Color end
        if TextSize then label.TextSize = TextSize end
        if CamPos then
            local distance = math.floor((CamPos - Part.Position).Magnitude)
            label.Text = string.format("%s - [ %d M ]", NameText or Part.Name, distance)
        else
            label.Text = NameText or Part.Name
        end
        return true
    end
    return false
end

function DestroyBillboardESP(Name, Part)
    if not Part then return false end
    local esp = Part:FindFirstChild(Name)
    if esp then esp:Destroy() return true end
    return false
end

function CreateTracerESP(tracerTable, part, thickness, color)
    local tracer = Drawing.new("Line")
    tracer.Thickness = thickness or 2
    tracer.Color = color or Color3.fromRGB(255, 255, 255)
    tracer.Transparency = 1
    tracer.Visible = false
    tracerTable[part] = tracer
    return tracer
end

function UpdateTracerESP(tracerTable, part, color)
    local tracer = tracerTable[part]
    if not tracer then return end
    if typeof(part) ~= "Instance" or not part.Parent or not part:IsDescendantOf(workspace) then
        tracer.Visible = false
        pcall(function()
            if tracer.Remove then tracer:Remove()
            elseif tracer.Destroy then tracer:Destroy() end
        end)
        tracerTable[part] = nil
        return
    end
    local ok, screenPos, onScreen = pcall(function()
        return workspace.CurrentCamera:WorldToViewportPoint(part.Position)
    end)
    if not ok or not onScreen then
        tracer.Visible = false
        return
    end
    if color then tracer.Color = color end
    tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
    tracer.Visible = true
end

function DestroyTracerESP(tracerTable, part)
    local tracer = tracerTable[part]
    if tracer then
        pcall(function()
            if tracer.Remove then tracer:Remove()
            elseif tracer.Destroy then tracer:Destroy() end
        end)
        tracerTable[part] = nil
    end
end

function CleanupTracers(tracerTable)
    for part, tracer in pairs(tracerTable) do
        if typeof(part) ~= "Instance" or not part.Parent or not part:IsDescendantOf(workspace) then
            pcall(function()
                if tracer.Remove then tracer:Remove()
                elseif tracer.Destroy then tracer:Destroy() end
            end)
            tracerTable[part] = nil
        end
    end
end

function CreateHighlightESP(Name, Part, HighlightColor, OutlineColor, OutlineOnly)
    if not Part or Part:FindFirstChild(Name) then return false end
    local Highlight = Instance.new("Highlight")
    Highlight.Name = Name
    Highlight.FillColor = HighlightColor or Color3.fromRGB(255, 255, 255)
    Highlight.OutlineColor = OutlineColor or Color3.fromRGB(0, 0, 0)
    Highlight.FillTransparency = OutlineOnly and 1 or 0.5
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Part
    return true
end

function UpdateHighlightESP(Name, Part, HighlightColor, OutlineColor, OutlineOnly)
    local Highlight = Part and Part:FindFirstChild(Name)
    if not Highlight or not Highlight:IsA("Highlight") then return false end
    if HighlightColor then Highlight.FillColor = HighlightColor end
    if OutlineColor then Highlight.OutlineColor = OutlineColor end
    if OutlineOnly ~= nil then Highlight.FillTransparency = OutlineOnly and 1 or 0.5 end
    return true
end

function DestroyHighlightESP(Name, Part)
    local Highlight = Part and Part:FindFirstChild(Name)
    if Highlight and Highlight:IsA("Highlight") then
        Highlight:Destroy()
        return true
    end
    return false
end

function DFunctions.CreateButton(ButtonName, Name, Size1, Size2, ScriptLogic, CircleMode)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = ButtonName
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Name = ButtonName
    frame.Size = UDim2.new(Size1, 0, Size2, 0)
    frame.Position = UDim2.new(0.5 - Size1 / 2, 0, 0.5 - Size2 / 2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.7
    frame.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = getgenv().ButtonGradients.Background
    gradient.Parent = frame

    task.spawn(function()
        while task.wait(0.03) do
            gradient.Rotation = (gradient.Rotation + 1) % 360
            gradient.Color = getgenv().ButtonGradients.Background
        end
    end)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = frame

    local gradientstroke = Instance.new("UIGradient")
    gradientstroke.Color = getgenv().ButtonGradients.Stroke
    gradientstroke.Rotation = 0
    gradientstroke.Parent = stroke

    task.spawn(function()
        while frame.Parent do
            gradientstroke.Rotation = (gradientstroke.Rotation + 0.5) % 360
            gradientstroke.Color = getgenv().ButtonGradients.Stroke
            task.wait()
        end
    end)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = Name
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.TextScaled = false
    button.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 28, 0, 28)
    toggle.Position = UDim2.new(1, 6, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Text = "○"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Visible = false
    toggle.Parent = frame

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggle

    local originalSize = UDim2.new(Size1, 0, Size2, 0)
    local holding = false
    local holdStart = 0
    local hideAt = 0

    frame:SetAttribute("IsCircle", false)

    local isCircle = CircleMode ~= nil and CircleMode or frame:GetAttribute("IsCircle")

    local function applyShape(circle)
        frame:SetAttribute("IsCircle", circle)
        local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
        if circle then
            frame.Size = UDim2.new(0, s, 0, s)
            button.TextWrapped = true
            button.TextScaled = true
            button.TextSize = math.floor(s * 0.45)
            corner.CornerRadius = UDim.new(1, 0)
            toggle.Text = "▢"
        else
            frame.Size = originalSize
            button.TextWrapped = false
            button.TextScaled = false
            button.TextSize = 24
            corner.CornerRadius = UDim.new(0, 15)
            toggle.Text = "○"
        end
    end

    applyShape(isCircle)

    task.spawn(function()
        while task.wait(0.25) do
            if toggle.Visible and tick() - hideAt >= 10 then
                toggle.Visible = false
            end
        end
    end)

    button.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            holding = true
            holdStart = tick()
        end
    end)

    button.InputEnded:Connect(function(i)
        if holding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            holding = false
            if tick() - holdStart >= 0.6 then
                toggle.Visible = true
                hideAt = tick()
            end
        end
    end)

    toggle.MouseButton1Click:Connect(function()
        hideAt = tick()
        local current = frame:GetAttribute("IsCircle")
        applyShape(not current)
    end)

    button.Activated:Connect(function()
        if ScriptLogic then
            ScriptLogic(button)
        end
    end)

    FBM:AddButton(ButtonName, frame, false)
    MakeDraggable(button, frame, false)

    return button
end

function DFunctions.UpdateButton(Name, Size1, Size2)
    local gui = LocalPlayer.PlayerGui:FindFirstChild(Name)
    if gui then
        local frame = gui:FindFirstChild(Name)
        if frame then
            frame.Size = UDim2.new(Size1, 0, Size2, 0)
            local isCircle = frame:GetAttribute("IsCircle")
            if isCircle then
                local s = math.min(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
                frame.Size = UDim2.new(0, s, 0, s)
            end
        end
    end
end

function DFunctions.DestroyButton(Name)
    local gui = LocalPlayer.PlayerGui:FindFirstChild(Name)
    if gui then
        gui:Destroy()
    end
end

local changePlayerMode = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetPlayerMode")


function DFunctions.SelfReviveRespawn()
    local SelfRevive = DConfiguration.SelfRevive
    local now = tick()
    if now - SelfRevive.LastRespawnTime < 0.5 then return end
    SelfRevive.LastRespawnTime = now
    if SelfRevive.IsProcessing then return end

    local char = LocalPlayer.Character
    if not char then return end

    local isDowned = false
    if CharacterService then
        local ok, charData = pcall(function() return CharacterService:GetCharacterFromPlayer(LocalPlayer) end)
        if ok and charData and charData.DataRegistry and charData.DataRegistry:Get("Downed") then
            isDowned = true
        end
    end
    if not isDowned then return end

    SelfRevive.IsProcessing = true
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if SelfRevive.Method == "Spawnpoint" then
        if not SelfRevive.HasRevived then
            SelfRevive.HasRevived = true
            pcall(function()
                if changePlayerMode then changePlayerMode:FireServer(true) end
            end)
            SelfRevive.IsProcessing = false
            task.delay(10, function()
                SelfRevive.HasRevived = false
            end)
        else
            SelfRevive.IsProcessing = false
        end
    elseif SelfRevive.Method == "Fake Revive" then
        local savedPos = nil
        if hrp then savedPos = hrp.CFrame.Position end
        task.spawn(function()
            pcall(function()
                if changePlayerMode then changePlayerMode:FireServer(true) end
            end)
            local newCharacter
            repeat
                newCharacter = LocalPlayer.Character
                task.wait()
            until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= char
            if newCharacter then
                local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
                if savedPos and newHRP then
                    task.wait(0.1)
                    newHRP.CFrame = CFrame.new(savedPos)
                end
            end
            SelfRevive.IsProcessing = false
        end)
    else
        SelfRevive.IsProcessing = false
    end
end

function DFunctions.StartSelfRevive()
    local SelfRevive = DConfiguration.SelfRevive
    if SelfRevive.Connections.Heartbeat then return end
    SelfRevive.Enabled = true

    SelfRevive.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        if not SelfRevive.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        if not CharacterService then return end
        local ok, charData = pcall(function() return CharacterService:GetCharacterFromPlayer(LocalPlayer) end)
        if ok and charData and charData.DataRegistry and charData.DataRegistry:Get("Downed") then
            DFunctions.SelfReviveRespawn()
        end
    end)

    SelfRevive.Connections.Character = LocalPlayer.CharacterAdded:Connect(function()
        SelfRevive.HasRevived = false
        SelfRevive.IsProcessing = false
        SelfRevive.LastSavedPosition = nil
    end)
end

function DFunctions.StopSelfRevive()
    local SelfRevive = DConfiguration.SelfRevive
    SelfRevive.Enabled = false
    SelfRevive.HasRevived = false
    SelfRevive.IsProcessing = false
    SelfRevive.LastSavedPosition = nil
    for name, conn in pairs(SelfRevive.Connections) do
        if conn then
            conn:Disconnect()
            SelfRevive.Connections[name] = nil
        end
    end
end

function DFunctions.AutoRespawn()
    DFunctions.SelfReviveRespawn()
end

function DFunctions.IsTokenFarmLocalPlayerModel(model)
    if not model then return true end
    if model == LocalPlayer.Character then return true end
    if model.Name == LocalPlayer.Name then return true end
    if model.Name == tostring(LocalPlayer.UserId) then return true end
    local attrName = model:GetAttribute("Name")
    if attrName == LocalPlayer.Name or attrName == LocalPlayer.DisplayName then return true end
    local attrTag = model:GetAttribute("Tag")
    if attrTag == LocalPlayer.Name or attrTag == LocalPlayer.DisplayName then return true end
    local userId = model:GetAttribute("UserId") or model:GetAttribute("PlayerUserId")
    if typeof(userId) == "number" and userId == LocalPlayer.UserId then return true end
    return false
end

function DFunctions.IsValidTokenFarmTarget(model)
    if not model or not model.Parent or not model:IsA("Model") then return false end
    if model.Parent.Name ~= "Players" then return false end
    if DFunctions.IsTokenFarmLocalPlayerModel(model) then return false end
    if not model:FindFirstChild("HumanoidRootPart") then return false end
    if model:GetAttribute("Tag") == nil then return false end
    return true
end

function DFunctions.PickRandomTokenFarmTarget()
    local playersFolder = workspace:FindFirstChild("Players")
    if not playersFolder then return nil end
    local valid = {}
    for _, model in ipairs(playersFolder:GetChildren()) do
        if DFunctions.IsValidTokenFarmTarget(model) then
            table.insert(valid, model)
        end
    end
    if #valid == 0 then return nil end
    return valid[math.random(1, #valid)]
end

function DFunctions.StartGodMode()
    local TF = DConfiguration.TokenFarm
    if TF.Connection then return end
    TF.Enabled = true
    TF.Connection = RunService.Heartbeat:Connect(function()
        if not TF.Enabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not DFunctions.IsValidTokenFarmTarget(TF.ReviveTarget) then
            TF.ReviveTarget = DFunctions.PickRandomTokenFarmTarget()
        end
        local target = TF.ReviveTarget
        if not target then return end
        local targetHrp = target:FindFirstChild("HumanoidRootPart")
        if not targetHrp then return end
        hrp.CFrame = targetHrp.CFrame + TF.TokenOffset
        local tag = target:GetAttribute("Tag")
        if not tag then return end
        local now = tick()
        if now - TF.LastReviveFire >= (TF.TokenDelay or 2) then
            TF.LastReviveFire = now
            pcall(function()
                ReplicatedStorage.Events.Interact:FireServer("Revive", tag)
                ReplicatedStorage.Events.Interact:FireServer("Revive", tag, true)
            end)
        end
    end)
end

function DFunctions.StopGodMode()
    local TF = DConfiguration.TokenFarm
    TF.Enabled = false
    if TF.Connection then
        TF.Connection:Disconnect()
        TF.Connection = nil
    end
    TF.ReviveTarget = nil
    TF.FireCount = 0
    TF.LastReviveFire = 0
end
function DFunctions.DisableTouch() end


function DFunctions.CreateTimer()
    local TD = DConfiguration.TimerDisplay
    if LocalPlayer.PlayerGui:FindFirstChild("TimerGui") then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.Name = "TimerGui"

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Parent = screenGui
    timerLabel.Size = UDim2.new(0, 200, 0, 50)
    timerLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.SourceSans
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.Text = "0:00"
    timerLabel.Name = "TimerLabel"

    TD.TimerGui = screenGui
    TD.Enabled = true

    if TD.TimerConn then TD.TimerConn:Disconnect() end
    TD.TimerConn = RunService.Heartbeat:Connect(function()
        if not TD.Enabled then return end
        local seconds = nil
        if ServerStateRegistryService and ServerStateRegistryService.Registry then
            seconds = ServerStateRegistryService.Registry.Time
        end
        if type(seconds) == "number" and seconds >= 0 and seconds ~= -1 then
            local m = math.floor(seconds / 60)
            local s = math.floor(seconds % 60)
            timerLabel.Text = string.format("%d:%02d", m, s)
        else
            timerLabel.Text = "--:--"
        end
    end)
end

function DFunctions.RemoveTimer()
    local TD = DConfiguration.TimerDisplay
    TD.Enabled = false
    if TD.TimerConn then
        TD.TimerConn:Disconnect()
        TD.TimerConn = nil
    end
    if LocalPlayer.PlayerGui:FindFirstChild("TimerGui") then
        LocalPlayer.PlayerGui.TimerGui:Destroy()
    end
    TD.TimerGui = nil
end

function DFunctions.CreateSpecialRoundDisplay()
    local TD = DConfiguration.TimerDisplay
    if LocalPlayer.PlayerGui:FindFirstChild("SpecialRoundGui") then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.Name = "SpecialRoundGui"

    local specialLabel = Instance.new("TextLabel")
    specialLabel.Parent = screenGui
    specialLabel.Size = UDim2.new(0, 300, 0, 40)
    specialLabel.Position = UDim2.new(0.5, -150, 0.16, 0)
    specialLabel.BackgroundTransparency = 1
    specialLabel.TextScaled = true
    specialLabel.Font = Enum.Font.SourceSans
    specialLabel.TextColor3 = Color3.new(1, 1, 1)
    specialLabel.Text = ""
    specialLabel.Name = "SpecialRoundLabel"

    TD.SpecialGui = screenGui
    TD.SpecialRoundEnabled = true

    if TD.SpecialConn then TD.SpecialConn:Disconnect() end
    TD.SpecialConn = RunService.Heartbeat:Connect(function()
        if not TD.SpecialRoundEnabled then return end
        local special = nil
        if ServerStateRegistryService and ServerStateRegistryService.Registry then
            special = ServerStateRegistryService.Registry.SpecialRound
        end
        if special and special ~= false and special ~= "" then
            local title = tostring(special)
            pcall(function()
                local folder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
                if folder then
                    local mod = folder:FindFirstChild(tostring(special))
                    if mod then
                        local ok, data = pcall(require, mod)
                        if ok and data and data.Title then title = data.Title end
                    end
                end
            end)
            specialLabel.Text = title
        else
            specialLabel.Text = ""
        end
    end)
end

function DFunctions.RemoveSpecialRoundDisplay()
    local TD = DConfiguration.TimerDisplay
    TD.SpecialRoundEnabled = false
    if TD.SpecialConn then
        TD.SpecialConn:Disconnect()
        TD.SpecialConn = nil
    end
    if LocalPlayer.PlayerGui:FindFirstChild("SpecialRoundGui") then
        LocalPlayer.PlayerGui.SpecialRoundGui:Destroy()
    end
    TD.SpecialGui = nil
end
function DFunctions.RemoveReduceRewards() end
function DFunctions.DisableInvisParts(state)
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    local invis = map:FindFirstChild("InvisParts") or map:FindFirstChild("MapLogic")
    if not invis then return end
    for _, v in pairs(invis:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = state
        end
    end
end

function DFunctions.DisableCameraShake() end
function DFunctions.DisableVignette() end

function DFunctions.GetDownedPlayer()
    local folder = workspace:FindFirstChild("Players")
    if not folder then return nil end
    for _, v in pairs(folder:GetChildren()) do
        if v:GetAttribute("Downed") and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    return nil
end

function DFunctions.GetEventNPC() return nil end
function DFunctions.TPEventNPC() end

function DFunctions.GetObjective()
    local objectives = {}
    local map = workspace:FindFirstChild("Map")
    if not map then
        local gameFolder = workspace:FindFirstChild("Game")
        map = gameFolder and gameFolder:FindFirstChild("Map")
    end
    if not map then return objectives end
    local parts = map:FindFirstChild("Parts") or map:FindFirstChild("MapLogic")
    if not parts then return objectives end
    local objectivesFolder = parts:FindFirstChild("Objectives")
    if not objectivesFolder then return objectives end
    for _, obj in pairs(objectivesFolder:GetChildren()) do
        if obj:GetAttribute("Completed") == true then continue end
        local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if primaryPart or obj:IsA("BasePart") then
            table.insert(objectives, {
                Name = obj.Name,
                Part = primaryPart or obj,
                Position = (primaryPart or obj).Position,
                Tag = obj:GetAttribute("Tag"),
                Instance = obj
            })
        end
    end
    return objectives
end

local FarmPart
function DFunctions.AFKFarming()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not FarmPart then
        FarmPart = Instance.new("Part")
        FarmPart.Size = Vector3.new(10, 1, 10)
        FarmPart.Anchored = true
        FarmPart.CanCollide = true
        FarmPart.Name = "AFKFarmPad"
        FarmPart.CFrame = CFrame.new(1131, 1015, 2222)
        FarmPart.Parent = workspace
    end
    hrp.CFrame = FarmPart.CFrame + Vector3.new(0, 3, 0)
end

function DFunctions.RevivePlayer()
    local downed = DFunctions.GetDownedPlayer()
    if downed and downed:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(downed.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
        end
    else
        DFunctions.AFKFarming()
    end
end


function DFunctions.TokenFarming()
    DFunctions.StartGodMode()
end

function DFunctions.PointFarming()
    local objectives = DFunctions.GetObjective()
    if type(objectives) ~= "table" or #objectives == 0 then return end
    for _, objective in ipairs(objectives) do
        local inst = objective.Instance
        if inst and inst:FindFirstChild("WhenActivated") then
            local tagValue = objective.Tag or inst:GetAttribute("Tag")
            if tagValue then
                pcall(function()
                    ReplicatedStorage.Events.Interact:FireServer("Dynamic", tagValue)
                end)
                task.wait(0.2)
            end
        end
    end
end

function DFunctions.TicketsFarming()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ticketsFolder = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
    if not ticketsFolder then
        DFunctions.AFKFarming()
        return
    end
    for _, v in ipairs(ticketsFolder:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "HumanoidRootPart" then
            hrp.CFrame = CFrame.new(v.Position)
            return
        end
    end
    DFunctions.AFKFarming()
end

function DFunctions.AutoVote() end

function DFunctions.NormalizeVIPString(str)
    return tostring(str or ""):gsub("%s+", ""):lower()
end

function DFunctions.AdminCommand(commandString)
    local cmd = ReplicatedStorage:FindFirstChild("Events")
        and ReplicatedStorage.Events:FindFirstChild("Admin")
        and ReplicatedStorage.Events.Admin:FindFirstChild("Command")
    if not cmd then return end
    pcall(function()
        cmd:FireServer(commandString)
    end)
end

function DFunctions.SetVIPCommands()
    local VIP = DConfiguration.AutoFarm.VIPAutomations
    local svc = ServerStateRegistryService
    if not svc then return end

    local function getState(key)
        if svc.Registry then
            return svc.Registry[key]
        end
        return nil
    end

    local function normalize(str)
        return tostring(str or ""):gsub("%s+", ""):lower()
    end

    local function getMapDisplayName(moduleName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        local mod = mapsFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end

    local function getMapModuleName(displayName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        for _, mod in ipairs(mapsFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end

    local function getSpecialRoundDisplayName(moduleName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        local mod = srFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end

    local function getSpecialRoundModuleName(displayName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        for _, mod in ipairs(srFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end

    if VIP.AutoMap and VIP.MapInput and VIP.MapInput ~= "" then
        if tick() - (VIP.LastMapSet or 0) >= 1 then
            local current = getState("Map")
            local desired = VIP.MapInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)

            if nc == nd then
                match = true
            else
                -- Registry = display name, Input = module name
                local display = getMapDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                -- Registry = module name, Input = display name
                local moduleName = getMapModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end

            if not match then
                local isLoading = getState("MapLoading")
                if type(isLoading) == "string" then
                    else
                    DFunctions.AdminCommand("!Map " .. desired)
                    VIP.LastMapSet = tick()
                end
            end
        end
    end

    if VIP.AutoSpecialRound and VIP.SpecialRoundInput and VIP.SpecialRoundInput ~= "" then
        if tick() - (VIP.LastSRSet or 0) >= 1 then
            local current = getState("SpecialRound")
            local desired = VIP.SpecialRoundInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)

            if nc == nd then
                match = true
            else
                -- Registry = display name, Input = module name
                local display = getSpecialRoundDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                -- Registry = module name, Input = display name
                local moduleName = getSpecialRoundModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end

            if not match then
                DFunctions.AdminCommand("!SpecialRound " .. desired)
                VIP.LastSRSet = tick()
                end
        end
    end

    if VIP.AutoTimer and VIP.TimerInput and VIP.TimerInput ~= "" then
        if tick() - (VIP.LastTimerSet or 0) >= 3 then
            local roundStatus = getState("RoundStatus")
            local roundState = VIP.TimerRoundState or 1
            local shouldFire = false
            if roundState == 1 and roundStatus == 2 then
                shouldFire = true
            elseif roundState == 2 and roundStatus ~= 2 then
                shouldFire = true
            elseif roundState == 3 then
                shouldFire = true
            end
            if shouldFire then
                local currentTime = getState("Time")
                local desiredNum = tonumber(VIP.TimerInput)
                if desiredNum and (currentTime == nil or currentTime ~= desiredNum) then
                    DFunctions.AdminCommand("!Time " .. tostring(desiredNum))
                    VIP.LastTimerSet = tick()
                end
            end
        end
    end
end


function DFunctions.GetItemRegistry()
    if ItemRegistry then return ItemRegistry end
    return ItemRegistry
end

function DFunctions.GetEmotesName()
    local names = {}
    local reg = DFunctions.GetItemRegistry()
    if not reg then return names end
    local byCat = reg.GetByCategory and reg.GetByCategory("Emotes")
    if byCat then
        for id, entry in pairs(byCat) do
            if entry and entry.Module then
                table.insert(names, entry.Module.Name)
            end
        end
    end
    if #names == 0 then
        local all = reg.GetAll and reg.GetAll()
        if all then
            for id, entry in pairs(all) do
                if entry and entry.Categories then
                    for _, cat in ipairs(entry.Categories) do
                        if tostring(cat):lower():find("emote") then
                            table.insert(names, entry.Module.Name)
                            break
                        end
                    end
                end
            end
        end
    end
    table.sort(names)
    return names
end


function DFunctions.GetMultipleShopItems()
    local names = {}
    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return names end

    local allIds = reg.GetAll()
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                table.insert(names, name)
            end
        end
    end
    table.sort(names)
    return names
end

function DFunctions.BuyItem()
    local selected = DConfiguration.AutoFarm.PurchaseAutomations.Selected
    if not selected or selected == "" then return end

    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return end

    local allIds = reg.GetAll()
    local itemId = nil
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                if name == selected then
                    itemId = id
                    break
                end
            end
        end
    end
    if not itemId then return end

    local amount = DConfiguration.AutoFarm.PurchaseAutomations.Amount or 1

    local purchaseEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
        and ReplicatedStorage.Shared:FindFirstChild("UserData")
        and ReplicatedStorage.Shared.UserData:FindFirstChild("Events")
        and ReplicatedStorage.Shared.UserData.Events:FindFirstChild("Requests")
        and ReplicatedStorage.Shared.UserData.Events.Requests:FindFirstChild("Purchase")
    if not purchaseEvent then return end

    pcall(function()
        purchaseEvent:FireServer(itemId, amount)
    end)
end
function DFunctions.GetMultipleShopItems()
    local names = {}
    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return names end

    local allIds = reg.GetAll()
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                table.insert(names, name)
            end
        end
    end
    table.sort(names)
    return names
end

function DFunctions.BuyItem()
    local selected = DConfiguration.AutoFarm.PurchaseAutomations.Selected
    if not selected or selected == "" then return end

    local reg = DFunctions.GetItemRegistry()
    if not reg or not reg.GetAll then return end

    local allIds = reg.GetAll()
    local itemId = nil
    for id, _ in pairs(allIds) do
        local config = reg.GetConfig(id)
        if config and config.PurchaseInfo then
            local purchase = config.PurchaseInfo
            if purchase.AppearsIn == "Shop" and purchase.OwnershipType == "Multiple" then
                local name = config.AppearanceInfo and config.AppearanceInfo.Name or config.Name or "Unknown"
                if name == selected then
                    itemId = id
                    break
                end
            end
        end
    end
    if not itemId then return end

    local amount = DConfiguration.AutoFarm.PurchaseAutomations.Amount or 1

    local purchaseEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
        and ReplicatedStorage.Shared:FindFirstChild("UserData")
        and ReplicatedStorage.Shared.UserData:FindFirstChild("Events")
        and ReplicatedStorage.Shared.UserData.Events:FindFirstChild("Requests")
        and ReplicatedStorage.Shared.UserData.Events.Requests:FindFirstChild("Purchase")
    if not purchaseEvent then return end

    pcall(function()
        purchaseEvent:FireServer(itemId, amount)
    end)
end

function DFunctions.GetCosmeticsName()
    local names = {}
    local reg = DFunctions.GetItemRegistry()
    if not reg then return names end
    local byCat = reg.GetByCategory and (reg.GetByCategory("Cosmetics") or reg.GetByCategory("Cosmetic"))
    if byCat then
        for id, entry in pairs(byCat) do
            if entry and entry.Module then
                table.insert(names, entry.Module.Name)
            end
        end
    end
    table.sort(names)
    return names
end

function DFunctions.GetItemByName(name)
    local reg = DFunctions.GetItemRegistry()
    if not reg or not name or name == "" then return nil end
    if reg.TryGetByName then
        return reg.TryGetByName(name)
    end
    return nil
end

function DFunctions.GetItemConfig(nameOrId)
    local reg = DFunctions.GetItemRegistry()
    if not reg then return nil end
    local id = tonumber(nameOrId)
    if not id and reg.TryGetByName then
        local entry = reg.TryGetByName(tostring(nameOrId))
        if entry then id = entry.Id end
    end
    if id and reg.GetConfig then
        return reg.GetConfig(id)
    end
    return nil
end

function DFunctions.GetSafeCFrame(typ, root, tdist, nextbotPos)
    if typ == "Spawn" then
        local map = workspace:FindFirstChild("Map")
        local spawns = map and (map:FindFirstChild("ItemSpawns") or map:FindFirstChild("Spawns") or map:FindFirstChild("MapLogic"))
        if spawns then
            local parts = {}
            for _, p in pairs(spawns:GetDescendants()) do
                if p:IsA("BasePart") then table.insert(parts, p) end
            end
            if #parts > 0 then
                local r = parts[math.random(1, #parts)]
                return CFrame.new(r.Position + Vector3.new(0, 3, 0))
            end
        end
    elseif typ == "Players" then
        local players = Players:GetPlayers()
        local candidates = {}
        for _, plr in pairs(players) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(candidates, plr)
            end
        end
        if #candidates > 0 then
            local r = candidates[math.random(1, #candidates)]
            return r.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    elseif typ == "Distance" and root and nextbotPos then
        local dir = (root.Position - nextbotPos)
        if dir.Magnitude > 0.1 then
            return CFrame.new(root.Position + dir.Unit * (tdist or 100))
        end
    end
    return root and (root.CFrame + Vector3.new(0, 50, 0)) or CFrame.new(0, 100, 0)
end

function DFunctions.AntiNextbot()
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local range = DConfiguration.Combat.AntiNextbotRange or 50
    local tpType = DConfiguration.Combat.AntiNextbotType or "Spawn"

    local function checkFolder(folder)
        if not folder then return false end
        for _, v in pairs(folder:GetChildren()) do
            if v:IsA("Model") and v:GetAttribute("Team") == "Nextbot" and v:FindFirstChild("HumanoidRootPart") then
                if (myHRP.Position - v.HumanoidRootPart.Position).Magnitude < range then
                    local target = DFunctions.GetSafeCFrame(tpType, myHRP, 100, v.HumanoidRootPart.Position)
                    if target then myHRP.CFrame = target end
                    return true
                end
            end
        end
        return false
    end

    if checkFolder(workspace:FindFirstChild("Players")) then return end
    local gameFolder = workspace:FindFirstChild("Game")
    if gameFolder then checkFolder(gameFolder:FindFirstChild("Players")) end
end
function DFunctions.GetAdjustments() end
function DFunctions.setTSpeed(value)
    DFunctions.MovementValueSet("Speed", tonumber(value) or 1500)
end
function DFunctions.setTJump(value)
    DFunctions.MovementValueSet("JumpHeight", tonumber(value) or 3)
end
function DFunctions.setTJumpCap(value)
    DFunctions.MovementValueSet("JumpCap", tonumber(value) or 1)
end
function DFunctions.setTJumpAcceleration(value)
    DFunctions.MovementValueSet("JumpSpeedMultiplier", tonumber(value) or 1.45)
end
function DFunctions.setTAirStrafe(value)
    DFunctions.MovementValueSet("AirStrafeAcceleration", tonumber(value) or 182)
end
function DFunctions.setTAirAccel(value)
    DFunctions.MovementValueSet("AirAcceleration", tonumber(value) or 1)
end
function DFunctions.setTSprintCap(value)
    DFunctions.MovementValueSet("SprintCap", tonumber(value) or 2)
end
function DFunctions.setTSprintAccel(value)
    DFunctions.MovementValueSet("SprintAcceleration", tonumber(value) or 1)
end
function DFunctions.setTFriction(value)
    DFunctions.MovementValueSet("Friction", tonumber(value) or 5)
end
function DFunctions.setTFriction() end
function DFunctions.setBhopEnabled() end
function DFunctions.setStrafeAcceleration() end
function DFunctions.SetPreviousAdjustment() end
function DFunctions.GetSpeedometer()
    local shared = LocalPlayer.PlayerGui:FindFirstChild("Shared")
    if not shared then return nil end
    local hud = shared:FindFirstChild("HUD")
    if not hud then return nil end
    local overlay = hud:FindFirstChild("Overlay")
    if not overlay then return nil end
    local default = overlay:FindFirstChild("Default")
    if not default then return nil end
    local charInfo = default:FindFirstChild("CharacterInfo")
    if not charInfo then return nil end
    local item = charInfo:FindFirstChild("Item")
    if not item then return nil end
    local speedometer = item:FindFirstChild("Speedometer")
    if not speedometer then return nil end
    return speedometer:FindFirstChild("Players")
end

function DFunctions.BounceFunction()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    if not humanoid then return end

    if not DConfiguration.Misc.Utilities.BounceModification.Enabled then
        humanoid.WalkSpeed = 0
        return
    end

    local state = char:GetAttribute("State")
    if state == "Default" or state == "Downed" then
        humanoid.WalkSpeed = 0
    elseif state == "Emoting" or state == "EmotingAir" or state == "EmotingSlide" or state == "EmotingSlideAir" then
        humanoid.WalkSpeed = DConfiguration.Misc.Utilities.BounceModification.EmoteBounce
    else
        humanoid.WalkSpeed = DConfiguration.Misc.Utilities.BounceModification.DefaultBounce
    end
end

function DFunctions.SuperBounce()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    local prevHip = char:FindFirstChild("R15Visual") and 0.75 or -1.25
    hrp.CanCollide = false
    humanoid.HipHeight = -100
    task.wait(2)
    hrp.CanCollide = true
    humanoid.HipHeight = prevHip
end

function DFunctions.StartLag(ms)
    local LagTime = (ms or 200) * 0.002
    local Character = LocalPlayer.Character
    if not Character then return end
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local StoredVelocity = hrp.AssemblyLinearVelocity
    if StoredVelocity.Magnitude < 1 then return end

    local start = tick()
    while tick() - start < LagTime do end

    local Mode = DConfiguration.Misc.Utilities.LagSwitch.Mode
    if Mode == "FastFlag" or LagTime < 0.2 then
        if setfflag then
            setfflag("MaxMissedWorldStepsRemembered", "9999")
        end
        return
    end
end

local EdgeParams = RaycastParams.new()
EdgeParams.FilterType = Enum.RaycastFilterType.Blacklist

function DFunctions.ModifyEdgeTrimp()
    local Character = LocalPlayer.Character
    if not Character then return end
    local Root = Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    local Velocity = Root.AssemblyLinearVelocity
    local HorizontalVel = Vector3.new(Velocity.X, 0, Velocity.Z)
    local Speed = HorizontalVel.Magnitude
    if Speed < 22 then return end

    if Velocity.Y >= 0 then return end

    local MoveDir = HorizontalVel.Unit
    EdgeParams.FilterDescendantsInstances = {Character}

    local PredictTime = math.clamp(Speed / 110, 0.14, 0.24)
    local FutureMovePos = Root.Position + HorizontalVel * PredictTime + MoveDir * 2.5

    local dropThreshold = DConfiguration.Misc.Utilities.EdgeTrimpModification.DownThreshold
    local heightMult = DConfiguration.Misc.Utilities.EdgeTrimpModification.HeightMultiplier

    local downHit = workspace:Raycast(FutureMovePos + Vector3.new(0, 2, 0), Vector3.new(0, -6, 0), EdgeParams)
    if downHit then
        local drop = Root.Position.Y - downHit.Position.Y
        if drop >= dropThreshold then
            Root.AssemblyLinearVelocity = HorizontalVel * 1.05 + Vector3.new(0, math.clamp(Speed * 0.7, 22, 85) * heightMult, 0)
        end
    end
end

local CharacterTag = nil
local function GetCharacterTag(character)
    if not character then return nil end
    return character:GetAttribute("Tag")
end
if LocalPlayer.Character then CharacterTag = GetCharacterTag(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(c) CharacterTag = GetCharacterTag(c) end)

local function getCurrentSpeed(character)
    if not character then return 0 end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end
    local velocity = hrp.AssemblyLinearVelocity
    return (velocity.X * velocity.X + velocity.Z * velocity.Z) ^ 0.5
end

function DFunctions.MovementValueSet(MovementType, value)
    if not CharacterTag then CharacterTag = GetCharacterTag(LocalPlayer.Character) end
    if not CharacterTag then return end
    pcall(function()
        firesignal(ReplicatedStorage.Events.CharacterTask.OnClientEvent, CharacterTag, "ModifyMovement", { MovementType, value })
    end)
end
local MovementValueSet = DFunctions.MovementValueSet

local originalRegistry = MovementModule.RegistryTermUpdated
local originalMovementUpdate = MovementModule.Update

if originalRegistry then
    MovementModule.RegistryTermUpdated = function(self, term)
        if term == "Emote" then
            local AED = DConfiguration.Misc.MovementModification.AggressiveEmoteDash
            local id = self.DataRegistry:Get("Emote")
            if id and id ~= 0 then
                local item = ClientItemService:GetItemFromID(id)
                local mult = 1
                if item then
                    local ok, mod = pcall(require, item)
                    if ok and mod and mod.EmoteInfo then mult = mod.EmoteInfo.SpeedMult or 1 end
                end
                if AED.Enabled and AED.Type == "Blatant" then
                    self.MoveStats:SpeedChange("Emote", mult * ((AED.Speed or 1000) / 1000))
                else
                    self.MoveStats:SpeedChange("Emote", mult)
                end
            else
                self.MoveStats:SpeedChange("Emote", nil)
            end
            return
        end
        return originalRegistry(self, term)
    end
end

if originalMovementUpdate then
    MovementModule.Update = function(self, ...)
        originalMovementUpdate(self, ...)
        local humanoid = self.Character and self.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local MM = DConfiguration.Misc.MovementModification
        local BHOP = MM.BHOP
        local S = BHOP.Settings
        local AED = MM.AggressiveEmoteDash
        local Slide = MM.SlideModification
        local state = self.State or (self.DataRegistry and self.DataRegistry:Get("State"))
        local grounded = self.DataRegistry and self.DataRegistry:Get("Grounded")
        local desiredFriction = nil

        local isInfSlide = (state == "Slide" or state == "EmotingSlide" or state == "CarrySlide")
        local isEmoteSlideAccel = (state == "EmotingSlide")
        if isInfSlide and Slide.Enabled then
            desiredFriction = Slide.Acceleration or -8
        end
        if isEmoteSlideAccel and AED.Enabled and AED.Type == "Legit" then
            desiredFriction = AED.Acceleration or -2
        end
        local accelOn = S.Type ~= "No Acceleration"
        if desiredFriction == nil and accelOn then
            local isBhopActive = BHOP.Enabled or (BHOP.HoldKeybind and humanoid.Jump == true)
            if isBhopActive and not grounded then
                local currentSpeed = getCurrentSpeed(self.Character)
                local AA = S.AutoAcceleration
                if AA.Enabled then
                    if currentSpeed > (AA.MinSpeed or 70) then
                        desiredFriction = AA.MaxAccelerate or 3
                    elseif currentSpeed < (AA.MinSpeed or 70) then
                        desiredFriction = AA.MinAccelerate or -1
                    else
                        desiredFriction = S.Acceleration or -0.2
                    end
                else
                    desiredFriction = S.Acceleration or -0.2
                end
            end
        end
        if desiredFriction ~= BHOP.lastFriction then
            if desiredFriction ~= nil then
                MovementValueSet("Friction", desiredFriction)
            else
                MovementValueSet("Friction", DConfiguration.Misc.PlayerAdjustment.Default.Friction)
            end
            BHOP.lastFriction = desiredFriction
        end
        if (state == "WallrunRight" or state == "WallrunLeft") and S.SpiderHop then
            pcall(function() self:AttemptJump() end)
        end
        if BHOP.Enabled and grounded then
            if S.JumpType == "Realistic" then
                pcall(function() self:AttemptJump() end)
            else
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        if BHOP.HoldKeybind and grounded and humanoid.Jump == true then
            pcall(function() self:AttemptJump() end)
        end
    end
end
local function updateBhopEnabled()
    local BHOP = DConfiguration.Misc.MovementModification.BHOP
    local shouldEnable = (BHOP.Enabled or BHOP.HoldKeybind) and BHOP.Settings.Type ~= "No Acceleration"
    MovementValueSet("BhopEnabled", shouldEnable)
end

function DFunctions.GetStatus(player)
    if not player then return "DEAD" end
    local character = player.Character
    if not character then return "DEAD" end

    local cs = CharacterService
    if not cs then
        pcall(function()
            cs = CharacterService
        end)
    end
    if cs then
        local ok, charData = pcall(function() return cs:GetCharacterFromPlayer(player) end)
        if ok and charData and charData.DataRegistry then
            if charData.DataRegistry:Get("Downed") then
                return "DOWNED"
            end
        end
    end

    local folder = workspace:FindFirstChild("Players")
    local folderPlr = folder and folder:FindFirstChild(player.Name)
    if folderPlr then
        local downed = folderPlr:GetAttribute("Downed")
        if downed == true or downed == 1 or downed == "true" then
            return "DOWNED"
        end
    end

    if character:GetAttribute("Downed") == true then
        return "DOWNED"
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then return "ALIVE" end
    return "DEAD"
end

function DFunctions.isPlayerDowned(player)
    return DFunctions.GetStatus(player) == "DOWNED"
end

function DFunctions.isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local char = player.Character
    if char:FindFirstChild("RagdollConstraints") then return true end
    if CharacterService then
        local ok, charData = pcall(function() return CharacterService:GetCharacterFromPlayer(player) end)
        if ok and charData and charData.DataRegistry and charData.DataRegistry:Get("Ragdolling") then return true end
    end
    if char.PrimaryPart and char.PrimaryPart.Anchored then return true end
    return false
end

function DFunctions.getNearestDownedPlayer()
    local nearest, nearestDist = nil, 20
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and DFunctions.isPlayerDowned(plr) and not DFunctions.isPlayerRagdolled(plr) then
            local otherHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local dist = (hrp.Position - otherHRP.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = plr
                end
            end
        end
    end
    return nearest
end

function DFunctions.CarryPlayer()
    local target = DFunctions.getNearestDownedPlayer()
    if not target or not target.Character then return end
    local tag = target.Character:GetAttribute("Tag")
    if tag then
        pcall(function()
            ReplicatedStorage.Events.Interact:FireServer("Carry", tag)
        end)
    end
end

function DFunctions.StartAutoCarry()
    local Carry = DConfiguration.Misc.GameAutomation.Carry
    if Carry.Connection then Carry.Connection:Disconnect() end
    Carry.Enabled = true
    Carry.Connection = RunService.Heartbeat:Connect(function()
        if not Carry.Enabled then return end
        local now = tick()
        if now - (Carry.lastAttempt or 0) < (Carry.Cooldown or 0.5) then return end
        DFunctions.CarryPlayer()
        Carry.lastAttempt = now
    end)
end

function DFunctions.StopAutoCarry()
    local Carry = DConfiguration.Misc.GameAutomation.Carry
    Carry.Enabled = false
    if Carry.Connection then
        Carry.Connection:Disconnect()
        Carry.Connection = nil
    end
end

function DFunctions.AggressiveEmoteDashFunction()
    if MovementModule then
        pcall(function()
            local id = MovementModule.DataRegistry:Get("Emote")
            if id and id ~= 0 then
                MovementModule.RegistryTermUpdated(MovementModule, "Emote")
            end
        end)
    end
end

function DFunctions.SetToMovableEmote() end

function DFunctions.InfiniteSlideFunction()
end

function DFunctions.ToggleBhop(state)
    DConfiguration.Misc.MovementModification.BHOP.Enabled = state and true or false
    updateBhopEnabled()
end

function DFunctions.ToggleBhopHold(state)
    DConfiguration.Misc.MovementModification.BHOP.HoldKeybind = state and true or false
    updateBhopEnabled()
end

function DFunctions.SetAccelerationMethod(method)
    local BHOP = DConfiguration.Misc.MovementModification.BHOP
    BHOP.Settings.Type = method
    updateBhopEnabled()
    if not (BHOP.Enabled or BHOP.HoldKeybind) then
        MovementValueSet("Friction", DConfiguration.Misc.PlayerAdjustment.Default.Friction)
        BHOP.lastFriction = nil
    end
end

function DFunctions.BHOPFunction()
    updateBhopEnabled()
end

function DFunctions.ResetBHOP()
    local BHOP = DConfiguration.Misc.MovementModification.BHOP
    BHOP.Enabled = false
    BHOP.HoldKeybind = false
    updateBhopEnabled()
    MovementValueSet("Friction", DConfiguration.Misc.PlayerAdjustment.Default.Friction)
    BHOP.lastFriction = nil
end

function DFunctions.CrouchFunction()
    local Config = DConfiguration.Misc.MovementModification.Crouch
    local now = tick()
    Config.isHolding = Config.isHolding or false
    Config.lastTick = Config.lastTick or 0
    Config.debounce = Config.debounce or 0.1
    local SendKeybindEvent = ReplicatedStorage:FindFirstChild("Services")
        and ReplicatedStorage.Services:FindFirstChild("Client")
        and ReplicatedStorage.Services.Client:FindFirstChild("KeybindService")
        and ReplicatedStorage.Services.Client.KeybindService:FindFirstChild("SendKeybindEvent")
    if not SendKeybindEvent then return end
    if not Config.isHolding and (now - Config.lastTick) >= Config.debounce then
        SendKeybindEvent:Fire({ Down = true, Key = "Crouching" })
        Config.isHolding = true
        Config.lastTick = now
    elseif Config.isHolding and (now - Config.lastTick) >= Config.debounce then
        SendKeybindEvent:Fire({ Down = false, Key = "Crouching" })
        Config.isHolding = false
        Config.lastTick = now
    end
end

function DFunctions.Normalize(input) return (input or ""):lower():gsub("%s+", "") end

function DFunctions.FindRealName(folder, userInput)
    if not userInput or userInput == "" then return nil end
    local reg = DFunctions.GetItemRegistry()
    if reg and reg.TryGetByName then
        local entry = reg.TryGetByName(userInput)
        if entry and entry.Module then return entry.Module.Name end
    end
    if not folder then return nil end
    local normalized = DFunctions.Normalize(userInput)
    for _, item in ipairs(folder:GetChildren()) do
        if DFunctions.Normalize(item.Name) == normalized then return item.Name end
    end
    for _, item in ipairs(folder:GetDescendants()) do
        if item:IsA("ModuleScript") and DFunctions.Normalize(item.Name) == normalized then
            return item.Name
        end
    end
    return nil
end

function DFunctions.GetItemModule(name)
    local reg = DFunctions.GetItemRegistry()
    if reg and reg.TryGetByName then
        local entry = reg.TryGetByName(name)
        if entry then return entry.Module, entry.Id end
    end
    return nil, nil
end

local CosmeticsFolder = Instance.new("Folder")
CosmeticsFolder.Name = "D-Folder-Cosmetics"
pcall(function() CosmeticsFolder.Parent = ReplicatedStorage:FindFirstChild("Items") or ReplicatedStorage end)


function DFunctions.scanDescendantsAsync(root, matchFolderName, targetName, callback)
    local stack = {}
    for _, child in ipairs(root:GetChildren()) do
        table.insert(stack, child)
    end
    local found = nil
    local function findInFolder(folder, name)
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name == name then return child end
            local result = findInFolder(child, name)
            if result then return result end
        end
        return nil
    end
    local iterations = 0
    while #stack > 0 do
        local node = table.remove(stack)
        if node:IsA("Folder") or node:IsA("Model") then
            if matchFolderName and node.Name == matchFolderName then
                local innerResult = findInFolder(node, targetName)
                if innerResult then
                    found = innerResult
                    break
                end
            elseif not matchFolderName and node.Name == targetName then
                found = node
                break
            else
                for _, child in ipairs(node:GetChildren()) do
                    table.insert(stack, child)
                end
            end
        end
        iterations = iterations + 1
        if iterations % 100 == 0 then task.wait() end
    end
    if callback then callback(found) end
    return found
end

function DFunctions.ChangeCosmetics(Name1, Name2, onComplete)
    onComplete = onComplete or function() end
    if not Name1 or not Name2 or Name1 == "" or Name2 == "" or Name1 == Name2 then
        onComplete(false)
        return
    end
    local cosSwaps = DConfiguration.Visual.CosSwaps
    local key = Name1 .. "_" .. Name2
    local items = ReplicatedStorage:FindFirstChild("Items")
    if not items then onComplete(false) return end

    task.spawn(function()
        local curFound = DFunctions.scanDescendantsAsync(items, "Cosmetics", Name1)
        local tarFound = DFunctions.scanDescendantsAsync(items, "Cosmetics", Name2)
        if not (curFound and tarFound) then
            onComplete(false)
            return
        end
        local temp = Instance.new("Folder")
        temp.Name = "__temp_cos_swap_" .. tostring(tick())
        temp.Parent = ReplicatedStorage
        local curChildren, tarChildren = {}, {}
        for _, child in ipairs(curFound:GetChildren()) do table.insert(curChildren, child) end
        for _, child in ipairs(tarFound:GetChildren()) do table.insert(tarChildren, child) end
        for _, child in ipairs(curChildren) do child.Parent = temp end
        for _, child in ipairs(tarChildren) do child.Parent = curFound end
        for _, child in ipairs(temp:GetChildren()) do child.Parent = tarFound end
        temp:Destroy()
        cosSwaps[key] = { current = Name1, target = Name2 }
        onComplete(true)
    end)
end

function DFunctions.RestoreCosmetics(onComplete)
    onComplete = onComplete or function() end
    local cosSwaps = DConfiguration.Visual.CosSwaps
    local list = {}
    for _, v in pairs(cosSwaps) do table.insert(list, v) end
    if #list == 0 then onComplete() return end
    local done = 0
    for _, v in ipairs(list) do
        DFunctions.ChangeCosmetics(v.target, v.current, function()
            done = done + 1
            if done >= #list then
                DConfiguration.Visual.CosSwaps = {}
                onComplete()
            end
        end)
    end
end

function DFunctions.ChangeAnimation() end

function DFunctions.SetEmote(emoteID)
    if not emoteID then return end
    local character = LocalPlayer.Character
    if not character then return end
    local tagValue = character:GetAttribute("Tag")
    if not tagValue then return end
    local tagBuf = buffer.create(2)
    buffer.writeu16(tagBuf, 0, tagValue)
    firesignal(ReplicatedStorage.Events.UpdateCharacterDataRegistry.OnClientEvent, {
        buffer.fromstring("\24\1"),
        emoteID,
        tagBuf
    })
end

function DFunctions.GetAllEmotes()
    local allEmotes = {}
    local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
    if not itemsFolder then return allEmotes end
    local function findEmotesFolders(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Folder") then
                if child.Name == "Emotes" then
                    for _, emote in ipairs(child:GetChildren()) do
                        if emote:IsA("ModuleScript") then
                            table.insert(allEmotes, { Name = emote.Name, ID = emote:GetAttribute("ID") })
                        end
                    end
                else
                    findEmotesFolders(child)
                end
            end
        end
    end
    findEmotesFolders(itemsFolder)
    local reg = DFunctions.GetItemRegistry()
    if reg and reg.GetByCategory then
        local byCat = reg.GetByCategory("Emotes")
        if byCat then
            for id, entry in pairs(byCat) do
                if entry and entry.Module then
                    local exists = false
                    for _, e in ipairs(allEmotes) do
                        if e.Name == entry.Module.Name then exists = true break end
                    end
                    if not exists then
                        table.insert(allEmotes, { Name = entry.Module.Name, ID = entry.Id or entry.Module:GetAttribute("ID") })
                    end
                end
            end
        end
    end
    return allEmotes
end

function DFunctions.FindEmoteInfo(emoteInput)
    if not emoteInput or emoteInput == "" then return nil end
    local id = tonumber(emoteInput)
    local reg = DFunctions.GetItemRegistry()
    if id then
        if reg and reg.GetConfig and reg.GetConfig(id) then
            return { Name = tostring(id), ID = id }
        end
        for _, e in ipairs(DFunctions.GetAllEmotes()) do
            if e.ID == id then return { Name = e.Name, ID = id } end
        end
        return { Name = tostring(id), ID = id }
    end
    for _, emote in ipairs(DFunctions.GetAllEmotes()) do
        if emote.Name:lower() == tostring(emoteInput):lower() then
            return { Name = emote.Name, ID = emote.ID }
        end
    end
    if reg and reg.TryGetByName then
        local entry = reg.TryGetByName(emoteInput)
        if entry then return { Name = entry.Module.Name, ID = entry.Id } end
    end
    return nil
end

function DFunctions.BuildEmoteMapping()
    local replacements = {}
    for i = 1, 12 do
        local currentInput = DConfiguration.Visual.CurrentEmotes[i] or DConfiguration.Visual.OriginalEmotes["Emote" .. i] or ""
        local selectInput = DConfiguration.Visual.SelectEmotes[i] or DConfiguration.Visual.ModifyEmotes["Emote" .. i] or ""
        if currentInput ~= "" and selectInput ~= "" and currentInput ~= " " and selectInput ~= " " then
            local currentInfo = DFunctions.FindEmoteInfo(currentInput)
            local selectInfo = DFunctions.FindEmoteInfo(selectInput)
            if currentInfo and selectInfo then
                replacements[currentInfo.Name] = {
                    select = selectInfo.Name,
                    selectID = selectInfo.ID,
                    slot = i
                }
            end
        end
    end
    DConfiguration.Visual.EmoteReplacements = replacements
    return replacements
end

function DFunctions.ChangeEmotes(Name1, Name2)
    local info1 = DFunctions.FindEmoteInfo(Name1)
    local info2 = DFunctions.FindEmoteInfo(Name2)
    if info1 and info2 and info2.ID then
        DFunctions.SetEmote(info2.ID)
    end
end

local hookActive = false
local lastEmoteName = nil
local origEmoteActivate, origEmoteDeactivate = nil, nil
local EmoteClassRef = nil

function DFunctions.StartEmoteWatcher()
    if hookActive then return end
    if not EmoteClass then return end
    EmoteClassRef = EmoteClass
    hookActive = true
    origEmoteActivate = EmoteClass.Activate
    origEmoteDeactivate = EmoteClass.Deactivate

    EmoteClass.Activate = function(self, p2, p3)
        origEmoteActivate(self, p2, p3)
        local anim = self.Animations and self.Animations.Animation
        if anim and anim.IsPlaying and anim.Speed > 0 then
            local module = self.EmoteModule
            local currentEmote = module and module.Name or "Unknown"
            if currentEmote ~= lastEmoteName then
                local emoteReplacements = DConfiguration.Visual.EmoteReplacements
                if emoteReplacements[currentEmote] then
                    local replacement = emoteReplacements[currentEmote]
                    local selectID = replacement.selectID
                    if selectID then
                        lastEmoteName = currentEmote
                        DFunctions.SetEmote(selectID)
                    end
                end
                lastEmoteName = currentEmote
            end
        end
    end

    EmoteClass.Deactivate = function(self, ...)
        origEmoteDeactivate(self, ...)
        lastEmoteName = nil
    end
end

function DFunctions.StopEmoteWatcher()
    if not hookActive then return end
    hookActive = false
    pcall(function()
    local EmoteClass = EmoteClass
        if origEmoteActivate then EmoteClass.Activate = origEmoteActivate end
        if origEmoteDeactivate then EmoteClass.Deactivate = origEmoteDeactivate end
    end)
    lastEmoteName = nil
end

function DFunctions.ResetEmoteChanges()
    DFunctions.StopEmoteWatcher()
    DConfiguration.Visual.EmoteReplacements = {}
end

function DFunctions.RestoreEmoteChanges()
    DFunctions.ResetEmoteChanges()
end

function DFunctions.AutoEmoteDash()
    local char = LocalPlayer.Character
    if not char then return end
    local emoteName = DConfiguration.Misc.GameAutomation.Macro.SelectedEmote
    local info = DFunctions.FindEmoteInfo(emoteName)
    local emoteId = info and info.ID
    if not emoteId then
        local mod = select(1, DFunctions.GetItemModule(emoteName or ""))
        if mod then emoteId = mod:GetAttribute("ID") end
    end
    if emoteId then
        pcall(function()
            ReplicatedStorage.Events.CharacterTask:FireServer("Emote", emoteId)
        end)
        DFunctions.SetEmote(emoteId)
    end
    DFunctions.CrouchFunction()
end
function DFunctions.Noclip(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

local EmoteNames = DFunctions.GetEmotesName()
if #EmoteNames == 0 then EmoteNames = {"BoldMarch", "DefaultEmote"} end
local ShopItemNames = DFunctions.GetMultipleShopItems()
if #ShopItemNames == 0 then ShopItemNames = {"Cola"} end
local CosmeticNames = DFunctions.GetCosmeticsName()

Tabs.Main:AddSection("Billboard ESP")

local function clearBillboardESP(espName)
    local folder = workspace:FindFirstChild("Players")
    if folder then
        for _, v in pairs(folder:GetDescendants()) do
            if v.Name == espName then v:Destroy() end
        end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            for _, d in pairs(plr.Character:GetDescendants()) do
                if d.Name == espName then d:Destroy() end
            end
        end
    end
    local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
    if tickets then
        for _, d in pairs(tickets:GetDescendants()) do
            if d.Name == espName then d:Destroy() end
        end
    end
end

local function isDownedTarget(plr)
    if not plr then return false end
    if DFunctions.isPlayerDowned and DFunctions.isPlayerDowned(plr) then return true end
    local folder = workspace:FindFirstChild("Players")
    local folderPlr = folder and folder:FindFirstChild(plr.Name)
    if folderPlr then
        if folderPlr:GetAttribute("Downed") == true then return true end
        if folderPlr:GetAttribute("Downed") == true then return true end
    end
    if plr.Character then
        if plr.Character:GetAttribute("Downed") == true then return true end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return true end
    end
    return false
end

local Toggle = Tabs.Main:AddToggle("BillboardNextbots", {Title = "Billboard Nextbots", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.ESP.Nextbots = value
    if not value then
        clearBillboardESP("NextbotESP")
        return
    end
    task.spawn(function()
        while DConfiguration.ESP.Nextbots do
            local folder = workspace:FindFirstChild("Players")
            if folder then
                for _, v in pairs(folder:GetChildren()) do
                    if v:GetAttribute("Team") == "Nextbot" and v:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.HumanoidRootPart
                        if not hrp:FindFirstChild("NextbotESP") then
                            CreateBillboardESP("NextbotESP", hrp, Color3.fromRGB(255, 0, 0), 18)
                        end
                        UpdateBillboardESP("NextbotESP", hrp, v.Name, Color3.fromRGB(255, 0, 0), 18, Camera.CFrame.Position)
                    end
                end
            end
            task.wait(0.1)
        end
        clearBillboardESP("NextbotESP")
    end)
end)

local Toggle = Tabs.Main:AddToggle("BillboardPlayers", {Title = "Billboard Players", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.ESP.Players = value
    if not value then
        clearBillboardESP("PlayerESP")
        return
    end
    task.spawn(function()
        while DConfiguration.ESP.Players do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    if not hrp:FindFirstChild("PlayerESP") then
                        CreateBillboardESP("PlayerESP", hrp, Color3.fromRGB(255, 255, 255), 14)
                    end
                    local color = isDownedTarget(plr) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                    UpdateBillboardESP("PlayerESP", hrp, plr.Name, color, 14, Camera.CFrame.Position)
                end
            end
            task.wait(0.1)
        end
        clearBillboardESP("PlayerESP")
    end)
end)

local Toggle = Tabs.Main:AddToggle("BillboardTicket", {Title = "Billboard Tickets", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.ESP.Tickets = State
    if not State then
        clearBillboardESP("TicketESP")
        return
    end
    task.spawn(function()
        while DConfiguration.ESP.Tickets do
            local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
            if tickets then
                for _, v in pairs(tickets:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name == "HumanoidRootPart" then
                        if not v:FindFirstChild("TicketESP") then
                            CreateBillboardESP("TicketESP", v, Color3.fromRGB(255, 213, 128), 18)
                        end
                        UpdateBillboardESP("TicketESP", v, v.Parent and v.Parent.Name or "Ticket", Color3.fromRGB(255, 213, 128), 18, Camera.CFrame.Position)
                    end
                end
            end
            task.wait(0.1)
        end
        clearBillboardESP("TicketESP")
    end)
end)

Tabs.Main:AddSection("Tracer ESP")

local TracerLines = {}
local TracerLinesBots = {}
local TracerLinesTickets = {}

local Toggle = Tabs.Main:AddToggle("TracersPlayers", {Title = "Tracer Players", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Tracers.Players = State
    if not State then
        for part, _ in pairs(TracerLines) do DestroyTracerESP(TracerLines, part) end
        TracerLines = {}
        return
    end
    task.spawn(function()
        while DConfiguration.Tracers.Players do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    if not TracerLines[hrp] then
                        CreateTracerESP(TracerLines, hrp, 2, Color3.fromRGB(255, 255, 255))
                    end
                    local color = isDownedTarget(plr) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                    UpdateTracerESP(TracerLines, hrp, color)
                end
            end
            CleanupTracers(TracerLines)
            task.wait()
        end
    end)
end)

local Toggle = Tabs.Main:AddToggle("TracersBots", {Title = "Tracer Bots", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Tracers.Nextbots = State
    if not State then
        for part, _ in pairs(TracerLinesBots) do DestroyTracerESP(TracerLinesBots, part) end
        TracerLinesBots = {}
        return
    end
    task.spawn(function()
        while DConfiguration.Tracers.Nextbots do
            local folder = workspace:FindFirstChild("Players")
            if folder then
                for _, v in pairs(folder:GetChildren()) do
                    if v:GetAttribute("Team") == "Nextbot" and v:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.HumanoidRootPart
                        if not TracerLinesBots[hrp] then
                            CreateTracerESP(TracerLinesBots, hrp, 5, Color3.fromRGB(255, 0, 0))
                        end
                        UpdateTracerESP(TracerLinesBots, hrp, Color3.fromRGB(255, 0, 0))
                    end
                end
            end
            CleanupTracers(TracerLinesBots)
            task.wait()
        end
    end)
end)

local Toggle = Tabs.Main:AddToggle("TracerTickets", {Title = "Tracer Tickets", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Tracers.Tickets = State
    if not State then
        for part, _ in pairs(TracerLinesTickets) do DestroyTracerESP(TracerLinesTickets, part) end
        TracerLinesTickets = {}
        return
    end
    task.spawn(function()
        while DConfiguration.Tracers.Tickets do
            local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
            if tickets then
                for _, v in pairs(tickets:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name == "HumanoidRootPart" then
                        if not TracerLinesTickets[v] then
                            CreateTracerESP(TracerLinesTickets, v, 2, Color3.fromRGB(255, 213, 128))
                        end
                        UpdateTracerESP(TracerLinesTickets, v, Color3.fromRGB(255, 213, 128))
                    end
                end
            end
            CleanupTracers(TracerLinesTickets)
            task.wait()
        end
    end)
end)

Tabs.Main:AddSection("Highlight ESP")

local function clearHighlights(name)
    local rigs = workspace:FindFirstChild("Rigs")
    if rigs then
        for _, rig in pairs(rigs:GetChildren()) do
            DestroyHighlightESP(name, rig)
        end
    end
    local folder = workspace:FindFirstChild("Players")
    if folder then
        for _, v in pairs(folder:GetChildren()) do
            DestroyHighlightESP(name, v)
        end
    end
    local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
    if tickets then
        for _, v in pairs(tickets:GetChildren()) do
            DestroyHighlightESP(name, v)
            local hrp = v:FindFirstChild("HumanoidRootPart")
            if hrp then DestroyHighlightESP(name, hrp) end
        end
    end
end

local Toggle = Tabs.Main:AddToggle("HighlightNextbot", {Title = "Highlight Nextbots", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Highlight.Nextbots = value
    if not value then
        clearHighlights("NextbotHighlight")
        return
    end
    task.spawn(function()
        while DConfiguration.Highlight.Nextbots do
            local rigs = workspace:FindFirstChild("Rigs")
            local playersFolder = workspace:FindFirstChild("Players")
            if rigs then
                for _, rig in pairs(rigs:GetChildren()) do
                    local team = playersFolder and playersFolder:FindFirstChild(rig.Name) and playersFolder[rig.Name]:GetAttribute("Team")
                    if team == "Nextbot" then
                        if not rig:FindFirstChild("NextbotHighlight") then
                            CreateHighlightESP("NextbotHighlight", rig, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), false)
                        end
                        UpdateHighlightESP("NextbotHighlight", rig, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), false)
                    end
                end
            end
            task.wait(0.1)
        end
        clearHighlights("NextbotHighlight")
    end)
end)

local Toggle = Tabs.Main:AddToggle("HighlightPlayers", {Title = "Highlight Players", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Highlight.Players = value
    if not value then
        clearHighlights("PlayerHighlight_D")
        return
    end
    task.spawn(function()
        while DConfiguration.Highlight.Players do
            local rigs = workspace:FindFirstChild("Rigs")
            local playersFolder = workspace:FindFirstChild("Players")
            if rigs then
                for _, rig in pairs(rigs:GetChildren()) do
                    if rig.Name ~= LocalPlayer.Name then
                        local folderPlr = playersFolder and playersFolder:FindFirstChild(rig.Name)
                        local team = folderPlr and folderPlr:GetAttribute("Team")
                        if team ~= "Nextbot" then
                            if not rig:FindFirstChild("PlayerHighlight_D") then
                                CreateHighlightESP("PlayerHighlight_D", rig, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), false)
                            end
                            local plr = Players:FindFirstChild(rig.Name)
                            local color = (plr and isDownedTarget(plr)) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                            UpdateHighlightESP("PlayerHighlight_D", rig, color, Color3.fromRGB(0, 0, 0), false)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
        clearHighlights("PlayerHighlight_D")
    end)
end)

local Toggle = Tabs.Main:AddToggle("HighlightTicket", {Title = "Highlight Tickets", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Highlight.Tickets = State
    if not State then
        clearHighlights("TicketHighlight")
        return
    end
    task.spawn(function()
        while DConfiguration.Highlight.Tickets do
            local tickets = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("Tickets")
            if tickets then
                for _, v in pairs(tickets:GetChildren()) do
                    local target = v:IsA("Model") and v or v
                    if not target:FindFirstChild("TicketHighlight") then
                        CreateHighlightESP("TicketHighlight", target, Color3.fromRGB(255, 213, 128), Color3.fromRGB(255, 213, 128), false)
                    end
                    UpdateHighlightESP("TicketHighlight", target, Color3.fromRGB(255, 213, 128), Color3.fromRGB(255, 213, 128), false)
                end
            end
            task.wait(0.1)
        end
        clearHighlights("TicketHighlight")
    end)
end)

Tabs.Main:AddSection("Game Modification")

local Toggle = Tabs.Main:AddToggle("AutoRespawn", {Title = "Auto Respawn", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.AutoRespawn = value
    DConfiguration.SelfRevive.Enabled = value
    if value then
        DFunctions.StartSelfRevive()
    else
        DFunctions.StopSelfRevive()
    end
end)

local Toggle = Tabs.Main:AddToggle("SelfReviveButton", {Title = "Self Revive (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("SelfReviveGui", "Self Revive: OFF", 0.15, 0.1, function(btn)
            local SR = DConfiguration.SelfRevive
            if SR.Enabled and SR.Connections and SR.Connections.Heartbeat then
                DFunctions.StopSelfRevive()
                DConfiguration.Main.AutoRespawn = false
                btn.Text = "Self Revive: OFF"
            else
                DFunctions.StartSelfRevive()
                DConfiguration.Main.AutoRespawn = true
                btn.Text = "Self Revive: ON"
            end
        end)
    else
        DFunctions.DestroyButton("SelfReviveGui")
    end
end)

local Toggle = Tabs.Main:AddToggle("RespawnButton", {Title = "Respawn (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("RespawnButton", "Respawn", 0.15 + DConfiguration.Settings.GuiScale.Respawn, 0.1 + DConfiguration.Settings.GuiScale.Respawn, function(btn)
            btn.Text = "Respawning..."
            local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetPlayerMode")
            if event then event:FireServer(true) end
            wait(0.1)
            btn.Text = "Respawned!"
            wait(0.2)
            btn.Text = "Respawn"
        end)
    else
        DFunctions.DestroyButton("RespawnButton")
    end
end)

Tabs.Main:AddInput("RespawnButtonSize", {
    Title = "Respawn Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.Respawn),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.Respawn = num * 0.01
        else
            DConfiguration.Settings.GuiScale.Respawn = 0
        end
        DFunctions.UpdateButton("RespawnButton", 0.15 + DConfiguration.Settings.GuiScale.Respawn, 0.1 + DConfiguration.Settings.GuiScale.Respawn)
    end
})

Tabs.Main:AddButton({
    Title = "Force Respawn",
    Description = "",
    Callback = function()
        local event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetPlayerMode")
        if event then event:FireServer(true) end
    end
})

local Dropdown = Tabs.Main:AddDropdown("RespawnType", {
    Title = "Respawn Type",
    Values = {"Spawnpoint", "Fake Revive"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(value)
    DConfiguration.Main.RespawnType = value
    DConfiguration.SelfRevive.Method = value
end)

Tabs.Main:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Main:AddToggle("AutoWhistle", {Title = "Auto Whistle", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.AutoWhistle = value
    task.spawn(function()
        while DConfiguration.Main.AutoWhistle do
            local SendKeybindEvent = ReplicatedStorage:FindFirstChild("Services")
                and ReplicatedStorage.Services:FindFirstChild("Client")
                and ReplicatedStorage.Services.Client:FindFirstChild("KeybindService")
                and ReplicatedStorage.Services.Client.KeybindService:FindFirstChild("SendKeybindEvent")
            if SendKeybindEvent then
                SendKeybindEvent:Fire({ Down = true, Key = "Whistle" })
                task.wait(0.05)
                SendKeybindEvent:Fire({ Down = false, Key = "Whistle" })
            end
            task.wait(1)
        end
    end)
end)

Tabs.Main:AddSection("Alternative Settings")

local Toggle = Tabs.Main:AddToggle("AntiAfk", {Title = "Anti-AFK", Default = false })
Toggle:OnChanged(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:ClickButton2(Vector2.new())
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
pcall(function() Options.AntiAfk:SetValue(true) end)

local Toggle = Tabs.Main:AddToggle("ShowTimer", {Title = "Show Timer", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Main.ShowTimer = State
    DConfiguration.TimerDisplay.Enabled = State
    if State then
        DFunctions.CreateTimer()
    else
        DFunctions.RemoveTimer()
    end
end)

local Toggle = Tabs.Main:AddToggle("ShowSpecialRound", {Title = "Show Special Round", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.TimerDisplay.SpecialRoundEnabled = State
    if State then
        DFunctions.CreateSpecialRoundDisplay()
    else
        DFunctions.RemoveSpecialRoundDisplay()
    end
end)

local Toggle = Tabs.Main:AddToggle("DisableCameraShake", {Title = "Disable Camera Shake", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.CameraShake = value
    if value then
        pcall(function()
            ReplicatedStorage.Shared.UserData.Events.Requests.SetSetting:FireServer("NextbotVignette", false)
        end)
    end
end)

local Toggle = Tabs.Main:AddToggle("DisableVignette", {Title = "Disable Vignette", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.Vignette = value
    task.spawn(function()
        while DConfiguration.Removals.Vignette do
            for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if typeof(v.Name) == "string" and (v.Name:lower():find("vignette") or v.Name:lower():find("noise") or v.Name == "NextbotNoise") then
                    if v:IsA("ImageLabel") or v:IsA("Frame") or v:IsA("ImageButton") then
                        v.Visible = false
                        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
                            v.ImageTransparency = 1
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end)

Tabs.Main:AddButton({
    Title = "Open Leaderboard",
    Description = "",
    Callback = function()
        local SendKeybindEvent = ReplicatedStorage:FindFirstChild("Services")
            and ReplicatedStorage.Services:FindFirstChild("Client")
            and ReplicatedStorage.Services.Client:FindFirstChild("KeybindService")
            and ReplicatedStorage.Services.Client.KeybindService:FindFirstChild("SendKeybindEvent")
        if SendKeybindEvent then
            SendKeybindEvent:Fire({ Down = true, Key = "Leaderboard" })
        end
    end
})

Tabs.Main:AddSection("Map Modification")


local Toggle = Tabs.Main:AddToggle("RemoveReducingRewards", {Title = "Remove Reducing Rewards", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.ReducingRewards = value
end)

local Toggle = Tabs.Main:AddToggle("RemoveInvisibleWalls", {Title = "Remove Invisible Walls", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Removals.InvisibleWalls = value
    while DConfiguration.Removals.InvisibleWalls and task.wait(1) do
        DFunctions.DisableInvisParts(false)
    end
    if not DConfiguration.Removals.InvisibleWalls then
        DFunctions.DisableInvisParts(true)
    end
end)

Tabs.Main:AddSection("Player Modification")

local Toggle = Tabs.Main:AddToggle("Noclip", {Title = "Noclip", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Main.Noclip = value
    if value then
        task.spawn(function()
            while DConfiguration.Main.Noclip do
                DFunctions.Noclip(true)
                RunService.Stepped:Wait()
            end
            DFunctions.Noclip(false)
        end)
    else
        DFunctions.Noclip(false)
    end
end)


    MovementModule = require(ReplicatedStorage:WaitForChild("Objects"):WaitForChild("Game"):WaitForChild("Character"):WaitForChild("Client"):WaitForChild("Movement"))
    DConfiguration.Main.FlyoriginalUpdate = MovementModule.Update
    local playerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    controlModule = require(playerModule:WaitForChild("ControlModule"))

local function getFlyDirection()
    if not controlModule then return Vector3.new() end
    local camCF = workspace.CurrentCamera.CFrame
    local moveVector = controlModule:GetMoveVector()
    if moveVector.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0)
    end
    local forward = camCF.LookVector
    local right = camCF.RightVector
    return (forward * -moveVector.Z + right * moveVector.X).Unit * 150 * DConfiguration.Main.FlySpeed
end

local function flyUpdate(self, dt)
    if DConfiguration.Main.FlyoriginalUpdate then DConfiguration.Main.FlyoriginalUpdate(self, dt) end
    local hrp = self.Character and self.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local flyDir = getFlyDirection()
    if flyDir.Magnitude > 0.1 then
        DConfiguration.Main.isFlyFloating = nil
    elseif not DConfiguration.Main.isFlyFloating then
        DConfiguration.Main.isFlyFloating = hrp.Position.Y
    end
    local newVel = flyDir
    if self.DataRegistry and self.DataRegistry.Set then
        self.DataRegistry:Set("Velocity", newVel * 90)
    end
    hrp.AssemblyLinearVelocity = newVel
    if DConfiguration.Main.isFlyFloating and flyDir.Magnitude <= 0.1 then
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos.X, DConfiguration.Main.isFlyFloating, pos.Z) * (hrp.CFrame - hrp.CFrame.Position)
    end
end

local function StartFly()
    if DConfiguration.Main.Fly or not MovementModule then return end
    DConfiguration.Main.Fly = true
    DConfiguration.Main.isFlyFloating = nil
    MovementModule.Update = flyUpdate
end

local function StopFly()
    if not DConfiguration.Main.Fly then return end
    DConfiguration.Main.Fly = false
    DConfiguration.Main.isFlyFloating = nil
    if MovementModule and DConfiguration.Main.FlyoriginalUpdate then
        MovementModule.Update = DConfiguration.Main.FlyoriginalUpdate
    end
end

local Toggle = Tabs.Main:AddToggle("ShowFlyButton", { Title = "Fly Button", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("FlyButton", "Fly: OFF", 0.15, 0.1, function(btn)
            local newState = not DConfiguration.Main.Fly
            if newState then
                StartFly()
                btn.Text = "Fly: ON"
            else
                StopFly()
                btn.Text = "Fly: OFF"
            end
        end)
    else
        StopFly()
        DFunctions.DestroyButton("FlyButton")
    end
end)

local FlySpeedInput = Tabs.Main:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = "1",
    Placeholder = "Enter fly speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local speed = tonumber(Value)
        if speed and speed > 0 then
            DConfiguration.Main.FlySpeed = speed
        end
    end
})

wait(Duration)

Tabs.AutoFarm:AddSection("Farmings")

local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmMoney", {
    Title = "Auto Farm Token",
    Description = "Teleports under a random workspace.Players child and fires Revive. Stays on that target until it is gone. Ban risk on public servers.",
    Default = false
})
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.FarmTokens = State
    DConfiguration.TokenFarm.Enabled = State
    if State then
        DFunctions.StartGodMode()
    else
        DFunctions.StopGodMode()
    end
end)

Tabs.AutoFarm:AddInput("TokenFarmOffset", {
    Title = "Token Farm Offset",
    Default = "0 -8 0",
    Placeholder = "X Y Z",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local x, y, z = tostring(Value):match("^%s*([%-%d%.]+)%s+([%-%d%.]+)%s+([%-%d%.]+)%s*$")
        if x and y and z then
            DConfiguration.TokenFarm.TokenOffset = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        end
    end
})

Tabs.AutoFarm:AddSlider("TokenFarmDelay", {
    Title = "Token Farm Delay",
    Description = "Revive fire delay in seconds",
    Default = 2,
    Min = 1,
    Max = 4,
    Rounding = 0,
    Callback = function(Value)
        DConfiguration.TokenFarm.TokenDelay = Value
    end
})

local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmTickets", {Title = "Auto Farm Tickets", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.FarmTickets = State
    while DConfiguration.AutoFarm.FarmTickets and task.wait(1) do
        DFunctions.TicketsFarming()
    end
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoCompleteObjectives", {Title = "Auto Complete Objective", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.CompleteObjective = State
    while DConfiguration.AutoFarm.CompleteObjective and task.wait(3) do
        DFunctions.PointFarming()
    end
end)

local Toggle = Tabs.AutoFarm:AddToggle("AFKFarm", {Title = "AFK Farm", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.AFKFarm = State
    while DConfiguration.AutoFarm.AFKFarm and task.wait(1) do
        DFunctions.AFKFarming()
    end
end)

Tabs.AutoFarm:AddSection("Purchase Automations")

local Toggle = Tabs.AutoFarm:AddToggle("AutoBuy", {Title = "Auto Purchase Selected Item", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.PurchaseAutomations.Enabled = State
    if State then
        DConfiguration.AutoFarm.PurchaseAutomations.LastBuy = tick()
        DConfiguration.AutoFarm.PurchaseAutomations.Connection = RunService.Heartbeat:Connect(function()
            if not DConfiguration.AutoFarm.PurchaseAutomations.Enabled then return end
            if tick() - (DConfiguration.AutoFarm.PurchaseAutomations.LastBuy or 0) >= 4 then
                DFunctions.BuyItem()
                DConfiguration.AutoFarm.PurchaseAutomations.LastBuy = tick()
            end
        end)
    else
        if DConfiguration.AutoFarm.PurchaseAutomations.Connection then
            DConfiguration.AutoFarm.PurchaseAutomations.Connection:Disconnect()
            DConfiguration.AutoFarm.PurchaseAutomations.Connection = nil
        end
    end
end)

local Dropdown = Tabs.AutoFarm:AddDropdown("SelectedItem", {
    Title = "Select Item",
    Values = ShopItemNames,
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.AutoFarm.PurchaseAutomations.Selected = Value
end)

Tabs.AutoFarm:AddInput("PurchaseAmount", {
    Title = "Purchase Amount",
    Default = "1",
    Placeholder = "1",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.PurchaseAutomations.Amount = tonumber(Value) or 1
    end,
})


Tabs.AutoFarm:AddSection("VIP Automations")

local AutoVote = {
    Enabled = false,
    Map = 1,
    Mode = 1,
    Connections = { Map = nil, Mode = nil }
}

local function getVotePopup()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local shared = playerGui:FindFirstChild("Shared")
    if shared then
        local popups = shared:FindFirstChild("Popups")
        if popups then
            local voteActive = popups:FindFirstChild("VoteActive")
            if voteActive and voteActive.Visible then return voteActive end
            local vote = popups:FindFirstChild("Vote")
            if vote and vote.Visible then return vote end
        end
    end
    return nil
end

local function fireVoteServer(mapNumber)
    if not getVotePopup() then return end
    local voteEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("Vote")
    if voteEvent and voteEvent:IsA("RemoteEvent") then
        voteEvent:FireServer(mapNumber)
    end
end

local function fireVoteMode(modeNumber)
    if not getVotePopup() then return end
    local voteEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("Vote")
    if voteEvent and voteEvent:IsA("RemoteEvent") then
        voteEvent:FireServer(modeNumber, true)
    end
end

local function StartAutoVoteMap()
    if AutoVote.Connections.Map then AutoVote.Connections.Map:Disconnect() end
    AutoVote.Connections.Map = RunService.Heartbeat:Connect(function()
        fireVoteServer(AutoVote.Map)
    end)
end

local function StopAutoVoteMap()
    if AutoVote.Connections.Map then
        AutoVote.Connections.Map:Disconnect()
        AutoVote.Connections.Map = nil
    end
end

local function StartAutoVoteMode()
    if AutoVote.Connections.Mode then AutoVote.Connections.Mode:Disconnect() end
    AutoVote.Connections.Mode = RunService.Heartbeat:Connect(function()
        fireVoteMode(AutoVote.Mode)
    end)
end

local function StopAutoVoteMode()
    if AutoVote.Connections.Mode then
        AutoVote.Connections.Mode:Disconnect()
        AutoVote.Connections.Mode = nil
    end
end

local Toggle = Tabs.AutoFarm:AddToggle("AutoVoteMap", {Title = "Auto Vote Map", Default = false })
Toggle:OnChanged(function(State)
    if State then StartAutoVoteMap() else StopAutoVoteMap() end
end)

local Dropdown = Tabs.AutoFarm:AddDropdown("MapSection", {
    Title = "Map Section",
    Values = {"Map 1", "Map 2", "Map 3", "Map 4"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    local num = tonumber(tostring(Value):match("%d+")) or 1
    AutoVote.Map = num
    DConfiguration.AutoFarm.VIPAutomations.MapSection = num
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoVoteMode", {Title = "Auto Vote Mode", Default = false })
Toggle:OnChanged(function(State)
    if State then StartAutoVoteMode() else StopAutoVoteMode() end
end)

local Dropdown = Tabs.AutoFarm:AddDropdown("GamemodeSection", {
    Title = "Gamemode Section",
    Values = {"Mode 1", "Mode 2", "Mode 3", "Mode 4"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    local num = tonumber(tostring(Value):match("%d+")) or 1
    AutoVote.Mode = num
    DConfiguration.AutoFarm.VIPAutomations.GamemodeSection = num
end)

Tabs.AutoFarm:AddParagraph({Title = " ", Content = ""})

Tabs.AutoFarm:AddInput("MapInput", {
    Title = "Map Input",
    Default = "DesertBus",
    Placeholder = "DesertBus",
    Numeric = false,
    Finished = false,
    Description = "NO SPACE NEEDED",
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.MapInput = Value
    end
})

local Toggle = Tabs.AutoFarm:AddToggle("AutoSetMap", {Title = "Auto Set Map", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoMap = State
    if State then
        DConfiguration.AutoFarm.VIPAutomations.LastMapSet = DConfiguration.AutoFarm.VIPAutomations.LastMapSet or tick()
    end
end)

Tabs.AutoFarm:AddInput("SpecialRoundInput", {
    Title = "Special Round Input",
    Default = "Plushie Hell",
    Placeholder = "Plushie Hell",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.SpecialRoundInput = Value
    end
})

local Toggle = Tabs.AutoFarm:AddToggle("AutoSetSpecialRound", {Title = "Auto Set Special Round", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoSpecialRound = State
    if State then
        DConfiguration.AutoFarm.VIPAutomations.LastSRSet = DConfiguration.AutoFarm.VIPAutomations.LastSRSet or tick()
    end
end)

Tabs.AutoFarm:AddInput("TimerInput", {
    Title = "Timer Input",
    Default = "180",
    Placeholder = "180",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.AutoFarm.VIPAutomations.TimerInput = Value
    end
})

local Dropdown = Tabs.AutoFarm:AddDropdown("TimerRoundState", {
    Title = "Auto Timer Round State",
    Values = {"Round Started", "Intermission", "All"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    local num = tonumber(tostring(Value):match("%d+")) or 1
    if Value == "Round Started" then num = 1
    elseif Value == "Intermission" then num = 2
    elseif Value == "All" then num = 3 end
    DConfiguration.AutoFarm.VIPAutomations.TimerRoundState = num
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoSetTimer", {Title = "Auto Set Timer", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.AutoFarm.VIPAutomations.AutoTimer = State
    if State then
        DConfiguration.AutoFarm.VIPAutomations.LastTimerSet = DConfiguration.AutoFarm.VIPAutomations.LastTimerSet or tick()
    end
end)

-- Cleanup any old per-command connections from previous script versions
pcall(function()
    if DConfiguration.AutoFarm.VIPAutomations.MapConn then
        DConfiguration.AutoFarm.VIPAutomations.MapConn:Disconnect()
        DConfiguration.AutoFarm.VIPAutomations.MapConn = nil
    end
end)
pcall(function()
    if DConfiguration.AutoFarm.VIPAutomations.SRConn then
        DConfiguration.AutoFarm.VIPAutomations.SRConn:Disconnect()
        DConfiguration.AutoFarm.VIPAutomations.SRConn = nil
    end
end)
pcall(function()
    if DConfiguration.AutoFarm.VIPAutomations.TimerConn then
        DConfiguration.AutoFarm.VIPAutomations.TimerConn:Disconnect()
        DConfiguration.AutoFarm.VIPAutomations.TimerConn = nil
    end
end)

-- Unified VIP Admin Command Heartbeat
if DConfiguration.AutoFarm.VIPAutomations.VIPConn then
    pcall(function() DConfiguration.AutoFarm.VIPAutomations.VIPConn:Disconnect() end)
    DConfiguration.AutoFarm.VIPAutomations.VIPConn = nil
end

DConfiguration.AutoFarm.VIPAutomations.VIPConn = RunService.Heartbeat:Connect(function()
    local VIP = DConfiguration.AutoFarm.VIPAutomations
    local svc = ServerStateRegistryService
    if not svc then return end

    local function getState(key)
        if svc.Registry then
            return svc.Registry[key]
        end
        return nil
    end

    local function normalize(str)
        return tostring(str or ""):gsub("%s+", ""):lower()
    end

    local function getMapDisplayName(moduleName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        local mod = mapsFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end

    local function getMapModuleName(displayName)
        local mapsFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("Maps")
        if not mapsFolder then return nil end
        for _, mod in ipairs(mapsFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end

    local function getSpecialRoundDisplayName(moduleName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        local mod = srFolder:FindFirstChild(moduleName)
        if mod and mod:IsA("ModuleScript") then
            local ok, data = pcall(require, mod)
            if ok and data and data.Name then
                return data.Name
            end
        end
        return nil
    end

    local function getSpecialRoundModuleName(displayName)
        local srFolder = ReplicatedStorage:FindFirstChild("Info") and ReplicatedStorage.Info:FindFirstChild("SpecialRounds")
        if not srFolder then return nil end
        for _, mod in ipairs(srFolder:GetChildren()) do
            if mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and data and data.Name then
                    if normalize(data.Name) == normalize(displayName) then
                        return mod.Name
                    end
                end
            end
        end
        return nil
    end

    -- Auto Map
    if VIP.AutoMap and VIP.MapInput and VIP.MapInput ~= "" then
        if tick() - (VIP.LastMapSet or 0) >= 1 then
            local current = getState("Map")
            local desired = VIP.MapInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)

            if nc == nd then
                match = true
            else
                local display = getMapDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                local moduleName = getMapModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end

            if not match then
                local isLoading = getState("MapLoading")
                if type(isLoading) == "string" then
                    else
                    DFunctions.AdminCommand("!Map " .. desired)
                    VIP.LastMapSet = tick()
                end
            end
        end
    end

    -- Auto Special Round
    if VIP.AutoSpecialRound and VIP.SpecialRoundInput and VIP.SpecialRoundInput ~= "" then
        if tick() - (VIP.LastSRSet or 0) >= 1 then
            local current = getState("SpecialRound")
            local desired = VIP.SpecialRoundInput
            local match = false
            local nc = normalize(current)
            local nd = normalize(desired)

            if nc == nd then
                match = true
            else
                local display = getSpecialRoundDisplayName(desired)
                if display and normalize(display) == nc then
                    match = true
                end
                local moduleName = getSpecialRoundModuleName(desired)
                if moduleName and normalize(moduleName) == nc then
                    match = true
                end
            end

            if not match then
                DFunctions.AdminCommand("!SpecialRound " .. desired)
                VIP.LastSRSet = tick()
                end
        end
    end

    -- Auto Voting Bypass
    local isVoting = getState("Voting")
    if isVoting == true and VIP.MapInput and VIP.MapInput ~= "" then
        if tick() - (VIP.LastVotingFire or 0) >= 3 then
            DFunctions.AdminCommand("!Time 1")
            DFunctions.AdminCommand("!Map " .. VIP.MapInput)
            VIP.LastVotingFire = tick()
            end
    end

    -- Auto Timer
    if VIP.AutoTimer and VIP.TimerInput and VIP.TimerInput ~= "" then
        if tick() - (VIP.LastTimerSet or 0) >= 3 then
            local roundStatus = getState("RoundStatus")
            local roundState = VIP.TimerRoundState or 1
            local shouldFire = false
            if roundState == 1 and roundStatus == 2 then
                shouldFire = true
            elseif roundState == 2 and roundStatus ~= 2 then
                shouldFire = true
            elseif roundState == 3 then
                shouldFire = true
            end
            if shouldFire then
                local current = getState("Time")
                local desiredNum = tonumber(VIP.TimerInput)
                if desiredNum and (current == nil or current ~= desiredNum) then
                    DFunctions.AdminCommand("!Time " .. tostring(desiredNum))
                    VIP.LastTimerSet = tick()
                end
            end
        end
    end
end)

wait(Duration)

Tabs.Combat:AddSection("Nextbot Modification")

local Toggle = Tabs.Combat:AddToggle("AntiNextbotToggle", {Title = "Anti Nextbot Toggle", Default = false })
Toggle:OnChanged(function(value)
    DConfiguration.Combat.AntiNextbot = value
    while DConfiguration.Combat.AntiNextbot and task.wait(0.1) do
        DFunctions.AntiNextbot()
    end
end)

local Dropdown = Tabs.Combat:AddDropdown("AntiBotTeleport", {
    Title = "Anti Nextbot Teleport Type",
    Values = {"Spawn", "Players"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Combat.AntiNextbotType = Value
end)

Tabs.Combat:AddInput("NextbotDistance", {
    Title = "Anti Nextbot Distance",
    Default = 15,
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Combat.AntiNextbotRange = tonumber(Value) or 15
    end
})

wait(Duration)

Tabs.Misc:AddSection("Player Adjustments")

Tabs.Misc:AddInput("PlayerSpeed", {
    Title = "Player Speed",
    Description = "Change how fast your character moves.",
    Default = "1500",
    Placeholder = "Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 1500
        DConfiguration.Misc.PlayerAdjustment.Update.Speed = n
        DConfiguration.Misc.PlayerAdjustment.Saved.Speed = n
        DFunctions.setTSpeed(n)
    end
})

Tabs.Misc:AddInput("PlayerJump", {
    Title = "Player Jump",
    Description = "Change how high your character jumps.",
    Default = "3",
    Placeholder = "Jump Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 3
        DConfiguration.Misc.PlayerAdjustment.Update.JumpHeight = n
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpHeight = n
        DFunctions.setTJump(n)
    end
})

Tabs.Misc:AddInput("PlayerJumpAcce", {
    Title = "Player Jump Acceleration",
    Description = "Your speed increases when you jump.",
    Default = "1.45",
    Placeholder = "Jump Acceleration Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 1.45
        DConfiguration.Misc.PlayerAdjustment.Update.JumpAcceleration = n
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpAcceleration = n
        DFunctions.setTJumpAcceleration(n)
    end
})

Tabs.Misc:AddInput("PlayerJumpCap", {
    Title = "Player Jump Cap",
    Description = "Allows air jumping.",
    Default = "1",
    Placeholder = "Jump Cap Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 1
        DConfiguration.Misc.PlayerAdjustment.Update.JumpCap = n
        DConfiguration.Misc.PlayerAdjustment.Saved.JumpCap = n
        DFunctions.setTJumpCap(n)
    end
})

Tabs.Misc:AddInput("PlayerStrafeAcceleration", {
    Title = "Player Strafe Acceleration",
    Description = "Change how fast you move sideways in the air.",
    Default = "182",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local n = tonumber(Value) or 182
        DConfiguration.Misc.PlayerAdjustment.Update.AirStrafe = n
        DConfiguration.Misc.PlayerAdjustment.Saved.AirStrafe = n
        DFunctions.setTAirStrafe(n)
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("PlayerJumpPower", {Title = "Jump Power Toggle", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Humanoids.OriginalJumpHeight = State
    while DConfiguration.Misc.Humanoids.OriginalJumpHeight and task.wait(0.1) do
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = DConfiguration.Misc.Humanoids.JP
        end
    end
end)

Tabs.Misc:AddInput("PlayerJumpPower", {
    Title = "Player Jump Power",
    Default = "20",
    Placeholder = "Jump Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Humanoids.JP = tonumber(Value) or 20
    end
})

local Toggle = Tabs.Misc:AddToggle("PlayerWalkspeed", {Title = "Walkspeed Toggle", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Humanoids.WalkspeedCF = State
    while DConfiguration.Misc.Humanoids.WalkspeedCF and task.wait() do
        local chr = LocalPlayer.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        if chr and hum and hum.MoveDirection.Magnitude > 0 then
            chr:TranslateBy(hum.MoveDirection * DConfiguration.Misc.Humanoids.CF * 0.1)
        end
    end
end)

Tabs.Misc:AddInput("PlayerWalkCf", {
    Title = "Player Walkspeed",
    Default = "5",
    Placeholder = "Walk Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Humanoids.CF = tonumber(Value) or 5
    end
})

Tabs.Misc:AddSection("Utilities")

local Toggle = Tabs.Misc:AddToggle("LagSwitch", {Title = "Lag Switch (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("LagSwitchButton", "Start Lag", 0.15 + DConfiguration.Settings.GuiScale.LagSwitch, 0.1 + DConfiguration.Settings.GuiScale.LagSwitch, function(btn)
            task.spawn(function()
                DFunctions.StartLag(DConfiguration.Misc.Utilities.LagSwitch.MSDelay)
            end)
            btn.Text = "..."
            wait(0.1)
            btn.Text = "Start Lag"
        end)
    else
        DFunctions.DestroyButton("LagSwitchButton")
    end
end)

local Keybind = Tabs.Misc:AddKeybind("LagSwitchKey", {
    Title = "Lag Switch Keybind",
    Mode = "Toggle",
    Default = "H",
    Callback = function()
        task.spawn(function()
            DFunctions.StartLag(DConfiguration.Misc.Utilities.LagSwitch.MSDelay)
        end)
    end,
})

Tabs.Misc:AddInput("LagSwitchButtonSize", {
    Title = "Lag Switch Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.LagSwitch),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.LagSwitch = num * 0.01
        else
            DConfiguration.Settings.GuiScale.LagSwitch = 0
        end
        DFunctions.UpdateButton("LagSwitchButton", 0.15 + DConfiguration.Settings.GuiScale.LagSwitch, 0.1 + DConfiguration.Settings.GuiScale.LagSwitch)
    end
})

Tabs.Misc:AddInput("DelayMS", {
    Title = "Delay MS",
    Default = "200",
    Placeholder = "Value",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.LagSwitch.MSDelay = tonumber(Value) or 200
    end
})

local Dropdown = Tabs.Misc:AddDropdown("LagMode", {
    Title = "Lag Mode",
    Values = {"Normal", "Demon", "FastFlag"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.Utilities.LagSwitch.Mode = Value
end)

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("AdjustBounce", {Title = "Modify Bounce", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Utilities.BounceModification.Enabled = State
    while DConfiguration.Misc.Utilities.BounceModification.Enabled and task.wait(0.1) do
        DFunctions.BounceFunction()
    end
end)

local Toggle = Tabs.Misc:AddToggle("SuperBounce", {Title = "Super Bounce", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("SuperBounceButton", "Super Bounce", 0.1 + DConfiguration.Settings.GuiScale.SuperBounce, 0.1 + DConfiguration.Settings.GuiScale.SuperBounce, function(btn)
            DFunctions.SuperBounce()
            btn.Text = "..."
            wait(0.1)
            btn.Text = "Super Bounce"
        end)
    else
        DFunctions.DestroyButton("SuperBounceButton")
    end
end)

Tabs.Misc:AddInput("PlayerBounce", {
    Title = "Player Bounce",
    Default = "80",
    Placeholder = "Bounce Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.BounceModification.DefaultBounce = tonumber(Value) or 80
    end
})

Tabs.Misc:AddInput("EmoteBounce", {
    Title = "Emote Bounce",
    Default = "120",
    Placeholder = "Bounce Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.BounceModification.EmoteBounce = tonumber(Value) or 120
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("AdjustEdgeTrimp", {Title = "Modify Edge Trimp", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.Utilities.EdgeTrimpModification.Enabled = State
    while DConfiguration.Misc.Utilities.EdgeTrimpModification.Enabled and task.wait(0.1) do
        DFunctions.ModifyEdgeTrimp()
    end
end)

Tabs.Misc:AddInput("EdgeTrimpHeight", {
    Title = "Height Multiplier",
    Default = "1.5",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.EdgeTrimpModification.HeightMultiplier = tonumber(Value) or 1.5
    end
})

Tabs.Misc:AddInput("DownThreshold", {
    Title = "Falling Threshold",
    Default = "4.5",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.Utilities.EdgeTrimpModification.DownThreshold = tonumber(Value) or 4.5
    end
})

Tabs.Misc:AddSection("Camera Adjustments")

Tabs.Misc:AddInput("CamX", {
    Title = "Stretch Horizontal",
    Default = "1",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.CameraAdjustment.StretchX = tonumber(Value) or 1
    end
})

Tabs.Misc:AddInput("CamY", {
    Title = "Stretch Vertical",
    Default = "1",
    Placeholder = "Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.CameraAdjustment.StretchY = tonumber(Value) or 1
    end
})

Tabs.Misc:AddInput("PlayerFOV", {
    Title = "Player FOV",
    Default = "1",
    Placeholder = "Number (multiplier)",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local mult = tonumber(Value) or 1
        if CameraService and CameraService.AdjustFOV then
            CameraService:AdjustFOV("ElderwyrmCustomFOV", mult)
        end
    end
})

Tabs.Misc:AddButton({
    Title = "Set Camera Stretch",
    Description = "(Warning: Stretch settings can make billboards look weird or disappear from far away.)",
    Callback = function()
        LocalPlayer:SetAttribute("StretchX", DConfiguration.Misc.CameraAdjustment.StretchX)
        LocalPlayer:SetAttribute("StretchY", DConfiguration.Misc.CameraAdjustment.StretchY)
    end
})

Tabs.Misc:AddButton({
    Title = "Enable Front Camera",
    Description = "",
    Callback = function()
    end
})

Tabs.Misc:AddSection("Gun Adjustments")

Tabs.Misc:AddButton({
    Title = "Set to Infinite Ammo",
    Description = " ",
    Callback = function()
        local Tools = ReplicatedStorage:FindFirstChild("Tools")
        if not Tools then return end
        for _, tool in ipairs(Tools:GetChildren()) do
            if tool:IsA("ModuleScript") then
                local success, module = pcall(require, tool)
                if success and module and module.Tasks then
                    for _, task in ipairs(module.Tasks) do
                        if task.ResourceInfo and task.ResourceInfo.Type == "Clip" then
                            task.ResourceInfo.Reserve = 9999999999
                            task.ResourceInfo.Cap = 9999999999
                        end
                    end
                end
            end
        end
    end
})

Tabs.Misc:AddButton({
    Title = "Set to Infinite Range",
    Description = " ",
    Callback = function()
        local function setInfiniteRange(data)
            if type(data) ~= "table" then return end
            for key, value in pairs(data) do
                if (key == "Range" or key == "LungeRange" or key == "HearingRange") and type(value) == "number" then
                    data[key] = math.huge
                elseif key == "DamageDistanceInterval" and type(value) == "table" and #value >= 2 then
                    value[2] = math.huge
                elseif type(value) == "table" then
                    setInfiniteRange(value)
                end
            end
        end

        local Tools = ReplicatedStorage:FindFirstChild("Tools")
        if not Tools then return end
        for _, tool in pairs(Tools:GetChildren()) do
            if tool:IsA("ModuleScript") then
                local success, toolData = pcall(require, tool)
                if success and type(toolData) == "table" and toolData.Tasks then
                    for _, task in ipairs(toolData.Tasks) do
                        for _, func in ipairs(task.Functions or {}) do
                            for _, activation in ipairs(func.Activations or {}) do
                                for _, method in ipairs(activation.Methods or {}) do
                                    if method.Info then setInfiniteRange(method.Info) end
                                end
                            end
                        end
                        for _, autoFunc in ipairs(task.AutomaticFunctions or {}) do
                            for _, method in ipairs(autoFunc.Methods or {}) do
                                if method.Info then setInfiniteRange(method.Info) end
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.Misc:AddButton({
    Title = "No Cooldown",
    Description = " ",
    Callback = function()
        local function setFastShoot(data)
            if type(data) ~= "table" then return end
            for key, value in pairs(data) do
                if key == "Cooldown" and type(value) == "number" then
                    data[key] = 1/65536
                elseif type(value) == "table" then
                    setFastShoot(value)
                end
            end
        end

        local Tools = ReplicatedStorage:FindFirstChild("Tools")
        if not Tools then return end
        for _, tool in pairs(Tools:GetChildren()) do
            if tool:IsA("ModuleScript") then
                local success, toolData = pcall(require, tool)
                if success and type(toolData) == "table" and toolData.Tasks then
                    for _, task in ipairs(toolData.Tasks) do
                        for _, func in ipairs(task.Functions or {}) do
                            for _, activation in ipairs(func.Activations or {}) do
                                for _, method in ipairs(activation.Methods or {}) do
                                    if method.Info then setFastShoot(method.Info) end
                                end
                            end
                        end
                        for _, autoFunc in ipairs(task.AutomaticFunctions or {}) do
                            for _, method in ipairs(autoFunc.Methods or {}) do
                                if method.Info then setFastShoot(method.Info) end
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.Misc:AddSection("Game Automations")
local Toggle = Tabs.Misc:AddToggle("AutoCarry", {Title = "Auto Carry (Button)", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("AutoCarryGui", "Auto Carry: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoCarry, 0.1 + DConfiguration.Settings.GuiScale.AutoCarry, function(btn)
            DConfiguration.Misc.GameAutomation.Carry.FloatingButton = not DConfiguration.Misc.GameAutomation.Carry.FloatingButton
            btn.Text = DConfiguration.Misc.GameAutomation.Carry.FloatingButton and "Auto Carry: ON" or "Auto Carry: OFF"
            if DConfiguration.Misc.GameAutomation.Carry.FloatingButton then
                DFunctions.StartAutoCarry()
            else
                DFunctions.StopAutoCarry()
            end
        end)
    else
        DFunctions.StopAutoCarry()
        DFunctions.DestroyButton("AutoCarryGui")
    end
end)

local Toggle = Tabs.Misc:AddToggle("EmoteCarry", {Title = "Carry While Emote", Default = false})
Toggle:OnChanged(function(State)
    DConfiguration.Misc.GameAutomation.Carry.WhileEmote = State
end)

local Keybind = Tabs.Misc:AddKeybind("KeybindCarry", {
    Title = "Keybind to Carry",
    Mode = "Toggle",
    Default = "Q",
    Callback = function(Bool)
        DConfiguration.Misc.GameAutomation.Carry.Keybind = Bool
    end,
})

Tabs.Misc:AddInput("CarryButtonSize", {
    Title = "Auto Carry Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoCarry),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoCarry = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoCarry = 0
        end
        DFunctions.UpdateButton("AutoCarryGui", 0.15 + DConfiguration.Settings.GuiScale.AutoCarry, 0.1 + DConfiguration.Settings.GuiScale.AutoCarry)
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

wait(Duration)

local Toggle = Tabs.Misc:AddToggle("AutoEmote", {Title = "Auto Emote Dash Button", Default = false})
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("EmoteDashButton", "Start Emote", 0.15 + DConfiguration.Settings.GuiScale.AutoEmoteDash, 0.1 + DConfiguration.Settings.GuiScale.AutoEmoteDash, function(btn)
            btn.Text = "Emoting..."
            DFunctions.AutoEmoteDash()
            task.wait(0.15)
            btn.Text = "Start Emote"
        end)
    else
        DFunctions.DestroyButton("EmoteDashButton")
    end
end)

Tabs.Misc:AddInput("EmoteButtonSize", {
    Title = "Auto Emote Dash Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoEmoteDash),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoEmoteDash = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoEmoteDash = 0
        end
        DFunctions.UpdateButton("EmoteDashButton", 0.15 + DConfiguration.Settings.GuiScale.AutoEmoteDash, 0.1 + DConfiguration.Settings.GuiScale.AutoEmoteDash)
    end
})

local Keybind = Tabs.Misc:AddKeybind("KeyEmoteDash", {
    Title = "Keybind to Emote Dash",
    Mode = "Toggle",
    Default = "RightControl",
    Callback = function(Bool)
        DConfiguration.Misc.GameAutomation.Macro.Keybind = Bool
        if Bool then
            DFunctions.AutoEmoteDash()
        end
    end,
})

local Dropdown = Tabs.Misc:AddDropdown("EmoteID", {
    Title = "Select Emote ID",
    Values = EmoteNames,
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.GameAutomation.Macro.SelectedEmote = Value
end)

Tabs.Misc:AddSection("Movement Modification")

local Toggle = Tabs.Misc:AddToggle("AggressiveEmoteDash", {Title = "Aggressive Emote Dash", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Enabled = State
    DFunctions.AggressiveEmoteDashFunction()
end)

local Dropdown = Tabs.Misc:AddDropdown("AggressiveEmoteType", {
    Title = "Aggressive Emote Type",
    Values = {"Legit", "Blatant"},
    Multi = false,
    Default = 2,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Type = Value
    DFunctions.AggressiveEmoteDashFunction()
end)

Tabs.Misc:AddInput("EmoteSpeed", {
    Title = "Aggressive Emote Speed",
    Default = "2000",
    Placeholder = "Emote Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Speed = tonumber(Value) or 2000
        DFunctions.AggressiveEmoteDashFunction()
    end
})

Tabs.Misc:AddInput("CrouchSpeedAgg", {
    Title = "Aggressive Emote Acceleration (Negative Only)",
    Default = "-2",
    Placeholder = "Acceleration Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.AggressiveEmoteDash.Acceleration = tonumber(Value) or -2
        DFunctions.AggressiveEmoteDashFunction()
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("InfiniteSlide", {Title = "Infinite Slide", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.SlideModification.Enabled = State
    DFunctions.InfiniteSlideFunction()
end)

local Toggle = Tabs.Misc:AddToggle("InfiniteSlideButton", {Title = "Infinite Slide (Button)", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("InfiniteSlideButton", "Infinite Slide: OFF", 0.15 + DConfiguration.Settings.GuiScale.InfiniteSlide, 0.1 + DConfiguration.Settings.GuiScale.InfiniteSlide, function(btn)
            DConfiguration.Misc.MovementModification.SlideModification.FloatingButton = not DConfiguration.Misc.MovementModification.SlideModification.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.SlideModification.FloatingButton and "Infinite Slide: ON" or "Infinite Slide: OFF"
            DConfiguration.Misc.MovementModification.SlideModification.Enabled = DConfiguration.Misc.MovementModification.SlideModification.FloatingButton
        end)
    else
        DFunctions.DestroyButton("InfiniteSlideButton")
    end
end)

Tabs.Misc:AddInput("InfiniteSlideButtonSize", {
    Title = "Infinite Slide Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.InfiniteSlide),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.InfiniteSlide = num * 0.01
        else
            DConfiguration.Settings.GuiScale.InfiniteSlide = 0
        end
        DFunctions.UpdateButton("InfiniteSlideButton", 0.15 + DConfiguration.Settings.GuiScale.InfiniteSlide, 0.1 + DConfiguration.Settings.GuiScale.InfiniteSlide)
    end
})

Tabs.Misc:AddInput("SlideSpeed", {
    Title = "Slide Speed (Negative Only)",
    Default = "-3",
    Placeholder = "Crouch Speed Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.SlideModification.Acceleration = tonumber(Value) or -3
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local NormalGravity = game.Workspace.Gravity

local Toggle = Tabs.Misc:AddToggle("GravityToggle", {Title = "Gravity Button", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("GravityGui", "Gravity: OFF", 0.15 + DConfiguration.Settings.GuiScale.Gravity, 0.1 + DConfiguration.Settings.GuiScale.Gravity, function(btn)
            DConfiguration.Misc.MovementModification.Gravity.FloatingButton = not DConfiguration.Misc.MovementModification.Gravity.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.Gravity.FloatingButton and "Gravity: ON" or "Gravity: OFF"
            if DConfiguration.Misc.MovementModification.Gravity.FloatingButton then
                task.spawn(function()
                    while DConfiguration.Misc.MovementModification.Gravity.FloatingButton do
                        workspace.Gravity = DConfiguration.Misc.MovementModification.Gravity.Value
                        task.wait(0.1)
                    end
                    workspace.Gravity = NormalGravity
                end)
            else
                workspace.Gravity = NormalGravity
            end
        end)
    else
        DConfiguration.Misc.MovementModification.Gravity.FloatingButton = false
        workspace.Gravity = NormalGravity
        DFunctions.DestroyButton("GravityGui")
    end
end)

Tabs.Misc:AddInput("GravityButtonSize", {
    Title = "Gravity Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.Gravity),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.Gravity = num * 0.01
        else
            DConfiguration.Settings.GuiScale.Gravity = 0
        end
        DFunctions.UpdateButton("GravityGui", 0.15 + DConfiguration.Settings.GuiScale.Gravity, 0.1 + DConfiguration.Settings.GuiScale.Gravity)
    end
})

local Keybind = Tabs.Misc:AddKeybind("GravitKey", {
    Title = "Gravity Keybind",
    Mode = "Toggle",
    Default = "J",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.Gravity.Keybind = Bool
        if Bool then
            workspace.Gravity = DConfiguration.Misc.MovementModification.Gravity.Value
        else
            workspace.Gravity = NormalGravity
        end
    end,
})

Tabs.Misc:AddInput("GravityAdjust", {
    Title = "Gravity Adjustment",
    Default = "10",
    Placeholder = " Number",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.Gravity.Value = tonumber(Value) or 10
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("BHOPToggle", {Title = "BHOP", Default = false })
Toggle:OnChanged(function(State)
    DFunctions.ToggleBhop(State)
end)

local Toggle = Tabs.Misc:AddToggle("BHOPHoldJump", {Title = "BHOP Hold Jump", Default = false })
Toggle:OnChanged(function(State)
    DFunctions.ToggleBhopHold(State)
end)

local Toggle = Tabs.Misc:AddToggle("ShowBHOPButton", {Title = "Show BHOP Button", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("BHOPGui", "BHOP: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoJump, 0.1 + DConfiguration.Settings.GuiScale.AutoJump, function(btn)
            local on = not DConfiguration.Misc.MovementModification.BHOP.Enabled
            DFunctions.ToggleBhop(on)
            btn.Text = on and "BHOP: ON" or "BHOP: OFF"
        end)
    else
        DFunctions.DestroyButton("BHOPGui")
    end
end)

local Keybind = Tabs.Misc:AddKeybind("KeybindBHOP", {
    Title = "Keybind to BHOP",
    Mode = "Toggle",
    Default = "B",
    Callback = function(Bool)
        DFunctions.ToggleBhop(Bool)
    end,
})

Tabs.Misc:AddInput("BHOPButtonSize", {
    Title = "BHOP Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoJump),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoJump = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoJump = 0
        end
        DFunctions.UpdateButton("BHOPGui", 0.15 + DConfiguration.Settings.GuiScale.AutoJump, 0.1 + DConfiguration.Settings.GuiScale.AutoJump)
    end
})

local Dropdown = Tabs.Misc:AddDropdown("BHOPVersion", {
    Title = "BHOP Mode",
    Values = {"Acceleration", "No Acceleration"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DFunctions.SetAccelerationMethod(Value)
end)

local Dropdown = Tabs.Misc:AddDropdown("JumpType", {
    Title = "Auto Jump Mode",
    Values = {"Simulation", "Realistic"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.BHOP.Settings.JumpType = Value
    DFunctions.BHOPFunction()
end)

local Toggle = Tabs.Misc:AddToggle("BackwardBHOP", {Title = "BHOP Backwards", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.BHOP.Settings.Backwards = State
end)

local Toggle = Tabs.Misc:AddToggle("SpiderHop", {Title = "Spider Hop (Beta)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.BHOP.Settings.SpiderHop = State
    DFunctions.BHOPFunction()
end)

Tabs.Misc:AddInput("BHOPAcceleration", {
    Title = "BHOP Acceleration (Negative Only)",
    Default = "-0.1",
    Placeholder = "-1",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.Acceleration = tonumber(Value) or -0.1
        DFunctions.BHOPFunction()
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("BHOPAutoAccelerate", {Title = "Auto Acceleration (Legit)", Default = false })
Toggle:OnChanged(function(State)
    DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.Enabled = State
    DFunctions.BHOPFunction()
end)

Tabs.Misc:AddInput("AutoAccelerationMaxAccel", {
    Title = "Max Acceleration",
    Default = "3",
    Placeholder = "3",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.MaxAccelerate = tonumber(Value) or 3
        DFunctions.BHOPFunction()
    end
})

Tabs.Misc:AddInput("AutoAccelerationMinAccel", {
    Title = "Min Acceleration",
    Default = "-1",
    Placeholder = "-1",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.MinAccelerate = tonumber(Value) or -1
        DFunctions.BHOPFunction()
    end
})

Tabs.Misc:AddInput("AutoAccelerationMaxSpeed", {
    Title = "Max Speed",
    Default = "70",
    Placeholder = "70",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.BHOP.Settings.AutoAcceleration.MinSpeed = tonumber(Value) or 70
    end
})

Tabs.Misc:AddParagraph({Title = " ", Content = ""})

local Toggle = Tabs.Misc:AddToggle("AutoCrouch", {Title = "Auto Crouch (Button)", Default = false })
Toggle:OnChanged(function(State)
    if State then
        DFunctions.CreateButton("AutoCrouchGui", "Auto Crouch: OFF", 0.15 + DConfiguration.Settings.GuiScale.AutoCrouch, 0.1 + DConfiguration.Settings.GuiScale.AutoCrouch, function(btn)
            DConfiguration.Misc.MovementModification.Crouch.FloatingButton = not DConfiguration.Misc.MovementModification.Crouch.FloatingButton
            btn.Text = DConfiguration.Misc.MovementModification.Crouch.FloatingButton and "Auto Crouch: ON" or "Auto Crouch: OFF"
            if DConfiguration.Misc.MovementModification.Crouch.FloatingButton then
                task.spawn(function()
                    while DConfiguration.Misc.MovementModification.Crouch.FloatingButton do
                        DFunctions.CrouchFunction()
                        task.wait(0.05)
                    end
                end)
            end
        end)
    else
        DConfiguration.Misc.MovementModification.Crouch.FloatingButton = false
        DFunctions.DestroyButton("AutoCrouchGui")
    end
end)

local Keybind = Tabs.Misc:AddKeybind("KeybindCrouch", {
    Title = "Keybind to Auto Crouch (Hold)",
    Mode = "Hold",
    Default = "RightControl",
    Callback = function(Bool)
        DConfiguration.Misc.MovementModification.Crouch.Keybind = Bool
        if Bool then
            task.spawn(function()
                while DConfiguration.Misc.MovementModification.Crouch.Keybind do
                    DFunctions.CrouchFunction()
                    task.wait(0.05)
                end
            end)
        end
    end,
})

Tabs.Misc:AddInput("CrouchButtonSize", {
    Title = "Auto Crouch Gui Size",
    Default = tostring(DConfiguration.Settings.GuiScale.AutoCrouch),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            DConfiguration.Settings.GuiScale.AutoCrouch = num * 0.01
        else
            DConfiguration.Settings.GuiScale.AutoCrouch = 0
        end
        DFunctions.UpdateButton("AutoCrouchGui", 0.15 + DConfiguration.Settings.GuiScale.AutoCrouch, 0.1 + DConfiguration.Settings.GuiScale.AutoCrouch)
    end
})

local Dropdown = Tabs.Misc:AddDropdown("CrouchType", {
    Title = "Select Crouch Type",
    Values = {"Rapid", "Ground", "Air", "Normal"},
    Multi = false,
    Default = 1,
})
Dropdown:OnChanged(function(Value)
    DConfiguration.Misc.MovementModification.Crouch.Type = Value
end)

Tabs.Misc:AddInput("CrouchDebounce", {
    Title = "Crouch Speed",
    Default = "0.1",
    Placeholder = "0.1",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Misc.MovementModification.Crouch.debounce = tonumber(Value) or 0.1
    end
})

Tabs.Visual:AddParagraph({
    Title = "Warning: Do not use locked emotes from the emote changer or you may get banned easily",
    Content = ""
})

Tabs.Visual:AddParagraph({
    Title = "To change it back to the original, please rejoin.",
    Content = ""
})

Tabs.Visual:AddSection("Cosmetics Changer")

Tabs.Visual:AddInput("CurrentCosmetic", {
    Title = "Current Cosmetic",
    Default = "",
    Placeholder = "Cosmetic name",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.OriginalCosmetics.Cosmetics1 = Value
    end
})

Tabs.Visual:AddInput("NewCosmetic", {
    Title = "New Cosmetic",
    Default = "",
    Placeholder = "Cosmetic name",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        DConfiguration.Visual.ModifyCosmetics.Cosmetics1 = Value
    end
})

Tabs.Visual:AddButton({
    Title = "Swap Cosmetics",
    Description = "Swap current cosmetic with new cosmetic",
    Callback = function()
        local cur = DConfiguration.Visual.OriginalCosmetics.Cosmetics1
        local neu = DConfiguration.Visual.ModifyCosmetics.Cosmetics1
        if cur and neu and cur ~= "" and neu ~= "" then
            DFunctions.ChangeCosmetics(cur, neu)
        end
    end
})

Tabs.Visual:AddButton({
    Title = "Reset Cosmetics",
    Description = "Restore all cosmetic swaps",
    Callback = function()
        DFunctions.RestoreCosmetics()
    end
})

Tabs.Visual:AddSection("Emote Changer")

for i = 1, 12 do
    DConfiguration.Visual.CurrentEmotes[i] = DConfiguration.Visual.CurrentEmotes[i] or ""
    Tabs.Visual:AddInput("CurrentEmote_" .. i, {
        Title = "Current Emote " .. i,
        Default = "",
        Placeholder = "Emote name or ID",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            DConfiguration.Visual.CurrentEmotes[i] = Value
            DConfiguration.Visual.OriginalEmotes["Emote" .. i] = Value
        end
    })
end

Tabs.Visual:AddParagraph({ Title = " ", Content = "" })

for i = 1, 12 do
    DConfiguration.Visual.SelectEmotes[i] = DConfiguration.Visual.SelectEmotes[i] or ""
    Tabs.Visual:AddInput("SelectEmote_" .. i, {
        Title = "Select Emote " .. i,
        Default = "",
        Placeholder = "Emote name or ID",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            DConfiguration.Visual.SelectEmotes[i] = Value
            DConfiguration.Visual.ModifyEmotes["Emote" .. i] = Value
        end
    })
end

Tabs.Visual:AddButton({
    Title = "Apply Emote Mappings",
    Description = "Build mapping and start emote watcher",
    Callback = function()
        DFunctions.BuildEmoteMapping()
        DFunctions.StartEmoteWatcher()
    end
})

Tabs.Visual:AddButton({
    Title = "Reset Emote Mappings",
    Description = "Stop watcher and clear mappings",
    Callback = function()
        DFunctions.ResetEmoteChanges()
    end
})

Tabs.Info:AddParagraph({
    Title = "Elderwyrm Hub X / Overhaul Script",
    Content = "Created by Vraigos"
})

Tabs.Info:AddParagraph({
    Title = "Adjustments / Movement Modification",
    Content = "Created by Vraigos and Aerave"
})

Tabs.Info:AddParagraph({
    Title = "Adjustments / ESP / Legacy Script",
    Content = "Created by Aerave"
})

Tabs.Info:AddButton({
    Title = "Join Discord",
    Description = "Tap to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/zvhjwgVVbR")
        end
    end
})

Tabs.Info:AddParagraph({
    Title = "UI: Fluent",
    Content = "Created by dawidscripts"
})

Tabs.Settings:AddParagraph({
    Title = "Configuration",
    Content = " "
})

Tabs.Settings:AddButton({
    Title = "Remove FPS Counter",
    Description = "",
    Callback = function()
        if fpsCounter then
            fpsCounter:Destroy()
        end
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
FBM:SetLibrary(Fluent)

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("ElderwyrmHubXUniversal")
FBM:SetFolder("ElderwyrmHubXUniversal/Evade/FloatingButtons")
SaveManager:SetFolder("ElderwyrmHubXUniversal/Evade")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
FBM:BuildConfigSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

local ExtensionLoaded = false

Tabs.Extension:AddButton({
    Title = "Load Extension",
    Description = "Not all the scripts here are ours. Some are recommendations from this tab.",
    Callback = function()
        Window:Dialog({
            Title = "WARNING",
            Content = "Extension loading is currently unavailable.",
            Buttons = {
                {
                    Title = "OK",
                    Callback = function() end
                },
            },
        })
    end
})

local tadaSound = Instance.new("Sound")
tadaSound.SoundId = "rbxassetid://131653558869295"
tadaSound.Parent = game:GetService("SoundService")
tadaSound.Volume = 6
tadaSound:Play()
tadaSound.Ended:Connect(function() tadaSound:Destroy() end)
print("[Elderwyrm Hub X] Loaded.")
end