module Home.View.About exposing (..)

import Msg exposing (..)
import Html exposing (Html, div, label, text)


view : Html Msg
view =
    div []
        [ div []
            [ label [] [ text "Test" ]
            ]
        ]
