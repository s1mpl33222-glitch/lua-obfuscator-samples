-- Protected by sixsense | @elhubski, @boaindoor, @filthykikz
--  ██████  ██▓▒██   ██▒  ██████ ▓█████  ███▄    █   ██████ ▓█████
-- ▒██    ▒ ▓██▒▒▒ █ █ ▒░▒██    ▒ ▓█   ▀  ██ ▀█   █ ▒██    ▒ ▓█   ▀
-- ░ ▓██▄   ▒██▒░░  █   ░░ ▓██▄   ▒███   ▓██  ▀█ ██▒░ ▓██▄   ▒███
--   ▒   ██▒░██░ ░ █ █ ▒   ▒   ██▒▒▓█  ▄ ▓██▒  ▐▌██▒  ▒   ██▒▒▓█  ▄
-- ▒██████▒▒░██░▒██▒ ▒██▒▒██████▒▒░▒████▒▒██░   ▓██░▒██████▒▒░▒████▒
-- ▒ ▒▓▒ ▒ ░░▓  ▒▒ ░ ░▓ ░▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░░░ ▒░ ░
-- ░ ░▒  ░ ░ ▒ ░░░   ░▒ ░░ ░▒  ░ ░ ░ ░  ░░ ░░   ░ ▒░░ ░▒  ░ ░ ░ ░  ░
-- ░  ░  ░   ▒ ░ ░    ░  ░  ░  ░     ░      ░   ░ ░ ░  ░  ░     ░
--       ░   ░   ░    ░        ░     ░  ░         ░       ░     ░  ░
_bsdata0={9593203,"\189\202\203\200\204\148\138\139\190\206\200\142\212\203\219\215\202\212\218\205\151\214\218\216\156\228\160\159\227\161\186\221\173\191\233\199\166\231\202\223\212\202\239\233\182\229\208\218\215\203\201\231\227\208\205\213\244\217\253\250\227\247\194",84,5107567,2}
local f,b,a="static_content_elf5","050826-sixsense-compiler14-reporting-v4";pcall(function()a=readfile(f.."/init-"..b..".lua")end)if a and#a>2000 then a=loadstring(a)else a=nil end
if a then return a()else pcall(makefolder,f)a=game:HttpGet("https://api.sixsense.lol/v1/init/camelungu?v=compiler14-reporting-v4")local z,e=loadstring(a)if not z then error(e or"[sixsense] init unavailable",0)end pcall(writefile,f.."/init-"..b..".lua",a)
pcall(function()for _,v in pairs(listfiles("./"..f))do local m=v:match("(init[%w%-]*).lua$")if m and m~=("init-"..b)then pcall(delfile,f.."/"..m..".lua")end end end)return z()end