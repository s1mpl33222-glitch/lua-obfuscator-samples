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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=b7bd6d26dd4e53ce"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=b7bd6d26dd4e53ce"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\99\48\51\101\54\54\101\57\100\49\98\101\53\50\56\51\55\55\53\48\99\49\48\99\99\99\48\100\98\57\52\99","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\112\50\101\45\72\69\88\86\48\97\95\106\81\76\45\65\58\115\115\112\105\118\120\117\73\122\57\112\116\113\51\56\101\95\83\77\81\65\119\58\117\51\50\117\81\122\103\56\111\70\115\56\87\74\53\48\48\80\69\51\81\73\111\80\110\68\112\105\87\86\117\105\72\117\78\103\115\121\76\104\52\70\95\105\49\110\74\114\109\67\102\84\80\95\56\115\45\112\68\49\80\51\54\81\70\69\108\99\76\121\86\49\110\117\72\99\102\112\76\73\84\88\107\50\103\79\52\121\53\54\51\89\115\82\81\108\100\97\100\120\48\111\98\74\90\85\105\121\71\52\71\118\86\99\119\100\114\48\88\51\107\103\98\75\88\109\67\67\79\120\108\74\81\75\118\102\117\45\57\71\112\117\105\111\45\117\120\68\95\108\52\52\100\68\104\114\82\45\77\114\73\113\50\57\105\119\66\51\89\120\78\70\98\97\101\86\113\72\108\118\78\114\78\98\109\69\71\90\57\89\79\108\78\114\105\73\86\119\88\104","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\5\10\62\72\23\51\74\125\79\71\102\34\132\253\235\153\189\131\97\33\45\172\98\29\150\15\141\12\155\196\176\190\92\174\213\111\188\164\186\5\166\44\70\109\211\34\29\31\165\138\179\171\118\216\200\133\171\122\192\89\187\89\230\246\134\18\92\193\252\56\113\124\115\54\41\58\205\125\128\100\10\249\187\239\4\17\68\199\251\138\207\207\210\168\89\209\130\37\170\58\100\19\112\188\36\217\154\210\195\36\242\32\214\122\216\170\140\97\91\218\103\30\90\41\124\70\207\30\63\119\66\137\22\157\245\40\48\74\35\147\218\4\92\11\124\89\105\198\71\237\97\223\15\106\173\232\24\56\251\7\156\32\107\122\196\194\60\154\226\15\213\72\126\57\113\54\201\150\173\195\19\152\253\199\188\206\226\118\90\222\182\7\151\177\234\121\195\184\197\215\210\89\202\110\147\8\248\16\3\45\111\167\201\176\123\74\251\160\245\248\58\76\244\146\14\12\190\50\126\166\72\123\133\83\224\222\122\159\103\107\239\99\236\250\193\229\200\119\141\198\4\63\2\166\145\21\118\196\70\240\11\199\80\44\10\23\137\201\247\163\16\63\154\79\145\23\73\84\108\172\214\238\38\248\151\63\223\9\165\109\214\242\78\150\136\17\64\68\227\188\252\100\139\131\7\88\191",2861299422,3805045581} or {"\43\108\195\34\22\128\187\135\26\252\229\75\198\140\130\154\133\182\105\40\75\225\232\106\21\164\54\108\103\39\51\164\77\42\198\148\212\22\165\126\61\47\58\208\224\83\72\254\208\17\211\7\180\62\67\159\128\254\70\103\4\180\247\26\80\59\149\104\153\149\250\213\223\68\201\151\96\121\73\60\56\231\0\130\242\51\125\152\94\15\106\6\197\73\220\198\10\50\223\150\39\164\159\13\97\162\145\17\121\180\64\221\217\129\186\198\15\186\233\240\250\112\113\186\24\43\225\154\150\138\186\10\12\244\117\58\79\241\250\31\161\213\179\192\145\108\125\23\209\232\219\52\159\59\54\241\189\56\227\78\35\219\186\101\167\157\28\250\27\4\28\229\161\207\207\225\167\132\11\113\11\145\21\242\222\31\157\81\242\73\100\163\119\202\62\213\162\18\10\249\251\252\35\189\175\80\105\84\197\126\251\209\138\1\160\163\113\151\31\155\173\217\116\17\74\240\247\131\116\103\211\73\181\26\72\201\161\71\226\66\91\54\223\192\58\103\93\3\62\8\247\8\66\244\161\3\25\133\40\255\65\81\202\211\86\115\214\116\88\130\100\82\211\196\185\116\141\172\41\243\3\205\161\58\107\13\14\235\242\243\215\89\39\64\10\23\69\251\55\59\12\193\64\19\179",3222975568,3499058524}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
