module Settings.Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg)
import Model as Main exposing (Model)
import Settings.Route as Settings exposing (Route)
import Settings.ControlCharacters.Router as ControlCharacters exposing (render)


render : Main.Model -> Settings.Route -> Html Msg
render model internalRoute =
    case internalRoute of
        Settings.RouteControlCharacters settingsInternalRoute ->
            ControlCharacters.render model settingsInternalRoute
