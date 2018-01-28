module Connection.HL7 exposing (..)

import Char exposing (fromCode)
import Model as Main exposing (Model)


getWrappedHl7 : Main.Model -> String
getWrappedHl7 model =
    getCharStringFromDecimal model.settings.controlCharacters.startOfText
        ++ getStringWithCarriageReturns (model.home.hl7)
        ++ getCharStringFromDecimal model.settings.controlCharacters.endOfLine
        ++ getCharStringFromDecimal model.settings.controlCharacters.endOfText


getStringWithCarriageReturns : String -> String
getStringWithCarriageReturns str =
    str
        |> String.split "\n"
        |> String.join "\x0D"


getCharStringFromDecimal : Int -> String
getCharStringFromDecimal decimalCode =
    String.fromChar (Char.fromCode decimalCode)
