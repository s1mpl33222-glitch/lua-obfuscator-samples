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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=23ba3d9ce2f60c5d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=23ba3d9ce2f60c5d"
local expected=617906
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
if s2*65536.0+s1~=2497301977 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\102\102\102\54\55\49\49\52\101\50\49\100\49\53\99\55\98\52\53\101\102\98\99\100\97\52\52\97\97\55\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\76\71\82\118\100\84\75\122\105\114\45\95\71\82\55\70\58\120\103\95\100\75\54\67\99\82\53\113\70\115\121\71\99\53\111\121\75\100\103\58\89\102\72\105\84\103\89\49\109\76\114\81\121\112\88\57\102\84\84\115\80\118\99\121\54\86\52\108\69\71\50\69\65\57\85\77\57\55\111\110\73\120\66\76\98\67\102\82\67\119\107\76\114\71\115\116\75\79\48\121\102\98\111\122\66\102\57\69\98\82\110\82\65\53\108\112\73\66\71\76\102\77\72\86\86\112\116\97\78\73\50\110\51\115\105\117\86\83\101\72\122\110\113\45\112\95\85\115\106\52\116\51\78\49\78\57\115\113\122\73\81\120\51\78\68\57\87\117\45\118\74\88\66\56\106\111\65\53\110\102\51\97\86\72\75\122\84\98\107\101\112\82\53\108\88\122\118\120\89\67\57\88\102\49\119\67\102\52\79\76\78\89\48\103\54\102\48\84\88\83\51\114\119\97\112\97\73\71\120\122\109\108\105\53\107\79\119\97\56\51","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\249\196\4\212\91\143\17\255\165\57\17\54\172\63\222\75\97\114\19\22\143\240\188\33\187\25\228\201\210\177\92\98\43\166\74\79\220\30\24\146\228\202\116\121\77\88\154\216\189\71\194\255\88\24\72\229\119\187\178\152\73\196\126\242\171\40\79\203\185\211\241\185\151\141\84\249\84\10\37\174\34\7\47\138\88\164\142\1\102\218\148\34\151\201\110\40\118\226\198\39\173\54\224\65\26\217\28\175\111\228\90\115\196\45\188\194\136\70\240\60\129\105\40\174\246\196\137\183\230\35\28\217\118\246\119\110\64\131\72\152\13\53\112\203\49\75\55\133\243\0\3\168\9\68\200\202\43\86\172\49\202\242\109\90\56\38\220\1\169\103\158\195\200\185\31\54\114\24\118\3\6\196\128\136\232\130\40\245\163\146\236\17\213\15\140\171\202\180\243\218\163\3\198\95\127\228\69\25\240\208\122\46\146\207\198\227\86\56\103\161\222\207\17\21\178\77\119\13\72\100\215\231\224\31\231\179\23\164\143\214\35\47\64\49\179\102\3\202\237\108\64\174\3\221\195\61\160\77\23\180\93\146\58\111\136\99\238\148\117\75\3\66\242\62\169\86\214\140\59\232\20\196\74\248\97\227\130\183\78\196\107\178\173\136\250\13\194\239\251\63\194\16\114\18\99\84\157",3394365745,3980944357} or {"\166\172\146\57\231\200\100\91\54\29\71\124\223\54\207\158\231\75\81\48\232\53\170\51\133\17\220\89\32\124\1\195\30\191\58\22\174\73\229\6\196\159\231\171\12\163\48\72\143\117\76\102\242\239\151\136\129\151\197\89\20\212\248\211\104\96\197\47\17\234\164\209\113\80\217\216\179\184\205\246\169\124\92\150\233\233\43\146\27\160\0\35\12\239\174\183\42\222\238\2\77\229\249\162\127\52\153\118\2\73\150\107\255\207\89\220\116\233\21\137\131\118\165\34\8\230\201\88\139\38\53\83\143\64\202\135\189\149\51\182\244\231\34\123\163\109\250\210\59\161\240\7\37\221\186\155\142\30\38\242\92\40\40\141\164\132\67\175\108\228\102\188\71\97\239\143\212\164\24\108\207\42\120\150\250\241\125\123\168\51\162\78\134\65\233\98\52\172\158\169\223\17\180\137\98\46\4\176\212\113\167\209\54\197\41\153\71\54\98\164\244\198\2\138\56\202\248\153\136\51\141\240\253\120\241\67\64\65\178\176\112\80\177\110\86\32\4\247\7\115\109\101\139\11\60\76\36\137\132\130\28\22\221\44\3\42\106\251\87\142\21\71\155\51\112\93\207\70\88\222\63\143\201\213\192\79\122\174\101\245\163\200\130\250\102\98\145\33\238\4\95\46\189\69\76",4093010656,3655427572}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
