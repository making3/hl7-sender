port module Main exposing (..)

import Html exposing (program)
import Msg as Main exposing (Msg(..))
import Model as Main exposing (Model, initialModel)
import Router exposing (route)
import Update exposing (update)
import Home.Msg as Home exposing (..)
import Route.Msg as Route exposing (..)
import Settings.Msg as Settings exposing (..)
import Connection.Msg as Connection exposing (..)
import Settings.Ports as Settings exposing (get)
import Home.Ports as Home exposing (loadVersion)


main : Program Never Model Main.Msg
main =
    program
        { init = init
        , view = route
        , update = update
        , subscriptions = subscriptions
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



-- TODO: Preferably move these to their specific domains


port menuClick : (String -> msg) -> Sub msg


port settingsSaved : (String -> msg) -> Sub msg


port settings : (( String, String ) -> msg) -> Sub msg


port connected : (() -> msg) -> Sub msg


port disconnected : (() -> msg) -> Sub msg


port connectionError : (String -> msg) -> Sub msg


port sent : (() -> msg) -> Sub msg


port version : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Main.Msg
subscriptions model =
    Sub.batch
        [ menuClick (MsgForRoute << MenuClick)
        , settingsSaved (MsgForSettings << Saved)
        , settings (MsgForSettings << InitialSettings)
        , connected (MsgForConnection << (always Connected))
        , disconnected (MsgForConnection << (always Disconnected))
        , connectionError (MsgForConnection << ConnectionError)
        , sent (MsgForConnection << always Sent)
        , version (MsgForHome << Version)
        ]
