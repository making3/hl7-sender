module Home.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Home.Model as Home exposing (Model)
import Home.Msg as Home exposing (..)


update : Home.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        ChangeHl7 hl7 ->
            ( updateHl7 model hl7, Cmd.none )

        Version version ->
            ( updateVersion model version, Cmd.none )


updateHl7 : Main.Model -> String -> Main.Model
updateHl7 model newHl7 =
    let
        home =
            model.home

        newHome =
            { home | hl7 = newHl7 }
    in
        { model | home = newHome }


updateVersion : Main.Model -> String -> Main.Model
updateVersion model version =
    let
        home =
            model.home

        newHome =
            { home | version = version }
    in
        { model | home = newHome }
