resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
-- resource_type 'gametype' { name = 'MIAV' }
-- resource_type 'map' { gameTypes = { dev = true } }

-- map 'devMap.lua'

description 'NoDB Ban and Client Mitigation Script. V2.'
ui_page 'ui/ui.html'

-- Server
server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'Server/svfunc.lua',
	'Server/svmain.lua'
}

-- Client
client_scripts {
	'config.lua',
	'Client/clfunc.lua',
	'Client/clmain.lua'
}

-- NUI Files
files {
	'ui/ui.html',
}
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