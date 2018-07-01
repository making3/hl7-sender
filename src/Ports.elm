port module Ports exposing (..)

-- COMMANDS


port connect : ( String, Int ) -> Cmd msg


port disconnect : () -> Cmd msg


port send : String -> Cmd msg


port saveConnection : ( String, String, Int ) -> Cmd msg


port versionGet : () -> Cmd msg


loadVersion : Cmd msg
loadVersion =
    versionGet ()


port settingsGet : String -> Cmd msg


port settingsSave : String -> Cmd msg



-- SUBSCRIPTIONS


port connected : (() -> msg) -> Sub msg


port disconnected : (() -> msg) -> Sub msg


port connectionError : (String -> msg) -> Sub msg


port sent : (() -> msg) -> Sub msg


port savedConnection : (String -> msg) -> Sub msg


port savedNewConnection : (String -> msg) -> Sub msg


port initialSavedConnections : (( String, String ) -> msg) -> Sub msg


port menuClick : (String -> msg) -> Sub msg


port version : (String -> msg) -> Sub msg


port settingsSaved : (String -> msg) -> Sub msg


port settings : (( String, String ) -> msg) -> Sub msg
