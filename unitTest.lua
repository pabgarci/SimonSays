module(..., package.seeall)
local lunatest = package.loaded.lunatest
local assert_true = lunatest.assert_true
local assert_boolean = lunatest.assert_boolean
local assert_number = lunatest.assert_number
local assert_not_equal = lunatest.assert_not_equal
local sqlite3 = require( "sqlite3" )
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

function test_getLevel()
	local retLevel1
	local retLevel2
	local retLevel3
    for row in db:nrows("SELECT * FROM data WHERE id=1") do
      retCurrentLevel=row.info
    end
    for row in db:nrows("SELECT * FROM data WHERE id=1") do
      retCurrentLevel=row.info
    end
    for row in db:nrows("SELECT * FROM data WHERE id=1") do
      retCurrentLevel=row.info
    end
  	assert_not_equal(nil, retCurrentLevel, "Returned level is null")
	assert_number(retCurrentLevel, "Get level don't returned a number")
end

function test_imageFiles()
	local imageShareFb = display.newImage( "images/facebook-share-button.png")
	local imageCheck = display.newImage( "images/checkbox.png")
    assert_not_equal(nil, imageShareFb, "No file image facebook-share-button.png")
    assert_not_equal(nil, imageCheck, "No file image checkbox.png")
    imageCheck:removeSelf()
    imageShareFb:removeSelf()
end

function test_soundFiles()
	local soundGameOver = audio.loadSound("sounds/game-over.mp3")
    local soundNextLevel = audio.loadSound("sounds/next-level.mp3")
    local soundRectangle1 = audio.loadSound("sounds/rectangle_1.mp3")
    local soundRectangle2 = audio.loadSound("sounds/rectangle_2.mp3")
    local soundRectangle3 = audio.loadSound("sounds/rectangle_3.mp3")
    local soundRectangle4 = audio.loadSound("sounds/rectangle_4.mp3")
    local soundRectangle5 = audio.loadSound("sounds/rectangle_5.mp3")
    local soundRectangle6 = audio.loadSound("sounds/rectangle_6.mp3")
    assert_not_equal(nil, soundGameOver, "No file sound game-over.mp3")
    assert_not_equal(nil, soundNextLevel, "No file sound gnext-level.mp3")
    assert_not_equal(nil, soundRectangle1, "No file sound rectangle_1.mp3")
    assert_not_equal(nil, soundRectangle2, "No file sound rectangle_2.mp3")
    assert_not_equal(nil, soundRectangle3, "No file sound rectangle_3.mp3")
    assert_not_equal(nil, soundRectangle4, "No file sound rectangle_4.mp3")
    assert_not_equal(nil, soundRectangle5, "No file sound rectangle_5.mp3")
    assert_not_equal(nil, soundRectangle6, "No file sound rectangle_6.mp3")
end

function test_sound()
	local boolSound
    for row in db:nrows("SELECT * FROM data WHERE id=4") do
      retSound=row.info
    end
  if(retSound==1)then
    boolSound=true
    elseif(retSound==0)then
      boolSound=false
  end
  assert_boolean(boolSound, "Sound - No boolean found")
end

function test_vibrate()
	local boolVibrate
    for row in db:nrows("SELECT * FROM data WHERE id=5") do
      retVibrate=row.info
    end
  if(retVibrate==1)then
    boolVibrate=true
    elseif(retVibrate==0)then
      boolVibrate=false
  end
  assert_boolean(boolVibrate, "Vibrate - No boolean found")
end

function test_forTesting()
  boolean111=true
  assert_true(boolean111, "Vibrate - Obtained false from de database")
end