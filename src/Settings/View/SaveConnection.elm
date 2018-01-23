module Settings.View.SaveConnection exposing (..)

import Html exposing (Html, Attribute, div, text, input, label, button)
import Html.Attributes exposing (class, value, placeholder, disabled)
import Html.Events exposing (onInput, onClick)
import Msg as Main exposing (..)
import Model as Main exposing (Model)
import Route.Msg as Route exposing (Msg(..))
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
        (div [ class "basic-form" ]
            [ viewName model
            , viewIpAddress model
            , viewPort model
            , viewActionButtons model
            ]
        )


viewName : Main.Model -> Html Main.Msg
viewName model =
    viewBasicInput
        "Connection Name"
        model.settings.newConnectionName
        "Connection"
        (MsgForSettings << UpdateNewConnectionName)


viewIpAddress : Main.Model -> Html Main.Msg
viewIpAddress model =
    viewBasicInput
        "IP Address"
        model.connection.destinationIp
        "IP Address"
        (MsgForConnection << ChangeDestinationIp)


viewPort : Main.Model -> Html Main.Msg
viewPort model =
    viewBasicInput
        "Port"
        (getPortDisplay model.connection.destinationPort)
        "Port"
        (MsgForConnection << ChangeDestinationPort)


viewActionButtons : Main.Model -> Html Main.Msg
viewActionButtons model =
    div [ class "save-connection-buttons" ]
        [ button
            [ class "btn btn-primary"
            , onClick (MsgForRoute GoHome)
            ]
            [ text "Go Home" ]
        , button
            [ class "btn btn-primary"
            , onClick (MsgForSettings (Settings.SaveConnection))
            , disabled (model.settings.newConnectionName == "")
            ]
            [ text "Save" ]
        ]
