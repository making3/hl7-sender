module Connection.Model exposing (..)


type alias Connection =
    { name : String
    , destinationIp : String
    , destinationPort : Int
    }


type alias Model =
    { destinationIp : String
    , destinationPort : Int
    , isConnected : Bool
    , connectionMessage : String
    , sentCount : Int
    , savedConnections : List Connection
    }


model : Model
model =
    { destinationIp = "127.0.0.1"
    , destinationPort = 1337
    , isConnected = False
    , connectionMessage = "Disconnected"
    , sentCount = 0
    , savedConnections =
        [ { name = "Default"
          , destinationIp = "127.0.0.1"
          , destinationPort = 1337
          }
        , { name = "Other"
          , destinationIp = "127.0.0.5"
          , destinationPort = 5555
          }
        ]
    }


updateSentCount model =
    { model | sentCount = model.sentCount + 1 }
