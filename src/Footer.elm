module Footer exposing (..)

import Html exposing (Html, div, footer, hr)
import Html.Attributes exposing (class)
import Main


-- import Connection.View.Log as Log exposing (view)
-- import Connection.View.Connection as Connection exposing (view)
-- import Connection.View.Status as Status exposing (view)
-- import Connection.Msg exposing (..)


type Model =
  {
  }
view : Main.Model -> Html Msg
view model =
    footer
        [ class "footer" ]
        [ --connectionForm model
          separator

        --, statusForm model
        ]


connectionForm : Main.Model -> Html Msg
connectionForm model =
    div [ class "connection-row" ]
        [ div [ class "connection" ] [] --Connection.view model ]
        , div [ class "log" ] (Log.view model)
        ]


separator : Html Main.Msg
separator =
    hr [ class "connection-status-separator" ] []



-- statusForm : Main.Model -> Html Main.Msg
-- statusForm model =
--     div [ class "clearfix" ]
--         [ Status.view model ]
-- UPDATE


type Msg
    = NoOp


update : Msg -> Main.Model -> ( Html Msg, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []
