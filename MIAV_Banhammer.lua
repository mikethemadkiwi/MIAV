JustLog("MIA:V: - Loaded Server Config")
loadALLBANS()
-------------------------------------------------------------------------------------------------------------------
function allbanmeplz(targetID, sourceID)
    nameal = GetPlayerName(targetID)    
    local steam
    local license
    local ip
    for k,v in ipairs(GetPlayerIdentifiers(targetID))do
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
    if nameal ~= nil then
        table.insert(IPLIST, ip)
        table.insert(STEAMLIST, steam)
        table.insert(PRODLIST, license)
        TriggerClientEvent('chatMessage', -1, "MIA:V", {186, 218, 85}, "User: ".. nameal .." was Banned.")
        bhname = GetPlayerName(sourceID)
        Log2File("Ban", "User ".. nameal .." BANNED: ".. ip ..", ".. license ..", ".. steam .." BanHammer: [ ".. bhname .." ] ")
        DropPlayer(targetID, defaultBanMsg)
        saveipList()
        savesteamList()
        saveprodList()
    end
end
--
function saveipList()
    local saveipdata = json.encode(IPLIST)
    local ipfile = SaveResourceFile(GetCurrentResourceName(), "banlists/ipBanList.json", saveipdata, -1)
end
--
function savesteamList()
    local savesteamdata = json.encode(STEAMLIST)
    local steamfile = SaveResourceFile(GetCurrentResourceName(), "banlists/steamBanList.json", savesteamdata, -1)
end
--
function saveprodList()
    local saveproddata = json.encode(PRODLIST)
    local prodfile = SaveResourceFile(GetCurrentResourceName(), "banlists/prodBanList.json", saveproddata, -1)
end
-------------------------------------------------------------------------------------------------------------------
JustLog('MIA:V: - Ban Functions Loaded.')
JustLog('MIA:V: - Whitelist set to: '.. whiteliststate)
JustLog("MIA:V: - PingCheck {".. pingLimit .."}ms Limit")
-------------------------------------------------------------------------------------------------------------------