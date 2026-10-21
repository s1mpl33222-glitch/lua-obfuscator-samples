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
local fresh=url.."?retry=6d07b1bd99de497d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=6d07b1bd99de497d"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\57\56\97\101\101\99\99\97\50\49\55\50\54\54\51\54\52\101\49\101\98\48\51\57\54\99\55\97\50\56\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\116\116\117\84\114\109\121\71\98\48\50\79\116\48\66\75\58\71\116\122\113\114\69\110\67\89\89\116\116\109\84\85\98\56\110\71\120\50\119\58\89\52\107\52\90\111\100\51\81\120\109\70\86\86\52\103\53\109\104\84\75\55\88\81\57\112\52\54\119\68\53\90\101\55\110\79\86\75\99\83\73\54\90\56\118\103\104\116\73\90\54\49\51\90\55\118\50\72\108\72\65\97\50\113\111\65\68\121\122\68\52\72\117\69\89\114\88\112\54\99\89\57\113\116\73\80\87\100\99\122\54\85\107\84\86\100\51\84\52\95\113\97\68\113\57\114\71\83\79\86\120\78\74\52\105\67\116\70\118\55\85\48\68\65\110\82\86\45\90\56\101\112\72\87\66\83\52\68\103\78\119\104\113\54\87\71\69\120\106\80\85\69\69\106\116\102\54\107\102\114\51\67\84\117\115\107\95\56\57\67\98\122\72\116\55\81\49\103\52\101\88\57\112\113\112\90\86\108\122\76\77\85\89\100\102\72\75\112\67\99","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\143\41\211\50\250\141\190\0\172\201\47\168\89\101\22\163\210\182\112\243\190\51\108\42\228\218\45\139\76\206\93\168\145\120\181\43\71\72\30\16\159\208\180\218\16\237\181\184\6\100\160\90\163\77\210\32\234\71\195\11\45\197\178\43\91\147\161\253\200\63\0\11\253\180\53\132\193\216\51\17\90\118\245\79\232\130\211\157\249\163\136\181\174\155\219\19\102\202\143\202\9\170\79\84\108\140\49\210\2\219\190\249\155\185\28\254\196\209\131\172\53\145\163\199\180\152\106\153\187\243\231\242\63\223\161\79\200\250\251\167\159\226\34\241\65\144\10\0\196\227\74\4\182\55\152\213\2\154\18\124\236\129\117\174\13\241\23\146\168\7\25\49\185\88\176\224\254\184\148\19\133\158\214\192\95\36\176\102\176\1\51\203\238\99\155\118\55\72\38\37\227\192\238\98\100\236\213\25\69\21\44\182\153\54\123\222\146\87\76\62\168\212\32\33\230\170\247\13\222\213\252\132\255\148\132\43\165\120\16\65\121\47\178\145\33\38\141\253\222\180\59\189\101\58\145\28\235\78\210\21\15\3\117\219\253\35\11\251\217\79\182\25\18\190\153\141\201\65\112\154\187\155\132\200\62\202\98\16\32\90\229\1\208\122\187\202\7\82\147\114\210\139\234\104\137\96\119",2960956072,2665636354} or {"\18\249\250\62\18\137\152\167\236\107\179\246\20\141\186\143\157\41\250\240\183\17\143\229\85\65\134\142\155\65\217\130\53\177\86\107\116\25\57\130\173\216\189\112\23\23\54\168\212\179\63\154\169\64\186\116\190\120\118\7\143\215\32\80\208\106\105\134\38\100\143\172\174\225\43\166\91\101\142\166\200\64\165\146\171\251\108\93\195\56\165\66\254\73\128\74\161\148\26\98\97\95\82\31\58\212\195\99\99\241\157\125\255\106\43\167\218\114\199\135\87\235\251\2\147\10\31\202\185\53\253\32\61\166\115\90\21\115\126\93\140\216\255\113\37\89\77\197\58\71\53\116\25\43\177\153\158\26\203\129\222\249\61\214\16\32\227\34\116\50\224\229\217\8\114\54\20\248\142\27\214\222\74\176\73\9\223\11\88\119\1\61\1\214\166\131\23\91\54\30\184\212\194\70\251\26\180\126\210\162\212\148\103\146\207\140\102\198\107\22\219\58\165\55\63\162\45\35\159\136\55\142\168\232\113\23\156\206\80\123\242\106\168\74\125\76\196\160\84\140\102\29\103\149\216\251\51\222\39\232\73\94\194\209\145\246\161\1\3\181\252\91\197\112\189\231\22\202\8\73\252\205\252\33\9\104\82\167\36\174\124\143\205\241\216\140\68\12\90\196\203\28\10\230\169",2793205458,2365023249}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
