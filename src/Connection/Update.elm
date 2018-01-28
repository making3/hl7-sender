module Connection.Update exposing (..)

import Array exposing (Array, get, toList, push)
import List exposing (head, filter)
import Msg as Main exposing (..)
import Model as Main exposing (..)
import Route.Model as Root exposing (..)
import Home.Route as Home exposing (..)
import Home.Router exposing (routeHome)
import Connection.Model as Connection exposing (Model, Connection, toSavedConnectionsModels, getCreateNewConnection)
import Connection.Msg as Connection exposing (..)
import Connection.Validations exposing (..)
import Connection.HL7 exposing (getWrappedHl7)
import Connection.Ports exposing (..)
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
            ( changeConnectionFromSaved model savedConnectionName, Cmd.none )

        SaveConnection ->
            ( model, saveConnection ( model.settings.newConnectionName, model.connection.destinationIp, model.connection.destinationPort ) )

        CreateNewConnection ->
            case model.connection.currentSavedConnectionName of
                "Create New" ->
                    ( Settings.route model Settings.RouteSaveConnection, Cmd.none )

                _ ->
                    ( model, saveConnection ( model.connection.currentSavedConnectionName, model.connection.destinationIp, model.connection.destinationPort ) )

        SavedConnection "" ->
            model
                |> updateSavedConnectionsWithCurrent
                |> routeHome
                |> logSavedConnection

        SavedNewConnection "" ->
            model
                |> addNewConnection
                |> routeHome
                |> logSavedConnection

        InitialSavedConnections ( "", savedConnectionsJson ) ->
            updateInitialSavedConnections model savedConnectionsJson

        SavedConnection errorMessage ->
            log "error" ("Failed to save message" ++ errorMessage) model

        SavedNewConnection errorMessage ->
            log "error" ("Failed to save message" ++ errorMessage) model

        InitialSavedConnections ( errorMessage, savedConnectionsJson ) ->
            log "error" errorMessage model


logSavedConnection : Main.Model -> ( Main.Model, Cmd Main.Msg )
logSavedConnection model =
    log "info" "Saved Connection!" model


changeConnectionFromSaved : Main.Model -> String -> Main.Model
changeConnectionFromSaved model connectionName =
    case connectionName of
        "Create New" ->
            updateCurrentConnection model getCreateNewConnection

        _ ->
            case findConnectionByName model connectionName of
                Nothing ->
                    model

                Just newConnection ->
                    updateCurrentConnection model newConnection


findConnectionByName : Main.Model -> String -> Maybe Connection
findConnectionByName model connectionName =
    List.head (List.filter (\m -> m.name == connectionName) (Array.toList model.connection.savedConnections))


updateCurrentConnection : Main.Model -> Connection -> Main.Model
updateCurrentConnection model newConnection =
    let
        connection =
            model.connection

        replacedConnection =
            { connection
                | destinationIp = newConnection.destinationIp
                , destinationPort = newConnection.destinationPort
                , currentSavedConnectionName = newConnection.name
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
                    { connection | savedConnections = savedConnections }

                newModel =
                    { model | connection = newConnection }

                defaultConnectionName =
                    getInitialConnectionName savedConnections
            in
                ( changeConnectionFromSaved newModel defaultConnectionName, Cmd.none )

        Err errorMessage ->
            log "error" errorMessage model


getInitialConnectionName : Array Connection -> String
getInitialConnectionName connections =
    case Array.get 0 connections of
        Just connection ->
            connection.name

        Nothing ->
            ""


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


addNewConnection : Main.Model -> Main.Model
addNewConnection model =
    let
        connection =
            model.connection

        settings =
            model.settings

        newIndividualConnection =
            getNewConnection model

        newConnection =
            { connection
                | savedConnections = appendConnectionToArray model newIndividualConnection model.connection.savedConnections
            }

        newSettings =
            { settings
                | newConnectionName = ""
            }

        newModel =
            { model
                | connection = newConnection
                , route = Root.RouteHome Home.RouteHome
                , settings = newSettings
            }
    in
        updateCurrentConnection newModel newIndividualConnection


appendConnectionToArray : Main.Model -> Connection -> Array Connection -> Array Connection
appendConnectionToArray model newConnection connections =
    Array.push newConnection connections


getNewConnection : Main.Model -> Connection
getNewConnection model =
    { name = model.settings.newConnectionName
    , destinationIp = model.connection.destinationIp
    , destinationPort = model.connection.destinationPort
    }


updateSavedConnectionsWithCurrent : Main.Model -> Main.Model
updateSavedConnectionsWithCurrent model =
    let
        connection =
            model.connection

        newSavedConnections =
            updateSavedConnectionsByIndex
                connection.savedConnections
                model.connection.currentSavedConnectionName
                model.connection.destinationIp
                model.connection.destinationPort

        newConnection =
            { connection | savedConnections = newSavedConnections }
    in
        { model | connection = newConnection }


updateSavedConnectionsByIndex : Array Connection -> String -> String -> Int -> Array Connection
updateSavedConnectionsByIndex connections connectionName destinationIp destinationPort =
    Array.set ((Array.length connections) - 1) ({ name = connectionName, destinationIp = destinationIp, destinationPort = destinationPort }) connections
