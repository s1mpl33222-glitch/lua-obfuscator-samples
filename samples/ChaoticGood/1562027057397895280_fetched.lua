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
local fresh=url.."?retry=796e088c4dad227c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=796e088c4dad227c"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\57\102\97\49\55\56\102\48\99\56\50\56\56\52\48\98\98\57\49\54\49\57\54\98\98\49\49\49\56\54\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\79\77\104\121\103\119\89\102\67\84\80\116\70\109\70\103\58\102\72\70\48\54\52\111\73\105\101\114\48\88\103\106\69\89\117\117\82\107\103\58\51\73\118\102\97\113\106\101\97\97\90\45\116\100\118\113\102\106\67\100\86\120\69\73\72\73\105\66\72\66\74\70\76\114\111\111\110\78\70\79\121\105\68\54\51\76\117\55\75\121\104\68\86\119\87\97\57\45\75\75\107\51\45\118\65\105\120\121\111\99\108\111\66\118\108\74\109\113\115\98\120\98\69\69\113\72\99\90\75\101\65\89\53\100\114\51\70\105\51\105\76\117\49\68\72\50\84\97\78\45\108\86\106\122\89\53\97\89\119\107\95\97\111\79\109\107\88\67\80\82\77\106\95\57\118\75\80\99\48\67\83\48\56\98\53\84\109\111\107\101\57\87\107\69\73\121\78\80\97\101\115\116\99\57\71\99\113\55\49\113\95\76\74\89\57\106\111\55\110\117\95\101\97\87\105\53\66\72\53\52\52\95\116\68\74\55\66\74\55\78","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\87\230\152\30\135\207\48\157\83\137\131\240\50\50\164\14\131\244\174\211\254\21\99\132\216\179\231\177\92\205\214\61\67\235\173\27\227\186\61\72\236\21\5\175\127\250\86\29\159\84\43\211\62\51\32\152\151\140\25\128\189\249\181\173\242\200\52\51\115\116\120\51\59\64\165\232\33\43\118\174\201\238\15\35\244\250\6\130\217\108\172\160\1\133\5\97\215\87\68\168\89\205\230\222\133\118\180\24\181\98\225\63\160\133\254\31\75\245\58\36\143\249\53\192\194\118\242\51\35\143\32\21\186\78\32\151\115\204\203\92\15\23\207\129\222\1\60\219\43\242\205\31\88\32\152\5\226\228\18\185\229\110\127\156\218\5\195\42\145\175\104\146\174\128\95\31\223\95\56\219\11\103\208\179\179\224\96\177\69\126\171\144\13\235\17\63\164\9\84\28\211\242\131\28\192\175\227\19\241\193\12\188\18\110\64\223\242\158\232\190\137\1\145\129\18\58\231\207\151\0\120\243\37\228\149\50\249\237\0\245\226\176\174\26\141\145\48\100\172\163\92\32\141\99\176\60\67\222\171\88\136\247\27\140\145\26\111\229\247\131\4\194\131\17\122\48\196\218\38\44\217\200\182\26\232\81\143\211\254\61\65\51\166\66\162\31\28\210\38\23\40\204\62\31\196\207\56",3583032213,3693634131} or {"\84\39\113\29\161\15\78\226\126\186\35\161\148\62\74\195\101\194\63\217\180\4\30\34\125\149\39\134\194\133\17\91\216\99\98\15\185\29\161\91\197\159\138\136\84\85\121\32\110\7\6\61\246\100\95\174\31\42\64\73\244\246\227\119\126\81\27\147\197\192\236\156\83\172\102\163\45\99\137\110\49\212\226\161\244\37\0\2\146\173\61\129\212\198\53\22\178\46\63\8\191\244\185\253\1\54\117\253\71\16\152\83\225\225\22\227\246\21\250\178\32\58\174\59\16\6\230\32\98\210\194\118\61\125\71\31\138\148\217\211\254\245\220\219\182\108\131\18\156\59\223\104\247\239\36\122\225\56\4\56\147\180\64\14\90\59\174\15\147\196\204\167\72\136\181\98\89\126\138\192\116\42\81\20\202\99\57\211\146\7\138\236\125\112\170\230\233\81\166\79\12\80\159\101\9\248\160\160\131\158\96\212\168\106\53\21\154\146\78\243\8\67\144\200\53\222\218\122\30\162\102\189\103\120\20\255\105\246\141\196\171\23\235\29\25\242\41\4\120\226\57\53\218\201\2\40\51\92\60\124\43\117\211\56\98\2\11\115\161\107\168\240\125\244\110\234\2\96\205\250\80\158\147\233\4\25\25\192\128\233\82\77\85\22\225\44\228\10\98\185\117\84\165\190\106",1386889981,3418055778}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
