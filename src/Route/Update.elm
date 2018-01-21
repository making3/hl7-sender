module Route.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Route.Model as Root exposing (Route)
import Route.Msg as Route exposing (..)
import Route.Menu exposing (..)
import Home.Route as Home exposing (Route)
import Home.Router as Home exposing (routeHome)


update : Route.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        GoHome ->
            ( routeHome model, Cmd.none )

        MenuClick menuItem ->
            ( menuClick model menuItem, Cmd.none )

        SaveConnection ->
            ( updateRoute model Root.RouteSaveConnection, Cmd.none )


updateRoute : Main.Model -> Root.Route -> Main.Model
updateRoute model newRoute =
    { model | route = newRoute }
