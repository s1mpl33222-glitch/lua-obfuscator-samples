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
local fresh=url.."?retry=6e23b27e50f3349d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=6e23b27e50f3349d"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\57\50\48\97\55\55\100\56\102\100\101\54\98\53\52\49\49\101\48\51\98\51\97\49\97\48\99\102\97\52\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\71\120\55\103\77\55\115\87\55\86\85\111\119\98\69\115\58\103\69\120\56\54\116\120\97\48\98\109\89\52\119\121\65\76\79\111\101\108\119\58\49\105\117\87\119\112\111\72\66\105\89\122\98\86\102\118\53\69\105\98\113\57\69\122\119\89\99\109\87\106\118\101\76\81\121\102\113\45\111\107\78\79\111\68\53\90\102\77\74\78\103\77\102\104\119\97\112\69\49\112\52\99\87\97\66\101\79\77\71\49\95\121\66\115\112\97\66\67\54\77\79\108\111\56\65\111\52\82\80\106\53\67\110\71\86\109\65\98\99\97\98\48\104\116\122\84\81\101\89\77\98\101\57\45\109\95\54\88\85\119\74\50\76\66\51\68\82\116\67\67\108\108\112\78\105\71\89\121\80\77\95\116\77\116\109\73\122\48\102\55\70\106\72\51\102\81\48\122\51\49\72\85\117\81\122\76\74\57\108\81\87\89\105\90\103\87\55\73\50\84\85\70\113\45\55\107\120\115\45\82\70\75\119\112\67\73\119\103\73\112","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\41\253\254\166\136\19\92\166\144\239\218\62\105\250\107\75\19\79\204\52\16\7\85\247\185\206\239\26\204\62\27\201\120\85\184\207\187\62\114\117\253\76\192\121\190\113\216\0\136\84\35\149\81\105\157\47\244\182\183\206\163\11\65\168\110\64\136\35\23\35\206\248\216\10\10\48\71\87\98\92\210\56\34\198\224\74\215\102\192\205\47\36\180\60\157\216\130\252\107\238\96\195\119\27\115\228\138\63\38\187\88\167\49\41\254\195\60\58\60\61\17\29\228\235\247\175\161\199\156\214\208\156\122\141\243\65\102\96\246\28\2\245\214\212\59\229\220\118\115\216\4\243\207\183\17\125\126\233\210\33\222\150\62\123\131\165\122\80\215\74\201\249\92\108\253\20\137\178\12\173\154\205\218\161\210\150\71\171\17\161\131\147\14\135\180\122\105\207\75\53\11\249\157\239\8\208\164\117\124\226\38\251\255\218\110\48\175\163\98\117\181\3\103\154\53\238\118\221\107\177\22\231\89\182\68\5\151\194\113\65\213\42\222\2\169\40\141\199\125\249\96\218\1\40\212\83\239\25\67\204\171\186\206\63\108\179\0\46\199\192\1\62\196\30\201\127\176\87\110\107\136\246\220\77\222\183\123\145\195\233\111\3\226\157\107\13\7\110\33\194\144\139\71\169\32\215\85",767860078,2253742} or {"\178\152\211\48\198\198\87\7\36\216\235\182\83\207\215\198\129\163\117\108\212\115\104\197\31\108\91\137\124\114\199\161\83\211\48\24\109\252\111\169\111\220\228\172\59\147\161\178\191\111\91\214\105\239\92\139\132\69\128\108\133\60\117\31\161\149\146\107\72\145\191\187\111\34\164\64\77\121\63\40\89\14\66\210\214\8\46\176\214\241\97\22\42\183\61\239\87\218\64\217\220\123\234\239\171\131\84\45\143\237\89\231\215\228\6\172\210\10\226\100\193\54\52\198\80\248\114\234\61\176\38\151\137\22\20\111\171\130\66\69\138\44\177\21\78\35\142\31\185\221\224\86\65\76\231\68\157\218\236\146\185\252\111\216\3\113\46\52\52\105\7\153\139\60\126\29\248\51\56\61\95\165\83\102\69\246\236\203\181\255\242\61\79\209\231\154\57\176\146\32\232\177\126\121\153\232\149\34\207\156\135\166\79\152\120\17\86\38\237\248\191\113\136\123\137\170\39\64\33\37\194\120\25\72\243\194\116\184\60\34\164\54\199\25\37\206\168\119\30\178\90\221\176\22\78\186\65\72\63\221\127\155\109\254\60\219\40\78\12\162\252\65\110\216\237\31\10\138\106\63\206\171\81\60\181\11\69\7\201\175\34\68\130\99\232\37\31\56\211\53\10\120\28\157\172",4156476597,3991692733}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
