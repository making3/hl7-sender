port module Settings.Commands exposing (..)

import Msg as Main exposing (..)
import Settings.Model as Settings exposing (..)


port settingsGet : String -> Cmd msg


port settingsSave : String -> Cmd msg


save : Settings.Model -> Cmd Main.Msg
save settings =
    settingsSave (Settings.toJson settings)


get : Settings.Model -> Cmd Main.Msg
get settings =
    settingsGet (Settings.toJson settings)
