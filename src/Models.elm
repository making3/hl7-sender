module Models exposing (..)


type alias Model =
    { route : Route
    , isConnected : Bool
    , connectionMessage : String
    , destinationIp : String
    , destinationPort : Int
    , hl7 : String
    , controlCharacters : ControlCharacters
    }


type alias ControlCharacters =
    { startOfText : Int
    , endOfText : Int
    , endOfLine : Int
    }


type Route
    = RouteHome
    | RouteControlCharacters


initialModel : Model
initialModel =
    { route = RouteHome
    , isConnected = False
    , connectionMessage = "Disconnected"
    , destinationIp = "127.0.0.1"
    , destinationPort = 1337
    , hl7 = ""
    , controlCharacters =
        { startOfText = 9
        , endOfText = 45
        , endOfLine = 35
        }
    }
