module Connection.View.Footer exposing (..)

import Html exposing (Html, Attribute, program, div, input, button, text, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msg as Main exposing (..)
import Model as Main
import Connection.Msg exposing (..)


view : Main.Model -> Html Main.Msg
view model =
    Html.footer [ class "footer" ]
        [ div [ class "row-fluid" ]
            [ viewConnection model
            , div [ class "col-4" ]
                [ label [ class "float-right" ] [ text model.connection.connectionMessage ]
                ]
            ]
        ]


viewConnection : Main.Model -> Html Main.Msg
viewConnection model =
    div [ class "col-8" ]
        [ div [ class "" ]
            [ div [ class "form-group row" ]
                [ label [ class "class-2 col-form-label" ]
                    [ text "Host" ]
                , div
                    [ class "col-10" ]
                    [ input
                        [ class "form-control"
                        , placeholder "IP Address"
                        , onInput (MsgForConnection << ChangeDestinationIp)
                        , readonly model.connection.isConnected
                        , value model.connection.destinationIp
                        ]
                        []
                    ]
                ]
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
