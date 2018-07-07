module TCP exposing (..)


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp


validatePort : String -> PortValidation
validatePort portStr =
    if portStr == "" then
        EmptyPort
    else
        case String.toInt portStr of
            Ok newPort ->
                ValidPort newPort

            Err _ ->
                InvalidPort


validateIp : String -> IpValidation
validateIp ip =
    ValidIp
