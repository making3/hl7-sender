module Settings.ControlCharacters.View.ControlCharacters exposing (..)

import Html exposing (Html, div, input, text, button, label)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)
import Msg as Main exposing (..)
import Route.Msg as Route exposing (..)
import Settings.ControlCharacters.Model as ControlCharacters
import Settings.ControlCharacters.Msg exposing (..)


view : ControlCharacters.Model -> Html Main.Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "form" ]
                [ div [ class "form-input" ]
                    [ label [] [ text "Start Of HL7" ]
                    , input
                        [ class "form-control"
                        , onInput (MsgForControlCharacters << UpdateStartOfText)
                        , value (toString model.startOfText)
                        ]
                        [ text (toString model.startOfText) ]
                    ]
                , div [ class "form-input" ]
                    [ label [] [ text "End Of HL7" ]
                    , input
                        [ class "form-control"
                        , onInput (MsgForControlCharacters << UpdateEndOfText)
                        , value (toString model.endOfText)
                        ]
                        []
                    ]
                , div [ class "form-input" ]
                    [ label [] [ text "End Of Segment" ]
                    , input
                        [ class "form-control"
                        , onInput (MsgForControlCharacters << UpdateEndOfLine)
                        , value (toString model.endOfLine)
                        ]
                        []
                    ]
                , button [ class "btn btn-secondary", onClick (MsgForRoute Route.GoHome) ] [ text "Go Back" ]

                -- TODO: Re-enable once some form of saving happens
                -- , button [ class "btn btn-primary", onClick SaveControlCharacters ] [ text "Save" ]
                ]
            ]
        ]
