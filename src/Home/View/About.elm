module Home.View.About exposing (..)

import Msg exposing (..)
import Model exposing (Model)
import View.Layout.Modal as Layout exposing (view)
import Html exposing (Html, div, label, text, hr)
import Html.Attributes exposing (class)


view : Model -> Html Msg
view model =
    Layout.view
        "HL7 Sender"
        (about model)


about : Model -> Html Msg
about model =
    div []
        [ label [ class "block" ] [ text aboutText ]
        , label [ class "block" ] [ text ("Version " ++ model.version) ]
        ]


aboutText : String
aboutText =
    "HL7 Sender is a utility for testing internal hl7 receiving applications."
