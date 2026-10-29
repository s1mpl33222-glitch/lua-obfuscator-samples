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
local fresh=url.."?retry=03965b81de370b32"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=03965b81de370b32"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\70\55\72\65\65\105\122\56\107\78\98\50\86\99\55\108\58\83\72\98\50\100\74\118\81\119\111\79\65\97\53\79\105\45\84\115\109\80\103\58\90\69\74\104\49\83\53\71\112\112\100\115\69\68\90\77\45\70\86\74\56\54\118\108\101\99\54\45\53\106\48\80\105\56\101\117\115\117\112\69\100\119\86\49\72\53\114\103\110\104\112\65\78\49\84\84\111\50\111\84\71\95\72\113\97\68\67\90\105\53\90\116\115\72\79\79\49\104\77\102\103\45\78\67\101\106\79\84\106\73\52\101\110\89\98\88\111\68\54\50\87\56\68\116\119\105\88\99\98\112\52\86\52\101\57\95\75\90\77\57\74\111\95\99\109\65\71\121\76\57\117\118\103\119\102\54\119\112\100\83\76\71\120\119\122\45\80\104\120\50\118\88\70\54\108\78\78\114\95\65\99\100\120\69\68\67\76\72\122\67\107\50\81\78\76\50\122\89\108\77\67\80\106\113\108\70\74\107\105\48\69\118\52\119\121\107\118\85\67\75","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\28\63\58\47\189\74\159\67\237\149\47\58\232\90\150\74\94\22\144\43\138\246\241\15\107\173\152\60\91\211\206\17\125\22\52\83\219\140\22\7\97\239\221\131\62\24\236\44\131\249\159\234\214\241\95\189\80\7\104\211\58\110\124\229\194\0\161\103\82\66\122\240\92\5\136\242\192\133\47\191\227\161\19\160\209\23\100\139\210\225\253\48\194\165\167\42\203\81\150\132\7\235\188\160\111\252\16\161\134\113\160\195\56\62\91\225\158\249\134\90\206\80\28\26\37\192\162\35\7\103\25\212\34\254\89\69\229\171\49\27\89\200\70\77\78\38\248\250\66\149\66\42\6\5\17\9\104\237\36\247\97\247\200\27\10\110\190\68\95\232\215\96\248\215\1\124\164\202\202\117\54\45\184\206\91\200\243\106\204\1\153\213\10\158\218\11\39\60\235\50\41\73\22\52\40\234\168\182\233\105\144\142\163\37\177\22\20\156\9\249\76\205\7\238\99\198\136\208\153\144\253\228\199\110\62\30\229\152\179\92\184\112\125\157\77\31\7\194\234\42\185\164\165\66\61\249\179\116\146\69\149\8\16\173\37\250\76\73\221\224\98\7\82\74\138\175\64\121\158\26\170\192\227\249\179\1\58\77\78\126\242\165\250\171\175\109\248\108\170\166\82\1\205\37\30\28\176",1597280336,3962855920} or {"\106\217\195\158\39\45\105\102\80\137\31\17\120\13\184\41\133\163\69\36\161\164\60\227\19\73\216\57\198\136\37\107\186\51\98\46\17\55\95\117\1\185\247\2\68\48\37\143\220\10\185\133\33\134\244\128\57\253\25\108\7\68\59\172\86\136\205\128\220\88\37\113\247\95\157\37\19\132\223\88\39\138\38\61\245\243\244\173\189\163\100\232\246\128\221\127\110\157\240\166\96\48\78\176\144\8\152\100\139\198\87\196\13\32\233\94\117\178\181\246\178\214\177\18\152\174\18\135\246\131\182\239\25\208\140\57\255\211\68\26\116\165\30\127\235\63\206\231\69\180\41\198\219\168\5\61\231\177\13\219\45\193\83\115\236\204\209\37\249\32\250\43\165\252\226\196\83\199\27\9\117\140\28\154\86\193\167\238\150\22\241\61\141\72\57\101\107\153\90\29\58\19\226\106\104\231\12\107\146\238\133\216\20\127\193\3\207\169\212\120\35\228\102\74\27\207\50\40\136\54\158\74\142\66\84\33\30\26\90\56\216\8\246\72\96\246\240\238\167\70\2\148\180\39\152\133\132\135\221\252\104\145\131\23\145\49\57\117\225\21\221\205\55\224\28\29\238\85\181\1\199\253\95\213\94\113\44\73\122\76\141\114\168\77\188\2\13\226\150\198\109\191\128\102\35",2115839510,3662242815}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
