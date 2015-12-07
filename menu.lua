local sceneName = "menu"

local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )
local gameNetwork = require( "gameNetwork" )

local playerName, googlePlayGames

local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local scene = composer.newScene( sceneName )

local background, SOUND

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local originX = display.screenOriginX
local originY = display.screenOriginY
local height = contentHeight-originY*2

local textSize = contentWidth/8
local textSizeTitle = contentWidth/7

local textTitle, textPlayer, textStart, textLevels, textRanking, textSound, textLabel

local buttonStart, buttonLevels, buttonRanking, checkboxSheet, checkSound

local checkboxOptions = {
        frames =
    {
        -- FRAME 1:
        {
            --all parameters below are required for each frame
            x = 1,
            y = 0,
            width = 14,
            height = 32
        },

        -- FRAME 2:
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

local backscene = {
    ["menu"] = function () os.exit() end,
    ["ranking"] = function () goBack ("menu") end,
    ["levels"] = function () goBack ("worlds") end,
    ["game"] = function () goBack ("menu") end,
    ["worlds"] = function () goBack ("levels") end
  }

local optionsTransition = {
      effect = "zoomInOutFade",
      time = 200
    }

---------------------------------------------------------------------------------

-- DATABASE

function initDataBase()
    local tablesetup = [[CREATE TABLE  IF NOT EXISTS data (id INTEGER PRIMARY KEY, info);]]
    db:exec( tablesetup )
    tablesetup = [[CREATE TABLE  IF NOT EXISTS world1 (id INTEGER PRIMARY KEY, stars);]]
    db:exec( tablesetup )
    tablesetup = [[CREATE TABLE IF NOT EXISTS world2 (id INTEGER PRIMARY KEY, stars);]]
    db:exec( tablesetup )
    tablesetup = [[CREATE TABLE IF NOT EXISTS world3 (id INTEGER PRIMARY KEY, stars);]]
    db:exec( tablesetup )
end

local function getCurrentLevel(worldAux)
  local retCurrentLevel
    for row in db:nrows("SELECT * FROM data WHERE id="..worldAux) do
        retCurrentLevel=row.info
    end
  if(retCurrentLevel==NULL) then
      retCurrentLevel = 0
  end
  return retCurrentLevel  
end

function setCurrentLevel(worldAux, levelAux)
  local insertQuery = "INSERT INTO data VALUES ("..worldAux..", "..levelAux..");"
  db:exec( insertQuery )
  local updateQuery = "UPDATE data SET info="..levelAux.." WHERE id="..worldAux..";"
  db:exec( updateQuery )
end

local function getSound()
  local boolSound
    for row in db:nrows("SELECT * FROM data WHERE id=4") do
        retSound=row.info
    end
  if(retSound==NULL) then
      retSound = true
  end
  print("GET SOUND:")
  print(retSound)
  if(retSound==1)then
    boolSound=true
    elseif(retSound==0)then
      boolSound=false
    end
  return boolSound  
end


function setSound(snd)
  local sound
  if(snd==true)then
    sound=1
    elseif(snd==false)then
      sound=0
    end
  local insertQuery = "INSERT INTO data VALUES (4, "..sound..");"
  db:exec( insertQuery )
  local updateQuery = "UPDATE data SET info="..sound.." WHERE id=4;"
  db:exec( updateQuery )
end


function initData()

  if(getCurrentLevel(1)==0)then
    setCurrentLevel(1,1)
  end
  if(getCurrentLevel(2)==0)then
      setCurrentLevel(2,0)
    end
  if(getCurrentLevel(3)==0)then
        setCurrentLevel(3,0)
  end
end

function showPlayerName()
    textPlayer.text = "Player: "..playerName
    print("-------------------------------------------------------------show name")
end

local function loadLocalPlayerCallback( event )
   playerName = event.data.alias
   showPlayerName()
  print("-------------------------------------------"..playerName)
  print("-------------------------------------------------------------load player")
  if(event.data.isError==false)then
    googlePlayGames=true
    print("-------------------------------------------------------------true")
   else
   googlePlayGames=false
   print("-------------------------------------------------------------false")
 end
end

local function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
   print("-------------------------------------------------------------game net")
   return true
end

local function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
   print("-------------------------------------------------------------gpgs")
end

local function gameNetworkSetup()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.init( "google", gpgsInitCallback )
   else
      gameNetwork.init( "gamecenter", gameNetworkLoginCallback )
   end
end

local function onCheckPress( event )
    local check = event.target
    SOUND = check.isOn
    setSound(SOUND)
end

function getTextLabel()
    if(getCurrentLevel(1)~=1)then
      print("current level "..getCurrentLevel(1))
      textLabel = "continue"
    else
      textLabel = "start"
    end
end

function scene:create( event )
    local sceneGroup = self.view

    checkboxSheet = graphics.newImageSheet( "images/checkbox.png", checkboxOptions )

    initDataBase()
    initData()
    getTextLabel()

    background = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height)
       background:setFillColor(0.59,0.99,0.79)
       sceneGroup:insert(background)

       textTitle = display.newText ("Who Says?",contentWidth/2, (height/10)*1, native.systemFontBold, textSizeTitle)
       textTitle:setFillColor( 1, 0.4, 0.4 )
       sceneGroup:insert(textTitle)

        textPlayer = display.newText ("",contentWidth/2, (height/10)*8.9, native.systemFontBold, textSize/2)
        textPlayer:setFillColor( 1, 0.4, 0.4 )
        sceneGroup:insert(textPlayer)

        textSound = display.newText ("Sound",contentWidth/1.35, (height/10)*7.35, native.systemFontBold, textSize/2)
        textSound:setFillColor( 1, 0.4, 0.4 )
        sceneGroup:insert(textSound)

       buttonStart = widget.newButton
        {
          label = textLabel,
          emboss = false,
          shape="roundedRect",
          width = contentWidth*0.9,
          height = textSize*1.3,
          font = native.systemFontBold,
          fontSize = textSize,
          labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
          fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.4, 0.4, 0.7 }},
    
        }

      
        buttonLevels = widget.newButton
        {
          label = "levels",
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
          label = "ranking",
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
            onPress = onCheckPress
        }

        checkSound.x = contentWidth/1.11
        checkSound.y = (height/10)*7.35

        buttonStart.x = display.contentCenterX
        buttonStart.y = (height/10)*3.7

        buttonLevels.x = display.contentCenterX
        buttonLevels.y = (height/10)*5

        buttonRanking.x = display.contentCenterX
        buttonRanking.y = (height/10)*6.3

        sceneGroup:insert(checkSound)
        sceneGroup:insert(buttonStart)
        sceneGroup:insert(buttonLevels)
        sceneGroup:insert(buttonRanking)

    
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    

    if phase == "will" then
       
       

    elseif phase == "did" then

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
                    composer.gotoScene( "ranking", optionsTransition )
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
    local phase = event.phase

    if event.phase == "will" then
       
    elseif phase == "did" then
       
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

end

function goBack(scene)
 composer.gotoScene(scene, optionsTransition)
end

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   local scene = composer.getSceneName( "current" )
  
   if ("back" == keyName and phase == "down") or ("b" == keyName and phase == "down" and system.getInfo("environment") == "simulator")  then 
      
        if (backscene[scene]) then
      backscene[scene]()
      return true
    end
    end
   return false
end

-- Composer scene listeners
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
