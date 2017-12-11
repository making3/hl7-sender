port module Connection.Update exposing (..)

import Char
import Msg as Main exposing (..)
import Model as Main exposing (..)
import Connection.Model as Connection exposing (Model)
import Connection.Msg as Connection exposing (..)
import Connection.Validations exposing (..)


update : Main.Msg -> Main.Model -> Main.Model
update msgFor model =
    case msgFor of
        MsgForConnection msg ->
            updateConnection msg model

        _ ->
            model


updateConnection : Connection.Msg -> Main.Model -> Main.Model
updateConnection msg model =
    case msg of
        ChangeDestinationIp newIp ->
            { model
                | connection = updateIpAddress model.connection newIp
            }

        ChangeDestinationPort newPort ->
            case validatePort newPort of
                ValidPort validatedPort ->
                    { model
                        | connection = updatePort model.connection validatedPort
                    }

                EmptyPort ->
                    { model
                        | connection = updatePort model.connection 0
                    }

                InvalidPort ->
                    model

        Connected ->
            log model "info" "Connected"
                |> connected

        Disconnected ->
            log model "info" "Disconnected"
                |> disconnected

        ConnectionError errorMsg ->
            log model "error" errorMsg
                |> disconnected

        Sent ->
            log model "info" "Sent a message"
                |> updateSentCount

        ClearLog ->
            { model | logs = [] }

        _ ->
            model


updateIpAddress connection newIp =
    { connection | destinationIp = newIp }


updatePort connection newPort =
    { connection | destinationPort = clamp 1 65535 newPort }


connected model =
    { model
        | connection = updateConnectionStatus model.connection True "Connected"
    }


disconnected model =
    { model
        | connection = updateConnectionStatus model.connection False "Disconnected"
    }


updateConnectionStatus connection isConnected message =
    { connection
        | isConnected = isConnected
        , connectionMessage = message
    }


updateSentCount model =
    { model
        | connection = Connection.updateSentCount model.connection
    }


port connect : ( String, Int ) -> Cmd msg


port disconnect : () -> Cmd msg


port send : String -> Cmd msg


updateCmd : Main.Msg -> Main.Model -> Cmd a
updateCmd msgFor model =
    case msgFor of
        MsgForConnection msg ->
            updateWithCmd msg model

        _ ->
            Cmd.none


updateWithCmd : Connection.Msg -> Main.Model -> Cmd a
updateWithCmd msg model =
    case msg of
        Send ->
            send (getWrappedHl7 model)

        ToggleConnection ->
            case model.connection.isConnected of
                False ->
                    connect
                        ( model.connection.destinationIp
                        , model.connection.destinationPort
                        )

                True ->
                    disconnect ()

        _ ->
            Cmd.none


getWrappedHl7 : Main.Model -> String
getWrappedHl7 model =
    getCharStr model.settings.controlCharacters.startOfText
        ++ model.home.hl7
        ++ getCharStr model.settings.controlCharacters.endOfLine
        ++ getCharStr model.settings.controlCharacters.endOfText


getCharStr : Int -> String
getCharStr i =
    String.fromChar (Char.fromCode i)
