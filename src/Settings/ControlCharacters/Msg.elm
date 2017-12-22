module Settings.ControlCharacters.Msg exposing (..)


type Msg
    = UpdateStartOfText String
    | UpdateEndOfText String
    | UpdateEndOfLine String
    | SaveControlCharacters
    | ResetControlCharacters
