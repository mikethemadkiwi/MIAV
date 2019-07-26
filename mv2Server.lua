isready = false
debugMode = true
settings = {}
OnlinePlayers = {}
PingTable = {}
RegisterServerEvent('MIAV2:onPlayerAllowed')

local Charset = {
  'a','A','b','B','c','C','d','D','e','E','f','F','g','G','h','H',
  'i','I','j','J','k','K','l','L','m','M','n','N','o','O','p','P',
  'q','Q','r','R','s','S','t','T','u','U','v','V','w','W','x','X',
  'y','Y','z','Z'
}
local Numset = {'0','1','2','3','4','5','6','7','8','9'}
-- FUNCTIONS

function Strip_Control_and_Extended_Codes( str )
    local s = ""
    for i = 1, str:len() do
	if str:byte(i) >= 32 and str:byte(i) <= 126 then
  	    s = s .. str:sub(i,i)
	end
    end
    return s
end


function Strip_Control_Codes( str )
    local s = ""
    for i in str:gmatch( "%C+" ) do
 	    s = s .. i
    end
    return s
end

function debugPrint( str )
  if debugMode then
   Citizen.Trace('[MIAV2]: '..str..'\n')
  --  updateLog(str) -- disabled this temp so i could no overflow the logs.
  else
    updateLog(str)
  end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end


function HexIdToSteamId(hexId)
  local cid = math_floor(tonumber(string_sub(hexId, 7), 16))
  local steam64 = math_floor(tonumber(string_sub( cid, 2)))
  local a = steam64 % 2 == 0 and 0 or 1
  local b = math_floor(math_abs(6561197960265728 - steam64 - a) / 2)
  local sid = "steam_0:"..a..":"..(a == 1 and b -1 or b)
  return sid
end
--
function updateLog(text)
  text = '[MIAV2]: '..text
  MySQL.Async.execute('INSERT INTO `_MIAV2Log` (`logmsg`) VALUES (@text)', {
      ['@text'] = text
  })
end


function updateCheck()
  local CurrentVersion = LoadResourceFile(GetCurrentResourceName(), "VERSION")
  PerformHttpRequest('https://raw.githubusercontent.com/mikethemadkiwi/MIAV/MIAV2/VERSION', function(Error, NewestVersion, Header)
          if tonumber(CurrentVersion) < tonumber(NewestVersion) then
            debugPrint('MIAV2 HAS UPDATED!!!! Get the newest updates!! NAO!!!')
            debugPrint('https://github.com/mikethemadkiwi/MIAV/blob/MIAV2/')
            PerformHttpRequest('https://raw.githubusercontent.com/mikethemadkiwi/MIAV/MIAV2/CHANGES', function(err, CHANGES, head)
              debugPrint(CHANGES)
            end)
          else
              if tonumber(CurrentVersion) > tonumber(NewestVersion) then
                 debugPrint('Welcome to the BETA group')
              end
             debugPrint('MIAV2 is at Latest Version.')
          end
          CurrentVersion = nil
  end)
end

function miav2TagUpdate(uptime)
  local whitelistenabled = "true"
  if settings.WL_Level == 0 then
      whitelistenabled = "false"
  end
  local CurrentVersion = LoadResourceFile(GetCurrentResourceName(), "VERSION")
  local setMenu = '| Whitelist: '..whitelistenabled..' | RequireSteam: '..tostring(settings.requireSteam)..' | RequireDiscord: '..tostring(settings.requireDiscord)..' | Ver: '..tostring(CurrentVersion)..' |'
  ExecuteCommand(('sets MIAV2 "%s"'):format(setMenu))
  ExecuteCommand(('sets Uptime "%s"'):format(uptime))
end
function getSettings()
    local setters = MySQL.Sync.fetchAll('SELECT * FROM `_MIAV2Settings`')    
    miav2TagUpdate("0")
    return setters[1]
end

function wlUserUpdate(identifier, state)
  return MySQL.Async.execute('UPDATE `_MIAV2Users` set `wl` = @wl where `identifier` = @identifier', {
      ['@identifier'] = identifier,
      ['@wl'] = state
  })
end
function wlSettingUpdate(state)
  return MySQL.Async.execute('UPDATE `_MIAV2Settings` set `WL_Level` = @wl', {
      ['@wl'] = state
  })
end

--
function getIdentifiers(source, name)
  local ids = {}  
  ids.steamid  = nil
  ids.license  = nil
  ids.discord  = nil
  ids.xbl      = nil
  ids.liveid   = nil
  ids.ip       = nil
  ids.lastlogin = os.time()
  ids.name = Strip_Control_and_Extended_Codes(name) 
  for k,v in pairs(GetPlayerIdentifiers(source))do        
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        ids.steamid = v
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        ids.license = v
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        ids.xbl  = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        ids.ip = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        ids.discord = v
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        ids.liveid = v
      end    
  end
  return ids
end

function updateIdentifiers(identifier, name, steam, discord, ip)
  -- -- this is old. fix it.
  -- MySQL.Async.execute("UPDATE `_miav2Users` SET name=@name, steam=@steam, discord=@discord, ip=@ip WHERE identifier=@identifier", {
  --     ['@identifier'] = identifier,
  --     ['@name'] = name,
  --     ['@steam'] = steam,
  --     ['@discord'] = discord,
  --     ['@ip'] = ip
  -- })
end

function createUser(identifier, identifiers)
  local newuser = nil
  MySQL.Sync.execute('INSERT INTO `_MIAV2Users` (`identifier`, `identifiers`) VALUES (@identifier, @identifiers)', {
    ['@identifier'] = identifier,
    ['@identifiers'] = identifiers
  },
  function(rowsaffected)
    newuser = MySQL.Sync.fetchAll('SELECT * FROM `_MIAV2Users` WHERE `identifier` = @identifier', {
      ['@identifier'] = identifiers.license
    })
    return newuser
  end)
end


---
function getUserFromID(identifiers)
  local users = MySQL.Sync.fetchAll('SELECT * FROM `_MIAV2Users` WHERE `identifier` = @identifier', {
      ['@identifier'] = identifiers.license
  })
  if users[1] == nil then return nil else return users[1] end
end

function getUserFromSource(source)
  local identifiers = getIdentifiers(source, GetPlayerName(source))
  local users = MySQL.Sync.fetchAll('SELECT * FROM `_MIAV2Users` WHERE `identifier` = @identifier', {
      ['@identifier'] = identifiers.license
  })
  if users[1] == nil then return nil else return users[1] end
end


--- BAN FUNCTIONS
function BanLicense(tarsource, user, reason)  
  local taruser = getIdentifiers(tarsource, GetPlayerName(tarsource))
  local sanReason = Strip_Control_and_Extended_Codes(reason)
  if user == -1 then -- banned by console or non player entity
    if taruser.steamid then end
    if taruser.discord then end
    if taruser.xbl then end
    if taruser.liveid then end
    -- user check required by ip. - discuss with sina
    MySQL.Async.execute('UPDATE `_MIAV2Users` SET `banned` = 1 where `identifier` = @identifier', {
      ['@identifier'] = taruser.license
    },
    function(rowsaffected)
      debugPrint('Banned accounts: {'..rowsaffected..'}')
    end)
    DropPlayer(tarsource, sanReason)
  else
    --banned by player 
    if taruser.steamid then end
    if taruser.discord then end
    if taruser.xbl then end
    if taruser.liveid then end
    -- user check required by ip. - discuss with sina
    MySQL.Async.execute('UPDATE `_MIAV2Users` SET `banned` = 1 where `identifier` = @identifier', {
      ['@identifier'] = taruser.license
    })
    DropPlayer(tarsource, sanReason)
  end
end


--- BAN CHECK FUNCTIONS
function BanCheckLicense(user)
  if user.banned ~= nil then return true else return false end
end


function BanCheckSteam(steamid, user)
  local banned = MySQL.Sync.fetchAll('SELECT * FROM `_MIAV2SteamBan` WHERE `steamid` = @steamid', {
      ['@steamid'] = steamid
  })
  if banned[1] == nil then return false 
  else 
      if user.banned ~= 1 then
        BanLicense(user, -1, settings.kickMsgBanned)
      end
      return true  
  end
end


function BanCheckDiscord(discord, user)
  return false
end


function BanCheckXbl(xbl, user)
  return false
end


function BanCheckLive(live, user)
  return false
end


function BanCheckIP(ip, user)
  return false
end

function pingCheck(sID)
  local pp = GetPlayerPing(sID) -- teehee i said pp!!
  debugPrint(sID..' '.. GetPlayerName(sID) ..' [ '..pp..'/'..settings.pingThreshold..' ]')
  if pp > settings.pingThreshold then return true else return false end
end

function playerConnect(name, setKickReason, deferrals)
  local src = source 
  deferrals.defer()
  local function done(msg)
      if not msg then deferrals.done() else deferrals.done(tostring(msg) and tostring(msg) or "") CancelEvent() end
  end
  local function update(msg)
      deferrals.update(tostring(msg) and tostring(msg) or "")
  end
  if isready == false then
    done("[ SQL Connection NOT Ready ]")
  end
  ---------------------------
  local identifiers = getIdentifiers(source, name)
  if #OnlinePlayers >= GetConvarInt('sv_maxclients', settings.maxPlayers) then
    done("[ This server is full ]")
  end
  ---------------------------
  if settings.acceptPlayers == false then
    done("[ Server is not allowing players at this time ]")
  end
  update("[ Checking your Identity. Please Be Patient ]")    
  Citizen.Wait(2000)
  --license
  if identifiers.license then
    update("[ Licence Key Found ]")
  else
    done("[ Incorrect or No License Found ]")
  end
  --steamid
  if identifiers.steamid then
    update("[ SteamID Found ]")
  else      
    if settings.requireSteam == true then      
      done(settings.kickMsgSteam)
    else
        update("[ No SteamID Account Found ]")
    end    
  end
  --discord
  if identifiers.discord then
   update("[ DiscordID Found ]")
  else      
    if settings.requireDiscord == true then     
      done(settings.kickMsgDiscord)
    else
        update("[ No DiscordID Account Found ]")
    end
  end
  --xbl
  if identifiers.xbl then
    deferrals.update("[ Xbox Live ID Found ]")
  else
    if settings.requireXbl == true then     
      done(settings.kickMsgXbl)
    else
      deferrals.update("[ No Xbl Account Found ]")
    end
  end
  --liveid
  if identifiers.liveid then
    deferrals.update("[ Microsoft Live Account Found ]")
  else
    if settings.requireLive == true then     
      done(settings.kickMsgLive)
    else
      deferrals.update("[ No Microsoft Live Account Found ]")
    end
  end
  --ip
  if identifiers.ip then
    deferrals.update("[ IP Provided to Server ]")
  end
  debugPrint('Loading ' .. identifiers.name .. '')
  local user = getUserFromID(identifiers)
  if user ~= nil then
      update("[ Found Existing User Profile ]")
      Citizen.Wait(1000)
      update("[ Beginning Security Check on Identifiers ]")
      Citizen.Wait(1000)
      if settings.requireBanCheck == true then
        update("[ Matching bans against license ]")

        if BanCheckLicense(user) then 
          done(settings.kickMsgBanned)
        end
      
        if settings.requireSteam == true then   
            update("[ Matching bans against steam user ]")
            if BanCheckSteam(identifiers.steamid, user) then done(settings.kickMsgSteam) end
        end      
        if settings.requireDiscord == true then   
            update("[ Matching bans against Discord user ]")
            if BanCheckDiscord(identifiers.discord, user) then done(settings.kickMsgDiscord) end
        end  
        if settings.requireXbl == true then   
            update("[ Matching bans against Xbox Live user ]")
            if BanCheckXbl(identifiers.xbl, user) then done(settings.kickMsgXbl) end
        end 
        if settings.requireLive == true then   
            update("[ Matching bans against Xbox Live user ]")
            if BanCheckLive(identifiers.liveid, user) then done(settings.kickMsgLive) end
        end
        update("[ Matching bans against ip ]")
        if BanCheckIP(identifiers.ip, user) then done(settings.kickMsgBanned) end
      end
      if settings.requireWhitelist == true then
        update("[ Whitelist is enabled. Confirming Access ]")
        Citizen.Wait(1000)
        if settings.WL_Level > user.wl then 
          done(settings.kickMsgWhitelist)
        end
      end
      --      
      if user.wl >= settings.DevLevel then
        debugPrint('User ['..src..']'..identifiers.name..' added as Dev Role:')
        ExecuteCommand("add_principal identifier.".. user.identifier.." miav2.dev")
      elseif user.wl >= settings.AdminLevel then
        debugPrint('User ['..src..']'..identifiers.name..' added as admin Role:')
        ExecuteCommand("add_principal identifier.".. user.identifier.." miav2.admin")
      elseif user.wl >= settings.modLevel then
        debugPrint('User ['..src..']'..identifiers.name..' added as moderator Role:')
        ExecuteCommand("add_principal identifier.".. user.identifier.." miav2.moderator")
      elseif user.wl >= settings.regLevel then
        debugPrint('User ['..src..']'..identifiers.name..' added as regular Role:')
        ExecuteCommand("add_principal identifier.".. user.identifier.." miav2.regular")
      end
      update("[ Security Checks Complete. Enjoy! ]")
      Citizen.Wait(2000)
      done()
      return
  else
      update("[ Creating a User Profile ]")
      Citizen.Wait(1000)
      local newuser = createUser(identifiers.license, json.encode(identifiers))
     ----
      if settings.requireWhitelist == true then
        update("[ Whitelist is enabled. Confirming Access ]")
        Citizen.Wait(1000)
        if settings.WL_Level > newuser.wl then 
          done(settings.kickMsgWhitelist)
        end
      end
      update("[ Security Checks Complete. Enjoy! ]")
      Citizen.Wait(2000)
      done()
      return
  end
  -- --- END THE DIFFERALS
  done("MIAV2 : Something went terribly wrong")
  ----
end

function playerDisconnect(reason)
  local src = source
  local strReason = Strip_Control_and_Extended_Codes(reason)
  debugPrint(' Saving ' .. GetPlayerName(src) .. ' : '.. strReason ..'')
  ----------------------------------------------------------------------
  -- remove_principal <child_identifier> <parent_identifier>
  local ids = getIdentifiers(source, GetPlayerName(source))
  local user = getUserFromID(ids)
  if user.wl >= settings.DevLevel then
    ExecuteCommand("remove_principal identifier.".. user.identifier.." miav2.dev")
  elseif user.wl >= settings.AdminLevel then
    ExecuteCommand("remove_principal identifier.".. user.identifier.." miav2.admin")
  elseif user.wl >= settings.modLevel then
    ExecuteCommand("remove_principal identifier.".. user.identifier.." miav2.moderator")
  elseif user.wl >= settings.regLevel then
    ExecuteCommand("remove_principal identifier.".. user.identifier.." miav2.regular")
  end
  ----------------------------------------------------------------------
  OnlinePlayers[source] = nil
  PingTable[source] = nil
end

function playerSpawned()
  local ids = getIdentifiers(source, GetPlayerName(source))
  OnlinePlayers[source] = ids
  PingTable[source] = os.time()
end

-- EVENT HANDLERS
AddEventHandler('onMySQLReady', function ()
  settings = getSettings()
  if settings ~= nil then
    isready = true
  end
 debugPrint('[MIAV2]: Settings Updated from MYSQL')
  updateCheck()

end)


AddEventHandler("playerConnecting", playerConnect)

AddEventHandler('playerDropped', playerDisconnect)

RegisterServerEvent('MIAV2:playerSpawned')
AddEventHandler('MIAV2:playerSpawned', playerSpawned)

RegisterServerEvent('MIAV2:getUser')
AddEventHandler('MIAV2:getUser', function(sourceid)
  local identifiers = getIdentifiers(sourceid, GetPlayerName(sourceid))
  local taruser = getUserFromID(identifiers)
  if taruser ~= nil then 
  else return nil end
end)

RegisterCommand("mv2", function(source, args, rawCommand) 
  settings = getSettings()
  if source > 0 then

    -- Chat Commands
    if args[1] ~= nil then
--TriggerClientEvent('chatMessage', -1, "MIAV2", { 255, 255, 255 }, "msg")




            ------------------------------- INFO
            if args[1] == 'info' then
              TriggerClientEvent('chatMessage', -1, "MIAV2", { 0, 255, 0 }, "This Banscript was Created by Madkiwi and SinaCutie, and scrutinized by Papa-Bendi and the members of the Ausdoj and ParadiseRP Dev teams. Thanks!")
        
              
            ------------------------------- Ticket
            -- elseif args[1] == 'ticket' then

            --   --##################################################
            --   if args[2] ~= nil then

            --     if args[2] == 'create' then

            --       if IsPlayerAceAllowed(source, "miav2.ticket.create") then
            --        debugPrint('canrun')
            --       else
            --        debugPrint('cantrun')
            --       end

            --     elseif args[2] == 'update' then

            --       if IsPlayerAceAllowed(source, "miav2.ticket.update") then
            --        debugPrint('canrun')
            --       else
            --        debugPrint('cantrun')
            --       end

            --     else
            --       print (' wot? thats not a ticket command ')
            --     end

                
            --   else
            --    debugPrint('no ticket subcommand, you need one. derpr')
            --   end
            --   --##################################################

            ------------------------------- KICK
            elseif args[1] == 'kick' then
              if IsPlayerAceAllowed(source, "miav2.kick") then               
                if args[2] ~= nil then
                  local pSource = args[2]      
                  -- check if player online just for sanity and check if player kicking is lower rank than curren kick.
                  if args[3] ~= nil then          
                    local sanReason = '' 
                    args[1] = nil
                    args[2] = nil
                    for k,v in pairs(args) do
                      sanReason = ''..sanReason..' '..args[k]
                    end
                    DropPlayer(pSource, sanReason)
                  else
                    --user default
                    DropPlayer(pSource, settings.kickMsgDefault)
                  end
                else
                  TriggerClientEvent('chatMessage', source, "MIAV2", { 255, 0, 0 }, "You did not enter a user Id to kick.")
                end
              else
                TriggerClientEvent('chatMessage', source, "MIAV2", { 255, 0, 0 }, "You do NOT have permission to run this command.")
              end
            ------------------------------- BAN
            elseif args[1] == 'ban' then
              if IsPlayerAceAllowed(source, "miav2.ban") then
                if args[2] ~= nil then
                  local pSource = args[2]
                  -- check if player online just for sanity and check if player kicking is lower rank than curren kick.
                  if args[3] ~= nil then                
                    local sanReason = '' 
                    args[1] = nil
                    args[2] = nil
                    for k,v in pairs(args) do
                      sanReason = ''..sanReason..' '..args[k]
                    end
                    BanLicense(pSource, OnlinePlayers[source], sanReason)
                    DropPlayer(pSource, sanReason)
                  else
                    --user default
                    BanLicense(pSource, OnlinePlayers[source], sanReason)
                    DropPlayer(pSource, settings.kickMsgDefault)
                  end
                else
                  TriggerClientEvent('chatMessage', source, "MIAV2", { 255, 0, 0 }, "You did not enter a user Id to kick.")
                end
              else
                TriggerClientEvent('chatMessage', source, "MIAV2", { 255, 0, 0 }, "You do NOT have permission to run this command.")
              end
            ------------------------------- RELOAD
            elseif args[1] == 'reload' then
              if IsPlayerAceAllowed(source, "miav2.reload") then
                settings = getSettings()
                TriggerClientEvent('chatMessage', source, "MIAV2", { 0, 255, 0 }, "Settings Updated.")
              else
                TriggerClientEvent('chatMessage', source, "MIAV2", { 255, 0, 0 }, "You do NOT have permission to run this command.")
              end
            -------------------------------
            else
              TriggerClientEvent('chatMessage', source, "MIAV2", { 255, 0, 0 }, "That is not a subcommand")
            end







    else
     debugPrint('no subcommand')
    end
  
  else           
    
    
    --##############
            -- Console Commands
            if args[1] == 'info' then              
              local CurrentVersion = LoadResourceFile(GetCurrentResourceName(), "VERSION")
             debugPrint('Version '.. tostring(CurrentVersion))
             debugPrint('This Banscript was Created by Madkiwi and SinaCutie, and scrutinized by Papa-Bendi and the members of the Ausdoj and ParadiseRP Dev teams. Thanks!')
            elseif args[1] == 'kick' then
                      if args[2] ~= nil then                        
                        local pSource = args[2]
                        -- check if player online just for sanity and check if player kicking is lower rank than curren kick.
                        if args[3] ~= nil then                 
                          local sanReason = '' 
                          args[1] = nil
                          args[2] = nil
                          for k,v in pairs(args) do
                            sanReason = ''..sanReason..' '..args[k]
                          end
                          DropPlayer(pSource, sanReason)
                        else
                          --user default
                          DropPlayer(pSource, settings.kickMsgDefault)
                        end
                      else
                       debugPrint('no player id specified for kick.')
                      end
            elseif args[1] == 'ban' then
              if args[2] ~= nil then
                local pSource = args[2]
                -- check if player online just for sanity and check if player kicking is lower rank than curren kick.
                if args[3] ~= nil then            
                  local sanReason = '' 
                  args[1] = nil
                  args[2] = nil
                  for k,v in pairs(args) do
                    sanReason = ''..sanReason..' '..args[k]
                  end
                  BanLicense(pSource, -1, sanReason)
                  DropPlayer(pSource, sanReason)
                else
                  BanLicense(pSource, -1, settings.kickMsgBanned)
                  DropPlayer(pSource, settings.kickMsgBanned)
                end
              else
               debugPrint('no player id specified for kick.')
              end

            elseif args[1] == 'reload' then

              settings = getSettings()
             debugPrint('Reloaded settings from MYSQL') 
            elseif args[1] == 'users' then
             debugPrint("Online Players")
              for key, val in pairs(OnlinePlayers) do
               debugPrint(key, ""..val.name.." { "..val.license.." } | IP: "..val.ip.." |")
              end
            end
    --##############
  end
end, false)
-------------------------------------------------- 
CreateThread(function()
	while true do
  Wait(0)
-------------------------------------------------- 
        if settings.pingInterval ~= nil then  
          for _, v in ipairs(GetPlayers()) do
            if PingTable[v] == nil then PingTable[v] = os.time() end 
            local tPingDiff = PingTable[v] + settings.pingInterval 
            if tPingDiff <= os.time() then
              if pingCheck(v) then DropPlayer(v, settings.kickMsgPing) end
              PingTable[v] = os.time()
            end
          end
        end
--------------------------------------------------
	end
end)
--------------------------------------------------
Citizen.CreateThread(function()
    local uptimeMinute, uptimeHour, uptime = 0, 0, ''
    uptime = string.format("%02dh %02dm", uptimeHour, uptimeMinute)
    miav2TagUpdate(uptime)
	while true do
		Citizen.Wait(1000 * 60) -- every minute
		uptimeMinute = uptimeMinute + 1
		if uptimeMinute == 60 then
			uptimeMinute = 0
			uptimeHour = uptimeHour + 1
		end
		uptime = string.format("%02dh %02dm", uptimeHour, uptimeMinute)
    miav2TagUpdate(uptime)
	end
end)