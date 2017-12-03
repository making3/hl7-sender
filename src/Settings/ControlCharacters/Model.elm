module Settings.ControlCharacters.Model exposing (..)

import Json.Encode as Encode exposing (Value, object, int)
import Json.Decode as Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (decode, required)


type alias Model =
    { startOfText : Int
    , endOfText : Int
    , endOfLine : Int
    }


model : Model
model =
    { startOfText = 9
    , endOfText = 45
    , endOfLine = 35
    }


encode : Model -> Value
encode controlCharacters =
    object
        [ ( "startOfText", Encode.int controlCharacters.startOfText )
        , ( "endOfText", Encode.int controlCharacters.endOfText )
        , ( "endOfLine", Encode.int controlCharacters.endOfLine )
        ]


decodeString : Decoder Model
decodeString =
    decode Model
        |> required "startOfText" Decode.int
        |> required "endOfText" Decode.int
        |> required "endOfLine" Decode.int
