module Settings exposing (..)

import ControlCharacters
import Json.Decode as Decode exposing (Decoder, decodeString, int, string)
import Json.Decode.Pipeline exposing (decode, optional, required)


-- MODEL


type alias Model =
    { controlCharacters : ControlCharacters.Model
    }


model : Model
model =
    { controlCharacters = ControlCharacters.init
    }



-- SERIALIZATION


toModel : String -> Result String Model
toModel json =
    Decode.decodeString settingsDecoder json


settingsDecoder : Decoder Model
settingsDecoder =
    decode Model
        |> required "controlCharacters" decodeControlCharacters


decodeControlCharacters : Decoder ControlCharacters.Model
decodeControlCharacters =
    decode ControlCharacters.Model
        |> required "startOfText" Decode.int
        |> required "endOfText" Decode.int
        |> required "endOfLine" Decode.int
