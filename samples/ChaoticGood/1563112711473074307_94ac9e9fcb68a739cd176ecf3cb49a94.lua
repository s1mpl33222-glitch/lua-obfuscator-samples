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
local fresh=url.."?retry=962c020650cd557d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=962c020650cd557d"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\57\52\97\99\57\101\57\102\99\98\54\56\97\55\51\57\99\100\49\55\54\101\99\102\51\99\98\52\57\97\57\52","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\80\82\70\87\74\95\97\87\82\119\78\113\78\49\57\45\58\102\73\99\84\76\110\79\86\49\66\53\102\57\76\104\114\121\54\90\50\104\103\58\76\45\53\121\49\97\87\79\100\52\76\67\120\107\71\122\107\109\87\67\49\69\56\122\104\67\81\99\69\78\79\84\49\114\85\54\48\104\74\98\90\102\121\108\106\115\70\111\67\117\110\79\117\65\110\53\54\71\100\57\76\69\73\73\110\73\69\75\55\102\77\65\118\55\48\81\90\80\109\77\76\120\122\95\74\104\70\78\87\72\111\85\114\54\95\54\118\72\49\120\95\113\79\106\75\73\78\70\49\53\52\119\89\86\81\68\50\48\52\71\75\45\56\73\89\68\122\53\110\52\95\115\72\71\45\66\110\102\115\71\67\87\76\95\73\109\108\111\88\121\108\112\88\122\115\68\103\56\77\45\57\83\83\104\115\118\89\57\74\114\57\75\49\79\108\79\118\95\122\118\115\68\107\76\97\74\108\69\84\70\54\55\45\102\82\73\104\90\117\68","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\252\73\132\67\1\101\150\19\32\174\65\120\7\226\119\150\186\59\243\148\130\55\224\97\151\171\44\122\216\37\7\23\161\63\198\234\117\139\129\84\193\179\188\108\25\0\243\235\123\255\104\205\225\162\72\103\99\240\79\99\251\245\147\1\184\223\60\216\106\133\246\158\36\185\124\238\216\195\177\184\221\240\65\214\132\99\241\243\84\72\117\220\52\198\8\239\57\158\157\205\70\182\67\180\56\150\144\242\150\218\108\235\170\102\252\252\156\197\209\204\178\158\123\7\211\246\152\235\89\79\4\193\189\109\227\47\183\19\223\204\85\118\70\130\139\157\142\125\202\212\225\43\194\170\69\84\42\38\73\106\94\238\145\163\230\229\12\249\17\151\66\63\220\166\112\216\108\213\161\50\67\185\217\189\21\204\148\7\253\240\226\26\137\76\171\38\167\230\118\220\146\12\62\176\170\51\240\219\71\137\245\139\9\221\234\204\55\140\227\118\143\206\115\42\231\10\114\82\239\0\35\36\186\7\55\188\56\52\221\242\162\241\237\215\173\181\254\251\129\67\39\115\47\220\21\167\106\208\229\153\217\229\182\50\10\129\231\239\238\255\67\75\125\58\134\55\234\78\205\17\57\72\207\92\213\86\121\157\52\208\97\50\206\150\5\37\178\40\180\147\191\162\39\67\169\104\112",3495922346,4262092920} or {"\200\153\120\52\187\228\179\53\146\220\159\10\75\36\207\224\147\31\234\167\142\16\197\52\156\24\70\47\249\92\159\124\41\108\159\206\16\93\103\57\75\15\62\204\5\213\210\202\233\107\179\148\178\109\242\163\52\76\210\43\172\113\111\14\252\9\153\162\142\208\68\128\194\247\218\141\130\120\214\240\95\134\56\177\113\13\207\2\170\161\235\76\67\92\124\212\111\178\118\39\26\65\168\168\116\42\135\227\121\17\245\196\121\28\107\136\251\182\174\241\47\66\120\4\92\26\233\68\73\64\91\81\243\18\231\184\222\166\225\168\1\142\185\86\159\184\189\168\230\27\150\82\144\69\247\56\29\52\10\63\230\143\236\8\247\230\5\22\192\89\80\142\51\98\198\182\95\99\56\85\212\44\225\21\151\57\70\29\219\203\5\37\61\101\245\182\173\11\136\254\234\38\233\89\238\207\111\41\105\83\253\23\242\94\6\170\114\94\88\112\62\253\146\62\140\25\16\248\173\26\98\67\223\79\241\68\239\229\168\204\213\91\23\106\88\154\159\58\123\170\135\183\180\43\28\88\41\230\117\22\0\69\37\114\217\38\253\203\168\182\225\154\102\159\58\25\76\16\236\18\190\193\171\228\173\182\126\62\216\63\120\65\184\49\44\230\159\120\30\190\234\252\42\177\185",1175298983,3939066503}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
