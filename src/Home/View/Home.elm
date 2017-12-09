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
        [ div [ class "simple-sender" ]
            [ label [] [ text "HL7 Message" ]
            , simpleSenderButtons model
            , textarea
                [ class "form-control"
                , onInput (MsgForHome << ChangeHl7)
                , rows 8
                ]
                []
            ]
        , Connection.view model
        ]


simpleSenderButtons : Main.Model -> Html Main.Msg
simpleSenderButtons model =
    div [ class "float-right" ]
        [ button
            [ class "validate btn btn-sm btn-primary"
            , disabled True
            ]
            [ text "Validate" ]
        , button
            [ class "btn btn-sm btn-primary"
            , onClick (MsgForConnection Send)
            , disabled (model.connection.isConnected == False)
            ]
            [ text "Send" ]
        ]
