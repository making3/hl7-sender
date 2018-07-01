module Settings exposing (..)

import Json.Decode as Decode exposing (Decoder, decodeString, int, string)
import Json.Decode.Pipeline exposing (decode, optional, required)


type alias Model =
    { controlCharacters : ControlCharactersModel
    , newConnectionName : String
    }


type alias ControlCharactersModel =
    { startOfText : Int
    , endOfText : Int
    , endOfLine : Int
    , pendingUpdate : Bool
    , tempStartOfText : Int
    , tempEndOfText : Int
    , tempEndOfLine : Int
    }


model : Model
model =
    { controlCharacters = initialControlCharacters
    , newConnectionName = ""
    }


initialControlCharacters : ControlCharactersModel
initialControlCharacters =
    { startOfText = 9
    , endOfText = 45
    , endOfLine = 35
    , pendingUpdate = False
    , tempStartOfText = 9
    , tempEndOfText = 45
    , tempEndOfLine = 35
    }



-- SERIALIZATION


toModel : String -> Result String Model
toModel json =
    Decode.decodeString settingsDecoder json


settingsDecoder : Decoder Model
settingsDecoder =
    decode Model
        |> required "controlCharacters" decodeControlCharacters
        |> optional "newConnectionName" Decode.string ""


decodeControlCharacters : Decoder ControlCharactersModel
decodeControlCharacters =
    decode ControlCharactersModel
        |> required "startOfText" Decode.int
        |> required "endOfText" Decode.int
        |> required "endOfLine" Decode.int
        |> optional "pendingUpdate" Decode.bool False
        |> optional "tempStartOfText" Decode.int 9
        |> optional "tempEndOfText" Decode.int 45
        |> optional "tempEndOfLine" Decode.int 35
