module Route.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Route.Model as Root exposing (Route)
import Route.Msg as Route exposing (..)
import Route.Menu exposing (..)
import Home.Route as Home exposing (Route)
import Home.Router as Home exposing (routeHome)
import Settings.Route as Settings exposing (Route)
import Settings.Router as Settings exposing (route)


update : Route.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        GoHome ->
            ( routeHome model, Cmd.none )

        MenuClick menuItem ->
            ( menuClick model menuItem, Cmd.none )

        SaveConnection ->
            ( Settings.route model Settings.RouteSaveConnection, Cmd.none )
