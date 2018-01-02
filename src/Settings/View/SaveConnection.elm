module Settings.View.SaveConnection exposing (..)

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (..)
import Msg as Main exposing (..)
import Settings.Model as Settings
import Settings.View.Layout as SettingsLayout


view : Settings.Model -> Html Main.Msg
view settings =
    SettingsLayout.view
        "Save Connection"
        (div []
            []
        )
