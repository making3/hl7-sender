module Connection.Msg exposing (..)


type Msg
    = ToggleConnection
    | Send
    | Sent
    | Connected
    | Disconnected
    | ClearLog
    | ConnectionError String
    | ChangeDestinationIp String
    | ChangeDestinationPort String
    | ChangeSavedConnection String


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp
