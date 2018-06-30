module View.Layout.Modal exposing (..)

import Html exposing (Html, div, h3, button, hr, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


view : String -> Html msg -> msg -> Html msg
view title content msg =
    div [ class "layout-padding" ]
        [ div [ class "modal-layout" ]
            [ h3 [] [ text title ]
            , button
                [ class "float-right close"
                , onClick msg
                ]
                [ text "X" ]
            ]
        , hr [] []
        , content
        ]
