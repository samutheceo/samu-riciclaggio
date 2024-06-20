fx_version "cerulean"
game 'gta5'

description "App per riciclare il denaro sporco."
author '"samu'
version '1.0.0'

lua54 'yes'

ui_page 'web/build/index.html'

client_scripts {
  "client/client.lua",
  "shared/*"
}

server_script "server/*"

files {
  'web/build/index.html',
  'web/build/**/*'
}

shared_scripts {
  'shared/config.lua'
}