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
local pinned=url.."?retry=edb8e39a5c180f81"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=edb8e39a5c180f81"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\55\57\50\98\97\50\50\97\48\50\57\100\97\53\55\101\51\101\48\51\48\54\102\50\53\56\97\101\53\49\56","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\69\77\98\79\90\108\50\68\70\67\111\69\108\52\112\65\58\107\90\100\70\110\104\116\57\89\57\83\85\98\119\54\84\72\105\79\69\65\103\58\122\57\111\86\109\122\111\81\80\69\55\73\100\68\118\77\108\75\106\87\100\106\77\50\73\48\99\116\97\77\48\71\57\88\50\53\51\74\54\106\111\112\70\84\98\57\45\52\48\69\110\99\72\50\57\83\77\89\100\78\77\97\102\77\120\109\77\111\103\99\105\99\75\95\103\82\79\81\77\70\56\74\79\98\111\71\109\99\67\81\98\53\87\104\117\85\106\113\122\107\87\103\81\86\84\113\82\68\106\107\90\104\101\75\74\51\49\77\97\87\51\119\112\49\80\122\102\103\112\79\109\70\75\106\115\107\95\117\105\80\74\90\110\114\50\107\85\48\86\101\104\65\110\55\110\79\101\45\78\86\80\101\120\56\104\103\65\81\108\113\101\49\48\121\88\82\86\100\97\71\112\66\54\112\86\55\73\101\105\78\74\52\90\106\51\113\51\66\115\48","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\198\66\157\65\17\78\140\142\250\190\59\134\209\175\86\133\252\53\158\56\164\130\98\248\182\72\103\160\83\245\163\13\248\14\202\186\242\111\6\32\95\3\209\249\134\227\75\240\229\223\80\59\56\14\151\86\24\214\61\154\196\135\134\207\186\30\228\74\173\134\127\29\31\224\88\86\6\46\202\117\5\39\46\213\40\88\45\101\108\23\145\53\40\127\186\92\76\160\41\221\96\76\213\220\33\213\94\29\167\243\232\156\209\216\78\23\199\196\61\223\200\89\247\175\204\138\184\204\189\96\207\118\39\140\145\21\218\170\143\9\14\153\69\157\234\32\150\174\25\229\118\71\121\193\120\24\235\166\55\161\165\115\179\217\24\132\116\213\121\157\187\219\168\3\117\94\47\135\189\121\103\218\184\156\136\236\225\242\126\16\19\92\181\191\20\188\184\215\176\187\26\20\70\194\135\7\106\101\36\91\113\17\246\43\177\122\41\16\193\29\1\108\213\21\254\84\237\47\6\234\71\157\17\27\172\171\84\108\184\211\44\108\188\174\236\133\235\62\7\232\197\130\47\49\151\154\247\109\89\59\82\26\103\32\201\213\10\229\218\35\29\61\46\183\213\218\16\224\192\199\125\131\124\156\49\57\252\190\51\17\210\179\59\141\143\36\77\161\250\132\75\49\16\25\252\134\166",97207176,3841483128} or {"\83\5\201\13\105\70\32\193\78\133\12\5\46\245\185\98\225\194\26\204\179\116\85\197\192\147\170\247\187\175\85\15\148\109\92\220\196\130\89\54\10\206\179\166\48\168\148\171\235\134\85\142\46\225\61\164\244\213\64\14\250\133\17\11\204\215\79\115\83\182\228\88\127\9\222\85\42\200\110\28\88\215\147\112\154\148\196\51\209\196\127\187\181\28\242\191\34\16\72\53\195\146\65\210\177\196\186\126\246\37\238\45\4\27\120\39\211\119\137\160\77\137\63\118\116\53\90\172\161\69\54\197\243\51\125\232\247\4\196\83\204\209\62\190\191\177\85\23\124\133\75\210\59\200\15\106\252\197\177\251\84\145\150\176\94\67\169\58\126\199\213\60\13\104\208\215\164\40\244\251\176\75\121\217\153\181\78\39\83\239\200\95\172\251\190\38\79\15\48\194\90\217\164\192\128\144\253\157\184\139\147\231\130\49\6\185\159\84\184\18\122\121\137\249\48\108\186\181\29\224\22\234\56\151\2\54\147\236\124\131\78\151\185\21\205\113\88\5\125\247\77\101\190\254\222\110\149\49\160\93\161\252\117\43\75\100\16\218\146\174\136\87\130\176\112\205\11\60\31\218\11\46\187\231\32\76\174\1\114\37\106\178\88\53\102\79\132\76\67\82\25\45\174\10\146",4273734414,3548341127}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
