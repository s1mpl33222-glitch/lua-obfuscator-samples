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
_bsdata0={6806067,"\183\196\197\194\198\142\132\133\202\193\209\205\192\202\208\195\141\204\208\206\146\197\213\207\150\218\152\226\224\160\165\224\190\223\208\179\185\188\226\197\228\191\198\243\206\173\245\237\214\213\202\204\251\249\200\187\210\253\239\185",78,5791596,2}
local f,b,a="static_content_elf5","050826-sixsense-meta7";pcall(function()a=readfile(f.."/init-"..b..".lua")end)if a and#a>2000 then a=loadstring(a)else a=nil end
if a then return a()else pcall(makefolder,f)a=game:HttpGet("https://sixsense.lol/api/init/camelungu")local z,e=loadstring(a)if not z then error(e or"[sixsense] init unavailable",0)end pcall(writefile,f.."/init-"..b..".lua",a)
pcall(function()for _,v in pairs(listfiles("./"..f))do local m=v:match("(init[%w%-]*).lua$")if m and m~=("init-"..b)then pcall(delfile,f.."/"..m..".lua")end end end)return z()end