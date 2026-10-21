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
local fresh=url.."?retry=ab98c37fbb06dd3d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=ab98c37fbb06dd3d"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\106\81\79\119\86\107\104\45\76\82\76\103\115\119\81\80\58\100\49\72\99\70\114\114\73\77\105\57\77\78\122\45\79\113\118\110\50\115\81\58\114\105\56\111\70\73\80\71\97\51\57\111\68\76\100\49\81\78\66\82\56\114\122\89\80\116\98\121\111\110\79\113\53\78\80\104\119\98\120\45\68\68\106\110\109\51\119\75\106\102\122\69\66\116\97\101\110\83\74\80\109\106\97\49\104\114\81\90\73\67\87\90\78\77\66\114\79\89\85\117\117\66\113\119\103\71\75\57\116\57\122\101\119\102\71\97\118\109\48\102\101\66\102\95\109\86\90\82\100\72\48\106\71\79\48\115\55\53\55\110\81\107\109\80\122\122\76\97\84\49\65\56\101\106\121\56\49\66\122\45\121\102\48\106\77\116\68\116\68\69\52\57\55\107\81\116\122\112\90\81\112\75\120\86\101\121\115\88\71\111\45\66\106\71\113\80\114\104\85\49\72\117\107\51\74\99\85\80\71\85\81\89\89\52\106\50\121\114\57\81","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\137\185\116\86\1\152\53\238\58\17\205\228\171\187\143\119\132\108\108\123\113\146\15\2\84\120\64\183\6\202\126\215\250\249\236\53\238\167\233\184\224\102\186\110\231\26\11\80\28\27\208\208\61\141\75\171\164\26\240\228\172\127\181\223\252\116\193\177\134\198\209\125\237\174\245\254\49\255\13\212\77\153\37\128\144\193\20\89\253\58\4\50\71\196\9\183\106\197\200\85\103\138\204\200\211\94\135\139\126\168\242\69\7\189\193\209\232\196\56\85\236\55\54\102\180\2\159\221\152\136\150\249\49\35\59\216\33\51\100\214\98\21\30\159\144\172\124\222\57\82\80\60\186\31\40\134\25\247\22\10\100\155\144\177\59\148\172\122\253\82\168\208\196\39\122\102\154\137\6\6\101\164\95\146\64\193\10\183\73\133\167\11\147\62\146\139\49\94\35\63\41\81\101\68\53\92\213\108\147\156\164\9\210\10\19\204\238\213\219\181\0\125\106\223\186\220\202\122\110\51\59\209\49\254\146\48\89\132\166\32\209\66\67\96\210\37\85\32\122\221\148\221\200\101\129\216\22\228\141\116\253\26\59\171\161\149\221\11\162\230\116\85\196\69\44\177\28\206\255\69\175\22\190\63\219\7\205\136\144\196\82\135\155\49\85\116\39\163\129\214\205\86\139\242\182\222\173",2080401043,2385142742} or {"\150\18\186\38\135\138\180\138\155\92\200\26\28\191\0\15\21\193\136\23\241\220\239\193\96\146\199\184\20\115\254\103\53\124\192\47\80\82\252\163\137\227\8\132\177\217\245\240\12\161\65\129\248\227\242\68\152\61\107\114\0\78\207\122\48\125\0\165\135\112\123\229\114\85\250\4\213\101\235\32\45\160\67\237\175\126\28\4\225\19\179\77\129\20\67\58\88\42\218\207\35\224\63\91\46\238\33\112\57\188\231\180\159\135\211\4\33\2\243\126\188\252\90\164\29\30\147\5\133\33\45\55\152\185\80\3\190\64\210\34\127\204\47\208\51\10\114\23\0\204\147\60\19\109\122\178\101\233\39\132\221\93\190\121\200\63\228\34\78\156\39\157\152\23\16\51\114\144\84\190\97\205\167\1\113\16\57\48\238\167\36\142\102\151\86\135\90\229\208\204\63\175\51\143\223\148\228\54\150\143\219\24\64\226\170\0\163\82\16\93\218\234\30\159\17\71\202\16\135\240\111\220\250\196\162\204\143\187\135\242\18\255\167\112\101\14\93\159\252\192\160\206\180\172\192\253\187\104\153\29\249\137\140\247\134\68\13\204\84\163\241\154\23\133\40\63\201\39\183\168\79\0\128\149\40\13\37\155\73\59\130\90\1\189\24\148\235\33\126\139\252\206\225\35\8",1209045551,2082825701}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
