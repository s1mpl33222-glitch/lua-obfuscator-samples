--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v11,v12) local v13={};for v14=1, #v11 do v6(v13,v0(v4(v1(v2(v11,v14,v14 + 1 )),v1(v2(v12,1 + (v14% #v12) ,1 + (v14% #v12) + 1 )))%256 ));end return v5(v13);end local v8=v7("\227\202\216\46","\126\177\163\187\69\134\219\167");local v9=915 -(668 + 222) ;local v10=24 + 126 ;if (v9>=(897 -(282 + 595))) then local v15=1637 -(1523 + 114) ;while true do if (v15==(0 + 0)) then print(v8   .. " desbloqueou a velocidade mÃ¡xima!" );v10=300;break;end end else print(v8   .. " ainda nÃ£o desbloqueou a velocidade mÃ¡xima." );end print(v7("\13\194\39\192\166","\156\67\173\74\165"),v8);print("NÃ­vel:",v9);print(v7("\2\178\69\25\191\47\66\53\179\76\76","\38\84\215\41\118\220\70"),v10);