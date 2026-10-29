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
local fresh=url.."?retry=7691697056a8486a"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=7691697056a8486a"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\109\106\99\83\51\118\118\103\53\87\103\112\121\88\56\102\58\79\90\57\72\85\74\114\111\49\71\115\95\81\76\114\48\111\118\114\45\104\119\58\110\88\49\56\103\70\51\100\57\89\49\109\98\73\68\80\70\66\97\99\95\113\122\102\71\52\66\95\102\100\48\87\95\121\67\122\103\77\95\114\66\88\65\99\119\55\68\89\68\84\57\117\88\100\80\53\80\71\76\78\50\108\113\115\75\109\69\99\104\77\109\115\117\65\122\119\87\120\69\112\87\98\112\120\89\85\76\82\99\119\122\66\79\71\74\107\111\112\76\74\89\81\81\117\54\45\99\81\84\76\77\49\72\75\100\113\73\65\52\76\73\73\73\98\116\122\73\108\95\115\95\87\76\45\57\54\56\68\83\51\118\121\77\73\90\80\67\49\66\79\48\48\116\108\83\90\77\66\74\90\56\114\65\75\108\66\89\70\84\57\79\121\111\45\88\81\79\55\76\81\72\82\84\121\95\71\108\88\104\95\103\48\56\106\111\117\89\114\106\90","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\18\251\23\118\246\32\213\131\150\198\96\199\28\204\196\91\153\91\46\70\206\242\9\187\9\204\103\13\117\230\47\46\162\181\124\49\142\216\217\214\250\175\151\250\125\191\49\213\131\169\117\170\190\159\223\141\162\4\23\212\190\90\246\169\21\185\254\211\50\143\162\23\46\218\93\48\250\147\186\216\63\251\115\104\41\47\145\133\136\248\67\156\145\20\209\195\147\227\107\242\193\90\252\74\223\236\100\66\87\38\128\135\243\133\155\19\111\226\66\205\129\113\33\132\233\249\38\23\120\166\168\245\168\234\58\186\232\22\151\128\169\46\137\116\123\91\109\229\64\232\242\225\91\246\187\75\57\180\84\56\195\45\139\213\190\76\252\211\175\141\82\222\240\89\127\10\166\170\250\167\97\204\120\79\210\34\229\21\75\25\213\173\200\186\197\226\132\78\155\211\184\213\229\107\94\67\167\109\172\122\124\182\246\227\50\145\204\108\36\27\75\121\249\16\186\168\139\38\53\221\216\30\159\125\161\168\57\145\47\94\159\154\220\31\170\215\96\218\183\187\0\76\140\167\229\238\84\95\70\119\157\15\25\55\18\87\108\102\225\75\228\244\154\51\151\132\39\185\168\149\141\0\189\154\38\113\188\224\163\15\160\10\174\48\195\55\172\145\74\62\53\150\156\136\4\237\112",881306621,4223361552} or {"\245\122\70\157\73\131\52\171\250\186\114\80\61\10\241\29\150\102\171\57\71\144\24\43\248\6\44\206\117\12\44\223\135\71\241\164\197\222\151\247\183\16\21\101\252\124\156\52\65\196\249\79\79\167\163\172\102\60\139\17\0\68\250\81\92\87\44\213\250\206\227\46\59\9\233\133\165\126\217\91\252\198\130\162\101\34\184\17\184\9\234\217\36\124\206\7\160\251\137\82\39\214\207\139\250\195\22\188\225\151\36\194\6\23\8\224\198\0\68\197\210\57\53\90\197\37\83\255\74\233\71\170\39\14\18\38\184\227\57\20\131\128\69\119\224\206\170\11\5\239\91\48\130\53\221\132\6\222\184\125\57\56\62\162\3\18\223\11\176\159\230\8\215\139\124\226\159\108\251\68\119\88\140\77\147\107\186\178\60\138\23\33\21\230\184\71\207\214\13\69\205\170\140\3\111\212\162\30\29\121\24\152\23\177\90\247\142\151\209\235\198\41\143\183\26\99\188\94\121\186\54\146\199\233\105\144\230\208\232\7\199\249\104\246\41\78\157\58\203\190\143\118\63\224\235\44\13\31\217\157\131\28\88\162\196\139\123\71\72\209\119\47\151\245\64\58\235\7\153\218\236\240\205\93\58\113\115\225\249\48\163\187\101\35\161\189\10\35\18\89\206\192\108\48\62",3103797105,3921568799}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
