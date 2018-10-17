--------------------------------------------------------------------------------------------
AddEventHandler('playerConnecting', function(playerName, setKickReason)
    loadALLBANS()
    local steam
    local license
    local ip
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
    end
    if not steam then
        setKickReason('MIA:V [ Open Steam THEN connect.. Dumbass... ]')
        Log2File("Connect", "MIAV: [ User ".. playerName .." Rejected: Lack of Steam or Game License. ]")
        CancelEvent()
    else   
        for i=0, #IPLIST, 1 do
            if IPLIST[i] == ip then
                Log2File("Ban", "MIA:V: Blacklisted LS[I] ".. ip .."!! Connection Rejected.")   
                setKickReason('MIA:V: Blacklisted LS[I]')
                CancelEvent()
            end
        end
        for i=0, #STEAMLIST, 1 do
            if STEAMLIST[i] == steam then      
                Log2File("Ban", "MIA:V: Blacklisted L[S]I ".. steam .."!! Connection Rejected.")
                setKickReason('MIA:V: Blacklisted L[S]I')
                CancelEvent()
            end
        end
        for i=0, #PRODLIST, 1 do
            if PRODLIST[i] == license then
                Log2File("Ban", "MIA:V: Blacklisted [L]SI ".. license .."!! Connection Rejected.")
                setKickReason('MIA:V: Blacklisted [L]SI')
                CancelEvent()
            end
        end
        if grouplist[steam] == nil then grouplist[steam] = 0 end
        if grouplist[steam] >= whiteliststate then
            Log2File("WList", "MIA:V Whitelist: User ".. playerName .." Allowed ( ".. grouplist[steam]  .." of ".. whiteliststate .." required )")
        else
            Log2File("WList", "MIA:V Whitelist: User ".. playerName .." NOT Allowed ( ".. grouplist[steam]  .." of ".. whiteliststate .." required )")
            setKickReason('MIA:V: Whitelist is ON. Your Current Level is not High Enough.')
            CancelEvent()
        end
    end 
end)

RegisterServerEvent('MIAV:KnockKnock')
AddEventHandler('MIAV:KnockKnock', function()
    local player = source
    Citizen.CreateThread(function()
        local steam
        local license
        local ip
        local playertoload
        ids = GetPlayerIdentifiers(player)
        for i,theIdentifier in ipairs(ids) do
            if string.find(theIdentifier,"license:") or -1 > -1 then
                license = theIdentifier
            elseif string.find(theIdentifier,"steam:") or -1 > -1 then
                steam = theIdentifier
            elseif string.find(theIdentifier,"ip:") or -1 > -1 then
                ip = theIdentifier
            end
        end
        if not steam then
            Log2File("Connect", "MIAV: [ User ".. GetPlayerName(player) .." Rejected: Lack of Steam or Game License. ]")
            DropPlayer(player, "GameLicense is not Present.")
        else
            playertoload = LoadResourceFile(GetCurrentResourceName(), "players/".. license ..".json")
            if playertoload == nil then
                local self = {}
                self.name = GetPlayerName(player)
                self.id = player
                self.license = license
                self.steam = steam
                self.ip = ip
                self.ping = ping
                self.connhistory = {
                    lastip = ip
                }
                local savedata = json.encode(self)
                local savefile = SaveResourceFile(GetCurrentResourceName(), "players/".. license ..".json", savedata, -1)
                playertoload = LoadResourceFile(GetCurrentResourceName(), "players/".. license ..".json")
                local saved = json.decode(playertoload)
                ONLINEPLAYERLIST[player] = saved
                Log2File("Connect",'Player added: '.. GetPlayerName(player) .. ' : '.. license ..'')
            else                
                local savedata = json.decode(playertoload)
                local miavtmp = savedata
                miavtmp.name = GetPlayerName(player)
                miavtmp.id = player
                miavtmp.connhistory.lastip = miavtmp.ip
                miavtmp.connhistory.ip = ip
                local savedata = json.encode(miavtmp)
                local savefile = SaveResourceFile(GetCurrentResourceName(), "players/".. license ..".json", savedata, -1)
                local updatedplayer = LoadResourceFile(GetCurrentResourceName(), "players/".. license ..".json")
                local updated = json.decode(updatedplayer)
                ONLINEPLAYERLIST[player] = updated
                Log2File("Connect",'Player loaded: '.. GetPlayerName(player) .. ' : '.. license ..'')
            end
        end
        return
	end)
end)

AddEventHandler('playerDropped', function()
    local steam
    local license
    local ip       
    ids = GetPlayerIdentifiers(source)
    for i,theIdentifier in ipairs(ids) do
        if string.find(theIdentifier,"license:") or -1 > -1 then
            license = theIdentifier
        elseif string.find(theIdentifier,"steam:") or -1 > -1 then
            steam = theIdentifier
        elseif string.find(theIdentifier,"ip:") or -1 > -1 then
            ip = theIdentifier
        end
    end
    if ONLINEPLAYERLIST[source] then
        local savedata = json.encode(ONLINEPLAYERLIST[source])
        local savefile = SaveResourceFile(GetCurrentResourceName(), "players/".. license ..".json", savedata, -1)
        Log2File("Connect",'Playerdata Saved: '.. GetPlayerName(source) .. ' : '.. license ..'')
        ONLINEPLAYERLIST[source] = nil
    end
    Log2File("Connect",'Player Drop: '.. GetPlayerName(source) .. ' : '.. license ..'')    
end)
----------------------------------------------------------------------------
JustLog("MIA:V CORE LOADED: Instructing Hamsters To Run.")