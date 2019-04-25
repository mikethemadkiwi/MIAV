isready = false
debugMode = false
settings = {}
OnlinePlayers = {}
--
-- FUNCTIONS
--
function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function getSettings()
    local setters = MySQL.Sync.fetchAll('SELECT * FROM `_miav2_settings`')
    local whitelistenabled = "true"
    if setters[1].WL_Level == 0 then
        whitelistenabled = "false"
    end
    local setMenu = '| Whitelist: '..whitelistenabled..' | RequireSteam: '..tostring(setters[1].requireSteam)..' | RequireDiscord: '..tostring(setters[1].requireDiscord)..' |'
    ExecuteCommand(('sets MIAV2 "%s"'):format(setMenu))
    return setters[1]
end
function setSetting(setting, value)
    local s = {
        'acceptPlayers',
        'requireSteam',
        'requireDiscord',
        'requireWhitelist',
        'requireBanCheck',
        'pingThreshold',
        'WL_Level'
    }
    if has_value(s, setting) then
        return MySQL.Sync.execute('UPDATE `_miav2_settings` SET @setting = @value', {
            ['@setting'] = setting,
            ['@value'] = value
        })
    end
    settings = getSettings()
end
function createUser(identifier, name, steam, discord, ip)
    MySQL.Sync.execute(
        'INSERT INTO `_miav2` (identifier, name, steam, discord, ip) VALUES (@identifier, @name, @steam, @discord, @ip)', {
            ['@identifier'] = identifier,
            ['@name']       = name,
            ['@steam']      = steam,
            ['@discord']    = discord,
            ['@ip']         = ip
        },
        function(rowsaffected)
            updateLog(rowsaffected.." User Created: ".. name .." ["..identifier.."]") 
        end)
end
function updateIdentifiers(identifier, name, steam, discord, ip)
    MySQL.Async.execute("UPDATE `_miav2` SET name=@name, steam=@steam, discord=@discord, ip=@ip WHERE identifier=@identifier", {
        ['@identifier'] = identifier,
        ['@name'] = name,
        ['@steam'] = steam,
        ['@discord'] = discord,
        ['@ip'] = ip
    })
end
function getUser(license)
    local users = MySQL.Sync.fetchAll('SELECT * FROM `_miav2` WHERE `identifier` = @identifier', {
        ['@identifier'] = license,
    })
    return users[1]
end
function checkPing()
    for k,player in #OnlinePlayers do
        currentPing = GetPlayerPing(k)
        if currentPing > settings.pingThreshold then
            kickPlayer(k, settings.kickMsgPing)            
        end
    end
end
function checkPlayer(player)
    local steam = nil
    local license = nil
    local ip = nil
    local discord = nil
    local name = GetPlayerName(player)
    for k,v in ipairs(GetPlayerIdentifiers(player))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steam = v
        end
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
        if string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
        end
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end
    end
    if settings.requireSteam == true then
        if not steam then
            return settings.kickMsgSteam
        end
    end
    if settings.requireDiscord == true then
        if not discord then
            return settings.kickMsgDiscord
        end
    end
    local SecCheck = getUser(license)
    if SecCheck == nil then
        createUser(license, name, steam, discord, ip)
        SecCheck = getUser(license)
    else
        updateIdentifiers(license, name, steam, discord, ip)        
    end
    if settings.requireWhitelist == true then
        if (tonumber(SecCheck.wl) < tonumber(settings.WL_Level)) then
            return settings.kickMsgWhitelist
        end
    end
    if settings.requireBanCheck == true then
        if SecCheck.banned ~= nil then
            return settings.kickMsgBanned
        end
    end
    OnlinePlayers[player] = SecCheck
    return true
end
function kickPlayer(player, reason)
    DropPlayer(player, reason)
end
function updateLog(text)
    text = '[MIAV2]: '..text
    print(text)
    return MySQL.Async.execute('INSERT INTO `_miav2_log` (`logmsg`) VALUES (@text)', {
        ['@text'] = text
    })
end
function setBan(identifier, banBy, banReason)
    return MySQL.Async.execute('UPDATE `_miav2` SET `banned` = 1, `banBy` = @banBy, `banReason` = @banReason where `identifier` = @identifier', {
        ['@identifier'] = identifier,
        ['@banBy'] = banBy,
        ['@banReason'] = banReason
    })
end
function wlUpdate(identifier, state)
    return MySQL.Async.execute('UPDATE `_miav2` set `wl` = @wl where `identifier` = @identifier', {
        ['@identifier'] = identifier,
        ['@wl'] = state
    })
end
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
--
-- EVENT HANDLERS
--
AddEventHandler('onMySQLReady', function ()
    settings = getSettings()
    if settings ~= nil then
        isready = true
    end
    updateLog("CORE LOADED")
end)
--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)  
    if debugMode == true then
        setKickReason("[MIAV2: Testing Completed. Get out.]")
    end
    if isready == false then
        setKickReason("[MIAV2: SQL Connection NOT Ready]")
        CancelEvent()
    end 
    if #OnlinePlayers >= GetConvarInt('sv_maxclients', 64) then
        setReason('This server is full ')
        CancelEvent()
    end
    settings = getSettings()
    if settings.acceptPlayers == false then
        setKickReason("[MIAV2: Connection Refused]")
        CancelEvent()
    else
        playercheck = checkPlayer(source)
        if playercheck ~= true then
            updateLog(name .. ": ".. playercheck)
            setKickReason("[MIAV2]: ".. playercheck)
            CancelEvent()
        else
            updateLog("User Online: ".. OnlinePlayers[source].name.." ["..OnlinePlayers[source].identifier.."]") 
        end
    end
    if debugMode == true then
        CancelEvent()
    end
end)
--
AddEventHandler('chatMessage', function(source, name, msg)
    -- print(source..'<'..name..'> '..msg..'')
    sm = stringsplit(msg, " ")    
    -- if OnlinePlayers[source] ~= nil then
    --     if OnlinePlayers[source].wl >= settings.modLevel then
    -- --         ----------- Mod Commands

    -- --          -- whitelist toggle
    --         if sm[1] == "/wltoggle" then
    --             if sm[2] ~= nil then
    --                 local newwlstate = tonumber(sm[2])
    --                 if newwlstate > OnlinePlayers[source].wl then newwlstate = OnlinePlayers[source].wl end
    --                 if newwlstate < 0 then newwlstate = 0 end
    --                 updateLog("Whitelist Lvl Updated to: ".. newwlstate .. " by ".. OnlinePlayers[source].name)
    --                 wlUpdate(OnlinePlayers[source].identifier, newwlstate)
    --             end
    --             CancelEvent()
    --         end 

    -- --         -- ban command
    --         if sm[1] == "/banall" then
    --             if sm[2] ~= nil then                    
    --                 target = tonumber(sm[2])
    --                 if OnlinePlayers[target].wl < OnlinePlayers[source].wl then
    --                     setBan(OnlinePlayers[target].identifier, OnlinePlayers[source].name, settings.kickMsBanned)
    --                     kickPlayer(target, source)
    --                 else
    --                     updateLog("Ban aborted, "..OnlinePlayers[target].name.." [".. OnlinePlayers[target].steam .."] is >= "..OnlinePlayers[target].name.." ["..OnlinePlayers[source].steam.."]")
    --                 end
    --             end
    --             CancelEvent()
    --         end


    -- --         ---------------------------------                             
    --     end        
    --     if OnlinePlayers[source].wl >= settings.AdminLevel then
    -- --         ----------- Admin Commands
            
    --         -- miav2 settings toggle
    --         if sm[1] == "/miav2set" then
    --             local key
    --             local value
    --             if sm[2] ~= nil then                    
    --                 key = tonumber(sm[2])
    --                 if sm[3] ~= nil then                    
    --                     value = tonumber(sm[3])
    --                     setSetting(key, value)
    --                    ---
    --                 end
    --             end
    --             CancelEvent()
    --         end 

    --         ---------------------------------                           
    --     end

    -- end
end)

AddEventHandler('playerDropped', function()
    updateLog('Player Drop: '.. GetPlayerName(source))
    OnlinePlayers[source] = nil
end)
-------------------------- CODE NOT ADDED YET --------------------------
-------------------------- CODE NOT ADDED YET --------------------------

-- we're being asked if we plan to cross reference if someone getas on thier buddies gta using thier own steam and will it ban... should we cross reference ban info? and how often?!
-- i'd also like to have it check the github version when it's loaded. so we can check if they're running our latest repo.

-------------------------- CODE NOT ADDED YET --------------------------
-------------------------- CODE NOT ADDED YET --------------------------