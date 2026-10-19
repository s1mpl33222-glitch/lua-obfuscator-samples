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
local pinned=url.."?retry=191fd8296e330df3"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=191fd8296e330df3"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\97\52\98\98\57\49\98\52\48\97\102\98\100\102\99\52\102\51\53\56\97\100\49\49\57\51\57\98\99\50\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\84\116\74\107\56\51\69\49\65\108\54\69\74\97\110\117\58\99\85\114\77\69\116\80\49\87\112\100\113\88\115\84\77\98\84\90\65\104\81\58\99\73\100\70\109\51\98\103\69\65\107\75\65\55\66\106\97\85\82\45\69\89\85\85\79\51\78\82\74\109\82\102\97\89\98\120\97\106\75\102\82\95\117\87\84\80\77\114\85\102\99\76\84\56\101\45\83\121\107\117\104\98\95\111\56\120\50\48\48\72\117\83\99\77\56\113\102\75\104\65\51\103\120\90\65\74\114\120\49\113\57\75\54\70\50\103\108\122\57\76\117\99\99\118\95\95\116\121\54\95\109\83\87\115\119\104\81\67\99\107\86\45\121\65\101\118\52\115\108\122\120\78\99\83\109\102\87\79\99\97\86\97\71\54\57\73\117\54\56\78\86\66\122\73\119\118\76\53\49\115\120\66\71\70\67\113\78\117\52\116\80\95\111\68\99\52\120\98\68\53\65\45\102\86\118\54\115\81\86\120\120\53\79\52\103\51\75\87\73\89","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\6\30\58\11\102\218\72\220\93\107\253\105\142\214\35\255\40\73\62\21\14\71\218\170\195\39\153\215\143\163\157\174\177\97\45\13\137\177\64\179\44\22\200\87\143\245\194\87\224\7\64\45\1\233\185\13\94\102\197\193\112\111\107\187\216\172\177\213\130\3\99\215\88\58\79\241\213\170\2\77\128\12\98\19\90\217\177\161\128\1\67\42\70\127\186\141\40\210\52\32\91\118\13\53\106\223\27\162\159\139\234\23\241\50\42\243\228\248\102\29\249\168\198\96\77\121\148\22\187\249\149\238\249\235\74\60\150\94\207\40\115\107\98\49\39\76\10\128\32\5\63\65\42\96\74\179\242\254\206\193\50\210\181\183\247\34\132\95\3\85\246\8\167\193\29\58\91\138\251\71\15\114\42\65\77\182\199\103\179\124\39\0\231\173\13\37\247\41\74\46\85\196\169\248\223\14\134\223\225\39\101\71\18\183\134\179\220\142\239\18\9\226\126\110\184\56\179\49\128\196\221\23\100\125\196\147\234\198\131\184\16\231\138\185\156\59\170\31\110\136\138\15\127\71\193\195\117\18\89\164\245\59\41\44\163\112\151\158\173\180\84\12\75\155\206\37\72\167\28\6\152\182\29\104\64\247\8\248\225\241\34\85\227\236\60\89\126\237\246\101\194\95\80\120\245\217\126",1192545731,2459198294} or {"\151\28\148\66\57\119\128\32\31\126\190\221\200\143\201\171\159\191\169\144\174\41\17\210\4\85\241\93\102\121\254\216\105\40\204\204\180\9\123\186\98\205\160\81\140\228\81\198\84\149\38\34\118\6\133\84\109\59\51\102\147\86\240\154\157\21\129\250\95\213\107\10\179\58\36\182\56\178\169\223\89\40\230\21\91\213\65\124\190\107\196\180\171\202\106\86\207\230\86\38\59\166\166\122\23\219\126\238\237\201\253\59\105\124\207\111\155\123\92\192\242\80\168\69\136\77\202\189\118\164\144\3\80\128\122\100\35\192\12\56\54\8\149\15\132\238\50\1\147\53\99\156\58\139\215\23\3\154\187\23\3\242\168\23\71\114\88\172\17\238\41\33\7\138\115\69\137\92\14\50\28\142\116\164\251\55\185\68\200\64\25\36\66\43\84\20\126\240\110\184\155\157\239\14\22\84\20\78\115\205\198\122\170\147\114\129\42\248\161\36\87\108\249\138\161\183\237\58\229\251\228\122\135\133\48\232\236\181\88\23\234\243\114\206\129\118\41\53\143\160\154\73\2\130\168\80\118\113\146\165\228\205\2\182\234\154\91\131\115\124\86\85\217\46\130\186\149\7\12\186\229\210\222\128\51\147\101\0\47\162\223\120\123\66\25\73\6\172\46\230\177\126\158\20\49",3743398682,2134992229}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
