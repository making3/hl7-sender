module Model exposing (..)

import Home.Model as Home
import Route.Model as Route
import Connection.Model as Connection
import Settings.ControlCharacters.Model as ControlCharacters


type alias Model =
    { home : Home.Model
    , route : Route.Model
    , connection : Connection.Model
    , controlCharacters : ControlCharacters.Model
    }


initialModel : Model
initialModel =
    { home = Home.model
    , route = Route.model
    , connection = Connection.model
    , controlCharacters = ControlCharacters.model
    }
