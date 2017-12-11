module View exposing (..)

import Html exposing (Html, Attribute, program, div, span, input, button, text, label, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msg exposing (Msg(..))
import Model as Main exposing (Model)
import Home.View.Home as Home
import Home.Model exposing (Model)
import Route.Model as Route exposing (Route)
import Settings.ControlCharacters.View.ControlCharacters as ControlCharacters


view : Main.Model -> Html Msg
view model =
    page model


page : Main.Model -> Html Msg
page model =
    case model.route of
        Route.RouteHome ->
            Home.view model

        Route.RouteControlCharacters ->
            ControlCharacters.view model.settings
