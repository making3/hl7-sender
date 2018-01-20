module Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg(..))
import Model as Main exposing (Model)
import Home.View.Home as Home
import Home.View.About as About
import View.Layout.Primary as PrimaryLayout exposing (view)
import Home.Model as Home exposing (Model)
import Route.Model as Root exposing (Route)
import Home.Router as Home exposing (route)
import Settings.ControlCharacters.View.ControlCharacters as ControlCharacters


route : Main.Model -> Html Msg
route model =
    PrimaryLayout.view model (page model)


page : Main.Model -> Html Msg
page model =
    case model.route of
        Root.RouteHome internalRoute ->
            Home.route model internalRoute

        -- TODO: Move this route to Settings.Router
        Root.RouteControlCharacters ->
            ControlCharacters.view model.settings
