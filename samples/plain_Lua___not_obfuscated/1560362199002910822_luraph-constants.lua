-- This file was generated at discord.gg/syncrypt

return {
    protos = {
        [0] = {
            proto_references = {
                [0] = { proto = 1 },
                [1] = { proto = 2 },
                [2] = { proto = 3 },
                [3] = { proto = 4 },
                [4] = { proto = 5 },
                [5] = { proto = 6 },
            },
        },
        [1] = {
            parent = 0,
            strings = {
                [0] = "bit32", -- x6
                [1] = "band",
                [2] = "lshift", -- x5
            },
        },
        [2] = {
            parent = 0,
            strings = {
                [0] = "bit32",
                [1] = "bxor",
                [2] = "string", -- x2
                [3] = "byte",
                [4] = "format",
                [5] = "%08x",
                [6] = "|6170fb196f8ccbc10fff8d404512bad8b00ffc3a9842203d",
                [7] = "|",
                [8] = "tostring",
                [9] = "",
                [10] = "time",
                [11] = "game",
                [12] = "JobId",
                [13] = "math",
                [14] = "floor",
                [15] = "os",
            },
        },
        [3] = {
            parent = 0,
            strings = {
                [0] = "type",
                [1] = "string",
            },
        },
        [4] = {
            parent = 0,
            strings = {
                [0] = "lshift", -- x5
                [1] = "bit32", -- x6
                [2] = "band",
            },
        },
        [5] = {
            parent = 0,
            strings = {
                [0] = "bit32",
                [1] = "bxor",
                [2] = "string", -- x2
                [3] = "byte",
                [4] = "format",
                [5] = "%08x",
                [6] = "tostring",
                [7] = "game",
                [8] = "GameId",
                [9] = "|d7ad27c1f68163a61c30cc963d4b64ead757827aa3a08645",
            },
        },
        [6] = {
            parent = 0,
            strings = {
                [0] = "reportTamper", -- x3
                [1] = "fake_response",
                [2] = "Destroy",
                [3] = "check",
                [4] = "CenzStore", -- x3
                [5] = "CenzConfig", -- x3
                [6] = "JSONDecode",
                [7] = "task",
                [8] = "game", -- x2
                [9] = "GetService", -- x2
                [10] = "HttpService",
                [11] = "ProxyUrl",
                [12] = "https://app.cenzstudio.com",
                [13] = "version_mismatch",
                [14] = "tamper",
                [15] = "ReplicatedStorage",
                [16] = "__mode",
                [17] = "k",
                [18] = "FindFirstChild",
                [19] = "CenzMusicBoot", -- x2
                [20] = "denied",
                [21] = "warn",
                [22] = "CENZ STUDIO - system unavailable. Please contact CENZ STUDIO.",
                [23] = "ProductId",
                [24] = "cenzmusic",
                [25] = "PublicKey",
                [26] = "e8e92640307e42995204155aaaf86f0b4b71fd36e6ffdbe61d5c13cbbc1ac301",
                [27] = "EncData",
                [28] = "8e0552eea0bae4cf0c4635674aac6925badd3a696ec372e2118028335cbfdc076bb622aaff3a45",
                [29] = "startHeartbeat",
                [30] = "wait",
                [31] = "name", -- x2
                [32] = "setmetatable",
                [33] = "Instance",
                [34] = "new",
                [35] = "RemoteFunction",
                [36] = "Name",
                [37] = "OnServerInvoke",
                [38] = "Parent",
                [39] = "Attempts",
                [40] = "loader_crack",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 7 },
                [1] = { proto = 8 },
                [2] = { proto = 9 },
                [3] = { proto = 10 },
                [4] = { proto = 11 },
                [5] = { proto = 12 },
                [6] = { proto = 13 },
                [7] = { proto = 14 },
                [8] = { proto = 15 },
                [9] = { proto = 16 },
                [10] = { proto = 17 },
            },
        },
        [7] = {
            parent = 6,
            strings = {
                [0] = "EndProfile",
                [1] = "GetFavorites",
                [2] = "ToggleFavorite",
                [3] = "game", -- x5
                [4] = "GetService", -- x5
                [5] = "MarketplaceService",
                [6] = "Roster",
                [7] = "OnLibraryChanged",
                [8] = "OnRosterChanged",
                [9] = "Ready",
                [10] = "CustomTracks",
                [11] = "Favorites",
                [12] = "MessagingService",
                [13] = "CenzConfig",
                [14] = "ExpectedNames",
                [15] = "RefreshRoster",
                [16] = "RemoveTrack",
                [17] = "GetRosterList",
                [18] = "Init",
                [19] = "Players",
                [20] = "AddDJ",
                [21] = "RemoveDJ",
                [22] = "GetAudioInfo",
                [23] = "AddTrack",
                [24] = "GetLikedAlbums",
                [25] = "ToggleLikedAlbum",
                [26] = "LikedAlbums",
                [27] = "RefreshLibrary",
                [28] = "IsRosterDJ",
                [29] = "StartProfile",
                [30] = "DataStoreService",
                [31] = "ReplicatedStorage",
                [32] = "OnProfileLoaded",
            },
            booleans = {
                [0] = false, -- x2
            },
            proto_references = {
                [0] = { proto = 18 },
                [1] = { proto = 19 },
                [2] = { proto = 20 },
                [3] = { proto = 21 },
                [4] = { proto = 22 },
                [5] = { proto = 23 },
                [6] = { proto = 24 },
                [7] = { proto = 25 },
                [8] = { proto = 26 },
                [9] = { proto = 27 },
                [10] = { proto = 28 },
                [11] = { proto = 29 },
                [12] = { proto = 30 },
                [13] = { proto = 31 },
                [14] = { proto = 32 },
                [15] = { proto = 33 },
                [16] = { proto = 34 },
                [17] = { proto = 35 },
                [18] = { proto = 36 },
                [19] = { proto = 37 },
            },
        },
        [8] = {
            parent = 6,
            strings = {
                [0] = "ForceField",
                [1] = "Material", -- x2
                [2] = "Parent", -- x2
                [3] = "Rev_DecayTime", -- x4
                [4] = "Effects", -- x26
                [5] = "EnableEqualizer", -- x4
                [6] = "EnableCompressor", -- x4
                [7] = "volume",
                [8] = "masterVolume",
                [9] = "speed",
                [10] = "length",
                [11] = "anchorServerTime",
                [12] = "anchorTimePos",
                [13] = "Enabled",
                [14] = "MusicZonePart", -- x2
                [15] = "Name", -- x2
                [16] = "Anchored", -- x2
                [17] = "EnableReverb", -- x4
                [18] = "EQ_LowGain", -- x4
                [19] = "CenzStore",
                [20] = "ExpectedNames",
                [21] = "Server", -- x2
                [22] = "MusicZone",
                [23] = "ContentProvider",
                [24] = "game", -- x3
                [25] = "GetService", -- x3
                [26] = "Players",
                [27] = "EQ_MidGain", -- x4
                [28] = "EQ_HighGain", -- x4
                [29] = "isActive", -- x2
                [30] = "startTime",
                [31] = "endTime",
                [32] = "ipairs",
                [33] = "FindFirstChild", -- x9
                [34] = "Remotes", -- x5
                [35] = "State",
                [36] = "Preload",
                [37] = "VoteState",
                [38] = "CFrame", -- x2
                [39] = "new", -- x4
                [40] = "Rev_Density", -- x4
                [41] = "Rev_WetLevel", -- x4
                [42] = "CanCollide", -- x2
                [43] = "Vector3",
                [44] = "currentPartIndex",
                [45] = "totalParts",
                [46] = "playbackSpeed",
                [47] = "totalLength",
                [48] = "partLengths",
                [49] = "accumulatedTime",
                [50] = "Size",
                [51] = "MusicSystemFolder", -- x2
                [52] = "votes",
                [53] = "votesRequired",
                [54] = "eligibleVoters",
                [55] = "initiatedBy",
                [56] = "Comp_Attack", -- x4
                [57] = "Comp_Release", -- x4
                [58] = "warn", -- x2
                [59] = "[CenzMusicServer] Validation Error: ",
                [60] = "workspace", -- x2
                [61] = "CenzConfig",
                [62] = "print",
                [63] = "CENZ STUDIO MUSIC SYSTEM SERVER ACTIVE",
                [64] = "Comp_Threshold", -- x4
                [65] = "Comp_Ratio", -- x4
                [66] = "RemoteFolder",
                [67] = "Connect", -- x3
                [68] = "SetExternalDJCheck",
                [69] = "fromRGB",
                [70] = "Color",
                [71] = "Enum",
                [72] = "ReplicatedStorage",
                [73] = "IsA",
                [74] = "Folder", -- x2
                [75] = "[CenzMusicServer] CenzModules folder not found!",
                [76] = "currentName",
                [77] = "No music playing",
                [78] = "currentAddedBy",
                [79] = "currentImageId",
                [80] = "isPlaying",
                [81] = "DefaultVolume",
                [82] = "Transparency",
                [83] = "Color3",
                [84] = "task", -- x3
                [85] = "initiatedByUserId",
                [86] = "trackName", -- x2
                [87] = "", -- x3
                [88] = "MaxCacheSize",
                [89] = "currentId",
                [90] = "0",
                [91] = "RequestState",
                [92] = "Command",
                [93] = "Instance", -- x2
                [94] = "trackImageId",
                [95] = "delay",
                [96] = "SetMasterVolume",
                [97] = "OnServerEvent", -- x2
                [98] = "WaitForChild",
                [99] = "CenzMusicRS",
                [100] = "musicZoneEnabled",
                [101] = "Mode",
                [102] = "musicZoneMode",
                [103] = "djModeActive",
                [104] = "spawn", -- x2
                [105] = "trackAddedBy",
                [106] = "soundIds",
                [107] = "PlayerRemoving",
                [108] = "DJLibrary",
                [109] = "Client",
                [110] = "Audio",
                [111] = "Part",
                [112] = "SetEffectValue",
                [113] = "SetSpeed",
                [114] = "SetVolume",
                [115] = "Voting",
                [116] = "OnLibraryChanged",
                [117] = "OnRosterChanged",
                [118] = "OnProfileLoaded",
            },
            booleans = {
                [0] = true, -- x6
                [1] = false, -- x7
            },
            proto_references = {
                [0] = { proto = 38 },
                [1] = { proto = 39 },
                [2] = { proto = 40 },
                [3] = { proto = 41 },
                [4] = { proto = 42 },
                [5] = { proto = 43 },
                [6] = { proto = 44 },
                [7] = { proto = 45 },
                [8] = { proto = 46 },
                [9] = { proto = 47 },
                [10] = { proto = 48 },
                [11] = { proto = 49 },
                [12] = { proto = 50 },
                [13] = { proto = 51 },
                [14] = { proto = 52 },
                [15] = { proto = 53 },
                [16] = { proto = 54 },
                [17] = { proto = 55 },
                [18] = { proto = 56 },
                [19] = { proto = 57 },
                [20] = { proto = 58 },
                [21] = { proto = 59 },
                [22] = { proto = 60 },
                [23] = { proto = 61 },
                [24] = { proto = 62 },
                [25] = { proto = 63 },
                [26] = { proto = 64 },
                [27] = { proto = 65 },
                [28] = { proto = 66 },
                [29] = { proto = 67 },
                [30] = { proto = 68 },
                [31] = { proto = 69 },
                [32] = { proto = 70 },
                [33] = { proto = 71 },
                [34] = { proto = 72 },
                [35] = { proto = 73 },
                [36] = { proto = 74 },
                [37] = { proto = 75 },
                [38] = { proto = 76 },
                [39] = { proto = 77 },
                [40] = { proto = 78 },
                [41] = { proto = 79 },
                [42] = { proto = 80 },
                [43] = { proto = 81 },
                [44] = { proto = 82 },
                [45] = { proto = 83 },
                [46] = { proto = 84 },
                [47] = { proto = 85 },
                [48] = { proto = 86 },
                [49] = { proto = 87 },
                [50] = { proto = 88 },
                [51] = { proto = 89 },
                [52] = { proto = 90 },
                [53] = { proto = 91 },
                [54] = { proto = 92 },
                [55] = { proto = 93 },
                [56] = { proto = 94 },
                [57] = { proto = 95 },
                [58] = { proto = 96 },
                [59] = { proto = 97 },
                [60] = { proto = 98 },
                [61] = { proto = 99 },
                [62] = { proto = 100 },
                [63] = { proto = 101 },
                [64] = { proto = 102 },
                [65] = { proto = 103 },
                [66] = { proto = 104 },
                [67] = { proto = 105 },
                [68] = { proto = 106 },
                [69] = { proto = 107 },
                [70] = { proto = 108 },
            },
        },
        [9] = {
            parent = 6,
            strings = {
                [0] = "error",
                [1] = "tostring",
                [2] = "[CENZ] unknown virtual module: ",
            },
        },
        [10] = {
            parent = 6,
            strings = {
                [0] = "__index",
                [1] = "setmetatable",
            },
            proto_references = {
                [0] = { proto = 109 },
            },
        },
        [11] = {
            parent = 6,
            strings = {
                [0] = "IsAlwaysDJ",
                [1] = "Notification", -- x6
                [2] = "Enabled", -- x6
                [3] = "WaitForChild",
                [4] = "CenzMusicRS", -- x2
                [5] = "GetService", -- x3
                [6] = "MarketplaceService",
                [7] = "game", -- x3
                [8] = "GamepassID",
                [9] = "MaxSongQueue",
                [10] = "BypassDJMode",
                [11] = "BypassCooldown",
                [12] = "GetDJPrefix",
                [13] = "MusicSystemFolder",
                [14] = "CenzMusicSystem", -- x2
                [15] = "MusicZonePart",
                [16] = "MusicZone", -- x7
                [17] = "MainSound",
                [18] = "Voting", -- x10
                [19] = "MinVotesRequired", -- x3
                [20] = "Audio", -- x16
                [21] = "EQ_MidGain", -- x3
                [22] = "EQ_HighGain", -- x3
                [23] = "Comp_Attack", -- x3
                [24] = "Comp_Threshold", -- x3
                [25] = "Rev_DecayTime", -- x3
                [26] = "Rev_Density", -- x3
                [27] = "EnableEqualizer", -- x3
                [28] = "EnableCompressor", -- x3
                [29] = "EnableReverb", -- x3
                [30] = "BroadcastVoteNotification", -- x3
                [31] = "EQ_LowGain", -- x3
                [32] = "DefaultVolume", -- x3
                [33] = "AllowCustomSongID",
                [34] = "GetPlayerDisplayName",
                [35] = "VoteTimer", -- x3
                [36] = "SkipVoteCooldown", -- x3
                [37] = "RequiredPercentage", -- x3
                [38] = "MaxVotesRequired", -- x3
                [39] = "WhoCanStartVote", -- x3
                [40] = "everyone",
                [41] = "UseZoneForVoting", -- x3
                [42] = "VoteState",
                [43] = "CenzDJ_VoteState",
                [44] = "Remotes",
                [45] = "Success",
                [46] = "SuccessSound",
                [47] = "Error",
                [48] = "ErrorSound",
                [49] = "Sounds",
                [50] = "Gamepass",
                [51] = "RestrictQueue",
                [52] = "MaxGroupQueues",
                [53] = "MaxNonGroupQueues",
                [54] = "IsSuperAdmin",
                [55] = "CanPlayerControlMusic",
                [56] = "CanPlayerStartVote",
                [57] = "Mode", -- x3
                [58] = "Rev_WetLevel", -- x3
                [59] = "Effects",
                [60] = "RemoteWait",
                [61] = "Timeouts",
                [62] = "Client",
                [63] = "FadeDistance", -- x2
                [64] = "MaxDistanceFromZone",
                [65] = "MinVolume", -- x2
                [66] = "MinVolumeAtEdge",
                [67] = "FadeCurveExponent",
                [68] = "FadeSettings",
                [69] = "TransitionDuration",
                [70] = "StrictSettings",
                [71] = "CanPlayerUseDJSystem",
                [72] = "AutoPlayCount", -- x2
                [73] = "AutoFillCount",
                [74] = "Queue", -- x4
                [75] = "AutoPlayEnabled", -- x3
                [76] = "AutoFillOnStartup",
                [77] = "Server",
                [78] = "DJCheckMode",
                [79] = "role",
                [80] = "GroupRoleID",
                [81] = "MinimumRank",
                [82] = "AlwaysDJUserIds",
                [83] = "DJBypassCooldown",
                [84] = "DJ", -- x2
                [85] = "GroupID",
                [86] = "Group",
                [87] = "EnableSound", -- x3
                [88] = "Players",
                [89] = "FindFirstChild",
                [90] = "CenzUserConfig", -- x2
                [91] = "VolumeLerp",
                [92] = "Comp_Release", -- x3
                [93] = "Comp_Ratio", -- x3
                [94] = "IsGroupMemberOnly",
                [95] = "strict",
                [96] = "ZoneVolume",
                [97] = "Connect",
                [98] = "GuiName",
                [99] = "CenzMusicPlayerGui",
                [100] = "ExpectedNames",
                [101] = "DefaultTrackLength",
                [102] = "PreloadTimeout",
                [103] = "MaxCacheSize",
                [104] = "PlayerRemoving",
                [105] = "ConfigModule",
                [106] = "CenzConfig",
                [107] = "UserConfigModule",
                [108] = "GUIBuilder",
                [109] = "CenzGUIBuilder",
                [110] = "UserConfig",
                [111] = "ServerScript",
                [112] = "CenzMusicServer",
                [113] = "ClientScript",
                [114] = "CenzMusicClient",
                [115] = "ModulesFolder",
                [116] = "pcall",
                [117] = "RemoteFolder",
                [118] = "CenzRemotes",
                [119] = "SFXFolder",
                [120] = "CenzSFX",
                [121] = "SetExternalDJCheck",
                [122] = "InvalidateDJCache",
                [123] = "GetMaxQueue",
                [124] = "CanBypassCooldown",
                [125] = "IsDJ",
                [126] = "HasGamepass",
                [127] = "ModulesSubFolder",
                [128] = "CenzMusicModules",
                [129] = "ProfileStore", -- x2
                [130] = "DJLibrary",
                [131] = "CenzDJLibrary",
                [132] = "ReplicatedStorage",
                [133] = "RequestState",
                [134] = "CenzDJ_RequestState",
                [135] = "Command",
                [136] = "CenzDJ_Command",
                [137] = "State",
                [138] = "CenzDJ_State",
                [139] = "Preload",
                [140] = "CenzDJ_Preload",
                [141] = "Prefix",
                [142] = "PrefixColor",
                [143] = "#FF0000",
                [144] = "DJModeEnabled",
                [145] = "IsGameOwner",
                [146] = "CanPlayerQueueSong",
                [147] = "CanPlayerSkip",
                [148] = "IsGroupMember",
                [149] = "AutoFillEnabled",
            },
            booleans = {
                [0] = false, -- x5
                [1] = true, -- x12
            },
            proto_references = {
                [0] = { proto = 110 },
                [1] = { proto = 111 },
                [2] = { proto = 112 },
                [3] = { proto = 113 },
                [4] = { proto = 114 },
                [5] = { proto = 115 },
                [6] = { proto = 116 },
                [7] = { proto = 117 },
                [8] = { proto = 118 },
                [9] = { proto = 119 },
                [10] = { proto = 120 },
                [11] = { proto = 121 },
                [12] = { proto = 122 },
                [13] = { proto = 123 },
                [14] = { proto = 124 },
                [15] = { proto = 125 },
                [16] = { proto = 126 },
                [17] = { proto = 127 },
                [18] = { proto = 128 },
                [19] = { proto = 129 },
                [20] = { proto = 130 },
                [21] = { proto = 131 },
                [22] = { proto = 132 },
                [23] = { proto = 133 },
            },
        },
        [12] = {
            parent = 6,
            strings = {
                [0] = "setmetatable",
                [1] = "__tostring",
                [2] = "__index",
            },
            proto_references = {
                [0] = { proto = 134 },
                [1] = { proto = 135 },
            },
        },
        [13] = {
            parent = 6,
            strings = {
                [0] = "require",
            },
        },
        [14] = {
            parent = 6,
            strings = {
                [0] = "bxor",
                [1] = "bnot",
                [2] = "lshift",
                [3] = "rshift",
                [4] = "verify",
                [5] = "decryptHex",
                [6] = "table",
                [7] = "freeze",
                [8] = "bit32",
                [9] = "band",
                [10] = "bor",
                [11] = "hexToBytes",
                [12] = "strToBytes",
                [13] = "bytesToHex",
                [14] = "sha512Hex",
            },
            proto_references = {
                [0] = { proto = 136 },
                [1] = { proto = 137 },
                [2] = { proto = 138 },
                [3] = { proto = 139 },
                [4] = { proto = 140 },
                [5] = { proto = 141 },
                [6] = { proto = 142 },
                [7] = { proto = 143 },
                [8] = { proto = 144 },
                [9] = { proto = 145 },
                [10] = { proto = 146 },
                [11] = { proto = 147 },
                [12] = { proto = 148 },
                [13] = { proto = 149 },
                [14] = { proto = 150 },
                [15] = { proto = 151 },
                [16] = { proto = 152 },
                [17] = { proto = 153 },
                [18] = { proto = 154 },
                [19] = { proto = 155 },
                [20] = { proto = 156 },
                [21] = { proto = 157 },
                [22] = { proto = 158 },
                [23] = { proto = 159 },
                [24] = { proto = 160 },
                [25] = { proto = 161 },
                [26] = { proto = 162 },
                [27] = { proto = 163 },
                [28] = { proto = 164 },
                [29] = { proto = 165 },
                [30] = { proto = 166 },
                [31] = { proto = 167 },
                [32] = { proto = 168 },
                [33] = { proto = 169 },
                [34] = { proto = 170 },
                [35] = { proto = 171 },
            },
        },
        [15] = {
            parent = 6,
            strings = {
                [0] = "_b64ToHex",
                [1] = "freeze",
                [2] = "game",
                [3] = "GetService",
                [4] = "HttpService",
                [5] = "check",
                [6] = "startHeartbeat",
                [7] = "reportTamper",
                [8] = "table",
                [9] = "string",
                [10] = "sub",
                [11] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
            },
            proto_references = {
                [0] = { proto = 172 },
                [1] = { proto = 173 },
                [2] = { proto = 174 },
                [3] = { proto = 175 },
                [4] = { proto = 176 },
                [5] = { proto = 177 },
            },
        },
        [16] = {
            parent = 6,
        },
        [17] = {
            parent = 6,
            strings = {
                [0] = "Players",
                [1] = "ipairs",
                [2] = "pcall", -- x2
                [3] = "PlayerAdded",
                [4] = "Connect",
                [5] = "GetPlayers",
                [6] = "game",
                [7] = "GetService",
            },
            proto_references = {
                [0] = { proto = 178 },
                [1] = { proto = 179 },
                [2] = { proto = 180 },
            },
        },
        [18] = {
            parent = 7,
            strings = {
                [0] = "EndSession",
            },
        },
        [19] = {
            parent = 7,
            strings = {
                [0] = "IsActive",
                [1] = "Data",
                [2] = "Favorites",
            },
        },
        [20] = {
            parent = 7,
            strings = {
                [0] = "Data", -- x2
                [1] = "Favorites", -- x2
                [2] = "IsActive",
                [3] = "type",
                [4] = "persistenceOff",
                [5] = "ipairs",
                [6] = "table", -- x3
                [7] = "insert",
                [8] = "remove",
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
        },
        [21] = {
            parent = 7,
            strings = {
                [0] = "OnRosterChanged", -- x2
                [1] = "djs", -- x2
                [2] = "Roster", -- x2
                [3] = "DJRoster",
                [4] = "type", -- x2
                [5] = "table", -- x2
            },
        },
        [22] = {
            parent = 7,
            strings = {
                [0] = "OnLibraryChanged", -- x2
                [1] = "persistenceOff",
                [2] = "tracks",
                [3] = "storeError", -- x2
                [4] = "CustomTracks",
                [5] = "library",
                [6] = "pcall",
                [7] = "Ready",
            },
            booleans = {
                [0] = false, -- x3
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 181 },
            },
        },
        [23] = {
            parent = 7,
            strings = {
                [0] = "addedBy", -- x2
                [1] = "userId",
                [2] = "type", -- x2
                [3] = "table", -- x4
                [4] = "User ",
                [5] = "pairs",
                [6] = "Roster",
                [7] = "name", -- x2
                [8] = "insert",
                [9] = "tonumber",
                [10] = "Unknown",
                [11] = "sort",
            },
            proto_references = {
                [0] = { proto = 182 },
            },
        },
        [24] = {
            parent = 7,
            strings = {
                [0] = "IsA",
                [1] = "ModuleScript",
                [2] = "FindFirstChild", -- x3
                [3] = "ModulesFolder",
                [4] = "ModulesSubFolder",
                [5] = "type",
                [6] = "table",
                [7] = "ProfileStore",
                [8] = "pcall",
            },
            proto_references = {
                [0] = { proto = 183 },
            },
        },
        [25] = {
            parent = 7,
            strings = {
                [0] = "DataStore tidak tersedia (Studio: aktifkan 'Enable Studio Access to API Services').",
                [1] = "ipairs",
                [2] = "GetPlayers",
                [3] = "task",
                [4] = "spawn",
                [5] = "RefreshRoster",
                [6] = "pcall", -- x4
                [7] = "Ready",
                [8] = "RefreshLibrary",
                [9] = "PlayerRemoving",
                [10] = "Connect", -- x2
                [11] = "ProfileStore",
                [12] = " -> fitur favorite dimatikan.",
                [13] = ".", -- x2
                [14] = "PlayerAdded",
                [15] = "[CenzStore] ProfileStore tidak ditemukan di ",
                [16] = "warn",
                [17] = "ModulesFolder",
                [18] = "ModulesSubFolder",
                [19] = "DataStore tidak bisa diakses (Studio: aktifkan 'Enable Studio Access to API Services').",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 184 },
                [1] = { proto = 185 },
                [2] = { proto = 186 },
                [3] = { proto = 187 },
                [4] = { proto = 188 },
                [5] = { proto = 189 },
                [6] = { proto = 190 },
            },
        },
        [26] = {
            parent = 7,
            strings = {
                [0] = "Roster",
                [1] = "roster",
                [2] = "storeError", -- x2
                [3] = "OnRosterChanged", -- x2
                [4] = "persistenceOff",
                [5] = "djs",
                [6] = "Ready",
                [7] = "tostring",
                [8] = "pcall",
            },
            booleans = {
                [0] = true,
                [1] = false, -- x3
            },
            proto_references = {
                [0] = { proto = 191 },
            },
        },
        [27] = {
            parent = 7,
            strings = {
                [0] = "AssetTypeId",
                [1] = "tonumber",
                [2] = "Name",
                [3] = "name",
                [4] = "invalidAudio",
                [5] = "lookupFailed",
                [6] = "table",
                [7] = "notAudio",
                [8] = "type",
                [9] = "pcall",
            },
            proto_references = {
                [0] = { proto = 192 },
            },
        },
        [28] = {
            parent = 7,
            strings = {
                [0] = "CustomTracks",
                [1] = "library",
                [2] = "OnLibraryChanged", -- x2
                [3] = "persistenceOff",
                [4] = "pcall",
                [5] = "storeError", -- x2
                [6] = "tracks",
                [7] = "Ready",
            },
            booleans = {
                [0] = false, -- x3
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 193 },
            },
        },
        [29] = {
            parent = 7,
            strings = {
                [0] = "IsActive",
                [1] = "Data", -- x3
                [2] = "LikedAlbums", -- x3
                [3] = "table",
                [4] = "type",
            },
        },
        [30] = {
            parent = 7,
            strings = {
                [0] = "table", -- x3
                [1] = "remove",
                [2] = "IsActive",
                [3] = "persistenceOff",
                [4] = "Data", -- x2
                [5] = "LikedAlbums", -- x2
                [6] = "ipairs",
                [7] = "type",
                [8] = "insert",
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [31] = {
            parent = 7,
            strings = {
                [0] = "warn",
                [1] = "[CenzStore] ",
            },
            booleans = {
                [0] = true,
            },
        },
        [32] = {
            parent = 7,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 194 },
            },
        },
        [33] = {
            parent = 7,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 195 },
            },
        },
        [34] = {
            parent = 7,
            strings = {
                [0] = "table", -- x2
                [1] = "type", -- x2
                [2] = "OnLibraryChanged", -- x2
                [3] = "tracks", -- x2
                [4] = "CustomTracks", -- x2
                [5] = "Library",
            },
        },
        [35] = {
            parent = 7,
            strings = {
                [0] = "Roster",
                [1] = "tostring",
            },
            booleans = {
                [0] = false,
            },
        },
        [36] = {
            parent = 7,
            strings = {
                [0] = "OnRosterChanged", -- x2
                [1] = "tostring",
                [2] = "pcall",
                [3] = "storeError", -- x2
                [4] = "Ready",
                [5] = "persistenceOff",
                [6] = "djs",
                [7] = "Roster",
                [8] = "roster",
            },
            booleans = {
                [0] = true,
                [1] = false, -- x3
            },
            proto_references = {
                [0] = { proto = 196 },
            },
        },
        [37] = {
            parent = 7,
            strings = {
                [0] = "EndSession",
                [1] = "StartSessionAsync",
                [2] = "OnProfileLoaded", -- x2
                [3] = "UserId", -- x2
                [4] = "Player_",
                [5] = "Cancel",
                [6] = "Reconcile",
                [7] = "OnSessionEnd",
                [8] = "Connect",
                [9] = "Parent",
                [10] = "AddUserId",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 197 },
                [1] = { proto = 198 },
            },
        },
        [38] = {
            parent = 8,
            strings = {
                [0] = "GetMaxQueue",
                [1] = "accessDenied", -- x2
                [2] = "CanPlayerUseDJSystem",
                [3] = "djRoster",
                [4] = "Ready",
                [5] = "persistenceReady",
                [6] = "GetLikedAlbums",
                [7] = "likedAlbums",
                [8] = "IsSuperAdmin",
                [9] = "favorites",
                [10] = "math",
                [11] = "huge",
                [12] = "maxQueue",
                [13] = "remainingSlots",
                [14] = "customTracks",
                [15] = "GetFavorites",
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
        },
        [39] = {
            parent = 8,
            strings = {
                [0] = "task",
                [1] = "defer",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 199 },
            },
        },
        [40] = {
            parent = 8,
            strings = {
                [0] = "SetAttribute", -- x7
                [1] = "DJ_CurrentId",
                [2] = "currentId",
                [3] = "DJ_CurrentName",
                [4] = "currentName",
                [5] = "DJ_DJModeActive",
                [6] = "djModeActive",
                [7] = "DJ_MasterVolume",
                [8] = "masterVolume",
                [9] = "DJ_IsPlaying",
                [10] = "isPlaying",
                [11] = "DJ_Volume",
                [12] = "volume",
                [13] = "DJ_Speed",
                [14] = "speed",
            },
        },
        [41] = {
            parent = 8,
            strings = {
                [0] = "currentAddedBy", -- x2
                [1] = "currentImageId", -- x2
                [2] = "isPlaying", -- x2
                [3] = "volume", -- x2
                [4] = "pairs",
                [5] = "isDJ",
                [6] = "IsSuperAdmin",
                [7] = "djModeActive", -- x2
                [8] = "IsDJ",
                [9] = "isSuperAdmin",
                [10] = "effects",
                [11] = "totalParts", -- x2
                [12] = "accumulatedTime", -- x2
                [13] = "masterVolume", -- x2
                [14] = "speed", -- x2
                [15] = "length", -- x2
                [16] = "anchorServerTime", -- x2
                [17] = "anchorTimePos", -- x2
                [18] = "queue",
                [19] = "isActive",
                [20] = "isMultiPart",
                [21] = "currentPartIndex", -- x2
                [22] = "musicZoneEnabled", -- x2
                [23] = "musicZoneMode", -- x2
                [24] = "FireClient",
                [25] = "currentId", -- x2
                [26] = "currentName", -- x2
            },
        },
        [42] = {
            parent = 8,
            strings = {
                [0] = "tostring", -- x2
                [1] = "match", -- x2
                [2] = "^(%d+)$",
                [3] = "", -- x3
                [4] = "rbxassetid://(%d+)",
            },
        },
        [43] = {
            parent = 8,
            strings = {
                [0] = "", -- x2
                [1] = "0",
            },
            booleans = {
                [0] = false,
            },
        },
        [44] = {
            parent = 8,
            strings = {
                [0] = "tostring",
                [1] = "gsub",
                [2] = "%s+",
                [3] = "",
                [4] = "match",
                [5] = "^%d+$",
            },
        },
        [45] = {
            parent = 8,
            strings = {
                [0] = "anchorTimePos",
                [1] = "anchorServerTime",
                [2] = "math",
                [3] = "max",
            },
        },
        [46] = {
            parent = 8,
            strings = {
                [0] = "currentId",
                [1] = "0",
                [2] = "currentName",
                [3] = "No music playing",
                [4] = "currentAddedBy",
                [5] = "Server",
                [6] = "currentImageId",
                [7] = "isPlaying",
                [8] = "length",
                [9] = "anchorServerTime",
                [10] = "anchorTimePos",
            },
            booleans = {
                [0] = false,
            },
        },
        [47] = {
            parent = 8,
            strings = {
                [0] = "tostring", -- x3
                [1] = "Id", -- x4
                [2] = "User ", -- x3
                [3] = "displayName", -- x2
                [4] = "ipairs", -- x3
                [5] = "pcall",
                [6] = "Username", -- x2
                [7] = "table", -- x2
                [8] = "insert",
                [9] = "username", -- x2
                [10] = "DisplayName",
                [11] = "type",
            },
            proto_references = {
                [0] = { proto = 200 },
            },
        },
        [48] = {
            parent = 8,
            strings = {
                [0] = "tonumber",
                [1] = "table", -- x3
                [2] = "insert", -- x3
                [3] = "tostring",
                [4] = "userId", -- x7
                [5] = "User ",
                [6] = "ipairs", -- x4
                [7] = "UserConfig",
                [8] = "DJ",
                [9] = "AlwaysDJUserIds",
                [10] = "displayName", -- x2
                [11] = "addedBy", -- x3
                [12] = "CenzUserConfig",
                [13] = "protected", -- x2
                [14] = "username",
                [15] = "name", -- x2
                [16] = "GetRosterList",
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
        },
        [49] = {
            parent = 8,
            strings = {
                [0] = "customTracks",
                [1] = "FireAllClients",
                [2] = "notification",
                [3] = "libraryChanged",
            },
        },
        [50] = {
            parent = 8,
            strings = {
                [0] = "id", -- x3
                [1] = "soundIds", -- x3
                [2] = "ipairs",
                [3] = "currentId", -- x3
                [4] = "UserId",
                [5] = "0",
                [6] = "FireClient", -- x3
            },
        },
        [51] = {
            parent = 8,
            strings = {
                [0] = "Audio ",
                [1] = "currentAddedBy", -- x2
                [2] = "currentImageId",
                [3] = "speed",
                [4] = "task", -- x2
                [5] = "defer", -- x2
                [6] = "Server",
                [7] = "partIndex",
                [8] = "totalParts",
                [9] = "math",
                [10] = "clamp",
                [11] = "imageId",
                [12] = "addedBy",
                [13] = "isMultiPart",
                [14] = "totalLength",
                [15] = "length", -- x2
                [16] = "currentId",
                [17] = "notification",
                [18] = "nowPlaying",
                [19] = "currentName", -- x2
                [20] = "trackName",
                [21] = "trackId",
                [22] = "FireAllClients",
                [23] = "isPlaying",
            },
            booleans = {
                [0] = true,
            },
        },
        [52] = {
            parent = 8,
            strings = {
                [0] = "trackAddedBy",
                [1] = "trackImageId",
                [2] = "playbackSpeed",
                [3] = "currentPartIndex", -- x4
                [4] = "totalParts", -- x3
                [5] = "defer", -- x3
                [6] = "task", -- x3
                [7] = "accumulatedTime", -- x2
                [8] = "soundIds", -- x2
                [9] = "trackName",
                [10] = "partLengths",
                [11] = "isActive",
            },
            booleans = {
                [0] = true,
            },
        },
        [53] = {
            parent = 8,
            strings = {
                [0] = "trackName",
                [1] = "trackImageId",
                [2] = "playbackSpeed",
                [3] = "totalLength",
                [4] = "partLengths",
                [5] = "Server",
                [6] = "isActive", -- x2
                [7] = "Unknown Track",
                [8] = "trackAddedBy",
                [9] = "soundIds",
                [10] = "currentPartIndex",
                [11] = "totalParts",
                [12] = "task", -- x2
                [13] = "defer", -- x2
                [14] = "accumulatedTime",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 201 },
            },
        },
        [54] = {
            parent = 8,
            strings = {
                [0] = "currentPartIndex",
                [1] = "totalParts",
                [2] = "playbackSpeed",
                [3] = "totalLength",
                [4] = "partLengths",
                [5] = "accumulatedTime",
                [6] = "isActive",
                [7] = "trackName",
                [8] = "", -- x2
                [9] = "trackImageId",
                [10] = "trackAddedBy",
                [11] = "soundIds",
            },
            booleans = {
                [0] = false,
            },
        },
        [55] = {
            parent = 8,
            strings = {
                [0] = "GetMaxQueue",
                [1] = "math",
                [2] = "max",
                [3] = "CanBypassCooldown",
            },
        },
        [56] = {
            parent = 8,
            strings = {
                [0] = "Z", -- x4
                [1] = "FindFirstChild",
                [2] = "HumanoidRootPart",
                [3] = "Position", -- x2
                [4] = "Size",
                [5] = "X", -- x4
                [6] = "Y", -- x4
                [7] = "Character",
                [8] = "Enabled",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false, -- x2
            },
        },
        [57] = {
            parent = 8,
            strings = {
                [0] = "table",
                [1] = "insert",
                [2] = "ipairs",
                [3] = "GetPlayers",
            },
        },
        [58] = {
            parent = 8,
            strings = {
                [0] = "GetPlayers",
                [1] = "UseZoneForVoting",
                [2] = "Enabled",
            },
        },
        [59] = {
            parent = 8,
            strings = {
                [0] = "pairs",
                [1] = "votes",
            },
        },
        [60] = {
            parent = 8,
            strings = {
                [0] = "math", -- x5
                [1] = "min", -- x2
                [2] = "ceil",
                [3] = "RequiredPercentage",
                [4] = "MaxVotesRequired",
                [5] = "max", -- x2
                [6] = "MinVotesRequired",
            },
        },
        [61] = {
            parent = 8,
            strings = {
                [0] = "initiatorUserId",
                [1] = "os",
                [2] = "clock",
                [3] = "math",
                [4] = "max",
                [5] = "endTime",
                [6] = "FireAllClients",
                [7] = "timeRemaining",
                [8] = "trackName", -- x2
                [9] = "initiatedBy", -- x2
                [10] = "initiatedByUserId",
                [11] = "isActive", -- x3
                [12] = "voteCount",
                [13] = "votesRequired", -- x2
                [14] = "eligibleVoters", -- x2
            },
        },
        [62] = {
            parent = 8,
            strings = {
                [0] = "isActive", -- x3
                [1] = "voteCount",
                [2] = "votesRequired", -- x2
                [3] = "eligibleVoters", -- x2
                [4] = "FireClient",
                [5] = "timeRemaining",
                [6] = "trackName", -- x2
                [7] = "initiatedBy", -- x2
                [8] = "initiatedByUserId",
                [9] = "initiatorUserId",
                [10] = "votes",
                [11] = "UserId",
                [12] = "pairs",
                [13] = "math",
                [14] = "max",
                [15] = "endTime",
                [16] = "os",
                [17] = "clock",
                [18] = "hasVoted",
            },
            booleans = {
                [0] = true,
            },
        },
        [63] = {
            parent = 8,
            strings = {
                [0] = "PreloadTimeout",
                [1] = "rbxassetid://",
                [2] = "SoundId",
                [3] = "TimeLength", -- x2
                [4] = "Destroy", -- x2
                [5] = "task",
                [6] = "wait",
                [7] = "Parent",
                [8] = "pcall",
                [9] = "Instance",
                [10] = "new",
                [11] = "Sound",
                [12] = "Volume",
            },
            proto_references = {
                [0] = { proto = 202 },
            },
        },
        [64] = {
            parent = 8,
            strings = {
                [0] = "task",
                [1] = "spawn",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 203 },
            },
        },
        [65] = {
            parent = 8,
            strings = {
                [0] = "",
                [1] = "FireAllClients",
                [2] = "0",
            },
        },
        [66] = {
            parent = 8,
            strings = {
                [0] = "ipairs",
            },
        },
        [67] = {
            parent = 8,
            strings = {
                [0] = "currentId", -- x4
                [1] = "0", -- x4
                [2] = "error", -- x44
                [3] = "djOnly", -- x10
                [4] = "IsDJ", -- x14
                [5] = "success", -- x7
                [6] = "albumLikeToggled",
                [7] = "albumName",
                [8] = "isLiked",
                [9] = "masterVolume",
                [10] = "invalidIndex",
                [11] = "Play", -- x2
                [12] = "cannotSkip",
                [13] = "soundIds", -- x6
                [14] = "GetAudioInfo",
                [15] = "notAudio", -- x2
                [16] = "notification", -- x6
                [17] = "queueRemoved",
                [18] = "GetPlayerDisplayName", -- x5
                [19] = "djName", -- x7
                [20] = "name", -- x10
                [21] = "pcall", -- x2
                [22] = "boolean",
                [23] = "djModeActive", -- x11
                [24] = "typeof",
                [25] = "djModeChanged",
                [26] = "DisplayName", -- x4
                [27] = "effects", -- x4
                [28] = "gsub", -- x8
                [29] = "^%s+", -- x4
                [30] = "", -- x19
                [31] = "type", -- x10
                [32] = "speed", -- x3
                [33] = "number",
                [34] = "SetSpeed", -- x2
                [35] = "Custom",
                [36] = "PlayNow", -- x2
                [37] = "notInLibrary", -- x4
                [38] = "huge", -- x4
                [39] = "CastVote",
                [40] = "librarySaved",
                [41] = "imageId", -- x8
                [42] = "collection", -- x5
                [43] = "favoriteId",
                [44] = "isFavorite",
                [45] = "GetFavorites",
                [46] = "Unknown Track",
                [47] = "string", -- x8
                [48] = "sub", -- x2
                [49] = "ON",
                [50] = "removedTrack", -- x2
                [51] = "PlayAgain", -- x2
                [52] = "queueAdded",
                [53] = "isMultiPart", -- x4
                [54] = "id", -- x7
                [55] = "djAdded",
                [56] = "userNotFound",
                [57] = "math", -- x17
                [58] = "addedAt",
                [59] = "ToggleFavorite",
                [60] = "album", -- x2
                [61] = "clamp", -- x6
                [62] = "invalidUser", -- x3
                [63] = "favoriteToggled",
                [64] = "DJ Mode is now ",
                [65] = "message",
                [66] = "accessDenied",
                [67] = "tonumber", -- x7
                [68] = "value", -- x5
                [69] = "table", -- x6
                [70] = "Name", -- x4
                [71] = "isPlaying", -- x4
                [72] = "Pause", -- x2
                [73] = "invalidAudio", -- x2
                [74] = "Unknown",
                [75] = "addedTrack",
                [76] = "remainingSlots",
                [77] = "maxQueue", -- x2
                [78] = "SetVolume", -- x2
                [79] = "title", -- x2
                [80] = "storeError", -- x6
                [81] = "ipairs", -- x4
                [82] = "SetMasterVolume", -- x2
                [83] = "key", -- x2
                [84] = "configDJProtected",
                [85] = "username",
                [86] = "FireAllClients", -- x6
                [87] = "effectsSynced",
                [88] = "skippedTrack",
                [89] = "isCustom",
                [90] = "playbackSpeed", -- x6
                [91] = "duplicateTrack", -- x2
                [92] = "removedIndex",
                [93] = "queueLimit",
                [94] = "GetMaxQueue", -- x2
                [95] = "DJAdd", -- x3
                [96] = "tooFast", -- x3
                [97] = "%s+$", -- x4
                [98] = "AddTrack",
                [99] = "task", -- x5
                [100] = "defer", -- x2
                [101] = "djRemoved",
                [102] = "LibraryAdd",
                [103] = "CanPlayerSkip",
                [104] = "trackName",
                [105] = "trackAddedBy",
                [106] = "trackImageId",
                [107] = "delay", -- x3
                [108] = "effectsReset",
                [109] = "RemoveTrack",
                [110] = "IsSuperAdmin",
                [111] = "AlbumFavoriteToggle",
                [112] = "favorites",
                [113] = "DJRemove",
                [114] = "CanPlayerQueueSong",
                [115] = "RemoveFromQueue",
                [116] = "Audio ",
                [117] = "abs", -- x3
                [118] = "superAdminOnly",
                [119] = "remove",
                [120] = "Skip",
                [121] = "insert", -- x2
                [122] = "isActive", -- x2
                [123] = "effectChanged",
                [124] = "anchorTimePos", -- x3
                [125] = "userId",
                [126] = "voteAlreadyActive",
                [127] = "StartVote",
                [128] = "max", -- x2
                [129] = "SyncEffects",
                [130] = "SetEffectToggle",
                [131] = "op",
                [132] = "OFF",
                [133] = "effectKey",
                [134] = "effectValue",
                [135] = "anchorServerTime", -- x2
                [136] = "volume",
                [137] = "LibraryRemove",
                [138] = "ToggleLikedAlbum",
                [139] = "SetEffectValue",
                [140] = "FavoriteToggle",
                [141] = "pairs", -- x2
                [142] = "os",
                [143] = "time",
                [144] = "ResetEffects",
                [145] = "UserId", -- x2
                [146] = "addedBy", -- x2
                [147] = "floor", -- x2
                [148] = "index",
                [149] = "cannotRemoveStatic",
                [150] = "addedByUserId",
                [151] = "AddDJ",
                [152] = "savedTrack",
                [153] = "libraryRemoved",
                [154] = "duplicateLibrary",
                [155] = "currentName",
                [156] = "djSkip",
                [157] = "RemoveDJ",
                [158] = "AddById", -- x2
                [159] = "col",
                [160] = "ToggleDJMode",
                [161] = "GetLikedAlbums",
                [162] = "likedAlbums",
            },
            booleans = {
                [0] = false,
                [1] = true, -- x3
            },
            proto_references = {
                [0] = { proto = 204 },
                [1] = { proto = 205 },
                [2] = { proto = 206 },
                [3] = { proto = 207 },
                [4] = { proto = 208 },
                [5] = { proto = 209 },
                [6] = { proto = 210 },
            },
        },
        [68] = {
            parent = 8,
            strings = {
                [0] = "table", -- x2
                [1] = "remove",
                [2] = "insert",
            },
        },
        [69] = {
            parent = 8,
            strings = {
                [0] = "table", -- x2
                [1] = "remove",
                [2] = "insert",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false,
            },
        },
        [70] = {
            parent = 8,
            strings = {
                [0] = "ipairs",
                [1] = "UserId",
                [2] = "addedByUserId",
            },
        },
        [71] = {
            parent = 8,
            strings = {
                [0] = "GetMaxQueue",
                [1] = "CanBypassCooldown",
            },
            booleans = {
                [0] = false,
            },
        },
        [72] = {
            parent = 8,
            strings = {
                [0] = "currentId",
                [1] = "0",
                [2] = "task",
                [3] = "delay",
                [4] = "warn",
                [5] = "[CenzMusicServer] No tracks found in DJLibrary!",
            },
            proto_references = {
                [0] = { proto = 211 },
            },
        },
        [73] = {
            parent = 8,
            strings = {
                [0] = "table", -- x4
                [1] = "remove", -- x2
                [2] = "ipairs",
                [3] = "insert", -- x2
            },
            booleans = {
                [0] = true, -- x2
                [1] = false,
            },
        },
        [74] = {
            parent = 8,
            strings = {
                [0] = "table",
                [1] = "remove",
                [2] = "ipairs",
            },
        },
        [75] = {
            parent = 8,
            strings = {
                [0] = "id",
                [1] = "ipairs",
            },
        },
        [76] = {
            parent = 8,
            strings = {
                [0] = "ipairs",
            },
        },
        [77] = {
            parent = 8,
            strings = {
                [0] = "id", -- x2
                [1] = "soundIds", -- x3
                [2] = "ipairs",
                [3] = "math",
                [4] = "min",
            },
        },
        [78] = {
            parent = 8,
            strings = {
                [0] = "playbackSpeed", -- x2
                [1] = "soundIds", -- x5
                [2] = "ipairs",
                [3] = "id", -- x3
                [4] = "table",
                [5] = "insert",
                [6] = "name", -- x2
                [7] = "imageId", -- x2
                [8] = "AutoFillEnabled",
                [9] = "isMultiPart", -- x2
            },
        },
        [79] = {
            parent = 8,
            strings = {
                [0] = "soundIds",
                [1] = "isMultiPart",
                [2] = "id",
                [3] = "partCount",
                [4] = "name",
                [5] = "imageId",
                [6] = "playbackSpeed",
                [7] = "col",
                [8] = "isCustom",
            },
        },
        [80] = {
            parent = 8,
            strings = {
                [0] = "", -- x2
                [1] = "Custom",
                [2] = "collection",
                [3] = "getSoundIds",
                [4] = "name", -- x2
                [5] = "ipairs", -- x3
                [6] = "tracks",
                [7] = "ImageId", -- x2
                [8] = "soundIds",
                [9] = "type",
                [10] = "table", -- x3
                [11] = "imageId",
                [12] = "tonumber", -- x2
                [13] = "playbackSpeed",
                [14] = "insert", -- x2
                [15] = "PlaybackSpeed",
                [16] = "Collections", -- x2
                [17] = "SongName",
                [18] = "CustomTracks",
                [19] = "Audio ", -- x2
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [81] = {
            parent = 8,
        },
        [82] = {
            parent = 8,
            strings = {
                [0] = "currentName", -- x2
                [1] = "isActive",
                [2] = "Audio ",
                [3] = "task", -- x3
                [4] = "defer", -- x3
                [5] = "Server",
                [6] = "currentAddedBy", -- x2
                [7] = "currentImageId",
                [8] = "length",
                [9] = "speed",
                [10] = "trackName",
                [11] = "trackId",
                [12] = "imageId",
                [13] = "addedBy",
                [14] = "type",
                [15] = "table",
                [16] = "FireAllClients",
                [17] = "notification",
                [18] = "nowPlaying",
                [19] = "math",
                [20] = "clamp",
                [21] = "currentId",
                [22] = "isPlaying",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 212 },
            },
        },
        [83] = {
            parent = 8,
            strings = {
                [0] = "table", -- x2
                [1] = "remove", -- x2
                [2] = "task", -- x6
                [3] = "defer", -- x5
                [4] = "Server", -- x2
                [5] = "imageId", -- x4
                [6] = "playbackSpeed", -- x4
                [7] = "soundIds", -- x6
                [8] = "name", -- x4
                [9] = "AutoFillEnabled",
                [10] = "id", -- x4
                [11] = "isActive",
                [12] = "delay",
                [13] = "addedBy", -- x2
            },
            proto_references = {
                [0] = { proto = 213 },
                [1] = { proto = 214 },
            },
        },
        [84] = {
            parent = 8,
            strings = {
                [0] = "workspace",
                [1] = "GetServerTimeNow",
            },
        },
        [85] = {
            parent = 8,
            strings = {
                [0] = "count", -- x4
                [1] = "UserId",
                [2] = "os",
                [3] = "clock",
                [4] = "start", -- x2
            },
            booleans = {
                [0] = true, -- x2
            },
        },
        [86] = {
            parent = 8,
            strings = {
                [0] = "os",
                [1] = "clock",
                [2] = "UserId",
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [87] = {
            parent = 8,
            strings = {
                [0] = "length", -- x2
                [1] = "currentId",
                [2] = "0",
                [3] = "anchorServerTime",
                [4] = "isPlaying", -- x3
                [5] = "isActive",
                [6] = "partLengths",
                [7] = "currentPartIndex",
                [8] = "task",
                [9] = "wait",
                [10] = "speed",
                [11] = "anchorTimePos",
                [12] = "math",
                [13] = "max",
            },
            booleans = {
                [0] = false, -- x2
            },
        },
        [88] = {
            parent = 8,
            strings = {
                [0] = "error", -- x5
                [1] = "noSongPlaying",
                [2] = "votesRequired",
                [3] = "eligibleVoters",
                [4] = "GetPlayerDisplayName",
                [5] = "currentName",
                [6] = "trackName",
                [7] = "task",
                [8] = "spawn",
                [9] = "cooldownTime",
                [10] = "startTime",
                [11] = "os", -- x3
                [12] = "clock", -- x3
                [13] = "VoteTimer",
                [14] = "endTime",
                [15] = "votes",
                [16] = "math",
                [17] = "ceil",
                [18] = "CanPlayerStartVote",
                [19] = "voteAlreadyActive",
                [20] = "isActive", -- x2
                [21] = "currentId",
                [22] = "0",
                [23] = "SkipVoteCooldown",
                [24] = "voteCooldown",
                [25] = "notEnoughPlayers",
                [26] = "required",
                [27] = "current",
                [28] = "cannotStartVote",
                [29] = "initiatedBy",
                [30] = "UserId",
                [31] = "initiatedByUserId",
            },
            booleans = {
                [0] = false, -- x5
                [1] = true, -- x2
            },
            proto_references = {
                [0] = { proto = 215 },
            },
        },
        [89] = {
            parent = 8,
            strings = {
                [0] = "error", -- x3
                [1] = "alreadyVoted",
                [2] = "isActive",
                [3] = "UseZoneForVoting",
                [4] = "Enabled",
                [5] = "votes", -- x2
                [6] = "UserId", -- x2
                [7] = "noActiveVote",
                [8] = "notInZone",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false, -- x3
            },
        },
        [90] = {
            parent = 8,
            strings = {
                [0] = "votes", -- x2
                [1] = "UserId", -- x6
                [2] = "votesRequired",
                [3] = "eligibleVoters",
                [4] = "isActive",
            },
        },
        [91] = {
            parent = 8,
            strings = {
                [0] = "Init",
            },
        },
        [92] = {
            parent = 8,
            strings = {
                [0] = "isActive",
                [1] = "startTime",
                [2] = "endTime",
                [3] = "votes",
                [4] = "votesRequired",
                [5] = "eligibleVoters",
                [6] = "initiatedBy",
                [7] = "initiatedByUserId",
                [8] = "trackName",
                [9] = "",
            },
            booleans = {
                [0] = false,
            },
        },
        [93] = {
            parent = 8,
            strings = {
                [0] = "BroadcastVoteNotification", -- x2
                [1] = "isActive",
                [2] = "Vote skip failed (",
                [3] = "message", -- x2
                [4] = "FireAllClients", -- x2
                [5] = "notification", -- x2
                [6] = "voteSuccess",
                [7] = " votes)", -- x2
                [8] = "Vote skip passed! (",
                [9] = "os", -- x2
                [10] = "clock", -- x2
                [11] = "voteFailed",
                [12] = "votesRequired",
                [13] = "/",
                [14] = "task",
                [15] = "defer",
            },
            proto_references = {
                [0] = { proto = 216 },
            },
        },
        [94] = {
            parent = 8,
            strings = {
                [0] = "votesRequired",
                [1] = "isActive",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true, -- x2
            },
        },
        [95] = {
            parent = 8,
            strings = {
                [0] = "notification",
                [1] = "rosterChanged",
                [2] = "djRoster",
                [3] = "ipairs",
                [4] = "GetPlayers",
                [5] = "FireClient",
                [6] = "IsSuperAdmin",
            },
        },
        [96] = {
            parent = 8,
            strings = {
                [0] = "math",
                [1] = "random",
                [2] = "ipairs",
            },
        },
        [97] = {
            parent = 8,
            strings = {
                [0] = "table", -- x2
                [1] = "insert", -- x2
                [2] = "id", -- x3
                [3] = "math",
                [4] = "min",
                [5] = "ipairs", -- x3
                [6] = "currentId", -- x2
                [7] = "0",
            },
            booleans = {
                [0] = true, -- x3
            },
        },
        [98] = {
            parent = 8,
            strings = {
                [0] = "IsRosterDJ",
            },
        },
        [99] = {
            parent = 8,
        },
        [100] = {
            parent = 8,
            strings = {
                [0] = "ipairs",
                [1] = "col",
            },
            booleans = {
                [0] = true,
                [1] = false,
            },
        },
        [101] = {
            parent = 8,
            strings = {
                [0] = "isCustom",
                [1] = "name", -- x2
                [2] = "imageId", -- x2
                [3] = "playbackSpeed", -- x2
                [4] = "col", -- x2
                [5] = "ipairs",
                [6] = "table",
                [7] = "insert",
                [8] = "soundIds", -- x2
                [9] = "id", -- x2
            },
        },
        [102] = {
            parent = 8,
            strings = {
                [0] = "ipairs",
                [1] = "UserConfig",
                [2] = "DJ",
                [3] = "AlwaysDJUserIds",
            },
            booleans = {
                [0] = false,
                [1] = true,
            },
        },
        [103] = {
            parent = 8,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 217 },
            },
        },
        [104] = {
            parent = 8,
            strings = {
                [0] = "gsub",
                [1] = "_", -- x3
                [2] = "",
                [3] = "sub", -- x2
                [4] = "match",
                [5] = "^[%w_]+$",
                [6] = "type",
                [7] = "string",
            },
            booleans = {
                [0] = false, -- x5
                [1] = true,
            },
        },
        [105] = {
            parent = 8,
            strings = {
                [0] = "type",
                [1] = "number",
                [2] = "pcall",
            },
            proto_references = {
                [0] = { proto = 218 },
            },
        },
        [106] = {
            parent = 8,
            strings = {
                [0] = "IsA", -- x3
                [1] = "ModuleScript",
                [2] = "FindFirstChild", -- x3
                [3] = "RemoteFolder",
                [4] = "table", -- x3
                [5] = "insert", -- x3
                [6] = "RemoteFolder not found!",
                [7] = "DJLibrary",
                [8] = "RemoteEvent",
                [9] = "DJLibrary not found!",
                [10] = "Folder",
                [11] = "' not found!",
                [12] = "RemoteEvent '",
                [13] = "pairs",
                [14] = "Remotes",
            },
        },
        [107] = {
            parent = 8,
            strings = {
                [0] = "InvalidateDJCache",
            },
        },
        [108] = {
            parent = 8,
            strings = {
                [0] = "GetFavorites",
                [1] = "favorites",
                [2] = "GetLikedAlbums",
                [3] = "likedAlbums",
            },
        },
        [109] = {
            parent = 10,
            strings = {
                [0] = "Parent", -- x2
                [1] = "WaitForChild",
                [2] = "FindFirstChild",
                [3] = "type",
                [4] = "function",
            },
            proto_references = {
                [0] = { proto = 219 },
                [1] = { proto = 220 },
                [2] = { proto = 221 },
            },
        },
        [110] = {
            parent = 11,
            strings = {
                [0] = "pcall",
                [1] = "Group",
                [2] = "GroupID",
            },
            proto_references = {
                [0] = { proto = 222 },
            },
        },
        [111] = {
            parent = 11,
            strings = {
                [0] = "UserId",
                [1] = "ipairs",
                [2] = "DJ",
                [3] = "AlwaysDJUserIds",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true,
            },
        },
        [112] = {
            parent = 11,
            strings = {
                [0] = "<b><font color='",
                [1] = "Prefix",
                [2] = "'>",
                [3] = "DJ", -- x2
                [4] = "PrefixColor",
            },
            opaque_ascii = {
                [0] = "</font></b> ",
            },
        },
        [113] = {
            parent = 11,
            strings = {
                [0] = "Name",
                [1] = "GetDJPrefix",
                [2] = "Unknown",
                [3] = "DisplayName",
                [4] = "IsDJ",
            },
        },
        [114] = {
            parent = 11,
            strings = {
                [0] = "IsAlwaysDJ",
            },
            booleans = {
                [0] = false,
            },
        },
        [115] = {
            parent = 11,
            strings = {
                [0] = "IsDJ",
                [1] = "CanPlayerUseDJSystem",
                [2] = "HasGamepass",
                [3] = "DJ",
                [4] = "DJModeEnabled",
                [5] = "Gamepass",
                [6] = "BypassDJMode",
            },
            booleans = {
                [0] = true, -- x3
                [1] = false, -- x3
            },
        },
        [116] = {
            parent = 11,
            strings = {
                [0] = "dj",
                [1] = "group",
                [2] = "IsDJ", -- x2
                [3] = "Voting",
                [4] = "WhoCanStartVote",
                [5] = "everyone",
                [6] = "CanPlayerUseDJSystem",
                [7] = "IsGroupMember",
            },
            booleans = {
                [0] = false, -- x3
                [1] = true,
            },
        },
        [117] = {
            parent = 11,
            strings = {
                [0] = "IsDJ",
                [1] = "HasGamepass",
                [2] = "Gamepass",
                [3] = "BypassDJMode",
                [4] = "DJ",
                [5] = "DJModeEnabled",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true, -- x3
            },
        },
        [118] = {
            parent = 11,
            strings = {
                [0] = "type",
                [1] = "table",
                [2] = "pairs",
            },
        },
        [119] = {
            parent = 11,
            strings = {
                [0] = "type", -- x3
                [1] = "table", -- x3
                [2] = "pairs",
            },
        },
        [120] = {
            parent = 11,
            strings = {
                [0] = "IsDJ",
                [1] = "IsGroupMember",
            },
            booleans = {
                [0] = false,
            },
        },
        [121] = {
            parent = 11,
            strings = {
                [0] = "UserId", -- x3
            },
        },
        [122] = {
            parent = 11,
        },
        [123] = {
            parent = 11,
            strings = {
                [0] = "table",
                [1] = "clear",
            },
        },
        [124] = {
            parent = 11,
            strings = {
                [0] = "math",
                [1] = "huge",
                [2] = "Queue", -- x2
                [3] = "MaxNonGroupQueues",
                [4] = "IsGroupMember",
                [5] = "Group",
                [6] = "GroupID",
                [7] = "Gamepass",
                [8] = "MaxSongQueue",
                [9] = "HasGamepass",
                [10] = "MaxGroupQueues",
                [11] = "IsDJ",
            },
        },
        [125] = {
            parent = 11,
            strings = {
                [0] = "DJ",
                [1] = "DJBypassCooldown",
                [2] = "HasGamepass",
                [3] = "IsDJ",
                [4] = "Gamepass",
                [5] = "BypassCooldown",
            },
            booleans = {
                [0] = true, -- x2
                [1] = false, -- x2
            },
        },
        [126] = {
            parent = 11,
            strings = {
                [0] = "table",
                [1] = "clear",
            },
        },
        [127] = {
            parent = 11,
            strings = {
                [0] = "DJ", -- x5
                [1] = "GroupRoleID", -- x2
                [2] = "UserId", -- x3
                [3] = "MinimumRank", -- x2
                [4] = "isDJ", -- x2
                [5] = "both",
                [6] = "os", -- x2
                [7] = "time", -- x4
                [8] = "role",
                [9] = "rank",
                [10] = "IsSuperAdmin",
                [11] = "DJCheckMode",
                [12] = "Group",
                [13] = "GroupID",
            },
            booleans = {
                [0] = false, -- x3
                [1] = true, -- x2
            },
        },
        [128] = {
            parent = 11,
            strings = {
                [0] = "Owner", -- x2
                [1] = "game", -- x3
                [2] = "CreatorId",
                [3] = "CreatorType", -- x4
                [4] = "Enum", -- x2
                [5] = "Group",
                [6] = "User",
                [7] = "pcall",
                [8] = "Id",
            },
            proto_references = {
                [0] = { proto = 223 },
            },
        },
        [129] = {
            parent = 11,
            strings = {
                [0] = "UserId",
            },
            booleans = {
                [0] = false,
            },
        },
        [130] = {
            parent = 11,
            strings = {
                [0] = "CanPlayerUseDJSystem",
                [1] = "HasGamepass",
                [2] = "IsDJ",
                [3] = "Queue",
                [4] = "RestrictQueue",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true,
            },
        },
        [131] = {
            parent = 11,
            strings = {
                [0] = "CanPlayerUseDJSystem",
            },
            booleans = {
                [0] = false, -- x2
                [1] = true,
            },
        },
        [132] = {
            parent = 11,
            strings = {
                [0] = "os", -- x2
                [1] = "time", -- x4
                [2] = "UserId", -- x2
                [3] = "Gamepass",
                [4] = "GamepassID",
                [5] = "pcall",
                [6] = "hasPass", -- x2
            },
            booleans = {
                [0] = false, -- x3
            },
            proto_references = {
                [0] = { proto = 224 },
            },
        },
        [133] = {
            parent = 11,
            strings = {
                [0] = "time", -- x4
                [1] = "Group",
                [2] = "GroupID",
                [3] = "UserId", -- x2
                [4] = "isMember", -- x2
                [5] = "os", -- x2
            },
            booleans = {
                [0] = false, -- x2
            },
        },
        [134] = {
            parent = 12,
            strings = {
                [0] = "name",
            },
        },
        [135] = {
            parent = 12,
            strings = {
                [0] = "Name",
                [1] = "name",
                [2] = "IsA",
                [3] = "ClassName",
                [4] = "ModuleScript",
            },
            proto_references = {
                [0] = { proto = 225 },
            },
        },
        [136] = {
            parent = 14,
        },
        [137] = {
            parent = 14,
        },
        [138] = {
            parent = 14,
        },
        [139] = {
            parent = 14,
            strings = {
                [0] = "math",
                [1] = "floor",
            },
        },
        [140] = {
            parent = 14,
            strings = {
                [0] = "math",
                [1] = "floor",
            },
        },
        [141] = {
            parent = 14,
        },
        [142] = {
            parent = 14,
            booleans = {
                [0] = false,
            },
        },
        [143] = {
            parent = 14,
            strings = {
                [0] = "n",
            },
        },
        [144] = {
            parent = 14,
            strings = {
                [0] = "pcall",
            },
            booleans = {
                [0] = false, -- x3
            },
            proto_references = {
                [0] = { proto = 226 },
            },
        },
        [145] = {
            parent = 14,
            strings = {
                [0] = "n", -- x2
            },
        },
        [146] = {
            parent = 14,
        },
        [147] = {
            parent = 14,
        },
        [148] = {
            parent = 14,
            strings = {
                [0] = "math",
                [1] = "floor",
            },
        },
        [149] = {
            parent = 14,
        },
        [150] = {
            parent = 14,
        },
        [151] = {
            parent = 14,
        },
        [152] = {
            parent = 14,
        },
        [153] = {
            parent = 14,
        },
        [154] = {
            parent = 14,
        },
        [155] = {
            parent = 14,
        },
        [156] = {
            parent = 14,
        },
        [157] = {
            parent = 14,
            strings = {
                [0] = "math",
                [1] = "floor",
            },
        },
        [158] = {
            parent = 14,
        },
        [159] = {
            parent = 14,
        },
        [160] = {
            parent = 14,
        },
        [161] = {
            parent = 14,
        },
        [162] = {
            parent = 14,
        },
        [163] = {
            parent = 14,
        },
        [164] = {
            parent = 14,
            strings = {
                [0] = "tonumber",
                [1] = "string", -- x2
                [2] = "sub",
                [3] = "lower",
                [4] = "n",
            },
        },
        [165] = {
            parent = 14,
            strings = {
                [0] = "n",
                [1] = "string",
                [2] = "byte",
            },
        },
        [166] = {
            parent = 14,
            strings = {
                [0] = "table",
                [1] = "concat",
                [2] = "string",
                [3] = "char",
            },
        },
        [167] = {
            parent = 14,
            strings = {
                [0] = "table",
                [1] = "concat",
                [2] = "string",
                [3] = "format",
                [4] = "%02x",
            },
        },
        [168] = {
            parent = 14,
            strings = {
                [0] = "math",
                [1] = "floor",
            },
        },
        [169] = {
            parent = 14,
        },
        [170] = {
            parent = 14,
        },
        [171] = {
            parent = 14,
            strings = {
                [0] = "math",
                [1] = "floor",
                [2] = "n",
            },
        },
        [172] = {
            parent = 15,
            strings = {
                [0] = "string", -- x2
                [1] = "sub",
                [2] = "table",
                [3] = "concat",
                [4] = "=",
                [5] = "format",
                [6] = "%02x",
                [7] = "math",
                [8] = "floor",
            },
        },
        [173] = {
            parent = 15,
            strings = {
                [0] = "pcall",
                [1] = "game", -- x3
                [2] = "CreatorType", -- x4
                [3] = "Enum", -- x2
                [4] = "Group",
                [5] = "CreatorId",
                [6] = "Owner", -- x2
                [7] = "Id",
                [8] = "User",
            },
            proto_references = {
                [0] = { proto = 227 },
            },
        },
        [174] = {
            parent = 15,
            strings = {
                [0] = "pcall", -- x2
                [1] = "type", -- x8
                [2] = "string", -- x6
                [3] = "tamper", -- x9
                [4] = "|", -- x5
                [5] = "userId", -- x2
                [6] = "productId", -- x2
                [7] = "nonce", -- x2
                [8] = "gameId", -- x2
                [9] = "math",
                [10] = "abs",
                [11] = "os",
                [12] = "time",
                [13] = "neterror", -- x2
                [14] = "dataKey",
                [15] = "ts",
                [16] = "sig",
                [17] = "StatusCode", -- x2
                [18] = "denied",
                [19] = "gsub",
                [20] = "-",
                [21] = "",
                [22] = "tostring", -- x6
                [23] = "_b64ToHex",
                [24] = "JSONEncode",
                [25] = "ProductId", -- x2
                [26] = "studio",
                [27] = "game", -- x4
                [28] = "PlaceId",
                [29] = "TimeToleranceSec",
                [30] = "GetService", -- x2
                [31] = "RunService", -- x2
                [32] = "IsStudio", -- x2
                [33] = "number",
                [34] = "verify",
                [35] = "PublicKey",
                [36] = "GenerateGUID",
                [37] = "table",
                [38] = "placeId",
                [39] = "Name",
                [40] = "gameName",
                [41] = "decryptHex",
                [42] = "EncData",
                [43] = "ok",
            },
            booleans = {
                [0] = false, -- x12
                [1] = true,
            },
            proto_references = {
                [0] = { proto = 228 },
                [1] = { proto = 229 },
            },
        },
        [175] = {
            parent = 15,
            strings = {
                [0] = "neterror", -- x2
                [1] = "denied",
                [2] = "ok",
                [3] = "task",
                [4] = "wait",
                [5] = "tamper",
                [6] = "game",
                [7] = "GameId",
                [8] = "Attempts",
            },
            booleans = {
                [0] = false, -- x3
                [1] = true,
            },
        },
        [176] = {
            parent = 15,
            strings = {
                [0] = "task",
                [1] = "spawn",
            },
            proto_references = {
                [0] = { proto = 230 },
            },
        },
        [177] = {
            parent = 15,
            strings = {
                [0] = "task",
                [1] = "spawn",
            },
            proto_references = {
                [0] = { proto = 231 },
            },
        },
        [178] = {
            parent = 17,
            strings = {
                [0] = "Kick",
                [1] = "This game is not licensed. Please contact CENZ STUDIO.",
            },
        },
        [179] = {
            parent = 17,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 232 },
            },
        },
        [180] = {
            parent = 17,
            strings = {
                [0] = "game",
                [1] = "GetService",
                [2] = "Workspace",
                [3] = "ClearAllChildren",
            },
        },
        [181] = {
            parent = 22,
            strings = {
                [0] = "UpdateAsync",
                [1] = "Library",
            },
            proto_references = {
                [0] = { proto = 233 },
            },
        },
        [182] = {
            parent = 23,
            strings = {
                [0] = "userId", -- x2
            },
        },
        [183] = {
            parent = 24,
        },
        [184] = {
            parent = 25,
            strings = {
                [0] = "StartProfile",
            },
        },
        [185] = {
            parent = 25,
            strings = {
                [0] = "SubscribeAsync",
                [1] = "CenzMusic_v1_Sync",
            },
            proto_references = {
                [0] = { proto = 234 },
            },
        },
        [186] = {
            parent = 25,
            strings = {
                [0] = "New",
                [1] = "CenzMusic_v1_Player",
            },
        },
        [187] = {
            parent = 25,
            strings = {
                [0] = "GetAsync",
                [1] = "Library",
            },
        },
        [188] = {
            parent = 25,
            strings = {
                [0] = "EndProfile",
            },
        },
        [189] = {
            parent = 25,
            strings = {
                [0] = "StartProfile",
            },
        },
        [190] = {
            parent = 25,
            strings = {
                [0] = "GetDataStore",
                [1] = "CenzMusic_v1_Global",
            },
        },
        [191] = {
            parent = 26,
            strings = {
                [0] = "UpdateAsync",
                [1] = "DJRoster",
            },
            proto_references = {
                [0] = { proto = 235 },
            },
        },
        [192] = {
            parent = 27,
            strings = {
                [0] = "Enum",
                [1] = "InfoType",
                [2] = "Asset",
                [3] = "GetProductInfo",
            },
        },
        [193] = {
            parent = 28,
            strings = {
                [0] = "UpdateAsync",
                [1] = "Library",
            },
            proto_references = {
                [0] = { proto = 236 },
            },
        },
        [194] = {
            parent = 32,
            strings = {
                [0] = "JobId",
                [1] = "from",
                [2] = "PublishAsync",
                [3] = "CenzMusic_v1_Sync",
                [4] = "kind",
                [5] = "game",
            },
        },
        [195] = {
            parent = 33,
            strings = {
                [0] = "GetAsync",
            },
        },
        [196] = {
            parent = 36,
            strings = {
                [0] = "UpdateAsync",
                [1] = "DJRoster",
            },
            proto_references = {
                [0] = { proto = 237 },
            },
        },
        [197] = {
            parent = 37,
            strings = {
                [0] = "Parent",
            },
        },
        [198] = {
            parent = 37,
        },
        [199] = {
            parent = 39,
            strings = {
                [0] = "currentAddedBy", -- x2
                [1] = "currentImageId", -- x2
                [2] = "isPlaying", -- x2
                [3] = "currentId", -- x2
                [4] = "currentName", -- x2
                [5] = "anchorServerTime", -- x2
                [6] = "anchorTimePos", -- x2
                [7] = "length", -- x2
                [8] = "FireClient",
                [9] = "volume", -- x2
                [10] = "masterVolume", -- x2
                [11] = "speed", -- x2
                [12] = "musicZoneMode", -- x2
                [13] = "djModeActive", -- x2
                [14] = "IsDJ",
                [15] = "isDJ",
                [16] = "ipairs",
                [17] = "totalParts", -- x2
                [18] = "accumulatedTime", -- x2
                [19] = "IsSuperAdmin",
                [20] = "isSuperAdmin",
                [21] = "queue",
                [22] = "musicZoneEnabled", -- x2
                [23] = "GetPlayers",
                [24] = "effects",
                [25] = "isActive",
                [26] = "isMultiPart",
                [27] = "currentPartIndex", -- x2
            },
            booleans = {
                [0] = false,
            },
        },
        [200] = {
            parent = 47,
            strings = {
                [0] = "GetUserInfosByUserIdsAsync",
                [1] = "game",
                [2] = "GetService",
                [3] = "UserService",
            },
        },
        [201] = {
            parent = 53,
        },
        [202] = {
            parent = 63,
            strings = {
                [0] = "PreloadAsync",
            },
        },
        [203] = {
            parent = 64,
            strings = {
                [0] = "TimeLength", -- x3
                [1] = "pcall",
                [2] = "rbxassetid://",
                [3] = "SoundId",
                [4] = "Parent",
                [5] = "Volume",
                [6] = "Instance",
                [7] = "new",
                [8] = "Sound",
                [9] = "Destroy",
                [10] = "task",
                [11] = "wait",
            },
            proto_references = {
                [0] = { proto = 238 },
            },
        },
        [204] = {
            parent = 67,
            strings = {
                [0] = "UserId",
                [1] = "GetNonChatStringForBroadcastAsync",
                [2] = "game",
                [3] = "GetService",
                [4] = "TextService",
                [5] = "FilterStringAsync",
            },
        },
        [205] = {
            parent = 67,
        },
        [206] = {
            parent = 67,
        },
        [207] = {
            parent = 67,
            strings = {
                [0] = "game",
                [1] = "GetService",
                [2] = "TextService",
                [3] = "FilterStringAsync",
                [4] = "UserId",
                [5] = "GetNonChatStringForBroadcastAsync",
            },
        },
        [208] = {
            parent = 67,
        },
        [209] = {
            parent = 67,
        },
        [210] = {
            parent = 67,
        },
        [211] = {
            parent = 72,
            strings = {
                [0] = "currentId",
                [1] = "0",
                [2] = "Server", -- x2
                [3] = "imageId", -- x2
                [4] = "playbackSpeed", -- x2
                [5] = "soundIds", -- x3
                [6] = "id", -- x2
                [7] = "name", -- x2
                [8] = "table",
                [9] = "remove",
            },
        },
        [212] = {
            parent = 82,
        },
        [213] = {
            parent = 83,
            strings = {
                [0] = "table",
                [1] = "remove",
                [2] = "id", -- x2
                [3] = "name", -- x2
                [4] = "currentId",
                [5] = "0",
                [6] = "soundIds", -- x3
                [7] = "Server", -- x2
                [8] = "imageId", -- x2
                [9] = "playbackSpeed", -- x2
            },
        },
        [214] = {
            parent = 83,
        },
        [215] = {
            parent = 88,
            strings = {
                [0] = "isActive", -- x3
                [1] = "endTime",
                [2] = "currentId", -- x2
                [3] = "os",
                [4] = "clock",
                [5] = "task",
                [6] = "wait",
            },
            booleans = {
                [0] = false,
            },
        },
        [216] = {
            parent = 93,
        },
        [217] = {
            parent = 103,
            strings = {
                [0] = "GetNameFromUserIdAsync",
            },
        },
        [218] = {
            parent = 105,
            strings = {
                [0] = "GetUserIdFromNameAsync",
            },
        },
        [219] = {
            parent = 109,
        },
        [220] = {
            parent = 109,
            strings = {
                [0] = "WaitForChild",
            },
        },
        [221] = {
            parent = 109,
            strings = {
                [0] = "FindFirstChild",
            },
        },
        [222] = {
            parent = 110,
            strings = {
                [0] = "GetRankInGroup",
            },
        },
        [223] = {
            parent = 128,
            strings = {
                [0] = "CreatorId",
                [1] = "game", -- x2
                [2] = "GetService",
                [3] = "GroupService",
                [4] = "GetGroupInfoAsync",
            },
        },
        [224] = {
            parent = 132,
            strings = {
                [0] = "UserOwnsGamePassAsync",
                [1] = "UserId",
            },
        },
        [225] = {
            parent = 135,
            strings = {
                [0] = "LuaSourceContainer",
                [1] = "ModuleScript",
                [2] = "Instance",
            },
        },
        [226] = {
            parent = 144,
            strings = {
                [0] = "n",
            },
        },
        [227] = {
            parent = 173,
            strings = {
                [0] = "game", -- x2
                [1] = "GetService",
                [2] = "GroupService",
                [3] = "GetGroupInfoAsync",
                [4] = "CreatorId",
            },
        },
        [228] = {
            parent = 174,
            strings = {
                [0] = "JSONDecode",
                [1] = "Body",
            },
        },
        [229] = {
            parent = 174,
            strings = {
                [0] = "Content-Type",
                [1] = "application/json",
                [2] = "Headers",
                [3] = "Body",
                [4] = "RequestAsync",
                [5] = "ProxyUrl",
                [6] = "/load",
                [7] = "Url",
                [8] = "Method",
                [9] = "POST",
            },
        },
        [230] = {
            parent = 176,
            strings = {
                [0] = "math", -- x2
                [1] = "clamp",
                [2] = "studio",
                [3] = "pcall", -- x2
                [4] = "game", -- x6
                [5] = "GetService", -- x2
                [6] = "Players",
                [7] = "GetPlayers",
                [8] = "JobId",
                [9] = "jobId",
                [10] = "tostring", -- x4
                [11] = "PlaceId",
                [12] = "placeId",
                [13] = "StatusCode",
                [14] = "HeartbeatSec",
                [15] = "IsStudio",
                [16] = "JSONEncode",
                [17] = "shutdown",
                [18] = "task",
                [19] = "wait",
                [20] = "tonumber",
                [21] = "nextIn",
                [22] = "GameId",
                [23] = "gameId",
                [24] = "ProductId",
                [25] = "productId",
                [26] = "ownerId",
                [27] = "type",
                [28] = "table",
                [29] = "Name",
                [30] = "gameName",
                [31] = "players",
                [32] = "RunService",
                [33] = "floor",
            },
            booleans = {
                [0] = true,
            },
            proto_references = {
                [0] = { proto = 239 },
                [1] = { proto = 240 },
            },
        },
        [231] = {
            parent = 177,
            strings = {
                [0] = "pcall",
            },
            proto_references = {
                [0] = { proto = 241 },
            },
        },
        [232] = {
            parent = 179,
            strings = {
                [0] = "Kick",
                [1] = "This game is not licensed. Please contact CENZ STUDIO.",
            },
        },
        [233] = {
            parent = 181,
            strings = {
                [0] = "cannotRemoveStatic",
                [1] = "type", -- x2
                [2] = "tracks", -- x3
                [3] = "ipairs",
                [4] = "table", -- x3
                [5] = "remove",
                [6] = "id",
            },
        },
        [234] = {
            parent = 185,
            strings = {
                [0] = "RefreshRoster",
                [1] = "table",
                [2] = "RefreshLibrary",
                [3] = "Data",
                [4] = "type",
                [5] = "kind", -- x2
                [6] = "roster",
                [7] = "from",
                [8] = "game",
                [9] = "JobId",
                [10] = "library",
            },
        },
        [235] = {
            parent = 191,
            strings = {
                [0] = "djs", -- x3
                [1] = "time",
                [2] = "at",
                [3] = "type", -- x2
                [4] = "table", -- x2
                [5] = "name",
                [6] = "addedBy",
                [7] = "os",
                [8] = "alreadyDJ",
            },
        },
        [236] = {
            parent = 193,
            strings = {
                [0] = "type", -- x2
                [1] = "tracks", -- x3
                [2] = "table", -- x3
                [3] = "ipairs",
                [4] = "id", -- x2
                [5] = "duplicateLibrary",
                [6] = "insert",
            },
        },
        [237] = {
            parent = 196,
            strings = {
                [0] = "djs", -- x3
                [1] = "table", -- x2
                [2] = "notRosterDJ",
                [3] = "type", -- x2
            },
        },
        [238] = {
            parent = 203,
            strings = {
                [0] = "PreloadAsync",
            },
        },
        [239] = {
            parent = 230,
            strings = {
                [0] = "Method",
                [1] = "POST",
                [2] = "Content-Type",
                [3] = "application/json",
                [4] = "Headers",
                [5] = "Body",
                [6] = "ProxyUrl",
                [7] = "/heartbeat",
                [8] = "Url",
                [9] = "RequestAsync",
            },
        },
        [240] = {
            parent = 230,
            strings = {
                [0] = "JSONDecode",
                [1] = "Body",
            },
        },
        [241] = {
            parent = 231,
            strings = {
                [0] = "jobId",
                [1] = "game", -- x5
                [2] = "GetService",
                [3] = "RunService",
                [4] = "JobId",
                [5] = "placeId",
                [6] = "Name",
                [7] = "GameId",
                [8] = "RequestAsync",
                [9] = "IsStudio",
                [10] = "studio",
                [11] = "gameId",
                [12] = "tostring", -- x4
                [13] = "PlaceId",
                [14] = "violation",
                [15] = "Body",
                [16] = "JSONEncode",
                [17] = "ownerId",
                [18] = "gameName",
                [19] = "ProductId",
                [20] = "productId",
                [21] = "ProxyUrl",
                [22] = "/tamper",
                [23] = "Url",
                [24] = "Method",
                [25] = "POST",
                [26] = "Content-Type",
                [27] = "application/json",
                [28] = "Headers",
            },
        },
    },
}
