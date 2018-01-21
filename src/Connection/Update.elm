port module Connection.Update exposing (..)

import Char
import List exposing (head, filter)
import Msg as Main exposing (..)
import Model as Main exposing (..)
import Connection.Model as Connection exposing (Model, Connection, toSavedConnectionsModels)
import Connection.Msg as Connection exposing (..)
import Connection.Validations exposing (..)
import Settings.Router as Settings exposing (route)
import Settings.Route as Settings exposing (Route)


update : Connection.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        ChangeDestinationIp ipAddress ->
            ( updateIpAddress model ipAddress, Cmd.none )

        ChangeDestinationPort newPort ->
            case validatePort newPort of
                ValidPort validatedPort ->
                    ( { model
                        | connection = updatePort model.connection validatedPort
                      }
                    , Cmd.none
                    )

                EmptyPort ->
                    ( { model
                        | connection = updatePort model.connection 0
                      }
                    , Cmd.none
                    )

                InvalidPort ->
                    ( model, Cmd.none )

        Connected ->
            connected model
                |> log "info" "Connected"

        Disconnected ->
            disconnected model
                |> log "info" "Disconnected"

        ConnectionError errorMsg ->
            disconnected model
                |> log "error" errorMsg

        Sent ->
            updateSentCount model
                |> log "info" "Sent a message"

        ClearLog ->
            ( { model | logs = [] }, Cmd.none )

        Send ->
            ( model, send (getWrappedHl7 model) )

        ToggleConnection ->
            case model.connection.isConnected of
                False ->
                    ( model
                    , connect
                        ( model.connection.destinationIp
                        , model.connection.destinationPort
                        )
                    )

                True ->
                    ( model
                    , disconnect ()
                    )

        ChangeSavedConnection savedConnectionName ->
            ( updateConnectionFromSaved model savedConnectionName, Cmd.none )

        SaveConnection ->
            case model.connection.currentSavedConnectionName of
                "Create New" ->
                    ( Settings.route model Settings.RouteSaveConnection, Cmd.none )

                _ ->
                    ( model, saveConnection ( model.connection.currentSavedConnectionName, model.connection.destinationIp, model.connection.destinationPort ) )

        SavedConnection errorMessage ->
            case errorMessage of
                "" ->
                    log "info" "Saved Connection!" model

                _ ->
                    log "error" ("Failed to save message" ++ errorMessage) model

        InitialSavedConnections ( error, savedConnectionsJson ) ->
            case error of
                "" ->
                    updateInitialSavedConnections model savedConnectionsJson

                errorMessage ->
                    log "error" errorMessage model


updateConnectionFromSaved : Main.Model -> String -> Main.Model
updateConnectionFromSaved model connectionName =
    let
        connection =
            model.connection

        foundConnection =
            List.head (List.filter (\m -> m.name == connectionName) connection.savedConnections)

        replacedConnection =
            case foundConnection of
                Nothing ->
                    connection

                Just newConnection ->
                    { connection
                        | destinationIp = newConnection.destinationIp
                        , destinationPort = newConnection.destinationPort
                        , currentSavedConnectionName = connectionName
                    }
    in
        { model | connection = replacedConnection }


updateIpAddress : Main.Model -> String -> Main.Model
updateIpAddress model ipAddress =
    let
        connection =
            model.connection

        newConnection =
            { connection | destinationIp = ipAddress }
    in
        { model | connection = newConnection }


updatePort connection newPort =
    { connection | destinationPort = clamp 1 65535 newPort }


updateInitialSavedConnections : Main.Model -> String -> ( Main.Model, Cmd Main.Msg )
updateInitialSavedConnections model savedConnectionsJson =
    case toSavedConnectionsModels savedConnectionsJson of
        Ok savedConnections ->
            let
                connection =
                    model.connection

                newConnection =
                    { connection | savedConnections = appendCreateNewConnection savedConnections }

                newModel =
                    { model | connection = newConnection }

                defaultConnectionName =
                    getInitialConnectionName savedConnections
            in
                ( updateConnectionFromSaved newModel defaultConnectionName, Cmd.none )

        Err errorMessage ->
            log "error" errorMessage model


getInitialConnectionName : List Connection -> String
getInitialConnectionName connections =
    case List.head connections of
        Just connection ->
            connection.name

        Nothing ->
            ""


appendCreateNewConnection : List Connection -> List Connection
appendCreateNewConnection connections =
    List.append connections [ getCreateNewConnection ]


getCreateNewConnection : Connection
getCreateNewConnection =
    { name = "Create New"
    , destinationIp = "127.0.0.1"
    , destinationPort = 3000
    }


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


port saveConnection : ( String, String, Int ) -> Cmd msg


getWrappedHl7 : Main.Model -> String
getWrappedHl7 model =
    getCharStr model.settings.controlCharacters.startOfText
        ++ getStrWithCarriageReturns (model.home.hl7)
        ++ getCharStr model.settings.controlCharacters.endOfLine
        ++ getCharStr model.settings.controlCharacters.endOfText


getStrWithCarriageReturns : String -> String
getStrWithCarriageReturns str =
    String.split "\n" str
        |> String.join "\x0D"


getCharStr : Int -> String
getCharStr i =
    String.fromChar (Char.fromCode i)
