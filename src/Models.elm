module Models exposing (..)


type alias Model =
    { isConnected : Bool
    , connectionMessage : String
    , destinationIp : String
    , destinationPort : Int
    , hl7 : String
    }


initialModel : Model
initialModel =
    { isConnected = False
    , connectionMessage = "Disconnected"
    , destinationIp = "127.0.0.1"
    , destinationPort = 1337
    , hl7 = ""
    }
