module Connection exposing (..)

import Array exposing (Array, fromList)


-- MODEL


type alias Model =
    { destinationIp : String
    , destinationPort : Int
    , isConnected : Bool
    , connectionMessage : String
    , sentCount : Int
    , savedConnections : Array Connection
    , currentSavedConnectionName : String
    }


type alias Connection =
    { name : String
    , destinationIp : String
    , destinationPort : Int
    }


model : Model
model =
    { destinationIp = "127.0.0.1"
    , destinationPort = 1337
    , isConnected = False
    , connectionMessage = "Disconnected"
    , sentCount = 0
    , savedConnections =
        Array.fromList
            [ getDefaultConnection
            ]
    , currentSavedConnectionName = "Default"
    }


getDefaultConnection : Connection
getDefaultConnection =
    Connection "Default" "127.0.0.1" 1337
