resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'Ban and Client Mitigation Script. V2.'
-- Client
client_scripts {
	'empty.lua'
} 
-- Server
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'svmain.lua'
}
-- Dependancies
dependencies {
	'mysql-async'
}