module Ports.Settings exposing (get, save)

import Json.Encode exposing (Value, encode, int, object)
import Settings


save : Settings.Model -> Cmd msg
save model =
    settingsSave (toJson model.settings)


get : Settings.Model -> Cmd msg
get model =
    settingsGet (toJson model.settings)


toJson : Settings.Model -> String
toJson settings =
    Json.Encode.encode 0 (encode settings)


encode : Settings.Model -> Value
encode settings =
    object
        [ ( "controlCharacters"
          , ControlCharacters.encode settings.controlCharacters
          )
        ]
