local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "OctaCore Technologies",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "OctaCore Tech. Interface",
   LoadingSubtitle = "by mauzer5.0",
   ShowText = "OctaCore", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "AmberGlow", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "L", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "OctaCore"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "OctaCore Technologies",
      Subtitle = "Key System",
      Note = "To purchase the key, DM mauzer5.0 on Discord", -- Use this to tell the user how to get a key
      FileName = "OctaCoreKeySystem", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {""} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Configuration", "settings") -- Title, Image

local Section = Tab:CreateSection("Opponent Information")

----------------------------------------------------
-- UI VARIABLES (Rayfield Toggles + Username Input)
----------------------------------------------------

local opponentUsername = ""
local autodenyEnabled = false
local autodenyFromKeybind = false

local autoblockEnabled = false
local autoblockFromKeybind = false

local takedownDefenseEnabled = false
local takedownFromKeybind = false

----------------------------------------------------
-- UI ELEMENTS
----------------------------------------------------

local Input = Tab:CreateInput({
   Name = "Opponent Username",
   CurrentValue = "",
   PlaceholderText = "",
   RemoveTextAfterFocusLost = false,
   Flag = "Username",
   Callback = function(Text)
      opponentUsername = Text
   end,
})

----------------------------------------------------
-- AUTO-DENY UI
----------------------------------------------------

Tab:CreateSection("Grappling Settings")

local Toggle = Tab:CreateToggle({
    Name = "Auto-Deny Switch",
    CurrentValue = false,
    Flag = "AutodenyToggle",
    Callback = function(Value)
        autodenyEnabled = Value

        if not autodenyFromKeybind then
            Rayfield:Notify({
                Title = "Auto-Deny",
                Content = Value and "Enabled" or "Disabled",
                Duration = 3,
                Image = "shield",
            })
        end

        autodenyFromKeybind = false
    end,
})

local Keybind = Tab:CreateKeybind({
    Name = "Auto-Deny Keybind",
    CurrentKeybind = "F",
    HoldToInteract = false,
    Flag = "AutodenyKeybind",
    Callback = function()
        autodenyFromKeybind = true
        local newState = not autodenyEnabled
        Toggle:Set(newState)
        autodenyEnabled = newState

        Rayfield:Notify({
            Title = "Auto-Deny",
            Content = newState and "Enabled" or "Disabled",
            Duration = 4,
            Image = "shield",
        })
    end,
})

----------------------------------------------------
-- AUTO-BLOCK UI
----------------------------------------------------

Tab:CreateSection("Blocking Settings")

local AutoblockToggle = Tab:CreateToggle({
    Name = "Auto-Block Switch",
    CurrentValue = false,
    Flag = "AutoblockToggle",
    Callback = function(Value)
        autoblockEnabled = Value

        if not autoblockFromKeybind then
            Rayfield:Notify({
                Title = "Auto-Block",
                Content = Value and "Enabled" or "Disabled",
                Duration = 3,
                Image = "shield",
            })
        end

        autoblockFromKeybind = false
    end,
})

local AutoblockKeybind = Tab:CreateKeybind({
    Name = "Auto-Block Keybind",
    CurrentKeybind = "Y",
    HoldToInteract = false,
    Flag = "AutoblockKeybind",
    Callback = function()
        autoblockFromKeybind = true
        local newState = not autoblockEnabled
        AutoblockToggle:Set(newState)
        autoblockEnabled = newState

        Rayfield:Notify({
            Title = "Auto-Block",
            Content = newState and "Enabled" or "Disabled",
            Duration = 3,
            Image = "shield",
        })
    end,
})

----------------------------------------------------
-- TAKEDOWN DEFENSE UI
----------------------------------------------------

Tab:CreateSection("Takedown Defense Settings")

local TakedownDefenseToggle = Tab:CreateToggle({
    Name = "Anti-Takedown Switch",
    CurrentValue = false,
    Flag = "TakedownDefenseToggle",
    Callback = function(Value)
        takedownDefenseEnabled = Value

        if not takedownFromKeybind then
            Rayfield:Notify({
                Title = "Anti-Takedown",
                Content = Value and "Enabled" or "Disabled",
                Duration = 3,
                Image = "shield",
            })
        end

        takedownFromKeybind = false
    end,
})

local TakedownDefenseKeybind = Tab:CreateKeybind({
    Name = "Anti-Takedown Keybind",
    CurrentKeybind = "J",
    HoldToInteract = false,
    Flag = "TakedownDefenseKeybind",
    Callback = function()
        takedownFromKeybind = true
        local newState = not takedownDefenseEnabled
        TakedownDefenseToggle:Set(newState)
        takedownDefenseEnabled = newState

        Rayfield:Notify({
            Title = "Anti-Takedown",
            Content = newState and "Enabled" or "Disabled",
            Duration = 3,
            Image = "shield",
        })
    end,
})

local Paragraph = Tab:CreateParagraph({Title = "Information", Content = "Anti-Takedown script uses your Holding Q+LMB, basically Left Heavy Body Strike to counter takedown attempts. If you have do not have any strikes to counter takedowns (BRK DUCK) in your moveset at that specific strike, it is suggested for you to leave this switch closed. If you are also low on stamina, you may leave this disabled aswell since there is a chance of failure at countering."})

----------------------------------------------------
-- TERMINATE BUTTON
----------------------------------------------------

Tab:CreateSection("Terminate Interface")

Tab:CreateButton({
    Name = "Unload Interface",
    Callback = function()
        Rayfield:Destroy()
    end,
})

----------------------------------------------------
-- CORE SCRIPT BELOW (MERGED)
----------------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Framework = ReplicatedStorage:WaitForChild("Framework")
local RemoteEvents = Framework:WaitForChild("RemoteEvents")
local PlayerValues = Framework:WaitForChild("PlayerValues")

local OpponentID = nil

local function updateOpponentID()
    if opponentUsername == "" then return end

    pcall(function()
        if Players:FindFirstChild(opponentUsername) then
            OpponentID = Players[opponentUsername].UserId
        else
            OpponentID = Players:GetUserIdFromNameAsync(opponentUsername)
        end
    end)

    if OpponentID then
        OpponentID = tostring(OpponentID)
    end
end

----------------------------------------------------
-- EMPTY STRIKE MAP FORMAT
----------------------------------------------------

local STRIKE_MAP = {
    Head = {"7128004737","7128005198","7128013699","7128014131","7128025741","7128026280","7128027843","7128028275","7128029727","7128030212","11748764097","11748777609","7128065366","7128065752","7355991331","7355999880","7356996116","7356994796","7357044373","7357032345","7356978214","7356979885","7128069591","7128069940","7357112431","7357110670","7128071283","7128071857","7128072162","7128072666","7357375109","7357376309","7621917447","7621919019","7128105371","7128105850","7128106270","7128106686","8926760585","8926756295","8926787137","8926799118","7128108640","7128110038","8926239326","8926296130","8926262993","8926339351","8926372116","8926686972","8926710618","8926872186","8926873565","8926875181","8926876700","8926878471","8926879971","8926881527","7128123933","7128124327","7128124709","7128125129","7128127665","7128128432","7128128961","7128129655","7128133667","8195243877","8195364079","8195362237","8195506498","8195524447","8195662079","8195667847","8195765340","8195766415","7128134454","7493245353","8137676061","8159638708","7939348961","7128136380","7597836294","8195783555","8195878812","8195879670","8195938709","7355614141","7128137482","7128137838","7128138979","7128145699","7128146101","7128146531","7356820187","7128146890","7128147350","7128147783","7128149368","7347442631","7128150351","7128150855","7128151919","7128152484","8038009309","7356803282","7128152853","7128153258","7128153644","7128154000","7347179360","9650168360","7493422492","9616072551","7128154400","8195253141","8195344484","8195357920","8195670960","8195670033","8195740661","8195759874","7128154994","7493244515","8137662749","8159639938","7128156567","7347447055","7128158183","7128158727","7128159523","7128159909","8037998205","7356803890","7128160338","7128160920","7128161704","7128180683","7939348233","7128182816","7355616472","7128201241","7128201696","7597845938","8195785372","8195844655","8195872866","8195935483","7128202475","7128202894","7128203325","7128203725","7356815939","7128204222","7128204708","7128205152","7347151692","9650169282","7493420663","9616072551","7315241537","7315547258","7347586859","7363422469","7347994474","7363400232","7128225907","7128226234","7128227522","7128227794","7128230378","7128230762","7128247773","7128248464","7128249611","7128250047","7128252318","7128252758","8644236725","7128260551","7128261071","7128263499","7128263853","7503065998","7503066748","9608385707","9608442736","7503067543","7503068346","9608396388","9608450719","8342806945","8342807434","8342784313","8342785406","8342860269","8342860683","8342843285","8342842581"},  -- animation IDs for head strikes
    Torso = {"7356048406","7356049045","8927815579","8927808288","7356021693","7356020403","12488426123","12488428916","12488453087","12488454247","7357212235","7363277457","12488525092","12488527010","12488552301","12488553413","7621942171","7621943922","7729989622","7729999366","12488611573","12488601337","12488586900","12488609121","8195651180","8195647473","8342989989","7355586692","7128135323","7128135875","9847468225","7363198019","7128137137","9847599384","10024874783","14003203870","7128148490","7128148885","9847517848","7363199920","7128150018","8195487706","8195530185","8195589995","8195641148","8342996282","14003206661","7128155714","7128156136","9847524454","7363288779","7128157501","7355793287","7128181620","7128182093","9847498083","7363251521","7128200765","9847595579","10024880109","7128226700","7128227164","7128228081","7128228435","7128231332","7128231798","7128232121","7128232655","7128248885","7128249232","7128250676","7128251037","7128253129","7128253487","7128254321","7128256360","7128259810","7128260182","7128262759","7128263060","8342649005","8342663617","8342875203","8342875778"},  -- animation IDs for body/torso strikes
    Legs = {"7355852706","7256536438","7355855706","7256547599","7543039763","7543084098","7355853611","7256548095","7543035600","7543078743","7355854920","7256537387","7128229225","7128229728","7128239865","7128251438","7128251813","7128256838"}   -- animation IDs for leg kicks
}

-- 1. Throttle fireBlock (max once every 0.15s)
local lastFireTime = 0
local function fireBlock(blockType)
    local now = tick()
    if now - lastFireTime < 0.15 then return end
    lastFireTime = now

    if blockType == "Head" then
        MAIN_REMOTE:FireServer({Move="BlockHigh", Type="Block"})
    elseif blockType == "Torso" then
        MAIN_REMOTE:FireServer({Move="BlockLow", Type="Block"})
    elseif blockType == "Legs" then
        MAIN_REMOTE:FireServer({Move="LegCheck", Type="Block"})
    end
end

local function endBlock()
    MAIN_REMOTE:FireServer({Type="EndBlock"})
end

----------------------------------------------------
-- TAKEDOWN COUNTER IDS
----------------------------------------------------

local COUNTER_IDS = {
    ["7127991726"] = true,
    ["8367769872"] = true,
    ["12488689103"] = true,
    ["12488694961"] = true,
    ["7127993447"] = true,
    ["7127993674"] = true
}

local function strikeInfo()
    return {Move="HeavyLeftBodyStrike", Type="Strike"}
end

----------------------------------------------------
-- AUTO-DENY SYSTEM (with debounce)
----------------------------------------------------

local autoDenyDebounce = false

local function initAutoDeny()
    if not OpponentID then return end

    local ok, isGrappling = pcall(function()
        return PlayerValues[OpponentID].Values.IsGrappling
    end)

    if not ok or not isGrappling then return end

    local trans = isGrappling:FindFirstChild("Transitioning")
    if not trans then return end

    local toValue = trans:FindFirstChild("To")
    if not toValue then return end

    trans.Changed:Connect(function(v)
        if not autodenyEnabled then return end
        if autoDenyDebounce then return end
        if v ~= true then return end

        autoDenyDebounce = true

        local dir = toValue.Value
        local key

        if dir == "Up" then key = Enum.KeyCode.W
        elseif dir == "Down" then key = Enum.KeyCode.S
        elseif dir == "Left" then key = Enum.KeyCode.A
        elseif dir == "Right" then key = Enum.KeyCode.D
        end

        if key then
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.delay(0.1, function()
                VirtualInputManager:SendKeyEvent(false, key, false, game)
                task.delay(0.2, function() -- simple debounce reset
                    autoDenyDebounce = false
                end)
            end)
        else
            autoDenyDebounce = false
        end
    end)
end

----------------------------------------------------
-- ANIM HOOK (prevent duplicate connections)
----------------------------------------------------

local hookedCharacters = {}

local function hookAnimations(char)
    if not char or hookedCharacters[char] then return end
    hookedCharacters[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local anim = hum:FindFirstChildOfClass("Animator")
    if not anim then return end

    anim.AnimationPlayed:Connect(function(track)
        local animId = tostring(track.Animation.AnimationId):gsub("rbxassetid://","")

        if takedownDefenseEnabled and COUNTER_IDS[animId] then
            MAIN_REMOTE:FireServer(strikeInfo())
            return
        end

        if not autoblockEnabled then return end

        local target = nil
        for hitbox, list in pairs(STRIKE_MAP) do
            for _, id in ipairs(list) do
                if animId == id and id ~= "" then
                    target = hitbox
                    break
                end
            end
            if target then break end
        end

        if not target then return end

        if target == "Legs" then
            fireBlock("Legs")
        else
            task.spawn(function()
                while track.IsPlaying and autoblockEnabled do
                    fireBlock(target)
                    task.wait()
                end
                endBlock()
            end)
        end
    end)
end

----------------------------------------------------
-- MAIN LOOP
----------------------------------------------------

task.spawn(function()
    while true do
        updateOpponentID()

        if OpponentID then
            MAIN_REMOTE = RemoteEvents:WaitForChild(OpponentID.."MainFrame")
            initAutoDeny()

            local opp = Players:GetPlayerByUserId(tonumber(OpponentID))
            if opp and opp.Character then
                hookAnimations(opp.Character)
            end
        end

        task.wait(5)
    end
end)