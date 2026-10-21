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
local fresh=url.."?retry=d524481fe3abf69d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=d524481fe3abf69d"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\55\99\100\53\49\102\53\48\100\102\102\49\50\48\99\100\51\53\56\101\55\48\99\48\57\101\99\98\56\98\101","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\56\98\87\78\49\83\72\122\74\70\109\56\83\116\48\113\58\49\82\73\106\120\90\120\90\85\71\122\53\99\113\66\66\106\122\66\88\76\81\58\114\121\105\121\69\113\115\68\106\56\50\100\115\90\67\115\97\52\122\83\78\72\98\110\76\73\80\114\110\69\75\65\115\67\122\76\49\81\88\70\116\109\82\49\117\82\98\119\116\71\82\118\65\50\79\71\74\70\66\45\118\81\100\108\98\99\50\54\101\52\49\77\114\68\86\78\118\74\66\104\116\55\121\55\106\67\116\104\115\86\83\113\78\52\79\85\56\111\54\120\119\65\87\98\49\71\104\86\105\117\54\52\107\98\65\70\89\102\55\74\77\89\67\88\105\111\55\104\87\103\109\49\107\45\114\55\107\115\73\45\51\103\118\122\79\57\120\100\83\82\88\55\71\48\114\99\70\79\102\82\118\67\75\65\72\66\78\45\57\111\121\118\79\107\66\82\119\87\120\110\99\98\90\95\109\114\76\113\120\116\122\74\106\120\65\48\74\89\53\77","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\244\22\74\187\131\85\149\229\213\116\141\175\153\22\119\89\112\178\179\136\136\119\155\119\165\184\66\43\162\72\224\82\34\98\10\136\155\95\199\204\182\85\97\42\254\86\194\71\237\28\26\190\217\26\170\237\167\199\103\88\183\128\60\151\61\197\126\110\29\207\8\75\248\99\161\241\4\180\215\235\120\204\132\3\27\87\133\50\229\128\205\141\18\72\111\139\13\188\100\82\13\195\172\92\144\205\167\253\174\251\135\141\229\180\124\205\141\181\217\152\62\112\4\250\9\142\100\128\8\122\139\232\56\252\225\208\224\186\19\186\146\16\242\177\54\130\141\117\207\135\211\11\229\255\252\199\65\193\194\135\73\3\153\131\166\7\244\230\60\14\38\89\66\149\39\96\160\200\144\251\226\169\47\43\209\220\255\77\5\68\73\173\107\31\97\43\201\189\35\234\178\228\136\203\5\129\72\216\216\249\129\119\47\17\20\244\85\135\79\11\134\164\227\139\50\229\137\119\62\117\201\182\3\210\237\138\152\104\88\197\74\133\55\26\141\234\6\150\57\174\6\160\34\67\204\168\110\30\119\29\13\11\78\125\88\205\219\73\158\137\200\213\157\212\238\200\31\217\200\110\207\45\192\21\80\68\53\186\180\176\204\243\194\196\214\124\75\154\253\45\180\132\59\53\10\129\113",4292759748,2107335503} or {"\250\113\244\29\37\105\42\30\129\168\130\233\151\122\183\112\82\24\170\144\53\114\200\234\43\229\146\103\27\213\130\73\181\16\64\183\69\141\53\217\163\112\150\60\113\82\216\13\240\184\171\196\3\171\140\92\218\171\230\226\146\79\38\230\53\145\83\18\235\220\213\165\69\234\107\135\58\89\93\127\130\114\82\25\242\22\82\35\58\84\208\141\23\213\175\124\170\82\234\96\139\28\58\125\251\203\38\95\242\48\120\133\85\90\230\156\70\167\160\154\153\145\12\159\56\127\56\229\0\180\100\169\12\152\166\129\237\38\241\85\64\210\60\237\14\243\114\191\232\209\98\153\27\87\9\169\175\65\145\248\79\136\124\160\208\60\119\178\174\197\13\235\234\157\7\0\175\182\163\60\222\110\167\211\161\110\9\176\245\104\117\187\34\50\207\212\32\133\194\144\49\16\170\236\92\104\105\199\75\173\159\213\74\248\131\165\175\144\132\223\219\1\165\172\18\177\158\255\34\18\43\60\155\65\85\239\128\7\11\214\205\127\248\20\37\161\200\62\234\91\3\225\245\39\161\49\231\63\72\27\96\149\235\112\38\34\180\84\12\148\17\213\79\131\78\183\96\184\50\92\214\58\178\2\112\185\185\58\3\90\209\133\207\84\175\52\134\158\239\121\62\22\167\99\79",3333003567,1781556574}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
