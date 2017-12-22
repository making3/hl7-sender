module Home.View.About exposing (..)

import Msg exposing (..)
import Model exposing (Model)
import View.Layout.Modal as Layout exposing (view)
import Html exposing (Html, div, label, text)


view : Html Msg
view =
    Layout.view
        "About"
        (div [] [ label [] [ text aboutText ] ])


aboutText : String
aboutText =
    "This is text about the application"
