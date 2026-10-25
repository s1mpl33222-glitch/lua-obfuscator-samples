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
local fresh=url.."?retry=bb29c3f17aaf654a"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=bb29c3f17aaf654a"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\78\83\80\122\69\84\74\87\108\111\80\122\67\45\72\103\58\52\85\78\119\114\108\97\121\85\117\111\51\111\56\105\48\80\67\108\102\122\65\58\103\113\106\52\75\101\71\87\98\104\67\56\120\100\106\56\119\76\111\95\48\54\100\105\114\103\67\71\99\120\100\84\119\103\121\119\95\68\78\70\110\67\98\45\51\81\80\120\78\84\90\119\78\54\49\85\115\101\95\82\45\66\89\109\118\106\66\89\122\77\119\105\112\49\50\54\80\72\86\66\113\108\102\79\50\89\83\103\54\83\55\106\49\99\77\106\69\73\118\104\80\71\119\117\84\70\51\117\71\106\49\121\88\73\88\114\118\108\106\81\85\72\84\103\88\95\82\88\50\65\102\67\110\86\78\65\105\83\106\120\65\101\79\88\106\97\53\82\112\75\109\54\120\90\98\108\99\95\82\86\68\107\120\84\53\66\84\55\76\71\105\84\100\116\95\45\87\114\98\65\120\103\71\80\97\57\116\51\122\81\88\80\122\51\116\95\116\51\70\100","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\1\165\207\37\137\249\239\18\187\19\114\78\119\11\60\69\71\113\206\182\20\116\111\120\36\232\250\74\49\249\12\126\218\219\246\206\26\55\131\33\6\207\201\105\210\14\233\162\83\160\145\243\28\36\115\54\139\241\232\107\149\74\239\65\94\211\192\10\189\215\55\87\184\229\19\218\178\154\71\93\65\192\140\88\141\50\24\135\255\11\28\153\112\69\43\0\89\252\55\144\146\165\187\177\106\170\24\174\8\138\106\5\81\74\167\236\127\59\155\214\240\139\104\229\243\65\158\27\48\157\59\75\25\131\209\179\132\153\80\104\111\222\190\248\244\211\142\17\198\77\110\241\242\153\200\211\134\71\138\40\181\85\157\98\203\232\68\19\64\181\5\223\201\34\64\33\72\171\88\139\177\108\201\33\180\22\166\38\251\220\169\11\170\212\118\41\83\157\36\83\244\62\229\21\39\104\238\143\1\30\2\255\244\132\215\206\7\133\236\27\210\140\170\171\75\226\45\10\64\86\27\227\33\44\234\245\71\127\224\227\162\148\37\170\70\100\88\54\139\86\67\160\232\103\34\247\38\9\82\67\240\105\209\180\28\38\194\15\122\91\159\134\226\75\142\151\18\133\228\99\125\23\86\89\175\146\16\215\127\24\86\158\92\252\166\155\97\33\35\131\75\80\250\88\222\19\251",2193555981,1778934709} or {"\224\61\7\98\228\171\57\9\94\98\13\206\5\127\138\82\62\41\104\239\108\158\157\62\234\212\155\133\252\110\162\137\8\214\5\156\45\85\184\190\113\221\168\69\83\166\231\184\7\113\17\99\202\49\70\157\127\91\121\202\181\86\79\93\175\235\74\63\164\153\184\86\62\234\189\218\144\179\34\18\207\230\13\205\98\149\90\11\211\24\206\67\165\164\1\228\112\238\199\150\79\140\241\123\94\201\153\28\74\21\37\18\81\135\191\37\203\167\253\200\155\253\146\209\222\208\102\137\56\41\112\192\174\230\31\136\37\11\164\192\54\97\71\160\77\212\231\213\119\45\83\151\34\165\126\112\124\74\80\237\31\183\61\36\63\161\184\38\132\180\59\37\146\188\173\127\55\137\116\116\67\235\30\127\198\83\222\205\47\17\140\29\201\17\213\204\241\98\2\152\157\232\213\123\117\217\2\217\86\2\34\29\81\144\196\113\19\208\134\34\65\37\242\87\55\161\114\90\120\138\105\48\15\52\139\251\58\37\140\41\234\36\34\255\35\172\108\161\111\111\133\76\206\213\255\29\194\179\136\73\46\9\128\7\208\157\41\27\114\46\162\124\78\129\206\88\8\186\146\13\42\223\128\133\35\153\221\112\157\48\189\213\117\55\202\175\81\123\95\63\203\168\208\19\129",1695658281,1476617668}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
