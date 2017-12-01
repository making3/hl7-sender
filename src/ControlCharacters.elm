module ControlCharacters exposing (..)

import Html exposing (Html, div, input, text, button, label)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg(..))
import Models exposing (Model)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "form" ]
                [ div [ class "form-input" ]
                    [ label [] [ text "Start Of HL7" ]
                    , input
                        [ class "form-control"
                        , onInput UpdateStartOfText
                        , value (toString model.controlCharacters.startOfText)
                        ]
                        [ text (toString model.controlCharacters.startOfText) ]
                    ]
                , div [ class "form-input" ]
                    [ label [] [ text "End Of HL7" ]
                    , input
                        [ class "form-control"
                        , onInput UpdateEndOfText
                        , value (toString model.controlCharacters.endOfText)
                        ]
                        []
                    ]
                , div [ class "form-input" ]
                    [ label [] [ text "End Of Segment" ]
                    , input
                        [ class "form-control"
                        , onInput UpdateEndOfLine
                        , value (toString model.controlCharacters.endOfLine)
                        ]
                        []
                    ]
                , button [ class "btn btn-secondary", onClick GoHome ] [ text "Go Back" ]

                -- TODO: Re-enable once some form of saving happens
                -- , button [ class "btn btn-primary", onClick SaveControlCharacters ] [ text "Save" ]
                ]
            ]
        ]
