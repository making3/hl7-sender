port module Connection.Update exposing (..)

import Char
import Msg as Main exposing (..)
import Model as Main exposing (..)
import Connection.Model as Connection exposing (Model)
import Connection.Msg as Connection exposing (..)
import Connection.Validations exposing (..)


update : Main.Msg -> Connection.Model -> Connection.Model
update msgFor connection =
    case msgFor of
        MsgForConnection msg ->
            updateConnection msg connection

        _ ->
            connection


updateConnection : Connection.Msg -> Connection.Model -> Connection.Model
updateConnection msg model =
    case msg of
        ChangeDestinationIp newIp ->
            { model | destinationIp = newIp }

        ChangeDestinationPort newPort ->
            case validatePort newPort of
                ValidPort validatedPort ->
                    { model | destinationPort = clamp 1 65535 validatedPort }

                EmptyPort ->
                    { model | destinationPort = 0 }

                InvalidPort ->
                    model

        Connected ->
            { model | isConnected = True, connectionMessage = "Connected" }

        Disconnected ->
            { model | isConnected = False, connectionMessage = "Disconnected" }

        ConnectionError errorMsg ->
            -- TODO: Write error somewhere..
            { model | isConnected = False, connectionMessage = ("Disconnected: " ++ errorMsg) }

        _ ->
            model


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
    getCharStr model.controlCharacters.startOfText
        ++ model.home.hl7
        ++ getCharStr model.controlCharacters.endOfLine
        ++ getCharStr model.controlCharacters.endOfText


getCharStr : Int -> String
getCharStr i =
    String.fromChar (Char.fromCode i)
