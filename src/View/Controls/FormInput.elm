module View.Controls.FormInput exposing (..)

import Html exposing (Html, div, text, input, label)
import Html.Attributes exposing (class, value, placeholder, readonly)
import Html.Events exposing (onInput)
import Msg exposing (..)


viewBasicInput : String -> String -> String -> String -> (String -> Msg) -> Html Msg
viewBasicInput className labelText inputValue placeholderText inputMsg =
    div [ class className ]
        [ label [] [ text labelText ]
        , input
            [ class "form-control"
            , value inputValue
            , placeholder placeholderText
            , onInput inputMsg
            ]
            []
        ]
