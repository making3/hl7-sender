module Settings.ControlCharacters.Update exposing (..)

import Settings.Msg as Settings exposing (..)
import Settings.ControlCharacters.Model exposing (Model)
import Settings.ControlCharacters.Msg as ControlCharacters exposing (..)


update : ControlCharacters.Msg -> Model -> Model
update msg model =
    case msg of
        UpdateStartOfText newSot ->
            { model | startOfText = getInt newSot }

        UpdateEndOfText newEot ->
            { model | endOfText = getInt newEot }

        UpdateEndOfLine newEol ->
            { model | endOfLine = getInt newEol }


getInt : String -> Int
getInt str =
    -- TODO: Error handling (Err msg)
    case String.toInt str of
        Ok i ->
            i

        Err _ ->
            0
