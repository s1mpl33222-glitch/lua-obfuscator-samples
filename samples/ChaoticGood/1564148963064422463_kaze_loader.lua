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
local fresh=url.."?retry=8b848def42d3adc4"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=8b848def42d3adc4"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\54\100\48\97\55\54\53\51\101\56\48\55\99\54\101\52\56\57\97\54\99\54\52\53\101\57\48\53\98\49\50","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\86\111\99\103\69\109\110\69\78\89\109\110\70\78\74\75\58\49\102\86\45\113\99\112\53\67\74\48\76\85\51\82\52\80\101\81\119\68\119\58\56\118\108\95\104\102\68\100\65\76\54\50\72\54\112\98\82\105\120\95\116\109\67\53\88\65\114\51\121\48\120\120\97\121\118\113\65\106\97\108\107\77\104\50\95\117\77\99\71\67\117\85\98\102\97\110\48\118\55\77\79\118\100\88\103\112\66\95\110\70\68\48\78\67\101\85\77\105\106\53\82\85\97\119\98\78\80\55\65\110\97\86\51\108\89\101\72\56\116\50\72\112\86\110\95\90\98\45\68\103\86\57\100\48\88\49\83\75\80\103\99\111\117\55\88\53\100\49\121\98\119\115\53\52\65\83\50\78\69\115\65\98\107\120\112\103\76\69\67\53\113\107\102\90\57\51\121\113\45\65\104\66\56\108\67\73\51\48\115\97\120\89\86\86\114\68\105\72\109\56\103\97\104\82\120\53\87\97\121\57\80\75\75\117\50\98\110\95\51\95","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\182\97\236\115\4\84\56\94\175\250\152\67\32\231\156\104\165\139\109\37\235\183\248\90\58\246\150\143\99\196\246\236\41\180\206\188\137\218\202\194\43\251\206\233\216\233\190\131\2\91\220\137\240\139\34\227\244\239\80\161\255\90\97\213\121\11\18\80\143\21\205\133\146\181\230\142\235\252\188\86\145\111\47\133\255\19\116\176\49\215\20\60\26\166\80\134\172\228\4\94\103\95\230\110\159\189\27\37\208\226\179\228\99\45\174\234\179\233\186\198\177\98\209\29\226\52\184\207\161\236\68\92\244\205\105\94\65\33\182\28\69\81\134\157\121\103\126\129\210\53\60\19\54\156\125\166\172\10\10\181\190\220\108\134\95\185\20\141\10\204\4\140\110\96\237\116\172\85\111\101\200\10\101\12\112\233\238\173\240\8\106\211\78\35\231\131\201\38\16\125\169\25\253\1\132\24\86\150\4\216\142\220\187\159\243\133\89\90\134\137\255\224\82\16\6\254\65\14\143\239\174\130\44\163\214\246\234\129\171\187\45\23\215\218\228\193\55\72\3\15\158\194\147\154\207\36\100\115\31\148\11\24\218\41\185\116\47\7\246\238\135\240\105\163\15\124\116\33\62\52\60\21\197\165\214\172\226\65\52\220\119\235\189\97\225\63\250\69\104\177\54\230\208\42\63\187\204",379313587,295002500} or {"\133\125\91\126\181\72\241\210\169\238\138\61\74\207\221\236\255\60\242\103\34\31\100\0\97\233\24\230\173\73\12\85\9\200\9\27\247\126\117\101\166\171\233\88\240\96\255\152\29\224\19\174\97\208\224\52\29\194\202\23\187\57\180\75\105\104\227\234\62\150\185\169\235\163\183\160\117\237\2\142\75\126\101\6\62\26\99\21\153\192\215\53\163\92\13\200\159\158\160\216\54\193\145\90\101\234\187\1\24\105\102\91\22\152\125\28\80\58\157\210\181\56\52\254\159\163\150\130\50\223\27\124\69\3\105\89\81\223\250\189\195\103\168\85\58\138\215\104\27\68\45\113\210\160\41\11\154\64\71\19\49\135\47\169\45\77\229\251\40\34\51\45\225\67\33\150\152\226\14\189\200\141\104\29\228\169\130\64\83\96\64\22\111\153\223\31\81\247\101\122\131\234\110\48\61\192\210\209\160\72\240\3\0\234\178\239\35\154\99\62\6\59\115\33\238\26\43\238\3\237\95\156\154\7\15\59\156\165\3\57\216\3\224\104\72\52\124\247\145\129\143\207\199\34\255\187\69\170\162\137\150\211\45\84\23\247\241\170\176\251\90\115\223\201\221\110\229\32\158\99\84\211\82\115\119\30\172\182\54\121\89\161\96\145\140\33\229\214\174\71\127\67\246\95\163",1862084736,12215187}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
