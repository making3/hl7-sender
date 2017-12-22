module Model exposing (..)

import Task
import Dom.Scroll
import Msg exposing (..)
import Home.Model as Home
import Route.Model as Route
import Connection.Model as Connection
import Settings.Model as Settings


type alias Model =
    { home : Home.Model
    , logs : List String
    , route : Route.Model
    , connection : Connection.Model
    , settings : Settings.Model
    }


initialModel : Model
initialModel =
    { home = Home.model
    , logs = []
    , route = Route.model
    , connection = Connection.model
    , settings = Settings.model
    }


log : String -> String -> Model -> ( Model, Cmd Msg )
log level message model =
    ( { model | logs = (message :: model.logs) }, scrollLogsToBottom )


scrollLogsToBottom : Cmd Msg
scrollLogsToBottom =
    Task.attempt (always NoOp) <| Dom.Scroll.toBottom "logs"
