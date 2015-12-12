local sceneName = "menu"

local gameNetwork = require( "gameNetwork" )
local common = require("common")
local composer = require( "composer" )
local widget = require( "widget" )
local localization = require( "mod_localize" )
local playerName, googlePlayGames

local _s = localization.str

local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local scene = composer.newScene( sceneName )

local background, SOUND
local soundThemeSong = audio.loadSound("sounds/simon_says_theme.mp3")

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local originX = display.screenOriginX
local originY = display.screenOriginY
local height = contentHeight-originY*2

local textSize = contentWidth/8
local textSizeTitle = contentWidth/7

local textTitle, textPlayer, textStart, textLevels, textRanking, textSound, textVibrate, textLabel

local buttonStart, buttonLevels, buttonRanking, checkboxSheet, checkSound, checkVibrate 

local checkboxOptions = {
        frames =
    {
        {
            x = 1,
            y = 0,
            width = 14,
            height = 32
        },

        {
            x = 21,
            y = 0,
            width = 14,
            height = 32
        },
  },
  
    sheetContentWidth = 36,
    sheetContentHeight = 32
}

local optionsTransition = {
      effect = "zoomInOutFade",
      time = 200
    }

---------------------------------------------------------------------------------

function showPlayerName()
    textPlayer.text = "Player: "..playerName
end

local function onSoundPress( event )
  local check = event.target
  SOUND = check.isOn
  setSound(SOUND)
  if(SOUND==false)then
    audio.fadeOut({channel=1, time=200})
      elseif (SOUND==true)then
        audio.play(soundThemeSong,{channel=1,loops=-1})
        audio.fade({channel=1, volume = 1.0})
  end
end

local function onVibratePress( event )
  local check = event.target
  VIBRATE = check.isOn
  setVibrate(VIBRATE)
end

function getTextLabel()
  if(getCurrentLevel(1)~=1)then
    buttonStart:setLabel(_s("continue"))
    else
      buttonStart:setLabel(_s("start"))
  end
end

function scene:create( event )
  local sceneGroup = self.view

  checkboxSheet = graphics.newImageSheet( "images/checkbox.png", checkboxOptions )

  background = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height)
  background:setFillColor(0.59,0.99,0.79)
  sceneGroup:insert(background)

  textTitle = display.newText (_s("Who Says?"),contentWidth/2, (height/10)*1, native.systemFontBold, textSizeTitle)
  textTitle:setFillColor( 1, 0.4, 0.4 )
  sceneGroup:insert(textTitle)

  textPlayer = display.newText ("",contentWidth/2, (height/10)*8.9, native.systemFontBold, textSize/2)
  textPlayer:setFillColor( 1, 0.4, 0.4 )
  sceneGroup:insert(textPlayer)

  textSound = display.newText (_s("sound"),contentWidth/1.35, (height/10)*7.35, native.systemFontBold, textSize/2)
  textSound:setFillColor( 1, 0.4, 0.4 )
  sceneGroup:insert(textSound)

  textVibrate = display.newText (_s("vibrate"),contentWidth/1.4, (height/10)*8, native.systemFontBold, textSize/2)
  textVibrate:setFillColor( 1, 0.4, 0.4 )
  sceneGroup:insert(textVibrate)

  buttonStart = widget.newButton
    {
      label = "",
      emboss = false,
      shape="roundedRect",
      width = contentWidth*0.9,
      height = textSize*1.3,
      font = native.systemFontBold,
      fontSize = textSize,
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
      fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.4, 0.4, 0.7 }},
    
    }

  getTextLabel()

  buttonLevels = widget.newButton
    {
      label = _s("levels"),
      emboss = false,
      shape="roundedRect",
      width = contentWidth*0.9,
      height = textSize*1.3,
      font = native.systemFontBold,
      fontSize = textSize,
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 }},
      fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.4, 0.4, 0.7 }},
    
    }

  buttonRanking = widget.newButton
    {
      label = _s("achievements"),
      emboss = false,
      shape="roundedRect",
      width = contentWidth*0.9,
      height = textSize*1.3,
      font = native.systemFontBold,
      fontSize = textSize,
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 }},
      fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.4, 0.4, 0.7 }},
    
    }

  checkSound = widget.newSwitch
    {
      left = 190,
      top = 180,
      style = "checkbox",
      sheet = checkboxSheet,
      initialSwitchState = getSound(),
      frameOn = 2,
      frameOff = 1,
      id = "checkSound",
      onPress = onSoundPress
    }

  checkVibrate = widget.newSwitch
    {
      left = 190,
      top = 180,
      style = "checkbox",
      sheet = checkboxSheet,
      initialSwitchState = getVibrate(),
      frameOn = 2,
      frameOff = 1,
      id = "checkVibrate",
      onPress = onVibratePress
    }

  checkSound.x = contentWidth/1.11
  checkSound.y = (height/10)*7.35

  checkVibrate.x = contentWidth/1.11
  checkVibrate.y = (height/10)*8

  buttonStart.x = display.contentCenterX
  buttonStart.y = (height/10)*3.7

  buttonLevels.x = display.contentCenterX
  buttonLevels.y = (height/10)*5

  buttonRanking.x = display.contentCenterX
  buttonRanking.y = (height/10)*6.3

  if(system.getInfo("environment") == "device" and "Win"==system.getInfo("platformName"))then
    buttonRanking.alpha=0
    checkVibrate.alpha=0
    textVibrate.alpha=0
  end

  sceneGroup:insert(checkSound)
  sceneGroup:insert(checkVibrate)
  sceneGroup:insert(buttonStart)
  sceneGroup:insert(buttonLevels)
  sceneGroup:insert(buttonRanking)
end

function scene:show( event )
  local sceneGroup = self.view
  local phase = event.phase
  if phase == "will" then
    getTextLabel()
    SOUND = getSound()
  elseif phase == "did" then
    getTextLabel()
    SOUND = getSound()
    if(SOUND)then
      audio.play(soundThemeSong,{channel=1,loops=-1})
      audio.fade({channel=1, volume = 1.0})
    end
          
    function buttonStart:touch ( event )
      local phase = event.phase
      if "ended" == phase then
        composer.setVariable("origin",0)
        composer.gotoScene( "game", optionsTransition )
      end
    end
                 
    function buttonLevels:touch ( event )
      local phase = event.phase
      if "ended" == phase then
        composer.gotoScene( "worlds", optionsTransition )
      end
    end
         
    function buttonRanking:touch ( event )
      local phase = event.phase
      if "ended" == phase then
        if("Android"==system.getInfo( "platformName" ))then
          gameNetwork.show( "achievements" )
        end
      end
    end
       
    gameNetworkSetup()
    buttonStart:addEventListener( "touch", buttonStart )
    buttonLevels:addEventListener( "touch", buttonLevels )
    buttonRanking:addEventListener( "touch", buttonRanking )   
    end 
end

function scene:hide( event )
  local sceneGroup = self.view
  audio.fadeOut({channel=1, time=200})
end

local function loadLocalPlayerCallback( event )
  playerName = event.data.alias
  showPlayerName()
  if(event.data.isError==false)then
    googlePlayGames=true
    else
      googlePlayGames=false
  end
end

function gameNetworkLoginCallback( event )
  gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
  return true
end

function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
end

function gameNetworkSetup()
  if("Android"==system.getInfo( "platformName" ))then
    gameNetwork.init( "google", gpgsInitCallback )
 end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
