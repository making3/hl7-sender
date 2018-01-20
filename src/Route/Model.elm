module Route.Model exposing (..)

import Home.Route as Home exposing (Route(..))


type Route
    = RouteHome Home.Route
    | RouteControlCharacters


type alias Model =
    Route


model : Route
model =
    RouteHome Home.RouteHome
