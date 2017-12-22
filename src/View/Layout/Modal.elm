module View.Layout.Modal exposing (..)

import Html exposing (Html, div, h3, button, hr, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Msg as Main exposing (..)
import Route.Msg as Route exposing (..)


view : String -> Html Main.Msg -> Html Main.Msg
view title content =
    div [ class "layout-padding" ]
        [ div [ class "settings" ]
            [ h3 [] [ text title ]
            , button
                [ class "float-right close"
                , onClick (MsgForRoute Route.GoHome)
                ]
                [ text "X" ]
            ]
        , hr [] []
        , content
        ]
