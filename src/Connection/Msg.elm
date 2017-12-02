module Connection.Msg exposing (..)


type Msg
    = ToggleConnection
    | Send
    | Connected
    | Disconnected
    | ConnectionError String
    | ChangeDestinationIp String
    | ChangeDestinationPort String


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp
