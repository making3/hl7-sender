module Route.Menu exposing (..)

import Model as Main exposing (Model)
import Settings.ControlCharacters.Router as ControlCharacters exposing (route)
import Home.Router as Home exposing (routeMenu)
import Route.Model as Root exposing (Route)
import Home.Route as Home exposing (Route)


menuClick : Main.Model -> String -> Main.Model
menuClick model menuItem =
    case menuItem of
        "edit-control-characters" ->
            ControlCharacters.route model

        _ ->
            Home.routeMenu model menuItem
