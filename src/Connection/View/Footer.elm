module Connection.View.Footer exposing (..)

import Html exposing (Html, div, hr, footer)
import Html.Attributes exposing (class)
import Msg as Main exposing (..)
import Model as Main
import Connection.View.Log as Log exposing (view)
import Connection.View.Connection as Connection exposing (view)
import Connection.View.Status as Status exposing (view)
import Connection.Msg exposing (..)


view : Main.Model -> Html Main.Msg
view model =
    footer
        [ class "footer" ]
        [ connectionForm model
        , separator
        , statusForm model
        ]


connectionForm : Main.Model -> Html Main.Msg
connectionForm model =
    div [ class "row-fluid" ]
        [ div [ class "col-8" ] (Connection.view model)
        , div [ class "col-6" ] (Log.view model)
        ]


separator : Html Main.Msg
separator =
    hr [] []


statusForm : Main.Model -> Html Main.Msg
statusForm model =
    div [ class "row-fluid" ]
        [ Status.view model ]
