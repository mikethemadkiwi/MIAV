resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
-- resource_type 'gametype' { name = 'Freeroam' }
-- -- resource_type 'map' { gameTypes = { dev = true } }

-- map 'devMap.lua'

-- description 'Fivem FreeRoam dev Info Base - Non db Required'
-- ui_page 'ui.html'

-- Server
server_scripts {
	'MIAV_Common.lua',
	'MIAV_Config.lua',
	'MIAV_server.lua',
	'MIAV_Banhammer.lua',
	'MIAV_cEvents.lua',
	'MIAV_Loop.lua',
}

-- Client
client_scripts {
	'MIAV_client.lua'
}

-- -- NUI Files
-- files {
-- 	-- 'ui.html',
-- 	-- 'pdown.ttf'
-- }
-- 
-- exports {
-- 	'getSharedObject'
-- }
-- 
-- server_exports {
-- 	'getSharedObject'
-- }
-- 
-- dependencies {
-- 	'baseevents'
-- }
--there is a way to save json files in lua, i have a file here to make it happen, i'm gonna flatfile the whole thing til we get db async setup then we'll db.
-- That is a very good idea.