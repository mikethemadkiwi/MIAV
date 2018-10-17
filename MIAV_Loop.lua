Citizen.CreateThread(function()
    while(true) do
        for i, playerobj in pairs(ONLINEPLAYERLIST) do
            playerobj.ping = GetPlayerPing(playerobj.id)
            local savedata = json.encode(playerobj)
            local savefile = SaveResourceFile(GetCurrentResourceName(), "players/".. playerobj.license ..".json", savedata, -1)
            local updatedplayer = LoadResourceFile(GetCurrentResourceName(), "players/".. playerobj.license ..".json")
            local updated = json.decode(updatedplayer)
            ONLINEPLAYERLIST[playerobj.id] = updated
            --
            if GetPlayerPing(playerobj.id) >= pingLimit then
                Log2File("Ping", "MIA:V Ping is too high ( Limit: " .. pingLimit .. "ms You: " .. GetPlayerPing(playerobj.id) .. "ms )")
                DropPlayer(playerobj.id, "Ping is too high ( Limit: " .. pingLimit .. "ms You: " .. GetPlayerPing(playerobj.id) .. "ms )")
            end
            --
            if grouplist[playerobj.steam] < whiteliststate then
                Log2File("WList", "MIA:V Whitelist: User dropped: ".. playerobj.steam .." ( ".. grouplist[playerobj.steam]  .." of ".. whiteliststate .." required ) ")
                DropPlayer(playerobj.id, "MIA:V Whitelist Enabled. Your Level is not high enough.")
            end            
        end
        Citizen.Wait(1000)
    end
end)