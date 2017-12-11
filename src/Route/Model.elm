module Route.Model exposing (..)


type Route
    = RouteHome
    | RouteControlCharacters


type alias Model =
    Route


model : Route
model =
    RouteControlCharacters



-- TEMP: Reset back to RouteHome
