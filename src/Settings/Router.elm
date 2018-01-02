module Settings.Router exposing (..)

import Model as Main exposing (Model)
import Route.Model as Route exposing (..)
import Settings.ControlCharacters.Router as ControlCharacters exposing (route)


route : Main.Model -> Main.Model
route model =
    { model
        | settings = ControlCharacters.route model.settings
        , route = Route.RouteControlCharacters
    }
