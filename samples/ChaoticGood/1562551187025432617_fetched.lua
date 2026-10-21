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
local fresh=url.."?retry=d0c4866104cc4b61"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=d0c4866104cc4b61"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\105\49\102\83\68\106\88\69\85\78\114\104\50\76\110\56\58\82\86\102\53\107\49\80\116\99\103\111\110\73\53\57\53\97\73\114\110\84\103\58\89\87\118\56\104\107\107\65\73\48\106\121\112\72\97\105\86\89\74\116\115\76\102\100\52\76\57\117\82\116\102\79\49\71\120\98\50\113\103\50\80\121\66\69\120\77\83\75\111\112\71\75\74\49\98\99\65\50\76\122\111\121\71\55\90\89\83\67\76\76\86\122\70\85\102\81\97\117\121\119\115\48\79\79\106\98\70\116\80\107\87\105\48\118\66\50\104\68\56\90\81\83\84\84\89\84\111\101\108\111\102\106\68\72\84\98\75\57\117\80\53\85\52\56\80\106\65\95\95\82\83\55\70\48\57\53\55\77\103\108\71\54\113\109\118\119\90\106\97\75\97\112\73\82\122\48\50\67\68\88\105\100\104\99\72\80\66\107\102\56\103\100\90\75\74\115\49\75\83\51\74\109\101\85\106\75\69\75\52\83\57\97\107\97\48\113\83\52\89\95","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\25\151\60\171\65\10\115\124\47\203\1\63\107\145\40\200\185\164\3\186\1\182\187\166\131\125\174\86\227\31\134\175\220\69\26\230\0\212\253\149\176\216\9\112\172\173\143\96\20\107\100\79\247\233\145\147\225\57\83\26\26\64\17\46\49\49\210\89\199\116\55\206\93\169\253\210\9\181\124\78\213\241\248\180\118\215\111\107\37\211\229\148\39\41\133\224\135\3\27\80\220\44\47\143\2\143\183\146\214\44\109\125\212\157\214\71\207\182\123\239\19\80\153\124\79\232\220\238\59\46\34\188\148\52\176\46\67\14\178\196\255\94\143\131\155\202\15\44\241\87\50\21\177\137\44\104\24\195\110\168\198\91\91\242\89\246\0\147\66\155\86\235\36\32\0\155\175\196\150\229\110\137\182\245\17\35\152\226\156\199\26\60\174\170\179\255\255\37\185\184\239\90\155\46\239\214\140\12\108\121\124\0\203\15\120\219\88\192\239\237\201\255\80\50\21\73\86\78\172\174\235\72\2\152\201\197\109\140\247\65\221\190\64\179\97\242\79\188\241\244\179\159\20\36\197\66\101\82\11\128\28\86\236\184\27\86\157\188\99\112\229\45\116\225\208\32\54\234\181\92\91\204\41\170\19\53\88\247\179\247\54\234\233\105\39\209\128\119\35\249\109\133\211\171\110\196\164",4294571466,3075760554} or {"\74\131\53\56\176\113\14\61\121\195\40\155\113\179\222\40\220\153\30\202\95\24\153\3\85\201\69\185\7\123\77\112\76\3\190\230\222\221\73\157\154\17\44\236\167\176\250\162\133\212\166\140\142\156\18\118\43\30\242\255\102\2\247\247\197\195\79\91\183\42\52\118\188\140\196\129\241\153\140\81\163\236\130\71\25\136\58\30\215\249\127\231\74\61\131\255\107\205\245\9\191\53\215\38\204\231\171\153\169\24\57\68\188\245\89\29\76\124\122\93\82\146\108\220\193\200\155\73\237\182\192\143\215\50\16\125\48\180\174\144\125\91\58\128\187\223\189\136\33\77\199\189\168\80\178\206\208\186\198\28\119\138\208\253\219\120\205\15\247\38\68\91\64\195\20\77\225\222\223\171\3\103\77\122\177\153\44\153\251\94\175\46\96\101\224\34\12\227\107\114\169\199\208\61\175\70\109\204\197\247\1\66\43\236\168\219\165\171\64\60\145\43\156\117\72\220\230\155\124\137\41\3\50\25\4\127\67\199\131\130\65\246\125\253\165\157\140\11\38\57\50\6\181\56\185\49\29\120\92\142\23\166\187\81\87\248\160\15\67\154\32\66\48\20\233\3\172\74\229\117\214\27\236\149\94\208\195\88\62\18\41\79\193\162\130\152\65\137\183\111\235\2\2\41\31",971879047,2773443513}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
