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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=4b329eb4df117d76"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=4b329eb4df117d76"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\100\97\49\101\50\54\49\49\56\56\98\98\53\49\100\49\99\53\51\55\49\101\52\57\100\100\48\56\49\55\48\101","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\86\89\78\77\97\89\122\120\119\98\101\121\97\101\54\95\58\104\57\68\118\119\67\97\51\81\88\101\55\83\50\66\107\83\112\69\85\86\65\58\97\115\52\74\112\115\52\50\109\78\88\111\108\50\79\86\51\105\76\100\49\107\72\114\105\67\88\107\120\87\115\115\109\78\82\81\107\74\105\49\77\74\83\105\87\110\65\68\55\99\73\114\82\117\111\116\82\65\120\53\112\99\109\75\49\97\106\108\110\77\49\54\74\115\77\55\97\95\119\80\55\73\119\54\51\57\98\76\80\89\119\69\48\84\102\119\118\52\90\120\119\122\73\78\122\87\71\109\102\98\89\116\98\52\120\70\76\74\118\50\66\72\110\115\68\116\74\81\74\50\85\99\82\49\101\107\48\90\95\83\101\114\53\68\117\109\79\57\111\99\48\87\68\111\104\97\110\84\79\101\97\69\51\78\68\121\89\76\73\74\116\116\54\97\107\84\105\82\114\115\110\104\108\56\113\109\108\85\122\98\57\101\53\97\67\118\107\48\78\73","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\207\102\21\137\20\34\37\200\74\119\226\24\189\36\187\112\177\43\61\22\112\158\42\13\235\206\42\198\35\207\101\56\143\4\101\24\83\166\249\122\76\153\111\173\157\60\132\52\254\166\220\145\127\122\201\168\149\105\234\240\130\66\166\103\205\101\10\145\185\80\31\91\174\23\56\25\56\73\129\138\129\80\122\114\134\181\35\135\83\27\94\239\92\59\88\86\173\120\213\8\212\139\170\222\124\135\68\44\232\153\226\170\54\100\32\159\123\39\76\80\198\237\17\155\241\0\76\68\52\225\48\180\193\143\10\102\3\166\205\118\176\247\56\181\176\195\126\16\194\179\200\20\79\9\247\201\137\244\1\162\249\153\254\234\161\48\123\190\68\34\17\171\57\84\33\23\177\195\76\198\103\202\66\229\146\71\119\100\165\190\140\51\23\149\155\216\160\91\180\171\92\136\108\172\79\150\6\72\4\77\68\189\82\207\157\132\16\37\63\66\21\88\161\104\126\240\21\188\63\115\204\81\2\140\31\80\241\249\180\76\53\212\191\189\234\205\61\22\54\197\201\142\242\95\33\7\45\226\27\161\152\161\144\114\80\149\18\182\74\184\136\70\214\86\141\226\52\83\177\82\252\69\59\245\7\11\204\50\245\142\84\234\57\28\212\181\255\185\246\128\158\159\82\201\166\217\7",2641185802,7627647} or {"\144\205\90\42\184\54\235\121\234\61\253\132\12\212\90\67\154\149\183\57\246\174\157\141\181\55\210\241\229\72\107\162\43\189\45\171\23\14\235\57\243\52\49\121\87\100\11\27\226\31\119\50\204\194\10\187\211\57\245\169\123\138\191\56\208\73\148\192\146\73\179\150\228\90\183\173\97\103\33\77\211\254\223\196\87\187\166\186\41\142\170\80\164\243\206\223\0\255\137\6\19\57\254\252\69\90\95\90\185\239\79\191\160\58\54\199\210\105\78\1\23\105\87\216\188\188\216\138\28\86\88\2\69\115\192\211\240\230\196\248\216\96\2\166\175\53\254\251\18\180\165\209\151\125\206\86\240\228\255\231\125\89\254\252\167\37\145\217\111\142\109\27\182\36\107\89\220\128\12\60\228\208\11\195\22\17\93\118\7\73\67\10\224\89\96\231\174\4\183\211\39\8\155\245\180\166\20\49\187\65\211\200\53\0\43\14\116\131\150\180\115\122\206\88\27\160\239\211\116\59\197\78\198\118\99\90\116\122\172\31\28\42\169\27\228\190\169\81\202\114\39\164\40\52\123\46\213\254\170\74\69\12\168\45\38\205\9\18\181\242\188\206\250\188\30\194\38\37\19\49\106\113\105\78\15\116\77\211\238\21\86\239\116\45\200\103\71\122\203\204\255\74\46\224\165",747638915,4008600974}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
