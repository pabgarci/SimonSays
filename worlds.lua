local sceneName = "worlds"
local composer = require( "composer" )
local widget = require( "widget" )
local gameNetwork = require( "gameNetwork" )
local localization = require( "mod_localize" )

local _s = localization.str

local playerName, googlePlayGames, valWin

local scene = composer.newScene( sceneName )

local background, textTitle, buttonWorld1, buttonWorld2, buttonWorld3, buttonBack

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local originX = display.screenOriginX
local originY = display.screenOriginY
local height = contentHeight-originY*2

local textSize = contentWidth/8
local textSizeTitle = contentWidth/7

local optionsTransition = {
      effect = "zoomInOutFade",
      time = 200
    }


---------------------------------------------------------------------------------

function checkPlatform()
    valWin = 0
    if(system.getInfo("environment") == "device" and "Win"==system.getInfo("platformName"))then
        valWin = contentHeight/15
    end
end

function goBack()
 composer.gotoScene("menu", optionsTransition)
end

function scene:create( event )
    local sceneGroup = self.view

       checkPlatform()

       background = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height)
       background:setFillColor(0.59,0.99,0.79)
       sceneGroup:insert(background)

       textTitle = display.newText (_s("select world"),contentWidth/2, (height/10)*1, native.systemFontBold, textSizeTitle)
       textTitle:setFillColor( 1, 0.4, 0.4 )
       sceneGroup:insert(textTitle)

       buttonWorld1 = widget.newButton
        {
          label = _s("world").." 1",
          emboss = false,
          shape="roundedRect",
          width = contentWidth*0.9,
          height = textSize*1.3,
          font = native.systemFontBold,
          fontSize = textSize,
          labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
          fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.1, 0.7, 0.4 } },
        }
      
        buttonWorld2 = widget.newButton
        {
          label = _s("world").." 2",
          emboss = false,
          shape="roundedRect",
          width = contentWidth*0.9,
          height = textSize*1.3,
          font = native.systemFontBold,
          fontSize = textSize,
          labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 }},
          fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.1, 0.7, 0.4 }},
        }

        buttonWorld3 = widget.newButton
        {
          label = _s("world").." 3",
          emboss = false,
          shape="roundedRect",
          width = contentWidth*0.9,
          height = textSize*1.3,
          font = native.systemFontBold,
          fontSize = textSize,
          labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 }},
          fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.1, 0.7, 0.4 }},
        }

       buttonBack = widget.newButton
        {
          label = _s("back"),
          emboss = false,
          shape="roundedRect",
          width = contentWidth*0.9,
          height = textSize*0.9,
          font = native.systemFontBold,
          fontSize = textSize*0.7,
          labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 }},
          fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.1, 0.7, 0.4 }},
          onRelease = goBack
        }

        buttonWorld1.x = display.contentCenterX
        buttonWorld1.y = (height/10)*3.7

        buttonWorld2.x = display.contentCenterX
        buttonWorld2.y = (height/10)*5

        buttonWorld3.x = display.contentCenterX
        buttonWorld3.y = (height/10)*6.3

        buttonBack.x = display.contentCenterX
        buttonBack.y = contentHeight + originY/2 - valWin

        sceneGroup:insert(buttonWorld1)
        sceneGroup:insert(buttonWorld2)
        sceneGroup:insert(buttonWorld3)
        sceneGroup:insert( buttonBack )
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
       
    elseif phase == "did" then

          function buttonWorld1:touch ( event )
                local phase = event.phase
                if "ended" == phase then
                    composer.setVariable("world",1)
                    composer.gotoScene( "levels", optionsTransition )
                end
          end
                 
          function buttonWorld2:touch ( event )
                local phase = event.phase
                if "ended" == phase then
                    composer.setVariable("world",2)
                    composer.gotoScene( "levels", optionsTransition )
                end
          end
           
          function buttonWorld3:touch ( event )
                local phase = event.phase
                if "ended" == phase then
                    composer.setVariable("world",3)
                    composer.gotoScene( "levels", optionsTransition )
                end
          end
          buttonWorld1:addEventListener( "touch", buttonWorld1 )
          buttonWorld2:addEventListener( "touch", buttonWorld2 )
          buttonWorld3:addEventListener( "touch", buttonWorld3 )
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

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
