module Settings.Model exposing (..)

import Json.Encode exposing (encode, Value, object, int)
import Connection.Model as Connection
import Settings.ControlCharacters.Model as ControlCharacters


type alias Model =
    { controlCharacters : ControlCharacters.Model
    }


model : Model
model =
    { controlCharacters = ControlCharacters.model
    }


toJson : Model -> String
toJson settings =
    Json.Encode.encode 0 (encode settings)


encode : Model -> Value
encode settings =
    object
        [ ( "controlCharacters"
          , ControlCharacters.encode settings.controlCharacters
          )
        ]
