module Connection.View.Log exposing (..)

import Html exposing (Html, div, textarea, text, label)
import Html.Attributes exposing (id, readonly, class, rows)
import Msg as Main exposing (..)
import Model as Main


view : Main.Model -> List (Html Main.Msg)
view model =
    [ textarea
        [ id Main.getLogId
        , readonly True
        , rows 5
        , class "form-control"
        ]
        [ text (getLogs model) ]
    ]


getLogs : Main.Model -> String
getLogs model =
    List.reverse model.logs
        |> String.join "\n"