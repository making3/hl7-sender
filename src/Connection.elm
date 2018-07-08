module Connection exposing (..)

import Array exposing (Array, fromList)
import List.Extra exposing (updateIf)
import Json.Decode as Decode exposing (Decoder, decodeString, int)
import Json.Decode.Pipeline exposing (decode)


-- MODEL


type alias Model =
    { name : String
    , destinationIp : String
    , destinationPort : Int
    }


model : Model
model =
    Model "Default" "127.0.0.1" 1337



-- UPDATE


updateSavedConnections : Array Model -> String -> String -> Int -> Array Model
updateSavedConnections connections connectionName destinationIp destinationPort =
    let
        updatedConnection =
            { name = connectionName, destinationIp = destinationIp, destinationPort = destinationPort }
    in
        connections
            |> Array.toList
            |> updateIf (\c -> c.name == connectionName) (\c -> updatedConnection)
            |> Array.fromList


getInitialConnectionName : Array Model -> String
getInitialConnectionName connections =
    case Array.get 0 connections of
        Just connection ->
            connection.name

        Nothing ->
            ""


findConnectionByName : Array Model -> String -> Maybe Model
findConnectionByName savedConnections connectionName =
    savedConnections
        |> Array.toList
        |> List.Extra.find (\c -> c.name == connectionName)



-- SERIALIZATION


toSavedConnectionsModels : String -> Result String (Array Model)
toSavedConnectionsModels json =
    Decode.decodeString (Decode.array decodeConnection) json


decodeConnection : Decoder Model
decodeConnection =
    decode Model
        |> Json.Decode.Pipeline.required "name" Decode.string
        |> Json.Decode.Pipeline.required "destinationIp" Decode.string
        |> Json.Decode.Pipeline.required "destinationPort" Decode.int
