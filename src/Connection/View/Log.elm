module Connection.View.Log exposing (..)

import Html exposing (Html, div, textarea, text, label)
import Html.Attributes exposing (readonly, class, rows)
import Msg as Main exposing (..)
import Model as Main


view : Main.Model -> List (Html Main.Msg)
view model =
    [ textarea
        [ readonly True
        , rows 5
        , class "form-control"
        ]
        [ text "test" ]
    ]
