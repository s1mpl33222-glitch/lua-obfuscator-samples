local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Multi-Target Controller",
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "by Vort Clan",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Auto Sender", 4483362458)

-- Default Variables
local targets = {"CELEST", "", "", ""}
local delayTime = 0.8
local customPattern = "@=@="
local patternRepeatCount = 18
local isRunning = false

-- Theme-based Relatable Emojis Dictionary
local emojiMap = {
    ["DIAMOND"] = "💎", ["COSMIC"] = "🌌", ["WAVE"] = "🌊", ["TATTI"] = "💩",
    ["ROSE"] = "🌹", ["RICE"] = "🍚", ["TORNADO"] = "🌪️", ["BLOOD"] = "🩸",
    ["SUGAR"] = "🍬", ["MANGO"] = "🥭", ["RAINBOW"] = "🌈", ["SNAKE"] = "🐍",
    ["CLOWN"] = "🤡", ["OMEGA"] = "⚡", ["CYBORG"] = "🤖", ["PHANTOM"] = "👻",
    ["VIPER"] = "🐍", ["TITAN"] = "🗿", ["SHADOW"] = "👤", ["BLADE"] = "⚔️",
    ["STORM"] = "🌩️", ["DRAGON"] = "🐉", ["VENOM"] = "🧪", ["THUNDER"] = "⚡",
    ["NOVA"] = "💥", ["HYPER"] = "🚀", ["INFERNO"] = "🔥", ["GALAXY"] = "🪐",
    ["STARLIGHT"] = "✨", ["METEOR"] = "☄️", ["BLAZE"] = "🔥", ["COMET"] = "☄️",
    ["ECLIPSE"] = "🌒", ["VORTEX"] = "🌀", ["NEBULA"] = "🌌", ["SOLARIS"] = "☀️",
    ["PYRO"] = "🔥", ["FROST"] = "❄️", ["GLACIER"] = "🧊", ["SPECTRE"] = "👁️",
    ["QUANTUM"] = "⚛️", ["DEVIL"] = "😈", ["SKULL"] = "💀", ["CROWN"] = "👑"
}

-- Large Base Words Pool (Clean Capital Words)
local baseWords = {
    "DIAMOND", "COSMIC", "WAVE", "TATTI", "ROSE", "RICE", "TORNADO",
    "BLOOD", "SUGAR", "MANGO", "RAINBOW", "SNAKE", "CLOWN", "OMEGA",
    "CYBORG", "PHANTOM", "VIPER", "TITAN", "SHADOW", "BLADE", "STORM",
    "DRAGON", "VENOM", "THUNDER", "NOVA", "HYPER", "INFERNO", "GALAXY",
    "STARLIGHT", "METEOR", "BLAZE", "COMET", "ECLIPSE", "VORTEX", "NEBULA",
    "SOLARIS", "PYRO", "FROST", "GLACIER", "SPECTRE", "QUANTUM", "DEVIL",
    "SKULL", "CROWN"
}

-- Chat Service Handle
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function sendChatMessage(msg)
    if ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    elseif TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    end
end

-- Helper: Get Clean Word with Relatable Emoji
local function getWordWithEmoji(word)
    local emoji = emojiMap[word] or "🔥"
    return word .. " " .. emoji
end

-- Helper: Get Next 7 Pure Unique Words (Looping through base pool without suffix)
local function getNextSevenWords(startIndex)
    local selectedWords = {}
    local totalBase = #baseWords
    
    for i = 0, 6 do
        local globalIdx = startIndex + i - 1
        local baseIdx = (globalIdx % totalBase) + 1
        local rawWord = baseWords[baseIdx]
        
        table.insert(selectedWords, getWordWithEmoji(rawWord))
    end
    
    return table.concat(selectedWords, " ")
end

-- Helper: Get Next Active Target Name
local function getActiveTargetList()
    local active = {}
    for _, name in ipairs(targets) do
        if name and name ~= "" then
            table.insert(active, name)
        end
    end
    return active
end

-- UI Controls for 4 Targets
Tab:CreateInput({
   Name = "Target Name 1",
   PlaceholderText = "CELEST",
   RemoveTextOnFocus = false,
   Callback = function(Text)
      targets[1] = string.upper(Text)
   end,
})

Tab:CreateInput({
   Name = "Target Name 2",
   PlaceholderText = "Target 2 (Optional)",
   RemoveTextOnFocus = false,
   Callback = function(Text)
      targets[2] = string.upper(Text)
   end,
})

Tab:CreateInput({
   Name = "Target Name 3",
   PlaceholderText = "Target 3 (Optional)",
   RemoveTextOnFocus = false,
   Callback = function(Text)
      targets[3] = string.upper(Text)
   end,
})

Tab:CreateInput({
   Name = "Target Name 4",
   PlaceholderText = "Target 4 (Optional)",
   RemoveTextOnFocus = false,
   Callback = function(Text)
      targets[4] = string.upper(Text)
   end,
})

Tab:CreateInput({
   Name = "Custom Pattern (Prefix)",
   PlaceholderText = "@=@=",
   RemoveTextOnFocus = false,
   Callback = function(Text)
      if Text ~= "" then customPattern = Text end
   end,
})

Tab:CreateInput({
   Name = "Custom Delay (Seconds)",
   PlaceholderText = "0.8",
   RemoveTextOnFocus = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then delayTime = num end
   end,
})

Tab:CreateToggle({
   Name = "Start Sender",
   CurrentValue = false,
   Flag = "SenderToggle",
   Callback = function(Value)
      isRunning = Value
      
      if isRunning then
         task.spawn(function()
            local wordCounter = 1
            local targetCounter = 1
            
            while isRunning do
               local activeTargets = getActiveTargetList()
               local currentTarget = "CELEST"
               
               if #activeTargets > 0 then
                  local tIdx = ((targetCounter - 1) % #activeTargets) + 1
                  currentTarget = activeTargets[tIdx]
               end
               
               local stylishBlock = string.rep(customPattern, patternRepeatCount)
               local sevenWordsWithEmojis = getNextSevenWords(wordCounter)
               
               -- Output Format: [Custom Pattern] [CURRENT TARGET] TMX MARE [7 CLEAN WORDS WITH EMOJIS]
               local formattedMessage = stylishBlock .. " " .. currentTarget .. " TMX MARE " .. sevenWordsWithEmojis
               
               sendChatMessage(formattedMessage)
               
               wordCounter = wordCounter + 7
               targetCounter = targetCounter + 1
               
               task.wait(delayTime)
            end
         end)
      end
   end,
})