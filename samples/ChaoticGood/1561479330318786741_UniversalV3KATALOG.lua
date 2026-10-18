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
local pinned=url.."?retry=297a17232c2ef715"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=297a17232c2ef715"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\51\49\102\51\54\51\50\55\102\57\56\57\99\56\54\54\53\52\56\57\50\97\98\57\56\57\51\53\99\57\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\89\108\95\88\81\50\120\55\80\114\53\57\82\99\54\118\58\119\50\114\87\70\72\103\77\67\97\45\105\100\79\105\108\110\52\75\95\72\103\58\80\120\84\108\74\55\97\111\77\100\70\71\112\86\53\114\54\72\95\68\87\119\118\103\57\66\107\100\82\88\68\49\88\97\67\103\82\100\112\107\113\110\54\66\99\49\109\73\107\116\99\68\110\66\78\104\98\83\112\68\107\45\83\101\67\66\100\84\98\105\102\90\55\104\78\45\70\102\103\99\99\55\122\95\118\106\78\54\84\104\83\104\49\67\108\89\122\89\53\86\107\79\85\116\117\68\118\101\49\53\118\52\48\51\106\119\119\103\53\102\65\116\67\88\83\52\79\76\102\106\117\70\87\83\106\111\67\106\79\118\113\53\88\85\119\103\68\114\80\89\81\108\107\119\122\78\71\71\111\72\112\78\73\85\72\90\102\73\113\50\119\51\101\57\48\111\101\65\114\113\103\100\56\49\111\109\114\105\82\116\54\78\76\95\113\74\117\110\54\73","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\38\158\255\2\196\29\153\235\91\94\151\28\68\62\169\159\139\90\39\170\77\61\154\123\47\244\224\217\165\215\222\65\77\248\96\178\139\162\202\159\142\9\32\216\239\25\244\84\12\206\211\244\236\149\128\124\104\69\39\245\205\72\236\234\150\247\167\173\247\55\154\169\35\4\249\136\118\249\105\167\214\244\1\242\128\125\158\84\130\22\180\187\65\82\100\99\90\23\213\198\114\77\124\192\110\3\151\124\119\209\131\34\88\3\43\214\246\71\154\252\68\128\86\47\1\28\190\40\179\138\133\14\94\10\177\40\32\95\89\94\232\143\14\97\178\124\249\162\227\91\163\88\186\5\228\40\156\95\53\187\191\5\199\232\254\180\253\98\184\18\216\140\244\140\25\196\149\33\229\204\241\239\55\209\10\136\23\115\126\227\141\49\191\141\54\8\123\13\137\57\10\169\53\96\143\230\200\18\1\147\89\6\87\83\206\121\23\114\189\245\238\192\20\175\223\102\27\18\102\181\2\255\249\236\50\80\2\75\233\55\144\157\15\24\26\107\182\201\108\41\246\116\188\34\150\93\79\220\169\17\106\205\120\161\198\212\209\81\214\131\166\238\89\178\232\51\101\160\235\54\136\247\188\208\24\194\174\6\29\212\202\249\234\44\162\59\17\56\2\212\76\29\205\165\148\5\148",3163079388,4191576744} or {"\35\145\22\100\18\17\225\190\239\50\5\6\11\99\151\89\59\196\43\200\141\233\113\198\19\175\137\247\182\113\87\147\64\215\41\27\27\112\178\43\101\85\199\77\224\192\71\94\153\197\147\157\240\24\134\82\141\221\163\107\193\156\42\219\169\222\139\84\151\101\82\155\18\167\39\62\189\22\191\81\164\40\85\188\72\228\97\29\190\110\232\125\109\114\223\121\225\234\18\94\2\43\90\139\108\57\65\161\86\4\241\157\153\38\36\196\110\191\37\92\185\155\133\100\41\28\190\156\225\55\126\78\43\15\147\81\173\54\116\23\196\44\191\212\101\18\191\22\133\13\113\79\105\222\30\206\101\255\52\155\15\222\33\193\8\195\56\107\225\91\82\63\102\250\42\63\153\156\151\121\203\175\217\235\93\111\252\92\5\167\59\42\42\34\166\158\140\154\97\220\108\65\23\70\17\150\224\214\11\143\217\71\173\84\120\202\3\59\194\66\33\73\114\124\180\121\20\254\11\225\38\230\103\108\74\40\168\126\158\244\14\65\229\10\132\125\115\26\68\160\17\216\146\205\70\62\195\87\189\69\16\102\181\8\232\176\29\231\172\55\83\95\127\255\118\185\11\45\117\247\115\162\223\159\112\172\207\170\232\222\36\89\137\236\89\181\156\56\49\26\86\124\202\209\64",2868939861,3917046967}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
