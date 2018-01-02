module Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg(..))
import Model as Main exposing (Model)
import Home.View.Home as Home
import Home.View.About as About
import View.Layout.Primary as PrimaryLayout exposing (view)
import Home.Model exposing (Model)
import Route.Model as Route exposing (Route)
import Settings.ControlCharacters.View.ControlCharacters as ControlCharacters
import Settings.View.SaveConnection as SaveConnection


route : Main.Model -> Html Msg
route model =
    PrimaryLayout.view model (page model)


page : Main.Model -> Html Msg
page model =
    case model.route of
        Route.RouteHome ->
            Home.view model

        Route.RouteAbout ->
            About.view model

        -- TODO: Move this route to Settings.Router
        Route.RouteControlCharacters ->
            ControlCharacters.view model.settings

        Route.RouteSaveConnection ->
            SaveConnection.view model.settings
