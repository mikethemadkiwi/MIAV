-- trigger the script to run only once player has spawned, this is basically an html frontend, and has no control over actual server events or functions
-- please note: all commands are run with YOUR permissions, so if you dont have access, the server will NOT respond to your requests. even if formatted correctly.
-- dont be THAT guy. inject your penii into other things...
AddEventHandler('playerSpawned', function()
	TriggerServerEvent('MIAV2:playerSpawned')
end)

-- Called when a resource stops
AddEventHandler('onClientResourceStop', function(res)
    print('[MIAV2]: Unloaded!!!! This Server Protected By Virgins. o/')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/mv2', '[MIAV2]', {
        {name="subcommand", help="[MIAV2] Info | Report | Ticket | Kick | Ban | wlUser | wlServer | Reload "},
        {name="Args", help="[MIAV2] command args eg: /mv2 kick [1] {dont be a bully}. [1] is an arg, {2} is the reason arg"}
    })
end)