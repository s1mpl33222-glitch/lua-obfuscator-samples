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
local fresh=url.."?retry=f53ab93c31420cf4"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=f53ab93c31420cf4"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\99\56\55\102\97\97\49\99\101\50\50\50\50\54\56\55\50\101\102\48\57\98\98\97\49\97\99\48\57\57\50","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\117\74\83\49\55\121\50\110\51\70\69\51\99\69\45\104\58\51\57\55\66\103\83\114\87\65\87\86\56\73\98\87\50\95\118\79\75\49\81\58\67\120\112\66\68\110\55\100\97\72\66\105\100\112\116\121\53\119\111\104\53\98\77\112\53\74\73\83\111\81\121\121\116\79\52\122\101\118\69\67\108\100\99\88\109\109\103\122\77\115\80\50\48\97\106\110\67\103\73\107\103\76\107\97\53\55\97\119\72\76\120\84\89\45\113\121\54\113\106\80\97\78\115\53\103\72\83\79\80\65\90\49\80\89\49\108\70\79\115\65\45\74\51\95\65\83\98\109\51\51\112\109\66\50\73\55\104\102\82\85\107\118\80\66\122\76\78\56\121\56\70\79\113\89\56\68\82\84\118\68\76\54\100\87\52\80\97\45\90\85\48\117\103\67\56\85\99\48\82\113\87\111\45\103\109\106\78\87\99\76\107\74\53\111\67\88\106\106\77\66\52\66\116\98\117\100\90\114\120\85\84\51\67\80\106\87\110\109\90\81","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\212\224\238\201\78\127\227\59\67\90\77\224\252\2\0\28\93\40\94\106\53\132\180\110\224\154\42\28\108\55\123\7\238\132\1\240\36\115\167\12\48\162\69\227\23\198\255\226\87\184\186\237\174\118\213\46\9\3\226\180\250\229\233\13\179\20\135\72\119\100\128\250\244\18\153\58\61\104\42\131\169\175\230\122\222\1\186\224\72\26\91\91\71\97\106\204\125\228\186\141\7\156\81\183\84\187\243\137\220\13\48\1\232\0\148\48\111\9\212\24\55\21\112\172\142\224\124\118\111\77\127\233\171\131\10\209\55\239\249\234\21\144\184\136\131\232\112\0\203\15\36\180\175\176\29\7\130\218\109\17\189\172\203\105\33\203\167\81\97\49\34\192\241\175\12\13\225\17\225\99\239\170\230\240\52\231\117\41\26\99\28\213\195\1\140\63\79\26\4\176\155\24\231\228\216\133\189\180\222\87\202\106\118\12\120\78\185\26\225\100\175\54\70\57\5\134\14\226\93\68\5\84\92\165\8\221\22\249\61\76\171\53\21\71\214\79\227\63\158\77\176\26\25\187\78\251\39\109\31\176\207\223\129\159\248\55\88\145\215\192\68\102\95\6\59\170\44\232\208\39\14\12\12\145\249\211\215\204\167\30\217\81\172\3\101\87\147\18\83\51\212\229\227\84\132\80\165",1511514397,844128597} or {"\97\176\42\25\166\87\25\40\43\59\221\42\75\211\27\66\138\208\198\37\90\27\198\2\238\99\1\157\47\3\160\225\90\139\233\118\46\104\117\234\129\97\113\146\191\134\246\68\5\188\238\43\183\22\221\204\194\23\187\156\190\175\84\206\74\134\223\153\190\220\38\138\203\155\218\185\187\138\140\56\132\50\121\201\182\133\84\69\74\136\62\230\20\62\118\47\248\211\228\133\10\89\138\115\46\47\152\60\179\26\63\167\232\70\248\175\42\154\237\71\105\120\14\20\27\28\243\188\14\119\252\179\248\68\90\198\160\210\210\108\178\169\140\88\241\73\77\169\231\126\247\81\106\26\74\168\165\33\137\148\48\89\13\193\138\73\142\50\219\46\253\3\7\131\225\216\10\60\116\229\24\172\29\134\33\255\212\73\179\65\245\200\150\125\39\143\233\177\19\194\0\132\28\78\166\22\22\124\114\208\224\73\245\103\72\239\69\80\248\245\204\23\71\159\210\171\254\130\224\93\177\51\157\35\131\69\237\126\86\234\243\254\227\92\107\49\196\60\81\161\67\153\8\218\82\214\235\57\164\247\154\103\207\69\6\127\102\241\69\161\185\71\219\224\41\28\109\9\8\86\252\118\159\189\72\202\103\196\123\222\57\180\156\28\50\239\139\98\139\131\240\50\201\255\161",4195745766,532243300}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
