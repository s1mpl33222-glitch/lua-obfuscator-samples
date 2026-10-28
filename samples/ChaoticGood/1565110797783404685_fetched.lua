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
local fresh=url.."?retry=632374b04245cd16"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=632374b04245cd16"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\102\102\102\54\55\49\49\52\101\50\49\100\49\53\99\55\98\52\53\101\102\98\99\100\97\52\52\97\97\55\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\104\98\95\52\50\99\103\51\119\73\114\115\100\106\56\68\58\57\86\81\89\57\109\113\114\100\81\102\74\71\53\77\67\54\76\114\52\48\119\58\55\101\95\55\53\109\72\106\50\98\73\97\98\109\53\108\121\118\84\101\84\102\112\98\115\50\88\95\75\83\56\70\90\112\119\102\85\90\56\56\118\85\104\73\65\121\77\53\77\117\108\49\83\51\66\69\89\118\95\108\106\68\84\104\117\79\101\88\74\85\52\83\85\69\122\105\88\95\68\113\118\101\101\54\50\104\77\112\65\85\82\114\87\67\83\68\99\57\89\49\81\90\90\75\83\73\114\109\65\74\99\84\45\105\49\98\82\120\110\80\97\57\50\97\72\65\112\103\53\55\70\54\105\86\111\120\119\116\71\108\98\118\83\101\111\85\114\108\87\79\114\118\75\95\116\122\107\101\86\106\54\107\83\100\75\87\104\72\101\89\79\50\84\80\116\100\68\102\103\109\52\51\73\80\80\70\81\79\68\121\118\101\98\82\108\120\71\82\49\110","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\170\1\213\233\93\10\156\60\186\114\102\101\126\155\126\251\126\36\159\44\50\203\34\174\185\180\7\103\121\109\34\34\200\214\51\164\58\178\28\6\139\116\110\37\20\137\62\20\7\2\64\127\165\165\116\51\155\190\52\94\55\231\203\4\157\222\208\98\13\114\29\70\220\195\12\168\233\156\255\197\3\92\242\94\230\79\224\59\207\223\59\9\136\72\181\132\124\255\187\124\212\84\139\246\194\71\223\120\174\233\5\107\227\59\94\7\198\57\162\96\94\106\190\96\249\170\73\172\94\91\244\214\95\211\66\42\196\197\200\210\13\240\91\215\98\147\10\35\115\125\22\2\48\75\221\28\74\193\157\223\171\55\37\131\51\169\8\55\116\148\39\180\204\43\73\135\104\77\196\150\163\139\21\65\117\145\251\180\148\59\146\209\178\229\20\110\46\65\225\178\76\185\32\80\255\202\170\255\2\57\119\105\176\70\60\40\242\66\157\138\37\20\158\97\70\43\252\112\38\34\201\184\168\34\249\236\6\77\161\75\70\187\102\119\47\91\65\101\0\30\110\193\152\105\189\128\179\31\67\232\198\107\31\226\219\235\161\10\113\180\169\87\92\238\214\105\116\50\254\32\193\43\35\79\205\94\82\90\130\127\142\53\106\175\138\185\181\77\175\159\8\227\44\161\196\247\98",2464008109,1701340087} or {"\142\5\207\32\93\4\190\2\39\135\211\96\246\218\231\62\221\213\105\241\9\90\161\172\145\193\112\66\255\69\47\228\23\61\21\20\170\109\212\65\118\105\184\82\126\236\1\38\232\202\164\225\189\222\225\162\34\16\189\104\174\58\113\228\87\176\249\114\97\152\135\2\194\35\162\164\230\194\64\210\40\210\1\247\47\3\191\143\50\235\43\160\21\188\180\87\5\168\239\115\23\76\9\19\207\216\124\149\186\221\121\158\152\159\52\133\127\62\74\108\51\104\57\136\17\40\226\184\75\62\123\157\61\64\247\148\254\44\129\61\38\159\33\159\24\109\64\28\37\213\82\219\236\131\4\110\145\182\14\190\224\124\199\62\106\147\13\105\245\245\123\198\78\141\61\80\93\150\225\226\209\201\96\190\2\123\179\35\79\47\42\51\198\45\99\93\145\40\69\158\78\28\251\180\121\222\137\131\130\215\90\153\230\68\121\89\85\148\83\65\181\183\191\7\103\87\201\27\131\226\144\232\242\4\131\140\104\198\183\170\50\237\63\144\166\66\241\68\98\44\202\204\196\97\138\236\105\47\141\158\235\188\183\65\232\227\125\207\102\80\40\171\135\90\185\196\44\240\109\144\65\50\98\133\29\8\49\99\26\213\146\245\150\107\129\233\162\253\213\141\3\75\14\43\193",3430081634,1375823302}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
