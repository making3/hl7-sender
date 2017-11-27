module ControlCharacters exposing (..)

import Html exposing (div)
import Html.Attributes exposing (class)
import Models exposing (ControlCharacters)


view : ControlCharacters -> Html Msg
view characters =
    div []
        [ input [] [ text characters.startOfText ]
        , input [] [ text characters.endOfText ]
        , input [] [ text characters.endOfLine ]
        ]
