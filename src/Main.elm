port module Main exposing (..)

import Html exposing (program)
import Msg as Main exposing (Msg(..))
import Model as Main exposing (Model, initialModel)
import View exposing (view)
import Update exposing (updateWithCmd)
import Route.Msg as Route exposing (..)
import Settings.Msg as Settings exposing (..)
import Settings.Update as Settings exposing (updateCmd)
import Connection.Msg as Connection exposing (..)


main : Program Never Model Main.Msg
main =
    program
        { init = init
        , view = view
        , update = updateWithCmd
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Main.Msg )
init =
    ( initialModel, Settings.updateCmd (Main.MsgForSettings Settings.GetSettings) initialModel )



-- TODO: Preferably move these to their specific domains


port menuClick : (String -> msg) -> Sub msg


port settingsSaved : (String -> msg) -> Sub msg


port settings : (( String, String ) -> msg) -> Sub msg


port connected : (() -> msg) -> Sub msg


port disconnected : (() -> msg) -> Sub msg


port connectionError : (String -> msg) -> Sub msg


port sent : (() -> msg) -> Sub msg


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
        ]
