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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=3afe21d76e717f63"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=3afe21d76e717f63"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\101\49\52\98\102\99\55\99\54\102\54\102\102\53\98\99\49\51\50\101\99\54\57\53\57\98\49\100\101\101\97","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\49\79\111\100\100\52\102\53\117\72\121\52\122\116\79\73\58\120\86\122\69\95\121\101\112\52\66\97\51\73\113\108\87\120\75\121\107\102\81\58\57\77\81\52\97\100\105\68\81\57\79\116\69\121\57\108\48\45\82\81\51\56\76\83\45\49\51\82\97\79\101\121\116\51\97\49\82\75\114\112\49\95\49\51\119\51\117\78\74\117\69\111\72\50\113\95\107\101\76\73\119\76\54\80\80\107\116\84\52\87\104\83\108\122\65\90\122\98\68\79\53\55\55\121\75\85\52\74\95\70\122\115\110\76\118\117\85\83\114\98\67\70\87\121\83\89\108\121\86\72\87\56\99\48\104\97\101\75\83\54\104\115\82\72\76\98\51\108\50\113\120\97\56\101\83\121\73\50\76\101\69\112\120\67\99\66\117\97\115\78\71\67\119\113\75\81\104\97\103\100\72\86\110\100\50\66\113\87\73\117\73\72\119\119\71\52\83\109\119\66\76\118\95\69\118\67\117\98\73\119\100\56\104\83\67\71\111\73\120\66","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\1\49\65\222\4\229\63\205\179\200\132\14\14\50\25\1\218\217\109\170\7\148\163\96\120\208\66\4\86\117\205\163\4\103\62\178\188\65\31\221\34\99\58\50\186\122\44\53\246\88\213\87\75\135\82\216\135\46\50\213\193\8\22\195\89\53\182\70\223\53\231\58\163\223\131\88\166\68\69\61\56\166\167\189\121\133\48\58\248\227\209\163\36\52\210\134\56\100\159\48\209\119\164\151\199\43\201\195\237\243\24\206\234\83\105\175\168\59\32\174\40\159\110\217\110\222\125\99\97\21\235\140\38\252\146\206\197\47\87\107\209\7\225\118\211\169\243\246\57\183\242\85\135\123\27\97\161\97\92\138\106\112\245\141\161\225\73\113\174\240\177\240\126\233\231\228\213\123\159\87\174\62\135\249\237\188\203\149\202\126\182\90\231\1\253\207\95\134\205\123\56\255\144\150\193\186\131\92\200\156\195\213\205\70\99\37\99\245\4\169\211\95\158\56\121\159\34\110\177\66\201\179\213\154\180\116\238\77\2\192\253\249\118\77\207\47\108\189\139\140\34\127\167\186\200\27\240\80\255\118\200\24\163\199\77\196\216\153\127\123\84\153\166\49\160\108\26\73\107\148\157\133\19\189\32\123\28\103\255\138\42\15\105\66\127\152\161\68\183\206\97\181\219\28\231\72\69",2895999517,2494194638} or {"\139\208\150\249\252\177\247\60\126\171\124\96\78\1\109\242\60\149\229\43\60\63\178\164\130\198\157\213\216\208\208\75\119\18\36\205\22\83\210\47\49\125\70\79\129\111\82\191\9\192\211\245\21\32\124\122\80\106\79\210\200\146\52\199\212\212\4\108\32\189\126\74\99\178\178\179\239\2\208\12\228\96\234\48\168\227\19\194\197\157\187\209\80\65\128\6\50\70\189\191\87\93\42\34\215\162\95\210\68\165\227\199\206\115\4\235\21\56\255\67\149\83\96\96\71\182\135\243\84\122\118\42\40\189\94\80\66\172\52\27\171\135\245\22\176\117\98\73\223\36\17\68\145\83\42\208\20\70\40\111\245\114\51\29\34\113\33\16\36\154\246\59\211\180\235\75\223\245\201\70\19\244\2\81\199\95\250\147\138\136\135\140\50\65\139\118\168\143\220\202\98\25\89\104\126\50\137\31\112\185\186\32\105\4\174\223\97\101\34\172\187\187\151\255\18\138\48\114\36\7\229\16\228\10\209\220\114\8\63\219\70\114\41\118\133\247\80\97\159\92\177\105\81\112\83\135\66\242\75\215\228\46\58\229\87\231\226\50\107\87\48\30\122\87\156\218\253\28\162\58\132\215\180\26\173\28\16\1\23\246\192\120\139\66\111\127\64\225\135\60\196\167\78\79\234",4064387763,2161599965}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
