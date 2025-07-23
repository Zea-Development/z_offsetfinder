---@section fx_information

fx_version("cerulean")
game("gta5")
lua54("yes")
use_experimental_fxv2_oal("yes")

---@section resource_information

name("z_offsetfinder")
author("Zea Development - https://discord.gg/zHvPyJzhQU")
url("https://zeadevelopment.com/")
version("22c7250")

---@section shared_script

shared_script({
    "config.lua",
})

---@section client_script

client_script({
    "core/main.lua",
    "core/classes/*.lua",
})

---@section ui_page

ui_page("web/index.html")

---@section files

files({
    "web/**",
})
