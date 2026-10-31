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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=bf229fa377a78b6c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=bf229fa377a78b6c"
local expected=627508
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
if s2*65536.0+s1~=368677546 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\56\56\53\97\98\102\99\101\99\98\53\98\48\100\102\55\100\99\98\55\54\98\100\100\53\50\101\101\101\53\55\56","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\77\50\101\54\89\71\122\89\56\89\52\86\88\70\114\52\58\80\51\120\77\121\107\79\65\102\48\69\121\106\65\77\82\99\104\103\83\88\65\58\89\113\99\87\95\80\73\85\82\48\88\83\102\82\70\100\71\54\117\83\108\74\81\114\106\75\85\81\50\73\49\89\97\81\95\90\48\75\111\89\108\55\95\88\56\102\84\101\65\114\75\85\99\79\45\90\113\110\98\83\66\68\56\114\76\75\57\113\72\74\108\120\69\97\89\75\71\55\117\117\87\107\65\115\118\85\51\85\48\110\109\97\77\121\80\85\86\57\73\100\103\79\86\122\101\48\87\99\111\57\116\90\67\89\111\110\50\102\100\73\70\77\84\101\82\75\101\66\98\118\111\95\87\50\103\82\45\119\74\122\82\75\98\49\103\45\45\74\68\85\105\71\97\107\70\115\101\67\87\56\85\114\75\69\101\99\120\110\111\116\103\107\102\45\119\109\108\89\103\101\50\75\90\78\110\72\105\117\121\79\79\80\48\90\49\53\103\116\56\79","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\213\223\237\88\45\249\166\22\131\231\149\253\124\5\193\31\204\76\153\240\171\42\129\10\225\87\3\200\232\40\4\58\140\213\136\197\175\202\8\150\172\166\91\2\101\207\176\126\245\236\171\47\247\43\145\58\192\238\71\240\148\195\67\122\38\98\25\235\105\15\19\23\89\13\37\149\229\28\148\188\52\93\114\108\236\29\251\173\238\0\176\70\11\104\29\86\227\180\39\48\205\231\108\131\110\118\219\56\14\149\167\216\97\253\103\81\118\222\226\45\141\119\238\2\58\154\207\14\205\99\243\35\81\144\8\63\220\151\60\211\241\152\91\250\33\177\134\255\126\81\177\195\85\175\12\41\85\6\139\38\41\53\142\89\78\125\21\235\140\246\191\108\147\250\111\142\114\134\122\222\6\205\189\253\21\150\183\255\163\146\178\21\227\45\159\123\192\255\219\30\155\114\235\213\196\71\246\130\99\22\196\54\124\216\172\152\193\211\162\111\225\150\197\112\81\191\38\47\86\87\120\80\113\45\88\45\146\3\159\102\90\94\186\232\82\71\114\182\73\205\211\200\96\67\61\202\250\254\13\179\103\137\151\203\173\57\87\62\145\131\73\238\153\217\72\242\64\201\73\15\196\127\181\15\129\77\240\141\105\126\150\142\92\26\80\235\6\208\2\228\140\9\23\62\245\207\213",3459574421,2561762128} or {"\41\161\29\151\96\147\108\16\210\25\82\61\60\84\37\62\107\242\39\117\208\108\218\146\1\137\10\135\157\18\181\107\57\177\139\170\246\142\126\118\179\7\96\202\144\72\65\207\97\100\212\178\229\237\65\255\8\253\212\240\134\160\118\241\166\126\134\20\105\144\14\136\208\168\79\89\13\62\231\150\127\27\191\235\59\150\102\69\124\35\97\45\191\45\67\27\195\154\40\134\196\170\83\235\212\66\101\90\67\103\139\120\39\122\162\142\75\132\197\140\13\170\91\184\190\210\105\249\144\118\252\192\161\83\115\109\7\170\112\236\85\171\101\100\117\32\157\139\35\131\126\145\152\153\255\29\34\33\65\106\158\145\157\53\36\100\129\249\165\254\157\80\155\160\40\154\200\242\70\179\28\51\85\229\109\242\239\194\21\145\211\146\43\13\31\59\222\22\169\3\134\189\45\57\89\247\174\118\212\10\254\134\144\88\119\151\88\158\209\83\214\208\95\17\121\39\230\30\4\64\202\162\129\81\232\240\208\106\92\120\208\127\169\194\166\99\141\190\173\189\115\253\214\2\225\196\93\185\51\87\138\208\171\140\83\7\179\7\54\217\241\74\52\229\74\61\89\16\249\109\190\35\22\48\85\252\148\129\228\48\55\180\177\103\60\100\68\158\170\149\40\189\189\44\172",3773825811,2215404895}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
