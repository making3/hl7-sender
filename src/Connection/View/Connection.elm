module Connection.View.Connection exposing (..)

import Html exposing (Html, Attribute, program, div, input, button, text, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msg as Main exposing (..)
import Model as Main
import Connection.Msg exposing (..)


view : Main.Model -> Html Main.Msg
view model =
    Html.footer [ class "footer" ]
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
