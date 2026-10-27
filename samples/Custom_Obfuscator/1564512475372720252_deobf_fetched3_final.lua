-- ============================================================
-- DEOBFUSCATED: fetched.lua_3.txt
-- Original comment: Bro come on, its free and keyless really?
-- ============================================================
-- Passes applied:
--   1. Arithmetic simplification: (14+10) -> 24  [3515 expressions]
--   2. String decryption: AHs(N) -> "plaintext"  [189 calls, 81 strings]
--   3. Dead code removal: if N*(N+1)%2==1 (always false) [327 blocks]
--   4. Lua formatting: semicolons -> newlines + indentation
-- 
-- Variable names are still obfuscated (VM/custom renamer).
-- This is a custom Lua VM (likely IronBrew2/Luyu style).
-- The bytecode payload (table_C ~pos 54885) remains encrypted.
-- ============================================================

local qOV=function(t,s,v,d)
    local r={}
    local k=s for i=1,#t do
        r[i]=string.char((((t[i]-k)%256)*v)%256)
        k=(k+t[i]+d)%256
    end
return table.concat(r)
end
local Lh={{{223,21,31,60,111,128,170,78,151,144,99,24,215,88,173,166,76,61,204},165,253,167},{{84,208,188,175,122,27,115,253},223,1,42},{{228,118,250,110,114,26,242,3},215,45,213},{{219,236,128,215,68,155,1,253,108,91,94,28,51,37,81},229,43,102},{{14,122,212,118,71,43,188,66,0},130,187,87},{{91},190,157,205},{{2,174,24,36,23,231},44,187,218},{{253,82,93,116,2,4,114,89,229,8,194,85,38,67,63,29,208,21,145,52,51,75,88,247,99,72,117,13,238,255},186,227,97},{{106,90,137,150,80,254,208,249,45,26,64,247,77,150,157,15,20,100,235,14,62,238,236,212,6,48,230},157,13,173},{{157,168,122,255,116,66},235,91,163},{{71},203,17,116},{{166,133,164,227,193,99,17,120,4,39,225,116,69,98,94,60,239,52,167,56,19,78,242,35,110,39,64,62},99,227,66},{{148,190,23,238,124,214,220,127,59,74,44,107,160,209,61,83,50,43,187,176,236,254,141,138,39,223,54,166,52,100},229,103,227},{{42,14,19,86,106,134},247,193,121},{{210,174,63,218,112,82,48,31,203,86,64,187,132,57,85,67,14,171,210,61,193},39,59,75},{{127,212,113,126,184,190,40,13,113,74,152,193,4,235,159,153,50,17,247,44,127},70,177,65},{{235,19,244,148,96,253,152,244,66,71,35,184,206,122,136,77,12,32,236},199,53,119},{{174},215,217,163},{{190,21,90,182,194,29,26,222,64,131,7,58,148,7,184,181,49,79,34,71,218,203,198,33,118},66,195,111},{{171,67,111,220,207,190,114,60,189,244,207,64,53,236,155,165,78,151,134,72,185,109,222,113,50,168,33,56,9,241,151},5,201,46},{{184,119,155,112,238,157,233,220},167,245,34},{{43,202,166,233,180,88,19,162,52,171,104,192,84,214,218,39,62,101,225,187,212,76,94,144,2,209,35,248,92,161,112,5,51,224,3,232,240,14},193,37,219},{{43,223,213,127,200,233,223,147,32,200,120,186,205,72,35,93,169},44,159,89},{{1,32,169,230,128,86,208,157,33,2,64,216,106,48,45,232,138},192,41,161},{{239,156,126,162,146,220,160,116,102,150,67,33,137,78,65,190,71},37,159,89},{{39,245,71,122,111,172,98,137,217,79,240,1,7,57,230,85,34,81,112,52},75,111,40},{{11,126,109},63,53,239},{{75,232,230,174,221,86,5},163,69,22},{{1,150,136,152},34,215,67},{{116,1,48,95,67,253},14,109,86},{{103,248,219,2,176,50,96,231,243,54,176,99,148,195,42,168,9,102,243,187,13,18,187,93,228,238},4,195,147},{{29,49,218,77,147,197,211,90,230,105,99,86,71,4,128,30,225,198,198,215,163,141,144},122,131,32},{{120,61,126,23,233,55,89,154,46,83,9,62,5,222,191,81,104,163,46,136,153,5,38,153,127,111},115,21,28},{{197,194,91,144,4,116,114},143,177,121},{{176,62,117,222,208,54,240,45,241,66,160,130,226,171,128,195,37,112},255,57,177},{{209,179,234,114,38,93,174,66,172,123,15,142,80,15,4,117,225,119,134},101,167,63},{{247,142,94,84,234,108,26,204,218},51,191,109},{{152,95,206,234,110,11,246,210,0,149,49,86,76,49,72,115,215,41,174,241,182,141,42,103},52,165,137},{{46,223,250,137,7,249,183,6,178,221,135,228,9,177,181,209,245,0,17,252,178,145,89,195,161,111,173,173,36},227,155,164},{{49,183,122,23,241,79,145,18,38,75,1,54,253,152,60,46,67,118,105,26,235,234,179,52,91,170,156,251},44,21,36},{{110,36,197,31},218,23,137},{{104,88,203},204,153,243},{{245,26,97,12,66,188,178,221,185,176,194,105,22,95,235,17,88,41,58,181,144,165,51,162,112,28,96,1},94,255,53},{{247,196,226,32,154},211,23,91},{{153,86,211,200,179,87,55,147,139,98,131,153,172,229,186,150,132,143,236,136,47,233,95,18},125,251,138},{{204,175,77,69,232,123,67,52,169,18,78,145,210,247,87,73},36,185,84},{{95,232,152,116,149,118,35,0,117,199},245,37,131},{{53,180,94},169,229,65},{{68,45,172,98,4,48,11,120,192,19,77,184,241,22,114,0,219,232,226,93,131,159,19,48},24,43,46},{{215,44,142,172,196,211,66,174,194,33,77,232,178,168,200,11,82,19,137,162},138,171,105},{{0,206,164},12,251,55},{{70},91,169,179},{{134,34,121,87,16,55,254,141,20,154},93,239,84},{{78,178},37,121,41},{{10,171,204,80,12,175,4,40,122,165,9,164,46,9,50,71,227,17,76,73,101,16,183,15,148,219},110,155,189},{{223,160,219,170,168,154,88,167,83,126,40,67,236,163,210,96,185,46,83,72,190,46,67,56,82,134,10},148,155,3},{{107,113,22,242,207,144,142,197,51},46,35,147},{{179,174,105,196,90,68,234,13,73,152,250,147,136,226,25,63,191,185,2,227,217,158},196,39,85},{{69,252,147,138,216,10,168,135,115,238,248,174,206,14,2,193,46,233,232,18,249,18,125,160,4,98,47,215},170,75,131},{{60,147,173,56,255},48,159,40},{{13,68,43,252,242,159,109},189,97,142},{{203,89,138,194,238,159,38,114,120,209,29,70,52,29,96,199,123,117,126,221,111,4,15,11,149,206},23,49,101},{{55,199,40,249,175,12,113},33,51,154},{{153,198,189,104,158,216,142,25,117,76,158,243,15,136,156,220,76,25,167,102,55,134,176,244,206,98,104,67,224},34,31,57},{{252,104},27,203,175},{{11,180,97,246,64,214,112,45,113,130,96,12,53,82,66,254,194,106,59,51,121,110,86,148,14,152,242,242,39},154,121,177},{{232,69,199,126,9,183,189,97,176,92,7,177,114,231,172,158,82,73,149,46,45,152,53,232,70,55,78,27,1,41,57,23,39,151,2,244,195,119,232,157,71,162,159,179,163,54,121,151,201,235,75,75,194,41,133,238,255,11,167,63,186,53,167,62,106,18,41,208},48,27,250},{{163,46,143,124,118,12,6,211,87,56,118,220,247,208,59,77,86,248,172,8,79},98,41,107},{{100,127,252,157,127,77,15,192,20,233,63,193,156,97,60,199,249,22,19,46,24,221,161,102,245,74,238,91,218},175,101,150},{{63,78,153,30,153,171},208,109,161},{{105,111,121,49,83},252,3,239},{{14,16,20,28,44},56,133,244},{{32,0,115,236,254,52,126,99,71,96,46,219,127,72,216,112,33,104,128,81,252},167,113,235},{{72,70,54,85,222,11,231,197,72,237,237,144,115,202,116,120,124,196,197,194,169,31,80},86,67,121},{{42,163,144,69,207,165,255,28,224,209,239,201,205,156,1,220,249,32,163,57,213,65,152},217,153,2},{{75,94,111,133,142,188,118,234,243,174},208,109,200},{{231,122,194,158,66,158,83,130},249,165,9},{{127,200,151,146,104,162,152,131,95,22,168,15,252,133,17,183,190,207,219,18,181,109,38,233,37,13,244,223,87,55,190},40,63,15},{{97,106,111,76,38,108,86,59,159,120,198,239,50,25,205,199,80,47,112,68,32,112,146,84,145,244},40,177,19},{{124,232,51,201,84,104,121,196,149,96,36,141,132,156,155,176,149,120,200,50,137,2,103,72,244,170,114},114,11,123},{{29,8,68,62,176,22,96,118,32,246,32,246,32,246,32,246,32,246,32,246,32,246,32,246,32,246,32,246,32,246,32,246,32},209,213,117}}
local lH={}
local function AHs(i)
    local x=lH[i]
    if x==nil then
        local e=Lh[i]
        x=qOV(e[1],e[2],e[3],e[4])
        lH[i]=x
    end
return x
end
local LYT do
    local Ky2,AaV,nq local KK5k,ci0=pcall(function()if type(typeof)~="function"or type(Instance)~="table"or type(Instance.new)~="function"then
            return false
        end
    if type(game)~="userdata"or typeof(game)~="Instance"or game.ClassName~="DataModel"or not game:IsA"DataModel"then
        return false
    end
local q83=game:GetService"RunService"if typeof(q83)~="Instance"or not q83:IsA"RunService"or q83 .Parent~=game then
    return false
end
if q83~=game:GetService"RunService"or type(q83:IsStudio())~="boolean"then
    return false
end
if typeof(q83 .Heartbeat)~="RBXScriptSignal"then
    return false
end
local IPv4=game:GetService"Players"if typeof(IPv4)~="Instance"or not IPv4:IsA"Players"or IPv4 .Parent~=game then
    return false
end
if IPv4~=game:GetService"Players"then
    return false
end
local inqp=game:GetService"Workspace"if typeof(inqp)~="Instance"or not inqp:IsA"Workspace"or inqp.Parent~=game or inqp~=workspace then
    return false
end
if type(Vector3)~="table"or type(CFrame)~="table"or type(Enum)~="userdata"then
    return false
end
local aYq_=Vector3 .new(94,24,49)if typeof(aYq_)~="Vector3"or aYq_.X~=94or aYq_.Y~=24or aYq_.Z~=49then
return false
end
local ATX=aYq_+Vector3 .new(1,2,3)if ATX.X~=95or ATX.Y~=26or ATX.Z~=52then
return false
end
local iF=CFrame.new(aYq_)if typeof(iF)~="CFrame"or iF.Position~=aYq_ then
    return false
end
if typeof(Enum.KeyCode.Unknown)~="EnumItem"or Enum.KeyCode.Unknown.EnumType~=Enum.KeyCode then
    return false
end
Ky2=Instance.new"Folder"AaV=Instance.new"Folder"if type(Ky2)~="userdata"or typeof(Ky2)~="Instance"or not Ky2:IsA"Folder"then
    return false
end
AaV.Name="v1d7bc494cec52fc1"AaV.Parent=Ky2 AaV:SetAttribute("a137ff265f7ff179c",569500)if Ky2:FindFirstChild"v1d7bc494cec52fc1"~=AaV or not AaV:IsDescendantOf(Ky2)then
    return false
end
if AaV:GetAttribute"a137ff265f7ff179c"~=569500then
return false
end
local IYY=AaV:GetAttributeChangedSignal"a137ff265f7ff179c"if typeof(IYY)~="RBXScriptSignal"then
    return false
end
nq=IYY:Connect(function()
end
)if typeof(nq)~="RBXScriptConnection"or not nq.Connected then
    return false
end
nq:Disconnect()if nq.Connected then
    return false
end
local K8xa={aYq_.X,ATX.Y,iF.Position.Z,AaV:GetAttribute"a137ff265f7ff179c"}Ky2:Destroy()if AaV.Parent~=nil then
    return false
end
return{(K8xa[1]*27958+K8xa[2]*49913+K8xa[3]*28590+K8xa[4]*40252)%4294967296,(K8xa[1]*49479+K8xa[2]*43894+K8xa[3]*34485+K8xa[4]*3531)%4294967296,(K8xa[1]*5942+K8xa[2]*24019+K8xa[3]*54967+K8xa[4]*27275)%4294967296,(K8xa[1]*43297+K8xa[2]*45296+K8xa[3]*59980+K8xa[4]*49476)%4294967296,(K8xa[1]*19758+K8xa[2]*32185+K8xa[3]*44165+K8xa[4]*32126)%4294967296,(K8xa[1]*42021+K8xa[2]*36893+K8xa[3]*47065+K8xa[4]*21547)%4294967296,(K8xa[1]*59067+K8xa[2]*8178+K8xa[3]*56594+K8xa[4]*52617)%4294967296,(K8xa[1]*19610+K8xa[2]*30350+K8xa[3]*43798+K8xa[4]*36367)%4294967296}
end
)if nq then
    pcall(function()nq:Disconnect()
    end
)
end
if AaV then
    pcall(function()AaV:Destroy()
    end
)
end
if Ky2 then
    pcall(function()Ky2:Destroy()
    end
)
end
if not KK5k or type(ci0)~="table"or#ci0~=8then error("Roblox environment verification failed",0)
end
LYT=ci0
end
local Nd=(getfenv and getfenv())or _ENV local l6=_VERSION=="Luau"or(type(typeof)=="function"and type(bit32)=="table")
    local Umy=table.unpack or unpack local bM,moke,wW,FgtO=string.char,table.concat,string.sub,tonumber local dg,N7H4,Ra,TY,vm5,NGFk=type,next,getmetatable,error,select,tostring local y5,NVE,jD3=rawget,setmetatable,newproxy local oduA,zYH,dewM=getfenv,setfenv,pcall local aaFL,G_ZI=Nd.getrawmetatable,Nd.setnamecallmethod local rn3y=NVE({},{__mode="kv"})
    local function fwB(...)return{pfd8b=vm5("#",...),...}
    end
local function KZY(w4B,Pdlt)if dg(oduA)=="function"and w4B then
        return oduA(w4B)
    end
return Pdlt
end
local oQK={["GetService"]=function(vaU,ZAJ)
    return vaU:GetService(Umy(ZAJ,2,ZAJ.pfd8b))
end
,["HttpGet"]=function(vaU,ZAJ)
    return vaU:HttpGet(Umy(ZAJ,2,ZAJ.pfd8b))
end
}
local function FKJZ(vaU,DFE,ZAJ)if l6 and dg(vaU)=="userdata"then
        local Lbn=oQK[DFE]if Lbn then
            return Lbn(vaU,ZAJ)
        end
end
if dg(vaU)=="userdata"and dg(aaFL)=="function"and dg(G_ZI)=="function"then
        local dtrg,b83=dewM(aaFL,vaU)
        local gY=dtrg and dg(b83)=="table"and y5(b83,"__namecall")if dg(gY)=="function"then
                G_ZI(DFE)
                return gY(Umy(ZAJ,1,ZAJ.pfd8b))
            end
    end
return vaU[DFE](Umy(ZAJ,1,ZAJ.pfd8b))
end
local function qq(xV)
    local t2ow={}for Yre,ZA in N7H4,xV do
        t2ow[Yre]=ZA
    end
return t2ow
end
local sDY={pfd8b=0}if dg(bit32)~="table"then
    TY"hardened VM requires Luau bit32
    use --no-hardening for standard Lua"
end
local n6M,eS7,AnW,mBKm=bit32 .bxor,bit32 .band,bit32 .lrotate,bit32 .rshift local Df=bit32 .bnot local obVa,gxdI=string.byte,string.gsub local KLSF=dg(string.unpack)=="function"and string.unpack or nil local BmCV=string.rep local oFFM=dg(table.freeze)=="function"and table.freeze or nil local Jo={"<I1","<I2","<I3","<I4"}
    local YC={{},{},{},{}}
    local function du6W(MYuM)if not oFFM then
            return MYuM
        end
    for JV,m8C in N7H4,MYuM do
        if dg(m8C)=="table"then
            du6W(m8C)
        end
end
return oFFM(MYuM)
end
local wh do
    local dSL,iSNJ=3136210318,2004992395
    local function LEw9(MYuM,...)
        local exw0,MG=...
        return AnW(n6M((dSL+MYuM)%4294967296,iSNJ),18),exw0,MG,vm5("#",...)
    end
local function wX(BsN,YOrB)
    return BsN-YOrB
end
local dtrg,Ue6,exw0,MG,nIGr=pcall(LEw9,3270417427,nil,false)
local LZ=dtrg and dg(Ue6)=="number"and Ue6>=0and Ue6<=4294967295 and Ue6%1==0LZ=LZ and exw0==nil and MG==false and nIGr==2and wX(17,9)==8
local UU0=dg(debug)=="table"and debug.info if dg(UU0)=="function"then
        local VHQM,Bpw7,m5,N5_=pcall(UU0,LEw9,"af")LZ=LZ and VHQM and Bpw7==1and m5==true and N5_==LEw9 local Fr7,vC,Jr,hiO=pcall(UU0,wX,"af")LZ=LZ and Fr7 and vC==2and Jr==false and hiO==wX local p2P=pcall(UU0,LEw9,"?")LZ=LZ and not p2P
    end
if not LZ then
    Ue6=1383805133end wh=Ue6
end
local PgQ0={n6M(1398199958,1540690586,wh,LYT[1]),n6M(1161594850,901505982,wh,LYT[2]),n6M(1901616311,1211890930,wh,LYT[3]),n6M(2800363502,2657855497,wh,LYT[4]),n6M(26103128,594504697,wh,LYT[5]),n6M(2480967156,3980343892,wh,LYT[6]),n6M(3214812824,3040942521,wh,LYT[7]),n6M(3447651384,3460879202,wh,LYT[8])}
local BV=dg(string.pack)=="function"and string.pack or nil local AJVN="<I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4"
    local function TX(eRR,Ya2,Zqc,X40)
        local KoBi={}
        local nCek=X40 or1for Fg=1,#eRR,64do local nHY,zW,TVyF,Bbk=1634760805,857760878,2036477234,1797285236
        local wUqs,mOy,JlXt,lR,wg,qX,qoI,qv=Ya2[1],Ya2[2],Ya2[3],Ya2[4],Ya2[5],Ya2[6],Ya2[7],Ya2[8]
        local wLHI,Oqs,CGL9,vIG=nCek,Zqc[1],Zqc[2],Zqc[3]for ryS=1,10do nHY=(nHY+wUqs)%4294967296 wLHI=AnW(n6M(wLHI,nHY),16)wg=(wg+wLHI)%4294967296 wUqs=AnW(n6M(wUqs,wg),12)nHY=(nHY+wUqs)%4294967296 wLHI=AnW(n6M(wLHI,nHY),8)wg=(wg+wLHI)%4294967296 wUqs=AnW(n6M(wUqs,wg),7)zW=(zW+mOy)%4294967296 Oqs=AnW(n6M(Oqs,zW),16)qX=(qX+Oqs)%4294967296 mOy=AnW(n6M(mOy,qX),12)zW=(zW+mOy)%4294967296 Oqs=AnW(n6M(Oqs,zW),8)qX=(qX+Oqs)%4294967296 mOy=AnW(n6M(mOy,qX),7)TVyF=(TVyF+JlXt)%4294967296 CGL9=AnW(n6M(CGL9,TVyF),16)qoI=(qoI+CGL9)%4294967296 JlXt=AnW(n6M(JlXt,qoI),12)TVyF=(TVyF+JlXt)%4294967296 CGL9=AnW(n6M(CGL9,TVyF),8)qoI=(qoI+CGL9)%4294967296 JlXt=AnW(n6M(JlXt,qoI),7)Bbk=(Bbk+lR)%4294967296 vIG=AnW(n6M(vIG,Bbk),16)qv=(qv+vIG)%4294967296 lR=AnW(n6M(lR,qv),12)Bbk=(Bbk+lR)%4294967296 vIG=AnW(n6M(vIG,Bbk),8)qv=(qv+vIG)%4294967296 lR=AnW(n6M(lR,qv),7)nHY=(nHY+mOy)%4294967296 vIG=AnW(n6M(vIG,nHY),16)qoI=(qoI+vIG)%4294967296 mOy=AnW(n6M(mOy,qoI),12)nHY=(nHY+mOy)%4294967296 vIG=AnW(n6M(vIG,nHY),8)qoI=(qoI+vIG)%4294967296 mOy=AnW(n6M(mOy,qoI),7)zW=(zW+JlXt)%4294967296 wLHI=AnW(n6M(wLHI,zW),16)qv=(qv+wLHI)%4294967296 JlXt=AnW(n6M(JlXt,qv),12)zW=(zW+JlXt)%4294967296 wLHI=AnW(n6M(wLHI,zW),8)qv=(qv+wLHI)%4294967296 JlXt=AnW(n6M(JlXt,qv),7)TVyF=(TVyF+lR)%4294967296 Oqs=AnW(n6M(Oqs,TVyF),16)wg=(wg+Oqs)%4294967296 lR=AnW(n6M(lR,wg),12)TVyF=(TVyF+lR)%4294967296 Oqs=AnW(n6M(Oqs,TVyF),8)wg=(wg+Oqs)%4294967296 lR=AnW(n6M(lR,wg),7)Bbk=(Bbk+wUqs)%4294967296 CGL9=AnW(n6M(CGL9,Bbk),16)qX=(qX+CGL9)%4294967296 wUqs=AnW(n6M(wUqs,qX),12)Bbk=(Bbk+wUqs)%4294967296 CGL9=AnW(n6M(CGL9,Bbk),8)qX=(qX+CGL9)%4294967296 wUqs=AnW(n6M(wUqs,qX),7)
    end
local A5Z={(nHY+1634760805)%4294967296,(zW+857760878)%4294967296,(TVyF+2036477234)%4294967296,(Bbk+1797285236)%4294967296,(wUqs+Ya2[1])%4294967296,(mOy+Ya2[2])%4294967296,(JlXt+Ya2[3])%4294967296,(lR+Ya2[4])%4294967296,(wg+Ya2[5])%4294967296,(qX+Ya2[6])%4294967296,(qoI+Ya2[7])%4294967296,(qv+Ya2[8])%4294967296,(wLHI+nCek)%4294967296,(Oqs+Zqc[1])%4294967296,(CGL9+Zqc[2])%4294967296,(vIG+Zqc[3])%4294967296}if Fg+63<=#eRR and KLSF and BV then
    local ya,g3qd,mjf,n4,hy,vR4,eGpS,hdd7,m33l,WJqB,LW,S3kq,HhpZ,WIKv,ZWV,bj=KLSF(AJVN,eRR,Fg)KoBi[#KoBi+1]=BV(AJVN,n6M(ya,A5Z[1]),n6M(g3qd,A5Z[2]),n6M(mjf,A5Z[3]),n6M(n4,A5Z[4]),n6M(hy,A5Z[5]),n6M(vR4,A5Z[6]),n6M(eGpS,A5Z[7]),n6M(hdd7,A5Z[8]),n6M(m33l,A5Z[9]),n6M(WJqB,A5Z[10]),n6M(LW,A5Z[11]),n6M(S3kq,A5Z[12]),n6M(HhpZ,A5Z[13]),n6M(WIKv,A5Z[14]),n6M(ZWV,A5Z[15]),n6M(bj,A5Z[16]))
else
    for UcL=1,16do local p8C=Fg+(UcL-1)*4if p8C+3<=#eRR then
        local BsN,YOrB,IoLK,sU=obVa(eRR,p8C,p8C+3)
        local Ue6=A5Z[UcL]KoBi[#KoBi+1]=bM(n6M(BsN,eS7(Ue6,255)),n6M(YOrB,eS7(mBKm(Ue6,8),255)),n6M(IoLK,eS7(mBKm(Ue6,16),255)),n6M(sU,mBKm(Ue6,24)))
    else
        for Ol=0,3do if p8C+Ol<=#eRR then
            KoBi[#KoBi+1]=bM(n6M(obVa(eRR,p8C+Ol),eS7(mBKm(A5Z[UcL],Ol*8),255)))
        end
end
end
end
end
nCek=nCek+1end
return moke(KoBi)
end
local cwrB,vJN,BmCV,cNI=math.floor,bit32 .bor,string.rep,math.min local function E_K(tIq,bm,XGK)
    local DSr=cwrB(XGK/13)+1
    local MYuM=bm*2^(XGK%13)tIq[DSr]=tIq[DSr]+MYuM%8192if XGK%13>5and DSr<10then tIq[DSr+1]=tIq[DSr+1]+cwrB(MYuM/8192)
end
end
local function Lv4(eRR,seqK)
    local t2ow,yxx={},{}for UcL=1,10do t2ow[UcL]=0yxx[UcL]=0end for UcL=0,15do local bm=obVa(seqK,UcL+1)if UcL==3or UcL==7or UcL==11or UcL==15then bm=eS7(bm,15)
elseif UcL==4or UcL==8or UcL==12then bm=eS7(bm,252)
end
E_K(t2ow,bm,UcL*8)
end
local SSj6,ECi,za4r,oKC3,VtQ,tZK,UD,Ek,akar,yWE=t2ow[1],t2ow[2],t2ow[3],t2ow[4],t2ow[5],t2ow[6],t2ow[7],t2ow[8],t2ow[9],t2ow[10]
local OY,Si,xn5,mLBu,zi,wM3f,XMTp,Zn,CsH=ECi*5,za4r*5,oKC3*5,VtQ*5,tZK*5,UD*5,Ek*5,akar*5,yWE*5for Fg=1,#eRR,16do local STa9=cNI(16,#eRR-Fg+1)if STa9==16and KLSF then
    local BsN,YOrB,IoLK,sU=KLSF("<I4I4I4I4",eRR,Fg)yxx[1]=yxx[1]+BsN%8192yxx[2]=yxx[2]+cwrB(BsN/8192)%8192yxx[3]=yxx[3]+cwrB(BsN/67108864)+(YOrB%128)*64yxx[4]=yxx[4]+cwrB(YOrB/128)%8192yxx[5]=yxx[5]+cwrB(YOrB/1048576)+(IoLK%2)*4096yxx[6]=yxx[6]+cwrB(IoLK/2)%8192yxx[7]=yxx[7]+cwrB(IoLK/16384)%8192yxx[8]=yxx[8]+cwrB(IoLK/134217728)+(sU%256)*32yxx[9]=yxx[9]+cwrB(sU/256)%8192yxx[10]=yxx[10]+cwrB(sU/2097152)+2048else for UcL=0,STa9-1do E_K(yxx,obVa(eRR,Fg+UcL),UcL*8)
end
E_K(yxx,1,STa9*8)
end
local CtRN,lM,NXj,A2p5,Ri,zG,ji,pl,EJ,f5=yxx[1],yxx[2],yxx[3],yxx[4],yxx[5],yxx[6],yxx[7],yxx[8],yxx[9],yxx[10]yxx[1]=CtRN*SSj6+lM*CsH+NXj*Zn+A2p5*XMTp+Ri*wM3f+zG*zi+ji*mLBu+pl*xn5+EJ*Si+f5*OY yxx[2]=CtRN*ECi+lM*SSj6+NXj*CsH+A2p5*Zn+Ri*XMTp+zG*wM3f+ji*zi+pl*mLBu+EJ*xn5+f5*Si yxx[3]=CtRN*za4r+lM*ECi+NXj*SSj6+A2p5*CsH+Ri*Zn+zG*XMTp+ji*wM3f+pl*zi+EJ*mLBu+f5*xn5 yxx[4]=CtRN*oKC3+lM*za4r+NXj*ECi+A2p5*SSj6+Ri*CsH+zG*Zn+ji*XMTp+pl*wM3f+EJ*zi+f5*mLBu yxx[5]=CtRN*VtQ+lM*oKC3+NXj*za4r+A2p5*ECi+Ri*SSj6+zG*CsH+ji*Zn+pl*XMTp+EJ*wM3f+f5*zi yxx[6]=CtRN*tZK+lM*VtQ+NXj*oKC3+A2p5*za4r+Ri*ECi+zG*SSj6+ji*CsH+pl*Zn+EJ*XMTp+f5*wM3f yxx[7]=CtRN*UD+lM*tZK+NXj*VtQ+A2p5*oKC3+Ri*za4r+zG*ECi+ji*SSj6+pl*CsH+EJ*Zn+f5*XMTp yxx[8]=CtRN*Ek+lM*UD+NXj*tZK+A2p5*VtQ+Ri*oKC3+zG*za4r+ji*ECi+pl*SSj6+EJ*CsH+f5*Zn yxx[9]=CtRN*akar+lM*Ek+NXj*UD+A2p5*tZK+Ri*VtQ+zG*oKC3+ji*za4r+pl*ECi+EJ*SSj6+f5*CsH yxx[10]=CtRN*yWE+lM*akar+NXj*Ek+A2p5*UD+Ri*tZK+zG*VtQ+ji*oKC3+pl*za4r+EJ*ECi+f5*SSj6 local Y84z repeat Y84z=0for UcL=1,10do local MYuM=yxx[UcL]+Y84z yxx[UcL]=MYuM%8192Y84z=cwrB(MYuM/8192)
end
yxx[1]=yxx[1]+Y84z*5until Y84z==0end local dm=yxx[1]>=8187for UcL=2,10do if yxx[UcL]~=8191then dm=false
end
end
if dm then
    yxx[1]=yxx[1]-8187for UcL=2,10do yxx[UcL]=0end
end
local xS={}
local Y84z=0for UcL=0,15do local XGK=UcL*8
local DSr=cwrB(XGK/13)+1
local UO=XGK%13
local bm=cwrB(yxx[DSr]/2^UO)if UO>5then bm=bm+yxx[DSr+1]*2^(13-UO)
end
local MYuM=bm%256+obVa(seqK,17+UcL)+Y84z xS[UcL+1]=bM(MYuM%256)Y84z=cwrB(MYuM/256)
end
return moke(xS)
end
local function G6k(MYuM)
    local Zg9={}for UcL=1,8do Zg9[UcL]=bM(MYuM%256)MYuM=cwrB(MYuM/256)
end
return moke(Zg9)
end
local function sa8i(W2K,Ya2,Zqc)
    local LCR4="RBXVM2"
    local gYXM=BmCV(bM(0),32)
    local seqK=TX(wW(gYXM,1,32),Ya2,Zqc,0)
    local iz=LCR4 ..wW(gYXM,1,(-#LCR4)%16)..W2K..wW(gYXM,1,(-#W2K)%16)..G6k(#LCR4)..G6k(#W2K)
    return Lv4(iz,seqK)
end
local function hS(C2Y,rp)
    local MYuM=AnW((vJN((n6M(C2Y,rp)*36167)%4294967296,3365469579)+eS7((n6M(C2Y,rp)*36167)%4294967296,3365469579))%4294967296,10)MYuM=n6M(MYuM,mBKm(MYuM,16))
    return MYuM
end
local function vsdg(ifSH,VPLk,rp)if dg(ifSH)~="table"or#ifSH~=2then TY"invalid VM transition"
end
local qjJd=hS(VPLk,rp)
return n6M(ifSH[1],qjJd),n6M(ifSH[2],AnW(qjJd,11))
end
local function ZgI(q2nS,C2Y,l6k5)if dg(l6k5)~="number"or l6k5<0or l6k5>4294967295 or l6k5%1~=0then TY"invalid VM block capability"
end
local Acid=hS(C2Y,l6k5)
local Xf=AnW((((n6M(n6M(q2nS[1],Acid),(C2Y+3365469579)%4294967296)*36167)%4294967296)+(3365469579))%4294967296,10)Xf=n6M(Xf,mBKm(Xf,16))Acid=Xf local RSq_=AnW((vJN((n6M(n6M(q2nS[2],Acid),(C2Y+6730939158)%4294967296)*36167)%4294967296,3365469579)+eS7((n6M(n6M(q2nS[2],Acid),(C2Y+6730939158)%4294967296)*36167)%4294967296,3365469579))%4294967296,10)RSq_=n6M(RSq_,mBKm(RSq_,16))Acid=RSq_ local aMjX=AnW((vJN((n6M(n6M(q2nS[3],Acid),(C2Y+10096408737)%4294967296)*36167)%4294967296,3365469579)+eS7((n6M(n6M(q2nS[3],Acid),(C2Y+10096408737)%4294967296)*36167)%4294967296,3365469579))%4294967296,10)aMjX=n6M(aMjX,mBKm(aMjX,16))Acid=aMjX local Db=AnW((((n6M(n6M(q2nS[4],Acid),(C2Y+13461878316)%4294967296)*36167)%4294967296)+(3365469579))%4294967296,10)Db=n6M(Db,mBKm(Db,16))Acid=Db local Oys=AnW((vJN((n6M(n6M(q2nS[5],Acid),(C2Y+16827347895)%4294967296)*36167)%4294967296,3365469579)+eS7((n6M(n6M(q2nS[5],Acid),(C2Y+16827347895)%4294967296)*36167)%4294967296,3365469579))%4294967296,10)Oys=n6M(Oys,mBKm(Oys,16))Acid=Oys local N4A=AnW((vJN((n6M(n6M(q2nS[6],Acid),(C2Y+20192817474)%4294967296)*36167)%4294967296,3365469579)+eS7((n6M(n6M(q2nS[6],Acid),(C2Y+20192817474)%4294967296)*36167)%4294967296,3365469579))%4294967296,10)N4A=n6M(N4A,mBKm(N4A,16))Acid=N4A local Az=AnW((vJN((n6M(n6M(q2nS[7],Acid),(C2Y+23558287053)%4294967296)*36167)%4294967296,3365469579)+eS7((n6M(n6M(q2nS[7],Acid),(C2Y+23558287053)%4294967296)*36167)%4294967296,3365469579))%4294967296,10)Az=n6M(Az,mBKm(Az,16))Acid=Az local cE0g=AnW((vJN((n6M(n6M(q2nS[8],Acid),(C2Y+26923756632)%4294967296)*36167)%4294967296,3365469579)+eS7((n6M(n6M(q2nS[8],Acid),(C2Y+26923756632)%4294967296)*36167)%4294967296,3365469579))%4294967296,10)cE0g=n6M(cE0g,mBKm(cE0g,16))Acid=cE0g return{Xf,RSq_,aMjX,Db,Oys,N4A,Az,cE0g}
end
local function K9(TF)
    local A5Z={TF[27200],TF[37035],TF[63968],TF[22337],TF[11092],TF[41993],TF[52656],TF[47956]}for UcL=1,8do local Ue6=A5Z[UcL]if dg(Ue6)~="number"or Ue6<0or Ue6>4294967295 or Ue6%1~=0then TY"invalid VM packet key"
end
end
return{n6M(A5Z[1],3425530259,wh),n6M(A5Z[2],135260372,wh),n6M(A5Z[3],2943194001,wh),n6M(A5Z[4],2143492518,wh),n6M(A5Z[5],3409338475,wh),n6M(A5Z[6],3186848619,wh),n6M(A5Z[7],3713712065,wh),n6M(A5Z[8],4057729383,wh)}
end
local function n4nu(C57W,Ya2)if dg(C57W)~="table"or dg(Ya2)~="table"then
        TY"invalid VM packet key"
    end
if#Ya2~=8then Ya2=K9(Ya2)
end
local Zqc=C57W[2]if dg(Zqc)~="table"or#Zqc~=3then TY"invalid VM packet nonce"
end
for UcL=1,8do local Ue6=Ya2[UcL]if dg(Ue6)~="number"or Ue6<0or Ue6>4294967295 or Ue6%1~=0then TY"invalid VM packet key"
end
end
for UcL=1,3do local Ue6=Zqc[UcL]if dg(Ue6)~="number"or Ue6<0or Ue6>4294967295 or Ue6%1~=0then TY"invalid VM packet nonce"
end
end
local W2K=C57W[1]if dg(W2K)~="string"or#W2K~=C57W[3]then
    TY"damaged VM packet length"
end
local xS=C57W[4]if dg(xS)~="string"or#xS~=16then TY"invalid VM authentication tag"
end
local dV0=sa8i(W2K,Ya2,Zqc)
local Mk=0for UcL=1,16do Mk=vJN(Mk,n6M(obVa(dV0,UcL),obVa(xS,UcL)))
end
if Mk~=0then TY"VM packet authentication failed"
end
return TX(W2K,Ya2,Zqc)
end
local function pdJ(eRR)
    local p8C=1
    local function bm()
        local MYuM=obVa(eRR,p8C)if MYuM==nil then
            TY"truncated VM packet"
        end
    p8C=p8C+1
    return MYuM
end
local function RL2I()
    local UV,EKux=0,1for UcL=1,5do local YOrB=bm()UV=UV+(YOrB%128)*EKux if YOrB<128then if UV>4294967295 then
        TY"oversized VM integer"
    end
return UV
end
EKux=EKux*128end TY"invalid VM integer"
end
local Oa,gC_ local function pTm(qW)if p8C+qW-1>#eRR then
        TY"truncated VM packed word"
    end
if KLSF then
    local MYuM MYuM,p8C=KLSF(Jo[qW],eRR,p8C)
    return MYuM
end
local BsN,YOrB,IoLK,sU=obVa(eRR,p8C,p8C+qW-1)p8C=p8C+qW if qW==1then
return BsN
elseif qW==2then
    return BsN+YOrB*256elseif qW==3then
    return BsN+YOrB*256+IoLK*65536end
    return BsN+YOrB*256+IoLK*65536+sU*16777216end local function A5Z(nIGr,qW)if nIGr>(#eRR-p8C+1)/qW then
            TY"truncated VM packed words"
        end
    if nIGr==0then return{}
end
if KLSF and nIGr<=64then local frDB=YC[qW]
local xo=frDB[nIGr]if not xo then
    xo="<"..BmCV("I"..qW,nIGr)frDB[nIGr]=xo
end
local jW4={KLSF(xo,eRR,p8C)}p8C=jW4[nIGr+1]jW4[nIGr+1]=nil
return jW4
end
local jW4={}for UcL=1,nIGr do
    jW4[UcL]=pTm(qW)
end
return jW4
end
local function C57W()
    local OoDL=bm()if OoDL==1then Oa=pTm(4)gC_=pTm(4)
elseif OoDL~=0or Oa==nil then
        TY"invalid VM packed nonce prefix"
    end
local nCek,STa9=RL2I(),RL2I()if STa9>#eRR-p8C-15then TY"truncated VM packed packet"
end
local zoZ=wW(eRR,p8C,p8C+STa9-1)p8C=p8C+STa9 local xS=wW(eRR,p8C,p8C+15)p8C=p8C+16return{zoZ,{Oa,gC_,nCek},STa9,xS}
end
local function MT(DVo,Ft4m)
    local nIGr=RL2I()
    local qW,QIj,oN,IuE=bm(),bm(),bm(),bm()if qW<3or qW>16or QIj<1or QIj>qW or oN<1or oN>qW or IuE<1or IuE>qW or QIj==oN or QIj==IuE or oN==IuE then
        TY"invalid VM packed record layout"
    end
local l6k5=pTm(3)if nIGr>(#eRR-p8C+1)/5then TY"invalid VM packed record count"
end
local w5k={}for UcL=1,nIGr do
    local qP5,Zki if p8C+3>#eRR then
        TY"truncated VM packed record"
    end
if KLSF then
    qP5,Zki,p8C=KLSF("<I2I2",eRR,p8C)
else
    qP5=pTm(2)Zki=pTm(2)
end
local oDr=bm()
local zkl9 if oDr==255then zkl9=Ft4m(DVo+1)if dg(zkl9)~="table"then
    TY"invalid VM packed operands"
end
else
    zkl9=A5Z(oDr,4)
end
local dQ={}
local q2nS=(l6k5+UcL*65521)%16777215for q3=1,qW do
    if q3~=QIj and q3~=oN and q3~=IuE then
        dQ[q3]=(q2nS+q3*257)%16777215+1end
    end
dQ[QIj]=qP5 dQ[oN]=zkl9 dQ[IuE]=Zki w5k[UcL]=dQ
end
return w5k
end
local Ft4m Ft4m=function(DVo)if DVo>96then TY"VM packet nesting limit"
end
local xV=bm()if xV==151then
return nil
elseif xV==216then
    return false
elseif xV==94then
    return true
elseif xV==104then
    return RL2I()
elseif xV==9or xV==115then local UV=RL2I()if p8C+UV-1>#eRR then
        TY"truncated VM string"
    end
local MYuM=wW(eRR,p8C,p8C+UV-1)p8C=p8C+UV if xV==115then
return FgtO(MYuM)
end
return MYuM
elseif xV==178then local UV=RL2I()if UV>#eRR-p8C+1then TY"invalid VM array length"
end
local jQ={}for UcL=1,UV do
    jQ[UcL]=Ft4m(DVo+1)
end
return jQ
elseif xV==171then local UV=RL2I()if UV>(#eRR-p8C+1)/2then TY"invalid VM map length"
end
local m8={}
local hFN={}for UcL=1,UV do
    local Ya2=RL2I()if hFN[Ya2]then
        TY"duplicate VM map key"
    end
hFN[Ya2]=true m8[Ya2]=Ft4m(DVo+1)
end
return m8
elseif xV==45then
    return MT(DVo,Ft4m)
elseif xV==198then local qW=bm()if qW<1or qW>4then TY"invalid VM packed word width"
end
return A5Z(RL2I(),qW)
elseif xV==132then local pMQ=bm()if pMQ>15then TY"invalid VM packed map widths"
end
local Rwr=cwrB(pMQ/4)+1
local s0WP=pMQ%4+1
local nIGr=RL2I()if nIGr>(#eRR-p8C+1)/(Rwr+s0WP)then
    TY"invalid VM packed map length"
end
local m8={}
local hFN={}for UcL=1,nIGr do
    local Ya2=pTm(Rwr)if hFN[Ya2]then
        TY"duplicate VM map key"
    end
hFN[Ya2]=true m8[Ya2]=pTm(s0WP)
end
return m8
elseif xV==143then
    return pTm(4)
elseif xV==245then
    return C57W()
end
TY"invalid VM packet tag"
end
local MYuM=Ft4m(0)if p8C~=#eRR+1then TY"trailing VM packet bytes"
end
return MYuM
end
local qeO={[122]=0,[63]=1,[33]=2,[118]=3,[80]=4,[111]=5,[114]=6,[110]=7,[69]=8,[120]=9,[56]=10,[85]=11,[53]=12,[115]=13,[83]=14,[81]=15,[112]=16,[90]=17,[106]=18,[35]=19,[45]=20,[74]=21,[72]=22,[43]=23,[42]=24,[66]=25,[36]=26,[67]=27,[105]=28,[75]=29,[124]=30,[104]=31,[65]=32,[103]=33,[102]=34,[113]=35,[126]=36,[107]=37,[95]=38,[125]=39,[123]=40,[38]=41,[77]=42,[71]=43,[98]=44,[78]=45,[94]=46,[46]=47,[51]=48,[50]=49,[109]=50,[37]=51,[86]=52,[57]=53,[60]=54,[91]=55,[87]=56,[121]=57,[93]=58,[59]=59,[108]=60,[117]=61,[62]=62,[100]=63,[44]=64,[64]=65,[88]=66,[48]=67,[116]=68,[70]=69,[79]=70,[68]=71,[82]=72,[54]=73,[58]=74,[101]=75,[99]=76,[52]=77,[76]=78,[49]=79,[41]=80,[47]=81,[55]=82,[89]=83,[40]=84}
local function w_hq(zIaQ,oDr)if#zIaQ~=math.floor((oDr+3)/4)*5+9then TY"invalid VM payload encoding"
end
if wW(zIaQ,1,5)~="GQUEK"or wW(zIaQ,-4)~="IPOB"then
    TY"invalid VM payload framing"
end
zIaQ=wW(zIaQ,6,#zIaQ-4)
local eRR=gxdI(zIaQ,".....",function(yM8r)
    local Jc,PlhK,eUL,MV8,IC=obVa(yM8r,1,5)
    local BsN,YOrB,IoLK,sU,TaV=qeO[Jc],qeO[MV8],qeO[PlhK],qeO[IC],qeO[eUL]if BsN==nil or YOrB==nil or IoLK==nil or sU==nil or TaV==nil then
        TY"invalid VM payload encoding"
    end
local Ue6=((((BsN*85+YOrB)*85+IoLK)*85+sU)*85+TaV)if Ue6>4294967295 then
    TY"invalid VM payload encoding"
end
return bM(eS7(mBKm(Ue6,16),255),eS7(mBKm(Ue6,8),255),eS7(Ue6,255),mBKm(Ue6,24))
end
)for UcL=oDr+1,#eRR do
    if obVa(eRR,UcL)~=0then TY"invalid VM payload padding"
end
end
return wW(eRR,1,oDr)
end
local vz="GQUEKnqN@9dmd{p3DKr?MO@u_5
XBlD*1-iD+/4A9v-,}<lN)gXGORG@P<HZ>-ReB.irYsn^r5_&9<^A.WPH6RiOF1uPr1AVy[.M~m0CSO^b%4!hO^Aq5*J?5kopp30?+2tBq:l{q>u&S(DnU!*@xDNg5ZR/1oSOLh-*xuJL0WRv#68A3n/WSyq1}lX!G*<V!9tZ5l](5P#NH.st%e7ugr(:ZhRpje&i&kyjiFH9_y/BS.Yh62F09$Ot)4<8{mjD8Q@9f-x:jF83{Ni*@#1zDevd4*YxsjgpKx<V5K}Oht0?2Sc&6?Rf?]mc-0BJ/iC2n)K
$U2|HqF4n.Hv:~@KnXPW{md9)3hm}NbMp*_Hx&?>XOSK!:)dD~q!PcJBqDA$1.9>{}JH$8yA0$Q}_O-!})tBYtco6r46hb60l)V_Cv
q^t<^1c#6gFn4@<O2r4xcq1RC]4R]jvttdRlLElFK
848fNP@%@F-1RGJ)S$1m[
czAU&J7*Bj2DyP?]SK4Kv+/APQE[W>q2)]tJ
)Xp/Vy8f|[CW&5X,E[.<}<zV$Yj&Gq-:f80{[)2]ee6Ar]sJk-:DlJSXB:xrR6l*G3-2.#drOV#ek0h~%[9>})/r$7|]
K}olnX1Y5|+hKWjle*>!yRk*<#u:BF7By:9jzKHc}JDb*mi{Dx4/XlqUfyFH$*j!1C|EkHc@+{O[8OVL[VDtM_fHeQ|pXDRS9xrL:HcpfP9%jp7Mv3|mXA1<}F!yruPz2JNiGNGseHx:]*y*LN6DW*+JOs@5xfUZ+o?o8qY6tg*:jA8Pz]igZ_xoV
2ZG^}
++Yx(^Do12ndlVU^9j]hH{E0RcgF#<z+M^2pbo!3X>f~W%?/POc#g8t*EyR/GZN~r+L4k3h2RgRD,]dNetcMNBEYo6~op*(XRO8Of:7y#B0Y54L[394U%4~Q[,/Esuxqu%#RU}OKX.WEZ]P,SZ8GC3muhmm~%PdG#K[tnKfBfULEBnx&WH9r)0h{R5S2M{,#qHvy6:z*B#Hu*R3@{%K]Vbgk&pS270pLL$WomAl$J0WoXQD6Ob&,Hsjd5ox6_PA[|ZXohJquz
mCvBtW:-YxDp#jd^kK::2ry/:G~+RlXcl[!Fgumn:)3zq<r~/%8><b)2+
2MOzu
WfXlfr!
Z5|-.h*9_Rp8$rj4[~$+4C>t
gHm:$5rYMO07OfMW!y+iQDvP[hPs
@.m?3RG$_ttK+D?L_>E|qS2[!QP:<!
@^#+,o4oJs_5O:-86oQG?tky>oug3f:fg|k-3h#0d3OO21.xScD+.#z>pxzEBpvQhd<vVJFbqp06NpZQd6@B2?bhgU%B>MeO$9}d3Zg$9N|LMCWkJd|>eGvmn?mVSBt6MPug6
v{B0hCA{Zv,$0ujXq+~R(lRk9JWN,j^^+/n@Ujr![ME-Ru2XR}:eY9,>C
)*eM!l
qq(+.Ed<-24b<Xk%DnxJe11k/X8KipVoK]KLXy3Wxj/9~YnepZ&[+McCm}]>+1iHcO+JFbbg@Gux3-Q#!/U+.}eht,dC!]hZ9+p+E)&tiCK:WJ8v]{cHoWH^GiHZu?UK.Xq>X2g{sRcoJK$P,&,vg@!^/r)Brpj0Q(5pBH4]p$jH^q9bKeJ7|<E88cQtH4p:Ru<bC>9D:0.[J]oE}]m@.Gg,|#FK>#6D9s[fP5xUy{1p%Vyd}<d9vk|pM9LM71?0c}95~&&rppD-
$&+
i{!1eb:R_^/&YDlrUpuvh4yG4AAusb^3%FGs0/t:$e2KeQgHShjn#A11RNuz}P{60]tL|5x1z[^q4~(hJJ{(lsEjn.HfXHkHFJ)/<G]*k6DnQ
o?*oU(t6)iZVu/xyu3ZjmH4&Hr
XMGhoSbpnrzxn>Ov-0tl_u{j0/,t}*+N>WrKM<@uH#]uW2_0^.3,W~_xE2~xsVVL-k~$)Kj9n5%*CL$y&etzD{y)e&UN1V!
mmOmgRct41ohz+b5U4)pvGiB1fCZdf%,OAH<VDNlZ&H!913qyCd00NX?D+#s,{!$shyKQBhY5s(mD3|K{8t#$M%(f{<NX?1P8Cfjo[jyGn_BJ-}_Cf0}|A>rt[55W{%/Ob^x{3]bYeBN{KyroG
cx]BFNJ.^k>Do:}8Kfz9V3<d](?R
L/9*J,Ntp+$@Q^emLJvPqf>hfH4K#tVu6hl+y<JL4,ZYPY1gHgOUkOGHr^{J{jU<0ORe*X(+j@+]Affxvj?u!p_.r4/>,.e9}eyn,
pqz
MQ{p30v]78&d.?/2^S_d~]L>U9H]5s(Kxy3f]{xY^1%+Uz>VE3?RQW5vHERcUK-YKRkV^OR5u&CdR?#X2j0FGRm,6#M|b&rRR!eoR8{<WC%!APr62G.ymZ+k22N0{+5}9uoyb{^bk/h
c~DR6.DXSF]b0jM@puW$<AuC9A
6hd^
N4M~i^[YgS7V0p]+C
*q^XY3*|)zLN*NH1V}RlDBQj6}R]P#FEb3/
]bY%Fe{8~7S}50{}R8:9KXGj>f%?!1c-s(@gFLS$c#c%Z>[t@qDstrBxb.]#]m>llGN%p_sj664.7oJF#GX}8,_U8LL%VtH4EF-R6ktj!8~*JketgGj*_%8yx1b<cpMsdG&0
]hu]eF!f5CQO{dmfP_}P[P<$P?nQ#1*n.dcVZ$/0nVCUG#G3m0QmL2uLqx2l:C_60Af~5d-/XYZJ,s*[dc~JQZlVpyf7c[[&1K^O6r.Hm<GK.E>-L-h?kR<2KuRYX0ddsyp7s-]*l+$fF6p9zkCO+Uz(.~Y&.3}qf@!}4bW5D19^v3/
2zkj5rkzq^A017<%]LFXUVY<Nu<h$<qQ@8D#
_y:)$n[Axp2y?02muAhtADbFEZAn.h/%8k/*{(G:vX.Pb0xsKu<W}Ds9si*[93|v^c^$4J?<Y>uQ)(E*,kW~uK}1>@&BsA+}WWZ9xKuS&hJ.-96qr4my_2kfUO2U|t5&cf}BOZd)z?Nxmj>Bbup]:kG{<SMe.1rnUpG0Grs|JHKsQdUHM&JdZ{bKc[WBMy([u_6_lu90*?2PsNO+tz
i>6WCCdu4p8#,AG)7:*1(zZ#o!D5W7,WBH(:KZZ_)UOE_eW[W6XDu
P*VgNzW6op?m(4eSEX(gU(ji%BDRQypc>Jnxb4ft$$9&Hr-,27d#sn%&
W#jmWe{#?xkfF.S!~!$(p6r7jS2vl:6~d*R(.<R>*:+m]ns+u>bpO5of+tY+Q!878-CCg@BNb9L?eyuJ#
ddKo
y.qbyu5M*k38KVk3$g?K+A3GhQ9Sf8W{}Rh6oS]OrdnSuWkWZnHG!YA<:^H<.qV*<bL,5KzVeC8@FB[9Oug/8jMs|:n!-GB~ZA#mEWP#Em3-*j1M6/23iCX^_L6CS[to{25v^
oMei7L!ErW[[h:RmdVGgGH{XkmCd98Z}|GlXE1Su9i~V&O*}t.W|5~M+Dp]EiUp|:x>LSr|f@+u,~DX)DPv,.0.4q7%DS6Bmg-Xmm[[P,U4@97DrF/QpmC/O_yJ-z_yhdk{4hd.y)
E*@x
{-(5NMq^y3R@K?D!
.qo35|PMhVbneu9Y.6@RzE{xQ.),{X[Gd_(PNs..@lqr.Kx
sy?Dld!>K1k(7]VV~3/pQMfHDUk$cD95Z8ueb4)<*$zEP4fO9~Lx}BPx3nziJokpVcxxVlg5/M{g|_r$^UsNH~~fmy5&l9|t^Z&f|^f/-+sgxbv15C/MHYf8nqWivGycQz_c%zf%@Gf&~z2J]<gv2R6EBDO6n$8@B]voQ_zUgrSi+izHLSxdQoyHF5Omx@{b&_SoSu|t:
@zZHX<49tX|r]m+}B5NembNMmtQ
AJG^@-6XciSZy9(!xd1C}8yG9Cl9j_X~tv
eLl3:Sx#p1rzAm:L|,DNjHedy<
p^%1!-4!~.b-D/@:]{~KxbWA>y&/m7u9L#CZ#p5*4G*eWrJrkoJLfY1~kfx7L-kUmO,3kNCe_Ju:Fdh?O@!3CP
DNSJ{,l!lJbrcFzys^mxyhcbV]/1M/0f^~+HB26*]VytN4-*ZpotOu>V5plAsPz<:]D_kk5RY_<b*ULx3(b(PAUg,Ft:y#i@lNM@umU5ByY%|32y<b<{#M9H|C3m33dXbM*/V!bO?&pB-M*D#k-_+X-Yl,s6@,c4pB@0e{t#yfcXd!#903:pC2n~}NdV6?W!J3yg|!AmNygxd5$Fr6.?Yr~6Jj$^msN$r}5ycBWQ1@]PzO<Dd6MV4Vc2u*c$cP*EBY8kq$YXA
{5M!X$G.>XrdAJ.
[/Q&xGFpL67AFi4*kUllYzPZ]?WSU+<vrdr8.4LBtz)+!9/F9:c>lpF:db*(ERLEsPS9UVDKB?)938CZ&VGPDR/QtkL?tBLr%_}&2)./&HRy{
9&*#*jk7)po^CDrt!BOCyg5sL>hJLc49Rr~nt._mzn&4>j$_G9*QA{Q-KmE*CgZb>&m{VGj$@:P9
F(:-^
,}cL:ogR+2@DGS|V+x%A:b@{,m$4SeihivK
pUFv)gqQ!d-LPz*-Z7eRu4<p:Y#c:.c&8Cjoveu@v91SUb}iXAnH$hq2RbvtDeCXb07~?yB>sm[4M5sj}7_Sy4jHv-@p6z7FCN@LRl2574P99c,&xPuBD
WPRGbrdc|jgUZg*u}_P>M_h1lposO|/2r^goGC$v1L32zz!4FEi@DUAsDM+jBr-}d|LmX^PB9A>44r{L%9#L?Pu|rMDsEjGE~_6c/0rud0>V0bGl#MlS%V>8J.H[([VPjd^_6)6%Ed-B[Mbk]FMZ/rez4QG5m*NzQU+:-F)SV|ymJ1:QtRZR0LQ+)L9x>[fGdRbLDz]RkPj}.^6%VYUP}[!t{nr}*>S:>W-eZG?X|s/LO*b.rU9vsg#OK]m-[2r]s.A
cW>&y%7r:q*(&1s8GN^R-:6[W)v{HE0vG{)5~J%0Mf)hpH:!_[%8h9%-9Af~VtsUMJx!9Rd*&?Qcz~_vA6sL8Xr}}l)nCz-zUvMK43*gcFKsKSebp^Dcos&SCj%-P0n&&Oe*tZQ&@H
?ZM?#?ek~QC.x|F:sJ)}i%NL4])E:b-RH~U0PUkX@*6%4C2^ri5,>GcX{<O1q6KF8mB398{eAh0@$V7:eZ0XCQ.j5@FM[4sA7D?sLe0Aj1Rx(GoB(mA/lnL0jf{J-,AL:xrO&><b1pmrLZG$jJe^oC}^Ys#?WNk0*sBvz3%93bB5tcMh1%b8,doRR+@4ZX%uNeJ|^^V.}vmzy[}1pCsHgEHQ53&!W^)U8kj9BOz]Wr7::6%R507WJ|*2/zce]M
Y[Y06:-W58}R)/vQRRb2b8u?3*5$Fr_Q^Yi]Km|s^pL8bdP2-~l>VAqU%/4+-^0%s^3GbBV[^/Q92%iixe1e|^y]!is)D^PCZsgy),BU51nAM,{23F,@c,$oA)~z[R^o(*X#EGV-y@-d{tYZ|0*VJt2y2>
>6#9}:c%0ig9g%b(z-#[g#MH#qWN9JQls)p9JeSK}FW^R,2G#!ktC,]gk#Ap#5Rqy?zgg:!G<i!lPr80hg<|smzv_|V1r,Q#WV0Y1r1iSH6S-36]ms8G[q1%K,<BJh1DJM{0<f-_W+5j[Zc1OsA:il}|!&iNS5,Z%^35)H!f{+UNJcc_ipqLHP?7o*B,FzDs34E+Mj9xLAU8)QRQN4>l0Lvgb~0#v2{2f0x!J6|
%$riRVl!hOsPg([gmQ_Bm$CPFM6c,D1ldV
)3m:{!$C{mlWn!:hh7VcKxJUrsVGBXzrYS,:tmu,D!(RBkzX[pSB:<v5-Lg78|ZZ,&51[>7tPux)6~l8#k@9z
<d:Pcp0@V2@gG4r?W!F1dhyJ3mg
HBG)6u/b0
X}A}z>|2>yl{7WzP+f3|[RptBo5Ax<f,N#YG[*|yRv%iA!QcPcverML0emrg*t6LBGd7k0#q[]!y@m?{s-5Dvi%0Oo<-)e[BVtte8lHkC@1LL/3X,g}*nW6g>g(fi{tAuMssond9~_&xrHyWScUqnOlcG+^brt#QKA!^t0v>K9gr[e2FZ~z*?.M<|5H6hg
?<V.MU_eZ{gbbikZt~pcE7>9q-gHO&O|4?:6>SStEPONg|)19?D!JGAuCEnGkq<1mn_Nsvf&o8cDh_Jc@,UeptW)*!2z*?:{G_ezQZ:Wk~WAV?vu$&p:&+,PZY(Fm25%*S6Cb0m.,+_}tf)
}ns<}QOyB+A-GC
UKm38KPdWK*^vGjF*#|dGSQ7dnBG0Px#u>i]yL*.OUq3(m]PK{}iB]&HH!qW5-3n89m*m%CD?mx|K%pu
&6g~t|2pb3jR20EPGA7j9yUp)+51hVR7*g}7:i$>J#%r^U
gH]vNY)eioC@1N*xOyi/Zh^[rx>VK-odRMnv~NZlc~HZJh_tY3SBL-BABZCMnE}zt]ocvhEr<@Q~DnjvLc$N00emDiC]@y43%0NAoV[VC2|iRbzMqP$Qq|MG/.[h{lmiE>3^^$1Gc:GKRm:0A~FJSM7#.Uydkb%dlHe}7|OtQ@J~qSiK3g5e&{oALDzVnsnf%n]hP$~h<<)/&t6g5s+Q8|7CAmD[Z-16t#|%yZAU!ciQ*tmuhZiyu+06Vgh:
W)WJ>r^QV2?EU.PW<_H
2!_:E:Zk^bgyP1,5Xc.[VUUAqp7SE~zBN
S.cD4+eW[FA]!(1WCBOxBes8{Cs$Ly/@j:]Hfdq)Uxg:1lp!BYlYE5v:iZbAtnd{+/,Dkf*3(Q3cD4+)K0kbq0|:}|R+lH):+@}cmh[uhOE!UxNV}-)rC3jhN?%<(/9U.$h}.s|+V.N)~E^{7AQ<D,rEX3v{EkM?UGrE5dQ-XYknWfo}c@|6er.P4k,|K)AMG[lUx}MJyZ#/OzF/$R5GmH7Bqht
Z_}tE:2u_A+7K#}|SOj.V2FCu6qq#Q9e66gHz!DMB<R|E,-GN)b<E^{Zzze9K?]NrM3L.]0DY6Q>$U/l%^?1D6[b6#.R@5DPJz@4fGccfPR|m8d6<^19{L*,OzSgRHB:PE6j#Gjn[f%G4[vc<^.X5^vPto1y2te8-+}8YZg_PF)v>ZUic*-^0sLpnf?bV:e&BQHs*sR*NP5c*|hijBeb6j,x%_gG$}_+:VZ5(-vRrHW2P/78AY2/>r_jMxA<W)#_/}888zi$[$Yj9V_),YP]2WY!gfi/H.3B?XuX#O&b@Fj&ZV!ZtkRXC/8$00muNDk3c9EJ$AG0GmttMi!ul#/BL%d$YEjAD8hx@|:i4(Pkg8k{:&ZAn
H9mo94J)h|y1pvY)W5^vA?:hZ@<1NcW8E,pc:O.GjE%5*8_/c-$3zE0Q[621{)EOE%vQ9NUzz|_F[X8{m8zt5kqNf!!ql@0X)|jbNWRyU00K]D5Y3{C24[
j>X%M7,HE,_E91<+..B0UN/oyG+$y_yR8OxPmx#8R2{.Y(jJ_LOF[R){8k-HeQ-70Z-[cQq^CKgn>oDk{c(5f}mhjO%l)3$n|$#1<->mv0?5Q3PsJ(#FmDmX.!1#BCn)H,FeiXl3
hEDrL&^#}iN?G.tZd97g.*Q7pCMZ~J[^5i]Mjn$F$PRS<E{gfCxz:|0^>@rk-Y(M!+(_|G1]9Z#4uENBQMFdm1-Ze[<#XAqo0@#cj5t:z1P+k)0#yHg[[Bv89-43N(#vuzV2%k!z^]WL^s6Pk0u%/4,UKRoP*e<+RoXh7qy-fBc#kt>DW_$q*+qYkWX3*6|!}F0)H<GDNXf
j4Wu+b*bUl+~bCetzH5e2OlpW)QMSkbrA4~SSp5fo-SoiOU!%t5Z-~/^BeL#$MO|vyAy8FQqN,yyl5_E&*iV1D>c_in.)hB5vPLNrb(c3UG(<mDj*V0FE:A$[,[N5Q$cs*jguLsyszoe2W</s:zAGy$lEml$$*hz%*@ln|#[@8@:eX#XXU]^LM63<4<v#p5b4)Y3o#z2VJ2|Uu$m}><v.>g,E,
(dEcL|*U]z:Q$KLDvVL>v9~o%HWCB|D@xxgFx++#q:-&gXtm)bYK807N?:?@|6&ck{kbZZHOYE%+sP8S]{3cl&>mB?/U)LVl_C}0z.c/sXX$xoMA$PZ}Q/:B!K[7xm-6qcA%
Y1y/vjk@/16W18BMi9LkE_Oy2.>jzlrbY)1iqxt&_gi+[C/NjH|YMy3Cv^u,*0!O[Ox?AdH[&LbZR^>OU<+l(u)1b)~Wm,3dnyE7^]!i+g&2$oj..1kjGxRt!2<xC/#VbsDWu8lu:H&:nl.u/^m*L{|sz.[2sSv>7.ss%3ZbOv,dn+P4ACyc>2m-Qp{[:K%
:gr+m2dk?GhxL.^7-VH>~KYWU?/sY#78)%S&lpckb41CkJOF>hE<j^8A!+v7Stki+7~L8.+J,BXt^i0<d:z/[}^<14(UuNom2y3n?c#56>~Y05F?gg?gV40C^hXxAD}%<n^l{$8Ai*G[uPBkQ!s~*d7.(mdf6HG[e_h6!hh]vYhhV{7.GPc|!2*6^s{@#n8.+2^9_hP-[E
UjY$38gCvM_@.2{)V!DGlH_?
JCFAtMeJGg~b8]jUCdJOdYW)y[%}eFefWDmJHv}H7[%)kEDp4ZV~>pBjKEp&pN1&i^p.06d|Rh}#+pNL13h96lF@)1xOzhg8QcJSOZE2r(s]64$ZZh#y$V2iN2<|Vmb!Qe~mvy4{Pniz~]q,]|B!XF[S_W>Lr[J0xA@+r~)Z/{DP7^!Ldqj!{1-!@u(W25F!hrJtlj&CYn#v{S|v8u$[WNRExf]4o8~W,v()G4PJlQXlJyN|Po6oU!#uRD!~OkPclQ~MWd.+:Jz$0KbV]tDlPhGX/8Jb1cBebY|YMP)(~cJ~?lX]O!-us08vW)Z97l4r!V^]AL*<1+nnUosPNR0Z8|iyjDW7kluxVro6BEU3LlHb67*KPq12mK0}uZ8])kA5#p8#FeocRg1tX+C<Gfzt,2{E>uWvmd/S>hC-e-Y[26$Y>8Js,VPi*4k#C@5uc+J+_7*(f.4:+fJpZ9XmPSCZ1DlC(*@k,$sPh6p2h]?Kl2~#BE/ECGU?~t1AUWcPb
^%zKv2<S_h/CdW)k#(^o.xO#6v/n,drr^%?N)]qu0z#dixd~[6UQfx(yP]ux#8VApUW1c]8Ej,ffiBj%Kpqnp{7q*J}y$H>r2k$^X}mBO]/BLobi8KD
AU9OM#Gv2-852BGZqh+1}S*yC8vX9EDWOg61p8&:>KAr1k@6tYcJO+008,&jO5s()|7h}U>r.<7LPNEX!oc)vGl}mofAR$Fg/g0HVR!ov9-SneZ!#|.}x?z
XnG,-t$y^D2*Exy0yl?b>B0:v%!nbKPxZp<pxL~/9rs~||WGmS08n7S3Z$jZ*>t%!Dr9K1!m
~z>.r(VigGOeH.PG1v@xLYARJ}W{.z*hN:
ut$cOn+kN]74W#bqCS2-o*R}+8LJ8gU?hc4C#JWyR2L
*dt?+c-sYPr
UNe{Jxk|#13<e)ROEB](R!f<}^_K19h,H)-RZ*fvqM%L,yo+jtCiUi.gA6W9#nZBRm]^dR)Am>*(SeZliM!x114F3L}<?9t,FSV?fd&J@}k+&+>#]H,<2JVEqu$-,@e9m7[zZ-xxK[{RM8::|[!sm0JCh-LzZuhhH*dF*EHg*JbuF5*@M-_!^W3thW)Q-g9L]HGQx[EK
@pbm4Q}Jg^u#S2.$CG6OsOODo^:1SuvX<WWcytcVVHQ*np!)Y{-!E|ysp
4obGR
1c!2u*/S&g*:|@Jqd_[_QB,O.0N@hf*AOcWm^Ly2cqBGMqr!JV<e+]:g&SkE!u*<R.Zeit[^9hBcV3l&k
$~,~Or]?>SW1Cs5L*n5,H3Y-A:6vLjU8LL8?rs1+Zn$Hq
Z
2b3jx|sMf>Mt3*E$5r1UZ_WW4j{O.?Qps.df$J?P~
e8B:[55rlHFC86N)
2iWC9Q#&6*+0g?^~E9{~nD5r&u[
7Sl
$d?~NC
g,?sm/}Nf(3.d<05ft(sgp|Ois-7_%k5gN5r*,Sq+~LkKL[mFeV|5f>*rZVOnU#2tQonm,f8l2e%^Eoc6(!55k>.SZ__gWsUj-^j}zp5L%RfK0dhCmQvy0#JE6.>/J*>5A1DA?s,fA|_DHVUt{!j?yp%d0mNEz_~pRe/U+timz6OVefD?P,XM<$B7pk[z&WJd(V!J,m#ur0-Q!.f|NW4W3&<.uoRM$%N)%ELVV@.rU*:-Jcj}!hbSMkeX<r2+lcOXVD?e,%v#kl/[pqW&-Ec}g<!$-J>
BOxm^e}3+HJ7X_{Qk-L#zYxL,0<ctvU]!X58zEtqdzjvVi,Y(]dZt4Pjboe5%dk[cC_iVCDd]4gVu$Ue:r3&-b@6<5oJz94)[lj$Rt6i)-!9,<
0}.9F[>H{5YN5ZqQHVu~~?}[/zGJ/-F?b&OMX{^c8R.2hnK~H/H15GN]kD:+XnVMH@|*~G|cCoFd8Wqv.7dLP:@/UG@]FOn_g>)8fVm[_C47P
ME46pHjh#s<?OPOk1Xc0H)cUbr/[ZoZQ)yxX
0n5C-#[OQ<z&@tsq[]65hh$mKgMd&P?zgG2z69?e,r72E#(l[
0g1UkvzrJK5d[u[cyKmBOSpD~XFsfReU}@1H+h
U+mW[8.m&@7J)@Z7S>:|e*g&i!y?t_P:E6f?~x:gQ7+^V(Q2Kb4F-pG0e[[L@3pZdCX3-Q(oH-(gA/?svexK7Zl8Qe[m*fg&fA.5)n!O7*E89}Zv/zx)NV3(r$bjV8Wh0l~Gi0LZW4bKi[bFusV3ALg.cv|G}{m~7Kb+DhVUAvhB(l,:~e{FA<<]nr$Fl-U{Uh/>,OlD5o{E]LEy3d)WUPn.6&HFWKp|t!eqPdeyeAsQx{0qc/|F9Wx*@N4q-Gt])A.d0g
pqUAjNCFxl)Md<z_K2Gn/NyQ*v%4jcfJUKH@<!#8(&@n<-er3t$j58-Xyp<#gEjyOCR5*WD&^91&&Lk){GuJ#BSqiq>u#.ZN<eqZS^,ozg3s):@YMr1zL0$lyVQ
}~S9uMV/A0Cb{00s]^d|plDq.A3WqViC{q-nJHU2)CX<}:C-ek#UbG.N]M$tiOXq?Vh+!pvs_ptz<Sn$^]X&4NmgH0fJ$dOd6QSm8(HAjkH!sA+eleK@F+7{<65?dMX|]CHA$WdG0)q)Mh_/YXnldtbC7756HO5+M46&n]9z>l~-t*Q?[hox
DnsA0&:#t]XJZS0(VW0lX>H_QNb!<D1kCEg:|S(x.k
|-gdg[Bg+0+$V!h__ZZ<9$:12A4.j9F2kN[$l9sjc-ZXY{[:coH-![?FthH_!s/l/H*:%o|qu4r2/jx*YQ]Sd^c&zZ|)><O><ON~1dp0m}Ed7.o5E>-kB4Q}jB6FtJ*tSKPAFoojv|K-nE-jB?RS${BDzj}EA/2XNpE*AM[&uK(A}Do(pj{z/Aj}Eij7)l.l2Mv6!q~7phQ6g#:jy!,&&Eh>XPSvWL&]ZfXNZJ9Kg/$SoXP1*:qVR
OmpQW@
@3n0S{Zt]]D_z2x0$B+GCzL_|7Y%XCfKL}nzlE$5bWc8CGO6C<v]XR#XL]cDsZl{P_fCu5JeO~NY,0:Heln_(Pi6Nj(@:)E
NBv%i*n*80_jLn@YJcy$tNK/[H+:!^p5ulW,v>f:#rVG,+WN_]:OPbj~|n-EGkx!%H&r*Hls.^6lmsrSN$~?F)qm[75kA{_
-!k,Rg~~6z#
%tMs!f6+-KO<$dtN%rq6#
o
{fc8h[HOyD.$&rgh<Qd>_N$%#1E-zHGz$WCjH0]7M-3d%z!/-x&yQCU}vufBLozs[X126^@yYj78n#xu3)#<.6AC8Ai]x5J/LB{D{Km{Fq)q!$4@+.fG~~(E8H^G_{1$toV_MQFSd}E1Ji6<8Jg*%Nf!eJqC<ZN*f_^*)iNdlneMnPtKgN_}HlM-~z,fuS[MC
b)>3uF1qSb6>PWZ+OArCE+4-A+,f~UNJ8r#.t1t
C0t.,xq^O.uq4QQCd:1
,Md+SOdHySX0MrYc[LB(u1LU!06:E^rqXthfu!&HVM7,K3UJPpv*|$Hn<})!C!1r_L]H8cDMlJVK>nm*0_%?-ZB4n>3h5htbL*ANGyL:Kbk535M[U3x,8*jpC_Wo*Xy}CSf4HJtcf<K*tjUcu@v<Eyi-QVg{*>foKeuP@4dAv(L#3DWd7L5H]@1]zzf?3Eb}HZ|#ys(nDM|2AG
@e1-&-kDG>iolgS8RHCmP]^7KWloNGJAePbCA8-.NyUxlblfXVbR,>&)4M6!WPMMq*%XPS/Lg6f7YmF>:f
Em)JvK9Fs%A!Y51rzH-,</}n#/EE[yk$F|^R??gVH/g|c3Wsu_~}t]28]{BNxebf+5ooHkgH5ul9VjpLn^s0*{
iHq$#eM,PnsS[cm6u](Oy6drU#GcW%&q2Ax2<8X3FB1.1H}DR__q_d2cQ4eCfYyB2~M#GP|D7WUi{q
vltt7?P[K]WLUFA{&lmj:PM[^MO_66t%QUC!12Jb53?4F$V:]FnX6zBKxLVfXWfq@bPk?n~-WP{>49F
R]y_in^X<m$s?ce8g6P_
F5P,p^!@E
qs/W&pbp[Bro<]Mv9CW|N).X~V6hMQ)P9X^~mAhV9O%[4B]PJj|KyY)bX:4thjqjD|L
WVH{c3W,6~b
x%0(!:*ZkkY$1Lfyvd?kt|%Vn.q<uiyu?&seu]@iAyjm@KMjh:2HKgXKJ)-5Qt1!?P)m,6:z+96/J}hN~XF6]@]U})+9Y9_Cb]4/#Mz^jvK4@g,!vjeEbyd[_dg,/FYF?h)H8H1D?2b]J_mvsuBnL@e]cdpBm-R6AJkV>V#sB5#i4[rd^5,CYAl5WS$|*lPg-.jYXC3]y>oz|55xY_NDopc(tJmP:g{v0[yHbZ~O|&^#kf3Um?<B:l-LJ%xG:@PESm:ePV<_H8L*q-&<:_C/F|F)[u~Y:e@#
89{VEqZZ-B<At]7*(B9lvzW.n%
7*F+s%l5e??hHUem+,L>h{fydA8Nm~^~_3?x*5VD2f/bphC1q36sd|cU>!CH/.N*Hs^4G%[ut~NJcCdA_300c)+(1O]eiVV$(s_>D>WU31eMBHoFtD[zG&u|
Zt3tM@#M_OBKg:|4Ep@&i_k#Yhr294705D[~^0K*kCL/~(b609WttF#*eq/m#/x()0<c)vFBy
%
EH6qBd]1^2cD*[PMftXRC1NZJ]FWY*$ndHb1:K|
UuF7_>u,kKYy
s*?VkZ<sx6%vh%^3U%meHhfrNO^?zG3c{0UW{pt1uq?l8?H?p$KjhhMi3c-m?]O*N^-+&&[
#n
)Q8+$dQ<NsYZ
:yxcYG69)Ufx<03bemDJ_!2&^t9xS%OF6d,ZSC7b_n|453L>~NH{#N*1p,gYr2ns{0curd:3o,UlptHiZ70PX<omDNCn]>WJ-Kq969Q<d$$Pmk%K@oN>Vt1Hc%f!}vEPDME3>V?v<t$66-|Yo7AFs/iHe
^vFK#9O#!e[mz]<,pb-/]Dzb(LOBkSi8|{S@Sm9:Sv)KZdse!
icjG[Kn3f>$2JDW%ljVUgZ)+u%M48BNkg+<XHm5)?G{SgLl
p5jP0SiX>DU!<}0p5C!s
F(x0x,Q__1b[Mtc*R?A+.SZbkhBe)$&u|E^@#e.A!7i@#~(bF^@UjxtS2~&R2Q?KK){M^QS]E*k7~QS5HthblERmy8k)%M4Vz@N@E|Q3c*:k|z>
vyYCQ%uU0[R9iV+
5),|b~/66L^Zfe{PrbygOi*
hpn1cvdOn#6^Eo^&Y}%2nV$pVp3rjJ^&MBZ~2Qd6B#XYHiH{hA.{c&QC]XZWR<blH@Ye3~#to
yPhv[vCPh
Y%e/QC9J$6q-2o~kpNjpLX*%zph{V|M^[#,AURuK,6KKh/Z{<D8?UYjeX6~K!.t@_^V$Ht>D*5ifV>6LZc-/[R?AfRH5nl:dvZh1$Pz+FA^EMERVQU)xlpJ^?l9?e
AHYrbOy6Em|zE&v4x|ol19v+gmF9(-2[/-oq
OE*kcvL/<x4NkS1@oDzLZEW$%KH6^o>H9uMxEQ:V}4M[Bt3K}f8/}i[2-x}fsqW3}(M8v}HChJ*YLobfcS39qYdOJo2bD|Ye7n
>yho<<ymYoQN!lQ.s)Yp-Vyzig_|hDF:2:mn@y>sk?Z!$nKA
3%r6XF<U6Nt,F6do$dYtzg-VLW:V
kyi.ZWdHKZ|V-_9{/u$9j|Au0(Kjg0O2DvK[bFJ1#3#&{q<G1L(Ju@>L9!(b4D-VM1yj,lPXZPvPCj0/)E/[DBH&*5[S5#zf-GV^B1y/[-q8U~G]Mh3OhiW/xW2KdVDxL$f00:4,Vz5#F]8217/x17~bWCX^PrquUuZZD+cXr<c[c$Z~2E*
:|k*JRlHbOY~4ye]AWm]xx93_AHvs?HPQb-n_
.HU~2,s[zj5PUIPOB" local DYD3=w_hq(vz,11295)
local U9ua=pdJ(n4nu({DYD3,{2959865899,90057854,92},11295,("hSV5oN?I@\\Ø")},PgQ0))LYT=nil DYD3=nil vz=nil PgQ0=nil qeO=nil local D2,t7=U9ua[39908],U9ua[10886]U9ua=nil local av7h,GUWQ,jc={},{},{0,0,0,0}
local wUr,q2=2048,1048576
local function yQ6(DSr,Kj)if jc[2]==DSr then
        return
    end
local gn,AM=Kj[1],Kj[2]if gn~=0then GUWQ[gn][2]=AM
else
    jc[1]=AM
end
if AM~=0then GUWQ[AM][1]=gn
end
GUWQ[jc[2]][2]=DSr Kj[1]=jc[2]Kj[2]=0jc[2]=DSr
end
local function rE6N(DSr,fB,oDr)if oDr>q2 then
        return
    end
while jc[4]>0and(jc[4]>=wUr or jc[3]+oDr>q2)do
    local zQWE=jc[1]
    local Kj=GUWQ[zQWE]jc[1]=Kj[2]jc[3]=jc[3]-Kj[3]jc[4]=jc[4]-1av7h[zQWE]=nil GUWQ[zQWE]=nil if jc[1]~=0then GUWQ[jc[1]][1]=0else jc[2]=0end
end
GUWQ[DSr]={jc[2],0,oDr}if jc[2]~=0then GUWQ[jc[2]][2]=DSr
else
    jc[1]=DSr
end
jc[2]=DSr jc[3]=jc[3]+oDr jc[4]=jc[4]+1av7h[DSr]=fB
end
local function Lb(XCb)
    local Mi6={__index=function(JV,DSr)
        local fd=XCb[DSr]if not fd then
            TY"invalid VM constant reference"
        end
    local HyT=av7h[DSr]if HyT then
        yQ6(DSr,GUWQ[DSr])
        return HyT[1]
    end
local MYuM=pdJ(n4nu(D2[DSr],fd))
local fB=fwB(MYuM)if oFFM then
    oFFM(fB)
end
rE6N(DSr,fB,D2[DSr][3])
return MYuM
end
}
return du6W(NVE({},du6W(Mi6)))
end
local KGtc={}
local function WaL(DSr)
    local uT=KGtc[DSr]if uT then
        return uT
    end
local fd=t7[DSr]if not fd then
    TY"invalid VM function reference"
    end
uT=pdJ(n4nu(fd[1],fd[2]))uT[31820]=K9(uT[31820])du6W(uT[4356])uT[61756]=Lb(uT[4356])uT[36440]={}uT[39814]={0,0,0,0}uT[52106]=64KGtc[DSr]=uT
return uT
end
local function iEav(uT,C2Y,l6k5)
    local itMh,rp=uT[36440],uT[39814]
    local Ci_=itMh[C2Y]if Ci_ then
        if Ci_[6]~=l6k5 then
            TY"invalid VM block capability"
        end
    if rp[2]~=C2Y then
        local gn,AM=Ci_[3],Ci_[4]if gn~=0then itMh[gn][4]=AM
    else
        rp[1]=AM
    end
if AM~=0then itMh[AM][3]=gn
end
itMh[rp[2]][4]=C2Y Ci_[3]=rp[2]Ci_[4]=0rp[2]=C2Y
end
return Ci_[1],Ci_[5]
end
local C57W=uT[50952][C2Y]if not C57W then
    TY"invalid VM branch destination"
end
local om=du6W(pdJ(n4nu(C57W,ZgI(uT[31820],C2Y,l6k5))))
local ymOf=((C2Y*uT[56126]+uT[53561])%65521)*16
local oDr=C57W[3]while rp[4]>0and(rp[4]>=uT[52106]or rp[3]+oDr>262144)do
    local lPY3=rp[1]
    local Kj=itMh[lPY3]rp[1]=Kj[4]rp[3]=rp[3]-Kj[2]rp[4]=rp[4]-1itMh[lPY3]=nil if rp[1]~=0then itMh[rp[1]][3]=0else rp[2]=0end
end
itMh[C2Y]={om,oDr,rp[2],0,ymOf,l6k5}if rp[2]~=0then itMh[rp[2]][4]=C2Y
else
    rp[1]=C2Y
end
rp[2]=C2Y rp[3]=rp[3]+oDr rp[4]=rp[4]+1
return om,ymOf
end
local function CN(MYuM,qjJd,Ya2,UWg9,WJwG,p8C)if dg(MYuM)=="number"then
        return n6M((AnW(MYuM,UWg9)-qjJd-p8C*WJwG)%4294967296,Ya2)
    end
if dg(MYuM)=="table"then
    local w5k={}for UcL=1,#MYuM do
        w5k[UcL]=CN(MYuM[UcL],qjJd,Ya2,UWg9,WJwG,p8C+UcL)
    end
return w5k
end
return MYuM
end
local function nX(Gy,exw0,nIGr,N6hX,Xj)if nIGr==0then
    return sDY
end
if nIGr==1then
return Gy[(exw0)*N6hX+Xj]
end
local t2ow={pfd8b=0}for UcL=1,nIGr do
    local OD8=Gy[(exw0+UcL-1)*N6hX+Xj]
    local UV=1if UcL==nIGr then
        UV=OD8 .pfd8b
    end
for Ol=1,UV do
    t2ow.pfd8b=t2ow.pfd8b+1t2ow[t2ow.pfd8b]=OD8[Ol]
end
end
return t2ow
end
local b6,N1 N1=function(DSr,xE,Ec,AC5)
    local w4B w4B=function(...)
        local ZAJ=fwB(...)ZAJ.sfd8b=w4B ZAJ.tc898=Ec ZAJ.u98fd=AC5
        return b6(DSr,xE,ZAJ)
    end
if dg(zYH)=="function"then
        zYH(w4B,Ec)
    end
return w4B
end
b6=function(DSr,xE,ZAJ)
    local f9zr=ZAJ.sfd8b if not f9zr then
        return N1(DSr,xE,Nd)(Umy(ZAJ,1,ZAJ.pfd8b))
    end
local Nd=ZAJ.tc898 or Nd local uT=WaL(DSr,ZAJ.u98fd)
local ZjP=uT[61756]
local ZL=qq(xE)
local a933=uT[24499]for UcL=1,#a933 do
    ZL[a933[UcL]]={[3351]=ZAJ[UcL]}
end
local XIFa=sDY if uT[60868]and ZAJ.pfd8b>#a933 then
    XIFa={pfd8b=0}for UcL=#a933+1,ZAJ.pfd8b do
        XIFa.pfd8b=XIFa.pfd8b+1XIFa[XIFa.pfd8b]=ZAJ[UcL]
    end
end
local Gy,r5ab,AFi,CaPG={},0,nil,{}
local N6hX,Xj=uT[59510],uT[37518]
local aCi8=uT[37213]
local v3Md,aJ,KlWh local TRU,nsK,l424=uT[46427],uT[43054],uT[63744]
local ss,ej=uT[29230],uT[44236]
local om,ymOf=iEav(uT,ss,ej)
local kN8E=1
local Q9=om[ymOf+52842]
local HZ,Dr=om[ymOf+46324],om[ymOf+52097]v3Md,aJ,KlWh=om[ymOf+34145],om[ymOf+33538],om[ymOf+17119]while true do
    if kN8E>#HZ then
        if Dr==0then TY"invalid VM fallthrough"
    end
ss,ej=vsdg(Dr,ss,Q9)om,ymOf=iEav(uT,ss,ej)kN8E=1Q9=om[ymOf+52842]HZ,Dr=om[ymOf+46324],om[ymOf+52097]v3Md,aJ,KlWh=om[ymOf+34145],om[ymOf+33538],om[ymOf+17119]
end
local nNqH=HZ[kN8E]
local Zki=nNqH[KlWh]
local yIR=Q9 local En=(nNqH[v3Md]-Zki-Q9)%65536
local qP5=aCi8[En]if qP5==nil then
    TY"invalid VM instruction alias"
end
Q9=(Q9*l424+nNqH[v3Md]+Zki)%65536kN8E=kN8E+1AFi=nil local Yuf=qP5%4if Yuf==3then if19603>=qP5 then
    if qP5>=7724then if qP5<15640then if not(qP5~=13499)then
        local cjzY=nNqH[aJ]
        local No6g=TRU+(Zki*nsK+yIR*l424)%1000003
        local OX=n6M(((AnW(cjzY[#cjzY-(1)+1],13))+(4294967296-(No6g+(1)*3634)))%4294967296,2790510965)
        local vaU=Gy[(r5ab)*N6hX+Xj][1]if l6 then
            Gy[(r5ab)*N6hX+Xj]={pfd8b=1,q98fd=vaU,rc898=ZjP[OX]}
        else
            Gy[(r5ab)*N6hX+Xj]=fwB(vaU[ZjP[OX]])
        end
    r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]=fwB(vaU)elseif15639==qP5 then
        local VC=nNqH[aJ]
        local yok=TRU+(Zki*nsK+yIR*l424)%1000003
        local OD8=Gy[(r5ab)*N6hX+Xj]for UcL=2,(#VC+1)do
            ZL[n6M(((AnW(VC[(UcL)-1],2))+(4294967296-(yok+((UcL)-1)*174)))%4294967296,1243806836)]={[3351]=OD8[UcL-1]}
        end
    Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1else TY"invalid VM opcode"
end
else
    if not(qP5~=17519)then
        local vaU,Ya2,MYuM=Gy[(r5ab-2)*N6hX+Xj][1],Gy[(r5ab-1)*N6hX+Xj][1],Gy[(r5ab)*N6hX+Xj][1]vaU[Ya2]=MYuM Gy[(r5ab)*N6hX+Xj]=nil Gy[(r5ab-1)*N6hX+Xj]=nil Gy[(r5ab-2)*N6hX+Xj]=nil r5ab=r5ab-3elseif qP5==17239then local PbOg=nNqH[aJ]
        local csX=TRU+(Zki*nsK+yIR*l424)%1000003
        local gaAX=n6M(((AnW(PbOg[#PbOg-(4)+1],12))+(4294967296-(csX+(4)*2459)))%4294967296,228074771)
        local sN=n6M(((AnW(PbOg[#PbOg-(1)+1],12))+(4294967296-(csX+(1)*2459)))%4294967296,228074771)
        local olg=n6M(((AnW(PbOg[#PbOg-(2)+1],12))+(4294967296-(csX+(2)*2459)))%4294967296,228074771)
        local Tm=n6M(((AnW(PbOg[#PbOg-(3)+1],12))+(4294967296-(csX+(3)*2459)))%4294967296,228074771)
        local rp=CaPG[sN]if rp[4]then
            rp[4]=false
        else
            rp[1]=rp[1]+rp[3]
        end
    local UV,qm,WJwG=rp[1],rp[2],rp[3]if(WJwG>0and UV<=qm)or(WJwG<=0and UV>=qm)then
        ZL[olg]={[3351]=UV}
    else
        AFi={Tm,gaAX}CaPG[sN]=nil
    end
elseif19603==qP5 then
    Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,{}}r5ab=r5ab+1else TY"invalid VM opcode"
end
end
else
    if not(qP5~=7723)then
        Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1elseif qP5==7687then local bn=nNqH[aJ]
        local RET=TRU+(Zki*nsK+yIR*l424)%1000003
        local c6=n6M(((AnW(bn[1],15))-(RET+(1)*2101))%4294967296,1538863306)
        local nIGr=c6 local exw0=r5ab-nIGr+1
        local BsN=nX(Gy,exw0,nIGr,N6hX,Xj)
        local R21K=Gy[(exw0-1)*N6hX+Xj]
        local erIj=R21K[1]for UcL=exw0,r5ab do
            Gy[(UcL)*N6hX+Xj]=nil
        end
    local Jy if R21K.rc898 then
        Jy=FKJZ(R21K.q98fd,R21K.rc898,BsN)
    elseif oduA and erIj==oduA and(BsN[1]==nil or BsN[1]==1)then
            Jy=KZY(f9zr,Nd)
        elseif zYH and erIj==zYH and BsN[1]==1then local yNlE=zYH(f9zr,BsN[2])Nd=BsN[2]Jy=yNlE
        else
            Jy=erIj(Umy(BsN,1,BsN.pfd8b))
        end
    if erIj==NVE then
        rn3y[BsN[1]]=BsN[2]
    elseif erIj==jD3 and BsN[1]==true then
            rn3y[Jy]=Ra(Jy)
        end
    Gy[(exw0-1)*N6hX+Xj]=nil r5ab=exw0-2elseif qP5==6003then local MYuM=Gy[(r5ab)*N6hX+Xj]r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]=MYuM
else
    TY"invalid VM opcode"
end
end
else
    if36199>=qP5 then
        if30287<qP5 then
            if31807<qP5 then
                if qP5==34143then local RT=nNqH[aJ]
                local Vb9=TRU+(Zki*nsK+yIR*l424)%1000003
                local BWf5=n6M(((AnW(RT[2],17))-(Vb9+(2)*31))%4294967296,493701976)
                local A3Z=n6M(((AnW(RT[3],17))-(Vb9+(3)*31))%4294967296,493701976)
                local kkXu=n6M(((AnW(RT[4],17))-(Vb9+(4)*31))%4294967296,493701976)
                local VP=n6M(((AnW(RT[1],17))-(Vb9+(1)*31))%4294967296,493701976)
                local rp=CaPG[VP]if rp[4]then
                    rp[4]=false
                else
                    rp[1]=rp[1]+rp[3]
                end
            local UV,qm,WJwG=rp[1],rp[2],rp[3]if(WJwG>0and UV<=qm)or(WJwG<=0and UV>=qm)then
                ZL[BWf5]={[3351]=UV}
            else
                AFi={A3Z,kkXu}CaPG[VP]=nil
            end
    elseif qP5==36199then local Pug=nNqH[aJ]
        local RvH=TRU+(Zki*nsK+yIR*l424)%1000003
        local Qe=n6M(((AnW(Pug[1],5))-(RvH+(1)*1491))%4294967296,2131186383)
        local o6p=n6M(((AnW(Pug[2],5))-(RvH+(2)*1491))%4294967296,2131186383)
        local Hr7=ZjP[Qe]
        local Jrc6=ZjP[o6p]Gy[(r5ab+1)*N6hX+Xj]=fwB(Hr7)Gy[(r5ab+2)*N6hX+Xj]=fwB(Jrc6)r5ab=r5ab+2else TY"invalid VM opcode"
    end
else
    if31807==qP5 then
        local WDFF=nNqH[aJ]
        local ZCzl=TRU+(Zki*nsK+yIR*l424)%1000003
        local GmAo=n6M(((AnW(WDFF[#WDFF-(1)+1],20))+(4294967296-(ZCzl+(1)*1953)))%4294967296,3211455098)
        local YOrB,BsN,e6N=Gy[(r5ab)*N6hX+Xj][1],Gy[(r5ab-1)*N6hX+Xj][1],GmAo r5ab=r5ab-1
        local t2ow if e6N==1then t2ow=BsN+YOrB
    elseif e6N==2then t2ow=BsN-YOrB
    elseif e6N==3then t2ow=BsN*YOrB
    elseif e6N==4then t2ow=BsN/YOrB
    elseif e6N==5then t2ow=BsN//YOrB
    elseif e6N==6then t2ow=BsN%YOrB
    elseif e6N==7then t2ow=BsN^YOrB
    elseif e6N==8then t2ow=BsN..YOrB
    elseif e6N==9then t2ow=BsN==YOrB
    elseif e6N==10then t2ow=BsN~=YOrB
    elseif e6N==11then t2ow=BsN<YOrB
    elseif e6N==12then t2ow=BsN>YOrB
    elseif e6N==13then t2ow=BsN<=YOrB
    elseif e6N==14then t2ow=BsN>=YOrB
    end
Gy[(r5ab)*N6hX+Xj]={pfd8b=1,t2ow}Gy[(r5ab+1)*N6hX+Xj]=nil
else
    TY"invalid VM opcode"
end
end
else
    if qP5==30287then local z8=nNqH[aJ]
    local eAlK=TRU+(Zki*nsK+yIR*l424)%1000003
    local ZO=n6M(((AnW(z8[1],8))-(eAlK+(1)*3635))%4294967296,2088866645)
    local MYuM=KZY(f9zr,Nd)[ZjP[ZO]]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,MYuM}r5ab=r5ab+1elseif27443==qP5 then
        local Qr=nNqH[aJ]
        local IlU=TRU+(Zki*nsK+yIR*l424)%1000003
        local U0oF=n6M(((AnW(Qr[#Qr-(1)+1],1))+(4294967296-(IlU+(1)*1234)))%4294967296,246844704)
        local YOrB,BsN,e6N=Gy[(r5ab)*N6hX+Xj][1],Gy[(r5ab-1)*N6hX+Xj][1],U0oF r5ab=r5ab-1
        local t2ow if e6N==2then t2ow=BsN-YOrB
    elseif e6N==11then t2ow=BsN<YOrB
    elseif e6N==5then t2ow=BsN//YOrB
    elseif e6N==1then t2ow=BsN+YOrB
    elseif e6N==4then t2ow=BsN/YOrB
    elseif e6N==6then t2ow=BsN%YOrB
    elseif e6N==12then t2ow=BsN>YOrB
    elseif e6N==3then t2ow=BsN*YOrB
    elseif e6N==7then t2ow=BsN^YOrB
    elseif e6N==9then t2ow=BsN==YOrB
    elseif e6N==14then t2ow=BsN>=YOrB
    elseif e6N==13then t2ow=BsN<=YOrB
    elseif e6N==8then t2ow=BsN..YOrB
    elseif e6N==10then t2ow=BsN~=YOrB
    end
Gy[(r5ab)*N6hX+Xj]={pfd8b=1,t2ow}Gy[(r5ab+1)*N6hX+Xj]=nil
elseif not(qP5~=27007)then
        local vaU,Ya2,MYuM=Gy[(r5ab-2)*N6hX+Xj][1],Gy[(r5ab-1)*N6hX+Xj][1],Gy[(r5ab)*N6hX+Xj][1]vaU[Ya2]=MYuM Gy[(r5ab)*N6hX+Xj]=nil Gy[(r5ab-1)*N6hX+Xj]=nil Gy[(r5ab-2)*N6hX+Xj]=nil r5ab=r5ab-3else TY"invalid VM opcode"
    end
end
else
    if55815<qP5 then
        if qP5<=59435then if qP5==59435then local T9K=nNqH[aJ]
        local vNm9=TRU+(Zki*nsK+yIR*l424)%1000003
        local VH=n6M(((AnW(T9K[#T9K-(1)+1],13))-(vNm9+(1)*3984))%4294967296,1855458172)
        local qB_B=ZjP[VH]
        local xz=Gy[(r5ab)*N6hX+Xj][1]
        local UY=(xz==qB_B)Gy[(r5ab)*N6hX+Xj]=fwB(UY)
    else
        TY"invalid VM opcode"
    end
else
    if not(qP5~=63607)then
        local XR_=nNqH[aJ]
        local ExD=TRU+(Zki*nsK+yIR*l424)%1000003
        local kUt=n6M(((AnW(XR_[#XR_-(1)+1],22))+(4294967296-(ExD+(1)*940)))%4294967296,2389766467)
        local kfH=n6M(((AnW(XR_[#XR_-(2)+1],22))+(4294967296-(ExD+(2)*940)))%4294967296,2389766467)
        local sc=ZjP[kUt]
        local z_Z0=ZjP[kfH]Gy[(r5ab+2)*N6hX+Xj]={pfd8b=1,z_Z0}Gy[(r5ab+1)*N6hX+Xj]=fwB(sc)r5ab=r5ab+2elseif60191==qP5 then
            local uXfv=nNqH[aJ]
            local sAT=TRU+(Zki*nsK+yIR*l424)%1000003
            local KOHy=n6M(((AnW(uXfv[#uXfv-(2)+1],13))+(4294967296-(sAT+(2)*2099)))%4294967296,4090851529)
            local hv=n6M(((AnW(uXfv[#uXfv-(1)+1],13))+(4294967296-(sAT+(1)*2099)))%4294967296,4090851529)
            local rX=not not Gy[(r5ab)*N6hX+Xj][1]Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1if rX then
                AFi={hv,KOHy}
            end
    elseif not(qP5~=61147)then
            local L1Y=nNqH[aJ]
            local bnK=TRU+(Zki*nsK+yIR*l424)%1000003
            local NXik=n6M(((AnW(L1Y[1],31))-(bnK+(1)*1753))%4294967296,2597036957)
            local HzT=n6M(((AnW(L1Y[2],31))-(bnK+(2)*1753))%4294967296,2597036957)
            local aI=ZL[NXik][3351]
            local aTn=ZjP[HzT]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,aI}Gy[(r5ab+2)*N6hX+Xj]=fwB(aTn)r5ab=r5ab+2else TY"invalid VM opcode"
        end
end
else
    if49351<qP5 then
        if qP5<=51275then if qP5==51275then local b1=nNqH[aJ]
        local KS=TRU+(Zki*nsK+yIR*l424)%1000003
        local OD8=Gy[(r5ab)*N6hX+Xj]for UcL=2,(#b1+1)do
            ZL[n6M(((AnW(b1[(UcL)-1],8))+(4294967296-(KS+((UcL)-1)*3314)))%4294967296,2126278767)]={[3351]=OD8[UcL-1]}
        end
    Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1else TY"invalid VM opcode"
end
else
    if qP5<53392then if not(qP5~=53391)then
        local TP=nNqH[aJ]
        local akT=TRU+(Zki*nsK+yIR*l424)%1000003
        local av=n6M(((AnW(TP[2],20))-(akT+(2)*975))%4294967296,857077518)
        local sd=n6M(((AnW(TP[1],20))-(akT+(1)*975))%4294967296,857077518)
        local rX=not not Gy[(r5ab)*N6hX+Xj][1]Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1if not rX then
            AFi={sd,av}
        end
    elseif53047==qP5 then
        local V3=nNqH[aJ]
        local tl=TRU+(Zki*nsK+yIR*l424)%1000003
        local ixfG=n6M(((AnW(V3[#V3-(1)+1],14))-(tl+(1)*46))%4294967296,1040372596)
        local vaU=Gy[(r5ab)*N6hX+Xj][1]if l6 then
            Gy[(r5ab)*N6hX+Xj]={pfd8b=1,q98fd=vaU,rc898=ZjP[ixfG]}
        else
            Gy[(r5ab)*N6hX+Xj]=fwB(vaU[ZjP[ixfG]])
        end
    r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]=fwB(vaU)
else
    TY"invalid VM opcode"
end
else
    if not(qP5~=55815)then
        local E_6v=nNqH[aJ]
        local NYZ=TRU+(Zki*nsK+yIR*l424)%1000003
        local Wc=n6M(((AnW(E_6v[#E_6v-(1)+1],19))+(4294967296-(NYZ+(1)*92)))%4294967296,4131651490)
        local jfI=n6M(((AnW(E_6v[#E_6v-(2)+1],19))+(4294967296-(NYZ+(2)*92)))%4294967296,4131651490)
        local hl=KZY(f9zr,Nd)[ZjP[Wc]]
        local amX=ZjP[jfI]
        local TPpl=hl[amX]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,TPpl}r5ab=r5ab+1else TY"invalid VM opcode"
    end
end
end
else
    if qP5==49351then local Qs=nNqH[aJ]
    local yOo=TRU+(Zki*nsK+yIR*l424)%1000003
    local GG8=n6M(((AnW(Qs[1],11))+(4294967296-(yOo+(1)*585)))%4294967296,2612705878)
    local vJGg=GG8 r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={ZL[vJGg],3351}
elseif qP5==39195then local zr5=nNqH[aJ]
    local SWJ=TRU+(Zki*nsK+yIR*l424)%1000003
    local BgMu=n6M(((AnW(zr5[#zr5-(1)+1],24))-(SWJ+(1)*1053))%4294967296,3366722161)
    local f_Y=ZL[BgMu][3351]
    local wRdT=(not f_Y)Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,wRdT}r5ab=r5ab+1else TY"invalid VM opcode"
end
end
end
end
end
elseif Yuf==2then if qP5>=30571then if qP5>37282then if qP5>=49027then if53134>=qP5 then
        if qP5==52754then local SFj=nNqH[aJ]
        local QOSr=TRU+(Zki*nsK+yIR*l424)%1000003for UcL=2,(#SFj+1)do
            ZL[n6M(((AnW(SFj[#SFj-((UcL)-1)+1],20))+(4294967296-(QOSr+((UcL)-1)*1563)))%4294967296,293602345)]=nil
        end
    elseif53134==qP5 then
        local h7CZ=nNqH[aJ]
        local F8s=TRU+(Zki*nsK+yIR*l424)%1000003
        local ZrX=n6M(((AnW(h7CZ[1],6))-(F8s+(1)*1883))%4294967296,1354517141)
        local vR=n6M(((AnW(h7CZ[2],6))-(F8s+(2)*1883))%4294967296,1354517141)
        local q98=ZL[ZrX][3351]
        local E0=ZjP[vR]
        local BX5=q98[E0]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,BX5}r5ab=r5ab+1else TY"invalid VM opcode"
    end
else
    if qP5>=56627then if qP5>60470then if qP5==62014then local ogJo=nNqH[aJ]
    local Gd=TRU+(Zki*nsK+yIR*l424)%1000003
    local uDYN=n6M(((AnW(ogJo[1],17))-(Gd+(1)*603))%4294967296,3652362776)r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={pfd8b=1,ZjP[uDYN]}
else
    TY"invalid VM opcode"
end
else
    if not(qP5~=60470)then
        r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={pfd8b=1,{}}
    elseif qP5==57590then local b86=nNqH[aJ]
        local CV=TRU+(Zki*nsK+yIR*l424)%1000003
        local Wf=n6M(((AnW(b86[#b86-(1)+1],17))-(CV+(1)*593))%4294967296,3816998808)
        local xG4=n6M(((AnW(b86[#b86-(2)+1],17))-(CV+(2)*593))%4294967296,3816998808)
        local rX=not not Gy[(r5ab)*N6hX+Xj][1]Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1if not rX then
            AFi={Wf,xG4}
        end
else
    TY"invalid VM opcode"
end
end
else
    if qP5==56626then Gy[(r5ab+1)*N6hX+Xj]=Gy[(r5ab)*N6hX+Xj]r5ab=r5ab+1else TY"invalid VM opcode"
end
end
end
else
    if qP5==49026then local jPw=nNqH[aJ]
    local o2P=TRU+(Zki*nsK+yIR*l424)%1000003
    local j43=n6M(((AnW(jPw[#jPw-(1)+1],5))-(o2P+(1)*1099))%4294967296,1608294759)
    local nIGr=j43 local exw0=r5ab-nIGr+1
    local BsN=nX(Gy,exw0,nIGr,N6hX,Xj)
    local R21K=Gy[(exw0-1)*N6hX+Xj]
    local erIj=R21K[1]for UcL=r5ab,exw0,-1do Gy[(UcL)*N6hX+Xj]=nil
end
local Jy if R21K.rc898 then
    Jy=fwB(FKJZ(R21K.q98fd,R21K.rc898,BsN))
elseif oduA and erIj==oduA and(BsN[1]==nil or BsN[1]==1)then
        Jy=fwB(KZY(f9zr,Nd))
    elseif zYH and erIj==zYH and BsN[1]==1then local yNlE=zYH(f9zr,BsN[2])Nd=BsN[2]Jy=fwB(yNlE)
    else
        Jy=fwB(erIj(Umy(BsN,1,BsN.pfd8b)))
    end
if erIj==NVE then
    rn3y[BsN[1]]=BsN[2]
elseif erIj==jD3 and BsN[1]==true then
        rn3y[Jy[1]]=Ra(Jy[1])
    end
r5ab=exw0-1Gy[(r5ab)*N6hX+Xj]=Jy
elseif not(qP5~=42570)then
        local DXe=nNqH[aJ]
        local CrhZ=TRU+(Zki*nsK+yIR*l424)%1000003
        local FgE=n6M(((AnW(DXe[#DXe-(1)+1],9))-(CrhZ+(1)*2720))%4294967296,2119043770)
        local OD8,nIGr=Gy[(r5ab)*N6hX+Xj],FgE local exw0=r5ab-nIGr for UcL=1,nIGr do
            local w63F=Gy[(exw0+UcL-1)*N6hX+Xj]w63F[1][w63F[2]]=OD8[UcL]
        end
    for UcL=r5ab,exw0,-1do Gy[(UcL)*N6hX+Xj]=nil
end
r5ab=exw0-1else TY"invalid VM opcode"
end
end
else
    if qP5<33031then if not(qP5~=33030)then
        local eSr9=nNqH[aJ]
        local L73=TRU+(Zki*nsK+yIR*l424)%1000003
        local wPu=CN(eSr9[#eSr9-(2)+1],L73,3282754226,29,2223,2)
        local CIm=n6M(((AnW(eSr9[#eSr9-(1)+1],29))-(L73+(1)*2223))%4294967296,3282754226)
        local sJ=wPu local CzPM={}for UcL=1,#sJ do
            CzPM[sJ[UcL]]=ZL[sJ[UcL]]
        end
    r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]=fwB(N1(CIm,CzPM,KZY(f9zr,Nd),ZAJ.u98fd))
elseif not(qP5~=32934)then
        local KI_=nNqH[aJ]
        local Mkjt=TRU+(Zki*nsK+yIR*l424)%1000003
        local Gv=n6M(((AnW(KI_[#KI_-(2)+1],7))-(Mkjt+(2)*1037))%4294967296,1480453192)
        local Hz=n6M(((AnW(KI_[#KI_-(1)+1],7))-(Mkjt+(1)*1037))%4294967296,1480453192)AFi={Hz,Gv}
    else
        TY"invalid VM opcode"
    end
else
    if qP5==36934then local yO=nNqH[aJ]
    local DCT=TRU+(Zki*nsK+yIR*l424)%1000003
    local RP=n6M(((AnW(yO[1],28))-(DCT+(1)*3586))%4294967296,945800157)
    local tzw=ZL[RP][3351]
    local WBhv=Gy[(r5ab)*N6hX+Xj][1]
    local SX=(WBhv+tzw)Gy[(r5ab)*N6hX+Xj]=fwB(SX)
elseif qP5==37282then local qyd=nNqH[aJ]
    local fZwa=TRU+(Zki*nsK+yIR*l424)%1000003
    local Op=n6M(((AnW(qyd[#qyd-(1)+1],30))+(4294967296-(fZwa+(1)*950)))%4294967296,248647448)
    local nIGr=Op local exw0=r5ab-nIGr+1
    local OD8=nX(Gy,exw0,nIGr,N6hX,Xj)for UcL=exw0,r5ab do
        Gy[(UcL)*N6hX+Xj]=nil
    end
r5ab=exw0 Gy[(r5ab)*N6hX+Xj]=OD8
else
    TY"invalid VM opcode"
end
end
end
else
    if qP5<435then if qP5==434then local Z5Oy=nNqH[aJ]
    local RC=TRU+(Zki*nsK+yIR*l424)%1000003
    local Jb=n6M(((AnW(Z5Oy[#Z5Oy-(1)+1],31))-(RC+(1)*3313))%4294967296,147117494)
    local MYuM=Jb MYuM=(MYuM*MYuM+MYuM)%2else TY"invalid VM opcode"
end
else
    if qP5<14295then if not(qP5~=14294)then
        local kG=nNqH[aJ]
        local iN=TRU+(Zki*nsK+yIR*l424)%1000003
        local I2G=AnW(kG[#kG-(1)+1],24)
        local QEC=iN+(1)*299
        local Md1z=n6M((n6M(I2G,Df(QEC))+2*eS7(I2G,Df(QEC))+1)%4294967296,2372212803)
        local OD8=Gy[(r5ab)*N6hX+Xj]
        local P5LE,qm,WJwG=FgtO(OD8[1]),FgtO(OD8[2]),FgtO(OD8[3])if P5LE==nil or qm==nil or WJwG==nil then
            TY"numeric for expects numbers"
        end
    CaPG[Md1z]={P5LE,qm,WJwG,true}Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1else TY"invalid VM opcode"
end
else
    if qP5==25042then local YM=nNqH[aJ]
    local sZem=TRU+(Zki*nsK+yIR*l424)%1000003
    local E7i=n6M(((AnW(YM[2],21))-(sZem+(2)*405))%4294967296,2597020455)
    local ls=n6M(((AnW(YM[1],21))-(sZem+(1)*405))%4294967296,2597020455)
    local a0=ZL[ls][3351]
    local H0qz=ZjP[E7i]
    local otHt=(a0==H0qz)Gy[(r5ab+1)*N6hX+Xj]=fwB(otHt)r5ab=r5ab+1elseif qP5==30570then local MQb=nNqH[aJ]
    local nXN=TRU+(Zki*nsK+yIR*l424)%1000003
    local OVvM=n6M(((AnW(MQb[#MQb-(1)+1],22))-(nXN+(1)*2840))%4294967296,2725099399)
    local OD8=Gy[(r5ab)*N6hX+Xj]
    local P5LE,qm,WJwG=FgtO(OD8[1]),FgtO(OD8[2]),FgtO(OD8[3])if P5LE==nil or qm==nil or WJwG==nil then
        TY"numeric for expects numbers"
    end
CaPG[OVvM]={P5LE,qm,WJwG,true}Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1elseif not(qP5~=22822)then
    local Gah=nNqH[aJ]
    local FABO=TRU+(Zki*nsK+yIR*l424)%1000003
    local ERpr=n6M(((AnW(Gah[1],19))-(FABO+(1)*986))%4294967296,1801055922)
    local p4u=n6M(((AnW(Gah[2],19))-(FABO+(2)*986))%4294967296,1801055922)
    local dAVB=ZL[ERpr][3351]
    local cGV7=ZjP[p4u]Gy[(r5ab+2)*N6hX+Xj]={pfd8b=1,cGV7}Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,dAVB}r5ab=r5ab+2else TY"invalid VM opcode"
end
end
end
end
elseif Yuf==1then if qP5>25549then if qP5>41305then if53953<qP5 then
        if qP5==54181then local tYON=nNqH[aJ]
        local La=TRU+(Zki*nsK+yIR*l424)%1000003
        local dv=n6M(((AnW(tYON[#tYON-(4)+1],11))+(4294967296-(La+(4)*3290)))%4294967296,3262682641)
        local Klb=n6M(((AnW(tYON[#tYON-(1)+1],11))+(4294967296-(La+(1)*3290)))%4294967296,3262682641)
        local yV=n6M(((AnW(tYON[#tYON-(2)+1],11))+(4294967296-(La+(2)*3290)))%4294967296,3262682641)
        local KM=n6M(((AnW(tYON[#tYON-(3)+1],11))+(4294967296-(La+(3)*3290)))%4294967296,3262682641)
        local GZeM=ZL[Klb][3351]
        local hF4=ZjP[yV]
        local b0J=GZeM[hF4]
        local OT=ZL[KM][3351]
        local dCR=(b0J*OT)
        local ERS=ZL[dv][3351]
        local lcoT=(dCR+ERS)Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,lcoT}r5ab=r5ab+1elseif not(qP5~=60893)then
            Gy[(r5ab)*N6hX+Xj]={pfd8b=1,Gy[(r5ab)*N6hX+Xj][1]}
        else
            TY"invalid VM opcode"
        end
else
    if qP5<50046then if50045==qP5 then
        local YvB=nNqH[aJ]
        local KY0=TRU+(Zki*nsK+yIR*l424)%1000003
        local KxtW=n6M(((AnW(YvB[#YvB-(1)+1],3))-(KY0+(1)*1125))%4294967296,2826833781)
        local glP=ZjP[KxtW]
        local Kmh=Gy[(r5ab)*N6hX+Xj][1]
        local M6q=(Kmh..glP)
        local bAmg=Gy[(r5ab-1)*N6hX+Xj][1]
        local KWN=(bAmg..M6q)Gy[(r5ab)*N6hX+Xj]=nil Gy[(r5ab-1)*N6hX+Xj]=fwB(KWN)r5ab=r5ab-1elseif not(qP5~=48617)then
            local Tq=nNqH[aJ]
            local QmgN=TRU+(Zki*nsK+yIR*l424)%1000003
            local U5_D=n6M(((AnW(Tq[#Tq-(2)+1],15))+(4294967296-(QmgN+(2)*780)))%4294967296,3359779836)
            local C7=n6M(((AnW(Tq[#Tq-(1)+1],15))+(4294967296-(QmgN+(1)*780)))%4294967296,3359779836)AFi={C7,U5_D}
        else
            TY"invalid VM opcode"
        end
else
    if qP5==53953then local OU=nNqH[aJ]
    local XU1=TRU+(Zki*nsK+yIR*l424)%1000003
    local aWrg=n6M(((AnW(OU[#OU-(1)+1],9))+(4294967296-(XU1+(1)*2025)))%4294967296,697187401)r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={pfd8b=1,ZL[aWrg][3351]}elseif51489==qP5 then
        local eI=nNqH[aJ]
        local bp=TRU+(Zki*nsK+yIR*l424)%1000003
        local SS=n6M(((AnW(eI[2],5))+(4294967296-(bp+(2)*3139)))%4294967296,2011643782)
        local X7=n6M(((AnW(eI[1],5))+(4294967296-(bp+(1)*3139)))%4294967296,2011643782)
        local so2n=KZY(f9zr,Nd)[ZjP[X7]]
        local Rn=ZjP[SS]
        local PG=so2n[Rn]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,PG}r5ab=r5ab+1else TY"invalid VM opcode"
    end
end
end
else
    if qP5<=33777then if qP5==32381then local JO=nNqH[aJ]
    local Sg=TRU+(Zki*nsK+yIR*l424)%1000003
    local CUG=n6M(((AnW(JO[#JO-(1)+1],10))+(4294967296-(Sg+(1)*2597)))%4294967296,1562632767)
    local OD8,nIGr=Gy[(r5ab)*N6hX+Xj],CUG local exw0=r5ab-nIGr for UcL=1,nIGr do
        local w63F=Gy[(exw0+UcL-1)*N6hX+Xj]w63F[1][w63F[2]]=OD8[UcL]
    end
for UcL=exw0,r5ab do
    Gy[(UcL)*N6hX+Xj]=nil
end
r5ab=exw0-1elseif33777==qP5 then
    local uzsp=nNqH[aJ]
    local gd=TRU+(Zki*nsK+yIR*l424)%1000003
    local mg5l=n6M(((AnW(uzsp[#uzsp-(2)+1],1))+(4294967296-(gd+(2)*2098)))%4294967296,3565677297)
    local nF=n6M(((AnW(uzsp[#uzsp-(1)+1],1))+(4294967296-(gd+(1)*2098)))%4294967296,3565677297)
    local RwK=ZL[nF][3351]
    local GlO=ZjP[mg5l]
    local Ut=RwK[GlO]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,Ut}r5ab=r5ab+1else TY"invalid VM opcode"
end
else
    if38765==qP5 then
        local RS=nNqH[aJ]
        local YuZ=TRU+(Zki*nsK+yIR*l424)%1000003
        local A8=n6M(((AnW(RS[1],7))+(4294967296-(YuZ+(1)*2527)))%4294967296,3363121940)
        local BsN=Gy[(r5ab)*N6hX+Xj][1]
        local e6N=A8 if e6N==1then BsN=-BsN
    elseif e6N==2then BsN=not BsN
    elseif e6N==3then BsN=#BsN
    end
Gy[(r5ab)*N6hX+Xj]={pfd8b=1,BsN}
elseif not(qP5~=41305)then
        local cES6=nNqH[aJ]
        local buA=TRU+(Zki*nsK+yIR*l424)%1000003
        local GfY=n6M(((AnW(cES6[1],30))-(buA+(1)*2724))%4294967296,2342483824)
        local nIGr=GfY local exw0=r5ab-nIGr+1
        local OD8=nX(Gy,exw0,nIGr,N6hX,Xj)for UcL=r5ab,exw0,-1do Gy[(UcL)*N6hX+Xj]=nil
    end
r5ab=exw0 Gy[(r5ab)*N6hX+Xj]=OD8
else
    TY"invalid VM opcode"
end
end
end
else
    if qP5>15073then if25549==qP5 then
        local noW=nNqH[aJ]
        local Yw=TRU+(Zki*nsK+yIR*l424)%1000003
        local UQxu=n6M(((AnW(noW[1],5))+(4294967296-(Yw+(1)*3101)))%4294967296,1665497977)
        local BsN=Gy[(r5ab)*N6hX+Xj][1]
        local e6N=UQxu if e6N==1then BsN=-BsN
    elseif e6N==2then BsN=not BsN
    elseif e6N==3then BsN=#BsN
    end
Gy[(r5ab)*N6hX+Xj]={pfd8b=1,BsN}elseif15513==qP5 then
    local LI=nNqH[aJ]
    local iVb=TRU+(Zki*nsK+yIR*l424)%1000003
    local OGER=n6M(((AnW(LI[1],11))+(4294967296-(iVb+(1)*129)))%4294967296,550757152)
    local Ov=ZL[OGER][3351]
    local W6g1=Gy[(r5ab)*N6hX+Xj][1]
    local Cfu=(W6g1+Ov)Gy[(r5ab)*N6hX+Xj]={pfd8b=1,Cfu}
elseif not(qP5~=15441)then
        r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]=XIFa
    else
        TY"invalid VM opcode"
    end
else
    if13989>=qP5 then
        if13989==qP5 then
            r5ab=r5ab-1Gy[(r5ab+1)*N6hX+Xj]=nil elseif285==qP5 then
                local QDHf=nNqH[aJ]
                local fz=TRU+(Zki*nsK+yIR*l424)%1000003
                local yKF=n6M(((AnW(QDHf[2],17))-(fz+(2)*3893))%4294967296,1164322621)
                local tQ0h=n6M(((AnW(QDHf[3],17))-(fz+(3)*3893))%4294967296,1164322621)
                local dh=n6M(((AnW(QDHf[1],17))-(fz+(1)*3893))%4294967296,1164322621)
                local NSMD=n6M(((AnW(QDHf[4],17))-(fz+(4)*3893))%4294967296,1164322621)
                local Tp1Z=ZL[dh][3351]
                local kh=ZjP[yKF]
                local TZ=Tp1Z[kh]
                local qFO1=ZL[tQ0h][3351]
                local FI9J=(TZ*qFO1)
                local EF93=ZL[NSMD][3351]
                local ihHO=(FI9J+EF93)Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,ihHO}r5ab=r5ab+1else TY"invalid VM opcode"
            end
    else
        if qP5==15073then local Qw=nNqH[aJ]
        local Ln6=TRU+(Zki*nsK+yIR*l424)%1000003
        local YaF=n6M(((AnW(Qw[1],17))+(4294967296-(Ln6+(1)*3264)))%4294967296,2868266157)
        local MYuM=YaF MYuM=(MYuM*MYuM+MYuM)%2else TY"invalid VM opcode"
    end
end
end
end
elseif Yuf==0then if43364>=qP5 then
        if qP5<13125then if qP5>8964then if13124==qP5 then
            local axx4=nNqH[aJ]
            local sW=TRU+(Zki*nsK+yIR*l424)%1000003
            local KUBk=n6M(((AnW(axx4[1],19))-(sW+(1)*1769))%4294967296,3577992992)
            local nIGr=KUBk local exw0=r5ab-nIGr+1
            local BsN=nX(Gy,exw0,nIGr,N6hX,Xj)
            local R21K=Gy[(exw0-1)*N6hX+Xj]
            local erIj=R21K[1]for UcL=exw0,r5ab do
                Gy[(UcL)*N6hX+Xj]=nil
            end
        local Jy if R21K.rc898 then
            Jy=fwB(FKJZ(R21K.q98fd,R21K.rc898,BsN))
        elseif oduA and erIj==oduA and(BsN[1]==nil or BsN[1]==1)then
                Jy=fwB(KZY(f9zr,Nd))
            elseif zYH and erIj==zYH and BsN[1]==1then local yNlE=zYH(f9zr,BsN[2])Nd=BsN[2]Jy=fwB(yNlE)
            else
                Jy=fwB(erIj(Umy(BsN,1,BsN.pfd8b)))
            end
        if erIj==NVE then
            rn3y[BsN[1]]=BsN[2]
        elseif erIj==jD3 and BsN[1]==true then
                rn3y[Jy[1]]=Ra(Jy[1])
            end
        r5ab=exw0-1Gy[(r5ab)*N6hX+Xj]=Jy elseif9888==qP5 then
            local Ba=nNqH[aJ]
            local Mj5=TRU+(Zki*nsK+yIR*l424)%1000003
            local EYdC=n6M(((AnW(Ba[1],26))+(4294967296-(Mj5+(1)*2326)))%4294967296,1084692351)
            local MYuM=ZjP[EYdC]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,MYuM}r5ab=r5ab+1else TY"invalid VM opcode"
        end
else
    if qP5>7144then if8964==qP5 then
        Gy[(r5ab+1)*N6hX+Xj]=XIFa r5ab=r5ab+1else TY"invalid VM opcode"
    end
else
    if qP5==4456then local Id=nNqH[aJ]
    local qQxQ=TRU+(Zki*nsK+yIR*l424)%1000003
    local BMb=CN(Id[#Id-(2)+1],qQxQ,1193914332,25,831,2)
    local eZLH=n6M(((AnW(Id[#Id-(1)+1],25))-(qQxQ+(1)*831))%4294967296,1193914332)
    local sJ=BMb local CzPM={}for UcL=1,#sJ do
        CzPM[sJ[UcL]]=ZL[sJ[UcL]]
    end
r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]=fwB(N1(eZLH,CzPM,KZY(f9zr,Nd),ZAJ.u98fd))
elseif qP5==7144then local oMc=nNqH[aJ]
    local P8=TRU+(Zki*nsK+yIR*l424)%1000003
    local p6ik=n6M(((AnW(oMc[#oMc-(1)+1],13))+(4294967296-(P8+(1)*1042)))%4294967296,2754342359)
    local Ckw=ZL[p6ik][3351]
    local HUWR=(not Ckw)Gy[(r5ab+1)*N6hX+Xj]=fwB(HUWR)r5ab=r5ab+1else TY"invalid VM opcode"
end
end
end
else
    if22504>=qP5 then
        if19776==qP5 then
            local g5b=nNqH[aJ]
            local ti=TRU+(Zki*nsK+yIR*l424)%1000003
            local xlt=n6M(((AnW(g5b[#g5b-(1)+1],16))+(4294967296-(ti+(1)*1885)))%4294967296,1983058950)
            local B4S7=ZjP[xlt]
            local GaF=Gy[(r5ab)*N6hX+Xj][1]
            local uqA=(GaF..B4S7)
            local nhSl=Gy[(r5ab-1)*N6hX+Xj][1]
            local hMSk=(nhSl..uqA)Gy[(r5ab)*N6hX+Xj]=nil Gy[(r5ab-1)*N6hX+Xj]=fwB(hMSk)r5ab=r5ab-1elseif19768==qP5 then
                local eZq=nNqH[aJ]
                local kzt=TRU+(Zki*nsK+yIR*l424)%1000003
                local Xl=n6M(((AnW(eZq[#eZq-(1)+1],13))-(kzt+(1)*437))%4294967296,2680735548)
                local kqV=n6M(((AnW(eZq[#eZq-(2)+1],13))-(kzt+(2)*437))%4294967296,2680735548)
                local FH=n6M(((AnW(eZq[#eZq-(3)+1],13))-(kzt+(3)*437))%4294967296,2680735548)
                local Xvgl=n6M(((AnW(eZq[#eZq-(4)+1],13))-(kzt+(4)*437))%4294967296,2680735548)
                local TNv=ZL[Xl][3351]
                local elW=ZjP[kqV]
                local gj=TNv[elW]
                local Rto=ZL[FH][3351]
                local LaG=ZjP[Xvgl]
                local se3=Rto[LaG]Gy[(r5ab+1)*N6hX+Xj]=fwB(gj)Gy[(r5ab+2)*N6hX+Xj]=fwB(se3)r5ab=r5ab+2elseif qP5==22504then local jof=nNqH[aJ]
                local jJCN=TRU+(Zki*nsK+yIR*l424)%1000003
                local Xr=n6M(((AnW(jof[#jof-(1)+1],18))-(jJCN+(1)*1171))%4294967296,2393162236)
                local MYuM=ZL[Xr][3351]Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,MYuM}r5ab=r5ab+1else TY"invalid VM opcode"
            end
    else
        if qP5>25836then if qP5>37988then if43364==qP5 then
            local McG=nNqH[aJ]
            local J83=TRU+(Zki*nsK+yIR*l424)%1000003
            local nDHa=n6M(((AnW(McG[1],8))-(J83+(1)*730))%4294967296,1298177853)
            local nIGr=nDHa local exw0=r5ab-nIGr+1
            local OD8=nX(Gy,exw0,nIGr,N6hX,Xj)for UcL=exw0,r5ab do
                Gy[(UcL)*N6hX+Xj]=nil
            end
        r5ab=exw0 Gy[(r5ab)*N6hX+Xj]=OD8 local OD8=Gy[(r5ab)*N6hX+Xj]
        return Umy(OD8,1,OD8 .pfd8b)
    else
        TY"invalid VM opcode"
    end
else
    if34492==qP5 then
        local f6e0=nNqH[aJ]
        local hF=TRU+(Zki*nsK+yIR*l424)%1000003
        local SG=n6M(((AnW(f6e0[2],24))-(hF+(2)*3978))%4294967296,1685999036)
        local o3=n6M(((AnW(f6e0[1],24))-(hF+(1)*3978))%4294967296,1685999036)
        local rX=not not Gy[(r5ab)*N6hX+Xj][1]Gy[(r5ab)*N6hX+Xj]=nil r5ab=r5ab-1if rX then
            AFi={o3,SG}
        end
elseif not(qP5~=37988)then
        local w63F=Gy[(r5ab)*N6hX+Xj]r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={pfd8b=1,w63F[1][w63F[2]]}
    else
        TY"invalid VM opcode"
    end
end
else
    if qP5==25836then local a9w=nNqH[aJ]
    local cDe=TRU+(Zki*nsK+yIR*l424)%1000003
    local ju=n6M(((AnW(a9w[#a9w-(1)+1],27))-(cDe+(1)*3908))%4294967296,3587409531)r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={pfd8b=1,KZY(f9zr,Nd)[ZjP[ju]]}
elseif not(qP5~=23676)then
        local X6g=nNqH[aJ]
        local AQ=TRU+(Zki*nsK+yIR*l424)%1000003
        local kI=n6M(((AnW(X6g[#X6g-(1)+1],5))+(4294967296-(AQ+(1)*2318)))%4294967296,3801731807)
        local nIGr=kI local exw0=r5ab-nIGr+1
        local BsN=nX(Gy,exw0,nIGr,N6hX,Xj)
        local R21K=Gy[(exw0-1)*N6hX+Xj]
        local erIj=R21K[1]for UcL=r5ab,exw0,-1do Gy[(UcL)*N6hX+Xj]=nil
    end
local Jy if R21K.rc898 then
    Jy=FKJZ(R21K.q98fd,R21K.rc898,BsN)
elseif oduA and erIj==oduA and(BsN[1]==nil or BsN[1]==1)then
        Jy=KZY(f9zr,Nd)
    elseif zYH and erIj==zYH and BsN[1]==1then local yNlE=zYH(f9zr,BsN[2])Nd=BsN[2]Jy=yNlE
    else
        Jy=erIj(Umy(BsN,1,BsN.pfd8b))
    end
if erIj==NVE then
    rn3y[BsN[1]]=BsN[2]
elseif erIj==jD3 and BsN[1]==true then
        rn3y[Jy]=Ra(Jy)
    end
Gy[(exw0-1)*N6hX+Xj]=nil r5ab=exw0-2else TY"invalid VM opcode"
end
end
end
end
else
    if54516<qP5 then
        if54560<qP5 then
            if61484==qP5 then
                local Lm=nNqH[aJ]
                local ox=TRU+(Zki*nsK+yIR*l424)%1000003
                local SOO=n6M(((AnW(Lm[1],8))+(4294967296-(ox+(1)*3149)))%4294967296,1382337301)
                local h0=ZjP[SOO]
                local sD7=Gy[(r5ab)*N6hX+Xj][1]
                local qrBo=(sD7==h0)Gy[(r5ab)*N6hX+Xj]=fwB(qrBo)elseif57164==qP5 then
                    local qyc4=nNqH[aJ]
                    local oIxe=TRU+(Zki*nsK+yIR*l424)%1000003
                    local ZlvV=n6M(((AnW(qyc4[#qyc4-(3)+1],18))+(4294967296-(oIxe+(3)*116)))%4294967296,3287997684)
                    local R4=n6M(((AnW(qyc4[#qyc4-(4)+1],18))+(4294967296-(oIxe+(4)*116)))%4294967296,3287997684)
                    local nb=n6M(((AnW(qyc4[#qyc4-(1)+1],18))+(4294967296-(oIxe+(1)*116)))%4294967296,3287997684)
                    local RLE=n6M(((AnW(qyc4[#qyc4-(2)+1],18))+(4294967296-(oIxe+(2)*116)))%4294967296,3287997684)
                    local ofV=ZL[nb][3351]
                    local Hbc=ZjP[RLE]
                    local mAx=ofV[Hbc]
                    local UFO=ZL[ZlvV][3351]
                    local CWO3=ZjP[R4]
                    local GO=UFO[CWO3]Gy[(r5ab+2)*N6hX+Xj]=fwB(GO)Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,mAx}r5ab=r5ab+2else TY"invalid VM opcode"
                end
        else
            if qP5==54560then local Lkjp=nNqH[aJ]
            local HCGX=TRU+(Zki*nsK+yIR*l424)%1000003for UcL=2,(#Lkjp+1)do
                ZL[n6M(((AnW(Lkjp[(UcL)-1],16))-(HCGX+((UcL)-1)*2446))%4294967296,3861984806)]=nil
            end
    else
        TY"invalid VM opcode"
    end
end
else
    if qP5>51052then if51776==qP5 then
        Gy[(r5ab)*N6hX+Xj]={pfd8b=1,Gy[(r5ab)*N6hX+Xj][1]}
    elseif qP5==54516then local GSZV=nNqH[aJ]
        local hf=TRU+(Zki*nsK+yIR*l424)%1000003
        local whF=n6M(((AnW(GSZV[#GSZV-(1)+1],22))-(hf+(1)*3578))%4294967296,2282102958)
        local vJGg=whF r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={ZL[vJGg],3351}
    else
        TY"invalid VM opcode"
    end
else
    if qP5>=45665then if51052==qP5 then
        local w63F=Gy[(r5ab)*N6hX+Xj]r5ab=r5ab+1Gy[(r5ab)*N6hX+Xj]={pfd8b=1,w63F[1][w63F[2]]}
    elseif qP5==47944then local Ju=nNqH[aJ]
        local tOYV=TRU+(Zki*nsK+yIR*l424)%1000003
        local VwF=n6M(((AnW(Ju[#Ju-(2)+1],16))-(tOYV+(2)*730))%4294967296,138471107)
        local iu=n6M(((AnW(Ju[#Ju-(1)+1],16))-(tOYV+(1)*730))%4294967296,138471107)
        local e6=ZL[iu][3351]
        local xU=ZjP[VwF]
        local SL=(e6==xU)Gy[(r5ab+1)*N6hX+Xj]={pfd8b=1,SL}r5ab=r5ab+1else TY"invalid VM opcode"
    end
else
    if45664==qP5 then
        local aNxX=nNqH[aJ]
        local rc=TRU+(Zki*nsK+yIR*l424)%1000003
        local JKFD=n6M(((AnW(aNxX[1],19))+(4294967296-(rc+(1)*2470)))%4294967296,2053276276)
        local nIGr=JKFD local exw0=r5ab-nIGr+1
        local OD8=nX(Gy,exw0,nIGr,N6hX,Xj)for UcL=r5ab,exw0,-1do Gy[(UcL)*N6hX+Xj]=nil
    end
r5ab=exw0 Gy[(r5ab)*N6hX+Xj]=OD8 local OD8=Gy[(r5ab)*N6hX+Xj]
return Umy(OD8,1,OD8 .pfd8b)
else
    TY"invalid VM opcode"
end
end
end
end
end
else
    TY"invalid VM opcode"
end
if AFi then
    ss,ej=vsdg(AFi,ss,yIR)om,ymOf=iEav(uT,ss,ej)kN8E=1Q9=om[ymOf+52842]HZ,Dr=om[ymOf+46324],om[ymOf+52097]v3Md,aJ,KlWh=om[ymOf+34145],om[ymOf+33538],om[ymOf+17119]
end
end
end
do
    local dtrg,Jy=pcall(function()
        return fwB(b6(4,{},fwB(40,4)))
    end
)
local LZ=dtrg and dg(Jy)=="table"and Jy.pfd8b==3and Jy[1]==138and Jy[2]==nil and Jy[3]==false local RI_=dg(debug)=="table"and debug.info if dg(RI_)=="function"then
        local VHQM,Bpw7,m5,N5_=pcall(RI_,b6,"af")LZ=LZ and VHQM and Bpw7==3and m5==false and N5_==b6
    end
if not LZ then
    wh=n6M(wh,2291712866)
end
end
return b6(1,{},fwB(...))