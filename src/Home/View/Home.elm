module Home.View.Home exposing (..)

import Html exposing (Html, Attribute, program, div, span, input, button, text, label, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Msg as Main exposing (..)
import Model as Main
import Home.Model as Home
import Home.Msg as Home exposing (..)
import Connection.Msg exposing (..)
import Connection.View.Footer as Connection exposing (..)


view : Main.Model -> Html Main.Msg
view model =
    div []
        [ div [ class "container-fluid form-group" ]
            [ label []
                [ text "HL7 Message"
                ]
            , textarea
                [ class "form-control"
                , onInput (MsgForHome << ChangeHl7)
                , rows 8
                ]
                []
            ]
        , div [ class "container-fluid float-right" ]
            [ button
                [ class "btn btn-primary"
                , onClick (MsgForConnection Send)
                , disabled (model.connection.isConnected == False)
                ]
                [ text "Send"
                ]
            ]
        , Html.br [] [] --TEMP
        , Html.br [] []
        , Connection.view model
        ]
