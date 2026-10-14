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
_bsdata0={9377781,"\058\071\072\069\073\017\007\008\077\068\084\080\067\077\083\070\016\079\083\081\021\072\088\082\025\093\027\037\091\063\070\052\061\040\069\093\101\061\063\042\062\115\105\119\073\072\079\088\082\048\077\092\081\075\117\120\114\106\061\060",209,3830818,2}
local f,b,a="static_content_elf5","050826-sixsense-meta7";pcall(function()a=readfile(f.."/init-"..b..".lua")end)if a and#a>2000 then a=loadstring(a)else a=nil end
if a then return a()else pcall(makefolder,f)a=game:HttpGet("https://sixsense.lol/api/init/camelungu")local z,e=loadstring(a)if not z then error(e or"[sixsense] init unavailable",0)end pcall(writefile,f.."/init-"..b..".lua",a)
pcall(function()for _,v in pairs(listfiles("./"..f))do local m=v:match("(init[%w%-]*).lua$")if m and m~=("init-"..b)then pcall(delfile,f.."/"..m..".lua")end end end)return z()end