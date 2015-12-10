local sceneName = "game"

local composer = require( "composer" )
local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )
local gameNetwork = require( "gameNetwork" )
local localization = require( "mod_localize" )

local _s = localization.str

local playerName, googlePlayGames

local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local scene = composer.newScene()

local FREQ = 800
local NEXTLEVEL = false
local TOUCH = false
local GAMEOVER = true
local SAVE = true
local KEYSOUND = true
local SOUND, VIBRATE, soundNextLevel, soundGameOver, starsTimer
local timerShow, timerShowEmpty
local soundRectangle1, soundRectangle2, soundRectangle3, soundRectangle4, soundRectangle5, soundRectangle6

local rectangle11, rectangle12, rectangle21, rectangle22, rectangle23, rectangle24
local rectangle31, rectangle32, rectangle33, rectangle34, rectangle35, rectangle36
local rectangleBackground, rectangleMessage

local textMessage1, textMessage2, textSequence, textLevel, textStars1, textStars2

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local originX = display.screenOriginX
local originY = display.screenOriginY
local height = contentHeight-originY*2

local textSize = contentWidth/8
local textSizeTitle = contentWidth/7
local rounded = contentWidth/40

local arrayGame ={}
local sequence = 1
local time, totalTime, stars, level, world, valWin, buttonBack
local justOnce=0
local countShow=1
local countCheck=1

local starVertices, rectangleStars, showStar1, showStar2, showStar3

local optionsTransition = {
      effect = "zoomInOutFade",
      time = 200
    }

local gradient1 = {
    type="gradient",
    color1={ 1,1,0.78 }, color2={ 1,0.95,0.46 }, direction="left"
}

local gradient2 = {
    type="gradient",
    color1={ 1,0.88,0.88 }, color2={ 0.96, 0.56, 0.69 }, direction="right"
}

function checkPlatform()
    valWin = 0
    if(system.getInfo("environment") == "device" and "Win"==system.getInfo("platformName"))then
        valWin = contentHeight/30
    end
end

function goBack()
 composer.gotoScene("menu", optionsTransition)
end

function calculateFrequency()
  FREQ = 800 - (level-1)*30
end

checkPlatform()

rectangleBackground = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height)

    rectangle11 = display.newRoundedRect( contentWidth/4, contentHeight/2, contentWidth/2, contentHeight-valWin*3.5, rounded)
    rectangle12 = display.newRoundedRect( contentWidth*3/4, contentHeight/2, contentWidth/2, contentHeight-valWin*3.5, rounded)
    rectangle11.alpha = 0
    rectangle12.alpha = 0

    rectangle21 = display.newRoundedRect( contentWidth/4, contentHeight/4, contentWidth/2, contentHeight/2-valWin*3.5, rounded)
    rectangle22 = display.newRoundedRect( contentWidth*3/4, contentHeight/4, contentWidth/2, contentHeight/2-valWin*3.5, rounded)
    rectangle23 = display.newRoundedRect( contentWidth/4, contentHeight*3/4, contentWidth/2, contentHeight/2-valWin*3.5, rounded)
    rectangle24 = display.newRoundedRect( contentWidth*3/4, contentHeight*3/4, contentWidth/2, contentHeight/2-valWin*3.5, rounded)
    rectangle21.alpha = 0
    rectangle22.alpha = 0
    rectangle23.alpha = 0
    rectangle24.alpha = 0

    rectangle31 = display.newRoundedRect( contentWidth/4, contentHeight/6, contentWidth/2, contentHeight/3-valWin*3.5, rounded)
    rectangle32 = display.newRoundedRect( contentWidth*3/4, contentHeight/6, contentWidth/2, contentHeight/3-valWin*3.5, rounded)
    rectangle33 = display.newRoundedRect( contentWidth/4, contentHeight/2, contentWidth/2, contentHeight/3-valWin*3.5, rounded)
    rectangle34 = display.newRoundedRect( contentWidth*3/4, contentHeight/2, contentWidth/2, contentHeight/3-valWin*3.5, rounded)
    rectangle35 = display.newRoundedRect( contentWidth/4, contentHeight*5/6, contentWidth/2, contentHeight/3-valWin*3.5, rounded)
    rectangle36 = display.newRoundedRect( contentWidth*3/4, contentHeight*5/6, contentWidth/2, contentHeight/3-valWin*3.5, rounded)
    rectangle31.alpha = 0
    rectangle32.alpha = 0
    rectangle33.alpha = 0
    rectangle34.alpha = 0
    rectangle35.alpha = 0
    rectangle36.alpha = 0

    rectangleMessage = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height*2.5/12)
      
    textLevel = display.newText ("",contentWidth/4, originY-originY/2+valWin, native.systemFontBold, textSize*0.5)
    textSequence = display.newText ("",contentWidth/4, contentHeight-originY/2-valWin, native.systemFontBold, textSize*0.5)

    textMessage1 = display.newText ("",contentWidth/2, (height/12)*4.8+valWin*2, native.systemFontBold, textSizeTitle*0.75)
    textMessage2 = display.newText ("",contentWidth/2, (height/12)*5.6+valWin*2, native.systemFontBold, textSize*0.5)


    starVertices = { 0,-8,1.763,-2.427,7.608,-2.472,2.853,0.927,4.702,6.472,0.0,3.0,-4.702,6.472,-2.853,0.927,-7.608,-2.472,-1.763,-2.427 }

    rectangleStars = display.newRect( contentWidth/2, contentHeight/2, contentWidth, height*2.5/10)
    textStars1 = display.newText ("", contentWidth/2, (height/12)*4.55+valWin*2, native.systemFontBold, textSizeTitle*0.75)
    textStars2 = display.newText ("", contentWidth/2, (height/12)*6+valWin*2, native.systemFontBold, textSize*0.5)

    showStar1 = display.newPolygon( 0, (height/12)*5.4+valWin*2, starVertices )
    showStar2 = display.newPolygon( 0, (height/12)*5.4+valWin*2, starVertices )
    showStar3 = display.newPolygon( 0, (height/12)*5.4+valWin*2, starVertices )

    buttonBack = widget.newButton
        {
          label = _s("back"),
          emboss = false,
          shape="roundedRect",
          width = contentWidth*0.4,
          height = textSize*0.5,
          font = native.systemFontBold,
          fontSize = textSize*0.5,
          labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 }},
          fillColor = { default={ 1, 0.4, 0.4}, over={ 1, 0.1, 0.7, 0.4 }},
          onRelease = goBack
        }

        buttonBack.x = contentWidth*3/4
        buttonBack.y = contentHeight-originY/2-valWin*0.8

    soundGameOver = audio.loadSound("sounds/game-over.mp3")
    soundNextLevel = audio.loadSound("sounds/next-level.mp3")
    soundRectangle1 = audio.loadSound("sounds/rectangle_1.mp3")
    soundRectangle2 = audio.loadSound("sounds/rectangle_2.mp3")
    soundRectangle3 = audio.loadSound("sounds/rectangle_3.mp3")
    soundRectangle4 = audio.loadSound("sounds/rectangle_4.mp3")
    soundRectangle5 = audio.loadSound("sounds/rectangle_5.mp3")
    soundRectangle6 = audio.loadSound("sounds/rectangle_6.mp3")
    
local function getSound()
  local boolSound
    for row in db:nrows("SELECT * FROM data WHERE id=4") do
        retSound=row.info
    end
  if(retSound==nil) then
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

local function getVibrate()
  local boolVibrate
    for row in db:nrows("SELECT * FROM data WHERE id=5") do
        retVibrate=row.info
    end
  if(retVibrate==nil) then
      boolVibrate = true
  end
  print("GET VIBRATE:")
  print(boolVibrate)
  if(retVibrate==1)then
    boolVibrate=true
    elseif(retVibrate==0)then
      boolVibrate=false
    end
  return boolVibrate  
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
  print("levelAux"..levelAux)
  print("worldAux"..worldAux)
  print("levelAuxR"..getCurrentLevel(worldAux))
end


local function getStars(worldAux, levelAux)
  local retStars
    for row in db:nrows("SELECT * FROM world"..worldAux.." WHERE id="..levelAux) do
        retStars=row.stars
    end
    if(retStars==NULL) then
      retStars = 0
    end
  return retStars
end

function setStars(worldAux, levelAux, stars)
  if(getStars(worldAux,levelAux)<=stars)then
    local insertQuery = "INSERT INTO world"..worldAux.." VALUES ("..levelAux..", "..stars..");"
    db:exec( insertQuery )
    local updateQuery = "UPDATE world"..worldAux.." SET stars="..stars.." WHERE id="..levelAux..";"
    db:exec( updateQuery )
  end
end

function showMessage(message1, message2)
  rectangleMessage.alpha = 0.85
  textMessage1.text = message1
  textMessage1.alpha = 1
  textMessage2.text = message2
  textMessage2.alpha = 1
end

function showStars(message1, message2, levelStars)
  rectangleStars.alpha = 0.85
  textStars1.alpha = 1
  textStars2.alpha = 1
  textStars1.text = message1
  textStars2.text = message2
  if(levelStars==1)then
    showStar1.x = contentWidth/2
    showStar1.alpha = 1
  elseif(levelStars==2)then
    showStar1.x = contentWidth/2 - contentWidth/20
    showStar2.x = contentWidth/2 + contentWidth/20
    showStar1.alpha = 1
    showStar2.alpha = 1
  elseif(levelStars==3)then
    showStar1.x = contentWidth/2 - contentWidth/10
    showStar2.x = contentWidth/2
    showStar3.x = contentWidth/2 + contentWidth/10
    showStar1.alpha = 1
    showStar2.alpha = 1
    showStar3.alpha = 1
  end
end

function playSound(ach)
  if(SOUND==true)then
    print("ESTA SONANDO")
  if(ach=="next-level")then
  audio.play(soundNextLevel, {channel=2})
  elseif(ach=="game-over")then
    audio.play(soundGameOver, {channel=3})
    elseif (ach=="second-world") then
        audio.play(soundNextLevel, {channel=4})
         elseif (ach=="third-world") then
          audio.play(soundNextLevel, {channel=5})
           elseif (ach=="three-stars") then
            audio.play(soundNextLevel, {channel=6})
              elseif (ach=="rectangle-1") then
               audio.play(soundRectangle1, {channel=7})
                elseif (ach=="rectangle-2") then
                 audio.play(soundRectangle2, {channel=8})
                   elseif (ach=="rectangle-3") then
                   audio.play(soundRectangle3, {channel=9})
                     elseif (ach=="rectangle-4") then
                     audio.play(soundRectangle4, {channel=10})
                       elseif (ach=="rectangle-5") then
                       audio.play(soundRectangle5, {channel=11})
                         elseif (ach=="rectangle-6") then
                         audio.play(soundRectangle6, {channel=12})
    end
  end
end

function stopSound()
  if(SOUND==true)then
       audio.stop(2)
       audio.stop(3)
       audio.stop(4)
       audio.stop(5)
       audio.stop(6)
       audio.stop(7)
       audio.stop(8)
       audio.stop(9)
       audio.stop(10)
       audio.stop(11)
       audio.stop(12)
  end 
end

function vibrate()
      if(getVibrate())then
        system.vibrate()
        print("VIBRANDOooooooooooooooooooooooOOOOOOOOOOOOOOOOOooooooooooooooooooooooOOOOOOOOOOOOOOOO")
      end
end

function rec (n)
  local aux=0
  for i=1,n do
    aux=aux+n
  end
  print("AUX: "..aux)
        return aux
    end

function calculateTotalTime()
  local recResult = rec(level +3)
  totalTime = recResult*1800/FREQ
  print("TOTAL TIME = "..totalTime)
end

function unlockAchievement(ach)
  if("Android"==system.getInfo( "platformName" ))then
local id
if(ach=="first-level")then
  id = "CgkI-YvM6OkaEAIQAw"
  elseif(ach=="first-world")then
    id="CgkI-YvM6OkaEAIQBg"
    elseif (ach=="second-world") then
        id="CgkI-YvM6OkaEAIQBw"
         elseif (ach=="third-world") then
          id="CgkI-YvM6OkaEAIQCA"
           elseif (ach=="three-stars") then
            id="CgkI-YvM6OkaEAIQCQ"
    end

gameNetwork.request( "unlockAchievement",
    {
        achievement =
        {
            identifier = id
        },
        listener = requestCallback
    }
)
end
end

function nextLevel()
  print("nextLevel")
  local levelStars = calculateStars()
  initScreenGame()
  NEXTLEVEL=true
  TOUCH = true
  print("HOLAHOLA World: "..world)
  print("HOLAHOLA Level: "..level)
  if(world == 1 and level == 6)then
    showStars(_s("world").." 1 ".._s("completed"), _s("tap to continue"), levelStars)
    unlockAchievement("first-world")
    setStars(world, level, levelStars)
    world = 2
    level = 1
    setCurrentLevel(world,level)
    elseif(world == 2 and level == 12)then
      showStars("world 2 completed", _s("tap to continue"), levelStars)
      unlockAchievement("second-world")
      setStars(world, level, levelStars)
      world = 3
      level = 1
      setCurrentLevel(world,level)
    elseif(world == 3 and level == 18)then
      showStars("world 3 completed", _s("tap to continue"), levelStars)
      unlockAchievement("third-world")
      setStars(world, level, levelStars)
      world = 1
      level = 1
      setCurrentLevel(world,level)
    else
      showStars("level "..level.." completed", _s("tap to continue"), levelStars)
      setCurrentLevel(world,level+1)
      unlockAchievement("first-level")
      if(stars==3)then
        unlockAchievement("three-stars")
      end
      setStars(world, level, levelStars)
      print("STARS = "..levelStars)
      level = level + 1
    end
  sequence = 1
  calculateFrequency()
  print("FREQ = "..FREQ)
  playSound("next-level")
  vibrate()
end

function checkLevel(worldAux, levelAux)
  if (worldAux==NULL and levelAux==NULL)then
    if(getCurrentLevel(2)==0 and getCurrentLevel(3)==0)then
      level=getCurrentLevel(1)
      world=1
      elseif(getCurrentLevel(2)~=0 and getCurrentLevel(3)==0)then
        level=getCurrentLevel(2)
        world=2
        elseif(getCurrentLevel(2)~=0 and getCurrentLevel(3)~=0)then
        level=getCurrentLevel(3)
        world=3
    end
  elseif(worldAux~=NULL and levelAux~=NULL)then
    world = worldAux
    level = levelAux
  end
  print("CHECKLEVEL2 Level: "..level)
  print("CHECKLEVEL2 Level: "..level)
end

function changeColor(color)
  print("changeColor")
  if(world == 1)then
    if(color==1)then
        rectangle11:setFillColor(1,1,0.29)
        playSound("rectangle-1")
     elseif (color==2)then
        rectangle12:setFillColor(1,0.29,0.29)
        playSound("rectangle-2")
      end
    elseif(world == 2)then
        if(color==1)then
        rectangle21:setFillColor(1,1,0.29)
        playSound("rectangle-1")
      elseif (color==2)then
        rectangle22:setFillColor(1,0.29,0.29)
        playSound("rectangle-2")
      elseif (color==3)then
        rectangle23:setFillColor(0.29,0.29,0.99)
        playSound("rectangle-3")
      elseif (color==4)then
        rectangle24:setFillColor(0.64,0.99,0.29)
        playSound("rectangle-4")
    end
    elseif(world == 3)then
      if(color==1)then
        rectangle31:setFillColor(1,1,0.29)
        playSound("rectangle-1")
      elseif (color==2)then
        rectangle32:setFillColor(1,0.29,0.29)
       playSound("rectangle-2")
      elseif (color==3)then
        rectangle33:setFillColor(0.29,0.29,0.99)
        playSound("rectangle-3")
      elseif (color==4)then
        rectangle34:setFillColor(0.64,0.99,0.29) 
       playSound("rectangle-4")
      elseif (color==5)then
        rectangle35:setFillColor(0.99,0.64,0.29)
       playSound("rectangle-5")
      elseif (color==6)then
        rectangle36:setFillColor(0.29,0.99,0.99)
        playSound("rectangle-6")
    end
  end
end

function fillArray()
  print("fillArray")
    arrayGame[countCheck] = math.random (world*2)
end

function initScreenGame()
      print("initScreenGame")
      if(valWin==0)then
        buttonBack.alpha=0
      else
        buttonBack.alpha=1
      end
      rectangleStars:setFillColor(0.59,0.99,0.79)
      textStars1:setFillColor( 1, 0.4, 0.4 )
      showStar1:setFillColor( 1, 0.9, 0 )
      showStar1.strokeWidth = 1
      showStar1:setStrokeColor( 0.5, 0.5, 0 )
      showStar2:setFillColor( 1, 0.9, 0 )
      showStar2.strokeWidth = 1
      showStar2:setStrokeColor( 0.5, 0.5, 0 )
      showStar3:setFillColor( 1, 0.9, 0 )
      showStar3.strokeWidth = 1
      showStar3:setStrokeColor( 0.5, 0.5, 0 )

      rectangleBackground:setFillColor(0.59,0.99,0.79)
      rectangleMessage:setFillColor(0.59,0.99,0.79)
      textLevel:setFillColor( 1, 0.4, 0.4 )
      textSequence:setFillColor( 1, 0.4, 0.4 )
      textMessage1:setFillColor( 1, 0.4, 0.4 )
      textMessage2:setFillColor( 1, 1, 1 )
      if(world == 1)then
       --rectangle11:setFillColor(1,1,0.78)
       rectangle11:setFillColor(gradient1)
       rectangle11.strokeWidth = 5
       rectangle11:setStrokeColor(1, 0.55, 0.55)
       --rectangle12:setFillColor(1,0.88,0.88)
       rectangle12:setFillColor(gradient2)
       rectangle12.strokeWidth = 5
       rectangle12:setStrokeColor(1, 0.55, 0.55)
       rectangle11.alpha = 1
       rectangle12.alpha = 1
       elseif(world == 2)then
       rectangle21:setFillColor(gradient1)
       rectangle21.strokeWidth = 5
       rectangle21:setStrokeColor(1, 0.55, 0.55)
       rectangle22:setFillColor(gradient2)
       rectangle22.strokeWidth = 5
       rectangle22:setStrokeColor(1, 0.55, 0.55)
       rectangle23:setFillColor(0.88,0.88,1)
       rectangle23.strokeWidth = 5
       rectangle23:setStrokeColor(1, 0.55, 0.55)
       rectangle24:setFillColor(0.89,1,0.78)
       rectangle24.strokeWidth = 5
       rectangle24:setStrokeColor(1, 0.55, 0.55)
       rectangle21.alpha = 1
       rectangle22.alpha = 1
       rectangle23.alpha = 1
       rectangle24.alpha = 1
       elseif(world == 3)then
       rectangle31:setFillColor(gradient1)
       rectangle31.strokeWidth = 5
       rectangle31:setStrokeColor(1, 0.55, 0.55)
       rectangle32:setFillColor(gradient2)
       rectangle32.strokeWidth = 5
       rectangle32:setStrokeColor(1, 0.55, 0.55)
       rectangle33:setFillColor(0.88,0.88,1)
       rectangle33.strokeWidth = 5
       rectangle33:setStrokeColor(1, 0.55, 0.55)
       rectangle34:setFillColor(0.89,1,0.78)
       rectangle34.strokeWidth = 5
       rectangle34:setStrokeColor(1, 0.55, 0.55)
       rectangle35.strokeWidth = 5
       rectangle35:setFillColor(0.99,0.89,0.78)
       rectangle35:setStrokeColor(1, 0.55, 0.55)
       rectangle36:setFillColor(0.88,1,1)
       rectangle36.strokeWidth = 5
       rectangle36:setStrokeColor(1, 0.55, 0.55)
       rectangle31.alpha = 1
       rectangle32.alpha = 1
       rectangle33.alpha = 1
       rectangle34.alpha = 1
       rectangle35.alpha = 1
       rectangle36.alpha = 1
      end
end

function gameOver()
      print("game over")
      playSound("game-over")
      vibrate()
      showMessage("game over",_s("tap to retry"))
      sequence = 1
      countShow=1
      fillArray()
      NEXTLEVEL = true
      TOUCH = true
      GAMEOVER = false
end

function checkSequence(num)
  print("checkSequence")
      if(num==arrayGame[countCheck])then
        countCheck=countCheck+1
      else
        gameOver()
      end
      
      if (countCheck>sequence and GAMEOVER)then  -- seq passed
        sequence = sequence +1
        print(FREQ)
        TOUCH = false
        if(sequence==(level+4))then
        nextLevel()
        end
        fillArray()
        countShow=1
        if(NEXTLEVEL==false)then
          startSequence()
        end
        
        print("level = "..level)
        print("sequence = "..sequence)
      end
end

function startSequence()
  print("startSequence")
  initScreenGame()
  timerShowEmpty = timer.performWithDelay(FREQ,showSequence)
end

function showEmptySequence()
  print("showEmptySequence")
  initScreenGame()
  timerShowEmpty = timer.performWithDelay(FREQ/2,showSequence)
end

function calculateStars()
  local currentStars = 0
  local usedTime
  SAVE = true
  usedTime = os.time() - time
  print("CURR TIME = "..os.time())
  print("TIME = "..time)
  print("USED TIME = "..usedTime)
  if(usedTime<totalTime*0.6)then
      currentStars = 3
      elseif(usedTime<totalTime)then
        currentStars = 2
        elseif(usedTime>=totalTime)then
          currentStars = 1
  end
  calculateTotalTime()
  return currentStars
end

function saveCurrentTime()
  time = os.time()
  print("CURRENT TIME: "..time)
end

function showSequence()
      textLevel.text = _s("level").." "..level
      textSequence.text = _s("seq").." "..sequence.."/"..level+3
      TOUCH=false
      if(SAVE)then
        timerShow = timer.performWithDelay(FREQ,saveCurrentTime())
        SAVE=false
      end
      print("showSequence")
      
      if(countShow<=sequence)then
       changeColor(arrayGame[countShow])        
      end

      countShow=countShow+1

      if(countShow<=sequence)then
        timerShow = timer.performWithDelay(FREQ,showEmptySequence)
      else
        print("limpio")
         timer.performWithDelay(FREQ,initScreenGame)
        TOUCH = true
      end
  countCheck=1
end

function deleteMessage()
  rectangleMessage.alpha = 0
  textMessage1.alpha = 0
  textMessage2.alpha = 0
  rectangleStars.alpha = 0
  textStars1.alpha = 0
  textStars2.alpha = 0
  showStar1.alpha=0
  showStar2.alpha=0
  showStar3.alpha=0
end

function click(worldAux, num)
  print("click")
  deleteMessage()
  if(NEXTLEVEL==true)then
        NEXTLEVEL=false
        GAMEOVER = true
        timer.performWithDelay(FREQ/3,startSequence)
      else
       checkSequence(num)
       changeColor(num)
       timer.performWithDelay(FREQ/10,initScreenGame)
      end
end

function rectangle11:touch( event )
             if event.phase == "ended" and TOUCH  then
                click (1,1)
                return true
              end
        end

        function rectangle12:touch( event )
             if event.phase == "ended"  and TOUCH then
              click(1,2)
                return true
              end
        end

        function rectangle21:touch( event )
              if event.phase == "ended" and TOUCH then
                click(2,1)
                 return true
             end

        end

        function rectangle22:touch( event )
              if event.phase == "ended"  and TOUCH then
                click(2,2)
                return true
              end
        end

        function rectangle23:touch( event )

             if event.phase == "ended" and TOUCH  then
              click(2,3)
                return true
              end

        end

        function rectangle24:touch( event )
             if event.phase == "ended"  and TOUCH then
              click(2,4)
                return true
              end
        end

        function rectangle31:touch( event )
              if event.phase == "ended" and TOUCH then
                click(3,1)
                 return true
             end

        end

        function rectangle32:touch( event )
              if event.phase == "ended"  and TOUCH then
                 click(3,2)
                return true
              end
        end

        function rectangle33:touch( event )
             if event.phase == "ended" and TOUCH  then
               click(3,3)
                return true
              end

        end

        function rectangle34:touch( event )
             if event.phase == "ended"  and TOUCH then
               click(3,4)
                return true
              end
        end

        function rectangle35:touch( event )
              if event.phase == "ended" and TOUCH then
                 click(3,5)
                 return true
             end

        end

        function rectangle36:touch( event )
              if event.phase == "ended"  and TOUCH then
                 click(3,6)
                return true
              end
        end

local function loadLocalPlayerCallback( event )
   playerName = event.data.alias
  print("-------------------------------------------"..playerName)
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
   return true
end

local function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
   
end

local function gameNetworkSetup()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.init( "google", gpgsInitCallback )
   end
end

        rectangle11:addEventListener( "touch", rectangle11 )
        rectangle12:addEventListener( "touch", rectangle12 )
        rectangle21:addEventListener( "touch", rectangle21 )
        rectangle22:addEventListener( "touch", rectangle22 )
        rectangle23:addEventListener( "touch", rectangle23 )
        rectangle24:addEventListener( "touch", rectangle24 )
        rectangle31:addEventListener( "touch", rectangle31 )
        rectangle32:addEventListener( "touch", rectangle32 )
        rectangle33:addEventListener( "touch", rectangle33 )
        rectangle34:addEventListener( "touch", rectangle34 )
        rectangle35:addEventListener( "touch", rectangle35 )
        rectangle36:addEventListener( "touch", rectangle36 )

function scene:create( event )
    local sceneGroup = self.view
    print("create")
    sceneGroup:insert(rectangleBackground) 
    sceneGroup:insert(rectangle11)
    sceneGroup:insert(rectangle12)

    sceneGroup:insert(rectangle21)
    sceneGroup:insert(rectangle22)
    sceneGroup:insert(rectangle23)
    sceneGroup:insert(rectangle24)

    sceneGroup:insert(rectangle31)
    sceneGroup:insert(rectangle32)
    sceneGroup:insert(rectangle33)
    sceneGroup:insert(rectangle34)
    sceneGroup:insert(rectangle35)
    sceneGroup:insert(rectangle36)

    sceneGroup:insert(textLevel)
    sceneGroup:insert(textSequence)

    sceneGroup:insert(rectangleMessage) 
    sceneGroup:insert(textMessage1) 
    sceneGroup:insert(textMessage2) 
    sceneGroup:insert(rectangleStars) 
    sceneGroup:insert(textStars1) 
    sceneGroup:insert(textStars2) 
    sceneGroup:insert(buttonBack)
end

-- On scene show...
function scene:show( event )
    local sceneGroup = self.view
    KEYSOUND=true
    if ( event.phase == "will" ) then 
      gameNetworkSetup()
      SOUND = getSound()
      VIBRATE = getVibrate()
    end

    if ( event.phase == "did" ) then
      initScreenGame()
      sequence=1
      countCheck=1
      countShow=1
      if(justOnce==0)then
      startSequence()
      justOnce=1
      elseif(justOnce==1)then
      justOnce=0
      end
    end
end

function scene:hide( event )
   --stopSound()
    audio.stop()
    SOUND=false
   --KEYSOUND=false
end

function scene:destroy( event )
    local sceneGroup = self.view   
end

----------------------------  GAME ------------------------------
      deleteMessage()
      SOUND = getSound()
      VIBRATE = getVibrate()
      print("SOUND GAME:")
      print (SOUND)
      if(composer.getVariable("origin")==1)then
      world = composer.getVariable("worldTarget")
      level = composer.getVariable("levelTarget")
      else
      checkLevel()
      end
      calculateFrequency()
      calculateTotalTime()
      fillArray()
----------------------------------------------------------------

-- Composer scene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene