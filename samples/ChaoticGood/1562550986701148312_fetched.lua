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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=eec2c6cfc63d894b"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=eec2c6cfc63d894b"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\53\55\68\76\99\80\104\114\73\108\55\72\89\105\97\68\58\116\109\109\89\101\66\99\121\103\78\83\99\75\106\119\48\83\107\107\104\113\65\58\69\106\86\65\70\86\108\85\50\76\78\118\52\113\113\116\112\53\84\54\79\52\106\49\82\118\52\90\105\89\55\54\70\117\121\112\68\73\110\113\49\81\107\54\88\103\52\100\95\86\84\117\110\90\121\107\104\85\105\53\118\81\121\112\89\108\121\68\51\77\108\69\103\80\104\52\106\83\118\117\89\87\67\68\97\99\104\107\97\55\49\105\66\83\84\50\50\74\102\116\88\121\116\114\71\99\81\121\84\77\113\79\114\89\82\106\57\84\84\88\103\78\119\107\50\82\53\52\88\45\118\80\121\117\99\83\55\50\121\99\109\65\69\109\99\99\113\118\97\52\51\50\74\68\120\107\118\117\98\106\67\113\74\78\114\54\99\119\119\90\98\65\69\89\104\56\57\71\68\76\113\103\81\118\80\48\110\69\72\79\105\49\68\45\120\118\71\121\73\106","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\64\12\141\250\161\80\181\193\48\97\76\1\6\125\199\188\123\69\162\59\104\35\255\215\240\243\24\125\173\71\210\49\79\0\225\138\60\201\207\249\145\122\13\177\44\6\177\131\37\196\88\238\39\138\14\192\145\79\174\41\159\120\222\202\110\127\137\215\102\242\81\174\30\123\253\50\56\178\32\29\199\183\5\183\205\148\142\173\156\177\212\180\234\199\3\139\43\224\83\172\32\80\162\105\27\116\237\201\39\139\218\250\42\72\214\133\223\133\189\146\100\117\91\109\94\181\84\79\199\81\41\49\140\111\191\129\93\84\206\77\9\28\231\236\121\15\253\98\70\212\75\186\175\185\145\14\134\166\58\90\6\192\73\6\136\197\175\56\55\221\166\89\235\15\153\37\114\213\126\49\182\186\134\131\58\63\74\27\228\180\148\57\42\139\144\168\142\180\226\203\122\180\35\158\140\220\34\243\216\143\63\228\49\187\225\191\52\172\20\187\52\103\233\199\38\235\20\140\143\117\232\137\178\232\111\140\91\175\115\92\55\67\115\204\174\173\162\132\193\114\239\185\114\202\188\162\173\89\179\234\151\247\245\189\123\235\70\164\234\25\163\115\156\145\87\70\131\43\137\72\166\54\199\113\116\41\30\29\118\62\34\154\160\152\202\222\44\136\15\88\69\189\157\191\236\67\54",1454912376,1813210076} or {"\23\158\139\89\243\162\214\177\31\104\58\4\188\132\65\27\14\32\11\201\254\206\214\41\15\139\237\247\161\87\240\196\22\79\131\5\5\121\204\53\145\61\58\88\124\1\24\159\190\37\0\67\219\157\29\85\73\92\197\146\95\148\205\73\37\89\182\32\176\94\96\41\8\169\98\106\195\138\172\52\6\212\56\56\168\204\8\135\2\94\228\28\63\63\245\48\143\32\244\95\40\48\157\146\5\71\179\168\146\56\130\23\33\92\203\252\165\225\248\109\12\24\187\248\73\212\227\1\213\253\43\211\219\113\53\255\136\205\142\96\191\120\44\132\212\13\147\191\195\250\124\59\90\3\139\127\135\124\82\151\154\225\161\73\177\152\212\247\201\213\169\223\145\115\112\40\118\173\190\183\10\180\230\114\187\227\36\243\15\203\120\90\241\176\171\243\66\96\20\62\85\231\111\175\154\119\184\175\225\66\94\113\125\114\188\144\158\135\210\160\208\128\159\66\112\127\248\85\69\131\190\211\8\234\179\54\136\148\224\183\10\129\171\17\244\100\53\224\60\146\88\180\86\185\200\89\220\188\70\1\191\167\240\51\83\178\213\97\174\234\96\124\181\32\231\199\131\96\116\8\177\105\57\5\116\255\244\82\13\92\186\207\4\105\84\180\157\228\80\181\88\67\100\250\2",4212379122,1510893035}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
