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
local fresh=url.."?retry=0b1d33e8a49de594"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=0b1d33e8a49de594"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\102\102\102\54\55\49\49\52\101\50\49\100\49\53\99\55\98\52\53\101\102\98\99\100\97\52\52\97\97\55\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\77\102\117\95\72\87\56\118\49\49\97\115\70\119\77\65\58\69\101\78\109\81\113\118\117\104\79\86\100\79\108\74\57\87\78\103\57\97\103\58\78\113\73\83\75\65\81\79\112\75\80\87\102\80\121\98\110\99\81\82\69\102\88\100\118\110\53\102\48\52\77\115\70\55\77\109\80\109\78\75\101\104\54\74\68\45\114\73\117\119\74\105\87\118\111\71\108\89\72\65\114\57\85\80\74\82\81\116\82\68\69\116\87\101\86\98\45\45\69\73\48\67\82\112\51\70\76\86\116\87\68\48\105\101\122\88\102\90\49\110\88\68\65\75\66\107\71\110\70\110\95\75\112\95\115\115\72\115\121\103\49\103\95\120\105\112\76\66\113\100\98\49\53\72\68\76\104\90\112\88\99\102\85\89\114\97\57\99\57\114\121\87\115\99\97\86\112\90\95\85\112\105\109\73\86\73\52\95\85\83\95\102\87\118\73\95\114\106\67\87\90\48\115\119\100\75\79\101\121\56\103\79\49\85\49\83\77\118\83\69","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\144\20\213\239\84\253\25\158\80\161\27\200\157\191\191\93\73\223\110\209\152\65\160\202\202\110\76\79\222\55\100\52\20\35\131\45\163\122\82\210\249\63\245\57\204\148\202\222\165\58\129\3\76\105\124\49\200\210\244\147\214\219\232\143\218\156\199\216\82\24\63\64\224\126\139\189\216\112\59\123\161\197\28\220\152\135\129\77\101\164\115\171\87\70\145\106\188\151\228\50\216\215\246\222\193\127\55\75\52\255\115\76\12\35\155\233\104\236\232\65\205\144\246\72\205\78\123\181\155\110\206\28\71\75\203\71\180\22\144\250\165\237\3\98\14\184\8\42\127\36\15\68\67\53\67\249\59\54\135\25\222\208\75\84\65\218\230\114\149\73\170\98\220\128\80\181\132\70\215\33\181\235\205\32\36\69\215\161\146\180\40\112\45\57\164\184\167\73\152\189\116\70\160\68\38\142\195\101\134\146\35\242\161\166\141\232\19\159\46\49\149\70\56\6\60\207\97\29\25\50\141\145\73\102\206\90\124\255\154\71\35\145\211\69\153\91\96\131\227\149\59\106\157\30\85\218\180\192\224\146\8\157\254\174\164\106\204\39\50\28\208\217\119\47\34\85\194\244\13\92\219\128\186\22\81\111\41\154\33\16\22\122\26\13\205\246\123\238\65\120\185\217\138\202\91\179\169",443641129,3470615598} or {"\92\27\46\246\137\201\198\187\48\91\115\186\103\212\254\144\103\116\59\91\215\146\177\81\94\105\49\236\71\29\0\81\153\208\115\72\106\220\240\164\147\91\187\234\59\209\55\97\214\131\24\133\231\30\4\53\31\158\72\237\65\93\235\251\181\64\61\83\45\215\91\178\25\100\184\136\122\68\205\59\241\53\80\95\158\62\253\2\36\57\175\66\241\175\199\173\243\241\83\32\35\25\54\211\213\119\68\104\37\73\238\58\144\234\153\37\244\154\136\187\202\115\52\179\70\179\227\186\21\171\209\177\225\176\227\20\249\126\122\235\189\125\52\18\215\18\81\43\207\173\4\233\25\169\57\227\106\83\67\185\227\4\226\228\85\229\254\21\122\9\95\215\184\117\9\94\2\212\193\105\195\3\240\0\224\198\87\2\80\17\185\130\183\245\157\254\124\120\164\163\148\207\34\165\31\118\49\92\139\83\169\108\229\52\80\241\158\81\214\200\243\143\99\130\135\226\102\82\157\212\76\113\46\25\20\136\221\236\155\243\255\45\145\29\41\39\216\47\137\132\186\78\142\144\104\120\81\196\142\71\26\209\248\149\117\60\201\199\133\129\174\146\46\50\45\214\11\176\101\53\23\116\13\8\124\56\240\79\196\0\86\93\111\55\100\182\227\52\189\246\99\86\45\42\242",1406473255,3145098813}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
