module Home.Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg(..))
import Model as Main exposing (Model)
import Route.Model as Root exposing (Route)
import Home.Route as Home exposing (Route)
import Home.View.Home as Home
import Home.View.About as About


route : Main.Model -> String -> Main.Model
route model route =
    case route of
        "about" ->
            { model | route = Root.RouteHome Home.RouteAbout }

        _ ->
            { model | route = Root.RouteHome Home.RouteHome }


render : Main.Model -> Home.Route -> Html Msg
render model internalRoute =
    case internalRoute of
        Home.RouteHome ->
            Home.view model

        Home.RouteAbout ->
            About.view model
