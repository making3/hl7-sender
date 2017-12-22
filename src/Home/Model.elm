module Home.Model exposing (..)


type alias Model =
    { hl7 : String
    , version : String
    }


model : Model
model =
    { hl7 = ""
    , version = "N/A"
    }
