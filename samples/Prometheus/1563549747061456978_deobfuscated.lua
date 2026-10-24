-- This file was generated at discord.gg/syncrypt

local Env = getfenv();
local W = {};
local r23 = {};
local r16 = setmetatable({}, {
    ["__index"] = r23,
    ["__metatable"] = nil
});
if _G.WindLoaded then
    warn("Jumantara Script is already running!");
    return;
end;
local v1 = _G;
v1.WindLoaded = true;
task.spawn(function(...)
    b = game;
    g = not b.IsLoaded(b);
    if g then
        g = game.Loaded;
        g.Wait(g);
    end;
    v = hookfunction;
    b = v;
    if v then
        b = islclosure(hookfunction);
    end;
    if b then
        g = game.Players.LocalPlayer;
        g.Kick(g, "Security Violation: Env Tampering Detected");
        while true do end;
    end;
    if not is_synapse_function and (not iskrnlclosure and not isexecutorclosure) then
    end; 
end);
local v2 = game;
local r24 = v2.GetService(v2, "TweenService");
local v3 = game;
local r25 = v3.GetService(v3, "RunService");
local v4 = game;
local r26 = loadstring(v4.HttpGet(v4, "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))();
local v5 = r26.Services;
v5.junkiedev = {
    ["Name"] = "Junkie Dev",
    ["Icon"] = "key",
    ["Args"] = {
        "ServiceName",
        "Identifier",
        "Provider"
    },
    ["New"] = function(arg1_2, arg2_2, arg3_2, ...)
        v1 = arg3_2;
        O = game;
        r27 = loadstring(O.HttpGet(O, "https://jnkie.com/sdk/library.lua"))();
        g = r27;
        v2 = arg1_2;
        g.service = v2;
        g = r27;
        v2 = arg2_2;
        g.identifier = v2;
        v3 = r27;
        b = "provider";
        v2 = v1;
        if v1 then
            g = v3;
            g[r16[v5]] = v1;
            return {
                ["Verify"] = function(arg1_3, ...)
                    v = arg1_3;
                    if not v or v == "" then
                        return false, "Key cannot be empty!";
                    end;
                    M = r27.check_key(v);
                    if M.valid then
                        return true, "Key Validated Successfully!";
                    end;
                    v1 = M.message or (M.error or "Unknown Error");
                    if v1 == "HWID_BANNED" then
                        return false, "HWID is Banned!";
                    end;
                    if v1 == "KEY_EXPIRED" then
                        return false, "Key Expired!";
                    end;
                    return false, v1; 
                end,
                ["Copy"] = function(...)
                    M = r27.get_key_link();
                    if M then
                        setclipboard(M);
                        return "Copied to clipboard: " .. M;
                    end;
                    return "Error: " .. tostring(M[2]); 
                end
            };
        else
            v2 = "Mixed";
        end; 
    end
};
local v6 = "MissionTargetID";
pz[1] = {};
pz[3] = false;
pz[5] = {};
pz[7] = false;
pz[9] = false;
pz[11] = false;
pz[12] = "AutoTPBoss";
pz[13] = false;
pz[14] = "DisableAnims";
pz[15] = false;
pz[16] = "WebhookURL";
pz[17] = "";
pz[18] = "WebhookEnabled";
pz[19] = false;
pz[20] = "WebhookWhitelist";
pz[21] = {};
pz[22] = "WebhookAutoStats";
pz[23] = false;
pz[24] = "WebhookInterval";
pz[26] = "WebhookMaxList";
pz[25] = 10;
pz[27] = 20;
pz[28] = "AutoUseSpecificSkill";
pz[29] = false;
pz[30] = "SpecificSkillsList";
pz[31] = {};
pz[32] = "SpecificSkillTarget";
pz[33] = "Always";
pz[34] = "AutoSkillGacha";
pz[35] = false;
pz[36] = "SkillGachaCount";
pz[37] = 5;
pz[38] = "AutoGift";
pz[39] = false;
pz[40] = "GiftLimit";
pz[41] = 10;
pz[42] = "GiftTarget";
pz[43] = "";
pz[44] = "GiftWhitelist";
pz[47] = 7;
pz[45] = {};
pz[49] = {};
pz[51] = 5;
pz[55] = nil;
pz[57] = nil;
local r28 = {
    ["AutoFarm"] = false,
    ["FarmDistance"] = 150,
    ["ChargeTime"] = .8,
    ["AutoSell"] = false,
    ["SellDelay"] = 60,
    ["AutoClaimAlbum"] = false,
    ["SelectedToolID"] = nil,
    ["AutoBuy"] = false,
    ["AutoHuntBoss"] = false,
    ["BossCheckInterval"] = 1,
    ["BossPriority"] = true,
    ["BossName"] = "",
    ["AutoTPChest"] = false,
    ["AutoUseSkill"] = false,
    ["TargetPriority"] = "Closest",
    ["StickToTarget"] = true,
    ["PrioritizeMutation"] = true,
    ["OnlyMutation"] = false,
    ["SelectedRarities"] = {},
    ["SelectedFishIDs"] = {},
    ["FarmMode"] = "Custom",
    ["UseRarityFilter"] = false,
    ["SelectedRarity"] = "1",
    [v6] = nil,
    ["AutoMission"] = false,
    ["SelectedMissionID"] = "Mession1",
    ["CurrentMissionStep"] = 1,
    ["UnlimitedRange"] = false,
    ["WalkSpeed"] = 16,
    ["JumpPower"] = 50,
    ["InfiniteJump"] = false,
    ["Noclip"] = false,
    ["AntiAFK"] = true,
    ["UnlockCursor"] = true,
    ["CursorToggleKey"] = Enum.KeyCode.LeftAlt,
    ["BossHop"] = false,
    ["AutoProgressShop"] = false,
    ["AutoReconnect"] = false,
    ["AntiStaff"] = false,
    ["AutoUnlock"] = false,
    [r16[r15("(6\x92\xe9b\x8a7x\x90P\xb5\xe4\xf6\x82n", pz[1])]] = {},
    [r16[pz[1]]] = false,
    [pz[1][pz[3]]] = pz[1],
    ["AutoSellRarity"] = pz[3],
    ["SellRarities"] = pz[5],
    ["EnableWalkSpeed"] = pz[7],
    ["EnableJumpPower"] = pz[9],
    ["AutoSkillGemsGacha"] = pz[11],
    ["AutoTPBoss"] = pz[13],
    ["DisableAnims"] = pz[15],
    ["WebhookURL"] = "",
    ["WebhookEnabled"] = pz[19],
    ["WebhookWhitelist"] = pz[21],
    ["WebhookAutoStats"] = pz[23],
    ["WebhookInterval"] = pz[25],
    ["WebhookMaxList"] = pz[27],
    ["AutoUseSpecificSkill"] = pz[29],
    ["SpecificSkillsList"] = pz[31],
    ["SpecificSkillTarget"] = "Always",
    ["AutoSkillGacha"] = pz[35],
    ["SkillGachaCount"] = pz[37],
    ["AutoGift"] = pz[39],
    ["GiftLimit"] = pz[41],
    ["GiftTarget"] = "",
    ["GiftWhitelist"] = pz[45],
    ["GiftToolbarSlot"] = pz[47],
    ["SelectedPoints"] = pz[49],
    ["BossScanInterval"] = pz[51],
    ["BossTPStrategy"] = "NearestSpawn",
    ["FarmSpot"] = pz[55],
    ["FarmSpotCoords"] = pz[57]
};
local r29 = {
    {
        ["Name"] = "Point 1",
        ["CFrame"] = CFrame.new(1291.04578, 95.697731, -366.907959)
    },
    {
        ["Name"] = "Point 2",
        ["CFrame"] = CFrame.new(435.460327, 96.8663254, -1033.87878)
    },
    {
        ["Name"] = "Point 3",
        ["CFrame"] = CFrame.new(1141.59741, -1161.55103, 3600.19995)
    },
    {
        ["Name"] = "Point 4",
        ["CFrame"] = CFrame.new(1102.93628, -1161.55103, 4191.78076)
    },
    {
        ["Name"] = "Point 5",
        ["CFrame"] = CFrame.new(1247.36975, 76.5539093, -569.399109)
    },
    {
        ["Name"] = "Point 6",
        ["CFrame"] = CFrame.new(1291.39746, -1026.17065, 3285.51562)
    }
};
local r30 = {
    ["Humpback Whale"] = "Point 1",
    ["Crimson Rift Dragon"] = "Point 2",
    ["Giant Octopus"] = "Point 3",
    ["Blue-Ringed Octopus"] = "Point 4",
    ["Tempest Voltking"] = "Point 5",
    ["Relic Guardian Dragon"] = "Point 6"
};
local r32 = false;
local r33 = {};
local r34 = {};
local r35 = {};
local r37 = {};
local r38 = false;
local v7 = g;
local v8 = v7;
local v9 = v8;
local r39 = syn and syn.request or (http and http.request or http_request);
local r42 = {};
local r43 = {};
local r44 = {};
local r45 = "";
if r28.DisableAnims == nil then
    v5 = r28;
    v5.DisableAnims = false;
end;
local r46 = true;
local v10 = game;
local r49 = v10.GetService(v10, "Players");
local r50 = r49.LocalPlayer;
local v11 = game;
local r51 = v11.GetService(v11, "ReplicatedStorage");
local v12 = r51;
local v13 = v9;
local r52 = v12.WaitForChild(v12, "Remotes", 10);
local v14 = r52;
if v14 then
    v14 = r52;
    Xe = v14.WaitForChild(v14, "FireRE", 5);
end;
local v15 = v13;
local r53 = v14;
local v16 = r52;
if v16 then
    v16 = r52;
    Xe = v16.WaitForChild(v16, "FishRE", 5);
end;
local v17 = v15;
local r54 = v16;
local v18 = r52;
if v18 then
    v18 = r52;
    Xe = v18.WaitForChild(v18, "ToolRE", 5);
end;
local v19 = v17;
local r55 = v18;
local v20 = r52;
if v20 then
    v20 = r52;
    Xe = v20.WaitForChild(v20, "SkillRE", 5);
end;
local v21 = v19;
local r56 = v20;
local v22 = r52;
local v23 = v22;
if v22 then
    v22 = r52;
    v23 = v22.WaitForChild(v22, "SendFishRF", 5);
end;
local v24 = v21;
local r57 = v23;
local v25 = r51;
local v26 = v25.WaitForChild(v25, "Config");
local r58 = {};
local v27 = {};
local function r59(arg1_4, ...)
    v = tonumber(arg1_4);
    if not v then
        return 0;
    end;
    M = 1000000000;
    if v >= M then
        M = string.format("%.1fB", v / 1000000000);
        return M.gsub(M, "%.0", "");
    end;
    M = 1000000;
    if v >= M then
        M = string.format("%.1fM", v / 1000000);
        return M.gsub(M, "%.0", "");
    end;
    M = 1000;
    if v >= M then
        M = string.format("%.1fK", v / 1000);
        return M.gsub(M, "%.0", "");
    end;
    return tostring(v); 
end;
local v28 = ("\xe8\xe3\xf3\x8f\x7f\x0cJ")[2];
local v29 = ("\xe8\xe3\xf3\x8f\x7f\x0cJ")[1];
for oe, Le in pairs(require(v26.WaitForChild(v26, "ResFish"))) do
    v24 = v24;
    if type(Le) == "table" and Le.Rarity then
        me = tostring(Le.Rarity);
        Pe = r58;
        Pe[tostring(oe)] = {
            ["Name"] = Le.Name,
            ["Price"] = Le.Price,
            ["Rarity"] = me
        };
        if not table.find({}, me) then
            table.insert({}, me);
        end;
    end; 
end;
table.sort(v27);
local v30 = game;
local r60 = require(v30.GetService(v30, "ReplicatedStorage").Config.ResMession);
(function(...)
    v1 = {
        pcall(function(...)
            v = r51;
            M = v.WaitForChild(v, "Config");
            return require(M.WaitForChild(M, "ResHarpoon")); 
        end)
    };
    v = v1[2];
    M = pcall(function(...)
        v = r51;
        M = v.WaitForChild(v, "Config");
        return require(M.WaitForChild(M, "ResHarpoon")); 
    end);
    if M then
        b = v1[2];
    end;
    if M then
        r33 = v;
        v1 = v.__index;
        if v1 then
            v3 = ("\xbf,\x95\x87\xbd\x94\xb0")[3];
            for v3, K in ("\xbf,\x95\x87\xbd\x94\xb0")[1], ipairs(v1) do
                v4 = v1[2][K];
                if v4 then
                    b = v4.AssetType ~= "Robux";
                end;
                v24 = v24;
                if v4 then
                    H = v4.Name .. " (" .. r59(v4.Price) .. ")";
                    table.insert(r34, H);
                    b = r35;
                    b[H] = v4.ID;
                end; 
            end;
        end;
    else
        b = r26;
        b.Notify(b, {
            ["Title"] = "Warning",
            ["Content"] = "Failed to load Shop Data. Using fallback.",
            ["Duration"] = 5
        });
        v10 = "Harpoon04";
        v3 = v10[3];
        v2 = v10[2];
        for v3, K in pairs({
            "Harpoon01",
            "Harpoon02",
            "Harpoon03",
            "Harpoon05",
            v10,
            "Harpoon06",
            "Harpoon07"
        }) do
            v10 = v3;
            table.insert(r34, K);
            b = r35;
            b[K] = K; 
        end;
        if #r34 > 0 then
            b = r28;
            b.SelectedToolID = r35[r34[1]];
        end;
        return;
    end; 
end)();
local r61 = "Jumantara_Hub_Spear_Fishing.txt";
local function r62(...)
    v24 = r50;
    v2 = 32061262821969;
    M = v24.FindFirstChild(v24, "PlayerGui");
    if M then
        v2 = M.FindFirstChild(M, "Data");
        b = v2 and v2.FindFirstChild(v2, "Fish");
        v24 = r50;
    end;
    if M then
        v2 = ("Data").Fish;
        v1 = v2[2];
        O = v2[3];
        v2 = "pairs";
        for O, v10 in pairs(v2.GetChildren(v2)) do
            v3 = O;
            if v10.GetAttribute(v10, "Lock") ~= true then
                table.insert({}, "Name");
            end; 
        end;
    end;
    return {}; 
end;
local function r63(arg1_5, ...)
    v = arg1_5;
    if not v or (not v.Parent or not v.IsA(v, "BasePart")) then
        return false;
    end;
    M = v.GetAttribute(v, "CurHP");
    if M then
        b = M > 0;
    end;
    return M; 
end;
local v31 = {};
local r64 = {};
local v32 = r58;
local v33 = v6[1];
local v34 = v6[2];
for Te, v32 in pairs(v32) do
    v6 = v32.Name .. " (" .. v32.Rarity .. ")";
    table.insert(v31, v6);
    Ie = r64;
    Ie[v6] = Te; 
end;
table.sort(v31);
local function r65(arg1_6, ...)
    v = arg1_6;
    if v then
        v = v;
        M = r50.Character;
        if M then
            v1 = M.FindFirstChild(M, "HumanoidRootPart");
        end;
        if not M then
            return nil;
        end;
        v24 = workspace;
        O = v24.FindFirstChild(v24, "WorldSea");
        v24 = not O;
        if v24 then
            return nil;
        end;
        if r28.StickToTarget and r31 then
            if ("Position" - r31.Position).Magnitude <= (r28.UnlimitedRange and math.huge or r28.FarmDistance) then
                return r31;
            end;
        end;
        I = O.GetChildren;
        v10 = {};
        v24 = pairs;
        H = I[3];
        for H, I in I[1], v24(I(O)) do
            k = H;
            u = I.GetChildren;
            c = u[2];
            A = u[3];
            for A, u in pairs(u(I)) do
                d = A;
                F = u.IsA(u, "BasePart");
                if F then
                    J = r63(u);
                end;
                if F then
                    J = ("Position" - u.Position).Magnitude;
                    if J <= (r28[W[M][W[O]("G\xeb\xc3R\xa0\xa1\xc50w\n\xa6K\xa4\xda", A)]] and math.huge or r28.FarmDistance) then
                        v24 = tostring;
                        F = v24(u.GetAttribute(u, "ID") or u.Name);
                        v24 = {
                            ["Object"] = u,
                            ["Distance"] = J,
                            ["ID"] = F,
                            ["Mutation"] = u.GetAttribute(u, "Mutation"),
                            ["CurHP"] = u.GetAttribute(u, "CurHP") or 0
                        };
                        table.insert({}, v24);
                        if b then
                            x = F == tostring(b);
                        end;
                        v24 = v24;
                        if b then
                            table.insert({}, v24);
                        end;
                    end;
                end; 
            end; 
        end;
        v4 = v;
        K = {};
        if v then
            v4 = #v10 > 0;
        end;
        v24 = v24;
        if v4 then
            v4 = {};
            K = {};
        else
            local function H(arg1_7, arg2_7, ...)
                M = arg2_7;
                if not M then
                    return false;
                end;
                O = v2[3];
                v1 = v2[2];
                v2 = "pairs";
                for O, v10 in pairs(M) do
                    v3 = O;
                    if v10 == arg1_7 then
                        return true;
                    end; 
                end;
                return false; 
            end;
            s = A[2];
            c = A[3];
            for c, A in ipairs({}) do
                d = true;
                k = c;
                u = r58[A.ID];
                if u then
                    Q = u.Rarity;
                end;
                v24 = H;
                J = u or "Unknown";
                v24 = H;
                if u then
                    x = u.Price;
                end;
                v24 = v24;
                x = J;
                A.Rarity = x;
                x = u or 0;
                A.Price = x;
                if r28.UseRarityFilter then
                    if J ~= tostring(r28.SelectedRarity) then
                        d = false;
                    end;
                else
                    t = v24;
                    if r28.OnlyMutation and not A.Mutation then
                        d = false;
                    end;
                    e = true;
                    if true then
                        t = #r28.SelectedRarities > 0;
                    end;
                    if true then
                        if not (function(arg1_8, arg2_8, ...)
                            M = arg2_8;
                            if not M then
                                return false;
                            end;
                            O = v2[3];
                            v1 = v2[2];
                            v2 = "pairs";
                            for O, v10 in pairs(M) do
                                v3 = O;
                                if v10 == arg1_8 then
                                    return true;
                                end; 
                            end;
                            return false; 
                        end)(u or "Unknown", r28.SelectedRarities) then
                            d = false;
                        end;
                    end;
                    if true then
                        e = #r28.SelectedFishIDs > 0;
                    end;
                    v24 = e;
                    if true then
                        if not (function(arg1_9, arg2_9, ...)
                            M = arg2_9;
                            if not M then
                                return false;
                            end;
                            O = v2[3];
                            v1 = v2[2];
                            v2 = "pairs";
                            for O, v10 in pairs(M) do
                                v3 = O;
                                if v10 == arg1_9 then
                                    return true;
                                end; 
                            end;
                            return false; 
                        end)(A.ID, r28.SelectedFishIDs) then
                            d = false;
                        end;
                    end;
                    if true then
                        table.insert({}, A);
                    end;
                end; 
            end;
            if #K == 0 then
                W[I] = nil;
                return nil;
            end;
            table.sort(K, function(arg1_10, arg2_10, ...)
                v = arg1_10;
                M = arg2_10;
                v2 = W[O];
                if r28.PrioritizeMutation then
                    v1 = v.Mutation ~= nil;
                    O = "Mutation" ~= nil;
                    if v1 then
                        b = not O;
                    end;
                    if v1 then
                        return true;
                    end;
                    v2 = not v1;
                    if v2 then
                        b = v24;
                    end;
                    if v2 then
                        return false;
                    end;
                end;
                if r28.TargetPriority == "HighestRarity" then
                    if v.Price ~= "Price" then
                        return arg1_10.Price > arg2_10.Price;
                    end;
                else
                    if r28.TargetPriority == "LowestHP" then
                        if arg1_10.CurHP ~= arg2_10.CurHP then
                            return arg1_10.CurHP < arg2_10.CurHP;
                        end;
                    end;
                    return v.Distance < "Distance";
                end; 
            end);
            r31 = K[1].Object;
            return r31;
        end;
    else
        b = r28.MissionTargetID;
    end; 
end;
local function r66(...)
    v24 = r26;
    v24.Notify(v24, {
        ["Title"] = "Boss Hunter",
        ["Content"] = "Cooldown > 30s. Hopping Server...",
        ["Duration"] = 5
    });
    v24 = game;
    r67 = v24.GetService(v24, "HttpService");
    v24 = game;
    r68 = v24.GetService(v24, "TeleportService");
    r69 = game.PlaceId;
    v3 = {
        pcall(function(...)
            v24 = r67;
            v = game;
            v2 = "data";
            O = v24.JSONDecode(v24, v.HttpGet(v, "https://games.roblox.com/v1/games/" .. r69 .. "/servers/Public?sortOrder=Asc&limit=100"))[v2];
            M = v2[2];
            O = v2[1];
            for v1, v3 in ipairs(O) do
                v2 = v1;
                if "playing" ~= "maxPlayers" and "id" ~= game.JobId then
                    v24 = r68;
                    v24.TeleportToPlaceInstance(v24, r69, "id", r50);
                    return;
                end; 
            end; 
        end)
    };
    v2 = pcall(function(...)
        v24 = r67;
        v = game;
        v2 = "data";
        O = v24.JSONDecode(v24, v.HttpGet(v, "https://games.roblox.com/v1/games/" .. r69 .. "/servers/Public?sortOrder=Asc&limit=100"))[v2];
        M = v2[2];
        O = v2[1];
        for v1, v3 in ipairs(O) do
            v2 = v1;
            if "playing" ~= "maxPlayers" and "id" ~= game.JobId then
                v24 = r68;
                v24.TeleportToPlaceInstance(v24, r69, "id", r50);
                return;
            end; 
        end; 
    end);
    O = v3[2];
    v24 = not v2;
    if v24 then
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Error",
            ["Content"] = "Server Hop Failed. Retrying...",
            ["Duration"] = 2
        });
    end; 
end;
local function r70(...)
    if isfile(r61) then
        return readfile(r61);
    end;
    return "None"; 
end;
local function r71(arg1_11, ...)
    writefile(r61, arg1_11); 
end;
local function r72(arg1_13, arg2_13, ...)
    v24 = r50;
    v3 = 9253380870356;
    v1 = v24.FindFirstChild(v24, "PlayerGui");
    O = v1 and v1.FindFirstChild(v1, "Data");
    v2 = O and O.FindFirstChild(O, arg1_13);
    if v2 then
        v3 = v2.GetAttribute(v2, "Count" .. arg2_13);
        return v3 or 0, v2.GetAttribute(v2, "Claimed"), v3 ~= nil;
    end;
    return 0, false, false; 
end;
local function r73(...)
    v = r60[r28.SelectedMissionID];
    if not v then
        return;
    end;
    v24 = r26;
    v24.Notify(v24, {
        ["Title"] = "Mission",
        ["Content"] = "Syncing progress...",
        ["Duration"] = 1
    });
    for f = 1, 20 do
        k = r15;
        if not v["Count" .. v1] then
        else
            A = {
                r72(r28.SelectedMissionID, v1)
            };
            v4 = A[2];
            k = r60[r28.SelectedMissionID]["Count" .. v1];
            if A[3] then
                if r72(r28.SelectedMissionID, v1) >= k then
                    M = v1 + 1;
                else
                    M = v1;
                end;
            end;
        end; 
    end;
    v24 = r28;
    v24.CurrentMissionStep = M;
    v24 = r26;
    v24.Notify(v24, {
        ["Title"] = "Mission",
        ["Content"] = "Synced to Step " .. 1,
        ["Duration"] = 2
    }); 
end;
local function r74(arg1_14, arg2_14, ...)
    M = arg2_14;
    v = arg1_14;
    v1 = v["Condition" .. M];
    if v1 == "HarpoonFish" then
        return "Fishing Rarity: " .. tostring(v["Rarity" .. M]);
    end;
    if v1 == "HarpoonRequiredFish" then
        return "Hunting: " .. tostring(v["RequiredID" .. M]);
    end;
    if v1 == "VisitLocation" or v1 == "Visit" then
        return "Visiting Location";
    end;
    if v1 == "BuyItem" or v1 == "Buy" then
        return "Buying Item";
    end;
    return "Unknown Objective"; 
end;
local function r78(...)
    v24 = r50;
    O = 18803266429491;
    v = v24.FindFirstChild(v24, "PlayerGui");
    if v then
        O = v.FindFirstChild(v, "Data");
        b = O and O.FindFirstChild(O, "Asset");
        v24 = r50;
    end;
    if v then
        v24 = v.Data.Asset;
        M = v24.GetAttribute(v24, "Coins");
        if M then
            return M;
        end;
    end;
    return 0; 
end;
local function r79(arg1_19, ...)
    v = arg1_19;
    if r33[v] then
        return r33[v].Price, r33[v].Name;
    end;
    return 999999999, v; 
end;
local function r80(...)
    if not r55 then
        return;
    end;
    r32 = true;
    b = r26;
    b.Notify(b, {
        ["Title"] = "System",
        ["Content"] = "Fixing aim (Switching tools)...",
        ["Duration"] = 1.5
    });
    b = r55;
    b.FireServer(b, unpack({
        [1] = "Switch",
        [2] = {
            ["index"] = 2
        }
    }));
    task.wait(.6);
    b = r55;
    b.FireServer(b, unpack({
        [1] = "Switch",
        [2] = {
            ["index"] = 1
        }
    }));
    task.wait(.6);
    r32 = false;
    v1 = r26;
    v1.Notify(v1, {
        ["Title"] = "System",
        ["Content"] = "Ready!",
        ["Duration"] = 1
    }); 
end;
local v36 = r26;
pz[3] = r16;
local r81 = v36.CreateWindow(v36, {
    ["Title"] = "Spear Fishing",
    ["Icon"] = "gamepad-2",
    ["Author"] = "Jumantara Hub",
    ["Folder"] = "SpearFishingWindUI",
    ["Transparent"] = true,
    ["Theme"] = "Plant",
    ["KeySystem"] = {
        ["Note"] = "Key System.",
        ["API"] = {
            {
                ["Type"] = "platoboost",
                [r16[r15("Y\x17\x8c\xe6\xe0\xf9\xac\xe3\xe2", "Provider")]] = 16361,
                [r16.Provider] = r16["Jumantara Hub"]
            },
            {
                ["Type"] = r16[r15("\xb8T;H\x93\xd5̉\xb4", "Provider")],
                [r16[r15("Provider", "Jumantara Hub")]] = r16.Provider,
                [r16["Jumantara Hub"]] = ("Provider")[pz[3]],
                ["Provider"] = "Jumantara Hub"
            }
        }
    }
});
local v37 = r81;
v37.EditOpenButton(v37, {
    ["Title"] = "Open UI",
    ["Icon"] = "monitor",
    ["CornerRadius"] = UDim.new(0, 16),
    ["StrokeThickness"] = 2,
    ["Color"] = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    ["OnlyMobile"] = false,
    ["Enabled"] = true,
    ["Draggable"] = true
});
local v38 = r81;
v38.Tag(v38, {
    ["Title"] = "UPD14",
    ["Icon"] = "arrow-big-up-dash",
    ["Color"] = Color3.fromHex("1d5452"),
    ["Radius"] = 8
});
local v39 = r81;
v39.Tag(v39, {
    ["Title"] = "V-3.0",
    ["Icon"] = "arrow-big-up-dash",
    ["Color"] = Color3.fromHex("1d5452"),
    ["Radius"] = 8
});
local v40 = r81;
local v41 = v40.Tab(v40, {
    ["Title"] = "Farm",
    ["Icon"] = "sword"
});
local v42 = r81;
local v43 = v42.Tab(v42, {
    ["Title"] = "Shop",
    ["Icon"] = "shopping-bag"
});
local v44 = r81;
v44.Tab(v44, {
    ["Title"] = "Album",
    ["Icon"] = "book"
});
local v45 = r81;
v45.Tab(v45, {
    ["Title"] = "Sell",
    ["Icon"] = "shopping-cart"
});
local v46 = r81;
v46.Tab(v46, {
    ["Title"] = "Settings",
    ["Icon"] = "settings"
});
local function r82(...)
    v24 = game;
    r83 = v24.GetService(v24, "HttpService");
    v24 = pcall;
    O = {
        v24(function(...)
            v24 = r83;
            return v24.JSONEncode(v24, r28); 
        end)
    };
    M = O[2];
    v1 = v24(function(...)
        v24 = r83;
        return v24.JSONEncode(v24, r28); 
    end);
    if v1 then
        setclipboard(M);
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Share Config",
            ["Content"] = "Config copied to clipboard!",
            ["Duration"] = 3
        });
    else
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Share Config",
            ["Content"] = "Failed to copy config: " .. tostring(M),
            ["Duration"] = 3
        });
    end; 
end;
local function r84(arg1_20, ...)
    r85 = arg1_20;
    v24 = game;
    v2 = 22888397187490;
    r86 = v24.GetService(v24, "HttpService");
    if r85 and r85 ~= "" then
        v24 = pcall;
        v2 = {
            v24(function(...)
                v24 = r86;
                return v24.JSONDecode(v24, r85); 
            end)
        };
        v1 = v2[2];
        O = v24(function(...)
            v24 = r86;
            return v24.JSONDecode(v24, r85); 
        end);
        if O then
            b = type(v1) == "table";
        end;
        if O then
            v2 = (22888397187490)[2];
            v10 = (22888397187490)[1];
            for v3, v4 in pairs(v1) do
                v24 = r28;
                v24[v3] = v4;
                v24 = r44[v3 .. "Toggle"];
                if v24 then
                    v24 = r44[v3 .. "Toggle"];
                    v24.Set(v24, v4);
                else
                    v24 = r44[v3 .. "Slider"];
                    if v24 then
                        v24 = r44[v3 .. "Slider"];
                        v24.Set(v24, v4);
                    else
                        v24 = r44[v3 .. "Dropdown"];
                        if v24 then
                            v24 = r44[v3 .. "Dropdown"];
                            v24.Set(v24, v4);
                        else
                            if v3 == "AutoFarm" and r44.AutoFarmingToggle then
                                v24 = r44.AutoFarmingToggle;
                                v24.Set(v24, v4);
                            else
                                if v3 == "UnlimitedRange" and r44.UnlimitedRangeToggle then
                                    v24 = r44.UnlimitedRangeToggle;
                                    v24.Set(v24, v4);
                                else
                                    if v3 == "FarmDistance" and r44.FarmDistanceSlider then
                                        v24 = r44.FarmDistanceSlider;
                                        v24.Set(v24, v4);
                                    else
                                        if v3 == "ChargeTime" and r44.ChargeTimeSlider then
                                            v24 = r44.ChargeTimeSlider;
                                            v24.Set(v24, v4);
                                        else
                                            if v3 == "AutoUseSkill" and r44.AutoUseSkillToggle then
                                                v24 = r44.AutoUseSkillToggle;
                                                v24.Set(v24, v4);
                                            else
                                                if v3 == "AutoUseSpecificSkill" and r44.AutoUseSpecificSkillToggle then
                                                    v24 = r44.AutoUseSpecificSkillToggle;
                                                    v24.Set(v24, v4);
                                                else
                                                    if v3 == "SpecificSkillsList" and r44.SpecificSkillsListDropdown then
                                                        v24 = r44.SpecificSkillsListDropdown;
                                                        v24.Set(v24, v4);
                                                    else
                                                        if v3 == "SpecificSkillTarget" and r44.SpecificSkillTargetDropdown then
                                                            v24 = r44.SpecificSkillTargetDropdown;
                                                            v24.Set(v24, v4);
                                                        else
                                                            if v3 == "DisableAnims" and r44.DisableAnimsToggle then
                                                                v24 = r44.DisableAnimsToggle;
                                                                v24.Set(v24, v4);
                                                            else
                                                                if v3 == "AutoHuntBoss" and r44.AutoHuntBossToggle then
                                                                    v24 = r44.AutoHuntBossToggle;
                                                                    v24.Set(v24, v4);
                                                                else
                                                                    if v3 == "BossHop" and r44.BossHopToggle then
                                                                        v24 = r44.BossHopToggle;
                                                                        v24.Set(v24, v4);
                                                                    else
                                                                        if v3 == "AutoTPBoss" and r44.AutoTPBossToggle then
                                                                            v24 = r44.AutoTPBossToggle;
                                                                            v24.Set(v24, v4);
                                                                        else
                                                                            if v3 == "BossTPStrategy" and r44.BossTPStrategyDropdown then
                                                                                v24 = r44.BossTPStrategyDropdown;
                                                                                v24.Set(v24, v4);
                                                                            else
                                                                                if v3 == "BossScanInterval" and r44.BossScanIntervalSlider then
                                                                                    v24 = r44.BossScanIntervalSlider;
                                                                                    v24.Set(v24, v4);
                                                                                else
                                                                                    if v3 == "SelectedPoints" and r44.SelectedPointsDropdown then
                                                                                        v24 = r44.SelectedPointsDropdown;
                                                                                        v24.Set(v24, v4);
                                                                                    else
                                                                                        if v3 == "TargetPriority" and r44.TargetPriorityDropdown then
                                                                                            v24 = r44.TargetPriorityDropdown;
                                                                                            v24.Set(v24, v4);
                                                                                        else
                                                                                            if v3 == "StickToTarget" and r44.StickToTargetToggle then
                                                                                                v24 = r44.StickToTargetToggle;
                                                                                                v24.Set(v24, v4);
                                                                                            else
                                                                                                if v3 == "PrioritizeMutation" and r44.PrioritizeMutationToggle then
                                                                                                    v24 = r44.PrioritizeMutationToggle;
                                                                                                    v24.Set(v24, v4);
                                                                                                else
                                                                                                    if v3 == "OnlyMutation" and r44.OnlyMutationToggle then
                                                                                                        v24 = r44.OnlyMutationToggle;
                                                                                                        v24.Set(v24, v4);
                                                                                                    else
                                                                                                        if v3 == "SelectedRarities" and r44.RarityMultiDropdown then
                                                                                                            v24 = r44.RarityMultiDropdown;
                                                                                                            v24.Set(v24, v4);
                                                                                                        else
                                                                                                            if v3 == "SelectedFishIDs" and r44.FishMultiDropdown then
                                                                                                                v24 = r44.FishMultiDropdown;
                                                                                                                v24.Set(v24, v4);
                                                                                                            else
                                                                                                                if v3 == "AutoTPChest" and r44.AutoTPChestToggle then
                                                                                                                    v24 = r44.AutoTPChestToggle;
                                                                                                                    v24.Set(v24, v4);
                                                                                                                else
                                                                                                                    if v3 == "SelectedToolID" and r44.SelectToolDropdown then
                                                                                                                        H = c[1];
                                                                                                                        k = c[2];
                                                                                                                        for I, c in pairs(r35) do
                                                                                                                            v24 = c == v4;
                                                                                                                            s = I;
                                                                                                                            if v24 then
                                                                                                                                v24 = r44.SelectToolDropdown;
                                                                                                                                v24.Set(v24, I);
                                                                                                                            end; 
                                                                                                                        end;
                                                                                                                    else
                                                                                                                        if v3 == "AutoBuy" and r44.AutoBuyToggle then
                                                                                                                            v24 = r44.AutoBuyToggle;
                                                                                                                            v24.Set(v24, v4);
                                                                                                                        else
                                                                                                                            if v3 == "AutoProgressShop" and r44.AutoProgressShopToggle then
                                                                                                                                v24 = r44.AutoProgressShopToggle;
                                                                                                                                v24.Set(v24, v4);
                                                                                                                            else
                                                                                                                                if v3 == "AutoSkillGacha" and r44.AutoSkillGachaToggle then
                                                                                                                                    v24 = r44.AutoSkillGachaToggle;
                                                                                                                                    v24.Set(v24, v4);
                                                                                                                                else
                                                                                                                                    if v3 == "AutoSkillGemsGacha" and r44.AutoSkillGachaGemsToggle then
                                                                                                                                        v24 = r44.AutoSkillGachaGemsToggle;
                                                                                                                                        v24.Set(v24, v4);
                                                                                                                                    else
                                                                                                                                        if v3 == "AutoClaimAlbum" and r44.AutoClaimAlbumToggle then
                                                                                                                                            v24 = r44.AutoClaimAlbumToggle;
                                                                                                                                            v24.Set(v24, v4);
                                                                                                                                        else
                                                                                                                                            if v3 == "AutoLock" and r44.AutoLockToggle then
                                                                                                                                                v24 = r44.AutoLockToggle;
                                                                                                                                                v24.Set(v24, v4);
                                                                                                                                            else
                                                                                                                                                if v3 == "LockedFishIDs" and r44.LockFishDropdown then
                                                                                                                                                    v24 = r44.LockFishDropdown;
                                                                                                                                                    v24.Set(v24, v4);
                                                                                                                                                else
                                                                                                                                                    if v3 == "AutoUnlock" and r44.AutoUnlockToggle then
                                                                                                                                                        v24 = r44.AutoUnlockToggle;
                                                                                                                                                        v24.Set(v24, v4);
                                                                                                                                                    else
                                                                                                                                                        if v3 == "UnlockedFishIDs" and r44.UnlockFishDropdown then
                                                                                                                                                            v24 = r44.UnlockFishDropdown;
                                                                                                                                                            v24.Set(v24, v4);
                                                                                                                                                        else
                                                                                                                                                            if v3 == "AutoLockRarity" and r44.AutoLockRarityToggle then
                                                                                                                                                                v24 = r44.AutoLockRarityToggle;
                                                                                                                                                                v24.Set(v24, v4);
                                                                                                                                                            else
                                                                                                                                                                if v3 == "LockedRarities" and r44.LockRarityDropdown then
                                                                                                                                                                    v24 = r44.LockRarityDropdown;
                                                                                                                                                                    v24.Set(v24, v4);
                                                                                                                                                                else
                                                                                                                                                                    if v3 == "AutoSell" and r44.AutoSellToggle then
                                                                                                                                                                        v24 = r44.AutoSellToggle;
                                                                                                                                                                        v24.Set(v24, v4);
                                                                                                                                                                    else
                                                                                                                                                                        if v3 == "SellDelay" and r44.SellDelaySlider then
                                                                                                                                                                            v24 = r44.SellDelaySlider;
                                                                                                                                                                            v24.Set(v24, v4);
                                                                                                                                                                        else
                                                                                                                                                                            if v3 == "AutoSellRarity" and r44.AutoSellRarityToggle then
                                                                                                                                                                                v24 = r44.AutoSellRarityToggle;
                                                                                                                                                                                v24.Set(v24, v4);
                                                                                                                                                                            else
                                                                                                                                                                                if v3 == "SellRarities" and r44.SellRarityDropdown then
                                                                                                                                                                                    v24 = r44.SellRarityDropdown;
                                                                                                                                                                                    v24.Set(v24, v4);
                                                                                                                                                                                else
                                                                                                                                                                                    if v3 == "GiftTarget" and r44.GiftTargetDropdown then
                                                                                                                                                                                        v24 = r44.GiftTargetDropdown;
                                                                                                                                                                                        v24.Set(v24, v4);
                                                                                                                                                                                    else
                                                                                                                                                                                        if v3 == "GiftWhitelist" and r44.GiftWhitelistDropdown then
                                                                                                                                                                                            v24 = r44.GiftWhitelistDropdown;
                                                                                                                                                                                            v24.Set(v24, v4);
                                                                                                                                                                                        else
                                                                                                                                                                                            if v3 == "GiftLimit" and r44.GiftLimitSlider then
                                                                                                                                                                                                v24 = r44.GiftLimitSlider;
                                                                                                                                                                                                v24.Set(v24, v4);
                                                                                                                                                                                            else
                                                                                                                                                                                                if v3 == "GiftToolbarSlot" and r44.GiftToolbarSlotSlider then
                                                                                                                                                                                                    v24 = r44.GiftToolbarSlotSlider;
                                                                                                                                                                                                    v24.Set(v24, v4);
                                                                                                                                                                                                else
                                                                                                                                                                                                    if v3 == "AutoGift" and r44.AutoGiftToggle then
                                                                                                                                                                                                        v24 = r44.AutoGiftToggle;
                                                                                                                                                                                                        v24.Set(v24, v4);
                                                                                                                                                                                                    else
                                                                                                                                                                                                        if v3 == "UnlockCursor" and r44.UnlockCursorToggle then
                                                                                                                                                                                                            v24 = r44.UnlockCursorToggle;
                                                                                                                                                                                                            v24.Set(v24, v4);
                                                                                                                                                                                                        else
                                                                                                                                                                                                            if v3 == "EnableWalkSpeed" and r44.EnableWalkSpeedToggle then
                                                                                                                                                                                                                v24 = r44.EnableWalkSpeedToggle;
                                                                                                                                                                                                                v24.Set(v24, v4);
                                                                                                                                                                                                            else
                                                                                                                                                                                                                if v3 == "WalkSpeed" and r44.WalkSpeedSlider then
                                                                                                                                                                                                                    v24 = r44.WalkSpeedSlider;
                                                                                                                                                                                                                    v24.Set(v24, v4);
                                                                                                                                                                                                                else
                                                                                                                                                                                                                    if v3 == "EnableJumpPower" and r44.EnableJumpPowerToggle then
                                                                                                                                                                                                                        v24 = r44.EnableJumpPowerToggle;
                                                                                                                                                                                                                        v24.Set(v24, v4);
                                                                                                                                                                                                                    else
                                                                                                                                                                                                                        if v3 == "JumpPower" and r44.JumpPowerSlider then
                                                                                                                                                                                                                            v24 = r44.JumpPowerSlider;
                                                                                                                                                                                                                            v24.Set(v24, v4);
                                                                                                                                                                                                                        else
                                                                                                                                                                                                                            if v3 == "InfiniteJump" and r44.InfJumpToggle then
                                                                                                                                                                                                                                v24 = r44.InfJumpToggle;
                                                                                                                                                                                                                                v24.Set(v24, v4);
                                                                                                                                                                                                                            else
                                                                                                                                                                                                                                if v3 == "Noclip" and r44.NoclipToggle then
                                                                                                                                                                                                                                    v24 = r44.NoclipToggle;
                                                                                                                                                                                                                                    v24.Set(v24, v4);
                                                                                                                                                                                                                                else
                                                                                                                                                                                                                                    if v3 == "AntiAFK" and r44.AntiAFKToggle then
                                                                                                                                                                                                                                        v24 = r44.AntiAFKToggle;
                                                                                                                                                                                                                                        v24.Set(v24, v4);
                                                                                                                                                                                                                                    else
                                                                                                                                                                                                                                        if v3 == "AutoReconnect" and r44.AutoReconnectToggle then
                                                                                                                                                                                                                                            v24 = r44.AutoReconnectToggle;
                                                                                                                                                                                                                                            v24.Set(v24, v4);
                                                                                                                                                                                                                                        else
                                                                                                                                                                                                                                            if v3 == "AntiStaff" and r44.AntiStaffToggle then
                                                                                                                                                                                                                                                v24 = r44.AntiStaffToggle;
                                                                                                                                                                                                                                                v24.Set(v24, v4);
                                                                                                                                                                                                                                            end;
                                                                                                                                                                                                                                        end;
                                                                                                                                                                                                                                    end;
                                                                                                                                                                                                                                end;
                                                                                                                                                                                                                            end;
                                                                                                                                                                                                                        end;
                                                                                                                                                                                                                    end;
                                                                                                                                                                                                                end;
                                                                                                                                                                                                            end;
                                                                                                                                                                                                        end;
                                                                                                                                                                                                    end;
                                                                                                                                                                                                end;
                                                                                                                                                                                            end;
                                                                                                                                                                                        end;
                                                                                                                                                                                    end;
                                                                                                                                                                                end;
                                                                                                                                                                            end;
                                                                                                                                                                        end;
                                                                                                                                                                    end;
                                                                                                                                                                end;
                                                                                                                                                            end;
                                                                                                                                                        end;
                                                                                                                                                    end;
                                                                                                                                                end;
                                                                                                                                            end;
                                                                                                                                        end;
                                                                                                                                    end;
                                                                                                                                end;
                                                                                                                            end;
                                                                                                                        end;
                                                                                                                    end;
                                                                                                                end;
                                                                                                            end;
                                                                                                        end;
                                                                                                    end;
                                                                                                end;
                                                                                            end;
                                                                                        end;
                                                                                    end;
                                                                                end;
                                                                            end;
                                                                        end;
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end; 
            end;
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Share Config",
                ["Content"] = "Successfully loaded and applied configuration!",
                ["Duration"] = 3
            });
        else
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Share Config",
                ["Content"] = "Invalid JSON format.",
                ["Duration"] = 3
            });
        end;
    else
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Share Config",
            ["Content"] = "Input is empty.",
            ["Duration"] = 3
        });
    end; 
end;
local v47 = v41.Section(v41, {
    ["Title"] = "Main Controls"
});
local v48 = r44;
v48.AutoFarmingToggle = v47.Toggle(v47, {
    ["Title"] = "Enable Auto Farm",
    ["Desc"] = "Auto farm with Aim Lock",
    ["Value"] = false,
    ["Flag"] = "AutoFarmingToggle",
    ["Callback"] = function(arg1_21, ...)
        v24 = r28;
        v = arg1_21;
        v24.AutoFarm = v;
        if v then
            task.spawn(r80);
        else
            r32 = false;
        end; 
    end
});
local v49 = r44;
v49.UnlimitedRangeToggle = v47.Toggle(v47, {
    ["Title"] = "Unlimited Shooting Range",
    ["Desc"] = "Ignore range limit (Shoot from anywhere)",
    ["Value"] = false,
    ["Flag"] = "UnlimitedRangeToggle",
    ["Callback"] = function(arg1_22, ...)
        v24 = r28;
        v24.UnlimitedRange = arg1_22; 
    end
});
local v50 = r44;
v50.FarmDistanceSlider = v47.Slider(v47, {
    ["Title"] = "Custom Range (If Unlimited Off)",
    ["Step"] = 5,
    ["Flag"] = "FarmDistanceSlider",
    ["Value"] = {
        ["Min"] = 25,
        ["Max"] = 500,
        ["\x9a\xfeW\x87n\xeaU"] = 150
    },
    ["Callback"] = function(arg1_23, ...)
        v24 = r28;
        v24.FarmDistance = arg1_23; 
    end
});
local v51 = r44;
v51.ChargeTimeSlider = v47.Slider(v47, {
    ["Title"] = "Aim Duration",
    ["Step"] = .05,
    ["Flag"] = "ChargeTimeSlider",
    ["Value"] = {
        ["Min"] = .01,
        ["Max"] = 2,
        ["Default"] = .6
    },
    ["Callback"] = function(arg1_24, ...)
        v24 = r28;
        v24.ChargeTime = arg1_24; 
    end
});
local v52 = r44;
v52.AutoUseSkillToggle = v47.Toggle(v47, {
    ["Title"] = "Auto Use Skill (All)",
    ["Desc"] = "Spam all skills automatically (Legacy)",
    ["Flag"] = "AutoUseSkillToggle",
    ["Value"] = false,
    ["Callback"] = function(arg1_25, ...)
        v24 = r28;
        v24.AutoUseSkill = arg1_25; 
    end
});
local v53 = r44;
v53.AutoUseSpecificSkillToggle = v47.Toggle(v47, {
    ["Title"] = "Auto Use Specific Skills",
    ["Desc"] = "Only use customized skills",
    ["Flag"] = "AutoUseSpecificSkillToggle",
    ["Value"] = false,
    ["Callback"] = function(arg1_26, ...)
        v24 = r28;
        v24.AutoUseSpecificSkill = arg1_26; 
    end
});
local v54 = r44;
pz[3] = 6134203026216;
v54.SpecificSkillsListDropdown = v47.Dropdown(v47, {
    ["Title"] = "Select Skills to Auto Use",
    ["Multi"] = true,
    ["Values"] = {
        "Skill01",
        "Skill02",
        "Skill03",
        "Skill04",
        "Skill05",
        r16[r15("1\x86C\xa8\xac\x8eg", "Skill11")],
        r16[r15("Skill11", "Skill12")],
        r16.Skill11,
        r16.Skill12,
        ("Skill11")[pz[3]],
        "Skill11",
        "Skill12",
        pz[3],
        "Skill14"
    },
    ["Value"] = {},
    ["Flag"] = "SpecificSkillsListDropdown",
    ["Callback"] = function(arg1_27, ...)
        v = arg1_27;
        M = 0;
        v3 = r15;
        if type(v) == "table" then
            v2 = v3[3];
            v3 = v3[1];
            for v2, K in v3, pairs(v) do
                M = 0 + 1;
                table.insert({}, K); 
            end;
        else
            if v then
                O = arg1_27 ~= "";
            end;
            v24 = O == b;
            if v then
                M = 1;
                table.insert({}, arg1_27);
            end;
            v2 = 0 > 5;
            if v2 then
                v2 = r26;
                v2.Notify(v2, {
                    ["Title"] = "Skill Customization",
                    ["Content"] = "Warning: Game max equip is 5 skills!",
                    ["Duration"] = 3
                });
            end;
            v2 = r28;
            v2.SpecificSkillsList = {};
            return;
        end; 
    end
});
local v55 = r44;
v55.SpecificSkillTargetDropdown = v47.Dropdown(v47, {
    ["Title"] = "Skill Usage Target",
    ["Multi"] = false,
    ["Values"] = {
        "Always",
        "Boss Only",
        "Normal Fish Only"
    },
    ["Value"] = "Always",
    ["Flag"] = "SpecificSkillTargetDropdown",
    ["Callback"] = function(arg1_28, ...)
        v24 = r28;
        v24.SpecificSkillTarget = arg1_28; 
    end
});
local v56 = r44;
v56.DisableAnimsToggle = v47.Toggle(v47, {
    ["Title"] = "Disable Animations",
    ["Desc"] = "Stops visual effects (FPS Boost)",
    ["Value"] = false,
    ["Flag"] = "DisableAnimsToggle",
    ["Callback"] = function(arg1_29, ...)
        v24 = r28;
        v24.DisableAnims = arg1_29; 
    end
});
local v57 = v41.Section(v41, {
    ["Title"] = "Boss Hunter"
});
local v58 = r44;
v58.AutoHuntBossToggle = v57.Toggle(v57, {
    ["Title"] = "Auto Hunt Boss",
    ["Desc"] = "Prioritize boss over fish",
    ["Flag"] = "AutoHuntBossToggle",
    ["Value"] = false,
    ["Callback"] = function(arg1_30, ...)
        v24 = r28;
        v = arg1_30;
        v24.AutoHuntBoss = v;
        if v then
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Boss Hunter",
                ["Content"] = "Boss hunting enabled!",
                ["Duration"] = 2
            });
        else
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Boss Hunter",
                ["Content"] = "Boss hunting disabled!",
                ["Duration"] = 2
            });
        end; 
    end
});
local v59 = r44;
v59.BossHopToggle = v57.Toggle(v57, {
    ["Title"] = "Hop if Boss CD > 30s",
    ["Value"] = false,
    ["Flag"] = "BossHopToggle",
    ["Callback"] = function(arg1_31, ...)
        v24 = r28;
        v24.BossHop = arg1_31; 
    end
});
local v60 = v41.Section(v41, {
    ["Title"] = "Auto TP Boss Farm"
});
local v61 = r44;
v61.AutoTPBossToggle = v60.Toggle(v60, {
    ["Title"] = "Enable Auto TP Boss",
    ["Desc"] = "Scan & TP to boss across all islands",
    ["Value"] = false,
    ["Flag"] = "AutoTPBossToggle",
    ["Callback"] = function(arg1_32, ...)
        v24 = r28;
        v = arg1_32;
        v24.AutoTPBoss = v;
        if v then
            M = r50.Character;
            v1 = M and M.FindFirstChild(M, "HumanoidRootPart");
            if v1 then
                v24 = r28;
                v24.BossReturnPos = v1.CFrame;
            end;
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "TP Boss",
                ["Content"] = "Auto TP Boss Farm enabled! Scanning...",
                ["Duration"] = 3
            });
        else
            v24 = r28;
            v24.BossReturnPos = nil;
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "TP Boss",
                ["Content"] = "Auto TP Boss Farm disabled.",
                ["Duration"] = 2
            });
        end; 
    end
});
local v62 = r44;
pz[2] = "\x83qH\x9dJԹ7";
pz[1] = 6134203026216;
v62.BossTPStrategyDropdown = v60.Dropdown(v60, {
    ["Title"] = "TP Strategy",
    ["Multi"] = false,
    ["Values"] = {
        "NearestSpawn",
        "AlreadyActive"
    },
    ["Value"] = "NearestSpawn",
    ["\rS\x14\xd7"] = r16[r15(pz[1], pz[2])],
    ["Callback"] = function(arg1_33, ...)
        v = arg1_33;
        v24 = r28;
        v24.BossTPStrategy = v;
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "TP Boss",
            ["Content"] = "Strategy: " .. v,
            ["Duration"] = 1
        }); 
    end
});
local v63 = r44;
pz[1] = 35051334680514;
v63.BossScanIntervalSlider = v60.Slider(v60, {
    ["Title"] = "Scan Interval (sec)",
    ["Step"] = 1,
    ["Flag"] = "BossScanIntervalSlider",
    ["Value"] = {
        ["\xfcc\xc3"] = 1,
        [r16[pz[1]]] = 30,
        ["Default"] = pz[1]
    },
    ["Callback"] = function(arg1_34, ...)
        v24 = r28;
        v24.BossScanInterval = arg1_34; 
    end
});
local v64 = r44;
pz[3] = r16;
pz[3] = function(arg1_35, ...)
    v = arg1_35;
    if v then
        g = r28;
        g.SelectedPoints = v;
        return;
    else
        M = {};
    end; 
end;
v64.SelectedPointsDropdown = v60.Dropdown(v60, {
    ["Title"] = "Select Bosses (Whitelist)",
    ["Multi"] = true,
    ["Values"] = (function(...)
        v = {};
        O = r30;
        M = (4)[2];
        O = (4)[1];
        for v1, v3 in pairs(O) do
            table.insert(v, v1); 
        end;
        table.sort(v);
        return v; 
    end)(),
    ["Value"] = {},
    [r16[r15("\x16\xf9[\xde}\x95\xea\xfa\xea\xcd\xf7;\xe9\xe0XM", "SelectedPointsDropdown")]] = true,
    [r16.SelectedPointsDropdown] = true,
    [("SelectedPointsDropdown")[pz[3]]] = "SelectedPointsDropdown",
    ["Callback"] = pz[3]
});
local r87 = v60.Paragraph(v60, {
    ["Title"] = "Boss Tracker",
    ["Desc"] = "Enable Auto TP Boss to see live status."
});
v60.Button(v60, {
    ["Title"] = "Set Current Pos as Farm Spot",
    ["Desc"] = "Fallback location when bosses are on CD",
    ["Callback"] = function(...)
        v = r50.Character;
        M = v and v.FindFirstChild(v, "HumanoidRootPart");
        if M then
            v24 = r28;
            O = "CFrame";
            v24.FarmSpot = {
                O.GetComponents(O)
            };
            v24 = r26;
            O = "Title";
            v24.Notify(v24, {
                [O] = "Farm Spot",
                ["Content"] = "Location saved!",
                ["Duration"] = 2
            });
            v24 = FarmSpotInput;
            if v24 then
                v1 = (b and v.FindFirstChild(v, "HumanoidRootPart")).Position;
                v24 = FarmSpotInput;
                v24.Set(v24, string.format("%.0f, %.0f, %.0f", v1.X, v1.Y, v1.Z));
            else
                v24 = r28;
                O = (b and v.FindFirstChild(v, "HumanoidRootPart")).CFrame;
                v24.FarmSpot = {
                    O.GetComponents(O)
                };
            end;
        end; 
    end
});
pz[1] = ":\xfd\x1c^\xeaP\xb7b";
local v65 = v60.Input(v60, {
    ["Title"] = "Current Farm Spot",
    ["Desc"] = "Saved location for fallback",
    ["Value"] = "Not Set",
    ["Placeholder"] = "Coordinates...",
    ["Flag"] = r16[r15(")\xddw\x19a{\xb6Q\xc4y\x10t\xf8H", pz[1])],
    ["Callback"] = function(arg1_36, ...)
        v = arg1_36;
        if v then
            b = v ~= "Not Set";
        end;
        if v then
            v2 = r15;
            O = {
                v.match(v, "([^,]+), ([^,]+), ([^,]+)")
            };
            v1 = v.match(v, "([^,]+), ([^,]+), ([^,]+)");
            M = O[3];
            O = O[2];
            if v1 then
                v2 = O[2];
                b = v2 and M;
                v24 = O[1];
            end;
            if v1 then
                v24 = r28;
                v24.FarmSpot = {
                    tonumber(v1),
                    tonumber(O),
                    tonumber(M)
                };
            end;
        end; 
    end
});
v60.Button(v60, {
    ["Title"] = "Clear Farm Spot",
    ["Callback"] = function(...)
        v24 = r28;
        v24.FarmSpot = nil;
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Farm Spot",
            ["Content"] = "Location cleared.",
            ["Duration"] = 2
        }); 
    end
});
local v66 = v41.Section(v41, {
    ["Title"] = "Flexible Targeting"
});
local v67 = r44;
pz[4] = r16;
pz[4] = function(arg1_37, ...)
    g = r28;
    v = arg1_37;
    g.TargetPriority = v;
    g = r26;
    g.Notify(g, {
        ["Title"] = "Priority Updated",
        ["Content"] = v,
        ["Duration"] = 1
    }); 
end;
v67.TargetPriorityDropdown = v66.Dropdown(v66, {
    ["Title"] = "Target Priority",
    ["Multi"] = false,
    ["Values"] = {
        r16[r15("Flag", "TargetPriorityDropdown")],
        r16.Flag,
        r16.TargetPriorityDropdown
    },
    [r16[r15("Flag", "TargetPriorityDropdown")]] = r16.Flag,
    [r16.TargetPriorityDropdown] = true,
    ["Flag"] = "TargetPriorityDropdown",
    ["Callback"] = pz[4]
});
local v68 = r44;
pz[1] = "\xfa\xf2$Y";
pz[2] = 26967804391693;
v68.StickToTargetToggle = v66.Toggle(v66, {
    ["Title"] = "Stick to Target",
    ["Desc"] = "Finish current fish before switching",
    ["Value"] = true,
    ["Flag"] = r16[pz[1]],
    [r16[pz[2]]] = function(arg1_38, ...)
        v24 = r28;
        v24.StickToTarget = arg1_38; 
    end
});
local v69 = r44;
pz[1] = r15;
pz[2] = 27693627077215;
v69.PrioritizeMutationToggle = v66.Toggle(v66, {
    ["Title"] = "Prioritize Mutation",
    ["Desc"] = "Mutated fish will be targeted first",
    ["Value"] = true,
    [r16[r15(pz[1], pz[2])]] = r16[pz[1]],
    ["Callback"] = function(arg1_39, ...)
        v24 = r28;
        v24.PrioritizeMutation = arg1_39; 
    end
});
local v70 = r44;
pz[1] = r15;
pz[2] = 18480004293021;
v70.OnlyMutationToggle = v66.Toggle(v66, {
    ["Title"] = "Only Mutated",
    ["Desc"] = "Ignore non-mutated fish",
    ["Value"] = false,
    [r16[r15(pz[1], pz[2])]] = r16[pz[1]],
    ["Callback"] = function(arg1_40, ...)
        v24 = r28;
        v24.OnlyMutation = arg1_40; 
    end
});
local v71 = v41.Section(v41, {
    ["Title"] = "Target Filters"
});
local v72 = r44;
pz[6] = r16;
pz[4] = true;
pz[6] = function(arg1_41, ...)
    v = arg1_41;
    b = "SelectedRarities";
    M = v;
    f = r28;
    if v then
        g = g;
        g[r16[O]] = v;
        print("Selected Rarities:", table.concat(r28.SelectedRarities, ", "));
        return;
    else
        M = {};
    end; 
end;
v72.RarityMultiDropdown = v71.Dropdown(v71, {
    ["Title"] = "Filter by Rarity",
    ["Multi"] = true,
    [r16[r15("_\x8e\xd3\xd2 \xd1", "Flag")]] = v27,
    [r16[r15("Flag", "RarityMultiDropdown")]] = {},
    [r16.RarityMultiDropdown] = true,
    ["Flag"] = "RarityMultiDropdown",
    ["AllowNone"] = pz[4],
    ["Callback"] = pz[6]
});
local v73 = r44;
pz[2] = true;
pz[10] = 2200981062656;
pz[9] = "*\xd1\r\x8f\x8f\xdbja";
pz[8] = 2200981062656;
pz[6] = function(arg1_42, ...)
    v = arg1_42;
    M = {};
    p = r15;
    if type(v) == "table" then
        O = p[3];
        p = p[1];
        for O, z in p, pairs(v) do
            K = r64[z];
            if K then
                table.insert({}, K);
            end; 
        end;
    end;
    g = r28;
    O = M;
    g.SelectedFishIDs = O;
    print("Selected Fish IDs Count:", #M); 
end;
pz[1] = 11127269807165;
pz[6] = 19117627155142;
v73.FishMultiDropdown = v71.Dropdown(v71, {
    ["Title"] = "Filter by Fish",
    ["Multi"] = true,
    ["\xcaͧz\xb0\xfe"] = v31,
    [r16[r15(pz[1], pz[2])]] = {},
    [r16[pz[2]]] = true,
    [pz[1]] = pz[2],
    ["Flag"] = "FishMultiDropdown",
    ["Callback"] = pz[6]
});
local v74 = v41.Section(v41, {
    ["Title"] = "Chest Teleport"
});
local v75 = r44;
pz[2] = r16;
pz[2] = function(arg1_43, ...)
    g = r28;
    g.AutoTPChest = arg1_43; 
end;
v75.AutoTPChestToggle = v74.Toggle(v74, {
    ["Title"] = "Auto TP Chest",
    ["Desc"] = r16[r15("\x7fV\xab\xcdž\xe2p\xf5\x17X\xca\xd3a6\x15\xf0\xf3\x01\xb7rFP\xb9\xfa\x02\x9d\xe45g\x1a\xc4\x05\xfa", "Callback")],
    [r16[r15("Callback", pz[2])]] = r16.Callback,
    [r16[pz[2]]] = false,
    ["Callback"] = pz[2]
});
local v76 = v43.Section(v43, {
    ["Title"] = "Shop (Coins Only)"
});
v76.Paragraph(v76, {
    ["Title"] = "Info",
    ["Content"] = "Robux items are hidden automatically."
});
local v77 = r44;
local v78 = "SelectToolDropdown";
local v79 = "Title";
local v82 = false;
local v84 = "Flag";
pz[1] = "SelectToolDropdown";
pz[2] = "Value";
pz[7] = 1;
pz[6] = r34;
pz[5] = pz[6][pz[7]];
pz[3] = pz[5];
pz[4] = v24;
if pz[5] then
    pz[5] = r34;
    pz[7] = true;
    pz[11] = r16;
    pz[9] = true;
    pz[11] = function(arg1_44, ...)
        M = r35[arg1_44];
        if M then
            v24 = r28;
            v1 = v24;
            v24.SelectedToolID = v1;
        end; 
    end;
    v77.SelectToolDropdown = v76.Dropdown(v76, {
        ["Title"] = "Select Harpoon",
        [W[M][W[O]("\xf2\xb4P\xc2\xc2", pz[1])]] = false,
        [W[M][pz[1]]] = true,
        [pz[1][pz[3]]] = pz[1],
        [pz[2]] = pz[3],
        ["Values"] = pz[5],
        ["AllowNone"] = pz[7],
        ["SearchBarEnabled"] = pz[9],
        ["Callback"] = pz[11]
    });
    pz[1] = 8048666529443;
    pz[2] = 2891818353986;
    v76.Button(v76, {
        ["Title"] = "Buy Selected Tool",
        ["Desc"] = "Buy item immediately",
        ["\xb7\x1a\xe2\x15"] = r16[r15(pz[1], pz[2])],
        ["Callback"] = function(...)
            if not r28.SelectedToolID then
                return;
            end;
            M = r79(r28.SelectedToolID);
            v1 = r78();
            v24 = v1 >= M;
            if v24 then
                v24 = r51;
                b = v24.WaitForChild(v24, "Remotes");
                O = b.WaitForChild(b, "ToolRE");
                O.FireServer(O, "Buy", {
                    ["ID"] = r28.SelectedToolID
                });
                v24 = r26;
                v24.Notify(v24, {
                    ["Title"] = "Shop",
                    ["Content"] = "Buying " .. v1[2] .. "...",
                    ["Duration"] = 2
                });
            else
                v24 = r26;
                v24.Notify(v24, {
                    ["Title"] = "Failed",
                    ["Content"] = "Need " .. r59(M) .. " Coins. You have " .. r59(v1),
                    ["Duration"] = 3
                });
            end; 
        end
    });
    v77 = r44;
    pz[3] = r16;
    pz[3] = function(arg1_45, ...)
        v24 = r28;
        v24.AutoBuy = arg1_45; 
    end;
    v77.AutoBuyToggle = v76.Toggle(v76, {
        ["Title"] = "Auto Buy Selected",
        ["AutoBuyToggle"] = "Callback",
        ["AutoBuyToggle"] = false,
        [("AutoBuyToggle")[pz[3]]] = "AutoBuyToggle",
        ["Callback"] = pz[3]
    });
    v77 = r44;
    pz[1] = r16;
    pz[2] = r15;
    pz[1] = function(arg1_46, ...)
        v24 = r28;
        v24.AutoProgressShop = arg1_46; 
    end;
    v77.AutoProgressShopToggle = v76.Toggle(v76, {
        ["Title"] = "Auto Progress Harpoon",
        [r16[r15("\xe8|Λ", pz[1])]] = r16[r15(pz[1], pz[2])],
        ["Value"] = false,
        ["Callback"] = pz[1]
    });
    v77 = v43.Section(v43, {
        ["Title"] = "Skill Gacha"
    });
    v78 = r44;
    pz[4] = r16;
    pz[4] = function(arg1_47, ...)
        v24 = r28;
        v24.AutoSkillGacha = arg1_47; 
    end;
    v78.AutoSkillGachaToggle = v77.Toggle(v77, {
        ["Title"] = "Flag",
        ["AutoSkillGachaToggle"] = "Flag",
        ["AutoSkillGachaToggle"] = false,
        ["Flag"] = "AutoSkillGachaToggle",
        ["Callback"] = pz[4]
    });
    task.spawn(function(...)
        while true do
            if r28.AutoSkillGacha and r56 then
                v24 = r56;
                v24.FireServer(v24, "SkillGacha", {
                    ["Key"] = "Coins",
                    ["Count"] = 5
                });
            end;
            task.wait(1); 
        end; 
    end);
    v77.Divider(v77);
    v78 = r44;
    pz[4] = r16;
    pz[4] = function(arg1_48, ...)
        v24 = r28;
        v24.AutoSkillGemsGacha = arg1_48; 
    end;
    pz[1] = 3518986372710;
    v78.AutoSkillGachaGemsToggle = v77.Toggle(v77, {
        ["Title"] = "\x89\xe0\x07\x92L=\x9a\xf5*\x0e\xb4f$\x89\x9a",
        ["AutoSkillGachaGemsToggle"] = "\x89\xe0\x07\x92L=\x9a\xf5*\x0e\xb4f$\x89\x9a",
        ["AutoSkillGachaGemsToggle"] = false,
        [pz[1]] = "AutoSkillGachaGemsToggle",
        ["Callback"] = pz[4]
    });
    task.spawn(function(...)
        while true do
            if r28.AutoSkillGemsGacha and r56 then
                v24 = r56;
                v24.FireServer(v24, "SkillGacha", {
                    ["Key"] = "Gems",
                    ["Count"] = 5
                });
            end;
            task.wait(1); 
        end; 
    end);
    v78 = ee.Section(ee, {
        ["Title"] = "Album Unlocker"
    });
    qz = r44;
    pz[1] = r16;
    pz[2] = r15;
    pz[1] = function(arg1_49, ...)
        v24 = r28;
        v24.AutoClaimAlbum = arg1_49; 
    end;
    qz.AutoClaimAlbumToggle = v78.Toggle(v78, {
        [r16[r15("\xd1\x19\x05\xd1\x02", pz[1])]] = r16[r15(pz[1], pz[2])],
        ["Value"] = false,
        ["Callback"] = pz[1]
    });
    qz = we.Section(we, {
        ["Title"] = "Lock Fish"
    });
    Xz = r44;
    pz[2] = false;
    pz[6] = r16;
    pz[6] = function(arg1_50, ...)
        v24 = r28;
        v24.AutoLock = arg1_50; 
    end;
    Xz.AutoLockToggle = qz.Toggle(qz, {
        [r16[r15("Value", pz[2])]] = "Value",
        [r16[pz[2]]] = ("Value").Flag,
        ["Value"] = pz[2],
        ["Flag"] = "AutoLockToggle",
        ["Callback"] = pz[6]
    });
    Xz = r44;
    pz[3] = {};
    pz[5] = true;
    pz[7] = true;
    pz[11] = r16;
    pz[11] = function(arg1_51, ...)
        v = arg1_51;
        if type(v) == "table" then
            v1 = v2[2];
            v2 = v2[1];
            for O, v10 in pairs(v) do
                K = r64[v10];
                if K then
                    table.insert({}, K);
                end; 
            end;
        end;
        v24 = r28;
        v24.LockedFishIDs = {}; 
    end;
    Xz.LockFishDropdown = qz.Dropdown(qz, {
        ["Value"] = "Values",
        ["Value"] = true,
        ["Values"] = v31,
        ["Value"] = pz[3],
        ["SearchBarEnabled"] = pz[5],
        ["AllowNone"] = pz[7],
        ["Flag"] = "LockFishDropdown",
        ["Callback"] = pz[11]
    });
    qz.Divider(qz);
    Xz = r44;
    pz[2] = false;
    pz[6] = r16;
    pz[6] = function(arg1_52, ...)
        v24 = r28;
        v24.AutoUnlock = arg1_52; 
    end;
    Xz.AutoUnlockToggle = qz.Toggle(qz, {
        [r16[r15("Value", pz[2])]] = "Value",
        [r16[pz[2]]] = ("Value").Flag,
        ["Value"] = pz[2],
        ["Flag"] = "AutoUnlockToggle",
        ["Callback"] = pz[6]
    });
    Xz = r44;
    pz[3] = {};
    pz[5] = true;
    pz[7] = true;
    pz[11] = r16;
    pz[11] = function(arg1_53, ...)
        v = arg1_53;
        if type(v) == "table" then
            O = v2[3];
            v1 = v2[2];
            v2 = "pairs";
            for O, v10 in pairs(v) do
                K = r64[v10];
                if K then
                    table.insert({}, K);
                end; 
            end;
        end;
        v24 = r28;
        v24.UnlockedFishIDs = {}; 
    end;
    pz[8] = 16542671953431;
    pz[1] = 12751315031857;
    Xz.UnlockFishDropdown = qz.Dropdown(qz, {
        ["Value"] = r16[pz[1]],
        ["Value"] = true,
        [pz[1]] = v31,
        ["Value"] = pz[3],
        ["SearchBarEnabled"] = pz[5],
        ["AllowNone"] = pz[7],
        [pz[8]] = "UnlockFishDropdown",
        ["Callback"] = pz[11]
    });
    pz[1] = r15;
    pz[2] = 31417400506661;
    qz.Button(qz, {
        ["Title"] = r16[r15("\xd3-MR\xbfPg\n\x94a\xd4\x16>\xb1\xb5", pz[1])],
        [r16[r15(pz[1], pz[2])]] = "Instantly unlock all locked fish in inventory",
        ["Callback"] = function(...)
            pcall(function(...)
                local Y = {
                    Y[1],
                    Y[2],
                    Y[3],
                    Y[4],
                    Y[5]
                };
                v24 = W[Y[1]];
                v = v24.FindFirstChild(v24, "PlayerGui");
                M = v and v.FindFirstChild(v, "Data");
                if M then
                    K = M.GetChildren;
                    v10 = {
                        K(M)
                    };
                    v3 = K[3];
                    v2 = K[2];
                    for v3, v4 in pairs(l(b)) do
                        K = v3;
                        if v4.GetAttribute(v4, "Lock") then
                            v1[v4.Name] = false;
                            O = 0 + 1;
                        end; 
                    end;
                    v2 = 0 > 0;
                    if v2 then
                        v2 = W[Y[4]];
                        v2.FireServer(v2, "Lock", {
                            ["Locks"] = {}
                        });
                        v2 = W[Y[5]];
                        v2.Notify(v2, {
                            ["Title"] = "Unlock All",
                            ["Content"] = "Unlocked " .. 0 .. " fish",
                            ["Duration"] = 2
                        });
                    else
                        v2 = W[Y[5]];
                        v2.Notify(v2, {
                            ["Title"] = "Unlock All",
                            ["Content"] = "No locked fish found",
                            ["Duration"] = 2
                        });
                    end;
                end; 
            end); 
        end
    });
    qz.Divider(qz);
    Xz = r44;
    pz[6] = r16;
    pz[6] = function(arg1_54, ...)
        v24 = r28;
        v24.AutoLockRarity = arg1_54; 
    end;
    pz[2] = 29914729657962;
    Xz.AutoLockRarityToggle = qz.Toggle(qz, {
        ["®Ә\x0f"] = "Value",
        ["®Ә\x0f"] = ("Value").Flag,
        ["Value"] = pz[2],
        ["Flag"] = "AutoLockRarityToggle",
        ["Callback"] = pz[6]
    });
    Xz = r44;
    pz[3] = {};
    pz[5] = true;
    pz[7] = true;
    pz[11] = r16;
    pz[11] = function(arg1_55, ...)
        v = arg1_55;
        if v then
            v24 = r28;
            v24.LockedRarities = v;
            return;
        else
            M = {};
        end; 
    end;
    Xz.LockRarityDropdown = qz.Dropdown(qz, {
        ["Value"] = "Values",
        ["Value"] = true,
        ["Values"] = v27,
        ["Value"] = pz[3],
        ["SearchBarEnabled"] = pz[5],
        ["AllowNone"] = pz[7],
        ["Flag"] = "LockRarityDropdown",
        ["Callback"] = pz[11]
    });
    Xz = we.Section(we, {
        ["Title"] = " \x8f/$\x1e\xdb\xee"
    });
    pz[3] = r16;
    pz[1] = false;
    pz[3] = function(arg1_56, ...)
        v24 = r28;
        v24.AutoSell = arg1_56; 
    end;
    Xz.Toggle(Xz, {
        [r16[r15("\x0c\xf7\xa2N\xa3", pz[1])]] = "Callback",
        [r16[pz[1]]] = "Callback",
        [pz[1][pz[3]]] = pz[1],
        ["Callback"] = pz[3]
    });
    v79 = r44;
    pz[1] = 1;
    pz[7] = 2;
    pz[9] = 300;
    pz[11] = 60;
    pz[5] = {
        ["Min"] = pz[7],
        ["Max"] = pz[9],
        ["Default"] = pz[11]
    };
    pz[7] = r16;
    pz[7] = function(arg1_57, ...)
        v24 = r28;
        v24.SellDelay = arg1_57; 
    end;
    pz[3] = 5858908457640;
    v79.SellDelaySlider = Xz.Slider(Xz, {
        [r16[pz[1]]] = "Flag",
        [pz[1][pz[3]]] = pz[1],
        ["Flag"] = pz[3],
        ["Value"] = pz[5],
        ["Callback"] = pz[7]
    });
    Xz.Divider(Xz);
    v79 = r44;
    pz[7] = r16;
    pz[7] = function(arg1_58, ...)
        v24 = r28;
        v24.AutoSellRarity = arg1_58; 
    end;
    pz[3] = 6421077445550;
    v79.AutoSellRarityToggle = Xz.Toggle(Xz, {
        ["Sell only fish matching selected rarities"] = "Value",
        [("Sell only fish matching selected rarities")[pz[3]]] = "Sell only fish matching selected rarities",
        ["Value"] = pz[3],
        ["Flag"] = "AutoSellRarityToggle",
        ["Callback"] = pz[7]
    });
    v79 = r44;
    pz[4] = {};
    pz[6] = true;
    pz[8] = true;
    pz[12] = function(arg1_59, ...)
        v = arg1_59;
        if v then
            v24 = r28;
            v24.SellRarities = v;
            return;
        else
            M = {};
        end; 
    end;
    pz[1] = 21616464815953;
    pz[12] = 34534400245457;
    v79.SellRarityDropdown = Xz.Dropdown(Xz, {
        [r16[pz[1]]] = "Values",
        [pz[1].Value] = pz[1],
        ["Values"] = v27,
        ["Value"] = pz[4],
        ["SearchBarEnabled"] = pz[6],
        ["AllowNone"] = pz[8],
        ["Flag"] = "SellRarityDropdown",
        ["Callback"] = pz[12]
    });
    pz[1] = "9\x80۳\x06\t$\xf5z\xff\xb1uDT\x1fA\x1b\xa0Zf}";
    pz[2] = ">(\"\xff\xed\xb4C\x81\xde\nK-\xa8<\xc0\xaar#";
    v79 = we.Section(we, {
        [r16[r15("͸\x89\xab\xa2", pz[1])]] = r16[r15(pz[1], pz[2])]
    });
    r88 = {};
    local function r89(...)
        r88 = {};
        O = r49;
        v2 = {
            O.GetPlayers(O)
        };
        v1 = O[3];
        M = O[2];
        for v1, v2 in pairs(l(v2)) do
            O = v1;
            if v2 ~= r50 then
                table.insert(r88, v2.Name);
            end; 
        end;
        table.sort(r88); 
    end;
    r89();
    v82 = r44;
    pz[4] = false;
    pz[6] = r88;
    pz[9] = pz[4];
    v24 = pz[9];
    pz[10] = true;
    pz[14] = r16;
    pz[14] = function(arg1_60, ...)
        v24 = r28;
        v24.GiftTarget = arg1_60; 
    end;
    pz[3] = "Ħ\xd2\x1c\x83";
    pz[7] = 29785081624109;
    pz[8] = 7877513645652;
    v82[r16[pz[1]]] = v79.Dropdown(v79, {
        ["Title"] = "Gift Target",
        [pz[3]] = pz[4],
        ["Values"] = pz[6],
        [pz[7]] = pz[8],
        ["SearchBarEnabled"] = pz[10],
        ["Flag"] = "GiftTargetDropdown",
        ["Callback"] = pz[14]
    });
    pz[2] = r16;
    pz[3] = r15;
    pz[2] = function(...)
        r89();
        v24 = r44.GiftTargetDropdown;
        v24.Refresh(v24, r88, r28.GiftTarget); 
    end;
    v79.Button(v79, {
        [r16[pz[2]]] = ("Callback")[pz[3]],
        ["Callback"] = pz[2]
    });
    v82 = r44;
    pz[4] = true;
    pz[7] = {};
    pz[9] = true;
    pz[13] = r16;
    pz[13] = function(arg1_61, ...)
        v = arg1_61;
        if type(v) == "table" then
            O = v2[3];
            v1 = v2[2];
            v2 = "pairs";
            for O, v10 in pairs(v) do
                K = r64[v10];
                if K then
                    table.insert({}, K);
                end; 
            end;
        end;
        v24 = r28;
        v24.GiftWhitelist = {}; 
    end;
    v82[r16[pz[1]]] = v79.Dropdown(v79, {
        ["Title"] = "Select Fish to Gift",
        ["Multi"] = pz[4],
        ["Values"] = v31,
        ["Value"] = pz[7],
        ["SearchBarEnabled"] = pz[9],
        ["Flag"] = "GiftWhitelistDropdown",
        ["Callback"] = pz[13]
    });
    v82 = r44;
    pz[6] = 1;
    pz[10] = 1;
    pz[12] = 100;
    pz[14] = 10;
    pz[8] = {
        ["Min"] = pz[10],
        ["Max"] = pz[12],
        ["Default"] = pz[14]
    };
    pz[12] = r16;
    pz[12] = function(arg1_62, ...)
        v24 = r28;
        v24.GiftLimit = arg1_62; 
    end;
    pz[5] = "\xe5A\x1b\xedS";
    v82[r16[pz[1]]] = v79.Slider(v79, {
        ["Title"] = "Gift Limit",
        ["Desc"] = "Stop after sending X fish",
        [pz[5]] = pz[6],
        ["Value"] = pz[8],
        ["Flag"] = "GiftLimitSlider",
        ["Callback"] = pz[12]
    });
    v82 = r44;
    pz[6] = 1;
    pz[10] = 1;
    pz[12] = 10;
    pz[14] = 7;
    pz[8] = {
        ["Min"] = pz[10],
        ["Max"] = pz[12],
        ["Default"] = pz[14]
    };
    pz[12] = r16;
    pz[12] = function(arg1_63, ...)
        v24 = r28;
        v24.GiftToolbarSlot = arg1_63; 
    end;
    pz[5] = 5512248707590;
    pz[4] = "/)\xceu}";
    pz[11] = "1\x88\xa3@";
    v82[r16[pz[1]]] = v79.Slider(v79, {
        ["Title"] = "Toolbar Slot",
        ["Desc"] = pz[4],
        [pz[5]] = pz[6],
        ["Value"] = pz[8],
        ["Flag"] = "GiftToolbarSlotSlider",
        [pz[11]] = pz[12]
    });
    r90 = 0;
    r91 = v79.Paragraph(v79, {
        [("Status").Ready] = "Status",
        ["Desc"] = "Ready"
    });
    v82 = r44;
    pz[1] = "Toggle";
    pz[1] = v79[pz[1]];
    pz[6] = false;
    pz[10] = r16;
    pz[10] = function(arg1_64, ...)
        v24 = r28;
        v = arg1_64;
        v24.AutoGift = v;
        if v then
            r90 = 0;
        end; 
    end;
    pz[2] = {
        ["Title"] = "Start Auto Gift",
        ["Value"] = pz[6],
        ["Flag"] = "AutoGiftToggle",
        ["Callback"] = pz[10]
    };
    pz[1] = pz[1](v79, pz[2]);
    v82[pz[1][pz[3]]] = pz[1];
    pz[1] = "spawn";
    pz[1] = function(...)
        while true do
            if r28.AutoGift and (r28.GiftTarget ~= "" and #r28.GiftWhitelist > 0) then
                v24 = r90 >= r28.GiftLimit;
                if v24 then
                    v24 = r28;
                    v24.AutoGift = false;
                    v24 = r91;
                    v24.SetDesc(v24, "Limit Reached (" .. r90 .. ")");
                    v24 = r26;
                    v24.Notify(v24, {
                        ["Title"] = "Auto Gift",
                        ["Content"] = "Limit Reached!",
                        ["Duration"] = 3
                    });
                    task.wait(1);
                end;
                v24 = r91;
                v10 = r28.GiftLimit;
                v3 = 15145156418444;
                v24.SetDesc(v24, "Scanning Inventory... Sent: " .. r90 .. "/" .. v10);
                v24 = r50;
                O = 15145156418444;
                v = v24.FindFirstChild(v24, "PlayerGui");
                if v then
                    O = v.FindFirstChild(v, "Data");
                    b = O and O.FindFirstChild(O, "Fish");
                    v24 = r50;
                end;
                M = v;
                if M then
                    v10 = M.GetChildren;
                    v3 = {
                        v10(M)
                    };
                    v2 = v10[3];
                    v3 = v10[1];
                    for v2, K in v3, pairs(l(v3)) do
                        v10 = v2;
                        v24 = pairs;
                        A = r28;
                        I = A[2];
                        k = A[1];
                        for s, A in v24(A.GiftWhitelist) do
                            c = s;
                            if A == (K.GetAttribute(K, "ID") or K.Name) then
                                H = true;
                            end; 
                        end;
                        if false then
                            k = not K.GetAttribute(K, "Lock");
                        end;
                        v24 = v24;
                        if false then
                            v1 = K;
                        end; 
                    end;
                end;
                if v1 then
                    O = v1.GetAttribute(v1, "ID") or v1.Name;
                    v3 = r91;
                    v3.SetDesc(v3, "Equipping " .. O .. "...");
                    v3 = r55;
                    v3.FireServer(v3, "Equip", {
                        ["ID"] = O,
                        ["UID"] = v1.Name
                    });
                    task.wait(0.5);
                    v3 = r55;
                    v3.FireServer(v3, "Switch", {
                        ["index"] = r28.GiftToolbarSlot or 7
                    });
                    task.wait(0.5);
                    v3 = r49;
                    I = r16;
                    K = r28.GiftTarget;
                    r92 = v3.FindFirstChild(v3, K);
                    if r92 then
                        v10 = r91;
                        v10.SetDesc(v10, "Sending to " .. r92.Name .. "...");
                        local function H(...)
                            v24 = r57;
                            v24.InvokeServer(v24, r92); 
                        end;
                        I = {
                            pcall(H)
                        };
                        v4 = I[2];
                        if pcall(H) then
                            r90 = r90 + 1;
                            H = r91;
                            H.SetDesc(H, "Sent: " .. r90 .. "/" .. r28.GiftLimit);
                            H = r26;
                            H.Notify(H, {
                                ["Title"] = "Gift Sent",
                                ["Content"] = "Sent " .. (v1.GetAttribute(v1, "ID") or v1.Name) .. " to " .. r92.Name,
                                ["Duration"] = 2
                            });
                            H = r55;
                            H.FireServer(H, "Switch", {
                                ["index"] = 1
                            });
                            task.wait(1.5);
                        else
                            H = r26;
                            H.Notify(H, {
                                ["Title"] = "Error",
                                ["Content"] = "Failed to send!",
                                ["Duration"] = 2
                            });
                        end;
                    else
                        K = r28;
                        K.AutoGift = false;
                        K = r26;
                        K.Notify(K, {
                            ["Title"] = "Error",
                            ["Content"] = "Target Player not found!",
                            ["Duration"] = 3
                        });
                    end;
                else
                    O = r91;
                    O.SetDesc(O, "No whitelisted fish found.");
                    task.wait(2);
                end;
            end; 
        end; 
    end;
    Env[pz[1]][pz[1]](pz[1]);
    v82 = Ne.Section(Ne, {
        ["Title"] = "Keybinds"
    });
    pz[9] = r16;
    pz[9] = function(arg1_65, ...)
        v24 = r81;
        v24.SetToggleKey(v24, Enum.KeyCode[arg1_65]); 
    end;
    pz[1] = {
        ["Title"] = "Menu Key",
        ["Value"] = "K",
        ["Flag"] = "MenuKeybind",
        ["Callback"] = pz[9]
    };
    v82.Keybind(v82, pz[1]);
    v84 = r44;
    pz[2] = "Toggle";
    pz[10] = r28;
    pz[9] = pz[10].UnlockCursor;
    pz[2] = v82[pz[2]];
    pz[13] = r16;
    pz[13] = function(arg1_66, ...)
        v24 = r28;
        v = arg1_66;
        v24.UnlockCursor = v;
        if v then
            v24 = game;
            b = v24.GetService(v24, "UserInputService");
            b.MouseIconEnabled = true;
            v24 = game;
            b = v24.GetService(v24, "UserInputService");
            b.MouseBehavior = Enum.MouseBehavior.Default;
        else
            v24 = game;
            b = v24.GetService(v24, "UserInputService");
            b.MouseIconEnabled = false;
            v24 = game;
            b = v24.GetService(v24, "UserInputService");
            b.MouseBehavior = Enum.MouseBehavior.LockCenter;
        end; 
    end;
    pz[3] = {
        ["Title"] = "Unlock Cursor",
        ["Desc"] = "Force mouse visible/free",
        ["Value"] = pz[9],
        ["Flag"] = "UnlockCursorToggle",
        ["Callback"] = pz[13]
    };
    pz[2] = pz[2](v82, pz[3]);
    v84[pz[1]] = pz[2];
    pz[11] = r16;
    pz[11] = function(arg1_67, ...)
        v24 = r28;
        v24.CursorToggleKey = Enum.KeyCode[arg1_67]; 
    end;
    pz[1] = {
        ["Title"] = "Toggle Cursor Key",
        ["Desc"] = "Key to switch cursor mode",
        ["Value"] = "LeftAlt",
        ["Flag"] = "CursorKeybind",
        ["Callback"] = pz[11]
    };
    v82.Keybind(v82, pz[1]);
    pz[1] = {
        ["Title"] = "Player Attributes"
    };
    v84 = Ne.Section(Ne, pz[1]);
    pz[8] = false;
    pz[3] = "Toggle";
    pz[3] = v84[pz[3]];
    pz[12] = r16;
    pz[12] = function(arg1_68, ...)
        v24 = r28;
        v = arg1_68;
        v24.EnableWalkSpeed = v;
        if not v then
            M = r50.Character;
            if M and M.FindFirstChild(M, "Humanoid") then
                M.WalkSpeed = 16;
            end;
        end; 
    end;
    pz[4] = {
        ["Title"] = "Enable WalkSpeed",
        ["Value"] = pz[8],
        ["Flag"] = "EnableWalkSpeedToggle",
        ["Callback"] = pz[12]
    };
    pz[3] = pz[3](v84, pz[4]);
    pz[1][pz[2]] = pz[3];
    pz[3] = "Slider";
    pz[8] = 1;
    pz[12] = 16;
    pz[3] = v84[pz[3]];
    pz[14] = 300;
    pz[16] = 16;
    pz[10] = {
        ["Min"] = pz[12],
        ["Max"] = pz[14],
        ["Default"] = pz[16]
    };
    pz[14] = r16;
    pz[14] = function(arg1_69, ...)
        v24 = r28;
        M = arg1_69;
        v24.WalkSpeed = M;
        if r28.EnableWalkSpeed then
            M = r50.Character;
            if M and M.FindFirstChild(M, "Humanoid") then
                M.WalkSpeed = arg1_69;
            end;
        end; 
    end;
    pz[4] = {
        ["Title"] = "WalkSpeed",
        ["Step"] = pz[8],
        ["Value"] = pz[10],
        ["Flag"] = "WalkSpeedSlider",
        ["Callback"] = pz[14]
    };
    pz[3] = pz[3](v84, pz[4]);
    pz[1][pz[2]] = pz[3];
    pz[3] = "Toggle";
    pz[8] = false;
    pz[12] = r16;
    pz[12] = function(arg1_70, ...)
        v24 = r28;
        v = arg1_70;
        v24.EnableJumpPower = v;
        if not v then
            M = r50.Character;
            if M and M.FindFirstChild(M, "Humanoid") then
                M.JumpPower = 50;
            end;
        end; 
    end;
    pz[4] = {
        ["Title"] = "Enable JumpPower",
        ["Value"] = pz[8],
        ["Flag"] = "EnableJumpPowerToggle",
        ["Callback"] = pz[12]
    };
    pz[3] = v84[pz[3]];
    pz[3] = pz[3](v84, pz[4]);
    pz[1][pz[2]] = pz[3];
    pz[8] = 1;
    pz[12] = 50;
    pz[14] = 300;
    pz[16] = 50;
    pz[10] = {
        ["Min"] = pz[12],
        ["Max"] = pz[14],
        ["Default"] = pz[16]
    };
    pz[14] = r16;
    pz[14] = function(arg1_71, ...)
        v24 = r28;
        M = arg1_71;
        v24.JumpPower = M;
        if r28.EnableJumpPower then
            M = r50.Character;
            if M and M.FindFirstChild(M, "Humanoid") then
                M.JumpPower = arg1_71;
            end;
        end; 
    end;
    pz[3] = "Slider";
    pz[3] = v84[pz[3]];
    pz[4] = {
        ["Title"] = "JumpPower",
        ["Step"] = pz[8],
        ["Value"] = pz[10],
        ["Flag"] = "JumpPowerSlider",
        ["Callback"] = pz[14]
    };
    pz[3] = pz[3](v84, pz[4]);
    pz[1][pz[2]] = pz[3];
    pz[3] = "Toggle";
    pz[10] = false;
    pz[3] = v84[pz[3]];
    pz[14] = r16;
    pz[14] = function(arg1_72, ...)
        v24 = r28;
        v24.InfiniteJump = arg1_72; 
    end;
    pz[4] = {
        ["Title"] = "Infinite Jump",
        ["Desc"] = "Jump inside air",
        ["Value"] = pz[10],
        ["Flag"] = "InfJumpToggle",
        ["Callback"] = pz[14]
    };
    pz[3] = pz[3](v84, pz[4]);
    pz[1][pz[2]] = pz[3];
    pz[10] = false;
    pz[14] = r16;
    pz[3] = "Toggle";
    pz[3] = v84[pz[3]];
    pz[14] = function(arg1_73, ...)
        v24 = r28;
        v24.Noclip = arg1_73; 
    end;
    pz[4] = {
        ["Title"] = "Noclip",
        ["Desc"] = "Walk through walls",
        ["Value"] = pz[10],
        ["Flag"] = "NoclipToggle",
        ["Callback"] = pz[14]
    };
    pz[3] = pz[3](v84, pz[4]);
    pz[1][pz[2]] = pz[3];
    pz[1] = "Section";
    pz[1] = Ne[pz[1]];
    pz[2] = {
        ["Title"] = "Server Management"
    };
    pz[1] = pz[1](Ne, pz[2]);
    pz[4] = "Toggle";
    pz[4] = pz[1][pz[4]];
    pz[11] = true;
    pz[15] = r16;
    pz[15] = function(arg1_74, ...)
        v24 = r28;
        v = arg1_74;
        v24.AntiAFK = v;
        if v then
            v24 = game.Players.LocalPlayer;
            M = v24.WaitForChild(v24, "PlayerScripts");
            v24 = M.FindFirstChild(M, "LocalAntiAFK");
            if v24 then
                v24.Destroy(v24);
                warn("LocalAntiAFK destroyed");
                v24 = r26;
                v24.Notify(v24, {
                    ["Title"] = "System",
                    ["Content"] = "LocalAntiAFK destroyed",
                    ["Duration"] = 3
                });
            else
                v24 = r26;
                v24.Notify(v24, {
                    ["Title"] = "System",
                    ["Content"] = "LocalAntiAFK already deleted / Not found",
                    ["Duration"] = 2
                });
            end;
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "System",
                ["Content"] = "Anti-AFK Active",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[5] = {
        ["Title"] = "Anti-AFK",
        ["Desc"] = "Prevent 20 min kick",
        ["Value"] = pz[11],
        ["Flag"] = "AntiAFKToggle",
        ["Callback"] = pz[15]
    };
    pz[4] = pz[4](pz[1], pz[5]);
    pz[2][pz[3]] = pz[4];
    pz[11] = false;
    pz[4] = "Toggle";
    pz[15] = r16;
    pz[4] = pz[1][pz[4]];
    pz[15] = function(arg1_75, ...)
        v24 = r28;
        v24.AutoReconnect = arg1_75; 
    end;
    pz[5] = {
        ["Title"] = "Auto Reconnect",
        ["Desc"] = "Rejoin if kicked/disconnected",
        ["Value"] = pz[11],
        ["Flag"] = "AutoReconnectToggle",
        ["Callback"] = pz[15]
    };
    pz[4] = pz[4](pz[1], pz[5]);
    pz[2][pz[3]] = pz[4];
    pz[4] = "Toggle";
    pz[4] = pz[1][pz[4]];
    pz[11] = false;
    pz[15] = r16;
    pz[15] = function(arg1_76, ...)
        v24 = r28;
        v24.AntiStaff = arg1_76; 
    end;
    pz[5] = {
        ["Title"] = "Anti-Staff",
        ["Desc"] = "Hop server if staff/admin detected",
        ["Value"] = pz[11],
        ["Flag"] = "AntiStaffToggle",
        ["Callback"] = pz[15]
    };
    pz[4] = pz[4](pz[1], pz[5]);
    pz[2][pz[3]] = pz[4];
    pz[2] = "Button";
    pz[2] = pz[1][pz[2]];
    pz[11] = r16;
    pz[11] = function(...)
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Server Hop",
            ["Content"] = "Finding new server...",
            ["Duration"] = 3
        });
        v24 = game;
        v = v24.GetService(v24, "HttpService");
        v24 = game;
        M = v24.GetService(v24, "TeleportService");
        b = game;
        K = "data";
        v10 = v.JSONDecode(v, b.HttpGet(b, "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))[K];
        v2 = K[2];
        v10 = K[1];
        for v3, v4 in ipairs(v10) do
            K = v3;
            if v4.playing ~= v4.maxPlayers and v4.id ~= game.JobId then
                M.TeleportToPlaceInstance(M, game.PlaceId, v4.id, r50);
                return;
            end; 
        end;
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Failed",
            ["Content"] = "No valid server found try again later.",
            ["Duration"] = 2
        }); 
    end;
    pz[3] = {
        ["Title"] = "Server Hop",
        ["Desc"] = "Find different server",
        ["Icon"] = "globe",
        ["Callback"] = pz[11]
    };
    pz[2] = pz[2](pz[1], pz[3]);
    pz[2] = "Button";
    pz[2] = pz[1][pz[2]];
    pz[11] = r16;
    pz[11] = function(...)
        v24 = game;
        v = v24.GetService(v24, "TeleportService");
        v.TeleportToPlaceInstance(v, game.PlaceId, game.JobId, r50); 
    end;
    pz[3] = {
        ["Title"] = "Rejoin Server",
        ["Desc"] = "Rejoin this same server",
        ["Icon"] = "rotate-cw",
        ["Callback"] = pz[11]
    };
    pz[2] = pz[2](pz[1], pz[3]);
    pz[2] = r81;
    pz[3] = "Tab";
    pz[3] = pz[2][pz[3]];
    pz[4] = {
        ["Title"] = "Webhook",
        ["Icon"] = "bell"
    };
    pz[3] = pz[3](pz[2], pz[4]);
    pz[2] = "Section";
    pz[2] = pz[3][pz[2]];
    pz[4] = {
        ["Title"] = "Settings"
    };
    pz[2] = pz[2](pz[3], pz[4]);
    pz[4] = "Input";
    pz[4] = pz[2][pz[4]];
    pz[13] = r16;
    pz[13] = function(arg1_77, ...)
        v24 = r28;
        v24.WebhookURL = arg1_77; 
    end;
    pz[5] = {
        ["Title"] = "Webhook URL",
        ["Placeholder"] = "https://discord.com/api/webhooks/...",
        ["Flag"] = "WebhookURLInput",
        ["Callback"] = pz[13]
    };
    pz[4] = pz[4](pz[2], pz[5]);
    pz[6] = "Toggle";
    pz[13] = false;
    pz[6] = pz[2][pz[6]];
    pz[17] = r16;
    pz[17] = function(arg1_78, ...)
        v24 = r28;
        v24.WebhookEnabled = arg1_78; 
    end;
    pz[7] = {
        ["Title"] = "Enable Webhook",
        ["Desc"] = "Master switch",
        ["Value"] = pz[13],
        ["Flag"] = "WebhookToggle",
        ["Callback"] = pz[17]
    };
    pz[6] = pz[6](pz[2], pz[7]);
    pz[4][pz[5]] = pz[6];
    pz[4] = "Section";
    pz[5] = {
        ["Title"] = "Catch Notification"
    };
    pz[4] = pz[3][pz[4]];
    pz[4] = pz[4](pz[3], pz[5]);
    pz[12] = true;
    pz[15] = {};
    pz[17] = true;
    pz[7] = "Dropdown";
    pz[7] = pz[4][pz[7]];
    pz[21] = r16;
    pz[21] = function(arg1_79, ...)
        v = arg1_79;
        if type(v) == "table" then
            O = v2[3];
            v1 = v2[2];
            v2 = "pairs";
            for O, v10 in pairs(v) do
                K = r64[v10];
                if K then
                    table.insert({}, K);
                end; 
            end;
        end;
        v24 = r28;
        v24.WebhookWhitelist = {}; 
    end;
    pz[8] = {
        ["Title"] = "Whitelist Fish",
        ["Multi"] = pz[12],
        ["Values"] = v31,
        ["Value"] = pz[15],
        ["SearchBarEnabled"] = pz[17],
        ["Flag"] = "WebhookWhitelistDropdown",
        ["Callback"] = pz[21]
    };
    pz[7] = pz[7](pz[4], pz[8]);
    pz[5][pz[6]] = pz[7];
    pz[5] = "Section";
    pz[5] = pz[3][pz[5]];
    pz[6] = {
        ["Title"] = "Inventory Stats"
    };
    pz[5] = pz[5](pz[3], pz[6]);
    pz[15] = false;
    pz[19] = r16;
    pz[19] = function(arg1_80, ...)
        v24 = r28;
        v24.WebhookAutoStats = arg1_80; 
    end;
    pz[9] = {
        ["Title"] = "Auto Send Stats",
        ["Desc"] = "Send inventory summary periodically",
        ["Value"] = pz[15],
        ["Flag"] = "WebhookAutoStatsToggle",
        ["Callback"] = pz[19]
    };
    pz[8] = "Toggle";
    pz[8] = pz[5][pz[8]];
    pz[8] = pz[8](pz[5], pz[9]);
    pz[6][pz[7]] = pz[8];
    pz[13] = 1;
    pz[17] = 1;
    pz[19] = 60;
    pz[21] = 10;
    pz[15] = {
        ["Min"] = pz[17],
        ["Max"] = pz[19],
        ["Default"] = pz[21]
    };
    pz[19] = r16;
    pz[8] = "Slider";
    pz[8] = pz[5][pz[8]];
    pz[19] = function(arg1_81, ...)
        v24 = r28;
        v24.WebhookInterval = arg1_81; 
    end;
    pz[9] = {
        ["Title"] = "Interval (Minutes)",
        ["Step"] = pz[13],
        ["Value"] = pz[15],
        ["Flag"] = "WebhookIntervalSlider",
        ["Callback"] = pz[19]
    };
    pz[8] = pz[8](pz[5], pz[9]);
    pz[6][pz[7]] = pz[8];
    pz[7] = "WebhookMaxListSlider";
    pz[8] = "Slider";
    pz[15] = 1;
    pz[19] = 5;
    pz[21] = 50;
    pz[23] = 20;
    pz[17] = {
        ["Min"] = pz[19],
        ["Max"] = pz[21],
        ["Default"] = pz[23]
    };
    pz[21] = r16;
    pz[8] = pz[5][pz[8]];
    pz[21] = function(arg1_82, ...)
        v24 = r28;
        v24.WebhookMaxList = arg1_82; 
    end;
    pz[9] = {
        ["Title"] = "Max Lines",
        ["Desc"] = "Limit inventory list length",
        ["Step"] = pz[15],
        ["Value"] = pz[17],
        ["Flag"] = "WebhookMaxListSlider",
        ["Callback"] = pz[21]
    };
    pz[8] = pz[8](pz[5], pz[9]);
    pz[6][pz[7]] = pz[8];
    pz[7] = function(arg1_83, ...)
        v = arg1_83;
        O = "";
        if r28.WebhookURL == O or not r39 then
            return;
        end;
        M = O[2];
        O = O[1];
        for v1, v3 in ipairs(v) do
            v2 = v1;
            if not "author" then
                v3.author = {
                    ["name"] = r50.DisplayName .. " (@" .. r50.Name .. ")",
                    ["icon_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. r50.UserId .. "&width=420&height=420&format=png"
                };
            end; 
        end;
        v4 = game;
        H = v4.GetService(v4, "HttpService");
        r39({
            ["Url"] = r28.WebhookURL,
            ["Body"] = H.JSONEncode(H, {
                ["embeds"] = v,
                ["username"] = "Jumantara Hub",
                ["avatar_url"] = "https://scriptblox.com/images/photo/693e0b819b445894f4da29d4-1768098570792.png"
            }),
            ["Method"] = "POST",
            ["Headers"] = {
                ["Content-Type"] = "application/json"
            }
        }); 
    end;
    pz[6] = 123;
    W[pz[6]] = pz[7];
    pz[12] = r16;
    pz[7] = "Button";
    pz[7] = pz[5][pz[7]];
    pz[12] = function(...)
        v24 = r50;
        v1 = r15;
        v = v24.FindFirstChild(v24, "PlayerGui");
        M = v and v.FindFirstChild(v, "Data");
        if M then
            v1 = {};
            K = M.GetChildren;
            v10 = {
                K(M)
            };
            v10 = K[1];
            v2 = K[2];
            for v3, v4 in pairs(l(v10)) do
                K = v3;
                H = v4.GetAttribute(v4, "ID") or v4.Name;
                v24 = r58[H];
                c = v24;
                k = v24;
                if k then
                    s = k.Name;
                end;
                v24 = 1;
                I = k and 0 + 1;
                c = v24;
                s = (v1[H] or 0) + 1;
                v1[H] = s;
                O = 0 + 1; 
            end;
            v2 = {};
            v4 = (8)[3];
            for v4, H in (8)[1], pairs(v1) do
                table.insert(v2, {
                    ["Name"] = v4,
                    ["Count"] = H
                }); 
            end;
            table.sort(v2, function(arg1_84, arg2_84, ...)
                return arg1_84.Count > arg2_84.Count; 
            end);
            H = (5724765702761)[3];
            for H, k in (5724765702761)[1], ipairs(v2) do
                if H > r28.WebhookMaxList then
                    v3 = r16[v4] .. "\n... and " .. #{} - r28.WebhookMaxList .. " more";
                else
                    v3 = r16[v4] .. "\n**" .. k.Name .. "**: " .. k.Count;
                end; 
            end;
            W[pz[6]]({
                {
                    ["title"] = "🎒 Inventory Stats",
                    ["description"] = "Total Fish: **" .. 0 .. "**\n" .. "",
                    ["color"] = 65280,
                    ["footer"] = {
                        ["text"] = os.date("%X")
                    }
                }
            });
            v10 = r26;
            v10.Notify(v10, {
                ["Title"] = "Webhook",
                ["Content"] = "Stats Sent!",
                ["Duration"] = 2
            });
        else
            v1 = r26;
            v1.Notify(v1, {
                ["Title"] = "Error",
                ["Content"] = "Inventory not found!",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[8] = {
        ["Title"] = "Send Stats Now",
        ["Callback"] = pz[12]
    };
    pz[7] = pz[7](pz[5], pz[8]);
    pz[7] = "Button";
    pz[7] = pz[5][pz[7]];
    pz[12] = r16;
    pz[12] = function(...)
        v24 = r28.WebhookURL == "";
        if v24 then
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Error",
                ["Content"] = "Set URL first!",
                ["Duration"] = 2
            });
            return;
        end;
        W[pz[6]]({
            {
                ["title"] = "Test Message",
                ["description"] = "Webhook is working!",
                ["color"] = 16776960
            }
        });
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Webhook",
            ["Content"] = "Test Sent!",
            ["Duration"] = 2
        }); 
    end;
    pz[8] = {
        ["Title"] = "Test Webhook",
        ["Callback"] = pz[12]
    };
    pz[7] = pz[7](pz[5], pz[8]);
    pz[7] = {};
    pz[8] = 124;
    W[pz[8]] = pz[7];
    pz[7] = function(...)
        v24 = W[pz[8]].Catch;
        if v24 then
            v24 = W[pz[8]].Catch;
            v24.Disconnect(v24);
        end;
        v24 = r50;
        v = v24.FindFirstChild(v24, "PlayerGui");
        v24 = v.WaitForChild(v, "Data");
        v1 = 5;
        M = v24.WaitForChild(v24, "Fish", v1);
        if M then
            v24 = W[pz[8]];
            v1 = "ChildAdded";
            v24.Catch = v1.Connect(v1, function(arg1_85, ...)
                v = arg1_85;
                if not r28.WebhookEnabled then
                    return;
                end;
                task.wait(0.5);
                M = v.GetAttribute(v, "ID") or v.Name;
                v24 = r58[M];
                if v24 then
                    O = v24.Name;
                end;
                v24 = v24;
                b = v24;
                if v24 then
                    O = O;
                    k = r28;
                    v4 = k[3];
                    for v4, k in k[1], pairs(k.WebhookWhitelist) do
                        H = v4;
                        if k == (v.GetAttribute(v, r16[v3]) or v.Name) then
                            v3 = true;
                        end; 
                    end;
                    if false then
                        W[pz[6]]({
                            {
                                ["title"] = "🎣 Fish Caught!",
                                ["fields"] = {
                                    {
                                        ["name"] = "Fish",
                                        ["value"] = O,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Weight",
                                        ["value"] = string.format("%.1f kg", v.GetAttribute(v, "Weight") or 0),
                                        ["inline"] = true
                                    }
                                },
                                ["color"] = 5814783
                            }
                        });
                    end;
                    return;
                else
                    b = v.GetAttribute(v, r16[v3]) or v.Name;
                end; 
            end);
        end; 
    end;
    pz[11] = "task";
    pz[10] = Env[pz[11]];
    pz[9] = pz[10].spawn;
    pz[11] = "task";
    pz[10] = pz[9](pz[7]);
    pz[10] = Env[pz[11]];
    pz[11] = "spawn";
    pz[9] = pz[10].spawn;
    pz[11] = function(...)
        while true do
            v = r28.WebhookEnabled;
            if v and r28.WebhookAutoStats then
                v24 = r50;
                v = v24.FindFirstChild(v24, "PlayerGui");
                if v and v.FindFirstChild(v, "Data") then
                    K = M.GetChildren;
                    v1 = {};
                    v10 = {
                        K(M)
                    };
                    v3 = K[3];
                    v2 = K[2];
                    for v3, v4 in pairs(l(b)) do
                        K = v3;
                        H = v4.GetAttribute(v4, "ID") or v4.Name;
                        v24 = r58[H];
                        I = v24 and v24.Name;
                        v24 = v24;
                        if v24 then
                            c = v24;
                            s = (v1[I] or 0) + 1;
                            v1[I] = s;
                            O = 0 + 1;
                        else
                            I = v4.GetAttribute(v4, r16[A]) or v4.Name;
                        end; 
                    end;
                    v2 = {};
                    v10 = H[1];
                    K = H[2];
                    for v4, H in pairs(v1) do
                        table.insert(v2, {
                            ["Name"] = v4,
                            ["Count"] = H
                        }); 
                    end;
                    table.sort(v2, function(arg1_86, arg2_86, ...)
                        return arg1_86.Count > arg2_86.Count; 
                    end);
                    H = (2431087936620)[3];
                    for H, k in (2431087936620)[1], ipairs(v2) do
                        if H > r28.WebhookMaxList then
                            v3 = r16[v4] .. "\n... and " .. #{} - r28.WebhookMaxList .. " more";
                        else
                            v3 = r16[v4] .. "\n**" .. k.Name .. "**: " .. k.Count;
                        end; 
                    end;
                    W[pz[6]]({
                        {
                            ["title"] = "🎒 Auto Stats",
                            ["description"] = "Total: **" .. 0 .. "**\n" .. "",
                            ["color"] = 65280,
                            ["footer"] = {
                                ["text"] = os.date("%X")
                            }
                        }
                    });
                    task.wait(r28.WebhookInterval * 60);
                end;
            end; 
        end; 
    end;
    pz[10] = pz[9](pz[11]);
    pz[9] = r81;
    pz[10] = "Tab";
    pz[10] = pz[9][pz[10]];
    pz[11] = {
        ["Title"] = "Teleport",
        ["Icon"] = "map-pin"
    };
    pz[10] = pz[10](pz[9], pz[11]);
    pz[9] = "Section";
    pz[9] = pz[10][pz[9]];
    pz[14] = r16;
    pz[11] = {
        ["Title"] = "NPC Navigator"
    };
    pz[9] = pz[9](pz[10], pz[11]);
    pz[11] = nil;
    pz[12] = 125;
    W[pz[12]] = pz[11];
    pz[11] = {};
    pz[13] = 126;
    pz[14] = function(...)
        v = {};
        table.clear(W[pz[13]]);
        M = {
            workspace
        };
        v24 = workspace;
        v1 = v24.FindFirstChild(v24, "WorldNpc");
        if v1 then
            table.insert(M, v1);
        end;
        v24 = workspace;
        if v24.FindFirstChild(v24, "NPCs") then
            table.insert(M, workspace.NPCs);
        end;
        v24 = workspace;
        v3 = r15;
        if v24.FindFirstChild(v24, "Merchants") then
            table.insert(M, workspace.Merchants);
        end;
        O = v3[2];
        v3 = v3[1];
        for v2, K in pairs(M) do
            v10 = v2;
            s = K.GetChildren;
            k = s[3];
            H = s[2];
            for k, s in pairs(s(K)) do
                I = k;
                if s.IsA(s, "Model") and (s.FindFirstChild(s, "HumanoidRootPart") and s.FindFirstChild(s, "Humanoid")) then
                    if "Name" ~= r50.Name then
                        c = "Name";
                        if ("Humanoid").DisplayName ~= "" then
                            c = ("Humanoid").DisplayName;
                        end;
                        d = 2;
                        while W[pz[13]][c] do
                            d = 2 + 1;
                            c = c .. " (" .. 2 .. ")"; 
                        end;
                        table.insert({}, c);
                        F = W[pz[13]];
                        F[c] = "HumanoidRootPart";
                    end;
                end; 
            end; 
        end;
        table.sort(v);
        return v; 
    end;
    W[pz[13]] = pz[11];
    pz[11] = 127;
    W[pz[11]] = pz[14];
    pz[19] = false;
    pz[22] = r15;
    pz[21] = W[pz[11]];
    pz[22] = pz[21]();
    pz[14] = "Dropdown";
    pz[25] = r16;
    pz[23] = true;
    pz[14] = pz[9][pz[14]];
    pz[25] = function(arg1_87, ...)
        W[pz[12]] = arg1_87; 
    end;
    pz[15] = {
        ["Title"] = "Select NPC",
        ["Multi"] = pz[19],
        ["Values"] = pz[22],
        ["SearchBarEnabled"] = pz[23],
        ["Callback"] = pz[25]
    };
    pz[14] = pz[14](pz[9], pz[15]);
    pz[15] = 128;
    W[pz[15]] = pz[14];
    pz[14] = "Button";
    pz[14] = pz[9][pz[14]];
    pz[22] = r16;
    pz[22] = function(...)
        v = W[pz[11]]();
        v24 = W[pz[15]];
        v24.Refresh(v24, v, v[1]);
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "System",
            ["Content"] = "Found " .. #v .. " NPCs",
            ["Duration"] = 1.5
        }); 
    end;
    pz[16] = {
        ["Title"] = "Refresh List",
        ["Desc"] = "Click if NPC is missing",
        ["Callback"] = pz[22]
    };
    pz[14] = pz[14](pz[9], pz[16]);
    pz[14] = "Button";
    pz[20] = r16;
    pz[14] = pz[9][pz[14]];
    pz[20] = function(...)
        if W[pz[12]] and W[pz[13]][W[pz[12]]] then
            v24 = r50.Character;
            if v24 then
                b = v24.FindFirstChild(v24, "HumanoidRootPart");
            end;
            if v24 then
                v24 = v24.HumanoidRootPart;
                v24.CFrame = W[pz[13]][W[pz[12]]].CFrame * CFrame.new(0, 0, 3);
                v24 = r26;
                v24.Notify(v24, {
                    ["Title"] = "Teleport",
                    ["Content"] = "Warped to " .. W[pz[12]],
                    ["Duration"] = 2
                });
            else
                v24 = r26;
                v24.Notify(v24, {
                    ["Title"] = "Error",
                    ["Content"] = "Character not ready!",
                    ["Duration"] = 2
                });
            end;
        else
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Error",
                ["Content"] = "Please select an NPC first!",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[16] = {
        ["Title"] = "Teleport Now",
        ["Callback"] = pz[20]
    };
    pz[14] = pz[14](pz[9], pz[16]);
    pz[14] = r81;
    pz[16] = "Tab";
    pz[16] = pz[14][pz[16]];
    pz[23] = false;
    pz[17] = {
        ["Title"] = "Mission (OnTesting)",
        ["Icon"] = "target",
        ["Locked"] = pz[23]
    };
    pz[16] = pz[16](pz[14], pz[17]);
    pz[17] = {
        ["Title"] = "Automatic Mission"
    };
    pz[14] = "Section";
    pz[14] = pz[16][pz[14]];
    pz[14] = pz[14](pz[16], pz[17]);
    pz[22] = false;
    pz[23] = "Flag";
    pz[24] = "AutoMission";
    pz[26] = r16;
    pz[17] = "Toggle";
    pz[17] = pz[14][pz[17]];
    pz[25] = "Callback";
    pz[26] = function(arg1_88, ...)
        v24 = r28;
        v = arg1_88;
        v24.AutoMission = v;
        if v then
            r47 = r28.AutoFarm;
            r73();
        else
            b = not r46;
            if b then
                b = r28;
                b.AutoFarm = false;
                b = r28;
                b.UseRarityFilter = false;
                b = r28;
                b.FarmMode = "GetClosestFish";
                b = r26;
                b.Notify(b, {
                    ["Title"] = "Auto Mission",
                    ["Content"] = "Off - Settings Reset",
                    ["Duration"] = 2
                });
            end;
            return;
        end; 
    end;
    pz[18] = {
        ["Title"] = "Enable Auto Mission",
        ["Value"] = pz[22],
        ["Flag"] = "AutoMission",
        ["Callback"] = pz[26]
    };
    pz[17] = pz[17](pz[14], pz[18]);
    pz[17] = {};
    pz[19] = "pairs";
    pz[18] = Env[pz[19]];
    pz[22] = r60;
    pz[23] = {
        pz[18](pz[22])
    };
    pz[19] = pz[23][1];
    pz[21] = pz[23][3];
    pz[20] = pz[23][2];
    pz[21], pz[22] = pz[19](pz[20], pz[21]);
    while pz[21] do
        pz[18] = pz[21];
        pz[25] = "table";
        pz[24] = Env[pz[25]];
        pz[23] = pz[24].insert;
        pz[24] = pz[23](pz[17], pz[18]); 
    end;
    pz[20] = "table";
    pz[19] = Env[pz[20]];
    pz[18] = pz[19].sort;
    pz[19] = pz[18](pz[17]);
    pz[18] = "Dropdown";
    pz[23] = false;
    pz[18] = pz[14][pz[18]];
    pz[28] = true;
    pz[30] = r16;
    pz[30] = function(arg1_89, ...)
        v24 = r28;
        v = arg1_89;
        M = v;
        v24.SelectedMissionID = M;
        v24 = r28;
        v24.CurrentMissionStep = 1;
        UpdateMissionStepsDetail(v); 
    end;
    pz[19] = {
        ["Title"] = "Select Mission",
        ["Multi"] = pz[23],
        ["Values"] = pz[17],
        ["Value"] = "Mession1",
        ["SearchBarEnabled"] = pz[28],
        ["Callback"] = pz[30]
    };
    pz[18] = pz[18](pz[14], pz[19]);
    pz[18] = "Section";
    pz[19] = {
        ["Title"] = "Mission Info"
    };
    pz[18] = pz[16][pz[18]];
    pz[18] = pz[18](pz[16], pz[19]);
    pz[19] = "Paragraph";
    pz[19] = pz[18][pz[19]];
    pz[20] = {
        ["Title"] = "Active Mission Details",
        ["Desc"] = "Select a mission to see requirements and rewards."
    };
    pz[19] = pz[19](pz[18], pz[20]);
    pz[20] = 90;
    W[pz[20]] = pz[19];
    pz[19] = "Paragraph";
    pz[22] = "Title";
    pz[19] = pz[18][pz[19]];
    pz[21] = {
        ["Title"] = "Active Mission Details",
        ["Desc"] = "..."
    };
    pz[19] = pz[19](pz[18], pz[21]);
    pz[21] = 91;
    pz[22] = function(arg1_90, ...)
        v24 = W[pz[21]];
        if v24 then
            v24 = W[pz[21]];
            v24.SetDesc(v24, arg1_90);
        end; 
    end;
    W[pz[21]] = pz[19];
    pz[19] = 92;
    W[pz[19]] = pz[22];
    pz[22] = "Paragraph";
    pz[22] = pz[18][pz[22]];
    pz[23] = {
        ["Title"] = "Mission Steps",
        ["Desc"] = "Select a mission..."
    };
    pz[22] = pz[22](pz[18], pz[23]);
    pz[23] = 93;
    W[pz[23]] = pz[22];
    pz[24] = r81;
    pz[22] = function(arg1_91, ...)
        M = r60[arg1_91];
        if not M then
            return;
        end;
        for O = 1, 20 do
            v4 = "Count" .. O;
            if not M[v4] then
            else
                v4 = M["Condition" .. O];
                H = "Unknown";
                if v4 == "HarpoonFish" then
                    H = "Fish Rarity: " .. tostring(M["Rarity" .. O]);
                    v1 = v1 .. string.format("[%d] %s (x%d)\n", O, H, M["Count" .. O]);
                end;
                s = r16;
                I = "HarpoonRequiredFish";
                if v4 == I then
                    c = v24;
                    I = r60[v]["RequiredID" .. O];
                    s = r58[I];
                    b = s and s.Name;
                    v24 = v24;
                    if s then
                        v24 = v24;
                        H = "Hunt: " .. (A and "Name");
                    else
                        b = M[r16[r15(u, J)] .. K];
                    end;
                else
                    c = v4 == "VisitLocation";
                    v24 = v4 == "HarpoonFish";
                    if c or v4 == "Visit" then
                        H = "Go to Location";
                    else
                        c = v4 == "BuyItem" or v4 == "Buy";
                        v24 = v4 == "BuyItem" or v4 == "Buy";
                        if v4 == "BuyItem" or v4 == "Buy" then
                            H = "Buy Item";
                        end;
                    end;
                end;
            end; 
        end;
        v24 = W[pz[23]];
        if v24 then
            v24 = W[pz[23]];
            v24.SetDesc(v24, "");
        end; 
    end;
    pz[25] = "Tab";
    pz[25] = pz[24][pz[25]];
    pz[26] = {
        ["Title"] = "Config",
        ["Icon"] = "save"
    };
    pz[25] = pz[25](pz[24], pz[26]);
    pz[26] = r81;
    pz[24] = pz[26].ConfigManager;
    pz[26] = 94;
    W[pz[26]] = pz[24];
    pz[27] = 95;
    W[pz[27]] = "";
    pz[24] = nil;
    pz[28] = 96;
    W[pz[28]] = pz[24];
    pz[24] = "Section";
    pz[24] = pz[25][pz[24]];
    pz[29] = {
        ["Title"] = "Create New"
    };
    pz[24] = pz[24](pz[25], pz[29]);
    pz[29] = "Input";
    pz[29] = pz[24][pz[29]];
    pz[38] = r16;
    pz[38] = function(arg1_92, ...)
        W[pz[27]] = arg1_92; 
    end;
    pz[30] = {
        ["Title"] = "Config Name",
        ["Value"] = "",
        ["Placeholder"] = "Enter config name...",
        ["Callback"] = pz[38]
    };
    pz[29] = pz[29](pz[24], pz[30]);
    pz[29] = "Button";
    pz[29] = pz[24][pz[29]];
    pz[38] = r16;
    pz[38] = function(...)
        v24 = W[pz[27]] ~= "";
        if v24 then
            v24 = W[pz[26]];
            b = v24.Config(v24, W[pz[27]]);
            b.Save(b);
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Config",
                ["Content"] = "Created: " .. W[pz[27]],
                ["Duration"] = 2
            });
        else
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Error",
                ["Content"] = "Enter a name first!",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[30] = {
        ["Title"] = "Create Config",
        ["Icon"] = "plus-circle",
        ["Justify"] = "Center",
        ["Callback"] = pz[38]
    };
    pz[29] = pz[29](pz[24], pz[30]);
    pz[29] = "Space";
    pz[29] = pz[25][pz[29]];
    pz[29] = pz[29](pz[25]);
    pz[29] = "Section";
    pz[29] = pz[25][pz[29]];
    pz[30] = {
        ["Title"] = "Manage Existing"
    };
    pz[29] = pz[29](pz[25], pz[30]);
    pz[30] = "Paragraph";
    pz[30] = pz[29][pz[30]];
    pz[36] = r15;
    pz[35] = r70;
    pz[36] = pz[35]();
    pz[31] = {
        ["Title"] = "Current Auto Load:",
        ["Desc"] = pz[36]
    };
    pz[30] = pz[30](pz[29], pz[31]);
    pz[31] = 97;
    W[pz[31]] = pz[30];
    pz[30] = "Dropdown";
    pz[37] = "AllConfigs";
    pz[36] = W[pz[26]];
    pz[37] = pz[36][pz[37]];
    pz[37] = pz[37](pz[36]);
    pz[38] = nil;
    pz[30] = pz[29][pz[30]];
    pz[40] = true;
    pz[44] = r16;
    pz[42] = true;
    pz[44] = function(arg1_93, ...)
        v = arg1_93;
        W[pz[28]] = v;
        if v then
            b = r81;
            v1 = W[pz[26]];
            b.CurrentConfig = v1.Config(v1, v);
        end; 
    end;
    pz[32] = {
        ["Title"] = "Select Config",
        ["Values"] = pz[37],
        ["Value"] = pz[38],
        ["AllowNone"] = pz[40],
        ["SearchBarEnabled"] = pz[42],
        ["Callback"] = pz[44]
    };
    pz[30] = pz[30](pz[29], pz[32]);
    pz[32] = 98;
    W[pz[32]] = pz[30];
    pz[43] = r16;
    pz[43] = function(...)
        v24 = W[pz[28]];
        if v24 then
            r71(W[pz[28]]);
            v24 = W[pz[31]];
            v24.SetDesc(v24, W[pz[28]]);
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Success",
                ["Content"] = "Auto Load set to: " .. W[pz[28]],
                ["Duration"] = 2
            });
        else
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Error",
                ["Content"] = "Select a config first!",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[30] = "Button";
    pz[33] = {
        ["Title"] = "Set as Auto Load",
        ["Desc"] = "Selected config will load on startup",
        ["Icon"] = "zap",
        ["Justify"] = "Center",
        ["Callback"] = pz[43]
    };
    pz[30] = pz[29][pz[30]];
    pz[30] = pz[30](pz[29], pz[33]);
    pz[30] = "Button";
    pz[30] = pz[29][pz[30]];
    pz[41] = r16;
    pz[41] = function(...)
        v24 = r81.CurrentConfig;
        if v24 then
            v24 = r81.CurrentConfig;
            v24.Load(v24);
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Config",
                ["Content"] = "Loaded successfully!",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[33] = {
        ["Title"] = "Load Selected",
        ["Icon"] = "download",
        ["Justify"] = "Center",
        ["Callback"] = pz[41]
    };
    pz[30] = pz[30](pz[29], pz[33]);
    pz[30] = "Button";
    pz[30] = pz[29][pz[30]];
    pz[41] = r16;
    pz[41] = function(...)
        v24 = r81.CurrentConfig;
        if v24 then
            v24 = r81.CurrentConfig;
            v24.Save(v24);
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Config",
                ["Content"] = "Saved successfully!",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[33] = {
        ["Title"] = "Save Selected",
        ["Icon"] = "save",
        ["Justify"] = "Center",
        ["Callback"] = pz[41]
    };
    pz[30] = pz[30](pz[29], pz[33]);
    pz[30] = "Button";
    pz[30] = pz[29][pz[30]];
    pz[41] = r16;
    pz[41] = function(...)
        v24 = W[pz[32]];
        v = W[pz[26]];
        v24.Refresh(v24, v.AllConfigs(v));
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "System",
            ["Content"] = "List refreshed",
            ["Duration"] = 1
        }); 
    end;
    pz[33] = {
        ["Title"] = "Refresh List",
        ["Icon"] = "refresh-cw",
        ["Justify"] = "Center",
        ["Callback"] = pz[41]
    };
    pz[30] = pz[30](pz[29], pz[33]);
    pz[30] = "Button";
    pz[30] = pz[29][pz[30]];
    pz[43] = r16;
    pz[43] = function(...)
        r71("None");
        v24 = W[pz[31]];
        v24.SetDesc(v24, "None");
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "System",
            ["Content"] = "Auto Load disabled",
            ["Duration"] = 2
        }); 
    end;
    pz[33] = {
        ["Title"] = "Reset Auto Load",
        ["Desc"] = "Disable Auto Load",
        ["Icon"] = "x-circle",
        ["Justify"] = "Center",
        ["Callback"] = pz[43]
    };
    pz[30] = pz[30](pz[29], pz[33]);
    pz[30] = "Button";
    pz[43] = r16;
    pz[30] = pz[29][pz[30]];
    pz[43] = function(...)
        v = "CurrentConfig";
        v24 = r81[v];
        if v24 then
            v24 = r81.CurrentConfig;
            v24.Delete(v24);
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Config",
                ["Content"] = "Config deleted successfully!",
                ["Duration"] = 2
            });
            v24 = W[pz[32]];
            v = W[pz[26]];
            v24.Refresh(v24, v.AllConfigs(v));
        else
            v24 = r26;
            v24.Notify(v24, {
                ["Title"] = "Config",
                ["Content"] = "No config selected to delete!",
                ["Duration"] = 2
            });
        end; 
    end;
    pz[33] = {
        ["Title"] = "Delete Selected Config",
        ["Desc"] = "Delete the currently selected config",
        ["Icon"] = "trash-2",
        ["Justify"] = "Center",
        ["Callback"] = pz[43]
    };
    pz[30] = pz[30](pz[29], pz[33]);
    pz[30] = "Section";
    pz[33] = {
        ["Title"] = "Share Configuration"
    };
    pz[30] = pz[25][pz[30]];
    pz[30] = pz[30](pz[25], pz[33]);
    pz[40] = r16;
    pz[40] = function(...)
        r82(); 
    end;
    pz[33] = "Button";
    pz[33] = pz[30][pz[33]];
    pz[34] = {
        ["Title"] = "Copy Config",
        ["Desc"] = "Serialize your configuration to the clipboard",
        ["Callback"] = pz[40]
    };
    pz[33] = pz[33](pz[30], pz[34]);
    pz[42] = r16;
    pz[33] = "Input";
    pz[42] = function(arg1_94, ...)
        r45 = arg1_94; 
    end;
    pz[33] = pz[30][pz[33]];
    pz[34] = {
        ["Title"] = "Import Config",
        ["Desc"] = "Paste a JSON configuration string here",
        ["Placeholder"] = "{}",
        ["Callback"] = pz[42]
    };
    pz[33] = pz[33](pz[30], pz[34]);
    pz[40] = r16;
    pz[33] = "Button";
    pz[40] = function(...)
        r84(r45); 
    end;
    pz[34] = {
        ["Title"] = "Load Config",
        ["Desc"] = "Load and apply the pasted configuration",
        ["Callback"] = pz[40]
    };
    pz[35] = "task";
    pz[33] = pz[30][pz[33]];
    pz[33] = pz[33](pz[30], pz[34]);
    pz[34] = Env[pz[35]];
    pz[36] = r16;
    pz[37] = r15;
    pz[35] = "spawn";
    pz[37] = function(...)
        v = tick();
        local function O(arg1_95, ...)
            if #r28.SelectedPoints == 0 then
                return true;
            end;
            v2 = r28;
            O = v2.SelectedPoints;
            M = v2[2];
            O = v2[1];
            for v1, v3 in pairs(O) do
                v2 = v1;
                if r30[v3] == arg1_95 then
                    return true;
                end; 
            end;
            return false; 
        end;
        v10 = r29;
        v2 = (6)[2];
        v3 = (6)[3];
        for v3, v4 in ipairs(b) do
            if not r42[v4.Name] then
                if (function(arg1_96, ...)
                    if #r28.SelectedPoints == 0 then
                        return true;
                    end;
                    v2 = r28;
                    O = v2.SelectedPoints;
                    M = v2[2];
                    O = v2[1];
                    for v1, v3 in pairs(O) do
                        v2 = v1;
                        if r30[v3] == arg1_96 then
                            return true;
                        end; 
                    end;
                    return false; 
                end)(v4.Name) then
                    return v4, "Scanning";
                end;
            end; 
        end;
        v24 = pairs;
        v10 = v4[3];
        for v10, v4 in v4[1], v24(r42) do
            k = pairs;
            v24 = v - (v4.LastScan or 0);
            s = v24;
            if O(v10) then
                if (v4.RemainTime or 9999) - v24 <= 0 then
                    return {
                        ["Name"] = v10,
                        ["CFrame"] = CFrame.new(v4.Position)
                    }, "Attacking";
                end;
            end; 
        end;
        v4 = r42;
        K = (8)[3];
        for K, v4 in (8)[1], pairs(v4) do
            s = v24;
            k = (v4.RemainTime or 9999) - (v - (v4.LastScan or 0));
            if O(K) then
                v24 = v24;
                if k > 0 and k < 999999 then
                    v1 = (c or A) - H;
                    M = {
                        ["Name"] = K,
                        ["CFrame"] = CFrame.new(v4.Position)
                    };
                end;
            end; 
        end;
        if r28.FarmSpot then
            if not nil then
                v2 = r26;
                v2.Notify(v2, {
                    ["Title"] = "Smart Boss",
                    ["Content"] = "No Bosses Active. Going to Farm Spot.",
                    ["Duration"] = 2
                });
                print("[Smart Boss] No Bosses Active. Going to Farm Spot.");
                return {
                    ["Name"] = "Farm Spot",
                    ["CFrame"] = CFrame.new(unpack(r28.FarmSpot))
                }, "Farming Spot";
            end;
            if 999999 > 10 then
                v2 = r26;
                v2.Notify(v2, {
                    ["Title"] = "Smart Boss",
                    ["Content"] = "Next Boss in " .. math.floor(999999) .. "s. Farming...",
                    ["Duration"] = 2
                });
                print("[Smart Boss] Next Boss in " .. math.floor(999999) .. "s. Farming...");
                return {
                    ["Name"] = "Farm Spot",
                    ["CFrame"] = CFrame.new(unpack(r28.FarmSpot))
                }, "Farming Spot";
            end;
        end;
        return nil, "Waiting"; 
    end;
    pz[40] = "task";
    pz[33] = pz[34].spawn;
    pz[35] = function(...)
        while true do
            v24 = r60[r28.SelectedMissionID];
            if v24 then
                v24 = W[pz[20]];
                v24.SetTitle(v24, v24.Title);
                v24 = W[pz[20]];
                v24.SetDesc(v24, "Reward: " .. tostring(v24.ThingId) .. " (x" .. tostring(v24.ThingCount) .. ")");
            end;
            task.wait(2); 
        end; 
    end;
    pz[34] = pz[33](pz[35]);
    pz[34] = function(...)
        v24 = workspace;
        v = v24.FindFirstChild(v24, "WorldBoss");
        if not v then
            return nil;
        end;
        v2 = v.GetChildren;
        O = {
            v2(v)
        };
        v1 = v2[3];
        O = v2[1];
        for v1, v3 in O, pairs(l(O)) do
            v2 = v1;
            if string.find("Name", "Point") then
                if v3.GetAttribute(v3, "RemainTime") == 0 then
                    I = v3.GetChildren;
                    H = I[3];
                    for H, I in I[1], pairs(I(v3)) do
                        k = H;
                        if string.find("Name", "Boss") then
                            s = I.FindFirstChild(I, "Model");
                            c = I.GetAttribute(I, "CurHP");
                            d = s;
                            A = I.GetAttribute(I, "HP");
                            if s then
                                if c then
                                    u = I.GetAttribute(I, "CurHP") > 0;
                                end;
                                I.GetAttribute(I, r16[J]);
                                d = c;
                            end;
                            if d then
                                d = s.FindFirstChild(s, "Root");
                                if d then
                                    BossName = "Name";
                                    return {
                                        ["Point"] = v3,
                                        ["Boss"] = I,
                                        ["Model"] = I.FindFirstChild(I, "Model"),
                                        ["TargetPart"] = d,
                                        ["CurHP"] = I.GetAttribute(I, "CurHP"),
                                        ["MaxHP"] = A,
                                        ["Position"] = d.Position,
                                        ["Name"] = "Name"
                                    };
                                end;
                            end;
                        end; 
                    end;
                end;
            end; 
        end;
        return nil; 
    end;
    pz[35] = function(...)
        v24 = workspace;
        v = v24.FindFirstChild(v24, "WorldBoss");
        if not v then
            return {};
        end;
        M = {};
        tick();
        v10 = v.GetChildren;
        v3 = {
            v10(v)
        };
        v3 = v10[1];
        O = v10[2];
        for v2, K in pairs(l(v3)) do
            v10 = v2;
            if string.find(K.Name, "Point") then
                k = v24;
                k = K.GetAttribute(K, "NextBossId") or "Unknown";
                v24 = v24;
                I = K.Position;
                F = K.GetChildren;
                J = {
                    F(K)
                };
                A = F[1];
                d = F[2];
                for u, J in pairs(l(J)) do
                    c = u;
                    F = J.GetAttribute(J, "CurHP");
                    J.GetAttribute(J, "HP");
                    if F then
                        x = F > 0;
                    end;
                    v24 = v24;
                    if F then
                        s = J;
                        if (K.GetAttribute(K, "NextBossId") or "Unknown") == "Unknown" then
                            k = J.Name;
                        end;
                    end; 
                end;
                A = 999999;
                Q = r29;
                u = (15)[1];
                J = (15)[2];
                for F, Q in ipairs(Q) do
                    d = F;
                    e = (Q.CFrame.Position - I).Magnitude;
                    if e < 800 then
                        if e < 999999 then
                            A = (Q.CFrame[r16[r15(Re, i)]] - I)[G[h]];
                            c = Q.Name;
                        end;
                    end; 
                end;
                u = v24;
                d = r42[nil] or r42[K.Name];
                J = u;
                v24 = J;
                if k == "Unknown" and d then
                    k = d.NextBossId;
                end;
                J = {
                    ["PointName"] = K.Name,
                    ["Point"] = K,
                    ["HasBoss"] = K.GetAttribute(K, "HasBoss") or false,
                    ["RemainTime"] = K.GetAttribute(K, "RemainTime") or 9999,
                    ["NextBossId"] = k,
                    ["Position"] = I,
                    ["ActiveBoss"] = nil,
                    ["LastScan"] = tick()
                };
                e = "insert";
                Q = table[e]({}, J);
                if nil then
                    Q = {
                        ["PointName"] = K.Name,
                        ["Point"] = K,
                        ["HasBoss"] = v4,
                        ["RemainTime"] = H,
                        ["NextBossId"] = k,
                        ["Position"] = I,
                        ["ActiveBoss"] = s,
                        [Re] = v1
                    };
                    F = r42;
                    F[nil] = Q;
                else
                    F = r42;
                    e = {
                        ["PointName"] = K.Name,
                        ["Point"] = K,
                        ["HasBoss"] = v4,
                        ["RemainTime"] = H,
                        ["NextBossId"] = k,
                        ["Position"] = I,
                        ["ActiveBoss"] = s,
                        [Re] = v1
                    };
                    F[K.Name] = e;
                end;
                if nil then
                    Q = {
                        ["PointName"] = K.Name,
                        ["Point"] = K,
                        ["HasBoss"] = v4,
                        ["RemainTime"] = H,
                        ["NextBossId"] = k,
                        ["Position"] = I,
                        ["ActiveBoss"] = s,
                        [Re] = v1
                    };
                    F = r42;
                    F[nil] = Q;
                else
                    F = r42;
                    e = {
                        ["PointName"] = K.Name,
                        ["Point"] = K,
                        ["HasBoss"] = v4,
                        ["RemainTime"] = H,
                        ["NextBossId"] = k,
                        ["Position"] = I,
                        ["ActiveBoss"] = s,
                        [Re] = v1
                    };
                    F[K.Name] = e;
                end;
            end; 
        end;
        r40 = M;
        return M; 
    end;
    pz[36] = function(arg1_97, ...)
        v = arg1_97;
        r93 = tick();
        v2 = {};
        K = r42;
        K = (7)[1];
        v3 = (7)[2];
        for v10, H in pairs(K) do
            table.insert(v2, H); 
        end;
        v4 = r15;
        table.sort(v2, function(arg1_98, arg2_98, ...)
            M = arg2_98;
            v = arg1_98;
            v1 = v24;
            v3 = v24;
            v24 = (v.RemainTime or 9999) - (r93 - (v.LastScan or 0));
            v2 = v24;
            K = v24;
            return v24 < (M.RemainTime or 9999) - (r93 - (M.LastScan or 0)); 
        end);
        if #v2 == 0 then
            return "Initializing scan...";
        end;
        v24 = ipairs;
        v10 = v4[2];
        v3 = v4[1];
        for K, H in v24(v2) do
            v4 = K;
            s = ipairs;
            v24 = r93 - (H.LastScan or 0);
            s = "❓";
            if (H.RemainTime or 9999) - v24 <= 0 then
                if H.HasBoss then
                    s = "🔴 ACTIVE";
                else
                    s = "⚠️ CHECKING";
                end;
            else
                u = math.floor(I / 60);
                if u < 0 then
                    J = 0;
                    u = 0;
                end;
                s = "⏳ " .. string.format("%02d:%02d", u, math.floor(I % 60));
                u = H.NextBossId or "?";
                v24 = W[v1] - (H.LastScan or 0);
                J = r58[tostring(u)];
                if J then
                    u = J.Name;
                end;
                table.insert({}, H.PointName .. ": " .. u .. " — " .. s);
            end; 
        end;
        return table.concat({}, "\n"); 
    end;
    pz[33] = 99;
    W[pz[33]] = pz[34];
    pz[34] = 100;
    W[pz[34]] = pz[35];
    pz[35] = 101;
    W[pz[35]] = pz[36];
    pz[36] = 102;
    W[pz[36]] = pz[37];
    pz[37] = function(arg1_99, ...)
        v = arg1_99;
        if not v or not v.TargetPart then
            return false;
        end;
        M = r50.Character;
        if not M then
            return false;
        end;
        v1 = M.FindFirstChild(M, "HumanoidRootPart");
        if not v1 then
            return false;
        end;
        O = v.TargetPart.Position;
        v1.CFrame = CFrame.new(O + Vector3.new(0, 5, -10), O);
        v24 = r26;
        v24.Notify(v24, {
            ["Title"] = "Boss Hunter",
            ["Content"] = "Teleported to " .. v.Name .. " | HP: " .. v.CurHP .. "/" .. v.MaxHP,
            ["Duration"] = 3
        });
        return true; 
    end;
    pz[39] = Env[pz[40]];
    pz[40] = "spawn";
    pz[38] = pz[39].spawn;
    pz[40] = function(...)
        if not r52 then
            return;
        end;
        r94 = {};
        v1 = {
            ["Ready"] = "rbxassetid://128688615634278",
            ["Start"] = "rbxassetid://106313713148421",
            ["Throw"] = "rbxassetid://8658666909120",
            ["Idle"] = "rbxassetid://108491131883663"
        };
        r96 = {
            ["Shoot"] = "rbxassetid://87323058513306",
            ["Retrieve"] = "rbxassetid://83134848428792"
        };
        local function r97(arg1_100, arg2_100, arg3_100, ...)
            v = arg1_100;
            v1 = arg3_100;
            r98 = v.FindFirstChild(v, "Handle");
            if not r98 then
                return;
            end;
            v24 = r98;
            r99 = v24.Clone(v24);
            v24 = r99;
            v24.Name = "VisualSpear";
            v24 = r99;
            v24.CanCollide = false;
            v24 = r99;
            v24.Anchored = true;
            v24 = r99;
            v24.CFrame = r98.CFrame;
            v24 = r99;
            v24.Parent = workspace;
            r100 = r98.Transparency;
            v24 = r98;
            v24.Transparency = 1;
            r101 = Instance.new("Attachment", r98);
            v4 = Instance.new("Beam");
            v4.Attachment0 = r101;
            b = Instance.new("Attachment", r99);
            v4.Attachment1 = b;
            v4.FaceCamera = true;
            v4.Width0 = .1;
            v4.Width1 = .1;
            v4.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0));
            v4.Parent = r99;
            v24 = r24;
            H = v24.Create(v24, r99, TweenInfo.new(v1, Enum.EasingStyle.Linear), {
                ["Position"] = arg2_100
            });
            H.Play(H);
            task.delay(v1 + .1, function(...)
                v24 = r99;
                if v24 then
                    v24 = r99;
                    v24.Destroy(v24);
                end;
                v24 = r101;
                if v24 then
                    v24 = r101;
                    v24.Destroy(v24);
                end;
                if r98 then
                    v24 = r98;
                    v24.Transparency = r100;
                end; 
            end); 
        end;
        local function r102(arg1_101, arg2_101, ...)
            v = arg1_101;
            v1 = v.FindFirstChild(v, "Handle");
            if not v1 then
                return;
            end;
            r103 = Instance.new("Part");
            v24 = r103;
            v24.Anchored = true;
            v24 = r103;
            v24.Transparency = 1;
            v24 = r103;
            v24.CanCollide = false;
            v24 = r103;
            v2 = arg2_101;
            v24.Position = v2;
            v24 = r103;
            v24.Parent = workspace;
            v10 = Instance.new("Beam");
            b = Instance.new("Attachment", v1);
            v10.Attachment0 = b;
            b = Instance.new("Attachment", r103);
            v10.Attachment1 = b;
            v10.FaceCamera = true;
            v10.Width0 = .05;
            v10.Width1 = .05;
            v10.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255));
            v10.Transparency = NumberSequence.new(.2);
            v10.Parent = r103;
            task.delay(.15, function(...)
                v24 = r103;
                if v24 then
                    v24 = r103;
                    v24.Destroy(v24);
                end; 
            end); 
        end;
        local function r104(arg1_102, arg2_102, arg3_102, ...)
            v = arg1_102;
            O = v.FindFirstChild(v, "Handle");
            if not O then
                return;
            end;
            r105 = Instance.new("Part");
            v24 = r105;
            v24.Anchored = true;
            v24 = r105;
            v24.Transparency = 1;
            v24 = r105;
            v24.CanCollide = false;
            v24 = r105;
            v3 = arg2_102;
            v24.Position = v3;
            v24 = r105;
            v24.Parent = workspace;
            K = Instance.new("Beam");
            b = Instance.new("Attachment", O);
            K.Attachment0 = b;
            b = Instance.new("Attachment", r105);
            K.Attachment1 = b;
            K.FaceCamera = true;
            K.Width0 = .08;
            K.Width1 = .08;
            K.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255));
            K.TextureMode = Enum.TextureMode.Wrap;
            K.Parent = r105;
            task.delay(arg3_102, function(...)
                v24 = r105;
                if v24 then
                    v24 = r105;
                    v24.Destroy(v24);
                end; 
            end); 
        end;
        local function r106(arg1_103, arg2_103, arg3_103, ...)
            v1 = arg3_103;
            M = arg2_103;
            v = arg1_103;
            v24 = r50.Character;
            if v24 then
                b = v24.FindFirstChild(v24, "Humanoid");
            end;
            if O then
                v3 = O.FindFirstChild(O, "Animator");
            end;
            v24 = v24;
            b = O;
            if O then
                if v3 then
                    v10 = Instance.new("Animation");
                    b = arg1_103;
                    v10.AnimationId = b;
                    K = v3.LoadAnimation(v3, v10);
                    v24 = "Looped";
                    K[v24] = arg2_103 or false;
                    K.Priority = Enum.AnimationPriority.Action;
                    K.AdjustSpeed(K, arg3_103 or 1);
                    K.Play(K);
                    table.insert(r94, K);
                    return K;
                end;
                return nil;
            else
                b = O;
            end; 
        end;
        v24 = r25.RenderStepped;
        v24.Connect(v24, function(...)
            v1 = "AutoFarm";
            v = r28[v1];
            if v then
                v1 = not r32;
                if v1 then
                    v24 = b[H];
                    v = r95 and r50.Character;
                end;
                b = v1;
                v24 = b[H];
            end;
            if v then
                v24 = r50.Character;
                v = v24.FindFirstChild(v24, "HumanoidRootPart");
                v24 = r50.Character;
                if v then
                    b = v24.FindFirstChild(v24, v1[v2]);
                end;
                if v then
                    M.AutoRotate = false;
                    v1 = v.Position;
                    v.CFrame = CFrame.lookAt(v1, Vector3.new(r95.X, v1.Y, r95.Z));
                end;
            else
                v24 = r50.Character;
                if v24 then
                    v24 = r50.Character;
                    v = v24.FindFirstChild(v24, "Humanoid");
                    if v then
                        v.AutoRotate = true;
                    end;
                end;
                return;
            end; 
        end);
        local function H(...)
            M = r28.FarmDistance;
            v1 = r50.Character;
            if not (v1 and v1.FindFirstChild(v1, "HumanoidRootPart")) then
                return nil;
            end;
            v24 = workspace;
            v2 = v24.FindFirstChild(v24, "WorldSea");
            if not v2 then
                return nil;
            end;
            v4 = v2.GetChildren;
            K = {
                v4(v2)
            };
            v3 = v4[2];
            v10 = v4[3];
            for v10, H in pairs(l("pairs")) do
                A = H.GetChildren;
                v4 = v10;
                s = A[3];
                I = A[2];
                for s, A in pairs(A(H)) do
                    c = s;
                    u = (nil).IsA(nil, "BasePart");
                    if u then
                        string.find((nil).Name, "Fish");
                    end;
                    if u then
                        d = (v1 and v1.FindFirstChild(v1, "HumanoidRootPart")).Position - (nil).Position;
                        v24 = (d.Magnitude and d) < r28.FarmDistance;
                    end; 
                end; 
            end;
            return nil; 
        end;
        task.spawn(function(...)
            v = 0;
            while true do
                if r28.AutoHuntBoss and r28.AutoFarm then
                    v1 = tick();
                    O = r28.BossCheckInterval;
                    v24 = v1 - 0 >= O;
                    if v24 then
                        O = W[pz[33]]();
                        v24 = tick();
                        v = v1;
                        if O then
                            v2 = v1;
                            v24 = v2;
                            if not nil or (nil).Name ~= "Name" then
                                M = O;
                                v2 = r26;
                                v2.Notify(v2, {
                                    ["Title"] = "Boss Found",
                                    ["Content"] = "Targeting: " .. "Name",
                                    ["Duration"] = 2
                                });
                            else
                                v2 = (nil).Position;
                                M.Position = ("TargetPart").Position;
                                M.CurHP = "CurHP";
                            end;
                        else
                            if r28.BossHop then
                                c = 22674868037950;
                                v10 = workspace;
                                K = v10.FindFirstChild(v10, "WorldBoss");
                                if K then
                                    c = K.GetChildren;
                                    s = {
                                        c(K)
                                    };
                                    k = c[2];
                                    I = c[3];
                                    for I, s in pairs(l(s)) do
                                        v4 = I;
                                        if string.find("Name", "Point") then
                                            A = v1;
                                            c = s.GetAttribute(s, "RemainTime") or 9999;
                                            A = c < 9999;
                                            if A then
                                                A = d or u;
                                                v10 = c;
                                            end;
                                        end; 
                                    end;
                                end;
                                if 9999 > 30 then
                                    task.wait(5);
                                    r66();
                                    task.wait(10);
                                end;
                            end;
                        end;
                    end;
                    if nil then
                        O = (nil).TargetPart;
                    end;
                    v24 = v24;
                    if nil then
                        r36 = (nil).TargetPart.Position;
                        r95 = (nil).TargetPart.Position;
                    else
                        W[Y[11]] = nil;
                    end;
                    task.wait(.1);
                else
                    W[Y[11]] = nil;
                end; 
            end; 
        end);
        task.spawn(function(...)
            v = 0;
            v1 = false;
            while true do
                O = "AutoTPBoss";
                if r28[O] then
                    O = tick();
                    v3 = r28;
                    v10 = "BossScanInterval";
                    v2 = v3[v10];
                    v24 = O - 0 >= v2;
                    if v24 then
                        v24 = tick();
                        v = O;
                        W[pz[34]]();
                        b = r87;
                        if b then
                            b = r87;
                            b.SetDesc(b, W[pz[35]](nil));
                        end;
                        v10 = {
                            W[pz[36]]()
                        };
                        v2 = W[pz[36]]();
                        v3 = v10[2];
                        if v2 then
                            if not r43 then
                                W[Y[17]] = {};
                            end;
                            if v3 == "Scanning" then
                                v10 = r43;
                                v10[v10[1].Name] = tick();
                            end;
                            if nil ~= v2.Name then
                                M = v2.Name;
                                s = 21275368941235;
                                K = r50.Character;
                                if K then
                                    v4 = K.FindFirstChild(K, "HumanoidRootPart");
                                end;
                                v24 = O;
                                if K then
                                    I = v2.CFrame * CFrame.new(0, 5, 0);
                                    v4.CFrame = I;
                                    v24 = v24;
                                    if v3 == "Waiting" and not r28.FarmSpot then
                                        k = (v3 .. ": " .. v2.Name) .. " (No Farm Spot Set!)";
                                    end;
                                    s = r26;
                                    s.Notify(s, {
                                        ["Title"] = "Smart Boss TP",
                                        ["Content"] = v3 .. ": " .. v2.Name,
                                        ["Duration"] = 3
                                    });
                                end;
                            end;
                        else
                            if nil then
                                v4 = r26;
                                v4.Notify(v4, {
                                    ["Title"] = "Smart Boss TP",
                                    ["Content"] = "Waiting for target...",
                                    ["Duration"] = 2
                                });
                            end;
                            task.wait(1);
                        end;
                    end;
                else
                    if nil then
                        v1 = false;
                        if r41 then
                            v3 = r50.Character;
                            H = b[O];
                            if v3 then
                                v4 = v3.FindFirstChild(v3, "HumanoidRootPart");
                            end;
                            if v3 then
                                v4.CFrame = r41;
                                H = r26;
                                H.Notify(H, {
                                    ["Title"] = "TP Boss",
                                    ["Content"] = "Returned to previous position.",
                                    ["Duration"] = 2
                                });
                            end;
                        end;
                    end;
                    v3 = r87;
                    if v3 then
                        v3 = r87;
                        v3.SetDesc(v3, "Enable Auto TP Boss to see live status.");
                    end;
                end; 
            end; 
        end);
        local function r108(...)
            if r28.AutoHuntBoss and (r28.BossPriority and r36) then
                return r36, true;
            end;
            v = r65(r28.MissionTargetID);
            if v then
                return v.Position, false;
            end;
            return nil, false; 
        end;
        local function r109(arg1_104, arg2_104, arg3_104, arg4_104, ...)
            M = arg2_104;
            O = arg4_104;
            v = arg1_104;
            v24 = string.find;
            if v24(string.lower(v.Name), "gun") then
                if not r28.DisableAnims then
                    r106(r96.Shoot, false, 1);
                    r102(arg1_104, arg2_104);
                end;
                v24 = r53;
                v24.FireServer(v24, "Fire", {
                    ["cameraOrigin"] = "Position",
                    ["player"] = r50,
                    ["toolInstance"] = v,
                    ["destination"] = M
                });
                if not r28.DisableAnims then
                    r104(arg1_104, arg2_104, .1);
                end;
            else
                if not r28.DisableAnims then
                    r97(arg1_104, arg2_104, .2);
                end;
                v24 = r53;
                v24.FireServer(v24, "Fire", {
                    ["cameraOrigin"] = "Position",
                    ["player"] = r50,
                    ["toolInstance"] = v,
                    ["destination"] = M,
                    ["isCharge"] = true
                });
                if arg3_104 then
                    v3 = W[pz[33]]();
                    if v3 then
                        b = "Boss";
                    end;
                    if v3 then
                        for z = 1, 5 do
                            v24 = r53;
                            v24.FireServer(v24, "Hit", {
                                ["fishInstance"] = v24().Boss,
                                ["HitPos"] = arg2_104,
                                ["toolInstance"] = arg1_104
                            }); 
                        end;
                    else
                        W[pz[33]] = nil;
                    end;
                else
                    v3 = r65();
                    if v3 then
                        b = 1;
                        for z = b, 5 do
                            b = r53;
                            b.FireServer(b, "Hit", {
                                ["fishInstance"] = v3,
                                ["HitPos"] = "Position",
                                ["toolInstance"] = arg1_104
                            }); 
                        end;
                    end;
                    return;
                end;
            end; 
        end;
        task.spawn(function(...)
            v = 0;
            while true do
                if r46 then
                    task.wait(0.5);
                else
                    if r28.AutoFarm and not r32 then
                        M = r50.Character;
                        v1 = M and M.FindFirstChildWhichIsA(M, "Tool");
                        O = M and M.FindFirstChild(M, "HumanoidRootPart");
                        if M then
                            if v1 then
                                v2 = M and M.FindFirstChild(M, "HumanoidRootPart");
                            end;
                            v24 = r50[r16[v2]];
                            b = v1;
                        end;
                        if M then
                            v3 = r108();
                            if v3 then
                                r95 = v3;
                                r109(M and M.FindFirstChildWhichIsA(M, "Tool"), v3, v3[2], M and M.FindFirstChild(M, "HumanoidRootPart"));
                                v = 0 + 1;
                            else
                                W[M] = nil;
                            end;
                        end;
                    else
                        W[v4]();
                    end;
                    if r28.AutoFarm then
                        task.wait(.01);
                    else
                        task.wait(1);
                    end;
                end; 
            end; 
        end);
        task.spawn(function(...)
            while true do
                if r28.AutoSell then
                    pcall(function(...)
                        v = r62();
                        v24 = #v > 0;
                        if v24 then
                            v24 = r54;
                            v24.FireServer(v24, "SellAll", {
                                ["UIDs"] = v
                            });
                            v24 = r26;
                            v24.Notify(v24, {
                                ["Title"] = "Auto Sell",
                                ["Content"] = "Sold: " .. #v,
                                ["Duration"] = 3
                            });
                        end; 
                    end);
                end;
                task.wait(r28.SellDelay); 
            end; 
        end);
        task.spawn(function(...)
            while true do
                if r28.AutoSellRarity and #r28.SellRarities > 0 then
                    pcall(function(...)
                        v = {};
                        v24 = r50;
                        M = v24.FindFirstChild(v24, "PlayerGui");
                        if M then
                            v2 = M.FindFirstChild(M, "Data");
                            if v2 then
                                v2 = v24.FindFirstChild(v24, v1[v2]).Data;
                                v1 = v2.FindFirstChild(v2, "Fish");
                            end;
                            v24 = r50;
                            b = v2;
                        end;
                        if M then
                            v2 = ("Data").Fish;
                            v1 = v2[2];
                            v2 = v2[1];
                            for O, v10 in pairs(v2.GetChildren(v2)) do
                                v3 = O;
                                if v10.GetAttribute(v10, "Lock") ~= true then
                                    K = v10.GetAttribute(v10, "ID") or v10.GetAttribute(v10, "Id");
                                    if K then
                                        v4 = r58[tostring(K)];
                                        if v4 then
                                            H = v4.Rarity;
                                        end;
                                        if v4 then
                                            A = r28;
                                            k = A[1];
                                            I = A[2];
                                            for s, A in pairs(A.SellRarities) do
                                                c = s;
                                                if A == v4.Rarity then
                                                    H = true;
                                                end; 
                                            end;
                                            if false then
                                                table.insert({}, "Name");
                                            end;
                                        end;
                                    end;
                                end; 
                            end;
                        end;
                        v1 = #v > 0;
                        if v1 then
                            v1 = r54;
                            v1.FireServer(v1, "SellAll", {
                                ["UIDs"] = v
                            });
                            v1 = r26;
                            v1.Notify(v1, {
                                ["Title"] = "Auto Sell by Rarity",
                                ["Content"] = "Sold: " .. #v,
                                ["Duration"] = 3
                            });
                        end; 
                    end);
                end;
                task.wait(r28.SellDelay); 
            end; 
        end);
        task.spawn(function(...)
            while true do
                if r28.AutoLock then
                    pcall(function(...)
                        v24 = r50;
                        v = v24.FindFirstChild(v24, "PlayerGui");
                        M = v and v.FindFirstChild(v, "Data");
                        if M then
                            v4 = M.GetChildren;
                            K = {
                                v4(M)
                            };
                            v3 = v4[2];
                            K = v4[1];
                            for v10, H in pairs(l(K)) do
                                v4 = v10;
                                I = H.GetAttribute(H, "ID") and H.GetAttribute(H, "Id");
                                if I then
                                    v24 = not I;
                                    s = not H.GetAttribute(H, "Lock") and (function(arg1_106, arg2_106, ...)
                                        O = ("\x9e\xb9_k\xe0s\x8f\x8ca")[3];
                                        v1 = ("\x9e\xb9_k\xe0s\x8f\x8ca")[2];
                                        v2 = "pairs";
                                        for O, v10 in pairs(arg2_106) do
                                            v3 = O;
                                            if v10 == arg1_106 then
                                                return true;
                                            end; 
                                        end;
                                        return false; 
                                    end)(tostring(I), r28.LockedFishIDs);
                                end;
                                v24 = not I;
                                if I then
                                    v1[H.Name] = true;
                                    O = 0 + 1;
                                end; 
                            end;
                            v3 = 0 > 0;
                            if v3 then
                                v3 = r54;
                                v3.FireServer(v3, "Lock", {
                                    ["Locks"] = {}
                                });
                                v3 = r26;
                                v3.Notify(v3, {
                                    ["Title"] = "Auto Lock",
                                    ["Content"] = "Locked " .. 0 .. " fish",
                                    ["Duration"] = 2
                                });
                            end;
                        end; 
                    end);
                end;
                task.wait(5); 
            end; 
        end);
        s = "spawn";
        task[s](function(...)
            while true do
                if r28.AutoUnlock then
                    pcall(function(...)
                        v24 = r50;
                        v = v24.FindFirstChild(v24, "PlayerGui");
                        M = v and v.FindFirstChild(v, "Data");
                        if M then
                            v4 = M.GetChildren;
                            K = {
                                v4(M)
                            };
                            v10 = v4[3];
                            K = v4[1];
                            for v10, H in K, pairs(l(K)) do
                                v4 = v10;
                                k = H.GetAttribute(H, "Lock");
                                I = H.GetAttribute(H, "ID") and H.GetAttribute(H, "Id");
                                if I then
                                    if k then
                                        (function(arg1_108, arg2_108, ...)
                                            O = ("\x1e\x91rM\xa4\xb53\x1ft")[3];
                                            for O, v10 in ("\x1e\x91rM\xa4\xb53\x1ft")[1], pairs(arg2_108) do
                                                v3 = O;
                                                if v10 == arg1_108 then
                                                    return true;
                                                end; 
                                            end;
                                            return false; 
                                        end)(tostring(H.GetAttribute(H, r16[A]) and H.GetAttribute(H, "Id")), r28.UnlockedFishIDs);
                                    end;
                                    v24 = not I;
                                    s = k;
                                end;
                                v24 = not I;
                                if I then
                                    v1[H.Name] = false;
                                    O = 0 + 1;
                                end; 
                            end;
                            v3 = 0 > 0;
                            if v3 then
                                v3 = r54;
                                v3.FireServer(v3, "Lock", {
                                    ["Locks"] = {}
                                });
                                v3 = r26;
                                v3.Notify(v3, {
                                    ["Title"] = "Auto Unlock",
                                    ["Content"] = "Unlocked " .. 0 .. " fish",
                                    ["Duration"] = 2
                                });
                            end;
                        end; 
                    end);
                end;
                task.wait(5); 
            end;
            repeat

            until (81)(nil, s);
            c = s;
            u = (nil).IsA(nil, "BasePart");
            if u then
                string.find((nil).Name, "Fish");
            end;
            if u then
                d = (v1 and v1.FindFirstChild(v1, "HumanoidRootPart")).Position - (nil).Position;
                v24 = (d.Magnitude and d) < r28.FarmDistance;
                if v24 then
                    v24 = (v1 and v1.FindFirstChild(v1, "HumanoidRootPart")).Position - A.Position;
                    M = d;
                end;
            end; 
        end);
        task.spawn(function(...)
            while true do
                if r28.AutoLockRarity and #r28.LockedRarities > 0 then
                    pcall(function(...)
                        v24 = r50;
                        v = v24.FindFirstChild(v24, "PlayerGui");
                        M = v and v.FindFirstChild(v, "Data");
                        if M then
                            K = M.GetChildren;
                            v10 = {
                                K(M)
                            };
                            v2 = K[2];
                            v3 = K[3];
                            for v3, v4 in pairs(l(b)) do
                                H = v4.GetAttribute(v4, "Lock");
                                K = v3;
                                k = v4.GetAttribute(v4, "ID") or v4.GetAttribute(v4, "Id");
                                if k then
                                    I = not H;
                                end;
                                if k then
                                    I = r58[tostring(k)];
                                    if I then
                                        s = "Rarity";
                                    end;
                                    if I then
                                        J = r28;
                                        A = J[2];
                                        d = J[3];
                                        for d, J in pairs(J.LockedRarities) do
                                            u = d;
                                            if J == "Rarity" then
                                                s = true;
                                            end; 
                                        end;
                                        if false then
                                            v1[v4.Name] = true;
                                            O = 0 + 1;
                                        end;
                                    end;
                                end; 
                            end;
                            v2 = 0 > 0;
                            if v2 then
                                v2 = r54;
                                v2.FireServer(v2, "Lock", {
                                    ["Locks"] = {}
                                });
                                v2 = r26;
                                v2.Notify(v2, {
                                    ["Title"] = "Auto Lock by Rarity",
                                    ["Content"] = "Locked " .. 0 .. " fish",
                                    ["Duration"] = 2
                                });
                            end;
                        end; 
                    end);
                end;
                task.wait(5); 
            end; 
        end);
        task.spawn(function(...)
            while true do
                M = r16;
                v2 = "\x97\xa6Ih@\ne>\xc1\xd6<\xc7\xfe\xf4";
                O = 24589889907898;
                if r28.AutoClaimAlbum then
                    v1 = {
                        pcall(function(...)
                            v = r51;
                            M = v.WaitForChild(v, "Config");
                            return require(M.WaitForChild(M, "ResMutation")); 
                        end)
                    };
                    v = v1[2];
                    M = pcall(function(...)
                        v = r51;
                        M = v.WaitForChild(v, "Config");
                        return require(M.WaitForChild(M, "ResMutation")); 
                    end);
                    v2 = {
                        pcall(function(...)
                            v = r51;
                            M = v.WaitForChild(v, "Config");
                            return require(M.WaitForChild(M, "ResFish")); 
                        end)
                    };
                    v1 = v2[2];
                    O = pcall(function(...)
                        v = r51;
                        M = v.WaitForChild(v, "Config");
                        return require(M.WaitForChild(M, "ResFish")); 
                    end);
                    if M then
                        if O then
                            v10 = v1[2];
                            v2 = v10 and v2[2];
                            v24 = pcall;
                        end;
                        v24 = pcall;
                        b = O;
                    end;
                    if M then
                        v24 = r26;
                        v24.Notify(v24, {
                            ["Title"] = "Album",
                            ["Content"] = "Generating smart claim list...",
                            ["Duration"] = 2
                        });
                        K = r15;
                        v10 = K[3];
                        K = K[1];
                        for v10, H in K, pairs(v1[2]) do
                            if type(v10) == "string" and v10 ~= "__index" then
                                table.insert({
                                    "GetThing",
                                    "GetMaxThing",
                                    v3
                                }, "Get" .. v10 .. "Thing");
                            end; 
                        end;
                        v10 = {};
                        v4 = (24917242047826)[2];
                        K = (24917242047826)[1];
                        for H, I in pairs("GetMaxThing") do
                            if H ~= "__index" then
                                v3 = 0 + 1;
                                table.insert(v10, H);
                            end; 
                        end;
                        v4 = r26;
                        s = "Album";
                        v4.Notify(v4, {
                            ["Title"] = s,
                            ["Content"] = "Checking " .. 0 .. " Fish Types...",
                            ["Duration"] = 2
                        });
                        I = s[3];
                        for I, s in s[1], ipairs(v10) do
                            v4 = I;
                            if not r28.AutoClaimAlbum then
                            else
                                tostring(s);
                                d = F[1];
                                u = F[2];
                                for J, F in ipairs({
                                    "GetThing",
                                    "GetMaxThing",
                                    "GetMinThing"
                                }) do
                                    A = J;
                                    if not r28.AutoClaimAlbum then
                                    else
                                        Q = r54;
                                        Q.FireServer(Q, "AlbumGetThing", {
                                            ["ID"] = tostring(s),
                                            ["Param"] = F
                                        });
                                        task.wait(.02);
                                    end; 
                                end;
                                K = 0 + 1;
                                d = K % 5 == 0;
                                if d then
                                    d = r26;
                                    d.Notify(d, {
                                        ["Title"] = "Album Progress",
                                        ["Content"] = K .. " / " .. 0 .. " Fish",
                                        ["Duration"] = 1
                                    });
                                end;
                                task.wait(.05);
                            end; 
                        end;
                        if r28.AutoClaimAlbum then
                            v4 = r26;
                            v4.Notify(v4, {
                                ["Title"] = "Cycle Finished",
                                ["Content"] = "Restarting in 5 seconds...",
                                ["Duration"] = 4
                            });
                            task.wait(5);
                        end;
                        task.wait(1);
                    else
                        v2 = r26;
                        v2.Notify(v2, {
                            ["Title"] = "Error",
                            ["Content"] = "Failed to load ResMutation/ResFish!",
                            ["Duration"] = 3
                        });
                        v2 = r28;
                        v2.AutoClaimAlbum = false;
                        v2 = tabAlbum;
                        if v2 then
                            v2 = tabAlbum;
                            v2.Set(v2, false);
                        end;
                    end;
                end; 
            end; 
        end);
        task.spawn(function(...)
            while true do
                O = r16;
                if r28.AutoBuy and r28.SelectedToolID then
                    M = r79(r28.SelectedToolID);
                    v24 = false;
                    O = r50.PlayerGui;
                    if O.FindFirstChild(O, "Data") and O.FindFirstChild(O, "Tool") then
                        v24 = r50.PlayerGui.Data.Tool;
                        if v24.FindFirstChild(v24, r28.SelectedToolID) then
                            v1 = true;
                        end;
                    end;
                    if v24 then
                        b = r26;
                        b.Notify(b, {
                            ["Title"] = "Shop",
                            ["Content"] = "Owned: " .. v1[2],
                            ["Duration"] = 3
                        });
                        b = r28;
                        b.AutoBuy = false;
                    else
                        b = r78() >= v1[1];
                        if b then
                            b = r55;
                            b.FireServer(b, "Buy", {
                                ["ID"] = r28.SelectedToolID
                            });
                            b = r26;
                            b.Notify(b, {
                                ["Title"] = "Buying",
                                ["Content"] = v1[2],
                                ["Duration"] = 1
                            });
                        end;
                        task.wait(60);
                    end;
                end; 
            end; 
        end);
        task.spawn(function(...)
            while true do
                if r28.AutoTPChest then
                    v = r50.Character;
                    if v and v.FindFirstChild(v, "HumanoidRootPart") then
                        v1 = {};
                        v3 = workspace;
                        O = v3[2];
                        v2 = v3[3];
                        v3 = "pairs";
                        for v2, K in pairs(v3.GetChildren(v3)) do
                            v10 = v2;
                            if K.IsA(K, "Model") and string.find(K.Name, "Chest") then
                                if K.PrimaryPart then
                                    table.insert({}, {
                                        ["Model"] = K,
                                        ["Dist"] = (K.PrimaryPart.Position - (b and v.FindFirstChild(v, "HumanoidRootPart")).Position).Magnitude
                                    });
                                end;
                            end; 
                        end;
                        v10 = r15;
                        table.sort(v1, function(arg1_109, arg2_109, ...)
                            return arg1_109.Dist < arg2_109.Dist; 
                        end);
                        if #v1 > 0 then
                            v24 = r26;
                            v10 = "Chest";
                            v24.Notify(v24, {
                                ["Title"] = v10,
                                ["Content"] = "Found " .. #v1 .. " Chests!",
                                ["Duration"] = 1
                            });
                            v3 = v10[3];
                            for v3, K in v10[1], ipairs(v1) do
                                v10 = v3;
                                if not r28.AutoTPChest then
                                else
                                    if K.Model and K.Model.Parent then
                                        v4 = K.Model.PrimaryPart;
                                        if v4 then
                                            H = v4.CFrame * CFrame.new(0, 3, 0);
                                            I = (H.Position - (b and v.FindFirstChild(v, "HumanoidRootPart")).Position).Magnitude;
                                            if I > 300 then
                                                s = v4.CFrame * CFrame.new(0, 3, 0);
                                                M.CFrame = s;
                                                task.wait(.2);
                                            else
                                                c = I / 300;
                                                v24 = r24;
                                                d = v24.Create(v24, b and v.FindFirstChild(v, "HumanoidRootPart"), TweenInfo.new(c, Enum.EasingStyle.Linear), {
                                                    ["CFrame"] = H
                                                });
                                                d.Play(d);
                                                task.wait(c + .05);
                                            end;
                                        end;
                                    end;
                                end; 
                            end;
                        end;
                    end;
                    task.wait(0.5);
                end; 
            end; 
        end);
        task.spawn(function(...)
            v = {
                "Skill01",
                "Skill02",
                "Skill03",
                "Skill04",
                "Skill05",
                "Skill06",
                "Skill07",
                "Skill08",
                "Skill09",
                "Skill10",
                "Skill11",
                "Skill12",
                "Skill13",
                "Skill14"
            };
            while true do
                if r28.AutoUseSkill then
                    if not r38 then
                        v24 = r26;
                        O = "Skill System";
                        v24.Notify(v24, {
                            ["Title"] = O,
                            ["Content"] = "Probing skills (Equip/Use logic)...",
                            ["Duration"] = 2
                        });
                        M = O[2];
                        O = O[1];
                        for v1, v3 in ipairs({
                            b,
                            "Skill02",
                            M,
                            v1,
                            O,
                            v2,
                            v3,
                            v10,
                            K,
                            v4,
                            H,
                            k,
                            I,
                            s
                        }) do
                            v2 = v1;
                            if not r28.AutoUseSkill then
                            else
                                v24 = r54;
                                v24.FireServer(v24, "Skill", {
                                    ["ID"] = v3
                                });
                                task.wait(.6);
                                v24 = r54;
                                v24.FireServer(v24, "EquipSkill", {
                                    ["ID"] = v3
                                });
                                task.wait(.6);
                                v24 = r54;
                                v24.FireServer(v24, "Skill", {
                                    ["ID"] = v3
                                });
                                task.wait(.6);
                                v24 = r54;
                                v24.FireServer(v24, "EquipSkill", {
                                    ["ID"] = v3
                                });
                                task.wait(.6);
                                v10 = r50;
                                if v10.GetAttribute(v10, v3 .. "Cooldown") ~= nil then
                                    if not table.find(r37, v3) then
                                        table.insert(r37, v3);
                                    end;
                                end;
                            end; 
                        end;
                        r38 = true;
                        M = r26;
                        M.Notify(M, {
                            ["Title"] = "Skill System",
                            ["Content"] = "Detected " .. #r37 .. " Active Skills",
                            ["Duration"] = 2
                        });
                    end;
                    v3 = r37;
                    v1 = (4155122354062)[1];
                    O = (4155122354062)[2];
                    for v2, v3 in ipairs(v3) do
                        M = v2;
                        r110 = v3;
                        v3 = 56;
                        if not r28.AutoUseSkill then
                        else
                            v4 = r50;
                            K = v4.GetAttribute(v4, r110 .. "Cooldown");
                            if K then
                                v4 = K == 0;
                            end;
                            v24 = not b;
                            if K then
                                pcall(function(...)
                                    v24 = r54;
                                    v24.FireServer(v24, "EquipSkill", {
                                        ["ID"] = r110
                                    });
                                    task.wait(.6);
                                    v24 = r54;
                                    v24.FireServer(v24, "Skill", {
                                        ["ID"] = r110
                                    });
                                    task.wait(.6);
                                    v24 = r54;
                                    v24.FireServer(v24, "EquipSkill", {
                                        ["ID"] = r110
                                    });
                                    task.wait(.6); 
                                end);
                            end;
                        end; 
                    end;
                    task.wait(0.5);
                else
                    r38 = false;
                    table.clear(r37);
                    task.wait(1);
                end; 
            end; 
        end);
        task.spawn(function(...)
            while true do
                if r28.AutoUseSpecificSkill and #r28.SpecificSkillsList > 0 then
                    v = false;
                    if r28.SpecificSkillTarget == "Always" and r95 ~= nil then
                        v = true;
                    else
                        v24 = false;
                        if r28.SpecificSkillTarget == "Boss Only" and r36 ~= nil then
                            v = true;
                        else
                            v1 = r28.SpecificSkillTarget == "Normal Fish Only" and (r36 == nil and r95 ~= nil);
                            K = r15;
                            v24 = v1;
                            if r28.SpecificSkillTarget == "Normal Fish Only" and (r36 == nil and r95 ~= nil) then
                                v = true;
                            end;
                            if v24 then
                                K = r28;
                                v10 = K.SpecificSkillsList;
                                v2 = K[2];
                                O = K[1];
                                for v3, v10 in ipairs(v10) do
                                    r111 = v10;
                                    v10 = 133;
                                    v1 = v3;
                                    if not r28.AutoUseSpecificSkill then
                                    else
                                        H = r50;
                                        v4 = H.GetAttribute(H, r111 .. "Cooldown");
                                        if v4 then
                                            H = v4 == 0;
                                        end;
                                        v24 = v1;
                                        if v4 then
                                            pcall(function(...)
                                                v24 = r54;
                                                v24.FireServer(v24, "EquipSkill", {
                                                    ["ID"] = r111
                                                });
                                                task.wait(.6);
                                                v24 = r54;
                                                v24.FireServer(v24, "Skill", {
                                                    ["ID"] = r111
                                                });
                                                task.wait(.6);
                                                v24 = r54;
                                                v24.FireServer(v24, "EquipSkill", {
                                                    ["ID"] = r111
                                                });
                                                task.wait(.6); 
                                            end);
                                        end;
                                    end; 
                                end;
                            end;
                            task.wait(0.5);
                        end;
                    end;
                else
                    task.wait(1);
                end; 
            end; 
        end);
        task.spawn(function(...)
            v24 = r51;
            b = v24.WaitForChild(v24, "Remotes");
            v = b.WaitForChild(b, "MessionRE");
            local function M(arg1_110, ...)
                v = arg1_110;
                M = v == "VisitLocation";
                if M then
                    return M;
                else
                    b = v == "Visit" or (v == "BuyItem" or v == "Buy");
                    b.WaitForChild(b, M[O]);
                end; 
            end;
            while true do
                O = r28.AutoMission;
                if O and not r32 then
                    if not r28.AutoFarm then
                        v24 = r28;
                        v24.AutoFarm = true;
                    end;
                    v2 = r28;
                    v10 = r16;
                    K = r15;
                    v4 = 18009195012290;
                    O = r60[v2.SelectedMissionID];
                    if O then
                        v2 = r28.CurrentMissionStep;
                        K = {
                            r72(r28.SelectedMissionID, v2)
                        };
                        v10 = r72(r28.SelectedMissionID, v2);
                        if K[2] then
                            v24 = r26;
                            v24.Notify(v24, {
                                ["Title"] = "Mission",
                                ["Content"] = "Already Claimed!",
                                ["Duration"] = 2
                            });
                            v24 = r28;
                            v24.AutoMission = false;
                            task.wait(1);
                        end;
                        K = O["Count" .. v2];
                        v4 = O["Condition" .. v2];
                        W[pz[19]]("Status: " .. string.format("Step %d: %s/%s", v2, tostring(v10), tostring(K)) .. "\nAction: " .. r74(O, v2));
                        if K then
                            b = v10 >= K;
                        end;
                        if K then
                            I = v2 + 1;
                            v24 = v24["Condition" .. I];
                            if v24 then
                                v24 = r28;
                                s = v2 + 1;
                                v24.CurrentMissionStep = s;
                                v24 = r26;
                                v24.Notify(v24, {
                                    ["Title"] = "Mission",
                                    ["Content"] = "Next Objective...",
                                    ["Duration"] = 2
                                });
                            else
                                v24 = r26;
                                v24.Notify(v24, {
                                    ["Title"] = "Mission",
                                    ["Content"] = "All Objectives Met! Claiming...",
                                    ["Duration"] = 3
                                });
                                v.FireServer(v, "Claim", {
                                    ["ID"] = r28.SelectedMissionID
                                });
                                task.wait(1);
                                v24 = r28;
                                v24.AutoMission = false;
                            end;
                        else
                            v24 = r28;
                            v24.MissionTargetID = nil;
                            v24 = (function(arg1_111, ...)
                                v = arg1_111;
                                M = v == "VisitLocation";
                                if M then
                                    return M;
                                else
                                    b = v == "Visit" or (v == "BuyItem" or v == "Buy");
                                    b.WaitForChild(b, M[O]);
                                end; 
                            end)(v4);
                            if v24 then
                                v24 = r26;
                                v24.Notify(v24, {
                                    ["Title"] = "Mission",
                                    ["Content"] = "Performing Non-Fish Task...",
                                    ["Duration"] = 1
                                });
                                if v4 == "VisitLocation" or v4 == "Visit" then
                                    W[Y[35]](v24, r28.CurrentMissionStep);
                                else
                                    if v4 == "BuyItem" or v4 == "Buy" then
                                        W[Y[36]](v24, r28.CurrentMissionStep);
                                    end;
                                end;
                            else
                                if O["Condition" .. v2] == "HarpoonRequiredFish" then
                                    v24 = r28;
                                    v24.MissionTargetID = v24["RequiredID" .. r28.CurrentMissionStep];
                                else
                                    if O["Condition" .. v2] == "HarpoonFish" then
                                        W[Y[37]](v24, r28.CurrentMissionStep);
                                    end;
                                end;
                            end;
                        end;
                    end;
                else
                    v24 = r28;
                    v24.MissionTargetID = nil;
                end; 
            end; 
        end);
        task.spawn(function(...)
            task.wait(3);
            v = r70();
            if v ~= "None" then
                v24 = W[pz[26]];
                b = table.find(v24.AllConfigs(v24), v);
                if b then
                    v24 = r81;
                    v1 = W[pz[26]];
                    v24.CurrentConfig = v1.Config(v1, v);
                    v24 = r81.CurrentConfig;
                    v24.Load(v24);
                    v24 = task.wait;
                    v24(1);
                    v3 = r16;
                    if r28.FarmSpotCoords and (type(r28.FarmSpotCoords) == "string" and r28.FarmSpotCoords ~= "Not Set") then
                        v24 = r28.FarmSpotCoords;
                        v3 = {
                            v24.match(v24, "([^,]+), ([^,]+), ([^,]+)")
                        };
                        v1 = v3[2];
                        v2 = v24.match(v24, "([^,]+), ([^,]+), ([^,]+)");
                        if v2 then
                            if v1 then
                                v3 = v3[3];
                            end;
                            v24 = r28.FarmSpotCoords;
                            b = v1;
                        end;
                        if v2 then
                            v24 = r28;
                            v24.FarmSpot = {
                                tonumber(v2),
                                tonumber(v1),
                                tonumber(v3[3])
                            };
                            print("✅ FarmSpot berhasil dipulihkan: ", r28.FarmSpotCoords);
                            v24 = v65;
                            if v24 then
                                v24 = v65;
                                v24.Set(v24, r28.FarmSpotCoords);
                            end;
                        end;
                    end;
                    print("========== AUTO LOAD DEBUG ==========");
                    print("UseRarityFilter:", r28.UseRarityFilter);
                    print("SelectedRarity:", r28.SelectedRarity);
                    print("FarmMode:", r28.FarmMode);
                    print("AutoFarm:", r28.AutoFarm);
                    print("MissionTargetID:", r28.MissionTargetID);
                    print("SelectedRarities:", table.concat(r28.SelectedRarities, ", "));
                    print("SelectedFishIDs:", table.concat(r28.SelectedFishIDs, ", "));
                    v24 = print;
                    v2 = v24;
                    v10 = v2;
                    v24 = v10;
                    v24 = r15;
                    v24("FarmSpot Loaded:", r28.FarmSpot and "YES" or "NO");
                    if r28.FarmSpot then
                        print("FarmSpot Coords:", unpack(r28.FarmSpot));
                        if v65 then
                            v24 = r28.FarmSpot;
                            if type(v24) == "table" and #v24 >= 3 then
                                v24 = v65;
                                v24.Set(v24, string.format("%.0f, %.0f, %.0f", v24[1], v24[2], v24[3]));
                            end;
                        end;
                    end;
                    print("=====================================");
                    v24 = r26;
                    v24.Notify(v24, {
                        ["Title"] = "Auto Load",
                        ["Content"] = "Loaded: " .. v,
                        ["Duration"] = 4
                    });
                    if r28.AutoFarm then
                        r32 = true;
                        task.spawn(r80);
                    end;
                    b = W[pz[32]];
                    if b then
                        b = W[Y[42]];
                        b.Select(b, r70());
                    end;
                else
                    b = r26;
                    b.Notify(b, {
                        ["Title"] = "Warning",
                        ["Content"] = "AutoLoad config '" .. r70() .. "' not found!",
                        ["Duration"] = 4
                    });
                end;
            end;
            r46 = false; 
        end);
        v24 = game;
        r112 = v24.GetService(v24, "UserInputService");
        v24 = game;
        r113 = v24.GetService(v24, "VirtualUser");
        v24 = r112.JumpRequest;
        v24.Connect(v24, function(...)
            if r28.InfiniteJump then
                v = r50.Character;
                M = v and v.FindFirstChild(v, "Humanoid");
                if M then
                    M.ChangeState(M, "Jumping");
                end;
            end; 
        end);
        v24 = r50.Idled;
        v24.Connect(v24, function(...)
            if r28.AntiAFK then
                v24 = r113;
                v24.CaptureController(v24);
                v24 = r113;
                v24.ClickButton2(v24, Vector2.new());
                print("⚠️ Anti-AFK Triggered");
            end; 
        end);
        v24 = r112.InputBegan;
        v24.Connect(v24, function(arg1_112, arg2_112, ...)
            v1 = not arg2_112;
            if v1 then
                b = arg1_112.KeyCode == r28.CursorToggleKey;
            end;
            if v1 then
                v24 = r28;
                v24.UnlockCursor = not r28.UnlockCursor;
                v24 = CursorToggleUI;
                if v24 then
                    v24 = CursorToggleUI;
                    v24.Set(v24, r28.UnlockCursor);
                end;
                v24 = r26;
                K = v24;
                H = v24;
                v24 = H;
                v24 = "Duration";
                v24.Notify(v24, {
                    ["Title"] = "Cursor",
                    ["Content"] = r28.UnlockCursor and "Unlocked (Free)" or "Locked (Camera)",
                    ["Duration"] = 1
                });
            end; 
        end);
        v24 = r25.RenderStepped;
        v24.Connect(v24, function(...)
            if r28.UnlockCursor then
                v24 = r112;
                v24.MouseBehavior = Enum.MouseBehavior.Default;
                v24 = r112;
                v24.MouseIconEnabled = true;
            end; 
        end);
        task.spawn(function(...)
            while true do
                v = r50.Character;
                if v then
                    b = v and v.FindFirstChild(v, "Humanoid");
                end;
                if v then
                    if r28.EnableWalkSpeed and "WalkSpeed" ~= r28.WalkSpeed then
                        M.WalkSpeed = r28.WalkSpeed;
                    end;
                    if r28.EnableJumpPower and "JumpPower" ~= r28.JumpPower then
                        M.JumpPower = r28.JumpPower;
                    end;
                    v3 = 24581231504566;
                    if r28.Noclip then
                        v3 = v24.GetDescendants;
                        v2 = {
                            v3(v24)
                        };
                        v1 = v3[2];
                        O = v3[3];
                        for O, v10 in pairs(l("pairs")) do
                            v3 = O;
                            if v10.IsA(v10, "BasePart") and "CanCollide" then
                                v10.CanCollide = false;
                            end; 
                        end;
                    end;
                    task.wait(0.5);
                end; 
            end; 
        end);
        task.spawn(function(...)
            while true do
                M = r16;
                v1 = r15;
                v = "AutoProgressShop";
                v24 = r28[v];
                if v24 then
                    v = {};
                    O = r33;
                    v1 = ("Ѧ\xecR\xb4\x8f\xec\xc5\"\xf5m?9S\xf8\xec")[3];
                    O = ("Ѧ\xecR\xb4\x8f\xec\xc5\"\xf5m?9S\xf8\xec")[1];
                    for v1, v3 in O, pairs(O) do
                        v4 = string.find(v1, "Harpoon");
                        if v4 then
                            v24 = pairs;
                            v10 = "Price" and "AssetType" ~= "Robux";
                        end;
                        if v4 then
                            table.insert({}, {
                                ["ID"] = v1,
                                ["Price"] = "Price",
                                ["Name"] = "Name"
                            });
                        end; 
                    end;
                    table.sort(v, function(arg1_113, arg2_113, ...)
                        return arg1_113.Price < arg2_113.Price; 
                    end);
                    v24 = r50;
                    M = v24.WaitForChild(v24, "PlayerGui");
                    v24 = M.WaitForChild(M, "Data");
                    v10 = 21320526898888;
                    v1 = v24.WaitForChild(v24, "Tools");
                    if v1 then
                        v2 = v10[2];
                        O = v10[1];
                        for v3, K in ipairs(v) do
                            v10 = v3;
                            if not v1.FindFirstChild(v1, K.ID) then
                                v4 = r78();
                                v24 = v4 >= K.Price;
                                if v24 then
                                    v24 = r51;
                                    H = v24.WaitForChild(v24, "Remotes");
                                    H = H.WaitForChild(H, "ToolRE");
                                    H.FireServer(H, "Buy", {
                                        ["ID"] = K.ID
                                    });
                                    v24 = r26;
                                    v24.Notify(v24, {
                                        ["Title"] = "Auto Progress",
                                        ["Content"] = "Buying: " .. K.Name,
                                        ["Duration"] = 3
                                    });
                                    v24 = r28;
                                    v24.SelectedToolID = K.ID;
                                    if r28.AutoFarm then
                                        v24 = r28;
                                        v24.AutoFarm = false;
                                        task.wait(1);
                                        I = game;
                                        k = I.GetService(I, "ReplicatedStorage").Remotes.ToolRE;
                                        k.FireServer(k, "Equip", {
                                            ["ID"] = K.ID
                                        });
                                        v24 = r28;
                                        v24.AutoFarm = true;
                                    end;
                                    task.wait(2);
                                else
                                    v24 = r26;
                                    v24.Notify(v24, {
                                        ["Title"] = "Auto Progress",
                                        ["Content"] = "Need " .. r59(K.Price) .. " Coins. You have " .. r59(v4),
                                        ["Duration"] = 3
                                    });
                                end;
                                task.wait(20);
                            end; 
                        end;
                    end;
                end; 
            end; 
        end);
        task.spawn(function(...)
            local function v(arg1_114, ...)
                if r28.AutoReconnect and arg1_114.Name == "ErrorPrompt" then
                    v24 = r26;
                    v24.Notify(v24, {
                        ["Title"] = "Disconnected",
                        ["Content"] = "Reconnecting in 5s...",
                        ["Duration"] = 5
                    });
                    task.wait(5);
                    v24 = game;
                    M = v24.GetService(v24, "TeleportService");
                    M.TeleportToPlaceInstance(M, game.PlaceId, game.JobId, r50);
                end; 
            end;
            M = game;
            M = M.GetService(M, "CoreGui").RobloxPromptGui.promptOverlay;
            v24 = M.ChildAdded;
            r48 = v24.Connect(v24, v);
            v10 = M.GetChildren;
            v2 = v10[3];
            for v2, v10 in v10[1], pairs(v10(M)) do
                v(v10);
                v3 = v2; 
            end; 
        end);
        task.spawn(function(...)
            while true do
                v1 = r15;
                if r28.AntiStaff then
                    v1 = {
                        pcall(function(...)
                            v1 = r49;
                            v = v1[2];
                            M = v1[3];
                            v1 = "ipairs";
                            for M, v2 in ipairs(v1.GetPlayers(v1)) do
                                O = M;
                                r114 = v2;
                                if r114 ~= r50 then
                                    v4 = "Group";
                                    if game.CreatorType == Enum.CreatorType[v4] then
                                        v4 = {
                                            pcall(function(...)
                                                v24 = r114;
                                                return v24.GetRankInGroup(v24, game.CreatorId); 
                                            end)
                                        };
                                        v10 = v4[2];
                                        v3 = pcall(function(...)
                                            v24 = r114;
                                            return v24.GetRankInGroup(v24, game.CreatorId); 
                                        end);
                                        if v3 then
                                            if v10 then
                                                v4 = v4[2] > 0;
                                            end;
                                            K = v10;
                                            v24 = pcall;
                                        end;
                                        if v3 then
                                            if v10 >= 100 then
                                                v24 = r26;
                                                v24.Notify(v24, {
                                                    ["Title"] = "Staff Detected",
                                                    ["Content"] = "Hopping Server...",
                                                    ["Duration"] = 3
                                                });
                                                r66();
                                                task.wait(10);
                                            end;
                                        end;
                                    end;
                                end; 
                            end; 
                        end)
                    };
                    v = v1[2];
                    M = pcall(function(...)
                        v1 = r49;
                        v = v1[2];
                        M = v1[3];
                        v1 = "ipairs";
                        for M, v2 in ipairs(v1.GetPlayers(v1)) do
                            O = M;
                            r114 = v2;
                            if r114 ~= r50 then
                                v4 = "Group";
                                if game.CreatorType == Enum.CreatorType[v4] then
                                    v4 = {
                                        pcall(function(...)
                                            v24 = r114;
                                            return v24.GetRankInGroup(v24, game.CreatorId); 
                                        end)
                                    };
                                    v10 = v4[2];
                                    v3 = pcall(function(...)
                                        v24 = r114;
                                        return v24.GetRankInGroup(v24, game.CreatorId); 
                                    end);
                                    if v3 then
                                        if v10 then
                                            v4 = v4[2] > 0;
                                        end;
                                        K = v10;
                                        v24 = pcall;
                                    end;
                                    if v3 then
                                        if v10 >= 100 then
                                            v24 = r26;
                                            v24.Notify(v24, {
                                                ["Title"] = "Staff Detected",
                                                ["Content"] = "Hopping Server...",
                                                ["Duration"] = 3
                                            });
                                            r66();
                                            task.wait(10);
                                        end;
                                    end;
                                end;
                            end; 
                        end; 
                    end);
                end;
                task.wait(5); 
            end; 
        end); 
    end;
    pz[39] = pz[38](pz[40]);
    pz[39] = "OnDestroy";
    pz[40] = function(...)
        print("⚠️ Window Closed. Stopping all features...");
        v24 = r28;
        v24.AutoFarm = false;
        v24 = r28;
        v24.AutoSell = false;
        v24 = r28;
        v24.AutoClaimAlbum = false;
        v24 = r28;
        v24.AutoBuy = false;
        v24 = r28;
        v24.AutoHuntBoss = false;
        v24 = r28;
        v24.AutoTPChest = false;
        v24 = r28;
        v24.AutoUseSkill = false;
        v24 = r28;
        v24.AutoTPBoss = false;
        v24 = r28;
        v24.AutoMission = false;
        v24 = r28;
        v24.UnlimitedRange = false;
        v24 = r28;
        v24.InfiniteJump = false;
        v24 = r28;
        v24.Noclip = false;
        v24 = r28;
        v24.AntiAFK = false;
        v24 = r28;
        v24.UnlockCursor = false;
        v24 = r28;
        v24.AutoProgressShop = false;
        v24 = r28;
        v24.AutoLock = false;
        v24 = r28;
        v24.AutoReconnect = false;
        v24 = r28;
        v24.AntiStaff = false;
        v24 = r28;
        v24.EnableWalkSpeed = false;
        v24 = r28;
        v24.EnableJumpPower = false;
        v24 = r28;
        v24.AutoSkillGemsGacha = false;
        if r48 then
            v24 = r48;
            v24.Disconnect(v24);
        end;
        r32 = false;
        v1 = r50.Character;
        if v1 then
            if v1.FindFirstChild(v1, "Humanoid") then
                O.AutoRotate = true;
                O.WalkSpeed = 16;
                O.JumpPower = 50;
            end;
        end;
        O = game;
        O.GetService(O, "UserInputService");
        v2.MouseIconEnabled = false;
        v2.MouseBehavior = Enum.MouseBehavior.LockCenter;
        v4 = workspace;
        K = v4[3];
        v10 = v4[2];
        for K, v4 in pairs(v4.GetChildren(v4)) do
            O = K;
            v24 = r48;
            if v4.Name == "VisualSpear" or (v4.Name == "VisualTracer" or v4.Name == "ESP_Holder") then
                v4.Destroy(v4);
            end; 
        end;
        print("✅ [JumantaraHub] Script Unloaded & Cleaned up successfully!"); 
    end;
    pz[38] = r81;
    pz[39] = pz[38][pz[39]];
    pz[39] = pz[39](pz[38], pz[40]);
    pz[39] = "print";
    pz[38] = Env[pz[39]];
    pz[39] = pz[38]("✅ [JumantaraHub] Spear Fishing Script Fully Loaded!");
    return;
end;