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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=5cb8951ec4c37147"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=5cb8951ec4c37147"
local expected=572639
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
if s2*65536.0+s1~=2292470616 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\98\97\52\56\57\54\55\99\48\49\57\57\101\56\48\49\97\98\102\50\50\57\50\98\51\53\51\98\52\55\48","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\51\112\86\111\95\79\75\73\87\50\50\97\48\68\101\117\58\66\73\89\103\77\101\57\73\79\98\68\98\116\88\84\108\122\98\87\116\74\103\58\108\88\116\97\99\56\103\120\68\73\88\74\80\71\68\75\88\120\52\83\113\75\87\103\81\78\109\78\118\122\66\89\81\74\54\107\119\49\81\84\82\74\116\85\104\49\104\76\65\114\117\79\75\97\107\79\98\87\67\71\65\69\119\67\100\76\120\75\119\99\105\115\66\66\65\80\54\69\78\67\51\81\99\97\51\106\68\45\103\87\77\88\90\82\68\121\74\78\119\105\71\85\57\51\65\68\102\65\103\111\68\107\52\100\100\80\49\83\68\118\114\104\102\53\113\75\112\106\66\78\84\65\81\73\117\114\121\53\53\106\95\106\74\99\68\106\89\119\115\70\104\105\89\72\69\80\80\84\116\72\89\116\51\102\81\71\70\111\98\104\70\89\95\74\100\66\48\85\77\83\121\97\106\120\74\52\106\79\70\88\85\104\115\103\45\81\75\108\87\50","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\181\54\41\88\73\191\79\157\35\78\25\229\91\189\95\46\103\0\86\30\126\115\14\217\118\148\225\42\218\194\154\210\191\130\39\222\137\141\248\189\155\250\214\105\120\117\202\85\178\109\213\68\101\15\84\66\94\31\44\84\140\13\217\100\203\153\68\165\217\42\226\158\200\80\13\167\90\125\128\152\179\10\146\18\96\85\226\38\184\95\4\238\217\238\30\28\136\99\41\48\62\13\48\105\3\93\247\20\62\7\97\86\91\155\7\158\157\101\233\201\51\137\253\52\144\72\74\180\111\5\189\117\175\65\105\110\118\136\176\22\98\200\255\7\129\119\147\219\127\233\102\226\131\66\73\63\78\208\209\41\140\221\208\230\83\36\249\102\138\78\16\151\71\70\219\87\248\137\93\193\196\128\47\112\234\116\175\139\192\225\31\7\186\168\8\206\254\12\13\54\169\163\70\128\10\207\174\236\73\166\78\138\68\123\246\202\133\54\184\157\51\6\137\245\105\80\45\119\111\176\221\166\207\144\155\164\65\6\170\193\22\13\137\178\87\240\59\232\216\85\43\150\169\152\164\41\224\83\253\195\82\52\0\234\34\177\217\223\10\106\147\45\129\8\114\45\165\202\228\116\15\188\173\255\60\162\161\159\134\110\12\170\51\14\202\134\125\203\176\52\176\163\85\147\40\174\128",1738008562,3383648609} or {"\251\208\139\15\42\245\230\226\199\230\88\127\210\227\173\93\143\169\189\204\73\254\197\96\0\108\5\228\17\182\147\208\91\137\160\84\191\82\12\93\59\153\89\33\45\84\188\45\206\43\69\52\157\250\68\73\165\247\83\3\197\224\208\119\1\26\62\85\72\49\33\163\52\224\67\138\168\30\102\114\243\52\79\168\100\125\54\105\105\88\182\201\200\20\137\91\70\253\200\28\239\147\194\217\165\200\160\1\230\63\157\70\104\181\43\241\222\47\228\114\179\42\252\165\62\4\96\107\12\52\32\37\249\231\22\158\120\94\31\180\136\170\58\54\231\42\145\126\25\153\192\167\172\126\43\141\112\7\98\103\63\199\216\39\185\167\161\132\194\41\251\164\181\195\170\144\87\199\63\239\223\202\203\230\126\21\118\100\121\49\165\175\225\117\223\10\183\146\81\118\142\227\81\82\206\190\91\50\97\135\140\141\131\139\99\42\119\222\232\33\90\172\163\18\222\21\1\113\103\163\155\60\131\244\106\138\255\0\155\0\249\141\96\197\214\164\83\8\215\243\144\120\181\196\232\224\22\115\165\115\81\64\146\58\229\57\90\196\105\180\24\234\172\213\82\48\38\119\114\35\169\109\197\211\215\123\254\162\254\76\169\125\40\174\149\17\135\62\5\136\151\176\79\200\192",3537740221,3102565232}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
