-- This file was generated at discord.gg/syncrypt

local v160, v164, v166
local v161 = function(arg11_1, arg11_2, arg11_3, arg11_4, arg11_5, arg11_6, arg11_7, arg11_8, arg11_9, arg11_10, arg11_11, arg11_12, arg11_13, arg11_14, arg11_15, arg11_16)
    local up4
    local up6 = arg11_1
    local up9
    local up10
    local up11
    local up12
    local v109 = function(arg2_1)
        local v45 = arg2_1
        local v46 = up4
        local v49 = (up4[v45] - 1)
        v46[v45] = v49
        if (0 == up4[v45]) then
            v46 = up4
            v49 = up10
            v46[v45] = nil
            v49[v45] = nil
        end
        return
    end
    local v111 = function(arg3_1, arg3_2, arg3_3, arg3_4)
        local v50, v51, v58, v63
        v50, v51 = arg3_4, arg3_1
        local v53
        while true do
            if not v51 then
                break
            end
            up6.print("1")
            v63 = up6.B5dxCkORDvY85F
            v58 = {}
            v53, v51 = v58, v63
        end
        local v62 = (#v50)
        return up11(v53)
    end
    up11 = arg11_3
    local v112 = function(arg4_1, arg4_2)
        local up1 = arg4_1
        local up2 = arg4_2
        local v66 = up9(up2)
        local up3
        local v64 = function(...)
            local v143 = {...}

            return up12(up1, v143, up2, up3)
        end
        up3 = v66
        return v64
    end
    local up7 = arg11_4
    local up13 = arg11_6
    local up5 = arg11_7
    local v113 = function(arg5_1)
        local v67, v68, v70, v71, v73
        v67, v68 = arg5_1, 1
        local v69 = v67[v68]
        v70, v71 = 1, v69
        v68 = v70
        while true do
            if not v71 then
                break
            end
            v70 = up4
            v69 = (up4[v71] - 1)
            v73 = (1 + v68)
            v70[v71] = v69
            v68 = v73
            if (up4[v71] == 0) then
                v70 = up4
                v69 = up10
                v70[v71] = nil
                v69[v71] = nil
            end
            v71 = v67[v68]
        end
        return
    end
    local up8 = arg11_8
    up4 = arg11_11
    local up14 = arg11_14
    up10 = {}
    local v115 = function()
        up14 = (1 + up14)
        up4[up14] = 1
        return up14
    end
    up9 = function(arg7_1)
        local v78, v81, v82, v83, v84, v88, v89
        local v77 = arg7_1
        local v79 = (#v77)
        local v80 = 1
        for v78 = 1, v79, v80 do
            v84 = up4
            v82 = v77[v78]
            v88 = (1 + up4[v77[v78]])
            v84[v82] = v88
        end
        if up5 then
            v78 = (up5(true))
            v79 = (up13(v78))
            v83 = up8
            v88 = function()
                return 2853702
            end
            v79.__index = v77
            v79.__gc = v83
            v79.__len = v88
            return v78
        else
            v78 = {}
            v84 = up7
            v81 = up8
            v89 = function()
                return 2853702
            end
            v79 = {["__gc"] = v81, ["__index"] = v77, ["__len"] = v89}

            return v84(v78, v79)
        end
    end
    up12 = v111
    up8 = v113
    up14 = 0
    up4 = {}
    local v118 = v112(6616647, {})
    return v118(up11(arg11_5))
end
local v169 = v160
local v168 = getfenv and (getfenv())
v164, v160 = v168, v169
if not (v168) then
    v164 = _ENV
end
v168, v160 = "select", v166
v166 = select
local v167 = unpack
v168 = v167
if not (v167) then
    v168 = table.unpack
end
v169 = setmetatable
v167 = {...}

return v161(v164, v166, v168, v169, v167, getmetatable, newproxy)
