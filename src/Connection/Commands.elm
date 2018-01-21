port module Connection.Commands exposing (..)

import Msg as Main exposing (..)
import Connection.Model as Connection exposing (Model, toSavedConnectionsJson)


port getConnections : String -> Cmd msg


get : Connection.Model -> Cmd Main.Msg
get connections =
    getConnections (toSavedConnectionsJson connections)
