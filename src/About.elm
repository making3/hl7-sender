module About exposing (..)

import View.Layout.Modal as Layout exposing (view)
import Html exposing (Html, div, label, text, hr)
import Html.Attributes exposing (class)


view : String -> msg -> Html msg
view version msg =
    Layout.view "HL7 Sender" (about version) msg


about : String -> Html msg
about version =
    div []
        [ label [ class "block" ] [ text aboutText ]
        , label [ class "block" ] [ text ("Version " ++ version) ]
        ]


aboutText : String
aboutText =
    "HL7 Sender is a utility for testing internal hl7 receiving applications."
