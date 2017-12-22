port module Settings.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Model as Settings exposing (..)
import Settings.ControlCharacters.Update as ControlCharacters exposing (update)
import Settings.ControlCharacters.Model as ControlCharacters exposing (encode)


update : Settings.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        Saved errorMessage ->
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
            ( { model
                | settings = updateControlCharacters model.settings msgFor
              }
            , Cmd.none
            )

        _ ->
            ( model, updateWithCmd msg model )


updateControlCharacters settings msgFor =
    { settings
        | controlCharacters = ControlCharacters.update msgFor model.controlCharacters
    }


port settingsGet : String -> Cmd msg


port settingsSave : String -> Cmd msg


updateWithCmd : Settings.Msg -> Main.Model -> Cmd Main.Msg
updateWithCmd msg model =
    case msg of
        GetSettings ->
            settingsGet (Settings.toJson model.settings)

        SaveSettings ->
            settingsSave (Settings.toJson model.settings)

        _ ->
            Cmd.none
