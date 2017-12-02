module Home.Update exposing (..)

import Msg as Main exposing (..)
import Home.Model exposing (Model)
import Home.Msg as Home exposing (..)


update : Main.Msg -> Model -> Model
update msgFor home =
    case msgFor of
        MsgForHome msg ->
            updateHome msg home

        _ ->
            home


updateHome : Home.Msg -> Model -> Model
updateHome msg model =
    case msg of
        ChangeHl7 newHl7 ->
            { model | hl7 = newHl7 }
