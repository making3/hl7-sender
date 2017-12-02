module Settings.ControlCharacters.Model exposing (..)

import Json.Encode exposing (Value, object, int)


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


encode : Model -> Value
encode controlCharacters =
    object
        [ ( "startOfText", int controlCharacters.startOfText )
        , ( "endOfText", int controlCharacters.endOfText )
        , ( "endOfLine", int controlCharacters.endOfLine )
        ]
