module Settings.ControlCharacters.Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg(..))
import Model as Main exposing (Model)
import Settings.Model as Settings exposing (Model)
import Settings.ControlCharacters.Model as ControlCharacters exposing (Model)
import Settings.ControlCharacters.Route as ControlCharacters exposing (Route)
import Settings.ControlCharacters.View.ControlCharacters as ControlCharacters


route : Settings.Model -> Settings.Model
route settings =
    { settings | controlCharacters = resetTempCharacters settings.controlCharacters }


resetTempCharacters : ControlCharacters.Model -> ControlCharacters.Model
resetTempCharacters controlCharacters =
    { controlCharacters
        | pendingUpdate = False
        , tempStartOfText = controlCharacters.startOfText
        , tempEndOfText = controlCharacters.endOfText
        , tempEndOfLine = controlCharacters.endOfLine
    }


render : Main.Model -> ControlCharacters.Route -> Html Msg
render model internalRoute =
    case internalRoute of
        ControlCharacters.RouteHome ->
            ControlCharacters.view model.settings
