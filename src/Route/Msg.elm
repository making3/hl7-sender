module Route.Msg exposing (..)

import Settings.Route as Settings exposing (Route)


type Msg
    = GoHome
    | MenuClick String
    | RouteForSettings Settings.Route
