module Home.Main exposing (..)

import Html exposing (Html, Attribute, program, div, span, input, button, text, label, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (Msg(..))
import Models exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ button [ class "btn btn-secondary float-right", onClick EditControlCharacters ] [ text "EditCharacters" ]
                ]
            , div [ class "row" ]
                [ div [ class "col-12" ]
                    [ div []
                        [ div [ class "form-group" ]
                            [ label []
                                [ text "HL7 Message"
                                ]
                            , textarea
                                [ class "form-control"
                                , onInput ChangeHl7
                                , rows 8
                                ]
                                []
                            ]
                        , button
                            [ class "btn btn-primary float-right"
                            , onClick Send
                            , disabled (model.isConnected == False)
                            ]
                            [ text "Send"
                            ]
                        ]
                    ]
                ]
            ]
        , Html.footer [ class "footer" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-8" ]
                        [ div [ class "form-inline" ]
                            [ input
                                [ class "form-control mr-sm-2"
                                , placeholder "IP Address"
                                , onInput ChangeDestinationIp
                                , readonly model.isConnected
                                , value model.destinationIp
                                ]
                                []
                            , input
                                [ class "form-control mr-sm-2"
                                , placeholder "Port"
                                , readonly model.isConnected
                                , onInput ChangeDestinationPort
                                , value (getPortDisplay model.destinationPort)
                                ]
                                []
                            , button
                                [ class "btn btn-primary"
                                , onClick ToggleConnection
                                ]
                                [ text (getConnectButtonText model.isConnected)
                                ]
                            ]
                        ]
                    , div [ class "col-4" ]
                        [ label [ class "float-right" ] [ text model.connectionMessage ]
                        ]
                    ]
                ]
            ]
        ]


getPortDisplay : Int -> String
getPortDisplay destinationPort =
    if destinationPort == 0 then
        ""
    else
        toString destinationPort


getConnectButtonText : Bool -> String
getConnectButtonText isConnected =
    case isConnected of
        True ->
            "Disconnect"

        False ->
            "Connect"
