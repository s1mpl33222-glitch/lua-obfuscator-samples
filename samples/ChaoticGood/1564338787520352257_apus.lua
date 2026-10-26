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
local fresh=url.."?retry=5a0406dec8bc979a"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=5a0406dec8bc979a"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\48\51\97\51\57\52\54\57\55\53\54\51\57\100\53\99\56\100\53\53\52\56\97\52\102\57\49\49\98\50\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\77\72\55\119\86\107\107\82\110\67\82\99\65\120\95\103\58\69\71\116\66\50\52\117\74\73\51\122\88\54\72\104\87\67\119\105\56\108\119\58\87\109\89\102\72\97\117\99\119\111\48\75\86\72\51\67\83\121\86\102\48\80\66\119\77\84\81\81\70\68\116\55\110\57\102\88\80\45\54\119\114\55\52\95\105\107\55\115\74\72\69\77\76\70\89\52\121\73\102\84\101\106\54\78\103\109\102\53\85\118\50\119\65\70\70\77\67\66\45\113\75\108\81\118\84\55\98\119\53\51\98\100\101\90\99\87\106\95\87\99\104\81\117\80\73\117\45\88\87\121\67\66\119\114\121\114\89\57\120\117\104\120\69\78\69\110\122\75\121\98\121\118\82\69\80\120\80\85\87\84\106\81\72\111\121\85\69\104\121\110\117\48\99\80\90\75\106\79\69\57\67\83\105\82\107\45\109\83\102\88\56\78\112\77\116\109\95\73\108\112\103\110\72\68\105\121\48\120\81\111\86\48\67\51\112\106\113\77\107\72","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\89\159\185\146\193\41\153\154\196\223\147\70\20\140\89\230\118\94\167\28\44\105\217\1\79\231\127\137\91\59\66\203\111\17\249\77\67\57\76\240\71\124\73\17\149\232\34\15\63\53\239\162\15\89\192\190\197\20\20\171\44\23\167\80\117\126\90\142\91\35\110\255\158\242\125\169\100\160\96\178\169\43\252\250\0\4\217\68\21\121\23\203\108\228\140\153\108\80\242\79\84\129\45\240\25\64\42\17\211\141\213\41\28\217\105\69\37\213\63\197\6\23\223\63\177\44\173\182\144\125\117\124\215\59\108\228\175\124\145\73\80\224\202\100\168\52\231\12\190\30\76\28\40\34\147\248\206\204\21\191\90\141\198\61\30\158\230\127\63\169\83\134\6\40\217\240\147\225\157\216\138\234\168\180\99\67\142\113\45\49\166\33\143\7\236\239\181\96\5\86\168\81\199\57\175\253\124\234\58\199\112\37\247\53\61\232\20\132\139\160\135\101\90\126\43\228\186\207\224\92\204\139\219\231\71\224\41\182\124\239\246\202\6\37\23\231\17\182\72\7\145\187\178\78\13\87\183\153\228\132\127\214\123\160\108\107\192\205\159\25\2\56\163\130\125\249\167\233\209\116\194\179\145\184\147\190\207\233\218\74\118\151\108\45\174\162\188\34\78\107\78\136\61\126\108\84\107",1381184583,3195626184} or {"\3\233\52\92\69\71\28\122\199\241\70\2\101\53\23\21\80\36\91\168\75\52\80\61\59\218\12\16\117\103\21\222\43\124\84\161\64\1\238\214\96\218\238\114\152\29\109\236\187\205\223\29\97\220\53\16\222\243\125\195\126\213\61\102\25\4\177\194\147\69\129\73\15\110\20\227\252\54\136\246\130\215\23\55\75\153\94\91\10\225\141\106\29\133\208\192\211\141\201\58\131\54\114\94\245\125\246\58\63\152\85\15\214\63\228\192\118\220\27\110\108\89\10\252\30\188\0\84\50\117\198\58\42\138\111\101\173\186\218\254\110\88\31\202\171\34\162\11\220\158\197\71\159\56\51\183\90\249\152\134\206\227\192\108\217\132\152\170\49\179\162\125\60\193\41\208\3\34\165\114\167\21\171\119\42\154\119\251\227\66\71\194\30\232\242\97\10\60\158\14\68\252\163\53\28\187\235\228\228\147\78\204\8\102\228\159\185\49\99\57\119\235\195\31\4\39\103\149\24\152\21\53\217\126\28\157\67\4\82\228\129\110\132\136\20\184\101\203\235\116\84\92\7\4\147\149\60\248\4\246\215\228\53\189\50\209\148\252\139\126\100\252\255\166\191\209\31\170\215\96\1\194\240\159\54\211\200\66\61\239\51\153\157\125\121\170\25\193\237\119\35\187\165\167\227",276909243,2923979991}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
