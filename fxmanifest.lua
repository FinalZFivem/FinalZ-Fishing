fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
} 

client_script 'client.lua'

server_script 'server.lua'

ui_page 'ui/index.html'

files {
    'ui/img/*',
    'ui/index.html',
    'ui/script.js'
}
escrow_ignore {
    'config.lua'
}