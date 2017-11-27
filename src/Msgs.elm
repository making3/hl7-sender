module Msgs exposing (..)

import Models exposing (ControlCharacters)


type Msg
    = ToggleConnection
    | Send
    | Connected String
    | ConnectionError String
    | Disconnected String
    | ChangeHl7 String
    | ChangeDestinationIp String
    | ChangeDestinationPort String
    | EditControlCharacters
      -- | SaveControlCharacters
    | GoHome
    | UpdateStartOfText String
    | UpdateEndOfText String
    | UpdateEndOfLine String


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp
