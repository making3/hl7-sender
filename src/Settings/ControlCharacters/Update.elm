module Settings.ControlCharacters.Update exposing (..)

import Msg as Main exposing (..)
import Settings.ControlCharacters.Model exposing (Model)
import Settings.ControlCharacters.Msg as ControlCharacters exposing (..)


update : Main.Msg -> Model -> Model
update msgFor controlCharacters =
    case msgFor of
        MsgForControlCharacters msg ->
            updateControlCharacters msg controlCharacters

        _ ->
            controlCharacters


updateControlCharacters : ControlCharacters.Msg -> Model -> Model
updateControlCharacters msg model =
    case msg of
        UpdateStartOfText newSot ->
            { model | startOfText = getInt newSot }

        UpdateEndOfText newEot ->
            { model | startOfText = getInt newEot }

        UpdateEndOfLine newEol ->
            { model | startOfText = getInt newEol }


getInt : String -> Int
getInt str =
    -- TODO: Error handling (Err msg)
    case String.toInt str of
        Ok i ->
            i

        Err _ ->
            0
