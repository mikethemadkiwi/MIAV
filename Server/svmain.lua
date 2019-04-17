debugMode = false
--
AddEventHandler('onMySQLReady', function ()
    print('MIAV2> sql: ready')
    isready = true
    print("MIAV2 CORE LOADED: Injecting Tiger Blood.")
end)
--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    if debugMode == true then
        setKickReason("[MIAV2: Testing Completed. Get out. ]")
    end
    ---
    local steam = nil
    local license = nil
    local ip = nil
    local discord = nil
    for k,v in ipairs(GetPlayerIdentifiers(source))do
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
    --- Steam Check
    if config.requireSteam == true then
        if not steam then
            print('MIAV2> User will be Rejected: '..name..' : no steam detected.')
            setKickReason("[MIAV2: "..config.kickMsg.Steam.." ]")
            CancelEvent()
        end
    end
    -- Discord Check
    if config.requireDiscord == true then
        if not discord then
            print('MIAV2> User will be Rejected: '..name..' : no discord detected.')
            setKickReason("[MIAV2: "..config.kickMsg.Discord.." ]")
            CancelEvent()
        end
    end
    --- SHOULD SERVER ACCEPT PLAYERS
    if config.acceptplayers == false then
        setKickReason("[MIAV2: Connection Refused]")
        CancelEvent()
    end
    -- if server sql connection is ready
    if isready == false then
        setKickReason("[MIAV2: SQL Connection NOT Ready]")
        CancelEvent()
    end
    -- send database request
    local SecCheck = MySQL.Sync.fetchAll('SELECT * FROM `miav2_accounts` WHERE `identifier` = @identifier', {
        ['@identifier'] = license,
    })
    if SecCheck[1] == nil then
        MySQL.Async.execute(
            'INSERT INTO `miav2_accounts` (identifier, name, steam, discord, ip) VALUES (@identifier, @name, @steam, @discord, @ip)',
            {
            ['@identifier'] = license,
            ['@name']       = name,
            ['@steam']       = steam,
            ['@discord']       = discord,
            ['@ip']       = ip
            },
            function(rowsaffected)
                print("MIAV2> "..rowsaffected.." User Created: ".. name .." ["..license.."]") 
            end
        )
    else
        --UPDATE `miav2_accounts` SET `ip` = 'ip:127.0.0.1' WHERE `miav2_accounts`.`id` = 1
        print("MIAV2> 1 User Found: ".. name .." ["..license.."]") 
        -- whitelist check
        if config.requireWhitelist == true then
            if (tonumber(SecCheck[1].wl) < tonumber(config.WL_Level)) then
                print("MIAV2> ".. name .." WL Too Low]")
                setKickReason("[MIAV2: "..config.kickMsg.Whitelist.."]")
                CancelEvent()
            end
        end
        -- ban check
        if config.requireBanCheck == true then
            if SecCheck[1].banned ~= nil then
                print("MIAV2> ".. name .." is Banned]")
                setKickReason("[MIAV2: "..config.kickMsg.Banned.."]")
                CancelEvent()
            end
        end
    end
    ---
    if debugMode == true then
        CancelEvent()
    end
end)