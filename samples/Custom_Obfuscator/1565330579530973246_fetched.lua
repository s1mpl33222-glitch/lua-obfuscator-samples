-- this file was protected using sixbyte obfuscator v1.9.1 [https://sixsense.lol]
--[[
                                                          &&%%%%*             
                                                    8&%%%%%%%%%&              
                                              %%%%%%%%%%%%%%%%&               
                               888%   B88%88888888888888888%%                 
                           B8888888888888888888888888888888  &                
                        BBBBBBBBBBBBBBBBBBBBBBBBBBBBB88  8%%&               
                     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BB    &%%%%%               
                   ###########################@@8     %%%%%%%*                
                  #%%%%%%%%%%%%%%%%%%####@@       8%%%%%%%%%&&                
                #%%%%%%%%%%%%%%%%%%#%       %&%%  888888888888%               
               &&&&&&&&&&&&&&&&%         %%% &%%& 8BBBBBBBBBBB%               
              BBBBBBBBBBBBB&             %%% &%&& 8BBBBBBBBBBB                
              MMMMMMMMMMMB      &#           &&%& B@@@@@@@@@@B                
             MWWWWWWWWWM      &%%%          %%%&  ###########                 
             @@@@@@@@@         &&%%%%     %%%%%& #%%%%%%%%%%%                 
             $$$$$$$@            %%&%%%%%&&%%& %%&&&&&&&&&&%                  
             $$$$$$         &88&&   %&%&&%    &888888888888&                  
             $$$$$$        BBBBBBBB8MBBBMBBBBBBBBBBBBBBBBBB                   
             $$$$$        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMB                    
             $$$$         W@@@@@@@@@@@@@@@@@@@@@@@@@@@@@W                     
              $$$         @$$$$@$$$$$$$$$$$$$$$$$$$$$$$@                      
              $$          $$$$$  $$$$$$$$$$$$$$$$$$$$$                        
               $           $$$$  $$$$$$$$$$$$$$$$$$$$                         
                            $$   $$$$$$$$$$$$$$$$$$                           
                             $   $$$$$$$$$$$$$$$$                             
                                 $$$$$$$$$$$$$                                
                                $$$$$$$$$$$                                   
                              $$$$$$$$$                                       
                            $$$$$$░         ░     

            sixsense. © 2026. all rights reserved.░     ░  
            #getgoodgetsixsense #sixsenseontop #nosixsensenotalk #werghoul

            sixbyte(obf) made by e7hubsk1, this (obf) is strictly intended for sixsense property only.
]]
--
_bsdata0={2207472,"\035\048\049\046\050\250\240\241\036\052\046\244\058\049\065\061\048\058\064\051\253\060\064\062\002\074\006\005\073\007\051\019\075\083\079\033\089\020\043\059\086\079\046\079\095\043\025\053\079\034\061\093\078\083\099\038\104\058\041\057\097\069\040",186,5820314,2}
local f,b,a="static_content_elf5","050826-sixsense-sixbyte-1-9-1";pcall(function()a=readfile(f.."/init-"..b..".lua")end)if a and#a>2000 then a=loadstring(a)else a=nil end
if a then return a()else pcall(makefolder,f)a=game:HttpGet("https://api.sixsense.lol/v1/init/camelungu?v=sixbyte-1-9-1")local z,e=loadstring(a)if not z then error(e or"[sixsense] init unavailable",0)end pcall(writefile,f.."/init-"..b..".lua",a)
pcall(function()for _,v in pairs(listfiles("./"..f))do local m=v:match("(init[%w%-]*).lua$")if m and m~=("init-"..b)then pcall(delfile,f.."/"..m..".lua")end end end)return z()end