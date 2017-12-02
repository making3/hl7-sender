module Settings.ControlCharacters.Model exposing (..)


type alias Model =
    { startOfText : Int
    , endOfText : Int
    , endOfLine : Int
    }


model : Model
model =
    { startOfText = 9
    , endOfText = 45
    , endOfLine = 35
    }
