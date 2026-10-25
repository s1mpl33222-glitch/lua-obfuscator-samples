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
local fresh=url.."?retry=d47d4fd811ab6b86"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=d47d4fd811ab6b86"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\99\109\122\86\95\78\98\99\87\117\81\104\66\75\73\57\58\103\112\82\102\85\97\78\84\57\84\109\50\56\56\55\121\99\99\99\118\111\103\58\114\113\106\78\106\86\54\95\102\65\116\109\90\79\104\66\115\81\72\119\53\78\89\57\83\50\75\57\106\86\119\80\49\99\57\77\85\54\73\86\111\99\81\78\122\57\54\108\71\107\109\78\88\114\120\111\121\109\80\86\75\100\88\51\121\45\107\76\72\74\45\110\86\71\45\82\53\104\116\98\98\114\79\57\55\79\45\89\49\103\117\108\87\57\49\118\84\49\55\103\77\103\76\95\69\116\108\85\72\115\73\103\85\116\120\49\76\87\113\118\69\85\72\119\95\118\49\106\67\71\103\99\87\72\74\65\105\120\113\78\90\48\67\101\49\53\65\106\78\45\54\116\57\112\68\113\53\85\77\69\110\76\50\108\83\103\114\113\45\103\105\104\83\113\117\77\89\107\56\120\106\104\69\49\79\86\104\111\45\121\79\52\121\87\80\78\95\101\52\109","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\141\215\64\220\36\198\231\39\210\171\125\208\26\235\238\218\252\52\43\189\225\212\137\131\99\54\109\238\171\79\183\230\81\179\56\65\150\245\36\49\39\18\64\137\189\63\114\240\203\51\83\197\81\7\95\59\21\239\171\45\153\95\111\38\100\92\232\154\193\221\103\114\168\143\56\70\100\128\208\68\18\202\225\240\123\25\238\212\39\136\82\29\24\75\190\210\172\164\121\46\171\50\76\233\62\44\45\144\160\208\151\98\117\192\202\206\188\165\249\35\23\166\223\171\36\141\120\163\136\227\120\100\192\146\73\143\254\122\171\100\147\182\60\230\49\38\182\145\89\89\252\82\157\194\77\155\13\0\236\13\72\246\237\48\55\130\210\87\74\222\65\106\230\211\14\189\49\227\27\8\24\10\142\30\236\53\79\33\159\64\197\165\93\204\130\133\201\232\46\53\161\232\43\36\84\229\189\218\82\26\185\6\154\210\203\168\137\251\39\18\14\92\231\251\48\102\75\41\89\164\56\207\247\12\113\33\72\121\127\91\150\146\57\118\44\70\168\144\129\30\241\148\239\69\92\163\244\154\252\57\233\201\73\179\142\166\211\149\151\140\32\143\233\100\194\224\40\76\118\119\7\84\62\207\111\159\14\138\240\161\156\252\209\206\172\22\165\169\21\36\178\232\72\228\153\241\40",1278706241,3987366505} or {"\179\249\111\211\85\51\86\22\164\30\38\11\249\225\8\251\4\94\152\236\216\12\131\10\106\242\243\10\74\193\191\239\197\39\27\170\192\133\136\118\143\168\245\161\192\73\223\65\197\213\112\35\99\153\76\222\12\197\99\83\60\74\225\40\105\177\75\59\250\216\212\222\169\180\66\62\45\82\214\81\83\230\181\171\139\178\196\219\170\63\236\35\184\82\77\132\64\199\171\72\145\112\50\28\230\103\115\181\207\90\139\211\175\84\48\105\11\184\44\11\50\122\71\29\123\246\72\26\228\10\162\67\14\122\178\123\230\41\42\250\30\19\126\208\111\237\116\249\51\251\26\200\44\240\1\250\100\154\199\234\94\165\186\231\122\69\66\169\48\241\90\116\124\37\118\163\122\135\40\229\181\38\195\130\33\107\229\44\184\83\150\102\246\9\8\46\249\213\29\62\221\64\196\88\190\203\71\25\96\22\203\236\99\78\47\46\63\57\237\66\88\71\77\208\192\190\25\97\167\178\30\35\36\89\218\247\93\228\210\168\86\227\134\74\76\54\210\123\60\246\2\53\249\177\194\71\233\241\240\208\98\152\106\59\41\201\229\181\183\149\155\231\191\209\130\213\153\8\92\131\238\186\109\35\117\220\1\85\82\221\194\75\138\43\9\23\198\52\21\158\8\2\115\37\210",2914079598,3685573752}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
