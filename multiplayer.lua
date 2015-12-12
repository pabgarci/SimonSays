local sceneName = "multiplayer"

local gameNetwork = require( "gameNetwork" )
local common = require("common")
local composer = require( "composer" )
local playerName, googlePlayGames

function multiplayer()
  gameNetwork.show( "waitingRoom")
end


local function requestCallback( event )
    print( event.data.roomID )  --ID of the room that was created
    multiplayer()
end

function requestRoom()

gameNetwork.request( "createRoom",
    {
        playerIDs =  --array of players to invite
        {
            "45987354897345345",
            "32238975789573445",
            "17891241248435990"
        },
        maxAutoMatchPlayers = 3,     --optional, defaults to 0
        minAutoMatchPlayers = 1,     --optional, defaults to 0
        listener = requestCallback   --including this will override any listener set in 'gameNetwork.setRoomListener()'
    }
)
end

function loadFriends()
    gameNetwork.request( "loadPlayers",
    {
        playerIDs =
        {
            "45987354897345345",
            "32238975789573445",
            "17891241248435990"
        },
        listener = requestCallback
    }
)
end

return multiplayer