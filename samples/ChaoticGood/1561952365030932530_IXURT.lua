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
local fresh=url.."?retry=4844e9665b4acb44"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=4844e9665b4acb44"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\54\57\51\57\99\101\97\102\56\56\48\97\57\48\98\54\56\98\55\99\50\57\99\97\50\57\48\50\102\100\98\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\51\82\113\66\77\71\55\116\74\80\67\107\50\84\111\115\58\52\107\73\110\71\75\119\57\95\79\103\107\72\118\111\95\97\77\105\107\71\103\58\67\72\87\69\105\117\51\88\99\53\71\107\89\55\108\99\99\118\112\50\85\67\100\104\76\72\51\57\55\55\115\88\111\105\101\50\116\87\89\99\79\56\55\87\77\68\115\119\75\105\112\52\81\121\53\75\71\66\86\54\71\67\88\111\73\111\118\66\56\55\87\45\99\84\81\97\75\86\87\68\81\69\78\97\66\90\95\118\109\114\55\104\117\117\105\122\49\95\81\83\84\69\49\54\70\102\69\105\80\122\111\49\121\74\71\83\98\86\81\115\86\76\54\83\73\70\70\110\107\107\69\114\74\113\83\76\74\118\119\82\72\50\67\77\105\107\120\53\119\120\70\90\84\112\119\97\56\97\66\45\112\82\84\116\53\52\84\72\98\87\54\70\113\108\83\100\114\116\120\107\86\106\48\45\73\45\116\65\117\78\90\84\57\114\45\106\97\87\52\53","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\130\242\116\80\86\101\120\251\63\146\58\77\144\93\245\104\187\102\240\220\230\119\23\89\207\223\114\46\225\32\237\49\64\46\230\224\91\171\58\163\218\145\86\4\254\39\188\29\82\151\211\249\241\230\179\47\237\63\208\202\198\223\94\245\207\119\254\206\176\252\34\149\93\170\110\239\29\150\55\173\23\120\112\66\99\22\125\189\174\247\162\252\31\69\24\194\137\72\245\66\248\113\103\105\23\121\23\146\72\248\6\246\116\102\60\186\68\107\163\193\222\161\134\64\75\84\15\228\251\195\243\154\182\164\143\160\51\5\63\159\80\205\98\155\92\234\76\22\1\25\8\180\102\81\80\5\96\213\208\124\108\184\116\209\141\128\209\98\229\20\113\70\202\241\98\100\181\85\187\222\184\186\221\109\160\247\91\211\207\90\186\255\182\167\64\237\40\76\156\67\200\231\119\123\124\155\56\34\210\56\163\65\189\209\129\86\77\10\207\185\131\88\119\111\9\70\138\113\107\242\215\251\250\214\158\200\9\241\137\21\104\73\148\102\76\237\80\83\21\162\54\146\223\122\250\128\217\3\42\221\162\89\37\77\242\144\91\70\44\45\242\213\182\57\236\112\179\197\143\220\101\18\33\89\46\210\189\94\247\124\118\223\153\117\7\189\141\32\255\49\144\170\65\175\183\26\207",3110369931,1702453644} or {"\212\208\252\31\69\155\248\216\244\19\212\148\234\4\227\10\97\51\121\81\229\21\228\183\226\244\105\232\136\135\39\100\83\239\2\217\128\20\246\32\119\225\126\249\88\6\134\208\244\64\42\213\228\139\140\240\237\243\181\214\142\247\34\3\241\250\228\199\237\196\149\71\14\123\158\249\123\151\249\140\71\26\37\112\243\5\0\167\48\95\175\251\110\35\139\24\242\99\98\214\70\46\62\198\5\237\208\144\47\34\152\97\46\39\95\129\253\32\18\205\211\101\72\9\228\181\227\222\154\11\44\153\34\4\201\148\61\57\162\150\67\184\122\226\141\196\181\86\200\189\201\119\234\185\228\13\178\25\170\46\143\119\82\166\208\63\131\249\233\93\63\44\202\207\64\232\58\0\194\29\80\160\225\119\58\141\131\1\206\194\160\165\205\179\203\157\45\174\83\240\5\14\150\215\202\100\128\82\25\41\47\67\41\215\144\31\13\35\84\69\7\222\181\181\144\246\23\125\219\117\87\131\143\37\0\164\193\223\219\15\208\249\105\5\231\253\60\215\4\174\67\59\192\5\238\183\206\249\236\190\219\180\238\37\100\218\250\40\42\168\165\198\180\228\108\208\123\193\0\75\67\112\94\18\190\2\215\146\73\121\225\42\242\180\253\48\189\121\17\56\224\78\6\173\104",3631468844,1393583003}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
