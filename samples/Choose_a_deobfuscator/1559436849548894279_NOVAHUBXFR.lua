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
local pinned=url.."?retry=ad7406fa946cdb67"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=ad7406fa946cdb67"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\51\99\53\49\99\51\49\48\98\56\53\54\102\57\102\57\52\97\97\97\56\100\53\98\48\57\57\98\51\102\56\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\109\117\114\95\70\66\45\81\102\69\57\114\80\110\118\75\58\71\106\55\102\73\116\104\84\71\71\86\65\120\103\107\112\69\102\52\85\121\103\58\85\83\118\49\85\67\88\87\120\104\110\108\70\86\57\95\74\77\67\118\100\82\56\78\75\118\83\122\65\88\101\50\82\49\109\120\66\109\50\81\85\88\112\54\107\102\69\122\81\54\117\80\104\56\67\116\82\115\57\115\84\74\65\106\100\100\65\85\118\56\111\52\116\110\48\66\122\116\120\77\106\53\106\97\82\67\67\72\113\45\97\114\75\76\51\48\97\115\73\77\117\107\100\76\83\55\79\76\107\88\117\112\49\48\68\71\100\89\112\87\69\114\45\105\101\76\53\53\75\65\75\49\117\89\108\117\120\112\116\69\48\114\67\78\97\100\52\67\100\70\103\54\50\73\112\50\70\82\52\80\85\86\104\53\70\85\110\48\50\78\84\105\67\119\118\71\70\75\67\51\98\98\105\65\74\100\73\81\57\52\118\111\73\85\74\81\80\77\79\55","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\15\49\69\232\93\181\189\184\110\119\211\80\47\3\2\155\238\146\34\63\88\253\232\93\142\86\130\78\69\252\166\8\24\21\71\244\48\11\217\48\65\188\253\126\72\68\61\91\69\48\228\140\184\81\185\60\210\161\179\33\167\113\220\251\135\201\157\87\121\67\232\140\37\5\139\161\98\99\102\145\106\209\13\255\129\45\76\43\148\91\8\235\117\95\227\126\102\48\189\206\201\35\132\226\65\24\204\2\113\10\154\14\111\226\74\215\187\167\130\60\238\36\33\37\87\91\217\6\97\31\64\57\58\217\103\47\235\34\66\243\23\242\114\251\226\122\72\210\156\176\45\174\10\139\26\231\146\232\132\59\48\205\242\166\242\71\68\33\68\52\184\81\209\215\192\95\230\99\56\34\98\12\184\74\177\73\0\53\118\214\195\246\211\13\139\122\176\150\63\21\205\217\56\65\128\116\169\48\148\206\118\2\141\104\38\125\110\254\130\207\166\163\147\235\147\78\208\16\87\198\168\147\9\41\250\226\235\13\161\17\62\186\223\49\136\168\49\180\15\105\203\40\251\171\158\57\180\208\113\4\125\49\6\61\71\14\47\15\28\71\176\193\95\38\231\17\252\1\219\159\85\237\20\164\152\89\245\197\199\246\161\56\118\194\155\91\97\92\202\44\109\126\124\198\155\75\89",1910049774,3333185772} or {"\166\174\142\228\93\91\70\201\221\92\115\15\52\255\146\114\139\122\39\157\94\6\59\174\76\244\58\107\54\239\46\98\170\94\146\58\114\118\35\126\245\63\93\229\56\81\229\233\159\209\225\30\170\243\17\205\241\208\208\181\11\183\35\48\252\203\107\73\145\173\46\102\27\152\163\252\167\234\98\175\209\117\139\109\219\169\181\89\154\173\147\150\2\71\0\128\77\44\244\245\120\146\25\101\76\78\63\214\1\197\99\214\162\198\135\182\184\156\49\2\156\221\239\14\237\11\54\118\58\92\208\43\47\160\8\159\10\175\183\56\180\84\165\70\3\114\60\51\127\92\140\14\148\45\110\53\128\27\15\17\111\172\81\2\149\73\29\120\219\160\231\131\33\251\255\156\137\188\239\39\63\127\234\81\120\145\55\5\3\59\66\105\210\11\209\89\112\66\110\96\164\172\219\125\114\75\253\233\10\237\78\169\191\186\19\126\31\208\231\106\145\134\226\251\58\249\82\45\125\194\130\37\229\96\237\109\92\223\121\227\134\161\244\132\33\233\182\178\158\134\107\174\183\2\239\43\1\67\205\51\143\126\144\54\172\250\35\91\85\145\191\27\54\238\192\251\8\177\153\89\209\140\120\225\175\29\77\70\234\99\8\83\0\184\146\232\220\249\148\117\33\22\209\171\154",3890980249,3031130875}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
