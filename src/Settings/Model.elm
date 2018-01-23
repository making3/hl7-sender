module Settings.Model exposing (..)

import Json.Encode exposing (encode, Value, object, int)
import Json.Decode as Decode exposing (Decoder, decodeString, int, string)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Connection.Model as Connection
import Settings.ControlCharacters.Model as ControlCharacters


type alias Model =
    { controlCharacters : ControlCharacters.Model
    , newConnectionName : String
    }


model : Model
model =
    { controlCharacters = ControlCharacters.model
    , newConnectionName = ""
    }


toJson : Model -> String
toJson settings =
    Json.Encode.encode 0 (encode settings)


encode : Model -> Value
encode settings =
    object
        [ ( "controlCharacters"
          , ControlCharacters.encode settings.controlCharacters
          )
        ]


toModel : String -> Result String Model
toModel json =
    Decode.decodeString settingsDecoder json


settingsDecoder : Decoder Model
settingsDecoder =
    decode Model
        |> required "controlCharacters" ControlCharacters.decodeString
        |> optional "newConnectionName" Decode.string ""
