module Models exposing (..)


type alias Model =
    { isConnected : Bool
    , connectionMessage : String
    , destinationIp : String
    , destinationPort : Int
    , hl7 : String
    }
