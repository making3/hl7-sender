module Settings.Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg(..))
import Model as Main exposing (Model)
import Route.Model as Root exposing (Route)
import Settings.Route as Settings exposing (Route)
import Settings.ControlCharacters.Router as ControlCharacters exposing (route)
import Settings.ControlCharacters.View.ControlCharacters as ControlCharacters


route : Main.Model -> Main.Model
route model =
    { model
        | settings = ControlCharacters.route model.settings
        , route = Root.RouteSettings Settings.RouteControlCharacters
    }


render : Main.Model -> Settings.Route -> Html Msg
render model internalRoute =
    case internalRoute of
        Settings.RouteControlCharacters ->
            ControlCharacters.view model.settings
