module Route.Model exposing (..)

import Home.Route as Home exposing (Route(..))
import Settings.Route as Settings exposing (Route(..))


type Route
    = RouteHome Home.Route
    | RouteSettings Settings.Route


type alias Model =
    Route


model : Route
model =
    RouteHome Home.RouteHome
