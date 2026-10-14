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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=ee43712f65b3d999"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=ee43712f65b3d999"
local expected=898586
local runtime,reason,issue,pr=nil,nil,"request failed",0
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
if s2*65536.0+s1~=1933677448 then problem("runtime checksum mismatch",3);return end
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
local candidates={{fetch,"HttpGet",url}}
if fallback~=""then candidates[#candidates+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then candidates[#candidates+1]={candidate[1],candidate[2],fallback,true}end
candidates[#candidates+1]={candidate[1],candidate[2],pinned}
end
candidates[#candidates+1]={fetch,"HttpGet",retry}
local started,ni,ls=clock(),1,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=candidates[ni];ni=ni+1;ls=clock()
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
for poll=1,2000 do
if clock()-started>=40 then problem("HTTP download timed out after 40 seconds",4);break end
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
if runtime or reason or(active==0 and ni>#candidates)then break end
if ni<=#candidates and(active==0 or(active<2 and(completed or clock()-ls>=8)))then launch()
elseif not asynchronous or not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\98\98\48\57\102\51\51\102\98\99\56\102\98\55\102\99\49\52\102\56\51\52\56\102\97\50\54\52\56\52","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\80\79\120\114\78\114\122\77\56\100\110\105\95\45\112\50\58\72\117\52\122\85\90\56\121\117\95\67\112\118\72\82\54\66\52\45\79\86\81\58\70\52\109\73\120\69\81\68\122\77\83\73\120\67\114\89\107\49\80\80\73\76\55\117\65\75\100\45\111\67\97\84\53\122\71\71\74\57\51\110\95\71\118\48\111\103\101\81\99\104\74\118\56\116\87\66\53\121\99\106\106\86\87\52\81\104\102\116\113\115\65\121\83\82\113\65\48\104\71\97\120\66\51\115\98\109\99\105\76\84\71\109\53\119\120\89\121\66\87\109\83\78\109\71\71\76\78\55\99\83\45\48\72\88\49\53\116\88\65\76\117\55\109\99\119\76\97\66\102\49\90\71\111\83\67\100\106\67\88\80\45\76\114\45\90\122\99\99\109\109\118\54\65\102\87\57\121\118\105\101\65\54\76\53\81\72\45\88\67\90\80\114\49\83\76\55\50\73\67\101\71\112\99\114\114\87\50\100\90\121\72\67\79\107\108\78\81\89\89\72","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if fetch then pcall(fetch,host,target)elseif reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
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
local handoff=alternate and {"\132\154\191\29\203\167\125\166\126\18\147\123\171\50\104\89\135\166\97\122\253\222\55\242\36\160\54\29\137\146\68\21\125\30\97\206\129\36\150\248\195\246\205\185\181\197\203\85\40\243\27\76\181\63\209\110\219\90\215\83\31\161\244\165\210\109\203\139\218\54\172\250\29\228\148\34\110\6\164\208\84\17\17\119\86\212\57\187\109\232\99\201\22\166\62\3\96\80\240\112\239\227\105\68\154\150\121\72\174\52\88\173\11\21\146\165\134\211\99\25\24\73\80\163\253\39\158\161\27\148\192\147\94\154\173\180\208\43\179\76\210\136\60\123\111\172\189\66\233\82\73\191\185\201\80\203\61\238\39\160\120\146\234\180\117\246\242\251\124\248\122\128\58\152\248\163\76\179\4\96\105\227\231\13\183\223\75\53\216\227\66\143\29\213\246\82\232\113\193\235\13\134\135\53\82\110\7\214\46\178\136\221\204\42\164\98\60\178\122\137\144\144\32\236\251\48\182\140\63\79\196\180\108\76\179\231\255\198\140\140\234\98\96\66\96\129\7\24\44\133\203\253\54\103\184\55\155\238\69\134\3\39\170\139\32\36\252\236\143\216\32\107\233\65\70\25\37\180\251\131\69\58\84\31\68\251\183\76\196\93\205\133\196\231\115\211\224\172\0\60\141\231\234\162\238\66\200",1046079243,3139461556} or {"\82\182\59\139\129\233\177\119\9\112\209\242\157\119\106\30\77\143\249\106\55\50\252\142\252\127\85\233\182\14\123\108\199\73\121\244\26\232\225\46\195\228\67\48\87\35\63\136\209\64\213\69\135\223\215\32\144\213\134\109\126\232\210\166\158\40\245\215\180\91\212\40\240\145\120\190\193\216\11\175\90\167\4\241\65\165\44\161\175\220\216\179\230\147\139\157\255\172\204\244\215\64\165\156\28\234\116\158\207\218\7\91\249\129\70\46\135\120\75\132\172\171\228\225\107\233\152\213\140\81\27\187\136\124\85\209\10\176\211\192\209\152\92\123\4\179\46\254\106\164\69\172\41\240\174\97\89\130\222\114\153\76\132\40\158\143\192\159\227\150\249\195\58\221\33\74\243\127\206\89\122\26\189\246\133\168\26\242\35\141\0\163\51\157\32\164\106\60\169\148\98\55\150\37\197\193\245\49\45\95\161\68\98\146\39\133\136\220\99\11\185\4\45\90\58\157\10\93\196\35\71\81\111\1\1\46\114\248\97\103\150\121\74\122\102\69\98\184\178\33\141\7\162\153\195\77\92\36\123\10\122\136\143\204\80\86\246\91\156\232\199\168\253\55\20\107\136\51\101\76\239\183\166\105\253\60\9\244\5\233\76\253\66\118\204\197\24\20\79\229\23\78\96\26\245",1208762029,2831246275}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
