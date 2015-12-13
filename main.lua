-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local lunatest = require("lunatest")
local common = require("common")
local localization = require( "mod_localize" )

local locale = system.getPreference("locale", "language")

localization:setLocale(locale)

initDataBase()
initData()

lunatest.suite("unitTest")
lunatest.run()
composer.gotoScene( "menu" )