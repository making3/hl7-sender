module Main exposing (..)

import About
import AddConnection
import Array exposing (Array, fromList)
import Char
import Connection
import ControlCharacters exposing (Msg)
import Dom.Scroll
import HL7
import Maybe exposing (withDefault)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Ports
import Ports.Connection
import Ports.Settings
import Settings
import Task
import TCP
import Utilities


init : ( Model, Cmd Msg )
init =
    let
        model =
            initialModel
    in
        model
            ! [ Ports.loadVersion
              , Ports.Settings.get model.settings
              , Ports.Connection.get model.savedConnections
              ]



-- MODEL


type Modal
    = None
    | ControlCharacters
    | AddConnection Connection.Model
    | About


type alias Model =
    { hl7 : String
    , logs : List String
    , settings : Settings.Model
    , modal : Modal
    , sentCount : Int
    , version : Maybe String
    , connection : Connection.Model
    , isConnected : Bool
    , savedConnections : Array Connection.Model
    }


initialModel : Model
initialModel =
    { hl7 = ""
    , logs = []
    , settings = Settings.model
    , modal = None
    , sentCount = 0
    , version = Nothing
    , connection = Connection.model
    , isConnected = False
    , savedConnections = Array.fromList [ Connection.model ]
    }


getLogId : String
getLogId =
    "logs"



-- VIEW


view : Model -> Html Msg
view model =
    case model.modal of
        ControlCharacters ->
            model.settings.controlCharacters
                |> ControlCharacters.view
                |> Html.map ControlCharactersMsg

        About ->
            model.version
                |> withDefault "N / A"
                |> About.view ExitModal

        AddConnection model ->
            model
                |> AddConnection.view
                |> Html.map AddConnectionMsg

        None ->
            viewPrimaryForm model


viewPrimaryForm : Model -> Html Msg
viewPrimaryForm model =
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
            , onClick Send
            , disabled (model.isConnected == False)
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
    let
        connectionMessage =
            case model.isConnected of
                True ->
                    "Connected"

                False ->
                    "Disconnected"
    in
        div [ class "status-row" ]
            [ label [ class "sent-count" ]
                [ text ("Sent Count: " ++ toString model.sentCount) ]
            , label
                [ class ("connection-status " ++ getConnectionColor model.isConnected) ]
                [ text connectionMessage ]
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
        [ text (model.logs |> List.reverse |> String.join "\n") ]
    ]


viewConnectionForm : Model -> Html Msg
viewConnectionForm model =
    div [ class "row" ]
        [ div [ class "col-8" ] (connectionFormControls model)
        , div [ class "col-4" ] (connectionButtons model)
        ]


connectionFormControls : Model -> List (Html Msg)
connectionFormControls model =
    [ formInput model "Saved" inputSavedConnections
    , formInput model "Host" inputIpAddress
    , formInput model "Port" inputPort
    ]


inputIpAddress : Model -> Html Msg
inputIpAddress model =
    inputControl
        "Host"
        model.connection.destinationIp
        model.isConnected
        ChangeDestinationIp


inputPort : Model -> Html Msg
inputPort model =
    inputControl
        "Port"
        (Utilities.getPortDisplay model.connection.destinationPort)
        model.isConnected
        ChangeDestinationPort


formInput : Model -> String -> (Model -> Html Msg) -> Html Msg
formInput model name inputControl =
    div
        [ class "form-group row connection-input-form" ]
        [ label
            [ class "col-sm-3 col-form-label col-form-label-sm" ]
            [ text name ]
        , div
            [ class "col-9" ]
            [ inputControl model ]
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


inputSavedConnections : Model -> Html Msg
inputSavedConnections model =
    let
        connections =
            model.savedConnections
                |> Array.push getCreateNewConnection
                |> Array.map (toConnectionOptions model.connection.name)
                |> Array.toList
    in
        div []
            [ select
                [ id getSavedConnectionsId
                , class "form-control form-control-sm"
                , onInput ChangeSavedConnection
                , disabled model.isConnected
                ]
                connections
            ]


getCreateNewConnection : Connection.Model
getCreateNewConnection =
    Connection.Model "Create New" "127.0.0.1" 3000


getSavedConnectionsId : String
getSavedConnectionsId =
    "saved-connections"


toConnectionOptions : String -> Connection.Model -> Html msg
toConnectionOptions currentSavedConnectionName connection =
    let
        isSelected =
            currentSavedConnectionName == connection.name
    in
        option [ selected isSelected, value connection.name ] [ text connection.name ]


connectionButtons : Model -> List (Html Msg)
connectionButtons model =
    [ button
        [ class "btn btn-sm btn-block btn-primary"
        , onClick ToggleConnection
        ]
        [ text (getConnectButtonText model.isConnected) ]
    , button
        [ class "clear-log btn btn-sm btn-block btn-secondary"
        , onClick ClearLog
        ]
        [ text "Clear Log" ]
    , button
        [ class "save-connection btn btn-sm btn-block btn-secondary"
        , onClick SaveConnection
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
    | ToggleConnection
    | Connected
    | Disconnected
    | ConnectionError String
    | ClearLog
    | Send
    | Sent
    | MenuClick String
    | ExitModal
    | NoOp
    | InitialSettings ( String, String )
    | Saved String
    | ChangeSavedConnection String
    | ControlCharactersMsg ControlCharacters.Msg
    | AddConnectionMsg AddConnection.Msg
    | InitialSavedConnections ( String, String )
    | SavedNewConnection String
    | SaveConnection
    | SavedConnection String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Saved errorMessage ->
            if errorMessage == "" then
                log "info" "Saved settings" model
            else
                log "error" errorMessage model

        ChangeHl7 hl7 ->
            ( updateHl7 model hl7, Cmd.none )

        Version version ->
            ( updateVersion model version, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        ChangeDestinationIp ipAddress ->
            ( updateIpAddress model ipAddress, Cmd.none )

        ChangeDestinationPort newPort ->
            ( changeDestinationPort model newPort, Cmd.none )

        ToggleConnection ->
            updateToggleConnection model

        Connected ->
            { model | isConnected = True }
                |> log "info" "Connected"

        Disconnected ->
            { model | isConnected = False }
                |> log "info" "Disconnected"

        ConnectionError errorMsg ->
            { model | isConnected = False }
                |> log "error" errorMsg

        ClearLog ->
            ( { model | logs = [] }, Cmd.none )

        Send ->
            ( model, Ports.send (HL7.getWrappedHl7 model.settings.controlCharacters model.hl7) )

        Sent ->
            updateSentCount model
                |> log "info" "Sent a message"

        MenuClick menuItem ->
            menuClickOption menuItem model

        ExitModal ->
            { model | modal = None } ! []

        InitialSettings ( error, settingsJson ) ->
            case error of
                "" ->
                    case Settings.toModel settingsJson of
                        Ok settings ->
                            let
                                newControlCharacters =
                                    ControlCharacters.resetTempCharacters settings.controlCharacters

                                newSettings =
                                    { settings | controlCharacters = newControlCharacters }
                            in
                                ( { model | settings = newSettings }, Cmd.none )

                        Err errorMessage ->
                            log "error" errorMessage model

                errorMessage ->
                    log "error" errorMessage model

        ChangeSavedConnection connectionName ->
            changeConnectionFromSaved connectionName model ! []

        InitialSavedConnections ( "", savedConnectionsJson ) ->
            updateInitialSavedConnections model savedConnectionsJson

        InitialSavedConnections ( errorMessage, savedConnectionsJson ) ->
            log "error" errorMessage model

        SavedNewConnection "" ->
            case model.modal of
                AddConnection subModel ->
                    model
                        |> addNewConnection subModel
                        |> logSavedConnection

                _ ->
                    model ! []

        SavedNewConnection errorMessage ->
            log "error" ("Failed to save message" ++ errorMessage) model

        SaveConnection ->
            let
                connection =
                    { name = model.connection.name
                    , destinationIp = model.connection.destinationIp
                    , destinationPort = model.connection.destinationPort
                    }
            in
                ( model, Ports.Connection.saveConnection connection )

        SavedConnection "" ->
            model
                |> updateSavedConnectionsWithCurrent
                |> logSavedConnection

        SavedConnection errorMessage ->
            log "error" ("Failed to save message" ++ errorMessage) model

        _ ->
            updateModal msg model


addNewConnection : Connection.Model -> Model -> Model
addNewConnection newConnectionModel model =
    let
        newSavedConnections =
            model.savedConnections
                |> Array.push newConnectionModel

        newModel =
            { model
                | savedConnections = newSavedConnections
                , modal = None
            }
    in
        newConnectionModel
            |> updateCurrentConnection newModel
            |> changeConnectionFromSaved newConnectionModel.name


updateSavedConnectionsWithCurrent : Model -> Model
updateSavedConnectionsWithCurrent model =
    let
        newSavedConnections =
            Connection.updateSavedConnections
                model.savedConnections
                model.connection.name
                model.connection.destinationIp
                model.connection.destinationPort
    in
        { model | savedConnections = newSavedConnections }


logSavedConnection : Model -> ( Model, Cmd Msg )
logSavedConnection model =
    log "info" "Saved Connection!" model


updateInitialSavedConnections : Model -> String -> ( Model, Cmd Msg )
updateInitialSavedConnections model savedConnectionsJson =
    case Connection.toSavedConnectionsModels savedConnectionsJson of
        Ok savedConnections ->
            let
                newModel =
                    { model | savedConnections = savedConnections }

                defaultConnectionName =
                    Connection.getInitialConnectionName newModel.savedConnections
            in
                ( changeConnectionFromSaved defaultConnectionName newModel, Cmd.none )

        Err errorMessage ->
            log "error" errorMessage model


changeConnectionFromSaved : String -> Model -> Model
changeConnectionFromSaved connectionName model =
    case connectionName of
        "Create New" ->
            { model | modal = AddConnection AddConnection.init }

        _ ->
            case Connection.findConnectionByName model.savedConnections connectionName of
                Nothing ->
                    model

                Just newConnection ->
                    updateCurrentConnection model newConnection


updateCurrentConnection : Model -> Connection.Model -> Model
updateCurrentConnection model newConnection =
    { model | connection = newConnection }


updateModal : Msg -> Model -> ( Model, Cmd Msg )
updateModal msg model =
    case ( msg, model.modal ) of
        ( ControlCharactersMsg subMsg, ControlCharacters ) ->
            let
                ( subModel, subCmd ) =
                    ControlCharacters.update subMsg model.settings.controlCharacters

                oldSettings =
                    model.settings

                newSettings =
                    { oldSettings | controlCharacters = subModel }

                newModel =
                    { model | settings = newSettings }
            in
                case subMsg of
                    ControlCharacters.SaveControlCharacters ->
                        ( newModel, Ports.Settings.save newModel.settings )

                    ControlCharacters.Exit ->
                        { newModel | modal = None } ! []

                    _ ->
                        newModel ! []

        ( AddConnectionMsg subMsg, AddConnection subModel ) ->
            let
                ( newSubModel, subCmd ) =
                    AddConnection.update subMsg subModel

                newModal =
                    AddConnection newSubModel

                newModel =
                    { model | modal = newModal }
            in
                case subMsg of
                    AddConnection.Exit ->
                        { model | modal = None } ! []

                    AddConnection.SaveConnection ->
                        ( newModel, Ports.Connection.saveConnection newSubModel )

                    _ ->
                        newModel ! []

        ( _, _ ) ->
            model ! []


updateIpAddress : Model -> String -> Model
updateIpAddress model ipAddress =
    let
        connection =
            model.connection

        newConnection =
            { connection | destinationIp = ipAddress }
    in
        { model | connection = newConnection }


changeDestinationPort : Model -> String -> Model
changeDestinationPort model newPort =
    case TCP.validatePort newPort of
        TCP.ValidPort validatedPort ->
            { model | connection = updatePort model.connection validatedPort }

        TCP.EmptyPort ->
            { model | connection = updatePort model.connection 0 }

        TCP.InvalidPort ->
            model


updatePort connection newPort =
    { connection | destinationPort = clamp 1 65535 newPort }


updateToggleConnection : Model -> ( Model, Cmd Msg )
updateToggleConnection model =
    case model.isConnected of
        False ->
            ( model
            , Ports.connect
                ( model.connection.destinationIp
                , model.connection.destinationPort
                )
            )

        True ->
            ( model
            , Ports.disconnect ()
            )


updateHl7 : Model -> String -> Model
updateHl7 model newHl7 =
    { model | hl7 = newHl7 }


updateVersion : Model -> String -> Model
updateVersion model version =
    { model | version = Just version }


log : String -> String -> Model -> ( Model, Cmd Msg )
log level message model =
    ( { model | logs = message :: model.logs }, scrollLogsToBottom )


scrollLogsToBottom : Cmd Msg
scrollLogsToBottom =
    Task.attempt (always NoOp) <| Dom.Scroll.toBottom getLogId


updateSentCount : Model -> Model
updateSentCount model =
    { model | sentCount = model.sentCount + 1 }


menuClickOption : String -> Model -> ( Model, Cmd Msg )
menuClickOption menuItem model =
    case menuItem of
        "about" ->
            { model | modal = About } ! []

        "edit-control-characters" ->
            { model | modal = ControlCharacters } ! []

        _ ->
            model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.menuClick MenuClick
        , Ports.settings InitialSettings
        , Ports.settingsSaved Saved
        , Ports.connected (always Connected)
        , Ports.disconnected (always Disconnected)
        , Ports.connectionError ConnectionError
        , Ports.sent (always Sent)
        , Ports.version Version
        , Ports.savedConnection SavedConnection
        , Ports.savedNewConnection SavedNewConnection
        , Ports.initialSavedConnections InitialSavedConnections
        ]



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
