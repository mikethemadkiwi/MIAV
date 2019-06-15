-- this is totally cosmetic. all code is run on the server. all handlers too.
Citizen.CreateThread(function()
    ---- MIAV2 INFO
    RegisterCommand('mv2', function(source, args) 
        TriggerEvent('chat:addMessage', {
            color = { 0, 255, 0},
            multiline = true,
            args = {"MIAV2", "This Banscript was Created by Madkiwi and SinaCutie, and scrutinized by Papa-Bendi and the members of the Ausdoj and ParadiseRP Dev teams. Thanks!"}
          })
    end, false)
    TriggerEvent('chat:addSuggestion', '/mv2', '[MIAV2] Info about the Resource', {})
    ---- BANALL COMMAND
    TriggerEvent('chat:addSuggestion', '/mv2ban', '[MIAV2] Bans a User', {
        {name="UserId", help="[MIAV2] {NUMBER} ID of the Target User"},
        {name="Reason", help="[MIAV2] The Reason you are banning.\nIf Reason is left empty, it uses the default BanMsg"}
    })
    ---- BANLIST CALLBACK
    TriggerEvent('chat:addSuggestion', '/mv2banlist', '[MIAV2] Loads the Banlist', {

    })
    ---- WHITELIST TOGGLE
    TriggerEvent('chat:addSuggestion', '/wltoggle', '[MIAV2] Alters the Global Whitelist Level', {
        {name="Whitelist Level", help="[MIAV2] {NUMBER} Enter a number to set global whitelist"}
    })
    ---- WHITELIST USER
    TriggerEvent('chat:addSuggestion', '/wluser', '[MIAV2] Alter a User Whitelist level', {
        {name="UserId", help="[MIAV2] {NUMBER} ID of the Target User"},
        {name="New Level", help="[MIAV2] {NUMBER} Enter a number to set user's whitelist level"}
    })
end)