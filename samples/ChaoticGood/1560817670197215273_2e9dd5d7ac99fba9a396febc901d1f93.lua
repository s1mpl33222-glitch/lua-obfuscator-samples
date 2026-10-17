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
local pinned=url.."?retry=a63b52f3d99919e1"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=a63b52f3d99919e1"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\101\57\100\100\53\100\55\97\99\57\57\102\98\97\57\97\51\57\54\102\101\98\99\57\48\49\100\49\102\57\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\73\49\95\104\95\54\79\87\75\121\104\51\50\111\51\74\58\69\74\118\78\70\106\55\117\101\66\50\89\82\82\109\101\102\115\66\100\102\81\58\50\112\81\49\100\104\86\68\56\97\49\105\113\105\112\120\45\70\90\97\122\89\55\97\52\85\120\97\84\48\66\71\82\118\77\99\57\99\81\95\45\107\48\71\105\86\75\100\89\55\118\65\50\53\112\118\49\86\87\75\52\101\105\67\87\87\99\75\77\111\115\53\57\87\70\102\83\71\116\81\114\57\66\71\101\110\54\50\52\116\73\88\74\51\98\120\65\114\51\100\79\85\102\118\81\99\105\102\109\71\95\79\118\86\111\90\66\51\103\116\57\82\97\76\121\84\86\87\83\74\70\102\81\65\51\65\71\89\103\52\103\115\72\82\85\119\106\53\107\104\48\119\115\88\110\48\83\109\69\120\105\84\97\78\98\55\70\110\75\68\95\105\56\81\52\72\88\89\78\53\86\89\111\98\111\54\115\79\67\76\99\115\101\117\74\54\50\76\90\77","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\125\112\19\87\226\138\69\65\142\6\67\149\195\196\143\24\53\66\60\247\93\112\192\66\155\178\213\140\56\229\155\109\52\65\66\184\26\121\185\97\135\147\34\200\157\247\158\44\20\207\121\44\78\21\92\7\185\78\104\134\1\200\30\93\64\94\143\160\88\222\108\217\153\83\251\187\163\227\97\36\215\77\244\113\101\239\204\5\3\177\238\220\55\69\132\218\54\112\126\187\23\141\170\114\234\120\50\154\181\176\85\217\228\247\255\54\247\119\158\143\235\65\235\135\76\73\177\0\225\168\172\71\132\251\85\30\97\225\103\100\233\181\149\203\240\135\180\55\204\2\60\240\55\81\155\206\220\33\43\135\172\251\244\85\5\207\13\164\56\149\101\15\227\201\126\118\228\132\67\155\81\239\199\177\141\193\186\124\110\223\99\36\207\97\135\191\234\207\70\62\117\240\169\184\242\229\246\248\222\64\203\199\21\144\65\87\120\192\208\10\68\43\243\119\185\42\215\150\164\78\147\223\145\215\141\186\114\183\16\240\118\5\119\215\234\245\60\44\170\174\91\224\253\111\3\39\218\24\11\222\205\136\159\160\126\196\122\173\145\171\72\101\30\193\44\223\2\186\115\28\130\205\6\244\234\165\21\29\54\247\110\13\76\223\109\215\163\202\121\139\130\129\216\43\205\9\133",274915990,2633458033} or {"\19\197\73\208\221\189\3\74\30\73\241\12\63\108\117\55\227\163\95\201\181\32\162\65\193\33\21\214\176\0\225\74\130\51\193\141\152\147\196\253\9\68\219\141\180\203\226\63\129\155\57\191\61\200\159\84\63\174\73\163\198\185\110\36\6\21\163\195\181\54\237\68\137\150\154\159\81\51\150\178\39\220\72\219\115\16\188\40\83\112\81\28\218\246\105\25\14\0\36\60\102\122\76\113\107\83\103\32\179\140\209\86\244\157\47\11\222\12\124\30\37\229\204\80\247\161\109\180\235\125\169\211\93\107\41\209\116\183\142\28\253\234\89\54\152\40\147\91\149\25\185\179\207\144\11\195\241\243\213\149\105\109\212\100\202\144\52\42\105\102\160\123\83\219\25\157\25\199\246\151\85\58\111\75\4\162\60\214\226\45\142\44\1\28\138\20\51\245\229\107\97\201\126\23\140\14\96\207\7\29\78\9\74\4\180\35\4\230\189\120\118\193\193\243\193\55\6\188\26\36\221\254\123\201\82\5\104\49\45\173\185\182\100\231\51\239\118\53\107\216\157\195\208\55\32\106\224\156\29\37\231\128\113\234\198\166\130\143\128\228\180\220\233\246\109\20\199\217\9\202\218\40\161\16\219\119\227\171\175\145\187\214\15\164\241\222\76\166\98\67\250\215\143\115\237",3619013574,2305057664}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
