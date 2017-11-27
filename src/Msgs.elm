module Msgs exposing (..)


type Msg
    = ToggleConnection
    | Send
    | Connected String
    | ConnectionError String
    | Disconnected String
    | ChangeHl7 String
    | ChangeDestinationIp String
    | ChangeDestinationPort String


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp
