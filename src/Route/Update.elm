module Route.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Route.Model as Root exposing (Route)
import Route.Msg as Route exposing (..)
import Route.Menu exposing (..)
import Home.Route as Home exposing (Route)


update : Route.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        GoHome ->
            ( updateRoute model (Root.RouteHome Home.RouteHome), Cmd.none )

        MenuClick menuItem ->
            ( menuClick model menuItem, Cmd.none )


updateRoute : Main.Model -> Root.Route -> Main.Model
updateRoute model newRoute =
    { model | route = newRoute }
