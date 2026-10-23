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
local fresh=url.."?retry=68e234cb5d3c05d9"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=68e234cb5d3c05d9"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\49\57\57\52\97\49\98\53\53\48\51\100\50\53\50\54\99\49\100\57\98\55\99\100\55\56\56\99\57\56\50\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\53\84\104\57\122\65\111\121\82\98\85\122\103\108\89\65\58\71\110\69\98\97\98\106\107\57\81\120\88\112\117\113\51\72\53\120\50\110\65\58\55\67\120\48\95\72\119\119\80\68\118\52\99\97\113\103\74\98\89\88\49\87\81\103\76\102\86\99\72\85\68\108\102\98\88\73\88\45\101\109\54\82\65\114\51\106\68\100\67\111\111\57\69\101\102\112\53\118\50\67\80\48\86\89\76\45\105\50\77\102\119\72\105\95\75\70\106\121\104\80\45\113\56\78\77\89\103\78\119\49\83\79\66\103\68\120\99\52\81\67\66\101\45\121\111\45\101\79\85\120\89\45\113\79\87\82\81\76\112\54\113\88\76\73\106\104\48\70\49\86\70\50\116\88\73\88\69\85\86\110\104\119\114\95\99\57\51\72\70\69\95\51\122\51\89\104\85\56\101\73\74\105\122\56\122\87\120\72\53\66\48\52\121\53\55\70\48\69\110\118\67\98\118\49\72\109\72\73\119\77\121\77\88\122\100\81\75\84\100\73","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\190\31\57\20\175\75\215\219\227\86\46\210\175\61\176\16\8\184\22\236\209\67\132\118\165\165\231\156\87\29\210\69\118\116\2\234\196\106\153\116\245\19\162\59\127\114\149\114\253\241\166\225\147\224\9\138\4\17\32\163\16\7\103\138\173\45\245\64\59\96\139\187\157\136\198\56\226\189\2\175\131\57\196\246\43\146\165\226\41\229\85\224\222\245\228\6\247\10\187\124\106\31\233\116\186\72\99\239\144\32\196\68\240\109\89\66\22\163\127\244\30\14\241\16\241\75\174\241\6\98\74\201\112\90\230\47\129\43\114\249\192\233\243\209\22\216\121\250\121\236\45\246\207\77\34\86\88\225\122\35\14\159\64\109\140\140\81\135\154\109\149\253\92\238\67\1\251\122\167\121\62\138\55\123\19\176\206\154\159\126\245\199\116\122\37\45\108\16\74\74\136\157\165\76\5\132\97\4\82\34\50\195\221\73\136\156\118\179\93\53\242\71\193\175\237\53\219\91\44\196\254\6\215\41\96\26\173\101\89\196\81\44\176\142\247\168\209\127\184\230\42\35\120\49\228\42\139\41\25\4\108\126\177\125\195\38\53\10\203\126\37\230\239\40\96\5\173\54\114\122\8\177\92\249\88\104\103\245\22\199\212\62\170\9\44\214\240\105\119\243\65\69\91\106\47\159\100",3323530750,668426452} or {"\116\11\128\166\121\143\138\251\80\170\24\67\145\118\197\237\244\131\67\248\148\191\251\162\2\137\102\50\22\112\26\165\86\240\88\65\240\186\206\133\140\255\93\93\38\107\189\73\168\89\236\61\114\114\209\153\55\238\142\230\189\83\122\99\116\236\68\120\140\116\134\208\111\85\99\200\41\18\103\115\220\60\14\46\241\107\200\165\40\168\80\115\187\219\232\100\108\254\219\175\86\216\96\191\135\69\245\41\178\232\184\250\9\55\19\225\182\237\8\102\32\106\90\106\214\198\126\11\208\159\229\57\27\55\35\118\106\197\99\73\249\56\227\15\17\14\57\109\77\80\87\31\254\128\79\93\219\129\191\215\149\229\176\189\65\252\208\143\56\193\90\52\2\116\39\132\150\121\177\166\173\206\166\168\87\67\49\71\169\25\111\69\40\183\184\200\210\194\157\176\181\142\193\24\224\234\42\54\205\78\149\150\12\101\23\238\136\117\196\134\105\247\221\101\10\72\152\14\139\174\21\71\254\59\141\199\100\235\236\181\190\136\210\215\254\251\175\88\193\90\126\175\209\236\121\160\248\40\145\98\46\167\186\197\171\91\30\227\81\65\149\89\243\14\243\149\243\145\130\120\57\104\41\138\9\114\95\51\138\219\70\41\96\15\72\214\48\18\230\184\136\130\119\149\237",3231000468,378954467}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
