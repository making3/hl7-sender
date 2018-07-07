module AddConnection exposing (..)

import Connection exposing (Connection)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Utilities
import View.Controls.FormInput exposing (viewBasicInput)
import View.Layout.Modal as Layout exposing (view)


-- MODEL


init =
    { name = ""
    , destinationIp = ""
    , destinationPort = 9000
    }



-- VIEW


view : Connection -> Html Msg
view model =
    Layout.view "Settings - Save New Connection" (viewForm model) Exit


viewForm : Connection -> Html Msg
viewForm model =
    div [ class "basic-form" ]
        [ viewName model
        , viewIpAddress model
        , viewPort model
        , viewActionButtons model
        ]


viewName : Connection -> Html Msg
viewName model =
    viewBasicInput
        "Connection Name"
        model.name
        "Connection"
        UpdateNewConnectionName


viewIpAddress : Connection -> Html Msg
viewIpAddress model =
    viewBasicInput
        "IP Address"
        model.destinationIp
        "IP Address"
        ChangeDestinationIp


viewPort : Connection -> Html Msg
viewPort model =
    viewBasicInput
        "Port"
        (Utilities.getPortDisplay model.destinationPort)
        "Port"
        ChangeDestinationPort


viewActionButtons : Connection -> Html Msg
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


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


update : Msg -> Connection -> ( Connection, Cmd Msg )
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


changeDestinationPort : Connection -> String -> ( Connection, Cmd Msg )
changeDestinationPort connection newPortStr =
    case validatePort newPortStr of
        ValidPort validatedPort ->
            updatePort connection validatedPort ! []

        EmptyPort ->
            updatePort connection 0 ! []

        InvalidPort ->
            connection ! []


validatePort : String -> PortValidation
validatePort portStr =
    if portStr == "" then
        EmptyPort
    else
        case String.toInt portStr of
            Ok newPort ->
                ValidPort newPort

            Err _ ->
                InvalidPort


updatePort connection newPort =
    { connection | destinationPort = clamp 1 65535 newPort }
