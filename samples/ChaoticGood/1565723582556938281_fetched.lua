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
local fresh=url.."?retry=c2e7f9532ef3868b"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=c2e7f9532ef3868b"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\49\57\57\52\97\49\98\53\53\48\51\100\50\53\50\54\99\49\100\57\98\55\99\100\55\56\56\99\57\56\50\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\95\89\88\66\95\102\112\97\115\75\109\90\76\71\51\110\58\69\83\68\101\66\74\82\105\50\121\75\90\95\120\114\97\109\97\90\110\79\65\58\89\109\79\88\52\67\121\65\89\53\77\51\90\111\102\84\120\57\120\116\102\115\109\88\55\112\116\49\114\68\95\109\72\74\53\115\45\52\88\76\76\54\114\49\113\72\69\116\114\99\112\107\86\52\50\85\80\71\87\75\112\67\77\56\98\104\78\81\100\51\72\45\71\112\89\111\82\73\52\81\76\48\72\100\68\117\117\49\75\88\82\102\98\72\56\80\52\83\122\77\108\56\76\55\83\118\120\72\81\57\76\49\77\78\50\50\104\78\86\53\53\84\106\70\74\82\57\113\65\116\110\76\104\109\80\103\67\56\101\76\54\87\84\52\95\104\109\65\104\114\107\70\118\108\87\113\87\100\109\73\74\110\121\119\56\120\74\65\116\79\52\105\71\53\55\85\57\68\52\52\53\78\106\101\120\95\71\118\103\78\88\52\97\66\107\82\90\67\71\116","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\180\113\178\228\10\119\160\100\136\225\34\176\55\252\3\249\4\29\234\156\237\242\12\229\18\9\88\110\77\56\105\100\66\197\207\77\145\116\215\115\77\92\158\66\221\113\120\185\223\2\63\225\255\104\68\72\91\231\5\99\104\126\172\199\48\126\67\62\107\181\189\73\129\56\46\54\172\141\65\27\254\192\21\132\80\155\248\71\72\255\233\182\16\114\47\204\9\39\30\110\220\227\49\172\38\36\201\121\173\199\161\21\14\232\115\176\212\214\21\211\9\224\10\2\170\193\13\140\195\232\157\141\181\54\140\159\98\177\25\201\24\248\104\190\55\1\58\1\149\121\57\97\6\86\126\198\157\185\87\204\149\37\144\135\78\46\108\77\165\173\122\48\32\89\240\234\248\117\170\185\103\90\88\42\153\77\9\255\172\53\50\111\108\2\19\5\152\143\169\105\14\37\161\232\26\186\75\216\198\221\42\130\106\126\168\96\181\211\130\96\29\155\49\161\112\167\248\228\173\209\210\71\169\87\161\50\20\41\135\214\137\126\30\66\149\185\79\233\90\118\220\114\22\84\157\114\228\23\101\94\85\227\127\178\6\72\255\103\123\96\114\106\129\87\188\114\32\18\186\68\193\57\50\96\156\93\117\149\11\143\114\237\62\255\177\139\101\235\142\66\154\112\8\177\56\71\227",2505368291,3283443782} or {"\126\159\220\163\207\190\50\32\110\202\165\124\18\57\137\73\4\169\132\9\13\211\105\215\161\31\4\202\126\173\178\224\133\7\60\251\60\32\126\216\138\173\116\174\128\122\23\97\206\202\85\28\169\168\235\224\25\197\23\13\151\31\177\183\205\232\78\64\7\183\144\88\52\63\179\57\58\61\46\106\236\10\31\169\185\57\150\221\113\227\148\165\79\125\175\183\62\8\209\254\128\240\101\197\166\11\132\170\121\21\170\84\172\150\192\154\146\230\114\205\30\124\163\133\153\35\240\201\88\209\235\67\69\244\253\114\170\111\165\175\248\140\145\123\39\241\195\144\17\107\86\138\183\89\24\16\31\41\38\50\221\15\94\172\69\73\84\41\13\157\159\136\148\241\71\228\235\4\78\211\41\129\139\28\50\58\188\63\201\183\192\239\235\14\194\242\146\86\101\93\107\2\251\232\221\65\67\71\213\35\235\69\58\249\94\243\91\153\234\69\196\107\238\213\142\73\202\233\89\26\236\199\107\178\28\227\221\228\119\255\59\252\243\141\125\20\248\32\201\144\56\22\70\215\65\197\138\240\166\247\98\240\154\208\113\244\222\12\76\146\17\133\184\173\31\151\191\235\121\17\180\42\188\26\183\76\94\157\31\0\75\26\184\201\60\241\233\187\105\157\223\67\156\41\100",2183017640,2993971797}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
