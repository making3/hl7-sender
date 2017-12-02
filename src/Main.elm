port module Main exposing (..)

import Html exposing (program)
import Msg as Main exposing (Msg(..))
import Model as Main exposing (Model, initialModel)
import View exposing (view)
import Update exposing (updateWithCmd)
import Route.Msg as Route exposing (..)
import Connection.Msg as Connection exposing (..)


main : Program Never Model Main.Msg
main =
    program
        { init = init
        , view = view
        , update = updateWithCmd
        , subscriptions = subscriptions
        }



-- MODEL


init : ( Model, Cmd Main.Msg )
init =
    ( initialModel, Cmd.none )



-- SUBS


port menuClick : (String -> msg) -> Sub msg


port connected : (() -> msg) -> Sub msg


port disconnected : (() -> msg) -> Sub msg


port connectionError : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Main.Msg
subscriptions model =
    Sub.batch
        [ menuClick (MsgForRoute << MenuClick)
        , connected (MsgForConnection << (always Connected))
        , disconnected (MsgForConnection << (always Disconnected))
        , connectionError (MsgForConnection << ConnectionError)
        ]
