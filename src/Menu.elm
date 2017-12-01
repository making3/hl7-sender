module Menu exposing (..)

import Msgs exposing (..)
import Models exposing (Model, Route(..))


menuClick : Model -> String -> ( Model, Cmd Msg )
menuClick model menuItem =
    case menuItem of
        "edit-control-characters" ->
            ( { model | route = RouteControlCharacters }, Cmd.none )

        _ ->
            ( { model | route = RouteHome }, Cmd.none )
