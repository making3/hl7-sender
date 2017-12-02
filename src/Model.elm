module Model exposing (..)

import Home.Model as Home
import Route.Model as Route
import Connection.Model as Connection
import Settings.Model as Settings


type alias Model =
    { home : Home.Model
    , route : Route.Model
    , connection : Connection.Model
    , settings : Settings.Model
    }


initialModel : Model
initialModel =
    { home = Home.model
    , route = Route.model
    , connection = Connection.model
    , settings = Settings.model
    }
