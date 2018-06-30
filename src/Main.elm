module Main exposing (..)

import Array exposing (Array, fromList)
import Dom.Scroll
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task


init : ( Model, Cmd Msg )
init =
    model ! []



-- MODEL


type alias Model =
    { hl7 : String
    , version : String
    , logs : List String

    -- , route : Route.Model
    , connection : ConnectionModel

    -- , settings : Settings.Model
    }


type alias ConnectionModel =
    { destinationIp : String
    , destinationPort : Int
    , isConnected : Bool
    , connectionMessage : String
    , sentCount : Int
    , savedConnections : Array Connection
    , currentSavedConnectionName : String
    }


type alias Connection =
    { name : String
    , destinationIp : String
    , destinationPort : Int
    }


model : Model
model =
    { hl7 = ""
    , version = "N/A"
    , logs = []

    -- , route = Route.model
    , connection = initialConnectionModel

    -- , settings = Settings.model
    }


initialConnectionModel : ConnectionModel
initialConnectionModel =
    { destinationIp = "127.0.0.1"
    , destinationPort = 1337
    , isConnected = False
    , connectionMessage = "Disconnected"
    , sentCount = 0
    , savedConnections = Array.fromList [ getDefaultConnection ]
    , currentSavedConnectionName = "Default"
    }


getDefaultConnection : Connection
getDefaultConnection =
    Connection "Default" "127.0.0.1" 1337


getLogId : String
getLogId =
    "logs"



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewHl7Form model
        , viewFooter model
        ]


viewHl7Form : Model -> Html Msg
viewHl7Form model =
    div [ class "simple-sender" ]
        [ label [] [ text "HL7 Message" ]
        , simpleSenderButtons model
        , textarea
            [ class "hl7 form-control"
            , onInput ChangeHl7
            , rows 8
            ]
            [ text model.hl7 ]
        ]


simpleSenderButtons : Model -> Html Msg
simpleSenderButtons model =
    div [ class "float-right" ]
        [ button
            [ class "validate btn btn-sm btn-primary"
            , disabled True
            ]
            [ text "Validate" ]
        , button
            [ class "btn btn-sm btn-primary"

            -- , onClick (MsgForConnection Send)
            , disabled (model.connection.isConnected == False)
            ]
            [ text "Send" ]
        ]


viewFooter : Model -> Html Msg
viewFooter model =
    footer
        [ class "footer" ]
        [ connectionForm model
        , separator
        , viewStatus model
        ]


connectionForm : Model -> Html Msg
connectionForm model =
    div [ class "connection-row" ]
        [ div [ class "connection" ] [ viewConnectionForm model ]
        , div [ class "log" ] (viewLogs model)
        ]


separator : Html Msg
separator =
    hr [ class "connection-status-separator" ] []


viewStatus : Model -> Html Msg
viewStatus model =
    div [ class "status-row" ]
        [ label [ class "sent-count" ]
            [ text ("Sent Count: " ++ toString model.connection.sentCount) ]
        , label
            [ class ("connection-status " ++ getConnectionColor model.connection.isConnected) ]
            [ text model.connection.connectionMessage ]
        ]


getConnectionColor : Bool -> String
getConnectionColor isConnected =
    if isConnected then
        "connected"
    else
        "disconnected"


viewLogs : Model -> List (Html Msg)
viewLogs model =
    [ textarea
        [ id getLogId
        , readonly True
        , rows 5
        , class "form-control"
        ]
        [ text (getLogs model) ]
    ]


getLogs : Model -> String
getLogs model =
    List.reverse model.logs
        |> String.join "\n"


viewConnectionForm : Model -> Html Msg
viewConnectionForm model =
    div [ class "row" ]
        [ div [ class "col-8" ] (connectionFormControls model.connection)
        , div [ class "col-4" ] (connectionButtons model)
        ]


connectionFormControls : ConnectionModel -> List (Html Msg)
connectionFormControls connectionModel =
    [ formInput connectionModel "Saved" inputSavedConnections
    , formInput connectionModel "Host" inputIpAddress
    , formInput connectionModel "Port" inputPort
    ]


inputIpAddress : ConnectionModel -> Html Msg
inputIpAddress connectionModel =
    inputControl
        "Host"
        connectionModel.destinationIp
        connectionModel.isConnected
        ChangeDestinationIp


inputPort : ConnectionModel -> Html Msg
inputPort connectionModel =
    inputControl
        "Port"
        (getPortDisplay connectionModel.destinationPort)
        connectionModel.isConnected
        ChangeDestinationPort


formInput : ConnectionModel -> String -> (ConnectionModel -> Html Msg) -> Html Msg
formInput connectionModel name inputControl =
    div
        [ class "form-group row connection-input-form" ]
        [ label
            [ class "col-sm-3 col-form-label col-form-label-sm" ]
            [ text name ]
        , div
            [ class "col-9" ]
            [ inputControl connectionModel ]
        ]


inputControl : String -> String -> Bool -> (String -> Msg) -> Html Msg
inputControl inputPlaceholder getValue isConnected msg =
    input
        [ class "form-control form-control-sm"
        , placeholder inputPlaceholder
        , readonly isConnected
        , onInput msg
        , value getValue
        ]
        []


getPortDisplay : Int -> String
getPortDisplay destinationPort =
    if destinationPort == 0 then
        ""
    else
        toString destinationPort


inputSavedConnections : ConnectionModel -> Html Msg
inputSavedConnections connection =
    div []
        [ select
            [ id getSavedConnectionsId
            , class "form-control form-control-sm"

            -- , onInput (MsgForConnection << ChangeSavedConnection)
            , disabled connection.isConnected
            ]
            (Array.toList (Array.map toOptions (Array.push getCreateNewConnection connection.savedConnections)))
        ]


getCreateNewConnection : Connection
getCreateNewConnection =
    Connection "Create New" "127.0.0.1" 3000


getSavedConnectionsId : String
getSavedConnectionsId =
    "saved-connections"


toOptions : Connection -> Html msg
toOptions connection =
    option [ value connection.name ] [ text connection.name ]


connectionButtons : Model -> List (Html Msg)
connectionButtons model =
    [ button
        [ class "btn btn-sm btn-block btn-primary"

        -- , onClick (MsgForConnection ToggleConnection)
        ]
        [ text (getConnectButtonText model.connection.isConnected) ]
    , button
        [ class "clear-log btn btn-sm btn-block btn-secondary"

        -- , onClick (MsgForConnection ClearLog)
        ]
        [ text "Clear Log" ]
    , button
        [ class "save-connection btn btn-sm btn-block btn-secondary"

        -- , onClick (MsgForConnection CreateNewConnection)
        ]
        [ text "Save" ]
    ]


getConnectButtonText : Bool -> String
getConnectButtonText isConnected =
    case isConnected of
        True ->
            "Disconnect"

        False ->
            "Connect"



-- UPDATE


type Msg
    = ChangeHl7 String
    | Version String
    | ChangeDestinationIp String
    | ChangeDestinationPort String
      -- | MsgForRoute Route.Msg
      -- | MsgForSettings Settings.Msg
      -- | MsgForConnection Connection.Msg
    | NoOp


type PortValidation
    = ValidPort Int
    | EmptyPort
    | InvalidPort


type IpValidation
    = ValidIp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeHl7 hl7 ->
            ( updateHl7 model hl7, Cmd.none )

        Version version ->
            ( updateVersion model version, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        ChangeDestinationIp ipAddress ->
            ( updateIpAddress model ipAddress, Cmd.none )

        ChangeDestinationPort newPort ->
            case validatePort newPort of
                ValidPort validatedPort ->
                    ( { model
                        | connection = updatePort model.connection validatedPort
                      }
                    , Cmd.none
                    )

                EmptyPort ->
                    ( { model
                        | connection = updatePort model.connection 0
                      }
                    , Cmd.none
                    )

                InvalidPort ->
                    ( model, Cmd.none )


updateIpAddress : Model -> String -> Model
updateIpAddress model ipAddress =
    let
        connection =
            model.connection

        newConnection =
            { connection | destinationIp = ipAddress }
    in
        { model | connection = newConnection }


updatePort connection newPort =
    { connection | destinationPort = clamp 1 65535 newPort }


updateHl7 : Model -> String -> Model
updateHl7 model newHl7 =
    { model | hl7 = newHl7 }


updateVersion : Model -> String -> Model
updateVersion model version =
    { model | version = version }


log : String -> String -> Model -> ( Model, Cmd Msg )
log level message model =
    ( { model | logs = message :: model.logs }, scrollLogsToBottom )


scrollLogsToBottom : Cmd Msg
scrollLogsToBottom =
    Task.attempt (always NoOp) <| Dom.Scroll.toBottom getLogId


validateIp : String -> IpValidation
validateIp ip =
    ValidIp


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



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none -- Subs.init
        }
