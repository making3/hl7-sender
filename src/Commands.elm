module Commands exposing (..)

import Msg exposing (..)
import Model as Main exposing (Model)


-- Commands

import Settings.Commands as Settings exposing (get)
import Home.Commands as Home exposing (loadVersion)
import Connection.Commands as Connection exposing (get)


init : Model -> Cmd Msg
init model =
    Cmd.batch
        [ Settings.get model.settings
        , Home.loadVersion
        , Connection.get model.connection
        ]
