module Commands exposing (..)

import Msg exposing (..)
import Model as Main exposing (Model)


-- Commands

import Settings.Ports as Settings exposing (get)
import Home.Ports as Home exposing (loadVersion)


init : Model -> Cmd Msg
init model =
    Cmd.batch
        [ Settings.get model.settings
        , Home.loadVersion
        ]
