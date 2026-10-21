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
local fresh=url.."?retry=0911dac9721b1b47"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=0911dac9721b1b47"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\99\49\101\56\54\50\98\99\53\57\50\56\54\50\51\97\102\49\102\54\54\56\102\97\52\55\49\48\98\102\54\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\65\115\80\97\50\51\54\51\112\122\88\77\76\87\52\100\58\48\110\82\118\72\54\107\57\68\110\101\74\88\88\101\76\89\57\105\95\73\103\58\108\69\87\45\122\75\49\98\108\107\90\83\71\65\54\81\77\82\55\98\113\75\85\83\76\115\75\105\87\51\106\80\76\65\68\65\80\105\50\55\78\74\117\79\116\81\106\105\45\84\72\51\56\102\45\51\112\78\76\100\67\113\90\105\54\45\72\113\111\87\81\83\108\95\121\72\98\78\107\98\77\109\95\76\56\51\121\57\101\116\112\87\109\113\99\107\78\113\89\57\108\89\68\102\116\54\101\106\103\98\56\83\68\120\98\104\73\50\89\106\66\83\52\78\71\99\49\120\48\88\104\82\73\117\120\121\102\76\65\77\103\114\56\74\86\83\102\79\117\108\55\116\112\107\110\71\67\77\48\103\51\109\49\119\55\104\75\118\55\53\75\87\72\120\71\95\66\49\53\72\72\83\110\102\74\120\76\73\107\77\55\79\50\115\99\108\82\99\85\50","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\212\171\213\136\86\170\154\195\60\233\135\232\8\124\35\32\86\176\41\202\128\63\198\83\82\90\195\177\166\25\56\236\42\48\63\191\129\79\17\226\213\60\179\56\204\239\6\76\71\143\113\178\229\25\163\247\8\106\217\143\71\217\93\69\208\207\115\0\8\145\134\228\210\0\83\146\6\67\198\146\171\38\34\79\216\44\241\243\31\2\106\159\155\70\194\176\241\11\56\200\109\72\199\148\115\236\188\66\21\25\229\41\178\198\139\230\214\251\66\213\186\42\103\253\210\55\26\150\212\143\1\105\41\185\43\122\175\76\237\130\5\41\243\73\7\132\50\139\145\11\117\68\27\154\19\106\25\211\20\173\229\79\129\97\202\22\105\227\248\214\230\248\231\49\41\56\94\203\216\62\52\213\144\147\146\63\253\90\108\203\225\126\186\172\227\17\210\187\241\200\90\174\94\77\55\209\218\38\33\26\96\57\214\113\237\112\240\101\179\199\89\232\47\9\152\22\151\19\72\13\171\12\240\186\152\54\7\151\228\26\17\80\86\250\229\141\60\45\139\240\10\203\6\135\84\128\179\67\146\85\26\152\109\151\218\6\137\185\168\72\11\178\107\45\202\74\87\228\16\224\254\123\139\68\245\180\107\31\3\237\167\226\165\210\46\129\132\162\82\53\81\132\114\59\198\5\187",2360053672,1758683241} or {"\109\190\117\8\140\245\66\75\0\87\173\196\211\144\173\97\182\204\243\186\157\113\28\222\12\43\103\103\109\75\129\176\191\5\103\166\3\3\208\100\214\152\140\73\230\169\105\204\16\25\72\223\185\39\80\171\80\199\160\239\182\65\153\173\115\61\114\174\218\191\106\164\79\185\131\110\149\4\251\11\19\69\193\14\122\207\242\183\144\9\225\54\112\18\168\99\80\169\208\9\187\85\209\234\46\81\190\16\3\55\81\95\208\192\20\170\9\115\21\243\72\147\139\59\111\253\120\236\250\182\184\93\224\37\82\103\233\219\56\80\164\170\90\201\89\169\242\73\173\219\4\63\48\116\223\96\81\203\56\121\138\247\208\99\69\67\181\248\111\130\181\169\231\28\153\95\44\236\192\38\183\249\101\237\172\40\6\167\133\247\58\86\20\38\100\101\192\143\247\140\126\191\186\196\191\2\172\37\66\237\248\204\91\201\135\12\241\175\46\44\66\233\16\241\197\125\145\237\45\155\248\164\169\72\25\79\22\215\44\127\66\165\150\180\234\249\240\207\63\118\121\242\37\136\178\37\179\51\30\171\106\185\176\157\80\227\120\228\124\29\208\157\7\102\200\114\218\214\223\161\214\198\100\52\9\224\30\74\100\102\164\37\77\81\193\224\233\86\162\57\191\61\230\238\174",1172024030,1463181944}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
