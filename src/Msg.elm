module Msg exposing (..)

import Home.Msg as Home
import Route.Msg as Route
import Connection.Msg as Connection
import Settings.ControlCharacters.Msg as ControlCharacters


type Msg
    = MsgForHome Home.Msg
    | MsgForRoute Route.Msg
    | MsgForConnection Connection.Msg
    | MsgForControlCharacters ControlCharacters.Msg
