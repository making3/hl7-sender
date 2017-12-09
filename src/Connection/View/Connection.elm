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
    [ div [ class "col-9" ] (connectionFormControls model.connection)
    , div [ class "col-3" ] (connectionButtons model)
    ]


connectionFormControls : Connection.Model -> List (Html Main.Msg)
connectionFormControls connection =
    [ formInput connection "Host" inputIpAddress
    , formInput connection "Port" inputPort
    ]


inputIpAddress : Connection.Model -> Html Main.Msg
inputIpAddress connection =
    inputControl
        "Host"
        connection.destinationIp
        connection.isConnected
        (MsgForConnection << ChangeDestinationIp)


inputPort : Connection.Model -> Html Main.Msg
inputPort connection =
    inputControl
        "Port"
        (getPortDisplay connection.destinationPort)
        connection.isConnected
        (MsgForConnection << ChangeDestinationPort)


formInput : Connection.Model -> String -> (Connection.Model -> Html Main.Msg) -> Html Main.Msg
formInput connection name inputControl =
    div
        [ class "form-group row" ]
        [ label
            [ class "class-2 col-form-label" ]
            [ text name ]
        , div
            [ class "col-10" ]
            [ inputControl connection ]
        ]


inputControl : String -> String -> Bool -> (String -> Main.Msg) -> Html Main.Msg
inputControl inputPlaceholder getValue isConnected msg =
    input
        [ class "form-control mr-sm-2"
        , placeholder inputPlaceholder
        , readonly isConnected
        , onInput msg
        , value getValue
        ]
        []


getPortDisplay : Int -> String
getPortDisplay destinationPort =
    if destinationPort == 0 then
        ""
    else
        toString destinationPort


connectionButtons : Main.Model -> List (Html Main.Msg)
connectionButtons model =
    [ button
        [ class "btn btn-primary"
        , onClick (MsgForConnection ToggleConnection)
        ]
        [ text (getConnectButtonText model.connection.isConnected)
        ]
    ]


getConnectButtonText : Bool -> String
getConnectButtonText isConnected =
    case isConnected of
        True ->
            "Disconnect"

        False ->
            "Connect"
