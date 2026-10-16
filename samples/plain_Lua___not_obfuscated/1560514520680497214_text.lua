local function _w0(v1, v2)
    return function()
        local v3 = 242
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18
        repeat
            if v3 == 1 then
                v3, v14 = v3 + 112, v11.UpgradePending
                v8 = v14[v10]
                v17 = not v8
            elseif v3 == 23 then
                v3 = v17 and 1311 / v3 or 40
            elseif v3 == 86 then
                v7.Level = v15
                v7.Cost = v16.Price
                v15, v7, v9 = v6.Id, v11.UpgradePending, v7
                v7[v15] = v9
                v5 = v6.Id
                v7, v15 = v2[1][2].Fire("TowerUpgrade", {Id = v5})
                v10 = not v7
                v3 = v10 and v3 + 25 or v3 + 167
            elseif v3 == 113 then
                v3 = v17 and 176 or 233 - v3
            elseif v3 == 140 then
                return true
            elseif v3 == 141 then
                v17 = not v13
                v3 = v17 and 254 or 280 - v3
            elseif v3 == 159 then
                v3, v8 = 182 - v3, v11.Busy
                v8 = v8()
                v17 = not v8
            elseif v3 == 198 then
                v16 = v1._.table.sort
                v9 = v1:Gc()
                v16(v4, v9)
                v16 = v4[1]
                v6 = not v16
                v3 = v6 and 16 or 170
            elseif v3 == 228 then
                v11 = v2[1][2].Auto
                v12 = v11.Budget()
                v4 = {}
                v16 = v1._.ipairs
                v6 = v2[1][2].Owned
                v6 = v1.h(v6())
                v16, v6, v9 = v16(v1.i(v6))
                v16, v6, v9 = v1.g(v16, v6, v9)
                v7, v15 = v16(v6, v9)
                v9 = v7
                v3 = v7 == nil and 198 or 9
            elseif v3 == 253 then
                v5 = v2[1][2]
                v13, v17, v8, v10, v5 = "Upgrading ", v6.Name, " | waiting for level confirmation", v5.SetStatus, "Auto"
                v18 = v17 .. " | waiting for level confirmation"
                v13 = "Upgrading " .. v18
                v3 = 393 - v3
                v10("Auto", v13)
            elseif v3 >= 229 and v3 <= 252 then
                v4 = v2[2][2]
                v12 = v4.AutoUpgrade
                v11 = not v12
                v3 = v11 and 88 or 228
            elseif v3 >= 177 and v3 <= 184 then
                v3 = v17 and 207 - v3 or 25944 / v3
            elseif v3 >= 185 and v3 <= 197 then
                v3, v14 = 41280 / v3, 0
            elseif v3 >= 199 and v3 <= 227 then
                v3, v17 = 335 - v3, v8 >= v14
            elseif v3 >= 142 and v3 <= 145 then
                v17 = v2[1][2].Wave()
                v3 = 25
                v8 = v5.Wave
                v18 = v17 ~= v8
            elseif v3 >= 146 and v3 <= 158 then
                v3, v17 = 333 - v3, v13 <= v12
            elseif v3 >= 160 and v3 <= 162 then
                v17 = v18
                v3 = v18 and 1 or 18306 / v3
            elseif v3 >= 163 and v3 <= 166 then
                v17 = v13
                v3 = v13 and 296 - v3 or 0
            elseif v3 >= 167 and v3 <= 170 then
                v7 = {}
                v6 = v16.Tower
                v7.At = v1._.os.clock()
                v10 = v6.Level
                v15 = v1._.tonumber(v10)
                v3 = v15 and 86 or 116
            elseif v3 >= 171 and v3 <= 176 then
                v8 = v1._.os.clock()
                v14 = v11.TowerCooldowns[v10]
                v3 = v14 and 37840 / v3 or 192
            elseif v3 >= 78 and v3 <= 85 then
                v8 = v5.Level
                v17 = v15.Level
                v3, v18 = 2436 / v3, v17 ~= v8
            elseif v3 >= 87 and v3 <= 88 then
                return false
            elseif v3 >= 89 and v3 <= 112 then
                v3 = 140
                v11.UpgradePending[v6.Id] = nil
                v17 = 2
                v11.TowerCooldowns[v6.Id] = v1._.os.clock() + 2
                v5 = v2[1][2]
                v13, v18, v5, v10 = v1._.tostring, v15, "Auto", v5.SetStatus
                v13 = table.pack(v13(v18))
                v10("Auto", table.unpack(v13, 1, v13.n))
            elseif v3 >= 131 and v3 <= 139 then
                v3 = v17 and 159 or 23
            elseif v3 >= 121 and v3 <= 130 then
                v8 = 0
                v3, v17 = 0 / v3, v13 > 0
            elseif v3 >= 117 and v3 <= 120 then
                v3 = v17 and 166 or 23
            elseif v3 >= 114 and v3 <= 116 then
                v3 = 86
                v15 = 1
            elseif v3 >= 24 and v3 <= 25 then
                v3 = v18 and 162 or 77
            elseif v3 >= 16 and v3 <= 22 then
                return false
            elseif v3 <= 0 then
                v3 = v17 and 149 or 184 - v3
            elseif v3 >= 2 and v3 <= 15 then
                v10 = v15.Id
                v5 = v11.Failures[v10]
                v13 = v2[1][2].UpgradeCost(v15)
                v18 = not v5
                v3 = v18 and 29 or 84
            elseif v3 >= 26 and v3 <= 29 then
                v3 = v18 and 25 or 145
            elseif v3 >= 30 and v3 <= 40 then
                v7, v15 = v16(v6, v9)
                v9 = v7
                v3 = v7 == nil and 7920 / v3 or 9
            elseif v3 >= 41 and v3 <= 57 then
                v3, v8 = v3 + -17, v1._.table
                v8, v14, v17 = v4, {}, v8.insert
                v14.Tower = v15
                v14.Price = v13
                v17(v8, v14)
            elseif v3 >= 58 and v3 <= 77 then
                v17 = v2[1][2].Cash()
                v14 = v5.Cash
                v8 = v14 + 100
                v3 = 162
                v18 = v17 > v8
            else
                v8 = 0
                v3, v17 = 35306 / v3, v12 > 0
            end
        until false
    end
end
local function _w1(v1, v2)
    return function(v3, v4)
        local v5 = 205
        local v6, v7, v8, v9, v10
        repeat
            if v5 == 15 then
                v5 = 83
                v6 = v2[1][2]
                v7 = v6.Recording
                v9 = not v7
            elseif v5 == 52 then
                v5 = v9 and 57 - v5 or 6240 / v5
            elseif v5 == 193 then
                v5 = 107
                v10 = nil
            elseif v5 == 205 then
                v9 = v3
                v5 = v3 and 208 or 52
            elseif v5 == 206 then
                v5 = 249
                v7 = 0
            elseif v5 == 244 then
                v10 = v2[1][2]
                v6 = v10.Next
                v7 = v6.AutoPlayback
                v5 = v7 and 60756 / v5 or 450 - v5
            elseif v5 >= 221 and v5 <= 238 then
                v5 = 115
                v8 = 10
            elseif v5 >= 209 and v5 <= 220 then
                v5 = v9 and 464 - v5 or v5 + -16
            elseif v5 >= 239 and v5 <= 243 then
                return
            elseif v5 >= 194 and v5 <= 195 then
                v6 = v2[1][2]
                v7 = v6.Playing
                v5 = 220
                v9 = not v7
            elseif v5 >= 145 and v5 <= 192 then
                v5 = v8 and 16675 / v5 or 229
            elseif v5 >= 196 and v5 <= 204 then
                v5 = v9 and 4284 / v5 or 443 - v5
            elseif v5 >= 207 and v5 <= 208 then
                v7 = v2[2][2]
                v5, v9 = 10816 / v5, v7.AutoPlayback
            elseif v5 >= 116 and v5 <= 144 then
                v5 = v9 and v5 + -105 or 9960 / v5
            elseif v5 >= 108 and v5 <= 115 then
                v6.AutoPlayback = v4 + v8
                v10 = v9
                v6 = v2[1][2]
                v5 = v9 and 72 or 49
            elseif v5 >= 73 and v5 <= 83 then
                v5 = v9 and 16185 / v5 or v5 + 137
            elseif v5 >= 53 and v5 <= 72 then
                v5 = v10 and 107 or 265 - v5
            elseif v5 >= 84 and v5 <= 107 then
                v5, v6.AutoPlayed = 346 - v5, v10
            elseif v5 >= 22 and v5 <= 49 then
                v8 = "wait"
                v5, v10 = 121 - v5, v7 ~= "wait"
            elseif v5 <= 14 then
                v5 = 120
                v6 = v2[1][2]
                v7 = v6.AutoPlayed
                v9 = not v7
            elseif v5 >= 16 and v5 <= 21 then
                v9, v7 = v2[1][2].StartPlayback()
                v10 = v2[1][2]
                v6 = v10.Next
                v8 = v7 == "wait"
                v5 = v8 and 51 or 145
            elseif v5 >= 50 and v5 <= 51 then
                v5 = 145
                v8 = 0.3
            else
                v5, v9 = 50796 / v5, v4 >= v7
            end
        until false
    end
end
local function _w2(v1)
    return function(v2, v3)
        local v4 = v2.Id
        return v1._.tostring(v4) < v1._.tostring(v3.Id)
    end
end
local function _w3(v1, v2)
    return function(v3, v4)
        local v5 = ""
        local v6 = 0
        local v7 = #v3 - 1
        local v8, v9, v10, v11
        if 0 <= v7 then
            while true do
                v10 = v2[2][2]
                v9 = v2[3][2]
                v8 = v2[1][2](v3, v6 + 1)
                v11 = v2[1][2]
                v11 = table.pack(v11(v4, v6 % #v4 + 1))
                v9 = table.pack(v9(v8, table.unpack(v11, 1, v11.n)))
                v5 = v5 .. v10(table.unpack(v9, 1, v9.n))
                v6 = v6 + 1
                if v6 > v7 then
                    break
                end
            end
        end
        return v5
    end
end
local function _w4(v1, v2)
    return function(elevator, v3)
        local v4 = v2[1][2]
        v4.Elevator = elevator
        v4.ModifierAppliedKey = nil
        local v5
        v5, v4 = nil, v4.Next
        v4.Modifiers = nil
        v4 = v2[1][2]
        v4.IsHost = v3 == true
        v4.StartRequested = nil
    end
end
local function _w5(v1, v2)
    return function()
        local v3 = 172
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
        while true do
            if v3 == 5 then
                v8 = v1._.type(v5)
                v20 = "string"
                v3 = v8 == "string" and v3 + 199 or 64
            elseif v3 == 155 then
                v17 = v11:GetChildren()
                v13 = v1._.table
                v7, v15, v13 = v1:Ec(), v13.sort, v17
                v15(v13, v7)
                v15 = {}
                v13, v7, v5 = v1._.ipairs(v17)
                v13, v7, v5 = v1.g(v13, v7, v5)
                v8, v20 = v13(v7, v5)
                v5 = v8
                v3 = v8 == nil and v3 + 60 or 129
            elseif v3 == 172 then
                v6 = v2[1][2]:FindFirstChild("Game")
                v13 = {}
                v11 = v1._.ipairs
                v5 = "MapName"
                v13[1], v13[2] = "Map", "MapName"
                v11, v17, v15 = v11(v13)
                v11, v17, v15 = v1.g(v11, v17, v15)
                v13, v7 = v11(v17, v15)
                v15 = v13
                v3 = v13 == nil and 247 or 4
            elseif v3 == 215 then
                v7 = 0
                v13 = #v15
                v3 = v13 > 0 and 156 or v3 + -179
            elseif v3 >= 31 and v3 <= 36 then
                return nil
            elseif v3 >= 37 and v3 <= 64 then
                v13, v7 = v11(v17, v15)
                v15 = v13
                v3 = v13 == nil and 247 or 4
            elseif v3 >= 6 and v3 <= 30 then
                v8, v20 = v13(v7, v5)
                v5 = v8
                v3 = v8 == nil and 6450 / v3 or 159 - v3
            elseif v3 <= 4 then
                v5 = v6
                v3 = v6 and 224 or 5
            elseif v3 >= 130 and v3 <= 154 then
                v17 = v6
                v15 = "Waypoints"
                v3 = 214
                v11 = v6:FindFirstChild("Waypoints")
            elseif v3 >= 126 and v3 <= 129 then
                v19 = v20:IsA("BasePart")
                v3 = v19 and 125 or 30
            elseif v3 >= 65 and v3 <= 125 then
                v12 = v1._.table
                v19 = v20.Position
                v10, v9, v12 = v1._.string, v12.insert, v15
                v10, v18, v4, v14, v21, v16 = "%s:%.1f,%.1f,%.1f", v19.Y, v10.format, v19.Z, v19.X, v20.Name
                v4 = table.pack(v4("%s:%.1f,%.1f,%.1f", v16, v21, v18, v14))
                v3 = 155 - v3
                v9(v12, table.unpack(v4, 1, v4.n))
            elseif v3 >= 216 and v3 <= 224 then
                v3 = 5
                v20 = v7
                v5 = v6:GetAttribute(v7)
            elseif v3 >= 173 and v3 <= 204 then
                return v5
            elseif v3 >= 205 and v3 <= 214 then
                v3 = v11 and v3 + -59 or 250 - v3
            elseif v3 >= 156 and v3 <= 171 then
                v13 = v1._.table.concat
                v13 = table.pack(v13(v15, ";"))
                return table.unpack(v13, 1, v13.n)
            else
                v11 = v6
                v3 = v6 and 150 or 461 - v3
            end
        end
    end
end
local function _w6(v1, v2, v3, v4)
    v1.jf[v4] = -v3 + (bit32.bnot(bit32.band(bit32.bnot(v3), bit32.bnot(v2))) + (v2 + (bit32.band(bit32.bnot(v2), v3) + (bit32.band(bit32.bnot(bit32.band(65535, v3)), bit32.band(65535, v2)) * bit32.band(bit32.bnot(bit32.band(65535, v2)), bit32.band(65535, v3)) + bit32.band(bit32.band(v2, 65535), bit32.band(v3, 65535)) * bit32.bor(bit32.band(65535, v2), bit32.band(65535, v3)) - bit32.band(v3, 65535) * bit32.band(v2, 65535))) + -bit32.bxor(v3, bit32.bor(v3, v2))))
    return v1.jf[v4]
end
local function _w7(v1, v2, v3, v4, v5)
    v1.Re[v5] = bit32.band(bit32.bnot(bit32.band(v4, 65535)), bit32.band(65535, v4)) * bit32.band(bit32.bnot(bit32.band(v4, 65535)), bit32.band(v4, 65535)) + bit32.bor(bit32.band(65535, v4), bit32.band(65535, v4)) * bit32.band(bit32.band(65535, v4), bit32.band(65535, v4)) - bit32.band(65535, v4) * bit32.band(v4, 65535) + (bit32.bxor(bit32.band(v2, 4294967295), bit32.band(v3, v3)) + -v4)
    return v1.Re[v5]
end
local function _w8(v1, v2)
    return function()
        local v3 = 128
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
        repeat
            if v3 == 9 then
                v8 = v7[2].Level
                v5 = v1._.tonumber(v8)
                v3 = v5 and 171 or 2097 / v3
            elseif v3 == 10 then
                v5 = v5 + v12
                v3 = (v12 > 0 and v5 > v8 or v12 <= 0 and v5 < v8 or false) and 85 - v3 or 102
            elseif v3 == 88 then
                v3, v8 = 323 - v3, "WaveSkip"
            elseif v3 == 113 then
                v5 = 1
                v8 = 12
                v12 = 1
                v3 = 102
            elseif v3 == 118 then
                v3, v8 = 135 - v3, v2[3][2]
                v5 = v8.Towers
                v7 = v5[v20[2]]
            elseif v3 == 144 then
                v20 = v2[2][2]
                v8 = v2[3][2]
                v7 = v20
                v5 = v8.GameClock()
                v3, v20.Previous = 336 - v3, v4[2]
                v7.CompletedAt = v5
            elseif v3 == 149 then
                v2[11][2], v10 = "waiting for TowerTarget confirmation", v7[2].TargetMode
                v10 = {[1] = 2, [2] = v10}
                v10[3] = v10
                v6 = {}
                v16 = v2[3][2].Fire
                v6.Id = v20[2]
                v16, v18 = v16("TowerTarget", v6)
                v1._.assert(v16, v18)
                v13 = v2[3][2]
                v19, v9, v13, v6 = v2[8][2], 5, v1:ed({v20, v7, v10, v2[3]}), v13.WaitUntil
                v3 = 10
                v6, v13 = v6(v13, 5, v19)
                v21, v6, v14 = v13, v1._.assert, v6
                v6(v14, v21)
            elseif v3 == 170 then
                v3, v7 = v3 + 50, v2[3][2]
                v20, v5, v8, v7 = v7.WaitUntil, nil, v2[8][2], v1:hd({v2[4], v2[3], v2[10], v4, v2[2]})
                v20, v7 = v20(v7, nil, v8)
                v21, v14, v20 = v7, v20, v1._.assert
                v7 = v14
                v5 = "Playback condition not reached (wave / time / money)"
                v20(v14, "Playback condition not reached (wave / time / money)")
            elseif v3 == 177 then
                v3 = 155
                v8 = v4[2].Key
            elseif v3 == 178 then
                v8 = "Sell"
                v5 = v4[2].Kind
                v3 = v5 == "Sell" and 146 or 122
            elseif v3 == 233 then
                v3, v5 = v3 + -62, 1
            elseif v3 >= 129 and v3 <= 143 then
                v2[11][2], v7 = "waiting for recorded skip wave / vote", v2[3][2]
                v7, v5, v20 = v4[2], v2[8][2], v7.PlayRecordedSkip
                v20, v7 = v20(v7, v5)
                v21, v14, v20 = v7, v20, v1._.assert
                v5 = v21
                v7 = v14
                v3 = 278 - v3
                v20(v14, v21)
            elseif v3 >= 123 and v3 <= 128 then
                v15 = v2[9][2].Actions
                v11, v15, v17 = v1._.ipairs(v15)
                v11, v15, v17 = v1.g(v11, v15, v17)
                v22, v4 = v11(v15, v17)
                v17 = v22
                v3 = v22 == nil and 251 or 114
            elseif v3 >= 119 and v3 <= 122 then
                v3 = v3 + 22
            elseif v3 >= 91 and v3 <= 97 then
                v7 = "Skip"
                v20 = v4[2].Kind
                v3 = v20 == "Skip" and 134 or 90
            elseif v3 >= 98 and v3 <= 112 then
                v16 = v4[2].Target
                v10 = v7[2].TargetMode
                v3 = v10 == v16 and 7650 / v3 or 149
            elseif v3 >= 114 and v3 <= 117 then
                v4 = {[1] = 2, [2] = v4}
                v4[3] = v4
                v21 = "Action %d/%d | %s %s"
                v20 = v22
                v14 = v1._.string.format
                v5 = v2[9][2].Actions
                v8, v5, v7 = v4[2].Name, v4[2].Kind, #v5
                v3 = v8 and 155 or 177
            elseif v3 >= 18 and v3 <= 49 then
                v3, v10 = v3 + 115, v4[2].Name .. "; refresh loadout / equip the recorded unit"
                v12 = "Cannot resolve equipped unit: " .. v10
            elseif v3 >= 11 and v3 <= 17 then
                v7 = {[1] = 2, [2] = v7}
                v7[3] = v7
                v8 = v7[2]
                v12 = "Missing recorded tower " .. v4[2].Key
                v1._.assert(v8, v12)
                v8 = "Upgrade"
                v5 = v4[2].Kind
                v3 = v5 == "Upgrade" and 26 - v3 or v3 + 236
            elseif v3 <= 8 then
                v3, v5 = 106 / v3, 1
            elseif v3 >= 89 and v3 <= 90 then
                v5 = v4[2].Key
                v20 = {[1] = 2, [2] = v2[6][2][v5]}
                v20[3] = v20
                v7 = v20[2]
                v3 = v7 and 10620 / v3 or 107 - v3
            elseif v3 >= 50 and v3 <= 53 then
                v5 = {[1] = 2, [2] = v5}
                v5[3] = v5
                v2[11][2], v12 = "waiting for upgrade money", v2[3][2]
                v16, v10, v12, v18, v8 = v2[8][2], nil, v1:fd({v4, v2[3], v7}), v2[7][2], v12.WaitFunds
                v8, v12 = v8(v12, nil, v16, v18)
                v21, v14, v8 = v12, v8, v1._.assert
                v8(v14, v21)
                v12, v2[11][2] = v2[3][2], "sending upgrade"
                v3, v8, v10, v12 = 9, v12.Fire, {}, "TowerUpgrade"
                v10.Id = v20[2]
                v8, v12 = v8("TowerUpgrade", v10)
                v1._.assert(v8, v12)
                v16, v2[11][2] = v2[3][2], "waiting for TowerUpgrade confirmation"
                v6, v16, v18, v10 = v2[8][2], v1:kd({v20, v7, v5, v2[3]}), 10, v16.WaitUntil
                v10, v16 = v10(v16, 10, v6)
                v10, v21, v14 = v1._.assert, v16, v10
                v10(v14, "Upgrade unconfirmed; playback stopped")
            elseif v3 >= 54 and v3 <= 87 then
                v5 = v1._.assert
                v12 = "Target mode could not be reached"
                v8 = v7[2].TargetMode == v4[2].Target
                v3 = 122
                v5(v8, "Target mode could not be reached")
            elseif v3 >= 220 and v3 <= 232 then
                v20 = v4[2].Kind
                v7 = "Place"
                v3 = v20 == "Place" and 33440 / v3 or 97
            elseif v3 >= 234 and v3 <= 235 then
                v14 = v14(v21, v20, v7, v5, v8)
                v14, v2[7][2] = "waiting for playback condition", v14
                v2[11][2], v21 = "waiting for playback condition", v2[3][2]
                v14, v7, v21 = v21.SetStatus, v1._.string, "Macro"
                v8, v7, v20 = v2[5][2], "Playing %s: %d/%d | %s", v7.format
                v16, v5, v8 = v2[9][2], v8.Profile, v22
                v10 = v16.Actions
                v10, v12 = v4[2].Kind, #v10
                v20 = v1.h(v20("Playing %s: %d/%d | %s", v5, v8, v12, v10))
                v14("Macro", v1.i(v20))
                v14 = v2[3][2]
                v14.PlaybackIndex = v22
                v14.PlaybackTotal = #v2[9][2].Actions
                v14 = true
                v7 = "Money"
                v21 = nil
                v20 = v2[10][2]
                v3 = v20 ~= "Money" and 170 or 220
            elseif v3 >= 236 and v3 <= 251 then
                return
            elseif v3 >= 179 and v3 <= 192 then
                v22, v4 = v11(v15, v17)
                v17 = v22
                v3 = v22 == nil and 251 or v3 + -78
            elseif v3 >= 193 and v3 <= 219 then
                v8 = v7[2].Level
                v5 = v1._.tonumber(v8)
                v3 = v5 and 10759 / v3 or 2
            elseif v3 >= 171 and v3 <= 176 then
                v8 = v4[2].Level
                v3 = v5 < v8 and 34713 / v3 or 293 - v3
            elseif v3 >= 156 and v3 <= 169 then
                v5(v8, v12)
                v8, v2[11][2] = v2[3][2], "waiting for placement money"
                v8, v5, v12, v10, v16 = v1:gd({v20, v2[3], v4}), v8.WaitFunds, nil, v2[8][2], v2[7][2]
                v5, v8 = v5(v8, nil, v10, v16)
                v5, v21, v14 = v1._.assert, v8, v5
                v5(v14, v21)
                v8, v2[11][2] = v1._.CFrame, "sending placement"
                v8, v5, v12 = v1._.unpack, v8.new, v4[2].CFrame
                v8 = v1.h(v8(v12))
                v5 = v5(v1.i(v8))
                v12 = v2[3][2]
                v12, v16, v8, v10 = "TowerAdd", v4[2].Name, v12.Fire, {}
                v10.Name = v16
                v10.UnitId = v20[2]
                v10.Pos = v5.Position
                v10.CFrame = v5
                v8, v12 = v8("TowerAdd", v10)
                v1._.assert(v8, v12)
                v3, v10 = v3 + -20, "waiting for TowerAdd confirmation"
                v2[11][2], v16, v10 = "waiting for TowerAdd confirmation", nil, nil
                v10 = {[1] = 2, [2] = nil}
                v10[3] = v10
                v16 = {[1] = 2, [2] = nil}
                v16[3] = v16
                v6 = v2[3][2]
                v9, v18, v6, v13 = v2[8][2], v6.WaitUntil, v1:id({v2[3], v10, v4, v16, v2[1]}), 10
                v18, v6 = v18(v6, 10, v9)
                v18, v13, v21, v6, v14 = v1._.assert, v16[2], v6, not v16[2], v18
                v18(v6, v13)
                v18(v14, "Placement unconfirmed; stopped to avoid duplicate placements")
                v6 = v4[2].Key
                v2[6][2][v6] = v10[2].Id
                v2[1][2][v10[2].Id] = true
            elseif v3 >= 150 and v3 <= 152 then
                v7 = v4[2]
                v20, v7 = v2[3][2].ResolveUnit(v7)
                v20 = {[1] = 2, [2] = v20}
                v20[3] = v20
                v12 = v7
                v8 = v20[2]
                v5 = v1._.assert
                v3 = v7 and v3 + 12 or 7448 / v3
            elseif v3 >= 153 and v3 <= 155 then
                v3 = v8 and 390 - v3 or 243 - v3
            elseif v3 >= 145 and v3 <= 148 then
                v2[11][2], v8 = "waiting for TowerRemove confirmation", v2[3][2]
                v8, v12, v5 = "TowerSell", {}, v8.Fire
                v12.Id = v20[2]
                v5, v8 = v5("TowerSell", v12)
                v1._.assert(v5, v8)
                v10 = v2[3][2]
                v18, v12, v16, v10 = v2[8][2], v10.WaitUntil, 10, v1:jd({v20, v2[3]})
                v12, v10 = v12(v10, 10, v18)
                v21, v12, v3, v14 = v10, v1._.assert, 17812 / v3, v12
                v12(v14, v21)
            else
                v5 = v4[2].Kind
                v8 = "Target"
                v3 = v5 == "Target" and v3 + -140 or 178
            end
        until false
    end
end
local function _w9(v1, v2)
    return function()
        local v3, v4, gUI, v5, v6, v7, v8, gUI2
        if not v2[2][2].AutoSkip then
            while true do
            end
        elseif not v2[1][2].Active() then
            return
        else
            gUI = v2[1][2].GUI("Stats/WaveSkipGui")
            gUI2 = v2[1][2].GUI("Stats/WaveSkipGui/Title")
            if not v2[1][2].Visible(gUI) then
                return
            else
                v8 = gUI2
                if gUI2 then
                    v8 = gUI2.Text
                    if v8 then
                        v5, v7 = v8:match("(%d+)%s*/%s*(%d+)")
                    else
                        v5, v7 = (""):match("(%d+)%s*/%s*(%d+)")
                    end
                    v6 = v5
                    if v5 then
                        if v1._.tonumber(v7) > 0 then
                            if v1._.tonumber(v5) >= v1._.tonumber(v7) then
                                return
                            else
                                v4 = v2[1][2]
                                v6 = v4.Wave()
                                v4 = v4.Skip.LastWave
                                if v4 ~= v6 then
                                    v3 = v2[1][2]
                                    v3.Skip.LastWave = v6
                                    v4, v3 = v3.Skip, 0
                                    v4.NextAt = 0
                                    if v2[1][2].IsAutoSkipStopped(v6) then
                                        return
                                    elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                        return
                                    else
                                        v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                        v2[1][2].SendSkip("AutoSkip")
                                        return
                                    end
                                elseif v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                else
                                    if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                        v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                        v2[1][2].SendSkip("AutoSkip")
                                    end
                                    return
                                end
                            end
                        else
                            v4 = v2[1][2]
                            v6 = v4.Wave()
                            v4 = v4.Skip.LastWave
                            if v4 ~= v6 then
                                v3 = v2[1][2]
                                v3.Skip.LastWave = v6
                                v4, v3 = v3.Skip, 0
                                v4.NextAt = 0
                                if v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                    return
                                else
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                    return
                                end
                            elseif v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            else
                                if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                end
                                return
                            end
                        end
                    elseif v6 then
                        if v1._.tonumber(v5) >= v1._.tonumber(v7) then
                            return
                        else
                            v4 = v2[1][2]
                            v6 = v4.Wave()
                            v4 = v4.Skip.LastWave
                            if v4 ~= v6 then
                                v3 = v2[1][2]
                                v3.Skip.LastWave = v6
                                v4, v3 = v3.Skip, 0
                                v4.NextAt = 0
                                if v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                    return
                                else
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                    return
                                end
                            elseif v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            else
                                if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                end
                                return
                            end
                        end
                    else
                        v4 = v2[1][2]
                        v6 = v4.Wave()
                        v4 = v4.Skip.LastWave
                        if v4 ~= v6 then
                            v3 = v2[1][2]
                            v3.Skip.LastWave = v6
                            v4, v3 = v3.Skip, 0
                            v4.NextAt = 0
                            if v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                return
                            else
                                v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                v2[1][2].SendSkip("AutoSkip")
                                return
                            end
                        elseif v2[1][2].IsAutoSkipStopped(v6) then
                            return
                        else
                            if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                v2[1][2].SendSkip("AutoSkip")
                            end
                            return
                        end
                    end
                elseif v8 then
                    v5, v7 = v8:match("(%d+)%s*/%s*(%d+)")
                    v6 = v5
                    if v5 then
                        if v1._.tonumber(v7) > 0 then
                            if v1._.tonumber(v5) >= v1._.tonumber(v7) then
                                return
                            else
                                v4 = v2[1][2]
                                v6 = v4.Wave()
                                v4 = v4.Skip.LastWave
                                if v4 ~= v6 then
                                    v3 = v2[1][2]
                                    v3.Skip.LastWave = v6
                                    v4, v3 = v3.Skip, 0
                                    v4.NextAt = 0
                                    if v2[1][2].IsAutoSkipStopped(v6) then
                                        return
                                    elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                        return
                                    else
                                        v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                        v2[1][2].SendSkip("AutoSkip")
                                        return
                                    end
                                elseif v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                else
                                    if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                        v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                        v2[1][2].SendSkip("AutoSkip")
                                    end
                                    return
                                end
                            end
                        else
                            v4 = v2[1][2]
                            v6 = v4.Wave()
                            v4 = v4.Skip.LastWave
                            if v4 ~= v6 then
                                v3 = v2[1][2]
                                v3.Skip.LastWave = v6
                                v4, v3 = v3.Skip, 0
                                v4.NextAt = 0
                                if v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                    return
                                else
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                    return
                                end
                            elseif v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            else
                                if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                end
                                return
                            end
                        end
                    elseif v6 then
                        if v1._.tonumber(v5) >= v1._.tonumber(v7) then
                            return
                        else
                            v4 = v2[1][2]
                            v6 = v4.Wave()
                            v4 = v4.Skip.LastWave
                            if v4 ~= v6 then
                                v3 = v2[1][2]
                                v3.Skip.LastWave = v6
                                v4, v3 = v3.Skip, 0
                                v4.NextAt = 0
                                if v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                    return
                                else
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                    return
                                end
                            elseif v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            else
                                if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                end
                                return
                            end
                        end
                    else
                        v4 = v2[1][2]
                        v6 = v4.Wave()
                        v4 = v4.Skip.LastWave
                        if v4 ~= v6 then
                            v3 = v2[1][2]
                            v3.Skip.LastWave = v6
                            v4, v3 = v3.Skip, 0
                            v4.NextAt = 0
                            if v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                return
                            else
                                v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                v2[1][2].SendSkip("AutoSkip")
                                return
                            end
                        elseif v2[1][2].IsAutoSkipStopped(v6) then
                            return
                        else
                            if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                v2[1][2].SendSkip("AutoSkip")
                            end
                            return
                        end
                    end
                else
                    v5, v7 = (""):match("(%d+)%s*/%s*(%d+)")
                    v6 = v5
                    if v5 then
                        if v1._.tonumber(v7) > 0 then
                            if v1._.tonumber(v5) >= v1._.tonumber(v7) then
                                return
                            else
                                v4 = v2[1][2]
                                v6 = v4.Wave()
                                v4 = v4.Skip.LastWave
                                if v4 ~= v6 then
                                    v3 = v2[1][2]
                                    v3.Skip.LastWave = v6
                                    v4, v3 = v3.Skip, 0
                                    v4.NextAt = 0
                                    if v2[1][2].IsAutoSkipStopped(v6) then
                                        return
                                    elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                        return
                                    else
                                        v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                        v2[1][2].SendSkip("AutoSkip")
                                        return
                                    end
                                elseif v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                else
                                    if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                        v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                        v2[1][2].SendSkip("AutoSkip")
                                    end
                                    return
                                end
                            end
                        else
                            v4 = v2[1][2]
                            v6 = v4.Wave()
                            v4 = v4.Skip.LastWave
                            if v4 ~= v6 then
                                v3 = v2[1][2]
                                v3.Skip.LastWave = v6
                                v4, v3 = v3.Skip, 0
                                v4.NextAt = 0
                                if v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                    return
                                else
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                    return
                                end
                            elseif v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            else
                                if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                end
                                return
                            end
                        end
                    elseif v6 then
                        if v1._.tonumber(v5) >= v1._.tonumber(v7) then
                            return
                        else
                            v4 = v2[1][2]
                            v6 = v4.Wave()
                            v4 = v4.Skip.LastWave
                            if v4 ~= v6 then
                                v3 = v2[1][2]
                                v3.Skip.LastWave = v6
                                v4, v3 = v3.Skip, 0
                                v4.NextAt = 0
                                if v2[1][2].IsAutoSkipStopped(v6) then
                                    return
                                elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                    return
                                else
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                    return
                                end
                            elseif v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            else
                                if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                    v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                    v2[1][2].SendSkip("AutoSkip")
                                end
                                return
                            end
                        end
                    else
                        v4 = v2[1][2]
                        v6 = v4.Wave()
                        v4 = v4.Skip.LastWave
                        if v4 ~= v6 then
                            v3 = v2[1][2]
                            v3.Skip.LastWave = v6
                            v4, v3 = v3.Skip, 0
                            v4.NextAt = 0
                            if v2[1][2].IsAutoSkipStopped(v6) then
                                return
                            elseif v1._.os.clock() < v2[1][2].Skip.NextAt then
                                return
                            else
                                v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                v2[1][2].SendSkip("AutoSkip")
                                return
                            end
                        elseif v2[1][2].IsAutoSkipStopped(v6) then
                            return
                        else
                            if not (v1._.os.clock() < v2[1][2].Skip.NextAt) then
                                v2[1][2].Skip.NextAt = v1._.os.clock() + 2
                                v2[1][2].SendSkip("AutoSkip")
                            end
                            return
                        end
                    end
                end
            end
        end
    end
end
local function _w10(v1, v2, v3)
    v1.jf[v3] = v2
    return v1.jf[v3]
end
local function _w11(v1, v2)
    return function(v3)
        v2[2][2].Difficulty = v1._.tostring(v3)
        v2[1][2].SaveSettings()
    end
end
local function _w12(v1, v2)
    return function(v3)
        local v4 = 156
        local v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19
        while true do
            if v4 == 7 then
                v4 = v10 and 217 / v4 or 194
            elseif v4 == 51 then
                v4 = v10 and 176 - v4 or 2142 / v4
            elseif v4 == 90 then
                return
            elseif v4 == 125 then
                v14 = v1._.type
                v7 = v1._.rawget
                v7 = table.pack(v7(v12, "Name"))
                v4, v10 = 167 - v4, v14(table.unpack(v7, 1, v7.n)) == "string"
            elseif v4 == 155 then
                v10 = v2[2][2]
                v19 = v10.Running
                v5 = not v19
                v4 = v5 and 109 or 53
            elseif v4 == 156 then
                v9 = v1._.type(v1._.getgc)
                v17 = "function"
                v4 = v9 ~= "function" and 90 or 2
            elseif v4 == 214 then
                v4 = v10 and 450 - v4 or 34
            elseif v4 >= 221 and v4 <= 236 then
                v10 = v1._.rawget(v12, "Id")
                v7 = v2[1][2]
                v14 = v2[2][2].Path(v7, "Game/Towers/" .. v10)
                v4 = v14 and v4 + -142 or 34
            elseif v4 >= 195 and v4 <= 213 then
                v7 = v1._.rawget
                v14 = v1._.tonumber
                v7 = table.pack(v7(v5, "UserId"))
                v4 = 184
                v10 = v14(table.unpack(v7, 1, v7.n)) == v2[3][2].UserId
            elseif v4 >= 193 and v4 <= 194 then
                v10 = v1._.rawget(v12, "OwnerUserId") == v2[3][2].UserId
                v4 = v10 and 6984 / v4 or 51
            elseif v4 >= 215 and v4 <= 220 then
                v1._.task.wait()
                v19 = v1._.os
                v5 = v19.clock()
                v4 = 192
                v13 = v5
            elseif v4 >= 185 and v4 <= 192 then
                v5 = v1._.type(v12)
                v19 = "table"
                v4 = v5 == "table" and 146 or 34
            elseif v4 >= 157 and v4 <= 184 then
                v4 = v10 and 1840 / v4 or 7
            elseif v4 >= 126 and v4 <= 154 then
                v10 = v1._.rawget(v12, "Tags")
                v10, v14, v19, v5 = v12, "Data", v1._.rawget, v10
                v19 = v19(v10, "Data")
                v10 = v1._.type(v5) == "table"
                v4 = v10 and 353 - v4 or v4 + 38
            elseif v4 >= 105 and v4 <= 124 then
                return
            elseif v4 >= 8 and v4 <= 10 then
                v4 = 7
                v10 = v1._.type(v19) == "table"
            elseif v4 >= 11 and v4 <= 28 then
                v13 = v1._.os.clock()
                v18, v8, v16 = v1._.ipairs(v17)
                v18, v8, v16 = v1.g(v18, v8, v16)
                v6, v12 = v18(v8, v16)
                v16 = v6
                v4 = v6 == nil and 168 / v4 or v4 + 45
            elseif v4 <= 2 then
                v17 = v1._.getgc
                v9, v17 = v1._.pcall(v17, true)
                v13 = not v9
                v4 = v13 and 104 or v4 + 26
            elseif v4 >= 3 and v4 <= 6 then
                return
            elseif v4 >= 32 and v4 <= 34 then
                v6, v12 = v18(v8, v16)
                v16 = v6
                v4 = v6 == nil and 204 / v4 or v4 + 39
            elseif v4 >= 29 and v4 <= 31 then
                v10 = v2[2][2].Inventory
                v4 = 225 - v4
                v10(v19)
            elseif v4 >= 35 and v4 <= 36 then
                v4, v14, v15, v11, v7 = 1836 / v4, v1._.type, "Id", v12, v1._.rawget
                v7 = table.pack(v7(v11, "Id"))
                v10 = v14(table.unpack(v7, 1, v7.n)) == "string"
            elseif v4 >= 37 and v4 <= 50 then
                v4 = v10 and v4 + 201 or 256 - v4
            elseif v4 >= 52 and v4 <= 72 then
                v10 = v1._.os
                v5 = v10.clock() - v13
                v19 = 0.002
                v4 = v5 >= 0.002 and 11660 / v4 or 192
            elseif v4 >= 73 and v4 <= 89 then
                v4 = v3 and 155 or 192
            elseif v4 >= 91 and v4 <= 94 then
                v7 = v2[2][2]
                v7.Towers[v10] = v12
                v4, v7, v14 = 128 - v4, v12, v7.Learn
                v14(v7)
            elseif v4 >= 95 and v4 <= 104 then
                return
            else
                v4 = 214
                v10 = v1._.rawget(v12, "CFrame")
            end
        end
    end
end
local function _w13(v1, v2)
    return function()
        local v3 = v2[2][2]
        v3.SaveQueued = false
        v3 = v3.Running
        local v4, v5
        if v3 then
            if v2[2][2].FS then
                v4 = v2[2][2]
                v3 = v4.Write
                v4, v5 = v4.SettingsFile, v2[1][2]
                v3, v4 = v3(v4, v5)
                if not v3 then
                    v2[2][2].SetStatus("Macro", "Settings save failed: " .. v1._.tostring(v4))
                end
            end
        end
    end
end
local function _w14(v1, v2, v3, v4)
    v1.Le[v4] = -v3 + (bit32.bor(bit32.band(65535, v3), bit32.band(65535, v3)) * bit32.band(bit32.band(v3, 65535), bit32.band(65535, v3)) + bit32.band(bit32.band(65535, v3), bit32.bnot(bit32.band(65535, v3))) * bit32.band(bit32.band(65535, v3), bit32.bnot(bit32.band(v3, 65535))) - bit32.band(v3, 65535) * bit32.band(v3, 65535)) + v2 + -bit32.bxor(bit32.bor(v3, v2), 4294967295) + bit32.bnot(bit32.bor(v2, v3))
    return v1.Le[v4]
end
(function()
    local v1, v2, v3 = type, getmetatable, pairs
    return function(v4, v5, v6)
        if v1(v4) ~= "function" then
            local v7 = v2(v4)
            if v7 ~= nil and v7.__iter ~= nil then
                return v7.__iter(v4)
            elseif (v7 and v7.__call) == nil and v1(v4) == "table" then
                return v3(v4)
            end
        end
        return v4, v5, v6
    end
end)()
local function _w16(v1, v2)
    return function()
        local v3 = 12
        local v4, gUI3, v5, v6, v7, v8, v9, v10, v11, v12, v13
        while true do
            if v3 == 101 then
                v10 = v1._.ipairs
                v11 = gUI3.GetChildren
                v11 = v1.h(v11(gUI3))
                v10, v11, v9 = v10(v1.i(v11))
                v10, v11, v9 = v1.g(v10, v11, v9)
                v12, v13 = v10(v11, v9)
                v9 = v12
                v3 = v12 == nil and v3 + -100 or 17574 / v3
            elseif v3 == 128 then
                v4 = v2[1][2].Path(v13, "Template/CoinAmount")
                v7 = v4
                v3 = v4 and 64 or 124
            elseif v3 >= 13 and v3 <= 100 then
                v3, v6 = 7936 / v3, v2[1][2]
                v7, v6 = v6.Visible, v4
                v7 = v7(v6)
            elseif v3 <= 1 then
                return
            elseif v3 >= 2 and v3 <= 12 then
                gUI3 = v2[1][2].GUI("FinalUI/Content/Stats")
                v10 = not gUI3
                v3 = v10 and 190 or 101
            elseif v3 >= 129 and v3 <= 134 then
                v3 = v4 and v3 + -6 or 253
            elseif v3 >= 102 and v3 <= 127 then
                v3 = v7 and 227 or 253
            elseif v3 >= 191 and v3 <= 227 then
                v7 = v1._.tonumber
                v6 = v4.Text:gsub(",", "")
                v8, v6, v5 = "[%d%.]+", v6.match, v6
                v6 = table.pack(v6(v5, "[%d%.]+"))
                v7 = table.pack(v7(table.unpack(v6, 1, v6.n)))
                return table.unpack(v7, 1, v7.n)
            elseif v3 >= 145 and v3 <= 174 then
                v4 = v13.Name:match("^FrameCoins")
                v3 = v4 and 144 or 134
            elseif v3 >= 135 and v3 <= 144 then
                v3, v7, v4 = v3 + -10, v13, v2[1][2].Visible
                v4 = v4(v7)
            elseif v3 >= 175 and v3 <= 190 then
                return nil
            else
                v12, v13 = v10(v11, v9)
                v9 = v12
                v3 = v12 == nil and 254 - v3 or v3 + -79
            end
        end
    end
end
local function _w17(v1, v2, v3, v4, v5)
    v1.df[v5] = -bit32.band(bit32.bnot(v4), v3) + (v2 + (-v4 + (bit32.band(bit32.band(65535, v2), bit32.band(65535, v3)) * bit32.bor(bit32.band(65535, v3), bit32.band(v2, 65535)) + bit32.band(bit32.bnot(bit32.band(v2, 65535)), bit32.band(v3, 65535)) * bit32.band(bit32.band(65535, v2), bit32.bnot(bit32.band(65535, v3))) - bit32.band(v3, 65535) * bit32.band(65535, v2))))
    return v1.df[v5]
end
local function _w18(v1, v2)
    return function()
        local v3 = 221
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19
        while true do
            if v3 == 18 then
                v3, v15, v12 = v3 + 56, v1._.type, v14.Id
                v15 = v15(v12)
                v12 = "string"
                v16 = v15 == "string"
            elseif v3 == 19 then
                v3 = v4 and 88 - v3 or 192
            elseif v3 == 20 then
                v16 = v14.Name
                v15 = "Template"
                v3 = v16 ~= "Template" and 68 or 3020 / v3
            elseif v3 == 41 then
                v11 = v1._.table.insert
                v13 = {}
                v17 = v19
                v13.Id = v14.Name
                v13.Key = "GUI/Daily/" .. v14.Name
                v3, v13.Type = 192 - v3, "Daily"
                v11(v17, v13)
            elseif v3 == 49 then
                v3 = 95
                v11 = v15
            elseif v3 == 68 then
                v16 = v2[2][2].Path(v14, "Progress/AmountDone")
                v15 = v2[2][2].Path(v14, "Progress/ClaimButton")
                v12 = v2[2][2].Path(v14, "Progress/ClaimedText")
                v4 = nil
                v7 = nil
                v3 = v16 and 146 or 267 - v3
            elseif v3 == 69 then
                v7 = 0
                v3 = 192
                v4 = v12 > 0
            elseif v3 == 90 then
                v3 = v4 and 257 - v3 or 252 - v3
            elseif v3 == 105 then
                v3, v8 = 14490 / v3, 0
            elseif v3 == 122 then
                v3 = v11 and 30988 / v3 or 224
            elseif v3 == 123 then
                v3, v4 = 142 - v3, v12
            elseif v3 == 129 then
                v1._.table.sort(v19, v1:Lc())
                return v19
            elseif v3 == 162 then
                v4 = v15
                v3 = v15 and 123 or 3078 / v3
            elseif v3 == 192 then
                v3 = v4 and 121 or 167
            elseif v3 == 215 then
                v3 = v18 and 194 or 156
            elseif v3 == 221 then
                v19 = {}
                v18 = v2[2][2]
                v5 = v18.InventoryData
                v3 = v5 and 222 or 67
            elseif v3 == 222 then
                v3 = 67
                v8 = v2[2][2]
                v18 = v8.InventoryData
                v5 = v18.ActiveQuests
            elseif v3 <= 13 then
                v8 = v1._.type(v5)
                v6 = "table"
                v18 = v8 == "table"
                v3 = v18 and 144 or 215
            elseif v3 >= 14 and v3 <= 17 then
                v3, v17 = v3 + 200, v12.Visible
            elseif v3 >= 21 and v3 <= 40 then
                v7 = v14.CurrentProgress
                v16 = v18 .. "/Daily/" .. v14.Id
                v15 = v1._.tonumber(v7)
                v12 = v1._.tonumber(v14.Progress)
                v11 = true
                v7 = v14.Completed
                v4 = v7 == true
                v3 = v4 and 90 or 2976 / v3
            elseif v3 >= 50 and v3 <= 61 then
                v3 = v11 and 220 or v3 + 93
            elseif v3 >= 42 and v3 <= 48 then
                v15 = v1._.type(v14)
                v12 = "table"
                v16 = v15 == "table"
                v3 = v16 and 18 or 116 - v3
            elseif v3 >= 62 and v3 <= 67 then
                v3 = v5 and 75 or 13
            elseif v3 >= 70 and v3 <= 74 then
                v3 = v16 and v3 + -50 or 84
            elseif v3 >= 75 and v3 <= 83 then
                v6 = v2[2][2]
                v3, v8 = 975 / v3, v6.InventoryData
                v18 = v8.ActiveQuests
                v5 = v18.Daily
            elseif v3 >= 84 and v3 <= 89 then
                v10, v14 = v8(v6, v9)
                v9 = v10
                v3 = v10 == nil and 129 or v3 + -42
            elseif v3 >= 91 and v3 <= 94 then
                v3, v17 = 154 - v3, v1._.tonumber(v7)
                v11 = v17 > 0
            elseif v3 >= 106 and v3 <= 121 then
                v3, v4 = 20207 / v3, v15 >= v12
            elseif v3 >= 95 and v3 <= 104 then
                v3 = v11 and 13490 / v3 or 217 - v3
            elseif v3 >= 124 and v3 <= 128 then
                v7 = v14.State
                v11 = "Completed"
                v3, v4 = 214 - v3, v7 == "Completed"
            elseif v3 >= 195 and v3 <= 199 then
                v11 = v4
                v3 = v4 and 292 - v3 or v3 + -138
            elseif v3 >= 193 and v3 <= 194 then
                v8 = v5.LastUpdate
                v18 = v1._.tostring
                v3 = v8 and 332 - v3 or 299 - v3
            elseif v3 >= 180 and v3 <= 191 then
                v8 = v1._.ipairs
                v6 = v18.GetChildren
                v6 = v1.h(v6(v18))
                v8, v6, v9 = v8(v1.i(v6))
                v8, v6, v9 = v1.g(v8, v6, v9)
                v10, v14 = v8(v6, v9)
                v9 = v10
                v3 = v10 == nil and 129 or 20
            elseif v3 >= 216 and v3 <= 217 then
                v3 = 224
                v11 = not v17
            elseif v3 >= 200 and v3 <= 214 then
                v3, v11 = 17976 / v3, v1._.table
                v13, v17, v11, v7 = v14.Id, {}, v19, v11.insert
                v17.Id = v13
                v17.Key = v16
                v17.Type = "Daily"
                v7(v11, v17)
            elseif v3 >= 223 and v3 <= 224 then
                v3 = v11 and 41 or 33824 / v3
            elseif v3 >= 218 and v3 <= 220 then
                v17 = v1._.tonumber(v4)
                v3 = 154
                v11 = v17 >= v1._.tonumber(v7)
            elseif v3 >= 167 and v3 <= 179 then
                v7 = v4
                v3 = v4 and 134 or 27722 / v3
            elseif v3 >= 163 and v3 <= 166 then
                v3 = v7 and 214 or 250 - v3
            elseif v3 >= 155 and v3 <= 161 then
                v8 = v2[2][2]
                v8, v9, v18 = v2[1][2], "PlayerGui", v8.Path
                v8 = v8:FindFirstChild("PlayerGui")
                v6 = "Main/Main/Quests/QuestsFrame/AllQuests/List"
                v18 = v18(v8, "Main/Main/Quests/QuestsFrame/AllQuests/List")
                v3 = v18 and 180 or 129
            elseif v3 >= 152 and v3 <= 154 then
                v3 = v11 and 49 or 95
            elseif v3 >= 130 and v3 <= 134 then
                v3, v17, v11 = 300 - v3, true, v14.RewardClaimed
                v7 = v11 ~= true
            elseif v3 >= 135 and v3 <= 138 then
                v18 = v18(v8)
                v8, v6, v9 = v1._.pairs(v5.Quests)
                v8, v6, v9 = v1.g(v8, v6, v9)
                v10, v14 = v8(v6, v9)
                v9 = v10
                v3 = v10 == nil and 129 or 42
            elseif v3 >= 139 and v3 <= 142 then
                v3 = 122
                v11 = v15.Visible
            elseif v3 >= 145 and v3 <= 146 then
                v11 = v16.Text
                v11, v17 = v11.match, v11
                v11, v17 = v11(v17, "(%d+)%s*/%s*(%d+)")
                v4, v3, v7 = v11, v3 + 53, v17
            elseif v3 >= 143 and v3 <= 144 then
                v8 = v1._.type(v5.Quests)
                v3, v6 = 359 - v3, "table"
                v18 = v8 == "table"
            elseif v3 >= 147 and v3 <= 151 then
                v10, v14 = v8(v6, v9)
                v9 = v10
                v3 = v10 == nil and 19479 / v3 or 171 - v3
            else
                v17 = v12
                v3 = v12 and 17 or 55118 / v3
            end
        end
    end
end
local function _w19(v1, v2)
    return function()
        local v3 = 7
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
        while true do
            if v3 == 2 then
                v15 = true
                v3, v22 = 113 - v3, v21 == true
            elseif v3 == 15 then
                v3 = v6 < v19 and 1275 / v3 or 243
            elseif v3 == 36 then
                v18 = v7.Key
                v20 = true
                v3, v19[v18] = 40, true
            elseif v3 == 40 then
                v12, v7 = v5(v17, v11)
                v11 = v12
                v3 = v12 == nil and v3 + -13 or 36
            elseif v3 == 56 then
                v12, v7 = v5(v17, v11)
                v11 = v12
                v3 = v12 == nil and 9632 / v3 or 205
            elseif v3 == 67 then
                v3 = 213
                v19 = v2[1][2]
                v6 = v19.Teleporting
            elseif v3 == 104 then
                v3 = v6 and v3 + 109 or 6968 / v3
            elseif v3 == 108 then
                v20 = v19[v12]
                v18 = not v20
                v3 = v18 and v3 + 104 or 29
            elseif v3 == 143 then
                return
            elseif v3 == 198 then
                v3 = v11 and v3 + -117 or 130
            elseif v3 == 213 then
                v3 = v6 and 356 - v3 or 53250 / v3
            elseif v3 == 250 then
                v6 = v1._.os.clock()
                v17 = v2[1][2]
                v5 = v17.Next
                v19 = v5.Quest
                v3 = v19 and 15 or 396 - v3
            elseif v3 >= 147 and v3 <= 172 then
                v17 = "Quest"
                v5 = v2[1][2].SetStatus
                v12 = 0
                v11 = #v6 == 0
                v3 = v11 and 102 or v3 + 26
            elseif v3 >= 114 and v3 <= 142 then
                v3 = 81
                v11 = "Waiting for quest update"
            elseif v3 >= 144 and v3 <= 146 then
                v3 = 15
                v19 = 0
            elseif v3 >= 105 and v3 <= 107 then
                v20 = not v18.Accepted
                v3 = v20 and 6042 / v3 or 97
            elseif v3 >= 102 and v3 <= 103 then
                v3, v11 = 20196 / v3, "Waiting for completed Daily quests"
            elseif v3 >= 112 and v3 <= 113 then
                v5, v17, v11 = v1._.ipairs(v6)
                v5, v17, v11 = v1.g(v5, v17, v11)
                v12, v7 = v5(v17, v11)
                v11 = v12
                v3 = v12 == nil and 172 or 205
            elseif v3 >= 109 and v3 <= 111 then
                v3 = v22 and 38 or 364 - v3
            elseif v3 >= 214 and v3 <= 249 then
                v2[1][2].Next.Quest = v1._.os.clock() + 2
                v6 = v2[1][2].ClaimableQuests()
                v19 = {}
                v5, v17, v11 = v1._.ipairs(v6)
                v5, v17, v11 = v1.g(v5, v17, v11)
                v12, v7 = v5(v17, v11)
                v11 = v12
                v3 = v12 == nil and v3 + -216 or 36
            elseif v3 >= 206 and v3 <= 212 then
                v3, v20 = 6148 / v3, v2[1][2]
                v20, v18 = nil, v20.QuestClaims
                v18[v12] = nil
            elseif v3 >= 199 and v3 <= 205 then
                v4 = v2[1][2]
                v4, v20 = v7.Key, v4.QuestClaims
                v18 = v20[v4]
                v20 = not v18
                v3 = v20 and v3 + -108 or 106
            elseif v3 >= 173 and v3 <= 197 then
                v9 = v9(v13)
                v3 = 0
                v14 = v14 .. v8 .. v10 .. v9
                v22(v15, v14)
            elseif v3 >= 59 and v3 <= 66 then
                v4 = {}
                v4.NextAt = v1._.os.clock() + 30
                v20 = v4
                v21 = v7.Key
                v2[1][2].QuestClaims[v21] = v20
                v21 = v2[1][2]
                v22, v16, v21, v4 = v7.Type, v7.Id, "CollectQuest", v21.Invoke
                v4, v21, v16 = v4("CollectQuest", v16, v22)
                v22 = v4
                v3 = v4 and 2 or 111
            elseif v3 >= 68 and v3 <= 81 then
                v5(v17, v11)
                return
            elseif v3 >= 86 and v3 <= 101 then
                v3 = v20 and 156 - v3 or 5432 / v3
            elseif v3 >= 82 and v3 <= 85 then
                return
            elseif v3 >= 57 and v3 <= 58 then
                v3, v4 = v3 + 40, v1._.os.clock
                v4 = v4()
                v21 = v18.NextAt
                v20 = v4 >= v21
            elseif v3 >= 41 and v3 <= 55 then
                v19, v3, v17 = v1._.game.PlaceId, 5720 / v3, v2[1][2]
                v5 = v17.LobbyId
                v6 = v19 ~= v5
            elseif v3 >= 29 and v3 <= 35 then
                v12 = v5(v17, v11)
                v11 = v12
                v3 = v12 == nil and v3 + 84 or 137 - v3
            elseif v3 >= 37 and v3 <= 39 then
                v20.Accepted = true
                v22 = v2[1][2].SetStatus
                v15 = "Quest"
                v3, v14 = v3 + -38, "Claim accepted: " .. v7.Id
                v22("Quest", v14)
            elseif v3 >= 16 and v3 <= 28 then
                v17 = v2[1][2].QuestClaims
                v5, v17, v11 = v1._.pairs(v17)
                v5, v17, v11 = v1.g(v5, v17, v11)
                v12 = v5(v17, v11)
                v11 = v12
                v3 = v12 == nil and 113 or v3 + 81
            elseif v3 >= 3 and v3 <= 6 then
                v3 = 195
                v13 = v21
            elseif v3 <= 1 then
                return
            elseif v3 >= 7 and v3 <= 14 then
                v5 = v2[2][2]
                v19 = v5.AutoClaimQuest
                v6 = not v19
                v3 = v6 and 104 or 55
            else
                v15 = v2[1][2]
                v15, v14, v13, v8, v22, v9, v10 = "Quest", "Claim pending: ", v16, v7.Id, v15.SetStatus, v1._.tostring, " | "
                v3 = v13 and 195 or 6
            end
        end
    end
end
local function _w20(v1, v2)
    return function()
        local v3 = 187
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
        repeat
            if v3 == 30 then
                v11 = v1:je({v13, v2[2]})
                v14, v11 = v1._.pcall(v11)
                v15 = not v14
                v3 = v15 and 161 or 75 - v3
            elseif v3 == 126 then
                v3 = 199
                v14 = v8 > v11
            elseif v3 == 150 then
                v2[2][2].Notify("Select a macro first")
                return
            elseif v3 == 157 then
                v7 = v2[2][2]
                v6 = v7.Read
                v9, v7 = v4, v7.File
                v7 = v1.h(v7(v9))
                v6 = v6(v1.i(v7))
                v7 = v2[2][2].ValidProfile(v6)
                v3 = v7 and 86 or 122
            elseif v3 == 158 then
                v14 = v2[1][2]
                v3 = 206
                v8 = v14.AutoPlayback
            elseif v3 == 187 then
                v8 = v2[1][2]
                v13 = {[1] = 2, [2] = v2[2][2].SafeName(v8.Profile)}
                v13[3] = v13
                v8 = ""
                v3 = v13[2] == "" and 150 or 134
            elseif v3 == 216 then
                v2[2][2].Notify("Stop recording and Auto Playback before deleting a macro")
                return
            elseif v3 >= 159 and v3 <= 186 then
                v12 = v1._.tostring
                v2[2][2].Notify("Delete failed: " .. v12(v11))
                return
            elseif v3 >= 188 and v3 <= 199 then
                v3 = v14 and v3 + -164 or 31044 / v3
            elseif v3 >= 151 and v3 <= 156 then
                v14 = v2[2][2]
                v14.DeleteProfile = nil
                v14.DeleteUntil = nil
                v15 = v14
                v11 = v14.FS
                v14 = not v11
                v3 = v14 and 22932 / v3 or v3 + -119
            elseif v3 >= 217 and v3 <= 238 then
                v15 = v2[2][2]
                v11 = v15.DeleteUntil
                v3 = v11 and 364 - v3 or 77
            elseif v3 >= 207 and v3 <= 215 then
                v10 = v2[2][2]
                v10.RefreshProfiles()
                v10.SaveSettings()
                v15, v10, v12 = v10.SetStatus, "Macro", " deleted"
                v15("Macro", v13[2] .. " deleted")
                return
            elseif v3 >= 200 and v3 <= 206 then
                v3 = v8 and v3 + 10 or v3 + -191
            elseif v3 <= 29 then
                v8 = v1._.os.clock()
                v15 = v2[2][2]
                v11 = v15.DeleteProfile
                v14 = v11 ~= v13[2]
                v3 = v14 and v3 + 184 or v3 + 223
            elseif v3 >= 31 and v3 <= 35 then
                v14 = v2[2][2]
                v14.DeleteProfile = v13[2]
                v14.DeleteUntil = v8 + 5
                v14, v11 = v14.Notify, "Click Delete Selected Macro again within 5 seconds to delete "
                v14("Click Delete Selected Macro again within 5 seconds to delete " .. v13[2])
                return
            elseif v3 >= 38 and v3 <= 45 then
                v2[1][2].Profile = ""
                v2[2][2].LoadedProfile = nil
                v15 = v1._.ipairs
                v10 = v2[2][2].Profiles
                v10 = v1.h(v10())
                v15, v10, v12 = v15(v1.i(v10))
                v15, v10, v12 = v1.g(v15, v10, v12)
                v5, v4 = v15(v10, v12)
                v12 = v5
                v3 = v5 == nil and 252 - v3 or 102
            elseif v3 >= 36 and v3 <= 37 then
                v15 = v1._.delfile
                v3 = 147
                v11 = v1._.type(v15)
                v15 = "function"
                v14 = v11 ~= "function"
            elseif v3 >= 78 and v3 <= 86 then
                v3 = 207
                v2[1][2].Profile = v4
                v7 = v2[2][2]
                v7.LoadedProfile = v6
                v9, v7 = v6, v7.LearnProfileCosts
                v7(v9)
            elseif v3 >= 46 and v3 <= 77 then
                v3 = 126
                v11 = 0
            elseif v3 >= 87 and v3 <= 99 then
                v2[2][2].Notify("Executor filesystem deletion unavailable")
                return
            elseif v3 >= 148 and v3 <= 149 then
                v14 = v2[2][2]
                v3 = 246
                v8 = v14.Recording
            elseif v3 >= 135 and v3 <= 147 then
                v3 = v14 and 99 or 30
            elseif v3 >= 103 and v3 <= 125 then
                v5, v4 = v15(v10, v12)
                v12 = v5
                v3 = v5 == nil and v3 + 85 or 102
            elseif v3 >= 100 and v3 <= 102 then
                v6 = "(none)"
                v3 = v4 ~= "(none)" and 157 or 122
            elseif v3 >= 127 and v3 <= 134 then
                v14 = v2[2][2]
                v8 = v14.Playing
                v3 = v8 and 246 or 149
            else
                v3 = v8 and 206 or 404 - v3
            end
        until false
    end
end
local function _w21(v1, v2, v3, v4, v5)
    v1.Ue[v5] = v4 + (bit32.band(bit32.bnot(bit32.band(v3, 65535)), bit32.band(v4, 65535)) * bit32.band(bit32.bnot(bit32.band(65535, v4)), bit32.band(65535, v3)) + bit32.bor(bit32.band(65535, v3), bit32.band(v4, 65535)) * bit32.band(bit32.band(v3, 65535), bit32.band(v4, 65535)) - bit32.band(v4, 65535) * bit32.band(v3, 65535) + v2 + v3)
    return v1.Ue[v5]
end
local function _w22(v1, v2)
    return function()
        local v3 = v1._.game.PlaceId
        local v4 = v1._.tostring(v3)
        local v5 = v1._.game.JobId
        local v6 = v4 .. "/" .. v1._.tostring(v5)
        if v2[1][2].WaveSessionKey ~= v6 then
            v4 = v2[1][2]
            v4.WaveSessionKey = v6
            v4.ObservedWave = 0
            v4.WaveStartedGame = nil
        end
        v4 = v2[1][2].GUI("Stats/Wave")
        v3 = v4
        local v7, v8
        if v4 then
            v7 = v4.Text
            v3 = v1._.tonumber
            v8, v7 = v7, v7.match
            v7 = table.pack(v7(v8, "[Ww]ave%s+(%d+)"))
            v3 = v3(table.unpack(v7, 1, v7.n))
            if v3 then
                v7 = v2[1][2].ObservedWave
                if v7 then
                    if v3 > v7 then
                        v7 = v2[1][2]
                        v7.WaveStartedGame = v7.GameClock()
                    end
                    v7 = v2[1][2]
                    v8 = v1._.math.max
                    v5 = v7.ObservedWave
                    if v5 then
                        v8 = v8(v5, v3)
                    else
                        v8 = v8(0, v3)
                    end
                    v7.ObservedWave = v8
                    v7 = v2[1][2].ObservedWave
                    if v7 then
                        return v7
                    else
                        return 0
                    end
                elseif v3 > 0 then
                    v7 = v2[1][2]
                    v7.WaveStartedGame = v7.GameClock()
                    v7 = v2[1][2]
                    v8 = v1._.math.max
                    v5 = v7.ObservedWave
                    if v5 then
                        v8 = v8(v5, v3)
                    else
                        v8 = v8(0, v3)
                    end
                    v7.ObservedWave = v8
                    v7 = v2[1][2].ObservedWave
                    if v7 then
                        return v7
                    else
                        return 0
                    end
                else
                    v7 = v2[1][2]
                    v8 = v1._.math.max
                    v5 = v7.ObservedWave
                    if v5 then
                        v8 = v8(v5, v3)
                    else
                        v8 = v8(0, v3)
                    end
                    v7.ObservedWave = v8
                    v7 = v2[1][2].ObservedWave
                    if v7 then
                        return v7
                    else
                        return 0
                    end
                end
            else
                v7 = v2[1][2].ObservedWave
                if v7 then
                    return v7
                else
                    return 0
                end
            end
        elseif v3 then
            v7 = v2[1][2].ObservedWave
            if v7 then
                if v3 > v7 then
                    v7 = v2[1][2]
                    v7.WaveStartedGame = v7.GameClock()
                end
                v7 = v2[1][2]
                v8 = v1._.math.max
                v5 = v7.ObservedWave
                if v5 then
                    v8 = v8(v5, v3)
                else
                    v8 = v8(0, v3)
                end
                v7.ObservedWave = v8
                v7 = v2[1][2].ObservedWave
                if v7 then
                    return v7
                else
                    return 0
                end
            elseif v3 > 0 then
                v7 = v2[1][2]
                v7.WaveStartedGame = v7.GameClock()
                v7 = v2[1][2]
                v8 = v1._.math.max
                v5 = v7.ObservedWave
                if v5 then
                    v8 = v8(v5, v3)
                else
                    v8 = v8(0, v3)
                end
                v7.ObservedWave = v8
                v7 = v2[1][2].ObservedWave
                if v7 then
                    return v7
                else
                    return 0
                end
            else
                v7 = v2[1][2]
                v8 = v1._.math.max
                v5 = v7.ObservedWave
                if v5 then
                    v8 = v8(v5, v3)
                else
                    v8 = v8(0, v3)
                end
                v7.ObservedWave = v8
                v7 = v2[1][2].ObservedWave
                if v7 then
                    return v7
                else
                    return 0
                end
            end
        else
            v7 = v2[1][2].ObservedWave
            if v7 then
                return v7
            else
                return 0
            end
        end
    end
end
local function _w23(v1, v2)
    return function()
        local v3 = v2[2][2]
        local v4 = v2[1][2]
        local v5 = v1._.readfile
        local pack = table.pack(v5(v4))
        local v6
        v3, v6 = v3.JSONDecode, v3
        v3 = table.pack(v3(v6, table.unpack(pack, 1, pack.n)))
        return table.unpack(v3, 1, v3.n)
    end
end
local function _w24(v1, v2)
    return function(v3)
        local safeName = v2[3][2].SafeName(v3)
        safeName, v2[2][2] = v2[1][2], safeName
        safeName.NewProfileName = v2[2][2]
        v2[3][2].SaveSettings()
    end
end
local function _w25(v1, v2, v3, v4)
    v1.vf[v4] = v1.me(v2, v3)
    return v1.vf[v4]
end
local function _w26(v1, v2)
    return function()
        local v3 = v2[2][2].Recording
        local v4, v5, v6, v7, v8, v9
        if not v3 then
            return
        elseif v3.WaveConnection then
            while true do
                v3.WaveConnection:Disconnect()
            end
        else
            v5 = v2[2][2]
            v5.RecordWave = nil
            v5.Recording = nil
            v5.Pending = {}
            v8 = #v3.Profile.Actions
            v3.Profile.ActionCount = v8
            v2[2][2].SetToggle("Record", false)
            v5 = v2[2][2]
            v5.Draft = v3.Profile
            v5.DraftName = v2[1][2].Profile
            v6 = v3.Profile
            v5 = not v5.ValidProfile(v6)
            if v5 then
                v2[2][2].Notify("Macro validation failed; draft retained")
                return false, "Macro validation failed"
            else
                v8 = v2[2][2]
                v5 = v8.Write
                v6, v8 = v2[1][2], v8.File
                v5, v8 = v5(v8(v6.Profile), v3.Profile)
                v6 = v2[2][2].SetStatus
                if v5 then
                    v9 = v3.Profile.ActionCount
                    v4 = "Saved " .. v2[1][2].Profile .. ": " .. v9 .. " actions"
                    if v4 then
                        v6("Macro", v4)
                    else
                        v6("Macro", "Save failed: " .. v1._.tostring(v8))
                    end
                else
                    v6("Macro", "Save failed: " .. v1._.tostring(v8))
                end
                if v5 then
                    v2[2][2].RefreshProfiles()
                else
                    v2[2][2].Notify("Save failed; recording draft retained")
                end
                if v5 then
                    v6 = v2[2][2]
                    v6.LoadedProfile = v3.Profile
                    v6, v7 = v6.LearnProfileCosts, v3.Profile
                    v6(v7)
                end
                return v5, v8
            end
        end
    end
end
local function _w27(v1, v2)
    return function(v3)
        local v4 = 141
        local v5, v6
        while true do
            if v4 == 78 then
                v2[1][2].GeometryDirty = true
                return
            elseif v4 == 102 then
                v4 = 94
                v5 = v6.Name == "TowerArea"
            elseif v4 >= 196 and v4 <= 222 then
                v4, v6 = 195, v6.Parent
            elseif v4 >= 156 and v4 <= 195 then
                v5 = v6
                v4 = v6 and 350 - v4 or 145
            elseif v4 >= 146 and v4 <= 155 then
                v4 = 145
                v5 = v6 ~= v2[2][2]
            elseif v4 >= 103 and v4 <= 141 then
                v4 = 195
                v6 = v3
            elseif v4 >= 142 and v4 <= 145 then
                v4 = v5 and 232 or 6525 / v4
            elseif v4 <= 77 then
                return
            elseif v4 >= 79 and v4 <= 101 then
                v4 = v5 and 7332 / v4 or 222
            else
                v5 = v6.Name == "Waypoints"
                v4 = v5 and 21808 / v4 or 102
            end
        end
    end
end
local function _w28(v1, v2)
    return function(v3)
        local v4 = 253
        local v5, v6, v7, v8, v9, v10
        while true do
            if v4 == 66 then
                v10 = {}
                v4, v7 = 264 / v4, v10
            elseif v4 == 174 then
                v4 = v7 and 200 or 13920 / v4
            elseif v4 >= 183 and v4 <= 200 then
                return nil
            elseif v4 >= 175 and v4 <= 182 then
                v6, v9 = v10(v5, v8)
                v8 = v6
                v4 = v6 == nil and 162 or v4 + -131
            elseif v4 >= 162 and v4 <= 173 then
                v7.ReceivedAt = v1._.os.clock()
                v5 = v2[1][2]
                v5, v10 = v3.Id, v5.Towers
                v10[v5] = v7
                v2[1][2].Learn(v7)
                return v7
            elseif v4 >= 81 and v4 <= 161 then
                v5, v4, v10 = v3.Id, 14442 / v4, v1._.type
                v10 = v10(v5)
                v5 = "string"
                v7 = v10 ~= "string"
            elseif v4 >= 67 and v4 <= 80 then
                v5 = v2[1][2]
                v5, v10 = v3.Id, v5.Towers
                v7 = v10[v5]
                v4 = v7 and 84 - v4 or v4 + -14
            elseif v4 <= 4 then
                v10, v5, v8 = v1._.pairs(v3)
                v10, v5, v8 = v1.g(v10, v5, v8)
                v6, v9 = v10(v5, v8)
                v8 = v6
                v4 = v6 == nil and 162 or 204 / v4
            elseif v4 >= 5 and v4 <= 65 then
                v4, v7[v6] = 182, v9
            else
                v10 = v1._.type(v3)
                v5 = "table"
                v7 = v10 ~= "table"
                v4 = v7 and 174 or 83
            end
        end
    end
end
local function _w29(v1)
    return function(v2)
        local v3 = v1._.type(v2) ~= "string"
        local v4, v5, v6, v7
        if v3 then
            if not v3 then
                v3 = v1._.loadstring(v2)
                if v3 then
                    v6, v4 = v1._.pcall(v3)
                    v5 = v6
                    if v6 then
                        if v1._.type(v4) == "table" then
                            v7 = v4.CreateWindow
                            if v1._.type(v7) == "function" then
                                return v4
                            else
                                return
                            end
                        else
                            return
                        end
                    elseif v5 then
                        v7 = v4.CreateWindow
                        if v1._.type(v7) == "function" then
                            return v4
                        else
                            return
                        end
                    else
                        return
                    end
                end
            end
        elseif v2 == "" then
            return
        else
            v3 = v1._.loadstring(v2)
            if v3 then
                v6, v4 = v1._.pcall(v3)
                v5 = v6
                if v6 then
                    if v1._.type(v4) == "table" then
                        v7 = v4.CreateWindow
                        if v1._.type(v7) == "function" then
                            return v4
                        else
                            return
                        end
                    else
                        return
                    end
                elseif v5 then
                    v7 = v4.CreateWindow
                    if v1._.type(v7) == "function" then
                        return v4
                    else
                        return
                    end
                else
                    return
                end
            end
        end
    end
end
local function _w30(v1)
    return function(v2, v3)
        local v4 = v3.Equipped
        return v2.Equipped < v4
    end
end
local function _w31(v1, v2, v3, v4)
    v1.df[v4] = bit32.bnot(bit32.bor(bit32.bnot(v3), bit32.bnot(v2))) + (-v3 + (bit32.band(bit32.band(v3, 65535), bit32.band(65535, v3)) * bit32.bor(bit32.band(v3, 65535), bit32.band(65535, v3)) + bit32.band(bit32.band(65535, v3), bit32.bnot(bit32.band(65535, v3))) * bit32.band(bit32.bnot(bit32.band(65535, v3)), bit32.band(65535, v3)) - bit32.band(65535, v3) * bit32.band(65535, v3) + (bit32.bxor(v2, bit32.bor(4294967295, v3)) + (bit32.bxor(bit32.bor(v3, 4294967295), v3) * -2 + (bit32.bnot(bit32.bnot(v2)) + bit32.bnot(bit32.bor(v3, v3)))))))
    return v1.df[v4]
end
local function _w32(v1, v2)
    return function(v3, v4)
        local v5 = v1._.tonumber(v3.Wave)
        if v5 then
            v5 = {[1] = 2, [2] = v5}
        else
            v5 = {[1] = 2, [2] = 0}
        end
        v5[3] = v5
        local v6 = v2[1][2]
        local v7, v8, v9
        v7, v6, v9, v8 = v4, v1:Yb({v5, v2[1]}), nil, v6.WaitUntil
        v8, v6 = v8(v6, nil, v7)
        local v10, v11, v12
        if not v8 then
            return false, v6
        else
            v9 = v2[1][2].Wave() > v5[2]
            if v9 then
                if v9 then
                    return true
                else
                    v9, v7 = v2[1][2].WaitUntil(v1:Xb({v5, v2[1]}), 30, v4)
                    v9 = not v9
                    if v9 then
                        return false, "Skip vote did not become available"
                    elseif v2[1][2].Wave() > v5[2] then
                        return true
                    else
                        v9 = v2[1][2].GUI("Stats/WaveSkipGui/Title")
                        if v9 then
                            v10 = v9.Text
                            v12, v10 = v10, v10.match
                            v10, v12 = v10(v12, "(%d+)%s*/%s*(%d+)")
                            v11 = v12
                            v7 = v10
                            v10 = v7
                            if v7 then
                                if v1._.tonumber(v11) then
                                    if v1._.tonumber(v11) > 0 then
                                        if v1._.tonumber(v7) >= v1._.tonumber(v11) then
                                            return true
                                        else
                                            v10 = v2[1][2].SendSkip
                                            v10 = table.pack(v10("Playback"))
                                            return table.unpack(v10, 1, v10.n)
                                        end
                                    else
                                        v10 = v2[1][2].SendSkip
                                        v10 = table.pack(v10("Playback"))
                                        return table.unpack(v10, 1, v10.n)
                                    end
                                else
                                    v10 = v2[1][2].SendSkip
                                    v10 = table.pack(v10("Playback"))
                                    return table.unpack(v10, 1, v10.n)
                                end
                            elseif v10 then
                                if v1._.tonumber(v11) > 0 then
                                    if v1._.tonumber(v7) >= v1._.tonumber(v11) then
                                        return true
                                    else
                                        v10 = v2[1][2].SendSkip
                                        v10 = table.pack(v10("Playback"))
                                        return table.unpack(v10, 1, v10.n)
                                    end
                                else
                                    v10 = v2[1][2].SendSkip
                                    v10 = table.pack(v10("Playback"))
                                    return table.unpack(v10, 1, v10.n)
                                end
                            else
                                v10 = v2[1][2].SendSkip
                                v10 = table.pack(v10("Playback"))
                                return table.unpack(v10, 1, v10.n)
                            end
                        else
                            v10 = v2[1][2].SendSkip
                            v10 = table.pack(v10("Playback"))
                            return table.unpack(v10, 1, v10.n)
                        end
                    end
                end
            else
                v7 = v5[2]
                if v2[1][2].SkipVoteComplete(v7) then
                    return true
                else
                    v9, v7 = v2[1][2].WaitUntil(v1:Xb({v5, v2[1]}), 30, v4)
                    v9 = not v9
                    if v9 then
                        return false, "Skip vote did not become available"
                    elseif v2[1][2].Wave() > v5[2] then
                        return true
                    else
                        v9 = v2[1][2].GUI("Stats/WaveSkipGui/Title")
                        if v9 then
                            v10 = v9.Text
                            v12, v10 = v10, v10.match
                            v10, v12 = v10(v12, "(%d+)%s*/%s*(%d+)")
                            v11 = v12
                            v7 = v10
                            v10 = v7
                            if v7 then
                                if v1._.tonumber(v11) then
                                    if v1._.tonumber(v11) > 0 then
                                        if v1._.tonumber(v7) >= v1._.tonumber(v11) then
                                            return true
                                        else
                                            v10 = v2[1][2].SendSkip
                                            v10 = table.pack(v10("Playback"))
                                            return table.unpack(v10, 1, v10.n)
                                        end
                                    else
                                        v10 = v2[1][2].SendSkip
                                        v10 = table.pack(v10("Playback"))
                                        return table.unpack(v10, 1, v10.n)
                                    end
                                else
                                    v10 = v2[1][2].SendSkip
                                    v10 = table.pack(v10("Playback"))
                                    return table.unpack(v10, 1, v10.n)
                                end
                            elseif v10 then
                                if v1._.tonumber(v11) > 0 then
                                    if v1._.tonumber(v7) >= v1._.tonumber(v11) then
                                        return true
                                    else
                                        v10 = v2[1][2].SendSkip
                                        v10 = table.pack(v10("Playback"))
                                        return table.unpack(v10, 1, v10.n)
                                    end
                                else
                                    v10 = v2[1][2].SendSkip
                                    v10 = table.pack(v10("Playback"))
                                    return table.unpack(v10, 1, v10.n)
                                end
                            else
                                v10 = v2[1][2].SendSkip
                                v10 = table.pack(v10("Playback"))
                                return table.unpack(v10, 1, v10.n)
                            end
                        else
                            v10 = v2[1][2].SendSkip
                            v10 = table.pack(v10("Playback"))
                            return table.unpack(v10, 1, v10.n)
                        end
                    end
                end
            end
        end
    end
end
local function _w33(v1, v2)
    return function()
        local v3 = v2[3][2].Name
        local v4 = v2[1][2]
        local v5 = v2[2][2].Units[v4]
        local unitCost = v2[2][2].UnitCost(v3, v5) or v2[3][2].Cost
        if unitCost then
            return unitCost
        else
            return 0
        end
    end
end
local function _w34(v1, v2)
    return function(v3)
        local v4 = 116
        local v5, v6, v7, v8, equipped, v9, v10, v11, v12, v13
        while true do
            if v4 == 52 then
                v9 = 0
                v11 = #equipped
                v13 = v11 == 0
                v4 = v13 and 133 or 293 - v4
            elseif v4 == 181 then
                return v9.Id
            elseif v4 == 191 then
                v13 = 1
                v4 = v5 == 1 and 420 - v4 or v4 + 24
            elseif v4 == 205 then
                v11, v9 = v10(v5, v13)
                v13 = v11
                v4 = v11 == nil and 140 or 301 - v4
            elseif v4 == 229 then
                return v10
            elseif v4 >= 53 and v4 <= 68 then
                return nil
            elseif v4 >= 69 and v4 <= 96 then
                v12 = v9.Id
                v8 = v12 == v3.UnitId
                v4 = v8 and v4 + 111 or 288 / v4
            elseif v4 >= 4 and v4 <= 51 then
                v8, v12 = v13(v11, v9)
                v9 = v8
                v4 = v8 == nil and 191 or 8274 / v4
            elseif v4 <= 3 then
                v4 = v8 and 543 / v4 or 205
            elseif v4 >= 122 and v4 <= 133 then
                v4, v9 = v4 + 108, v2[1][2]
                v9, v11 = v3.UnitId, v9.Units
                v13 = v11[v9]
            elseif v4 >= 117 and v4 <= 121 then
                return v3.UnitId
            elseif v4 >= 97 and v4 <= 116 then
                equipped = v2[1][2].Equipped()
                v10, v5, v13 = v1._.ipairs(equipped)
                v10, v5, v13 = v1.g(v10, v5, v13)
                v11, v9 = v10(v5, v13)
                v13 = v11
                v4 = v11 == nil and 140 or 96
            elseif v4 >= 134 and v4 <= 161 then
                v10 = nil
                v5 = 0
                v13, v11, v9 = v1._.ipairs(equipped)
                v13, v11, v9 = v1.g(v13, v11, v9)
                v8, v12 = v13(v11, v9)
                v9 = v8
                v4 = v8 == nil and v4 + 51 or 197
            elseif v4 >= 215 and v4 <= 228 then
                v13 = 1
                v4 = v5 > 1 and 190 or 52
            elseif v4 >= 206 and v4 <= 214 then
                v12 = v9.Name
                v4, v8 = 210 - v4, v12 == v3.Name
            elseif v4 >= 162 and v4 <= 180 then
                v6, v4, v10 = 1, 204 - v4, v12.Id
                v5 = v5 + 1
            elseif v4 >= 182 and v4 <= 190 then
                return nil, "Multiple equipped copies match " .. v3.Name
            elseif v4 >= 192 and v4 <= 204 then
                v7 = v3.Name
                v6 = v12.Name
                v4 = v6 == v7 and 162 or 42
            else
                v4 = v13 and 121 or 309 - v4
            end
        end
    end
end
local function _w35(v1, v2)
    return function()
        local v3 = not v2[2][2].Running
        local v4, v5, v6, v7
        if v3 then
            if not v3 then
                v5 = v2[2][2].HiddenNameOriginal
                v6 = v2[1][2]
                v6, v3 = v2[2][2], v5[v6]
                v5, v6 = v6.IsOwnNameText, v2[1][2]
                v5 = v5(v6.Text)
                if v5 then
                    if not v3 then
                        v4 = v2[1][2]
                        v3 = {
                            Visible = v4.Visible,
                            TextTransparency = v4.TextTransparency,
                            TextStrokeTransparency = v4.TextStrokeTransparency,
                        }
                        v2[2][2].HiddenNameOriginal[v4] = v3
                    end
                    v5 = v2[1][2]
                    v5.Visible = false
                    v5.TextTransparency, v7 = 1, 1
                    v5.TextStrokeTransparency = 1
                    return
                elseif v3 then
                    v5 = v2[1][2]
                    v5.Visible = v3.Visible
                    v7 = v3.TextStrokeTransparency
                    v5.TextTransparency = v3.TextTransparency
                    v5.TextStrokeTransparency = v7
                    v6 = v2[1][2]
                    v2[2][2].HiddenNameOriginal[v6] = nil
                    return
                else
                    return
                end
            end
        elseif not v2[3][2].HideName then
            return
        else
            v5 = v2[2][2].HiddenNameOriginal
            v6 = v2[1][2]
            v6, v3 = v2[2][2], v5[v6]
            v5, v6 = v6.IsOwnNameText, v2[1][2]
            v5 = v5(v6.Text)
            if v5 then
                if not v3 then
                    v4 = v2[1][2]
                    v3 = {
                        Visible = v4.Visible,
                        TextTransparency = v4.TextTransparency,
                        TextStrokeTransparency = v4.TextStrokeTransparency,
                    }
                    v2[2][2].HiddenNameOriginal[v4] = v3
                end
                v5 = v2[1][2]
                v5.Visible = false
                v5.TextTransparency, v7 = 1, 1
                v5.TextStrokeTransparency = 1
                return
            elseif v3 then
                v5 = v2[1][2]
                v5.Visible = v3.Visible
                v7 = v3.TextStrokeTransparency
                v5.TextTransparency = v3.TextTransparency
                v5.TextStrokeTransparency = v7
                v6 = v2[1][2]
                v2[2][2].HiddenNameOriginal[v6] = nil
                return
            else
                return
            end
        end
    end
end
local function _w36(v1, v2, v3, v4)
    v1.Re[v4] = v1.me(v2, v3)
    return v1.Re[v4]
end
local function _w37(v1, v2)
    return function(v3, v4)
        local v5 = 117
        local v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
        repeat
            if v5 == 8 then
                v5 = v20 and 38 or 225
            elseif v5 == 22 then
                v20 = v2[2][2].Wave()
                v5, v7 = v5 + -8, 0
                v15 = v20 > 0
            elseif v5 == 23 then
                v5 = v15 and v5 + 232 or 191
            elseif v5 == 75 then
                return v20
            elseif v5 == 103 then
                v15 = not v3
                v5 = v15 and 209 or v5 + 50
            elseif v5 == 117 then
                v19 = {[1] = 2, [2] = v2[2][2].ReportRuntime}
                v19[3] = v19
                v15 = not v3
                v5 = v15 and 182 or 19
            elseif v5 == 134 then
                v7 = v2[2][2].ResultCoins()
                v8 = nil
                v20 = v7 == nil
                v5 = v20 and 62 or 102
            elseif v5 == 153 then
                v20 = v19[2].Final
                v15 = not v20
                v5 = v15 and 126 or 153 / v5
            elseif v5 == 171 then
                v11 = v1._.game.PlaceId
                v16 = v1._.tostring(v11)
                v12 = v1._.game.JobId
                v5, v6 = 5, v6[v16 .. "/" .. v1._.tostring(v12)]
            elseif v5 == 214 then
                v6 = v2[3][2].__CameraTDRoundCounters
                v5 = v6 and v5 + -43 or 73
            elseif v5 == 228 then
                v20 = {[1] = 2, [2] = v2[2][2].MatchReport()}
                v20[3] = v20
                v19[2].Requested = true
                v19[2].Pending = true
                v5, v8 = 56772 / v5, v1._.os
                v7 = v8.clock()
                v19[2].SendAt = v7
                v2[3][2].__CameraTDMatchReports[v15] = true
                v7 = v1._.task.spawn
                v8 = v1:Qb({v19, v2[2], v20})
                v7(v8)
            elseif v5 == 245 then
                v5, v8 = 320 - v5, v1._.os.clock
                v8, v7 = 8, v8() - v19[2].SendAt
                v20 = v7 >= 8
            elseif v5 >= 127 and v5 <= 133 then
                return false
            elseif v5 >= 104 and v5 <= 116 then
                v7 = v2[2][2]
                v5, v20 = 314 - v5, v7.ReportStartedAt
                v15 = not v20
            elseif v5 >= 118 and v5 <= 126 then
                v5, v19[2].Final = 126 / v5, true
                v20 = v1._.os
                v15 = v20.clock()
                v19[2].At = v15
                v15 = v2[2][2]
                v7 = v20
                v20 = v20.clock()
                v15.ReportEndedAt = v20
            elseif v5 >= 63 and v5 <= 74 then
                v5 = 171
                v6 = {}
            elseif v5 >= 76 and v5 <= 80 then
                v13 = v13(v6)
                v6 = "/" .. v2[4][2].WebhookURL
                v15, v20 = v20 .. v8 .. v14 .. v21 .. v9 .. v17 .. v13 .. v6, v2[3][2]
                v8 = v20
                v7 = v20.__CameraTDMatchReports
                v5 = v7 and 15440 / v5 or 112 - v5
            elseif v5 >= 81 and v5 <= 102 then
                v5 = v20 and 133 or v5 + 126
            elseif v5 <= 1 then
                v7 = v2[4][2]
                v20 = v7.WebhookEnabled
                v15 = not v20
                v5 = v15 and 23 or v5 + 48
            elseif v5 >= 2 and v5 <= 7 then
                v5 = v6 and 80 or v5 + 238
            elseif v5 >= 15 and v5 <= 21 then
                v5 = v15 and 41 - v5 or 14
            elseif v5 >= 9 and v5 <= 14 then
                v5 = v15 and 112 or 216 - v5
            elseif v5 >= 24 and v5 <= 32 then
                v8 = {}
                v5 = 193
                v7 = v8
            elseif v5 >= 33 and v5 <= 38 then
                return true
            elseif v5 >= 39 and v5 <= 49 then
                v7 = v2[4][2]
                v5 = 23
                v20 = v7.WebhookMatchEnd
                v15 = not v20
            elseif v5 >= 50 and v5 <= 62 then
                v5, v18 = v5 + 40, v1._.os
                v8 = 3
                v7 = v18.clock() - v19[2].At
                v20 = v7 < 3
            elseif v5 >= 135 and v5 <= 146 then
                return false
            elseif v5 >= 154 and v5 <= 170 then
                v7 = v1._.os.clock()
                v8 = v19[2].At
                v7, v20 = 0.75, v7 - v8
                v5 = v20 < 0.75 and 21855 / v5 or v5 + -21
            elseif v5 >= 147 and v5 <= 152 then
                v7 = v19[2].Pending
                v5 = 8
                v20 = not v7
            elseif v5 >= 192 and v5 <= 193 then
                v20.__CameraTDMatchReports = v7
                v8 = v2[3][2]
                v7 = v8.__CameraTDMatchReports
                v20 = v7[v15]
                v5 = v20 and 147 or 1544 / v5
            elseif v5 >= 194 and v5 <= 202 then
                v5 = v15 and 208 or 20806 / v5
            elseif v5 >= 183 and v5 <= 191 then
                v7 = v1._.game.JobId
                v20 = v1._.tostring(v7)
                v8 = "/"
                v21 = "/"
                v14 = v2[1][2].UserId
                v9 = v1._.tostring
                v10 = v2[2][2].CurrentMap
                v10 = table.pack(v10())
                v9 = v9(table.unpack(v10, 1, v10.n))
                v17 = "/"
                v13 = v1._.tostring
                v6 = v2[2][2].RoundId
                v5 = v6 and 955 / v5 or 214
            elseif v5 >= 172 and v5 <= 182 then
                v5, v15 = 201 - v5, v4
            elseif v5 >= 229 and v5 <= 244 then
                v5, v6 = 19440 / v5, 0
            elseif v5 >= 246 and v5 <= 249 then
                v7 = v19[2].Pending
                v20 = not v7
                v5 = v20 and 75 or 494 - v5
            elseif v5 >= 215 and v5 <= 227 then
                v7 = v19[2].Requested
                v20 = not v7
                v5 = v20 and 380 - v5 or 56025 / v5
            elseif v5 >= 209 and v5 <= 213 then
                return true
            elseif v5 >= 203 and v5 <= 208 then
                v5, v15, v7 = 311 - v5, v2[2][2], v1._.os
                v20 = v7.clock()
                v15.ReportStartedAt = v20
            else
                return true
            end
        until false
    end
end
local function _w38(v1, v2)
    return function()
        local gUI4 = v2[1][2].GUI("Stats/Wave")
        local v3 = v2[1][2].MatchId
        local v4 = v1._.game.PlaceId == v3
        local v5, v6, v7, v8
        if v4 then
            v4 = not v2[1][2].SoloReturning
            if v4 then
                v4 = not v2[1][2].FinalSeen
                if v4 then
                    v4 = gUI4
                    if v4 then
                        v4 = v2[1][2].Visible(gUI4)
                        if v4 then
                            v4 = not v2[1][2].Final()
                            if v4 then
                                while true do
                                    v6 = gUI4.Text:lower()
                                    v6, v5, v3, v8, v7 = v6.find, "voting", v6, true, 1
                                    v4 = not v6(v3, "voting", 1, true)
                                end
                            else
                                return v4
                            end
                        else
                            return v4
                        end
                    else
                        return v4
                    end
                else
                    return v4
                end
            else
                return v4
            end
        else
            return v4
        end
    end
end
local function _w39(v1)
    return function(v2)
        local v3 = v1._.tostring
        local v4 = v2
        if v2 then
            v3 = v3(v4)
        else
            v3 = v3("")
        end
        v3 = v3:gsub("[%c<>:\"/\\|?*]", "")
        v3 = v3:sub(1, 64)
        v3 = v3:match("^%s*(.-)%s*$")
        local v5, v6
        v5, v4, v6, v3 = "[%. ]+$", v3, "", v3.gsub
        v3 = table.pack(v3(v4, "[%. ]+$", ""))
        return table.unpack(v3, 1, v3.n)
    end
end
local function _w40(v1, v2, v3, v4, v5)
    v1.Fe[v5] = bit32.band(bit32.bnot(v2), v3) * bit32.band(v2, bit32.bnot(v3)) + (bit32.bor(v3, v2) * bit32.band(v3, v2) + (-(bit32.band(bit32.bnot(bit32.bxor(bit32.bxor(4294967295, v2), bit32.bxor(v3, v2))), bit32.band(bit32.bnot(v2), v3)) * bit32.band(4294967295, bit32.band(bit32.band(v2, bit32.bnot(v3)), bit32.bnot(bit32.bxor(v4, 51496))))) + (v3 + -bit32.band(4294967295, v3)))) + -bit32.bxor(v4, 51496) + 2 * (bit32.band(bit32.bnot(bit32.bxor(v4, 51496)), bit32.band(bit32.bnot(v3), v2)) * bit32.band(bit32.bnot(v2), v3)) + -(bit32.band(bit32.bnot(v2), v3) * bit32.band(4294967295, bit32.band(bit32.bnot(bit32.bxor(v4, 51496)), bit32.band(bit32.bnot(v3), v2))))
    return v1.Fe[v5]
end
local function _w41(v1, v2, v3, v4)
    v1.Bf[v4] = v1.me(v2, v3)
    return v1.Bf[v4]
end
local function _w42(v1, v2)
    return function(v3)
        local v4 = v2[2][2].Refreshing
        local v5, v6, v7, v8, v9, v10, v11
        if v4 then
            if v4 then
                while true do
                end
            else
                v4 = v2[2][2].Playing
                if v4 then
                    if v4 then
                        v2[2][2].Notify("Stop the active macro before changing profiles")
                    else
                        v4 = v2[2][2].SafeName(v3)
                        v8 = v2[2][2]
                        v9 = v8.Read
                        v6, v8 = v4, v8.File
                        v8 = table.pack(v8(v6))
                        v9 = v9(table.unpack(v8, 1, v8.n))
                        if not v2[2][2].ValidProfile(v9) then
                            v2[2][2].SetStatus("Macro", "Load failed: invalid macro")
                            v2[2][2].RefreshProfiles()
                        else
                            v2[1][2].Profile = v4
                            v8 = v2[2][2]
                            v8.LoadedProfile = v9
                            v6, v8 = v9, v8.LearnProfileCosts
                            v8(v6)
                            v8 = v2[2][2]
                            v8.AutoPlayed = nil
                            v8.PlaybackCompleted = nil
                            v8.SaveSettings()
                            v6, v10, v5, v8, v7 = "Macro", "Loaded ", v9.Actions, v8.SetStatus, " | "
                            v11, v5 = #v5, " actions"
                            v8("Macro", "Loaded " .. v4 .. " | " .. v11 .. " actions")
                        end
                    end
                    return
                elseif v2[2][2].Recording then
                    v2[2][2].Notify("Stop the active macro before changing profiles")
                    return
                else
                    v4 = v2[2][2].SafeName(v3)
                    v8 = v2[2][2]
                    v9 = v8.Read
                    v6, v8 = v4, v8.File
                    v8 = table.pack(v8(v6))
                    v9 = v9(table.unpack(v8, 1, v8.n))
                    if not v2[2][2].ValidProfile(v9) then
                        v2[2][2].SetStatus("Macro", "Load failed: invalid macro")
                        v2[2][2].RefreshProfiles()
                    else
                        v2[1][2].Profile = v4
                        v8 = v2[2][2]
                        v8.LoadedProfile = v9
                        v6, v8 = v9, v8.LearnProfileCosts
                        v8(v6)
                        v8 = v2[2][2]
                        v8.AutoPlayed = nil
                        v8.PlaybackCompleted = nil
                        v8.SaveSettings()
                        v6, v10, v5, v8, v7 = "Macro", "Loaded ", v9.Actions, v8.SetStatus, " | "
                        v11, v5 = #v5, " actions"
                        v8("Macro", "Loaded " .. v4 .. " | " .. v11 .. " actions")
                    end
                    return
                end
            end
        elseif v3 == "(none)" then
            while true do
            end
        else
            v4 = v2[2][2].Playing
            if v4 then
                if v4 then
                    v2[2][2].Notify("Stop the active macro before changing profiles")
                else
                    v4 = v2[2][2].SafeName(v3)
                    v8 = v2[2][2]
                    v9 = v8.Read
                    v6, v8 = v4, v8.File
                    v8 = table.pack(v8(v6))
                    v9 = v9(table.unpack(v8, 1, v8.n))
                    if not v2[2][2].ValidProfile(v9) then
                        v2[2][2].SetStatus("Macro", "Load failed: invalid macro")
                        v2[2][2].RefreshProfiles()
                    else
                        v2[1][2].Profile = v4
                        v8 = v2[2][2]
                        v8.LoadedProfile = v9
                        v6, v8 = v9, v8.LearnProfileCosts
                        v8(v6)
                        v8 = v2[2][2]
                        v8.AutoPlayed = nil
                        v8.PlaybackCompleted = nil
                        v8.SaveSettings()
                        v6, v10, v5, v8, v7 = "Macro", "Loaded ", v9.Actions, v8.SetStatus, " | "
                        v11, v5 = #v5, " actions"
                        v8("Macro", "Loaded " .. v4 .. " | " .. v11 .. " actions")
                    end
                end
                return
            elseif v2[2][2].Recording then
                v2[2][2].Notify("Stop the active macro before changing profiles")
                return
            else
                v4 = v2[2][2].SafeName(v3)
                v8 = v2[2][2]
                v9 = v8.Read
                v6, v8 = v4, v8.File
                v8 = table.pack(v8(v6))
                v9 = v9(table.unpack(v8, 1, v8.n))
                if not v2[2][2].ValidProfile(v9) then
                    v2[2][2].SetStatus("Macro", "Load failed: invalid macro")
                    v2[2][2].RefreshProfiles()
                else
                    v2[1][2].Profile = v4
                    v8 = v2[2][2]
                    v8.LoadedProfile = v9
                    v6, v8 = v9, v8.LearnProfileCosts
                    v8(v6)
                    v8 = v2[2][2]
                    v8.AutoPlayed = nil
                    v8.PlaybackCompleted = nil
                    v8.SaveSettings()
                    v6, v10, v5, v8, v7 = "Macro", "Loaded ", v9.Actions, v8.SetStatus, " | "
                    v11, v5 = #v5, " actions"
                    v8("Macro", "Loaded " .. v4 .. " | " .. v11 .. " actions")
                end
                return
            end
        end
    end
end
local function _w43(v1)
    return function(v2)
        local v3
        if v1._.type(v2) ~= "string" then
            return false
        else
            v3 = v2:match("^https://discord%.com/api/webhooks/%d+/[%w_%-]+$") ~= nil
            if v3 then
                return v3
            else
                return v2:match("^https://discordapp%.com/api/webhooks/%d+/[%w_%-]+$") ~= nil
            end
        end
    end
end
local function _w44(v1)
    return function(v2, v3)
        local v4 = v1._.tonumber
        local v5 = v2.Name
        local v6
        v5, v6 = v5.match, v5
        v5 = table.pack(v5(v6, "%d+"))
        v4 = v4(table.unpack(v5, 1, v5.n))
        local v7
        if v4 then
            v5 = v1._.tonumber
            v6 = v3.Name
            v6, v7 = v6.match, v6
            v6 = table.pack(v6(v7, "%d+"))
            v5 = v5(table.unpack(v6, 1, v6.n))
            if v5 then
                return v4 < v5
            else
                return v4 < 0
            end
        else
            v5 = v1._.tonumber
            v6 = v3.Name
            v6, v7 = v6.match, v6
            v6 = table.pack(v6(v7, "%d+"))
            v5 = v5(table.unpack(v6, 1, v6.n))
            if v5 then
                return 0 < v5
            else
                return false
            end
        end
    end
end
local function _w45(v1, v2)
    return function(message)
        v2[1][2].Message = message
    end
end
local function _w46(v1, v2)
    return function(v3, v4, ...)
        if v2[2][2].Running then
            v2[1][2](v3, v4, ...)
        end
    end
end
local function _w47(v1, v2)
    return function()
        local v3 = v1:od({v2[2], v2[4], v2[1]})
        local v4, v5
        v5, v3, v4 = v1._.pcall(v3)
        local v6 = v2[3][2]
        v6.Pending = false
        local v7 = v5
        if v5 then
            v6.Sent = v3 == true
        else
            v6.Sent = v7
        end
        local v8 = {}
        v6 = v2[4][2]
        v8.Success = v2[3][2].Sent
        local v9 = v5
        if v5 then
            v9 = v4
            if v9 then
                v8.Reason = v9
            else
                v8.Reason = "Logger request failed"
            end
            v8.At = v1._.os.clock()
            v6.LoggerStatus = v8
            return
        elseif v9 then
            v8.Reason = v9
            v8.At = v1._.os.clock()
            v6.LoggerStatus = v8
            return
        else
            v8.Reason = "Logger request failed"
            v8.At = v1._.os.clock()
            v6.LoggerStatus = v8
            return
        end
    end
end
local function _w48(v1, v2)
    return function()
        local v3 = 145
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
        while true do
            if v3 == 3 then
                v17 = 0
                v3, v8 = v3 + 38, v15 > 0
            elseif v3 == 9 then
                v3 = 66
                v10 = 0
            elseif v3 == 10 then
                v3, v8 = 154 - v3, 0
            elseif v3 == 11 then
                v3 = v8 and 37 or 89
            elseif v3 == 24 then
                v3 = 223
                v10 = v17.Id
                v21[v10] = true
            elseif v3 == 25 then
                v16 = not v9
                v3 = v16 and 225 - v3 or 97
            elseif v3 == 38 then
                v16 = v16 + v7
                v3 = (v7 > 0 and v16 > v21 or v7 <= 0 and v16 < v21 or false) and 25 or v3 + 195
            elseif v3 == 43 then
                v21 = #v4
                v3 = v6 == v21 and 99 or 81
            elseif v3 == 66 then
                v3 = 102
                v8 = v17 >= v10
            elseif v3 == 97 then
                v16 = v2[1][2].PlaceCandidate()
                v21 = not v16
                v3 = v21 and 19303 / v3 or v3 + -46
            elseif v3 == 98 then
                v9 = v13.Text
                v9, v14 = v9.match, v9
                v9, v14 = v9(v14, "(%d+)%s*/%s*(%d+)")
                v6 = 0
                v11, v19, v16 = v1._.pairs(v20.PlacePending)
                v11, v19, v16 = v1.g(v11, v19, v16)
                v21 = v11(v19, v16)
                v16 = v21
                v3 = v21 == nil and 9408 / v3 or 187
            elseif v3 == 99 then
                v21 = "Cannot read equipped slot prices | cash "
                v5 = v2[1][2]
                v3, v7 = 227 - v3, v5.Cash()
                v16 = "Cannot read equipped slot prices | cash " .. v7
            elseif v3 == 103 then
                v3 = 57
                v8 = v15
            elseif v3 == 117 then
                v14, v3, v9 = v15, v3 + -92, v5
            elseif v3 == 125 then
                v2[1][2].Candidate = 0
                v5 = {Name = v9.Name, UnitId = v9.Id}
                v17 = v16.GetComponents
                v8 = {}
                v17 = v1.h(v17(v16))
                v1.j(v8, 1, v1.i(v17))
                v5.CFrame = v8
                v17, v15, v7, v12, v5 = {}, v9.Id, v5, v1._.os, v20.PlacePending
                v10 = v12.clock()
                v17.At = v10
                v17.Before = v21
                v17.Action = v7
                v17.Cost = v14
                v5[v15] = v17
                v5 = v2[1][2].Fire
                v8 = {Name = v9.Name, UnitId = v9.Id}
                v17 = v16.Position
                v8.Pos = v17
                v8.CFrame = v16
                v5, v15 = v5("TowerAdd", v8)
                v8 = not v5
                v3 = v8 and v3 + -123 or v3 + -4
            elseif v3 == 145 then
                v22 = v2[2][2]
                v4 = v22.AutoPlace
                v20 = not v4
                v3 = v20 and 221 or 74
            elseif v3 == 187 then
                v3, v5 = 371 - v3, 1
                v6 = v6 + 1
            elseif v3 == 199 then
                v2[1][2].SetStatus("Auto", "Searching for clear ground beside the path")
                return false
            elseif v3 == 200 then
                v21 = #v4
                v16 = nil
                v3 = v11 == v21 and 32600 / v3 or 243 - v3
            elseif v3 == 201 then
                v19, v3, v16, v21 = v1._.tonumber(v9) + v6, 277 - v3, v1._.tonumber, v14
                v16 = v16(v21)
                v11 = v19 >= v16
            elseif v3 == 223 then
                v8, v17 = v7(v5, v15)
                v15 = v8
                v3 = v8 == nil and 125 or v3 + -199
            elseif v3 >= 26 and v3 <= 32 then
                v3 = 156
                v8 = 1
                v11 = v11 + 1
            elseif v3 >= 33 and v3 <= 37 then
                v8 = 1
                v3, v6 = 89, v6 + 1
            elseif v3 >= 44 and v3 <= 51 then
                v21 = {}
                v7 = v1._.ipairs
                v5 = v2[1][2].Owned
                v5 = v1.h(v5())
                v7, v5, v15 = v7(v1.i(v5))
                v7, v5, v15 = v1.g(v7, v5, v15)
                v8, v17 = v7(v5, v15)
                v15 = v8
                v3 = v8 == nil and v3 + 74 or 24
            elseif v3 >= 39 and v3 <= 42 then
                v3 = v8 and 861 / v3 or 280 - v3
            elseif v3 >= 12 and v3 <= 23 then
                v3 = 239
                v8 = v15 <= v22
            elseif v3 >= 4 and v3 <= 8 then
                v2[1][2].SetStatus("Auto", "Tower limit reached / reserved")
                return false
            elseif v3 <= 2 then
                v20.PlacePending[v9.Id] = nil
                v3 = 185
                v20.SlotCooldowns[v9.Id] = v1._.os.clock() + 2
                v17 = v2[1][2]
                v10, v12, v8, v17 = v1._.tostring, v15, v17.SetStatus, "Auto"
                v10 = table.pack(v10(v12))
                v8("Auto", table.unpack(v10, 1, v10.n))
            elseif v3 >= 90 and v3 <= 96 then
                v11 = v9
                v3 = v9 and 201 or 76
            elseif v3 >= 82 and v3 <= 89 then
                v10 = v5.Id
                v17 = v20.PlacePending
                v8 = v17[v10]
                v3 = v8 and 32 or 156
            elseif v3 >= 100 and v3 <= 102 then
                v3 = v8 and 103 or 57
            elseif v3 >= 77 and v3 <= 79 then
                v6 = 0
                v9 = nil
                v14 = nil
                v11 = 0
                v21 = #v4
                v19 = v1._.math.huge
                v16 = 1
                v7 = 1
                v3 = (1 > v21 or false) and 25 or 18407 / v3
            elseif v3 >= 75 and v3 <= 76 then
                v3 = v11 and 532 / v3 or 79
            elseif v3 >= 80 and v3 <= 81 then
                v3 = v19 > v22 and 18306 / v3 or 136
            elseif v3 >= 52 and v3 <= 55 then
                v17 = v1._.os.clock()
                v18 = v5.Id
                v10 = v20.SlotCooldowns[v18]
                v3 = v10 and 66 or 9
            elseif v3 >= 56 and v3 <= 65 then
                v3 = v8 and 60 - v3 or 41
            elseif v3 >= 67 and v3 <= 74 then
                v4 = v2[1][2]
                v20 = v4.Auto
                v4 = v4.Equipped()
                v22 = v20.Budget()
                v13 = #v4
                v9 = 0
                v3 = v13 == 0 and 228 - v3 or v3 + 95
            elseif v3 >= 188 and v3 <= 198 then
                v3, v17 = 21384 / v3, 0
                v8 = v15 > 0
            elseif v3 >= 185 and v3 <= 186 then
                return true
            elseif v3 >= 170 and v3 <= 184 then
                v21 = v11(v19, v16)
                v16 = v21
                v3 = v21 == nil and 280 - v3 or v3 + 3
            elseif v3 >= 234 and v3 <= 237 then
                v10 = v20.PlacePending
                v17 = v10[v5.Id]
                v8 = not v17
                v3 = v8 and 55 or 102
            elseif v3 >= 227 and v3 <= 233 then
                v8 = v20.SlotIndex
                v3 = v8 and 377 - v3 or 10
            elseif v3 >= 202 and v3 <= 222 then
                return false
            elseif v3 >= 224 and v3 <= 226 then
                v3, v15, v21 = v3 + -98, " / cheapest ", "Waiting for money | available "
                v5 = " / cheapest " .. v19
                v7 = v22 .. v5
                v16 = "Waiting for money | available " .. v7
            elseif v3 >= 118 and v3 <= 120 then
                v17 = v19
                v10 = v15
                v3, v8 = v3 + 118, v1._.math.min(v17, v10)
                v19 = v8
            elseif v3 >= 104 and v3 <= 116 then
                v3 = v8 and 227 - v3 or 237
            elseif v3 >= 126 and v3 <= 128 then
                v2[1][2].SetStatus("Auto", v16)
                return false
            elseif v3 >= 121 and v3 <= 124 then
                v8 = v2[1][2].SetStatus
                v17 = "Auto"
                v3 = 185
                v10 = "Placing " .. v9.Name .. " | waiting for tower confirmation"
                v8("Auto", v10)
            elseif v3 >= 129 and v3 <= 136 then
                v3 = 128
                v21 = "Waiting for slot cooldown / pending confirmation | available "
                v16 = "Waiting for slot cooldown / pending confirmation | available " .. v22
            elseif v3 >= 146 and v3 <= 154 then
                v2[1][2].SetStatus("Auto", "Waiting for equipped loadout from local replica")
                return false
            elseif v3 >= 143 and v3 <= 144 then
                v8, v15 = 1, v8 % #v4
                v20.SlotIndex = v15 + 1
                v5 = v4[v20.SlotIndex]
                v8 = v5.Name
                v17 = v5
                v15 = v2[1][2].UnitCost(v8, v17)
                v8 = not v15
                v3 = v8 and 11 or 142
            elseif v3 >= 137 and v3 <= 142 then
                v3, v17 = 153 - v3, 0
                v8 = v15 <= 0
            elseif v3 >= 157 and v3 <= 163 then
                v5 = " slot(s) pending"
                v21 = "Waiting for TowerAdd confirmation | "
                v3, v7 = 291 - v3, v11 .. " slot(s) pending"
                v16 = "Waiting for TowerAdd confirmation | " .. v7
            elseif v3 >= 155 and v3 <= 156 then
                v8 = v15
                v3 = v15 and 354 - v3 or v3 + -48
            elseif v3 >= 164 and v3 <= 169 then
                v9 = "Stats/OtherUI/Towers"
                v13 = v2[1][2].GUI("Stats/OtherUI/Towers")
                v3 = v13 and 267 - v3 or 79
            else
                v3 = v8 and 27963 / v3 or 38
            end
        end
    end
end
local function _w49(v1, v2)
    return function(v3)
        v2[2][2].PlaybackMode = v1._.tostring(v3)
        v2[1][2].SaveSettings()
    end
end
local function _w50(v1, v2)
    return function(v3)
        local v4, v5, v6
        if v2[1][2].Attempts == 0 then
            while true do
            end
        else
            v5 = {}
            v4 = v2[1][2].Log
            v5.state = v1._.tostring(v3)
            v4("teleport_state", v5)
            v4 = v3 == v1._.Enum.TeleportState.Started
            if v4 then
                if v4 then
                    v4 = v2[1][2]
                    v6 = v4.InFlight
                    if v6 then
                        v4.InFlight = v6
                    else
                        v4.InFlight = v1._.os.clock()
                    end
                    v2[1][2].Status("Teleporting to lobby")
                    return
                elseif v3 == v1._.Enum.TeleportState.Failed then
                    v2[1][2].InFlight = nil
                    return
                else
                    return
                end
            elseif v3 == v1._.Enum.TeleportState.InProgress then
                v4 = v2[1][2]
                v6 = v4.InFlight
                if v6 then
                    v4.InFlight = v6
                else
                    v4.InFlight = v1._.os.clock()
                end
                v2[1][2].Status("Teleporting to lobby")
                return
            else
                if v3 == v1._.Enum.TeleportState.Failed then
                    v2[1][2].InFlight = nil
                end
                return
            end
        end
    end
end
local function _w51(v1, v2)
    return function()
        local v3 = 248
        local v4, v5, v6, v7, v8, v9, v10, v11, v12
        while true do
            if v3 == 48 then
                v10, v6 = v4(v9, v11)
                v11 = v10
                v3 = v10 == nil and 38 or 235
            elseif v3 == 194 then
                v3 = 48
                v12(v7, v5)
            elseif v3 >= 195 and v3 <= 235 then
                v12 = v1._.table.insert
                v7 = v8
                v5 = v2[2][2].ModifierCatalog[v6]
                v3 = v5 and 194 or 141
            elseif v3 >= 49 and v3 <= 193 then
                v3, v5 = 27354 / v3, v6
            elseif v3 <= 47 then
                return v8
            else
                v2[2][2].ModifierOptions()
                v8 = {}
                v4, v9, v11 = v1._.ipairs(v2[1][2].Modifiers)
                v4, v9, v11 = v1.g(v4, v9, v11)
                v10, v6 = v4(v9, v11)
                v11 = v10
                v3 = v10 == nil and 38 or 235
            end
        end
    end
end
local function _w52(v1, v2)
    return function()
        local v3 = 152
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
        while true do
            if v3 == 43 then
                v11, v6 = v5(v4, v10)
                v10 = v11
                v3 = v11 == nil and 240 - v3 or 5504 / v3
            elseif v3 == 88 then
                v7 = v2[2][2]
                v12, v7, v9 = v6.Text, v11.Name, v7.ModifierCatalog
                v3, v9[v7] = 96, v12
            elseif v3 == 128 then
                v3, v12, v9, v7 = v3 + -85, v6, v1._.table.insert, v8
                v9(v7, v12)
            elseif v3 == 197 then
                v1._.table.sort(v8)
                return v8
            elseif v3 >= 75 and v3 <= 87 then
                v9 = v6
                v3 = v6 and 180 or 23
            elseif v3 >= 44 and v3 <= 74 then
                v9 = v11
                v3 = 75
                v6 = v2[2][2].Path(v9, "Holder/Title")
            elseif v3 >= 24 and v3 <= 42 then
                v11 = v2[2][2]
                v8 = {}
                v5, v4, v10 = v1._.pairs(v11.ModifierCatalog)
                v5, v4, v10 = v1.g(v5, v4, v10)
                v11, v6 = v5(v4, v10)
                v10 = v11
                v3 = v11 == nil and v3 + 158 or 4992 / v3
            elseif v3 >= 9 and v3 <= 23 then
                v3 = v9 and 88 or 119 - v3
            elseif v3 <= 8 then
                v9 = v11.Name
                v6 = v9 ~= "Template"
                v3 = v6 and 74 or 600 / v3
            elseif v3 >= 153 and v3 <= 196 then
                v3, v9 = v3 + -157, v6.Text ~= ""
            elseif v3 >= 129 and v3 <= 152 then
                v8 = v2[2][2]
                v4, v8, v13 = "PlayerGui", v2[1][2], v8.Path
                v8 = v8:FindFirstChild("PlayerGui")
                v5 = "ElevatorGui/Modifiers/List/ScrollingFrame"
                v13 = v13(v8, "ElevatorGui/Modifiers/List/ScrollingFrame")
                v3 = v13 and 225 or 39
            elseif v3 >= 89 and v3 <= 127 then
                v10, v11 = v8(v5, v4)
                v4 = v10
                v3 = v10 == nil and v3 + -57 or v3 + -88
            else
                v5 = v13.GetChildren
                v8 = v1._.ipairs
                v5 = v1.h(v5(v13))
                v8, v5, v4 = v8(v1.i(v5))
                v8, v5, v4 = v1.g(v8, v5, v4)
                v10, v11 = v8(v5, v4)
                v4 = v10
                v3 = v10 == nil and v3 + -186 or 1800 / v3
            end
        end
    end
end
local function _w53(v1, v2)
    return function(v3)
        v2[2][2].HideName = v3 == true
        local v4 = v2[3][2].BindHiddenNameCharacter
        local v5
        if v2[2][2].HideName then
            v5 = v2[1][2].Character
            if v5 then
                v4(v5)
            else
                v4(nil)
            end
        else
            v4(nil)
        end
    end
end
local function _w54(v1, v2)
    return function(v3, v4)
        local v5 = 232
        local v6, v7, v8, v9, v10, v11, v12, configUnit
        repeat
            if v5 == 14 then
                v5 = 186
                v8 = nil
            elseif v5 == 35 then
                v10 = v9(v6)
                v5 = v10 and 6545 / v5 or 97
            elseif v5 == 63 then
                v11 = v4
                v8 = v9(v4)
                v5 = v8 and 277 - v5 or 124 - v5
            elseif v5 == 126 then
                v5 = 50
                v9 = configUnit
            elseif v5 == 143 then
                v5 = v8 and 186 or v5 + -129
            elseif v5 == 185 then
                v5, v12 = 328 - v5, v2[1][2].KnownCosts
                v11 = v12[v3]
                v8 = v11[1]
            elseif v5 == 186 then
                return v8
            elseif v5 == 187 then
                return v10
            elseif v5 == 214 then
                return v8
            elseif v5 >= 127 and v5 <= 142 then
                v5 = 117
                v9 = configUnit.Stats
            elseif v5 >= 144 and v5 <= 151 then
                return v8
            elseif v5 >= 152 and v5 <= 184 then
                v10 = v6.Name
                v5 = v10 == v3 and 35 or 97
            elseif v5 >= 215 and v5 <= 230 then
                v9 = configUnit[1]
                v5 = v9 and 347 - v5 or 30820 / v5
            elseif v5 >= 188 and v5 <= 213 then
                v11 = v8
                v5 = v8 and 11564 / v5 or 30
            elseif v5 >= 231 and v5 <= 232 then
                configUnit = v2[1][2].ConfigUnit(v3)
                v9 = v1._.type(configUnit)
                v8 = "table"
                v5 = v9 == "table" and 230 or 13
            elseif v5 >= 57 and v5 <= 59 then
                v12 = 0
                v5, v11 = v5 + -29, v8 > 0
            elseif v5 >= 60 and v5 <= 62 then
                v12 = v2[1][2]
                v11 = v12.KnownCosts
                v8 = v11[v3]
                v5 = v8 and v5 + 124 or 143
            elseif v5 >= 64 and v5 <= 92 then
                v5, v11 = v5 + -45, v9.Cost
            elseif v5 >= 93 and v5 <= 97 then
                v7, v6 = v8(v11, v12)
                v12 = v7
                v5 = v7 == nil and 61 or 249 - v5
            elseif v5 >= 98 and v5 <= 125 then
                v5 = v9 and 167 - v5 or 14742 / v5
            elseif v5 >= 36 and v5 <= 47 then
                v5, v8 = 196, v8(v11)
            elseif v5 >= 48 and v5 <= 50 then
                v11 = v1._.type(v9)
                v12 = "table"
                v8 = v11 == "table"
                v5 = v8 and 11850 / v5 or v5 + 146
            elseif v5 >= 51 and v5 <= 56 then
                v8 = v1._.ipairs
                v11 = v2[1][2].Equipped
                v11 = v1.h(v11())
                v8, v11, v12 = v8(v1.i(v11))
                v8, v11, v12 = v1.g(v8, v11, v12)
                v7, v6 = v8(v11, v12)
                v12 = v7
                v5 = v7 == nil and 3416 / v5 or 8512 / v5
            elseif v5 <= 13 then
                v9 = v1:hc({v2[1]})
                v5 = v4 and 819 / v5 or 56
            elseif v5 >= 15 and v5 <= 34 then
                v5 = v11 and 151 or 390 / v5
            else
                v8 = v1._.tonumber
                v11 = v9.Price
                v5 = v11 and 47 or 329 - v5
            end
        until false
    end
end
local function _w55(v1, v2)
    return function(v3)
        local v4, v5, v6, v7
        if v2[2][2].ChangingToggle then
            return
        else
            v6 = v2[1][2]
            v6.AutoPlayback = v3 == true
            v6 = v6.AutoPlayback
            if v6 then
                if v2[2][2].Recording then
                    if not v2[2][2].StopRecord() then
                        v2[1][2].AutoPlayback = false
                        v2[2][2].SetToggle("Playback", false)
                    else
                        v6 = v2[2][2]
                        v6.AutoPlayed = nil
                        v6.PlaybackCompleted = nil
                        v6, v4 = v6.Next, 0
                        v6.AutoPlayback = 0
                        v6, v4 = v2[2][2].StartPlayback()
                        v5 = v2[2][2]
                        v7 = v6 or v4 ~= "wait"
                        if v7 then
                            v5.AutoPlayed = v7
                        else
                            v5.AutoPlayed = nil
                        end
                        if not v6 then
                            if v4 == "wait" then
                                v2[2][2].SetStatus("Macro", "Playback armed: waiting for match")
                            end
                        end
                    end
                else
                    v6 = v2[2][2]
                    v6.AutoPlayed = nil
                    v6.PlaybackCompleted = nil
                    v6, v4 = v6.Next, 0
                    v6.AutoPlayback = 0
                    v6, v4 = v2[2][2].StartPlayback()
                    v5 = v2[2][2]
                    v7 = v6 or v4 ~= "wait"
                    if v7 then
                        v5.AutoPlayed = v7
                    else
                        v5.AutoPlayed = nil
                    end
                    if not v6 then
                        if v4 == "wait" then
                            v2[2][2].SetStatus("Macro", "Playback armed: waiting for match")
                        end
                    end
                end
                v2[2][2].SaveSettings()
                return
            elseif v2[2][2].Playing then
                v2[2][2].StopPlayback("Stopped by user")
                v2[2][2].SaveSettings()
                return
            else
                v2[2][2].SaveSettings()
                return
            end
        end
    end
end
local function _w56(v1, v2)
    return function(v3)
        local v4 = v2[1][2]
        local v5 = v4.SkipAutomationThreads
        local v6
        if not v5 then
            v5 = v1._.setmetatable({}, {__mode = "k"})
        end
        v4.SkipAutomationThreads = v5
        v4 = v1._.coroutine.running()
        v6 = v2[1][2]
        v5 = v6.SkipAutomationThreads[v4]
        local wave = v6.Wave()
        v6.SkipAutomationThreads[v4] = v3
        v6 = v1._.table.pack
        local v7 = v1._.pcall
        local v8 = v2[1][2].Fire
        v7 = v1.h(v7(v8, "WaveSkip"))
        v6 = v6(v1.i(v7))
        v2[1][2].SkipAutomationThreads[v4] = v5
        local v9
        if not v6[1] then
            return false, "WaveSkip call failed"
        elseif v6[2] then
            v2[1][2].SkipSubmittedWave = wave
            v7 = v1._.table.unpack
            v9 = v6.n
            v7 = table.pack(v7(v6, 2, v9))
            return table.unpack(v7, 1, v7.n)
        else
            v7 = v1._.table.unpack
            v9 = v6.n
            v7 = table.pack(v7(v6, 2, v9))
            return table.unpack(v7, 1, v7.n)
        end
    end
end
local function _w57(v1, v2)
    return function()
        local v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
        if v2[2][2].Rejoin then
            while true do
            end
        else
            if v2[1][2].CameraTDRejoinTest then
                if v2[1][2].CameraTDRejoinTest.Stop then
                    v1._.pcall(v2[1][2].CameraTDRejoinTest.Stop)
                end
            end
            v5 = {Active = true, Armed = true, Attempts = 0, Connections = {}}
            v5.At = v1._.os.clock()
            v5.Sequence = 0
            v11 = {[1] = 2, [2] = v5}
            v11[3] = v11
            v2[2][2].Rejoin = v11[2]
            v5 = v1._.game
            v5, v9 = v5.GetService, v5
            v9 = {[1] = 2, [2] = v5(v9, "Players").LocalPlayer}
            v9[3] = v9
            v10 = v1._.game
            v7, v10 = v10, v10.GetService
            v10 = {[1] = 2, [2] = v10(v7, "TeleportService")}
            v10[3] = v10
            v1._.game:GetService("HttpService")
            v12 = v1._.game
            v12, v13 = v12.GetService, v12
            v12 = {[1] = 2, [2] = v12(v13, "CoreGui")}
            v12[3] = v12
            v4 = {}
            v4[3], v4[2], v4[1] = 20, 10, 3
            v13 = {[1] = 2, [2] = v4}
            v13[3] = v13
            v4 = v1:rc({v11})
            v11[2].Log = v4
            v4 = v1:qc({v11})
            v11[2].Status = v4
            v4 = v1:tc({v11})
            v11[2].Connect = v4
            v4 = {[1] = 2, [2] = v4}
            v4[3] = v4
            v4[2] = v1:oc()
            v8 = v1:uc({v4, v12})
            v11[2].ReadPrompt = v8
            v8 = v1:kc()
            v11[2].ConnectionError = v8
            v8 = v1:mc({v11})
            v11[2].Reset = v8
            v8 = v1:pc({v2[1], v11, v9, v13, v10})
            v11[2].Step = v8
            v8 = v1:sc({v11})
            v11[2].Stop = v8
            v8 = v11[2].Connect
            v6 = v1:vc({v11, v9})
            v8(v10[2].TeleportInitFailed, v6)
            v11[2].Connect(v9[2].OnTeleport, v1:nc({v11}))
            v3 = v1._.task
            v3, v8 = v1:lc({v11, v2[2]}), v3.spawn
            v8(v3)
            return
        end
    end
end
local function _w58(v1, v2, v3, v4)
    v1.vf[v4] = bit32.bxor(bit32.bor(v3, 4294967295), bit32.bnot(v3)) + (bit32.bnot(bit32.bor(bit32.bnot(v3), bit32.bnot(bit32.bxor(v2, 57339)))) + (bit32.band(bit32.band(65535, bit32.bxor(v2, 57339)), bit32.bnot(bit32.band(65535, v3))) * bit32.band(bit32.band(v3, 65535), bit32.bnot(bit32.band(bit32.bxor(v2, 57339), 65535))) + bit32.band(bit32.band(65535, v3), bit32.band(65535, bit32.bxor(v2, 57339))) * bit32.bor(bit32.band(65535, v3), bit32.band(65535, bit32.bxor(v2, 57339))) - bit32.band(bit32.bxor(v2, 57339), 65535) * bit32.band(65535, v3) + -bit32.bxor(bit32.band(v3, v3), 0)) + bit32.bxor(bit32.bor(bit32.bxor(v2, 57339), bit32.bxor(v2, 57339)), bit32.bxor(v3, v3))) + -bit32.bxor(v2, 57339)
    return v1.vf[v4]
end
local function _w59(v1, v2)
    return function()
        local v3 = 201
        local v4, v5, v6, v7, v8, v9, v10, v11, v12
        repeat
            if v3 == 43 then
                v10 = 1
                v3 = 127
                v1._.task.wait(1)
            elseif v3 == 149 then
                v11 = v2[1][2]
                v3, v7 = 208 - v3, v11.Active
            elseif v3 == 150 then
                v3 = 43
                v6 = v2[1][2]
                v5, v12, v9, v6, v4 = {}, v10, v1._.tostring, "monitor_error", v6.Log
                v5.error = v9(v12)
                v4("monitor_error", v5)
            elseif v3 == 201 then
                v3 = 127
            elseif v3 >= 127 and v3 <= 148 then
                v11 = v2[2][2]
                v7 = v11.Running
                v3 = v7 and 149 or 186 - v3
            elseif v3 <= 42 then
                v8 = v2[1][2].Log
                v10 = "prompt_read_error"
                v4 = {}
                v3, v4.error = 43, v1._.tostring(v11)
                v8("prompt_read_error", v4)
            elseif v3 >= 44 and v3 <= 126 then
                v3 = v7 and 272 - v3 or 153
            elseif v3 >= 154 and v3 <= 200 then
                v10 = v2[1][2].Step
                v8, v10 = v1._.pcall(v10, v11)
                v3 = not v8 and 26100 / v3 or 43
            elseif v3 >= 151 and v3 <= 153 then
                return
            else
                v11 = v2[1][2].ReadPrompt
                v7, v11 = v1._.pcall(v11)
                v3 = v7 and 387 - v3 or 4899 / v3
            end
        until false
    end
end
local function _w60(v1, v2)
    return function()
        local v3 = 252
        local v4, v5, v6, v7, v8, v9, v10
        while true do
            if v3 == 93 then
                v8 = v1._.table.insert
                v3 = 13485 / v3
                v8(v9, v10)
            elseif v3 == 110 then
                v4 = v2[1][2]
                v4, v9 = v4.InventoryData, v4.Inventory
                v3 = 67
                v9(v4)
            elseif v3 >= 150 and v3 <= 224 then
                v3 = v8 > 0 and v3 + -131 or 145
            elseif v3 >= 111 and v3 <= 145 then
                v5, v10 = v4(v7, v6)
                v6 = v5
                v3 = v5 == nil and 108 or 42
            elseif v3 >= 146 and v3 <= 149 then
                v3 = 224
                v8 = 0
            elseif v3 >= 43 and v3 <= 92 then
                v9 = {}
                v5 = v2[1][2]
                v4, v7, v6 = v1._.pairs(v5.Units)
                v4, v7, v6 = v1.g(v4, v7, v6)
                v5, v10 = v4(v7, v6)
                v6 = v5
                v3 = v5 == nil and 108 or 42
            elseif v3 <= 42 then
                v8 = v1._.tonumber(v10.Equipped)
                v3 = v8 and v3 + 182 or v3 + 107
            elseif v3 >= 94 and v3 <= 109 then
                v7 = v1._.table
                v6, v7, v4 = v1:ec(), v9, v7.sort
                v4(v7, v6)
                return v9
            else
                v4 = v2[1][2]
                v9 = v4.InventoryData
                v3 = v9 and 110 or 67
            end
        end
    end
end
local function _w61(v1, v2, v3)
    v1.Le[v3] = v2
    return v1.Le[v3]
end
local function _w62(v1, v2, v3, v4)
    v1.Ue[v4] = v1.me(v2, v3)
    return v1.Ue[v4]
end
local function _w63(v1, v2)
    return function()
        local v3 = 80
        local v4, v5, v6, v7, v8
        while true do
            if v3 == 16 then
                v5 = v1._.task
                v5, v4 = v2[1][2], v5.wait
                v5 = v5.AutoSummon
                v3 = v5 and v3 + 34 or 69 - v3
            elseif v3 == 29 then
                v3 = v3 + -4
                v4(v5)
            elseif v3 == 80 then
                v3 = 25
            elseif v3 == 176 then
                v3 = v4 and v3 + -114 or v3 + -160
            elseif v3 <= 15 then
                return
            elseif v3 >= 17 and v3 <= 28 then
                v5 = v2[2][2]
                v4 = v5.Running
                v3 = v4 and v3 + 17 or 1
            elseif v3 >= 43 and v3 <= 50 then
                v3 = 53
                v5 = v2[1][2].SummonDelay
            elseif v3 >= 30 and v3 <= 42 then
                v5 = v2[1][2]
                v4 = v5.AutoSummon
                v3 = v4 and 8988 / v3 or 227 - v3
            elseif v3 >= 81 and v3 <= 89 then
                v3 = 103
                v6 = "Summon x" .. v2[1][2].SummonAmount .. " request completed; check inventory"
            elseif v3 >= 51 and v3 <= 53 then
                v3 = v5 and 29 or 229
            elseif v3 >= 54 and v3 <= 79 then
                v5 = v2[2][2]
                v8, v7, v4, v5 = v2[1][2], "Basic Crate", v5.Invoke, "SummonTowers"
                v4, v5 = v4("SummonTowers", "Basic Crate", v8.SummonAmount)
                v7 = v2[2][2].SetStatus
                v6 = v4
                v8 = "Summon"
                v3 = v6 and v3 + 27 or v3 + 41
            elseif v3 >= 196 and v3 <= 214 then
                v5 = v1._.game.PlaceId
                v8 = v2[2][2]
                v3, v7 = v3 + -29, v8.LobbyId
                v4 = v5 == v7
            elseif v3 >= 215 and v3 <= 229 then
                v3 = 29
                v5 = 0.5
            elseif v3 >= 177 and v3 <= 185 then
                v3 = v4 and 195 or 32560 / v3
            elseif v3 >= 186 and v3 <= 195 then
                v3, v7 = v3 + -19, v2[2][2]
                v5 = v7.Teleporting
                v4 = not v5
            elseif v3 >= 104 and v3 <= 175 then
                v3 = 16
                v7(v8, v6)
            elseif v3 >= 90 and v3 <= 103 then
                v3 = v6 and 158 or v3 + 142
            else
                v3 = 158
                v6 = "Summon call failed: " .. v1._.tostring(v5)
            end
        end
    end
end
local function _w64(v1, v2)
    return function(v3, v4)
        local v5 = v2[1][2]
        local v6 = {Type = v3, Data = v4}
        v6.At = v1._.os.clock()
        v5.LastEvent = v6
    end
end
local function _w65(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5 = v3
        local v6 = v1._.tostring
        if v3 then
            v6 = v6(v5)
        else
            v6 = v6("")
        end
        v4.WebhookURL = v6:match("^%s*(.-)%s*$")
        v2[1][2].SaveSettings()
    end
end
local function _w66(v1, v2)
    return function()
        local v3
        if v2[2][2].Widgets.Macro then
            v3 = v2[2][2].Widgets.Macro
            if v2[4][2] then
                v3:SetTitle("State: Recording")
            elseif v2[2][2].Playing then
                v3:SetTitle("State: Playback")
            elseif v2[2][2].PlaybackFailure then
                v3:SetTitle("State: Playback stopped")
            elseif v2[1][2].AutoPlayback then
                v3:SetTitle("State: Playback armed")
            else
                v3:SetTitle("State: Idle")
            end
            if v2[2][2].Widgets.MacroActions then
                v2[2][2].Widgets.MacroActions:SetTitle("Recorded actions: " .. v2[3][2])
            end
            while true do
            end
        elseif v2[2][2].Widgets.MacroActions then
            v2[2][2].Widgets.MacroActions:SetTitle("Recorded actions: " .. v2[3][2])
            while true do
            end
        else
            while true do
            end
        end
    end
end
local function _w67(v1, v2)
    return function()
        local v3 = v2[1][2].HiddenNameOriginal
        local v4, v5
        v5, v3, v4 = v1._.pairs(v3)
        v5, v3, v4 = v1.g(v5, v3, v4)
        local v6, v7
        v6, v7 = v5(v3, v4)
        v4 = v6
        local v8
        if v6 == nil then
            v2[1][2].HiddenNameOriginal = v1._.setmetatable({}, {__mode = "k"})
            return
        else
            while true do
                v6 = {[1] = 2, [2] = v6}
                v6[3] = v6
                v7 = {[1] = 2, [2] = v7}
                v8 = v1:Rb({v6, v7})
                v1._.pcall(v8)
                v6, v7 = v5(v3, v4)
                v4 = v6
                if v6 == nil then
                    v2[1][2].HiddenNameOriginal = v1._.setmetatable({}, {__mode = "k"})
                    return
                else
                    continue
                end
            end
        end
    end
end
local function _w68(v1, v2)
    return function(v3)
        local v4 = v1._.math
        local v5 = v2[2][2]
        local v6, v7
        v4, v6, v7 = v1._.tonumber, v3, v4.clamp
        v4 = v4(v6)
        if v4 then
            v5.SummonDelay = v7(v4, 0.1, 10)
        else
            v5.SummonDelay = v7(1, 0.1, 10)
        end
        v2[1][2].SaveSettings()
    end
end
local function _w69(v1, v2)
    return function(v3, v4)
        local v5
        if not v4 then
            v5 = v1._.Enum.UserInputType.MouseButton1
            if v3.UserInputType == v5 then
                v2[1][2].CloseClick()
            end
        end
        while true do
        end
    end
end
local function _w70(v1, v2)
    return function()
        local v3 = 199
        local v4, v5, v6, v7, v8, v9, v10, spawningHitbox
        repeat
            if v3 == 33 then
                spawningHitbox = v8:FindFirstChild("SpawningHitbox", true)
                v3 = spawningHitbox and v3 + 193 or 18
            elseif v3 == 222 then
                v9 = v1._.ipairs
                v5 = v6.GetChildren
                v5 = v1.h(v5(v6))
                v9, v5, v7 = v9(v1.i(v5))
                v9, v5, v7 = v1.g(v9, v5, v7)
                v10, v8 = v9(v5, v7)
                v7 = v10
                v3 = v10 == nil and 295 - v3 or 33
            elseif v3 >= 199 and v3 <= 221 then
                v6 = v2[2][2]
                v4 = v6.Close
                v6, v9, v5 = v6.Path, v2[1][2], "Game/Towers"
                v6 = v6(v9, "Game/Towers")
                v5 = v2[1][2]
                v9 = v2[2][2].Path(v5, "Game/Paths")
                v4.TowerRoot = v6
                v4.PathRoot = v9
                v5, v9, v6 = "Game/PlacingTowers", v5, v2[2][2].Path
                v6 = v6(v9, "Game/PlacingTowers")
                v9 = nil
                v7 = {}
                v4.Preview, v5 = nil, v7
                v4.Hitboxes = v5
                v3 = v6 and 222 or 73
            elseif v3 >= 223 then
                v4.Hitboxes[spawningHitbox] = true
                v3, v4.Preview = 18, v8
            elseif v3 <= 32 then
                v10, v8 = v9(v5, v7)
                v7 = v10
                v3 = v10 == nil and 1314 / v3 or 33
            end
        until false
    end
end
local function _w72(v1, v2)
    return function()
        v2[1][2]:CaptureController()
        local v3 = v2[1][2]
        local v4 = v1._.Vector2.new
        local pack = table.pack(v4(0, 0))
        v3:ClickButton2(table.unpack(pack, 1, pack.n))
    end
end
local function _w73(v1, v2)
    return function(v3)
        local v4, v5
        if v2[2][2].Running then
            if v2[4][2].HideName then
                v5 = v2[1][2]
                v5, v4 = v2[3][2], v5.Character
                if v4 == v5 then
                    v2[2][2].HideOwnNameObject(v3)
                end
            end
        end
        while true do
        end
    end
end
local function _w74(v1, v2)
    return function()
        v2[2][2]:SetDesc(v2[1][2])
    end
end
local function _w75(v1)
    return function(v2, v3)
        return v2.Distance < v3.Distance
    end
end
local function _w76(v1, v2)
    return function()
        local v3 = v2[1][2]
        v3.Prompt = nil
        v3.Attempts = 0
        v3.NextAt = nil
        v3.InFlight = nil
    end
end
local function _w77(v1, v2)
    return function()
        local v3 = 250
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
        repeat
            if v3 == 27 then
                v12 = v11[2]
                v3 = 159
                v13 = "Model"
                v4 = v11[2].IsA(v12, "Model")
                v5 = not v4
            elseif v3 == 64 then
                v3, v6 = 2048 / v3, v10.Name
                v8 = v6 == v13[2]
            elseif v3 == 77 then
                v3 = 89
                v8 = v1._.os.clock() - v10.At < 0.1
            elseif v3 == 92 then
                v1._.task.delay(0.15, v1:Cc({v13, v2[1], v4, v12, v11, v5, v7}))
                return
            elseif v3 == 125 then
                v5 = v2[1][2]
                v3 = 220
                v11 = v5.SoloReturning
            elseif v3 == 207 then
                return
            elseif v3 == 250 then
                v11 = v2[1][2]
                v7 = {[1] = 2, [2] = v11.Close}
                v7[3] = v7
                v4 = v11
                v5 = v11.Running
                v11 = not v5
                v3 = v11 and 70 or 107
            elseif v3 >= 28 and v3 <= 40 then
                v3 = v8 and 254 or v3 + 186
            elseif v3 >= 12 and v3 <= 26 then
                v5 = v2[1][2]
                v3 = 3
                v11 = v5.Final()
            elseif v3 <= 3 then
                v3 = v11 and 109 or 164 - v3
            elseif v3 >= 4 and v3 <= 5 then
                v3, v4 = 205 / v3, v1._.game
                v5 = v4.PlaceId
                v12 = v2[1][2]
                v4 = v12.MatchId
                v11 = v5 ~= v4
            elseif v3 >= 6 and v3 <= 11 then
                v3 = v8 and 207 or 92
            elseif v3 >= 65 and v3 <= 76 then
                v3 = v11 and v3 + -29 or 75 - v3
            elseif v3 >= 41 and v3 <= 63 then
                v3 = v11 and v3 + 179 or 125
            elseif v3 >= 93 and v3 <= 108 then
                v3, v5 = 177 - v3, v7[2].Enabled
                v11 = not v5
            elseif v3 >= 78 and v3 <= 91 then
                v3 = v8 and v3 + -25 or 32
            elseif v3 >= 221 and v3 <= 236 then
                return
            elseif v3 >= 219 and v3 <= 220 then
                v3 = v11 and 223 - v3 or 12
            elseif v3 >= 208 and v3 <= 218 then
                v3 = v8 and 149 or v3 + -207
            elseif v3 >= 237 and v3 <= 249 then
                v2[1][2].CloseRefresh()
                v11 = {[1] = 2, [2] = v7[2].Preview}
                v11[3] = v11
                v5 = not v11[2]
                v3 = v5 and 159 or v3 + -217
            elseif v3 >= 167 and v3 <= 206 then
                return
            elseif v3 >= 162 and v3 <= 166 then
                v5 = v1._.os.clock()
                v7[2].LastClickAt = v5
                v5 = v7[2].ClickSerial + 1
                v7[2].ClickSerial = v5
                v4 = v7[2].SendSerial
                v5 = {[1] = 2, [2] = v7[2].ClickSerial}
                v5[3] = v5
                v4 = {[1] = 2, [2] = v4}
                v4[3] = v4
                v8 = v11[2]
                v12 = v11[2].GetPivot(v8)
                v13 = v11[2].Name
                v12 = {[1] = 2, [2] = v12}
                v12[3] = v12
                v13 = {[1] = 2, [2] = v13}
                v13[3] = v13
                v10 = v7[2].LastSend
                v8 = v10
                v3 = v10 and v3 + -89 or 89
            elseif v3 >= 160 and v3 <= 161 then
                v4 = v1._.os.clock()
                v12 = v7[2].LastClickAt
                v4, v5 = 0.5, v4 - v12
                v3 = 109
                v11 = v5 < 0.5
            elseif v3 >= 150 and v3 <= 159 then
                v3 = v5 and 236 or 166
            elseif v3 >= 126 and v3 <= 149 then
                v9 = v12[2].Position
                v3 = 11
                v8 = (v10.Pos - v9).Magnitude < 0.1
            elseif v3 >= 109 and v3 <= 124 then
                v3 = v11 and 309 - v3 or v3 + 135
            else
                v3 = 218
                v8 = v1._.typeof(v10.Pos) == "Vector3"
            end
        until false
    end
end
local function _w78(v1)
    return function(v2)
        local lower, v3
        if v1._.type(v2) ~= "string" then
            return false
        else
            lower = v2:lower()
            if lower:match("error%s*code%s*:%s*%d+") then
                return true
            else
                v3 = lower:find("disconnect", 1, true) ~= nil or lower:find("reconnect", 1, true) ~= nil or lower:find("lost connection", 1, true) ~= nil or lower:find("connection lost", 1, true) ~= nil or lower:find("internet connection", 1, true) ~= nil
                if v3 then
                    return v3
                else
                    return lower:find("connection timed out", 1, true) ~= nil
                end
            end
        end
    end
end
local function _w79(v1, v2)
    return function()
        local v3 = 249
        local v4, v5, v6, v7, v8, tab, v9, tab2, v10, tab3, v11, createWindow, v12, loadWindUI, v13, v14, tab4
        while true do
            if v3 == 73 then
                v3, v8 = 4599 / v3, ""
            elseif v3 == 164 then
                v7.Value = v6 .. v4
                v7.Multi = false
                v7.Callback = v1:Rd({v2[3], v2[1]})
                v12:Dropdown(v7)
                v8 = v2[3][2]
                v5 = {}
                v9 = v8.Widgets
                v5.Title = "Map"
                v5.Values = v8.Maps()
                v5.Value = v2[1][2].Map
                v5.Multi = false
                v5.SearchBarEnabled = true
                v5.Callback = v1:Td({v2[3], v2[1]})
                v9.Maps = v12:Dropdown(v5)
                v8 = v2[3][2]
                v9 = v8.Widgets
                v5 = {Title = "Modifier"}
                v5.Values = v8.ModifierOptions()
                v5.Value = v8.ModifierLabels()
                v5.Multi = true
                v5.AllowNone = true
                v5.Callback = v1:Nd({v2[3], v2[1]})
                v9.Modifiers = v12:Dropdown(v5)
                v7 = {Title = "Method", Desc = "Movement used to reach the elevator."}
                v6 = {}
                v6[1], v6[2] = "Walk", "TP"
                v7.Values = v6
                v7.Value = v2[1][2].JoinMethod
                v7.Multi = false
                v7.Callback = v2[3][2].SetJoinMethod
                v12:Dropdown(v7)
                v7 = {Title = "Auto Join & Start", Value = v2[1][2].AutoLobby}
                v7.Callback = v1:Kd({v2[3], v2[1]})
                v12:Toggle(v7)
                v12:Section({Title = "Auto Summon"})
                v7 = {Title = "Amount"}
                v6 = {}
                v6[1], v6[2] = "x1", "x10"
                v7.Values = v6
                v13 = v2[1][2]
                v7.Value = "x" .. v13.SummonAmount
                v7.Multi = false
                v7.Callback = v1:Yd({v2[3], v2[1]})
                v12:Dropdown(v7)
                v7 = {Title = "Summon Delay", Step = 0.1}
                v7.Value = {Min = 0.1, Max = 10, Default = v13.SummonDelay}
                v7.Callback = v1:Pd({v2[3], v2[1]})
                v12:Slider(v7)
                v7 = {Title = "Auto Summon", Value = v13.AutoSummon}
                v7.Callback = v1:Cd({v2[3], v2[1]})
                v12:Toggle(v7)
                v11:Section({Title = "Pre-match Vote"})
                v7 = {Title = "Difficulty"}
                v6 = {}
                v6[1], v6[3], v6[4], v6[2] = "Easy", "Hard", "Insane", "Normal"
                v7.Values = v6
                v6 = v2[1][2]
                v7.Value = v6.Difficulty
                v7.Multi = false
                v7.Callback = v1:Dd({v2[3], v2[1]})
                v11:Dropdown(v7)
                v7 = {Title = "Auto Vote Difficulty", Value = v6.AutoDifficulty}
                v7.Callback = v1:fe({v2[3], v2[1]})
                v11:Toggle(v7)
                v11:Section({Title = "Wave"})
                v7 = {Title = "Auto Skip Waves", Value = v6.AutoSkip}
                v7.Callback = v1:ae({v2[3], v2[1]})
                v11:Toggle(v7)
                v7 = {
                    Title = "Stop Auto Skip At",
                    Desc = "Pause Auto Skip on the listed waves. Separate wave numbers with commas.",
                    Placeholder = "1, 4, 5, 6, 13, 15, 18",
                    Value = v6.StopAutoSkipAt,
                }
                v7.Callback = v1:Ed({v2[3], v2[1]})
                v11:Input(v7)
                v7 = {Title = "Auto Speed Scale", Value = v6.AutoSpeed}
                v7.Callback = v1:Od({v2[3], v2[1]})
                v11:Toggle(v7)
                v7 = {Title = "Speed Scale"}
                v6 = {}
                v6[3], v6[1], v6[2] = "2x", "1x", "1.5x"
                v7.Values = v6
                v4 = v2[1][2].SpeedScale
                v7.Value = v1._.tostring(v4) .. "x"
                v7.Multi = false
                v7.Callback = v1:Ld({v2[3], v2[1]})
                v11:Dropdown(v7)
                v11:Section({Title = "Match End"})
                v7 = {Title = "After Match"}
                v6 = {}
                v13 = "Replay"
                v4 = "None"
                v6[3], v6[2], v6[1] = "Return", "Replay", "None"
                v7.Values = v6
                v7.Value = v2[1][2].EndAction
                v7.Multi = false
                v7.Callback = v1:Xd({v2[3], v2[1]})
                v11:Dropdown(v7)
                tab:Section({Title = "Macro State"})
                v2[3][2].Widgets.Macro = tab:Paragraph({Title = "State: Idle", Desc = "Ready to record or play back a macro."})
                v5 = {}
                v9 = v2[3][2].Widgets
                v5.Title = "Live match"
                v5.Desc = "Waiting for match data."
                v9.MacroRuntime = tab:Paragraph(v5)
                v5 = {}
                v9 = v2[3][2].Widgets
                v5.Title = "Recorded actions: 0"
                v6 = "No macro actions loaded."
                v5.Desc = "No macro actions loaded."
                v7 = tab
                v9.MacroActions = tab:Paragraph(v5)
                v9 = v1._.tostring
                v8 = v2[1][2].NewProfileName
                v3 = v8 and 10332 / v3 or 237 - v3
            elseif v3 >= 132 and v3 <= 163 then
                v3 = 127
                v13 = v8[1]
            elseif v3 >= 165 and v3 <= 199 then
                v3 = 33
                v4 = " Player"
            elseif v3 >= 200 and v3 <= 230 then
                v3, v4 = 37720 / v3, " Players"
            elseif v3 >= 231 and v3 <= 247 then
                v3, v14 = 305 - v3, v2[1][2]
                v13 = v14.Profile
            elseif v3 >= 63 and v3 <= 72 then
                v9 = {[1] = 2, [2] = v9(v8)}
                v9[3] = v9
                v5 = {Title = "Create Macro", Placeholder = "Macro name", Value = v9[2]}
                v5.Callback = v1:he({v2[1], v9, v2[3]})
                tab:Input(v5)
                v5 = {Title = "Create New Macro", Icon = "file-plus"}
                v6 = v1:Id({v2[1], v2[3], v9})
                v5.Callback = v6
                tab:Button(v5)
                v7 = v2[3][2]
                v8 = v7.Profiles()
                v7 = v7.Widgets
                v4 = {Title = "Select Macro", Values = v8}
                v13 = v2[1][2].Profile ~= ""
                v3 = v13 and 247 or 58
            elseif v3 >= 74 and v3 <= 131 then
                v4.Value = v13
                v4.Multi = false
                v4.Callback = v1:Gd({v2[1], v2[3]})
                v7.Profiles = tab:Dropdown(v4)
                v6 = {Title = "Delete Selected Macro", Icon = "trash-2"}
                v6.Callback = v1:Ud({v2[1], v2[3]})
                tab:Button(v6)
                v6 = {Title = "Playback Mode"}
                v13 = {}
                v13[2], v13[3], v13[1] = "Time", "Money", "Hybrid"
                v6.Values = v13
                v6.Value = v2[1][2].PlaybackMode
                v6.Multi = false
                v6.Callback = v1:ce({v2[3], v2[1]})
                tab:Dropdown(v6)
                v4 = {}
                v7 = v2[3][2].Widgets
                v4.Title = "Record"
                v4.Value = false
                v4.Callback = v1:yd({v2[3]})
                v7.Record = tab:Toggle(v4)
                v7 = v2[3][2].Widgets
                v4 = {Title = "Auto Playback Every Match"}
                v14 = v2[1][2]
                v4.Value = v14.AutoPlayback
                v4.Callback = v1:Jd({v2[1], v2[3]})
                v7.Playback = tab:Toggle(v4)
                tab3:Section({Title = "Auto Play"})
                v4 = {}
                v7 = v2[3][2].Widgets
                v4.Title = "Auto Play State"
                v4.Desc = "Auto Play is disabled."
                v7.Auto = tab3:Paragraph(v4)
                v6 = {
                    Title = "Auto Place",
                    Desc = "Automatically place towers. Waits for macro completion when Auto Playback is enabled.",
                    Value = v14.AutoPlace,
                }
                v6.Callback = v1:Fd({v2[3], v2[1]})
                tab3:Toggle(v6)
                v6 = {
                    Title = "Auto Upgrade",
                    Desc = "Automatically upgrade towers. Waits for macro completion when Auto Playback is enabled.",
                    Value = v14.AutoUpgrade,
                }
                v6.Callback = v1:Qd({v2[3], v2[1]})
                tab3:Toggle(v6)
                v6 = {Title = "Auto Play Delay", Step = 0.1}
                v13 = {Min = 0.1, Max = 10}
                v10 = v2[1][2]
                v13.Default = v10.AutoDelay
                v6.Value = v13
                v6.Callback = v1:Vd({v2[3], v2[1]})
                tab3:Slider(v6)
                v6 = {
                    Title = "Placement Range",
                    Desc = "Position along the path: 0% at the entrance, 100% at the base.",
                    Step = 1,
                }
                v6.Value = {Min = 0, Max = 100, Default = v10.PlacementRange}
                v6.Callback = v1:zd({v2[3], v2[1]})
                tab3:Slider(v6)
                v6 = {Title = "Show Placement Range", Value = v10.ShowRange}
                v6.Callback = v1:Wd({v2[3], v2[1]})
                tab3:Toggle(v6)
                tab2:Section({Title = "Discord Webhook"})
                v6 = {
                    Title = "Webhook URL",
                    Placeholder = "https://discord.com/api/webhooks/...",
                    Value = v10.WebhookURL,
                }
                v6.Callback = v1:Ad({v2[3], v2[1]})
                tab2:Input(v6)
                v6 = {Title = "Enable Webhook", Value = v10.WebhookEnabled}
                v6.Callback = v1:de({v2[3], v2[1]})
                tab2:Toggle(v6)
                v6 = {Title = "Notify On Match End"}
                v13 = v10
                v6.Value = v10.WebhookMatchEnd
                v6.Callback = v1:_e({v2[3], v2[1]})
                tab2:Toggle(v6)
                v6 = {Title = "Send Test Webhook", Icon = "send"}
                v6.Callback = v1:Sd({v2[3]})
                tab2:Button(v6)
                tab4:Section({Title = "Automation"})
                v6 = {
                    Title = "Auto Execute",
                    Desc = "Automatically reload the hub after teleporting.",
                    Value = v13.AutoExecute,
                }
                v6.Callback = v1:Hd({v2[3], v2[1]})
                tab4:Toggle(v6)
                v6 = {
                    Title = "PlaceAnywhere",
                    Desc = "Enable additional tower placement locations where supported by the game.",
                    Value = v13.ClosePlacement,
                }
                v6.Callback = v1:ge({v2[3], v2[1]})
                tab4:Toggle(v6)
                v6 = {Title = "Auto Claim Quest", Value = v10.AutoClaimQuest}
                v6.Callback = v1:Md({v2[3], v2[1]})
                tab4:Toggle(v6)
                tab4:Section({Title = "Privacy"})
                v6 = {
                    Title = "Hide Name",
                    Desc = "Hide your name in character tags, tower details, and the player list.",
                }
                v6.Value = v10.HideName
                v6.Callback = v1:ee({v2[3]})
                tab4:Toggle(v6)
                tab4:Section({Title = "Performance"})
                v6 = {
                    Title = "FPS Boost",
                    Desc = "Reduce visual effects to improve performance.",
                    Value = v10.FPSBoost,
                }
                v6.Callback = v1:be({v2[3], v2[1]})
                tab4:Toggle(v6)
                tab4:Section({Title = "Anti-AFK"})
                v6 = {Title = "Anti-AFK", Value = v10.AntiAFK}
                v6.Callback = v1:Bd({v2[3], v2[1]})
                tab4:Toggle(v6)
                return
            elseif v3 <= 33 then
                v3 = v4 and 164 or 263 - v3
            elseif v3 >= 34 and v3 <= 62 then
                v3 = v13 and 185 - v3 or 132
            else
                v12 = v1._.os
                v2[2][2].WindUIStart = v12.clock()
                loadWindUI = v2[3][2].LoadWindUI()
                v2[2][2].WindUIReady = v12.clock()
                v2[3][2].UI = loadWindUI
                v11 = {
                    Title = "Camera TD Hub",
                    Author = "Kero",
                    Folder = "CameraTDHub",
                    Icon = "camera",
                    Theme = "Dark",
                }
                v11.Size = v1._.UDim2.fromOffset(620, 480)
                v11.Transparent = true
                v11.HideSearchBar = true
                v11.NewElements = true
                v11.ToggleKey = v1._.Enum.KeyCode.RightShift
                v11.OpenButton = {Title = "Camera TD Hub", Enabled = true, Draggable = true, OnlyMobile = false}
                createWindow = loadWindUI:CreateWindow(v11)
                v2[3][2].Window = createWindow
                v2[2][2].WindowCreated = v1._.os.clock()
                v12 = createWindow:Tab({Title = "Lobby", Icon = "door-open"})
                v11 = createWindow:Tab({Title = "Match", Icon = "map"})
                tab3 = createWindow:Tab({Title = "Auto Play", Icon = "play"})
                tab = createWindow:Tab({Title = "Macros", Icon = "clapperboard"})
                tab2 = createWindow:Tab({Title = "Webhook", Icon = "webhook"})
                tab4 = createWindow:Tab({Title = "Misc", Icon = "settings"})
                v9 = v12.Section
                v8 = v12
                v9(v12, {Title = "Play"})
                v7 = {Title = "Players", Desc = "Minimum number of players required to start the match."}
                v6 = {}
                v6[4], v6[2], v6[5], v6[1], v6[3] = "4 Players", "2 Players", "5 Players", "1 Player", "3 Players"
                v7.Values = v6
                v4 = v2[1][2].Players
                v6 = v1._.tostring(v4)
                v13 = v2[1][2].Players
                v4 = v13 == 1
                v3 = v4 and 199 or 33
            end
        end
    end
end
local function _w81(v1, v2)
    return function()
        local v3 = v2[1][2]
        v2[2][2][v2[3][2]] = v3
    end
end
local function _w82(v1, v2)
    return function()
        local v3 = 15
        local v4, v5, v6, v7, v8, v9, v10
        while true do
            if v3 == 15 then
                v3 = 54
            elseif v3 >= 121 and v3 <= 248 then
                v7 = v2[1][2].SpeedStep
                v8, v7 = v1._.pcall(v7)
                v3 = not v8 and 120 or v3 + 2
            elseif v3 >= 16 and v3 <= 54 then
                v7 = v2[1][2]
                v8 = v7.Running
                v3 = v8 and v3 + 194 or 63 - v3
            elseif v3 <= 14 then
                return
            elseif v3 >= 55 and v3 <= 120 then
                v3, v5 = 370 - v3, v2[1][2]
                v9, v6, v4, v10, v5 = "Speed update failed: ", v1._.tostring, v5.SetStatus, v7, "Speed"
                v4("Speed", "Speed update failed: " .. v6(v10))
            else
                v3 = 54
                v1._.task.wait(0.25)
            end
        end
    end
end
local function _w83(v1, v2)
    return function()
        local v3 = v2[3][2]
        local v4 = v3.Title
        local v5 = v3
        v3 = v3.Description
        local v6 = v5.Color
        local v7
        v7, v5 = "https://i.postimg.cc/1RYRdwrS/Bo-suu-tap.jpg", v5.Fields
        local v8
        v8, v4 = v2[2][2].SendWebhook(v4, v3, v6, v5, "https://i.postimg.cc/1RYRdwrS/Bo-suu-tap.jpg")
        v3 = v2[1][2]
        v3.Pending = false
        v3.Sent = v8
        v2[2][2].WebhookStatus(v8, v4)
    end
end
local function _w84(v1, v2)
    return function()
        local v3 = v2[1][2]
        local path = v2[2][2].Path(v3, "leaderstats/Money")
        v3 = path
        local v4, v5, v6
        if path then
            if path:IsA("ValueBase") then
                v5 = path.Value
                v3 = v1._.tonumber(v5)
                if v3 then
                    return v3
                else
                    return 0
                end
            else
                v3 = v2[2][2].GUI("Stats/OtherUI/Money/Title")
                if v3 then
                    v5 = v3.Text:gsub(",", "")
                    v4 = v5.match
                    v6 = v1._.tonumber
                    v4 = table.pack(v4(v5, "[%d%.]+"))
                    v6 = v6(table.unpack(v4, 1, v4.n))
                    if v6 then
                        return v6
                    else
                        return 0
                    end
                else
                    return 0
                end
            end
        elseif v3 then
            v5 = path.Value
            v3 = v1._.tonumber(v5)
            if v3 then
                return v3
            else
                return 0
            end
        else
            v3 = v2[2][2].GUI("Stats/OtherUI/Money/Title")
            if v3 then
                v5 = v3.Text:gsub(",", "")
                v4 = v5.match
                v6 = v1._.tonumber
                v4 = table.pack(v4(v5, "[%d%.]+"))
                v6 = v6(table.unpack(v4, 1, v4.n))
                if v6 then
                    return v6
                else
                    return 0
                end
            else
                return 0
            end
        end
    end
end
local function _w85(v1, v2)
    return function(v3)
        v2[2][2].AutoExecute = v3 == true
        v2[1][2].SaveSettings()
        if v2[2][2].AutoExecute then
            v2[1][2].QueueTeleport()
        end
    end
end
local function _w86(v1, v2, v3, v4, v5)
    v1.df[v5] = -(bit32.band(bit32.band(v2, v4), bit32.bor(v2, v4)) * bit32.band(v4, v2)) + (-bit32.bnot(bit32.band(v3, v3)) + (v2 + (bit32.bnot(v2) + -v3) + bit32.band(bit32.bnot(v4), v2) * bit32.band(bit32.bnot(v2), v4) + 2 * (bit32.band(bit32.bnot(v2), v3) * bit32.band(v2, bit32.bnot(v3))) + -(bit32.band(bit32.bnot(v2), v3) * bit32.band(bit32.band(v2, bit32.bnot(v3)), v4)) + -(bit32.band(bit32.bor(v2, v4), bit32.bnot(v3)) * bit32.band(v4, v2))) + bit32.band(v2, v4) * bit32.bor(v4, v2) * 3 + -(bit32.band(bit32.bnot(bit32.band(v4, v2)), bit32.bor(v2, v4)) * bit32.band(v2, v4)) + bit32.band(v2, v3) * bit32.bor(v2, v3)) + -(bit32.band(bit32.bnot(v2), v3) * bit32.band(bit32.band(bit32.bnot(v3), v2), bit32.bnot(v4))) + -(bit32.band(v2, v4) * bit32.band(bit32.bor(v4, v2), v3))
    return v1.df[v5]
end
local function _w87(v1, v2)
    return function(v3)
        local v4 = 171
        local v5, v6, v7, v8, v9, v10, v11
        repeat
            if v4 == 24 then
                v8 = v2[2][2]
                v8.NameConnections = {}
                v9 = v1._.setmetatable
                v6 = {}
                v5 = "k"
                v6.__mode = "k"
                v8.NameWatched = v9({}, v6)
                v8.RestoreHiddenName()
                v7 = v2[3][2]
                v9 = v7.HideName
                v8 = not v9
                v4 = v8 and 69 or 195
            elseif v4 == 69 then
                return
            elseif v4 >= 196 and v4 <= 235 then
                v11, v4, v10 = v2[2][2].HideOwnNameObject, v4 + -181, v5
                v11(v10)
            elseif v4 >= 175 and v4 <= 195 then
                v4 = v3[2] and v4 + -192 or 369 - v4
            elseif v4 >= 172 and v4 <= 174 then
                v8 = {[1] = 2, [2] = v8}
                v8[3] = v8
                v8[2] = v1:Ic({v2[3], v2[2]})
                v7 = v2[1][2]
                v9 = v8[2]
                v7, v6 = v7.FindFirstChild, v7
                v7 = v1.h(v7(v6, "PlayerGui"))
                v9(v1.i(v7))
                v7 = v1:Jc({v8})
                v1._.pcall(v7)
                return
            elseif v4 >= 150 and v4 <= 171 then
                v3 = {[1] = 2, [2] = v3}
                v3[3] = v3
                v9 = v2[2][2].NameConnections
                v8, v9, v7 = v1._.ipairs(v9)
                v8, v9, v7 = v1.g(v8, v9, v7)
                v6, v5 = v8(v9, v7)
                v7 = v6
                v4 = v6 == nil and 24 or 149
            elseif v4 <= 23 then
                v8 = v1._.ipairs
                v9 = v3[2].GetDescendants
                v7 = v3[2]
                v9 = v1.h(v9(v7))
                v8, v9, v7 = v8(v1.i(v9))
                v8, v9, v7 = v1.g(v8, v9, v7)
                v6, v5 = v8(v9, v7)
                v7 = v6
                v4 = v6 == nil and v4 + 25 or 235
            elseif v4 >= 25 and v4 <= 53 then
                v8 = v1._.table.insert
                v7 = v2[2][2]
                v5, v9, v4, v7 = v1:Hc({v2[1], v2[2], v3, v2[3]}), v7.NameConnections, 4872 / v4, v3[2].DescendantAdded
                v6, v7 = v7, v7.Connect
                v7 = table.pack(v7(v6, v5))
                v8(v9, table.unpack(v7, 1, v7.n))
            elseif v4 >= 54 and v4 <= 68 then
                v6, v5 = v8(v9, v7)
                v7 = v6
                v4 = v6 == nil and 1512 / v4 or v4 + 181
            elseif v4 >= 70 and v4 <= 149 then
                v4 = 239
                v5:Disconnect()
            else
                v6, v5 = v8(v9, v7)
                v7 = v6
                v4 = v6 == nil and v4 + -215 or 388 - v4
            end
        until false
    end
end
local function _w88(v1, v2, v3, v4)
    v1.pf[v4] = bit32.bor(bit32.band(v3, 65535), bit32.band(v2, 65535)) * bit32.band(bit32.band(v3, 65535), bit32.band(65535, v2)) + bit32.band(bit32.bnot(bit32.band(v3, 65535)), bit32.band(65535, v2)) * bit32.band(bit32.band(65535, v3), bit32.bnot(bit32.band(65535, v2))) - bit32.band(65535, v3) * bit32.band(65535, v2) + (-bit32.band(bit32.bnot(v2), v3) + (v2 + (v3 + (bit32.bor(0, bit32.bor(v3, v3)) + -bit32.bor(bit32.bnot(v3), bit32.band(v2, 4294967295))) + bit32.bnot(bit32.band(v3, v3)))))
    return v1.pf[v4]
end
local function _w89(v1, v2, v3)
    v1.pf[v3] = v2
    return v1.pf[v3]
end
local function _w90(v1, v2)
    return function()
        local v3 = v1._.tostring
        local v4 = v2[2][2].LoggerURL
        if v4 then
            v3 = v3(v4)
        else
            v3 = v3("")
        end
        local v5
        v4, v5, v3 = v3, "^%s*(.-)%s*$", v3.match
        v3 = {[1] = 2, [2] = v3(v4, "^%s*(.-)%s*$")}
        v3[3] = v3
        local v6 = v2[2][2]
        v6, v5 = v3[2], v6.ValidWebhook
        v5 = v5(v6)
        local v7, v8
        if v5 then
            v4 = v2[3][2]
            v5 = v4.__CameraTDLoggerSessions
            if v5 then
                v4.__CameraTDLoggerSessions = v5
            else
                v4.__CameraTDLoggerSessions = {}
            end
            v6 = v1._.game.JobId
            v5 = v1._.tostring(v6)
            v7 = "/" .. v3[2]
            v4 = v5 .. "/" .. v2[1][2].UserId .. v7
            v5 = {[1] = 2, [2] = v2[3][2].__CameraTDLoggerSessions[v4]}
            v5[3] = v5
            if v5[2] then
                v6 = v5[2].Sent or v5[2].Pending
                if v6 then
                    if not v6 then
                        v6 = {Pending = true}
                        v6.NextAt = v1._.os.clock() + 60
                        v5[2], v8 = v6, v2[3][2]
                        v8.__CameraTDLoggerSessions[v4] = v5[2]
                        v8 = v1._.task
                        v8, v6 = v1:nd({v3, v2[1], v5, v2[2]}), v8.spawn
                        v6(v8)
                        return
                    end
                elseif v1._.os.clock() < v5[2].NextAt then
                    return
                else
                    v6 = {Pending = true}
                    v6.NextAt = v1._.os.clock() + 60
                    v5[2], v8 = v6, v2[3][2]
                    v8.__CameraTDLoggerSessions[v4] = v5[2]
                    v8 = v1._.task
                    v8, v6 = v1:nd({v3, v2[1], v5, v2[2]}), v8.spawn
                    v6(v8)
                    return
                end
            else
                v6 = {Pending = true}
                v6.NextAt = v1._.os.clock() + 60
                v5[2], v8 = v6, v2[3][2]
                v8.__CameraTDLoggerSessions[v4] = v5[2]
                v8 = v1._.task
                v8, v6 = v1:nd({v3, v2[1], v5, v2[2]}), v8.spawn
                v6(v8)
                return
            end
        end
    end
end
local function _w91(v1, v2)
    return function()
        local v3 = v2[1][2]
        v3.Teleporting = true
        v3.QueueTeleport()
    end
end
local function _w92(v1, v2)
    return function()
        local v3 = v2[2][2]
        local v4 = v1._.tonumber
        v3 = table.pack(v3())
        v4 = v4(table.unpack(v3, 1, v3.n))
        local v5, v6, v7
        if v4 then
            v3 = v2[3][2].Cash()
            if v3 >= v4 then
                return true
            else
                v5 = v2[3][2].SetStatus
                v7 = v1._.string.format
                v6 = v2[1][2]
                v7 = table.pack(v7("%s | waiting for money: %s / %s", v6, v3, v4))
                v5("Macro", table.unpack(v7, 1, v7.n))
                return false
            end
        else
            v3 = v2[3][2].Cash()
            if v3 >= 0 then
                return true
            else
                v5 = v2[3][2].SetStatus
                v7 = v1._.string.format
                v6 = v2[1][2]
                v7 = table.pack(v7("%s | waiting for money: %s / %s", v6, v3, 0))
                v5("Macro", table.unpack(v7, 1, v7.n))
                return false
            end
        end
    end
end
local function _w93(v1, v2)
    return function(v3)
        local v4 = v1._.math
        local v5 = v2[2][2]
        local v6, v7
        v4, v6, v7 = v1._.tonumber, v4.clamp, v3
        v4 = v4(v7)
        if v4 then
            v5.AutoDelay = v6(v4, 0.1, 10)
        else
            v5.AutoDelay = v6(0.1, 0.1, 10)
        end
        v2[1][2].SaveSettings()
    end
end
local function _w94(v1)
    return function(v2)
        local v3 = 117
        local v4, v5
        while true do
            if v3 == 93 then
                v3, v4 = 266 - v3, v2.Enabled
                v5 = not v4
            elseif v3 == 165 then
                v5 = v2:IsA("ScreenGui")
                v3 = v5 and 15345 / v3 or 173
            elseif v3 == 202 then
                return false
            elseif v3 == 218 then
                v5 = v2:IsA("GuiObject")
                v3 = v5 and 211 or 451 - v3
            elseif v3 == 245 then
                v3 = v2 and v3 + -27 or 422 - v3
            elseif v3 >= 174 and v3 <= 201 then
                return true
            elseif v3 >= 166 and v3 <= 173 then
                v3 = v5 and 41 or 411 - v3
            elseif v3 >= 94 and v3 <= 164 then
                v5 = not v2
                v3 = v5 and 248 or 245
            elseif v3 <= 92 then
                return false
            elseif v3 >= 234 and v3 <= 244 then
                v3, v2 = 245, v2.Parent
            elseif v3 >= 203 and v3 <= 217 then
                v3 = 233
                v5 = not v2.Visible
            elseif v3 >= 219 and v3 <= 233 then
                v3 = v5 and 202 or 38445 / v3
            else
                return false
            end
        end
    end
end
local function _w95(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5
        if v3 == "Walk" then
            v4.JoinMethod = "Walk"
        else
            v4.JoinMethod = "TP"
        end
        v5 = v2[1][2]
        v5.CancelJoinWalk()
        v5.JoinWalkExit = nil
        v5.LobbyAttempt = nil
        v5.SaveSettings()
    end
end
local function _w97(v1, v2)
    return function(v3, v4, ...)
        if v2[2][2].Active then
            v2[1][2](v3, v4, ...)
        end
    end
end
local function _w98(v1, v2)
    return function()
        v2[2][2]:Set(v2[1][2])
    end
end
local function _w99(v1, v2)
    return function(v3)
        local v4 = 0
        local v5 = 1
        while true do
            v4 = v4 * 85 + ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~"):find(v3:sub(v5, v5), 1, true) - 1
            v5 = v5 + 1
            if v5 > 5 then
                break
            end
        end
        v5 = v2[2][2]
        local v6 = v2[3][2](v4, 24)
        local v7 = v2[1][2](v2[3][2](v4, 16), 255)
        local v8 = v2[1][2](v2[3][2](v4, 8), 255)
        local v9 = v2[1][2]
        local pack = table.pack(v9(v4, 255))
        v5 = table.pack(v5(v6, v7, v8, table.unpack(pack, 1, pack.n)))
        return table.unpack(v5, 1, v5.n)
    end
end
local function _w100(v1, v2)
    return function(v3)
        local isA = v3:IsA("ParticleEmitter") or v3:IsA("Trail") or v3:IsA("Beam") or v3:IsA("Smoke") or v3:IsA("Fire") or v3:IsA("Sparkles")
        local v4
        if isA then
            if isA then
                v2[1][2].FPSSet(v3, "Enabled", false)
                return
            elseif v3:IsA("BasePart") then
                v2[1][2].FPSSet(v3, "CastShadow", false)
                v4 = v1._.Enum
                v2[1][2].FPSSet(v3, "Material", v4.Material.SmoothPlastic)
                return
            else
                isA = v3:IsA("Decal")
                if isA then
                    if isA then
                        v2[1][2].FPSSet(v3, "Transparency", 1)
                    end
                    return
                elseif v3:IsA("Texture") then
                    v2[1][2].FPSSet(v3, "Transparency", 1)
                    return
                else
                    return
                end
            end
        elseif v3:IsA("PostEffect") then
            v2[1][2].FPSSet(v3, "Enabled", false)
            return
        elseif v3:IsA("BasePart") then
            v2[1][2].FPSSet(v3, "CastShadow", false)
            v4 = v1._.Enum
            v2[1][2].FPSSet(v3, "Material", v4.Material.SmoothPlastic)
            return
        else
            isA = v3:IsA("Decal")
            if isA then
                if isA then
                    v2[1][2].FPSSet(v3, "Transparency", 1)
                end
                return
            elseif v3:IsA("Texture") then
                v2[1][2].FPSSet(v3, "Transparency", 1)
                return
            else
                return
            end
        end
    end
end
local function _w101(v1, v2)
    return function(v3)
        local v4 = v1._.tostring
        local v5 = v3
        if v3 then
            v4 = v4(v5)
        else
            v4 = v4("")
        end
        v4 = v4:match("^%s*(.-)%s*$")
        v5 = v4 == v2[1][2].Name
        local v6
        if v5 then
            if v5 then
                return v5
            else
                return v4 == "@" .. v2[1][2].Name
            end
        else
            v6 = v2[1][2].DisplayName
            if v1._.type(v6) == "string" then
                if v2[1][2].DisplayName ~= "" then
                    v5 = v4 == v2[1][2].DisplayName
                    if v5 then
                        return v5
                    else
                        return v4 == "@" .. v2[1][2].Name
                    end
                else
                    return v4 == "@" .. v2[1][2].Name
                end
            else
                return v4 == "@" .. v2[1][2].Name
            end
        end
    end
end
local function _w102(v1, v2)
    return function()
        local v3 = v2[1][2]
        v3.Elevator = nil
        v3.IsHost = false
        v3.StartRequested = nil
        v3.LobbyAttempt = nil
    end
end
local function _w103(v1, v2)
    return function()
        local v3 = v2[2][2]
        local v4 = v2[3][2].Profiles
        v4 = table.pack(v4())
        v3:Refresh(table.unpack(v4, 1, v4.n))
        if v2[1][2].Profile ~= "" then
            while true do
                v4 = v2[1][2]
                v2[2][2]:Select(v4.Profile)
            end
        else
            return
        end
    end
end
local function _w104(v1, v2)
    return function()
        local v3
        local getDescendants = v2[2][2]:GetDescendants()
        local v4, v5, v6
        v4, v6, v5 = v1._.ipairs(getDescendants)
        v4, v6, v5 = v1.g(v4, v6, v5)
        local v7, v8
        v8, v7 = v4(v6, v5)
        v5 = v8
        if v8 ~= nil then
            goto __L91006
        end
        ::__L91002::
        v6 = v2[3][2]
        v4 = v1._.ipairs
        v5, v6 = v6, v6.GetDescendants
        v6 = v1.h(v6(v5))
        v4, v6, v5 = v4(v1.i(v6))
        v4, v6, v5 = v1.g(v4, v6, v5)
        v8, v7 = v4(v6, v5)
        v5 = v8
        while true do
            v3(v7)
            v8, v7 = v4(v6, v5)
            v5 = v8
        end
        ::__L91006::
        while true do
            local shouldExit = false
            while true do
                v2[4][2].FPSObject(v7)
                v3 = v8 % 250
                if v3 ~= 0 then
                    v8, v7 = v4(v6, v5)
                    v5 = v8
                    if v8 == nil then
                        goto __L91002
                    else
                        shouldExit = true
                        break
                    end
                end
                v3 = v1._.task.wait
                v3()
                v8, v7 = v4(v6, v5)
                v5 = v8
                if v8 == nil then
                    goto __L91002
                else
                    shouldExit = true
                    break
                end
            end
            if not shouldExit then
                break
            end
        end
    end
end
local function le(v1, v2, v3, v4, v9, ...)
    local v5 = #v2
    local v6 = v1
    local v7 = 0
    local v8 = v5 - 1
    if 0 <= v8 then
        while true do
            v6[v2[(100151 * v7 + 15443) % v5 + 1]] = v6[v7 + 1]
            v7 = v7 + 1
            if v7 > v8 then
                break
            end
        end
    end
    v7 = v1[v3]
    v7 = table.pack(v7(v1, v4, v9, ...))
    return table.unpack(v7, 1, v7.n)
end
local function _w106(v1, v2)
    return function(v3, v4, v5, v6)
        local v7 = v3 ~= v2[2][2] or v6 ~= 132929771812494
        local v8, v9, v10, v11
        if v7 then
            if not v7 then
                v7 = v2[1][2]
                v7.InFlight = nil
                v9, v8, v7, v11, v10 = "teleport_init_failed", {}, v7.Log, v4, v1._.tostring
                v8.result = v10(v11)
                v8.message = v1._.tostring(v5)
                v8.attempt = v2[1][2].Attempts
                v7("teleport_init_failed", v8)
                return
            end
        elseif v2[1][2].Attempts == 0 then
            return
        else
            v7 = v2[1][2]
            v7.InFlight = nil
            v9, v8, v7, v11, v10 = "teleport_init_failed", {}, v7.Log, v4, v1._.tostring
            v8.result = v10(v11)
            v8.message = v1._.tostring(v5)
            v8.attempt = v2[1][2].Attempts
            v7("teleport_init_failed", v8)
            return
        end
    end
end
local function _w107(v1, v2)
    return function(v3, v4, v7, ...)
        local remote = v2[1][2].Remote(v3, "RemoteFunction")
        local v5 = not remote
        local v6
        if v5 then
            if v5 then
                return false, "Missing remote " .. v3
            else
                v6 = remote.InvokeServer
                v5 = v1._.pcall
                v5 = table.pack(v5(v6, remote, v4, v7, ...))
                return table.unpack(v5, 1, v5.n)
            end
        elseif not remote:IsA("RemoteFunction") then
            return false, "Missing remote " .. v3
        else
            v6 = remote.InvokeServer
            v5 = v1._.pcall
            v5 = table.pack(v5(v6, remote, v4, v7, ...))
            return table.unpack(v5, 1, v5.n)
        end
    end
end
local function _w108(v1, v2)
    return function()
        local v3 = 180
        local v4, v5, v6, v7, v8, v9, v10
        while true do
            if v3 == 111 then
                v7 = v2[2][2]
                v4 = v7.Running
                v3 = v4 and 107 or 240
            elseif v3 == 180 then
                v3 = 111
            elseif v3 >= 181 and v3 <= 192 then
                v3 = 111
                v1._.task.wait(0.3)
            elseif v3 <= 110 then
                v4, v7 = v1._.pcall(v1:Sb({v2[1], v2[2]}))
                v3 = not v4 and 270 - v3 or 299 - v3
            elseif v3 >= 112 and v3 <= 179 then
                v6 = v2[2][2]
                v8, v6, v10, v9, v3, v5 = v7, "Match", v1._.tostring, "State update error: ", 192, v6.SetStatus
                v5("Match", "State update error: " .. v10(v8))
            else
                return
            end
        end
    end
end
local function _w109(v1, v2)
    return function(v3)
        local v4
        if v1._.type(v1._.writefile) == "function" then
            v4 = v1._.writefile
            v1._.pcall(v4, v2[1][2], "-- CameraWindUICache " .. v1._.os.time() .. "\n" .. v3)
        end
    end
end
local function _w110(v1, v2, v3)
    v1.Fe[v3] = v2
    return v1.Fe[v3]
end
local function _w111(v1, v2)
    return function(v3)
        local v4 = v1._.type(v3) == "table"
        local v5
        if v4 then
            v5 = v3.OwnerUserId
            return v1._.tonumber(v5) == v2[1][2].UserId
        else
            return v4
        end
    end
end
(function()
    local function v1(v2, v3, v4)
        if v3 > v4 then
            return
        end
        return v2[v3], v1(v2, v3 + 1, v4)
    end
    return function(v2)
        return v1(v2[1], 1, v2[2])
    end
end)()
local function _w113(v1, v2)
    return function(v3, v4, v5, v6)
        v3 = {[1] = 2, [2] = v3}
        v3[3] = v3
        v6 = {[1] = 2, [2] = v6}
        v6[3] = v6
        local v7 = v2[1][2].WaitUntil
        local v8 = v1:ud({v6, v3, v2[1]})
        local pack = table.pack(v7(v8, v4, v5))
        return table.unpack(pack, 1, pack.n)
    end
end
local function _w114(v1, v2)
    return function()
        local v3 = 218
        local v4, v5, v6, v7, clock, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18
        while true do
            if v3 == 46 then
                v3, v10 = v3 + 7, v17.Level
                v5 = v18 > v10
            elseif v3 == 73 then
                v10 = v14.UnitId
                v3 = 205
                v18 = v10 == v13
            elseif v3 == 115 then
                v5 = v2[1][2]
                v18, v5, v14 = v17.Before, v17.Action, v5.FindPlacement
                v14, v5 = v14(v5, v18)
                v18 = v14
                v3 = v14 and 73 or 205
            elseif v3 == 118 then
                v13, v17 = v4(v7, v15)
                v15 = v13
                v3 = v13 == nil and v3 + -1 or 183
            elseif v3 == 176 then
                v9.UpgradePending[v13] = nil
                v6 = v2[1][2]
                v5 = v9.TowerCooldowns
                v10 = v6.AutoInterval()
                v5[v13] = clock + v10
                v18 = nil
                v5 = v9.Failures
                v5[v13] = nil
                v3 = v14 and 178 or 118
            elseif v3 == 204 then
                v4, v7, v15 = v1._.pairs(v9.UpgradePending)
                v4, v7, v15 = v1.g(v4, v7, v15)
                v13, v17 = v4(v7, v15)
                v15 = v13
                v3 = v13 == nil and 117 or 37332 / v3
            elseif v3 == 218 then
                v9 = v2[1][2].Auto
                clock = v1._.os.clock()
                v7 = v9.PlacePending
                v4, v7, v15 = v1._.pairs(v7)
                v4, v7, v15 = v1.g(v4, v7, v15)
                v13, v17 = v4(v7, v15)
                v15 = v13
                v3 = v13 == nil and 204 or 115
            elseif v3 == 232 then
                v3 = 96
                v10 = clock - v17.At
                v6 = 10
                v18 = v10 >= 10
            elseif v3 >= 179 and v3 <= 183 then
                v18 = v2[1][2]
                v14 = v18.Towers[v13]
                v5 = not v14
                v3 = v5 and 9699 / v3 or 228
            elseif v3 >= 157 and v3 <= 175 then
                v3, v11, v6 = 194 - v3, v17.Action, "Placement unconfirmed: "
                v11, v8 = " | this unit is locked pending late confirmation", v11.Name
                v6 = "Placement unconfirmed: " .. v8 .. " | this unit is locked pending late confirmation"
            elseif v3 >= 177 and v3 <= 178 then
                v3 = 118
                v18 = v2[1][2]
                v12, v16, v11, v5, v18, v10 = v14.Level, v14.Name, " | level ", v18.SetStatus, "Auto", "Upgraded "
                v6 = v16 .. " | level " .. v12
                v10 = "Upgraded " .. v6
                v5("Auto", v10)
            elseif v3 >= 184 and v3 <= 185 then
                v17.Warned = true
                v10 = "Auto"
                v18 = v2[1][2].SetStatus
                v6 = v5
                v3 = v6 and 37 or 157
            elseif v3 >= 186 and v3 <= 203 then
                v3 = 46
                v18 = 1
            elseif v3 >= 221 and v3 <= 231 then
                v10 = v14.Level
                v18 = v1._.tonumber(v10)
                v3 = v18 and v3 + -182 or 193
            elseif v3 >= 205 and v3 <= 217 then
                v3 = v18 and 220 or v3 + -157
            elseif v3 >= 219 and v3 <= 220 then
                v9.PlacePending[v13] = nil
                v16 = v2[1][2]
                v3, v9.SlotCooldowns[v13] = 133, clock + v16.AutoInterval()
                v18 = v16.SetStatus
                v10 = "Auto"
                v6 = "Placed " .. v14.Name .. " | confirmed"
                v18("Auto", v6)
            elseif v3 >= 54 and v3 <= 72 then
                v3 = v18 and 10730 / v3 or v3 + 75
            elseif v3 >= 49 and v3 <= 53 then
                v3 = v5 and 176 or 102
            elseif v3 >= 47 and v3 <= 48 then
                v18 = v5
                v3 = v5 and 96 or 11136 / v3
            elseif v3 >= 25 and v3 <= 45 then
                v3 = 133
                v18(v10, v6)
            elseif v3 <= 24 then
                v3, v10 = v3 + 34, v17.Warned
                v18 = not v10
            elseif v3 >= 119 and v3 <= 156 then
                v13, v17 = v4(v7, v15)
                v15 = v13
                v3 = v13 == nil and v3 + 71 or 15295 / v3
            elseif v3 >= 116 and v3 <= 117 then
                return
            elseif v3 >= 74 and v3 <= 96 then
                v3 = v18 and 24 or 58
            elseif v3 >= 97 and v3 <= 114 then
                v5 = clock - v17.At
                v18 = 10
                v3 = v5 >= 10 and 25194 / v3 or v3 + 16
            else
                v9.UpgradePending[v13] = nil
                v9.TowerCooldowns[v13] = clock + 15
                v5 = v9.Failures
                v16 = v2[1][2]
                v10 = {}
                v10.Wave = v16.Wave()
                v3, v10.Cash = 365 - v3, v16.Cash()
                v10.Level = v14.Level
                v5[v13] = v10
                v16, v18, v5, v10, v8 = v14.Name, "Auto", v16.SetStatus, "Upgrade unconfirmed: ", " | paused until wave/cash/level changes"
                v6 = v16 .. " | paused until wave/cash/level changes"
                v10 = "Upgrade unconfirmed: " .. v6
                v5("Auto", v10)
            end
        end
    end
end
local function _w115(v1, v2)
    return function(v3)
        local v4 = 226
        local v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
        repeat
            if v4 == 21 then
                v7 = v1._.getcallingscript
                v4 = 135
                v12 = v1._.type(v7)
                v7 = "function"
                v10 = v12 ~= "function"
            elseif v4 == 35 then
                v12 = v2[2][2]
                v10[2].Hub = v12
                v7 = v5.InputBound
                v12 = not v7
                v4 = v12 and 231 or 5740 / v4
            elseif v4 == 41 then
                v9, v11 = v9(v11, v14, v13, v8)
                v14 = not v9
                v4 = v14 and v4 + 210 or 8446 / v4
            elseif v4 == 76 then
                v4 = v10 and 135 or 1596 / v4
            elseif v4 == 133 then
                v4 = v8 and 174 - v4 or v4 + 120
            elseif v4 == 152 then
                v4 = 7
                v12 = v5.UI
                v10 = not v12
            elseif v4 == 202 then
                v12 = v1._.type(v1._.hookmetamethod)
                v7 = "function"
                v10 = v12 ~= "function"
                v4 = v10 and 15352 / v4 or 250
            elseif v4 == 214 then
                v4 = v10 and 227 - v4 or 202
            elseif v4 == 240 then
                v2[2][2].InstallRecorderHook()
                v10 = {[1] = 2, [2] = v2[4][2].__CameraTDHubPlacementRouter}
                v10[3] = v10
                v12 = not v10[2]
                v4 = v12 and 48 or 35
            elseif v4 == 251 then
                v2[4][2].__CameraTDHubPlacementRouter = nil
                v2[2][2].Notify("Close + Path hook unavailable")
                return
            elseif v4 >= 11 and v4 <= 20 then
                return
            elseif v4 >= 5 and v4 <= 7 then
                v4 = v10 and 47 - v4 or 1680 / v4
            elseif v4 <= 4 then
                v4, v7 = v4 + 25, v2[4][2]
                v12 = v7.CameraTDCloseTest
                v10 = v12.Stop
            elseif v4 >= 8 and v4 <= 10 then
                v7 = v2[4][2]
                v10 = v1._.pcall
                v4 = 89
                v12 = v7.CameraTDCloseTest.Stop
                v10(v12)
            elseif v4 >= 36 and v4 <= 40 then
                v2[2][2].Notify("Close + Path: game placement UI unavailable")
                return
            elseif v4 >= 22 and v4 <= 34 then
                v4 = v10 and 10 or v4 + 60
            elseif v4 >= 101 and v4 <= 132 then
                v12 = v2[4][2]
                v10 = v12.CameraTDCloseTest
                v4 = v10 and 4 or 29
            elseif v4 >= 90 and v4 <= 100 then
                v4 = 133
                v8 = v1._.newcclosure(v7)
            elseif v4 >= 42 and v4 <= 75 then
                v12, v10[2] = v2[4][2], {}
                v12.__CameraTDHubPlacementRouter = v10[2]
                v12 = {[1] = 2, [2] = nil}
                v12[3] = v12
                v8 = v1._.type
                v9 = v1._.pcall
                v14 = v1._.game
                v6 = v1._.newcclosure
                v13 = "__namecall"
                v11 = v1._.hookmetamethod
                v7 = v1:Nc({v12, v10, v2[3]})
                v8 = v8(v6) == "function"
                v4 = v8 and 100 or 133
            elseif v4 >= 77 and v4 <= 89 then
                v12 = v2[2][2]
                v12.Hydrate()
                v12.CloseRefresh()
                v10, v12 = v12.Remote, "TowerAdd"
                v10 = v10("TowerAdd")
                v9 = "ModuleLoader/Client/UI"
                v7 = v2[1][2]
                v12 = v2[2][2].Path(v7, "ModuleLoader/Client/UI")
                v5.Add = v10
                v5.UI = v12
                v12 = v5.Add
                v10 = not v12
                v4 = v10 and v4 + -82 or 152
            elseif v4 >= 229 and v4 <= 239 then
                v5.InputBound = true
                v12 = v2[2][2].Connect
                v14 = "UserInputService"
                v9 = v1._.game:GetService("UserInputService")
                v9, v7 = v1:Mc({v2[2]}), v9.InputBegan
                v4 = 37884 / v4
                v12(v7, v9)
            elseif v4 >= 227 and v4 <= 228 then
                v12 = v1._.game.PlaceId
                v4 = 214
                v9 = v2[2][2]
                v7 = v9.MatchId
                v10 = v12 ~= v7
            elseif v4 >= 215 and v4 <= 226 then
                v5 = v2[2][2].Close
                v5.Enabled = false
                v7 = 1
                v12 = v5.ClickSerial
                v5.ClickSerial = v12 + 1
                v10 = not v3
                v4 = v10 and 214 or 228
            elseif v4 >= 241 and v4 <= 250 then
                v12 = v1._.type(v1._.getnamecallmethod)
                v7 = "function"
                v4, v10 = 326 - v4, v12 ~= "function"
            elseif v4 >= 134 and v4 <= 151 then
                v4 = v10 and 191 or 17145 / v4
            elseif v4 >= 153 and v4 <= 164 then
                v5.Enabled = true
                return
            elseif v4 >= 203 and v4 <= 213 then
                v4, v12[2] = 7210 / v4, v11
            elseif v4 >= 165 and v4 <= 201 then
                v2[2][2].Notify("Close + Path requires executor hook and caller support")
                return
            else
                v4 = 41
                v8 = v7
            end
        until false
    end
end
local function _w116(v1, v2)
    return function(v3)
        local v4 = v2[1][2].ModifierSelection
        v2[2][2].Modifiers = v4(v3)
        local v5 = v2[1][2]
        v5.ModifierAppliedKey = nil
        v4, v5 = nil, v5.Next
        v5.Modifiers = nil
        v2[1][2].SaveSettings()
    end
end
local function _w117(v1, v2)
    return function(v3)
        local v4, v5, v6, v7, v8
        if v1._.typeof(v3.Pos) == "Vector3" then
            return v3.Pos
        else
            v4 = v3.CFrame
            if v1._.typeof(v4) == "CFrame" then
                return v3.CFrame.Position
            else
                v4 = v2[2][2]
                v4, v8, v6, v5, v7 = v2[1][2], "Game/Towers/", v1._.tostring, v3.Id, v4.Path
                v7 = v7(v4, "Game/Towers/" .. v6(v5))
                v4 = v7
                if v7 then
                    if v7:IsA("Model") then
                        v4 = v7:GetPivot().Position
                        if v4 then
                            return v4
                        else
                            return nil
                        end
                    else
                        return nil
                    end
                elseif v4 then
                    v4 = v7:GetPivot().Position
                    if v4 then
                        return v4
                    else
                        return nil
                    end
                else
                    return nil
                end
            end
        end
    end
end
local function _w118(v1, v2)
    return function()
        local v3 = v2[2][2]
        local v4, v5, v6, v7
        v4, v6, v3, v7, v5 = v2[5][2], v2[1][2], v2[4][2], v2[3][2], v3.ActionReady
        v5 = table.pack(v5(v3, v6, v7, v4))
        return table.unpack(v5, 1, v5.n)
    end
end
local function _w119(v1, v2, v3)
    v1.Ue[v3] = v2
    return v1.Ue[v3]
end
local function _w120(v1, v2)
    return function()
        local createPath = v1._.game:GetService("PathfindingService"):CreatePath({AgentRadius = 2, AgentHeight = 5, AgentCanJump = true})
        local v3 = v2[2][2]
        local v4, v5, v6
        v5, v4, v6, v3 = createPath.ComputeAsync, v3.Position, createPath, v2[1][2]
        v5(v6, v4, v3)
        v6 = v1._.Enum.PathStatus.Success
        if createPath.Status == v6 then
            v5 = createPath.GetWaypoints
            v5 = table.pack(v5(createPath))
            return table.unpack(v5, 1, v5.n)
        else
            return
        end
    end
end
local function _w121(v1, v2)
    return function(v3, v4)
        v4 = {[1] = 2, [2] = v4}
        v4[3] = v4
        local v5 = {[1] = 2, [2] = v2[1][2].Remote(v3)}
        v5[3] = v5
        local v6 = not v5[2]
        local v7, v8
        if v6 then
            if v6 then
                return false, "Missing remote " .. v3
            else
                v8 = v1:jc({v5, v4})
                v6 = v1._.pcall
                v6 = table.pack(v6(v8))
                return table.unpack(v6, 1, v6.n)
            end
        else
            v7 = v5[2]
            if not v5[2].IsA(v7, "RemoteEvent") then
                return false, "Missing remote " .. v3
            else
                v8 = v1:jc({v5, v4})
                v6 = v1._.pcall
                v6 = table.pack(v6(v8))
                return table.unpack(v6, 1, v6.n)
            end
        end
    end
end
local function _w122(v1, v2)
    return function(v3)
        v2[2][2].AutoSpeed = v3 == true
        local v4 = v2[1][2]
        local v5 = v4.Speed
        local v6, v7
        v6, v7, v4 = nil, nil, v4.Speed
        v5.Applied = nil
        v4.Rejected = nil
        v2[1][2].Next.Speed = nil
        v2[1][2].SaveSettings()
    end
end
local function _w123(v1, v2, v3, v4)
    v1.Bf[v4] = bit32.band(bit32.band(v3, 65535), bit32.band(65535, v3)) * bit32.bor(bit32.band(65535, v3), bit32.band(65535, v3)) + bit32.band(bit32.bnot(bit32.band(v3, 65535)), bit32.band(v3, 65535)) * bit32.band(bit32.band(v3, 65535), bit32.bnot(bit32.band(65535, v3))) - bit32.band(65535, v3) * bit32.band(65535, v3) + (-bit32.bxor(bit32.bxor(v3, v2), bit32.bor(v2, v3)) + bit32.bor(bit32.band(v3, v2), bit32.bxor(4294967295, v2)) + -bit32.band(bit32.bor(v2, 4294967295), bit32.bnot(v3)) + v2 * 2)
    return v1.Bf[v4]
end
local function _w124(v1, v2)
    return function()
        local v3 = v2[3][2]
        local upgradeCost = v2[2][2].UpgradeCost(v3) or v2[1][2].Cost
        if upgradeCost then
            return upgradeCost
        else
            return 0
        end
    end
end
local function _w125(v1, v2)
    return function(v3)
        local v4 = not v2[2][2].Running
        local v5, v6, v7, v8, v9
        if v4 then
            if v4 then
                return
            elseif v3:IsA("Humanoid") then
                if not v2[2][2].HiddenNameOriginal[v3] then
                    v7 = {}
                    v4 = v2[2][2].HiddenNameOriginal
                    v7.DisplayName = v3.DisplayName
                    v7.NameDisplayDistance = v3.NameDisplayDistance
                    v4[v3] = v7
                end
                v3.NameDisplayDistance = 0
                v3.DisplayName = ""
                return
            else
                if v3:IsA("TextLabel") or v3:IsA("TextButton") then
                    if v3:FindFirstAncestorWhichIsA("BillboardGui") then
                        v4 = v3.Text
                        v6 = v2[1][2]
                        v5, v8, v6, v9, v7 = v4.find, true, 1, v6.Name, v4
                        v5 = v5(v7, v9, 1, true)
                        if v5 then
                            if v5 then
                                if not v2[2][2].HiddenNameOriginal[v3] then
                                    v5 = v2[2][2].HiddenNameOriginal
                                    v9 = {Visible = v3.Visible}
                                    v9.TextTransparency = v3.TextTransparency
                                    v9.TextStrokeTransparency = v3.TextStrokeTransparency
                                    v5[v3] = v9
                                end
                                v3.Visible = false
                                v3.TextTransparency, v7 = 1, 1
                                v3.TextStrokeTransparency = 1
                            end
                        elseif v2[1][2].DisplayName ~= "" then
                            v6 = v2[1][2]
                            v5, v9, v8, v7, v6 = v4.find, v6.DisplayName, true, v4, 1
                            v5 = v5(v7, v9, 1, true)
                            if v5 then
                                if not v2[2][2].HiddenNameOriginal[v3] then
                                    v5 = v2[2][2].HiddenNameOriginal
                                    v9 = {Visible = v3.Visible}
                                    v9.TextTransparency = v3.TextTransparency
                                    v9.TextStrokeTransparency = v3.TextStrokeTransparency
                                    v5[v3] = v9
                                end
                                v3.Visible = false
                                v3.TextTransparency, v7 = 1, 1
                                v3.TextStrokeTransparency = 1
                            end
                        end
                    end
                end
                return
            end
        elseif not v2[3][2].HideName then
            return
        else
            if v3:IsA("Humanoid") then
                if not v2[2][2].HiddenNameOriginal[v3] then
                    v7 = {}
                    v4 = v2[2][2].HiddenNameOriginal
                    v7.DisplayName = v3.DisplayName
                    v7.NameDisplayDistance = v3.NameDisplayDistance
                    v4[v3] = v7
                end
                v3.NameDisplayDistance = 0
                v3.DisplayName = ""
            elseif v3:IsA("TextLabel") or v3:IsA("TextButton") then
                if v3:FindFirstAncestorWhichIsA("BillboardGui") then
                    v4 = v3.Text
                    v6 = v2[1][2]
                    v5, v8, v6, v9, v7 = v4.find, true, 1, v6.Name, v4
                    v5 = v5(v7, v9, 1, true)
                    if v5 then
                        if v5 then
                            if not v2[2][2].HiddenNameOriginal[v3] then
                                v5 = v2[2][2].HiddenNameOriginal
                                v9 = {Visible = v3.Visible}
                                v9.TextTransparency = v3.TextTransparency
                                v9.TextStrokeTransparency = v3.TextStrokeTransparency
                                v5[v3] = v9
                            end
                            v3.Visible = false
                            v3.TextTransparency, v7 = 1, 1
                            v3.TextStrokeTransparency = 1
                        end
                    elseif v2[1][2].DisplayName ~= "" then
                        v6 = v2[1][2]
                        v5, v9, v8, v7, v6 = v4.find, v6.DisplayName, true, v4, 1
                        v5 = v5(v7, v9, 1, true)
                        if v5 then
                            if not v2[2][2].HiddenNameOriginal[v3] then
                                v5 = v2[2][2].HiddenNameOriginal
                                v9 = {Visible = v3.Visible}
                                v9.TextTransparency = v3.TextTransparency
                                v9.TextStrokeTransparency = v3.TextStrokeTransparency
                                v5[v3] = v9
                            end
                            v3.Visible = false
                            v3.TextTransparency, v7 = 1, 1
                            v3.TextStrokeTransparency = 1
                        end
                    end
                end
            end
            return
        end
    end
end
local function _w127(v1, v2)
    return function(v3)
        v3 = v1._.tonumber(v3)
        local v4 = {}
        local v5 = v1._.table.find
        v4[1], v4[3], v4[2] = 1, 2, 1.5
        local v6
        v6, v4 = v4, v3
        v5 = v5(v6, v4)
        local v7, v8, v9, v10
        if not v5 then
            return false
        else
            v5 = v2[2][2]
            v5.GameClock()
            v5.Speed.Value = v3
            v10 = v2[1][2]
            v6 = {}
            v8 = v1._.game.PlaceId
            v7 = v1._.tostring(v8)
            v9 = v1._.game.JobId
            v6.Server = v7 .. "/" .. v1._.tostring(v9)
            v6.Value = v3
            v10.__CameraTDConfirmedSpeed = v6
            v5 = v2[2][2]
            v6 = v5.Speed.Revision
            v5.Speed.Revision = v6 + 1
            return true
        end
    end
end
local function _w128(v1, v2)
    return function(v3)
        v2[2][2].FPSBoost = v3 == true
        local v4 = v2[2][2]
        v2[1][2].FPS(v4.FPSBoost)
        v2[1][2].SaveSettings()
    end
end
local function _w129(v1)
    local gsub = string.gsub
    local v2 = {[1] = 2, [2] = string.char}
    v2[3] = v2
    gsub = {[1] = 2, [2] = gsub}
    gsub[3] = gsub
    local band = bit32.band
    local v3 = {[1] = 2, [2] = bit32.rshift}
    v3[3] = v3
    band = {[1] = 2, [2] = band}
    band[3] = band
    return v1:re({v2, gsub, v3, band})
end
local function _w130(v1, v2)
    return function()
        local v3 = 198
        local v4, v5, v6, v7
        repeat
            if v3 == 223 then
                v3 = 30
                v1._.task.wait(1)
            elseif v3 <= 30 then
                v6 = v2[1][2]
                v7 = v6.Running
                v3 = v7 and 284 - v3 or 193 - v3
            elseif v3 >= 31 and v3 <= 163 then
                return
            elseif v3 >= 164 and v3 <= 222 then
                v3 = 30
            elseif v3 >= 224 and v3 <= 237 then
                v5 = v2[1][2].SetStatus
                v3, v4 = v3 + -14, v1._.tostring(v6)
                v5("Quest", "Quest update failed: " .. v4)
            else
                v6 = v2[1][2].QuestStep
                v7, v6 = v1._.pcall(v6)
                v3 = not v7 and 237 or 223
            end
        until false
    end
end
local function _w131(v1)
    return function(v2, v3)
        local v4 = v1._.tonumber
        local v5 = v2.Name
        local v6
        v6, v5 = v5, v5.match
        v5 = table.pack(v5(v6, "%d+"))
        v4 = v4(table.unpack(v5, 1, v5.n))
        local v7
        if v4 then
            v5 = v1._.tonumber
            v6 = v3.Name
            v7, v6 = v6, v6.match
            v6 = table.pack(v6(v7, "%d+"))
            v5 = v5(table.unpack(v6, 1, v6.n))
            if v5 then
                return v4 < v5
            else
                return v4 < 0
            end
        else
            v5 = v1._.tonumber
            v6 = v3.Name
            v7, v6 = v6, v6.match
            v6 = table.pack(v6(v7, "%d+"))
            v5 = v5(table.unpack(v6, 1, v6.n))
            if v5 then
                return 0 < v5
            else
                return false
            end
        end
    end
end
local function _w133(v1, v2)
    return function(v3, v4, v5)
        local v6 = 102
        local v7, v8, v9, v10
        repeat
            if v6 == 66 then
                v6, v8 = v6 + 34, v2[1][2]
                v7 = v8.Serial ~= v5
            elseif v6 == 100 then
                v6 = v7 and v6 + 49 or 289 - v6
            elseif v6 == 149 then
                v6 = v7 and 93 or v6 + -42
            elseif v6 == 189 then
                v6, v7 = v6 + -40, not v2[1][2].Playing
            elseif v6 == 219 then
                return true
            elseif v6 >= 205 and v6 <= 218 then
                return false, "Cancelled / match ended"
            elseif v6 >= 199 and v6 <= 204 then
                v6, v7 = 278 - v6, v1._.math
                v10 = v7.huge
            elseif v6 >= 190 and v6 <= 192 then
                return false, "Timed out waiting for confirmation"
            elseif v6 >= 193 and v6 <= 198 then
                v7 = v3()
                v6 = v7 and 219 or 12
            elseif v6 >= 150 and v6 <= 188 then
                v6 = v10 and 74 or 356 - v6
            elseif v6 >= 103 and v6 <= 148 then
                v6 = 93
                v7 = not v2[1][2].Active()
            elseif v6 >= 101 and v6 <= 102 then
                v10 = v4
                v6 = v4 and 45 or 152
            elseif v6 >= 93 and v6 <= 99 then
                v6 = v7 and v6 + 122 or 198
            elseif v6 >= 13 and v6 <= 65 then
                v6, v7 = v6 + 107, v1._.os.clock
                v7 = v7()
                v10 = v7 + v4
            elseif v6 <= 12 then
                v6, v7, v9 = 2892 / v6, v1._.task.wait, 0.1
                v7(0.1)
            elseif v6 >= 67 and v6 <= 92 then
                v7 = not v2[1][2].Running
                v6 = v7 and 7400 / v6 or v6 + -8
            else
                v7 = v1._.os.clock()
                v6 = v7 >= v10 and 192 or v6 + -167
            end
        until false
    end
end
local function _w134(v1)
    return function(v2)
        local v3 = 4
        local v4
        repeat
            if v3 == 59 then
                return false
            elseif v3 == 195 then
                v3 = v4 and v3 + -136 or v3 + -63
            elseif v3 >= 137 and v3 <= 172 then
                v4 = v2:IsA("GuiObject")
                v3 = v4 and v3 + 90 or 195
            elseif v3 >= 133 and v3 <= 136 then
                v3 = 87
                v4 = not v2.Enabled
            elseif v3 >= 173 and v3 <= 194 then
                v3 = v2 and 332 - v3 or 11245 / v3
            elseif v3 >= 5 and v3 <= 58 then
                v3, v2 = 173, v2.Parent
            elseif v3 <= 4 then
                v3 = 173
            elseif v3 >= 60 and v3 <= 65 then
                return true
            elseif v3 >= 66 and v3 <= 87 then
                v3 = v4 and 92 or 1392 / v3
            elseif v3 >= 88 and v3 <= 92 then
                return false
            elseif v3 >= 93 and v3 <= 132 then
                v4 = v2:IsA("ScreenGui")
                v3 = v4 and 136 or 219 - v3
            else
                v3, v4 = 444 - v3, not v2.Visible
            end
        until false
    end
end
local function _w135(v1, v2, v3, v4, v5)
    v1.jf[v5] = bit32.bnot(bit32.band(bit32.bnot(bit32.band(4294967295, v3 - v4)), bit32.bnot(bit32.bxor(v2, 7200)))) + (bit32.bor(0, v3) + (bit32.band(bit32.band(v3, 65535), bit32.band(v4, 65535)) * bit32.bor(bit32.band(65535, v3), bit32.band(v4, 65535)) + bit32.band(bit32.band(65535, v3), bit32.bnot(bit32.band(65535, v4))) * bit32.band(bit32.bnot(bit32.band(65535, v3)), bit32.band(v4, 65535)) - bit32.band(v4, 65535) * bit32.band(65535, v3)) + -v3)
    return v1.jf[v5]
end
local function _w136(v1, v2)
    return function(v3, v4, v5)
        local v6 = 174
        local v7, v8, v9, v10, v11, v12
        while true do
            if v6 == 37 then
                v6 = v9 and 257 - v6 or v6 + 195
            elseif v6 == 96 then
                v6, v8 = v6 + 119, v4[v7]
                v9 = v9[v8]
            elseif v6 == 141 then
                return
            elseif v6 == 200 then
                v11 = v2[1][2]
                v7 = v11.InventoryData
                v6, v9 = v6 + -164, not v7
            elseif v6 >= 216 and v6 <= 220 then
                return
            elseif v6 >= 210 and v6 <= 215 then
                v7 = v7 + v12
                v6 = (v12 > 0 and v7 > v11 or v12 <= 0 and v7 < v11 or false) and 132 or 424 - v6
            elseif v6 >= 201 and v6 <= 209 then
                v10 = v9[v4[v7]]
                v8 = v1._.type(v10)
                v6 = v8 ~= "table" and 228 - v6 or 96
            elseif v6 >= 142 and v6 <= 199 then
                v7 = v1._.tostring(v3)
                v12 = v2[1][2].ReplicaId
                v11 = v1._.tostring(v12)
                v9 = v7 ~= v11
                v6 = v9 and 36 or 200
            elseif v6 >= 97 and v6 <= 140 then
                v7 = #v4
                v11 = 0
                v6 = v7 > 0 and 173 - v6 or 18612 / v6
            elseif v6 >= 42 and v6 <= 95 then
                v7 = v1._.type(v4)
                v6 = 37
                v11 = "table"
                v9 = v7 ~= "table"
            elseif v6 >= 38 and v6 <= 41 then
                v6, v9[v4[#v4]] = v6 + 100, v5
                v11 = v2[1][2]
                v7, v11 = v11.Inventory, v11.InventoryData
                v7(v11)
            elseif v6 >= 20 and v6 <= 36 then
                v6 = v9 and v6 + 1 or 103 - v6
            elseif v6 <= 19 then
                v6, v9[v4[v7]] = 1824 / v6, {}
            else
                v7 = 1
                v9 = v2[1][2].InventoryData
                v12 = 1
                v11 = #v4 - 1
                v6 = (1 > v11 or false) and 30624 / v6 or 209
            end
        end
    end
end
local function _w138(v1, v2)
    return function()
        local v3, v4, clock2
        if v2[1][2].Running then
            clock2 = v1._.os.clock()
            v4 = v2[1][2].Hydrate
            v3 = v1._.pcall(v4, true)
            v2[1][2].LoadTimes.HydrateSeconds = v1._.os.clock() - clock2
            v2[1][2].LoadTimes.HydrateOK = v3
        end
    end
end
local function _w139(v1, v2)
    return function()
        local v3 = v2[1][2].Speed
        local clock3 = v1._.os.clock()
        local v4 = v1._.math.max
        local v5 = v3.At
        v3.Clock = v3.Clock + v4(0, clock3 - v5) * v3.Value
        v3.At = clock3
        return v3.Clock
    end
end
local function _w141(v1, v2)
    return function(v3)
        local v4 = not v3 or v2[2][2].EndSent or v2[1][2].EndAction == "None"
        local v5, v6, v7
        if v4 then
            if v4 then
                return
            elseif v2[1][2].EndAction == "Replay" then
                v4 = v2[2][2]
                v4.EndSent = true
                v4, v5 = v4.Fire, "PlayAgain"
                v4, v5 = v4("PlayAgain")
                v7 = v2[2][2].SetStatus
                if v4 then
                    v7("Match", "Replay requested; waiting for next round")
                else
                    v7("Match", v1._.tostring(v5))
                end
                return
            else
                if v2[1][2].EndAction == "Return" then
                    v4 = v2[2][2]
                    v4.EndSent, v6 = true, true
                    v4.ReturnSent = true
                    v5 = v4
                    v5.QueueTeleport()
                    v4, v5 = v5.Fire, "OnLeave"
                    v4("OnLeave")
                end
                return
            end
        elseif v2[2][2].SoloReturning then
            return
        elseif v2[1][2].EndAction == "Replay" then
            v4 = v2[2][2]
            v4.EndSent = true
            v4, v5 = v4.Fire, "PlayAgain"
            v4, v5 = v4("PlayAgain")
            v7 = v2[2][2].SetStatus
            if v4 then
                v7("Match", "Replay requested; waiting for next round")
            else
                v7("Match", v1._.tostring(v5))
            end
            return
        elseif v2[1][2].EndAction == "Return" then
            v4 = v2[2][2]
            v4.EndSent, v6 = true, true
            v4.ReturnSent = true
            v5 = v4
            v5.QueueTeleport()
            v4, v5 = v5.Fire, "OnLeave"
            v4("OnLeave")
            return
        else
            return
        end
    end
end
local function _w142(v1, v2)
    return function()
        local v3 = v2[1][2]
        local v4 = v3.Visible
        local v5
        v3, v5 = v3.GUI, "FinalUI/Content/Lobby"
        v3 = table.pack(v3("FinalUI/Content/Lobby"))
        local pack = table.pack(v4(table.unpack(v3, 1, v3.n)))
        return table.unpack(pack, 1, pack.n)
    end
end
local function h(...)
    return {[1] = {...}, [2] = select("#", ...)}
end
local function _w144(v1, v2)
    return function()
        local v3 = v2[3][2]
        local v4 = v2[1][2]
        v2[2][2][v3] = v4
    end
end
local function _w145(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        v4.AutoLobby = v3 == true
        v4.StartNow = true
        v4 = not v4.AutoLobby
        if v4 then
            v2[1][2].LeaveElevator()
        end
        v2[1][2].SaveSettings()
    end
end
local function _w146(v1, v2)
    return function()
        local v3 = v2[5][2]
        local v4 = v2[3][2]
        local v5
        v5, v4 = v2[1][2].FindPlacement(v4, v3)
        v2[2][2], v2[4][2] = v5, v4
        v5 = v2[2][2] ~= nil
        if v5 then
            return v5
        else
            return v2[4][2] ~= nil
        end
    end
end
local function _w147(v1, v2)
    return function(v3)
        local v4 = 107
        local v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
        repeat
            if v4 == 25 then
                v4 = 62
                v13 = v11.Running
            elseif v4 == 48 then
                v4, v10 = 6000 / v4, 30
            elseif v4 == 58 then
                return
            elseif v4 == 69 then
                v4 = v7 and 58 or 1311 / v4
            elseif v4 == 99 then
                v11 = not v3
                v4 = v11 and 21681 / v4 or 146 - v4
            elseif v4 == 107 then
                v13 = v2[2][2]
                v11 = v13.Active
                v7 = not v11
                v4 = v7 and 69 or 232
            elseif v4 == 180 then
                v11 = v2[2][2]
                v11.Prompt = v3
                v11.Attempts = 0
                v11.NextAt = v7 + v2[4][2][1]
                v13, v11, v4, v10 = "disconnect_detected", v11.Log, 18900 / v4, {}
                v10.prompt = v3
                v11("disconnect_detected", v10)
            elseif v4 == 229 then
                v4 = v13 and 109 or 57
            elseif v4 == 244 then
                v4, v13 = 55876 / v4, v11.QueueTeleport
            elseif v4 >= 126 and v4 <= 142 then
                v11 = v2[2][2]
                v13 = v11.Attempts + 1
                v11.Attempts = v13
                v5 = v11.Attempts
                v10 = v2[4][2][v5 + 1]
                v4 = v10 and 125 or 190 - v4
            elseif v4 >= 110 and v4 <= 125 then
                v11.NextAt = v7 + v10
                v13 = v2[2][2]
                v14, v10, v11, v13 = v2[2][2], {}, v13.Log, "rejoin_attempt"
                v10.attempt = v14.Attempts
                v10.placeId = 132929771812494
                v11("rejoin_attempt", v10)
                v11 = v2[1][2].CameraTDHub
                v13 = v11
                v4 = v11 and 3125 / v4 or 62
            elseif v4 >= 103 and v4 <= 106 then
                v11 = v2[2][2].Attempts
                v10 = v2[4][2]
                v13 = #v10
                v4 = v11 >= v13 and 137 - v4 or v4 + -81
            elseif v4 >= 108 and v4 <= 109 then
                v4 = 57
                v13 = v1._.pcall
                v10 = v11.QueueTeleport
                v13(v10)
            elseif v4 >= 181 and v4 <= 197 then
                v10 = v2[2][2]
                v13 = 45
                v11 = v7 - v10.InFlight
                v4 = v11 < 45 and v4 + -129 or 34
            elseif v4 >= 165 and v4 <= 179 then
                v2[2][2].Status("Prompt detected; no reconnect required")
                return
            elseif v4 >= 143 and v4 <= 164 then
                v14 = v2[2][2].Attempts
                v6 = v2[2][2].NextAt - v7
                v2[2][2].Status("Lobby retry " .. v14 + 1 .. "/3 in " .. v1._.math.ceil(v6) .. "s")
                return
            elseif v4 >= 198 and v4 <= 219 then
                v13 = v2[2][2]
                v11 = v13.Prompt
                v4 = v11 and 294 - v4 or 12
            elseif v4 >= 222 and v4 <= 228 then
                v4 = 221
                v2[2][2].Status("Lobby request sent; awaiting teleport")
            elseif v4 >= 245 then
                v4, v13 = 41415 / v4, v2[2][2]
                v11 = v13.Reset
                v11()
            elseif v4 >= 230 and v4 <= 243 then
                v13 = v2[2][2]
                v11 = v13.Armed
                v4, v7 = 16008 / v4, not v11
            elseif v4 >= 1 and v4 <= 12 then
                v2[2][2].Status("Monitoring connection")
                return
            elseif v4 <= 0 then
                v14 = v2[2][2]
                v5, v8, v12, v14 = {}, v2[2][2], v14.Log, "teleport_call_error"
                v4, v9 = 221 - v4, v8.Attempts
                v5.attempt = v9
                v5.error = v1._.tostring(v10)
                v12("teleport_call_error", v5)
                v2[2][2].Status("Teleport call failed; waiting for next retry")
            elseif v4 >= 13 and v4 <= 16 then
                v13 = v2[2][2]
                v11 = v13.Prompt
                v4 = v11 and 251 or 165
            elseif v4 >= 17 and v4 <= 19 then
                v7 = v1._.os.clock()
                v13 = v2[2][2]
                v11 = v13.InFlight
                v4 = v11 and 197 or 118 - v4
            elseif v4 >= 20 and v4 <= 24 then
                v13 = v2[2][2]
                v11 = v13.NextAt
                v4 = v7 < v11 and 188 - v4 or 3408 / v4
            elseif v4 >= 35 and v4 <= 47 then
                v10 = v3
                v13 = v2[2][2].ConnectionError(v10)
                v11 = not v13
                v4 = v11 and v4 + -31 or 149 - v4
            elseif v4 >= 33 and v4 <= 34 then
                v11 = v2[2][2]
                v11.InFlight = nil
                v11, v13, v14, v10 = v11.Log, "teleport_unconfirmed", v2[2][2], {}
                v4, v10.attempt = 99, v14.Attempts
                v11("teleport_unconfirmed", v10)
            elseif v4 >= 26 and v4 <= 32 then
                v2[2][2].Status("Retry limit reached. See test log.")
                return
            elseif v4 >= 49 and v4 <= 57 then
                v13, v10 = v1._.pcall(v1:wc({v2[3], v2[5]}))
                v4 = not v13 and v4 + -57 or 228
            elseif v4 >= 59 and v4 <= 62 then
                v4 = v13 and 15128 / v4 or 14198 / v4
            elseif v4 >= 63 and v4 <= 68 then
                return
            elseif v4 >= 100 and v4 <= 102 then
                v10 = v2[2][2]
                v13 = v10.Prompt
                v11 = not v13
                v4 = v11 and 180 or v4 + 3
            elseif v4 >= 70 and v4 <= 98 then
                v13 = v2[2][2]
                v4 = 900 / v4
                v13.Reset()
                v10, v13, v11 = {}, "prompt_closed", v13.Log
                v11("prompt_closed", v10)
            end
        until false
    end
end
local function _w148(v1, v2, v3, v4, v5)
    v1.Ue[v5] = -v3 + bit32.bnot(bit32.bxor(4294967295, bit32.bxor(v2, 56966))) + bit32.bnot(bit32.band(bit32.bnot(bit32.band(bit32.bxor(v4, 63767), v3)), bit32.bnot(bit32.bxor(v2, 56966)))) + (bit32.bor(bit32.band(bit32.bxor(v4, 63767), 65535), bit32.band(65535, bit32.bxor(v4, 63767))) * bit32.band(bit32.band(65535, bit32.bxor(v4, 63767)), bit32.band(65535, bit32.bxor(v4, 63767))) + bit32.band(bit32.bnot(bit32.band(65535, bit32.bxor(v4, 63767))), bit32.band(65535, bit32.bxor(v4, 63767))) * bit32.band(bit32.bnot(bit32.band(bit32.bxor(v4, 63767), 65535)), bit32.band(65535, bit32.bxor(v4, 63767))) - bit32.band(65535, bit32.bxor(v4, 63767)) * bit32.band(bit32.bxor(v4, 63767), 65535)) + -bit32.bxor(v2, 56966) + bit32.band(bit32.bor(v3, bit32.bxor(v4, 63767)), v3)
    return v1.Ue[v5]
end
local function _w149(v1, v2)
    return function()
        local v3 = 25
        local v4, v5, v6, v7, v8, v9, v10, v11
        repeat
            if v3 == 23 then
                v11 = v10
                v3 = 108
                v4 = v10:FindFirstChild(v2[8][2])
            elseif v3 == 90 then
                v3 = 9
                v11 = v4:GetAttribute("Map") ~= v2[9][2].Map
            elseif v3 == 143 then
                v3 = v10 and 15158 / v3 or 243 - v3
            elseif v3 == 161 then
                v3 = 228
                v11 = v1._.task.wait
                v11(0.08)
            elseif v3 == 162 then
                v2[7][2].CancelJoinWalk()
                return
            elseif v3 == 163 then
                v3 = v11 and 26406 / v3 or 86
            elseif v3 == 210 then
                v3, v11 = v3 + -67, v2[9][2]
                v4, v11 = v11.JoinMethod, "Walk"
                v10 = v4 ~= "Walk"
            elseif v3 == 215 then
                v11 = v2[9][2]
                v4 = v11.Map
                v3, v10 = 32035 / v3, v4 ~= v5
            elseif v3 == 222 then
                v3 = v10 and 38 or v3 + -69
            elseif v3 == 238 then
                v3, v11 = 460 - v3, v2[3][2]
                v11, v4 = v2[5][2], v11.Character
                v10 = v4 ~= v11
            elseif v3 >= 24 and v3 <= 25 then
                v9 = 0
                v3 = 228
                v10 = v2[9][2]
                v5 = v10.Map
            elseif v3 <= 9 then
                v3 = v11 and 163 or 105 - v3
            elseif v3 >= 10 and v3 <= 22 then
                return
            elseif v3 >= 26 and v3 <= 27 then
                v11 = v2[7][2]
                v4 = v11.Running
                v10 = not v4
                v3 = v10 and 6318 / v3 or 3294 / v3
            elseif v3 >= 28 and v3 <= 29 then
                v3 = 64
                v11 = 0
                v4 = v2[4][2].Health
                v10 = v4 <= 0
            elseif v3 >= 71 and v3 <= 73 then
                v8 = v2[7][2]
                v8, v11 = v2[6][2], v8.JoinWalk
                v3 = v11 ~= v8 and 10 or 161
            elseif v3 >= 65 and v3 <= 70 then
                return
            elseif v3 >= 52 and v3 <= 64 then
                v3 = v10 and 149 or 279 - v3
            elseif v3 >= 39 and v3 <= 51 then
                v11 = v2[7][2].JoinWalk
                v8 = v2[6][2]
                v3 = v11 == v8 and 243 or 249 - v3
            elseif v3 >= 30 and v3 <= 38 then
                v3 = v10 and 226 - v3 or 168
            elseif v3 >= 101 and v3 <= 106 then
                v3 = v10 and 142 or 253
            elseif v3 >= 97 and v3 <= 100 then
                v3 = 106
                v4 = v1._.game.PlaceId
                v11 = v2[7][2].LobbyId
                v10 = v4 ~= v11
            elseif v3 >= 80 and v3 <= 89 then
                v4 = v2[7][2].WalkToJoin
                v11 = v2[1][2]
                v8 = v2[8][2]
                v10, v4 = v1._.pcall(v4, v11, v8)
                v11 = not v10
                v3 = v11 and 137 - v3 or 73
            elseif v3 >= 74 and v3 <= 79 then
                v10 = v1._.os.clock()
                v10, v11, v9 = v2[2][2], "Elevators", v10 + 0.4
                v10 = v10:FindFirstChild("Elevators")
                v4 = v10
                v3 = v10 and 23 or 108
            elseif v3 >= 91 and v3 <= 96 then
                v3, v8 = 15648 / v3, v2[7][2]
                v8, v11, v6 = v4, v8.CircleOccupied, false
                v11 = v11(v8, false)
            elseif v3 >= 133 and v3 <= 142 then
                v3 = v10 and 219 or 356 - v3
            elseif v3 >= 107 and v3 <= 108 then
                v6 = v1._.string
                v7, v6, v8 = "^Exit:", v2[8][2], v6.match
                v11 = not v8(v6, "^Exit:")
                v3 = v11 and 226 or 163
            elseif v3 >= 109 and v3 <= 122 then
                v3, v11 = v3 + 112, v2[9][2]
                v4 = v11.AutoLobby
                v10 = not v4
            elseif v3 >= 123 and v3 <= 132 then
                v4 = v1._.os
                v10 = v4.clock()
                v3 = v10 >= v9 and 79 or 11352 / v3
            elseif v3 >= 216 and v3 <= 221 then
                v3 = v10 and 222 or 238
            elseif v3 >= 227 and v3 <= 233 then
                v10 = v2[7][2].JoinWalk
                v4 = v2[6][2]
                v3 = v10 == v4 and 255 - v3 or 15960 / v3
            elseif v3 >= 223 and v3 <= 226 then
                v11 = not v4
                v3 = v11 and 9 or 20340 / v3
            elseif v3 >= 244 and v3 <= 246 then
                v2[7][2].CancelJoinWalk()
                return
            elseif v3 >= 239 and v3 <= 243 then
                v3 = 198
                v11 = v2[7][2].CancelJoinWalk
                v11()
            elseif v3 >= 234 and v3 <= 237 then
                v3 = v10 and 143 or v3 + -24
            elseif v3 >= 150 and v3 <= 160 then
                v11 = v2[10][2]
                v4 = v11.Parent
                v3 = 38
                v10 = not v4
            elseif v3 >= 144 and v3 <= 149 then
                v3 = v10 and v3 + 97 or 132
            elseif v3 >= 211 and v3 <= 214 then
                v4 = v2[7][2]
                v3 = 219
                v10 = v4.Elevator
            elseif v3 >= 198 and v3 <= 209 then
                v7 = v1._.tostring
                v2[7][2].SetStatus("Lobby", "Walking failed: " .. v7(v4))
                return
            elseif v3 >= 164 and v3 <= 168 then
                v11 = v2[4][2]
                v3 = 188
                v4 = v11.Parent
                v10 = not v4
            elseif v3 >= 169 and v3 <= 197 then
                v3 = v10 and v3 + -124 or v3 + -159
            else
                v4 = v2[7][2]
                v3 = 142
                v10 = v4.Teleporting
            end
        until false
    end
end
local function _w150(v1, v2)
    return function()
        local v3 = 204
        local v4, v5, v6, v7, robloxPromptGui, v8, v9, v10, v11, v12, v13, v14
        while true do
            if v3 == 12 then
                v8 = "ErrorPrompt"
                v4 = v14
                v3, v13 = v3 + 132, v14:FindFirstChild("ErrorPrompt")
            elseif v3 == 53 then
                v11, v9 = v8(v5, v12)
                v12 = v11
                v3 = v11 == nil and 214 or 3021 / v3
            elseif v3 == 57 then
                v6 = v9:IsA("TextLabel")
                v3 = v6 and 190 or 185
            elseif v3 == 66 then
                v3 = 163
                v5 = v4
                v12 = " | "
                v8 = v1._.table.concat(v5, " | ")
            elseif v3 == 67 then
                v4 = robloxPromptGui
                v3 = robloxPromptGui and 74 - v3 or 33
            elseif v3 == 109 then
                v3 = v6 and 25942 / v3 or 53
            elseif v3 == 163 then
                v3 = v8 and 219 or v3 + -7
            elseif v3 == 182 then
                v3, v6 = v3 + -73, v9.Text ~= ""
            elseif v3 == 187 then
                v3 = v4 and 56 or 59
            elseif v3 == 204 then
                v13 = "RobloxPromptGui"
                robloxPromptGui = v2[2][2]:FindFirstChild("RobloxPromptGui")
                v14 = robloxPromptGui
                v3 = robloxPromptGui and 226 or 106
            elseif v3 >= 188 and v3 <= 203 then
                v3, v6 = 375 - v3, v2[1][2](v9)
            elseif v3 >= 205 and v3 <= 214 then
                v5 = #v4
                v12 = 0
                v8 = v5 > 0
                v3 = v8 and 66 or v3 + -51
            elseif v3 >= 215 and v3 <= 219 then
                return v8
            elseif v3 >= 220 and v3 <= 226 then
                v13, v14, v3, v4 = robloxPromptGui, robloxPromptGui.FindFirstChild, 332 - v3, "promptOverlay"
                v14 = v14(v13, "promptOverlay")
            elseif v3 >= 178 and v3 <= 181 then
                return nil
            elseif v3 >= 183 and v3 <= 186 then
                v3 = v6 and 367 - v3 or 294 - v3
            elseif v3 >= 145 and v3 <= 162 then
                v3 = 219
                v8 = nil
            elseif v3 >= 164 and v3 <= 177 then
                v5 = v13.GetDescendants
                v8 = v1._.ipairs
                v4 = {}
                v5 = v1.h(v5(v13))
                v8, v5, v12 = v8(v1.i(v5))
                v8, v5, v12 = v1.g(v8, v5, v12)
                v11, v9 = v8(v5, v12)
                v12 = v11
                v3 = v11 == nil and 214 or 57
            elseif v3 >= 13 and v3 <= 19 then
                v3, v4 = 3553 / v3, v14
            elseif v3 <= 11 then
                v8 = robloxPromptGui
                v5 = "ErrorPrompt"
                v12 = true
                v3 = 33
                v4 = robloxPromptGui:FindFirstChild("ErrorPrompt", true)
            elseif v3 >= 20 and v3 <= 33 then
                v13 = v4
                v3 = v4 and 187 or 52 - v3
            elseif v3 >= 54 and v3 <= 56 then
                v13 = v4
                v4 = not v4
                v3 = v4 and 48 or 93
            elseif v3 >= 34 and v3 <= 52 then
                v3 = v4 and 178 or 8304 / v3
            elseif v3 >= 58 and v3 <= 65 then
                v3 = 56
                v4 = robloxPromptGui
            elseif v3 >= 68 and v3 <= 93 then
                v5 = v13
                v3 = 48
                v8 = v2[1][2](v13)
                v4 = not v8
            elseif v3 >= 110 and v3 <= 144 then
                v4 = v13
                v3 = v13 and 4752 / v3 or 211 - v3
            elseif v3 >= 94 and v3 <= 108 then
                v13 = v14
                v3 = v14 and 12 or 15264 / v3
            else
                v3 = 53
                v7 = v1._.table
                v7, v10, v6 = v4, v9.Text, v7.insert
                v6(v7, v10)
            end
        end
    end
end
local function _w151(v1, v2)
    return function(v3)
        v2[2][2].WebhookMatchEnd = v3 == true
        v2[1][2].SaveSettings()
    end
end
local function _w152(v1, v2, v3)
    v1.vf[v3] = v2
    return v1.vf[v3]
end
local function _w153(v1, v2)
    return function(v3)
        v2[2][2].AutoDifficulty = v3 == true
        v2[1][2].SaveSettings()
    end
end
local function _w154(v1)
    return function(v2, v3)
        local v4 = v3.Id
        return v2.Id < v4
    end
end
local function _w155(v1, v2)
    return function(v3)
        v2[1][2].SetHideName(v3)
        v2[1][2].SaveSettings()
    end
end
local function _w156(v1, v2)
    return function()
        local v3 = 217
        local v4, v5, v6, v7, v8, v9
        repeat
            if v3 == 135 then
                return
            elseif v3 == 136 then
                v8 = v2[1][2]
                v6 = v8.Running
                v3 = v6 and 100 or 135
            elseif v3 >= 42 and v3 <= 50 then
                v5 = v1._.task
                v5, v9, v4 = 0.1, v2[1][2], v5.wait
                v3 = 136
                v4(0.1 / v9.Speed.Value)
            elseif v3 <= 41 then
                v7 = v1._.tostring
                v3 = 50
                v2[1][2].SetStatus("Auto", "Auto Play error: " .. v7(v8))
            elseif v3 >= 51 and v3 <= 134 then
                v8 = v2[1][2].AutoStep
                v6, v8 = v1._.pcall(v8)
                v3 = not v6 and v3 + -59 or 50
            else
                v3 = 136
            end
        until false
    end
end
local function _w157(v1, v2)
    return function(v3)
        local v4 = 177
        local v5, v6, v7, v8, v9, v10, v11, v12
        repeat
            if v4 == 6 then
                v11 = v2[1][2].Towers
                v10 = v3.Id
                v9 = v11[v10]
                v4 = v9 and v4 + 149 or 69 - v4
            elseif v4 == 155 then
                v12 = v9
                v10 = "TowerSell"
                v11 = v2[1][2].TakeStamp("TowerSell", v12)
                v4 = v11 and 205 or 18135 / v4
            elseif v4 >= 206 then
                v4, v6, v8 = 384 - v4, v2[1][2].MergeTower, v7
                v6(v8)
            elseif v4 >= 178 and v4 <= 205 then
                v4, v12 = 23985 / v4, v2[1][2]
                v5, v10, v12, v7 = v9, v12.RecordAction, "Sell", v11
                v10("Sell", v5, v7)
            elseif v4 >= 120 and v4 <= 154 then
                v5, v7 = v11(v10, v12)
                v12 = v5
                v4 = v5 == nil and 1 or 238
            elseif v4 >= 156 and v4 <= 177 then
                v9 = v1._.type(v3)
                v11 = "table"
                v4 = v9 ~= "table" and 14 or 6
            elseif v4 >= 64 and v4 <= 117 then
                v7 = v1._.os
                v12 = v3.Id
                v4 = 63
                v2[1][2].Removed[v12] = v7.clock()
                v10 = v2[1][2].Towers
                v12 = v3.Id
                v10[v12] = nil
            elseif v4 >= 118 and v4 <= 119 then
                v11, v10, v12 = v1._.pairs(v3.Towers)
                v11, v10, v12 = v1.g(v11, v10, v12)
                v5, v7 = v11(v10, v12)
                v12 = v5
                v4 = v5 == nil and 1 or 238
            elseif v4 <= 5 then
                return
            elseif v4 >= 15 and v4 <= 63 then
                v11 = v1._.type(v3.Towers)
                v10 = "table"
                v4 = v11 == "table" and v4 + 56 or 1
            end
        until false
    end
end
local function _w158(v1, v2)
    return function()
        local v3 = not v2[2][2].AutoExecute
        local v4, v5, v6, v7
        if v3 then
            if not v3 then
                v3 = v1._.queue_on_teleport or v1._.queueonteleport or v1._.syn and v1._.syn.queue_on_teleport
                v5 = v1._.type(v3) ~= "function" or not v2[1][2].FS
                if v5 then
                    if v5 then
                        v2[1][2].SetStatus("Macro", "Auto Execute unavailable: queue_on_teleport + shared filesystem required")
                    else
                        v5, v6 = v1._.pcall(v3, "        if game.GameId ~= 10762636904 then return end\n        task.wait(3)\n        local players = game:GetService(\"Players\")\n        local player = players.LocalPlayer or players.PlayerAdded:Wait()\n        local e = getgenv()\n        local key = tostring(game.JobId) .. \"/\" .. tostring(player.UserId)\n        if e.__CameraTDQueuedJob ~= key then\n            local enabled = true\n            local ok, raw = pcall(readfile, \"CameraTD_Macros/Settings/\" .. player.Name .. \".json\")\n            if ok then\n                local good, config = pcall(function() return game:GetService(\"HttpService\"):JSONDecode(raw) end)\n                if good and type(config) == \"table\" then enabled = config.AutoExecute ~= false end\n            end\n            if enabled then\n                local source = readfile(\"CameraTD_Macros/Hub.lua\")\n                local chunk, reason = loadstring(source)\n                assert(chunk, reason)\n                e.__CameraTDQueuedJob = key\n                chunk()\n            end\n        end\n    ")
                        v2[1][2].Queued = v5
                        if not v5 then
                            v4 = v1._.tostring
                            v2[1][2].SetStatus("Macro", "Auto Execute queue failed: " .. v4(v6))
                        end
                    end
                else
                    v7 = v2[1][2].Folder .. "/Hub.lua"
                    if not v1._.isfile(v7) then
                        v2[1][2].SetStatus("Macro", "Auto Execute unavailable: queue_on_teleport + shared filesystem required")
                    else
                        v5, v6 = v1._.pcall(v3, "        if game.GameId ~= 10762636904 then return end\n        task.wait(3)\n        local players = game:GetService(\"Players\")\n        local player = players.LocalPlayer or players.PlayerAdded:Wait()\n        local e = getgenv()\n        local key = tostring(game.JobId) .. \"/\" .. tostring(player.UserId)\n        if e.__CameraTDQueuedJob ~= key then\n            local enabled = true\n            local ok, raw = pcall(readfile, \"CameraTD_Macros/Settings/\" .. player.Name .. \".json\")\n            if ok then\n                local good, config = pcall(function() return game:GetService(\"HttpService\"):JSONDecode(raw) end)\n                if good and type(config) == \"table\" then enabled = config.AutoExecute ~= false end\n            end\n            if enabled then\n                local source = readfile(\"CameraTD_Macros/Hub.lua\")\n                local chunk, reason = loadstring(source)\n                assert(chunk, reason)\n                e.__CameraTDQueuedJob = key\n                chunk()\n            end\n        end\n    ")
                        v2[1][2].Queued = v5
                        if not v5 then
                            v4 = v1._.tostring
                            v2[1][2].SetStatus("Macro", "Auto Execute queue failed: " .. v4(v6))
                        end
                    end
                end
                return
            end
        elseif v2[1][2].Queued then
            return
        else
            v3 = v1._.queue_on_teleport or v1._.queueonteleport or v1._.syn and v1._.syn.queue_on_teleport
            v5 = v1._.type(v3) ~= "function" or not v2[1][2].FS
            if v5 then
                if v5 then
                    v2[1][2].SetStatus("Macro", "Auto Execute unavailable: queue_on_teleport + shared filesystem required")
                else
                    v5, v6 = v1._.pcall(v3, "        if game.GameId ~= 10762636904 then return end\n        task.wait(3)\n        local players = game:GetService(\"Players\")\n        local player = players.LocalPlayer or players.PlayerAdded:Wait()\n        local e = getgenv()\n        local key = tostring(game.JobId) .. \"/\" .. tostring(player.UserId)\n        if e.__CameraTDQueuedJob ~= key then\n            local enabled = true\n            local ok, raw = pcall(readfile, \"CameraTD_Macros/Settings/\" .. player.Name .. \".json\")\n            if ok then\n                local good, config = pcall(function() return game:GetService(\"HttpService\"):JSONDecode(raw) end)\n                if good and type(config) == \"table\" then enabled = config.AutoExecute ~= false end\n            end\n            if enabled then\n                local source = readfile(\"CameraTD_Macros/Hub.lua\")\n                local chunk, reason = loadstring(source)\n                assert(chunk, reason)\n                e.__CameraTDQueuedJob = key\n                chunk()\n            end\n        end\n    ")
                    v2[1][2].Queued = v5
                    if not v5 then
                        v4 = v1._.tostring
                        v2[1][2].SetStatus("Macro", "Auto Execute queue failed: " .. v4(v6))
                    end
                end
            else
                v7 = v2[1][2].Folder .. "/Hub.lua"
                if not v1._.isfile(v7) then
                    v2[1][2].SetStatus("Macro", "Auto Execute unavailable: queue_on_teleport + shared filesystem required")
                else
                    v5, v6 = v1._.pcall(v3, "        if game.GameId ~= 10762636904 then return end\n        task.wait(3)\n        local players = game:GetService(\"Players\")\n        local player = players.LocalPlayer or players.PlayerAdded:Wait()\n        local e = getgenv()\n        local key = tostring(game.JobId) .. \"/\" .. tostring(player.UserId)\n        if e.__CameraTDQueuedJob ~= key then\n            local enabled = true\n            local ok, raw = pcall(readfile, \"CameraTD_Macros/Settings/\" .. player.Name .. \".json\")\n            if ok then\n                local good, config = pcall(function() return game:GetService(\"HttpService\"):JSONDecode(raw) end)\n                if good and type(config) == \"table\" then enabled = config.AutoExecute ~= false end\n            end\n            if enabled then\n                local source = readfile(\"CameraTD_Macros/Hub.lua\")\n                local chunk, reason = loadstring(source)\n                assert(chunk, reason)\n                e.__CameraTDQueuedJob = key\n                chunk()\n            end\n        end\n    ")
                    v2[1][2].Queued = v5
                    if not v5 then
                        v4 = v1._.tostring
                        v2[1][2].SetStatus("Macro", "Auto Execute queue failed: " .. v4(v6))
                    end
                end
            end
            return
        end
    end
end
local function _w159(v1, v2)
    return function(inventoryData)
        local v3 = 91
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
        while true do
            if v3 == 9 then
                v10, v6 = v12(v8, v4)
                v4 = v10
                v3 = v10 == nil and 113 - v3 or v3 + 15
            elseif v3 == 126 then
                v3 = v9 and 9702 / v3 or v3 + 25
            elseif v3 == 150 then
                v3 = v12 and 140 or 173
            elseif v3 == 173 then
                v2[1][2].InventoryData = inventoryData
                v8 = v2[1][2].Units
                v12, v8, v4 = v1._.pairs(v8)
                v12, v8, v4 = v1.g(v12, v8, v4)
                v10, v6 = v12(v8, v4)
                v4 = v10
                v3 = v10 == nil and v3 + -69 or 197 - v3
            elseif v3 == 244 then
                return
            elseif v3 >= 174 and v3 <= 243 then
                v7.Equipped = v13
                v3, v9[v5] = 151, v7
            elseif v3 >= 151 and v3 <= 172 then
                v10, v6 = v12(v8, v4)
                v4 = v10
                v3 = v10 == nil and 244 or 48
            elseif v3 >= 133 and v3 <= 149 then
                return
            elseif v3 >= 78 and v3 <= 91 then
                v8 = v1._.type(inventoryData)
                v4 = "table"
                v12 = v8 ~= "table"
                v3 = v12 and 150 or 8
            elseif v3 >= 92 and v3 <= 125 then
                v12, v8, v4 = v1._.pairs(inventoryData.Towers)
                v12, v8, v4 = v1.g(v12, v8, v4)
                v10, v6 = v12(v8, v4)
                v4 = v10
                v3 = v10 == nil and 25376 / v3 or 4992 / v3
            elseif v3 >= 127 and v3 <= 132 then
                v3 = 224
                v13 = 0
            elseif v3 >= 49 and v3 <= 77 then
                v9 = v2[1][2].Units
                v5 = v1._.tostring(v10)
                v7 = {}
                v7.Id = v1._.tostring(v10)
                v7.Name = v6.Name
                v13 = v1._.tonumber(v6.Equipped)
                v3 = v13 and v3 + 147 or 209 - v3
            elseif v3 >= 25 and v3 <= 48 then
                v5 = v1._.type(v6)
                v9 = v5 == "table"
                v3 = v9 and 250 or 174 - v3
            elseif v3 <= 8 then
                v3, v8 = 1200 / v3, v1._.type(inventoryData.Towers)
                v4 = "table"
                v12 = v8 ~= "table"
            elseif v3 >= 10 and v3 <= 24 then
                v3, v9 = 33 - v3, 0
                v6.Equipped = 0
            else
                v11 = v6.Name
                v3 = 126
                v5 = v1._.type(v11)
                v9 = v5 == "string"
            end
        end
    end
end
local function _w160(v1, v2)
    return function(v3)
        v2[2][2].AutoSummon = v3 == true
        v2[1][2].SaveSettings()
    end
end
local function _w161(v1, v2)
    return function(v3, v4, v5)
        local v6 = 31
        local v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
        while true do
            if v6 == 22 then
                v9 = not v13
                v6 = v9 and 220 - v6 or 4576 / v6
            elseif v6 == 31 then
                v12 = v2[1][2].Recording
                v13 = not v12
                v6 = v13 and 248 or 146
            elseif v6 == 90 then
                v6, v14 = v6 + 112, v5.Time
            elseif v6 == 100 then
                v6 = v14 and 119 or 294 - v6
            elseif v6 == 101 then
                v6, v9.Cost = v6 + -24, v7
            elseif v6 == 125 then
                return
            elseif v6 == 131 then
                v6 = v7 and 372 - v6 or 112
            elseif v6 == 146 then
                v7 = v4
                v9 = v2[1][2].Own(v7)
                v6, v13 = 36208 / v6, not v9
            elseif v6 == 178 then
                v6 = v7 and 73 or v6 + 11
            elseif v6 == 203 then
                v6, v14 = v6 + -103, v5.Wave
            elseif v6 == 235 then
                return
            elseif v6 == 249 then
                v7 = v4.Name
                v10 = {}
                v15 = v4.CFrame
                v14 = v4.UnitId
                v8, v15 = v15, v15.GetComponents
                v15 = table.pack(v15(v8))
                v1.j(v10, 1, table.unpack(v15, 1, v15.n))
                v9.Name, v16 = v7, v10
                v9.UnitId = v14
                v9.CFrame = v16
                v7 = v5
                v6 = v5 and 148 or 44322 / v6
            elseif v6 >= 60 and v6 <= 68 then
                v6 = 24
                v14 = v2[1][2].RecordTime(v12)
            elseif v6 >= 69 and v6 <= 73 then
                v6 = v7 and 171 or v6 + 166
            elseif v6 >= 46 and v6 <= 59 then
                v14 = v5.Cost
                v6 = 131
                v7 = v1._.tonumber(v14)
            elseif v6 >= 32 and v6 <= 35 then
                v7 = "Target"
                v6 = v3 == "Target" and 63 - v6 or 2695 / v6
            elseif v6 >= 36 and v6 <= 45 then
                v9.Level = v4.Level
                v7 = v5
                v6 = v5 and 59 or 131
            elseif v6 >= 6 and v6 <= 21 then
                v7 = v1._.tonumber
                v14 = v4.Stats
                v6 = v14 and 30 or 19 - v6
            elseif v6 <= 1 then
                v7 = v7(v14)
                v6 = v7 and 102 - v6 or 142
            elseif v6 >= 2 and v6 <= 5 then
                v7 = "Upgrade"
                v6 = v3 == "Upgrade" and v6 + 40 or v6 + 30
            elseif v6 >= 23 and v6 <= 24 then
                v7.Time = v14
                v14 = v5
                v6 = v5 and 203 or 2400 / v6
            elseif v6 >= 25 and v6 <= 28 then
                v6, v7 = 105 - v6, v4.TargetMode
                v9.Target = v7
            elseif v6 >= 29 and v6 <= 30 then
                v6 = 1
                v14 = v4.Stats.Price
            elseif v6 >= 91 and v6 <= 92 then
                v6 = v13 and 327 - v6 or 85
            elseif v6 >= 93 and v6 <= 99 then
                v6, v7 = v6 + -22, v7(v14)
            elseif v6 >= 78 and v6 <= 89 then
                v7 = v4.CFrame
                v9 = v1._.typeof(v7)
                v7 = "CFrame"
                v6 = v9 ~= "CFrame" and 253 or 222
            elseif v6 >= 74 and v6 <= 77 then
                v14 = v12.Profile.Actions
                v1._.table.insert(v14, v9)
                v14 = v2[1][2]
                v16, v14, v11, v7 = "Recording: ", "Macro", v12.Profile, v14.SetStatus
                v7("Macro", "Recording: " .. #v11.Actions .. " confirmed actions")
                return
            elseif v6 >= 102 and v6 <= 118 then
                v6, v7 = v6 + 129, 0
            elseif v6 >= 119 and v6 <= 124 then
                v7.Wave = v14
                v7, v9 = "Place", v7
                v6 = v3 == "Place" and 249 or v6 + -114
            elseif v6 >= 126 and v6 <= 127 then
                v6 = v7 and v6 + -109 or 204 - v6
            elseif v6 >= 242 and v6 <= 248 then
                v6 = v13 and 125 or 128
            elseif v6 >= 240 and v6 <= 241 then
                v9.Cost = v7
                v14 = v9.Cost
                v7 = not v14
                v6 = v7 and 30607 / v6 or 134
            elseif v6 >= 204 and v6 <= 221 then
                v7 = {Kind = v3, Key = v13}
                v14 = v5
                v6 = v5 and 18720 / v6 or 202
            elseif v6 >= 199 and v6 <= 202 then
                v6 = v14 and 24 or 13736 / v6
            elseif v6 >= 222 and v6 <= 234 then
                v14, v6, v7 = 1, v6 + -14, v12.Counter
                v12.Counter = v7 + 1
                v7 = v12.Counter
                v7, v13, v9 = v4.Id, "T" .. v7, v12.Keys
                v9[v7] = v13
            elseif v6 >= 236 and v6 <= 239 then
                v6 = 171
                v7 = 0
            elseif v6 >= 128 and v6 <= 130 then
                v7 = v4.Id
                v9 = "Place"
                v13 = v12.Keys[v7]
                v6 = v3 == "Place" and 92 or 22
            elseif v6 >= 132 and v6 <= 141 then
                v14 = v9.Cost
                v6 = 127
                v7 = v14 <= 0
            elseif v6 >= 149 and v6 <= 171 then
                v6, v9.Cost = 77, v7
            elseif v6 >= 142 and v6 <= 145 then
                v6 = 101
                v7 = 0
            elseif v6 >= 147 and v6 <= 148 then
                v6, v7 = 26344 / v6, v5.Cost
            elseif v6 >= 172 and v6 <= 177 then
                v6, v14 = 271 - v6, v4.Stats
                v14 = v14.Price
            elseif v6 >= 179 and v6 <= 189 then
                v14 = v4.Stats
                v7 = v1._.tonumber
                v6 = v14 and 176 or 95
            elseif v6 >= 195 and v6 <= 198 then
                v2[1][2].SetStatus("Macro", "Unknown tower skipped; start recording before placing units")
                return
            elseif v6 >= 190 and v6 <= 194 then
                v6, v16 = 313 - v6, v2[1][2]
                v14 = v16.Wave()
            else
                return
            end
        end
    end
end
local function _w162(v1, v2)
    return function()
        return v2[2][2].Wave() >= v2[1][2]
    end
end
local function _w163(v1, v2)
    return function()
        local v3 = 52
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
        while true do
            if v3 == 11 then
                v3 = 250
                v7 = v11
            elseif v3 == 55 then
                v3 = v21 and 9295 / v3 or v3 + -5
            elseif v3 == 82 then
                v7 = v11:lower():find("lost", 1, true)
                v3 = v7 and 120 or 1640 / v3
            elseif v3 == 97 then
                v10 = "Health"
                v18 = v15
                v20 = v15:GetAttribute("Health")
                v3 = v20 and 255 or v3 + 94
            elseif v3 == 110 then
                v3 = 238
                v21 = 16776960
            elseif v3 == 169 then
                v3 = v21 and v3 + 69 or v3 + -59
            elseif v3 == 235 then
                v9 = v2[2][2]
                v15 = v15(v20(v18, v10 - v9.ReportStartedAt) + 0.5)
                v20 = v1._.string.format
                v18 = "%02d:%02d"
                v3 = 107
                v10 = v1._.math.floor(v15 / 60)
                v21 = v15 % 60
                v20 = v20("%02d:%02d", v10, v21)
                v19 = v20
            elseif v3 <= 10 then
                v3 = 72
                v5 = v19
            elseif v3 >= 12 and v3 <= 20 then
                v3 = v7 and 270 - v3 or 31 - v3
            elseif v3 >= 21 and v3 <= 50 then
                v9 = "Defeat"
                v21 = v7 == "Defeat"
                v3 = v21 and 207 - v3 or 219 - v3
            elseif v3 >= 51 and v3 <= 52 then
                v17 = v1:sd({v2[2]})
                v11 = v17("Content", "Match ended")
                v7 = v11:lower():find("won", 1, true)
                v3 = v7 and 136 or 59
            elseif v3 >= 60 and v3 <= 70 then
                v16.value = v14 .. v5
                v16.inline = true
                v13 = {}
                v14 = "Match Rewards"
                v12 = v16
                v13.name = "Match Rewards"
                v5 = "💵 Coins: "
                v6 = v1._.tostring
                v8 = v2[2][2].ResultCoins()
                v3 = v8 and 12530 / v3 or 174
            elseif v3 >= 56 and v3 <= 59 then
                v3 = v7 and 20 or 4838 / v3
            elseif v3 >= 53 and v3 <= 54 then
                v3, v6 = 4860 / v3, "Unavailable"
            elseif v3 >= 71 and v3 <= 81 then
                v3 = v5 and 142 - v3 or 11808 / v3
            elseif v3 >= 83 and v3 <= 96 then
                v5 = v1.h(v5(v6))
                v12.value = v16(v13, v14, v1.i(v5))
                v12.inline = false
                v13 = "Clear Time"
                v16 = {}
                v4 = v12
                v16.name = "Clear Time"
                v14 = "⏱️ "
                v6 = ""
                v5 = v19 ~= ""
                v3 = v5 and 8 or v3 + -18
            elseif v3 >= 98 and v3 <= 109 then
                v20 = v2[4][2]
                v18 = "Game/Base"
                v15 = v2[2][2].Path(v20, "Game/Base")
                v20 = v15
                v3 = v15 and v3 + -10 or 255
            elseif v3 >= 111 and v3 <= 120 then
                v3, v7 = 140 - v3, "Defeat"
            elseif v3 >= 241 and v3 <= 250 then
                v20 = v2[2][2]
                v19 = ""
                v15 = v20.ReportStartedAt
                v3 = v15 and 229 or 26750 / v3
            elseif v3 >= 192 and v3 <= 234 then
                v20 = v1._.math
                v15 = v20.floor
                v20, v21, v18 = v20.max, v2[2][2], 0
                v10 = v21.ReportEndedAt
                v3 = v10 and 53815 / v3 or 152
            elseif v3 >= 236 and v3 <= 238 then
                v10.Color = v21
                v12 = {}
                v9 = {}
                v12.name = "Player Info"
                v13 = v1._.string
                v5, v13, v16 = v2[3][2], "👤 Name: ||%s||\n❤️ Base HP: %s", v13.format
                v14, v6, v5 = v5.Name, v20, v1._.tostring
                v3 = v6 and 328 - v3 or 54
            elseif v3 >= 239 and v3 <= 240 then
                v3 = 55
                v21 = 65280
            elseif v3 >= 180 and v3 <= 191 then
                v18 = v15
                v10 = "HP"
                v3 = 255
                v20 = v15:GetAttribute("HP")
            elseif v3 >= 170 and v3 <= 174 then
                v3 = 179
                v8 = "Unavailable"
            elseif v3 >= 175 and v3 <= 179 then
                v13.value = v5 .. v6(v8)
                v13.inline = false
                v9[3], v9[2], v9[1] = v13, v12, v4
                v10.Fields = v9
                return v10
            elseif v3 >= 121 and v3 <= 136 then
                v3 = 59
                v7 = "Victory"
            elseif v3 >= 137 and v3 <= 152 then
                v21 = v1._.os
                v3, v10 = v3 + 83, v21.clock()
            elseif v3 >= 153 and v3 <= 157 then
                v3 = 169
                v21 = 16711680
            elseif v3 >= 158 and v3 <= 168 then
                v3, v5 = v3 + -94, "Unavailable"
            else
                v10 = {Title = "Camera TD Match Report"}
                v21 = v1._.string.format
                v13 = ""
                v4 = v17("Map", v2[1][2].Map):gsub("^Map:%s*", "")
                v12 = v17("Mode", v2[1][2].Difficulty):gsub("^Mode:%s*", "")
                v16 = v7
                v10.Description = v21("**Stage:** %s\n**Mode:** %s\n**Result:** %s", v4, v12, v7)
                v9 = "Victory"
                v21 = v7 == "Victory"
                v3 = v21 and 240 or 310 - v3
            end
        end
    end
end
local function _w164(v1, v2)
    return function()
        local v3 = v2[2][2].UI
        local v4 = {Title = "Camera TD"}
        local v5 = v2[1][2]
        v4.Content = v1._.tostring(v5)
        v4.Duration = 5
        v3:Notify(v4)
    end
end
local function _w166(v1, v2)
    return function()
        local v3 = {}
        local v4 = v2[2][2].SendWebhook
        local v5 = {name = "Player", value = "||" .. v2[3][2].Name .. "||", inline = true}
        local v6 = {name = "Match Players"}
        v6.value = v1._.tostring(v2[1][2])
        v6.inline = true
        local v7 = {name = "Return Lobby"}
        local v8 = v2[2][2].LobbyId
        v7.value = v1._.tostring(v8)
        v7.inline = false
        v3[2], v3[1], v3[3] = v6, v5, v7
        local v9
        v4, v9 = v4("Camera TD Solo Queue Alert", "Players was set to 1, but another player entered the match. Returning this account to lobby.", 16753920, v3)
        local v10 = v2[2][2]
        v10.SoloWebhookPending = false
        local v11
        v3, v10, v11 = v9, v10.WebhookStatus, v4
        v10(v11, v3)
    end
end
getfenv()
local function _w168(v1, v2)
    return function()
        local v3 = 78
        local v4, v5, disconnect, v6, v7, v8, v9
        repeat
            if v3 == 66 then
                v3 = v5 and v3 + 44 or 192
            elseif v3 == 134 then
                v5, v3, v9 = v1._.pcall, 11792 / v3, v1:rd({v2[2]})
                v5(v9)
            elseif v3 == 141 then
                v3, v4 = 173 - v3, v2[2][2].Ring
                v4:Destroy()
            elseif v3 == 162 then
                v3 = 43
                v8:Disconnect()
            elseif v3 == 163 then
                v4 = v2[2][2]
                v4.Serial = v4.Serial + 1
                v4.Playing = false
                v5 = v2[2][2].Connections
                v4, v5, v9 = v1._.ipairs(v5)
                v4, v5, v9 = v1.g(v4, v5, v9)
                v7, v8 = v4(v5, v9)
                v9 = v7
                v3 = v7 == nil and 176 or 36675 / v3
            elseif v3 == 175 then
                v4 = v1._.ipairs
                v8 = v2[2][2]
                v5 = v8.Auto.MapConnections
                v3 = v5 and 348 - v3 or 43050 / v3
            elseif v3 == 176 then
                v5 = v2[2][2]
                v4 = v5.Auto
                v3 = v4 and 175 or 244
            elseif v3 == 226 then
                v2[2][2].Close.Enabled = false
                v5 = v2[2][2]
                v4 = v5.Close
                v8 = v5
                v3, v7, v9 = 389 - v3, 1, v5.Close.ClickSerial
                v5 = v9 + 1
                v4.ClickSerial = v5
            elseif v3 >= 177 and v3 <= 183 then
                return
            elseif v3 >= 184 and v3 <= 192 then
                v9 = v2[2][2]
                v5 = v9.Window
                v3 = v5 and 326 - v3 or v3 + -104
            elseif v3 >= 164 and v3 <= 174 then
                v4, v5, v9 = v4(v5)
                v4, v5, v9 = v1.g(v4, v5, v9)
                v7, v8 = v4(v5, v9)
                v9 = v7
                v3 = v7 == nil and 244 or 162
            elseif v3 >= 230 and v3 <= 232 then
                v5 = v2[2][2]
                v5.CancelJoinWalk()
                v5, v4 = nil, v5
                v4.JoinWalkExit = nil
                v4, v5 = v4.SetHideName, false
                v4(false)
                v5 = v2[2][2]
                v4 = v5.Rejoin
                v3 = v4 and v3 + -72 or 21
            elseif v3 >= 227 and v3 <= 229 then
                v5 = v2[2][2]
                v4 = v5.StopRecord
                v3 = v3 + 3
                v4()
            elseif v3 >= 193 and v3 <= 225 then
                v6, v3, disconnect = v8, 365 - v3, v8.Disconnect
                disconnect(v6)
            elseif v3 >= 233 and v3 <= 244 then
                v2[2][2].FPS(false)
                v5 = v2[2][2]
                v4 = v5.Ring
                v3 = v4 and v3 + -103 or 7808 / v3
            elseif v3 >= 25 and v3 <= 32 then
                v4 = v2[1][2].__CameraTDRecorderRouter
                v5 = v4
                v3 = v4 and 15 or 66
            elseif v3 >= 16 and v3 <= 21 then
                v4 = v2[2][2]
                v4.Running = false
                v5 = v4
                v4 = v4.Close
                v3 = v4 and 226 or v3 + 142
            elseif v3 <= 15 then
                v9 = v4.Hub
                v3 = 66
                v5 = v9 == v2[2][2]
            elseif v3 >= 22 and v3 <= 24 then
                v5 = v2[2][2]
                v4 = v5.Recording
                v3 = v4 and 229 or 232
            elseif v3 >= 33 and v3 <= 65 then
                v7, v8 = v4(v5, v9)
                v9 = v7
                v3 = v7 == nil and 244 or 6966 / v3
            elseif v3 >= 67 and v3 <= 78 then
                v9 = v2[2][2]
                v5 = v9.Running
                v4 = not v5
                v3 = v4 and 183 or 24
            elseif v3 >= 135 and v3 <= 140 then
                v7, v8 = v4(v5, v9)
                v9 = v7
                v3 = v7 == nil and 176 or 225
            elseif v3 >= 79 and v3 <= 88 then
                return
            elseif v3 >= 89 and v3 <= 133 then
                v3, v5 = v3 + 82, nil
                v4.Hub = nil
            elseif v3 >= 142 and v3 <= 161 then
                v9 = v2[2][2]
                v5 = v9.Rejoin
                v3, v4 = 3360 / v3, v5.Stop
                v4()
            else
                v3, v5 = v3 + -73, {}
            end
        until false
    end
end
local function _w170(v1)
    return function(v2, v3, v4)
        local v5 = v1._.Vector3
        local v6 = v2 - v3
        local v7, v8, v9
        v5, v7, v8, v9 = v6.X, v5.new, v6.Z, 0
        local v10 = v7(v5, 0, v8).Magnitude <= v4
        local v11
        if v10 then
            v7 = v1._.math
            v7, v11 = v6.Y, v7.abs
            v11 = v11(v7)
            return v11 <= 6
        else
            return v10
        end
    end
end
local function _w171(v1, v2)
    return function()
        local v3 = 197
        local v4, v5, v6, v7, v8, v9, match, v10, v11, v12, v13
        while true do
            if v3 == 80 then
                v3 = v12 and v3 + -6 or 18240 / v3
            elseif v3 == 209 then
                v3, v10 = 16720 / v3, "Settings"
                v12 = match ~= "Settings"
            elseif v3 >= 189 and v3 <= 197 then
                v13 = {}
                v7 = v2[1][2]
                v8 = v7.FS
                v3 = v8 and 245 or 114
            elseif v3 >= 156 and v3 <= 188 then
                v3 = 230
                v8 = v13
            elseif v3 >= 115 and v3 <= 155 then
                match = v9:match("([^/\\]+)%.json$")
                v12 = match
                v3 = match and 364 - v3 or 235 - v3
            elseif v3 <= 11 then
                v6, v4, v11 = v1._.ipairs(v7)
                v6, v4, v11 = v1.g(v6, v4, v11)
                v5, v9 = v6(v4, v11)
                v11 = v5
                v3 = v5 == nil and 114 or 155
            elseif v3 >= 12 and v3 <= 79 then
                v12 = v1._.table.insert
                v3 = 228
                v12(v13, match)
            elseif v3 >= 81 and v3 <= 114 then
                v1._.table.sort(v13)
                v6 = 0
                v7 = #v13
                v8 = v7 > 0
                v3 = v8 and 188 or 230
            elseif v3 >= 231 and v3 <= 245 then
                v7 = v1._.listfiles
                v6 = v2[1][2].Folder
                v8, v7 = v1._.pcall(v7, v6)
                v3 = v8 and 11 or 114
            elseif v3 >= 210 and v3 <= 228 then
                v5, v9 = v6(v4, v11)
                v11 = v5
                v3 = v5 == nil and 114 or 383 - v3
            elseif v3 >= 198 and v3 <= 208 then
                return v8
            elseif v3 >= 229 and v3 <= 230 then
                v3 = v8 and 208 or 246
            else
                v7 = {}
                v6 = "(none)"
                v3, v7[1] = 208, "(none)"
                v8 = v7
            end
        end
    end
end
local function _w172(v1, v2)
    return function(v3, v4, v5, v6)
        local v7 = 178
        local v8, v9, v10, v11, v12, v13, v14, v15, v16
        repeat
            if v7 == 16 then
                v10 = v2[1][2].GameClock() - v4
                v9 = v3.Time
                v12 = v1._.tonumber(v9)
                v7 = v12 and v7 + 185 or 176
            elseif v7 == 33 then
                v7 = v9 and 5148 / v7 or 181
            elseif v7 == 61 then
                v11 = v10 >= v12
                v7 = v11 and 235 or 5612 / v7
            elseif v7 == 92 then
                return v11
            elseif v7 == 93 then
                v11 = v3.Kind
                v10 = "Skip"
                v7 = v11 == "Skip" and 9486 / v7 or v7 + 154
            elseif v7 == 98 then
                v9 = v3.WaveTime
                v12 = v1._.tonumber(v9)
                v7 = v12 and 322 - v7 or 5
            elseif v7 == 121 then
                v7, v14 = 269 - v7, 0
            elseif v7 == 148 then
                v13 = v13 - v14
                v9 = v9(v8, v13)
                v14 = v2[1][2].GameClock()
                v16 = v6.CompletedAt
                v7 = v16 and 41 or 228
            elseif v7 == 181 then
                v13 = v2[1][2].GameClock()
                v14, v13, v8 = v3.Time, v1._.tonumber, v13 - v4
                v13 = v13(v14)
                v7 = v13 and 426 - v7 or 390 - v7
            elseif v7 == 195 then
                v7 = 95
                v9 = v11
                v12 = v2[1][2].SkipVoteComplete(v9)
            elseif v7 == 201 then
                return v10 >= v12
            elseif v7 == 224 then
                v7, v9 = 1120 / v7, v2[1][2]
                v12 = v9.WaveStartedGame
            elseif v7 == 235 then
                v7 = 92
                v11 = v15
            elseif v7 == 239 then
                v13 = v2[1][2]
                v9, v13 = v13.GameClock() - v13.WaveStartedGame, v1._.math
                v16, v8, v14, v13 = v3.WaveTime, v13.max, v1._.tonumber, 0
                v14 = table.pack(v14(v16))
                v8 = v8(0, table.unpack(v14, 1, v14.n))
                return v9 >= v8
            elseif v7 >= 178 and v7 <= 180 then
                v11 = v2[1][2].Cash()
                v12 = v3.Cost
                v10 = v1._.tonumber(v12)
                v7 = v10 and 19 or 236
            elseif v7 >= 182 and v7 <= 184 then
                v13, v7, v8 = v12.Wave, v7 + -151, v1._.tonumber
                v8 = v8(v13)
                v9 = v8 == v11
            elseif v7 >= 171 and v7 <= 174 then
                v9 = v12
                v7 = v12 and 184 or v7 + -141
            elseif v7 >= 169 and v7 <= 170 then
                return v15
            elseif v7 >= 175 and v7 <= 177 then
                v7, v12 = 35376 / v7, 0
            elseif v7 >= 196 and v7 <= 200 then
                v7 = 166
                v11 = 0
            elseif v7 >= 185 and v7 <= 186 then
                v7, v12 = 32364 / v7, v6.Previous
            elseif v7 >= 187 and v7 <= 194 then
                v11 = "Money"
                v7 = v5 == "Money" and 357 - v7 or 280 - v7
            elseif v7 >= 225 and v7 <= 226 then
                return false
            elseif v7 >= 227 and v7 <= 234 then
                v7 = 41
                v16 = v4
            elseif v7 >= 202 and v7 <= 223 then
                v7, v13 = 454 - v7, 0
            elseif v7 >= 240 and v7 <= 245 then
                return v8 >= v13
            elseif v7 >= 236 and v7 <= 238 then
                v7, v10 = 255 - v7, 0
            elseif v7 >= 122 and v7 <= 124 then
                v7 = v10 < v11 and v7 + 102 or 98
            elseif v7 >= 125 and v7 <= 147 then
                v12 = v6
                v7 = v6 and 186 or 174
            elseif v7 >= 99 and v7 <= 120 then
                v10 = v3.Wave
                v11 = v1._.tonumber(v10)
                v7 = v11 and 166 or v7 + 97
            elseif v7 >= 155 and v7 <= 156 then
                v8 = v1._.math
                v8, v14, v9, v13 = 0, v3.Time, v8.max, v1._.tonumber
                v13 = v13(v14)
                v7 = v13 and 324 - v7 or 55
            elseif v7 >= 149 and v7 <= 154 then
                v7, v12 = 215 - v7, 0
            elseif v7 >= 157 and v7 <= 166 then
                v10 = v2[1][2].Wave()
                v12 = v10 > v11
                v7 = v12 and 95 or 11620 / v7
            elseif v7 >= 167 and v7 <= 168 then
                v16 = v12.Time
                v14 = v1._.tonumber(v16)
                v7 = v14 and 316 - v7 or 121
            elseif v7 >= 94 and v7 <= 95 then
                v7 = v12 and 97 or 124
            elseif v7 >= 96 and v7 <= 97 then
                return true
            elseif v7 >= 62 and v7 <= 91 then
                v12 = v10 == v11
                v7 = v12 and 195 or v7 + 25
            elseif v7 >= 42 and v7 <= 60 then
                v7 = 168
                v13 = 0
            elseif v7 >= 34 and v7 <= 41 then
                return v14 - v16 >= v9
            elseif v7 <= 15 then
                v7 = v12 and 239 or 147
            elseif v7 >= 17 and v7 <= 32 then
                v11, v15 = "Time", v11 >= v10
                v7 = v5 == "Time" and 35 - v7 or 206 - v7
            else
                v10 = v2[1][2].Wave()
                v9 = v3.Wave
                v12 = v1._.tonumber(v9)
                v7 = v12 and v7 + -186 or 401 - v7
            end
        until false
    end
end
local function _w173(v1, v2)
    return function(v3)
        v2[2][2].Map = v1._.tostring(v3)
        local v4 = v2[1][2]
        v4.CancelJoinWalk()
        local v5
        v5, v4 = v4, nil
        v5.JoinWalkExit = nil
        v5 = v5.Elevator
        if v5 then
            v2[1][2].LeaveElevator()
        end
        v5 = v2[1][2]
        v5.LobbyAttempt = nil
        v5.SaveSettings()
    end
end
local function _w174(v1, v2)
    return function(v3)
        local v4, v5, v6, v7
        if v2[1][2].ChangingToggle then
            return
        elseif v3 then
            if v2[1][2].Playing then
                v2[1][2].StopPlayback("Stopped to begin recording")
            end
            v5 = v2[1][2]
            v5.StartRecord()
            v4, v5, v6 = v5.SetToggle, "Record", v2[1][2]
            v6, v7 = nil, v6.Recording
            v4("Record", v7 ~= nil)
            v2[1][2].SaveSettings()
            return
        else
            v2[1][2].StopRecord()
            v2[1][2].SaveSettings()
            return
        end
    end
end
local function _w175(v1, v2)
    return function()
        if not v2[2][2].SaveQueued then
            v2[2][2].SaveQueued = true
            v1._.task.delay(0.3, v1:ld({v2[1], v2[2]}))
        end
    end
end
local function _w176(v1, v2)
    return function()
        local v3 = v2[1][2].Speed.Value
        return v2[2][2].AutoDelay / v3
    end
end
local function _w177(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        if v3 == "x10" then
            v4.SummonAmount = 10
        else
            v4.SummonAmount = 1
        end
        v2[1][2].SaveSettings()
    end
end
local function _w178(v1, v2)
    return function(v3)
        v2[2][2].WebhookEnabled = v3 == true
        v2[1][2].SaveSettings()
    end
end
local function _w179(v1, v2, v3)
    v1.Re[v3] = v2
    return v1.Re[v3]
end
local function _w180(v1, v2)
    return function(v3)
        local v4 = 90
        local v5, v6, v7, v8, v9, v10, v11, v12
        while true do
            if v4 == 90 then
                v5 = v1._.type(v3)
                v10 = "table"
                v4 = v5 ~= "table" and 132 or 54
            elseif v4 == 172 then
                return
            elseif v4 >= 48 and v4 <= 54 then
                v5, v10, v7 = v1._.pairs(v3)
                v5, v10, v7 = v1.g(v5, v10, v7)
                v9, v11 = v5(v10, v7)
                v7 = v9
                v4 = v9 == nil and 172 or 177
            elseif v4 >= 55 and v4 <= 89 then
                v4 = v12 and 338 - v4 or v4 + -40
            elseif v4 >= 11 and v4 <= 47 then
                v4 = v12 and v4 + -40 or 217 - v4
            elseif v4 <= 7 then
                v12 = v2[1][2]
                v12.ReplicaId = v9
                v12, v6 = v12.Inventory, v11[3]
                v4 = 170
                v12(v6)
            elseif v4 >= 8 and v4 <= 10 then
                v4 = 87
                v12 = v1._.type(v11[2]) == "table"
            elseif v4 >= 173 and v4 <= 177 then
                v12 = v1._.type(v11) == "table"
                v4 = v12 and 187 - v4 or 87
            elseif v4 >= 133 and v4 <= 171 then
                v9, v11 = v5(v10, v7)
                v7 = v9
                v4 = v9 == nil and 172 or 30090 / v4
            elseif v4 >= 91 and v4 <= 132 then
                return
            else
                v8 = v11[2].UserId
                v6 = v1._.tonumber(v8)
                v4, v8 = v4 + -204, v2[2][2].UserId
                v12 = v6 == v8
            end
        end
    end
end
local function _w181(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5 = v4.CircleCooldowns
        if v5 then
            v4.CircleCooldowns = v5
        else
            v4.CircleCooldowns = {}
        end
        local v6 = v1._.os
        v5 = v3.Name
        v2[2][2].CircleCooldowns[v5] = v6.clock() + 15
        local v7 = v3.Name
        v2[2][2].Invoke("ElevatorLeave", v7)
        v4 = v3:FindFirstChild("Pad")
        v5 = v4
        if v4 then
            if v4:IsA("Model") then
                v5 = v4:GetPivot().Position or v4.Position
            else
                v5 = v4.Position
            end
        end
        v2[2][2].CancelJoinWalk()
        v7 = v5
        local v8, v9, v10, v11
        if v5 then
            if v2[3][2].Character then
                if v2[1][2].JoinMethod == "Walk" then
                    v7 = v2[2][2]
                    v6 = {}
                    v6.Position = v5 + v1._.Vector3.new(24, 0, 0)
                    v6.Id = v3.Name
                    v7.JoinWalkExit = v6
                else
                    v7 = v2[3][2].Character
                    v6 = v1._.CFrame.new
                    v10 = v5 + v1._.Vector3.new(24, 3, 0)
                    v6 = table.pack(v6(v10))
                    v7:PivotTo(table.unpack(v6, 1, v6.n))
                end
            end
            v7 = v2[2][2]
            v7.Elevator = nil
            v7.IsHost = false
            v7.StartRequested = nil
            v7.LobbyAttempt = nil
            v8, v7, v11, v6, v9 = v3.Name, v7.SetStatus, "Lobby", "Another player in ", "; switching to an empty circle"
            v7("Lobby", "Another player in " .. v8 .. "; switching to an empty circle")
            return
        elseif v7 then
            if v2[1][2].JoinMethod == "Walk" then
                v7 = v2[2][2]
                v6 = {}
                v6.Position = v5 + v1._.Vector3.new(24, 0, 0)
                v6.Id = v3.Name
                v7.JoinWalkExit = v6
            else
                v7 = v2[3][2].Character
                v6 = v1._.CFrame.new
                v10 = v5 + v1._.Vector3.new(24, 3, 0)
                v6 = table.pack(v6(v10))
                v7:PivotTo(table.unpack(v6, 1, v6.n))
            end
            v7 = v2[2][2]
            v7.Elevator = nil
            v7.IsHost = false
            v7.StartRequested = nil
            v7.LobbyAttempt = nil
            v8, v7, v11, v6, v9 = v3.Name, v7.SetStatus, "Lobby", "Another player in ", "; switching to an empty circle"
            v7("Lobby", "Another player in " .. v8 .. "; switching to an empty circle")
            return
        else
            v7 = v2[2][2]
            v7.Elevator = nil
            v7.IsHost = false
            v7.StartRequested = nil
            v7.LobbyAttempt = nil
            v8, v7, v11, v6, v9 = v3.Name, v7.SetStatus, "Lobby", "Another player in ", "; switching to an empty circle"
            v7("Lobby", "Another player in " .. v8 .. "; switching to an empty circle")
            return
        end
    end
end
local function _w182(v1)
    return function(v2, v3)
        local v4 = v3.Score
        local v5
        if v2.Score ~= v4 then
            v5 = v3.Score
            return v2.Score < v5
        else
            v4 = v3.Position.X
            if v2.Position.X ~= v4 then
                v5 = v3.Position.X
                return v2.Position.X < v5
            else
                v5 = v3.Position.Z
                return v2.Position.Z < v5
            end
        end
    end
end
local function _w183(v1)
    return function(v2, v3)
        local v4 = v3.Name
        return v2.Name < v4
    end
end
local function _w184(v1, v2)
    return function(v3, v4)
        v4 = {[1] = 2, [2] = v4}
        v4[3] = v4
        local v5, v6
        if v2[1][2].Status[v3] == v4[2] then
            while true do
            end
        else
            v6 = v2[1][2]
            v6.Status[v3] = v4[2]
            v5 = {[1] = 2, [2] = v6.Widgets[v3]}
            v5[3] = v5
            if v5[2] then
                v1._.pcall(v1:Oc({v4, v5}))
            end
            return
        end
    end
end
local function _w185(v1, v2, v3, v4, v5)
    v1.Ue[v5] = bit32.bxor(v3, 61632) + (bit32.band(v2, bit32.bxor(v3, 61632)) * bit32.bor(v2, bit32.bxor(v3, 61632)) + (bit32.band(v4, bit32.bnot(v2)) * bit32.band(v2, bit32.bnot(v4)) + (bit32.band(bit32.bxor(v3, 61632), bit32.bnot(v2)) * bit32.band(v2, bit32.bnot(bit32.bxor(v3, 61632))) + (bit32.bor(v4, v2) * bit32.band(v2, v4) + bit32.band(bit32.bnot(v4), bit32.band(bit32.bnot(bit32.bxor(bit32.band(bit32.bxor(v3, 61632), 4294967295), bit32.bor(bit32.bxor(v3, 61632), v2))), bit32.band(bit32.bxor(v3, 61632), v2))) * bit32.band(bit32.bxor(bit32.bor(4294967295, v2), bit32.bnot(bit32.bxor(v3, 61632))), bit32.bor(bit32.bxor(v3, 61632), v2))) + -(bit32.band(bit32.bnot(bit32.bxor(bit32.bor(bit32.bxor(v3, 61632), v2), bit32.band(4294967295, bit32.bxor(v3, 61632)))), bit32.band(bit32.bxor(v3, 61632), v2)) * bit32.band(bit32.bxor(bit32.bor(v2, 4294967295), bit32.bnot(bit32.bxor(v3, 61632))), bit32.bor(bit32.bxor(v3, 61632), v2))) + -bit32.bnot(bit32.bnot(bit32.bxor(v3, 61632))))) + bit32.band(bit32.band(bit32.bnot(bit32.bxor(bit32.bor(bit32.bxor(v3, 61632), v2), bit32.band(4294967295, bit32.bxor(v3, 61632)))), bit32.band(bit32.bxor(v3, 61632), v2)), v4) * bit32.band(bit32.bxor(bit32.bnot(bit32.bxor(v3, 61632)), bit32.bor(v2, 4294967295)), bit32.bor(bit32.bxor(v3, 61632), v2)))
    return v1.Ue[v5]
end
local function _w186(v1)
    return function(...)
        local v2 = 98
        local v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
        repeat
            if v2 == 2 then
                v2 = 95
                v12 = v1._.os.clock()
                v6 = v19[2].__CameraTDBoot
                v15 = v6.At
                v13, v12 = v12 - v15, 30
                v11 = v13 < 30
            elseif v2 == 3 then
                v16 = {[1] = 2, [2] = v16}
                v16[3] = v16
                v14 = {
                    [1] = 2,
                    [2] = {
                        Map = "Toilet City",
                        Players = 1,
                        AutoLobby = false,
                        JoinMethod = "TP",
                        StartNow = true,
                        SummonAmount = 1,
                        SummonDelay = 1,
                        AutoSummon = false,
                        Difficulty = "Easy",
                        AutoDifficulty = true,
                        AutoSkip = false,
                        StopAutoSkipAt = "",
                        AutoSpeed = false,
                        SpeedScale = 1,
                        Modifiers = {},
                        EndAction = "None",
                        Profile = "",
                        NewProfileName = "",
                        AutoPlayback = false,
                        PlaybackMode = "Hybrid",
                        ActionTimeout = 120,
                        AutoExecute = true,
                        AutoPlace = false,
                        AutoUpgrade = false,
                        AutoDelay = 0.5,
                        PlacementRange = 0,
                        ShowRange = false,
                        AntiAFK = true,
                        AutoClaimQuest = false,
                        ClosePlacement = false,
                        FPSBoost = false,
                        HideName = false,
                        WebhookURL = "",
                        WebhookEnabled = false,
                        WebhookMatchEnd = true,
                    },
                }
                v14[3] = v14
                v11[2].Settings = v14[2]
                v7 = v11[2].Folder .. "/Settings"
                v11[2].SettingsFolder = v7
                v18 = v16[2].Name
                v3 = "/"
                v5 = v18 .. ".json"
                v7 = v11[2].SettingsFolder .. "/" .. v5
                v11[2].SettingsFile = v7
                v20 = v1._.readfile
                v17 = v1._.type(v20)
                v20 = "function"
                v7 = v17 == "function"
                v2 = v7 and 124 or 174
            elseif v2 == 4 then
                v2 = 172
                v17 = "Easy"
                v14[2].Difficulty = "Easy"
            elseif v2 == 16 then
                v2 = 147
                v10 = v7[v5]
                v14[2][v5] = v10
            elseif v2 == 29 then
                v17 = "Hybrid"
                v2, v14[2].PlaybackMode = 206, "Hybrid"
            elseif v2 == 59 then
                v3 = v1._.os
                v17 = {}
                v17.StartedAt = v3.clock()
                v11[2].LoadTimes = v17
                v7 = v3.clock()
                v4[2].ProfileReady = v7
                v7 = v1:A({v11})
                v11[2].LoadWindUI = v7
                v7, v17 = v1._.pcall(v1:Jb({v14, v4, v11}))
                v20 = v11[2].LoadTimes
                v5 = v3.clock()
                v18 = v11[2].LoadTimes.StartedAt
                v20.UISeconds = v5 - v18
                v20 = v1._.os.clock()
                v4[2].UIControlsReady = v20
                v3 = false
                v19[2].__CameraTDBoot.Loading = false
                v20 = not v7
                v2 = v20 and 238 - v2 or 129
            elseif v2 == 80 then
                v17 = 1
                v2, v14[2].SpeedScale = 119, 1
            elseif v2 == 89 then
                v7 = v1:Ua({v11})
                v11[2].Connect = v7
                v7 = v1:X()
                v11[2].Path = v7
                v7 = v1:Nb({v11})
                v11[2].Notify = v7
                v7 = v1:La({v11})
                v11[2].SetStatus = v7
                v7 = v1:C()
                v11[2].SafeName = v7
                v7 = v1:r({v11})
                v11[2].File = v7
                v7 = v1:x({v6, v11})
                v11[2].Read = v7
                v7 = v1:ka({v6, v11})
                v11[2].Write = v7
                v7 = v1:wa({v16, v11})
                v11[2].LoadAccountSettings = v7
                v7 = v11[2].LoadAccountSettings()
                v2 = v7 and 186 - v2 or 280 - v2
            elseif v2 == 98 then
                v4 = v1._.game:IsLoaded()
                v19 = not v4
                v2 = v19 and 167 or 143
            elseif v2 == 99 then
                v2, v17 = v2 + 145, 1
            elseif v2 == 119 then
                v3 = "^%s*(.-)%s*$"
                v17 = v14[2].WebhookURL:match("^%s*(.-)%s*$")
                v14[2].WebhookURL = v17
                v20 = v14[2].Profile
                v17 = v11[2].SafeName(v20)
                v14[2].Profile = v17
                v17 = v14[2].Profile:lower()
                v20 = "settings"
                v2 = v17 == "settings" and 320 - v2 or v2 + 68
            elseif v2 == 123 then
                v18 = v11[2].Notify
                v2 = 170
                v18("Auto Rejoin unavailable: " .. v1._.tostring(v5))
            elseif v2 == 127 then
                v20 = v14[2].PlaybackMode
                v2 = 65
                v3 = "Wave"
                v17 = v20 == "Wave"
            elseif v2 == 128 then
                v21 = v7[v5]
                v10 = v1._.type(v21)
                v21 = v1._.type(v18)
                v2 = v10 == v21 and 16 or 18816 / v2
            elseif v2 == 129 then
                v3 = v1._.task
                v5, v20, v3 = v1:xa({v11}), v3.delay, 0.5
                v20(0.5, v5)
                v11[2].SaveSettings()
                v5 = v11[2].BindHiddenNameCharacter
                v11[2].Connect(v16[2].CharacterAdded, v5)
                v3 = v14[2].HideName
                v11[2].SetHideName(v3)
                v20 = v1._.os.clock()
                v4[2].PrivacyReady = v20
                v5 = v1:Qa({v11, v14})
                v11[2].Connect(v16[2].Idled, v5)
                v3 = v15[2].DescendantAdded
                v5 = v1:B({v11, v14})
                v11[2].Connect(v3, v5)
                v3 = v9[2].DescendantAdded
                v11[2].Connect(v3, v1:cb({v11, v14}))
                v20 = v11[2].Connect
                v5 = v1:sb({v11})
                v20(v16[2].OnTeleport, v5)
                v20 = v1._.pcall(v1:rb({v11}))
                v3 = v14[2].FPSBoost
                v2 = v3 and 213 or v2 + -86
            elseif v2 == 140 then
                v17 = "None"
                v2, v14[2].EndAction = 2800 / v2, "None"
            elseif v2 == 141 then
                v2 = v17 and 244 or v2 + -42
            elseif v2 == 157 then
                v17 = v1._.type(v1._.isfolder)
                v20 = "function"
                v2 = 222
                v7 = v17 == "function"
            elseif v2 == 158 then
                v2 = v17 and 292 - v2 or 30810 / v2
            elseif v2 == 170 then
                v18 = v1._.os.clock()
                v4[2].RejoinReady = v18
                v1._.task.spawn(v1:yb({v11}))
                v1._.task.spawn(v1:Kb({v14, v11}))
                v10 = v1._.task
                v10, v18 = v1:q({v14, v11}), v10.spawn
                v18(v10)
                v10 = v1._.task
                v10, v18 = v1:Aa({v11}), v10.spawn
                v18(v10)
                v1._.task.spawn(v1:F({v11}))
                v1._.task.spawn(v1:s({v11}))
                v10 = v1._.task
                v10, v18 = v1:ub({v11}), v10.spawn
                v18(v10)
                v10 = v1._.task
                v10, v18 = v1:N({v11}), v10.spawn
                v18(v10)
                v11[2].Notify("Camera TD Hub loaded | RightShift to toggle")
                v18 = v1._.os.clock()
                v4[2].HubReady = v18
                return
            elseif v2 == 179 then
                v11[2].Notify("UI initialization failed: " .. v1._.tostring(v17))
                v11[2].Destroy()
                return
            elseif v2 == 209 then
                v17, v2, v20 = v1._.type, v2 + 14, v1._.listfiles
                v17 = v17(v20)
                v20 = "function"
                v7 = v17 == "function"
            elseif v2 == 213 then
                v3 = v11[2].FPS
                v5 = true
                v2 = 43
                v3(true)
            elseif v2 == 221 then
                v19 = {[1] = 2, [2] = v1._.getgenv()}
                v19[3] = v19
                v11 = {}
                v12 = v1._.os
                v13 = v12.clock()
                v11.CoreEntered = v13
                v4 = {[1] = 2, [2] = v11}
                v4[3] = v4
                v19[2].__CameraTDStartupMarks = v4[2]
                v11 = v19[2].__CameraTDBoot
                v2 = v11 and 240 or 10
            elseif v2 == 222 then
                v2 = v7 and 209 or 223
            elseif v2 == 223 then
                v11[2].FS = v7
                v7 = v11[2].FS
                v2 = v7 and 38 or 89
            elseif v2 == 238 then
                v2, v17 = 396 - v2, "Walk"
            elseif v2 == 242 then
                v16 = v13[2].PlayerAdded
                v16, v14 = v16.Wait, v16
                v2, v16 = 726 / v2, v16(v14)
            elseif v2 >= 39 and v2 <= 43 then
                v3 = v1._.os.clock()
                v4[2].FPSReady = v3
                v11[2].QueueTeleport()
                v11[2].SetClosePlacement(v14[2].ClosePlacement)
                v3 = v1._.os.clock()
                v4[2].PlacementReady = v3
                v3, v5 = v1._.pcall(v11[2].StartRejoin)
                v18 = not v3
                v2 = v18 and v2 + 80 or 170
            elseif v2 >= 36 and v2 <= 38 then
                v2, v17, v7 = v2 + 51, v1:Ta({v11}), v1._.pcall
                v7(v17)
            elseif v2 >= 34 and v2 <= 35 then
                v5 = {}
                v20 = v1._.table.find
                v18 = "Hybrid"
                v5[2], v5[3], v5[1] = "Time", "Money", "Hybrid"
                v5, v3 = v14[2].PlaybackMode, v5
                v20 = v20(v3, v5)
                v17 = not v20
                v2 = v17 and v2 + -6 or 206
            elseif v2 >= 44 and v2 <= 58 then
                v2, v17, v20 = 149 - v2, v1._.type, v1._.makefolder
                v17 = v17(v20)
                v20 = "function"
                v7 = v17 == "function"
            elseif v2 >= 60 and v2 <= 79 then
                v2 = v17 and 89 - v2 or 100 - v2
            elseif v2 >= 81 and v2 <= 83 then
                v7 = v1:l({v11})
                v11[2].GameClock = v7
                v7 = v1:Ya({v19, v11})
                v11[2].ConfirmSpeed = v7
                v7 = v1:ob({v11})
                v11[2].RecordTime = v7
                v7 = v1:t({v11})
                v11[2].SpeedNotice = v7
                v7 = v1:fa({v11, v14})
                v11[2].SpeedStep = v7
                v7 = v1:fb({v11, v14})
                v11[2].AutoInterval = v7
                v7 = v1:bb({v19, v11})
                v11[2].RoundStep = v7
                v7 = v1:ib({v14, v11})
                v11[2].EndMatchStep = v7
                v11[2].QuestClaims = {}
                v7 = v1:Ba({v16, v11})
                v11[2].ClaimableQuests = v7
                v7 = v1:u({v11, v14})
                v11[2].QuestStep = v7
                v7 = v1:ra({v16, v11})
                v11[2].GUI = v7
                v7 = v1:T()
                v11[2].Visible = v7
                v7 = v1:Wa({v11})
                v11[2].Final = v7
                v7 = v1:K({v11})
                v11[2].Wave = v7
                v7 = v1:U({v11})
                v11[2].Active = v7
                v7 = v1:Cb({v16, v11})
                v11[2].Cash = v7
                v7 = v1:la({v15})
                v11[2].CurrentMap = v7
                v7 = v1:db({v16})
                v11[2].Own = v7
                v7 = v1:P({v15, v11})
                v11[2].Position = v7
                v7 = v1:Ab({v11})
                v11[2].Owned = v7
                v7 = v1:ma({v11})
                v11[2].Learn = v7
                v7 = v1:Fa({v11})
                v11[2].Inventory = v7
                v7 = v1:ya({v15, v11, v16})
                v11[2].Hydrate = v7
                v7 = v1:G({v11})
                v11[2].Equipped = v7
                v7 = v1:L({v11})
                v11[2].ResolveUnit = v7
                v7 = v1:ga({v11})
                v11[2].Profiles = v7
                v7 = v1:O({v14, v11})
                v11[2].RefreshProfiles = v7
                v7 = v1:sa()
                v11[2].ValidProfile = v7
                v7 = v1:Ga({v11})
                v11[2].LearnProfileCosts = v7
                v7 = v1:aa({v11})
                v11[2].RecordAction = v7
                v7 = v1:E({v11})
                v11[2].RecordManualSkip = v7
                v7 = v1:Pa({v11})
                v11[2].Stamp = v7
                v7 = v1:Ha({v11})
                v11[2].TakeStamp = v7
                v7 = v1:vb({v11, v19})
                v11[2].InstallRecorderHook = v7
                v7 = v1:eb({v14, v11})
                v11[2].StartRecord = v7
                v7 = v1:Ma({v14, v11})
                v11[2].StopRecord = v7
                v7 = v1:mb({v11})
                v11[2].MergeTower = v7
                v7 = v1:Xa({v16, v11, v12})
                v11[2].BindRemotes = v7
                v7 = v1:ca({v11})
                v11[2].StopPlayback = v7
                v7 = v1:tb({v11})
                v11[2].WaitUntil = v7
                v7 = v1:Bb({v11})
                v11[2].WaitFunds = v7
                v7 = v1:Q({v11})
                v11[2].SendSkip = v7
                v7 = v1:D({v11})
                v11[2].SkipVoteComplete = v7
                v7 = v1:y({v11})
                v11[2].PlayRecordedSkip = v7
                v7 = v1:I({v11})
                v11[2].FindPlacement = v7
                v7 = v1:Ca({v11})
                v11[2].ActionReady = v7
                v7 = v1:Y({v11})
                v11[2].SetToggle = v7
                v7 = v1:hb({v14, v11})
                v11[2].StartPlayback = v7
                v7 = v1:Ra({v11, v14})
                v11[2].AutoPlaybackStep = v7
                v7 = v1:W({v12, v11})
                v11[2].ConfigUnit = v7
                v7 = v1:R({v11})
                v11[2].UnitCost = v7
                v7 = v1:v({v11})
                v11[2].UpgradeCost = v7
                v7 = v1:kb({v15})
                v11[2].Maps = v7
                v7 = v1:Db({v13, v16})
                v11[2].CircleOccupied = v7
                v7 = v1:S({v11})
                v11[2].CancelJoinWalk = v7
                v7 = v1:ha({v16, v11, v15, v14})
                v11[2].WalkToJoin = v7
                v7 = v1:M({v11, v14})
                v11[2].SetJoinMethod = v7
                v7 = v1:Da({v14, v11, v16})
                v11[2].AvoidCircle = v7
                v11[2].ModifierCatalog = {Hp_Mobs = "X2 Hp Mobs"}
                v7 = v1:da({v16, v11})
                v11[2].ModifierOptions = v7
                v7 = v1:na({v11})
                v11[2].RefreshModifiers = v7
                v7 = v1:H({v11})
                v11[2].ModifierSelection = v7
                v7 = v1:Ia({v14, v11})
                v11[2].ModifierLabels = v7
                v7 = v1:ja({v14, v11})
                v11[2].ApplyModifiers = v7
                v7 = v1:va({v15, v11, v16, v14})
                v11[2].LobbyStep = v7
                v7 = v1:Ib({v11})
                v11[2].LeaveElevator = v7
                v7 = v1:oa({v11, v14})
                v11[2].QueueTeleport = v7
                v7 = v1:Gb({v14, v15, v11})
                v11[2].PathTarget = v7
                v7 = v1:nb({v15, v11})
                v11[2].PlaceCandidate = v7
                v11[2].Auto = {
                    PlacePending = {},
                    UpgradePending = {},
                    SlotCooldowns = {},
                    TowerCooldowns = {},
                    Failures = {},
                    NextAt = 0,
                    PlaceTurn = true,
                }
                v7 = v1:jb({v11})
                v11[2].Auto.Busy = v7
                v7 = v1:Na({v11})
                v11[2].Auto.Budget = v7
                v7 = v1:Ka({v11})
                v11[2].Auto.Poll = v7
                v11[2].Auto.UpgradeStep = v1:qa({v11, v14})
                v11[2].Auto.PlaceStep = v1:ab({v11, v14})
                v7 = v1:Va({v14, v11})
                v11[2].AutoStep = v7
                v11[2].Skip = {NextAt = 0, LastWave = nil}
                v7 = v1:ta({v11, v14})
                v11[2].IsAutoSkipStopped = v7
                v7 = v1:n({v11, v14})
                v11[2].SkipStep = v7
                v7 = v1:Eb({v15, v14, v11})
                v11[2].Visual = v7
                v7 = v1:w({v11})
                v11[2].FPSSet = v7
                v7 = v1:J({v11})
                v11[2].FPSObject = v7
                v7 = v1:z({v14, v11, v15, v9})
                v11[2].FPS = v7
                v7 = v1:V()
                v11[2].ValidWebhook = v7
                v7 = v1:Hb()
                v11[2].RequestFunction = v7
                v7 = v1:wb({v6, v11})
                v11[2].SendDiscord = v7
                v7 = v1:ba({v11, v14})
                v11[2].SendWebhook = v7
                v7 = v1:Oa({v11})
                v11[2].WebhookStatus = v7
                v7 = v1:Lb({v11})
                v11[2].AccountCoins = v7
                v7 = v1:pb({v16, v11, v19})
                v11[2].ActivityLogger = v7
                v7 = v1:m({v13, v14, v16, v11})
                v11[2].SoloGuard = v7
                v7 = v1:Sa({v11})
                v11[2].ResultCoins = v7
                v7 = v1:zb({v14, v11, v16, v15})
                v11[2].MatchReport = v7
                v11[2].ReportRuntime = {}
                v7 = v1:o({v16, v11, v19, v14})
                v11[2].WebhookStep = v7
                v11[2].Close = {
                    Enabled = false,
                    Hitboxes = {},
                    SendSerial = 0,
                    ClickSerial = 0,
                    LastClickAt = -10,
                }
                v7 = v1:gb({v15, v11})
                v11[2].CloseRefresh = v7
                v7 = v1:Mb({v11})
                v11[2].CloseFilter = v7
                v7 = v1:ia({v11})
                v11[2].CloseClick = v7
                v7 = v1:Ja({v12, v11, v15, v19})
                v11[2].SetClosePlacement = v7
                v7 = v1._.setmetatable
                v20 = {}
                v3 = "k"
                v20.__mode = "k"
                v7 = v7({}, v20)
                v11[2].HiddenNameOriginal = v7
                v11[2].NameConnections = {}
                v7 = v1:p({v11})
                v11[2].RestoreHiddenName = v7
                v7 = v1:_b({v16, v11, v14})
                v11[2].HideOwnNameObject = v7
                v7 = v1:pa({v16})
                v11[2].IsOwnNameText = v7
                v7 = v1:qb({v14, v11})
                v11[2].WatchOwnNameLabel = v7
                v7 = v1:za({v16, v11, v14})
                v11[2].BindHiddenNameCharacter = v7
                v7 = v1:ua({v16, v14, v11})
                v11[2].SetHideName = v7
                v7 = v1:ea({v19, v11})
                v11[2].StartRejoin = v7
                v7 = v1:xb({v19, v11})
                v11[2].Destroy = v7
                v7 = v1._.os.clock()
                v4[2].SetupReady = v7
                v11[2].BindRemotes()
                v7 = v11[2].Read
                v17 = v11[2].File
                v20 = v14[2].Profile
                v17 = v1.h(v17(v20))
                v7 = v7(v1.i(v17))
                v20 = v7
                v17 = v11[2].ValidProfile(v7)
                v2 = v17 and 120 or 142 - v2
            elseif v2 >= 17 and v2 <= 23 then
                v20 = v1._.table.find
                v18 = "Easy"
                v5 = {}
                v5[1], v5[3], v5[2], v5[4] = "Easy", "Hard", "Normal", "Insane"
                v5, v3 = v14[2].Difficulty, v5
                v20 = v20(v3, v5)
                v17 = not v20
                v2 = v17 and 24 - v2 or 192 - v2
            elseif v2 >= 24 and v2 <= 28 then
                v17 = "Hybrid"
                v2, v14[2].PlaybackMode = 35, "Hybrid"
            elseif v2 >= 30 and v2 <= 33 then
                v20 = v1._.isfile
                v17 = v1._.type(v20)
                v20 = "function"
                v2, v7 = v2 + 197, v17 == "function"
            elseif v2 <= 1 then
                v2 = v11 and 170 - v2 or 175
            elseif v2 >= 5 and v2 <= 15 then
                v2 = v11 and 2 or 95
            elseif v2 >= 103 and v2 <= 118 then
                v2, v17, v20 = 9794 / v2, v11[2].Speed, v7.Value
                v17.Value = v20
            elseif v2 >= 100 and v2 <= 102 then
                v2 = v7 and 157 or 222
            elseif v2 >= 96 and v2 <= 97 then
                v20 = v14[2]
                v17, v20, v3 = v1._.pairs(v20)
                v17, v20, v3 = v1.g(v17, v20, v3)
                v5, v18 = v17(v20, v3)
                v3 = v5
                v2 = v5 == nil and v2 + 94 or 128
            elseif v2 >= 93 and v2 <= 95 then
                v2 = v11 and 137 or 315 - v2
            elseif v2 >= 90 and v2 <= 92 then
                v20 = v7.Server
                v18 = v1._.game.PlaceId
                v5 = v1._.tostring(v18)
                v8 = v1._.game.JobId
                v18 = "/" .. v1._.tostring(v8)
                v3 = v5 .. v18
                v2, v17 = v2 + 120, v20 == v3
            elseif v2 >= 84 and v2 <= 88 then
                return
            elseif v2 >= 120 and v2 <= 122 then
                v2, v11[2].LoadedProfile = 59, v7
                v17 = v11[2].LearnProfileCosts
                v20 = v7
                v17(v7)
            elseif v2 >= 124 and v2 <= 126 then
                v2 = 174
                v17 = v1._.type(v1._.writefile)
                v20 = "function"
                v7 = v17 == "function"
            elseif v2 >= 130 and v2 <= 134 then
                v14[2].JoinMethod = v17
                v20 = v1._.math
                v17 = v20.clamp
                v3, v20 = v14[2].Players, v20.floor
                v17 = v17(v20(v3), 1, 5)
                v14[2].Players = v17
                v20 = v1._.math
                v20, v17, v5, v3 = v14[2].PlacementRange, v20.clamp, 100, 0
                v17 = v17(v20, 0, 100)
                v14[2].PlacementRange = v17
                v20 = v1._.math
                v5, v20, v3, v17 = 600, v14[2].ActionTimeout, 10, v20.clamp
                v17 = v17(v20, 10, 600)
                v14[2].ActionTimeout = v17
                v5 = {}
                v18 = "None"
                v20 = v1._.table.find
                v5[1], v5[2], v5[3] = "None", "Replay", "Return"
                v3, v5 = v5, v14[2].EndAction
                v20 = v20(v3, v5)
                v17 = not v20
                v2 = v17 and v2 + 6 or v2 + -114
            elseif v2 >= 135 and v2 <= 139 then
                return
            elseif v2 >= 142 and v2 <= 146 then
                v19 = v1._.game.GameId
                v4 = 10762636904
                v2 = v19 ~= 10762636904 and 85 or 364 - v2
            elseif v2 >= 159 and v2 <= 167 then
                v19 = v1._.game.Loaded
                v19, v4 = v19.Wait, v19
                v2 = v2 + -24
                v19(v4)
            elseif v2 >= 168 and v2 <= 169 then
                v11 = v1._.pcall
                v13 = v19[2].CameraTDHub.Destroy
                v2 = 344 - v2
                v11(v13)
            elseif v2 >= 147 and v2 <= 156 then
                v5, v18 = v17(v20, v3)
                v3 = v5
                v2 = v5 == nil and 191 or 128
            elseif v2 >= 175 and v2 <= 178 then
                v11 = {
                    [1] = 2,
                    [2] = {
                        Running = true,
                        Connections = {},
                        Towers = {},
                        Units = {},
                        Pending = {},
                        Removed = {},
                        Serial = 0,
                        Status = {},
                        Widgets = {},
                        Folder = "CameraTD_Macros",
                        Next = {},
                        Bound = {},
                        FPSOriginal = {},
                        LobbyId = 132929771812494,
                        MatchId = 114068177100380,
                        Version = 1,
                    },
                }
                v11[3] = v11
                v19[2].CameraTDHub = v11[2]
                v11[2].LoggerURL = "https://discord.com/api/webhooks/1559278026607431811/G_R5u2z4vEnC-B5uqp8TMXmweLhaQYboJ4L4kmh5u0cewTbrdbccN_aT8b4THTqo5kz0"
                v11[2].KnownCosts = {}
                v13 = v1._.setmetatable({}, {__mode = "k"})
                v11[2].FPSOriginal = v13
                v13 = v1._.game
                v12, v13 = v13, v13.GetService
                v13 = {[1] = 2, [2] = v13(v12, "Players")}
                v13[3] = v13
                v12 = v1._.game
                v12, v15 = v12.GetService, v12
                v12 = {[1] = 2, [2] = v12(v15, "ReplicatedStorage")}
                v12[3] = v12
                v15 = v1._.game
                v6, v15 = v15, v15.GetService
                v15 = {[1] = 2, [2] = v15(v6, "Workspace")}
                v15[3] = v15
                v6 = v1._.game
                v6, v9 = v6.GetService, v6
                v6 = {[1] = 2, [2] = v6(v9, "HttpService")}
                v6[3] = v6
                v9 = v1._.game
                v14 = "Lighting"
                v16, v9 = v9, v9.GetService
                v9 = {[1] = 2, [2] = v9(v16, "Lighting")}
                v9[3] = v9
                v16 = v13[2].LocalPlayer
                v2 = v16 and 3 or 242
            elseif v2 >= 173 and v2 <= 174 then
                v2 = v7 and 33 or 404 - v2
            elseif v2 >= 171 and v2 <= 172 then
                v20 = v14[2].PlaybackMode
                v3 = "Wave + Time"
                v17 = v20 == "Wave + Time"
                v2 = v17 and 237 - v2 or 299 - v2
            elseif v2 >= 192 and v2 <= 195 then
                v2, v17 = 329 - v2, "TP"
            elseif v2 >= 180 and v2 <= 187 then
                v7 = v1:lb({v14, v11})
                v11[2].SaveSettings = v7
                v7 = v1:Ea({v12, v11})
                v11[2].Remote = v7
                v7 = v1:_a({v11})
                v11[2].Fire = v7
                v7 = v1:Fb({v11})
                v11[2].Invoke = v7
                v17 = {Value = 1, Clock = 0}
                v3 = v1._.os
                v17.At = v3.clock()
                v20 = 0
                v17.Revision = 0
                v11[2].Speed = v17
                v7 = v19[2].__CameraTDConfirmedSpeed
                v17 = v7
                v2 = v7 and 92 or 212
            elseif v2 >= 188 and v2 <= 191 then
                v20 = v14[2].SummonAmount
                v3 = 10
                v17 = v20 == 10
                v2 = v17 and 428 - v2 or 141
            elseif v2 >= 239 and v2 <= 241 then
                v13 = v19[2].__CameraTDBoot
                v2, v11 = 250 - v2, v13.Loading
            elseif v2 >= 231 and v2 <= 237 then
                v2, v17 = v2 + -96, 10
            elseif v2 >= 224 and v2 <= 230 then
                v2 = v7 and 47 or v2 + -128
            elseif v2 >= 217 and v2 <= 220 then
                v13 = {Loading = true}
                v15 = v1._.os
                v12 = v15.clock()
                v13.At = v12
                v19[2].__CameraTDBoot = v13
                v11 = v19[2].CameraTDHub
                v2 = v11 and 216 or 1
            elseif v2 >= 214 and v2 <= 216 then
                v2, v13 = 217 - v2, v19[2].CameraTDHub
                v11 = v13.Destroy
            elseif v2 >= 210 and v2 <= 212 then
                v2 = v17 and 118 or 83
            elseif v2 >= 196 and v2 <= 201 then
                v2, v17 = 388 - v2, ""
                v14[2].Profile = ""
            elseif v2 >= 202 and v2 <= 208 then
                v18 = 1
                v5 = {}
                v20 = v1._.table.find
                v5[1], v5[2], v5[3] = 1, 1.5, 2
                v5, v3 = v14[2].SpeedScale, v5
                v20 = v20(v3, v5)
                v17 = not v20
                v2 = v17 and 286 - v2 or 325 - v2
            else
                v14[2].SummonAmount = v17
                v20 = v14[2].SummonDelay
                v17 = v1._.math.clamp(v20, 0.1, 10)
                v14[2].SummonDelay = v17
                v20 = v1._.math
                v3, v20, v5, v17 = 0.1, v14[2].AutoDelay, 10, v20.clamp
                v17 = v17(v20, 0.1, 10)
                v14[2].AutoDelay = v17
                v3 = "Walk"
                v20 = v14[2].JoinMethod
                v17 = v20 == "Walk"
                v2 = v17 and 58072 / v2 or 38552 / v2
            end
        until false
    end
end
local function _w187(v1, v2, v3, ...)
    local v4 = {v3}
    for v5 = 1, 1 + select("#", ...) do
        v1[v2 + v5 - 1] = v4[v5]
    end
end
local function _w188(v1)
    local v2 = string
    local v3, v4
    v4, v3, v2 = v2.byte, v2.char, bit32
    local bxor = v2.bxor
    v3 = {[1] = 2, [2] = v3}
    v3[3] = v3
    v4 = {[1] = 2, [2] = v4}
    v4[3] = v4
    bxor = {[1] = 2, [2] = bxor}
    bxor[3] = bxor
    return v1:ne({v4, v3, bxor})
end
local function _w189(v1, v2)
    return function(v3)
        v3 = {[1] = 2, [2] = v3}
        v3[3] = v3
        local v4 = v3[2]
        v1._.warn("[Camera TD Hub] " .. v1._.tostring(v4))
        if v2[1][2].UI then
            v1._.pcall(v1:ke({v3, v2[1]}))
        end
    end
end
local function _w190(v1, v2, v3, v4, v5)
    v1.df[v5] = bit32.band(bit32.bnot(bit32.bnot(bit32.bor(bit32.bxor(v2, 7782), 4294967295))), bit32.bor(bit32.bxor(v2, 7782), bit32.bxor(v3, v4))) * bit32.band(bit32.bxor(v3, v4), bit32.bxor(v2, 7782)) + (-bit32.bxor(v2, 7782) + (bit32.band(bit32.bxor(v2, 7782), bit32.bxor(v4, v3)) * bit32.band(bit32.bnot(bit32.bxor(4294967295, bit32.bxor(v2, 7782))), bit32.bor(bit32.bxor(v2, 7782), bit32.bxor(v3, v4))) + (bit32.bor(bit32.bxor(bit32.bxor(v2, 7782), v4), bit32.bxor(v4, bit32.bxor(v2, 7782))) + -(bit32.band(bit32.band(bit32.bnot(bit32.bnot(bit32.bor(bit32.bxor(v2, 7782), 4294967295))), bit32.bor(bit32.bxor(v2, 7782), bit32.bxor(v3, v4))), bit32.bnot(bit32.bnot(bit32.bxor(v2, 7782)))) * bit32.band(bit32.bxor(v4, v3), bit32.bxor(v2, 7782))) + bit32.band(bit32.bnot(bit32.bxor(v4, v3)), bit32.bxor(v2, 7782)) * bit32.band(bit32.band(bit32.bxor(v3, v4), bit32.bnot(bit32.bxor(v2, 7782))), bit32.bor(bit32.bxor(4294967295, bit32.bxor(v2, 7782)), 4294967295))) + -v4 + bit32.band(v4, bit32.bxor(v2, 7782)) * 2))
    return v1.df[v5]
end
local function _w191(v1, v2)
    return function(v3)
        local v4 = 55
        local v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
        repeat
            if v4 == 11 then
                v4 = v9 and v4 + 36 or 209 / v4
            elseif v4 == 47 then
                v4 = not v9 and 11421 / v4 or v4 + 2
            elseif v4 == 184 then
                v4, v5, v9, v14 = 231 - v4, v7.PathRoot, v8.IsDescendantOf, v8
                v9 = v9(v14, v5)
            elseif v4 >= 50 and v4 <= 55 then
                v7 = v2[1][2].Close
                v10 = {}
                v6, v11, v13 = v1._.ipairs(v3)
                v6, v11, v13 = v1.g(v6, v11, v13)
                v12, v8 = v6(v11, v13)
                v13 = v12
                v4 = v12 == nil and 26 or 129
            elseif v4 >= 56 and v4 <= 183 then
                v9 = v1._.typeof(v8) == "Instance"
                v4 = v9 and v4 + -122 or 176 - v4
            elseif v4 >= 185 and v4 <= 243 then
                v9 = v10
                v4 = 49
                v1._.table.insert(v9, v8)
            elseif v4 >= 12 and v4 <= 25 then
                v9 = v7.PathRoot
                v4 = v9 and 3496 / v4 or v4 + 28
            elseif v4 <= 10 then
                v9 = v7.TowerRoot
                v4 = v9 and 252 or 11
            elseif v4 >= 48 and v4 <= 49 then
                v12, v8 = v6(v11, v13)
                v13 = v12
                v4 = v12 == nil and 26 or 129
            elseif v4 >= 26 and v4 <= 46 then
                return v10
            else
                v4, v9 = 2772 / v4, v8:IsDescendantOf(v7.TowerRoot)
            end
        until false
    end
end
local function _w193(v1, v2)
    return function(v3)
        local v4 = 138
        local v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17
        while true do
            if v4 == 10 then
                v4 = 82
                v13 = true
                v9 = v11 == true
            elseif v4 == 111 then
                v15, v6 = v13(v10, v14)
                v14 = v15
                v4 = v15 == nil and 36 or 131 - v4
            elseif v4 == 138 then
                v16 = {}
                v17 = v1._.pairs
                v5 = v1._.type(v3)
                v11 = "table"
                v8 = v5 == "table"
                v4 = v8 and 122 or 215
            elseif v4 == 193 then
                v4 = v9 and 12 or 226
            elseif v4 == 237 then
                v4 = v7 and 22752 / v4 or 26307 / v4
            elseif v4 >= 187 and v4 <= 192 then
                v4 = 237
                v7 = not v1._.table.find(v16, v15)
            elseif v4 >= 164 and v4 <= 186 then
                v4 = v7 and 378 - v4 or 44082 / v4
            elseif v4 >= 154 and v4 <= 163 then
                v4 = 252
                v5 = {}
                v8 = v5
            elseif v4 >= 216 and v4 <= 226 then
                v4, v9 = 2712 / v4, v11
            elseif v4 >= 194 and v4 <= 215 then
                v4 = v8 and 54180 / v4 or v4 + -52
            elseif v4 >= 227 and v4 <= 236 then
                v4 = 186
                v7 = v9 == v6
            elseif v4 >= 238 and v4 <= 251 then
                v10 = v2[1][2].ModifierCatalog
                v13, v10, v14 = v1._.pairs(v10)
                v13, v10, v14 = v1.g(v13, v10, v14)
                v15, v6 = v13(v10, v14)
                v14 = v15
                v4 = v15 == nil and 36 or 20
            elseif v4 >= 21 and v4 <= 36 then
                v5, v11 = v17(v8, v12)
                v12 = v5
                v4 = v5 == nil and 140 or v4 + -31
            elseif v4 >= 37 and v4 <= 95 then
                v4 = v9 and 235 - v4 or 193
            elseif v4 >= 11 and v4 <= 12 then
                v13 = v1._.type(v9)
                v10 = "string"
                v4 = v13 == "string" and 251 or 432 / v4
            elseif v4 <= 9 then
                v13 = v1._.type(v5)
                v10 = "string"
                v9 = v13 == "string"
                v4 = v9 and 10 or 82
            elseif v4 >= 13 and v4 <= 20 then
                v7 = v9 == v15
                v4 = v7 and 186 or 234
            elseif v4 >= 141 and v4 <= 153 then
                v4 = 193
                v9 = v5
            elseif v4 >= 139 and v4 <= 140 then
                v1._.table.sort(v16)
                return v16
            elseif v4 >= 96 and v4 <= 110 then
                v4 = 111
                v7 = v1._.table.insert
                v7(v16, v15)
            elseif v4 >= 112 and v4 <= 137 then
                v4 = 215
                v8 = v3
            else
                v17, v8, v12 = v17(v8)
                v17, v8, v12 = v1.g(v17, v8, v12)
                v5, v11 = v17(v8, v12)
                v12 = v5
                v4 = v5 == nil and 140 or 5
            end
        end
    end
end
local function _w194(v1, v2)
    return function(v3)
        local v4 = 54
        local v5, v6, v7, v8, v9, v10, v11
        while true do
            if v4 == 192 then
                v10 = v11
                v5 = v11:match("^%d+$")
                v4 = v5 and 187 or 19
            elseif v4 >= 55 and v4 <= 90 then
                return v2[1][2].Skip.StopWaves[v3] == true
            elseif v4 <= 19 then
                v11 = v6(v8, v9)
                v9 = v11
                v4 = v11 == nil and 1710 / v4 or 192
            elseif v4 >= 20 and v4 <= 54 then
                v9 = v2[1][2]
                v7 = v2[2][2].StopAutoSkipAt
                v8 = v9.Skip
                v6 = v8.StopText
                v4 = v6 ~= v7 and 239 or 90
            elseif v4 >= 91 and v4 <= 186 then
                v4 = 19
                v10 = v2[1][2].Skip.StopWaves
                v10[v5] = true
            elseif v4 >= 187 and v4 <= 191 then
                v5 = v1._.tonumber(v11)
                v10 = v5
                v4 = v5 and 399 - v4 or 219
            elseif v4 >= 193 and v4 <= 212 then
                v4 = 219
                v10 = v5 >= 1
            elseif v4 >= 213 and v4 <= 219 then
                v4 = v10 and v4 + -71 or 4161 / v4
            else
                v8 = v2[1][2]
                v6 = v8.Skip
                v8 = v8.Skip
                v6.StopText, v9 = v7, {}
                v8.StopWaves = v9
                v6 = v1._.tostring(v7)
                v9, v8, v6 = "[^,%s;]+", v6, v6.gmatch
                v6, v8, v9 = v6(v8, "[^,%s;]+")
                v6, v8, v9 = v1.g(v6, v8, v9)
                v11 = v6(v8, v9)
                v9 = v11
                v4 = v11 == nil and 90 or v4 + -47
            end
        end
    end
end
local function _w195(v1, v2)
    return function(v3, v4, v13, ...)
        local v5 = 65
        local v6, v7, v8, v9, v10, v11, v12
        repeat
            if v5 == 2 then
                v7 = "GetPartsInPart"
                v5, v6 = 47 - v5, v11 == "GetPartsInPart"
            elseif v5 == 46 then
                v10 = v12.Close
                v11 = v1._.getnamecallmethod()
                v7 = v10.Add
                v6 = v3 == v7
                v5 = v6 and v5 + -31 or 218
            elseif v5 == 79 then
                v6 = v3
                v10 = v1._.table.pack
                v7 = table.pack(v4, v13, ...)
                v11 = v2[1][2]
                v11 = table.pack(v11(v6, table.unpack(v7, 1, v7.n)))
                v10 = v10(table.unpack(v11, 1, v11.n))
                v11 = v9
                v5 = v9 and 12087 / v5 or 108
            elseif v5 == 111 then
                v5 = 252
                v6 = not v7
            elseif v5 == 143 then
                v5, v7 = 254 - v5, v1._.checkcaller()
            elseif v5 == 160 then
                v8 = {}
                v8.At = v1._.os.clock()
                v5, v8.Name = 79, v6.Name
                v8.Pos = v6.Pos
                v7 = v8
                v10.LastSend = v8
            elseif v5 == 173 then
                v7 = v1._.getcallingscript()
                v6 = v7 == v10.UI
                v5 = v6 and 23 or 43596 / v5
            elseif v5 <= 1 then
                v6 = v1._.table
                v8, v6, v7, v11 = v10.n, v10, 1, v6.unpack
                v11 = table.pack(v11(v6, 1, v8))
                return table.unpack(v11, 1, v11.n)
            elseif v5 >= 3 and v5 <= 15 then
                v7 = "FireServer"
                v5 = 218
                v6 = v11 == "FireServer"
            elseif v5 >= 16 and v5 <= 23 then
                v7 = v1._.type(v1._.checkcaller) == "function"
                v5 = v7 and 143 or 111
            elseif v5 >= 29 and v5 <= 45 then
                v5 = v6 and 28 or 184
            elseif v5 >= 24 and v5 <= 28 then
                v5 = 184
                v7 = v10.Hitboxes
                v6 = v7[v4]
            elseif v5 >= 59 and v5 <= 78 then
                v12 = v2[2][2].Hub
                v9 = nil
                v10 = v12
                v5 = v12 and 168 or 165
            elseif v5 >= 47 and v5 <= 58 then
                v10.SendSerial = v10.SendSerial + 1
                v6 = v4
                v7 = v1._.type(v6)
                v5 = v7 == "table" and 218 - v5 or v5 + 21
            elseif v5 >= 80 and v5 <= 89 then
                v5 = v10 and 46 or 79
            elseif v5 >= 90 and v5 <= 107 then
                v5 = 89
                v11 = v12.Close
                v10 = v11.Enabled
            elseif v5 >= 216 and v5 <= 218 then
                v5 = v6 and v5 + -160 or 215
            elseif v5 >= 174 and v5 <= 184 then
                v5 = v6 and 31832 / v5 or 79
            elseif v5 >= 166 and v5 <= 172 then
                v5 = 165
                v10 = v12.Running
            elseif v5 >= 185 and v5 <= 215 then
                v7 = v2[3][2]
                v6 = v3 == v7
                v5 = v6 and 2 or 45
            elseif v5 >= 108 and v5 <= 110 then
                v5 = v11 and 113 or 1
            elseif v5 >= 112 and v5 <= 142 then
                v6 = v10[1]
                v5 = 1
                v11 = v12.CloseFilter(v6)
                v10[1] = v11
            elseif v5 >= 161 and v5 <= 165 then
                v5 = v10 and 16500 / v5 or 89
            elseif v5 >= 144 and v5 <= 159 then
                v7 = v10[1]
                v6 = v1._.type(v7)
                v7 = "table"
                v5, v11 = 16524 / v5, v6 == "table"
            else
                v5, v9 = v5 + -173, v6
            end
        until false
    end
end
local function _w196(v1, v2)
    return function()
        local v3 = 205
        local v4, v5, v6, v7
        while true do
            if v3 == 11 then
                v3 = 207
                v7 = 0
            elseif v3 == 26 then
                v5 = v4.PlaceStep()
                v6 = not v5
                v3 = v6 and 95 or 158
            elseif v3 == 27 then
                v3, v6 = v3 + 208, 0
            elseif v3 == 28 then
                v3, v7 = 109 - v3, v2[2][2]
                v6 = v7.PlaybackCompleted
                v5 = not v6
            elseif v3 == 37 then
                v3 = v7 and v3 + 83 or v3 + 157
            elseif v3 == 69 then
                v7 = v4.PlaceTurn
                v3, v6 = 1104 / v3, not v7
                v4.PlaceTurn = v6
            elseif v3 == 86 then
                v4.Poll()
                v7 = v2[1][2]
                v6 = v7.AutoPlace
                v5 = not v6
                v3 = v5 and 89 - v3 or 245
            elseif v3 == 87 then
                v3 = 106
                v6 = #v2[2][2].Equipped()
                v7 = 0
                v5 = v6 == 0
            elseif v3 == 121 then
                v3, v7 = 29766 / v3, "Disabled | resolving outstanding requests"
            elseif v3 == 137 then
                v6 = v4.HydrateAttempts
                v3 = v6 and 235 or 27
            elseif v3 == 155 then
                v3, v7 = 31000 / v3, "Disabled"
            elseif v3 == 158 then
                v3 = v5 and 10902 / v3 or 16
            elseif v3 == 177 then
                v4.HydrateAt = v6 + v7
                v6 = v2[2][2]
                v3, v5 = v3 + -77, v6.Hydrate
                v5()
            elseif v3 == 200 then
                v5(v6, v7)
                return
            elseif v3 == 208 then
                v6 = v4.PlaceStep()
                v3, v5 = 366 - v3, v6
            elseif v3 == 235 then
                v5 = v6 + 1
                v4.HydrateAttempts = v5
                v6 = v1._.os.clock()
                v7 = v4.HydrateAttempts <= 3
                v3 = v7 and 237 - v3 or 244
            elseif v3 == 245 then
                v3 = v5 and 64 or 386 - v3
            elseif v3 == 253 then
                v3, v6 = v3 + -96, v2[2][2]
                v5 = v6.Recording
            elseif v3 >= 17 and v3 <= 25 then
                v2[2][2].SetStatus("Auto", "Paused: macro recording / playback")
                return
            elseif v3 >= 12 and v3 <= 16 then
                v4.NextAt = v1._.os.clock() + v2[2][2].AutoInterval()
                return
            elseif v3 <= 2 then
                v3 = 244
                v7 = 10
            elseif v3 >= 3 and v3 <= 10 then
                v7 = v2[1][2]
                v6 = v7.AutoUpgrade
                v3 = 245
                v5 = not v6
            elseif v3 >= 29 and v3 <= 36 then
                v3, v7 = 68 - v3, "Paused: macro playback failed"
            elseif v3 >= 38 and v3 <= 46 then
                v6 = v2[1][2]
                v5 = v6.AutoPlace
                v3 = v5 and 87 or 4876 / v3
            elseif v3 >= 47 and v3 <= 68 then
                v6 = v2[2][2]
                v6, v7, v5 = "Auto", v4.Busy, v6.SetStatus
                v7 = v7()
                v3 = v7 and v3 + 57 or 310 - v3
            elseif v3 >= 101 and v3 <= 106 then
                v3 = v5 and 198 or 22260 / v3
            elseif v3 >= 96 and v3 <= 100 then
                v5 = v1._.os.clock()
                v6 = v4.NextAt
                v3 = v5 < v6 and 12900 / v3 or 190
            elseif v3 >= 88 and v3 <= 95 then
                v3 = 158
                v6 = v4.UpgradeStep()
                v5 = v6
            elseif v3 >= 70 and v3 <= 85 then
                v3 = v5 and v3 + 149 or v3 + 106
            elseif v3 >= 107 and v3 <= 120 then
                v5(v6, v7)
                return
            elseif v3 >= 122 and v3 <= 128 then
                v6 = v2[1][2]
                v5 = v6.AutoPlayback
                v3 = v5 and 28 or v3 + -42
            elseif v3 >= 138 and v3 <= 141 then
                v6 = v2[2][2]
                v5 = v6.Playing
                v3 = v5 and 22137 / v3 or 253
            elseif v3 >= 129 and v3 <= 136 then
                return
            elseif v3 >= 191 and v3 <= 197 then
                v3 = 120
                v7 = "Waiting for macro completion"
            elseif v3 >= 188 and v3 <= 190 then
                v5 = false
                v6 = v4.PlaceTurn
                v3 = v6 and 26 or 432 - v3
            elseif v3 >= 198 and v3 <= 199 then
                v6 = v1._.os.clock()
                v7 = v4.HydrateAt
                v3 = v7 and v3 + 9 or v3 + -187
            elseif v3 >= 201 and v3 <= 205 then
                v5 = v2[2][2]
                v6 = v5
                v4 = v5.Auto
                v5 = v5.Active()
                v3 = v5 and 254 or 86
            elseif v3 >= 142 and v3 <= 154 then
                v2[2][2].SetStatus("Auto", "Waiting for a match")
                return
            elseif v3 >= 156 and v3 <= 157 then
                v3 = v5 and v3 + -132 or 280 - v3
            elseif v3 >= 178 and v3 <= 187 then
                v7 = v2[2][2]
                v6 = v7.Active()
                v5 = not v6
                v3 = v5 and v3 + -36 or 46
            elseif v3 >= 159 and v3 <= 176 then
                v3 = 177
                v7 = 30
            elseif v3 >= 246 and v3 <= 252 then
                v3 = v7 and 200 or 401 - v3
            elseif v3 >= 243 and v3 <= 244 then
                v3 = v7 and 177 or 405 - v3
            elseif v3 >= 230 and v3 <= 234 then
                v6 = v2[2][2]
                v6, v7, v5 = "Auto", v2[2][2], v6.SetStatus
                v7 = v7.PlaybackFailure
                v3 = v7 and 31 or v3 + -193
            elseif v3 >= 236 and v3 <= 242 then
                v5 = v4.UpgradeStep()
                v6 = not v5
                v3 = v6 and 50336 / v3 or v3 + -84
            elseif v3 >= 206 and v3 <= 207 then
                v3, v5 = 417 - v3, v6 >= v7
            elseif v3 >= 209 and v3 <= 229 then
                v3 = v5 and 137 or 100
            else
                v6 = v2[2][2]
                v3, v5 = 340 - v3, v6.PathTarget
                v5()
            end
        end
    end
end
local function _w197(v1, v2, v3, v4, v5)
    v1.Le[v5] = v3 + (-bit32.bor(bit32.band(v3, 4294967295), bit32.bxor(v3, v3)) + (bit32.band(bit32.bnot(bit32.band(v2, 65535)), bit32.band(v4, 65535)) * bit32.band(bit32.bnot(bit32.band(v4, 65535)), bit32.band(v2, 65535)) + bit32.bor(bit32.band(65535, v2), bit32.band(65535, v4)) * bit32.band(bit32.band(v2, 65535), bit32.band(65535, v4)) - bit32.band(65535, v2) * bit32.band(v4, 65535))) + bit32.bxor(bit32.bnot(v4), bit32.bnot(bit32.bor(v2, v3)))
    return v1.Le[v5]
end
local function _w198(v1, v2)
    return function(v3)
        local v4 = v1._.tostring
        local v5 = v2[2][2]
        local v6 = v3
        if v3 then
            v5.StopAutoSkipAt = v4(v6)
        else
            v5.StopAutoSkipAt = v4("")
        end
        v2[1][2].Skip.NextAt = 0
        v2[1][2].SaveSettings()
    end
end
local function _w199(v1, v2, v3, v4)
    v1.pf[v4] = -v3 + (bit32.band(bit32.band(65535, v3), bit32.band(65535, v3)) * bit32.bor(bit32.band(65535, v3), bit32.band(65535, v3)) + bit32.band(bit32.band(65535, v3), bit32.bnot(bit32.band(v3, 65535))) * bit32.band(bit32.band(v3, 65535), bit32.bnot(bit32.band(65535, v3))) - bit32.band(65535, v3) * bit32.band(v3, 65535)) + -bit32.bnot(bit32.bnot(bit32.bxor(v2, 35531))) + bit32.bxor(v2, 35531) * 2
    return v1.pf[v4]
end
local function _w200(v1, v2)
    return function(v3)
        local v4 = v3.Equipped
        local v5 = v1._.tonumber(v4)
        v4 = not v5 or v5 < 1 or v5 > 5
        local v6, v7, v8
        if v4 then
            if v4 then
                return nil
            else
                v4 = v2[1][2].GUI("Slots/Slot" .. v1._.string.format("%d", v5) .. "/TroopFrame/Price")
                v6 = v4
                if v4 then
                    while true do
                        v4.Text:gsub(",", ""):match("[%d%.]+")
                    end
                else
                    v8 = v1._.tonumber(v6)
                    v7 = v8
                    if v8 then
                        if v8 > 0 then
                            return v8
                        end
                    elseif v7 then
                        return v8
                    else
                        return
                    end
                end
            end
        elseif v5 % 1 ~= 0 then
            return nil
        else
            v4 = v2[1][2].GUI("Slots/Slot" .. v1._.string.format("%d", v5) .. "/TroopFrame/Price")
            v6 = v4
            if v4 then
                while true do
                    v4.Text:gsub(",", ""):match("[%d%.]+")
                end
            else
                v8 = v1._.tonumber(v6)
                v7 = v8
                if v8 then
                    if v8 > 0 then
                        return v8
                    end
                elseif v7 then
                    return v8
                else
                    return
                end
            end
        end
    end
end
local function _w201(v1, v2)
    return function()
        local v3 = v2[1][2]
        v3.Window:OnDestroy(v3.Destroy)
    end
end
local function _w202(v1, v2)
    return function()
        local v3 = 23
        local v4, v5, v6, v7, v8
        repeat
            if v3 >= 68 and v3 <= 73 then
                v8 = v2[1][2]
                v6, v7, v8, v4 = v2[1][2], {}, "stopped", v8.Log
                v7.attempts = v6.Attempts
                v4("stopped", v7)
                return
            elseif v3 <= 66 then
                v7 = v2[1][2]
                v8 = v7.Active
                v4 = not v8
                v3 = v4 and 67 or 79
            elseif v3 >= 74 and v3 <= 79 then
                v4 = v2[1][2]
                v4.Active, v5 = false, false
                v4.Armed = false
                v8 = v4.Connections
                v4, v8, v7 = v1._.ipairs(v8)
                v4, v8, v7 = v1.g(v4, v8, v7)
                v5, v6 = v4(v8, v7)
                v7 = v5
                v3 = v5 == nil and 73 or 258 - v3
            elseif v3 >= 80 and v3 <= 83 then
                v5, v6 = v4(v8, v7)
                v7 = v5
                v3 = v5 == nil and 6059 / v3 or 179
            elseif v3 >= 84 then
                v3 = 83
                v6:Disconnect()
            end
        until false
    end
end
local function _w203(v1, v2)
    return function(v3, v4, v13, ...)
        local v5 = 0
        local v6, v7, v8, v9, v10, getnamecallmethod, v11, v12
        repeat
            if v5 == 17 then
                v11.Wave = v6
                v11.Time = v9.RecordTime(v10)
                v6 = v9.WaveStartedGame
                v5 = v6 and 20 - v5 or 1989 / v5
            elseif v5 == 22 then
                v10 = not v12
                v5 = v10 and 21 or 95 - v5
            elseif v5 == 79 then
                v12 = v9.SkipAutomationThreads
                v5 = v12 and 210 or 101 - v5
            elseif v5 == 210 then
                v11 = v9.SkipAutomationThreads
                v5, v6 = 4620 / v5, v1._.coroutine.running
                v6 = v6()
                v12 = v11[v6]
            elseif v5 >= 227 and v5 <= 233 then
                v5, v6 = v5 + -216, 0
            elseif v5 >= 219 and v5 <= 226 then
                v5 = v8 and 236 or 178
            elseif v5 >= 211 and v5 <= 218 then
                v5, v8 = v5 + 8, v9.Running
            elseif v5 >= 179 and v5 <= 186 then
                v5 = v8 and 200 or 13578 / v5
            elseif v5 >= 118 and v5 <= 142 then
                v5, v6 = v5 + -58, v9.LastWave
            elseif v5 >= 143 and v5 <= 178 then
                v5 = v8 and v5 + 15 or v5 + 8
            elseif v5 >= 194 and v5 <= 209 then
                v10 = "WaveSkip"
                v8 = v9.RecordRemotes[v3]
                v5 = v8 == "WaveSkip" and 279 - v5 or 4
            elseif v5 >= 187 and v5 <= 193 then
                v5 = 186
                v10 = "FireServer"
                v8 = getnamecallmethod == "FireServer"
            elseif v5 >= 1 and v5 <= 3 then
                v5 = 117
                v6 = v1._.math.max(0, v9.GameClock() - v9.WaveStartedGame)
            elseif v5 <= 0 then
                getnamecallmethod = v1._.getnamecallmethod()
                v9 = v2[2][2].Hub
                v8 = v9
                v5 = v9 and 218 or 226
            elseif v5 >= 18 and v5 <= 21 then
                v10 = v9.Recording
                v11 = {Record = v10}
                v6 = v9.RecordWave
                v5 = v6 and v5 + 63 or 163 - v5
            elseif v5 >= 4 and v5 <= 16 then
                v5 = v8 and v5 + 104 or v5 + 69
            elseif v5 >= 109 and v5 <= 117 then
                v11.WaveTime = v6
                v12 = v11
                v11 = v1._.table.pack
                v6 = v2[1][2]
                v6 = table.pack(v6(v3, v4, v13, ...))
                v11 = v11(table.unpack(v6, 1, v6.n))
                v1._.pcall(v9.RecordManualSkip, v12)
                v6 = v1._.table.unpack
                v7 = v11.n
                v6 = v1.h(v6(v11, 1, v7))
                return table.unpack(v6, 1, v6.n)
            elseif v5 >= 85 and v5 <= 108 then
                v10 = v1._.pcall
                v12 = v9.Stamp
                v11 = v8
                v6 = table.pack(v4, v13, ...)
                v5 = 7884 / v5
                v10(v12, v11, table.unpack(v6, 1, v6.n))
            elseif v5 >= 80 and v5 <= 84 then
                v5 = v6 and 101 - v5 or 233
            elseif v5 >= 23 and v5 <= 78 then
                v8 = v2[1][2]
                v12 = table.pack(v4, v13, ...)
                v8 = table.pack(v8(v3, table.unpack(v12, 1, v12.n)))
                return table.unpack(v8, 1, v8.n)
            else
                v5, v8 = 42008 / v5, v9.Recording
            end
        until false
    end
end
local function _w204(v1, v2, v3, v4)
    v1.pf[v4] = v1.oe(v2, v3)
    return v1.pf[v4]
end
local function _w207(v1, v2)
    return function(v3, v4)
        local v5 = v2[2][2].Path
        local v6 = v2[1][2]
        local v7 = v4
        if v7 then
            v5 = table.pack(v5(v6, "ModuleLoader/Shared/Network/" .. v7 .. "/" .. v3))
        else
            v5 = table.pack(v5(v6, "ModuleLoader/Shared/Network/" .. "RemoteEvent" .. "/" .. v3))
        end
        return table.unpack(v5, 1, v5.n)
    end
end
local function _w208(v1, v2)
    return function(match2, v3, v4, v5, fields, url)
        local v6 = 57
        local v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
        while true do
            if v6 == 21 then
                v22.color = v18
                v22.fields = fields
                v19 = {text = "Made By Kero"}
                v9 = "https://i.postimg.cc/HWKcyfKJ/download-(2).jpg"
                v19.icon_url = "https://i.postimg.cc/HWKcyfKJ/download-(2).jpg"
                v18 = v19
                v22.footer = v19
                v22, v17 = v1._.DateTime, v22
                v6 = v22 and v6 + 108 or 30
            elseif v6 == 22 then
                v6 = v7 and 56 or v6 + 52
            elseif v6 == 31 then
                return false, "Executor HTTP request unavailable"
            elseif v6 == 32 then
                return false, "HTTP response has no status; delivery unconfirmed"
            elseif v6 == 49 then
                v9 = v9 + v10
                v6 = (v10 > 0 and v9 > v14 or v10 <= 0 and v9 < v14 or false) and 183 - v6 or v6 + 136
            elseif v6 == 57 then
                v17 = match2
                v21 = v1._.tostring
                v6 = match2 and 172 or 149
            elseif v6 == 76 then
                v6, v7 = 15200 / v6, v15.Status
            elseif v6 == 88 then
                return false, "Could not encode webhook payload"
            elseif v6 == 129 then
                v6 = 30
                v22 = v1._.DateTime.now():ToIsoDate()
                v17.timestamp = v22
            elseif v6 == 148 then
                return false, "HTTP request failed (executor/network)"
            elseif v6 == 149 then
                v6 = 172
                v17 = ""
            elseif v6 == 165 then
                v6 = 223
                v13 = v12 > 5
            elseif v6 == 182 then
                v6 = 21
                v18 = 5793266
            elseif v6 == 185 then
                v8 = v1._.pcall
                v20 = {Url = match2, Method = "POST"}
                v11 = {}
                v12 = "application/json"
                v11["Content-Type"] = "application/json"
                v7 = v11
                v20.Headers = v11
                v20.Body = v19
                v8, v15 = v8(v21, v20)
                v20 = not v8
                v6 = v20 and v6 + -37 or 343 - v6
            elseif v6 == 200 then
                v6, v20 = 117, v20(v7)
            elseif v6 == 201 then
                v13 = v1._.task.wait
                v16 = v1._.math.max
                v16 = table.pack(v16(0.1, v12))
                v13(table.unpack(v16, 1, v16.n))
                v13 = not v2[2][2].Running
                v6 = v13 and 184 or 250 - v6
            elseif v6 == 209 then
                v6 = v12 and 120 or 1
            elseif v6 == 235 then
                return false, "Discord rate limited (HTTP 429)"
            elseif v6 >= 120 and v6 <= 128 then
                v6, v12, v13 = v6 + -119, v1._.tonumber, v11.retry_after
                v12 = v12(v13)
            elseif v6 >= 130 and v6 <= 131 then
                v11 = 1
                v6 = 22
                v7 = v9 == 1
            elseif v6 >= 113 and v6 <= 119 then
                v7 = not v20
                v6 = v7 and 149 - v6 or 196
            elseif v6 >= 93 and v6 <= 112 then
                v11 = 429
                v7 = v20 == 429
                v6 = v7 and 131 or 22
            elseif v6 >= 89 and v6 <= 92 then
                v18 = {}
                v6, v18.url = 45, url
                v22 = v18
                v17.image = v18
            elseif v6 >= 83 and v6 <= 87 then
                v13 = v1._.type(v11)
                v6, v12 = 292 - v6, v13 == "table"
            elseif v6 >= 77 and v6 <= 82 then
                return false, "Enter a valid Discord webhook URL"
            elseif v6 >= 74 and v6 <= 75 then
                return false, "Discord returned HTTP " .. v20
            elseif v6 >= 58 and v6 <= 59 then
                v14 = 2
                v9 = 1
                v10 = 1
                v6 = 244 - v6
            elseif v6 >= 60 and v6 <= 73 then
                v6 = v7 and v6 + 67 or 8
            elseif v6 >= 50 and v6 <= 56 then
                v12 = v2[1][2]
                v7 = v1._.pcall
                v11 = v12.JSONDecode
                v13 = v15.Body
                v6 = v13 and 162 or 251
            elseif v6 >= 33 and v6 <= 48 then
                v18 = {username = "Camera TD Hub"}
                v10 = {}
                v18.allowed_mentions = {parse = v10}
                v18.embeds = {[1] = v17}
                v9, v18, v22 = v2[1][2], v1._.pcall, v18
                v14 = v22
                v18, v19 = v18(v9.JSONEncode, v9, v22)
                v9 = not v18
                v6 = v9 and 88 or v6 + 14
            elseif v6 <= 1 then
                v13 = not v12
                v6 = v13 and 223 or 165
            elseif v6 >= 2 and v6 <= 20 then
                v6 = v7 and 205 or 112
            elseif v6 >= 23 and v6 <= 30 then
                v6 = url and 122 - v6 or 1350 / v6
            elseif v6 >= 150 and v6 <= 158 then
                v7 = v1._.type(v15)
                v11 = "table"
                v20 = v7 == "table"
                v6 = v20 and 197 or 18486 / v6
            elseif v6 >= 159 and v6 <= 164 then
                v7, v11 = v7(v11, v12, v13)
                v12 = v7
                v6 = v7 and 83 or 209
            elseif v6 >= 132 and v6 <= 134 then
                return false, "Discord rate limited (HTTP 429)"
            elseif v6 >= 135 and v6 <= 147 then
                v6 = 8
                v12 = false
                v11 = v15.Success
                v7 = v11 ~= false
            elseif v6 >= 186 and v6 <= 196 then
                v11 = 200
                v7 = v20 >= 200
                v6 = v7 and v6 + 8 or 14308 / v6
            elseif v6 >= 183 and v6 <= 184 then
                return false, "Hub stopped"
            elseif v6 >= 166 and v6 <= 181 then
                v21 = v21(v17)
                match2 = v21:match("^%s*(.-)%s*$")
                v22 = match2
                v17 = v2[2][2].ValidWebhook(v22)
                v21 = not v17
                v6 = v21 and 79 or 253
            elseif v6 >= 249 and v6 <= 251 then
                v6, v13 = v6 + -89, ""
            elseif v6 >= 236 and v6 <= 248 then
                v22 = {title = v3, description = v4}
                v18 = v5
                v6 = v5 and 269 - v6 or 45136 / v6
            elseif v6 >= 210 and v6 <= 234 then
                v6 = v13 and v6 + 12 or 201
            elseif v6 >= 205 and v6 <= 208 then
                return true, "HTTP " .. v20
            elseif v6 >= 202 and v6 <= 204 then
                v11 = 300
                v6 = 73
                v7 = v20 < 300
            elseif v6 >= 197 and v6 <= 199 then
                v20 = v1._.tonumber
                v7 = v15.StatusCode
                v6 = v7 and 397 - v6 or 273 - v6
            else
                v21 = v2[2][2].RequestFunction()
                v17 = not v21
                v6 = v17 and 31 or 248
            end
        end
    end
end
local function _w209(v1, v2)
    return function(v3, reason)
        local v4 = {}
        local v5 = v2[1][2]
        v4.Success = v3
        v4.Reason = reason
        v4.At = v1._.os.clock()
        v5.WebhookLastStatus = v4
        local v6
        v4, v6, v5 = v3, "Webhook", v5.SetStatus
        if v4 then
            v5("Webhook", "Sent: " .. v1._.tostring(reason))
        else
            v5("Webhook", "Failed: " .. v1._.tostring(reason))
        end
        if not v3 then
            v1._.warn("[Camera TD Hub] Webhook: " .. v1._.tostring(reason))
        end
    end
end
local function _w210(v1, v2)
    return function()
        v1._.task.spawn(v1:ie({v2[1]}))
    end
end
local function _w211(v1, v2)
    return function(v3)
        local v4, v5, gUI5, v6, v7
        if v2[1][2].Wave() ~= v3 then
            return false
        else
            gUI5 = v2[1][2].GUI("Stats/WaveSkipGui/Title")
            if gUI5 then
                v4 = gUI5.Text
                v7, v4 = v4, v4.match
                v4, v7 = v4(v7, "(%d+)%s*/%s*(%d+)")
                v6 = v4
                v5 = v7
                if v1._.tonumber(v5) then
                    if v1._.tonumber(v5) > 0 then
                        v4 = v1._.tonumber(v6) >= v1._.tonumber(v5)
                        if v4 then
                            return v4
                        else
                            return false
                        end
                    else
                        return false
                    end
                else
                    return false
                end
            elseif v1._.tonumber(nil) then
                if v1._.tonumber(nil) > 0 then
                    v4 = v1._.tonumber(nil) >= v1._.tonumber(nil)
                    if v4 then
                        return v4
                    else
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        end
    end
end
local function _w212(v1, v2, v3, v4)
    v1.df[v4] = v1.me(v2, v3)
    return v1.df[v4]
end
local function _w213(v1, v2, v3, v4)
    v1.jf[v4] = v1.me(v2, v3)
    return v1.jf[v4]
end
local function _w214(v1, v2)
    return function()
        local v3 = {[1] = 2, [2] = v2[2][2].Widgets.Profiles}
        v3[3] = v3
        if v3[2] then
            v2[2][2].Refreshing = true
            v1._.pcall(v1:gc({v2[1], v3, v2[2]}))
            v2[2][2].Refreshing = false
        end
    end
end
local function _w215(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5, v6
        v4, v6, v5 = v2[1][2], v4.Path, "PlayerGui"
        v4 = v4:FindFirstChild("PlayerGui")
        v6 = table.pack(v6(v4, "GameUI/" .. v3))
        return table.unpack(v6, 1, v6.n)
    end
end
local function _w216(v1, v2)
    return function()
        local v3 = v1._.game
        local v4 = v2[1][2]
        local v5
        v5, v3 = v3, v3.GetService
        v3 = table.pack(v3(v5, "CoreGui"))
        v4(table.unpack(v3, 1, v3.n))
    end
end
local function _w217(v1, v2)
    return function()
        return v2[2][2][v2[1][2]]
    end
end
local function _w218(v1, v2)
    return function()
        local v3 = v2[2][2]
        local v4, v5, v6
        v3, v4, v5, v6 = v2[3][2], v3.SendDiscord, v1._.string, "Camera TD Hub Activated"
        local v7, v8
        v7, v8, v5 = v2[1][2], v5.format, "User: ||%s||\nID: ||%d||\nPlace ID: %s"
        local v9 = v7.Name
        local v10, v11
        v11, v10, v7 = v1._.game, v1._.tostring, v7.UserId
        v11 = v11.PlaceId
        v10 = table.pack(v10(v11))
        v8 = v8("User: ||%s||\nID: ||%d||\nPlace ID: %s", v9, v7, table.unpack(v10, 1, v10.n))
        v9 = {}
        v10 = {name = "Account Coins"}
        v11 = v1._.tostring
        local accountCoins = v2[2][2].AccountCoins()
        if accountCoins then
            v10.value = v11(accountCoins)
        else
            v10.value = v11("Unavailable")
        end
        v10.inline = true
        v9[1] = v10
        v4 = table.pack(v4(v3, "Camera TD Hub Activated", v8, 5763719, v9))
        return table.unpack(v4, 1, v4.n)
    end
end
local function _w219(v1, v2)
    return function(v3)
        if v2[2][2].FPSBoost then
            v2[1][2].FPSObject(v3)
        end
    end
end
local function _w220(v1, v2)
    return function()
        local v3 = 181
        local v4, v5, v6, v7
        while true do
            if v3 == 50 then
                v3 = 170
                v5 = v2[1][2].SetStatus
                v6 = v1._.tostring
                v6 = table.pack(v6(v4))
                v5("Lobby", table.unpack(v6, 1, v6.n))
            elseif v3 <= 49 then
                v4 = v2[1][2]
                v7 = v4.Running
                v3 = v7 and 141 or 212
            elseif v3 >= 51 and v3 <= 141 then
                v4 = v2[1][2].LobbyStep
                v7, v4 = v1._.pcall(v4)
                v3 = not v7 and 7050 / v3 or 170
            elseif v3 >= 142 and v3 <= 170 then
                v3 = 17
                v1._.task.wait(1)
            elseif v3 >= 171 and v3 <= 181 then
                v3 = 17
            else
                return
            end
        end
    end
end
local function _w221(v1, v2)
    return function(v3)
        v2[2][2].AutoPlace = v3 == true
        v2[1][2].SaveSettings()
    end
end
local function _w222(v1, v2, v3, v4)
    v1.Fe[v4] = bit32.band(bit32.band(v2, 65535), bit32.band(v2, 65535)) * bit32.bor(bit32.band(v2, 65535), bit32.band(65535, v2)) + bit32.band(bit32.band(65535, v2), bit32.bnot(bit32.band(65535, v2))) * bit32.band(bit32.bnot(bit32.band(65535, v2)), bit32.band(65535, v2)) - bit32.band(v2, 65535) * bit32.band(v2, 65535) + (v2 * -3 + (2 * bit32.bxor(0, bit32.bor(v2, v3)) + (bit32.bnot(bit32.bxor(4294967295, v2)) + bit32.bor(v2, bit32.band(v2, v3)))) + -bit32.bxor(bit32.bnot(v3), bit32.bor(v3, 4294967295)))
    return v1.Fe[v4]
end
local function _w223(v1, v2)
    return function()
        local v3 = v2[2][2]
        local v4
        v3, v4 = v2[1][2], v3.File
        v4 = v4(v3)
        local v5
        if v1._.isfile(v4) then
            v3 = v1._.writefile
            v5 = v1._.readfile
            v5 = table.pack(v5(v4))
            v3(v4 .. ".bak", table.unpack(v5, 1, v5.n))
            v1._.delfile(v4)
        end
    end
end
local function _w224(v1, v2)
    return function(v3)
        local v4 = 109
        local v5, v6, v7, v8, v9
        repeat
            if v4 == 40 then
                v7 = v2[2][2]
                v5 = v1._.table.insert
                v7, v8, v9 = v3.DescendantAdded, v7.NameConnections, v1:Kc({v2[1], v2[2]})
                v6, v7 = v7, v7.Connect
                v7 = table.pack(v7(v6, v9))
                v5(v8, table.unpack(v7, 1, v7.n))
                return
            elseif v4 >= 192 then
                v8 = v3.GetDescendants
                v5 = v1._.ipairs
                v8 = v1.h(v8(v3))
                v5, v8, v7 = v5(v1.i(v8))
                v5, v8, v7 = v1.g(v5, v8, v7)
                v6, v9 = v5(v8, v7)
                v7 = v6
                v4 = v6 == nil and v4 + -209 or 2241 / v4
            elseif v4 >= 41 and v4 <= 109 then
                v5 = not v3
                v4 = v5 and 191 or 249
            elseif v4 <= 39 then
                v4 = 186
                v2[2][2].WatchOwnNameLabel(v9)
            elseif v4 >= 110 and v4 <= 186 then
                v6, v9 = v5(v8, v7)
                v7 = v6
                v4 = v6 == nil and 7440 / v4 or 9
            end
        until false
    end
end
local function _w225(v1, v2)
    return function(v3)
        local v4
        local v5, v6, v7, v8, v9, v10
        if v2[1][2].Own(v3) then
            if v1._.type(v3.UnitId) == "string" then
                if v1._.type(v3.Name) == "string" then
                    v6 = v3.UnitId
                    v4 = v2[1][2].Units[v6] or {}
                    v6 = v3.UnitId
                    v4.Name = v3.Name
                    v4.Id = v6
                    v6 = v2[1][2]
                    v6, v7 = v3.UnitId, v6.Units
                    v7[v6] = v4
                    v6 = v3.Stats
                    v7 = v1._.tonumber
                    if v6 then
                        v7 = v7(v3.Stats.Price)
                    else
                        v7 = v7(v6)
                    end
                    v6 = v7
                    if v7 then
                        if v7 > 0 then
                            v8 = v3.Level
                            if v1._.tonumber(v8) then
                                v6 = v2[1][2].KnownCosts
                                v5 = v2[1][2]
                                v8 = v3.Name
                                v5, v10 = v3.Name, v5.KnownCosts
                                v9 = v10[v5]
                                if v9 then
                                    v6[v8] = v9
                                else
                                    v6[v8] = {}
                                end
                                v9 = v2[1][2]
                                v9, v8 = v3.Name, v9.KnownCosts
                                v9, v6, v8 = v3.Level, v8[v9], v1._.tonumber
                                v8 = v8(v9)
                                v6[v8] = v7
                            end
                        end
                        return
                    elseif v6 then
                        v8 = v3.Level
                        if v1._.tonumber(v8) then
                            v6 = v2[1][2].KnownCosts
                            v5 = v2[1][2]
                            v8 = v3.Name
                            v5, v10 = v3.Name, v5.KnownCosts
                            v9 = v10[v5]
                            if v9 then
                                v6[v8] = v9
                            else
                                v6[v8] = {}
                            end
                            v9 = v2[1][2]
                            v9, v8 = v3.Name, v9.KnownCosts
                            v9, v6, v8 = v3.Level, v8[v9], v1._.tonumber
                            v8 = v8(v9)
                            v6[v8] = v7
                        end
                        return
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    end
end
local function _w226(v1, v2, v3, v4, v5)
    v1.Le[v5] = -bit32.bnot(bit32.bnot(v4)) + (v4 + (-bit32.bxor(v3, 38011) + bit32.bxor(v3, 38011) * bit32.bxor(v2, 11017) * v4 + bit32.band(4294967295, bit32.bxor(v3, 38011))))
    return v1.Le[v5]
end
local function _w227(v1, v2)
    return function()
        local v3 = 65
        local v4, v5, v6, v7, v8, v9, v10, v11
        while true do
            if v3 > 147 then
                if v3 < 206 then
                    if v3 >= 173 then
                        if v3 > 173 then
                            return v6
                        end
                        return nil
                    else
                        v5 = v2[2][2]
                        v8 = v5.Write
                        v5, v7 = v5.SettingsFile, v10
                        v8 = v8(v5, v7)
                        v5 = v8
                        v3 = v8 and 136 or 274 - v3
                    end
                elseif v3 >= 235 then
                    if v3 > 235 then
                        v3 = v8 and v3 + -157 or 4
                    else
                        return nil
                    end
                elseif v3 <= 206 then
                    v9 = v2[2][2]
                    v10 = v9.Read
                    v11, v9 = "/Settings.json", v9.Folder
                    v10 = v10(v9 .. "/Settings.json")
                    v9 = not v10
                    v3 = v9 and 441 - v3 or 47792 / v3
                else
                    v9 = v2[2][2].SettingsFolder .. "/.legacy-owner.json"
                    v11 = v2[2][2].Read(v9)
                    v8 = v11
                    v3 = v11 and 147 or 55912 / v3
                end
            elseif v3 <= 71 then
                if v3 <= 35 then
                    if v3 < 4 then
                        v3 = 71
                        v5 = nil
                    elseif v3 > 4 then
                        v8 = v2[2][2].Write
                        v7 = {}
                        v4 = v2[1][2]
                        v7.UserId = v4.UserId
                        v7.Username = v4.Name
                        v8 = v8(v9, v7)
                        v5 = not v8
                        v3 = v5 and 6055 / v3 or 171
                    else
                        v8 = not v11
                        v3 = v8 and 35 or 175 - v3
                    end
                elseif v3 > 65 then
                    return v5
                else
                    v10 = v2[2][2]
                    v10, v6 = v10.SettingsFile, v10.Read
                    v6 = v6(v10)
                    v3 = v6 and 174 or 206
                end
            elseif v3 > 136 then
                v7 = v11.UserId
                v3 = 241
                v5 = v1._.tonumber(v7)
                v8 = v5 ~= v2[1][2].UserId
            elseif v3 >= 103 then
                if v3 > 103 then
                    v3 = 103
                    v5 = v10
                else
                    v3 = v5 and 71 or 309 / v3
                end
            else
                return nil
            end
        end
    end
end
local function _w228(v1, v2)
    return function()
        local v3 = 226
        local v4, v5, elevators, v6, map, v7, v8, v9, v10, v11, v12, v13
        repeat
            if v3 == 33 then
                v3 = v13 and 238 or 6171 / v3
            elseif v3 == 99 then
                v4, v11, v12 = v4(v11)
                v4, v11, v12 = v1.g(v4, v11, v12)
                v10, v7 = v4(v11, v12)
                v12 = v10
                v3 = v10 == nil and v3 + 50 or 2574 / v3
            elseif v3 == 187 then
                v10, v7 = v4(v11, v12)
                v12 = v10
                v3 = v10 == nil and v3 + -38 or v3 + -161
            elseif v3 == 226 then
                v9 = {}
                v8 = {}
                elevators = v2[1][2]:FindFirstChild("Elevators")
                v11 = elevators
                v4 = v1._.ipairs
                v3 = elevators and 28 or 38
            elseif v3 >= 227 and v3 <= 238 then
                v8[map] = true
                v3, v13, v5, v6 = v3 + -51, v1._.table.insert, v9, map
                v13(v5, v6)
            elseif v3 >= 188 and v3 <= 225 then
                v12, v11, v3, v10, v4 = "Desert", "Toilet City", 36432 / v3, "Cameraman HQ", {}
                v4[3], v4[1], v4[2] = "Cameraman HQ", "Toilet City", "Desert"
                v9 = v4
            elseif v3 >= 150 and v3 <= 186 then
                v1._.table.sort(v9)
                return v9
            elseif v3 >= 24 and v3 <= 26 then
                map = v7:GetAttribute("Map")
                v13 = v1._.type(map) == "string"
                v3 = v13 and 6552 / v3 or 858 / v3
            elseif v3 <= 23 then
                v3 = 99
                v11 = {}
            elseif v3 >= 27 and v3 <= 32 then
                v7 = elevators
                v3 = 38
                v11 = elevators:GetChildren()
            elseif v3 >= 34 and v3 <= 98 then
                v3 = v11 and 99 or 23
            elseif v3 >= 100 and v3 <= 149 then
                v4 = #v9
                v11 = 0
                v3 = v4 == 0 and 30843 / v3 or v3 + 27
            else
                v3, v13 = 8316 / v3, not v8[map]
            end
        until false
    end
end
local function _w229(v1, v2)
    return function()
        local v3 = 54
        local v4, v5, v6, v7, v8, v9, v10, v11
        repeat
            if v3 == 47 then
                v3, v10 = 7379 / v3, v10 + v7
            elseif v3 == 110 then
                v8 = v1._.math
                v6, v8, v4 = v2[1][2], 0, v8.max
                v11 = v6.Cash() - v10
                v4 = table.pack(v4(0, v11))
                return table.unpack(v4, 1, v4.n)
            elseif v3 == 199 then
                v6, v5 = v4(v8, v11)
                v11 = v6
                v3 = v6 == nil and 110 or 231
            elseif v3 >= 111 and v3 <= 157 then
                v6, v5 = v4(v8, v11)
                v11 = v6
                v3 = v6 == nil and 218 - v3 or 173
            elseif v3 >= 158 and v3 <= 198 then
                v7 = v5.Cost
                v3 = v7 and 8131 / v3 or 17
            elseif v3 >= 200 and v3 <= 212 then
                v3, v9 = 279 - v3, v2[1][2]
                v7 = v9.Cash()
            elseif v3 >= 55 and v3 <= 61 then
                v8 = v2[1][2].Auto.UpgradePending
                v4, v8, v11 = v1._.pairs(v8)
                v4, v8, v11 = v1.g(v4, v8, v11)
                v6, v5 = v4(v8, v11)
                v11 = v6
                v3 = v6 == nil and 110 or 231
            elseif v3 >= 62 and v3 <= 109 then
                v3, v10 = 13333 / v3, v10 + v7
            elseif v3 >= 48 and v3 <= 54 then
                v10 = 0
                v8 = v2[1][2].Auto.PlacePending
                v4, v8, v11 = v1._.pairs(v8)
                v4, v8, v11 = v1.g(v4, v8, v11)
                v6, v5 = v4(v8, v11)
                v11 = v6
                v3 = v6 == nil and 61 or 173
            elseif v3 <= 46 then
                v3, v7 = 64 - v3, v2[1][2].Cash
                v7 = v7()
            else
                v7 = v5.Cost
                v3 = v7 and v3 + -164 or 443 - v3
            end
        until false
    end
end
local function _w230(v1, v2, v3, ...)
    v1.oe, v1.qe, v1.me = v1:oe(), v1:qe(), v1:me()
    return v1:k()(v2, v3, ...)
end
local function _w231(v1, v2)
    return function(v3)
        if v2[2][2].FPSBoost then
            v2[1][2].FPSObject(v3)
        end
        while true do
        end
    end
end
local function _w232(v1, v2)
    return function(v3)
        local v4 = #v3 % 5
        if v4 > 0 then
            v3 = v3 .. ("~"):rep(5 - v4)
        end
        local v5 = v2[2][2](v3, ".....", v1:se({v2[4], v2[1], v2[3]}))
        local v6
        v5, v6 = v5.sub, v5
        v5 = table.pack(v5(v6, 1, v4 > 0 and -(5 - v4) - 1 or -1))
        return table.unpack(v5, 1, v5.n)
    end
end
local function _w233(v1, v2)
    return function()
        local v3 = 128
        local v4, v5, v6, v7, v8, v9, v10, v11
        while true do
            if v3 == 44 then
                v8 = v10.Name
                v5 = v2[1][2]
                v3 = v8 == v5 and 151 - v3 or v3 + 104
            elseif v3 == 73 then
                v4 = v2[2][2]
                v11, v7, v4 = v2[1][2], v4.Notify, "Cannot resolve equipped unit: "
                v7("Cannot resolve equipped unit: " .. v11)
                return
            elseif v3 == 107 then
                v3 = 199
                v9 = v10
            elseif v3 == 142 then
                return
            elseif v3 == 143 then
                v3 = v9 and 150 or 241
            elseif v3 == 163 then
                v3 = v9 and 40424 / v3 or 354 - v3
            elseif v3 >= 144 and v3 <= 148 then
                v6, v10 = v7(v4, v11)
                v11 = v6
                v3 = v6 == nil and 199 or 44
            elseif v3 >= 129 and v3 <= 141 then
                return
            elseif v3 >= 114 and v3 <= 128 then
                v4 = v2[2][2]
                v7 = v4.Running
                v9 = not v7
                v3 = v9 and 143 or 113
            elseif v3 >= 74 and v3 <= 106 then
                v3, v7 = 17115 / v3, v2[2][2]
                v9 = v7.SoloReturning
            elseif v3 >= 108 and v3 <= 113 then
                v4 = v2[7][2]
                v7 = v4.Enabled
                v3, v9 = 16159 / v3, not v7
            elseif v3 >= 45 and v3 <= 72 then
                v3 = v9 and 232 - v3 or v3 + 115
            elseif v3 <= 43 then
                v2[2][2].CloseRefresh()
                v9 = v2[7][2].Preview
                v7 = v2[5][2]
                v3 = v9 ~= v7 and v3 + 112 or 243
            elseif v3 >= 180 and v3 <= 191 then
                v7 = v2[2][2]
                v3 = 248
                v9 = v7.Final()
            elseif v3 >= 175 and v3 <= 179 then
                v3 = v9 and 142 or 17
            elseif v3 >= 149 and v3 <= 162 then
                v3 = v9 and 24450 / v3 or 15750 / v3
            elseif v3 >= 164 and v3 <= 168 then
                v7 = v2[7][2].SendSerial
                v4 = v2[3][2]
                v3 = 179
                v9 = v7 ~= v4
            elseif v3 >= 169 and v3 <= 174 then
                v3 = 53
                v7 = v2[7][2].ClickSerial
                v4 = v2[6][2]
                v9 = v7 ~= v4
            elseif v3 >= 200 and v3 <= 241 then
                v3 = 150
                v7 = v1._.game.PlaceId
                v11 = v2[2][2]
                v4 = v11.MatchId
                v9 = v7 ~= v4
            elseif v3 >= 196 and v3 <= 199 then
                v7 = not v9
                v3 = v7 and 272 - v3 or 38805 / v3
            elseif v3 >= 192 and v3 <= 195 then
                v7 = v2[2][2].Fire
                v11 = {Name = v2[1][2], UnitId = v9.Id}
                v10 = v2[4][2]
                v11.Pos = v10.Position
                v11.CFrame = v10
                v7("TowerAdd", v11)
                return
            elseif v3 >= 242 and v3 <= 243 then
                v9 = nil
                v7 = v1._.ipairs
                v4 = v2[2][2].Equipped
                v4 = v1.h(v4())
                v7, v4, v11 = v7(v1.i(v4))
                v7, v4, v11 = v1.g(v7, v4, v11)
                v6, v10 = v7(v4, v11)
                v11 = v6
                v3 = v6 == nil and 442 - v3 or 44
            else
                v3 = v9 and 13144 / v3 or 174
            end
        end
    end
end
local function _w234(v1, v2)
    return function(v3)
        local v4 = 59
        local v5, v6, v7, v8, v9, v10, v11, v12, v13
        repeat
            if v4 == 59 then
                v4 = v3 and 227 or 45
            elseif v4 == 96 then
                v9 = v10
                v7 = "^intermission"
                v6 = v10:match("^intermission")
                v4 = v6 and 344 - v4 or 188
            elseif v4 == 146 then
                v7 = {}
                v4 = 145
                v9 = v7
            elseif v4 == 175 then
                v6 = v2[2][2]
                v11 = v6.Playing
                v4 = v11 and 212 or 108
            elseif v4 == 212 then
                v4, v6 = 320 - v4, v2[2][2]
                v11, v6 = v6.StopPlayback, "New round"
                v11("New round")
            elseif v4 == 230 then
                v5 = v2[2][2].GUI("Stats/Wave")
                v10 = v5
                v4 = v5 and 132 or 122
            elseif v4 >= 50 and v4 <= 58 then
                v6 = v2[2][2]
                v4 = 49
                v11 = v6.StopRecord
                v11()
            elseif v4 >= 46 and v4 <= 49 then
                v2[2][2].FinalSeen = nil
                v9 = v1._.game.PlaceId
                v6 = v1._.tostring(v9)
                v12 = v1._.game.JobId
                v11, v6 = v6 .. "/" .. v1._.tostring(v12), v2[1][2]
                v7 = v6
                v9 = v6.__CameraTDRoundCounters
                v4 = v9 and v4 + 96 or 195 - v4
            elseif v4 >= 15 and v4 <= 31 then
                v4 = 81
                v7 = 0
            elseif v4 >= 8 and v4 <= 14 then
                return false
            elseif v4 <= 7 then
                v7 = v2[2][2]
                v8 = v7.Close.ClickSerial
                v4, v7.Close.ClickSerial = v4 + 208, v8 + 1
                v7, v9 = nil, v7.Close
                v9.LastSend = nil
            elseif v4 >= 32 and v4 <= 45 then
                v11 = v2[2][2]
                v10 = v11.FinalSeen
                v5 = not v10
                v4 = v5 and 14 or 230
            elseif v4 >= 75 and v4 <= 95 then
                v6[v11] = v7 + 1
                v6 = v2[2][2]
                v6.RoundId = v2[1][2].__CameraTDRoundCounters[v11]
                v6.ObservedWave, v8 = 0, 0
                v6.LastWave = 0
                v6, v9 = v6, nil
                v6.WaveStartedGame = nil
                v6.WaveSessionKey = v11
                v7 = v6
                v6.AutoPlayed = nil
                v6.ReturnSent = nil
                v6.EndSent = nil
                v9, v6 = nil, v6
                v6.PlaybackCompleted = nil
                v7.PlaybackFailure, v13 = nil, 0
                v7.PlaybackIndex = 0
                v7.PlaybackTotal = 0
                v7.SkipSubmittedWave = nil
                v6 = v7.Skip
                v8, v9, v7 = nil, v7.Skip, 0
                v6.NextAt = 0
                v9.LastWave = nil
                v9 = v2[2][2]
                v6 = v9.Next
                v9 = v9.Next
                v7 = v9.Next
                v6.Vote = nil
                v9.AutoPlayback = nil
                v7.Speed = nil
                v9 = v2[2][2]
                v6 = v9.Speed
                v9, v8, v7 = v9.Speed, nil, nil
                v6.Applied = nil
                v9.Rejected = nil
                v6 = v2[2][2]
                v6.Towers, v13 = {}, {}
                v6.Pending = {}
                v6.Removed = v13
                v6 = v6.Auto
                v6.PlacePending, v7 = {}, {}
                v6.UpgradePending = v7
                v6.SlotCooldowns, v8 = {}, {}
                v6.TowerCooldowns = {}
                v6.Failures = v8
                v6.NextAt, v8 = 0, true
                v6.PlaceTurn = true
                v6.GeometryDirty = true
                v6.HydrateAt = nil
                v6.HydrateAttempts = nil
                v9 = v2[2][2]
                v9.ReportRuntime = {}
                v9.ReportStartedAt = nil
                v9.ReportEndedAt = nil
                v7 = v9
                v9 = v9.Close
                v4 = v9 and 7 or 215
            elseif v4 >= 60 and v4 <= 74 then
                v4, v9, v7, v6 = 310 - v4, v10, "^wave%s+1%s*$", v10.match
                v6 = v6(v9, "^wave%s+1%s*$")
            elseif v4 >= 123 and v4 <= 132 then
                v10 = v5.Text:lower()
            elseif v4 >= 97 and v4 <= 108 then
                v6 = v2[2][2]
                v11 = v6.Recording
                v4 = v11 and 6048 / v4 or 5292 / v4
            elseif v4 >= 109 and v4 <= 122 then
                v4 = v10 and 11712 / v4 or 367 - v4
            elseif v4 >= 176 and v4 <= 211 then
                v4 = 248
                v9 = v10
                v7 = "voting"
                v6 = v10:find("voting", 1, true)
            elseif v4 >= 213 and v4 <= 215 then
                v2[2][2].SetStatus("Macro", "New replay round: ready")
                return true
            elseif v4 >= 133 and v4 <= 145 then
                v6.__CameraTDRoundCounters = v9
                v9 = v2[1][2]
                v6 = v9.__CameraTDRoundCounters
                v7 = v9.__CameraTDRoundCounters[v11]
                v4 = v7 and 81 or 31
            elseif v4 >= 147 and v4 <= 174 then
                return false
            elseif v4 >= 216 and v4 <= 229 then
                v2[2][2].FinalSeen = true
                return false
            elseif v4 >= 231 and v4 <= 236 then
                v11 = not v6
                v4 = v11 and 164 or 175
            elseif v4 >= 237 and v4 <= 245 then
                v4 = 96
                v10 = ""
            else
                v4 = v6 and v4 + -12 or 74
            end
        until false
    end
end
local function _w235(v1, v2)
    return function(v3)
        local v4 = v1._.type(v3) == "table"
        local v5, v6
        if v4 then
            v6 = v2[1][2]
            v6, v5 = v3.Id, v6.Towers
            v4 = v5[v6]
        end
        v5 = v4
        local v7, v8, v9
        if v4 then
            v5 = v4.Level
            if v5 then
                v6 = v2[1][2].MergeTower(v3)
                v7 = v6
                if v6 then
                    v8 = v6.Level
                    if v1._.tonumber(v8) then
                        if v6.Level > v5 then
                            v7 = v2[1][2].RecordAction
                            v9 = v2[1][2].TakeStamp
                            v9 = table.pack(v9("TowerUpgrade", v6))
                            v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                        end
                    end
                    return
                elseif v7 then
                    if v6.Level > v5 then
                        v7 = v2[1][2].RecordAction
                        v9 = v2[1][2].TakeStamp
                        v9 = table.pack(v9("TowerUpgrade", v6))
                        v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                    end
                    return
                else
                    return
                end
            else
                v6 = v2[1][2].MergeTower(v3)
                v7 = v6
                if v6 then
                    v8 = v6.Level
                    if v1._.tonumber(v8) then
                        if v6.Level > 0 then
                            v7 = v2[1][2].RecordAction
                            v9 = v2[1][2].TakeStamp
                            v9 = table.pack(v9("TowerUpgrade", v6))
                            v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                        end
                    end
                    return
                elseif v7 then
                    if v6.Level > 0 then
                        v7 = v2[1][2].RecordAction
                        v9 = v2[1][2].TakeStamp
                        v9 = table.pack(v9("TowerUpgrade", v6))
                        v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                    end
                    return
                else
                    return
                end
            end
        elseif v5 then
            v6 = v2[1][2].MergeTower(v3)
            v7 = v6
            if v6 then
                v8 = v6.Level
                if v1._.tonumber(v8) then
                    if v6.Level > v5 then
                        v7 = v2[1][2].RecordAction
                        v9 = v2[1][2].TakeStamp
                        v9 = table.pack(v9("TowerUpgrade", v6))
                        v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                    end
                end
                return
            elseif v7 then
                if v6.Level > v5 then
                    v7 = v2[1][2].RecordAction
                    v9 = v2[1][2].TakeStamp
                    v9 = table.pack(v9("TowerUpgrade", v6))
                    v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                end
                return
            else
                return
            end
        else
            v6 = v2[1][2].MergeTower(v3)
            v7 = v6
            if v6 then
                v8 = v6.Level
                if v1._.tonumber(v8) then
                    if v6.Level > 0 then
                        v7 = v2[1][2].RecordAction
                        v9 = v2[1][2].TakeStamp
                        v9 = table.pack(v9("TowerUpgrade", v6))
                        v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                    end
                end
                return
            elseif v7 then
                if v6.Level > 0 then
                    v7 = v2[1][2].RecordAction
                    v9 = v2[1][2].TakeStamp
                    v9 = table.pack(v9("TowerUpgrade", v6))
                    v7("Upgrade", v6, table.unpack(v9, 1, v9.n))
                end
                return
            else
                return
            end
        end
    end
end
local function _w236(v1, v2)
    return function()
        local v3 = v2[1][2]
        local v4
        if v2[2][2].Recording == v3 then
            v4 = v2[2][2]
            v4.RecordWave = v4.Wave()
        end
    end
end
local function _w237(v1, v2)
    return function()
        local v3 = v2[1][2].Folder
        local v4 = {[1] = 2, [2] = v3 .. "/WindUI.lua"}
        v4[3] = v4
        v3 = {[1] = 2, [2] = v3}
        v3[3] = v3
        local v5, v6, v7
        v6, v3[2], v5, v7 = v1._.readfile, v1:dc({v4}), v1._.type, v1:cc()
        v5 = v5(v6)
        local v8, v9, v10, v11, v12
        if v5 == "function" then
            v6 = v1._.readfile
            v8 = v4[2]
            v5, v6 = v1._.pcall(v6, v8)
            if v5 then
                v8 = v7(v6)
                if v8 then
                    v2[1][2].LoadTimes.WindUI = "Cache"
                    v12 = v1._.tonumber
                    v9 = v6.match
                    v9 = table.pack(v9(v6, "^%-%- CameraWindUICache (%d+)"))
                    v12 = v12(table.unpack(v9, 1, v9.n))
                    if v12 then
                        if v1._.os.time() - v12 >= 86400 then
                            v11 = v1._.task
                            v10, v9, v11 = v1:bc({v3, v2[1]}), v11.delay, 15
                            v9(15, v10)
                        end
                        return v8
                    elseif v1._.os.time() - 0 >= 86400 then
                        v11 = v1._.task
                        v10, v9, v11 = v1:bc({v3, v2[1]}), v11.delay, 15
                        v9(15, v10)
                        return v8
                    else
                        return v8
                    end
                else
                    v5 = v1._.game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
                    v6 = v7(v5)
                    if not v6 then
                        v1._.error("WindUI source could not initialize", 0)
                    end
                    v3[2](v5)
                    v2[1][2].LoadTimes.WindUI = "Network"
                    return v6
                end
            else
                v5 = v1._.game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
                v6 = v7(v5)
                if not v6 then
                    v1._.error("WindUI source could not initialize", 0)
                end
                v3[2](v5)
                v2[1][2].LoadTimes.WindUI = "Network"
                return v6
            end
        else
            v5 = v1._.game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
            v6 = v7(v5)
            if not v6 then
                v1._.error("WindUI source could not initialize", 0)
            end
            v3[2](v5)
            v2[1][2].LoadTimes.WindUI = "Network"
            return v6
        end
    end
end
local function _w238(v1, v2)
    return function()
        local v3 = v2[1][2]
        v3.CancelJoinWalk()
        v3.JoinWalkExit = nil
        v3.LobbyAttempt = nil
        local v4
        if v3.Elevator then
            v4 = v2[1][2]
            v2[1][2].Invoke("ElevatorLeave", v4.Elevator)
        end
    end
end
local function _w239(v1, v2)
    return function()
        v2[1][2].Window:Destroy()
    end
end
local function _w240(v1, v2, v3, v4)
    v1.Fe[v4] = bit32.band(bit32.bnot(bit32.band(v3, 65535)), bit32.band(65535, v2)) * bit32.band(bit32.bnot(bit32.band(65535, v2)), bit32.band(65535, v3)) + bit32.band(bit32.band(65535, v2), bit32.band(v3, 65535)) * bit32.bor(bit32.band(v3, 65535), bit32.band(v2, 65535)) - bit32.band(65535, v3) * bit32.band(v2, 65535) + (bit32.bnot(bit32.bnot(v2)) + (bit32.bnot(bit32.bxor(v2, 4294967295)) + v3 + -v2))
    return v1.Fe[v4]
end
local function _w241(v1, v2)
    return function()
        local v3 = v2[1][2].Folder
        local v4
        if not v1._.isfolder(v3) then
            v4 = v2[1][2]
            v1._.makefolder(v4.Folder)
        end
        v3 = v2[1][2].SettingsFolder
        if not v1._.isfolder(v3) then
            v4 = v2[1][2].SettingsFolder
            v1._.makefolder(v4)
        end
        while true do
        end
    end
end
local function _w242(v1, v2, v3, v4)
    v1.jf[v4] = bit32.bxor(4294967295, bit32.bnot(v2)) + (bit32.band(bit32.band(v3, 65535), bit32.band(65535, v3)) * bit32.bor(bit32.band(v3, 65535), bit32.band(v3, 65535)) + bit32.band(bit32.bnot(bit32.band(65535, v3)), bit32.band(65535, v3)) * bit32.band(bit32.bnot(bit32.band(v3, 65535)), bit32.band(65535, v3)) - bit32.band(65535, v3) * bit32.band(65535, v3) + bit32.band(bit32.bor(v3, v2), bit32.band(v3, 4294967295)))
    return v1.jf[v4]
end
local function _w243(v1, v2)
    return function(v3)
        v2[2][2].AutoSkip = v3 == true
        v2[1][2].Skip.NextAt = 0
        v2[1][2].SaveSettings()
    end
end
local function _w244(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5 = v1._.math.clamp
        local v6 = v1._.tonumber(v3)
        if v6 then
            v4.PlacementRange = v5(v6, 0, 100)
        else
            v4.PlacementRange = v5(0, 0, 100)
        end
        v4 = v2[1][2]
        v4.Candidate = 0
        v4.SaveSettings()
    end
end
local function _w245(v1, v2)
    return function(v3, v4)
        local v5 = 57
        local v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
        while true do
            if v5 == 5 then
                v7 = v15[2].LastMoveAt
                v5 = v7 and 40 / v5 or 153 - v5
            elseif v5 == 8 then
                v5, v8, v7 = 952 / v5, v10 - v7, 6
                v14 = v8 >= 6
            elseif v5 == 39 then
                v15 = v2[2][2]
                v15.CancelJoinWalk()
                v13, v15, v10 = v15.SetStatus, "Lobby", "Waiting for character"
                v13("Lobby", "Waiting for character")
                return false
            elseif v5 == 51 then
                v8 = v15[2].Index
                v12 = v15[2].Points[v8]
                v14 = not v12
                v5 = v14 and v5 + 31 or 52
            elseif v5 == 52 then
                v7 = v15[2].Index
                v14 = v15[2].LastMoveIndex ~= v7
                v5 = v14 and 119 or 260 / v5
            elseif v5 == 68 then
                v9 = v11[2]
                v13 = "HumanoidRootPart"
                v5, v6 = 14076 / v5, v11[2].FindFirstChild(v9, "HumanoidRootPart")
            elseif v5 == 89 then
                v5 = v10 and 298 - v5 or 21271 / v5
            elseif v5 == 96 then
                v6, v5, v9 = v2[4][2].JoinMethod, v5 + 124, "Walk"
                v11 = v6 ~= "Walk"
            elseif v5 == 115 then
                v14 = v15[2].Points
                v12 = not v14
                v5 = v12 and 244 or v5 + -100
            elseif v5 == 123 then
                v13 = v11[2]
                v15 = "Humanoid"
                v5, v9 = 4920 / v5, v11[2].FindFirstChildOfClass(v13, "Humanoid")
            elseif v5 == 126 then
                v5, v14 = 360 - v5, true
                v9[2].Jump = true
            elseif v5 == 138 then
                v5, v9 = 28290 / v5, v1._.game
                v13 = v2[2][2]
                v6 = v9.PlaceId
                v9 = v13.LobbyId
                v11 = v6 ~= v9
            elseif v5 == 153 then
                v5 = v11 and v5 + 67 or v5 + -57
            elseif v5 == 154 then
                v10 = v1._.os.clock()
                v12 = not v15[2]
                v5 = v12 and 7 or 321 - v5
            elseif v5 == 159 then
                v14 = v15[2].NextPlanAt
                v5, v12 = v5 + -127, v10 >= v14
            elseif v5 == 184 then
                v5, v13 = 42688 / v5, not v9[2]
            elseif v5 == 196 then
                v10 = v2[2][2]
                v13 = v1:Ac()
                v15 = {[1] = 2, [2] = v10.JoinWalk}
                v15[3] = v15
                v10 = v15[2]
                v5 = v10 and 200 - v5 or 209
            elseif v5 == 207 then
                v6 = {[1] = 2, [2] = v6}
                v6[3] = v6
                v9 = v11[2]
                v5 = v9 and v5 + -84 or v5 + -167
            elseif v5 == 232 then
                v5 = v13 and 150 or v5 + -133
            elseif v5 == 235 then
                v12 = v6[2].Position
                v15[2].ProgressPosition = v12
                v5, v15[2].ProgressAt = 54, v10
            elseif v5 == 248 then
                v2[2][2].CancelJoinWalk()
                return false
            elseif v5 >= 97 and v5 <= 111 then
                v5 = 150
                v15 = v9[2].Health
                v10 = 0
                v13 = v15 <= 0
            elseif v5 >= 90 and v5 <= 95 then
                v14 = v15[2].Index
                v7 = v15[2].Points
                v12 = v14 <= #v7
                v5 = v12 and 27 or 6696 / v5
            elseif v5 >= 69 and v5 <= 72 then
                v5 = v12 and 223 or 3672 / v5
            elseif v5 >= 73 and v5 <= 88 then
                v15[2].Points = nil
                return false
            elseif v5 >= 112 and v5 <= 114 then
                v11 = {[1] = 2, [2] = v2[1][2].Character}
                v11[3] = v11
                v6 = v11[2]
                v5 = v6 and 68 or 23184 / v5
            elseif v5 >= 116 and v5 <= 122 then
                v5 = v14 and 25228 / v5 or 158
            elseif v5 >= 124 and v5 <= 125 then
                v12 = v2[2][2]
                v10 = v12.CancelJoinWalk
                v10()
                v5, v15[2] = 186, nil
            elseif v5 >= 127 and v5 <= 137 then
                return false
            elseif v5 >= 6 and v5 <= 7 then
                v12 = {
                    Character = v11[2],
                    Root = v6[2],
                    Humanoid = v9[2],
                    Position = v3[2],
                    Target = v4[2],
                    ProgressPosition = v6[2].Position,
                    ProgressAt = v10,
                    NextPlanAt = 0,
                }
                v15[2], v12 = v12, v2[2][2]
                v12.JoinWalk = v15[2]
                v14 = v1._.task
                v14, v12 = v1:yc({v3, v2[3], v2[1], v9, v11, v15, v2[2], v4, v2[4], v6}), v14.spawn
                v5 = 167
                v12(v14)
            elseif v5 <= 4 then
                v12 = v15[2].Character
                v10 = v12 ~= v11[2]
                v5 = v10 and v5 + 85 or 17
            elseif v5 >= 18 and v5 <= 31 then
                v14 = v6[2].Position
                v7 = 2
                v5 = 72
                v12 = v13(v14, v15[2].Points[v15[2].Index].Position, 2)
            elseif v5 >= 16 and v5 <= 17 then
                v12 = v15[2].Target
                v5, v10 = 106 - v5, v12 ~= v4[2]
            elseif v5 >= 9 and v5 <= 15 then
                v14 = v10 - v15[2].ProgressAt
                v5 = 244
                v12 = v14 >= 3
            elseif v5 >= 40 and v5 <= 50 then
                v9 = {[1] = 2, [2] = v9}
                v9[3] = v9
                v13 = not v6[2]
                v5 = v13 and 9280 / v5 or 184
            elseif v5 >= 32 and v5 <= 38 then
                v5 = v12 and 147 - v5 or 7808 / v5
            elseif v5 >= 55 and v5 <= 67 then
                v3 = {[1] = 2, [2] = v3}
                v3[3] = v3
                v4 = {[1] = 2, [2] = v4}
                v4[3] = v4
                v9 = v2[2][2]
                v6 = v9.Running
                v11 = not v6
                v5 = v11 and 153 or 152
            elseif v5 >= 53 and v5 <= 54 then
                v14 = v2[2][2].JoinPathBusy
                v12 = not v14
                v5 = v12 and 159 or 32
            elseif v5 >= 168 and v5 <= 183 then
                v14 = v15[2].Points
                v12 = not v14
                v5 = v12 and 23427 / v5 or 93
            elseif v5 >= 160 and v5 <= 167 then
                v7 = v15[2].ProgressPosition
                v14 = 0.75
                v12 = (v6[2].Position - v7).Magnitude
                v5 = v12 >= 0.75 and 402 - v5 or 54
            elseif v5 >= 197 and v5 <= 203 then
                v2[2][2].CancelJoinWalk()
                return true
            elseif v5 >= 185 and v5 <= 195 then
                v14 = v3[2]
                v12 = v6[2].Position
                v10 = v13(v12, v14, 2.5)
                v5 = v10 and 203 or 154
            elseif v5 >= 155 and v5 <= 158 then
                return false
            elseif v5 >= 151 and v5 <= 152 then
                v9 = v2[4][2]
                v6 = v9.AutoLobby
                v5 = 153
                v11 = not v6
            elseif v5 >= 149 and v5 <= 150 then
                v5 = v13 and 5850 / v5 or 346 - v5
            elseif v5 >= 139 and v5 <= 148 then
                v5, v7 = 156 - v5, -v1._.math.huge
            elseif v5 >= 221 and v5 <= 231 then
                v14 = v15[2].Index
                v5 = 93
                v12 = v14 + 1
                v15[2].Index = v12
            elseif v5 >= 213 and v5 <= 220 then
                v5 = v11 and 45100 / v5 or 358 - v5
            elseif v5 >= 208 and v5 <= 209 then
                v5 = v10 and 124 or 38874 / v5
            elseif v5 >= 204 and v5 <= 206 then
                v5 = v11 and 248 or v5 + -93
            elseif v5 >= 210 and v5 <= 212 then
                v14 = v12.Action
                v7 = v1._.Enum.PathWaypointAction
                v8 = v7.Jump
                v5 = v14 == v8 and v5 + -86 or 234
            elseif v5 >= 240 and v5 <= 247 then
                v5 = v12 and 254 or 41724 / v5
            elseif v5 >= 233 and v5 <= 234 then
                v5 = 158
                v8 = v9[2]
                v7 = v12.Position
                v9[2].MoveTo(v8, v7)
                v14 = v15[2].Index
                v15[2].LastMoveIndex = v14
                v15[2].LastMoveAt = v10
            elseif v5 >= 236 and v5 <= 239 then
                v5, v8 = v5 + -30, v15[2].Position
                v14 = 2
                v12 = (v8 - v3[2]).Magnitude
                v10 = v12 > 2
            else
                v5, v15[2].NextPlanAt = 171, v10 + 4
                v2[2][2].JoinPathBusy = true
                v12 = v1._.task.spawn
                v14 = v1:zc({v2[1], v3, v15, v11, v2[4], v2[2], v6})
                v12(v14)
            end
        end
    end
end
local function _w246(v1, v2)
    return function()
        local v3 = v1:Wc({v2[2]})
        v3(v2[2][2].Remote("Notificate"), v2[2][2].SpeedNotice)
        v3(v2[2][2].Remote("TowerAdd"), v1:Tc({v2[2]}))
        v3(v2[2][2].Remote("TowerUpgrade"), v1:Xc({v2[2]}))
        v3(v2[2][2].Remote("TowerTarget"), v1:Uc({v2[2]}))
        v3(v2[2][2].Remote("TowerRemove"), v1:Yc({v2[2]}))
        v3(v2[2][2].Remote("ElevatorEntered"), v1:_d({v2[2]}))
        v3(v2[2][2].Remote("ElevatorLeft"), v1:Vc({v2[2]}))
        v3(v2[2][2].Remote("ElevatorTeleporting"), v1:ad({v2[2]}))
        local remoteEvents = v2[3][2]:FindFirstChild("RemoteEvents")
        local v4 = v3
        local v5 = remoteEvents
        if remoteEvents then
            v4(remoteEvents:FindFirstChild("ReplicaCreate"), v1:Rc({v2[2], v2[1]}))
        else
            v4(v5, v1:Rc({v2[2], v2[1]}))
        end
        v5 = remoteEvents
        v4 = v3
        if remoteEvents then
            v4(remoteEvents:FindFirstChild("ReplicaSet"), v1:Sc({v2[2]}))
        else
            v4(v5, v1:Sc({v2[2]}))
        end
    end
end
local function _w247(v1, v2)
    return function(v3)
        v3 = {[1] = 2, [2] = v3}
        v3[3] = v3
        local v4 = v3[2]
        local isA2 = v3[2].IsA(v4, "TextLabel")
        local v5
        if isA2 then
            v5 = not isA2
        else
            v4 = v3[2]
            v5 = not v3[2].IsA(v4, "TextButton")
        end
        local v6, v7, v8, v9
        if v5 then
            if not v5 then
                v5 = v3[2].Name:lower()
                if v5 ~= "ownername" then
                    if not v5:find("playername", 1, true) then
                        if not v5:find("displayname", 1, true) then
                            v6 = v2[2][2]
                            v6, v4 = v3[2].Text, v6.IsOwnNameText
                            if v4(v6) then
                                v2[2][2].NameWatched[v3[2]] = true
                                isA2 = v1:pd({v3, v2[2], v2[1]})
                                v9 = v2[2][2]
                                v4 = v1._.table.insert
                                v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                                v9 = v9(v7, "Text")
                                v7, v9, v8 = v9, v9.Connect, isA2
                                v9 = table.pack(v9(v7, v8))
                                v4(v6, table.unpack(v9, 1, v9.n))
                                isA2()
                            end
                        else
                            v2[2][2].NameWatched[v3[2]] = true
                            isA2 = v1:pd({v3, v2[2], v2[1]})
                            v9 = v2[2][2]
                            v4 = v1._.table.insert
                            v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                            v9 = v9(v7, "Text")
                            v7, v9, v8 = v9, v9.Connect, isA2
                            v9 = table.pack(v9(v7, v8))
                            v4(v6, table.unpack(v9, 1, v9.n))
                            isA2()
                        end
                    else
                        v2[2][2].NameWatched[v3[2]] = true
                        isA2 = v1:pd({v3, v2[2], v2[1]})
                        v9 = v2[2][2]
                        v4 = v1._.table.insert
                        v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                        v9 = v9(v7, "Text")
                        v7, v9, v8 = v9, v9.Connect, isA2
                        v9 = table.pack(v9(v7, v8))
                        v4(v6, table.unpack(v9, 1, v9.n))
                        isA2()
                    end
                else
                    v2[2][2].NameWatched[v3[2]] = true
                    isA2 = v1:pd({v3, v2[2], v2[1]})
                    v9 = v2[2][2]
                    v4 = v1._.table.insert
                    v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                    v9 = v9(v7, "Text")
                    v7, v9, v8 = v9, v9.Connect, isA2
                    v9 = table.pack(v9(v7, v8))
                    v4(v6, table.unpack(v9, 1, v9.n))
                    isA2()
                end
                return
            end
        elseif v2[2][2].NameWatched[v3[2]] then
            return
        else
            v5 = v3[2].Name:lower()
            if v5 ~= "ownername" then
                if not v5:find("playername", 1, true) then
                    if not v5:find("displayname", 1, true) then
                        v6 = v2[2][2]
                        v6, v4 = v3[2].Text, v6.IsOwnNameText
                        if v4(v6) then
                            v2[2][2].NameWatched[v3[2]] = true
                            isA2 = v1:pd({v3, v2[2], v2[1]})
                            v9 = v2[2][2]
                            v4 = v1._.table.insert
                            v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                            v9 = v9(v7, "Text")
                            v7, v9, v8 = v9, v9.Connect, isA2
                            v9 = table.pack(v9(v7, v8))
                            v4(v6, table.unpack(v9, 1, v9.n))
                            isA2()
                        end
                    else
                        v2[2][2].NameWatched[v3[2]] = true
                        isA2 = v1:pd({v3, v2[2], v2[1]})
                        v9 = v2[2][2]
                        v4 = v1._.table.insert
                        v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                        v9 = v9(v7, "Text")
                        v7, v9, v8 = v9, v9.Connect, isA2
                        v9 = table.pack(v9(v7, v8))
                        v4(v6, table.unpack(v9, 1, v9.n))
                        isA2()
                    end
                else
                    v2[2][2].NameWatched[v3[2]] = true
                    isA2 = v1:pd({v3, v2[2], v2[1]})
                    v9 = v2[2][2]
                    v4 = v1._.table.insert
                    v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                    v9 = v9(v7, "Text")
                    v7, v9, v8 = v9, v9.Connect, isA2
                    v9 = table.pack(v9(v7, v8))
                    v4(v6, table.unpack(v9, 1, v9.n))
                    isA2()
                end
            else
                v2[2][2].NameWatched[v3[2]] = true
                isA2 = v1:pd({v3, v2[2], v2[1]})
                v9 = v2[2][2]
                v4 = v1._.table.insert
                v8, v7, v9, v6 = "Text", v3[2], v3[2].GetPropertyChangedSignal, v9.NameConnections
                v9 = v9(v7, "Text")
                v7, v9, v8 = v9, v9.Connect, isA2
                v9 = table.pack(v9(v7, v8))
                v4(v6, table.unpack(v9, 1, v9.n))
                isA2()
            end
            return
        end
    end
end
local function _w248(v1, v2)
    return function(v3)
        local v4 = 100
        local v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
        while true do
            if v4 == 51 then
                v9(v12, v6)
                v4 = v3 and 248 - v4 or 84
            elseif v4 == 84 then
                v12 = v2[2][2].FPSOriginal
                v9, v12, v6 = v1._.pairs(v12)
                v9, v12, v6 = v1.g(v9, v12, v6)
                v8, v10 = v9(v12, v6)
                v6 = v8
                v4 = v8 == nil and 69 or 107
            elseif v4 == 106 then
                v8, v10 = v9(v12, v6)
                v6 = v8
                v4 = v8 == nil and 175 - v4 or 107
            elseif v4 == 107 then
                v8 = {[1] = 2, [2] = v8}
                v8[3] = v8
                v11, v5, v13 = v1._.pairs(v10)
                v11, v5, v13 = v1.g(v11, v5, v13)
                v14, v7 = v11(v5, v13)
                v13 = v14
                v4 = v14 == nil and 229 or 26964 / v4
            elseif v4 == 188 then
                v4 = 133
                v6 = "Disabling effects, shadows and post-processing"
            elseif v4 == 229 then
                v4 = 24274 / v4
            elseif v4 >= 108 and v4 <= 187 then
                v4 = v6 and 51 or 227
            elseif v4 >= 189 and v4 <= 226 then
                v6 = "GlobalShadows"
                v8 = false
                v12 = v2[4][2]
                v4 = 6
                v2[2][2].FPSSet(v12, "GlobalShadows", false)
                v9 = v1._.task.spawn
                v12 = v1:ac({v2[1], v2[3], v2[4], v2[2]})
                v9(v12)
            elseif v4 >= 227 and v4 <= 228 then
                v4, v6 = 11577 / v4, "Original effects and shadows restored"
            elseif v4 >= 230 then
                v14 = {[1] = 2, [2] = v14}
                v14[3] = v14
                v7 = {[1] = 2, [2] = v7}
                v7[3] = v7
                v4 = 48
                v1._.pcall(v1:_c({v7, v8, v14}))
            elseif v4 >= 7 and v4 <= 50 then
                v14, v7 = v11(v5, v13)
                v13 = v14
                v4 = v14 == nil and 229 or v4 + 204
            elseif v4 >= 52 and v4 <= 83 then
                v9 = v2[2][2]
                v12 = v1._.setmetatable
                v6, v4, v10, v8 = {}, 414 / v4, "k", {}
                v8.__mode = "k"
                v12 = v12(v6, v8)
                v9.FPSOriginal = v12
            elseif v4 >= 85 and v4 <= 105 then
                v9 = v2[2][2].SetStatus
                v12 = "Performance"
                v6 = v3
                v4 = v6 and 188 or 133
            end
        end
    end
end
local function _w249(v1, v2, v3, v4, v5)
    v1.pf[v5] = bit32.bxor(bit32.bnot(bit32.band(v3, v4)), bit32.bnot(v2)) + (bit32.band(bit32.band(65535, v2), bit32.bnot(bit32.band(v2, 65535))) * bit32.band(bit32.bnot(bit32.band(v2, 65535)), bit32.band(v2, 65535)) + bit32.band(bit32.band(v2, 65535), bit32.band(65535, v2)) * bit32.bor(bit32.band(v2, 65535), bit32.band(65535, v2)) - bit32.band(65535, v2) * bit32.band(v2, 65535))
    return v1.pf[v5]
end
local function _w250(v1, v2)
    return function()
        local v3 = 42
        local v4, v5, v6, v7, v8, getPropertyChangedSignal
        while true do
            if v3 >= 157 then
                if v3 < 191 then
                    if v3 < 173 then
                        if v3 <= 157 then
                            v2[2][2].Notify("Wait for outstanding Auto Play requests before recording")
                        else
                            v2[2][2].SetStatus("Macro", "Recording: 0 confirmed actions")
                            v2[2][2].SetToggle("Record", true)
                        end
                        return
                    elseif v3 >= 176 then
                        if v3 > 176 then
                            v7 = v2[2][2]
                            v4 = v7.Auto
                            v3 = v4 and v3 + -8 or 239
                        else
                            v3, v7 = v3 + 51, v2[2][2]
                            v4, v7 = v7.Notify, "Recorder hook unavailable; manual Skip and sells cannot be recorded; upgrade/target use incoming confirmations"
                            v4("Recorder hook unavailable; manual Skip and sells cannot be recorded; upgrade/target use incoming confirmations")
                        end
                    else
                        v7 = v2[2][2].Auto
                        v3 = 239
                        v4 = v7.Busy()
                    end
                elseif v3 < 228 then
                    if v3 < 215 then
                        v2[2][2].Notify("Create / select a macro first")
                        return
                    elseif v3 > 215 then
                        v4 = v2[2][2]
                        v4.Pending = {}
                        v4.LastWave = v4.Wave()
                        v8 = {}
                        v8.At = v1._.os.clock()
                        v8.GameAt = v4.GameClock()
                        v8.Counter = 0
                        v8.Keys = {}
                        v5 = {Game = "CameraTD", Version = 1}
                        v5.Map = v4.CurrentMap()
                        v6 = v2[1][2]
                        v5.LobbyMap = v6.Map
                        v5.Difficulty = v6.Difficulty
                        v5.Created = v1._.os.time()
                        v5.TimeBasis = "GameSeconds"
                        v5.RecordedSpeed = v4.Speed.Value
                        v5.Actions = {}
                        v8.Profile = v5
                        v4.Recording = v8
                        v8 = v4
                        v4.RecordWave = v4.Wave()
                        v4 = {[1] = 2, [2] = v8.Recording}
                        v4[3] = v4
                        v7, v8 = v8.GUI, "Stats/Wave"
                        v7 = v7("Stats/Wave")
                        v3 = v7 and 153 or 394 - v3
                    else
                        v2[2][2].Notify("Recording needs executor filesystem support")
                        return
                    end
                elseif v3 > 230 then
                    v3 = v4 and 157 or v3 + -11
                elseif v3 <= 228 then
                    v2[1][2].AutoPlayback = false
                    v7 = v2[2][2]
                    v7.SaveSettings()
                    v7, v4, v8 = "Playback", v7.SetToggle, false
                    v4("Playback", false)
                    v7 = v2[2][2]
                    v7.Hydrate()
                    v7, v4 = 0, #v7.Owned()
                    v3 = v4 > 0 and 79 or 26676 / v3
                else
                    v4 = v2[1][2].Profile
                    v7 = ""
                    v3 = v4 == "" and 421 - v3 or 9
                end
            elseif v3 > 84 then
                if v3 <= 143 then
                    if v3 < 117 then
                        v3 = v4 and 9576 / v3 or v3 + -88
                    elseif v3 > 117 then
                        v7 = v2[2][2]
                        v3 = 114
                        v4 = v7.Recording
                    else
                        v4 = v2[2][2]
                        v4.HookOK = v4.InstallRecorderHook()
                        v7 = v4.HookOK
                        v4 = not v7
                        v3 = v4 and 176 or 227
                    end
                else
                    getPropertyChangedSignal = v7.GetPropertyChangedSignal
                    v8 = v2[2][2].Connect(getPropertyChangedSignal(v7, "Text"), v1:bd({v4, v2[2]}))
                    v3, v4[2].WaveConnection = 25551 / v3, v8
                end
            elseif v3 < 43 then
                if v3 < 26 then
                    v7 = v2[2][2].FS
                    v4 = not v7
                    v3 = v4 and 215 or 181
                elseif v3 > 26 then
                    v7 = v2[2][2]
                    v4 = v7.Playing
                    v3 = v4 and 114 or 143
                else
                    v7 = v2[2][2].Active()
                    v4 = not v7
                    v3 = v4 and 43 or 230
                end
            elseif v3 > 79 then
                v2[2][2].Notify("Stop the active macro first")
                return
            elseif v3 > 43 then
                v2[2][2].Notify("Start with no owned towers so the macro has a complete placement history")
                return
            else
                v2[2][2].Notify("Start recording in match intermission / wave 0 or later")
                return
            end
        end
    end
end
local function _w251(v1, v2)
    return function()
        local v3, v4
        if v2[2][2].AntiAFK then
            v4 = v1._.game
            v4, v3 = v4.GetService, v4
            v4 = {[1] = 2, [2] = v4(v3, "VirtualUser")}
            v4[3] = v4
            if not v1._.pcall(v1:Pc({v4})) then
                v2[1][2].Notify("Anti-AFK VirtualUser input unavailable in this executor")
            end
        end
    end
end
local function _w252(v1, v2)
    return function(v3, v4)
        local v5 = not v3
        local v6, v7
        if v5 then
            if not v5 then
                v2[1][2].Bound[v3] = true
                v7 = v2[1][2]
                v6, v7, v5 = v4, v3.OnClientEvent, v7.Connect
                v5(v7, v6)
                return
            end
        elseif v2[1][2].Bound[v3] then
            return
        else
            v2[1][2].Bound[v3] = true
            v7 = v2[1][2]
            v6, v7, v5 = v4, v3.OnClientEvent, v7.Connect
            v5(v7, v6)
            return
        end
    end
end
local function _w253(v1, v2)
    return function()
        local v3, v4
        v3 = v2[1][2].Running
        if not v3 then
            break
        end
        v4 = v2[1][2].ActivityLogger
        v1._.pcall(v4)
        v3(1)
    end
end
local function _w254(v1, v2)
    return function()
        local v3 = 51
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
        repeat
            if v3 == 11 then
                v3 = v11 and 254 or 176
            elseif v3 == 24 then
                v11 = v1._.os.clock()
                v12 = v14[2].GeometryAt
                v3 = v12 and 205 or v3 + 101
            elseif v3 == 39 then
                v3, v16 = 4134 / v3, v18.Magnitude
                v13 = v18 / v16
            elseif v3 == 55 then
                v3, v12 = v3 + 75, {}
                v10 = v12
            elseif v3 == 89 then
                v8, v13, v3, v18 = v1._.table.insert, v7, 19402 / v3, v11
                v8(v18, v13)
            elseif v3 == 106 then
                v3 = v13 and v3 + 55 or v3 + 82
            elseif v3 == 134 then
                v3 = v20 and v3 + 47 or 65
            elseif v3 == 155 then
                v3 = 101
                v11 = v5
                v10 = v5:GetChildren()
            elseif v3 == 164 then
                v12, v15 = v5(v10, v11)
                v11 = v12
                v3 = v12 == nil and v3 + 25 or 199
            elseif v3 == 165 then
                return nil
            elseif v3 == 182 then
                v11 = v1._.table.sort
                v12 = v10
                v15 = v1:wd()
                v11(v12, v15)
                v11 = v10[1]
                v3 = v11 and 105 or 11
            elseif v3 == 189 then
                v14[2].MapConnections = {}
                v14[2].Map = v4[2]
                v5 = -v1._.math.huge
                v14[2].GeometryAt = v5
                v14[2].GeometryDirty = true
                v14[2].PlacePending = {}
                v3, v10 = v3 + -165, {}
                v14[2].UpgradePending = v10
                v14[2].Failures = {}
                v14[2].SlotCooldowns = {}
                v14[2].TowerCooldowns = {}
                v5 = v1:vd({v14, v4})
                v10 = v1._.table.insert
                v11 = v14[2].MapConnections
                v12 = v4[2].DescendantAdded
                v12, v15 = v12.Connect, v12
                v12 = table.pack(v12(v15, v5))
                v10(v11, table.unpack(v12, 1, v12.n))
                v11 = v1._.table
                v12, v11, v6, v10 = v4[2].DescendantRemoving, v14[2].MapConnections, v5, v11.insert
                v12, v15 = v12.Connect, v12
                v12 = v1.h(v12(v15, v6))
                v10(v11, table.unpack(v12, 1, v12.n))
            elseif v3 == 198 then
                v5 = v14[2].Points
                v3 = v5 and 343 - v3 or v3 + -198
            elseif v3 == 199 then
                v21 = v15
                v6 = v15.Disconnect
                v3 = 32636 / v3
                v6(v15)
            elseif v3 == 220 then
                v3 = 198
                v1._.table.sort(v11, v1:xd())
                v14[2].Points = v11
                v6 = "TowerArea"
                v15 = v4[2]
                v12 = v4[2].FindFirstChild(v15, "TowerArea")
                v14[2].Area = v12
            elseif v3 == 236 then
                v3 = v5 and 213 or 198
            elseif v3 >= 93 and v3 <= 97 then
                v13 = 1
                v21 = v5[v12 - 1].Position
                v7 = v5[v12].Position
                v18 = v7 - v21
                v8 = v18.Magnitude
                v3 = v11 <= v8 and 152 or 7954 / v3
            elseif v3 >= 90 and v3 <= 92 then
                v7 = v5[v11].Position
                v13 = v11 - 1
                v18 = v5[v13]
                v8 = v18.Position
                v21 = v7 - v8
                v6 = v21.Magnitude
                v3, v10 = 255, v10 + v6
            elseif v3 >= 98 and v3 <= 101 then
                v3 = v10 and 18382 / v3 or 240
            elseif v3 >= 102 and v3 <= 105 then
                v6 = "BasePart"
                v12 = v10[1]:IsA("BasePart")
                v3 = 11
                v11 = not v12
            elseif v3 >= 107 and v3 <= 111 then
                v3, v8 = 9768 / v3, v6.Magnitude
                v7 = v6 / v8
            elseif v3 >= 112 and v3 <= 114 then
                v12 = v12 + v6
                v3 = (v6 > 0 and v12 > v15 or v6 <= 0 and v12 < v15 or false) and v3 + 44 or 97
            elseif v3 >= 115 and v3 <= 129 then
                v3, v6 = 25625 / v3, v1._.math
                v15 = v6.huge
                v12 = -v15
            elseif v3 >= 130 and v3 <= 133 then
                v5, v10, v11 = v5(v10)
                v5, v10, v11 = v1.g(v5, v10, v11)
                v12, v15 = v5(v10, v11)
                v11 = v12
                v3 = v12 == nil and 24570 / v3 or 199
            elseif v3 >= 135 and v3 <= 151 then
                v11 = 0
                v10 = #v5
                v3 = v10 == 0 and 165 or 22765 / v3
            elseif v3 >= 12 and v3 <= 23 then
                v15 = #v5
                v6 = 1
                v12 = 2
                v11 = v10 * v2[1][2].PlacementRange / 100
                v3 = (2 > v15 or false) and 179 - v3 or 2037 / v3
            elseif v3 >= 1 and v3 <= 10 then
                return v21, v7
            elseif v3 <= 0 then
                v10 = {}
                v3, v5 = 145 - v3, v10
            elseif v3 >= 40 and v3 <= 44 then
                v18 = v7
                v13 = "BasePart"
                v8 = v7:IsA("BasePart")
                v3 = v8 and 3916 / v3 or 218
            elseif v3 >= 25 and v3 <= 38 then
                v14 = {[1] = 2, [2] = v2[3][2].Auto}
                v14[3] = v14
                v5 = v14[2].Map
                v3 = v5 ~= v4[2] and v3 + 150 or 864 / v3
            elseif v3 >= 86 and v3 <= 88 then
                v3 = v7 and 10 or 7480 / v3
            elseif v3 >= 83 and v3 <= 85 then
                v3 = 10
                v18 = 0
                v8 = 1
                v13 = 0
                v7 = v1._.Vector3.new(1, 0, 0)
            elseif v3 >= 66 and v3 <= 82 then
                v3, v11 = 114, v11 - v8
            elseif v3 >= 56 and v3 <= 65 then
                v3, v20 = v3 + 116, 0
            elseif v3 >= 45 and v3 <= 54 then
                v5 = "Game"
                v4 = v2[2][2]
                v4, v14 = v4.FindFirstChild, v4
                v4 = {[1] = 2, [2] = v4(v14, "Game")}
                v4[3] = v4
                v14 = not v4[2]
                v3 = v14 and 168 or 36
            elseif v3 >= 177 and v3 <= 181 then
                return v21:Lerp(v17, v20), v13
            elseif v3 >= 169 and v3 <= 176 then
                v11 = {}
                v12, v15, v6 = v1._.ipairs(v10)
                v12, v15, v6 = v1.g(v12, v15, v6)
                v21, v7 = v12(v15, v6)
                v6 = v21
                v3 = v21 == nil and 220 or v3 + -132
            elseif v3 >= 183 and v3 <= 186 then
                v10 = v14[2].MapConnections
                v5 = v1._.ipairs
                v3 = v10 and 130 or 10230 / v3
            elseif v3 >= 187 and v3 <= 188 then
                v3, v13, v16, v19 = 349 - v3, v1._.Vector3.new, 1, 0
                v13 = v13(1, 0, 0)
            elseif v3 >= 158 and v3 <= 160 then
                v12 = v5[v1._.math.max(1, #v5 - 1)].Position
                v15 = v5[#v5].Position
                v7 = v15.X
                v8 = v12.X
                v8, v7, v21, v18 = v15.Z, 0, v7 - v8, v12.Z
                v6 = v1._.Vector3.new(v21, 0, v8 - v18)
                v21 = v15
                v18 = 0
                v8 = v6.Magnitude
                v7 = v8 > 0
                v3 = v7 and 111 or 88
            elseif v3 >= 152 and v3 <= 154 then
                v19 = v21.X
                v16 = v7.X
                v19, v9, v13, v16 = v7.Z, v21.Z, v16 - v19, 0
                v18 = v1._.Vector3.new(v13, 0, v19 - v9)
                v13 = v18.Magnitude > 0
                v3 = v13 and 39 or 106
            elseif v3 >= 156 and v3 <= 157 then
                v10 = 0
                v12 = #v5
                v11 = 2
                v15 = 1
                v3 = (2 > v12 or false) and 178 - v3 or 92
            elseif v3 >= 166 and v3 <= 168 then
                return nil
            elseif v3 >= 161 and v3 <= 163 then
                v17 = v7
                v20 = v8 > 0
                v3 = v20 and v3 + 36 or 134
            elseif v3 >= 190 and v3 <= 197 then
                v3 = 134
                v20 = v11 / v8
            elseif v3 >= 200 and v3 <= 205 then
                v11, v10 = 5, v11 - v12
                v5 = v10 >= 5
                v3 = v5 and 441 - v3 or 234
            elseif v3 >= 206 and v3 <= 213 then
                v5 = v1._.os.clock()
                v14[2].GeometryAt = v5
                v14[2].GeometryDirty = false
                v11 = "Waypoints"
                v10 = v4[2]
                v5 = v4[2].FindFirstChild(v10, "Waypoints")
                v10 = v5
                v3 = v5 and 33015 / v3 or 101
            elseif v3 >= 214 and v3 <= 219 then
                v21, v7 = v12(v15, v6)
                v6 = v21
                v3 = v21 == nil and v3 + 2 or 262 - v3
            elseif v3 >= 241 and v3 <= 254 then
                v11 = v10[1]
                v12, v11 = v11, v11.GetChildren
                v3, v11 = 430 - v3, v11(v12)
                v10 = v11
            elseif v3 >= 221 and v3 <= 235 then
                v3 = 236
                v5 = v14[2].GeometryDirty
            elseif v3 >= 237 and v3 <= 240 then
                v3 = 182
                v11 = {}
                v10 = v11
            else
                v11 = v11 + v15
                v3 = (v15 > 0 and v11 > v12 or v15 <= 0 and v11 < v12 or false) and v3 + -234 or 92
            end
        until false
    end
end
local function _w255(v1, v2)
    return function()
        local v3 = v2[1][2]
        local v4 = v3.JoinWalk
        v3.JoinWalk = nil
        v3 = v4
        local v5, v6, v7
        if v4 then
            if v4.Root.Parent then
                if v4.Humanoid.Parent then
                    v7 = v4.Humanoid
                    v7, v6, v5 = v4.Humanoid, v7.MoveTo, v4.Root
                    v1._.pcall(v6, v7, v5.Position)
                end
            end
            while true do
            end
        elseif v3 then
            if v4.Humanoid.Parent then
                v7 = v4.Humanoid
                v7, v6, v5 = v4.Humanoid, v7.MoveTo, v4.Root
                v1._.pcall(v6, v7, v5.Position)
            end
            while true do
            end
        else
            while true do
            end
        end
    end
end
local function _w256(v1, v2)
    return function()
        local v3 = v2[1][2].Auto.PlacePending
        local v4 = v1._.next(v3) ~= nil
        if v4 then
            return v4
        else
            v3 = v2[1][2].Auto.UpgradePending
            return v1._.next(v3) ~= nil
        end
    end
end
local function _w257(v1, v2)
    return function(v3, v4, v5, v6, v7)
        local v8, v9
        if not v2[2][2].WebhookEnabled then
            return false, "Webhook is disabled"
        else
            v8 = v2[1][2].SendDiscord
            v9 = v2[2][2].WebhookURL
            v8 = table.pack(v8(v9, v3, v4, v5, v6, v7))
            return table.unpack(v8, 1, v8.n)
        end
    end
end
local function _w258(v1, v2, v3, v4, v5)
    v1.vf[v5] = bit32.bxor(v3, 63950) + (-v4 + bit32.bxor(bit32.bxor(v3, 63950), 4294967295) + bit32.bnot(bit32.band(bit32.bnot(bit32.band(v2, bit32.bxor(v3, 63950))), bit32.bnot(v4)))) + -bit32.bnot(v4) + (bit32.bor(bit32.band(65535, v4), bit32.band(v2, 65535)) * bit32.band(bit32.band(65535, v2), bit32.band(65535, v4)) + bit32.band(bit32.band(65535, v4), bit32.bnot(bit32.band(65535, v2))) * bit32.band(bit32.bnot(bit32.band(65535, v4)), bit32.band(v2, 65535)) - bit32.band(v2, 65535) * bit32.band(v4, 65535))
    return v1.vf[v5]
end
local function _w259(v1, v2)
    return function(v3)
        v2[2][2].AntiAFK = v3 == true
        v2[1][2].SaveSettings()
    end
end
local function _w260(v1, v2)
    return function()
        v2[2][2]:Teleport(132929771812494, v2[1][2])
    end
end
local function _w261(v1, v2)
    return function(v3, v4)
        local v5 = 148
        local v6, v7, new, v8, v9, position, v10, v11, v12, v13
        repeat
            if v5 == 50 then
                v5 = v9 and 145 or 3100 / v5
            elseif v5 == 86 then
                position = v2[1][2].Position(v12)
                v9 = not v4[v12.Id]
                v5 = v9 and 88 or 213
            elseif v5 == 101 then
                v12 = v13[2]
                v6 = v12.Distance
                v11 = v13[1].Distance - v6
                v7 = v1._.math.abs(v11)
                v5, v11 = 24341 / v5, 0.05
                v8 = v7 < 0.05
            elseif v5 == 213 then
                v5 = v9 and 116 or 10650 / v5
            elseif v5 >= 87 and v5 <= 100 then
                v10 = v3.Name
                v5 = 213
                v9 = v12.Name == v10
            elseif v5 >= 102 and v5 <= 104 then
                v7 = v13[1]
                v5, v8 = 312 / v5, v7.Tower
            elseif v5 >= 105 and v5 <= 116 then
                v5, v9 = 166 - v5, position
            elseif v5 >= 63 and v5 <= 85 then
                v10 = {}
                v9 = v1._.table.insert
                v10.Tower = v12
                v10.Distance = (position - new).Magnitude
                v5 = 160
                v9(v13, v10)
            elseif v5 >= 51 and v5 <= 62 then
                v5 = v9 and 84 or 160
            elseif v5 <= 49 then
                return v8
            elseif v5 >= 214 and v5 <= 241 then
                v5 = v8 and 211 or 244
            elseif v5 >= 211 and v5 <= 212 then
                return nil, "Placed tower identity is ambiguous"
            elseif v5 >= 149 and v5 <= 210 then
                v6, v12 = v8(v7, v11)
                v11 = v6
                v5 = v6 == nil and 22240 / v5 or 86
            elseif v5 >= 140 and v5 <= 145 then
                v5 = 62
                v9 = (position - new).Magnitude < 1
            elseif v5 >= 117 and v5 <= 139 then
                v7 = v1._.table
                v11, v8, v7 = v1:fc(), v7.sort, v13
                v8(v7, v11)
                v7 = #v13
                v11 = 1
                v8 = v7 > 1
                v5 = v8 and 101 or 33499 / v5
            elseif v5 >= 146 and v5 <= 148 then
                v13 = v3.CFrame[1]
                v8 = v3.CFrame[2]
                v7 = v3.CFrame[3]
                new = v1._.Vector3.new(v13, v8, v7)
                v8 = v1._.ipairs
                v13 = {}
                v7 = v2[1][2].Owned
                v7 = v1.h(v7())
                v8, v7, v11 = v8(v1.i(v7))
                v8, v7, v11 = v1.g(v8, v7, v11)
                v6, v12 = v8(v7, v11)
                v11 = v6
                v5 = v6 == nil and 139 or 86
            else
                v8 = v13[1]
                v5 = v8 and 104 or 3
            end
        until false
    end
end
local function _w262(v1, v2)
    return function()
        local v3 = 167
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
        while true do
            if v3 == 2 then
                v5 = v2[1][2].Speed.Revision
                v3 = v7 == v5 and 79 - v3 or 126
            elseif v3 == 36 then
                v3 = v7 and 177 or 219
            elseif v3 == 83 then
                v8 = v2[1][2]
                v8.Speed.Rejected = v10
                v6, v12, v13, v8, v5 = "x rejected; current ", "Speed ", v2[1][2], "Speed", v8.SetStatus
                v5("Speed", "Speed " .. v10 .. "x rejected; current " .. v13.Speed.Value .. "x")
                v3 = 38
                v5 = v13.Notify
                v5("Speed " .. v10 .. "x rejected by game (2x requires 200 wins or X2 Speed gamepass)")
            elseif v3 == 114 then
                v3, v11 = 172 - v3, 0
            elseif v3 == 124 then
                v5 = v4
                v3 = v4 and 34 or 152 - v3
            elseif v3 == 127 then
                v5 = v4
                v3 = v4 and 127 / v3 or 172
            elseif v3 == 145 then
                v5 = v2[1][2]
                v11 = v5.Speed
                v4 = v11.Rejected
                v7 = v4 == v10
                v3 = v7 and v3 + -109 or 88
            elseif v3 == 146 then
                v3 = 38
                v5 = v2[1][2].SetStatus
                v5("Speed", "Speed request unconfirmed; keeping current timing")
            elseif v3 == 178 then
                v5 = v2[1][2]
                v11 = v5.Speed
                v4 = v11.Value
                v3, v7 = 8366 / v3, v4 == v10
            elseif v3 == 202 then
                return
            elseif v3 >= 13 and v3 <= 33 then
                v3 = v5 and v3 + -26 or 3556 / v3
            elseif v3 <= 1 then
                v3, v8 = 173 - v3, false
                v5 = v11 == false
            elseif v3 >= 3 and v3 <= 12 then
                return
            elseif v3 >= 39 and v3 <= 47 then
                v3 = v7 and 132 or 145
            elseif v3 >= 34 and v3 <= 35 then
                v3 = 28
                v5 = v11 == true
            elseif v3 >= 37 and v3 <= 38 then
                return
            elseif v3 >= 59 and v3 <= 82 then
                v5 = v2[1][2].ConfirmSpeed
                v3 = 126
                v5(v10)
            elseif v3 >= 48 and v3 <= 58 then
                v3, v7 = 2088 / v3, v4 < v11
            elseif v3 >= 84 and v3 <= 88 then
                v4 = v1._.os.clock()
                v5 = v2[1][2].Next
                v11 = v5.Speed
                v3 = v11 and v3 + -30 or v3 + 26
            elseif v3 >= 115 and v3 <= 123 then
                v10 = v2[2][2].SpeedScale
                v5 = v2[1][2]
                v11 = v5.Speed
                v4 = v11.Applied
                v7 = v4 == v10
                v3 = v7 and 178 or v3 + -71
            elseif v3 >= 89 and v3 <= 113 then
                v3, v4 = 14933 / v3, v2[1][2]
                v7 = v4.Speed
                v10 = v7.Busy
            elseif v3 >= 173 and v3 <= 177 then
                return
            elseif v3 >= 168 and v3 <= 172 then
                v3 = v5 and 83 or v3 + -26
            elseif v3 >= 147 and v3 <= 167 then
                v4 = v2[2][2]
                v7 = v4.AutoSpeed
                v10 = not v7
                v3 = v10 and 129 or 188
            elseif v3 >= 179 and v3 <= 201 then
                v4 = v2[1][2]
                v3, v7 = v3 + -59, v4.Active
                v7 = v7()
                v10 = not v7
            elseif v3 >= 133 and v3 <= 144 then
                v3 = v10 and 12 or 16166 / v3
            elseif v3 >= 125 and v3 <= 126 then
                v8 = v2[1][2]
                v3, v8.Speed.Applied = 38, v10
                v12, v9, v8, v5 = "Confirmed speed: ", v2[1][2], "Speed", v8.SetStatus
                v5("Speed", "Confirmed speed: " .. v9.Speed.Value .. "x")
            elseif v3 >= 128 and v3 <= 129 then
                v3 = v10 and 137 or 238 - v3
            elseif v3 >= 130 and v3 <= 132 then
                return
            else
                v2[1][2].Speed.Busy = true
                v2[1][2].Next.Speed = v1._.os.clock() + 5
                v11 = v2[1][2]
                v7, v5, v11, v4 = v11.Speed.Revision, v10, "ChangeSpeed", v11.Invoke
                v4, v11 = v4("ChangeSpeed", v5)
                v2[1][2].Speed.Busy = false
                v5 = not v2[1][2].Running
                v3 = v5 and 202 or 343 - v3
            end
        end
    end
end
local function _w263(v1, v2)
    return function()
        local v3 = 222
        local v4, v5, v6, v7, v8, v9, v10, v11
        repeat
            if v3 == 43 then
                v11 = v2[2][2]
                v11.ModifierOptions()
                v7, v11 = v11.ModifierSelection, v2[1][2]
                v7 = v7(v11.Modifiers)
                v9 = "/"
                v6 = v2[2][2].Elevator
                v10 = v1._.table.concat(v7, ",")
                v11 = v6 .. "/" .. v10
                v4 = v2[2][2]
                v6 = v4.ModifierAppliedKey
                v3 = v6 == v11 and v3 + 193 or 248
            elseif v3 == 188 then
                return false
            elseif v3 == 236 then
                return true
            elseif v3 == 243 then
                v2[2][2].ModifierAppliedKey = v11
                return true
            elseif v3 >= 189 and v3 <= 210 then
                v6 = v2[2][2]
                v3 = 5
                v11 = v6.IsHost
                v7 = not v11
            elseif v3 >= 170 and v3 <= 187 then
                v3, v8 = 8840 / v3, v2[2][2]
                v10 = v8.Elevator == v6
            elseif v3 >= 211 and v3 <= 221 then
                v3 = 116
                v4 = 0
            elseif v3 >= 222 and v3 <= 235 then
                v6 = v2[2][2]
                v11 = v6.Elevator
                v7 = not v11
                v3 = v7 and 5 or 210
            elseif v3 >= 237 and v3 <= 242 then
                v2[2][2].Next.Modifiers = v1._.os.clock() + 5
                v4 = v2[2][2]
                v6 = v4.Elevator
                v4, v10, v9, v5 = v4.Invoke, v6, "ElevatorSetModifiers", v7
                v4, v9 = v4("ElevatorSetModifiers", v10, v5)
                v10 = v4
                v3 = v4 and 110 or 40898 / v3
            elseif v3 >= 53 and v3 <= 110 then
                v3, v10 = 18590 / v3, v9 == true
            elseif v3 >= 111 and v3 <= 116 then
                v3 = v6 < v4 and 158 or 242
            elseif v3 <= 42 then
                v3 = v7 and v3 + 183 or 48 - v3
            elseif v3 >= 44 and v3 <= 52 then
                v3 = v10 and 12636 / v3 or 8528 / v3
            elseif v3 >= 117 and v3 <= 164 then
                if not (v3 <= 158) then
                    v2[2][2].SetStatus("Lobby", "Modifier selection not accepted; waiting before start")
                end
                return false
            elseif v3 >= 165 and v3 <= 169 then
                v3 = v10 and 170 or 52
            else
                v6 = v1._.os.clock()
                v10 = v2[2][2]
                v9 = v10.Next
                v4 = v9.Modifiers
                v3 = v4 and 116 or 215
            end
        until false
    end
end
local function _w264(v1, v2, v3)
    v1.Bf[v3] = v2
    return v1.Bf[v3]
end
local function _w265(v1, v2)
    return function(v3, v4)
        local v5 = 6
        local v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17
        while true do
            if v5 == 6 then
                v16 = v2[1][2]
                v11 = v16.Pending
                v7 = v11[v3]
                v5 = v7 and 216 or 37
            elseif v5 == 37 then
                v11 = {}
                v5 = 216
                v7 = v11
            elseif v5 == 92 then
                v11, v16, v8 = v1._.ipairs(v7)
                v11, v16, v8 = v1.g(v11, v16, v8)
                v12, v9 = v11(v16, v8)
                v8 = v12
                v5 = v12 == nil and 341 - v5 or 232
            elseif v5 == 191 then
                v11 = v11 + v8
                v5 = (v8 > 0 and v11 > v16 or v8 <= 0 and v11 < v16 or false) and 92 or 334 - v5
            elseif v5 == 245 then
                v5 = 141
                v15 = v2[1][2].Position
                v6 = (v14.Pos - v15(v4)).Magnitude < 1
            elseif v5 >= 57 and v5 <= 62 then
                v1._.table.remove(v7, v12)
                return v9
            elseif v5 >= 63 and v5 <= 91 then
                v13 = v4.UnitId
                v6 = v14.UnitId == v13
                v5 = v6 and 53 or 26
            elseif v5 >= 93 and v5 <= 141 then
                v5, v10 = v5 + -140, v6
            elseif v5 >= 7 and v5 <= 36 then
                v5 = v6 and 234 - v5 or 56
            elseif v5 <= 5 then
                v5 = v10 and 62 / v5 or 168
            elseif v5 >= 54 and v5 <= 56 then
                v5 = v6 and 245 or 141
            elseif v5 >= 38 and v5 <= 53 then
                v13 = v14.Pos
                v5, v17 = 1378 / v5, v1._.typeof(v13)
                v6 = v17 == "Vector3"
            elseif v5 >= 217 and v5 <= 244 then
                v14 = v9.Payload
                v17 = v4.Id
                v10 = v14.Id == v17
                v6 = "TowerAdd"
                v5 = v3 == "TowerAdd" and 14616 / v5 or 1
            elseif v5 >= 209 and v5 <= 216 then
                v8 = -1
                v11 = #v7
                v16 = 1
                v5 = v11 < 1 and v5 + -124 or 143
            elseif v5 >= 144 and v5 <= 167 then
                v5, v14, v12, v9 = v5 + 40, v11, v1._.table.remove, v7
                v12(v9, v14)
            elseif v5 >= 142 and v5 <= 143 then
                v9 = v1._.os.clock()
                v10 = v7[v11]
                v14 = v10.At
                v9, v12 = 15, v9 - v14
                v5 = v12 > 15 and 151 or v5 + 48
            elseif v5 >= 168 and v5 <= 190 then
                v12, v9 = v11(v16, v8)
                v8 = v12
                v5 = v12 == nil and 249 or v5 + 64
            elseif v5 >= 192 and v5 <= 208 then
                v5 = 56
                v6 = v2[1][2].Position(v4)
            else
                return
            end
        end
    end
end
local function _w266(v1, v2)
    return function(v3, v4)
        local v5 = 20
        local v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
        while true do
            if v5 == 13 then
                v18 = v4
                v5 = v4 and 66 or v5 + 76
            elseif v5 == 23 then
                return false
            elseif v5 == 46 then
                v22 = v18
                v14 = nil
                v21 = "Model"
                v7 = nil
                v12 = v18:IsA("Model")
                v5 = v12 and 5842 / v5 or v5 + 130
            elseif v5 == 61 then
                v9 = v15.Character
                v5 = v9 and 1891 / v5 or v5 + 83
            elseif v5 == 78 then
                v5, v7, v14 = 4602 / v5, v1._.tostring, v19
                v7 = v7(v14)
                v14 = ""
                v18 = v7 ~= ""
            elseif v5 == 123 then
                v5 = v19 > v18 and 20295 / v5 or 238
            elseif v5 == 124 then
                v5 = v18 and 132 or 254
            elseif v5 == 144 then
                v5 = v9 and 21 or 177
            elseif v5 == 150 then
                v7 = v1._.tostring(v19)
                v14 = "0"
                v5 = 49
                v18 = v7 ~= "0"
            elseif v5 == 177 then
                v16, v15 = v22(v21, v13)
                v13 = v16
                v5 = v16 == nil and 147 or 187
            elseif v5 == 223 then
                return true
            elseif v5 == 232 then
                v5 = v7 and v5 + -34 or 278 - v5
            elseif v5 == 251 then
                v7 = v1._.tostring(v19)
                v5, v12 = v5 + -127, v2[2][2]
                v14 = v12.Name
                v18 = v7 ~= v14
            elseif v5 >= 252 and v5 <= 253 then
                v5 = 250
                v12 = not v14
            elseif v5 >= 247 and v5 <= 250 then
                v5 = v12 and 23 or v5 + -121
            elseif v5 >= 239 and v5 <= 246 then
                v5 = 234
                v8 = v17.X
                v10 = v17.Z
                v20 = v1._.Vector3.new(v8, 0, v10).Magnitude <= v12
            elseif v5 >= 235 and v5 <= 238 then
                v7 = "Host"
                v19 = v3:GetAttribute("Host")
                v18 = v19
                v5 = v19 and 316 - v5 or 59
            elseif v5 >= 233 and v5 <= 234 then
                v5 = v20 and 52182 / v5 or 177
            elseif v5 >= 224 and v5 <= 231 then
                v12 = not v7
                v5 = v12 and 250 or 480 - v5
            elseif v5 >= 178 and v5 <= 187 then
                v9 = v2[2][2]
                v5 = v15 ~= v9 and 11407 / v5 or 177
            elseif v5 >= 188 and v5 <= 194 then
                v12 = v2[1][2]
                v5 = 232
                v14 = v12.GetPlayers
                v7 = not v14
            elseif v5 >= 195 and v5 <= 222 then
                return false
            elseif v5 >= 130 and v5 <= 143 then
                return true
            elseif v5 >= 145 and v5 <= 149 then
                return false
            elseif v5 >= 166 and v5 <= 176 then
                v21 = "BasePart"
                v22 = v18
                v12 = v18:IsA("BasePart")
                v5 = v12 and 5632 / v5 or v5 + 51
            elseif v5 >= 151 and v5 <= 165 then
                return true
            elseif v5 >= 50 and v5 <= 60 then
                v5 = v18 and 209 - v5 or 49
            elseif v5 >= 32 and v5 <= 45 then
                v14, v5, v7 = v18.Size, v5 + 195, v18.CFrame
            elseif v5 >= 47 and v5 <= 49 then
                v5 = v18 and 1 or 63
            elseif v5 >= 14 and v5 <= 20 then
                v14 = "Players"
                v19 = v1._.tonumber
                v7 = v3
                v18 = v3.GetAttribute
                v18 = table.pack(v18(v3, "Players"))
                v19 = v19(table.unpack(v18, 1, v18.n))
                v5 = v19 and 13 or 84
            elseif v5 <= 12 then
                v7 = v1._.tostring(v19)
                v5, v14, v12 = 63 / v5, v1._.tostring, v2[2][2]
                v12 = v12.UserId
                v14 = v14(v12)
                v18 = v7 ~= v14
            elseif v5 >= 21 and v5 <= 22 then
                v11 = v7.Position
                v6 = v1._.math
                v17 = v9.Position - v11
                v6, v11 = v17.Y, v6.abs
                v20 = v11(v6) <= 10
                v5 = v20 and 246 or 234
            elseif v5 >= 24 and v5 <= 31 then
                v9 = v15.Character
                v20 = "HumanoidRootPart"
                v17, v9 = v9, v9.FindFirstChild
                v5, v9 = 175 - v5, v9(v17, "HumanoidRootPart")
            elseif v5 >= 125 and v5 <= 127 then
                v22, v5, v12 = v18, v5 + 100, v18.GetBoundingBox
                v12, v22 = v12(v22)
                v14 = v22
                v7 = v12
            elseif v5 >= 128 and v5 <= 129 then
                v13 = v1._.math
                v16, v13, v21 = v14.Z, v14.X, v13.max
                v12 = v1._.math.max(6, v21(v13, v16) / 2)
                v21 = v2[1][2]
                v22 = v1._.ipairs
                v21, v13 = v21.GetPlayers, v21
                v21 = v1.h(v21(v13))
                v22, v21, v13 = v22(v1.i(v21))
                v22, v21, v13 = v1.g(v22, v21, v13)
                v16, v15 = v22(v21, v13)
                v13 = v16
                v5 = v16 == nil and 147 or 187
            elseif v5 >= 90 and v5 <= 122 then
                v5, v18 = 15006 / v5, 0
            elseif v5 >= 79 and v5 <= 84 then
                v5, v19 = v5 + -71, 0
            elseif v5 >= 85 and v5 <= 89 then
                v5 = v18 and 123 or 122
            elseif v5 >= 62 and v5 <= 63 then
                v5 = v18 and 251 or 187 - v5
            elseif v5 >= 64 and v5 <= 77 then
                v5, v18 = 155 - v5, 1
            else
                v14 = "Pad"
                v18 = v3:FindFirstChild("Pad")
                v7 = not v18
                v5 = v7 and 232 or 448 - v5
            end
        end
    end
end
local function _w267(v1, v2)
    return function()
        local v3 = 78
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20
        while true do
            if v3 == 6 then
                v3, v11 = 160 - v3, v11(v12, v13, v19)
            elseif v3 == 23 then
                v3 = v18 and v3 + 195 or v3 + 24
            elseif v3 == 51 then
                v3 = 76
                v13 = "(none)"
            elseif v3 == 60 then
                v18 = v2[2][2]
                v14 = v18.LoadedProfile
                v3 = v14 and 237 or 89
            elseif v3 == 74 then
                v3, v19 = v3 + 78, 0
            elseif v3 == 89 then
                v3 = v14 and 166 or 222
            elseif v3 == 113 then
                v12 = v1._.string
                v19, v11, v12 = v2[2][2], v12.format, "Playback: %d/%d"
                v13 = v19.PlaybackIndex
                v3 = v13 and 40 or 101
            elseif v3 == 147 then
                v12 = v2[2][2]
                v11 = v12.Next
                v5 = v11.Vote
                v3 = v5 and 1176 / v3 or 143
            elseif v3 == 162 then
                v2[2][2].AutoPlaybackStep(v6, v9)
                v18 = v2[2][2]
                v18.LastWave = v4
                v18.Visual()
                return
            elseif v3 == 163 then
                v5 = v2[2][2]
                v18 = v5.Visible
                v19, v11, v5 = v2[1][2], "GamemodeVoting/MainFrame/", v5.GUI
                v19, v13 = "/Vote/Vote", v19.Difficulty
                v12 = v13 .. "/Vote/Vote"
                v11 = "GamemodeVoting/MainFrame/" .. v12
                v5 = table.pack(v5(v11))
                v3, v18 = 33089 / v3, v18(table.unpack(v5, 1, v5.n))
            elseif v3 == 166 then
                v14 = {[1] = 2, [2] = v14}
                v14[3] = v14
                v5 = v1:Tb({v2[1], v2[2], v14, v17})
                v1._.pcall(v5)
                v5 = "MacroActions"
                v18 = v2[2][2].SetStatus
                v11 = v17[2]
                v3 = v11 and 22078 / v3 or 222 - v3
            elseif v3 == 183 then
                v18, v3, v5 = v2[2][2].EndMatchStep, v3 + -21, v7
                v18(v5)
            elseif v3 == 202 then
                v3, v11 = 21412 / v3, v2[2][2]
                v5 = v11.SoloReturning
                v18 = not v5
            elseif v3 == 216 then
                v3 = v18 and v3 + -199 or v3 + -180
            elseif v3 == 227 then
                v3, v20 = v3 + -169, v2[2][2]
                v9 = v20.CloseRefresh
                v9()
            elseif v3 == 252 then
                v3 = v19 and v3 + -100 or 74
            elseif v3 >= 167 and v3 <= 168 then
                v3, v5 = v3 + 16, v2[2][2]
                v18 = v5.StopRecord
                v18()
            elseif v3 >= 169 and v3 <= 182 then
                v5 = v2[2][2]
                v18 = v5.Recording
                v3 = v18 and v3 + -14 or 33488 / v3
            elseif v3 >= 164 and v3 <= 165 then
                v12 = v2[2][2]
                v5 = v1._.game.PlaceId
                v11 = v12.MatchId
                v3 = 207
                v18 = v5 == v11
            elseif v3 >= 148 and v3 <= 150 then
                v3, v19 = 900 / v3, 0
            elseif v3 >= 134 and v3 <= 146 then
                v3, v5 = v3 + -135, 0
            elseif v3 >= 131 and v3 <= 133 then
                v19 = v17[2].Profile
                v13 = v19.Actions
                v3, v12 = v3 + -77, #v13
                v11 = "Recorded actions: " .. v12
            elseif v3 >= 153 and v3 <= 154 then
                v3 = v11 and v3 + -50 or 53
            elseif v3 >= 151 and v3 <= 152 then
                v3, v11 = 104, v11(v12, v13, v19)
            elseif v3 >= 155 and v3 <= 161 then
                v3, v16 = v3 + 95, v2[2][2]
                v19 = #v16.LoadedProfile.Actions
            elseif v3 >= 241 and v3 <= 251 then
                v3 = v18 and 504 - v3 or 32630 / v3
            elseif v3 >= 228 and v3 <= 237 then
                v3, v11 = v3 + -148, v2[2][2]
                v5 = v11.LoadedProfile
                v18 = v5.Actions
                v14 = #v18
            elseif v3 >= 222 and v3 <= 226 then
                v3, v14 = 388 - v3, 0
            elseif v3 >= 238 and v3 <= 240 then
                v3, v18 = 263 - v3, v15.Text
            elseif v3 >= 207 and v3 <= 215 then
                v3 = v18 and 163 or 203
            elseif v3 >= 217 and v3 <= 221 then
                v11 = " | Cash: "
                v19 = v2[2][2]
                v13 = v19.Cash()
                v8 = v19
                v19 = " | Owned: " .. #v19.Owned()
                v12 = v13 .. v19
                v5 = " | Cash: " .. v12
                v17(v14, v18 .. v5)
                v17 = v8.SetStatus
                v18 = v15
                v14 = "MacroRuntime"
                v3 = v18 and 5668 / v3 or 216
            elseif v3 >= 184 and v3 <= 201 then
                v5 = v2[2][2]
                v18 = v5.Playing
                v3 = v18 and 5 or v3 + -1
            elseif v3 >= 203 and v3 <= 206 then
                v3 = v18 and 29841 / v3 or 251
            elseif v3 <= 5 then
                v3, v5 = 188 - v3, v2[2][2]
                v5, v18 = "Match ended", v5.StopPlayback
                v18("Match ended")
            elseif v3 >= 7 and v3 <= 8 then
                v3, v18 = 259 - v3, v9 >= v5
            elseif v3 >= 9 and v3 <= 16 then
                v3 = v13 and 76 or v3 + 40
            elseif v3 >= 27 and v3 <= 36 then
                v3, v18 = 612 / v3, "Lobby"
            elseif v3 >= 24 and v3 <= 26 then
                v3 = 216
                v18 = v15.Text
            elseif v3 >= 17 and v3 <= 22 then
                v11 = " | "
                v13 = v2[1][2].PlaybackMode
                v10 = v2[2][2]
                v19 = " | Cash: " .. v10.Cash()
                v12 = v13 .. v19
                v5 = " | " .. v12
                v18 = v18 .. v5
                v17(v14, v18)
                v17 = {[1] = 2, [2] = v10.Recording}
                v17[3] = v17
                v14 = v17[2]
                v3 = v14 and 142 - v3 or v3 + 90
            elseif v3 >= 41 and v3 <= 50 then
                v3 = 218
                v18 = "Lobby"
            elseif v3 >= 37 and v3 <= 40 then
                v19 = v2[2][2].PlaybackTotal
                v3 = v19 and 46 - v3 or 6000 / v3
            elseif v3 >= 52 and v3 <= 53 then
                v11 = v1._.string.format
                v12 = "Selected macro: %s | %d actions"
                v19 = v2[1][2].Profile
                v13 = v19 ~= ""
                v3 = v13 and 62 or 11
            elseif v3 >= 54 and v3 <= 56 then
                v3 = v11 and 154 or 79
            elseif v3 >= 57 and v3 <= 59 then
                v9 = v1._.os.clock()
                v6 = v2[2][2]
                v6.SoloGuard()
                v20 = v6.Final()
                v6, v7 = v6.RoundStep, v20
                v6(v7)
                v7 = v2[2][2]
                v7.RefreshModifiers()
                v6 = v7.Active()
                v4, v7, v15 = v20, v7.WebhookStep, v6
                v7 = v7(v4, v15)
                v15 = v2[2][2]
                v4 = v15.Wave()
                v15, v17 = v15.GUI, "Stats/Wave"
                v15 = v15("Stats/Wave")
                v18 = v15
                v17 = v2[2][2].SetStatus
                v14 = "Match"
                v3 = v18 and 240 or 23
            elseif v3 >= 114 and v3 <= 125 then
                v3, v5 = 232 - v3, v17[2].Profile
                v18 = v5.Actions
                v14 = #v18
            elseif v3 >= 126 and v3 <= 130 then
                v3 = v20 and 182 or 162
            elseif v3 >= 107 and v3 <= 112 then
                v3 = v14 and 196 - v3 or 60
            elseif v3 >= 102 and v3 <= 104 then
                v18(v5, v11)
                v5 = v2[1][2]
                v18 = v5.AutoDifficulty
                v3 = v18 and 202 or 210 - v3
            elseif v3 >= 105 and v3 <= 106 then
                v3 = v18 and 165 or 207
            elseif v3 >= 79 and v3 <= 88 then
                v11 = v2[2][2].Playing
                v3 = v11 and 113 or 12166 / v3
            elseif v3 >= 90 and v3 <= 101 then
                v3 = 40
                v13 = 0
            elseif v3 >= 77 and v3 <= 78 then
                v20 = v2[2][2]
                v20.BindRemotes()
                v6 = v20
                v20 = v20.Close
                v9 = v20.Enabled
                v3 = v9 and 227 or 58
            elseif v3 >= 75 and v3 <= 76 then
                v19 = v2[2][2].LoadedProfile
                v3 = v19 and 157 or v3 + 176
            elseif v3 >= 61 and v3 <= 73 then
                v19 = v2[1][2]
                v3 = 11
                v13 = v19.Profile
            else
                v3, v2[2][2].Next.Vote = 383 - v3, v9 + 2
                v5 = v2[2][2]
                v5, v11, v18 = "ModeVote", v2[1][2], v5.Fire
                v11 = v11.Difficulty
                v18("ModeVote", v11)
            end
        end
    end
end
local function _w268(v1, v2)
    return function()
        local v3 = 149
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, path2, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31
        while true do
            if v3 == 3 then
                v7 = v7 + v16
                v3 = (v16 > 0 and v7 > v27 or v16 <= 0 and v7 < v27 or false) and 79 - v3 or 233 - v3
            elseif v3 == 16 then
                v11 = v1._.Vector3
                v22, v11, v21, v29 = v31.Z, v31.X, 0, v11.new
                v29 = v29(v11, 0, v22)
                v21 = v1._.Vector3
                v21, v17, v22, v11 = v8.X, v8.Z, 0, v21.new
                v3 = 175
                v23 = 4.5
                v9 = (v29 - v11(v21, 0, v17)).Magnitude
                v24 = v9 < 4.5
            elseif v3 == 17 then
                v29 = v1._.Vector3
                v31 = v12.Action.CFrame
                v11, v21, v23, v29 = 0, v31[3], v29.new, v31[1]
                v23 = v23(v29, 0, v21)
                v11 = v1._.Vector3
                v22, v21, v29, v11 = v8.Z, 0, v11.new, v8.X
                v9 = 4.5
                v24 = (v23 - v29(v11, 0, v22)).Magnitude
                v3 = v24 < 4.5 and 259 - v3 or 1054 / v3
            elseif v3 == 18 then
                v27 = v27 + v19
                v3 = (v19 > 0 and v27 > v16 or v19 <= 0 and v27 < v16 or false) and v3 + 122 or 204
            elseif v3 == 19 then
                v26 = v30
                v10 = -v26.Z
                v25 = v26.X
                v30 = v1._.Vector3.new(v10, 0, v25)
                v10 = v1._.RaycastParams.new()
                v10.FilterType = v1._.Enum.RaycastFilterType.Include
                v10.FilterDescendantsInstances = {[1] = path2}
                v15 = v2[2][2].Auto
                v4 = v1._.string
                v28, v13, v5, v25, v4 = v20.X, v20.Y, v20.Z, v4.format, "%.2f/%.2f/%.2f"
                v25 = v25("%.2f/%.2f/%.2f", v28, v13, v5)
                v28 = v15.CandidateKey
                v4 = v28 ~= v25
                v3 = v4 and v3 + 114 or 59
            elseif v3 == 41 then
                v3 = v7 and 193 - v3 or 51
            elseif v3 == 48 then
                v3, v27 = 7056 / v3, {}
                v7 = v27
            elseif v3 == 51 then
                v5 = v5 + v18
                v3 = (v18 > 0 and v5 > v14 or v18 <= 0 and v5 < v14 or false) and 8262 / v3 or 44
            elseif v3 == 62 then
                v19, v12 = v7(v27, v16)
                v16 = v19
                v3 = v19 == nil and 118 - v3 or 79 - v3
            elseif v3 == 70 then
                v16 = v2[2][2]
                v27 = v16.Auto
                v7 = v27.Points
                v3 = v7 and 10290 / v3 or 48
            elseif v3 == 71 then
                v3 = 0
                v6 = false
            elseif v3 == 72 then
                v3 = 130
                v12 = {}
                v19 = v12
            elseif v3 == 77 then
                v3 = v23 and 219 or 31
            elseif v3 == 92 then
                v28 = 1
                v8 = #v4
                v18 = 24
                v14 = v1._.math.min(24, v8)
                v13 = v14
                v5 = 1
                v3 = (1 > v14 or false) and 318 - v3 or v3 + -4
            elseif v3 == 109 then
                v4 = v15.Candidates
                v3 = v4 and 87 or 184
            elseif v3 == 132 then
                v30 = v26
                v3 = v26 and 2508 / v3 or 171
            elseif v3 == 133 then
                v3 = v4 and 66 or 14497 / v3
            elseif v3 == 141 then
                v27 = v2[2][2].Auto.PlacePending
                v7, v27, v16 = v1._.pairs(v27)
                v7, v27, v16 = v1.g(v7, v27, v16)
                v19, v12 = v7(v27, v16)
                v16 = v19
                v3 = v19 == nil and 56 or 17
            elseif v3 == 162 then
                v4 = v4 + v13
                v3 = (v13 > 0 and v4 > v28 or v13 <= 0 and v4 < v28 or false) and v3 + 76 or 190
            elseif v3 == 165 then
                v3 = v9 and 14 or 164
            elseif v3 == 171 then
                v10 = 1
                v3 = 19
                v15 = 0
                v25 = 0
                v30 = v1._.Vector3.new(1, 0, 0)
            elseif v3 == 204 then
                v12 = v7[v27 - 1].Position
                v31 = v7[v27].Position
                v23 = v31.X
                v29 = v12.X
                v11, v29, v9, v23 = v12.Z, v31.Z, v23 - v29, 0
                v24 = v1._.Vector3.new(v9, 0, v29 - v11)
                v23 = v8.X - v12.X
                v21 = v12.Z
                v11 = v8.Z
                v9 = v1._.Vector3.new(v23, 0, v11 - v21)
                v23 = v24:Dot(v24) > 0
                v3 = v23 and 51612 / v3 or 281 - v3
            elseif v3 == 213 then
                v19, v12 = v7(v27, v16)
                v16 = v19
                v3 = v19 == nil and 0 or v3 + -45
            elseif v3 == 226 then
                return nil
            elseif v3 == 229 then
                v28 = v28 + v5
                v3 = (v5 > 0 and v28 > v13 or v5 <= 0 and v28 < v13 or false) and 455 - v3 or v3 + -141
            elseif v3 == 230 then
                v19 = v15.Points[v7 - 1].Position
                v12 = v15.Points[v7].Position
                v23 = v19.X
                v9 = v12.X
                v29, v23, v9, v24 = v19.Z, v12.Z, 0, v9 - v23
                v31 = v1._.Vector3.new(v24, 0, v23 - v29)
                v23 = v8.X
                v29 = v19.X
                v29, v9, v11, v23 = v8.Z, v23 - v29, v19.Z, 0
                v24 = v1._.Vector3.new(v9, 0, v29 - v11)
                v23 = v31:Dot(v31)
                v9 = v23 > 0
                v3 = v9 and 82 or 165
            elseif v3 >= 227 and v3 <= 228 then
                v18 = v2[1][2]
                v6 = v14 + v1._.Vector3.new(0, 100, 0)
                v27 = 0
                v16 = -200
                v19 = 0
                v7 = v1._.Vector3.new(0, -200, 0)
                v18 = v18:Raycast(v6, v7, v10)
                v3 = v18 and 207 or 229
            elseif v3 >= 231 and v3 <= 238 then
                v28 = v1._.table
                v13, v3, v28, v4 = v1:md(), 25942 / v3, v15.Candidates, v28.sort
                v4(v28, v13)
            elseif v3 >= 243 and v3 <= 249 then
                return nil
            elseif v3 >= 239 and v3 <= 242 then
                v3 = 56
                v6 = false
            elseif v3 >= 185 and v3 <= 190 then
                v5 = -18
                v18 = 1.5
                v14 = 18
                v3 = 44
            elseif v3 >= 176 and v3 <= 184 then
                v28 = {}
                v3, v4 = v3 + -97, v28
            elseif v3 >= 191 and v3 <= 203 then
                v7 = v1._.CFrame.new
                v7 = table.pack(v7(v8))
                return table.unpack(v7, 1, v7.n)
            elseif v3 >= 205 and v3 <= 212 then
                v8 = v18.Position
                v6 = true
                v27 = v2[2][2].Towers
                v7, v27, v16 = v1._.pairs(v27)
                v7, v27, v16 = v1.g(v7, v27, v16)
                v19, v12 = v7(v27, v16)
                v16 = v19
                v3 = v19 == nil and 0 or 375 - v3
            elseif v3 >= 214 and v3 <= 225 then
                v29 = (v9 - v24 * v23).Magnitude
                v3 = v29 < 3.5 and v3 + -150 or 18
            elseif v3 >= 148 and v3 <= 149 then
                v20, v26 = v2[2][2].PathTarget()
                v30 = v2[1][2]
                v10 = "Game/TowerArea"
                path2 = v2[2][2].Path(v30, "Game/TowerArea")
                v30 = not v20
                v3 = v30 and 157 or 23
            elseif v3 >= 134 and v3 <= 140 then
                v3 = v6 and 199 or 369 - v3
            elseif v3 >= 142 and v3 <= 147 then
                v27 = 2
                v19 = 1
                v16 = #v7
                v3 = (2 > v16 or false) and 287 - v3 or v3 + 57
            elseif v3 >= 130 and v3 <= 131 then
                v27 = #v19
                v16 = 1
                v3 = (v7 > v27 or false) and 9880 / v3 or 230
            elseif v3 >= 110 and v3 <= 129 then
                v16 = v1._.math
                v27 = v16.huge
                v3, v7 = v3 + -77, v6 < v27
            elseif v3 >= 172 and v3 <= 175 then
                v3 = v24 and 71 or 388 - v3
            elseif v3 >= 166 and v3 <= 170 then
                v31 = v2[2][2].Position(v12)
                v24 = v31
                v3 = v31 and 184 - v3 or v3 + 7
            elseif v3 >= 153 and v3 <= 161 then
                v3 = v30 and 249 or 20724 / v3
            elseif v3 >= 150 and v3 <= 152 then
                v16 = {}
                v7 = v1._.table.insert
                v27 = v15.Candidates
                v16.Position = v8
                v3, v24, v23 = 203 - v3, v1._.math.floor, 2
                v23 = 0.5
                v9 = 1000
                v31, v24 = v24(v6 * 2 + 0.5) * 1000, v4 * v4
                v12, v31 = v31 + v24, v5 * v5
                v19 = v12 + v31
                v16.Score = v19
                v7(v27, v16)
            elseif v3 >= 163 and v3 <= 164 then
                v3 = 14
                v9 = 0
            elseif v3 >= 83 and v3 <= 87 then
                v13 = 0
                v28 = #v4
                v3 = v28 == 0 and 50 or v3 + 5
            elseif v3 >= 78 and v3 <= 82 then
                v9, v29, v21, v3, v11 = v1._.math.clamp, v24.Dot, v31, v3 + 83, v24
                v23, v29, v11 = v29(v11, v21) / v31:Dot(v31), 0, 1
                v9 = v9(v23, 0, 1)
            elseif v3 >= 73 and v3 <= 76 then
                v27 = 3.5
                v7 = v6 >= 3.5
                v3 = v7 and 118 or 41
            elseif v3 >= 88 and v3 <= 91 then
                v14 = v2[2][2]
                v7 = v14
                v6 = v14.Candidate
                v3 = v6 and 9 or 33
            elseif v3 >= 93 and v3 <= 108 then
                v16 = v5
                v27 = 0
                v8 = v20 + v1._.Vector3.new(v4, 0, v16)
                v7 = v1._.math
                v19, v7, v6 = v15.Points, 2, v7.huge
                v3 = v19 and 237 - v3 or 72
            elseif v3 >= 67 and v3 <= 69 then
                v3, v6 = v3 + 71, false
            elseif v3 >= 52 and v3 <= 58 then
                v3 = v6 and 70 or 7840 / v3
            elseif v3 >= 59 and v3 <= 61 then
                v28 = v15.CandidatePoints
                v13 = v15.Points
                v3 = 133
                v4 = v28 ~= v13
            elseif v3 >= 63 and v3 <= 66 then
                v15.CandidateKey, v4 = v25, v15.Points
                v15.CandidatePoints = v4
                v15.Candidates = {}
                v2[2][2].Candidate = 0
                v4 = -18
                v28 = 18
                v13 = 1.5
                v3 = 190
            elseif v3 >= 32 and v3 <= 40 then
                v3 = 9
                v6 = 0
            elseif v3 >= 20 and v3 <= 23 then
                v3 = 157
                v30 = not path2
            elseif v3 >= 24 and v3 <= 31 then
                v3, v23 = v3 + 188, 0
            elseif v3 >= 49 and v3 <= 50 then
                return nil
            elseif v3 >= 42 and v3 <= 47 then
                v7 = v5 * v5
                v8 = v4 * v4 + v7
                v6 = 324
                v3 = v8 <= 324 and 151 - v3 or v3 + 7
            elseif v3 >= 4 and v3 <= 13 then
                v7 = #v4
                v6, v8 = 1, v6 % v7
                v14.Candidate = v8 + 1
                v6 = v2[2][2]
                v14 = v4[v6.Candidate].Position
                v18 = (v14 - v20).Magnitude
                v8 = 18
                v3 = v18 <= 18 and 228 or 229
            elseif v3 <= 2 then
                v3 = v6 and 141 - v3 or 56 - v3
            elseif v3 >= 14 and v3 <= 15 then
                v21, v29, v3, v23 = v31 * v9, v6, v3 + -11, v1._.math.min
                v23 = v23(v29, (v24 - v21).Magnitude)
                v6 = v23
            else
                v3 = 77
                v23 = v1._.math.clamp(v9:Dot(v24) / v24:Dot(v24), 0, 1)
            end
        end
    end
end
local function _w269(v1, v2)
    return function()
        local v3 = v2[2][2]
        local v4
        v3, v4 = v2[1][2], v3.Removed
        local v5
        v5, v4 = v4[v3], nil
        return v5 ~= nil
    end
end
local function _w270(v1, v2)
    return function(v3, v4, v5)
        v3 = {[1] = 2, [2] = v3}
        v3[3] = v3
        v4 = {[1] = 2, [2] = v4}
        v4[3] = v4
        v5 = {[1] = 2, [2] = v5}
        v5[3] = v5
        local v6 = v2[1][2]
        local v7 = v6.FPSOriginal
        v6 = v6.FPSOriginal[v3[2]]
        if v6 then
            v7[v3[2]] = v6
        else
            v7[v3[2]] = {}
        end
        if v2[1][2].FPSOriginal[v3[2]][v4[2]] == nil then
            v6 = v1:Vb({v4, v3})
            v7, v6 = v1._.pcall(v6)
            if v7 then
                v2[1][2].FPSOriginal[v3[2]][v4[2]] = v6
            end
        end
        v6 = v1:Ub({v5, v3, v4})
        v1._.pcall(v6)
    end
end
local function _w271(v1, v2)
    return function(v3)
        local mergeTower = v2[1][2].MergeTower(v3)
        local v4 = mergeTower
        local v7
        if mergeTower then
            if v2[1][2].Recording then
                v4 = v2[1][2].RecordAction
                v7 = v2[1][2].TakeStamp
                v7 = table.pack(v7("TowerAdd", mergeTower))
                v4("Place", mergeTower, table.unpack(v7, 1, v7.n))
            end
            return
        elseif v4 then
            v4 = v2[1][2].RecordAction
            v7 = v2[1][2].TakeStamp
            v7 = table.pack(v7("TowerAdd", mergeTower))
            v4("Place", mergeTower, table.unpack(v7, 1, v7.n))
            return
        else
            return
        end
    end
end
local function _w272(v1)
    return function(v2, v3)
        local v4 = v2.Price or v1._.math.huge
        local v5 = v3.Price or v1._.math.huge
        local v6, v7, v8
        if v4 == v5 then
            v6 = v2.Tower.Id
            v8 = v1._.tostring(v6)
            v7 = v3.Tower.Id
            return v8 < v1._.tostring(v7)
        else
            return v4 < v5
        end
    end
end
local function _w273(v1, v2)
    return function()
        local v3, v4, v5
        if not v2[2][2].Running then
            return
        else
            v3 = v1._.game
            v4 = v3.HttpGet
            v5, v4 = v1._.pcall(v4, v3, "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
            v3 = v5
            if v5 then
                if v1._.type(v4) == "string" then
                    if v1._.loadstring(v4) then
                        if v2[2][2].Running then
                            v2[1][2](v4)
                        end
                    end
                end
                return
            elseif v3 then
                if v1._.loadstring(v4) then
                    if v2[2][2].Running then
                        v2[1][2](v4)
                    end
                end
                return
            else
                return
            end
        end
    end
end
local function _w274(v1, v2)
    return function(v3, v4)
        local v5 = ""
        local v6 = 0
        local v7 = #v3 - 1
        local v8, v9, v10, v11
        if 0 <= v7 then
            while true do
                v9 = v2[2][2]
                v10 = v2[3][2]
                v8 = v2[1][2](v3, v6 + 1)
                v11 = v2[1][2]
                v11 = table.pack(v11(v4, #v4 - v6 % #v4))
                v10 = table.pack(v10(v8, table.unpack(v11, 1, v11.n)))
                v5 = v5 .. v9(table.unpack(v10, 1, v10.n))
                v6 = v6 + 1
                if v6 > v7 then
                    break
                end
            end
        end
        return v5
    end
end
local function _w275(v1, v2)
    return function()
        local v3 = 125
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18
        repeat
            if v3 == 1 then
                v2[2][2].CancelJoinWalk()
                v18 = v1._.CFrame.new
                v4 = 3
                v7 = 0
                v12 = v8 + v1._.Vector3.new(0, 3, 0)
                v18 = table.pack(v18(v12))
                v15 = v11
                v5 = v11.PivotTo
                v3 = 9 - v3
                v5(v11, table.unpack(v18, 1, v18.n))
            elseif v3 == 4 then
                v18 = v2[3][2]
                v15 = v18.Character
                v3 = 48
                v5 = v15 ~= v11
            elseif v3 == 5 then
                v3 = v18 and 724 - v3 or 78
            elseif v3 == 7 then
                v15 = v13:GetAttribute("Map")
                v12 = v2[4][2]
                v18 = v12.Map
                v3, v5 = 1302 / v3, v15 ~= v18
            elseif v3 == 11 then
                v18 = v2[4][2]
                v3, v15 = 203 - v3, v18.JoinMethod
                v5 = v15 ~= v17
            elseif v3 == 19 then
                v3, v5, v17 = v3 + 87, v6, v6.GetPivot
                v17 = v17(v5)
                v8 = v17.Position
            elseif v3 == 25 then
                v18 = v2[2][2]
                v15 = v18.Elevator
                v5 = not v15
                v3 = v5 and 162 or 78
            elseif v3 == 37 then
                v12 = v15:GetAttribute("Map")
                v4 = v2[4][2]
                v7 = v4.Map
                v18 = v12 == v7
                v3 = v18 and 128 - v3 or 216
            elseif v3 == 40 then
                v7 = v4[v15.Name]
                v3 = v7 and 237 or 99 - v3
            elseif v3 == 49 then
                v13 = v11
                v10 = true
                v14 = v2[2][2].CircleOccupied(v13, true)
                v3 = v14 and 45 or 96
            elseif v3 == 52 then
                v13 = not v14
                v3 = v13 and v3 + 56 or 85
            elseif v3 == 53 then
                v3, v16, v10, v6 = v3 + 16, v13, v2[2][2].CircleOccupied, true
                v10 = v10(v16, true)
            elseif v3 == 67 then
                v6 = not v13
                v3 = v6 and v3 + 30 or 30
            elseif v3 == 68 then
                v3 = v16 and 225 - v3 or 168
            elseif v3 == 69 then
                v3 = v10 and 189 or 146 - v3
            elseif v3 == 72 then
                v18 = v13.Name
                v5, v15 = v2[2][2].Invoke("ElevatorEnter", v18)
                v18 = not v5
                v3 = v18 and 77 - v3 or 792
            elseif v3 == 73 then
                v15 = v16.Name
                v17 = v5[v15]
                v3 = v17 and v3 + 30 or 167 - v3
            elseif v3 == 77 then
                v10 = v2[2][2]
                v13 = v10.LobbyAttempt
                v3 = v13 and v3 + 158 or 204
            elseif v3 == 78 then
                return
            elseif v3 == 84 then
                v15 = v2[2][2].Elevator
                v18 = v13.Name
                v3, v5 = 326 - v3, v15 ~= v18
            elseif v3 == 85 then
                v10 = v2[2][2]
                v13 = v10.LobbyAttempt
                v3 = v13 and 97 - v3 or 207
            elseif v3 == 86 then
                v3 = v14 and 16340 / v3 or v3 + 81
            elseif v3 == 89 then
                v3 = 199
                v16 = v2[2][2]
                v8 = v16
                v10 = v16.WalkToJoin
                v5 = v8
                v16 = v8.JoinWalkExit.Position
                v17 = v5.JoinWalkExit
                v8 = v17.Id
                v6 = "Exit:" .. v8
                v10 = v10(v16, v6)
                v13 = not v10
            elseif v3 == 90 then
                v2[2][2].AvoidCircle(v11)
                return
            elseif v3 == 91 then
                v7 = v15
                v4 = false
                v12 = v2[2][2].CircleOccupied(v7, false)
                v3 = 216
                v18 = not v12
            elseif v3 == 94 then
                v3 = 103
                v17 = 0
            elseif v3 == 95 then
                v3, v4 = 17100 / v3, v7 < v10
            elseif v3 == 96 then
                v10 = v2[2][2]
                v3, v13 = 141 - v3, v10.IsHost
                v14 = not v13
            elseif v3 == 97 then
                v8 = v2[2][2]
                v8.CancelJoinWalk()
                v6, v17, v15, v8 = v8.SetStatus, "Waiting for an empty elevator: ", v2[4][2], "Lobby"
                v6("Lobby", "Waiting for an empty elevator: " .. v15.Map)
                return
            elseif v3 == 102 then
                v3 = v14 and 345 - v3 or v3 + 48
            elseif v3 == 103 then
                v3 = 134
                v6 = v8 >= v17
            elseif v3 == 106 then
                v3 = v8 and 124 or 93
            elseif v3 == 107 then
                v2[2][2].SetStatus("Lobby", "Waiting for ElevatorEntered confirmation")
                return
            elseif v3 == 108 then
                v2[2][2].SetStatus("Lobby", "Waiting for character")
                return
            elseif v3 == 113 then
                v13 = v2[4][2].Players
                v10 = 1
                v14 = v13 == 1
                v3 = v14 and 49 or 158 - v3
            elseif v3 == 121 then
                v18 = true
                v15 = v13
                v5 = v2[2][2].CircleOccupied(v15, true)
                v3 = v5 and 363 - v3 or 250 - v3
            elseif v3 == 124 then
                v5 = "Walk"
                v17 = v2[4][2].JoinMethod
                v3 = v17 == "Walk" and 6944 / v3 or 1
            elseif v3 == 127 then
                v10 = nil
                v13 = v2[2][2]
                v3, v13.JoinWalkExit = 29972 / v3, nil
            elseif v3 == 134 then
                v3 = v6 and 229 or v3 + -119
            elseif v3 == 157 then
                v17 = v2[2][2]
                v8 = v17.JoinWalk.Target
                v16 = v9:FindFirstChild(v8)
                v6 = v16
                v3 = v16 and 173 or 39721 / v3
            elseif v3 == 158 then
                v13 = v1._.tonumber
                v16 = v11
                v6 = "Players"
                v10 = v11.GetAttribute
                v10 = table.pack(v10(v11, "Players"))
                v13 = v13(table.unpack(v10, 1, v10.n))
                v3 = v13 and 5688 / v3 or 259 - v3
            elseif v3 == 164 then
                v4 = not v10
                v7 = (v12 - v14.Position).Magnitude
                v3 = v4 and 344 - v3 or 15580 / v3
            elseif v3 == 167 then
                v13 = v2[4][2]
                v14 = v13.StartNow
                v3 = v14 and 29559 / v3 or 102
            elseif v3 == 168 then
                v6 = v1._.ipairs
                v8 = v9.GetChildren
                v16 = v13 ~= nil
                v8 = v1.h(v8(v9))
                v6, v8, v17 = v6(v1.i(v8))
                v6, v8, v17 = v1.g(v6, v8, v17)
                v5, v15 = v6(v8, v17)
                v17 = v5
                v3 = v5 == nil and 67 or v3 + -131
            elseif v3 == 173 then
                v8 = v16:GetAttribute("Map")
                v5 = v2[4][2]
                v17 = v5.Map
                v3, v6 = 43769 / v3, v8 == v17
            elseif v3 == 177 then
                v13 = v2[2][2]
                v3 = 102
                v14 = v13.IsHost
            elseif v3 == 180 then
                v3 = v4 and v3 + 20 or 346 - v3
            elseif v3 == 183 then
                v13 = v2[2][2]
                v13.LobbyAttempt = nil
                v10 = v13
                v13 = v13.JoinWalkExit
                v3 = v13 and v3 + -159 or 419 - v3
            elseif v3 == 186 then
                v3 = v5 and 48 or 4
            elseif v3 == 187 then
                v3 = v9 and v3 + -100 or 335 - v3
            elseif v3 == 192 then
                v3 = v5 and v3 + -6 or 7
            elseif v3 == 198 then
                v16 = true
                v3 = 32
                v10 = v13 ~= true
            elseif v3 == 199 then
                v3 = v13 and 34825 / v3 or 127
            elseif v3 == 200 then
                v10, v3, v13 = v7, v3 + -34, v15
            elseif v3 == 201 then
                return
            elseif v3 == 217 then
                v15 = v2[2][2]
                v12, v18, v15, v5 = v13.Name, "Walking to ", "Lobby", v15.SetStatus
                v5("Lobby", "Walking to " .. v12)
                return
            elseif v3 == 218 then
                v2[2][2].AvoidCircle(v13)
                return
            elseif v3 == 225 then
                v10 = v2[2][2].SetStatus
                v16 = "Lobby"
                v6 = "Start rejected; waiting for the elevator countdown"
                v3 = 0
                v10("Lobby", "Start rejected; waiting for the elevator countdown")
            elseif v3 == 229 then
                v3 = 168
                v13 = v16
            elseif v3 == 236 then
                v13 = nil
                v10 = nil
                v8 = "Walk"
                v6 = v2[4][2].JoinMethod
                v16 = v6 == "Walk"
                v3 = v16 and 105 or v3 + -168
            elseif v3 == 237 then
                v3, v18 = 53562 / v3, v12 >= v7
            elseif v3 == 238 then
                v3 = 40
                v4 = {}
            elseif v3 == 242 then
                v3 = v5 and 218 or 25
            elseif v3 == 243 then
                v3 = 150
                v10 = v2[2][2]
                v13 = v10.StartRequested
                v14 = not v13
            elseif v3 == 244 then
                v3 = v14 and 386 - v3 or 0
            elseif v3 == 249 then
                v2[2][2].AvoidCircle(v13)
                return
            elseif v3 == 253 then
                v3 = v6 and v3 + -71 or 117
            elseif v3 == 719 then
                v7, v12, v3, v18 = "Enter rejected; checking elevator again in 15s", "Lobby", v3 + -641, v2[2][2].SetStatus
                v18("Lobby", "Enter rejected; checking elevator again in 15s")
            elseif v3 >= 2 and v3 <= 3 then
                v3 = v12 and 197 or 255
            elseif v3 <= 0 then
                return
            elseif v3 >= 8 and v3 <= 10 then
                v18 = {}
                v7 = v1._.os
                v5 = v2[2][2]
                v18.At = v7.clock()
                v12 = v13.Name
                v18.Id = v12
                v5.LobbyAttempt = v18
                v1._.task.wait(0.8)
                v18 = v2[2][2]
                v15 = v18.Running
                v5 = not v15
                v3 = v5 and 112 or v3 + 34
            elseif v3 >= 12 and v3 <= 14 then
                v3, v10, v16 = 2484 / v3, v2[4][2].Players, 1
                v13 = v10 == 1
            elseif v3 >= 15 and v3 <= 18 then
                v8 = v2[2][2]
                v3, v6 = 183 - v3, v8.CancelJoinWalk
                v6()
            elseif v3 >= 20 and v3 <= 24 then
                v16 = "Walk"
                v10 = v2[4][2].JoinMethod
                v13 = v10 == "Walk"
                v3 = v13 and 2136 / v3 or 199
            elseif v3 >= 31 and v3 <= 32 then
                v3 = v10 and 7200 / v3 or 32 - v3
            elseif v3 >= 26 and v3 <= 28 then
                v6 = v2[2][2]
                v16 = v6.LobbyAttempt.Id
                v13 = v9:FindFirstChild(v16)
                v10 = v13
                v3 = v13 and 53 or 1932 / v3
            elseif v3 >= 29 and v3 <= 30 then
                v8 = v13
                v17 = false
                v6 = v2[2][2].CircleOccupied(v8, false)
                v3 = v6 and 6 or 185
            elseif v3 >= 33 and v3 <= 36 then
                v16 = v2[4][2]
                v10 = v16.Players
                v3 = 244
                v14 = v13 >= v10
            elseif v3 >= 38 and v3 <= 39 then
                v11 = v2[3][2].Character
                v14 = v11
                v3 = v11 and 284 - v3 or 52
            elseif v3 >= 46 and v3 <= 48 then
                v3 = v5 and 9648 / v3 or 66
            elseif v3 >= 41 and v3 <= 42 then
                v3 = 112
                v18 = v2[4][2]
                v15 = v18.AutoLobby
                v5 = not v15
            elseif v3 >= 43 and v3 <= 45 then
                v3 = v14 and 90 or 224
            elseif v3 >= 50 and v3 <= 51 then
                return
            elseif v3 >= 54 and v3 <= 56 then
                v18 = v8
                v12 = v13.Name
                v15 = v2[2][2].WalkToJoin(v18, v12)
                v5 = not v15
                v3 = v5 and 217 or 64 - v3
            elseif v3 >= 60 and v3 <= 61 then
                v14 = "Elevators"
                v9 = v2[1][2]:FindFirstChild("Elevators")
                v11 = not v9
                v3 = v11 and 112 - v3 or 75
            elseif v3 >= 57 and v3 <= 59 then
                v3 = 237
                v7 = 0
            elseif v3 >= 62 and v3 <= 66 then
                v15 = v2[4][2].Players
                v18 = 1
                v5 = v15 == 1
                v3 = v5 and 121 or 242
            elseif v3 >= 74 and v3 <= 76 then
                v14 = v2[2][2]
                v11 = v14.Elevator
                v3 = v11 and 161 or 38
            elseif v3 >= 70 and v3 <= 71 then
                v7 = v1._.os
                v12 = v7.clock()
                v4 = v2[2][2].CircleCooldowns
                v3 = v4 and 111 - v3 or 238
            elseif v3 >= 79 and v3 <= 83 then
                v3 = 197
                v12 = v18.Position
            elseif v3 >= 87 and v3 <= 88 then
                v3 = v9 and 10701 / v3 or 61
            elseif v3 >= 104 and v3 <= 105 then
                v3 = 68
                v6 = v2[2][2]
                v16 = v6.JoinWalk
            elseif v3 >= 98 and v3 <= 101 then
                v3, v13 = v3 + -65, 0
            elseif v3 >= 92 and v3 <= 93 then
                v3 = 124
                v8 = v6.Position
            elseif v3 >= 114 and v3 <= 120 then
                v3 = v6 and 29250 / v3 or 15678 / v3
            elseif v3 >= 111 and v3 <= 112 then
                v3 = v5 and 21504 / v3 or 11
            elseif v3 >= 109 and v3 <= 110 then
                v3 = v7 and 164 or 18260 / v3
            elseif v3 >= 234 and v3 <= 235 then
                v16 = v1._.os.clock()
                v17 = v2[2][2]
                v8 = v17.LobbyAttempt
                v6 = v8.At
                v16, v3, v10 = 15, 204, v16 - v6
                v13 = v10 < 15
            elseif v3 >= 239 and v3 <= 241 then
                v2[2][2].Elevator = nil
                return
            elseif v3 >= 250 and v3 <= 252 then
                v17 = v1._.os
                v8 = v17.clock()
                v15 = v2[2][2]
                v5 = v15.CircleCooldowns
                v3 = v5 and 323 - v3 or 58250 / v3
            elseif v3 >= 245 and v3 <= 248 then
                v14, v10, v3, v13 = v11.FindFirstChild, "HumanoidRootPart", v3 + -194, v11
                v14 = v14(v13, "HumanoidRootPart")
            elseif v3 >= 720 then
                v12 = true
                v3, v18 = 797 - v3, v15 ~= true
            elseif v3 >= 254 and v3 <= 718 then
                v4 = "BasePart"
                v7 = v18
                v12 = v18:IsA("BasePart")
                v3 = v12 and 83 or v3 + -58
            elseif v3 >= 226 and v3 <= 228 then
                v3 = v18 and 40454 / v3 or 166
            elseif v3 >= 230 and v3 <= 233 then
                v3, v15 = 306 - v3, {}
                v5 = v15
            elseif v3 >= 219 and v3 <= 224 then
                v14 = v2[2][2].SetStatus
                v16 = v1._.string
                v8, v10, v16 = v2[2][2], v16.format, "%s | %s | %s/%s | %ss"
                v6, v15, v8, v17, v5 = v8.Elevator, "Map", v1._.tostring, v11.GetAttribute, v11
                v17 = v1.h(v17(v5, "Map"))
                v8 = v8(v1.i(v17))
                v17 = v1._.tostring
                v5 = v11.GetAttribute
                v5 = v1.h(v5(v11, "Players"))
                v17 = v17(v1.i(v5))
                v5 = v1._.tostring
                v15 = v11.GetAttribute
                v15 = table.pack(v15(v11, "MaxPlayers"))
                v5 = v5(table.unpack(v15, 1, v15.n))
                v12 = v11
                v15 = v1._.tostring
                v7 = "Time"
                v18 = v11.GetAttribute
                v18 = table.pack(v18(v11, "Time"))
                v15 = v1.h(v15(table.unpack(v18, 1, v18.n)))
                v10 = table.pack(v10("%s | %s | %s/%s | %ss", v6, v8, v17, v5, table.unpack(v15, 1, v15.n)))
                v14("Lobby", table.unpack(v10, 1, v10.n))
                v13 = v2[2][2]
                v14 = v13.IsHost
                v3 = v14 and 34944 / v3 or 86
            elseif v3 >= 208 and v3 <= 216 then
                v3 = v18 and 287 - v3 or v3 + 10
            elseif v3 >= 190 and v3 <= 191 then
                return
            elseif v3 >= 193 and v3 <= 197 then
                v7 = v12
                v3 = v12 and v3 + -58 or 307 - v3
            elseif v3 >= 205 and v3 <= 207 then
                v3 = v13 and 28 or 77
            elseif v3 >= 202 and v3 <= 204 then
                v3 = v13 and 107 or 387 - v3
            elseif v3 >= 184 and v3 <= 185 then
                v6 = v13:FindFirstChild("Pad")
                v5 = "Model"
                v17 = v6
                v8 = v6:IsA("Model")
                v3 = v8 and 19 or 291 - v3
            elseif v3 >= 188 and v3 <= 189 then
                v2[2][2].AvoidCircle(v13)
                return
            elseif v3 >= 181 and v3 <= 182 then
                v5 = false
                v17 = v16
                v8 = v2[2][2].CircleOccupied(v17, false)
                v3 = 117
                v6 = not v8
            elseif v3 >= 178 and v3 <= 179 then
                v7 = "Pad"
                v18 = v15:FindFirstChild("Pad")
                v12 = v18
                v3 = v18 and 137 or 197
            elseif v3 >= 162 and v3 <= 163 then
                v18 = false
                v15 = v13
                v5 = v2[2][2].CircleOccupied(v15, false)
                v3 = v5 and 249 or 72
            elseif v3 >= 165 and v3 <= 166 then
                v5, v15 = v6(v8, v17)
                v17 = v5
                v3 = v5 == nil and v3 + -99 or 203 - v3
            elseif v3 >= 174 and v3 <= 176 then
                v2[2][2].SetStatus("Lobby", "Walking out of the occupied elevator")
                return
            elseif v3 >= 169 and v3 <= 172 then
                v3 = 2
                v4 = v18
                v7 = v18:GetPivot()
                v12 = v7.Position
            elseif v3 >= 125 and v3 <= 126 then
                v11 = v1._.game.PlaceId
                v13 = v2[2][2]
                v14 = v13.LobbyId
                v9 = v11 ~= v14
                v3 = v9 and 187 or 152
            elseif v3 >= 122 and v3 <= 123 then
                v11 = v2[2][2]
                v11.CancelJoinWalk()
                v9, v11 = v11, nil
                v9.JoinWalkExit = nil
                return
            elseif v3 >= 128 and v3 <= 133 then
                v15 = v2[2][2]
                v5 = v15.Elevator
                v3 = v5 and 213 - v3 or v3 + 113
            elseif v3 >= 135 and v3 <= 137 then
                v7 = v18
                v4 = "Model"
                v12 = v18:IsA("Model")
                v3 = v12 and 23564 / v3 or 2
            elseif v3 >= 138 and v3 <= 139 then
                v3, v7 = 15290 / v3, not v16
            elseif v3 >= 159 and v3 <= 161 then
                v14 = v2[2][2]
                v14.CancelJoinWalk()
                v14, v11 = nil, v14
                v11.JoinWalkExit = nil
                v13, v14, v11 = v11.Elevator, v9, v9.FindFirstChild
                v11 = v11(v14, v13)
                v14 = not v11
                v3 = v14 and v3 + 80 or 274 - v3
            elseif v3 >= 149 and v3 <= 150 then
                v3 = v14 and 308 - v3 or 36600 / v3
            elseif v3 >= 143 and v3 <= 148 then
                v11 = v2[2][2]
                v3 = 87
                v9 = v11.Teleporting
            elseif v3 >= 140 and v3 <= 142 then
                v14 = v2[2][2]
                v14.StartRequested = true
                v10, v13, v14 = v2[2][2], "ElevatorStart", v14.Invoke
                v14, v13 = v14("ElevatorStart", v10.Elevator)
                v10 = not v14
                v3 = v10 and 32 or 198
            elseif v3 >= 151 and v3 <= 152 then
                v3, v14 = 339 - v3, v2[4][2]
                v11 = v14.AutoLobby
                v9 = not v11
            elseif v3 >= 153 and v3 <= 156 then
                v10 = v2[2][2]
                v3, v13 = v3 + -70, v10.ApplyModifiers()
                v14 = not v13
            end
        until false
    end
end
local function _w276(v1, v2)
    return function()
        local v3 = 64
        local v4, v5, v6, v7, v8, v9, v10
        while true do
            if v3 == 24 then
                v10 = v1._.getnamecallmethod
                v5 = v1._.type(v10)
                v3 = 166
                v10 = "function"
                v6 = v5 ~= "function"
            elseif v3 == 64 then
                v4 = {[1] = 2, [2] = v2[2][2].__CameraTDRecorderRouter}
                v4[3] = v4
                v6 = v4[2]
                v3 = v6 and 89 or 138
            elseif v3 == 89 then
                v10 = 3
                v5 = v4[2].Version
                v3 = 138
                v6 = v5 ~= 3
            elseif v3 == 138 then
                v3 = v6 and 1518 / v3 or 177
            elseif v3 == 216 then
                v9 = v2[1][2].Remote(v8)
                v3 = v9 and 145 or 111
            elseif v3 >= 25 and v3 <= 63 then
                return v4[2].Installed == true
            elseif v3 <= 1 then
                v6 = {[1] = 2, [2] = nil}
                v6[3] = v6
                v5 = v1:qd({v6, v4})
                v7 = v1._.newcclosure
                v10 = v1._.type(v7)
                v7 = "function"
                v3 = v10 == "function" and 246 or v3 + 192
            elseif v3 >= 2 and v3 <= 23 then
                v4[2].Hub = nil
                v4[2], v6, v5 = nil, v2[2][2], nil
                v3, v6.__CameraTDRecorderRouter = 177, nil
            elseif v3 >= 65 and v3 <= 88 then
                v2[2][2].__CameraTDRecorderRouter = nil
                return false
            elseif v3 >= 90 and v3 <= 131 then
                v7, v8 = v6(v5, v10)
                v10 = v7
                v3 = v7 == nil and 63 or 327 - v3
            elseif v3 >= 178 and v3 <= 193 then
                v7 = v1._.hookmetamethod
                v8 = v1._.game
                v9 = "__namecall"
                v10, v7 = v1._.pcall(v7, v8, "__namecall", v5)
                v8 = not v10
                v3 = v8 and v3 + -107 or 200
            elseif v3 >= 194 and v3 <= 215 then
                v6[2], v8 = v7, true
                v3, v4[2].Installed = 132, true
            elseif v3 >= 167 and v3 <= 177 then
                v6 = not v4[2]
                v3 = v6 and 153 or 132
            elseif v3 >= 154 and v3 <= 166 then
                v3 = v6 and 250 - v3 or 166 / v3
            elseif v3 >= 146 and v3 <= 153 then
                v6, v4[2] = v2[2][2], {Version = 3}
                v6.__CameraTDRecorderRouter = v4[2]
                v10 = v1._.hookmetamethod
                v5 = v1._.type(v10)
                v10 = "function"
                v6 = v5 ~= "function"
                v3 = v6 and 25398 / v3 or 24
            elseif v3 >= 132 and v3 <= 137 then
                v6 = v2[1][2]
                v4[2].Hub = v6
                v6.RecordRemotes = {}
                v9 = "TowerUpgrade"
                v6 = v1._.ipairs
                v7 = {}
                v7[3], v7[4], v7[2], v7[5], v7[1] = "TowerTarget", "TowerSell", "TowerUpgrade", "WaveSkip", "TowerAdd"
                v6, v5, v10 = v6(v7)
                v6, v5, v10 = v1.g(v6, v5, v10)
                v7, v8 = v6(v5, v10)
                v10 = v7
                v3 = v7 == nil and 195 - v3 or v3 + 84
            elseif v3 >= 139 and v3 <= 145 then
                v3 = 111
                v2[1][2].RecordRemotes[v9] = v8
            else
                v7 = v5
                v10 = v1._.newcclosure(v5)
                v3, v5 = v3 + -53, v10
            end
        end
    end
end
local function _w277(v1, v2)
    return function(v3)
        v2[2][2].AutoClaimQuest = v3 == true
        v2[1][2].Next.Quest = nil
        v2[1][2].SaveSettings()
    end
end
local function _w278(v1, v2)
    return function(v3)
        local v4 = 208
        local v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
        repeat
            if v4 == 25 then
                v4 = 24
                v11 = 0
            elseif v4 == 79 then
                v12 = v9.Cost
                v11 = v1._.tonumber(v12)
                v4 = v11 and v4 + -55 or 25
            elseif v4 == 133 then
                v7 = "Place"
                v14 = v9.Kind
                v4 = v14 == "Place" and 357 - v4 or 213
            elseif v4 == 180 then
                v5, v9 = v10(v13, v8)
                v8 = v5
                v4 = v5 == nil and 334 - v4 or 133
            elseif v4 == 224 then
                v7 = v9.Name
                v14 = v9.Key
                v4, v6[v14] = 47712 / v4, v7
            elseif v4 >= 108 and v4 <= 132 then
                v4, v7 = v4 + -87, 1
            elseif v4 >= 134 and v4 <= 153 then
                v15 = v14
                v4 = v14 and 23829 / v4 or 6345 / v4
            elseif v4 >= 80 and v4 <= 107 then
                v4 = 141
                v7 = v9.Level
            elseif v4 <= 21 then
                v4 = v7 and 141 or 3402 / v4
            elseif v4 >= 22 and v4 <= 24 then
                v4, v12 = 6048 / v4, 0
                v15 = v11 > 0
            elseif v4 >= 26 and v4 <= 27 then
                v11 = v2[1][2]
                v15 = v11.KnownCosts
                v11 = v11.KnownCosts[v14]
                v4 = v11 and 248 or v4 + 223
            elseif v4 >= 28 and v4 <= 78 then
                v4 = v15 and 124 - v4 or 252
            elseif v4 >= 213 and v4 <= 223 then
                v15 = v9.Kind
                v14 = v6[v9.Key]
                v11 = "Place"
                v7 = v15 == "Place"
                v4 = v7 and 108 or 21
            elseif v4 >= 225 and v4 <= 248 then
                v15[v14] = v11
                v4 = 180
                v11 = v2[1][2].KnownCosts
                v11, v15 = v9.Cost, v11[v14]
                v15[v7] = v11
            elseif v4 >= 249 and v4 <= 250 then
                v4 = 248
                v11 = {}
            elseif v4 >= 251 then
                v4 = v15 and v4 + -225 or v4 + -72
            elseif v4 >= 155 and v4 <= 168 then
                v11 = "Upgrade"
                v15 = v9.Kind
                v7 = v15 == "Upgrade"
                v4 = v7 and v4 + -70 or 303 - v4
            elseif v4 >= 169 and v4 <= 179 then
                v4 = 45
                v15 = v7
            elseif v4 >= 181 and v4 <= 212 then
                v6 = {}
                v10, v13, v8 = v1._.ipairs(v3.Actions)
                v10, v13, v8 = v1.g(v10, v13, v8)
                v5, v9 = v10(v13, v8)
                v8 = v5
                v4 = v5 == nil and 154 or 133
            end
        until false
    end
end
local function _w279(v1, v2, v3, v4)
    v1.Fe[v4] = v1.me(v2, v3)
    return v1.Fe[v4]
end
local function _w281(v1, v2)
    return function()
        local v3 = 222
        local v4, v5, v6, v7, v8
        while true do
            if v3 == 180 then
                v4 = v2[1][2]
                v5 = v4.Running
                v3 = v5 and 58 or v3 + -59
            elseif v3 == 222 then
                v3 = 180
            elseif v3 >= 209 and v3 <= 221 then
                v3 = v7 and 208 or 157
            elseif v3 >= 205 and v3 <= 208 then
                v2[1][2].Next.SkipError = v1._.os.clock() + 10
                v7 = v1._.warn
                v3, v6 = 365 - v3, v1._.tostring(v4)
                v8 = "[Camera TD Hub] Auto Skip: " .. v6
                v7(v8)
            elseif v3 >= 181 and v3 <= 204 then
                v3 = 251
                v6 = 0
            elseif v3 >= 157 and v3 <= 179 then
                v7, v3, v8 = v1._.task.wait, 28260 / v3, 0.25
                v7(0.25)
            elseif v3 >= 122 and v3 <= 156 then
                v8 = v1._.os.clock()
                v6 = v2[1][2].Next.SkipError
                v3 = v6 and 251 or 204
            elseif v3 >= 59 and v3 <= 121 then
                return
            elseif v3 <= 58 then
                v4 = v2[1][2].SkipStep
                v5, v4 = v1._.pcall(v4)
                v7 = not v5
                v3 = v7 and 205 - v3 or 12180 / v3
            else
                v3, v7 = v3 + -41, v8 >= v6
            end
        end
    end
end
local function _w282(v1, v2)
    return function(v3)
        local v4, v5, v6, v7, v8, v9, v10, v11, v12
        if not v3 then
            return nil
        else
            v11 = v2[1][2]
            v11, v4 = v3.Name, v11.ConfigUnit
            v4 = v4(v11)
            v11 = v1._.type(v4) == "table" and (v4.Upgrades or v4.Levels or v4)
            v6 = v1._.type(v11) == "table"
            if v6 then
                v7 = v3.Level
                v8 = v1._.tonumber(v7)
                if v8 then
                    v6 = v11[v8 + 1]
                else
                    v6 = v11[2]
                end
            end
            v10 = v1._.type(v6) == "table"
            if v10 then
                v10 = v1._.tonumber
                v8 = v6.Price
                if v8 then
                    v10 = v10(v8)
                else
                    v10 = v10(v6.Cost)
                end
                if v10 ~= nil then
                    return v10
                else
                    v9 = v2[1][2]
                    v9, v7 = v3.Name, v9.KnownCosts
                    v8 = v7[v9]
                    v7 = v8
                    if v8 then
                        v5 = v3.Level
                        v12 = v1._.tonumber(v5)
                        if v12 then
                            v7 = v8[v12 + 1]
                        else
                            v7 = v8[2]
                        end
                        if v7 then
                            return v7
                        else
                            return nil
                        end
                    elseif v7 then
                        return v7
                    else
                        return nil
                    end
                end
            elseif v10 ~= nil then
                return v10
            else
                v9 = v2[1][2]
                v9, v7 = v3.Name, v9.KnownCosts
                v8 = v7[v9]
                v7 = v8
                if v8 then
                    v5 = v3.Level
                    v12 = v1._.tonumber(v5)
                    if v12 then
                        v7 = v8[v12 + 1]
                    else
                        v7 = v8[2]
                    end
                    if v7 then
                        return v7
                    else
                        return nil
                    end
                elseif v7 then
                    return v7
                else
                    return nil
                end
            end
        end
    end
end
local function _w283(v1, v2)
    return function(v3)
        local v4 = v1._.type(v3) == "string" and v3:match("just changed the game speed to ([%d%.]+)")
        local v5 = v4
        local v6
        if v4 then
            v5 = v1._.tonumber
            v6 = v4.match
            v6 = table.pack(v6(v4, "%d+%.?%d*"))
            v5 = v5(table.unpack(v6, 1, v6.n))
        end
        v4 = v5
        if v5 then
            v2[1][2].ConfirmSpeed(v4)
        end
    end
end
local function _w284(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5 = v1._.table.find
        local v6 = {}
        v6[1], v6[2], v6[3] = "None", "Replay", "Return"
        local v7
        v6, v7 = v3, v6
        v5 = v5(v7, v6)
        if v5 then
            v5 = v3
            if v5 then
                v4.EndAction = v5
            else
                v4.EndAction = "None"
            end
        else
            v4.EndAction = "None"
        end
        v2[1][2].SaveSettings()
    end
end
local function _w285(v1, v2)
    return function(v3, v4)
        v4 = {[1] = 2, [2] = v4}
        v4[3] = v4
        local v5 = {[1] = 2, [2] = v2[1][2].Widgets[v3]}
        v5[3] = v5
        local v6
        if v5[2] then
            v2[1][2].ChangingToggle = true
            v6 = v1:ic({v4, v5})
            v1._.pcall(v6)
            v2[1][2].ChangingToggle = false
        end
    end
end
local function _w286(v1, v2)
    return function(v3, v4)
        v3 = {[1] = 2, [2] = v3}
        v3[3] = v3
        v4 = {[1] = 2, [2] = v4}
        v4[3] = v4
        local v5, v6
        if not v2[2][2].FS then
            return false, "Executor filesystem unavailable"
        else
            v6, v5 = v1._.pcall(v1:Dc({v3, v2[1], v4}))
            return v6, v5
        end
    end
end
local function _w287(v1, v2)
    return function()
        local v3 = v2[2][2].Wave() > v2[1][2]
        local v4, v5
        if not v3 then
            v4 = v2[2][2]
            v3 = v4.Visible
            v4, v5 = v4.GUI, "Stats/WaveSkipGui"
            v4 = table.pack(v4("Stats/WaveSkipGui"))
            v3 = v3(table.unpack(v4, 1, v4.n))
        end
        return v3
    end
end
local function _w288(v1)
    return function()
        local v2 = 230
        local v3, v4, v5, v6, v7, v8, v9, v10, v11
        repeat
            if v2 == 62 then
                return v7
            elseif v2 == 149 then
                v6, v7 = v4(v10, v11)
                v11 = v6
                v2 = v6 == nil and v2 + -17 or v2 + 36
            elseif v2 == 215 then
                v6[2], v6[4], v6[3], v6[1] = v5, v9, v8, v7
                v4, v10, v11 = v4(v6)
                v4, v10, v11 = v1.g(v4, v10, v11)
                v6, v7 = v4(v10, v11)
                v11 = v6
                v2 = v6 == nil and v2 + -83 or 185
            elseif v2 >= 133 and v2 <= 148 then
                v9 = v1._.syn
                v2, v8 = 6750 / v2, v9.request
            elseif v2 <= 61 then
                v9 = v1._.fluxus
                v2 = v9 and 197 or 10750 / v2
            elseif v2 >= 63 and v2 <= 132 then
                return
            elseif v2 >= 150 and v2 <= 196 then
                v5 = v1._.type(v7)
                v8 = "function"
                v2 = v5 == "function" and 62 or 149
            elseif v2 >= 197 and v2 <= 214 then
                v2, v3 = 412 - v2, v1._.fluxus
                v9 = v3.request
            else
                v8 = v1._.syn
                v7 = v1._.http_request
                v4 = v1._.pairs
                v6 = {}
                v5 = v1._.request
                v2 = v8 and 135 or 50
            end
        until false
    end
end
local function _w289(v1, v2)
    return function(v3)
        local v4 = v1._.tonumber
        local v5 = v2[2][2]
        local v6 = v1._.tostring(v3)
        local v7, v8
        v7, v8, v6 = v6, "[%d%.]+", v6.match
        v6 = table.pack(v6(v7, "[%d%.]+"))
        v4 = v4(table.unpack(v6, 1, v6.n))
        if v4 then
            v5.SpeedScale = v4
        else
            v5.SpeedScale = 1
        end
        v4 = v2[1][2]
        v5 = v4.Speed
        v4, v7, v6 = v4.Speed, nil, nil
        v5.Applied = nil
        v4.Rejected = nil
        v2[1][2].Next.Speed = nil
        v2[1][2].SaveSettings()
    end
end
local function _w290(v1, v2)
    return function(v3)
        local v4 = v1._.type(v3) == "table"
        local v5, v6
        if v4 then
            v5 = v2[1][2]
            v5, v6 = v3.Id, v5.Towers
            v4 = v6[v5]
        end
        v6 = v4
        if v4 then
            v6 = v4.TargetMode
        end
        v5 = v2[1][2].MergeTower(v3)
        local v7 = v5
        local v8
        if v5 then
            if v6 ~= v5.TargetMode then
                v7 = v2[1][2].RecordAction
                v8 = v2[1][2].TakeStamp
                v8 = table.pack(v8("TowerTarget", v5))
                v7("Target", v5, table.unpack(v8, 1, v8.n))
            end
            return
        elseif v7 then
            v7 = v2[1][2].RecordAction
            v8 = v2[1][2].TakeStamp
            v8 = table.pack(v8("TowerTarget", v5))
            v7("Target", v5, table.unpack(v8, 1, v8.n))
            return
        else
            return
        end
    end
end
local function _w291(v1, v2)
    return function()
        local v3 = 205
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
        repeat
            if v3 == 35 then
                v3 = v5 and 225 - v3 or v3 + 162
            elseif v3 == 66 then
                v3 = 174
                v6[2][v10.Id] = true
            elseif v3 == 133 then
                v15 = v2[2][2]
                v11 = v15.Auto
                v3 = 91
                v5 = v11.Busy()
            elseif v3 == 134 then
                v2[2][2].Hydrate()
                v15 = {[1] = 2, [2] = v2[1][2].PlaybackMode}
                v15[3] = v15
                v9 = "Money"
                v4 = v15[2] ~= "Money"
                v3 = v4 and 24656 / v3 or 194 - v3
            elseif v3 == 153 then
                v4 = v2[2][2]
                v4.PlaybackFailure = nil
                v4.PlaybackCompleted = nil
                v4.Playing = true
                v14 = v4.Serial
                v16 = 1
                v4.Serial = v14 + 1
                v9 = v2[1][2]
                v4 = v9.AutoPlayback
                v3 = v4 and 165 or 41
            elseif v3 == 166 then
                v3 = v4 and 108 or 25398 / v3
            elseif v3 == 173 then
                v14 = 0
                v3 = 60
                v4 = v9 > 0
            elseif v3 == 184 then
                v16 = v5[2].Actions
                v14 = v16[1].Wave
                v9 = v1._.tonumber(v14)
                v3 = v9 and 357 - v3 or 396 - v3
            elseif v3 == 212 then
                v3, v9 = v3 + -39, 0
            elseif v3 == 232 then
                v2[2][2].Notify("Selected macro is empty or invalid")
                return false
            elseif v3 >= 124 and v3 <= 132 then
                v3, v4 = 221 - v3, v5[2].Map
                v15 = v4 ~= v11
            elseif v3 >= 135 and v3 <= 152 then
                v2[2][2].SetStatus("Macro", "Waiting for match / intermission")
                return false, "wait"
            elseif v3 >= 109 and v3 <= 123 then
                v3, v11 = v3 + -78, v2[2][2]
                v5 = v11.Recording
            elseif v3 >= 98 and v3 <= 108 then
                v2[2][2].SetStatus("Macro", "Playback armed: waiting for wave 1")
                return false, "wait"
            elseif v3 >= 92 and v3 <= 97 then
                v3 = v15 and 70 or 134
            elseif v3 >= 71 and v3 <= 91 then
                v3 = v5 and 202 or 237
            elseif v3 >= 52 and v3 <= 65 then
                v3 = v4 and 213 or 226 - v3
            elseif v3 >= 42 and v3 <= 51 then
                v11 = v2[2][2]
                v11.LoadedProfile = v5[2]
                v11, v15 = v11.LearnProfileCosts, v5[2]
                v11(v15)
                v11 = v2[2][2].CurrentMap()
                v15 = not v11
                v3 = v15 and v3 + -49 or 171
            elseif v3 >= 67 and v3 <= 70 then
                v2[2][2].Notify("Macro map differs from current map; playback stopped")
                return false
            elseif v3 >= 3 and v3 <= 13 then
                v1._.task.spawn(v1:cd({v16, v5, v9, v4, v2[1], v2[2], v14, v15, v6}))
                return true
            elseif v3 <= 2 then
                v2[2][2].SetStatus("Macro", "Waiting for map waypoints")
                return false, "wait"
            elseif v3 >= 36 and v3 <= 41 then
                v9 = v2[2][2]
                v4 = {[1] = 2, [2] = v9.Serial}
                v4[3] = v4
                v9 = {[1] = 2, [2] = v9.GameClock()}
                v9[3] = v9
                v14 = {[1] = 2, [2] = {}}
                v14[3] = v14
                v16 = {[1] = 2, [2] = {}}
                v16[3] = v16
                v6 = {[1] = 2, [2] = {}}
                v6[3] = v6
                v13 = v1._.ipairs
                v7 = v2[2][2].Owned
                v7 = v1.h(v7())
                v13, v7, v12 = v13(v1.i(v7))
                v13, v7, v12 = v1.g(v13, v7, v12)
                v8, v10 = v13(v7, v12)
                v12 = v8
                v3 = v8 == nil and 6 or 66
            elseif v3 >= 14 and v3 <= 34 then
                v3 = 208
                v15 = #v5[2].Actions
                v4 = 0
                v11 = v15 == 0
            elseif v3 >= 185 and v3 <= 190 then
                v2[2][2].Notify("Stop the active macro first")
                return false
            elseif v3 >= 191 and v3 <= 197 then
                v15 = v2[2][2]
                v11 = v15.Active()
                v5 = not v11
                v3 = v5 and v3 + -60 or 407 - v3
            elseif v3 >= 174 and v3 <= 183 then
                v8, v10 = v13(v7, v12)
                v12 = v8
                v3 = v8 == nil and v3 + -168 or 66
            elseif v3 >= 154 and v3 <= 165 then
                v9 = true
                v4 = v2[2][2]
                v3, v4.AutoPlayed = 41, true
            elseif v3 >= 167 and v3 <= 172 then
                v15 = v5[2].Map
                v3 = v15 and v3 + -47 or 97
            elseif v3 >= 213 and v3 <= 231 then
                v3, v14 = 35358 / v3, v2[2][2]
                v9 = v14.Wave()
                v14 = 1
                v4 = v9 < 1
            elseif v3 >= 206 and v3 <= 208 then
                v3 = v11 and 232 or 51
            elseif v3 >= 203 and v3 <= 205 then
                v11 = v2[2][2]
                v5 = v11.Playing
                v3 = v5 and 35 or 113
            elseif v3 >= 198 and v3 <= 202 then
                v2[2][2].SetStatus("Macro", "Waiting for outstanding Auto Play requests")
                return false, "wait"
            elseif v3 >= 209 and v3 <= 211 then
                v11 = v2[2][2]
                v5 = v11.Auto
                v3 = v5 and 27930 / v3 or 301 - v3
            else
                v11 = v2[2][2]
                v5 = v11.Read
                v15, v11 = v2[1][2], v11.File
                v15 = v15.Profile
                v11 = v1.h(v11(v15))
                v5 = {[1] = 2, [2] = v5(v1.i(v11))}
                v5[3] = v5
                v4 = v2[2][2]
                v4, v15 = v5[2], v4.ValidProfile
                v15 = v15(v4)
                v11 = not v15
                v3 = v11 and 208 or 14
            end
        until false
    end
end
local function _w292(v1, v2)
    return function()
        local v3
        local v4
        if v2[1][2].InventoryData then
            v4 = v2[1][2].InventoryData.Money
            v3 = v1._.tonumber(v4)
            if v3 then
                return v3
            else
                return nil
            end
        else
            return nil
        end
    end
end
local function _w293(v1, v2)
    return function(v3)
        v3 = {[1] = 2, [2] = v3}
        v3[3] = v3
        local v4 = not v2[2][2].FS
        local v5, v6
        if v4 then
            if v4 then
                return nil
            else
                v5 = v1:Wb({v3, v2[1]})
                v4, v5 = v1._.pcall(v5)
                v6 = v4
                if v4 then
                    if v1._.type(v5) == "table" then
                        v6 = v5
                        if v6 then
                            return v6
                        else
                            return nil
                        end
                    else
                        return nil
                    end
                elseif v6 then
                    v6 = v5
                    if v6 then
                        return v6
                    else
                        return nil
                    end
                else
                    return nil
                end
            end
        else
            v6 = v3[2]
            if not v1._.isfile(v6) then
                return nil
            else
                v5 = v1:Wb({v3, v2[1]})
                v4, v5 = v1._.pcall(v5)
                v6 = v4
                if v4 then
                    if v1._.type(v5) == "table" then
                        v6 = v5
                        if v6 then
                            return v6
                        else
                            return nil
                        end
                    else
                        return nil
                    end
                elseif v6 then
                    v6 = v5
                    if v6 then
                        return v6
                    else
                        return nil
                    end
                else
                    return nil
                end
            end
        end
    end
end
local function _w294(v1, v2)
    return function()
        local v3 = {}
        local v4
        local v5 = v2[1][2].SendWebhook
        local v6 = {}
        local v7
        v3.name = "Coins"
        local v8 = v1._.tostring
        local accountCoins2 = v2[1][2].AccountCoins()
        if accountCoins2 then
            v3.value = v8(accountCoins2)
        else
            v3.value = v8("Unavailable")
        end
        v3.inline = false
        v6[1] = v3
        v5, v7 = v5("Webhook Test", "Camera TD Hub webhook is working.", 5763719, v6)
        v2[1][2].WebhookStatus(v5, v7)
        v4 = v2[1][2].Notify
        if v5 then
            v4("Test message sent")
        else
            v4("Webhook failed: " .. v1._.tostring(v7))
        end
    end
end
local function _w295(v1, v2)
    return function()
        v2[2][2].Widgets.Modifiers:Refresh(v2[1][2])
    end
end
local function _w296(v1, v2)
    return function(v3, v4)
        local gUI6 = v2[1][2].GUI("FinalUI/Content/" .. v3)
        local v5 = gUI6
        if gUI6 then
            if gUI6.Text ~= "" then
                v5 = gUI6.Text
                if v5 then
                    return v5
                else
                    return v4
                end
            else
                return v4
            end
        elseif v5 then
            v5 = gUI6.Text
            if v5 then
                return v5
            else
                return v4
            end
        else
            return v4
        end
    end
end
local function _w297(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        v4.ShowRange = v3 == true
        v4 = not v4.ShowRange
        if v4 then
            if v2[1][2].Ring then
                while true do
                    v2[1][2].Ring:Destroy()
                    v2[1][2].Ring = nil
                end
            else
                v2[1][2].SaveSettings()
                return
            end
        else
            v2[1][2].SaveSettings()
            return
        end
    end
end
local function _w298(v1, v2)
    return function(v3)
        v2[2][2].AutoUpgrade = v3 == true
        v2[1][2].SaveSettings()
    end
end
local function _w299(v1, v2, v3, v4, v5)
    v1.vf[v5] = 3 * v3 + (2 * bit32.band(bit32.bnot(v3), bit32.bxor(v3, 4294967295)) + (bit32.bnot(v4) * -2 + (-v4 + (bit32.band(bit32.band(65535, v4), bit32.band(v3, 65535)) * bit32.bor(bit32.band(v3, 65535), bit32.band(65535, v4)) + bit32.band(bit32.bnot(bit32.band(v3, 65535)), bit32.band(65535, v4)) * bit32.band(bit32.band(65535, v3), bit32.bnot(bit32.band(v4, 65535))) - bit32.band(65535, v3) * bit32.band(65535, v4)))) + v2)
    return v1.vf[v5]
end
local function _w300(v1, v2)
    return function()
        local v3 = 71
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19
        repeat
            if v3 == 39 then
                v13 = v2[3][2].Ring
                v17 = v1._.CFrame.new
                v15 = v8 + v1._.Vector3.new(0, 0.12, 0)
                v17 = table.pack(v17(v15))
                v13:PivotTo(table.unpack(v17, 1, v17.n))
                return
            elseif v3 == 199 then
                v7 = v2[3][2]
                v13 = v7.Active()
                v3 = 65
                v8 = not v13
            elseif v3 == 251 then
                v7 = v7 + v15
                v3 = (v15 > 0 and v7 > v17 or v15 <= 0 and v7 < v17 or false) and 43 or 167
            elseif v3 >= 209 and v3 <= 242 then
                return
            elseif v3 >= 200 and v3 <= 208 then
                v8 = v2[3][2].PathTarget()
                v13 = not v8
                v3 = v13 and v3 + -30 or 463 - v3
            elseif v3 >= 178 and v3 <= 198 then
                return
            elseif v3 >= 243 and v3 <= 250 then
                v13 = v1._.Instance.new("Model")
                v13.Name = "CameraTDAutoPlayPlacementRange"
                v15 = 1
                v7 = 0
                v17 = 47
                v3 = 167
            elseif v3 >= 44 and v3 <= 65 then
                v3 = v8 and 204 - v3 or v3 + 143
            elseif v3 >= 40 and v3 <= 43 then
                v17 = v1._.CFrame
                v13.WorldPivot = v17.new()
                v13.Parent = v2[1][2]
                v3 = 39
                v7 = v2[3][2]
                v7.Ring = v13
            elseif v3 <= 38 then
                v3 = 242
                v2[3][2].Ring:Destroy()
                v8 = v2[3][2]
                v13 = nil
                v8.Ring = nil
            elseif v3 >= 66 and v3 <= 71 then
                v7 = v2[2][2]
                v13 = v7.ShowRange
                v8 = not v13
                v3 = v8 and 65 or 199
            elseif v3 >= 72 and v3 <= 139 then
                v13 = v2[3][2]
                v8 = v13.Ring
                v3 = v8 and 22 or 242
            elseif v3 >= 140 and v3 <= 177 then
                v9 = v1._.math
                v4 = v1._.Vector3
                v10 = v7 * v9.pi * 2 / 48
                v9, v14, v18 = v10, v9.cos, v4.new
                v14 = v14(v9)
                v16, v14, v4 = v1._.math, 0, v14 * 18
                v16, v9 = v10, v16.sin
                v18 = v18(v4, 0, v9(v16) * 18)
                v4 = v1._.Instance.new("Part")
                v9 = v1._.Vector3
                v16, v19, v9, v5, v14 = 0.06, v1._.math, 0.12, 2, v9.new
                v4.Size = v14(0.12, 0.06, 2 * v19.pi * 18 / 48 + 0.03)
                v9 = v1._.CFrame
                v9, v12, v14 = v18, v1._.Vector3, v9.lookAt
                v16 = v12.new
                v6, v3, v11 = v19.sin, 418 - v3, v10
                v12, v5, v6 = -v6(v11), v19, 0
                v11, v5 = v5.cos, v10
                v11 = table.pack(v11(v5))
                v4.CFrame = v14(v9, v18 + v16(v12, 0, table.unpack(v11, 1, v11.n)))
                v4.Anchored, v12, v16 = true, false, false
                v4.CanCollide = false
                v4.CanTouch = false
                v4.CanQuery = false
                v4.CastShadow = false
                v4.Material = v1._.Enum.Material.Neon
                v4.Color, v9 = v1._.Color3.fromRGB(70, 210, 255), 0.25
                v4.Transparency = 0.25
                v4.Parent = v13
            else
                v17 = v2[3][2]
                v7 = v17.Ring
                v13 = not v7
                v3 = v13 and 63750 / v3 or 39
            end
        until false
    end
end
local function _w301(v1, v2)
    return function()
        local v3 = v2[1][2].LobbyId
        local v4 = v1._.game.PlaceId ~= v3
        local v5, v6
        if v4 then
            if not v4 then
                v2[1][2].Next.ModifierCatalog = v1._.os.clock() + 5
                v4 = {[1] = 2, [2] = v2[1][2].ModifierOptions()}
                v4[3] = v4
                v3 = v4[2]
                v5 = v1._.table.concat(v3, "|")
                if v2[1][2].ModifierCatalogSignature ~= v5 then
                    if v2[1][2].Widgets.Modifiers then
                        v2[1][2].ModifierCatalogSignature = v5
                        v6 = v1:Fc({v4, v2[1]})
                        v1._.pcall(v6)
                    end
                end
                return
            end
        else
            v5 = v1._.os.clock()
            v3 = v2[1][2].Next.ModifierCatalog
            if v3 then
                if v5 >= v3 then
                    v2[1][2].Next.ModifierCatalog = v1._.os.clock() + 5
                    v4 = {[1] = 2, [2] = v2[1][2].ModifierOptions()}
                    v4[3] = v4
                    v3 = v4[2]
                    v5 = v1._.table.concat(v3, "|")
                    if v2[1][2].ModifierCatalogSignature ~= v5 then
                        if v2[1][2].Widgets.Modifiers then
                            v2[1][2].ModifierCatalogSignature = v5
                            v6 = v1:Fc({v4, v2[1]})
                            v1._.pcall(v6)
                        end
                    end
                    return
                end
            elseif v5 < 0 then
                return
            else
                v2[1][2].Next.ModifierCatalog = v1._.os.clock() + 5
                v4 = {[1] = 2, [2] = v2[1][2].ModifierOptions()}
                v4[3] = v4
                v3 = v4[2]
                v5 = v1._.table.concat(v3, "|")
                if v2[1][2].ModifierCatalogSignature ~= v5 then
                    if v2[1][2].Widgets.Modifiers then
                        v2[1][2].ModifierCatalogSignature = v5
                        v6 = v1:Fc({v4, v2[1]})
                        v1._.pcall(v6)
                    end
                end
                return
            end
        end
    end
end
local function _w302(v1)
    local v2 = string
    local v3, v4
    v4, v3, v2 = v2.char, v2.byte, bit32
    local bxor2 = v2.bxor
    v4 = {[1] = 2, [2] = v4}
    v4[3] = v4
    v3 = {[1] = 2, [2] = v3}
    v3[3] = v3
    bxor2 = {[1] = 2, [2] = bxor2}
    bxor2[3] = bxor2
    return v1:pe({v3, v4, bxor2})
end
local function _w303(v1, v2, v3, v4, v5)
    v1.Re[v5] = bit32.bnot(bit32.band(bit32.bnot(bit32.bor(v2, v3)), bit32.bnot(v4))) + (-bit32.bnot(v3) + (bit32.band(bit32.bnot(bit32.band(65535, v3)), bit32.band(v2, 65535)) * bit32.band(bit32.band(v3, 65535), bit32.bnot(bit32.band(v2, 65535))) + bit32.bor(bit32.band(v2, 65535), bit32.band(v3, 65535)) * bit32.band(bit32.band(65535, v2), bit32.band(v3, 65535)) - bit32.band(65535, v2) * bit32.band(v3, 65535) + bit32.bnot(bit32.band(v4, v4))) + -v3) + v4
    return v1.Re[v5]
end
local function _w304(v1, v2)
    return function(v3)
        if v2[2][2].Running then
            if v2[1][2].HideName then
                v2[2][2].WatchOwnNameLabel(v3)
            end
        end
    end
end
local function _w305(v1, v2)
    return function()
        local jSONEncode = v2[2][2]:JSONEncode(v2[3][2])
        local v3 = v2[1][2] .. ".pending"
        v1._.writefile(v3, jSONEncode)
        local v4 = v1._.assert
        local v5 = v2[1][2] .. ".pending"
        v4(v1._.readfile(v5) == jSONEncode, "Pending verification failed")
        local v6 = v1._.type
        v5 = v2[2][2]
        local v7
        v5, v7 = v5.JSONDecode, v5
        v5 = table.pack(v5(v7, jSONEncode))
        v6, v3 = "JSON verification failed", v6(table.unpack(v5, 1, v5.n)) == "table"
        v4(v3, "JSON verification failed")
        if v1._.isfile(v2[1][2]) then
            v6 = v2[1][2]
            v4 = v1._.writefile
            v6, v3, v5 = v1._.readfile, v6 .. ".bak", v2[1][2]
            v6 = table.pack(v6(v5))
            v4(v3, table.unpack(v6, 1, v6.n))
        end
        v3 = v2[1][2]
        v1._.writefile(v3, jSONEncode)
        v4 = v1._.assert
        v3, v6 = v1._.readfile(v3) == jSONEncode, "Final verification failed; backup preserved"
        v4(v3, "Final verification failed; backup preserved")
        if v1._.type(v1._.delfile) == "function" then
            v3 = v2[1][2] .. ".pending"
            v1._.delfile(v3)
        end
        while true do
        end
    end
end
local function _w306(v1, v2, v3, v4)
    v1.Le[v4] = v1.me(v2, v3)
    return v1.Le[v4]
end
local function _w307(v1, v2)
    return function()
        local v3 = v2[2][2].Playing
        local v4, v5, v6, v7, v8, v9
        if v3 then
            if v3 then
                v2[2][2].Notify("Stop the active macro first")
                return
            else
                v4 = v2[3][2]
                v3 = v2[2][2].SafeName(v4)
                v4 = v3 == ""
                if v4 then
                    if v4 then
                        v2[2][2].Notify("Enter a valid macro name first")
                    elseif v2[2][2].FS then
                        v4 = v1._.isfile
                        v8 = v2[2][2].File
                        v8 = table.pack(v8(v3))
                        v4 = v4(table.unpack(v8, 1, v8.n))
                        if v4 then
                            v2[2][2].Notify("That macro already exists")
                        else
                            v5 = v2[2][2]
                            v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                            v8 = v5.Write
                            v9, v5 = v3, v5.File
                            v8, v5 = v8(v5(v9), v4)
                            if not v8 then
                                v7 = v1._.tostring
                                v2[2][2].Notify("Create failed: " .. v7(v5))
                            else
                                v2[1][2].Profile = v3
                                v9 = v2[2][2]
                                v9.LoadedProfile = v4
                                v6 = v9
                                v9.RefreshProfiles()
                                v6.SaveSettings()
                                v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                                v9("Macro", v3 .. " is ready to record")
                            end
                        end
                    else
                        v5 = v2[2][2]
                        v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                        v8 = v5.Write
                        v9, v5 = v3, v5.File
                        v8, v5 = v8(v5(v9), v4)
                        if not v8 then
                            v7 = v1._.tostring
                            v2[2][2].Notify("Create failed: " .. v7(v5))
                        else
                            v2[1][2].Profile = v3
                            v9 = v2[2][2]
                            v9.LoadedProfile = v4
                            v6 = v9
                            v9.RefreshProfiles()
                            v6.SaveSettings()
                            v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                            v9("Macro", v3 .. " is ready to record")
                        end
                    end
                    return
                elseif v3:lower() == "settings" then
                    v2[2][2].Notify("Enter a valid macro name first")
                    return
                else
                    if v2[2][2].FS then
                        v4 = v1._.isfile
                        v8 = v2[2][2].File
                        v8 = table.pack(v8(v3))
                        v4 = v4(table.unpack(v8, 1, v8.n))
                        if v4 then
                            v2[2][2].Notify("That macro already exists")
                        else
                            v5 = v2[2][2]
                            v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                            v8 = v5.Write
                            v9, v5 = v3, v5.File
                            v8, v5 = v8(v5(v9), v4)
                            if not v8 then
                                v7 = v1._.tostring
                                v2[2][2].Notify("Create failed: " .. v7(v5))
                            else
                                v2[1][2].Profile = v3
                                v9 = v2[2][2]
                                v9.LoadedProfile = v4
                                v6 = v9
                                v9.RefreshProfiles()
                                v6.SaveSettings()
                                v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                                v9("Macro", v3 .. " is ready to record")
                            end
                        end
                    else
                        v5 = v2[2][2]
                        v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                        v8 = v5.Write
                        v9, v5 = v3, v5.File
                        v8, v5 = v8(v5(v9), v4)
                        if not v8 then
                            v7 = v1._.tostring
                            v2[2][2].Notify("Create failed: " .. v7(v5))
                        else
                            v2[1][2].Profile = v3
                            v9 = v2[2][2]
                            v9.LoadedProfile = v4
                            v6 = v9
                            v9.RefreshProfiles()
                            v6.SaveSettings()
                            v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                            v9("Macro", v3 .. " is ready to record")
                        end
                    end
                    return
                end
            end
        elseif v2[2][2].Recording then
            v2[2][2].Notify("Stop the active macro first")
            return
        else
            v4 = v2[3][2]
            v3 = v2[2][2].SafeName(v4)
            v4 = v3 == ""
            if v4 then
                if v4 then
                    v2[2][2].Notify("Enter a valid macro name first")
                elseif v2[2][2].FS then
                    v4 = v1._.isfile
                    v8 = v2[2][2].File
                    v8 = table.pack(v8(v3))
                    v4 = v4(table.unpack(v8, 1, v8.n))
                    if v4 then
                        v2[2][2].Notify("That macro already exists")
                    else
                        v5 = v2[2][2]
                        v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                        v8 = v5.Write
                        v9, v5 = v3, v5.File
                        v8, v5 = v8(v5(v9), v4)
                        if not v8 then
                            v7 = v1._.tostring
                            v2[2][2].Notify("Create failed: " .. v7(v5))
                        else
                            v2[1][2].Profile = v3
                            v9 = v2[2][2]
                            v9.LoadedProfile = v4
                            v6 = v9
                            v9.RefreshProfiles()
                            v6.SaveSettings()
                            v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                            v9("Macro", v3 .. " is ready to record")
                        end
                    end
                else
                    v5 = v2[2][2]
                    v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                    v8 = v5.Write
                    v9, v5 = v3, v5.File
                    v8, v5 = v8(v5(v9), v4)
                    if not v8 then
                        v7 = v1._.tostring
                        v2[2][2].Notify("Create failed: " .. v7(v5))
                    else
                        v2[1][2].Profile = v3
                        v9 = v2[2][2]
                        v9.LoadedProfile = v4
                        v6 = v9
                        v9.RefreshProfiles()
                        v6.SaveSettings()
                        v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                        v9("Macro", v3 .. " is ready to record")
                    end
                end
                return
            elseif v3:lower() == "settings" then
                v2[2][2].Notify("Enter a valid macro name first")
                return
            else
                if v2[2][2].FS then
                    v4 = v1._.isfile
                    v8 = v2[2][2].File
                    v8 = table.pack(v8(v3))
                    v4 = v4(table.unpack(v8, 1, v8.n))
                    if v4 then
                        v2[2][2].Notify("That macro already exists")
                    else
                        v5 = v2[2][2]
                        v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                        v8 = v5.Write
                        v9, v5 = v3, v5.File
                        v8, v5 = v8(v5(v9), v4)
                        if not v8 then
                            v7 = v1._.tostring
                            v2[2][2].Notify("Create failed: " .. v7(v5))
                        else
                            v2[1][2].Profile = v3
                            v9 = v2[2][2]
                            v9.LoadedProfile = v4
                            v6 = v9
                            v9.RefreshProfiles()
                            v6.SaveSettings()
                            v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                            v9("Macro", v3 .. " is ready to record")
                        end
                    end
                else
                    v5 = v2[2][2]
                    v4 = {Game = "CameraTD", Version = 1, Actions = {}, ActionCount = 0}
                    v8 = v5.Write
                    v9, v5 = v3, v5.File
                    v8, v5 = v8(v5(v9), v4)
                    if not v8 then
                        v7 = v1._.tostring
                        v2[2][2].Notify("Create failed: " .. v7(v5))
                    else
                        v2[1][2].Profile = v3
                        v9 = v2[2][2]
                        v9.LoadedProfile = v4
                        v6 = v9
                        v9.RefreshProfiles()
                        v6.SaveSettings()
                        v6, v7, v9 = "Macro", " is ready to record", v6.SetStatus
                        v9("Macro", v3 .. " is ready to record")
                    end
                end
                return
            end
        end
    end
end
local function _w308(v1, v2)
    return function(v3)
        v2[2][2].ClosePlacement = v3 == true
        local v4 = v2[1][2]
        local v5
        v4, v5 = v2[2][2], v4.SetClosePlacement
        v5(v4.ClosePlacement)
        v2[1][2].SaveSettings()
    end
end
local function _w309(v1, v2)
    return function()
        v1._.game:GetService("TeleportService"):Teleport(v2[2][2].LobbyId, v2[1][2])
    end
end
local function _w310(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5 = v1._.math.clamp
        local v6 = v1._.tonumber
        local v7 = v1._.tostring(v3)
        local v8, v9
        v8, v9, v7 = "%d+", v7, v7.match
        v7 = table.pack(v7(v9, "%d+"))
        v6 = v6(table.unpack(v7, 1, v7.n))
        if v6 then
            v4.Players = v5(v6, 1, 5)
        else
            v4.Players = v5(1, 1, 5)
        end
        v2[1][2].SaveSettings()
    end
end
local function _w311(v1, v2)
    return function()
        local v3 = v2[4][2].Towers[v2[1][2]]
        v2[2][2] = v3
        v3 = v2[2][2]
        local v4, v5
        if v3 then
            v4 = v2[2][2].Level
            v5 = v1._.tonumber(v4)
            if v5 then
                return v5 > v2[3][2]
            else
                return 1 > v2[3][2]
            end
        else
            return v3
        end
    end
end
local function _w312(v1, v2)
    return function(v3)
        local v4 = v2[2][2]
        local v5, v6
        v4, v6, v5 = v2[1][2], "ModuleLoader/Configs/Config", v4.Path
        v5 = v5(v4, "ModuleLoader/Configs/Config")
        local v7, v8
        if not v5 then
            return nil
        elseif v5:IsA("ModuleScript") then
            if not v2[2][2].Config then
                v6 = v1._.require
                v4, v6 = v1._.pcall(v6, v5)
                if v4 then
                    v2[2][2].Config = v6
                end
            end
            v4 = v2[2][2].Config
            if v1._.type(v4) == "table" then
                if v1._.type(v4.Towers) == "table" then
                    return v4.Towers[v3]
                else
                    v4 = v2[2][2].Path(v5, "Towers/" .. v3)
                    if v4 then
                        if v4:IsA("ModuleScript") then
                            v6 = v4 or v4:FindFirstChild("Config")
                        else
                            v6 = v4:FindFirstChild("Config")
                        end
                        v8 = v6
                        if v6 then
                            if v6:IsA("ModuleScript") then
                                v8 = v2[2][2]
                                v7 = v8.ConfigUnits
                                if v7 then
                                    v8.ConfigUnits = v7
                                else
                                    v8.ConfigUnits = {}
                                end
                                if not v2[2][2].ConfigUnits[v3] then
                                    v7 = v1._.require
                                    v8, v7 = v1._.pcall(v7, v6)
                                    if v8 then
                                        v2[2][2].ConfigUnits[v3] = v7
                                    end
                                end
                                return v2[2][2].ConfigUnits[v3]
                            else
                                return
                            end
                        elseif v8 then
                            v8 = v2[2][2]
                            v7 = v8.ConfigUnits
                            if v7 then
                                v8.ConfigUnits = v7
                            else
                                v8.ConfigUnits = {}
                            end
                            if not v2[2][2].ConfigUnits[v3] then
                                v7 = v1._.require
                                v8, v7 = v1._.pcall(v7, v6)
                                if v8 then
                                    v2[2][2].ConfigUnits[v3] = v7
                                end
                            end
                            return v2[2][2].ConfigUnits[v3]
                        else
                            return
                        end
                    else
                        return
                    end
                end
            else
                v4 = v2[2][2].Path(v5, "Towers/" .. v3)
                if v4 then
                    if v4:IsA("ModuleScript") then
                        v6 = v4 or v4:FindFirstChild("Config")
                    else
                        v6 = v4:FindFirstChild("Config")
                    end
                    v8 = v6
                    if v6 then
                        if v6:IsA("ModuleScript") then
                            v8 = v2[2][2]
                            v7 = v8.ConfigUnits
                            if v7 then
                                v8.ConfigUnits = v7
                            else
                                v8.ConfigUnits = {}
                            end
                            if not v2[2][2].ConfigUnits[v3] then
                                v7 = v1._.require
                                v8, v7 = v1._.pcall(v7, v6)
                                if v8 then
                                    v2[2][2].ConfigUnits[v3] = v7
                                end
                            end
                            return v2[2][2].ConfigUnits[v3]
                        else
                            return
                        end
                    elseif v8 then
                        v8 = v2[2][2]
                        v7 = v8.ConfigUnits
                        if v7 then
                            v8.ConfigUnits = v7
                        else
                            v8.ConfigUnits = {}
                        end
                        if not v2[2][2].ConfigUnits[v3] then
                            v7 = v1._.require
                            v8, v7 = v1._.pcall(v7, v6)
                            if v8 then
                                v2[2][2].ConfigUnits[v3] = v7
                            end
                        end
                        return v2[2][2].ConfigUnits[v3]
                    else
                        return
                    end
                else
                    return
                end
            end
        else
            v4 = v2[2][2].Path(v5, "Towers/" .. v3)
            if v4 then
                if v4:IsA("ModuleScript") then
                    v6 = v4 or v4:FindFirstChild("Config")
                else
                    v6 = v4:FindFirstChild("Config")
                end
                v8 = v6
                if v6 then
                    if v6:IsA("ModuleScript") then
                        v8 = v2[2][2]
                        v7 = v8.ConfigUnits
                        if v7 then
                            v8.ConfigUnits = v7
                        else
                            v8.ConfigUnits = {}
                        end
                        if not v2[2][2].ConfigUnits[v3] then
                            v7 = v1._.require
                            v8, v7 = v1._.pcall(v7, v6)
                            if v8 then
                                v2[2][2].ConfigUnits[v3] = v7
                            end
                        end
                        return v2[2][2].ConfigUnits[v3]
                    else
                        return
                    end
                elseif v8 then
                    v8 = v2[2][2]
                    v7 = v8.ConfigUnits
                    if v7 then
                        v8.ConfigUnits = v7
                    else
                        v8.ConfigUnits = {}
                    end
                    if not v2[2][2].ConfigUnits[v3] then
                        v7 = v1._.require
                        v8, v7 = v1._.pcall(v7, v6)
                        if v8 then
                            v2[2][2].ConfigUnits[v3] = v7
                        end
                    end
                    return v2[2][2].ConfigUnits[v3]
                else
                    return
                end
            else
                return
            end
        end
    end
end
local function _w313(v1, v2)
    return function(v3)
        local v4 = not v3
        local v5 = v2[1][2].Recording
        if not v4 then
            v4 = not v2[1][2].Running
        end
        if not v4 then
            v4 = not v5
        end
        if not v4 then
            v4 = v5 ~= v3.Record
        end
        local v6, v7, v8
        if v4 then
            if not v4 then
                v2[1][2].SkipSubmittedWave = v3.Wave
                v4 = v5.SkipWaves
                if v4 then
                    v5.SkipWaves = v4
                else
                    v5.SkipWaves = {}
                end
                if not v5.SkipWaves[v3.Wave] then
                    v5.SkipWaves[v3.Wave] = true
                    v4 = v1._.table.insert
                    v7 = {}
                    v6 = v5.Profile.Actions
                    v7.Kind = "Skip"
                    v7.Wave = v3.Wave
                    v7.Time = v3.Time
                    v7.WaveTime = v3.WaveTime
                    v7.Cost = 0
                    v4(v6, v7)
                    v8 = v5.Profile
                    v2[1][2].SetStatus("Macro", "Recording: " .. #v8.Actions .. " actions | manual Skip W" .. v3.Wave)
                end
                return
            end
        elseif v3.Wave < 1 then
            return
        else
            v2[1][2].SkipSubmittedWave = v3.Wave
            v4 = v5.SkipWaves
            if v4 then
                v5.SkipWaves = v4
            else
                v5.SkipWaves = {}
            end
            if not v5.SkipWaves[v3.Wave] then
                v5.SkipWaves[v3.Wave] = true
                v4 = v1._.table.insert
                v7 = {}
                v6 = v5.Profile.Actions
                v7.Kind = "Skip"
                v7.Wave = v3.Wave
                v7.Time = v3.Time
                v7.WaveTime = v3.WaveTime
                v7.Cost = 0
                v4(v6, v7)
                v8 = v5.Profile
                v2[1][2].SetStatus("Macro", "Recording: " .. #v8.Actions .. " actions | manual Skip W" .. v3.Wave)
            end
            return
        end
    end
end
local function _w314(v1, v2)
    return function(v3, v4)
        v4 = {[1] = 2, [2] = v4}
        v4[3] = v4
        local connect = v3:Connect(v1:Qc({v4, v2[1]}))
        local v5 = v2[1][2].Connections
        v1._.table.insert(v5, connect)
        return connect
    end
end
local function _w315(v1, v2)
    return function()
        local v3 = 141
        local v4, v5, v6, v7, v8, v9, v10
        repeat
            if v3 == 15 then
                v3 = v5 and 120 or 39 - v3
            elseif v3 == 179 then
                v3 = v4 and 72 or 235
            elseif v3 == 235 then
                v3 = v4 and 14 or v3 + -141
            elseif v3 >= 25 and v3 <= 26 then
                v3, v9, v8, v7 = 258 - v3, {}, v2[2][2], {}
                v7.Position = v8
                v9[1] = v7
                v4 = v9
            elseif v3 >= 27 and v3 <= 30 then
                v4 = v1._.game.PlaceId
                v3, v9 = v3 + -15, v2[6][2].LobbyId
                v5 = v4 ~= v9
            elseif v3 >= 22 and v3 <= 24 then
                v9 = v2[1][2]
                v3, v9, v4 = 120, v2[4][2], v9.Character
                v5 = v4 ~= v9
            elseif v3 <= 14 then
                v3, v4 = v3 + 80, v10
            elseif v3 >= 16 and v3 <= 21 then
                v5 = v2[3][2]
                v4 = v6
                v3 = v6 and 4914 / v3 or v3 + 158
            elseif v3 >= 77 and v3 <= 84 then
                return
            elseif v3 >= 73 and v3 <= 76 then
                v4 = v2[6][2].Running
                v3 = 230
                v5 = not v4
            elseif v3 >= 31 and v3 <= 72 then
                v3 = 235
                v4 = #v10 > 0
            elseif v3 >= 95 and v3 <= 112 then
                v3 = v5 and 15 or 30
            elseif v3 >= 85 and v3 <= 94 then
                v3 = v4 and 232 or 26
            elseif v3 >= 190 and v3 <= 194 then
                v4 = v2[5][2].AutoLobby
                v3, v5 = 431 - v3, not v4
            elseif v3 >= 195 and v3 <= 230 then
                v3 = v5 and 237 or 194
            elseif v3 >= 113 and v3 <= 120 then
                v3 = v5 and 84 or 21
            elseif v3 >= 121 and v3 <= 178 then
                v6, v10 = v1._.pcall(v1:Bc({v2[2], v2[7]}))
                v5 = v2[6][2]
                v5.JoinPathBusy = false
                v4 = v5.JoinWalk
                v5 = v4 ~= v2[3][2]
                v3 = v5 and 230 or 76
            elseif v3 >= 180 and v3 <= 189 then
                v3 = 112
                v4 = v2[5][2].JoinMethod
                v5 = v4 ~= "Walk"
            elseif v3 >= 233 and v3 <= 234 then
                v3 = 179
                v4 = v1._.type(v10) == "table"
            elseif v3 >= 231 and v3 <= 232 then
                v5.Points = v4
                v5 = v2[3][2]
                v4 = v5
                v8 = v1._.os.clock()
                v5.Index = 1
                v4.LastMoveIndex = nil
                v4.ProgressAt = v8
                return
            else
                v3 = v5 and 26544 / v3 or v3 + -48
            end
        until false
    end
end
local function _w316(v1, v2)
    return function(v3)
        if v3.GameAt then
            return v2[1][2].GameClock() - v3.GameAt
        else
            return v1._.os.clock() - v3.At
        end
    end
end
local function _w317(v1, v2)
    return function()
        local v3 = v2[1][2]
        local v4 = v2[4][2].Towers[v3]
        v2[2][2] = v4
        v4 = v2[2][2]
        if v4 then
            v3 = v2[3][2]
            return v2[2][2].TargetMode ~= v3
        else
            return v4
        end
    end
end
local function _w318(v1, v2)
    return function()
        local v3 = 99
        local v4, v5, v6, v7, v8, v9
        while true do
            if v3 < 130 then
                if v3 >= 64 then
                    if v3 >= 99 then
                        if v3 < 108 then
                            if v3 > 99 then
                                v3 = v6 and 210 or 2438 / v3
                            else
                                v9 = v2[2][2]
                                v6 = v9.AutoLobby
                                v4 = not v6
                                v3 = v4 and 174 or 133
                            end
                        elseif v3 >= 109 then
                            if v3 > 109 then
                                v9(v7, v8)
                            else
                                v2[4][2].SoloReturning = nil
                            end
                            return
                        else
                            v3 = v4 and 350 - v3 or 23544 / v3
                        end
                    elseif v3 > 93 then
                        v9 = v2[4][2]
                        v6 = v9.SoloWebhookPending
                        v3 = v6 and 271 - v3 or 106
                    elseif v3 > 81 then
                        return
                    elseif v3 <= 64 then
                        v6 = v2[4][2]
                        v6.SoloReturning = true
                        v7 = v1._.os
                        v6.SoloReturnStartedAt = v7.clock()
                        v9 = v6
                        v6 = v6.Playing
                        v3 = v6 and 131 or 246
                    else
                        v3 = v4 and 130 or 203
                    end
                elseif v3 >= 39 then
                    if v3 < 48 then
                        if v3 <= 39 then
                            v3 = v8 and 112 or 145
                        else
                            v9 = v2[4][2]
                            v6 = v9.StopRecord
                            v3 = v3 + 113
                            v6()
                        end
                    elseif v3 > 48 then
                        v7 = v2[4][2]
                        v9 = v7.SoloReturning
                        v6 = not v9
                        v3 = v6 and v3 + 5 or 154 - v3
                    else
                        v9 = v2[1][2]
                        v6 = v9.GetPlayers
                        v3, v4 = 5184 / v3, not v6
                    end
                elseif v3 > 23 then
                    v2[4][2].Next.SoloReturn = v1._.os.clock() + 15
                    v2[4][2].QueueTeleport()
                    v6 = v1._.pcall(v1:Ob({v2[3], v2[4]}))
                    v8 = v6
                    v9 = v2[4][2].SetStatus
                    v7 = "Match"
                    v3 = v8 and 5082 / v3 or 39
                elseif v3 < 14 then
                    v3 = 147
                    v7 = v2[4][2]
                    v9 = v7.SoloReturning
                    v6 = not v9
                elseif v3 > 14 then
                    v6 = v1._.os.clock()
                    v8 = v2[4][2]
                    v7 = v8.Next
                    v9 = v7.SoloReturn
                    v3 = v9 and 140 or 180
                else
                    v7 = v2[4][2]
                    v6 = v1._.game.PlaceId
                    v9 = v7.MatchId
                    v4 = v6 ~= v9
                    v3 = v4 and v3 + 67 or 170 - v3
                end
            elseif v3 <= 174 then
                if v3 > 147 then
                    if v3 < 159 then
                        if v3 > 154 then
                            v3 = 81
                            v9 = v2[2][2]
                            v6 = v9.AutoLobby
                            v4 = not v6
                        else
                            v3 = 39
                            v8 = "Solo guard: returning to lobby"
                        end
                    elseif v3 <= 159 then
                        v3, v5, v6, v8, v9 = 254 - v3, " players; returning to lobby", v2[4][2].Notify, #v4, "Players = 1 but this match has "
                        v6("Players = 1 but this match has " .. v8 .. " players; returning to lobby")
                        v6 = {[1] = 2, [2] = #v4}
                        v6[3] = v6
                        v2[4][2].SoloWebhookPending = true
                        v7 = v1._.task
                        v7, v9 = v1:Pb({v6, v2[4], v2[3]}), v7.spawn
                        v9(v7)
                    else
                        v3 = v4 and 109 or v3 + -160
                    end
                elseif v3 <= 140 then
                    if v3 <= 133 then
                        if v3 <= 131 then
                            if v3 <= 130 then
                                v3 = v4 and 238 - v3 or 48
                            else
                                v3 = 246
                                v6 = v2[4][2].StopPlayback
                                v9 = "Solo queue violation; returning to lobby"
                                v6("Solo queue violation; returning to lobby")
                            end
                        else
                            v3, v9, v6 = 307 - v3, 1, v2[2][2].Players
                            v4 = v6 ~= 1
                        end
                    else
                        v3 = v6 < v9 and 238 or v3 + -107
                    end
                elseif v3 > 145 then
                    v3 = v6 and 93 or v3 + -88
                else
                    v3 = 112
                    v8 = "Solo guard: teleport failed; retrying in 15s"
                end
            elseif v3 <= 218 then
                if v3 > 203 then
                    if v3 > 210 then
                        v4 = v2[1][2]:GetPlayers()
                        v7 = 1
                        v9 = #v4
                        v6 = v9 <= 1
                        v3 = v6 and 13 or 147
                    end
                elseif v3 < 180 then
                    v7 = v1._.os.clock()
                    v3, v8 = v3 + -70, v2[4][2].SoloReturnStartedAt
                    v7, v9 = 8, v7 - v8
                    v6 = v9 < 8
                elseif v3 <= 180 then
                    v3 = 140
                    v9 = 0
                else
                    v3, v9 = v3 + -73, v2[2][2]
                    v9, v6 = 1, v9.Players
                    v4 = v6 ~= 1
                end
            elseif v3 <= 242 then
                return
            else
                v9 = v2[4][2]
                v6 = v9.Recording
                v3 = v6 and v3 + -200 or 159
            end
        end
    end
end
local function _w319(v1, v2)
    return function(v3, v4)
        v4 = {[1] = 2, [2] = v4}
        v4[3] = v4
        local v5 = v1._.table.insert
        local v6 = v2[1][2]
        local v7, v8, v9
        v6, v9, v8, v7 = v3.Connect, v6.Connections, v1:xc({v4, v2[1]}), v3
        v6 = table.pack(v6(v7, v8))
        v5(v9, table.unpack(v6, 1, v6.n))
    end
end
local function _w320(v1, v2)
    return function(v3)
        local v4 = v2[1][2]
        v4.Serial = v4.Serial + 1
        v4.Playing = false
        local v5, v6
        v5, v6, v4 = "Macro", v3, v4.SetStatus
        if v6 then
            v4("Macro", v6)
        else
            v4("Macro", "Playback stopped")
        end
    end
end
local function _w321(v1, v2)
    return function(v3, v4)
        local v5 = 112
        local v6, v7, v8, v9, v10, v11, v12, v13
        repeat
            if v5 == 28 then
                v5 = v12 and 173 - v5 or 208 - v5
            elseif v5 == 37 then
                v12 = v1._.table.remove
                v7 = 1
                v5 = 38
                v12(v6, 1)
            elseif v5 == 70 then
                v10.Wave = v6
                v10.Payload = v11
                v12 = v2[1][2]
                v13 = v10
                v12, v6 = v4.Id, v12.Towers
                v10, v6 = v6[v12], "TowerUpgrade"
                v5 = v3 == "TowerUpgrade" and 255 or 138 - v5
            elseif v5 == 140 then
                v12 = v6
                v5 = v6 and 331 - v5 or 34860 / v5
            elseif v5 == 141 then
                v5, v13.Cost = 9588 / v5, v12
            elseif v5 == 163 then
                v5, v12 = 4564 / v5, v6[1]
            elseif v5 == 171 then
                v5, v12 = 312 - v5, 0
            elseif v5 == 180 then
                v5 = 145
                v12 = 0
            elseif v5 == 188 then
                v5, v7 = 262 - v5, 1
            elseif v5 == 249 then
                v5 = v12 and 390 - v5 or 171
            elseif v5 >= 133 and v5 <= 139 then
                v5, v13 = v5 + 46, "table"
                v11 = v1._.type(v4) ~= "table"
            elseif v5 >= 113 and v5 <= 128 then
                v13 = v1._.os
                v11 = {
                    Id = v4.Id,
                    Name = v4.Name,
                    UnitId = v4.UnitId,
                    Pos = v4.Pos,
                    CFrame = v4.CFrame,
                }
                v10 = {}
                v10.At = v13.clock()
                v12 = v2[1][2]
                v12, v6 = v12.Recording, v12.RecordTime
                v10.Time = v6(v12)
                v12 = v2[1][2]
                v6 = v12.LastWave
                v5 = v6 and 70 or 35
            elseif v5 >= 129 and v5 <= 132 then
                v5, v12, v8 = 272 - v5, v2[1][2].KnownCosts, v10.Name
                v6 = v12[v8]
            elseif v5 >= 75 and v5 <= 112 then
                v13 = v2[1][2]
                v11 = not v13.Recording
                v5 = v11 and 184 or 138
            elseif v5 >= 71 and v5 <= 74 then
                v5, v9 = v5 + 175, 1
                v12 = v6[v7 + 1]
            elseif v5 >= 68 and v5 <= 69 then
                v6 = "TowerAdd"
                v5 = v3 == "TowerAdd" and 295 - v5 or 100 - v5
            elseif v5 >= 29 and v5 <= 34 then
                v12 = v2[1][2]
                v7 = v12
                v6 = v12.Pending
                v12 = v12.Pending[v3]
                v5 = v12 and 5440 / v5 or 59 - v5
            elseif v5 <= 27 then
                v5 = 170
                v12 = {}
            elseif v5 >= 35 and v5 <= 36 then
                v5, v6 = 2450 / v5, 0
            elseif v5 >= 38 and v5 <= 67 then
                v1._.table.insert(v6, v13)
                return
            elseif v5 >= 192 and v5 <= 248 then
                v8 = v4.Name
                v6 = v2[1][2].KnownCosts[v8]
                v12 = v6
                v5 = v6 and 390 - v5 or 255 - v5
            elseif v5 >= 189 and v5 <= 191 then
                v9 = v10.Level
                v7 = v1._.tonumber(v9)
                v5 = v7 and 265 - v5 or 188
            elseif v5 >= 181 and v5 <= 187 then
                v5 = v11 and v5 + -10 or 23552 / v5
            elseif v5 >= 142 and v5 <= 162 then
                v5, v13.Cost = 32, v12
            elseif v5 >= 172 and v5 <= 179 then
                return
            elseif v5 >= 164 and v5 <= 170 then
                v6[v3] = v12
                v6 = v2[1][2].Pending[v3]
                v12 = #v6
                v5 = v12 >= 64 and 207 - v5 or 38
            else
                v6 = v10
                v5 = v10 and 132 or 140
            end
        until false
    end
end
local function _w322(v1)
    return function(v2, v3)
        local v4 = 144
        local v5, v6, v7, v8, v9, v10
        repeat
            if v4 == 71 then
                v4, v7 = 5609 / v4, v9:FindFirstChild(v5)
            elseif v4 == 149 then
                v5 = v8(v6, v10)
                v10 = v5
                v4 = v5 == nil and v4 + -99 or 227
            elseif v4 >= 72 and v4 <= 143 then
                v4, v9 = v4 + 70, v7
            elseif v4 <= 70 then
                return v9
            elseif v4 >= 144 and v4 <= 148 then
                v9 = v2
                v8, v6, v10 = v3:gmatch("[^/]+")
                v8, v6, v10 = v1.g(v8, v6, v10)
                v5 = v8(v6, v10)
                v10 = v5
                v4 = v5 == nil and 50 or 227
            else
                v7 = v9
                v4 = v9 and 298 - v4 or 17933 / v4
            end
        until false
    end
end
local function _w323(v1, v2)
    return function()
        local v3 = {}
        local v4, v5, v6
        v5, v4, v6 = v1._.pairs(v2[1][2].Towers)
        v5, v4, v6 = v1.g(v5, v4, v6)
        local v7, v8
        v7, v8 = v5(v4, v6)
        v6 = v7
        if v7 == nil then
            v4 = v1._.table
            v6, v5, v4 = v1:td(), v4.sort, v3
            v5(v4, v6)
            return v3
        else
            while true do
                if not v2[1][2].Own(v8) then
                    v7, v8 = v5(v4, v6)
                    v6 = v7
                    if v7 == nil then
                        v4 = v1._.table
                        v6, v5, v4 = v1:td(), v4.sort, v3
                        v5(v4, v6)
                        return v3
                    else
                        continue
                    end
                end
                v1._.table.insert(v3, v8)
            end
        end
    end
end
local function _w324(v1, v2)
    return function()
        local v3 = {[1] = 2, [2] = "starting"}
        v3[3] = v3
        local v4 = {[1] = 2, [2] = "macro"}
        v4[3] = v4
        local v5 = v1:dd({
            v2[9],
            v2[7],
            v2[6],
            v2[3],
            v2[5],
            v2[1],
            v4,
            v2[4],
            v2[2],
            v2[8],
            v3,
        })
        local v6
        v6, v5 = v1._.pcall(v5)
        local v7 = v2[4][2]
        local v8, v9, v10, v11, v12, v13
        if v2[6][2].Serial == v7 then
            v11 = v2[6][2]
            v11.Playing = false
            if not v6 then
                v11.PlaybackFailure = true
            else
                v11.PlaybackFailure = nil
            end
            v7 = v6
            v11 = v2[6][2]
            if v6 then
                v11.PlaybackCompleted = true
                if v6 then
                    v2[6][2].Auto.NextAt = 0
                    v2[6][2].PlaybackIndex = 0
                end
                v11 = v1._.tostring(v5):gsub("^.-:%d+:%s*", "")
                v7 = v2[6][2].SetStatus
                if v6 then
                    v7("Macro", "Playback complete")
                else
                    v9 = v1._.string
                    v12, v10, v13, v9, v8 = v3[2], v4[2], v2[6][2], "Stopped: %s | %s | cash %s | %s", v9.format
                    v8 = v8("Stopped: %s | %s | cash %s | %s", v10, v12, v13.Cash(), v11)
                    v7("Macro", v8)
                end
                while true do
                end
            elseif v7 then
                v11.PlaybackCompleted = v7
                if v6 then
                    v2[6][2].Auto.NextAt = 0
                    v2[6][2].PlaybackIndex = 0
                end
                v11 = v1._.tostring(v5):gsub("^.-:%d+:%s*", "")
                v7 = v2[6][2].SetStatus
                if v6 then
                    v7("Macro", "Playback complete")
                else
                    v9 = v1._.string
                    v12, v10, v13, v9, v8 = v3[2], v4[2], v2[6][2], "Stopped: %s | %s | cash %s | %s", v9.format
                    v8 = v8("Stopped: %s | %s | cash %s | %s", v10, v12, v13.Cash(), v11)
                    v7("Macro", v8)
                end
                while true do
                end
            else
                v11.PlaybackCompleted = nil
                if v6 then
                    v2[6][2].Auto.NextAt = 0
                    v2[6][2].PlaybackIndex = 0
                end
                v11 = v1._.tostring(v5):gsub("^.-:%d+:%s*", "")
                v7 = v2[6][2].SetStatus
                if v6 then
                    v7("Macro", "Playback complete")
                else
                    v9 = v1._.string
                    v12, v10, v13, v9, v8 = v3[2], v4[2], v2[6][2], "Stopped: %s | %s | cash %s | %s", v9.format
                    v8 = v8("Stopped: %s | %s | cash %s | %s", v10, v12, v13.Cash(), v11)
                    v7("Macro", v8)
                end
                while true do
                end
            end
        else
            while true do
            end
        end
    end
end
local function _w325(v1, v2, v3, v4, v5)
    v1.Re[v5] = -bit32.bxor(bit32.bor(v3, v3), bit32.bor(v4, 4294967295)) + (v2 + (bit32.bnot(bit32.band(bit32.bnot(v2), bit32.bnot(bit32.bxor(v4, v3)))) + (bit32.band(bit32.bnot(bit32.band(v2, 65535)), bit32.band(v2, 65535)) * bit32.band(bit32.band(65535, v2), bit32.bnot(bit32.band(v2, 65535))) + bit32.band(bit32.band(65535, v2), bit32.band(65535, v2)) * bit32.bor(bit32.band(v2, 65535), bit32.band(65535, v2)) - bit32.band(v2, 65535) * bit32.band(v2, 65535)) + -v3 + bit32.bnot(bit32.band(v2, v2))))
    return v1.Re[v5]
end
local function _w326(v1)
    return function(v2)
        local v3 = 255
        local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
        while true do
            if v3 == 11 then
                v3 = v7 and 189 or 94
            elseif v3 == 18 then
                v3 = v9 and 243 - v3 or 127 - v3
            elseif v3 == 46 then
                v3 = v9 and 6164 / v3 or 219
            elseif v3 == 47 then
                v3, v11, v8 = v3 + 29, 0, v14.WaveTime
                v9 = v8 < 0
            elseif v3 == 56 then
                v11 = v14.Target
                v8 = v1._.type(v11)
                v11 = "string"
                v3 = 0
                v9 = v8 ~= "string"
            elseif v3 == 64 then
                v3 = 103
                v13 = false
            elseif v3 == 72 then
                v3 = v9 and 18 or 276 - v3
            elseif v3 == 94 then
                v7 = v2.ActionCount
                v15 = v2.Actions
                v10 = #v15
                v3 = v7 ~= v10 and 22466 / v3 or 230
            elseif v3 == 95 then
                v3 = v7 and 11 or 137
            elseif v3 == 98 then
                return false
            elseif v3 == 109 then
                v8 = v14.CFrame
                v9, v8, v11 = v1._.ipairs(v8)
                v9, v8, v11 = v1.g(v9, v8, v11)
                v4, v5 = v9(v8, v11)
                v11 = v4
                v3 = v4 == nil and 266 - v3 or 14497 / v3
            elseif v3 == 116 then
                v11 = "Upgrade"
                v8 = v14.Kind
                v9 = v8 == "Upgrade"
                v3 = v9 and v3 + -5 or 46
            elseif v3 == 128 then
                v11 = v14.UnitId
                v3, v8 = 14592 / v3, v1._.type(v11)
                v11 = "string"
                v9 = v8 ~= "string"
            elseif v3 == 134 then
                return false
            elseif v3 == 144 then
                v3 = v9 and v3 + -127 or 39
            elseif v3 == 155 then
                v8, v3, v4 = v14.WaveTime, 224 - v3, v1._.math
                v11 = v4.huge
                v9 = v8 == v11
            elseif v3 == 178 or v3 == 193 then
                return false
            elseif v3 == 212 then
                v15 = 1
                v10 = v2.Version
                v3, v7 = 307 - v3, v10 ~= 1
            elseif v3 == 216 then
                v3, v10, v15 = 17928 / v3, v2.Game, "CameraTD"
                v7 = v10 ~= "CameraTD"
            elseif v3 == 220 then
                v6, v14 = v10(v15, v12)
                v12 = v6
                v3 = v6 == nil and 391 - v3 or 172
            elseif v3 == 230 then
                v7 = {}
                v15 = v2.Actions
                v10, v15, v12 = v1._.ipairs(v15)
                v10, v15, v12 = v1.g(v10, v15, v12)
                v6, v14 = v10(v15, v12)
                v12 = v6
                v3 = v6 == nil and 171 or 172
            elseif v3 == 245 or v3 >= 112 and v3 <= 113 then
                return false
            elseif v3 >= 104 and v3 <= 108 then
                v8 = v14.Kind
                v11 = "Skip"
                v9 = v8 ~= "Skip"
                v3 = v9 and 238 or 248 - v3
            elseif v3 >= 110 and v3 <= 111 then
                v11 = v14.Level
                v8 = v1._.type(v11)
                v11 = "number"
                v9 = v8 ~= "number"
                v3 = v9 and 5106 / v3 or v3 + -73
            elseif v3 >= 120 and v3 <= 124 then
                v3 = v9 and 5 or v3 + 25
            elseif v3 >= 114 and v3 <= 115 then
                v3 = v9 and 8208 / v3 or 119
            elseif v3 >= 117 and v3 <= 119 then
                v8 = v1._.type(v14.CFrame)
                v11 = "table"
                v3, v9 = 8568 / v3, v8 ~= "table"
            elseif v3 >= 96 and v3 <= 97 then
                v8 = 1
                v9 = v14.Wave
                v3 = v9 < 1 and 98 or 11136 / v3
            elseif v3 >= 99 and v3 <= 103 then
                v3 = v13 and 175 or 87
            elseif v3 >= 77 and v3 <= 83 then
                v3 = v7 and 7885 / v3 or 212
            elseif v3 >= 84 and v3 <= 93 then
                v3 = 175
                v13 = v1._.math.abs(v5) == v1._.math.huge
            elseif v3 >= 75 and v3 <= 76 then
                v3 = v9 and 69 or 155
            elseif v3 >= 73 and v3 <= 74 then
                v8 = v14.Key
                v9 = v7[v8]
                v3 = v9 and 232 or v3 + -66
            elseif v3 >= 12 and v3 <= 17 then
                v3 = v9 and v3 + 107 or 147
            elseif v3 >= 32 and v3 <= 38 then
                v11 = 2
                v8 = v14.Level
                v3, v9 = v3 + 8, v8 < 2
            elseif v3 >= 19 and v3 <= 31 then
                v11 = 0
                v3 = 2
                v8 = v14.Wave
                v9 = v8 < 0
            elseif v3 >= 6 and v3 <= 7 then
                v3 = v9 and v3 + 137 or 728 / v3
            elseif v3 >= 8 and v3 <= 10 then
                v3, v8 = 240 - v3, v1._.type(v14.Name)
                v11 = "string"
                v9 = v8 ~= "string"
            elseif v3 >= 1 and v3 <= 2 then
                v3 = v9 and 245 or 196
            elseif v3 <= 0 then
                v3 = v9 and 112 - v3 or v3 + 220
            elseif v3 >= 3 and v3 <= 5 then
                v3 = v9 and 2 or 31
            elseif v3 >= 48 and v3 <= 55 then
                v11 = v14.Key
                v8 = v7[v11]
                v9 = not v8
                v3 = v9 and 178 or 116
            elseif v3 >= 39 and v3 <= 45 then
                v11 = v14.Time
                v8 = v1._.type(v11)
                v3 = 17
                v11 = "number"
                v9 = v8 ~= "number"
            elseif v3 >= 57 and v3 <= 63 then
                v11 = v14.WaveTime
                v8 = v1._.type(v11)
                v11 = "number"
                v9 = v8 ~= "number"
                v3 = v9 and 192 or 126
            elseif v3 >= 65 and v3 <= 71 then
                v3 = v9 and v3 + 178 or 96
            elseif v3 >= 156 and v3 <= 157 then
                v8 = true
                v9 = v14.Key
                v3, v7[v9] = 116, true
            elseif v3 >= 149 and v3 <= 154 then
                v11 = v14.Wave
                v8 = v1._.type(v11)
                v3, v11 = 745 / v3, "number"
                v9 = v8 ~= "number"
            elseif v3 >= 145 and v3 <= 148 then
                v11 = 0
                v8 = v14.Time
                v3, v9 = 18228 / v3, v8 < 0
            elseif v3 >= 135 and v3 <= 143 then
                v3, v15, v10 = 148 - v3, v2.Actions, v1._.type
                v10 = v10(v15)
                v15 = "table"
                v7 = v10 ~= "table"
            elseif v3 >= 129 and v3 <= 133 then
                v13 = v1._.type(v5) ~= "number"
                v3 = v13 and v3 + -30 or 8512 / v3
            elseif v3 >= 125 and v3 <= 127 then
                v3, v8, v11 = 318 - v3, v14.WaveTime, v14.WaveTime
                v9 = v8 ~= v11
            elseif v3 >= 190 and v3 <= 192 then
                v3 = v9 and 76 or 47
            elseif v3 >= 194 and v3 <= 196 then
                v8 = "Place"
                v9 = v14.Kind
                v3 = v9 == "Place" and 270 - v3 or 409 - v3
            elseif v3 >= 158 and v3 <= 171 then
                return true
            elseif v3 >= 172 and v3 <= 174 then
                v8 = v1._.type(v14)
                v11 = "table"
                v9 = v8 ~= "table"
                v3 = v9 and 1204 / v3 or 253
            elseif v3 >= 175 and v3 <= 177 then
                v3 = v13 and 193 or 250
            elseif v3 >= 179 and v3 <= 189 or v3 >= 239 and v3 <= 244 then
                return false
            elseif v3 >= 233 and v3 <= 238 then
                v3 = 144
                v8 = v1._.type(v14.Key)
                v11 = "string"
                v9 = v8 ~= "string"
            elseif v3 >= 231 and v3 <= 232 then
                v3 = v9 and 114 or 128
            elseif v3 >= 251 and v3 <= 253 then
                v3, v11 = 260 - v3, v1._.table
                v8 = v11.find
                v5 = "Place"
                v13 = "Upgrade"
                v4 = {}
                v4[5], v4[4], v4[1], v4[3], v4[2] = "Skip", "Sell", "Place", "Target", "Upgrade"
                v4, v11 = v14.Kind, v4
                v8 = v8(v11, v4)
                v9 = not v8
            elseif v3 >= 248 and v3 <= 250 then
                v4, v5 = v9(v8, v11)
                v11 = v4
                v3 = v4 == nil and 157 or 383 - v3
            elseif v3 >= 246 and v3 <= 247 or v3 >= 221 and v3 <= 229 then
                return false
            elseif v3 >= 217 and v3 <= 219 then
                v11 = "Target"
                v8 = v14.Kind
                v9 = v8 == "Target"
                v3 = v9 and 56 or v3 + -219
            elseif v3 >= 197 and v3 <= 200 then
                v8 = v14.WaveTime
                v11 = nil
                v9 = v8 ~= nil
                v3 = v9 and 58 or v3 + -131
            elseif v3 >= 201 and v3 <= 211 then
                v11 = 12
                v8 = #v14.CFrame
                v3, v9 = v3 + -186, v8 ~= 12
            elseif v3 >= 213 and v3 <= 215 then
                v9 = v14.Kind
                v8 = "Skip"
                v3 = v9 == "Skip" and 413 - v3 or 50
            else
                v10 = v1._.type(v2)
                v15 = "table"
                v7 = v10 ~= "table"
                v3 = v7 and 83 or 216
            end
        end
    end
end
local function _w327(v1, v2)
    return function(v3)
        if v3 == v1._.Enum.TeleportState.Started then
            v2[1][2].QueueTeleport()
        end
    end
end
local function _w328(v1, v2)
    return function()
        local v3, v4, v5
        v4, v5, v3 = v1._.pairs(v2[2][2])
        v4, v5, v3 = v1.g(v4, v5, v3)
        local v6, v7
        v7, v6 = v4(v5, v3)
        v3 = v7
        local v8
        if v7 ~= nil then
            while true do
                v8[v7] = v6
                v7, v6 = v4(v5, v3)
                v3 = v7
                if v7 ~= nil then
                    continue
                end
            end
        end
    end
end
local function _w329(v1, v2)
    return function()
        if v2[2][2] == nil then
            v2[1][2]:FireServer()
            return
        else
            while true do
                v2[1][2]:FireServer(v2[2][2])
            end
        end
    end
end
local function _w330(v1, v2)
    return function(v3)
        local v4 = v2[1][2]
        local v5 = v4.SafeName
        return v4.Folder .. "/" .. v5(v3) .. ".json"
    end
end
le({
    "P",
    "nc",
    "ob",
    "Qa",
    "k",
    "Bc",
    "ua",
    "tc",
    "Gb",
    "Nb",
    "Ef",
    "Q",
    "X",
    "ba",
    "b",
    "c",
    "lc",
    "cf",
    "wc",
    "Nc",
    "qe",
    "We",
    "Rb",
    "ja",
    "Ed",
    "d",
    "Ad",
    "qa",
    "Db",
    "rb",
    "of",
    "Pd",
    "ne",
    "jd",
    "rf",
    "xa",
    "Re",
    "nf",
    "Gc",
    "Ea",
    "ib",
    "Oc",
    "n",
    "va",
    "Sd",
    "Kd",
    "ia",
    "ya",
    "Ga",
    "kf",
    "Ye",
    "a",
    "g",
    "F",
    "Jc",
    "_e",
    "Qb",
    "Ba",
    "Xd",
    "cb",
    "Lc",
    "gf",
    "af",
    "Xb",
    "Ie",
    "Yc",
    "qf",
    "he",
    "Uc",
    "ma",
    "Cd",
    "ud",
    "vd",
    "x",
    "kb",
    "zb",
    "M",
    "ec",
    "sd",
    "B",
    "Pb",
    "ic",
    "gd",
    "yf",
    "bb",
    "df",
    "pa",
    "Se",
    "oe",
    "A",
    "Ca",
    "ac",
    "C",
    "Dc",
    "Je",
    "lb",
    "q",
    "Gd",
    "ge",
    "ae",
    "de",
    "db",
    "qc",
    "kd",
    "Xa",
    "Da",
    "Ja",
    "ab",
    "Ua",
    "sf",
    "La",
    "hd",
    "Ia",
    "ed",
    "Wc",
    "j",
    "_a",
    "R",
    "ca",
    "S",
    "if_",
    "fd",
    "ea",
    "Ab",
    "Af",
    "H",
    "Ya",
    "G",
    "sa",
    "I",
    "Va",
    "ub",
    "Kb",
    "jc",
    "Cf",
    "tf",
    "tb",
    "Tb",
    "Ra",
    "Sb",
    "sc",
    "Sc",
    "Mc",
    "_d",
    "w",
    "vf",
    "l",
    "Pc",
    "Te",
    "bc",
    "wb",
    "Wa",
    "fc",
    "mf",
    "vb",
    "D",
    "id",
    "kc",
    "ld",
    "Ge",
    "O",
    "yc",
    "_c",
    "Sa",
    "v",
    "Vb",
    "zf",
    "Cb",
    "u",
    "Y",
    "yb",
    "ee",
    "za",
    "K",
    "Hb",
    "je",
    "oa",
    "pb",
    "xf",
    "hb",
    "Pe",
    "aa",
    "Vd",
    "mb",
    "ie",
    "Na",
    "ke",
    "jf",
    "ef",
    "Wd",
    "re",
    "_",
    "se",
    "L",
    "Eb",
    "Xc",
    "Ac",
    "Vc",
    "o",
    "Xe",
    "Ib",
    "Td",
    "vc",
    "Ke",
    "Me",
    "Ta",
    "fb",
    "dc",
    "V",
    "Ob",
    "zd",
    "bf",
    "Bb",
    "Qc",
    "W",
    "qb",
    "md",
    "Nd",
    "ce",
    "zc",
    "eb",
    "_f",
    "Ve",
    "da",
    "m",
    "N",
    "me",
    "Od",
    "Jd",
    "Pa",
    "jb",
    "Mb",
    "_b",
    "wf",
    "cd",
    "Bd",
    "ta",
    "be",
    "Oe",
    "sb",
    "fa",
    "Qe",
    "xd",
    "rc",
    "r",
    "Ha",
    "hc",
    "oc",
    "p",
    "td",
    "nb",
    "qd",
    "Ue",
    "gb",
    "la",
    "Tc",
    "Le",
    "pf",
    "Hc",
    "dd",
    "pe",
    "Oa",
    "Ub",
    "mc",
    "Dd",
    "Md",
    "ff",
    "pc",
    "Jb",
    "Ne",
    "Fe",
    "ra",
    "uc",
    "s",
    "hf",
    "t",
    "od",
    "fe",
    "Hd",
    "Ud",
    "ka",
    "Fd",
    "Aa",
    "uf",
    "Wb",
    "Ld",
    "Ic",
    "Fa",
    "ad",
    "Ma",
    "Lb",
    "wa",
    "Yb",
    "T",
    "cc",
    "Fc",
    "Ff",
    "Bf",
    "xc",
    "y",
    "Qd",
    "Cc",
    "xb",
    "J",
    "pd",
    "na",
    "bd",
    "ga",
    "gc",
    "U",
    "Kc",
    "rd",
    "yd",
    "Fb",
    "Df",
    "Id",
    "lf",
    "Yd",
    "He",
    "wd",
    "Rd",
    "ha",
    "Rc",
    "Ka",
    "nd",
    "E",
    "z",
    "Ec",
}, "Ff", ...)
