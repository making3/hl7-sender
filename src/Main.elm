module Main exposing (..)

import Html exposing (program)
import Msg as Main exposing (Msg(..))
import Model as Main exposing (Model, initialModel)
import Router exposing (render)
import Update exposing (update)
import Subs as Subs exposing (init)
import Commands as Commands exposing (init)


main : Program Never Model Main.Msg
main =
    program
        { init = init
        , view = render
        , update = update
        , subscriptions = Subs.init
        }


init : ( Model, Cmd Main.Msg )
init =
    ( initialModel, Commands.init initialModel )
