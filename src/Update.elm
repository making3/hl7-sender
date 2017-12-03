module Update exposing (..)

import Msg exposing (..)
import Model exposing (Model)
import Home.Update as Home
import Route.Update as Route
import Connection.Update as Connection
import Settings.Update as Settings
import Settings.ControlCharacters.Update as ControlCharacters


updateWithCmd : Msg -> Model -> ( Model, Cmd Msg )
updateWithCmd msg model =
    ( update msg model, updateCmd msg model )


update : Msg -> Model -> Model
update msg model =
    { model
        | home = Home.update msg model.home
        , route = Route.update msg model.route
        , connection = Connection.update msg model.connection
        , settings = Settings.update msg model.settings
    }


updateCmd : Msg -> Model -> Cmd Msg
updateCmd msg model =
    Cmd.batch
        [ Connection.updateCmd msg model
        , Settings.updateCmd msg model
        ]
