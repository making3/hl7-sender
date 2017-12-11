module Settings.ControlCharacters.View.ControlCharacters exposing (..)

import Html exposing (Html, div, input, text, button, label)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)
import Msg as Main exposing (..)
import Route.Msg as Route exposing (..)
import Settings.Msg as Settings exposing (Msg(..))
import Settings.Model as Settings
import Settings.View.Layout as SettingsLayout
import Settings.ControlCharacters.Model as ControlCharacters
import Settings.ControlCharacters.Msg exposing (..)


view : Settings.Model -> Html Main.Msg
view settings =
    SettingsLayout.view settings
        "Control Characters"
        (div
            [ class "form" ]
            [ viewInput
                settings.controlCharacters.startOfText
                "Start of HL7"
                (MsgForSettings << MsgForControlCharacters << UpdateStartOfText)
            , viewInput
                settings.controlCharacters.endOfText
                "End of HL7"
                (MsgForSettings << MsgForControlCharacters << UpdateEndOfText)
            , viewInput
                settings.controlCharacters.endOfLine
                "End of Segment"
                (MsgForSettings << MsgForControlCharacters << UpdateEndOfLine)
            , button
                [ class "btn btn-primary settings-save"
                , onClick (MsgForSettings SaveSettings)
                ]
                [ text "Save" ]
            ]
        )


viewInput : Int -> String -> (String -> Main.Msg) -> Html Main.Msg
viewInput controlCharacter labelText inputMsg =
    div [ class "control-character" ]
        [ label []
            [ text labelText ]
        , input
            [ class "form-control"
            , onInput inputMsg
            , value (toString controlCharacter)
            ]
            []
        ]
