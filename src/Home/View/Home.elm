module Home.View.Home exposing (..)

import Html exposing (Html, Attribute, program, div, span, input, button, text, label, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msg as Main exposing (..)
import Model as Main
import Home.Model as Home
import Home.Msg as Home exposing (..)
import Connection.Msg exposing (..)


view : Main.Model -> Html Main.Msg
view model =
    div []
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-12" ]
                    [ div []
                        [ div [ class "form-group" ]
                            [ label []
                                [ text "HL7 Message"
                                ]
                            , textarea
                                [ class "form-control"
                                , onInput (MsgForHome << ChangeHl7)
                                , rows 8
                                ]
                                []
                            ]
                        , button
                            [ class "btn btn-primary float-right"
                            , onClick (MsgForConnection Send)
                            , disabled (model.connection.isConnected == False)
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
                                , onInput (MsgForConnection << ChangeDestinationIp)
                                , readonly model.connection.isConnected
                                , value model.connection.destinationIp
                                ]
                                []
                            , input
                                [ class "form-control mr-sm-2"
                                , placeholder "Port"
                                , readonly model.connection.isConnected
                                , onInput (MsgForConnection << ChangeDestinationPort)
                                , value (getPortDisplay model.connection.destinationPort)
                                ]
                                []
                            , button
                                [ class "btn btn-primary"
                                , onClick (MsgForConnection ToggleConnection)
                                ]
                                [ text (getConnectButtonText model.connection.isConnected)
                                ]
                            ]
                        ]
                    , div [ class "col-4" ]
                        [ label [ class "float-right" ] [ text model.connection.connectionMessage ]
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
