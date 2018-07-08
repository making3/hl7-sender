module AddConnection exposing (..)

import Connection exposing (Model)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Utilities
import View.Controls.FormInput exposing (viewBasicInput)
import View.Layout.Modal as Layout exposing (view)
import TCP


-- MODEL


init =
    { name = ""
    , destinationIp = ""
    , destinationPort = 9000
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
        model.name
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
        (Utilities.getPortDisplay model.destinationPort)
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
            , disabled (model.name == "")
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
            { model | name = name } ! []

        ChangeDestinationIp ip ->
            { model | destinationIp = ip } ! []

        ChangeDestinationPort newPortStr ->
            changeDestinationPort model newPortStr

        _ ->
            model ! []


changeDestinationPort : Model -> String -> ( Model, Cmd Msg )
changeDestinationPort connection newPortStr =
    case TCP.validatePort newPortStr of
        TCP.ValidPort validatedPort ->
            updatePort connection validatedPort ! []

        TCP.EmptyPort ->
            updatePort connection 0 ! []

        TCP.InvalidPort ->
            connection ! []


updatePort connection newPort =
    { connection | destinationPort = clamp 1 65535 newPort }
