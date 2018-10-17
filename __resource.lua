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
	'MIAV_Banhammer.lua',
	'MIAV_cEvents.lua',
	'MIAV_Loop.lua',
	'MIAV_server.lua',
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