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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=08c8779d4f06bd9d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=08c8779d4f06bd9d"
local expected=617906
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
if s2*65536.0+s1~=2497301977 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\102\102\102\54\55\49\49\52\101\50\49\100\49\53\99\55\98\52\53\101\102\98\99\100\97\52\52\97\97\55\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\65\100\71\71\120\108\119\71\110\74\68\54\75\57\117\53\58\79\67\49\66\117\90\75\86\77\77\76\57\85\55\68\116\78\86\81\83\80\103\58\56\83\89\51\52\76\90\116\107\78\118\70\111\45\68\88\68\88\54\78\110\65\49\97\70\49\55\100\97\74\95\99\88\54\107\108\70\57\101\73\72\97\108\80\57\111\119\110\110\86\108\67\98\75\76\72\86\104\119\110\106\79\99\98\118\72\73\67\121\52\106\110\78\75\103\55\79\87\85\65\113\77\72\87\106\104\73\107\105\111\55\87\88\120\114\89\65\103\53\71\88\85\82\50\102\119\84\98\114\112\52\90\108\112\54\75\72\68\69\77\57\74\117\104\50\102\113\114\74\114\75\67\56\116\52\88\95\45\98\120\57\118\54\110\49\65\112\118\85\107\99\57\104\77\83\120\98\120\107\66\77\85\102\65\70\57\104\72\86\45\78\101\99\51\76\117\81\49\81\54\49\95\103\117\88\74\66\88\72\49\109\82\83\53\102\50\116\51\69\75","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\111\180\230\221\152\215\79\207\133\138\57\145\149\169\184\98\69\248\214\51\100\177\243\125\123\151\148\71\166\90\109\170\223\198\29\250\93\100\16\218\212\89\251\211\136\100\106\93\216\204\211\156\83\190\142\151\233\254\6\2\146\119\102\43\229\118\22\56\19\85\162\250\83\4\8\194\82\51\195\138\141\64\128\171\35\198\117\115\59\108\36\131\242\38\231\78\156\66\119\52\173\130\119\174\130\218\245\85\202\194\247\210\103\237\74\11\53\85\205\90\123\125\156\126\135\79\221\249\128\54\247\27\42\68\193\202\52\146\16\103\247\170\218\41\0\115\230\71\162\110\175\92\34\96\99\22\23\74\128\195\76\91\228\168\163\140\238\170\14\151\0\132\5\159\215\53\242\80\106\157\255\124\253\24\113\81\177\198\57\143\99\172\129\196\105\4\99\130\75\72\250\127\250\97\35\173\78\221\244\42\27\125\173\141\191\234\177\48\209\5\253\152\209\25\121\179\105\203\22\35\9\181\21\210\47\146\138\213\103\208\237\142\12\128\100\141\161\168\125\116\136\63\74\214\17\122\207\202\164\202\183\136\159\126\218\204\251\131\29\35\13\67\196\215\108\140\62\215\215\246\208\52\26\171\69\27\3\193\57\85\177\192\151\1\227\189\148\3\86\187\142\144\62\161\49\239\106",2030758100,1710711012} or {"\238\229\18\241\71\2\182\48\174\167\114\191\139\172\47\64\197\34\22\119\15\15\44\39\147\153\37\57\100\223\194\57\180\15\162\71\151\245\115\42\177\3\151\227\60\103\237\48\102\123\9\143\105\61\215\94\14\53\55\228\202\207\233\41\134\181\146\220\104\228\191\194\84\52\47\252\244\19\173\119\42\169\154\197\2\166\252\58\48\143\146\106\64\49\23\131\240\64\39\86\191\194\174\174\226\16\216\1\70\87\210\138\239\175\15\232\157\76\137\161\143\10\195\171\27\229\98\106\174\248\160\129\70\48\147\35\54\40\26\144\255\79\74\157\170\235\123\69\109\156\56\63\188\253\123\195\195\63\39\39\173\95\185\206\161\212\238\68\52\77\154\173\91\27\0\159\94\190\142\36\71\102\230\249\7\81\14\67\237\23\37\170\250\62\203\154\252\61\239\11\121\98\194\202\238\181\86\156\173\91\180\126\173\83\118\118\213\79\122\81\232\245\26\137\159\226\19\137\171\172\251\63\120\132\37\49\67\255\132\216\83\81\125\206\44\94\229\241\147\217\0\70\225\186\106\161\101\17\170\165\241\142\159\232\5\11\61\8\8\30\212\77\246\211\100\69\7\65\20\125\197\162\108\222\7\82\25\160\199\116\226\145\212\70\90\173\24\62\247\32\190\9\253\190\117",3983848862,1385194227}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
