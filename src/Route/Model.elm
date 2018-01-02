module Route.Model exposing (..)


type Route
    = RouteHome
    | RouteControlCharacters
    | RouteAbout
    | RouteSaveConnection


type alias Model =
    Route


model : Route
model =
    RouteHome
