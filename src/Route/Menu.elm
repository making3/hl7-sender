module Route.Menu exposing (..)

import Route.Model as Route exposing (..)
import Model as Main exposing (..)
import Settings.Router as Settings exposing (route)


menuClick : Main.Model -> String -> Main.Model
menuClick model menuItem =
    case menuItem of
        "edit-control-characters" ->
            Settings.route model

        "about" ->
            { model | route = RouteAbout }

        _ ->
            { model | route = RouteHome }
