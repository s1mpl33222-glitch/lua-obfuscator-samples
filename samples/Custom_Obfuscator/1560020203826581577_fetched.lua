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
_bsdata0={8671823,"\198\211\212\209\213\157\147\148\217\208\224\220\207\217\223\210\156\219\223\221\161\212\228\222\165\233\167\234\210\230\227\175\203\195\233\186\220\212\214\178\248\200\223\208\245\236\253\215\228\233\234\234\195\220\221\011\249\229\005\200",93,5749141,2}
local f,b,a="static_content_elf5","050826-sixsense-meta7";pcall(function()a=readfile(f.."/init-"..b..".lua")end)if a and#a>2000 then a=loadstring(a)else a=nil end
if a then return a()else pcall(makefolder,f)a=game:HttpGet("https://sixsense.lol/api/init/camelungu")local z,e=loadstring(a)if not z then error(e or"[sixsense] init unavailable",0)end pcall(writefile,f.."/init-"..b..".lua",a)
pcall(function()for _,v in pairs(listfiles("./"..f))do local m=v:match("(init[%w%-]*).lua$")if m and m~=("init-"..b)then pcall(delfile,f.."/"..m..".lua")end end end)return z()end