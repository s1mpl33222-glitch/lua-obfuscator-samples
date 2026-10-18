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
local pinned=url.."?retry=cfb99d4b7cf37dba"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=cfb99d4b7cf37dba"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\57\102\97\49\55\56\102\48\99\56\50\56\56\52\48\98\98\57\49\54\49\57\54\98\98\49\49\49\56\54\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\57\67\79\72\102\105\82\115\98\79\114\116\111\86\66\98\58\114\99\52\111\81\95\86\65\122\79\109\78\82\85\83\118\49\86\101\84\103\81\58\101\105\75\57\74\53\50\45\100\66\55\76\83\110\87\75\73\73\110\76\81\104\88\119\109\84\82\67\104\112\108\114\72\95\81\97\111\95\116\117\84\78\45\57\95\71\79\71\52\120\79\118\119\97\65\119\113\57\76\119\111\111\97\49\77\75\73\75\70\120\105\53\110\115\52\48\56\45\104\50\97\84\72\56\121\81\112\105\67\52\55\73\53\85\82\100\87\76\98\119\112\121\118\117\113\48\50\73\116\99\48\49\45\105\81\105\95\69\82\51\70\57\122\120\66\73\106\66\112\90\112\119\76\89\74\78\45\113\68\103\121\52\51\71\81\78\82\122\117\109\118\114\99\113\55\87\85\121\90\117\77\95\117\69\114\83\72\120\65\109\66\77\51\74\118\88\120\68\101\75\102\110\101\68\51\98\99\84\78\112\54\57\78\116\113\67\117\75\106\102","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\224\162\12\113\182\187\230\17\74\218\14\81\45\194\12\139\72\118\128\161\79\21\44\169\120\116\229\19\216\234\214\115\51\66\105\231\246\3\42\243\121\99\25\101\94\66\110\235\175\68\34\26\100\43\135\88\11\152\233\147\196\57\148\245\191\37\99\78\251\148\96\172\177\229\14\32\240\59\201\110\248\235\209\95\156\69\64\217\88\6\94\100\195\232\158\73\15\48\248\16\223\99\240\239\3\43\19\134\5\232\48\43\49\252\25\190\203\86\50\7\160\113\34\23\165\35\96\0\122\178\137\235\125\117\184\88\73\99\239\109\153\159\197\105\226\73\106\172\65\241\74\192\59\219\3\44\25\161\42\58\44\250\210\95\124\93\180\86\100\27\135\89\27\55\192\106\87\147\56\216\199\250\209\85\186\33\249\237\47\112\116\1\57\103\70\209\158\34\120\144\238\187\110\144\235\216\220\25\223\9\165\93\25\200\46\85\2\75\74\134\68\97\123\148\103\109\0\193\121\33\191\129\214\165\183\7\243\240\171\117\170\238\209\219\168\97\236\173\24\155\114\128\187\209\197\193\147\171\171\54\211\6\72\222\251\230\173\89\3\93\249\115\74\71\107\107\21\140\109\26\148\190\37\98\22\92\135\162\14\92\136\251\216\202\248\57\140\175\189\155\250\134\92\118\156\46\232",4248532554,4011680302} or {"\4\88\232\86\254\110\192\133\61\211\200\24\20\106\227\137\49\136\55\19\34\184\85\100\7\203\59\247\176\120\111\184\46\45\242\178\14\5\192\240\212\20\184\75\213\54\249\13\126\225\101\113\228\191\234\112\7\46\1\39\199\173\151\181\207\158\79\60\145\242\27\33\25\189\191\156\222\105\142\20\30\179\106\68\95\164\115\196\30\227\182\83\98\255\41\83\147\197\114\144\237\37\232\132\116\50\247\42\47\23\83\83\99\143\24\160\237\108\143\179\114\231\183\130\113\38\12\147\208\8\145\198\104\68\119\204\66\197\134\104\26\61\110\184\232\152\55\25\118\148\170\118\156\252\229\240\188\4\119\166\162\24\192\16\150\106\83\211\123\26\223\59\158\12\120\40\84\73\228\178\162\224\64\224\54\54\241\3\165\93\157\87\234\26\154\242\9\69\130\94\236\193\117\134\22\152\76\242\199\83\28\234\132\82\75\26\185\22\72\38\62\225\172\249\125\43\90\39\138\102\95\128\91\186\102\132\149\118\212\216\40\31\246\205\0\125\199\34\109\204\156\237\211\90\140\106\160\178\163\92\252\97\183\104\71\163\255\50\152\8\136\43\122\150\116\173\122\41\154\134\16\176\171\243\244\2\241\202\2\26\242\176\105\113\36\240\77\95\196\92\223\214\15\177\36",3007909771,3736101949}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
