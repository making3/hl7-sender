port module Settings.Subs exposing (..)


port settingsSaved : (String -> msg) -> Sub msg


port settings : (( String, String ) -> msg) -> Sub msg
