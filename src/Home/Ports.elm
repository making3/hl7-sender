port module Home.Ports exposing (..)

import Msg exposing (..)


port versionGet : () -> Cmd msg


loadVersion : Cmd Msg
loadVersion =
    versionGet ()
