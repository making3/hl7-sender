port module Settings.Update exposing (..)

import Json.Encode exposing (encode, Value, object, int)
import Msg as Main exposing (..)
import Model as Main exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Model as Settings exposing (..)
import Settings.ControlCharacters.Update as ControlCharacters exposing (encode)


update : Main.Msg -> Settings.Model -> Settings.Model
update msgFor settings =
    case msgFor of
        MsgForSettings msg ->
            updateSettings msg settings

        _ ->
            settings


updateSettings : Settings.Msg -> Settings.Model -> Settings.Model
updateSettings msg model =
    case msg of
        Saved error ->
            model

        -- TODO: Update settings?
        InitialSettings ( error, settingsJson ) ->
            model

        _ ->
            model


port settingsGet : String -> Cmd msg


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
            settingsGet (settingsToJson settings)

        _ ->
            Cmd.none


settingsToJson : Settings.Model -> String
settingsToJson settings =
    Json.Encode.encode 0 (encodeSettings settings)


encodeSettings : Settings.Model -> Value
encodeSettings settings =
    object
        [ ( "controlCharacters"
          , ControlCharacters.encode settings.controlCharacters
          )
        ]
