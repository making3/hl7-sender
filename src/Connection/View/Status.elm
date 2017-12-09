module Connection.View.Status exposing (..)

import Html exposing (Html, div, label, text)
import Html.Attributes exposing (class)
import Msg as Main exposing (..)
import Model as Main


view : Main.Model -> Html Main.Msg
view model =
    div [ class "status-row" ]
        [ label [ class "sent-count" ]
            [ text "Sent Count: 0" ]
        , label
            [ class "connection-status" ]
            [ text model.connection.connectionMessage ]
        ]
