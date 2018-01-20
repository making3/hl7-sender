module Update exposing (..)

import Msg exposing (Msg(..))
import Model exposing (Model)
import Home.Update as Home exposing (update)
import Route.Update as Route exposing (update)
import Connection.Update as Connection exposing (update)
import Settings.Update as Settings exposing (update)


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

        NoOp ->
            ( model, Cmd.none )
