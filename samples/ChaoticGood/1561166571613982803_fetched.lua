local credential=...
local type,pcall,error,tostring,tonumber=type,pcall,error,tostring,tonumber
local rawset,getfenv=rawset,getfenv
local globals,host=_G,game
local byte,gsub,find=string.byte,string.gsub,string.find
local wait=type(task)=="table"and task.wait
local clock=os.clock
local compile=loadstring
local function member(value,key)
local ok,result=pcall(function()return value[key]end)
if ok then return result end
end
local keyless=true
if keyless then
credential=""
elseif type(credential)~="string"then
for lv=2,4 do
local f,sc=pcall(getfenv,lv)
local v=f and type(sc)=="table"and member(sc,"script_key")
if type(v)=="string"then credential=v;pcall(rawset,sc,"script_key",nil);break end
end
end
local spawn=member(task,"spawn")
local fetch=member(host,"HttpGet")
local ok,senv=pcall(function()return getfenv()end)
if not ok or type(senv)~="table"then senv=globals end
local ok,environment=pcall(function()return getgenv()end)
if not ok or type(environment)~="table"then environment=senv end
local function global(key)return member(environment,key)or member(senv,key)or member(globals,key)end
local sample=20
local platform="?"
pcall(function()
local input=host:GetService("UserInputService")
platform=input.TouchEnabled and not input.KeyboardEnabled and"m"or"d"
end)
local function ms(x)return math.floor(x*1000+.5)end
local reqs,seen={},{}
local function add(fn,name)
if type(fn)=="function"and not seen[fn]then seen[fn]=true;reqs[#reqs+1]={fn,name}end
end
add(global("request"),"request")
add(global("http_request"),"http_request")
add(global("httpRequest"),"httpRequest")
add(global("httprequest"),"httprequest")
add(member(global("http"),"request"),"http.request")
add(member(global("syn"),"request"),"syn.request")
local bt=member(global("buffer"),"tostring")
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=81e6e03b6c09171a"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=81e6e03b6c09171a"
local expected=622786
local runtime,reason,issue,pr=nil,nil,"request failed",0
local transport,issueTransport="HttpGet","HttpGet"
local function problem(message,rank)
if rank>=pr then issue,pr,issueTransport=message,rank,transport end
end
local arrived,ck,cm=0,0,0
local function accept(value)
local began=clock()
if type(value)=="buffer"then local ok,text=pcall(bt,value);value=ok and text or nil end
if type(value)~="string"then problem("unsupported response body",1);return end
if #value~=expected then
if #value<1024 and find(value,"Failed to send HTTP request.",1,true)then
problem(find(value,"timed out",1,true)and"HTTP request timed out"or"HTTP request failed",2)
else problem("received "..#value.." bytes; expected "..expected,2)end
return
end
local s1,s2,i=1.0,0.0,1
while i+7<=#value do
local a,b,c,d,e,f,g,h=byte(value,i,i+7)
s2=(s2+8*s1+8*a+7*b+6*c+5*d+4*e+3*f+2*g+h)%65521
s1=(s1+a+b+c+d+e+f+g+h)%65521;i=i+8
end
while i<=#value do s1=(s1+byte(value,i))%65521;s2=(s2+s1)%65521;i=i+1 end
if s2*65536.0+s1~=2050046860 then problem("runtime checksum mismatch",3);return end
local t=clock();ck=t-began
local ok,compiled,detail=pcall(compile,value,"=FlowAuthRuntime")
local text=not(ok and type(compiled)=="function")and tostring(ok and detail or compiled)
if text and not(find(text,"FlowAuthRuntime:")or find(text,"xpected")or find(text,"syntax"))then
if wait then pcall(wait,1.5)end
ok,compiled,detail=pcall(compile,value,"=FlowAuthRuntime")
end
cm=clock()-t
if ok and type(compiled)=="function"then runtime=compiled;return true end
reason=(ok and detail or compiled)or"compiler returned no function";issueTransport=transport
return false
end
local candidates={{fetch,"HttpGet",url}}
if fallback~=""then candidates[#candidates+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then candidates[#candidates+1]={candidate[1],candidate[2],fallback,true}end
candidates[#candidates+1]={candidate[1],candidate[2],pinned}
end
candidates[#candidates+1]={fetch,"HttpGet",retry}
local started,ni,ls=clock(),1,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=candidates[ni];ni=ni+1;ls=clock()
local job={name=candidate[2],alternate=candidate[4]};js[#js+1]=job
local function run()
if shut or job.started then return end
job.started=true
local ok,response
if job.name=="HttpGet"then ok,response=pcall(candidate[1],host,candidate[3])
else ok,response=pcall(candidate[1],{Url=candidate[3],Method="GET"})end
if not shut then job.ok,job.response,job.done=ok,response,true end
end
if asynchronous then
local ok,thread=pcall(spawn,run);job.thread=ok and thread or nil
if not job.started and type(job.thread)~="thread"then asynchronous=false;run()end
else run()end
end
launch()
for poll=1,2000 do
if clock()-started>=40 then problem("HTTP download timed out after 40 seconds",4);break end
local active,completed=0,false
for i=1,#js do
local job=js[i]
if not job.done then active=active+1
elseif not job.read then
job.read=true;completed=true;transport=job.name;arrived=clock()-started
local response=job.response;job.response=nil
if not job.ok then problem("request failed",1)
elseif type(response)=="table"then
local status=tonumber(member(response,"StatusCode")or member(response,"status_code")or member(response,"Status")or member(response,"status"))or 0
local success=member(response,"Success");if success==nil then success=member(response,"success")end
if status==0 and success==true then status=200 end
if success==false and status<400 then status=500 end
if status>=200 and status<300 then accept(member(response,"Body")or member(response,"body")or member(response,"ResponseBody")or member(response,"response_body"))
else problem("HTTP "..status,2)end
else accept(response)end
if runtime or reason then alternate=job.alternate;break end
end
end
if runtime or reason or(active==0 and ni>#candidates)then break end
if ni<=#candidates and(active==0 or(active<2 and(completed or clock()-ls>=8)))then launch()
elseif not asynchronous or not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\117\56\57\97\70\74\97\75\77\99\81\83\117\88\104\68\58\70\85\118\103\102\56\111\102\105\65\114\111\76\117\54\120\99\112\68\75\101\81\58\45\88\101\101\86\45\73\48\71\121\82\115\54\97\102\85\68\88\95\112\76\86\71\116\108\99\51\109\100\75\118\105\107\104\52\77\85\48\113\50\89\52\106\86\65\48\116\89\70\81\85\55\85\87\90\57\65\120\67\122\72\97\83\108\110\86\89\76\103\68\120\121\118\114\84\116\67\49\67\112\74\87\97\115\100\119\115\115\45\118\56\55\71\85\71\103\97\53\57\117\113\50\53\53\72\109\116\81\66\110\79\100\79\99\53\70\79\116\84\97\101\102\116\107\70\107\74\104\50\78\116\83\68\90\71\56\69\79\51\115\102\100\104\108\49\108\89\71\56\121\77\49\114\68\97\77\98\65\84\97\67\66\68\102\119\77\99\79\95\103\57\68\120\103\116\68\99\71\79\51\83\102\113\115\56\100\117\118\86\90\57\67\57\89\95\50\72\107\89\89","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if fetch then pcall(fetch,host,target)elseif reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
end)
end
if not runtime then
pcall(function()
local text=gsub(issueTransport..": "..tostring(reason or issue),"[^%w .:;,()=/_-]","?")
local body=(reason and"launcher_load"or"launcher_download")..'","executor":"launcher","diag":["pf='..platform..'"],"error":"'..string.sub(text,1,160)..'"}'
for _,base in ipairs{url,fallback}do
if base~=""then send(base,"/v1/telemetry/executor",body)end
end
end)
if reason then error("FlowAuth runtime compilation failed: "..tostring(reason),0)end
error("FlowAuth runtime download failed ("..issueTransport.."): "..tostring(issue)..". Please run the loader again.",0)
end
if sample>0 and spawn and math.random(sample)==1 then
pcall(send,alternate and fallback or url,"/v1/telemetry/load",'load","pf":"'..platform..'","tp":"'..transport..'","fb":'..(alternate and 1 or 0)..',"tr":'..#js..',"dl":'..ms(arrived)..',"ck":'..ms(ck)..',"cm":'..ms(cm)..',"w":'..sample..'}',2)
end
if asynchronous then pcall(wait)end
local handoff=alternate and {"\228\154\214\53\188\241\124\120\141\66\33\30\12\166\88\40\238\15\83\133\199\227\246\148\56\30\39\65\38\160\248\210\96\106\92\58\119\169\146\106\49\242\247\19\127\236\5\209\209\69\77\164\219\187\167\85\190\154\219\237\232\5\237\97\97\225\248\182\154\252\51\162\195\143\44\212\133\22\134\1\168\228\173\145\116\12\121\202\252\237\166\180\208\170\1\230\227\135\250\133\23\68\22\163\139\47\51\17\89\134\152\97\126\164\203\170\70\0\65\29\105\218\74\28\187\169\226\150\137\121\77\132\20\166\188\76\66\39\111\164\216\35\91\27\168\79\139\254\7\202\6\38\82\114\25\103\62\162\171\153\227\65\99\9\243\136\164\117\136\149\216\150\150\82\231\182\147\149\199\179\227\242\153\209\118\43\170\239\174\198\2\250\0\70\143\63\207\126\13\68\204\107\250\145\152\23\177\130\171\82\255\138\165\188\255\9\150\245\42\250\170\228\11\218\77\51\45\70\11\229\253\228\237\66\153\96\77\128\168\71\251\140\10\145\92\6\242\236\222\128\235\217\189\204\189\42\45\154\58\52\166\64\74\205\63\140\243\94\215\188\156\184\52\106\129\123\4\38\67\169\98\76\50\213\142\152\188\229\71\188\229\91\242\105\123\84\231\101\32\6\223\184\203\74\166\18\46",4257768188,3839386237} or {"\156\232\254\165\134\199\64\101\161\24\172\42\212\118\45\233\15\34\44\197\183\134\174\70\183\108\1\230\7\248\83\98\205\218\127\106\63\191\12\38\69\24\227\225\98\135\32\118\223\118\128\156\166\201\27\199\201\230\156\248\198\80\91\83\239\190\120\231\93\105\255\22\206\11\139\99\4\42\27\132\89\176\214\4\208\44\186\250\115\182\154\110\85\163\152\82\25\45\161\74\151\195\84\196\143\42\7\111\112\199\68\187\36\102\101\41\140\38\148\12\186\233\25\165\119\38\224\8\95\104\32\185\218\151\225\125\112\103\116\179\83\34\8\241\14\16\125\0\12\136\76\150\91\63\242\225\161\2\226\188\245\34\183\212\169\114\72\92\53\40\65\73\110\23\20\245\193\204\122\235\129\225\195\19\145\73\47\3\184\104\116\150\87\113\184\109\214\79\44\227\168\205\132\24\117\181\6\246\180\16\255\106\253\58\12\181\255\108\27\69\49\242\96\127\103\84\205\144\43\177\79\118\178\120\93\9\4\88\161\246\14\110\74\150\42\69\47\83\165\170\26\54\73\61\86\72\226\122\250\117\163\187\137\111\146\114\222\84\250\171\171\141\22\186\207\136\44\76\101\90\164\161\108\122\190\26\151\169\241\103\68\17\251\133\174\0\135\171\215\68\145\75\78\207\172",1311777392,3537069196}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
