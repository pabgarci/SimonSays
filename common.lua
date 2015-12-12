
local sqlite3 = require( "sqlite3" )
local composer = require( "composer" )
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local optionsTransition = {
      effect = "zoomInOutFade",
      time = 200
    }

function goBack(scn)
 print("BACK TO: "..scn)
 composer.gotoScene(scn, optionsTransition)
end

local backscene = {
    ["menu"] = function () os.exit() end,
    ["levels"] = function () goBack ("worlds") end,
    ["game"] = function () goBack ("menu") end,
    ["multiplayer"] = function () goBack ("menu") end,
    ["worlds"] = function () goBack ("menu") end
  }

function getCurrentLevel(worldAux)
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

function getSound()
  local boolSound
    for row in db:nrows("SELECT * FROM data WHERE id=4") do
      retSound=row.info
    end
  if(retSound==nil) then
    boolSound = true
  end
  if(retSound==1)then
    boolSound=true
    elseif(retSound==0)then
      boolSound=false
  end
  return boolSound  
end

function getVibrate()
  local boolVibrate
    for row in db:nrows("SELECT * FROM data WHERE id=5") do
      retVibrate=row.info
    end
  if(retVibrate==nil) then
    boolVibrate = true
  end
  if(retVibrate==1)then
    boolVibrate=true
    elseif(retVibrate==0)then
      boolVibrate=false
  end
  return boolVibrate  
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

function setVibrate(vbt)
  local vibrate
  if(vbt==true)then
    vibrate=1
    elseif(vbt==false)then
      vibrate=0
  end
  local insertQuery = "INSERT INTO data VALUES (5, "..vibrate..");"
  db:exec( insertQuery )
  local updateQuery = "UPDATE data SET info="..vibrate.." WHERE id=5;"
  db:exec( updateQuery )
end

function getStars(worldAux, levelAux)
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

function initData()

  if(getCurrentLevel(1)==0)then
    setCurrentLevel(1,1)
    setSound(true)
    setVibrate(true)
  end
  if(getCurrentLevel(2)==0)then
    setCurrentLevel(2,0)
    end
  if(getCurrentLevel(3)==0)then
    setCurrentLevel(3,0)
  end
end

function onKeyEvent( event )
  local phase = event.phase
  local keyName = event.keyName
  local scene = composer.getSceneName( "current" )
  if("Win"==system.getInfo("platformName") or "Android"==system.getInfo("platformName") or system.getInfo("environment") == "simulator")then
    if ("back" == keyName and phase == "down") or ("b" == keyName and phase == "down")  then 
      if (backscene[scene]) then
        backscene[scene]()
        print("LOCAL SCENE: "..scene)
        return true
      end
    end
  end
end

Runtime:addEventListener( "key", onKeyEvent )

return common