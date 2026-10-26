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
local fresh=url.."?retry=9bba0dc2a9af49b0"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=9bba0dc2a9af49b0"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\57\83\53\50\74\71\78\102\116\121\103\74\121\57\120\70\58\103\45\66\49\53\111\114\98\66\122\120\81\86\82\68\100\111\74\113\113\84\81\58\105\101\105\49\121\48\84\100\45\80\122\110\105\88\49\99\87\101\110\120\112\106\115\68\106\79\75\88\82\69\105\45\102\102\100\45\115\99\68\105\84\88\107\102\66\82\53\84\117\53\87\95\56\69\72\88\81\89\49\70\95\84\80\118\67\104\83\89\85\99\89\69\48\113\57\67\113\74\118\106\67\69\107\114\71\104\87\74\116\120\88\68\55\110\87\109\81\70\85\113\121\103\114\70\119\104\88\100\116\103\98\86\68\102\52\114\103\67\108\107\118\86\97\119\100\57\72\111\57\52\119\54\70\109\82\53\56\83\50\121\120\50\53\105\90\48\111\49\90\90\109\55\53\45\48\69\122\103\73\67\82\52\102\109\104\114\83\99\104\88\101\115\117\118\73\50\121\113\79\80\113\122\86\85\57\102\112\68\101\73\106\71\90\121\101\79\99\57\70\77","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\204\215\218\174\181\144\64\124\216\54\172\144\234\195\175\26\216\80\92\74\253\27\90\80\70\229\79\144\15\183\170\198\156\93\140\187\71\157\25\116\219\211\171\236\79\67\237\131\203\129\103\34\244\46\71\201\122\142\132\36\77\157\122\181\84\40\246\134\167\137\233\147\203\157\166\249\161\52\163\217\240\198\147\255\58\190\69\232\37\233\67\135\109\9\80\110\85\225\43\187\195\115\135\203\95\158\206\248\251\250\63\173\249\237\242\79\78\43\247\48\56\48\12\136\64\7\27\122\136\177\44\36\128\95\35\142\196\66\233\249\175\215\36\85\100\165\82\69\127\206\38\199\62\35\247\26\77\175\191\246\145\91\158\12\209\153\99\28\162\35\31\213\226\137\224\118\180\26\161\42\221\76\172\165\111\203\153\176\120\29\64\114\20\82\128\176\107\57\93\70\175\107\238\86\85\0\185\42\156\58\211\249\187\45\249\184\227\154\58\56\9\54\159\20\116\19\173\51\208\211\40\80\172\106\106\245\3\50\52\70\165\22\10\82\3\204\134\37\214\96\124\64\41\61\197\192\173\239\66\246\83\112\96\101\7\93\106\24\132\219\112\105\116\159\16\221\247\175\57\79\164\255\60\181\85\164\197\200\207\12\96\38\148\103\41\195\51\124\150\157\154\57\116\51\122\16\254",2290031240,498164592} or {"\154\196\33\66\33\161\116\249\149\143\162\67\218\245\30\48\42\237\94\188\123\137\122\19\54\3\185\79\129\105\185\178\129\221\39\102\122\189\223\182\102\27\223\62\226\163\3\9\48\9\200\115\39\206\142\137\245\221\56\102\17\193\220\23\122\127\192\50\47\141\43\26\0\143\177\251\162\57\134\245\151\238\239\241\22\24\213\185\49\12\148\11\45\10\193\44\92\43\148\10\130\208\124\130\198\60\27\50\58\100\145\96\116\94\84\124\255\57\158\170\101\1\154\27\185\225\158\28\4\169\234\184\151\108\210\58\210\176\224\255\113\167\34\89\22\92\106\86\28\196\172\190\226\145\31\213\231\19\192\113\254\40\91\77\117\241\15\146\106\57\83\253\81\25\216\72\6\190\208\59\23\123\153\126\18\40\147\79\216\43\39\17\20\136\130\132\97\196\155\8\192\144\196\13\231\59\132\147\184\58\151\76\153\168\103\126\248\140\208\162\248\162\27\112\132\130\195\203\223\9\192\187\215\99\167\5\57\198\24\208\73\47\234\114\77\19\145\155\85\75\43\104\190\148\198\247\61\90\11\15\76\95\211\48\216\96\246\112\1\198\58\161\241\219\97\136\202\21\232\163\20\104\152\52\61\236\83\216\221\30\172\16\214\224\245\25\32\36\223\94\125\106\89\209\109",255861050,196371839}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
