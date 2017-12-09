module Connection.View.Log exposing (..)

import Html exposing (Html, div, text, label)
import Html.Attributes exposing (class)
import Msg as Main exposing (..)
import Model as Main


view : Main.Model -> List (Html Main.Msg)
view model =
    [ label [] [ text "test" ] ]
