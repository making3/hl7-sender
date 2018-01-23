module Settings.View.SaveConnection exposing (..)

import Html exposing (Html, Attribute, div, text, input, label)
import Html.Attributes exposing (class, value, placeholder)
import Html.Events exposing (onInput)
import Msg as Main exposing (..)
import Model as Main exposing (Model)
import Settings.Msg as Settings exposing (Msg(..))
import Connection.Msg as Connection exposing (Msg(..))
import Settings.Model as Settings
import Settings.View.Layout as SettingsLayout
import View.Controls.FormInput exposing (..)
import Connection.View.Connection exposing (getPortDisplay)


view : Main.Model -> Html Main.Msg
view model =
    SettingsLayout.view
        "Save New Connection"
        (div []
            [ viewName model
            , viewIpAddress model
            , viewPort model
            ]
        )


viewName : Main.Model -> Html Main.Msg
viewName model =
    viewBasicInput
        "new-connection-name"
        "Connection Name"
        model.settings.newConnectionName
        "Connection"
        (MsgForSettings << UpdateNewConnectionName)


viewIpAddress : Main.Model -> Html Main.Msg
viewIpAddress model =
    viewBasicInput
        "new-connection-name"
        "IP Address"
        model.connection.destinationIp
        "IP Address"
        (MsgForConnection << ChangeDestinationIp)


viewPort : Main.Model -> Html Main.Msg
viewPort model =
    viewBasicInput
        "new-connection-name"
        "Port"
        (getPortDisplay model.connection.destinationPort)
        "Port"
        (MsgForConnection << ChangeDestinationPort)
