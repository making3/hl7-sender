port module Home.Commands exposing (..)

import Msg exposing (..)


port versionGet : () -> Cmd msg


loadVersion : Cmd Msg
loadVersion =
    versionGet ()
