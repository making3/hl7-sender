module Settings.ControlCharacters.View.ControlCharacters exposing (..)

import Char
import Hex as Hex exposing (toString)
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


route : Settings.Model -> Settings.Model
route settings =
    { settings | controlCharacters = resetTempCharacters settings.controlCharacters }


resetTempCharacters : ControlCharacters.Model -> ControlCharacters.Model
resetTempCharacters controlCharacters =
    { controlCharacters
        | tempStartOfText = controlCharacters.startOfText
        , tempEndOfText = controlCharacters.endOfText
        , tempEndOfLine = controlCharacters.endOfLine
    }


view : Settings.Model -> Html Main.Msg
view settings =
    SettingsLayout.view settings
        "Control Characters"
        (div []
            [ viewHeading
            , viewCharacters settings
            ]
        )


viewHeading : Html Main.Msg
viewHeading =
    div []
        [ label [ class "settings-label-control-character" ] [ text "Control Character" ]
        , label [ class "settings-label-control-decimal" ] [ text "Decimal" ]
        , label [ class "settings-label-control-ascii" ] [ text "ASCII" ]
        , label [ class "settings-label-control-hex" ] [ text "Hex" ]
        ]


viewCharacters : Settings.Model -> Html Main.Msg
viewCharacters settings =
    div
        [ class "form" ]
        [ viewInput
            settings.controlCharacters.tempStartOfText
            "Start of HL7"
            (MsgForSettings << MsgForControlCharacters << UpdateStartOfText)
        , viewInput
            settings.controlCharacters.tempEndOfText
            "End of HL7"
            (MsgForSettings << MsgForControlCharacters << UpdateEndOfText)
        , viewInput
            settings.controlCharacters.tempEndOfLine
            "End of Segment"
            (MsgForSettings << MsgForControlCharacters << UpdateEndOfLine)
        , button
            [ class "btn btn-primary settings-save"
            , onClick (MsgForSettings (MsgForControlCharacters SaveControlCharacters))
            ]
            [ text "Save to Disk" ]
        ]


viewInput : Int -> String -> (String -> Main.Msg) -> Html Main.Msg
viewInput controlCharacter labelText inputMsg =
    div [ class "control-character" ]
        [ label []
            [ text labelText ]
        , input
            [ class "form-control"
            , onInput inputMsg
            , value (Basics.toString controlCharacter)
            ]
            []
        , label [ class "settings-label-control-ascii" ] [ text (viewAsciiCharacter controlCharacter) ]
        , label [ class "settings-label-control-hex" ] [ text (viewHexCode controlCharacter) ]
        ]


viewAsciiCharacter : Int -> String
viewAsciiCharacter character =
    if character < 32 then
        "N/A"
    else
        Char.fromCode (character)
            |> Basics.toString
            |> printStr


printStr : String -> String
printStr str =
    if String.left 1 str == "'" then
        String.dropRight 1 (String.dropLeft 1 str)
    else
        str


viewHexCode : Int -> String
viewHexCode character =
    "0x" ++ (Hex.toString character)
