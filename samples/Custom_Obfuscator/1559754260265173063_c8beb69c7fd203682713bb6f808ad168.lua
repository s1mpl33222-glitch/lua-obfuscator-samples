-- Do not save this file
  -- Always use the loadstring
  _bsdata0={559352548,"=JZLMuV5dipn4gxB7ueajnMPT6RmLmnXYrCAblMNog4Fa5FAA2wySQHVQb1Sa2CDDkDLVaZcjxkuHhHhoCf1.P3Lns",1791944855849,"\127\245\243\18\54\46\109\191\147\213\147\48\235\82\183\221","aTWxR.pwmGRKM5PvHqSWr.NrwF2tCqYLWky5zNEHKNFOa4DviJE7QWIKWiZjYn73ftUyv7C9ChiBfFfOsUFWB1r4p","lsZacXmyK9_P6VLQG3u1lNypmCGBJZcSWybtNpOfcfrtvUgMGGDndmi4dajw9px8.10WZ6qRNSEWjeAH85qmnZiyT",4243149583,3072271188,1385400603,3929072416,4238380155,1584372728,"6fb3135b25a9208d9fecfc84245edbbc77776bf8f99262cafb1f1d37110d81d28b307f63fdb6f5e58b9dc474a1967c5eee1e94b1435b53efebf0f8298b0fa1d1e48355dbaabe00af3a8a56508d65d6449013856e28021b24fbd85396ec23aa8c1e11e868cf97369f196c222bb88c32fafc59a380695946412c4e8321c5eb0e8b1c1e7ff96e40b76d8d21ecc3b29512b502f02d0da3e533947a36f8ce75e3125505c5178ec346b46505176f498afac757267ba9a89cef67734a02980b64ba98156a9a7e0c213ea1b0","\141\115\87\15\191\77\208\227\143\21\49\128\176\115\247\77\234\133\198\43\70\188\211\1"};
  local f,b,a="static_content_130520","ab41c9f0e2w-sephal"
  pcall(function() a=readfile(f.."/init-"..b..".lua") end)
  if a and #a>2000 then a=loadstring(a) else a=nil end
  if a then return a() end

  pcall(makefolder,f)
  a=game:HttpGet("https://cdn.xhider.xyz/v4_init_sephal.lua"..(_ca920af6193 or ""))
  writefile(f.."/init-"..b..".lua",a)

  local keep="init-"..b..".lua"
  local bs=string.char(92)
  local function clean(dir)
    local ok,list=pcall(listfiles,dir)
    if not ok or type(list)~="table" then return false end
    for _,v in ipairs(list) do
      local name=tostring(v):gsub(bs,"/"):match("([^/]+)$")
      if name and name~=keep and name:match("^init[%w%-]*%.lua$") then
        if not pcall(delfile,v) then pcall(delfile,f.."/"..name) end
      end
    end
    return true
  end
  if not clean(f) then clean("./"..f) end

  return loadstring(a)()