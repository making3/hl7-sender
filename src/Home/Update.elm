module Home.Update exposing (..)

import Msg as Main exposing (..)
import Model as Main exposing (..)
import Home.Model as Home exposing (Model)
import Home.Msg as Home exposing (..)


update : Home.Msg -> Main.Model -> ( Main.Model, Cmd Main.Msg )
update msg model =
    case msg of
        ChangeHl7 newHl7 ->
            ( { model | home = updateHl7 model.home newHl7 }, Cmd.none )


updateHl7 : Home.Model -> String -> Home.Model
updateHl7 home newHl7 =
    { home | hl7 = newHl7 }
