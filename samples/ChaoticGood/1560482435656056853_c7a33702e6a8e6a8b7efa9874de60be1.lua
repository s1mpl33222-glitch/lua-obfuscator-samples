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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=cb56ceff7298aecb"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=cb56ceff7298aecb"
local expected=572639
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
if s2*65536.0+s1~=2292470616 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\99\55\97\51\51\55\48\50\101\54\97\56\101\54\97\56\98\55\101\102\97\57\56\55\52\100\101\54\48\98\101\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\95\53\74\86\78\75\89\72\111\100\108\57\119\111\121\102\58\88\114\85\89\113\118\114\115\45\121\79\71\68\109\122\70\98\88\99\81\113\103\58\99\67\108\118\120\120\107\74\84\72\81\84\114\79\100\81\57\87\85\102\88\72\71\108\73\83\48\109\116\101\87\122\72\85\51\97\87\51\109\76\101\71\54\116\55\109\75\65\114\82\85\55\72\119\88\121\108\114\71\72\67\84\79\122\54\105\116\105\51\122\103\118\65\67\99\52\45\57\104\53\73\97\70\54\57\107\69\109\75\100\87\66\83\49\90\67\45\84\54\49\53\102\48\97\116\95\89\114\54\50\57\73\85\98\98\49\75\67\106\69\51\70\74\86\98\106\85\122\70\45\51\83\85\113\76\95\90\116\99\102\112\84\82\69\100\89\88\97\82\86\114\84\49\109\75\83\78\55\110\55\107\104\54\121\107\89\99\108\101\105\98\83\69\110\52\89\101\50\73\103\68\57\106\70\102\112\106\84\97\99\48\108\110\113\65\87\52\104\70\65","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\248\215\238\189\123\82\148\145\105\114\153\20\73\138\181\13\60\122\231\228\242\236\102\48\235\122\230\215\108\201\157\129\167\254\64\218\47\166\103\20\57\59\153\125\220\156\248\217\255\201\142\178\250\134\192\197\5\184\224\71\197\113\81\236\122\191\142\9\87\113\222\245\166\234\34\95\78\175\210\35\70\67\54\127\165\228\97\126\134\147\200\74\96\4\79\148\136\6\61\108\43\187\72\126\8\179\244\228\37\153\110\179\255\63\247\66\85\250\159\174\217\129\103\255\2\117\32\153\225\87\177\15\69\21\2\159\39\124\98\14\203\107\46\243\165\124\233\251\31\184\196\129\154\204\154\58\149\77\82\29\141\212\105\12\231\0\158\124\133\13\189\112\17\219\68\0\197\192\65\233\149\136\233\130\218\63\104\235\217\231\154\41\30\194\21\45\43\158\6\185\169\26\32\192\224\192\128\160\240\220\171\124\212\128\61\34\216\9\84\236\77\44\87\126\106\184\51\100\6\192\11\47\1\23\214\250\200\202\243\65\242\3\176\88\62\231\141\8\84\171\27\138\27\210\35\180\184\30\102\60\123\161\0\29\161\149\97\247\250\158\120\152\195\146\30\232\79\106\20\213\75\45\221\14\83\120\61\197\173\252\97\93\132\217\11\253\116\26\241\167\158\215\47\107\186\178\192",3590194743,2272027256} or {"\115\9\200\206\67\167\5\194\16\254\33\159\67\46\195\247\137\127\41\227\115\40\26\242\225\162\22\246\122\26\109\236\52\116\216\21\104\180\130\251\65\175\56\145\90\104\126\158\184\163\185\14\161\7\195\207\159\171\251\36\4\103\154\127\126\91\204\199\167\125\193\15\145\158\125\95\158\153\16\106\144\179\185\219\167\91\112\210\46\139\19\167\101\123\98\158\24\81\242\226\46\74\95\68\190\72\188\67\78\250\235\46\251\132\191\114\55\34\157\236\112\252\93\216\34\167\74\236\234\67\67\246\103\39\238\226\30\70\67\244\163\216\1\244\198\30\49\141\51\102\7\27\196\115\83\172\52\211\34\2\113\103\167\233\249\166\190\187\12\55\164\16\227\78\229\45\188\252\174\56\30\107\116\240\175\132\247\33\115\71\7\133\60\110\54\1\49\40\73\241\197\47\175\88\71\246\192\183\174\34\182\160\152\242\72\234\107\161\141\241\179\82\76\81\39\74\27\114\182\82\180\100\182\51\10\55\66\118\48\165\230\2\48\59\121\129\236\159\154\91\203\35\199\181\174\53\159\68\218\79\207\123\59\35\0\241\203\237\210\195\193\42\130\248\219\190\83\224\6\146\171\51\203\222\49\203\71\2\156\249\239\233\98\88\68\106\113\146\28\189\89\37\190\198\11",4272336636,1957520519}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
