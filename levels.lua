local sceneName = "levels"

local composer = require( "composer" )
local common = require("common")
local widget = require( "widget" )
local localization = require( "mod_localize" )
local _s = localization.str

local scene = composer.newScene()

local maxLevels, buttonBack, valWin, worldL

local background
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local originX = display.screenOriginX
local originY = display.screenOriginY
local height = contentHeight-originY*2

local textSize = contentWidth/8
local textSizeTitle = contentWidth/7

local starVertices = { 0,-8,1.763,-2.427,7.608,-2.472,2.853,0.927,4.702,6.472,0.0,3.0,-4.702,6.472,-2.853,0.927,-7.608,-2.472,-1.763,-2.427 }

local optionsTransition = {
      effect = "zoomInOutFade",
      time = 200
    }

---------------------------------------------------------------------

function goBackWorlds()
 composer.gotoScene("worlds", optionsTransition)
end

function checkPlatform()
  valWin = 0
  if(system.getInfo("environment") == "device" and "Win"==system.getInfo("platformName"))then
    valWin = contentHeight/15
  end
end

local function handleLevelSelect( event )
  if ( "ended" == event.phase ) then
    composer.setVariable("worldTarget",worldL)
    composer.setVariable("levelTarget",event.target.id)
    composer.setVariable("origin",1)
    composer.removeScene("game")
    composer.gotoScene( "game", { effect = "fade", time = 200 } )
  end
end

function scene:create( event )
  local sceneGroup = self.view
  background = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height)
  background:setFillColor(0.59,0.99,0.79)
  sceneGroup:insert(background)
end

function scene:show( event )
  local sceneGroup = self.view
  if ( event.phase == "will" ) then
    worldL = composer.getVariable("worldC")
    checkPlatform()
    local levelSelectGroup = widget.newScrollView({
        width = contentWidth,
        height = contentHeight-valWin,
        scrollWidth = contentWidth,
        scrollHeight = contentHeight-valWin,
        backgroundColor = { 0.59,0.99,0.79 },
        horizontalScrollDisabled = true
    })
  
    local xOffset = contentWidth*3/14
    local yOffset = -originY*3 + valWin*2
    local cellCount = 1
    local buttons = {}

    if(worldL == 1)then
      maxLevels = 6
        elseif(worldL == 2)then
          maxLevels = 12
            elseif(worldL == 3)then
              maxLevels = 18
    end
    
    for i = 1, maxLevels do
        buttons[i] = widget.newButton({
            label = tostring( i ),
            id = tostring( i ),
            onEvent = handleLevelSelect,
            emboss = false,
            shape="roundedRect",
            width = contentWidth*2.5/14,
            height = contentWidth*2.5/14,
            font = native.systemFontBold,
            fontSize = 18,
            labelColor = { default = { 1, 1, 1 }, over = { 0.5, 0.5, 0.5 } },
            cornerRadius = 8,
            labelYOffset = -6, 
            fillColor = { default={ 1, 0.4, 0.4}, over={1, 0.4, 0.4 } },
            strokeColor = { default={ 0.8, 0.2, 0.2 }, over={ 0.333, 0.667, 1, 1 } },
            strokeWidth = 2
    })
  
    buttons[i].x = xOffset
    buttons[i].y = yOffset
    levelSelectGroup:insert( buttons[i] )

    if ( i <= getCurrentLevel(worldL) ) then
      buttons[i]:setEnabled( true )
      buttons[i].alpha = 1.0
      else 
        buttons[i]:setEnabled( false ) 
        buttons[i].alpha = 0.5 
    end 

    local star = {} 
    for j = 1, getStars(worldL, i) do
      star[j] = display.newPolygon( 0, 0, starVertices )
      star[j]:setFillColor( 1, 0.9, 0 )
      star[j].strokeWidth = 1
      star[j]:setStrokeColor( 1, 0.8, 0 )
      star[j].x = buttons[i].x + (j * 16) - 32
      star[j].y = buttons[i].y + 13
      levelSelectGroup:insert( star[j] )
    end

    xOffset = xOffset + contentWidth/3.5
    cellCount = cellCount + 1
    if ( cellCount > 3 ) then
      cellCount = 1
      xOffset = contentWidth*3/14
      yOffset = yOffset + contentWidth/4
    end
  end

  sceneGroup:insert( levelSelectGroup )
  levelSelectGroup.x = display.contentCenterX
  levelSelectGroup.y = display.contentCenterY+originY

  buttonBackLevels = widget.newButton
    {
      label = _s("back"),
      shape="roundedRect",
      width = contentWidth*0.9,
      height = textSize*0.9,
      font = native.systemFontBold,
      fontSize = textSize*0.7,
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 }},
      fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.4, 0.4, 0.7 }},
      onPress = goBackWorlds
    }

    buttonBackLevels.x = display.contentCenterX
    buttonBackLevels.y = contentHeight + originY/2 - valWin
    sceneGroup:insert(buttonBackLevels)
  end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
return scene