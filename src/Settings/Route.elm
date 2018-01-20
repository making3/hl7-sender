module Settings.Route exposing (..)

import Settings.ControlCharacters.Route as ControlCharacters exposing (Route)


type Route
    = RouteControlCharacters ControlCharacters.Route
