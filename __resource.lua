resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'Ban and Client Mitigation Script. V2.'

-- Banlist NUI
ui_page 'nui/ui.html'

-- Client
client_scripts {
	'empty.lua'
} 
-- Server
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'svmain.lua'
}
-- NUI Files
files {
    'nui/index.html',
    'VERSION'
}
-- Dependancies
dependencies {
	'mysql-async'
}