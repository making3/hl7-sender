module Home.View.About exposing (..)

import Msg exposing (..)
import Model exposing (Model)
import View.Layout.Modal as Layout exposing (view)
import Html exposing (Html, div, label, text, hr)
import Html.Attributes exposing (class)


view : Html Msg
view =
    Layout.view
        "HL7 Sender"
        about


about : Html Msg
about =
    div []
        [ label [ class "block" ] [ text aboutText ]
        , label [ class "block" ] [ text "Version 0.1.0" ]
        ]


aboutText : String
aboutText =
    "HL7 Sender is a utility for testing internal hl7 receiving applications."
