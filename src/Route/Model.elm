module Route.Model exposing (..)


type Route
    = RouteHome
    | RouteControlCharacters
    | RouteAbout


type alias Model =
    Route


model : Route
model =
    RouteHome
