module Connection.View.Status exposing (..)

import Html exposing (Html, label, text)
import Html.Attributes exposing (class)
import Msg as Main exposing (..)
import Model as Main


view : Main.Model -> Html Main.Msg
view model =
    label [ class "float-right" ] [ text model.connection.connectionMessage ]
