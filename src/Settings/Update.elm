port module Settings.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Model as Settings exposing (..)
import Settings.ControlCharacters.Update as ControlCharacters exposing (update)
import Settings.ControlCharacters.Model as ControlCharacters exposing (encode)


update : Main.Msg -> Main.Model -> Main.Model
update msgFor model =
    case msgFor of
        MsgForSettings msg ->
            updateSettings msg model

        _ ->
            model


updateSettings : Settings.Msg -> Main.Model -> Main.Model
updateSettings msg model =
    case msg of
        Saved errorMessage ->
            log model "error" errorMessage

        InitialSettings ( error, settingsJson ) ->
            case error of
                "" ->
                    case Settings.toModel settingsJson of
                        Ok newSettings ->
                            { model | settings = newSettings }

                        Err errorMessage ->
                            log model "error" errorMessage

                errorMessage ->
                    log model "error" errorMessage

        MsgForControlCharacters msgFor ->
            { model
                | settings = updateControlCharacters model.settings msgFor
            }

        _ ->
            model


updateControlCharacters settings msgFor =
    { settings
        | controlCharacters = ControlCharacters.update msgFor model.controlCharacters
    }


port settingsGet : String -> Cmd msg


port settingsSave : String -> Cmd msg


updateCmd : Main.Msg -> Main.Model -> Cmd a
updateCmd msgFor model =
    case msgFor of
        MsgForSettings msg ->
            updateWithCmd msg model.settings

        _ ->
            Cmd.none


updateWithCmd : Settings.Msg -> Settings.Model -> Cmd a
updateWithCmd msg settings =
    case msg of
        GetSettings ->
            settingsGet (Settings.toJson settings)

        SaveSettings ->
            settingsSave (Settings.toJson settings)

        _ ->
            Cmd.none
