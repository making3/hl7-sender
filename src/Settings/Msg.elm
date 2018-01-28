module Settings.Msg exposing (..)

import Settings.ControlCharacters.Msg as ControlCharacters


type Msg
    = Saved String
    | InitialSettings ( String, String )
    | GetSettings
    | SaveSettings
    | MsgForControlCharacters ControlCharacters.Msg
    | UpdateNewConnectionName String
