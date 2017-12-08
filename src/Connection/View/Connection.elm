module Connection.View.Connection exposing (..)

import Html exposing (Html, Attribute, program, div, input, button, text, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Connection.View.Log as Log exposing (view)
import Msg as Main exposing (..)
import Model as Main
import Connection.Msg exposing (..)
import Connection.Model as Connection exposing (Model)


view : Main.Model -> List (Html Main.Msg)
view model =
    [ connectionForm model.connection
    , connectionButtons model
    ]


host : Connection.Model -> Html Main.Msg
host model =
    div [ class "form-group row" ]
        [ label [ class "class-2 col-form-label" ]
            [ text "Host" ]
        , div [ class "col-10" ]
            [ inputIpAddress model
            ]
        ]


inputIpAddress : Connection.Model -> Html Main.Msg
inputIpAddress model =
    input
        [ class "form-control"
        , placeholder "IP Address"
        , onInput (MsgForConnection << ChangeDestinationIp)
        , readonly model.isConnected
        , value model.destinationIp
        ]
        []


inputPort : Connection.Model -> Html Main.Msg
inputPort model =
    input
        [ class "form-control mr-sm-2"
        , placeholder "Port"
        , readonly model.isConnected
        , onInput (MsgForConnection << ChangeDestinationPort)
        , value (getPortDisplay model.destinationPort)
        ]
        []


connectionForm : Connection.Model -> Html Main.Msg
connectionForm model =
    div [ class "col-9" ]
        [ host model
        , inputPort model
        ]


connectionButtons : Main.Model -> Html Main.Msg
connectionButtons model =
    div [ class "col-3" ]
        [ button
            [ class "btn btn-primary"
            , onClick (MsgForConnection ToggleConnection)
            ]
            [ text (getConnectButtonText model.connection.isConnected)
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
