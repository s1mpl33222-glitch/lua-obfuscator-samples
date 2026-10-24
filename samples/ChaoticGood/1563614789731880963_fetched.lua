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
local fresh=url.."?retry=e57837fbc5f31d2b"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e57837fbc5f31d2b"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\102\48\56\51\51\102\50\98\101\56\56\99\99\97\57\48\57\50\100\98\100\101\101\54\55\97\99\57\100\57\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\110\100\104\116\66\68\95\66\107\87\110\50\99\115\110\71\58\66\113\51\71\73\70\85\68\97\97\118\54\84\81\54\77\95\115\99\50\73\65\58\107\97\103\65\72\74\112\88\106\104\110\65\81\120\82\67\90\79\114\115\73\71\50\75\87\86\69\82\108\79\115\69\115\66\108\51\115\45\49\114\111\118\86\116\73\100\118\56\98\95\45\74\116\65\90\95\98\51\84\102\54\102\119\119\53\65\114\51\97\49\106\111\118\122\105\66\45\109\116\68\51\86\67\88\48\98\116\77\107\107\76\114\75\99\114\114\75\73\55\72\83\95\82\102\69\77\99\90\49\98\54\84\107\85\118\111\101\119\114\45\68\106\122\50\100\122\100\76\53\87\53\89\117\69\50\104\57\75\105\50\115\67\49\53\102\77\119\117\48\103\119\55\98\109\99\95\106\48\120\95\70\84\66\87\109\66\52\97\73\106\65\78\49\113\50\104\70\74\122\111\89\69\117\98\68\76\103\69\119\103\75\56\86\88\122\114\95\102\112\110","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\74\81\139\123\188\119\127\90\215\185\61\200\250\249\95\192\35\128\198\131\111\66\222\180\175\52\36\157\42\0\131\133\202\15\150\161\236\226\147\59\189\152\158\185\112\50\184\220\221\156\30\34\33\63\46\28\67\90\196\160\29\249\134\99\52\145\170\154\70\111\125\178\126\1\214\145\139\94\162\52\248\70\82\190\130\130\135\58\23\60\170\56\227\6\152\0\12\92\187\162\86\72\8\27\30\246\196\153\50\153\136\5\138\143\165\177\203\181\182\252\145\133\48\130\50\118\68\158\230\204\165\149\198\42\103\191\113\213\223\65\39\74\41\220\0\128\58\41\159\212\53\78\239\132\116\51\4\232\64\181\18\75\74\60\172\207\145\18\196\51\251\231\191\197\145\158\58\186\54\232\255\200\1\150\125\97\37\59\236\220\67\68\236\153\177\202\84\32\119\231\18\108\44\124\181\31\187\152\142\169\31\238\193\215\46\8\142\56\174\204\44\237\0\163\203\233\99\28\234\160\190\55\255\205\102\118\46\220\10\163\144\176\160\48\153\20\181\7\212\203\81\153\242\24\25\87\151\127\189\107\12\136\81\182\38\11\224\224\159\28\110\72\224\54\104\201\108\207\59\136\175\90\191\55\111\202\39\139\215\237\60\100\177\56\132\153\221\8\109\214\146\75\199\91\7\65\111",978798338,1806787435} or {"\23\205\2\71\69\24\60\75\230\215\244\14\147\62\153\33\245\146\163\216\54\72\144\199\105\147\19\214\132\241\252\164\226\95\25\69\113\228\101\204\225\155\241\141\221\172\108\168\95\129\171\41\215\18\152\183\139\84\195\21\200\87\245\158\45\63\66\98\121\142\97\125\34\124\239\243\164\159\83\183\114\151\205\39\156\80\25\200\54\195\244\21\223\145\10\99\38\91\44\223\222\21\16\65\97\118\72\152\99\118\174\64\133\226\153\235\59\75\185\167\230\233\23\140\231\182\169\253\87\80\5\94\180\213\33\111\56\220\145\220\153\10\177\26\236\224\241\240\248\205\12\172\25\0\6\180\136\197\157\8\147\94\160\217\126\33\216\33\122\162\141\203\149\96\52\127\88\75\223\42\93\199\35\51\40\28\218\37\112\18\174\203\150\178\249\248\225\122\117\55\129\107\173\173\24\242\147\152\30\69\165\110\124\50\241\82\209\156\8\17\69\185\203\217\6\221\54\1\135\240\255\10\191\166\50\233\161\254\3\62\252\3\66\69\173\139\199\146\39\119\197\103\65\219\244\98\56\174\220\18\253\123\30\218\161\181\195\244\104\158\241\11\89\31\236\244\226\143\233\89\183\241\71\24\203\0\120\62\75\3\143\52\149\236\55\167\245\7\195\46\91\156\90\100\147",1697492703,1485071738}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
