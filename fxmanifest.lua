fx_version 'cerulean'

name 'qidentification'
description 'Identification cards script built to work with linden_inventory'

author 'Noms'
game 'gta5'


ui_page 'html/index.html'


dependencies {
	'es_extended',
	'oxmysql'
}

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}


server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/fonts/roboto/*.woff',
	'html/assets/fonts/roboto/*.woff2',
	'html/assets/fonts/justsignature/JustSignature.woff',
	'html/assets/images/*.png'
}
