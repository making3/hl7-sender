module Connection exposing (..)

import Array exposing (Array, fromList)
import List.Extra exposing (updateIf)
import Json.Decode as Decode exposing (Decoder, decodeString, int)
import Json.Decode.Pipeline exposing (decode)


-- MODEL


type alias Model =
    { destinationIp : String
    , destinationPort : Int
    , isConnected : Bool
    , connectionMessage : String
    , sentCount : Int
    , savedConnections : Array Connection
    , currentSavedConnectionName : String
    }


type alias Connection =
    { name : String
    , destinationIp : String
    , destinationPort : Int
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
            [ getDefaultConnection
            ]
    , currentSavedConnectionName = "Default"
    }


getDefaultConnection : Connection
getDefaultConnection =
    Connection "Default" "127.0.0.1" 1337



-- UPDATE


updateSavedConnections : Array Connection -> String -> String -> Int -> Array Connection
updateSavedConnections connections connectionName destinationIp destinationPort =
    let
        updatedConnection =
            { name = connectionName, destinationIp = destinationIp, destinationPort = destinationPort }
    in
        connections
            |> Array.toList
            |> updateIf (\c -> c.name == connectionName) (\c -> updatedConnection)
            |> Array.fromList


getInitialConnectionName : Array Connection -> String
getInitialConnectionName connections =
    case Array.get 0 connections of
        Just connection ->
            connection.name

        Nothing ->
            ""


findConnectionByName : Model -> String -> Maybe Connection
findConnectionByName model connectionName =
    model.savedConnections
        |> Array.toList
        |> List.Extra.find (\c -> c.name == connectionName)


updateConnectionStatus : Model -> Bool -> String -> Model
updateConnectionStatus model isConnected message =
    { model
        | isConnected = isConnected
        , connectionMessage = message
    }



-- SERIALIZATION


toSavedConnectionsModels : String -> Result String (Array Connection)
toSavedConnectionsModels json =
    Decode.decodeString (Decode.array decodeConnection) json


decodeConnection : Decoder Connection
decodeConnection =
    decode Connection
        |> Json.Decode.Pipeline.required "name" Decode.string
        |> Json.Decode.Pipeline.required "destinationIp" Decode.string
        |> Json.Decode.Pipeline.required "destinationPort" Decode.int
