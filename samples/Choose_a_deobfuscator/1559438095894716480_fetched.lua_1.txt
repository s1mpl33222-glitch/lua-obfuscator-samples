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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=988d2877dbf7b32c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=988d2877dbf7b32c"
local expected=898586
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
if s2*65536.0+s1~=1933677448 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\51\99\53\49\99\51\49\48\98\56\53\54\102\57\102\57\52\97\97\97\56\100\53\98\48\57\57\98\51\102\56\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\112\45\113\72\79\108\120\99\51\80\81\85\48\78\111\111\58\110\114\95\104\115\85\99\89\49\67\53\118\72\109\81\97\90\101\73\50\56\103\58\80\75\111\103\73\114\69\103\88\108\87\87\116\68\71\109\85\121\71\65\119\53\88\82\114\107\98\72\90\101\114\79\77\65\73\67\97\105\48\79\104\69\95\69\103\117\49\89\55\120\121\86\48\78\79\99\116\87\103\80\83\52\119\57\76\65\66\77\99\118\108\101\88\97\73\83\119\48\70\122\120\85\56\80\116\86\79\98\77\99\51\74\78\115\74\107\80\45\95\73\66\104\74\90\104\90\68\48\74\109\114\107\116\118\48\109\108\120\98\114\69\90\99\83\74\116\49\68\102\88\78\100\86\48\71\50\116\57\82\51\53\119\57\87\85\99\57\106\78\56\90\102\82\72\87\81\71\68\109\82\52\54\89\89\69\49\50\100\112\66\53\106\101\97\86\117\120\65\99\97\66\122\53\67\54\90\81\68\84\52\71\56\49\68\89\68\113\121\107\99","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\145\152\30\163\105\58\143\131\197\136\6\13\31\6\123\156\236\57\0\223\39\28\71\83\124\27\67\1\88\116\85\234\194\164\156\52\233\224\125\110\207\114\190\37\199\253\50\157\44\225\24\16\196\236\221\248\120\36\140\29\90\196\128\110\142\15\214\45\80\175\59\3\53\221\157\48\9\198\200\91\127\8\55\116\108\43\99\91\2\67\181\97\161\63\82\237\186\201\171\218\105\215\233\164\128\214\244\20\43\114\171\53\241\206\44\193\8\40\244\56\134\37\114\203\142\247\88\137\36\49\49\238\105\245\130\88\209\165\5\42\187\251\153\140\207\167\225\135\77\216\54\99\189\199\176\134\226\170\154\253\44\152\245\204\34\10\96\77\93\242\253\129\173\101\132\48\181\191\137\197\210\120\148\150\138\151\57\184\144\36\14\129\59\230\121\189\248\122\78\111\173\47\40\112\236\83\209\108\134\158\15\122\138\93\236\142\206\132\85\53\2\224\23\55\152\59\110\226\157\35\159\18\211\233\106\239\226\61\21\173\176\34\136\21\23\213\199\47\213\104\155\191\240\100\131\224\81\136\151\173\147\113\186\217\160\77\13\139\54\203\201\65\114\94\90\156\100\123\228\162\223\192\82\161\204\16\166\247\154\85\11\36\177\212\210\128\243\227\181\25\75\71\164\0\4\16\132",3601678144,3634389348} or {"\121\140\230\199\45\23\97\28\129\27\95\18\20\153\181\157\100\140\28\219\112\188\186\201\26\232\152\189\147\46\58\164\194\237\150\151\35\102\6\130\146\153\242\64\37\142\91\28\100\129\180\169\70\192\133\224\183\227\90\250\143\243\228\69\49\145\143\121\186\178\143\120\47\98\29\139\66\57\141\140\249\16\169\102\101\213\150\154\249\29\163\42\212\194\186\52\182\9\107\241\101\158\66\100\95\44\205\106\97\44\98\193\182\206\186\35\34\12\0\145\136\239\115\182\8\43\234\45\30\33\150\182\144\37\226\20\106\97\115\236\249\196\140\68\23\18\10\21\216\231\82\43\117\43\200\203\28\220\99\154\119\96\98\28\151\6\72\51\6\228\189\230\46\158\41\252\54\233\97\225\38\135\145\33\57\102\232\15\242\117\188\109\241\174\196\50\79\27\201\132\75\143\43\100\233\60\114\81\107\254\123\16\129\238\16\10\105\248\66\214\216\202\78\50\115\89\5\184\116\100\68\128\160\14\38\158\78\118\57\212\5\66\178\16\183\206\117\240\50\46\65\85\187\233\201\165\37\145\212\162\207\129\43\179\1\33\55\89\100\138\21\30\214\79\92\56\51\158\140\168\117\58\105\14\161\217\139\115\252\232\164\28\173\155\17\53\63\7\57\6\148\219\53\237\130",1167329348,3332334451}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
