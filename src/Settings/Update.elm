module Settings.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Route.Model as Root exposing (..)
import Home.Route as Home exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Commands exposing (..)
import Settings.Model as Settings exposing (..)
import Connection.Model as Connection exposing (Connection)
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

        newConnection =
            { connection | savedConnections = appendConnectionToList model model.connection.savedConnections }
    in
        { model
            | connection = newConnection
            , route = Root.RouteHome Home.RouteHome
        }


appendConnectionToList : Main.Model -> List Connection -> List Connection
appendConnectionToList model connections =
    (getNewConnection model) :: connections


getNewConnection : Main.Model -> Connection
getNewConnection model =
    { name = model.settings.newConnectionName
    , destinationIp = model.connection.destinationIp
    , destinationPort = model.connection.destinationPort
    }
