module Settings.Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg)
import Model as Main exposing (Model)
import Route.Model as Root exposing (Route)
import Settings.Route as Settings exposing (Route)
import Settings.ControlCharacters.Router as ControlCharacters exposing (render)
import Settings.View.SaveConnection as SaveConnection


route : Main.Model -> Settings.Route -> Main.Model
route model route =
    { model | route = Root.RouteSettings route }


render : Main.Model -> Settings.Route -> Html Msg
render model internalRoute =
    case internalRoute of
        Settings.RouteControlCharacters settingsInternalRoute ->
            ControlCharacters.render model settingsInternalRoute

        Settings.RouteSaveConnection ->
            SaveConnection.view model
