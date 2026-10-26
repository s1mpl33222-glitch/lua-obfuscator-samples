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
local fresh=url.."?retry=f2fbc8c7fdda0f10"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=f2fbc8c7fdda0f10"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\97\108\101\81\101\108\101\113\86\52\116\108\53\56\74\110\58\109\100\111\83\82\120\65\74\99\81\48\111\53\117\70\53\50\102\109\88\45\103\58\118\105\71\55\106\74\80\72\55\95\102\105\122\85\79\99\83\70\68\48\76\74\119\95\84\66\102\50\66\110\105\87\49\104\95\88\108\109\72\78\116\45\99\79\76\112\97\108\79\115\86\70\88\106\77\72\110\103\75\112\52\83\50\79\72\45\101\56\110\107\86\90\102\73\81\57\52\78\99\102\79\79\87\77\117\105\117\52\103\57\100\82\88\74\55\89\111\49\118\113\87\108\68\104\67\108\103\75\68\86\82\67\116\112\119\82\81\53\49\51\65\84\57\52\100\86\112\83\110\45\90\57\49\121\50\55\112\97\55\119\86\101\105\88\71\86\73\86\115\110\69\51\86\97\106\51\118\104\67\117\115\72\106\85\98\115\122\111\48\99\109\69\71\98\109\100\89\105\107\80\68\95\108\68\102\78\45\115\90\48\69\99\105\67\103\57\116\74\107\103","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\163\54\70\108\140\15\197\153\20\218\83\102\30\129\144\194\54\32\131\14\255\2\154\46\107\239\226\245\60\15\214\243\141\208\85\70\216\185\58\56\175\84\126\28\216\223\168\140\180\186\69\171\127\5\160\88\96\59\135\63\52\176\62\109\155\160\176\230\23\144\183\17\101\159\238\42\156\42\111\116\112\207\177\167\158\87\71\255\254\196\175\50\40\48\10\229\129\175\173\82\109\248\136\236\38\133\130\0\4\170\41\82\177\1\218\247\137\47\210\50\228\125\103\169\215\162\161\142\67\20\207\162\35\242\40\254\98\192\137\219\255\11\97\182\188\23\88\187\232\11\127\99\203\127\248\49\235\90\68\253\24\3\205\230\135\40\234\130\70\191\103\243\185\54\235\184\243\113\146\94\206\177\10\3\76\121\233\96\75\20\71\238\185\79\251\120\174\67\98\74\82\124\48\231\21\177\244\135\22\192\234\26\161\50\247\97\15\145\110\24\17\158\203\95\12\37\202\111\224\169\150\152\220\69\240\103\204\54\40\211\12\216\249\150\206\79\105\101\253\29\170\22\244\102\95\2\38\120\202\234\139\152\57\24\110\214\13\4\158\249\20\156\116\63\221\190\81\148\98\161\117\242\124\207\161\28\24\95\133\110\10\115\195\4\122\176\93\20\96\216\172\198\139\85\91\231\222",2870704276,2676777553} or {"\63\59\96\81\93\117\36\69\121\251\197\133\144\73\98\28\240\5\111\171\132\238\158\128\90\206\133\67\55\102\159\11\6\85\134\17\74\209\115\200\45\34\254\191\81\103\202\238\94\86\111\243\241\69\149\51\11\35\94\253\17\159\50\68\99\24\217\101\148\23\226\136\54\221\75\130\35\12\40\58\250\137\48\200\75\230\162\47\5\155\122\82\34\231\137\237\169\170\139\62\152\111\213\255\40\255\6\191\86\243\186\129\101\102\207\159\241\73\121\221\130\182\82\63\255\48\167\46\115\46\129\227\209\178\116\254\99\187\171\180\107\181\109\41\49\153\106\163\58\127\216\236\223\81\16\9\184\215\109\105\185\55\74\13\181\113\65\247\224\144\241\200\71\216\5\57\2\73\91\253\46\160\127\190\60\228\137\0\106\24\1\189\28\28\162\141\202\190\118\254\43\254\85\76\135\100\107\89\125\167\66\94\117\236\130\91\245\171\113\252\142\224\50\129\201\202\4\128\240\13\253\220\39\147\93\68\180\46\12\219\81\57\16\8\247\241\59\131\100\41\141\104\113\129\27\99\35\185\216\52\151\246\194\224\200\154\148\158\170\15\135\51\70\23\131\221\214\207\198\204\152\248\115\50\184\26\168\35\198\121\30\64\230\187\136\120\92\118\12\16\150\201\213\202\165",1617592976,2374984800}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
