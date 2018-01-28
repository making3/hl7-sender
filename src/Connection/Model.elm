module Connection.Model exposing (..)

import Array exposing (Array, fromList)
import Json.Encode as Encode exposing (encode, Value, object, string, int, array)
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
    , savedConnections : Array Connection
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
        Array.fromList
            [ { name = "Default"
              , destinationIp = "127.0.0.1"
              , destinationPort = 1337
              }
            ]
    , currentSavedConnectionName = "Default"
    }


getCreateNewConnection : Connection
getCreateNewConnection =
    Connection "Create New" "127.0.0.1" 3000


updateSentCount : Model -> Model
updateSentCount model =
    { model | sentCount = model.sentCount + 1 }


toSavedConnectionsJson : Model -> String
toSavedConnectionsJson connection =
    connection.savedConnections
        |> Array.map encodeConnection
        |> Encode.array
        |> Encode.encode 0


encodeConnection : Connection -> Value
encodeConnection connection =
    object
        [ ( "name", Encode.string connection.name )
        , ( "destinationIp", Encode.string connection.destinationIp )
        , ( "destinationPort", Encode.int connection.destinationPort )
        ]


toSavedConnectionsModels : String -> Result String (Array Connection)
toSavedConnectionsModels json =
    Decode.decodeString (Decode.array decodeConnection) json


decodeConnection : Decoder Connection
decodeConnection =
    decode Connection
        |> required "name" Decode.string
        |> required "destinationIp" Decode.string
        |> required "destinationPort" Decode.int
