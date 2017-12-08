module Connection.View.Footer exposing (..)

import Html exposing (Html, div, hr)
import Html.Attributes exposing (class)
import Msg as Main exposing (..)
import Model as Main
import Connection.View.Log as Log exposing (view)
import Connection.View.Connection as Connection exposing (view)
import Connection.View.Status as Status exposing (view)
import Connection.Msg exposing (..)


view : Main.Model -> Html Main.Msg
view model =
    Html.footer [ class "footer" ]
        [ div [ class "row-fluid" ]
            [ viewConnection model
            , Log.view model
            ]
        , hr [] []
        , Status.view model
        ]


viewConnection : Main.Model -> Html Main.Msg
viewConnection model =
    div [ class "col-8" ]
        [ div [ class "row-fluid" ]
            (Connection.view model)
        ]


viewLog : Main.Model -> Html Main.Msg
viewLog model =
    div [ class "col-6" ]
        [ div [ class "row-fluid" ]
            []
        ]
