resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'Ban and Client Mitigation Script. V2.'
ui_page 'ui/ui.html'
-- Server
server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'Server/svmain.lua',
	'Server/svevents.lua'
}
-- Client
client_scripts {
	'Client/clmain.lua'
}
-- NUI Files
files {
	'ui/ui.html',
}

exports {
	'getSharedObject'
}
server_exports {
	'getSharedObject'
}
-- Dependancies
dependencies {
	'async',
	'mysql-async'
}