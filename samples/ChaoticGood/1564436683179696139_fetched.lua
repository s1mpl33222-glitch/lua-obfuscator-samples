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
local keyless=false
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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=e4c596c7fcabc6da"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e4c596c7fcabc6da"
local expected=632423
local runtime,reason,issue,pr=nil,nil,"timed out",0
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
if s2*65536.0+s1~=3646516830 then problem("runtime checksum mismatch",3);return end
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
local cs={{fetch,"HttpGet",url}}
if fallback~=""then cs[#cs+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then cs[#cs+1]={candidate[1],candidate[2],fallback,true}end
cs[#cs+1]={candidate[1],candidate[2],fresh}
end
cs[#cs+1]={fetch,"HttpGet",retry}
local started,ni,ls,idle=clock(),1,0,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=cs[ni];ni=ni+1;ls=clock()
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
for poll=1,4000 do
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
if runtime or reason or(active==0 and ni>#cs)then break end
local t=clock()
if t-started-idle>=40 then problem("HTTP download timed out after 40 seconds",4);break end
if ni<=#cs and(active==0 or(active<2 and(completed or t-ls>=8)))then launch()
elseif not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break
else idle=idle+math.max(clock()-t-1,0)end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\48\100\55\51\98\57\97\50\53\54\53\56\51\56\56\48\98\52\49\54\98\52\54\50\99\53\52\56\54\49\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\118\103\122\95\79\65\53\105\67\81\119\50\112\78\75\97\58\50\106\78\48\79\112\77\86\45\72\107\108\65\70\90\87\66\107\65\103\83\65\58\86\82\108\102\87\118\101\51\108\122\56\49\55\76\120\112\45\85\104\108\70\111\118\81\90\121\114\84\72\68\73\84\73\108\56\72\110\76\112\104\65\107\106\68\102\118\107\52\82\79\105\67\79\97\75\114\82\49\112\112\98\98\110\111\118\97\72\71\115\50\104\106\105\111\89\111\111\119\119\90\80\57\85\78\67\48\82\84\110\69\117\88\57\74\77\102\98\56\69\71\69\71\68\108\48\103\121\79\83\88\115\113\113\51\87\118\107\121\103\78\73\113\50\71\75\66\54\81\112\69\76\57\45\54\101\45\116\117\114\49\114\117\81\99\95\114\53\82\90\70\120\79\70\101\105\108\107\75\70\77\118\53\114\102\49\79\95\119\74\72\88\68\88\118\83\114\53\97\121\68\50\75\102\100\56\69\45\88\121\122\111\70\80\50\49\48\104\106\85\113","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if not pcall(fetch,host,target)and reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
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
local handoff=alternate and {"\67\34\211\209\218\55\158\224\248\190\210\14\124\0\149\37\198\51\133\92\91\172\207\76\17\14\236\130\184\188\184\156\174\39\203\172\217\183\109\250\195\234\218\54\6\190\206\199\33\163\187\14\9\239\210\116\203\142\112\243\56\16\181\200\173\94\135\245\41\169\238\188\39\95\50\140\78\142\255\222\164\232\40\222\218\46\161\104\26\170\27\238\14\237\252\19\128\40\248\5\127\216\212\110\94\62\54\241\76\224\189\184\81\157\120\162\204\222\220\234\58\153\198\52\171\19\232\60\93\237\40\204\0\212\133\39\145\151\68\190\92\94\65\209\50\74\18\198\236\91\113\89\206\139\58\249\29\26\129\23\155\16\86\110\160\116\90\190\234\180\206\147\247\122\54\220\213\102\253\200\45\169\15\119\154\46\95\215\10\227\21\73\110\216\159\160\77\207\215\165\155\6\102\29\120\76\50\195\245\59\42\202\160\26\221\51\10\229\187\55\57\231\7\192\119\207\74\177\153\67\130\223\203\200\251\133\96\25\160\233\151\181\233\255\99\186\39\21\126\195\240\129\43\128\213\237\111\12\98\213\29\146\37\88\201\242\86\177\137\125\54\159\19\145\81\40\113\117\230\71\47\213\231\89\81\39\67\76\255\58\85\187\34\237\46\128\202\133\199\208\179\2\12\214\34\184\33",671574509,4037042643} or {"\142\215\107\208\203\36\105\164\232\193\2\172\158\161\214\27\187\91\39\59\254\55\134\86\17\210\131\146\222\3\67\177\5\183\222\151\106\103\193\117\209\78\211\78\240\191\134\217\129\157\18\68\77\208\228\111\234\41\228\34\43\137\230\76\226\3\36\98\214\65\16\50\59\206\175\198\22\21\181\149\95\44\188\171\206\232\243\241\242\150\49\139\25\128\167\29\122\144\110\152\134\60\129\171\57\18\204\148\125\136\113\41\72\13\56\7\186\31\142\134\48\214\170\133\129\123\75\65\19\194\20\34\0\32\53\169\52\91\35\175\223\232\62\254\160\36\163\123\187\47\24\206\130\200\170\48\164\202\26\11\165\34\106\195\154\3\137\144\151\148\219\180\244\243\119\66\126\83\194\120\118\232\151\229\101\231\2\134\20\61\228\245\205\150\249\211\121\24\84\122\232\178\187\216\90\35\113\38\190\153\200\86\95\160\50\100\254\55\219\243\230\173\89\212\135\188\20\78\68\162\82\57\97\207\147\202\93\240\199\187\70\187\68\222\111\60\6\11\112\232\176\243\72\168\52\89\68\33\135\26\58\72\11\120\49\241\253\160\180\50\142\247\8\147\184\171\29\202\148\160\70\9\74\6\73\204\141\38\208\84\134\204\77\209\36\12\168\41\116\181\116\149\72\140\165",3988343124,3767755746}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
