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
local fresh=url.."?retry=0cbba96bc798f1f6"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=0cbba96bc798f1f6"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\51\48\49\97\98\49\101\51\100\49\57\97\100\102\102\97\55\100\102\54\49\50\102\97\100\98\51\57\53\55\98\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\115\73\65\52\49\79\100\68\51\112\113\54\78\97\78\86\58\104\121\88\83\52\113\45\85\85\106\65\122\82\98\87\48\90\111\66\50\65\103\58\106\113\85\119\115\49\101\115\103\111\78\112\54\75\56\109\100\84\81\55\81\111\113\95\115\74\116\72\109\108\114\51\99\104\84\97\97\122\122\74\55\56\90\97\80\57\100\102\101\79\100\74\68\112\81\97\88\53\82\116\83\84\113\83\102\112\49\82\85\90\73\99\108\68\45\90\49\50\78\120\67\51\119\120\112\49\76\77\99\83\67\122\57\98\114\81\116\90\57\110\99\49\88\121\50\112\116\50\84\111\97\80\119\51\111\117\65\120\102\103\75\98\103\117\75\95\120\115\49\55\99\71\122\97\67\104\95\98\71\66\109\57\74\45\105\76\76\120\109\116\99\84\49\90\88\50\78\107\52\117\105\111\89\120\117\103\87\48\52\95\69\77\52\79\112\80\79\105\67\56\106\78\56\75\54\114\89\68\122\69\85\99\100\84\81\72\119\72\80\99","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\39\91\55\37\119\241\200\206\76\223\242\106\65\202\112\4\38\226\151\65\136\172\179\200\152\254\91\245\243\250\225\118\99\101\240\108\67\11\151\44\139\36\228\105\201\113\183\204\103\22\31\193\196\6\19\21\212\35\55\157\143\223\62\56\221\100\70\187\252\95\101\153\241\203\119\66\58\96\102\98\92\162\70\165\36\79\151\102\218\66\6\154\116\158\120\139\98\132\42\143\83\143\3\87\187\39\164\142\19\153\110\87\245\60\230\70\64\56\35\196\202\213\4\205\254\232\193\105\215\50\120\91\30\195\72\35\73\213\80\16\165\251\122\93\97\212\137\189\179\160\159\75\150\148\43\65\88\26\4\45\222\222\187\76\164\123\217\140\209\211\148\109\149\5\54\114\145\173\212\27\78\170\86\112\145\46\49\69\67\133\97\0\122\118\129\0\248\191\85\110\135\118\4\24\42\212\109\254\61\88\86\105\11\232\230\215\55\168\191\190\53\112\232\197\21\136\197\155\95\253\100\4\24\183\41\109\87\246\208\109\82\2\124\57\215\238\114\249\112\201\222\160\19\72\117\131\104\226\65\234\29\71\44\145\188\73\193\21\242\103\40\159\19\11\123\84\167\107\41\70\93\59\171\228\88\186\231\217\42\213\125\200\245\70\128\157\91\174\149\204\224\34\168\65\194\198\93",2539092148,4165297124} or {"\102\24\44\131\177\6\92\183\8\239\223\17\238\146\194\29\31\83\206\54\206\67\78\110\76\163\69\181\9\46\80\96\27\40\217\155\225\200\109\11\186\231\199\87\200\162\99\155\232\112\247\184\32\26\180\144\102\92\63\66\51\229\247\92\12\101\90\72\186\112\210\169\96\29\227\108\94\62\69\34\79\222\61\34\223\152\70\86\81\91\32\112\88\164\23\73\60\61\207\244\205\196\174\126\45\203\97\146\56\180\49\194\2\9\46\2\228\230\10\157\81\133\143\38\229\138\129\250\250\169\252\178\244\102\251\239\234\246\131\154\210\162\198\183\227\89\54\45\200\206\98\249\164\20\116\163\117\11\188\96\151\133\213\225\114\186\88\51\99\47\188\9\20\116\235\37\124\211\118\184\10\234\71\68\63\179\182\75\230\177\181\99\176\26\122\193\37\209\203\48\6\76\99\146\150\6\133\157\45\101\99\212\225\87\163\19\54\47\225\204\175\153\9\68\78\119\122\105\70\157\38\81\82\201\54\190\64\84\87\122\52\41\26\213\210\9\196\100\91\192\155\99\187\69\207\254\155\163\33\246\172\170\209\18\125\32\157\30\200\216\17\249\35\252\107\186\206\219\68\163\114\240\28\13\127\150\238\1\192\97\214\100\228\227\248\200\50\102\187\62\161\198\169\138\170",991905307,3834406387}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
