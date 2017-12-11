module Settings.View.Layout exposing (..)

import Html exposing (Html, div, h3, button, hr, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Settings.Model as Settings exposing (Model)
import Msg as Main exposing (..)
import Route.Msg as Route exposing (..)


view : Settings.Model -> String -> Html Main.Msg -> Html Main.Msg
view model title content =
    div [ class "layout-padding" ]
        [ div [ class "settings" ]
            [ h3 [] [ text ("Settings - " ++ title) ]
            , button
                [ class "float-right close"
                , onClick (MsgForRoute Route.GoHome)
                ]
                [ text "X" ]
            ]
        , hr [] []
        , content
        ]
