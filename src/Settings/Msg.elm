module Settings.Msg exposing (..)


type Msg
    = Saved String
    | InitialSettings ( String, String )
    | GetSettings
    | SaveSettings
