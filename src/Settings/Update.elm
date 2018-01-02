module Settings.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Commands exposing (..)
import Settings.Model as Settings exposing (..)
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

        SaveConnection ->
            ( model, Cmd.none )
