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
local fresh=url.."?retry=03f4184042497cb4"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=03f4184042497cb4"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\56\100\56\53\48\55\101\101\101\52\98\57\99\101\50\98\97\57\49\101\100\98\48\53\101\57\101\102\54\48\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\101\81\69\122\99\77\86\67\121\109\89\100\122\84\79\56\58\107\82\73\56\112\88\74\57\49\53\73\101\78\100\104\74\69\65\118\103\105\103\58\77\109\101\55\113\81\48\78\67\75\103\68\103\97\118\73\98\104\111\67\114\85\55\51\116\68\67\109\104\73\109\89\82\51\109\99\57\71\56\65\82\109\104\75\73\65\99\110\111\87\115\83\117\56\79\83\106\110\48\76\88\104\71\115\113\53\80\116\50\74\74\78\119\121\51\84\114\90\101\99\81\86\67\110\121\51\84\110\70\78\75\55\81\50\75\119\83\83\73\75\69\85\115\103\106\99\74\74\102\67\48\95\100\89\105\116\52\72\116\73\118\108\76\118\122\76\107\107\77\116\52\51\67\104\72\119\98\122\49\57\102\102\106\119\119\87\48\82\52\98\106\65\95\65\70\52\75\76\56\95\99\121\70\81\53\72\52\50\116\55\121\82\75\70\74\118\84\90\108\54\106\55\53\55\121\107\73\68\69\101\103\98\112\100\90\82\116\77\111\113","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\134\102\11\250\211\180\146\73\96\160\195\180\132\122\74\174\42\215\207\90\78\11\130\9\160\1\23\148\229\115\3\140\107\11\215\199\190\91\228\47\78\15\228\41\39\144\90\212\169\90\9\102\219\184\157\105\44\50\220\115\63\75\90\36\37\19\146\50\236\238\159\139\85\29\66\69\7\253\70\52\193\222\113\239\15\67\100\1\143\204\103\156\206\143\109\178\167\179\84\122\175\23\24\158\143\4\3\98\160\146\232\151\233\85\120\219\240\6\151\107\181\229\20\27\248\187\219\245\153\217\134\104\55\3\157\159\57\254\37\250\100\176\67\222\212\45\208\214\82\31\124\141\41\59\229\186\122\100\177\147\24\52\135\229\29\11\238\226\226\136\195\62\146\77\115\76\218\103\230\243\231\98\224\5\57\125\142\160\178\253\16\59\201\156\74\75\85\119\147\0\15\126\63\198\161\91\166\201\147\214\176\17\70\55\251\234\107\242\89\124\104\204\227\98\19\170\184\131\43\135\140\246\76\188\57\146\211\112\52\110\74\24\26\63\146\130\181\216\200\234\30\152\205\215\130\64\5\130\41\32\143\149\9\172\82\148\106\83\74\229\145\100\32\151\41\106\253\25\125\31\51\122\132\109\135\139\192\180\92\182\117\133\104\114\107\117\162\167\79\146\192\174\190\116\23\118\21",3524444189,2114937595} or {"\187\45\50\217\188\133\43\38\61\93\191\11\49\40\122\189\122\101\225\240\150\236\154\165\73\33\200\169\236\163\158\57\56\179\207\82\227\53\67\159\62\44\103\161\170\159\65\230\172\32\242\81\241\171\253\2\22\253\177\235\26\95\41\25\72\114\96\178\60\183\229\81\95\108\131\80\153\235\94\170\150\39\251\209\158\130\218\76\64\48\180\109\175\103\121\107\43\43\130\10\91\220\126\119\191\61\41\181\37\170\221\211\0\142\113\185\209\98\197\252\63\231\102\167\122\56\18\163\193\60\53\85\227\23\128\69\131\245\124\60\171\113\238\246\35\34\85\249\30\136\242\76\207\202\118\16\71\52\44\113\229\103\31\168\53\162\90\101\94\173\145\105\215\207\160\154\119\217\51\209\147\96\14\186\212\157\245\113\60\239\205\82\223\13\0\161\93\14\147\83\12\214\89\251\181\34\59\90\228\63\48\196\4\117\40\142\64\204\51\168\121\103\127\26\78\110\59\76\221\49\197\254\163\209\2\95\51\28\142\234\193\180\20\97\26\22\82\11\133\31\30\5\37\207\200\67\172\233\131\150\55\120\179\145\106\250\73\27\16\86\0\15\207\147\115\17\24\189\116\113\24\76\142\233\215\143\24\77\184\50\6\57\177\234\64\82\188\185\97\186\134\215\209\42\253",2177013528,1787847946}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
