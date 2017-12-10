module Model exposing (..)

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


log : Model -> String -> String -> Model
log model level message =
    { model | logs = (message :: model.logs) }
