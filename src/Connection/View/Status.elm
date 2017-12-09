module Connection.View.Status exposing (..)

import Html exposing (Html, div, label, text)
import Html.Attributes exposing (class)
import Msg as Main exposing (..)
import Model as Main


view : Main.Model -> Html Main.Msg
view model =
    div [ class "status-row" ]
        [ label [ class "sent-count" ]
            [ text ("Sent Count: " ++ (toString model.connection.sentCount)) ]
        , label
            [ class ("connection-status " ++ (getConnectionColor model.connection.isConnected)) ]
            [ text model.connection.connectionMessage ]
        ]


getConnectionColor : Bool -> String
getConnectionColor isConnected =
    if isConnected then
        "connected"
    else
        "disconnected"
