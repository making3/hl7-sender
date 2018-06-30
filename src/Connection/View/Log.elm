module Connection.View.Log exposing (..)

import Html exposing (Html, div, label, text, textarea)
import Html.Attributes exposing (class, id, readonly, rows)
import Model as Main
import Msg as Main exposing (..)


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
