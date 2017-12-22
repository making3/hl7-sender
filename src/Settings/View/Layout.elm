module Settings.View.Layout exposing (..)

import Html exposing (Html, div, h3, button, hr, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Msg as Main exposing (..)
import Route.Msg as Route exposing (..)
import View.Layout.Modal as Layout exposing (view)


view : String -> Html Main.Msg -> Html Main.Msg
view title content =
    Layout.view ("Settings - " ++ title) content
