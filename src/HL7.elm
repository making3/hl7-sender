module HL7 exposing (..)

import Char
import ControlCharacters


getWrappedHl7 : ControlCharacters.Model -> String -> String
getWrappedHl7 controlCharacters hl7 =
    getCharStringFromDecimal controlCharacters.startOfText
        ++ getStringWithCarriageReturns hl7
        ++ getCharStringFromDecimal controlCharacters.endOfLine
        ++ getCharStringFromDecimal controlCharacters.endOfText


getStringWithCarriageReturns : String -> String
getStringWithCarriageReturns str =
    str
        |> String.split "\n"
        |> String.join "\x0D"


getCharStringFromDecimal : Int -> String
getCharStringFromDecimal decimalCode =
    String.fromChar (Char.fromCode decimalCode)
