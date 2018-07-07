module Ports.Connection exposing (..)

import Array exposing (Array, fromList)
import Connection
import Json.Encode as Encode exposing (Value, encode, int, object)
import Ports


get : Connection.Model -> Cmd msg
get connections =
    Ports.getConnections (toSavedConnectionsJson connections)


saveConnection : Connection.Connection -> Cmd msg
saveConnection model =
    model
        |> encodeConnection
        |> Encode.encode 0
        |> Ports.saveConnection


toSavedConnectionsJson : Connection.Model -> String
toSavedConnectionsJson connection =
    connection.savedConnections
        |> Array.map encodeConnection
        |> Encode.array
        |> Encode.encode 0


encodeConnection : Connection.Connection -> Value
encodeConnection connection =
    object
        [ ( "name", Encode.string connection.name )
        , ( "destinationIp", Encode.string connection.destinationIp )
        , ( "destinationPort", Encode.int connection.destinationPort )
        ]
