port module Connection.Ports exposing (..)


port connect : ( String, Int ) -> Cmd msg


port disconnect : () -> Cmd msg


port send : String -> Cmd msg


port saveConnection : ( String, String, Int ) -> Cmd msg
