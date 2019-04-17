isready = false
--
AddEventHandler('onMySQLReady', function ()
    print('MIAV2> sql: ready')
    isready = true
    print("MIAV2 CORE LOADED: Injecting Tiger Blood.")
end)

function MIAV2WLCheck(name, license, steam, discord, ip)
    local retval = 0        
    MySQL.Async.fetchAll(
        'SELECT * FROM `miav2_accounts` WHERE `identifier` = @identifier',
        {
        ['@identifier'] = license
        },
        function(result)
        --------------------------    
            if result ~= nil then
                for j=1, #result, 1 do 
                    print("MIAV> Name: ".. result[j].name .. " ["..result[j].identifier.."] Data Found")
                    -- retval = result[j].wl
                    -- config.playerList[source].wl = result[j].wl
                end   
            else
                MIAV2CreateUser(license, name, steam, discord, ip) 
            end
            -- print("MIAV2> "..retval)
            -- return retval 
        ------------------------------
        end
    )   
end

function MIAV2CreateUser(license, name, steam, discord, ip)
    
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
        print("MIAV2> User Created: ".. name) 
        end
    )

end

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
        local steam = ''
        local license = ''
        local ip = ''
        local discord = ''
        -- config.playerList[source] = {banned = false, wl = 0}

        --- FIND IDENTIFIERS
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

        --- SHOULD SERVER ACCEPT PLAYERS
        if config.acceptplayers == false then
            setKickReason("[MIAV2: Server in Online Closed Mode]")
            CancelEvent()
        end
        if isready == false then
            setKickReason("[MIAV2: Server is Loading]")
            CancelEvent()
        end
        --- Steam Check
        if (config.requireSteam == true) then
            if not steam then
                print('MIAV2> User will be Rejected: '..name..' : no steam detected.')
                setKickReason("server requires steam, restart steam and fivem")
                CancelEvent()
            end
        end
        -- Discord Check
        if (config.requireDiscord == true) then
            if not discord then
                print('MIAV2> User will be Rejected: '..name..' : no discord detected.')
                setKickReason("server requires discord, restart discord and fivem")
                CancelEvent()
            end
        end
        MIAV2WLCheck(name, license, steam, discord, ip)
        -- --- Whitelist Check
                                                -- if (config.requireWhitelist == true) then 
                                                --     if ( config.WL_Level > securitycheck ) then
                                                --         print('MIAV2> User will be Rejected: '..name..' : WL Level too low')
                                                --         setKickReason("your whitelist level is too low")
                                                --         CancelEvent()
                                                --     else
                                                --         print('MIAV2> User : '..name..' : Allowed.')
                                                --     end
                                                -- end
        -------
        setKickReason("[MIAV2: Devmode.]")
        CancelEvent()
end)
----------------------------------------------------------------------------