module Settings.Update exposing (..)

import Array exposing (Array, push)
import Msg as Main exposing (..)
import Model as Main exposing (..)
import Route.Model as Root exposing (..)
import Home.Route as Home exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Commands exposing (..)
import Settings.Model as Settings exposing (..)
import Connection.Model as Connection exposing (Connection)
import Connection.Update as Connection exposing (appendCreateNewConnection, updateCurrentConnection)
import Settings.ControlCharacters.Update as ControlCharacters exposing (update)
import Settings.ControlCharacters.Model as ControlCharacters exposing (encode)


update : Settings.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        Saved errorMessage ->
            if errorMessage == "" then
                log "info" "Saved settings" model
            else
                log "error" errorMessage model

        InitialSettings ( error, settingsJson ) ->
            case error of
                "" ->
                    case Settings.toModel settingsJson of
                        Ok newSettings ->
                            ( { model | settings = newSettings }, Cmd.none )

                        Err errorMessage ->
                            log "error" errorMessage model

                errorMessage ->
                    log "error" errorMessage model

        MsgForControlCharacters msgFor ->
            ControlCharacters.update msgFor model

        GetSettings ->
            ( model, get model.settings )

        SaveSettings ->
            ( model, save model.settings )

        UpdateNewConnectionName connectionName ->
            let
                settings =
                    model.settings

                newSettings =
                    { settings | newConnectionName = connectionName }
            in
                ( { model | settings = newSettings }, Cmd.none )

        SaveConnection ->
            ( addNewConnection model, Cmd.none )


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
    connections
        |> Array.set ((Array.length connections) - 1) newConnection
        |> appendCreateNewConnection


getNewConnection : Main.Model -> Connection
getNewConnection model =
    { name = model.settings.newConnectionName
    , destinationIp = model.connection.destinationIp
    , destinationPort = model.connection.destinationPort
    }
