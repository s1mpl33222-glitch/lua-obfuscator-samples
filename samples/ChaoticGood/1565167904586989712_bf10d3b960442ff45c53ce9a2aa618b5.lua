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
_bsdata0={7974045,"\188\201\202\199\203\147\137\138\189\205\199\141\211\202\218\214\201\211\217\204\150\213\217\215\155\227\159\158\226\160\195\228\236\192\204\204\239\197\242\200\239\198\206\194\177\197\183\212\206\236\229\201\207\208\221\243\222\240\211\230\246\213\193",83,5205830,2}
local f,b,a="static_content_elf5","050826-sixsense-compiler14-reporting-v4";pcall(function()a=readfile(f.."/init-"..b..".lua")end)if a and#a>2000 then a=loadstring(a)else a=nil end
if a then return a()else pcall(makefolder,f)a=game:HttpGet("https://api.sixsense.lol/v1/init/camelungu?v=compiler14-reporting-v4")local z,e=loadstring(a)if not z then error(e or"[sixsense] init unavailable",0)end pcall(writefile,f.."/init-"..b..".lua",a)
pcall(function()for _,v in pairs(listfiles("./"..f))do local m=v:match("(init[%w%-]*).lua$")if m and m~=("init-"..b)then pcall(delfile,f.."/"..m..".lua")end end end)return z()end