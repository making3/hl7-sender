module AddConnection exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import View.Controls.FormInput exposing (viewBasicInput)
import View.Layout.Modal as Layout exposing (view)
import Utilities


-- MODEL


type alias Model =
    { connectionName : String
    , destinationIp : String
    , destinationPort : String
    }


init =
    { connectionName = ""
    , destinationIp = ""
    , destinationPort = "9000"
    }



-- VIEW


view : Model -> Html Msg
view model =
    Layout.view "Settings - Save New Connection" (viewForm model) Exit


viewForm : Model -> Html Msg
viewForm model =
    div [ class "basic-form" ]
        [ viewName model
        , viewIpAddress model
        , viewPort model
        , viewActionButtons model
        ]


viewName : Model -> Html Msg
viewName model =
    viewBasicInput
        "Connection Name"
        model.connectionName
        "Connection"
        UpdateNewConnectionName


viewIpAddress : Model -> Html Msg
viewIpAddress model =
    viewBasicInput
        "IP Address"
        model.destinationIp
        "IP Address"
        ChangeDestinationIp


viewPort : Model -> Html Msg
viewPort model =
    viewBasicInput
        "Port"
        -- (Utilities.getPortDisplay model.destinationPort)
        model.destinationPort
        "Port"
        ChangeDestinationPort


viewActionButtons : Model -> Html Msg
viewActionButtons model =
    div [ class "save-connection-buttons" ]
        [ button
            [ class "btn btn-primary"
            , onClick Exit
            ]
            [ text "Go Home" ]
        , button
            [ class "btn btn-primary"
            , onClick SaveConnection
            , disabled (model.connectionName == "")
            ]
            [ text "Save" ]
        ]



-- UPDATE


type Msg
    = SaveConnection
    | Exit
    | UpdateNewConnectionName String
    | ChangeDestinationIp String
    | ChangeDestinationPort String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SaveConnection ->
            model ! []

        UpdateNewConnectionName name ->
            { model | connectionName = name } ! []

        ChangeDestinationIp ip ->
            { model | destinationIp = ip } ! []

        ChangeDestinationPort newPort ->
            { model | destinationPort = newPort } ! []

        _ ->
            model ! []
