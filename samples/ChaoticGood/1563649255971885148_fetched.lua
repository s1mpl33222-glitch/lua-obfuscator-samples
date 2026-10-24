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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=61c9545bb8a7b3c0"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=61c9545bb8a7b3c0"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\53\49\102\52\101\48\51\102\54\51\101\49\100\52\50\97\57\57\56\102\51\98\102\50\101\55\102\100\57\99\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\78\49\48\57\117\110\74\68\65\72\88\108\53\88\52\73\58\103\111\112\54\54\49\112\53\45\105\113\84\53\116\95\83\110\53\74\117\80\65\58\114\86\85\102\82\115\50\112\82\102\120\50\56\52\79\121\71\98\122\98\50\65\79\83\82\84\101\104\110\87\45\105\119\110\114\89\85\74\113\85\82\53\83\87\81\74\107\103\97\52\87\53\80\98\68\54\112\78\111\54\80\78\79\74\113\66\52\112\114\105\119\122\50\75\109\75\68\120\100\107\53\78\99\89\67\84\118\81\99\70\48\73\115\45\48\88\115\110\67\103\109\103\117\101\57\115\105\86\98\95\66\118\52\101\98\105\113\88\97\55\50\107\89\120\101\114\95\90\86\78\52\102\73\88\100\117\113\87\76\78\86\95\55\105\79\69\98\69\54\111\76\106\113\76\79\101\52\108\56\88\107\120\83\50\56\100\97\73\48\66\99\51\107\56\84\103\89\84\109\112\45\69\74\90\95\65\99\115\55\115\109\67\83\111\51\95\51\114\116\108","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\70\217\58\28\126\133\27\132\13\150\67\161\60\147\181\48\173\122\97\54\42\117\226\74\111\145\7\71\93\44\126\7\83\1\178\93\184\229\214\184\176\219\31\0\70\234\45\30\59\105\2\252\60\132\18\90\43\155\146\227\234\237\84\55\48\187\126\110\180\90\221\244\116\131\230\28\172\154\171\60\174\142\199\222\190\216\198\131\168\87\218\152\100\193\27\211\46\147\153\153\173\169\103\119\180\168\211\151\53\246\91\131\12\117\139\44\15\202\22\237\45\127\198\157\10\156\101\135\107\151\248\157\50\81\181\2\227\206\78\37\135\210\117\62\125\40\179\80\179\84\178\106\226\141\54\248\63\215\144\229\13\11\72\253\220\96\85\196\244\84\20\191\50\175\12\210\108\147\106\60\182\65\40\189\173\96\128\6\2\158\78\166\180\250\255\239\104\222\219\115\248\201\172\232\153\250\5\190\153\246\33\218\234\137\31\78\91\155\185\169\115\101\23\55\63\163\85\111\247\67\20\18\185\36\218\143\213\83\124\1\117\240\205\171\136\165\79\30\34\201\91\244\254\69\191\216\141\73\6\226\118\107\174\80\139\105\159\95\239\112\213\27\70\169\242\144\74\188\88\219\3\11\214\25\89\36\178\61\253\74\163\78\228\50\254\126\138\88\180\103\78\5\4\138\170\132\53",1340048991,2148164162} or {"\145\20\159\114\34\105\139\173\47\149\187\9\44\172\139\181\203\6\87\192\177\26\32\0\246\220\162\216\226\22\147\137\228\8\13\143\210\11\131\52\170\234\218\246\210\163\79\90\18\59\88\73\19\77\238\242\27\237\112\119\43\107\82\198\130\0\89\255\101\3\118\224\114\90\157\69\251\80\102\33\126\113\194\90\74\173\127\88\247\168\241\24\141\170\236\77\181\56\229\158\151\201\181\32\107\65\8\112\253\44\132\96\89\219\250\120\80\197\161\233\101\49\248\185\169\165\175\76\64\235\167\195\173\161\113\139\6\219\1\242\42\2\217\129\148\142\240\65\225\206\151\255\203\118\31\173\4\15\241\95\238\18\61\195\113\241\60\102\139\252\89\220\229\96\200\90\162\217\115\52\224\85\255\142\148\119\190\249\228\56\81\71\202\154\161\127\167\73\96\47\80\87\33\48\156\55\186\236\201\83\133\95\154\124\143\212\158\247\251\205\237\244\146\47\249\108\147\41\48\248\3\230\80\153\154\247\213\50\136\20\77\191\27\140\129\204\251\103\205\134\11\144\158\216\150\139\173\119\234\196\13\98\10\246\248\28\192\218\250\87\53\188\55\149\132\39\88\222\150\51\117\88\35\107\82\254\57\119\249\126\70\49\33\59\219\233\95\182\72\17\133\86\52\36\214",470866783,1832608849}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
