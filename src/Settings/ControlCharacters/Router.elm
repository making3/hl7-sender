module Settings.ControlCharacters.Router exposing (..)

import Settings.Model as Settings exposing (Model)
import Settings.ControlCharacters.Model as ControlCharacters exposing (Model)


route : Settings.Model -> Settings.Model
route settings =
    { settings | controlCharacters = resetTempCharacters settings.controlCharacters }


resetTempCharacters : ControlCharacters.Model -> ControlCharacters.Model
resetTempCharacters controlCharacters =
    { controlCharacters
        | tempStartOfText = controlCharacters.startOfText
        , tempEndOfText = controlCharacters.endOfText
        , tempEndOfLine = controlCharacters.endOfLine
    }
