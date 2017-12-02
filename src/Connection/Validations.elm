module Connection.Validations exposing (..)

import Connection.Msg exposing (..)


-- TODO: Validate port range (1-65535)


validateIp : String -> IpValidation
validateIp ip =
    ValidIp


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
