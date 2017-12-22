module Connection.View.Connection exposing (..)

import Json.Decode as Json
import Html exposing (Html, Attribute, program, div, input, button, text, label, datalist, option)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onInput, onClick)
import Connection.View.Log as Log exposing (view)
import Msg as Main exposing (..)
import Model as Main
import Connection.Msg exposing (..)
import Connection.Model as Connection exposing (Model, Connection)


view : Main.Model -> Html Main.Msg
view model =
    div [ class "row" ]
        [ div [ class "col-8" ] (connectionFormControls model.connection)
        , div [ class "col-4" ] (connectionButtons model)
        ]


connectionFormControls : Connection.Model -> List (Html Main.Msg)
connectionFormControls connection =
    [ formInput connection "Host" inputIpAddress
    , formInput connection "Port" inputPort
    , formInput connection "Saved" inputSavedConnections
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
        [ class "form-group row connection-input-form" ]
        [ label
            [ class "col-sm-3 col-form-label col-form-label-sm" ]
            [ text name ]
        , div
            [ class "col-9" ]
            [ inputControl connection ]
        ]


inputControl : String -> String -> Bool -> (String -> Main.Msg) -> Html Main.Msg
inputControl inputPlaceholder getValue isConnected msg =
    input
        [ class "form-control form-control-sm"
        , placeholder inputPlaceholder
        , readonly isConnected
        , onInput msg
        , value getValue
        ]
        []


inputSavedConnections : Connection.Model -> Html Main.Msg
inputSavedConnections connection =
    div []
        [ input
            [ class "form-control form-control-sm"
            , list getSavedConnectionsId
            , onInput (MsgForConnection << ChangeSavedConnection)
            ]
            []
        , datalist [ id getSavedConnectionsId ]
            (List.map toOptions connection.savedConnections)
        ]


getSavedConnectionsId : String
getSavedConnectionsId =
    "saved-connections"


toOptions : Connection.Connection -> Html msg
toOptions connection =
    option [ value connection.name ] []


onChange : (String -> msg) -> Attribute msg
onChange handler =
    on "change" <| Json.map handler <| Json.at [ "target", "value" ] Json.string


getPortDisplay : Int -> String
getPortDisplay destinationPort =
    if destinationPort == 0 then
        ""
    else
        toString destinationPort


connectionButtons : Main.Model -> List (Html Main.Msg)
connectionButtons model =
    [ button
        [ class "btn btn-sm btn-block btn-primary"
        , onClick (MsgForConnection ToggleConnection)
        ]
        [ text (getConnectButtonText model.connection.isConnected) ]
    , button
        [ class "clear-log btn btn-sm btn-block btn-secondary"
        , onClick (MsgForConnection ClearLog)
        ]
        [ text "Clear Log" ]
    , button
        [ class "save-connection btn btn-sm btn-block btn-secondary" ]
        [ text "Save" ]
    ]


getConnectButtonText : Bool -> String
getConnectButtonText isConnected =
    case isConnected of
        True ->
            "Disconnect"

        False ->
            "Connect"
