module Home.Router exposing (..)

import Html exposing (Html)
import Msg exposing (Msg(..))
import Model as Main exposing (Model)
import Home.Route exposing (Route(..))
import Home.View.Home as Home
import Home.View.About as About


render : Main.Model -> Route -> Html Msg
render model internalRoute =
    case internalRoute of
        RouteHome ->
            Home.view model

        RouteAbout ->
            About.view model
