module Settings exposing (..)

import ControlCharacters
import Json.Decode as Decode exposing (Decoder, decodeString, int, string)
import Json.Decode.Pipeline exposing (decode, optional, required)


-- MODEL


type alias Model =
    { controlCharacters : ControlCharacters.Model
    , newConnectionName : String
    }


model : Model
model =
    { controlCharacters = ControlCharacters.initialModel
    , newConnectionName = ""
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


decodeControlCharacters : Decoder ControlCharacters.Model
decodeControlCharacters =
    decode ControlCharacters.Model
        |> required "startOfText" Decode.int
        |> required "endOfText" Decode.int
        |> required "endOfLine" Decode.int
        |> optional "pendingUpdate" Decode.bool False
        |> optional "tempStartOfText" Decode.int 9
        |> optional "tempEndOfText" Decode.int 45
        |> optional "tempEndOfLine" Decode.int 35
