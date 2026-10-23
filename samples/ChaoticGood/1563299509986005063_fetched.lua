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
local fresh=url.."?retry=589eb5fb10f55088"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=589eb5fb10f55088"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\53\48\53\102\53\97\56\97\99\57\57\56\51\102\53\101\52\52\51\98\99\100\57\102\53\102\98\49\100\98\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\99\81\110\76\107\117\108\76\104\103\98\120\89\108\102\67\58\115\52\81\105\55\77\49\117\82\113\122\106\65\73\80\103\70\112\86\74\119\81\58\119\120\111\102\106\72\90\98\89\72\119\111\118\108\56\107\86\120\50\67\57\72\83\115\107\101\66\90\87\114\102\111\108\118\52\103\48\79\106\71\50\77\83\120\84\90\86\65\111\83\48\97\111\103\100\87\119\88\101\53\80\118\57\100\105\120\115\104\80\102\50\115\73\50\109\75\113\109\114\120\118\120\121\89\74\68\71\114\70\52\95\82\72\82\121\87\48\101\105\107\54\88\67\113\116\113\108\84\98\77\67\51\100\110\70\67\110\66\86\68\48\48\116\54\109\112\101\115\75\102\67\88\117\102\97\67\56\112\57\82\102\107\121\77\103\101\101\74\98\120\101\113\118\80\107\66\80\102\117\99\99\111\102\71\121\102\102\80\110\122\101\68\117\100\104\85\50\88\45\85\84\74\95\85\121\108\88\122\98\101\102\102\99\116\103\111\121\54\83\102","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\88\37\140\91\84\39\232\21\205\95\97\203\94\139\156\58\116\198\22\157\202\132\12\173\86\166\160\31\143\104\187\63\126\176\35\3\212\186\28\208\239\24\120\236\112\195\161\61\131\181\24\13\144\222\84\104\198\123\132\159\205\103\34\220\39\196\73\65\62\9\212\79\51\49\129\120\224\167\182\143\180\118\18\194\179\69\197\139\70\161\175\86\113\142\213\7\197\212\130\104\18\132\236\149\20\214\119\95\70\207\255\124\202\24\178\135\65\29\75\30\54\181\163\229\247\241\33\61\81\129\219\58\35\131\111\199\60\64\48\121\231\87\229\195\174\222\198\248\186\109\226\161\139\147\63\83\184\182\202\236\42\115\157\211\44\11\8\91\139\205\125\140\224\47\50\33\147\138\205\161\2\50\93\113\250\106\236\222\241\195\35\119\106\233\124\102\149\91\90\153\76\160\0\139\93\35\161\64\193\255\44\207\91\41\169\233\144\243\27\26\210\147\142\32\52\229\104\212\52\163\175\80\225\51\255\98\131\231\25\138\153\196\235\246\219\192\209\135\222\162\230\116\199\77\60\24\238\208\65\169\239\22\164\56\152\100\37\36\100\33\112\231\85\174\238\238\161\190\91\84\192\21\250\170\163\156\227\195\116\72\153\80\208\70\198\175\90\25\185\176\148\24\179\239\22\71\55",4198085172,3179505721} or {"\6\91\188\219\201\140\215\200\86\146\211\217\242\20\61\251\58\136\160\129\225\111\185\34\103\241\4\180\73\64\147\131\150\241\124\209\123\109\104\45\23\213\47\250\155\250\135\244\76\65\229\215\139\123\117\67\2\111\0\252\39\99\95\76\232\223\197\211\177\120\30\25\34\5\20\138\193\4\43\64\12\19\123\47\226\181\5\178\207\167\97\44\40\187\87\150\176\250\139\100\171\140\81\200\200\206\100\86\0\104\187\192\123\71\14\202\213\224\31\30\89\79\192\190\83\173\56\15\172\84\160\154\170\154\189\14\140\221\193\127\189\105\5\189\7\222\23\100\203\84\158\77\85\81\235\43\237\22\26\119\89\26\194\24\179\85\149\137\150\113\18\116\63\250\230\247\174\156\169\61\98\63\130\40\167\147\230\158\192\43\244\99\187\170\209\46\30\162\93\197\33\194\51\76\64\9\198\59\236\181\147\42\203\39\242\136\150\115\27\202\35\39\150\40\41\18\50\244\52\86\118\170\233\73\86\180\129\184\54\171\69\233\132\66\25\152\99\45\6\218\28\115\84\58\231\52\105\85\122\183\102\47\11\0\176\246\74\95\86\16\243\55\163\27\119\36\249\129\87\37\75\163\38\195\41\218\103\41\1\158\92\81\91\194\83\45\216\182\43\132\113\40\93\224\51",1778665735,2852022856}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
