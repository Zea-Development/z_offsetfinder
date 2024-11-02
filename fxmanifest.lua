---@type fx_information

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

---@type resource_information

name 'z_offsetfinder'
author 'Zea Development - https://discord.gg/zHvPyJzhQU'
url 'https://zeadevelopment.com/'
version 'v1.0.0'

---@type shared_script

shared_script ({
    'config.lua',
})

---@type client_script

client_script ({
    'core/cl-main.lua',
    'core/classes/*.lua'
})

---@type ui_page

ui_page 'web/index.html'

---@type files

files ({ 
    'web/*.html',
    'web/*.css',
    'web/*.js'
})