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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=fffa4902170bb033"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=fffa4902170bb033"
local expected=627508
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
if s2*65536.0+s1~=368677546 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\48\100\55\51\98\57\97\50\53\54\53\56\51\56\56\48\98\52\49\54\98\52\54\50\99\53\52\56\54\49\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\55\95\103\107\107\113\119\111\51\113\49\105\53\108\53\87\58\45\56\116\84\110\90\104\120\117\48\114\83\95\87\69\50\52\115\57\50\54\81\58\70\49\90\101\100\121\108\81\112\104\78\49\88\106\103\99\104\84\73\69\80\87\53\67\118\118\50\114\100\72\78\55\89\69\49\53\98\101\113\98\80\82\52\83\80\54\50\104\98\113\67\81\70\116\83\90\56\90\80\66\85\119\100\53\72\66\104\65\111\102\74\85\108\107\120\66\68\67\88\54\78\118\101\53\70\105\49\65\103\81\55\106\87\75\48\68\73\77\53\105\119\65\106\80\57\109\101\68\79\90\79\67\78\71\80\50\101\119\73\55\55\109\110\99\99\116\45\83\74\121\101\109\52\75\85\51\114\107\105\73\81\116\113\67\81\102\82\120\77\68\55\76\73\45\107\84\122\98\100\79\84\71\100\88\99\74\104\120\113\55\100\80\85\122\118\110\52\50\79\104\55\112\56\100\78\48\95\101\99\95\86\117\84\118\49\99\77\106\53\109","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\117\10\203\71\155\4\18\174\1\74\188\143\176\208\156\163\94\26\243\43\87\140\223\189\209\112\246\149\0\232\35\147\107\12\160\80\88\50\197\199\100\165\138\75\191\183\160\150\251\144\153\201\36\19\137\69\252\253\73\4\156\32\127\163\183\252\163\35\254\223\240\255\174\183\255\250\238\51\34\31\64\193\26\56\103\80\50\8\53\82\230\164\24\9\43\57\61\176\40\163\105\198\104\202\66\174\108\178\86\118\127\57\219\7\206\168\254\27\73\245\48\23\109\9\225\50\33\213\51\127\169\199\188\214\50\207\73\65\127\101\51\76\42\144\17\109\156\41\235\178\228\74\217\231\103\86\70\248\66\18\22\115\14\111\51\207\162\240\186\54\181\162\201\137\100\116\226\96\214\253\32\189\48\134\136\192\45\49\145\27\39\115\49\69\51\181\109\69\97\240\92\28\67\167\145\214\229\190\146\17\123\36\6\179\223\220\161\122\125\251\71\3\211\175\189\151\188\11\147\240\22\252\113\178\153\13\191\1\35\63\20\33\244\128\52\147\240\97\234\254\177\41\244\96\79\119\197\193\112\45\42\59\226\148\113\132\236\105\126\231\204\33\215\220\69\72\11\186\149\100\185\178\219\15\46\105\99\72\35\127\112\175\62\229\242\29\232\132\0\141\100\29\94\208\132\255\0",1704980557,3332726790} or {"\139\215\70\155\160\183\31\205\66\247\113\95\120\135\179\130\125\179\177\83\232\166\100\183\209\105\73\121\92\58\139\237\45\105\104\54\67\174\244\87\212\4\177\53\107\174\18\40\163\232\15\143\46\208\76\174\242\88\124\219\236\235\223\187\16\18\66\117\110\115\213\6\5\60\255\157\164\46\5\35\194\62\238\171\22\131\113\87\93\70\99\66\127\120\131\125\90\145\74\246\55\17\158\4\83\58\16\119\185\184\52\38\102\36\5\138\94\99\51\16\164\127\231\251\161\174\80\97\38\120\145\147\237\193\132\167\101\174\188\175\120\170\83\140\58\65\159\167\18\153\206\56\150\169\115\120\218\73\106\88\8\173\209\19\188\79\133\171\196\216\239\172\236\37\155\96\146\242\62\157\128\228\24\66\96\72\240\255\130\74\98\77\234\244\112\247\114\196\10\114\54\70\196\74\110\192\122\112\68\199\132\121\0\81\136\172\199\88\57\66\189\178\147\3\162\28\220\94\13\49\111\113\247\1\142\171\54\113\250\183\219\104\225\169\223\184\213\20\35\210\209\28\201\15\214\81\245\87\127\0\12\145\192\118\13\234\50\172\136\185\3\21\210\78\92\155\173\106\236\48\59\45\93\24\166\110\222\152\156\32\144\73\165\248\160\39\39\238\212\44\30\95\143\53\197",1846440116,3063439893}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
