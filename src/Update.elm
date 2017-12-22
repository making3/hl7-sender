module Update exposing (..)

import Msg exposing (..)
import Model exposing (Model)
import Home.Update as Home
import Route.Update as Route
import Connection.Update as Connection
import Settings.Update as Settings
import Settings.ControlCharacters.Update as ControlCharacters


update : Msg -> Model -> ( Model, Cmd Msg )
update msgFor model =
    case msgFor of
        MsgForHome msg ->
            Home.update msg model

        MsgForRoute msg ->
            Route.update msg model

        MsgForSettings msg ->
            Settings.update msg model

        MsgForConnection msg ->
            Connection.update msg model

        _ ->
            ( model, Cmd.none )
