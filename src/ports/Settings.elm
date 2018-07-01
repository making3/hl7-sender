module Ports.Settings exposing (get, save)

import Json.Encode as Encode exposing (Value, encode, int, object)
import Ports
import Settings


save : Settings.Model -> Cmd msg
save settings =
    Ports.settingsSave (toJson settings)


get : Settings.Model -> Cmd msg
get settings =
    Ports.settingsGet (toJson settings)


toJson : Settings.Model -> String
toJson settings =
    Encode.encode 0 (encode settings)


encode : Settings.Model -> Value
encode settings =
    object
        [ ( "controlCharacters"
          , encodeControlCharacters settings.controlCharacters
          )
        ]


encodeControlCharacters : Settings.ControlCharactersModel -> Value
encodeControlCharacters controlCharacters =
    object
        [ ( "startOfText", Encode.int controlCharacters.startOfText )
        , ( "endOfText", Encode.int controlCharacters.endOfText )
        , ( "endOfLine", Encode.int controlCharacters.endOfLine )
        ]
