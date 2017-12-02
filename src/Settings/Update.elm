module Settings.Update exposing (..)

import Msg as Main exposing (..)
import Settings.Model exposing (Model)
import Settings.Msg as Settings exposing (..)


update : Main.Msg -> Model -> Model
update msgFor settings =
    case msgFor of
        MsgForSettings msg ->
            updateSettings msg settings

        _ ->
            settings


updateSettings : Settings.Msg -> Model -> Model
updateSettings msg model =
    case msg of
        Saved error ->
            model

        -- TODO: Update settings?
        InitialSettings error settingsJson ->
            model
