port module Main exposing (..)

import Html exposing (program)
import Msgs exposing (Msg(..))
import Models exposing (Model, initialModel)
import View exposing (view)
import Update exposing (update)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- SUBS
-- Since Elm doesn't allow functions without parameters, just use empty strings


port menuClick : (String -> msg) -> Sub msg


port connected : (String -> msg) -> Sub msg


port connectionError : (String -> msg) -> Sub msg


port disconnected : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ menuClick MenuClick
        , connected Connected
        , connectionError ConnectionError
        , disconnected Disconnected
        ]
