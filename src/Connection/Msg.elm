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
    | SaveConnection
    | SavedConnection String
    | InitialSavedConnections ( String, String )


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp
