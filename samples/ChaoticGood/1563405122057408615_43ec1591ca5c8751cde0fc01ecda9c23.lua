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
local fresh=url.."?retry=ed89782422a0a048"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=ed89782422a0a048"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\52\51\101\99\49\53\57\49\99\97\53\99\56\55\53\49\99\100\101\48\102\99\48\49\101\99\100\97\57\99\50\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\85\112\45\69\107\81\85\106\105\95\52\66\52\97\53\84\58\83\69\111\107\115\68\71\99\118\98\113\95\54\73\99\98\76\104\77\75\121\65\58\52\54\81\101\85\85\100\74\106\45\48\102\74\80\107\118\104\51\51\89\84\110\113\78\103\121\70\101\81\82\66\104\48\113\48\76\78\120\90\69\67\88\75\108\54\74\118\83\97\56\69\116\69\118\67\113\113\67\49\102\87\77\78\49\55\121\52\121\99\75\66\107\98\53\87\48\107\101\48\111\74\49\115\118\115\79\50\122\100\52\81\69\80\90\102\99\90\97\86\68\70\86\54\103\68\52\49\81\68\105\115\122\70\48\68\79\53\69\105\66\66\117\104\109\73\114\122\77\107\117\71\77\97\74\103\67\112\71\56\103\105\56\73\117\107\72\50\90\120\122\112\51\74\84\67\65\67\109\68\104\49\107\67\66\99\90\119\107\54\87\52\100\74\98\84\65\109\89\50\109\108\118\51\105\98\84\113\85\74\114\88\117\73\97\73\107\53\73\115\102","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\166\87\182\74\41\224\58\107\30\19\117\78\118\225\186\106\50\64\185\28\0\131\16\33\186\10\254\119\79\199\166\212\14\75\83\176\45\27\143\43\252\139\25\59\22\196\93\215\190\119\107\73\46\62\171\88\179\134\54\30\135\193\125\0\237\180\130\100\16\207\23\96\215\199\217\56\129\116\172\9\39\235\68\37\142\130\7\243\145\110\235\134\112\32\96\229\117\113\97\217\47\99\255\110\24\152\18\76\228\87\242\191\19\20\98\253\131\220\23\80\81\174\75\200\33\177\185\50\182\100\221\167\200\9\238\226\119\175\227\160\51\186\7\4\180\149\7\102\165\237\247\35\184\72\231\6\101\30\112\17\58\79\164\180\112\139\180\221\137\157\174\5\71\255\216\65\231\127\232\232\194\180\27\133\76\56\1\132\119\162\132\92\161\147\147\10\93\143\240\178\248\22\127\96\220\207\140\44\149\207\194\138\160\112\178\183\54\55\250\105\102\244\41\242\139\194\2\39\184\149\157\177\252\70\47\113\247\14\131\78\49\1\174\241\129\64\23\161\45\129\220\45\110\158\156\252\45\183\125\9\195\225\88\149\94\196\163\117\237\7\17\65\36\130\252\25\71\175\105\120\116\173\184\253\162\107\57\77\15\139\64\231\191\210\215\77\234\214\71\70\111\217\244\17\234\115\254",939846061,1806590380} or {"\4\72\132\167\201\166\234\188\239\146\230\38\192\41\143\49\151\143\199\164\48\116\13\139\91\216\27\55\83\17\180\245\93\242\90\74\33\233\73\241\253\25\29\49\131\37\85\18\16\10\29\44\249\189\45\19\70\197\94\36\153\130\200\55\1\1\230\148\44\212\105\55\12\140\60\128\87\156\245\146\143\169\70\47\127\122\63\124\91\187\33\156\246\169\174\142\91\121\95\206\49\73\167\231\47\7\240\255\87\205\201\74\138\124\89\30\62\127\202\61\96\137\106\135\91\86\36\113\8\95\136\52\19\117\177\11\55\190\80\100\228\17\23\148\93\46\122\232\179\163\109\175\145\138\134\94\93\220\206\35\93\27\219\92\173\93\215\87\108\227\185\195\196\140\65\130\57\138\167\219\61\49\109\207\77\114\40\23\101\181\19\73\115\4\144\173\8\210\114\228\187\245\243\158\196\176\49\104\213\135\16\239\132\216\105\68\77\176\44\205\158\3\117\135\133\109\16\21\212\133\174\165\130\252\250\141\224\66\54\221\155\0\62\50\23\92\176\47\2\177\52\165\42\159\195\105\63\233\61\209\81\124\195\235\227\177\59\20\160\67\234\149\54\51\221\251\65\137\15\166\104\150\119\11\102\130\77\54\191\79\15\94\254\27\13\234\221\179\147\230\252\27\65\138\48",3182507354,1488675771}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
