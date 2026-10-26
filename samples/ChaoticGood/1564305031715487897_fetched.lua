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
local fresh=url.."?retry=bfca900fc04aec62"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=bfca900fc04aec62"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\114\57\56\51\52\113\75\73\115\118\117\101\75\83\104\97\58\121\86\120\112\89\68\66\50\76\120\68\105\109\116\48\119\89\104\45\105\53\119\58\76\77\121\114\48\55\100\97\67\120\105\90\65\45\111\57\81\72\77\70\104\80\86\115\87\110\87\102\69\88\85\90\101\112\115\95\111\50\84\110\112\55\95\68\121\70\77\55\116\84\71\75\97\89\114\115\85\100\115\116\110\66\116\116\95\45\114\70\69\110\112\65\118\84\51\76\113\78\57\104\90\116\118\49\102\48\118\89\109\66\76\113\90\81\110\76\114\55\86\51\68\106\104\104\88\54\117\55\100\122\100\90\85\99\106\57\78\67\120\65\107\57\81\117\69\74\78\74\121\119\90\118\102\114\72\109\121\72\99\82\52\48\53\78\121\114\45\95\82\83\69\122\99\118\74\105\95\101\117\120\84\99\78\73\53\101\121\117\95\65\97\115\75\109\90\65\85\116\111\52\71\121\100\51\74\76\100\45\115\74\99\73\69\69\99\113\75\75\72\102","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\68\176\160\148\231\34\243\105\139\67\123\114\68\16\129\219\103\229\12\233\131\12\108\92\136\0\16\184\22\42\126\177\22\115\182\46\224\44\165\97\60\213\64\209\73\5\24\119\204\158\14\54\79\9\40\186\32\188\2\115\86\102\153\253\144\135\207\244\233\160\240\83\239\248\5\92\12\174\114\53\196\168\36\224\18\19\161\39\157\215\210\179\195\65\78\199\227\107\89\217\29\48\213\23\198\193\255\87\42\243\23\238\138\96\196\154\230\75\91\253\255\224\129\19\160\249\128\217\239\80\147\90\219\110\128\96\94\150\207\71\16\165\161\210\17\221\160\97\119\210\199\3\85\79\47\5\237\125\99\242\27\203\56\155\40\55\128\113\34\111\139\212\29\245\236\70\67\51\59\173\103\10\253\252\255\245\18\9\246\112\49\0\220\27\122\54\175\250\101\177\133\157\137\49\140\174\60\221\18\97\142\243\111\180\115\187\111\24\38\29\237\218\217\216\2\75\44\129\151\215\89\120\117\226\53\99\107\226\162\32\216\182\119\120\94\179\237\90\138\165\38\227\12\129\129\72\35\186\112\112\47\134\111\185\17\175\10\56\160\237\187\164\87\97\166\68\8\131\107\64\178\196\139\240\56\227\70\31\205\215\168\236\188\252\247\156\246\242\28\114\121\156\99\211\51\242\51",3710595889,3183305885} or {"\222\173\44\124\159\23\100\0\112\208\74\175\132\129\131\29\105\220\103\175\39\69\21\204\142\165\149\107\83\0\90\186\181\71\105\197\20\235\188\23\137\96\9\82\111\90\188\254\65\64\203\210\130\213\143\201\20\9\28\11\232\254\189\219\64\64\84\62\162\34\134\169\44\72\139\200\141\219\13\139\111\12\65\255\82\24\177\74\220\42\56\233\177\180\231\163\222\140\217\137\72\11\230\29\4\123\117\47\186\77\198\55\95\131\5\214\106\62\237\76\131\96\123\100\30\56\15\93\150\222\107\226\147\84\237\10\149\168\55\110\231\33\15\228\40\175\14\196\94\159\54\159\208\74\83\165\7\185\209\245\226\28\239\236\183\162\237\197\180\215\23\153\203\18\68\158\20\222\62\201\7\205\210\213\211\56\192\231\133\187\147\166\228\239\98\40\90\251\122\181\80\198\240\47\220\60\37\175\252\32\87\157\168\58\197\155\173\102\192\170\174\79\37\216\219\81\249\1\178\130\208\168\231\240\152\158\162\184\91\182\25\109\146\4\96\236\81\215\49\105\38\223\141\228\61\151\103\236\177\159\22\152\20\155\185\200\218\45\161\36\170\7\233\233\118\106\180\222\221\202\255\147\158\156\182\114\23\191\170\174\122\136\11\102\14\198\185\126\226\198\223\110\24\199\52",462587353,2880988844}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
