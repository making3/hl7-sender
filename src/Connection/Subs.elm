port module Connection.Subs exposing (..)


port connected : (() -> msg) -> Sub msg


port disconnected : (() -> msg) -> Sub msg


port connectionError : (String -> msg) -> Sub msg


port sent : (() -> msg) -> Sub msg


port savedConnection : (String -> msg) -> Sub msg


port savedNewConnection : (String -> msg) -> Sub msg


port initialSavedConnections : (( String, String ) -> msg) -> Sub msg
