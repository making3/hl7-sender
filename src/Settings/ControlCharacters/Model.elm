module Settings.ControlCharacters.Model exposing (..)

import Json.Encode as Encode exposing (Value, object, int)
import Json.Decode as Decode exposing (Decoder, int, bool)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias Model =
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
    { startOfText = 9
    , endOfText = 45
    , endOfLine = 35
    , pendingUpdate = False
    , tempStartOfText = 9
    , tempEndOfText = 45
    , tempEndOfLine = 35
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
        |> optional "pendingUpdate" Decode.bool False
        |> optional "tempStartOfText" Decode.int 9
        |> optional "tempEndOfText" Decode.int 45
        |> optional "tempEndOfLine" Decode.int 35
