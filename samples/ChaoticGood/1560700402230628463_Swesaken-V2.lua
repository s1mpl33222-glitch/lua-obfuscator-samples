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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=72fe2c2381f9cfa9"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=72fe2c2381f9cfa9"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\102\48\56\51\51\102\50\98\101\56\56\99\99\97\57\48\57\50\100\98\100\101\101\54\55\97\99\57\100\57\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\50\79\117\51\78\99\85\87\53\104\48\112\101\71\104\70\58\81\101\83\106\116\52\69\55\108\118\65\54\55\107\90\77\113\81\79\116\117\103\58\66\77\83\99\107\119\48\70\120\68\67\48\98\108\111\119\115\114\81\102\84\81\115\85\45\118\122\69\73\54\85\48\81\50\109\77\104\75\55\104\114\108\54\109\75\95\101\70\97\111\71\112\98\118\84\73\71\79\87\113\77\69\86\45\81\110\75\76\54\52\73\78\65\117\120\119\111\116\103\109\75\115\72\52\80\107\72\100\97\49\86\108\101\107\116\100\81\55\74\81\88\90\87\119\104\84\85\69\52\112\100\78\74\106\66\98\85\69\45\104\48\109\76\118\108\114\83\50\57\53\97\107\102\53\107\104\122\98\99\110\113\51\115\102\88\121\68\82\53\111\71\84\121\81\50\109\57\89\118\121\52\109\120\70\81\112\90\51\117\101\97\111\57\103\48\115\83\104\81\112\85\77\86\88\67\83\103\74\118\109\69\73\48\82\101\70\89\110\119\52","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\186\134\26\128\137\32\205\57\3\20\76\83\108\235\112\205\50\174\229\177\193\40\121\243\54\72\77\252\59\197\34\3\252\164\97\209\196\241\212\106\40\184\187\114\216\136\54\116\39\215\5\153\20\75\47\15\26\225\161\137\43\228\245\115\233\252\90\100\254\63\129\66\199\198\36\49\241\60\145\168\14\135\179\18\215\122\168\61\135\102\159\230\174\160\25\129\14\225\33\205\112\135\205\177\62\47\163\101\191\184\184\141\222\114\50\234\167\137\17\193\229\3\20\117\158\242\8\160\18\4\144\3\78\37\217\73\32\225\164\78\22\180\178\231\206\18\114\63\197\40\26\198\145\167\120\0\155\167\163\167\168\42\37\69\133\196\47\223\250\172\30\226\71\231\136\94\91\173\204\2\118\166\63\253\36\224\80\17\115\203\24\152\69\196\203\129\118\194\140\18\77\110\145\246\224\94\162\187\14\134\249\237\153\4\15\198\156\183\245\179\130\170\208\139\199\73\98\138\22\248\177\213\95\202\188\4\29\43\47\79\143\23\30\54\50\252\99\181\63\117\99\28\125\25\149\208\87\127\194\114\136\37\235\173\155\167\52\101\146\135\183\53\136\239\218\139\230\227\214\249\75\254\146\7\214\30\196\178\20\132\150\110\54\215\193\55\24\5\22\131\228\33\138\101\86\224\28",2813422778,2258396130} or {"\183\132\98\121\203\197\186\77\140\156\161\79\181\96\174\193\36\95\6\43\223\255\224\251\245\160\40\127\215\135\140\155\157\12\175\240\246\141\122\236\185\242\234\245\110\94\187\205\60\249\115\214\23\91\24\21\64\99\136\138\124\49\58\73\64\35\176\208\224\238\140\147\211\86\254\182\67\211\140\122\59\178\76\174\181\133\52\181\226\184\52\222\219\243\218\140\34\252\122\94\108\5\235\135\28\74\184\65\84\172\174\172\25\126\188\45\110\65\42\66\237\24\212\124\186\193\220\76\19\231\104\56\123\255\41\238\11\197\209\87\129\86\71\228\182\77\193\44\225\92\191\136\128\140\117\26\221\207\9\14\72\20\61\143\20\103\95\59\130\168\26\17\167\7\251\4\14\45\241\148\237\178\57\133\253\119\228\182\112\164\207\183\71\68\158\12\250\56\183\121\34\110\86\133\35\128\81\98\6\79\248\23\188\182\151\117\181\98\166\180\202\94\93\91\36\79\210\166\16\167\106\211\31\244\143\21\91\167\101\52\63\90\47\121\182\83\9\232\144\123\121\117\249\189\31\190\79\163\129\229\113\96\171\55\180\228\212\102\232\178\127\243\108\156\15\194\207\134\177\135\166\48\76\123\6\50\251\8\248\151\59\230\173\206\136\31\127\232\114\44\200\103\164\31\84",3544310685,1936680433}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
