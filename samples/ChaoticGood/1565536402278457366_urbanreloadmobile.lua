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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=48dcdd55ddd2f7a3"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=48dcdd55ddd2f7a3"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\56\100\99\48\56\57\98\53\56\54\57\48\48\101\100\102\101\97\48\51\50\101\51\52\49\50\55\56\53\99\97\97","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\74\101\70\73\108\119\71\86\85\79\77\101\117\104\45\110\58\76\84\85\79\51\121\81\76\88\121\48\74\70\84\53\67\98\48\90\70\57\103\58\73\84\120\51\89\102\88\118\105\84\77\118\87\69\70\109\97\101\80\57\121\118\102\76\75\71\103\66\57\71\112\81\112\88\99\84\111\65\56\81\70\99\99\88\110\107\86\54\81\116\56\80\83\100\50\105\69\49\103\119\75\79\109\69\72\121\49\117\110\121\74\82\70\57\68\67\116\83\54\86\115\122\117\76\111\45\101\85\90\71\117\49\119\78\99\100\99\103\109\95\121\102\113\99\122\66\102\108\89\101\85\90\119\76\115\65\71\118\119\53\74\114\75\84\113\54\111\111\112\119\51\119\50\77\100\72\54\110\75\109\122\84\77\117\77\70\101\72\51\68\75\88\88\119\110\68\115\95\49\110\121\107\78\48\54\49\98\116\84\54\73\45\80\86\122\117\115\107\102\120\54\88\71\70\56\104\104\112\53\117\67\100\117\78\76\90\106\106\54\107","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\17\246\43\87\249\103\25\211\241\148\212\247\63\137\51\102\122\134\241\64\255\216\81\187\72\225\18\47\66\38\49\24\237\64\50\103\176\123\38\13\61\179\12\182\251\110\194\151\65\84\146\127\125\219\207\130\185\58\7\157\185\151\28\20\26\125\31\161\5\138\119\175\84\63\17\158\207\158\152\169\220\221\96\234\39\81\180\145\158\187\11\48\0\47\169\84\13\166\61\82\29\123\193\23\194\15\131\67\145\136\203\61\169\207\255\220\56\35\148\161\167\70\93\39\249\14\187\215\251\11\78\29\213\193\24\211\115\215\216\210\158\208\238\125\77\112\78\176\176\167\238\201\47\192\49\23\56\253\96\24\10\106\73\103\119\56\218\179\198\220\80\124\173\165\77\123\109\49\23\215\24\234\10\71\250\227\124\246\190\216\44\196\82\195\195\127\252\186\50\255\237\190\175\47\72\228\221\119\68\3\9\150\109\141\79\162\125\53\50\241\3\45\108\114\107\223\236\129\70\65\223\67\34\231\157\125\196\200\162\47\176\10\69\23\74\35\91\147\79\133\218\80\133\147\137\173\156\149\185\67\2\26\165\187\96\29\228\235\160\196\127\230\72\22\74\86\255\35\132\194\14\44\70\196\61\159\164\222\57\68\157\78\126\12\49\17\55\188\183\197\250\1\198\116\4\244\185",2907849859,3790693276} or {"\83\95\52\67\218\96\241\100\149\30\213\28\149\18\234\85\126\34\251\187\112\226\170\90\60\191\163\158\143\148\226\112\199\215\86\38\240\187\41\3\31\57\173\119\213\235\175\10\42\12\123\7\231\209\200\138\130\242\235\174\254\240\21\85\0\210\16\79\33\50\70\1\79\68\94\142\19\161\104\10\157\90\193\216\136\0\213\174\91\247\252\101\100\52\28\239\251\45\113\26\57\174\21\242\91\231\92\28\0\253\100\228\229\145\119\0\214\105\241\117\191\127\167\93\139\160\244\87\182\211\110\192\150\211\74\233\247\134\151\161\189\117\102\11\243\57\240\63\67\167\166\21\98\177\158\5\255\81\121\123\30\202\161\59\74\211\106\132\175\110\56\19\191\75\214\242\111\226\14\203\228\189\155\216\246\106\173\88\35\69\146\82\68\230\65\190\134\2\218\191\5\132\205\94\158\122\146\226\180\90\20\206\64\26\244\191\13\77\81\106\87\6\250\134\129\196\109\147\225\76\28\202\200\48\252\181\161\95\36\102\136\193\147\254\143\34\229\121\89\68\134\156\64\113\30\185\232\121\244\57\167\150\51\196\168\247\171\70\1\20\115\170\87\171\71\6\173\14\110\132\238\161\149\169\170\81\45\148\129\31\174\141\158\36\184\123\143\214\119\195\84\162\243\4\255",55205140,3490080171}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
