module Route.Menu exposing (..)

import Route.Model exposing (..)


menuClick : Model -> String -> Model
menuClick model menuItem =
    case menuItem of
        "edit-control-characters" ->
            RouteControlCharacters

        _ ->
            RouteHome
