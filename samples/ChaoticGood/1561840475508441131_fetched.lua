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
local fresh=url.."?retry=9cbfa6f465b7e56d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=9cbfa6f465b7e56d"
local expected=617906
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\54\116\81\71\87\110\52\89\50\55\105\98\48\51\102\54\58\72\110\86\66\106\77\79\84\105\65\107\87\80\118\122\51\65\57\89\109\56\103\58\112\70\100\86\52\109\111\71\71\68\82\116\98\73\95\71\75\100\84\66\98\120\75\120\73\82\53\111\104\100\65\110\65\65\69\102\117\52\107\70\67\66\114\55\87\72\122\77\101\48\65\84\106\98\104\49\73\67\81\117\116\95\116\122\116\108\85\122\87\49\100\68\76\101\50\83\65\97\102\80\72\71\112\106\114\83\104\117\66\104\76\68\65\78\104\118\114\71\112\109\99\104\102\77\95\118\69\48\106\102\56\54\101\77\89\114\122\109\118\107\84\81\49\105\100\83\67\121\105\98\55\95\72\103\79\89\52\85\48\102\81\72\76\84\118\116\74\110\107\80\103\53\109\66\98\53\111\54\103\52\77\115\71\117\100\71\45\95\68\95\107\90\66\80\76\100\80\113\109\100\56\72\99\71\113\88\89\89\116\76\105\75\66\51\119\118\79\82\66\108","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\47\99\58\161\81\152\212\128\134\198\97\193\92\94\161\203\95\201\158\143\60\172\211\149\34\85\86\244\78\251\38\93\121\35\138\246\132\71\169\27\153\51\214\186\101\108\172\11\70\10\179\231\209\253\186\50\166\180\82\43\77\67\200\190\27\15\132\125\51\246\188\82\81\201\34\131\20\129\47\38\0\52\44\178\196\14\201\43\38\132\224\23\23\52\252\145\76\241\185\184\20\186\123\91\192\195\102\63\76\175\224\106\64\157\128\6\145\44\252\134\119\57\69\38\181\61\112\46\213\112\85\160\92\237\97\168\5\67\173\38\28\62\71\108\160\130\181\218\77\218\243\59\49\127\17\118\142\67\128\221\223\212\241\147\227\209\199\186\168\174\4\206\69\124\40\242\129\63\90\185\255\8\153\96\18\187\11\164\72\139\117\83\97\240\173\22\11\85\226\240\197\7\197\119\146\201\119\46\159\4\95\222\42\251\77\186\48\230\209\98\78\80\152\48\210\90\102\211\48\40\13\51\57\245\153\126\193\72\144\118\77\121\69\104\155\138\86\194\118\12\109\109\6\229\12\112\206\236\210\60\155\213\119\201\185\195\99\225\151\182\130\105\55\174\168\67\201\184\27\33\41\192\250\117\80\103\98\136\252\144\16\10\211\109\154\174\137\187\38\192\179\98\132\4\57\104\93",2495330644,1708417705} or {"\83\47\105\119\161\223\38\167\190\128\233\50\5\234\172\204\190\224\32\230\228\28\235\123\129\136\28\164\169\95\50\97\45\161\13\181\133\173\231\98\215\204\147\16\114\71\175\229\132\202\236\99\21\211\138\153\195\37\193\31\228\185\175\8\254\135\93\40\254\3\55\70\0\142\65\78\196\169\39\52\199\153\130\249\141\115\8\226\120\71\156\32\29\171\32\24\9\240\244\35\138\90\96\232\20\162\135\58\205\84\246\123\81\176\65\203\21\97\59\232\162\221\46\84\39\114\198\219\7\74\72\214\52\158\95\149\64\81\39\117\243\211\25\233\205\201\127\109\210\229\222\146\143\203\116\120\131\148\193\109\53\18\112\107\108\51\221\111\119\6\68\107\26\92\107\132\93\190\1\246\164\132\9\184\252\225\173\153\133\95\50\202\91\41\195\218\168\8\166\37\13\86\95\39\4\239\3\55\165\101\132\124\142\191\187\61\187\50\200\60\84\13\0\166\41\174\142\28\13\17\215\126\109\186\248\152\131\185\124\114\159\123\114\225\211\33\189\163\60\4\253\53\137\78\11\246\122\13\161\159\188\67\149\227\40\108\147\174\200\47\100\206\15\171\63\50\107\152\198\207\206\20\168\92\113\8\141\29\119\130\86\227\99\216\223\169\7\193\155\115\209\153\239\105\132",991852649,1407804600}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
