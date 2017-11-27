module View exposing (..)

import Html exposing (Html, Attribute, program, div, span, input, button, text, label, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msgs exposing (Msg(..))
import Models exposing (Model, Route(..))
import ControlCharacters
import Home.Main


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        RouteHome ->
            Home.Main.view model

        RouteControlCharacters ->
            ControlCharacters.view model
