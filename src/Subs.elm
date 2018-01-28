module Subs exposing (..)

import Msg as Main exposing (..)
import Model exposing (Model)
import Home.Msg as Home exposing (..)
import Route.Msg as Route exposing (..)
import Settings.Msg as Settings exposing (..)
import Connection.Msg as Connection exposing (..)


-- Subs

import Home.Subs exposing (..)
import Route.Subs exposing (..)
import Settings.Subs exposing (..)
import Connection.Subs exposing (..)


init : Model -> Sub Main.Msg
init model =
    Sub.batch
        [ menuClick (MsgForRoute << MenuClick)
        , settingsSaved (MsgForSettings << Saved)
        , settings (MsgForSettings << InitialSettings)
        , connected (MsgForConnection << (always Connected))
        , disconnected (MsgForConnection << (always Disconnected))
        , connectionError (MsgForConnection << ConnectionError)
        , sent (MsgForConnection << always Sent)
        , version (MsgForHome << Version)
        , savedConnection (MsgForConnection << SavedConnection)
        , savedNewConnection (MsgForConnection << SavedNewConnection)
        , initialSavedConnections (MsgForConnection << InitialSavedConnections)
        ]
