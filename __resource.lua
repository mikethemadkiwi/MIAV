resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'MIAV2 Ban and Client Mitigation Script.'
ui_page 'nui/ui.html'
local ClientScripts = {
	'mv2Client.lua'
} 
local ServerScripts = {
	'@mysql-async/lib/MySQL.lua',
	'mv2Server.lua'
}
local ServerExports = {
    'getUser'
}
local ReqFiles = {
    'nui/index.html',
    'VERSION',
    'CHANGES'
}
files(ReqFiles)
client_scripts(ClientScripts)
server_scripts(ServerScripts)
server_exports(ServerExports)
dependencies {
	'mysql-async'
}