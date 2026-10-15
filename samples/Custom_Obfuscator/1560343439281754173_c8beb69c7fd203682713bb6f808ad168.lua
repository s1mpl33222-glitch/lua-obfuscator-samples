-- Do not save this file
  -- Always use the loadstring
  _bsdata0={117134507,"=JdJQS87jK9n9i38n_KmcvxLWJ40_Pmvg3FzalbPDX3kcJoKMhJKX4mVzk1yof9DHkcLId2djBkuGpbgED_1Ze4zhg",1792085330686,"\82\54\132\2\157\41\48\76\189\220\101\72\59\239\95\94","WHDQ0_6pj4uZUbhtHgjonHtQ.SLq_h.8H7n1j.GzpZTaHMCHTSZOAEXHGi.gIk_XHcQuLOGNhhjJYFcScVISRKU3k","i8avJh_heRUc4zLvs4.DonudxCGBJZcSWybtNpOfcfrtvUgMGGDndmi4dajw9px8.10WZ6qRNSEWjeAH85qmnZiyT",954282536,3587701593,4006062816,3886509214,445242680,1189931820,"3a3a4333a0f70e0536331c1ba2f4dd6ad4bb9addf65ecc95df69f0a23aa0716cbf642703166831b1b32cdcbd53bc782eff39e9ed8d5fb2522ddd3d551079d3196f75f138dfb32ac497d3c527c1806639071fedee14b0d9674804d2190ecffeaacaa939ee71dd4a1cb51207f4f5e82f85193873e035333fcb5d32c8e34c0853043a098d444874f82b1acb9279e59b31694c2d33a8faa259c5f8143e3f09c371dde4c64ca0d0b503419d9a19a22cc346543a136b9425a9e7c1575a928b0792d73f25eb1890766e2d20","\135\135\134\207\143\137\19\45\198\6\223\163\220\244\86\181\161\75\200\93\165\34\72\243"};
  local f,b,a="static_content_130520","ab41c9f0e2p-sephal"
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