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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=99f0c7c239553550"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=99f0c7c239553550"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\99\53\98\98\56\49\101\52\48\102\52\57\48\52\50\50\54\53\97\99\57\57\48\53\51\55\53\54\48\52\99","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\65\77\79\118\79\86\115\113\66\118\67\78\105\48\120\67\58\110\79\110\109\113\112\78\103\81\113\104\98\81\102\81\107\118\55\73\57\99\103\58\113\51\77\80\87\74\97\49\57\99\115\98\78\103\86\98\52\87\74\109\81\112\104\116\120\114\108\45\81\100\74\75\89\119\111\69\121\48\98\52\116\98\71\88\110\68\76\100\74\67\90\79\71\83\104\56\115\119\86\54\100\120\107\56\103\73\50\69\100\75\102\114\113\100\45\109\105\48\45\50\65\54\103\75\66\86\65\78\81\82\113\85\55\77\116\84\120\55\80\82\115\65\86\69\113\87\115\45\70\101\117\99\82\89\105\117\87\107\56\45\69\86\111\55\68\114\86\119\120\75\75\112\109\81\99\112\57\117\97\49\73\53\81\86\121\54\119\104\115\107\76\54\72\88\95\83\116\114\104\69\114\56\57\83\68\98\66\100\122\74\121\49\70\90\122\105\83\90\78\69\51\116\121\69\76\75\86\100\100\89\119\114\87\100\54\103\77\119\45\82","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\237\146\70\61\140\141\111\15\15\16\185\1\221\39\246\154\23\52\33\99\85\100\66\149\238\225\99\52\175\153\224\42\211\242\140\215\137\206\178\204\236\117\44\255\144\130\101\253\184\244\16\190\177\74\96\27\5\228\187\9\77\56\207\220\86\89\200\66\94\61\83\216\56\160\152\194\122\214\133\170\193\96\229\61\242\0\134\227\92\115\66\123\179\144\2\18\229\219\22\145\191\209\192\177\168\11\14\215\52\157\78\0\101\36\123\192\239\235\138\200\181\122\191\181\117\16\31\151\138\94\183\78\228\10\196\214\146\57\26\241\220\182\214\227\92\172\73\30\17\54\95\16\68\12\35\94\79\10\113\157\225\108\22\85\54\108\129\63\229\176\131\127\191\226\227\30\243\61\28\119\152\0\121\107\184\124\69\50\98\25\184\62\182\202\199\32\242\183\96\180\68\236\94\164\28\216\207\18\38\79\26\169\187\34\179\69\206\179\151\160\158\121\158\228\249\152\247\74\82\216\157\75\117\98\210\126\18\0\129\238\240\96\93\139\137\17\247\28\245\182\106\127\164\96\36\11\5\177\226\219\233\217\231\168\76\148\99\143\182\225\34\73\91\250\208\245\246\237\239\207\50\47\189\208\100\68\133\92\133\135\35\182\193\209\152\71\207\112\199\69\55\196\235\111\5\59\42",859003158,2105041576} or {"\126\159\141\79\189\159\192\199\166\181\52\221\16\239\140\113\98\240\82\72\30\179\125\224\161\49\16\131\211\12\126\58\219\223\126\227\165\188\137\118\76\193\176\96\3\204\110\19\90\201\14\217\103\254\223\102\89\9\67\3\206\212\82\48\14\150\105\146\46\237\110\58\46\166\111\185\246\252\40\37\8\240\191\68\115\190\148\216\218\252\224\23\161\62\79\82\34\11\254\186\214\156\0\215\35\121\188\134\88\50\80\176\113\241\55\50\240\186\160\74\122\137\100\178\235\55\96\144\28\2\92\216\199\187\202\4\205\235\172\16\186\48\52\75\6\55\144\15\59\35\35\117\86\255\124\242\188\21\179\25\182\116\233\92\96\56\7\151\36\211\247\89\216\223\216\201\154\42\6\47\128\165\94\11\35\155\84\102\155\126\70\102\45\124\99\19\41\157\175\1\157\169\114\141\71\61\207\105\134\77\72\239\232\79\223\209\202\111\21\132\166\114\106\5\191\81\194\145\64\34\231\251\120\210\226\70\77\21\153\67\103\172\127\181\12\17\220\141\153\102\19\64\255\109\137\201\93\61\200\54\150\254\129\78\166\152\91\35\73\72\160\43\33\189\85\185\152\216\184\192\97\49\211\184\148\129\87\175\179\90\15\112\189\228\65\160\178\70\136\201\36\21\145\24\79",1788182701,1829332151}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
