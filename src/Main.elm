module Main exposing (..)

import Html exposing (program)
import Msg as Main exposing (Msg(..))
import Model as Main exposing (Model, initialModel)
import Router exposing (route)
import Update exposing (update)
import Subs as Subs exposing (init)


-- Commands

import Settings.Ports as Settings exposing (get)
import Home.Ports as Home exposing (loadVersion)


main : Program Never Model Main.Msg
main =
    program
        { init = init
        , view = route
        , update = update
        , subscriptions = Subs.init
        }


init : ( Model, Cmd Main.Msg )
init =
    ( initialModel, initialCommands )


initialCommands : Cmd Main.Msg
initialCommands =
    Cmd.batch
        [ Settings.get initialModel.settings
        , Home.loadVersion
        ]
