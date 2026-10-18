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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=8c41db4a13a2c742"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=8c41db4a13a2c742"
local expected=622786
local runtime,reason,issue,pr=nil,nil,"request failed",0
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
if s2*65536.0+s1~=2050046860 then problem("runtime checksum mismatch",3);return end
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
local candidates={{fetch,"HttpGet",url}}
if fallback~=""then candidates[#candidates+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then candidates[#candidates+1]={candidate[1],candidate[2],fallback,true}end
candidates[#candidates+1]={candidate[1],candidate[2],pinned}
end
candidates[#candidates+1]={fetch,"HttpGet",retry}
local started,ni,ls=clock(),1,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=candidates[ni];ni=ni+1;ls=clock()
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
for poll=1,2000 do
if clock()-started>=40 then problem("HTTP download timed out after 40 seconds",4);break end
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
if runtime or reason or(active==0 and ni>#candidates)then break end
if ni<=#candidates and(active==0 or(active<2 and(completed or clock()-ls>=8)))then launch()
elseif not asynchronous or not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\72\68\100\55\108\87\114\112\111\109\120\67\113\103\112\120\58\72\71\72\52\82\115\89\106\73\100\70\67\95\79\76\101\55\69\51\87\70\119\58\115\71\101\119\86\56\90\68\53\103\54\69\67\80\101\51\89\86\121\83\89\104\69\107\100\73\110\52\109\77\85\69\66\86\67\80\53\103\81\85\72\115\103\114\79\54\81\74\105\104\54\106\115\66\83\99\101\83\122\113\113\70\122\74\81\104\83\48\54\109\121\50\45\110\80\115\120\48\111\74\115\52\115\85\109\122\88\67\79\68\69\118\109\84\119\116\107\119\55\81\72\74\103\68\113\97\72\111\121\48\120\110\72\113\80\104\48\119\101\106\68\114\70\89\109\68\50\84\78\52\118\48\104\68\81\55\98\74\100\81\79\65\115\108\97\84\120\117\80\73\99\83\66\87\73\49\71\111\79\80\49\71\69\74\104\57\57\81\121\88\74\95\113\113\57\109\121\120\82\105\54\98\55\67\70\51\53\119\109\88\89\102\113\119\48\107\52\83\73\66","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if fetch then pcall(fetch,host,target)elseif reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
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
local handoff=alternate and {"\209\247\146\58\210\53\113\92\106\188\84\148\0\27\206\88\28\217\158\213\22\153\105\232\253\13\57\220\155\121\168\3\164\36\66\93\7\135\56\4\130\184\138\177\151\167\41\29\24\104\254\36\246\6\65\42\192\192\37\174\245\232\79\180\32\254\207\167\147\239\157\187\226\71\195\54\20\82\136\117\170\28\157\178\61\227\146\144\253\233\184\63\94\86\161\171\137\72\211\79\251\11\16\143\33\222\134\180\39\30\196\36\138\89\217\182\15\79\143\187\45\228\253\186\224\8\102\151\249\35\69\71\235\191\61\168\195\73\235\12\130\6\128\95\125\76\61\133\38\185\4\41\185\218\193\205\57\34\97\128\79\118\220\239\117\50\0\57\244\236\46\231\225\55\120\41\12\93\132\69\196\244\119\65\1\37\110\253\54\7\89\121\51\251\230\74\94\83\119\83\33\144\130\26\192\228\162\234\114\174\145\17\128\42\90\200\149\216\208\99\52\147\194\194\118\151\93\175\27\108\239\58\60\15\10\214\201\2\200\34\220\77\214\248\132\255\68\222\47\142\222\17\136\84\221\77\67\113\75\43\227\242\165\255\184\188\170\123\131\167\105\142\144\251\252\60\202\38\168\185\236\27\49\236\251\14\142\151\30\201\41\43\155\236\129\240\101\69\195\240\35\216\233\181\225\66\18",2524321816,127492768} or {"\174\39\53\201\128\134\69\166\21\159\182\119\231\255\30\115\139\14\200\55\246\9\48\8\188\102\214\158\157\220\143\196\36\205\18\99\230\121\215\197\38\110\54\34\55\101\207\218\134\45\150\199\202\151\69\91\177\226\210\29\66\99\189\122\199\116\53\85\72\110\185\14\248\251\179\164\129\137\164\129\238\211\93\56\131\55\31\210\68\202\173\218\243\131\73\104\178\115\54\231\82\75\21\121\251\134\55\101\224\79\136\73\198\205\187\170\124\50\184\102\120\94\247\154\75\250\182\21\96\125\204\98\170\98\223\79\217\23\162\26\23\186\157\0\183\195\0\253\142\36\121\68\126\162\61\114\24\225\1\153\241\16\45\101\179\75\174\181\199\181\54\24\130\74\210\226\49\207\74\42\93\217\140\102\80\42\36\211\207\16\222\119\202\94\93\234\159\17\224\179\31\208\223\28\184\194\52\89\27\187\45\119\70\146\59\247\234\22\159\103\75\13\69\102\215\226\199\255\84\226\105\227\150\121\62\156\176\93\150\21\36\212\105\137\33\22\44\75\226\29\130\233\138\131\61\209\51\226\254\32\51\28\34\198\180\200\58\73\34\28\61\15\172\39\80\84\104\2\237\160\103\26\152\54\240\60\2\200\169\23\142\208\117\155\123\194\169\82\232\48\210\166\118\141\34",544977715,4119684271}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
