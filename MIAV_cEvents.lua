AddEventHandler('chatMessage', function(source, name, msg) 
    chatname = GetPlayerName(source)
    sm = stringsplit(msg, " ");
    if grouplist[ONLINEPLAYERLIST[source].steam] ~= nil then
        if grouplist[ONLINEPLAYERLIST[source].steam] >= ranklist["Moderator"] then
            if sm[1] == "/wltoggle" then
                CancelEvent()
                if sm[2] ~= nil then
                    local newwlstate = tonumber(sm[2])
                    if newwlstate > grouplist[ONLINEPLAYERLIST[source].steam] then newwlstate = grouplist[ONLINEPLAYERLIST[source].steam] end
                    if newwlstate < 0 then newwlstate = 0 end
                    Log2File("WList", "MIA:V Whitelist Lvl Updated to: ".. newwlstate .. " by ".. chatname .."")
                    whiteliststate = newwlstate
                end
            end
            if sm[1] == "/banall" then
                CancelEvent()
                if sm[2] ~= nil then                    
                    target = tonumber(sm[2])
                    if grouplist[ONLINEPLAYERLIST[target].steam] ~= nil then
                        if grouplist[ONLINEPLAYERLIST[target].steam] < grouplist[ONLINEPLAYERLIST[source].steam] then
                            allbanmeplz(target, source)
                        else
                            Log2File("Ban", "MIA:V ban aborted, ".. ONLINEPLAYERLIST[target].steam .." is >= ".. ONLINEPLAYERLIST[source].steam .."")
                        end
                    else                        
                        allbanmeplz(target, source)
                    end
                end
            end
        end
    end
end)