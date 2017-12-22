module View.Layout.Primary exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Html exposing (Html, div)
import Connection.View.Footer as Connection exposing (view)


view : Model -> Html Msg -> Html Msg
view model primaryView =
    div []
        [ primaryView
        , Connection.view model
        ]
