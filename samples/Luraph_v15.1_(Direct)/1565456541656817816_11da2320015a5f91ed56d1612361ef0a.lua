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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=c6bd14776d4ea474"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=c6bd14776d4ea474"
local expected=618951
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
if s2*65536.0+s1~=733717851 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\49\49\100\97\50\51\50\48\48\49\53\97\53\102\57\49\101\100\53\54\100\49\54\49\50\51\54\49\101\102\48\97","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\87\112\67\121\101\54\108\51\72\88\45\88\54\116\87\108\58\57\71\84\119\86\108\68\78\55\118\105\73\78\77\106\113\122\75\102\90\69\81\58\88\73\67\74\119\106\106\71\49\88\107\109\79\49\80\79\113\49\49\78\57\119\49\117\49\73\66\89\77\89\112\55\65\83\104\87\82\55\80\122\107\109\83\90\106\56\95\100\103\98\70\67\121\104\69\53\66\112\80\105\121\97\111\49\114\95\69\99\65\120\67\118\116\48\67\104\50\84\111\119\80\54\55\110\71\90\69\83\98\65\105\45\90\99\57\66\88\95\86\51\50\121\113\66\113\80\103\118\57\90\97\53\79\118\78\95\70\115\108\73\105\95\99\75\72\110\66\121\111\77\84\50\81\56\68\56\82\103\71\67\70\73\74\97\103\45\87\56\49\45\72\83\117\87\106\109\103\82\78\107\67\99\105\107\83\105\51\104\81\82\90\113\89\66\48\85\105\66\84\50\111\115\57\51\114\85\120\77\51\49\69\48\104\107\89\83\57\98\90\110","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\202\126\225\97\16\174\191\19\178\128\64\91\172\146\253\175\120\103\61\110\171\202\118\188\116\32\190\40\186\93\116\237\156\222\179\242\247\135\159\28\206\251\112\140\102\91\212\250\47\215\88\194\4\57\230\248\92\192\29\152\216\58\89\126\139\25\207\152\199\205\239\70\9\242\34\209\5\49\23\190\87\118\68\185\152\247\28\38\135\182\237\87\247\8\247\231\231\13\176\173\201\138\222\197\217\127\23\21\155\78\10\34\223\120\199\251\124\139\116\176\136\2\166\231\53\134\155\78\193\180\49\24\125\132\201\3\239\212\9\38\184\241\86\86\113\154\227\172\112\31\199\98\128\236\16\235\173\212\72\41\42\96\47\11\111\192\188\5\159\72\15\65\55\227\78\3\178\238\211\40\120\144\77\19\143\250\67\148\208\207\20\36\74\237\32\40\166\141\214\228\98\151\103\56\232\121\139\156\136\123\76\194\227\104\129\178\101\62\26\48\128\51\12\162\43\246\211\193\28\108\174\22\37\112\61\162\163\89\45\82\50\205\235\244\121\9\68\28\92\11\245\66\85\8\96\107\18\227\103\67\111\146\138\234\5\45\215\214\104\58\219\162\78\52\131\172\35\133\4\106\220\4\112\62\237\206\64\62\54\184\240\182\167\224\21\23\228\164\189\201\91\94\6\80\203\106\90",1830568560,1939103772} or {"\125\152\54\251\83\223\127\80\18\239\95\136\135\130\81\74\190\162\98\137\16\219\229\20\161\161\133\215\50\33\14\68\26\198\98\242\127\129\3\19\141\25\194\58\246\212\44\67\44\41\245\251\71\254\111\93\202\134\237\180\184\179\107\212\192\229\206\129\223\217\63\237\3\70\0\110\230\4\238\71\179\251\154\30\71\246\196\2\85\88\171\109\93\193\12\120\180\47\158\36\42\18\158\154\128\227\64\77\46\178\15\103\186\189\10\4\184\172\107\153\79\4\218\190\13\36\82\207\36\12\162\137\225\217\5\104\184\115\183\117\76\50\162\114\66\58\127\59\52\77\175\77\136\135\127\110\56\57\167\40\223\61\196\209\129\247\102\221\17\79\86\233\15\14\103\109\183\249\33\136\72\58\185\138\37\98\227\111\184\45\84\96\205\86\222\87\57\49\6\219\251\210\243\185\32\203\49\126\157\204\39\162\151\85\169\29\249\125\114\98\226\217\190\27\253\15\51\192\165\213\48\114\130\234\177\253\229\11\165\74\70\182\156\225\123\106\24\34\53\192\247\234\114\223\122\97\2\183\120\253\158\64\61\249\180\155\211\234\15\203\2\36\48\124\72\47\61\148\39\255\91\4\90\104\210\141\145\77\106\115\13\65\253\20\36\61\72\184\61\3\232\251\197\7\95",2170702004,1655005739}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
