--[[
    [ Luabfuscor - Universal Protection Engine ]
    Protected with Luabfuscor for Roblox & Luau
--]]
return (function(...)
  local function I_lIl111IlI1_4()
    local _t = {}
    for _i = 1, 64 do _t[_i] = _t end
    return _t[1][2][3]()
  end

  local function l_I1I1Il_5()
    if type(string) ~= "table" or type(string.byte) ~= "function" or type(string.sub) ~= "function" or type(string.char) ~= "function" then
      return false
    end
    if type(math) ~= "table" or type(math.floor) ~= "function" or type(math.abs) ~= "function" then
      return false
    end
    if type(table) ~= "table" or type(table.concat) ~= "function" then
      return false
    end
    if type(pcall) ~= "function" then
      return false
    end
    return true
  end
  if not l_I1I1Il_5() then I_lIl111IlI1_4() end

  local function l_11lI1lI_6()
    local sm = getmetatable("")
    if sm and type(sm) == "table" then
      if sm.__index ~= string then
        return false
      end
    end
    return true
  end
  if not l_11lI1lI_6() then I_lIl111IlI1_4() end

  local function l_II1IllIl_7()
    if debug and type(debug.gethook) == "function" and debug.gethook() ~= nil then
      return false
    end
    if debug and type(debug.getinfo) == "function" then
      local targets = { string.byte, string.char, string.sub, math.floor, pcall }
      for idx = 1, #targets do
        local fn = targets[idx]
        if type(fn) == "function" then
          local info = debug.getinfo(fn, "S")
          if info and (info.what == "Lua" or info.what == "main") then
            return false
          end
        end
      end
    end
    return true
  end
  if not l_II1IllIl_7() then I_lIl111IlI1_4() end

  local l_l1lIl1lI1_8 = (function()
    local ok1, res1 = pcall(function()
      return typeof(game) == "Instance" and game.ClassName == "DataModel" and type(game.GetService) == "function"
    end)
    if not (ok1 and res1) then return false end
    local ok2 = pcall(function()
      return game:GetService("RunService") and game:GetService("Players")
    end)
    if not ok2 then return false end
    return true
  end)()
  if not l_l1lIl1lI1_8 then I_lIl111IlI1_4() end

  local I_IlIl1l1_1 = (getfenv and getfenv()) or _ENV or _G
  local l_I1I1111l_2 = unpack or table.unpack
  local l_llI11lI1I_3 = bit32 or bit
  if not l_llI11lI1I_3 then
    local function _bxor(a, b)
      local r, p = 0, 1
      while a > 0 or b > 0 do
        if (a % 2) ~= (b % 2) then r = r + p end
        a = math.floor(a / 2); b = math.floor(b / 2); p = p * 2
      end
      return r
    end
    l_llI11lI1I_3 = {
      bxor = _bxor,
      band = function(a, b)
        local r, p = 0, 1
        while a > 0 and b > 0 do
          if (a % 2 == 1) and (b % 2 == 1) then r = r + p end
          a = math.floor(a / 2); b = math.floor(b / 2); p = p * 2
        end
        return r
      end,
      bor = function(a, b)
        local r, p = 0, 1
        while a > 0 or b > 0 do
          if (a % 2 == 1) or (b % 2 == 1) then r = r + p end
          a = math.floor(a / 2); b = math.floor(b / 2); p = p * 2
        end
        return r
      end,
      lshift = function(a, b) return (a * (2 ^ b)) % 4294967296 end,
      rshift = function(a, b) return math.floor((a % 4294967296) / (2 ^ b)) end,
      bnot = function(a) return 4294967295 - (a % 4294967296) end,
    }
  end

  local l_Il1lI1l1II_9 = "\066\077\198\000\000\000\000\000\000\000\054\000\000\000\040\000\000\000\016\000\000\000\003\000\000\000\001\000\024\000\000\000\000\000\144\000\000\000\019\011\000\000\019\011\000\000\000\000\000\000\000\000\000\000\116\000\000\000\249\195\188\036\051\197\017\254\235\239\222\236\031\167\074\010\026\185\127\126\094\157\246\037\132\027\126\077\136\072\171\172\178\024\020\071\072\054\025\141\207\041\235\061\187\002\020\009\002\223\110\201\250\107\095\108\068\110\029\197\213\004\053\107\050\177\175\233\149\204\148\052\017\249\079\124\244\062\033\240\085\029\141\132\055\255\182\208\012\034\183\207\022\251\162\112\022\154\132\078\100\213\149\087\116\000\095\021\055\050\193\061\118\127\188\162\158\230\078\195\017\131\232\060\184\013\103\237\050\146\034\087\189\087\124\232\140\161\019\193"
  if string.sub(l_Il1lI1l1II_9, 1, 2) ~= "BM" then I_lIl111IlI1_4() end

  local function I_lll11l_a(offset)
    local b1, b2, b3, b4 = string.byte(l_Il1lI1l1II_9, offset, offset + 3)
    return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
  end

  local I_l1IlIl1_b = I_lll11l_a(19)
  local I_ll11II11_c = I_lll11l_a(23)
  local l_1llllI1lI_d = I_lll11l_a(11)

  local l_1111111lIl_e = math.floor((24 * I_l1IlIl1_b + 31) / 32) * 4
  local l_llll1l_f = 3

  local lenB1, lenB2, lenB3, lenB4 = string.byte(l_Il1lI1l1II_9, l_1llllI1lI_d + 1, l_1llllI1lI_d + 4)
  local I_l11IlII_10 = (lenB1 + lenB2 * 256 + lenB3 * 65536 + lenB4 * 16777216) % 4294967296

  local I_Il11IIl11_17 = 15882
  local I_1lI1III_1a = {}
  local I_1l1I1llI_1b = {}
  local l_l1lIlI1Il_1c = 0
  local I_lI11I1_14 = 0
  local I_IIll1lI_15 = 0
  local I_1Il111_1e, l_1lII111_1f, l_IIl1II11_20, l_lI11II1Il_21 = 0, 0, 0, 0
  local I_ll1III_23 = 1
  local l_IIIllI1_24 = 0

  for y = 0, I_ll11II11_c - 1 do
    local rowStart = l_1llllI1lI_d + y * l_1111111lIl_e
    for x = 0, I_l1IlIl1_b - 1 do
      local pStart = rowStart + x * l_llll1l_f
      for ch = 0, 2 do
        I_IIll1lI_15 = I_IIll1lI_15 + 1
        if I_IIll1lI_15 > 4 then
          if I_lI11I1_14 < I_l11IlII_10 then
            I_lI11I1_14 = I_lI11I1_14 + 1
            I_Il11IIl11_17 = (I_Il11IIl11_17 * 1664525 + 1013904223) % 4294967296
            local l_ll1lIllI1l_18 = math.floor(I_Il11IIl11_17 / 16777216) % 256
            local b = string.byte(l_Il1lI1l1II_9, pStart + ch + 1)
            local I_IlIl1l_19 = l_llI11lI1I_3.bxor(b, l_ll1lIllI1l_18)

            if I_lI11I1_14 == 1 then
              I_1Il111_1e = I_IlIl1l_19
            elseif I_lI11I1_14 == 2 then
              l_1lII111_1f = I_IlIl1l_19
            elseif I_lI11I1_14 == 3 then
              l_IIl1II11_20 = I_IlIl1l_19
            elseif I_lI11I1_14 == 4 then
              l_lI11II1Il_21 = I_IlIl1l_19
            else
              I_ll1III_23 = (I_ll1III_23 + I_IlIl1l_19) % 65521
              l_IIIllI1_24 = (l_IIIllI1_24 + I_ll1III_23) % 65521

              l_l1lIlI1Il_1c = l_l1lIlI1Il_1c + 1
              I_1l1I1llI_1b[l_l1lIlI1Il_1c] = string.char(I_IlIl1l_19)
              if l_l1lIlI1Il_1c >= 1024 then
                I_1lI1III_1a[#I_1lI1III_1a + 1] = table.concat(I_1l1I1llI_1b)
                I_1l1I1llI_1b = {}
                l_l1lIlI1Il_1c = 0
              end
            end
          else
            break
          end
        end
      end
      if I_lI11I1_14 >= I_l11IlII_10 then break end
    end
    if I_lI11I1_14 >= I_l11IlII_10 then break end
  end
  if l_l1lIlI1Il_1c > 0 then
    I_1lI1III_1a[#I_1lI1III_1a + 1] = table.concat(I_1l1I1llI_1b)
  end

  local l_II1IlllIll_22 = (I_1Il111_1e + l_1lII111_1f * 256 + l_IIl1II11_20 * 65536 + l_lI11II1Il_21 * 16777216) % 4294967296
  local l_lll1llIl_25 = (l_IIIllI1_24 * 65536 + I_ll1III_23) % 4294967296
  if l_lll1llIl_25 ~= l_II1IlllIll_22 then
    I_lIl111IlI1_4()
  end

  local l_III1II1111_1d = table.concat(I_1lI1III_1a)
  local I_1l1lIl1Il_26 = 1
  local function I_l1lIl1IlI1_27()
    local v = string.byte(l_III1II1111_1d, I_1l1lIl1Il_26)
    I_1l1lIl1Il_26 = I_1l1lIl1Il_26 + 1
    return v
  end

  local function l_lIlIl1_28()
    local b1, b2 = string.byte(l_III1II1111_1d, I_1l1lIl1Il_26, I_1l1lIl1Il_26 + 1)
    I_1l1lIl1Il_26 = I_1l1lIl1Il_26 + 2
    return b1 + b2 * 256
  end

  local function I_l1lII1l_29()
    local b1, b2, b3, b4 = string.byte(l_III1II1111_1d, I_1l1lIl1Il_26, I_1l1lIl1Il_26 + 3)
    I_1l1lIl1Il_26 = I_1l1lIl1Il_26 + 4
    local v = b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    if v >= 2147483648 then v = v - 4294967296 end
    return v
  end

  local function I_I111I11l_2a()
    local len = I_l1lII1l_29()
    if len <= 0 then return "" end
    local chunks = {}
    local cur = {}
    local cLen = 0
    for i = 1, len do
      local b = string.byte(l_III1II1111_1d, I_1l1lIl1Il_26)
      I_1l1lIl1Il_26 = I_1l1lIl1Il_26 + 1
      cLen = cLen + 1
      cur[cLen] = string.char((b - 63 - i * 7) % 256)
      if cLen >= 1024 then
        chunks[#chunks + 1] = table.concat(cur)
        cur = {}
        cLen = 0
      end
    end
    if cLen > 0 then
      chunks[#chunks + 1] = table.concat(cur)
    end
    return table.concat(chunks)
  end

  local function I_1lIllIllI_2b()
    local proto = {}
    proto.p = I_l1lIl1IlI1_27()
    proto.v = I_l1lIl1IlI1_27()
    proto.max = I_l1lIl1IlI1_27()

    local numInst = l_lIlIl1_28()
    local code = {}
    for i = 1, numInst do
      local op = I_l1lIl1IlI1_27()
      local a = I_l1lIl1IlI1_27()
      local b = l_lIlIl1_28()
      local c = l_lIlIl1_28()
      local bx = I_l1lII1l_29()
      local sbx = I_l1lII1l_29()
      code[i] = { op, a, b, c, bx, sbx }
    end
    proto.i = code

    local numConst = l_lIlIl1_28()
    local consts = {}
    for i = 1, numConst do
      local tag = I_l1lIl1IlI1_27()
      if tag == 0 then
        consts[i] = nil
      elseif tag == 1 then
        consts[i] = false
      elseif tag == 2 then
        consts[i] = true
      elseif tag == 3 then
        local rawInt = I_l1lII1l_29()
        consts[i] = math.floor((rawInt - 244) / 29)
      elseif tag == 4 then
        local rawNumStr = I_I111I11l_2a()
        consts[i] = tonumber(rawNumStr)
      elseif tag == 5 then
        consts[i] = I_I111I11l_2a()
      end
    end
    proto.c = consts

    local numUpvals = l_lIlIl1_28()
    local upvals = {}
    for i = 1, numUpvals do
      upvals[i] = { I_l1lIl1IlI1_27(), I_l1lIl1IlI1_27() }
    end
    proto.u = upvals

    local numChild = l_lIlIl1_28()
    local childProtos = {}
    for i = 1, numChild do
      childProtos[i] = I_1lIllIllI_2b()
    end
    proto.s = childProtos

    return proto
  end

  local I_lIll11l1I1_2c = I_1lIllIllI_2b()

  local function l_I1III1_2d(l_1II1l1I_2e, l_I1I1IIlI_2f, ...)
    local l_ll1llIlII_30 = { ... }
    local l_IIIlIIIIII_31 = {}
    local I_IIl1l1_32 = 0
    local l_11lIII1_33 = 1
    local l_ll1llIl1_34 = l_1II1l1I_2e.i
    local I_II1IlI1ll_35 = l_1II1l1I_2e.c
    local l_l11lllll11_36 = l_1II1l1I_2e.s
    local l_I11III_37 = {}

    local function I_1I11Il1_38(u)
      if u.open then
        return u.stk[u.reg]
      else
        return u.val
      end
    end

    local function l_lllII111_39(u, val)
      if u.open then
        u.stk[u.reg] = val
      else
        u.val = val
      end
    end

    local function I_I1llllll1_3a(limit)
      for reg, upval in pairs(l_I11III_37) do
        if reg >= limit then
          upval.val = l_IIIlIIIIII_31[reg]
          upval.open = false
          upval.stk = nil
          l_I11III_37[reg] = nil
        end
      end
    end

    for i = 0, l_1II1l1I_2e.p - 1 do
      l_IIIlIIIIII_31[i] = l_ll1llIlII_30[i + 1]
    end
    I_IIl1l1_32 = l_1II1l1I_2e.p - 1

    local function l_lIII1I1llI_3b(child_proto)
      local captured = {}
      for idx, udef in ipairs(child_proto.u) do
        if udef[1] == 1 then
          local reg = udef[2]
          if not l_I11III_37[reg] then
            local slot = { open = true, reg = reg, stk = l_IIIlIIIIII_31 }
            l_I11III_37[reg] = slot
            captured[idx] = slot
          else
            captured[idx] = l_I11III_37[reg]
          end
        else
          captured[idx] = l_I1I1IIlI_2f[udef[2] + 1]
        end
      end
      return function(...)
        return l_I1III1_2d(child_proto, captured, ...)
      end
    end

    while true do
      local I_Il1l1l_3c = l_ll1llIl1_34[l_11lIII1_33]
      if not I_Il1l1l_3c then break end
      l_11lIII1_33 = l_11lIII1_33 + 1

      local l_Il1Il11_3d = I_Il1l1l_3c[1]
      local l_II111III_3e = I_Il1l1l_3c[2]
      local I_l1lIIll11_3f = I_Il1l1l_3c[3]
      local l_IlI1lIllll_40 = I_Il1l1l_3c[4]
      local I_llll11_41 = I_Il1l1l_3c[5]
      local I_llIIIIl_42 = I_Il1l1l_3c[6]

      if l_Il1Il11_3d <= 28 then
        if ((math.floor(2.7) == 2)) and (l_Il1Il11_3d <= 13) then
          if l_Il1Il11_3d <= 6 then
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 2) then
              if l_Il1Il11_3d == 0 then
                l_IIIlIIIIII_31[l_II111III_3e] = {}
              elseif l_Il1Il11_3d == 1 then
                local _s = l_IIIlIIIIII_31[I_l1lIIll11_3f]; for _i = I_l1lIIll11_3f + 1, l_IlI1lIllll_40 do _s = _s .. l_IIIlIIIIII_31[_i] end; l_IIIlIIIIII_31[l_II111III_3e] = _s
              else
                local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = l_llI11lI1I_3.bor(_b, _c)
              end
            else
              if l_Il1Il11_3d <= 4 then
                if l_Il1Il11_3d == 3 then
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = _b * _c
                else
                  l_IIIlIIIIII_31[l_II111III_3e] = l_IIIlIIIIII_31[I_l1lIIll11_3f]
                end
              else
                if l_Il1Il11_3d == 5 then
                  local _nx = l_ll1llIl1_34[l_11lIII1_33]; l_11lIII1_33 = l_11lIII1_33 + 1; l_IIIlIIIIII_31[l_II111III_3e] = I_II1IlI1ll_35[_nx[5] + 1]
                else
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = l_llI11lI1I_3.rshift(_b, _c)
                end
              end
            end
          else
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 9) then
              if l_Il1Il11_3d == 7 then
                local _k = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; local _t = I_1I11Il1_38(l_I1I1IIlI_2f[I_l1lIIll11_3f + 1]); local _res = _t and _t[_k]; if _res == nil and _G then _res = _G[_k] end; l_IIIlIIIIII_31[l_II111III_3e] = _res
              elseif l_Il1Il11_3d == 8 then
                local _step = l_IIIlIIIIII_31[l_II111III_3e + 2]; local _idx = l_IIIlIIIIII_31[l_II111III_3e] + _step; l_IIIlIIIIII_31[l_II111III_3e] = _idx; local _limit = l_IIIlIIIIII_31[l_II111III_3e + 1]; if (_step > 0 and _idx <= _limit) or (_step <= 0 and _idx >= _limit) then l_11lIII1_33 = l_11lIII1_33 + I_llIIIIl_42; l_IIIlIIIIII_31[l_II111III_3e + 3] = _idx end
              else
                if (not not l_IIIlIIIIII_31[l_II111III_3e]) ~= (l_IlI1lIllll_40 ~= 0) then l_11lIII1_33 = l_11lIII1_33 + 1 end
              end
            else
              if l_Il1Il11_3d <= 11 then
                if l_Il1Il11_3d == 10 then
                  local _cnt = (I_l1lIIll11_3f == 0) and #l_ll1llIlII_30 or (I_l1lIIll11_3f - 1); for _i = 1, _cnt do l_IIIlIIIIII_31[l_II111III_3e + _i - 1] = l_ll1llIlII_30[_i] end; if I_l1lIIll11_3f == 0 then I_IIl1l1_32 = l_II111III_3e + #l_ll1llIlII_30 - 1 end
                else
                  local _k = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = l_IIIlIIIIII_31[I_l1lIIll11_3f][_k]
                end
              else
                if l_Il1Il11_3d == 12 then
                  l_lllII111_39(l_I1I1IIlI_2f[I_l1lIIll11_3f + 1], l_IIIlIIIIII_31[l_II111III_3e])
                else
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; if (_b <= _c) ~= (l_II111III_3e ~= 0) then l_11lIII1_33 = l_11lIII1_33 + 1 end
                end
              end
            end
          end
        else
          if l_Il1Il11_3d <= 21 then
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 17) then
              if l_Il1Il11_3d == 14 then
                if (not not l_IIIlIIIIII_31[I_l1lIIll11_3f]) ~= (l_IlI1lIllll_40 ~= 0) then l_11lIII1_33 = l_11lIII1_33 + 1 else l_IIIlIIIIII_31[l_II111III_3e] = l_IIIlIIIIII_31[I_l1lIIll11_3f] end
              elseif l_Il1Il11_3d == 16 then
                local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = l_llI11lI1I_3.bxor(_b, _c)
              else
                l_IIIlIIIIII_31[l_II111III_3e] = #l_IIIlIIIIII_31[I_l1lIIll11_3f]
              end
            else
              if l_Il1Il11_3d <= 19 then
                if l_Il1Il11_3d == 18 then
                  l_IIIlIIIIII_31[l_II111III_3e] = not l_IIIlIIIIII_31[I_l1lIIll11_3f]
                else
                  local _k = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _v = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e][_k] = _v
                end
              else
                if l_Il1Il11_3d == 20 then
                  l_IIIlIIIIII_31[l_II111III_3e] = l_lIII1I1llI_3b(l_l11lllll11_36[I_llll11_41 + 1])
                else
                  l_IIIlIIIIII_31[l_II111III_3e] = I_II1IlI1ll_35[I_llll11_41 + 1]
                end
              end
            end
          else
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 24) then
              if l_Il1Il11_3d == 22 then
                local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = _b - _c
              elseif l_Il1Il11_3d == 23 then
                l_IIIlIIIIII_31[l_II111III_3e] = -l_IIIlIIIIII_31[I_l1lIIll11_3f]
              else
                local _o = l_IIIlIIIIII_31[I_l1lIIll11_3f]; l_IIIlIIIIII_31[l_II111III_3e + 1] = _o; local _k = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = _o[_k]
              end
            else
              if l_Il1Il11_3d <= 26 then
                if l_Il1Il11_3d == 25 then
                  for _i = l_II111III_3e, l_II111III_3e + I_l1lIIll11_3f do l_IIIlIIIIII_31[_i] = nil end
                else
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = l_llI11lI1I_3.lshift(_b, _c)
                end
              else
                if l_Il1Il11_3d == 27 then
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = math.floor(_b / _c)
                else
                  l_IIIlIIIIII_31[l_II111III_3e] = l_llI11lI1I_3.bnot(l_IIIlIIIIII_31[I_l1lIIll11_3f])
                end
              end
            end
          end
        end
      else
        if ((math.floor(2.7) == 2)) and (l_Il1Il11_3d <= 42) then
          if l_Il1Il11_3d <= 35 then
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 31) then
              if l_Il1Il11_3d == 29 then
                local _iter = l_IIIlIIIIII_31[l_II111III_3e]; local _state = l_IIIlIIIIII_31[l_II111III_3e + 1]; local _var = l_IIIlIIIIII_31[l_II111III_3e + 2]; local _rets = { _iter(_state, _var) }; for _i = 1, l_IlI1lIllll_40 do l_IIIlIIIIII_31[l_II111III_3e + 2 + _i] = _rets[_i] end; I_IIl1l1_32 = l_II111III_3e + 2 + l_IlI1lIllll_40
              elseif l_Il1Il11_3d == 30 then
                l_IIIlIIIIII_31[l_II111III_3e] = I_1I11Il1_38(l_I1I1IIlI_2f[I_l1lIIll11_3f + 1])
              else
                local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = l_llI11lI1I_3.band(_b, _c)
              end
            else
              if l_Il1Il11_3d <= 33 then
                if l_Il1Il11_3d == 32 then
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; if (_b < _c) ~= (l_II111III_3e ~= 0) then l_11lIII1_33 = l_11lIII1_33 + 1 end
                else
                  if l_IIIlIIIIII_31[l_II111III_3e + 1] ~= nil then l_IIIlIIIIII_31[l_II111III_3e] = l_IIIlIIIIII_31[l_II111III_3e + 1]; l_11lIII1_33 = l_11lIII1_33 + I_llIIIIl_42 end
                end
              else
                if l_Il1Il11_3d == 34 then
                  local _rets = {}; local _nr = (I_l1lIIll11_3f == 0) and (I_IIl1l1_32 - l_II111III_3e + 1) or (I_l1lIIll11_3f - 1); for _i = 1, _nr do _rets[_i] = l_IIIlIIIIII_31[l_II111III_3e + _i - 1] end; I_I1llllll1_3a(0); return l_I1I1111l_2(_rets, 1, _nr)
                else
                  local _fn = l_IIIlIIIIII_31[l_II111III_3e]; local _args = {}; local _na = (I_l1lIIll11_3f == 0) and (I_IIl1l1_32 - l_II111III_3e) or (I_l1lIIll11_3f - 1); for _i = 1, _na do _args[_i] = l_IIIlIIIIII_31[l_II111III_3e + _i] end; local _rets = { _fn(l_I1I1111l_2(_args, 1, _na)) }; if l_IlI1lIllll_40 == 0 then I_IIl1l1_32 = l_II111III_3e + #_rets - 1; for _i = 1, #_rets do l_IIIlIIIIII_31[l_II111III_3e + _i - 1] = _rets[_i] end else for _i = 1, l_IlI1lIllll_40 - 1 do l_IIIlIIIIII_31[l_II111III_3e + _i - 1] = _rets[_i] end; I_IIl1l1_32 = l_II111III_3e + l_IlI1lIllll_40 - 2 end
                end
              end
            end
          else
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 38) then
              if l_Il1Il11_3d == 36 then
                local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = _b + _c
              elseif l_Il1Il11_3d == 37 then
                local _fn = l_IIIlIIIIII_31[l_II111III_3e]; local _args = {}; local _na = (I_l1lIIll11_3f == 0) and (I_IIl1l1_32 - l_II111III_3e) or (I_l1lIIll11_3f - 1); for _i = 1, _na do _args[_i] = l_IIIlIIIIII_31[l_II111III_3e + _i] end; I_I1llllll1_3a(0); return _fn(l_I1I1111l_2(_args, 1, _na))
              else
                local _cnt = (I_l1lIIll11_3f == 0) and (I_IIl1l1_32 - l_II111III_3e) or I_l1lIIll11_3f; local _c = (l_IlI1lIllll_40 == 0) and 1 or l_IlI1lIllll_40; local _off = (_c - 1) * 50; for _i = 1, _cnt do l_IIIlIIIIII_31[l_II111III_3e][_off + _i] = l_IIIlIIIIII_31[l_II111III_3e + _i] end
              end
            else
              if l_Il1Il11_3d <= 40 then
                if l_Il1Il11_3d == 39 then
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = _b ^ _c
                else
                  l_IIIlIIIIII_31[l_II111III_3e] = (I_l1lIIll11_3f ~= 0); if l_IlI1lIllll_40 ~= 0 then l_11lIII1_33 = l_11lIII1_33 + 1 end
                end
              else
                if l_Il1Il11_3d == 41 then
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = _b / _c
                else
                  l_11lIII1_33 = l_11lIII1_33 + I_llIIIIl_42; if l_II111III_3e > 0 then I_I1llllll1_3a(l_II111III_3e - 1) end
                end
              end
            end
          end
        else
          if l_Il1Il11_3d <= 82 then
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 45) then
              if l_Il1Il11_3d == 43 then
                local _k = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _v = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; local _t = I_1I11Il1_38(l_I1I1IIlI_2f[l_II111III_3e + 1]); _t[_k] = _v
              elseif l_Il1Il11_3d == 44 then
                local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; l_IIIlIIIIII_31[l_II111III_3e] = _b % _c
              else
                local _init = l_IIIlIIIIII_31[l_II111III_3e]; local _step = l_IIIlIIIIII_31[l_II111III_3e + 2]; l_IIIlIIIIII_31[l_II111III_3e] = _init - _step; l_11lIII1_33 = l_11lIII1_33 + I_llIIIIl_42
              end
            else
              if l_Il1Il11_3d <= 63 then
                if l_Il1Il11_3d == 46 then
                  local _b = (I_l1lIIll11_3f >= 256) and I_II1IlI1ll_35[I_l1lIIll11_3f - 255] or l_IIIlIIIIII_31[I_l1lIIll11_3f]; local _c = (l_IlI1lIllll_40 >= 256) and I_II1IlI1ll_35[l_IlI1lIllll_40 - 255] or l_IIIlIIIIII_31[l_IlI1lIllll_40]; if (_b == _c) ~= (l_II111III_3e ~= 0) then l_11lIII1_33 = l_11lIII1_33 + 1 end
                else
                  local _t = l_IIIlIIIIII_31[I_l1lIIll11_3f]; if type(_t) == "table" then _t[l_II111III_3e] = false end
                end
              else
                if l_Il1Il11_3d == 80 then
                  l_IIIlIIIIII_31[l_II111III_3e] = not (l_IIIlIIIIII_31[I_l1lIIll11_3f] == nil)
                else
                  local _t = l_IIIlIIIIII_31[I_l1lIIll11_3f]; if type(_t) == "table" then _t[l_II111III_3e] = false end
                end
              end
            end
          else
            if ((math.abs(-5) == 5)) and (l_Il1Il11_3d <= 141) then
              if l_Il1Il11_3d <= 104 then
                if l_Il1Il11_3d == 83 then
                  l_IIIlIIIIII_31[l_II111III_3e] = (l_IIIlIIIIII_31[I_l1lIIll11_3f] or 0) * 0x3d + 1
                else
                  l_IIIlIIIIII_31[l_II111III_3e] = not (l_IIIlIIIIII_31[I_l1lIIll11_3f] == nil)
                end
              else
                if l_Il1Il11_3d == 129 then
                  l_IIIlIIIIII_31[l_II111III_3e] = (l_IIIlIIIIII_31[I_l1lIIll11_3f] or 0) * 0x3d + 1
                else
                  if l_IIIlIIIIII_31[l_II111III_3e] == nil then l_IIIlIIIIII_31[l_II111III_3e] = 0 end
                end
              end
            else
              if l_Il1Il11_3d <= 209 then
                if l_Il1Il11_3d == 148 then
                  local _acc = (l_IIIlIIIIII_31[I_l1lIIll11_3f] or 1); for _k = 1, 3 do _acc = (_acc * 17) % 65536 end; l_IIIlIIIIII_31[l_II111III_3e] = _acc
                else
                  local _d = (l_IIIlIIIIII_31[I_l1lIIll11_3f] or 0) % 256; l_IIIlIIIIII_31[l_II111III_3e] = _d
                end
              else
                if l_Il1Il11_3d == 214 then
                  local _d = (l_IIIlIIIIII_31[I_l1lIIll11_3f] or 0) % 256; l_IIIlIIIIII_31[l_II111III_3e] = _d
                else
                  if l_IIIlIIIIII_31[l_II111III_3e] == nil then l_IIIlIIIIII_31[l_II111III_3e] = 0 end
                end
              end
            end
          end
        end
      end
    end
  end

  local I_llIlIlll_43 = { val = I_IlIl1l1_1, open = false }
  return l_I1III1_2d(I_lIll11l1I1_2c, { I_llIlIlll_43 }, ...)
end)(...)
