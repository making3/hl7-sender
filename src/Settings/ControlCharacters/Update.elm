module Settings.ControlCharacters.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Model as Settings exposing (..)
import Settings.Commands as Settings exposing (save)
import Settings.ControlCharacters.Model as ControlCharacters exposing (Model)
import Settings.ControlCharacters.Msg as ControlCharacters exposing (..)


update : ControlCharacters.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        SaveControlCharacters ->
            let
                updatedModel =
                    { model
                        | settings = saveControlCharacters model.settings
                    }
            in
                ( updatedModel, Settings.save updatedModel.settings )

        ResetControlCharacters ->
            ( resetTempCharacters msg model, Cmd.none )

        _ ->
            ( { model
                | settings = updateTempCharacters msg model.settings
              }
            , Cmd.none
            )


resetTempCharacters : ControlCharacters.Msg -> Main.Model -> Main.Model
resetTempCharacters msg model =
    let
        updateSettings settings =
            { settings | controlCharacters = updateControlCharacters settings.controlCharacters }

        updateControlCharacters controlCharacters =
            { controlCharacters
                | tempStartOfText = controlCharacters.startOfText
                , tempEndOfText = controlCharacters.endOfText
                , tempEndOfLine = controlCharacters.endOfLine
                , pendingUpdate = False
            }
    in
        { model | settings = updateSettings model.settings }


updateTempCharacters : ControlCharacters.Msg -> Settings.Model -> Settings.Model
updateTempCharacters msg settings =
    { settings
        | controlCharacters = updateForm msg settings.controlCharacters
    }


updateForm : ControlCharacters.Msg -> ControlCharacters.Model -> ControlCharacters.Model
updateForm msg model =
    case msg of
        UpdateStartOfText newSot ->
            { model | tempStartOfText = getInt newSot } |> isPending

        UpdateEndOfText newEot ->
            { model | tempEndOfText = getInt newEot } |> isPending

        UpdateEndOfLine newEol ->
            { model | tempEndOfLine = getInt newEol } |> isPending

        _ ->
            model


isPending : ControlCharacters.Model -> ControlCharacters.Model
isPending controlCharacters =
    { controlCharacters
        | pendingUpdate =
            (controlCharacters.tempStartOfText /= controlCharacters.startOfText)
                || (controlCharacters.tempEndOfText /= controlCharacters.endOfText)
                || (controlCharacters.tempEndOfLine /= controlCharacters.endOfLine)
    }


saveControlCharacters : Settings.Model -> Settings.Model
saveControlCharacters settings =
    let
        applyControlCharacters controlCharacters =
            { controlCharacters
                | startOfText = controlCharacters.tempStartOfText
                , endOfText = controlCharacters.tempEndOfText
                , endOfLine = controlCharacters.tempEndOfLine
                , pendingUpdate = False
            }
    in
        { settings | controlCharacters = applyControlCharacters settings.controlCharacters }


getInt : String -> Int
getInt str =
    -- TODO: Error handling (Err msg)
    case String.toInt str of
        Ok i ->
            i

        Err _ ->
            0
