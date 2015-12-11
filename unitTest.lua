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