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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=1ef0a57867522c28"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=1ef0a57867522c28"
local expected=618951
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
if s2*65536.0+s1~=733717851 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\101\45\45\102\117\57\82\109\77\71\73\87\122\54\85\115\58\114\71\102\83\95\77\54\117\78\107\72\56\78\54\86\120\87\54\95\110\74\103\58\83\82\71\122\98\109\87\122\85\69\111\53\113\53\53\106\78\117\50\97\106\106\81\88\82\109\106\98\81\95\106\80\118\115\78\108\82\87\105\45\50\97\113\65\49\72\119\97\99\106\99\51\56\103\112\53\76\101\122\106\97\49\69\83\122\76\98\101\113\104\48\75\112\114\83\119\79\120\54\121\98\75\76\113\54\77\101\84\69\105\77\99\55\53\97\86\119\54\56\73\103\72\107\69\87\77\50\111\69\84\66\113\87\45\103\79\122\50\114\85\53\55\105\72\76\81\79\57\85\50\115\113\85\82\51\88\45\75\71\50\50\99\99\71\121\120\118\83\88\103\95\73\80\50\50\95\110\70\57\83\57\66\76\69\54\76\110\84\68\69\99\108\49\84\75\108\73\51\68\70\65\112\109\105\87\98\80\79\50\82\109\80\106\56\54\104\79\49\69\78","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\113\24\1\245\234\191\116\16\164\247\105\17\39\199\180\188\146\95\27\116\184\71\232\71\42\231\159\5\104\253\103\116\83\80\101\117\104\64\58\171\123\115\235\97\127\60\211\1\158\144\221\62\112\117\145\6\83\65\116\223\2\205\96\9\147\150\255\192\203\104\209\118\248\241\0\153\202\205\2\24\83\42\240\196\106\64\188\219\114\236\178\74\238\119\242\33\149\67\47\111\252\78\167\198\85\61\96\1\241\12\218\231\24\163\209\58\198\30\96\80\61\3\248\23\51\63\240\57\244\69\4\109\40\212\154\80\214\38\254\224\132\52\159\158\15\131\96\238\156\32\6\207\197\128\179\99\1\8\132\11\165\37\13\247\247\145\83\151\61\158\135\152\13\195\178\59\171\196\17\231\70\80\6\106\213\49\154\20\206\246\242\90\254\16\65\4\190\45\124\107\227\11\218\210\40\176\78\255\132\122\183\0\235\33\137\157\153\14\112\160\62\136\49\241\106\117\50\165\237\228\203\197\233\46\81\91\126\99\215\240\102\11\2\160\170\44\45\160\134\110\6\49\248\157\92\106\187\106\30\109\73\95\204\214\130\189\116\40\9\133\74\1\30\132\74\223\98\69\25\87\144\228\39\4\246\197\2\6\237\83\218\135\44\172\170\234\141\100\223\136\108\138\229\209\85\108\37",1837463893,1991467105} or {"\5\230\80\96\178\76\129\253\155\5\55\185\247\179\62\79\208\162\193\232\42\82\140\87\58\94\204\228\9\138\125\162\101\9\115\6\150\17\96\123\90\22\249\160\6\133\68\55\29\26\148\113\102\145\181\234\183\93\130\66\238\148\173\131\89\32\97\232\12\164\17\7\143\189\47\79\86\228\239\149\174\171\6\154\93\175\58\128\6\62\202\241\173\93\16\45\11\22\1\184\69\209\204\104\237\42\30\188\254\27\50\145\223\48\10\223\175\182\29\100\208\133\19\40\250\110\37\161\164\150\67\173\125\14\154\192\236\193\97\59\159\155\125\87\185\0\94\232\107\13\141\219\213\23\103\189\197\53\153\170\45\239\194\63\157\118\144\174\194\2\146\177\212\244\188\219\235\130\115\119\11\156\126\108\155\252\42\203\210\209\7\99\210\20\9\35\25\62\161\67\129\181\159\20\176\31\33\191\29\247\85\8\49\69\54\141\248\55\161\196\61\239\175\63\228\125\157\254\133\172\191\155\34\72\132\203\3\39\196\111\138\204\0\129\148\220\207\252\50\169\166\227\238\204\1\21\229\157\181\110\163\136\191\92\190\221\213\20\0\204\58\29\218\58\85\233\40\142\182\112\186\218\246\167\90\136\41\142\194\22\8\55\103\109\62\94\12\170\98\198\61\24\233\0\48",415474906,1690854000}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
