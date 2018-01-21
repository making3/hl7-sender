module Connection.Model exposing (..)

import Json.Encode as Encode exposing (encode, Value, object, string, int, list)
import Json.Decode as Decode exposing (Decoder, decodeString, int)
import Json.Decode.Pipeline exposing (decode, required)


type alias Connection =
    { name : String
    , destinationIp : String
    , destinationPort : Int
    }


type alias Model =
    { destinationIp : String
    , destinationPort : Int
    , isConnected : Bool
    , connectionMessage : String
    , sentCount : Int
    , savedConnections : List Connection
    , currentSavedConnectionName : String
    }


model : Model
model =
    { destinationIp = "127.0.0.1"
    , destinationPort = 1337
    , isConnected = False
    , connectionMessage = "Disconnected"
    , sentCount = 0
    , savedConnections =
        [ { name = "Default"
          , destinationIp = "127.0.0.1"
          , destinationPort = 1337
          }
        ]
    , currentSavedConnectionName = "Default"
    }


updateSentCount model =
    { model | sentCount = model.sentCount + 1 }


toSavedConnectionsJson : Model -> String
toSavedConnectionsJson connection =
    connection.savedConnections
        |> List.map encodeConnection
        |> Encode.list
        |> Encode.encode 0


encodeConnection : Connection -> Value
encodeConnection connection =
    object
        [ ( "name", Encode.string connection.name )
        , ( "destinationIp", Encode.string connection.destinationIp )
        , ( "destinationPort", Encode.int connection.destinationPort )
        ]


toSavedConnectionsModels : String -> Result String (List Connection)
toSavedConnectionsModels json =
    Decode.decodeString (Decode.list decodeConnection) json


decodeConnection : Decoder Connection
decodeConnection =
    decode Connection
        |> required "name" Decode.string
        |> required "destinationIp" Decode.string
        |> required "destinationPort" Decode.int
