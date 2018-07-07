module View.Controls.FormInput exposing (..)

import Html exposing (Html, div, text, input, label)
import Html.Attributes exposing (class, value, placeholder, readonly)
import Html.Events exposing (onInput)


viewBasicInput : String -> String -> String -> (String -> msg) -> Html msg
viewBasicInput labelText inputValue placeholderText inputMsg =
    div []
        [ label [] [ text labelText ]
        , input
            [ class "form-control"
            , value inputValue
            , placeholder placeholderText
            , onInput inputMsg
            ]
            []
        ]
