fx_version 'cerulean'
game 'gta5'

description 'Diesel Lap Heist'
version '1.0.0'

author 'NT Diesel#4486'

shared_script 'config.lua'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    "client/Editables-Client.lua",
    'client/functions.lua',  
    'client/main.lua',
    'client/handledoors.lua'
}

server_scripts {
    'Editables-Server.lua',
    'server/main.lua'
}

dependencies {
    'Diesel-Hack'
}

lua54 'yes'

escrow_ignore {

    "client/Editables-Client.lua",
    'Editables-Server.lua',
    'config.lua',
    'shared.lua',
    'inv.js',
    'imgs/*.png', 
}