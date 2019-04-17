---------------------------------------------------------------------------
-- Important Options.
---------------------------------------------------------------------------
config = {}
config.acceptplayers = true
---------------------------------------------------------------------------
config.requireSteam = true
config.requireDiscord = false
config.requireWhitelist = true
config.requireBanCheck = true
-- whitelist
config.WL_Level = 1 -- if users level is below this they will not connect
-- Msgs
config.kickMsg = {
    Steam = "No Steam. Restart Steam and Fivem",
    Discord = "No Discord. Restart Discord and Fivem",
    Whitelist = "Your Whitelist Level is too Low",
    Banned = "You are Banned. Contact Admins",    
}