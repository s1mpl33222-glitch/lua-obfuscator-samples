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
local fresh=url.."?retry=73cde2ede714a5d0"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=73cde2ede714a5d0"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\101\49\52\98\102\99\55\99\54\102\54\102\102\53\98\99\49\51\50\101\99\54\57\53\57\98\49\100\101\101\97","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\88\68\117\108\83\82\120\101\68\69\109\66\68\97\107\57\58\111\53\74\72\78\104\101\99\79\51\72\102\98\115\87\118\98\50\83\99\86\81\58\67\57\66\81\106\107\71\53\72\67\57\83\73\95\113\71\71\81\80\56\56\99\51\84\90\70\106\68\72\120\49\100\86\100\74\118\101\52\72\89\77\112\84\78\75\69\66\77\102\122\86\72\53\106\115\45\118\118\116\115\95\118\65\67\85\54\49\117\81\75\88\50\110\48\107\84\50\76\49\103\111\75\95\81\99\53\116\55\109\87\100\53\122\72\82\53\120\89\100\66\45\82\78\74\121\99\109\57\89\121\119\76\87\109\107\100\114\56\73\54\80\54\106\109\119\72\85\101\72\69\119\84\89\49\98\99\75\89\50\117\102\104\53\122\116\79\95\45\113\68\55\89\99\79\86\108\86\65\85\110\51\73\111\52\101\84\106\85\53\48\104\114\111\79\87\90\121\101\53\50\113\120\112\110\79\48\53\113\79\57\117\119\118\72\77\118\77\79\114\66","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\160\190\109\2\81\238\29\13\187\213\169\70\162\39\236\207\46\139\92\21\13\56\107\152\28\82\211\153\159\60\94\101\219\223\221\78\37\5\235\187\179\2\242\59\252\157\21\8\103\76\201\38\160\234\31\113\91\39\220\244\8\155\14\13\232\41\91\66\83\30\85\238\1\121\131\69\187\245\241\174\4\34\25\214\108\45\31\39\25\244\105\17\117\21\179\161\3\62\133\140\46\249\191\225\59\59\204\217\183\233\81\90\25\136\15\25\224\129\149\163\243\94\88\207\56\195\206\135\11\254\170\42\43\121\243\16\180\140\9\75\128\133\81\98\219\226\3\52\92\124\121\27\219\196\45\122\36\196\193\247\165\115\93\82\205\23\23\2\102\86\59\96\202\6\187\219\210\39\224\78\231\15\48\142\243\0\81\177\222\52\107\232\243\103\207\219\99\107\78\122\22\50\235\107\244\192\9\130\73\248\218\8\237\244\139\98\48\228\202\230\47\170\128\133\65\116\193\218\83\23\213\76\69\40\42\159\64\67\231\95\64\58\94\183\99\173\185\205\175\138\44\90\183\223\72\163\113\161\99\241\16\192\217\131\127\26\53\149\2\147\183\138\22\252\25\181\243\59\4\149\30\34\167\19\136\139\157\175\17\239\132\78\255\144\185\95\47\89\130\70\178\173\92\99\97\29\112",944811034,3927335522} or {"\27\147\134\33\208\46\54\208\5\238\185\124\83\3\145\213\63\37\206\161\72\39\168\34\118\147\146\188\219\50\34\155\197\139\154\210\121\224\4\4\72\51\1\188\34\32\231\129\131\48\112\86\84\94\193\233\36\238\78\169\204\187\42\28\186\126\243\178\239\66\117\247\242\254\178\230\220\134\193\121\22\237\249\79\115\137\60\23\108\248\60\135\229\206\104\148\59\115\190\108\87\246\47\120\142\195\85\75\115\225\132\208\8\114\158\217\194\100\142\85\93\89\252\229\77\62\64\58\2\224\137\34\70\22\48\59\133\234\61\84\124\22\127\164\224\50\184\85\178\252\164\48\14\32\84\217\249\142\219\14\213\169\89\166\179\17\69\194\232\230\155\250\241\56\35\80\76\136\255\248\38\172\18\135\194\176\17\34\118\65\230\91\121\4\23\9\97\190\240\124\5\238\231\9\73\72\222\210\157\23\56\25\234\222\228\175\238\200\161\170\216\17\245\62\83\4\247\28\50\65\219\95\191\124\193\244\102\226\152\172\134\110\214\218\255\55\180\149\98\170\19\46\125\110\60\147\101\242\88\51\128\206\190\55\248\228\228\110\155\173\227\185\249\141\247\247\141\207\156\241\42\156\35\236\249\237\118\22\161\186\17\13\224\167\73\193\182\165\165\88\239\168\179\81\37",4077718303,3594740849}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
