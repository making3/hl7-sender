module Route.Update exposing (..)

import Msg as Main exposing (..)
import Route.Model exposing (..)
import Route.Msg as Route exposing (..)
import Route.Menu exposing (..)


update : Main.Msg -> Model -> Model
update msgFor route =
    case msgFor of
        MsgForRoute msg ->
            updateRoute msg route

        _ ->
            route


updateRoute : Route.Msg -> Model -> Model
updateRoute msg model =
    case msg of
        GoHome ->
            RouteHome

        MenuClick menuItem ->
            menuClick model menuItem
