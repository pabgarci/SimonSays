local sceneName = "worlds"
local composer = require( "composer" )

local gameNetwork = require( "gameNetwork" )
local playerName
local googlePlayGames

local widget = require( "widget" )
-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

local background

local pink = { 1, 0.4, 0.4}

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local originX = display.screenOriginX
local originY = display.screenOriginY
local height = contentHeight-originY*2

local textSize = contentWidth/8
local textSizeTitle = contentWidth/7

local textTitle

local buttonWorld1 
local buttonWorld2
local buttonWorld3
local buttonBack

---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view
       background = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height)
       background:setFillColor(0.59,0.99,0.79)
       sceneGroup:insert(background)

       textTitle = display.newText ("Select world",contentWidth/2, (height/10)*1, native.systemFontBold, textSizeTitle)
       textTitle:setFillColor( 1, 0.4, 0.4 )
       sceneGroup:insert(textTitle)


       buttonWorld1 = widget.newButton
        {
          label = "world 1",
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
          label = "world 2",
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
          label = "world 3",
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
          label = "back",
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
        buttonBack.y = contentHeight + originY/2

        sceneGroup:insert(buttonWorld1)
        sceneGroup:insert(buttonWorld2)
        sceneGroup:insert(buttonWorld3)
        sceneGroup:insert( buttonBack )
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
       -- Called when the scene is still off screen and is about to move on screen
       
       
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
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
  
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
